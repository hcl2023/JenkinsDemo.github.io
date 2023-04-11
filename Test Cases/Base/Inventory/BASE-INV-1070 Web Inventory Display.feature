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
# Test Case: BASE-INV-1070 Web Inventory Display.feature
#
# Functional Area: Inventory
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: MOCA, WEB
#
# Description:
# This test case will perform an inventory display in the Web
#
# Input Source: Test Case Inputs/BASE-INV-1070.csv
# Required Inputs:
# 	stoloc - Location where the inventory display will come from. Must be a valid location in the system
# 	lodnum - Load number being displayed. Must be from actual inventory in the system
# 	prtnum - A valid part number in the systen relative to the specified lodnum
#	generate_screenshot - generate screen shot of inventory display screen
# Optional Inputs:
# None
#
# Assumptions:
# None
#
# Notes:
# - This feature does not used a dataset for load or cleanup
#
############################################################ 
Feature: BASE-INV-1070 Web Inventory Display
 
Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Inventory Adjust Imports"
	Then I execute scenario "Web Environment Setup"

	And I assign "BASE-INV-1070" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "note, there is no dataset to load"

After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "note, there is no dataset to cleanup"

@BASE-INV-1070
Scenario Outline: BASE-INV-1070 Web Inventory Display
CSV Examples: Test Case Inputs/BASE-INV-1070.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "login into the web and navigate to the inventory screen"
	And I execute scenario "Web Login"
	And I execute scenario "Web Open Inventory Screen"

And I execute scenario "Web Inventory Display"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"