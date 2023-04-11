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
# Test Case: BASE-YRD-1040 Web Outbound Trailer Check In.feature
# 
# Functional Area: Outbound
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: regression
# Blue Yonder Interfaces Interacted With: WEB, MOCA
#
# Description:
# This test case creates an outbound trailer in the Web Transport Equipment screen then uses the 
# Web Check In screen to check the outbound trailer into an available dock door
# 
# Input Source: Test Case Inputs/BASE-YRD-1040.csv
# Required Inputs:
#	carcod - Carrier Code. Must exist in system
#	trlr_num - Trailer number to be created if creating data or used if already in system
#	dock - This will be used as the dock location for the trailer check in
# Optional Inputs:
# 	None
#
# Assumptions:
# - Dock door is available for check in
# - Process assumes check in without appointment
#
# Notes:
# - This Test Case creates a trailer using the web if create_data is set to TRUE (default) and does not do a dataset load
# - This Test Case can check in an existing trailer by setting create_data to FALSE and supplying a valid trlr_num with carcod in Expected status
# 
############################################################ 
Feature: BASE-YRD-1040 Web Outbound Trailer Check In
 
Background:
#############################################################
# Description: Imports dependencies, sets up environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Web Outbound Trailer Imports"
	Then I execute scenario "Web Environment Setup"

	And I assign "BASE-YRD-1040" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "cleanup the dataset, since there was no initial dataset to load"
	Then I assign "Web_Outbound_Trailer_Common" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"
    
After Scenario:
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Web_Outbound_Trailer_Common" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"
 
@BASE-YRD-1040
Scenario Outline: BASE-YRD-1040 Web Outbound Trailer Check In
CSV Examples: Test Case Inputs/BASE-YRD-1040.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I execute scenario "Web Login"
And I execute scenario "Web Create Outbound Trailer for Check In"
And I execute scenario "Web Validate Outbound Trailer Exists for Check In"
And I execute scenario "Web Open Check In Screen"
And I execute scenario "Web Select Check In Without Appointment"
And I execute scenario "Web Search for Outbound Trailer"
And I execute scenario "Web Select Dock Door for Check In"
And I execute scenario "Web Check In Outbound Trailer"
And I execute scenario "Web Verify Outbound Trailer Check In"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"