-- MariaDB dump 10.17  Distrib 10.4.11-MariaDB, for debian-linux-gnu (aarch64)
--
-- Host: localhost    Database: syzoj-ng
-- ------------------------------------------------------
-- Server version	10.4.11-MariaDB-1:10.4.11+maria~bionic-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `group`
--

DROP TABLE IF EXISTS `group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(48) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ownerId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_8a45300fd825918f3b40195fbd` (`name`),
  KEY `FK_af997e6623c9a0e27c241126988` (`ownerId`),
  CONSTRAINT `FK_af997e6623c9a0e27c241126988` FOREIGN KEY (`ownerId`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `group`
--

LOCK TABLES `group` WRITE;
/*!40000 ALTER TABLE `group` DISABLE KEYS */;
/*!40000 ALTER TABLE `group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `group_membership`
--

DROP TABLE IF EXISTS `group_membership`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `group_membership` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `isGroupAdmin` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_9cd83b6cfd264fcd25d6eb4a13` (`userId`,`groupId`),
  KEY `IDX_d59b6ccf0c6407b3fb9b7d321e` (`userId`),
  KEY `IDX_b1411f07fafcd5ad93c6ee1642` (`groupId`),
  KEY `IDX_313baeed7e5245ced8c4722962` (`groupId`,`isGroupAdmin`),
  CONSTRAINT `FK_b1411f07fafcd5ad93c6ee16424` FOREIGN KEY (`groupId`) REFERENCES `group` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_d59b6ccf0c6407b3fb9b7d321ec` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `group_membership`
--

LOCK TABLES `group_membership` WRITE;
/*!40000 ALTER TABLE `group_membership` DISABLE KEYS */;
/*!40000 ALTER TABLE `group_membership` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `localized_content`
--

DROP TABLE IF EXISTS `localized_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `localized_content` (
  `objectId` int(11) NOT NULL,
  `type` enum('PROBLEM_TITLE','PROBLEM_CONTENT') COLLATE utf8mb4_unicode_ci NOT NULL,
  `locale` enum('en_US','zh_CN') COLLATE utf8mb4_unicode_ci NOT NULL,
  `data` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`objectId`,`type`,`locale`),
  KEY `IDX_fb6d767fc806d7937deb39c9fc` (`objectId`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `localized_content`
--

LOCK TABLES `localized_content` WRITE;
/*!40000 ALTER TABLE `localized_content` DISABLE KEYS */;
INSERT INTO `localized_content` VALUES (1,'PROBLEM_TITLE','en_US','Example Problem'),(1,'PROBLEM_TITLE','zh_CN','示例题目'),(1,'PROBLEM_CONTENT','en_US','[{\"sectionTitle\":\"Description\",\"type\":\"TEXT\",\"text\":\"This is a problem to show the OJ\'s features.\\n\\n**We notice that Markdown rendering has NOT been implemented.**\"},{\"sectionTitle\":\"Input\",\"type\":\"TEXT\",\"text\":\"Just like the A + B Problem, two integers $a$ and $b$.\"},{\"sectionTitle\":\"Output\",\"type\":\"TEXT\",\"text\":\"Output the sum of two integers $a+b$.\"},{\"sectionTitle\":\"Sample 1\",\"type\":\"SAMPLE\",\"sampleId\":0,\"text\":\"Obviously, $1+2=3$.\"},{\"sectionTitle\":\"Sample 2\",\"type\":\"SAMPLE\",\"sampleId\":1,\"text\":\"\"},{\"sectionTitle\":\"Limits And Hints\",\"type\":\"TEXT\",\"text\":\"There\'s no testdata since we don\'t support judging yet.\"}]'),(1,'PROBLEM_CONTENT','zh_CN','[{\"sectionTitle\":\"题目描述\",\"type\":\"TEXT\",\"text\":\"这是一道用于演示 OJ 功能的题目。\\n\\n**我们注意到，Markdown 渲染还未被实现。**\"},{\"sectionTitle\":\"输入格式\",\"type\":\"TEXT\",\"text\":\"如同 A + B 问题一样，输入两个整数 $a$ 和 $b$。\"},{\"sectionTitle\":\"输出格式\",\"type\":\"TEXT\",\"text\":\"输出这两个整数的和 $a+b$。\"},{\"sectionTitle\":\"样例 1\",\"type\":\"SAMPLE\",\"sampleId\":0,\"text\":\"很显然，$1+2=3$。\"},{\"sectionTitle\":\"样例 2\",\"type\":\"SAMPLE\",\"sampleId\":1,\"text\":\"\"},{\"sectionTitle\":\"数据范围与提示\",\"type\":\"TEXT\",\"text\":\"没有数据，因为还不支持评测。\"}]');
/*!40000 ALTER TABLE `localized_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permission_for_group`
--

DROP TABLE IF EXISTS `permission_for_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permission_for_group` (
  `objectId` int(11) NOT NULL,
  `objectType` enum('PROBLEM') COLLATE utf8mb4_unicode_ci NOT NULL,
  `groupId` int(11) NOT NULL,
  `permissionType` enum('READ','WRITE') COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`objectId`,`objectType`,`groupId`,`permissionType`),
  KEY `IDX_3c91dfe419af49986b9e4647f8` (`groupId`),
  KEY `IDX_d606b840ba17d10e00a270d269` (`objectId`,`objectType`,`groupId`),
  CONSTRAINT `FK_3c91dfe419af49986b9e4647f89` FOREIGN KEY (`groupId`) REFERENCES `group` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission_for_group`
--

LOCK TABLES `permission_for_group` WRITE;
/*!40000 ALTER TABLE `permission_for_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `permission_for_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permission_for_user`
--

DROP TABLE IF EXISTS `permission_for_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permission_for_user` (
  `objectId` int(11) NOT NULL,
  `objectType` enum('PROBLEM') COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` int(11) NOT NULL,
  `permissionType` enum('READ','WRITE') COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`objectId`,`objectType`,`userId`,`permissionType`),
  KEY `IDX_4793cc20adaac11452e7e34c57` (`userId`),
  KEY `IDX_f17291139d52734936cca4a7b4` (`objectId`,`objectType`,`userId`,`permissionType`),
  CONSTRAINT `FK_4793cc20adaac11452e7e34c579` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission_for_user`
--

LOCK TABLES `permission_for_user` WRITE;
/*!40000 ALTER TABLE `permission_for_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `permission_for_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `problem`
--

DROP TABLE IF EXISTS `problem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `problem` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `displayId` int(11) DEFAULT NULL,
  `type` enum('TRADITIONAL') COLLATE utf8mb4_unicode_ci NOT NULL,
  `isPublic` tinyint(4) NOT NULL,
  `ownerId` int(11) NOT NULL,
  `locales` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_219b1e601b8b47e38de7f91dbe` (`displayId`),
  KEY `FK_c39da795fe62e7a65b7ed5eacba` (`ownerId`),
  CONSTRAINT `FK_c39da795fe62e7a65b7ed5eacba` FOREIGN KEY (`ownerId`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `problem`
--

LOCK TABLES `problem` WRITE;
/*!40000 ALTER TABLE `problem` DISABLE KEYS */;
INSERT INTO `problem` VALUES (1,1,'TRADITIONAL',1,1,'[\"en_US\",\"zh_CN\"]');
/*!40000 ALTER TABLE `problem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `problem_judge_info`
--

DROP TABLE IF EXISTS `problem_judge_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `problem_judge_info` (
  `problemId` int(11) NOT NULL,
  `judgeInfo` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`problemId`),
  UNIQUE KEY `REL_86e8539b96ed22ce70416416b1` (`problemId`),
  CONSTRAINT `FK_86e8539b96ed22ce70416416b1e` FOREIGN KEY (`problemId`) REFERENCES `problem` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `problem_judge_info`
--

LOCK TABLES `problem_judge_info` WRITE;
/*!40000 ALTER TABLE `problem_judge_info` DISABLE KEYS */;
INSERT INTO `problem_judge_info` VALUES (1,'{\"defaultTimeLimit\":1000,\"defaultMemoryLimit\":512,\"runSamples\":true,\"fileIo\":null,\"testdata\":null}');
/*!40000 ALTER TABLE `problem_judge_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `problem_sample`
--

DROP TABLE IF EXISTS `problem_sample`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `problem_sample` (
  `problemId` int(11) NOT NULL,
  `data` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`problemId`),
  UNIQUE KEY `REL_267ae957142251696652533e7d` (`problemId`),
  CONSTRAINT `FK_267ae957142251696652533e7d7` FOREIGN KEY (`problemId`) REFERENCES `problem` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `problem_sample`
--

LOCK TABLES `problem_sample` WRITE;
/*!40000 ALTER TABLE `problem_sample` DISABLE KEYS */;
INSERT INTO `problem_sample` VALUES (1,'[{\"inputData\":\"1 2\",\"outputData\":\"3\"},{\"inputData\":\"233 1\",\"outputData\":\"234\"}]');
/*!40000 ALTER TABLE `problem_sample` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `bio` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `isAdmin` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_78a916df40e02a9deb1c4b75ed` (`username`),
  UNIQUE KEY `IDX_e12875dfb3b1d92d7d7c5377e2` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'Menci','huanghaorui301@gmail.com','',1);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_auth`
--

DROP TABLE IF EXISTS `user_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_auth` (
  `userId` int(11) NOT NULL,
  `password` char(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`userId`),
  UNIQUE KEY `REL_52403f2133a7b1851d8ab4dc9d` (`userId`),
  CONSTRAINT `FK_52403f2133a7b1851d8ab4dc9db` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_auth`
--

LOCK TABLES `user_auth` WRITE;
/*!40000 ALTER TABLE `user_auth` DISABLE KEYS */;
INSERT INTO `user_auth` VALUES (1,'$2b$10$IwLLymKgl1Ot4Ohng2rr6uBoZrmJX0OHZMWdG7efZEu2EdcD0UIoy');
/*!40000 ALTER TABLE `user_auth` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_privilege`
--

DROP TABLE IF EXISTS `user_privilege`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_privilege` (
  `userId` int(11) NOT NULL,
  `privilegeType` enum('MANAGE_USER','MANAGE_USER_GROUP','MANAGE_PROBLEM','MANAGE_CONTEST','MANAGE_DISCUSSION') COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`userId`,`privilegeType`),
  KEY `IDX_62c7a2c2a30224fa1f7d14a160` (`userId`),
  KEY `IDX_b05a610d828909b25309351019` (`privilegeType`),
  CONSTRAINT `FK_62c7a2c2a30224fa1f7d14a160a` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_privilege`
--

LOCK TABLES `user_privilege` WRITE;
/*!40000 ALTER TABLE `user_privilege` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_privilege` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-01-13 12:32:02
