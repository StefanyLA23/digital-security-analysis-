-- MySQL dump 10.13  Distrib 8.4.8, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: mysql
-- ------------------------------------------------------
-- Server version	8.4.8-google

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `db-ciberseguridad`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `db-ciberseguridad` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `db-ciberseguridad`;

--
-- Table structure for table `Accion`
--

DROP TABLE IF EXISTS `Accion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Accion` (
  `ID_Accion` int NOT NULL,
  `Nombre_Accion` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_Accion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Accion`
--

LOCK TABLES `Accion` WRITE;
/*!40000 ALTER TABLE `Accion` DISABLE KEYS */;
INSERT INTO `Accion` VALUES (1,'Delete'),(2,'Failed'),(3,'Inserted'),(4,'Read'),(5,'Success'),(6,'Write'),(7,'USB_Insert');
/*!40000 ALTER TABLE `Accion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Anomalia`
--

DROP TABLE IF EXISTS `Anomalia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Anomalia` (
  `ID_Anomalia` int NOT NULL,
  `Descripcion` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID_Anomalia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Anomalia`
--

LOCK TABLES `Anomalia` WRITE;
/*!40000 ALTER TABLE `Anomalia` DISABLE KEYS */;
INSERT INTO `Anomalia` VALUES (0,'Sin anomalía'),(1,'Intento de acceso fallido'),(2,'Tráfico inusual'),(3,'Data_Exfil'),(4,'USB_Access'),(5,'Network_Traffic'),(6,'Remote_Login');
/*!40000 ALTER TABLE `Anomalia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Clasificacion`
--

DROP TABLE IF EXISTS `Clasificacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Clasificacion` (
  `ID_Clasificacion` int NOT NULL,
  `Etiqueta` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_Clasificacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Clasificacion`
--

LOCK TABLES `Clasificacion` WRITE;
/*!40000 ALTER TABLE `Clasificacion` DISABLE KEYS */;
INSERT INTO `Clasificacion` VALUES (1,'Bajo'),(2,'Medio'),(3,'Alto');
/*!40000 ALTER TABLE `Clasificacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Evento`
--

DROP TABLE IF EXISTS `Evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Evento` (
  `ID_Evento` int NOT NULL,
  `Timestamp` datetime DEFAULT NULL,
  `ID_Usuario` int DEFAULT NULL,
  `ID_TipoActividad` int DEFAULT NULL,
  `ID_Recurso` int DEFAULT NULL,
  `ID_Accion` int DEFAULT NULL,
  `Login_Attempts` decimal(10,2) DEFAULT NULL,
  `File_Size` decimal(10,2) DEFAULT NULL,
  `ID_Anomalia` int DEFAULT NULL,
  `ID_Clasificacion` int DEFAULT NULL,
  PRIMARY KEY (`ID_Evento`),
  KEY `ID_Usuario` (`ID_Usuario`),
  KEY `ID_TipoActividad` (`ID_TipoActividad`),
  KEY `ID_Recurso` (`ID_Recurso`),
  KEY `ID_Accion` (`ID_Accion`),
  KEY `ID_Anomalia` (`ID_Anomalia`),
  KEY `ID_Clasificacion` (`ID_Clasificacion`),
  CONSTRAINT `Evento_ibfk_1` FOREIGN KEY (`ID_Usuario`) REFERENCES `Usuario` (`ID_Usuario`),
  CONSTRAINT `Evento_ibfk_2` FOREIGN KEY (`ID_TipoActividad`) REFERENCES `TipoActividad` (`ID_TipoActividad`),
  CONSTRAINT `Evento_ibfk_3` FOREIGN KEY (`ID_Recurso`) REFERENCES `Recurso` (`ID_Recurso`),
  CONSTRAINT `Evento_ibfk_4` FOREIGN KEY (`ID_Accion`) REFERENCES `Accion` (`ID_Accion`),
  CONSTRAINT `Evento_ibfk_5` FOREIGN KEY (`ID_Anomalia`) REFERENCES `Anomalia` (`ID_Anomalia`),
  CONSTRAINT `Evento_ibfk_6` FOREIGN KEY (`ID_Clasificacion`) REFERENCES `Clasificacion` (`ID_Clasificacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Evento`
--

LOCK TABLES `Evento` WRITE;
/*!40000 ALTER TABLE `Evento` DISABLE KEYS */;
INSERT INTO `Evento` VALUES (1,'2026-06-05 08:15:00',201,1,2,1,1.00,120.00,0,1),(2,'2026-06-05 09:20:00',202,2,4,3,5.00,250.00,1,2),(3,'2026-06-05 10:45:00',203,3,6,2,7.00,180.00,2,3),(4,'2026-06-05 11:30:00',204,1,5,2,4.00,90.00,1,2),(5,'2026-06-05 12:10:00',205,2,3,1,2.00,300.00,0,1),(6,'2026-06-05 13:00:00',206,3,7,3,6.00,210.00,2,3),(7,'2026-06-05 13:45:00',207,1,8,1,8.00,400.00,1,2),(8,'2026-06-05 14:20:00',208,2,9,2,1.00,150.00,0,1),(9,'2026-06-05 15:05:00',209,3,10,1,9.00,500.00,2,3),(10,'2026-06-05 15:50:00',210,1,11,3,3.00,220.00,1,2);
/*!40000 ALTER TABLE `Evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Recurso`
--

DROP TABLE IF EXISTS `Recurso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Recurso` (
  `ID_Recurso` int NOT NULL,
  `Ruta_Recurso` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`ID_Recurso`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Recurso`
--

LOCK TABLES `Recurso` WRITE;
/*!40000 ALTER TABLE `Recurso` DISABLE KEYS */;
INSERT INTO `Recurso` VALUES (1,'/backup/data.csv'),(2,'/backup/document2.docx'),(3,'/backup/new_project.docx'),(4,'/backup/report1.pdf'),(5,'/backup/report2.pdf'),(6,'/backup/secrets.txt'),(7,'/confidential/data.csv'),(8,'/confidential/document2.docx'),(9,'/confidential/new_project.docx'),(10,'/confidential/report1.pdf'),(11,'/confidential/report2.pdf'),(12,'/confidential/secrets.txt'),(13,'/network/logs/data.csv'),(14,'/network/logs/document2.docx'),(15,'/network/logs/new_project.docx'),(16,'/network/logs/report1.pdf'),(17,'/network/logs/report2.pdf'),(18,'/network/logs/secrets.txt'),(19,'/project/data.csv'),(20,'/project/document2.docx'),(21,'/project/new_project.docx'),(22,'/project/report1.pdf'),(23,'/project/report2.pdf'),(24,'/project/secrets.txt'),(25,'/server/data.csv'),(26,'/server/document2.docx'),(27,'/server/new_project.docx'),(28,'/server/report1.pdf'),(29,'/server/report2.pdf'),(30,'/server/secrets.txt'),(31,'/shared/documents/data.csv'),(32,'/shared/documents/document2.docx'),(33,'/shared/documents/new_project.docx'),(34,'/shared/documents/report1.pdf'),(35,'/shared/documents/report2.pdf'),(36,'/shared/documents/secrets.txt');
/*!40000 ALTER TABLE `Recurso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TipoActividad`
--

DROP TABLE IF EXISTS `TipoActividad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TipoActividad` (
  `ID_TipoActividad` int NOT NULL,
  `Nombre_Tipo` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_TipoActividad`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TipoActividad`
--

LOCK TABLES `TipoActividad` WRITE;
/*!40000 ALTER TABLE `TipoActividad` DISABLE KEYS */;
INSERT INTO `TipoActividad` VALUES (1,'File_Access'),(2,'File_Deletion'),(3,'File_Modification'),(4,'Login'),(5,'Network_Traffic'),(6,'Remote_Login'),(7,'USB_Insert');
/*!40000 ALTER TABLE `TipoActividad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Usuario`
--

DROP TABLE IF EXISTS `Usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Usuario` (
  `ID_Usuario` int NOT NULL,
  `User_ID` int DEFAULT NULL,
  `IP_Address` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_Usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Usuario`
--

LOCK TABLES `Usuario` WRITE;
/*!40000 ALTER TABLE `Usuario` DISABLE KEYS */;
INSERT INTO `Usuario` VALUES (1,1000,'192.168.252.36'),(2,1001,'172.19.88.206'),(3,1002,'172.23.61.168'),(4,1003,'172.28.232.9'),(5,1004,'172.22.2.242'),(6,1006,'172.31.86.28'),(7,1007,'10.222.179.45'),(8,1008,'172.19.6.195'),(9,1010,'10.118.92.10'),(10,1011,'172.16.180.101'),(11,1012,'10.183.131.226'),(12,1015,'172.16.249.225'),(13,1018,'10.120.94.0'),(14,1020,'192.168.19.110'),(15,1022,'192.168.52.118'),(16,1023,'192.168.153.106'),(17,1024,'172.16.229.228'),(18,1025,'10.137.44.132'),(19,1029,'192.168.58.93'),(20,1036,'172.18.70.213'),(21,1037,'10.198.116.172'),(22,1038,'192.168.2.250'),(23,1042,'10.98.185.41'),(24,1044,'192.168.26.206'),(25,1045,'10.55.43.50'),(26,1046,'192.168.168.139'),(27,1047,'172.17.95.57'),(28,1049,'172.25.162.160'),(29,1052,'172.16.22.11'),(30,1054,'192.168.102.22'),(31,1060,'172.21.113.189'),(32,1061,'172.22.42.87'),(33,1062,'172.29.159.213'),(34,1065,'172.24.203.183'),(35,1066,'192.168.65.151'),(36,1067,'192.168.185.139'),(201,1001,'192.168.1.1'),(202,1002,'192.168.1.2'),(203,1003,'192.168.1.3'),(204,1004,'192.168.1.4'),(205,1005,'192.168.1.5'),(206,1006,'192.168.1.6'),(207,1007,'192.168.1.7'),(208,1008,'192.168.1.8'),(209,1009,'192.168.1.9'),(210,1010,'192.168.1.10');
/*!40000 ALTER TABLE `Usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_eventos`
--

DROP TABLE IF EXISTS `vw_eventos`;
/*!50001 DROP VIEW IF EXISTS `vw_eventos`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_eventos` AS SELECT 
 1 AS `ID_Evento`,
 1 AS `Timestamp`,
 1 AS `User_ID`,
 1 AS `IP_Address`,
 1 AS `Tipo_Actividad`,
 1 AS `Ruta_Recurso`,
 1 AS `Nombre_Accion`,
 1 AS `Anomalia`,
 1 AS `Clasificacion`,
 1 AS `Login_Attempts`,
 1 AS `File_Size`*/;
SET character_set_client = @saved_cs_client;

--
-- Current Database: `db-ciberseguridad`
--

USE `db-ciberseguridad`;

--
-- Final view structure for view `vw_eventos`
--

/*!50001 DROP VIEW IF EXISTS `vw_eventos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`ciberseguridad-db`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_eventos` AS select `e`.`ID_Evento` AS `ID_Evento`,`e`.`Timestamp` AS `Timestamp`,`u`.`User_ID` AS `User_ID`,`u`.`IP_Address` AS `IP_Address`,`ta`.`Nombre_Tipo` AS `Tipo_Actividad`,`r`.`Ruta_Recurso` AS `Ruta_Recurso`,`a`.`Nombre_Accion` AS `Nombre_Accion`,`an`.`Descripcion` AS `Anomalia`,`c`.`Etiqueta` AS `Clasificacion`,`e`.`Login_Attempts` AS `Login_Attempts`,`e`.`File_Size` AS `File_Size` from ((((((`Evento` `e` left join `Usuario` `u` on((`e`.`ID_Usuario` = `u`.`ID_Usuario`))) left join `TipoActividad` `ta` on((`e`.`ID_TipoActividad` = `ta`.`ID_TipoActividad`))) left join `Recurso` `r` on((`e`.`ID_Recurso` = `r`.`ID_Recurso`))) left join `Accion` `a` on((`e`.`ID_Accion` = `a`.`ID_Accion`))) left join `Anomalia` `an` on((`e`.`ID_Anomalia` = `an`.`ID_Anomalia`))) left join `Clasificacion` `c` on((`e`.`ID_Clasificacion` = `c`.`ID_Clasificacion`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-05 22:58:18
