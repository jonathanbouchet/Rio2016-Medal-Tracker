# -*- coding: utf-8 -*-
import requests
import re
import datetime, sys, os

#initial code from Sumit Dhingra : https://github.com/LinuxSDA?tab=repositories

out = 'Rio-Medals-'+str(datetime.datetime.now().strftime('%Y-%m-%d-%H-%M-%S'))+'.csv'
fileOut = open(out,"w")
sys.stdout = fileOut

curTime = datetime.datetime.now().strftime('%Y-%m-%d')

headers = {
            "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) " +
                          "AppleWebKit/537.36 (KHTML, like Gecko)" +
                          " Chrome/52.0.2743.116 Safari/537.36",
}

Info = requests.get("https://www.google.co.in/search?async=hl:en," +
                    "ofr:%5B%22%2Fm%2F03tnk7%22%2C1%2C%22m%22%2C1%2Cnull%2Cnull%2Cnull%2Cnull" +
                    "%2Cnull%2Cnull%2Cnull%2Cnull%2Cnull%2Cnull%2Cnull%2Cnull%2Cnull%2Cnull%2Cnull" +
                    "%2C0%5D,stream:%2Fm%2F03tnk7,_fmt:jspb&ved=0ahUKEwiG_IrmpqjOAhWHQY8KHYp6AhgQprYBCCwoCDAA" +
                    "&yv=2&q=%2Fm%2F03tnk7&asearch=lr_oly", headers=headers)

special = u"\u0026"
Country_Medal_Regex = re.compile(r'"[\w\s\-\\,\'Ã´]+",\[[0-9]+,[0-9]+,[0-9]+,[0-9]+]')
Result = Country_Medal_Regex.findall(Info.content)

#take care of few spacial cases : \u0026 utf not recognized ; comma between country name that will split the name
for counter in range(0,len(Result)):
  if '\u0026' in Result[counter]:
    Result[counter] = Result[counter].replace('\u0026','and')
  if 'Hong Kong, China' in Result[counter]:
    Result[counter] = Result[counter].replace('Hong Kong, China','Hong Kong China')
  curStr = str(Result[counter])
  str0 = curStr.split(',[')[0]
  str1 = curStr.split(',[')[1]
  x = re.findall(r"[-+]?\d*\.\d+|\d+",str1)
  print curTime,',', str0,',' ,int(x[0]),',' ,int(x[1]),',' ,int(x[2]),',',int(x[3])

fileOut.close()
