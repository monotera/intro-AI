
import pandas as pd
from openpyxl import load_workbook
import pprint

def get_sheetnames_xlsx(filepath):
    wb = load_workbook(filepath, read_only=True, keep_links=False)
    return wb.sheetnames


def obtain_data(filepath):
    #Obtains sheet names from excel
    sheetnames = get_sheetnames_xlsx(filepath)
    prob_data = {}
    """
    - Obtains the data from each sheet in excel. 
    - it comes as a dataFrame and then its transform into a dictionary
    example of data:
    prob_data = 
    {   'Appointment': {'Train': ['on time', 'delayed'],
                        'attend': [0.9, 0.6],
                        'miss': [0.1, 0.4]},
        'Maintenance': {'Rain': ['none', 'light', 'heavy'],
                        'no': [0.6, 0.8, 0.9],
                        'yes': [0.4, 0.2, 0.1]},
        'Rain':        {'heavy': [0.1], 'light': [0.2], 'none': [0.7]},
        'Train':       {'Maintenance': ['yes', 'no', 'yes', 'no', 'yes', 'no'],
                        'Rain': ['none', 'none', 'light', 'light', 'heavy', 'heavy'],
                        'delayed': [0.2, 0.1, 0.4, 0.3, 0.6, 0.5],
                        'on time': [0.8, 0.9, 0.6, 0.7, 0.4, 0.5]}
    }
    """
    for sheetname in sheetnames:
        prob_dataFrame = (pd.read_excel(filepath, sheet_name=sheetname))
        prob_data[sheetname] = prob_dataFrame.to_dict()

    for key,value in prob_data.items():
        for k,v in value.items():
            value[k] = list(v.values())
    return prob_data

pprint.pprint(obtain_data("./Datos-IA-3.xlsx"))
