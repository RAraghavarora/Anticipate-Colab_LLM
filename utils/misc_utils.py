import os
def extract_op_string(op_string):
    try:
        op_dict = eval(op_string)
    except SyntaxError:
        start_index = op_string.find("{")
        end_index = op_string.rfind("}") + 1
        dict_string = op_string[start_index:end_index]
        op_dict = eval(dict_string)
    return op_dict


def count_folders(directory):
    return len(
        [
            name
            for name in os.listdir(directory)
            if os.path.isdir(os.path.join(directory, name))
        ]
    )


def remove_parentheses(text):
    return re.sub(r"\s*\([^)]*\)", "", text).strip()

