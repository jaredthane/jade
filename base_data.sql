-- MySQL dump 10.13  Distrib 5.1.37, for debian-linux-gnu (i486)
--
-- Host: localhost    Database: Jade
-- ------------------------------------------------------
-- Server version	5.1.37-1ubuntu5

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `entity_id` int(11) DEFAULT NULL,
  `number` varchar(20) DEFAULT NULL,
  `modifier` int(2) DEFAULT NULL,
  `balance` decimal(8,2) DEFAULT '0.00',
  `is_parent` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `parent_id` (`parent_id`),
  KEY `entity_id` (`entity_id`),
  KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=34 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` VALUES (2,'Activos',NULL,NULL,'1',1,'0.00',NULL),(3,'Pasivos',NULL,NULL,'2',-1,'0.00',NULL),(4,'Patrimonio',NULL,NULL,'3',-1,'0.00',NULL),(5,'Ingresos',NULL,NULL,'4',-1,'0.00',NULL),(6,'Gastos',NULL,NULL,'5',1,'0.00',NULL),(7,'Efectivo',2,NULL,'11',1,'0.00',NULL),(8,'Inventario',2,NULL,'12',1,'0.00',NULL),(9,'Cuenta Bancaria',2,NULL,'13',1,'0.00',NULL),(10,'Cuentas a Cobrar',2,NULL,'14',-1,'0.00',NULL),(11,'Cuentas por Pagar',3,NULL,'21',-1,'0.00',NULL),(12,'Impuesto',3,NULL,'22',-1,'0.00',NULL),(13,'Empleados',11,NULL,'211',-1,'0.00',NULL),(14,'Proveedores',11,NULL,'212',-1,'0.00',NULL),(15,'Clientes',10,NULL,'141',1,'0.00',NULL),(16,'Efectivo en Principal',7,5,'',1,'0.00',NULL),(17,'Gastos en Principal',6,5,'',1,'0.00',NULL),(18,'Ingresos en Principal',5,5,'',-1,'0.00',NULL),(19,'Impuestos en Principal',12,5,'',-1,'0.00',NULL),(20,'Inventario en Principal',8,5,'',1,'1.13',NULL),(21,'Principal Proveedores',14,NULL,'',-1,'1.13',NULL),(22,'Principal Empleados',13,NULL,'',-1,'0.00',NULL),(23,'Principal Clientes',15,NULL,'',1,'0.00',NULL);
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `combo_line_types`
--

DROP TABLE IF EXISTS `combo_line_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `combo_line_types` (
  `id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `combo_line_types`
--

LOCK TABLES `combo_line_types` WRITE;
/*!40000 ALTER TABLE `combo_line_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `combo_line_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `combo_lines`
--

DROP TABLE IF EXISTS `combo_lines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `combo_lines` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) DEFAULT NULL,
  `combo_id` int(11) DEFAULT NULL,
  `quantity` decimal(8,2) DEFAULT NULL,
  `serialized_product_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `combo_line_type_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `combo_lines`
--

LOCK TABLES `combo_lines` WRITE;
/*!40000 ALTER TABLE `combo_lines` DISABLE KEYS */;
/*!40000 ALTER TABLE `combo_lines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `costs`
--

DROP TABLE IF EXISTS `costs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `costs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  `entity_id` int(11) DEFAULT NULL,
  `quantity` decimal(8,2) DEFAULT '0.00',
  `value` decimal(8,2) DEFAULT '0.00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `costs`
--

LOCK TABLES `costs` WRITE;
/*!40000 ALTER TABLE `costs` DISABLE KEYS */;
/*!40000 ALTER TABLE `costs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entities`
--

DROP TABLE IF EXISTS `entities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `entities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `entity_type_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `home_phone` char(8) DEFAULT '',
  `office_phone` char(8) DEFAULT '',
  `address` text,
  `birth` datetime DEFAULT NULL,
  `state_id` int(11) DEFAULT NULL,
  `cell_phone` char(8) DEFAULT NULL,
  `nit` char(14) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `register` varchar(255) DEFAULT NULL,
  `giro` varchar(255) DEFAULT NULL,
  `price_group_id` int(11) DEFAULT NULL,
  `price_group_name_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `site_id` int(11) DEFAULT NULL,
  `inventory_account_id` int(11) DEFAULT NULL,
  `cash_account_id` int(11) DEFAULT NULL,
  `revenue_account_id` int(11) DEFAULT NULL,
  `expense_account_id` int(11) DEFAULT NULL,
  `returns_account_id` int(11) DEFAULT NULL,
  `tax_account_id` int(11) DEFAULT NULL,
  `payables_account_id` int(11) DEFAULT NULL,
  `notes` text,
  `oldid` varchar(255) DEFAULT NULL,
  `subscription_day` int(11) DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  `next_receipt_number` char(8) DEFAULT NULL,
  `client_accounts_group_id` int(11) DEFAULT NULL,
  `vendor_accounts_group_id` int(11) DEFAULT NULL,
  `next_bar_code` varchar(32) DEFAULT NULL,
  `fax` char(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `entity_type_id` (`entity_type_id`),
  KEY `site_id` (`site_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entities`
--

LOCK TABLES `entities` WRITE;
/*!40000 ALTER TABLE `entities` DISABLE KEYS */;
INSERT INTO `entities` VALUES (1,'Consumo Interno',NULL,NULL,NULL,'','',NULL,NULL,12,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL),(2,'Varios',1,NULL,NULL,'','',NULL,NULL,12,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,17,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL),(3,'Anonimo',2,NULL,NULL,'','',NULL,NULL,12,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL,5,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL),(4,'No Specificado',1,NULL,NULL,'','',NULL,NULL,12,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,21,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL),(5,'Principal',3,'2009-11-07 16:40:45','2009-12-21 13:13:47','','','',NULL,1,NULL,NULL,'','',NULL,NULL,1,NULL,NULL,NULL,NULL,20,16,18,17,NULL,19,NULL,'',NULL,NULL,1,'1',23,21,'10007',''),(9,'Anulado',2,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `entities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entity_types`
--

DROP TABLE IF EXISTS `entity_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `entity_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entity_types`
--

LOCK TABLES `entity_types` WRITE;
/*!40000 ALTER TABLE `entity_types` DISABLE KEYS */;
INSERT INTO `entity_types` VALUES (1,'Proveedor'),(2,'Consumidor Final'),(3,'Sitio'),(5,'Credito Fiscal'),(6,'Empleado'),(7,'Cuenta Bancaria'),(8,'Empleado'),(9,'Cuenta Bancaria');
/*!40000 ALTER TABLE `entity_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entries`
--

DROP TABLE IF EXISTS `entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `post_id` int(11) DEFAULT NULL,
  `account_id` int(11) DEFAULT NULL,
  `balance` decimal(8,2) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `created_at` (`created_at`),
  KEY `account_id` (`account_id`),
  KEY `post_id` (`post_id`)
) ENGINE=MyISAM AUTO_INCREMENT=764 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entries`
--

LOCK TABLES `entries` WRITE;
/*!40000 ALTER TABLE `entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventories`
--

DROP TABLE IF EXISTS `inventories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `inventories` (
  `product_id` int(11) DEFAULT NULL,
  `entity_id` int(11) DEFAULT NULL,
  `min` decimal(8,2) DEFAULT NULL,
  `max` decimal(8,2) DEFAULT NULL,
  `to_order` decimal(8,2) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` date DEFAULT NULL,
  `updated_at` date DEFAULT NULL,
  `quantity` decimal(8,2) DEFAULT NULL,
  `default_warranty_sales_id` int(11) DEFAULT NULL,
  `default_warranty_purchases_id` int(11) DEFAULT NULL,
  `cost` decimal(8,2) DEFAULT NULL,
  `default_cost` decimal(8,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  KEY `entity_id` (`entity_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2237 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventories`
--

LOCK TABLES `inventories` WRITE;
/*!40000 ALTER TABLE `inventories` DISABLE KEYS */;
INSERT INTO `inventories` VALUES (13,5,'0.00','0.00','0.00',2236,'2010-02-20','2010-02-20','0.00',NULL,NULL,'0.00','0.00');
/*!40000 ALTER TABLE `inventories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lines`
--

DROP TABLE IF EXISTS `lines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lines` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  `quantity` decimal(8,2) DEFAULT NULL,
  `price` decimal(8,2) DEFAULT '0.00',
  `received` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `serialized_product_id` int(11) DEFAULT NULL,
  `line_id` int(11) DEFAULT NULL,
  `warranty_price` decimal(8,2) DEFAULT '0.00',
  `warranty_id` int(11) DEFAULT NULL,
  `tax` decimal(8,2) DEFAULT '0.00',
  `previous_qty` decimal(8,2) DEFAULT NULL,
  `warranty_months` int(11) DEFAULT NULL,
  `receipt_id` int(11) DEFAULT NULL,
  `note` text,
  `sales_tax` decimal(8,2) DEFAULT '0.00',
  `order_type_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=32956 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lines`
--

LOCK TABLES `lines` WRITE;
/*!40000 ALTER TABLE `lines` DISABLE KEYS */;
INSERT INTO `lines` VALUES (32862,3,32874,'2.00','20.00','2009-12-02 11:56:50','2009-12-02 11:56:50','2009-12-02 13:07:41',NULL,NULL,'0.00',89,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32863,4,32875,'10.00','0.00',NULL,'2009-12-02 13:14:39','2009-12-02 13:14:39',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32864,4,32876,'1.00','0.00',NULL,'2009-12-02 14:46:14','2009-12-02 14:46:14',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32865,4,32877,'1.00','0.00',NULL,'2009-12-02 14:46:41','2009-12-02 14:46:41',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32866,4,32878,'1.00','0.00',NULL,'2009-12-02 14:48:53','2009-12-02 14:48:53',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32867,4,32879,'1.00','0.00',NULL,'2009-12-02 15:12:57','2009-12-02 15:12:57',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32868,4,32880,'1.00','0.00',NULL,'2009-12-02 15:16:25','2009-12-02 15:16:25',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32869,4,32881,'1.00','0.00',NULL,'2009-12-02 15:16:32','2009-12-02 15:16:32',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32870,5,32882,'1.00','5.00',NULL,'2009-12-02 15:28:53','2009-12-02 15:28:53',NULL,NULL,'0.00',91,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32871,5,32883,'2.00','0.00',NULL,'2009-12-02 16:06:01','2009-12-02 16:06:01',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32872,4,32884,'2.00','0.00',NULL,'2009-12-02 16:06:01','2009-12-02 16:06:01',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32873,5,32885,'1.00','0.00',NULL,'2009-12-02 16:12:00','2009-12-02 16:12:00',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32874,4,32886,'3.00','0.00',NULL,'2009-12-02 16:12:12','2009-12-02 16:12:12',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32875,4,32887,'0.00','0.00',NULL,'2009-12-02 16:14:29','2009-12-02 16:14:29',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32876,4,32888,'0.00','0.00',NULL,'2009-12-02 16:14:37','2009-12-02 16:14:37',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32877,5,32889,'0.00','0.00',NULL,'2009-12-02 16:14:45','2009-12-02 16:14:45',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32878,5,32890,'1.00','0.00',NULL,'2009-12-02 16:16:06','2009-12-02 16:16:06',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32879,5,32891,'1.00','0.00',NULL,'2009-12-02 16:16:12','2009-12-02 16:16:12',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32880,5,32892,'1.00','0.00',NULL,'2009-12-02 16:16:17','2009-12-02 16:16:17',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32881,5,32893,'0.00','0.00','2009-12-02 17:31:42','2009-12-02 16:17:14','2009-12-02 17:31:42',NULL,NULL,'0.00',91,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32882,5,32894,'0.00','0.00',NULL,'2009-12-02 16:17:20','2009-12-02 16:17:20',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32883,5,32895,'1.00','0.00',NULL,'2009-12-02 16:18:36','2009-12-02 16:18:36',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32884,5,32896,'1.00','0.00',NULL,'2009-12-02 16:18:42','2009-12-02 16:18:42',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32885,5,32897,'1.00','0.00',NULL,'2009-12-02 16:19:18','2009-12-02 16:19:18',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32886,5,32898,'3.00','0.00',NULL,'2009-12-02 17:04:25','2009-12-02 17:06:36',NULL,NULL,'0.00',91,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32887,5,32899,'1.00','0.00',NULL,'2009-12-02 17:04:31','2009-12-02 17:04:31',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32888,5,32900,'1.00','0.00',NULL,'2009-12-02 17:29:19','2009-12-02 17:29:19',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32889,5,32901,'1.00','0.00',NULL,'2009-12-02 17:31:13','2009-12-02 17:31:13',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32890,6,32904,'3.00','50.00','2009-12-02 17:47:00','2009-12-02 17:47:00','2009-12-02 17:47:00',NULL,NULL,'0.00',92,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32891,7,32905,'3.00','50.00','2009-12-02 17:49:42','2009-12-02 17:49:42','2009-12-02 17:49:42',NULL,NULL,'0.00',93,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32892,7,32906,'5.00','23.00','2009-12-02 17:51:49','2009-12-02 17:51:49','2009-12-02 17:51:49',NULL,NULL,'0.00',93,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32893,8,32906,'1.00','0.00','2009-12-02 17:52:11','2009-12-02 17:52:11','2009-12-02 17:52:11',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32894,8,32907,'1.00','0.00','2009-12-02 21:26:56','2009-12-02 21:26:56','2009-12-02 21:26:56',1,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32895,8,32907,'1.00','0.00','2009-12-02 21:26:56','2009-12-02 21:26:56','2009-12-02 21:26:56',2,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32896,8,32907,'1.00','0.00','2009-12-02 21:26:56','2009-12-02 21:26:56','2009-12-02 21:26:56',3,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32897,8,32907,'1.00','0.00','2009-12-02 21:47:30','2009-12-02 21:47:30','2009-12-02 21:47:30',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32898,8,32907,'1.00','0.00','2009-12-02 21:50:24','2009-12-02 21:50:24','2009-12-02 21:50:24',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32899,8,32907,'1.00','0.00','2009-12-02 21:53:39','2009-12-02 21:53:39','2009-12-02 21:53:39',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32900,8,32907,'1.00','0.00','2009-12-02 21:55:28','2009-12-02 21:55:28','2009-12-02 21:55:28',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32901,8,32907,'1.00','0.00','2009-12-02 21:57:09','2009-12-02 21:57:09','2009-12-02 21:57:09',4,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32902,7,32908,'1.00','13.00','2009-12-02 23:21:22','2009-12-02 23:21:22','2009-12-02 23:21:22',NULL,NULL,'0.00',93,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32903,7,32909,'1.00','13.00','2009-12-02 23:21:38','2009-12-02 23:21:38','2009-12-02 23:21:38',NULL,NULL,'0.00',93,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32904,8,32910,'1.00','23.00','2009-12-02 23:22:01','2009-12-02 23:21:54','2009-12-02 23:22:01',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32905,8,32911,'1.00','0.00','2009-12-02 23:28:05','2009-12-02 23:28:05','2009-12-02 23:28:05',1,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32908,8,32912,'1.00','0.00','2009-12-03 00:02:27','2009-12-03 00:02:27','2009-12-03 00:02:27',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32909,8,32913,'1.00','0.00','2009-12-03 00:05:59','2009-12-03 00:05:59','2009-12-03 00:05:59',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32910,8,32914,'1.00','0.00','2009-12-03 00:08:34','2009-12-03 00:08:34','2009-12-03 00:08:34',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32911,8,32915,'1.00','0.00','2009-12-03 00:10:47','2009-12-03 00:10:47','2009-12-03 00:10:47',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32912,8,32916,'1.00','0.00','2009-12-03 00:12:45','2009-12-03 00:12:46','2009-12-03 00:12:46',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32913,8,32917,'1.00','0.00','2009-12-03 00:16:36','2009-12-03 00:16:36','2009-12-03 00:16:36',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32914,8,32918,'1.00','0.00','2009-12-03 00:20:08','2009-12-03 00:19:31','2009-12-03 00:20:08',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32915,8,32919,'1.00','0.00','2009-12-03 00:23:27','2009-12-03 00:23:27','2009-12-03 00:23:27',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32916,8,32920,'1.00','0.00','2009-12-03 00:24:43','2009-12-03 00:24:43','2009-12-03 00:24:43',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32917,8,32921,'1.00','0.00','2009-12-03 00:29:24','2009-12-03 00:29:24','2009-12-03 00:29:24',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32918,8,32922,'1.00','0.00','2009-12-03 00:31:20','2009-12-03 00:31:20','2009-12-03 00:31:20',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32919,8,32923,'1.00','0.00','2009-12-03 00:32:34','2009-12-03 00:32:34','2009-12-03 00:32:34',5,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32920,8,32924,'1.00','0.00','2009-12-03 00:33:06','2009-12-03 00:32:51','2009-12-03 00:33:06',7,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32921,8,32924,'1.00','0.00','2009-12-03 00:33:06','2009-12-03 00:33:06','2009-12-03 00:33:06',6,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32922,8,32925,'1.00','5.00','2009-12-03 00:37:15','2009-12-03 00:37:15','2009-12-03 00:37:15',8,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32923,8,32926,'1.00','0.00',NULL,'2009-12-03 00:47:16','2009-12-03 00:58:20',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32924,8,32927,'1.00','0.00',NULL,'2009-12-03 00:48:03','2009-12-03 00:48:37',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32925,8,32927,'1.00','0.00',NULL,'2009-12-03 00:48:16','2009-12-03 00:57:03',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32926,8,32928,'1.00','0.00','2009-12-03 21:46:49','2009-12-03 21:46:49','2009-12-03 21:46:49',12,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32927,8,32929,'1.00','0.00',NULL,'2009-12-03 21:47:39','2009-12-03 21:54:43',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32928,8,32931,'1.00','0.00',NULL,'2009-12-03 21:59:14','2009-12-03 22:11:23',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32929,8,32932,'1.00','50.00','2009-12-03 22:27:38','2009-12-03 22:27:38','2009-12-03 22:27:38',16,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32930,8,32933,'1.00','0.00','2009-12-03 22:28:54','2009-12-03 22:28:54','2009-12-03 22:28:54',17,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32931,8,32934,'1.00','0.00',NULL,'2009-12-03 22:30:35','2009-12-03 22:40:10',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32932,8,32935,'1.00','0.00',NULL,'2009-12-03 22:41:14','2009-12-03 22:43:12',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32933,8,32936,'1.00','0.00','2009-12-03 22:44:18','2009-12-03 22:44:18','2009-12-03 22:44:18',19,NULL,'0.00',NULL,'0.00','10.00',NULL,NULL,NULL,'0.00',5),(32934,7,32937,'4.00','0.00','2009-12-04 00:26:29','2009-12-03 23:21:13','2009-12-04 00:26:29',20,NULL,'0.00',93,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32935,7,32938,'5.00','0.00','2009-12-03 23:28:09','2009-12-03 23:28:09','2009-12-03 23:28:10',NULL,NULL,'0.00',NULL,'0.00','9.00',NULL,NULL,NULL,'0.00',5),(32936,7,32937,'2.00','39.20','2009-12-04 00:26:29','2009-12-03 23:44:05','2009-12-04 00:26:30',20,NULL,'0.00',93,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32937,7,32939,'4.00','39.20','2009-12-04 00:11:17','2009-12-04 00:08:00','2009-12-04 00:11:17',NULL,NULL,'0.00',93,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32938,8,32939,'1.00','2.00','2009-12-04 00:11:17','2009-12-04 00:08:00','2009-12-04 00:11:17',22,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32939,7,NULL,'0.00','0.00',NULL,'2009-12-04 00:18:34','2009-12-04 00:18:34',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32940,7,32942,'1.00','45.00','2009-12-04 00:57:06','2009-12-04 00:57:06','2009-12-04 01:18:17',NULL,NULL,'0.00',93,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32941,11,32945,'100.00','25.00','2009-12-18 08:29:35','2009-12-18 08:29:35','2009-12-18 08:29:35',NULL,NULL,'0.00',98,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32942,11,32946,'1.00','30.00','2009-12-18 08:37:36','2009-12-18 08:37:37','2009-12-18 08:37:37',NULL,NULL,'0.00',98,'0.00',NULL,NULL,NULL,NULL,'0.00',1),(32943,11,32947,'1.00','30.00','2009-12-18 08:41:30','2009-12-18 08:41:31','2009-12-18 08:41:31',NULL,NULL,'0.00',98,'0.00',NULL,NULL,NULL,NULL,'0.00',1),(32944,11,32948,'1.00','30.00','2009-12-18 09:03:05','2009-12-18 09:03:05','2009-12-18 09:03:05',NULL,NULL,'0.00',98,'0.00',NULL,NULL,NULL,NULL,'0.00',1),(32945,11,32950,'1.00','30.00','2009-12-18 09:42:48','2009-12-18 09:42:48','2009-12-18 09:42:48',NULL,NULL,'0.00',98,'0.00',NULL,NULL,NULL,NULL,'0.00',1),(32946,11,32951,'1.00','30.00','2009-12-18 09:45:27','2009-12-18 09:45:27','2009-12-18 09:45:27',NULL,NULL,'0.00',98,'0.00',NULL,NULL,NULL,NULL,'0.00',1),(32947,11,32952,'100.00','250.00','2009-12-21 13:03:01','2009-12-20 22:20:55','2009-12-21 13:03:01',NULL,NULL,'0.00',NULL,'0.00','90.00',NULL,NULL,NULL,'0.00',5),(32948,11,32953,'1.00','10.00','2009-12-20 23:51:22','2009-12-20 23:51:22','2009-12-20 23:51:22',NULL,NULL,'0.00',98,'0.00',NULL,NULL,NULL,NULL,'0.00',1),(32949,11,32954,'90.00','-250.00','2009-12-21 12:52:19','2009-12-21 00:17:41','2009-12-21 12:52:19',NULL,NULL,'0.00',NULL,'0.00','100.00',NULL,NULL,NULL,'0.00',5),(32950,12,32955,'10.00','100.00','2009-12-21 12:55:57','2009-12-21 12:55:44','2009-12-21 12:55:57',NULL,NULL,'0.00',NULL,'0.00','0.00',NULL,NULL,NULL,'0.00',5),(32951,12,32956,'5.00','-50.00','2009-12-21 12:57:04','2009-12-21 12:56:42','2009-12-21 12:57:04',NULL,NULL,'0.00',NULL,'0.00','10.00',NULL,NULL,NULL,'0.00',5),(32952,12,32957,'20.00','0.00','2009-12-21 13:13:29','2009-12-21 13:05:46','2009-12-21 13:13:29',NULL,NULL,'0.00',NULL,'0.00','20.00',NULL,NULL,NULL,'0.00',5),(32953,11,32958,'99.00','-25.00','2009-12-21 13:14:12','2009-12-21 13:13:47','2009-12-21 13:14:12',NULL,NULL,'0.00',NULL,'0.00','100.00',NULL,NULL,NULL,'0.00',5),(32955,13,32960,'1.00','1.00',NULL,'2010-02-20 13:15:19','2010-02-20 13:15:19',NULL,NULL,'0.00',100,'0.00',NULL,NULL,NULL,NULL,'0.00',2);
/*!40000 ALTER TABLE `lines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs`
--

DROP TABLE IF EXISTS `logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `severity` varchar(32) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `msg` varchar(255) DEFAULT NULL,
  `object_class` varchar(32) DEFAULT NULL,
  `object_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=683 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs`
--

LOCK TABLES `logs` WRITE;
/*!40000 ALTER TABLE `logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movement_types`
--

DROP TABLE IF EXISTS `movement_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `movement_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movement_types`
--

LOCK TABLES `movement_types` WRITE;
/*!40000 ALTER TABLE `movement_types` DISABLE KEYS */;
INSERT INTO `movement_types` VALUES (1,'Venta'),(2,'Compra'),(3,'Transferencia'),(4,'Cuenta Fisica'),(5,'Devolucion de Venta'),(6,'Devolucion de Compra'),(7,'Devolucion de Transferencia'),(8,'Consumo Interno'),(9,'Devolucion de Consumo Interno'),(10,'Pago'),(11,'Deposito'),(12,'Retiro'),(13,'Pago'),(14,'Deposito'),(15,'Retiro');
/*!40000 ALTER TABLE `movement_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movements`
--

DROP TABLE IF EXISTS `movements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `movements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `quantity` decimal(8,2) DEFAULT NULL,
  `movement_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  `serialized_product_id` int(11) DEFAULT NULL,
  `comments` text,
  `line_id` int(11) DEFAULT NULL,
  `quantity_left` decimal(8,2) DEFAULT NULL,
  `cost` decimal(8,2) DEFAULT NULL,
  `cost_ref` int(11) DEFAULT NULL,
  `value_left` decimal(8,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `order_id_2` (`order_id`),
  KEY `product_id` (`product_id`),
  KEY `entity_id` (`entity_id`)
) ENGINE=InnoDB AUTO_INCREMENT=192 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movements`
--

LOCK TABLES `movements` WRITE;
/*!40000 ALTER TABLE `movements` DISABLE KEYS */;
/*!40000 ALTER TABLE `movements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_types`
--

DROP TABLE IF EXISTS `order_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_types`
--

LOCK TABLES `order_types` WRITE;
/*!40000 ALTER TABLE `order_types` DISABLE KEYS */;
INSERT INTO `order_types` VALUES (1,'Venta'),(2,'Compra'),(3,'Consumo Interno'),(4,'Transferencia'),(5,'Cuenta Fisica'),(6,'Abono a cuenta'),(7,'Transferencia de Fondos'),(8,'Abono a cuenta'),(9,'Transferencia de Fondos');
/*!40000 ALTER TABLE `order_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vendor_id` int(11) DEFAULT NULL,
  `client_id` int(11) DEFAULT NULL,
  `received` date DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `serialized_product_id` int(11) DEFAULT NULL,
  `last_batch` tinyint(1) DEFAULT NULL,
  `receipt_printed` datetime DEFAULT NULL,
  `comments` text,
  `order_type_id` int(11) DEFAULT NULL,
  `grand_total` decimal(8,2) DEFAULT '0.00',
  `amount_paid` decimal(8,2) DEFAULT '0.00',
  `d` tinyint(1) DEFAULT '0',
  `purchase_receipt_number` int(11) DEFAULT NULL,
  `next_order` int(11) DEFAULT NULL,
  `receipt_filename` varchar(255) DEFAULT NULL,
  `receipt_generated` datetime DEFAULT NULL,
  `receipt_number` char(8) DEFAULT NULL,
  `scanned_receipt_id` int(11) DEFAULT NULL,
  `scanned_receipt_content_type` varchar(255) DEFAULT NULL,
  `scanned_receipt_file_name` varchar(255) DEFAULT NULL,
  `scanned_receipt_file_size` int(11) DEFAULT NULL,
  `sequel_id` int(11) DEFAULT NULL,
  `prequel_id` int(11) DEFAULT NULL,
  `deleted_at` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `created_at` (`created_at`),
  KEY `client_id` (`client_id`),
  KEY `vendor_id` (`vendor_id`),
  KEY `receipt_number` (`receipt_number`)
) ENGINE=InnoDB AUTO_INCREMENT=32961 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (32960,4,5,NULL,2,'2009-12-21 13:15:19','2010-02-20 13:15:19',NULL,NULL,NULL,'',2,'1.13','0.00',0,NULL,NULL,'/home/jared/oldjade/invoice_pdfs/32960.pdf',NULL,'1',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_methods`
--

DROP TABLE IF EXISTS `payment_methods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payment_methods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_methods`
--

LOCK TABLES `payment_methods` WRITE;
/*!40000 ALTER TABLE `payment_methods` DISABLE KEYS */;
INSERT INTO `payment_methods` VALUES (1,'Efectivo'),(2,'Cheque'),(3,'Tarjeta de Credito'),(4,'Credito');
/*!40000 ALTER TABLE `payment_methods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) DEFAULT NULL,
  `payment_method_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `returned` decimal(8,2) DEFAULT '0.00',
  `presented` decimal(8,2) DEFAULT '0.00',
  `canceled` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_types`
--

DROP TABLE IF EXISTS `post_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `post_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_types`
--

LOCK TABLES `post_types` WRITE;
/*!40000 ALTER TABLE `post_types` DISABLE KEYS */;
INSERT INTO `post_types` VALUES (1,'Debito'),(-1,'Credito');
/*!40000 ALTER TABLE `post_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `post_type_id` int(11) DEFAULT NULL,
  `value` decimal(8,2) DEFAULT NULL,
  `account_id` int(11) DEFAULT NULL,
  `trans_id` int(11) DEFAULT NULL,
  `balance` decimal(8,2) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `account_id` (`account_id`),
  KEY `trans_id` (`trans_id`),
  KEY `created_at` (`created_at`)
) ENGINE=MyISAM AUTO_INCREMENT=5431 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
INSERT INTO `posts` VALUES (5429,-1,'1.13',21,12255,'1.13','2009-12-21 13:15:19'),(5430,1,'1.13',20,12255,'1.13','2009-12-21 13:15:19');
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `preferences`
--

DROP TABLE IF EXISTS `preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `preferences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `value` int(11) DEFAULT NULL,
  `pref_group` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `preferences`
--

LOCK TABLES `preferences` WRITE;
/*!40000 ALTER TABLE `preferences` DISABLE KEYS */;
INSERT INTO `preferences` VALUES (1,'Producto',1,'revenue'),(2,'Categoria',2,'revenue'),(3,'Proveedor',3,'revenue'),(4,'Sitio',5,'revenue'),(5,'Asesor',4,'revenue'),(6,'Usuario',6,'revenue'),(7,'Sitio',4,'cash'),(8,'Asesor',2,'cash'),(9,'Usuario',3,'cash');
/*!40000 ALTER TABLE `preferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `price_group_names`
--

DROP TABLE IF EXISTS `price_group_names`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `price_group_names` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `price_group_names`
--

LOCK TABLES `price_group_names` WRITE;
/*!40000 ALTER TABLE `price_group_names` DISABLE KEYS */;
INSERT INTO `price_group_names` VALUES (1,'Publico'),(2,'Mayoreo');
/*!40000 ALTER TABLE `price_group_names` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `price_groups`
--

DROP TABLE IF EXISTS `price_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `price_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `price_group_name_id` int(11) DEFAULT NULL,
  `entity_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=37 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `price_groups`
--

LOCK TABLES `price_groups` WRITE;
/*!40000 ALTER TABLE `price_groups` DISABLE KEYS */;
INSERT INTO `price_groups` VALUES (1,1,5),(2,2,5);
/*!40000 ALTER TABLE `price_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prices`
--

DROP TABLE IF EXISTS `prices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `prices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `price_group_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `fixed` decimal(8,2) DEFAULT NULL,
  `relative` decimal(8,2) DEFAULT NULL,
  `available` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  KEY `price_group_id` (`price_group_id`)
) ENGINE=MyISAM AUTO_INCREMENT=610 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prices`
--

LOCK TABLES `prices` WRITE;
/*!40000 ALTER TABLE `prices` DISABLE KEYS */;
INSERT INTO `prices` VALUES (608,1,13,NULL,NULL,1),(609,2,13,NULL,NULL,1);
/*!40000 ALTER TABLE `prices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_categories`
--

DROP TABLE IF EXISTS `product_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT '',
  `revenue_account_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_categories`
--

LOCK TABLES `product_categories` WRITE;
/*!40000 ALTER TABLE `product_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_types`
--

DROP TABLE IF EXISTS `product_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_types`
--

LOCK TABLES `product_types` WRITE;
/*!40000 ALTER TABLE `product_types` DISABLE KEYS */;
INSERT INTO `product_types` VALUES (1,'Simple'),(2,'Discount'),(3,'Combo'),(4,'Service');
/*!40000 ALTER TABLE `product_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `production_order_lines`
--

DROP TABLE IF EXISTS `production_order_lines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `production_order_lines` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quantity` decimal(8,2) DEFAULT NULL,
  `quantity_planned` decimal(8,2) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `production_order_id` int(11) DEFAULT NULL,
  `serialized_product_id` int(11) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `production_order_lines`
--

LOCK TABLES `production_order_lines` WRITE;
/*!40000 ALTER TABLE `production_order_lines` DISABLE KEYS */;
/*!40000 ALTER TABLE `production_order_lines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `production_orders`
--

DROP TABLE IF EXISTS `production_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `production_orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `is_process` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `started_at` datetime DEFAULT NULL,
  `finished_at` datetime DEFAULT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `started_by_id` int(11) DEFAULT NULL,
  `finished_by_id` int(11) DEFAULT NULL,
  `site_id` int(11) DEFAULT NULL,
  `quantity` decimal(8,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `production_orders`
--

LOCK TABLES `production_orders` WRITE;
/*!40000 ALTER TABLE `production_orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `production_orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `vendor_id` int(11) DEFAULT NULL,
  `oldcost` decimal(8,2) DEFAULT NULL,
  `upc` varchar(255) DEFAULT NULL,
  `unit_id` int(11) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `model` varchar(255) DEFAULT NULL,
  `serialized` tinyint(1) DEFAULT NULL,
  `serialized_product_id` int(11) DEFAULT NULL,
  `product_type_id` int(11) DEFAULT NULL,
  `product_category_id` int(11) DEFAULT NULL,
  `blocked_by_count` int(1) DEFAULT '0',
  `revenue_account_id` int(11) DEFAULT NULL,
  `image_id` int(11) DEFAULT NULL,
  `image_content_type` varchar(255) DEFAULT NULL,
  `image_file_name` varchar(255) DEFAULT NULL,
  `image_file_size` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `vendor_id` (`vendor_id`),
  KEY `upc` (`upc`),
  KEY `product_type_id` (`product_type_id`),
  KEY `product_category_id` (`product_category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (13,'Bloom','',4,NULL,'10007',1,'','2010-02-20 13:03:18','2010-02-20 13:03:18','',0,NULL,1,NULL,0,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requirements`
--

DROP TABLE IF EXISTS `requirements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `requirements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) DEFAULT NULL,
  `required_id` int(11) DEFAULT NULL,
  `quantity` decimal(8,2) DEFAULT NULL,
  `static_price` decimal(8,2) DEFAULT NULL,
  `relative_price` decimal(8,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=66 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requirements`
--

LOCK TABLES `requirements` WRITE;
/*!40000 ALTER TABLE `requirements` DISABLE KEYS */;
/*!40000 ALTER TABLE `requirements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rights`
--

DROP TABLE IF EXISTS `rights`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rights` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rights`
--

LOCK TABLES `rights` WRITE;
/*!40000 ALTER TABLE `rights` DISABLE KEYS */;
INSERT INTO `rights` VALUES ('CHANGE_ACCOUNTS','Cambiar Cuentas'),('CHANGE_CLIENTS','Cambiar Clientes'),('CHANGE_COMBOS','Cambiar Combos'),('CHANGE_COUNTS','Cambiar Cuentas Fisicas'),('CHANGE_DISCOUNTS','Cambiar Descuentos'),('CHANGE_INTERNAL_CONSUMPTIONS','Cambiar Consumos Internos'),('CHANGE_LABELS','Cambiar Etiquetas'),('CHANGE_PAYMENTS_FOR_PURCHASES','Cambiar Pagos para Compras'),('CHANGE_PAYMENTS_FOR_SALES','Cambiar Pagos para Ventas'),('CHANGE_PRICES','Cambiar Prices'),('CHANGE_PRODUCTION_ORDERS','Cambiar Ordenes de Produccion'),('CHANGE_PRODUCTION_PROCESSES','Cambiar Procesos de Produccion'),('CHANGE_PRODUCTS','Cambiar Productos'),('CHANGE_PURCHASES','Cambiar Compras'),('CHANGE_ROLES','Cambiar Papeles'),('CHANGE_SALES','Cambiar Ventas'),('CHANGE_SERIAL_NUMBERS','Cambiar Numeros de Serie'),('CHANGE_SERVICES','Cambiar Servicios'),('CHANGE_SITES','Cambiar Sitios'),('CHANGE_SUBSCRIPTIONS','Cambiar Suscripciones'),('CHANGE_TRANSACTIONS','Cambiar Transacciones'),('CHANGE_USERS','Cambiar Usuarios'),('CHANGE_VENDORS','Cambiar Proveedores'),('CHANGE_WARRANTIES','Cambiar Garantias'),('CREATE_ACCOUNTS','Crear Cuentas'),('CREATE_CLIENTS','Crear Clientes'),('CREATE_COMBOS','Crear Combos'),('CREATE_COUNTS','Crear Cuentas Fisicas'),('CREATE_DISCOUNTS','Crear Descuentos'),('CREATE_INTERNAL_CONSUMPTIONS','Crear Consumos Internos'),('CREATE_LABELS','Hacer Etiquetas'),('CREATE_PAYMENTS_FOR_PURCHASES','Crear Pagos para Compras'),('CREATE_PAYMENTS_FOR_SALES','Crear Pagos para Ventas'),('CREATE_PRODUCTION_ORDERS','Crear Ordenes de Produccion'),('CREATE_PRODUCTION_PROCESSES','Crear Procesos de Produccion'),('CREATE_PRODUCTS','Crear Productos'),('CREATE_PURCHASES','Crear Compras'),('CREATE_ROLES','Crear Papeles'),('CREATE_SALES','Crear Ventas'),('CREATE_SERIAL_NUMBERS','Crear Numeros de Serie'),('CREATE_SERVICES','Crear Servicios'),('CREATE_SITES','Crear Sitios'),('CREATE_SUBSCRIPTIONS','Crear Suscripciones'),('CREATE_TRANSACTIONS','Crear Transacciones'),('CREATE_USERS','Crear Usuarios'),('CREATE_VENDORS','Crear Proveedores'),('CREATE_WARRANTIES','Crear Garantias'),('DELETE_ACCOUNTS','Borrar Cuentas'),('DELETE_CLIENTS','Borrar Clientes'),('DELETE_COMBOS','Borrar Combos'),('DELETE_COUNTS','Borrar Cuentas Fisicas'),('DELETE_DISCOUNTS','Borrar Descuentos'),('DELETE_INTERNAL_CONSUMPTIONS','Borrar Consumos Internos'),('DELETE_LABELS','Borrar Etiquetas'),('DELETE_PAYMENTS_FOR_PURCHASES','Borrar Pagos para Compras'),('DELETE_PAYMENTS_FOR_SALES','Borrar Pagos para Ventas'),('DELETE_PRODUCTION_ORDERS','Borrar Ordenes de Produccion'),('DELETE_PRODUCTION_PROCESSES','Borrar Procesos de Produccion'),('DELETE_PRODUCTS','Borrar Productos'),('DELETE_PURCHASES','Borrar Compras'),('DELETE_ROLES','Borrar Papeles'),('DELETE_SALES','Borrar Ventas'),('DELETE_SERIAL_NUMBERS','Borrar Numeros de Serie'),('DELETE_SERVICES','Borrar Servicios'),('DELETE_SITES','Borrar Sitios'),('DELETE_SUBSCRIPTIONS','Borrar Suscripciones'),('DELETE_TRANSACTIONS','Borrar Transacciones'),('DELETE_USERS','Borrar Usuarios'),('DELETE_VENDORS','Borrar Proveedores'),('DELETE_WARRANTIES','Borrar Garantias'),('FINISH_PRODUCTION_ORDERS','Terminar Ordenes de Produccion'),('POST_COUNTS','Procesar Cuentas Fisicas'),('START_PRODUCTION_ORDERS','Iniciar Ordenes de Produccion'),('VIEW_ACCOUNTS','Ver Cuentas'),('VIEW_CLIENTS','Ver Clientes'),('VIEW_COMBOS','Ver Combos'),('VIEW_COSTS','Ver Costos'),('VIEW_COUNTS','Ver Cuentas Fisicas'),('VIEW_DISCOUNTS','Ver Descuentos'),('VIEW_INTERNAL_CONSUMPTIONS','Ver Consumos Internos'),('VIEW_LABELS','Ver Etiquetas'),('VIEW_PAYMENTS_FOR_PURCHASES','Ver Pagos para Compras'),('VIEW_PAYMENTS_FOR_SALES','Ver Pagos para Ventas'),('VIEW_PRODUCTION_ORDERS','Ver Ordenes de Produccion'),('VIEW_PRODUCTION_PROCESSES','Ver Procesos de Produccion'),('VIEW_PRODUCTS','Ver Productos'),('VIEW_PURCHASES','Ver Compras'),('VIEW_ROLES','Ver Papeles'),('VIEW_SALES','Ver Ventas'),('VIEW_SERIAL_NUMBERS','Ver Numeros de Serie'),('VIEW_SERVICES','Ver Servicios'),('VIEW_SITES','Ver Sitios'),('VIEW_SUBSCRIPTIONS','Ver Suscripciones'),('VIEW_TRANSACTIONS','Ver Transacciones'),('VIEW_USERS','Ver Usuarios'),('VIEW_VENDORS','Ver Proveedores'),('VIEW_WARRANTIES','Ver Garantias');
/*!40000 ALTER TABLE `rights` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rights_roles`
--

DROP TABLE IF EXISTS `rights_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rights_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) DEFAULT NULL,
  `right_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=501 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rights_roles`
--

LOCK TABLES `rights_roles` WRITE;
/*!40000 ALTER TABLE `rights_roles` DISABLE KEYS */;
INSERT INTO `rights_roles` VALUES (1,1,0),(2,1,0),(3,1,0),(4,1,0),(5,1,0),(6,1,0),(7,1,0),(8,1,0),(9,1,0),(10,1,0),(11,2,0),(12,2,0),(13,2,0),(14,2,0),(15,2,0),(16,2,0),(17,2,0),(18,2,0),(19,2,0),(20,2,0),(21,2,0),(22,2,0),(23,2,0),(24,2,0),(25,2,0),(26,3,0),(27,3,0),(28,3,0),(29,3,0),(30,3,0),(31,3,0),(32,3,0),(33,3,0),(34,3,0),(35,3,0),(36,3,0),(37,3,0),(38,3,0),(39,3,0),(40,3,0),(41,3,0),(42,4,0),(43,4,0),(44,4,0),(45,4,0),(46,4,0),(47,4,0),(48,4,0),(49,4,0),(50,4,0),(51,4,0),(52,5,0),(53,5,0),(54,5,0),(55,5,0),(56,5,0),(57,5,0),(58,5,0),(59,5,0),(60,5,0),(61,5,0),(62,5,0),(63,5,0),(64,5,0),(65,5,0),(66,5,0),(67,5,0),(68,5,0),(69,5,0),(70,5,0),(71,6,0),(72,6,0),(73,6,0),(74,6,0),(75,6,0),(76,6,0),(77,6,0),(78,6,0),(79,6,0),(80,6,0),(81,6,0),(82,6,0),(83,6,0),(84,6,0),(85,6,0),(86,6,0),(87,6,0),(88,6,0),(89,6,0),(90,6,0),(91,6,0),(92,6,0),(93,6,0),(94,6,0),(95,6,0),(96,6,0),(97,6,0),(98,6,0),(99,6,0),(100,6,0),(101,6,0),(102,6,0),(103,6,0),(104,6,0),(105,6,0),(106,6,0),(107,6,0),(108,6,0),(109,6,0),(110,6,0),(111,6,0),(112,6,0),(113,6,0),(114,6,0),(115,6,0),(116,6,0),(117,7,0),(118,7,0),(119,7,0),(120,7,0),(121,7,0),(122,7,0),(123,7,0),(124,7,0),(125,7,0),(126,7,0),(127,7,0),(128,7,0),(129,7,0),(130,7,0),(131,7,0),(132,7,0),(133,7,0),(134,7,0),(135,7,0),(136,7,0),(137,7,0),(138,7,0),(139,7,0),(140,7,0),(141,7,0),(142,7,0),(143,7,0),(144,7,0),(145,7,0),(146,7,0),(147,7,0),(148,7,0),(149,7,0),(150,7,0),(151,7,0),(152,7,0),(153,7,0),(154,7,0),(155,7,0),(156,7,0),(157,7,0),(158,7,0),(159,7,0),(160,7,0),(161,7,0),(162,7,0),(163,7,0),(164,7,0),(165,8,0),(166,9,0),(167,9,0),(168,9,0),(169,9,0),(170,3,0),(171,3,0),(172,3,0),(173,2,0),(174,5,0),(175,6,0),(176,7,0),(177,6,0),(178,6,0),(179,7,0),(180,7,0),(181,7,0),(182,6,0),(183,6,0),(184,6,0),(185,5,0),(186,2,0),(187,3,0),(188,4,0),(189,7,0),(190,7,0),(191,7,0),(192,7,0),(193,2,0),(194,3,0),(195,5,0),(196,6,0),(197,7,0),(198,7,0),(199,6,0),(200,3,0),(201,3,0),(202,3,0),(203,6,0),(204,6,0),(205,6,0),(206,7,0),(207,7,0),(208,7,0),(209,7,0),(210,7,0),(211,7,0),(212,7,0),(213,7,0),(214,7,0),(215,7,0),(216,7,0),(217,7,0),(218,7,0),(219,7,0),(220,7,0),(221,7,0),(222,7,0),(223,7,0),(224,7,0),(225,7,0),(226,7,0),(227,7,0),(228,7,0),(229,7,0),(230,11,0),(231,11,0),(232,11,0),(233,11,0),(234,11,0),(235,11,0),(236,12,0),(237,12,0),(238,13,0),(239,13,0),(240,15,0),(241,15,0),(242,15,0),(243,15,0),(244,15,0),(245,15,0),(246,15,0),(247,15,0),(248,15,0),(249,15,0),(250,14,0),(251,1,0),(252,1,0),(253,1,0),(254,1,0),(255,1,0),(256,1,0),(257,1,0),(258,1,0),(259,1,0),(260,1,0),(261,2,0),(262,2,0),(263,2,0),(264,2,0),(265,2,0),(266,2,0),(267,2,0),(268,2,0),(269,2,0),(270,2,0),(271,2,0),(272,2,0),(273,2,0),(274,2,0),(275,2,0),(276,3,0),(277,3,0),(278,3,0),(279,3,0),(280,3,0),(281,3,0),(282,3,0),(283,3,0),(284,3,0),(285,3,0),(286,3,0),(287,3,0),(288,3,0),(289,3,0),(290,3,0),(291,3,0),(292,4,0),(293,4,0),(294,4,0),(295,4,0),(296,4,0),(297,4,0),(298,4,0),(299,4,0),(300,4,0),(301,4,0),(302,5,0),(303,5,0),(304,5,0),(305,5,0),(306,5,0),(307,5,0),(308,5,0),(309,5,0),(310,5,0),(311,5,0),(312,5,0),(313,5,0),(314,5,0),(315,5,0),(316,5,0),(317,5,0),(318,5,0),(319,5,0),(320,5,0),(321,6,0),(322,6,0),(323,6,0),(324,6,0),(325,6,0),(326,6,0),(327,6,0),(328,6,0),(329,6,0),(330,6,0),(331,6,0),(332,6,0),(333,6,0),(334,6,0),(335,6,0),(336,6,0),(337,6,0),(338,6,0),(339,6,0),(340,6,0),(341,6,0),(342,6,0),(343,6,0),(344,6,0),(345,6,0),(346,6,0),(347,6,0),(348,6,0),(349,6,0),(350,6,0),(351,6,0),(352,6,0),(353,6,0),(354,6,0),(355,6,0),(356,6,0),(357,6,0),(358,6,0),(359,6,0),(360,6,0),(361,6,0),(362,6,0),(363,6,0),(364,6,0),(365,6,0),(366,6,0),(367,7,0),(368,7,0),(369,7,0),(370,7,0),(371,7,0),(372,7,0),(373,7,0),(374,7,0),(375,7,0),(376,7,0),(377,7,0),(378,7,0),(379,7,0),(380,7,0),(381,7,0),(382,7,0),(383,7,0),(384,7,0),(385,7,0),(386,7,0),(387,7,0),(388,7,0),(389,7,0),(390,7,0),(391,7,0),(392,7,0),(393,7,0),(394,7,0),(395,7,0),(396,7,0),(397,7,0),(398,7,0),(399,7,0),(400,7,0),(401,7,0),(402,7,0),(403,7,0),(404,7,0),(405,7,0),(406,7,0),(407,7,0),(408,7,0),(409,7,0),(410,7,0),(411,7,0),(412,7,0),(413,7,0),(414,7,0),(415,8,0),(416,9,0),(417,9,0),(418,9,0),(419,9,0),(420,3,0),(421,3,0),(422,3,0),(423,2,0),(424,5,0),(425,6,0),(426,7,0),(427,6,0),(428,6,0),(429,7,0),(430,7,0),(431,7,0),(432,6,0),(433,6,0),(434,6,0),(435,5,0),(436,2,0),(437,3,0),(438,4,0),(439,7,0),(440,7,0),(441,7,0),(442,7,0),(443,2,0),(444,3,0),(445,5,0),(446,6,0),(447,7,0),(448,7,0),(449,6,0),(450,3,0),(451,3,0),(452,3,0),(453,6,0),(454,6,0),(455,6,0),(456,7,0),(457,7,0),(458,7,0),(459,7,0),(460,7,0),(461,7,0),(462,7,0),(463,7,0),(464,7,0),(465,7,0),(466,7,0),(467,7,0),(468,7,0),(469,7,0),(470,7,0),(471,7,0),(472,7,0),(473,7,0),(474,7,0),(475,7,0),(476,7,0),(477,7,0),(478,7,0),(479,7,0),(480,11,0),(481,11,0),(482,11,0),(483,11,0),(484,11,0),(485,11,0),(486,12,0),(487,12,0),(488,13,0),(489,13,0),(490,15,0),(491,15,0),(492,15,0),(493,15,0),(494,15,0),(495,15,0),(496,15,0),(497,15,0),(498,15,0),(499,15,0),(500,14,0);
/*!40000 ALTER TABLE `rights_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'Cobrador'),(2,'Vendedor'),(3,'Comprador'),(4,'Contabilidad'),(5,'Inventario'),(6,'Gerente'),(7,'Admin'),(8,'Ver Suscripciones'),(9,'Cambiar Suscripciones'),(10,'admin');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles_users`
--

DROP TABLE IF EXISTS `roles_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles_users`
--

LOCK TABLES `roles_users` WRITE;
/*!40000 ALTER TABLE `roles_users` DISABLE KEYS */;
INSERT INTO `roles_users` VALUES (1,2,4),(2,2,7),(3,2,8),(4,2,10);
/*!40000 ALTER TABLE `roles_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_info`
--

DROP TABLE IF EXISTS `schema_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_info` (
  `version` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_info`
--

LOCK TABLES `schema_info` WRITE;
/*!40000 ALTER TABLE `schema_info` DISABLE KEYS */;
INSERT INTO `schema_info` VALUES (38);
/*!40000 ALTER TABLE `schema_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('1'),('10'),('11'),('12'),('13'),('14'),('15'),('16'),('17'),('18'),('2'),('20'),('20081209145242'),('20081209161439'),('20100119053656'),('20100119061905'),('20100208153143'),('20100208220845'),('20100209145806'),('20100220150518'),('20100220170125'),('21'),('22'),('23'),('24'),('25'),('26'),('27'),('28'),('29'),('3'),('30'),('31'),('32'),('33'),('34'),('35'),('36'),('37'),('38'),('5'),('6'),('7'),('8'),('9');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `serialized_products`
--

DROP TABLE IF EXISTS `serialized_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `serialized_products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `serial_number` varchar(255) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  KEY `serial_number` (`serial_number`),
  KEY `product_id_2` (`product_id`),
  KEY `serial_number_2` (`serial_number`),
  KEY `product_id_3` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `serialized_products`
--

LOCK TABLES `serialized_products` WRITE;
/*!40000 ALTER TABLE `serialized_products` DISABLE KEYS */;
/*!40000 ALTER TABLE `serialized_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `states`
--

DROP TABLE IF EXISTS `states`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `states` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1000 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `states`
--

LOCK TABLES `states` WRITE;
/*!40000 ALTER TABLE `states` DISABLE KEYS */;
INSERT INTO `states` VALUES (1,'Ahuachapán'),(14,'Usulután'),(13,'Sonsonate'),(11,'San Vicente'),(12,'Santa Ana'),(10,'San Salvador'),(9,'San Miguel'),(8,'Morazán'),(7,'La Unión'),(5,'La Libertad'),(6,'La Paz'),(4,'Cuscatlán'),(3,'Chalatenango'),(2,'Cabañas');
/*!40000 ALTER TABLE `states` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscriptions`
--

DROP TABLE IF EXISTS `subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `subscriptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `client_id` int(11) DEFAULT NULL,
  `vendor_id` int(11) DEFAULT NULL,
  `quantity` decimal(8,2) DEFAULT '1.00',
  `end_date` datetime DEFAULT NULL,
  `end_times` int(11) DEFAULT NULL,
  `fixed_price` decimal(8,2) DEFAULT '0.00',
  `relative_price` decimal(8,2) DEFAULT '0.00',
  `last_line_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `frequency` int(11) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `next_order_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `client_id` (`client_id`)
) ENGINE=MyISAM AUTO_INCREMENT=7665 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subscriptions`
--

LOCK TABLES `subscriptions` WRITE;
/*!40000 ALTER TABLE `subscriptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `subscriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trans`
--

DROP TABLE IF EXISTS `trans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) DEFAULT NULL,
  `comments` text,
  `created_at` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `description` varchar(32) DEFAULT NULL,
  `payment_id` int(11) DEFAULT NULL,
  `direction` int(2) DEFAULT NULL,
  `kind_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `created_at` (`created_at`),
  KEY `user_id` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=12256 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trans`
--

LOCK TABLES `trans` WRITE;
/*!40000 ALTER TABLE `trans` DISABLE KEYS */;
INSERT INTO `trans` VALUES (12254,32959,NULL,'2009-12-21 13:13:59',2,NULL,'Compra',NULL,1,1),(12255,32960,NULL,'2009-12-21 13:15:19',2,NULL,'Compra',NULL,1,1);
/*!40000 ALTER TABLE `trans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `units`
--

DROP TABLE IF EXISTS `units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `units` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (1,'Cada Uno'),(2,'Hora'),(3,'Caja'),(4,'Dolares'),(5,'Mes'),(6,'Libra'),(7,'Galones');
/*!40000 ALTER TABLE `units` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `crypted_password` varchar(40) DEFAULT NULL,
  `salt` varchar(40) DEFAULT NULL,
  `remember_token` varchar(255) DEFAULT NULL,
  `remember_token_expires_at` datetime DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `default_received` tinyint(1) DEFAULT NULL,
  `price_group_name_id` int(11) DEFAULT NULL,
  `cash_account_id` int(11) DEFAULT NULL,
  `personal_account_id` int(11) DEFAULT NULL,
  `revenue_account_id` int(11) DEFAULT NULL,
  `do_accounting` tinyint(1) DEFAULT '1',
  `name` varchar(255) DEFAULT NULL,
  `default_page` varchar(255) DEFAULT NULL,
  `date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `login` (`login`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Sistema Jade','','',NULL,NULL,NULL,5,NULL,1,NULL,NULL,NULL,1,'Sistema Jade',NULL,'2009-07-04'),(2,'jmartin','','71d52dbae5655e57b802caae4f85c24a2b4acb10','b1547f784045f4e8857bfcffb25fbf47f69c67b6',NULL,NULL,5,0,2,NULL,NULL,NULL,1,'Jared Martin',NULL,'2009-12-21');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `warranties`
--

DROP TABLE IF EXISTS `warranties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `warranties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) DEFAULT NULL,
  `price` decimal(8,2) DEFAULT NULL,
  `month_id` int(11) DEFAULT NULL,
  `order_type_id` int(11) DEFAULT NULL,
  `months` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`)
) ENGINE=MyISAM AUTO_INCREMENT=101 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `warranties`
--

LOCK TABLES `warranties` WRITE;
/*!40000 ALTER TABLE `warranties` DISABLE KEYS */;
INSERT INTO `warranties` VALUES (100,13,'0.00',NULL,NULL,0);
/*!40000 ALTER TABLE `warranties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `warranty_months`
--

DROP TABLE IF EXISTS `warranty_months`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `warranty_months` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `months` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `warranty_months`
--

LOCK TABLES `warranty_months` WRITE;
/*!40000 ALTER TABLE `warranty_months` DISABLE KEYS */;
INSERT INTO `warranty_months` VALUES (1,0),(2,6),(3,12),(4,24),(5,3);
/*!40000 ALTER TABLE `warranty_months` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-02-20 13:15:58
