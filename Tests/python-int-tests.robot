*** Settings ***
Documentation       Passing python int objects from Python to Robot and Back To Python
Library             Utils.py

# To run:
# robot -L debug -d Results/  Tests/python-int-tests.robot
# robot -L debug -d Results/  Tests/

*** Variables ***
${VARIABLE}             ${21}

*** Keywords ***
(Keyword 1) Get The Sum From Python
    [Arguments]  ${int_1}       ${int_2}=${0}    ${int_3}=${VARIABLE}    @{varargs}      &{named_ints}
    Log     ${int_1}
    Log     ${int_2}
    Log     ${int_3}
    Log     ${varargs}
    Log     ${named_ints}
    # @{varargs}  syntax: individual list items are passed in as arguments separately
    # &{named_ints}  syntax: individual items of the dictionary are passed as named arguments to the keyword
    # In Python:                                 t1         t2        t3      *args          **kwargs
    #                                                                         V            V
    ${sum}=     calculate sum (version one)  ${int_1}    ${int_2}   ${int_3}  @{varargs}   &{named_ints}
    [return]  ${sum}


(Keyword 2) Get The Sum From Python
    [Arguments]  ${int_1}       ${int_2}=${0}    ${int_3}=${VARIABLE}    @{varargs}      &{named_ints}
    Log     ${int_1}
    Log     ${int_2}
    Log     ${int_3}
    Log     ${varargs}
    Log     ${named_ints}
    # ${varargs}  syntax:  list object is passed as an item to *args
    # &{named_ints}  syntax: individual items of the dictionary are passed as named arguments to the keyword
    # In Python:                                 t1         t2        t3      *args          **kwargs
    #                                                                         V               V
    ${sum}=     calculate sum (version two)  ${int_1}    ${int_2}   ${int_3}  ${varargs}   &{named_ints}
    [return]  ${sum}

(Keyword 3) Get The Sum From Python
    [Arguments]  ${int_1}       ${int_2}=${0}    ${int_3}=${VARIABLE}    @{varargs}      &{named_ints}
    Log     ${int_1}
    Log     ${int_2}
    Log     ${int_3}
    Log     ${varargs}
    Log     ${named_ints}
    # ${varargs}  syntax:  list object is passed as an item to *args
    # ${named_ints}  syntax:  the dictionary is passed as an item to *args
    # In Python:                                 t1         t2        t3      *args             *args
    #                                                                           V               V
    ${sum}=     calculate sum (version three)  ${int_1}    ${int_2}   ${int_3}  ${varargs}   ${named_ints}
    [return]  ${sum}

*** Test Cases ***
(Test 3) Passing Integers Between Python And Robot
    ${i}=           get int   # from python
    @{int_list}=    Create List     ${5}      ${i}      ${i}       # ${i}. When this syntax is used, the variable name is replaced with its value as-is
    &{int_dict}=    Create Dictionary   key1=${i}     key2=${i}    # ${i}. When this syntax is used, the variable name is replaced with its value as-is

    #                                                     int_1 = 2     int_2 = 0    int_3 = 21    varargs = []      named_ints = {}
    ${total}        (Keyword 3) Get The Sum From Python   ${i}
    ${expected}=    Set Variable  ${23}
    Should Be Equal As Numbers     ${total}        ${expected}

    #                                                     int_1 = 2     int_2 = 2    int_3 = 21    varargs = []      named_ints = {}
    ${total}        (Keyword 3) Get The Sum From Python   ${i}          ${i}
    ${expected}=    Set Variable  ${25}
    Should Be Equal As Numbers     ${total}        ${expected}

    #                                                     int_1 = 2     int_2 = 2    int_3 = 2     varargs = []      named_ints = {}
    ${total}        (Keyword 3) Get The Sum From Python   ${i}          ${i}         ${i}
    ${expected}=    Set Variable  ${6}
    Should Be Equal As Numbers     ${total}        ${expected}

    # TODO: change @{int_list} to ${int_list} and explain the behaviour difference
    # TODO: for ${int_list}                               int_1 = 2     int_2 = 2    int_3 = 2     varargs = [[5, 2, 2]]      named_ints = {}
    # TODO:                                               int_1 = 2     int_2 = 2    int_3 = 2     varargs = [5, 2, 2]      named_ints = {}
    ${total}        (Keyword 3) Get The Sum From Python   ${i}          ${i}         ${i}          @{int_list}
    ${expected}=    Set Variable  ${15}
    Should Be Equal As Numbers     ${total}        ${expected}

    # TODO: change &{int_dict} to ${int_dict} and explain the behaviour difference
    # TODO: for ${int_dict}                               int_1 = 2     int_2 = 2    int_3 = 2     varargs = [5, 2, 2, {key1: 2, key2: 2} ]      named_ints = {}
    # TODO: for &{int_dict}                               int_1 = 2     int_2 = 2    int_3 = 2     varargs = [5, 2, 2]      named_ints = {key1: 2, key2: 2}
    ${total}        (Keyword 3) Get The Sum From Python   ${i}          ${i}         ${i}          @{int_list}                 &{int_dict}
    ${expected}=    Set Variable  ${19}
    Should Be Equal As Numbers   ${total}        ${expected}

(Test 2) Passing Integers Between Python And Robot
    ${i}=           get int   # from python
    @{int_list}=    Create List     ${5}      ${i}      ${i}       # ${i}. When this syntax is used, the variable name is replaced with its value as-is
    &{int_dict}=    Create Dictionary   key1=${i}     key2=${i}    # ${i}. When this syntax is used, the variable name is replaced with its value as-is

    #                                                     int_1 = 2     int_2 = 0    int_3 = 21    varargs = []      named_ints = {}
    ${total}        (Keyword 2) Get The Sum From Python   ${i}
    ${expected}=    Set Variable  ${23}
    Should Be Equal As Numbers     ${total}        ${expected}

    #                                                     int_1 = 2     int_2 = 2    int_3 = 21    varargs = []      named_ints = {}
    ${total}        (Keyword 2) Get The Sum From Python   ${i}          ${i}
    ${expected}=    Set Variable  ${25}
    Should Be Equal As Numbers     ${total}        ${expected}

    #                                                     int_1 = 2     int_2 = 2    int_3 = 2    varargs = []      named_ints = {}
    ${total}        (Keyword 2) Get The Sum From Python   ${i}          ${i}         ${i}
    ${expected}=    Set Variable  ${6}
    Should Be Equal As Numbers     ${total}        ${expected}

    #                                                     int_1 = 2     int_2 = 2    int_3 = 2    varargs = [5, 2, 2]      named_ints = {}
    ${total}        (Keyword 2) Get The Sum From Python   ${i}          ${i}         ${i}         @{int_list}
    ${expected}=    Set Variable  ${15}
    Should Be Equal As Numbers     ${total}        ${expected}

    #                                                     int_1 = 2     int_2 = 2    int_3 = 2    varargs = [5, 2, 2]      named_ints = {key1: 2, key2: 2}
    ${total}        (Keyword 2) Get The Sum From Python   ${i}          ${i}         ${i}         @{int_list}                 &{int_dict}
    ${expected}=    Set Variable  ${19}
    Should Be Equal As Numbers     ${total}        ${expected}

(Test 1) Passing Integers Between Python And Robot
    ${i}=           get int   # from python
    @{int_list}=    Create List     ${5}      ${i}      ${i}       # ${i}. When this syntax is used, the variable name is replaced with its value as-is
    &{int_dict}=    Create Dictionary   key1=${i}     key2=${i}    # ${i}. When this syntax is used, the variable name is replaced with its value as-is

    #                                                     int_1 = 2     int_2 = 0    int_3 = 21    varargs = []      named_ints = {}
    ${total}        (Keyword 1) Get The Sum From Python   ${i}
    ${expected}=    Set Variable  ${23}
    Should Be Equal As Numbers     ${total}        ${expected}

    #                                                     int_1 = 2     int_2 = 2    int_3 = 21    varargs = []      named_ints = {}
    ${total}        (Keyword 1) Get The Sum From Python   ${i}   ${i}
    ${expected}=    Set Variable  ${25}
    Should Be Equal As Numbers     ${total}        ${expected}

    #                                                     int1=2    int2=5   int_3=2   varargs=[2]
    ${total}        (Keyword 1) Get The Sum From Python   ${i}    @{int_list}
    ${expected}=    Set Variable  ${11}
    Should Be Equal As Numbers     ${total}        ${expected}

    #                                                     int1=2    int2=2   int_3=5   varargs=[2, 2]  named_ints = {key1: 2, key2: 2}
    ${total}        (Keyword 1) Get The Sum From Python   ${i}  ${i}  @{int_list}  &{int_dict}
    ${expected}=    Set Variable  ${17}
    Should Be Equal As Numbers     ${total}        ${expected}
