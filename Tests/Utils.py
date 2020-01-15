# A utility file that contains keywords for built-in-library-test.robot
from robot.api.deco import keyword
from robot.api import logger


@keyword
def get_boolean():
    return True


@keyword
def does_not_flip_in_robot(b):
    # print(b)   # True
    # Scope Rule #3:   Name assignments will create or change local names by default.
    b = not b  # due to the assignment, name 'b' now points at another boolean object
    # print(b)   # False, does flip in python

@keyword
def do_flip_in_robot(b):
    # print(b)   # True
    # Scope Rule #3:   Name assignments will create or change local names by default.
    b = not b  # due to the assignment, name 'b' now points at another boolean object
    # print(b)   # False, does flip in python
    return b

@keyword
def get_string():
    return 'PYTHON'


@keyword('string merge (version one)')
def string_merge_version_one(arg1, arg2, arg3, *args, **kwargs):

    logger.debug(f'arg1: {arg1}')
    logger.debug(f'arg2: {arg2}')
    logger.debug(f'arg3: {arg3}')
    logger.debug(f'args: {args}')
    logger.debug(f'kwargs: {kwargs}')

    # all arguments must be Strings; raise TypeError otherwise
    if type(arg1) != str or type(arg2) != str or type(arg3) != str:
        raise TypeError('string_merge_one: arg1 or arg2 or arg3 is not a string')
    for item in args:
        if type(item) != str:
            raise TypeError('string_merge_one: an item in args is not a string')
    for key in kwargs:
        if type(kwargs[key]) != str:
            raise TypeError('string_merge_one: kwargs[key] is not a string')

    # all items are String objects, proceed with merging them into one big string
    result = f'{arg1} {arg2} {arg3}'
    for item in args:
        result += f' {item}'
    for key in kwargs:
        result += f' {kwargs[key]}'
    return result


@keyword('string merge (version two)')
def string_merge_version_two(arg1, arg2, arg3, *args, **kwargs):

    logger.debug(f'arg1: {arg1}')
    logger.debug(f'arg2: {arg2}')
    logger.debug(f'arg3: {arg3}')
    logger.debug(f'args: {args}')
    logger.debug(f'kwargs: {kwargs}')

    # arg1, arg2 and arg3 must be Strings; raise TypeError otherwise
    if type(arg1) != str or type(arg2) != str or type(arg3) != str:
        raise TypeError('string_merge_two: arg1 or arg2 or arg3 is not a string')
    # args is a tuple; each item is a list from Robot
    for lst in args:
        if type(lst) != list:
            raise TypeError('string_merge_two: an item in args is not a list')
        for item in lst:
            if type(item) != str:
                raise TypeError('string_merge_two: an item in args[i] (i=0,..) is not a string')
    for key in kwargs:
        if type(kwargs[key]) != str:
            raise TypeError('string_merge_two: kwargs[key] is not a string')

    # arg1, arg2, arg3, *args, **kwargs all contain only strings
    # merge them into a one big string
    result = f'{arg1} {arg2} {arg3}'
    for lst in args:  # lst is a list
        for item in lst:
            result += f' {item}'
    for key in kwargs:
        result += f' {kwargs[key]}'
    return result


@keyword('string merge (version three)')
def string_merge_version_three(arg1, arg2, arg3, *args, **kwargs):

    logger.debug(f'arg1: {arg1}')
    logger.debug(f'arg2: {arg2}')
    logger.debug(f'arg3: {arg3}')
    logger.debug(f'args: {args}')
    logger.debug(f'kwargs: {kwargs}')

    # arg1, arg2, arg3, *args, **kwargs all ultimately contain only strings
    # merge them into a one big string
    result = f'{arg1} {arg2} {arg3}'
    for item in args[0]:  # args[0] is a list
        result += f' {item}'
    for item in args[1]:  # args[1] is a list
        result += f' {item}'
    for key in args[2]:  # args[2] is a dictionary
        result += f' {args[2][key]}'
    for key in kwargs:
        result += f' {kwargs[key]}'
    return result


@keyword
def get_int():
    return 2


@keyword('calculate sum (version one)')
def calculate_sum_version_one(int_1, int_2, int_3, *args, **kwargs):

    logger.debug(f'int_1: {int_1}')
    logger.debug(f'int_2: {int_2}')
    logger.debug(f'int_3: {int_3}')
    logger.debug(f'args: {args}')
    logger.debug(f'kwargs: {kwargs}')

    # all arguments must be integers; raise TypeError otherwise
    if type(int_1) != int or type(int_2) != int or type(int_3) != int:
        raise TypeError('calculate sum (version one): int_1 or int_2 or int_3 is not int')
    for item in args:
        if type(item) != int:
            raise TypeError('calculate sum (version one): an item in args is not an integer')
    for key in kwargs:
        if type(kwargs[key]) != int:
            raise TypeError('calculate sum (version one): a value in kwargs is not an integer')

    result = int_1 + int_2 + int_3
    result += sum(args)
    result += sum(kwargs.values())
    return result


@keyword('calculate sum (version two)')
def calculate_sum_version_two(int_1, int_2, int_3, *args, **kwargs):

    logger.debug(f'int_1: {int_1}')
    logger.debug(f'int_2: {int_2}')
    logger.debug(f'int_3: {int_3}')
    logger.debug(f'args: {args}')  # args[0] must be a list of integers
    logger.debug(f'kwargs: {kwargs}')

    # all arguments must be integers; raise TypeError otherwise
    if type(int_1) != int or type(int_2) != int or type(int_3) != int:
        raise TypeError('calculate sum (version two): int_1 or int_2 or int_3 is not int')
    for item in args:
        if type(item) != list:
            raise TypeError('calculate sum (version two): an item in args is not a list')
    for key in kwargs:
        if type(kwargs[key]) != int:
            raise TypeError('calculate sum (version two): a value in kwargs is not an integer')

    result = int_1 + int_2 + int_3
    result += sum(args[0])
    result += sum(kwargs.values())
    return result


@keyword('calculate sum (version three)')
def calculate_sum_version_three(int_1, int_2, int_3, *args, **kwargs):

    logger.debug(f'int_1: {int_1}')
    logger.debug(f'int_2: {int_2}')
    logger.debug(f'int_3: {int_3}')
    logger.debug(f'args: {args}')  # args[0] must be a list of integers, args[1] must be a dictionary
    logger.debug(f'kwargs: {kwargs}')  # kwargs  must always be an empty dictionary

    result = int_1 + int_2 + int_3
    result += sum(args[0])  # args[0] must be a list of integers (i.e. [5, 2, 2] or [] )
    result += sum(args[1].values())  # args[1] must be a dictionary (i.e. {key1: 2, key2: 2}  or {} )
    result += sum(kwargs.values())
    return result


@keyword
def get_tuple():
    return 1, 2, 3


@keyword('calculate sum tuple (version one)')
def calculate_sum_tuple_version_one(t1, *args, **kwargs):
    """ t1 must be a tuple
        args must be a tuple of tuples, where each item must have the length being equal to len(t1)
        kwargs must be a dictionary, where values must be tuples. Each tuple must have the length being equal to len(t1)
        Example:
            t1 = (1, 2, 3)
            args = ((1, 2, 3), (1, 2, 3), (1, 2, 3))  OR ()
            kwargs = {key1: (1, 2, 3), key2: (1, 2, 3)} OR {}
    """
    logger.debug(f't1: {t1}')
    logger.debug(f'args: {args}')
    logger.debug(f'kwargs: {kwargs}')

    # all arguments must be a tuple; raise TypeError otherwise
    if type(t1) != tuple:
        raise TypeError('calculate sum tuple (version one): t1 must be a tuple')
    for item in args:
        if type(item) != tuple:
            raise TypeError('calculate sum tuple (version one): each item in args must be a tuple')
    for key in kwargs:
        if type(kwargs[key]) != tuple:
            raise TypeError('calculate sum tuple (version one): each value in kwargs must be a tuple')

    # TODO: Make sure that the length of the passed tuples are equal to len(t1)
    result = list(t1)  # t1 = (1, 2, 3)
    # args = (t, t)  where t is a tuple (1, 2, 3)
    for t in args:
        result = list(map(lambda x, y: x+y, t, result))
    # kwargs = {key1: t, key2: t} where t is a tuple (1, 2, 3)
    for key in kwargs:
        result = list(map(lambda x, y: x+y, kwargs[key], result))
    return tuple(result)


@keyword('calculate sum tuple (version two)')
def calculate_sum_tuple_version_two(t1, *args, **kwargs):
    """ t1 must be a tuple; (1, 2, 3)
        args must be a tuple containing 1 item, a list. The list contains tuples, which are (1, 2, 3) each
        kwargs must be a dictionary, where values must be tuples. Each tuple must have the length being equal to len(t1)
        Example:
            t1 = (1, 2, 3)
            args = ( [t, t, t] ) where t = (1, 2, 3)  OR ( [], )
            kwargs = { 'key1': (1, 2, 3),  'key2': (1, 2, 3) }  OR {}
    """
    logger.debug(f't1: {t1}')
    logger.debug(f'args: {args}')
    logger.debug(f'kwargs: {kwargs}')

    # TODO: Make sure that the length of the passed tuples are equal to len(t1)
    result = list(t1)
    # args = ([t, t, t], )  where t is a tuple (1, 2, 3)  OR args=([],)
    for t in args[0]:
        result = list(map(lambda x, y: x+y, t, result))
    # kwargs = {key1: t, key2: t}  where t is a tuple (1, 2, 3)
    for key in kwargs:
        result = list(map(lambda x, y: x+y, kwargs[key], result))
    return tuple(result)


@keyword('calculate sum tuple (version three)')
def calculate_sum_tuple_version_three(t1, *args, **kwargs):
    """ t1 must be a tuple; (1, 2, 3)
        args = ([t, t, t], {key1: t, key2: t}) OR ([t, t, t], {}) OR ([], {})  where t is (1, 2, 3)
        kwargs must always be an empty dictionary
    """
    logger.debug(f't1: {t1}')
    logger.debug(f'args: {args}')
    logger.debug(f'kwargs: {kwargs}')

    # TODO: Make sure that the length of the passed tuples are equal to len(t1)
    result = list(t1)
    for t in args[0]:  # args[0] is either [t, t, t] OR []  where t is (1, 2, 3)
        result = list(map(lambda x, y: x+y, t, result))
    for key in args[1]:  # args[1] = {'key1': (1, 2, 3), 'key2': (1, 2, 3)}
        result = list(map(lambda x, y: x+y, args[1][key], result))
    for key in kwargs:   # kwargs is always an empty dictionary
        result = list(map(lambda x, y: x+y, kwargs[key], result))
    return tuple(result)


@keyword
def get_list():
    return [2, 2, 2]


@keyword('calculate sum list (version one)')
def calculate_sum_list_version_one(l1, *args, **kwargs):
    """

    Example:
    :param l1: [2, 2, 2]
    :param args: (l, l, l) where l = [2, 2, 2]   OR ()
    :param kwargs: {'key1':l, 'key2':l} where l=[2, 2, 2]  OR  {}
    :return: all the lists passed in are summed into a sum list and returned
    """
    logger.debug(f'l1: {l1}')
    logger.debug(f'args: {args}')
    logger.debug(f'kwargs: {kwargs}')

    result = l1
    for lst in args:
        result = list(map(lambda x, y: x+y, result, lst))
    for key in kwargs:
        result = list(map(lambda x, y: x + y, result, kwargs[key]))
    return result


@keyword('calculate sum list (version two)')
def calculate_sum_list_version_two(l1, *args, **kwargs):
    """
    Example:
    :param l1: [2, 2, 2]
    :param args: ( [l, l, l], ) where l = [2, 2, 2]   OR ( [], )
    :param kwargs: {'key1':l, 'key2':l} where l=[2, 2, 2]  OR  {}
    :return: all the lists passed in are summed into a sum list and returned
    """
    logger.debug(f'l1: {l1}')
    logger.debug(f'args: {args}')
    logger.debug(f'kwargs: {kwargs}')

    result = l1
    for lst in args[0]:  # args[0] is either [l, l, l] OR []
        result = list(map(lambda x, y: x+y, result, lst))
    for key in kwargs:
        result = list(map(lambda x, y: x + y, result, kwargs[key]))
    return result


@keyword('calculate sum list (version three)')
def calculate_sum_list_version_three(l1, *args, **kwargs):
    """
    Example:
    :param l1: [2, 2, 2]
    :param args: ( [l, l, l], d ) where l = [2, 2, 2]  and d={'key1':l, 'key2':l} OR ( [l, l, l], {} )  OR ( [], {} )
    :param kwargs: {}
    :return: all the lists passed in are summed into a sum list and returned
    """
    logger.debug(f'l1: {l1}')
    logger.debug(f'args: {args}')
    logger.debug(f'kwargs: {kwargs}')

    result = l1
    for lst in args[0]:  # args[0] is either [l, l, l] OR []
        result = list(map(lambda x, y: x+y, result, lst))
    for key in args[1]:  # args[1] is either {'key1':l, 'key2':l}  OR {}
        result = list(map(lambda x, y: x+y, result, args[1][key]))
    for key in kwargs:   # kwargs is always an empty dictionary
        result = list(map(lambda x, y: x + y, result, kwargs[key]))
    return result


@keyword
def get_dictionary():
    return {'key': 'value'}


@keyword('create super dictionary (version one)')
def create_super_dictionary_version_one(arg1, *args, **kwargs):
    """
    This method counts the number of the occurrences of d={'key': 'value'} dictionary instance in the parameters
    arg1, args and kwargs.

    :param arg1:  must be {'key':'value'}
    :param args:  must be () OR (d, d) where d = {'key':'value'}
    :param kwargs: must be {} OR {'key1':d, 'key2':d} where d = {'key':'value'}
    :return: a dictionary {'d_count':x} where x is the number of occurrences of d in args1, args and kwargs
    """
    logger.debug(f'd: {arg1})')
    logger.debug(f'args: {args}')
    logger.debug(f'kwargs: {kwargs}')

    d = {'key': 'value'}  # this is the dictionary to look for in arg1, args and kwargs
    x = 0
    if arg1 == d:
        x += 1
    for item in args:
        if item == d:
            x += 1
    for key in kwargs:
        if kwargs[key] == d:
            x += 1
    return {'d_count': x}


@keyword('create super dictionary (version two)')
def create_super_dictionary_version_two(arg1, *args, **kwargs):
    """
    This method counts the number of the occurrences of d={'key': 'value'} dictionary instance in the parameters
    arg1, args and kwargs.

    :param arg1:  must be {'key':'value'}
    :param args:  must be ( [], ) OR ( [d, d], ) where d = {'key':'value'}
    :param kwargs: must be {} OR {'key1':d, 'key2':d} where d = {'key':'value'}
    :return: a dictionary {'d_count':x} where x is the number of occurrences of d in args1, args and kwargs
    """
    logger.debug(f'd: {arg1}')
    logger.debug(f'args: {args}')
    logger.debug(f'kwargs: {kwargs}')

    d = {'key': 'value'}  # this is the dictionary to look for in arg1, args and kwargs
    x = 0
    if arg1 == d:
        x += 1
    for item in args[0]:  # args[0] is [d, d] where d = {'key':'value'}
        if item == d:
            x += 1
    for key in kwargs:
        if kwargs[key] == d:
            x += 1
    return {'d_count': x}


@keyword('create super dictionary (version three)')
def create_super_dictionary_version_three(arg1, *args, **kwargs):
    """
    This method counts the number of the occurrences of d={'key': 'value'} dictionary instance in the parameters
    arg1, args and kwargs.

    :param arg1:  must be {'key':'value'}
    :param args:  must be ( [], {} ) OR ( [d, d], {} ) OR ( [d, d], {'key1': d, 'key2': d} )  where d = {'key':'value'}
    :param kwargs: must be {}
    :return: a dictionary {'d_count':x}, where x is the number of occurrences of d in args1, args and kwargs
    """
    logger.debug(f'd: {arg1}')
    logger.debug(f'args: {args}')
    logger.debug(f'kwargs: {kwargs}')

    d = {'key': 'value'}  # this is the dictionary to look for in arg1, args and kwargs
    x = 0
    if arg1 == d:
        x += 1
    for item in args[0]:  # args[0] is [d, d] where d = {'key':'value'}
        if item == d:
            x += 1
    for key in args[1]:
        if item == args[1][key]:
            x += 1
    for key in kwargs:  # kwargs must always be an empty dictionary
        if kwargs[key] == d:
            x += 1
    return {'d_count': x}


@keyword
def get_set():
    return set([1, 2, 3])


@keyword('count the number of occurrences of {1, 2, 3, 4} (version one)')
def count_occurrences_version_one(s, *args, **kwargs):
    """
    :param s: must be {1, 2, 3, 4}
    :param args: must be either [] OR [s, s, s]
    :param kwargs: must be either {} OR {'key1':s, 'key2':s}
    :return: the number of occurrences of {1, 2, 3, 4} in s, args and kwargs
    """
    logger.debug(f's: {s}')
    logger.debug(f'args: {args}')
    logger.debug(f'kwargs: {kwargs}')

    target = {1, 2, 3, 4}
    count = 0
    if s == target:
        count += 1
    for item in args:
        if item == target:
            count += 1
    for key in kwargs:
        if kwargs[key] == target:
            count += 1
    return count


@keyword('count the number of occurrences of {1, 2, 3, 4} (version two)')
def count_occurrences_version_two(s, *args, **kwargs):
    """
    :param s: must be {1, 2, 3, 4}
    :param args: must be either ([]) OR ([s, s, s])
    :param kwargs: must be either {} OR {'key1':s, 'key2':s}
    :return: the number of occurrences of {1, 2, 3, 4} in s, args and kwargs
    """
    logger.debug(f's: {s}')
    logger.debug(f'args: {args}')
    logger.debug(f'kwargs: {kwargs}')

    target = {1, 2, 3, 4}
    count = 0
    if s == target:
        count += 1
    for item in args[0]:    # args[0] must be either [] OR [s, s, s] where s = {1, 2, 3, 4}
        if item == target:
            count += 1
    for key in kwargs:
        if kwargs[key] == target:
            count += 1
    return count


@keyword('count the number of occurrences of {1, 2, 3, 4} (version three)')
def count_occurrences_version_three(s, *args, **kwargs):
    """
    :param s: must be {1, 2, 3, 4}
    :param args: must be either ([], {}) OR ([s, s, s], {}) OR ([s, s, s], {'key1':s, 'key2':s})
    :param kwargs: must be {}
    :return: the number of occurrences of {1, 2, 3, 4} in s, args and kwargs
    """
    logger.debug(f's: {s}')
    logger.debug(f'args: {args}')
    logger.debug(f'kwargs: {kwargs}')

    target = {1, 2, 3, 4}
    count = 0
    if s == target:
        count += 1
    for item in args[0]:    # args[0] must be either [] OR [s, s, s] where s = {1, 2, 3, 4}
        if item == target:
            count += 1
    for key in args[1]:     # args[1] must be either {} or {'key1':s, 'key2':s}
        if args[1][key] == target:
            count += 1
    for key in kwargs:      # kwargs is always an empty dictionary
        if kwargs[key] == target:
            count += 1
    return count


@keyword('duplicate list items')
def duplicate_list_items(lst):
    """
    :param lst: the items in the list must be an integer. Each item will be multiplied by two
    :return: the modified lst
    """
    logger.debug(f'lst: {lst}')
    for i in range(len(lst)):
        lst[i] *= 2

    return lst


@keyword('modify dictionary')
def modify_dictionary(d):
    logger.debug(f'before modification, d: {d}')
    for key in d:
        d[key] = 'modified'
    logger.debug(f'after modification, d: {d}')


@keyword
def utility_function_one(*args, **kwargs):
    part_1 = 'positional args: ' + str(args)
    part_2 = ' keyworded args: ' + str(kwargs)
    return part_1 + part_2


class Util(object):
    def __init__(self):
        self.variable = 'value'

    def method(self, *args, **kwargs):
        part_1 = 'positional args: ' + str(args)
        part_2 = ' key worded args: ' + str(kwargs)
        return part_1 + part_2

    def __str__(self):
        return 'I am Util object from Python side'


if __name__ == 'Utils':   # if the module is imported by Robot
    utility_object = Util()
    python_list = [1, 2, 3]
    python_dictionary = {'keyA': 'a', 'keyB': 'b', 'keyC': 'c'}

