# 📊 Marketing Campaign Performance Analysis

## 📌 Project Overview

This project delivers an end-to-end analysis of marketing campaign performance using data analytics and machine learning techniques.

The objective is to identify key drivers of profitability, evaluate campaign efficiency, and provide actionable insights for optimizing marketing strategies.

The project combines **SQL, Python (EDA & Machine Learning), and Power BI (dashboarding)** to transform raw campaign data into business-ready insights.

---

## 💼 Business Problem

Despite significant investment in marketing campaigns, the company is not achieving expected returns.

Marketing decisions are currently made without clear insight into which campaings drive profitability, leading to inefficient budget allocation and missed opportunities to scale high-performing campaigns.

Key issues included:

* High marketing costs without clear visibility into profitability drivers
* Inefficient budget allocation across marketing channels
* Difficulty identifying high-performing vs underperforming campaigns
* Lack of clear segmentation for targeted decision-making

This project addresses these challenges by uncovering key performance drivers and enabling data-driven marketing optimization.

---

## 🎯 Objectives

* Analyze campaign performance using Profit, ROI, CTR, and CPC
* Identify factors influencing profitability
* Evaluate relationships between engagement and cost
* Build a predictive model for profit estimation
* Segment campaigns into performance groups
* Develop a dashboard for business decision-making

---

## 📁 Dataset Description

The dataset contains campaign-level marketing data, including:

* `clicks` – Number of clicks
* `impressions` – Ad views
* `ctr` – Click-through rate
* `cpc` – Cost per click
* `engagement_score` – Interaction metric
* `campaign_type` – Type of campaign
* `channel_used` – Marketing channel
* `customer_segment` – Target audience
* `profit` – Revenue minus cost
* `roi` – Return on investment

---

## 🛠️ Tools & Technologies

* 🗄️ **SQL** – Data extraction, cleaning & feature engineering
* 🐍 **Python (Pandas, NumPy)** – Data preprocessing, transformation & analysis
* 📊 **Matplotlib & Seaborn** – Exploratory visualization
* 🤖 **Scikit-learn** – Machine Learning (Regression & Clustering)
* 📈 **Power BI** – Interactive dashboard & reporting
* 📓 **Jupyter Notebook** – Workflow documentation

---

## 🔍 Methodology

### 1. Data Preparation

* Cleaned dataset and handled missing values to enusre data integrity
* Encoded categorical variables
* Selected relevant features

### 2. Exploratory Data Analysis (EDA)

* Distribution analysis (Profit, ROI, CTR, CPC)
* Outlier detection and treatment
* Trend analysis over time
* Relationship analysis between variables
* Correlation analysis

### 3. Feature Engineering

* Log transformation of Profit
* One-hot encoding of categorical variables

### 4. Machine Learning

#### 📈 Linear Regression

* Target variable: `log(profit)`
* Performance:

  * RMSE: **0.99**
  * R²: **0.31**

#### 🔍 KMeans Clustering

* Segmented campaigns into:

  * 🟢 Top-performing
  * 🟡 Average-performing
  * 🔴 Underperforming

### 5. Data Visualization & Reporting

* Built an interactive Power BI dashboard
* Translated insights into business-friendly visuals
* Enabled stakeholder-level decision-making

---

## 📊 Dashboard (Power BI)

An interactive one-page dashboard was developed to present key insights.

### Key Features:

* KPI overview (Profit, ROI, CPC, CTR)
* Profit by marketing channel
* Monthly profit trends
* Campaign performance comparison
* Cluster-based segmentation

---

## 📊 Key Insights

* CPC has a **strong negative impact** on profitability
* CTR has a **positive but weak relationship** with profit
* Profit distribution is **highly skewed**, driven by a few campaigns
* Cost efficiency is the **primary driver of performance**
* Campaigns can be clearly segmented into performance tiers

---

## 🎯 Conclusion

Campaign profitability is influenced by both engagement and cost factors, with **cost efficiency (CPC)** emerging as the most critical driver.

High-performing campaigns are characterized by:

* Low CPC
* Strong engagement
* Efficient conversion behavior

---

## 🚀 Recommendations

* Reduce CPC through better targeting and bidding strategies
* Scale high-performing campaigns
* Optimize or eliminate underperforming campaigns
* Use CTR as a supporting metric
* Leverage segmentation for decision-making
* Incorporate additional metrics (CPA, conversion rate)

---

## 📁 Repository Structure

```id="83291x"
marketing-campaign-analysis/
│
├── datasets/
│   └── campaign_data.csv
│
├── notebooks/
│   └── marketing_analysis.ipynb
│
├── powerbi/
│   └── marketing_dashboard.pbix
│
├── outputs/
│   ├── figures/
│   └── models/
│
├── .env
├── requirements.txt
├── README.md
└── .gitignore
```

---

## 🧠 Executive Summary

Campaign profitability is primarily driven by **cost efficiency (CPC)** rather than engagement (CTR), with high-performing campaigns characterized by low acquisition costs and efficient conversion behavior.

---

## 👤 Author

**Emmanuel**
Data Analyst | SQL • Python • Power BI • Machine Learning

---
