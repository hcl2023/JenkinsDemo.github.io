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
# Utility: API Item Utilities.feature
# 
# Functional Area: Inventory
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: API
#
# Description:
# This utility contains scenarios to facilitate interaction with
# the Item endpoints in the Blue Yonder API
#
# Public Scenarios:  
# 	- API Get Alternate Item Number - Returns the alternate item number (UPC, GTIN, etc.) associated with an item
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
Scenario: API Get Alternate Item Number
#############################################################
# Description: This scenario returns an alternate item number
# 	based on the provided item number. Both the private and
# 	public APIs support this operation, so both implementations
# 	are provided, as the private implementation should run
# 	marginally faster.
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		wh_id - Warehouse ID
# 		prtnum - Item Number
# 		prt_client_id - Item Client ID
# 		alt_prt_typ - Alternate Item Type
# 	Optional:
# 		uomcod - UOM Code
# Outputs:
# 	alt_prtnum - The Alternate Item Number
#############################################################

When I "decide whether to use the private or public API"
	If I verify variable "api_preference" is assigned
	And I verify text $api_preference is equal to "private"
		Then I execute scenario "Private API Get Alternate Item Number"
	Else I execute scenario "Public API Get Alternate Item Number"
	EndIf

#############################################################
# Private Scenarios:
# 	- Get Alternate Item Number from Public API - attempts to find a matching Alternate Item using the BY Public API
# 	- Get Alternate Item Number from Private API - leverages the filtering capabilities of the BY Private API to more quickly find a matching Alternate Item
#############################################################

@wip @private
Scenario: Public API Get Alternate Item Number
#############################################################
# Description: This scenario returns an alternate item number
# 	based on the provided item number, using the Blue Yonder
# 	Public API
# API Endpoints:
# 	/api/item/v1beta/items/<ResourceID>/alternates
# Inputs:
# 	Required:
# 		wh_id - Warehouse ID
# 		prtnum - Item Number
# 		prt_client_id - Item Client ID
# 		alt_prt_typ - Alternate Item Type
# 	Optional:
# 		uomcod - UOM Code
# Outputs:
# 	alt_prtnum - The Alternate Item Number
#############################################################

Given I "obtain a resource ID for the Item"
	Given I verify variables "wh_id,prtnum,prt_client_id,alt_prt_typ" are assigned
	And I assign "warehouseId,itemNumber,itemClientId" to variable "columns"
	When I execute scenario "API Translate Variable Names"
	Then I execute scenario "API Generate Resource ID"

When I "get a JSON object with all of the Alternate Items associated with our Item"
	Given I assign variable "api_endpoint" by combining "/api/item/" $api_version "/items/" $resource_id "/alternates"
	And I assign "GET" to variable "api_method"
	When I execute scenario "API Request"
	Then I assign $response_json to variable "json"

Then I "scan the JSON object for an Alternate Item that matches the Alternate Item Type (and UOM Code, if specified)"
	Given I assign "/alternateItems" to variable "array_path"
	And I assign "alternateItemId/alternateItemType" to variable "validation_paths"
	And I assign $alt_prt_typ to variable "validation_values"

	If I verify variable "uomcod" is assigned
	And I verify text $uomcod is not equal to ""
		Then I assign variable "validation_paths" by combining $validation_paths ",uomCode"
		And I assign variable "validation_values" by combining $validation_values "," $uomcod
	EndIf

	# Search JSON array found at /alternateItems
	# Absolute JSONPath to uomCode = /alternateItems[i]/uomCode
	# Absolute JSONPath to alternateItemType = /alternateItems[i]/alternateItemId/alternateItemType
	# Absolute JSONPath to alternateItemNumber = /alternateItems[i]/alternateItemId/alternateItemNumber
	If I execute scenario "API Find Value in JSON Array"
		# Match found
		Then I assign variable "alt_prtnum_path" by combining $result_path "alternateItemId/alternateItemNumber"
		And I assign value from JSON $json with path $alt_prtnum_path to variable "alt_prtnum"
	Else I fail step with error message "ERROR: No alternate item number found"
	EndIf

@wip @private
Scenario: Private API Get Alternate Item Number
#############################################################
# Description: This scenario returns an alternate item number
# 	based on the provided item number, using the Blue Yonder
# 	Private API
# API Endpoints:
# 	/ws/wm/alternateItems
# Inputs:
# 	Required:
# 		wh_id - Warehouse ID
# 		prtnum - Item Number
# 		prt_client_id - Item Client ID
# 		alt_prt_typ - Alternate Item Type
# 	Optional:
# 		uomcod - UOM Code
# Outputs:
# 	alt_prtnum - The Alternate Item Number
#############################################################

Given I "translate MOCA variable names to API variable names"
	When I verify variables "wh_id,prtnum,prt_client_id,alt_prt_typ" are assigned
	Then I execute scenario "API Translate Variable Names"

When I "execute the API request"
	Given I assign "/ws/wm/alternateItems" to variable "api_endpoint"
	And I assign "GET" to variable "api_method"
	If I verify variable "uomcod" is assigned
	And I verify text $uomcod is not equal to ""
		Then I assign "warehouseId,itemNumber,itemClientId,alternateItemType,unitOfMeasure" to variable "api_parameters"
	Else I assign "warehouseId,itemNumber,itemClientId,alternateItemType" to variable "api_parameters"
	EndIf
	When I execute scenario "API Request"
	Then I assign $response_json to variable "json"

Then I "parse the JSON result"
	Given I assign count of elements from json $json with path "/data" to variable "num_alt_items"
	If I verify number $num_alt_items is equal to 0
		Then I fail step with error message "ERROR: Alternate Item Number not found"
	Else I "retrieve data from JSON"
		Then I assign value from JSON $json with path "/data[0]/alternateItemNumber" to variable "alt_prtnum"
	EndIf