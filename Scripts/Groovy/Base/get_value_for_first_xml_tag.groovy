/*
Groovy File: get_value_for_first_xml_tag.groovy
Description: 
	This script will return the value for a tag within an XML string
	If the TAG is in the XML multiple times, this script return
	the value from the first occurance of the TAG
Input:
	Required:   
		xml  - an XML String
		tag  - a XML Tag 
Output:
	tag_value - String containing xml with the tag altered.
*/
import java.util.*
import groovy.xml.*

def stringXML = new XmlParser().parseText(xml)
val = stringXML.depthFirst().find{it -> it.name() == tag}.text()
tag_value = val.toString()