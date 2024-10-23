CREATE DATABASE assignment_3;

USE assignment_3;

-- Users table storing information about registered users
CREATE TABLE User (
    user_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Primary key, unique identifier for each user',
    username VARCHAR(50) NOT NULL COMMENT 'Username of the user, must be unique',
    email VARCHAR(100) NOT NULL UNIQUE COMMENT 'User email address, must be unique',
    password_hash VARCHAR(255) NOT NULL COMMENT 'Hashed password for user authentication',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp of when the user was created'
) COMMENT = 'Table storing registered users information';

-- Profiles table storing additional information related to users
CREATE TABLE Profile (
    profile_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Primary key, unique identifier for each profile',
    user_id INT UNIQUE COMMENT 'Foreign key linking to User table, each user has one profile',
    first_name VARCHAR(50) COMMENT 'User’s first name',
    last_name VARCHAR(50) COMMENT 'User’s last name',
    phone_number VARCHAR(20) COMMENT 'User’s phone number',
    address VARCHAR(255) COMMENT 'User’s address',
    FOREIGN KEY (user_id) REFERENCES User (user_id) ON DELETE CASCADE
) COMMENT = 'Table storing additional information related to users';

-- Posts table storing posts created by users
CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Primary key, unique identifier for each post',
    user_id INT COMMENT 'Foreign key linking to User table, indicates who created the post',
    title TEXT NOT NULL COMMENT 'Title of the post',
    text TEXT NOT NULL COMMENT 'Content of the post',
    media_url VARCHAR(255) COMMENT 'URL to any media attached to the post',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp of when the post was created',
    FOREIGN KEY (user_id) REFERENCES User (user_id) ON DELETE CASCADE
) COMMENT = 'Table storing posts created by users';

-- Comments table storing comments made on posts
CREATE TABLE Comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Primary key, unique identifier for each comment',
    post_id INT COMMENT 'Foreign key linking to Posts table, indicates the post being commented on',
    user_id INT COMMENT 'Foreign key linking to User table, indicates who made the comment',
    text TEXT NOT NULL COMMENT 'Content of the comment',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp of when the comment was made',
    FOREIGN KEY (post_id) REFERENCES Posts (post_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES User (user_id) ON DELETE CASCADE
) COMMENT = 'Table storing comments on posts';

-- PostLikes table managing likes on posts by users
CREATE TABLE PostLikes (
    like_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Primary key, unique identifier for each post like',
    post_id INT COMMENT 'Foreign key linking to Posts table, indicates the liked post',
    user_id INT COMMENT 'Foreign key linking to User table, indicates who liked the post',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp of when the post was liked',
    FOREIGN KEY (post_id) REFERENCES Posts (post_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES User (user_id) ON DELETE CASCADE
) COMMENT = 'Table storing likes on posts by users';

-- CommentLikes table managing likes on comments by users
CREATE TABLE CommentLikes (
    like_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Primary key, unique identifier for each comment like',
    comment_id INT COMMENT 'Foreign key linking to Comments table, indicates the liked comment',
    user_id INT COMMENT 'Foreign key linking to User table, indicates who liked the comment',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp of when the comment was liked',
    FOREIGN KEY (comment_id) REFERENCES Comments (comment_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES User (user_id) ON DELETE CASCADE
) COMMENT = 'Table storing likes on comments by users';

DROP TABLE IF EXISTS PostLikes;
DROP TABLE IF EXISTS CommentLikes;
DROP TABLE IF EXISTS Profile;
DROP TABLE IF EXISTS Comments;
DROP TABLE IF EXISTS Posts;
DROP TABLE IF EXISTS User;
