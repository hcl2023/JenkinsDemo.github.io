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
# Test Case: BASE-RCV-4020 Mobile Inbound Putaway.feature
# 
# Functional Area: Receiving
# Author: Tryon Solutions 
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Mobile, MOCA
#
# Description: This Test Case generates an LPN to perform an Undirected Putaway in Mobile App
#
# Input Source: Test Case Inputs/BASE-RCV-4020.csv
# Required Inputs:
# 	wh_id - Warehouse ID
# 	trlr_num - Trailer Number
#	inv_num - Inventory number. Can be set to match the trlr_num
#	yard_loc - Yard location
#	invtyp - Inventory type
#	rcvsts - Receive status
#	expqty - Expected quantity for the receipt
#	supnum - Supplier Number
#	rec_loc - Receive location. Where the load will be received
#	uomcod - UOM Code
# 	lodnum - Load number being adjusted in. Can be a fabricated number. Used in Terminal and datasets processing
# 	invsts - Inventory status. This needs to be a valid inventory status in your system
#	dep_loc - Deposit location. Where the load will be deposited
# 	prtnum - Needs to be a valid part number that is assigned in your system
#	ftpcod - Footprint Code. Must be a valid footprint code for the given prtnum
# 	untqty - Quantity being added
#	allocate - Boolean specifying whether to allocate
#	override - Boolean specifying whether there exists an override
#	over_code - Overage code
#	over_dep_loc - Overage deposit location. Where overages will be deposited to (if allowed).
#	actcod - Action code
#	carcod - Carrier code of the trailer
# Optional Inputs:
# 	None
#
# Assumptions:
# - Receiving can continue whether there are overages or shorts.
#
# Notes:
# - Regression runs require parts and enough config to deposit inventory into the receive stage location
# - Processing will handle standard LPN flow for blind receipts, over receipts, multi-client, multi-wh, lot tracking, aging, qa directed  
# - Processing ends with the deposit into the dep_loc
#
############################################################
Feature: BASE-RCV-4020 Mobile Inbound Putaway

Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Mobile Receiving Imports"

	Then I assign "BASE-RCV-4020" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"	
	Then I assign "Putaway" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"
	And I assign $trlr_num to variable "trknum"
 
After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Putaway" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-RCV-4020
Scenario Outline: BASE-RCV-4020 Mobile Inbound Putaway
CSV Examples: Test Case Inputs/BASE-RCV-4020.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I execute scenario "Mobile Login"

When I "perform the Putaway"
	Then I execute scenario "Mobile Putaway Menu"
	And I execute scenario "Mobile Undirected Putaway"

And I "validate the Load Was Deposited"
	If I execute scenario "Validate Putaway Was Successful"
		Then I echo "Successfully completed putaway!"
	# If the above scenario fails, we know $error_message was set within said scenario
	Else I fail step with error message $error_message
	EndIf
    
Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"