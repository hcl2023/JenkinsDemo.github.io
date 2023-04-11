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
# Utility: Terminal Unpick Utilities.feature
# 
# Functional Area: Picking
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Utility
# Blue Yonder Interfaces Interacted With: MOCA, Terminal
#
# Description:
# This Utility contains utility scenarios to perform unpick functionality in the terminal
#
# Public Scenarios:
#	- Terminal Perform Unpick - Performs a terminal unpick operation
#	- Terminal Navigate to Unpick Menu - Navigate to the terminal unpick menu
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Terminal Unpick Utilities

@wip @public
Scenario: Terminal Perform Unpick
#############################################################
# Description: Performs a Terminal Unpick operation in terminal
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		pck_lodnum - Pick load to be unpicked
#		unpick_partial - Flag indicating partial or full unpick
#		cancod - Cancel Code
#		putaway_method - Type of putaway for unpicked inventory
# 	Optional:
#       None
# Outputs:
#	None
#############################################################

Given I "verify I am on the unpick screen"
	Once I see "Unpick" on line 1 in terminal

Then I "enter the lodnum to be unpicked"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 2 column 5 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 2 column 6 in terminal 
	EndIf 
	Then I enter $pck_lodnum in terminal
	
When I "check for partial unpick and LPN error conditions"
	If I see "unpick partial" in terminal within $wait_med seconds
		Then I wait $wait_short seconds 
		If I verify text $unpick_partial is equal to "Y"
			Then I "am performing a partial unpick"
				Given I type "Y" in terminal
				And I wait $wait_short seconds
				Then I execute scenario "Terminal Perform Unpick Partial"
		Else I type "N" in terminal
		EndIf       
	Elsif I see "identifier" in terminal
	And I see "invalid" in terminal
		Then I fail step with error message "ERROR: The load number to be unpicked is invalid"   
	Elsif I see "Identifier Is Not" in terminal
	And I see "Picked Inventory" in terminal
		Then I fail step with error message "ERROR: The load number to be unpicked is not picked inventory"
	EndIf 
	
And I "enter the cancel code for the unpick"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 15 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 7 column 14 in terminal
	EndIf
	Then I enter $cancod in terminal
	If I see "Unpicked -" in terminal within $wait_med seconds 
		Then I press keys "ENTER" in terminal
	EndIf 
	And I wait $wait_short seconds
	
And I "force putaway if the vehicle load limit is more than 1"
	If I do not see "Product Putaway" in terminal within $wait_med seconds 
		Then I press keys "F6" in terminal
	EndIf
	Then I "choose a Putaway Method"
		Once I see "Product Putaway" in terminal 
		Then I type $putaway_method in terminal
		And I wait $wait_short seconds 
		If I see "Could Not Allocate" in terminal within $wait_med seconds 
			Then I press keys "ENTER" in terminal
		EndIf
		
When I "deposit the load"
	Then I execute scenario "Terminal Deposit"

@wip @public
Scenario: Terminal Navigate to Unpick Menu
#############################################################
# Description: Navigates to the Unpick screen from the Undirected Menu
# MSQL Files:
#	None
# Inputs:
# 	Required:
#   	None
# 	Optional:
#       None
# Outputs:
#	None
#############################################################

Given I "navigate to the Unpick Menu"
	Once I see "Picking Menu" in terminal
	Then I type option for "Picking Menu" menu in terminal
	Once I see "Unpick" in terminal 
	Then I type option for "Unpick" menu in terminal
	Once I see "Unpick" on line 1 in terminal
    And I verify screen is done loading in terminal within $max_response seconds
	
#############################################################
# Private Scenarios:
#	Terminal Perform Unpick Partial - Performs a partial Terminal Unpick
#############################################################

@wip @private
Scenario: Terminal Perform Unpick Partial
#############################################################
# Description: Performs a partial Terminal Unpick.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		client_id - Client
#		prtnum - Part Number
#		unpick_qty - Partial qty to unpick
#		unpick_to_lodnum - LPN to put partial unpicked inventory
# 	Optional:
#       None
# Outputs:
#	None
#############################################################

Given I "verify I am on the unpick (partial) screen"
	Once I see "Unpick" on line 1 in terminal

Given I "enter the client_id"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 5 column 6 in terminal 
	Else I verify text $term_type is equal to "vehicle" 
		Once I see cursor at line 2 column 32 in terminal
	EndIf 
	Then I execute scenario "Terminal Clear Field"
	And I enter $client_id in terminal

When I "enter the item number"
	Then I execute scenario "Terminal Clear Field"
	And I enter $prtnum in terminal
	If I see "no rows" in terminal within $wait_med seconds 
		Then I fail step with error message "ERROR: The item to unpick is not on this load"
	ElsIf I see "Invalid item" in terminal
		Then I fail step with error message "ERROR: The item number is invalid"
	EndIf
	
And I "enter the unpick quantity"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 10 column 6 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 5 column 6 in terminal
	EndIf 
	Then I execute scenario "Terminal Clear Field"
	And I enter $unpick_qty in terminal
	If I see "Un-pickable" in terminal within $wait_med seconds 
		Then I press keys "ENTER" in terminal
		And I fail step with error message "ERROR: Inventory to unpick exceeds what is available in the current load"
	EndIf
	
And I "acknowledge the uom for unpicking"
	And I press keys "ENTER" in terminal

And I "enter the destination load for the unpicked item if one is defined and this is a partial qty"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 13 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 6 column 20 in terminal
	EndIf
	If I verify variable "unpick_to_lodnum" is assigned
	And I verify text $unpick_to_lodnum is not equal to ""
		Then I enter $unpick_to_lodnum in terminal
		And I wait $wait_short seconds 
	Else I press keys "ENTER" in terminal
	EndIf