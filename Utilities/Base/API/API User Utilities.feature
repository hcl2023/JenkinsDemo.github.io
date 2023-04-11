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
# Utility: API User Utilities.feature
# 
# Functional Area: System Administration
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: API
#
# Description:
# This utility contains scenarios to facilitate interaction with
# the User endpoints in the Blue Yonder API
#
# Public Scenarios:  
# 	- API List Warehouses for Current User - Returns a list of all the warehouses the current user is authorized to use
# 	- API Verify User Is Authorized for Warehouse - Determines whether the current user is authorized for a specific warehouse
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: API Item Utilities

@wip @public
Scenario: API List Warehouses for Current User
#############################################################
# Description: This scenario returns a list of all the warehouses
# 	the current user is authorized to use
# API Endpoints:
# 	/api/user/v1beta/currentUser/warehouses
# Inputs:
# 	Required:
# 		None
# 	Optional:
# 		None
# Outputs:
# 	response_json
#############################################################

Given I "get a JSON object with all of the Warehouses assigned to the current user"
	When I assign variable "api_endpoint" by combining "/api/user/" $api_version "/currentUser/warehouses"
	And I assign "GET" to variable "api_method"
	Then I execute scenario "API Request"

@wip @public
Scenario: API Verify User Is Authorized for Warehouse
#############################################################
# Description: This scenario scans the list of warehouses
# 	where the current user is authorized and attempts to locate
# 	wh_id
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		wh_id - The warehouse ID
# 	Optional:
# 		None
#############################################################

Given I "set up the parameters related to the JSON structure"
	Given I assign "/warehouses" to variable "array_path"
	And I assign "warehouseId" to variable "validation_paths"
	And I assign $wh_id to variable "validation_values"

And I "retrieve the list of warehouses authorized to the current user"
	Given I execute scenario "API List Warehouses for Current User"
	And I assign $response_json to variable "json"

When I "scan the list of warehouses for the current warehouse"
	# Search JSON array found at /warehouses
	# Absolute JSONPath to warehouseId = /warehouses[i]/warehouseId
	If I execute scenario "API Find Value in JSON Array"
	Else I assign variable "error_message" by combining "ERROR: User is not authorized for warehouse " $wh_id
		And I fail step with error message $error_message
	EndIf