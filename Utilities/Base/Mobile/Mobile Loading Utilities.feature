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
# Utility: Mobile Loading Utilities.feature
# 
# Functional Area: Loading
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: Mobile
#
# Description:
# This utility contains scenarios for loading trailers using Mobile App
#
# Public Scenarios:  
#	- Mobile Perform Undirected LTL Loading - find the correct door for loading a trailer using Undirected LTL loading
#	- Mobile Perform Undirected TL Loading - find the correct door for loading a trailer using Undirected TL loading
#	- Mobile Perform LTL Directed Loading of All LPNs for Truck - performs Directed LTL of a dock door
#	- Mobile Perform TL Directed Loading of All LPNs for Truck - performs Directed TL of a dock door
#	- Mobile Outbound Audit - performs an outbound audit of a outbound staging location
#	- Mobile Outbound Unload and Unpick Shipment - unloads a shipping trailer and unpicks inventory.
#
# Assumptions:
# 	None
#
# Notes:
# 	None
#
############################################################
Feature: Mobile Loading Utilities

@wip @public
Scenario: Mobile Outbound Audit
###############################################################
# Description: This scenario will conduct an Outbound audit in the Mobile App.
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

Then I execute scenario "Mobile Perform Outbound Audit"
    
And I "check for results of the audit"
    And I "check for discrepancies"
		If I see "Discrepancies found" in web browser within $screen_wait seconds
			Then I execute scenario "Mobile Handle Audit Discrepancies"
		EndIf

	And I "check for clean audit"
		Then I assign "Audit completed with no discrepancies" to variable "mobile_dialog_message"
		And I execute scenario "Mobile Set Dialog xPath"
		If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
			Then I press keys "ENTER" in web browser
		EndIf

And I unassign variable "skip_location_lpn"

@wip @public
Scenario: Mobile Perform Undirected LTL Loading
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
	Then I execute scenario "Mobile Sign onto Undirected LTL Loading Door"

Then I "load all the LPNs onto the truck"
	While I execute scenario "Get Next LPN for Undirected LTL Trailer Loading"
		Then I execute scenario "Mobile Outbound Undirected Load LPN to LTL Trailer"
	EndWhile 
 
@wip @public
Scenario: Mobile Perform Undirected TL Loading
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
	Then I execute scenario "Mobile Sign onto Undirected TL Loading Door"

Then I "load all the LPNs onto the truck"
	While I execute scenario "Get Next LPN for Undirected TL Trailer Loading"
		Then I execute scenario "Mobile Outbound Load LPN to Trailer"
	EndWhile 
	
Then I "perform trailer completion logic" 
	Given I execute scenario "Mobile Outbound Trailer Completion"    
	
@wip @public
Scenario: Mobile Sign onto Undirected TL Loading Door
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
	Then I assign "Dock" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $yard_loc in element "name:yard_loc" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

Then I "press enter at the prepopulated load and stop fields"
	Then I assign "Load ID" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	And I press keys "ENTER" in web browser

	Then I assign "Stop ID" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	And I press keys "ENTER" in web browser

And I "check to see if we have a workflow and process the workflow"
	If I see "Confirm Workflow" in web browser within $wait_med seconds 
		Then I execute scenario "Mobile Process Workflow"
	EndIf  
	
@wip @public
Scenario: Mobile Perform LTL Directed Loading of All LPNs for Truck 
#############################################################
# Description: This scenario performs Directed LTL of a dock door. It performs 
# the loading of all the staged LPNS for a door.
# MSQL Files:
#	None      
# Inputs:
#	Required:
#		username - Username signed into Mobile App
#		dock_door - Dock Door being loaded
#		devcod - Device Code
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I execute scenario "Mobile Loading Sign On"

Then I "load all the LPNs waiting to be loaded"
	While I see "Loading Pickup" in web browser within $screen_wait seconds
		If I execute scenario "Get Next LPN for Directed LTL Trailer Loading"
			  Then I execute scenario "Mobile Outbound Load LPN to Trailer"      
		EndIf
	EndWhile

@wip @public
Scenario: Mobile Perform TL Directed Loading of All LPNs for Truck 
#############################################################
# Description: This scenario performs Directed TL of a dock door.  It assigns
# the user to the door, gets the directed work, then it performs 
# the loading of all the staged LPNS for a door.
# MSQL Files:
#	None          
# Inputs:
#	Required:
#		username - Username signed into Mobile App
#		dock_door - Dock Door being loaded
#		devcod - Device Code
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I execute scenario "Mobile Loading Sign On"

When I "load all the LPNs waiting to be loaded"
	While I see "Loading Pickup" in web browser within $screen_wait seconds 
		If I execute scenario "Get Next LPN for Directed TL Trailer Loading"
			  Then I execute scenario "Mobile Outbound Load LPN to Trailer"      
		EndIf
	EndWhile
	
Then I "perform trailer completion logic" 
	Given I execute scenario "Mobile Outbound Trailer Completion"
 
@wip @public
Scenario: Mobile Outbound Unload and Unpick Shipment
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

		Once I see "Unload Equip" in element "className:appbar-title" in web browser

		And I assign "LPN" to variable "input_field_with_focus"
		Then I execute scenario "Mobile Check for Input Focus Field"
		And I type $pck_lodnum in element "name:invtid" in web browser within $max_response seconds
		Then I press keys "ENTER" in web browser

		If I see "Confirm Workflow" in web browser within $wait_med seconds 
			Then I execute scenario "Mobile Process Workflow"
		EndIf  

		And I "enter destination location - ship staging location"
			Then I assign "Destination Location" to variable "input_field_with_focus"
			And I execute scenario "Mobile Check for Input Focus Field"
			Then I type $shpstg_loc in element "name:dstloc" in web browser within $max_response seconds
			And I press keys "ENTER" in web browser

			Then I assign "OK To Unload" to variable "mobile_dialog_message"
			And I execute scenario "Mobile Set Dialog xPath"
			Once I see element $mobile_dialog_elt in web browser
			Then I press keys "Y" in web browser

		Then I "am processing unpick based on the input variable"
			If I do not see "OK To Unpick?" in web browser within $screen_wait seconds
				Then I press keys "F6" in web browser
				If I see "OK To Unpick" in web browser within $wait_long seconds
				Else I echo "Retrying F6 operation"
			     	And I press keys "F6" in web browser
				EndIf
				Once I see "OK To Unpick" in web browser
			EndIf
			If I verify text $ok_to_unpick is equal to "Y"
				Then I press keys $ok_to_unpick in web browser
				And I execute scenario "Mobile Perform Unpick"
			Else I press keys $ok_to_unpick in web browser
			EndIf

		If I do not see "Unload Equip" in web browser within $screen_wait seconds
		And I see "Unpick" in web browser within $screen_wait seconds
			Then I press keys "F1" in web browser
		EndIf
		Then I increase variable "row_count"
	EndWhile

#############################################################
# Private Scenarios:
#	Mobile Loading Sign On - signs the user into the door and performs Trailer Workflows if prompted
#	Mobile Sign onto Undirected LTL Loading Door - sign into a door for Undirected LTL Loading
#	Mobile Outbound Undirected Load LPN to LTL Trailer - pick up and deposit a single LPN on Undirected LTL loading screen
#	Mobile Sign onto Undirected TL Loading Door - sign into a door for UndirectedTL Loading
#   Mobile Outbound Trailer Completion - stop closing logic within the Mobile App
#	Mobile Outbound Load LPN to Trailer - process the TL/LTL loading screen
#	Mobile Perform Outbound Audit - Assist in conducting an Outbound audit in the Mobile App
#	Mobile Initiate and Acknowledge Outbound Audit - Press F6 and complete outbound audit
#	Mobile Handle Audit Discrepancies - Check if there were discrepancies found, either fail the test case or perform a re-count
#############################################################

@wip @private
Scenario: Mobile Loading Sign On
#############################################################
# Description: This scenario signs the user into the door. Trailer Workflows are performed if prompted.
# MSQL Files:
#	None            
# Inputs:
#	Required:
#		username - Username signed into Mobile App
#		dock_door - Dock Door being loaded
#		devcod - Device Code
#	Optional:
#		None
# Outputs:
#	None
#############################################################
	
Given I "acknowledge the directed work"
	Once I see "Load Equip" in element "className:appbar-title" in web browser    

	Once I see element "xPath://span[contains(text(),'Next [Enter]')]" in web browser
	Then I press keys "ENTER" in web browser
  
Then I "check to see if we have a workflow and process the workflow"
	If I see "Confirm Workflow" in web browser within $wait_med seconds 
		Then I execute scenario "Mobile Process Workflow"
	EndIf

@wip @private
Scenario: Mobile Sign onto Undirected LTL Loading Door
###############################################################
# Description: This scenario will sign into a door for Undirected
# LTL Loading.  The logic will also complete a trailer workflow if necessary.
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
	Then I assign "Carrier" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $carcod in element "name:carcod" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

And I "enter the dock door"
	Then I assign "Dock" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $yard_loc in element "name:yard_loc" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

Then I "check to see if we have a workflow and process the workflow"
	If I see "Confirm Workflow" in web browser within $wait_med seconds 
		Then I execute scenario "Mobile Process Workflow"
	EndIf

@wip @private
Scenario: Mobile Outbound Undirected Load LPN to LTL Trailer 
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
	Once I see "Loading Pickup" in element "className:appbar-title" in web browser

	Then I assign "LPN" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $lodnum in element "name:invtid" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

When I "press F6 to deposit the LPN if still on Loading Pickup screen"
	If I see "Loading Pickup" in web browser within $screen_wait seconds 
		Then I press keys "F6" in web browser
	EndIf 

	Once I see "Loading Deposit" in element "className:appbar-title" in web browser

And I "enter the dock door I am loading"
	Then I assign "Destination Location" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $yard_loc in element "name:dstloc" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

And I "enter the LPN to deposit"
	Then I assign "LPN" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $lodnum in element "name:invtid" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

Once I see "LTL Loading" in element "className:appbar-title" in web browser

@wip @private
Scenario: Mobile Sign onto Undirected TL Loading Door
###############################################################
# Description: This scenario will sign into a door for Undirected
# TL Loading.  The logic will also complete a trailer workflow if necessary.
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
	Then I assign "Dock" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $yard_loc in element "name:yard_loc" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

Then I "press enter at the prepopulated load and stop fields"
	Then I assign "Load ID" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	And I press keys "ENTER" in web browser

	Then I assign "Stop ID" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	And I press keys "ENTER" in web browser

And I "check to see if we have a workflow and process the workflow"
	If I see "Confirm Workflow" in web browser within $wait_med seconds 
		Then I execute scenario "Mobile Process Workflow"
	EndIf 

@wip @private
Scenario: Mobile Outbound Trailer Completion
#############################################################
# Description: This scenario will process the stop closing logic within
# the Mobile App.  This scenario assumes the Mobile App has
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
	Given I execute scenario "Mobile Outbound Trailer Document Entry"

And I "enter the seal number and complete the stop if prompted"
	Given I execute scenario "Mobile Outbound Trailer Complete Stop"
	
@wip @private
Scenario: Mobile Outbound Load LPN to Trailer
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
	Once I see "Loading Pickup" in element "className:appbar-title" in web browser

	Then I assign "LPN" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $lodnum in element "name:lodnum" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	
Then I "end pickup if multiple LPNs exist for trailer. We are loading one at a time."
	If I do not see "Loading Deposit" in web browser within $screen_wait seconds 
		Then I press keys "F6" in web browser
	EndIf
	
Then I "deposit the LPN to the trailer"
	Once I see "Loading Deposit" in element "className:appbar-title" in web browser
    
	Then I assign "Dock Location" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $yard_loc in element "name:dstloc" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

@wip @private
Scenario: Mobile Perform Outbound Audit
###############################################################
# Description: This scenario will assist in conducting an Outbound audit in the Mobile App.
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

Once I see "RF Outbound Audit" in element "className:appbar-title" in web browser

If I verify text $skip_location_lpn is equal to "FALSE" ignoring case
	Given I "get lodnum, location, and uom via MSQL"
		Then I execute scenario "Get Lodnum and Location from Ship ID"
		And I execute scenario "Get UOM from Prtnum"

	Then I "enter the staging location"
		Then I assign "Location" to variable "input_field_with_focus"
		And I execute scenario "Mobile Check for Input Focus Field"
		Then I type $stoloc in element "name:stoloc" in web browser within $max_response seconds
		And I press keys "ENTER" in web browser
    
	And I "enter the LPN/Lodnum"
		Then I assign "Identifier" to variable "input_field_with_focus"
		And I execute scenario "Mobile Check for Input Focus Field"
		Then I type $lodnum in element "name:ID" in web browser within $max_response seconds
		And I press keys "ENTER" in web browser
EndIf

And I "enter the prtnum"
	Then I assign "Item Number" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $prtnum in element "name:prtnum" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

And I "press ENTER to accept CLIENT ID"
	If I verify text $client_id is not equal to "----"
		Then I assign "Item Client ID" to variable "input_field_with_focus"
		And I execute scenario "Mobile Check for Input Focus Field"
		Then I press keys "ENTER" in web browser
	EndIf

And I "enter the quantity observed"
	Then I assign "Qty" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $audqty in element "name:quantity" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

And I "enter the UOM"
	Then I assign "UOM" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $stkuom in element "name:uom" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
    
Once I see "RF Outbound Audit" in element "className:appbar-title" in web browser
And I wait $wait_med seconds

And I execute scenario "Mobile Initiate and Acknowledge Outbound Audit"

@wip @private
Scenario: Mobile Initiate and Acknowledge Outbound Audit
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
	Then I press keys "F6" in web browser
	Once I see $lodnum in web browser

And I "press F6 to complete the audit"
	Then I press keys "F6" in web browser

	Then I assign "Complete the entire outbound audit?" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	Once I see element $mobile_dialog_elt in web browser
	Then I press keys "Y" in web browser

@wip @private
Scenario: Mobile Handle Audit Discrepancies
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
		Then I assign "Identifier" to variable "input_field_with_focus"
		And I execute scenario "Mobile Check for Input Focus Field"
		Then I press keys "ENTER" in web browser
        
		And I wait $screen_wait seconds
        And I press keys "ENTER" in web browser
        
		And I assign "TRUE" to variable "skip_location_lpn"
        And I execute scenario "Mobile Perform Outbound Audit"

		Then I assign "Audit discrepancy exists" to variable "mobile_dialog_message"
		And I execute scenario "Mobile Set Dialog xPath"
		If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
			Then I press keys "ENTER" in web browser
		EndIf
    Else I verify text $discrepancy_action is equal to "fail" ignoring case
    	Then I press keys "ENTER" in web browser
		And I execute scenario "Mobile Initiate and Acknowledge Outbound Audit"
		And I fail step with error message "ERROR: Outbound Audit found discrepancies, failing test"
    EndIf