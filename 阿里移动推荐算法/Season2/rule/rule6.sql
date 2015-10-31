--根据转够率过滤掉部分用户
--转够率统计的是12-18号之前有出现的用户（不包括18号），所以18号出现的用户中有部分是没有交互信息的,这部分怎么处理？

drop table if exists tianchi_mobile_recommendation_predict1;
create table tianchi_mobile_recommendation_predict1
as select a.user_id,a.item_id
    from
        (
        select user_id,item_id from wepon_5_19_tianchi_mobile_recommendation_predict
        )a
    join
        (
        select user_id,zgl from user_zgl
        )b
    on a.user_id=b.user_id and b.zgl>0.22
;
