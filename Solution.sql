-- 3)	Display the number of the customer group by their genders who have placed any order of amount greater than or equal to Rs.3000.
	
    SELECT cus_gender, COUNT(*)
	FROM `order`
	INNER JOIN
		customer
		ON `order`.cus_id = customer.cus_id
	WHERE ord_amount >= 3000
	GROUP BY customer.cus_gender;

-- 4)	Display all the orders alONg with the product name ordered by a customer having Customer_Id=2.
	
    SELECT *
	FROM `order`
	INNER JOIN	product_details
		ON `order`.prod_id = product_details.prod_id
	INNER JOIN product
		ON product_details.pro_id = product.pro_id
	WHERE cus_id = 2;

-- 5)	Display the Supplier details who can supply more than ONe product.

    SELECT *
	FROM supplier
	WHERE supp_id IN (
		SELECT supp_id
		FROM product_details
		GROUP BY supp_id
		HAVING COUNT(*) > 1
	);

-- 6)	Find the category of the product whose order amount is minimum.
	
    SELECT ORD_AMOUNT, CAT_NAME
	FROM `order`
	INNER JOIN product_details 
		ON product_details.prod_id = `order`.prod_id
	INNER JOIN product 
		ON product_details.pro_id = product.pro_id
	INNER JOIN category 
		ON product.cat_id = category.cat_id
	ORDER BY ord_amount LIMIT 1;

-- 7)	Display the Id and Name of the Product ordered after “2021-10-05”.

	SELECT product.pro_id, pro_name, pro_desc
	FROM `order`
	INNER JOIN product_details 
		ON `order`.prod_id = product_details.prod_id
	INNER JOIN product 
		ON product_details.pro_id = product.pro_id
	WHERE ord_date > "2021-10-05";

-- 8)	Print the top 3 supplier name and id and their rating ON the basis of their rating alONg with the customer name who has given the rating.
	
    SELECT supplier.supp_id, supp_name, cus_name, rating.rat_ratstars
	FROM rating
	INNER JOIN supplier 
		ON supplier.supp_id = rating.supp_id
	INNER JOIN customer 
		ON customer.cus_id = rating.cus_id
	ORDER BY rating.rat_ratstars DESC LIMIT 3;

-- 9)	Display customer name and gender whose names start or end with character 'A'.
	
    SELECT cus_name, cus_gender
	FROM customer
	WHERE cus_name LIKE 'A%' or cus_name LIKE '%A';

-- 10)	Display the total order amount of the male customers.
	
    SELECT cus_gender, SUM(ord_amount)
	FROM `order` 
	INNER JOIN 
		customer 
		ON `order`.cus_id = customer.cus_id
	GROUP BY CUS_GENDER
	HAVING cus_gender = 'M';

-- 11)	Display all the Customers LEFT OUTER JOIN with  the orders.

-- add a new customer Pallavi - initially she has NO order
	
    INSERT INTO customer(cus_id, cus_name, cus_phONe, cus_city, cus_gender) 
    VALUES(6, 'Pallavi', 1234567890, 'Bangalore', 'F');	

-- solution
	SELECT *
	FROM customer 
	LEFT OUTER JOIN 
		`order` 
		ON `order`.cus_id = customer.cus_id;
        
-- 12)	 Create a stored procedure to display the Rating for a Supplier if any alONg with the Verdict ON that rating if any LIKE if rating >4 then “Genuine Supplier” if rating >2 “Average Supplier” else “Supplier should not be considered”.

	CREATE DEFINER=`root`@`localhost` PROCEDURE `categorize_supplier`()
	BEGIN
		-- Verdict ON that rating if any LIKE
		-- 			if rating > 4 then "Genuine Supplier"
		-- 			if rating > 2 "Average Supplier"
		--          else "Supplier should not be cONsidered"
		SELECT supplier.supp_id, supp_name, rat_ratstars, 
		CASE
			WHEN rat_ratstars > 4 THEN "Genuine Supplier"
			WHEN rat_ratstars > 2 THEN "Average Supplier"
			ELSE "Supplier should not be considered"
		END AS verdict
		FROM rating INNER JOIN supplier ON rating.SUPP_ID = supplier.SUPP_ID;
	END;
