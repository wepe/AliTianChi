-------
--这份文件实现：18号加购物车或收藏且当天没买
-------
--18号加购物车的且当天没买的
drop table  if exists 18jgwc_nobuy;
create table 18jgwc_nobuy
as select c.user_id,c.item_id
from(
    select  a.user_id,a.item_id,b.user_id as flag
    	from jiagwc18 a left outer join goumai18 b
    	on a.user_id=b.user_id and a.item_id=b.item_id
	)c
where c.flag is null;

--统计一下条数  333492条
select count(*) from 18jgwc_nobuy;

--18号收藏的
drop table if exists 18sc;
create table 18sc
    as select user_id,item_id
		from
			(
			select a.user_id, a.item_id
			from
				(
				--选出18号收藏的ui对
				select user_id,item_id
				from tianchi_lbs.tianchi_mobile_recommend_train_user
				where substr(time,1,10)="2014-12-18" and behavior_type=2
				group by user_id,item_id
				)a
				join
				(
				    --选出商品子集里的商品，得到表b
					select distinct item_id
					from tianchi_lbs.tianchi_mobile_recommend_train_item
				)b
				on a.item_id = b.item_id
			where
				b.item_id is not null
			) c
;

--统计一下条目  240759
select count(*) from 18sc;

--18号收藏的且当天没买的
drop table  if exists 18sc_nobuy;
create table 18sc_nobuy
as select c.user_id,c.item_id
from(
    select  a.user_id,a.item_id,b.user_id as flag
    	from 18sc a left outer join goumai18 b
    	on a.user_id=b.user_id and a.item_id=b.item_id
	)c
where c.flag is null;

--统计一下条数 230380
select count(*) from 18sc_nobuy;


--融合18jgwc_nobuy与18sc_nobuy，去重
drop table  if exists 18jgwc_sc_nobuy;
create table 18jgwc_sc_nobuy 
as select distinct user_id,item_id from
(
    select user_id,item_id from 18jgwc_nobuy 
    union all 
    select user_id,item_id from 18sc_nobuy
)b;

--统计一下条目  552401
select count(*) from 18jgwc_sc_nobuy;
