*** Settings ***
Documentation    Passing list objects from Python to Robot and vice versa
Library          Utils.py

# To run:
# robot -L debug -d Results/  Tests/python-list-tests.robot
# robot -L debug -d Results/  Tests/

*** Keywords ***
# TODO: How to pass l1 a default value (i.e. [0, 0, 0]) ???
(Keyword 1) Get The Sum List From Python
    [Arguments]  ${l1}      @{varargs}        &{named}
    Log     ${l1}
    Log     ${varargs}
    Log     ${named}
    # ${l1}: When this syntax is used, the variable name is replaced with its value as-is
    # @{varargs}: individual list items are passed in as arguments separately
    # &{named}: individual items of the dictionary are passed as named arguments to the keyword
    # In Python:                                          t1     *args              **kwargs
    #                                                            V                  V
    ${sum_list} =   calculate sum list (version one)    ${l1}    @{varargs}         &{named}
    [return]  ${sum_list}

(Keyword 2) Get The Sum List From Python
    [Arguments]  ${l1}      @{varargs}        &{named}
    Log     ${l1}
    Log     ${varargs}
    Log     ${named}
    # ${l1}: When this syntax is used, the variable name is replaced with its value as-is
    # ${varargs}: the varargs list object is passed to args as is
    # &{named}: individual items of the dictionary are passed as named arguments to the keyword
    # In Python:                                          t1     *args              **kwargs
    #                                                            V                  V
    ${sum_list} =   calculate sum list (version two)    ${l1}    ${varargs}         &{named}
    [return]  ${sum_list}

(Keyword 3) Get The Sum List From Python
    [Arguments]  ${l1}      @{varargs}        &{named}
    Log     ${l1}
    Log     ${varargs}
    Log     ${named}
    # ${l1}: When this syntax is used, the variable name is replaced with its value as-is
    # ${varargs}: the varargs list object is passed to args, as is
    # ${named}: the dictionary is passed to args, as is
    # In Python:                                          t1        *args            *args
    #                                                               V                V
    ${sum_list} =   calculate sum list (version three)    ${l1}     ${varargs}       ${named}
    [return]  ${sum_list}

*** Test Cases ***
(Test 3) Passing Lists Between Python And Robot
    ${l} =   get list          # from Python; [2, 2, 2]
    @{ll} =  Create List     ${l}       ${l}       ${l}    # ${l}. When this syntax is used, the variable name is replaced with its value as-is
    &{d} =   Create Dictionary   key1=${l}   key2=${l}     # ${l}. When this syntax is used, the variable name is replaced with its value as-is

    #                                                           l1=${l}     varargs=[]       named={}
    ${sum_list} =    (Keyword 3) Get The Sum List From Python   ${l}
    ${expected} =     Create List       ${2}   ${2}   ${2}
    Should Be Equal     ${sum_list}        ${expected}

    # TODO: replace @{ll} with ${ll} and explain the difference in behaviour
    # TODO: with ${ll}                                          l1=${l}     varargs=[ [l, l, l] ]   named={}
    # TODO: with @{ll}                                          l1=${l}     varargs=[l, l, l]       named = {}
    #                                                                       V
    ${sum_list} =    (Keyword 3) Get The Sum List From Python   ${l}        @{ll}
    ${expected} =     Create List       ${8}   ${8}   ${8}
    Should Be Equal     ${sum_list}        ${expected}

    # TODO: replace &{d} with ${d} and explain the difference in behaviour
    # TODO: with ${d}                                           l1=${l}     varargs=[l, l, l, d]    named={}
    # TODO: with &{d}                                           l1=${l}     varargs=[l, l, l]       named={'key1':l, 'key2': l}
    #                                                                                        V
    ${sum_list} =    (Keyword 3) Get The Sum List From Python   ${l}        @{ll}            &{d}
    ${expected} =     Create List       ${12}   ${12}   ${12}
    Should Be Equal     ${sum_list}        ${expected}

(Test 2) Passing Lists Between Python And Robot
    ${l} =   get list          # from Python; [2, 2, 2]
    @{ll} =  Create List     ${l}       ${l}       ${l}    # ${l}. When this syntax is used, the variable name is replaced with its value as-is
    &{d} =   Create Dictionary   key1=${l}   key2=${l}     # ${l}. When this syntax is used, the variable name is replaced with its value as-is

    #                                                           l1=${l}     varargs=[]       named={}
    ${sum_list} =    (Keyword 2) Get The Sum List From Python   ${l}
    ${expected} =     Create List       ${2}   ${2}   ${2}
    Should Be Equal     ${sum_list}        ${expected}

    # TODO: replace @{ll} with ${ll} and explain the difference in behaviour
    # TODO: with ${ll}                                          l1=${l}     varargs=[ [l, l, l] ]   named={}
    # TODO: with @{ll}                                          l1=${l}     varargs=[l, l, l]       named = {}
    #                                                                       V
    ${sum_list} =    (Keyword 2) Get The Sum List From Python   ${l}        @{ll}
    ${expected} =     Create List       ${8}   ${8}   ${8}
    Should Be Equal     ${sum_list}        ${expected}

    # TODO: replace &{d} with ${d} and explain the difference in behaviour
    # TODO: with ${d}                                           l1=${l}     varargs=[l, l, l, d]    named={}
    # TODO: with &{d}                                           l1=${l}     varargs=[l, l, l]       named={'key1':l, 'key2': l}
    #                                                                                        V
    ${sum_list} =    (Keyword 2) Get The Sum List From Python   ${l}        @{ll}            &{d}
    ${expected} =     Create List       ${12}   ${12}   ${12}
    Should Be Equal     ${sum_list}        ${expected}

(Test 1) Passing Lists Between Python And Robot
    ${l} =   get list          # from Python; [2, 2, 2]
    @{ll} =  Create List     ${l}       ${l}       ${l}    # ${l}. When this syntax is used, the variable name is replaced with its value as-is
    &{d} =   Create Dictionary   key1=${l}   key2=${l}     # ${l}. When this syntax is used, the variable name is replaced with its value as-is

    #                                                           l1=${l}     varargs=[]       named={}
    ${sum_list} =    (Keyword 1) Get The Sum List From Python   ${l}
    ${expected} =     Create List       ${2}   ${2}   ${2}
    Should Be Equal     ${sum_list}        ${expected}

    # TODO: replace @{ll} with ${ll} and explain the difference in behaviour
    # TODO: with ${ll}                                          l1=${l}    varargs=[ [l, l, l] ]
    # TODO: with @{ll}                                          l1=${l}    varargs=[l, l, l]       named={}
    #                                                                      V
    ${sum_list} =    (Keyword 1) Get The Sum List From Python   ${l}       @{ll}
    ${expected} =     Create List       ${8}   ${8}   ${8}
    Should Be Equal     ${sum_list}        ${expected}

    # TODO: replace &{d} with ${d} and explain the difference in behaviour
    # TODO: with ${d}                                           l1=${l}     varargs=[l, l, l, d]    named={}
    # TODO: with &{d}                                           l1=${l}     varargs=[l, l, l]       named={'key1'=l, 'key2':l}
    #                                                                                               V
    ${sum_list} =    (Keyword 1) Get The Sum List From Python   ${l}       @{ll}                    &{d}
    ${expected} =     Create List       ${12}   ${12}   ${12}
    Should Be Equal     ${sum_list}        ${expected}