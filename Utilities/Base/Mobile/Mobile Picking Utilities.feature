###########################################################
# Copyright 2020, Tryon Solutions, Inc.
# All rights reserved.  Proprietary and confidential.
#
# This file is subject to the license terms found at 
# https://www.cycleautomation.com/enduserlicenseagreement/
#
# The methods and techniques described herein are considered
# confidential and/or trade secrets. 
# No part of this file may be copied, modified, propagated,
# or distributed except as authorized by the license.
############################################################ 
# Utility: Mobile Picking Utilities.feature
# 
# Functional Area: Picking
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Utility
# Blue Yonder Interfaces Interacted With: Mobile
#
# Description: Utilities that are common across all Mobile picking operations
#
# Public Scenarios:
#	 - Mobile Cancel Pick from Tools Menu - From the Tools Menu, cancel a pick
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Mobile Picking Utilities

@wip @public
Scenario: Mobile Cancel Pick from Tools Menu
#############################################################
# Description: From the Tools Menu, cancel a pick
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		cancel_code - cancel code - defaults to "C-N-R" if not specified
#		error_location_flag - error location on cancel of pick (TRUE|FALSE)
# 	Optional:
#		None
# Outputs:
# 	work_assignment_loop_done - set to TRUE on list pick completion
#############################################################
   
Given I "open the Tools Menu"
	When I press keys "F7" in web browser
	Once I see "Tools Menu" in element "className:appbar-title" in web browser

And I "select the Cancel Pick option"
	Then I click element "xPath://span[contains(text(),'Cancel Pick') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Cancel Pick" in element "className:appbar-title" in web browser

    If I verify variable "cancel_code" is assigned
	And I verify text $cancel_code is not equal to ""
    ElsIf I assign "C-N-R" to variable "cancel_code"
	EndIf
	Then I type $cancel_code in element "name:codval" in web browser within $max_response seconds 
	And I press keys "ENTER" in web browser
	And I wait $screen_wait seconds

And I "Respond to 'error the location' question"
	If I verify text $error_location_flag is equal to "TRUE" ignoring case
		Then I type "Y" in web browser
	Else I type "N" in web browser
	EndIf
	And I press keys "ENTER" in web browser
		
And I "confirm the cancellation"
	Then I assign "OK To Cancel Pick?" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	Once I see element $mobile_dialog_elt in web browser
	Then I type "Y" in web browser
	And I wait $wait_short seconds

	Then I assign "Pick Canceled" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $wait_med seconds
	ElsIf I assign "Pick Successfully" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
    And I see element $mobile_dialog_elt in web browser within $wait_med seconds
	Else I fail step with error message "ERROR: Error during pick cancellation"
	EndIf
	Then I press keys "ENTER" in web browser
	And I wait $wait_short seconds
    
    Then I "validate that the List is complete, if appicable"
	And I assign "List Pick Completed" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $wait_med seconds
		Then I press keys "ENTER" in web browser
		And I assign "TRUE" to variable "work_assignment_loop_done"
	EndIf

Then I "exit the Tools Menu"
	Once I see "Tools Menu" in element "className:appbar-title" in web browser
	Then I press keys "F1" in web browser