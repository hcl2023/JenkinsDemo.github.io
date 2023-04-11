/*
Groovy File: base64_encode.groovy
Description:
	This script will encode a string using Base64 encoding
Input:
	Required:
		input_string - The string to encode
	Optional:
		None
Output:
	output_string - The Base64-encoded string
*/

output_string = input_string.bytes.encodeBase64().toString()