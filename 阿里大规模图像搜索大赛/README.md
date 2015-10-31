##阿里大规模图像搜索大赛


###赛题简介
阿里巴巴集团经过多年实践，积累了海量及多样的图像数据；在移动互联网的时代，如何通过图片（尤其是实拍图片）搜索并访问到背后的服务，是非常有挑战和意义的事情。 本次“阿里大规模图像搜索大赛”的目标就是提供一个平台和环境，使参赛选手基于此，找到准确且快速的图片搜索方法，公开客观的衡量方法的效果，并推动这些方法在智能购物、知识获取、推荐关联等各个领域的线上应用。
赛题：给定query集，从海量图像中检索最相同或相似的Top20图像。

- [官方链接](http://tianchi.aliyun.com/competition/introduction.htm?spm=5176.100066.333.14.UWexgq&raceId=231510)

###比赛总结

当初师兄看到这个比赛，心血来潮，说要参赛，用CNN玩一玩，然后我就报名了。我没做过图像搜索相关的项目，所以一直等着师兄来教我...等着等着，初赛都快截止了，师兄跑去澳洲开会了（额...师兄坑我

既然报了名，就搞一搞吧。

搜了几篇博客看了看，大概了解了一下图像搜索的流程：

- 首先，需要找到一种方法对图像进行描述，这样的方法其实有很多了，传统的像[感知哈希算法](http://www.ruanyifeng.com/blog/2011/07/principle_of_similar_image_search.html)、[颜色分布法、内容特征法](http://www.ruanyifeng.com/blog/2013/03/similar_image_search_part_ii.html),这几种算法比较简单，我没有去尝试，因为我看了这个比赛的数据，场景相对比较复杂，感觉这些方法不会很work，加上我没有什么时间去探索（也不想花太多时间去探索）。我转而使用OpenCV里面的特征描述和匹配算法，主要是SIFT，有兴趣的读者可以看看这里：[Feature Detection and Description](http://opencv-python-tutroals.readthedocs.org/en/latest/py_tutorials/py_feature2d/py_table_of_contents_feature2d/py_table_of_contents_feature2d.html)。得到了图像的SIFT特征之后，自然就可以衡量两幅图像之间的相似度了。

- 接下来，需要对检索全集提取SIFT特征，然后“离线”保存下来。那么新来一张query图，我只需要计算这张新图的特征，与检索数据库里面的所有图片一一比较，找出最相似的Top20张图片。这种方法可行，但是很明显，计算量太大了，实际业务中肯定也不是这么干的。用过Google搜图的同学就清楚，它的响应时间非常短，这背后想必有一套建立快速索引的方法，将相似的特征映射到相邻的存储空间，像局部敏感哈希算法此类的。（羞愧，我为了偷懒，直接跟检索全集一一去比较了，最后也只提交了200多张的检索结果，得分没垫底...

- 看一下SIFT特征的匹配效果，以及比较好的检索结果：

![](https://github.com/wepe/AliTianChi/blob/master/%E9%98%BF%E9%87%8C%E5%A4%A7%E8%A7%84%E6%A8%A1%E5%9B%BE%E5%83%8F%E6%90%9C%E7%B4%A2%E5%A4%A7%E8%B5%9B/siftmatch.png)


![](https://github.com/wepe/AliTianChi/blob/master/%E9%98%BF%E9%87%8C%E5%A4%A7%E8%A7%84%E6%A8%A1%E5%9B%BE%E5%83%8F%E6%90%9C%E7%B4%A2%E5%A4%A7%E8%B5%9B/search_result.png)