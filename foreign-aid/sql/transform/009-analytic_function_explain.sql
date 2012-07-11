explain analyze select
    c.name as country,
    p.name as program,
    aa.year,
    aa.amount
from
    (select
        aa.country,
        aa.program,
        aa.year,
        aa.amount,
        aa.total_country_program,
        rank() over (
            partition by aa.country
            order by aa.total_country_program desc
        ) as total_amount_rank
    from
        (select
            country,
            program,
            year,
            amount,
            sum(amount) over (
                partition by country,program
            ) total_country_program
        from
            aid_amount) aa) aa
    join country c on
        c.id = aa.country
    join program p on
        p.id = aa.program
where total_amount_rank = 1
order by country,program,year;
