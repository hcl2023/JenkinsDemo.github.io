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
# Test Case: BASE-VAL-0030 Post Validation Test
# 
# Functional Area: Testing
# Author: Tryon Solutions 
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: MOCA
# 
# Description:
# This Test Case tests a post validation on an integrator event
#
# Input Source: Test Case Inputs/BASE-VAL-0030.CSV
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
Feature: BASE-VAL-0030 Post Validation Test

Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Then I assign "BASE-VAL-0030" to variable "test_case"
	When I execute scenario "Test Data Triggers"
 
After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"
 
@BASE-VAL-0030
Scenario Outline: BASE-VAL-0030 Post Validation Test
CSV Examples: Test Case Inputs/BASE-VAL-0030.csv
 
Given I execute scenario "Begin Pre-Test Activities"
When I execute moca command "sl_log event where sys_id='DCS' and evt_id = '" $evt_id "' and prt_client_id = '" $prt_client_id "' and prtnum = '" $prtnum "'  and wh_id = '" $wh_id "' and untqty = '10' "
And I wait 5 seconds
Then I execute scenario "End Post-Test Activities"