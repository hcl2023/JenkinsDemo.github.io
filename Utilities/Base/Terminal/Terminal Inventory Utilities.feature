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
# Utility: Terminal Inventory Utilities.feature
# 
# Functional Area: Inventory
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: Terminal, MOCA
#
# Description:
# These Utility Scenarios perform actions specific to Terminal Inventory activities
#
# Public Scenarios:
#	- Terminal Inventory Status Change - Performs an Inventory Status Change
#	- Terminal Inventory Transfer Directed - Performs an Inventory transfer in directed mode
#	- Terminal Inventory Transfer Undirected - Performs an Inventory transfer
#	- Terminal Inventory Adjustment Add - Performs an Inventory Adjustment Add
#	- Terminal Inventory Adjustment Delete - Performs an Inventory adjustment Delete
#	- Terminal Inventory Adjustment Change - Performs an Inventory Adjustment increase or decrease
#	- Terminal Inventory Adjustment References - On Adjustment, add references and reason
#	- Terminal Inventory Adjustment Complete - Confirm the Inventory Adjustment
#	- Inventory Transfer Validate Location - Validates lodnum is at a specified location
#	- Get Location Status from Location - Get locsts relative to a given stoloc
#	- Terminal Inventory Putaway Directed Override - Perform putaway. If specified, will override location with F4
#	- Terminal Inventory Display - Inventory display relative to lodnum and prtnum
#	- Terminal Inventory Location Display - Inventory Location Display relative to specified location
#	- Validate Partial Move Was Successful - validate that the partial move was successfull by checking inventory by prtnum and quantity
#	- Terminal Partial Inventory Move - performs a Partial Inventory Move
#	- Terminal Inventory Transfer Invalid - Performs an inventory move to a storage trailer not at dock door.
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Terminal Inventory Utilities

@wip @public
Scenario: Terminal Inventory Transfer Invalid
#############################################################
# Description: Perform an inventory transfer with an
# storage location not at dock door (should get message
# about Invalid location)
# MSQL Files:
#	None
# Inputs:
#	Required:
#		xfer_lodnum - LPN to be transferred
#		dstloc - Invalid location where deposit will first be attempted to (and fail)
#		valid_dstloc - Valid location where deposit will eventually be made to
#	Optional:
#		None
# Outputs:
# 	None   
#############################################################

Given I "check to make sure destination location is not full"
	Then I assign $dstloc to variable "loc_to_check"
	And I execute scenario "Get Location Status from Location"
	If I verify text $location_status is equal to "F" ignoring case
		Then I assign variable "error_string" by combining "ERROR: Destination location is Full (" $dstloc ")"
		And I fail step with error message $error_string
	EndIf

And I "validate I am on the inventory move screen"
	If I verify text $term_type is equal to "handheld"
		Once I see "Full Inv Move" on line 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see "Full Inventory Move" on line 1 in terminal
    EndIf

When I "input the LPN to Be Transferred"
	When I scan $xfer_lodnum in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see "Full Inv Move" on line 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see "Full Inventory Move" on line 1 in terminal
	Endif

And I "press F6 to Deposit"
	When I press keys "F6" in terminal
	Once I see "MRG" on line 1 in terminal

And I "enter the invalid location, checking to make sure we see the invalid message"
	Then I assign $dstloc to variable "dep_loc"
	And I enter $dstloc in terminal

	Once I see "Invalid location" in terminal
	Then I press keys "ENTER" in terminal
    
And I "deposit to a good location"
	Then I unassign variables "dep_loc,dstloc"
    And I assign value $valid_dstloc to unassigned variable "dep_loc"
	And I assign value $valid_dstloc to unassigned variable "dstloc"
	Then I execute scenario "Terminal Deposit"

And I unassign variable "loc_to_check"

@wip @public
Scenario: Terminal Inventory Location Display
#############################################################
# Description: Enter sorage location and process information
# on Inventory Location Display screen
# MSQL Files:
#	None
# Inputs:
#	Required:
#		stoloc - storage location for display
#	Optional:
#		generate_screenshot - if requested generate terminal screen shot
# Outputs:
#	None
#############################################################

Given I "enter storage location in inventory location display"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 2 column 6 in terminal 
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 2 column 8 in terminal 
	EndIf
	Then I enter $stoloc in terminal
    
And I "verify data on the screen"
	Then I wait $screen_wait seconds
	If I verify text $term_type is equal to "handheld"
		Once I see $stoloc on line 2 in terminal within $max_response seconds
	Else I verify text $term_type is equal to "vehicle"
		Once I see $stoloc on line 2 in terminal within $max_response seconds
	EndIf

	Given I assign $stoloc to variable "loc_to_check"
	And I execute scenario "Get Location Status from Location"
	If I verify text $location_status is equal to "P" ignoring case
		Then I assign "Partial" to variable "locsts_string"
	Elsif I verify text $location_status is equal to "F" ignoring case
		Then I assign "Full" to variable "locsts_string"
	Elsif I verify text $location_status is equal to "E" ignoring case
		Then I assign "Empty" to variable "locsts_string"
	Elsif I verify text $location_status is equal to "I" ignoring case
		Then I assign "Inventory Error" to variable "locsts_string"
	Else I fail step with error message "ERROR: Could not determine locsts"
	EndIf

	If I verify text $term_type is equal to "handheld"
		Once I see $locsts_string on line 3 in terminal within $max_response seconds
	Else I verify text $term_type is equal to "vehicle"
		Once I see $locsts_string on line 3 in terminal within $max_response seconds
	EndIf

And I "take a terminal screen shot if requested"
    If I verify variable "generate_screenshot" is assigned
	And I verify text $generate_screenshot is equal to "TRUE" ignoring case
		Then I execute scenario "Terminal Generate Screenshot"
	EndIf

And I press keys "ENTER" in terminal

And I unassign variables "locsts_string,loc_to_check"

@wip @public
Scenario: Terminal Inventory Display
#############################################################
# Description: Perform an inventory display relative to 
# lodnum and prtnum
# MSQL Files:
#	None
# Inputs:
#	Required:
#		stoloc - storage location
#		lodnum - load number
#	Optional:
#		prtnum - part number
#		generate_screenshot - if requested generate terminal screen shot
# Outputs:
#	None
#############################################################

Given I "enter lodnum and prtnum (if specified) in inventory display"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 3 column 1 in terminal 
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 2 column 14 in terminal 
	EndIf

	Then I enter $lodnum in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 5 column 1 in terminal 
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 3 column 14 in terminal 
	EndIf

	If I verify variable "prtnum" is assigned
	And I verify text $prtnum is not equal to "" ignoring case
		Then I enter $prtnum in terminal
		If I verify text $client_id is not equal to "----"
			If I verify text $term_type is equal to "handheld"
				Once I see cursor at line 7 column 1 in terminal 
			Else I verify text $term_type is equal to "vehicle"
				Once I see cursor at line 4 column 14 in terminal 
			EndIf
			And I press keys "ENTER" in terminal
		EndIf
	Else I press keys "ENTER" in terminal
	EndIf
    
Then I "press enter through remaining fields in inventory display"
	And I press keys "ENTER" in terminal 7 times with $wait_short seconds delay

And I "move through all possible items relative to lodnum"
	And I verify screen is done loading in terminal within $max_response seconds
	While I do not see "Last Line of" in terminal within $screen_wait seconds
	And I do not see "Press Enter" in terminal within $wait_short seconds
		Then  I "verify data on the screen"
			If I verify text $term_type is equal to "handheld"
				If I verify variable "prtnum" is assigned
				And I verify text $prtnum is not equal to "" ignoring case
					Once I see $prtnum on line 3 in terminal within $max_response seconds
				EndIf
				Once I see $stoloc on line 2 in terminal within $max_response seconds
				Once I see $lodnum on line 5 in terminal within $max_response seconds
			Else I verify text $term_type is equal to "vehicle"
				If I verify variable "prtnum" is assigned
				And I verify text $prtnum is not equal to "" ignoring case
					Once I see $prtnum on line 3 in terminal within $max_response seconds
				EndIf

				Once I see $stoloc on line 2 in terminal within $max_response seconds
				Once I see $lodnum on line 4 in terminal within $max_response seconds
			EndIf
    
	And I "take a terminal screen shot if requested"
    	If I verify variable "generate_screenshot" is assigned
		And I verify text $generate_screenshot is equal to "TRUE" ignoring case
			Then I execute scenario "Terminal Generate Screenshot"
		EndIf
    
	And I press keys "ENTER" in terminal
	And I verify screen is done loading in terminal within $max_response seconds
EndWhile

And I press keys "ENTER" in terminal

@wip @public
Scenario: Terminal Inventory Putaway Directed Override
#############################################################
# Description: Perform product putaway. If override is set
# then will override deposit location with F4, If allocate
# is set, will allocate with F3. If neither is set,
# will perform standard putaway.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		lodnum - the LPN that was deposited
#	Optional:
#		inputs to terminal Deposit:
#		dep_loc - the deposit location
#		override_f2 - use F2 to show overrtide code
#		allocate - TRUE|FALSE - will use F3 to allocate location
#		override - TRUE|FALSE - will use F4 to override location
#		over_code - override code
#		over_dep_loc - override deposit location
# Outputs:
# 	None  
#############################################################

Given I "enter the Lodnum"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 4 column 1 in terminal 
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 3 column 12 in terminal 
	EndIf

	Then I enter $lodnum in terminal
	Once I see "Putaway" on line 1 in terminal
	Once I do not see $lodnum in terminal
    
    Then I press keys "F6" in terminal
	If I see "Could Not Allocate" in terminal within $wait_long seconds 
		Then I press keys "ENTER" in terminal
	EndIf
    
    And I "perform deposit"
    	Then I execute scenario "Terminal Deposit"

@wip @public
Scenario: Get Location Status from Location
#############################################################
# Description: This scenario returns locsts relative to a stoloc
# MSQL Files: 
#	check_location_status.msql
# Inputs:
#   Required:
#   	loc_to_check - location to check status
#       wh_id - warehouse ID
#	Optional:
#		None
# Outputs:
# 	location_status - location status
#############################################################

When I "check for available inventory transfers and assign it to the user"
   	Then I assign "check_location_status.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
    If I verify MOCA status is 0
    	Then I assign row 0 column "locsts" to variable "location_status"
	Else I fail step with error message "ERROR: Could not determine locstst from specified location"
    Endif  

@wip @public
Scenario: Terminal Inventory Transfer Undirected
#############################################################
# Description: This scenario performs a Full Inv Move
# MSQL Files:
#	None
# Inputs:
#	Required:
#		xfer_lodnum - LPN to be transferred
#		dstloc - Location where LPN will be deposited
#	Optional:
#		xfer_lodnum_list - Comma separate list of LPNs to be transferred
# Outputs:
# 	None           
#############################################################

Given I "check to make sure destination location is not full"
	Then I assign $dstloc to variable "loc_to_check"
	And I execute scenario "Get Location Status from Location"
    If I verify text $location_status is equal to "F" ignoring case
    	Then I assign variable "error_string" by combining "ERROR: Destination location is Full (" $dstloc ")"
		And I fail step with error message $error_string
	EndIf

And I "validate I am on the inventory move screen"
	If I verify text $term_type is equal to "handheld"
		Once I see "Full Inv Move" on line 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see "Full Inventory Move" on line 1 in terminal
    EndIf

And I "look to see if we have multiple LPNs to move"
	If I verify variable "xfer_lodnum_list" is assigned
	And I verify text $xfer_lodnum_list is not equal to ""
		Then I assign $xfer_lodnum_list to variable "xfer_lodnum_list_local"
	Else I assign $xfer_lodnum to variable "xfer_lodnum_list_local"
	EndIf
    
When I "input the LPN to Be Transferred"
	Then I assign 1 to variable "lodnum_cnt"
	While I assign $lodnum_cnt th item from "," delimited list $xfer_lodnum_list_local to variable "xfer_lodnum_local"
		When I scan $xfer_lodnum_local in terminal
		If I verify text $term_type is equal to "handheld"
			Once I see "Full Inv Move" on line 1 in terminal
		Else I verify text $term_type is equal to "vehicle"
			Once I see "Full Inventory Move" on line 1 in terminal
		Endif

		And I increase variable "lodnum_cnt" by 1
	EndWhile
	
And I "press F6 to Deposit"
	When I press keys "F6" in terminal
	Once I see "MRG" on line 1 in terminal

And I "perform the Inventory Move"
	Given I assign $dstloc to variable "dep_loc"
	When I execute scenario "Terminal Product Deposit"

And I unassign variables "loc_to_check,lodnum_cnt,xfer_lodnum_local,xfer_lodnum_list_local"

@wip @public
Scenario: Terminal Partial Inventory Move
#############################################################
# Description: This scenario performs a Partial Inventory Move
# MSQL Files:
#	None
# Inputs:
#	Required:
#		srclod - LPN to be transferred
#		dstloc - Location where LPN will be deposited
#		move_qty - Quantity to be moved
#	Optional:
#		srclod_list - Comma separate list of LPNs to be transferred
# Outputs:
# 	None           
#############################################################

Given I "check to make sure destination location is not full"
	Then I assign $dstloc to variable "loc_to_check"
	And I execute scenario "Get Location Status from Location"
	If I verify text $location_status is equal to "F" ignoring case
		Then I assign variable "error_string" by combining "ERROR: Destination location is Full (" $dstloc ")"
		And I fail step with error message $error_string
	EndIf

And I "validate I am on the partial inventory move screen"
	If I verify text $term_type is equal to "handheld"
		Once I see "Part Inv Move" on line 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see "Partial Inventory Move" on line 1 in terminal
	EndIf

And I "look to see if we have multiple LPNs to move"
	If I verify variable "srclod_list" is assigned
	And I verify text $srclod_list is not equal to ""
		Then I assign $srclod_list to variable "srclod_list_local" 
	Else I assign $srclod to variable "srclod_list_local"
	EndIf

When I "input each LPN to be transferred"
	Then I assign 1 to variable "lodnum_cnt"
	While I assign $lodnum_cnt th item from "," delimited list $srclod_list_local to variable "srclod_local"  
		When I "input the LPN to Be Transferred"
		Then I enter $srclod_local in terminal
		And I "expect to be in the quantity field to scan partial quantity"
			If I verify text $term_type is equal to "handheld"
				Once I see cursor at line 15 column 3 in terminal
			Else I verify text $term_type is equal to "vehicle"
				Once I see cursor at line 7 column 20 in terminal
			EndIf
    
    	And I "scan the partial quantity"
    		Given I execute scenario "Terminal Clear Field"
    		Then I enter $move_qty in terminal
    		And I wait $screen_wait seconds
    		Then I "enter through the UOM field as I am not going to change it"
    			And I press keys "Enter" in terminal
	
				If I verify text $term_type is equal to "handheld"
					Once I see "Part Inv Move" on line 1 in terminal
				Else I verify text $term_type is equal to "vehicle"
					Once I see "Partial Inventory Move" on line 1 in terminal
				Endif

		And I increase variable "lodnum_cnt" by 1
	EndWhile
	
And I "press F6 to Deposit"
	When I press keys "F6" in terminal
	Once I see "MRG" on line 1 in terminal

And I "perform the Inventory Move"
	Given I assign $dstloc to variable "dep_loc"
	When I execute scenario "Terminal Product Deposit"

And I unassign variables "loc_to_check,srclod_list_local,srclod_local,lodnum_cnt"

@wip @public
Scenario: Validate Partial Move Was Successful
#############################################################
# Description: This scenario validate that the partial move
# was successfull by checking inventory by prtnum and quantity
# MSQL Files:
#	validate_inventory_location_by_prtnum_untqty.msql
# Inputs:
#	Required:
#		dstloc - Location where LPN will be deposited
#		move_qty - Quantity to be moved
#	Optional:
#		None
# Outputs:
# 	None           
#############################################################

Given I "validate that the partial inventory move was successful"
	And I assign "validate_inventory_location_by_prtnum_untqty.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	And I verify MOCA status is 0

@wip @public
Scenario: Terminal Inventory Transfer Directed 
#############################################################
# Description: Perform an Inventory Transfer in Directed work mode
# MSQL Files:
#	None
# Inputs:
#	Required:
#		srcloc - source location for the transfer
#		dstloc -  destination location for the transfer
#		xfer_lodnum - lodnum to transfer
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I "check to make sure destination location is not full"
	Then I assign $dstloc to variable "loc_to_check"
	And I execute scenario "Get Location Status from Location"
    If I verify text $location_status is equal to "F" ignoring case
    	Then I assign variable "error_string" by combining "ERROR: Destination location is Full (" $dstloc ")"
		And I fail step with error message $error_string
	EndIf
    
And I "am on Directed Work Screen"
	Once I see "Pickup Product At" on line 1 in terminal

And I "Enter the transfer source location and get to Product Pickup Screen"
	If I see $srcloc in terminal within $wait_med seconds
	And I see "Press Enter To Ack" in terminal within $wait_med seconds
   		Then I press keys "ENTER" in terminal
	Else I fail step with error message "ERROR: The srcloc for the work given does not match the dataset. Use WMS work queue to resolve"
	EndIf
	
	If I see "Product Pickup" on line 1 in terminal within $wait_long seconds
    	Then I assign "TRUE" to variable "proceed"
    ElsIf I see "Replenish Pick" on line 1 in terminal within $wait_long seconds
    	Then I assign "TRUE" to variable "proceed"
    ElsIf I fail step with error message "ERROR: Expected text not found on terminal screen"
    EndIf
    
    If I verify text $proceed is equal to "TRUE"
      If I verify text $term_type is equal to "handheld"
          Once I see cursor at line 8 column 6 in terminal 
      Else I verify text $term_type is equal to "vehicle"
          Once I see cursor at line 5 column 6 in terminal
      EndIf

  	  And I "scan the transfer lodnum and press F6 to deposit and complete transfer"
      Then I scan $xfer_lodnum in terminal
      If I see "no rows affected" in terminal within $wait_med seconds 
          Then I fail step with error message "ERROR: The lodnum for the work given does not match the dataset. Use WMS work queue to resolve"
      EndIf
      And I assign $dstloc to variable "dep_loc"

      If I see "Directed Mode" in terminal within $wait_med seconds 
          Then I wait $screen_wait seconds 
          And I press keys F6 in terminal
      EndIf
      And I execute scenario "Terminal Deposit"

  	  And I "Terminal Exit Directed Work Mode"
      If I see "Directed Mode" in terminal within $wait_med seconds 
          Then I press keys F1 in terminal
      EndIf 
      If I see "Press Enter To Ack" in terminal within $wait_med seconds 
          Then I press keys F1 in terminal
      EndIf
    EndIf

And I unassign variable "loc_to_check"

@wip @public
Scenario: Terminal Inventory Adjustment Add
#############################################################
# Description: Perform an Inventory Adjustment to Add
# Inventory to a specified Location
# MSQL Files:
#	None
# Inputs:
#	Required:
#		stoloc - Location where the adjustment will take place
#		lodnum - Load number that was added 
#		prtnum - Valid part number that is assigned in your system
#		client_id - Client for the adjustment inventory
#		reacod - System reason code for adjustment/add
#		invsts - Inventory status
#		lotnum - Lot Number for item to be added
#		ftpcod - Footprint code for item to be added
#		uom - Unit of measure
#		adjref1 - Adjustment reference 1 (defaults to stoloc value)
#		adjref1 - Adjustment reference 2 (defaults to prtnum value)
#		untqty - The quantity of inventory we want to add
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I "am at the Inventory Adjustment Screen"
	Once I see "Inventory Adjustment" in terminal

And I "enter my Location"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 8 column 2 in terminal
	Else I verify text $term_type is equal to "vehicle"
    	Once I see cursor at line 4 column 16 in terminal
	EndIf
	When I enter $stoloc in terminal
	If I see "Location is empty" in terminal within $wait_med seconds
		Then I press keys "F3" in terminal
	EndIf
	
And I "enter my Client ID"
	If I verify text $client_id is not equal to "----"
		If I verify text $term_type is equal to "handheld"
			Once I see cursor at line 3 column 6 in terminal
		Else I verify text $term_type is equal to "vehicle"
			Once I see cursor at line 2 column 32 in terminal
		EndIf
		When I enter $client_id in terminal
	EndIf
	
And I "enter my Load Number"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 5 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 3 column 10 in terminal
	EndIf
	If I verify variable "lodnum" is assigned
		When I enter $lodnum in terminal
	Else I press keys "F3" in terminal
		And I press keys "ENTER" in terminal
	EndIf

And I "enter my Part Number"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 7 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 4 column 10 in terminal
	EndIf
	When I enter $prtnum in terminal

And I "confirm U/C"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 9 column 6 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 5 column 10 in terminal
	EndIf
	When I press keys "ENTER" in terminal
	
And I "enter Quantity"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 10 column 8 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 6 column 12 in terminal
	EndIf
	When I enter $untqty in terminal
	
And I "confirm the Unit of Measure"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 10 column 15 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 6 column 18 in terminal
	EndIf
	When I press keys "ENTER" in terminal
	
And I "enter Inventory Status"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 12 column 6 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 6 column 28 in terminal
	EndIf
	When I enter $invsts in terminal
	
And I "process Lot if Configured"
	If I see "Identify Product" in terminal within $wait_med seconds
	And I see "Sup Lot:" in terminal
		If I verify text $term_type is equal to "handheld"
			Once I see cursor at line 5 column 1 in terminal
		Else I verify text $term_type is equal to "vehicle"
			Once I see cursor at line 3 column 12 in terminal
		EndIf
		When I enter $lotnum in terminal
	EndIf
	
And I "add References and Reason Code if Configured"
	If I see "Adjustment Ref" in terminal within $wait_med seconds
		Then I execute scenario "Terminal Inventory Adjustment References"
	EndIf
	
@wip @public
Scenario: Terminal Inventory Adjustment Delete
#############################################################
# Description: Conduct a terminal inventory adjustment delete
# operation.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		stoloc - Location where the adjustment will take place
#		lodnum - Load number that was added 
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

And I "enter the Location"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 8 column 2 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 4 column 16 in terminal 
	EndIf 
	And I enter $stoloc in terminal
	
And I "validate my Load is in the Location"
	Once I see $lodnum in terminal

And I "select the Delete Option"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 5 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 4 column 1 in terminal 
	EndIf
	And I press keys "F4" in terminal

And I "add References and Reason Code if Configured"
	If I see "Adjustment Ref" in terminal within $wait_med seconds 
		Then I execute scenario "Terminal Inventory Adjustment References"
	EndIf
 
@wip @public
Scenario: Terminal Inventory Adjustment Change
#############################################################
# Description: Perform an Inventory Adjustment Change
# to increase or decrease the amount of inventory
# MSQL Files:
#	None
# Inputs:
#	Required:
#		stoloc - Location where the adjustment will take place
#		lodnum - Load number that was added 
#		reacod - System reason code for adjustment.
#		adjref1 - Adjustment reference 1 (defaults to stoloc value)
#		adjref1 - Adjustment reference 2 (defaults to prtnum value)
#		new_qty - The new quantity we want to adjust to (increase/decrease)
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I "enter my Location"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 8 column 2 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 4 column 16 in terminal 
	EndIf
	Then I enter $stoloc in terminal
	
And I "validate my Load is in the Location"
	Once I see $lodnum in terminal 
	And I press keys "ENTER" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 16 column 6 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 8 column 27 in terminal 
	EndIf

And I "enter the New Quantity"
	Given I execute scenario "Terminal Clear Field"
	And I enter $new_qty in terminal
	
And I "confirm Unit of Measure"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 16 column 16 in terminal 
	Else I verify text $term_type is equal to "vehicle" 
		Once I see cursor at line 8 column 36 in terminal 
	EndIf
	And I press keys "ENTER" in terminal
	
And I "add References and Reason Code if Configured"
	If I see "Adjustment Ref" in terminal within $wait_med seconds 
		Then I execute scenario "Terminal Inventory Adjustment References"
	EndIf 
	When I execute scenario "Terminal Inventory Adjustment Complete"
	And I press keys "F1" in terminal

@wip @public
Scenario: Terminal Inventory Adjustment References
#############################################################
# Description: Add Adjustment References and Reason for 
# an adjustment operation
# MSQL Files:
#	None
# Inputs:
#	Required:
#		reacod - System reason code for adjustment.
#		adjref1 - Adjustment reference 1 (defaults to stoloc value)
#		adjref2 - Adjustment reference 2 (defaults to prtnum value)
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I "specify the Inventory Adjustments References and Reason"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 6 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 5 column 10 in terminal 
	EndIf 
	And I enter $adjref1 in terminal

	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 8 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 6 column 10 in terminal 
	EndIf 
	And I enter $adjref2 in terminal
	
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 10 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 7 column 10 in terminal 
	EndIf 
	And I enter $reacod in terminal

@wip @public
Scenario: Terminal Inventory Adjustment Complete
#############################################################
# Description: Complete and confirm an Inventory Adjustment 
# relative to the Storage Location
# MSQL Files:
#	None
# Inputs:
#	Required:
#		stoloc - Location where the adjustment will take place
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I "Create/Delete/Update the Inventory"
	If I see "OK To " in terminal within $wait_med seconds 
	And I see "(Y|N)" in terminal within $wait_med seconds 
		Then I type "Y" in terminal
	EndIf 
 
And I "acknowledge Approval is Required if Create/Delete Adjustment is Above Configured Threshold"
	If I see "Approval Required" in terminal within $wait_med seconds 
		Then I press keys "ENTER" in terminal
	EndIf 
	Once I see "Inventory Adjustment" in terminal
	Once I see $stoloc in terminal
	Then I press keys "F6" in terminal
 
	Once I see "Complete Adjustment?" in terminal
	Then I type "Y" in terminal
 
	Once I see "Press" in terminal
	Once I see "Enter" in terminal
	
And I "acknowledge Adjustment Completed or Acknowledge Approval is Required"
	If I do not see "Adjustment Completed" in terminal within $wait_med seconds
	And I do not see "Approval Required" in terminal within $wait_med seconds
		Then I fail step with error message "ERROR: Failed to complete adjustment or acknowledge approval required"
	Else I press keys "ENTER" in terminal
	EndIf
	
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 8 column 2 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 4 column 16 in terminal 
	EndIf
	Then I press keys "F1" in terminal

	If I see "Play Adjustments?" in terminal within $wait_med seconds 
		Then I type "Y" in terminal
	EndIf

@wip @public
Scenario: Inventory Transfer Validate Location
#############################################################
# Description: Ensure a given lodnum (LPN) is now in the expected location 
# (such as after an inventory move).
# MSQL Files:
#	validate_inventory_location_by_lodnum.msql
# Inputs:
#	Required:
#		dstloc - Location where the load should be
#		xfer_lodnum - the lodnum to validate, either this or lodnum should be set
#		lodnum - the lodnum to validate, either this or xfer_lodnum should be set
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I "validate that the destination location contains the specified lodnum"
	Then I verify variable "dstloc" is assigned
	And I assign $dstloc to variable "validate_dstloc"

	If I verify variable "xfer_lodnum" is assigned
	And I verify text $xfer_lodnum is not equal to ""
		Then I assign $xfer_lodnum to variable "validate_lodnum"
	ElsIf I verify variable "lodnum" is assigned
	And I verify text $lodnum is not equal to ""
		Then I assign $lodnum to variable "validate_lodnum"
	EndIf
	
	And I assign "validate_inventory_location_by_lodnum.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
	Else I fail step with error message "ERROR: could not find specified lodnum in destination location"
	EndIf

@wip @public
Scenario: Terminal Inventory Status Change
#############################################################
# Description: Perform a status change on inventory in the terminal
# MSQL Files:
#	None
# Inputs:
#	Required:
#		lodnum - Load number being adjusted in 
#		reacod - System reason code for the change
#		new_sts - Status change value
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I "verify we are on the Terminal Inventory Screen"
	Once I see "Inventory Status" in terminal

And I "enter the load number for the status change"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 4 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 3 column 20 in terminal 
	EndIf 
	And I enter $lodnum in terminal

And I "change the inventory status"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 8 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 5 column 20 in terminal 
	EndIf
	And I enter $new_sts in terminal

And I "provide a reason code"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 10 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 6 column 20 in terminal 
	EndIf 
	And I enter $reacod in terminal
	
And I "confirm the change"
	Once I see "Ok to Change Status" in terminal
	Then I type "Y" in terminal
	Once I see "Status Changed" in terminal 
	Then I press keys "ENTER" in terminal
	
############################################################
# Private Scenarios:
# None
#############################################################