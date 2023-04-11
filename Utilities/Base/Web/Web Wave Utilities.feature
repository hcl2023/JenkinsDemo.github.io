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
# Utility: Web Wave Utilities.feature
# 
# Functional Area: Allocation
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: WEB, MOCA
#
# Description:
# These utility scenarios perform wave planning and allocation functions in the Web
#
# Public Scenarios:
#	- Web Plan Wave - plans customer orders into a wave
#	- Get Wave Number - gets the planned wave number to use for allocation
#	- Web Allocate Wave - allocates the Wave
#	- Web Select Order - selects the order to plan
#	- Web Add Load and Plan Shipment - plans the order into a shipment and assigns a load
#	- Validate Shipment Planned - validates the shipment was planned
#	- Web Unallocate Wave - unallocate an allocated Wave in the Web
#	- Validate Wave Unallocated - check to see if Web was unallocated
#	- Web Navigate to Outbound Planner Waves and Picks - navigate to Outbound Planner Waves and Picks
#	- Web Navigate to Picking Waves and Picks - navigate to Picking Waves and Picks
#	- Web Cancel Short - Cancels a short from a wave
#	- Web Cancel and Reallocate Short - Cancels and reallocates a short on a wave
#	- Web Process Cancel Short - Proces a short on a wave
#	- Wait for Order Picks to Release - Wait up to 1 minutes for picks for an order to release
#	- Get Pick Totals for Order - get the number of picks and the total unit quantity of picks for an order
#	- Web Unplan Wave - This scenario will Unplan a Wave in the WebUI
#	- Validate Unplan Wave - This scenario will utilize a MSQL to verify successful unplan wave
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Web Wave Utilities

@wip @public
Scenario: Web Unallocate Wave
#############################################################
# Description: This scenario will unallocate a Wave in the Web
# MSQL Files:
#	None
# Inputs:
#	Required:
#		wave_num - Wave ID (schbat)
#	Optional:
#		None
# Outputs:
#	None         
#############################################################

Given I "am on the Waves and Picks screen"
	Once I see "Waves and Picks" in web browser

Then I "search for Wave"
	And I assign "wave" to variable "component_to_search_for"
    And I assign $wave_num to variable "string_to_search_for"
	When I execute scenario "Web Component Search"

And I "select the Wave from the grid"
	Then I assign variable "elt" by combining "xPath://tr[starts-with(@id,'gridview') and contains(@id,'" $wave_num "')]"
	And I click element $elt in web browser within $max_response seconds

And I "select the 'Actions' drop-down"
	Then I click element "xPath://span[contains(@id,'moreactionsbutton-') and text()='Actions']/.." in web browser within $max_response seconds 

And I "select the Unallocate Wave Menu Item"
	Then I click element "xPath://span[text()='Unallocate Wave']" in web browser within $max_response seconds 

And I "confirm I want to unallocate the Wave"
	Once I see "Are you sure you want to unallocate the selected wave?" in web browser
	Then I assign variable "elt" by combining "xPath://span[text()='OK']/.."
	And I click element $elt in web browser within $max_response seconds
    And I wait $wait_med seconds
    
And I "select the wave and verify"
	Then I assign variable "elt" by combining "text:" $wave_num
	And I click element $elt in web browser within $max_response seconds
    Once I see "0%" in web browser
    Once I see "Planned" in web browser

@wip @public
Scenario: Web Plan Wave
#############################################################
# Description: This scenario plans customer orders into a wave using the WEB
# MSQL Files:
#	None
# Inputs:
#	Required:
#		ordnum - Order Number
#		cstnum - Customer Number
#	Optional:
#		None
# Outputs:
#	None         
#############################################################

Given I "Use Search Box for Waves and Picks"
	Then I assign "Waves and Picks" to variable "wms_screen_to_open"
	When I execute scenario "Web Screen Search"
	Once I see element "xPath://span[text()='Waves and Picks']" in web browser

When I "am on Wave Screen, first step is to plan a wave"
	Given I assign variable "elt" by combining $xPath ""
	And I assign variable "elt" by combining $elt "//span[starts-with(@id,'moreactionsbutton-')"
	And I assign variable "elt" by combining $elt " and contains(@id,'-btnIconEl')]"
	And I assign $elt to variable "waves_Actions_button"
	When I click element $waves_Actions_button in web browser within $max_response seconds 
	And I click element "text:Plan Wave" in web browser within $max_response seconds 
	And I wait $wait_med seconds 
 
And I "am looking for all orders for customer"
	Given I assign variable "elt" by combining $xPath ""
	And I assign variable "elt" by combining $elt "//table[starts-with(@id,'customerlookup-')"
	And I assign variable "elt" by combining $elt " and contains(@id,'-triggerWrap')]"
	And I assign variable "elt" by combining $elt "//input"
	And I assign $elt to variable "cust_lookup"
	When I click element $cust_lookup in web browser within $max_response seconds 
	And I type $cstnum in element $cust_lookup in web browser within $max_response seconds
	And I wait $wait_med seconds 
	And I press keys TAB in web browser
	And I wait $wait_med seconds 
 
And I "press the Search button to fetch this customer's orders"
	Then I click element $xPath_span_Search_sibling in web browser within $max_response seconds 
	And I wait $wait_med seconds 
 
And I "select the order"
	Given I assign variable "order_id" by combining "text:" $ordnum
	When I click element $order_id in web browser within $max_response seconds 
	And I wait $wait_med seconds 
 
And I "press the button to Plan the Wave"
	Given I assign "Plan Wave" to variable "text"
	And I execute scenario "Web xPath for Span Text"
	And I execute scenario "Web xPath Add Sibling"
	When I assign $elt to variable "plan_wave_button"
	And I click element $plan_wave_button in web browser within $max_response seconds 
	And I wait $wait_med seconds 
 
And I "am on the Plan Wave confirmation dialog.  I only need to press 'OK' and wait for wave planning to end"
	Then I click element $xPath_span_OK_sibling in web browser within $max_response seconds 
	And I wait $wait_med seconds

@wip @public
Scenario: Get Wave Number
#############################################################
# Description: This scenario gets the planned wave number to use for allocation
# MSQL Files:
#	get_schbat_for_shipment.msql
# Inputs:
#	Required:
#		ordnum - Order Number
# 	Optional:
#		None
# Outputs:
#	schbat1 - schbat value renamed    
#############################################################

Given I "validate wave Planning is complete and next we need to get the schbat of wave just planned so that we can allocate"
	Then I assign "get_schbat_for_shipment.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	Then I verify MOCA status is 0
	And I assign row 0 column "schbat1" to variable "schbat1"
	And I echo $schbat1

@wip @public
Scenario: Web Allocate Wave
#############################################################
# Description: This scenario allocates the Wave in the Web
# MSQL Files:
#	None
# Inputs:
#	Required:
#		schbat1 - Wave number
#	Optional:
#		alc_destination_zone - Destination Zone
#		alc_staging_lane - Staging Lane
#		alc_consonsolidate_by - Consolidate by (default Outbound Order Number)
#		alc_imr_uoms - Comma seperate list of UOMs to be immediately released
# Outputs:
#	None                     
#############################################################

Given I "search by Wave Number"
	And I assign "wave" to variable "component_to_search_for"
    And I assign $schbat1 to variable "string_to_search_for"
	When I execute scenario "Web Component Search"
 
And I "select the wave from the list"
	Given I assign variable "search2" by combining "text:" $schbat1
	When I click element $search2 in web browser within $max_response seconds 
	And I wait $wait_med seconds 
 
And I "select the Actions menu drop-down"
	Given I assign variable "elt" by combining $xPath ""
	And I assign variable "elt" by combining $elt "//div[starts-with(@id,'wm-common-wavedetails-headerinfo')"
	And I assign variable "elt" by combining $elt " and contains(@id,'-innerCt')]"
	And I assign variable "elt" by combining $elt "//a[starts-with(@id,'moreactionsbutton-')]"
	And I assign variable "elt" by combining $elt "//span[starts-with(@id,'moreactionsbutton-')"
	And I assign variable "elt" by combining $elt " and contains(@id,'-btnIconEl')]"
	And I assign $elt to variable "actions_drop_down"
	When I click element $actions_drop_down in web browser within $max_response seconds 
 
When I "select the Allocate Wave choice"
	Given I assign variable "elt" by combining $xPath ""
	And I assign variable "elt" by combining $elt "//div[starts-with(@class,'x-panel rp-bound-menu rp-menu-btn-menu')]"
	And I assign variable "elt" by combining $elt "//div[starts-with(@id,'ext-comp-')"
	And I assign variable "elt" by combining $elt " and contains(@id,'-targetEl')]"
	And I assign variable "elt" by combining $elt "//span[text()='Allocate Wave']"
	And I assign $elt to variable "allocate_wave_choice"
	When I click element $allocate_wave_choice in web browser within $max_response seconds 
	And I wait $wait_med seconds 

And I "am in the Allocate Wave dialog box and I need to set destination zone"
	If I verify variable "alc_destination_zone" is assigned
    And I verify text $alc_destination_zone is not equal to ""
        Given I assign variable "elt" by combining $xPath ""
        And I assign variable "elt" by combining $elt "//div[starts-with(@id,'wm-common-waves-components-AllocateWaveWindow-')]"
        And I assign variable "elt" by combining $elt "//input[@name='destinationZone']"
        And I assign $elt to variable "destination_zone_in_wave"
        When I click element $destination_zone_in_wave in web browser within $max_response seconds 
        And I wait $wait_short seconds 
        Then I assign variable "dstzone_in_wave" by combining "text:" $alc_destination_zone
        Then I click element $dstzone_in_wave in web browser within $max_response seconds 
		And I wait $wait_med seconds 
    EndIf

And I "am in the Allocate Wave dialog box and I need to set staging lane"
	If I verify variable "alc_staging_lane" is assigned
    And I verify text $alc_staging_lane is not equal to ""
        Given I assign variable "elt" by combining $xPath ""
        And I assign variable "elt" by combining $elt "//div[starts-with(@id,'wm-common-waves-components-AllocateWaveWindow-')]"
        And I assign variable "elt" by combining $elt "//input[@name='stagingLane']"
        And I assign $elt to variable "staging_lane_in_wave"
        When I click element $staging_lane_in_wave in web browser within $max_response seconds 
        And I wait $wait_short seconds 
        Then I assign variable "stglane_in_wave" by combining "text:" $alc_staging_lane
        Then I click element $stglane_in_wave in web browser within $max_response seconds 
		And I wait $wait_med seconds 
    EndIf

And I "am in the Allocate Wave dialog box and I need to set Wave Priority"
	Then I assign "xPath://div[contains(@class,'wm-questiongrouper')]/descendant::input[contains(@id,'textfield-')]" to variable "wave_priority"
	If I verify variable "alc_wave_priority" is assigned
	And I verify text $alc_wave_priority is not equal to ""
		When I click element $wave_priority in web browser within $max_response seconds
		And I wait $wait_short seconds
		Then I type $alc_wave_priority in web browser
		And I wait $wait_med seconds
	Else I clear all text in element $wave_priority in web browser
	EndIf

And I "mark UOMs from comma seperated list for immediate release"
	If I verify variable "alc_imr_uoms" is assigned
    And I verify text $alc_imr_uoms is not equal to ""
    	Then I assign 0 to variable "uom_loop"
    	While I increase variable "uom_loop"
	    And I assign $uom_loop th item from "," delimited list $alc_imr_uoms to variable "imr_uom"
			When I assign variable "elt" by combining $xPath ""
			And I assign variable "elt" by combining $elt "//div[text()='" $imr_uom "']"
			If I verify number $uom_loop is equal to 1
				Then I click element $elt in web browser within $max_response seconds
			Else I "CTRL" click element $elt in web browser within $max_response seconds
			EndIf 
		EndWhile
	EndIf

And I "am in the Allocate Wave dialog box.  I first want to consolidate by my order number"
	Given I assign variable "elt" by combining $xPath ""
	And I assign variable "elt" by combining $elt "//div[starts-with(@id,'wm-common-waves-components-AllocateWaveWindow-')]"
	And I assign variable "elt" by combining $elt "//div[@class='x-container x-container-default wm-questiongrouper'][3]"
	And I assign variable "elt" by combining $elt "//input"
	And I assign $elt to variable "consolidate_order_in_wave"
	When I click element $consolidate_order_in_wave in web browser within $max_response seconds 
	And I wait $wait_short seconds 
  
And I "select Outbound Order Number or optional value in 'Consolidate by' field"
	If I verify variable "alc_consolidate_by" is assigned
    And I verify text $alc_consolidate_by is not equal to ""
    	Then I assign variable "consolidate_by_in_wave" by combining "text:" $alc_consolidate_by
    Else I assign "text:Outbound Order Number" to variable "consolidate_by_in_wave"
    EndIf
	Then I click element $consolidate_by_in_wave in web browser within $max_response seconds 
	And I wait $wait_med seconds 

And I "maximize the web browser and click the OK button"
	When I maximize web browser
	And I wait $wait_med seconds 
	And I click element $xPath_span_OK_sibling in web browser within $max_response seconds 
	And I wait $wait_med seconds 
 
And I "select the 'Wave' hyperlink in the upper left corner"
	Given I assign variable "elt" by combining $xPath ""
	And I assign variable "elt" by combining $elt "xPath://a[starts-with(@id,'rpHyperLinkBreadCrumb-')]"
	When I click element "xPath://a[starts-with(@id,'rpHyperLinkBreadCrumb-')]" in web browser within $max_response seconds 
	And I wait $wait_short seconds 
 
Then I "select the 'x' next to the 'Wave Status = Planned' indicator to display my wave"
	Given I assign variable "elt" by combining $xPath ""
	And I assign variable "elt" by combining $elt "//div[starts-with(@id,'rpCriteriaView-')"
	And I assign variable "elt" by combining $elt " and contains(@id,'-innerCt')]"
	And I assign variable "elt" by combining $elt "//span[starts-with(@id,'button-') and contains(@id,'-btnIconEl')]"
	And I assign $elt to variable "display_wave"
	When I click element $display_wave in web browser within $max_response seconds 
	And I wait $wait_long seconds

And I unassign variables "component_to_search_for,string_to_search_for"

@wip @public
Scenario: Web Select Order
#############################################################
# Description: This scenario selects the order to plan
# MSQL Files:
#	None
# Inputs:
#	Required:
#		ordnum - Order number
#	Optional:
#		None
# Outputs:
#	load_next_button
#	load_finish_button
#	or_button
#############################################################

Given I "navigate to outbound planner/outbound screen"
	Then I execute scenario "Web Navigate to Outbound Planner Outbound Screen"
    
And I "search for order"
	Then I assign "order" to variable "component_to_search_for"
    And I assign $ordnum to variable "string_to_search_for"
	And I execute scenario "Web Component Search"

And I "select the order"
	And I assign variable "order_id" by combining "text:" $ordnum
	Then I click element $order_id in web browser within $max_response seconds
    
And I "store xpaths for later use"
	Then I assign "xPath://span[text()='Next']//.." to variable "load_next_button"
	And I assign "xPath://span[text()='Finish']//.." to variable "load_finish_button"
	And I assign "xPath://span[starts-with(@id,'rpFilterConjunction')]//.." to variable "or_button"

And I unassign variables "component_to_search_for,string_to_search_for"

@wip @public
Scenario: Web Add Load and Plan Shipment
#############################################################
# Description: This scenario plans the order into a shipment and assigns a load
# MSQL Files:
#	None
# Inputs:
#	Required:
#		load - Load number. Maps to car_move.car_move_id
#		ordnum - Order number
#	Optional:
#		None
# Outputs:
#	ship_id - Shipment ID generated in planning   
#############################################################

Given I "choose Add Load to create the shipment"
	Then I assign variable "elt" by combining $xPath ""
	And I assign variable "elt" by combining $elt "//div[starts-with(@id,'toolbar')"
	And I assign variable "elt" by combining $elt " and contains(@id,'innerCt')]"
	And I assign variable "elt" by combining $elt "//span[text()='Actions']//.."
	And I assign $elt to variable "order_actions"
	Once I see element $order_actions in web browser 
	And I wait $wait_med seconds
	Then I click element $order_actions in web browser within $max_response seconds 
	And I click element "text:Add Load" in web browser within $max_response seconds

Then I "enter Load information and complete the load"
	And I type $load in element "name:carrierMoveId" in web browser within $max_response seconds 
	And I click element $load_next_button in web browser within $max_response seconds 
	Then I execute scenario "Validate Shipment Info"

Given I "remove filters, search by order, click on shipment and complete/finish load"
	Then I assign variable "elt" by combining "xPath://a[@data-qtip='Delete']"
	And I click element $elt in web browser within $max_response seconds

	Then I assign variable "elt" by combining "xPath://span[contains(@id,'assign-shipments')]/descendant::input[starts-with(@id,'rpFilterComboBox-') and contains(@type,'text')]"
	Once I see element $elt in web browser
	Then I click element $elt in web browser within $max_response seconds
	And I type "Order = " in element $elt in web browser
	And I type $ordnum in element $elt in web browser
	And I press keys "ENTER" in web browser

	Then I assign variable "ship_id_element" by combining "text:" $ship_id
	And I click element $ship_id_element in web browser within $max_response seconds 
	And I click element $load_finish_button in web browser within $max_response seconds 
	Once I see $ship_id in web browser

@wip @public
Scenario: Validate Shipment Planned
#############################################################
# Description: This scenario validates the shipment was planned
# MSQL Files:
#	check_stop_created.msql
# Inputs:
#	Required:
#		load - Load number. Maps to car_move.car_move_id
#	Optional:
#		None
# Outputs:
#	None            
#############################################################

Given I "validate the shipment was planned"
	And I assign "check_stop_created.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	Then I verify MOCA status is 0

@wip @public   
Scenario: Web Navigate to Outbound Planner Waves and Picks
#############################################################
# Description: Use Web Search to navigate to Outbount Planner/Waves and Picks screen
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		None
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "open the Outbound Plannner Waves and Picks screen"
	Then I assign "Waves and Picks" to variable "wms_screen_to_open"
	And I assign "Outbound Planner" to variable "wms_parent_menu"
	Then I execute scenario "Web Screen Search"

And I unassign variables "wms_screen_to_open,wms_parent_menu"

@wip @public    
Scenario: Web Navigate to Picking Waves and Picks
#############################################################
# Description: Use Web Search to navigate to Picking/Waves and Picks screen
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		None
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "open the Outbound Plannner screen"
	Then I assign "Waves and Picks" to variable "wms_screen_to_open"
	And I assign "Picking" to variable "wms_parent_menu"
	Then I execute scenario "Web Screen Search"

And I unassign variables "wms_screen_to_open,wms_parent_menu"
    
@wip @public
Scenario: Validate Wave Unallocated
#############################################################
# Description: This scenario validates the wave is unallocated
# (batsts = 'PLAN')
# MSQL Files:
#	check_wave_status.msql
# Inputs:
#	Required:
#		wave_num - WAVE number 
#	Optional:
#		None
# Outputs:
#	None            
#############################################################

Given I "validate the wave status is Plan (unallocated)"
	Then I assign "check_wave_status.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	Then I verify MOCA status is 0
	And I assign row 0 column "batsts" to variable "wave_status"
    
	If I verify text "Plan" is not equal to $wave_status ignoring case
		Then I fail step with error message "ERROR: Wave status is not the expected value of Plan"
	EndIf

And I unassign variable "wave_status"

@wip @public    
Scenario: Web Cancel Short
#############################################################
# Description: This scenario cancels a short from a wave.  The logic
#				assumes the wave screen is open and the wave is 
#				filtered.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		schbat1 - Wave number
#	Optional:
#		None
# Outputs:
#	None                     
#############################################################

Given I assign "Cancel Short" to variable "cancel_short_method"
Then I execute scenario "Web Process Cancel Short"

@wip @public
Scenario: Web Cancel and Reallocate Short
#############################################################
# Description: This scenario cancels and reallocates a short from a wave.  
#               The logic assumes the wave screen is open and the wave is 
#				filtered.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		wave_num - Wave number
#	Optional:
#		None
# Outputs:
#	None                   
#############################################################

Given I assign "Cancel Short and Reallocate" to variable "cancel_short_method"
Then I execute scenario "Web Process Cancel Short"

@wip @public
Scenario: Web Process Cancel Short
#############################################################
# Description: This scenario allocates the Wave in the Web
# MSQL Files:
#	None
# Inputs:
#	Required:
#		wave_num - Wave number
#		cancel_short_method - cancel code (Cancel Short and Reallocate or Cancel Short)
#	Optional:
#		None
# Outputs:
#	None                 
#############################################################

Given I "select the Wave from the grid"
	Then I assign variable "elt" by combining "xPath://tr[starts-with(@id,'gridview') and contains(@id,'" $wave_num "')]/td/div/span"
	And I click element $elt in web browser within $max_response seconds
	And I click element "xPath://span[starts-with(@id,'rpCountButton') and text()='Shorts']/ancestor::a" in web browser within $max_response seconds

And I "click on the first line for order in grid"
	Then I assign variable "elt" by combining "xPath://div[text()='" $ordnum "']"
	And I click element $elt in web browser within $max_response seconds   
    
And I "select the 'Actions' drop-down and select Choose Cancel and Reallocate"
	Then I click element "xPath://div[starts-with(@id,'outbound-short-grid-')]//span[text()='Actions']/.." in web browser within $max_response seconds 
	And I assign variable "elt" by combining "xPath://span[text()='" $cancel_short_method "']"
	And I click element $elt in web browser within $max_response seconds     

@wip @public
Scenario: Wait for Order Picks to Release
#############################################################
# Description: This scenario waits up to 1 minutes for picks for an order to release
# MSQL Files:
#	wait_for_order_picks_to_release.msql
# Inputs:
#	Required:
#		ordnum - Order number
#		client_id - Client Id
#	Optional:
#		None
# Outputs:
#	pcksts - pick status                
#############################################################

When I "run the command"
	Given I assign "wait_for_order_picks_to_release.msql" to variable "msql_file"
	And I execute scenario "Perform MSQL Execution"
	Then I verify MOCA status is 0
    
Then I "check the returned values"
	And I assign row 0 column "pcksts" to variable "pcksts"
	If I verify text $pcksts is equal to "R"
	Else I assign variable "error_message" by combining "ERROR: Picks for order " $ordnum " are still in " $pcksts " status.  Not Released"
		And I fail step with error message $error_message
	Endif

@wip @public
Scenario: Get Pick Totals for Order
#############################################################
# Description: This scenario will get the number of picks and 
#              the total unit quantity of picks for an order
# MSQL Files:
#	get_pick_totals_for_order.msql
# Inputs:
#	Required:
#		ordnum - Order number
#		client_id - Client Id
#	Optional:
#		None
# Outputs:
#	pick_count
#	pick_unit_count
#############################################################

When I "run the command"
	Given I assign "get_pick_totals_for_order.msql" to variable "msql_file"
	And I execute scenario "Perform MSQL Execution"
	Then I verify MOCA status is 0
    
Then I "check the returned values"
	And I assign row 0 column "pick_count" to variable "pick_count"
	And I assign row 0 column "pick_unit_count" to variable "pick_unit_count"
	
@wip @public
Scenario: Web Unplan Wave
#############################################################
# Description: This scenario will Unplan a Wave in the Web
# MSQL Files:
#	None
# Inputs:
#	Required:
#		wave_num - Wave ID (schbat)
#	Optional:
#		None
# Outputs:
#	None         
#############################################################

Given I "am on the Waves and Picks screen"
	Once I see "Waves and Picks" in web browser

Then I "search for Wave"
	And I assign "wave" to variable "component_to_search_for"
	And I assign $wave_num to variable "string_to_search_for"
	When I execute scenario "Web Component Search"

And I "select the Wave from the grid"
	Then I assign variable "elt" by combining "xPath://tr[starts-with(@id,'gridview') and contains(@id,'" $wave_num "')]"
	And I click element $elt in web browser within $max_response seconds

And I "select the 'Actions' drop-down"
	Then I click element "xPath://span[contains(@id,'moreactionsbutton-') and text()='Actions']/.." in web browser within $max_response seconds 

And I "select the Delete Wave from Actions drop-down"
	Then I click element "xPath://a[@class='x-menu-item-link x-menu-item-indent-no-separator']/descendant::span[text()='Delete Wave']" in web browser within $max_response seconds 

And I "confirm I want to delete the Wave"
	Once I see "Are you sure you want to delete the selected wave?" in web browser
	Then I assign variable "elt" by combining "xPath://div[starts-with(@id,'messagebox-') "
	And I assign variable "elt" by combining $elt "and contains(@id,'-toolbar-targetEl')]/a[2]/descendant::span[text()='OK']/../span[2]"
	Then I click element $elt in web browser within $max_response seconds
	And I wait $wait_med seconds	
    
@wip @public
Scenario: Validate Wave Unplan
#############################################################
# Description: This scenario will validate wave unplan was successful by using MOCA
# MSQL Files:
#	validate_wave_unplan.msql
# Inputs:
#	Required:
#		wave_num - Wave ID (schbat)
#	Optional:
#		None
# Outputs:
#	None         
#############################################################

	When I assign "validate_wave_unplan.msql" to variable "msql_file"
	Then I execute scenario "Perform MSQL Execution"
	And I verify MOCA status is 510

#############################################################
# Private Scenarios:
# None
#############################################################