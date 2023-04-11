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
# Test Case: BASE-RCV-1150 Web Inbound Capture Quality Incident.feature
# 
# Functional Area: Receiving
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Web, MOCA
#
# Description:
# This test case captures a inbound quality incident for shipment from the Web.
#
# Input Source: Test Case Inputs/BASE-RCV-1150.csv
# Required Inputs:
# 	trlr_num - This will be used as the trailer number when receiving by Trailer. If not, this will be the Receive Truck and Invoice Number
#	inv_num - This will be used as the Invoice Number when receiving by Trailer. If receiving by PO - this will not be used.
#	yard_loc - If receiving by Trailer, this is where your Trailer needs to be checked in. Must be a valid and open dock door.
#	invtyp - This need to be a valid Invoice Type, that is assigned in your system
#	prtnum - This needs to be a valid part number that is assigned in your system. Will use the default client_id.
#	rcvsts - Receiving status created on the Invoice Line being loaded
#	expqty - The number expected
#	issue_type - Specifies whether this was a Carrier or Supplier quality issue.
#	issue_rsn - The reason for the quality issue.
#	inbqty - The quantity of quality issues.
#	supnum - The supplier of the quality issue.
#	carcod - The carrier of the quality issue.
#	ib_issue - The code for the quality issue.
#	check_report_issue_screen - Validates the current screen for Report Quality Issue or Add Quality Issue
# Optional Inputs:
#	None
#
# Assumptions:
#	None
#
# Notes:
# - Test Case Inputs (CSV) - Examples:
#	Example Row: Execution with Carrier damage
#	Example Row: Execution with Supplier damage
#
############################################################
Feature: BASE-RCV-1150 Web Inbound Capture Quality Incident
 
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

	Then I assign "BASE-RCV-1150" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"
	Then I assign "Receiving" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"
	And I assign $trlr_num to variable "trknum"
 
After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Receiving" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-RCV-1150
Scenario Outline: BASE-RCV-1150 Web Inbound Capture Quality Incident
CSV Examples: Test Case Inputs/BASE-RCV-1150.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Given I execute scenario "Web Login"
Then I execute scenario "Web Open Inbound Shipments Screen"
And I execute scenario "Web Inbound Shipments Search for Shipment"
And I execute scenario "Web Open Inbound Shipment Details"
And I execute scenario "Web Open Report Quality Issue Screen"
And I execute scenario "Web Add Report Quality Issues Information"
And I execute scenario "Web Open Inbound Quality Issues Screen"
And I execute scenario "Web Validate Report Quality Issue Created"
And I execute scenario "Validate Inbound Quality Issue Created"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"