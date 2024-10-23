-- Active: 1729709375283@@127.0.0.1@3306@assignment_3

CREATE FUNCTION get_full_name(user_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE full_name VARCHAR(100);
    SELECT CONCAT(first_name, ' ', last_name) INTO full_name
    FROM Profile
    WHERE user_id = user_id;
    RETURN full_name;
END;

