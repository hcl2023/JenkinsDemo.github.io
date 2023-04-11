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
# Utility: API Inventory Utilities.feature
# 
# Functional Area: Inventory
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: API
#
# Description:
# This utility contains scenarios to facilitate interaction with
# the Inventory endpoints in the Blue Yonder API
#
# Public Scenarios:  
# 	- API Create Inventory - Creates inventory using the attributes specified by the parameters
# 	- API Remove Inventory - Removes inventory by identifier
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: API Inventory Utilities

@wip @public
Scenario: API Create Inventory
#############################################################
# Description: Creates inventory using the attributes
# 	specified by the parameters
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		wh_id - Warehouse ID
# 		invtid - Inventory Identifier
# 		prtnum - Item Number
# 		ftpcod - Footprint Code
# 		stoloc - Storage Location
# 		untqty - Unit Quantity
# 	Optional:
# 		oprcod - Operation Code (for adjustment) - default is "INVADJ"
# 		reacod - Reason Code (for adjustment) - default is "ADJ-ACCEPT"
# 		invsts - Inventory Status Code - default is "A"
# 		prt_client_id - Item Client ID - If not specified, uses the value of client_id
# Outputs:
# 	alt_prtnum - The Alternate Item Number
#############################################################

Given I execute scenario "Public API Create Inventory"

@wip @private
Scenario: Public API Create Inventory
#############################################################
# Description: Creates inventory using the public Inventory
# 	Adjustments endpoint
# API Endpoints:
# 	/api/inventory/v1beta/adjustments
# Inputs:
# 	Required:
# 		wh_id - Warehouse ID
# 		invtid - Inventory Identifier
# 		prtnum - Item Number
# 		ftpcod - Footprint Code
# 		stoloc - Storage Location
# 		untqty - Unit Quantity
# 	Optional:
# 		oprcod - Operation Code (for adjustment) - default is "INVADJ"
# 		reacod - Reason Code (for adjustment) - default is "ADJ-ACCEPT"
# 		invsts - Inventory Status Code - default is "A"
# 		prt_client_id - Item Client ID - If not specified, uses the value of client_id (this happens in Environment.feature)
# Outputs:
# 	alt_prtnum - The Alternate Item Number
#############################################################

Given I "validate input arguments"
	When I verify variables "wh_id,invtid,prtnum,ftpcod,stoloc,untqty" are assigned

	If I verify variable "oprcod" is assigned
	And I verify text $oprcod is not equal to ""
	Else I assign "INVADJ" to variable "oprcod"
	EndIf

	If I verify variable "reacod" is assigned
	And I verify text $reacod is not equal to ""
	Else I assign "ADJ-ACCEPT" to variable "reacod"
	EndIf

	If I verify variable "invsts" is assigned
	And I verify text $invsts is not equal to ""
	Else I assign "A" to variable "invsts"
	EndIf

	Then I execute scenario "API Translate Variable Names"

When I "prepare and invoke the API request"
	Given I assign """{"inventoryAdjustments":[{@footprintCode,"inventoryReference":{@inventoryId},@inventoryStatus,@itemClientId,@itemNumber,@locationNumber,"reason":{@reasonCode},@unitQuantity}],@operationCode,@warehouseId}""" to variable "structure"
	And I execute scenario "API Build Complex JSON Object"
	And I echo $json_string
	
	Given I assign $json_string to variable "request_json"
	And I assign variable "api_endpoint" by combining "/api/inventory/" $api_version "/adjustments"
	And I assign "POST" to variable "api_method"
	If I execute scenario "API Request"
	Else I fail step with error message $error_message
	EndIf

@wip @public
Scenario: API Remove Inventory
#############################################################
# Description: This scenario removes an inventory identifier
# API Endpoints:
# 	/api/inventory/v1beta/inventory/<invtid>
# Inputs:
# 	Required:
# 		wh_id - Warehouse ID
# 		invtid - Inventory Identifier
# 	Optional:
# 		reacod - Reason Code
# 		adjref1 - Adjustment Reference 1
# 		adjref2 - Adjustment Reference 2
# Outputs:
# 	None
#############################################################

Given I "validate the input arguments"
	Given I assign "wh_id,invtid" to variable "required_args"
	Then I execute scenario "API Validate Required Arguments"
	And I execute scenario "API Translate Variable Names"

When I "set up the API request parameters"
	Given I assign $api_var_map_wh_id to variable "api_parameters"
	And I assign "reacod,adjref1,adjref2" to variable "arg_list"
	Then I execute scenario "API Process Optional Arguments"

Then I "invoke the API request"
	Given I assign "DELETE" to variable "api_method"
	And I assign variable "api_endpoint" by combining "/api/inventory/" $api_version "/inventory/" $invtid
	If I execute scenario "API Request"
		Then I echo $response_json
	Else I fail step with error message $error_message
	EndIf