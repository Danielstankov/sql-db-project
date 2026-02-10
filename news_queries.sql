USE news;

SELECT * FROM payments;

-- Преглед на новините по -> Категории / Дата / Популярност

SELECT a.title, c.category_name
FROM articles a
JOIN categories c ON a.category_id = c.id
WHERE c.category_name = 'Politics';

SELECT * FROM articles
WHERE published_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
ORDER BY published_at DESC;

SELECT * FROM articles
ORDER BY views DESC
LIMIT 10;


-- Статистическа информация -> Най четена статия за месеца / Най коментирана статя за деня / Най-популярни автори за седмицата

SELECT * FROM articles
WHERE MONTH(published_at) = MONTH(NOW()) AND YEAR(published_at) = YEAR(NOW())
ORDER BY views DESC
LIMIT 1;

SELECT a.title, COUNT(c.id) AS comment_count
FROM articles a
JOIN comments c ON c.article_id = a.id
WHERE DATE(c.posted_at) = CURDATE()
GROUP BY a.id
ORDER BY comment_count DESC
LIMIT 3;

SELECT au.id AS author_id, u.fullname, SUM(a.views) AS total_views
FROM authors au
JOIN users u ON au.user_id = u.id
JOIN articles a ON a.author_id = au.id
WHERE a.published_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
GROUP BY au.id
ORDER BY total_views DESC
LIMIT 2;


-- Задачи: 2 до 9

-- 2. SELECT с ограничаващо условие
SELECT * FROM users
WHERE fullname LIKE 'P%';

-- 3. Агрегатна функция + GROUP BY
SELECT COUNT(c.id) AS comment_count, ar.title AS title  
FROM comments c  
JOIN articles ar ON c.article_id = ar.id  
GROUP BY ar.id;

-- 4. INNER JOIN
SELECT cat.category_name, u.fullname  
FROM users u  
JOIN authors a ON u.id = a.user_id  
JOIN articles ar ON a.id = ar.author_id  
JOIN categories cat ON ar.category_id = cat.id;

-- 5. OUTER JOIN
SELECT t.tag_name, ar.title  
FROM tags t  
LEFT JOIN article_tags artg ON t.id = artg.tag_id  
LEFT JOIN articles ar ON artg.article_id = ar.id;

-- 6. Вложен SELECT
SELECT * FROM articles
WHERE author_id = (
    SELECT author_id
    FROM articles
    GROUP BY author_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- 7. JOIN + агрегатна функция
SELECT cat.category_name, AVG(ar.views) AS average_views  
FROM articles ar  
JOIN categories cat ON ar.category_id = cat.id  
GROUP BY cat.id  
ORDER BY average_views DESC;

-- 8. Тригери
DELIMITER $$
CREATE TRIGGER update_article_views_count
AFTER INSERT ON article_views
FOR EACH ROW
BEGIN
    UPDATE articles
    SET views = views + 1
    WHERE id = NEW.article_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER update_interest_on_like
AFTER INSERT ON likes
FOR EACH ROW
BEGIN
    INSERT INTO user_interests (user_id, tag_id, interest_level)
    SELECT NEW.user_id, at.tag_id, 2
    FROM article_tags at
    WHERE at.article_id = NEW.article_id
    ON DUPLICATE KEY UPDATE interest_level = interest_level + 2;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER update_interest_on_bookmark
AFTER INSERT ON bookmarks
FOR EACH ROW
BEGIN
    INSERT INTO user_interests (user_id, tag_id, interest_level)
    SELECT NEW.user_id, at.tag_id, 3
    FROM article_tags at
    WHERE at.article_id = NEW.article_id
    ON DUPLICATE KEY UPDATE interest_level = interest_level + 3;
END$$
DELIMITER ;


INSERT INTO article_views (user_id, article_id, viewed_at) VALUES (4, 1, NOW());
INSERT INTO likes (user_id, article_id, liked_at) VALUES (2, 2, NOW());
INSERT INTO bookmarks (user_id, article_id, bookmarked_at) VALUES (3, 1, NOW());



-- 9. Процедура с курсор
DELIMITER $$

CREATE PROCEDURE pay_moderators()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE mod_id INT;
    DECLARE base_salary DECIMAL(10, 2);
    DECLARE extra DECIMAL(10, 2);
    DECLARE total_payment DECIMAL(10, 2);

    -- Курсор за всички модератори
    DECLARE mod_cursor CURSOR FOR
        SELECT id FROM moderators;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN mod_cursor;

    read_loop: LOOP
        FETCH mod_cursor INTO mod_id;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Проверка дали вече е платено този месец
        IF NOT EXISTS (
            SELECT 1 FROM payments
            WHERE moderator_id = mod_id
              AND MONTH(payment_date) = MONTH(CURDATE())
              AND YEAR(payment_date) = YEAR(CURDATE())
        ) THEN
            
            SET base_salary = 1000;

            -- Добавка за активност: брой баннати потребители този месец * 50
            SELECT COUNT(*) * 50 INTO extra
            FROM banned_users
            WHERE moderator_id = mod_id
              AND MONTH(banned_at) = MONTH(CURDATE())
              AND YEAR(banned_at) = YEAR(CURDATE());

            SET total_payment = base_salary + extra;

            INSERT INTO payments (moderator_id, amount, payment_date)
            VALUES (mod_id, total_payment, NOW());
        END IF;
    END LOOP;

    CLOSE mod_cursor;
END$$

DELIMITER ;


CALL pay_moderators();

SELECT * FROM payments ORDER BY payment_date DESC;


