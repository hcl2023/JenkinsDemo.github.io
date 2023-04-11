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
# Test Case: BASE-INV-1110 Web Inventory Location Display.feature
#
# Functional Area: Inventory
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: MOCA, WEB
#
# Description:
# This test case will examine a storage location for Configuration/Storage Locations area in the Web
#
# Input Source: Test Case Inputs/BASE-INV-1110.csv
# Required Inputs:
# 	stoloc - valid storage location in the system
#	generate_screenshot - generate screen shot of storage location screen
# Optional Inputs:
# None
#
# Assumptions:
# None
#
# Notes:
# - This feature does not use a dataset for load or cleanup
#
############################################################ 
Feature: BASE-INV-1110 Web Inventory Location Display
 
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

	And I assign "BASE-INV-1110" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "note, there is no dataset to load"

After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "note, there is no dataset to cleanup"

@BASE-INV-1110
Scenario Outline: BASE-INV-1110 Web Inventory Location Display
CSV Examples: Test Case Inputs/BASE-INV-1110.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "login into the web and navigate to the inventory screen"
	And I execute scenario "Web Login"
	And I execute scenario "Web Open Storage Locations Screen"

And I execute scenario "Web Inventory Location Display"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"