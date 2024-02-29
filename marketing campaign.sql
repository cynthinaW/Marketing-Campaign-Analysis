--- sales, sessions trends by month
select month(date) as month,
sum(sessions) as sessions,
sum(sales) as sales
from site_date
group by 1;

--- Top 5 categories sales trends by month
with sales_summary as
(select month(date) as month,
category,
sum(sales) as sales,
rank() over (partition by month(date) order by sum(sales) desc) as rnk
from site_date
group by 1,2
order by 1)

select month, category, sales
from sales_summary
where rnk<=5
order by month

---campaign effectiveness by channel
select channel,
round(sum(attributed_sales),2) as revenue,
round(sum(conversions)/sum(impressions),4) as conversion_rate,
round(sum(attributed_sales)/sum(spend),2) as ROAS,
round(sum(attributed_sales)-sum(spend),2) as net_profit
from campaign_performance
group by 1

---sales by age age_group
select age_group,
round(sum(sales),2) as sales
from user_sales
where brand='A'
group by 1
order by 1

---sales by age gender
select gender,
round(sum(sales),2) as sales
from user_sales
where brand='A'
group by 1
order by 2 desc

---sales by age region
select region,
round(sum(sales),2) as sales
from user_sales
where brand='A'
group by 1
order by 2 desc

---Most purchased categories
select category,
round(sum(sales),2)as sales
from user_sales
where brand='A'
group by 1
order by 2 desc

---Average Purchase Frequency
select count (distinct order_id)/count(distinct customer_id) as frequency
from user_sales
where
age_group = '35-39'
and region = 'NY'
and gender = 'F'
and brand = 'A'
and sales > 0

---Average Days Since Last Purchase
with previous_date as
(select date,
lag(date) over (partition by customer_id order by date) as previous_date
from user_sales
where brand = 'A' and sales > 0 and age_group = '35-39'
and region = 'NY' and gender = 'F' and brand = 'A')

select
floor(avg(datediff('day', previous_date, date))) as days_since_last_purchase
from previous_date
where previous_date not null
