-- Active: 1729709375283@@127.0.0.1@3306@assignment_3
CREATE PROCEDURE count_user_posts(IN user_id INT, OUT post_count INT)
BEGIN
    SELECT COUNT(*) INTO post_count FROM Posts WHERE user_id = user_id;
END;


CALL count_user_posts(4, @post_count);
SELECT @post_count;