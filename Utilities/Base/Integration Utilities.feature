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
# Utility: Integration Utilities.feature
# 
# Functional Area: Host Integrations
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Utility
# Blue Yonder Interfaces Interacted With: MOCA, Integrator
#
# Description:
# This utility contains scenarios for testing integrator transactions
#
# Public Scenarios:  
#  	- Process Integrator Add Transaction - runs an Add transaction file and validates
#   - Process Integrator Change Transaction - runs a Change transaction file and validates
#	- Process Integrator Delete Transaction - runs a Delete transaction file and validates
# 	- Upload and Process Integrator Transaction File - copies and processes an integrator transaction file to the WMS server
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Integration Utilities

@wip @public
Scenario: Upload and Process Integrator Transaction File
###################################################################
# Description:  Determine proper path to integration transaction file
# and copies the integrator transaction file from the cycle project directory 
# to the WMS server and then processes that file.
# MSQL Files:
#	None   
# Inputs:
# 	Required:
#		interface_path - path to directory in cycle that holds the transaction file
#		transaction_file_name - Name of the file to be uploaded and processed
#		tran_name - Transaction Name (must be valid WMS Integrator transaction for the system)  
#		system - Integrator System (must be a valid WMS Integrator system)
#		wms_inbound_directory - directory on WMS system for processing host files (environment variable)
#	Optional:
#		destination_file_name - If provided, the transaction file will be renamed during upload
# Outputs:
# 	None
###################################################################

Given I "build the local file name and destination file name"
   	Then I assign variable "file" by combining $interfaces_directory_location $transaction_file_name
	And I execute scenario "Locate File on Path"
	If I verify variable "new_file" is assigned
	Else I assign variable "error_message" by combining "ERROR: Could not determine path to Transaction file: " $file
		And I fail step with error message $error_message
	EndIf

	Then I assign $new_file to variable "full_local_file_path"
	If I verify variable "destination_file_name" is assigned
	And I verify text $destination_file_name is not equal to ""
		Then I assign variable "full_destination_file_path" by combining $wms_inbound_directory "/" $transaction_file_name
	Else I assign variable "full_destination_file_path" by combining $wms_inbound_directory "/" $transaction_file_name
	EndIf

Then I "upload and process the integrator transaction file"
	When I upload file $full_local_file_path to $full_destination_file_path on the MOCA server
	Then I log MOCA inbound integration transaction $tran_name on system $system with file $full_destination_file_path

@wip @public
Scenario: Process Integration Add Transaction
#############################################################
# Description: 
#	This scenario copies an Add transaction file to the WMS
#	system and processes the file.  Pre and Post validation
#	are run to validate the file was successfully
#	downloaded.
# MSQL Files:
#	None
# Inputs:
#	Required:
#		resource_path - Full path and file name to be downloaded
#		system - Integrator System (must be a valid WMS Integrator system)
#		wms_inbound_directory - directory on WMS system for processing host files
#		transaction_file_name - Name of the file to be uploaded and processed
#		tran_name - Transaction Name (must be valid integrator transaction for the system)  
#		pre_validation - Cycle scenario that confirms data does not exist
#		post_validation - Cycle scenario that confirms data was added
#	Optional:
#		destination_file_name - If provided, the transaction file will be renamed during upload
# Outputs:
#	None
#############################################################

Given I "confirm data being downloaded isn't already in the system"
   If I verify variable "pre_validation" is assigned
   And I verify text $pre_validation is not equal to ""
	  Then I execute scenario $pre_validation
	  If I verify MOCA status is 0 
	  	Then I fail step with error message "ERROR: Data being added already exists."
	  EndIf
   Else I fail step with error message "ERROR: Prevalidation missing"
   EndIf

When I "log the transaction in WMS"
	When I execute scenario "Upload and Process Integrator Transaction File"

Then I "check to see if the data was added"
	If I verify variable "post_validation" is assigned
	And I verify text $post_validation is not equal to ""
		Then I execute scenario $post_validation
		If I verify MOCA status is 0
			Then I echo "Downloaded data found in system"
		Else I fail step with error message "ERROR: Downloaded data was not added"
		EndIf
	 Else I fail step with error message "ERROR: Post validation missing"
	 EndIf

@wip @public
Scenario: Process Integration Change Transaction
#############################################################
# Description: 
#	This scenario copies a Change transaction file to the WMS
#	system and processes the file.  Pre and Post validation
#	are run to validate the file was successfully
#	downloaded and data was changed.
# MSQL Files:
#	None            
# Inputs:
#	Required:
#		resource_path - Full path and file name to be downloaded
#		system - Integrator System (must be a valid WMS Integrator system)
#		wms_inbound_directory - directory on WMS system for processing host files
#		transaction_file_name - Name of the file to be uploaded and processed
#		tran_name - Transaction Name (must be valid integrator transaction for the system)  
#		field_to_validate_change - Field value used to confirm download was processed
#		pre_validation - Cycle scenario that confirms data exists
#		post_validation - Cycle scenario that confirms data was changed
#	Optional:
#		destination_file_name - If provided, the transaction file will be renamed during upload
# Outputs:
#	None
#############################################################

Given I "check to make sure the data already exist and save the colume to be checked"
	If I verify variable "pre_validation" is assigned
   	And I verify text $pre_validation is not equal to ""
		Then I execute scenario $pre_validation
		And I assign row 0 column $field_to_validate_change to variable "value_before_change"
		If I verify MOCA status is 0
	  		Then I echo "Data already exists with post change data"
		Else I echo "Data does not already exists. So It will be added by change transaction"
		EndIf 
	Else I fail step with error message "ERROR: Prevalidation missing"
	EndIf
   
When I "log the transaction in WMS"  
	When I execute scenario "Upload and Process Integrator Transaction File"

Then I "check to see if the data was changed"
	If I verify variable "post_validation" is assigned
   	And I verify text $post_validation is not equal to ""
		Then I execute scenario $post_validation
		And I assign row 0 column $field_to_validate_change to variable "value_post_change"
		If I verify text $value_before_change is equal to $value_post_change
	   		Then I fail step with error message "ERROR: Data was not changed"
		EndIf
   	Else I fail step with error message "ERROR: Post validation missing"
   	EndIf

@wip @public
Scenario: Process Integration Delete Transaction
#############################################################
# Description: 
#	This scenario copies a Delete transaction file to the WMS
#	system and processes the file.  Pre and Post validation
#	are run to validate the file was successfully
#	downloaded.
# MSQL Files:
#	None      
# Inputs:
# 	Required:
#		resource_path - Full path and file name to be downloaded
#		system - Integrator System (must be a valid WMS Integrator system)
#		wms_inbound_directory - directory on WMS system for processing host files
#		transaction_file_name - Name of the file to be uploaded and processed
#		tran_name - Transaction Name (must be valid integrator transaction for the system)  
#		pre_validation - Cycle scenario that confirms data does not exist
#		post_validation - Cycle scenario that confirms data was added
#	Optional:
#		destination_file_name - If provided, the transaction file will be renamed during upload
# Outputs:
#	None
#############################################################

Given I "check to make sure the data already exists for delete"
	If I verify variable "pre_validation" is assigned
   	And I verify text $pre_validation is not equal to ""
		Then I execute scenario $pre_validation
	  	If I verify MOCA status is 0
			Then I echo "Data exists and is available for delete"
	  	Else I fail step with error message "ERROR: Data does not exist."
	  	EndIf  
   	Else I fail step with error message "ERROR: Prevalidation missing"
   	EndIf

When I "log the transaction in WMS" 
	When I execute scenario "Upload and Process Integrator Transaction File"

Then I "check to see if the ASN was deleted"
   	If I verify variable "post_validation" is assigned
   	And I verify text $post_validation is not equal to ""
	  	Then I execute scenario $post_validation
	  	If I verify MOCA status is 0
			Then I fail step with error message "ERROR: Data was not deleted"
	  	Else I echo "Delete Transaction Passed"
	  	EndIf
   	Else I fail step with error message "ERROR: Post validation missing"
   	EndIf
	
@wip @public
Scenario: Wait for Outbound Event  
#############################################################
# Description: 
#	This scenario waits for an outbound integrator event to  
#	created (at least to IC status)
# MSQL Files:
#	None         
# Inputs:
#	Required:
#		evt_id - Integrator Event
#		evt_arg_val - Integrator Event Argument Value
#	Optional:
#		None
# Outputs:
#	None
#############################################################

Given I assign "FALSE" to variable "event_ready"
And I assign 0 to variable "evt_loop_count"
While I verify text $event_ready is equal to "FALSE"
And I verify number $event_loop_count is less than 20
    Then I execute scenario "List Outbound Event Data"
    If I verify MOCA status is 0
    	Then I assign row 0 column "evt_stat_cd" to variable "evt_stat_cd"
		If I verify text $evt_stat_cd is equal to "IC"
			Then I assign 1 to variable "event_ready"
		ElsIf I verify text $evt_stat_cd is equal to "SC"
			Then I assign 1 to variable "event_ready"
		ElsIf I verify text $evt_stat_cd is equal to "EC" 
			Then I wait 10 seconds
		Else I fail step with error message "ERROR: Event did not get sent successfully"
    Endif
    Else I wait 10 seconds
    Endif
  	Then I increase variable "event_loop_count" by 1    
EndWhile
If I verify number $event_ready is equal to "FALSE"
	Then I fail step with error message "ERROR: Event did not get logged within time limit"
Endif    
Then I unassign variables "evt_id,evt_arg_val,event_loop_count,event_ready"

@wip @public
Scenario: List Outbound Event Data
#############################################################
# Description: 
#	This scenario returns data for an outbound integrator event    
#	An event can selected by evt_id & evt_arg_val or evt_data_seq
# MSQL Files:
#	list_outbound_event_data.msql
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
        Then I assign variable "err_argument_list" by combining $err_argument_list " evt_id=" $evt_id
    EndIf
    If I verify variable "evt_arg_val" is assigned
        Then I assign variable "err_argument_list" by combining $err_argument_list " evt_arg_id=" $evt_arg_val
    EndIf
    If I verify variable "evt_data_seq" is assigned
        Then I assign variable "err_argument_list" by combining $err_argument_list " evt_data_seq=" $evt_data_seq 
    EndIf
    If I verify variable "evt_dest_sys_id" is assigned
        Then I assign variable "err_argument_list" by combining $err_argument_list " evt_dest_sys_id=" $evt_dest_sys_id 
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

#############################################################
# Private Scenarios:
#	Check Integrator ASN Download - validates an ASN Download
#	Check Integrator Customer Download - validates a Customer Download
#	Check Integrator Supplier Download - validates a Supplier Download
#	Check Integrator Order Download - validates an Order Download
#	Check Integrator Work Order Download - validates a Work Order Download
#	Check Integrator BOM Download - validates a BOM Download
#	Check Integrator PartFootprint Download - validates a PartFootprint Download
#	Check Integrator Shipment Order Download - validates a Shipment Order Download
#	Check Integrator PO Download - validates a PO Download
#	Check Integrator Part Download - validates a Part Download
#############################################################

@wip @private
Scenario: Check Integrator ASN Download
#############################################################
# Description: 
#	This scenario runs a MSQL script to check for the existence
# 	of ASN data. If the Transaction Type is C (Change) then
# 	the logic also returns the value of a field
# MSQL Files:
#	check_integrator_asn_download.msql
# Inputs:
#	Required:
#		trntyp - Transaction Type 
#		invnum - Invoice Number
#		field_to_validate_change - Field to return 
#		client_id - Client Id
#		wh_id - Warehouse Id
#	Optional:
#		None
# Outputs:
#	Field specified by field_to_validate_change
#############################################################

Given I assign "check_integrator_asn_download.msql" to variable "msql_file"
And I execute scenario "Perform MSQL Execution"

@wip @private
Scenario: Check Integrator Customer Download
#############################################################
# Description: 
#	This scenario runs a MSQL script to check for the existence
#	of Customer data. If the Transaction Type is C (Change) then
#	the logic also returns the value of a field
# MSQL Files:
#	None          
# Inputs:
#	Required:
#		trntyp - Transaction Type 
#		cstnum - Customer Number
#		field_to_validate_change - Field to return 
#		client_id - Client Id
#		wh_id - Warehouse Id
#	Optional:
#		None
# Outputs:
#	Field specified by field_to_validate_change
#############################################################

Given I assign "check_integrator_customer_download.msql" to variable "msql_file"
And I execute scenario "Perform MSQL Execution"

@wip @private
Scenario: Check Integrator Order Download 
#############################################################
# Description: 
#	This scenario runs a MSQL script to check for the existence
#	of Order data. If the Transaction Type is C (Change) then
#	the logic also returns the value of a field
# MSQL Files:
#	None              
# Inputs:
#	Required:
#		trntyp - Transaction Type 
#		ordnum - Order Number
#		table_to_validate_change - Table to return
#		field_to_validate_change - Field to return 
#		client_id - Client Id
#		wh_id - Warehouse Id
#	Optional:
#		clause - Must match file value when used
# Outputs:
#	Field specified by field_to_validate_change
#	Field specified by table_to_validate_change
#############################################################

Given I assign "check_integrator_order_download.msql" to variable "msql_file"
And I execute scenario "Perform MSQL Execution"

@wip @private
Scenario: Check Integrator Supplier Download
#############################################################
# Description: 
#	This scenario runs a MSQL script to check for the existence
#	of Supplier data. If the Transaction Type is C (Change) then
#	the logic also returns the value of a field
# MSQL Files:
#	check_integrator_supplier_download.msql
# Inputs:
#	Required:
#		trntyp - Transaction Type 
#		supnum - Supplier Number
#		table_to_validate_change - Table to return
#		field_to_validate_change - Field to return 
#		client_id - Client Id
#		wh_id - Warehouse Id
#	Optional:
#		None
# Outputs:
#	Field specified by field_to_validate_change
#	Field specified by table_to_validate_change
#############################################################

Given I assign "check_integrator_supplier_download.msql" to variable "msql_file"
And I execute scenario "Perform MSQL Execution"

@wip @private
Scenario: Check Integrator Work Order Download
#############################################################
# Description: 
#	This scenario runs a MSQL script to check for the existence
#	of Work Order data. If the Transaction Type is C (Change) then
#	the logic also returns the value of a field
# MSQL Files:
#	check_integrator_work_order_download.msql
# Inputs:
#	Required:
#		trntyp - Transaction Type 
#		wkonum - Work Order Number
#		wkorev - Work Order Revision
#		wkolin - Work Order Line
#		table_to_validate_change - Table to return
#		field_to_validate_change - Field to return 
#		client_id - Client Id
#		wh_id - Warehouse Id
#	Optional:
#		None
# Outputs:
#	Field specified by field_to_validate_change
#	Field specified by table_to_validate_change
#############################################################

Given I assign "check_integrator_work_order_download.msql" to variable "msql_file"
And I execute scenario "Perform MSQL Execution"

@wip @private
Scenario: Check Integrator PartFootprint Download
#############################################################
# Description: 
#      This scenario runs a MSQL script to check for the existence
#      of PartFootprint data. If the Transaction Type is C (Change) then
#      the logic also returns the value of a field
#      If the Transaction Type is D (Delete) then
#      The WMS Transaction will not delete default footprint
# MSQL Files:
#	create_part.msql
#	check_default_footprint.msql
#	check_integrator_partfoot_download.msql
# Inputs:
#	Required:
#		trntyp - Transaction Type 
#		prtnum - Part to be created, used for validation and After Scenario purge
#		ftpcod - Footprint to be created
#		lngdsc - Part description to be created
#		short_dsc - Part description to be created
#		add_part - A flag to add a part for a Footprint Add transaction only and If add_part is Yes then the part and the footprint will be deleted in the cleanup dataset
#		table_to_validate_change - Table to return
#		field_to_validate_change - Field to return 
#		client_id - Client Id
#		wh_id - Warehouse Id
#	Optional:
#		None
# Outputs:
#	Field specified by field_to_validate_change
#	Field specified by table_to_validate_change
#############################################################

Given I "assign variables"
	If I verify text $trntyp is equal to "A"
		If I verify text "YES" is equal to $add_part
			And I assign "create_part.msql" to variable "msql_file"
			Then I execute scenario "Perform MSQL Execution"
		EndIf
	EndIf

	If I verify text $trntyp is equal to "D"
		Then I assign "check_default_footprint.msql" to variable "msql_file"
		And I execute scenario "Perform MSQL Execution"
		If I verify MOCA status is 0
			Then I echo "Default Footprint"
			And I fail step with error message "ERROR: The WMS Transaction will not delete default footprint"
		EndIf 
	EndIf

Then I assign "check_integrator_partfoot_download.msql" to variable "msql_file"
And I execute scenario "Perform MSQL Execution"

@wip @private
Scenario: Check Integrator BOM Download
#############################################################
# Description: 
#	This scenario runs a MSQL script to check for the existence
#	of BOM data. If the Transaction Type is C (Change) then
#	the logic also returns the value of a field
# MSQL Files:
#	check_integrator_bom_download.msql
# Inputs:
#	Required:
#		trntyp - Transaction Type 
#		bomnum - Bill of Material Number
#		table_to_validate_change - Table to return
#		field_to_validate_change - Field to return 
#		client_id - Client Id
#		wh_id - Warehouse Id
#	Optional:
#		None
# Outputs:
#	Field specified by field_to_validate_change
#	Field specified by table_to_validate_change
#############################################################

Given I assign "check_integrator_bom_download.msql" to variable "msql_file"
And I execute scenario "Perform MSQL Execution"

@wip @private
Scenario: Check Integrator Part Download
#############################################################
# Description: 
#	This scenario runs a MSQL script to check for the existence
#	of Part data. If the Transaction Type is C (Change) then
#	the logic also returns the value of a field
# MSQL Files:
#	check_integrator_part_download.msql
# Inputs:
#	Required:
#		trntyp - Transaction Type 
#		prtnum - Part Number
#		field_to_validate_change - Field to return 
#		client_id - Client Id
#		wh_id - Warehouse Id
#	Optional:
#		None
# Outputs:
#	Field specified by field_to_validate_change
#############################################################

Given I assign "check_integrator_part_download.msql" to variable "msql_file"
And I execute scenario "Perform MSQL Execution"

@wip @private
Scenario: Check Integrator PO Download
#############################################################
# Description: 
#	This scenario runs a MSQL script to check for the existence
#	of PO data. If the Transaction Type is C (Change) then
#	the logic also returns the value of a field
# MSQL Files:
#	check_integrator_po_download.msql
# Inputs:
#	Required:
#		trntyp - Transaction Type 
#		invnum - Planned Inbound Order Number
#		table_to_validate_change - Table to return
#		field_to_validate_change - Field to return 
#		client_id - Client Id
#		wh_id - Warehouse Id
#	Optional:
#		None
# Outputs:
#	Field specified by field_to_validate_change
#	Field specified by table_to_validate_change
#############################################################

Given I assign "check_integrator_po_download.msql" to variable "msql_file"
And I execute scenario "Perform MSQL Execution"

@wip @private
Scenario: Check Integrator Shipment Order Download
#############################################################
# Description: 
#	This scenario runs a MSQL script to check for the existence
#	of Shipment Order data. If the Transaction Type is C (Change) then
#	the logic also returns the value of a field
# MSQL Files:
#	check_integrator_order_download.msql
# Inputs:
#	Required:
#		trntyp - Transaction Type 
#		ordnum - Order Number
#		field_to_validate_change - Field to return 
#		client_id - Client Id
#		wh_id - Warehouse Id
#	Optional:
#		None
# Outputs:
#	Field specified by field_to_validate_change
#############################################################

Given I assign "check_integrator_order_download.msql" to variable "msql_file"
And I execute scenario "Perform MSQL Execution"