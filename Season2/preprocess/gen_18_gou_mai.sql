--针对商品子集，18号购买的
drop table if exists GouMai18;
create table GouMai18
as select d.user_id, d.item_id
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
			)d
			join
			(
    			--选出商品子集里的商品
    			select distinct item_id
    			from
    				tianchi_lbs.tianchi_mobile_recommend_train_item
			)e
			on d.item_id = e.item_id
		where
			e.item_id is not null