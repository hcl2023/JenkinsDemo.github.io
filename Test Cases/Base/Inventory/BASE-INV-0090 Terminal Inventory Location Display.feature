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
# Test Case: BASE-INV-0090 Terminal Inventory Location Display.feature
# 
# Functional Area: Inventory
# Author: Tryon Solutions 
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Terminal, MOCA
#
# Description: This Test Case will perform an inventory location display given a stoloc in the terminal
#
# Input Source: Test Case Inputs/BASE-INV-0090.csv
# Required Inputs:
# 	stoloc - A valid storage location in the system
#	generate_screenshot - generate screen shot of location display screen
# Optional Inputs:
# 	None
#
# Assumptions:
# None
#
# Notes:
# - No dataset is used, relies on location in the system
#
############################################################
Feature: BASE-INV-0090 Terminal Inventory Location Display

Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Inventory Adjust Imports"

	Then I assign "BASE-INV-0090" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "mention there is no dataset to load"

After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "mention there is no dataset to cleanup"

@BASE-INV-0090
Scenario Outline: BASE-INV-0090 Terminal Inventory Location Display
CSV Examples: Test Case Inputs/BASE-INV-0090.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "log into the terminal and navigate to the inventory display screen"
	And I execute scenario "Terminal Login"
	And I execute scenario "Terminal Inventory Location Display Menu"

When I "perform an inventory location display from the terminal"
	And I execute scenario "Terminal Inventory Location Display"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"