-- Active: 1729709375283@@127.0.0.1@3306@assignment_3
CREATE VIEW comments_with_post_info AS
SELECT 
    Comments.comment_id,
    Posts.title AS post_title,
    User.username AS commenter_username,
    Comments.text AS comment_text,
    Comments.created_at
FROM 
    Comments
JOIN 
    Posts ON Comments.post_id = Posts.post_id
JOIN 
    User ON Comments.user_id = User.user_id;
