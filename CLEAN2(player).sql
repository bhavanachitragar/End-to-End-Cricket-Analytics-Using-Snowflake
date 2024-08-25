USE ROLE SYSADMIN;
USE SCHEMA CRICKET.CLEAN2;

-- extract players
-- version-1
select
    raw.info:match_type_number::int as match_type_number,
    raw.info:players,
    raw.info:teams
from cricket.raw.match_raw_tbl raw;

-- version-2
select
    raw.info:match_type_number::int as match_type_number,
    raw.info:players,
    raw.info:teams
from cricket.raw.match_raw_tbl raw
where match_type_number = 4670;

-- version-3
select
    raw.info:match_type_number::int as match_type_number,
    -- to find key(p.*)
    -- p.*
    p.key::text as country
from cricket.raw.match_raw_tbl raw,
lateral flatten(input => raw.info:players) p
where match_type_number = 4670;

--version-4
select
    raw.info:match_type_number::int as match_type_number,
    p.key::text as country,
    --team.*
    team.value :: text as player_name
from cricket.raw.match_raw_tbl raw,
lateral flatten(input => raw.info:players) p,
lateral flatten(input => p.value) team
where match_type_number = 4670;

-- version 5 - create table for player
create or replace table cricket.clean.player_clean_tbl as 
select 
    raw.info:match_type_number::int as match_type_number,
    p.key::text as country,
    team.value::text as player_name,
    raw.stg_file_name,
    raw.stg_file_row_number,
    raw.stg_file_hashkey,
    raw.stg_modified_ts
from cricket.raw.match_raw_tbl raw,
    lateral flatten(input => raw.info:Players) p,
    lateral flatten(input => p.value) team;

-- lets desc table
desc table cricket.clean.player_clean_tbl;

--ddl statement to check foreign key
select get_ddl('table','cricket.clean.player_clean_tbl')

-- add not null and fk relationships

alter table cricket.clean.player_clean_tbl
modify column match_type_number set not null;

alter table cricket.clean.player_clean_tbl
modify column country set not null;

alter table cricket.clean.player_clean_tbl
modify column player_name set not null;

alter table cricket.clean.match_detail_clean
add constraint pk_match_type_number primary key (match_type_number);

alter table cricket.clean.player_clean_tbl
add constraint fk_match_id
foreign key (match_type_number)
references cricket.clean.match_detail_clean (match_type_number);

