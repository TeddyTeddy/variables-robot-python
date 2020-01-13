*** Settings ***
Documentation    Suite description
Documentation  Passing List Objects from Robot to Python and vice versa
Library        Utils.py

# To run:
# robot -L debug -d Results/  Tests/robot-list-tests.robot
# robot -L debug -d Results/  Tests/

*** Keywords ***
Call Python To Duplicate The Items
    [Arguments]     @{l}
    ${result} =     duplicate list items  ${l}
    [return]  ${result}

*** Test Cases ***
Test Duplicating List Items
    @{l} =  Create List   ${1}  ${1}    ${1}
    @{l} =  Call Python To Duplicate The Items  @{l}
    Log     ${l}



