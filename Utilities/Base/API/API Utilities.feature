###########################################################
# Copyright 2020, Tryon Solutions, Inc.
# All rights reserved.  Proprietary and confidential.
#
# This file is subject to the license terms found at 
# https://www.cycleautomation.com/end-user-license-agreement/
#
# The methods and techniques described herein are considered
# confidential and/or trade secrets. 
# No part of this file may be copied, modified, propagated,
# or distributed except as authorized by the license.
############################################################ 
# Utility: API Utilities.feature
# 
# Functional Area: API
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: API
#
# Description:
# This utility contains scenarios to facilitate interaction with
# the Blue Yonder APIs
#
# Public Scenarios:  
# 	- API Request - A generic helper scenario that handles all API requests to the BY API
# 	- API Build Simple JSON Object - Build a simple, flat JSON object using the specified variable names
# 	- API Build Complex JSON Object - Build a complex JSON object using variable replacement/expansion
# 	- API Generate Resource ID - Generates a Blue Yonder Resource ID by converting a flat JSON object to Base64
# 	- API Generate Query String - Generates a properly-formatted and properly-escaped URL query string
# 	- API Find Value in JSON Array - Searches a JSON array for a specific value
# 	- API Validate Required Arguments - Validates that the specified variables are populated
# 	- API Translate Variable Names - Translates DB field names to API field names
# 	- API Retrieve Values from JSON Path - Retrieves values from a JSON object and translates API field names back to DB field names
# 	- API Process Optional Arguments - Scans a comma-separated list, validates the variables are populated, then translates them to API field names
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: API Utilities

@wip @public
Scenario: API Request
#############################################################
# Description: This scenario performs the desired HTTP request
# 	after performing and/or validating authentication
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		api_method - HTTP method to use (GET, POST, PUT, PATCH, DELETE)
# 		api_endpoint - Endpoint to query
# 	Optional:
# 		api_parameters - Comma-separated list of request parameters
# 			(for GET or DELETE)
# 		request_json - JSON message to include in the request body
# 			(for POST, PUT, PATCH)
# Outputs:
# 	response_json - The JSON HTTP response
#############################################################

Given I "validate input arguments"
	When I assign "api_method,api_endpoint" to variable "required_args"
	Then I execute scenario "API Validate Required Arguments"

	If I verify variable "request_json" is assigned
	And I verify text $request_json is not equal to ""
	Else I "ensure request_json parameter is included with POST/PUT/PATCH operations"
		If I verify text $api_method is equal to "POST"
			Then I fail step with error message "ERROR: request_json must be specified for POST operations"
		ElsIf I verify text $api_method is equal to "PUT"
			Then I fail step with error message "ERROR: request_json must be specified for PUT operations"
		ElsIf I verify text $api_method is equal to "PATCH"
			Then I fail step with error message "ERROR: request_json must be specified for PATCH operations"
		EndIf
	EndIf

And I "set up local variables"
	# We need to set the HTTP base URL before authentication, just in case someone
	# makes a one-off HTTP request and changes the base URL on us
	Given I set $api_base_url as my http base url
	And I assign $api_tracing to variable "X-Session-Trace"
	And I assign "Cookie,X-Session-Trace" to variable "http_headers"
	And I assign "api_method,api_endpoint" to variable "variables_to_unassign"

	# Since not all of the Cycle HTTP steps support parameters natively, we'll append the
	# parameters to the end of the URL in the format of a query string
	If I verify variable "api_parameters" is assigned
	And I verify text $api_parameters is not equal to ""
	Then I "append the parameters to the URL"
		Given I assign $api_parameters to variable "columns"
		When I execute scenario "API Generate Query String"
		Then I assign variable "api_endpoint" by combining $api_endpoint "?" $query_string
		And I assign variable "variables_to_unassign" by combining $variables_to_unassign ",api_parameters"
	EndIf

And I "validate authentication"
	If I execute scenario "API Authenticate"
	Else I fail step with error message "ERROR: API authentication failed"
	EndIf

When I "execute HTTP request"
	Given I assign $api_cookie to variable "Cookie"
	If I verify text $api_method is equal to "GET"
		Then I http GET JSON from $api_endpoint with headers $http_headers
	ElsIf I verify text $api_method is equal to "PUT"
		Then I http PUT JSON to $api_endpoint $request_json with headers $http_headers
		And I assign variable "variables_to_unassign" by combining $variables_to_unassign ",request_json"
	ElsIf I verify text $api_method is equal to "PATCH"
		Then I http PATCH JSON to $api_endpoint $request_json with headers $http_headers
		And I assign variable "variables_to_unassign" by combining $variables_to_unassign ",request_json"
	ElsIf I verify text $api_method is equal to "DELETE"
		Then I http DELETE from $api_endpoint with headers $http_headers
	ElsIf I verify text $api_method is equal to "POST"
		Then I http POST JSON to $api_endpoint $request_json with headers $http_headers
		And I assign variable "variables_to_unassign" by combining $variables_to_unassign ",request_json"
	Else I fail step with error message "ERROR: Invalid value for api_method (must be GET|POST|PUT|PATCH|DELETE)"
	EndIf

Then I "validate the request"
	Given I assign http response body to variable "response_json"
	And I assign http response status code to variable "response_code"
	And I echo $response_code $response_json

And I "attempt to parse error codes and messages from JSON response"
	If I verify number $response_code is not equal to $http_status_ok
		If I assign value from json $response_json with path "/errors[0]/errorCode" to variable "error_code"
		And I assign value from json $response_json with path "/errors[0]/userMessage" to variable "error_message"
		EndIf
	EndIf

And I "unassign variables and return"
	Given I unassign variables $variables_to_unassign
	And I verify number $response_code is equal to $http_status_ok

@wip @private
Scenario: API Authenticate
#############################################################
# Description: This scenario attempts to authenticate against the
# 	authentication endpoint using the supplied username and
# 	password. If authentication is successful, then the resulting
# 	session cookie will be stored for subsequent API calls. If
# 	authentication fails, an error is thrown.
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		api_username - Username
# 		api_password - Password
# 	Optional:
# 		None
# Outputs:
# 	api_cookie - The session cookie
#############################################################

If I verify variable "api_cookie" is assigned
Else I "authenticate to Blue Yonder API"
	Given I assign $api_username to variable "usr_id"
	And I assign $api_password to variable "password"
	And I assign "usr_id,password" to variable "columns"
	When I execute scenario "API Build Simple JSON Object"
	Then I http post JSON to "/ws/auth/login" $json_string
	If I verify http response had status code $http_status_unauthorized
		Then I fail step with error message "ERROR: Invalid username/password"
	ElsIf I verify http response had status code $http_status_ok
		Then I assign http response header "Set-Cookie" to variable "api_cookie"
	Else I fail step with error message "ERROR: Unexpected error occurred during authentication"
	EndIf
EndIf

@wip @public
Scenario: API Build Simple JSON Object
#############################################################
# Description: 
# 	Builds a simple JSON object using the variables specified
# 	in the "columns" parameter. It is not capable of producing
# 	arrays or nested JSON objects. Also, it treats all values
# 	as Strings
# Groovy Files: 
# 	build_simple_json_object.groovy
# Inputs:
# 	Required:
# 		columns - Comma-separated list of column names
# 	Optional:
# 		None
# Outputs:
# 	json_string - JSON string
#############################################################

Given I "validate input arguments"
	When I assign "columns" to variable "required_args"
	Then I execute scenario "API Validate Required Arguments"

When I "execute the Groovy script"
	When I assign "build_simple_json_object.groovy" to variable "groovy_file"
	Then I execute scenario "Perform Groovy Execution"

Then I "validate the output of the Groovy script"
	If I verify variable "json_string" is assigned
	And I verify text $json_string is not equal to ""
	Else I fail step with error message "ERROR: Simple JSON object was blank"
	EndIf

@wip @public
Scenario: API Build Complex JSON Object
#############################################################
# Description: 
# 	Builds a complex JSON object using the structure specified
# 	in the "structure" parameter. Variables are prefixed by @
# 	and will be interpolated automatically
# Groovy Files: 
# 	build_complex_json_object.groovy
# Inputs:
# 	Required:
# 		structure - The structure of the JSON object. See
# 			Groovy script for a more detailed explanation
# 	Optional:
# 		None
# Outputs:
# 	json_string - JSON string
#############################################################

Given I "validate input arguments"
	When I assign "structure" to variable "required_args"
	Then I execute scenario "API Validate Required Arguments"

When I "execute the Groovy script"
	When I assign "build_complex_json_object.groovy" to variable "groovy_file"
	Then I execute scenario "Perform Groovy Execution"

Then I "validate the output of the Groovy script"
	If I verify variable "json_string" is assigned
	And I verify text $json_string is not equal to ""
	Else I fail step with error message "ERROR: Complex JSON object was blank"
	EndIf

@wip @public
Scenario: API Generate Resource ID
#############################################################
# Description: 
# 	Generates a Blue Yonder resource ID based on a list of
# 	variables and their values. Resulting value can be used to
# 	uniquely identify resources in the Public API.
# Groovy Files: 
# 	base64_encode.groovy
# Inputs:
# 	Required:
# 		columns - Comma-separated list of column names
# 	Optional:
# 		None
# Outputs:
# 	resource_id - Resource ID
#############################################################

Given I "validate input arguments and build the JSON representation of the Resource ID"
	Given I execute scenario "API Build Simple JSON Object"

When I "execute the Groovy script"
	When I assign "base64_encode.groovy" to variable "groovy_file"
	And I assign $json_string to variable "input_string"
	Then I execute scenario "Perform Groovy Execution"
	And I assign $output_string to variable "resource_id"

Then I "validate the output of the Groovy script"
	If I verify variable "resource_id" is assigned
	And I verify text $resource_id is not equal to ""
	Else I fail step with error message "ERROR: Resource ID was blank"
	EndIf

@wip @public
Scenario: API Generate Query String
#############################################################
# Description: 
#  Generates a properly-formatted, URL-encoded query string
# Groovy Files: 
#	generate_query_string.groovy
# Inputs:
#	Required:
# 		columns - Comma-separated list of column names
# 	Optional:
# 		None
# Outputs:
# 	query_string - Query String
#############################################################

Given I "validate input arguments"
	When I assign "columns" to variable "required_args"
	Then I execute scenario "API Validate Required Arguments"

When I "execute the Groovy script"
	When I assign "generate_query_string.groovy" to variable "groovy_file"
	Then I execute scenario "Perform Groovy Execution"

Then I "validate the output of the Groovy script"
	If I verify variable "query_string" is assigned
	And I verify text $query_string is not equal to ""
	Else I fail step with error message "ERROR: Query String was blank"
	EndIf

@wip @public
Scenario: API Find Value in JSON Array
#############################################################
# Description: Searches a JSON array for a specific value
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		json - The JSON object to search
# 		array_path - The JSONPath of the array
# 		validation_paths - Comma-separated list of JSONPaths (relative to the array) to validate
# 		validation_values - Comma-separated list of values (relative to validation_paths) to match against
# 	Optional:
# 		None
# Outputs:
# 	result_path - The JSONPath of the value that matched the criteria
#############################################################

Given I "scan the JSON object for an index that matches the criteria"
	Given I assign count of elements from json $json with path $array_path to variable "array_count"
	And I assign 0 to variable "loop_index"
	And I assign -1 to variable "found_index"
	While I verify number $loop_index is less than $array_count
	And I verify number $found_index is less than 0
		Then I assign 1 to variable "validation_count"
		And I assign "TRUE" to variable "is_match"
		While I assign $validation_count th item from "," delimited list $validation_paths to variable "validation_path"
		And I assign $validation_count th item from "," delimited list $validation_values to variable "validation_value"
		And I verify text $is_match is equal to "TRUE"
			Then I assign variable "full_validation_path" by combining $array_path "[" $loop_index "]/" $validation_path
			Given I echo $full_validation_path
			Given I assign value from JSON $json with path $full_validation_path to variable "current_value"
			If I verify text $current_value is equal to $validation_value
			Else I assign "FALSE" to variable "is_match"
			EndIf

			Then I increase variable "validation_count" by 1
		EndWhile

		If I verify text $is_match is equal to "TRUE"
			Then I assign $loop_index to variable "found_index"
		EndIf

		Then I increase variable "loop_index" by 1
	EndWhile
	
	If I verify number $found_index is less than 0
		Then I fail step with error message "ERROR: Match not found"
	Else I "return the path of the match"
		Then I assign variable "result_path" by combining $array_path "[" $found_index "]/"
	EndIf

@wip @public
Scenario: API Validate Required Arguments
#############################################################
# Description: Validates that the specified variables are populated
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		required_args - Comma-separated list of variables that are required.
# 			Error will be thrown if one of the corresponding variables is
# 			unassigned or empty
# 	Optional:
# 		None
# Outputs:
# 	None
#############################################################

Given I "verify the variables in required_args are populated"
	If I verify variable "required_args" is assigned
	And I verify text $required_args is not equal to ""
		Then I assign 1 to variable "array_index"
		While I assign $array_index th item from "," delimited list $required_args to variable "variable_name"
			If I verify variable $variable_name is assigned
			And I assign contents of variable $variable_name to "variable_value"
			And I verify text $variable_value is not equal to ""
			Else I "raise an exception"
				Given I assign variable "error_message" by combining "ERROR: Missing argument " $variable_name
				Then I fail step with error message $error_message
			EndIf

			Then I increase variable "array_index" by 1
		EndWhile
	Else I fail step with error message "ERROR: Missing argument required_args"
	EndIf

@wip @public
Scenario: API Translate Variable Names
#############################################################
# Description: Translates DB field names to API field names
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		None
# 	Optional:
# 		None
# Outputs:
# 	Varies
#############################################################

Given I "verify that the API mappings file has been located"
	If I verify variable "api_field_mapping_file" is assigned
	And I verify text $api_field_mapping_file is not equal to ""
	Else I fail step with error message "ERROR: API mappings file not found"
	EndIf

Then I "translate DB field names to API field names"
	Given I reset line counter for $api_field_mapping_file
	While I assign values in next row from $api_field_mapping_file to variables
		If I verify variable $db_field is assigned
			Then I assign contents of variable $db_field to $api_field
		EndIf
	EndWhile

@wip @public
Scenario: API Retrieve Values from JSON Path
#############################################################
# Description: Retrieves values from a JSON object and translates
# 	API field names back to DB field names
# MSQL Files:
# 	None
# Inputs:
# 	Required:
# 		json - the JSON object
# 		json_path - the path within the JSON object
# 		return_fields - comma-separated list of fields to retrieve
# 	Optional:
# 		None
# Outputs:
# 	Varies
#############################################################

Given I "verify that the API mappings file has been located"
	If I verify variable "api_field_mapping_file" is assigned
	And I verify text $api_field_mapping_file is not equal to ""
	Else I fail step with error message "ERROR: API mappings file not found"
	EndIf

And I "validate input arguments"
	When I assign "json,json_path,return_fields" to variable "required_args"
	Then I execute scenario "API Validate Required Arguments"

Then I "translate DB field names to API field names"
	Given I assign 1 to variable "field_index"
	While I assign $field_index th item from "," delimited list $return_fields to variable "db_field_name"
		Given I assign variable "mapping_name" by combining "api_var_map_" $db_field_name
		If I verify variable $mapping_name is assigned
		Else I "throw a meaningful error message"
			Given I assign variable "error_message" by combining "ERROR: No mapping exists for DB field " $db_field_name
			And I fail step with error message $error_message
		EndIf

		Given I assign contents of variable $mapping_name to "api_variable_name"
		And I assign variable "field_json_path" by combining $json_path "/" $api_variable_name
		When I assign value from JSON $json with path $field_json_path to variable "json_value"
		If I verify text $json_value is not equal to "null"
			Then I assign $json_value to variable $db_field_name
		EndIf

		Then I increase variable "field_index" by 1
	EndWhile

@wip @public
Scenario: API Process Optional Arguments
#############################################################
# Description: Scans a list of optional arguments (using DB field
# 	names) to see which ones have values, then builds appends to
# 	$api_parameters (using API field names)
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		arg_list - Comma-separated list of optional arguments to scan
# 	Optional:
# 		None
# Outputs:
# 	api_parameters - Comma-separated list of API field names
#############################################################

Given I "initialize the necessary variables"
	If I verify variable "api_parameters" is assigned
	Else I assign "" to variable "api_parameters"
	EndIf
	Given I assign 1 to variable "array_index"

When I "loop through the argument list, I check each DB field to see if it's populated, and if so, I append the corresponding API field name to api_parameters"
	While I assign $array_index th item from "," delimited list $arg_list to variable "variable_name"
		If I verify variable $variable_name is assigned
		And I assign contents of variable $variable_name to "variable_value"
		And I verify text $variable_value is not equal to ""
			# DB field has a value, let's see if we can find a DB-to-API mapping
			Then I assign variable "api_var_map_name" by combining "api_var_map_" $variable_name
			If I verify variable $api_var_map_name is assigned
			And I verify text $api_var_map_name is not equal to ""
			Else I "generate an appropriate error message"
				Given I assign variable "error_message" by combining "ERROR: Auto mapping failed for variable " $variable_name
				And I fail step with error message $error_message
			EndIf

			# Mapping found, append the API field name to $api_parameters
			When I assign contents of variable $api_var_map_name to "api_var_map_value"
			If I verify text $api_parameters is equal to ""
				Then I assign $api_var_map_value to variable "api_parameters"
			Else I assign variable "api_parameters" by combining $api_parameters "," $api_var_map_value
			EndIf
		EndIf

		Then I increase variable "array_index" by 1
	EndWhile

Then I "echo the result"
	Given I echo $api_parameters