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
# Test Case: Dynamic Data Test
# 
# Functional Area: Testing
# Author: Tryon Solutions 
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: MOCA
# 
# Description:
# This Test Case tests the Dynamic Data Functionality
#
# Input Source: Test Case Inputs/BASE-DD-0010.CSV
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
Feature: BASE-DD-0010 Dynamic Data Test

Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Then I assign "BASE-DD-0010" to variable "test_case"
	When I execute scenario "Test Data Triggers"
 
After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"
 
@BASE-DD-0010
Scenario Outline: BASE-DD-0010 Dynamic Data Test
CSV Examples: Test Case Inputs/BASE-DD-0010.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Given I "confirm dynamic data values were returned"
	When I echo $test_description
	Then I echo $prtnum $srcprt $lotnum $ordnum

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"
 