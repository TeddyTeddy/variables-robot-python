*** Settings ***
Documentation       Passing python tuple object between python and Robot and vice versa
Library             Collections
Library             Utils.py


# To run:
# robot -L debug -d Results/  Tests/python-tuple-tests.robot
# robot -L debug -d Results/  Tests/

*** Variables ***


*** Keywords ***
# TODO: How to pass ${t1} a default value (i.e. (0, 0, 0))
(Keyword 1) Get The Sum Tuple From Python
    [Arguments]  ${t1}    @{varargs}       &{named_tuples}
    Log  ${t1}              # (1, 2, 3)
    Log  ${varargs}      # i.e. [(1, 2, 3), (1, 2, 3), (1, 2, 3)] or []
    Log  ${named_tuples}      # i.e. {'key1': (1, 2, 3), 'key2': (1, 2, 3)} or {}

    # ${t1}: When this syntax is used, the variable name is replaced with its value as-is
    # @{varargs}: individual list items are passed in as arguments separately
    # &{named_tuples}: individual items of the dictionary are passed as named arguments to the keyword
    # In Python:                                          t1     *args        **kwargs
    #                                                            V               V
    ${sum_tuple}=   calculate sum tuple (version one)    ${t1}   @{varargs}   &{named_tuples}
    [return]  ${sum_tuple}


(Keyword 2) Get The Sum Tuple From Python
    [Arguments]  ${t1}    @{varargs}       &{named_tuples}
    Log  ${t1}              # (1, 2, 3)
    Log  ${varargs}      # i.e. [(1, 2, 3), (1, 2, 3), (1, 2, 3)]
    Log  ${named_tuples}      # i.e. {'key1': (1, 2, 3), 'key2': (1, 2, 3)}

    # ${t1}: When this syntax is used, the variable name is replaced with its value as-is
    # ${varargs}: the list is passed as an item to *args
    # &{named_tuples}: individual items of the dictionary are passed as named arguments to the keyword
    # In Python:                                          t1     *args           **kwargs
    #                                                            V               V
    ${sum_tuple}=   calculate sum tuple (version two)    ${t1}   ${varargs}   &{named_tuples}
    [return]  ${sum_tuple}

(Keyword 3) Get The Sum Tuple From Python
    [Arguments]  ${t1}    @{varargs}       &{named_tuples}
    Log  ${t1}              # (1, 2, 3)
    Log  ${varargs}      # i.e. [(1, 2, 3), (1, 2, 3), (1, 2, 3)]
    Log  ${named_tuples}      # i.e. {'key1': (1, 2, 3), 'key2': (1, 2, 3)}

    # ${t1}: When this syntax is used, the variable name is replaced with its value as-is
    # ${varargs}: the list is passed as an item to *args
    # ${named_tuples}: the dictionary is passed as an item to *args
    # In Python:                                            t1     *args           *args
    #                                                              V               V
    ${sum_tuple}=   calculate sum tuple (version three)    ${t1}   ${varargs}   ${named_tuples}
    [return]  ${sum_tuple}

*** Test Cases ***
(Test 3) Test Passing Tuples Between Robot And Python
    ${t} =   get tuple          # from Python; (1, 2, 3)
    @{l} =   Create List     ${t}       ${t}       ${t}    # ${t}. When this syntax is used, the variable name is replaced with its value as-is
    &{d} =   Create Dictionary   key1=${t}   key2=${t}     # ${t}. When this syntax is used, the variable name is replaced with its value as-is

    #                                                           t1=${t}     varargs=[]       named_tuples={}
    ${sum_tuple} =    (Keyword 3) Get The Sum Tuple From Python   ${t}
    ${sum_list} =     Convert To List   ${sum_tuple}
    ${expected} =     Create List       ${1}   ${2}   ${3}
    Should Be Equal     ${sum_list}        ${expected}

    # TODO: replace @{l} with ${l} and explain the difference in behaviour
    # TODO: with ${l}                                           t1={t}      varargs=[ [t, t, t] ]   named_tuples={}
    # TODO: with @{l}                                           t1={t}      varargs=[t, t, t]   named_tuples={}
    #                                                                       V
    ${sum_tuple} =    (Keyword 3) Get The Sum Tuple From Python   ${t}      @{l}
    ${sum_list} =     Convert To List   ${sum_tuple}
    ${expected} =     Create List       ${4}   ${8}   ${12}
    Should Be Equal     ${sum_list}        ${expected}

    # TODO: replace &{d} with ${d} and explain the difference in behaviour
    # TODO: with ${d}                                           t1=${t}     varargs=[t, t, t, d]    named_tuples={}
    # TODO: with &{d}                                           t1=${t}     varargs=[t, t, t]       named_tuples={'key1':t, 'key2': t}
    #                                                                                                  V
    ${sum_tuple} =    (Keyword 3) Get The Sum Tuple From Python   ${t}      @{l}                       &{d}
    ${sum_list} =     Convert To List   ${sum_tuple}
    ${expected} =     Create List       ${6}   ${12}   ${18}
    Should Be Equal     ${sum_list}        ${expected}


(Test 2) Test Passing Tuples Between Robot And Python
    ${t} =   get tuple          # from Python
#   Log     ${tuple}                # (1, 2, 3)
    @{l} =   Create List     ${t}       ${t}       ${t}    # ${t}. When this syntax is used, the variable name is replaced with its value as-is
    &{d} =   Create Dictionary   key1=${t}   key2=${t}     # ${t}. When this syntax is used, the variable name is replaced with its value as-is

    #                                                           t1=${t}     varargs=[]       named_tuples={}
    ${sum_tuple} =    (Keyword 2) Get The Sum Tuple From Python   ${t}
    ${sum_list} =     Convert To List   ${sum_tuple}
    ${expected} =     Create List       ${1}   ${2}   ${3}
    Should Be Equal     ${sum_list}        ${expected}

    # TODO: Change  @{l} to ${l} and explain the difference in behaviour
    # TODO: With @{l}:                                       t1=${t}     varargs=[t, t, t]      named_tuples={}
    # TODO: With ${l}:                                       t1=${t}     varargs=[[t, t, t]]      named_tuples={}
    ${sum_tuple} =    (Keyword 2) Get The Sum Tuple From Python   ${t}      @{l}
    ${sum_list} =     Convert To List   ${sum_tuple}
    ${expected} =     Create List       ${4}   ${8}   ${12}
    Should Be Equal     ${sum_list}        ${expected}

    # TODO: change &{d} to ${d} and explain the difference in behaviour
    # TODO: with &{d}:                                       t1=${t}     varargs=[t, t, t]       named_tuples={key1:t, key2=t }
    # TODO: with ${d}:                                       t1=${t}     varargs=[t, t, t, {key1: t, key2:t}]     named_tuples={}
    ${sum_tuple} =    (Keyword 2) Get The Sum Tuple From Python   ${t}      @{l}                    &{d}
    ${sum_list} =     Convert To List   ${sum_tuple}
    ${expected} =     Create List       ${6}   ${12}   ${18}
    Should Be Equal     ${sum_list}        ${expected}


(Test 1) Test Passing Tuples Between Robot And Python
    ${t} =   get tuple          # from Python
#   Log     ${tuple}                # (1, 2, 3)
    @{l} =   Create List     ${t}       ${t}       ${t}    # ${t}. When this syntax is used, the variable name is replaced with its value as-is
    &{d} =   Create Dictionary   key1=${t}   key2=${t}     # ${t}. When this syntax is used, the variable name is replaced with its value as-is

    #                                                           t1=${t}     varargs=[]       named_tuples={}
    ${sum_tuple} =    (Keyword 1) Get The Sum Tuple From Python   ${t}
    ${sum_list} =     Convert To List   ${sum_tuple}
    ${expected} =     Create List       ${1}   ${2}   ${3}
    Should Be Equal     ${sum_list}        ${expected}

    # @{l}: individual list items are passed in as arguments separately
    #                                                           t1=${t}     varargs=[(1,2,3), (1,2,3), (1,2,3)]       named_tuples={}
    ${sum_tuple} =    (Keyword 1) Get The Sum Tuple From Python   ${t}      @{l}
    ${sum_list} =     Convert To List   ${sum_tuple}
    ${expected} =     Create List       ${4}   ${8}   ${12}
    Should Be Equal     ${sum_list}        ${expected}

    # @{l}: individual list items are passed in as arguments separately
    # &{d}: individual items of the dictionary are passed as named arguments to the keyword.
    #                                                           t1=${t}     varargs=[(1,2,3), (1,2,3), (1,2,3)]       named_tuples={'key1': (1, 2, 3), 'key2': (1, 2, 3)}
    ${sum_tuple} =    (Keyword 1) Get The Sum Tuple From Python   ${t}      @{l}                                      &{d}
    ${sum_list} =     Convert To List   ${sum_tuple}
    ${expected} =     Create List       ${6}   ${12}   ${18}
    Should Be Equal     ${sum_list}        ${expected}