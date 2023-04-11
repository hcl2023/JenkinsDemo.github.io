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
# Test Case: BASE-YRD-4010 Mobile Trailer Move.feature
# 
# Functional Area: Yard
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: regression
# Blue Yonder Interfaces Interacted With: Mobile, MOCA
#
# Description:
# This Test Case assigns a trailer, checks it in, then moves the trailer using the Mobile App
#
# Input Source: Test Case Inputs/BASE-YRD-4010.csv
# Required Inputs:
# 	wh_id - Warehouse ID
# 	trlr_num - Trailer Number
# 	carcod - Carrier Code
# 	check_in_dock_loc - Location where trailer will be checked into
# 	move_to_dock_loc - Location where trailer will be moved to
#	work_queue_or_immediate - Indicator for how the move is processed
# Optional Inputs:
# None
#
# Assumptions:
# - User must have permissions to perform trailer moves
#
# Notes:
# - Test Case Inputs (CSV) - Examples:
#	Example Row: One with work_queue_or_immediate set to work_queue
#	Example Row: One with work_queue_or_immediate set to immediate
#   both cases will complete and verify the move in the Mobile App/MOCA
#
############################################################
Feature: BASE-YRD-4010 Mobile Trailer Move
 
Background:
#############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Then I assign "BASE-YRD-4010" to variable "test_case"
	When I execute scenario "Test Data Triggers"

	Given I execute scenario "Mobile Trailer Move Imports"

And I "load the dataset"
	Then I assign "Trailer_Creation" to variable "dataset_directory"    
	And I execute scenario "Perform MOCA Dataset"

After Scenario:
#############################################################
# Description: Logs out of the inteface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"
	
And I "cleanup the dataset"
	Then I assign "Trailer_Creation" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-YRD-4010
Scenario Outline: BASE-YRD-4010 Mobile Trailer Move
CSV Examples: Test Case Inputs/BASE-YRD-4010.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "setup for a trailer move operation"
	And I execute scenario "Trailer Validate Move Data"
	And I execute scenario "Create Trailer Move Work"
	And I execute scenario "Mobile Verify and Escalate Directed Work"

When I "execute a trailer move operation"
	Then I execute scenario "Mobile Login"
	And I execute scenario "Mobile Trailer Move"

And I "verify a trailer move operation"
	Then I execute scenario "Trailer Moving Post Move Checks"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"