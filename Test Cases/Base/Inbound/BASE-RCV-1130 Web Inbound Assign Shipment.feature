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
# Test Case: BASE-RCV-1130 Web Inbound Assign Shipment.feature
# 
# Functional Area: Receiving
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Web, MOCA
#
# Description:
# This test case will Assign transport Equipment to Shipment 
#
# Input Source: Test Case Inputs/BASE-RCV-1130.csv
# Required Inputs:
# 	trlr_num - Name of the Transport Equipment
#	exp_arecod - Expected area code
#	trlr_num - Transport Equipment Number
#	trlr_cod - Transport Equipment Code
#	trlr_typ - Transport Equipment Type
#	trlrcnt - Trailer count
# Optional Inputs:
#	None
#
# Assumptions:
# 	None 
#
# Notes:
# None
#
############################################################
Feature: BASE-RCV-1130 Web Inbound Assign Shipment
 
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

	Then I assign "BASE-RCV-1130" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"	
	Then I assign "Create_Ship_and_Trailer" to variable "dataset_directory"   
	And I execute scenario "Perform MOCA Dataset"
 
After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Create_Ship_and_Trailer" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-RCV-1130
Scenario Outline: BASE-RCV-1130 Web Inbound Assign Shipment
CSV Examples: Test Case Inputs/BASE-RCV-1130.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "log into the Web Browser and navigate to shipments screen"
	Then I execute scenario "Web Login"
	And I execute scenario "Web Open Inbound Shipments Screen"

When I execute scenario "Web Assign Inbound Shipment"

And I execute scenario "Validate Trailer Assign to Shipment"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"