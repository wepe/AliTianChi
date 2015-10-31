__author__ = "wepon,http://2hwp.com"
__date__ = "2015/08/14"

"""
It score 40.94% on training set when we predict  with uid's (forward_median,comment_medain,like_median).
This is good,and we can go further based on this:
	
	for each uid, we first get its (f_min,f_median,f_max),(c_min,c_median,c_max),(l_min,l_medain,l_max),and then:
		1. fix c_median and l_medain, search a  forward value between <f_min,f_max>  , which cause a higher score than (f_medain,c_medain,l_medain)
		   if there exist several result that get the same highest score, we choose the one near f_medain.
		   if not exist any result that get higher score than (f_medain,c_medain,l_medain), than we choose forward = f_medain
		2. search a  comment value, by the same method 
		3. search a  like value, by the same method

"""

import cPickle
import pandas as pd
import numpy as np
from genUidStat import loadData,genUidStat
from evaluation import precision
from runTime import runTime
from multiprocessing import Pool

def score(uid_data,pred):
	"""
	uid_data:
		pd.DataFrame
	pred:
		list, [fp,cp,lp]
	"""
	uid_real_pred = uid_data[['forward','comment','like']]
	uid_real_pred['fp'] = pred[0]
	uid_real_pred['cp'] = pred[1]
	uid_real_pred['lp'] = pred[2]
	return precision(uid_real_pred.values)
	



#search and return the best target value for uid
def search(uid_data,target,args):
	"""
	target:
		'forward','comment','like'
	
	args:
		(f_min,f_median,f_max,c_min,c_median,c_max,l_min,l_medain,l_max)
	"""
	args = list(args)
	target_index = ['forward','comment','like'].index(target)
	target_min,target_median,target_max = args[3*target_index:3*target_index+3]
	del args[3*target_index:3*target_index+3]
	pred = (args[1],args[4])
	
	best_num = [target_median]
	best_pred = list(pred)
	best_pred.insert(target_index,target_median)
	best_score = score(uid_data,best_pred)
	for num in range(target_min,target_max+1):
		this_pred = list(pred)
		this_pred.insert(target_index,num)
		this_score = score(uid_data,this_pred)
		if this_score >= best_score:                  
			if this_score > best_score:
				best_num = [num]
				best_score = this_score
			else:
				best_num.append(num)                       
			
	return best_num[np.array([abs(i - target_median) for i in best_num]).argmin()]

##search best target value for all uid,return a dictionary that store {uid:[f,c,l]}
def search_all_uid():
	"""
	traindata,testdata = loadData()
	stat_dic = genUidStat()
	
	#for each uid,search its best fp,cp,lp
	uid_best_pred = {}
	for uid in stat_dic:
		print "search uid: {}".format(uid)
		uid_data = traindata[traindata.uid == uid]
		args = stat_dic[uid][['forward_min','forward_median','forward_max','comment_min',\
					'comment_median','comment_max','like_min','like_median','like_max']]
		args = tuple([int(i) for i in args]) 
		fp = search(uid_data,'forward',args)	
		cp = search(uid_data,'comment',args)	
		lp = search(uid_data,'like',args)	
		uid_best_pred[uid] = [fp,cp,lp]
	"""
	#multiprocessing version for geting uid_best_pred
	traindata,testdata = loadData()
	stat_dic = genUidStat()
	uid_best_pred = {}
	pool = Pool()
	uids,f,c,l = [],[],[],[]
	for uid in stat_dic:
		print "search uid:{}".format(uid)
		uid_data = traindata[traindata.uid == uid]
		arguments = stat_dic[uid][['forward_min','forward_median','forward_max','comment_min',\
					'comment_median','comment_max','like_min','like_median','like_max']]
		arguments = tuple([int(i) for i in arguments]) 
		f.append(pool.apply_async(search,args=(uid_data,'forward',arguments)))
		c.append(pool.apply_async(search,args=(uid_data,'comment',arguments)))
		l.append(pool.apply_async(search,args=(uid_data,'like',arguments)))
		uids.append(uid)
	pool.close()
	pool.join()
	f = [i.get() for i in f]
	c = [i.get() for i in c]
	l = [i.get() for i in l]
	
	for i in range(len(uids)):
		uid_best_pred[uids[i]] = [f[i],c[i],l[i]]
	
	try:
		cPickle.dump(uid_best_pred,open('uid_best_pred.pkl','w'))
	except Exception:
		pass
		
	return uid_best_pred

	
@runTime
def predict_by_search(submission=True):
	traindata,testdata = loadData()
	uid_best_pred = search_all_uid()
	print "search done,now predict on traindata and testdata..."

	#predict traindata with uid's best fp,cp,lp
	forward,comment,like = [],[],[]
	for uid in traindata['uid']:
		if uid_best_pred.has_key(uid):
			forward.append(int(uid_best_pred[uid][0]))
			comment.append(int(uid_best_pred[uid][1]))
			like.append(int(uid_best_pred[uid][2]))
		else:
			forward.append(0)
			comment.append(0)
			like.append(0)
	
	#score on the traindata
	train_real_pred = traindata[['forward','comment','like']]
	train_real_pred['fp'],train_real_pred['cp'],train_real_pred['lp'] = forward,comment,like
	print "Score on the training set:{0:.2f}%".format(precision(train_real_pred.values)*100)	
	
	
	if submission:
		test_pred = testdata[['uid','mid']]
		forward,comment,like = [],[],[]
		for uid in testdata['uid']:
			if uid_best_pred.has_key(uid):
				forward.append(int(uid_best_pred[uid][0]))
				comment.append(int(uid_best_pred[uid][1]))
				like.append(int(uid_best_pred[uid][2]))
			else:
				forward.append(0)
				comment.append(0)
				like.append(0)
		test_pred['fp'],test_pred['cp'],test_pred['lp'] = forward,comment,like
		
		#generate submission file
		result = []
		filename = "weibo_predict_search.txt"
		for _,row in test_pred.iterrows():
			result.append("{0}\t{1}\t{2},{3},{4}\n".format(row[0],row[1],row[2],row[3],row[4]))
		f = open(filename,'w')
		f.writelines(result)
		f.close()
		print 'generate submission file "{}"'.format(filename)
		
if __name__ == "__main__":
		predict_by_search()	
			
