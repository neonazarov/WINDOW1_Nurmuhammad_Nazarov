-- Creating the sales Table
CREATE TABLE sales (
    customer_id INT,
    sale_amount DECIMAL,
    sale_date DATE,
    sales_channel VARCHAR(50)
);

-- Inserting Sample Data
INSERT INTO sales (customer_id, sale_amount, sale_date, sales_channel) VALUES
(1, 100.00, '1998-01-15', 'Online'),
(2, 200.00, '1998-02-20', 'Retail'),
(3, 150.00, '1999-03-10', 'Online'),
(4, 300.00, '1999-04-25', 'Retail'),
(5, 250.00, '2001-05-30', 'Online'),
(6, 350.00, '2001-06-05', 'Retail'),
(7, 400.00, '2001-07-20', 'Online');

-- Running the Query
WITH RankedSales AS (
    SELECT
        customer_id,
        SUM(sale_amount) AS total_sales,
        sales_channel,
        ROW_NUMBER() OVER (PARTITION BY sales_channel, EXTRACT(YEAR FROM sale_date) ORDER BY SUM(sale_amount) DESC) AS sales_rank,
        EXTRACT(YEAR FROM sale_date) AS sale_year
    FROM
        sales
    WHERE
        EXTRACT(YEAR FROM sale_date) IN (1998, 1999, 2001)
    GROUP BY
        customer_id,
        sales_channel,
        EXTRACT(YEAR FROM sale_date)
)
SELECT
    customer_id,
    ROUND(total_sales, 2) AS total_sales,
    sales_channel,
    sale_year
FROM
    RankedSales
WHERE
    sales_rank <= 300
ORDER BY
    sales_channel,
    sale_year,
    total_sales DESC;
