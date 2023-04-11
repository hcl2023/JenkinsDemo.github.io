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
# Test Case: BASE-SHP-1020 Web Outbound Trailer Dispatch
#
# Functional Area: Yard
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: regression
# Blue Yonder Interfaces Interacted With: WEB, MOCA
# 
# Description:
# This test case will handle dispatching a trailer in the Web
#
# Input Source: Test Case Inputs/BASE-SHP-1020.csv
# Required Inputs:
#	ordnum - This will be used as the ordnum when creating the order to be loaded onto the trailer
#	ship_id - This will be used as the ship_id when creating the shipment to be loaded onto the trailer
# 	adr_id - This will be used as the adr_id when creating the order to be loaded onto the trailer
# 	cstnum - This will be used as the cstnum when creating the order to be loaded onto the trailer
# 	carcod - This will be used as the carrier for the shipment
# 	srvlvl - This will be used as the service level for the shipment
# 	ordtyp - This will be used as the order type for the order
# 	prtnum - This will be used as the prtnum for the order
# 	untqty - This will be used as the order qty for the order
# 	invsts_prg - This will be used as the inventory status progression on the order line
# 	wave_num - This will be used as the wave number for the shipment
# 	move_id - This will be used as the move ID assigned to the trailer
# 	trlr_id - This will be used as the trailer ID for the trailer
# 	dock - This will be used as the dock location for the trailer
# 	pck_dstloc - This will be used as the location the order is picked to
#	load_stop - This will be used by the dataset to load the stop 
#	close_trailer - This will be used by the dataset to close the trailer
# Optional Inputs:
#	None
#
# Assumptions:
# - Sufficient pickable and shippable inventory for the order
# - Dock door for the dataset is an open and usable dock door
# - Trailer to be dispatched is fully loaded and closed
#
# Notes:
# - This Test Case creates a trailer using the dataset if create_data is set to TRUE
# - This Test Case can use an existing trailer by setting create_data to FALSE and supplying a valid move_id
# 
############################################################ 
Feature: BASE-SHP-1020 Web Outbound Trailer Dispatch
 
Background:
#############################################################
# Description: Imports dependencies, sets up environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Trailer Move Imports"
	Then I execute scenario "Web Outbound Trailer Imports"
	And I execute scenario "Web Environment Setup"

	Then I assign "BASE-SHP-1020" to variable "test_case"
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
 
@BASE-SHP-1020
Scenario Outline: BASE-SHP-1020 Web Outbound Trailer Dispatch
CSV Examples: Test Case Inputs/BASE-SHP-1020.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I execute scenario "Web Trailer Check Paperwork"
And I execute scenario "Web Login"
And I execute scenario "Web Open Shipping Loads Screen"
And I execute scenario "Web Search for Load"
And I execute scenario "Web Dispatch the Trailer"
And I execute scenario "Web Door Activity Process Trailer Safety Check"
And I execute scenario "Web Click Save"
And I execute scenario "Web Verify Confirmation"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"