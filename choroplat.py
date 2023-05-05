import plotly_express as px
import pandas as pd

data = []

file = open("output.txt", "r")
bigstring = file.read()

bigstring = bigstring.replace(",", "")
listas = bigstring.split("\n")


for i in listas:
    temp = i.strip().split(" ")
    if len(temp) > 1:
        if temp[1]=='United':
            temp[1]='USA'
        if temp[1] != "can't":
            data.append([temp[1],int(temp[0])])

print(data)


df= pd.DataFrame(data, columns=['Country','Tries'])
print(df)


fig = px.choropleth(df,
                   locations="Country",
                   locationmode='country names',
                   color="Tries",
                   scope="world",
                   title='SSH tries per country')

fig.write_image('image.png')
