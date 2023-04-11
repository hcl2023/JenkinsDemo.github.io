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
# Test Case: BASE-YRD-8020 API Close Transport Equipment.feature
# 
# Functional Area: Yard
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: regression
# Blue Yonder Interfaces Interacted With: API, MOCA
#
# Description:
# This Test Case creates an Inbound transport equipment using MOCA, then checks it in and closes it via the API
#
# Input Source: Test Case Inputs/BASE-YRD-8020.csv
# Required Inputs:
#	trlr_num - This will be used as the transport equipment number when receiving by Transport Equipment. If not, this will be the Receive Truck and Invoice Number
#	inv_num - This will be used as the Invoice Number when receiving by Transport Equipment. If receiving by PO - this will not be used.
#	yard_loc - If receiving by Transport Equipment, this is where your Transport Equipment needs to be checked in
#	invtyp - This need to be a valid Invoice Type, that is defined in your system
#	prtnum - This needs to be a valid part number that is defined in your system
#	rcvsts - Receiving status created on the Invoice Line being loaded
#	expqty - This can be a fabrication, but assumes simple, standard LPN receiving
#	supnum - This needs to be a valid supplier, defined in your system
#	rec_loc - This is the receiving staging lane used for drop
# Optional Inputs:
#	None
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: BASE-YRD-8020 API Close Transport Equipment

Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "API Imports"

	Then I assign "BASE-YRD-8020" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"
	Then I assign "Inbound_Trailer" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"

After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Inbound_Trailer" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-YRD-8020
Scenario Outline: BASE-YRD-8020 API Close Transport Equipment
CSV Examples: Test Case Inputs/BASE-YRD-8020.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

When I "close the transport equipment using the API"
	Given I execute scenario "API Get Transport Equipment ID"
	Then I execute scenario "API Check In Transport Equipment"
	And I execute scenario "API Close Transport Equipment"

Then I "verify the results using the API"
	When I execute scenario "API Get Transport Equipment ID"
	If I verify text $trlr_stat is equal to "CLOSED"
	Else I "throw a useful error message"
		Then I assign variable "error_message" by combining "ERROR: Transport Equipment was not closed. Expected status = CLOSED, actual status = " $trlr_stat
		And I fail step with error message $error_message
	EndIf

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"