*** Settings ***
Documentation  Passing Set Objects from Python to Robot and vice versa
Library        Utils.py

# To run:
# robot -L debug -d Results/  Tests/python-set-tests.robot
# robot -L debug -d Results/  Tests/


*** Variables ***

*** Keywords ***
(Keyword 1) Process The Sets In Python
    [Arguments]  ${s}       @{varargs}      &{named}
    Log     ${s}
    Log     ${varargs}
    Log     ${named}
    # ${s}:         When this syntax is used, the variable name is replaced with its value as-is
    # @{varargs}:   the items in varargs are passed to args
    # &{named}:     the items in named are passed to kwargs
    ${result} =     count the number of occurrences of {1, 2, 3, 4} (version one)   ${s}       @{varargs}      &{named}
    [Return]     ${result}

# TODO: How to set ${s} parameter a default set (i.e. {0, 0, 0, 0} ) ?
(Keyword 2) Process The Sets In Python
    [Arguments]  ${s}       @{varargs}      &{named}
    Log     ${s}
    Log     ${varargs}
    Log     ${named}
    # ${s}:         When this syntax is used, the variable name is replaced with its value as-is
    # ${varargs}:   varargs list is passed as an item to args
    # &{named}:     the items in named are passed to kwargs
    ${result} =     count the number of occurrences of {1, 2, 3, 4} (version two)   ${s}       ${varargs}      &{named}
    [Return]     ${result}

(Keyword 3) Process The Sets In Python
    [Arguments]  ${s}       @{varargs}      &{named}
    Log     ${s}
    Log     ${varargs}
    Log     ${named}
    # ${s}:         When this syntax is used, the variable name is replaced with its value as-is
    # ${varargs}:   varargs list is passed as an item to args
    # ${named}:     named is passed as an item to args
    ${result} =     count the number of occurrences of {1, 2, 3, 4} (version three)   ${s}       ${varargs}      ${named}
    [Return]     ${result}

*** Test Cases ***
(Test 3) Passing Set From Python to Robot And Vice Versa
    ${s} =     get set   # From Python (1, 2, 3)
    Evaluate     $s.add(4)
    # Log     ${s}   # {1, 2, 3, 4}
    @{super_list} =  Create List     ${s}       ${s}       ${s}     # ${s}. When this syntax is used, the variable name is replaced with its value as-is
    &{super_dict} =   Create Dictionary   key1=${s}   key2=${s}     # ${s}. When this syntax is used, the variable name is replaced with its value as-is

    ${result} =     (Keyword 3) Process The Sets In Python  ${s}
    Should Be Equal As Integers     ${result}       ${1}

    # TODO: Replace @{super_list} with ${super_list} and explain the difference in behaviour
    # TODO: with ${super_list}                                      varargs=[ [s, s, s] ]    named={}
    # TODO: with @{super_list}                                      varargs=[s, s, s]    named={}
    ${result} =     (Keyword 3) Process The Sets In Python  ${s}    @{super_list}
    Should Be Equal As Integers     ${result}       ${4}

    # TODO: Replace &{super_dict} with ${super_dict} and explain the difference in behaviour
    # TODO: with ${super_dict}                                      varargs=[ s, s, s, {'key1': s, 'key2': s} ]    named={}
    # TODO: with &{super_dict}                                      varargs=[s, s, s]    named={'key1': s, 'key2': s}
    ${result} =     (Keyword 3) Process The Sets In Python  ${s}    @{super_list}   &{super_dict}
    Should Be Equal As Integers     ${result}       ${6}


(Test 2) Passing Set From Python to Robot And Vice Versa
    ${s} =     get set   # From Python (1, 2, 3)
    Evaluate     $s.add(4)
    # Log     ${s}   # {1, 2, 3, 4}
    @{super_list} =  Create List     ${s}       ${s}       ${s}     # ${s}. When this syntax is used, the variable name is replaced with its value as-is
    &{super_dict} =   Create Dictionary   key1=${s}   key2=${s}     # ${s}. When this syntax is used, the variable name is replaced with its value as-is

    ${result} =     (Keyword 2) Process The Sets In Python  ${s}
    Should Be Equal As Integers     ${result}       ${1}

    # TODO: Replace @{super_list} with ${super_list} and explain the difference in behaviour
    # TODO: with ${super_list}                                      varargs=[ [s, s, s] ]    named={}
    # TODO: with @{super_list}                                      varargs=[s, s, s]    named={}
    ${result} =     (Keyword 2) Process The Sets In Python  ${s}    @{super_list}
    Should Be Equal As Integers     ${result}       ${4}

    # TODO: Replace &{super_dict} with ${super_dict} and explain the difference in behaviour
    # TODO: with ${super_dict}                                      varargs=[ s, s, s, {'key1': s, 'key2': s} ]    named={}
    # TODO: with &{super_dict}                                      varargs=[s, s, s]    named={'key1': s, 'key2': s}
    ${result} =     (Keyword 2) Process The Sets In Python  ${s}    @{super_list}   &{super_dict}
    Should Be Equal As Integers     ${result}       ${6}

(Test 1) Passing Set From Python to Robot And Vice Versa
    ${s} =     get set   # From Python (1, 2, 3)
    Evaluate     $s.add(4)
    # Log     ${s}   # {1, 2, 3, 4}
    @{super_list} =  Create List     ${s}       ${s}       ${s}     # ${s}. When this syntax is used, the variable name is replaced with its value as-is
    &{super_dict} =   Create Dictionary   key1=${s}   key2=${s}     # ${s}. When this syntax is used, the variable name is replaced with its value as-is

    ${result} =     (Keyword 1) Process The Sets In Python  ${s}
    Should Be Equal As Integers     ${result}       ${1}

    ${result} =     (Keyword 1) Process The Sets In Python  ${s}    @{super_list}
    Should Be Equal As Integers     ${result}       ${4}

    ${result} =     (Keyword 1) Process The Sets In Python  ${s}    @{super_list}   &{super_dict}
    Should Be Equal As Integers     ${result}       ${6}

