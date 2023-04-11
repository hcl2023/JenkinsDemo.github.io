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
# Test Case: BASE-LDG-5000 Flow Outbound Audit.feature
#
# Functional Area: Loading
# Author: Tryon Solutions 
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: MOCA, Terminal, Web
#
# Description: 
# This test case performs an outbound inventory audit in the terminal. If a discrepancy is found,
# a re-count will occur, followed by a release of hold completed in the Web. It will also check the RF
# Outbound audit history and load, close, dispatch the trailer.
#
# Input Source: Test Case Inputs/BASE-LDG-5000.csv
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
#	audqty - Quantity to use when asked during outbound audit
# 	invsts_prg - Inventory status progression on the order line.  Must be a valid invsts_prg configured in the system
# 	wave_num - Wave number for the shipment. Must not match any existing wave number in the warehouse
# 	move_id - Carrier Move ID assigned to the trailer. Must not match any existing carrier move in the warehouse
# 	trlr_id - Trailer ID for the trailer. Must not match any existing trailer in the warehouse
# 	dock_door - Dock location for the trailer.  Must be a valid and open shipping dock door in the warehouse
#	discrepancy_action - if an audit discrepancy is found, what action to take (valid values: fail | recount)
#	reacod - reason code (Web string) to provide when releasing hold
#	invsts - inventory status (Web string) to provide when releasing hold
# Optional Inputs:  
#	None
#
# Assumptions:
# None
#
# Notes:
# - Test Case Inputs (CSV) - Examples:
#	Example Row: No discrepancy found, untqty is equal to audqty 
#	Example Row: Discrepancy is found, untqty is NOT equal to audqty
#
############################################################
Feature: BASE-LDG-5000 Flow Outbound Audit

Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Terminal Loading Imports"
	And I execute scenario "Web Outbound Audit Imports"
	And I execute scenario "Web Environment Setup"

	Then I assign "BASE-LDG-5000" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"
	Then I assign value $trlr_id to unassigned variable "trlr_num"
	And I assign value $move_id to unassigned variable "car_move_id"
	And I assign value $devcod to unassigned variable "pck_dstloc"
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

@BASE-LDG-5000
Scenario Outline: BASE-LDG-5000 Flow Outbound Audit
CSV Examples: Test Case Inputs/BASE-LDG-5000.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "log into terminal and navigate to the outbound audit menu"
	And I execute scenario "Terminal Login"
	And I execute scenario "Terminal Shipping Manual Outbound Audit Menu"

When I "perform the outbound audit in the terminal"
	And I execute scenario "Terminal Outbound Audit"

And I "log into the Web and release hold from the terminal audit (if we have discrepancy)"
	If I verify text $untqty is not equal to $audqty
		Then I execute scenario "Web Login"
		And I execute scenario "Web Navigate to Shiping Issues Screen"
		And I execute scenario "Web Release Outbound Audit Hold"

		And I "check for audit history for the lodnum"
			Then I execute scenario "Web Navigate to RF Outbound Audit Issues Screen"
			And I execute scenario "Web Check Outbound Audit History"
        
        And I "load the trailer, close, and dispatch to complete actions"
        	Then I execute scenario "Web Assign Close and Dispatch Variables"
			And I execute scenario "Web Open Shipping Loads Screen"
			And I execute scenario "Web Search for Load"
			And I execute scenario "Web Shipping Loads Process Trailer Safety Check"
			And I execute scenario "Web Select Load Row"
			And I execute scenario "Web Set Load Stop"
			And I execute scenario "Web Verify Dock Door Ready"
			And I execute scenario "Web Select Move Immediately, Close, and Dispatch"
			And I execute scenario "Web Click Save"
			And I execute scenario "Web Verify Paperwork"
			And I execute scenario "Web Verify Confirmation"
	EndIf

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"