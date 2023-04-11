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
# Utility: Work Assignment Utilities.feature
# 
# Functional Area: Work Management
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Utility
# Blue Yonder Interfaces Interacted With: MOCA
#
# Description:
# This utility contains scenarios for assigning users and priorities to work in the WMS
#
# Public Scenarios:  
#	- Assign Work to User by Order and Operation - Assigns a WMS  user to all the picks for an order and operation code
#	- Assign Work to User by Operation and Lodnum - Assigns directed work to user based on oprcod and lodnum
#	- Assign Transfer Directed Work - Assign transfer operation work to current user
#	- Assign Work to User by Count Batch and Count Type - Assigns work to user with priority based on count type and batch
#	- Assign Work Order Picks to User - finds available work order picks
#	- Assign User to Loading Work for Door - assigns a user to the loading work associated with a dock door
#	- Web Assign User to Work Queue - assigns a User to Work in the Web
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Work Assignment Utilities

@wip @public
Scenario: Assign Work to User by Order and Operation
#############################################################
# Description: This scenario assigns available order picks based on the Order number 
# and Operation to the user and unassigns any other work
# MSQL Files:
# 	assign_work_to_user_by_order_and_operation.msql
# Inputs:
# 	Required:
#		oprcod - Operation Code
#		username - User to assign work to
#		client_id - Client Id for Order
#	Optional:
#		ordnum - Work Order number
# Outputs:
#	None
#############################################################

Given I "check for available Work Order picks based on the Work Order number/revision and assign it to the user"
   	And I assign "assign_work_to_user_by_order_and_operation.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
    Then I verify MOCA status is 0

@wip @public
Scenario: Assign Transfer Directed Work
#############################################################
# Description: Assign transfer work operation to current user
# MSQL Files:
#	assign_transfer_work.msql
# Inputs:
#	Required:
#		srcloc - source location for the transfer
#		username - User to assign work to
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "assign transfer work"
	Then I assign "assign_transfer_work.msql" to variable "msql_file"
 	When I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
	Else I fail step with error message "ERROR: Could not assign directed work for transfer operation to user"
	EndIf

@wip @public
Scenario: Assign Work to User by Operation and Lodnum
#############################################################
# Description: This scenario assigns available inventory transfer work based
# on the lodnum assigned to the user and unassigns any other work
# MSQL Files:
#	assign_work_to_user_by_inv_transfer.msql
# Inputs:
#	Required:
#		xfer_lodnum - load being transfered
#		username - User to assign work to
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "check for available inventory transfers and assign it to the user"
    And I assign "TRN" to variable "oprcod"
   	And I assign "assign_work_to_user_by_inv_transfer.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
    If I verify MOCA status is 0
    ElsIf I fail step with error message "ERROR: Attemtpt to assign directed work failed"
    Endif

@wip @public
Scenario: Assign Work to User by Count Batch and Count Type
#############################################################
# Description: This scenario assigns available count work based on the count type and
# count batch to the user and unassigns any other work
# MSQL Files:
#	assign_work_to_user_by_count_type_and_batch.msql
# Inputs:
#	Required:
#		cnttyp - Count type
#		username - User to assign work to
#		cntbat - Batch for this count
#	Optional:
#		cnt_id - Count ID (Audit work)
# Outputs:
#	None
#############################################################

Given I "check for available Count work on the count batch and assign it to the user"
    If I verify variable "cnt_id" is assigned
    	If I verify variable "cntbat" is assigned
		Else I assign $cnt_id to variable "cntbat"
		EndIf
	EndIf
   	And I assign "assign_work_to_user_by_count_type_and_batch.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
    If I verify MOCA status is 0
    ElsIf I fail step with error message "ERROR: Attemtpt to assign directed work failed"
    Endif

@wip @public
Scenario: Assign Work Order Picks to User
#############################################################
# Description: This scenario assigns available work order picks based on the Work Order number
# and revision to the user and unassigns any other work
# MSQL Files:
#	get_list_picking_directed_work_for_work_order.msql
# Inputs:
#	Required:
#		oprcod - Operation Code
#		username - User to assign work to
#		wkonum - Work Order number
#		wkorev - Work Order revision
#	Optional:
#		None
# Outputs:
#	work_order_picks
#############################################################

Given I "check for available Work Order picks based on the Work Order number/revision and assign it to the user"
   	Then I assign "get_list_picking_directed_work_for_work_order.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	And I assign 1 to variable "work_order_picks"

@wip @public
Scenario: Assign User to Loading Work for Door
#############################################################
# Description: This scenario runs an MSQL script to assign a user to 
# the loading work associated with a dock door.
# MSQL Files:
#	assign_loading_work.msql     
# Inputs:
#	Required:
#		wh_id - Warehouse Id
#		username - Username signed into terminal
#		dock_door - Dock Door
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "assign variables to moca variables and execute MSQL"
	Then I assign "assign_loading_work.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	And I verify MOCA status is 0

@wip @public
Scenario: Web Assign User to Work Queue
#############################################################
# Description: This scenario will Assign User to Work Queue
# MSQL Files:
#	None
# Inputs:
#	Required:
#		yard_loc - yard location
#		username - Web username to assign work to
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "search for location to assign user"
	Then I assign variable "elt" by combining "xPath://div[contains(@id,'wm-common-workqueueoperationsgrid')]/descendant::input[contains(@id,'rpFilterComboBox-')]"
	And I click element $elt in web browser within $max_response seconds
	And I clear all text in element $elt in web browser
	And I assign variable "yard_search_string" by combining "source=" $yard_loc
	And I type $yard_search_string in element $elt in web browser
	And I press keys "ENTER" in web browser
    
Then I "select yard and click actions and assign user"    
	And I click element "xPath://tr[contains(@id,'rpMultiLevelGridView')]/descendant::div[contains(@class,'grid-row-checker')]" in web browser within $max_response seconds
	And I click element "xPath://span[text()='Actions']/.." in web browser within $max_response seconds
	And I click element "xPath://span[text()='Assign User']" in web browser within $max_response seconds
    
And I "click element select the user"   
	Then I assign variable "elt" by combining "xPath://td[contains(@id,'rpuxFilterComboBox')]/descendant::input[contains(@id,'rpuxFilterComboBox-')]"
	And I click element $elt in web browser within $max_response seconds
	And I clear all text in element $elt in web browser
	And I assign variable "user_search_string" by combining "login=" $username
	And I type $user_search_string in element $elt in web browser
	And I press keys "ENTER" in web browser
    
And I "select the user"
	Then I assign variable "elt" by combining $xPath "//td[contains(@class,'headerId-gridcolumn')]/descendant::div[text()='" $username "']"
	And I click element $elt in web browser within $max_response seconds
    And i click element "xPath://span[text()='Select']/.." in web browser within $max_response seconds
    Once I see element "xPath://div[contains(text(),'The selected work has been assigned')]" in web browser
    And I click element "xPath://span[text()='OK']/.." in web browser within $max_response seconds

And I "remove applied filter"
	Then I assign variable "elt" by combining "xPath://a[@data-qtip='Delete']"
	If I see element $elt in web browser within $screen_wait seconds
		Then I click element $elt in web browser within $max_response seconds
	EndIf

And I unassign variables "yard_search_string,user_search_string"

#############################################################
# Private Scenarios:
#	None
#############################################################