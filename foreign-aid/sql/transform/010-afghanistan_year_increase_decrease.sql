select
    c.name as country,
    p.name as program,
    aa.year,
    aa.amount,
    (aa.amount - lag(aa.amount) over (
        partition by aa.program
        order by aa.year
    ) ) as year_over_year,
    sum(aa.amount) over (
        partition by aa.program
        order by aa.year)
        as running_total
from
    aid_amount aa
    join country c on 
        aa.country = c.id and c.name = 'Afghanistan'
    join program p on
        aa.program = p.id
order by
    c.name,p.name,aa.year;
