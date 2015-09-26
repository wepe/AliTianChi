--18号加购物车且当天没买的
drop table  if exists tianchi_mobile_recommendation_predict;
create table tianchi_mobile_recommendation_predict
as select c.user_id,c.item_id
from(
    select  a.user_id,a.item_id,b.user_id as flag
    	from jiagwc18 a left outer join goumai18 b
    	on a.user_id=b.user_id and a.item_id=b.item_id
	)c
where c.flag is null