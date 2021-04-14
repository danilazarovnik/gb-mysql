-- задание 3 лайки мужские и женские, кто больше
SELECT COUNT(id) FROM likes WHERE like_type = 1 
IN 
(SELECT user_id FROM profiles WHERE gender_id = 1) 
UNION  
SELECT COUNT(id) FROM likes WHERE like_type = 1 
IN 
(SELECT user_id FROM profiles WHERE gender_id = 2);
   

-- занадие 4 сумма лайков полученных 10 самыми молодыми
SELECT SUM(like_type) FROM likes WHERE target_id
	IN 
	(SELECT * FROM 
		(SELECT user_id FROM profiles 
   		ORDER BY birthday DESC LIMIT 10)
   	likes);
   
-- задание 5 критерии не активности: без фото и с дизлайками
SELECT user_id FROM profiles WHERE photo_id IS NULL 
AND user_id IN
(SELECT user_id FROM likes WHERE like_type = 0);

    

