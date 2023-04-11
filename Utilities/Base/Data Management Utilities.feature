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
# Utility: Data Management Utilities.feature
# 
# Functional Area: Data Setup and Management
# Author: Tryon Solutions
# Blue Yonder WMS Version: Consult Bundle Release Notes
# Test Case Type: Utility
# Blue Yonder Interfaces Interacted With: SQL, MOCA
# 
# Description:
# This utility contains scenarios to manage test data.  The logic supports 
# dynamic data processing for test inputs, pre and post test validations,
# and handling XML.
#
# Public Scenarios:
#	- Process Dynamic Data Variables - Evaluates all the test inputs to determine if dynamic data processing is configured.  If so, the dynamic data logic is run for the variables.
#	- Process Test Case Pre Validations - Perform Pre Test Validations
#	- Process Test Case Post Validations - Perform Post Test Validations
#
# Assumptions:
# None
#
# Notes:
# None
#
############################################################
Feature: Data Management Utilities

@wip @public
Scenario: Process Dynamic Data Variables
#############################################################
# Description:  
#  Evaluates all the test inputs to determine if dynamic data processing is configured.  
#  If so, the dynamic data logic is run for the variables.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		dynamic_data - flag to determine if dynamic data processing is enabled for the current test
#		test_case_examples - Name of CSV file containing the test case input examples
# 	Optional:
#		None
# Outputs:
# 	None
#############################################################

Given I "determine if dynamic data processing is enabled"
    If I verify text $dynamic_data is equal to "TRUE" ignoring case 

      Given I "read the example file to get the list of test case variables"
          If I verify variable "test_case" is assigned
          		Then I assign variable "test_case_examples_file" by combining "Test Case Inputs/" $test_case ".csv"
          Else  I assign variable "test_case_examples_file" by combining "Test Case Inputs/" $test_case_examples
          EndIf
          Then I assign next line from $test_case_examples_file to variable "csv_header_list"

      Then I "loop through each variable checking if the value indicates the use of dynamic data processing"
          Given I assign 1 to variable "variable_list_idx"
          While I assign $variable_list_idx th item from "," delimited list $csv_header_list to variable "variable"
             If I assign contents of variable $variable to "value" 
             And I verify text $value is not equal to "" 
             And I execute Groovy "temp_value=value.toString();first_character_of_value=temp_value.substring(0,1)"
             And I verify text $first_character_of_value is equal to "?"
                  Then I execute scenario "Process Dynamic Data Lookup and Execute"  
             EndIf
             Then I increase variable "variable_list_idx"
          EndWhile
    EndIf

@wip @public
Scenario: Process Test Case Pre Validations
#############################################################
# Description: This sets the validation type to "PRE" and calls the logic to perform pre validations
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		test_case_examples - name of examples file and of the validation file
#		pre_validations - Flag indicating if pre-validations should be performed
#	Optional:
#		None
# Outputs:
#	None                        
#############################################################

If I verify variable "pre_validations" is assigned
And I verify text $pre_validations is equal to "TRUE" ignoring case
	Given I assign "PRE" to variable "validation_type"
	Then I execute scenario "Process Test Case Validations"
EndIf

@wip @public
Scenario: Process Test Case Post Validations
#############################################################
# Description: This sets the validation type to "POST" and calls the logic to perform post validations
# MSQL Files:
#	None
# Inputs:
#	Required:
#		test_case_examples - name of examples file and of the validation file
#		post_validations - Flag indicating if post-validations should be performed
#	Optional:
#		None
# Outputs:
#	None                      
#############################################################

If I verify variable "post_validations" is assigned
And I verify text $post_validations is equal to "TRUE" ignoring case
	Then I assign "POST" to variable "validation_type"
	And I execute scenario "Process Test Case Validations"
EndIf

#############################################################
# Private Scenarios:
#	Process Dynamic Data Lookup and Execute
#	Perform Dynamic Data Scenario Instruction
#	Perform Dynamic Data MSQL Instruction
#	Perform Dynamic Data SQL Instruction
#	Perform Dynamic Data Prompt String Instruction
#	Perform Dynamic Data Prompt Integer Instruction
#	Process Dynamic Data Return Fields 
#	Process Dynamic Data Return Fields for Datasets
#	Process Test Case Validations - locates the validation configuration file for the test and performs all the validations
#	Map Test Case Validation Parameters - Map Test Case Validation Parameters
# 	Unmap Test Case Case Validation Parameters - unassign cycle variables used for parameters
#	Perform Test Case Validation - This scenario peforms the validation instructions
#############################################################

@wip @private
Scenario: Process Dynamic Data Lookup and Execute
#############################################################
# Description:  
#   For a variable requiring dynamic data processing, this scenario will
#   search the dynamic data CSV files to find the configure instruction and
#	then execute and instruction.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		variable - The name of the test case input variable for with dynamic data is being used 
#		value - The dynamic data value assigned to the variable (or the retry_value)
#		first_character_of_value - The first character of the contents in $value. If this is not ? then value is a Default value for the variable
# 	Optional:
#		None
# Outputs:
# 	The variable specified in $variable will be populated.
#############################################################

Given I "Check if we need to retrieve the first character for recursive calls"
    If I verify variable $first_character_of_value is assigned
    Else I execute Groovy "temp_value=value.toString();first_character_of_value=temp_value.substring(0,1)"
    EndIf

Then I "determine if this is a Default value or an actual dynamic data value"
	If I verify text $first_character_of_value is equal to "?"
    	Then I unassign variable "first_character_of_value"
     	Then I echo $variable $value
        
        When I "search the CSV file for the instruction configured for the dynamic data value"
            Given I assign "lookup_dynamic_data_instructions.groovy" to variable "groovy_file"
            when I execute scenario "Perform Groovy Execution"
            Then I echo $instruction_type $instruction $where_clause $order_by_clause $return_fields $retry_value
            
        Then I "perform variable substitution on the where_clause and assign where and order by to moca environment varaibles"
            Given I assign $where_clause to variable "sql_string"
            And I execute scenario "Perform Variable Replacement in SQL String"
            If I verify variable "moca_server_connection" is assigned
			And I verify text $moca_server_connection is not equal to ""
            	Then I assign $sql_string to variable "where_clause"
            	And I assign $order_by_clause to variable "order_by_clause"
            EndIf
            
     	Then I "perform the instruction according to the configured instruction type"
            If I verify text $instruction_type is equal to "Scenario" ignoring case
				If I execute scenario "Perform Dynamic Data Scenario Instruction"
				ElsIf I verify text $retry_value is not equal to ""
					Then I assign $retry_value to variable "value"
					And I execute scenario "Process Dynamic Data Lookup and Execute"
				Else I fail step with error message $error_message
				EndIf
            ElsIf I verify text $instruction_type is equal to "MSQL" ignoring case
				If I execute scenario "Perform Dynamic Data MSQL Instruction" 
				ElsIf I verify text $retry_value is not equal to ""
					Then I assign $retry_value to variable "value"
					And I execute scenario "Process Dynamic Data Lookup and Execute"
				Else I fail step with error message $error_message
				EndIf
            ElsIf I verify text $instruction_type is equal to "SQL" ignoring case
				If I execute scenario "Perform Dynamic Data SQL Instruction"
				ElsIf I verify text $retry_value is not equal to ""
					Then I assign $retry_value to variable "value"
					And I execute scenario "Process Dynamic Data Lookup and Execute"
				Else I fail step with error message $error_message
				EndIf
            ElsIf I verify text $instruction_type is equal to "Prompt-String" ignoring case
				Then I execute scenario "Perform Dynamic Data Prompt String Instruction"
            ElsIf I verify text $instruction_type is equal to "Prompt-Integer" ignoring case
				Then I execute scenario "Perform Dynamic Data Prompt Integer Instruction"
            ElsIf I verify text $instruction_type is equal to "SKIP" ignoring case
				Then I assign variable "error_message" by combining "No value found for the dynamic data value " $value 
				And I fail step with error message $error_message
			EndIf 
	Else I "am in the retry logic with default value (does not start with ?), just default the value"
		Then I assign $value to variable $variable
	EndIf
    
@wip @private
Scenario: Perform Dynamic Data Scenario Instruction
#############################################################
# Description:  
#   Run the Cycle scenario configured as a dynamic data instruction and handle
#	assigning the values after the scenario call.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		variable - The name of the test case input variable for with dynamic data is being used 
#		instruction - The scenario to be called 
#		extra_fields - extra cycle variables that should get populated and stored by the scenario
# 	Optional:
#		None		
# Outputs:
# 	error_message - Filled in if the scenario fails
#############################################################

Given I "execute the scenario cofigured in dynamic data"
    If I execute scenario $instruction
    Else I assign variable "error_message" by combining "Error running scenario (" $instruction ") for variable " $variable " and value " $value
       And I fail step with error message $error_message
    EndIf
    
Then I "assign the value found to the variable being processed"
    Given I execute scenario "Process Dynamic Data Return Fields"    
    
@wip @private
Scenario: Perform Dynamic Data MSQL Instruction
#############################################################
# Description:  
#   Run the MSQL File configured as a dynamic data instruction and handle
#	assigning the values after the scenario call.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		variable - The name of the test case input variable for with dynamic data is being used 
#		instruction - The scenario to be called 
#		return_fields - variables that should get populated and stored by the scenario
# 	Optional:
#		None		
# Outputs:
# 	error_message - Filled in if the scenario fails
#############################################################

Given I "execute the MSQL File cofigured in dynamic data"
    Given I assign $instruction to variable "msql_file"
    When I execute scenario "Perform MSQL Execution"
	If I verify MOCA status is 0
	ElsIf I verify MOCA status is 510
		Then I assign variable "error_message" by combining "No Data Found error running MSQL (" $instruction ") for variable " $variable " and value " $value
		And I fail step with error message $error_message
	Else I assign variable "error_message" by combining "Error running MSQL (" $instruction ") for variable " $variable " and value " $value
		And I fail step with error message $error_message
	EndIf

Then I "assign the value found to the variable being processed"
 	Given I execute scenario "Process Dynamic Data Return Fields for Datasets"
               
@wip @private             
Scenario: Perform Dynamic Data SQL Instruction
#############################################################
# Description:  
#   Run the SQL File configured as a dynamic data instruction and handle
#	assigning the values after the scenario call.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		variable - The name of the test case input variable for with dynamic data is being used 
#		instruction - The scenario to be called 
#		return_fields - variables that should get populated and stored by the scenario
# 	Optional:
#		None		
# Outputs:
# 	error_message - Filled in if the scenario fails
#############################################################

Given I "execute the SQL File cofigured in dynamic data"
    Given I assign $instruction to variable "sql_file"
    When I execute scenario "Perform SQL Execution"
    If I verify SQL status is 0
    ElsIf I verify SQL status is -1403
        Then I assign variable "error_message" by combining "No Data Found error running SQL (" $instruction ") for variable " $variable " and value " $value
        And I fail step with error message $error_message
    ElsIf I verify 0 rows in result set
        Then I assign variable "error_message" by combining "No Data Found error running SQL (" $instruction ") for variable " $variable " and value " $value
        And I fail step with error message $error_message             
    Else I assign variable "error_message" by combining "Error running SQL (" $instruction ") for variable " $variable " and value " $value
		And I fail step with error message $error_message
    EndIf
 
Then I "assign the value found to the variable being processed"
	Given I execute scenario "Process Dynamic Data Return Fields for Datasets"
             
@wip @private                 
Scenario: Perform Dynamic Data Prompt String Instruction
#############################################################
# Description:  
#   Prompt the user for a string value and store it in the variable
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		variable - The name of the test case input variable for with dynamic data is being used 
#		instruction - The text prompt
# 	Optional:
#		None		
# Outputs:
# 	error_message - Filled in if the scenario fails
#############################################################

Given I "prompt user and store the value"
    Given I prompt $instruction and assign user response to variable "value"
    Then I assign $value to variable $variable
             
@wip @private              
Scenario: Perform Dynamic Data Prompt Integer Instruction
#############################################################
# Description:  
#   Prompt the user for an integer value and store it in the variable
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		variable - The name of the test case input variable for with dynamic data is being used 
#		instruction - The text prompt
# 	Optional:
#		None		
# Outputs:
# 	error_message - Filled in if the scenario fails
#############################################################

Given I "prompt user and store the value"
    Given I prompt $instruction for integer and assign user response to variable "value"
    Then I assign $value to variable $variable
             
@wip @private             
Scenario: Process Dynamic Data Return Fields
#############################################################
# Description:  
#	This scenario will use fill in the fields designated in the 
#	return_fields list from values populated from a scenario call
#	and assign moca environment variables.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		returns_field - list of fields to be populated 
# 	Optional:
#		None
# Outputs:
# 	The variable specified in $variable will be populated.
#############################################################

Given I assign 1 to variable "return_fields_loop"
While I assign $return_fields_loop nd item from "," delimited list $return_fields to variable "next_field"
	If I assign contents of variable $next_field to "value" 
	And I verify text $value is not equal to "" 
    	If I verify number $return_fields_loop is equal to 1
			Then I assign $value to variable $variable
        Else I echo "Not the first/test input value"
            Then I assign $value to variable $next_field
   		EndIf
    EndIf
    Then I increase variable "return_fields_loop"
EndWhile

@wip @private  
Scenario: Process Dynamic Data Return Fields for Datasets
#############################################################
# Description:  
#	This scenario will use fill in the fields designated in the 
#	return_fields list from values populated from a SQL or MSQL
# 	dataset	and assign moca environment variables.
# MSQL Files:
#	None
# Inputs:
# 	Required:
#		returns_field - list of fields to be populated 
# 	Optional:
#		None
# Outputs:
# 	The variable specified in $variable will be populated.
#############################################################

Given I assign 1 to variable "return_fields_loop"
While I assign $return_fields_loop nd item from "," delimited list $return_fields to variable "next_field"
    If I assign row 0 column $next_field to variable "value"
	And I verify text $value is not equal to "" 
        If I verify number $return_fields_loop is equal to 1
           Then I assign $value to variable $variable
        Else I echo "Not the first/test input value"
            Then I assign $value to variable $next_field
        EndIf
    EndIf
    Then I increase variable "return_fields_loop"
EndWhile

@wip @private
Scenario: Process Test Case Validations
#############################################################
# Description: This scenario locates the validation configuration file
# for the test and performs all the validations
# MSQL Files:
#	None
# Inputs:
#	Required:
#		test_case - Name of test case, maps to the name of file containing validations
#		validation_type - Indicates if Pre or Post validations should be performed
#	Optional:
#		None
# Outputs:
#	None                      
#############################################################

Given I "find the validation file"
    Given I assign variable "file" by combining $test_case_validations_directory_location $test_case "-Validations.csv"
    Then I execute scenario "Locate File on Path"
	If I verify variable "new_file" is assigned
		Then I assign $new_file to variable "validation_file"
		And I unassign variable "new_file"
    EndIf
 
If I verify variable "validation_file" is assigned
	While I assign values in next row from $validation_file to variables
    	If I verify text $type is equal to $validation_type 
    		Given I echo $type $instruction_type $instruction
            When I execute scenario "Map Test Case Validation Parameters"
            Then I execute scenario "Perform Test Case Validation"
            And I execute scenario "Unmap Test Case Validation Parameters"
        EndIf
    EndWhile
    Then I reset line counter for $validation_file
	And I unassign variable "validation_file"
EndIf

@wip @private
Scenario: Map Test Case Validation Parameters
#############################################################
# Description: This scenario maps the input parameters for the validation instructions
# MSQL Files:
#	None
# Inputs:
#	Required:
#       validation_parameters - Comma seperated list of Cycle variables to be mapped to parameters
#		validation_type - Indicates if Pre or Post validations should be performed
#	Optional:
#		None
# Outputs:
#       parameter_1 - Validation Parameter (also assigned to parameter_1)
#       parameter_2 - Validation Parameter (also assigned to parameter_2)
#       parameter_3 - Validation Parameter (also assigned to parameter_3)
#       parameter_x - Validation Parameter (also assigned to parameter_x)  
#		parameter_count - The number of parameters assigned
#############################################################

Given I "loop through the parameter list and I map the input parameters"
	Given I assign 0 to variable "parameter_count"

    	Given I assign 1 to variable "parameter_loop"
        While I assign variable "input_parameter" by combining "parameter_" $parameter_loop
        And I verify variable $input_parameter is assigned
        
            Given I assign contents of variable $input_parameter to "parameter"            
            When I "determine that the first charater is $ then we assign from a cycle variable, otherwise it is a fixed value"
            	If I verify text $parameter is not equal to ""
                    Then I execute Groovy "tmp=parameter.toString();first_character_of_parameter=tmp.substring(0,1);cycle_variable = tmp.substring(1)"
                    If I verify text $first_character_of_parameter is equal to "$"
                        Then I assign contents of variable $cycle_variable to $input_parameter
                    Else I echo "Parameter " $input_parameter " already has the fixed values of " $parameter
                    EndIf
                Else I assign "" to variable $input_parameter
             	EndIf
             
            Then I "adjust the counters"
                Given I increase variable "parameter_count"                
                And I increase variable "parameter_loop"
        EndWhile

@wip @private
Scenario: Unmap Test Case Validation Parameters
#############################################################
# Description: This scenario unassigns the cycle variables used for input parameters
# MSQL Files:
#	None
# Inputs:
#	Required:
#       parameter_count - The number of varibles mapped to parameters
#	Optional:
#       parameter_1 - Validation Parameter (also assigned to parameter_1)
#       parameter_2 - Validation Parameter (also assigned to parameter_2)
#       parameter_3 - Validation Parameter (also assigned to parameter_3)
#       parameter_x - Validation Parameter (also assigned to parameter_x)  
# Outputs:
#	None
#############################################################

Given I "loop through the parameter list and unassign the cycle variable and moca environment variables"
	While I verify number $parameter_count is greater than 0
    	Given I assign variable "input_parameter" by combining "parameter_" $parameter_count
        Then I unassign variable $input_parameter

        And I decrease variable "parameter_count"
    EndWhile
    Then I unassign variable "parameter_count"
    
@wip @private
Scenario: Perform Test Case Validation
#############################################################
# Description: This scenario peforms the validation instructions
# MSQL Files:
#	None
# Inputs:
#	Required:
#		instruction_type - Type of instruction to perform
#		instruction - Validation Instruction to be performed
#	Optional:
#       parameter_1 - Validation parameter
#       parameter_2 - Validation parameter 
#       parameter_3 - Validation parameter
#       parameter_x - Validation parameter 
# Outputs:
#      None                      
#############################################################

Given I "evaluate the type of validation and perform the validation instructions"
    If I verify text $instruction_type is equal to "Scenario" ignoring case
    	If I execute scenario $instruction
            If I verify text $validation_status is not equal to "TRUE"
            	If I verify variable "error_message" is assigned
                And I verify text $error_message is not equal to ""
                	Then I assign variable "error_message" by combining "ERROR: Validation " $instruction " failed with error: " $error_message
                Else I assign variable "error_message" by combining "ERROR: Validation " $instruction " failed."
                EndIf
                Then I fail step with error message $error_message
            EndIf
        Else I "handle the failed validation"
        	If I verify variable "error_message" is assigned
        	And I verify text $error_message is not equal to ""
          		Then I assign variable "error_message" by combining "ERROR: Validation " $instruction " failed with error: " $error_message
      		Else I assign variable "error_message" by combining "ERROR: Validation " $instruction " failed."      
        	EndIf
			Then I fail step with error message $error_message
		EndIf        
    Elsif I verify text $instruction_type is equal to "MSQL" ignoring case
    	When I assign $instruction to variable "msql_file"
     	Then I execute scenario "Perform MSQL Execution" 
        If I verify MOCA status is 0 
        	If I assign row 0 column "validation_status" to variable "validation_status"
            And I verify text $validation_status is equal to "TRUE"
            	Then I "continue as the validation passed"
            Else I "handle the error conditions"
            	If I assign row 0 column "error_message" to variable "error_message"
                	Then I assign variable "error_message" by combining "ERROR: Validation " $instruction " failed with error: " $error_message
            	Else I assign variable "error_message" by combining "ERROR: Validation " $instruction " failed."
            	EndIf
            	Then I fail step with error message $error_message
            EndIf
        Else I assign variable "error_message" by combining "ERROR: Validation " $instruction " failed."
			And I fail step with error message $error_message
        EndIf
        
    Elsif I verify text $instruction_type is equal to "SQL" ignoring case
     	When I assign $instruction to variable "sql_file"
     	Then I execute scenario "Perform SQL Execution"
		If I verify SQL status is 0    
        	# A SQL validation must return at least 1 row to be considered a pass
            If I verify 0 rows in result set
            	Then I assign variable "error_message" by combining "ERROR: Validation " $instruction " failed."
                And I fail step with error message $error_message
            EndIf
        Else I assign variable "error_message" by combining "ERROR: Validation " $instruction " failed."
			And I fail step with error message $error_message
        EndIf
        
    ElsIf I verify text $instruction_type is equal to "Prompt-String" ignoring case
    	When I prompt $instuction and assign user response to variable "validation_prompt_response"
        If I verify text $validation_prompt_response is not equal to $parameter_1
            Then I assign variable "error_message" by combining "ERROR: Validation " $instruction " failed.  Expect response (" $parameter_1 ") Actual response (" $validation_prompt_response ")" 
        	And I fail step with error message $error_message
        EndIf
        
    ElsIf I verify text $instruction_type is equal to "Prompt-Integer" ignoring case
    	When I prompt $instuction for integer and assign user response to variable "validation_prompt_response"
        And I convert string variable "parameter_1" to INTEGER variable "parameter_1_int"
        If I verify number $validation_prompt_response is not equal to $parameter_1_int
        	Then I assign variable "error_message" by combining "ERROR: Validation " $instruction " failed.  Expect response (" $parameter1 ") Actual response (" $validation_prompt_response ")" 
        	And I fail step with error message $error_message
        EndIf
    EndIf
    
@wip @private
Scenario: Perform Variable Replacement in SQL String
#############################################################
# Description: 
# This scenario accepts a SQL string and converts and cycle variables
# in the $ notation with the value contains within the cycle variable
# MSQL Files:
#	None
# Inputs:
#	Required:
#		sql_string - Source string for processing
#	Optional:
#		None
# Outputs:
#      sql_string - With cycle variables replaces with data values                    
#############################################################

If I verify text $sql_string is not equal to ""
    Given I "call commad to parse sql string into text list and cycle variable list"
        Given I assign "parse_cycle_variables_from_sql_string.groovy" to variable "groovy_file"
        And i execute scenario "Perform Groovy Execution"

    Then I "merge the text list with the variable list, replacing the variable with the value"
        Given I assign "" to variable "new_string"
        And I assign 1 to variable "list_count" 
        While I assign $list_count st item from "]" delimited list $text_list to variable "text"
            Then I assign variable "new_string" by combining $new_string $text
            If I assign $list_count st item from "]" delimited list $cycle_var_list to variable "cycle_variable"
                Then I assign contents of variable $cycle_variable to "cycle_variable_value"
                Then I assign variable "new_string" by combining $new_string $cycle_variable_value
            EndIf
            Then I increase variable "list_count"
        EndWhile
        Then I assign $new_string to variable "sql_string"

    And I "clean up the working variables"
        Then I unassign variables "new_string,list_count,text_list"
        If I verify variable "cycle_var_list" is assigned
        	Then I unassign variables "cycle_var_list,cycle_variable"
        EndIf
EndIf