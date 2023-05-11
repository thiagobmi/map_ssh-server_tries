import numpy as np
import plotly_express as px
import pandas as pd

data=[]
count =[]
country = []

file = open("output.txt", "r")
bigstring = file.read()

bigstring = bigstring.replace(",", "")
listas = bigstring.split("\n")

for i in listas:
    temp = i.split(";")
    if temp != ['']:
        count.append([int(temp[0])])
        country.append([temp[2]])

uniqueCT = np.unique(country)

counter = np.zeros(len(uniqueCT))
countCT = []

for i in range(0,len(uniqueCT)):
    for j in range(0,len(country)):
        if country[j][0] == uniqueCT[i]:
            counter[i] += int(count[j][0])

for i in range(0,len(counter)):
    if uniqueCT[i]=='United':
        uniqueCT[i]='USA'
    if uniqueCT[i] != "can't" and uniqueCT[i] != "Address" and uniqueCT[i] != "Resolve":
        data.append([uniqueCT[i],int(counter[i])])


df= pd.DataFrame(data, columns=['Country','Tries'])

fig = px.choropleth(df,
                   locations="Country",
                   locationmode='country names',
                   color="Tries",
                   scope="world",
                   title='SSH tries per country')

fig.write_image('image.png')
