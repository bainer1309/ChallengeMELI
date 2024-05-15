--1.Listar los usuarios que cumplan años el día de hoy cuya cantidad de ventas realizadas en enero 2020 sea superior a 1500.
SELECT c.*
FROM Customer c
JOIN OrderTable o ON c.id_customer = o.id_customer
WHERE MONTH(c.birthday) = MONTH(NOW()) AND DAY(c.birthday) = DAY(NOW())
AND YEAR(o.purchase_date) = 2020 AND MONTH(o.purchase_date) = 1
GROUP BY c.id_customer
HAVING SUM(o.total_amount) > 1500;

--2. Por cada mes del 2020, se solicita el top 5 de usuarios que más vendieron($) en la categoría Celulares. Se requiere el mes y año de análisis, nombre y apellido del vendedor, cantidad de ventas realizadas, cantidad de productos vendidos y el monto total transaccionado. 
SELECT 
    year,
    month,
    seller_name,
    seller_surname,
    sales_count,
    total_items_sold,
    total_amount_sold
FROM (
    SELECT 
        YEAR(o.purchase_date) AS year,
        MONTH(o.purchase_date) AS month,
        c.name AS seller_name,
        c.surname AS seller_surname,
        COUNT(o.id_order) AS sales_count,
        SUM(i.quantity) AS total_items_sold,
        SUM(o.total_amount) AS total_amount_sold,
        ROW_NUMBER() OVER(PARTITION BY YEAR(o.purchase_date), MONTH(o.purchase_date) ORDER BY SUM(o.total_amount) DESC) AS rn
    FROM 
        `OrderTable` o
    JOIN 
        Customer c ON o.id_customer = c.id_customer
    JOIN 
        Item i ON o.id_item = i.id_item
    JOIN 
        Category cat ON i.id_category = cat.id_category
    WHERE 
        YEAR(o.purchase_date) = 2020
        AND cat.description = 'Celulares'
    GROUP BY 
        YEAR(o.purchase_date), MONTH(o.purchase_date), c.id_customer, c.name, c.surname
) AS top_sales
WHERE rn <= 5
ORDER BY year, month, total_amount_sold DESC;


--3. Se solicita poblar una nueva tabla con el precio y estado de los Ítems a fin del día. Tener en cuenta que debe ser reprocesable. Vale resaltar que en la tabla Item, vamos a tener únicamente el último estado informado por la PK definida. (Se puede resolver a través de StoredProcedure). 
--La tabla se creó junto a las demás en el punto 1
DELIMITER //

CREATE PROCEDURE PopulateItemState()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;
    
    DELETE FROM ItemState WHERE date = CURRENT_DATE();
    
    INSERT INTO ItemState (id_item, price, state, date)
    SELECT 
        i.id_item,
        i.price,
        i.state,
        CURRENT_DATE() AS date
    FROM 
        Item i
    WHERE 
        (i.id_item, i.release_date) IN (
            SELECT 
                id_item,
                MAX(release_date) AS release_date
            FROM 
                Item
            GROUP BY 
                id_item
        );
    
    COMMIT;
END //

DELIMITER ;
