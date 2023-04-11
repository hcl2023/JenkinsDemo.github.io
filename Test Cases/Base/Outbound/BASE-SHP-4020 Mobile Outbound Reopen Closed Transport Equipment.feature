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
# Test Case: BASE-SHP-4020 Mobile Outbound Reopen Closed Transport Equipment.feature
#
# Functional Area: Loading
# Author: Tryon Solutions 
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: MOCA, Mobile
#
# Description: 
# This test case will reopen closed transport equipment in the Mobile App
#
# Input Source: Test Case Inputs/BASE-SHP-4020.csv
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
Feature: BASE-SHP-4020 Mobile Outbound Reopen Closed Transport Equipment

Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Mobile Loading Imports"

	Then I assign "BASE-SHP-4020" to variable "test_case"
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

@BASE-SHP-4020
Scenario Outline: BASE-SHP-4020 Mobile Outbound Reopen Closed Transport Equipment
CSV Examples: Test Case Inputs/BASE-SHP-4020.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "log into Mobile App and navigate to the Reopen Equipment menu"
	And I execute scenario "Mobile Login"
	And I execute scenario "Mobile Navigate to Reopen Equipment Menu"
    
When I "reopen the closed transport equipment"
	Then I execute scenario "Mobile Outbound Trailer Reopen"

And I "verify the closed transport equipment is opened" 
	Then I execute scenario "Validate Trailer Reopened"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"