-- MariaDB dump 10.19  Distrib 10.4.28-MariaDB, for osx10.10 (x86_64)
--
-- Host: localhost    Database: cafe_fantini
-- ------------------------------------------------------
-- Server version	10.4.28-MariaDB

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
-- Table structure for table `CATEGORIES`
--

DROP TABLE IF EXISTS `CATEGORIES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CATEGORIES` (
  `category_id` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(255) NOT NULL,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `uq_category_name` (`category_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CATEGORIES`
--

LOCK TABLES `CATEGORIES` WRITE;
/*!40000 ALTER TABLE `CATEGORIES` DISABLE KEYS */;
INSERT INTO `CATEGORIES` VALUES (4,'Accessories'),(2,'Capsules'),(1,'Coffee Beans'),(3,'Juices'),(5,'Syrups');
/*!40000 ALTER TABLE `CATEGORIES` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PRODUCTS`
--

DROP TABLE IF EXISTS `PRODUCTS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PRODUCTS` (
  `product_id` int(11) NOT NULL AUTO_INCREMENT,
  `product_name` varchar(255) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 0,
  `size` varchar(50) DEFAULT NULL,
  `category_id` int(11) NOT NULL,
  PRIMARY KEY (`product_id`),
  KEY `idx_category_id` (`category_id`),
  KEY `idx_quantity` (`quantity`),
  KEY `idx_product_id` (`product_id`),
  FULLTEXT KEY `ft_product_name` (`product_name`),
  CONSTRAINT `fk_products_category` FOREIGN KEY (`category_id`) REFERENCES `CATEGORIES` (`category_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=446 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PRODUCTS`
--

LOCK TABLES `PRODUCTS` WRITE;
/*!40000 ALTER TABLE `PRODUCTS` DISABLE KEYS */;
INSERT INTO `PRODUCTS` VALUES (2,'Café Bar Extra (cse= 8 kg)',20,'kg',1),(11,'BARATTOLO (cafe)- RED (argento x 250gr)',0,'tin',1),(13,'THE - Red Rose  (x 100s)',0,'bxe',1),(15,'Tisane Camomille (x 20s)',0,'bxe',1),(16,'Tisane Peppermint - (menthe) (x 20s)',0,'bxe',1),(17,'Tisane Earl Grey - (thea noir) (x 20s)',0,'bxe',1),(21,'Tisane Green Tea - (tea vert) (x 20s)',0,'bxe',1),(24,'Tisane Cranberry - (canneberge) (x 20s)',0,'bxe',1),(25,'Tisane Lemon - (citron) (x 20s)',0,'bxe',1),(26,'PAPIER (filtre a cafe) (x 1000)',0,'cse',1),(28,'Cappuccino - cups (pqt x 6)',0,'box',1),(29,'ESPRESSO - cups (pqt x 6)',0,'box',1),(35,'Café Décaféiné MUSETTI  (cse =20 x 500gr)',0,'EACH',1),(36,'FANTINI Pod - ORO (moyen) (cse x 200)',0,'each',1),(38,'BARATTOLO (cafe) - NERO (bar extra - 250gr)',0,'tin',1),(41,'GRIMAC Mach. Esp. (Terry)',0,'each',1),(45,'POD MACHINE - (EN CONSIGNE)',0,'each',1),(48,'Café Selezione (cse= 8 kg)',0,'kg',1),(53,'GRIMAC  Machine (Dadda) (CONSIGNE)',0,'each',1),(67,'MANGO SYRUP (cse = 6 x 1/2 gal)',0,'1/2 gal',1),(69,'Granita - Limonade - syrup (cse x 6 x 2 lt)',0,'gal',1),(71,'MELON D\'EAU SYRUP (cse = 6 x 1/2 gal)',0,'1/2 gal',1),(75,'Café - Silex  - DECAFEINE (x 64s)',0,'cse',1),(78,'Tisane English Breakfast (x 20s)',0,'bxe',1),(84,'Fantini  -  Misc. Supplies',0,'each',1),(92,'Moak - tasses espresso)',0,'dz',1),(93,'Moak - tasses cappucino)',0,'dz',1),(97,'POUDRE DE CACAO (CSE = 20 x 1KG)',0,'EACH',1),(104,'Tisane Mures Sauvages - (blackberry)  (x 20s)',0,'bxe',1),(106,'Banane syrup (cse x 6 x 2 lt)',0,'gal',1),(115,'Mach esp.2gr (PRESTIGE)) auto. (Bord) (mat;1610E20014',0,'each',1),(116,'Café - Silex - MÉLANGE VELOUTÉ (x 64s)',0,'cse',1),(121,'Café  (Moulu) (100%- Arabica) (24x250gr)',0,'each',1),(122,'CAFE  Argento  (cse= 8kg)',0,'kg',1),(125,'Tisane Bleuet - (blueberry) (x 20s)',0,'bxe',1),(132,'Moak -  Coffee  Kit (x 150 serv,)',0,'bxe',1),(133,'SILEX INCL RECHAUD- (EN CONSIGNE)',0,'each',1),(140,'ADOUCISSEUR  d\'eau DVA  8 lt',0,'each',1),(151,'CAPITANI Mach. Esp.\"B\" ARG - Col. Avorio',0,'each',1),(152,'CAPITANI Mach. Esp.+ VAP \"B\" Col. Argento',0,'each',1),(154,'Capsule café  \"Quality\" - 70% arabica - 30% robusta)',0,'each',1),(157,'MACHINE ESP. MOD SOPHIA - 2gr (Bordeaux) #S170620001)',0,'Each',1),(166,'Cafe Selezione (cse x 16 x 500gr)',0,'kl',1),(167,'FANTINI Pod - ROSSO  (fort) (cse x 200)',0,'each',1),(168,'DOLCIFICANTE (MUSETTI)',0,'bxe',1),(170,'Macinino Fiorenzato#30158806',0,'each',1),(179,'BARATTOLO- (cafe) - BLUE (decaf - 250 gr)',0,'tin',1),(180,'FANTINI Pod  - DECAFEINE  (cse x 200)',0,'each',1),(187,'BARATTOLO (cafe) - GOLD (selezione x 250 gr)',0,'tin',1),(190,'BATTIFONDI Inox',0,'each',1),(191,'Macchina CHOCOLADY con campana',0,'each',1),(198,'ADOUCISSEUR d\'eau DVA 12LT)',0,'each',1),(205,'FRAMBOISE BLEU SYRUP (cse= 3 X 4 LT)',0,'4 LT',1),(206,'Sucre Blanc FANTINI (3000 sachet=10kg)',0,'cse',1),(207,'Sucre Brun FANTINI (1520 sachet = 5kg)',0,'cse',1),(213,'ASCOR EXPRESS  (poudre nettoyante x 1kl)',0,'pot',1),(223,'Café 4 stelle (excelso)  (cse= 8kg)',0,'kg',1),(227,'R.D.L.- CIALDE COFFEE MACHINE',0,'each',1),(237,'Cafe BIO (cse= 8kg)',0,'kg',1),(238,'Cafe BIO (cse=12pqt x 250 gr)',0,'each',1),(239,'PRESSINO METAL',0,'each',1),(240,'Pressini Nylon',0,'each',1),(243,'BAR Capsules compatible NESPRESSO',0,'each',1),(245,'Moulin Fiorenzato (CNSIGNE)',0,'Each',1),(246,'Tisanne verbena',0,'bx',1),(247,'Tazzoni',0,'each',1),(248,'COMPUTER HARDWARE & IT SERVICES',0,'Each',1),(249,'Miscela di caffe decaffeinato (50 sachet)',0,'box',1),(250,'CAFE ROSSO  250gr (24x250gr)',0,'Each',1),(251,'Cafe argento 500gr (cse=14x500gr)',0,'Each',1),(252,'Cafe 4 stelle 500gr (cse=14x500gr)',0,'Each',1),(253,'Cafe selezione 500gr (cse=14x500gr)',0,'Each',1),(254,'DECAF Capsules compatible NESPRESSO',0,'Each',1),(255,'BICCHIERINO IN PLASTICA FANTINI (pqt x 50pcs)',0,'pqt',1),(256,'COFFEE GRINDER FIORENZATO',0,'Each',1),(257,'CBC ROYAL LIRA 2GR/14/PU',0,'Each',1),(258,'CBC ROYAL LIRA 2GR/21/PU',0,'Each',1),(259,'CBC ROYAL ANTEA 2GR',0,'Each',1),(260,'FANTINI NAPKINS',0,'pqt',1),(261,'CHERRY SYRUP (cse= 3 X 4LT)',0,'4 LT',1),(262,'SANTAL PERA 250ML X 24',0,'cse',1),(263,'SANTAL PLUS PEACH MANGO 250ML X 24',0,'cse',1),(264,'SANTAL GREEN APPLE 250ML X 24',0,'cse',1),(265,'SANTAL ARANCE ROSSE 250ML X 24',0,'cse',1),(266,'SANTAL BANANA 250ML X 24',0,'cse',1),(267,'SANTAL ICE TEA PEACH 250ML X 24',0,'cse',1),(268,'SANTAL PEACH LEMON 250ML X 24',0,'cse',1),(269,'SANTAL ICE TEA LEMON 250ML X 24',0,'cse',1),(270,'SANTAL ACTIVE ACE CARROT/ORANG 250ML X 24',0,'cse',1),(271,'SANTAL PEACH NECTAR 250ML X 24',0,'cse',1),(272,'SANTAL PINK GRAPEFRUIT 250ML X 24',0,'cse',1),(273,'SANTAL 100% ORANGE 250ML X 24',0,'cse',1),(274,'SANTAL POMEGRENATE (MELOGRANO) 250ML X 24',0,'cse',1),(275,'SANTAL ARANCE ROSSE 1000ML X 12',0,'cse',1),(276,'ORGANIC EARL GREY (BOX = 100)',0,'Each',1),(277,'CHAMOMILE CITRUS / CAMOMILLE AGRUMES (BOX=100)',0,'Each',1),(278,'GREEN TEA TROPICAL / THE VERT TROPICAL (BOX=100)',0,'Each',1),(279,'ORGANIC MINT / MELANGE DE MENTHE BIOLOGIQUE (BOX=100)',0,'Each',1),(280,'ORGANIC TUMERIC GINGER (BOX=100)',0,'Each',1),(281,'ORGANIC HOJICHA BIOLOGIQUE (GREEN TEA) (BOX = 100)',0,'Each',1),(282,'SANTAL PERA 1000ML X 12',0,'cse',1),(283,'SANTAL MIRTILLO (BLUEBERRY) 250ML X 24',0,'cse',1),(284,'LAPACO NAPKINS 2-PLY',0,'cse',1),(285,'SANTAL 100% ANANAS 250ML X 24',0,'cse',1),(286,'SANTAL APRICOT NECTAR 250ML X 24',0,'cse',1),(287,'ZUCCHERO BIANCO FANTINI ( cse = 5kg )',0,'cse',1),(288,'ZUCCHERO CANNA FANTINI ( cse = 5kg )',0,'cse',1),(289,'CAFFE CREMA 1KG  ( CSE= 10 x 1KG )',0,'1KG',1),(290,'CAFE FANTINI BAR',0,'kg',1),(291,'INSEGNA FANTINI OVALE',0,'Each',1),(292,'MAXI POD PRO 1 GRUPPO TOUCH INOX',0,'Each',1),(293,'MAXI POD PRO EVO 2 GRUPPO TOUCH INOX',0,'Each',1),(294,'ELEGANCE 2 GROUPS AUTO - INOX',0,'Each',1),(295,'ELEGANCE 2 GROUPS AUTO - BLACK',0,'Each',1),(296,'ELEGANCE 2 GROUPS AUTO - WHITE',0,'Each',1),(297,'PRESTIGE 2 GROUPS AUTO - RED',0,'Each',1),(298,'PRESTIGE 2 GROUPS AUTO - WHITE',0,'Each',1),(299,'PRESTIGE 2 GROUPS AUTO - BLACK',0,'Each',1),(300,'ELEGANCE 3 GROUPS AUTO - BLACK/INOX',0,'Each',1),(301,'ELEGANCE 2 GROUPS AUTO - BLACK/INOX',0,'Each',1),(302,'JOLLY 1 GROUP AUTO - BLACK OR STAINLESS',0,'Each',1),(303,'CBC ROYAL LIRA 3 GROUP',0,'Each',1),(304,'CIME 2 GROUP SEMIAUTO',0,'Each',1),(305,'CBC ROYAL IMPERO 3 GROUP',0,'Each',1),(306,'VERA 2 GROUP 220-240V AUTO INOX',0,'Each',1),(307,'GRINDER MD F 64 A - 110V',0,'Each',1),(308,'GRINDER MD F 64 EL - 110V',0,'Each',1),(309,'SAECO ROYAL OTC',0,'Each',1),(310,'FANTINI BAR (FILTRE)',0,'kg',1),(311,'FANTINI POD MACHINE',0,'Each',1),(312,'ARABICA Capsules compatible NESPRESSO',0,'Each',1),(313,'SANTAL AGRUMI MELONE(CITRUS MELON)',0,'cse',1),(314,'ENGLISH BREAKFAST/PETIT DEJEUNER ANGLAIS (BOX=100)',0,'Each',1),(315,'SAECO AULIKA TOP HSC',0,'Each',1),(317,'JOLLY 2GR AUTO 230-240V (WHITE)',0,'Each',1),(318,'JOLLY 2GR AUTO 230-240V (GLOSSY BLACK)',0,'Each',1),(319,'HAND SANITIZER 2L PUMP (CSE= 6 X 2L)',0,'Each',1),(320,'CREMA MACHINE (BLACK)',0,'Each',1),(321,'CAFFETTIERA 500GR (CSE=20 X 500GR)',0,'Each',1),(322,'SANITIZER 1LT REFILL CITRUS (CSE=10LT)',0,'Each(1LT)',1),(323,'SANITIZER 1LT REFILL PEACH (CSE=10LT)',0,'Each(1LT)',1),(324,'SANITIZER 1LT REFILL WATERMELON (CSE=10LT)',0,'Each(1LT)',1),(325,'SANITIZER 1LT REFILL NEUTRAL (CSE=10LT)',0,'Each(1LT)',1),(326,'AUTO DISPENSER W/STAND *LOAN*',0,'Each',1),(327,'AUTO DISPENSER *LOAN*',0,'Each',1),(328,'CLIP ON HAND SANITIZER (48 UNITS PER BOX)',0,'BOX',1),(329,'MANGO SYRUP (cse = 6 x 1/2 gal)',0,'Each',1),(330,'SANITIZER WIPES 100ct BAG (CSE=12 BAGS)',0,'Each',1),(331,'SERVICE PROGRAM (BI-ANNUAL)',0,'Each',1),(332,'HAND SANITIZER 1L PUMP (CSE= 8 X 1L)',0,'Each',1),(333,'CIOCIARO 500GR (CSE=14 X 500GR)',0,'Each',1),(334,'CAFE ROSSO COLOSSEO  250gr (CSE=24 X 250gr)',0,'Each',1),(335,'CAFE ORO SAN PIETRO  250gr (CSE=24 X 250gr)',0,'Each',1),(336,'TRANSPORT FEE',0,'Each',1),(337,'SERVICE (1ST HR + DISPLACEMENT)',0,'Each',1),(338,'SERVICE',0,'Each',1),(339,'SOTTOCOPPA',0,'Each',1),(340,'SPACER FOR GROUP HEAD',0,'Each',1),(341,'BICCHIERE 4OZ CIOCIARO',0,'Each',1),(342,'4OZ LIDS',0,'Each',1),(343,'BICCHIERE 4OZ CLUB SOCIAL',0,'Each',1),(344,'BICCHIERE 4OZ CAFE GELATO',0,'Each',1),(345,'BLACK ESPRESSO CUPS (BOX = 6 CUPS)',0,'BOX',1),(346,'BLACK CAPPUCCINO CUPS (BOX = 6 CUPS)',0,'BOX',1),(347,'BICCHIERE 4OZ ROMEO & CAFFE',0,'Each',1),(348,'BICCHIERE 4OZ CAFE SAN SIMEON',0,'Each',1),(349,'NOBEL 1GR',0,'Each',1),(350,'QUAMAR M80E ROSSO (ELECTRIC)',0,'Each',1),(351,'BICCHIERE 4OZ FANTINI',0,'Each',1),(352,'BICCHIERE 7.5 OZ ROMEO & CAFFE',0,'Each',1),(353,'BICCHIERE 7.5 OZ CAFE GELATO',0,'Each',1),(354,'BICCHIERE 12.5 OZ CAFE GELATO',0,'Each',1),(355,'BICCHIERE 7.5 OZ CLUB SOCIAL',0,'Each',1),(356,'BICCHIERE 12.5 OZ CLUB SOCIAL',0,'Each',1),(357,'BICCHIERE 7.5 OZ CIOCIARO',0,'Each',1),(358,'BICCHIERE 12.5 OZ CIOCIARO',0,'Each',1),(359,'BICCHIERE 7.5 OZ CAFE SAN SIMEON',0,'Each',1),(360,'BICCHIERE 12.5 OZ CAFE SAN SIMEON',0,'Each',1),(361,'9 OZ LIDS',0,'Each',1),(362,'12 OZ LIDS',0,'Each',1),(363,'SANTAL PLUS PEACH MANGO 1000ML X 12',0,'CASE',1),(364,'SANTAL PEACH NECTAR 1000ML X 12',0,'CASE',1),(365,'BICCHIERE 9 OZ FANTINI',0,'Each',1),(366,'BICCHIERE 12 OZ FANTINI',0,'Each',1),(367,'FANTINI POD/CIALDE MACHINE',0,'Each',1),(368,'GRINDER ANFIM BLACK (110V)',0,'Each',1),(369,'CLUB SOCIAL 500GR (CSE=14 X 500GR)',0,'Each',1),(370,'OLIMPICO ZUCCHERO BIANCO (10KG)',0,'CASE(10KG)',1),(371,'OLIMPICO ZUCCHERO CANNA (10KG)',0,'CASE(10KG)',1),(372,'FABBRI VANILLA (1000ML)',0,'Each',1),(373,'FABBRI AMARETTO (1000ML)',0,'Each',1),(374,'FABBRI CARAMEL (1000ML)',0,'Each',1),(375,'FABBRI ORZATA (1000ML)',0,'Each',1),(376,'FABBRI NOCCIOLA (1000ML)',0,'Each',1),(377,'FABBRI GINGERBREAD (1000ML)',0,'Each',1),(378,'FABBRI CINNAMON (1000ML)',0,'Each',1),(379,'FABBRI CHAI (1000ML)',0,'Each',1),(380,'FABBRI AMARENA (230g)',0,'Each',1),(381,'FABBRI STRAWBERRY (230g)',0,'Each',1),(382,'FABBRI GINGER (230g)',0,'Each',1),(383,'MARINELLI 500GR (CSE=14 X 500GR)',0,'Each',1),(384,'PIZZERIA NAPOLETANA 500GR (CSE=12 X 500GR)',0,'Each',1),(385,'PIZZERIA NAPOLETANA MACINATO 500GR (CSE=12 X 500GR)',0,'Each',1),(386,'SPINEL CIAO 120V (RED)',0,'Each',1),(387,'SPINEL CIAO 120V (WHITE)',0,'Each',1),(388,'RDL CIALDE MACHINE STD 120V (BLACK)',0,'Each',1),(389,'RDL CIALDE MACHINE STD 120V (WHITE)',0,'Each',1),(390,'GRINDER MD F 83 EL - 110V',0,'Each',1),(391,'GRINDER MD F 71 EL (CONICAL)- 110V',0,'Each',1),(392,'RED LEAF. LAIT EN POUDRE (500GR) (CSE=10 BAGS)',0,'Each',1),(393,'DURE CAPPUCCINO VANILLE FRANCAISE 2LB (CSE=6 BAGS)',0,'Each',1),(394,'DURE-LICIOUS CHOC CHAUD 2LB (CSE=12 BAGS)',0,'Each',1),(395,'STANDARD AUTO 2GR (INOX)',0,'Each',1),(396,'GRAINS D\'ESPOIR',0,'Each',1),(397,'COFFEE GRINDER MITO (120V)',0,'Each',1),(398,'PARADISO 1KG (MUSETTI) CSE=10KG',0,'KG',1),(399,'CREMISSIMO 1KG (MUSETTI) CSE=10KG',0,'KG',1),(400,'ROSSA 1KG (MUSETTI) CSE=10KG',0,'KG',1),(401,'JOLLY 2GR AUTO 230-240V (INOX)',0,'Each',1),(402,'JOLLY 2GR AUTO 230-240V (RED)',0,'Each',1),(403,'K22 AUTO 2GR 220V-240V (INOX)',0,'Each',1),(404,'K22 AUTO 2GR 220V-240V (RED)',0,'Each',1),(405,'K22 AUTO 2GR 220V-240V (BLACK)',0,'Each',1),(406,'SPINEL JESSICA 1GR AUTO 120V',0,'Each',1),(407,'LEVA LUXURY 2GR ETL 220-240V (WHITE)',0,'Each',1),(408,'SELECT 1KG (MUSETTI) CSE=10KG',0,'Each',1),(409,'NATURALE EAU DE SOURCE SAN BERNARDO (24x330ml)',0,'CASE',1),(410,'FRIZZANTE EAU DE SOURCE SAN BERNARDO (24x330ml)',0,'CASE',1),(411,'MATTONELLA CAFFETTIERA 250GR (CSE=18 X 250GR)',0,'Each',1),(412,'CAFFETTIERA NAPKINS (10PKS/BOX 2000 PCS)',0,'BOX',1),(413,'MUSETTI POD ROSSA (CIALDE) BX=150',0,'Each',1),(414,'MUSETTI POD CREMISSIMO (CIALDE) BX=150',0,'Each',1),(415,'MUSETTI POD PARADISO (CIALDE) BX=150',0,'Each',1),(416,'ZUCCHERO BIANCO MUSETTI (CSE=10KG)',0,'CASE',1),(417,'ZUCCHERO CANNA MUSETTI (CSE=10KG)',0,'CASE',1),(418,'MUSETTI FILTER COFFEE (SILEX) 85GR X 100',0,'CASE',1),(419,'CREMA PISTACCHIO 1KG (CSE = 10KG)',0,'Each',1),(420,'LA SAN MARCO 105 TOUCH 220V (MATT BLACK)',0,'Each',1),(421,'ZUCCHERO CANNA CAFFETTIERA (10KG)',0,'Each',1),(422,'201 BLEND 1KG (MUSETTI) CSE=10KG',0,'Each',1),(423,'CREAROMA 1KG (MUSETTI) CSE=10KG',0,'Each',1),(424,'MUSETTI NAPKINS (10PKS/BOX=2000 PCS)',0,'PACK',1),(425,'3 OZ MUSETTI BICCHIERE/ BOX=2000',0,'Each',1),(426,'8 OZ MUSETTI BICCHIERE / BOX=1000',0,'Each',1),(427,'ZUCCHERO BIANCO CAFFETTIERA (10KG)',0,'Each',1),(428,'MUSETTI POD SELECT (CIALDE) BX=150',0,'Each',1),(429,'CAPSULE MUSETTI GENTILE',0,'Each',1),(430,'CAPSULE MUSETTI ARMONICO',0,'Each',1),(431,'CAPSULE MUSETTI INTENSO',0,'Each',1),(432,'CAPSULE MUSETTI DECAF',0,'Each',1),(433,'FAP CAPSULE CREMISSIMO (BOX=100 PCS)',0,'Each',1),(434,'FAP CAPSULE DECAF (BOX=100 PCS)',0,'Each',1),(435,'GENTILE MATTONELLA 250GR (CSE = 18 X 250GR)',0,'Each',1),(436,'ARMONICO MATTONELLA 250GR (CSE = 18 X 250GR)',0,'Each',1),(437,'INTENSO MATTONELLA 250GR (CSE = 18 X 250GR)',0,'Each',1),(438,'DECAF MATTONELLA 250GR (CSE = 18 X 250GR)',0,'Each',1),(439,'MARRAKECH MINT (BOX = 100)',0,'Each',1),(440,'SERVICE PROGRAM (BI-ANNUAL W/CARTRIDGE REPLACEMENT)',0,'Each',1),(441,'SERVICE PROGRAM (BI-ANNUAL W/CARTRIDGE)',0,'Each',1),(442,'SPINEL JESSICA 2GR AUTO 220V',0,'Each',1),(443,'FAP CAPSULE ROSSA (BOX=100 PCS)',0,'Each',1),(444,'MUSETTI POD DECAF (CIALDE) BX=150',0,'Each',1),(445,'Test Product',10,'bxe',1);
/*!40000 ALTER TABLE `PRODUCTS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `STOCK_UPDATES`
--

DROP TABLE IF EXISTS `STOCK_UPDATES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `STOCK_UPDATES` (
  `update_id` int(11) NOT NULL AUTO_INCREMENT,
  `quantity_change` int(11) NOT NULL,
  `updated_at` date NOT NULL,
  `product_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`update_id`),
  KEY `fk_stock_product` (`product_id`),
  KEY `fk_stock_user` (`user_id`),
  CONSTRAINT `fk_stock_product` FOREIGN KEY (`product_id`) REFERENCES `PRODUCTS` (`product_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_stock_user` FOREIGN KEY (`user_id`) REFERENCES `USERS` (`user_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `STOCK_UPDATES`
--

LOCK TABLES `STOCK_UPDATES` WRITE;
/*!40000 ALTER TABLE `STOCK_UPDATES` DISABLE KEYS */;
INSERT INTO `STOCK_UPDATES` VALUES (6,100,'2026-05-03',2,1),(7,-80,'2026-05-03',2,1),(8,0,'2026-05-03',2,1),(9,0,'2026-05-03',2,1),(10,10,'2026-05-03',445,1);
/*!40000 ALTER TABLE `STOCK_UPDATES` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_after_stock_insert
AFTER INSERT ON STOCK_UPDATES
FOR EACH ROW
BEGIN
  UPDATE PRODUCTS
  SET    quantity = quantity + NEW.quantity_change
  WHERE  product_id = NEW.product_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `USERS`
--

DROP TABLE IF EXISTS `USERS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `USERS` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uq_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USERS`
--

LOCK TABLES `USERS` WRITE;
/*!40000 ALTER TABLE `USERS` DISABLE KEYS */;
INSERT INTO `USERS` VALUES (1,'Adamo','$2y$12$.pX5tw0One/DeksnA5KFUeigVRh8cejRPt6WxCI0O6FsVo8rnZQha','admin','admin@cafefantini.com'),(2,'Secretary','$2y$12$/SFUbMn2ca5AwtG3VVHM0ezI1KJSS1ePjgXv1/U8HQ6v1sHPPEP96','secretary','secretary@cafefantini.com');
/*!40000 ALTER TABLE `USERS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `v_products`
--

DROP TABLE IF EXISTS `v_products`;
/*!50001 DROP VIEW IF EXISTS `v_products`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_products` AS SELECT
 1 AS `product_id`,
  1 AS `product_name`,
  1 AS `quantity`,
  1 AS `size`,
  1 AS `category_id`,
  1 AS `category_name`,
  1 AS `status` */;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `v_products`
--

/*!50001 DROP VIEW IF EXISTS `v_products`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_products` AS select `p`.`product_id` AS `product_id`,`p`.`product_name` AS `product_name`,`p`.`quantity` AS `quantity`,`p`.`size` AS `size`,`p`.`category_id` AS `category_id`,`c`.`category_name` AS `category_name`,case when `p`.`quantity` < 10 then 'critical' when `p`.`quantity` < 50 then 'low-stock' else 'in-stock' end AS `status` from (`products` `p` join `categories` `c` on(`c`.`category_id` = `p`.`category_id`)) */;
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

-- Dump completed on 2026-05-03 19:58:51
