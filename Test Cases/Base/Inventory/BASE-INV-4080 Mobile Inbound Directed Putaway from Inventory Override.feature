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
# Test Case: BASE-INV-4080 Mobile Inbound Directed Putaway from Inventory Override.feature
# 
# Functional Area: Inventory
# Author: Tryon Solutions 
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Mobile, MOCA
#
# Description: This Test Case generates an LPN to perform a putaway and during operation overrides the putaway location.
#
# Input Source: Test Case Inputs/BASE-INV-4080.csv
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
# 	lodnum - Load number being adjusted in. Can be a fabricated number. Used in Mobile App and datasets processing
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
#	override_f2 - use F2 to display override code during putway and selects one
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
# - Processing ends with the deposit into the over_dep_loc
#
############################################################
Feature: BASE-INV-4080 Mobile Inbound Directed Putaway from Inventory Override

Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Mobile Inventory Imports"

	Then I assign "BASE-INV-4080" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"	
	Then I assign "Putaway" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"
	And I assign $dep_loc to variable "count_location"

After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Putaway" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-INV-4080
Scenario Outline: BASE-INV-4080 Mobile Inbound Directed Putaway from Inventory Override
CSV Examples: Test Case Inputs/BASE-INV-4080.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I execute scenario "Mobile Login"

When I "Perform the Putaway Directed with override (F4)"
	Then I execute scenario "Mobile Putaway Menu"
	And I execute scenario "Mobile Inventory Putaway Directed Override"
    
And I "cancel the cycle count generated on override location based on override code"
	Then I execute scenario "Cancel Cycle Count"
    
And I "verify LPN is deposited properly"
	And I execute scenario "Validate Putaway Was Successful"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"