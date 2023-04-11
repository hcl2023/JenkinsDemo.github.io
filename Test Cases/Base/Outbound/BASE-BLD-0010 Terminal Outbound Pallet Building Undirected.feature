############################################################
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
# Test Case: BASE-BLD-0010 Terminal Outbound Pallet Building Undirected.feature
# 
# Functional Area: Pallet Building
# Author: Tryon Solutions
# Blue Yonder WMS Version:  Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Terminal, MOCA
#
# Description: This Test Case performs terminal undirected pallet building in the Terminal
#
# Input Source: Datasets/Test Case Inputs/BASE-PCK-0010.csv
# Required Inputs:
# 	ordnum - This will be used as the ordnum when creating when creating carton/ list pick data
# 	ship_id - This will be used as the ship_id when creating carton/ list pick data
# 	adr_id - This will be used as the adr_id when creating carton/ list pick data
# 	cstnum - This will be used as the cstnum when creating carton/ list pick data
# 	carcod - This will be used as the carrier for the shipment when creating carton/ list pick data - this needs to be a valid carrier configured in the system
# 	srvlvl - This will be used as the service level for the shipment when creating carton/ list pick data - this needs to be a valid service level for the carrier configured in the system
# 	ordtyp - This will be used as the order type for the order when creating carton/ list pick data - this needs to be a valid ordtyp configured in the system
# 	prtnum - This will be used as the prtnum for the order - this needs to be a valid prtnum configured in the system - there must to be sufficient allocatable and pickable inventory of this item in the warehouse
# 	untqty - This will be used as the order qty for the order - this needs to be a valid number
# 	invsts_prg - This will be used as the inventory status progression on the order line - this needs to be a valid invsts_prg configured in the system
# 	wave_num - This will be used as the wave number for the shipment when creating carton/ list pick data
# 	move_id - This will be used as the move ID assigned to the trailer when creating carton/ list pick data
# 	trlr_id - This will be used as the trailer ID for the trailer when creating carton/ list pick data
# 	dock - This will be used as the dock location for the trailer when creating carton/ list pick data
#	pck_dstloc - This will be used as the location the order is picked to, this number must be a valid location that can be picked to in the warehouse such as an RDT location
#	pb_stage_loc - Pallet building staging location. This is the location inventory is deposited to before pallet building. Inventory in this location is eligible for pallet building.
# Optional Inputs:
#	pb_max_carton_count - This variable can be used to set a maximum number of cartons to pallet build onto a given pallet. Once the max number of cartons has been added to the pallet, the feature will close the pallet. If this value is not defined, or if the number of cartons to pallet build is less than this value, then the system will automatically close the pallet once all cases have been added to the pallet
#
# Assumptions:
# - Pass the pallet building staging location where cartons will be built into a pallet
# - System is configured to have movement paths that will force a pallet building hop before final staging for sub load level picks.
# - There is sufficient inventory in the correct location (derived in accordance with pick zone and pick method to create sub load level pick) to fulfill the order that is created with the dataset.
#
# Notes:
# None
#
############################################################
Feature: BASE-BLD-0010 Terminal Outbound Pallet Building Undirected

Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Terminal Pallet Building Imports"

	Then I assign "BASE-BLD-0010" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"	
	Then I assign "Pallet_Building_Undirected" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"

After Scenario:
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Pallet_Building_Undirected" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"
 
@BASE-BLD-0010
Scenario Outline: BASE-BLD-0010 Terminal Outbound Pallet Building Undirected
CSV Examples: Test Case Inputs/BASE-BLD-0010.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I execute scenario "Terminal Login"
And I execute scenario "Open Pallet Building Menu Option"
When I execute scenario "Terminal Pallet Building"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"