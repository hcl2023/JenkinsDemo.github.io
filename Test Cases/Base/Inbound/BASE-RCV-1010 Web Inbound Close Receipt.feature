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
# Test Case: BASE-RCV-1010 Web Inbound Close Receipt.feature
# 
# Functional Area: Receiving
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Web, MOCA
#
# Description:
# Receive an invoice without discrepancies and with over/under discrepancies in the Web
#
# Input Source: Test Case Inputs/BASE-RCV-1010.csv
# Required Inputs:
# 	trlr_num - This will be used as the trailer number when receiving by Trailer. If not, this will be the Receive Truck and Invoice Number
#	invnum - This will be used as the Invoice Number when receiving by Trailer. If receiving by PO - this will not be used.
#	yard_loc - If receiving by Trailer, this is where your Trailer needs to be checked in. Must be a valid and open dock door.
#	invtyp - This need to be a valid Invoice Type, that is assigned in your system
#	prtnum - This needs to be a valid part number that is assigned in your system. Will use the default client_id.
#	rcvsts - Receiving status created on the Invoice Line being loaded
#	expqty - The number expected
#	rcvqty - The number being received
# 	supnum - A valid supplier
#	rec_loc - A valid Receiving Staging lane 
#	workstation - the workstation to perform the operation on, must be valid
# Optional Inputs:
# 	lotnum - Lot Number
#	revlvl - Revision Level
#
# Assumptions:
# None
#
# Notes:
# - Test Case Inputs (CSV) - Examples:
#	Example Row: expqty = rcvqty - Standard Receipt Close (Lot enabled prtnum)
#	Example Row: expqty = rcvqty - Standard Receipt Close (Lot and Revision Level enabled prtnum)
#	Example Row: expqty = rcvqty - Standard Receipt Close
# 	Example Row: expqty < rcvqty - Overreceipt Close
#	Example Row: expqty > rcvqty - Underreceipt Close
#	Example Row: expqty = rcvqty - Standard Receipt Close (without rec_loc set (system determines))
#
############################################################
Feature: BASE-RCV-1010 Web Inbound Close Receipt

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

	Then I assign "BASE-RCV-1010" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"	
	Then I assign "Close_Receipt" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"
	And I assign $trlr_num to variable "trknum"
 
After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Close_Receipt" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-RCV-1010
Scenario Outline: BASE-RCV-1010 Web Inbound Close Receipt
CSV Examples: Test Case Inputs/BASE-RCV-1010.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "login to the Web and navigate to the Inbound Shipments Screen"
	Then I execute scenario "Web Login"
	And I execute scenario "Web Open Inbound Shipments Screen"
    
And I "select a workstation to use"
	Then I execute scenario "Web Select Workstation"

When I execute scenario "Web Perform Receiving"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"