use semimar_4;

# Task 1

drop procedure if exists user_friends;
delimiter //
create procedure user_friends(us_id int)
begin

select user_id from profiles
where hometown = 
(select hometown from profiles where user_id = us_id) and user_id != us_id
union
select user_id from users_communities where community_id in
(select community_id from users_communities where user_id = us_id) and user_id != us_id;
end//
delimiter ;
call user_friends(1);


# Task 2

drop function if exists rank_user;
delimiter //
create function rank_user(us_id int)
returns float reads sql data
begin

set @rank :=
(select count(friend_requests.initiator_user_id) 
from friend_requests
where friend_requests.target_user_id = us_id) /
(select count(users.id)
from users);

return @rank;

end//
delimiter ;
select rank_user(1);
