CREATE TRIGGER trg_UpdateRestaurantRating
ON food.M_D_ORDERS
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Update restaurant rating based on latest average customer ratings
    UPDATE R
    SET R.rating = AvgRatings.avg_rating
    FROM food.M_D_RESTAURANT R
    INNER JOIN (
        SELECT O.restaurant_id,
               AVG(O.customer_ratings) AS avg_rating
        FROM food.M_D_ORDERS O
        WHERE O.customer_ratings IS NOT NULL
          AND O.is_deleted = 0
        GROUP BY O.restaurant_id
    ) AvgRatings
    ON R.restaurant_id = AvgRatings.restaurant_id
    WHERE R.restaurant_id IN (
        SELECT DISTINCT restaurant_id
        FROM inserted
    );
END
go






No — the MODIFY COLUMN syntax is MySQL only.
For MS SQL Server (MSSQL), the syntax is different.

✅ Steps in MSSQL to change default value:

1️⃣ First, drop the existing default constraint (if any)

In MSSQL, default values are created as constraints, and you must drop the constraint first.

To find the default constraint name:

SELECT name 
FROM sys.default_constraints
WHERE parent_object_id = OBJECT_ID('your_table_name')
  AND parent_column_id = (
        SELECT column_id 
        FROM sys.columns 
        WHERE object_id = OBJECT_ID('your_table_name')
          AND name = 'rating'
     );

You'll get the constraint name (example: DF_products_rating).

Then drop it:

ALTER TABLE your_table_name
DROP CONSTRAINT constraint_name;

2️⃣ Add a new default constraint

ALTER TABLE your_table_name
ADD CONSTRAINT DF_rating_default
DEFAULT 5.0 FOR rating;


---

✅ Full example for table Products

-- Drop old default constraint
ALTER TABLE Products DROP CONSTRAINT DF_Products_Rating;

-- Add new default value
ALTER TABLE Products
ADD CONSTRAINT DF_Rating_Default DEFAULT 5.0 FOR rating;


---

📌 Important Notes

MSSQL does not allow ALTER COLUMN ... DEFAULT

You must drop the old constraint first

You can name the new constraint anything (DF_Rating_Default here)



---

If you want, tell me your table name and I’ll generate the exact runnable script for you 👇