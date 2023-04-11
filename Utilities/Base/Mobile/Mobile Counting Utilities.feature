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
# Utility: Mobile Counting Utilities.feature
# 
# Functional Area: Inventory
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Utility
# Blue Yonder Interfaces Interacted With: Mobile, MOCA
#
# Description:
# These Utility Scenarios perform actions specific to Mobile Counting activities
#
# Public Scenarios:
#	- Mobile Inventory Perform LPN Count  - Perform LPN Count process
#	- Mobile Inventory Count Process Directed Work Screen - process initial directed work screen for a count
#	- Mobile Inventory Count Enter Batch and Location Undirected Work - enter count batch and stoloc and process count screen
#	- Mobile Inventory Count Complete Undirected Work - Check for completion of undirected count
#	- Mobile Inventory Audit Count Enter Batch and Location Undirected Work - enter the count batch and the location in Undirected work mode
#	- Mobile Inventory Audit Count Perform Count - perform the audit count operation
#	- Mobile Inventory Audit Count Complete Count - complete the audit count operation
#	- Mobile Inventory Audit Count Enter Location Directed Work - Enter Location in Directed Mode work mode
#	- Mobile Inventory Audit Count Add LPN - Add LPN during an audit count by counting an item not in the audit's location
#	- Mobile Inventory Perform Detail Count - Perform Detail Count process
#	- Mobile Inventory Perform Summary Count - Perform Summary Count process
#	- Mobile Manual Count Process - Perform Manual Count
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Mobile Counting Utilities

@wip @public
Scenario: Mobile Manual Count Process
#############################################################
# Description: Handles the logic for manual count process. Selects an LPN or stoloc based on input, 
# and proceeds to perform a manual count
# MSQL Files:
#	get_inventory_details_for_manual_count.msql
#	get_numUoms_by_part_and_footprint.msql
# Inputs:
#	Required:
#		create_mismatch - Indicates whether a mismatched count is needed.
#		stoloc - Storage location where count will occur
#		man_cnt_mode - Specifies whether the manual count should be performed at "LOAD", "SUB" or "DETAIL" level
#		create_mismatch - Specifies whether to create a count mismatch (TRUE|FALSE)
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Once I see "Manual Count" in element "className:appbar-title" in web browser

Given I "select the LPN to manual count"
	Then I assign "get_inventory_details_for_manual_count.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	And I verify MOCA status is 0
	And I assign row 0 column "inv_count" to variable "inv_count_in_location"
	And I assign "0" to variable "row_index"
	And I convert string variable "row_index" to integer variable "row_index"
    
Then I "enter the Inventory ID"
	Then I assign "Inventory Identifier" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $stoloc in element "name:invtid" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

While I verify number $row_index is less than $inv_count_in_location
	Then I assign "get_inventory_details_for_manual_count.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
		Then I assign row $row_index column "invtid" to variable "invtid"
		And I assign row $row_index column "untqty" to variable "untqty"
		And I assign row $row_index column "prtnum" to variable "prtnum"
		And I assign row $row_index column "prt_client_id" to variable "prt_client_id"
		And I assign row $row_index column "ftpcod" to variable "ftpcod"
	ElsIf I fail step with error message "ERROR: No inventory that matches the selection criteria for manual count"
	Endif
    
	Given I "verify we are on Count Adjustment Screen and Enter lodum"
		Once I see "Count Adjustment" in element "className:appbar-title" in web browser

	And I "see the cursor at the ID Field"
    	Then I assign "Inventory Identifier" to variable "input_field_with_focus"
		And I execute scenario "Mobile Check for Input Focus Field"
		Then I clear all text in element "name:invtid" in web browser
		And I type $invtid in element "name:invtid" in web browser within $max_response seconds
		And I press keys "ENTER" in web browser

	And I "see the cursor should at the Prtnum Field (for load and sub-load tracked parts)"
    	If I verify text $man_cnt_mode is not equal to "DETAIL" ignoring case
    		Then I assign "Item Number" to variable "input_field_with_focus"
			And I execute scenario "Mobile Check for Input Focus Field"
			Then I clear all text in element "name:prtnum" in web browser
			And I type $prtnum in element "name:prtnum" in web browser within $max_response seconds
			And I press keys "ENTER" in web browser

        And I "see the cursor at the Client Field"
            If I verify text $prt_client_id is not equal to "----"
    			Then I assign "Client ID" to variable "input_field_with_focus"
				And I execute scenario "Mobile Check for Input Focus Field"
				Then I clear all text in element "name:prt_client_id" in web browser
				And I type $prt_client_id in element "name:prt_client_id" in web browser within $max_response seconds
				And I press keys "ENTER" in web browser
            EndIf
        EndIf
  
	And I "now expect to be in the quantity capture screen"
		Once I see "Quantity Capture" in element "className:appbar-title" in web browser

	And I "calculate the number of uoms for this part and footprint"
		And I assign "get_numUoms_by_part_and_footprint.msql" to variable "msql_file"
		When I execute scenario "Perform MSQL Execution"
		Then I verify MOCA status is 0
		And I assign row 0 column "numUOMs" to variable "numUOMs"
  
	And I "enter the quantity in the quantity capture screen"
		Given I execute scenario "Calculate Quantity Mismatch Information"
		And I execute scenario "Mobile Enter Count Quantity"
    	And I increase variable "row_index"
EndWhile

And I "press F6 to complete count and look for discrepancy"
	Then I press keys "F6" in web browser
	And I execute scenario "Mobile Wait for Processing" 

	If I verify text $create_mismatch is equal to "TRUE" ignoring case
		Then I assign "Discrepancy Found in this count" to variable "mobile_dialog_message"
		And I execute scenario "Mobile Set Dialog xPath"
		Once I see element $mobile_dialog_elt in web browser
		Then I press keys "ENTER" in web browser
		And I wait $wait_short seconds
        
        Then I assign "Count/Audit cannot be completed.  Counts are still outstanding" to variable "mobile_dialog_message"
		And I execute scenario "Mobile Set Dialog xPath"
		Once I see element $mobile_dialog_elt in web browser
		Then I press keys "Enter" in web browser
		And I wait $wait_short seconds
    
		Then I "validate that the audit was generated"
			And I execute scenario "Validate Audit Count Generated"
	EndIf

@wip @public
Scenario: Mobile Inventory Perform Summary Count 
#############################################################
# Description: Logic to process a Summary Count from the Cycle
# Count Screen. Can handle case where a singular and specified prtnum and 
# prt_client_id are specified and also case where just the stoloc is 
# specified and all items in the location are counted.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		stoloc - Location where the count will take place and 
#                if this is the only input, will count all items
#                in the location.
#		cntbat - Count Batch we are working on
#	Optional:
#		create_mismatch - (TRUE|FALSE) specifies if the quantity should be incremented
#				 to generate a mismatch.
#		blind_counting - (TRUE|FALSE) specifies if the prtnum and prt_client_id
#			     should be entered or just ENTER responses.
#		prtnum - part, if specified along with prt_client_id will
#                count just this prtnum in this stoloc.
#		prt_client_id - client ID. if specified along with prtnum will
#                count just this prtnum in this stoloc.
# Outputs:
# 		None
#############################################################

Given I "am on the Cyle Count Screen"
	Once I see "Cycle Count" in element "className:appbar-title" in web browser

And I "enter the location to count"
	Then I assign "Location" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $stoloc in element "name:vfyloc" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

And I "count the item assigned by the prtnum variable otherwise loop through and count all of the items in the location"
	If I verify variable "prtnum" is assigned
	And I verify variable "prt_client_id" is assigned
    And I verify text $prtnum is not equal to ""
    And I verify text $prt_client_id is not equal to ""
		Then I execute scenario "Mobile Inventory Summary Count Enter Blind or Part Info"
        And I execute scenario "Mobile Inventory Count Process Quantity Capture"
			
        Then I assign "Unexpected Entry" to variable "mobile_dialog_message"
		And I execute scenario "Mobile Set Dialog xPath"
		If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
	  		Then I "know there is a mismatch in what I counted"
	  			And I press keys "ENTER" in web browser
	  		And I "need to enter the quantity again"
	  			Then I execute scenario "Mobile Inventory Count Process Quantity Capture"
		EndIf

	 	# if quantity is entered (or re-entered), screen goes back 
	 	# to the screen where we enter an item number for the same location
	 	# if there is more inventory in the location we would enter it now
	 	# check if there are more items to count in this location
		Given I "am on Cycle Count Screen, I process the count"
			Once I see "Cycle Count" in element "className:appbar-title" in web browser
			When I press keys "F6" in web browser
			And I execute scenario "Mobile Wait for Processing" 
			
			If I see element "xPath://span[contains(text(),'Next [Enter]')]" in web browser within $screen_wait seconds
				Then I press keys "ENTER" in web browser

				Then I assign "OK To Complete Cycle" to variable "mobile_dialog_message"
				And I execute scenario "Mobile Set Dialog xPath"
				Once I see element $mobile_dialog_elt in web browser
				Then I press keys "Y" in web browser
				And I wait $screen_wait seconds 
			EndIf
	Else I "am going to loop through all items in the location"
		Given I execute scenario "Inventory Summary Count Get Next Item to Count"
		While I verify variable "prtnum" is assigned
        And I verify text $prtnum is not equal to ""
			Then I execute scenario "Mobile Inventory Summary Count Enter Blind or Part Info"
            And I execute scenario "Mobile Inventory Count Process Quantity Capture"
			# if quantity is entered and there is no descrepancy, screen goes back 
			# to the screen where we enter an item number for the same location
			# if there is more inventory in the location we would enter it now
			# check if there are more items to count in this location
			Then I assign "Unexpected Entry" to variable "mobile_dialog_message"
			And I execute scenario "Mobile Set Dialog xPath"
			If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		  		Then I "know there is a mismatch in what I counted"
					And I press keys "ENTER" in web browser
		  		Then I "need to enter the quantity again for the same prtnum and quantity"
		  			And I execute scenario "Mobile Inventory Count Process Quantity Capture"
			EndIf

			Then I "reset input parameters so the next loop doesn't get confused"
				And I unassign variables "prtnum,prt_client_id,numUOMs,untqty"

			And I "see if there are more items to count in this location"
				Then I execute scenario "Inventory Summary Count Get Next Item to Count"
		EndWhile
	
		Then I "know there are no more items to count in the location according to what's in the system - press F6"
			Once I see "Cycle Count" in element "className:appbar-title" in web browser
			Then I wait $wait_med seconds
			When I press keys "F6" in web browser
			And I wait $wait_med seconds
			And I execute scenario "Mobile Wait for Processing"
			
			If I see element "xPath://span[contains(text(),'Next [Enter]')]" in web browser within $screen_wait seconds
				Then I press keys "ENTER" in web browser

				Then I assign "OK To Complete Cycle" to variable "mobile_dialog_message"
				And I execute scenario "Mobile Set Dialog xPath"
				Once I see element $mobile_dialog_elt in web browser
				Then I press keys "Y" in web browser
				And I wait $screen_wait seconds 
			EndIf

		If I see "Cycle Count At" in element "className:appbar-title" in web browser within $screen_wait seconds
			Then I "know we completed this location count because the next count is showing up"
		ElsIf I see "Looking" in web browser within $screen_wait seconds 
			Then I "know we completed this location count"
		Else I fail step with error message "ERROR: Something went wrong during summary count"
		EndIf
	EndIf

@wip @public
Scenario: Mobile Inventory Perform Detail Count 
#############################################################
# Description: Logic to process a Detail Count from the Detail
# Cycle Count Screen. Can handle case where a singular and specified lodnum, prtnum and 
# prt_client_id are specified and also case where just the stoloc is 
# specified and all items in the location are counted.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		stoloc - Location where the count will take place and 
#                if this is the only input, will count all items
#                in the location.
#		cntbat - Count Batch we are working on
#	Optional:
#		lodnum - load number
#		create_mismatch - (TRUE|FALSE) specifies if the quantity should be incremented
#				 to generate a mismatch.
#		blind_counting - (TRUE|FALSE) specifies if the prtnum and prt_client_id
#			     should be entered or just ENTER responses.
#		prtnum - part, if specified along with prt_client_id will
#                count just this prtnum in this stoloc.
#		prt_client_id - client ID. if specified along with prtnum will
#                count just this prtnum in this stoloc.
# Outputs:
# 		None
#############################################################

Given I "am on the Detail Cyle Count Screen"
	Once I see "Detail Cycle Count" in element "className:appbar-title" in web browser

And I "enter the location to count"
	Then I assign "Location" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $stoloc in element "name:stoloc" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

Given I "process a single lodnum/prtnum or process all lodnum/prtnums at a stoloc"
	# in each location, we might have multiple LPNs to count
	# loop through the LPNs in this location by selecting the next
	# eligibleLPN to count, using the same logic as the RF screen does.
	# Unless the LPN (lodnum) is passed in, then we need to use that variable
	# and only execute once (no looping)
	If I verify variable "lodnum" is assigned
	And I verify variable "prtnum" is assigned
	And I verify variable "prt_client_id" is assigned
    And I verify text $lodnum is not equal to ""
    And I verify text $prtnum is not equal to ""     
    And I verify text $prt_client_id is not equal to ""
		Then I execute scenario "Mobile Inventory Detail Count Enter Blind or Part Info"
        And I execute scenario "Mobile Inventory Count Process Quantity Capture"
		# if quantity is entered and there is no descrepancy, screen goes back 
		# to the screen where we enter the LPN and the cursor lands on ....
		# the client id field. with one more entry we end up back in the quantities field

		Then I assign "Unexpected Entry - Please Re-Enter" to variable "mobile_dialog_message"
		And I execute scenario "Mobile Set Dialog xPath"
		If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
			Then I press keys "ENTER" in web browser
			Then I "know there is a mismatch in what I counted"                
				If I verify text $client_id is not equal to "----"
    				And I assign "Item Client ID" to variable "input_field_with_focus"
					Then I execute scenario "Mobile Check for Input Focus Field"
					Once I see element "name:prt_client_id" in web browser
					Then I press keys "ENTER" in web browser
				EndIf
                
                And I "need to enter the quantiy again for the same prtnum and quantity"
					Then I execute scenario "Mobile Inventory Count Process Quantity Capture"
		EndIf

		Then I "look to see if we have an triggered an inventory adjustment with serialization and handle it"
			If I see "Adjustment References" in element "className:appbar-title" in web browser within $screen_wait seconds
				Then I execute scenario "Mobile Count Process Adjustment"
			EndIf

	 	# if quantity is entered (or re-entered), screen goes back 
	 	# to the screen where we enter an item number for the same location
	 	# if there is more inventory in the location we would enter it now
	 	# check if there are more items to count in this location
		Once I see "Count Adjustment" in element "className:appbar-title" in web browser

		And I "press F6 and complete count"
			Then I press keys "F6" in web browser
			And I execute scenario "Mobile Wait for Processing" 

			Then I assign "OK To complete this" to variable "mobile_dialog_message"
			And I execute scenario "Mobile Set Dialog xPath"
			Once I see element $mobile_dialog_elt in web browser
			Then I press keys "Y" in web browser
			And I wait $wait_med seconds

		And I "validate that an audit count was generated if test generated a mismatch"
			If I verify text $create_mismatch is equal to "TRUE" ignoring case
				Then I execute scenario "Validate Count Audit Generated"
			EndIf

	# the Mobile screen keeps the counted LPNs, prtnums and quantities 'in memory' and doesn't
	# write each count to the database, so we can't retrieve the 'next' LPN/prtnum combo after each count
	# in this script. So we are going to loop through the moca result set instead. 
	Else I "am going to loop through all LPNs in the location, and through all items on each LPN"
		Then I execute scenario "Inventory Detail Count Get LPNs to Count"
		And I assign 0 to variable "row"
		While I verify number $row is less than $num_rows
			Then I assign row $row column "lodnum" to variable "lodnum"
			And I assign row $row column "prtnum" to variable "prtnum"
			And I assign row $row column "prt_client_id" to variable "prt_client_id" 
			And I assign row $row column "untqty" to variable "untqty"
			And I assign row $row column "numUOMs" to variable "numUOMs" 
			And I increase variable "row"
            
			And I "check if mismatch was requested and calculate the quantity to use"
            	Then I execute scenario "Calculate Quantity Mismatch Information"

			Then I execute scenario "Mobile Inventory Detail Count Enter Blind or Part Info"
            And I execute scenario "Mobile Inventory Count Process Quantity Capture"

			# if quantity is entered and there is no descrepancy, screen goes back 
			# to the screen where we enter the LPN and the cursor lands on ....
			# the client id field. with one more entry we end up back in the quantities field
			Then I assign "Unexpected Entry - Please Re-Enter" to variable "mobile_dialog_message"
			And I execute scenario "Mobile Set Dialog xPath"
			If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
				Then I "know there is a mismatch in what I counted"
					Then I press keys "ENTER" in web browser
					
					If I verify text $client_id is not equal to "----"
    					And I assign "Item Client ID" to variable "input_field_with_focus"
						Then I execute scenario "Mobile Check for Input Focus Field"
						And I press keys "ENTER" in web browser
					EndIf
                
                	And I "need to enter the quantiy again for the same prtnum and quantity"
						Then I execute scenario "Mobile Inventory Count Process Quantity Capture"
			EndIf
			
			# sometimes a message shows 'Please complete this inventory first - Press Enter'
			# re-enter the quantity, just like we do with an unexpected quantity
			Then I assign "Please complete this" to variable "mobile_dialog_message"
			And I execute scenario "Mobile Set Dialog xPath"
			If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
				Then I "know I have to re-enter what I counted"
					And I press keys "ENTER" in web browser
				And I "need to enter the quantity again for the same prtnum and quantity"
					Then I execute scenario "Mobile Inventory Count Process Quantity Capture"
			EndIf
		EndWhile

		And I "know there are no more LPNs to count in the location according to what's in the system - press F6"
			Then I "look to see if we have an triggered an inventory adjustment with serialization and handle it"
				If I see "Adjustment References" in element "className:appbar-title" in web browser within $screen_wait seconds
					Then I execute scenario "Mobile Count Process Adjustment"
				EndIf

			Once I see "Count Adjustment" in element "className:appbar-title" in web browser

			And I "press F6 and complete count"
				Then I press keys "F6" in web browser
				And I execute scenario "Mobile Wait for Processing" 

				Then I assign "OK To complete this" to variable "mobile_dialog_message"
				And I execute scenario "Mobile Set Dialog xPath"
				Once I see element $mobile_dialog_elt in web browser
				Then I press keys "Y" in web browser
				And I wait $wait_med seconds
            
            And I "validate that an audit count was generated if test generated a mismatch"
			If I verify text $create_mismatch is equal to "TRUE" ignoring case
				Then I execute scenario "Validate Count Audit Generated"
			EndIf

		If I see "Cycle Count" in element "className:appbar-title" in web browser within $screen_wait seconds
			Then I "know we completed this location count because the next count is showing up"
		ElsIf I see "Looking" in web browser within $screen_wait seconds 
			Then I "know we completed this location count"
		Else I fail step with error message "ERROR: Something went wrong during detail count"
		EndIf
	EndIf

@wip @public
Scenario: Mobile Inventory Audit Count Enter Location Directed Work
#############################################################
# Description: For Mobile Count Audit, on Count Audit Screen,
# enter the count location
# MSQL Files:
#	None
# Inputs:
#	Required:
#		stoloc - Storage location where audit will take place
#	Optional:
#		None
# Outputs:
# 		None
#############################################################|

Given I "am on Count Audit Screen"
	Once I see "Count Audit" in element "className:appbar-title" in web browser

And I "enter the storage location"
	Then I assign "Location" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $stoloc in element "name:stoloc" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

@wip @public
Scenario: Mobile Inventory Audit Count Complete Count
#############################################################
# Description: For Mobile Count Audit, complete the audit 
# count operation by answering screen question and validating
# operation completed
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I "look to see if we have an triggered an adjustment and handle"
	If I see "Adjustment References" in element "className:appbar-title" in web browser within $screen_wait seconds
		Then I execute scenario "Mobile Count Process Adjustment"
	EndIf

Then I "am on the Count Adjustment Screen - Press F6"
	Once I see "Count Adjustment" in element "className:appbar-title" in web browser
	Then I press keys "F6" in web browser
	And I execute scenario "Mobile Wait for Processing" 

And I "complete the audit by answering Y"
	Then I assign "Could Not Allocate" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		Then I press keys "ENTER" in web browser
	EndIf

	Then I assign "OK To complete this count audit?" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	Once I see element $mobile_dialog_elt in web browser
	Then I press keys "Y" in web browser
	
And I "verify audit is completed successfully"
	Then I assign "Audit Completed Successfully" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	Once I see element $mobile_dialog_elt in web browser
	Then I press keys "ENTER" in web browser

@wip @public
Scenario: Mobile Inventory Audit Count Add LPN
#############################################################
# Description: For Mobile Count Audit, enter lodnum that does not
# exist in location and add new inventory relative to that lodnum/prtnum
# MSQL Files:
#	None
# Inputs:
#	Required:
#		lodnum - lodnum  to add to location during audit
#		prtnum - part number for new inventory
#		untqy - quantity of prtnum to add into inventory
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I "verify we are on Count Adjustment Screen and enter lodnum"
	Once I see "Count Adjustment" in element "className:appbar-title" in web browser
    
	Then I assign "Inventory Identifier" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $lodnum in element "name:invtid" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

And I "validate inventory does not exist and we would like to add"
	Then I assign "Inventory does not exist-do you want to add it?" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	Once I see element $mobile_dialog_elt in web browser
	And I press keys "Y" in web browser

And I "enter client ID"
	If I verify text $client_id is not equal to "----"
		And I assign "Client ID" to variable "input_field_with_focus"
		Then I execute scenario "Mobile Check for Input Focus Field"
		And I type $client_id in element "name:client_id" in web browser within $max_response seconds
		And I press keys "ENTER" in web browser
	EndIf

And I "enter for the LPN of new inventory being added"
	Then I assign "LPN" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	And I press keys "ENTER" in web browser

And I "enter new the prtnum which being added to the location"
	Then I assign "Item Number" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	And I type $prtnum in element "name:prtnum" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

And I "confirm U/C"
	Then I assign "Units Per" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	And I click element "name:untcas" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	
And I "enter quantity"
	Then I assign "Receive Quantity" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	And I type $untqty in element "name:rcvqty" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	
And I "confirm the Unit of Measure"
	Then I assign "UOM" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	And I click element "name:rcvuom" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	
And I "enter Inventory status"
	Then I assign "Inventory Status" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	And I type $invsts in element "name:invsts" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

@wip @public
Scenario: Mobile Inventory Audit Count Perform Count
#############################################################
# Description: For Mobile Count Audit, perform the audit 
# count operation.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		lodnum - load number
#		prtnum - part number
#		cnt_qty - inventory quantity entered in audit count
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I "verify we are on Count Adjustment Screen and enter lodum"
	Once I see "Count Adjustment" in element "className:appbar-title" in web browser
	And I assign "Inventory Identifier" to variable "input_field_with_focus"
	Then I execute scenario "Mobile Check for Input Focus Field"
	And I type $lodnum in element "name:invtid" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

And I "enter prtnum"
	And I assign "Item Number" to variable "input_field_with_focus"
	Then I execute scenario "Mobile Check for Input Focus Field"
	And I type $prtnum in element "name:prtnum" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

And I "enter client ID"
	If I verify text $client_id is not equal to "----"
    	And I assign "Item Client ID" to variable "input_field_with_focus"
		Then I execute scenario "Mobile Check for Input Focus Field"
		And I press keys "ENTER" in web browser
	EndIf
	
And I "see quanity capture screen"
	Once I see "Quantity Capture" in element "className:appbar-title" in web browser
	
And I "enter pallet quantity"
	Then I assign "Quantity" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Once I see element "name:uomqty1" in web browser
	Then I press keys "ENTER" in web browser
	
And I "enter case quantity"
	Then I assign "Quantity" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Once I see element "name:uomqty2" in web browser
	Then I press keys "ENTER" in web browser
	
And I "enter the actual amount we want to count (in eaches)"
	Then I assign "Quantity" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $cnt_qty in element "name:uomqty3" in web browser within $max_response seconds
	Then I press keys "ENTER" in web browser

@wip @public
Scenario: Mobile Inventory Audit Count Enter Batch and Location Undirected Work
#############################################################
# Description: For Mobile Count Audit, on Count Audit Screen,
# enter the count batch and the location
# MSQL Files:
#	None
# Inputs:
#	Required:
#		cnt_id - Count batch for the audit
#		stoloc - Storage location where audit will take place
#	Optional:
#		None
# Outputs:
# 		None
#############################################################|

Given I "am on Count Audit Screen"
	Once I see "Count Audit" in element "className:appbar-title" in web browser

Then I "enter the Count Batch"
	And I assign "Count Batch" to variable "input_field_with_focus"
	Then I execute scenario "Mobile Check for Input Focus Field"
	And I type $cnt_id in element "name:cntbat" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

And I "enter the storage location"
	Then I assign "Location" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $stoloc in element "name:stoloc" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

Once I see "Count Adjustment" in element "className:appbar-title" in web browser

@wip @public
Scenario: Mobile Inventory Perform LPN Count 
#############################################################
# Description: Logic to process a count on LPN Count Screen. 
# Can handle case where a singular and specified lodnum is used
# or where the instance is queried and all LPNs relative to the
# storage location (stoloc) are included.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		stoloc - Location where the count will take place
#		cntbat - Count Batch we are working on
#		committe_inventory_in_count_loc - contunue if comiitted inventory exists
#	Optional:
#		lodnum - The LPN to count in a location. Logic will 
#		         get all LPNs in the location (stoloc) if not defined
# Outputs:
# 		None
#############################################################

Given I "see LPN Count and stoloc on the Screen"
	Once I see "LPN Count" in element "className:appbar-title" in web browser
 	Then I assign "Verify Location" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Once I see $stoloc in web browser 

And I "enter the Location we are counting"
	Then I type $stoloc in element "name:vfyloc" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	And I wait $wait_short seconds

	Then I assign "Committed" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		Then I "have committed Inventory in this location"
			And I type $committed_inventory_in_count_loc in web browser
			And I press keys "ENTER" in web browser
			And I wait $wait_short seconds
	EndIf

When I "count the LPNs in the Location, enter lodnum"
	If I verify variable "lodnum" is assigned
	And I verify text $lodnum is not equal to ""
		Then I assign "Inventory Identifier" to variable "mobile_dialog_message"
		And I execute scenario "Mobile Set Dialog xPath"
		Then I type $lodnum in element "name:invtid" in web browser within $max_response seconds
		And I press keys "ENTER" in web browser
		And I wait $wait_short seconds
        
		Then I "acknowledge Inventory has already been counted if attempting to count a previously counted LPN"
			And I assign "Inventory already" to variable "mobile_dialog_message"
			And I execute scenario "Mobile Set Dialog xPath"
			If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
				Then I press keys "ENTER" in web browser
				And I wait $wait_short seconds
			EndIf
			
		And I "press F6 and process/acknowledge the count"
			Then I press keys "F6" in web browser
			And I execute scenario "Mobile Wait for Processing"

			Once I see "LPNs Counted:" in web browser
			Once I see element "xPath://span[contains(text(),'Next [Enter]')]" in web browser
			Then I press keys "ENTER" in web browser

			Then I assign "OK To Complete Cycle Count?" to variable "mobile_dialog_message"
			And I execute scenario "Mobile Set Dialog xPath"
			Once I see element $mobile_dialog_elt in web browser
			Then I press keys "Y" in web browser
	Else I "loop through all LPNs in the location"
		And I execute scenario "Inventory LPN Count Get Next LPN to Count"
		While I verify variable "lodnum" is assigned
		And I verify text $lodnum is not equal to ""
			Once I see "LPN Count" in element "className:appbar-title" in web browser
			Then I assign "Inventory Identifier" to variable "mobile_dialog_message"
			And I execute scenario "Mobile Set Dialog xPath"
			And I type $lodnum in element "name:invtid" in web browser within $max_response seconds
			And I press keys "ENTER" in web browser
			And I wait $wait_short seconds 
			 
			Then I "acknowledge Inventory has already been counted if attempting to count a previously counted LPN"
				And I assign "Inventory already" to variable "mobile_dialog_message"
				And I execute scenario "Mobile Set Dialog xPath"
				If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
					Then I "will skip this"
						And I press keys "ENTER" in web browser
						And I wait $wait_short seconds
				EndIf
			
			If I see "Unexpected Entry" in web browser within $screen_wait seconds
				Then I "need to enter the LPN"
					And I press keys "ENTER" in web browser
					Once I see "LPN Count" in element "className:appbar-title" in web browser

					Then I assign "Inventory Identifier" to variable "mobile_dialog_message"
					And I execute scenario "Mobile Set Dialog xPath"
					Then I type $lodnum in element "name:invtid" in web browser within $max_response seconds
					And I press keys "ENTER" in web browser
					And I wait $wait_short seconds
				
				And I "reset input parameters so the next loop doesn't get confused"
					Then I unassign variable "lodnum"

			Else I "see no unexpected entries and continue with next iteration"
				Then I execute scenario "Inventory LPN Count Get Next LPN to Count"
			EndIf
		EndWhile

		Then I "know there are no more LPNs to count in the location according to what's in the system - Press F6"
		And I "process the counts (acknowledge and confirm)"
			Once I see "LPN Count" in element "className:appbar-title" in web browser 
			When I press keys "F6" in web browser
          	And I execute scenario "Mobile Wait for Processing"
 
			Once I see element "xPath://span[contains(text(),'Next [Enter]')]" in web browser
			When I press keys "ENTER" in web browser
	
			And I assign "OK To Complete Cycle Count?" to variable "mobile_dialog_message"
			And I execute scenario "Mobile Set Dialog xPath"
			Once I see element $mobile_dialog_elt in web browser
			Then I press keys "Y" in web browser
			And I wait $wait_short seconds

			If I see "LPN Count" in element "className:appbar-title" in web browser within $screen_wait seconds 
				Then I "know we completed this location count because the next count is showing up"
			ElsIf I see "Looking" in web browser within $screen_wait seconds 
				Then I "know we completed this location count"
			EndIf
	EndIf

@wip @public
Scenario: Mobile Inventory Count Process Directed Work Screen
#############################################################
# Description: process initial directed work screen for a count
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
# 		None
#############################################################
        
	If I see "Count At" in element "className:appbar-title" in web browser within $screen_wait seconds
	Elsif I see "Count Audit At" in element "className:appbar-title" in web browser within $screen_wait seconds
	Endif

	Once I see element "xPath://span[contains(text(),'Next [Enter]')]" in web browser
	Then I press keys "ENTER" in web browser
	Once I see "Count" in element "className:appbar-title" in web browser
 
@wip @public
Scenario: Mobile Inventory Count Enter Batch and Location Undirected Work
#############################################################
# Description: From the Cycle Count Menu, enter the count batch
# and storage location infomation
# MSQL Files:
#	None
# Inputs:
#	Required:
#		stoloc - Location where the count will take place
#		cntbat - Count Batch we are working on
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I "am on Cycle Count Screen"
	Once I see "Cycle Count Entry" in element "className:appbar-title" in web browser

Then I "specify Count Batch and Storage Location"
	Then I assign "Count Batch" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $cntbat in element "name:cntbat" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
 
 	Then I assign "Source Location" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $stoloc in element "name:dsploc" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

And I "skip the Count Zone field by pressing Enter"
	Then I assign "Count Zone Code" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
    Then I press keys "ENTER" in web browser
	And I wait $wait_short seconds

And I "process conditions based on screen outputs"
	Then I assign "No More Counts" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		Then I fail step with error message "ERROR: No counts found"
	EndIf

	Then I assign "Committed" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		Then I fail step with error message "ERROR: Committed Inventory exists in location"
	EndIf

@wip @public
Scenario: Mobile Inventory Count Complete Undirected Work
#############################################################
# Description: After count has completed, check screen to make sure
# count it complete and process.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I "check to see if the count has completed"
	Then I assign "No More Counts Found" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		Then I "am done with the test - completed one count location in undirected work mode"
			And I press keys "ENTER" in web browser
			And I wait $wait_med seconds 
	Else I "Stop this scenario because we decided this test would only do one location per run"
	EndIf

And I wait $wait_short seconds

#############################################################
# Private Scenarios:
#	- Mobile Count Process Adjustment- Process Inventory adjustment rererences and serialization if needed
# 	- Mobile Inventory Count Process Quantity Capture - get untqty and numUOMs relative to the stoloc/prtnum
#	- Mobile Enter Count Quantity - Enters count quantity in the Quantity Capture screen
#	- Mobile Inventory Detail Count Enter Blind or Part Info - enter the prtnum and prt_client_id for Detail Count
#	- Mobile Inventory Count Enter Blind or Part Info - generic to count scenario to enter prtnum and prt_client_id
# 	- Mobile Inventory Summary Count Enter Blind or Part Info - enter the prtnum and prt_client_id info for Summary Count
#	- Mobile Check for Count Near Zero Prompt - Checks for the count near zero prompt for count near zero in picking
#	- Mobile Count Near Zero Cycle Count Process - Handles the logic for different modes of count near zero test case
#	- Mobile Process Rematched Count - Processes terminal count near zero by doing a mismatched count first and then a matched count. 
#	- Mobile Process Mismatched Count - Process terminal count near zero by creaing a mismatched count.
#	- Mobile Enter Count Quantity - Enters count quantity in the Quantity Capture screen.
#	- Mobile Unexpected Entry during Count for Count Near Zero - Enters through unexpected entry error during mismatched count
#	- Mobile Count Process Adjustment - Process Inventory adjustment rererences and serialization if needed
#############################################################

@wip @private
Scenario: Mobile Inventory Summary Count Enter Blind or Part Info
#############################################################
# Description: While on the Cycle Count screen, enter the
# prtnum and prt_client_id OR if blind_counting is set, just
# press ENTER for these values.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		blind_counting - (TRUE|FALSE) specifies if the prtnum and prt_client_id
#			            should be entered or just ENTER responses.
#	Optional:
#		prtnum - specified part
#		prt_client_id - specified client ID
# Outputs:
# 		None
#############################################################

Given I "am in the Cycle Count screen where I enter part and quantities"
	Once I see "Cycle Count" in element "className:appbar-title" in web browser

	Then I execute scenario "Mobile Inventory Count Enter Blind or Part Info"

@wip @private
Scenario: Mobile Inventory Detail Count Enter Blind or Part Info
#############################################################
# Description: While on the Count Adjustment screen, enter the
# prtnum and prt_client_id OR if blind_counting is set, just
# press ENTER for these values. 
# MSQL Files:
#	None
# Inputs:
#	Required:
#		blind_counting - (TRUE|FALSE) specifies if the prtnum and prt_client_id
#			             should be entered or just ENTER responses.
#		lodnum - the LPN to count relative to stoloc
#	Optional:
#		prtnum - specified part
#		prt_client_id - specified client ID
# Outputs:
# 		None
#############################################################

Given I "Am in the Count Adjustment screen where I enter LPN and item number"
	Once I see "Count Adjustment" in element "className:appbar-title" in web browser

 	Then I assign "Inventory Identifier" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $lodnum in element "name:invtid" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

	Then I execute scenario "Mobile Inventory Count Enter Blind or Part Info"

@wip @private
Scenario: Mobile Inventory Count Enter Blind or Part Info
#############################################################
# Description: While on the Cycle Count screen, enter the
# prtnum and prt_client_id OR if blind_counting is set, just
# press ENTER for these values.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		blind_counting - (TRUE|FALSE) specifies if the prtnum and prt_client_id
#			            should be entered or just ENTER responses.
#	Optional:
#		prtnum - specified part
#		prt_client_id - specified client ID
# Outputs:
# 		None
#############################################################

	# blind counting does not show the item number so you have to enter it,
	# otherwise, it shows the part number and we only have to press Enter
	If I verify text $blind_counting is equal to "TRUE" ignoring case
		Then I assign "Item Number" to variable "input_field_with_focus"
		And I execute scenario "Mobile Check for Input Focus Field"
		Once I see element "name:prtnum" in web browser
		Then I press keys "ENTER" in web browser
        
		If I verify text $prt_client_id is not equal to "----"
			Then I assign "Item Client ID" to variable "input_field_with_focus"
			And I execute scenario "Mobile Check for Input Focus Field"
        	Once I see element "name:prt_client_id" in web browser
			And I press keys "ENTER" in web browser
		EndIf
	Elsif I verify text $blind_counting is equal to "FALSE" ignoring case
		Then I assign "Item Number" to variable "input_field_with_focus"
		And I execute scenario "Mobile Check for Input Focus Field"
        And I clear all text in element "name:prtnum" in web browser within $max_response seconds
        Then I type $prtnum in element "name:prtnum" in web browser within $max_response seconds
		And I press keys "ENTER" in web browser

		If I verify text $prt_client_id is not equal to "----"
			Then I assign "Item Client ID" to variable "input_field_with_focus"
			And I execute scenario "Mobile Check for Input Focus Field"
			Then I clear all text in element "name:prt_client_id" in web browser within $max_response seconds
        	And I type $prt_client_id in element "name:prt_client_id" in web browser within $max_response seconds
			Then I press keys "ENTER" in web browser
		EndIf
	Endif

@wip @private
Scenario: Mobile Enter Count Quantity
############################################################
# Description: Enters the quantity (correct or mismatched) in the quantity capture count screen.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		untqty - driven from the previous scenarios Inventory Count Get untqty and numUOMs 
#			     and Calculate Quantity Mismatch Information for Count Zero.
# 	Optional:
#       None
# Outputs:
#	None
#############################################################

Given I "enter the quantity (for each UOM) and post it to the screen"
	Then I assign 1 to variable "rownum"
	And I convert string variable "numUOMs" to integer variable "numUOMs_num"
	While I verify number $numUOMs_num is greater than or equal to $rownum
		Then I assign variable "elt" by combining "name:" "uomqty" $rownum
		And I see element $elt in web browser within $screen_wait seconds
		If I verify number $numUOMs_num is equal to $rownum
			And I type $untqty in element $elt in web browser within $max_response seconds
		Endif
		And I press keys "ENTER" in web browser
		
		And I wait $wait_short seconds 
		Then I increase variable "rownum"
	EndWhile

@wip @private
Scenario: Mobile Inventory Count Process Quantity Capture
#############################################################
# Description: While on the Quantity Capture screen, call scenario
# to get untqty and numUOMs relative to the stoloc/prtnum. Use this data to 
# enter for each UOM the current quantity. If the script is asked to 
# generate mismatch on quantity (create_mismatch) increment the quantity 
# by untqty_mismatch_increment setting.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		create_mismatch - (TRUE|FALSE) specifies if the quantity should be incremented
#                         to generate a mismatch.
#		numUOMs - number of unit of measures for this prtnum
#		untqty - the quantity of inventory relative to the prtnum
#		untqty_mismatch_increment - amount to increase quantity to create a mismatch
# Outputs:
# 	None
#############################################################

Given I "calculate and enter quantity information"
	Once I see "Quantity Capture" in element "className:appbar-title" in web browser

	# now we need to loop through these fields. The number of fields depends on 
	# footprint detail levels. Which quantity (or multiple quantities) we fill in is 
	# arbitrary and depends on user decision / business process. 
	# We will assume we fill in one of the quantites and we get the number of fields
	# and the lowest level quantity passed in as a variable
	If I verify variable "numUOMs" is assigned
	And I verify variable "untqty" is assigned
    And I verify text $numUOMs is not equal to ""
    And I verify text $untqty is not equal to ""
		Then I echo "number of UOMs: " $numUOMs "  quantity: " $untqty 
	Else I execute scenario "Inventory Count Get untqty and numUOMs"
		Then I execute scenario "Calculate Quantity Mismatch Information"
	EndIf 

	Then I execute scenario "Mobile Enter Count Quantity"

@wip @private
Scenario: Mobile Count Process Adjustment
#############################################################
# Description: Process Inventory adjustment rererences and
# serialization if needed
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "process inventory adjustment screen"
	Then I execute scenario "Mobile Inventory Adjustment References"

And I "process serialization if required/configured"
	If I see "Serial Number Capture" in element "className:appbar-title" in web browser within $screen_wait seconds
		Then I copy text inside element "xPath://span[contains(text(),'Item Number')]/ancestor::aq-displayfield[contains(@id,'prtnum')]/descendant::span[contains(@class,'data')]" in web browser to variable "prtnum" within $max_response seconds
        
		Then I execute scenario "Get Item Serialization Type"
		If I verify text $serialization_type is equal to "CRDL_TO_GRAVE"
			Then I execute scenario "Mobile Scan Serial Number Cradle to Grave Receiving"
		EndIf
	EndIf

@wip @private
Scenario: Mobile Check for Count Near Zero Prompt
############################################################
# Description: Checks to see if the count near zero prompt appears on the Mobile App Screen
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		None
# 	Optional:
#       None
# Outputs:
#	None
#############################################################

If I see "A cycle count is required for this location" in web browser within $wait_med seconds
	Then I press keys "ENTER" in web browser
	And I wait $screen_wait seconds    
	And I "am expecting to see the Cycle Count screen"
Else I fail step with error message "ERROR: Expected to see count near zero prompt for this test case"
EndIf

Then I execute scenario "Mobile Count Near Zero Cycle Count Process"

@wip @private
Scenario: Mobile Count Near Zero Cycle Count Process
############################################################
# Description: This scenario handles the processing logic for count near zero for picking.
# MSQL Files: 
#	validate_audit_work_generated.msql
# Inputs:
# 	Required:
#		prtnum - item number used for the test case
#		client_id - Client ID
# 	Optional:
#       match_count - Determines if the count near zero should use the correct quantity, use the
#                     incorrect quantity in the first attempt and the correct quantity the next
#                     attempt, or do a mismatched count. The modes are MISMATCH and REMATCH.
# Outputs:
#	None
#############################################################

Given I "should now be at the Cycle Count screen, inputting item number"
	Once I see "Cycle Count" in element "className:appbar-title" in web browser

	Then I assign "Item Number" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $prtnum in element "name:prtnum" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
    
Then I "enter prt client id"
	If I verify text $client_id is not equal to "----"
		Then I assign "Item Client ID" to variable "input_field_with_focus"
		And I execute scenario "Mobile Check for Input Focus Field"
		Then I type $client_id in element "name:prt_client_id" in web browser within $max_response seconds
	EndIf
 	And I press keys "ENTER" in web browser
    
Then I "expect to be in the quantity capture screen"
And I "decide how to proceed with the quantity capture based off input variables"
	If I verify text $match_count is equal to "REMATCH" ignoring case
		Then I "will enter a mismatched quantity the first time and the correct quantity the next time"
			And I execute scenario "Mobile Process Rematched Count"
	ElsIf I verify text $match_count is equal to "MISMATCH" ignoring case
		Then I "will do a mismatched count"
    		And I execute scenario "Mobile Process Mismatched Count"
	Else I execute scenario "Mobile Inventory Count Process Quantity Capture"
	EndIf

Then I "F6 to complete count and take me to deposit screen"
	And I press keys "F6" in web browser 2 times with $wait_med seconds delay
    
If I verify text $match_count is equal to "MISMATCH" ignoring case
    Then I "will validate that audit generated after a mismatched count"
        And I assign "validate_audit_work_generated.msql" to variable "msql_file"
        When I execute scenario "Perform MSQL Execution"
        And I verify MOCA status is 0
EndIf
    
@wip @private
Scenario: Mobile Process Rematched Count
############################################################
# Description: Handles count near zero processing for an incorrect count in the first attempt and a 
# correct count in the confirmation.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		None
# 	Optional:
#       None
# Outputs:
#	None
#############################################################

Given I execute scenario "Inventory Count Get untqty and numUOMs"
And I execute scenario "Calculate Quantity Mismatch Information for Count Zero"

Then I "have now created a mismatch, I will now input the mismatched value into the Mobile App screen"
	And I execute scenario "Mobile Enter Count Quantity"

And I "expect to see a mismatch error on the Mobile App screen"
	Then I execute scenario "Mobile Unexpected Entry during Count for Count Near Zero"
            
And I "now have to input the correct quantity, so I will call the same scenario without manipulating the quantity"
	Then I execute scenario "Mobile Inventory Count Process Quantity Capture"

@wip @private
Scenario: Mobile Process Mismatched Count
############################################################
# Description: Handles creating a mismatched count for Count near Zero for picking.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		None
# 	Optional:
#       None
# Outputs:
#	None
#############################################################

Given I execute scenario "Inventory Count Get untqty and numUOMs"
And I execute scenario "Calculate Quantity Mismatch Information for Count Zero"

Then I "have now created a mismatch, I will now input the mismatched value into the Mobile App screen"
	And I execute scenario "Mobile Enter Count Quantity"

And I "expect to see a mismatch error on the Mobile App screen"
	Then I execute scenario "Mobile Unexpected Entry during Count for Count Near Zero"
            
And I "now have to input the mismatched quantity again, so I will call the same scenario again"
	Then I execute scenario "Mobile Enter Count Quantity"

@wip @private
Scenario: Mobile Unexpected Entry during Count for Count Near Zero
############################################################
# Description: Press Enter to go through the unexpected entry popup error during the counting process.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		untqty - driven from the previous scenarios Inventory Count Get untqty and numUOMs 
#                and Calculate Quantity Mismatch Information for Count Zero.
# 	Optional:
#       None
# Outputs:
#	None
#############################################################

Then I assign "Unexpected Entry" to variable "mobile_dialog_message"
And I execute scenario "Mobile Set Dialog xPath"
If I see element $mobile_dialog_elt in web browser within $screen_wait seconds 
	Then I "know there is a mismatch in what I counted"
		And I press keys "ENTER" in web browser
EndIf