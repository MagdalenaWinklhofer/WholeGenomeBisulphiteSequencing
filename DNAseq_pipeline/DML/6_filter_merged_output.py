# %%
# import all needed packages
import pandas as pd


df_n = pd.read_csv("/cluster/work/users/magdalena/11_DML/res_merged/allc_normoxia.tsv", header=None,
                 sep='\t', usecols=[1,4,5], names=['position', 'methylation_coverage', 'read_coverage'])

df_a = pd.read_csv("/cluster/work/users/magdalena/11_DML/res_merged/allc_anoxia.tsv", header=None,
                 sep='\t', usecols=[1,4,5], names=['position', 'methylation_coverage', 'read_coverage'])

df_r = pd.read_csv("/cluster/work/users/magdalena/11_DML/res_merged/allc_reoxygenation.tsv", header=None,
                 sep='\t', usecols=[1,4,5], names=['position', 'methylation_coverage', 'read_coverage'])


# filter df_n for read coverage (equal and above 10) and methylation coverage (not 0)
df_n = df_n[(df_n['read_coverage'] >= 10) & (df_n['methylation_coverage'] != 0)]
df_a = df_a[(df_a['read_coverage'] >= 10) & (df_a['methylation_coverage'] != 0)]
df_r = df_r[(df_r['read_coverage'] >= 10) & (df_r['methylation_coverage'] != 0)]
# export filtered df_n to tsv file
df_n.to_csv("/cluster/work/users/magdalena/11_DML/res_merged/allc_normoxia_filtered.tsv", sep='\t', index=False, header=False)
df_a.to_csv("/cluster/work/users/magdalena/11_DML/res_merged/allc_anoxia_filtered.tsv", sep='\t', index=False, header=False)
df_r.to_csv("/cluster/work/users/magdalena/11_DML/res_merged/allc_reoxygenation_filtered.tsv", sep='\t', index=False, header=False)