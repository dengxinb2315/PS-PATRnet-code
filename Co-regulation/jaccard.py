import pandas as pd
import numpy as np
import os
import matplotlib.pyplot as plt
import seaborn as sns

path = r'/home/huangjiadai/huangjiadai1/HJD/PAO1-chip-HH/co-binding/bed/'
filenames = os.listdir(path)
filenames.sort()
##print(filenames)

##check one bed data
df = pd.read_csv('/home/huangjiadai/huangjiadai1/HJD/PAO1-chip-HH/co-binding/bed/PA0034.bed',sep='\t',header=None,index_col=0)
print(df.to_string())

##df.to_csv('check.csv')

def x(a,b):
    return a - b

##output the sum of variance of all beds
union = [pd.read_csv(path+i,sep='\t',header=None,index_col=0).apply(lambda f: x(f[2],f[1]), axis=1).sum(axis=0) for i in filenames]
print (union)

path = r'/home/huangjiadai/huangjiadai1/HJD/PAO1-chip-HH/co-binding/jaccard/'
filenames = os.listdir(path)
filenames.sort()

##create intersect files
intersect = [[path+i+'/'+j for j in os.listdir(path+i)] for i in filenames]
for i in range(174):
    intersect[i].sort()
##print(intersect)

jc=pd.read_csv('/home/huangjiadai/huangjiadai1/HJD/PAO1-chip-HH/co-binding/jaccard/PA0034/PA0034_PA0034_interect.bed',header=None).sum(axis=0)[0]
print(jc)

jaccard = np.zeros((174,174))

for i in range(174):
    for j in range(174):
        size = os.path.getsize(intersect[i][j])
        if size == 0:
            print('文件是空的')
            jaccard[i,j] = 0
        else:
            print(i)
            print(j)
            jaccard[i,j] = pd.read_csv(intersect[i][j],header=None).sum(axis=0)[0]
            print(jaccard)
pd.DataFrame(jaccard).to_csv('intersect.csv')

Union = np.zeros((174,174))
for i in range(174):
    for j in range(174):
        if i==j:
            Union[i,j]=union[i]
        else:
            Union[i,j]=union[i]+union[j]-jaccard[i][j]
            if Union[i,j]<0 or Union[i,j]<jaccard[i][j]:
                print("problem index: "+str(i)+" "+str(j))
                print("problem tf "+str(filenames[i])+" "+str(filenames[j]))
                print("problem value "+str(Union[i][j]))
                print("original value union1: "+str(union[i])+" union2: "+str(union[j])+" intersect: "+str(jaccard[i,j]))


Jaccard =  jaccard/Union

print(Jaccard)

pd.DataFrame(Jaccard).to_csv('Jaccard.csv')

