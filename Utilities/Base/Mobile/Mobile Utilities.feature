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
# Utility: Mobile Utilities.feature
# 
# Functional Area: General Mobile
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: Mobile, MOCA
#
# Description:
# This Utility contains general Mobile scenarios for the Web
#
# Public Scenarios:
#	- Mobile Login - Login to the Mobile App and process Work Information
#	- Mobile Logout - Will log out from the Mobile App
#	- Mobile Set Dialog xPath - construct xPath to Mobile dialog with expected message
# 	- Mobile Clear Field - Uses a shortcut to empty a mobile field
#	- Mobile Deposit - Performs either an Inventory, Load, or Product Deposit.
#	- Mobile Start Server Trace - Starts a Server Trace
#	- Mobile Start Device Trace - Starts a Device Trace
#	- Mobile Generate Screenshot - Generate a a mobile/web screenshot
#	- Mobile Check for Input Focus Field - Check for label of input field with input focus (top of screen)
#	- Mobile Wait for Processing - Waits until the Mobile App is done processing
#	- Mobile Set Work Area - Use F7 and User Options to set Work Area
# 
# Assumptions:
# 	None
#
# Notes:
# 	None
#
############################################################ 
Feature: Mobile Utilities

@wip @public
Scenario: Mobile Login
#############################################################
# Description: This scenario will Navigate to WMS's Mobile App
# screen and login to the Mobile App. It will also processes
# work information.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		browser - Browser name (set in Environment by default)
#		mobile_ui - Mobile App URL (set in Environment by default)
#		USERNAME - Username (This value comes from MOCA credentials)
#		PASSWORD - Password (This value comes from MOCA credentials)
#		mobile_credentials - Cycle Credential relative to Mobile testing
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "navigate to WMS main screen in Mobile App"
	Then I open $browser web browser
	And I wait $wait_short seconds 
	When I navigate to $mobile_ui in web browser

Then I "login to the Mobile App UI"	
	Then I execute scenario "Mobile Process Login Screen"

And I "enter the device id (try mobile_devcod and if not available, use devcod)"
	Then I execute scenario "Mobile Process Device Code"

And I "check to see if we are at the work information screen, if not log out and log back in"
	If I see "Work Information" in element "className:appbar-title" in web browser within $screen_wait seconds
		Then I assign "TRUE" to variable "past_work_information_screen"
	Else I assign "FALSE" to variable "close_browser_on_logout"
		And I assign "FALSE" to variable "past_work_information_screen"
		And I execute scenario "Mobile Logout"
        And I execute scenario "Mobile Process Login Screen"
		And I unassign variable "close_browser_on_logout"
		And I assign "TRUE" to variable "past_work_information_screen"
	EndIf

And I "check to see if we are requested to change orientation or size in demo URL"
	And I execute scenario "Mobile Adjust Size and Orientation"

And I "enter the location (try mobile_start_loc first and then fall back to start_loc if not available)"
	Once I see element "name:stoloc" in web browser
	If I verify variable "mobile_start_loc" is assigned
    And I verify text $mobile_start_loc is not equal to ""
		Then I "am using mobile_start_loc setting"
			And I type $mobile_start_loc in element "name:stoloc" in web browser within $max_response seconds
	Else I "am using start_loc setting"
    		And I type $start_loc in element "name:stoloc" in web browser within $max_response seconds
	EndIf
	And I press keys "ENTER" in web browser
    
And I "enter the vehicle type"
	Once I see element "name:vehtyp" in web browser
	Then I type $vehtyp in element "name:vehtyp" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser

And I "use default for work area"
	Once I see element "name:wrkare" in web browser
	And I clear all text in element "name:wrkare" in web browser
	And I click element "name:wrkare" in web browser
	If I verify variable "wrkarea" is assigned
	And I verify text $wrkarea is not equal to ""
		Then I type $wrkarea in web browser
	EndIf 
	And I press keys "ENTER" in web browser
    
Then I "verify you are in the Undirected Menu"
	Once I see "Undirected Menu" in element "className:appbar-title" in web browser

And I assign "FALSE" to variable "mobile_logged_off"
    
@wip @public 
Scenario: Mobile Logout
#############################################################
# Description: This scenario will log out of the WMS Mobile App
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

Given I "logout of the mobile app"
	Then I assign "OK To Logout?" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
    And I assign variable "mobile_logout_prompt" by combining $mobile_dialog_elt

	And I "attempt to cleanup from prior runs to be able to logout properly"
		If I verify text $past_work_information_screen is equal to "FALSE" ignoring case
			Then I execute scenario "Mobile Attempt to Cleanup State"
    	EndIf

	And I "check for inventory on device and navigate up Mobile menu with F1 until logout message is seen"
		Then I assign "0" to variable "loop_cnt_str"
    	And I convert string variable "loop_cnt_str" to integer variable "loop_cnt"
		And I assign "FALSE" to variable "recovery_mode"
    	While I do not see element $mobile_logout_prompt in web browser within $screen_wait seconds
		And I verify number $loop_cnt is not equal to 25
			Then I execute scenario "Mobile Check for Deposit"
			And I press keys "F1" in web browser
			And I increase variable "loop_cnt" by 1
    	EndWhile
		If I verify number $loop_cnt is equal to 25
			Then I close web browser
			And I fail step with error message "ERROR: Exhausted retry count trying to logout, explicitly closing browser from Cycle"
		EndIf

	Then I "logout making sure there is not inventory on device one last time"
		And I assign "End Of Day?" to variable "mobile_dialog_message"
		And I execute scenario "Mobile Set Dialog xPath"
		And I assign variable "mobile_end_of_day_prompt" by combining $mobile_dialog_elt

		While I see element $mobile_logout_prompt in web browser within $screen_wait seconds
    		Then I press keys "Y" in web browser
			And I wait $wait_short seconds
			If I do not see element "xPath://button[contains(@class,'submit-button') and contains(text(),'SIGN IN') and @name = 'submit' or @name = 'btnSubmit']" in web browser within $screen_wait seconds
			And I do not see element $mobile_end_of_day_prompt in web browser within $wait_short seconds
 				Then I execute scenario "Mobile Check for Deposit"
				And I press keys "F1" in web browser
			EndIf
		EndWhile

	And I "answer the End Of Day? question if present"
		If I see element $mobile_end_of_day_prompt in web browser within $screen_wait seconds
			Then I press keys "Y" in web browser
			Once I see element "xPath://button[contains(@class,'submit-button') and contains(text(),'SIGN IN') and @name = 'submit' or @name = 'btnSubmit']" in web browser
		EndIf
        
	And I "close the browser unless requested not to"
		If I verify variable "close_browser_on_logout" is assigned
		And I verify text $close_browser_on_logout is equal to "FALSE" ignoring case
    	Else I close web browser
		EndIf

And I unassign variables "mobile_logout_prompt,loop_cnt_str,loop_cnt,mobile_dialog_message"

And I assign "TRUE" to variable "mobile_logged_off"

@wip @public
Scenario: Mobile Check for Input Focus Field
#############################################################
# Description: Given passed in label of Input Field in Mobile App,
# generate xPath and check to make sure that is visible on Mobile App screen.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		input_field_with_focus - label of input field which has focus (top of screen) in Mobile App
#	Optional:
#		None
# Outputs:
#	None
#############################################################

	Given I assign variable "mobile_focus_elt" by combining "xPath://div[@class='mat-form-field-infix']/descendant::mat-label[contains(text(),'" $input_field_with_focus "')]"
	Once I see element $mobile_focus_elt in web browser
	And I unassign variable "input_field_with_focus"

@wip @public
Scenario: Mobile Set Dialog xPath
#############################################################
# Description: This scenario will set an xPath to the Dialog
# used for confirmations and messages by Mobile (relative to
# passed in expected message displayed in the dialog) 
# MSQL Files:
#	None
# Inputs:
#	Required:
#		mobile_dialog_message - message anticipated in dialog
#	Optional:
#		None
# Outputs:
#	mobile_dialog_elt - constructed xPath to the dialog
#############################################################

Given I "assign mobile_dialog_elt relative to passed in string mobile_dialog_message"
	Then I assign variable "mobile_dialog_elt" by combining "xPath://span[contains(text(), '" $mobile_dialog_message "')]/ancestor::mat-dialog-container[contains(@id, 'mat-dialog')]"

@wip @public
Scenario: Mobile Generate Screenshot
#############################################################
# Description: Generate a mobile screen shot. Will call standard
# web browser sreenshot step.
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

Given I "generate a mobile screenshot"
	Then I save web browser screenshot
 
@wip @public
Scenario: Mobile Clear Field
#############################################################
# Description: If the cursor is in a field, uses a shortcut to clear it
# NOTE: This shortcut sometimes takes you to the Tools Menu, consider using
# I clear all text step in web browser
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

Given I "clear the mobile field"
	When I press keys "CTRL" in web browser
	Then I press keys "ALT" in web browser
    And I press keys "F7" in web browser

@wip @public
Scenario: Mobile Deposit
#############################################################
# Description: Performs either an Inventory, Load, or Product Deposit.
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

Given I "check to see which type of deposit we are performing"
	Once I see " Deposit" in element "className:appbar-title" in web browser

	If I see "MRG Product Deposit" in element "className:appbar-title" in web browser within $screen_wait seconds
		Then I execute scenario "Mobile Product Deposit"
	ElsIf I see "MRG Deposit" in element "className:appbar-title" in web browser within $screen_wait seconds
        Then I execute scenario "Mobile Load Deposit"
    ElsIf I see "Inventory Deposit" in element "className:appbar-title" in web browser within $screen_wait seconds
		Then I execute scenario "Mobile Inventory Deposit"
    Else I fail step with error message "ERROR: Could not determine what type of deposit to perform"
    EndIf
 
@wip @public
Scenario: Mobile Start Server Trace
#############################################################
# Description: Starts a Server Trace in Mobile. Scenario will stop
# trace if running, and the restart.
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

Given I "open the Tools Menu"
	Then I press keys "F7" in web browser
    
	If I see "Tools Menu" in element "className:appbar-title" in web browser within $screen_wait seconds
		Then I "navigate to tracing screen"
			And I click element "xPath://span[contains(text(),'Utilities Menu') and contains(@class,'label')]" in web browser within $max_response seconds
			Once I see "Utilities Menu" in element "className:appbar-title" in web browser
			And I click element "xPath://span[contains(text(),'Server Tracing') and contains(@class,'label')]" in web browser within $max_response seconds
			Once I see "Server Tracing" in element "className:appbar-title" in web browser

		And I "stop trace if running"
    		Then I assign "OK To Stop Trace?" to variable "mobile_dialog_message"
			And I execute scenario "Mobile Set Dialog xPath"
			If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
				Then I press keys "Y" in web browser
				Once I see "Utilities Menu" in element "className:appbar-title" in web browser
				And I click element "xPath://span[contains(text(),'Server Tracing') and contains(@class,'label')]" in web browser within $max_response seconds
				Once I see "Server Tracing" in element "className:appbar-title" in web browser
		EndIf

		And I "start trace"
			Then I press keys "ENTER" in web browser 2 times with $wait_short seconds delay
			And I assign "OK To Start Trace?" to variable "mobile_dialog_message"
			And I execute scenario "Mobile Set Dialog xPath"
			If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
				Then I press keys "Y" in web browser
			EndIf

    	And I "exit tools menu"
			Then I press keys "F1" in web browser
			Once I see "Utilities Menu" in element "className:appbar-title" in web browser
			Then I press keys "F1" in web browser
			Once I see "Tools Menu" in element "className:appbar-title" in web browser
			Then I press keys "F1" in web browser
	EndIf

@wip @public
Scenario: Mobile Start Device Trace
#############################################################
# Description: Starts a Device Trace in Mobile. Scenario will stop
# trace if running, and the restart.
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

Given I "open the Tools Menu"
	Then I press keys "F7" in web browser
    
	If I see "Tools Menu" in element "className:appbar-title" in web browser within $screen_wait seconds
		Then I "navigate to tracing screen"
			And I click element "xPath://span[contains(text(),'Utilities Menu') and contains(@class,'label')]" in web browser within $max_response seconds
			Once I see "Utilities Menu" in element "className:appbar-title" in web browser
			And I click element "xPath://span[contains(text(),'Device Tracing') and contains(@class,'label')]" in web browser within $max_response seconds
			Once I see "Device Tracing" in element "className:appbar-title" in web browser

		And I "stop trace if running"
    		Then I assign "OK To Stop Device Trace?" to variable "mobile_dialog_message"
			And I execute scenario "Mobile Set Dialog xPath"
			If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
				Then I press keys "Y" in web browser
				Once I see "Utilities Menu" in element "className:appbar-title" in web browser
				And I click element "xPath://span[contains(text(),'Device Tracing') and contains(@class,'label')]" in web browser within $max_response seconds
				Once I see "Device Tracing" in element "className:appbar-title" in web browser
			EndIf

		And I "start trace"
			Then I press keys "ENTER" in web browser 2 times with $wait_short seconds delay
			And I assign "OK To Start Device Trace?" to variable "mobile_dialog_message"
			And I execute scenario "Mobile Set Dialog xPath"
			If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
				Then I press keys "Y" in web browser
			EndIf

		And I "exit tools menu"
			Then I press keys "F1" in web browser
			Once I see "Utilities Menu" in element "className:appbar-title" in web browser
			Then I press keys "F1" in web browser
			Once I see "Tools Menu" in element "className:appbar-title" in web browser
			Then I press keys "F1" in web browser
	EndIf

@wip @public
Scenario: Mobile Set Work Area
#############################################################
# Description: From F7 and Tools Menu and User Options, set Work Area
# MSQL Files:
#	None
# Inputs:
#	Required:
#		wrkarea - work area to be set
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "open the Tools Menu"
	Then I press keys "F7" in web browser
	Once I see "Tools Menu" in element "className:appbar-title" in web browser
    
Then I "navigate to the User Options / Set Home Work Area screen"
	And I click element "xPath://span[contains(text(),'User Options') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "User Options" in element "className:appbar-title" in web browser
	Then I click element "xPath://span[contains(text(),'Set Home Work Area') and contains(@class,'label')]" in web browser within $max_response seconds
	Once I see "Warehouse Management" in element "className:appbar-title" in web browser

When I "set work area"
	Then I assign "Home Work Area" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I clear all text in element "name:hmewrkare" in web browser
	And I click element "name:hmewrkare" in web browser
	Then I type $wrkarea in element "name:hmewrkare" in web browser
	And I press keys "ENTER" in web browser

	Then I assign "OK To Update?" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	Once I see element $mobile_dialog_elt in web browser
	Then I press keys "Y" in web browser

	Then I assign "Update Complete" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	Once I see element $mobile_dialog_elt in web browser
	Then I press keys "ENTER" in web browser

	Once I see "User Options" in element "className:appbar-title" in web browser
    
And I "back out of the tools menu"
	Then I press keys "F1" in web browser
	And I press keys "F1" in web browser

@wip @public
Scenario: Mobile Wait for Processing
#############################################################
# Description: Waits until the Mobile App is done processing
# TODO - NEED to INVESTIGATE if needed (do not see this message in Mobile, just rotating cicle)
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

Given I wait $screen_wait seconds

#############################################################
# Private Scenarios:
#	Mobile Process Device Code - Input Device Code and handle and errors
#	Mobile Inventory Deposit - From the Inventory Deposit Screen, deposits inventory
#	Mobile Product Deposit - Performs the product deposit for a given pick, load, or move
#	Mobile Process Login Screen - Process initial login screen including username/password
# 	Mobile Load Deposit - Deposits the load on the device to a location
#	Mobile Copy Deposit Location - Copies the Deposit Location from the Mobile App
#	Mobile Allocate Location - Gets an allocated location for deposit
#	Mobile Confirm Lodnum - Check to see if the system is configured to confirm lodnum
# 	Mobile Putaway Override - Override the Putaway Location
# 	Mobile Copy Deposit LPN - Copies the Deposit LPN from the Mobile App
#	Mobile Check for Deposit - Check to see if there is inventory on device and deposit
#	Mobile Adjust Size and Orientation - Allow for setting Portrait/Landscape or Tablet/Handheld display modes
#	Mobile Attempt to Cleanup State - Attempt to cleanup from prior test runs and mobile application state
#############################################################

@wip @private
Scenario: Mobile Attempt to Cleanup State
#############################################################
# Description: This scenario will attempt to cleanup from prior
# test runs and mobile application state. Nothing is guaranteed to
# cleanup depending on state (for instance if screen was left entering
# serial numbers).
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

Given I "attempt to cleanup from prior test runs and mobile state"
	Then I "try to cleanup a deposit screen visible in recovery mode"
		If I see " Deposit" in element "className:appbar-title" in web browser within $wait_short seconds
			And I press keys "F1" in web browser
			And I wait $wait_short seconds
			If I see " Deposit" in element "className:appbar-title" in web browser within $wait_short seconds
				Then I execute scenario "Mobile Deposit"
				And I press keys "F1" in web browser
			EndIf
		EndIf

	And I "try to cleanup a application dialog box asking for an ENTER response"
		If I see element "xPath://span[contains(text(),'OK [Enter]')]" in web browser within $wait_short seconds
			Then I press keys "ENTER" in web browser
		EndIf

	And I "try to cleanup a application dialog box asking for an Y/N response"
		If I see element "xPath://span[contains(text(),'No [N]')]" in web browser within $wait_short seconds
			Then I press keys "N" in web browser
		EndIf

@wip @private
Scenario: Mobile Process Login Screen
#############################################################
# Description: This scenario will perform the initial login
# on the Mobile App (username/password collection) 
# MSQL Files:
#	None
# Inputs:
#	Required:
#		USERNAME - Username (This value comes from MOCA credentials)
#		PASSWORD - Password (This value comes from MOCA credentials)
#		mobile_credentials - Cycle Credential relative to Mobile testing
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "am on initial Mobile Login screen provide username / password"
	Once I see element "xPath://button[contains(@class,'submit-button') and contains(text(),'SIGN IN') and @name = 'submit' or @name = 'btnSubmit']" in web browser
		Then I type USERNAME from credentials $mobile_credentials in element "id:username" in web browser within $max_response seconds
		And I type PASSWORD from credentials $mobile_credentials in element "id:password" in web browser within $max_response seconds
		And I click element "xPath://button[contains(@class,'submit-button') and contains(text(),'SIGN IN') and @name = 'submit' or @name = 'btnSubmit']" in web browser within $max_response seconds
		And I wait $screen_wait seconds

@wip @private
Scenario: Mobile Process Device Code
#############################################################
# Description: Enter the Device Code into the Mobile UI and
# handle any error conditions.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		mobile_devcod - mobile device code (try first)
#		devcod - standard device code (fall back if mobile_devcod is not set)
# Outputs:
#	None
#############################################################

Given I "process the mobile device code during login"
	If I verify variable "mobile_devcod" is assigned
    And I verify text $mobile_devcod is not equal to ""
		Then I "am using mobile_devcod setting"
			And I type $mobile_devcod in element "name:terminalId" in web browser within $max_response seconds
	Else I "am using devcod setting"
    		And I type $devcod in element "name:terminalId" in web browser within $max_response seconds
	EndIf
	And I press keys "ENTER" in web browser
    
Then I "check to see if device ID is invalid, if so close browser and exit with failure message"
	Then I assign variable "elt" by combining "xPath://mat-dialog-content[contains(text(),'is not configured')]/ancestor::mat-dialog-container[contains(@id,'mat-dialog')]"
	If I see element $elt in web browser within $screen_wait seconds
		Then I click element "xPath://span[text() = 'Close']" in web browser within $max_response seconds
		And I close web browser
		And I fail step with error message "ERROR: Device ID is incorrect and not configured for Mobile, please use appriopriate devcode/device ID for Mobile Access, closing browser"
	EndIf
    
And I "check if device is offline and try login again"
	If I see "Device could not contact server. Server might be offline" in web browser within $screen_wait seconds
    	Then I press keys "F1" in web browser
		And I wait $wait_short seconds
        If I see "Device could not contact server. Server might be offline" in web browser within $screen_wait seconds
        	Then I press keys "ENTER" in web browser
			And I wait $wait_short seconds
        EndIf
        And I execute scenario "Mobile Process Login Screen"
    EndIf

@wip @private
Scenario: Mobile Adjust Size and Orientation
#############################################################
# Description: Check to see and set Mobile screen orientation and
# Mobile screen size if using the /demo URL for the Mobile Application.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		mobile_screen_size_setting - set to Tablet, or any other setting (or blank) for HandHeld mode
#		mobile_screen_orientation_setting - set to Landscape, or any other setting (or blank) for Portrait mode
# Outputs:
#	None
#############################################################
    
Given I "check for Size and Orientation settings and ajust interface"
	If I verify variable "mobile_screen_size_setting" is assigned
	And I verify text $mobile_screen_size_setting is not equal to ""
		If I verify text $mobile_screen_size_setting is equal to "Tablet" ignoring case
		And I see element "xPath://div[@id='toggleSize']" in web browser within $screen_wait seconds
        	Then I click element "xPath://div[@id='toggleSize']/descendant::div[contains(@class,'mdc-switch__thumb')]" in web browser within $max_response seconds
			And I maximize web browser
		EndIf
	EndIf

	If I verify variable "mobile_screen_orientation_setting" is assigned
	And I verify text $mobile_screen_orientation_setting is not equal to ""
		If I verify text $mobile_screen_orientation_setting is equal to "Landscape" ignoring case
		And I see element "xPath://div[@id='toggleOrientation']" in web browser within $screen_wait seconds
        	Then I click element "xPath://div[@id='toggleOrientation']/descendant::div[contains(@class,'mdc-switch__thumb')]" in web browser within $max_response seconds
		EndIf
	EndIf

@wip @private
Scenario: Mobile Check for Deposit
#############################################################
# Description: Check to see if there is inventory on device and deposit
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

And I "answer the End Of Day? question if present"
	Then I assign "End Of Day?" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $wait_short seconds
		Then I press keys "Y" in web browser
	EndIf

And I "if not on login screen, check if inventory is on device that needs to be deposited"
	If I do not see element "xPath://button[contains(@class,'submit-button') and contains(text(),'SIGN IN') and @name = 'submit' or @name = 'btnSubmit']" in web browser
		Then I assign "FALSE" to variable "recovery_mode"
		And I assign "Inventory on Device must be deposited" to variable "mobile_dialog_message"
		Then I execute scenario "Mobile Set Dialog xPath"
		If I see element $mobile_dialog_elt in web browser within $wait_short seconds
			Then I assign "TRUE" to variable "recovery_mode"
			And I press keys "ENTER" in web browser
			If I see "MRG Deposit" in element "className:appbar-title" in web browser within $screen_wait seconds
				Then I execute scenario "Mobile Load Deposit"
			Elsif I see "Inventory Deposit" in element "className:appbar-title" in web browser within $screen_wait seconds
				Then I execute scenario "Mobile Inventory Deposit"
			Else I execute scenario "Mobile Product Deposit"
			EndIf
			And I assign "FALSE" to variable "recovery_mode"
		EndIf
	EndIf

@wip @private
Scenario: Mobile Putaway Override
#############################################################
# Description: Override the Putaway Location
# MSQL Files:
#	None
# Inputs:
#	Required:
#		over_code - the override code to be input
#		override_f2 - use F2 to select override code
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "start the Override by pressing F4"
	Then I press keys "F4" in web browser
	Once I see "Override Location" in element "className:appbar-title" in web browser
	Then I assign "Override Location Code" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"

Then I "override Code or use F2 to select code"
	If I verify variable "override_f2" is assigned
	And I verify text $override_f2 is equal to "TRUE" ignoring case
    	Then I press keys "F2" in web browser
		Once I see "Value Lookup" in element "className:appbar-title" in web browser
		And I assign variable "elt" by combining "xPath://span[contains(text(),'" $over_code "')]"
        And I click element $elt in web browser within $max_response seconds
        
		Then I assign "Override Location Code" to variable "input_field_with_focus"
		And I execute scenario "Mobile Check for Input Focus Field"
		And I press keys "ENTER" in web browser
    Else I clear all text in element "name:ovr_loc_cod" in web browser within $max_response seconds
		Then I type $over_code in element "name:ovr_loc_cod" in web browser within $max_response seconds
		And I press keys "ENTER" in web browser
	EndIf
	Once I see "Override Location" in element "className:appbar-title" in web browser
	Then I assign "Location" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	
And I "enter the Override Deposit Location"
	Then I type $over_dep_loc in element "name:dstloc" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	And I wait $wait_short seconds

And I "confirm the Override"
	Then I assign "OK To Override?" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		Then I press keys "Y" in web browser
	EndIf

And I "check for Unpickable"
	Then I wait $wait_short seconds
	And I assign "un-pickable" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		Then I press keys "Y" in web browser
	EndIf

Then I "ensure I am back on the Deposit Screen"
	Once I see "MRG" in element "className:appbar-title" in web browser
	Once I see "Deposit" in element "className:appbar-title" in web browser 
	
And I "check to see if the system is configured to confirm lodnum"
	Then I execute scenario "Mobile Confirm Lodnum"
	
And I "get the new Deposit Location from screen override any prior settnig of dep_loc"
	Then I assign "" to variable "dep_loc"
	And I execute scenario "Mobile Copy Deposit Location"

@wip @private
Scenario: Mobile Copy Deposit Location
#############################################################
# Description: Copies the suggested Deposit Location from the Mobile App
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	dep_loc - the deposit location suggested in the Mobile App
#############################################################

Given I "assign deposit location appropriately"
	If I verify variable "dep_loc" is assigned
	And I verify text $dep_loc is not equal to ""
		If I verify variable "recovery_mode" is assigned
        And I verify text $recovery_mode is equal to "TRUE" ignoring case
			Then I assign "" to variable "dep_loc"
		EndIf
	ElsIf I copy text inside element "xPath://span[contains(text(),'Location')]/ancestor::aq-displayfield[contains(@id,'dsploc')]/descendant::span[contains(@class,'data')]" in web browser to variable "dep_loc" within $max_response seconds
    	Then I verify text $dep_loc is not equal to "" ignoring case
	Else I assign "" to variable "dep_loc"
	EndIf

@wip @private
Scenario: Mobile Load Deposit
#############################################################
# Description: Performs a Load Deposit
# MSQL Files: 
#	check_confirm_lodnum.msql
# Inputs:
#	Required:
#		None
#	Optional:
#		dep_loc - the location to deposit to
#		recovery_mode - if set to TRUE, will deposit to the recovery deposit location
#		recovery_deploc - the recovery deposit location
#		allocate - if set to TRUE, will use the location allocated by WMS
#		override - if set to TRUE, will override the deposit location
#		validate_loc - if set to a location, will check to ensure the deposit location matches
# Outputs:
#	None
#############################################################

Given I "verify I am on the Deposit screen"
	Once I see "MRG Deposit" in element "className:appbar-title" in web browser
    
Then I "copy the LPN from the Mobile App, if applicable"
	Then I execute scenario "Mobile Copy Deposit LPN"

And I "check to see if the system is configured to confirm lodnum"
	Then I assign "check_confirm_lodnum.msql" to variable "msql_file"
	If I execute scenario "Perform MSQL Execution"
	And I verify MOCA status is 0
		Then I press keys "ENTER" in web browser
	EndIf
	
And I "copy the Deposit Location, if applicable"
	If I verify variable "dep_loc" is assigned
	And I verify text $dep_loc is not equal to ""
	Else I "copy the deposit location from the suggested location field"
		Then I execute scenario "Mobile Copy Deposit Location"
		And I "check if we are depositing to the Recovery Mode Deposit Location instead"
			If I verify text $dep_loc is equal to ""
			And I verify variable "recovery_mode" is assigned
			And I verify text $recovery_mode is equal to "TRUE"
			And I verify variable "recovery_deploc" is assigned
				Then I "am defaulting to recovery mode deposit location"
					And I assign $recovery_deploc to variable "dep_loc"
			EndIf
	EndIf

When I "am on the Deposit Location field"
	Once I see element "name:dstloc" in web browser

And I "want to allocate the Location"
	If I verify variable "allocate" is assigned
	And I verify text $allocate is equal to "TRUE"
	And I verify variable "recovery_mode" is assigned
	And I verify text $recovery_mode is equal to "FALSE"
		Then I execute scenario "Mobile Allocate Location"
	EndIf 
	
And I "want to override the Location, if applicable"
	If I verify variable "override" is assigned
	And I verify text $override is equal to "TRUE"
	And I verify variable "recovery_mode" is assigned
	And I verify text $recovery_mode is equal to "FALSE"
		Then I execute scenario "Mobile Putaway Override"
	EndIf 

And I "validate the directed storage location if needed"
	If I verify variable "validate_loc" is assigned
	And I verify text $validate_loc is not equal to ""
		If I see $validate_loc in web browser within $screen_wait seconds
			Then I "see the system has allocated the correct location"
		Else I assign variable "error_message" by combining "ERROR: System directed location does not match expected location"
			Then I fail step with error message $error_message
		EndIf 
	EndIf
	
And I "input the Deposit Location"
	Then I assign "Location" to variable "input_field_with_focus"
	And I execute scenario "Mobile Check for Input Focus Field"
	Then I type $dep_loc in element "name:dstloc" in web browser within $max_response seconds
	And I press keys "ENTER" in web browser
	
Then I "check for unpickable"
	And I wait $wait_short seconds
	And I assign "will cause the inventory un-pickable, continue?" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		Then I press keys "Y" in web browser
	EndIf 

And I "wait for the Deposit to complete"
	Then I execute scenario "Mobile Wait for Processing" 

Then I "unassign dep_loc in the event Mobile Deposit is being called from List Pick Set Down test case"
	If I verify variable "lpck_action" is assigned
		Then I unassign variable "dep_loc"
	EndIf

@wip @private
Scenario: Mobile Allocate Location
#############################################################
# Description: During a deposit, allocates the location for deposit.
# MSQL Files:
#	check_confirm_lodnum.msql
# Inputs:
#	Required:
#		None
#	Optional:
#		dep_loc - deposit location will be used for allocation location if set
# Outputs:
#	dep_loc - the shown allocated locations
#############################################################

Given I "allocate a location"
	Then I press keys "F3" in web browser
	Once I see "Blank for Any Loc" in web browser
    
	If I verify variable "dep_loc" is assigned
	And I verify text $dep_loc is not equal to "" ignoring case
		Then I type $dep_loc in element "name:dstloc" in web browser within $max_response seconds
		And I press keys "ENTER" in web browser
	Else I press keys "ENTER" in web browser
		Then I wait $wait_short seconds
		And I assign "Could Not Allocate Location" to variable "mobile_dialog_message"
		And I execute scenario "Mobile Set Dialog xPath"
		If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
			Then I press keys "ENTER" in web browser
			And I fail step with error message "ERROR: Could not allocate location"
		EndIf 
	EndIf
	Once I see "Deposit" in element "className:appbar-title" in web browser
	Once I see "MRG" in element "className:appbar-title" in web browser

And I "check to see if the system is configured to confirm lodnum"
	Then I execute scenario "Mobile Confirm Lodnum"

And I "get the allocated location"
	Then I execute scenario "Mobile Copy Deposit Location"
	And I verify text $dep_loc is not equal to "" ignoring case

@wip @private
Scenario: Mobile Confirm Lodnum
#############################################################
# Description: Check to see if the system is configured to confirm lodnum
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

Given I "check to make sure system is configured to confirm lodnum"
	Then I assign "check_confirm_lodnum.msql" to variable "msql_file"
	If I execute scenario "Perform MSQL Execution"
	And I verify MOCA status is 0
		Then I press keys "ENTER" in web browser
	EndIf

@wip @private
Scenario: Mobile Product Deposit
#############################################################
# Description: Performs the product deposit for a given pick,
# load, or move.
# MSQL Files: 
#	validate_shipment_is_staged.msql
# Inputs:
# 	Required:
#		None
# 	Optional:
#       None
# Outputs:
#	dep_lpn - the (last if multiples) LPN deposited
#	dep_lpn_list - list of LPNs deposited (will be set to dep_lpn if only one was deposited)
#	dep_loc - the location where load was deposited
#############################################################
    
Given I "navigate to the Deposit screen"
	If I see "MRG Product Deposit" in element "className:appbar-title" in web browser within $wait_med seconds
		Then I "am already in the product deposit screen"
	Else I press keys "F6" in web browser
		And I wait $screen_wait seconds
		Once I see "MRG Product Deposit" in element "className:appbar-title" in web browser
	EndIf

And I "verify Pick Completion"
	If I see "Directed Work" in web browser within $screen_wait seconds
		Then I click element "xPath://span[contains(text(),'Directed Work') and contains(@class,'label')]" in web browser within $max_response seconds
		If I see "deposited " in web browser within $wait_med seconds 
			Then I press keys "ENTER" in web browser
		EndIf 
	EndIf
    
And I "allocate the Location"
	If I verify variable "allocate" is assigned
	And I verify text $allocate is equal to "TRUE"
		Then I execute scenario "Mobile Allocate Location"
	EndIf 
	
And I "override the Location, if applicable"
	If I verify variable "override" is assigned
	And I verify text $override is equal to "TRUE"
		Then I press keys "ENTER" in web browser
		And I execute scenario "Mobile Putaway Override"
	EndIf


And I "enter the given Deposit Location for each Load"
	Then I assign "0" to variable "retry_cnt_str"
    And I convert string variable "retry_cnt_str" to integer variable "retry_cnt"

	And I assign "" to variable "dep_lpn_list"
	
	While I see " Deposit" in element "className:appbar-title" in web browser within $screen_wait seconds
    And I verify number $retry_cnt is not equal to 100

		And I "copy the LPN from the Mobile App and generate list of all dep_lpns seen in this deposit"
			Then I execute scenario "Mobile Copy Deposit LPN"

			If I verify variable "dep_lpn" is assigned
			And I verify text $dep_lpn is not equal to ""
			And I verify variable "dep_lpn_list" is assigned
				If I verify text $dep_lpn_list is not equal to ""
					Then I assign variable "dep_lpn_list" by combining $dep_lpn_list "," $dep_lpn
				Else I assign $dep_lpn to variable "dep_lpn_list"
				EndIf
			EndIf
    
		Then I "copy the deposit location from the Mobile App"
			And I execute scenario "Mobile Copy Deposit Location"

		And I "check if we are depositing to the Recovery Mode Deposit Location instead"
			If I verify text $dep_loc is equal to ""
			And I verify variable "recovery_mode" is assigned
			And I verify text $recovery_mode is equal to "TRUE"
			And I verify variable "recovery_deploc" is assigned
				Then I "am defaulting to recovery mode deposit location"
					And I assign $recovery_deploc to variable "dep_loc"
			EndIf

		And I "copy the LPN from the Mobile App"
			Then I execute scenario "Mobile Copy Deposit LPN"
            
		And I "enter the deposit location"
			If I verify variable "dep_loc" is assigned
			And I verify text $dep_loc is not equal to ""
        		Then I assign "Location" to variable "input_field_with_focus"
				And I execute scenario "Mobile Check for Input Focus Field"
				Then I type $dep_loc in element "name:dstloc" in web browser within $max_response seconds
				And I press keys "ENTER" in web browser
			Else I fail step with error message "ERROR: could not determine deposit location"
			EndIf
    
		And I "check for unpickable"
			Then I assign "un-pickable" to variable "mobile_dialog_message"
			And I execute scenario "Mobile Set Dialog xPath"
			If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
				Then I press keys "Y" in web browser
			EndIf

			Then I wait $screen_wait seconds
			And I increase variable "retry_cnt" by 1
	EndWhile

	If I verify number $retry_cnt is equal to 100
		Then I fail step with error message "ERROR: Failed to deposit within max attempts"
	EndIf

Then I ", if the deposited product is associated with an order or shipment, validate that Auto Staging is working as intended"
	And I assign "validate_shipment_is_staged.msql" to variable "msql_file"
	When I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
		Then I "have successfully validated the shipment was staged"
	ElsIf I verify MOCA status is 99990001
		Then I assign variable "error_message" by combining "ERROR: Shipment was not staged already and did not stage properly when it should have"
		And I fail step with error message $error_message
	Else I assign variable "error_message" by combining "ERROR: Failed to validate shipment was staged with dep_lpn " $dep_lpn " to dep_loc " $dep_loc
		Then I fail step with error message $error_message
	EndIf

And I unassign variables "retry_cnt,retry_cnt_str"
    
@wip @private
Scenario: Mobile Inventory Deposit
#############################################################
# Description: From the Mobile Inventory Deposit screen, 
# deposits all inventory on the device.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	dep_lpn - the LPN deposited
#############################################################
	
Given I "verify we are on the Inventory Deposit screen"
	Once I see "Inventory Deposit" in element "className:appbar-title" in web browser
	Once I see "ID:" in web browser

And I "navigate to the Load ID Field"
	Given I press keys "DOWN" in web browser
	And I wait $screen_wait seconds
	When I press keys "ENTER" in web browser
	And I wait $screen_wait seconds  
	Then I "check for Could Not Allocate prompt"   
		Once I do not see "Inventory Deposit" in web browser

		Then I assign "Could Not Allocate" to variable "mobile_dialog_message"
		And I execute scenario "Mobile Set Dialog xPath"
		If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
			Then I press keys "ENTER" in web browser
		EndIf

	And I wait $screen_wait seconds

And I "copy the LPN from the Mobile App, if applicable"
	Then I execute scenario "Mobile Copy Deposit LPN"

When I "deposit the Product"
	Given I "clear any potential deposit locations from previous deposits"
		Then I assign "" to variable "dep_loc"
        
	When I execute scenario "Mobile Load Deposit"
	
	Then I "unassign the deposit location for future deposits"
		And I unassign variable "dep_loc"

	Then I assign "Could Not Allocate" to variable "mobile_dialog_message"
	And I execute scenario "Mobile Set Dialog xPath"
	If I see element $mobile_dialog_elt in web browser within $screen_wait seconds
		Then I press keys "ENTER" in web browser
	EndIf

	If I see "MRG Deposit" in element "className:appbar-title" in web browser within $screen_wait seconds 
	    Then I execute scenario "Mobile Load Deposit"
	EndIf
	And I wait $screen_wait seconds
	
And I "check if there is more to deposit"
	If I see "Inventory Deposit" in element "className:appbar-title" in web browser within $screen_wait seconds 
		Then I execute scenario "Check for Deposit Options"
	ElsIf I see "MRG Deposit" in element "className:appbar-title" in web browser within $screen_wait seconds
		Then I execute scenario "Mobile Load Deposit"
		Once I do not see "MRG" in element "className:appbar-title" in web browser
		And I wait $screen_wait seconds 
	EndIf

@wip @private
Scenario: Mobile Copy Deposit LPN
#############################################################
# Description: Copies the Deposit LPN from the Mobile App
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	dep_lpn - the lodnum (LPN) to deposit shown in Mobile App
#############################################################

Given I "copy the deposit LPN from the Mobile App screen"
	If I see "Deposit" in element "className:appbar-title" in web browser
		Then I copy text inside element "xPath://span[contains(text(),'LPN')]/ancestor::aq-displayfield[contains(@id,'lodnum')]/descendant::span[contains(@class,'data')]" in web browser to variable "dep_lpn" within $max_response seconds
	EndIf