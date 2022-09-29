package test

import (
	"fmt"
	"os"
	"testing"

	intersight "github.com/cgascoig/intersight-simple-go/client"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/maxatome/go-testdeep/td"
	"github.com/stretchr/testify/assert"
)

func TestFull(t *testing.T) {
	//========================================================================
	// Setup Terraform options
	//========================================================================

	// Generate a unique name for objects created in this test to ensure we don't
	// have collisions with stale objects
	uniqueId := random.UniqueId()
	instanceName := fmt.Sprintf("test_pools_ip-%s", uniqueId)

	// Input variables for the TF module
	vars := map[string]interface{}{
		"intersight_keyid":         os.Getenv("IS_KEYID"),
		"intersight_secretkeyfile": os.Getenv("IS_KEYFILE"),
		"name":                     instanceName,
	}

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./full",
		Vars:         vars,
	})

	//========================================================================
	// Init and apply terraform module
	//========================================================================
	defer terraform.Destroy(t, terraformOptions) // defer to ensure that TF destroy happens automatically after tests are completed
	terraform.InitAndApply(t, terraformOptions)
	moid := terraform.Output(t, terraformOptions, "moid")
	assert.NotEmpty(t, moid, "TF module moid output should not be empty")

	//========================================================================
	// Make Intersight API calls to validate module worked
	//========================================================================
	client, err := intersight.NewClient(intersight.Config{
		KeyID:   os.Getenv("IS_KEYID"),
		KeyFile: os.Getenv("IS_KEYFILE"),
	})
	assert.NoError(t, err)
	assert.NotNil(t, client)

	// Get the created MO
	res, err := client.Get(fmt.Sprintf("/api/v1/ippool/Pools/%s", moid))
	assert.NoError(t, err, "MOID should exist")
	assert.NotNil(t, res, "MOID should exist")

	// Setup the expected values of the returned MO. We will use td.CmpSuperMapOf which will ignore any fields
	// in the result that aren't included here.
	// Note: td.CmpSuperMapOf only compares non-zero valued fields in the "expected" map, so take care to not
	// add fields with 0, "", etc values.
	// See https://pkg.go.dev/github.com/maxatome/go-testdeep/td#SubMapOf
	expected := map[string]interface{}{
		"Name":        instanceName,
		"Description": "Demo IP Pool",

		"AssignmentOrder": "sequential",
		"IpV4Blocks": []interface{}{
			map[string]interface{}{
				"ClassId":    "ippool.IpV4Block",
				"ObjectType": "ippool.IpV4Block",
				"From":       "198.18.0.10",
				"Size":       float64(240), //these are float64 because JSON only has a single Number type which always unmarshal to float64
				"To":         "198.18.0.249",
			},
		},
		"IpV4Config": map[string]interface{}{
			"ClassId":      "ippool.IpV4Config",
			"ObjectType":   "ippool.IpV4Config",
			"Gateway":      "198.18.0.1",
			"Netmask":      "255.255.255.0",
			"PrimaryDns":   "208.67.220.220",
			"SecondaryDns": "208.67.222.222",
		},
		"IpV6Blocks": []interface{}{
			map[string]interface{}{
				"ClassId":    "ippool.IpV6Block",
				"ObjectType": "ippool.IpV6Block",
				"From":       "2001:db8::10",
				"Size":       float64(1000),
				"To":         "2001:DB8::3F7",
			},
		},
		"IpV6Config": map[string]interface{}{
			"ClassId":      "ippool.IpV6Config",
			"ObjectType":   "ippool.IpV6Config",
			"Gateway":      "2001:db8::1",
			"Prefix":       float64(64),
			"PrimaryDns":   "2620:119:53::53",
			"SecondaryDns": "2620:119:35::35",
		},
	}

	if td.CmpNoError(t, err) {
		td.CmpSuperMapOf(t, res, expected, nil)
	}
}
