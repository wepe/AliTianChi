--针对商品子集，18号加购物车的
drop table if exists JiaGWC18;
create table JiaGWC18
as select a.user_id, a.item_id
		from
			(
    	        --选出18号加购物车的ui对，去重，得到表a
    			select user_id,item_id
    			from
    				tianchi_lbs.tianchi_mobile_recommend_train_user
    			where
    				substr(time,1,10)="2014-12-18"
    				and behavior_type=3
    			group by user_id,item_id
			)a
			join
			(
    			--选出商品子集里的商品，得到表b
    			select distinct item_id
    			from
    				tianchi_lbs.tianchi_mobile_recommend_train_item
			)b
			on a.item_id = b.item_id
		where
			b.item_id is not null