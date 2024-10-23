-- Active: 1729709375283@@127.0.0.1@3306@assignment_3
CREATE TRIGGER insert_user_timestamp
BEFORE INSERT ON User
FOR EACH ROW
BEGIN
    SET NEW.created_at = NOW();
END;

CREATE TRIGGER insert_posts_timestamp
BEFORE INSERT ON Posts
FOR EACH ROW
BEGIN
    SET NEW.created_at = NOW();
END;

CREATE TRIGGER insert_comments_timestamp
BEFORE INSERT ON Comments
FOR EACH ROW
BEGIN
    SET NEW.created_at = NOW();
END;

CREATE TRIGGER insert_comment_likes_timestamp
BEFORE INSERT ON Comments
FOR EACH ROW
BEGIN
    SET NEW.created_at = NOW();
END;