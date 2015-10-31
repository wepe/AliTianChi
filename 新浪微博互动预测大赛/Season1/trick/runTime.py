__author__ = "wepon, http://2hwp.com"
__data__ = "2015/08/14"

"""
just for run time calculate

"""

def runTime(func):
	def wrapper(*args,**kwargs):
		import time
		t1 = time.time()
		func(*args,**kwargs)
		t2 = time.time()
		print "{0} run time: {1:.2f}s".format(func.__name__,t2-t1)
	return wrapper
