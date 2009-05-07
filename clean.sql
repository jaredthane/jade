-- MySQL dump 10.11
--
-- Host: localhost    Database: Jade
-- ------------------------------------------------------
-- Server version	5.0.67-0ubuntu6

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
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `accounts` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `parent_id` int(11) default NULL,
  `entity_id` int(11) default NULL,
  `postable` tinyint(1) default NULL,
  `number` varchar(20) default NULL,
  `transparent_journal` tinyint(1) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` VALUES (2,'Activos',NULL,NULL,NULL,'1',NULL),(3,'Pasivos',NULL,NULL,NULL,'2',NULL),(4,'Patrimonio',NULL,NULL,NULL,'3',NULL),(5,'Ingresos',NULL,NULL,NULL,'4',NULL),(6,'Gastos',NULL,NULL,1,'5',NULL),(7,'Efectivo',2,NULL,1,'11',NULL),(8,'Inventario',2,NULL,1,'12',NULL),(9,'Cuenta Bancaria',2,NULL,1,'13',NULL),(10,'Cuentas a Cobrar',2,NULL,1,'14',NULL),(17,'Cuentas por Pagar',3,NULL,1,'21',NULL),(18,'Impuesto',3,NULL,1,'22',NULL);
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entities`
--

DROP TABLE IF EXISTS `entities`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `entities` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `entity_type_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `home_phone` char(8) default '',
  `office_phone` char(8) default '',
  `address` text,
  `birth` datetime default NULL,
  `state_id` int(11) default NULL,
  `cell_phone` char(8) default NULL,
  `nit` char(14) default NULL,
  `city` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `register` varchar(255) default NULL,
  `giro` varchar(255) default NULL,
  `price_group_id` int(11) default NULL,
  `price_group_name_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `product_id` int(11) default NULL,
  `site_id` int(11) default NULL,
  `inventory_account_id` int(11) default NULL,
  `cash_account_id` int(11) default NULL,
  `revenue_account_id` int(11) default NULL,
  `expense_account_id` int(11) default NULL,
  `returns_account_id` int(11) default NULL,
  `tax_account_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `entities`
--

LOCK TABLES `entities` WRITE;
/*!40000 ALTER TABLE `entities` DISABLE KEYS */;
INSERT INTO `entities` VALUES (1,'Consumo Interno',NULL,NULL,NULL,'','',NULL,NULL,12,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(2,'Varios',1,NULL,'2009-05-06 20:30:06','','','',NULL,12,'',NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,17,NULL,NULL,NULL,NULL),(3,'Anonimo',2,NULL,'2009-05-06 20:30:41','','','','2009-05-06 00:00:00',12,'','','','','','',NULL,1,1,NULL,5,NULL,10,NULL,NULL,NULL,NULL),(4,'No Specificado',1,NULL,'2009-05-06 20:29:44','','','',NULL,12,'',NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,17,NULL,NULL,NULL,NULL),(5,'Principal',3,NULL,'2009-05-06 20:28:57','','',NULL,NULL,12,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,8,7,5,6,NULL,18);
/*!40000 ALTER TABLE `entities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entity_types`
--

DROP TABLE IF EXISTS `entity_types`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `entity_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `entity_types`
--

LOCK TABLES `entity_types` WRITE;
/*!40000 ALTER TABLE `entity_types` DISABLE KEYS */;
INSERT INTO `entity_types` VALUES (1,'Proveedor'),(2,'Consumidor Final'),(3,'Sitio'),(5,'Credito Fiscal'),(6,'Empleado'),(7,'Cuenta Bancaria');
/*!40000 ALTER TABLE `entity_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventories`
--

DROP TABLE IF EXISTS `inventories`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `inventories` (
  `product_id` int(11) default NULL,
  `entity_id` int(11) default NULL,
  `min` int(11) default NULL,
  `max` int(11) default NULL,
  `to_order` int(11) default NULL,
  `id` int(11) NOT NULL auto_increment,
  `created_at` date default NULL,
  `updated_at` date default NULL,
  `quantity` int(11) default NULL,
  `default_warranty_sales_id` int(11) default NULL,
  `default_warranty_purchases_id` int(11) default NULL,
  `cost` decimal(8,2) default NULL,
  `default_cost` decimal(8,2) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2096 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `inventories`
--

LOCK TABLES `inventories` WRITE;
/*!40000 ALTER TABLE `inventories` DISABLE KEYS */;
INSERT INTO `inventories` VALUES (NULL,5,0,0,0,2086,'2009-05-01','2009-05-01',0,NULL,NULL,NULL,NULL),(3,5,NULL,NULL,0,2087,'2009-05-01','2009-05-01',0,NULL,NULL,'0.00','0.00'),(NULL,5,0,0,0,2088,'2009-05-01','2009-05-01',0,NULL,NULL,NULL,NULL),(4,5,NULL,NULL,0,2089,'2009-05-01','2009-05-01',0,NULL,NULL,'0.00','0.00');
/*!40000 ALTER TABLE `inventories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lines`
--

DROP TABLE IF EXISTS `lines`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `lines` (
  `id` int(11) NOT NULL auto_increment,
  `product_id` int(11) default NULL,
  `order_id` int(11) default NULL,
  `quantity` int(11) default NULL,
  `price` decimal(8,2) default NULL,
  `received` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `serialized_product_id` int(11) default NULL,
  `line_id` int(11) default NULL,
  `warranty_price` decimal(8,2) default NULL,
  `warranty_id` int(11) default NULL,
  `tax` decimal(8,2) default NULL,
  `previous_qty` int(11) default NULL,
  `warranty_months` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `lines`
--

LOCK TABLES `lines` WRITE;
/*!40000 ALTER TABLE `lines` DISABLE KEYS */;
INSERT INTO `lines` VALUES (1,3,1,1,'1.00',NULL,'2009-05-01 20:16:37','2009-05-01 20:16:37',NULL,NULL,'0.00',69,'0.15',NULL,NULL),(3,3,3,10,'3.00','2009-05-05 23:53:40','2009-05-05 23:53:40','2009-05-05 23:53:40',NULL,NULL,'0.00',69,'4.50',NULL,NULL),(4,3,5,10,'3.00','2009-05-06 08:38:53','2009-05-06 08:38:53','2009-05-06 08:38:53',NULL,NULL,'0.00',69,'4.50',NULL,NULL),(5,3,6,10,'0.00','2009-05-06 08:42:30','2009-05-06 08:42:30','2009-05-06 08:42:30',NULL,NULL,'0.00',69,'0.00',NULL,NULL),(6,3,7,10,'5.00','2009-05-06 08:57:12','2009-05-06 08:57:12','2009-05-06 08:58:05',NULL,NULL,'0.00',69,'7.50',NULL,NULL),(8,3,11,10,'5.00','2009-05-06 09:10:29','2009-05-06 09:10:29','2009-05-06 09:10:29',NULL,NULL,'0.00',69,'7.50',NULL,NULL),(9,3,12,10,'0.00','2009-05-06 09:11:37','2009-05-06 09:11:37','2009-05-06 09:11:37',NULL,NULL,'0.00',69,'0.00',NULL,NULL),(10,3,15,10,'0.00','2009-05-06 09:30:19','2009-05-06 09:30:19','2009-05-06 09:30:19',NULL,NULL,'0.00',69,'0.00',NULL,NULL),(11,3,17,10,'0.00','2009-05-06 09:31:06','2009-05-06 09:31:06','2009-05-06 09:31:06',NULL,NULL,'0.00',69,'0.00',NULL,NULL),(12,3,23,10,'0.00','2009-05-06 09:41:26','2009-05-06 09:41:26','2009-05-06 09:41:26',NULL,NULL,'0.00',69,'0.00',NULL,NULL),(13,3,24,10,'0.00','2009-05-06 09:43:07','2009-05-06 09:43:07','2009-05-06 09:43:07',NULL,NULL,'0.00',69,'0.00',NULL,NULL),(15,3,27,10,'0.00','2009-05-06 09:55:18','2009-05-06 09:55:18','2009-05-06 09:55:18',NULL,NULL,'0.00',69,'0.00',NULL,NULL),(16,3,28,10,'0.00','2009-05-06 09:58:49','2009-05-06 09:58:50','2009-05-06 09:58:50',NULL,NULL,'0.00',69,'0.00',NULL,NULL),(18,3,30,10,'3.00','2009-05-06 10:10:55','2009-05-06 10:10:55','2009-05-06 10:10:55',NULL,NULL,'0.00',69,'4.50',NULL,NULL),(19,3,31,1,'5.00','2009-05-06 10:29:31','2009-05-06 10:29:31','2009-05-06 10:29:31',NULL,NULL,'0.00',69,'0.75',NULL,NULL),(20,3,32,1,'0.00','2009-05-06 11:19:50','2009-05-06 11:19:50','2009-05-06 11:19:50',NULL,NULL,'0.00',69,'0.00',NULL,NULL),(21,3,33,1,'0.00','2009-05-06 11:36:06','2009-05-06 11:36:06','2009-05-06 11:36:06',NULL,NULL,'0.00',69,'0.00',NULL,NULL),(22,3,34,1,'50.00','2009-05-06 12:06:01','2009-05-06 12:06:01','2009-05-06 12:06:01',NULL,NULL,'0.00',69,'7.50',NULL,NULL),(23,3,35,1,'30.00','2009-05-06 12:11:57','2009-05-06 12:11:57','2009-05-06 12:11:57',NULL,NULL,'0.00',69,'4.50',NULL,NULL),(24,3,36,1,'77.00','2009-05-06 12:14:08','2009-05-06 12:14:09','2009-05-06 12:14:09',NULL,NULL,'0.00',69,'11.55',NULL,NULL),(25,3,37,1,'0.04','2009-05-06 12:15:23','2009-05-06 12:15:23','2009-05-06 12:15:23',NULL,NULL,'0.00',69,'0.01',NULL,NULL),(26,3,38,1,'66.00','2009-05-06 12:16:27','2009-05-06 12:16:28','2009-05-06 12:16:28',NULL,NULL,'0.00',69,'9.90',NULL,NULL),(27,3,39,1,'46.00','2009-05-06 12:18:18','2009-05-06 12:18:18','2009-05-06 12:18:18',NULL,NULL,'0.00',69,'6.90',NULL,NULL),(30,3,42,1,'665.00','2009-05-06 12:34:51','2009-05-06 12:34:51','2009-05-06 12:34:51',NULL,NULL,'0.00',69,'99.75',NULL,NULL),(31,3,43,1,'2.00','2009-05-06 12:39:54','2009-05-06 12:39:54','2009-05-06 12:39:54',NULL,NULL,'0.00',69,'0.30',NULL,NULL),(32,3,44,1,'0.00','2009-05-06 12:51:28','2009-05-06 12:51:28','2009-05-06 12:51:28',NULL,NULL,'0.00',69,'0.00',NULL,NULL),(33,3,45,1,'0.00','2009-05-06 13:26:07','2009-05-06 13:26:07','2009-05-06 13:26:07',NULL,NULL,'0.00',69,'0.00',NULL,NULL),(34,3,46,1,'0.00','2009-05-06 13:29:51','2009-05-06 13:29:51','2009-05-06 13:29:51',NULL,NULL,'0.00',69,'0.00',NULL,NULL),(35,3,47,1,'0.00','2009-05-06 13:31:31','2009-05-06 13:31:31','2009-05-06 13:31:31',NULL,NULL,'0.00',69,'0.00',NULL,NULL),(36,3,48,1,'23.00','2009-05-06 13:33:12','2009-05-06 13:33:12','2009-05-06 13:33:12',NULL,NULL,'0.00',69,'3.45',NULL,NULL),(37,3,49,1,'0.00','2009-05-06 13:41:22','2009-05-06 13:41:22','2009-05-06 13:41:22',NULL,NULL,'0.00',69,'0.00',NULL,NULL),(39,3,51,1,'0.00','2009-05-06 13:53:23','2009-05-06 13:53:23','2009-05-06 13:53:23',NULL,NULL,'0.00',69,'0.00',NULL,NULL),(40,3,52,1,'5.00','2009-05-06 14:01:29','2009-05-06 14:01:29','2009-05-06 14:01:29',NULL,NULL,'0.00',69,'0.75',NULL,NULL),(41,3,53,1,'5.00','2009-05-06 14:09:25','2009-05-06 14:09:25','2009-05-06 14:09:25',NULL,NULL,'0.00',69,'0.75',NULL,NULL),(42,3,54,1,'5.00','2009-05-06 14:10:47','2009-05-06 14:10:47','2009-05-06 14:10:47',NULL,NULL,'0.00',69,'0.75',NULL,NULL),(43,3,55,1,'5.00','2009-05-06 14:12:15','2009-05-06 14:12:15','2009-05-06 14:12:15',NULL,NULL,'0.00',69,'0.75',NULL,NULL),(44,3,56,1,'5.00','2009-05-06 14:20:41','2009-05-06 14:20:42','2009-05-06 14:20:42',NULL,NULL,'0.00',69,'0.75',NULL,NULL),(45,3,57,1,'5.00','2009-05-06 14:43:09','2009-05-06 14:43:09','2009-05-06 14:43:09',NULL,NULL,'0.00',69,'0.75',NULL,NULL),(46,3,58,1,'5.00','2009-05-06 16:55:30','2009-05-06 16:55:31','2009-05-06 16:55:31',NULL,NULL,'0.00',69,'0.75',NULL,NULL),(47,3,59,1,'5.00','2009-05-06 17:00:45','2009-05-06 17:00:45','2009-05-06 17:00:45',NULL,NULL,'0.00',69,'0.75',NULL,NULL),(48,3,60,1,'36.00','2009-05-06 18:15:59','2009-05-06 18:15:59','2009-05-06 18:15:59',NULL,NULL,'0.00',69,'5.40',NULL,NULL),(49,3,61,2,'40.00','2009-05-06 18:38:51','2009-05-06 18:38:51','2009-05-06 18:38:51',NULL,NULL,'0.00',69,'12.00',NULL,NULL),(50,3,62,1,'5.00','2009-05-06 19:14:48','2009-05-06 19:14:48','2009-05-06 19:14:48',NULL,NULL,'0.00',69,'0.75',NULL,NULL),(51,3,63,1,'5.00','2009-05-06 19:26:18','2009-05-06 19:26:18','2009-05-06 19:26:18',NULL,NULL,'0.00',69,'0.75',NULL,NULL),(52,3,64,1,'7.00','2009-05-06 19:29:07','2009-05-06 19:29:08','2009-05-06 19:29:08',NULL,NULL,'0.00',69,'1.05',NULL,NULL),(53,3,65,1,'8.00','2009-05-06 19:33:04','2009-05-06 19:33:04','2009-05-06 19:33:04',NULL,NULL,'0.00',69,'1.20',NULL,NULL),(54,3,66,1,'1.00','2009-05-06 19:37:33','2009-05-06 19:37:33','2009-05-06 19:37:33',NULL,NULL,'0.00',69,'0.15',NULL,NULL),(55,3,67,1,'5.00','2009-05-06 19:39:08','2009-05-06 19:39:08','2009-05-06 19:39:08',NULL,NULL,'0.00',69,'0.75',NULL,NULL),(56,3,68,1,'5.00','2009-05-06 20:00:25','2009-05-06 20:00:25','2009-05-06 20:00:25',NULL,NULL,'0.00',69,'0.75',NULL,NULL);
/*!40000 ALTER TABLE `lines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movement_types`
--

DROP TABLE IF EXISTS `movement_types`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `movement_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `movement_types`
--

LOCK TABLES `movement_types` WRITE;
/*!40000 ALTER TABLE `movement_types` DISABLE KEYS */;
INSERT INTO `movement_types` VALUES (1,'Venta'),(2,'Compra'),(3,'Transferencia'),(4,'Cuenta Fisica'),(5,'Devolucion de Venta'),(6,'Devolucion de Compra'),(7,'Devolucion de Transferencia'),(8,'Consumo Interno'),(9,'Devolucion de Consumo Interno'),(10,'Pago'),(11,'Deposito'),(12,'Retiro');
/*!40000 ALTER TABLE `movement_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movements`
--

DROP TABLE IF EXISTS `movements`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `movements` (
  `id` int(11) NOT NULL auto_increment,
  `entity_id` int(11) default NULL,
  `product_id` int(11) default NULL,
  `quantity` int(11) default NULL,
  `movement_type_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `order_id` int(11) default NULL,
  `serialized_product_id` int(11) default NULL,
  `oldline_id` int(11) default NULL,
  `comments` text,
  `value` decimal(8,2) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

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
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `order_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `order_types`
--

LOCK TABLES `order_types` WRITE;
/*!40000 ALTER TABLE `order_types` DISABLE KEYS */;
INSERT INTO `order_types` VALUES (1,'Venta'),(2,'Compra'),(3,'Consumo Interno'),(4,'Transferencia'),(5,'Cuenta Fisica'),(6,'Abono a cuenta'),(7,'Transferencia de Fondos');
/*!40000 ALTER TABLE `order_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `orders` (
  `id` int(11) NOT NULL auto_increment,
  `vendor_id` int(11) default NULL,
  `client_id` int(11) default NULL,
  `received` date default NULL,
  `ordered` date default NULL,
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `serialized_product_id` int(11) default NULL,
  `last_batch` tinyint(1) default NULL,
  `receipt_printed` datetime default NULL,
  `receipt_number` int(11) default NULL,
  `comments` text,
  `order_type_id` int(11) default NULL,
  `deleted` tinyint(1) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

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
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `payment_methods` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

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
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `payments` (
  `id` int(11) NOT NULL auto_increment,
  `order_id` int(11) default NULL,
  `amount` decimal(8,2) default NULL,
  `date` date default NULL,
  `payment_method_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `returned` decimal(8,2) default NULL,
  `receipt_id` int(11) default NULL,
  `presented` decimal(8,2) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `people`
--

DROP TABLE IF EXISTS `people`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `people` (
  `id` int(11) NOT NULL auto_increment,
  `home_phone` char(8) default '',
  `office_phone` char(8) default '',
  `address` text,
  `birth` datetime default NULL,
  `state_id` int(11) default NULL,
  `cell_phone` char(8) default NULL,
  `nit` char(14) default NULL,
  `city` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `register` varchar(255) default NULL,
  `giro` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `people`
--

LOCK TABLES `people` WRITE;
/*!40000 ALTER TABLE `people` DISABLE KEYS */;
INSERT INTO `people` VALUES (1,'','',NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),(2,'','',NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),(3,'','',NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),(4,'','',NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),(5,'','',NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),(6,'','',NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),(7,'','',NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL),(8,'24080080','','','2009-05-05 00:00:00',1,'','123456789845','','','','asdf');
/*!40000 ALTER TABLE `people` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_types`
--

DROP TABLE IF EXISTS `post_types`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `post_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `post_types`
--

LOCK TABLES `post_types` WRITE;
/*!40000 ALTER TABLE `post_types` DISABLE KEYS */;
INSERT INTO `post_types` VALUES (1,'Debito'),(2,'Credito');
/*!40000 ALTER TABLE `post_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `posts` (
  `id` int(11) NOT NULL auto_increment,
  `post_type_id` int(11) default NULL,
  `value` decimal(8,2) default NULL,
  `account_id` int(11) default NULL,
  `trans_id` int(11) default NULL,
  `balance` decimal(8,2) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=113 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `price_group_names`
--

DROP TABLE IF EXISTS `price_group_names`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `price_group_names` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

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
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `price_groups` (
  `id` int(11) NOT NULL auto_increment,
  `price_group_name_id` int(11) default NULL,
  `entity_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `price_groups`
--

LOCK TABLES `price_groups` WRITE;
/*!40000 ALTER TABLE `price_groups` DISABLE KEYS */;
INSERT INTO `price_groups` VALUES (1,1,5),(2,2,5),(5,1,7),(6,2,7);
/*!40000 ALTER TABLE `price_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prices`
--

DROP TABLE IF EXISTS `prices`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `prices` (
  `id` int(11) NOT NULL auto_increment,
  `price_group_id` int(11) default NULL,
  `product_id` int(11) default NULL,
  `fixed` decimal(8,2) default NULL,
  `relative` decimal(8,2) default NULL,
  `available` tinyint(1) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=208 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `prices`
--

LOCK TABLES `prices` WRITE;
/*!40000 ALTER TABLE `prices` DISABLE KEYS */;
INSERT INTO `prices` VALUES (1,1,1,'1.00',NULL,1),(2,2,1,'1.00',NULL,1),(3,1,2,'1.00',NULL,1),(4,2,2,'1.00',NULL,1),(200,1,3,'5.00',NULL,0),(201,2,3,'5.00',NULL,0),(202,5,3,'5.00',NULL,1),(203,6,3,'5.00',NULL,1),(204,1,4,'77.00',NULL,NULL),(205,2,4,'77.00',NULL,NULL),(206,5,4,'77.00',NULL,NULL),(207,6,4,'77.00',NULL,NULL);
/*!40000 ALTER TABLE `prices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_categories`
--

DROP TABLE IF EXISTS `product_categories`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `product_categories` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

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
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `product_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

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
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `products` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `description` text,
  `vendor_id` int(11) default NULL,
  `oldcost` decimal(8,2) default NULL,
  `upc` varchar(255) default NULL,
  `unit_id` int(11) default NULL,
  `location` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `model` varchar(255) default NULL,
  `serialized` tinyint(1) default NULL,
  `serialized_product_id` int(11) default NULL,
  `product_type_id` int(11) default NULL,
  `product_category_id` int(11) default NULL,
  `blocked_by_count` int(1) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'Abono a cuenta','',NULL,NULL,'!Abono a cuenta',4,'','2009-05-01 20:11:49','2009-05-01 20:11:49','',0,NULL,1,NULL,0),(2,'Transferencia de Fondos','',NULL,NULL,'!Transferencia de Fondos',4,'','2009-05-01 20:13:31','2009-05-01 20:13:31','',0,NULL,1,NULL,0);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `receipts`
--

DROP TABLE IF EXISTS `receipts`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `receipts` (
  `id` int(11) NOT NULL auto_increment,
  `order_id` int(11) default NULL,
  `filename` varchar(255) default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `receipts`
--

LOCK TABLES `receipts` WRITE;
/*!40000 ALTER TABLE `receipts` DISABLE KEYS */;
/*!40000 ALTER TABLE `receipts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requirements`
--

DROP TABLE IF EXISTS `requirements`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `requirements` (
  `id` int(11) NOT NULL auto_increment,
  `product_id` int(11) default NULL,
  `required_id` int(11) default NULL,
  `quantity` int(11) default NULL,
  `static_price` decimal(8,2) default NULL,
  `relative_price` decimal(8,2) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=66 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `requirements`
--

LOCK TABLES `requirements` WRITE;
/*!40000 ALTER TABLE `requirements` DISABLE KEYS */;
INSERT INTO `requirements` VALUES (64,4,3,1,'0.00',NULL),(65,4,3,1,'0.00',NULL);
/*!40000 ALTER TABLE `requirements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'ventas'),(2,'admin'),(3,'compras'),(4,'inventario'),(5,'Contabilidad');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles_users`
--

DROP TABLE IF EXISTS `roles_users`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `roles_users` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `role_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `roles_users`
--

LOCK TABLES `roles_users` WRITE;
/*!40000 ALTER TABLE `roles_users` DISABLE KEYS */;
INSERT INTO `roles_users` VALUES (1,1,2);
/*!40000 ALTER TABLE `roles_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_info`
--

DROP TABLE IF EXISTS `schema_info`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

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
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

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
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `serialized_products` (
  `id` int(11) NOT NULL auto_increment,
  `serial_number` varchar(255) default NULL,
  `product_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `serialized_products`
--

LOCK TABLES `serialized_products` WRITE;
/*!40000 ALTER TABLE `serialized_products` DISABLE KEYS */;
INSERT INTO `serialized_products` VALUES (1,'1',432),(2,'2',432),(3,'3',432),(4,'4',432),(5,'5',432),(6,'6',432),(7,'7',432),(8,'123566',432),(9,'876888',432),(10,'9595959',432),(11,'14444',432),(12,'958874734',432),(13,'99999',432),(14,'41414',432),(15,'15151515',432),(16,'515151111',432),(17,'666',432),(18,'77',432),(19,'0',432),(20,'1414414141',432),(21,'13133333',432),(22,'1313133',432),(23,'2626',432),(24,'51555',432),(25,'1315666',432),(26,'131333',432),(27,'45678',432),(28,'561614',432),(29,'13145455',432),(30,'1415144',432),(31,'18236',432),(32,'2147483647',432),(33,'1234876243',432),(34,'123498273',432),(35,'912832764',432),(36,'2147483647',432),(37,'2147483647',432),(38,'2147483647',432),(39,'2147483647',432),(40,'2147483647',432),(41,'327346374',432),(42,'88765432',432),(43,'2147483647',432),(44,'2147483647',432),(45,'111',434),(46,'222',434),(47,'333',434),(48,'444',434),(49,'54545',436),(50,'43434',436),(51,'32323',436),(52,'11111',436),(53,'22222',436),(54,'33333',436),(55,'555',434),(56,'777',434),(57,'bird2',434),(58,'212',434),(59,'313',434),(60,'414',434),(61,'515',434),(62,'616',434),(63,'717',434),(64,'919',434),(65,'818',434),(66,'birasd',434),(67,'71353623',468),(68,'128734649837',468),(69,'1u736t27362736',468);
/*!40000 ALTER TABLE `serialized_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `states`
--

DROP TABLE IF EXISTS `states`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `states` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1000 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

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
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `subscriptions` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `client_id` int(11) default NULL,
  `vendor_id` int(11) default NULL,
  `quantity` int(11) default NULL,
  `end_date` datetime default NULL,
  `end_times` int(11) default NULL,
  `fixed_price` decimal(8,2) default NULL,
  `relative_price` decimal(8,2) default NULL,
  `last_run` datetime default NULL,
  `product_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

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
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `trans` (
  `id` int(11) NOT NULL auto_increment,
  `order_id` int(11) default NULL,
  `comments` text,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=40 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

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
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `units` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (1,'Cada Uno'),(2,'Hora'),(3,'Caja'),(4,'Dolares');
/*!40000 ALTER TABLE `units` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_privileges`
--

DROP TABLE IF EXISTS `user_privileges`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `user_privileges` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `privilege_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `user_privileges`
--

LOCK TABLES `user_privileges` WRITE;
/*!40000 ALTER TABLE `user_privileges` DISABLE KEYS */;
INSERT INTO `user_privileges` VALUES (1,1,1,NULL,NULL),(2,6,1,NULL,NULL),(3,6,3,NULL,NULL),(4,6,2,NULL,NULL),(5,6,4,NULL,NULL);
/*!40000 ALTER TABLE `user_privileges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `crypted_password` varchar(40) default NULL,
  `salt` varchar(40) default NULL,
  `remember_token` varchar(255) default NULL,
  `remember_token_expires_at` datetime default NULL,
  `location_id` int(11) default NULL,
  `default_received` tinyint(1) default NULL,
  `price_group_name_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','null@null.null','efac2d903cd08baa3ffb48c853e0eff587e39b5d','b41e5fb0c70973c725b3d47dd8bfb99780da3a0b',NULL,NULL,5,1,1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `warranties`
--

DROP TABLE IF EXISTS `warranties`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `warranties` (
  `id` int(11) NOT NULL auto_increment,
  `product_id` int(11) default NULL,
  `price` decimal(8,2) default NULL,
  `month_id` int(11) default NULL,
  `order_type_id` int(11) default NULL,
  `months` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=74 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `warranties`
--

LOCK TABLES `warranties` WRITE;
/*!40000 ALTER TABLE `warranties` DISABLE KEYS */;
INSERT INTO `warranties` VALUES (68,NULL,'0.00',NULL,NULL,0),(69,3,'0.00',NULL,NULL,0),(70,NULL,'0.00',NULL,NULL,0),(71,4,'0.00',NULL,NULL,0),(72,3,'0.00',NULL,NULL,0),(73,NULL,'0.00',NULL,NULL,0);
/*!40000 ALTER TABLE `warranties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `warranty_months`
--

DROP TABLE IF EXISTS `warranty_months`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `warranty_months` (
  `id` int(11) NOT NULL auto_increment,
  `months` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

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

-- Dump completed on 2009-05-07  2:31:56
