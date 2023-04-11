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
# Test Case: BASE-RCV-1140 Web Inbound Complete Shipment.feature
# 
# Functional Area: Receiving
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Web, MOCA
#
# Description:
# This test case will complete an Inbound Shipment in the Web
#
# Input Source: Test Case Inputs/BASE-RCV-1140.csv
# Required Inputs:
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
#	trlr_option - what do do with trailer on completion, options are leave_at_Door, turnaround, or dispatch
#	carcod - Carrier code of the trailer
# Optional Inputs:
#	turnaround_carrier - If trlr_option is turnaround carrier to use
#	turnaround_location - If trlr_option is turnaround location to use
#
# Assumptions:
# 	None 
#
# Notes:
# - Test Case Inputs (CSV) - Examples:
#	Example Row: trlr_option of leave_at_door
#	Example Row: trlr_option of turnaround
#	Example Rows: trlr_option of dispatch
#
############################################################
Feature: BASE-RCV-1140 Web Inbound Complete Shipment
 
Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Web Receiving Imports"
	And I execute scenario "Web Environment Setup"

	Then I assign "BASE-RCV-1140" to variable "test_case"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"	
	Then I assign "putaway" to variable "dataset_directory"   
	And I execute scenario "Perform MOCA Dataset"

After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "putaway" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-RCV-1140
Scenario Outline: BASE-RCV-1140 Web Inbound Complete Shipment
CSV Examples: Test Case Inputs/BASE-RCV-1140.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "log into the Web Browser and navigate to shipments screen"
	Then I execute scenario "Web Login"
	And I execute scenario "Web Open Inbound Shipments Screen"

When I execute scenario "Web Inbound Complete Shipment"

Then I execute scenario "Web Receiving Dispatch Trailer Modes"

And I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"