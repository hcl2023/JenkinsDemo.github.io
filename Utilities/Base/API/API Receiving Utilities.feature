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
# Utility: API Receiving Utilities.feature
# 
# Functional Area: Receiving
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: API
#
# Description:
# This utility contains scenarios to facilitate interaction with
# the Receiving endpoints in the Blue Yonder API
#
# Public Scenarios:
# 	- API Create Inbound Shipment - Creates an inbound shipment with the specified attributes
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: API Receiving Utilities

@wip @public
Scenario: API Create Inbound Shipment
#############################################################
# Description: Creates an inbound shipment with the specified
# 	attributes
# API Endpoints:
# 	/api/receiving/v1beta/inboundShipments
# Inputs:
# 	Required:
# 		wh_id - Warehouse ID
# 		trknum - Inbound Shipment Number
# 	Optional:
# 		None
# Outputs:
# 	None
#############################################################

Given I "validate input arguments"
	Given I assign "trknum,wh_id" to variable "required_args"
	When I execute scenario "API Validate Required Arguments"
	Then I execute scenario "API Translate Variable Names"

When I "create the JSON request body"
	# Use "API Field Names" mapping file to translate "wh_id,trknum" into "warehouseId,inboundShipmentNumber"
	Given I assign variable "columns" by combining $api_var_map_wh_id "," $api_var_map_trknum
	When I execute scenario "API Build Simple JSON Object"
	Then I verify variable "json_string" is assigned
	And I verify text $json_string is not equal to ""

Then I "execute the API request"
	Given I assign "POST" to variable "api_method"
	And I assign variable "api_endpoint" by combining "/api/receiving/" $api_version "/inboundShipments"
	And I assign $json_string to variable "request_json"
	If I execute scenario "API Request"
	Else I fail step with error message $error_message
	EndIf