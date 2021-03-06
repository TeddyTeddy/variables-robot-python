*** Settings ***
Documentation    Suite description
Documentation  Passing a dictionary object from Robot to Python and vice versa
Library        Utils.py
Variables      Utils.py

# To run:
# robot -L debug -d Results/  Tests/robot-dictionary-tests.robot

*** Variables ***
&{D} =          key=original
&{EXPECTED} =   key=modified
&{DICTIONARY} =         key1=value1     key2=value2     key3=value3

*** Keywords ***
(Keyword 1) Call Python To Modify The Dictionary
    [Documentation]  &{named} is an intermediate dictionary, seperate from &{D} in the caller
    ...              ${named} passes the intermediate dictionary 'as is' down to python
    ...              Python indeed modifies the intermediate dictionary
    [arguments]  &{named}
    Log    ${named}                 # {'key': 'original'}
    modify dictionary   ${named}
    Log    ${named}                 # {'key': 'modified'}

(Keyword 2) Call Python To Modify The Dictionary
    [Documentation]  ${named} references a dictionary object, which is also referenced by ${D} in the caller
    [arguments]  ${named}
    Log     ${named}
    modify dictionary   ${named}
    Log     ${named}

Take In A Dictionary
    [Arguments]  ${dictionary}
    FOR   ${key}  IN   @{dictionary}
        Log Many    ${key}      ${dictionary}[${key}]
    END

Take In A Variable Number Of Dictionaries
    [Arguments]  @{varargs}
    FOR   ${dict}  IN  @{varargs}
        Take In A Dictionary    ${dict}
    END

*** Test Cases ***
(Test 1) Modifying Robot Dictionary in Python
    [Documentation]     Compare this very test case with (Test 2). This very test case should fail as expected
    ...                 because we use '&' in &{D} to pass in the items to &{named}. ${named} is local to (Keyword 1)
    (Keyword 1) Call Python To Modify The Dictionary    &{D}
    Should Be Equal   ${D}      ${EXPECTED}

(Test 2) Modifying Robot Dictionary in Python
    [Documentation]     Comparing this very test case with (Test 1). This very test case passes as expected
    ...                 because we use '$' in ${D} to pass in the dictionary as is. ${named} and ${d} points
    ...                 at the same dictionary
    (Keyword 2) Call Python To Modify The Dictionary    ${D}
    Should Be Equal   ${D}      ${EXPECTED}

(Test 3) Passing Multiple Dictionaries To A Keyword
    Take In A Variable Number Of Dictionaries   ${DICTIONARY}   ${python_dictionary}