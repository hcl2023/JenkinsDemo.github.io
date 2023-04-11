############################################################
# Copyright © 2019, Tryon Solutions, Inc.
# All rights reserved. Proprietary and confidential.
# This file is subject to the license terms found at
# https://www.cycleautomation.com/end-user-license-agreement/
############################################################
#
# Feature Name: hello_world.feature
# Author: Tryon Solutions
# Cycle Version: 2.2.0
#
# Description:
# This simplified executable example Feature is included for
# reference. If executed, it will open notepad, type some text,
# and close notepad.
#
# Usage Instructions:
# Click the "Play" button at the top of the Feature to
# execute this example Feature.
#
# For Additional Information:
# Cycle User Manual: http://www.cycleautomation.com/user-manual/
# Cycle Support: help@cycleautomation.com
############################################################

Feature: Hello World

# Any Steps added to a Background block will run at the beginning
# of each Scenario in the Feature. Only one Background is allowed
# per Feature.
Background: Open Notepad
Given I minimize Cycle
And I execute process "notepad.exe"
And I assign "Defining variables in a Background makes them available to use in all Scenarios in a Feature." to variable "text"
And I wait 2 seconds

# Scenarios are blocks of Steps that run independently of one another.
# Multiple Scenarios are allowed per Feature.
Scenario: Enter Text
Then I echo "This Step will print text to the Output Panel and reports. It does not perform any action beyond that."
And I enter "This Step will enter text into whatever program is active on the desktop."
And I press keys ENTER
And I wait 2 seconds
And I enter $text
And I wait 2 seconds
And I enter "See the Step Guide under the Help menu in Cycle for more Steps (web, terminal, file interactions, etc)!"
And I wait 2 seconds

# Any Steps added to an After Scenario block will run AFTER each Scenario
# in the Feature. Only one After Scenario is allowed per Feature.
After Scenario: Close Notepad
Then I press keys ENTER
And I press keys ALT+SPACE
Then I press keys C
Then I press keys RIGHT
Then I press keys ENTER
