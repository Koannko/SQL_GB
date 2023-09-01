use semimar_4;


/* 
Task 1
create view which contains 
info (firstname, lastname, hometown and gender)
about users younger than 20 
*/

create or replace view view_young_users as
select firstname, lastname, hometown, gender
from users, profiles
where user_id = users.id and
datediff(curdate(), str_to_date(birthday, '%Y-%m-%d')) < 20 * 365.25;

select *
from view_young_users;


/* 
Task 2
Count the messages sended by each user. 
Range specifying the user's age and lastname,
count of the sended messages and rate
*/

USE semimar_4;
create view view_rank_users_by_mes_count as
SELECT firstname, 
	   lastname, 
       round(datediff(curdate(), str_to_date(birthday, '%Y-%m-%d')) / 365.25) as age, 
       COUNT(messages.id) AS message_count,
       dense_rank() OVER ( 
       ORDER BY COUNT(messages.id) desc 
	) rank_no 
FROM users
RIGHT JOIN profiles ON users.id = user_id
RIGHT JOIN messages ON users.id = from_user_id
group by users.id
ORDER BY message_count DESC;

select *
from view_rank_users_by_mes_count;


/* 
Task 3
Select all the messages, sort by the send date ascending
count the difference between neibour messages
*/

create or replace view view_mes as
select id, 
	   created_at,
       TIMESTAMPDIFF(SECOND,
					 STR_TO_DATE(lead(created_at, 1, 0) over (order by created_at), '%Y-%m-%d %H:%i:%s'),
                     STR_TO_DATE(created_at, '%Y-%m-%d %H:%i:%s')) 
                     as diff_in_sec_prev,
       TIMESTAMPDIFF(SECOND,
					  STR_TO_DATE(lag(created_at, 1, 0) over (order by created_at), '%Y-%m-%d %H:%i:%s'),
                      STR_TO_DATE(created_at, '%Y-%m-%d %H:%i:%s')) 
                      as diff_in_sec_next
from messages;

select *
from view_mes;

