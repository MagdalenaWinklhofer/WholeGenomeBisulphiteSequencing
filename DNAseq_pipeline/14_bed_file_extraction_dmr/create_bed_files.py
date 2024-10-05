# %%
import pandas as pd 
import numpy as np 
import matplotlib.pyplot as plt
import seaborn as sns
import csv

# %%
positions = pd.read_csv('NA_genome_matrix_CG_G.tsv', sep='\t', nrows=500)

# %%
# drop rows that have nan values 
positions = positions.dropna()
positions = positions.drop(columns=['class', 'strand'])

# %%
# define a function to extract the second value from the list 
def get_second_value(positions):
    temp = positions.strip().split('/')
    if len(temp) > 1:
        return float(temp[1])
    else:
        return np.nan

for col in positions.columns[-8:]:
    positions[col] = positions[col].apply(get_second_value)
    temp = positions[['#chr', 'pos', col]].dropna()
    # duplicate pos column 
    temp['end'] = temp['pos']
    # reorder columns 
    temp = temp[['#chr', 'pos', 'end', col]]
    # export temp without the column names 
    temp.to_csv(f'{col}.bed', sep='\t', index=False, header=False)


# %%



