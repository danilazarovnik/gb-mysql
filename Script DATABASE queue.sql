CREATE DATABASE queue
-- база электронной очереди для клиентов в банке

USE queue

DROP TABLE IF EXISTS windows;
CREATE TABLE windows (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
	number_win INT UNSIGNED NOT NULL COMMENT "Номер окна (рабочего места)",
	win_category_id INT UNSIGNED NOT NULL COMMENT "Идентификатор окна", 
	post_id_win INT UNSIGNED NOT NULL COMMENT "Под какую должность настроено окно",
	status_id INT UNSIGNED NOT NULL COMMENT "Статус окна",
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Окна-рабочие места для сотрудников";

DROP TABLE IF EXISTS win_category;
CREATE TABLE win_category (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
	category VARCHAR (30) COMMENT "Категория окна",
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Категории окон";
		-- разделяют длинные (вызываются сложные, длительные операции первым приоритетом), 
		-- короткие (быстрые операции), окна менеджеров
		-- в зависимости от должности и стажа сотрудник может работать только на определенном месте

DROP TABLE IF EXISTS win_status;
CREATE TABLE win_status (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
	status VARCHAR (30) COMMENT "Статус окна",
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Статуты окон";
		-- перерыв, простой, обслуживает, закрыто

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
	login VARCHAR(150) COMMENT "Логин пользователя",
	first_name VARCHAR(150) COMMENT "Имя пользователя",
	last_name VARCHAR(150) COMMENT "Фамилия пользователя",
	experience_mnth INT UNSIGNED COMMENT "Стаж работы в должности в месяцах",
		-- в зависимости от стажа сотрудник может занимать только определенные рабочие места
	post_id INT UNSIGNED NOT NULL COMMENT "Идентификатор долженности",
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Сотрудники";

DROP TABLE IF EXISTS post;
CREATE TABLE post (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
	post_sm VARCHAR (10) COMMENT "Сокращенное наименование долженности",
	post_full VARCHAR (100) COMMENT "Полное наименование долженности",
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Должности сотрудников";

DROP TABLE IF EXISTS operation_category;
CREATE TABLE operation_category (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
	letter VARCHAR (2) COMMENT "Буквенное обозначение категории операции",
	name_operation VARCHAR (100) COMMENT "Название категории операции",
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  	updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Категории операций";

DROP TABLE IF EXISTS tickets;
CREATE TABLE tickets (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
	number_tickets INT UNSIGNED NOT NULL COMMENT "Номер талона",
	letter_id INT UNSIGNED NOT NULL COMMENT "Индекс буквенного обозначения категории операции талона",
			-- это то, что печатается на талоне электронной очереди
	win_number_id INT UNSIGNED,
	created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT "Время взятия клиентом талона",
	calling_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT "Время вызова талона в окно",
	timeservice_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT "Время завершения обслуживания"
) COMMENT "Талоны";

ALTER TABLE windows
DROP CONSTRAINT windows_fk_post_id_win,
DROP CONSTRAINT windows_fk_win_category_id,
DROP CONSTRAINT windows_fk_status_id;
ALTER TABLE windows
  ADD CONSTRAINT windows_fk_post_id_win
    FOREIGN KEY (post_id_win) REFERENCES post(id),
  ADD CONSTRAINT windows_fk_win_category_id
    FOREIGN KEY (win_category_id) REFERENCES win_category(id),
  ADD CONSTRAINT windows_fk_status_id
    FOREIGN KEY (status_id) REFERENCES win_status(id);
   
ALTER TABLE users 
DROP CONSTRAINT users_fk_post_id;
ALTER TABLE users 
  ADD CONSTRAINT users_fk_post_id
    FOREIGN KEY (post_id) REFERENCES post(id);
   
ALTER TABLE tickets 
DROP CONSTRAINT tickets_fk_letter_id,
DROP CONSTRAINT tickets_fk_win_number_id;
ALTER TABLE tickets 
  ADD CONSTRAINT tickets_fk_letter_id
    FOREIGN KEY (letter_id) REFERENCES operation_category(id),
  ADD CONSTRAINT tickets_fk_win_number_id
    FOREIGN KEY (win_number_id) REFERENCES windows(id);

-- ЗАПОЛНЕНИЕ ТАБЛИЦ

-- Категории операций
INSERT INTO `operation_category` (`id`, `letter`, `name_operation`, `created_at`, `updated_at`) 
VALUES (1, 'П', 'Платежи', '2011-11-12 10:11:22', '2018-08-11 17:36:43');
INSERT INTO `operation_category` (`id`, `letter`, `name_operation`, `created_at`, `updated_at`) 
VALUES (2, 'Н', 'Наличные. Снять, положить', '2001-02-26 16:13:15', '2014-08-17 22:34:53');
INSERT INTO `operation_category` (`id`, `letter`, `name_operation`, `created_at`, `updated_at`) 
VALUES (3, 'В', 'Вклад', '1972-06-28 11:38:09', '1981-03-22 13:28:24');
INSERT INTO `operation_category` (`id`, `letter`, `name_operation`, `created_at`, `updated_at`) 
VALUES (4, 'К', 'Кредит', '1978-10-12 08:23:43', '1991-07-06 19:41:34');
INSERT INTO `operation_category` (`id`, `letter`, `name_operation`, `created_at`, `updated_at`) 
VALUES (5, 'И', 'Ипотека', '1986-04-14 01:08:32', '2010-06-24 14:45:44');
INSERT INTO `operation_category` (`id`, `letter`, `name_operation`, `created_at`, `updated_at`) 
VALUES (6, 'С', 'Справки', '1986-03-10 18:55:36', '1997-11-10 17:40:48');
INSERT INTO `operation_category` (`id`, `letter`, `name_operation`, `created_at`, `updated_at`) 
VALUES (7, 'М', 'Монеты, обмен валюты', '2013-03-04 09:22:57', '1971-10-16 02:50:21');

SELECT * FROM operation_category;

-- Должности сотрудников
INSERT INTO `post` (`id`, `post_sm`, `post_full`, `created_at`, `updated_at`) 
VALUES (1, 'СМО', 'Старший менеджер по обслуживанию', '2011-04-29 07:56:22', '1994-03-14 04:30:36');
INSERT INTO `post` (`id`, `post_sm`, `post_full`, `created_at`, `updated_at`) 
VALUES (2, 'МО', 'Менеджер по обслуживанию', '1993-11-01 06:11:54', '2002-06-01 02:32:31');
INSERT INTO `post` (`id`, `post_sm`, `post_full`, `created_at`, `updated_at`) 
VALUES (3, 'МП', 'Менеджер по продажам', '1998-10-27 14:49:38', '1992-03-10 15:01:47');
INSERT INTO `post` (`id`, `post_sm`, `post_full`, `created_at`, `updated_at`) 
VALUES (4, 'КС', 'Консультант', '1983-12-12 12:30:29', '1988-09-01 13:37:39');

SELECT * FROM post;

-- Талоны
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (1, 1, 1, 3, '2021-04-15 09:00:00', '2021-04-15 09:00:00', '2021-04-15 09:03:00'); -- п
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (2, 2, 1, 4, '2021-04-15 09:00:10', '2021-04-15 09:00:10', '2021-04-15 09:02:10'); -- п
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (3, 1, 2, 5, '2021-04-15 09:01:00', '2021-04-15 09:01:00', '2021-04-15 09:11:23'); -- н
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (4, 3, 1, 1, '2021-04-15 09:01:30', '2021-04-15 09:12:30', '2021-04-15 09:21:30'); -- п 
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (5, 4, 1, 3, '2021-04-15 09:05:00', '2021-04-15 09:05:00', '2021-04-15 09:09:00'); -- п
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (6, 2, 2, 2, '2021-04-15 09:06:00', '2021-04-15 09:09:00', '2021-04-15 09:11:00'); -- н
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (7, 3, 2, 3, '2021-04-15 09:13:00', '2021-04-15 09:13:00', '2021-04-15 09:17:00'); -- н
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (8, 1, 4, 6, '2021-04-15 09:14:00', '2021-04-15 09:19:00', '2021-04-15 09:44:00'); -- к
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (9, 1, 3, 7, '2021-04-15 09:14:24', '2021-04-15 09:26:24', '2021-04-15 09:34:24'); -- в
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (10, 2, 3, 8, '2021-04-15 09:34:00', '2021-04-15 09:34:00', '2021-04-15 09:53:00'); -- в
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (11, 1, 7, 5, '2021-04-15 09:46:00', '2021-04-15 09:46:00', '2021-04-15 09:48:00'); -- м
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (12, 2, 7, 5, '2021-04-15 09:46:10', '2021-04-15 09:48:10', '2021-04-15 09:50:00'); -- м
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (13, 1, 6, 1, '2021-04-15 09:50:00', '2021-04-15 09:50:00', '2021-04-15 09:59:00'); -- с
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (14, 2, 6, 2, '2021-04-15 09:51:00', '2021-04-15 09:51:00', '2021-04-15 09:56:00'); -- с
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (15, 4, 2, 3, '2021-04-15 10:10:00', '2021-04-15 10:21:00', '2021-04-15 10:23:00'); -- н
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (16, 5, 2, 4, '2021-04-15 10:13:00', '2021-04-15 10:14:00', '2021-04-15 10:17:00'); -- н
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (17, 1, 5, 9, '2021-04-15 10:42:00', '2021-04-15 10:42:00', '2021-04-15 10:55:00'); -- и
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (18, 5, 1, 5, '2021-04-15 10:48:00', '2021-04-15 10:48:00', '2021-04-15 10:50:00'); -- п
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (19, 2, 4, 6, '2021-04-15 10:50:00', '2021-04-15 10:56:00', '2021-04-15 11:22:00'); -- к
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (20, 3, 7, 5, '2021-04-15 10:52:00', '2021-04-15 11:04:00', '2021-04-15 11:06:00'); -- м
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (21, 3, 3, 7, '2021-04-15 10:55:00', '2021-04-15 10:55:00', '2021-04-15 11:12:00'); -- в
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (22, 3, 6, 1, '2021-04-15 11:10:00', '2021-04-15 11:10:00', '2021-04-15 11:38:00'); -- с
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (23, 6, 2, 3, '2021-04-15 11:13:00', '2021-04-15 11:17:00', '2021-04-15 11:19:00'); -- н						
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (24, 6, 1, 4, '2021-04-15 11:22:00', '2021-04-15 11:22:00', '2021-04-15 11:27:00'); -- п
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (25, 2, 5, 8, '2021-04-15 11:24:00', '2021-04-15 11:24:00', '2021-04-15 11:57:00'); -- и
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (26, 4, 7, 5, '2021-04-15 11:37:00', '2021-04-15 11:37:00', '2021-04-15 11:39:00'); -- м
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (27, 7, 2, 3, '2021-04-15 11:39:00', '2021-04-15 11:50:00', '2021-04-15 11:55:00'); -- н
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (28, 8, 2, 4, '2021-04-15 11:40:00', '2021-04-15 11:40:00', '2021-04-15 11:43:00'); -- н
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (29, 3, 4, 9, '2021-04-15 11:41:00', '2021-04-15 11:41:00', '2021-04-15 11:41:00'); -- к
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (30, 7, 1, 3, '2021-04-15 11:55:00', '2021-04-15 11:56:00', '2021-04-15 11:59:34'); -- п
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (31, 9, 2, 4, '2021-04-15 11:55:30', '2021-04-15 11:59:30', '2021-04-15 12:12:30'); -- н
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (32, 4, 3, 6, '2021-04-15 11:57:00', '2021-04-15 11:57:00', '2021-04-15 12:24:00'); -- в
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (33, 8, 1, 5, '2021-04-15 11:59:00', '2021-04-15 11:59:00', '2021-04-15 12:10:00'); -- п
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (34, 9, 1, 3, '2021-04-15 12:06:00', '2021-04-15 12:06:00', '2021-04-15 12:11:00'); -- п
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (35, 4, 6, 2, '2021-04-15 12:13:00', '2021-04-15 12:13:40', '2021-04-15 12:49:00'); -- с
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (36, 10, 2, 4, '2021-04-15 12:17:00', '2021-04-15 12:28:00', '2021-04-15 12:34:00'); -- н
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (37, 11, 2, 3, '2021-04-15 12:32:00', '2021-04-15 12:39:00', '2021-04-15 12:43:00'); -- н
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (38, 5, 7, 5, '2021-04-15 12:49:00', '2021-04-15 12:50:00', '2021-04-15 12:53:00'); -- м
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (39, 10, 1, 3, '2021-04-15 13:01:00', '2021-04-15 13:01:00', '2021-04-15 13:10:00'); -- п
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (40, 11, 1, 4, '2021-04-15 13:04:00', '2021-04-15 13:11:00', '2021-04-15 13:34:00'); -- п
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (41, 12, 2, 5, '2021-04-15 13:04:47', '2021-04-15 13:04:47', '2021-04-15 13:08:47'); -- н
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (42, 13, 2, 3, '2021-04-15 13:09:00', '2021-04-15 13:09:00', '2021-04-15 13:15:00'); -- н
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (43, 14, 2, 4, '2021-04-15 13:21:00', '2021-04-15 13:21:00', '2021-04-15 13:35:00'); -- н
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (44, 4, 4, 7, '2021-04-15 13:26:00', '2021-04-15 13:26:00', '2021-04-15 13:55:00'); -- к
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (45, 5, 6, 1, '2021-04-15 13:34:00', '2021-04-15 13:47:00', '2021-04-15 13:49:00'); -- с
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (46, 6, 6, 2, '2021-04-15 13:38:00', '2021-04-15 13:47:10', '2021-04-15 13:53:00'); -- с
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (47, 5, 3, 8, '2021-04-15 13:40:00', '2021-04-15 13:40:00', '2021-04-15 13:57:00'); -- в
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (48, 12, 1, 3, '2021-04-15 13:55:00', '2021-04-15 13:55:00', '2021-04-15 13:59:00'); -- п
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (49, 15, 2, 5, '2021-04-15 13:57:00', '2021-04-15 13:57:00', '2021-04-15 13:59:00'); -- н
INSERT INTO `tickets` (`id`, `number_tickets`, `letter_id`, `win_number_id`, `created_at`, `calling_at`, `timeservice_at`) 
VALUES (50, 16, 2, 4, '2021-04-15 13:59:00', '2021-04-15 14:01:00', '2021-04-15 14:06:00'); -- н

SELECT * FROM tickets;

-- Сотрудники
INSERT INTO `users` (`id`, `login`, `first_name`, `last_name`, `experience_mnth`, `post_id`, `created_at`, `updated_at`) 
VALUES (1, 'zspinka@bahringer.com', 'Erica', 'Gutmann', 8, 1, '1988-09-03 06:46:08', '2007-09-19 14:54:18');
INSERT INTO `users` (`id`, `login`, `first_name`, `last_name`, `experience_mnth`, `post_id`, `created_at`, `updated_at`) 
VALUES (2, 'hamill.ron@yahoo.com', 'Colton', 'Cummerata', 4, 2, '1989-02-24 00:20:09', '1986-06-05 17:50:06');
INSERT INTO `users` (`id`, `login`, `first_name`, `last_name`, `experience_mnth`, `post_id`, `created_at`, `updated_at`) 
VALUES (3, 'raynor.katelin@yahoo.com', 'Erwin', 'Lakin', 0, 3, '1973-04-14 05:21:50', '1979-08-14 01:12:43');
INSERT INTO `users` (`id`, `login`, `first_name`, `last_name`, `experience_mnth`, `post_id`, `created_at`, `updated_at`) 
VALUES (4, 'hayes.alden@zulauf.com', 'Brenna', 'Brakus', 7, 4, '2010-09-12 18:33:27', '2006-05-04 17:49:33');
INSERT INTO `users` (`id`, `login`, `first_name`, `last_name`, `experience_mnth`, `post_id`, `created_at`, `updated_at`) 
VALUES (5, 'clement.o\'hara@gmail.com', 'Christiana', 'Nolan', 6, 1, '2017-03-20 14:25:44', '2006-12-16 11:03:35');
INSERT INTO `users` (`id`, `login`, `first_name`, `last_name`, `experience_mnth`, `post_id`, `created_at`, `updated_at`) 
VALUES (6, 'yasmin26@hotmail.com', 'Khalid', 'Pouros', 3, 2, '2011-10-17 02:27:25', '1998-04-28 20:44:10');
INSERT INTO `users` (`id`, `login`, `first_name`, `last_name`, `experience_mnth`, `post_id`, `created_at`, `updated_at`) 
VALUES (7, 'lang.josephine@gmail.com', 'Zoey', 'Reichel', 7, 3, '1980-06-05 02:05:50', '1998-01-12 18:20:24');
INSERT INTO `users` (`id`, `login`, `first_name`, `last_name`, `experience_mnth`, `post_id`, `created_at`, `updated_at`) 
VALUES (8, 'abbey39@ledner.com', 'Mitchel', 'McKenzie', 5, 4, '1985-03-23 20:39:48', '2015-01-22 22:05:40');
INSERT INTO `users` (`id`, `login`, `first_name`, `last_name`, `experience_mnth`, `post_id`, `created_at`, `updated_at`) 
VALUES (9, 'erna30@yahoo.com', 'Amber', 'Ziemann', 6, 1, '1977-10-25 13:18:17', '2013-12-17 02:40:01');
INSERT INTO `users` (`id`, `login`, `first_name`, `last_name`, `experience_mnth`, `post_id`, `created_at`, `updated_at`) 
VALUES (10, 'dbeer@yahoo.com', 'Berniece', 'Bins', 6, 2, '1999-02-24 08:08:44', '1990-01-14 19:56:00');
INSERT INTO `users` (`id`, `login`, `first_name`, `last_name`, `experience_mnth`, `post_id`, `created_at`, `updated_at`) 
VALUES (11, 'noelia.crist@ward.com', 'Michale', 'Beahan', 1, 3, '1984-12-01 08:45:57', '1986-08-27 12:41:27');
INSERT INTO `users` (`id`, `login`, `first_name`, `last_name`, `experience_mnth`, `post_id`, `created_at`, `updated_at`) 
VALUES (12, 'rhoda62@hotmail.com', 'Gabe', 'Douglas', 8, 4, '2009-03-10 17:11:37', '1993-12-23 20:49:35');
INSERT INTO `users` (`id`, `login`, `first_name`, `last_name`, `experience_mnth`, `post_id`, `created_at`, `updated_at`) 
VALUES (13, 'o\'hara.lionel@halvorson.com', 'Marie', 'Hessel', 9, 1, '1976-10-15 00:24:50', '1995-08-21 19:25:39');
INSERT INTO `users` (`id`, `login`, `first_name`, `last_name`, `experience_mnth`, `post_id`, `created_at`, `updated_at`) 
VALUES (14, 'marques.abshire@yahoo.com', 'Olga', 'Hoppe', 1, 2, '1987-02-26 10:59:11', '2006-10-30 07:56:59');
INSERT INTO `users` (`id`, `login`, `first_name`, `last_name`, `experience_mnth`, `post_id`, `created_at`, `updated_at`) 
VALUES (15, 'aerdman@kuphal.info', 'Enos', 'Smith', 4, 3, '2015-02-15 18:06:21', '2012-07-20 19:59:36');

SELECT * FROM users;

-- Категории окон
INSERT INTO `win_category` (`id`, `category`, `created_at`, `updated_at`) 
VALUES (1, 'Короткое', '2007-04-14 06:44:33', '1977-11-27 17:45:28');
INSERT INTO `win_category` (`id`, `category`, `created_at`, `updated_at`) 
VALUES (2, 'Длинное', '2007-04-14 06:44:33', '1977-11-27 17:45:28');
INSERT INTO `win_category` (`id`, `category`, `created_at`, `updated_at`) 
VALUES (3, 'Менеджера по продажам', '2007-04-14 06:44:33', '1977-11-27 17:45:28');

SELECT * FROM win_category;

-- Статуты окон
INSERT INTO `win_status` (`id`, `status`, `created_at`, `updated_at`)
VALUES (1, 'Открыто', '2006-10-20 11:12:08', '1999-06-28 05:39:53');
INSERT INTO `win_status` (`id`, `status`, `created_at`, `updated_at`) 
VALUES (2, 'Закрыто', '1975-02-04 20:08:19', '1976-12-29 17:13:42');
INSERT INTO `win_status` (`id`, `status`, `created_at`, `updated_at`) 
VALUES (3, 'Перерыв', '2018-12-02 04:20:07', '2002-01-23 10:04:34');
INSERT INTO `win_status` (`id`, `status`, `created_at`, `updated_at`) 
VALUES (4, 'Простой', '2019-09-15 10:03:52', '1998-05-10 09:16:10');

SELECT * FROM win_status;

UPDATE
  win_status
SET
  created_at = NOW(),
  updated_at = NOW();

-- Окна-рабочие места для сотрудников
INSERT INTO `windows` (`id`, `number_win`, `win_category_id`, `post_id_win`, `status_id`, `created_at`, `updated_at`)
VALUES (1, 1, 2, 1, 1, '2011-04-16 09:04:30', '2014-12-04 05:51:31');
INSERT INTO `windows` (`id`, `number_win`, `win_category_id`, `post_id_win`, `status_id`, `created_at`, `updated_at`) 
VALUES (2, 2, 2, 1, 1, '1994-07-02 02:26:41', '1994-01-13 03:19:04');
INSERT INTO `windows` (`id`, `number_win`, `win_category_id`, `post_id_win`, `status_id`, `created_at`, `updated_at`) 
VALUES (3, 3, 1, 2, 1, '2000-01-18 14:41:56', '1983-11-18 00:39:22');
INSERT INTO `windows` (`id`, `number_win`, `win_category_id`, `post_id_win`, `status_id`, `created_at`, `updated_at`) 
VALUES (4, 4, 1, 2, 2, '1980-12-07 02:37:11', '2012-04-13 01:40:43');
INSERT INTO `windows` (`id`, `number_win`, `win_category_id`, `post_id_win`, `status_id`, `created_at`, `updated_at`) 
VALUES (5, 5, 1, 2, 3, '1995-05-12 18:54:02', '2006-05-25 00:53:32');
INSERT INTO `windows` (`id`, `number_win`, `win_category_id`, `post_id_win`, `status_id`, `created_at`, `updated_at`) 
VALUES (6, 6, 3, 3, 1, '1978-09-21 12:21:32', '1972-07-22 03:35:23');
INSERT INTO `windows` (`id`, `number_win`, `win_category_id`, `post_id_win`, `status_id`, `created_at`, `updated_at`) 
VALUES (7, 7, 3, 3, 1, '1982-03-12 09:03:56', '2007-07-27 05:25:36');
INSERT INTO `windows` (`id`, `number_win`, `win_category_id`, `post_id_win`, `status_id`, `created_at`, `updated_at`) 
VALUES (8, 8, 3, 3, 4, '2019-01-06 19:46:40', '2013-11-18 12:23:05');
INSERT INTO `windows` (`id`, `number_win`, `win_category_id`, `post_id_win`, `status_id`, `created_at`, `updated_at`) 
VALUES (9, 9, 3, 3, 4, '1978-03-19 17:53:17', '1996-07-24 18:36:31');
INSERT INTO `windows` (`id`, `number_win`, `win_category_id`, `post_id_win`, `status_id`, `created_at`, `updated_at`) 
VALUES (10, 10, 3, 3, 3, '1992-02-08 11:57:13', '1987-11-05 05:38:38');

SELECT * FROM windows;

-- колличество обслужанных талонов в каждом окне
SELECT COUNT(t.win_number_id) AS TOTAL
FROM tickets t
GROUP BY win_number_id;

-- колличество талонов по категориям
SELECT COUNT(t.letter_id) AS TOTAL, oc.letter, oc.name_operation 
FROM tickets t
JOIN operation_category oc ON oc.id = t.letter_id 
GROUP BY t.letter_id;

-- информация по сотрудникам
SELECT CONCAT_WS (' ', u.first_name, u.last_name) as user_name, u.login, p.post_full, u.experience_mnth
FROM users u
JOIN post p ON p.id = u.post_id;

-- сколько ококон по категориям
SELECT wc.category, COUNT(w.id) AS TOTAL
FROM win_category wc
JOIN windows w ON wc.id = w.win_category_id
GROUP BY wc.category;
