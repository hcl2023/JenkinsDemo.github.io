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
# Test Case: BASE-PCK-4020 Mobile Outbound Carton Picking Undirected and Reallocate.feature
# 
# Functional Area: Picking
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Mobile, MOCA
#
# Description:
# This test case performs Mobile App Undirected Carton Picking and a Cancel Pick
#
# Input Source: Test Case Inputs/BASE-PCK-4020.csv
# Required Inputs:
# 	ordnum - This will be used as the ordnum when creating when creating carton pick data
# 	ship_id - This will be used as the ship_id when creating carton pick data
# 	adr_id - This will be used as the adr_id when creating carton pick data
# 	cstnum - This will be used as the cstnum when creating carton pick data
# 	carcod - This will be used as the carrier for the shipment when creating carton pick data - this needs to be a valid carrier configured in the system
# 	srvlvl - This will be used as the service level for the shipment when creating carton pick data - this needs to be a valid service level for the carrier configured in the system
# 	ordtyp - This will be used as the order type for the order when creating carton pick data - this needs to be a valid ordtyp configured in the system
# 	prtnum - This will be used as the prtnum for the order - this needs to be a valid prtnum configured in the system - there must to be sufficient allocatable and pickable inventory of this item in the warehouse
# 	unqty - This will be used as the order qty for the order - this needs to be a valid number
# 	invsts_prg - This will be used as the inventory status progression on the order line - this needs to be a valid invsts_prg configured in the system
# 	wave_num - This will be used as the wave number for the shipment when creating carton pick data
# 	move_id - This will be used as the move ID assigned to the trailer when creating carton pick data
# 	trlr_id - This will be used as the trailer ID for the trailer when creating carton pick data
# 	dock - This will be used as the dock location for the trailer when creating carton pick data
# 	cancel_pick_flag - This determines if cancelling and reallocating picks inline
#	cancel_code - This is the WMS cancel code used for cancelling picks
# Optional Inputs:
#	None
#
# Assumptions:
# - Pass the Order Number in and all cartons for that order will be batched for Undirected Carton Picking.
# - Will cancel and reallocate the first carton pick and continue picking the remaining carton picks.
# - There is sufficient inventory in the warehouse to allocate a carton pick of the assigned prtnum.
# - If picking serialized inventory, the requirements for serial picking detailed in Serialization Utilities.feature are met.
#
# Notes:
# - Supply values for required and desired variables that adhere to the requirements of the system.
#
############################################################
Feature: BASE-PCK-4020 Mobile Outbound Carton Picking Undirected and Reallocate

Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Mobile Picking Imports"

	Then I assign "BASE-PCK-4020" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"
	Then I assign "Allocate_Carton_Picks" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"

After Scenario:
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Allocate_Carton_Picks" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-PCK-4020
Scenario Outline: BASE-PCK-4020 Mobile Outbound Carton Picking Undirected and Reallocate
CSV Examples: Test Case Inputs/BASE-PCK-4020.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "login to the Mobile App and navigate to the Carton Pick Menu"
	And I execute scenario "Mobile Login"
	And I execute scenario "Mobile Navigate to Carton Pick Menu"

Then I "assign variables to force the first pick to be canceled and reallocated"
    Given I assign value "TRUE" to unassigned variable "cancel_pick_flag"
    And I assign value "C-RA" to unassigned variable "cancel_code"
    
When I execute scenario "Mobile Perform Carton Picks for Order"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"