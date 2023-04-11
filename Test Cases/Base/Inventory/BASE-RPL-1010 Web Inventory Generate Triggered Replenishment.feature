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
# Test Case: BASE-RPL-1010 Web Inventory Generate Triggered Replenishment.feature

# Functional Area: Replenishment
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: MOCA, WEB
#
# Description: This test case will generate a triggered replenishment for a location in the Web
# 
# Input Source: Test Case Inputs/BASE-RPL-1010.csv
# Required Inputs:
#	client_id - Needs to be a valid client id that is assigned in your system
#	prtnum - Needs to be a valid part number that is assigned in your system
#	untqty - Quantity being added to caslod
#	invsts_prg - Needs to be a valid invsts_prg configured in the system
#	caslod - This will be used as the load number that will be used for the replenishment
#	srcloc - This will be used as the location that will be used for the replenishment
#	adjrea - This will be used as the adjustment reason when creating load to replen
#	adjact - This will be used as the adjustment activity code when creating load to replen
#	dst_untqty - This will be used as the qty to adjust in to fulfill 20% of location capacity
#	dst_caslod - This will be used as the load number that will be used to create inventory in repl_loc
#	repl_loc - This will be the location used to generate a top-off replenishment 
#	reacodfull - System reason code for adjustment. Must exist as a valid reason code in the system. 
#				 This Web readable value (this input value) is translated to the system code value for use in the dataset
# Optional Inputs:
# None
#
# Assumptions:
# - The warehouse is configured for Triggered Replenishment
#
# Notes:
# None
#
############################################################ 
Feature: BASE-RPL-1010 Web Inventory Generate Triggered Replenishment

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

	And I assign "BASE-RPL-1010" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"
	Then I assign "Triggered_Replen" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"
	And I assign $repl_loc to variable "stoloc"
	And I assign $dst_caslod to variable "lodnum"
 
After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Triggered_Replen" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-RPL-1010
Scenario Outline: BASE-RPL-1010 Web Inventory Generate Triggered Replenishment
CSV Examples: Test Case Inputs/BASE-RPL-1010.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "login into the web and navigate to the inventory screen"
	And I execute scenario "Web Login"
	And I execute scenario "Web Open Inventory Screen"

Then I "remove lpn from a location"
	When I execute scenario "Web Inventory Remove LPN from a Location"

Then I "verify triggered replenishment generated"
	When I execute scenario "Validate Triggered Replenishment Generated"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"