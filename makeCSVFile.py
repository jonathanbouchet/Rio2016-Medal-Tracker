import pandas as pd
import numpy as np
import glob

#make empty dataframe to save data from daily CSV files
col=['date','country','gold','silver','bronze','total']
index = range(0)
df = pd.DataFrame(index=index, columns=col)

# loop over cvs files and append one by one
counter=0
for filename in glob.iglob('JSON/Rio*.csv'):
    print filename
    tempo = pd.read_csv(filename,sep=',',names=col)
    print tempo.shape
    tempo = tempo.drop_duplicates()
    print tempo.shape
    df = df.append(tempo, ignore_index=True)  

#sort dataframe by country and date and re-index it from 0 to number of country * day
df = df.sort_index(by=['country', 'date'], ascending=[True, True])
df = df.set_index([range(0,len(df))])

#save result in a CSV file
df.to_csv('Rio-ALL-US.csv',sep=',')