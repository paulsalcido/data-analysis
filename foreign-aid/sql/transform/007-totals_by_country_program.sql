select
    c.name as country,
    p.name as program,
    sum(aa.amount) as amount
from
    aid_amount aa
    join country c on
        c.id = aa.country
    join program p on
        p.id = aa.program
group by
    c.name, p.name
