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
# Utility: API Yard Utilities.feature
# 
# Functional Area: Yard
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: API
#
# Description:
# This utility contains scenarios to facilitate interaction with
# the Yard endpoints in the Blue Yonder API
#
# Public Scenarios:
# 	- API List Transport Equipment - List Transport Equipment matching criteria
# 	- API Get Transport Equipment ID - Returns the unique identifier of a Transport Equipment based on the criteria
# 	- API Check In Transport Equipment - Check in transport equipment by ID
# 	- API Close Transport Equipment - Close transport equipment by ID
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: API Yard Utilities

@wip @public
Scenario: API List Transport Equipment
#############################################################
# Description: This scenario lists transport equipment matching
# 	the criteria
# MSQL Files:
# 	None
# Inputs:
# 	Required:
# 		None
# 	Optional:
# 		carcod - Carrier
# 		trlr_id - Transport Equipment ID
# 		trlr_num - Transport Equipment Number
# Outputs:
# 	None
#############################################################

Given I execute scenario "Public API List Transport Equipment"

@wip @public
Scenario: API Get Transport Equipment ID
#############################################################
# Description: Returns the unique identifier of a Transport
# 	Equipment based on the criteria. If the criteria is too
# 	generic and multiple options are returned, an error is
# 	thrown
# MSQL Files:
# 	None
# Inputs:
# 	Required:
# 		None
# 	Optional:
# 		carcod - Carrier
# 		trlr_id - Transport Equipment ID
# 		trlr_num - Transport Equipment Number
# Outputs:
# 	trlr_id - Transport Equipment ID
# 	trlr_num - Transport Equipment Number
# 	carcod - Carrier Code
# 	trlr_stat - Transport Equipment Status
# 	trlr_cod - Transport Equipment Type (SHIPPING or RECEIVING_EQUIPMENT_TYPE)
#############################################################

Given I execute scenario "API List Transport Equipment"

When I "verify only 1 result was found"
	If I verify count of elements from JSON $response_json with path "/transportEquipment" is equal to 1
	Else I fail step with error message "ERROR: Multiple Transport Equipments found with specified criteria. Please make criteria more specific"
	EndIf

Then I "populate the transport equipment ID and other fields"
	Given I assign $response_json to variable "json"
	And I assign "/transportEquipment[0]" to variable "json_path"
	And I assign "trlr_id,trlr_num,carcod,trlr_stat,trlr_cod" to variable "return_fields"
	# Due to current architecture, we don't want to overwrite the "status" variable using a fixed variable mapping, so we'll add it temporarily
	And I assign "status" to variable "api_var_map_trlr_stat"
	When I execute scenario "API Retrieve Values from JSON Path"
	Then I verify variable "trlr_id" is assigned
	And I verify text $trlr_id is not equal to ""
	And I unassign variable "api_var_map_trlr_stat"

@wip @public
Scenario: API Check In Transport Equipment
#############################################################
# Description: This scenario checks in a transport equipment
# 	(referenced by the ID) using the specified dock door
# MSQL Files:
# 	None
# Inputs:
# 	Required:
# 		trlr_id - Transport Equipment ID
# 		wh_id - Warehouse ID
# 		yard_loc - Dock Door
# 	Optional:
# 		None
# Outputs:
# 	None
#############################################################

Given I execute scenario "Public API Check In Transport Equipment"

@wip @public
Scenario: API Close Transport Equipment
#############################################################
# Description: This scenario closes transport equipment by ID
# MSQL Files:
# 	None
# Inputs:
# 	Required:
# 		trlr_id - Transport Equipment ID
# 	Optional:
# 		None
# Outputs:
# 	None
#############################################################

Given I execute scenario "Public API Close Transport Equipment"

#############################################################
# Private Scenarios:
# 	- Public API List Transport Equipment
# 	- Private API List Transport Equipment
# 	- Public API Check In Transport Equipment
# 	- Private API Check In Transport Equipment
# 	- Public API Close Transport Equipment
# 	- Private API Close Transport Equipment
#############################################################

@wip @private
Scenario: Public API List Transport Equipment
#############################################################
# Description: This scenario lists transport equipment using
# 	the Blue Yonder Public API
# API Endpoints:
# 	/api/yard/v1beta/transportEquipment
# Inputs:
# 	Required:
# 		None
# 	Optional:
# 		carcod - Carrier
# 		trlr_id - Transport Equipment ID
# 		trlr_num - Transport Equipment Number
# Outputs:
# 	None
#############################################################

Given I "determine which arguments were specified and set the API parameters accordingly"
	When I assign "carcod,trlr_id,trlr_num" to variable "arg_list"
	Then I execute scenario "API Process Optional Arguments"
	And I execute scenario "API Translate Variable Names"
	Given I echo $transportEquipmentNumber
	And I echo $api_parameters

When I "execute the API request"
	Given I assign "GET" to variable "api_method"
	And I assign variable "api_endpoint" by combining "/api/yard/" $api_version "/transportEquipment"
	If I execute scenario "API Request"
	Else I fail step with error message $error_message
	EndIf

Then I "count the number of results, throwing an error if none"
	When I assign count of elements from json $response_json with path "/transportEquipment" to variable "rowcount"
	If I verify number $rowcount is equal to 0
		Then I fail step with error message "ERROR: Transport Equipment not found"
	EndIf

@wip @private
Scenario: Private API List Transport Equipment
#############################################################
# Description: This scenario lists transport equipment using
# 	the Blue Yonder Private API
# MSQL Files:
# 	None
# Inputs:
# 	Required:
# 		None
# 	Optional:
# 		carcod - Carrier
# 		trlr_id - Transport Equipment ID
# 		trlr_num - Transport Equipment Number
# Outputs:
# 	None
#############################################################

Given I execute scenario "Public API List Transport Equipment"

@wip @private
Scenario: Public API Check In Transport Equipment
#############################################################
# Description: This scenario checks in transport equipment using
# 	the Blue Yonder Public API
# API Endpoints:
# 	/api/yard/v1beta/transportEquipment/<trlr_id>/checkIn
# Inputs:
# 	Required:
# 		trlr_id - Transport Equipment ID
# 		wh_id - Warehouse ID
# 		yard_loc - Dock Door
# 	Optional:
# 		None
# Outputs:
# 	None
#############################################################

Given I "validate input arguments"
	Given I assign "trlr_id,wh_id,yard_loc" to variable "required_args"
	When I execute scenario "API Validate Required Arguments"
	Then I execute scenario "API Translate Variable Names"
	And I assign $yard_loc to variable "checkInLocation"

And I "create JSON request body"
	Given I assign "checkInLocation,transportEquipmentId,warehouseId" to variable "columns"
	When I execute scenario "API Build Simple JSON Object"
	Then I verify variable "json_string" is assigned
	And I verify text $json_string is not equal to ""

When I "execute the API request"
	Given I assign "POST" to variable "api_method"
	And I assign variable "api_endpoint" by combining "/api/yard/" $api_version "/transportEquipment/" $trlr_id "/checkIn"
	And I assign $json_string to variable "request_json"
	If I execute scenario "API Request"
	Else I fail step with error message $error_message
	EndIf

@wip @private
Scenario: Private API Check In Transport Equipment
#############################################################
# Description: This scenario checks in transport equipment using
# 	the Blue Yonder Private API
# MSQL Files:
# 	None
# Inputs:
# 	Required:
# 		trlr_id - Transport Equipment ID
# 		wh_id - Warehouse ID
# 		yard_loc - Dock Door
# 	Optional:
# 		None
# Outputs:
# 	None
#############################################################

Given I execute scenario "Public API Check In Transport Equipment"

@wip @private
Scenario: Public API Close Transport Equipment
#############################################################
# Description: This scenario closes transport equipment using
# 	the Blue Yonder Public API
# API Endpoints:
# 	/api/yard/v1beta/transportEquipment/<trlr_id>/close
# Inputs:
# 	Required:
# 		trlr_id - Transport Equipment ID
# 	Optional:
# 		None
# Outputs:
# 	None
#############################################################

Given I "validate input arguments"
	If I verify variable "trlr_id" is assigned
	And I verify text $trlr_id is not equal to ""
	Else I fail step with error message "ERROR: Missing argument trlr_id"
	EndIf

And I "create JSON request body"
	Given I assign "IMMEDIATE" to variable "moveType"
	And I assign "moveType" to variable "columns"
	When I execute scenario "API Build Simple JSON Object"
	Then I verify variable "json_string" is assigned
	And I verify text $json_string is not equal to ""

When I "execute the API request"
	Given I assign "POST" to variable "api_method"
	And I assign variable "api_endpoint" by combining "/api/yard/" $api_version "/transportEquipment/" $trlr_id "/close"
	And I assign $json_string to variable "request_json"
	If I execute scenario "API Request"
	Else I fail step with error message $error_message
	EndIf

@wip @private
Scenario: Private API Close Transport Equipment
#############################################################
# Description: This scenario closes transport equipment using
# 	the Blue Yonder Private API
# MSQL Files:
# 	None
# Inputs:
# 	Required:
# 		trlr_id - Transport Equipment ID
# 	Optional:
# 		None
# Outputs:
# 	None
#############################################################

Given I execute scenario "Public API Close Transport Equipment"