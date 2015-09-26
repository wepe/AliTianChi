--选出18号16点过后提交购物车的且该天没买的，且该用户该天提交购物车次数小于10的
--也就是剔除了该天加购物车次数过多的用户
drop table if exists tianchi_mobile_recommendation_predict;
create table tianchi_mobile_recommendation_predict
as select a.user_id,a.item_id
from 
(
    select * from wepon_5_19_tianchi_mobile_recommendation_predict
)a
join
(
    select user_id
    from
    (
        select user_id,count(1) as num 
        from  wepon_5_19_tianchi_mobile_recommendation_predict
        group by user_id
    )b
    where num<10
)c
on a.user_id=c.user_id
