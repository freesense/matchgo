/*
 Navicat Premium Data Transfer

 Source Server         : new Byex生产-SSH
 Source Server Type    : MySQL
 Source Server Version : 50720
 Source Host           : rm-j6cbr743ax3asi6ttbo.mysql.rds.aliyuncs.com:3306
 Source Schema         : jys_his

 Target Server Type    : MySQL
 Target Server Version : 50720
 File Encoding         : 65001

 Date: 26/01/2019 01:01:13
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for bargain
-- ----------------------------
DROP TABLE IF EXISTS `bargain`;
CREATE TABLE `bargain`  (
  `tags` char(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `bargain_id` bigint(20) UNSIGNED NOT NULL,
  `bargain_dt` timestamp(0) NULL DEFAULT NULL,
  `consign_id_activated` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `consign_id_proactive` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`tags`, `bargain_id`) USING BTREE,
  INDEX `ix_activated`(`consign_id_activated`) USING BTREE,
  INDEX `ix_proactive`(`consign_id_proactive`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bargain_20181015
-- ----------------------------
DROP TABLE IF EXISTS `bargain_20181015`;
CREATE TABLE `bargain_20181015`  (
  `tags` char(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `bargain_id` bigint(20) UNSIGNED NOT NULL,
  `bargain_dt` timestamp(0) NULL DEFAULT NULL,
  `consign_id_activated` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `consign_id_proactive` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`bargain_id`) USING BTREE,
  INDEX `consign_id_activated`(`consign_id_activated`) USING BTREE,
  INDEX `consign_id_proactive`(`consign_id_proactive`) USING BTREE,
  INDEX `ix_bargain_consign_id_activated`(`consign_id_activated`) USING BTREE,
  INDEX `ix_bargain_consign_id_proactive`(`consign_id_proactive`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ccyflow
-- ----------------------------
DROP TABLE IF EXISTS `ccyflow`;
CREATE TABLE `ccyflow`  (
  `tags` char(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `flow_id` bigint(20) NOT NULL,
  `user_id` int(11) NULL DEFAULT NULL,
  `ccy` int(11) NULL DEFAULT NULL,
  `occur_dt` timestamp(0) NULL DEFAULT NULL,
  `occur_balance` bigint(20) NULL DEFAULT NULL,
  `occur_frozen` bigint(20) NULL DEFAULT NULL,
  `summary` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `business_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`tags`, `flow_id`) USING BTREE,
  INDEX `ix_usrid`(`user_id`) USING BTREE,
  INDEX `ix_businessid`(`business_id`) USING BTREE,
  INDEX `ix_settle`(`tags`, `user_id`, `ccy`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ccyflow_20181015
-- ----------------------------
DROP TABLE IF EXISTS `ccyflow_20181015`;
CREATE TABLE `ccyflow_20181015`  (
  `tags` char(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `flow_id` bigint(20) NOT NULL,
  `user_id` int(11) NULL DEFAULT NULL,
  `ccy` int(11) NULL DEFAULT NULL,
  `occur_dt` timestamp(0) NULL DEFAULT NULL,
  `occur_balance` bigint(20) NULL DEFAULT NULL,
  `occur_frozen` bigint(20) NULL DEFAULT NULL,
  `summary` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `business_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`flow_id`) USING BTREE,
  INDEX `ix_ccyflow_user_id`(`user_id`) USING BTREE,
  INDEX `ix_ccyflow_uid_ccy`(`user_id`, `ccy`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign
-- ----------------------------
DROP TABLE IF EXISTS `consign`;
CREATE TABLE `consign`  (
  `tags` char(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`tags`, `consign_id`) USING BTREE,
  INDEX `ix_userid`(`user_id`) USING BTREE,
  INDEX `ix_consignid`(`consign_id`) USING BTREE,
  INDEX `ix_dt`(`consign_dt`) USING BTREE,
  INDEX `ix_ss`(`symbol`, `reference`) USING BTREE,
  INDEX `ix_tags`(`tags`) USING BTREE,
  INDEX `ix_tc`(`tags`, `consign_dt`, `user_id`) USING BTREE,
  INDEX `ix_relatedid`(`related_id`) USING BTREE,
  INDEX `ix_settle`(`tags`, `consign_id`, `user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181015
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181015`;
CREATE TABLE `consign_20181015`  (
  `tags` char(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`consign_id`) USING BTREE,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181129t194346
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181129t194346`;
CREATE TABLE `consign_20181129t194346`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181130t163314
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181130t163314`;
CREATE TABLE `consign_20181130t163314`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181201t165941
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181201t165941`;
CREATE TABLE `consign_20181201t165941`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181202t190022
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181202t190022`;
CREATE TABLE `consign_20181202t190022`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181203t190022
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181203t190022`;
CREATE TABLE `consign_20181203t190022`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181204t190022
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181204t190022`;
CREATE TABLE `consign_20181204t190022`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181205t190022
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181205t190022`;
CREATE TABLE `consign_20181205t190022`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181206t190022
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181206t190022`;
CREATE TABLE `consign_20181206t190022`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181207t190022
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181207t190022`;
CREATE TABLE `consign_20181207t190022`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181208t190021
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181208t190021`;
CREATE TABLE `consign_20181208t190021`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181209t190022
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181209t190022`;
CREATE TABLE `consign_20181209t190022`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181210t190021
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181210t190021`;
CREATE TABLE `consign_20181210t190021`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181211t190021
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181211t190021`;
CREATE TABLE `consign_20181211t190021`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181212t190021
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181212t190021`;
CREATE TABLE `consign_20181212t190021`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181213t190021
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181213t190021`;
CREATE TABLE `consign_20181213t190021`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181214t190021
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181214t190021`;
CREATE TABLE `consign_20181214t190021`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181215t190021
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181215t190021`;
CREATE TABLE `consign_20181215t190021`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181216t190021
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181216t190021`;
CREATE TABLE `consign_20181216t190021`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181217t190021
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181217t190021`;
CREATE TABLE `consign_20181217t190021`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181218t190021
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181218t190021`;
CREATE TABLE `consign_20181218t190021`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE,
  INDEX `ix_settle`(`consign_id`, `user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181219t190022
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181219t190022`;
CREATE TABLE `consign_20181219t190022`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE,
  INDEX `ix_settle`(`consign_id`, `user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181220t190022
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181220t190022`;
CREATE TABLE `consign_20181220t190022`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181221t190022
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181221t190022`;
CREATE TABLE `consign_20181221t190022`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181222t190021
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181222t190021`;
CREATE TABLE `consign_20181222t190021`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181223t190021
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181223t190021`;
CREATE TABLE `consign_20181223t190021`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181224t190021
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181224t190021`;
CREATE TABLE `consign_20181224t190021`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181225t190022
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181225t190022`;
CREATE TABLE `consign_20181225t190022`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181226t190021
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181226t190021`;
CREATE TABLE `consign_20181226t190021`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181227t190021
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181227t190021`;
CREATE TABLE `consign_20181227t190021`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181228t190022
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181228t190022`;
CREATE TABLE `consign_20181228t190022`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181229t190022
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181229t190022`;
CREATE TABLE `consign_20181229t190022`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181230t190021
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181230t190021`;
CREATE TABLE `consign_20181230t190021`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20181231t190022
-- ----------------------------
DROP TABLE IF EXISTS `consign_20181231t190022`;
CREATE TABLE `consign_20181231t190022`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20190101t190022
-- ----------------------------
DROP TABLE IF EXISTS `consign_20190101t190022`;
CREATE TABLE `consign_20190101t190022`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20190102t190021
-- ----------------------------
DROP TABLE IF EXISTS `consign_20190102t190021`;
CREATE TABLE `consign_20190102t190021`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20190103t190022
-- ----------------------------
DROP TABLE IF EXISTS `consign_20190103t190022`;
CREATE TABLE `consign_20190103t190022`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20190104t190021
-- ----------------------------
DROP TABLE IF EXISTS `consign_20190104t190021`;
CREATE TABLE `consign_20190104t190021`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20190105t190021
-- ----------------------------
DROP TABLE IF EXISTS `consign_20190105t190021`;
CREATE TABLE `consign_20190105t190021`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20190106t190022
-- ----------------------------
DROP TABLE IF EXISTS `consign_20190106t190022`;
CREATE TABLE `consign_20190106t190022`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20190107t190021
-- ----------------------------
DROP TABLE IF EXISTS `consign_20190107t190021`;
CREATE TABLE `consign_20190107t190021`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20190108t190021
-- ----------------------------
DROP TABLE IF EXISTS `consign_20190108t190021`;
CREATE TABLE `consign_20190108t190021`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20190109t190021
-- ----------------------------
DROP TABLE IF EXISTS `consign_20190109t190021`;
CREATE TABLE `consign_20190109t190021`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20190110t190022
-- ----------------------------
DROP TABLE IF EXISTS `consign_20190110t190022`;
CREATE TABLE `consign_20190110t190022`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20190111t190022
-- ----------------------------
DROP TABLE IF EXISTS `consign_20190111t190022`;
CREATE TABLE `consign_20190111t190022`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20190112t190022
-- ----------------------------
DROP TABLE IF EXISTS `consign_20190112t190022`;
CREATE TABLE `consign_20190112t190022`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20190113t190022
-- ----------------------------
DROP TABLE IF EXISTS `consign_20190113t190022`;
CREATE TABLE `consign_20190113t190022`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20190114t190022
-- ----------------------------
DROP TABLE IF EXISTS `consign_20190114t190022`;
CREATE TABLE `consign_20190114t190022`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20190115t190022
-- ----------------------------
DROP TABLE IF EXISTS `consign_20190115t190022`;
CREATE TABLE `consign_20190115t190022`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20190116t190021
-- ----------------------------
DROP TABLE IF EXISTS `consign_20190116t190021`;
CREATE TABLE `consign_20190116t190021`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20190118t190021
-- ----------------------------
DROP TABLE IF EXISTS `consign_20190118t190021`;
CREATE TABLE `consign_20190118t190021`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20190119t190021
-- ----------------------------
DROP TABLE IF EXISTS `consign_20190119t190021`;
CREATE TABLE `consign_20190119t190021`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20190120t190022
-- ----------------------------
DROP TABLE IF EXISTS `consign_20190120t190022`;
CREATE TABLE `consign_20190120t190022`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20190121t190021
-- ----------------------------
DROP TABLE IF EXISTS `consign_20190121t190021`;
CREATE TABLE `consign_20190121t190021`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20190122t190021
-- ----------------------------
DROP TABLE IF EXISTS `consign_20190122t190021`;
CREATE TABLE `consign_20190122t190021`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20190123t190022
-- ----------------------------
DROP TABLE IF EXISTS `consign_20190123t190022`;
CREATE TABLE `consign_20190123t190022`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign_20190124t190021
-- ----------------------------
DROP TABLE IF EXISTS `consign_20190124t190021`;
CREATE TABLE `consign_20190124t190021`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT NULL,
  `fee` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_consign_relateid`(`related_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for daysettle_info
-- ----------------------------
DROP TABLE IF EXISTS `daysettle_info`;
CREATE TABLE `daysettle_info`  (
  `tbname` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tags` char(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `ids` bigint(20) NOT NULL,
  INDEX `ix_daysettle_info`(`tbname`, `tags`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for dts_increment_trx
-- ----------------------------
DROP TABLE IF EXISTS `dts_increment_trx`;
CREATE TABLE `dts_increment_trx`  (
  `job_id` char(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `partition` int(11) NOT NULL,
  `checkpoint` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`job_id`, `partition`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'DTS迁移位点表,请勿轻易删除!' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_account_info_20181020
-- ----------------------------
DROP TABLE IF EXISTS `jys_account_info_20181020`;
CREATE TABLE `jys_account_info_20181020`  (
  `create_time` bigint(20) NULL DEFAULT NULL,
  `update_time` bigint(20) NULL DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `coin` bigint(20) NOT NULL,
  `free_amount` decimal(24, 8) UNSIGNED NOT NULL,
  `freeze_amount` decimal(24, 8) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ix_jys_account_info_user_id`(`user_id`) USING BTREE,
  CONSTRAINT `jys_account_info_20181020_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `jys_user_info` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 262601 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_all_coin
-- ----------------------------
DROP TABLE IF EXISTS `jys_all_coin`;
CREATE TABLE `jys_all_coin`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `coin` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `withdraw_poundage` decimal(5, 4) NOT NULL,
  `coin_sell_poundage` decimal(5, 4) NOT NULL,
  `coin_buy_poundage` decimal(5, 4) NOT NULL,
  `legal_buy_poundage` decimal(5, 4) NOT NULL,
  `legal_sell_poundage` decimal(5, 4) NOT NULL,
  `set_legal` tinyint(1) NULL DEFAULT NULL,
  `min_withdraw` decimal(24, 8) NULL DEFAULT NULL,
  `once_min_withdraw` decimal(24, 8) NULL DEFAULT NULL,
  `withdraw_check_limit` decimal(24, 8) NULL DEFAULT NULL,
  `create_time` bigint(20) NULL DEFAULT NULL,
  `update_time` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `ix_jys_all_coin_coin`(`coin`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_all_symbol
-- ----------------------------
DROP TABLE IF EXISTS `jys_all_symbol`;
CREATE TABLE `jys_all_symbol`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `status` tinyint(1) NOT NULL,
  `datum_coin_id` bigint(20) NOT NULL,
  `trade_coin_id` bigint(20) NOT NULL,
  `price_point` int(11) NULL DEFAULT NULL,
  `size_point` int(11) NULL DEFAULT NULL,
  `weight` int(11) NULL DEFAULT NULL,
  `create_time` bigint(20) NULL DEFAULT NULL,
  `update_time` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ix_jys_all_symbol_datum_coin_id`(`datum_coin_id`) USING BTREE,
  INDEX `ix_jys_all_symbol_trade_coin_id`(`trade_coin_id`) USING BTREE,
  CONSTRAINT `jys_all_symbol_ibfk_1` FOREIGN KEY (`datum_coin_id`) REFERENCES `jys_all_coin` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `jys_all_symbol_ibfk_2` FOREIGN KEY (`trade_coin_id`) REFERENCES `jys_all_coin` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 38 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_bc_fee_flow
-- ----------------------------
DROP TABLE IF EXISTS `jys_bc_fee_flow`;
CREATE TABLE `jys_bc_fee_flow`  (
  `user_id` bigint(20) NULL DEFAULT NULL,
  `coin_id` smallint(6) NULL DEFAULT NULL,
  `bc_fee` bigint(20) NULL DEFAULT NULL,
  `isreturn` tinyint(1) NULL DEFAULT NULL,
  `consign_id` bigint(20) NOT NULL,
  `bc_amount` bigint(20) NULL DEFAULT NULL,
  `return_refer_amount` bigint(20) NULL DEFAULT NULL,
  `return_self_amount` bigint(20) NULL DEFAULT NULL,
  `create_time` timestamp(0) NULL DEFAULT NULL,
  `update_time` timestamp(0) NULL DEFAULT NULL,
  INDEX `ix_bcfee`(`consign_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_bc_fee_flow_his
-- ----------------------------
DROP TABLE IF EXISTS `jys_bc_fee_flow_his`;
CREATE TABLE `jys_bc_fee_flow_his`  (
  `user_id` bigint(20) NULL DEFAULT NULL,
  `coin_id` smallint(6) NULL DEFAULT NULL,
  `bc_fee` bigint(20) NULL DEFAULT NULL,
  `isreturn` tinyint(1) NULL DEFAULT NULL,
  `consign_id` bigint(20) NOT NULL,
  `bc_amount` bigint(20) NULL DEFAULT NULL,
  `return_refer_amount` bigint(20) NULL DEFAULT NULL,
  `return_self_amount` bigint(20) NULL DEFAULT NULL,
  `create_time` timestamp(0) NULL DEFAULT NULL,
  `update_time` timestamp(0) NULL DEFAULT NULL,
  INDEX `ix_jys_bc_fee_flow_his`(`user_id`, `coin_id`, `isreturn`) USING BTREE,
  INDEX `ix_consign_id`(`consign_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_order_info_20181020
-- ----------------------------
DROP TABLE IF EXISTS `jys_order_info_20181020`;
CREATE TABLE `jys_order_info_20181020`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `buyer_user_id` bigint(20) NOT NULL,
  `order_id` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `placard_id` bigint(20) NOT NULL,
  `amount` decimal(24, 8) NOT NULL,
  `total` decimal(24, 8) NOT NULL,
  `price` decimal(24, 8) NOT NULL,
  `status` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `seller_user_id` bigint(20) NOT NULL,
  `pay_num` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `out_confirm` tinyint(1) NOT NULL,
  `in_confirm` tinyint(1) NOT NULL,
  `buy_fee` decimal(24, 8) NOT NULL,
  `sell_fee` decimal(24, 8) NOT NULL,
  `coin` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `create_time` bigint(20) NULL DEFAULT NULL,
  `update_time` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ix_jys_order_info_buyer_user_id`(`buyer_user_id`) USING BTREE,
  INDEX `ix_jys_order_info_order_id`(`order_id`) USING BTREE,
  INDEX `ix_jys_order_info_placard_id`(`placard_id`) USING BTREE,
  INDEX `ix_jys_order_info_seller_user_id`(`seller_user_id`) USING BTREE,
  INDEX `ix_jys_order_info_coin`(`coin`) USING BTREE,
  CONSTRAINT `jys_order_info_20181020_ibfk_1` FOREIGN KEY (`buyer_user_id`) REFERENCES `jys_user_info` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `jys_order_info_20181020_ibfk_2` FOREIGN KEY (`placard_id`) REFERENCES `jys_publish_info_20181020` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `jys_order_info_20181020_ibfk_3` FOREIGN KEY (`seller_user_id`) REFERENCES `jys_user_info` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 1709 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181008t114315
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181008t114315`;
CREATE TABLE `jys_position_20181008t114315`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181008t114914
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181008t114914`;
CREATE TABLE `jys_position_20181008t114914`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181008t115114
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181008t115114`;
CREATE TABLE `jys_position_20181008t115114`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181009t082417
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181009t082417`;
CREATE TABLE `jys_position_20181009t082417`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181011t160512
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181011t160512`;
CREATE TABLE `jys_position_20181011t160512`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181011t173429
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181011t173429`;
CREATE TABLE `jys_position_20181011t173429`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181015t192146
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181015t192146`;
CREATE TABLE `jys_position_20181015t192146`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181015t192940
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181015t192940`;
CREATE TABLE `jys_position_20181015t192940`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181015t193627
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181015t193627`;
CREATE TABLE `jys_position_20181015t193627`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181015t193924
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181015t193924`;
CREATE TABLE `jys_position_20181015t193924`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181018t153350
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181018t153350`;
CREATE TABLE `jys_position_20181018t153350`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181020t161059
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181020t161059`;
CREATE TABLE `jys_position_20181020t161059`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181023t160212
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181023t160212`;
CREATE TABLE `jys_position_20181023t160212`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181025t163921
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181025t163921`;
CREATE TABLE `jys_position_20181025t163921`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181026t161404
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181026t161404`;
CREATE TABLE `jys_position_20181026t161404`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181029t160319
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181029t160319`;
CREATE TABLE `jys_position_20181029t160319`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181031t160619
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181031t160619`;
CREATE TABLE `jys_position_20181031t160619`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181101t160832
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181101t160832`;
CREATE TABLE `jys_position_20181101t160832`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181103t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181103t190022`;
CREATE TABLE `jys_position_20181103t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181104t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181104t190022`;
CREATE TABLE `jys_position_20181104t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181105t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181105t190022`;
CREATE TABLE `jys_position_20181105t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181106t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181106t190022`;
CREATE TABLE `jys_position_20181106t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181107t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181107t190022`;
CREATE TABLE `jys_position_20181107t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181108t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181108t190022`;
CREATE TABLE `jys_position_20181108t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181109t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181109t190022`;
CREATE TABLE `jys_position_20181109t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181110t170750
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181110t170750`;
CREATE TABLE `jys_position_20181110t170750`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181110t190021
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181110t190021`;
CREATE TABLE `jys_position_20181110t190021`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181111t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181111t190022`;
CREATE TABLE `jys_position_20181111t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181112t190021
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181112t190021`;
CREATE TABLE `jys_position_20181112t190021`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181113t190021
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181113t190021`;
CREATE TABLE `jys_position_20181113t190021`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181114t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181114t190022`;
CREATE TABLE `jys_position_20181114t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181115t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181115t190022`;
CREATE TABLE `jys_position_20181115t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181116t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181116t190022`;
CREATE TABLE `jys_position_20181116t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181117t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181117t190022`;
CREATE TABLE `jys_position_20181117t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181118t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181118t190022`;
CREATE TABLE `jys_position_20181118t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181129t190820
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181129t190820`;
CREATE TABLE `jys_position_20181129t190820`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181129t192714
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181129t192714`;
CREATE TABLE `jys_position_20181129t192714`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181129t194346
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181129t194346`;
CREATE TABLE `jys_position_20181129t194346`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181130t163314
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181130t163314`;
CREATE TABLE `jys_position_20181130t163314`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181201t165941
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181201t165941`;
CREATE TABLE `jys_position_20181201t165941`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181202t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181202t190022`;
CREATE TABLE `jys_position_20181202t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181203t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181203t190022`;
CREATE TABLE `jys_position_20181203t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181204t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181204t190022`;
CREATE TABLE `jys_position_20181204t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181205t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181205t190022`;
CREATE TABLE `jys_position_20181205t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181206t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181206t190022`;
CREATE TABLE `jys_position_20181206t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181207t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181207t190022`;
CREATE TABLE `jys_position_20181207t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181208t190021
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181208t190021`;
CREATE TABLE `jys_position_20181208t190021`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181209t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181209t190022`;
CREATE TABLE `jys_position_20181209t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181210t190021
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181210t190021`;
CREATE TABLE `jys_position_20181210t190021`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181211t190021
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181211t190021`;
CREATE TABLE `jys_position_20181211t190021`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181212t190021
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181212t190021`;
CREATE TABLE `jys_position_20181212t190021`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181213t190021
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181213t190021`;
CREATE TABLE `jys_position_20181213t190021`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181214t190021
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181214t190021`;
CREATE TABLE `jys_position_20181214t190021`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181215t190021
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181215t190021`;
CREATE TABLE `jys_position_20181215t190021`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181216t190021
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181216t190021`;
CREATE TABLE `jys_position_20181216t190021`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181217t190021
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181217t190021`;
CREATE TABLE `jys_position_20181217t190021`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181218t190021
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181218t190021`;
CREATE TABLE `jys_position_20181218t190021`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181219t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181219t190022`;
CREATE TABLE `jys_position_20181219t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181220t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181220t190022`;
CREATE TABLE `jys_position_20181220t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181221t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181221t190022`;
CREATE TABLE `jys_position_20181221t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181222t190021
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181222t190021`;
CREATE TABLE `jys_position_20181222t190021`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181223t190021
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181223t190021`;
CREATE TABLE `jys_position_20181223t190021`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181224t190021
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181224t190021`;
CREATE TABLE `jys_position_20181224t190021`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181225t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181225t190022`;
CREATE TABLE `jys_position_20181225t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181226t190021
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181226t190021`;
CREATE TABLE `jys_position_20181226t190021`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181227t190021
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181227t190021`;
CREATE TABLE `jys_position_20181227t190021`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181228t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181228t190022`;
CREATE TABLE `jys_position_20181228t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181229t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181229t190022`;
CREATE TABLE `jys_position_20181229t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181230t190021
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181230t190021`;
CREATE TABLE `jys_position_20181230t190021`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20181231t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20181231t190022`;
CREATE TABLE `jys_position_20181231t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20190101t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20190101t190022`;
CREATE TABLE `jys_position_20190101t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20190102t190021
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20190102t190021`;
CREATE TABLE `jys_position_20190102t190021`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20190103t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20190103t190022`;
CREATE TABLE `jys_position_20190103t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20190104t190021
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20190104t190021`;
CREATE TABLE `jys_position_20190104t190021`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20190105t190021
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20190105t190021`;
CREATE TABLE `jys_position_20190105t190021`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20190106t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20190106t190022`;
CREATE TABLE `jys_position_20190106t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20190107t190021
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20190107t190021`;
CREATE TABLE `jys_position_20190107t190021`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20190108t190021
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20190108t190021`;
CREATE TABLE `jys_position_20190108t190021`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20190109t190021
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20190109t190021`;
CREATE TABLE `jys_position_20190109t190021`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20190110t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20190110t190022`;
CREATE TABLE `jys_position_20190110t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20190111t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20190111t190022`;
CREATE TABLE `jys_position_20190111t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20190112t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20190112t190022`;
CREATE TABLE `jys_position_20190112t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20190113t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20190113t190022`;
CREATE TABLE `jys_position_20190113t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20190114t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20190114t190022`;
CREATE TABLE `jys_position_20190114t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20190115t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20190115t190022`;
CREATE TABLE `jys_position_20190115t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20190116t190021
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20190116t190021`;
CREATE TABLE `jys_position_20190116t190021`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20190118t190021
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20190118t190021`;
CREATE TABLE `jys_position_20190118t190021`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20190119t190021
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20190119t190021`;
CREATE TABLE `jys_position_20190119t190021`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20190120t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20190120t190022`;
CREATE TABLE `jys_position_20190120t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20190121t190021
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20190121t190021`;
CREATE TABLE `jys_position_20190121t190021`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20190122t190021
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20190122t190021`;
CREATE TABLE `jys_position_20190122t190021`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20190123t190022
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20190123t190022`;
CREATE TABLE `jys_position_20190123t190022`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position_20190124t190021
-- ----------------------------
DROP TABLE IF EXISTS `jys_position_20190124t190021`;
CREATE TABLE `jys_position_20190124t190021`  (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) UNSIGNED NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_publish_info_20181020
-- ----------------------------
DROP TABLE IF EXISTS `jys_publish_info_20181020`;
CREATE TABLE `jys_publish_info_20181020`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `coin` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `price` decimal(24, 8) UNSIGNED NOT NULL,
  `amount` decimal(24, 8) UNSIGNED NOT NULL,
  `now_amount` decimal(24, 8) UNSIGNED NULL DEFAULT NULL,
  `lock_amount` decimal(24, 8) UNSIGNED NULL DEFAULT NULL,
  `type` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `order_min` decimal(24, 8) NOT NULL,
  `order_max` decimal(24, 8) NOT NULL,
  `status` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `create_time` bigint(20) NULL DEFAULT NULL,
  `update_time` bigint(20) NULL DEFAULT NULL,
  `placard_id` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ix_jys_publish_info_coin`(`coin`) USING BTREE,
  INDEX `ix_jys_publish_info_status`(`status`) USING BTREE,
  INDEX `ix_jys_publish_info_user_id`(`user_id`) USING BTREE,
  INDEX `ix_jys_publish_info_placard_id`(`placard_id`) USING BTREE,
  CONSTRAINT `jys_publish_info_20181020_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `jys_user_info` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 394 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_tarnsfer_account_20181020
-- ----------------------------
DROP TABLE IF EXISTS `jys_tarnsfer_account_20181020`;
CREATE TABLE `jys_tarnsfer_account_20181020`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `coin` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `type` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `num` decimal(24, 8) NOT NULL,
  `create_time` bigint(20) NULL DEFAULT NULL,
  `update_time` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ix_jys_tarnsfer_account_user_id`(`user_id`) USING BTREE,
  INDEX `ix_jys_tarnsfer_account_coin`(`coin`) USING BTREE,
  INDEX `ix_jys_tarnsfer_account_type`(`type`) USING BTREE,
  CONSTRAINT `jys_tarnsfer_account_20181020_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `jys_user_info` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 1437 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Procedure structure for bc_flow
-- ----------------------------
DROP PROCEDURE IF EXISTS `bc_flow`;
delimiter ;;
CREATE PROCEDURE `bc_flow`()
  SQL SECURITY INVOKER
BEGIN
		insert into byex_db.jys_bc_fee_flow_his
		SELECT * FROM byex_db.jys_bc_fee_flow where isreturn=1;
        
        delete FROM byex_db.jys_bc_fee_flow where isreturn=1;
	END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for cz_ccy
-- ----------------------------
DROP PROCEDURE IF EXISTS `cz_ccy`;
delimiter ;;
CREATE PROCEDURE `cz_ccy`(IN p_user_id BIGINT,
  IN p_ccy BIGINT)
quit_fast:
BEGIN
  DECLARE fee BIGINT ;
  DECLARE max_cz_id BIGINT ;
  DECLARE t_error INTEGER DEFAULT 0 ;
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET t_error = 1 ;
  START TRANSACTION ;
  
  SELECT 
    IFNULL(SUM(- occur_balance),0) INTO @fee 
  FROM
    ccyflow 
  WHERE user_id = p_user_id 
    AND summary IN ('BBFE', 'CZ') 
    AND ccy = p_ccy ;
  
  IF @fee = 0 
  THEN 
	SET @t_error=2;
	SELECT NOW(),p_user_id,p_ccy,'上次冲账后未产生手续费不处理';
	LEAVE quit_fast ;
  END IF ;
  
  UPDATE 
    jys_position 
  SET
    `balance` = `balance` + @fee 
  WHERE user_id = p_user_id 
    AND ccy = p_ccy ;
  
  INSERT INTO `ccyflow` (
    `user_id`,
    `ccy`,
    `occur_dt`,
    `occur_balance`,
    `occur_frozen`,
    `summary`,
    `business_id`
  ) 
  VALUES
    (p_user_id, p_ccy, NOW(), @fee, 0, 'CZ', 0) ;
  
  SELECT 
    *,
    NOW(),p_user_id,p_ccy,
    @fee,t_error 
  FROM
    jys_position 
  WHERE user_id = p_user_id 
    AND ccy = p_ccy ;
    
  IF t_error > 0 
  THEN ROLLBACK ;
  ELSE COMMIT ;
  END IF ;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for cz_deccy
-- ----------------------------
DROP PROCEDURE IF EXISTS `cz_deccy`;
delimiter ;;
CREATE PROCEDURE `cz_deccy`(IN p_user_id BIGINT,
  IN p_ccy BIGINT,
  IN p_deccy_id BIGINT)
quit_fast:
BEGIN
  DECLARE fee BIGINT ;
  DECLARE max_cz_id BIGINT ;
  DECLARE t_error INTEGER DEFAULT 0 ;
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET t_error = 1 ;
  START TRANSACTION ;

SELECT occur_balance INTO @fee FROM ccyflow WHERE user_id=p_user_id AND ccy=p_ccy AND flow_id=p_deccy_id AND summary='CZ';   
  
  UPDATE 
    jys_position 
  SET
    `balance` = `balance` - @fee 
  WHERE user_id = p_user_id 
    AND ccy = p_ccy ;
  
  INSERT INTO `ccyflow` (
    `user_id`,
    `ccy`,
    `occur_dt`,
    `occur_balance`,
    `occur_frozen`,
    `summary`,
    `business_id`
  ) 
  VALUES
    (p_user_id, p_ccy, NOW(), -@fee, 0, 'CZ', 0) ;
  
  SELECT 
    *,
    NOW(),
    @fee 
  FROM
    jys_position 
  WHERE user_id = p_user_id 
    AND ccy = p_ccy ;
    
    
  SELECT 
    t_error ;
  IF t_error > 0 
  THEN ROLLBACK ;
  ELSE COMMIT ;
  END IF ;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for cz_his_20181124_ccy
-- ----------------------------
DROP PROCEDURE IF EXISTS `cz_his_20181124_ccy`;
delimiter ;;
CREATE PROCEDURE `cz_his_20181124_ccy`()
BEGIN
  DECLARE t_error INTEGER DEFAULT 0 ;
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET t_error = 1 ;
  START TRANSACTION ;
  
  UPDATE jys_position SET `balance` = `balance` + 18597256695 WHERE user_id = 151683 AND ccy = 13;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (151683, 13, NOW(), 18597256695, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 9401813400 WHERE user_id = 151683 AND ccy = 3;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (151683, 3, NOW(), 9401813400, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 3600000000 WHERE user_id = 151683 AND ccy = 14;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (151683, 14, NOW(), 3600000000, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 1480895707 WHERE user_id = 152031 AND ccy = 13;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (152031, 13, NOW(), 1480895707, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 1017680 WHERE user_id = 152031 AND ccy = 2;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (152031, 2, NOW(), 1017680, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 999702809752 WHERE user_id = 152063 AND ccy = 13;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (152063, 13, NOW(), 999702809752, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 2452635573397 WHERE user_id = 152063 AND ccy = 14;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (152063, 14, NOW(), 2452635573397, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 14568906715888 WHERE user_id = 152145 AND ccy = 13;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (152145, 13, NOW(), 14568906715888, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 150220 WHERE user_id = 152145 AND ccy = 2;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (152145, 2, NOW(), 150220, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 255420 WHERE user_id = 152145 AND ccy = 10;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (152145, 10, NOW(), 255420, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 26794392721492 WHERE user_id = 152145 AND ccy = 14;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (152145, 14, NOW(), 26794392721492, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 6819283759076 WHERE user_id = 152587 AND ccy = 13;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (152587, 13, NOW(), 6819283759076, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 200000 WHERE user_id = 152587 AND ccy = 14;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (152587, 14, NOW(), 200000, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 2544633614149 WHERE user_id = 152587 AND ccy = 15;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (152587, 15, NOW(), 2544633614149, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 723627748970 WHERE user_id = 152588 AND ccy = 13;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (152588, 13, NOW(), 723627748970, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 200000 WHERE user_id = 152588 AND ccy = 3;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (152588, 3, NOW(), 200000, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 167895405532 WHERE user_id = 152588 AND ccy = 15;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (152588, 15, NOW(), 167895405532, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 167833154153390 WHERE user_id = 152589 AND ccy = 13;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (152589, 13, NOW(), 167833154153390, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 53288374929986 WHERE user_id = 152589 AND ccy = 15;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (152589, 15, NOW(), 53288374929986, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 21199750897913 WHERE user_id = 155182 AND ccy = 13;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155182, 13, NOW(), 21199750897913, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 3066424574315 WHERE user_id = 155182 AND ccy = 3;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155182, 3, NOW(), 3066424574315, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 1050277833 WHERE user_id = 155182 AND ccy = 1;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155182, 1, NOW(), 1050277833, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 17978066144488 WHERE user_id = 155183 AND ccy = 13;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155183, 13, NOW(), 17978066144488, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 1556589567807 WHERE user_id = 155183 AND ccy = 3;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155183, 3, NOW(), 1556589567807, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 155984624 WHERE user_id = 155183 AND ccy = 1;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155183, 1, NOW(), 155984624, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 25908656552 WHERE user_id = 155183 AND ccy = 2;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155183, 2, NOW(), 25908656552, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 9757252400641 WHERE user_id = 155184 AND ccy = 13;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155184, 13, NOW(), 9757252400641, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 1384105124840 WHERE user_id = 155184 AND ccy = 3;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155184, 3, NOW(), 1384105124840, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 8621598189258 WHERE user_id = 155186 AND ccy = 13;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155186, 13, NOW(), 8621598189258, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 1230816466143 WHERE user_id = 155186 AND ccy = 3;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155186, 3, NOW(), 1230816466143, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 137345817 WHERE user_id = 155186 AND ccy = 1;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155186, 1, NOW(), 137345817, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 70093538380 WHERE user_id = 155186 AND ccy = 4;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155186, 4, NOW(), 70093538380, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 11443921092584 WHERE user_id = 155189 AND ccy = 13;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155189, 13, NOW(), 11443921092584, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 1644387838678 WHERE user_id = 155189 AND ccy = 3;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155189, 3, NOW(), 1644387838678, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 113724563 WHERE user_id = 155189 AND ccy = 1;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155189, 1, NOW(), 113724563, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 8178569860 WHERE user_id = 155189 AND ccy = 5;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155189, 5, NOW(), 8178569860, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 10386311181148 WHERE user_id = 155191 AND ccy = 13;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155191, 13, NOW(), 10386311181148, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 1505777528147 WHERE user_id = 155191 AND ccy = 3;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155191, 3, NOW(), 1505777528147, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 37304683 WHERE user_id = 155191 AND ccy = 1;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155191, 1, NOW(), 37304683, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 388672105100 WHERE user_id = 155191 AND ccy = 6;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155191, 6, NOW(), 388672105100, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 1368965025898 WHERE user_id = 155193 AND ccy = 13;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155193, 13, NOW(), 1368965025898, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 214848848834 WHERE user_id = 155193 AND ccy = 3;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155193, 3, NOW(), 214848848834, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 2052670 WHERE user_id = 155193 AND ccy = 1;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155193, 1, NOW(), 2052670, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 430220638314 WHERE user_id = 155193 AND ccy = 7;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155193, 7, NOW(), 430220638314, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 1461323883323 WHERE user_id = 155194 AND ccy = 13;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155194, 13, NOW(), 1461323883323, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 211286283000 WHERE user_id = 155194 AND ccy = 3;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155194, 3, NOW(), 211286283000, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 3002569 WHERE user_id = 155194 AND ccy = 1;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155194, 1, NOW(), 3002569, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 146459301960 WHERE user_id = 155194 AND ccy = 8;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155194, 8, NOW(), 146459301960, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 982422787210 WHERE user_id = 155195 AND ccy = 13;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155195, 13, NOW(), 982422787210, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 306391672195 WHERE user_id = 155195 AND ccy = 3;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155195, 3, NOW(), 306391672195, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 46789788 WHERE user_id = 155195 AND ccy = 1;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155195, 1, NOW(), 46789788, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 6085128980 WHERE user_id = 155195 AND ccy = 9;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155195, 9, NOW(), 6085128980, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 280153324333 WHERE user_id = 155196 AND ccy = 13;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155196, 13, NOW(), 280153324333, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 42688707989 WHERE user_id = 155196 AND ccy = 3;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155196, 3, NOW(), 42688707989, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 4892663 WHERE user_id = 155196 AND ccy = 1;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155196, 1, NOW(), 4892663, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 7813794920 WHERE user_id = 155196 AND ccy = 10;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155196, 10, NOW(), 7813794920, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 260634539790 WHERE user_id = 155197 AND ccy = 13;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155197, 13, NOW(), 260634539790, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 37327699314 WHERE user_id = 155197 AND ccy = 3;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155197, 3, NOW(), 37327699314, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 2456379 WHERE user_id = 155197 AND ccy = 1;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155197, 1, NOW(), 2456379, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 522213026200 WHERE user_id = 155197 AND ccy = 11;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155197, 11, NOW(), 522213026200, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 360498049979 WHERE user_id = 155198 AND ccy = 13;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155198, 13, NOW(), 360498049979, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 52354886229 WHERE user_id = 155198 AND ccy = 3;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155198, 3, NOW(), 52354886229, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 2270391 WHERE user_id = 155198 AND ccy = 1;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155198, 1, NOW(), 2270391, 0, 'CZ', 0);
UPDATE jys_position SET `balance` = `balance` + 34095681360 WHERE user_id = 155198 AND ccy = 12;
INSERT INTO `ccyflow` (`user_id`,`ccy`,`occur_dt`,`occur_balance`,`occur_frozen`,`summary`,`business_id`) VALUES (155198, 12, NOW(), 34095681360, 0, 'CZ', 0);

  IF t_error > 0 
  THEN ROLLBACK ;
  ELSE COMMIT ;
  END IF ;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for give_bc_20181128
-- ----------------------------
DROP PROCEDURE IF EXISTS `give_bc_20181128`;
delimiter ;;
CREATE PROCEDURE `give_bc_20181128`()
BEGIN

  DECLARE t_error INTEGER DEFAULT 0 ;
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET t_error = 1 ;
  START TRANSACTION ;
	UPDATE jys_account_info SET free_amount=free_amount+10,update_time=UNIX_TIMESTAMP(NOW()) WHERE user_id=150607 AND coin=13;
	UPDATE jys_account_info SET free_amount=free_amount+10,update_time=UNIX_TIMESTAMP(NOW()) WHERE user_id=150709 AND coin=13;
	INSERT INTO `jys_register_give_bc` (`user_id`,`coin`,`amount`,`type`,`create_time`,`is_return`) VALUES (150607,'BC',10,'register',UNIX_TIMESTAMP(NOW()),1) ;
	UPDATE `jys_register_give_bc` SET is_return=1 WHERE user_id=150709 AND `type`='register' AND coin='BC' AND amount=10;

  IF t_error > 0 
  THEN ROLLBACK ;
  ELSE COMMIT ;
  END IF ;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for market_sell
-- ----------------------------
DROP PROCEDURE IF EXISTS `market_sell`;
delimiter ;;
CREATE PROCEDURE `market_sell`(IN `in_user_id` BIGINT,
  IN `in_order_id` BIGINT)
BEGIN
  DECLARE error_code INT DEFAULT 0 ;
  
  DECLARE has_error INT DEFAULT 0 ;
  
  DECLARE error_msg VARCHAR (64) DEFAULT 'success' ;
  
  DECLARE sql_code CHAR(5) DEFAULT '00000' ;
  
  DECLARE sql_msg TEXT ;
  
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
  BEGIN
    GET DIAGNOSTICS CONDITION 1 sql_code = RETURNED_SQLSTATE,
    sql_msg = MESSAGE_TEXT ;
    
    SET has_error = 1 ;
    
  END ;
  
  SELECT 
    @in_ccy := aa.reference,
    @out_ccy := aa.symbol,
    @out_qty := - aa.deal_qty,
    @in_qty := aa.deal_amount,
    @in_fee := - fee,
    @in_time := bargain_dt,
    @in_bargin_id := b.bargain_id 
  FROM
    consign aa,
    bargain b 
  WHERE aa.consign_id = b.consign_id_activated 
    AND aa.user_id = in_user_id 
    AND aa.consign_id = in_order_id 
    AND aa.consign_type = 9 
    AND aa.STATUS = 5 ;
  
  START TRANSACTION ;
  
  Match_lable :
  BEGIN
    UPDATE 
      jys_position 
    SET
      balance = balance + @in_qty + @in_fee 
    WHERE ccy = @in_ccy 
      AND user_id = in_user_id ;
    
    IF (has_error = 1) 
    THEN SET error_msg = 'update POSITION IN SQLEXCEPTION!' ;
    
    LEAVE Match_lable ;
    
    END IF ;
    
    IF (ROW_COUNT() <> 1) 
    THEN SET error_msg = 'update POSITION IN no record updated !' ;
    
    SET has_error = 1 ;
    
    LEAVE Match_lable ;
    
    END IF ;
    
    UPDATE 
      jys_position 
    SET
      frozen = frozen + @out_qty 
    WHERE ccy = @out_ccy 
      AND user_id = in_user_id ;
    
    IF (has_error = 1) 
    THEN SET error_msg = 'update POSITION OUT SQLEXCEPTION!' ;
    
    LEAVE Match_lable ;
    
    END IF ;
    
    IF (ROW_COUNT() <> 1) 
    THEN SET error_msg = 'update POSITION OUT no record updated !' ;
    
    SET has_error = 1 ;
    
    LEAVE Match_lable ;
    
    END IF ;
    
    INSERT INTO ccyflow (
      `user_id`,
      `ccy`,
      `occur_dt`,
      `occur_balance`,
      `occur_frozen`,
      `summary`,
      `business_id`
    ) 
    VALUES
      (
        in_user_id,
        @in_ccy,
        @int_time,
        @in_qty,
        0,
        'BB',
        @in_bargin_id
      ) ;
    
    IF (has_error = 1) 
    THEN SET error_msg = 'insert ccyflow BBIN fail!' ;
    
    LEAVE Match_lable ;
    
    END IF ;
    
    IF (ROW_COUNT() <> 1) 
    THEN SET error_msg = 'insert ccyflow BBIN fail!' ;
    
    SET has_error = 1 ;
    
    LEAVE Match_lable ;
    
    END IF ;
    
    INSERT INTO ccyflow (
      `user_id`,
      `ccy`,
      `occur_dt`,
      `occur_balance`,
      `occur_frozen`,
      `summary`,
      `business_id`
    ) 
    VALUES
      (
        in_user_id,
        @out_ccy,
        @int_time,
        @out_qty,
        @out_qty,
        'BB',
        @in_bargin_id
      ) ;
    
    IF (has_error = 1) 
    THEN SET error_msg = 'insert ccyflow BBOUT fail!' ;
    
    LEAVE Match_lable ;
    
    END IF ;
    
    IF (ROW_COUNT() <> 1) 
    THEN SET error_msg = 'insert ccyflow  BBOUT fail!' ;
    
    SET has_error = 1 ;
    
    LEAVE Match_lable ;
    
    END IF ;
    
    INSERT INTO ccyflow (
      `user_id`,
      `ccy`,
      `occur_dt`,
      `occur_balance`,
      `occur_frozen`,
      `summary`,
      `business_id`
    ) 
    VALUES
      (
        in_user_id,
        @in_ccy,
        @int_time,
        @in_fee,
        0,
        'BBFE',
        @in_bargin_id
      ) ;
    
    IF (has_error = 1) 
    THEN SET error_msg = 'insert ccyflow BBFE fail!' ;
    
    LEAVE Match_lable ;
    
    END IF ;
    
    IF (ROW_COUNT() <> 1) 
    THEN SET error_msg = 'insert ccyflow  BBFE fail!' ;
    
    SET has_error = 1 ;
    
    LEAVE Match_lable ;
    
    END IF ;
    
  END Match_lable ;
  
  IF (has_error = 1) 
  THEN ROLLBACK ;
  
  END IF ;
  
  COMMIT ;
  
  SELECT 
    has_error AS error_code,
    error_msg AS error_msg,
    sql_code,
    sql_msg ;
  
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
