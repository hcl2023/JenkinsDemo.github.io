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
# Test Case: BASE-CNT-0050 Terminal Inventory Count Manual Undirected.feature
# 
# Functional Area: Inventory
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Terminal, MOCA
#
# Description: This test case performs a manual count in the Terminal
#
# Input Source: Test Case Inputs/BASE-CNT-0050.csv
# Required Inputs:
#	stoloc - location where the manual count is desired
#	create_mismatch - specifies whether to create a count mismatch
#	committed_inventory_in_count_loc - Specifies whether to proceed or not if selected LPN or location has committed inventory
#	man_cnt_mode - Specifies whether the manual count should be performed at "LOAD", "SUB" or "DETAIL" level.
# Optional Inputs:
#	None
#	
# Assumptions: 
# - Setup manual counting correctly: The WMS lets you setup a combination of count types and count zones that result in errors while executing the manual counts.
# - Locations, parts, clients, reason codes are set up for counting
# - The location where the count is desired has inventory. There should not be more than one load in the specified location, for load level counting. While capturing quantity for detail level counts, the untqty can either be 0 or 1.
# - Configuration to generate audit count after a mismatched count
# 
# Notes:
# - Test Case Inputs (CSV) - Examples:
# 	Example Row: Performs a load level matched count on the specified location - item in location must be tracked at load level.
#	Example Row: Performs a load level mismatched count on the specified location - item in location must be tracked at load level.
#	Example Row: Performs a sub-load level matched count on the specified location - item in location must be tracked at sub-load level.
#	Example Row: Performs a sub-load level mismatched count on the specified location - item in location must be tracked at sub-load level.
#	Example Row: Performs a detail level matched count on the specified location - item in location must be tracked at detail level. The detail can take untqty value of either 0 or 1 - needs to be considered if mismatch is desired at the detail level.
#
############################################################ 
Feature: BASE-CNT-0050 Terminal Inventory Count Manual Undirected
 
Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Inventory Count Imports"

	Then I assign "BASE-CNT-0050" to variable "test_case"
	When I execute scenario "Test Data Triggers"
 
After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"
    
And I "cleanup the data that might have been created as part of this test"
	Then I assign "Manual_Count" to variable "cleanup_directory"
	And I assign $stoloc to variable "srcloc"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-CNT-0050
Scenario Outline: BASE-CNT-0050 Terminal Inventory Count Manual Undirected
CSV Examples: Test Case Inputs/BASE-CNT-0050.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "login to the terminal"
	And I execute scenario "Terminal Login"

And I "navigate to the manual count screen"
    Then I execute scenario "Terminal Navigate to Manual Count Menu"
    
When I "select the LPN or location I want to manually count and proceed with the count"
	Then I execute scenario "Terminal Manual Count Process"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"