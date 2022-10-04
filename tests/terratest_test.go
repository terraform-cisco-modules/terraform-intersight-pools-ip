package test

import (
	"fmt"
	"os"
	"testing"

	iassert "github.com/cgascoig/intersight-simple-go/assert"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestFull(t *testing.T) {
	//========================================================================
	// Setup Terraform options
	//========================================================================

	// Generate a unique name for objects created in this test to ensure we don't
	// have collisions with stale objects
	uniqueId := random.UniqueId()
	instanceName := fmt.Sprintf("test-pools-ip-%s", uniqueId)

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
	// Make Intersight API call(s) to validate module worked
	//========================================================================

	// Setup the expected values of the returned MO.
	// This is a Go template for the JSON object, so template variables can be used
	expectedJSONTemplate := `
{
	"AssignmentOrder": "sequential",
	"Name":        "{{ .name }}",
	"Description": "{{ .name }} IP Pool.",
	"IpV4Blocks": [
		{
			"ClassId":    "ippool.IpV4Block",
			"ObjectType": "ippool.IpV4Block",
			"From":       "198.18.0.10",
			"Size":       240, 
			"To":         "198.18.0.249"
		}
	],
	"IpV4Config": {
		"ClassId":      "ippool.IpV4Config",
		"ObjectType":   "ippool.IpV4Config",
		"Gateway":      "198.18.0.1",
		"Netmask":      "255.255.255.0",
		"PrimaryDns":   "208.67.220.220",
		"SecondaryDns": "208.67.222.222"
	},
	"IpV6Blocks": [
		{
			"ClassId":    "ippool.IpV6Block",
			"ObjectType": "ippool.IpV6Block",
			"From":       "2001:db8::10",
			"Size":       1000,
			"To":         "2001:DB8::3F7"
		}
	],
	"IpV6Config": {
		"ClassId":      "ippool.IpV6Config",
		"ObjectType":   "ippool.IpV6Config",
		"Gateway":      "2001:db8::1",
		"Prefix":       64,
		"PrimaryDns":   "2620:119:53::53",
		"SecondaryDns": "2620:119:35::35"
	}
}
`
	// Validate that what is in the Intersight API matches the expected
	// The AssertMOComply function only checks that what is expected is in the result. Extra fields in the
	// result are ignored. This means we don't have to worry about things that aren't known in advance (e.g.
	// Moids, timestamps, etc)
	iassert.AssertMOComply(t, fmt.Sprintf("/api/v1/ippool/Pools/%s", moid), expectedJSONTemplate, vars)
}
