USE `seminar_5`;
-- Персонал
DROP TABLE IF EXISTS staff;
CREATE TABLE staff (
	id INT AUTO_INCREMENT PRIMARY KEY, 
	firstname VARCHAR(45),
	lastname VARCHAR(45),
	post VARCHAR(100),
	seniority INT, 
	salary INT, 
	age INT
);

-- Наполнение данными
INSERT INTO staff (firstname, lastname, post, seniority, salary, age)
VALUES
('Вася', 'Петров', 'Начальник', '40', 100000, 60),
('Петр', 'Власов', 'Начальник', '8', 70000, 30),
('Катя', 'Катина', 'Инженер', '2', 70000, 25),
('Саша', 'Сасин', 'Инженер', '12', 50000, 35),
('Ольга', 'Васютина', 'Инженер', '2', 70000, 25),
('Петр', 'Некрасов', 'Уборщик', '36', 16000, 59),
('Саша', 'Петров', 'Инженер', '12', 50000, 49),
('Иван', 'Сидоров', 'Рабочий', '40', 50000, 59),
('Петр', 'Петров', 'Рабочий', '20', 25000, 40),
('Сидр', 'Сидоров', 'Рабочий', '10', 20000, 35),
('Антон', 'Антонов', 'Рабочий', '8', 19000, 28),
('Юрий', 'Юрков', 'Рабочий', '5', 15000, 25),
('Максим', 'Максимов', 'Рабочий', '2', 11000, 22),
('Юрий', 'Галкин', 'Рабочий', '3', 12000, 24),
('Людмила', 'Маркина', 'Уборщик', '10', 10000, 49),
('Юрий', 'Онегин', 'Начальник', '8', 100000, 39);



-- Оценки учеников
DROP TABLE IF EXISTS academic_record;
CREATE TABLE academic_record (
	id INT AUTO_INCREMENT PRIMARY KEY, 
	name VARCHAR(45),
	quartal  VARCHAR(45),
    subject VARCHAR(45),
	grade INT
);

INSERT INTO academic_record (name, quartal, subject, grade)
values
	('Александр','1 четверть', 'математика', 4),
	('Александр','2 четверть', 'русский', 4),
	('Александр', '3 четверть','физика', 5),
	('Александр', '4 четверть','история', 4),
	('Антон', '1 четверть','математика', 4),
	('Антон', '2 четверть','русский', 3),
	('Антон', '3 четверть','физика', 5),
	('Антон', '4 четверть','история', 3),
    ('Петя', '1 четверть', 'физика', 4),
	('Петя', '2 четверть', 'физика', 3),
	('Петя', '3 четверть', 'физика', 4),
	('Петя', '2 четверть', 'математика', 3),
	('Петя', '3 четверть', 'математика', 4),
	('Петя', '4 четверть', 'физика', 5);

select id, name, grade,
avg(grade) over(partition by name) as average,
max(grade) over(partition by name) as max,
min(grade) over(partition by name) as min,
sum(grade) over(partition by name) as sum,
count(grade) over(partition by name) as count
from academic_record;

use seminar_5;
select name, subject, quartal, grade,
lag(grade, 1, 0) over (order by quartal) as next_q,
lead(grade, 1, 0) over (order by quartal) as previous_q 
from academic_record 
where (name = 'Петя' and subject = 'физика')
window ql as (order by quartal);


use semimar_4;
create or replace view u111 as
select *
from semimar_4.messages
where from_user_id = 1 or to_user_id = 1;

SELECT * FROM u111;


with v_1 as
(select initiator_user_id as f_id
from friend_requests
where target_user_id = 1
and status = 'approved'
union
select target_user_id
from friend_requests
where initiator_user_id = 1
and status = 'approved')

select initiator_user_id
from v_1
join friend_requests on target_user_id = f_id
where  initiator_user_id != 1
and status = 'approved'
union
select target_user_id
from v_1
join friend_requests on initiator_user_id = f_id
where target_user_id != 1
and status = 'approved';

create view v_2 as
select initiator_user_id as f_id
from friend_requests
where target_user_id = 1
and status = 'approved'
union
select target_user_id
from friend_requests
where initiator_user_id = 1
and status = 'approved';

select initiator_user_id
from v_2
join friend_requests on target_user_id = f_id
where  initiator_user_id != 1
and status = 'approved'
union
select target_user_id
from v_2
join friend_requests on initiator_user_id = f_id
where target_user_id != 1
and status = 'approved';
