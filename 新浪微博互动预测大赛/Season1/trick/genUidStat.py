__author__ = "wepon, http://2hwp.com"
__date__ = "2015/08/14"


import csv,cPickle
import pandas as pd

def loadData():
    traindata = pd.read_csv("weibo_train_data.txt",header=None,sep='\t')
    traindata.columns = ["uid","mid","date","forward","comment","like","content"]

    testdata = pd.read_csv("weibo_predict_data.txt",header=None,sep='\t')
    testdata.columns=["uid","mid","date","content"]

    return traindata,testdata

#for every uid , generate statistics of forward,comment,like
def genUidStat():
    traindata, _ = loadData()
    train_stat = traindata[['uid','forward','comment','like']].groupby('uid').agg(['min','max','median','mean'])
    train_stat.columns = ['forward_min','forward_max','forward_median','forward_mean',\
                          'comment_min','comment_max','comment_median','comment_mean',\
                          'like_min','like_max','like_median','like_mean']
    train_stat = train_stat.apply(pd.Series.round)
    #store into dictionary,for linear time search
    stat_dic = {}
    for uid,stats in train_stat.iterrows():
        stat_dic[uid] = stats   #type(stats) : pd.Series
    return stat_dic
    
    






