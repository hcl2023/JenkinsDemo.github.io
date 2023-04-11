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
# Utility: Terminal Counting Utilities.feature
# 
# Functional Area: Inventory
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: Terminal, MOCA
#
# Description:
# These Utility Scenarios perform actions specific to Terminal Counting activities
#
# Public Scenarios:
#	- Terminal Inventory Perform LPN Count  - Perform LPN Count process
#	- Terminal Inventory Perform Summary Count - Perform Summary Count process
#	- Terminal Inventory Perform Detail Count - Perform Detail Count process 
#	- Terminal Inventory Perform Audit Count - Perform Audit Count process
#	- Terminal Inventory Count Process Directed Work Screen - process initial directed work screen for a count
#	- Terminal Inventory Count Enter Batch and Location Undirected Work - enter count batch and stoloc and process count screen
#	- Terminal Inventory Count Complete Undirected Work - Check for completion of undirected count
#	- Terminal Inventory Audit Count Enter Batch and Location Undirected Work - enter the count batch and the location in Undirected work mode
#	- Terminal Inventory Audit Count Enter Location Directed Work - Enter Location in Directed Mode work mode
#	- Terminal Inventory Audit Count Perform Count - perform the audit count operation
#	- Terminal Inventory Audit Count Complete Count - complete the audit count operation
#	- Inventory Audit Count Check Inventory - validating that the audit count value was accepted
#	- Inventory Audit Count Check Tables - validating the count history and the count work tables
#	- Validate Count Audit Generated - validate that a audit count was generated
#	- Terminal Manual Count Process - Perform Manual Count
#	- Validate Audit Count Generated - validate that a audit count was generated (by location; this scenario follows manual count)
#	- Terminal Inventory Audit Count Add LPN - Add LPN during an audit count by counting an item not in the audit's location
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Terminal Counting Utilities

@wip @public
Scenario: Terminal Inventory Audit Count Add LPN
#############################################################
# Description: For Terminal Count Audit, enter lodnum that does not
# exist in location and add new inventory relative to that lodnum/prtnum
# MSQL Files:
#	None
# Inputs:
#	Required:
#		lodnum - lodnum  to add to location during audit
#		prtnum - part number for new inventory
#		untqy - quantity of prtnum to add into inventory
#		invsts - inventory status
#	Optional:
#		lotnum - lot number
# Outputs:
# 		None
#############################################################

Given I "verify we are on Count Adjustment Screen and enter lodnum"
	Once I see "Count Adjustment" in terminal
	Then I enter $lodnum in terminal

And I "validate inventory does not exist and we would like to add"
	Once I see "Inventory does not" in terminal
	Once I see "add it?" in terminal
	Then I press keys "Y" in terminal
	
And I "enter client ID"
	If I verify text $client_id is not equal to "----"
		If I verify text $term_type is equal to "handheld"
			Once I see cursor at line 3 column 6 in terminal
		Else I verify text $term_type is equal to "vehicle"
			Once I see cursor at line 2 column 32 in terminal
		EndIf
		Then I enter $client_id in terminal
	EndIf

And I "enter for the LPN of new inventory being added"
	Then I press keys "ENTER" in terminal

And I "enter new the prtnum which is being added to the location"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 7 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 4 column 10 in terminal
	EndIf
	Then I enter $prtnum in terminal

And I "confirm U/C"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 9 column 6 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 5 column 10 in terminal
	EndIf
	Then I press keys "ENTER" in terminal
	
And I "enter quantity"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 10 column 8 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 6 column 12 in terminal
	EndIf
	Then I enter $untqty in terminal
	
And I "confirm the Unit of Measure"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 10 column 15 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 6 column 18 in terminal
	EndIf
	Then I press keys "ENTER" in terminal
	
And I "enter Inventory status"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 12 column 6 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 6 column 28 in terminal
	EndIf
	Then I enter $invsts in terminal

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
Scenario: Terminal Inventory Perform LPN Count 
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
	Once I see "LPN Count" in terminal 
	Once I see $stoloc in terminal 

And I "enter the Location we are counting"
	Then I enter $stoloc in terminal 
	And I wait $wait_short seconds 
	If I see "Committed" in terminal within $wait_med seconds 
		Then I echo "Committed Inventory exists in location"
		And I type $committed_inventory_in_count_loc in terminal
	EndIf

When I "count the LPNs in the Location, enter lodnum"
	If I verify variable "lodnum" is assigned
    And I verify text $lodnum is not equal to ""
		Once I see "LPN Count" in terminal 
		When I enter $lodnum in terminal
		And I wait $wait_short seconds 
		
		Then I "acknowledge Inventory has already been counted if attempting to count a previously counted LPN"
			If I see "Inventory already" in terminal
				Then I press keys "ENTER" in terminal
			EndIf
			
		And I "press F6 and process/acknowledge the count"
			Once I see "LPN Count" in terminal 
			Then I press keys "F6" in terminal
			And I wait $wait_med seconds
		
			Once I see "Press Enter To Ack" in terminal 
			Then I press keys "ENTER" in terminal
			And I wait $wait_med seconds
		
			Once I see "OK To Complete Cycle" in terminal 
			Then I type "Y" in terminal
			And I wait $wait_med seconds
	Else I "loop through all LPNs in the location"
		And I execute scenario "Inventory LPN Count Get Next LPN to Count"
		While I verify variable "lodnum" is assigned
			Once I see "LPN Count" in terminal 
			When I enter $lodnum in terminal
			And I wait $wait_short seconds 
			 
			Then I "acknowledge Inventory has already been counted if attempting to count a previously counted LPN"
			If I see "Inventory already" in terminal within $wait_med seconds 
				Then I "will skip this"
					And I press keys "ENTER" in terminal
			EndIf
			
			If I see "Unexpected Entry" in terminal within $wait_med seconds
				Then I "Need to enter the LPN"
					Then I press keys "ENTER" in terminal
					Once I see "LPN Count" in terminal 
					When I enter $lodnum in terminal
					And I wait $wait_short seconds 
				
				And I "reset input parameters so the next loop doesn't get confused"
					Then I unassign variable "lodnum"

			Elsif I see "Unexpected Entry" in terminal within $wait_med seconds 
				Then I fail step with error message "ERROR: Did not mean to enter an Invalid LPN"
			Else I "see no unexpected entries and continue with next iteration"
				Then I execute scenario "Inventory LPN Count Get Next LPN to Count"
			EndIf
		EndWhile

		Then I "know there are no more LPNs to count in the location according to what's in the system - Press F6"
		And I "process the counts (acknowledge and confirm)"
			Once I see "LPN Count" in terminal 
			When I press keys "F6" in terminal
          	And I wait $wait_med seconds
 
			Once I see "Press Enter To Ack" in terminal 
			When I press keys "ENTER" in terminal
			And I wait $wait_med seconds
	
			Once I see "OK To Complete Cycle" in terminal 
			When I type "Y" in terminal
			And I wait $wait_med seconds

			If I see "LPN Count" in terminal within $wait_med seconds 
				Then I "know we completed this location count because the next count is showing up"
			ElsIf I see "Looking" in terminal within $wait_med seconds 
				Then I "know we completed this location count"
			EndIf
	EndIf
	
@wip @public
Scenario: Terminal Inventory Perform Summary Count 
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

Given I "ensure we are on the Cycle Count Screen"
	Once I see "Count Location:" in terminal 
	Once I see $stoloc in terminal 

Then I "enter the location to count"
	And I enter $stoloc in terminal 
	And I wait $wait_short seconds 

And I "count the item assigned by the prtnum variable otherwise loop through and count all of the items in the location"
	If I verify variable "prtnum" is assigned
	And I verify variable "prt_client_id" is assigned
    And I verify text $prtnum is not equal to ""
    And I verify text $prt_client_id is not equal to ""
		Then I execute scenario "Terminal Inventory Summary Count Enter Blind or Part Info"
        And I execute scenario "Terminal Inventory Count Process Quantity Capture"
		If I see "Unexpected Entry" in terminal within $wait_med seconds
	  		Then I "know there is a mismatch in what I counted"
	  			And I press keys "ENTER" in terminal
	  		And I "need to enter the quantity again"
	  			Then I execute scenario "Terminal Inventory Count Process Quantity Capture"
		EndIf

	 	# if quantity is entered (or re-entered), screen goes back 
	 	# to the screen where we enter an item number for the same location
	 	# if there is more inventory in the location we would enter it now
	 	# check if there are more items to count in this location
		Given I "am on Cycle Count Screen, I process the count"
			Once I see "Cycle Count" in terminal 
			And I press keys "F6" in terminal
			And I wait $wait_med seconds
			
			If I see "Press Enter To Ack" in terminal within $wait_med seconds 
				Then I press keys "ENTER" in terminal
				Once I see "OK To Complete Cycle" in terminal 
				When I enter "Y" in terminal
				And I wait $wait_med seconds 
			EndIf
	Else I "am going to loop through all items in the location"
		Given I execute scenario "Inventory Summary Count Get Next Item to Count"
		While I verify variable "prtnum" is assigned
        And I verify text $prtnum is not equal to ""
			Then I execute scenario "Terminal Inventory Summary Count Enter Blind or Part Info"
            And I execute scenario "Terminal Inventory Count Process Quantity Capture"
			# if quantity is entered and there is no descrepancy, screen goes back 
			# to the screen where we enter an item number for the same location
			# if there is more inventory in the location we would enter it now
			# check if there are more items to count in this location
			If I see "Unexpected Entry" in terminal within $wait_med seconds
		  		Then I "know there is a mismatch in what I counted"
					And I press keys "ENTER" in terminal
		  		Then I "need to enter the quantity again for the same prtnum and quantity"
		  			And I execute scenario "Terminal Inventory Count Process Quantity Capture"
			EndIf

			Then I "reset input parameters so the next loop doesn't get confused"
				And I unassign variables "prtnum,prt_client_id,numUOMs,untqty"

			And I "see if there are more items to count in this location"
				Then I execute scenario "Inventory Summary Count Get Next Item to Count"
		EndWhile
	
		Then I "know there are no more items to count in the location according to what's in the system - press F6"
			Once I see "Cycle Count" in terminal 
			When I press keys "F6" in terminal
			And I wait $wait_med seconds
			
			If I see "Press Enter To Ack" in terminal within $wait_med seconds 
				Then I press keys "ENTER" in terminal
				Once I see "OK To Complete Cycle" in terminal 
				When I enter "Y" in terminal
				And I wait $wait_med seconds 
			EndIf

		If I see "Cycle Count At" in terminal within $wait_med seconds 
			Then I "know we completed this location count because the next count is showing up"
		ElsIf I see "Looking" in terminal within $wait_med seconds 
			Then I "know we completed this location count"
		Else I fail step with error message "ERROR: Something went wrong during count"
		EndIf
	EndIf

@wip @public
Scenario: Terminal Inventory Perform Detail Count 
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
	Once I see "Detail Cycle Count" in terminal 
	Once I see $stoloc in terminal 

And I "enter the location to count"
	Then I enter $stoloc in terminal 
	And I wait $wait_short seconds 

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
		Then I execute scenario "Terminal Inventory Detail Count Enter Blind or Part Info"
        And I execute scenario "Terminal Inventory Count Process Quantity Capture"
		# if quantity is entered and there is no descrepancy, screen goes back 
		# to the screen where we enter the LPN and the cursor lands on ....
		# the client id field. with one more entry we end up back in the quantities field
		If I see "Unexpected Entry" in terminal within $wait_med seconds 
			Then I "know there is a mismatch in what I counted"
				And I press keys "ENTER" in terminal
				And I press keys "ENTER" in terminal
		
			And I "need to enter the quantiy again for the same prtnum and quantity"
				Then I execute scenario "Terminal Inventory Count Process Quantity Capture"
		EndIf

		Then I "look to see if we have an triggered an inventory adjustment with serialization and handle it"
			If I see "Adjustment Ref" in terminal within $wait_med seconds
				Then I execute scenario "Terminal Count Process Adjustment"
			EndIf

	 	# if quantity is entered (or re-entered), screen goes back 
	 	# to the screen where we enter an item number for the same location
	 	# if there is more inventory in the location we would enter it now
	 	# check if there are more items to count in this location
		Once I see "Count Adjustment" in terminal 

		And I "press F6 and complete count"
			Then I press keys "F6" in terminal

			Once I see "OK To complete this" in terminal 
			When I type "Y" in terminal
			And I wait $wait_med seconds

		And I "validate that an audit count was generated if test generated a mismatch"
			If I verify text $create_mismatch is equal to "TRUE" ignoring case
				Then I execute scenario "Validate Count Audit Generated"
			EndIf

	# the Terminal screen keeps the counted LPNs, prtnums and quantities 'in memory' and doesn't
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

			Then I execute scenario "Terminal Inventory Detail Count Enter Blind or Part Info"
            And I execute scenario "Terminal Inventory Count Process Quantity Capture"
			# if quantity is entered and there is no descrepancy, screen goes back 
			# to the screen where we enter the LPN and the cursor lands on ....
			# the client id field. with one more entry we end up back in the quantities field
			If I see "Unexpected Entry" in terminal within $wait_med seconds 
				Then I "know there is a mismatch in what I counted"
					And I press keys "ENTER" in terminal
					And I press keys "ENTER" in terminal
		   			And I "need to enter the quantity again for the same prtnum and quantity"
						Then I execute scenario "Terminal Inventory Count Process Quantity Capture"
			EndIf
			
			# sometimes a message shows 'Please complete this inventory first - Press Enter'
			# re-enter the quantity, just like we do with an unexpected quantity
			If I see "Please complete this" in terminal within $wait_med seconds 
				Then I "know I have to re-enter what I counted"
					And I press keys "ENTER" in terminal
				And I "need to enter the quantity again for the same prtnum and quantity"
					Then I execute scenario "Terminal Inventory Count Process Quantity Capture"
			EndIf
		EndWhile

		And I "know there are no more LPNs to count in the location according to what's in the system - press F6"
			Then I "look to see if we have an triggered an inventory adjustment with serialization and handle it"
				If I see "Adjustment Ref" in terminal within $wait_med seconds
					Then I execute scenario "Terminal Count Process Adjustment"
				EndIf
    
			Once I see "Count Adjustment" in terminal 

			And I "press F6 and complete count"
				Then I press keys "F6" in terminal
				And I wait $wait_med seconds

				Once I see "OK To complete this" in terminal 
				When I type "Y" in terminal
				And I wait $wait_med seconds
            
            And I "validate that an audit count was generated if test generated a mismatch"
			If I verify text $create_mismatch is equal to "TRUE" ignoring case
				Then I execute scenario "Validate Count Audit Generated"
			EndIf

		If I see "Count Audit At" in terminal within $wait_med seconds 
			Then I "know we completed this location count because the next count is showing up"
		ElsIf I see "Looking" in terminal within $wait_med seconds 
			Then I "know we completed this location count and no more work is available"
		EndIf
	EndIf
    
@wip @public
Scenario: Terminal Inventory Count Process Directed Work Screen
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
        
	If I see "Count At" in terminal within $wait_med seconds
	Elsif I see "Count Audit At" in terminal within $wait_med seconds
	Endif
    
    Then I press keys "ENTER" in terminal
	And I wait $wait_med seconds 
 
@wip @public
Scenario: Terminal Inventory Count Enter Batch and Location Undirected Work
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
	Once I see "Cycle Count Entry" in terminal

And I "Specify Count Batch and Storage Location"
	Then I enter $cntbat in terminal
	And I wait $wait_short seconds 
 
	Then I enter $stoloc in terminal
	And I wait $wait_short seconds
	
And I "skip the Count Zone field by pressing Enter"
	Then I press keys "ENTER" in terminal
	And I wait $wait_short seconds

And I "process conditions based on screen outputs"
	If I see "No More Counts" in terminal within $wait_med seconds 
		Then I fail step with error message "ERROR: No counts found"
	EndIf
 
	If I see "Committed" in terminal within $wait_med seconds
		Then I fail step with error message "ERROR: Committed Inventory exists in location"
	EndIf

@wip @public
Scenario: Terminal Inventory Count Complete Undirected Work
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
    If I see "No More Counts Found" in terminal within $wait_med seconds
    	And I "am done with the test - completed one count location in undirected work mode"
			Then I press keys "ENTER" in terminal
			And I wait $wait_med seconds 
	Else I "Stop this scenario because we decided this test would only do one location per run"
	EndIf

And I wait $wait_med seconds

@wip @public
Scenario: Terminal Inventory Audit Count Enter Batch and Location Undirected Work
#############################################################
# Description: For Terminal Count Audit, on Count Audit Screen,
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
	Once I see "Count Audit" in terminal

Given I "See the cursor at the Count Batch"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 8 column 2 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 4 column 16 in terminal 
	EndIf 
	When I enter $cnt_id in terminal
	
And I "See the cursor at the Loc Field and enter storage location"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 10 column 2 in terminal 
	Else I verify text $term_type is equal to "vehicle" 
		Once I see cursor at line 5 column 16 in terminal 
	EndIf 
	When I enter $stoloc in terminal
    
@wip @public
Scenario: Terminal Inventory Audit Count Enter Location Directed Work
#############################################################
# Description: For Terminal Count Audit, on Count Audit Screen,
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
	Once I see "Count Audit" in terminal
	Once I see $stoloc in terminal 

And I "See the cursor at the Loc Field and enter storage location"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 10 column 2 in terminal 
	Else I verify text $term_type is equal to "vehicle" 
		Once I see cursor at line 5 column 16 in terminal 
	EndIf 
	When I enter $stoloc in terminal

@wip @public
Scenario: Terminal Inventory Audit Count Perform Count
#############################################################
# Description: For Terminal Count Audit, perform the audit 
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

Given I "Verify we are on Count Adjustment Screen and Enter lodum"
	Once I see "Count Adjustment" in terminal 
	Once I see "ID" in terminal 
	And I "See the cursor at the ID Field"
		If I verify text $term_type is equal to "handheld"
			Once I see cursor at line 2 column 5 in terminal 
		Else I verify text $term_type is equal to "vehicle"
			Once I see cursor at line 2 column 6 in terminal 
	EndIf 
	When I enter $lodnum in terminal

And I "See the cursor should at the Prtnum Field"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 3 column 6 in terminal 
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 3 column 6 in terminal 
	EndIf 
	When I enter $prtnum in terminal

And I "See the cursor at the Client Field"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 5 column 6 in terminal 
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 4 column 16 in terminal 
	EndIf 
	When I press keys "ENTER" in terminal
	
And I "Enter quantity"
And I "See the cursor at the Q: Field"
	Once I see "Quantity Capture" in terminal 
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 7 column 6 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 5 column 6 in terminal 
	EndIf
	
And I "Enter the Pallet Qty"
	When I press keys "ENTER" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 8 column 6 in terminal 
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 6 column 6 in terminal 
	EndIf
	
And I "Enter the Case qty"
	When I press keys "ENTER" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 9 column 6 in terminal 
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 7 column 6 in terminal 
	EndIf
	
And I "Enter the actual amount we want to count (in Eaches)"
	When I enter $cnt_qty in terminal

@wip @public
Scenario: Terminal Inventory Audit Count Complete Count
#############################################################
# Description: For Terminal Count Audit, complete the audit 
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
	If I see "Adjustment Ref" in terminal within $wait_med seconds
		Then I execute scenario "Terminal Count Process Adjustment"
	EndIf

Then I "Am on the Count Adjustment Screen - Press F6"
	Once I see "Count Adjustment" in terminal 
	And I wait $wait_short seconds 
	When I press keys "F6" in terminal

And I "Complete the audit by answering Y"
	Then I wait $wait_short seconds 
	Once I see "complete this" in terminal 
	Once I see "count audit? (Y|N):" in terminal 
	And I wait $wait_short seconds 
	When I type "Y" in terminal
	
And I "Verify audit is completed successfully"
	Once I see "Audit Completed" in terminal 
	Once I see "Successfully" in terminal 
	Once I see "Enter" in terminal 
	And I wait $wait_short seconds 
	Then I press keys "ENTER" in terminal

@wip @public
Scenario: Inventory Audit Count Check Inventory
#############################################################
# Description: Validate that the count value was accepted and 
# matches what was passed in to the of the start count.
# MSQL Files:
#	check_inventory_after_count.msql
# Inputs:
#	Required:
#		stoloc - storage location where audit is being done from
#		cnt_qty - inventory quantity entered in audit count
#	Optional:
#		None
# Outputs:
# 		None
#############################################################

Given I "Validate inventory after count"
	Then I assign "check_inventory_after_count.msql" to variable "msql_file"
	And I execute scenario "Perform MSQL Execution"
	And I verify MOCA status is 0
	And I assign row 0 column "sum_untqty" to variable "sum_untqty"
	
	If I verify number $sum_untqty is equal to $cnt_qty
		Then I echo "Inventory matches what we counted."
	Else I fail step with error message "ERROR: Inventory does NOT match what we counted."
	Endif

@wip @public
Scenario: Inventory Audit Count Check Tables
#############################################################
# Description: Validating the count history (cnthst) and the
# count work (cntwrk) tables have been properly updated.
# MSQL Files:
#	check_count_work_after_count.msql
#	check_count_history_after_count.msql
# Inputs:
#	Required:
#		stoloc - storage location where audit is being done from
#		cntbat - Count batch for the audit
#	Optional:
#		cnt_id - used for cntbat for audit counts
# Outputs:
# 		None
#############################################################

Given I "Check cnthst table after count"
    Then I assign "check_count_history_after_count.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
		Then I echo "cnthst table was updated properly."
	Else I fail step with error message "ERROR: cnthst table was not updated properly"
	Endif

Given I "Check cntwrk table after audit"
	Then I assign "check_count_work_after_count.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
		And I fail step with error message "ERROR: cntwrk table was not updated properly"
	Else I echo "cntwrk table was updated properly."
	Endif

@wip @public
Scenario: Validate Count Audit Generated
#############################################################
# Description: Check to see if an audit count has been generated
# realtive to the cntbat, stoloc, and the prtnum
# MSQL Files:
#	check_count_audit_generated.msql
# Inputs:
#	Required:
#		stoloc - Location where the count will take place
#		cntbat - Count Batch we are working on
#		prtnum - part number
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "select the next LPN in the Location"
	Then I assign "check_count_audit_generated.msql" to variable "msql_file"
	And I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
	Else I fail step with error message "ERROR: No audit count generated"
	Endif
    
@wip @public
Scenario: Terminal Manual Count Process
#############################################################
# Description: Handles the logic for manual count process. Selects an LPN or stoloc based on input, and proceeds to perform a manual count
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

Given I "select the LPN to manual count"
	Then I assign "get_inventory_details_for_manual_count.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	And I verify MOCA status is 0
	And I assign row 0 column "inv_count" to variable "inv_count_in_location"
	And I assign "0" to variable "row_index"
	And I convert string variable "row_index" to integer variable "row_index"
    
Then I "enter the Inventory ID" 
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 5 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 3 column 12 in terminal 
	EndIf
	Then I enter $stoloc in terminal

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
		Once I see "Count Adjustment" in terminal 
		Once I see "ID" in terminal

	And I "see the cursor at the ID Field"
		If I verify text $term_type is equal to "handheld"
			Once I see cursor at line 2 column 5 in terminal 
		Else I verify text $term_type is equal to "vehicle"
			Once I see cursor at line 2 column 6 in terminal 
		EndIf
		Given I execute scenario "Terminal Clear Field"
		Then I enter $invtid in terminal

	And I "see the cursor should at the Prtnum Field (for load and sub-load tracked parts)"
    	If I verify text $man_cnt_mode is not equal to "DETAIL" ignoring case
            If I verify text $term_type is equal to "handheld"
                Once I see cursor at line 3 column 6 in terminal 
            Else I verify text $term_type is equal to "vehicle"
                Once I see cursor at line 3 column 6 in terminal 
            EndIf 
            Given I execute scenario "Terminal Clear Field"
            Then I enter $prtnum in terminal

        And I "see the cursor at the Client Field"
            If I verify text $prt_client_id is not equal to "----"
                If I verify text $term_type is equal to "handheld"
                    Once I see cursor at line 5 column 6 in terminal 
                Else I verify text $term_type is equal to "vehicle"
                    Once I see cursor at line 4 column 16 in terminal 
                EndIf 
                Given I execute scenario "Terminal Clear Field"
                Then I enter $prt_client_id in terminal
            EndIf
        EndIf
  
	And I "now expect to be in the quantity capture screen"
		Once I see "Quantity Capture" in terminal

	And I "calculate the number of uoms for this part and footprint"
		Then I assign "get_numUoms_by_part_and_footprint.msql" to variable "msql_file"
		When I execute scenario "Perform MSQL Execution"
		Then I verify MOCA status is 0
		And I assign row 0 column "numUOMs" to variable "numUOMs"
  
	And I "enter the quantity in the quantity capture screen"
		Given I execute scenario "Calculate Quantity Mismatch Information"
		And I execute scenario "Terminal Enter Count Quantity"
    	And I increase variable "row_index"
EndWhile

And I "press F6 to complete count and look for discrepancy"
	Then I press keys "F6" in terminal

	If I verify text $create_mismatch is equal to "TRUE" ignoring case
		Once I see "Discrepancy Found" in terminal
		Then I wait $wait_short seconds
		Then I press keys "Enter" in terminal
		Once I see "still" in terminal
		Then I press keys "Enter" in terminal
		And I wait $wait_short seconds
    
		Then I "validate that the audit was generated"
			And I execute scenario "Validate Audit Count Generated"
	EndIf

@wip @public
Scenario: Validate Audit Count Generated
#############################################################
# Description: Validates whether audit count was generated after a mismatched count
# MSQL Files:
#	validate_audit_work_generated.msql
# Inputs:
#	Required:
#		stoloc - Location at which the mismatched count was performed
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "validate a audit count has been generated after a purposefull mismatch was performed"
	Then I assign "validate_audit_work_generated.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
	ElsIf I fail step with error message "ERROR: Audit work did not generate after a mismatched count"
	Endif

#############################################################
# Private Scenarios:
# 	- Terminal Inventory Summary Count Enter Blind or Part Info - enter the prtnum and prt_client_id info for Summary Count
#	- Terminal Inventory Detail Count Enter Blind or Part Info - enter the prtnum and prt_client_id for Detail Count
#	- Terminal Inventory Count Enter Blind or Part Info - generic to count scenario to enter prtnum and prt_client_id
#	- Calculate Quantity Mismatch Information - if mismatch was requested, add untqty_mismatch_increment to current untqty for use
# 	- Terminal Inventory Count Process Quantity Capture - get untqty and numUOMs relative to the stoloc/prtnum
# 	- Inventory Summary Count Get Next Item to Count - find the next item number to count
# 	- Inventory Summary Count Get untqty - get the quantity in this location
# 	- Inventory LPN Count Get Next LPN to Count - select the next LPN to count
#	- Inventory Detail Count Get LPNs to Count - select the detail of the next LPN to process
#	- Inventory Count Get untqty and numUOMs -  get number of UOMs and the quantity relative to location
# level quantity
#	- Check for Count Near Zero Prompt - Checks for the count near zero prompt for count near zero in picking
#	- Terminal Count Near Zero Cycle Count Process - Handles the logic for different modes of count near zero test case
#	- Terminal Process Rematched Count - Processes terminal count near zero by doing a mismatched count first and then a matched count. 
#	- Terminal Process Mismatched Count - Process terminal count near zero by creaing a mismatched count.
#	- Terminal Enter Count Quantity - Enters count quantity in the Quantity Capture screen.
#	- Terminal Unexpected Entry during Count for Count Near Zero - Enters through unexpected entry error during mismatched count
#	- Calculate Quantity Mismatch Information for Count Zero - Calculates mismatched untqty for count near zero mismatch process
#	- Terminal Count Process Adjustment - Process Inventory adjustment rererences and serialization if needed
#############################################################

@wip @private
Scenario: Terminal Count Process Adjustment
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
	Then I execute scenario "Terminal Inventory Adjustment References"

And I "process serialization if required/configured"
	Then I wait $screen_wait seconds
	And I verify screen is done loading in terminal within $max_response seconds
	If I see "Serial Numb" on line 1 in terminal within $wait_med seconds
		Then I "verify screen has loaded for information to be copied off of it"
			And I verify screen is done loading in terminal within $max_response seconds

		If I verify text $term_type is equal to "handheld"
			Then I copy terminal line 4 columns 2 through 20 to variable "prtnum"
		Else I verify text $term_type is equal to "vehicle"
        	And I copy terminal line 5 columns 10 through 30 to variable "prtnum"
		EndIf
		Then I execute Groovy "prtnum = prtnum.trim()"
        
		Then I execute scenario "Get Item Serialization Type"
		If I verify text $serialization_type is equal to "CRDL_TO_GRAVE"
			Then I execute scenario "Terminal Scan Serial Number Cradle to Grave Receiving"
		EndIf
	EndIf

@wip @private
Scenario: Inventory LPN Count Get Next LPN to Count
#############################################################
# Description: Relative to the stoloc and cntbat select the
# next LPN to count.
# MSQL Files:
#	get_cycle_count_lpn_for_matching_count.msql
# Inputs:
#	Required:
#		stoloc - Location where the count will take place
#		cntbat - Count Batch we are working on
#	Optional:
#		None
# Outputs:
# 		lodnum - The LPN to count relative to stoloc
#############################################################

Given I "select the next LPN in the Location"
	Then I assign "get_cycle_count_lpn_for_matching_count.msql" to variable "msql_file"
	And I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
		Then I assign row 0 column "lodnum" to variable "lodnum"
	ElsIf I verify MOCA status is 510 
		Then I "can't find eligible LPN to count, unassigning lodnum" 
			And I unassign variable "lodnum"
	Else I fail step with error message "ERROR: unknown MOCA error status"
	Endif

@wip @private
Scenario: Terminal Inventory Summary Count Enter Blind or Part Info
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
	Once I see "Cycle Count" in terminal
    And I verify screen is done loading in terminal within $wait_long seconds

	Then I execute scenario "Terminal Inventory Count Enter Blind or Part Info"
	
@wip @private
Scenario: Terminal Inventory Detail Count Enter Blind or Part Info
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
	Once I see "Count Adjustment" in terminal
    And I verify screen is done loading in terminal within $wait_long seconds
    
	Then I enter $lodnum in terminal
	And I wait $wait_med seconds 

	Then I execute scenario "Terminal Inventory Count Enter Blind or Part Info"

@wip @private
Scenario: Terminal Inventory Count Enter Blind or Part Info
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
		Then I press keys "ENTER" in terminal
		And I wait $wait_short seconds

		Then I press keys "ENTER" in terminal
		And I wait $wait_short seconds 
	Elsif I verify text $blind_counting is equal to "FALSE" ignoring case
		Given I execute scenario "Terminal Clear Field"
		Then I enter $prtnum in terminal
		And I wait $wait_med seconds

		Given I execute scenario "Terminal Clear Field"
		If I verify text $prt_client_id is not equal to "----"
			Then I enter $prt_client_id in terminal
		EndIf
		And I wait $wait_med seconds 
	Endif

@wip @private
Scenario: Terminal Inventory Count Process Quantity Capture
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
# 		None
#############################################################

Once I see "Quantity Capture" in terminal
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

Then I execute scenario "Terminal Enter Count Quantity"
    
@wip @private
Scenario: Calculate Quantity Mismatch Information
#############################################################
# Description: Look to see if mismatch was requested, if so
# add untqty_mismatch_increment to current untqty for use.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		create_mismatch - (TRUE|FALSE) specifies if the quantity should be incremented
#                         to generate a mismatch.
#		untqty - the quantity of inventory relative to the prtnum
#	Optional:
#		untqty_mismatch_increment - amount to add to current untqty
# Outputs:
# 	None
#############################################################

	If I verify variable "create_mismatch" is assigned
	And I verify text $create_mismatch is equal to "TRUE" ignoring case
		Then I "calculate how much to use for a mismatch increment"
        	If I verify variable "untqty_mismatch_increment" is assigned
    		Else I assign "1" to variable "untqty_mismatch_increment"
    		EndIf
			And I convert string variable "untqty" to integer variable "untqty_num"
        	And I convert string variable "untqty_mismatch_increment" to integer variable "untqty_mismatch_increment_num"

		Then I "purposely want to create a mismatch, add 1 to the untqty"
			And I increase variable "untqty_num" by $untqty_mismatch_increment_num
			And I convert number variable "untqty_num" to string variable "untqty"
	EndIf

@wip @private
Scenario: Inventory Summary Count Get Next Item to Count
#############################################################
# Description: Given a cntbat and stoloc, find the next item number 
# to count. Use the same or similar logic as the RF screen does in 
# determining the next item (like it does when doing non-blind counting)
# MSQL Files:
#	get_cycle_count_next_item_and_client_from_location.msql
# Inputs:
#	Required:
#		stoloc - specified storage location
#		cntbat - specified Count Batch
#	Optional:
#		None
# Outputs:
# 		prtnum - next part to count
#		prt_client_id - next client ID relative to part
#############################################################

Given I "Select the next item number we are working with"
	Then I assign "get_cycle_count_next_item_and_client_from_location.msql" to variable "msql_file"
	And I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
		Then I assign row 0 column "prtnum" to variable "prtnum"
		And I assign row 0 column "prt_client_id" to variable "prt_client_id" 
	ElsIf I verify MOCA status is 510
		Then I "Can't find eligible item to count - unassign prtnum and prt_client_id" 
			If I verify variable "prtnum" is assigned
            	Then I unassign variable "prtnum"
            EndIf
            If I verify variable "prt_client_id" is assigned
				Then I unassign variable "prt_client_id"
			EndIf
	Else I fail step with error message "ERROR: unknown MOCA status"
	Endif

@wip @private
Scenario: Inventory Count Get untqty and numUOMs
#############################################################
# Description: Given a stoloc, prtnum, and prt_client_id, get 
# number of UOMs and the quantity in this location in terms of the lowest 
# level quantity.
# MSQL Files:
#	get_cycle_count_qty_and_uom_from_count_location.msql
# Inputs:
#	Required:
#		stoloc - specified storage location
# 		prtnum - specified part to count
#		prt_client_id - specified client ID relative to part
#	Optional:
#		None
# Outputs:
#	numUOMs - number of unit of measures for this prtnum
#	untqty - the quantity of inventory relative to the prtnum
#############################################################

Given I "select the uoms and unit quantity in this location"
	If I verify variable "cnz_mode" is assigned
	And I verify text $cnz_mode is equal to "TRUE"
    	If I verify variable "stoloc" is assigned
		And I verify text $stoloc is not equal to ""
			Then I assign $stoloc to variable "save_stoloc_value"
		EndIf
		And I assign $srcloc to variable "stoloc"
  	EndIf

	Then I execute MOCA command "[select ltrim(rtrim('" $prt_client_id "')) as prt_client_id from dual]"
	And I verify MOCA status is 0
	Then I assign row 0 column "prt_client_id" to variable "prt_client_id"
    
	Then I assign "get_cycle_count_qty_and_uom_from_count_location.msql" to variable "msql_file"
	And I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0 
		Then I assign row 0 column "untqty" to variable "untqty"
		And I assign row 0 column "numUOMs" to variable "numUOMs" 
	Else I fail step with error message "ERROR: can't determine untqty/UOMs"
	Endif

	And I "restore stoloc if needed"
		If I verify variable "cnz_mode" is assigned
		And I verify text $cnz_mode is equal to "TRUE"
    		If I verify variable "save_stoloc_value" is assigned
			And I verify text $save_stoloc_value is not equal to ""
				Then I assign $save_stoloc_value to variable "stoloc"
				And I unassign variable "save_stoloc_value"
			EndIf
		EndIf

@wip @private
Scenario: Inventory Detail Count Get LPNs to Count
#############################################################
# Description: Relative to the stoloc and cntbat select the
# detail of the next LPN to process.
# MSQL Files:
#	get_cycle_count_lpn_list_for_detail_count.msql
# Inputs:
#	Required:
#		stoloc - Location where the count will take place
#		cntbat - Count Batch we are working on
#	Optional:
#		None
# Outputs:
# 		lodnum - the LPN to count relative to stoloc
#		prtnum - the part to count
#		prt_client_id - the client ID relative to the part
#		untqty - the part quantity
#		numUOMs - the number of UOMs for the part 
#############################################################

Given I "Select all the LPNs, items and quantities in the location"
	Then I assign "get_cycle_count_lpn_list_for_detail_count.msql" to variable "msql_file"
	And I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0 
		Then I assign $row_count to variable "num_rows"
	ElsIf I verify MOCA status is 510 
		Then I "Cant find eligible LPNs to count - set the lodnum to null" 
			And I assign 0 to variable "num_rows"
	Else I fail step with error message "ERROR: unknown MOCA status"
	Endif
    
@wip @private
Scenario: Check for Count Near Zero Prompt
############################################################
# Description: Checks to see if the count near zero prompt appears on the terminal screen
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		None
# 	Optional:
#       None
# Outputs:
#		None
#############################################################

If I see "A cycle count is" in terminal within $wait_med seconds
	Then I press keys "Enter" in terminal
	And I wait $wait_med seconds    
	And I "am expecting to see the Cycle Count screen"
Else I fail step with error message "ERROR: Expected to see count near zero prompt for this test case"
EndIf

Then I execute scenario "Terminal Count Near Zero Cycle Count Process"

@wip @private
Scenario: Terminal Count Near Zero Cycle Count Process
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
#		None
#############################################################

Given I "should now be at the Cycle Count screen, inputting item number"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 5 column 4 in terminal
    Else I verify text $term_type is equal to "vehicle"
    	Once I see cursor at line 3 column 8 in terminal
    EndIf

    Then I execute scenario "Terminal Clear Field"
    And I "make sure I haven't copied extra characters from the terminal"
    	Then I execute MOCA command "[select ltrim(rtrim('" $prtnum "')) as prtnum from dual]"
    	And I verify MOCA status is 0
		Then I assign row 0 column "prtnum" to variable "prtnum"

    Then I enter $prtnum in terminal
    And I wait $wait_med seconds
    
Then I "Enter prt client id"
	If I verify text $term_type is equal to "handheld"
    	Once I see cursor at line 7 column 6 in terminal
    Else I verify text $term_type is equal to "vehicle"  
    	Once I see cursor at line 3 column 34 in terminal
    EndIf
	If I verify text $client_id is not equal to "----"
    	Then I execute scenario "Terminal Clear Field"
        And I "make sure I haven't copied extra characters from the terminal"
        	Then I execute MOCA command "[select ltrim(rtrim('" $client_id "')) as client_id from dual]"
        	And I verify MOCA status is 0
			And I assign row 0 column "client_id" to variable "client_id"
        And I enter $client_id in terminal
    Else I press keys "Enter" in terminal
    EndIf
    
Then I "expect to be in the quantity capture screen"
And I "decide how to proceed with the quantity capture based off input variables"
	If I verify text $match_count is equal to "REMATCH" ignoring case
		Then I "will enter a mismatched quantity the first time and the correct quantity the next time"
			And I execute scenario "Terminal Process Rematched Count"
	ElsIf I verify text $match_count is equal to "MISMATCH" ignoring case
		Then I "will do a mismatched count"
    		And I execute scenario "Terminal Process Mismatched Count"
	Else I execute scenario "Terminal Inventory Count Process Quantity Capture"
	EndIf

Then I "F6 to complete count and take me to deposit screen"
	And I press keys "F6" in terminal 2 times with $screen_wait seconds delay
    
If I verify text $match_count is equal to "MISMATCH" ignoring case
    Then I "will validate that audit generated after a mismatched count"
        And I assign "validate_audit_work_generated.msql" to variable "msql_file"
        When I execute scenario "Perform MSQL Execution"
        And I verify MOCA status is 0
EndIf
    
@wip @private
Scenario: Terminal Process Rematched Count
############################################################
# Description: Handles count near zero processing for an incorrect count in the first attempt and a correct count in the confirmation.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		None
# 	Optional:
#       None
# Outputs:
#		None
#############################################################

Given I execute scenario "Inventory Count Get untqty and numUOMs"
And I execute scenario "Calculate Quantity Mismatch Information for Count Zero"

Then I "have now created a mismatch, I will now input the mismatched value into the terminal screen"
	And I execute scenario "Terminal Enter Count Quantity"

And I "expect to see a mismatch error on the terminal screen"
	Then I execute scenario "Terminal Unexpected Entry during Count for Count Near Zero"
            
And I "now have to input the correct quantity, so I will call the same scenario without manipulating the quantity"
	Then I execute scenario "Terminal Inventory Count Process Quantity Capture"

@wip @private
Scenario: Terminal Process Mismatched Count
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
#		None
#############################################################

Given I execute scenario "Inventory Count Get untqty and numUOMs"
And I execute scenario "Calculate Quantity Mismatch Information for Count Zero"

Then I "have now created a mismatch, I will now input the mismatched value into the terminal screen"
	And I execute scenario "Terminal Enter Count Quantity"

And I "expect to see a mismatch error on the terminal screen"
	Then I execute scenario "Terminal Unexpected Entry during Count for Count Near Zero"
            
And I "now have to input the mismatched quantity again, so I will call the same scenario again"
	Then I execute scenario "Terminal Enter Count Quantity"

@wip @private
Scenario: Terminal Enter Count Quantity
############################################################
# Description: Enters the quantity (correct or mismatched) in the quantity capture count screen.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		untqty - driven from the previous scenarios Inventory Count Get untqty and numUOMs and Calculate Quantity Mismatch Information for Count Zero.
# 	Optional:
#       None
# Outputs:
#		None
#############################################################

Given I "Enter the quantity (for each UOM) and post it to the screen"
	Then I assign 1 to variable "rownum"
	And I convert string variable "numUOMs" to integer variable "numUOMs_num"
	While I verify number $numUOMs_num is greater than or equal to $rownum
		If I verify number $numUOMs_num is equal to $rownum
			And I enter $untqty in terminal
		Else I press keys "ENTER" in terminal
		Endif
		
		And I wait $wait_short seconds 
		Then I increase variable "rownum"
	EndWhile

@wip @private
Scenario: Terminal Unexpected Entry during Count for Count Near Zero
############################################################
# Description: Press Enter to go through the unexpected entry popup error during the counting process.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		untqty - driven from the previous scenarios Inventory Count Get untqty and numUOMs and Calculate Quantity Mismatch Information for Count Zero.
# 	Optional:
#       None
# Outputs:
#		None
#############################################################

If I see "Unexpected Entry" in terminal within $wait_med seconds 
	Then I "know there is a mismatch in what I counted"
    	And I press keys "ENTER" in terminal
EndIf

@wip @private
Scenario: Calculate Quantity Mismatch Information for Count Zero
############################################################
# Description: Calculates the mismatch quantity.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		untqty - driven from the previous scenario Inventory Count Get untqty and numUOMs.
# 	Optional:
#       None
# Outputs:
#		untqty - added 1 to existing untqty to create a mismatch
#############################################################

And I convert string variable "untqty" to integer variable "untqty_num"

Then I "Purposely want to create a mismatch, add 1 to the untqty"
	And I increase variable "untqty_num"
	And I convert number variable "untqty_num" to string variable "untqty"