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
# Test Case: BASE-RCV-0110 Terminal Inbound Blind Receiving.feature
# 
# Functional Area: Receiving
# Author: Tryon Solutions 
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Terminal, MOCA
# 
# Description:
# This Test Case generates a receipt via MSQL and receives it. It specifies a part not on the receipt and receives that blind.
#
# Input Source: Test Case Inputs/BASE-RCV-0110.csv
# Required Inputs:
# 	trlr_num - This will be used as the trailer number when receiving by Trailer. If not, this will be the Receive Truck and Invoice Number
#	inv_num - This will be used as the Invoice Number when receiving by Trailer. If receiving by PO - this will not be used.
#	yard_loc - If receiving by Trailer, this is where your Trailer needs to be checked in. Must be a valid and open dock door.
#	invtyp - This need to be a valid Invoice Type, that is assigned in your system
#	prtnum - This needs to be a valid part number that is assigned in your system. Will use the default client_id.
#	rcvsts - Receiving status created on the Invoice Line being loaded
#	expqty - The number expected
# 	supnum - A valid supplier
#	rcv_qty - quantity to receive for terminal input
#	putaway_method - 1 is Directed, 2 is Sorted, 3 is Undirected.
#	asn_flg - Flag for ASN Receipts
#	actcod - Activity Code
#	rcv_prtnum - Populate this field to test blind receiving 
# Optional Inputs: 
#	validate_loc - Location to be validated for Directed Putaway, when doing Directed Putaway only
#	lotnum - Lotnum to add to the receiving line when creating the invoice and to be used for receiving if the item is lot tracked
#	rec_loc - A valid Receiving Staging lane when using sorting putaway
#	dep_loc - A valid Receiving Staging lane for deposit for undirected putaway
#	ap_sts - Valid Aging profile status, if the part has an aging profile
#	qa_sts - Valid QA Status, if the part should be received in a QA Status
#
# Assumptions:
# - Regression runs require parts and enough config to deposit inventory into the receive stage location
# - Processing will handle standard LPN flow for blind receipts, over receipts, multi-client, multi-wh, lot tracking, aging, qa directed
# - Putaway Method defaults to Undirected If I verify variable is not specified in Feature or CSV
# - Processing ends with the deposit into the rec_loc
# - Configuration for Inbound Identification/Unexpected Items must be enabled in WMS
#
# Notes:
# None
#
############################################################
Feature: BASE-RCV-0110 Terminal Inbound Blind Receiving

Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Terminal Receiving Imports"

	Then I assign "BASE-RCV-0110" to variable "test_case"
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

@BASE-RCV-0110
Scenario Outline: BASE-RCV-0110 Terminal Inbound Blind Receiving
CSV Examples: Test Case Inputs/BASE-RCV-0110.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "open the Terminal Receiving Menu"
	When I execute scenario "Terminal Login"

When I "open the Receipt, process workflow, receive each receipt line individually, and deposit to location"
	Given I "open the Receipt"
    	Then I execute scenario "Terminal LPN Receiving Menu"
		And I enter $trknum in terminal
	
	And I "check to see if we have a workflow and process the workflow"
		Then I execute scenario "Terminal Process Workflow"

	When I "perform Receiving (non-ASN)"
		Then I execute scenario "Terminal Non-ASN Receiving"

	And I "move to Product Putaway screen and process the Putaway"
    	Then I execute scenario "Terminal Trigger Product Putaway"
    	And I execute scenario "Terminal Process Product Putaway"
	
	And I "deposit the load"
		Then I execute scenario "Terminal Deposit"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"