--统计该月里每个小时买的子集商品总数
drop table if exists hourbuy;
create table hourbuy
as select a.hour,count(1) as num
from
    (   
        --选出被购买的item_id及购买时间
        select item_id,substr(time,12,2) as hour 
        from tianchi_lbs.tianchi_mobile_recommend_train_user
        where behavior_type=4
    )a
    join 
    (
        --选出商品子集里的商品
        select distinct item_id
        from tianchi_lbs.tianchi_mobile_recommend_train_item
    )b
    on a.item_id=b.item_id
    group by a.hour