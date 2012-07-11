select
    c.name as country,
    p.name as program,
    aa.year,
    aa.amount
from
    (select
        country,
        program,
        sum(amount) as sum_amount
    from
        aid_amount
    group by
        country,
        program) p1 join
    (select
        country,
        max(sum_amount) as max_sum_amount
    from
        (select
            country,
            program,
            sum(amount) as sum_amount
        from
            aid_amount
        group by
            country,
            program) p3
    group by
        country) p2 on p1.country = p2.country and p1.sum_amount = p2.max_sum_amount
    join aid_amount aa on
        aa.country = p1.country and aa.program = p1.program
    join country c on
        aa.country = c.id
    join program p on
        aa.program = p.id
order by
    c.name,
    p.name,
    aa.year
