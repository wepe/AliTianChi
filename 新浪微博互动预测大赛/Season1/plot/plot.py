#coding=utf-8

import pandas as pd
import matplotlib.pylab as plt
import numpy as np

df = pd.read_csv('weibo_train_data.txt',sep='\t')
df.columns = ['uid','mid','time','f','c','l','content']


#总体的forward分布
f,c,l = df.f,df.c,df.l

x_f,y_f = [],[]
d = {}
for i in f:
	if d.has_key(i):
		d[i] += 1
	else:
		d[i] = 1

for key,value in d.items():
	x_f.append(key)
	y_f.append(value)

#总体的comment分布
x_c,y_c = [],[]
d = {}
for i in c:
	if d.has_key(i):
		d[i] += 1
	else:
		d[i] = 1

for key,value in d.items():
	x_c.append(key)
	y_c.append(value)


#总体的like分布
x_l,y_l = [],[]
d = {}
for i in l:
	if d.has_key(i):
		d[i] += 1
	else:
		d[i] = 1

for key,value in d.items():
	x_l.append(key)
	y_l.append(value)

plt.axis([0,1000,0,1000])

plt.plot(x_f,y_f,'k')
#plt.plot(x_f,y_f,'r')
#plt.plot(x_f,y_f,'b')

plt.xticks(np.linspace(0,1000,11,endpoint=True))
plt.yticks(np.linspace(0,1000,11,endpoint=True))
plt.xlabel('forward')
plt.ylabel('count')

plt.show()



#画出某个uid的分布
uid = '0199d79415106bcb23aa22fdfeb595b4'
uid_f = df[df.uid==uid]['f']
x_f,y_f = [],[]
d = {}
for i in uid_f:
	if d.has_key(i):
		d[i] += 1
	else:
		d[i] = 1

for key,value in d.items():
	x_f.append(key)
	y_f.append(value)

plt.bar(x_f,y_f,color='b')
plt.title('uid({}) forward'.format(uid))
plt.show()

