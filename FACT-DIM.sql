SELECT DISTINCT team_name from (
SELECT first_name as team_name from cricket.clean.match_detail_clean
UNION ALL
SELECT second_name as team_name from cricket.clean.match_detail_clean
);

--populate team_dim
INSERT INTO CRICKET.CONSUMPTION.TEAM_DIM(team_name)
SELECT DISTINCT team_name FROM (
    SELECT first_team as team_name from CRICKET.CLEAN.MATCH_DETAIL_CLEAN
    UNION ALL
    SELECT second_team as team_name from CRICKET.CLEAN.MATCH_DETAIL_CLEAN
)
order by team_name;

SELECT * FROM CRICKET.CONSUMPTION.TEAM_DIM

--TEAM PLAYER
INSERT INTO CRICKET.CONSUMPTION.PLAYER_DIM(team_id, player_name)
SELECT 
    T.team_id,
    P.player_name
FROM
    CRICKET.CLEAN.PLAYER_CLEAN_TBL P 
    JOIN
    CRICKET.CONSUMPTION.TEAM_DIM T
    ON 
    P.COUNTRY = T.TEAM_NAME
GROUP BY
    T.team_id,
    P.player_name;

SELECT * FROM CRICKET.CONSUMPTION.PLAYER_DIM

--VENUE DIM
INSERT INTO CRICKET.CONSUMPTION.VENUE_DIM(venue_name,city)
SELECT
    venue,city 
    FROM (
        SELECT 
            venue,
            case when city is null then 'NA'
            else city
            end as city
        FROM
            cricket.clean.match_detail_clean
    )
GROUP BY 
    venue,
    city;

SELECT * FROM CRICKET.CONSUMPTION.VENUE_DIM

--MATCH TYPE DIM
INSERT INTO CRICKET.CONSUMPTION.MATCH_TYPE_DIM(match_type)
SELECT match_type 
FROM
CRICKET.CLEAN.MATCH_DETAIL_CLEAN 
GROUP BY MATCH_TYPE;


--DATE DIM
INSERT INTO cricket.consumption.date_dim (Date_ID, Full_Dt, Day, Month, Year, Quarter, DayOfWeek, DayOfMonth, DayOfYear, DayOfWeekName, IsWeekend)
SELECT
    ROW_NUMBER() OVER (ORDER BY Date) AS DateID,
    Date AS FullDate,
    EXTRACT(DAY FROM Date) AS Day,
    EXTRACT(MONTH FROM Date) AS Month,
    EXTRACT(YEAR FROM Date) AS Year,
    CASE WHEN EXTRACT(QUARTER FROM Date) IN (1, 2, 3, 4) THEN EXTRACT(QUARTER FROM Date) END AS Quarter,
    DAYOFWEEKISO(Date) AS DayOfWeek,
    EXTRACT(DAY FROM Date) AS DayOfMonth,
    DAYOFYEAR(Date) AS DayOfYear,
    DAYNAME(Date) AS DayOfWeekName,
    CASE When DAYNAME(Date) IN ('Sat', 'Sun') THEN 1 ELSE 0 END AS IsWeekend
FROM cricket.consumption.date_range01;