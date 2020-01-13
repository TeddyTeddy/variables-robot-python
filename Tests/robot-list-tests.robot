*** Settings ***
Documentation  Passing List Objects from Robot to Python and vice versa
Library        Utils.py

# To run:
# robot -L debug -d Results/  Tests/robot-list-tests.robot

*** Keywords ***
(Keyword 1) Call Python To Duplicate The Items
    [Documentation]     Note that @{lst} is an intermediate list, apart from @{l} itself in the caller
    [Arguments]     @{lst}
    ${result} =     duplicate list items  ${lst}
    [return]  ${result}

(Keyword 2) Call Python To Duplicate The Items
    [Documentation]     Note that @{lst} is NOT an intermediate list, it is the same list ${l} points to in the caller
    [Arguments]     ${lst}
    duplicate list items  ${lst}

*** Test Cases ***
(Test 1) Test Duplicating List Items
    [Documentation]     Compare this very test case with (Test 2). In this very test, we use '@' sign
    ...                 in front of @{l}, which passes the list items to the keyword (i.e. not the list itself)
    @{l} =  Create List   ${1}      ${1}    ${1}
    @{expected} =   Create List  ${2}     ${2}     ${2}
    @{l} =  (Keyword 1) Call Python To Duplicate The Items  @{l}
    Should Be Equal     ${l}    ${expected}

(Test 2) Test Duplicating List Items
    [Documentation]     Compare this very test case with (Test 1). In this very test, we use '$' sign
    ...                 in front of ${l}, which passes the list itself to the keyword (i.e. not the list items)
    @{l} =  Create List   ${1}  ${1}    ${1}
    (Keyword 2) Call Python To Duplicate The Items  ${l}   # note that we dont use any return value from the keyword
    Log     ${l}

