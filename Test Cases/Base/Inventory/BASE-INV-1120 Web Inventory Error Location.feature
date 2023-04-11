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
# Test Case: BASE-INV-1120 Web Inventory Error Location.feature
# 
# Functional Area: Inventory
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: MOCA, WEB
# 
# Description: This Test Case sets a location status to error and resets it to the original status.
#
# Input Source: Test Case Inputs/BASE-INV-1120.csv
# Required Inputs:
# 	stoloc – valid storage location in the system.
# Optional Inputs: 
# 	None
#
# Assumptions:
# 	- Location is not locked, or in inventory error state
#
# Notes:
# None
#
############################################################
Feature: BASE-INV-1120 Web Inventory Error Location

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

	Then I assign "BASE-INV-1120" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"
	Then I assign "Web_Location_Status_Change" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"
	 
After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Web_Location_Status_Change" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-INV-1120
Scenario Outline: BASE-INV-1120 Web Inventory Error Location
CSV Examples: Test Case Inputs/BASE-INV-1120.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "confirm location is not in error and save the current status"
	And I execute scenario "Validate Location is not in Error"
	And I assign value $location_status to unassigned variable "pre_location_status"

And I execute scenario "Web Login"

When I "put location on error status"
	And I execute scenario "Web Error Location"
	
Then I "validate the location is now in error status"
	Then I execute scenario "Validate Location is in Error"

And I "reset the location status"
	Given I execute scenario "Web Reset Location"

And I "validate original status"
	Then I execute scenario "Validate Location is not in Error"
	And I assign value $location_status to unassigned variable "post_location_status"
	If I verify text $pre_location_status is equal to $post_location_status
		Then I echo "location is set to the original status"
	Else I fail step with error message "ERROR: location is not in the original status"
	Endif

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"