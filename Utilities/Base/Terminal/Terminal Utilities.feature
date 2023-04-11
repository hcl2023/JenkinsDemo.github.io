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
# Utility: Terminal Utilities.feature
# 
# Functional Area: Terminal
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Utility
# Blue Yonder Interfaces Interacted With: Terminal, MOCA
#
# Description: Utility Scenarios that perform generic terminal operations common to many processes.
#
# Public Scenarios:
# 	- Terminal Clear Field - Uses a shortcut to empty a terminal field
#	- Terminal Login - Performs a clean login from most terminal states
#	- Terminal Deposit - Performs either an Inventory, Load, or Product Deposit.
#	- Terminal Wait Until First Line Is Not Blank - Waits until the Terminal's first line is not blank
#	- Terminal Logout - Logs the Terminal out from most states
#	- Terminal Start Server Trace - Starts a Server Trace
#	- Terminal Start Device Trace - Starts a Device Trace
#	- Terminal Generate Screenshot - Generate a a terminal screenshot
#	- Terminal Set Work Area - Sets Work Area from the Tools and User Options screen
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Terminal Utilities

@wip @public
Scenario: Terminal Set Work Area
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
	Then I press keys "F7" in terminal
	Once I see "Tools Menu" in terminal
    
Then I "navigate to the User Options / Set Home Work Area screen"
	Given I type option for "User Options" menu in terminal
	Once I see "User Options" on line 1 in terminal
	Then I type option for "Set Home Work Are" menu in terminal
	Once I see "Home Work Area:" in terminal

When I "set work area"
	Then I execute scenario "Terminal Clear Field"
	And I enter $wrkarea in terminal
	Once I see "OK To Update?" in terminal
	Then I press keys "Y" in terminal
	Once I see "Update Complete" in terminal
	And I press keys "ENTER" in terminal
	Once I see "User Options" on line 1 in terminal

And I "back out of the tools menu"
	Then I press keys "F1" in terminal
	And I press keys "F1" in terminal

@wip @public
Scenario: Terminal Generate Screenshot
#############################################################
# Description: Generate a terminal screen shot. Given no explicit
# command in Cycle, the sequence below will generate screen shot.
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

Given I "generate a terminal screenshot"
	Then I see " " in terminal
 
@wip @public
Scenario: Terminal Clear Field
#############################################################
# Description: If the cursor is in a field, uses a shortcut to clear it
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
When I "clear the Field"
	When I press keys ESCAPE in terminal
	And I press keys "F7" in terminal

@wip @public
Scenario: Terminal Login
#############################################################
# Description: Will attempt a 'clean' login after connecting to the terminal.
# If certain conditions arise during login that indicate the device is not in
# a clean login state, this scenario will attempt to restore the device to
# a clean login screen and repeat the login process before proceeding.
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

Given I execute scenario "Terminal Validate Variables"

And I execute scenario "Connect and Set the Size of the Terminal"

When I "perform a clean login to the Terminal, regardless of its current state"
	Given I assign 1 to variable "login_loop"
	While I verify number $login_loop is equal to 1
		Given I assign 1 to variable "do_not_close"
		When I execute scenario "Check for Terminal ID Screen"
		And I execute scenario "Check for Login Screen"
		And I execute scenario "Check for Work Information Screen"
		And I execute scenario "Check for Recovery Mode"
		
		If I see "ndirected Menu" on line 1 in terminal within $wait_short seconds 
		And I verify number $term_logged_in is equal to 1
			Then I assign 0 to variable "login_loop"
		Else I echo "Execute the Scenarios Below If we were not able to successfully login"
			When I execute scenario "Check for Authentication Screen"
			And I execute scenario "Check for Terminal Questions"
			And I execute scenario "Check for F6"
			And I execute scenario "Check for Deposit Options"
			And I execute scenario "Terminal Logout"
		Endif
	EndWhile

Then I "verify we are at the Undirected Menu"
	Once I see "ndirected Menu" in terminal

@wip @public
Scenario: Terminal Deposit
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
	And I verify screen is done loading in terminal within $max_response seconds
	If I see "Product Deposit" on line 1 in terminal within $wait_long seconds
        Then I execute scenario "Terminal Product Deposit"
	ElsIf I see "MRG" on line 1 in terminal within $wait_long seconds
    And I see "Deposit" on line 1 in terminal within $wait_long seconds
        Then I execute scenario "Terminal Load Deposit"
    ElsIf I see "Inventory Deposit" on line 1 in terminal within $wait_long seconds 
		Then I execute scenario "Terminal Inventory Deposit"
    Else I fail step with error message "ERROR: Could not determine what type of deposit to perform"
    EndIf

@wip @public
Scenario: Terminal Wait Until First Line Is Not Blank
#############################################################
# Description: Waits until the Terminal's first line is not blank.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		no_process - if this is set to 1, then will not check for terminal processing
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I "check if we need to wait for terminal processing"
	If I verify variable "no_process" is assigned
	And I verify number $no_process is equal to 1
	Else I execute scenario "Terminal Wait for Processing"
	EndIf

When I "evaluate the First Line of the Terminal until it is not blank"
	And I assign 50 to variable "max_processing_loops"
	And I assign 0 to variable "processing_loops"
	While I verify number $processing_loops is less than $max_processing_loops
		If I copy terminal line 1 columns 1 through 20 to variable "first_line"
			Given I execute Groovy "first_line = first_line.trim()"
			If I verify text $first_line is equal to ""
				Then I "wait For Screen To Load" which can take between $wait_short seconds and $wait_med seconds 
			Else I "exit the loop"
				Then I increase variable "processing_loops" by $max_processing_loops
			Endif
		Else I echo "Could Not Copy First Line"
			Then I wait $wait_med seconds 
		Endif
		
		If I verify variable "term_logged_in" is assigned
		ElsIf I verify number $processing_loops is less than $max_processing_loops
		And I verify number $processing_loops is greater than 3
			Once I press keys "ENTER" in terminal
			Then I execute scenario "Check for Terminal Questions"
		Endif
		Then I increase variable "processing_loops" by 1
	EndWhile

Then I "clear variable artifacts"
	When I assign "" to variable "no_process"

@wip @public
Scenario: Terminal Logout
#############################################################
# Description: Logs out of the Terminal from most terminal states.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		do_not_close - If this is set to 1, it will not close the terminal subsequent to logout.
# Outputs:
#	None
#############################################################

Given I execute scenario "Terminal Navigate to Undirected Menu"

When I "logout"
	If I verify number $at_login_screen is equal to 1
	Else I echo "We should be a the Undirected Menu And we need to get to the login screen."
		Once I see "ndirected Menu" in terminal
		Given I press keys "F1" in terminal
		Given I execute scenario "Terminal Logout Questions And Possibly Deposit"
	Endif
	
Then I "verify that the terminal is logged out"
	Once I see "Login" in terminal
	Once I see "User ID:" in terminal
	Then I assign 0 to variable "term_logged_in"

And I "close the Terminal, if applicable"
	If I verify number $do_not_close is equal to 1
		Then I assign "" to variable "do_not_close"
	Else I echo "Attempt to Close the Terminal"
		Given I echo "We can sometimes receive an error here that Cycle could not get the data stream. We will attempt to close it a few times."
		And I assign 1 to variable "close_term_loop"
		And I assign 5 to variable "close_term_attempts"
		While I verify number $close_term_loop is less than or equal to $close_term_attempts
			If I close terminal
				Then I increase variable "close_term_loop" by $close_term_attempts
			Else I wait $wait_med seconds 
				Then I increase variable "close_term_loop" by 1
			Endif
		EndWhile
	Endif
 
@wip @public
Scenario: Terminal Start Server Trace
#############################################################
# Description: Starts a Server Trace
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
	Given I press keys "F7" in terminal

If I see "Tools Menu" in terminal within $screen_wait seconds 
	Given I type option for "Utilities Menu" menu in terminal
	Once I see "Server Tracing" in terminal
	Once I see cursor at line 12 column 15 in terminal
	Then I type option for "Server Tracing" menu in terminal
	Once I see "Trace File" in terminal
	Then I press keys "ENTER" in terminal 2 times with $wait_short seconds delay
	Once I see "OK To Start Trace" in terminal
	Then I type "Y" in terminal
	And I press keys "F1" in terminal
	And I press keys "F1" in terminal
EndIf 
 
@wip @public
Scenario: Terminal Start Device Trace
#############################################################
# Description: Starts a Device Trace
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

Given I press keys "F7" in terminal
If I see "Tools Menu" in terminal within $screen_wait seconds 
	Given I type option for "Utilities Menu" menu in terminal
	Once I see "Device Tracing" in terminal
	Once I see cursor at line 12 column 15 in terminal
	Then I type option for "Device Tracing" menu in terminal
	Then I press keys "ENTER" in terminal 2 times with $wait_short seconds delay
	Once I see "OK To Start Device Trace" in terminal
	Then I type "Y" in terminal
	And I press keys "F1" in terminal
	And I press keys "F1" in terminal
EndIf

@wip @public
Scenario: Get Location Verification Code
#############################################################
# Description: Gets the location verification code for a location
# MSQL Files: 
#	get_location_verification_code.msql
# Inputs:
#	Required:
#		verify_location - Location to be entered (this is unassigned)
#	Optional:
#		None
# Outputs:
#	location_verification_code
#############################################################

Given I "initialize the location variable"
    Then I verify variable "verify_location" is assigned
    
Then I "run msql to get the location verification code"
    When I assign "get_location_verification_code.msql" to variable "msql_file"
    And I execute scenario "Perform MSQL Execution" 
    If I verify MOCA status is 0
        Given I assign row 0 column "locvrc" to variable "location_verification_code"
    Else I assign variable "error_message" by combining "ERROR: Failed to get Location Verification Code for: " $verify_location
    	And I fail step with error message $error_message
    EndIf

And I unassign variable "verify_location"

#############################################################
# Private Scenarios:
# 	Terminal Load Deposit - Deposits the load on the device to a location
#	Terminal Inventory Deposit - From the Inventory Deposit Screen, deposits inventory
#	Terminal Product Deposit - Performs the product deposit for a given pick, load, or move
#	Terminal Validate Variables - validates that all variables for the Terminal Login scenario are assigned
#	Connect and Set the Size of the Terminal - Connects to the terminal based on device type, ensuring a clean start
#	Check for Terminal ID Screen - If on the Terminal ID screen, enters the Terminal ID 
#	Check for Login Screen - if on the Login screen, login to the Terminal
#	Check for Bad Login - If the Bad Login message is present, get back to the original Login state.
#	Check for Work Information Screen - If on the Work Information screen, enters the appropriate information
#	Check for Recovery Mode - deposits inventory to a Directed Putaway Location if present, if not, will be deposited to a Recovery Deposit Location.
# 	Check for Authentication Screen - From the Authentication screen, inputs the username and password, if applicable
#	Check for Terminal Questions - Answers any Terminal Questions
# 	Check for F6 - Presses F6, if applicable
#	Check for Deposit Options - From the Deposit Options screen, performs a deposit
#	Terminal Wait for Processing - Waits until the terminal is done processing
#	Terminal Logout Questions And Possibly Deposit
#	Allocate Location - Gets an allocated location for deposit
# 	Putaway Override - Override the Putaway Location
#	Terminal Copy Deposit Location - Copies the Deposit Location from the Terminal
# 	Terminal Copy Deposit LPN - Copies the Deposit LPN from the Terminal
#	Terminal Confirm Lodnun - Check to see if the system is configured to confirm lodnum
#############################################################

@wip @private
Scenario: Terminal Load Deposit
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
#	dep_lpn - the LPN deposited
#############################################################

Given I "verify I am on the Deposit screen"
	Once I see "MRG" on line 1 in terminal
	Once I see "Deposit" on line 1 in terminal

And I "check to see if the system is configured to confirm lodnum"
	Then I assign "check_confirm_lodnum.msql" to variable "msql_file"
	If I execute scenario "Perform MSQL Execution"
	And I verify MOCA status is 0
		If I verify text $term_type is equal to "handheld"
			Once I see cursor at line 3 column 1 in terminal
		Else I verify text $term_type is equal to "vehicle"
			Once I see cursor at line 2 column 7 in terminal
		EndIf 
		Then I press keys "ENTER" in terminal
	EndIf

And I "copy the Deposit LPN, if applicable" 
	Then I execute scenario "Terminal Copy Deposit LPN"
	
And I "copy the Deposit Location, if applicable"
	If I verify variable "dep_loc" is assigned
	And I verify text $dep_loc is not equal to ""
	Else I "copy the deposit location from the suggested location field"
		Given I "verify screen has loaded for information to be copied off of it"
			Then I verify screen is done loading in terminal within $max_response seconds

        Then I execute scenario "Terminal Copy Deposit Location"
		
		Then I "check if we are depositing to the Recovery Mode Deposit Location instead"
			If I verify text $dep_loc is equal to ""
			And I verify text $recovery_mode is equal to "TRUE"
			And I verify variable "recovery_deploc" is assigned
				Then I echo "defaulting to recovery mode deposit location"
				And I assign $recovery_deploc to variable "dep_loc"
			EndIf
	EndIf

When I "am on the Deposit Location field"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 15 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 8 column 7 in terminal
	EndIf 

And I "allocate the Location"
	If I verify variable "allocate" is assigned
    And I verify text $allocate is equal to "TRUE"
		Then I execute scenario "Terminal Allocate Location"
	EndIf 
	
And I "override the Location, if applicable"
	If I verify variable "override" is assigned
    And I verify text $override is equal to "TRUE"
		Then I execute scenario "Terminal Putaway Override"
	EndIf 

And I "validate the directed storage location if needed"
	If I verify variable "validate_loc" is assigned
	And I verify text $validate_loc is not equal to ""
		If I see $validate_loc in terminal
			Then I "see the system has allocated the correct location"
		Else I assign variable "error_message" by combining "ERROR: System directed location does not match expected location"
            Then I fail step with error message $error_message
		EndIf 
	EndIf 
	
And I "input the Deposit Location"
	When I enter $dep_loc in terminal
	
Then I "check for unpickable"
	If I see "un-pickable" in terminal within $screen_wait seconds
	And I see "Y" in terminal within $wait_short seconds
		Then I type "Y" in terminal
	EndIf 

And I "wait for the Deposit to complete"
	When I execute scenario "Terminal Wait for Processing" 

Then I "unassign dep_loc in the event Terminal Deposit is being called from List Pick Set Down test case"
	If I verify variable "lpck_action" is assigned
		Then I unassign variable "dep_loc"
	EndIf
    
@wip @private
Scenario: Terminal Product Deposit
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
	If I see "Deposit" on line 1 in terminal within $wait_med seconds
		Then I "am already in the deposit screen"
	Else I press keys "F6" in terminal
		And I see "Deposit" on line 1 in terminal within $wait_med seconds 
	EndIf

And I "verify Pick Completion"
    If I see "Directed Work" in terminal within $wait_med seconds 
        Then I type option for "Directed Work" menu in terminal
        If I see "deposited " in terminal within $wait_med seconds 
            Then I press keys "ENTER" in terminal
        EndIf 
    EndIf
    
And I "allocate the Location"
	If I verify variable "allocate" is assigned
	And I verify text $allocate is equal to "TRUE"
		Then I execute scenario "Terminal Allocate Location"
	EndIf 
	
And I "override the Location, if applicable"
	If I verify variable "override" is assigned
	And I verify text $override is equal to "TRUE"
    	Then I press keys "ENTER" in terminal
		And I execute scenario "Terminal Putaway Override"
	EndIf

And I "enter the given Deposit Location for each Load"
	Then I verify screen is done loading in terminal within $wait_med seconds
	And I assign "0" to variable "retry_cnt_str"
    And I convert string variable "retry_cnt_str" to integer variable "retry_cnt"

	Then I assign "" to variable "dep_lpn_list"

    While I see " Deposit" on line 1 in terminal within $screen_wait seconds
	And I verify number $retry_cnt is not equal to 100

		Then I "copy the Deposit LPN, if applicable" 
			Then I execute scenario "Terminal Copy Deposit LPN"
			And I "generate a list of LPNs if depositing multiples"
				If I verify variable "dep_lpn" is assigned
				And I verify text $dep_lpn is not equal to ""
				And I verify variable "dep_lpn_list" is assigned
					If I verify text $dep_lpn_list is not equal to ""
						Then I assign variable "dep_lpn_list" by combining $dep_lpn_list "," $dep_lpn
					Else I assign $dep_lpn to variable "dep_lpn_list"
					EndIf
				EndIf
        
        When I "copy the deposit location from the terminal"
            Then I execute scenario "Terminal Copy Deposit Location"

			If I verify variable "dep_loc" is assigned
			And I verify text $dep_loc is not equal to ""
				Then I enter $dep_loc in terminal
				And I "check for unpickable"
					If I see "un-pickable" in terminal within $screen_wait seconds
					And I see "Y" in terminal within $wait_med seconds
						Then I type "Y" in terminal
					EndIf
				And I wait $screen_wait seconds

				And I verify screen is done loading in terminal within $wait_med seconds
			Else I fail step with error message "ERROR: could not determine deposit location"
			EndIf

			Then I wait $screen_wait seconds
			And I verify screen is done loading in terminal within $wait_med seconds
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
    	And I fail step with error message $error_message
    EndIf

And I unassign variables "retry_cnt,retry_cnt_str"
    
@wip @private
Scenario: Terminal Inventory Deposit
#############################################################
# Description: From the Terminal Inventory Deposit screen, 
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
	Once I see "Inventory Deposit" on line 1 in terminal
	Once I see "ID:" in terminal

And I "navigate to the Load ID Field"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 3 column 6 in terminal
    Else I verify text $term_type is equal to "vehicle"
    	Once I see cursor at line 2 column 9 in terminal
    EndIf
    
    Given I press keys "DOWN" in terminal
	When I press keys "ENTER" in terminal    
    Then I "check for Could Not Allocate prompt"   
        Once I do not see "Inventory Deposit" in terminal
        If I see "Could Not Allocate" in terminal within $screen_wait seconds 
            Then I press keys "ENTER" in terminal
        EndIf
        
	Then I execute scenario "Terminal Wait Until First Line Is Not Blank"

And I "copy the Deposit LPN, if applicable" 
	Then I execute scenario "Terminal Copy Deposit LPN"

When I "deposit the Product"
	Given I "clear any potential deposit locations from previous deposits"
		Given I assign "" to variable "dep_loc"
        
	When I execute scenario "Terminal Load Deposit"
	
    Then I "unassign the deposit location for future deposits"
    	And I unassign variable "dep_loc"
	If I see "Could Not Allocate" in terminal within $screen_wait seconds 
		Then I press keys "ENTER" in terminal
	EndIf

	If I see "MRG" in terminal within $screen_wait seconds 
	    Then I execute scenario "Terminal Load Deposit"
	EndIf
	And I execute scenario "Terminal Wait Until First Line Is Not Blank"
	
And I "check if there is more to deposit"
	If I see "Inventory Deposit" on line 1 in terminal within $screen_wait seconds 
		Then I execute scenario "Check for Deposit Options"
	ElsIf I see "MRG" on line 1 in terminal within $screen_wait seconds 
		Then I execute scenario "Terminal Load Deposit"
		Once I do not see "MRG" in terminal
		And I execute scenario "Terminal Wait Until First Line Is Not Blank"
	EndIf
    
@wip @private
Scenario: Terminal Wait for Processing
#############################################################
# Description: Waits until the terminal is done processing
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

Given I assign 100 to variable "max_processing_loops"
And I assign 0 to variable "process_loops"
While I verify number $process_loops is less than $max_processing_loops
And I see "Processing Request" in terminal within $wait_med seconds 
	Then I increase variable "process_loops" by 1
    And I wait $wait_short seconds
EndWhile

@wip @private
Scenario: Terminal Validate Variables
#############################################################
# Description: This scenario validates that all variables for the Terminal Login scenario are assigned.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		terminal_server - the terminal server to connect to
#	Optional:
#		None
# Outputs:
#	None
#############################################################

# Note: You could place a pre-terminal session hook here, if needed, such as a test case specific wait time.
Given I "validate all necessary variables"
	When I verify variable "terminal_server" is assigned
	And I verify variable "devcod" is assigned
	If I verify variable "terminal_credentials" is assigned
	Else I "assume we are using username and password"
		Then I verify variable "username" is assigned
		And I verify variable "password" is assigned
	EndIf

@wip @private
Scenario: Connect and Set the Size of the Terminal
#############################################################
# Description: Connects to the terminal based on device type, ensuring a clean start
# MSQL Files:
#	clear_device_context.msql
#	list_rf_terminals.msql
# Inputs:
#	Required:
#		terminal_protocol - telnet or ssh
#		terminal_server - the address to connect to
#		devcod - the device code
#	Optional:
#		term_type - the Terminal Type, vehicle or handheld
# 		ssh_username - the username to login with when using SSH
#		ssh_password - the password to login with when using SSH
# Outputs:
#	term_type - the Terminal Type, vehicle or handheld
# 	term_id - the Terminal ID
#############################################################

Given I "clear the terminal state"
	Then I assign "clear_device_context.msql" to variable "msql_file"
	Given I execute scenario "Perform MSQL Execution"
	
And I "determine the Terminal Type"
	If I verify variable "term_type" is assigned
		Then I echo $term_type
	Elsif I verify variable "server" is assigned
	And I verify variable "devcod" is assigned
		Then I assign "list_rf_terminals.msql" to variable "msql_file"
		When I execute scenario "Perform MSQL Execution"
		Then I verify MOCA status is 0
		And I assign row 0 column "term_typ" to variable "term_type"
		And I assign row 0 column "term_id" to variable "term_id"
	EndIf 
	
When I "size the Terminal appropriately"
	If I verify text $term_type is equal to "handheld"
		Then I size terminal to 16 lines and 20 columns
	Else I size terminal to 8 lines and 40 columns
	EndIf
	
And I "establish the appropriate connection over the correct protocol"
	If I verify text $terminal_protocol is equal to "telnet"
		Then I open terminal connected to $terminal_server with answerback $devcod 
	Else I echo "since we are not doing telnet we need to run via SSH"
		Then I open terminal with SSH encryption connected to $terminal_server logged in as $ssh_username $ssh_password for terminal $devcod
	Endif

Then I "handle an arbitrary start screen"
	If I see "ÿý" on line 1 in terminal within $wait_med seconds 
		If I do not see "ÿý" in terminal within $screen_wait seconds 
		Else I echo "we need to attempt pushing on through this stuck screen"
			If I see "ÿý" in terminal
				Once I press keys "ENTER" in terminal
					If I see "Enter" in terminal within $screen_wait seconds 
						Once I press keys "ENTER" in terminal
					Endif
			Endif
		Endif
	Endif

And I "check for a clean terminal state"
	Then I execute scenario "Check for Terminal Questions"
	And I execute scenario "Terminal Wait Until First Line Is Not Blank"

@wip @private
Scenario: Check for Terminal ID Screen
#############################################################
# Description: If on the Terminal ID screen, enters the Terminal ID
# MSQL Files:
#	None
# Inputs:
#	Required:
#		devcod - the Device Code to be entered
#	Optional:
#		None
# Outputs:
#	None
#############################################################

If I see "Terminal ID:" on line 1 in terminal within $wait_short seconds 
	If I see cursor at line 2 column 1 in terminal within $screen_wait seconds 
	ElsIf I see "Terminal ID:" in terminal
		Given I press keys "ENTER" in terminal
        Then I verify screen is done loading in terminal within $max_response seconds
		If I see "Invalid" in terminal within $screen_wait seconds 
			If I see "Enter" in terminal within $screen_wait seconds 
			   Then I wait $wait_short seconds 
			EndIf
			Given I press keys "ENTER" in terminal
			Once I see cursor at line 2 column 1 in terminal
            Then I verify screen is done loading in terminal within $max_response seconds
		Endif
	Endif
	Then I enter $devcod in terminal
	Once I do not see "Terminal ID" in terminal
EndIf

@wip @private
Scenario: Check for Login Screen
#############################################################
# Description: If on the Login screen, login to the terminal
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		terminal_credentials - the Cycle Credentials to use
#		username - the plaintext username to use
#		password - the plaintext password to use
# Outputs:
#	None
#############################################################

If I see "Login" on line 1 in terminal within $wait_short seconds 
And I see "User ID:" in terminal within $wait_short seconds 
	Given I "verify I am on the Username Field"
		Given I execute scenario "Check for Bad Login"
		If I verify text $term_type is equal to "handheld"
			If I see cursor at line 4 column 2 in terminal within $screen_wait ms
			Else I see cursor at line 6 column 2 in terminal within $screen_wait ms
				Then I "exit the Password Field"
					Given I press keys "ENTER" in terminal
					Then I execute scenario "Check for Bad Login"
			Endif
	   	Else I verify text $term_type is equal to "vehicle"
			If I see cursor at line 3 column 16 in terminal within $screen_wait ms
			Else I see cursor at line 4 column 16 in terminal within $screen_wait ms
				Then I "exit the Password Field"
					Given I press keys "ENTER" in terminal
					Then I execute scenario "Check for Bad Login"
			Endif
		Endif
	
	When I "input my username"
		Given I execute scenario "Terminal Clear Field"
		If I verify variable "terminal_credentials" is assigned
			Then I enter USERNAME from credentials $terminal_credentials in terminal
		Else I "assume we are using username and password"
			Then I enter $username in terminal
		EndIf
	
	And I "verify I am on the Password Field"
		If I verify text $term_type is equal to "handheld"
			Once I see cursor at line 6 column 2 in terminal
		Else I verify text $term_type is equal to "vehicle"
			Once I see cursor at line 4 column 16 in terminal 
		EndIf
	
	And I "input my password"
		Given I execute scenario "Terminal Clear Field"
		If I verify variable "terminal_credentials" is assigned
			Then I enter PASSWORD from credentials $terminal_credentials in terminal
		Else I "assume we are using username and password"
			Then I enter $password in terminal
		EndIf
	
	Then I "verify I am logged in"
		Once I do not see "Login" in terminal
		Then I assign 1 to variable "term_logged_in"
		And I assign 1 to variable "no_process"
		And I execute scenario "Terminal Wait Until First Line Is Not Blank"
EndIf

@wip @private
Scenario: Check for Bad Login
#############################################################
# Description: If the Bad Login message is present, get back to the original Login state.
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

If I see "Bad" in terminal within $wait_short seconds 
And I see "Login" in terminal within $wait_short seconds 
And I see "Enter" in terminal within $wait_short seconds 
	Once I press keys "ENTER" in terminal
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 4 column 2 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 3 column 16 in terminal
	EndIf
Endif

@wip @private
Scenario: Check for Work Information Screen
#############################################################
# Description: If on the Work Information screen, enters the appropriate information
# MSQL Files:
#	None
# Inputs:
#	Required:
#		start_loc - the location to start the device on
#		vehtyp - the vehicle type to start the device on
#	Optional:
#		None
# Outputs:
#	None
#############################################################

If I see "Work Information" on line 1 in terminal within $wait_short seconds 
	If I verify variable "term_logged_in" is assigned
	And I verify number $term_logged_in is equal to 1
		When I "enter my Starting Location"
			If I verify text $term_type is equal to "handheld"
				Once I see cursor at line 6 column 4 in terminal
			Else I verify text $term_type is equal to "vehicle"
				Once I see cursor at line 4 column 15 in terminal
			EndIf
			Given I execute scenario "Terminal Clear Field"
			When I enter $start_loc in terminal
			
		And I "enter my Vehicle Type"
			If I see "Wh Eq Type:" in terminal within $wait_med seconds 
				If I verify text $term_type is equal to "handheld"
					Once I see cursor at line 8 column 4 in terminal
				Else I verify text $term_type is equal to "vehicle"
					Once I see cursor at line 5 column 15 in terminal
				EndIf
				Given I execute scenario "Terminal Clear Field"
				When I enter $vehtyp in terminal
			EndIf
			
		And I "accept the default Work Area"
			If I verify text $term_type is equal to "handheld"
				Once I see cursor at line 10 column 4 in terminal
			Else I verify text $term_type is equal to "vehicle"
				Once I see cursor at line 6 column 15 in terminal
			EndIf
			If I verify variable "wrkarea" is assigned
			And I verify text $wrkarea is not equal to ""
				Then I execute scenario "Terminal Clear Field"
				And I enter $wrkarea in terminal
			Else I execute scenario "Terminal Clear Field"
				And I press keys "ENTER" in terminal
			EndIf
			Once I do not see "Work Information" in terminal
			Once I do not see "Please Wait" in terminal
	Else I echo "We have not started logging in yet. Let's go back to the login screen"
		Once I press keys "F6" in terminal
	Endif
	Once I do not see "Please Wait" in terminal
	Then I assign 1 to variable "no_process"
	
	Then I "check for Recovery Mode"
		If I see "Recovery Mode" in terminal within $wait_med seconds 
		And I see "Enter" in terminal within $wait_short seconds 
		Else I execute scenario "Terminal Wait Until First Line Is Not Blank"
		EndIf
EndIf

@wip @private
Scenario: Check for Recovery Mode
#############################################################
# Description: Deposits inventory to a Directed Putaway Location if present, if not, will 
# be deposited to a Recovery Deposit Location.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		recovery_deploc - the Recovery Deposit Location
#	Optional:
#		None
# Outputs:
#	None
#############################################################

If I see "Recovery Mode" in terminal within $wait_short seconds 
And I see "Enter" in terminal within $wait_med seconds 
	Once I press keys "ENTER" in terminal
	Once I do not see "Recovery" in terminal
	If I see "Could Not Allocate" in terminal within $screen_wait seconds 
		Then I press keys "ENTER" in terminal
	EndIf
	Then I execute scenario "Terminal Wait Until First Line Is Not Blank"
	And I assign "TRUE" to variable "recovery_mode"
	If I see "MRG" on line 1 in terminal within $screen_wait seconds 
		Then I execute scenario "Terminal Load Deposit"
	Elsif I see "Inventory Deposit" on line 1 in terminal within $screen_wait seconds 
		Then I execute scenario "Terminal Inventory Deposit"
	Endif
	And I assign "FALSE" to variable "recovery_mode"
	Then I execute scenario "Terminal Navigate to Undirected Menu"
Endif

@wip @private
Scenario: Check for Authentication Screen
#############################################################
# Description: From the Authentication screen, inputs the username and password, if applicable
# MSQL Files:
#	None
# Inputs:
#	Required:
#		terminal_credentials - the credentials to login with
#	Optional:
#		password - the plaintext password to use
# Outputs:
#	None
#############################################################

If I see "Authenticate" on line 1 in terminal within $wait_short seconds 
And I see "Password" in terminal within $screen_wait seconds 
	Then I execute scenario "Check for Terminal Questions"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 4 column 2 in terminal
		If I verify variable "terminal_credentials" is assigned
			Then I enter PASSWORD from credentials $terminal_credentials in terminal
		Else I "assume we are using username and password"
			Then I enter $password in terminal
		EndIf
	ElsIf I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 3 column 16 in terminal
		If I verify variable "terminal_credentials" is assigned
			Then I enter PASSWORD from credentials $terminal_credentials in terminal
		Else I "assume we are using username and password"
			Then I enter $password in terminal
		EndIf
  	Else I echo "We didn't see the expected questions and the cursor is not in the expected position."
		Then I press keys "ENTER" in terminal
		And I wait $wait_med seconds 
	Endif
Endif

@wip @private
Scenario: Check for Terminal Questions
#############################################################
# Description: Answers any Terminal Questions
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

If I see "Enter" in terminal
	If I see "Logged" in terminal
	And I see "Off" in terminal
		Once I press keys "ENTER" in terminal
	Elsif I see "Press" in terminal
		Once I press keys "ENTER" in terminal
	Endif
EndIf

# Yes and No Questions
If I see "Y|N" in terminal
	If I do not see "Logout?" in terminal
		Once I type "N" in terminal
	Elsif I see "End Of Day" in terminal
		Once I type "Y" in terminal
	Elsif I see "OK To" in terminal
	And I see "Logout?" in terminal
		Once I type "N" in terminal
	EndIf
Endif

@wip @private
Scenario: Check for F6
#############################################################
# Description: If the terminal prompts for an F6, presses F6
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

If I see "Press F6" in terminal within $wait_short seconds 
	Once I press keys "F6" in terminal
Endif

@wip @private
Scenario: Check for Deposit Options
#############################################################
# Description: From the Deposit Options screen, performs a deposit
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

If I see "Deposit Options" on line 1 in terminal within $wait_short seconds 
And I see "Y|N" in terminal within $wait_short seconds 
	Once I type "Y" in terminal
		If I see "MRG" on line 1 in terminal within $screen_wait seconds 
		And I see "Lod:" in terminal within $wait_short seconds 
			Then I execute scenario "Terminal Load Deposit"
		Endif
		If I see "Inventory Deposit" on line 1 in terminal within $screen_wait seconds 
			Then I execute scenario "Terminal Inventory Deposit"
		Endif
ElsIf I see "MRG" on line 1 in terminal within $wait_short seconds 
And I see "Lod:" in terminal within $wait_short seconds 
	Then I execute scenario "Terminal Load Deposit"
Endif

If I see "Inventory Deposit" on line 1 in terminal
	Then I execute scenario "Terminal Inventory Deposit"
Endif

@wip @private
Scenario: Terminal Logout Questions And Possibly Deposit
#############################################################
# Description: look for terminal logout questions and check
# if a deposit is needed and perform the deposit.
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

Given I assign 1 to variable "term_logout_questions"
While I verify number $term_logout_questions is equal to 1
	Given I execute scenario "Check for Authentication Screen"
	If I verify number $term_logout_questions is equal to 1
	And I see "OK To Logout?" in terminal within $screen_wait seconds 
		While I see "Y|N" in terminal within $wait_short seconds 
			Once I type "Y" in terminal
			And I wait $wait_short seconds 
		EndWhile
	Endif

	If I verify number $term_logout_questions is equal to 1
	And I see "Logged" in terminal within $screen_wait seconds 
	And I see "Off" in terminal
	And I verify number $term_logout_questions is equal to 1
		While I see "Press" in terminal within $wait_short seconds 
		And I see "Enter" in terminal
			Once I press keys "ENTER" in terminal
			And I wait $wait_short seconds 
		EndWhile
	Endif

	If I verify number $term_logout_questions is equal to 1
	And I see "Login" on line 1 in terminal within $screen_wait seconds 
	And I see "User ID:" in terminal within $wait_short seconds
	And I see "Password:" in terminal within $wait_short seconds
	And I verify number $term_logout_questions is equal to 1
		Then I assign 0 to variable "term_logout_questions"
	Endif

	If I verify number $term_logout_questions is equal to 1
	And I see "End Of Day" in terminal within $screen_wait seconds 
		While I see "Y|N" in terminal within $screen_wait seconds 
			Once I type "Y" in terminal
		EndWhile
		If I see "Logged Off" in terminal within $screen_wait seconds 
		And I see "Enter" in terminal within $wait_short seconds 
			Once I press keys "ENTER" in terminal
		Endif
		Then I assign 0 to variable "term_logout_questions"
	Elsif I see "Inventory" in terminal within $wait_short seconds 
	And I see "deposited" in terminal within $wait_short seconds 
	And I see "Press Enter" in terminal within $wait_short seconds 
	And I verify number $term_logout_questions is equal to 1
		Once I press keys "ENTER" in terminal
		And I assign "TRUE" to variable "recovery_mode"
		If I see "MRG" on line 1 in terminal within $screen_wait seconds 
			Then I execute scenario "Terminal Load Deposit"
		Elsif I see "Inventory Deposit" on line 1 in terminal within $screen_wait seconds 
			Then I execute scenario "Terminal Inventory Deposit"
		Endif
		And I assign "FALSE" to variable "recovery_mode"
		Then I execute scenario "Terminal Navigate to Undirected Menu"
		Once I see "ndirected Menu" in terminal
		Once I press keys "F1" in terminal
	Endif

	If I verify number $term_logout_questions is equal to 1
	And I see "Terminal is Logged Off" in terminal within $screen_wait seconds 
	And I see "Off" in terminal
	While I see "Press" in terminal within $wait_short seconds 
	And I see "Enter" in terminal
		Once I press keys "ENTER" in terminal
		And I wait $wait_short seconds 
	EndWhile
	Endif
EndWhile

@wip @private
Scenario: Terminal Allocate Location
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

When I "allocate the Location"
	Given I press keys "F3" in terminal
	Once I see "Blank" in terminal 
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 10 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 5 column 7 in terminal
	EndIf
    
	If I verify variable "dep_loc" is assigned
	And I verify text $dep_loc is not equal to "" ignoring case
		Then I enter $dep_loc in terminal
	Else I press keys "ENTER" in terminal
	EndIf
    
	Once I see "MRG" on line 1 in terminal 
	Once I see "Deposit" on line 1 in terminal

And I "check to see if the system is configured to confirm lodnum"
	Then I execute scenario "Terminal Confirm Lodnum"

Then I "get the allocated location"
	Given I "verify screen has loaded for information to be copied off of it"
		Then I verify screen is done loading in terminal within $max_response seconds

	If I verify text $term_type is equal to "handheld"
		Then I copy terminal line 12 columns 6 through 16 to variable "dep_loc"
	Else I verify text $term_type is equal to "vehicle"
		Then  I copy terminal line 8 columns 7 through 17 to variable "dep_loc"
	EndIf 
	
@wip @private
Scenario: Terminal Putaway Override
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

Given I "start the Override by entering the Override Code or use F2"
	Given I press keys "F4" in terminal
	Once I see "Override" on line 1 in terminal 
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 7 column 1 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 4 column 16 in terminal
	EndIf
	If I verify variable "override_f2" is assigned
	And I verify text $override_f2 is equal to "TRUE" ignoring case
    	Then I press keys "F2" in terminal
		And I wait $screen_wait seconds
        And I press keys "DOWN" in terminal
        And I press keys "ENTER" in terminal 2 times with $screen_wait seconds delay
    Else I execute scenario "Terminal Clear Field"
		And I enter $over_code in terminal
	EndIf
	
When I "enter the Override Deposit Location"
	If I verify text $term_type is equal to "handheld"
		Once I see cursor at line 9 column 2 in terminal
	Else I verify text $term_type is equal to "vehicle"
		Once I see cursor at line 5 column 6 in terminal 
	EndIf 
	Then I enter $over_dep_loc in terminal
	
And I "confirm the Override"
	If I see "OK To Override?" in terminal within $wait_med seconds 
		Then I type "Y" in terminal
	EndIf 

And I "check for Unpickable"
	If I see "un-pickable" in terminal within $wait_med seconds 
		Then I type "Y" in terminal
	EndIf 
	
Then I "ensure I am back on the Deposit Screen"
	Once I see "MRG" on line 1 in terminal
	Once I see "Deposit" on line 1 in terminal 
	
And I "check to see if the system is configured to confirm lodnum"
	Then I execute scenario "Terminal Confirm Lodnum"
	
And I "get the new Deposit Location"
	Given I "verify screen has loaded for information to be copied off of it"
		Then I verify screen is done loading in terminal within $max_response seconds

	And I execute scenario "Terminal Copy Deposit Location"
    
@wip @private
Scenario: Terminal Confirm Lodnum
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

	Given I assign "check_confirm_lodnum.msql" to variable "msql_file"
	If I execute scenario "Perform MSQL Execution"
	And I verify MOCA status is 0
		If I verify text $term_type is equal to "handheld"
			Once I see cursor at line 3 column 1 in terminal
		Else I verify text $term_type is equal to "vehicle"
			Once I see cursor at line 2 column 7 in terminal
		EndIf 
		Then I press keys "ENTER" in terminal
	EndIf
    
@wip @private
Scenario: Terminal Copy Deposit Location
#############################################################
# Description: Copies the suggested Deposit Location from the Terminal
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	dep_loc - the deposit location suggested in the terminal
#############################################################

If I see "Deposit" on line 1 in terminal within $wait_short seconds
	If I verify text $term_type is equal to "handheld"
		Then I copy terminal line 12 columns 6 through 20 to variable "dep_loc_local"
	Else I verify text $term_type is equal to "vehicle"
		If I assign text matching regex ".*Loc:\s+(\w+).*Loc:.*" in terminal to variables "dep_loc_local" within $wait_med seconds
        Else I assign "" to variable "dep_loc_local"
		EndIf
	EndIf
	Given I execute Groovy "dep_loc_local = dep_loc_local.trim()"
    
    If I verify variable "dep_loc_local" is assigned
	And I verify text $dep_loc_local is not equal to ""
      Then I assign $dep_loc_local to variable "dep_loc"
	EndIf

	And I unassign variable "dep_loc_local"
EndIf

@wip @private
Scenario: Terminal Copy Deposit LPN
#############################################################
# Description: Copies the Deposit LPN from the Terminal
# MSQL Files:
#	None
# Inputs:
#	Required:
#		None
#	Optional:
#		None
# Outputs:
#	dep_lpn - the lodnum (LPN) to deposit shown in terminal
#############################################################

If I see "Deposit" on line 1 in terminal within $wait_short seconds
    If I verify text $term_type is equal to "handheld"
        And I copy terminal line 3 columns 1 through 20 to variable "dep_lpn"
    Else I verify text $term_type is equal to "vehicle"
        Then I copy terminal line 2 columns 7 through 36 to variable "dep_lpn"
    EndIf
    Given I execute Groovy "dep_lpn = dep_lpn.trim()"
    Then I echo $dep_lpn
EndIf