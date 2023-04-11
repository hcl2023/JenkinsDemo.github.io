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
# Utility: Web Serialization Utilities.feature
#
# Functional Area: Serialization
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: utility
# Blue Yonder Interfaces Interacted With: Web
# 
# Description: This utility contains scenarios using the Web to perform serialization activities
#
# Public Scenarios:
#	- Web Scan Serial Number Cradle to Grave Receiving
#
# Assumptions:
# - See Terminal Serialization Utilities.feature for full details on serialization
#
# Notes:
# None
# 
############################################################ 
Feature: Web Serialization Utilities

@wip @public
Scenario: Web Scan Serial Number Cradle to Grave Receiving
#############################################################
# Description: For CRDL_TO_GRAVE receiving serialization in web,
# first (if lodnum is not provided) click on generate LPNs button 
# and then based screen data, enter the requested serial numbers 
# for each serial number type grouping.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		None
#	Optional:
#		lodnum - load number
# Outputs:
#	serialization_phase - set to RCV
#############################################################

Given I "perform CRDL_TO_GRAVE receiving serialization, look for serial number (from file) and enter/validate that serial number"
	Then I "click on Generate LPNs button (if lodnum was not specified)"
		If I verify variable "lodnum" is assigned
        And I verify text $lodnum is not equal to ""
        Else I assign variable "elt" by combining "xPath://span[text()='Generate LPNs']//.."
			And I click element $elt in web browser within $max_response seconds
        	And I wait $wait_med seconds
		EndIf
        
    And I assign "RCV" to variable "serialization_phase"
    
	And I "extract from screen the list of labels corresponding to serial number types and save list"
		And I assign "1" to variable "index_label"
		And I convert string variable "index_label" to integer variable "index_label_num"
		And I assign "FALSE" to variable "completed"
		And I assign "" to variable "ser_num_type_list"
        
		While I verify text $completed is equal to "FALSE" 
			Then I convert number variable "index_label_num" to string variable "index_label"
			And I assign variable "elt_ser_label" by combining "xPath://div[contains(@class,'serialization-fields')][1]/descendant::label[" $index_label "]"
			If I see element $elt_ser_label in web browser within $wait_long seconds
				Then I copy text inside element $elt_ser_label in web browser to variable "serial_num_type" within $max_response seconds          
				And I increase variable "index_label_num" by 1
				If I verify text $ser_num_type_list is equal to ""
					Then I assign $serial_num_type to variable "ser_num_type_list"
 				Else I assign variable "ser_num_type_list" by combining $ser_num_type_list "," $serial_num_type
				EndIf
			Else I assign "TRUE" to variable "completed"
 			EndIf
		EndWhile
        
	And I "store the number of serial number types seen on screen"
		Then I decrease variable "index_label_num" by 1
        And I convert number variable "index_label_num" to string variable "num_ser_types"
        And I assign "FALSE" to variable "lpns_completed"
		And I assign variable "elt_lpn_base" by combining "xPath://div[contains(@id, 'inventoryidentification-numbercapture-identifiers')]/descendant::div[contains(@class, 'x-component x-box-item')]"
            
	And I "setup for finding all LPNs needed relative to receive quantity (left side of SN capture screen)"
    	Then I assign "0" to variable "lpn_cnt"
        And I convert string variable "lpn_cnt" to integer variable "lpn_cnt_num"
        
    And I "iterate though each group of serial numbers requested to meet quantities received"
		Given I increase variable "lpn_cnt_num" by 1
		While I verify text $lpns_completed is equal to "FALSE"
		And I verify number $lpn_cnt_num is less than or equal to 1
			And I assign variable "elt_lpn_generate_item" by combining $elt_lpn_base "[" $lpn_cnt_num "]"
			If I see element $elt_lpn_generate_item in web browser within $wait_long seconds
            	Then I click element $elt_lpn_generate_item in web browser within $max_response seconds
        		While I see "Enter a range" in web browser within $wait_med seconds    
					Given I assign 1 to variable "ser_num_typ_cnt"
 					While I assign $ser_num_typ_cnt th item from "," delimited list $ser_num_type_list to variable "serial_num_type"
						And I "set the type of serial number, look up a new one to use and enter it"
        					And I execute scenario "Create Variable cradle_to_grave_rcv_serial_file"
							And I assign $crdle_to_grave_rcv_serial_file to variable "serial_num_file"
							When I execute scenario "Get Serial Number from Serial Number File"
        					Then I type $serial_scan in web browser

						And I "move to the next serial number input element (next serial number type)"
							If I verify text $ser_num_typ_cnt is equal to $num_ser_types
                    		Else I press keys TAB in web browser
                    		EndIf
                    
						And I increase variable "ser_num_typ_cnt"
					EndWhile
            
            		And I "press enter which will process current serial number group for selected LPN"
            		And I "and determine if more serial number inputs are needed"
            			Given I press keys "ENTER" in web browser
            			Once I do not see "Duplicate" in web browser within $wait_short seconds
        		EndWhile
				And I increase variable "lpn_cnt_num" by 1
        	Else I assign "TRUE" to variable "lpns_completed"
 			EndIf
		EndWhile
    
    And I "click on Receive button to complete serialization"
		Then I assign variable "elt" by combining "xPath://span[text()='Receive']//.."
		And I click element $elt in web browser within $max_response seconds
        
	And I "allow identification process to complete" which can take between $max_response seconds and 60 seconds
        
	And I unassign variables "serial_num_file,num_ser_types,ser_num_typ_cnt"
    And I unassign variables "ser_num_type_list,elt_ser_label,index_label,index_label_num"
    And I unassign variables "lpn_cnt,lpn_cnt_num,elt_lpn_generate_item,lpns_completed,elt_lpn_base"