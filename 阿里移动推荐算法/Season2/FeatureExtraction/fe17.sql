--**********************************************
--**********************************************
--针对17号加购物车或者收藏且当天没买的那些ui对，提取特征
--**********************************************
--**********************************************


-------------------------------------------------
--将12-17号的数据提取出来，保留user_id,item_id,behavior_type, hour
-------------------------------------------------
drop table if exists date12_17;
create table date12_17 
as select user_id,item_id,behavior_type,user_geohash,item_category,substr(time,12,2) as hour 
from tianchi_lbs.tianchi_mobile_recommend_train_user
where substr(time,1,10)="2014-12-17";

--统计一下条目  182582359
select count(*) from date12_17;

-------------------------------------------------
--提取特征：uid对iid三种行为（除了购买）的总数
-------------------------------------------------
drop table if exists 17_featurefile1;
create table 17_featurefile1
as select a.user_id,a.item_id,b.behavior_type,count(*) as num
from 17jgwc_sc_nobuy a join date12_17 b
on  a.user_id=b.user_id and a.item_id=b.item_id
group by a.user_id,a.item_id,b.behavior_type;

--三种行为分别占一列
drop table t;
create table if not exists  t(user_id string,item_id string,ui_b1 double,ui_b2 double,ui_b3 double);
insert into table t
select user_id,item_id,
case behavior_type when 1 then num else 0.0 end,
case behavior_type when 2 then num else 0.0 end,
case behavior_type when 3 then num else 0.0 end
from 17_featurefile1;

--将相同的ui的三种行为合并
drop table if exists  17_ui_behavior_sum;
create table if not exists 17_ui_behavior_sum
as select user_id,item_id,sum(ui_b1) as ui_b1,sum(ui_b2) as ui_b2,sum(ui_b3) as ui_b3
from t group by user_id,item_id;

------------------------------------------
--提取特征：uid对iid在各个小时里的点击次数
-------------------------------------------
drop table if exists 17_featurefile2;
create table 17_featurefile2
as select a.user_id,a.item_id,b.hour,count(*) as num
from 17jgwc_sc_nobuy a left outer join date12_17 b
on  a.user_id=b.user_id and a.item_id=b.item_id and b.behavior_type=1
group by a.user_id,a.item_id,b.hour;

--24种hour的点击次数分别占一列
drop table if exists t;
create table if not exists  t(user_id string,item_id string,
ui_b1h0 double,ui_b1h1 double,ui_b1h2 double,ui_b1h3 double,ui_b1h4 double,ui_b1h5 double,
ui_b1h6 double,ui_b1h7 double,ui_b1h8 double,ui_b1h9 double,ui_b1h10 double,ui_b1h11 double,
ui_b1h12 double,ui_b1h13 double,ui_b1h14 double,ui_b1h15 double,ui_b1h16 double,ui_b1h17 double,
ui_b1h18 double,ui_b1h19 double,ui_b1h20 double,ui_b1h21 double,ui_b1h22 double,ui_b1h23 double);
insert into table t
select user_id,item_id,
case when hour=0 then num else 0.0 end,case when hour=1 then num else 0.0 end,
case when hour=2 then num else 0.0 end,case when hour=3 then num else 0.0 end,
case when hour=4 then num else 0.0 end,case when hour=5 then num else 0.0 end,
case when hour=6 then num else 0.0 end,case when hour=7 then num else 0.0 end,
case when hour=8 then num else 0.0 end,case when hour=9 then num else 0.0 end,
case when hour=10 then num else 0.0 end,case when hour=11 then num else 0.0 end,
case when hour=12 then num else 0.0 end,case when hour=13 then num else 0.0 end,
case when hour=14 then num else 0.0 end,case when hour=15 then num else 0.0 end,
case when hour=16 then num else 0.0 end,case when hour=17 then num else 0.0 end,
case when hour=18 then num else 0.0 end,case when hour=19 then num else 0.0 end,
case when hour=20 then num else 0.0 end,case when hour=21 then num else 0.0 end,
case when hour=22 then num else 0.0 end,case when hour=23 then num else 0.0 end
from 17_featurefile2;
--将相同ui的hour点击行为合并
drop table if exists 17_ui_b1_hour_sum;
create table if not exists 17_ui_b1_hour_sum
as select user_id,item_id,
sum(ui_b1h0) as ui_b1h0,sum(ui_b1h1) as ui_b1h1,sum(ui_b1h2) as ui_b1h2,sum(ui_b1h3) as ui_b1h3,
sum(ui_b1h4) as ui_b1h4,sum(ui_b1h5) as ui_b1h5,sum(ui_b1h6) as ui_b1h6,sum(ui_b1h7) as ui_b1h7,
sum(ui_b1h8) as ui_b1h8,sum(ui_b1h9) as ui_b1h9,sum(ui_b1h10) as ui_b1h10,sum(ui_b1h11) as ui_b1h11,
sum(ui_b1h12) as ui_b1h12,sum(ui_b1h13) as ui_b1h13,sum(ui_b1h14) as ui_b1h14,sum(ui_b1h15) as ui_b1h15,
sum(ui_b1h16) as ui_b1h16,sum(ui_b1h17) as ui_b1h17,sum(ui_b1h18) as ui_b1h18,sum(ui_b1h19) as ui_b1h19,
sum(ui_b1h20) as ui_b1h20,sum(ui_b1h21) as ui_b1h21,sum(ui_b1h22) as ui_b1h22,sum(ui_b1h23) as ui_b1h23
from t group by user_id,item_id;


------------------------------------------
--提取特征：uid对iid在各个小时里的收藏次数
-------------------------------------------
drop table if exists 17_featurefile2;
create table 17_featurefile2
as select a.user_id,a.item_id,b.hour,count(*) as num
from 17jgwc_sc_nobuy a left outer join date12_17 b
on  a.user_id=b.user_id and a.item_id=b.item_id and b.behavior_type=2
group by a.user_id,a.item_id,b.hour;

--24种hour的收藏次数分别占一列
drop table if exists t;
create table if not exists  t(user_id string,item_id string,
ui_b2h0 double,ui_b2h1 double,ui_b2h2 double,ui_b2h3 double,ui_b2h4 double,ui_b2h5 double,
ui_b2h6 double,ui_b2h7 double,ui_b2h8 double,ui_b2h9 double,ui_b2h10 double,ui_b2h11 double,
ui_b2h12 double,ui_b2h13 double,ui_b2h14 double,ui_b2h15 double,ui_b2h16 double,ui_b2h17 double,
ui_b2h18 double,ui_b2h19 double,ui_b2h20 double,ui_b2h21 double,ui_b2h22 double,ui_b2h23 double);
insert into table t
select user_id,item_id,
case when hour=0 then num else 0.0 end,case when hour=1 then num else 0.0 end,
case when hour=2 then num else 0.0 end,case when hour=3 then num else 0.0 end,
case when hour=4 then num else 0.0 end,case when hour=5 then num else 0.0 end,
case when hour=6 then num else 0.0 end,case when hour=7 then num else 0.0 end,
case when hour=8 then num else 0.0 end,case when hour=9 then num else 0.0 end,
case when hour=10 then num else 0.0 end,case when hour=11 then num else 0.0 end,
case when hour=12 then num else 0.0 end,case when hour=13 then num else 0.0 end,
case when hour=14 then num else 0.0 end,case when hour=15 then num else 0.0 end,
case when hour=16 then num else 0.0 end,case when hour=17 then num else 0.0 end,
case when hour=18 then num else 0.0 end,case when hour=19 then num else 0.0 end,
case when hour=20 then num else 0.0 end,case when hour=21 then num else 0.0 end,
case when hour=22 then num else 0.0 end,case when hour=23 then num else 0.0 end
from 17_featurefile2;
--将相同ui的hour收藏行为合并
drop table if exists 17_ui_b2_hour_sum;
create table if not exists 17_ui_b2_hour_sum
as select user_id,item_id,
sum(ui_b2h0) as ui_b2h0,sum(ui_b2h1) as ui_b2h1,sum(ui_b2h2) as ui_b2h2,sum(ui_b2h3) as ui_b2h3,
sum(ui_b2h4) as ui_b2h4,sum(ui_b2h5) as ui_b2h5,sum(ui_b2h6) as ui_b2h6,sum(ui_b2h7) as ui_b2h7,
sum(ui_b2h8) as ui_b2h8,sum(ui_b2h9) as ui_b2h9,sum(ui_b2h10) as ui_b2h10,sum(ui_b2h11) as ui_b2h11,
sum(ui_b2h12) as ui_b2h12,sum(ui_b2h13) as ui_b2h13,sum(ui_b2h14) as ui_b2h14,sum(ui_b2h15) as ui_b2h15,
sum(ui_b2h16) as ui_b2h16,sum(ui_b2h17) as ui_b2h17,sum(ui_b2h18) as ui_b2h18,sum(ui_b2h19) as ui_b2h19,
sum(ui_b2h20) as ui_b2h20,sum(ui_b2h21) as ui_b2h21,sum(ui_b2h22) as ui_b2h22,sum(ui_b2h23) as ui_b2h23
from t group by user_id,item_id;

------------------------------------------
--提取特征：uid对iid在各个小时里的加购物车次数
-------------------------------------------
drop table if exists 17_featurefile2;
create table 17_featurefile2
as select a.user_id,a.item_id,b.hour,count(*) as num
from 17jgwc_sc_nobuy a left outer join date12_17 b
on  a.user_id=b.user_id and a.item_id=b.item_id and b.behavior_type=3
group by a.user_id,a.item_id,b.hour;

--24种hour的加购物车次数分别占一列
drop table if exists t;
create table if not exists  t(user_id string,item_id string,
ui_b3h0 double,ui_b3h1 double,ui_b3h2 double,ui_b3h3 double,ui_b3h4 double,ui_b3h5 double,
ui_b3h6 double,ui_b3h7 double,ui_b3h8 double,ui_b3h9 double,ui_b3h10 double,ui_b3h11 double,
ui_b3h12 double,ui_b3h13 double,ui_b3h14 double,ui_b3h15 double,ui_b3h16 double,ui_b3h17 double,
ui_b3h18 double,ui_b3h19 double,ui_b3h20 double,ui_b3h21 double,ui_b3h22 double,ui_b3h23 double);
insert into table t
select user_id,item_id,
case when hour=0 then num else 0.0 end,case when hour=1 then num else 0.0 end,
case when hour=2 then num else 0.0 end,case when hour=3 then num else 0.0 end,
case when hour=4 then num else 0.0 end,case when hour=5 then num else 0.0 end,
case when hour=6 then num else 0.0 end,case when hour=7 then num else 0.0 end,
case when hour=8 then num else 0.0 end,case when hour=9 then num else 0.0 end,
case when hour=10 then num else 0.0 end,case when hour=11 then num else 0.0 end,
case when hour=12 then num else 0.0 end,case when hour=13 then num else 0.0 end,
case when hour=14 then num else 0.0 end,case when hour=15 then num else 0.0 end,
case when hour=16 then num else 0.0 end,case when hour=17 then num else 0.0 end,
case when hour=18 then num else 0.0 end,case when hour=19 then num else 0.0 end,
case when hour=20 then num else 0.0 end,case when hour=21 then num else 0.0 end,
case when hour=22 then num else 0.0 end,case when hour=23 then num else 0.0 end
from 17_featurefile2;
--将相同ui的hour加购物车行为合并
drop table if exists 17_ui_b3_hour_sum;
create table if not exists 17_ui_b3_hour_sum
as select user_id,item_id,
sum(ui_b3h0) as ui_b3h0,sum(ui_b3h1) as ui_b3h1,sum(ui_b3h2) as ui_b3h2,sum(ui_b3h3) as ui_b3h3,
sum(ui_b3h4) as ui_b3h4,sum(ui_b3h5) as ui_b3h5,sum(ui_b3h6) as ui_b3h6,sum(ui_b3h7) as ui_b3h7,
sum(ui_b3h8) as ui_b3h8,sum(ui_b3h9) as ui_b3h9,sum(ui_b3h10) as ui_b3h10,sum(ui_b3h11) as ui_b3h11,
sum(ui_b3h12) as ui_b3h12,sum(ui_b3h13) as ui_b3h13,sum(ui_b3h14) as ui_b3h14,sum(ui_b3h15) as ui_b3h15,
sum(ui_b3h16) as ui_b3h16,sum(ui_b3h17) as ui_b3h17,sum(ui_b3h18) as ui_b3h18,sum(ui_b3h19) as ui_b3h19,
sum(ui_b3h20) as ui_b3h20,sum(ui_b3h21) as ui_b3h21,sum(ui_b3h22) as ui_b3h22,sum(ui_b3h23) as ui_b3h23
from t group by user_id,item_id;


-------------------------------------------------
--提取特征：uid对all商品四种行为的总数
-------------------------------------------------
drop table if exists 17_featurefile1;
create table 17_featurefile1
as select a.user_id,b.behavior_type,count(*) as num
from 17jgwc_sc_nobuy a left outer join date12_17 b
on a.user_id=b.user_id
group by a.user_id,b.behavior_type;

--四种行为分别占一列
drop table if exists t;
create table if not exists  t(user_id string,ua_b1 double,ua_b2 double,ua_b3 double,ua_b4 double);
insert into table t
select user_id,
case behavior_type when 1 then num else 0.0 end,
case behavior_type when 2 then num else 0.0 end,
case behavior_type when 3 then num else 0.0 end,
case behavior_type when 4 then num else 0.0 end
from 17_featurefile1;

--将相同的ui的三种行为合并
drop table if exists 17_ua_behavior_sum;
create table if not exists 17_ua_behavior_sum
as select user_id,sum(ua_b1) as ua_b1,sum(ua_b2) as ua_b2,sum(ua_b3) as ua_b3,sum(ua_b4) as ua_b4
from t group by user_id;


------------------------------------------
--提取特征：uid对all在各个小时里的点击次数
-------------------------------------------
drop table if exists 17_featurefile2;
create table 17_featurefile2
as select a.user_id,b.hour,count(*) as num
from 17jgwc_sc_nobuy a left outer join date12_17 b
on  a.user_id=b.user_id and b.behavior_type=1
group by a.user_id,b.hour;

--24种hour的点击次数分别占一列
drop table if exists t;
create table if not exists  t(user_id string,
ua_b1h0 double,ua_b1h1 double,ua_b1h2 double,ua_b1h3 double,ua_b1h4 double,ua_b1h5 double,
ua_b1h6 double,ua_b1h7 double,ua_b1h8 double,ua_b1h9 double,ua_b1h10 double,ua_b1h11 double,
ua_b1h12 double,ua_b1h13 double,ua_b1h14 double,ua_b1h15 double,ua_b1h16 double,ua_b1h17 double,
ua_b1h18 double,ua_b1h19 double,ua_b1h20 double,ua_b1h21 double,ua_b1h22 double,ua_b1h23 double);
insert into table t
select user_id,
case when hour=0 then num else 0.0 end,case when hour=1 then num else 0.0 end,
case when hour=2 then num else 0.0 end,case when hour=3 then num else 0.0 end,
case when hour=4 then num else 0.0 end,case when hour=5 then num else 0.0 end,
case when hour=6 then num else 0.0 end,case when hour=7 then num else 0.0 end,
case when hour=8 then num else 0.0 end,case when hour=9 then num else 0.0 end,
case when hour=10 then num else 0.0 end,case when hour=11 then num else 0.0 end,
case when hour=12 then num else 0.0 end,case when hour=13 then num else 0.0 end,
case when hour=14 then num else 0.0 end,case when hour=15 then num else 0.0 end,
case when hour=16 then num else 0.0 end,case when hour=17 then num else 0.0 end,
case when hour=18 then num else 0.0 end,case when hour=19 then num else 0.0 end,
case when hour=20 then num else 0.0 end,case when hour=21 then num else 0.0 end,
case when hour=22 then num else 0.0 end,case when hour=23 then num else 0.0 end
from 17_featurefile2;
--将相同u的hour点击行为合并
drop table if exists  17_ua_b1_hour_sum;
create table if not exists 17_ua_b1_hour_sum
as select user_id,
sum(ua_b1h0) as b1h0,sum(ua_b1h1) as b1h1,sum(ua_b1h2) as b1h2,sum(ua_b1h3) as b1h3,
sum(ua_b1h4) as b1h4,sum(ua_b1h5) as b1h5,sum(ua_b1h6) as b1h6,sum(ua_b1h7) as b1h7,
sum(ua_b1h8) as b1h8,sum(ua_b1h9) as b1h9,sum(ua_b1h10) as b1h10,sum(ua_b1h11) as b1h11,
sum(ua_b1h12) as b1h12,sum(ua_b1h13) as b1h13,sum(ua_b1h14) as b1h14,sum(ua_b1h15) as b1h15,
sum(ua_b1h16) as b1h16,sum(ua_b1h17) as b1h17,sum(ua_b1h18) as b1h18,sum(ua_b1h19) as b1h19,
sum(ua_b1h20) as b1h20,sum(ua_b1h21) as b1h21,sum(ua_b1h22) as b1h22,sum(ua_b1h23) as b1h23
from t group by user_id;


------------------------------------------
--提取特征：uid对all在各个小时里的收藏次数
-------------------------------------------
drop table if exists 17_featurefile2;
create table 17_featurefile2
as select a.user_id,b.hour,count(*) as num
from 17jgwc_sc_nobuy a left outer join date12_17 b
on  a.user_id=b.user_id and b.behavior_type=2
group by a.user_id,b.hour;

--24种hour的收藏次数分别占一列
drop table if exists t;
create table if not exists  t(user_id string,
ua_b2h0 double,ua_b2h1 double,ua_b2h2 double,ua_b2h3 double,ua_b2h4 double,ua_b2h5 double,
ua_b2h6 double,ua_b2h7 double,ua_b2h8 double,ua_b2h9 double,ua_b2h10 double,ua_b2h11 double,
ua_b2h12 double,ua_b2h13 double,ua_b2h14 double,ua_b2h15 double,ua_b2h16 double,ua_b2h17 double,
ua_b2h18 double,ua_b2h19 double,ua_b2h20 double,ua_b2h21 double,ua_b2h22 double,ua_b2h23 double);
insert into table t
select user_id,
case when hour=0 then num else 0.0 end,case when hour=1 then num else 0.0 end,
case when hour=2 then num else 0.0 end,case when hour=3 then num else 0.0 end,
case when hour=4 then num else 0.0 end,case when hour=5 then num else 0.0 end,
case when hour=6 then num else 0.0 end,case when hour=7 then num else 0.0 end,
case when hour=8 then num else 0.0 end,case when hour=9 then num else 0.0 end,
case when hour=10 then num else 0.0 end,case when hour=11 then num else 0.0 end,
case when hour=12 then num else 0.0 end,case when hour=13 then num else 0.0 end,
case when hour=14 then num else 0.0 end,case when hour=15 then num else 0.0 end,
case when hour=16 then num else 0.0 end,case when hour=17 then num else 0.0 end,
case when hour=18 then num else 0.0 end,case when hour=19 then num else 0.0 end,
case when hour=20 then num else 0.0 end,case when hour=21 then num else 0.0 end,
case when hour=22 then num else 0.0 end,case when hour=23 then num else 0.0 end
from 17_featurefile2;
--将相同u的hour收藏行为合并
drop table if exists 17_ua_b2_hour_sum;
create table if not exists 17_ua_b2_hour_sum
as select user_id,
sum(ua_b2h0) as b2h0,sum(ua_b2h1) as b2h1,sum(ua_b2h2) as b2h2,sum(ua_b2h3) as b2h3,
sum(ua_b2h4) as b2h4,sum(ua_b2h5) as b2h5,sum(ua_b2h6) as b2h6,sum(ua_b2h7) as b2h7,
sum(ua_b2h8) as b2h8,sum(ua_b2h9) as b2h9,sum(ua_b2h10) as b2h10,sum(ua_b2h11) as b2h11,
sum(ua_b2h12) as b2h12,sum(ua_b2h13) as b2h13,sum(ua_b2h14) as b2h14,sum(ua_b2h15) as b2h15,
sum(ua_b2h16) as b2h16,sum(ua_b2h17) as b2h17,sum(ua_b2h18) as b2h18,sum(ua_b2h19) as b2h19,
sum(ua_b2h20) as b2h20,sum(ua_b2h21) as b2h21,sum(ua_b2h22) as b2h22,sum(ua_b2h23) as b2h23
from t group by user_id;

------------------------------------------
--提取特征：uid对all在各个小时里的加购物车次数
-------------------------------------------
drop table if exists 17_featurefile22;
create table 17_featurefile22
as select a.user_id,b.hour,count(*) as num
from 17jgwc_sc_nobuy a left outer join date12_17 b
on  a.user_id=b.user_id and b.behavior_type=3
group by a.user_id,b.hour;

--24种hour的加购物车次数分别占一列
drop table if exists tt;
create table if not exists  tt(user_id string,
ua_b3h0 double,ua_b3h1 double,ua_b3h2 double,ua_b3h3 double,ua_b3h4 double,ua_b3h5 double,
ua_b3h6 double,ua_b3h7 double,ua_b3h8 double,ua_b3h9 double,ua_b3h10 double,ua_b3h11 double,
ua_b3h12 double,ua_b3h13 double,ua_b3h14 double,ua_b3h15 double,ua_b3h16 double,ua_b3h17 double,
ua_b3h18 double,ua_b3h19 double,ua_b3h20 double,ua_b3h21 double,ua_b3h22 double,ua_b3h23 double);
insert into table tt
select user_id,
case when hour=0 then num else 0.0 end,case when hour=1 then num else 0.0 end,
case when hour=2 then num else 0.0 end,case when hour=3 then num else 0.0 end,
case when hour=4 then num else 0.0 end,case when hour=5 then num else 0.0 end,
case when hour=6 then num else 0.0 end,case when hour=7 then num else 0.0 end,
case when hour=8 then num else 0.0 end,case when hour=9 then num else 0.0 end,
case when hour=10 then num else 0.0 end,case when hour=11 then num else 0.0 end,
case when hour=12 then num else 0.0 end,case when hour=13 then num else 0.0 end,
case when hour=14 then num else 0.0 end,case when hour=15 then num else 0.0 end,
case when hour=16 then num else 0.0 end,case when hour=17 then num else 0.0 end,
case when hour=18 then num else 0.0 end,case when hour=19 then num else 0.0 end,
case when hour=20 then num else 0.0 end,case when hour=21 then num else 0.0 end,
case when hour=22 then num else 0.0 end,case when hour=23 then num else 0.0 end
from 17_featurefile22;
--将相同u的hour加购物车行为合并
drop table if exists 17_ua_b3_hour_sum;
create table if not exists 17_ua_b3_hour_sum
as select user_id,
sum(ua_b3h0) as b3h0,sum(ua_b3h1) as b3h1,sum(ua_b3h2) as b3h2,sum(ua_b3h3) as b3h3,
sum(ua_b3h4) as b3h4,sum(ua_b3h5) as b3h5,sum(ua_b3h6) as b3h6,sum(ua_b3h7) as b3h7,
sum(ua_b3h8) as b3h8,sum(ua_b3h9) as b3h9,sum(ua_b3h10) as b3h10,sum(ua_b3h11) as b3h11,
sum(ua_b3h12) as b3h12,sum(ua_b3h13) as b3h13,sum(ua_b3h14) as b3h14,sum(ua_b3h15) as b3h15,
sum(ua_b3h16) as b3h16,sum(ua_b3h17) as b3h17,sum(ua_b3h18) as b3h18,sum(ua_b3h19) as b3h19,
sum(ua_b3h20) as b3h20,sum(ua_b3h21) as b3h21,sum(ua_b3h22) as b3h22,sum(ua_b3h23) as b3h23
from tt group by user_id;

------------------------------------------
--提取特征：uid对all在各个小时里的购买次数
-------------------------------------------
drop table if exists 17_featurefile222;
create table 17_featurefile222
as select a.user_id,b.hour,count(*) as num
from 17jgwc_sc_nobuy a left outer join date12_17 b
on  a.user_id=b.user_id and b.behavior_type=4
group by a.user_id,b.hour;

--24种hour的购买次数分别占一列
drop table if exists ttt;
create table if not exists  ttt(user_id string,
ua_b4h0 double,ua_b4h1 double,ua_b4h2 double,ua_b4h3 double,ua_b4h4 double,ua_b4h5 double,
ua_b4h6 double,ua_b4h7 double,ua_b4h8 double,ua_b4h9 double,ua_b4h10 double,ua_b4h11 double,
ua_b4h12 double,ua_b4h13 double,ua_b4h14 double,ua_b4h15 double,ua_b4h16 double,ua_b4h17 double,
ua_b4h18 double,ua_b4h19 double,ua_b4h20 double,ua_b4h21 double,ua_b4h22 double,ua_b4h23 double);
insert into table ttt
select user_id,
case when hour=0 then num else 0.0 end,case when hour=1 then num else 0.0 end,
case when hour=2 then num else 0.0 end,case when hour=3 then num else 0.0 end,
case when hour=4 then num else 0.0 end,case when hour=5 then num else 0.0 end,
case when hour=6 then num else 0.0 end,case when hour=7 then num else 0.0 end,
case when hour=8 then num else 0.0 end,case when hour=9 then num else 0.0 end,
case when hour=10 then num else 0.0 end,case when hour=11 then num else 0.0 end,
case when hour=12 then num else 0.0 end,case when hour=13 then num else 0.0 end,
case when hour=14 then num else 0.0 end,case when hour=15 then num else 0.0 end,
case when hour=16 then num else 0.0 end,case when hour=17 then num else 0.0 end,
case when hour=18 then num else 0.0 end,case when hour=19 then num else 0.0 end,
case when hour=20 then num else 0.0 end,case when hour=21 then num else 0.0 end,
case when hour=22 then num else 0.0 end,case when hour=23 then num else 0.0 end
from 17_featurefile222;
--将相同u的hour购买行为合并
drop table if exists 17_ua_b4_hour_sum;
create table if not exists 17_ua_b4_hour_sum
as select user_id,
sum(ua_b4h0) as b4h0,sum(ua_b4h1) as b4h1,sum(ua_b4h2) as b4h2,sum(ua_b4h3) as b4h3,
sum(ua_b4h4) as b4h4,sum(ua_b4h5) as b4h5,sum(ua_b4h6) as b4h6,sum(ua_b4h7) as b4h7,
sum(ua_b4h8) as b4h8,sum(ua_b4h9) as b4h9,sum(ua_b4h10) as b4h10,sum(ua_b4h11) as b4h11,
sum(ua_b4h12) as b4h12,sum(ua_b4h13) as b4h13,sum(ua_b4h14) as b4h14,sum(ua_b4h15) as b4h15,
sum(ua_b4h16) as b4h16,sum(ua_b4h17) as b4h17,sum(ua_b4h18) as b4h18,sum(ua_b4h19) as b4h19,
sum(ua_b4h20) as b4h20,sum(ua_b4h21) as b4h21,sum(ua_b4h22) as b4h22,sum(ua_b4h23) as b4h23
from ttt group by user_id;



-----------------------------------------------------
--uid在2014-12-16之前的总的点击，收藏，加购物车，购买次数
------------------------------------------------------
drop table if exists tmp;
create table tmp
as select b.user_id,c.behavior_type,c.num
from
(
    select user_id,behavior_type,count(1) as num
    from 
        (
        select user_id,behavior_type
        from tianchi_lbs.tianchi_mobile_recommend_train_user
        where substr(time,1,10)<="2014-12-16"
        )a
    group by user_id,behavior_type
)c
right outer join
(   --特定用户
    select distinct user_id
    from 17jgwc_sc_nobuy
)b
on c.user_id=b.user_id;

--四种行为分别占一列
drop table t;
create table if not exists  t(user_id string,u_b1 double,u_b2 double,u_b3 double,u_b4 double);
insert into table t
select user_id,
case behavior_type when 1 then num else 0.0 end,
case behavior_type when 2 then num else 0.0 end,
case behavior_type when 3 then num else 0.0 end,
case behavior_type when 4 then num else 0.0 end
from tmp;

--将相同的u的四种行为合并
drop table if exists 17u_ever_behavior_sum;
create table if not exists 17u_ever_behavior_sum
as select user_id,sum(u_b1) as u_b1,sum(u_b2) as u_b2,sum(u_b3) as u_b3,sum(u_b4) as u_b4
from t group by user_id;

-----------------------------------------------------
--iid在2014-12-16之前的总的被点击，收藏，加购物车，购买次数
------------------------------------------------------
drop table if exists tmp;
create table tmp
as select b.item_id,c.behavior_type,c.num
from
(
    select item_id,behavior_type,count(1) as num
    from 
        (
        select item_id,behavior_type
        from tianchi_lbs.tianchi_mobile_recommend_train_user
        where substr(time,1,10)<="2014-12-16"
        )a
    group by item_id,behavior_type
)c
right outer join
(   --特定商品
    select distinct item_id
    from 17jgwc_sc_nobuy
)b
on c.item_id=b.item_id;

--四种行为分别占一列
drop table t;
create table if not exists  t(item_id string,i_b1 double,i_b2 double,i_b3 double,i_b4 double);
insert into table t
select item_id,
case behavior_type when 1 then num else 0.0 end,
case behavior_type when 2 then num else 0.0 end,
case behavior_type when 3 then num else 0.0 end,
case behavior_type when 4 then num else 0.0 end
from tmp;

--将相同的i的四种行为合并
drop table if exists 17i_ever_behavior_sum;
create table if not exists 17i_ever_behavior_sum
as select item_id,sum(i_b1) as i_b1,sum(i_b2) as i_b2,sum(i_b3) as i_b3,sum(i_b4) as i_b4
from t group by item_id;


--************************************************************
--*******************2015/05/31添加以下特征******************
--************************************************************

-----------------------------------------------------
--uid在2014-12-16之前的活跃天数
------------------------------------------------------
drop table if exists 17u_liveday;
create table 17u_liveday
as select c.user_id,b.liveday
from
(
select user_id,count(*) as liveday
from 
    (
    select distinct user_id,substr(time,1,10) as day
    from tianchi_lbs.tianchi_mobile_recommend_train_user
    where substr(time,1,10) <="2014-12-16"
    )a
group by user_id
)b
right outer join
(   --特定用户
    select distinct user_id
    from 17jgwc_sc_nobuy
)c
on c.user_id=b.user_id;


-----------------------------------------------------
--uid对iid在2014-12-16之前的四种行为的总量
------------------------------------------------------
drop table if exists tmp;
create table tmp
as select c.user_id,c.item_id,b.behavior_type,b.num
from
(
    select user_id,item_id,behavior_type,count(*) as num
    from tianchi_lbs.tianchi_mobile_recommend_train_user
    where substr(time,1,10) <="2014-12-16"
    group by user_id,item_id,behavior_type
)b
right outer join
(   --特定用户
    select distinct user_id,item_id
    from 17jgwc_sc_nobuy
)c
on c.user_id=b.user_id and c.item_id=b.item_id;

--四种行为分别占一列
drop table if exists tmp1;
create table   tmp1(user_id string,item_id string,ui_hb1 double,ui_hb2 double,ui_hb3 double,ui_hb4 double);
insert into table  tmp1
select user_id,item_id,
case behavior_type when 1 then num else 0.0 end,
case behavior_type when 2 then num else 0.0 end,
case behavior_type when 3 then num else 0.0 end,
case behavior_type when 4 then num else 0.0 end
from tmp;

--将相同的ui的四种行为合并
drop table if exists 17ui_history;
create table 17ui_history
as select user_id,item_id,sum(ui_hb1) as ui_hb1,sum(ui_hb2) as ui_hb2,sum(ui_hb3) as ui_hb3,sum(ui_hb4) as ui_hb4
from tmp1 group by user_id,item_id;


--************************************************************
--*******************2015/06/06增加以下特征******************
--************************************************************

-------------------------------------------------
--提取特征：17号当天uid对all商品的购买总数
-------------------------------------------------
drop table if exists 17_featurefile1;
create table 17_featurefile1
as select a.user_id,b.behavior_type,count(*) as num
from 17jgwc_sc_nobuy a left outer join date12_17 b
on a.user_id=b.user_id
group by a.user_id,b.behavior_type;


drop table if exists 17_ua_b4_sum;
create table 17_ua_b4_sum(user_id string,ua_b4 double);
insert into table 17_ua_b4_sum
select user_id,
sum(case behavior_type when 4 then num else 0.0 end)
from 17_featurefile1
group by user_id;

-------------------------------------------------
--特征：17号当天，uid对iid的品牌的四种行为的总数
-------------------------------------------------
drop table if exists 17_feature_temp;
create table 17_feature_temp
    as select user_id,item_category, behavior_type, count(*) as num
        from date12_17
        group by user_id,item_category, behavior_type;

--四种行为分别占一列
drop table if exists 17_feature_uc;
create table 17_feature_uc
    (
    	user_id string,
    	item_category string,
    	uc_b1 double,
    	uc_b2 double,
    	uc_b3 double,
    	uc_b4 double
    );
insert overwrite table 17_feature_uc
    select user_id,item_category,
        sum(case behavior_type when 1 then num else 0.0 end),
        sum(case behavior_type when 2 then num else 0.0 end),
        sum(case behavior_type when 3 then num else 0.0 end),
        sum(case behavior_type when 4 then num else 0.0 end)
        from 17_feature_temp
        group by user_id,item_category;




-------------------------------------------------
--特征：17号以前，uid对iid的品牌的四种行为的总数
-------------------------------------------------
drop table if exists tmp;
create table tmp
as select c.user_id,c.item_category,b.behavior_type,b.num
from
(
    select user_id,item_category,behavior_type,count(*) as num
    from tianchi_lbs.tianchi_mobile_recommend_train_user
    where substr(time,1,10) <="2014-12-16"
    group by user_id,item_category,behavior_type
)b
right outer join
(   --特定用户
    select distinct user_id,item_category
    from 17jgwc_sc_nobuy
)c
on c.user_id=b.user_id and c.item_category=b.item_category;

--四种行为分别占一列
drop table if exists tmp1;
create table   tmp1(user_id string,item_category string,uc_hb1 double,uc_hb2 double,uc_hb3 double,uc_hb4 double);
insert into table  tmp1
select user_id,item_category,
case behavior_type when 1 then num else 0.0 end,
case behavior_type when 2 then num else 0.0 end,
case behavior_type when 3 then num else 0.0 end,
case behavior_type when 4 then num else 0.0 end
from tmp;

--将相同的uc的四种行为合并
drop table if exists 17uc_history;
create table 17uc_history
as select user_id,item_category,sum(uc_hb1) as uc_hb1,sum(uc_hb2) as uc_hb2,sum(uc_hb3) as uc_hb3,sum(uc_hb4) as uc_hb4
from tmp1 group by user_id,item_category;

-------------------------------------------------
--特征：17号以前，uid发生过购买行为的天数
-------------------------------------------------
drop table if exists 17u_buyday;
create table 17u_buyday
as select c.user_id,b.buyday
from
(
select user_id,count(*) as buyday
from 
    (
    select distinct user_id,substr(time,1,10) as day
    from tianchi_lbs.tianchi_mobile_recommend_train_user
    where substr(time,1,10) <="2014-12-16" and behavior_type=4
    )a
group by user_id
)b
right outer join
(   --特定用户
    select distinct user_id
    from 17jgwc_sc_nobuy
)c
on c.user_id=b.user_id;


-----------------------------------------------------
--uid在前三天即2014-12-14～2014-12-16之间的总的点击，收藏，加购物车，购买次数
------------------------------------------------------
drop table if exists tmp;
create table tmp
as select b.user_id,c.behavior_type,c.num
from
(
    select user_id,behavior_type,count(1) as num
    from 
        (
        select user_id,behavior_type
        from tianchi_lbs.tianchi_mobile_recommend_train_user
        where substr(time,1,10)<="2014-12-16" and substr(time,1,10)>="2014-12-14"
        )a
    group by user_id,behavior_type
)c
right outer join
(   --特定用户
    select distinct user_id
    from 17jgwc_sc_nobuy
)b
on c.user_id=b.user_id;

--四种行为分别占一列
drop table t;
create table if not exists  t(user_id string,u_b1 double,u_b2 double,u_b3 double,u_b4 double);
insert into table t
select user_id,
case behavior_type when 1 then num else 0.0 end,
case behavior_type when 2 then num else 0.0 end,
case behavior_type when 3 then num else 0.0 end,
case behavior_type when 4 then num else 0.0 end
from tmp;

--将相同的u的四种行为合并
drop table if exists 17u_3day_behavior_sum;
create table if not exists 17u_3day_behavior_sum
as select user_id,sum(u_b1) as u3day_b1,sum(u_b2) as u3day_b2,sum(u_b3) as u3day_b3,sum(u_b4) as u3day_b4
from t group by user_id;


-----------------------------------------------------
--uid在前7天即2014-12-10～2014-12-16之间的总的点击，收藏，加购物车，购买次数
------------------------------------------------------
drop table if exists tmp;
create table tmp
as select b.user_id,c.behavior_type,c.num
from
(
    select user_id,behavior_type,count(1) as num
    from 
        (
        select user_id,behavior_type
        from tianchi_lbs.tianchi_mobile_recommend_train_user
        where substr(time,1,10)<="2014-12-16" and substr(time,1,10)>="2014-12-10"
        )a
    group by user_id,behavior_type
)c
right outer join
(   --特定用户
    select distinct user_id
    from 17jgwc_sc_nobuy
)b
on c.user_id=b.user_id;

--四种行为分别占一列
drop table t;
create table if not exists  t(user_id string,u_b1 double,u_b2 double,u_b3 double,u_b4 double);
insert into table t
select user_id,
case behavior_type when 1 then num else 0.0 end,
case behavior_type when 2 then num else 0.0 end,
case behavior_type when 3 then num else 0.0 end,
case behavior_type when 4 then num else 0.0 end
from tmp;

--将相同的u的四种行为合并
drop table if exists 17u_7day_behavior_sum;
create table if not exists 17u_7day_behavior_sum
as select user_id,sum(u_b1) as u7day_b1,sum(u_b2) as u7day_b2,sum(u_b3) as u7day_b3,sum(u_b4) as u7day_b4
from t group by user_id;

-----------------------------------------------------
--uid在前14天即2014-12-3～2014-12-16之间的总的点击，收藏，加购物车，购买次数
------------------------------------------------------
drop table if exists tmp;
create table tmp
as select b.user_id,c.behavior_type,c.num
from
(
    select user_id,behavior_type,count(1) as num
    from 
        (
        select user_id,behavior_type
        from tianchi_lbs.tianchi_mobile_recommend_train_user
        where substr(time,1,10)<="2014-12-16" and substr(time,1,10)>="2014-12-03"
        )a
    group by user_id,behavior_type
)c
right outer join
(   --特定用户
    select distinct user_id
    from 17jgwc_sc_nobuy
)b
on c.user_id=b.user_id;

--四种行为分别占一列
drop table t;
create table if not exists  t(user_id string,u_b1 double,u_b2 double,u_b3 double,u_b4 double);
insert into table t
select user_id,
case behavior_type when 1 then num else 0.0 end,
case behavior_type when 2 then num else 0.0 end,
case behavior_type when 3 then num else 0.0 end,
case behavior_type when 4 then num else 0.0 end
from tmp;

--将相同的u的四种行为合并
drop table if exists 17u_14day_behavior_sum;
create table if not exists 17u_14day_behavior_sum
as select user_id,sum(u_b1) as u14day_b1,sum(u_b2) as u14day_b2,sum(u_b3) as u14day_b3,sum(u_b4) as u14day_b4
from t group by user_id;



-----------------------------------------------------
--iid在前3天即2014-12-14～2014-12-16之前的总的被点击，收藏，加购物车，购买次数
------------------------------------------------------
drop table if exists tmp;
create table tmp
as select b.item_id,c.behavior_type,c.num
from
(
    select item_id,behavior_type,count(1) as num
    from 
        (
        select item_id,behavior_type
        from tianchi_lbs.tianchi_mobile_recommend_train_user
        where substr(time,1,10)<="2014-12-16" and substr(time,1,10)>="2014-12-14"
        )a
    group by item_id,behavior_type
)c
right outer join
(   --特定商品
    select distinct item_id
    from 17jgwc_sc_nobuy
)b
on c.item_id=b.item_id;

--四种行为分别占一列
drop table if exists t;
create table if not exists  t(item_id string,i_b1 double,i_b2 double,i_b3 double,i_b4 double);
insert into table t
select item_id,
case behavior_type when 1 then num else 0.0 end,
case behavior_type when 2 then num else 0.0 end,
case behavior_type when 3 then num else 0.0 end,
case behavior_type when 4 then num else 0.0 end
from tmp;

--将相同的i的四种行为合并
drop table if exists 17i_3day_behavior_sum;
create table if not exists 17i_3day_behavior_sum
as select item_id,sum(i_b1) as i3day_b1,sum(i_b2) as i3day_b2,sum(i_b3) as i3day_b3,sum(i_b4) as i3day_b4
from t group by item_id;

-----------------------------------------------------
--iid在前7天即2014-12-10～2014-12-16之前的总的被点击，收藏，加购物车，购买次数
------------------------------------------------------
drop table if exists tmp;
create table tmp
as select b.item_id,c.behavior_type,c.num
from
(
    select item_id,behavior_type,count(1) as num
    from 
        (
        select item_id,behavior_type
        from tianchi_lbs.tianchi_mobile_recommend_train_user
        where substr(time,1,10)<="2014-12-16" and substr(time,1,10)>="2014-12-10"
        )a
    group by item_id,behavior_type
)c
right outer join
(   --特定商品
    select distinct item_id
    from 17jgwc_sc_nobuy
)b
on c.item_id=b.item_id;

--四种行为分别占一列
drop table if exists t;
create table if not exists  t(item_id string,i_b1 double,i_b2 double,i_b3 double,i_b4 double);
insert into table t
select item_id,
case behavior_type when 1 then num else 0.0 end,
case behavior_type when 2 then num else 0.0 end,
case behavior_type when 3 then num else 0.0 end,
case behavior_type when 4 then num else 0.0 end
from tmp;

--将相同的i的四种行为合并
drop table if exists 17i_7day_behavior_sum;
create table if not exists 17i_7day_behavior_sum
as select item_id,sum(i_b1) as i7day_b1,sum(i_b2) as i7day_b2,sum(i_b3) as i7day_b3,sum(i_b4) as i7day_b4
from t group by item_id;



-----------------------------------------------------
--iid在前14天即2014-12-3～2014-12-16之前的总的被点击，收藏，加购物车，购买次数
------------------------------------------------------
drop table if exists tmp;
create table tmp
as select b.item_id,c.behavior_type,c.num
from
(
    select item_id,behavior_type,count(1) as num
    from 
        (
        select item_id,behavior_type
        from tianchi_lbs.tianchi_mobile_recommend_train_user
        where substr(time,1,10)<="2014-12-16" and substr(time,1,10)>="2014-12-03"
        )a
    group by item_id,behavior_type
)c
right outer join
(   --特定商品
    select distinct item_id
    from 17jgwc_sc_nobuy
)b
on c.item_id=b.item_id;

--四种行为分别占一列
drop table if exists t;
create table if not exists  t(item_id string,i_b1 double,i_b2 double,i_b3 double,i_b4 double);
insert into table t
select item_id,
case behavior_type when 1 then num else 0.0 end,
case behavior_type when 2 then num else 0.0 end,
case behavior_type when 3 then num else 0.0 end,
case behavior_type when 4 then num else 0.0 end
from tmp;

--将相同的i的四种行为合并
drop table if exists 17i_14day_behavior_sum;
create table if not exists 17i_14day_behavior_sum
as select item_id,sum(i_b1) as i14day_b1,sum(i_b2) as i14day_b2,sum(i_b3) as i14day_b3,sum(i_b4) as i14day_b4
from t group by item_id;


-----------------------------------------------------
--iid在17号前，被点击，收藏，加购物车，购买的总人数（即相同人只算一次）
------------------------------------------------------
drop table if exists tmp;
create table tmp
as select b.item_id,c.behavior_type,c.num
from
(
    select item_id,behavior_type,count(1) as num
    from 
        (
        select distinct item_id,user_id,behavior_type
        from tianchi_lbs.tianchi_mobile_recommend_train_user
        where substr(time,1,10)<="2014-12-16"
        )a
    group by item_id,behavior_type
)c
right outer join
(   --特定商品
    select distinct item_id
    from 17jgwc_sc_nobuy
)b
on c.item_id=b.item_id;

--四种行为分别占一列
drop table if exists t;
create table if not exists  t(item_id string,i_b1 double,i_b2 double,i_b3 double,i_b4 double);
insert into table t
select item_id,
case behavior_type when 1 then num else 0.0 end,
case behavior_type when 2 then num else 0.0 end,
case behavior_type when 3 then num else 0.0 end,
case behavior_type when 4 then num else 0.0 end
from tmp;

--将相同的i的四种行为合并
drop table if exists 17i_ppl_behavior_sum;
create table if not exists 17i_ppl_behavior_sum
as select item_id,sum(i_b1) as i_pplb1,sum(i_b2) as i_pplb2,sum(i_b3) as i_pplb3,sum(i_b4) as i_pplb4
from t group by item_id;





-----------------------------------------------------
--uid在17号前，点击、收藏、加购物车、购买过的商品类别数
------------------------------------------------------
drop table if exists tmp;
create table tmp
as select b.user_id,c.behavior_type,c.num
from
(
    select user_id,behavior_type,count(1) as num
    from 
        (
        select distinct user_id,item_id,behavior_type
        from tianchi_lbs.tianchi_mobile_recommend_train_user
        where substr(time,1,10)<="2014-12-16"
        )a
    group by user_id,behavior_type
)c
right outer join
(   --特定用户
    select distinct user_id
    from 17jgwc_sc_nobuy
)b
on c.user_id=b.user_id;

--四种行为分别占一列
drop table t;
create table if not exists  t(user_id string,u_b1 double,u_b2 double,u_b3 double,u_b4 double);
insert into table t
select user_id,
case behavior_type when 1 then num else 0.0 end,
case behavior_type when 2 then num else 0.0 end,
case behavior_type when 3 then num else 0.0 end,
case behavior_type when 4 then num else 0.0 end
from tmp;

--将相同的u的四种行为合并
drop table if exists 17u_item_behavior_sum;
create table if not exists 17u_item_behavior_sum
as select user_id,sum(u_b1) as u_item_hb1,sum(u_b2) as u_item_hb2,sum(u_b3) as u_item_hb3,sum(u_b4) as u_item_hb4
from t group by user_id;


-----------------------------------------------------
--uid在17号当天，点击、收藏、加购物车、购买过的商品类别数
------------------------------------------------------
drop table if exists tmp;
create table tmp
as select b.user_id,c.behavior_type,c.num
from
(
    select user_id,behavior_type,count(1) as num
    from 
        (
        select distinct user_id,item_id,behavior_type
        from tianchi_lbs.tianchi_mobile_recommend_train_user
        where substr(time,1,10)="2014-12-17"
        )a
    group by user_id,behavior_type
)c
right outer join
(   --特定用户
    select distinct user_id
    from 17jgwc_sc_nobuy
)b
on c.user_id=b.user_id;

--四种行为分别占一列
drop table t;
create table if not exists  t(user_id string,u_b1 double,u_b2 double,u_b3 double,u_b4 double);
insert into table t
select user_id,
case behavior_type when 1 then num else 0.0 end,
case behavior_type when 2 then num else 0.0 end,
case behavior_type when 3 then num else 0.0 end,
case behavior_type when 4 then num else 0.0 end
from tmp;

--将相同的u的四种行为合并
drop table if exists 17u_item_behavior_sum17;
create table if not exists 17u_item_behavior_sum17
as select user_id,sum(u_b1) as u_item_b1,sum(u_b2) as u_item_b2,sum(u_b3) as u_item_b3,sum(u_b4) as u_item_b4
from t group by user_id;



-----------------------------------------------------
--uid在17号前点击、收藏、加购物车、购买过的商品品牌数
------------------------------------------------------
drop table if exists tmp;
create table tmp
as select b.user_id,c.behavior_type,c.num
from
(
    select user_id,behavior_type,count(1) as num
    from 
        (
        select distinct user_id,item_category,behavior_type
        from tianchi_lbs.tianchi_mobile_recommend_train_user
        where substr(time,1,10)<="2014-12-16"
        )a
    group by user_id,behavior_type
)c
right outer join
(   --特定用户
    select distinct user_id
    from 17jgwc_sc_nobuy
)b
on c.user_id=b.user_id;

--四种行为分别占一列
drop table t;
create table if not exists  t(user_id string,u_b1 double,u_b2 double,u_b3 double,u_b4 double);
insert into table t
select user_id,
case behavior_type when 1 then num else 0.0 end,
case behavior_type when 2 then num else 0.0 end,
case behavior_type when 3 then num else 0.0 end,
case behavior_type when 4 then num else 0.0 end
from tmp;

--将相同的u的四种行为合并
drop table if exists 17u_category_behavior_sum;
create table if not exists 17u_category_behavior_sum
as select user_id,sum(u_b1) as u_category_hb1,sum(u_b2) as u_category_hb2,sum(u_b3) as u_category_hb3,sum(u_b4) as u_category_hb4
from t group by user_id;


-----------------------------------------------------
--uid在17号当天，点击、收藏、加购物车、购买过的商品品牌数
------------------------------------------------------
drop table if exists tmp;
create table tmp
as select b.user_id,c.behavior_type,c.num
from
(
    select user_id,behavior_type,count(1) as num
    from 
        (
        select distinct user_id,item_category,behavior_type
        from tianchi_lbs.tianchi_mobile_recommend_train_user
        where substr(time,1,10)="2014-12-17"
        )a
    group by user_id,behavior_type
)c
right outer join
(   --特定用户
    select distinct user_id
    from 17jgwc_sc_nobuy
)b
on c.user_id=b.user_id;

--四种行为分别占一列
drop table t;
create table if not exists  t(user_id string,u_b1 double,u_b2 double,u_b3 double,u_b4 double);
insert into table t
select user_id,
case behavior_type when 1 then num else 0.0 end,
case behavior_type when 2 then num else 0.0 end,
case behavior_type when 3 then num else 0.0 end,
case behavior_type when 4 then num else 0.0 end
from tmp;

--将相同的u的四种行为合并
drop table if exists 17u_category_behavior_sum17;
create table if not exists 17u_category_behavior_sum17
as select user_id,sum(u_b1) as u_category_b1,sum(u_b2) as u_category_b2,sum(u_b3) as u_category_b3,sum(u_b4) as u_category_b4
from t group by user_id;





--************************************************************
--*******************2015/06/07添加以下特征******************
--************************************************************
--增加比值类特征，在表wepon_stack17_new20w上添加

drop table if exists t17;
create table t17
as select *,
(case i_b1 when 0.0 then i_b4/1.0 else i_b4/i_b1 end )as ib4ib1,
(case i_b2 when 0.0 then i_b4/1.0 else i_b4/i_b2 end )as ib4ib2,
(case i_b3 when 0.0 then i_b4/1.0 else i_b4/i_b3 end )as ib4ib3,
(case i_pplb4 when 0.0 then 0.0 else i_b4/i_pplb4 end )as ib4ipplb4,
(case u_b1 when 0.0 then u_b4/1.0 else u_b4/u_b1 end )as ub4ub1,
(case u_b2 when 0.0 then u_b4/1.0 else u_b4/u_b2 end )as ub4ub2,
(case u_b3 when 0.0 then u_b4/1.0 else u_b4/u_b3 end )as ub4ub3,
(case liveday when 0 then 0.0 else buyday/liveday end )as buydayliveday,
(case ua_b1 when 0.0 then ua_b4/1.0 else ua_b4/ua_b1 end )as uab4uab1,
(case ua_b2 when 0.0 then ua_b4/1.0 else ua_b4/ua_b2 end )as uab4uab2,
(case ua_b3 when 0.0 then ua_b4/1.0 else ua_b4/ua_b3 end )as uab4uab3
from wepon_stack17_new20w;


