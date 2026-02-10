-- Таблици:
CREATE DATABASE news;
USE news;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fullname VARCHAR(255) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    user_password VARCHAR(255) NOT NULL,
    registered_at DATETIME DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) UNIQUE NOT NULL
);


CREATE TABLE authors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE,
    bio TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);


CREATE TABLE moderators (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE,
    joined_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);


CREATE TABLE articles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    author_id INT NOT NULL,
    category_id INT NOT NULL,
    published_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    views INT DEFAULT 0,
    FOREIGN KEY (author_id) REFERENCES authors(id),
    FOREIGN KEY (category_id) REFERENCES categories(id)
);


CREATE TABLE comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    article_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    posted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE likes (
    user_id INT NOT NULL,
    article_id INT NOT NULL,
    liked_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, article_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE
);

CREATE TABLE media (
    id INT AUTO_INCREMENT PRIMARY KEY,
    article_id INT,
    media_type ENUM('image', 'video') NOT NULL,
    url VARCHAR(255) NOT NULL,
    uploaded_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    caption VARCHAR(255),
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE
);


CREATE TABLE tags (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tag_name VARCHAR(50) UNIQUE NOT NULL
);


CREATE TABLE article_tags (
    article_id INT NOT NULL,
    tag_id INT NOT NULL,
    PRIMARY KEY (article_id, tag_id),
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
);


CREATE TABLE featured_articles (
    article_id INT PRIMARY KEY,
    featured_from DATETIME NOT NULL,
    featured_until DATETIME,
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE
);


CREATE TABLE banned_users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE,
    reason TEXT NOT NULL,
    banned_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    banned_by INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (banned_by) REFERENCES moderators(id)
);


CREATE TABLE notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    notification_type ENUM('comment', 'like', 'new article', 'system') NOT NULL,
    message VARCHAR(255),
    is_read BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- proveri kolko e vajno i dali da se maha
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);


CREATE TABLE article_revisions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    article_id INT NOT NULL,
    revised_by INT NOT NULL,
    revised_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    old_title VARCHAR(255),
    old_content TEXT,
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,
    FOREIGN KEY (revised_by) REFERENCES authors(id)
);


CREATE TABLE bookmarks (
    user_id INT NOT NULL,
    article_id INT NOT NULL,
    bookmarked_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, article_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE
);


CREATE TABLE user_interests (
    user_id INT NOT NULL,
    tag_id INT NOT NULL,
    interest_level INT DEFAULT 1, 
    PRIMARY KEY (user_id, tag_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (tag_id) REFERENCES tags(id)
);


CREATE TABLE article_views (
    user_id INT NOT NULL,
    article_id INT NOT NULL,
    viewed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, article_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (article_id) REFERENCES articles(id)
);


CREATE TABLE payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    moderator_id INT,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (moderator_id) REFERENCES moderators(id)
);




-- Записи:




USE news;
INSERT INTO users (fullname, username, email, user_password)
VALUES
('Ivan Petrov', 'ivanp', 'ivan@example.com', 'pass1'),
('Maria Georgieva', 'mariag', 'maria@example.com', 'pass2'),
('Petar Dimitrov', 'nikolad', 'nikola@example.com', 'pass3'),
('Anna Stoycheva', 'annas', 'anna@example.com', 'pass4'),
('Georgi Ivanov', 'georgii', 'georgii@example.com', 'pass5'),
('Petya Koleva', 'petyak', 'petya@example.com', 'pass6'),
('Dimitar Radev', 'dimitaro', 'dimitar@example.com', 'pass7');

INSERT INTO authors (user_id, bio)
VALUES
(1, 'Journalist with over 10 years of experience in politics.'),
(3, 'Technology enthusiast and editor in the tech section.');

INSERT INTO moderators (user_id)
VALUES
(2),
(4);

INSERT INTO categories (category_name)
VALUES
('Politics'),
('Technology'),
('Society'),
('Health');

INSERT INTO articles (title, content, author_id, category_id)
VALUES
('Elections 2025: What to Expect?', 'A complete analysis of the upcoming elections...', 1, 1),
('New Discoveries in AI Technology', 'Researchers have created a new AI...', 2, 2),
('How the Pandemic Changed Society', 'An overview of the long-term effects...', 1, 3);

INSERT INTO comments (article_id, user_id, content)
VALUES
(1, 2, 'Very interesting point of view!'),
(2, 4, 'This article is very helpful.'),
(1, 3, 'I expected more details.'),
(3, 7, '@#%$^#'),
(2, 5, 'AI technology is advancing so fast.'),
(1, 6, 'More details would be great.');

INSERT INTO tags (tag_name)
VALUES
('AI'),
('Politics'),
('Education');

INSERT INTO article_tags (article_id, tag_id)
VALUES
(1, 2),
(2, 1),
(3, 3);

INSERT INTO media (article_id, media_type, url, caption)
VALUES
(1, 'image', 'https://example.com/image1.jpg', 'Elections 2025'),
(2, 'video', 'https://example.com/video1.mp4', 'Interview with a researcher');

INSERT INTO featured_articles (article_id, featured_from, featured_until)
VALUES (3, '2025-04-01', '2025-04-30');

INSERT INTO banned_users (user_id, reason, banned_by)
VALUES
(7, 'Violation of comment rules.', 2);

INSERT INTO notifications (user_id, notification_type, message)
VALUES
(1, 'new article', 'A new article has been published in Technology!'),
(2, 'comment', 'Someone commented on your article.');

INSERT INTO user_interests (user_id, tag_id, interest_level)
VALUES
(1, 2, 3.0), 
(2, 1, 2.5);

INSERT INTO article_views (user_id, article_id)
VALUES
(1, 1),
(5, 2),
(3, 1);

INSERT INTO payments (moderator_id, amount)
VALUES
(1, 450.00),
(2, 500.00);


-- For TESTS

INSERT INTO comments (article_id, user_id, content)
VALUES
(1, 5, 'Nice!');

INSERT INTO tags (tag_name)
VALUES
('Sports');

INSERT INTO articles (title, content, author_id, category_id)
VALUES
('Microsoft Breakthrough', 'Engineers at microsoft have invented a new...', 1, 2);
