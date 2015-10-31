__author__ = "wepon, http://2hwp.com"
__date__ = "2015/08/14"

"""
about 80% of the training data are: 0 0 0 (forward_count,comment_count,like_count),
inspired by this, we try some fixed value for all uid,and calculate their score on training data:
	
	predict score(%)
	0 0 0  34.10%
	1 0 0  29.23%
	0 1 0  35.01%
	0 0 1  32.20%
	1 1 0  29.30%
	1 0 1  29.39%
	0 1 1  33.45%
	1 1 1  13.46%
	2 0 0  7.04%
	0 2 0  29.93%
	0 0 2  28.22%
	0 1 2  12.85%
	....          



another wise solution is to predict respectively with uid's statistics(E.g mean,median)	,
their score on the training data:

	mean   38.01%
	min    34.17%
	max    8.08%
	median 40.94%      **best**

"""

import pandas as pd
from genUidStat import loadData,genUidStat
from evaluation import precision
from runTime import runTime




@runTime
def predict_with_fixed_value(forward,comment,like,submission=True):
	# type check
	if isinstance(forward,int) and isinstance(forward,int) and isinstance(forward,int):
		pass
	else:
		raise TypeError("forward,comment,like should be type 'int' ")
	
	traindata,testdata = loadData()
	
	#score on the training set
	train_real_pred = traindata[['forward','comment','like']]
	train_real_pred['fp'],train_real_pred['cp'],train_real_pred['lp'] = forward,comment,like
	print "Score on the training set:{0:.2f}%".format(precision(train_real_pred.values)*100)
	
	#predict on the test data with fixed value, generate submission file
	if submission:
		test_pred = testdata[['uid','mid']]
		test_pred['fp'],test_pred['cp'],test_pred['lp'] = forward,comment,like
		
		result = []
		filename = "weibo_predict_{}_{}_{}.txt".format(forward,comment,like)
		for _,row in test_pred.iterrows():
			result.append("{0}\t{1}\t{2},{3},{4}\n".format(row[0],row[1],row[2],row[3],row[4]))
		f = open(filename,'w')
		f.writelines(result)
		f.close()
		print 'generate submission file "{}"'.format(filename)


@runTime	
def predict_with_stat(stat="median",submission=True):
	"""
	stat:
		string
		min,max,mean,median
	"""
	stat_dic = genUidStat()
	traindata,testdata = loadData()
	
	#get stat for each uid
	forward,comment,like = [],[],[]
	for uid in traindata['uid']:
		if stat_dic.has_key(uid):
			forward.append(int(stat_dic[uid]["forward_"+stat]))
			comment.append(int(stat_dic[uid]["comment_"+stat]))
			like.append(int(stat_dic[uid]["like_"+stat]))
		else:
			forward.append(0)
			comment.append(0)
			like.append(0)
	#score on the training set
	train_real_pred = traindata[['forward','comment','like']]
	train_real_pred['fp'],train_real_pred['cp'],train_real_pred['lp'] = forward,comment,like
	print "Score on the training set:{0:.2f}%".format(precision(train_real_pred.values)*100)
	
	#predict on the test data with fixed value, generate submission file
	if submission:
		test_pred = testdata[['uid','mid']]
		forward,comment,like = [],[],[]
		for uid in testdata['uid']:
			if stat_dic.has_key(uid):
				forward.append(int(stat_dic[uid]["forward_"+stat]))
				comment.append(int(stat_dic[uid]["comment_"+stat]))
				like.append(int(stat_dic[uid]["like_"+stat]))
			else:
				forward.append(0)
				comment.append(0)
				like.append(0)
				
				
		test_pred['fp'],test_pred['cp'],test_pred['lp'] = forward,comment,like
		
		result = []
		filename = "weibo_predict_{}.txt".format(stat)
		for _,row in test_pred.iterrows():
			result.append("{0}\t{1}\t{2},{3},{4}\n".format(row[0],row[1],row[2],row[3],row[4]))
		f = open(filename,'w')
		f.writelines(result)
		f.close()
		print 'generate submission file "{}"'.format(filename)
	



if __name__ == "__main__":
	 #predict_with_fixed_value(0,1,1,submission=False)
	 predict_with_stat(stat="median",submission=True)
	 