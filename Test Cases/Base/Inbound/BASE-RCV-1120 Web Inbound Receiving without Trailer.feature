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
# Test Case: BASE-RCV-1120 Web Inbound Receiving Without Trailer.feature
# 
# Functional Area: Receiving
# Author: Tryon Solutions 
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Web, MOCA
# 
# Description:
# This Test Case receives without a trailer in the Web
#
# Input Source: Test Case Inputs/BASE-RCV-1120.csv
# Required Inputs:
#	prtnum - This needs to be a valid part number that is assigned in your system
#	rcvsts - Receiving status created on the Invoice Line being loaded
#	expqty - The number expected
#	rcvqty - The number being received
# 	supnum - A valid supplier
#	rec_loc - A valid Receiving Staging lane 
#	workstation - the workstation to perform the operation on, must be valid
#	lodnum - LPN to use for the putaway
#	invtyp - This need to be a valid Invoice Type, that is assigned in your system
#	invnum - This will be used as the Invoice Number
#	ship_id - inbound shipment id
# Optional Inputs: 
#	None
#
# Assumptions:
# None
#
# Notes:
# - Test Case Inputs (CSV) - Examples:
#	Example Row:  CRDL_TO_GRAVE serialization prtnum being received - Non ASN
# 	Example Row: Non-Serialization Receive - Non ASN, Case level
# 	Example Row: Non-Serialization Receive - Non ASN, Each level
#
############################################################
Feature: BASE-RCV-1120 Web Inbound Receiving Without Trailer

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

	Then I assign "BASE-RCV-1120" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"
	Then I assign "Rcv_No_Trailer" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"
 
After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Rcv_No_Trailer" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-RCV-1120
Scenario Outline: BASE-RCV-1120 Web Inbound Receiving Without Trailer
CSV Examples: Test Case Inputs/BASE-RCV-1120.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "login to the Web interface"
	Then I execute scenario "Web Login"
    
And I "select a workstation to use"
	Then I execute scenario "Web Select Workstation"

And I "navigate to the Inbound Shipments Screen"
	And I execute scenario "Web Open Inbound Shipments Screen"

When I "Receive without Trailer"
	Then I execute scenario "Web Receiving Without Trailer"
	And I execute scenario "Validate Putaway Process"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"