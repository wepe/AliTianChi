--官方baseline
drop table tianchi_mobile_recommendation_predict;
create table tianchi_mobile_recommendation_predict
    as select user_id,item_id
	from
	(
	    --对相同的user_id，根据num降序排序
		select user_id,item_id,row_number() over(partition by user_id order by num desc) as rank
		from
			(
			--只取商品子集里的item，join表a和表b
			select a.user_id, a.item_id, a.num
			from
				(
				--选出18号加购物车的ui对，并且多加了一个num列，对相同的ui对计数。得到表a
				select user_id,item_id,count(1) as num
				from
					tianchi_lbs.tianchi_mobile_recommend_train_user
				where
					substr(time,1,10)="2014-12-18"
					and behavior_type=3
				group by user_id,item_id
				) a
				
				join
				(
				    --选出商品子集里的商品，得到表b
					select distinct item_id
					from
						tianchi_lbs.tianchi_mobile_recommend_train_item
				) b
				on a.item_id = b.item_id
			where
				b.item_id is not null
			) c
	) d
	where rank<=1
;