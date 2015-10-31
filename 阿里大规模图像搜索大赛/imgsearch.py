import numpy as np
import cv2
import os
from multiprocessing import Pool
import cPickle



def img_descriptors(imgname):
	img = cv2.imread(imgname,0)
	orb = cv2.ORB(nfeatures=200)
	kp, des = orb.detectAndCompute(img,None)
	return des #numpy.ndarray

	

def bf_orb_distance(des1,des2):
	# create BFMatcher object
	bf = cv2.BFMatcher(cv2.NORM_HAMMING, crossCheck=True)
	
	# Match descriptors.
	matches = bf.match(des1,des2)
	
	# Sort them in the order of their distance.
	matches = sorted(matches, key = lambda x:x.distance)
	
	cnt = 0.0
	total_distance = 0.0
	for i in matches[0:50]:
		if type(i.distance).__name__ == 'float':
			total_distance += i.distance
			cnt += 1.0
	
	return total_distance/cnt


def gen_submission(result):
	lines = []
	for img in result:
		lines.append(str(img)+','+';'.join(result[img][0:100])+';\n')
	f = open('submission.txt','w')
	f.writelines(lines)
	f.close()

"""
	
def gen_descriptors(img_dir):
	imgs = os.listdir(img_dir)
	pool = Pool()
	img_des = {}
	for img in imgs:
		img_des[img] = pool.apply_async(img_descriptors,args=(img_dir+img,))
	pool.close()
	pool.join()
	
	for img in img_des:
		img_des[img] = img_des[img].get()
	
	cPickle.dump(img_des,open('img_des.pkl','w'))
		

def search(img_des,query_dir,query_img):
	min20_distance = [float('inf') for i in range(50)]
	min20_img = ["tmp" for i in range(50)]
	query_img_des = img_descriptors(query_dir+query_img)
	for img in img_des:
		this_distance = bf_orb_distance(query_img_des,img_des[img])
		max_min20 = max(min20_distance)
		if this_distance < max_min20:
			ind = min20_distance.index(max_min20)
			del min20_distance[ind]
			del min20_img[ind]
			min20_distance.append(this_distance)
			min20_img.append(img)
		
	tmp = zip(min20_distance,min20_img)
	tmp.sort(key=lambda x:x[0])
	return [i[1].split('.')[0] for i in tmp]



def mp_imgsearch():
	img_des = cPickle.load(open('img_des.pkl','r'))
	query_dir = './query/'
	query_imgs = os.listdir(query_dir)
	result = {}

	pool = Pool()
	for query_img in query_imgs:
		result[query_img.split('.')[0]] = pool.apply_async(search,args=(img_des,query_dir,query_img))

	pool.close()
	pool.join()

	for img in result:
		print "{0}: {1}".format(img,result[img])

	cPickle.dump(result,open('result.pkl','w'))

	gen_submission(result)



def imgsearch():
	img_des = cPickle.load(open('img_des.pkl','r'))
	query_dir = './query/'
	query_imgs = os.listdir(query_dir)
	result = {}

	for query_img in query_imgs:
		min20_distance = [float('inf') for i in range(50)]
		min20_img = ["tmp" for i in range(50)]
		query_img_des = img_descriptors(query_dir+query_img)
		for img in img_des:
			this_distance = bf_orb_distance(query_img_des,img_des[img])
			max_min20 = max(min20_distance)
			if this_distance < max_min20:
				ind = min20_distance.index(max_min20)
				del min20_distance[ind]
				del min20_img[ind]
				min20_distance.append(this_distance)
				min20_img.append(img)
		
		tmp = zip(min20_distance,min20_img)
		tmp.sort(key=lambda x:x[0])

		result[query_img.split('.')[0]] = [i[1].split('.')[0] for i in tmp]

	for img in result:
		print "{0}: {1}".format(img,result[img])

	cPickle.dump(result,open('result.pkl','w'))

	gen_submission(result)

"""



"""
It is impossible to generate descriptor for all images and load into memory at a time.
I have to calculate their distance  one by one, which is very very slow.
"""

def slow_search_single(query_img):
	print "query image:",query_img
	query_img_des = img_descriptors('./query/'+query_img)
	min20_distance = [float('inf') for i in range(100)]
	min20_img = ["tmp" for i in range(100)]
	eval_images = os.listdir('./eval_image')
	cnt = 0
	for eval_image in eval_images:
		if query_img[0:3] != eval_image[0:3]:
			continue
		cnt += 1
		if cnt > 10000:break
		try:
			eval_image_des = img_descriptors('./eval_image/'+eval_image)
			this_distance = bf_orb_distance(query_img_des,eval_image_des)
			max_min20 = max(min20_distance)
			if this_distance < max_min20:
				ind = min20_distance.index(max_min20)
				del min20_distance[ind]
				del min20_img[ind]
				min20_distance.append(this_distance)
				min20_img.append(eval_image)
		except:
			pass
				
	tmp = zip(min20_distance,min20_img)
	tmp.sort(key=lambda x:x[0])
	print query_img,"done",tmp

	f = open('./predict/'+query_img.split('.')[0]+'.txt','w')
	f.writelines(query_img.split('.')[0]+','+';'.join([i[1].split('.')[0] for i in tmp])+';\n')
	f.close()

	return [i[1].split('.')[0] for i in tmp]
	

def slow_search():
	query_imgs = os.listdir('./query')
	result = {}
	
	pool = Pool()
	for query_img in query_imgs:
		result[query_img.split('.')[0]] = pool.apply_async(slow_search_single,args=(query_img,))

	pool.close()
	pool.join()

	for img in result:
		result[img] = result[img].get()

	cPickle.dump(result,open('result_rest1359.pkl','w'))

	gen_submission(result)
		
	
if __name__ == "__main__":
	#target_dir = './eval_image/'
	#gen_descriptors(target_dir)
	#imgsearch()
	slow_search()

	
			
