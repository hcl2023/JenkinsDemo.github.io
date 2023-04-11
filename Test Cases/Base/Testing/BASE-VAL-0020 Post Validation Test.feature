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
# Test Case: BASE-VAL-0020 Post Validation Test.feature
# 
# Functional Area: Testing
# Author: Tryon Solutions 
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: MOCA
# 
# Description:
# This Test Case tests the Validation Functionality
#
# Input Source: Test Case Inputs/BASE-VAL-0020.CSV
# Required Inputs:
# 	None
# Optional Inputs: 
#	None
#
# Assumptions:
# 	None
#
# Notes:
#
############################################################
Feature: BASE-VAL-0020 Post Validation Test

Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Then I assign "BASE-VAL-0020" to variable "test_case"
	When I execute scenario "Test Data Triggers"
 
After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"
 
@BASE-VAL-0020
Scenario Outline: BASE-VAL-0020 Post Validation Test
CSV Examples: Test Case Inputs/BASE-VAL-0020.csv

Given I execute scenario "Begin Pre-Test Activities"
When I "perform test case logic"
Given I assign 20 to variable "qty20"
Then I execute scenario "End Post-Test Activities"