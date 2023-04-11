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
# Test Case: BASE-YRD-1030 Web Inbound Trailer Check In with Safety Check.feature
# 
# Functional Area: Inbound
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: regression
# Blue Yonder Interfaces Interacted With: WEB, MOCA 
#
# Description:
# This Test Case checks in an Inbound trailer and processes enabled Safety Checks in he Web
#
# Input Source: Test Case Inputs/BASE-YRD-1030.csv
# Required Inputs:
#	trlr_num - This will be used as the trailer number when receiving by Trailer. If not, this will be the Receive Truck and Invoice Number
#	inv_num - This will be used as the Invoice Number when receiving by Trailer. If receiving by PO - this will not be used.
#	yard_loc - If receiving by Trailer, this is where your Trailer needs to be checked in
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
Feature: BASE-YRD-1030 Web Inbound Trailer Check In with Safety Check
 
Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Web Inbound Trailer Imports"
	And I execute scenario "Web Environment Setup"

	Then I assign "BASE-YRD-1030" to variable "test_case"
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

@BASE-YRD-1030
Scenario Outline: BASE-YRD-1030 Web Inbound Trailer Check In with Safety Check
CSV Examples: Test Case Inputs/BASE-YRD-1030.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "log into the web and navigate to the transport equipment screen"
	And I execute scenario "Web Login"
	And I execute scenario "Web Open Receiving Transport Equipment Screen"

And I execute scenario "Web Search for Inbound Trailer"
And I execute scenario "Web Check In Inbound Trailer"
And I execute scenario "Web Verify Inbound Trailer Check In"
When I execute scenario "Web Process Inbound Trailer Safety Check"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"