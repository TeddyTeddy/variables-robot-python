*** Settings ***
Documentation    Test passing a boolean object from Python to Robot and vice versa
Library          Utils.py

# To run:
# robot -L debug -d Results/  Tests/python-boolean-tests.robot

*** Keywords ***
Call Python But It Does Not Flip
    [Arguments]  ${bool}
    Log     ${bool}  # True
    does not flip in robot    ${bool}
    Log     ${bool}  # True

Call Python And It Does Flip
    [Arguments]  ${bool}
    Log     ${bool}  # True
    ${bool} =  do flip in robot    ${bool}
    Log     ${bool}  # False
    [return]    ${bool}

*** Test Cases ***
Passing A Boolean Object Between Python And Robot
    ${b} =  get boolean     # from Python, True

    Call Python But It Does Not Flip  ${b}
    Should Be Equal  ${b}   ${True}

    ${b} =  Call Python And It Does Flip     ${b}
    Should Be Equal  ${b}   ${False}



