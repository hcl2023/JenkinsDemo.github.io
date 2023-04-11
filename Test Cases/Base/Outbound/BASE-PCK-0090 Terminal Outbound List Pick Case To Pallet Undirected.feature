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
# Test Case: BASE-PCK-0090 Terminal Outbound List Pick Case To Pallet Undirected.feature
# 
# Functional Area: Picking
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Terminal, MOCA
#
# Description:
# This Test Case performs Terminal Directed List Pick Case To Pallet
#
# Input Source:Test Case Inputs/BASE-PCK-0090.csv
# Required Inputs:
# 	ordnum - This will be used as the ordnum when creating when creating carton pick data
# 	ship_id - This will be used as the ship_id when creating carton pick data
# 	adr_id - This will be used as the adr_id when creating carton pick data
# 	cstnum - This will be used as the cstnum when creating carton pick data
# 	carcod - This will be used as the carrier for the shipment when creating carton pick data - this needs to be a valid carrier configured in the system
# 	srvlvl - This will be used as the service level for the shipment when creating carton pick data - this needs to be a valid service level for the carrier configured in the system
# 	ordtyp - This will be used as the order type for the order when creating carton pick data - this needs to be a valid ordtyp configured in the system
# 	prtnum - This will be used as the prtnum for the order - this needs to be a valid prtnum configured in the system - there must to be sufficient allocatable and pickable inventory of this item in the warehouse
# 	untqty - This will be used as the order qty for the order - this needs to be a valid number
# 	invsts_prg - This will be used as the inventory status progression on the order line - this needs to be a valid invsts_prg configured in the system
# 	wave_num - This will be used as the wave number for the shipment when creating carton pick data
# 	move_id - This will be used as the move ID assigned to the trailer when creating carton pick data
# 	trlr_id - This will be used as the trailer ID for the trailer when creating carton pick data
# 	dock - This will be used as the dock location for the trailer when creating carton pick data
# 	bckflg - This is what the backorder flag will be set as on the order line.  It defaults to 0 if nothing is passed in
# 	cancel_no_reallocate - This determines if cancelling and reallocating picks inline
# 	oprcod - This will be used to validate the type of operation performed
# Optional Inputs:
#	None
#
# Assumptions:
# - There is sufficient inventory in the warehouse to allocate a List pick of the assigned prtnum if using the dataset
#
# Notes:
# - Supply values for required and desired variables that adhere to the requirements of the system.
# - Test Case Inputs (CSV) - Examples:
#	Example Row: List Pick Case To Pallet Undirected work with CRADLE_TO_GRAVE serialization
#	Example Row: List Pick Case To Pallet Undirected work with OUTCAP_ONLY serialization
#	Example Row: List Pick Case To Pallet Undirected work with no serialization
#
############################################################
Feature: BASE-PCK-0090 Terminal Outbound List Pick Case To Pallet Undirected

Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Terminal Picking Imports"

	Then I assign "BASE-PCK-0090" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"
	Then I assign "Allocate_List_Picks" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"

After Scenario:
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Allocate_List_Picks" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-PCK-0090
Scenario Outline: BASE-PCK-0090 Terminal Outbound List Pick Case To Pallet Undirected
CSV Examples: Test Case Inputs/BASE-PCK-0090.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"
   
Then I "login to the terminal and navigate to the Work Assignment screen"
	And I execute scenario "Terminal Login"
	And I execute scenario "Terminal Work Assignment Menu"

When I execute scenario "Terminal Perform Undirected List Pick for Order"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"