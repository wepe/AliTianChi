--对多个模型的结果取平均
drop table  if exists wepon_18tmp;
create table wepon_18tmp
as select user_id,item_id,sum(prediction_score) as pred,sum(0+0) as partition_column
from wepon_18pred_1_11
group by user_id,item_id;

--select count(*) from wepon_18pred_1_11;
--select count(*) from wepon_18tmp;

drop table if exists wepon_18tmp1;
create table wepon_18tmp1
as select user_id,item_id,pred,row_number() over(partition by partition_column order by pred desc) as rank from wepon_18tmp;


drop table if exists tianchi_mobile_recommendation_predict;
create table tianchi_mobile_recommendation_predict
as select user_id,item_id from  wepon_18tmp1 where rank<=100000;

select count(*) from tianchi_mobile_recommendation_predict;

-- select * from  wepon_18tmp1 where rank<=100000
-- order by pred
-- limit 100000000


--验证集上的效果
-- drop table  if exists wepon_17tmp;
-- create table wepon_17tmp
-- as select user_id,item_id,label,sum(prediction_score) as pred,sum(0+0) as partition_column
-- from wepon_17s
-- group by user_id,item_id,label;



-- drop table if exists wepon_17tmp1;
-- create table wepon_17tmp1
-- as select user_id,item_id,label,pred,row_number() over(partition by partition_column order by pred desc) as rank from wepon_17tmp;

-- select count(*) from wepon_17tmp1 where rank<=85274 and label=1
