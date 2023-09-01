# Task 1
# Count likes which were gotten by users less 12 years-old
SELECT COUNT(likes.media_id)
FROM likes
JOIN profiles ON likes.user_id=profiles.user_id
WHERE DATEDIFF(CURDATE(), STR_TO_DATE(birthday, '%Y-%m-%d')) < 12 * 365.25;

# Task 2
# Who gave more likes? Men or women?
SELECT profiles.gender, COUNT(*) AS like_count
FROM media
JOIN profiles ON media.user_id = profiles.user_id
LEFT JOIN likes ON media.id=likes.media_id
GROUP BY profiles.gender;

# Task 3
# All users who didn't send messages
SELECT users.id
FROM users
LEFT JOIN messages ON users.id = messages.from_user_id
WHERE messages.from_user_id IS NULL;

# Task 4
# Let some user be given. Of all the friends of this user, 
# find the person who wrote him the most messages.
USE semimar_4;
SELECT firstname, lastname, COUNT(messages.id) AS message_count
FROM users
RIGHT JOIN messages ON users.id = from_user_id
WHERE to_user_id = 1
group by users.id
ORDER BY message_count DESC
LIMIT 1;