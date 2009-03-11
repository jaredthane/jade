
--
-- Adding previous qty field to lines
--
LOCK TABLES `lines` WRITE;
alter table `lines` add column previous_qty int(11);
UNLOCK TABLES;

LOCK TABLES `order_types` WRITE;
INSERT INTO `order_types` VALUES (5,'Cuenta Fisica');
UNLOCK TABLES;
