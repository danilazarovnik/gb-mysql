-- задание 3 лайки мужские и женские, кто больше
SELECT COUNT(id) FROM likes WHERE like_type = 1
AND user_id IN
(SELECT user_id FROM profiles WHERE gender_id = 1)
UNION
SELECT COUNT(id) FROM likes WHERE like_type = 1
AND user_id IN
(SELECT user_id FROM profiles WHERE gender_id = 2);

-- join запрос
SELECT COUNT(gender_id) FROM profiles p
JOIN likes l ON l.user_id = p.user_id WHERE l.like_type = 1
GROUP BY gender_id

-- занадие 4 сумма лайков полученных 10 самыми молодыми
-- без вложенного запроса не могу понять как это выполнить

SELECT SUM(l.like_type) 
FROM profiles p
JOIN likes l ON l.target_id = p.user_id 
IN 
	(SELECT * FROM 
		(SELECT p.user_id FROM profiles p
   		ORDER BY p.birthday DESC LIMIT 10)
   	likes)
WHERE l.like_type = 1


-- 5 Найти 10 пользователей, которые проявляют наименьшую активность
-- не сделаною времени не хватило
SELECT 
  CONCAT(first_name, ' ', last_name) AS user, 
	(SELECT COUNT(*) FROM likes WHERE likes.user_id = profiles.user_id) +
	(SELECT COUNT(*) FROM media WHERE media.user_id = profiles.user_id) +
	(SELECT COUNT(*) FROM messages WHERE messages.from_user_id = profiles.user_id) AS overall_activity 
	  FROM profiles
	  ORDER BY overall_activity
	  LIMIT 10;


    

