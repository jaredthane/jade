# Delete unneeded price groups and prices
delete from prices where d=1;
update price_groups inner join entities on entity_id=entities.id set d=1 where entity_type_id !=3;
update price_groups left join entities on entity_id=entities.id set d=1 where entities.id is null;
delete from price_groups where d=1;
alter table prices add column d tinyint(1);
update prices set d=0;
update prices left join price_groups on price_group_id=price_groups.id set prices.d=1 where price_groups.id is null;
delete from prices where d=1;

# Delete lines that have no order
alter table `lines` add column d tinyint(1);
update `lines` set d=0;
update `lines` left join orders on order_id=orders.id set `lines`.d=1 where orders.id is null;
delete from `lines` where d=1;

# Delete transactions that have no order
alter table `trans` add column d tinyint(1);
update `trans` set d=0;
update `trans` left join orders on order_id=orders.id set `trans`.d=1 where orders.id is null;
delete from `trans` where d=1;

#Check for movements with cost_left but no quantity_left and vice-versa(almost: we have to allow for free stuff)
delete from movements where cost_left>0 AND (quantity_left = 0 or quantity_left is null)
delete from movements where quantity_left>0 AND cost_left is null

# Remove duplicates from rights_roles
CREATE TABLE temp_table as SELECT * FROM rights_roles WHERE 1 GROUP BY role_id, right_id;
DROP TABLE rights_roles;
RENAME TABLE temp_table TO rights_roles;
