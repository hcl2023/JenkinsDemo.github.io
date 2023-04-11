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
# Test Case: BASE-RCV-1070 Web Inbound Create Inbound Shipment.feature
# 
# Functional Area: Receiving
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Web, MOCA
#
# Description:
# This test case creates an Inbound Shipment from the Web.
#
# Input Source: Test Case Inputs/BASE-RCV-1070.csv
# Required Inputs:
#	trknum - The truck number of the inbound shipment
#	rcpt_area - The receipt area for the inbound shipment
#	rcvtrk_stat - The inbound shipment status code
# Optional Inputs:
#	None
#
# Assumptions:
#	- no dataset load is needed
#
# Notes:
# None
#
############################################################
Feature: BASE-RCV-1070 Web Inbound Create Inbound Shipment
 
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

	Then I assign "BASE-RCV-1070" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "cleanup the dataset, since there was no initial dataset to load"
	Then I assign "RCV_Inbound_Shipment" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"
    
After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "RCV_Inbound_Shipment" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-RCV-1070
Scenario Outline: BASE-RCV-1070 Web Inbound Create Inbound Shipment
CSV Examples: Test Case Inputs/BASE-RCV-1070.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

When I execute scenario "Web Login"
Then I execute scenario "Web Open Inbound Shipments Screen"
And I execute scenario "Web Open Add Inbound Shipment Window" 
And I execute scenario "Web Enter Inbound Shipment Information"
And I execute scenario "Validate Inbound Shipment"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"