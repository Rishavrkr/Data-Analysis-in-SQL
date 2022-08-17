select * from project..data1

select * from project..data2

--Number of rows in our dataset

select count(*) 
from project..data1

select count(*) 
from project..data2

--Dataset for Jharkhand and Bihar

select * 
from project..data1 
where state in ('Jharkhand' ,'Bihar')

--Total Population of India

select sum(population) as Population 
from project..data2

--Avg growth 

select state,avg(growth)*100 avg_growth 
from project..data1 group by state;

--Avg sex ratio

select state,round(avg(sex_ratio),0) avg_sex_ratio 
from project..data1 
group by state 
order by avg_sex_ratio desc;

--Avg literacy rate

select state,round(avg(literacy),0) avg_literacy_ratio 
from project..data1 
group by state having round(avg(literacy),0)>90 
order by avg_literacy_ratio desc;

--Top 3 state showing highest growth ratio

select Top 3 state,avg(growth)*100 avg_growth 
from project..data1 
group by state 
order by avg_growth desc;

--Bottom 3 state showing lowest sex ratio

select top 3 state,round(avg(sex_ratio),0) avg_sex_ratio
from project..data1 
group by state order by
avg_sex_ratio asc;

--Top and bottom 3 states in literacy

drop table if exists #topstates;
create table #topstates
( state nvarchar(255),
  topstate float
  )

insert into #topstates
select state,round(avg(literacy),0) avg_literacy_ratio 
from project..data1 
group by state order by avg_literacy_ratio desc;

select top 3 * 
from #topstates 
order by #topstates.topstate desc;

drop table if exists #bottomstates;
create table #bottomstates
( state nvarchar(255),
  bottomstate float
  )

insert into #bottomstates
select state,round(avg(literacy),0) avg_literacy_ratio 
from project..data1 
group by state order by avg_literacy_ratio desc;

select top 3 * 
from #bottomstates 
order by #bottomstates.bottomstate asc;

--Union opertor

select * from (
select top 3 * from #topstates 
order by #topstates.topstate desc) a
union
select * from (
select top 3 * 
from #bottomstates 
order by #bottomstates.bottomstate asc) b;

--Joining both table

select a.district,a.state,a.sex_ratio/1000 sex_ratio,b.population 
from project..data1 a 
inner join project..data2 b 
on a.district=b.district;

--Top 3 districts from each state with highest literacy rate

select a.* from
(select district,state,literacy,rank() 
over(partition by state order by literacy desc) rnk 
from project..data1) a
where a.rnk in (1,2,3) 
order by state