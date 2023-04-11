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
# Test Case: BASE-RCV-1090 Web Inbound Unload All Without Receiving.feature
# 
# Functional Area: Receiving
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Web, MOCA
#
# Description: This test case will perform an Unload All operation from the Web
#
# Input Source: Test Case Inputs/BASE-RCV-1090.csv
# Required Inputs:
#	trlr_num - this will be the Receive Truck 
#	yard_loc - This is where your Trailer needs to be checked in. Must be a valid and open dock door.
#	invtyp - This need to be a valid Invoice Type, that is assigned in your system
#	prtnum - This needs to be a valid part number that is assigned in your system. Will use the default client_id.
#	rcvsts - Receiving status created on the Invoice Line being loaded
#	expqty - The expected quantity
#	supnum - A valid supplier
#	rec_loc - staging location to receive to
#	move_option - On unload, move equipment option (valid options are dispatch, leave, move_to)
# Optional Inputs:
#	move_to_loc - If move option is move_to, door location to move to
#
# Assumptions:
# None

# Notes: Test Case Inputs (CSV) - Examples:
#	Example Row: move_option set to move_to
#	Example Row: move_option set to dispatch
#	Example Row: move_option set to leave
#	Example Row: move_option not set (should do dispatch)
# 
############################################################
Feature: BASE-RCV-1090 Web Inbound Unload All Without Receiving

Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Web Receiving Imports"
	And I execute scenario "Web Environment Setup"

	Then I assign "BASE-RCV-1090" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"	
	Then I assign "receiving" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"

After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "receiving" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-RCV-1090
Scenario Outline: BASE-RCV-1090 Web Inbound Unload All Without Receiving
CSV Examples: Test Case Inputs/BASE-RCV-1090.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "log into the Web Browser and navigate to the Receiving/Door Activity Screen"
	Then I execute scenario "Web Login"
    And I execute scenario "Web Open Receiving Door Activity Screen"
    
When I "find trailer, perform safety checks and perform unload all operation"
	Then I execute scenario "Web Receiving Search for Trailer from Door Activity"
    And I execute scenario "Web Shipping Loads Process Trailer Safety Check"
	And I execute scenario "Web Door Activity Select Trailer"
	When I execute scenario "Web Receiving Unload All"
    
Then I "validate receiving trailer state and location after unload all operation"
	And I execute scenario "Receiving Validate Trailer After Unload All"

And I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"