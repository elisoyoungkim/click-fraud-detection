create table newFeatures as(
select t1.partnerid, t1.countid, t2.distinct_iplong, t3.distinct_referer, t4.std_per_hrs, t5.std_per_min, t6.std_iplong, t7.avg_min_AgIpCntrRef, 
	   t8.night_avg_min_referer, t9.avg_min_agent, t10.avg_min_referer, t11.avg_min_RefAgCntr, t12.night_avg_min_RefAgCntrIp
from(select partnerid, countid from testSet) t1, 
	(select partnerid, count(x.countid) as distinct_iplong
	 from(select partnerid, count(id) as countid from testSet group by partnerid, iplong) x 
	 group by partnerid) t2,
	(select partnerid, count(x.countid) as distinct_referer
     from(select partnerid, count(id) as countid from testSet group by partnerid, referer) x 
	 group by partnerid) t3,
	(select partnerid, std(x.countid) as std_per_hrs
	 from(select partnerid, count(id) as countid from testSet group by partnerid, date(timeat), hour(timeat)) x
	 group by partnerid) t4,
	(select partnerid, std(x.countid) as std_per_min
	 from(select partnerid, count(id) as countid from testSet group by partnerid, date(timeat), hour(timeat), minute(timeat)) x 
	 group by partnerid) t5,
	(select partnerid, std(x.countid) as std_iplong
 	 from(select partnerid, count(id) as countid from testSet group by partnerid, iplong) x 
 	 group by partnerid) t6,
	(select partnerid, avg(x.countid) as avg_min_AgIpCntrRef 
	 from(select partnerid, count(id) as countid from testSet group by partnerid, date(timeat), hour(timeat), minute(timeat), referer, agent, cntr, iplong) x 
	 group by partnerid) t7,
	(select partnerid, avg(x.countid) as night_avg_min_referer 
	 from(select partnerid, count(id) as countid from nZoneTest group by partnerid, date(timeat), hour(timeat), minute(timeat)) x 
	 group by partnerid) t8,
	(select partnerid, avg(x.countid) as avg_min_agent 
	 from(select partnerid, count(id) as countid from testSet group by partnerid, date(timeat), hour(timeat), minute(timeat), agent) x 
	 group by partnerid) t9,
	(select partnerid, avg(x.countid) as avg_min_referer 
	 from(select partnerid, count(id) as countid from testSet group by partnerid, date(timeat), hour(timeat), minute(timeat), referer) x 
	 group by partnerid) t10,
	(select partnerid, avg(x.countid) as avg_min_RefAgCntr 
	 from(select partnerid, count(id) as countid from testSet group by partnerid, date(timeat), hour(timeat), minute(timeat), referer, agent, cntr) x 
	 group by partnerid) t11,
	(select partnerid, avg(x.countid) as night_avg_min_RefAgCntrIp 
	 from(select partnerid, count(id) as countid from nZoneTest group by partnerid, date(timeat), hour(timeat), minute(timeat), referer, agent, cntr, iplong) x 
	 group by partnerid) t12
where t1.partnerid = t2.partnerid and t1.partnerid = t3.partnerid and t1.partnerid = t4.partnerid and t1.partnerid = t5.partnerid and t1.partnerid = t6.partnerid and 
	  t1.partnerid = t7.partnerid and t1.partnerid = t8.partnerid and t1.partnerid = t9.partnerid and t1.partnerid = t10.partnerid and t1.partnerid = t11.partnerid and 
	  t1.partnerid = t12.partnerid
group by partnerid)