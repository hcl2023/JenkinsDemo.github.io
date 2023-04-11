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
# Test Case: BASE-INV-6000 Flow Mobile Inventory Move.feature
#
# Functional Area: Inventory
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: MOCA, WEB, Mobile
#
# Description: This test case will utilize the Web to request an inventory movement from a source location to a 
# destination location as directed work, perform the inventory movement in the Mobile App, and confirm the 
# inventory has been moved to the destination location.
#
# Input Source: Test Case Inputs/BASE-INV-6000.csv
# Required Inputs:
# 	srcloc - The source location of the LPN (load number) to be moved. Must be a valid adjustable/storable location 
#			 in the system. Used in load dataset processing.
# 	dstloc - The destination location of the LPN to be moved. Must be a valid adjustable/storable location in the system.
#			 Must be a different location than the source location. Used in Web interactions and post move validation.
# 	srclod - Load number added by dataset and moved by the main scenario. Can be a fabricated number. 
# 			 Used in dataset processing and in Web interactions.
#	prtnum - This needs to be a valid part number that is defined in your system. The part will use the default 
#			 client_id defined in Environment.feature. Used in load dataset processing and Web validation.
#	untqty - Quantity for the dataset to add inventory. Must be a number. Used in load dataset processing and Web validation.
#	ftpcod - Footprint code for item to be adjusted. Must be a valid footprint for the item. Used in load dataset processing.
#	move_qty - Qty to be moved from source to destination if moving less than a full load. Used in Web interactions 
#			 and post move validation.
#	dstlod - New load number (LPN) for the partial qty if performing a partial qty movement. Used in Web interactions, 
#			 post move validation, and cleanup dataset processing.
# Optional Inputs:
# None
#
# Assumptions:
# - This test case is for moving a single item LPN (load number) from a source location to a destination location
# - Locations, parts, clients, reason codes are set up for an inventory movement
# - If moving a partial quantity, the move_qty variable is populated and is less than the untqty variable used by the load dataset
# - If moving a partial qty, the dstlod variable is populated for the new LPN that is created with the partial move qty
# - Sufficient configuration to allow stock transfer
# - The Flow inventory transfer will be not be an immediate move and will utilize directed work
#
# Notes:
# - Test Case Inputs (CSV) - Example:
#	- representing a full move of inventory (LPN)
#
############################################################ 
Feature: BASE-INV-6000 Flow Mobile Inventory Move
 
Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Mobile Inventory Imports"
	Then I execute scenario "Web Environment Setup"

	And I assign "BASE-INV-6000" to variable "test_case"
    And I assign "WORK QUEUE" to variable "inventory_move_mode"
	When I execute scenario "Test Data Triggers"

And I "load the dataset"	
	Then I assign "Flow_Inventory_Move" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"
 
After Scenario: 
#############################################################
# Description: Logs out of the interface and cleans up the dataset
#############################################################

Given I "perform test completion activities including logging out of the interfaces"
	Then I execute scenario "Test Completion"

And I "cleanup the dataset"
	Then I assign "Flow_Inventory_Move" to variable "cleanup_directory"
	And I execute scenario "Perform MOCA Cleanup Script"

@BASE-INV-6000
Scenario Outline: BASE-INV-6000 Flow Inventory Move
CSV Examples: Test Case Inputs/BASE-INV-6000.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

Then I "login into the web and navigate to the inventory screen"
	And I execute scenario "Web Login"
	And I execute scenario "Web Open Inventory Screen"

Then I "perform move and logout of Web"
	When I execute scenario "Web Inventory Move"
	And I execute scenario "Web Logout"

Then I "perform directed inventory transfer in Mobile App"  
	Given I execute scenario "Mobile Login"
	And I execute scenario "Assign Transfer Directed Work"
	And I execute scenario "Mobile Navigate to Directed Work Menu"
	When I execute scenario "Mobile Inventory Transfer Directed"
	Then I execute scenario "Inventory Transfer Validate Location"

And I "execute post-test scenario actions (including post-validations)"
	Then I execute scenario "End Post-Test Activities"