
create view IF NOT EXISTS Pl3 as select 
    id, 
    Pl2.word, 
    case d.polarity 
      when  'negative' then -1
      when 'positive' then 1 
      else 0 end as polarity 
 from Pl2 left outer join Pdictionary d on Pl2.word = d.word;
 
 create table IF NOT EXISTS Ptweets_sentiment as select 
  id, 
  case 
    when sum( polarity ) > 0 then 'positive' 
    when sum( polarity ) < 0 then 'negative'  
    else 'neutral' end as sentiment 
 from Pl3 group by id;
 
 

CREATE TABLE IF NOT EXISTS Ptweetsbi 
AS
SELECT 
  t.*,
  s.sentiment 
FROM Ptweets_clean t LEFT OUTER JOIN Ptweets_sentiment s on t.id = s.id;

-- data with tweet counts.....
CREATE TABLE IF NOT EXISTS Ptweetsbiaggr 
AS
SELECT 
  country,sentiment, count(sentiment) as tweet_count 
FROM Ptweetsbi
group by country,sentiment;


CREATE VIEW IF NOT EXISTS POSVE as select country,tweet_count as positive_response from Ptweetsbiaggr where sentiment='positive';
CREATE VIEW IF NOT EXISTS NEGVE as select country,tweet_count as negative_response from Ptweetsbiaggr where sentiment='negative';
CREATE VIEW IF NOT EXISTS NEUTRL as select country,tweet_count as neutral_response from Ptweetsbiaggr where sentiment='neutral';
CREATE TABLE IF NOT EXISTS Ptweetcompare as select POSVE.*,NEGVE.negative_response as negative_response,NEUTRL.neutral_response as neutral_response from POSVE join NEGVE on POSVE.country= NEGVE.country join NEUTRL on NEGVE.country=NEUTRL.country;
 
