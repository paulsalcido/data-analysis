create table aid_type (
    id uuid primary key,
    name varchar unique not null
);

insert into aid_type values (uuid_generate_v4(),'economic');
insert into aid_type values (uuid_generate_v4(),'military');
