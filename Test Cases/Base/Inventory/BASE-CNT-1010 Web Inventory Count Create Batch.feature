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
# Test Case: BASE-CNT-1010 Web Inventory Count Create Batch.feature
#
# Functional Area: Inventory
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: MOCA, WEB
#
# Description: Create a Count Batch using the Web using ad-hoc selection parameters like location range, client_id etc.
#
# Input Source: Test Case Inputs/BASE-CNT-1010.csv
# Required Inputs:
#	requestCountBy - Method of requesting counts
#	beginLocation - Start of count location range
#	endLocation - End of count location range
#	cntbat - Count Batch we are creating
#	cnttyp_desc - Count type description
#	gencod_desc - Generate code description
# Optional Inputs:
# None
#
# Assumptions:
# - Locations to be counted that are EMPTY - MUST have the configuration in 
#   Inventory -> Counts Types -> Cycle Count -> Empty Location set to Yes, without this
#	if the location used for the test is empty, the test will fail.
# - Locations to be counted should have a Count Zone assigned, otherwise they can't be selected for a count batch.
#   Setup one or more Count Zones and assign it to all locations eligible for counting
# - No Data load is used for this test
# 
# Notes:
# None
#
############################################################# 
Feature: BASE-CNT-1010 Web Inventory Count Create Batch

Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Then I execute scenario "Inventory Count Imports"
	And I execute scenario "Web Environment Setup"

	Then I assign "BASE-CNT-1010" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "cleanup the dataset, since there was no initial dataset to load"
	Then I assign "Inv_Count_Batch" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"
    
After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Inv_Count_Batch" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-INV-1010
Scenario Outline: BASE-CNT-1010 Web Inventory Count Create Batch
CSV Examples: Test Case Inputs/BASE-CNT-1010.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I execute scenario "Web Login"
Then I execute scenario "Web Open Inventory Counts Screen"
When I execute scenario "Web Inventory Create Count Batch"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"