2015阿里巴巴天池大数据竞赛-阿里移动推荐
===

**竞赛介绍：**[链接](http://tianchi.aliyun.com/competition/introduction.htm?spm=5176.100066.333.2.umhl4N&raceId=1)

本repo目录说明
---
- **data**  *存放数据*
- **preprocess**    *数据预处理*
- **rule**   *根据规则生成提交文件*
- **model**   *训练机器学习模型（暂时不分享）*
	




代码使用说明
---

- fork本repo，非Github用户请点右下角的`Downlown ZIP`

- 解压后，将`tianchi_mobile_recommend_train_user.csv`以及`tianchi_mobile_recommend_train_item.csv`放入`/data/`目录下

- 仅需两个步骤即可获得一份提交文件，F1可达到7.6%

	- 第一步，进入`/preprocess/`目录，运行`data_preprocess.py`
	- 第二步，进入`/rule/`目录，运行`gen_submission_by_rule.py`


- 完成上面两个步骤后，在`/rule/`目录下会生成一份`tianchi_mobile_recommendation_predict.csv`文件，提交它。

补充说明
---

- **纯Python**，无任何依赖项。

- 关于代码实现的功能，在每份代码文件中均有注释，代码可能写得比较乱，也可能有bug，欢迎issues。
	
- 如果你想获得更高的F1值，修改`gen_submission_by_rule.py`这份文件，加入一些规则，F1可以达到9%以上。
	
- **建议在Linux下运行**；在我的PC上（8核），上面两个步骤总共花了不到20分钟。
	
- 请在规则的基础上，做特征工程，训练模型，这才是参赛目的。
	
- 进入第二赛季后，请删了这些代码，不适合处理大数据。

