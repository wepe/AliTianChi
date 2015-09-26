--继续处理everbuy_jgwc1所生成的everbuy文件,以生成格式为“user_id,jgwc,gm,18jgwc”的表
create table everbuy_18jgwc
as select a.user_id,a.jgwc,b.gm,a.18jgwc
from
(
select user_id,num as jgwc,18num as 18jgwc
from everbuy
where behavior_type=3
)a
join
(
select user_id,num as gm,18num as 18jgwc
from everbuy
where behavior_type=4
)b
on a.user_id=b.user_id