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
# Test Case: BASE-SHP-0030 Terminal Unload and Unpick Shipment.feature
#
# Functional Area: Loading
# Author: Tryon Solutions 
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: MOCA, Terminal
#
# Description: This test case will unload a shipping trailer, and unpick the inventory that was picked for the shipment.
#
# Input Source: Test Case Inputs/BASE-SHP-0030.csv
# Required Inputs:
# 	ordnum -  Order number when creating the order to be loaded onto the trailer. Must not match any existing ordnum in the warehouse
#	ship_id - Shipment id used when creating the shipment to be loaded onto the trailer. Must not match any existing ship_id in the warehouse
# 	adr_id - Address Id used when creating the order to be loaded onto the trailer. Must not match any existing adr_id in the warehouse
# 	cstnum - Customer Number when creating the order to be loaded onto the trailer. Must not match any existing cstnum in the warehouse
# 	carcod - Carrier Code used for the shipment. Must to be a valid carrier configured in the system
# 	srvlvl - Service Level used for the shipment - Must be a valid service level for the carrier configured in the system
# 	ordtyp - Order type for the order. Must be a valid ordtyp configured in the system
# 	prtnum - Part Number for the order.  Must be a valid prtnum configured in the system.
#			 There must to be sufficient allocatable and pickable inventory of this item in the warehouse
# 	untqty - Order qty for the order line
# 	invsts_prg - Inventory status progression on the order line.  Must be a valid invsts_prg configured in the system
# 	wave_num - Wave number for the shipment. Must not match any existing wave number in the warehouse
# 	move_id - Carrier Move ID assigned to the trailer. Must not match any existing carrier move in the warehouse
# 	trlr_id - Trailer ID for the trailer. Must not match any existing trailer in the warehouse
# 	dock - Dock location for the trailer.  Must be a valid and open shipping dock door in the warehouse
#	load_stop - If we want to create a load stop
#	close_trailer - If we want to close the trailer 
#	shpstg_loc - Shipment staging location to unload the inventory to.
#	ok_to_unpick - If we want to unpick inventory after unloading trailer. Can take only 'Y' or 'N'
#	unpick_partial - If we want to unpick partial inventory where applicable.
#	cancod - cancel code used for unpicking. Must be a valid code defined in the system.
#	putaway_method - 1 for directed, 2 for sorted, 3 for undirected.
#	dep_loc - Location to deposit unpicked inventory.
# Optional Inputs:  
# 	None
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: BASE-SHP-0030 Terminal Unload and Unpick Shipment

Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Terminal Unloading Imports"

	Then I assign "BASE-SHP-0030" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"
	Then I assign "Web_Outbound_Trailer_Common" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"

After Scenario:
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Web_Outbound_Trailer_Common" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

	And I "use the Unpick Dataset to cleanup the resulting deposit of the unpick after unload"
		If I verify variable "pck_lodnum" is assigned
			Then I assign "Unpicking" to variable "cleanup_directory"
			And I execute scenario "Perform MOCA Cleanup Script"
		EndIf

@BASE-SHP-0030
Scenario Outline: BASE-SHP-0030 Terminal Unload and Unpick Shipment
CSV Examples: Test Case Inputs/BASE-SHP-0030.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "log into terminal and navigate to the Unload Equipment menu"
	And I execute scenario "Terminal Login"
	And I execute scenario "Terminal Navigate to Unload Equipment Menu"
    
When I "Unload the equipment"
	Then I execute scenario "Terminal Outbound Unload and Unpick Shipment"
    
And I "verify the equipment was unloaded and inventory unpicked" 
	Then I execute scenario "Validate Unload and Unpick Equipment"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"