-- a.  Portfolio management: Display the cumulative approval rate by month for each source in 2023

; with CTE_monthly_approved as (
    select month(a.apply_date) as apply_month, b.source
    , count(a.latest_status) as total_leads_this_month
    , sum(case when a.latest_status = 'approved' then 1 else 0 end) as leads_approved_this_month
    FROM leads a 
    left join customers b on a.customer_id = b.customer_id
    WHERE year(apply_date) = '2023'
    GROUP BY  month(a.apply_date), b.source
)

; with CTE_cumulated_approval as (
    select *
    , SUM(total_leads_this_month) OVER (PARTITION BY source ORDER BY apply_month ASC) AS cumulative_sum_total_leads
    , SUM(leads_approved_this_month) OVER (PARTITION BY source ORDER BY apply_month ASC) AS cumulative_sum_leads_approved
    from CTE_monthly_approved
)

select apply_month, source, format(cumulative_sum_leads_approved/cumulative_sum_total_leads * 100, '0.00') as cumulative_approval_rate_%
from CTE_cumulated_approval
order by source, apply_month ASC

-- b. Marketing: Display the names of customers who applied in 2023 and are older than 92.5% of all leads who applied in 2022

; with CTE_percentile as (
    SELECT PERCENTILE_DISC(0.925) WITHIN GROUP (ORDER BY customer_age ) OVER () AS 'percentile_92.5'
    FROM customers
    WHERE customer_id in (select customer_id from leads where cast(apply_date as date)) between '2022-1-1' and '2022-12-31'
)

select customer_name
from customers
where customer_age > (select percentile_92.5 from CTE_percentile)
AND customer_id in (select customer_id from leads where cast(apply_date as date)) between '2023-1-1' and '2023-12-31'


/* c.Rollover detection: display the names of customers who applied 5 times consecutively
25-35 days between any two continuous dates
loan amount is increasing (each subsequent loan amount is larger than the previous one)
all 5 banks applied being different
*/

; with CTE_application_ranked as(
    select b.customer_name, a.apply_date, c.loan_amount, c.bank_id
    dense_rank() over(partition by customer_name order by apply_date asc) as application_rank
    from leads a
    left join customers b on a.customer_id = b.customer_id
    left join products c on a.product_id = c.product_id
)

; with CTE_5_consecutive_applications as(
    select customer_name, apply_date, loan_amount, bank_id, application_rank
    , LAG(apply_date, 1) OVER (PARTITION BY customer_name ORDER BY application_rank) AS apply_date_T_minus_1
    , LAG(apply_date, 2) OVER (PARTITION BY customer_name ORDER BY application_rank) AS apply_date_T_minus_2
    , LAG(apply_date, 3) OVER (PARTITION BY customer_name ORDER BY application_rank) AS apply_date_T_minus_3
    , LAG(apply_date, 4) OVER (PARTITION BY customer_name ORDER BY application_rank) AS apply_date_T_minus_4
    , LAG(loan_amount, 1) OVER (PARTITION BY customer_name ORDER BY application_rank) AS loan_amount_T_minus_1
    , LAG(loan_amount, 2) OVER (PARTITION BY customer_name ORDER BY application_rank) AS loan_amount_T_minus_2
    , LAG(loan_amount, 3) OVER (PARTITION BY customer_name ORDER BY application_rank) AS loan_amount_T_minus_3
    , LAG(loan_amount, 4) OVER (PARTITION BY customer_name ORDER BY application_rank) AS loan_amount_T_minus_4
    , LAG(bank_id, 1) OVER (PARTITION BY customer_name ORDER BY application_rank) AS bank_id_T_minus_1
    , LAG(bank_id, 2) OVER (PARTITION BY customer_name ORDER BY application_rank) AS bank_id_T_minus_2
    , LAG(bank_id, 3) OVER (PARTITION BY customer_name ORDER BY application_rank) AS bank_id_T_minus_3
    , LAG(bank_id, 4) OVER (PARTITION BY customer_name ORDER BY application_rank) AS bank_id_T_minus_4
    from CTE_application_ranked
    where application_rank >= 5
)

select distinct customer_name from CTE_5_consecutive_applications
WHERE datediff(day, apply_date_T_minus_1, apply_date) between 25 and 35
AND datediff(day, apply_date_T_minus_2, apply_date_T_minus_1) between 25 and 35
AND datediff(day, apply_date_T_minus_3, apply_date_T_minus_2) between 25 and 35
AND datediff(day, apply_date_T_minus_4, apply_date_T_minus_3) between 25 and 35
AND loan_amount > loan_amount_T_minus_1
AND loan_amount_T_minus_1 > loan_amount_T_minus_2
AND loan_amount_T_minus_2 > loan_amount_T_minus_3
AND loan_amount_T_minus_3 > loan_amount_T_minus_4
AND bank_id <> bank_id_T_minus_1
AND bank_id <> bank_id_T_minus_2
AND bank_id <> bank_id_T_minus_3
AND bank_id <> bank_id_T_minus_4
AND bank_id_T_minus_1 <> bank_id_T_minus_2
AND bank_id_T_minus_1 <> bank_id_T_minus_3
AND bank_id_T_minus_1 <> bank_id_T_minus_4
AND bank_id_T_minus_2 <> bank_id_T_minus_3
AND bank_id_T_minus_2 <> bank_id_T_minus_4
AND bank_id_T_minus_3 <> bank_id_T_minus_4;


/* d. Create a user-defined SQL function that takes a customer_id as input. The output should be a
message congratulating the customer if they can apply for the largest possible loan amount
from a bank name, or a message expressing regret if no suitable loan product is found. Ensure
that A customer with a certain risk level cannot be matched with products that accept a lower
risk level. */

CREATE FUNCTION CheckLoanEligibility(input_customer_id INT) RETURNS VARCHAR(255)
BEGIN
    DECLARE max_loan_amount INT;
    DECLARE bank_name VARCHAR(255);
    
    ; with products_risk_as_number_rank as (
        select *
        , case when accepted_risk_level = 'low' then 1
        when accepted_risk_level = 'medium' then 2
        when accepted_risk_level = 'high' then 3
        end as risk_level_num_rank
        from products
    )

    ; with customers_risk_as_num_rank as (
        select *
        , case when accepted_risk_level = 'low' then 1
        when accepted_risk_level = 'medium' then 2
        when accepted_risk_level = 'high' then 3
        end as risk_level_num_rank
        from customers
    )

    SELECT Top 1 a.loan_amount, b.bank_name
    INTO max_loan_amount, bank_name
    FROM products_risk_as_number_rank a
    left join banks b on a.bank_id = b.bank_id
    WHERE a.risk_level_num_rank <= (SELECT risk_level_num_rank FROM customers_risk_as_num_rank WHERE customer_id = input_customer_id)
    Order by a.loan_amount DESC;

    IF max_loan_amount IS NOT NULL THEN
        RETURN CONCAT('Congratulations, You can apply for a loan with the amount of ', max_loan_amount, ' USD from ', bank_name, ' bank.');
    ELSE
        RETURN 'Sorry, we cannot find any suitable loan products for you at this time.';
    END IF;

END;


/* The race of products: For each month in the year 2023, identify and display the following
information:
● The month (formatted as YYYY-MM).
● The number of unique loan products that had at least 100,000 applications in that
month and in every previous month of 2023 (“good” product).
● The name of the "best" loan product for the month.
● The number of applications for the "best" loan product.
*/

-- CTE1: Use group by to get month, loan products, no. of applications in that month
-- CTE2: min over partion by loan products order by month asc as min_applications
-- CTE3: filter out only the good products
-- CTE4: count the good products
-- CTE5: use row number to get the name of the best loan product for each month
-- Final select: join all the table together on the month column

; with CTE1_applications_by_month as (
    select format(a.apply_date, 'yyyy-MM') AS month, b.product_name
    , count(customer_id) as no_of_applications
    FROM leads a
    left join products b on a.product_id = b.product_id
    WHERE year(a.apply_date) = '2023'
)

; with CTE2_check_min_application as (
    select *
    , min(no_of_applications) over (PARTITION by product_name order by month asc rows between UNBOUNDED PRECEDING and current row)
    as min_no_of_applications_to_date
    from CTE1_applications_by_month
)

; with CTE3_filter_good_products as (
    select *
    from CTE2_check_min_application
    where min_no_of_applications_to_date >= 100000 and no_of_applications >= 100000 
)

; with CTE4_good_products_count as (
    select month, count(b.product_name) as no_of_good_products
    from CTE3_filter_good_products
    group by month
)

; with CTE5_top_product_by_month as (
    select *, row_numnber() over (partition by month order by no_of_applications DESC) as product_ranking
    from CTE3_filter_good_products
)

select a.month as 'Month', a.no_of_good_products as 'No. good products'
, b.product_name as 'Best product', b.no_of_applications as 'Maximum applications'
from CTE4_good_products_count a 
left join 
(select month, product_name, no_of_applications 
from CTE5_top_product_by_month
where product_ranking = 1) b on a.month = b.month