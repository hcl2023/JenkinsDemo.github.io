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
# Utility: Mobile Yard Utilities.feature
# 
# Functional Area: Yard
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: Mobile
#
# Description:
# This Utility contains common scenarios for Mobile Yard features
#
# Public Scenarios:
#	- Mobile Yard Audit - This Scenario will perform yard audit relative to yard audit type requested
#	
# Assumptions:
# None
#
# Notes:
# None
#
############################################################ 
Feature: Mobile Yard Utilities

@wip @public
Scenario: Mobile Yard Audit
#############################################################
# Description: This Scenario will perform yard audit relative
# to yard audit type requested
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		yard_audit_type - type of yard audit scenario to run
#	Optional:
#		None
# Outputs:
#     None
#############################################################

	If I verify text $yard_audit_type is equal to "with_trailer" ignoring case
		Then I execute scenario "Mobile Yard Audit With Trailer"
	ElsIf I verify text $yard_audit_type is equal to "without_trailer" ignoring case
		Then I execute scenario "Mobile Yard Audit WithOut Trailer"
	Else I fail step with error message "ERROR: Invalid option for yard_audit_type"
	EndIf 

#############################################################
# Private Scenarios:
#	Mobile Yard Audit With Trailer - This Scenario will perform Audit by passing the trailer
#	Mobile Accept And Exit Yard Audit - This will accept the Audit and exit the Audit
#	Mobile Yard Audit WithOut Trailer - This Scenario will Perform Audit without providing any fields
#	Mobile Yard Audit With Missing Trailer - This Scenario will Perform Yard Audit To Location missing Equipment
#############################################################

@wip @private
Scenario: Mobile Yard Audit With Trailer
#############################################################
# Description: This Scenario will Perform Audit by passing Trailer
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		trlr_id - Trailer Number
#	Optional:
#		None
# Outputs:
#     None
#############################################################

Given I "acknowledge directed work"
	Once I see "Audit Equip At" in element "className:appbar-title" in web browser
	If I see element "xPath://span[contains(text(),'Next [Enter]')]" in web browser within $screen_wait seconds
		Then I press keys "ENTER" in web browser
		And I wait $screen_wait seconds
	EndIf
	Once I see "Audit Equip" in element "className:appbar-title" in web browser

Then I "enter required trailer ID"
	And I assign "Transport Equipment Number" to variable "input_field_with_focus"
	Then I execute scenario "Mobile Check for Input Focus Field"
	And I type $trlr_id in element "name:trlnum" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

And I execute scenario "Mobile Accept And Exit Yard Audit"

@wip @private
Scenario: Mobile Accept And Exit Yard Audit
#############################################################
# Description: This will Accept the Audit and Exit the Audit
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		None
#	Optional:
#		None
# Outputs:
#     None
#############################################################

Given I "accept Audit"
	Once I see "Audit Equip" in element "className:appbar-title" in web browser

	Then I assign "Accept?" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		Then I press keys "Y" in web browser
    Else I "sometimes see carrier input is requested, press enter"
    		Then I press keys "ENTER" in web browser
    		If I see element $mobile_dialog_elt in web browser within $wait_med seconds
        		Then I press keys "Y" in web browser
			EndIf
	EndIf
    
Then I "complete the audit"    
	Once I see "Audit Equip" in element "className:appbar-title" in web browser
	And I press keys "F6" in web browser

	Then I assign "Exit Audit?" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
    
    When I press keys "F6" in web browser
	If I see $mobile_dialog_elt in element "className:appbar-title" in web browser within $wait_long seconds
	Else I "sometimes do not see F6 activate completing Audit, retry"
    		And I press keys "F6" in web browser
	EndIf
	And I execute scenario "Mobile Wait for Processing" 
    
And I "acknowledge audit is complete" 
	Once I see element $mobile_dialog_elt in web browser
	Then I press keys "Y" in web browser

	Then I assign "Done Auditing Location?" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	Once I see element $mobile_dialog_elt in web browser
	And I press keys "Y" in web browser

@wip @private
Scenario: Mobile Yard Audit WithOut Trailer
#############################################################
# Description: This Scenario will Perform Audit without providing any fields
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		yard_loc - Yard Location
#	Optional:
#		None
# Outputs:
#     None
#############################################################

Given I "acknowledge directed work"
	Once I see "Audit Equip At" in element "className:appbar-title" in web browser
	If I see element "xPath://span[contains(text(),'Next [Enter]')]" in web browser within $screen_wait seconds
		Then I press keys "ENTER" in web browser
		And I wait $screen_wait seconds
	EndIf
	Once I see "Audit Equip" in element "className:appbar-title" in web browser

And I "type enter in the required fields"
	Then I assign "Transport Equipment Number" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I press keys "ENTER" in web browser
	And I wait $screen_wait seconds
    
    Once I see "Audit Equip" in element "className:appbar-title" in web browser

And I execute scenario "Mobile Accept And Exit Yard Audit"

@wip @private
Scenario: Mobile Yard Audit With Missing Trailer
#############################################################
# Description: This Scenario will Perform Yard Audit To Location missing Equipment
# MSQL Files:
#	None
# Inputs:
# 	Required:
# 		trlr_id - Trailer Number
#	Optional:
#		None
# Outputs:
#     None
#############################################################

Given I "acknowlegde directed work"
	Once I see "Audit Equip At" in element "className:appbar-title" in web browser
	If I see element "xPath://span[contains(text(),'Next [Enter]')]" in web browser within $screen_wait seconds
		Then I press keys "ENTER" in web browser
		And I wait $screen_wait seconds
	EndIf
	Once I see "Audit Equip" in element "className:appbar-title" in web browser

And I "enter trailer Number and Carrier"
	Then I assign "Transport Equipment Number" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $trlr_id in element "name:trlnum" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
    
And I execute scenario "Mobile Accept And Exit Yard Audit"