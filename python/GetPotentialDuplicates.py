### Load a .csv file, create a fingerprint from a selection of columns, compare the fingerprints for duplicates, and write out potential duplicates to a new .csv 
###
#######

import pandas
import fingerprint as fp # from https://gist.github.com/pietz/d6197f64c34d273a6d456d7b736c028d

df = pandas.read_csv('C:\\Users\\pryors\\OneDrive - University of Missouri\\Documents\\FOLIO\\UMLD-DEDUPE_202504071237.csv', dtype='str', encoding='utf-8')

df=df.astype(str) # fingerprint function gets grumpy about float values in enumeration column. Cast all as strings.

fingerprint_list = [] # iterate through each row of the dataframe and generate a fingerprint based on combination of columns that would indicate a potential dupe
for index, row in df.iterrows():
    fingerprint_list.append(fp.fingerprint(row['title']+row['chronology']+row['enumeration']+row['volume']+row['contributor_name']+row['format']))
    # build a list of fingerprints

df['fingerprint'] = fingerprint_list # add the list of fingerprints to the dataframe as a new column

dupes = df.duplicated(subset='fingerprint', keep=False) # check if a row (on the fingerprint column) is a duplicate of another fingerprint...subset marks ALL matching rows

df['dupes'] = dupes # write the True/False series as a dataframe column just for reference

df[dupes].to_csv('./UMLD_potential_duplicates.csv') # output just the ones where dupes=true to .csv
