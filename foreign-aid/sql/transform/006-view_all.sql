select
    c.name as country,
    p.name as program,
    atp.name as aid_type,
    to_char(aa.year,'YYYY') as year,
    aa.amount as amount
from
    aid_amount aa
    join country c on
        c.id = aa.country
    join program p on
        p.id = aa.program
    join aid_type atp on
        atp.id = aa.aid_type
order by
    c.name,
    p.name,
    atp.name,
    aa.year;
        
