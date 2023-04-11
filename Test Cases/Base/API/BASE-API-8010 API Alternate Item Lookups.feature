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
# Test Case: BASE-API-8010 API Alternate Item Lookups.feature
# 
# Functional Area: Inventory
# Author: Tryon Solutions 
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Pre-Validation
# Blue Yonder Interfaces Interacted With: API
# 
# Description:
# This Test Case validates alternate item types of a given part
#
# Input Source: Test Case Inputs/BASE-API-8010.csv
# Required Inputs:
# 	prtnum - Item Number - Every Alternate Item is attached to a specific prtnum/prt_client_id
# 	prt_client_id - Item Client ID - Every Alternate Item is attached to a specific prtnum/prt_client_id
# 	alt_prt_typ - Alternate Item Type - Every Alternate Item has a free-form type associated with it (UPCCOD, GTIN, etc)
# 	expected_result - What we should expect the "alt_prtnum" variable to be based on the data in our Bundle snapshot
# Optional Inputs: 
#	uomcod - Unit of Measure Code - Optionally, an Alternate Item can be associated with a specific UOM of an item (EA, CS, PA)
#
# Assumptions:
# - None
#
# Notes:
# - No dataset is used, relies on alternate items in the system
# - Test Case Inputs (CSV) - Examples:
# 	Example Row: Run with "COMB" item and "GTIN" alternate item type, expect a non-empty response
# 	Example Row: Run with "COMB" item and "UPCCOD" alternate item type, expect a non-empty response
# 	Example Row: Run with "COMB" item and "EAN" alternate item type, expect empty response
# 	Example Row: Run with "COMB" item "CS" UOM, should return empty response regardless of alternate item type
# 	Example Row: Run with "COMB" item "CS" UOM, should return empty response regardless of alternate item type
# 	Example Row: Run with "COMB" item "CS" UOM, should return empty response regardless of alternate item type
# 	Example Row: Run with "SHAMPOO" item and "GTIN" alternate item type, expect a non-empty response
# 	Example Row: Run with "SHAMPOO" item and "UPCCOD" alternate item type, expect empty response
# 	Example Row: Run with "SHAMPOO" item and "EAN" alternate item type, expect empty response
# 	Example Row: Run with "SHAMPOO" item "CS" UOM, should return empty response regardless of alternate item type
# 	Example Row: Run with "SHAMPOO" item "CS" UOM, should return empty response regardless of alternate item type
# 	Example Row: Run with "SHAMPOO" item "CS" UOM, should return empty response regardless of alternate item type
# 	Example Row: Run with "SOAP" item and "GTIN" alternate item type, expect empty response
# 	Example Row: Run with "SOAP" item and "UPCCOD" alternate item type, expect a non-empty response
# 	Example Row: Run with "SOAP" item and "EAN" alternate item type, expect empty response
# 	Example Row: Run with "SOAP" item "CS" UOM, should return empty response regardless of alternate item type
# 	Example Row: Run with "SOAP" item "CS" UOM, should return empty response regardless of alternate item type
# 	Example Row: Run with "SOAP" item "CS" UOM, should return empty response regardless of alternate item type
#
############################################################
Feature: BASE-API-8010 API Alternate Item Lookups

Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "API Imports"

	Then I assign "BASE-API-8010" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "mention there is no dataset to load"

After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "mention there is no dataset to cleanup"

@BASE-API-8010
Scenario Outline: BASE-API-8010 API Alternate Item Lookups
CSV Examples: Test Case Inputs/BASE-API-8010.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

When I "verify the response from the API matches the expected result"
	If I execute scenario "API Get Alternate Item Number"
	Else I assign "" to variable "alt_prtnum"
	EndIf
	Then I echo $alt_prtnum $expected_result
	If I verify text $alt_prtnum is equal to $expected_result
	Else I "generate a useful error message"
		Then I assign variable "error_message" by combining "ERROR: Expected result (" $expected_result ") did not match actual result (" $alt_prtnum ")"
		And I fail step with error message $error_message
	EndIf

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"