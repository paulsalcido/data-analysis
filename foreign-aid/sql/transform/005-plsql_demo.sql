create or replace function fill_amount_table() returns void as
/* fill_amount_table
 * This fills the table aid_amount using the data from the loaded tables
 * for economic aid and military aid using the information_schema table
 * definitions as the table reference.
 */
$BODY$
declare
    i information_schema.columns%rowtype;
    j varchar;
    k aid_amount%rowtype;
begin
/* Loop over the columns for the military and economic aid tables */
for i in select 
        * 
    from 
        information_schema.columns 
    where 
        table_catalog = 'foreign_aid' 
        and table_schema='public' 
        and table_name in ('economic_aid','military_aid')
        and column_name like 'fy%' loop
    /* Set the aid_type based on the table name for the current column */
    if i.table_name = 'economic_aid' then
        j := 'economic';
    else
        j := 'military';
    end if;
    /* Create a new table record/update current tables based on the
     * data in the loaded tables */
    for k in execute 'select 
            uuid_generate_v4() as id,
            c.id as country,
            p.id as program,
            atp.id as aid_type,
            regexp_replace(''' || i.column_name || ''',''[^\d]'','''',''g'') || ''/01/01'' as year,
            regexp_replace(ea.' || i.column_name || ',''[^\d]'','''',''g'') as amount
        from
            ' || j || '_aid ea
            join program p on ea.program_name = p.name
            join country c on ea.country_name = c.name
            join aid_type atp on atp.name = ''' || j || '''
        where
            ea.' || i.column_name || ' is not null' loop
        RAISE NOTICE '(%,%,%,%,%,%)',k.id,k.country,k.program,k.aid_type,k.year,k.amount;
        /* Update or insert if the record does not exist (this 'solves'
         * the problem with the transitional quarter in 1976 */
        update aid_amount 
            set amount = amount + k.amount 
        where 
            program = k.program
            and country = k.country
            and aid_type = k.aid_type
            and year = k.year;
        if found then
            raise notice 'Updated existing';
        else
            insert into aid_amount values (k.*);
            raise notice 'Inserted new';
        end if;
    end loop;
end loop;
end;
$BODY$ language 'plpgsql'

