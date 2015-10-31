
--**********************************************
--对averaging模型
--**********************************************************
--对多个模型的结果取平均
drop table  if exists wepon_17validation;
create table wepon_17validation
as select user_id,item_id,label,sum(prediction_score) as pred,sum(0+0) as partition_column
from wepon_17s
group by user_id,item_id,label;


--select count(*) from wepon_17s;
--select count(*) from wepon_17validation;



drop table if exists wepon_17validation1;
create table wepon_17validation1
as select user_id,item_id,label,pred,row_number() over(partition by partition_column order by pred desc) as rank from wepon_17validation;

select count(*) from wepon_17validation1 where rank<=200000 and label=1;










--*****************************************
--对单模型
--*****************************************************



-- drop table if exists tmp;
-- create table tmp
-- as select a.*,row_number() over(partition by partition_column order by prediction_score desc) as rank 
-- from
-- (
-- select user_id,item_id,label,prediction_result,prediction_score,sum(0+0) as partition_column 
-- from wepon_17_rf64 group by user_id,item_id,label,prediction_result,prediction_score
-- )a;

-- --排在前面的n个里预测对的正样本有多少
-- select count(*) from tmp where rank<=85274 and label=1 and  prediction_result=1;

-- select count(*) from tmp;

-- --预测为正样本的有多少个
-- select count(*) from tmp where prediction_result=1;


-- --预测对的正样本有多少，正样本原本有15218个
-- select count(*) from tmp where label=1 and prediction_result=1;


-- --设置阈值，看看预测对的正样本有多少
-- select count(*) from tmp where label=1 and prediction_score>0.4;

-- --大于该阈值的有多少个
-- select count(*) from tmp where prediction_score>0.4;


-- drop table if exists tmp;
-- create table tmp
-- as select a.*,row_number() over(partition by partition_column order by prediction_score desc) as rank 
-- from
-- (
-- select user_id,item_id,label,prediction_result,prediction_score,sum(0+0) as partition_column 
-- from wepon_17_gbdt200 group by user_id,item_id,label,prediction_result,prediction_score
-- )a;

-- --排在前面的n个里预测对的正样本有多少
-- select count(*) from tmp where rank<=200000 and label=1 and  prediction_result=1;


-- drop table if exists tmp;
-- create table tmp
-- as select a.*,row_number() over(partition by partition_column order by prediction_score desc) as rank 
-- from
-- (
-- select user_id,item_id,label,prediction_result,prediction_score,sum(0+0) as partition_column 
-- from wepon_17_gbdt800 group by user_id,item_id,label,prediction_result,prediction_score
-- )a;

-- --排在前面的n个里预测对的正样本有多少
-- select count(*) from tmp where rank<=200000 and label=1 and  prediction_result=1;



-- drop table if exists tmp;
-- create table tmp
-- as select a.*,row_number() over(partition by partition_column order by prediction_score desc) as rank 
-- from
-- (
-- select user_id,item_id,label,prediction_result,prediction_score,sum(0+0) as partition_column 
-- from wepon_17_rf448 group by user_id,item_id,label,prediction_result,prediction_score
-- )a;

-- --排在前面的n个里预测对的正样本有多少
-- select count(*) from tmp where rank<=200000 and label=1 and  prediction_result=1;

-- drop table if exists tmp;
-- create table tmp
-- as select a.*,row_number() over(partition by partition_column order by prediction_score desc) as rank 
-- from
-- (
-- select user_id,item_id,label,prediction_result,prediction_score,sum(0+0) as partition_column 
-- from wepon_17_rf320 group by user_id,item_id,label,prediction_result,prediction_score
-- )a;

-- --排在前面的n个里预测对的正样本有多少
-- select count(*) from tmp where rank<=200000 and label=1 and  prediction_result=1;