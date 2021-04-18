USE vk;

-- 1
-- поис пользователей, с учетом их даты рождения, страны проживания
CREATE INDEX profiles_birthday_idx ON profiles(birthday);
CREATE INDEX profiles_country_idx ON profiles(country);
-- Поиск по медиафайлам
CREATE INDEX media_filename_idx ON media(filename);
-- Поиск по названиям сообществ
CREATE INDEX communities_name_idx ON communities(name);
-- Поиск по заголовкам постов
CREATE INDEX posts_head_idx ON posts(head);
-- Поиск по текстам постов
CREATE FULLTEXT INDEX posts_body_idx ON posts(body);
-- Нужно будет осуществлять поиск по постам, смотреть архивированы они или нет
CREATE INDEX profiles_is_archived_idx ON posts(is_archived);
-- Пользователь захочет смотреть сначала свежие посты
CREATE INDEX profiles_created_at_idx ON posts(created_at);


-- 2 
SELECT 
       c.name as group_name,                                                                                                            
       FIRST_VALUE(TIMESTAMPDIFF(year, p.birthday, now())) OVER (PARTITION BY c.name order by p.birthday desc) as min_age_in_group,
       LAST_VALUE(TIMESTAMPDIFF(year, p.birthday, now())) OVER (PARTITION BY c.name order by p.birthday desc) as max_age_in_group,
       count(c.id) over (PARTITION BY c.name) as count_user_in_curent_group,
       count(c.id) over () as count_user_in_system
FROM communities c
    JOIN communities_users cu on c.id = cu.community_id
    JOIN profiles p on cu.user_id = p.user_id
ORDER BY TIMESTAMPDIFF(year, p.birthday, now());