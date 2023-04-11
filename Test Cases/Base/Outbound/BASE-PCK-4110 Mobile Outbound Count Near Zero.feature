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
# Test Case: BASE-PCK-4110 Mobile Outbound Count Near Zero.feature
#
# Functional Area: Picking
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Mobile, MOCA
#
# Description: This Test Case performs Mobile App Directed Pallet Picking in a location that has count near zero enabled 
# and then performs count near zero with different scenarios:
# 	- (i) Pick and count near zero - no mismatch 
#  	- (ii) Pick and count near zero - mismatch and match 
# 	- (iii) Pick and count near zero - mismatch and mismatch - generate audit
#
# Input Source: Test Case Inputs/BASE-PCK-4110.csv
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
#	srcloc - The location where the picking and count near zero operations will occur
# Optional Inputs:
#	match_count- variable that will drive method of counting.
#
# Assumptions:
# - The location specified for this test case is configured to allow pallet picks and has sufficient configuration to 
#   generate count near zero. Count near zero in this case will be triggered when there is less than 550 units of a 
#   product in the count near zero count zone.
# - There is sufficient configuration to allow the user to perform pallet picking and count near zero through directed work.
# - This test case will perform pallet picking for a non-serialized part followed by count near zero. 
#
# Notes:
# - Supply values for required and desired variables that adhere to the requirements of the system.
# - Test Case Inputs (CSV) - Examples:
#	Example Row: Pallet Pick with Count Near Zero Mode REGULAR
#	Example Row: Pallet Pick with Count Near Zero Mode REMATCH
#	Example Row: Pallet Pick with Count Near Zero Mode MISMATCH
#
############################################################
Feature: BASE-PCK-4110 Mobile Outbound Count Near Zero

Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Mobile Picking Imports"
    And I execute scenario "Mobile Count Near Zero Imports"

	Then I assign "BASE-PCK-4110" to variable "test_case"
	When I execute scenario "Test Data Triggers"

    If I verify variable "mobile_devcod" is assigned
		Then I assign value $mobile_devcod to unassigned variable "pck_dstloc"
		And I assign $mobile_devcod to variable "devcod"
	Else I assign value $devcod to unassigned variable "pck_dstloc"
	EndIf

And I "load the dataset"
	Then I assign "Count_Near_Zero" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"

After Scenario:
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Count_Near_Zero" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-PCK-4110
Scenario Outline: BASE-PCK-4110 Mobile Outbound Count Near Zero
CSV Examples: Test Case Inputs/BASE-PCK-4110.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "navigate to the Directed Work Menu to perform the Pallet Pick"
	And I execute scenario "Mobile Login"
	And I execute scenario "Assign Work to User by Order and Operation"
	And I execute scenario "Mobile Navigate to Directed Work Menu"

When I "perform a pallet pick and continue on to the subsequent count near zero"
	When I execute scenario "Mobile Perform Pallet Pick for Order"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"