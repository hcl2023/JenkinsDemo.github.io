/*
Groovy File: generate_query_string.groovy
Description:
	This script will generate a properly formatted, URL-encoded
	query string that includes the variable names and values
	specified by the "columns" parameter
	https://en.wikipedia.org/wiki/Query_string

	Example:
		URL Parameters (as collection of key-value pairs):
			| key         | value   |
			|-------------|---------|
			| warehouseId | WMD1    |
			| itemNumber  | MY ITEM |

		Proper query string representation:
			warehouseId=WMD1&itemNumber=MY+ITEM
Input:
	Required:
		columns  - a comma-separated list of variable names
	Optional:
		None
Output:
	query_string - URL-encoded query string
*/

import java.net.URLEncoder

/*
// Uncomment this block of code to run Groovy standalone
def columns = 'warehouseId,itemNumber'
warehouseId = 'WMD1'
itemNumber = 'TEST ITEM WITH SPACES & OTHER SPECIAL CHARS==='
*/

StringBuilder sb = new StringBuilder()
String encoding = 'UTF-8'
columns.split(',').each({variableName ->
	if (sb.length() > 0)
	{
		sb.append('&')
	}
	sb.append(URLEncoder.encode(variableName, encoding)).append('=').append(URLEncoder.encode(this."$variableName".toString(), encoding))
})
query_string = sb.toString()
println('Query string: ' + query_string)
