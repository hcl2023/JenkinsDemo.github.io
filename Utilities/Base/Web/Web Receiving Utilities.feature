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
# Utility: Web Receiving Utilities.feature
# 
# Functional Area: Receiving
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: WEB, MOCA
#
# Description:
# This Utility contains common utility scenarios for Web Receiving Features in the Web
#
# Public Scenarios:
#	- Web Open Inbound Shipments Screen - opens the Inbound Shipments screen
#	- Get LPN Data for Reverse Confirmation - Gets the Sub-LPN associated to the Reverse Receipt of a load.
#	- Web Validate Reverse Receipt - Validates that a reverse receipt occurred on a load.
#	- Web Reverse Receipt - Reverses an order.
#	- Validate Putaway Process - Validate the putaway has been completed properly
#	- Web Putaway - This will receive and putaway inventory in recommended storage location
#	- Web Inbound Shipments Search for Shipment - Search Inbound Shipments by trailer
#	- Web Receiving Validate Inbound Shipment - Validates the shipment and order in the Web
#	- Web Open Receiving Door Activity Screen - opens the Receiving/Door Activity screen.
#	- Web Door Activity Select Trailer - Click on the trailer in the Door Activity Screen
#	- Web Receiving Unload All - Perform an Unload All operation from Door Activity
#	- Web Receiving Search for Trailer from Door Activity - Search for trailer on Door Activity Screen
#	- Receiving Validate Trailer After Unload All - Validate trailer state and location for Unload All operation
#	- Web Press Inbound Orders - Presses the Inbound Orders button.
#	- Web Select Add Inbound Order Action - Selects the Add Inbound Order from the Actions dropdown menu.
#	- Web Enter Inbound Order Information - Enters an saves the Inbound Order information.
#	- Web Receiving OSD Receipt - Perform Receive/Putaway for OSD conditions
#	- Web Receiving Validate OSD States - Valuidate OSD states after Receive/Putaway
#	- Validate Inbound Order - Validates the Inbound Order in the database.
#	- Web Add Quality Issues Information - Enters and saves the Quality Issue Information.
#	- Validate Inbound Quality Issue Created - Validates the Inbound Quality Issue was created in the database.
#	- Web Open Add Inbound Shipment Window - Opens the Add Inbound Shipment window from the Actions dropdown.
#	- Web Enter Inbound Shipment Information - Enters the information for the Inbound Shipment into the Add Inbound Shipment form.
#	- Validate Inbound Shipment - Validate the Inbound Shipment was created.
#	- Web Open Inbound Shipment Details - Selects the shipment to open its details screen.
#	- Web Open Copy Inbound Orders to Shipment Window - Selects the Copy Inbound Orders to Shipment option from the Actions dropdown.
#	- Web Inbound Shipments Search for Inbound Shipment Number - From inbound shipment screen, use search box to find shipment from the inbound shipment number. 
#	- Web Search For Order To Copy - From copy order window, search for a given order.
#	- Web Copy Order To Shipment - Selects the order in the Copy Order to Shipment window and then adds it to the shipment.
#	- Validate Inbound Order Copied to Shipment - Validates the Inbound Order was copied to the Shipment in the database.
#	- Web Receiving Complete OSD Shipment - Complete Shipment after having and verifying an OSD condition
#	- Web Assign Inbound Shipment  - Inbound Shipment is assigned to Transport Equipment
#	- Validate Trailer Assign to Shipment - Verifying shipment is assign to transport Equipment
#	- Web Receiving Complete Shipment - Complete Shipment clicking on Commplete Inbound Shipment button
#	- Web Inbound Complete Shipment - Complete Inbound Shipment in the Web
#	- Web Receiving Dispatch Trailer Modes - Select Transport Equipment option to leave_at_door, turnaround, or dispatch option and press OK
#	- Web Receiving Without Trailer - Given a shipment without a trailer, perform receiving in the web.
# 	- Web Open Receiving Work Queue Screen - Open the Receiving/Work Queue screen, given the Web UI is open.
#	- Web Open Report Quality Issue Screen - Selects report quality issue option from the actions drop-down on inbound shipment details screen
#	- Web Add Report Quality Issues Information - Enters and saves the Quality Issue Information on Report Quality screen
#	- Web Validate Report Quality Issue Created - Validates a Quality Issue was created
#	- Web Validate Reversed LPN on Inbound Shipment Details Screen - Validate Reversed LPN on Inbound Shipment Details screen
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################ 
Feature: Web Receiving Utilities

@wip @public
Scenario: Web Reverse Receipt
#############################################################
# Description: Given a load number, will reverse the receipt.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		trlr_num - the Inbound Shipment that will be reversed
#		lodnum - the Load Number that will be reversed
#	Optional:
#		None
# Outputs:
# 	None
#############################################################

Given I "click the inbound shipment that will be reversed"
	Then I assign variable "elt" by combining "xPath://span[@class='rpux-link-grid-column-link' and text()='" $trlr_num "']"
	When I click element $elt in web browser within $max_response seconds
	Once I see "Inbound Shipment - " in web browser

And I "click the 'View LPNs' button"
	Given I assign variable "elt" by combining "xPath://span[text()='View LPNs']/..//span[2]"
	When I click element $elt in web browser within $max_response seconds
	Once I see "Attributes" in web browser 

Then I "check the box for the LPN to be reversed"
	And I assign variable "elt" by combining "xPath://span[@class='rpux-link-grid-column-link' and text()='" $lodnum "']"
	And I assign variable "elt" by combining $elt "/../../..//div[@class='x-grid-row-checker']"
	When I click element $elt in web browser within $max_response seconds

And I "click the 'Actions' dropdown"
	Given I assign variable "elt" by combining "xPath://span[starts-with(@id,'moreactionsbutton') and text()='Actions']/..//span[2]"
	When I click element $elt in web browser within $max_response seconds

And I "click the 'Reverse LPN'"
	Given I assign variable "elt" by combining "xPath://span[starts-with(@id,'menuitem') and text()='Reverse LPN']"
	When I click element $elt in web browser within $max_response seconds
	Once I see "will be reversed" in web browser

And I "reverse the Receipt"
	Given I assign variable "elt" by combining "xPath://span[starts-with(@id,'button-') and text()='Yes']/..//span[2]"
	Then I click element $elt in web browser within $max_response seconds

@wip @public
Scenario: Web Open Inbound Shipments Screen
#############################################################
# Description: Opens the Inbound Shipments Screen, given the Web UI is open.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		None
#	Optional:
#		None
# Outputs:
# 	None
#############################################################

Given I "open the Inbound Shipments screen"
	And I assign "Inbound Shipments" to variable "wms_screen_to_open"
	And I assign "Receiving" to variable "wms_parent_menu"
	And I execute scenario "Web Screen Search"
	Once I see "Inbound Orders" in web browser

And I unassign variables "wms_screen_to_open,wms_parent_menu"
    
@wip @public
Scenario: Web Open Receiving Door Activity Screen
#############################################################
# Description: Opens the Receiving/Door Activity Screen, given the Web UI is open.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		None
#	Optional:
#		None
# Outputs:
# 	None
#############################################################

Given I "open the Receiving/Door Activity screen"
	And I assign "Door Activity" to variable "wms_screen_to_open"
	And I assign "Receiving" to variable "wms_parent_menu"
	And I execute scenario "Web Screen Search"
	Once I see "Door Activity" in web browser

And I unassign variables "wms_screen_to_open,wms_parent_menu"

@wip @public
Scenario: Get LPN Data for Reverse Confirmation
#############################################################
# Description: Gets LPN Data for Reverse Confirmation
# MSQL Files:
#	get_sub_lpn_to_validate_reverse_receipt.msql
# Inputs:
# 	Required:
#		lodnum - the load associated with the sub-load
#	Optional:
#		None
# Outputs:
# 	verify_subnum - the sub-LPN that is associated with the Reverse Receipt
#############################################################

Given I "get LPN info for reverser receipt confirmation"
	Then I assign "get_sub_lpn_to_validate_reverse_receipt.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	And I assign row 0 column "subnum" to variable "verify_subnum"

@wip @public
Scenario: Web Validate Reverse Receipt
#############################################################
# Description: Validates that a reverse receipt occurred on a load.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		verify_subnum - the Sub-LPN to filter the search by
#		lodnum - the LPN to validate has been reversed
#	Optional:
#		None
# Outputs:
# 	None
#############################################################

Given I "go to Search box and enter History"
	Then I assign "History" to variable "wms_screen_to_open"
	When I execute scenario "Web Screen Search"
	Once I see "Transaction Date" in web browser
	Then I maximize web browser

And I "set the beginning date to 12:00 am to account for server time zone differences"
	Given I assign variable "elt" by combining "xPath://td[contains(@id,'timefield')]//div[contains(@class,'x-form-time-trigger')]"
	When I click 1 st element $elt in web browser within $max_response seconds
	And I assign variable "elt" by combining "text:12:00 am"
	And I click element $elt in web browser within $max_response seconds

And I "set the ending time to 11:45 pm and date (one day ahead) to account for server time zone differences"
	Given I assign variable "elt" by combining "xPath://label[contains(@id,'rpDateTime') and @class = 'x-form-item-label x-unselectable x-form-item-label-to']/../../descendant::input[contains(@id, 'datefield')]"
	And I clear all text in element $elt in web browser within $max_response seconds
	And I assign "MM/dd/yyyy" to variable "date_format"
	And I assign "86400" to variable "seconds_in_day"
	And I convert string variable "seconds_in_day" to INTEGER variable "seconds_in_day_num"
	Then I execute Groovy """import java.time.*; new_date = LocalDateTime.now().plus(seconds_in_day_num).format(date_format)"""
	And I type $new_date in element $elt in web browser within $max_response seconds

	Given I assign variable "elt" by combining "xPath://td[contains(@id,'timefield')]//div[contains(@class,'x-form-time-trigger')]"
	When I click 2 nd element $elt in web browser within $max_response seconds
	And I assign variable "elt" by combining "text:11:45 pm"
	And I click element $elt in web browser within $max_response seconds
    
When I "search for the Sub-LPN that was reversed"
	Given I assign variable "elt" by combining "xPath://div[starts-with(@id,'wm-dailytransaction-main-') and contains(@id,'-body')]"
	And I assign variable "elt" by combining $elt "//input[starts-with(@id,'rpFilterComboBox-') and contains(@id,'-inputEl')]"
	When I click element $elt in web browser within $max_response seconds
	And I type $verify_subnum in element $elt in web browser within $max_response seconds

And I "select the 'in Sub-LPN' choice"
	When I click element "text: in Sub-LPN" in web browser within $max_response seconds

Then I "confirm there is a Reverse Receipt activity for the LPN that was reversed"
	Given I assign variable "elt" by combining "xPath://span[@class='rpux-link-grid-column-link' and text()='" $lodnum "']"
	And I assign variable "elt" by combining $elt "/../../..//div[starts-with(@class,'column-item') and text()='Reverse Receipt']"
	Once I see element $elt in web browser

And I unassign variable "wms_screen_to_open"
    
@wip @public
Scenario: Web Receiving Without Trailer
#############################################################
# Description: Given a shipment without a trailer, perform receiving in web.
# First select the staging lane and then receive and putaway goods
# MSQL Files:
#	None
# Inputs:
#	Required:
#		ship_id - inbound shipment id
#	Optional:
#		rec_loc - receiving staging lane location
# Outputs:
#	None
#############################################################

Given I execute scenario "Create local xPaths"

And I "check I am on the Inbound Shipments Screen"
	Once I see "Inbound Shipments" in web browser

Then I "search for Shipment"
	And I assign $ship_id to variable "trknum"
	And I execute scenario "Web Inbound Shipments Search for Inbound Shipment Number"

And I "select the inbound shipment from the Inbound Shipments page"
	Given I assign variable "shipment" by combining "text:" $ship_id
	When I click element $shipment in web browser within $max_response seconds
    
And I "select the 'Actions' drop-down"
	When I click element $inbound_shipments_action_button in web browser within $max_response seconds 
 
And I "select the 'Assign to Staging Lane' choice from the 'Actions' drop-down"
	Given I assign "Assign to Staging Lane" to variable "text"
	And I execute scenario "Web xPath for Span Text"
	When I click element $elt in web browser within $max_response seconds
    Once I see "Assign Inbound Shipment To Staging Lane" in web browser
    
And I "select Staging Lane and Save"
	Then I assign variable "elt" by combining "xPath://div[contains(text(),'" $rec_loc "')]"
	And I click element $elt in web browser within $max_response seconds

	Then I assign variable "elt" by combining "xPath://span[starts-with(@id,'save-') and text()='Save']/.."
	And I click element $elt in web browser within $max_response seconds
    Once I see "Inbound Shipments" in web browser
         
And I "receive and perform putaway"
	Then I execute scenario "Web Receiving Perform Receiving and Putaway"

@wip @public
Scenario: Web Perform Receiving
#############################################################
# Description: Given a trailer number, perform receiving in web.
# Closing a receipt including receiving and putaway of goods and dispatch of equipment.
# Support for both ASN and non-ASN via the asn_flag
# MSQL Files:
#	None
# Inputs:
#	Required:
#		trlr_num - the trailer to close the receipt at
#		asn_flag - TRUE|FALSE to descern if this is an ASN or non-ASN receive condition
#		uom - Unit of Measure (Case|Each|Pallet)
#	Optional:
#		lodnum - load number to use for receiving
#		auto_close_flag - Should the trailer auto close (def='FALSE')
#		lotnum - lot number
#		revlvl - revision level
# Outputs:
#	None
#############################################################

Given I execute scenario "Create local xPaths"

And I "search for shipment with search box"	
	Then I execute scenario "Web Inbound Shipments Search for Shipment"
 
And I "select the inbound shipment I want from the Inbound Shipments page"
	Given I assign variable "shipment" by combining "text:" $trlr_num
	When I click element $shipment in web browser within $max_response seconds 
         
And I "receive and perform putaway"
	Then I execute scenario "Web Receiving Perform Receiving and Putaway"
    
And I "click into the shipment with the shipment link and complete shipment"
	If I verify variable "auto_close_flag" is assigned
	And I verify text $auto_close_flag is equal to "TRUE" ignoring case
	Else I execute scenario "Web Complete Inbound Shipment"
	EndIf

And I "Go back to the Search box and enter my search arguments"
	Then I execute scenario "Web Open Receiving Door Activity Screen"

And I "search for my truck sitting at my dock door"
	Then I execute scenario "Web Dock Door Search for Trailer"
    
And I "click on Trailer"
	Then I execute scenario "Web Door Activity Select Trailer"
    
And I "complete receive and dispatch equipment"
	Then I execute scenario "Web Trailer Close and Dispatch Equipment"
 
@wip @public
Scenario: Web Trailer Close and Dispatch Equipment
#############################################################
# Description: Close and dispatch equipment
# MSQL Files:
#	None
# Inputs:
#	Required:
#		trlr_num - the trailer to close the receipt at
#		auto_close_flag - if set to TRUE will skip close operation (if available) 
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "select the 'Actions' drop-down"
	When I click element $dock_door_Actions_button in web browser within $max_response seconds 

And I "close if needed and dispatch trailer"
	Then I assign "TRUE" to variable "perform_close"
	If I verify variable "auto_close_flag" is assigned
	And I verify text $auto_close_flag is equal to "TRUE" ignoring case
		Then I assign "FALSE" to variable "perform_close"
	Else I "select 'Close Equipment' from the list"
		If I see element $close_equipment in web browser within $wait_med seconds
			And I assign "TRUE" to variable "perform_close"
			Then I scroll to element $close_equipment in web browser within $max_response seconds
			And I click element $close_equipment in web browser within $max_response seconds
		EndIf
    EndIf

    And I "Dispatch the equipment to finish the task"
		When I click element $dispatch_equipment_choice in web browser within $max_response seconds 

	And I "press ENTER for the YES/NO Confirmation"
		if I verify text $perform_close is equal to "TRUE"
			Then I press keys "ENTER" in web browser
		EndIf
   
	And I "wait for the trailer to close/dispatch" which can take between $wait_long seconds and $max_response seconds

And I "get the 'Dispatch Equipment' dialog box. I only need to select 'Dispatch' and we're done"
	When I click element $final_dispatch in web browser within $max_response seconds 
 
And I "get the 'Check Out Complete' Confirmation and press Enter"
	Once I see "Check Out Complete" in web browser
	Then I press keys "ENTER" in web browser

@wip @public
Scenario: Web Inbound Shipments Search for Shipment
#############################################################
# Description: From inbound shipment screen, use search box to 
# find shipment from the trailer
# MSQL Files:
#	None
# Inputs:
#	Required:
#       trlr_num - trailer number
#	Optional:
#		None
# Outputs:
# 		None             
#############################################################

Given I "am on the Inbound Shipment screen"
	Once I see "Inbound Shipments" in web browser

And I "search for trailer/shipment with the Inbound Shipment search box"
	Then I assign "Equipment Number" to variable "component_to_search_for"
	And I assign $trlr_num to variable "string_to_search_for"
	And I execute scenario "Web Component Search"
    
    And I unassign variables "component_to_search_for,string_to_search_for"

@wip @public
Scenario: Web Door Activity Select Trailer
#############################################################
# Description: In the Door Activity Screen, click on the Trailer
# MSQL Files:
#	None
# Inputs:
#	Required:
#       trlr_num - Trailer Number
#	Optional:
#		None
# Outputs:
# 		None             
#############################################################

Given I "click on Trailer in Door Activity Screen"
	Then I assign variable "elt" by combining "xPath://div[contains(text(),'" $trlr_num "')]"
	Once I see element $elt in web browser 
	And I click element $elt in web browser within $max_response seconds
    
@wip @public
Scenario: Web Receiving Unload All
#############################################################
# Description: This scenario will perform an Unload All operation using the WEB
# MSQL Files:
#	None
# Inputs:
#	Required:
#		rec_loc - receiving staging location
#		move_option - options are dispatch, move_to, or leave (relative to uload all operation)
#	Optional:
#		move_to_loc - option if move_option is move_to
# Outputs:
# 		None             
#############################################################

Given I "setup xpaths to use"
	And I execute scenario "Create local xPaths"
   
And I "select the 'Actions' drop-down"
	When I click element $dock_door_Actions_button in web browser within $max_response seconds
    
And I "select 'Unload All' from the Action list"
	When I scroll to element $unload_all_item in web browser within $max_response seconds
	And I click element $unload_all_item in web browser within $max_response seconds
    Once I see "Unload All from" in web browser
    
And I "select the receiving staging lane"
	Then I assign variable "elt" by combining "xPath://div[text()='" $rec_loc "']"
	Once I see element $elt in web browser 
	And I click element $elt in web browser within $max_response seconds
    
And I "click next"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id,'button') and text()='Next']/.."
	Once I see element $elt in web browser 
	And I click element $elt in web browser within $max_response seconds
    
And I "decide the proper move operation and perform actions"
	If I verify variable "move_option" is assigned
    And I verify text $move_option is not equal to ""
	Else I assign "dispatch" to variable "move_option"
    EndIf
    
    And I "click on move equipment operation"
		If I verify text $move_option is equal to "dispatch" ignoring case
			Then I assign variable "elt" by combining "xPath://*[@id=(//label[text()='Dispatch Equipment']/@for)]"
		ElsIf I verify text $move_option is equal to "move_to" ignoring case
			Then I assign variable "elt" by combining "xPath://*[@id=(//label[text()='Move to New Location']/@for)]"
		Elsif I verify text $move_option is equal to "leave" ignoring case
			Then I assign variable "elt" by combining "xPath://*[@id=(//label[text()='Leave At Door']/@for)]"
		Else I fail step with error message "ERROR: did not recognize a valid move_option"
    	EndIf
    	And I click element $elt in web browser within $max_response seconds
    
    	If I verify text $move_option is equal to "dispatch" ignoring case
			Then I see "Dispatch Equipment" in web browser
    	ElsIf I verify text $move_option is equal to "leave" ignoring case
			Then I see "Leave At Door" in web browser
		ElsIf I verify text $move_option is equal to "move_to" ignoring case
        	Then I assign variable "elt" by combining "xPath://div[text()='" $move_to_loc "']"
			Once I see element $elt in web browser 
			And I click element $elt in web browser within $max_response seconds
            Then I see "Move Equipment" in web browser
		EndIf
    
    And I "click on Next button"
        Then I assign variable "elt_next" by combining "xPath://span[starts-with(@id,'button') and text()='Next']/.."
    	Once I see element $elt_next in web browser 
		And I click element $elt_next in web browser within $max_response seconds

And I "complete the operation (click on Finish)"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id,'button') and text()='Finish']/.."
	And I click element $elt in web browser within $max_response seconds
    
And I "wait for WMS to process trailer move operation" which can take between $wait_long seconds and $max_response seconds
    
@wip @public
Scenario: Web Receiving Search for Trailer from Door Activity
#############################################################
# Description: On the Dock Door Activity Screen, search for the input trailer.
# MSQL Files:
#	None
# Inputs:
#	Required:
#       trlr_num - Trailer Number
#	Optional:
#		None
# Outputs:
# 		None             
#############################################################

Given I execute scenario "Create local xPaths"

Then I "check we are on Door Activity Screen and search for the input trailer"
	Once I see "Door Activity" in web browser
	Once I see $trlr_num in web browser
    
And I "search for my truck sitting at my dock door"
	Then I execute scenario "Web Dock Door Search for Trailer"

@wip @public
Scenario: Receiving Validate Trailer After Unload All
#############################################################
# Description: Gets trailer state and yard location and validates
# versus inputs/assumptions associated after an Unload All operation
# MSQL Files:
#	get_trailer_state_and_location.msql
# Inputs:
# 	Required:
#		yard_loc - receiving location for trailer
#		trlr_num - trailer number
#		move_option - options are dispatch, move_to, or leave
#	Optional:
#		move_to_loc - location trailer was moved to
# Outputs:
# 	None
#############################################################

Given I "get trailer status and location"
	Then I assign "get_trailer_state_and_location.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	if I verify MOCA status is 0
		Then I assign row 0 column "yard_loc" to variable "ret_yard_loc"
    	And I assign row 0 column "trlr_stat" to variable "ret_trlr_stat"
	Else I fail step with error message "ERROR: failed to get trailer state and location"
	EndIf

And I "verify trailer state and location"
	if I verify text $move_option is equal to "move_to" ignoring case
		If I verify text $move_to_loc is equal to $ret_yard_loc ignoring case
    	And I verify text $ret_trlr_stat is equal to "C" ignoring case
		Else I assign variable "error_message" by combining "ERROR: expected trailer (" $trlr_num ") at location (" $move_to_loc ") but was found at " $ret_yard_loc " with state of " $ret_trlr_stat
    		And I fail step with error message $error_message
		EndIf
	EndIf

	if I verify text $move_option is equal to "leave" ignoring case
		If I verify text $yard_loc is equal to $ret_yard_loc ignoring case
    	And I verify text $ret_trlr_stat is equal to "C" ignoring case
    	Else I assign variable "error_message" by combining "ERROR: expected trailer (" $trlr_num ") at location (" $yard_loc ") but was found at " $ret_yard_loc " with state of " $ret_trlr_stat
    		And I fail step with error message $error_message
		EndIf
	EndIf

	if I verify text $move_option is equal to "dispatch" ignoring case
		If I verify text $ret_yard_loc is equal to ""
    	And I verify text $ret_trlr_stat is equal to "D" ignoring case
    	Else I assign variable "error_message" by combining "ERROR: expected trailer (" $trlr_num ") to be dispatched, but was found at " $ret_yard_loc " with state of " $ret_trlr_stat
    		And I fail step with error message $error_message
		EndIf
	EndIf

And I unassign variables "ret_yard_loc,ret_trlr_stat"
	
@wip @public
Scenario: Web Press Inbound Orders
#############################################################
# Description: Presses the Inbound Orders button.
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

Given I "click Inbound Order button"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id, 'button-') and text()='Inbound Orders']/ancestor::a[starts-with(@id, 'button-') and contains(@class, 'x-btn')]"
	Then I click element $elt in web browser within $max_response seconds
	Once I do not see element $elt in web browser

@wip @public
Scenario: Web Select Add Inbound Order Action
#############################################################
# Description: Selects the Add Inbound Order from the Actions dropdown menu.
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

Given I "select the Actions Drop Down"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id,'button-') and contains(@id,'-btnInnerEl') and .= 'Actions']/ancestor::a[starts-with(@id,'button-')]"
	And I click element $elt in web browser within $max_response seconds

And I "click the Add Inbound Order"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id,'menuitem') and text()='Add Inbound Order']"
	And I click element $elt in web browser within $max_response seconds
	
And I "verify the Add Inbound Order window appears"  
  And I assign variable "elt" by combining "xPath://div[starts-with(@id, 'wm-inboundloads-addorder-')]"
  Once I see element $elt in web browser

@wip @public
Scenario: Web Enter Inbound Order Information
#############################################################
# Description: Enters and saves the Inbound Order information.
# Will add single line to the order.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		invnum - The Inventory number
#		order_type - The type of Inbound Order
#		supnum - The Supplier number
#		prtnum - The part number
#		expqty - The expected quantity
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "enter Inventory number"
	Then I assign variable "elt" by combining "xPath://input[contains(@name, 'receiptNumber')]"
	And I click element $elt in web browser within $max_response seconds
	And I type $invnum in element $elt in web browser within $max_response seconds

And I "enter Inbound Order Type"
	Then I assign variable "elt" by combining "xPath://input[contains(@name, 'receiptType')]"
	And I click element $elt in web browser within $max_response seconds
	And I type $order_type in element $elt in web browser within $max_response seconds
	And I click element $elt in web browser within $max_response seconds
	And I assign variable "elt" by combining "xPath://li[text()='" $order_type "']"
    And I click element $elt in web browser within $max_response seconds

And I "enter Supplier"
	Then I assign variable "elt" by combining "xPath://input[contains(@name, 'supplierNumber')]"
	And I click element $elt in web browser within $max_response seconds
	And I type $supnum in element $elt in web browser within $max_response seconds
	And I click element $elt in web browser within $max_response seconds
	And I assign variable "elt" by combining "xPath://li[text()='" $supnum "']"
    And I click element $elt in web browser within $max_response seconds

And I "save Inbound Order"
	Then I assign variable "elt" by combining "xPath://div[starts-with(@id, 'wm-inboundloads-addorder')]/descendant::span[starts-with(@id, 'button-') and text()='Save']/ancestor::a[starts-with(@id, 'button-') and contains(@class, 'x-btn')]"
	And I see element $elt in web browser
	And I click element $elt in web browser within $max_response seconds
    
And I "add a line to the inbound order"
	Then I execute scenario "Web Receiving Add Line to Order"

And I "verify Inbound Order was saved to table"
	Once I see $prtnum in web browser
	Once I see "001" in web browser
	Once I see $expqty in web browser
	Once I see $invnum in web browser

@wip @public
Scenario: Validate Inbound Order
#############################################################
# Description: Validates the Inbound Order in the database.
# MSQL Files:
#	validate_inbound_order.msql
# Inputs:
# 	Required:
#		invnum - The inventory number for the Inbound Order
#		supnum - The supplier number for the Inbound Order
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "validate the Inbound Order was created in the database"
	Then I assign "validate_inbound_order.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
    	Then I echo "Inbound Order was created"
    Else I fail step with error message "ERROR: Inbound Order failed to be created"
    Endif
    
@wip @public
Scenario: Web Receiving OSD Receipt
#############################################################
# Description: Performs a Receive and Putaway for Under, Over,
# and Damage product conditions.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		trlr_num - trailer number
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "setup xpaths to use and validate location"
	And I execute scenario "Create local xPaths"
    Once I see "Inbound Orders" in web browser
 
And I "select the inbound shipment I want from the Inbound Shipments page"
	Given I assign variable "shipment" by combining "text:" $trlr_num
	When I click element $shipment in web browser within $max_response seconds 
    
And I "perform receiving and putaway operations"
	Then I execute scenario "Web Receiving Perform Receiving and Putaway"
    
And I unassign variable "shipment"
        
@wip @public
Scenario: Web Receiving Validate OSD States
#############################################################
# Description: After a Receive and Putaway for Under, Over,
# and Damage product receive conditions, navigate to shipment screen,
# view and validate the View LPNs and OSD Tabs
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		trlr_num - trailer number
#		prtnum - part number
#		rcvqty - quantity that was received
#		damaged_flag - did the receive mark goods as Damaged Product
#		rec_loc - location where product was directed during putaway
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "am on the Inbound Shipment screen"
	Once I see "Inbound Shipments" in web browser

And I "click into the shipment with the shipment link"
	Then I assign variable "elt" by combining "xPath://span[@class='rpux-link-grid-column-link' and text()='" $trlr_num "']"
 	And I click element $elt in web browser within $max_response seconds
	Once I see "View LPNs" in web browser
	Once I see "OSD/Complete" in web browser

And I "click on the OSD/Complete button and verify contents"
	Then I assign variable "elt" by combining "xPath://span[text()='OSD/Complete']/..//span[2]"
	And I click element $elt in web browser within $max_response seconds
	Once I see "All LPNs" in web browser
    
And I "click on the All LPNs TAB and verify contents"
	Then I assign variable "elt" by combining "xPath://span[text()='All LPNs']/..//span[2]"
	And I click element $elt in web browser within $max_response seconds
    Once I see $prtnum in web browser
    Once I see $rcvqty in web browser 
    
    if I verify variable "damaged_flag" is assigned
    And I verify text $damaged_flag is equal to "TRUE" ignoring case
    	Once I see "Damaged Product" in web browser
    EndIf
    
    if I verify variable "rec_loc" is assigned
	And I verify text $rec_loc is not equal to ""
    	Once I see $rec_loc in web browser
    EndIf
    
And I "click on the OSD button and verify screen"
	Then I assign variable "elt" by combining "xPath://span[text()='OSD']/..//span[2]"
	And I click element $elt in web browser within $max_response seconds
	Once I see "Over" in web browser
    Once I see "Short" in web browser
    Once I see "Damaged" in web browser

And I "select Over, Short, and Damaged TABs and verify contents"
	Then I execute scenario "Web Receiving Verify OSB TAB States"
    
@wip @public
Scenario: Web Receiving Complete Shipment
#############################################################
# Description: Complete Shipment by click on Complete Inbound
# Shipment and dispatching equipment
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		auto_close_flag - if TRUE skips Complete Shipment selection/action
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "check for auto_close_flag and skip if set"
	If I verify variable "auto_close_flag" is assigned
    And I verify text $auto_close_flag is equal to "TRUE" ignoring case
    Else I "am on the Inbound Shipment OSD/View LPNs screen"
		Once I see "Inbound Shipments" in web browser
		Once I see "OSD" in web browser
    
		And I "click on Complete Inbound Shipment"
			Then I assign variable "elt" by combining "xPath://span[text()='Complete Inbound Shipment']/..//span[2]"
			And I click element $elt in web browser within $max_response seconds
			Once I see "Leave equipment at door" in web browser
    
		And I "click ok and leave the equipment at the door"
			Then I assign variable "elt" by combining "xPath://span[text()='OK']/..//span[2]"
			And I click element $elt in web browser within $max_response seconds

		And I "handle safety check workflow on close if seen"
			If I see "Safety Check" in web browser within $wait_med seconds
				Then I execute scenario "Web Complete Trailer Safety Check"
			EndIf 

			Once I see "Inbound Shipment Complete" in web browser
	EndIf

@wip @public
Scenario: Web Open Inbound Quality Issues Screen
#############################################################
# Description: Opens the Inbound Quality Issues Screen.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		  None
#	  Optional:
#	  	None
# Outputs:
# 	None
#############################################################

Given I "open the Inbound Quality Issues screen"
	Then I assign "Inbound Quality Issues" to variable "wms_screen_to_open"
	And I assign "Receiving" to variable "wms_parent_menu"
	And I execute scenario "Web Screen Search"
 
Once I see "This list includes supplier and carrier quality issues" in web browser

And I unassign variables "wms_screen_to_open,wms_parent_menu"

@wip @public
Scenario: Web Add Quality Issues Information
#############################################################
# Description: Enters and saves the Quality Issue Information.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		issue_type - Specifies whether this was a Carrier or Supplier quality issue.
#		issue_rsn - The reason for the quality issue.
#		inbqty - The quantity of quality issues.
#		supnum - The supplier of the quality issue.
#		carcod - The carrier of the quality issue.
#	  Optional:
#		None
# Outputs:
# 	None
#############################################################

Given I "click the Add button"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id, 'button-') and text()='Add']/ancestor::a[contains(@class, 'x-btn')]"
	And I click element $elt in web browser within $max_response seconds
	Once I see "Add Quality Issue" in web browser

	If I verify text $issue_type is equal to "Supplier" ignoring case
		Then I execute scenario "Web Enter Supplier Quality Issue Information"
	Elsif I verify text $issue_type is equal to "Carrier" ignoring case
		Then I execute scenario "Web Enter Carrier Quality Issue Information"
	Endif

And I "save the Quality Issue"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id, 'button-') and text()='Save']/ancestor::a[contains(@class, 'x-btn')]"
	And I click element $elt in web browser within $max_response seconds

And I "verify the Quality Issue was saved"
	Then I assign variable "elt" by combining "xPath://span[contains(@class, 'rpux-link-grid-column-link') and text()='" $issue_rsn "']"
	Once I see element $elt in web browser

@wip @public
Scenario: Validate Inbound Quality Issue Created
#############################################################
# Description: Validates the Inbound Quality Issue was created in the database.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		issue_type - Specifies whether this was a Carrier or Supplier quality issue.
#		issue_rsn - The reason for the quality issue.
#		inbqty - The quantity of quality issues.
#		supnum - The supplier of the quality issue.
#		carcod - The carrier of the quality issue.
#	  Optional:
#		None
# Outputs:
# 	None
#############################################################

If I verify text $issue_type is equal to "Supplier"
	Then I execute scenario "Validate Supplier Inbound Quality Issue"
Elsif I verify text $issue_type is equal to "Carrier"
	Then I execute scenario "Validate Carrier Inbound Quality Issue"
Endif

@wip @public
Scenario: Web Receiving Validate Inbound Shipment
#############################################################
# Description: Validates the shipment and order in the Web
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		yard_loc - yard location
#		trlr_num - trailer number
#		prtnum - part number
#		expqty - expected quantity of prtnum
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "validate screen data for shipment"
	Once I see $yard_loc in web browser
	Once I see $trlr_num in web browser
        
And I "click into the shipment from the shipment link"
	Then I assign variable "elt" by combining "xPath://span[@class='rpux-link-grid-column-link' and text()='" $trlr_num "']"
	And I click element $elt in web browser within $max_response seconds
        
And I "validate inbound shipment screen"
	Once I see $yard_loc in web browser
	And I assign variable "inb_ship_string" by combining "Inbound Shipment - " $trlr_num
	Once I see $inb_ship_string in web browser
        
And I "click into the order"
	Then I assign variable "elt" by combining "xPath://a[contains(@id, 'rpHyperlink-') and text()='" $trlr_num "']"
	And I click element $elt in web browser within $max_response seconds
        
And I "validate the planned inbound order"
	Once I see $yard_loc in web browser
	Once I see $prtnum in web browser
	And I assign variable "planned_ord_string" by combining "Planned Inbound Order - " $trlr_num
    Once I see $planned_ord_string in web browser
    And I assign variable "expected_quantity" by combining $expqty " Units"
	Once I see $expected_quantity in web browser

And I unassign variables "planned_ord_string,inb_ship_string,expected_quantity,elt"

@wip @public
Scenario: Validate Putaway Process
#############################################################
# Description: Validate the putaway process has completed properly
# MSQL Files:
#	get_inventory.msql
# Inputs:
# 	Required:
#		lodnum - the load associated with the Inventory
#	Optional:
#		None
# Outputs:
# 	stoloc - storage location from MSQL query
#############################################################

Given I "Validate the putaway has completed properly"
	Then I assign "get_inventory.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	And I assign row 0 column "stoloc" to variable "stoloc"
	If I verify text $stoloc is equal to $rec_loc ignoring case
		Then I echo "Validation of putaway has passed and putaway is done"
	Else I fail step with error message "ERROR: Validation of putaway has failed"    
	EndIf
    
@wip @public
Scenario: Web Putaway
#############################################################
# Description: This will receive and putaway inventory in recommended storage location
# MSQL Files:
#	None
# Inputs:
#	Required:
#		trlr_num - Name of the Transport Equipment
#		rec_loc - The location were the inventory is to be deposited
#		rec_qty - The required amount of quantity to be received
#		lodnum - The load number
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I execute scenario "Create local xPaths"

And I "search for shipment with search box"	
	Then I execute scenario "Web Inbound Shipments Search for Shipment"
 
And I "select the inbound shipment I want from the Inbound Shipments page"
	Given I assign variable "shipment" by combining "text:" $trlr_num
	When I click element $shipment in web browser within $max_response seconds 
 
And I "receive and perform putaway"
	Then I execute scenario "Web Receiving Perform Receiving and Putaway"  

@wip @public
Scenario: Web Open Add Inbound Shipment Window
#############################################################
# Description: Opens the Add Inbound Shipment window from the Actions dropdown.
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

Given I "open the Actions dropdown"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id, 'button-') and text() = 'Actions']/ancestor::a[starts-with(@id, 'button-') and contains(@class, 'x-btn')]"
	And I click element $elt in web browser within $max_response seconds

And I "select Add Inbound Shipment"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id, 'menuitem-') and text() = 'Add Inbound Shipment']"
	And I click element $elt in web browser within $max_response seconds

And I "verify Add Inbound Shipment Window is open"
	Then I assign variable "elt" by combining "xPath://div[starts-with(@id, 'wm-inboundloads')]"
	Once I see element $elt in web browser within $max_response seconds
  
@wip @public
Scenario: Web Enter Inbound Shipment Information
#############################################################
# Description: Enters the information for the Inbound Shipment into the Add Inbound Shipment form.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		trknum - Name of the Shipment
#		rcpt_area - The receipt area for the inbound shipment
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "verify Add Inbound Shipment Window is open"
	Then I assign variable "elt" by combining "xPath://div[starts-with(@id, 'wm-inboundloads')]"
	Once I see element $elt in web browser  

And I "enter trailer number"
	Then I assign variable "elt" by combining "xPath://input[contains(@name, 'masterReceiptId')]"
    And I click element $elt in web browser within $max_response seconds
	And I type $trknum in element $elt in web browser within $max_response seconds
    
And I "enter receipt area"
	Then I assign variable "elt" by combining "xPath://input[contains(@name, 'expectedReceiptArea')]"
    And I click element $elt in web browser within $max_response seconds
    And I type $rcpt_area in element $elt in web browser within $max_response seconds
    And I wait $wait_short seconds
    And I assign variable "elt" by combining "xPath://li[text() = '" $rcpt_area "']"
    And I click element $elt in web browser within $max_response seconds
    
And I "press Save button"
	Then I assign variable "elt" by combining "xPath://div[starts-with(@id, 'wm-inboundloads-addload')]/descendant::span[text()='Save']/ancestor::a[starts-with(@id, 'button-') and contains(@class, 'x-btn')]"
    And I click element $elt in web browser within $max_response seconds
    
And I "verify inbound shipment is saved"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id, 'wm-inboundloads-inboundloads_header_hd-') and text() = 'Inbound Shipment - " $trknum "']"
	And I see element $elt in web browser within $wait_med seconds

@wip @public
Scenario: Validate Inbound Shipment
#############################################################
# Description: Validate the Inbound Shipment was created.
# MSQL Files:
#	validate_inbound_shipment.msql
# Inputs:
# 	Required:
#		trknum - Name of the Shipment
#		rcvtrk_stat - receive truch stat
#	Optional:
#		None
# Outputs:
# 	None
#############################################################

Given I "validate the putaway has been executed or not"
	And I assign "validate_inbound_shipment.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
    	Then I echo "Inbound Shipment was created"
  	Else I fail step with error message "ERROR: Inbound Shipment failed to be created"
  	Endif

@wip @public
Scenario: Web Open Inbound Shipment Details
#############################################################
# Description: Selects the shipment to open its details screen.
# MSQL Files:
#	None
# Inputs:
#	Required:
#       trknum - Name of the Shipment
#	Optional:
#		None
# Outputs:
# 		None             
#############################################################

Given I "click the inbound shipment to open details screen"
	Then I assign variable "elt" by combining "xPath://span[@class='rpux-link-grid-column-link' and text()='" $trknum "']"
	When I click element $elt in web browser within $max_response seconds
	Once I see "Inbound Shipment - " in web browser

@wip @public
Scenario: Web Open Copy Inbound Orders to Shipment Window
#############################################################
# Description: Selects the Copy Inbound Orders to Shipment option from the Actions dropdown.
# MSQL Files:
#	None
# Inputs:
#	Required:
#       None
#	Optional:
#		None
# Outputs:
# 		None             
#############################################################

Given I "click Actions dropdown"
	Then I assign variable "elt" by combining "xPath://div[starts-with(@id, 'toolbar-')]/descendant::span[text() = 'Actions']/ancestor::a[starts-with(@id, 'button-') and contains(@class, 'x-btn')]"
	And I click element $elt in web browser within $max_response seconds
	And I wait $wait_med seconds

And I "select Copy Inbound Orders to Shipment"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id, 'menuitem-') and text() = 'Copy Inbound Orders to Shipment']"
	And I click element $elt in web browser within $max_response seconds

And I "verify Copy Inbound Orders to Shipment window appears"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id, 'wm-inboundloads-inboundloads-components-copyinboundapp')]"
	Once I see element $elt in web browser

@wip @public
Scenario: Web Inbound Shipments Search for Inbound Shipment Number
#############################################################
# Description: From inbound shipment screen, use search box to 
# find shipment from the inbound shipment number.
# MSQL Files:
#	None
# Inputs:
#	Required:
#       trknum - Name of the Shipment
#	Optional:
#		None
# Outputs:
# 		None             
#############################################################

Given I "am on the Inbound Shipment screen"
	Once I see "Inbound Shipments" in web browser

And I "search for trailer/shipment with the Inbound Shipment search box"
	Then I assign "Inbound Shipment Number" to variable "component_to_search_for"
	And I assign $trknum to variable "string_to_search_for"
	And I execute scenario "Web Component Search"
    
And I unassign variables "component_to_search_for,string_to_search_for"    

@wip @public
Scenario: Web Search For Order To Copy
#############################################################
# Description: From copy order window, search for a given order.
# MSQL Files:
#	None
# Inputs:
#	Required:
#       invnum - inventory number
#	Optional:
#		None
# Outputs:
# 		None             
#############################################################

Given I "am on the Copy Inbound Orders to Shipment window"
	Once I see "Copy Inbound Orders to Shipment" in web browser

And I "search for the order in the copy order search box"
	Given I assign variable "order_search" by combining "Order = " $invnum
	And I assign variable "elt" by combining $xPath ""
	And I assign variable "elt" by combining $elt "//div[contains(@id, 'copyinboundapp')]"
	And I assign variable "elt" by combining $elt "/descendant::table[starts-with(@id,'rpFilterComboBox-') and contains(@id,'triggerWrap')]"
	And I assign variable "elt" by combining $elt "//input[contains(@id,'-inputEl')]"
	And I assign $elt to variable "order_filter"
    
	When I click element $order_filter in web browser within $max_response seconds 
	And I type $order_search in  element $order_filter in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
    
    And I unassign variables "order_search,order_filter,elt"   

@wip @public
Scenario: Web Copy Order To Shipment
#############################################################
# Description: Selects the order in the Copy Order to Shipment window and then adds it to the shipment.
# MSQL Files:
#	None
# Inputs:
#	Required:
#       invnum - inventory number
#	Optional:
#		None
# Outputs:
# 		None             
#############################################################

Given I "am on the Copy Inbound Orders to Shipment window"
	Once I see "Copy Inbound Orders to Shipment" in web browser

And I "select the order to copy"
	Then I assign variable "elt" by combining "xPath://div[contains(@id, 'copyinboundapp')]/descendant::div[@class='x-grid-row-checker']"
	And I click element $elt in web browser within $max_response seconds

And I "add the order to the shipment"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id, 'button-') and text() = 'Add to Shipment']/ancestor::a[starts-with(@id, 'button-') and contains(@class, 'x-btn')]"
	And I click element $elt in web browser within $max_response seconds

And I "verify the order was added to the shipment table"
	Then I assign variable "elt" by combining "xPath://div[contains(@class, 'wm-inboundload-record')]/descendant::td[text() = '" $invnum "']"
	Once I see element $elt in web browser

@wip @public
Scenario: Validate Inbound Order Copied to Shipment
#############################################################
# Description: Validates the Inbound Order was copied to the Shipment in the database.
# MSQL Files:
#	validate_inbound_order_in_shipment.msql
# Inputs:
# 	Required:
#		trknum - Name of the Shipment
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "validate the Inbound Order was created in the database"
	And I assign "validate_inbound_order_in_shipment.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
    	Then I echo "Inbound Order was copied into the Shipment"
    Else I fail step with error message "ERROR: Inbound Order failed to be copied into the Shipment"
    Endif
    
@wip @public
Scenario: Web Assign Inbound Shipment
#############################################################
# Description: Inbound Shipment is assigned to Transport Equipment
# MSQL Files:
#	None
# Inputs:
#	Required:
#		trlr_num - Name of the Transport Equipment
#		trknum - Name of the Shipment
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I execute scenario "Create local xPaths"

And I "isolate the desired equipment by clicking the combo box and entering the trailer ID"
	Then I execute scenario "Web Inbound Shipments Search for Inbound Shipment Number"

And I "select the inbound shipment I want from the Inbound Shipments page"
	Given I assign variable "shipment" by combining "text:" $trknum
	When I click element $shipment in web browser within $max_response seconds
 
And I "select the 'Actions' drop-down"
	When I click element $inbound_shipments_action_button in web browser within $max_response seconds 
 
When I "select the 'Receive Inventory' choice from the 'Actions' drop-down"
	Given I assign "Receive Inventory" to variable "text"
	And I execute scenario "Web xPath for Span Text"
	When I click element $elt in web browser within $max_response seconds 

And I "select 'Modify Inbound Shipment' from the list"
	Then I click element $modify_inbound_shipment in web browser within $max_response seconds 
    
And I "select Transport Equipment"
	Then I click element "name:trailerId" in web browser within $max_response seconds
	And I type $trlr_num in web browser
	And I assign variable "elt" by combining "xPath://div[text()='" $trlr_num "']"
	And I click element $elt in web browser within $max_response seconds
    
And I "save the Inbound Shipment"
	When I scroll to element $save_inbound_shipment in web browser within $max_response seconds
	Then I click element $save_inbound_shipment in web browser within $max_response seconds
    
@wip @public
Scenario: Validate Trailer Assign to Shipment
#############################################################
# Description: Validate a trailer was sssigned to a shipment
# MSQL Files:
#	validate_trailer_assign_to_shipment.msql
# Inputs:
# 	Required:
#		trknum - Name of the Shipment
#	Optional:
#		None
# Outputs:
# 	None
#############################################################

Given I "Validate a trailer was assigned to a shipment"
	Then I assign "validate_trailer_assign_to_shipment.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
    If I verify MOCA status is 0
    	Then I assign row 0 column "trlr_id" to variable "trlr_id"
		If I verify text $trlr_id is not equal to "" ignoring case
			Then I echo "Trailer has been assigned to shipment successfully"
		Else I fail step with error message "ERROR: Trailer was not assigned to shipment"    
		EndIf
	Else I fail step with error message "ERROR: validate_trailer_assign_to_shipment.msql failed"
	EndIf
    
#############################################################
# Private Scenarios:
#   Create local xPaths - helper scenario to create xPaths for this utility
#	Web Dock Door Search for Trailer - Search for Dock Door in search box
#	Web Receiving Perform Receiving and Putaway - Perform transport workflow, receive, and putaway actions
#	Web Process Receiving Tab - Process the Receiving Tab when performing Receive action
#	Web Process Putaway Tab - Process the Putaway Tab when performing Receive action
#	Web Receiving Verify OSB TAB States - validate the states for Short, Over, and Damaged
#	Web Enter Supplier Quality Issue Information - Enters the Supplier Quality Issue Information.
#	Web Enter Carrier Quality Issue Information - Enters the Carrier Quality Issue Information.
#	Validate Supplier Inbound Quality Issue - Validates the Supplier Inbound Quality Issue in the database.
#	Validate Carrier Inbound Quality Issue - Validates the Carrier Inbound Quality Issue in the database.
#	Web Process Serialization - Look to see if serialization is required and process serial numbers
#	Web Receiving Add Line to Order - Add line to a created order
#############################################################

@wip @private
Scenario: Web Receiving Add Line to Order
#############################################################
# Description: Adds a line to a created order
# MSQL Files:
#	None
# Inputs:
#	Required:
#		prtnum - The part number
#		expqty - The expected quantity
#		supnum - The Supplier number
#		rcvsts - The receive status
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "am on Add Inbound Order Line Screen"
	Once I see "Line Number" in web browser
	Once I see "Sub Line" in web browser
    
And I "fill in part (Item) information"
	Then I click element "name:itemNumber" in web browser within $max_response seconds
	And I type $prtnum in element "name:itemNumber" in web browser within $max_response seconds
	And I assign variable "elt" by combining "xPath://div[contains(text(),'" $prtnum "')]"
    And I click element $elt in web browser within $max_response seconds

And I "fill in expected quantity information"
	Then I type $expqty in element "name:expectedQuantity" in web browser within $max_response seconds
    
And I "fill in receive status"
	Then I click element "name:receiveStatus" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	And I assign variable "elt" by combining "xPath://li[text()='" $rcvsts "']"
    And I click element $elt in web browser within $max_response seconds
    
And I "click off Add Next Line"
	Then I assign variable "elt" by combining "xPath://label[text()='Add Next Line']"
    And I click element $elt in web browser within $max_response seconds
    
And I "click Save"
	Then I assign variable "elt" by combining "xPath://span[text()='Save']/.."
    And I click element $elt in web browser within $max_response seconds

@wip @private
Scenario: Web Complete Inbound Shipment
############################################################
# Description: Traverse to OSD/Complete Shipment button and 
# Complete Shipment
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		trlr_num - trailer number
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "verify I am on proper screen"
	Once I see "Inbound Shipments" in web browser
    
And I "select the trailer link in the Inbound Shipment screen"
	Then I assign variable "elt" by combining "xPath://span[@class='rpux-link-grid-column-link' and text()='" $trlr_num "']"
 	And I click element $elt in web browser within $max_response seconds
    
And I "Click on the OSD/Complete button"
	Then I assign variable "elt" by combining "xPath://span[text()='OSD/Complete']/..//span[2]"
	And I click element $elt in web browser within $max_response seconds
	Once I see "All LPNs" in web browser
    
And I "complete the shipment"
    Then I execute scenario "Web Receiving Complete Shipment"

@wip @private
Scenario: Web Receiving Verify OSB TAB States
#############################################################
# Description: After a Receive and Putaway for Under, Over,
# and Damage product receive conditions and on OSD Tab, validate the
# States for Short, Over, and Damaged by clicking into each TAB
# and validating the screens giving information about state.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		trlr_num - trailer number
#		prtnum - part number
#		rcvqty - quantity that was received
#		expqty - expected quantity
#		rec_loc - location where product was directed during putaway
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "verify I am on proper screen"
	Once I see "Inbound Shipments" in web browser
    Once I see "OSD" in web browser

And I "set numeric quantities to compare against"
	if I verify variable "damaged_flag" is assigned
	And I verify text $damaged_flag is equal to "TRUE" ignoring case
    	Then I assign $rcvqty to variable "damage_qty"
    Else I assign "0" to variable "damage_qty"
    Endif
    
    Then I convert string variable "damage_qty" to integer variable "damage_qty_num"
    And I convert string variable "rcvqty" to integer variable "rcvqty_num"
    And I convert string variable "expqty" to integer variable "expqty_num"

And I "verify Over state (TAB data)"
	Then I assign variable "elt" by combining "xPath://span[text()='Over']/ancestor::a"
	And I click element $elt in web browser within $max_response seconds
    
	if I verify number $damage_qty_num is greater than 0
		Then I assign variable "exp_result" by combining "0 expected | " $rcvqty " over | Damaged Product"
		Once I see $exp_result in web browser
		Once I see $prtnum in web browser
	EndIf
    
	if I verify number $rcvqty_num is greater than $expqty_num
    	Then I assign $rcvqty to variable "over_by"
        And I convert string variable "over_by" to integer variable "over_by_num"
        And I decrease variable "over_by_num" by $expqty_num
        And I convert number variable "over_by_num" to string variable "over_by"
    	Then I assign variable "exp_result" by combining $expqty " expected | " $over_by " over | Available"
		Once I see $exp_result in web browser
		Once I see $prtnum in web browser
	EndIf
    
	if I verify number $rcvqty_num is less than $expqty_num
		Once I see "No Planned Inbound Order Lines affected" in web browser
	EndIf
    
And I "verify Short state (TAB data)"
    Then I assign variable "elt" by combining "xPath://span[text()='Short']/ancestor::a"
	And I click element $elt in web browser within $max_response seconds
    
    if I verify number $damage_qty_num is greater than 0
		Then I assign variable "exp_result" by combining $rcvqty " expected | " $rcvqty " short | Available"
		Once I see $exp_result in web browser
		Once I see $prtnum in web browser
	EndIf
    
	if I verify number $rcvqty_num is less than $expqty_num
    	Then I assign $expqty to variable "under_by"
        And I convert string variable "under_by" to integer variable "under_by_num"
        And I decrease variable "under_by_num" by $rcvqty_num
        And I convert number variable "under_by_num" to string variable "under_by"
    	Then I assign variable "exp_result" by combining $expqty " expected | " $under_by " short | Available"
		Once I see $exp_result in web browser
 		Once I see $prtnum in web browser
	EndIf
    
    if I verify number $rcvqty_num is greater than $expqty_num
    	Once I see "No Planned Inbound Order Lines affected" in web browser
    EndIf

And I "verify Damaged state (TAB data)"
    Then I assign variable "elt" by combining "xPath://span[text()='Damaged']/ancestor::a"
	And I click element $elt in web browser within $max_response seconds
    
    if I verify number $damage_qty_num is greater than 0
		Then I assign variable "exp_result" by combining "0 expected | " $rcvqty " damaged | Damaged Product"
		Once I see $exp_result in web browser
		Once I see $prtnum in web browser
	Else I "see no planned inbound order lines affected"
    	Once I see "No Planned Inbound Order Lines affected" in web browser
	EndIf
    
And I unassign variables "exp_result,damage_qty_num,damage_qty,rcvqty_num,expqty_num"

@wip @private
Scenario: Web Receiving Perform Receiving and Putaway
#############################################################
# Description: Perform Receive and Putaway including
# transport workflow, receive, and putaway actions.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		trlr_num - trailer number
#		rcvqty - quantity that was received
#		rec_loc - location where product was directed during putaway
#		asn_flag - TRUE|FALSE to descern if this is an ASN or non-ASN receive condition
#		uom - Unit of Measure (Case|Each|Pallet)
#	Optional:
#		lodnum - load number to use for receiving
#		lotnum - lot number
#		revlvl - revision level
# Outputs:
#	None
#############################################################

Given I "am on the Inbound Shipment screen"
	Once I see "Inbound Shipments" in web browser

And I "select the 'Actions' drop-down"
	When I click element $inbound_shipments_action_button in web browser within $max_response seconds 
 
When I "select the 'Receive Inventory' choice from the 'Actions' drop-down"
	Given I assign "Receive Inventory" to variable "text"
	And I execute scenario "Web xPath for Span Text"
	When I click element $elt in web browser within $max_response seconds 

And I "process the trailer workflow if necessary"
	If I see "Transport Equipment Workflow" in web browser within $wait_med seconds 
		Then I execute scenario "Web Perform Transport Equipment Workflow Safety Check Pass"
		Once I see "Inbound Shipments" in web browser

		And I "select the Receive Inventory 'Actions' drop-down"
			When I click element $inbound_shipments_action_button in web browser within $max_response seconds 
	
			Then I "select the 'Receive Inventory' choice from the 'Actions' drop-down"
				Given I assign "Receive Inventory" to variable "text"
				And I execute scenario "Web xPath for Span Text"
				When I click element $elt in web browser within $max_response seconds
	EndIf
        
And I "process the receive TAB and receive goods and handle serialization"
	And I execute scenario "Web Process Receiving Tab"
    
And I "process the putaway TAB and putaway goods"
	And I execute scenario "Web Process Putway Tab"
 
And I "close the 'Putaway/Receive' screen by clicking the 'X' in the upper right corner"
	Given I assign variable "elt" by combining $xPath "//i[starts-with(@id,'tool-') and contains(@id,'-toolEl')]"
	When I click element $elt in web browser within $max_response seconds
    
Given I "am back to the Inbound Shipment screen"
	Once I see "Inbound Shipments" in web browser

@wip @prviate
Scenario: Web Process Receiving Tab
#############################################################
# Description: Process the Web Receiving TAB that is started 
# from Actions->Receive Intentory option
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		trlr_num - trailer number
#		rcvqty - quantity that was received
#		asn_flag - TRUE|FALSE to descern if this is an ASN or non-ASN receive condition
#		uom - Unit of Measure (Case|Each|Pallet)
#	Optional:
#		lodnum - load number to use for receiving
#		lotnum - lot number
#		revlvl - revision level
# Outputs:
#	None
#############################################################

And I "should be on Receiving and Putaway screen"
	Once I see "Receiving" in web browser
    Once I see "Putaway" in web browser

And I "go to the page where I can receive the goods"
And I "fill in fields that are both required and optional (based on inputs)"
	And I click element "className:table-container" in web browser within $max_response seconds 

And I "check for ASN flag is set and skip receiving TAB if it is"
	Then I assign "TRUE" to variable "perform_receive"
	If I verify variable "asn_flag" is assigned
    And I verify text $asn_flag is equal to "TRUE" ignoring case
		Then I assign "FALSE" to variable "perform_receive"
	EndIf
    
	If I verify text $perform_receive is equal to "TRUE"
		Then I "input the receive quantity and wait for values to register"
			And I type $rcvqty in element "name:quantity" in web browser within $max_response seconds
            
		And I "set unit of measure for receive if requested"
			If I verify variable "uom" is assigned
    		And I verify text $uom is not equal to ""
      			Then I double click element "name:uomCode" in web browser within $max_response seconds
    			And I type $uom in element "name:uomCode" in web browser within $max_response seconds
        		And I assign variable "elt" by combining "xPath://li[text()='" $uom "']"
				And I click element $elt in web browser within $max_response seconds
			EndIF
    
		And I "set lodnum for receive if requested"
			If I verify variable "lodnum" is assigned
    		And I verify text $lodnum is not equal to ""
				Then I type $lodnum in element "name:loadNumber" in web browser within $max_response seconds
			EndIf

		And I "check to see if we want to mark goods as damaged"
			If I verify variable "damaged_flag" is assigned
    		And I verify text $damaged_flag is equal to "TRUE" ignoring case
    			Then I double click element "name:inventoryStatus" in web browser within $max_response seconds
    			And I type "Damaged Product" in element "name:inventoryStatus" in web browser within $max_response seconds
        		And I assign variable "elt" by combining "xPath://li[text()='Damaged Product']"
				And I click element $elt in web browser within $max_response seconds
			EndIf

		And I "process lot information (if needed)"
			If I verify variable "lotnum" is assigned
			And I verify text $lotnum is not equal to ""
				If I see element "name:lotNumber" in web browser within $wait_med seconds
					Then I type $lotnum in element "name:lotNumber" in web browser within $max_response seconds
				EndIf
			EndIf

		And I "process revision level (if needed)"
			If I verify variable "revlvl" is assigned
			And I verify text $revlvl is not equal to ""
				If I see element "name:revisionLevel" in web browser within $wait_med seconds
					Then I type $revlvl in element "name:revisionLevel" in web browser within $max_response seconds
				EndIf
			EndIf
 
		And I "click the 'Receive' button on the bottom"
			When I click element "xPath://span[text()='Receive']//.." in web browser within $max_response seconds
    
		And I "process serialization if required/configured"
			Then I execute scenario "Web Process Serialization"
            
		And I "see 100% received if expected quantity is same as receive quantity"
			if I verify text $expqty is equal to $rcvqty
				Once I see "100%" in web browser
			EndIf
	EndIf
    
@wip @prviate
Scenario: Web Process Putway Tab
#############################################################
# Description: Process the Web Putaway TAB that is started 
# from Actions->Receive Intentory option
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		rec_loc - receiving location
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "should be on Receiving and Putaway screen"
	Once I see "Receiving" in web browser
    Once I see "Putaway" in web browser

Then I "select the 'Putaway' button on the top"
	When I click element "xPath://span[text()='Putaway']//.." in web browser within $max_response seconds 
 
And I "select the items to put away (i.e. all of them)"
	When I click element $putaway_check_box in web browser within $max_response seconds
    
And I "select the 'Move Immediately' radio button"
	Given I assign "xPath://*[@id=(//label[text()='Move Immediately']/@for)]" to variable "elt"
	When I click element $elt in web browser within $max_response seconds 
    
And I "specify the receiving location (if specified)"
	if I verify variable "rec_loc" is assigned
	And I verify text $rec_loc is not equal to ""
		Then I double click element "name:userSelectedLocation" in web browser within $max_response seconds
    	And I type $rec_loc in element "name:userSelectedLocation" in web browser within $max_response seconds
        And I assign variable "elt" by combining "xPath://li[text()='" $rec_loc "']"
		And I click element $elt in web browser within $max_response seconds
	EndIf
 
And I "press the 'Putaway' button on the very bottom to complete the putaway action"
	When I click element $putaway_button in web browser within $max_response seconds 

And I "wait for WMS to put the stuff away. There is no acknowledgement other than it goes away" which can take between $wait_long seconds and $max_response seconds

@wip @private
Scenario: Web Process Serialization
#############################################################
# Description: Look to see if serialization is required for
# this receive and process the screen for entry of serial numbers
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

Given I "should be on Receiving and Putaway screen"
	Once I see "Receiving" in web browser

And I "perform serialization if applicable"
	If I see "Serial Numbers" in web browser within $wait_long seconds 
		Then I execute scenario "Get Item Serialization Type"
		If I verify text $serialization_type is equal to "CRDL_TO_GRAVE"
			Then I execute scenario "Web Scan Serial Number Cradle to Grave Receiving"
		ElsIf I verify text $serialization_type is equal to "OUTCAP_ONLY"
		Else I fail step with error message "ERROR: Serial Number screen seen, but serialization type cannot be determined"
		EndIf
	EndIf

@wip @private
Scenario: Web Dock Door Search for Trailer
#############################################################
# Description: Enter dock door in the search box and search by locations
# MSQL Files:
#	None
# Inputs:
#	Required:
#       yard_loc - Receiving Dock Door
#	Optional:
#		None
# Outputs:
# 		None             
#############################################################

Given I "search for trailer relative to dock door with search box"
	Then I assign "Location" to variable "component_to_search_for"
	And I assign $yard_loc to variable "string_to_search_for"
	And I execute scenario "Web Component Search"

And I unassign variables "component_to_search_for,string_to_search_for"

@wip @private
Scenario: Create local xPaths
#############################################################
# Description: Create xpath variables for use in this utility
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		trlr_num - trailer number
# Outputs:
#	None
#############################################################

Given I "create an xPath to the trailer combo box"
	Then I assign variable "elt" by combining $xPath ""
	And I assign variable "elt" by combining $elt "//div[starts-with(@id,'rpFilterableGrid')"
	And I assign variable "elt" by combining $elt " and contains(@id,'_header')]"
	And I assign variable "elt" by combining $elt "//div[@class='rp-filter-combo-wrap']"
	And I assign variable "elt" by combining $elt "//input[@role='combobox']"
	When I assign $elt to variable "trailer_combo_box"

And I "create an xPath to the Inbound Shipments 'Action' button"
	Then I assign variable "elt" by combining $xPath ""
	And I assign variable "elt" by combining $elt "//div[starts-with(@id,'container-') and contains(@id,'-innerCt')]"
	And I assign variable "elt" by combining $elt "//span[text()='Actions']"
	And I assign variable "elt" by combining $elt "/..//span[2]"
	When I assign $elt to variable "inbound_shipments_action_button"

And I "create the xPath to the Putaway check box"
	Then I assign variable "elt" by combining $xPath ""
	And I assign variable "elt" by combining $elt "//span[text()='LPN']/..//..//.."
	And I assign variable "elt" by combining $elt "//span[starts-with(@id,'gridcolumn-')"
	And I assign variable "elt" by combining $elt " and contains(@id,'-textEl')]"
	When I assign $elt to variable "putaway_check_box"

And I "create the xPath for the Putaway button"
	Then I assign variable "elt" by combining $xPath ""
	And I assign variable "elt" by combining $elt "//div[@id='wm-inboundloads-inboundloads-components-receivingapp-body']"
	And I assign variable "elt" by combining $elt "//span[text()='Putaway']//.."
	When I assign $elt to variable "putaway_button"

And I "create an xPath to the Dock Door Actions drop-down"
	Then I assign variable "elt" by combining $xPath
	And I assign variable "elt" by combining $elt "//div[starts-with(@id,'wm-loaddetails')]"
	And I assign variable "elt" by combining $elt "//div[starts-with(@id,'wm-loaddetails-bottomcontrols-')"
	And I assign variable "elt" by combining $elt " and contains(@id,'-innerCt')]"
	And I assign variable "elt" by combining $elt "//span[text()='Actions']/..//span[2]"
	When I assign $elt to variable "dock_door_Actions_button"

And I "create an xPath to the Dock Door Close Equipment choice"
	Then I assign variable "elt" by combining $xPath ""
	And I assign variable "elt" by combining $elt "//span[text()='Close Equipment'"
	And I assign variable "elt" by combining $elt " and starts-with(@id,'menuitem-')"
	And I assign variable "elt" by combining $elt " and contains(@id,'-textEl')"
	And I assign variable "elt" by combining $elt "]"
	When I assign $elt to variable "close_equipment"

And I "create an xPath to the Dock Door Dispatch Equipment option"
	Then I assign variable "elt" by combining $xPath ""
	And I assign variable "elt" by combining $elt "//span[text()='Dispatch Equipment'"
	And I assign variable "elt" by combining $elt " and starts-with(@id,'menuitem-')"
	And I assign variable "elt" by combining $elt " and contains(@id,'-textEl')"
	And I assign variable "elt" by combining $elt "]"
	When I assign $elt to variable "dispatch_equipment"

And I "create the xPath to the Dock Door Dispatch Equipment choice"
	Then I assign variable "elt" by combining $xPath ""
	And I assign variable "elt" by combining $elt "//span[text()='Dispatch Equipment'"
	And I assign variable "elt" by combining $elt " and @class='x-menu-item-text'"
	And I assign variable "elt" by combining $elt "]"
	When I assign $elt to variable "dispatch_equipment_choice"

And I "create the xPath to the final Dispatch selection"
	Then I assign variable "elt" by combining $xPath ""
	And I assign variable "elt" by combining $elt "//span[text()='Dispatch'"
	And I assign variable "elt" by combining $elt " and @class='x-btn-inner x-btn-inner-center'"
	And I assign variable "elt" by combining $elt "]"
	And I assign variable "elt" by combining $elt "/..//span[2]"
	When I assign $elt to variable "final_dispatch"

And I "create an xPath to the Dock Door Unload All choice"
	Then I assign variable "elt" by combining $xPath ""
	And I assign variable "elt" by combining $elt "//span[text()='Unload All'"
	And I assign variable "elt" by combining $elt " and starts-with(@id,'menuitem-')"
	And I assign variable "elt" by combining $elt " and contains(@id,'-textEl')"
	And I assign variable "elt" by combining $elt "]"
	When I assign $elt to variable "unload_all_item"
    
And I "create an xPath to the Web Modify Inbound Shipment"
	Then I assign variable "elt" by combining $xPath ""
	And I assign variable "elt" by combining $elt "//span[starts-with(@id,'inboundLoadHeader_modifyaction-textEl')"
	And I assign variable "elt" by combining $elt " and text()='Modify Inbound Shipment'"
	And I assign variable "elt" by combining $elt "]"
	When I assign $elt to variable "modify_inbound_shipment"  
             
And I "create an xPath to Select Transport Equipment"
	If I verify variable "trlr_num" is assigned
    And I verify text $trlr_num is not equal to ""
		Then I assign variable "elt" by combining $xPath ""
		And I assign variable "elt" by combining $elt "//div[starts-with(@class,'x-grid-cell-inner ') and text()='"
		And I assign variable "elt" by combining $elt $trlr_num
		And I assign variable "elt" by combining $elt "']"
		When I assign $elt to variable "select_trlr"
	EndIf

And I "create an xPath to Save the Transport Equipment"
	Then I assign variable "elt" by combining $xPath ""
	And I assign variable "elt" by combining $elt "//span[starts-with(@class,'x-btn-inner x-btn-inner-center')"
	And I assign variable "elt" by combining $elt " and contains(text(),'Select')"
	And I assign variable "elt" by combining $elt "]/../span[2]"
	When I assign $elt to variable "save_transport_equipment" 
    
And I "create an xPath to Save Inbound Shipment"
	Then I assign variable "elt" by combining $xPath ""
	And I assign variable "elt" by combining $elt "//div[starts-with(@class,'x-container x-docked x-container-default x-docked-bottom x-container-docked-bottom x-container-default-docked-bottom x-box-layout-ct')]"
	And I assign variable "elt" by combining $elt "//span[starts-with(@id,'button-') and contains(@class,'x-btn-inner x-btn-inner-center') and contains(text(),'Save')]"
	And I assign variable "elt" by combining $elt "/../span[2]"
	When I assign $elt to variable "save_inbound_shipment"   	
	  
And I "create an xPath to Select Shipment"
	If I verify variable "trlr_num" is assigned
    And I verify text $trlr_num is not equal to ""
		Given I assign variable "elt" by combining $xPath ""
		And I assign variable "elt" by combining $elt "//span[starts-with(@id,'ext-gen') and text()='"
		And I assign variable "elt" by combining $elt $trlr_num
		And I assign variable "elt" by combining $elt "']"
		When I assign $elt to variable "select_shipment"
	EndIf
	
@wip @private
Scenario: Web Enter Supplier Quality Issue Information
#############################################################
# Description: Enters the Supplier Quality Issue Information.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		issue_rsn - The reason for the quality issue.
#		inbqty - The quantity of quality issues.
#		supnum - The supplier of the quality issue.
#		check_report_issue_screen - Validates the current screen for Report Quality Issue or Add Quality Issue
#	 Optional:
#		None
# Outputs:
# 	None
#############################################################

Given I "enter the Supplier Issue"

	If I verify variable "check_report_issue_screen" is assigned
		And I verify text $check_report_issue_screen is equal to "YES" ignoring case
		Then I "validate Report Quality Issue screen "
		Once I see "Report Quality Issue" in web browser
	Else I "validate Add Quality Issue screen "
		Once I see "Add Quality Issue" in web browser
	Endif

	Then I assign variable "elt" by combining "xPath://input[@name = 'supplierIssues']"
	Then I click element $elt in web browser within $max_response seconds
	And I type $issue_rsn in element $elt in web browser within $max_response seconds
	And I wait $wait_short seconds
	And I assign variable "elt" by combining "xPath://li[text()='" $issue_rsn "']"
	And I click element $elt in web browser within $max_response seconds

And I "enter the Supplier Quantity"
	Then I assign variable "elt" by combining "xPath://input[@name = 'supplierQuantity']"
	Then I click element $elt in web browser within $max_response seconds
	And I type $inbqty in element $elt in web browser within $max_response seconds

And I "enter the Supplier ID"
	Then I assign variable "elt" by combining "xPath://input[@name = 'supplier']"
	And I click element $elt in web browser within $max_response seconds
	And I type $supnum in element $elt in web browser within $max_response seconds
	And I wait $wait_short seconds
	And I assign variable "elt" by combining "xPath://li[text()='" $supnum "']"
	And I click element $elt in web browser within $max_response seconds

@wip @private
Scenario: Web Enter Carrier Quality Issue Information
#############################################################
# Description: Enters the Carrier Quality Issue Information.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		issue_rsn - The reason for the quality issue.
#		inbqty - The quantity of quality issues.
#		carcod - The carrier of the quality issue.
#		check_report_issue_screen - Validates the current screen for Report Quality Issue or Add Quality Issue
# 	Optional:
#		None
# Outputs:
# 	None
#############################################################

Given I "enter the Carrier Issue"

	If I verify variable "check_report_issue_screen" is assigned
		And I verify text $check_report_issue_screen is equal to "YES" ignoring case
		Then I "validate Report Quality Issue screen "
		Once I see "Report Quality Issue" in web browser
	Else I "validate Add Quality Issue screen "
		Once I see "Add Quality Issue" in web browser
	Endif

	Then I assign variable "elt" by combining "xPath://input[@name = 'carrierIssues']"
	Then I click element $elt in web browser within $max_response seconds
	And I type $issue_rsn in element $elt in web browser within $max_response seconds
    And I wait $wait_short seconds
	And I assign variable "elt" by combining "xPath://li[text()='" $issue_rsn "']"
    And I click element $elt in web browser within $max_response seconds

And I "enter the Carrier Quantity"
	Then I assign variable "elt" by combining "xPath://input[@name = 'carrierQuantity']"
	Then I click element $elt in web browser within $max_response seconds
	And I type $inbqty in element $elt in web browser within $max_response seconds

And I "enter the Carrier ID"
	Then I assign variable "elt" by combining "xPath://input[@name = 'carrier']"
	And I click element $elt in web browser within $max_response seconds
	And I type $carcod in element $elt in web browser within $max_response seconds
	And I wait $wait_short seconds
	And I assign variable "elt" by combining "xPath://li[text()='" $carcod "']"
    And I click element $elt in web browser within $max_response seconds

@wip @private
Scenario: Validate Supplier Inbound Quality Issue
#############################################################
# Description: Validates the Supplier Inbound Quality Issue in the database.
# MSQL Files:
#	validate_supplier_inbound_quality_issue.msql
# Inputs:
# 	Required:
#		inbqty - The quantity of quality issues.
#		ib_issue - The code for the type of quality issue.
#		supnum - The supplier of the quality issue.
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "validate the Inbound Order was created in the database"
	Then I assign "validate_supplier_inbound_quality_issue.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
    	Then I echo "Supplier Inbound Quality Issue was created."
    Else I fail step with error message "ERROR: Supplier Inbound Quality Issue failed to be created."
    Endif

@wip @private
Scenario: Validate Carrier Inbound Quality Issue
#############################################################
# Description: Validates the Carrier Inbound Quality Issue in the database.
# MSQL Files:
#	validate_carrier_inbound_quality_issue.msql
# Inputs:
# 	Required:
#		inbqty - The quantity of quality issues.
#		ib_issue - The code for the type of quality issue.
#		carcod - The carrier of the quality issue.
#############################################################

Given I "validate the Inbound Order was created in the database"
	Then I assign "validate_carrier_inbound_quality_issue.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
    	Then I echo "Carrier Inbound Quality Issue was created"
    Else I fail step with error message "ERROR: Carrier Inbound Quality Issue failed to be created"
    Endif
	
    
@wip @public
Scenario: Web Inbound Complete Shipment
#############################################################
# Description: This sceanrio will complete an Inbound Shipment in Web
# MSQL Files:
#	None
# Inputs:
#	Required:
#		trlr_num - trailer number
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I execute scenario "Create local xPaths"

And I "isolate the desired equipment by clicking the combo box and entering the trailer ID"
	Then I type $trlr_num in element $trailer_combo_box in web browser within $max_response seconds
	And I assign variable "elt" by combining "xPath://span[text()=' in Inbound Shipment Number']"
	When I click element $elt in web browser within $max_response seconds 
	And I press keys "ENTER" in web browser

And I "select the inbound shipment I want from the Inbound Shipments page"
	Then I click element $select_shipment in web browser within $max_response seconds

And I "select the OSD/Complete button"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id,button-) and text()='OSD/Complete']/../span[2]"
	And I click element $elt in web browser within $max_response seconds 
 
And I "select the Complete Inbound Shipment button"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id,button-) and text()='Complete Inbound Shipment']/../span[2]"
	Once I see element $elt in web browser
	Then I click element $elt in web browser within $max_response seconds  
  
@wip @public
Scenario: Web Receiving Dispatch Trailer Modes
#############################################################
# Description: This scenario will select Transport Equipment option leave_at_door, 
# turnaround, or dispatch option and press OK
# MSQL Files:
#	None
# Inputs:
#	Required:
#		trlr_option - what to do with trailer (leave_at_Door, turnaround, or dispatch)
#	Optional:
#		turnaround_carrier - If trlr_option is turnaround carrier to use
#		turnaround_location - If trlr_option is turnaround location to use
# Outputs:
#	None
#############################################################

Given I "select Transport Equipment option to leave_at_door, turnaround, or dispatch Option and press OK"  
	If I verify text $trlr_option is equal to "leave_at_door" ignoring case
		Then I assign variable "elt" by combining "xPath://label[starts-with(@id,'radiofield-') and text()='Leave equipment at door']/../input"
		And I click element $elt in web browser within $max_response seconds
        And I click element "xPath://span[starts-with(@id,button-) and text()='OK']/../span[2]" in web browser within $max_response seconds

		Then I "handle safety check if seen"
			If I see "Safety Check" in web browser within $wait_med seconds
				Then I execute scenario "Web Complete Trailer Safety Check"
			EndIf 

        And I see element "xPath://span[starts-with(@id,button-) and text()='Reopen']" in web browser within $max_response seconds
	Elsif I verify text $trlr_option is equal to "turnaround" ignoring case
		Then I assign variable "elt" by combining "xPath://label[starts-with(@id,'radiofield-') and text()='Turnaround equipment']/../input"
		When I click element $elt in web browser within $max_response seconds
        Then I click element "xPath://span[starts-with(@id,button-) and text()='OK']/../span[2]" in web browser within $max_response seconds

		And I "handle safety check if seen"
			If I see "Safety Check" in web browser within $wait_med seconds
				Then I execute scenario "Web Complete Trailer Safety Check"
			EndIf 
        
		Then I assign variable "elt" by combining "xPath://input[starts-with(@name,'carrierCode')]"
		And I double click element $elt in web browser within $max_response seconds
		And I type $turnaround_carrier in web browser
		And I assign variable "elt" by combining "xPath://li[text()='" $turnaround_carrier "']"
		And I click element $elt in web browser within $max_response seconds	
		
        Then I assign variable "elt" by combining "xPath://input[starts-with(@name,'location')]"
		And I click element $elt in web browser within $max_response seconds
		And I type $turnaround_location in web browser
		And I assign variable "elt" by combining "xPath://li[text()='" $turnaround_location "']"
		And I click element $elt in web browser within $max_response seconds	

        Then I assign variable "elt" by combining "xPath://label[starts-with(@id,'radiofield-') and text()='System moves equipment immediately']/../input"
		And I click element $elt in web browser within $max_response seconds
		
        Then I assign variable "elt" by combining "xPath://a[contains(@class,'x-btn')]//span[starts-with(@id,'button-') and text()='OK']/../span[2]"
        And I click element $elt in web browser within $max_response seconds
	Elsif I verify text $trlr_option is equal to "dispatch" ignoring case
		Then I click element "xPath://label[starts-with(@id,'radiofield-') and text()='Dispatch equipment']/../input" in web browser within $max_response seconds
        And I click element "xPath://span[starts-with(@id,'button-') and text()='OK']/../span[2]" in web browser within $max_response seconds

		Then I "handle safety check if seen"
			If I see "Safety Check" in web browser within $wait_med seconds
				Then I execute scenario "Web Complete Trailer Safety Check"
			EndIf 
            
        And I wait $wait_short seconds
        And I press keys "ENTER" in web browser
	Else I fail step with error message "ERROR: Select valid Transport Equipment option: leave_at_door, turnaround, or dispatch"
	EndIf
    
And I "verify Inbound Shipment is Completed or Not"  
	If I see element "xPath://div[starts-with(@id,'displayfield-') and text()='Inbound Shipment Complete']" in web browser within $max_response seconds
    	Then I echo "Inbound Shipment Completed Successfully"
	Else I fail step with error message "ERROR: Inbound Shipment Not Completed Successfully"	
    EndIf
		
@wip @public
Scenario: Web Open Receiving Work Queue Screen
#############################################################
# Description: Open the Receiving/Work Queue screen, given the Web UI is open.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		None
#	Optional:
#		None
# Outputs:
# 	None
#############################################################

Given I "open the Receiving/Work Queue screen"
	Then I assign "Work Queue" to variable "wms_screen_to_open"
	And I assign "Receiving" to variable "wms_parent_menu"
	And I execute scenario "Web Screen Search"
	Once I see "Work Queue" in web browser

And I unassign variables "wms_screen_to_open,wms_parent_menu"

@wip @public
Scenario: Web Open Report Quality Issue Screen
#############################################################
# Description: Selects report quality issue option from the actions drop-down on inbound shipment details screen
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		None
#	  Optional:
#		None
# Outputs:
# 	None
#############################################################

Given I "validate on the Inbound Shipment screen"
	Once I see "Inbound Shipment" in web browser

Then I "select report quality issue option from the actions drop-down"
	And I assign variable "elt" by combining "xPath://text()[.='Actions']/ancestor::a[1]"
	Once I see element $elt in web browser
	When I click 1 st element $elt in web browser within $max_response seconds

	Then I assign variable "elt" by combining "xPath://span[text()='Report Quality Issue']"
	Once I see element $elt in web browser
	When I click element $elt in web browser within $max_response seconds

@wip @public
Scenario: Web Add Report Quality Issues Information
#############################################################
# Description: Enters and saves the Quality Issue Information on Report Quality screen.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		issue_type - Specifies whether this was a Carrier or Supplier quality issue.
#		issue_rsn - The reason for the quality issue.
#		inbqty - The quantity of quality issues.
#		supnum - The supplier of the quality issue.
#		carcod - The carrier of the quality issue.
# 	Optional:
#		None
# Outputs:
# 	None
#############################################################

Given I "validate on the report quality issue screen"
	Once I see "Report Quality Issue" in web browser

	If I verify text $issue_type is equal to "Supplier" ignoring case
		Then I execute scenario "Web Enter Supplier Quality Issue Information"
	Elsif I verify text $issue_type is equal to "Carrier" ignoring case
		Then I execute scenario "Web Enter Carrier Quality Issue Information"
	Endif

And I "save the Quality Issue"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id, 'button-') and text()='Save']/ancestor::a[contains(@class, 'x-btn')]"
	And I click element $elt in web browser within $max_response seconds

@wip @public
Scenario: Web Validate Report Quality Issue Created
#############################################################
# Description: Validates a Quality Issue was created.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		issue_type - Specifies whether this was a Carrier or Supplier quality issue.
#		issue_rsn - The reason for the quality issue.
# 	Optional:
#		None
# Outputs:
# 	None
#############################################################

Given I "handle exception error, remove once corrected"
	If I see element "xPath://span[text()='Exception Occurred']" in web browser within $wait_med seconds
		Then I click element "xPath://text()[.='OK']/ancestor::a[1]" in web browser within $max_response seconds
		And I refresh web browser
	Endif

And I "validate inbound quality issues screen"
	Once I see "Inbound Quality Issues" in web browser

And I "click on quick filters"
	Then I assign variable "elt" by combining "xPath://text()[.='Quick Filters']/ancestor::a[1]"
	Once I see element $elt in web browser
	When I click element $elt in web browser within $max_response seconds

	If I verify text $issue_type is equal to "Supplier" ignoring case
		Then I assign variable "elt" by combining "xPath://td[text()='Supplier Issue']"
		Once I see element $elt in web browser
		When I click element $elt in web browser within $max_response seconds
	Elsif I verify text $issue_type is equal to "Carrier" ignoring case
		Then I assign variable "elt" by combining "xPath://td[text()='Carrier Issue']"
		Once I see element $elt in web browser
		When I click element $elt in web browser within $max_response seconds
	Endif

And I "validate Quality Issue was created"
	Then I assign variable "elt" by combining "xPath://span[contains(@class, 'rpux-link-grid-column-link') and text()='" $issue_rsn "']"
	Once I see element $elt in web browser

@wip @public
Scenario: Web Validate Reversed LPN on Inbound Shipment Details Screen
#############################################################
# Description: Validates a reversed LPN on Inbound Shipment details screen
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		trknum - Name of the Shipment
#		lpn - Reversed LPN details to validate.
# 	Optional:
#		None
# Outputs:
# 	None
#############################################################

Given I "click the 'View LPNs' button"
	Once I see element "xPath://text()[.='View LPNs']/ancestor::a[1]" in web browser
	And I click element "xPath://text()[.='View LPNs']/ancestor::a[1]" in web browser within $max_response seconds

Then I "validate inbound shipment details in the View LPNs Tab"
	Given I assign variable "elt" by combining $xPath ""
	And I assign variable "elt" by combining $elt "//span[text()='Inbound Shipment - " $trknum "']"
	Once I see element $elt in web browser

Then I "validate reversed LPN details in the View LPNs Tab"
	And I assign variable "elt" by combining "xPath://span[text()='" $lpn "']"
	If I do not see element $elt in web browser within $max_response seconds
		Then I echo "reversed LPN is not listed"
	Else I fail step with error message "ERROR: reversed LPN is listed and that is not expected"
	EndIf