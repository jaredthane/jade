
--
-- Adding previous qty field to lines
--
LOCK TABLES `lines` WRITE;
alter table `lines` add column previous_qty int(11);
UNLOCK TABLES;

LOCK TABLES `order_types` WRITE;
INSERT INTO `order_types` VALUES (5,'Cuenta Fisica');
UNLOCK TABLES;
+
0
+LOCK TABLES `products` WRITE;
0
+alter table products add column blocked_by_count int(1) default 0;
0
+UNLOCK TABLES;
