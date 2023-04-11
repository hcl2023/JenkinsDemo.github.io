############################################################
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
# Test Case: BASE-SHP-1030 Web Outbound Validate Order.feature
#
# Functional Area: Outbound
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: regression
# Blue Yonder Interfaces Interacted With: WEB, MOCA
# 
# Description:
# This test case will load an incoming order via MSQL and validate it from the Web
#
# Input Source: Test Case Inputs/BASE-SHP-1030.csv
# Required Inputs:
#	adrnam - Address name to be created
#	adrtyp - Address type. Must exist in system.
#	adrln1 - Address line 1 to be created
#	adrcty - Address city to be created
#	adrstc - Address state code. Must be valid and must exist in system.
#	adrpsz - Address zip code. Must be valid and must exist in system.
#	ctry_name - Country for address. Must exist in system
#	first_name - First name for address to be created
#	locale_id - Language location ID. Must exist in system
#	ordnum - Order number to be created
#	cstnum - Customer number. Must exist in system
#	cponum - Customer PO number
#	ordtyp - Order type. Must exist in system
#	untqty - Order line quantity to ship
#	prtnum - Part number on order line. Must exist in system.
#	carcod - Carrier code. Must exist in system
#	srvlvl - Shipping service level. Must exist in system.
# Optional Inputs:
# 	None
# 
# Assumptions:
# None
#
# Notes:
# None
# 
############################################################ 
Feature: BASE-SHP-1030 Web Outbound Validate Order
 
Background: 
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Outbound Planner Imports"
	And I execute scenario "Web Environment Setup"

	Then I assign "BASE-SHP-1030" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"	
	Then I assign "Ord_Manual_Ship_Plan" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"
 
After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Ord_Manual_Ship_Plan" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"
 
@BASE-SHP-1030
Scenario Outline: BASE-SHP-1030 Web Outbound Validate Order
CSV Examples: Test Case Inputs/BASE-SHP-1030.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "log into the Web and navigate to Outbound Screen"
	And I execute scenario "Web Login"
	And I execute scenario "Web Navigate to Outbound Planner Outbound Screen"
    
When I "validate the incoming order and screen/system information about the order"
	Then I execute scenario "Web Validate Order"
	And I execute scenario "Web Validate Order Info"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"