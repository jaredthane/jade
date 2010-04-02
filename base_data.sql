-- MySQL dump 10.13  Distrib 5.1.37, for debian-linux-gnu (i486)
--
-- Host: localhost    Database: Jade
-- ------------------------------------------------------
-- Server version	5.1.37-1ubuntu5.1

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
  `home_phone` varchar(9) DEFAULT '',
  `office_phone` char(8) DEFAULT '',
  `address` text,
  `birth` datetime DEFAULT NULL,
  `state_id` int(11) DEFAULT NULL,
  `cell_phone` varchar(9) DEFAULT NULL,
  `nit` varchar(17) DEFAULT NULL,
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
  `fax` varchar(9) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `entity_type_id` (`entity_type_id`),
  KEY `site_id` (`site_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entities`
--

LOCK TABLES `entities` WRITE;
/*!40000 ALTER TABLE `entities` DISABLE KEYS */;
INSERT INTO `entities` VALUES (1,'Consumo Interno',NULL,NULL,NULL,'','',NULL,NULL,12,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),(2,'Varios',1,NULL,NULL,'','',NULL,NULL,12,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,17,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),(3,'Anonimo',2,NULL,NULL,'','',NULL,NULL,12,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL,5,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),(4,'No Specificado',1,NULL,NULL,'','',NULL,NULL,12,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,21,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),(5,'Principal',3,'2009-11-07 16:40:45','2009-12-21 13:13:47','','','',NULL,1,NULL,NULL,'','',NULL,NULL,1,NULL,NULL,NULL,NULL,20,16,18,17,NULL,19,NULL,'',NULL,NULL,1,'1',23,21,'10007','',NULL),(9,'Anulado',2,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL);
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
  `cost` decimal(8,2) DEFAULT NULL,
  `cost_ref` int(11) DEFAULT NULL,
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
INSERT INTO `lines` VALUES (32862,3,32874,'2.00','20.00','2009-12-02 11:56:50','2009-12-02 11:56:50','2009-12-02 13:07:41',NULL,NULL,'0.00',89,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32863,4,32875,'10.00','0.00',NULL,'2009-12-02 13:14:39','2009-12-02 13:14:39',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32864,4,32876,'1.00','0.00',NULL,'2009-12-02 14:46:14','2009-12-02 14:46:14',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32865,4,32877,'1.00','0.00',NULL,'2009-12-02 14:46:41','2009-12-02 14:46:41',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32866,4,32878,'1.00','0.00',NULL,'2009-12-02 14:48:53','2009-12-02 14:48:53',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32867,4,32879,'1.00','0.00',NULL,'2009-12-02 15:12:57','2009-12-02 15:12:57',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32868,4,32880,'1.00','0.00',NULL,'2009-12-02 15:16:25','2009-12-02 15:16:25',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32869,4,32881,'1.00','0.00',NULL,'2009-12-02 15:16:32','2009-12-02 15:16:32',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32870,5,32882,'1.00','5.00',NULL,'2009-12-02 15:28:53','2009-12-02 15:28:53',NULL,NULL,'0.00',91,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32871,5,32883,'2.00','0.00',NULL,'2009-12-02 16:06:01','2009-12-02 16:06:01',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32872,4,32884,'2.00','0.00',NULL,'2009-12-02 16:06:01','2009-12-02 16:06:01',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32873,5,32885,'1.00','0.00',NULL,'2009-12-02 16:12:00','2009-12-02 16:12:00',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32874,4,32886,'3.00','0.00',NULL,'2009-12-02 16:12:12','2009-12-02 16:12:12',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32875,4,32887,'0.00','0.00',NULL,'2009-12-02 16:14:29','2009-12-02 16:14:29',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32876,4,32888,'0.00','0.00',NULL,'2009-12-02 16:14:37','2009-12-02 16:14:37',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32877,5,32889,'0.00','0.00',NULL,'2009-12-02 16:14:45','2009-12-02 16:14:45',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32878,5,32890,'1.00','0.00',NULL,'2009-12-02 16:16:06','2009-12-02 16:16:06',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32879,5,32891,'1.00','0.00',NULL,'2009-12-02 16:16:12','2009-12-02 16:16:12',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32880,5,32892,'1.00','0.00',NULL,'2009-12-02 16:16:17','2009-12-02 16:16:17',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32881,5,32893,'0.00','0.00','2009-12-02 17:31:42','2009-12-02 16:17:14','2009-12-02 17:31:42',NULL,NULL,'0.00',91,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32882,5,32894,'0.00','0.00',NULL,'2009-12-02 16:17:20','2009-12-02 16:17:20',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32883,5,32895,'1.00','0.00',NULL,'2009-12-02 16:18:36','2009-12-02 16:18:36',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32884,5,32896,'1.00','0.00',NULL,'2009-12-02 16:18:42','2009-12-02 16:18:42',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32885,5,32897,'1.00','0.00',NULL,'2009-12-02 16:19:18','2009-12-02 16:19:18',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32886,5,32898,'3.00','0.00',NULL,'2009-12-02 17:04:25','2009-12-02 17:06:36',NULL,NULL,'0.00',91,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32887,5,32899,'1.00','0.00',NULL,'2009-12-02 17:04:31','2009-12-02 17:04:31',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32888,5,32900,'1.00','0.00',NULL,'2009-12-02 17:29:19','2009-12-02 17:29:19',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32889,5,32901,'1.00','0.00',NULL,'2009-12-02 17:31:13','2009-12-02 17:31:13',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32890,6,32904,'3.00','50.00','2009-12-02 17:47:00','2009-12-02 17:47:00','2009-12-02 17:47:00',NULL,NULL,'0.00',92,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32891,7,32905,'3.00','50.00','2009-12-02 17:49:42','2009-12-02 17:49:42','2009-12-02 17:49:42',NULL,NULL,'0.00',93,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32892,7,32906,'5.00','23.00','2009-12-02 17:51:49','2009-12-02 17:51:49','2009-12-02 17:51:49',NULL,NULL,'0.00',93,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32893,8,32906,'1.00','0.00','2009-12-02 17:52:11','2009-12-02 17:52:11','2009-12-02 17:52:11',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32894,8,32907,'1.00','0.00','2009-12-02 21:26:56','2009-12-02 21:26:56','2009-12-02 21:26:56',1,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32895,8,32907,'1.00','0.00','2009-12-02 21:26:56','2009-12-02 21:26:56','2009-12-02 21:26:56',2,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32896,8,32907,'1.00','0.00','2009-12-02 21:26:56','2009-12-02 21:26:56','2009-12-02 21:26:56',3,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32897,8,32907,'1.00','0.00','2009-12-02 21:47:30','2009-12-02 21:47:30','2009-12-02 21:47:30',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32898,8,32907,'1.00','0.00','2009-12-02 21:50:24','2009-12-02 21:50:24','2009-12-02 21:50:24',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32899,8,32907,'1.00','0.00','2009-12-02 21:53:39','2009-12-02 21:53:39','2009-12-02 21:53:39',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32900,8,32907,'1.00','0.00','2009-12-02 21:55:28','2009-12-02 21:55:28','2009-12-02 21:55:28',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32901,8,32907,'1.00','0.00','2009-12-02 21:57:09','2009-12-02 21:57:09','2009-12-02 21:57:09',4,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32902,7,32908,'1.00','13.00','2009-12-02 23:21:22','2009-12-02 23:21:22','2009-12-02 23:21:22',NULL,NULL,'0.00',93,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32903,7,32909,'1.00','13.00','2009-12-02 23:21:38','2009-12-02 23:21:38','2009-12-02 23:21:38',NULL,NULL,'0.00',93,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32904,8,32910,'1.00','23.00','2009-12-02 23:22:01','2009-12-02 23:21:54','2009-12-02 23:22:01',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32905,8,32911,'1.00','0.00','2009-12-02 23:28:05','2009-12-02 23:28:05','2009-12-02 23:28:05',1,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32908,8,32912,'1.00','0.00','2009-12-03 00:02:27','2009-12-03 00:02:27','2009-12-03 00:02:27',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32909,8,32913,'1.00','0.00','2009-12-03 00:05:59','2009-12-03 00:05:59','2009-12-03 00:05:59',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32910,8,32914,'1.00','0.00','2009-12-03 00:08:34','2009-12-03 00:08:34','2009-12-03 00:08:34',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32911,8,32915,'1.00','0.00','2009-12-03 00:10:47','2009-12-03 00:10:47','2009-12-03 00:10:47',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32912,8,32916,'1.00','0.00','2009-12-03 00:12:45','2009-12-03 00:12:46','2009-12-03 00:12:46',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32913,8,32917,'1.00','0.00','2009-12-03 00:16:36','2009-12-03 00:16:36','2009-12-03 00:16:36',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32914,8,32918,'1.00','0.00','2009-12-03 00:20:08','2009-12-03 00:19:31','2009-12-03 00:20:08',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2,NULL,NULL),(32915,8,32919,'1.00','0.00','2009-12-03 00:23:27','2009-12-03 00:23:27','2009-12-03 00:23:27',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2,NULL,NULL),(32916,8,32920,'1.00','0.00','2009-12-03 00:24:43','2009-12-03 00:24:43','2009-12-03 00:24:43',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2,NULL,NULL),(32917,8,32921,'1.00','0.00','2009-12-03 00:29:24','2009-12-03 00:29:24','2009-12-03 00:29:24',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2,NULL,NULL),(32918,8,32922,'1.00','0.00','2009-12-03 00:31:20','2009-12-03 00:31:20','2009-12-03 00:31:20',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2,NULL,NULL),(32919,8,32923,'1.00','0.00','2009-12-03 00:32:34','2009-12-03 00:32:34','2009-12-03 00:32:34',5,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2,NULL,NULL),(32920,8,32924,'1.00','0.00','2009-12-03 00:33:06','2009-12-03 00:32:51','2009-12-03 00:33:06',7,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2,NULL,NULL),(32921,8,32924,'1.00','0.00','2009-12-03 00:33:06','2009-12-03 00:33:06','2009-12-03 00:33:06',6,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2,NULL,NULL),(32922,8,32925,'1.00','5.00','2009-12-03 00:37:15','2009-12-03 00:37:15','2009-12-03 00:37:15',8,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2,NULL,NULL),(32923,8,32926,'1.00','0.00',NULL,'2009-12-03 00:47:16','2009-12-03 00:58:20',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2,NULL,NULL),(32924,8,32927,'1.00','0.00',NULL,'2009-12-03 00:48:03','2009-12-03 00:48:37',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2,NULL,NULL),(32925,8,32927,'1.00','0.00',NULL,'2009-12-03 00:48:16','2009-12-03 00:57:03',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2,NULL,NULL),(32926,8,32928,'1.00','0.00','2009-12-03 21:46:49','2009-12-03 21:46:49','2009-12-03 21:46:49',12,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2,NULL,NULL),(32927,8,32929,'1.00','0.00',NULL,'2009-12-03 21:47:39','2009-12-03 21:54:43',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2,NULL,NULL),(32928,8,32931,'1.00','0.00',NULL,'2009-12-03 21:59:14','2009-12-03 22:11:23',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2,NULL,NULL),(32929,8,32932,'1.00','50.00','2009-12-03 22:27:38','2009-12-03 22:27:38','2009-12-03 22:27:38',16,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2,NULL,NULL),(32930,8,32933,'1.00','0.00','2009-12-03 22:28:54','2009-12-03 22:28:54','2009-12-03 22:28:54',17,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2,NULL,NULL),(32931,8,32934,'1.00','0.00',NULL,'2009-12-03 22:30:35','2009-12-03 22:40:10',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2,NULL,NULL),(32932,8,32935,'1.00','0.00',NULL,'2009-12-03 22:41:14','2009-12-03 22:43:12',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2,NULL,NULL),(32933,8,32936,'1.00','0.00','2009-12-03 22:44:18','2009-12-03 22:44:18','2009-12-03 22:44:18',19,NULL,'0.00',NULL,'0.00','10.00',NULL,NULL,NULL,'0.00',5,NULL,NULL),(32934,7,32937,'4.00','0.00','2009-12-04 00:26:29','2009-12-03 23:21:13','2009-12-04 00:26:29',20,NULL,'0.00',93,'0.00',NULL,NULL,NULL,NULL,'0.00',2,NULL,NULL),(32935,7,32938,'5.00','0.00','2009-12-03 23:28:09','2009-12-03 23:28:09','2009-12-03 23:28:10',NULL,NULL,'0.00',NULL,'0.00','9.00',NULL,NULL,NULL,'0.00',5,NULL,NULL),(32936,7,32937,'2.00','39.20','2009-12-04 00:26:29','2009-12-03 23:44:05','2009-12-04 00:26:30',20,NULL,'0.00',93,'0.00',NULL,NULL,NULL,NULL,'0.00',2,NULL,NULL),(32937,7,32939,'4.00','39.20','2009-12-04 00:11:17','2009-12-04 00:08:00','2009-12-04 00:11:17',NULL,NULL,'0.00',93,'0.00',NULL,NULL,NULL,NULL,'0.00',2,NULL,NULL),(32938,8,32939,'1.00','2.00','2009-12-04 00:11:17','2009-12-04 00:08:00','2009-12-04 00:11:17',22,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2,NULL,NULL),(32939,7,NULL,'0.00','0.00',NULL,'2009-12-04 00:18:34','2009-12-04 00:18:34',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL,NULL,NULL),(32940,7,32942,'1.00','45.00','2009-12-04 00:57:06','2009-12-04 00:57:06','2009-12-04 01:18:17',NULL,NULL,'0.00',93,'0.00',NULL,NULL,NULL,NULL,'0.00',2,NULL,NULL),(32941,11,32945,'100.00','25.00','2009-12-18 08:29:35','2009-12-18 08:29:35','2009-12-18 08:29:35',NULL,NULL,'0.00',98,'0.00',NULL,NULL,NULL,NULL,'0.00',2,NULL,NULL),(32942,11,32946,'1.00','30.00','2009-12-18 08:37:36','2009-12-18 08:37:37','2009-12-18 08:37:37',NULL,NULL,'0.00',98,'0.00',NULL,NULL,NULL,NULL,'0.00',1,NULL,NULL),(32943,11,32947,'1.00','30.00','2009-12-18 08:41:30','2009-12-18 08:41:31','2009-12-18 08:41:31',NULL,NULL,'0.00',98,'0.00',NULL,NULL,NULL,NULL,'0.00',1,NULL,NULL),(32944,11,32948,'1.00','30.00','2009-12-18 09:03:05','2009-12-18 09:03:05','2009-12-18 09:03:05',NULL,NULL,'0.00',98,'0.00',NULL,NULL,NULL,NULL,'0.00',1,NULL,NULL),(32945,11,32950,'1.00','30.00','2009-12-18 09:42:48','2009-12-18 09:42:48','2009-12-18 09:42:48',NULL,NULL,'0.00',98,'0.00',NULL,NULL,NULL,NULL,'0.00',1,NULL,NULL),(32946,11,32951,'1.00','30.00','2009-12-18 09:45:27','2009-12-18 09:45:27','2009-12-18 09:45:27',NULL,NULL,'0.00',98,'0.00',NULL,NULL,NULL,NULL,'0.00',1,NULL,NULL),(32947,11,32952,'100.00','250.00','2009-12-21 13:03:01','2009-12-20 22:20:55','2009-12-21 13:03:01',NULL,NULL,'0.00',NULL,'0.00','90.00',NULL,NULL,NULL,'0.00',5,NULL,NULL),(32948,11,32953,'1.00','10.00','2009-12-20 23:51:22','2009-12-20 23:51:22','2009-12-20 23:51:22',NULL,NULL,'0.00',98,'0.00',NULL,NULL,NULL,NULL,'0.00',1,NULL,NULL),(32949,11,32954,'90.00','-250.00','2009-12-21 12:52:19','2009-12-21 00:17:41','2009-12-21 12:52:19',NULL,NULL,'0.00',NULL,'0.00','100.00',NULL,NULL,NULL,'0.00',5,NULL,NULL),(32950,12,32955,'10.00','100.00','2009-12-21 12:55:57','2009-12-21 12:55:44','2009-12-21 12:55:57',NULL,NULL,'0.00',NULL,'0.00','0.00',NULL,NULL,NULL,'0.00',5,NULL,NULL),(32951,12,32956,'5.00','-50.00','2009-12-21 12:57:04','2009-12-21 12:56:42','2009-12-21 12:57:04',NULL,NULL,'0.00',NULL,'0.00','10.00',NULL,NULL,NULL,'0.00',5,NULL,NULL),(32952,12,32957,'20.00','0.00','2009-12-21 13:13:29','2009-12-21 13:05:46','2009-12-21 13:13:29',NULL,NULL,'0.00',NULL,'0.00','20.00',NULL,NULL,NULL,'0.00',5,NULL,NULL),(32953,11,32958,'99.00','-25.00','2009-12-21 13:14:12','2009-12-21 13:13:47','2009-12-21 13:14:12',NULL,NULL,'0.00',NULL,'0.00','100.00',NULL,NULL,NULL,'0.00',5,NULL,NULL),(32955,13,32960,'1.00','1.00',NULL,'2010-02-20 13:15:19','2010-02-20 13:15:19',NULL,NULL,'0.00',100,'0.00',NULL,NULL,NULL,NULL,'0.00',2,NULL,NULL);
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
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
  `total_revenue` decimal(8,2) DEFAULT NULL,
  `total_expense` decimal(8,2) DEFAULT NULL,
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
INSERT INTO `orders` VALUES (32960,4,5,NULL,2,'2009-12-21 13:15:19','2010-04-02 11:35:27',NULL,NULL,NULL,'',2,'1.13','0.00',0,NULL,NULL,'/home/jared/oldjade/invoice_pdfs/32960.pdf',NULL,'1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'1.00','0.00');
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
-- Table structure for table `report_parts`
--

DROP TABLE IF EXISTS `report_parts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `report_parts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `content` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report_parts`
--

LOCK TABLES `report_parts` WRITE;
/*!40000 ALTER TABLE `report_parts` DISABLE KEYS */;
INSERT INTO `report_parts` VALUES (1,1,'Cabezera','**Hello**'),(2,1,'Linea','* Heres a line'),(3,1,'Pie','This is the end of the road'),(4,2,'Cabezera',''),(5,2,'Linea',''),(6,2,'Pie',''),(7,3,'Cabezera',''),(8,3,'Linea',''),(9,3,'Pie',''),(10,4,'Cabezera',''),(11,4,'Linea',''),(12,4,'Pie','');
/*!40000 ALTER TABLE `report_parts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `report_templates`
--

DROP TABLE IF EXISTS `report_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `report_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `content` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report_templates`
--

LOCK TABLES `report_templates` WRITE;
/*!40000 ALTER TABLE `report_templates` DISABLE KEYS */;
INSERT INTO `report_templates` VALUES (1,'Factura','Factura# {{@order.receipt_number}}\r\n{% for line in @order.lines %}\r\n  Product:{{ line.product.name }}\r\n{% endfor %}');
/*!40000 ALTER TABLE `report_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reports`
--

DROP TABLE IF EXISTS `reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reports`
--

LOCK TABLES `reports` WRITE;
/*!40000 ALTER TABLE `reports` DISABLE KEYS */;
INSERT INTO `reports` VALUES (1,'Factura'),(2,'Lista de Productos'),(3,'Cuenta Fisica'),(4,'Cotizacion');
/*!40000 ALTER TABLE `reports` ENABLE KEYS */;
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
INSERT INTO `rights` VALUES ('CHANGE_ACCOUNTS','Cambiar Cuentas'),('CHANGE_CLIENTS','Cambiar Clientes'),('CHANGE_COMBOS','Cambiar Combos'),('CHANGE_COUNTS','Cambiar Cuentas Fisicas'),('CHANGE_DISCOUNTS','Cambiar Descuentos'),('CHANGE_INTERNAL_CONSUMPTIONS','Cambiar Consumos Internos'),('CHANGE_LABELS','Cambiar Etiquetas'),('CHANGE_PAYMENTS_FOR_PURCHASES','Cambiar Pagos para Compras'),('CHANGE_PAYMENTS_FOR_SALES','Cambiar Pagos para Ventas'),('CHANGE_PRICES','Cambiar Prices'),('CHANGE_PRODUCTION_ORDERS','Cambiar Ordenes de Produccion'),('CHANGE_PRODUCTION_PROCESSES','Cambiar Procesos de Produccion'),('CHANGE_PRODUCTS','Cambiar Productos'),('CHANGE_PURCHASES','Cambiar Compras'),('CHANGE_REPORTS','Cambiar Plantillas de Reportes'),('CHANGE_ROLES','Cambiar Papeles'),('CHANGE_SALES','Cambiar Ventas'),('CHANGE_SERIAL_NUMBERS','Cambiar Numeros de Serie'),('CHANGE_SERVICES','Cambiar Servicios'),('CHANGE_SITES','Cambiar Sitios'),('CHANGE_SUBSCRIPTIONS','Cambiar Suscripciones'),('CHANGE_TRANSACTIONS','Cambiar Transacciones'),('CHANGE_USERS','Cambiar Usuarios'),('CHANGE_VENDORS','Cambiar Proveedores'),('CHANGE_WARRANTIES','Cambiar Garantias'),('CREATE_ACCOUNTS','Crear Cuentas'),('CREATE_CLIENTS','Crear Clientes'),('CREATE_COMBOS','Crear Combos'),('CREATE_COUNTS','Crear Cuentas Fisicas'),('CREATE_DISCOUNTS','Crear Descuentos'),('CREATE_INTERNAL_CONSUMPTIONS','Crear Consumos Internos'),('CREATE_LABELS','Hacer Etiquetas'),('CREATE_PAYMENTS_FOR_PURCHASES','Crear Pagos para Compras'),('CREATE_PAYMENTS_FOR_SALES','Crear Pagos para Ventas'),('CREATE_PRODUCTION_ORDERS','Crear Ordenes de Produccion'),('CREATE_PRODUCTION_PROCESSES','Crear Procesos de Produccion'),('CREATE_PRODUCTS','Crear Productos'),('CREATE_PURCHASES','Crear Compras'),('CREATE_ROLES','Crear Papeles'),('CREATE_SALES','Crear Ventas'),('CREATE_SERIAL_NUMBERS','Crear Numeros de Serie'),('CREATE_SERVICES','Crear Servicios'),('CREATE_SITES','Crear Sitios'),('CREATE_SUBSCRIPTIONS','Crear Suscripciones'),('CREATE_TRANSACTIONS','Crear Transacciones'),('CREATE_USERS','Crear Usuarios'),('CREATE_VENDORS','Crear Proveedores'),('CREATE_WARRANTIES','Crear Garantias'),('DELETE_ACCOUNTS','Borrar Cuentas'),('DELETE_CLIENTS','Borrar Clientes'),('DELETE_COMBOS','Borrar Combos'),('DELETE_COUNTS','Borrar Cuentas Fisicas'),('DELETE_DISCOUNTS','Borrar Descuentos'),('DELETE_INTERNAL_CONSUMPTIONS','Borrar Consumos Internos'),('DELETE_LABELS','Borrar Etiquetas'),('DELETE_PAYMENTS_FOR_PURCHASES','Borrar Pagos para Compras'),('DELETE_PAYMENTS_FOR_SALES','Borrar Pagos para Ventas'),('DELETE_PRODUCTION_ORDERS','Borrar Ordenes de Produccion'),('DELETE_PRODUCTION_PROCESSES','Borrar Procesos de Produccion'),('DELETE_PRODUCTS','Borrar Productos'),('DELETE_PURCHASES','Borrar Compras'),('DELETE_ROLES','Borrar Papeles'),('DELETE_SALES','Borrar Ventas'),('DELETE_SERIAL_NUMBERS','Borrar Numeros de Serie'),('DELETE_SERVICES','Borrar Servicios'),('DELETE_SITES','Borrar Sitios'),('DELETE_SUBSCRIPTIONS','Borrar Suscripciones'),('DELETE_TRANSACTIONS','Borrar Transacciones'),('DELETE_USERS','Borrar Usuarios'),('DELETE_VENDORS','Borrar Proveedores'),('DELETE_WARRANTIES','Borrar Garantias'),('FINISH_PRODUCTION_ORDERS','Terminar Ordenes de Produccion'),('POST_COUNTS','Procesar Cuentas Fisicas'),('START_PRODUCTION_ORDERS','Iniciar Ordenes de Produccion'),('VIEW_ACCOUNTS','Ver Cuentas'),('VIEW_CLIENTS','Ver Clientes'),('VIEW_COMBOS','Ver Combos'),('VIEW_COSTS','Ver Costos'),('VIEW_COUNTS','Ver Cuentas Fisicas'),('VIEW_DISCOUNTS','Ver Descuentos'),('VIEW_INTERNAL_CONSUMPTIONS','Ver Consumos Internos'),('VIEW_LABELS','Ver Etiquetas'),('VIEW_PAYMENTS_FOR_PURCHASES','Ver Pagos para Compras'),('VIEW_PAYMENTS_FOR_SALES','Ver Pagos para Ventas'),('VIEW_PRODUCTION_ORDERS','Ver Ordenes de Produccion'),('VIEW_PRODUCTION_PROCESSES','Ver Procesos de Produccion'),('VIEW_PRODUCTS','Ver Productos'),('VIEW_PURCHASES','Ver Compras'),('VIEW_REPORTS','Ver Plantillas de Reportes'),('VIEW_ROLES','Ver Papeles'),('VIEW_SALES','Ver Ventas'),('VIEW_SERIAL_NUMBERS','Ver Numeros de Serie'),('VIEW_SERVICES','Ver Servicios'),('VIEW_SITES','Ver Sitios'),('VIEW_SUBSCRIPTIONS','Ver Suscripciones'),('VIEW_TRANSACTIONS','Ver Transacciones'),('VIEW_USERS','Ver Usuarios'),('VIEW_VENDORS','Ver Proveedores'),('VIEW_WARRANTIES','Ver Garantias');
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
  `old_id` int(32) DEFAULT NULL,
  `right_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=771 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rights_roles`
--

LOCK TABLES `rights_roles` WRITE;
/*!40000 ALTER TABLE `rights_roles` DISABLE KEYS */;
INSERT INTO `rights_roles` VALUES (348,1,1,'CREATE_PAYMENTS_PARA_SALES'),(349,1,2,'CHANGE_PAYMENTS_PARA_SALES'),(350,1,3,'VIEW_PAYMENTS_PARA_SALES'),(351,1,11,'VIEW_SALES'),(352,1,19,'VIEW_CLIENTS'),(354,1,43,'VIEW_SITIOS'),(355,1,56,'VIEW_SERVICIOS'),(356,1,60,'VIEW_COMBOS'),(357,1,64,'VIEW_DESCUENTOS'),(358,2,3,'VIEW_PAYMENTS_PARA_SALES'),(359,2,9,'CREATE_SALES'),(360,2,10,'CHANGE_SALES'),(361,2,11,'VIEW_SALES'),(362,2,17,'CREATE_CLIENTS'),(363,2,18,'CHANGE_CLIENTS'),(364,2,19,'VIEW_CLIENTS'),(368,2,27,'VIEW_PRODUCTOS'),(369,2,43,'VIEW_SITIOS'),(370,2,56,'VIEW_SERVICIOS'),(371,2,60,'VIEW_COMBOS'),(372,2,64,'VIEW_DESCUENTOS'),(373,3,5,'CREATE_PAYMENTS_PARA_PURCHASES'),(374,3,6,'CHANGE_PAYMENTS_PARA_PURCHASES'),(375,3,7,'VIEW_PAYMENTS_PARA_PURCHASES'),(376,3,11,'VIEW_SALES'),(377,3,13,'CREATE_PURCHASES'),(378,3,14,'CHANGE_PURCHASES'),(379,3,15,'VIEW_PURCHASES'),(380,3,16,'DELETE_PURCHASES'),(381,3,25,'CREATE_PRODUCTOS'),(382,3,26,'CHANGE_PRODUCTOS'),(383,3,27,'VIEW_PRODUCTOS'),(384,3,43,'VIEW_SITIOS'),(385,3,49,'VIEW_COSTS'),(386,3,56,'VIEW_SERVICIOS'),(387,3,60,'VIEW_COMBOS'),(388,3,64,'VIEW_DESCUENTOS'),(389,4,3,'VIEW_PAYMENTS_PARA_SALES'),(390,4,7,'VIEW_PAYMENTS_PARA_PURCHASES'),(391,4,11,'VIEW_SALES'),(392,4,15,'VIEW_PURCHASES'),(393,4,43,'VIEW_SITIOS'),(394,4,49,'VIEW_COSTS'),(395,4,50,'CREATE_CUENTAS'),(396,4,51,'CHANGE_CUENTAS'),(397,4,52,'VIEW_CUENTAS'),(398,4,53,'DELETE_CUENTAS'),(399,5,11,'VIEW_SALES'),(400,5,15,'VIEW_PURCHASES'),(401,5,19,'VIEW_CLIENTS'),(403,5,25,'CREATE_PRODUCTOS'),(404,5,26,'CHANGE_PRODUCTOS'),(405,5,27,'VIEW_PRODUCTOS'),(406,5,31,'VIEW_SUSCRIPCIONES'),(407,5,43,'VIEW_SITIOS'),(408,5,45,'CREATE_CUENTAS_FISICAS'),(409,5,46,'CHANGE_CUENTAS_FISICAS'),(410,5,47,'VIEW_CUENTAS_FISICAS'),(411,5,48,'DELETE_CUENTAS_FISICAS'),(412,5,49,'VIEW_COSTS'),(413,5,56,'VIEW_SERVICIOS'),(414,5,58,'CREATE_COMBOS'),(415,5,59,'CHANGE_COMBOS'),(416,5,60,'VIEW_COMBOS'),(417,5,64,'VIEW_DESCUENTOS'),(418,6,1,'CREATE_PAYMENTS_PARA_SALES'),(419,6,2,'CHANGE_PAYMENTS_PARA_SALES'),(420,6,3,'VIEW_PAYMENTS_PARA_SALES'),(421,6,5,'CREATE_PAYMENTS_PARA_PURCHASES'),(422,6,6,'CHANGE_PAYMENTS_PARA_PURCHASES'),(423,6,7,'VIEW_PAYMENTS_PARA_PURCHASES'),(424,6,9,'CREATE_SALES'),(425,6,10,'CHANGE_SALES'),(426,6,11,'VIEW_SALES'),(427,6,12,'DELETE_SALES'),(428,6,13,'CREATE_PURCHASES'),(429,6,14,'CHANGE_PURCHASES'),(430,6,15,'VIEW_PURCHASES'),(431,6,16,'DELETE_PURCHASES'),(432,6,17,'CREATE_CLIENTS'),(433,6,18,'CHANGE_CLIENTS'),(434,6,19,'VIEW_CLIENTS'),(438,6,25,'CREATE_PRODUCTOS'),(439,6,26,'CHANGE_PRODUCTOS'),(440,6,27,'VIEW_PRODUCTOS'),(441,6,29,'CREATE_SUSCRIPCIONES'),(442,6,30,'CHANGE_SUSCRIPCIONES'),(443,6,31,'VIEW_SUSCRIPCIONES'),(444,6,32,'DELETE_SUSCRIPCIONES'),(445,6,43,'VIEW_SITIOS'),(446,6,45,'CREATE_CUENTAS_FISICAS'),(447,6,46,'CHANGE_CUENTAS_FISICAS'),(448,6,47,'VIEW_CUENTAS_FISICAS'),(449,6,48,'DELETE_CUENTAS_FISICAS'),(450,6,49,'VIEW_COSTS'),(451,6,50,'CREATE_CUENTAS'),(452,6,51,'CHANGE_CUENTAS'),(453,6,52,'VIEW_CUENTAS'),(454,6,53,'DELETE_CUENTAS'),(455,6,54,'CREATE_SERVICIOS'),(456,6,55,'CHANGE_SERVICIOS'),(457,6,56,'VIEW_SERVICIOS'),(458,6,58,'CREATE_COMBOS'),(459,6,59,'CHANGE_COMBOS'),(460,6,60,'VIEW_COMBOS'),(461,6,62,'CREATE_DESCUENTOS'),(462,6,63,'CHANGE_DESCUENTOS'),(463,6,64,'VIEW_DESCUENTOS'),(512,8,31,'VIEW_SUSCRIPCIONES'),(513,9,29,'CREATE_SUSCRIPCIONES'),(514,9,30,'CHANGE_SUSCRIPCIONES'),(515,9,31,'VIEW_SUSCRIPCIONES'),(516,9,32,'DELETE_SUSCRIPCIONES'),(517,3,66,'CREATE_GARANTIAS'),(518,3,67,'CHANGE_GARANTIAS'),(519,3,68,'VIEW_GARANTIAS'),(520,2,68,'VIEW_GARANTIAS'),(521,5,68,'VIEW_GARANTIAS'),(522,6,68,'VIEW_GARANTIAS'),(524,6,66,'CREATE_GARANTIAS'),(525,6,67,'CHANGE_GARANTIAS'),(530,6,70,'CREATE_CONSUMOS_INTERNOS'),(531,6,71,'CHANGE_CONSUMOS_INTERNOS'),(532,6,72,'VIEW_CONSUMOS_INTERNOS'),(533,5,72,'VIEW_CONSUMOS_INTERNOS'),(534,2,72,'VIEW_CONSUMOS_INTERNOS'),(535,3,72,'VIEW_CONSUMOS_INTERNOS'),(536,4,72,'VIEW_CONSUMOS_INTERNOS'),(541,2,76,'VIEW_NUMEROS_DE_SERIE'),(542,3,76,'VIEW_NUMEROS_DE_SERIE'),(543,5,76,'VIEW_NUMEROS_DE_SERIE'),(544,6,76,'VIEW_NUMEROS_DE_SERIE'),(547,6,78,'CHANGE_PRICES'),(548,3,79,'CREATE_PROVEEDORES'),(549,3,80,'CHANGE_PROVEEDORES'),(550,3,81,'VIEW_PROVEEDORES'),(551,6,81,'VIEW_PROVEEDORES'),(552,6,79,'CREATE_PROVEEDORES'),(553,6,80,'CHANGE_PROVEEDORES'),(606,7,1,'CREATE_PAYMENTS_PARA_SALES'),(607,7,2,'CHANGE_PAYMENTS_PARA_SALES'),(608,7,3,'VIEW_PAYMENTS_PARA_SALES'),(609,7,4,'DELETE_PAYMENTS_PARA_SALES'),(610,7,5,'CREATE_PAYMENTS_PARA_PURCHASES'),(611,7,6,'CHANGE_PAYMENTS_PARA_PURCHASES'),(612,7,7,'VIEW_PAYMENTS_PARA_PURCHASES'),(613,7,8,'DELETE_PAYMENTS_PARA_PURCHASES'),(614,7,9,'CREATE_SALES'),(615,7,10,'CHANGE_SALES'),(616,7,11,'VIEW_SALES'),(617,7,12,'DELETE_SALES'),(618,7,13,'CREATE_PURCHASES'),(619,7,14,'CHANGE_PURCHASES'),(620,7,15,'VIEW_PURCHASES'),(621,7,16,'DELETE_PURCHASES'),(622,7,17,'CREATE_CLIENTS'),(623,7,18,'CHANGE_CLIENTS'),(624,7,19,'VIEW_CLIENTS'),(625,7,20,'DELETE_CLIENTS'),(630,7,25,'CREATE_PRODUCTOS'),(631,7,26,'CHANGE_PRODUCTOS'),(632,7,27,'VIEW_PRODUCTOS'),(633,7,28,'DELETE_PRODUCTOS'),(634,7,29,'CREATE_SUSCRIPCIONES'),(635,7,30,'CHANGE_SUSCRIPCIONES'),(636,7,31,'VIEW_SUSCRIPCIONES'),(637,7,32,'DELETE_SUSCRIPCIONES'),(638,7,33,'CREATE_PAPELES'),(639,7,34,'CHANGE_PAPELES'),(640,7,35,'VIEW_PAPELES'),(641,7,36,'DELETE_PAPELES'),(642,7,37,'CREATE_USUARIOS'),(643,7,38,'CHANGE_USUARIOS'),(644,7,39,'VIEW_USUARIOS'),(645,7,40,'DELETE_USUARIOS'),(646,7,41,'CREATE_SITIOS'),(647,7,42,'CHANGE_SITIOS'),(648,7,43,'VIEW_SITIOS'),(649,7,44,'DELETE_SITIOS'),(650,7,45,'CREATE_CUENTAS_FISICAS'),(651,7,46,'CHANGE_CUENTAS_FISICAS'),(652,7,47,'VIEW_CUENTAS_FISICAS'),(653,7,48,'DELETE_CUENTAS_FISICAS'),(654,7,49,'VIEW_COSTS'),(655,7,50,'CREATE_CUENTAS'),(656,7,51,'CHANGE_CUENTAS'),(657,7,52,'VIEW_CUENTAS'),(658,7,53,'DELETE_CUENTAS'),(659,7,54,'CREATE_SERVICIOS'),(660,7,55,'CHANGE_SERVICIOS'),(661,7,56,'VIEW_SERVICIOS'),(662,7,57,'DELETE_SERVICIOS'),(663,7,58,'CREATE_COMBOS'),(664,7,59,'CHANGE_COMBOS'),(665,7,60,'VIEW_COMBOS'),(666,7,61,'DELETE_COMBOS'),(667,7,62,'CREATE_DESCUENTOS'),(668,7,63,'CHANGE_DESCUENTOS'),(669,7,64,'VIEW_DESCUENTOS'),(670,7,65,'DELETE_DESCUENTOS'),(671,7,66,'CREATE_GARANTIAS'),(672,7,67,'CHANGE_GARANTIAS'),(673,7,68,'VIEW_GARANTIAS'),(674,7,69,'DELETE_GARANTIAS'),(675,7,70,'CREATE_CONSUMOS_INTERNOS'),(676,7,71,'CHANGE_CONSUMOS_INTERNOS'),(677,7,72,'VIEW_CONSUMOS_INTERNOS'),(678,7,73,'DELETE_CONSUMOS_INTERNOS'),(679,7,74,'CREATE_NUMEROS_DE_SERIE'),(680,7,75,'CHANGE_NUMEROS_DE_SERIE'),(681,7,76,'VIEW_NUMEROS_DE_SERIE'),(682,7,77,'DELETE_NUMEROS_DE_SERIE'),(683,7,78,'CHANGE_PRICES'),(684,7,79,'CREATE_PROVEEDORES'),(685,7,80,'CHANGE_PROVEEDORES'),(686,7,81,'VIEW_PROVEEDORES'),(687,7,82,'DELETE_PROVEEDORES'),(688,6,NULL,'CHANGE_REPORTS'),(689,6,NULL,'VIEW_REPORTS'),(690,7,NULL,'CHANGE_REPORTS'),(691,7,NULL,'VIEW_REPORTS'),(692,7,NULL,'CHANGE_ACCOUNTS'),(693,7,NULL,'CHANGE_COUNTS'),(694,7,NULL,'CHANGE_DISCOUNTS'),(695,7,NULL,'CHANGE_INTERNAL_CONSUMPTIONS'),(696,7,NULL,'CHANGE_LABELS'),(697,7,NULL,'CHANGE_PAYMENTS_FOR_PURCHASES'),(698,7,NULL,'CHANGE_PAYMENTS_FOR_SALES'),(699,7,NULL,'CHANGE_PRODUCTION_ORDERS'),(700,7,NULL,'CHANGE_PRODUCTION_PROCESSES'),(701,7,NULL,'CHANGE_PRODUCTS'),(702,7,NULL,'CHANGE_ROLES'),(703,7,NULL,'CHANGE_SERIAL_NUMBERS'),(704,7,NULL,'CHANGE_SERVICES'),(705,7,NULL,'CHANGE_SITES'),(706,7,NULL,'CHANGE_SUBSCRIPTIONS'),(707,7,NULL,'CHANGE_TRANSACTIONS'),(708,7,NULL,'CHANGE_USERS'),(709,7,NULL,'CHANGE_VENDORS'),(710,7,NULL,'CHANGE_WARRANTIES'),(711,7,NULL,'CREATE_ACCOUNTS'),(712,7,NULL,'CREATE_COUNTS'),(713,7,NULL,'CREATE_DISCOUNTS'),(714,7,NULL,'CREATE_INTERNAL_CONSUMPTIONS'),(715,7,NULL,'CREATE_LABELS'),(716,7,NULL,'CREATE_PAYMENTS_FOR_PURCHASES'),(717,7,NULL,'CREATE_PAYMENTS_FOR_SALES'),(718,7,NULL,'CREATE_PRODUCTION_ORDERS'),(719,7,NULL,'CREATE_PRODUCTION_PROCESSES'),(720,7,NULL,'CREATE_PRODUCTS'),(721,7,NULL,'CREATE_ROLES'),(722,7,NULL,'CREATE_SERIAL_NUMBERS'),(723,7,NULL,'CREATE_SERVICES'),(724,7,NULL,'CREATE_SITES'),(725,7,NULL,'CREATE_SUBSCRIPTIONS'),(726,7,NULL,'CREATE_TRANSACTIONS'),(727,7,NULL,'CREATE_USERS'),(728,7,NULL,'CREATE_VENDORS'),(729,7,NULL,'CREATE_WARRANTIES'),(730,7,NULL,'DELETE_ACCOUNTS'),(731,7,NULL,'DELETE_COUNTS'),(732,7,NULL,'DELETE_DISCOUNTS'),(733,7,NULL,'DELETE_INTERNAL_CONSUMPTIONS'),(734,7,NULL,'DELETE_LABELS'),(735,7,NULL,'DELETE_PAYMENTS_FOR_PURCHASES'),(736,7,NULL,'DELETE_PAYMENTS_FOR_SALES'),(737,7,NULL,'DELETE_PRODUCTION_ORDERS'),(738,7,NULL,'DELETE_PRODUCTION_PROCESSES'),(739,7,NULL,'DELETE_PRODUCTS'),(740,7,NULL,'DELETE_ROLES'),(741,7,NULL,'DELETE_SERIAL_NUMBERS'),(742,7,NULL,'DELETE_SERVICES'),(743,7,NULL,'DELETE_SITES'),(744,7,NULL,'DELETE_SUBSCRIPTIONS'),(745,7,NULL,'DELETE_TRANSACTIONS'),(746,7,NULL,'DELETE_USERS'),(747,7,NULL,'DELETE_VENDORS'),(748,7,NULL,'DELETE_WARRANTIES'),(749,7,NULL,'FINISH_PRODUCTION_ORDERS'),(750,7,NULL,'POST_COUNTS'),(751,7,NULL,'START_PRODUCTION_ORDERS'),(752,7,NULL,'VIEW_ACCOUNTS'),(753,7,NULL,'VIEW_COUNTS'),(754,7,NULL,'VIEW_DISCOUNTS'),(755,7,NULL,'VIEW_INTERNAL_CONSUMPTIONS'),(756,7,NULL,'VIEW_LABELS'),(757,7,NULL,'VIEW_PAYMENTS_FOR_PURCHASES'),(758,7,NULL,'VIEW_PAYMENTS_FOR_SALES'),(759,7,NULL,'VIEW_PRODUCTION_ORDERS'),(760,7,NULL,'VIEW_PRODUCTION_PROCESSES'),(761,7,NULL,'VIEW_PRODUCTS'),(762,7,NULL,'VIEW_ROLES'),(763,7,NULL,'VIEW_SERIAL_NUMBERS'),(764,7,NULL,'VIEW_SERVICES'),(765,7,NULL,'VIEW_SITES'),(766,7,NULL,'VIEW_SUBSCRIPTIONS'),(767,7,NULL,'VIEW_TRANSACTIONS'),(768,7,NULL,'VIEW_USERS'),(769,7,NULL,'VIEW_VENDORS'),(770,7,NULL,'VIEW_WARRANTIES');
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
INSERT INTO `schema_migrations` VALUES ('1'),('10'),('11'),('12'),('13'),('14'),('15'),('16'),('17'),('18'),('2'),('20'),('20081209145242'),('20081209161439'),('20100119053656'),('20100119061905'),('20100208153143'),('20100208220845'),('20100209145806'),('20100220150518'),('20100220170125'),('20100220195536'),('20100220213221'),('20100220224933'),('20100303204450'),('20100304170341'),('20100318162504'),('20100402172852'),('21'),('22'),('23'),('24'),('25'),('26'),('27'),('28'),('29'),('3'),('30'),('31'),('32'),('33'),('34'),('35'),('36'),('37'),('38'),('5'),('6'),('7'),('8'),('9');
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
INSERT INTO `users` VALUES (1,'Sistema Jade','','',NULL,NULL,NULL,5,NULL,1,NULL,NULL,NULL,1,'Sistema Jade',NULL,'2009-07-04'),(2,'jmartin','','71d52dbae5655e57b802caae4f85c24a2b4acb10','b1547f784045f4e8857bfcffb25fbf47f69c67b6',NULL,NULL,5,0,2,NULL,NULL,NULL,1,'Jared Martin',NULL,'2010-04-02');
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

-- Dump completed on 2010-04-02 17:35:39
