create table program (
   id uuid primary key,
   name varchar unique not null
);

insert into program
select
  uuid_generate_v4() id,
  coalesce(ea.program_name,ma.program_name) as name   
from
  (select distinct program_name from economic_aid) ea
  full outer join (select distinct program_name from military_aid) ma on
    ea.program_name = ma.program_name
;
