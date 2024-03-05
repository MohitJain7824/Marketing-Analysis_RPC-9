## Task 1

WITH main AS (
    SELECT
        f.*,d.city,
        CASE
            WHEN promo_type = '50% OFF' THEN base_price * 0.5  
            WHEN promo_type = '25% OFF' THEN base_price * 0.75 
            WHEN promo_type = 'BOGOF' THEN base_price / 2    
            WHEN promo_type = '500 Cashback' THEN base_price - 500 
            WHEN promo_type = '33% OFF' THEN base_price * 0.67 
            ELSE base_price  
        END AS promo_price,
        case 
			when promo_type='BOGOF' then `quantity_sold(after_promo)`*2
            else `quantity_sold(after_promo)`
            end as Adjusted_qty
    FROM
        fact_events f
        left join dim_stores d
        on d.store_id=f.store_id
)
SELECT
    max(city) as City,store_id,
    round(((SUM(promo_price * Adjusted_qty) - SUM(base_price * `quantity_sold(before_promo)`)) /
    SUM(base_price * `quantity_sold(before_promo)`)) * 100, 2) as IR
FROM main
    group by store_id
    order by IR desc
    limit 10;
    
    
    
    ##Task 2
    
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
        case 
			when promo_type='BOGOF' then `quantity_sold(after_promo)`*2
            else `quantity_sold(after_promo)`
            end as Adjusted_qty
    FROM
        fact_events
)
SELECT
    store_id,
    ((SUM(Adjusted_qty) - SUM(`quantity_sold(before_promo)`)) / SUM(`quantity_sold(before_promo)`) * 100) AS ISU
FROM
    main
GROUP BY
    store_id
ORDER BY
    ISU ASC
LIMIT 10;

## Task 4
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
        case 
			when promo_type='BOGOF' then `quantity_sold(after_promo)`*2
            else `quantity_sold(after_promo)`
            end as Adjusted_qty
    FROM
        fact_events
)
SELECT
    promo_type,
    round(((SUM(promo_price * Adjusted_qty) - SUM(base_price * `quantity_sold(before_promo)`)) /
    SUM(base_price * `quantity_sold(before_promo)`)) * 100, 2) as IR
FROM main
    group by promo_type
    order by IR desc
    limit 10;
    
    
    ## Task 5
  WITH main AS (
    SELECT
        e.*,
        p.category,
        p.product_name,
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
        fact_events e
    LEFT JOIN
        dim_products p ON p.product_code = e.product_code
)
SELECT
    promo_type,
    SUM(Adjusted_qty) AS Adjusted_qty_sum,
    SUM(`quantity_sold(before_promo)`) AS quantity_sold_before_promo_sum,
    ROUND((SUM(Adjusted_qty) - SUM(`quantity_sold(before_promo)`)) / SUM(`quantity_sold(before_promo)`) * 100) AS ISU
FROM
    main
GROUP BY
    promo_type
ORDER BY
    ISU DESC;


## Task 6
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
        END AS Adjusted_qty,
		case 
        WHEN promo_type = '500 Cashback' THEN "Cashback"
		WHEN promo_type = 'BOGOF' THEN "BOGOF"
        else "Discounted"
        end as Promotion_type
    FROM
        fact_events
)
SELECT
    Promotion_type,
    round(((SUM(promo_price * Adjusted_qty) - SUM(base_price * `quantity_sold(before_promo)`)) /
    SUM(base_price * `quantity_sold(before_promo)`)) * 100, 2) as IR
FROM main
    group by Promotion_type
    order by IR desc
    limit 10;

##Task 7
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
, promo_metrics AS (
    SELECT
        promo_type,
        round(((SUM(promo_price * Adjusted_qty) - SUM(base_price * `quantity_sold(before_promo)`)) /
        SUM(base_price * `quantity_sold(before_promo)`)) * 100, 2) as IR,
        ((SUM(Adjusted_qty) - SUM(`quantity_sold(before_promo)`)) / SUM(`quantity_sold(before_promo)`) * 100) AS ISU
    FROM main
    GROUP BY promo_type
)
SELECT
    promo_type,
    IR,
    ISU
FROM promo_metrics
#WHERE IR > 0 AND ISU > 0
ORDER BY IR DESC, ISU DESC;

##Task 8
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
)select p.category,
round(((SUM(promo_price * Adjusted_qty) - SUM(base_price * `quantity_sold(before_promo)`)) /
    SUM(base_price * `quantity_sold(before_promo)`)) * 100, 2) as IR
 from main m
left join dim_products p
on p.product_code=m.product_code
group by p.category
order by IR desc
limit 5;

## Task 9
WITH main AS (
    SELECT
        e.*,
        p.category,
        p.product_name,
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
        fact_events e
    LEFT JOIN
        dim_products p ON p.product_code = e.product_code
)
, product_promo_metrics AS (
    SELECT
        product_code,
        product_name,
        promo_type,
        SUM(Adjusted_qty) AS Adjusted_qty_sum,
        SUM(`quantity_sold(before_promo)`) AS quantity_sold_before_promo_sum,
        ROUND((SUM(Adjusted_qty) - SUM(`quantity_sold(before_promo)`)) / SUM(`quantity_sold(before_promo)`) * 100) AS ISU
    FROM
        main
    GROUP BY
        product_code, product_name, promo_type
)
SELECT
    product_code,
    product_name,
    promo_type,
    ISU
FROM
    product_promo_metrics;
    
##or
WITH main AS (
    SELECT
        e.*,
        p.category,
        p.product_name,
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
        fact_events e
    LEFT JOIN
        dim_products p ON p.product_code = e.product_code
)select product_code,product_name, SUM(promo_price * Adjusted_qty),SUM(base_price * `quantity_sold(before_promo)`),
round(((SUM(promo_price * Adjusted_qty) - SUM(base_price * `quantity_sold(before_promo)`)) /
    SUM(base_price * `quantity_sold(before_promo)`)) * 100, 2) as IR
    from main
    group by product_code,product_name
    