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
# Utility: Web Inventory Utilities.feature
#
# Functional Area: Inventory
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: MOCA, WEB
# 
# Description:
# These Utility Scenarios perform actions specific to Web Inventory activities
#
# Public Scenarios:
# 	- Web Open Inventory Screen - Traverse to top-level search and then to Inventory screen
# 	- Web Open Inventory Counts Screen - Traverse to top-level search and then to Inventory/Counts screen
# 	- Web Open Inventory Adjustments Screen - Traverse to Inventory/Adjustments screen
# 	- Web Inventory Adjustment Add - Conduct an Inventory Add operation from the Location screen
# 	- Web Inventory Adjustment Delete - Conduct an Inventory Delete operation from the Location screen
# 	- Web Inventory Adjustment Change - Conduct an Inventory Adjustment with input provided by test case
# 	- Web Inventory Move - Perform the inventory move operation
#	- Web Inventory Create Count Batch - Create a Count Batch for a Range of storage locations
#	- Web Inventory Add or Release Hold - Perform either an Inventory Add or Release Hold operation
#	- Web Inventory Status Change - Perform a inventory status change operation
# 	- Web Inventory Navigate to Inventory LPN Display - Search for the LPN on Inventory screen and click on the LPN TAB
# 	- Web Inventory Move Enter Partial Quantity Move Information - If this is a partial move of inventory, then enter the appropriate quantity and destination LPN
# 	- Web Inventory Adjustment Check LPN Item Attributes in Location - Validate screen output after adjustment to input params
# 	- Web Inventory Adjustment Check Inventory Adjustment Approval Pending - Use MOCA/xpath to verify screen output
# 	- Web Inventory Adjustment Check LPN Deleted from Location - Check in the Location screen looking to make sure the lodnum (input) it not displayed
# 	- Web Inventory Adjustment Search for Location to Add Inventory on Inventory Screen - Search for the specified storage location on the Inventory screen
# 	- Web Inventory Adjustment Check that Inventory Adjustment was Successful - Verify that the UI from the Location screen has updated values after an inventory adjustment
# 	- Web Inventory Move Check LPN Moved to Location - Verify after the move operation completed from the UI
#	- Web Open the Inventory Outbound Screen - Traverse to top-level Search Box in Web UI.
#	- Web Select LPN to Modify - Selects the LPN in the Inventory table.
#	- Web Select Modify Inventory Attribute Action - Selects the Modify Inventory Attribute button.
#	- Web Select Relabel LPN Action - Selects the Relabel LPN button from the Action dropdown on the Inventory screen.
#	- Web Modify Inventory Lotnum - Changes and saves the lotnum on the inventory.
# 	- Web Error Location - changes the location status to error
# 	- Web Reset Location - resets the status to original
# 	- Web Location Status Change - changes the location status to error and resets the status to original.
#	- Web Inventory Relabel LPN - Enters and saves the new LPN into the Relabel LPN modal.
#	- Web Inventory Display - Search by lodnum or location and display specified inventory
#	- Web Inventory Location Display - display sepcified location in configuration/storage locations
#	- Web Open Storage Locations Screen  - navigate to the configuration/storage locations screen
#	- Web Inventory Adjust With Approval Limits - This Scenario will perform the Adjustments in the Inventory
#	- Web Approve Inventory Adjustments - This Scenario will perform the Approval for the Inventory Adjustments
#	- Validate Inventory Adjust With Approval Limits - This scenario will Validate Inventory Adjust With Approval Limits
# 	- Get Code Value from Code Description - Use MOCA call to get code value from description
#	- Create local xPaths - Create xpath variables for use in this utility
#	- Web Inventory Remove LPN from a Location - removes a LPN from a location 
#	- Validate Triggered Replenishment Generated - confirms that a triggered replenishment is generated for a location
#	- Web Reject Inventory Adjustments - perform the Rejection of a inventory adjustment
#	- Validate Top-off Replenishment Generated - confirms that a top-off replenishment is generated for a location
#	- Web Generate Top-off Replenishment For a Location - generates top-off replenishment for specified location
#	- Determine Inventory Adjustment Settings by Cost - Based on prtnum and it's associated unit cost, determine the proper settings for inventory adjustment.
#
# Assumptions:
# - This Feature Utility file uses the Web Interface
#
# Notes:
# None
############################################################ 
Feature: Web Inventory Utilities

@wip @public
Scenario: Determine Inventory Adjustment Settings by Cost
#############################################################
# Description: Based on prtnum and it's associated unit cost,
# determine the proper settings for inventory adjustment.
# MSQL Files:
#	get_prtnum_cost.msql
# Inputs:
#	Required:
#		prtnum - part number
#		adj_max_cost - maxiumum adjustment cost
#		untqty - quantity created of prtnum
#		adj_thresh - values include AT_LIMIT|LESS_THAN|GREATER_THAN
#	Optional:
#		None
# Outputs:
#	adj_qty - adjustment quantity to use based on prtnum and adj_thresh
#############################################################

Given I "determine the max allowable adjustment without approval"
    And I assign "get_prtnum_cost.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
    If I verify MOCA status is 0
		Then I assign row 0 column "untcst" to variable "prtnum_cost"
	Else I fail step with error message "ERROR: Could not determine unit cost for prtnum (or get_prtnum_cost.msql failed in general)"
	EndIf
    
    Then I convert string variable "prtnum_cost" to INTEGER variable "prtnum_cost_int"
	And I convert string variable "adj_max_cost" to INTEGER variable "adj_max_cost_int"
	And I convert string variable "untqty" to INTEGER variable "untqty_int"
    Then I execute Groovy "max_adjust_with_threshold_int = adj_max_cost_int / prtnum_cost_int"

And I "set adj_untqty to appropriate level based on adj_thresh setting"
	If I verify text $adj_thresh is equal to "MAX_ALLOWABLE" ignoring case
    	Then I execute Groovy "adj_untqty = (untqty_int + max_adjust_with_threshold_int) - 1"
		And I assign "FALSE" to variable "approval_needed"
	Elsif I verify text $adj_thresh is equal to "LESS_THAN" ignoring case
    	Then I execute Groovy "adj_untqty = (untqty_int + max_adjust_with_threshold_int) - 2"
		And I assign "FALSE" to variable "approval_needed"
    Elsif I verify text $adj_thresh is equal to "GREATER_THAN" ignoring case
		Then I execute Groovy "adj_untqty = (untqty_int + max_adjust_with_threshold_int) + 1"
		And I assign "TRUE" to variable "approval_needed"
	Else I fail step with error message "ERROR: Incorrect value for adj_thresh"
	EndIf

And I unassign variables "prtnum_cost_int,adj_max_cost_int,untqty_int,max_adjust_with_threshold_int"

@wip @public
Scenario: Web Inventory Location Display
#############################################################
# Description: Display a storage location from the Configuration / Warehouse /
# Locations / Storage Locations screen
# MSQL Files:
#	None
# Inputs:
#	Required:
#		stoloc - storage location
#	Optional:
#		generate_screenshot - flag to indicate screen shot should be taken
# Outputs:
#	None
#############################################################

Given I "search for storage location"
	Then I assign $stoloc to variable "string_to_search_for"
	And I assign "Location" to variable "component_to_search_for"
	And I execute scenario "Web Component Search"

And I "click on the location"
	Then I assign variable "elt" by combining "xPath://span[text()='" $stoloc "']"
	And I click element $elt in web browser within $max_response seconds

And I "verify a select set of fields on the screen versus data returned from MSQL"
	Then I assign $stoloc to variable "loc_to_use"
	Then I execute scenario "Get Storage Location Info from Location"
	Once I see $stoloc in web browser
	Once I copy text inside element "name:areaCode" in web browser to variable "ui_areaCode"
	Once I copy text inside element "name:aisle" in web browser to variable "ui_aisle"
	Once I copy text inside element "name:level" in web browser to variable "ui_level"
	Then I verify text $sto_area_code is equal to $ui_areaCode ignoring case
	And I verify text $sto_aisle_id is equal to $ui_aisle ignoring case
	And I verify text $sto_level is equal to $ui_level ignoring case

And I "take a web browser screen shot if requested"
	If I verify variable "generate_screenshot" is assigned
	And I verify text $generate_screenshot is equal to "TRUE" ignoring case
		Then I save web browser screenshot
	EndIf
	And I wait $screen_wait seconds

And I unassign variables "ui_areaCode,ui_aisle,ui_level,string_to_search_for,component_to_search_for"

@wip @public
Scenario: Web Open Storage Locations Screen
#############################################################
# Description: Navigate to Configuration / Warehouse / Locations /
# Storage Locations screen
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

Given I "Go to Search box and search for storage locations"
	Then I assign "Configuration" to variable "wms_parent_menu"
	And I assign "Storage Locations" to variable "wms_screen_to_open"
	When I execute scenario "Web Screen Search"
	And I wait $screen_wait seconds 
	Once I see "Storage Locations" in web browser

And I unassign variables "wms_parent_menu,wms_screen_to_open"

@wip @public
Scenario: Web Inventory Display
#############################################################
# Description: Search by lodnum or location and display specified inventory
# MSQL Files:
#	None
# Inputs:
#	Required:
#		lodnum - load number
#		stoloc - storage location
#		prtnum - part number
#	Optional:
#		generate_screenshot - flag to indicate screen shot should be taken
# Outputs:
#	None
#############################################################

Given I "search for LPN then stoloc"
	Then I assign $lodnum to variable "string_to_search_for"
	And I assign "LPN" to variable "component_to_search_for"
	And I execute scenario "Web Component Search"

And I "select the location"
	Then I assign variable "elt" by combining "xPath://span[text()='" $stoloc "']"
	And I click element $elt in web browser within $max_response seconds

And I "click on LPNs TAB"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id,'button') and text()='LPNs']/.."
	And I click element $elt in web browser within $max_response seconds
	Once I see $lodnum in web browser

And I "take a web browser screen shot if requested"
	If I verify variable "generate_screenshot" is assigned
	And I verify text $generate_screenshot is equal to "TRUE" ignoring case
		Then I save web browser screenshot
	EndIf

And I "click on the lodnum"
	Then I assign variable "elt" by combining "xPath://span[text()='" $lodnum "']"
	And I click element $elt in web browser within $max_response seconds
	Once I see $lodnum in web browser
    
And I "take a web browser screen shot if requested"
	If I verify variable "generate_screenshot" is assigned
	And I verify text $generate_screenshot is equal to "TRUE" ignoring case
		Then I save web browser screenshot
	EndIf

And I "click on lodnum (if the contains multiple LPNs)"
	Then I assign variable "elt" by combining "xPath://div[contains(@class, 'rp-plus-button')]"
	If I verify element $elt is clickable in web browser within $wait_med seconds
		Then I click element $elt in web browser within $max_response seconds
		Once I see $prtnum in web browser
		Once I see $stoloc in web browser
	EndIf
    
And I "take a web browser screen shot if requested"
	If I verify variable "generate_screenshot" is assigned
	And I verify text $generate_screenshot is equal to "TRUE" ignoring case
		Then I save web browser screenshot
	EndIf
    
And I "move back to main Inventory screen (two clicks on left arrow)"
	Then I assign variable "elt" by combining "xPath://div[contains(@class, 'breadcrumb-button-container')]"
	And I click element $elt in web browser within $max_response seconds
	And I wait $screen_wait seconds
	And I click element $elt in web browser within $max_response seconds
    
And I "search for the storage location and then the lodnum"
	Then I assign $stoloc to variable "string_to_search_for"
	And I assign "Location" to variable "component_to_search_for"
	And I execute scenario "Web Component Search"
    
And I "select the location"
	Then I assign variable "elt" by combining "xPath://span[text()='" $stoloc "']"
	And I click element $elt in web browser within $max_response seconds

And I "click on LPNs TAB"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id,'button') and text()='LPNs']/.."
	And I click element $elt in web browser within $max_response seconds
    Once I see $lodnum in web browser
    
And I "take a web browser screen shot if requested"
	If I verify variable "generate_screenshot" is assigned
	And I verify text $generate_screenshot is equal to "TRUE" ignoring case
		Then I save web browser screenshot
	EndIf

And I "click on the lodnum"
	Then I assign variable "elt" by combining "xPath://span[text()='" $lodnum "']"
	And I click element $elt in web browser within $max_response seconds
	Once I see $lodnum in web browser
    
And I "take a web browser screen shot if requested"
	If I verify variable "generate_screenshot" is assigned
	And I verify text $generate_screenshot is equal to "TRUE" ignoring case
		Then I save web browser screenshot
	EndIf

And I unassign variables "string_to_search_for,component_to_search_for"

@wip @public
Scenario: Web Open Inventory Screen
#############################################################
# Description: Traverse to top-level Search Box in Web UI
# and search/open the main Inventory screen
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

Given I "Go to Search box and enter Inventory"
	Then I assign "Inventory" to variable "wms_parent_menu"
	And I assign "Inventory" to variable "wms_screen_to_open"
	When I execute scenario "Web Screen Search"
	And I wait $wait_med seconds 
	Once I see "To find inventory" in web browser

And I unassign variables "wms_parent_menu,wms_screen_to_open"

@wip @public
Scenario: Web Open Inventory Adjustments Screen
#############################################################
# Description: Traverse to top-level Search Box in Web UI
# and search/open the Adjustments and the Inventory->Adjustment
# screen
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

Given I "Go to Search Box and Enter Adjustments"
	Then I assign "Adjustments" to variable "wms_screen_to_open"
	When I execute scenario "Web Screen Search"
	And I wait $wait_med seconds 
	Once I see "Approve" in web browser

And I unassign variables "wms_screen_to_open"

@wip @public
Scenario: Web Open Inventory Counts Screen
#############################################################
# Description: Traverse to top-level Search Box in Web UI
# and search/open the Inventory->Counts screen
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

Given I "Go to Search box and enter Inventory/Counts"
	Then I assign "Inventory" to variable "wms_parent_menu"
	And I assign "Counts" to variable "wms_screen_to_open"
	When I execute scenario "Web Screen Search"
	And I wait $wait_med seconds 
	Once I see "Counts" in web browser

And I unassign variables "wms_parent_menu,wms_screen_to_open"
	
@wip @public
Scenario: Web Inventory Adjustment Check LPN Item Attributes in Location
#############################################################
# Description: On completion of a Inventory Add Adjustment,
# verify the screen attributes versus test inputs
# MSQL Files:
#	None
# Inputs:
#	Required:
#		lodnum - Load number that was added 
#		prtnum - Valid part number that is assigned in your system
#		untqty - Inventory quantity that was added
#		ftpcod - Part footprint code for item being added
#		invsts - Inventory status. This needs to be a valid inventory status in your system
#		client_id - Client for the adjustment inventory
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "navigate to the LPNs grid on the Location Screen by clicking the LPNs button"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id,'button') and text()='LPNs']/.."
	And I click element $elt in web browser within $max_response seconds
	
And I "ensure the LPNs grid is displaying"
	Then I assign variable "elt" by combining "xPath://span[text()='Basics']"
	Once I see element $elt in web browser
	
And I "ensure the LPN is in the Location"
	If I verify variable "lodnum" is assigned
		Then I assign variable "elt_lodnum_row" by combining "xPath://tr[starts-with(@id,'rpMultiLevelGridView') and contains(@id,'" $lodnum "')]"
		Once I see element $elt_lodnum_row in web browser 
	Else I fail step with error message "ERROR: Load number (LPN) required for location check"
	EndIf

And I "ensure Prtnum is Assigned"
	If I verify variable "prtnum" is assigned
   		Then I assign variable "elt" by combining $elt_lodnum_row "//span[text()='" $prtnum "']"
   		Once I see element $elt in web browser
	EndIf
	
And I "validate the unit qty on the LPN"
	If I verify variable "untqty" is assigned
   		Then I assign variable "elt" by combining $elt_lodnum_row "//div[contains(text(),'" $untqty " ')]"
   		Once I see element $elt in web browser
	EndIf
	
And I "validate the footprint on the LPN"
	If I verify variable "ftpcod" is assigned
   		Then I assign variable "elt" by combining $elt_lodnum_row "//td[text()='" $ftpcod "']"
   		Once I see element $elt in web browser
	EndIf
	
And I "validate the inventory status on the LPN"
	If I verify variable "invsts" is assigned
   		Then I assign variable "elt" by combining $elt_lodnum_row "//div[text()='" $invsts "']"
   		Once I see element $elt in web browser
	EndIf
	
And I "validate the client ID on the LPN"
	If I verify variable "client_id" is assigned
   		Then I assign variable "elt" by combining $elt_lodnum_row "//div[text()='" $client_id "']"
   		Once I see element $elt in web browser
	Endif

@wip @public
Scenario: Web Inventory Adjustment Check Inventory Adjustment Approval Pending
#############################################################
# Description: Call MOCA script that gets the adjustment detail record for the load
# and use that in an xpath to verify screen output
# MSQL Files:
#	get_adj_dtlnum_from_lodnum.msql
# Inputs:
#	Required:
#		stoloc - Location where the adjustment will take place
#		lodnum - Load number that was added 
#		prtnum - Valid part number that is assigned in your system
#		check_adjqty - Denotes if approvals are required
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "open Inventory Adjustments screen"
	Then I execute Scenario "Web Open Inventory Adjustments Screen"
	
And I "get the Adjustment detail that is pending approval"
	Then I assign "get_adj_dtlnum_from_lodnum.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
		Then I assign row 0 column "dtlnum" to variable "dtlnum"
	Else I fail step with error message "ERROR: adjustment detail not found"
	EndIf

	Then I assign variable "elt" by combining "xPath://div[starts-with(text(),'" $stoloc "')]//ancestor::tr//div[text()[contains(., '" $dtlnum "')]]"
	Once I see element $elt in web browser

@wip @public
Scenario: Get Code Value from Code Description
#############################################################
# Description: Make MSQL call to get the system code value from description
# MSQL Files:
#	get_code_value_from_code_description.msql
# Inputs:
#	Required:
# 		code_name - the value for the field (i.e. $reacod, $invsts)
#		code_description - the field name (i.e "reacod", "invsts")
#	Optional:
#		None
# Outputs:
# 	code_value - column value of the lookup of code_name/code_description from docmst
#	code - error code if lookup fails (fails to find)	
#############################################################

Given I "get system code value from UI description"
	And I assign "get_code_value_from_code_description.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
		Then I assign row 0 column "colval" to variable "code_value"
	Else I assign variable "err_msg" by combining "ERROR: " $code_name " " $code_description " not found"
		Then I fail step with error message $err_msg
	EndIf

@wip @public
Scenario: Web Inventory Adjustment Check LPN Deleted from Location
#############################################################
# Description: Check in the Location / LPNs TAB (Basics) UI
# looking to make sure the lodnum (input) it not displayed
# MSQL Files:
#	None
# Inputs:
#	Required:
#		lodnum - Load number that was used in test 
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "navigate to the LPNs Grid on the Location screen by clicking the LPNs button"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id,'button') and text()='LPNs']/.."
	And I click element $elt in web browser within $max_response seconds 

And I "ensure the LPNs grid is displaying"
	Then I assign variable "elt" by combining "xPath://span[text()='Basics']"
	Once I see element $elt in web browser
	
And I "ensure the LPN is no longer in the Location"
	Then I assign variable "elt_lodnum_row" by combining "xPath://tr[starts-with(@id,'rpMultiLevelGridView') and contains(@id,'" $lodnum "')]"
	Once I do not see element $elt_lodnum_row in web browser 
	
@wip @public
Scenario: Web Inventory Adjustment Search for Location to Add Inventory on Inventory Screen
#############################################################
# Description: Search for the specified storage location on the Inventory screen
# MSQL Files:
#	None
# Inputs:
#	Required:
#		stoloc - Location where the adjustment will take place
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "search for the location on the Inventory screen"
	Then I assign $stoloc to variable "string_to_search_for"
	And I assign "Location" to variable "component_to_search_for"
	And I execute scenario "Web Component Search"

And I "select the row with my Location and Wait for the Location page to load"
	Then I assign variable "elt" by combining "xPath://span[text()='" $stoloc "']"
	And I click element $elt in web browser within $max_response seconds
	
And I "wait for the page to load"
	Then I assign variable "elt" by combining "Location - " $stoloc
	Once I see $elt in web browser

And I unassign variables "string_to_search_for,component_to_search_for"
 
@wip @public
Scenario: Web Inventory Adjustment Check that Inventory Adjustment was Successful
#############################################################
# Description: Verify that the UI from the Location screen has
# updated values after an inventory adjustment
# MSQL Files:
#	None
# Inputs:
#	Required:
#		new_qty - The new quantity to adjust inventory to
#		approval_required - Is approval required for update
#	Optional:
#		None
# Outputs:
#	None
############################################################# 
 
Given I "ensure the adjustment was successful or pending approval if authorization is required"
	If I verify variable "approval_required" is assigned
	And I verify text $approval_required is equal to "TRUE" ignoring case
		Then I assign $new_qty to variable "check_adjqty"
		And I execute Scenario "Web Inventory Adjustment Check Inventory Adjustment Approval Pending"
	Else I assign $new_qty to variable "untqty"
		And I execute scenario "Web Inventory Adjustment Check LPN Item Attributes in Location"
	EndIf

@wip @public
Scenario: Web Inventory Adjustment Add
#############################################################
# Description: Conduct an Inventory Add operation from the 
# location screen.
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
#		adjref1 - Adjustment reference 1
#		adjref2 - Adjustment reference 2
#		untqty - The quantity of inventory we want to add
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "ensure the Location is either Empty or Partially Full, any other status will fail the test"
	Then I execute scenario "Web Create Variable location_status on Location Screen"
	If I do not see element $location_status_partial in web browser
	And I do not see element $location_status_empty in web browser
		Then I "have Selected a Location that is not Empty or Partially Full."
			And I fail step with error message "ERROR: The Location is NOT Empty or Partially Full. Stopping Test Due to Location status."
	EndIf
	
And I "select the 'Actions' drop-down"
	Then I click element "xPath://span[starts-with(@id,'button-') and text()='Actions']//.." in web browser within $max_response seconds 
	And I wait $wait_med seconds

And I "click 'Add Inventory'"
	Then I execute scenario "Web Create Variable add_inventory_button on Actions Menu"
	And I click element $add_inventory_button in web browser within $max_response seconds 
	And I wait $screen_wait seconds 
	Once I see "ADD INVENTORY" in web browser

And I "enter the LPN to be Added"
	Then I assign variable "elt" by combining "xPath://input[@placeholder='System Generated If Empty']"
	And I click element $elt in web browser within $max_response seconds 
	When I type $lodnum in element $elt in web browser within $max_response seconds

And I "enter the item number into the Item Field"
	Then I assign variable "elt" by combining "xPath://input[@name='itemNumber']"
	And I click element $elt in web browser within $max_response seconds 
	When I type $prtnum in element $elt in web browser within $max_response seconds
	And I wait $screen_wait seconds

And I "select the item from the list"
	Then I assign variable "elt" by combining "xPath://div[text()='" $prtnum " - " $client_id "']"
	And I click element $elt in web browser within $max_response seconds
	And I wait $wait_short seconds 

And I "ensure the item client ID is populated"
	Then I assign variable "elt" by combining "xPath://input[@name='itemClientId']"
	And I copy text inside element $elt in web browser to variable "check_client" within $max_response seconds
	And I verify text $check_client is equal to $client_id

And I "enter the quantity to Add"
	Then I assign variable "elt" by combining "xPath://input[@name='quantity']"
	And I click element $elt in web browser within $max_response seconds 
	When I type $untqty in element $elt in web browser within $max_response seconds

And I "select the UOM"
	Given I assign variable "dropdown_type" by combining "uomCode"
	And I execute scenario "Web Click Attribute Dropdown on Adjustment Screen"
	And I assign variable "elt" by combining "xPath://li[text()='" $uom "']"
	When I click element $elt in web browser within $max_response seconds

And I "select the inventory status"
	Then I assign variable "dropdown_type" by combining "inventoryStatus"
	And I execute scenario "Web Click Attribute Dropdown on Adjustment Screen"
	And I assign variable "elt" by combining "xPath://li[text()='" $invsts "']"
	When I click element $elt in web browser within $max_response seconds

And I "select the item footprint"
	Then I assign variable "dropdown_type" by combining "footprintCode"
	And I execute scenario "Web Click Attribute Dropdown on Adjustment Screen"
	And I assign variable "elt" by combining "xPath://li[text()='" $ftpcod "']"
	When I click element $elt in web browser within $max_response seconds

And I "enter the lot if Required"
	Then I assign variable "elt" by combining "xPath://label[text()='Lot']"
	If I see element $elt in web browser within $wait_med seconds
		Then I assign variable "elt" by combining "xPath://input[@name='lotNumber']"
		And I click element $elt in web browser within $max_response seconds
		When I type $lotnum in element $elt in web browser within $max_response seconds
	EndIf

And I "enter the adjustment references and reason code"
	Then I assign variable "dropdown_type" by combining "reasonCode"
	And I execute scenario "Web Inventory Add Adjustments and Reason" 

And I "check location state and complete adjustment"
	Then I execute scenario "Web Inventory Check Location and Finish Adjustment"

@wip @public
Scenario: Web Inventory Adjustment Delete
#############################################################
# Description: Conduct an Inventory Delete operation from the 
# Location screen.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		stoloc - Location where the adjustment will take place
#		lodnum - Load number that was added 
#		reacod - System reason code for adjustment/delete
#		adjref1 - Adjustment reference 1
#		adjref2 - Adjustment reference 2
#		new_qty - The new quantity we want to adjust to
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "ensure the Location is either Full or Partially Full, any other status will fail the test"
	Then I execute scenario "Web Create Variable location_status on Location Screen"
	If I do not see element $location_status_partial in web browser within $wait_med seconds
	And I do not see element $location_status_full in web browser within $wait_med seconds
		Then I "have selected a location that is not full or partially full."
			And I fail step with error message "ERROR: The location is not full or partially full. Stopping test due to location status."
	EndIf
	
And I "navigate to the LPNs grid on the location screen by clicking the LPNs button"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id,'button') and text()='LPNs']/.."
	And I click element $elt in web browser within $max_response seconds
	
And I "ensure the LPNs grid is displaying"
	Then I assign variable "elt" by combining "xPath://span[text()='Basics']"
	Once I see element $elt in web browser
	
And I "check the checkbox for the load being deleted"
	Then I assign variable "elt" by combining "xPath://tr[starts-with(@id,'rpMultiLevelGridView') and contains(@id,'" $lodnum "')]//div[@class='x-grid-row-checker']"
	And I click element $elt in web browser within $max_response seconds
	
And I "select the 'Actions' drop-down"
	Then I click element "xPath://span[starts-with(@id,'button-') and text()='Actions']//.." in web browser within $max_response seconds 
	And I wait $wait_med seconds
	
And I "click 'Remove Inventory'"
	Then I execute scenario "Web Create Variable remove_inventory_button on Actions Menu"
	And I click element $remove_inventory_button in web browser within $max_response seconds 
	And I wait $screen_wait seconds
	Once I see "Quantity to be Removed" in web browser
	
And I "enter the adjustment references and reason code"
	Then I assign variable "dropdown_type" by combining "adjustmentReason"
	And I execute scenario "Web Inventory Add Adjustments and Reason" 

And I "check location state and complete adjustment"
	Then I execute scenario "Web Inventory Check Location and Finish Adjustment"

@wip @public
Scenario: Web Inventory Adjustment Change
#############################################################
# Description: Conduct an Inventory Adjustment with input
# provided by test case. Assumes you are on Inventory screen
# and searches for Location and performs the adjustment.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		stoloc - Location where the adjustment will take place
#		lodnum - Load number that was added 
#		reacod - System reason code for adjustment.
#		uom - Unit of measure
#		adjref1 - Adjustment reference 1
#		adjref1 - Adjustment reference 2
#		new_qty - The new quantity we want to adjust to (increase/decrease)
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "search for the location to adjust inventory"
	Then I assign $stoloc to variable "string_to_search_for"
	And I assign "Location" to variable "component_to_search_for"
	And I execute scenario "Web Component Search"

And I "select the row with my location and wait for the Location page to load"
	Then I assign variable "elt" by combining "xPath://span[text()='" $stoloc "']"
	And I click element $elt in web browser within $max_response seconds
	
And I "wait for the page to load"
	Then I assign variable "elt" by combining "Location - " $stoloc
	Once I see $elt in web browser 

Given I "ensure the location is either Full or Partially Full, any other status will fail the test"
	Then I execute scenario "Web Create Variable location_status on Location Screen"
	If I do not see element $location_status_partial in web browser
	And I do not see element $location_status_full in web browser
		Then I "Have selected a location that is not full or partially full."
			And I fail step with error message "ERROR: The location is not full or partially full. Stopping test due to location status."
	EndIf
	
And I "navigate to the LPNs grid on the Location screen by clicking the LPNs button"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id,'button') and text()='LPNs']/.."
	And I click element $elt in web browser within $max_response seconds
	
And I "ensure the LPNs grid is displaying"
	Then I assign variable "elt" by combining "xPath://span[text()='Basics']"
	Once I see element $elt in web browser 

And I "check the checkbox for the load being adjusted"
	Then I assign variable "elt" by combining "xPath://tr[starts-with(@id,'rpMultiLevelGridView') and contains(@id,'" $lodnum "')]//div[@class='x-grid-row-checker']"
	And I click element $elt in web browser within $max_response seconds 

And I "select the 'Actions' drop-down"
	Then I click element "xPath://span[starts-with(@id,'button-') and text()='Actions']//.." in web browser within $max_response seconds 
	And I wait $wait_med seconds 

And I "click 'Adjust Inventory'"
	Then I execute scenario "Web Create Variable adjust_inventory_button on Location Screen"
	And I click element $adjust_inventory_button in web browser within $max_response seconds 
	And I wait $screen_wait seconds 
	Once I see "ADJUST INVENTORY" in web browser

And I "Enter the quantity to adjust"
	Then I assign variable "elt" by combining "xPath://input[@name='quantity']"
	And I click element $elt in web browser within $max_response seconds 
	And I clear all text in element $elt in web browser within $max_response seconds
	When I type $new_qty in element $elt in web browser within $max_response seconds

And I "select the UOM"
	Then I assign variable "dropdown_type" by combining "uomCode"
	And I execute scenario "Web Click Attribute Dropdown on Adjustment Screen"
	And I assign variable "elt" by combining "xPath://li[text()='" $uom "']"
	When I click element $elt in web browser within $max_response seconds 

And I "enter the adjustment references and reason code"
	Then I assign variable "dropdown_type" by combining "reasonCode"
	And I execute scenario "Web Inventory Add Adjustments and Reason"

And I "check location state and complete adjustment"
	Then I execute scenario "Web Inventory Check Location and Finish Adjustment"

And I unassign variables "string_to_search_for,component_to_search_for"

@wip @public
Scenario: Web Inventory Navigate to Inventory LPN Display
#############################################################
# Description: Search for the LPN and click on the LPN TAB
# MSQL Files:
#	None
# Inputs:
#	Required:
#		lodnum - Load Number, Generated in 
#                Web Inventory Move Check LPN Moved to Location 
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "search for the LPN"
	Then I assign $lodnum to variable "string_to_search_for"
	And I assign "LPN" to variable "component_to_search_for"
	And I execute scenario "Web Component Search"
	
And I "click the LPNs Button to Open LPN Data Grid"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id,'rpCountButton-') and text()='LPNs']/../.."
	And I click element $elt in web browser within $max_response seconds
	
And I "ensure the LPNs Grid is Displaying"
	Then I assign variable "elt" by combining "xPath://span[text()='Basics']"
	Once I see element $elt in web browser
    
And I wait $wait_long seconds

And I unassign variables "string_to_search_for,component_to_search_for"

@wip @public
Scenario: Web Inventory Move Enter Partial Quantity Move Information
#############################################################
# Description: If this is a partial move of inventory, then
# enter the appropriate quantity and destination LPN 
# MSQL Files:
#	None
# Inputs:
#	Required:
#		move_qty - Qty to be moved from source to destination
#		dstlod - New load number (LPN) for the partial qty if performing a partial qty movement
#	Optional:
#		None
# Outputs:
#	partial_move - denotes if this is a partial move case
#############################################################

Given I "flag this as a Partial Transfer and Enter the Move Quantity"
	Then I assign variable "partial_move" by combining "Y"
	And I assign variable "elt" by combining "xPath://input[@name='movInvQuantity']"
	Then I click element $elt in web browser within $max_response seconds 
	And I clear all text in element $elt in web browser within $max_response seconds
	When I type $move_qty in element $elt in web browser within $max_response seconds
	
And I "enter the Destination LPN"
	Then I assign variable "elt" by combining "xPath://input[@name='movInvLPN']"
	And I click element $elt in web browser within $max_response seconds 
	And I clear all text in element $elt in web browser within $max_response seconds
	When I type $dstlod in element $elt in web browser within $max_response seconds

@wip @public
Scenario: Web Inventory Move Check LPN Moved to Location
#############################################################
# Description: Verify after the move operation completed and that
# the UI reflects the proper values
# MSQL Files:
#	None
# Inputs:
#	Required:
#		move_qty - Qty to be moved from source to destination
#		dstlod - New load number (LPN) for the partial qty if performing a partial qty movement
#		srclod - Load number added by dataset and moved by the main scenario
#		prtnum - valid part number that is defined in your system
#		untqty - Quantity for the dataset to add inventory
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "determine Storage Location"
	If I verify variable "partial_move" is assigned
		Then I assign variable "lodnum" by combining $dstlod
		And I assign variable "untqty" by combining $move_qty
	Else I assign variable "lodnum" by combining $srclod
	EndIf
	And I assign variable "stoloc" by combining $dstloc
	
And I "find the Load Number (LPN) to Move in the Inventory Screen"
	Then I execute scenario "Web Inventory Navigate to Inventory LPN Display"
	If I verify variable "lodnum" is assigned
		Then I assign variable "elt_lodnum_row" by combining "xPath://tr[starts-with(@id,'rpMultiLevelGridView') and contains(@id,'" $lodnum "')]"
		Once I see element $elt_lodnum_row in web browser 
	Else I fail step with error message "ERROR: Load number (LPN) required for location check"
	EndIf
	
And I "check the Attributes on the Basics TAB"
And I "validate the Item is on the LPN"
	If I verify variable "prtnum" is assigned
		Then I assign variable "elt" by combining $elt_lodnum_row "//span[text()='" $prtnum "']"
		Once I see element $elt in web browser
	EndIf

And I "validate the unit qty on the LPN"
	If I verify variable "untqty" is assigned
		Then I assign variable "elt" by combining $elt_lodnum_row "//div[contains(text(),'" $untqty " ')]"
		Once I see element $elt in web browser
	EndIf
	
And I "validate the Location of the LPN"
	If I verify variable "stoloc" is assigned
		Then I assign variable "elt" by combining $elt_lodnum_row "//span[text()='" $stoloc "']"
		Once I see element $elt in web browser
	EndIf
	
@wip @public
Scenario: Web Inventory Move  
#############################################################
# Description: From LPN TAB on the Inventory Screen, select
# the LPN to move, select the Move Action, and conduct the move operation.
# Take into both partial and full inventory move cases.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		move_qty - Qty to be moved from source to destination
#		untqty - Quantity for the dataset to add inventory
#		dstloc - The destination location of the LPN to be moved
#		srclod - Load number added by dataset and moved
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "find the LPN to Move in the Inventory Screen"
	Then I assign variable "lodnum" by combining $srclod
	And I execute scenario "Web Inventory Navigate to Inventory LPN Display"

And I "check the Checkbox for the LPN being Moved"
	Then I assign variable "elt" by combining "xPath://tr[starts-with(@id,'rpMultiLevelGridView') and contains(@id,'" $srclod "')]//div[@class='x-grid-row-checker']"
	And I click element $elt in web browser within $max_response seconds 

And I "select the 'Actions' drop-down"
	Then I click element "xPath://span[starts-with(@id,'wmMultiViewActionButton-') and text()='Actions']//.." in web browser within $max_response seconds 
	And I wait $wait_med seconds 

And I "click 'Move Inventory'"
	Then I execute scenario "Web Create variable move_inventory_button on Move LPN Screen"
	And I click element $move_inventory_button in web browser within $max_response seconds 
	And I wait $screen_wait seconds 

And I "enter the Quantity and New Destination LPN if Moving Partial Quantity"
	Once I see "Destination" in web browser
	If I verify variable "move_qty" is assigned
	And I verify number $move_qty is less than $untqty
		Then I execute scenario "Web Inventory Move Enter Partial Quantity Move Information"
	Else I "need to make sure the Destination LPN field is cleared out since we want to move the whole LPN"
			Then I assign variable "elt" by combining "xPath://input[@name='movInvLPN']"
			And I click element $elt in web browser within $max_response seconds 
			And I clear all text in element $elt in web browser within $max_response seconds
	EndIf

And I "enter the Destination Location"
	Then I assign variable "elt" by combining "xPath://input[starts-with(@id,'locationLookup-') and contains(@id,'-inputEl')]"
	And I click element $elt in web browser within $max_response seconds 
	When I type $dstloc in element $elt in web browser within $max_response seconds
	And I wait $screen_wait seconds 
	
And I "select the Location from the List"
	Then I assign variable "elt" by combining "xPath://li[text()='" $dstloc "']"
	And I click element $elt in web browser within $max_response seconds 
	And I wait $wait_short seconds 

And I "move immediate or through work queue depending on variable mode"
And I "use Move immediate option"
	If I verify text $inventory_move_mode is equal to "IMMEDIATE"
		Then I "click the Move Immediately radio button"
			And I assign variable "elt" by combining "xPath://label[text()='Move Immediately']/..//input[@type='button']"
			And I click element $elt in web browser within $max_response seconds 
        
		And I "click the Move button to Complete the Move"
			Then I assign variable "elt" by combining "xPath://span[text()='Move']/.."
			And I click element $elt in web browser within $max_response seconds 

		And I "acknowledge the LPN was Moved"
			Then I assign variable "elt" by combining "xPath://div[text()='LPN moved Successfully to " $dstloc "']"
			Once I see element $elt in web browser
			And I press keys "ENTER" in web browser

		And I "clear Inventory Screen Filter and Ensure the LPN was Moved Successfully"
			Then I assign variable "elt" by combining "xPath://a[@data-qtip='Delete']"
			And I click element $elt in web browser within $max_response seconds 
			When I execute scenario "Web Inventory Move Check LPN Moved to Location"
    EndIf

And I "use Move through work queue option"
	If I verify text $inventory_move_mode is equal to "WORK QUEUE"
		Then I "click the Work Queue radio button"
			And I assign variable "elt" by combining "xPath://label[text()='Add to Work Queue']/..//input[@type='button']"
			And I click element $elt in web browser within $max_response seconds
          
		And I "click the Move button to Complete the Move"
			Then I assign variable "elt" by combining "xPath://span[text()='Move']/.."
			And I click element $elt in web browser within $max_response seconds
          
		And I "check if the move was created successfully and click OK"
			Once I see element "xPath://div[@class='x-container x-container-default x-table-layout-ct'][contains(.,'Successful moves: 1 of 1Failed Moves: 0')]" in web browser
			And I click element "xPath://span[starts-with(@id,'button-') and .= 'OK']" in web browser within $max_response seconds
        
		And I "clear Inventory Screen Filter"
			Then I assign variable "elt" by combining "xPath://a[@data-qtip='Delete']"
			And I click element $elt in web browser within $max_response seconds     
        
		Then I assign contents of variable "srclod" to "xfer_lodnum"          
	EndIf

@wip @public
Scenario: Web Inventory Status Change  
#############################################################
# Description: Change status of Inventory specified by lodnum
# MSQL Files:
#	validate_status_on_inventory_by_lpn.msql
# Inputs:
#	Required:
# 		stoloc - Location where the adjustment will take place. Must be a valid adjustable location in the system
# 		lodnum - Load number being adjusted in. Can be a fabricated number
#		newinvsts - New Inventory Status. Used to set the inventory to this status
#		reacodfull - Reason Code Full. Used for the reason code of the inventory status change. Must be full description
#	Optional:
#		None
# Outputs:
#	None
#############################################################  

Given I "search for the Inventory by LPN Number"
	Then I assign $lodnum to variable "string_to_search_for"
	And I assign "LPN" to variable "component_to_search_for"
	And I execute scenario "Web Component Search"

	Once I see $stoloc in web browser

And I "click the Row with the LPN"
	Once I see element "className:x-grid-row-checker" in web browser
	Then I click element "className:x-grid-row-checker" in web browser within $max_response seconds 
	And I wait $wait_short seconds
	
And I "click on the LPNs TAB"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id,'rpCountButton-') and .= 'LPNs']/ancestor::a[starts-with(@id,'rpCountButton-')]"
	And I click element $elt in web browser within $max_response seconds 
	Once I see $lodnum in web browser
	
And I "click on the LPN"
	Then I assign variable "elt" by combining "xPath://span[.='" $lodnum "']"
	And I click element $elt in web browser within $max_response seconds 
	And I wait $wait_short seconds 

And I "select the Actions Drop Down"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id,'button-') and contains(@id,'-btnInnerEl') and .= 'Actions']/ancestor::a[starts-with(@id,'button-')]"
	And I click element $elt in web browser within $max_response seconds

And I "select the Change Inventory Status Drop Down"
	Then I assign variable "elt" by combining "xPath://a[starts-with(@id,'menuitem-') and .= 'Change Inventory Status']"
	And I click element $elt in web browser within $max_response seconds 
	And I wait $wait_short seconds 

And I "click the To Inventory Status DropDown"
	Then I wait $wait_short seconds 
	And I assign variable "elt" by combining "xPath://input[starts-with(@id,'combobox-') and starts-with(@name,'inventoryStatus')]"
	When I click element $elt in web browser within $max_response seconds 

And I "enter the Inventory Status"
	Then I wait $wait_short seconds 
	And I type $newinvsts in element $elt in web browser within $max_response seconds
	And I wait $wait_short seconds 
	When I press keys "ENTER" in web browser

And I "click the Reason Code DropDown"
	Then I wait $wait_short seconds 
	And I assign variable "elt" by combining "xPath://input[starts-with(@id,'combobox-') and starts-with(@name,'reasonCode')]"
	When I click element $elt in web browser within $max_response seconds 

And I "enter The Appropriate Reason Code"
	Then I wait $wait_short seconds 
	And I type $reacodfull in element $elt in web browser within $max_response seconds
	And I wait $wait_short seconds 
	When I press keys "ENTER" in web browser
	And I wait $wait_short seconds 

And I "press the OK Button"
	Then I assign variable "elt" by combining "xPath://a[starts-with(@id,'button-') and .= 'OK']"
	And I click element $elt in web browser within $max_response seconds 
	Once I see "successfully" in web browser
	
And I "click the 'OK' button to Finalize the Inventory Status Change"
	Then I wait $wait_med seconds 
	And I assign variable "elt" by combining "xPath://span[starts-with(@id,'button-') and contains(@id,'-btnInnerEl') and .= 'OK']/ancestor::div[starts-with(@id, 'window-')]//a[starts-with(@id,'button-')]"
	When I click element $elt in web browser within $max_response seconds 

And I "validate the Inventory Status Changed"
	Then I assign $newinvsts to variable "validate_invsts"
	And I assign "validate_status_on_inventory_by_lpn.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	And I verify MOCA status is 0

And I unassign variables "string_to_search_for,component_to_search_for"

@wip @public
Scenario: Web Inventory Add or Release Hold
#############################################################
# Description: Perform either an Inventory Add or Release
# Hold operation based on the hold_mode flag being set to
# 0 (release hold) or 1 (add hold)
# MSQL Files:
#	check_invhld.msql
# Inputs:
#	Required:
# 		stoloc - Where the adjustment will take place. Must be a valid adjustable location in the system
# 		lodnum - Load number being adjusted in. Can be a fabricated number. Used in Terminal/WEB and datasets processing.
#		hldnum - Hold Number. Hold Number to be applied to inventory
#		reacodfull - Reason Code Full. Used for the reason code of the inventory status change. Must be full description.
#		hold_mode - Used for processing logic. 1 = Add Hold, 0 = Release Hold
#	Optional:
#		hold_multi - Used for multiple inventory (if TRUE)
# Outputs:
#	None
#############################################################

Given I "search for the Inventory By LPN Number"
	If I verify variable "hold_multi" is assigned
	And I verify text $hold_multi is equal to "TRUE" ignoring case
    	Then I assign variable "search_lodnum" by combining $lodnum "*"
    	Then I assign $search_lodnum to variable "string_to_search_for"
	Else I assign $lodnum to variable "string_to_search_for"
    EndIf
	And I assign "LPN" to variable "component_to_search_for"
	And I execute scenario "Web Component Search"
	Once I see $stoloc in web browser

Then I "click the Row with the LPN"
	Once I see element "className:x-grid-row-checker" in web browser 
	And I click element "className:x-grid-row-checker" in web browser within $max_response seconds 
	And I wait $wait_short seconds 

And I "click the LPNs TAB"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id,'rpCountButton-') and .= 'LPNs']/ancestor::a[starts-with(@id,'rpCountButton-')]"
	And I click element $elt in web browser within $max_response seconds 
	Once I see $lodnum in web browser

Then I "select LPNs and click on Actions Button"
	And I "run for multi hold case"
		If I verify variable "hold_multi" is assigned
		And I verify text $hold_multi is equal to "TRUE" ignoring case
			Then I click element "xPath://div[contains(@class,'x-column-header-checkbox') and not(contains(@class,'x-grid-hd-checker-on'))]//span" in web browser within $max_response seconds
    		And I click element "xPath://span[starts-with(@id,'wmMultiViewActionButton-') and text()='Actions']//.." in web browser within $max_response seconds
	Else I "will run single hold case"
		And I "click LPN itself"
			Then I assign variable "elt" by combining "xPath://span[.='" $lodnum "']"
			And I click element $elt in web browser within $max_response seconds 
			And I wait $wait_short seconds 
		And I "select the Actions Drop Down"
			Then I assign variable "elt" by combining "xPath://span[starts-with(@id,'button-') and contains(@id,'-btnInnerEl') and .= 'Actions']/ancestor::a[starts-with(@id,'button-')]"
			And I click element $elt in web browser within $max_response seconds 
	Endif

And I "interact with the Apply or Release Drop Down"
	If I verify number $hold_mode is equal to 1
		Then I "apply Hold Drop Down"
			And I assign variable "elt" by combining "xPath://a[starts-with(@id,'menuitem-') and .= 'Apply Hold']"
			When I click element $elt in web browser within $max_response seconds 
	Elsif I verify number $hold_mode is equal to 0
		Then I "release Hold Drop Down"
			And I assign variable "elt" by combining "xPath://a[starts-with(@id,'menuitem-') and .= 'Release Hold']"
			When I click element $elt in web browser within $max_response seconds 
	Else I fail step with error message "ERROR: HOLD_MODE not set"
	EndIf
	And I wait $wait_short seconds 

And I "click Hold Number"
	Then I assign variable "hold_search" by combining "Hold= " $hldnum
	And I assign variable "elt" by combining "text:" $hldnum
	When I click element $elt in web browser within $max_response seconds 
	And I wait $wait_short seconds 

And I "apply or Release the Hold"
	If I verify number $hold_mode is equal to 1
		Then I "Apply the Hold"
			And I assign variable "elt" by combining "xPath://a[starts-with(@id,'button-') and .= 'Apply']"
			When I click element $elt in web browser within $max_response seconds 
	Elsif I verify number $hold_mode is equal to 0
		Then I "Release the Hold"
			And I assign variable "elt" by combining "xPath://a[starts-with(@id,'button-') and .= 'Release']"
			When I click element $elt in web browser within $max_response seconds 
	Else I fail step with error message "ERROR: HOLD_MODE not set"
	EndIf
	And I wait $wait_short seconds 

And I "click the Reason Code DropDown"
	Then I wait $wait_short seconds 
	And I assign variable "elt" by combining "xPath://input[starts-with(@id,'combobox-') and starts-with(@name,'reasonCode')]"
	When I click element $elt in web browser within $max_response seconds 

And I "enter The Appropriate Reason Code"
	Then I wait $wait_short seconds 
	And I type $reacodfull in element $elt in web browser within $max_response seconds
	And I wait $wait_short seconds 
	When I press keys "ENTER" in web browser
	And I wait $wait_short seconds 

And I "press the OK Button"
	Then I assign variable "elt" by combining "xPath://a[starts-with(@id,'button-') and .= 'OK']"
	And I click element $elt in web browser within $max_response seconds 
	Once I see "successfully" in web browser

And I "click the 'OK' Button to Finalize the Inventory Hold"
	Then I wait $wait_med seconds 
	And I click element $elt in web browser within $max_response seconds 
	And I wait $wait_short seconds 

And I "validate the Hold Process using MOCA"
	Then I assign "check_invhld.msql" to variable "msql_file"
	And I execute scenario "Perform MSQL Execution"
	If I verify number $hold_mode is equal to 1
		Then I "Validate a Hold was Added"
			And I verify MOCA status is 0
	Elsif I verify number $hold_mode is equal to 0
		Then I "Validate a Hold was Released"
			And I verify MOCA status is 510
	Else I fail step with error message "ERROR: HOLD_MODE not set"
	EndIf

And I unassign variables "string_to_search_for,component_to_search_for"

@wip @public
Scenario: Web Inventory Create Count Batch
#############################################################
# Description: Create a Count Batch for a Range of storage
# locations specified
# MSQL Files:
#	None
# Inputs:
#	Required:
#		requestCountBy - Method of requesting counts
#		beginLocation - Start of count location range
#		endLocation - End of count location range
#		cntbat - Count Batch we are creating
#		cnttyp_desc - Count type description
#		gencod_desc - Generate code description
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "am in the Counts Screen, Select the 'Schedule Count' Option"
	# Can't use the $xPath_span_Actions variable since there are multiple Actions in this screen
	Then I assign variable "elt" by combining $xPath ""
	And I assign variable "elt" by combining $elt "//div[starts-with(@id,'wm-inventorycounts-main-')]"
	And I assign variable "elt" by combining $elt "//span[contains(@id,'-btnEl') and child::span[text()='Actions']]"
	And I assign $elt to variable "count_action"
	When I click element $count_action in web browser within $max_response seconds 
	And I wait $wait_med seconds

	And I assign variable "elt" by combining $xPath ""
	And I assign variable "elt" by combining $elt "//span[starts-with(@id,'menuitem') and text()='Schedule Count']"
	And I assign $elt to variable "schedule_count_option"
	When I click element $schedule_count_option in web browser within $max_response seconds 
	And I wait $wait_med seconds 

And I "am in the first schedule Count screen, either search criteria and find eligible locations"
	Then I type $requestCountBy in element "xPath://input[@name='requestCountBy']" in web browser within $max_response seconds
	# Add the waits to ensure the drop-down has selected the request field (text)
	And I wait $screen_wait seconds
	And I press keys TAB in web browser
	Then I type $beginLocation in element "xPath://input[@name='beginLocation']" in web browser within $max_response seconds 
	And I wait $screen_wait seconds
	And I press keys TAB in web browser
	Then I type $endLocation in element "xPath://input[@name='endLocation']" in web browser within $max_response seconds 
	And I wait $screen_wait seconds
	And I press keys TAB in web browser
	When I click element "xPath://span[child::span[text()='Find Locations']]" in web browser within $max_response seconds 
	And I wait $wait_med seconds 

And I "check if we have eligible locations before we continue"
	Then I assign variable "elt" by combining $xPath ""
	And I assign variable "elt" by combining $elt "//div[starts-with(@id,'wm-inventorycounts-schedulecounts-locationsgrid')]"
	And I assign variable "elt" by combining $elt "//td/div[text()='" $beginLocation "']"
	And I assign $elt to variable "location_grid_first_cell"
	Once I see element $location_grid_first_cell in web browser 
	When I click element "xPath://span[child::span[text()='Next']]" in web browser within $max_response seconds 
	And I wait $wait_med seconds 

And I "am in the second schedule count screen. Enter Batch Number and other details and release"
	Then I type $cntbat in element "xPath://input[@name='countId']" in web browser within $max_response seconds 
	And I press keys TAB in web browser
	And I type $cnttyp_desc in element "xPath://input[@name='countType']" in web browser within $max_response seconds 
	And I press keys TAB in web browser
	And I type $gencod_desc in element "xPath://input[@name='requestType']" in web browser within $max_response seconds 
	And I press keys TAB in web browser
	When I click element "xPath://span[child::span[text()='Save and Release']]" in web browser within $max_response seconds 
	And I wait $wait_med seconds 

And I "see a success message that the Counts are released"
	Once I see element "xPath://div[contains(text(),'count(s) released successfully')]" in web browser 
	And I press keys "ENTER" in web browser
    
@wip @public
Scenario: Web Open the Inventory Outbound Screen
#############################################################
# Description: Traverse to top-level Search Box in Web UI
# and search/open the main Outbound Planner Inventory screen.
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

Given I "open the Inventory Outbound Plannner screen"
	Then I assign "Inventory" to variable "wms_screen_to_open"
	And I assign "Outbound Planner" to variable "wms_parent_menu"
	Then I execute scenario "Web Screen Search"
	And I wait $wait_med seconds 
	Once I see "To find inventory" in web browser 

And I unassign variables "wms_parent_menu,wms_screen_to_open"
	
@wip @public
Scenario: Web Error Location
#############################################################
# Description: changes the location status to error.
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

Given I "put location on error status"
	And I assign "ERROR" to variable "mode"
	Then I execute scenario "Web Location Status Change"

@wip @public
Scenario: Web Select LPN to Modify
#############################################################
# Description: Selects the LPN in the Inventory table.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		lotnum - The lotnum for the inventory to select.
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "find the LPN to Modify in the Inventory Screen"
	And I execute scenario "Web Inventory Navigate to Inventory LPN Display"

And I "check the Checkbox for the LPN being Modified"
	Then I assign variable "elt" by combining "xPath://tr[starts-with(@id,'rpMultiLevelGridView') and contains(@id,'" $lodnum "')]//div[@class='x-grid-row-checker']"
	And I click element $elt in web browser within $max_response seconds 

@wip @public
Scenario: Web Select Modify Inventory Attribute Action
#############################################################
# Description: Selects the Modify Inventory Attribute button
# from the Action dropdown on the Inventory screen.
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

Given I "select the 'Actions' drop-down"
	When I see "Inventory" in web browser
	Then I click element "xPath://span[starts-with(@id,'wmMultiViewActionButton-') and text()='Actions']//.." in web browser within $max_response seconds 
	And I wait $wait_med seconds 

And I "click 'Modify Inventory Attribute'"
	Then I execute scenario "Web Create variable modify_inventory_attribute_button on LPN Screen"
	And I click element $modify_inventory_attribute_button in web browser within $max_response seconds 
	And I wait $screen_wait seconds 
	Once I see "Modify Inventory Attribute" in web browser
  
@wip @public
Scenario: Web Select Relabel LPN Action
#############################################################
# Description: Selects the Relabel LPN button 
# from the Action dropdown on the Inventory screen.
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

Given I "select the 'Actions' drop-down"
	Then I click element "xPath://span[starts-with(@id,'wmMultiViewActionButton-') and text()='Actions']//.." in web browser within $max_response seconds 
	And I wait $wait_med seconds 

And I "click 'Relabel LPN'"
	Then I execute scenario "Web Create variable relabel_lpn_button on LPN Screen"
	And I click element $relabel_lpn_button in web browser within $max_response seconds 
	And I wait $screen_wait seconds 
	Once I see "New LPN" in web browser

@wip @public
Scenario: Web Reset Location
#############################################################
# Description: resets the status to original.
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

Given I "reset the location status"
	And I assign "RESET" to variable "mode"
	Then I execute scenario "Web Location Status Change"
   
@wip @public
Scenario: Web Modify Inventory Lotnum
#############################################################
# Description: Changes and saves the lotnum on the inventory.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		new_lotnum - The new lotnum to enter in for the inventory.
#		reacodfull - The reason code for the change to the inventory.
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "enter Modified Inventory Lotnum" 
	Then I assign variable "elt" by combining "xPath://input[starts-with(@id,'itemlotlookup-') and contains(@id,'-inputEl')]"
	And I clear all text in element $elt in web browser within $max_response seconds
	And I type $new_lotnum in element $elt in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	And I wait $wait_med seconds  

And I "press the Save Button"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id,'button-') and contains(@id,'-btnInnerEl') and .= 'Save']/ancestor::a[starts-with(@id, 'button-') and contains(@class, 'bottom-tool-bar-save-button')]"
	And I click element $elt in web browser within $max_response seconds 
	And I wait $wait_short seconds 

And I "click Into The Reason Field"
	Then I assign variable "elt" by combining "xPath://input[starts-with(@id,'combobox-') and starts-with(@name,'reasonCode')]"
	And I clear all text in element $elt in web browser within $max_response seconds
	And I wait $wait_short seconds 
	When I click element $elt in web browser within $max_response seconds 

And I "enter The Reason Code Into The Field"
	Then I wait $wait_short seconds 
	And I type $reacodfull in element $elt in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	And I wait $wait_short seconds 

And I "press the OK Button"
	Then I assign variable "elt" by combining "xPath://span[text()='OK']/ancestor::a[starts-with(@id, 'button-') and contains(@class, 'x-btn')]"
	When I click element $elt in web browser within $max_response seconds
	And I wait $wait_short seconds 

And I "click the 'OK' button to finalize the lotnum change"
	Once I see "Successfully updated inventory attributes" in web browser
	Then I press keys "ENTER" in web browser

@wip @public
Scenario: Web Location Status Change
#############################################################
# Description: changes the location status to error or resets.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		stoloc -storage location that needs confirmation.
#		mode - if ERROR is set then location status changed to error.
#			 - if RESET is set then location status changes to its original status from error.
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I execute scenario "Web Open Inventory Screen"

When I "search for the location to change status"
	Then I assign $stoloc to variable "string_to_search_for"
	And I assign "Location" to variable "component_to_search_for"
	And I execute scenario "Web Component Search"

And I "check the checkbox for the load being adjusted"
	Then I assign variable "elt" by combining "xPath://div[@class='x-grid-row-checker']"
	And I click element $elt in web browser within $max_response seconds 

And I "select the 'Actions' drop-down"
	Then I click element "xPath://text()[.='Actions']/ancestor::a[1]" in web browser within $max_response seconds 
	And I wait $wait_short seconds 

And I "set location status to error or reset the the status to original status"    
	If I verify variable "mode" is assigned
	And I verify text $mode is equal to "ERROR"
		Then I execute scenario "Web Perform Error Location"
		And I unassign variable "mode"
	Elsif I verify variable "mode" is assigned
	And I verify text $mode is equal to "RESET"
		Then I execute scenario "Web Perform Reset Location"
		And I unassign variable "mode"
	Else I fail step with error message "ERROR: No mode is assigned"
	Endif

And I unassign variables "string_to_search_for,component_to_search_for"

@wip @public
Scenario: Web Inventory Relabel LPN
#############################################################
# Description: Enters and saves the new LPN into the Relabel LPN modal.
# MSQL Files:
#	None
# Inputs:
#	Required:
#   new_lodnum - Used to set the inventory's lodnum to this value
#	Optional:
#		None
# Outputs:
#   None
#############################################################

Given I "enter new LPN info"
	Then I assign variable "elt" by combining "xPath://input[@name='newLPN']"
	And I click element $elt in web browser within $max_response seconds
	And I type $new_lodnum in element $elt in web browser within $max_response seconds
    Then I press keys "ENTER" in web browser

And I "save the New LPN"
	Then I assign variable "elt" by combining "xPath://div[starts-with(@id, 'wm-relabellpn')]/descendant::span[text()='Save']/ancestor::a[starts-with(@id, 'button-') and contains(@class, 'x-btn')]"
	And I click element $elt in web browser within $max_response seconds

And I "click the 'OK' button to finalize the LPN relabel change"
	Once I see "Identifier relabeled successfully" in web browser
	Then I press keys "ENTER" in web browser
	Once I see "To find inventory, enter search criteria or select a saved filter." in web browser
    
@wip @public
Scenario: Web Reject Inventory Adjustments
#############################################################
# Description: This scenario will perform the rejection of a Inventory adjustment
# MSQL Files:
#	None
# Inputs:
#	Required:
#		stoloc - storage location
#		adjust_approval_reason - Used for the reason code for inventory adjustment approval. Must be full description
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I execute scenario "Create local xPaths"

When I "search for Inventory by location"
	Then I assign $stoloc to variable "string_to_search_for"
	And I assign "Location" to variable "component_to_search_for"
	And I execute scenario "Web Component Search"
    
And I "select an LPN from the grid" 
	When I click element $select_adjust_xpath in web browser within $max_response seconds
    
And I "click on Reject Button"
	When I click element "xPath://span[starts-with(@class,'x-btn-inner x-btn-inner-center') and text()='Reject']/.." in web browser within $max_response seconds
    
And I "click on Reason code field and enter reason code"  
	When I click element "xPath://input[@name='reasonCode']" in web browser within $max_response seconds
	And I type $adjust_approval_reason in web browser
	And I assign variable "elt" by combining "xPath://li[text()='" $adjust_approval_reason "']"
	Then I click element $elt in web browser within $max_response seconds
    
And I "click on Generate Cycle Count"
	When I click element "xPath://label[text() = 'Generate Cycle Count']" in web browser within $max_response seconds
    
And I "click the 'OK' button to reject the inventory"
	When I click element $ok_to_adjust_xpath in web browser within $max_response seconds 
	And I wait $wait_med seconds
	And I click element "xPath://div[contains(@class,'wm-InventoryAdjustmentWithoutFailures')]//span[text()='OK']/.." in web browser within $max_response seconds

And I unassign variables "string_to_search_for,component_to_search_for"

@wip @public	
Scenario: Web Inventory Remove LPN from a Location
#############################################################
# Description: Removes a LPN from a specified location
# MSQL Files:
#	None
# Inputs:
#	Required:
# 		stoloc - Where the adjustment will take place. Must be a valid adjustable location in the system
# 		lodnum - Load number being adjusted in. Can be a fabricated number. Used in Terminal/WEB and datasets processing.
#		reacodfull - Reason Code Full. Used for the reason code of the inventory status change. Must be full description.
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "search for the Inventory By LPN Number"
	Then I assign $lodnum to variable "string_to_search_for"
	And I assign "LPN" to variable "component_to_search_for"
	And I execute scenario "Web Component Search"
	Once I see $stoloc in web browser

And I "click the Row with the LPN"
	Once I see element "className:x-grid-row-checker" in web browser 
	And I click element "className:x-grid-row-checker" in web browser within $max_response seconds 
	And I wait $wait_short seconds 

And I "click the LPNs TAB"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id,'rpCountButton-') and .= 'LPNs']/ancestor::a[starts-with(@id,'rpCountButton-')]"
	And I click element $elt in web browser within $max_response seconds 
	Once I see $lodnum in web browser

And I "click LPN Itself"
	Then I assign variable "elt" by combining "xPath://span[.='" $lodnum "']"
	And I click element $elt in web browser within $max_response seconds 
	And I wait $wait_short seconds 

And I "select the Actions Drop Down"
	Then I assign variable "elt" by combining "xPath://span[starts-with(@id,'button-') and contains(@id,'-btnInnerEl') and .= 'Actions']/ancestor::a[starts-with(@id,'button-')]"
	And I click element $elt in web browser within $max_response seconds 

And I "interact with the Remove Inventory Drop Down"
	Then I assign variable "elt" by combining "xPath://a[starts-with(@id,'menuitem-') and .= 'Remove Inventory']"
	When I click element $elt in web browser within $max_response seconds 
	And I wait $wait_short seconds 

And I "validation the remove inventory popup screen"
	Then I assign variable "elt" by combining "xPath://span[text()='Remove Inventory']"
	Once I see element $elt in web browser

And I "click the Reason Code DropDown"
	Then I wait $wait_short seconds 
	And I assign variable "elt" by combining "xPath://input[@type='text'][@name='adjustmentReason']"
	When I click element $elt in web browser within $max_response seconds 

And I "enter The Appropriate Reason Code"
	Then I wait $wait_short seconds 
	And I type $reacodfull in element $elt in web browser within $max_response seconds
	And I wait $wait_short seconds 

And I "press the Save Button"
	Then I assign variable "elt" by combining "xPath://a[starts-with(@id,'button-') and .= 'Save']"
	And I click element $elt in web browser within $max_response seconds
	And I wait $wait_med seconds

And I unassign variables "string_to_search_for,component_to_search_for"

@wip @public
Scenario: Validate Triggered Replenishment Generated
#############################################################
# Description: confirms that triggered replenishment generated for the location
# MSQL Files: 
#	validate_triggered_replenishment_generated.msql
# Inputs:
#	Required:
#		stoloc - storage location that needs confirmation.
#		prtnum - prtnum location that needs confirmation.
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "execute MSQL that confirms triggerd replenishment generated for the location"
	And I assign "validate_triggered_replenishment_generated.msql" to variable "msql_file"
	Then I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
		Then I echo "triggered replenishment generated successfully"  
	Else I fail step with error message "ERROR: failed to generate a triggered replenishment"
	Endif

@wip @public
Scenario: Validate Top-off Replenishment Generated
#############################################################
# Description: This scenario confirms that top-off replenishment generated for the location
# MSQL Files: 
#	validate_top_off_replenishment_generated.msql
# Inputs:
#	Required:
#		stoloc - storage location that needs confirmation.
#		prtnum - prtnum location that needs confirmation.
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "execute MSQL that confirms top-off replenishment generated for the location"
	And I assign "validate_top_off_replenishment_generated.msql" to variable "msql_file"
	Then I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
		Then I echo "top-off replenishment generated successfully"  
	Else I fail step with error message "ERROR: failed to generate a top-off replenishment"
	Endif
	
@wip @public	
Scenario: Web Generate Top-off Replenishment For a Location
#############################################################
# Description: This scenario generates top-off replenishment for specified location
# MSQL Files:
#	None
# Inputs:
#	Required:
# 		stoloc - location needing top-off replenishment
#	Optional:
#		validate_sucess - If YES validates success message in web
#		validate_fail - If YES validates fail message in web
# Outputs:
#	None
#############################################################

Given I "search for storage location"
	Then I assign $stoloc to variable "string_to_search_for"
	And I assign "Location" to variable "component_to_search_for"
	And I execute scenario "Web Component Search"

Then I "select the location to generate a top off replenishment"
	And I assign variable "elt" by combining "xPath://div[@class='x-grid-row-checker']/ancestor::tr[contains(@id,'" $stoloc "')]"
	Once I see element $elt in web browser
	Then I click element $elt in web browser

When I "select Generate Replenishment from action drop down" 
	Then I assign "xPath://span[text()='Actions']/.." to variable "elt" 
	And I click element $elt in web browser within $max_response seconds 
	Then I assign "xPath://span[text()='Generate Replenishment']" to variable "elt"
	And I click element $elt in web browser

Then I "wait for replenishment to generate"
	While I see "Generating" in web browser 
		Then I wait $wait_short seconds
	EndWhile

And I "verify the replenishment"
	If I see "Confirmation" in web browser within $max_response seconds 
		If I verify variable "validate_sucess" is assigned
		And I verify text $validate_sucess is equal to "YES" ignoring case
			If I see "Failed to generate" in web browser
				Then I fail step with error message "Failed to generate top off replenishment" 
    		EndIf
			Then I "press the OK button to confirm" 
				And I click element "xPath://span[text()='OK']/.." in web browser within $max_response seconds
			Then I "clear the search"
				And I click element "xPath://*[@class='x-table-layout-cell last']" in web browser within $max_response seconds
		Endif

    	If I verify variable "validate_fail" is assigned
    	And I verify text $validate_fail is equal to "YES" ignoring case
			If I see "Failed to generate" in web browser
    			Then I echo "successfully failed to generate replenishment"
			Else I fail step with error message "ERROR: Top off replenishment generated (was not expected)"
    		EndIf
    		Then I "press the OK button to confirm" 
				And I click element "xPath://span[text()='OK']/.." in web browser within $max_response seconds
			Then I "clear the search"
				And I click element "xPath://*[@class='x-table-layout-cell last']" in web browser within $max_response seconds
    	Endif
	Else I fail step with error message "ERROR: Replenishment not successfully generated"
	EndIf 
	
#############################################################
# Private Scenarios:
#	Web Inventory Add Adjustments and Reason - Add adjustmnent refereces and reason
#	Web Inventory Check Location and Finish Adjustment - Complete and confirm the completion of the adjustment
#	Web Create Variable adjust_inventory_button on Location Screen - xpath representing the adjust inventory button
#	Web Create Variable location_status on Location Screen - xpath representing the screen's right-side status button
#	Web Create Variable error_toggle_yes on Adjustment Screen - xpath representing the "YES" state of the toggle control
#	Web Create Variable save_adjustment_button on Remove Inventory Screen - xpath to get to the Save Adjustment button
#	Web Create Variable add_inventory_button on Actions Menu - xpath to get to the Add Inventory button
#	Web Create Variable remove_inventory_button on Actions Menu - xpath to get to the remove inventory button
#	Web Create variable move_inventory_button on Move LPN Screen - xpath representing the move inventory button
#	Web Create variable relabel_lpn_button on LPN Screen - Create an xpath representing the Relabel LPN button on the Move Inventory Screen.
#	Web Click Attribute Dropdown on Adjustment Screen - xpath creation and click on the Drop Down arrow
#	Web Create variable modify_inventory_attribute_button on LPN Screen -Create an xpath representing the Modify Inventory Attribute.
#	Web Click Attribute Dropdown on Adjustment Screen - xpath creation and click on the Drop Down arrow
#	Web Create Variable Error Location on Actions Menu - xpath to get to the Error Location button
#	Web Create Variable Reset Location on Actions Menu - xpath to get to the Reset Location button
#	Web Clear Location Search Filter on Location Screen - xpath to clear location search filter button
#	Validate Location is not in Error - confirms location is not in error
#	Validate Location is in Error - confirms location is in error
#	Web Perform Error Location - sets location to error
#	Web Perform Reset Location - resets error location to original status
#	Get Storage Location Info from Location - use MSQL to get information on specified stoloc
#############################################################

@wip @private
Scenario: Web Inventory Check Location and Finish Adjustment
#############################################################
# Description: Complete and confirm the completion of the adjustment
# MSQL Files:
#	None
# Inputs:
#	Required:
#		stoloc - storage location
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "ensure the location will be reset from error status after adjustment"
	Then I execute scenario "Web Create Variable error_toggle_yes on Adjustment Screen"
	If I see element $error_toggle_yes in web browser within $wait_med seconds
		Then I click element $error_toggle_yes in web browser within $max_response seconds 
	EndIf
	
And I "click Save or Finish or Next button to complete the adjustment"
	Then I assign variable "elt_finish" by combining "xPath://span[starts-with(@id,'button') and text()='Finish']/.."
	And I assign variable "elt_next" by combining "xPath://span[starts-with(@id,'button') and text()='Next']/.."
	If I see element $elt_finish in web browser within $screen_wait seconds
		Then I click element $elt_finish in web browser within $max_response seconds
	ElsIf  I see element $elt_next in web browser within $screen_wait seconds
		Then I click element $elt_next in web browser within $max_response seconds
	Else I execute scenario "Web Create Variable save_adjustment_button on Remove Inventory Screen"
		And I click element $save_adjustment_button in web browser within $max_response seconds
	EndIf
	If I see "Approval is Required" in web browser within $wait_med seconds 
		Then I assign "TRUE" to variable "approval_required"
		And I press keys "ENTER" in web browser
	EndIf
	
And I "confirm return to the Location screen"
	Then I assign variable "elt" by combining "Location - " $stoloc
	Once I see $elt in web browser
	If I see "Error" in web browser within $wait_med seconds 
		Then I press keys "ENTER" in web browser
	EndIf

@wip @private
Scenario: Web Inventory Add Adjustments and Reason
#############################################################
# Description: Add adjustmnent refereces and reason in web
# MSQL Files:
#	None
# Inputs:
#	Required:
#		adjref1 - adjustment reference 1
#		adjref2 - adjusrment reference 2
#		reacod - reason code
#		dropdown_type - dropdown arrow reason type (reasonCode | adjustmentReason)
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "select the adjusment reason code"
	Then I execute scenario "Web Click Attribute Dropdown on Adjustment Screen"
	And I assign variable "elt" by combining "xPath://li[text()='" $reacod "']"
	When I click element $elt in web browser within $max_response seconds

And I "enter adjustment reference 1"
	Then I assign variable "elt" by combining "xPath://input[@name='adjustmentReference1']"
	And I click element $elt in web browser within $max_response seconds
	When I type $adjref1 in element $elt in web browser within $max_response seconds

And I "enter adjustment reference 2"
	Then I assign variable "elt" by combining "xPath://input[@name='adjustmentReference2']"
	And I click element $elt in web browser within $max_response seconds
	When I type $adjref2 in element $elt in web browser within $max_response seconds
	
@wip @private
Scenario: Web Create Variable adjust_inventory_button on Location Screen
#############################################################
# Description: Create an xpath representing the adjust inventory
# button on the Inventory Screen.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	adjust_inventory_button - xpath to adjust inventory button
#############################################################

Given I "create a xpath variable for Adjust Inventory button"
	Then I assign variable "elt" by combining $xPath "//span[text()='Adjust Inventory'"
	And I assign variable "elt" by combining $elt " and starts-with(@id,'menuitem-')"
	And I assign variable "elt" by combining $elt " and contains(@id,'-textEl')]"
	And I assign variable "adjust_inventory_button" by combining $elt "/.."

@wip @private
Scenario: Web Create Variable location_status on Location Screen
#############################################################
# Description: Create an xpath representing the screen's right-side status
# button representing the 3 possible states of the Location Screen
# (Empty, Partially Full, Empty)
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	location_status_partial - xpath to Status (Partially Full) button on Location screen
#	location_status_full - xpath to Status (Full) button on Location screen
#	location_status_empty - xpath to Status (Empty) button on Location screen
#############################################################

Given I "create a xpath variable for location status button"
	Then I assign variable "elt" by combining "xPath://td[@class='location-status'"
	And I assign variable "location_status_partial" by combining $elt " and text()='Partially Full']"
	And I assign variable "location_status_full" by combining $elt " and text()='Full']"
	And I assign variable "location_status_empty" by combining $elt " and text()='Empty']"

@wip @private
Scenario: Web Create Variable error_toggle_yes on Adjustment Screen
#############################################################
# Description: Create an xpath representing the "YES" state of the toggle
# control to keep Location in Error after adjustment.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	error_toggle_yes - xpath representing the "YES" state of toggle
#                      control to keep Location in Error after adjustment.
#############################################################

Given I "create a xpath variable for error toggle control"
	Then I assign variable "elt" by combining "xPath://div[@class='toggle_switch']"
	And I assign variable "elt" by combining $elt "/..//div[@type='checkbox'"
	And I assign variable "elt" by combining $elt " and text()='Yes']"
	And I assign variable "error_toggle_yes" by combining $elt

@wip @private
Scenario: Web Click Attribute Dropdown on Adjustment Screen
#############################################################
# Description: Create an xpath and click on the Drop Down arrow
# (to activate the dropdown) associated with choice dropdown control 
# (used in UOM, Reason Code, and other controls on Adjustment screen)
# MSQL Files:
#	None
# Inputs:
#	Required:
#		dropdown_type - dropdown control name such as uomCode, reasonCode, ..
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "generate a xpath and click on Drop Down arrow button"
	Then I assign variable "elt" by combining "xPath://input[@name='" $dropdown_type "']"
	And I assign variable "click_dropdown" by combining $elt "/../..//div[contains(@class, 'arrow-trigger')]"
	When I click element $click_dropdown in web browser within $max_response seconds

@wip @private
Scenario: Web Create Variable remove_inventory_button on Actions Menu
#############################################################
# Description: Generate a xpath to get to the remove inventory
# button in the Actions Menu/DropDown on the Location screen
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	remove_inventory_button - xpath to remove inventory button in menu
#############################################################

Given I "create a xpath variable for remove inventory button"
	Then I assign variable "elt" by combining $xPath "//span[text()='Remove Inventory'"
	And I assign variable "elt" by combining $elt " and starts-with(@id,'menuitem-')"
	And I assign variable "elt" by combining $elt " and contains(@id,'-textEl')]"
	And I assign variable "remove_inventory_button" by combining $elt "/.."

@wip @private
Scenario: Web Create Variable save_adjustment_button on Remove Inventory Screen
#############################################################
# Description: Generate a xpath to get to the Save Adjustment button
# on the remove Inventory Screen
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	save_adjustment_button - xpath to save adjustment button
#############################################################

Given I "create a xpath variable for save adjustment button"
	Then I assign variable "elt" by combining $xPath "//span[starts-with(@id,'button')"
	And I assign variable "elt" by combining $elt " and text()='Save']"
	And I assign variable "elt" by combining $elt "/../../../../.."
	And I assign variable "elt" by combining $elt "//div[starts-with(@id,'toolbar-')"
	And I assign variable "elt" by combining $elt " and contains(@id,'-targetEl')]"
	And I assign variable "elt" by combining $elt "//span[starts-with(@id,'button-')"
	And I assign variable "save_adjustment_button" by combining $elt " and contains(@id,'btnEl')]"

@wip @private
Scenario: Web Create Variable add_inventory_button on Actions Menu
#############################################################
# Description: Generate a xpath to get to the Add Inventory 
# button in the Actions Menu/DropDown on the Location screen
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	add_inventory_button - xpath to add inventory button in menu
#############################################################

Given I "create a xpath variable for add inventory button"
	Then I assign variable "elt" by combining $xPath "//span[text()='Add Inventory'"
	And I assign variable "elt" by combining $elt " and starts-with(@id,'menuitem-')"
	And I assign variable "elt" by combining $elt " and contains(@id,'-textEl')]"
	And I assign variable "add_inventory_button" by combining $elt "/.."

@wip @private
Scenario: Web Create variable move_inventory_button on Move LPN Screen
#############################################################
# Description: Create a xpath representing the move inventory
# button on the Move Inventory Screen.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	move_inventory_button - xpath to move inventory button
#############################################################

Given I "generate a xpath for the Move Inventory Button on Move LPN Screen"
	Then I assign variable "elt" by combining $xPath "//span[text()='Move Inventory'"
	And I assign variable "elt" by combining $elt " and starts-with(@id,'menuitem-')"
	And I assign variable "elt" by combining $elt " and contains(@id,'-textEl')]"
	And I assign variable "move_inventory_button" by combining $elt "/.."
    
@wip @private
Scenario: Web Create variable relabel_lpn_button on LPN Screen
#############################################################
# Description: Create a xpath representing the Relabel LPN
# button on the Move Inventory Screen.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	relabel_lpn_button - xpath to relabel lpn button
#############################################################

Given I "generate a xpath for the Move Inventory Button on Move LPN Screen"
	Then I assign variable "elt" by combining $xPath "//span[text()='Relabel LPN'"
	And I assign variable "elt" by combining $elt " and starts-with(@id,'menuitem-')"
	And I assign variable "elt" by combining $elt " and contains(@id,'-textEl')]"
	And I assign variable "relabel_lpn_button" by combining $elt "/.."    
    
@wip @private
Scenario: Web Create variable modify_inventory_attribute_button on LPN Screen
#############################################################
# Description: Create a xpath representing the Modify Inventory Attribute.
# button on the Inventory Screen.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	modify_inventory_attribute_button - xpath to move inventory button
#############################################################

Given I "generate a xpath for the Modify Inventory Attribute Button on LPN Screen"
	Then I assign variable "elt" by combining $xPath "//span[text()='Modify Inventory Attributes'"
	And I assign variable "elt" by combining $elt " and starts-with(@id,'menuitem-')"
	And I assign variable "elt" by combining $elt " and contains(@id,'-textEl')]"
	And I assign variable "modify_inventory_attribute_button" by combining $elt "/.."
	
@wip @private
Scenario: Web Create Variable Error Location on Actions Menu
#############################################################
# Description: Generate a xpath to get to the error_location 
# button in the Actions Menu/DropDown on the Location screen
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	error_location - xpath to error_location in menu
#############################################################

Given I "create a xpath variable for error_location button"
	Then I assign variable "elt" by combining $xPath "//span[text()='Error Location'"
	And I assign variable "elt" by combining $elt " and starts-with(@id,'menuitem-')"
	And I assign variable "elt" by combining $elt " and contains(@id,'-textEl')]"
	And I assign variable "error_location" by combining $elt "/.."

@wip @private
Scenario: Web Create Variable Reset Location on Actions Menu
#############################################################
# Description: Generate a xpath to get to the reset_location 
# button in the Actions Menu/DropDown on the Location screen
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	reset_location - xpath to reset_location in menu
#############################################################

Given I "Create a xpath variable for reset_location button"
	Then I assign variable "elt" by combining $xPath "//span[text()='Reset Location'"
	And I assign variable "elt" by combining $elt " and starts-with(@id,'menuitem-')"
	And I assign variable "elt" by combining $elt " and contains(@id,'-textEl')]"
	And I assign variable "reset_location" by combining $elt "/.."

@wip @private
Scenario: Web Clear Location Search Filter on Location Screen
#############################################################
# Description: Generate a xpath to clears location search filter on the Location screen
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	close_loc_fliter - xpath to clears location search filter
#############################################################

Given I "create a xpath variable for close location fliter button"
	Then I assign variable "elt" by combining $xPath "//span[contains(@class,'x-btn-icon-el rp-icon-cancel-close ')]"
	And I assign variable "close_loc_fliter" by combining $elt "/.."

@wip @private
Scenario: Validate Location is not in Error
#############################################################
# Description: confirms that a location is not in error state
# MSQL Files: 
#	check_loc_error_sts.msql
# Inputs:
#	Required:
#		stoloc - storage location that needs confirmation
#	Optional:
#		None
# Outputs:
#	location_status - current status of the location
#############################################################

Given I "execute MSQL that confirms location is not in error and save the current status"
	Then I assign "check_loc_error_sts.msql" to variable "msql_file"
	And I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
		Then I assign row 0 column "locsts" to variable "location_status"
	Else I fail step with error message "ERROR: location is in error"
	Endif

@wip @private
Scenario: Validate Location is in Error
#############################################################
# Description: confirms that a location is in error state
# MSQL Files: 
#	validate_location_in_error.msql
# Inputs:
#	Required:
#		stoloc - storage location that needs confirmation.
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "execute MSQL that confirms location is in error"
	Then I assign "validate_location_in_error.msql" to variable "msql_file"
	And I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
		Then I echo "location set to error status"  
	Else I fail step with error message "ERROR: location is not in error"
	Endif
	
@wip @private
Scenario: Web Perform Error Location
#############################################################
# Description: Sets a location to error state
# MSQL Files:
#	None
# Inputs:
#	Required:
#		mode - if ERROR is set then location status changed to error
#       error_location - xpath to error_location in menu
#       close_loc_filter - xpath to clears location search filter     
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "set location to error"
	And I execute scenario "Web Create Variable Error Location on Actions Menu"
	Then I click element $error_location in web browser within $max_response seconds
	Once I see element "xPath://div[@role='textbox'][contains(.,'Would you like to error the selected locations?')]" in web browser

	Then I click element "xPath://text()[.='Yes']/ancestor::a[1]" in web browser within $max_response seconds
	And I wait $wait_short seconds

	And I execute scenario "Web Clear Location Search Filter on Location Screen"
	Then I click element $close_loc_fliter in web browser within $max_response seconds
	And I wait $wait_short seconds
	
@wip @private
Scenario: Web Perform Reset Location
#############################################################
# Description: Resets a location in error state to original status
# MSQL Files:
#	None
# Inputs:
#	Required:
#		mode - if RESET is set then location status changes to its original status from error.
#       reset_location - xpath to reset_location in menu
#       close_loc_filter - xpath to clears location search filter 
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "reset location to original status"
	And I execute scenario "Web Create Variable Reset Location on Actions Menu"
	Then I click element $reset_location in web browser within $max_response seconds
	Once I see element "xPath://div[@role='textbox'][contains(.,'Would you like to reset the selected locations?')]" in web browser

	Then I click element "xPath://text()[.='Yes']/ancestor::a[1]" in web browser within $max_response seconds
	And I wait $wait_short seconds

	And I execute scenario "Web Clear Location Search Filter on Location Screen"
	Then I click element $close_loc_fliter in web browser within $max_response seconds
	And I wait $wait_short seconds

@wip @private
Scenario: Get Storage Location Info from Location
#############################################################
# Description: This scenario returns information about a 
# specified storage location
# MSQL Files: 
#	get_location_information.msql
# Inputs:
#   Required:
#   	loc_to_use - storage location to use for gatherig information on
#       wh_id - warehouse ID
#	Optional:
#		None
# Outputs:
# 	sto_area_code - storage location area code
#	sto_aisle_id - storage location asile ID
#	sto_level - storage location Level
############################################################

Given I "retrieve infoprmation about the storage location"
	Then I assign $stoloc to variable "save_stoloc_value"
	Then I assign $loc_to_use to variable "stoloc"
	And I assign "get_location_information.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	And I assign $save_stoloc_value to variable "stoloc"
	And I unassign variable "save_stoloc_value"
    If I verify MOCA status is 0
		Then I assign row 0 column "arecod" to variable "sto_area_code"
		And I assign row 0 column "aisle_id" to variable "sto_aisle_id"
		And I assign row 0 column "lvl" to variable "sto_level"
	Else I fail step with error message "ERROR: Could not get information about the specified storage location"
	Endif

@wip @public
Scenario: Web Inventory Adjust With Approval Limits
#############################################################
# Description: This Scenario will perform the Adjustments in the Inventory
# MSQL Files:
#	None
# Inputs:
#	Required:
#		lodnum - Load number being adjusted in. Can be a fabricated number.
#		adj_untqty - Adjustable Quantity
#		reacodfull - Used for the reason code of the lotnum change.  Must be full description
#	Optional:
#		approval_needed - if set (TRUE) will expect dialog message about approval being needed
# Outputs:
#	None
#############################################################

Given I execute scenario "Create local xPaths"

When I "search for Inventory By LPN Number"
	Then I assign $lodnum to variable "string_to_search_for"
	And I assign "LPN" to variable "component_to_search_for"
	And I execute scenario "Web Component Search"
    
And I "select the Inventory from the grid" 
	When I click element "xPath://span[starts-with(@class,'rpux-count-btn-text') and text()='LPNs']/../..//span[contains(@class,'x-btn-icon-el')]" in web browser within $max_response seconds
	Then I click element $select_inv_xpath in web browser within $max_response seconds
    
And I "select the 'Actions' drop-down"
	When I click element "xPath://span[text()='Actions']/.." in web browser within $max_response seconds
    
And I "click on 'Adjust Inventory'"  
	When I click element "xPath://span[text()='Adjust Inventory']" in web browser within $max_response seconds
    
Then I "enter the UOM Code"    
	If I verify variable "uomcod" is assigned
	And I verify text $uomcod is equal to "Case" ignoring case
    	Then I assign variable "dropdown_type" by combining "uomCode"
		And I execute scenario "Web Click Attribute Dropdown on Adjustment Screen"
		And I assign variable "elt" by combining "xPath://li[text()='" $uomcod "']"
		When I click element $elt in web browser within $max_response seconds 
	Else I echo "using default UOM Code"
	EndIf 
    
And I "select the Quantity field and enter the adjustment quantity" 
	When I assign variable "elt" by combining "xPath://input[@name='quantity']"
	Then I clear all text in element $elt in web browser within $max_response seconds
	And I click element $elt in web browser within $max_response seconds
	And I type $adj_untqty in web browser
	And I press keys "ENTER" in web browser

And I "add adjustments and approval reason"
	Then I assign variable "dropdown_type" by combining "reasonCode"
	And I execute scenario "Web Inventory Add Adjustments and Reason"
    
And I "click on Finish" 
	Then I click element "xPath://span[text()='Finish']/.." in web browser within $max_response seconds   
    
Then I "click the 'OK' button to adjust the inventory"
	If I verify variable "approval_needed" is assigned
	And I verify text $approval_needed is equal to "TRUE"
    	Then I assign "xPath://span[contains(@class,'x-btn') and text()='OK']/.." to variable "elt"
		Once I see element $elt in web browser
		Once I see "The Adjustment requested is greater than permitted limit" in web browser
		And I click element $elt in web browser within $max_response seconds
	EndIf 
    
And I unassign variables "string_to_search_for,component_to_search_for"

@wip @public
Scenario: Web Approve Inventory Adjustments
#############################################################
# Description: This Scenario will perform the Approval for the Inventory Adjustments
# MSQL Files:
#	None
# Inputs:
#	Required:
#		lodnum - Load number being adjusted in. Can be a fabricated number.
#		adj_untqty - Adjustable Quantity
#		adjust_approval_reason - Used for the reason code inventory adjustment approval. Must be full description
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I execute scenario "Create local xPaths"

When I "search for Inventory by location"
	Then I assign $stoloc to variable "string_to_search_for"
	And I assign "Location" to variable "component_to_search_for"
	And I execute scenario "Web Component Search"
    
And I "select an LPN from the grid" 
	When I click element $select_adjust_xpath in web browser within $max_response seconds
    
And I "click on Approve Button"
	When I click element "xPath://span[starts-with(@class,'x-btn-inner x-btn-inner-center') and text()='Approve']/.." in web browser within $max_response seconds
    
And I "click on Reason code field and enter reason code"  
	When I click element "xPath://input[@name='reasonCode']" in web browser within $max_response seconds
	And I type $adjust_approval_reason in web browser
	And I assign variable "elt" by combining "xPath://li[text()='" $adjust_approval_reason "']"
	Then I click element $elt in web browser within $max_response seconds
    
And I "click the 'OK' button to adjust the inventory"
	When I click element $ok_to_adjust_xpath in web browser within $max_response seconds 
	And I wait $wait_med seconds
	And I click element "xPath://div[contains(@class,'wm-InventoryAdjustmentWithoutFailures')]//span[text()='OK']/.." in web browser within $max_response seconds

And I unassign variables "string_to_search_for,component_to_search_for"

@wip @public
Scenario: Validate Inventory Adjust With Approval Limits
#############################################################
# Description: This scenario will verify the adjustments to the Inventory has been
# done successfully or not
# MSQL Files:
#	validate_inventory.msql
# Inputs:
#	Required:
#		adj_untqty - quantity inventory was adjusted to
#	Optional:
#		None
# Outputs:
#	None            
#############################################################

Given I "validate Inventory Adjust With Approval Limits"
	Then I assign "validate_inventory.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
		Then I assign row 0 column "untqty" to variable "change_untqty"
		If I verify text $change_untqty is equal to $adj_untqty ignoring case
			Then I echo "Inventory Adjusted Successfully With Approval Limit"
		Else I fail step with error message "ERROR: Inventory did not adjust properly"    
		EndIf       	
	Else I fail step with error message "ERROR: validate_inventory.msql failed"
	Endif

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
#		None
# Outputs:
#	select_inv_xpath - xPath location to select inventory from terminal adjust
#	select_adjust_xpath - xPath location to approve inventory adjust
#	ok_to_adjust_xpath - OK Button on inventory adjust screen
#############################################################

Given I "create an xPath to Select the Inventory"
	Then I assign variable "elt" by combining $xPath ""
	And I assign variable "elt" by combining $elt "//tr[contains(@id,'rpMultiLevelGridView')]/descendant::div[contains(@class,'grid-row-checker')]"
	And I assign $elt to variable "select_inv_xpath"

Then I "create the xPath to Select the Inventory to Approve"
	Given I assign variable "elt" by combining $xPath ""
	And I assign variable "elt" by combining $elt "//tr[contains(@id,'record-ext-record')]/descendant::div[contains(@class,'grid-row-checker')]"
	And I assign $elt to variable "select_adjust_xpath"
    
And I "create the xPath to click the 'OK' button to Approve the Inventory Adjustments"
	Then I assign variable "elt" by combining $xPath ""
	And I assign variable "elt" by combining $elt "//span[contains(@class,'x-btn') and text()='OK']/.."
	And I assign $elt to variable "ok_to_adjust_xpath"
   
@wip @public
Scenario: Validate Cycle Count
#############################################################
# Description: Verify that a cycle count was generated or not
# MSQL Files:
#	validate_cycle_count.msql
# Inputs:
#	Required:
#		stoloc - storage location to check for cycle count
#		prtnum - part number
#	Optional:
#		None
# Outputs:
#	None            
#############################################################

Given I "validate Cycle Count"
	Then I assign "validate_cycle_count.msql" to variable "msql_file"
	And I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
		Then I echo "Cycle Count was generated"
	Else I fail step with error message "ERROR: Cycle Count was not generated"           	
	EndIf