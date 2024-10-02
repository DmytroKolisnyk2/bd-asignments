use assignment_2;

-- Non-optimized version
EXPLAIN
SELECT (
        SELECT CONCAT(
                users.username, ' (', profiles.first_name, ' ', profiles.last_name, '): ', COUNT(posts.id), ' posts'
            )
        FROM users
            JOIN profiles ON users.id = profiles.user_id
            JOIN posts ON users.id = posts.user_id
        WHERE
            posts.created_at > '2021-10-10'
        GROUP BY
            users.username,
            profiles.first_name,
            profiles.last_name
        ORDER BY COUNT(posts.id) ASC
        LIMIT 1
    ) AS min_posts,
    (
        SELECT CONCAT(
                users.username, ' (', profiles.first_name, ' ', profiles.last_name, '): ', COUNT(posts.id), ' posts'
            )
        FROM users
            JOIN profiles ON users.id = profiles.user_id
            JOIN posts ON users.id = posts.user_id
        WHERE
            posts.created_at > '2021-10-10'
        GROUP BY
            users.username,
            profiles.first_name,
            profiles.last_name
        ORDER BY COUNT(posts.id) DESC
        LIMIT 1
    ) AS max_posts,
    (
        SELECT CONCAT(
                users.username, ' (', profiles.first_name, ' ', profiles.last_name, '): ', COUNT(likes.id), ' likes'
            )
        FROM
            users
            JOIN profiles ON users.id = profiles.user_id
            JOIN posts ON users.id = posts.user_id
            LEFT JOIN likes ON posts.id = likes.post_id
        WHERE
            posts.created_at > '2021-10-10'
            AND (
                likes.liked_at > '2021-10-10'
                OR likes.liked_at IS NULL
            )
        GROUP BY
            users.username,
            profiles.first_name,
            profiles.last_name
        ORDER BY COUNT(likes.id) ASC
        LIMIT 1
    ) AS min_likes,
    (
        SELECT CONCAT(
                users.username, ' (', profiles.first_name, ' ', profiles.last_name, '): ', COUNT(likes.id), ' likes'
            )
        FROM
            users
            JOIN profiles ON users.id = profiles.user_id
            JOIN posts ON users.id = posts.user_id
            LEFT JOIN likes ON posts.id = likes.post_id
        WHERE
            posts.created_at > '2021-10-10'
            AND (
                likes.liked_at > '2021-10-10'
                OR likes.liked_at IS NULL
            )
        GROUP BY
            users.username,
            profiles.first_name,
            profiles.last_name
        ORDER BY COUNT(likes.id) DESC
        LIMIT 1
    ) AS max_likes

-- Optimized version
EXPLAIN
WITH
    UserPosts AS (
        SELECT u.id AS user_id, u.username, p.first_name, p.last_name, COUNT(po.id) AS post_count
        FROM
            users u
            JOIN profiles p ON u.id = p.user_id
            JOIN posts po ON u.id = po.user_id
        WHERE
            po.created_at > '2021-10-10'
        GROUP BY
            u.id,
            u.username,
            p.first_name,
            p.last_name
    ),
    UserLikes AS (
        SELECT u.id AS user_id, u.username, p.first_name, p.last_name, COUNT(l.id) AS like_count
        FROM
            users u
            JOIN profiles p ON u.id = p.user_id
            JOIN posts po ON u.id = po.user_id
            LEFT JOIN likes l ON po.id = l.post_id
        WHERE
            po.created_at > '2021-10-10'
            AND (
                l.liked_at > '2021-10-10'
                OR l.liked_at IS NULL
            )
        GROUP BY
            u.id,
            u.username,
            p.first_name,
            p.last_name
    )
SELECT (
        SELECT CONCAT(
                up.username, ' (', up.first_name, ' ', up.last_name, '): ', up.post_count, ' posts'
            )
        FROM UserPosts up
        ORDER BY up.post_count ASC
        LIMIT 1
    ) AS min_posts,
    (
        SELECT CONCAT(
                up.username, ' (', up.first_name, ' ', up.last_name, '): ', up.post_count, ' posts'
            )
        FROM UserPosts up
        ORDER BY up.post_count DESC
        LIMIT 1
    ) AS max_posts,
    (
        SELECT CONCAT(
                ul.username, ' (', ul.first_name, ' ', ul.last_name, '): ', ul.like_count, ' likes'
            )
        FROM UserLikes ul
        ORDER BY ul.like_count ASC
        LIMIT 1
    ) AS min_likes,
    (
        SELECT CONCAT(
                ul.username, ' (', ul.first_name, ' ', ul.last_name, '): ', ul.like_count, ' likes'
            )
        FROM UserLikes ul
        ORDER BY ul.like_count DESC
        LIMIT 1
    ) AS max_likes;

CREATE INDEX idx_posts_user_created ON posts (user_id, created_at);
CREATE INDEX idx_posts_user_created ON posts (user_id, created_at);

SELECT
    u.id AS user_id,
    u.username,
    COUNT(po.id) AS post_count,
    COUNT(l.id) AS like_count
FROM
    users u
    JOIN profiles p ON u.id = p.user_id
    JOIN posts po ON u.id = po.user_id
    LEFT JOIN likes l ON po.id = l.post_id
WHERE
    po.created_at > '2021-10-10' 
GROUP BY
    u.id,
    u.username 
ORDER BY like_count DESC LIMIT 10;