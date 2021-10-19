
--Because the report will be used for evaluation, we will only take data where 'order_status = delivered' 
--for the delivered packages and the order_status = 'canceled' 
--or order_status = 'unavailable' for the failed packages

--Data items with order_status = 'shipped','invoiced','created','approved','processing' 
--are not invloved because it is still in process
--We can't evaluate the data items that are still in process (not delivered but not failed yet).

--TABLE 1:
--In order to get these information:
-- *Amount packages delivered
-- *Delivery frequency per city
-- *Avg freight value per city
-- *Avg package weight per city
-- We need these columns:
create table tabel_1 as
	select 
	oi.order_id,
	oi.product_id,
	oi.freight_value,
	lc.customer_city,
	lp.product_category_name,
	lp.product_weight_g, 
	lo.order_delivered_customer_date,
	lo.order_status 
	from order_items oi 
	left join list_products lp 
	on oi.product_id = lp.product_id 
	left join list_orders lo 
	on oi.order_id = lo.order_id 
	left join list_customers lc 
	on lo.customer_id = lc.customer_id
	where order_status = 'delivered' 
	
--TABLE 2:
--In order to get these information:
-- *Delivery time (delivered customer-delivered carrier) distribution
-- *Most route (Buyer-seller city)
-- We need these columns:
create table tabel_x as
	select 
	lo.order_id,
	lo.customer_id,
	lo.order_status,
	lo.order_approved_at,
	lo.order_delivered_customer_date, 
	lp.product_category_name,
	lc.customer_city,
	sl.seller_city,
	lc.customer_city ||'-'|| sl.seller_city as route
	from list_orders lo 
	left join list_customers lc 
	on lo.customer_id = lc.customer_id 
	left join order_items oi 
	on lo.order_id = oi.order_id 
	left join list_products lp 
	on oi.product_id = lp.product_id
	left join seller_lists sl 
	on oi.seller_id = sl.seller_id 
	
create table tabel_2 as
	select * 
	from tabel_x
	where order_status = 'delivered'

--Table 3:
--In order to get these information:
-- *Delivery failure (canceled or unavailable)
-- *Delivery failure per city
-- *Delivery failure per order status
-- We need these columns:
create table tabel_3 as
	select * from tabel_x 
	where order_status = 'canceled' or order_status = 'unavailable'

