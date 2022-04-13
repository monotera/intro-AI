
import pandas as pd
from openpyxl import load_workbook
import pprint

def get_sheetnames_xlsx(filepath):
    wb = load_workbook(filepath, read_only=True, keep_links=False)
    return wb.sheetnames


def obtain_data(filepath):
    sheetnames = get_sheetnames_xlsx(filepath)
    prob_data = {}
    for sheetname in sheetnames:
        prob_dataFrame = (pd.read_excel(filepath, sheet_name=sheetname))
        prob_data[sheetname] = prob_dataFrame.to_dict()

    for key,value in prob_data.items():
        for k,v in value.items():
            value[k] = list(v.values())
    return prob_data

pprint.pprint(obtain_data("./Datos-IA-3.xlsx"))
