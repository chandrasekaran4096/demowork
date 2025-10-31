IF NOT EXISTS(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'M_D_RESTAURANT'   AND TABLE_SCHEMA='food')
BEGIN
CREATE TABLE food.M_D_RESTAURANT (
  restaurant_id INT IDENTITY(1,1) PRIMARY KEY,
  userid INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  address VARCHAR(250)  NULL,
  phone_number VARCHAR(15) NULL,
  cuisine_type VARCHAR(100) NULL,
  delivery_time INT NULL,
  rating DECIMAL(3,2)  default 5.0,
  is_active BIT DEFAULT 1 NULL,
  approval_status_from_admin BIT DEFAULT 0,
  img VARBINARY(MAX) NULL,
  created_at DATETIME DEFAULT GETDATE() NOT NULL,
  updated_at DATETIME NULL,
  is_deleted BIT DEFAULT 0 NULL
);
END
GO

IF NOT EXISTS(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'M_D_ORDERS'   AND TABLE_SCHEMA='food')
BEGIN
CREATE TABLE food.M_D_ORDERS (
  order_id INT IDENTITY(1,1) PRIMARY KEY,
  restaurant_id INT NOT NULL,
  userid INT NOT NULL,
  order_date DATETIME NULL,
  total_amount DECIMAL(10,2) NULL,
  status VARCHAR(50) NULL,
  payment_mode VARCHAR(50) NULL,
  created_at DATETIME DEFAULT GETDATE() NOT NULL,
  updated_at DATETIME NULL,
  is_deleted BIT DEFAULT 0 NULL,
  customer_ratings DECIMAL(3,2) NULL,
);
END
GO

When ever we insert or update in customer_ratings in food.M_D_ORDERS we need to update the rating column in food.M_D_RESTAURANT based on the avg(customer_ratings) on food.M_D_ORDERS  and update the ratings on food.M_D_RESTAURANT with the avg customer_ratings in that restaurant give me a correct mssql trigger query
