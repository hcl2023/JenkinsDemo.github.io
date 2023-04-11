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
# Test Case: BASE-RPL-1030 Web Inventory Generate Top-Off Replenishment.feature

# Functional Area: Replenishment
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: MOCA, WEB
#
# Description: This test case will generate a top-off replenishment for a location in the Web
# 
# Input Source: Test Case Inputs/BASE-RPL-1030.csv
# Required Inputs:
#	client_id - Needs to be a valid client id that is assigned in your system
#	prtnum - Needs to be a valid part number that is assigned in your system
#	untqty - Quantity being added to caslod
#	invsts_prg - Needs to be a valid invsts_prg configured in the system
#	caslod - This will be used as the load number that will be used for the replenishment
#	srcloc - This will be used as the location that will be used for the replenishment
#	adjrea - This will be used as the adjustment reason when creating load to replen
#	adjact - This will be used as the adjustment activity code when creating load to replen
#	repl_loc - This will be the location used to generate a top-off replenishment 
#
# Optional Inputs:
# 	validate_sucess - If YES validates success message in web
#	retry_replenishment - If YES try to generate top-off replenishment for a pending replenishment location in web
#
# Assumptions:
# - The warehouse is configured for Top-off Replenishment
#
# Notes:
# - Test Case Inputs (CSV) - Examples:
#	Example Row: Successful Top Off Replenishment from reserve to location
#	Example Row: Failed Top Off Replenishment with "failed to generate replenishments" message
#
############################################################ 
Feature: BASE-RPL-1030 Web Inventory Generate Top-Off Replenishment

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

	And I assign "BASE-RPL-1030" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"
	Then I assign "Top_Off_Replen" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"
	And I assign $repl_loc to variable "stoloc"
 
After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Top_Off_Replen" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-RPL-1030
Scenario Outline: BASE-RPL-1030 Web Inventory Generate Top-Off Replenishment
CSV Examples: Test Case Inputs/BASE-RPL-1030.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "login into the web and navigate to the inventory screen"
	And I execute scenario "Web Login"
	Then I execute scenario "Web Open Inventory Screen"

When I "generate top-off replenishment for a location"
	Then I execute scenario "Web Generate Top-off Replenishment For a Location"
    
Then I "verify top-off replenishment generated"
	When I execute scenario "Validate Top-off Replenishment Generated"

When I "verify re-try to generate top-off replenishment is yes"
	If I verify variable "retry_replenishment" is assigned 
	And I verify text $retry_replenishment is equal to "YES" ignoring case
		Then I unassign variable "validate_sucess"
		And I assign "YES" to variable "validate_fail"
		Then I execute scenario "Web Open Inventory Screen"

		When I "generate top-off replenishment for a location"
			Then I execute scenario "Web Generate Top-off Replenishment For a Location"	
	Endif

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"