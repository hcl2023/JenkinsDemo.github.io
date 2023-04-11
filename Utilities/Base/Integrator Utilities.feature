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
# Utility: Integrator Utilities.feature
# 
# Functional Area: Host Integrations
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Utility
# Blue Yonder Interfaces Interacted With: MOCA, Integrator
#
# Description:
# This utility contains scenarios for working with transactions in the integrator
# layer of the Blue Yonder WMS
#
#  Public Scenarios:  
#  - Wait for Outbound Event - Logic that waits for and event to be create or sent
#  - List Outbound Event Data - MSQL wrapper to get outbound event data
#  
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Integrator Utilities

@wip @public
Scenario: Wait for Outbound Integrator Event  
#############################################################
# Description: 
#	This scenario waits for an outbound integrator event to  
#	be created (at least to IC status)
# MSQL Files:
#	None      
# Inputs:
#	Required:
#		evt_id - Integrator Event
#		evt_arg_val - Integrator Event Argument Value
#	Optional:
#		only_sent_flag - If TRUE, then only return success on a SC
#		loop_size - counter the controls how long we wait (default=20)
# Outputs:
#	None
#############################################################

Given I "setup the variables"
    Given I assign "FALSE" to variable "event_ready"
    And I assign 0 to variable "event_loop_count"
    And I assign value 20 to unassigned variable "loop_size"

When I "keep looking for the integrator event until I find it in a IC or SC status"
    While I verify text $event_ready is equal to "FALSE"
    And I verify number $event_loop_count is less than $loop_size
        Then I execute scenario "List Outbound Event Data"
        If I verify MOCA status is 0
            Then I assign row 0 column "evt_stat_cd" to variable "evt_stat_cd"
            If I verify text $evt_stat_cd is equal to "SC"
                Then I assign 1 to variable "event_ready"
            ElsIf I verify text $evt_stat_cd is equal to "IC"
                If I verify text $only_sent_flag is equal to "TRUE"
                    Then I wait 10 seconds
                Else I assign 1 to variable "event_ready"
                EndIf
            ElsIf I verify text $evt_stat_cd is equal to "EC" 
                Then I wait 10 seconds
            Else I fail step with error message "ERROR: Event did not get sent successfully"
        Endif
        Else I wait 10 seconds
        Endif
        Then I increase variable "event_loop_count" by 1    
    EndWhile

Then I "check for an error and clean up"
    If I verify number $event_ready is equal to "FALSE"
        Then I fail step with error message "ERROR: Event did not get processed within time limit"
    Endif    
    Then I unassign variables "evt_id,evt_arg_val,event_loop_count,event_ready,loop_size"
    
Scenario: List Outbound Event Data
#############################################################
# Description: 
#	This scenario returns data for an outbound integrator event    
#	An event can selected by evt_id & evt_arg_val or evt_data_seq
# MSQL Files:
#	`list_outbound_event_data.msql
# Inputs:
#	Required:
#		None
#	Optional:
#		evt_id - Integrator Event
#		evt_arg_val - Integrator Event Argument Value
#		evt_data_seq - Integrator Event Data Sequence Value
#		evt_dest_sys_id - Integrator system that an event is sent to
# Outputs:
#	evt_stat_cd - Status code for the event
#	evt_xml	- XML version of the outbound IFD
#	evt_data_seq - Event Data Sequence of event
#	ifd_data_seq - IFD Data Sequence of the outbound IFD
#############################################################

Given I "assign variable to moca environment variables"
	When I assign "" to variable "err_argument_list"
    If I verify variable "evt_id" is assigned
        And I assign variable "err_argument_list" by combining $err_argument_list " evt_id=" $evt_id
    EndIf
    If I verify variable "evt_arg_val" is assigned
        And I assign variable "err_argument_list" by combining $err_argument_list " evt_arg_id=" $evt_arg_val
    EndIf
    If I verify variable "evt_data_seq" is assigned
        and I assign variable "err_argument_list" by combining $err_argument_list " evt_data_seq=" $evt_data_seq 
    EndIf
    If I verify variable "evt_dest_sys_id" is assigned
        And I assign variable "err_argument_list" by combining $err_argument_list " evt_dest_sys_id=" $evt_dest_sys_id 
    EndIf    

when I "run the MSQL command"
	Then I assign "list_outbound_event_data.msql" to variable "msql_file"
    And I execute scenario "Perform MSQL Execution"

Then I "return either the event values or an error message"
    If I verify MOCA status is 0
    	Then I assign row 0 column "evt_stat_cd" to variable "evt_stat_cd"
        And I assign row 0 column "evt_data_seq" to variable "evt_data_seq"
        And I assign row 0 column "ifd_data_seq" to variable "ifd_data_seq"
        And I assign row 0 column "xml" to variable "evt_xml"   
    Else I "handle error condition"
    	Given I assign variable "error_message" by combining "ERROR: Failed fo find data for event with values" $err_argument_list
        Then I fail step with error message $error_message
	EndIf

And I "clean up variables"
    And I unassign variable "err_argument_list"