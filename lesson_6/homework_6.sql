# Task 1
# Create table users_old and 
# tranzaction what move a user from users to users_old 

create table users_old (
	`id` bigint unsigned not null auto_increment,
	`firstname` varchar(50) default null,
	`lastname` varchar(50) default null comment 'Фамилия',
	`email` varchar(120) default null,
	primary key (`id`),
	UNIQUE KEY `id` (`id`),
	UNIQUE KEY `email` (`email`)
	) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
    
start transaction;

set @us_id = 5;
set @us_firstname = (select firstname from users where id = @us_id);
set @us_lastname = (select lastname from users where id = @us_id);
set @us_email = (select email from users where id = @us_id);

insert into users_old (id, firstname, lastname, email)
values (@us_id, @us_firstname, @us_lastname, @us_email);

commit;


# Task 2
# Create function that get the greeting depending on time

drop function if exists hello;
delimiter //
create function hello(cur_time time)
returns text reads sql data
begin

set @sunrise := '06:00:00';
set @noon := '12:00:00';
set @sunset := '18:00:00';
set @midnight := '00:00:00';

if cur_time >= @sunrise and cur_time <= @noon then
	return 'Good morning';
elseif cur_time >= @noon and cur_time <= @sunset then
	return 'Good afternoon';
elseif cur_time >= @sunset and cur_time <= @midnight then
	return 'Good evening';
else
	return 'Good night';
end if;
return '';
end//
delimiter ;
set @test1 = '02:45:03'; 
set @test2 = '06:55:21'; 
set @test3 = '12:41:35'; 
set @test4 = '22:49:05'; 
select @test1 as input_time, hello(@test1) as greeting
union
select @test2, hello(@test2)
union
select @test3, hello(@test3)
union
select @test4, hello(@test4);


# Task 3
drop table if exists logs;
create table logs (
	`id` bigint unsigned not null AUTO_INCREMENT PRIMARY KEY,
	`created_at` datetime default null,
	`table_name` varchar(50) default null comment 'Фамилия',
	primary_key_id INT
	) ENGINE=Archive AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

    
delimiter //
drop procedure if exists insert_log;
create procedure insert_log(
	in table_n varchar(50),
    in primary_key_id int
)
begin
	insert into logs (created_at, table_name, primary_key_id)
    values (now(), table_n, primary_key_id);
end//
commit;

drop trigger if exists users_old_after_insert;
create trigger users_old_after_insert
after insert on users_old
for each row 
begin
	call insert_log('users_old', new.id);
end//

drop trigger if exists users_after_insert;
create trigger users_after_insert
after insert on users
for each row 
begin
	call insert_log('users', new.id);
end//

create trigger communities_after_insert
after insert on communities
for each row 
begin
	call insert_log('communities', new.id);
end//

create trigger messages_after_insert
after insert on messages
for each row 
begin
	call insert_log('communities', new.id);
end//
delimiter ;

SHOW TRIGGERS;
SHOW PROCEDURE STATUS;
