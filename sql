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
GO