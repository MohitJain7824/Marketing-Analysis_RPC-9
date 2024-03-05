##Ad-hoc
##TASK-1
SELECT distinct p.product_code,p.product_name FROM retail_events_db.fact_events e
LEFT JOIN retail_events_db.dim_products p
on p.product_code=e.product_code
where e.base_price>500 and promo_type='BOGOF';

##TASK-2
select city,count(*) as Store_counts from retail_events_db.dim_stores
group by city
order by Store_counts desc;

##TASK-3
WITH main AS (
    SELECT
        *,
        CASE
            WHEN promo_type = '50% OFF' THEN base_price * 0.5
            WHEN promo_type = '25% OFF' THEN base_price * 0.75 
            WHEN promo_type = 'BOGOF' THEN base_price / 2
            WHEN promo_type = '500 Cashback' THEN base_price - 500 
            WHEN promo_type = '33% OFF' THEN base_price * 0.67 
            ELSE base_price
        END AS promo_price,
        CASE 
            WHEN promo_type = 'BOGOF' THEN `quantity_sold(after_promo)` * 2
            ELSE `quantity_sold(after_promo)`
        END AS Adjusted_qty
    FROM
        fact_events
)
SELECT
    campaign_id,
    SUM(base_price * `quantity_sold(before_promo)`) / 1000000 AS before_promo_rev_mln,
    SUM(promo_price * Adjusted_qty) / 1000000 AS after_promo_price_mln
FROM
    main
GROUP BY
    campaign_id;
    
    ##TASK-4
    WITH main AS (
    SELECT
        f.*, p.product_name, p.category,
        CASE
            WHEN promo_type = '50% OFF' THEN base_price * 0.5  
            WHEN promo_type = '25% OFF' THEN base_price * 0.75 
            WHEN promo_type = 'BOGOF' THEN base_price / 2    
            WHEN promo_type = '500 Cashback' THEN base_price - 500 
            WHEN promo_type = '33% OFF' THEN base_price * 0.67 
            ELSE base_price  
        END AS promo_price,
        CASE 
            WHEN promo_type = 'BOGOF' THEN `quantity_sold(after_promo)` * 2
            ELSE `quantity_sold(after_promo)`
        END AS Adjusted_qty
    FROM
        fact_events f
        LEFT JOIN retail_events_db.dim_products p
        ON p.product_code = f.product_code
)
SELECT
    category,
    ((SUM(Adjusted_qty) - SUM(`quantity_sold(before_promo)`)) / SUM(`quantity_sold(before_promo)`) * 100) AS 'ISU%',
    RANK() OVER (ORDER BY ((SUM(Adjusted_qty) - SUM(`quantity_sold(before_promo)`)) / SUM(`quantity_sold(before_promo)`)) DESC) AS ranks
FROM
    main
WHERE
    campaign_id = 'CAMP_DIW_01'
GROUP BY
    category;
        

##TASK-5
WITH main AS (
    SELECT
        *,
        CASE
            WHEN promo_type = '50% OFF' THEN base_price * 0.5  
            WHEN promo_type = '25% OFF' THEN base_price * 0.75 
            WHEN promo_type = 'BOGOF' THEN base_price / 2    
            WHEN promo_type = '500 Cashback' THEN base_price - 500 
            WHEN promo_type = '33% OFF' THEN base_price * 0.67 
            ELSE base_price  
        END AS promo_price,
        CASE 
            WHEN promo_type = 'BOGOF' THEN `quantity_sold(after_promo)` * 2
            ELSE `quantity_sold(after_promo)`
        END AS Adjusted_qty
    FROM
        fact_events
)select p.product_name,p.category,
round(((SUM(promo_price * Adjusted_qty) - SUM(base_price * `quantity_sold(before_promo)`)) /
    SUM(base_price * `quantity_sold(before_promo)`)) * 100, 2) as IR
 from main m
left join dim_products p
on p.product_code=m.product_code
group by p.product_name,p.category
order by IR desc
limit 5;
