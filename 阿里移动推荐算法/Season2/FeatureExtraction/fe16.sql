


--************************************************************
--*******************2015/05/31添加以下特征******************
--************************************************************

-----------------------------------------------------
--uid在2014-12-15之前的活跃天数
------------------------------------------------------
drop table if exists 16u_liveday;
create table 16u_liveday
as select c.user_id,b.liveday
from
(
select user_id,count(*) as liveday
from 
    (
    select distinct user_id,substr(time,1,10) as day
    from tianchi_lbs.tianchi_mobile_recommend_train_user
    where substr(time,1,10) <="2014-12-15"
    )a
group by user_id
)b
right outer join
(   --特定用户
    select distinct user_id
    from 16jgwc_sc_nobuy
)c
on c.user_id=b.user_id;


-----------------------------------------------------
--uid对iid在2014-12-15之前的四种行为的总量
------------------------------------------------------
drop table if exists tmptmp;
create table tmptmp
as select c.user_id,c.item_id,b.behavior_type,b.num
from
(
    select user_id,item_id,behavior_type,count(*) as num
    from tianchi_lbs.tianchi_mobile_recommend_train_user
    where substr(time,1,10) <="2014-12-15"
    group by user_id,item_id,behavior_type
)b
right outer join
(   --特定用户
    select distinct user_id,item_id
    from 16jgwc_sc_nobuy
)c
on c.user_id=b.user_id and c.item_id=b.item_id;

--四种行为分别占一列
drop table if exists tmptmp1;
create table   tmptmp1(user_id string,item_id string,ui_hb1 double,ui_hb2 double,ui_hb3 double,ui_hb4 double);
insert into table  tmptmp1
select user_id,item_id,
case behavior_type when 1 then num else 0.0 end,
case behavior_type when 2 then num else 0.0 end,
case behavior_type when 3 then num else 0.0 end,
case behavior_type when 4 then num else 0.0 end
from tmptmp;

--将相同的ui的四种行为合并
drop table if exists 16ui_history;
create table 16ui_history
as select user_id,item_id,sum(ui_hb1) as ui_hb1,sum(ui_hb2) as ui_hb2,sum(ui_hb3) as ui_hb3,sum(ui_hb4) as ui_hb4
from tmp1 group by user_id,item_id;