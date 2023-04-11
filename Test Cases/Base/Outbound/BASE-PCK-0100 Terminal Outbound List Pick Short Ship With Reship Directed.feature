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
# Test Case: BASE-PCK-0100 Terminal Outbound List Pick Short Ship With Reship Directed.feature
# 
# Functional Area: Picking
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Terminal, MOCA
#
# Description:
# This Test Case performs Terminal Outbound List Pick Short Ship With Reship Directed
#
# Input Source:Test Case Inputs/BASE-PCK-0100.csv
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
# 	car_move_id -This will be used as the Carrier Move Id  
# 	trlr_id - This will be used as the trailer ID for the trailer when creating carton pick data
# 	trlr_num - Transport Equipment Number used as User identification for the trailer.
# 	dock - This will be used as the dock location for the trailer when creating carton pick data
# 	dock_door - Physical location in the dock location where the trailer is located.
# 	oprcod - This will be used to validate the type of operation performed
# 	bckflg - This is what the backorder flag will be set as on the order line.  It defaults to 0 if nothing is passed in
# 	short_pick_flag - The short_pick variable to determine if we should be short picking or not
# 	short_pick_qty - The short_pick_qty variable to determine amount of the qty to pick and short ship
# 	cancel_code - The cancel code entered after the short pick (for this case is should be C-N-R)
# 	create_order - The create_order variable to determine if we should be create_order or not
# 	detail_file_name - csv file that contains variables for reship and cleanup
# 	pck_dstloc - This will be used as the location the order is picked to
#	trac_ref - tracking reference for dispatch information
#	driver_lic - drivers license for dispatch information
#	driver_nam - drivers name for dispatch information
# Optional Inputs:
#	None
#
# Assumptions:
# - There is sufficient inventory in the warehouse to allocate a List pick of the assigned prtnum if using the dataset
#
# Notes:
# - Supply values for required and desired variables that adhere to the requirements of the system.
#
############################################################
Feature: BASE-PCK-0100 Terminal Outbound List Pick Short Ship With Reship Directed

Background:
############################################################
# Description: Imports dependencies, sets up the environment.
#############################################################

Given I "setup the environment"
	Then I assign all chevron variables to unassigned dollar variables
	And I import scenarios from "Utilities/Base/Environment.feature"
	When I execute scenario "Set Up Environment"

	Given I execute scenario "Terminal Picking Imports"
	And I execute scenario "Terminal Loading Imports"

	Then I assign "BASE-PCK-0100" to variable "test_case"
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

And I "cleanup with the current set of local data variables"
	Then I assign "No" to variable "ignore_cleanup"
	And I assign "Allocate_List_Picks" to variable "cleanup_directory"
	Then I execute scenario "Perform MOCA Cleanup Script"
  
And I "get the local data variables from the first pick scenario execution from csv"
Then I "instantiate variables and run the cleanup for the first pick scenario execution"
	And I execute scenario "Load Detail CSV Variables"
	And I assign "Allocate_List_Picks" to variable "cleanup_directory"
	Then I execute scenario "Perform MOCA Cleanup Script"

@BASE-PCK-0100
Scenario Outline: BASE-PCK-0100 Terminal Outbound List Pick Short Ship With Reship Directed
CSV Examples:Test Case Inputs/BASE-PCK-0100.csv

Given I "execute pre-test scenario actions (including pre-validations)"
	And I execute scenario "Begin Pre-Test Activities"

When I "list pick for shortship"
Then I "login to the terminal, assign work, and traverse to directed work menu"
	And I execute scenario "Terminal Login"
	And I execute scenario "Assign Work to User by Order and Operation"	
    And I execute scenario "Terminal Navigate to Directed Work Menu"

When I "perform list pick"
	And I execute scenario "Terminal Perform Directed List Pick for Order"

And I "load, close. and dispatch the trailer"
	And I execute scenario "Terminal Navigate Quickly to Undirected Menu"
	And I execute scenario "Terminal Navigate to Load Equipment Menu"
	When I execute scenario "Terminal Perform Undirected TL Loading"
    
	Then I execute scenario "Terminal Navigate Quickly to Undirected Menu"
	And I execute scenario "Terminal Navigate to Close Equipment Menu"
	And I execute scenario "Terminal Outbound Trailer Close"

	Then I execute scenario "Terminal Navigate Quickly to Undirected Menu"
	And I execute scenario "Terminal Navigate to Dispatch Equipment Menu"
	And I execute scenario "Terminal Outbound Trailer Dispatch"

	And I execute scenario "Terminal Navigate Quickly to Undirected Menu"

And I "get the local data variables for performing second pick"
Given I "instantiate variables and skip running the cleanup for the first pick scenario execution "
	Then I execute scenario "Load Detail CSV Variables"
	And I assign "Yes" to variable "ignore_cleanup"
	And I assign "Allocate_List_Picks" to variable "dataset_directory"
	And I execute scenario "Perform MOCA Dataset"
	Then I "wait some time for list picks to release" which can take between $wait_long seconds and $max_response seconds 
 
When I "perform list pick for reship"
	And I execute scenario "Assign Work to User by Order and Operation"	
    And I execute scenario "Terminal Navigate to Directed Work Menu"
	Then I execute scenario "Terminal Perform Directed List Pick for Order"

And I "load, close, and dispatch the trailer"
	And I execute scenario "Terminal Navigate Quickly to Undirected Menu"
	And I execute scenario "Terminal Navigate to Load Equipment Menu"
	When I execute scenario "Terminal Perform Undirected TL Loading"
    
	Then I execute scenario "Terminal Navigate Quickly to Undirected Menu"
	And I execute scenario "Terminal Navigate to Close Equipment Menu"
    And I execute scenario "Terminal Outbound Trailer Close"

    Then I execute scenario "Terminal Navigate Quickly to Undirected Menu"
	And I execute scenario "Terminal Navigate to Dispatch Equipment Menu"
	And I execute scenario "Terminal Outbound Trailer Dispatch"

Then I "execute post-test scenario actions (including post-validations)"
	And I execute scenario "End Post-Test Activities"
    
@wip @private
Scenario: Load Detail CSV Variables
#############################################################
# Description: This scenario performs loads CSV variables for reship and cleanup for list pick.
# Inputs:
# 	Required:
#		detail_file_name - csv file that needs to have variables loaded
#		ordnum - the order number
#		ship_id- the shipment ID
#		adr_id - the address ID
#		cstnum - the customer number
#		srvlvl - the service level
#		ordtyp - the order type
#		prtnum - the part number
#		untqty - the unit quantity
#		invsts_prg - the inventory status progression
#		wave_num - the wave number
#		move_id - the move ID
#		trlr_id - the trailer ID
#		dock - the dock
#		create_order - the parameter to tell the dataset to create the order
#		bckflg - the back flg
#		pck_dstloc - the picking destination location
# 	Optional:
#		None
# Outputs:
# 	None
#############################################################

Given I "load CSV Detail input file"
	Then I assign variable "detail_file" by combining "Test Case Inputs/Details/" $detail_file_name
	And I reset line counter for $detail_file
	And I assign values in next row from $detail_file to variables    