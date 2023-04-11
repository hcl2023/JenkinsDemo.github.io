/*  
Groovy File: parse_cycle_variables_from_sql_string.groovy
Description: 
This script process a text string containing SQL and looks for cycle variables ($ notation).  The logic
returns two lists. A list of the Text values and a list of cycle variables.  The lists use a closing bracket (])
for a seperator.  
 
This script is call from "Perform Variable Replacement in SQL String" in 
"Data Management Utilties"

Input:
	Required:
		sql_string - a string of sql code
 
Output:
	text_list - close bracket seperated list of text from sql string
	cycle_variable_list - close bracket seperated list of cycle variables from sql string

*/
int empty=1; 
while(sql_string.length() > 0){   
   /* find next $ */
   dollar_pos = sql_string.indexOf('$',0) 
   
   if (dollar_pos != -1){
      /* character up to $ are the value for text list */
      text = sql_string.substring(0, dollar_pos )
      
      /* dollar was found - find the next ' or space */
      close_quote = sql_string.indexOf('\'', dollar_pos)
      next_space = sql_string.indexOf(' ', dollar_pos)
      
      if ((close_quote == -1) && (next_space == -1)) {
         /* variable name goes to the end of the string */
         cycle_var = sql_string.substring(dollar_pos+1)
         sql_string = ''
      }
      else if (((close_quote != -1) && (close_quote < next_space)) || (next_space == -1) ) {
         /* ' was found next - cycle variable is from dollar to ' */
         cycle_var = sql_string.substring(dollar_pos+1, close_quote)  
         sql_string = sql_string.substring(close_quote)
      }
      else { 
         /* space was found next - cycle variable is from dollar to space */
         cycle_var = sql_string.substring(dollar_pos+1, next_space) 
         sql_string = sql_string.substring(next_space)
      }
      /* Add text and cycle variable onto the lists */
      if (empty==0){
         text_list = text_list + text + ']'
         cycle_var_list = cycle_var_list + cycle_var + ']'
      }
      else {
         /* first entries on lists */
         text_list =  text + ']'
         cycle_var_list = cycle_var + ']'
		 empty = 0;
      }
   }
   else {
      /* No dollar was found - remainder is last value on text list */
	  if (empty == 1) {
	     text_list = sql_string
	  }
	  else {
         text_list = text_list + sql_string  
	  }
      sql_string=''
   }
}
 