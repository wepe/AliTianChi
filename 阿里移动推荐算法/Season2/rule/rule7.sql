--18号加购物车且该用户在18号买过东西
drop table  if exists tianchi_mobile_recommendation_predict;
create table tianchi_mobile_recommendation_predict
as select distinct c.user_id,c.item_id
from(
    select  a.user_id,a.item_id,b.user_id as flag
    	from jiagwc18 a left outer join goumai18 b
    	on a.user_id=b.user_id
	)c
where c.flag is not null