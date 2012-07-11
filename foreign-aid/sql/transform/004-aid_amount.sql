create table aid_amount(
   id uuid primary key,
   country uuid references country(id) not null,
   program uuid references program(id) not null,
   aid_type uuid references aid_type(id) not null,
   year date not null,
   amount float not null,
   unique(country,program,aid_type,year)
);
