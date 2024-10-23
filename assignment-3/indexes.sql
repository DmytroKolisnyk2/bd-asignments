-- makes request 2x faster
CREATE INDEX idx_posts_title ON Posts (title (10));

with
    filtered_posts as (
        SELECT *
        FROM Posts
        WHERE
            title LIKE 'sol%'
    )
SELECT p.post_id, p.title, p.text, p.media_url, p.created_at, COUNT(pl.like_id) AS like_count
FROM
    filtered_posts p
    LEFT JOIN PostLikes pl ON p.post_id = pl.post_id
GROUP BY
    p.post_id,
    p.title,
    p.text,
    p.media_url,
    p.created_at
ORDER BY like_count DESC;

-- makes request 150x faster
CREATE INDEX idx_commentlikes_created_at ON CommentLikes (created_at);

SELECT * FROM CommentLikes ORDER BY created_at DESC LIMIT 1;