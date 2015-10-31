--18号加购物车且当天没买，333492条
--统计一下这里面涉及的用户的历史加购物车量和购买量(针对商品全集)，以及该天的加购物车量（针对商品子集）
drop table if exists everbuy;
create table everbuy
as select c.user_id,c.behavior_type,c.num,b.18num
from
(
    select user_id,behavior_type,count(1) as num
    from 
        (
        select user_id,behavior_type
        from tianchi_lbs.tianchi_mobile_recommend_train_user
        where substr(time,1,10)<>"2014-12-18" and (behavior_type=3 or behavior_type=4)
        )a
    group by user_id,behavior_type
)c
join
(   --用户及其在18号加购物车的次数
    select user_id,count(1) as 18num 
    from wepon_5_18_tianchi_mobile_recommendation_predict
    group by user_id
)b
on c.user_id=b.user_id