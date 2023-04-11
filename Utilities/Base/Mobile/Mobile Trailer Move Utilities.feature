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
# Utility: Mobile Trailer Move Utilities.feature
# 
# Functional Area: Yard
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Regression
# Blue Yonder Interfaces Interacted With: Mobile, MOCA
#
# Description:
# This Utility contains scenarios to perform actions specific to trailer moves in the Mobile App
#
# Public Scenarios:
# 	- Mobile Trailer Move - top-level move scenario in Mobile App
# 	- Mobile Verify and Escalate Directed Work - verifies if it is directed work and escalates if appropriate
#
# Assumptions:
# None
#
# Notes:
# - MOCA scenarios in support of this Utility are in Terminal Trailer Move Utilities.feature
#
############################################################
Feature: Mobile Trailer Move Utilities

@wip @public
Scenario: Mobile Trailer Move
#############################################################
# Description: This scenario moves a trailer using the Mobile App
# MSQL Files:
#	None
# Inputs:
#     Required:
#       trlr_num - Trailer Number
#       carcod - Carrier Code
#       move_to_dock_loc - Location trailer will be moved to
#       check_in_dock_loc - Location trailer will be checked in to
#		work_queue_or_immediate - Variable that indicates when the move is performed
#	Optional:
#		None
# Outputs:
#      None                        
#############################################################

If I verify variable "work_queue_or_immediate" is assigned
And I verify text $work_queue_or_immediate is equal to "work_queue" 
	Then I "have to go to the yard work screen to get my trailer move"
		And I execute scenario "Mobile Navigate to Select Yard Menu"
        
		Once I see "Work Selection" in element "className:appbar-title" in web browser

		Once I see $move_to_dock_loc in web browser 
		Once I see $check_in_dock_loc in web browser 
		Then I press keys "ENTER" in web browser
		
Else I "have to go to the Pickup Equipment Screen Manually (immediate case)"
	And I execute scenario "Mobile Navigate to Shipment Pickup Equipment Menu"
    
	Once I see "Transport Equipment Number" in web browser
	Once I see "Carrier" in web browser
	Once I see "Source Location" in web browser
    
    Then I assign "Transport Equipment Number" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $trlr_num in element "name:trlr_num" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	
	Then I assign "Carrier" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I press keys "ENTER" in web browser
EndIf 

And I "verify I am ready to enter data"
	Then I assign "Source Location" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $check_in_dock_loc in element "name:srcloc" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	Once I see $carcod in web browser

And I "acknowledge it's OK to move transport equipment"  
	Then I assign "Ok to move transport equipment?" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	Once I see element $mobile_dialog_elt in web browser
	Then I press keys "Y" in web browser

And I "move the trailer to the destination location (equip deposit screen)"
	Once I see $trlr_num in web browser
	Once I see $check_in_dock_loc in web browser
	Once I see $carcod in web browser
 
	Then I assign "Deposit To" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $move_to_dock_loc in element "name:dstloc" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	
    Then I assign "OK To Begin Activity?" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	Once I see element $mobile_dialog_elt in web browser
	Then I press keys "Y" in web browser

And I "confirm operation is complete and return to the Undirected Menu"
	Then I assign "Equip Deposited" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	Once I see element $mobile_dialog_elt in web browser
	Then I press keys "ENTER" in web browser
    
	Then I assign "No more eligible work for user" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		Then I press keys "ENTER" in web browser
	EndIf

	Then I press keys "F1" in web browser 2 times with $wait_short seconds delay
	And I wait $wait_med seconds

@wip @public
Scenario: Mobile Verify and Escalate Directed Work
#############################################################
# Description: This scenario verifies directed work is required and escalates it if so
# MSQL Files:
#	None
# Inputs:
# 	Required:
#       trlr_num - Trailer Number
#       carcod - Carrier Code
#       username - User performing the work
#       move_to_dock_loc - Location trailer will be moved to
#       check_in_dock_loc - Location trailer will be checked in to
#		work_queue_or_immediate - Variable that indicates when the move is performed
#	Optional:
#		None
# Outputs:
# 		None                 
#############################################################

	If I verify variable "work_queue_or_immediate" is assigned
	And I verify text $work_queue_or_immediate is equal to "work_queue" 
		Then I execute scenario "Mobile Increase Trailer Move Directed Work Priority"
	Endif

#############################################################
# Private Scenarios:
#	Mobile Increase Trailer Move Directed Work Priority - escalates trailer move directed work
#############################################################

@wip @private
Scenario: Mobile Increase Trailer Move Directed Work Priority
#############################################################
# Description: This scenario escalates trailer move directed work
# Simply call Terminal version given it it's MOCA only.
# MSQL Files:
#	escalate_trailer_move_directed_work_priority.msql
# Inputs:
# 	Required:
#       trlr_num - Trailer Number
#       carcod - Carrier Code
#       username - User performing the work
#       move_to_dock_loc - Location trailer will be moved to
#       check_in_dock_loc - Location trailer will be check in to
#	Optional:
#		None
# Outputs:
# 		None      
#############################################################

	Given I execute scenario "Terminal Increase Trailer Move Directed Work Priority"