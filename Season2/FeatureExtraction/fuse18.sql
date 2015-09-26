drop table if exists  temp1;
create table temp1 as select user_id,item_id,ui_b1,ui_b2,ui_b3 from 18_ui_behavior_sum;

drop table if exists  temp2;
create table temp2 as select 
a.*,
b.ui_b1h0,b.ui_b1h1,b.ui_b1h2,b.ui_b1h3,b.ui_b1h4,b.ui_b1h5,b.ui_b1h6,b.ui_b1h7,b.ui_b1h8,b.ui_b1h9,
b.ui_b1h10,b.ui_b1h11,b.ui_b1h12,b.ui_b1h13,b.ui_b1h14,b.ui_b1h15,b.ui_b1h16,b.ui_b1h17,b.ui_b1h18,b.ui_b1h19,
b.ui_b1h20,b.ui_b1h21,b.ui_b1h22,b.ui_b1h23
from temp1 a left outer join 18_ui_b1_hour_sum b
on a.user_id=b.user_id and a.item_id=b.item_id;

drop table if exists  temp3;
create table temp3 as select 
a.*,
b.ui_b2h0,b.ui_b2h1,b.ui_b2h2,b.ui_b2h3,b.ui_b2h4,b.ui_b2h5,b.ui_b2h6,b.ui_b2h7,b.ui_b2h8,b.ui_b2h9,
b.ui_b2h10,b.ui_b2h11,b.ui_b2h12,b.ui_b2h13,b.ui_b2h14,b.ui_b2h15,b.ui_b2h16,b.ui_b2h17,b.ui_b2h18,b.ui_b2h19,
b.ui_b2h20,b.ui_b2h21,b.ui_b2h22,b.ui_b2h23
from temp2 a left outer join 18_ui_b2_hour_sum b
on a.user_id=b.user_id and a.item_id=b.item_id;

drop table if exists  temp4;
create table temp4 as select 
a.*,
b.ui_b3h0,b.ui_b3h1,b.ui_b3h2,b.ui_b3h3,b.ui_b3h4,b.ui_b3h5,b.ui_b3h6,b.ui_b3h7,b.ui_b3h8,b.ui_b3h9,
b.ui_b3h10,b.ui_b3h11,b.ui_b3h12,b.ui_b3h13,b.ui_b3h14,b.ui_b3h15,b.ui_b3h16,b.ui_b3h17,b.ui_b3h18,b.ui_b3h19,
b.ui_b3h20,b.ui_b3h21,b.ui_b3h22,b.ui_b3h23
from temp3 a left outer join 18_ui_b3_hour_sum b
on a.user_id=b.user_id and a.item_id=b.item_id;

drop table if exists  temp5;
create table temp5 as select 
a.*,b.ua_b1,b.ua_b2,b.ua_b3
from temp4 a left outer join 18_ua_behavior_sum b
on a.user_id=b.user_id;

drop table if exists  temp6;
create table temp6 as select 
a.*,
b.b1h0,b.b1h1,b.b1h2,b.b1h3,b.b1h4,b.b1h5,b.b1h6,b.b1h7,b.b1h8,b.b1h9,
b.b1h10,b.b1h11,b.b1h12,b.b1h13,b.b1h14,b.b1h15,b.b1h16,b.b1h17,b.b1h18,b.b1h19,
b.b1h20,b.b1h21,b.b1h22,b.b1h23
from temp5 a left outer join 18_ua_b1_hour_sum b
on a.user_id=b.user_id;

drop table if exists  temp7;
create table temp7 as select 
a.*,
b.b2h0,b.b2h1,b.b2h2,b.b2h3,b.b2h4,b.b2h5,b.b2h6,b.b2h7,b.b2h8,b.b2h9,
b.b2h10,b.b2h11,b.b2h12,b.b2h13,b.b2h14,b.b2h15,b.b2h16,b.b2h17,b.b2h18,b.b2h19,
b.b2h20,b.b2h21,b.b2h22,b.b2h23
from temp6 a left outer join 18_ua_b2_hour_sum b
on a.user_id=b.user_id;

drop table if exists  temp8;
create table temp8 as select 
a.*,
b.b3h0,b.b3h1,b.b3h2,b.b3h3,b.b3h4,b.b3h5,b.b3h6,b.b3h7,b.b3h8,b.b3h9,
b.b3h10,b.b3h11,b.b3h12,b.b3h13,b.b3h14,b.b3h15,b.b3h16,b.b3h17,b.b3h18,b.b3h19,
b.b3h20,b.b3h21,b.b3h22,b.b3h23
from temp7 a left outer join 18_ua_b3_hour_sum b
on a.user_id=b.user_id;

drop table if exists  temp9;
create table temp9 as select 
a.*,
b.b4h0,b.b4h1,b.b4h2,b.b4h3,b.b4h4,b.b4h5,b.b4h6,b.b4h7,b.b4h8,b.b4h9,
b.b4h10,b.b4h11,b.b4h12,b.b4h13,b.b4h14,b.b4h15,b.b4h16,b.b4h17,b.b4h18,b.b4h19,
b.b4h20,b.b4h21,b.b4h22,b.b4h23
from temp8 a left outer join 18_ua_b4_hour_sum b
on a.user_id=b.user_id;

drop table if exists  temp10;
create table temp10 as select 
a.*,b.u_b1,b.u_b2,b.u_b3,b.u_b4
from temp9 a left outer join 18u_ever_behavior_sum b
on a.user_id=b.user_id;

drop table if exists  temp11;
create table temp11 as select 
a.*,b.i_b1,b.i_b2,b.i_b3,b.i_b4
from temp10 a left outer join 18i_ever_behavior_sum b
on a.item_id=b.item_id;


