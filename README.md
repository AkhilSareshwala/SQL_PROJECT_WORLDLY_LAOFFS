# 🌟 **Title: Mastering Data Cleaning and Analysis in SQL: A Step-by-Step Guide** 🌟

Data cleaning is a critical step in the data analysis process, transforming messy data into actionable insights. Here’s a detailed walkthrough of how I tackled a dataset on layoffs, focusing on SQL techniques that you can apply in your own projects.

---

## 🔍 **1. Removing Duplicates**

To ensure data integrity, I started by removing duplicates. Using a **Common Table Expression (CTE)**, I assigned a row number to each duplicate entry based on key fields such as **company** and **location**. Then, I deleted the duplicates, retaining only the first occurrence.

---

## ✂️ **2. Standardizing Data**

Data inconsistency can lead to inaccurate analyses. I trimmed whitespace from string columns, unified industry terms (e.g., changing "Crypto Currency" to "Crypto"), and standardized country names for uniformity.

---

## 🛠️ **3. Handling Missing Values**

I filled in missing industry values by matching companies with existing data. This step ensured that my dataset remained robust and usable for analysis.

---

## 🗑️ **4. Cleaning Up Unwanted Data**

I removed rows with **null values** in key metrics and dropped unnecessary columns, streamlining the dataset for further exploration.

---

## 📊 **Exploratory Data Analysis (EDA)**

With the dataset cleaned, I performed EDA to uncover insights:

- **100% Layoffs**: Identified companies with total layoffs equating to 100% of their workforce.
- **Aggregate Analysis**: Grouped total layoffs by company, industry, and country to highlight trends.
- **Temporal Analysis**: Explored layoffs over time, revealing critical periods of workforce reduction.

---

## 📈 **Rolling Sums and Yearly Analysis**

I computed rolling sums to visualize trends over months and years, and ranked companies by layoffs, providing a clear view of the landscape.

---

## 🏁 **Conclusion**

Effective data cleaning and analysis reveal patterns that can inform strategic decisions. By following these steps, you can transform your data into powerful insights.
