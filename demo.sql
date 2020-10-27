-- MariaDB dump 10.17  Distrib 10.5.5-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: syzoj-ng-demo
-- ------------------------------------------------------
-- Server version	10.5.5-MariaDB

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
-- Table structure for table `discussion`
--

DROP TABLE IF EXISTS `discussion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `discussion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `publishTime` datetime NOT NULL,
  `editTime` datetime DEFAULT NULL,
  `sortTime` datetime NOT NULL,
  `replyCount` int(11) NOT NULL,
  `isPublic` tinyint(4) NOT NULL,
  `publisherId` int(11) NOT NULL,
  `problemId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_e711f80f3386503affe1751be5` (`publishTime`),
  KEY `IDX_aa665dd76652a2690783aed7c9` (`editTime`),
  KEY `IDX_4fcd056e39725d3fc69b8ce4a8` (`sortTime`),
  KEY `IDX_19ea47f9bd6169814dc3375c0c` (`replyCount`),
  KEY `IDX_906f4cf6e6f6496abd8797a196` (`isPublic`),
  KEY `IDX_31f21d648dc4bfd9ffd2d074fe` (`publisherId`),
  KEY `IDX_9e3215dbfc238a233f5fbc4889` (`problemId`),
  KEY `IDX_43422726d6df9de966a0322512` (`problemId`,`sortTime`,`publisherId`),
  KEY `IDX_78d9d18f3de70af5e6db6c8c43` (`problemId`,`isPublic`,`sortTime`,`publisherId`),
  CONSTRAINT `FK_31f21d648dc4bfd9ffd2d074fe5` FOREIGN KEY (`publisherId`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_9e3215dbfc238a233f5fbc48898` FOREIGN KEY (`problemId`) REFERENCES `problem` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discussion`
--

LOCK TABLES `discussion` WRITE;
/*!40000 ALTER TABLE `discussion` DISABLE KEYS */;
/*!40000 ALTER TABLE `discussion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discussion_content`
--

DROP TABLE IF EXISTS `discussion_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `discussion_content` (
  `discussionId` int(11) NOT NULL,
  `content` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`discussionId`),
  UNIQUE KEY `REL_ead0dc8aaf683b5f0d8ed214f6` (`discussionId`),
  CONSTRAINT `FK_ead0dc8aaf683b5f0d8ed214f6a` FOREIGN KEY (`discussionId`) REFERENCES `discussion` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discussion_content`
--

LOCK TABLES `discussion_content` WRITE;
/*!40000 ALTER TABLE `discussion_content` DISABLE KEYS */;
/*!40000 ALTER TABLE `discussion_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discussion_reaction`
--

DROP TABLE IF EXISTS `discussion_reaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `discussion_reaction` (
  `discussionId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `emoji` varbinary(28) NOT NULL,
  PRIMARY KEY (`discussionId`,`userId`,`emoji`),
  KEY `IDX_79547fa1a34a42feaf15627d17` (`userId`),
  KEY `IDX_cd9aaa2c6e038bfadc711f85d1` (`discussionId`,`emoji`),
  KEY `IDX_1f2ebb466a44dc30526cdfb525` (`discussionId`,`userId`,`emoji`),
  CONSTRAINT `FK_79547fa1a34a42feaf15627d17d` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_b1347358780b8ebe8bdba9037f0` FOREIGN KEY (`discussionId`) REFERENCES `discussion` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discussion_reaction`
--

LOCK TABLES `discussion_reaction` WRITE;
/*!40000 ALTER TABLE `discussion_reaction` DISABLE KEYS */;
/*!40000 ALTER TABLE `discussion_reaction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discussion_reply`
--

DROP TABLE IF EXISTS `discussion_reply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `discussion_reply` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `publishTime` datetime NOT NULL,
  `editTime` datetime DEFAULT NULL,
  `isPublic` tinyint(4) NOT NULL,
  `discussionId` int(11) NOT NULL,
  `publisherId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_088162e17d18764c8e0b7f3d3c` (`publishTime`),
  KEY `IDX_713cc64e0babb669eeb7ba700a` (`editTime`),
  KEY `IDX_18bafb753e9c943cc16c272512` (`discussionId`),
  KEY `IDX_2107856a195cb3347b325fcf83` (`publisherId`),
  KEY `IDX_bf05dce10eaa1520d4e39b445c` (`discussionId`,`id`,`publisherId`),
  KEY `IDX_646c80ce64deab48888294ce3a` (`discussionId`,`id`,`isPublic`),
  CONSTRAINT `FK_18bafb753e9c943cc16c2725122` FOREIGN KEY (`discussionId`) REFERENCES `discussion` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_2107856a195cb3347b325fcf832` FOREIGN KEY (`publisherId`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discussion_reply`
--

LOCK TABLES `discussion_reply` WRITE;
/*!40000 ALTER TABLE `discussion_reply` DISABLE KEYS */;
/*!40000 ALTER TABLE `discussion_reply` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discussion_reply_reaction`
--

DROP TABLE IF EXISTS `discussion_reply_reaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `discussion_reply_reaction` (
  `discussionReplyId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `emoji` varbinary(28) NOT NULL,
  PRIMARY KEY (`discussionReplyId`,`userId`,`emoji`),
  KEY `IDX_7de08247e40dd1c6315245f0ea` (`userId`),
  KEY `IDX_03abd528a1d82471503d7ac327` (`discussionReplyId`,`emoji`),
  KEY `IDX_9ff01f6a9c32cdf13a44a4f302` (`discussionReplyId`,`userId`,`emoji`),
  CONSTRAINT `FK_7de08247e40dd1c6315245f0eaf` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_ed12d115c36919c15cfac4c6c49` FOREIGN KEY (`discussionReplyId`) REFERENCES `discussion_reply` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discussion_reply_reaction`
--

LOCK TABLES `discussion_reply_reaction` WRITE;
/*!40000 ALTER TABLE `discussion_reply_reaction` DISABLE KEYS */;
/*!40000 ALTER TABLE `discussion_reply_reaction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `file`
--

DROP TABLE IF EXISTS `file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `file` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `size` int(11) NOT NULL,
  `uploadTime` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_d85c96c207a7395158a68ee126` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `file`
--

LOCK TABLES `file` WRITE;
/*!40000 ALTER TABLE `file` DISABLE KEYS */;
/*!40000 ALTER TABLE `file` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `group`
--

DROP TABLE IF EXISTS `group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(48) COLLATE utf8mb4_unicode_ci NOT NULL,
  `memberCount` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_8a45300fd825918f3b40195fbd` (`name`)
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
-- Table structure for table `judge_client`
--

DROP TABLE IF EXISTS `judge_client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `judge_client` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `key` char(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `allowedHosts` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_d1a82157f6ab829c78e681577f` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `judge_client`
--

LOCK TABLES `judge_client` WRITE;
/*!40000 ALTER TABLE `judge_client` DISABLE KEYS */;
/*!40000 ALTER TABLE `judge_client` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `localized_content`
--

DROP TABLE IF EXISTS `localized_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `localized_content` (
  `objectId` int(11) NOT NULL,
  `type` enum('ProblemTitle','ProblemContent','ProblemTagName') COLLATE utf8mb4_unicode_ci NOT NULL,
  `locale` enum('en_US','zh_CN','ja_JP') COLLATE utf8mb4_unicode_ci NOT NULL,
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
  `objectType` enum('Problem','Discussion') COLLATE utf8mb4_unicode_ci NOT NULL,
  `groupId` int(11) NOT NULL,
  `permissionLevel` int(11) NOT NULL,
  PRIMARY KEY (`objectId`,`objectType`,`groupId`),
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
  `objectType` enum('Problem','Discussion') COLLATE utf8mb4_unicode_ci NOT NULL,
  `userId` int(11) NOT NULL,
  `permissionLevel` int(11) NOT NULL,
  PRIMARY KEY (`objectId`,`objectType`,`userId`),
  KEY `IDX_4793cc20adaac11452e7e34c57` (`userId`),
  KEY `IDX_924ca2195ce50c337d7e88f593` (`objectId`,`objectType`,`userId`),
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
  `type` enum('Traditional','Interaction','SubmitAnswer') COLLATE utf8mb4_unicode_ci NOT NULL,
  `isPublic` tinyint(4) NOT NULL,
  `publicTime` datetime DEFAULT NULL,
  `ownerId` int(11) NOT NULL,
  `locales` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `submissionCount` int(11) NOT NULL,
  `acceptedSubmissionCount` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_219b1e601b8b47e38de7f91dbe` (`displayId`),
  KEY `FK_c39da795fe62e7a65b7ed5eacba` (`ownerId`),
  CONSTRAINT `FK_c39da795fe62e7a65b7ed5eacba` FOREIGN KEY (`ownerId`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `problem`
--

LOCK TABLES `problem` WRITE;
/*!40000 ALTER TABLE `problem` DISABLE KEYS */;
/*!40000 ALTER TABLE `problem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `problem_file`
--

DROP TABLE IF EXISTS `problem_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `problem_file` (
  `problemId` int(11) NOT NULL,
  `type` enum('TestData','AdditionalFile') COLLATE utf8mb4_unicode_ci NOT NULL,
  `filename` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `uuid` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`problemId`,`type`,`filename`),
  CONSTRAINT `FK_a78a14239aabe967ee873d7549d` FOREIGN KEY (`problemId`) REFERENCES `problem` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `problem_file`
--

LOCK TABLES `problem_file` WRITE;
/*!40000 ALTER TABLE `problem_file` DISABLE KEYS */;
/*!40000 ALTER TABLE `problem_file` ENABLE KEYS */;
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
/*!40000 ALTER TABLE `problem_sample` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `problem_tag`
--

DROP TABLE IF EXISTS `problem_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `problem_tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `color` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `locales` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `problem_tag`
--

LOCK TABLES `problem_tag` WRITE;
/*!40000 ALTER TABLE `problem_tag` DISABLE KEYS */;
/*!40000 ALTER TABLE `problem_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `problem_tag_map`
--

DROP TABLE IF EXISTS `problem_tag_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `problem_tag_map` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `problemId` int(11) NOT NULL,
  `problemTagId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_138ee7875855ae108ad1fc9870` (`problemId`,`problemTagId`),
  KEY `IDX_bd68d5a8ded5639e40cced306f` (`problemId`),
  KEY `IDX_6236a4ec59d17c40dcb7e0d074` (`problemTagId`),
  CONSTRAINT `FK_6236a4ec59d17c40dcb7e0d0749` FOREIGN KEY (`problemTagId`) REFERENCES `problem_tag` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_bd68d5a8ded5639e40cced306fe` FOREIGN KEY (`problemId`) REFERENCES `problem` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `problem_tag_map`
--

LOCK TABLES `problem_tag_map` WRITE;
/*!40000 ALTER TABLE `problem_tag_map` DISABLE KEYS */;
/*!40000 ALTER TABLE `problem_tag_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `submission`
--

DROP TABLE IF EXISTS `submission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `submission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `taskId` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `isPublic` tinyint(4) NOT NULL,
  `codeLanguage` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `answerSize` int(11) DEFAULT NULL,
  `timeUsed` int(11) DEFAULT NULL,
  `memoryUsed` int(11) DEFAULT NULL,
  `score` int(11) DEFAULT NULL,
  `status` enum('Pending','ConfigurationError','SystemError','Canceled','CompilationError','FileError','RuntimeError','TimeLimitExceeded','MemoryLimitExceeded','OutputLimitExceeded','InvalidInteraction','PartiallyCorrect','WrongAnswer','Accepted','JudgementFailed') COLLATE utf8mb4_unicode_ci NOT NULL,
  `submitTime` datetime NOT NULL,
  `problemId` int(11) NOT NULL,
  `submitterId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_fe96352b2f1e9bfb922c54eba1` (`isPublic`),
  KEY `IDX_c070c2d4786412369a646a5d4b` (`codeLanguage`),
  KEY `IDX_92def80b501371ec0ce5df607e` (`score`),
  KEY `IDX_04a58564ad172e19f4ba1ca5d3` (`status`),
  KEY `IDX_ebd1b63340ac17250257bb42d3` (`submitTime`),
  KEY `IDX_3182d5e825aa9dee60559030d4` (`problemId`),
  KEY `IDX_e5f4d46cd1d0c691ac9d80e306` (`submitterId`),
  KEY `IDX_8f7047952600eb35a86208fa0d` (`problemId`,`submitterId`,`status`),
  KEY `IDX_60cf71f894ad9c8d878b7c823b` (`problemId`,`submitterId`),
  KEY `IDX_dabad4d6c14a960a04c5689ab5` (`isPublic`,`status`,`codeLanguage`),
  KEY `IDX_7bfb085025154721ba1ef6bf8e` (`isPublic`,`codeLanguage`,`submitterId`),
  KEY `IDX_e5d8ffe28e4e2297f1cf7d37b2` (`isPublic`,`submitterId`,`status`,`codeLanguage`),
  KEY `IDX_a6bd5902fd1410a3bbb38e90cf` (`isPublic`,`problemId`,`codeLanguage`,`submitterId`),
  KEY `IDX_b8c9400add938e8a99ba691ee6` (`isPublic`,`problemId`,`status`,`codeLanguage`),
  KEY `IDX_f4523bac8a7a22b5b3330893c0` (`isPublic`,`problemId`,`submitterId`,`status`,`codeLanguage`),
  CONSTRAINT `FK_3182d5e825aa9dee60559030d49` FOREIGN KEY (`problemId`) REFERENCES `problem` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_e5f4d46cd1d0c691ac9d80e3064` FOREIGN KEY (`submitterId`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submission`
--

LOCK TABLES `submission` WRITE;
/*!40000 ALTER TABLE `submission` DISABLE KEYS */;
/*!40000 ALTER TABLE `submission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `submission_detail`
--

DROP TABLE IF EXISTS `submission_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `submission_detail` (
  `submissionId` int(11) NOT NULL,
  `content` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `fileUuid` char(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `result` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`submissionId`),
  UNIQUE KEY `REL_23be757795c044a246c82e414e` (`submissionId`),
  UNIQUE KEY `IDX_b2253c2c2e5e15cc1e99232906` (`fileUuid`),
  CONSTRAINT `FK_23be757795c044a246c82e414e7` FOREIGN KEY (`submissionId`) REFERENCES `submission` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submission_detail`
--

LOCK TABLES `submission_detail` WRITE;
/*!40000 ALTER TABLE `submission_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `submission_detail` ENABLE KEYS */;
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
  `nickname` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  `bio` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL,
  `avatarInfo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `isAdmin` tinyint(4) NOT NULL,
  `acceptedProblemCount` int(11) NOT NULL,
  `submissionCount` int(11) NOT NULL,
  `rating` int(11) NOT NULL,
  `publicEmail` tinyint(4) NOT NULL,
  `registrationTime` datetime DEFAULT NULL,
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
INSERT INTO `user` VALUES (1,'Menci','huanghaorui301@gmail.com','','','gravatar:',1,0,0,0,1,'2020-10-27 15:24:20');
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
  `password` char(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
INSERT INTO `user_auth` VALUES (1,'$2b$10$UYCfuYy/X2eW0YEHpAENJOx6sPB3kh4qPb6D9TqSSdsdzTMf.Gwpy');
/*!40000 ALTER TABLE `user_auth` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_information`
--

DROP TABLE IF EXISTS `user_information`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_information` (
  `userId` int(11) NOT NULL,
  `organization` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `location` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `telegram` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `qq` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `github` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`userId`),
  UNIQUE KEY `REL_9505f52b69dcdd979173b620ca` (`userId`),
  CONSTRAINT `FK_9505f52b69dcdd979173b620ca8` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_information`
--

LOCK TABLES `user_information` WRITE;
/*!40000 ALTER TABLE `user_information` DISABLE KEYS */;
INSERT INTO `user_information` VALUES (1,'','','','','','');
/*!40000 ALTER TABLE `user_information` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_migration_info`
--

DROP TABLE IF EXISTS `user_migration_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_migration_info` (
  `userId` int(11) NOT NULL,
  `oldUsername` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `oldEmail` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `oldPasswordHashBcrypt` char(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `usernameMustChange` tinyint(4) NOT NULL,
  `migrated` tinyint(4) NOT NULL,
  PRIMARY KEY (`userId`),
  UNIQUE KEY `REL_ec55c7dc1c79cfbd36caed67d7` (`userId`),
  CONSTRAINT `FK_ec55c7dc1c79cfbd36caed67d74` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_migration_info`
--

LOCK TABLES `user_migration_info` WRITE;
/*!40000 ALTER TABLE `user_migration_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_migration_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_preference`
--

DROP TABLE IF EXISTS `user_preference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_preference` (
  `userId` int(11) NOT NULL,
  `preference` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`userId`),
  UNIQUE KEY `REL_5b141fbd1fef95a0540f7e7d1e` (`userId`),
  CONSTRAINT `FK_5b141fbd1fef95a0540f7e7d1e2` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_preference`
--

LOCK TABLES `user_preference` WRITE;
/*!40000 ALTER TABLE `user_preference` DISABLE KEYS */;
INSERT INTO `user_preference` VALUES (1,'{}');
/*!40000 ALTER TABLE `user_preference` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_privilege`
--

DROP TABLE IF EXISTS `user_privilege`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_privilege` (
  `userId` int(11) NOT NULL,
  `privilegeType` enum('ManageUser','ManageUserGroup','ManageProblem','ManageContest','ManageDiscussion') COLLATE utf8mb4_unicode_ci NOT NULL,
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

-- Dump completed on 2020-10-27 17:17:14
