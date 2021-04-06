-- lesson 7
-- 1 Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
USE compshop;

INSERT INTO orders (user_id)
SELECT id FROM users WHERE name = 'Сергей';

INSERT INTO orders (user_id)
SELECT id FROM users WHERE name = 'Геннадий';

INSERT INTO orders (user_id)
SELECT id FROM users WHERE name = 'Наталья';

INSERT INTO orders (user_id)
SELECT id FROM users WHERE name = 'Иван';

SELECT * FROM orders;

SELECT u.id, u.name, u.birthday_at
FROM users AS u
JOIN orders AS o ON u.id = o.user_id;

SELECT DISTINCT u.id, u.name, u.birthday_at
FROM users AS u
JOIN orders AS o ON u.id = o.user_id;

-- 2 Выведите список товаров products и разделов catalogs, который соответствует товару.

SELECT p.name, c.name
FROM products AS p
LEFT JOIN catalogs AS c ON p.catalog_id = c.id;
     
-- 3 Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.

DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
  label_from VARCHAR(255) COMMENT 'Город отравления',
  label_to VARCHAR(255) COMMENT 'Город прибытия'
) COMMENT = 'Рейсы';

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
  id SERIAL PRIMARY KEY,
  label VARCHAR(255) COMMENT 'Код города',
  name VARCHAR(255) COMMENT 'Название города'
) COMMENT = 'Словарь городов';

INSERT INTO flights (label_from, label_to) VALUES
  ('moscow', 'omsk'),
  ('irkutsk', 'kazan'),
  ('novgorod', 'moscow'),
  ('kazan', 'novgorod'),
  ('omsk', 'irkutsk');
     
INSERT INTO cities (label, name) VALUES
  ('moscow', 'Москва'),
  ('irkutsk', 'Иркутск'),
  ('novgorod', 'Новгород'),
  ('kazan', 'Казань'),
  ('omsk', 'Омск');

SELECT * FROM flights;

SELECT f.id, c_from.name AS city_from, c_to.name AS city_to
FROM flights AS f
JOIN cities AS c_from ON f.label_from = c_from.label
JOIN cities AS c_to ON f.label_to = c_to.label;