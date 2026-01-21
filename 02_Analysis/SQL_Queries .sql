 select 
    Age, item_purchased, category, location, size, color, season, review_rating, subscription_status,
    shipping_type, discount_applied, promo_code_used, payment_method, frequency_of_purchases
--aggreation
    , count(customer_id) as Customer,
    sum("Purchase Amount (USD)") as Revenue,
    SUM(PREVIOUS_PURCHASES) as Quantity,
--Date
    to_date(processdate) as full_date,
    to_char(to_date(processdate), 'yyyy-mm') Month_id,
    monthname(full_date) as Months,
    dayname(full_date) as weekdays,
    dayofmonth(full_date) as day_number,
    YEAR(FULL_DATE) AS YEAR,
--time
    TO_CHAR(processdate, 'HH24:mi') as Times,
    Case
    When Times between '05:00' and '11:59' then 'Morning: 05:00-11:59'
    When Times between '12:00' and '16:59' then 'Afternoon: 12:00-16:59'
    When Times between '17:00' and '22:59' then 'Evening: 17:00-21:59'
    else 'Night: 22:00-04:59'
    end as time_busket,
---MOM REVENUE CHANGE %
    lag(sum("Purchase Amount (USD)"), 1)
over(ORDER by to_char(to_date(processdate), 'yyyy-mm')) as Months_pr,
(
sum ("Purchase Amount (USD)")-lag(sum("Purchase Amount (USD)"),1)
over (order by to_char(to_date(processdate), 'yyyy-mm')))/ lag(sum("Purchase Amount (USD)"), 1)
over (order by to_char(to_date(processdate), 'yyyy-mm')) * 100 percentage_change,
--Spend_busket
    case when "Purchase Amount (USD)" between '20' and '40' then 'Low_End:R20-R40'
         when "Purchase Amount (USD)" between '41' and '60' then 'Mid_End:R41-R60'
         when "Purchase Amount (USD)" between '61' and '80' then 'Mid_High:R61-R80'
         else 'High_End:81+'
    end as Spend_busket,
--Age_group
    case when age between '18' and '25' then '18-25:Youth'
         when age between '26' and '59' then '26-59:Adults'
         when age between '60' and '70' then '60+:Senior'
    end as Age_Group,
---Rating_busket
    case when review_rating between '2.5' and '3.0' then 'Bad:2.5-3.0'
         when review_rating between '3.1' and '4.0' then 'Neutral:3.1-4.0'
         else 'Good :4.1+'
    end as Rating_group
FROM `workspace`.`default`.`shopping_data`
GROUP BY Age,`Item Purchased`,Category,Location,Size, Color,Season, 
        `Review Rating`, `Subscription Status`,`Shipping Type`, 
        `Discount Applied`, `Promo Code Used`,`Payment Method`, 
        `Frequency of Purchases`,processdate, `Purchase Amount (USD)`,
        `Customer ID`, `Previous Purchases`;
