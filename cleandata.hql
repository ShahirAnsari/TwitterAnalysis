
CREATE VIEW IF NOT EXISTS Ptweets_simple AS
SELECT
  id,
  cast ( from_unixtime( unix_timestamp(concat( '2016 ', substring(created_at,5,15)), 'yyyy MMM dd hh:mm:ss')) as timestamp) ts,
  text,
  user.time_zone 
FROM PMytweets_raw
;

CREATE VIEW IF NOT EXISTS Ptweets_clean AS
SELECT
  id,
  ts,
  text,
  m.country 
 FROM Ptweets_simple t LEFT OUTER JOIN Ptime_zone_map m ON t.time_zone = m.time_zone;

 

create view IF NOT EXISTS Pl1 as select id, words from PMytweets_raw lateral view explode(sentences(lower(text))) dummy as words;
create view Pl2 as select id, word from Pl1 lateral view explode( words ) dummy as word ;
