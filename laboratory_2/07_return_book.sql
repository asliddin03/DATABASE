CREATE OR REPLACE FUNCTION return_book(
    p_card_number int,
    p_inventory_number int
)
    RETURNS TABLE (
        success boolean,
        message_text text,
        return_date DATE
    ) AS $$
DECLARE
v_expected_return_date date;
    v_overdue_days int;
BEGIN
SELECT expected_return_date INTO v_expected_return_date
FROM issuance
WHERE card_number = p_card_number
  AND inventory_number = p_inventory_number
  AND actual_return_date IS NULL;

IF NOT FOUND THEN
        RETURN QUERY SELECT
                            false,
                            'Активная выдача не найдена',
                            NULL::DATE;
RETURN;
END IF;

    v_overdue_days := GREATEST(0, CURRENT_DATE - v_expected_return_date);

UPDATE book_instance
SET status = 'в наличии'
WHERE inventory_number = p_inventory_number;
UPDATE issuance
SET actual_return_date = CURRENT_DATE
WHERE card_number = p_card_number AND inventory_number = p_inventory_number
  AND actual_return_date IS NULL;

IF v_overdue_days > 0 THEN
        RETURN QUERY SELECT
                            true,
                            'Книга возвращена с просрочкой ' || v_overdue_days || ' дней',
                            CURRENT_DATE;
ELSE
        RETURN QUERY SELECT
                         true,
                         'Книга возвращена вовремя',
                         CURRENT_DATE;
END IF;

END;
$$ LANGUAGE plpgsql;

SELECT * FROM return_book(1001, 1)