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
# Utility: Post Validation Utilities.feature
# 
# Functional Area: Validation
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Utility
# Blue Yonder Interfaces Interacted With: SQL, MOCA
# 
# Description:
# This utility contains scenarios to execute post validation checks
#
# Public Scenarios:
#	- Validate Variable Value - Compare two values and fail if not equal
#	- Validate String Variable Value - Compare two string values and fail if not equal
#	- Validate String Variable Value Ignoring Case - Compare two string values ingnoring case and fail if not equal
#	- Validate Number Variable Value - Compare two numeric values and fail if not equal
#	- Validate Number is Greater than Value - Compare two numeric values and fail if first is not greater than second
#	- Validate Number is Less than Value - Compare two numeric values and fail if first is not less than second
#	- Validate Transaction was Created - Validate that an integrator transaction was created
#	- Validate Transaction was Sent -Validate that an integrator transaction was sent
#	- Validate Transaction Field Value in XML - Validate that the value for a given tag within an XML string matches an expected value
#	- Validate Transaction Field Value in XML - Validate that a list of values for a given tag within an XML string matches an expected value
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Post Validation Utilities

@wip @public
Scenario: Validate Variable Value
#############################################################
# Description: Compare two values and fail if not equal
# MSQL Files:
#	None
# Inputs:
#	Required:
#		parameter_1 - first value
#		parameter_2 - second value
#	Optional:
#		None
# Outputs:
#	None                      
#############################################################

If I verify variable $parameter_1 is equal to variable $parameter_2
	Then I assign "TRUE" to variable "validation_status"
Else I assign "FALSE" to variable "validation_status"
	Then I assign variable "error_message" by combining "ERROR: Validation failed as value (" $parameter_1 ") is not equal to (" $parameter_2 ")"
	And I fail step with error message $error_message
EndIf

@wip @public
Scenario: Validate String Variable Value
#############################################################
# Description: Compare two string values and fail if not equal
# MSQL Files:
#	None
# Inputs:
#	Required:
#		parameter_1 - first value
#		parameter_2 - second value
#	Optional:
#		None
# Outputs:
#	None                      
#############################################################

If I verify text $parameter_1 is equal to $parameter_2
	Then I assign "TRUE" to variable "validation_status"
Else I assign "FALSE" to variable "validation_status"
	Then I assign variable "error_message" by combining "ERROR: Validation failed as value (" $parameter_1 ") is not equal to (" $parameter_2 ")"
	And I fail step with error message $error_message
EndIf

@wip @public
Scenario: Validate String Variable Value Ignoring Case
#############################################################
# Description: Compare two string values ingnoring case and fail if not equal
# MSQL Files:
#	None 
# Inputs:
#	Required:
#		parameter_1 - first value
#		parameter_2 - second value
#	Optional:
#		None
# Outputs:
#	None                      
#############################################################

If I verify text $parameter_1 is equal to $parameter_2 ignoring case
	Then I assign "TRUE" to variable "validation_status"
Else I assign "FALSE" to variable "validation_status" 
	Then I assign variable "error_message" by combining "ERROR: Validation failed as value (" $parameter_1 ") is not equal to (" $parameter_2 ")"
	And I fail step with error message $error_message
EndIf

@wip @public
Scenario: Validate Number Variable Value
#############################################################
# Description: Compare two numeric values and fail if not equal
# MSQL Files:
#	None
# Inputs:
#	Required:
#		parameter_1 - first value
#		parameter_2 - second value
#	Optional:
#		None
# Outputs:
#	None                      
#############################################################

If I verify number $parameter_1 is equal to $parameter_2
	Then I assign "TRUE" to variable "validation_status"
Else I assign "FALSE" to variable "validation_status"
	Then I assign variable "error_message" by combining "ERROR: Validation failed as value (" $parameter_1 ") is not equal to (" $parameter_2 ")"
	And I fail step with error message $error_message
EndIf

@wip @public
Scenario: Validate Number is Greater than Value
#############################################################
# Description: Compare two numeric values and fail if first is not greater than second
# MSQL Files:
#	None
# Inputs:
#	Required:
#		parameter_1 - first value
#		parameter_2 - second value
#	Optional:
#		None
# Outputs:
#	None                      
#############################################################

If I verify number $parameter_1 is greater than $parameter_2
	Then I assign "TRUE" to variable "validation_status"
Else I assign "FALSE" to variable "validation_status"
	Then I assign variable "error_message" by combining "ERROR: Validation failed as value (" $parameter_1 ") is not greater than (" $parameter_2 ")"
	And I fail step with error message $error_message
EndIf

@wip @public
Scenario: Validate Number is Less than Value
#############################################################
# Description: Compare two numeric values and fail if first is not less than second
# MSQL Files:
#	None 
# Inputs:
#	Required:
#		parameter_1 - first value
#		parameter_2 - second value
#	Optional:
#		None
# Outputs:
#	None                      
#############################################################

If I verify number $parameter_1 is less than $parameter_2
	Then I assign "TRUE" to variable "validation_status"
Else I assign "FALSE" to variable "validation_status"
	Then I assign variable "error_message" by combining "ERROR: Validation failed as value (" $parameter_1 ") is not less than (" $parameter_2 ")"
	And I fail step with error message $error_message
EndIf

@wip @public
Scenario: Validate Transaction was Created
#############################################################
# Description: Validate that an integrator transaction was created
# MSQL Files:
#	None
# Inputs:
#	Required:
#		parameter_1 - Integrator Event Id
#		parameter_2 - Event Argument Value
#	Optional:
#		parameter_3 - Destination System Id
# Outputs:
#	evt_xml - XML string of transaction                        
#############################################################

Given I "assign parameters to the correct arguements"
	Given I assign $parameter_1 to variable "evt_id"
	Then I assign $parameter_2 to variable "evt_arg_val"
	If I verify variable "parameter_3" is assigned
	And I verify text $parameter_3 is not equal to ""
		Then I assign $parameter_3 to variable "evt_dest_sys_id"
	EndIf
    
Then I "wait for transaction to be in IC or SC status"
	Given I assign "FALSE" to variable "sent_only_flag"
	If I execute scenario "Wait for Outbound Integrator Event"
    	Then I assign "TRUE" to variable "validation_status"
	Else I assign "FALSE" to variable "validation_status"
    	Then I assign variable "error_message" by combining "ERROR: Event " $evt_id " was not successfully created"
		And I fail step with error message $error_message
	EndIf
   
@wip @public   
Scenario: Validate Transaction was Sent
#############################################################
# Description: Validate that an integrator transaction was sent
# MSQL Files:
#	None
# Inputs:
#	Required:
#		parameter_1 - Integrator Event Id
#		parameter_2 - Event Argument Value
#	Optional:
#		parameter_3 - Destination System Id
# Outputs:
#	evt_xml - XML string of transaction                     
#############################################################

Given I "assign parameters to the correct arguements"
	Given I assign $parameter_1 to variable "evt_id"
	Then I assign $parameter_2 to variable "evt_arg_val"
	If I verify variable "parameter_3" is assigned
	And I verify text $parameter_3 is not equal to ""
		Then I assign $parameter_3 to variable "evt_dest_sys_id"
	EndIf
    
Then I "wait for transaction to be in SC status"
	Given I assign "TRUE" to variable "sent_only_flag"
	If I execute scenario "Wait for Outbound Integrator Event"
    	Then I assign "TRUE" to variable "validation_status"
	Else I assign "FALSE" to variable "validation_status"
    	Then I assign variable "error_message" by combining "ERROR: Event " $evt_id " was not successfully sent"
		And I fail step with error message $error_message
	EndIf

@wip @public
Scenario: Validate Transaction Field Value in XML
#############################################################
# Description: Validate that the value for a given tag within an XML string matches an expected value
# MSQL Files:
#	None
# Inputs:
#	Required:
#		evt_xml - XML string usually populated from earlier validation (Validate Transaction was Created)
#		parameter_1 - XML Tag
#		parameter_2 - Expected value
#	Optional:
#		None
# Outputs:
#	None                      
#############################################################

When I "retrieve the next tag value from XML"
	Given I assign $evt_xml to variable "xml"
	And I assign $parameter_1 to variable "tag"
	Then I execute scenario "Get XML Tag Value"
        
Then I "compare the retrieved value to the expected value"        
	If I verify variable "tag_value" is equal to variable "parameter_2"
    	Then I assign "TRUE" to variable "validation_status"
	Else I assign "FALSE" to variable "validation_status"
    	Then I assign variable "error_message" by combining "ERROR: Field (" $parameter_1 ") Value (" $tag_value ") is not equal to (" $parameter_2 ")"
		And I fail step with error message $error_message
	EndIf
	And I unassign variables "xml,tag,tag_value"
        
@wip @public
Scenario: Validate Transaction Field Value List in XML
#############################################################
# Description: Validate that a list of values for a given tag within an XML string matches an expected value
# MSQL Files:
#	None
# Inputs:
#	Required:
#		evt_xml - XML string usually populated from earlier validation (Validate Transaction was Created)
#		parameter_1 - XML Tag
#		parameter_2 - Expected value
#	Optional:
#		parameter_3 - 2nd XML Tag
#		parameter_4 - 2nd Expected value
#		parameter_5 - 3rd XML Tag
#		parameter_6 - 3rd Expected value
#		parameter_n - nth XML Tag
#		parameter_n+1 - nth Expected value
# Outputs:
#	None                      
#############################################################
    
Given I "setup comparison loop"
	Given I assign "parameter_1" to variable "next_tag_parameter"
	And I assign "parameter_2" to variable "next_value_parameter"
	Then I assign 2 to variable "parameter_counter"
	And I assign "TRUE" to variable "validation_status"

Then I "loop through all value pairs"
	While I verify variable $next_tag_parameter is assigned
	And I assign contents of variable $next_tag_parameter to "tag"
	And I verify text $tag is not equal to ""
	And I verify variable $next_value_parameter is assigned
	And I verify text $validation_status is equal to "TRUE"
    
		When I "retrieve the next tag value from XML"
			Then I assign contents of variable $next_tag_parameter to "tag"
			Then I assign contents of variable $next_value_parameter to "expected_value"
			And I assign $evt_xml to variable "xml"
			Then I execute scenario "Get XML Tag Value"
 
		Then I "compare the retrieved value to the expected value"
			If I verify variable "tag_value" is equal to variable "expected_value"
				Then I echo $tag_value $expected_value
			Else I assign variable "error_message" by combining "ERROR: Field (" $tag ") Value (" $tag_value ") is not equal to (" $expected_value ")"
				And I assign "FALSE" to variable "validation_status"
			EndIf      
        
		And I "proceed to the next tag/value pair"
			Given I increase variable "parameter_counter"
			Then I assign variable "next_tag_parameter" by combining "parameter_" $parameter_counter
			And I increase variable "parameter_counter"
			Then I assign variable "next_value_parameter" by combining "parameter_" $parameter_counter
    EndWhile
    And I unassign variables "parameter_counter,next_value_parameter,next_tag_parameter,xml,tag,expected_value,tag_value"