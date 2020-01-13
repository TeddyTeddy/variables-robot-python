*** Settings ***
Documentation       Passing python string objects from python to Robot and back to Python
Library             Utils.py


# To run:
# robot -L debug -d Results/  Tests/python-string-tests.robot
# robot -L debug -d Results/  Tests/

*** Variables ***
${GLOBAL_VAR}           GLOBAL-ROBOT


*** Keywords ***
(Keyword 1) Get Merged String From Python
    [Arguments]   ${pos_arg_1}     ${pos_arg_2}=ROBOT   ${pos_arg_3}=${GLOBAL_VAR}   @{varargs}   &{named}
     Log     ${varargs}    # i.e. ['PYTHON', 'PYTHON', 'PYTHON']
     Log     ${named}        # i.e. {'key1': 'PYTHON', 'key2': 'PYTHON'}

    # @{varargs} => individual list items are passed in as arguments separately
    # &{named} => individual items of the dictionary are passed as named arguments to the keyword
    # In Python:                            arg1           arg2          arg3            *args        **kwargs
    #                                                                                    V            V
    ${result}=  string merge (version one)  ${pos_arg_1}  ${pos_arg_2}   ${pos_arg_3}    @{varargs}   &{named}
    [return]  ${result}

(Keyword 2) Get Merged String From Python
    [Arguments]   ${pos_arg_1}     ${pos_arg_2}=ROBOT   ${pos_arg_3}=${GLOBAL_VAR}   @{varargs}   &{named}
     Log     ${varargs}
     Log     ${named}

    # ${varargs}  ${varargs}  => each ${varargs} is a list object. ${varargs} list objects are passed in as items to *args
    # &{named} => individual items of the dictionary are passed as named arguments to **kwargs
    # In Python:                            arg1           arg2          arg3            *args       *args       **kwargs
    #                                                                                    V           V           V
    ${result}=  string merge (version two)  ${pos_arg_1}  ${pos_arg_2}   ${pos_arg_3}    ${varargs}  ${varargs}  &{named}
    [return]  ${result}

(Keyword 3) Get Merged String From Python
    [Arguments]   ${pos_arg_1}     ${pos_arg_2}=ROBOT   ${pos_arg_3}=${GLOBAL_VAR}   @{varargs}   &{named}
     Log     ${varargs}
     Log     ${named}

    # ${varargs}  ${varargs}  => each ${varargs} is a list object. ${varargs} list objects are passed in as items to *args
    # ${named} => the dictionary object is passed in as an item to *args
    # In Python:                              arg1           arg2          arg3            *args        *args      *args
    #                                                                                      V            V          V
    ${result}=  string merge (version three)  ${pos_arg_1}  ${pos_arg_2}   ${pos_arg_3}    ${varargs}  ${varargs}  ${named}
    [return]  ${result}

*** Test Cases ***
(Test 3) Test Passing Strings Between Python and Robot
    ${s} =          get string      # from python
    @{list}=        Create List  ${s}    ${s}    ${s}
    &{dict}=        Create Dictionary   key1=${s}   key2=${s}

    ${merged} =  (Keyword 3) Get Merged String From Python   ${s}
    ${expected}=    Set Variable    PYTHON ROBOT GLOBAL-ROBOT
    Should Be Equal     ${merged}  ${expected}

    ${merged} =  (Keyword 3) Get Merged String From Python   ${s}    ${s}
    ${expected}=    Set Variable    PYTHON PYTHON GLOBAL-ROBOT
    Should Be Equal     ${merged}  ${expected}

    ${merged} =  (Keyword 3) Get Merged String From Python   ${s}    ${s}    ${s}
    ${expected}=    Set Variable    PYTHON PYTHON PYTHON
    Should Be Equal     ${merged}  ${expected}

    ${merged} =  (Keyword 3) Get Merged String From Python   ${s}    ${s}    ${s}      @{list}
    ${expected}=    Set Variable    PYTHON PYTHON PYTHON PYTHON PYTHON PYTHON PYTHON PYTHON PYTHON     # PYTHON x 9
    Should Be Equal     ${merged}  ${expected}

    ${merged} =  (Keyword 3) Get Merged String From Python   ${s}    ${s}    ${s}      @{list}      &{dict}
    ${expected}=    Set Variable    PYTHON PYTHON PYTHON PYTHON PYTHON PYTHON PYTHON PYTHON PYTHON PYTHON PYTHON     # PYTHON x 11
    Should Be Equal     ${merged}  ${expected}

(Test 2) Test Passing Strings Between Python and Robot
    ${s} =          get string      # from python
    @{list}=        Create List  ${s}    ${s}    ${s}
    &{dict}=        Create Dictionary   key1=${s}   key2=${s}

    ${merged} =  (Keyword 2) Get Merged String From Python   ${s}
    ${expected}=    Set Variable    PYTHON ROBOT GLOBAL-ROBOT
    Should Be Equal     ${merged}  ${expected}

    ${merged} =  (Keyword 2) Get Merged String From Python   ${s}   ${s}
    ${expected}=    Set Variable    PYTHON PYTHON GLOBAL-ROBOT
    Should Be Equal     ${merged}  ${expected}

    ${merged} =  (Keyword 2) Get Merged String From Python   ${s}   ${s}   ${s}
    ${expected}=    Set Variable    PYTHON PYTHON PYTHON
    Should Be Equal     ${merged}  ${expected}

    ${merged} =  (Keyword 2) Get Merged String From Python   ${s}   ${s}   ${s}     @{list}
    ${expected}=    Set Variable    PYTHON PYTHON PYTHON PYTHON PYTHON PYTHON PYTHON PYTHON PYTHON      # PYTHON x 9
    Should Be Equal     ${merged}  ${expected}

    ${merged} =  (Keyword 2) Get Merged String From Python   ${s}    ${s}    ${s}      @{list}      &{dict}
    ${expected}=    Set Variable    PYTHON PYTHON PYTHON PYTHON PYTHON PYTHON PYTHON PYTHON PYTHON PYTHON PYTHON     # PYTHON x 11
    Should Be Equal     ${merged}  ${expected}


(Test 1) Test Passing Strings Between Python and Robot
    ${s} =          get string      # from python
    @{list}=        Create List  ${s}    ${s}    ${s}
    &{dict}=        Create Dictionary   key1=${s}   key2=${s}

    # test: pass ${s} as ${pos_arg_1}
    ${merged}=      (Keyword 1) Get Merged String From Python     ${s}
    ${expected}=    Set Variable    PYTHON ROBOT GLOBAL-ROBOT
    Should Be Equal     ${merged}  ${expected}

    # test: pass ${s} as ${pos_arg_1} and as ${pos_arg_2}
    ${merged}=      (Keyword 1) Get Merged String From Python     ${s}   ${s}
    ${expected}=    Set Variable    PYTHON PYTHON GLOBAL-ROBOT
    Should Be Equal     ${merged}  ${expected}

    # test: pass ${s} as as ${pos_arg_1} and ${pos_arg_2} and as ${pos_arg_3}
    ${merged}=      (Keyword 1) Get Merged String From Python     ${s}   ${s}   ${s}
    ${expected}=    Set Variable    PYTHON PYTHON PYTHON
    Should Be Equal     ${merged}  ${expected}

    # test: pass ${s} as as ${pos_arg_1} and ${pos_arg_2} and as ${pos_arg_3}
    #       pass @{list} : individual list items are passed in as arguments separately
    ${merged}=      (Keyword 1) Get Merged String From Python     ${s}   ${s}   ${s}   @{list}
    ${expected}=    Set Variable    PYTHON PYTHON PYTHON PYTHON PYTHON PYTHON           # PYTHON X 6
    Should Be Equal     ${merged}  ${expected}

    # test: pass ${s} as as ${pos_arg_1} and ${pos_arg_2} and as ${pos_arg_3}
    #       pass @{list} as @{varargs}
    #       pass &{dict} as &{named}
    ${merged}=      (Keyword 1) Get Merged String From Python     ${s}   ${s}   ${s}   @{list}   &{dict}
    ${expected}=    Set Variable    PYTHON PYTHON PYTHON PYTHON PYTHON PYTHON PYTHON PYTHON     # PYTHON X 8
    Should Be Equal     ${merged}  ${expected}

