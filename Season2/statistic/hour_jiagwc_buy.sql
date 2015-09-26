--统计前一天各个小时加购物车且第二天被买的情况
drop table if exists hour_jiagwc_buy;
create table hour_jiagwc_buy
as select x.hour,count(1) as num
from
(--加购物车的
    select a.user_id,a.item_id,a.day,a.hour
    from
    (
        select user_id,item_id,substr(time,1,10) as day,substr(time,12,2) as hour
        from tianchi_lbs.tianchi_mobile_recommend_train_user
        where behavior_type=3
    )a
    join
    (
        --选出商品子集里的商品
        select distinct item_id
        from tianchi_lbs.tianchi_mobile_recommend_train_item
    )b
    on a.item_id=b.item_id 
)x
join
(--被购买的
    select c.user_id,c.item_id,c.day
    from
    (
        select user_id,item_id,substr(time,1,10) as day
        from tianchi_lbs.tianchi_mobile_recommend_train_user
        where behavior_type=4
    )c
    join
    (
        --选出商品子集里的商品
        select distinct item_id
        from tianchi_lbs.tianchi_mobile_recommend_train_item
    )d
    on c.item_id=d.item_id 
)y
on x.user_id=y.user_id and x.item_id=y.item_id
where substr(x.day,6,2)=substr(y.day,6,2) and substr(x.day,9,2)+1=substr(y.day,9,2)
group by x.hour