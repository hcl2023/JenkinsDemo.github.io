/*
Groovy File: http_post_xml.groovy
Description:  This script will POST an XML message to an HTTP endpoint
Input:
	Required:
		api_base_url - Base URL of API (environment variable)
		api_endpoint - API endpoint (e.g. /myendpoint)
		api_cookie - Authentication token
		xml_file OR request_xml - The file or string to POST
	Optional:
		None
Output:
	response_code - The HTTP response code
	response_json - The HTTP response body (JSON expected)
*/
def post = new URL("${api_base_url}${api_endpoint}").openConnection();
post.setRequestMethod('POST');
post.setDoOutput(true);
post.setRequestProperty('Content-Type', 'application/xml');
post.setRequestProperty('Cookie', api_cookie);
byte[] bytes;
if (request_xml == null || request_xml.isEmpty()) {
	bytes = new File(xml_file).bytes;
}
else {
	bytes = request_xml.getBytes('UTF-8');
}
post.getOutputStream().write(bytes);
response_code = post.getResponseCode();
println("HTTP response code: ${response_code}");
response_json = '';
if (response_code >= 200 && response_code < 300) {
	println("HTTP response body: ${response_json}");
	response_json = post.getInputStream().getText();
}