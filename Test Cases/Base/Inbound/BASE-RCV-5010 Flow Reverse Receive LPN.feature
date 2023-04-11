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
# Test Case: BASE-RCV-5010 Flow Reverse Receive LPN.feature
# 
# Functional Area: Receiving
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Terminal, MOCA, Web
#
# Description:
# Performs Terminal Reverse Receiving, verifying the inbound shipment details in Web and then receives back the reversed LPN
#
# Input Source: Test Case Inputs/BASE-RCV-5010.csv
# Required Inputs:
# 	trlr_num - This will be used as the trailer number when receiving by Trailer. If not, this will be the Receive Truck and Invoice Number
# 	invnum - This will be used as the Invoice Number when receiving by Trailer. If receiving by PO - this will not be used.
# 	yard_loc - If receiving by Trailer, this is where your Trailer needs to be checked in. Must be a valid and open dock door.
# 	invtyp - This need to be a valid Invoice Type, that is assigned in your system
# 	prtnum_1,prtnum_2 - valid part number(s) that are assigned in your system. Will use client_id in Environment.feature
# 	rcvsts - Receiving status created on the Invoice Line being loaded
# 	expqty_1,expqty_2 - Exepected quantities
# 	actcod - Activity Code
# 	supnum - This needs to be a valid supplier, assigned in your system
# 	uomcod_1,uomcod_2 - valid Unit(s) of Measure
# 	ftpcod_1,ftpcod_2 - valid footprint(s) code
# 	lodnum_1,lodnum_2 - the load number(s)
# 	invsts - a valid inventory status 
# 	rec_loc - A valid Receiving Staging lane when using sorting putaway
# 	dep_loc - A valid Receiving Staging lane for deposit for undirected putaway
# 	create_trailer - if 'Y' performs creation of receving trailer
# 	create_inbshp - if 'Y' performs creation of inbound shipment
# 	create_inbord - if 'Y' performs creation of inbound order 
# 	checkin_trailer - if 'Y' performs checkin of trailer 
# 	create_asn - if 'Y' performs creation of ASN 
# 	putaway - if 'Y' performs putaway process
# 	no_of_rcvlins - number of receive lines needs to be created
# 	putaway_method - 1 is Directed, 2 is Sorted, 3 is Undirected.
# Optional Inputs:
# 	lotnum - Lotnum to add to the receiving line when creating the invoice and to be used for receiving if the item is lot tracked
# 	receive_reversed_lpn - if 'Y' performs Terminal Receive a Reversed LPN 
# 	validate_load_loc - if 'Y' verifies reversed LPN is deposited to receive staging lane
#
# Assumptions:
# - Load is received and trailer is not dispatched/closed
#
# - Test Case Inputs (CSV) - Examples:
# 	Example Row: Reverse receive LPN in Terminal, verifies the Inbound Shipment details in the Web
# 	Example Row: Reverse receive LPN in Terminal, verifies the Inbound Shipment details in Web and receives back the reversed LPN in the Terminal
#
############################################################
Feature: BASE-RCV-5010 Flow Reverse Receive LPN
 
Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"
	
	Then I assign "BASE-RCV-5010" to variable "test_case"
	When I execute scenario "Test Data Triggers"

	Given I execute scenario "Terminal Receiving Imports"
	And I execute scenario "Web Receiving Imports"
	And I execute scenario "Web Environment Setup"

And I "load the dataset"	
	Then I assign "Receiving_Multiple_loads" to variable "dataset_directory"    
	And I execute scenario "Perform MOCA Dataset"
	And I assign $trlr_num to variable "trknum"
	And I assign $prtnum_2 to variable "prtnum"
	And I assign $lodnum_2 to variable "lpn"
	And I assign $lpn to variable "lodnum"
	And I assign $expqty_2 to variable "rcv_qty"

After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Receiving_Multiple_loads" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-RCV-5010
Scenario Outline: BASE-RCV-5010 Flow Reverse Receive LPN
CSV Examples: Test Case Inputs/BASE-RCV-5010.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "open the Terminal Receiving Menu"
	And I execute scenario "Terminal Login"
	And I execute scenario "Terminal LPN Reverse Receipt Menu"

When I "reverse the Receipt"
	And I execute scenario "Terminal Reverse Receipt"
	Then I wait $wait_med seconds

Then I "open the Inbound Shipment Details"
	Given I execute scenario "Web Login"
	Then I execute scenario "Web Open Inbound Shipments Screen"
	And I execute scenario "Web Inbound Shipments Search for Shipment"
	And I execute scenario "Web Open Inbound Shipment Details"

Then I "validate reversed LPN details on Inbound Shipment Details"
	And I execute scenario "Web Validate Reversed LPN on Inbound Shipment Details Screen"

Then I "receive a Reversed LPN"
	If I verify variable "receive_reversed_lpn" is assigned
	And I verify text $receive_reversed_lpn is equal to "Y" ignoring case
		Given I "navigate to the undirected menu"
			Then I execute scenario "Terminal Navigate to Undirected Menu"

		When I "open the Receipt,receive a reversed LPN and deposit to location"
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
	Endif

And I "verify reversed LPN is deposited to receive staging lane"
	If I verify variable "validate_load_loc" is assigned 
	And I verify text $validate_load_loc is equal to "Y" ignoring case
		Then I execute scenario "Validate Putaway Was Successful"
	EndIf

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"