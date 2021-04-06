-- 1.В базе данных shop и sample присутствуют одни и те же таблицы учебной базы данных.
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users.
-- Используйте транзакции.

DROP TABLE IF EXISTS sample.users;
CREATE TABLE sample.users LIKE shop.users;

USE shop;
SELECT * FROM shop.users;
SELECT * FROM sample.users;

START TRANSACTION;
  INSERT INTO sample.users SELECT * FROM shop.users WHERE id = 1;
  DELETE FROM shop.users WHERE id = 1;
COMMIT;

-- 2.Создайте представление, которое выводит название name товарной
-- позиции из таблицы products и соответствующее название каталога name
-- из таблицы catalogs.

CREATE OR REPLACE VIEW products_catalogs AS
SELECT
  p.name AS product,
  c.name AS catalog
FROM products AS p
JOIN catalogs AS c ON p.catalog_id = c.id;

SELECT * FROM products_catalogs;

-- 3.Пусть имеется таблица с календарным полем created_at.
-- В ней размещены разреженые календарные записи за август 2018 года '2018-08-01', '2018-08-04', 
-- '2018-08-16' и 2018-08-17. Составьте запрос, который выводит полный список дат за август, 
-- выставляя в соседнем поле значение 1, если дата присутствует в исходной таблице и 0, если она отсутствует.

DROP TABLE IF EXISTS august;
CREATE TABLE IF NOT EXISTS august (
  id SERIAL PRIMARY KEY,
  name VARCHAR(15),
  created_at DATE NOT NULL);

INSERT INTO august VALUES
(NULL, 'первая', '2018-08-01'),
(NULL, 'вторая', '2018-08-04'),
(NULL, 'третья', '2018-08-16'),
(NULL, 'четвертая', '2018-08-17');

DROP TABLE IF EXISTS all_days;
CREATE TEMPORARY TABLE all_days (
  day INT);

INSERT INTO all_days VALUES
(0), (1), (2), (3), (4),
(5), (6), (7), (8), (9), 
(10), (11), (12), (13), (14), 
(15), (16), (17), (18), (19), 
(20), (21), (22), (23), (24), 
(25), (26), (27), (28), (29), (30);

SELECT * FROM august;
SELECT * FROM all_days;

SELECT
  DATE(DATE('2018-08-31') - INTERVAL a_d.day DAY) AS day,
  NOT ISNULL(a.name) AS order_exists
FROM all_days AS a_d
LEFT JOIN august AS a
ON DATE(DATE('2018-08-31') - INTERVAL a_d.day DAY) = a.created_at
ORDER BY day;

-- 4.Пусть имеется любая таблица с календарным полем created_at. 
-- Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя
-- только 5 самых свежих записей.

DROP TABLE IF EXISTS posts;
CREATE TABLE IF NOT EXISTS posts (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  created_at DATE NOT NULL
);

INSERT INTO posts VALUES
(NULL, 'первая запись', '2018-11-01'),
(NULL, 'вторая запись', '2018-11-02'),
(NULL, 'третья запись', '2018-11-03'),
(NULL, 'четвертая запись', '2018-11-04'),
(NULL, 'пятая запись', '2018-11-05'),
(NULL, 'шестая запись', '2018-11-06'),
(NULL, 'седьмая запись', '2018-11-07'),
(NULL, 'восьмая запись', '2018-11-08'),
(NULL, 'девятая запись', '2018-11-09'),
(NULL, 'десятая запись', '2018-11-10'),
(NULL, 'одиннадцатая запись', '2018-11-11'),
(NULL, 'двенадцатая запись', '2018-11-12');

SELECT * FROM posts;

SELECT * FROM posts
JOIN (SELECT created_at FROM posts
  ORDER BY created_at DESC
  LIMIT 5, 1) AS delpst
ON posts.created_at <= delpst.created_at;

DELETE posts FROM posts
JOIN (SELECT created_at FROM posts
  ORDER BY created_at DESC
  LIMIT 5, 1) AS delpst
ON posts.created_at <= delpst.created_at;

SELECT * FROM posts;

-- Хранимые процедуры и функции, триггеры

-- 1.Создайте хранимую функцию hello(), которая будет возвращать приветствие,
-- в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна
-- возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать
-- фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 —
-- "Доброй ночи".

USE shop;

CREATE FUNCTION hello()
RETURNS TINYTEXT NO SQL
BEGIN
  DECLARE hour INT;
  SET hour = HOUR(NOW());
  CASE
    WHEN hour BETWEEN 0 AND 5 THEN
      RETURN "Доброй ночи";
    WHEN hour BETWEEN 6 AND 11 THEN
      RETURN "Доброе утро";
    WHEN hour BETWEEN 12 AND 17 THEN
      RETURN "Добрый день";
    WHEN hour BETWEEN 18 AND 23 THEN
      RETURN "Добрый вечер";
  END CASE;
END

SELECT NOW(), hello();