*** Settings ***
Documentation    Passing dictionary between Python and Robot and vice versa
Library          Utils.py

# To run:
# robot -L debug -d Results/  Tests/python-dictionary-tests.robot
# robot -L debug -d Results/  Tests/

*** Keywords ***
# TODO: How to pass a default value to ${d} ???
(Keyword 1) Get Super Dictionary From Python
    [Arguments]  ${d}   @{varargs}      &{named}
    Log     ${d}
    Log     ${varargs}
    Log     ${named}
    # ${d}: When this syntax is used, the variable name is replaced with its value as-is
    # @{varargs}: individual items in varargs are passed into args
    # &{named}: individual dictionary items (i.e. key1=${d} ) are passed to kwargs
    #                                                             V                   V
    ${result} =     create super dictionary (version one)  ${d}   @{varargs}          &{named}
    [return]  ${result}

(Keyword 2) Get Super Dictionary From Python
    [Arguments]  ${d}   @{varargs}      &{named}
    Log     ${d}
    Log     ${varargs}
    Log     ${named}
    # ${d}: When this syntax is used, the variable name is replaced with its value as-is
    # ${varargs}: varargs list is passed into args as an item
    # &{named}: individual dictionary items (i.e. key1=${d} ) are passed to kwargs
    #                                                             V                   V
    ${result} =     create super dictionary (version two)  ${d}   ${varargs}          &{named}
    [return]  ${result}

(Keyword 3) Get Super Dictionary From Python
    [Arguments]  ${d}   @{varargs}      &{named}
    Log     ${d}
    Log     ${varargs}
    Log     ${named}
    # ${d}: When this syntax is used, the variable name is replaced with its value as-is
    # ${varargs}: varargs list is passed as an item to args
    # ${named}: named dictionary is passed as an item to args
    #                                                               V                   V
    ${result} =     create super dictionary (version three)  ${d}   ${varargs}          ${named}
    [return]  ${result}

*** Test Cases ***
(Test 3) Passing A Dictionary Between Python and Robot
    ${d} =      get dictionary      # From Python; {'key':'value'}
    @{super_list} =     Create List   ${d}      ${d}
    &{super_dict} =     Create Dictionary   key1=${d}       key2=${d}

    ${result} =  (Keyword 3) Get Super Dictionary From Python   ${d}
    ${expected} =       Create Dictionary   d_count=${1}
    Should Be Equal     ${result}        ${expected}

    # TODO: Change @{super_list} with ${super_list} and explain the difference in behaviour
    # TODO: with ${super_list}                                 d=${d}   varargs=[[d, d]]    named={ }
    # TODO: with @{super_list}                                 d=${d}   varargs=[d, d]      named={ }
    ${result} =  (Keyword 3) Get Super Dictionary From Python   ${d}    @{super_list}
    ${expected} =       Create Dictionary   d_count=${3}
    Should Be Equal     ${result}        ${expected}

    # TODO: Change &{super_dict} with ${super_dict} and explain the difference in behaviour
    # TODO: with ${super_dict}                                 d=${d}   varargs=[d, d, {'key1':d, 'key2':d}]    named={ }
    # TODO: with &{super_dict}                                 d=${d}   varargs=[d, d]     named={'key1':d, 'key2':d}
    ${result} =  (Keyword 3) Get Super Dictionary From Python   ${d}    @{super_list}      &{super_dict}
    ${expected} =       Create Dictionary   d_count=${5}
    Should Be Equal     ${result}        ${expected}

(Test 2) Passing A Dictionary Between Python and Robot
    ${d} =      get dictionary      # From Python; {'key':'value'}
    @{super_list} =     Create List   ${d}      ${d}
    &{super_dict} =     Create Dictionary   key1=${d}       key2=${d}

    ${result} =  (Keyword 2) Get Super Dictionary From Python   ${d}
    ${expected} =       Create Dictionary   d_count=${1}
    Should Be Equal     ${result}        ${expected}

    # TODO: Change @{super_list} with ${super_list} and explain the difference in behaviour
    # TODO: with ${super_list}                                 d=${d}   varargs=[[d, d]]    named={ }
    # TODO: with @{super_list}                                 d=${d}   varargs=[d, d]      named={ }
    ${result} =  (Keyword 2) Get Super Dictionary From Python   ${d}    @{super_list}
    ${expected} =       Create Dictionary   d_count=${3}
    Should Be Equal     ${result}        ${expected}

    # TODO: Change &{super_dict} with ${super_dict} and explain the difference in behaviour
    # TODO: with ${super_dict}                                 d=${d}   varargs=[d, d, {'key1':d, 'key2':d}]    named={ }
    # TODO: with &{super_dict}                                 d=${d}   varargs=[d, d]     named={'key1':d, 'key2':d}
    ${result} =  (Keyword 2) Get Super Dictionary From Python   ${d}    @{super_list}      &{super_dict}
    ${expected} =       Create Dictionary   d_count=${5}
    Should Be Equal     ${result}        ${expected}


(Test 1) Passing A Dictionary Between Python and Robot
    ${d} =      get dictionary      # From Python; {'key':'value'}
    @{super_list} =     Create List   ${d}      ${d}
    &{super_dict} =     Create Dictionary   key1=${d}       key2=${d}

    ${result} =  (Keyword 1) Get Super Dictionary From Python   ${d}
    ${expected} =       Create Dictionary   d_count=${1}
    Should Be Equal     ${result}        ${expected}

    ${result} =  (Keyword 1) Get Super Dictionary From Python   ${d}    @{super_list}
    ${expected} =       Create Dictionary   d_count=${3}
    Should Be Equal     ${result}        ${expected}

    ${result} =  (Keyword 1) Get Super Dictionary From Python   ${d}    @{super_list}      &{super_dict}
    ${expected} =       Create Dictionary   d_count=${5}
    Should Be Equal     ${result}        ${expected}


