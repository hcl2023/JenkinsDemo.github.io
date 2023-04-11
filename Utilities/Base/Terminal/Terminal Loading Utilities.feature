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
# Utility: Terminal Loading Utilities.feature
# 
# Functional Area: Loading
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: Terminal, MOCA
#
# Description:
# This utility contains scenarios for loading trailers using terminals
#
# Public Scenarios:  
#	- Terminal Perform Undirected LTL Loading - find the correct door for loading a trailer using Undirected LTL loading
#	- Terminal Perform Undirected TL Loading - find the correct door for loading a trailer using Undirected TL loading
#	- Terminal Perform LTL Directed Loading of All LPNs for Truck - performs Directed LTL of a dock door
#	- Terminal Perform TL Directed Loading of All LPNs for Truck - performs Directed TL of a dock door
#	- Terminal Outbound Audit - performs an outbound audit of a outbound staging location
#	- Terminal Outbound Unload and Unpick Shipment - unloads a shipping trailer and unpicks inventory
#
# Assumptions:
# 	None
#
# Notes:
# 	None
#
############################################################
Feature: Terminal Loading Utilities

@wip @public
Scenario: Terminal Outbound Audit
###############################################################
# Description: This scenario will conduct an Outbound audit in the terminal.
# It will also check to see if the audit completed with discrepancies
# or not. If discrepancies were found it will call scenario to handle
# the discrepancies in terms of releasing a hold.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		stoloc - outbound staging location
#		lodnum - load number
#		prtnum - part number
#		stkuom - unit of measure relative to prtnum
#		audqty - quantity to enter during audit (if not equal to untqty then this will generate a mismatch)
#		client_id - client ID
#	Optional:
#		None
# Outputs:
#	None
##################################################################

Given I assign "FALSE" to variable "skip_location_lpn"

Then I execute scenario "Terminal Perform Outbound Audit"
    
And I "check for results of the audit"
	Then I wait $screen_wait seconds
    And I "check for discrepancies"
		If I see "Discrepancies found" in terminal within $wait_med seconds
			Then I execute scenario "Terminal Handle Audit Discrepancies"
		EndIf
	And I "check for clean audit"
		If I see "Audit completed with" in terminal within $wait_med seconds
		And I see "no discrepancies" in terminal within $wait_short seconds
		And I see "Press Enter" on last line in terminal within $wait_short seconds
			Then I press keys "ENTER" in terminal
		EndIf

And I unassign variable "skip_location_lpn"

@wip @public
Scenario: Terminal Perform Undirected LTL Loading
###############################################################
# Description: This scenario will find the correct door for loading
# a trailer using Undirected LTL loading screen.  Then
# Sign on to the trailer and perform a undirected LTL load
# of all the LPNs.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		trlr_id - Trailer Id 
#		trlr_num - Trailer Number 
#		dock_door - Dock Door
#	Optional:
#		None
# Outputs:
#	None
##################################################################

Given I "find the door and sign on to the the trailer/door"
	Given I execute scenario "Get Next LPN for Undirected LTL Trailer Loading"
	Then I execute scenario "Terminal Sign onto Undirected LTL Loading Door"

Then I "load all the LPNs onto the truck"
	While I execute scenario "Get Next LPN for Undirected LTL Trailer Loading"
		Then I execute scenario "Terminal Outbound Undirected Load LPN to LTL Trailer"
	EndWhile 
 
@wip @public
Scenario: Terminal Perform Undirected TL Loading
###############################################################
# Description: This scenario will find the correct door for loading
# a trailer using Undirected TL loading screen.  Then
# Sign on to the trailer and perform a undirected TL load
# of all the LPNs.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		trlr_id - Trailer Id 
#		trlr_num - Trailer Number 
#		dock_door - Dock Door
#	Optional:
#		None
# Outputs:
#     None
##################################################################

Given I "find the door and sign on to the the trailer/door"
	Given I execute scenario "Get Next LPN for Undirected TL Trailer Loading"
	Then I execute scenario "Terminal Sign onto Undirected TL Loading Door"

Then I "load all the LPNs onto the truck"
	While I execute scenario "Get Next LPN for Undirected TL Trailer Loading"
		Then I execute scenario "Terminal Outbound Load LPN to Trailer"
	EndWhile 
	
Then I "perform trailer completion logic" 
	Given I execute scenario "Terminal Outbound Trailer Completion"    
	
@wip @public
Scenario: Terminal Sign onto Undirected TL Loading Door
###############################################################
# Description: This scenario will sign into a door for Undirected
# TL Loading.  The logic will also complete a trailer
# workflow if necessary.
# MSQL Files:
#	None            
# Inputs:
#	Required:
#		carcod - Carrier Code for Trailer
#		yard_loc - Yard location of Dock Door
#	Optional:
#		None
# Outputs:
#	None
##################################################################

Given I "enter the dock door"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 4 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 3 column 20 in terminal
	EndIf
	Then I enter $yard_loc in terminal

Then I "press enter at the prepopulated load and stop fields"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 6 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 4 column 20 in terminal
	EndIf
	Then I press keys "ENTER" in terminal
	
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 10 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 6 column 20 in terminal
	EndIf
	Then I press keys "ENTER" in terminal

And I "check to see if we have a workflow and process the workflow"
	Given I execute scenario "Terminal Process Workflow"    
	
@wip @public
Scenario: Terminal Perform LTL Directed Loading of All LPNs for Truck 
#############################################################
# Description: This scenario performs Directed LTL of a dock door. It performs 
# the loading of all the staged LPNS for a door.
# MSQL Files:
#	None      
# Inputs:
#	Required:
#		username - Username signed into terminal
#		dock_door - Dock Door being loaded
#		devcod - Device Code
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I execute scenario "Terminal Loading Sign On"

Then I "load all the LPNs waiting to be loaded"
	While I see "Loading Pickup" in terminal within $screen_wait seconds 
		If I execute scenario "Get Next LPN for Directed LTL Trailer Loading"
			  Then I execute scenario "Terminal Outbound Load LPN to Trailer"      
		EndIf
	EndWhile

@wip @public
Scenario: Terminal Perform TL Directed Loading of All LPNs for Truck 
#############################################################
# Description: This scenario performs Directed TL of a dock door.  It assigns
# the user to the door, gets the directed work, then it performs 
# the loading of all the staged LPNS for a door.
# MSQL Files:
#	None          
# Inputs:
#	Required:
#		username - Username signed into terminal
#		dock_door - Dock Door being loaded
#		devcod - Device Code
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I execute scenario "Terminal Loading Sign On"

When I "load all the LPNs waiting to be loaded"
	While I see "Loading Pickup" in terminal within $screen_wait seconds 
		If I execute scenario "Get Next LPN for Directed TL Trailer Loading"
			  Then I execute scenario "Terminal Outbound Load LPN to Trailer"      
		EndIf
	EndWhile
	
Then I "perform trailer completion logic" 
	Given I execute scenario "Terminal Outbound Trailer Completion"
 
@wip @public
Scenario: Terminal Outbound Unload and Unpick Shipment
#############################################################
# Description: This scenario unloads picked inventory from a outbound trailer, and 
# unpicks the inventory - depending on the decision variable in the input file. 
# MSQL Files:
#	None          
# Inputs:
#	Required:
#		shpstg_loc - Ship staging location to unload to
#	Optional:
#		None
# Outputs:
#	pck_lodnum - last unpicked lodnum
#############################################################

When I "find out the details of the loads on the shipment"
	Then I execute scenario "Get Inventory Details for Shipment"    
	And I assign row 0 column "number_loads" to variable "number_of_loads"
	And I convert string variable "number_of_loads" to integer variable "number_of_loads"
	Then I assign "0" to variable "row_count"
	And I convert string variable "row_count" to integer variable "row_count"
    
Then I "process unloading the equipment"
	While I verify number $row_count is less than $number_of_loads
		Then I execute scenario "Get Inventory Details for Shipment" 
		And I assign row 0 column "lodnum" to variable "pck_lodnum"
		Once I see "Unload Equip" in terminal
		If I verify text $term_type is equal to "handheld"
			Once I see cursor at line 3 column 1 in terminal
		Else I verify text $term_type is equal to "vehicle"
			Once I see cursor at line 2 column 10 in terminal
		EndIf
		Then I enter $pck_lodnum in terminal

		Then I execute scenario "Terminal Process Workflow"

		And I "enter destination location - ship staging location"
			If I verify text $term_type is equal to "handheld"
				Once I see cursor at line 11 column 1 in terminal
			Else I verify text $term_type is equal to "vehicle"
				Once I see cursor at line 6 column 10 in terminal
			EndIf
			Then I enter $shpstg_loc in terminal

		Once I see "OK To Unload" in terminal
		Then I press keys "Y" in terminal

		Then I "am processing unpick based on the input variable"
			If I do not see "OK To Unpick" in terminal within $wait_med seconds
				Then I press keys "F6" in terminal
				Once I see "OK To Unpick" in terminal
			EndIf
			If I verify text $ok_to_unpick is equal to "Y"
				Then I type $ok_to_unpick in terminal
				And I execute scenario "Terminal Perform Unpick"
			Else I type $ok_to_unpick in terminal
			EndIf

		If I do not see "Unload Equip" in terminal within $wait_med seconds
		And I see "Unpick" in terminal within $wait_med seconds
			Then I press keys "F1" in terminal
		EndIf
		Then I increase variable "row_count"
	EndWhile

@wip @public
Scenario: Validate Unload and Unpick Equipment
#############################################################
# Description: This scenario uses an MSQL to validate successful unload and unpick.
# MSQL Files:
#	validate_unload_equipment.msql
#	validate_unpick_inventory.msql
# Inputs:
#	Required:
#		pck_lodnum - LPN
#		ok_to_unpick - If we want to unpick inventory after unloading trailer. Can take only 'Y' or 'N'
#		trknum - transport equipment identifier
#		shpstg_loc - location the equipment is being unloaded to
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "validate successful unload and unpick"
	When I assign "validate_unload_equipment.msql" to variable "msql_file"
	Then I execute scenario "Perform MSQL Execution"
	And I verify MOCA status is 0

	If I verify text $ok_to_unpick is equal to "Y"
		When I assign "validate_unpick_inventory.msql" to variable "msql_file"
    	Then I execute scenario "Perform MSQL Execution"
		And I verify MOCA status is 0
	EndIf

#############################################################
# Private Scenarios:
#	Terminal Loading Sign On - signs the user into the door and performs Trailer Workflows if prompted
#	Get Next LPN for Directed TL Trailer Loading - get the next LPN needing for directed TL loading
#	Get Next LPN for Directed LTL Trailer Loading - get the next LPN needing for directed LTL loading
#	Get Next LPN for Undirected LTL Trailer Loading - get the next LPN for undirected LTL loading
#	Get Next LPN for Undirected TL Trailer Loading - get the next LPN needing for undirected LTL loading
#	Terminal Sign onto Undirected LTL Loading Door - sign into a door for Undirected LTL Loading
#	Terminal Outbound Undirected Load LPN to LTL Trailer - pick up and deposit a single LPN on Undirected LTL loading screen
#	Terminal Sign onto Undirected TL Loading Door - sign into a door for UndirectedTL Loading
#   Terminal Outbound Trailer Completion - stop closing logic within the terminal
#	Terminal Outbound Load LPN to Trailer - process the TL/LTL loading screen
#	Get Lodnum and Location from Ship ID- MSQL call to extract the Lodnum and
# stoloc from the Ship ID
#	Get UOM from Prtnum - MSQL call to get stkuom from prtnum
#	Terminal Perform Outbound Audit - Assist in conducting an Outbound audit in the terminal
#	Terminal Initiate and Acknowledge Outbound Audit - Press F6 and complete outbound audit
#	Terminal Handle Audit Discrepancies - Check if there were discrepancies found, either fail the test case or perform a re-count
#	Get Inventory Details for Shipment - looks up picked inventory details for a shipment
#############################################################

@wip @private
Scenario: Get Inventory Details for Shipment
#############################################################
# Description: This scenario uses an MSQL to look up inventory details for a shipment.
# MSQL Files:
#	get_inventory_details_for_shipment.msql          
# Inputs:
#	Required:
#		ship_id - shipment ID
#	Optional:
#		None
# Outputs:
#	number_of_loads - number of loads associated with the shipment
#	lodnum - load associated with the shipment
#############################################################

Given I assign "get_inventory_details_for_shipment.msql" to variable "msql_file"
Then I execute scenario "Perform MSQL Execution"
And I verify MOCA status is 0

@wip @private
Scenario: Terminal Loading Sign On
#############################################################
# Description: This scenario signs the user into the door. Trailer Workflows are performed if prompted.
# MSQL Files:
#	None            
# Inputs:
#	Required:
#		username - Username signed into terminal
#		dock_door - Dock Door being loaded
#		devcod - Device Code
#	Optional:
#		None
# Outputs:
#	None
#############################################################
	
Given I "acknowledge the directed work"    
	Once I see "Load Equip" in terminal 
  	Once I see "Press Enter To Ack" in terminal
  	Then I press keys "ENTER" in terminal
  
Then I "check to see if we have a workflow and process the workflow"
	Given I execute scenario "Terminal Process Workflow"

@wip @private
Scenario: Get Next LPN for Directed TL Trailer Loading
#############################################################
# Description: This scenario runs a SQL to get the next LPN needing
# for directed TL loading
# MSQL Files:
#	get_TL_ack_work.msql     
# Inputs:
#	Required:
#		wh_id - Warehouse Id
#		username - Username signed into terminal
#		dock_door - Dock Door being loaded
#		devcod - Device Code
#	Optional:
#		None
# Outputs:
#	lodnum - LPN to be loaded
#	dock_door - Dock Door to be loaded
#############################################################

Given I assign "get_TL_ack_work.msql" to variable "msql_file"
When I execute scenario "Perform MSQL Execution"

And I "assign return values"
	Given I verify MOCA status is 0
	Then I assign row 0 column "lodnum" to variable "lodnum"                   
	And I assign row 0 column "yard_loc" to variable "yard_loc"

@wip @private
Scenario: Get Next LPN for Directed LTL Trailer Loading
#############################################################
# Description: This scenario runs a SQL to get the next LPN needing
# for directed LTL loading based on the user assigned work
# MSQL Files:
#	get_next_lpn_trlr_dir_load.msql     
# Inputs:
#	Required:
#		wh_id - Warehouse Id
#		username - Username signed into terminal
#		devcod - Device Code
#	Optional:
#		None
# Outputs:
#	lodnum - LPN to be loaded
#	yard_loc - Dock Door to be loaded
#############################################################

Given I assign "get_next_lpn_trlr_dir_load.msql" to variable "msql_file"
When I execute scenario "Perform MSQL Execution"

And I "assign return values"
	Given I verify MOCA status is 0
	Then I assign row 0 column "lodnum" to variable "lodnum"                   
	And I assign row 0 column "yard_loc" to variable "yard_loc"
	
@wip @private
Scenario: Get Next LPN for Undirected LTL Trailer Loading
#############################################################
# Description: This scenario runs an MSQL to get the yard location, 
# Carrier Code, and gets the next LPN needed for undirected LTL loading
# MSQL Files:
#	get_LTL_inv_and_trlr.msql  
# Inputs:
#	Required:
#		wh_id - Warehouse Id
#	Optional:
#		trlr_id - Trailer Id
#		trlr_num -  Trailer Number
#		dock_door - Dock Door
#		ship_id - Ship Id
#		car_move_id - Carrier Move Id
# Outputs:
#	lodnum - LPN to be loaded
#	carcod - Carrier Code
#	yard_loc - Dock Door to be loaded
#############################################################

Given I assign "get_LTL_inv_and_trlr.msql" to variable "msql_file"
When I execute scenario "Perform MSQL Execution"

Then I "assign return values"
	When I verify MOCA status is 0
	Then I assign row 0 column "lodnum" to variable "lodnum"
	And I assign row 0 column "yard_loc" to variable "yard_loc"
	And I assign row 0 column "carcod" to variable "carcod"

@wip @private
Scenario: Get Next LPN for Undirected TL Trailer Loading
#############################################################
# Description: This scenario runs an MSQL to get the yard location, 
# Carrier Code, and the next LPN needed for undirected LTL loading
# MSQL Files:
#	get_TL_inv_and_trlr.msql 
# Inputs:
#	Required:
#		wh_id - Warehouse Id
#	Optional:
#		trlr_id - Trailer Id
#		trlr_num -  Trailer Number
#		dock_door - Dock Door
#		ship_id - Ship Id
#		car_move_id - Carrier Move Id
# Outputs:
#	lodnum - LPN to be loaded
#	yard_loc - Dock Door to be loaded
#############################################################  

Given I assign "get_TL_inv_and_trlr.msql" to variable "msql_file"
When I execute scenario "Perform MSQL Execution"

And I "assign return values"
	When I verify MOCA status is 0
	Then I assign row 0 column "lodnum" to variable "lodnum"
	And I assign row 0 column "yard_loc" to variable "yard_loc"

@wip @private
Scenario: Terminal Sign onto Undirected LTL Loading Door
###############################################################
# Description: This scenario will sign into a door for Undirected
# LTL Loading.  The logic will also complete a trailer
# workflow if necessary.
# MSQL Files:
#	None           
# Inputs:
#	Required:
#		carcod - Carrier Code for Trailer
#		yard_loc - Yard location of Dock Door
#	Optional:
#		None
# Outputs:
#	None
##################################################################

Given I "enter the carrier code"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 4 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 3 column 10 in terminal
	EndIf 
	Then I enter $carcod in terminal

And I "enter the dock door"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 8 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 5 column 10 in terminal
	EndIf 
	Then I enter $yard_loc in terminal

Then I "check to see if we have a workflow and process the workflow"
	Given I execute scenario "Terminal Process Workflow"

@wip @private
Scenario: Terminal Outbound Undirected Load LPN to LTL Trailer 
###############################################################
# Description: This scenario will pick up and deposit a single
# LPN on Undirected LTL loading screen.  It scans
# a passed in load number and scans the load to a dock door.
# MSQL Files:
#	None            
# Inputs:
#	Required:
#		lodnum - Load being loaded
#		yard_loc - Dock Door being loaded
#	Optional:
#		None
# Outputs:
#	None
##################################################################

Given I "enter the LPN to pick up for loading"
	Once I see "Loading Pickup" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 13 column 2 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 8 column 7 in terminal
	EndIf 
	Then I enter $lodnum in terminal

When I "press F6 to deposit the LPN if still on Loading Pickup screen"
	If I see "Loading Pickup" in terminal within $screen_wait seconds 
		Then I press keys "F6" in terminal
	EndIf 

Then I verify screen is done loading in terminal within $max_response seconds
	Once I see "Loading Deposit" in terminal 
	Once I see "Eq Num:" in terminal
	Once I see "LPN:" in terminal
	Once I see "Dck:" in terminal

And I "enter the dock door I am loading"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 11 column 2 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 6 column 10 in terminal
	EndIf 
	Then I enter $yard_loc in terminal

And I "enter the LPN to deposit"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 13 column 2 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 7 column 10 in terminal
	EndIf 
	Then I enter $lodnum in terminal

@wip @private
Scenario: Terminal Sign onto Undirected TL Loading Door
###############################################################
# Description: This scenario will sign into a door for Undirected
# TL Loading.  The logic will also complete a trailer
# workflow if necessary.
# MSQL Files:
#	None          
# Inputs:
#	Required:
#		carcod - Carrier Code for Trailer
#		yard_loc - Yard location of Dock Door
#	Optional:
#		None
# Outputs:
#	None
##################################################################

Given I "enter the dock door"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 4 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 3 column 20 in terminal
	EndIf
	Then I enter $yard_loc in terminal

Then I "press enter at the prepopulated load and stop fields"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 6 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 4 column 20 in terminal
	EndIf
	Then I press keys "ENTER" in terminal
	
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 10 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 6 column 20 in terminal
	EndIf
	Then I press keys "ENTER" in terminal

And I "check to see if we have a workflow and process the workflow"
	Given I execute scenario "Terminal Process Workflow" 

@wip @private
Scenario: Terminal Outbound Trailer Completion
#############################################################
# Description: This scenario will process the stop closing logic within
# the terminal.  This scenario assumes the terminal has
# just completed trailer loading
# MSQL Files:
#	None           
# Inputs:
#   Required:
#		None
#   Optional:
#       bol_num - Bill of Lading number
#		pro_num - WMS Pro Num
#		seal_num - Seal number
# Outputs:
#     None
#############################################################

Given I "enter the document numbers if prompted"
	Given I execute scenario "Terminal Outbound Trailer Document Entry"

And I "enter the seal number and complete the stop if prompted"
	Given I execute scenario "Terminal Outbound Trailer Complete Stop"
	
@wip @private
Scenario: Terminal Outbound Load LPN to Trailer
#############################################################
# Description: This scenario will process the TL/LTL loading screen.  It scans
# a passed in load number and scans the load to a dock door.
# MSQL Files:
#	None          
# Inputs:
#	Required:
#		lodnum - Load being loaded
#		yard_loc - Dock Door being loaded
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "pick up the LPN to load to the trailer"
	Once I see "Loading Pickup" in terminal 
	Once I see "Dock:" in terminal
	Once I see "LPN:" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 16 column 2 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 8 column 7 in terminal
	EndIf 
	Then I enter $lodnum in terminal
	
Then I "end pickup if multiple LPNs exist for trailer. We are loading one at a time."
	If I do not see "Loading Deposit" in terminal within $screen_wait seconds 
		Then I press keys "F6" in terminal
	EndIf
	
Then I "deposit the LPN to the trailer"
	Given I verify screen is done loading in terminal within $max_response seconds
	Once I see "Loading Deposit" in terminal 
	Once I see "Load" in terminal
	Once I see "Eq Num:" in terminal
	Once I see "Car:" in terminal
	Once I see "Stp Se" in terminal
	Once I see "LPN:" in terminal
	Once I see "Dck:" in terminal
	Once I see "Stg:" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 13 column 2 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 7 column 10 in terminal
	EndIf 
	Then I enter $yard_loc in terminal

@wip @private
Scenario: Get Lodnum and Location from Ship ID
#############################################################
# Description: This scenario runs a MSQL call to extract the Lodnum and
# stoloc from the Ship ID.
# MSQL Files:
#	get_details_from_ship_id.msql     
# Inputs:
#	Required:
#		ship_id - Shipment ID
#	Optional:
#		None
# Outputs:
#	lodnum - LPN of load in staging location
#	stoloc - outbound staging location relative to ship
#############################################################

Given I "assign variables to moca variables"
	Then I assign "get_details_from_ship_id.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	Given I verify MOCA status is 0

And I "assign return values"
	Then I assign row 0 column "lodnum" to variable "lodnum"                   
	And I assign row 0 column "stoloc" to variable "stoloc"
    
@wip @private
Scenario: Get UOM from Prtnum
#############################################################
# Description: This scenario runs a MSQL call to get stkuom from prtnum
# MSQL Files:
#	get_uom_from_prtnum.msql     
# Inputs:
#	Required:
#		prtnum - Part Number
#	Optional:
#		None
# Outputs:
#	stkuom - UOM for the provide prtnum
#############################################################

Given I "assign variables to moca variables"
	Then I assign "get_uom_from_prtnum.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	Given I verify MOCA status is 0

And I "assign return values"
	Then I assign row 0 column "stkuom" to variable "stkuom"
    
@wip @private
Scenario: Terminal Perform Outbound Audit
###############################################################
# Description: This scenario will assist in conducting an Outbound audit in the terminal.
# It will enter the needed outbound staging location and lodnum.
# It will then enter the prtnum, auditted quantity (which can be used to generate a
# discrepancy), and UOM. It will then press F6 to generate the audit.
# This routine can be called both in the initial audit and in a recount condition.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		skip_location_lpn - if set this is re-count condition and entering staging location and lodnum is not needed
#		stoloc - outbound staging location
#		lodnum - load number
#		prtnum - part number
#		stkuom - unit of measure relative to prtnum
#		audqty - quantity to enter during audit (if not equal to untqty then this will generate a mismatch)
#		client_id - client ID
#	Optional:
#		None
# Outputs:
#	None
##################################################################

Once I see "RF Outbound Audit" on line 1 in terminal

if I verify text $skip_location_lpn is equal to "FALSE" ignoring case
	Given I "get lodnum, location, and uom via MSQL"
		Then I execute scenario "Get Lodnum and Location from Ship ID"
		And I execute scenario "Get UOM from Prtnum"

	Then I "enter the staging location"
		If I verify text $term_type is equal to "handheld"
			Once I see cursor at line 2 column 5 in terminal
		Else I verify text $term_type is equal to "vehicle"
			Once I see cursor at line 3 column 13 in terminal
		EndIf
		Then I enter $stoloc in terminal
    
	And I "enter the LPN/Lodnum"
		If I verify text $term_type is equal to "handheld"
			Once I see cursor at line 3 column 5 in terminal
		Else I verify text $term_type is equal to "vehicle"
			Once I see cursor at line 4 column 13 in terminal
		EndIf
		Then I enter $lodnum in terminal
		Once I see "Itm:" on line 2 in terminal
	EndIf

And I "enter the prtnum"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 2 column 5 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 2 column 10 in terminal
	EndIf
	Then I enter $prtnum in terminal

And I "press ENTER to accept CLIENT ID"
	If I verify text $client_id is not equal to "----"
		Then I press keys "ENTER" in terminal
	EndIf

And I "enter the quantity observed"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 4 column 5 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 3 column 10 in terminal
	EndIf
	Then I enter $audqty in terminal

And I "enter the UOM"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 4 column 15 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 3 column 22 in terminal
	EndIf
	Then I enter $stkuom in terminal
	Once I see "RF Outbound Audit" on line 1 in terminal
	And I wait $wait_med seconds

And I execute scenario "Terminal Initiate and Acknowledge Outbound Audit"

@wip @private
Scenario: Terminal Initiate and Acknowledge Outbound Audit
###############################################################
# Description: Press F6 and complete outbound audit
# MSQL Files:
#	None
# Inputs:
#	Required:
#		lodnum - load number
#	Optional:
#		None
# Outputs:
#	None
##################################################################

Given I "press F6"
	Then I press keys "F6" in terminal
	Once I see $lodnum in terminal

And I "press F6 to complete the audit"
	Then I press keys "F6" in terminal
	Once I see "Complete the entire" in terminal
	Once I see "outbound audit?" in terminal
	Once I see "(Y|N):" on last line in terminal
	Then I press keys "Y" in terminal

@wip @private
Scenario: Terminal Handle Audit Discrepancies
###############################################################
# Description: During an outbound audit, if there were discrepancies found,
# either fail the test case or perform a re-count.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		discrepancy_action - either fail test (fail) or re-count (recount)
#	Optional:
#		None
# Outputs:
#	None
##################################################################

Given I "check for what process to follow on discrepancy"
	If I verify text $discrepancy_action is equal to "recount" ignoring case
		Then I press keys "ENTER" in terminal
        And I press keys "ENTER" in terminal
		And I assign "TRUE" to variable "skip_location_lpn"
        And I execute scenario "Terminal Perform Outbound Audit"

		Then I verify screen is done loading in terminal within $max_response seconds
		If I see "Audit discrepancy" in terminal within $wait_med seconds
		And I see "exists" in terminal within $wait_med seconds
			Then I press keys "ENTER" in terminal
		EndIf
    Else I verify text $discrepancy_action is equal to "fail" ignoring case
    	Then I press keys "ENTER" in terminal
		And I execute scenario "Terminal Initiate and Acknowledge Outbound Audit"
		And I fail step with error message "ERROR: Outbound Audit found discrepancies, failing test"
    EndIf