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
  `postable` tinyint(1) DEFAULT NULL,
  `number` varchar(20) DEFAULT NULL,
  `transparent_journal` tinyint(1) DEFAULT NULL,
  `modifier` int(2) DEFAULT NULL,
  `balance` decimal(8,2) DEFAULT '0.00',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=32 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` VALUES (2,'Activos',NULL,NULL,NULL,'1',NULL,1,'0.00'),(3,'Pasivos',NULL,NULL,NULL,'2',NULL,-1,'0.00'),(4,'Patrimonio',NULL,NULL,NULL,'3',NULL,-1,'0.00'),(5,'Ingresos',NULL,NULL,NULL,'4',NULL,-1,'0.00'),(6,'Gastos',NULL,NULL,NULL,'5',NULL,1,'0.00'),(7,'Efectivo',2,NULL,NULL,'11',NULL,1,'0.00'),(8,'Inventario',2,NULL,NULL,'12',NULL,1,'0.00'),(9,'Cuenta Bancaria',2,NULL,NULL,'13',NULL,1,'0.00'),(10,'Cuentas a Cobrar',2,NULL,NULL,'14',NULL,-1,'0.00'),(11,'Cuentas por Pagar',3,NULL,NULL,'21',NULL,-1,'0.00'),(12,'Impuesto',3,NULL,NULL,'22',NULL,-1,'0.00'),(13,'Empleados',11,NULL,NULL,'211',NULL,-1,'0.00'),(14,'Proveedores',11,NULL,NULL,'212',NULL,-1,'0.00'),(15,'Clientes',10,NULL,NULL,'141',NULL,1,'0.00'),(16,'Efectivo en Principal',7,5,NULL,'',NULL,1,'0.00'),(17,'Gastos en Principal',6,5,NULL,'',NULL,1,'0.00'),(18,'Ingresos en Principal',5,5,NULL,'',NULL,-1,'0.00'),(19,'Impuestos en Principal',12,5,NULL,'',NULL,-1,'0.00'),(20,'Inventario en Principal',8,5,NULL,'',NULL,1,'0.00'),(21,'Principal Proveedores',14,NULL,NULL,'',NULL,-1,'0.00'),(22,'Principal Empleados',13,NULL,NULL,'',NULL,-1,'0.00'),(23,'Principal Clientes',15,NULL,NULL,'',NULL,1,'0.00');
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
  `quantity` int(11) DEFAULT NULL,
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entities`
--

LOCK TABLES `entities` WRITE;
/*!40000 ALTER TABLE `entities` DISABLE KEYS */;
INSERT INTO `entities` VALUES (1,'Consumo Interno',NULL,NULL,NULL,'','',NULL,NULL,12,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL),(2,'Varios',1,NULL,NULL,'','',NULL,NULL,12,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,17,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL),(3,'Anonimo',2,NULL,NULL,'','',NULL,NULL,12,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL,5,NULL,10,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL),(4,'No Specificado',1,NULL,NULL,'','',NULL,NULL,12,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,21,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL),(5,'Principal',3,'2009-11-07 16:40:45','2009-12-04 01:18:18','','','',NULL,1,NULL,NULL,'','',NULL,NULL,1,NULL,NULL,NULL,NULL,20,16,18,17,NULL,19,NULL,'',NULL,NULL,1,'4169',23,21,'10005',''),(9,'Anulado',2,NULL,NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL);
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
  KEY `created_at` (`created_at`)
) ENGINE=MyISAM AUTO_INCREMENT=713 DEFAULT CHARSET=latin1;
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
  `min` int(11) DEFAULT NULL,
  `max` int(11) DEFAULT NULL,
  `to_order` int(11) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` date DEFAULT NULL,
  `updated_at` date DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `default_warranty_sales_id` int(11) DEFAULT NULL,
  `default_warranty_purchases_id` int(11) DEFAULT NULL,
  `cost` decimal(8,2) DEFAULT NULL,
  `default_cost` decimal(8,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2234 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventories`
--

LOCK TABLES `inventories` WRITE;
/*!40000 ALTER TABLE `inventories` DISABLE KEYS */;
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
  `quantity` int(11) DEFAULT '0',
  `price` decimal(8,2) DEFAULT '0.00',
  `received` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `serialized_product_id` int(11) DEFAULT NULL,
  `line_id` int(11) DEFAULT NULL,
  `warranty_price` decimal(8,2) DEFAULT '0.00',
  `warranty_id` int(11) DEFAULT NULL,
  `tax` decimal(8,2) DEFAULT '0.00',
  `previous_qty` int(11) DEFAULT NULL,
  `warranty_months` int(11) DEFAULT NULL,
  `receipt_id` int(11) DEFAULT NULL,
  `note` text,
  `sales_tax` decimal(8,2) DEFAULT '0.00',
  `order_type_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32941 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lines`
--

LOCK TABLES `lines` WRITE;
/*!40000 ALTER TABLE `lines` DISABLE KEYS */;
INSERT INTO `lines` VALUES (32862,3,32874,2,'20.00','2009-12-02 11:56:50','2009-12-02 11:56:50','2009-12-02 13:07:41',NULL,NULL,'0.00',89,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32863,4,32875,10,'0.00',NULL,'2009-12-02 13:14:39','2009-12-02 13:14:39',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32864,4,32876,1,'0.00',NULL,'2009-12-02 14:46:14','2009-12-02 14:46:14',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32865,4,32877,1,'0.00',NULL,'2009-12-02 14:46:41','2009-12-02 14:46:41',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32866,4,32878,1,'0.00',NULL,'2009-12-02 14:48:53','2009-12-02 14:48:53',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32867,4,32879,1,'0.00',NULL,'2009-12-02 15:12:57','2009-12-02 15:12:57',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32868,4,32880,1,'0.00',NULL,'2009-12-02 15:16:25','2009-12-02 15:16:25',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32869,4,32881,1,'0.00',NULL,'2009-12-02 15:16:32','2009-12-02 15:16:32',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32870,5,32882,1,'5.00',NULL,'2009-12-02 15:28:53','2009-12-02 15:28:53',NULL,NULL,'0.00',91,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32871,5,32883,2,'0.00',NULL,'2009-12-02 16:06:01','2009-12-02 16:06:01',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32872,4,32884,2,'0.00',NULL,'2009-12-02 16:06:01','2009-12-02 16:06:01',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32873,5,32885,1,'0.00',NULL,'2009-12-02 16:12:00','2009-12-02 16:12:00',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32874,4,32886,3,'0.00',NULL,'2009-12-02 16:12:12','2009-12-02 16:12:12',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32875,4,32887,0,'0.00',NULL,'2009-12-02 16:14:29','2009-12-02 16:14:29',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32876,4,32888,0,'0.00',NULL,'2009-12-02 16:14:37','2009-12-02 16:14:37',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32877,5,32889,0,'0.00',NULL,'2009-12-02 16:14:45','2009-12-02 16:14:45',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32878,5,32890,1,'0.00',NULL,'2009-12-02 16:16:06','2009-12-02 16:16:06',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32879,5,32891,1,'0.00',NULL,'2009-12-02 16:16:12','2009-12-02 16:16:12',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32880,5,32892,1,'0.00',NULL,'2009-12-02 16:16:17','2009-12-02 16:16:17',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32881,5,32893,0,'0.00','2009-12-02 17:31:42','2009-12-02 16:17:14','2009-12-02 17:31:42',NULL,NULL,'0.00',91,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32882,5,32894,0,'0.00',NULL,'2009-12-02 16:17:20','2009-12-02 16:17:20',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32883,5,32895,1,'0.00',NULL,'2009-12-02 16:18:36','2009-12-02 16:18:36',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32884,5,32896,1,'0.00',NULL,'2009-12-02 16:18:42','2009-12-02 16:18:42',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32885,5,32897,1,'0.00',NULL,'2009-12-02 16:19:18','2009-12-02 16:19:18',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32886,5,32898,3,'0.00',NULL,'2009-12-02 17:04:25','2009-12-02 17:06:36',NULL,NULL,'0.00',91,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32887,5,32899,1,'0.00',NULL,'2009-12-02 17:04:31','2009-12-02 17:04:31',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32888,5,32900,1,'0.00',NULL,'2009-12-02 17:29:19','2009-12-02 17:29:19',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32889,5,32901,1,'0.00',NULL,'2009-12-02 17:31:13','2009-12-02 17:31:13',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32890,6,32904,3,'50.00','2009-12-02 17:47:00','2009-12-02 17:47:00','2009-12-02 17:47:00',NULL,NULL,'0.00',92,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32891,7,32905,3,'50.00','2009-12-02 17:49:42','2009-12-02 17:49:42','2009-12-02 17:49:42',NULL,NULL,'0.00',93,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32892,7,32906,5,'23.00','2009-12-02 17:51:49','2009-12-02 17:51:49','2009-12-02 17:51:49',NULL,NULL,'0.00',93,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32893,8,32906,1,'0.00','2009-12-02 17:52:11','2009-12-02 17:52:11','2009-12-02 17:52:11',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32894,8,32907,1,'0.00','2009-12-02 21:26:56','2009-12-02 21:26:56','2009-12-02 21:26:56',1,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32895,8,32907,1,'0.00','2009-12-02 21:26:56','2009-12-02 21:26:56','2009-12-02 21:26:56',2,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32896,8,32907,1,'0.00','2009-12-02 21:26:56','2009-12-02 21:26:56','2009-12-02 21:26:56',3,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32897,8,32907,1,'0.00','2009-12-02 21:47:30','2009-12-02 21:47:30','2009-12-02 21:47:30',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32898,8,32907,1,'0.00','2009-12-02 21:50:24','2009-12-02 21:50:24','2009-12-02 21:50:24',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32899,8,32907,1,'0.00','2009-12-02 21:53:39','2009-12-02 21:53:39','2009-12-02 21:53:39',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32900,8,32907,1,'0.00','2009-12-02 21:55:28','2009-12-02 21:55:28','2009-12-02 21:55:28',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32901,8,32907,1,'0.00','2009-12-02 21:57:09','2009-12-02 21:57:09','2009-12-02 21:57:09',4,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32902,7,32908,1,'13.00','2009-12-02 23:21:22','2009-12-02 23:21:22','2009-12-02 23:21:22',NULL,NULL,'0.00',93,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32903,7,32909,1,'13.00','2009-12-02 23:21:38','2009-12-02 23:21:38','2009-12-02 23:21:38',NULL,NULL,'0.00',93,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32904,8,32910,1,'23.00','2009-12-02 23:22:01','2009-12-02 23:21:54','2009-12-02 23:22:01',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32905,8,32911,1,'0.00','2009-12-02 23:28:05','2009-12-02 23:28:05','2009-12-02 23:28:05',1,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32908,8,32912,1,'0.00','2009-12-03 00:02:27','2009-12-03 00:02:27','2009-12-03 00:02:27',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32909,8,32913,1,'0.00','2009-12-03 00:05:59','2009-12-03 00:05:59','2009-12-03 00:05:59',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32910,8,32914,1,'0.00','2009-12-03 00:08:34','2009-12-03 00:08:34','2009-12-03 00:08:34',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32911,8,32915,1,'0.00','2009-12-03 00:10:47','2009-12-03 00:10:47','2009-12-03 00:10:47',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32912,8,32916,1,'0.00','2009-12-03 00:12:45','2009-12-03 00:12:46','2009-12-03 00:12:46',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32913,8,32917,1,'0.00','2009-12-03 00:16:36','2009-12-03 00:16:36','2009-12-03 00:16:36',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32914,8,32918,1,'0.00','2009-12-03 00:20:08','2009-12-03 00:19:31','2009-12-03 00:20:08',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32915,8,32919,1,'0.00','2009-12-03 00:23:27','2009-12-03 00:23:27','2009-12-03 00:23:27',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32916,8,32920,1,'0.00','2009-12-03 00:24:43','2009-12-03 00:24:43','2009-12-03 00:24:43',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32917,8,32921,1,'0.00','2009-12-03 00:29:24','2009-12-03 00:29:24','2009-12-03 00:29:24',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32918,8,32922,1,'0.00','2009-12-03 00:31:20','2009-12-03 00:31:20','2009-12-03 00:31:20',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32919,8,32923,1,'0.00','2009-12-03 00:32:34','2009-12-03 00:32:34','2009-12-03 00:32:34',5,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32920,8,32924,1,'0.00','2009-12-03 00:33:06','2009-12-03 00:32:51','2009-12-03 00:33:06',7,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32921,8,32924,1,'0.00','2009-12-03 00:33:06','2009-12-03 00:33:06','2009-12-03 00:33:06',6,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32922,8,32925,1,'5.00','2009-12-03 00:37:15','2009-12-03 00:37:15','2009-12-03 00:37:15',8,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32923,8,32926,1,'0.00',NULL,'2009-12-03 00:47:16','2009-12-03 00:58:20',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32924,8,32927,1,'0.00',NULL,'2009-12-03 00:48:03','2009-12-03 00:48:37',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32925,8,32927,1,'0.00',NULL,'2009-12-03 00:48:16','2009-12-03 00:57:03',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32926,8,32928,1,'0.00','2009-12-03 21:46:49','2009-12-03 21:46:49','2009-12-03 21:46:49',12,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32927,8,32929,1,'0.00',NULL,'2009-12-03 21:47:39','2009-12-03 21:54:43',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32928,8,32931,1,'0.00',NULL,'2009-12-03 21:59:14','2009-12-03 22:11:23',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32929,8,32932,1,'50.00','2009-12-03 22:27:38','2009-12-03 22:27:38','2009-12-03 22:27:38',16,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32930,8,32933,1,'0.00','2009-12-03 22:28:54','2009-12-03 22:28:54','2009-12-03 22:28:54',17,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32931,8,32934,1,'0.00',NULL,'2009-12-03 22:30:35','2009-12-03 22:40:10',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32932,8,32935,1,'0.00',NULL,'2009-12-03 22:41:14','2009-12-03 22:43:12',NULL,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32933,8,32936,1,'0.00','2009-12-03 22:44:18','2009-12-03 22:44:18','2009-12-03 22:44:18',19,NULL,'0.00',NULL,'0.00',10,NULL,NULL,NULL,'0.00',5),(32934,7,32937,4,'0.00','2009-12-04 00:26:29','2009-12-03 23:21:13','2009-12-04 00:26:29',20,NULL,'0.00',93,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32935,7,32938,5,'0.00','2009-12-03 23:28:09','2009-12-03 23:28:09','2009-12-03 23:28:10',NULL,NULL,'0.00',NULL,'0.00',9,NULL,NULL,NULL,'0.00',5),(32936,7,32937,2,'39.20','2009-12-04 00:26:29','2009-12-03 23:44:05','2009-12-04 00:26:30',20,NULL,'0.00',93,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32937,7,32939,4,'39.20','2009-12-04 00:11:17','2009-12-04 00:08:00','2009-12-04 00:11:17',NULL,NULL,'0.00',93,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32938,8,32939,1,'2.00','2009-12-04 00:11:17','2009-12-04 00:08:00','2009-12-04 00:11:17',22,NULL,'0.00',94,'0.00',NULL,NULL,NULL,NULL,'0.00',2),(32939,7,NULL,0,'0.00',NULL,'2009-12-04 00:18:34','2009-12-04 00:18:34',NULL,NULL,'0.00',NULL,'0.00',NULL,NULL,NULL,NULL,'0.00',NULL),(32940,7,32942,1,'45.00','2009-12-04 00:57:06','2009-12-04 00:57:06','2009-12-04 01:18:17',NULL,NULL,'0.00',93,'0.00',NULL,NULL,NULL,NULL,'0.00',2);
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
  `quantity` int(11) DEFAULT NULL,
  `movement_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  `serialized_product_id` int(11) DEFAULT NULL,
  `comments` text,
  `line_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=169 DEFAULT CHARSET=latin1;
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
  `deleted` tinyint(1) DEFAULT '0',
  `grand_total` decimal(8,2) DEFAULT '0.00',
  `amount_paid` decimal(8,2) DEFAULT '0.00',
  `d` tinyint(1) DEFAULT '0',
  `purchase_receipt_number` int(11) DEFAULT NULL,
  `next_order` int(11) DEFAULT NULL,
  `receipt_filename` varchar(255) DEFAULT NULL,
  `receipt_generated` datetime DEFAULT NULL,
  `receipt_number` char(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `created_at` (`created_at`),
  KEY `client_id` (`client_id`),
  KEY `vendor_id` (`vendor_id`),
  KEY `receipt_number` (`receipt_number`),
  KEY `receipt_number_2` (`receipt_number`)
) ENGINE=InnoDB AUTO_INCREMENT=32943 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
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
  `transaction_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5407 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
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
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=604 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prices`
--

LOCK TABLES `prices` WRITE;
/*!40000 ALTER TABLE `prices` DISABLE KEYS */;
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
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
  `quantity` int(11) DEFAULT NULL,
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
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=103 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rights`
--

LOCK TABLES `rights` WRITE;
/*!40000 ALTER TABLE `rights` DISABLE KEYS */;
INSERT INTO `rights` VALUES (1,'Crear Pagos para Ventas'),(2,'Cambiar Pagos para Ventas'),(3,'Ver Pagos para Ventas'),(4,'Borrar Pagos para Ventas'),(5,'Crear Pagos para Compras'),(6,'Cambiar Pagos para Compras'),(7,'Ver Pagos para Compras'),(8,'Borrar Pagos para Compras'),(9,'Crear Ventas'),(10,'Cambiar Ventas'),(11,'Ver Ventas'),(12,'Borrar Ventas'),(13,'Crear Compras'),(14,'Cambiar Compras'),(15,'Ver Compras'),(16,'Borrar Compras'),(17,'Crear Consumidor Final'),(18,'Cambiar Consumidor Final'),(19,'Ver Consumidor Final'),(20,'Borrar Consumidor Final'),(21,'Crear Credito Fiscal'),(22,'Cambiar Credito Fiscal'),(23,'Ver Credito Fiscal'),(24,'Borrar Credito Fiscal'),(25,'Crear Productos'),(26,'Cambiar Productos'),(27,'Ver Productos'),(28,'Borrar Productos'),(29,'Crear Suscripciones'),(30,'Cambiar Suscripciones'),(31,'Ver Suscripciones'),(32,'Borrar Suscripciones'),(33,'Crear Papeles'),(34,'Cambiar Papeles'),(35,'Ver Papeles'),(36,'Borrar Papeles'),(37,'Crear Usuarios'),(38,'Cambiar Usuarios'),(39,'Ver Usuarios'),(40,'Borrar Usuarios'),(41,'Crear Sitios'),(42,'Cambiar Sitios'),(43,'Ver Sitios'),(44,'Borrar Sitios'),(45,'Crear Cuentas Fisicas'),(46,'Cambiar Cuentas Fisicas'),(47,'Ver Cuentas Fisicas'),(48,'Borrar Cuentas Fisicas'),(49,'Ver_COSTS'),(50,'Crear_Cuentas'),(51,'Cambiar_Cuentas'),(52,'Ver_Cuentas'),(53,'Borrar_Cuentas'),(54,'Crear_Servicios'),(55,'Cambiar_Servicios'),(56,'Ver_Servicios'),(57,'Borrar_Servicios'),(58,'Crear_Combos'),(59,'Cambiar_Combos'),(60,'Ver_Combos'),(61,'Borrar_Combos'),(62,'Crear_Descuentos'),(63,'Cambiar_Descuentos'),(64,'Ver_Descuentos'),(65,'Borrar_Descuentos'),(66,'Crear_Garantias'),(67,'Cambiar_Garantias'),(68,'Ver_Garantias'),(69,'Borrar_Garantias'),(70,'Crear_Consumos Internos'),(71,'Cambiar_Consumos Internos'),(72,'Ver_Consumos Internos'),(73,'Borrar_Consumos Internos'),(74,'Crear_Numeros de Serie'),(75,'Cambiar_Numeros de Serie'),(76,'Ver_Numeros de Serie'),(77,'Borrar_Numeros de Serie'),(78,'Cambiar_Prices'),(79,'Crear_Proveedores'),(80,'Cambiar_Proveedores'),(81,'Ver_Proveedores'),(82,'Borrar_Proveedores'),(83,'Crear Transacciones'),(84,'Cambiar Transacciones'),(85,'Ver Transacciones'),(86,'Borrar Transacciones');
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
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=688 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rights_roles`
--

LOCK TABLES `rights_roles` WRITE;
/*!40000 ALTER TABLE `rights_roles` DISABLE KEYS */;
INSERT INTO `rights_roles` VALUES (348,1,1),(349,1,2),(350,1,3),(351,1,11),(352,1,19),(353,1,23),(354,1,43),(355,1,56),(356,1,60),(357,1,64),(358,2,3),(359,2,9),(360,2,10),(361,2,11),(362,2,17),(363,2,18),(364,2,19),(365,2,21),(366,2,22),(367,2,23),(368,2,27),(369,2,43),(370,2,56),(371,2,60),(372,2,64),(373,3,5),(374,3,6),(375,3,7),(376,3,11),(377,3,13),(378,3,14),(379,3,15),(380,3,16),(381,3,25),(382,3,26),(383,3,27),(384,3,43),(385,3,49),(386,3,56),(387,3,60),(388,3,64),(389,4,3),(390,4,7),(391,4,11),(392,4,15),(393,4,43),(394,4,49),(395,4,50),(396,4,51),(397,4,52),(398,4,53),(399,5,11),(400,5,15),(401,5,19),(402,5,23),(403,5,25),(404,5,26),(405,5,27),(406,5,31),(407,5,43),(408,5,45),(409,5,46),(410,5,47),(411,5,48),(412,5,49),(413,5,56),(414,5,58),(415,5,59),(416,5,60),(417,5,64),(418,6,1),(419,6,2),(420,6,3),(421,6,5),(422,6,6),(423,6,7),(424,6,9),(425,6,10),(426,6,11),(427,6,12),(428,6,13),(429,6,14),(430,6,15),(431,6,16),(432,6,17),(433,6,18),(434,6,19),(435,6,21),(436,6,22),(437,6,23),(438,6,25),(439,6,26),(440,6,27),(441,6,29),(442,6,30),(443,6,31),(444,6,32),(445,6,43),(446,6,45),(447,6,46),(448,6,47),(449,6,48),(450,6,49),(451,6,50),(452,6,51),(453,6,52),(454,6,53),(455,6,54),(456,6,55),(457,6,56),(458,6,58),(459,6,59),(460,6,60),(461,6,62),(462,6,63),(463,6,64),(667,7,62),(666,7,61),(665,7,60),(664,7,59),(663,7,58),(662,7,57),(661,7,56),(660,7,55),(659,7,54),(658,7,53),(657,7,52),(656,7,51),(655,7,50),(654,7,49),(653,7,48),(652,7,47),(651,7,46),(650,7,45),(649,7,44),(648,7,43),(647,7,42),(646,7,41),(645,7,40),(644,7,39),(643,7,38),(642,7,37),(641,7,36),(640,7,35),(639,7,34),(638,7,33),(637,7,32),(636,7,31),(635,7,30),(634,7,29),(633,7,28),(632,7,27),(631,7,26),(630,7,25),(629,7,24),(628,7,23),(627,7,22),(626,7,21),(625,7,20),(624,7,19),(623,7,18),(622,7,17),(621,7,16),(620,7,15),(512,8,31),(513,9,29),(514,9,30),(515,9,31),(516,9,32),(517,3,66),(518,3,67),(519,3,68),(520,2,68),(521,5,68),(522,6,68),(619,7,14),(524,6,66),(525,6,67),(618,7,13),(617,7,12),(616,7,11),(530,6,70),(531,6,71),(532,6,72),(533,5,72),(534,2,72),(535,3,72),(536,4,72),(615,7,10),(614,7,9),(613,7,8),(612,7,7),(541,2,76),(542,3,76),(543,5,76),(544,6,76),(611,7,6),(610,7,5),(547,6,78),(548,3,79),(549,3,80),(550,3,81),(551,6,81),(552,6,79),(553,6,80),(609,7,4),(608,7,3),(607,7,2),(606,7,1),(668,7,63),(669,7,64),(670,7,65),(671,7,66),(672,7,67),(673,7,68),(674,7,69),(675,7,70),(676,7,71),(677,7,72),(678,7,73),(679,7,74),(680,7,75),(681,7,76),(682,7,77),(683,7,78),(684,7,79),(685,7,80),(686,7,81),(687,7,82);
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
  PRIMARY KEY (`id`)
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
INSERT INTO `schema_migrations` VALUES ('1'),('10'),('11'),('12'),('13'),('14'),('15'),('16'),('17'),('18'),('2'),('20'),('20081209145242'),('20081209161439'),('21'),('22'),('23'),('24'),('25'),('26'),('27'),('28'),('29'),('3'),('30'),('31'),('32'),('33'),('34'),('35'),('36'),('37'),('38'),('5'),('6'),('7'),('8'),('9');
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
  KEY `serial_number` (`serial_number`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1;
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
  `quantity` int(11) DEFAULT '1',
  `end_date` datetime DEFAULT NULL,
  `end_times` int(11) DEFAULT NULL,
  `fixed_price` decimal(8,2) DEFAULT '0.00',
  `relative_price` decimal(8,2) DEFAULT '0.00',
  `last_line_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `frequency` int(11) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `next_order_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
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
  `tipo` varchar(255) DEFAULT NULL,
  `payment_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2529 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trans`
--

LOCK TABLES `trans` WRITE;
/*!40000 ALTER TABLE `trans` DISABLE KEYS */;
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Sistema Jade','','',NULL,NULL,NULL,5,NULL,1,NULL,NULL,NULL,1,'Sistema Jade',NULL,'2009-07-04'),(2,'jmartin','','71d52dbae5655e57b802caae4f85c24a2b4acb10','b1547f784045f4e8857bfcffb25fbf47f69c67b6',NULL,NULL,5,0,1,NULL,NULL,NULL,1,'Jared Martin',NULL,'2009-12-04');
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
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=98 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `warranties`
--

LOCK TABLES `warranties` WRITE;
/*!40000 ALTER TABLE `warranties` DISABLE KEYS */;
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

-- Dump completed on 2009-12-04  1:22:05
