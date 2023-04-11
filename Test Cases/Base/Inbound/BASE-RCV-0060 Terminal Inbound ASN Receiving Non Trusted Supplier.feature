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
# Test Case: BASE-RCV-0060 Terminal Inbound ASN Receiving Non Trusted Supplier.feature
# 
# Functional Area: Receiving
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Terminal, MOCA
#
# Description:
# This Test Case generates an ASN receipt from a non-trusted supplier via MSQL and receives it.
#
# Input Source: Test Case Inputs/BASE-RCV-0060.csv
# Required Inputs:
#	asn_lodnum - the user-provided LPN value to create inventory
#	ftpcod - a valid footprint code for inventory creation
# 	trlr_num - This will be used as the trailer number when receiving by Trailer. If not, this will be the Receive Truck and Invoice Number
#	inv_num - This will be used as the Invoice Number when receiving by Trailer. If receiving by PO - this will not be used.
#	yard_loc - If receiving by Trailer, this is where your Trailer needs to be checked in. Must be a valid and open dock door.
#	invtyp - This need to be a valid Invoice Type, that is assigned in your system
#	prtnum - This needs to be a valid part number that is assigned in your system. Will use the default client_id.
#	rcvsts - Receiving status created on the Invoice Line being loaded
#	expqty - The number expected- to be inputted as receive quantity
# 	supnum - A valid supplier
#	putaway_method - 3 is Undirected.
#	asn_flg - Flag for ASN Receipts
#	actcod - Activity Code
#	rcv_uom - Unit of measure upon receipt
# Optional Inputs: 
#	rec_loc - A valid Receiving Staging lane when using sorting putaway
#	dep_loc - A valid Receiving Staging lane for deposit for undirected putaway
#	ap_sts - Valid Aging profile status, if the part has an aging profile
#	chg_rcv_sts - Valid Inv Status, if the inventory status needs to be changed on receipt
#	rcv_qty - quantity to receive, if quantity needs to be changed on receipt
#	chg_qty- flag that prompts recieve quantity to be overriden, if receive quantity needs to be changed upon receipt
#	chg_uom - flag that prompts uom to be overriden, if unit of measure needs to be changed on receipt
#	chg_sts - flag that prompts invsts to be overriden, if the inventory status needs to be changed on receipt
# 	expire_dte - set value for ASN Inventory with Expiration Dates
#
# Assumptions:
# - Regression runs require parts and enough config to deposit inventory into the rec_loc
# - Processing will handle standard LPN flow for blind receipts, over receipts, multi-client, multi-wh, lot tracking, aging
# - Undirected putaway method is used for this test.
# - Processing ends with the deposit into the rec_loc
# - This Test Case will only be used for vehicle types configured to hold a single load
# - The system is configured for the Putaway Method chosen
# - There is an existing LOTNUM in the system for the item being received
# - Supplier is setup as non trusted supplier.
# - Test performed for non serialized inventory.
#
# Notes:
# - Test Case Inputs (CSV) - Examples:
#	Example Row: Not changing any of the ASN LPN attributes
# 	Example Row: Changing Receive Quantity of the ASN LPN
#	Example Row: Changing the Receive Quantity and Unit of Measure of the ASN LPN
#	Example Row: Changing the Receive Quantity, Unit of Measure and Inventory Status of the ASN LPN
#	Example Row: Changing the Receive Quantity, Unit of Measure and Inventory Status of the ASN LPN with CRDL_TO_CRAVE serialized prtnum
#	Example Row: Changing the Receive Quantity, Unit of Measure and Inventory Status of the ASN LPN with OUTCAP_ONLY serialized prtnum
#	Example Row: Not changing any of the ASN LPN attributes (detail level CRDL_TO_CRAVE serialized prtnum)
#
############################################################
Feature: BASE-RCV-0060 Terminal Inbound ASN Receiving Non Trusted Supplier
 
Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Then I assign "BASE-RCV-0060" to variable "test_case"
	When I execute scenario "Test Data Triggers"
	
	Given I execute scenario "Terminal Receiving Imports"

And I "load the dataset"	
	Then I assign "Rec_ASN_NT_Supplier_Receiving" to variable "dataset_directory"    
	And I execute scenario "Perform MOCA Dataset"
	And I assign $trlr_num to variable "trknum"
 
Then I "check for serialization and add required serial numbers to ASN"
	And I execute scenario "Get Item Serialization Type"
	If I verify text $serialization_type is equal to "CRDL_TO_GRAVE"
		Then I assign $asn_lodnum to variable "lodnum"
		And I assign $trlr_num to variable "srcloc"
		And I execute scenario "Add Serial Numbers for Cradle to Grave"
	EndIf
 
After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Rec_ASN_NT_Supplier_Receiving" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"
 
@BASE-RCV-0060
Scenario Outline: BASE-RCV-0060 Terminal Inbound ASN Receiving Non Trusted Supplier
CSV Examples: Test Case Inputs/BASE-RCV-0060.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "login to the Terminal"
	When I execute scenario "Terminal Login"

When I "open the Receipt, process workflow, receive each receipt line individually, and deposit to location"
	Given I "open the Receipt"
    	Then I execute scenario "Terminal LPN Receiving Menu"
		And I enter $trknum in terminal
	
	And I "check to see if we have a workflow and process the workflow"
		Then I execute scenario "Terminal Process Workflow"

	When I "perform Receiving (ASN) from a non-trusted supplier"
		Then I execute scenario "Terminal ASN Receiving Non-Trusted Supplier"

	And I "move to Putaway screen and process the Putaway"
    	Then I execute scenario "Terminal Trigger Product Putaway"
    	And I execute scenario "Terminal Process Product Putaway"

	And I "deposit the load"
		Then I execute scenario "Terminal Deposit"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"