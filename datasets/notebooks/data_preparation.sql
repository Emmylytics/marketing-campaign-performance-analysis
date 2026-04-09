-- =====================================
-- Drop or recreate table if it exists
-- =====================================
DROP TABLE IF EXISTS campaign;
-- =====================================================
-- Create the campaign table with appropriate data types
-- =====================================================
CREATE TABLE campaign(
	Campaign_ID INT PRIMARY KEY,
	Company VARCHAR(255),
	Campaign_Type VARCHAR(50),
	Target_Audience TEXT,
	Duration VARCHAR(20),
	Channel_Used VARCHAR(50),
	Conversion_Rate NUMERIC(5,2),
	Acquisition_Cost TEXT,
	ROI NUMERIC(6,2),
	Location TEXT,
	Language TEXT,
	Clicks INT,
	Impressions INT,
	Engagement_Score INT,
	Customer_Segment VARCHAR(100),
	Date DATE
);

-- ==========================================
-- Import CSV data into the campaign table
-- ==========================================
COPY campaign
FROM 'C:\Program Files\PostgreSQL\17\data\campaign.csv'
DELIMITER ','
CSV HEADER;

-- =====================================
-- Quick data preview (first 10 rows)
-- =====================================
SELECT *
FROM campaign
LIMIT 10;

-- =====================================
-- Count total rows in the dataset
-- =====================================
SELECT COUNT(*)
FROM campaign;

-- =======================================
-- Inspect column names and data types
-- =======================================
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name ='campaign';

-- ========================================================
-- Generates dynamic SQL formula to count nulls per column
-- ========================================================
SELECT
'SUM(CASE WHEN ' || column_name || ' IS NULL THEN 1 ELSE 0 END) AS'
|| column_name || '_nulls,'
FROM information_schema.columns
WHERE table_name ='campaign';

-- =======================================
-- Check nulls explicitly for all columns
-- =======================================
SELECT
	SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS date_nulls,
	SUM(CASE WHEN conversion_rate IS NULL THEN 1 ELSE 0 END) AS conversion_rate_nulls,
	SUM(CASE WHEN acquisition_cost IS NULL THEN 1 ELSE 0 END) AS acquisition_cost_nulls,
	SUM(CASE WHEN roi IS NULL THEN 1 ELSE 0 END) AS roi_nulls,
	SUM(CASE WHEN clicks IS NULL THEN 1 ELSE 0 END) AS clicks_nulls,
	SUM(CASE WHEN impressions IS NULL THEN 1 ELSE 0 END) AS impressions_nulls,
	SUM(CASE WHEN engagement_score IS NULL THEN 1 ELSE 0 END) AS engagement_score_nulls,
	SUM(CASE WHEN campaign_id IS NULL THEN 1 ELSE 0 END) AS campaign_id_nulls,
	SUM(CASE WHEN customer_segment IS NULL THEN 1 ELSE 0 END) AS customer_segment_nulls,
	SUM(CASE WHEN company IS NULL THEN 1 ELSE 0 END) AS company_nulls,
	SUM(CASE WHEN campaign_type IS NULL THEN 1 ELSE 0 END) AS campaign_type_nulls,
	SUM(CASE WHEN target_audience IS NULL THEN 1 ELSE 0 END) AS target_audience_nulls,
	SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_nulls,
	SUM(CASE WHEN channel_used IS NULL THEN 1 ELSE 0 END) AS channel_used_nulls,
	SUM(CASE WHEN location IS NULL THEN 1 ELSE 0 END) AS location_nulls,
	SUM(CASE WHEN language IS NULL THEN 1 ELSE 0 END) AS language_nulls
FROM campaign;

-- =======================================
-- Check for duplicates using ROW_NUMBER
-- =======================================
WITH duplicates AS 
	(
	SELECT *, 
	ROW_NUMBER() OVER(PARTITION BY campaign_id, company, campaign_type, 
	target_audience, duration, channel_used, conversion_rate, acquisition_cost, 
	roi, location, language, clicks, impressions, engagement_score, customer_segment, date) AS row_num
	FROM campaign
	)
SELECT *
FROM duplicates
WHERE row_num >1;

-- ==========================================
-- Inspect acquisition_cost before cleaning
-- ==========================================
SELECT 
	acquisition_cost
FROM campaign
LIMIT 10;

-- ==============================================
-- Convert acquisition_cost from text to numeric
-- ==============================================
ALTER TABLE campaign
ALTER COLUMN acquisition_cost TYPE NUMERIC 
USING REPLACE(REPLACE(acquisition_cost, '$', ''), ',', '')::NUMERIC;

-- =======================================
-- Inspect duration col before cleaning
-- =======================================
SELECT 
	duration
FROM campaign
LIMIT 10;

-- =======================================
-- Convert duration from text to integer
-- =======================================
ALTER TABLE campaign
ALTER COLUMN duration TYPE INT 
USING REPLACE(duration, 'days', '')::INT;

-- =====================================================
-- Verify acquisition_cost and duration after conversion
-- =====================================================
SELECT 
	acquisition_cost, 
	duration
FROM campaign
LIMIT 10;

-- ====================================================
-- Feature Engineering: create click_through_rate (ctr)
-- ctr = clicks / impressions
-- ====================================================
ALTER TABLE campaign
ADD COLUMN ctr NUMERIC(10,2);

UPDATE campaign
SET ctr = ROUND(
	clicks::NUMERIC/NULLIF(impressions,0),
	2
);

-- ================================================
-- Feature Engineering: create cost_per_click (cpc)
-- cpc = acquisition_cost / clicks
-- ================================================
ALTER TABLE campaign
ADD COLUMN cpc NUMERIC(10,2);

UPDATE campaign
SET cpc = ROUND(
	acquisition_cost/NULLIF(clicks,0),
	2
);

-- =============================================================
-- Feature Engineering: create month col for time-based analysis
-- =============================================================
ALTER TABLE campaign
ADD COLUMN month DATE;

UPDATE campaign
SET month = DATE_TRUNC('month', date);

-- ==========================================
-- Another preview to verify the cols created
-- ==========================================
SELECT *
FROM campaign
LIMIT 10;

-- ======================================================
-- Create campaign features for ML analysis and modeling
-- ======================================================
CREATE VIEW campaign_features_ml AS
SELECT
    campaign_type,
    channel_used,
    customer_segment,
	month,
    clicks,
    impressions,
    ctr,
    cpc,
    conversion_rate,
    engagement_score,
    clicks * conversion_rate * 1000 AS revenue,
	(clicks * conversion_rate * 1000) - acquisition_cost AS profit,
	CASE 
        WHEN acquisition_cost = 0 THEN NULL
        ELSE ((clicks * conversion_rate * 1000) - acquisition_cost) 
             / acquisition_cost * 100
    END AS roi
FROM campaign;

-- =================================================
-- Create campaign_pbix_view for dashboard creation
-- =================================================
CREATE VIEW campaign_pbix_view AS
SELECT
	campaign_type,
    channel_used,
    customer_segment,
	location,
    date,
    SUM(clicks) AS clicks,
    SUM(impressions) AS impressions,
    SUM(acquisition_cost) AS ad_spend,
    SUM(clicks * conversion_rate) AS conversions,
	SUM(clicks * conversion_rate) * 1000 AS revenue,
	(SUM(clicks * conversion_rate) * 1000) 
    - SUM(acquisition_cost) AS profit,
    CASE 
        WHEN SUM(acquisition_cost) = 0 THEN NULL
        ELSE 
            ((SUM(clicks * conversion_rate) * 1000) 
            - SUM(acquisition_cost)) 
            / SUM(acquisition_cost)
    END AS roi
FROM campaign
GROUP BY date,
		campaign_type,
		channel_used,
		customer_segment,
		location;
