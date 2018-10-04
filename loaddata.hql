
CREATE EXTERNAL TABLE IF NOT EXISTS PMytweets_raw (
   id BIGINT,
   created_at STRING,
   source STRING,
   favorited BOOLEAN,
   retweet_count INT,
   retweeted_status STRUCT<
      text:STRING,
      user:STRUCT<screen_name:STRING,name:STRING>>,
   entities STRUCT<
      urls:ARRAY<STRUCT<expanded_url:STRING>>,
      user_mentions:ARRAY<STRUCT<screen_name:STRING,name:STRING>>,
      hashtags:ARRAY<STRUCT<text:STRING>>>,
   text STRING,
   user STRUCT<
      screen_name:STRING,
      name:STRING,
      friends_count:INT,
      followers_count:INT,
      statuses_count:INT,
      verified:BOOLEAN,
      utc_offset:INT,
      time_zone:STRING>,
   in_reply_to_screen_name STRING
) 
ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe'
LOCATION '/user/cloudera/data/tweets_raw';

load data inpath '/user/cloudera/data/tweets_raw/' INTO TABLE PMytweets_raw;

-- create sentiment dictionary
CREATE EXTERNAL TABLE IF NOT EXISTS Pdictionary (
    type string,
    length int,
    word string,
    pos string,
    stemmed string,
    polarity string
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' 
STORED AS TEXTFILE
LOCATION '/user/cloudera/data/dictionary';

load data inpath '/user/cloudera/data/dictionary/dictionary.tsv' INTO TABLE Pdictionary;

CREATE EXTERNAL TABLE IF NOT EXISTS Ptime_zone_map (
    time_zone string,
    country string
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' 
STORED AS TEXTFILE
LOCATION '/user/cloudera/data/time_zone_map';


load data inpath '/user/cloudera/data/time_zone_map/time_zone_map.tsv' INTO TABLE Ptime_zone_map;
