--18号16点后加购物车且当天没买的
drop table  if exists tianchi_mobile_recommendation_predict1;
create table tianchi_mobile_recommendation_predict1
as select c.user_id,c.item_id
from(
    select  a.user_id,a.item_id,b.user_id as flag
    	from 
    	(   --18号16点后加购物车的
        	select x.user_id, x.item_id
    		from
    			(
        	        --选出18号加购物车的ui对，去重，得到表a
        			select user_id,item_id
        			from
        				tianchi_lbs.tianchi_mobile_recommend_train_user
        			where
        				substr(time,1,10)="2014-12-18"
        				and behavior_type=3
        				and substr(time,12,13)>=16
        			group by user_id,item_id
    			)x
    			join
    			(
        			--选出商品子集里的商品，得到表b
        			select distinct item_id
        			from
        				tianchi_lbs.tianchi_mobile_recommend_train_item
    			)y
    			on x.item_id = y.item_id
    		where
    			y.item_id is not null
    	)a
    	left outer join
    	(   --18号购买的
        	select p.user_id, p.item_id
    		from
    			(
        	        --选出18号购买的，去重
        			select user_id,item_id
        			from
        				tianchi_lbs.tianchi_mobile_recommend_train_user
        			where
        				substr(time,1,10)="2014-12-18"
        				and behavior_type=4
        			group by user_id,item_id
    			)p
    			join
    			(
        			--选出商品子集里的商品
        			select distinct item_id
        			from
        				tianchi_lbs.tianchi_mobile_recommend_train_item
    			)q
    			on p.item_id = q.item_id
    		where
    			q.item_id is not null
    	)b
    	on a.user_id=b.user_id and a.item_id=b.item_id
	)c
where c.flag is null