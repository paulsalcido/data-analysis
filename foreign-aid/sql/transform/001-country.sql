create table country (
   id uuid primary key,
   name varchar unique not null
);

insert into country
select
  uuid_generate_v4() id,
  coalesce(ea.country_name,ma.country_name) as name   
from
  (select distinct country_name from economic_aid) ea
  full outer join (select distinct country_name from military_aid) ma on
    ea.country_name = ma.country_name
;
