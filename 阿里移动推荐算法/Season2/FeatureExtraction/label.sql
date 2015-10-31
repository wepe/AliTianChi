drop table 18buylabel;
create table 18buylabel
as select user_id,item_id, count(*) as label
from 18buy group by user_id,item_id;

create table  datalabel17
as select a.*,b.label
from data17 a left outer join 18buylabel b
on a.user_id=b.user_id and a.item_id=b.item_id;