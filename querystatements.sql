select tripduration, avg(x.countid)
from(select tripduration, count(tripduration) as countid from jan group by starttime, date(timeat), hour(timeat)) x 

insert ignore into jan(select * from feb);
insert ignore into jan(select * from mar);
insert ignore into apr(select * from may);
insert ignore into june(select * from july);
insert ignore into aug(select * from sep);
insert ignore into apr(select * from jun);
insert ignore into apr(select * from aug);
insert ignore into jan(select * from apr);

ALTER TABLE apr MODIFY starttime datetime;

select partnerid, iplong, max(x.countx), avg(x.countx)
from
	(select partnerid, iplong, count(id) as countx from trainingFraud
	 group by partnerid, iplong) x
group by partnerid;