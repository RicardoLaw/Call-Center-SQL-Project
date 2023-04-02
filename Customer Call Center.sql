-- -----------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------- PREPARE PHASE: UNDERTAND, COLLECT AND ORGANIZE DATA  ---------------------
-- -----------------------------------------------------------------------------------------------------------------------

-- We should create a database to load our data into

CREATE DATABASE call_center;

-- Use the database which was just created
USE call_center;

-- Create a table to match the attributes in the dataset

CREATE TABLE customers(ID VARCHAR(50),
name CHAR (50),
sentiment CHAR (20),
-- csat_score was giving an error while importing the dataset via table data import wizard. So I changed the datatype from an INTEGER to CHAR <- This resolved the issue
csat_score CHAR(50),
call_timestamp CHAR (10),
reason CHAR (20),
city CHAR (20),
state CHAR (20),
channel CHAR (20),
response_time CHAR (20),
call_duration_minutes INT,
call_center CHAR (20));

-- Import data through the table data import wizard


-- -----------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------- PROCESS: EXPLORING / CLEANING DATASET  -------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------

-- Ensure data was imported correctly
SELECT * FROM customers;



-- To see the number of rows
SELECT COUNT(*) AS num_rows FROM customers;
-- To see the number of columns
SELECT COUNT(*) AS num_cols FROM information_schema.columns WHERE table_name = 'customers' ;



-- Converting String to date format
   
SET SQL_SAFE_UPDATES = 0;
   
UPDATE customers SET call_timestamp = str_to_date(call_timestamp, "%m/%d/%Y");

-- A quick scan of the table revealed empty entries (Only from the csat_score) were entered as ''
    -- I assigned empty entries as NULL
   
UPDATE customers SET csat_score = NULL WHERE csat_score = '' OR 0;

SET SQL_SAFE_UPDATES = 1;




-- -----------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------- ANALYZE: AGGREGATION / ANALYSIS  -------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------

-- Querying the distinct data from all of the columns  
    -- gives us a better understanding of the dataset at hand

SELECT DISTINCT sentiment FROM customers;
SELECT DISTINCT reason FROM customers;  
SELECT DISTINCT city FROM customers;
SELECT DISTINCT state FROM customers;
SELECT DISTINCT channel FROM customers;
SELECT DISTINCT call_center FROM customers;


-- Displays the sentiment of customers satisfaction as a percentage
   
SELECT sentiment, count(*) AS total, ROUND((COUNT(*) / (SELECT COUNT(*) FROM customers)) * 100, 2) AS percentage
FROM customers
GROUP BY 1
ORDER BY percentage DESC ;


-- Displays the reasons customers contact the call center as a percentage
   
SELECT reason, count(*) AS total, ROUND((COUNT(*) / (SELECT COUNT(*) FROM customers)) * 100, 2) AS percentage
FROM customers
GROUP BY 1
ORDER BY percentage DESC ;


-- Displays the state customers are reaching out from as a percentage
   
SELECT state, count(*) AS total, ROUND((COUNT(*) / (SELECT COUNT(*) FROM customers)) * 100, 2) AS percentage
FROM customers
GROUP BY 1
ORDER BY percentage DESC ;


-- Displays the call center traffic as a percentage
   
SELECT call_center, count(*) AS total, ROUND((COUNT(*) / (SELECT COUNT(*) FROM customers)) * 100, 2) AS percentage
FROM customers
GROUP BY 1
ORDER BY percentage DESC ;


-- Displays the minimum , maximum and average of the csat_score attribute
   
SELECT MIN(csat_score) AS min_score, MAX(csat_score) AS max_score, ROUND(AVG(csat_score),2) AS avg_score
FROM customers WHERE csat_score IS NOT NULL ;


-- Counting the number of each channel
   
SELECT channel, COUNT(channel) AS channel_count FROM customers GROUP BY channel


-- Displays the most and least common method of contact from customers for each call center
   
SELECT call_center, COUNT(channel), MIN(channel), MAX(channel) FROM customers GROUP BY call_center


-- Average call time based on customers satisfaction
   
SELECT sentiment, AVG(call_duration_minutes) FROM customers GROUP BY 1 ORDER BY 2 DESC;


-- Listing the total of each sentiment based on the state
 SELECT state, sentiment , COUNT(*) AS total FROM customers GROUP BY 1,2 ORDER BY 1,3 DESC;
