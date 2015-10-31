--统计每个用户的加购物车次数
--加购物车次数过多的用户可以考虑丢掉
select * from
    (
    select user_id,count(1) as num 
    from  tianchi_mobile_recommendation_predict1
    group by user_id
    )a
order by num desc
Limit 200000
