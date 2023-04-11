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
# Test Case: BASE-WAV-1050 Web Outbound Plan Wave Delete Load.feature
# 
# Functional Area: Outbound
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: regression
# Blue Yonder Interfaces Interacted With: WEB, MOCA
# 
# Description:
# This Test Case loads a carrier move id (load) via MSQL and then removes the load in the Web
# 
# Input Source: Test Case Inputs/BASE-WAV-1050.csv
# Required Inputs:
# 	carcod - This will be used as the carrier for the shipment
# 	move_id - This will be used as the move ID assigned to the trailer
# Optional Inputs:
#	None
#
# Assumptions:
# - User has permissions for functions
#
# Notes:
# None
#
############################################################ 
Feature: BASE-WAV-1050 Web Outbound Plan Wave Delete Load
 
Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Outbound Planner Imports"
    Then I execute scenario "Web Outbound Trailer Imports"
	And I execute scenario "Web Environment Setup"

	And I assign "BASE-WAV-1050" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"
	Then I assign "Create_Car_Move" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"

After Scenario:
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"
    
And I "cleanup the dataset"
	Then I assign "Create_Car_Move" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script" 
 
@BASE-WAV-1050
Scenario Outline: BASE-WAV-1050 Web Outbound Plan Wave Delete Load
CSV Examples: Test Case Inputs/BASE-WAV-1050.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "log into the Web"
	And I execute scenario "Web Login"

And I "navigate to Outbound Screen"
	Then I execute scenario "Web Navigate to Outbound Planner Outbound Screen"
    
And I "delete the load"
	Then I execute scenario "Web Delete Load"

And I "validate the load was deleted"
	Then I execute scenario "Validate Load Deleted"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"