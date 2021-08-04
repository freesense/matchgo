/*
 Navicat Premium Data Transfer

 Source Server         : new Byex生产-SSH
 Source Server Type    : MySQL
 Source Server Version : 50720
 Source Host           : rm-j6cbr743ax3asi6ttbo.mysql.rds.aliyuncs.com:3306
 Source Schema         : byex_db

 Target Server Type    : MySQL
 Target Server Version : 50720
 File Encoding         : 65001

 Date: 26/01/2019 00:59:11
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for auth_group
-- ----------------------------
DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for auth_group_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_group_permissions_group_id_permission_id_0cd325b0_uniq`(`group_id`, `permission_id`) USING BTREE,
  INDEX `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm`(`permission_id`) USING BTREE,
  CONSTRAINT `auth_group_permissions_ibfk_1` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `auth_group_permissions_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for auth_user
-- ----------------------------
DROP TABLE IF EXISTS `auth_user`;
CREATE TABLE `auth_user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `last_login` datetime(6) NULL DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `first_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `last_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `email` varchar(254) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for auth_user_groups
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_groups`;
CREATE TABLE `auth_user_groups`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_user_groups_user_id_group_id_94350c0c_uniq`(`user_id`, `group_id`) USING BTREE,
  INDEX `auth_user_groups_group_id_97559544_fk_auth_group_id`(`group_id`) USING BTREE,
  CONSTRAINT `auth_user_groups_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `auth_user_groups_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for auth_user_user_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_user_permissions`;
CREATE TABLE `auth_user_user_permissions`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq`(`user_id`, `permission_id`) USING BTREE,
  INDEX `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm`(`permission_id`) USING BTREE,
  CONSTRAINT `auth_user_user_permissions_ibfk_1` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `auth_user_user_permissions_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bargain
-- ----------------------------
DROP TABLE IF EXISTS `bargain`;
CREATE TABLE `bargain`  (
  `bargain_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `bargain_dt` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `consign_id_activated` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `consign_id_proactive` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `price` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `qty` bigint(20) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`bargain_id`) USING BTREE,
  INDEX `ix_bargain_consign_id_activated`(`consign_id_activated`) USING BTREE,
  INDEX `ix_bargain_consign_id_proactive`(`consign_id_proactive`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 41262388 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for byex_bonus_record
-- ----------------------------
DROP TABLE IF EXISTS `byex_bonus_record`;
CREATE TABLE `byex_bonus_record`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `house_id` bigint(20) NULL DEFAULT NULL COMMENT '交易所ID',
  `mem_id` bigint(20) NULL DEFAULT NULL COMMENT '会员ID',
  `coin_id` bigint(20) NULL DEFAULT NULL COMMENT '币ID',
  `coin_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '币种名称',
  `contributor` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '贡献者用户名',
  `amount` decimal(35, 18) NULL DEFAULT NULL COMMENT '返佣数量',
  `entrust_id` bigint(20) NULL DEFAULT NULL COMMENT '关联的委托交易记录ID',
  `success_poundage_id` bigint(20) NULL DEFAULT NULL COMMENT '收取手续费的记录ID',
  `status` tinyint(4) NULL DEFAULT 0 COMMENT '结算状态：0=未结算；1=已结算',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `type` tinyint(4) NULL DEFAULT NULL,
  `level` int(11) NULL DEFAULT NULL COMMENT '返佣等级，（0为自己，直接关系为1级，间接关系为2级，以此类推）',
  `aggr_status` int(4) NULL DEFAULT 0 COMMENT '\'是否计入用户收益    0 否  1是\'',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `u_m_b_r_house_id`(`house_id`) USING BTREE,
  INDEX `u_m_b_r_mem_id`(`mem_id`) USING BTREE,
  INDEX `u_m_b_r_coin_id`(`coin_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 103196695172685825 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '返佣记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for byex_bxxb_address_balance
-- ----------------------------
DROP TABLE IF EXISTS `byex_bxxb_address_balance`;
CREATE TABLE `byex_bxxb_address_balance`  (
  `id` bigint(22) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `coin` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '代币名称',
  `address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '地址',
  `balance` decimal(28, 8) NULL DEFAULT 0.00000000 COMMENT '代币余额',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `coin`(`coin`, `address`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1543 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for byex_contract_v2_postion
-- ----------------------------
DROP TABLE IF EXISTS `byex_contract_v2_postion`;
CREATE TABLE `byex_contract_v2_postion`  (
  `uid` bigint(20) NOT NULL AUTO_INCREMENT,
  `address` varchar(44) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `balance` decimal(28, 2) NULL DEFAULT 0.00,
  `init_lock` decimal(28, 2) NULL DEFAULT 0.00,
  `left_lock` decimal(28, 2) NULL DEFAULT 0.00,
  `create_at` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP,
  `is_pay` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'N',
  PRIMARY KEY (`uid`) USING BTREE,
  UNIQUE INDEX `address`(`address`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 800 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ccyflow
-- ----------------------------
DROP TABLE IF EXISTS `ccyflow`;
CREATE TABLE `ccyflow`  (
  `flow_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NULL DEFAULT NULL,
  `ccy` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `occur_dt` timestamp(0) NULL DEFAULT NULL,
  `occur_balance` bigint(20) NOT NULL DEFAULT 0,
  `occur_frozen` bigint(20) NOT NULL DEFAULT 0,
  `summary` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `business_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`flow_id`) USING BTREE,
  INDEX `ix_ccyflow_user_id`(`user_id`) USING BTREE,
  INDEX `ix_ccyflow_uidccy`(`user_id`, `ccy`) USING BTREE,
  INDEX `ix_ccyflow_bid`(`business_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 91734908 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for consign
-- ----------------------------
DROP TABLE IF EXISTS `consign`;
CREATE TABLE `consign`  (
  `consign_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `consign_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` int(11) UNSIGNED NULL DEFAULT NULL,
  `symbol` smallint(6) NULL DEFAULT NULL,
  `reference` smallint(6) UNSIGNED NULL DEFAULT NULL,
  `consign_type` int(11) NULL DEFAULT NULL,
  `price` bigint(20) NULL DEFAULT NULL,
  `qty` bigint(20) NULL DEFAULT NULL,
  `status` tinyint(4) UNSIGNED NULL DEFAULT 1,
  `fee` bigint(20) NULL DEFAULT NULL,
  `deal_qty` bigint(20) UNSIGNED NULL DEFAULT 0,
  `deal_amount` bigint(20) UNSIGNED NULL DEFAULT 0,
  `related_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '关联订单编号',
  `update_dt` timestamp(0) NULL DEFAULT NULL,
  `frozen` bigint(20) UNSIGNED NULL DEFAULT 0,
  PRIMARY KEY (`consign_id`) USING BTREE,
  INDEX `ix_consign_user_id`(`user_id`) USING BTREE,
  INDEX `ix_consign_reference`(`reference`) USING BTREE,
  INDEX `ix_consign_symbol`(`symbol`) USING BTREE,
  INDEX `ix_related_id`(`related_id`) USING BTREE,
  INDEX `ix_yjcd`(`user_id`, `consign_type`, `status`, `related_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 42746629 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for django_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE `django_admin_log`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `object_repr` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL,
  `change_message` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `content_type_id` int(11) NULL DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `django_admin_log_content_type_id_c4bce8eb_fk_django_co`(`content_type_id`) USING BTREE,
  INDEX `django_admin_log_user_id_c564eba6_fk_auth_user_id`(`user_id`) USING BTREE,
  CONSTRAINT `django_admin_log_ibfk_1` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `django_admin_log_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 3561 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for django_content_type
-- ----------------------------
DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `model` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `django_content_type_app_label_model_76bd3d3b_uniq`(`app_label`, `model`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 40 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for django_migrations
-- ----------------------------
DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE `django_migrations`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for django_session
-- ----------------------------
DROP TABLE IF EXISTS `django_session`;
CREATE TABLE `django_session`  (
  `session_key` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `session_data` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`) USING BTREE,
  INDEX `django_session_expire_date_a5c62663`(`expire_date`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

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
-- Table structure for frozen_log
-- ----------------------------
DROP TABLE IF EXISTS `frozen_log`;
CREATE TABLE `frozen_log`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(255) NULL DEFAULT NULL,
  `ccy` int(255) NULL DEFAULT NULL,
  `qty` bigint(20) NULL DEFAULT NULL,
  `date` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 504 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_account_flow
-- ----------------------------
DROP TABLE IF EXISTS `jys_account_flow`;
CREATE TABLE `jys_account_flow`  (
  `flow_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NULL DEFAULT NULL,
  `ccy` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `occur_dt` timestamp(0) NULL DEFAULT NULL,
  `balance` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `frozen` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `occur_balance` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '0',
  `occur_frozen` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '0',
  `summary` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `business_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`flow_id`) USING BTREE,
  INDEX `ix_ccyflow_user_id`(`user_id`) USING BTREE,
  INDEX `ix_ccyflow_uidccy`(`user_id`, `ccy`) USING BTREE,
  INDEX `ix_ccyflow_bid`(`business_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 285623 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_account_info
-- ----------------------------
DROP TABLE IF EXISTS `jys_account_info`;
CREATE TABLE `jys_account_info`  (
  `create_time` bigint(20) NULL DEFAULT NULL,
  `update_time` bigint(20) NULL DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `coin` bigint(20) NOT NULL,
  `free_amount` decimal(24, 8) UNSIGNED NOT NULL,
  `freeze_amount` decimal(24, 8) UNSIGNED NOT NULL,
  `ctime` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `utime` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ix_jys_account_info_user_id`(`user_id`) USING BTREE,
  INDEX `ix_jys_account_info_coin`(`coin`) USING BTREE,
  INDEX `ix_jys_account_info_coin_id`(`coin`) USING BTREE,
  CONSTRAINT `jys_account_info_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `jys_user_info` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 302641 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

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
  `ctime` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `utime` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `ix_jys_all_coin_coin`(`coin`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

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
  `ctime` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `utime` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ix_jys_all_symbol_datum_coin_id`(`datum_coin_id`) USING BTREE,
  INDEX `ix_jys_all_symbol_trade_coin_id`(`trade_coin_id`) USING BTREE,
  CONSTRAINT `jys_all_symbol_ibfk_1` FOREIGN KEY (`datum_coin_id`) REFERENCES `jys_all_coin` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `jys_all_symbol_ibfk_2` FOREIGN KEY (`trade_coin_id`) REFERENCES `jys_all_coin` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 39 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_assets_flow
-- ----------------------------
DROP TABLE IF EXISTS `jys_assets_flow`;
CREATE TABLE `jys_assets_flow`  (
  `flow_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NULL DEFAULT NULL,
  `ccy` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `occur_dt` timestamp(0) NULL DEFAULT NULL,
  `balance` bigint(20) NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `occur_balance` bigint(20) NOT NULL DEFAULT 0,
  `occur_frozen` bigint(20) NOT NULL DEFAULT 0,
  `summary` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `business_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`flow_id`) USING BTREE,
  INDEX `ix_ccyflow_user_id`(`user_id`) USING BTREE,
  INDEX `ix_ccyflow_uidccy`(`user_id`, `ccy`) USING BTREE,
  INDEX `ix_ccyflow_bid`(`business_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 292227 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

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
  `ctime` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `utime` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
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
  `ctime` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `utime` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  INDEX `ix_jys_bc_fee_flow_his`(`user_id`, `coin_id`, `isreturn`) USING BTREE,
  INDEX `ix_consign_id`(`consign_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_bxxb_transfer
-- ----------------------------
DROP TABLE IF EXISTS `jys_bxxb_transfer`;
CREATE TABLE `jys_bxxb_transfer`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `coin` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `blockNumber` int(11) NULL DEFAULT NULL,
  `from` varchar(44) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `to` varchar(44) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `txid` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `amount` decimal(28, 8) NULL DEFAULT NULL,
  `create_at` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` datetime(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4441 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_coin_address
-- ----------------------------
DROP TABLE IF EXISTS `jys_coin_address`;
CREATE TABLE `jys_coin_address`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NULL DEFAULT NULL,
  `coin` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `out_address` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `in_address` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `password` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `create_time` bigint(20) NULL DEFAULT NULL,
  `update_time` bigint(20) NULL DEFAULT NULL,
  `ctime` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `utime` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `udx_in_out_address_coin`(`in_address`, `out_address`, `coin`) USING BTREE,
  INDEX `ix_jys_coin_address_user_id`(`user_id`) USING BTREE,
  INDEX `ix_jys_coin_address_coin`(`coin`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10430 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_coin_address_balance
-- ----------------------------
DROP TABLE IF EXISTS `jys_coin_address_balance`;
CREATE TABLE `jys_coin_address_balance`  (
  `id` bigint(22) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `coin` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '代币名称',
  `address` varchar(44) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '地址',
  `balance` decimal(44, 8) NULL DEFAULT 0.00000000 COMMENT '代币余额',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `coin`(`coin`, `address`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1594 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_daily_knots
-- ----------------------------
DROP TABLE IF EXISTS `jys_daily_knots`;
CREATE TABLE `jys_daily_knots`  (
  `user_id` bigint(20) NOT NULL COMMENT '用户id',
  `position` bigint(20) NULL DEFAULT NULL COMMENT '每日BX持仓',
  `state` int(5) NULL DEFAULT 0 COMMENT '状态（0：正常）',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `daily` bigint(20) NOT NULL COMMENT '日结日期',
  PRIMARY KEY (`user_id`, `daily`) USING BTREE,
  INDEX `ix_jys_daily_knots_user_id`(`user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '私募账户日结表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_fee_account
-- ----------------------------
DROP TABLE IF EXISTS `jys_fee_account`;
CREATE TABLE `jys_fee_account`  (
  `create_time` bigint(20) NULL DEFAULT NULL,
  `update_time` bigint(20) NULL DEFAULT NULL,
  `user_id` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `balance` decimal(24, 8) NULL DEFAULT NULL,
  `frozen` decimal(24, 8) NULL DEFAULT NULL,
  `bc_trader_amount` decimal(24, 8) NULL DEFAULT NULL,
  `history_fee_total` decimal(24, 8) NULL DEFAULT NULL,
  `invite_fee_total` decimal(24, 8) NULL DEFAULT NULL COMMENT '总邀请手续费返佣',
  `n_bc_trader_amount` decimal(24, 8) NULL DEFAULT NULL COMMENT '累计交易总额---新增',
  `n_history_fee_total` decimal(24, 8) NULL DEFAULT NULL COMMENT '累计手续费总额---新增',
  `return_fee_total` decimal(24, 8) NULL DEFAULT NULL COMMENT '总手续费返佣',
  `b_balance` decimal(24, 8) NULL DEFAULT NULL COMMENT '手续费总额备份',
  `ctime` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `utime` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`user_id`, `ccy`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_fix_forex
-- ----------------------------
DROP TABLE IF EXISTS `jys_fix_forex`;
CREATE TABLE `jys_fix_forex`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `create_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_dt` datetime(0) NOT NULL ON UPDATE CURRENT_TIMESTAMP(0),
  `coin` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `coin_id` int(10) UNSIGNED NOT NULL,
  `to_base` decimal(32, 8) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `ix_forex_coinid`(`coin_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_invite_info
-- ----------------------------
DROP TABLE IF EXISTS `jys_invite_info`;
CREATE TABLE `jys_invite_info`  (
  `create_time` bigint(20) NULL DEFAULT NULL,
  `update_time` bigint(20) NULL DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NULL DEFAULT NULL,
  `refer_uid` bigint(20) NULL DEFAULT NULL,
  `invite_count` int(11) NULL DEFAULT NULL,
  `un_auth_count` int(11) NULL DEFAULT NULL,
  `auth_count` int(11) NULL DEFAULT NULL,
  `ctime` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `utime` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `ix_jys_invite_info_user_id`(`user_id`) USING BTREE,
  INDEX `ix_jys_invite_info_refer_uid_1`(`refer_uid`) USING BTREE,
  CONSTRAINT `jys_invite_info_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `jys_user_info` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 60537 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_lately_login
-- ----------------------------
DROP TABLE IF EXISTS `jys_lately_login`;
CREATE TABLE `jys_lately_login`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NULL DEFAULT NULL,
  `login_time` datetime(0) NULL DEFAULT NULL,
  `login_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `ip` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `ip_name` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `create_time` bigint(20) NULL DEFAULT NULL,
  `update_time` bigint(20) NULL DEFAULT NULL,
  `ctime` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `utime` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ix_jys_lately_login_user_id`(`user_id`) USING BTREE,
  CONSTRAINT `jys_lately_login_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `jys_user_info` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 198644 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_log_trade
-- ----------------------------
DROP TABLE IF EXISTS `jys_log_trade`;
CREATE TABLE `jys_log_trade`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NULL DEFAULT NULL,
  `log_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `content` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `success` tinyint(1) NULL DEFAULT NULL,
  `ctime` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ix_jys_log_trade_user_id`(`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 792226 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_log_user
-- ----------------------------
DROP TABLE IF EXISTS `jys_log_user`;
CREATE TABLE `jys_log_user`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NULL DEFAULT NULL,
  `log_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `content` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `success` tinyint(1) NULL DEFAULT NULL,
  `ctime` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ix_jys_log_user_user_id`(`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 237484 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_monthly_knots
-- ----------------------------
DROP TABLE IF EXISTS `jys_monthly_knots`;
CREATE TABLE `jys_monthly_knots`  (
  `user_id` bigint(20) NOT NULL COMMENT '用户id',
  `position` bigint(20) NULL DEFAULT NULL COMMENT '30天BX持仓',
  `avg_position` decimal(24, 8) NULL DEFAULT NULL COMMENT '30天平均BX持仓',
  `state` int(5) NULL DEFAULT 0 COMMENT '状态（0：正常  1：月结通知失败）',
  `cycle` int(5) NOT NULL COMMENT '月结周期',
  `ratio` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '当月解锁比例',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `txid` varchar(88) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'txid',
  `chain_status` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '解锁状态',
  `ratio_num` bigint(10) NULL DEFAULT NULL COMMENT '解锁比例',
  PRIMARY KEY (`user_id`, `cycle`) USING BTREE,
  INDEX `ix_jys_monthly_knots_user_id`(`user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '私募账户月结表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_noob_task
-- ----------------------------
DROP TABLE IF EXISTS `jys_noob_task`;
CREATE TABLE `jys_noob_task`  (
  `user_id` bigint(20) NOT NULL COMMENT '用户id',
  `task_id` tinyint(5) NOT NULL DEFAULT 1 COMMENT '完成步骤（1：任务1  2：任务2  3：任务3）',
  `complete_time` bigint(13) NOT NULL COMMENT '完成时间',
  `task_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '任务名称',
  `remark` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`, `task_id`) USING BTREE,
  INDEX `ix_novice_task_complete_time`(`complete_time`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '新手任务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_notice
-- ----------------------------
DROP TABLE IF EXISTS `jys_notice`;
CREATE TABLE `jys_notice`  (
  `type` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `parameter_name` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `message` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `remark` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `create_time` bigint(20) NULL DEFAULT NULL,
  `update_time` bigint(20) NULL DEFAULT NULL,
  `ctime` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `utime` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`parameter_name`) USING BTREE,
  UNIQUE INDEX `parameter_name`(`parameter_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_operator_account_flow
-- ----------------------------
DROP TABLE IF EXISTS `jys_operator_account_flow`;
CREATE TABLE `jys_operator_account_flow`  (
  `flow_id` bigint(22) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(22) NOT NULL COMMENT '用户ID',
  `coin` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '代币符号',
  `amount` bigint(22) NOT NULL DEFAULT 0 COMMENT '代币数量',
  `create_time` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `update_time` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `is_record` smallint(6) NULL DEFAULT 0 COMMENT '是否充值',
  `remark` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` bigint(22) NULL DEFAULT NULL COMMENT '创建者',
  `update_by` bigint(22) NULL DEFAULT NULL COMMENT '修改者',
  PRIMARY KEY (`flow_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 35 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_order_info
-- ----------------------------
DROP TABLE IF EXISTS `jys_order_info`;
CREATE TABLE `jys_order_info`  (
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
  `ctime` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `utime` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ix_jys_order_info_buyer_user_id`(`buyer_user_id`) USING BTREE,
  INDEX `ix_jys_order_info_order_id`(`order_id`) USING BTREE,
  INDEX `ix_jys_order_info_placard_id`(`placard_id`) USING BTREE,
  INDEX `ix_jys_order_info_seller_user_id`(`seller_user_id`) USING BTREE,
  INDEX `ix_jys_order_info_coin`(`coin`) USING BTREE,
  CONSTRAINT `jys_order_info_ibfk_1` FOREIGN KEY (`buyer_user_id`) REFERENCES `jys_user_info` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `jys_order_info_ibfk_2` FOREIGN KEY (`placard_id`) REFERENCES `jys_publish_info` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `jys_order_info_ibfk_3` FOREIGN KEY (`seller_user_id`) REFERENCES `jys_user_info` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 23443 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_parameter
-- ----------------------------
DROP TABLE IF EXISTS `jys_parameter`;
CREATE TABLE `jys_parameter`  (
  `type` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `parameter_name` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `val` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `remark` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `create_time` bigint(20) NULL DEFAULT NULL,
  `update_time` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`type`, `parameter_name`) USING BTREE,
  UNIQUE INDEX `parameter_name`(`parameter_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_pay_method
-- ----------------------------
DROP TABLE IF EXISTS `jys_pay_method`;
CREATE TABLE `jys_pay_method`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `pay_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `pay_name` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `number` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `picture` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `is_activate` tinyint(1) NOT NULL,
  `bank_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `bank_branch_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `auth_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `create_time` bigint(20) NULL DEFAULT NULL,
  `update_time` bigint(20) NULL DEFAULT NULL,
  `ctime` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `utime` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ix_jys_pay_method_user_id`(`user_id`) USING BTREE,
  CONSTRAINT `jys_pay_method_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `jys_user_info` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 6322 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_position
-- ----------------------------
DROP TABLE IF EXISTS `jys_position`;
CREATE TABLE `jys_position`  (
  `user_id` bigint(20) NOT NULL,
  `balance` bigint(20) NOT NULL,
  `frozen` bigint(20) NOT NULL,
  `ccy` smallint(6) NOT NULL,
  `id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`, `ccy`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_private_account
-- ----------------------------
DROP TABLE IF EXISTS `jys_private_account`;
CREATE TABLE `jys_private_account`  (
  `user_id` bigint(20) NOT NULL COMMENT '用户id',
  `address` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '地址',
  `address_quota` bigint(20) NOT NULL COMMENT '地址额度',
  `quota` bigint(20) NOT NULL COMMENT '总额度',
  `initial_ratio` int(5) NULL DEFAULT 0 COMMENT '初始解锁比例',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`user_id`, `address`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '私募账户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_private_statistics
-- ----------------------------
DROP TABLE IF EXISTS `jys_private_statistics`;
CREATE TABLE `jys_private_statistics`  (
  `user_id` bigint(20) NOT NULL COMMENT '用户id',
  `quota` bigint(20) NOT NULL COMMENT '总额度',
  `initial_ratio` int(5) NULL DEFAULT 0 COMMENT '初始解锁比例',
  `unlock_ratio` int(5) NULL DEFAULT 0 COMMENT '已月结总解锁比例',
  `unlock_chain_ratio` int(5) NULL DEFAULT 0 COMMENT '已完成总解锁比例',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '私募账户统计表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_publish_info
-- ----------------------------
DROP TABLE IF EXISTS `jys_publish_info`;
CREATE TABLE `jys_publish_info`  (
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
  `ctime` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `utime` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ix_jys_publish_info_coin`(`coin`) USING BTREE,
  INDEX `ix_jys_publish_info_status`(`status`) USING BTREE,
  INDEX `ix_jys_publish_info_user_id`(`user_id`) USING BTREE,
  INDEX `ix_jys_publish_info_placard_id`(`placard_id`) USING BTREE,
  CONSTRAINT `jys_publish_info_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `jys_user_info` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 2699 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_recharge_distill
-- ----------------------------
DROP TABLE IF EXISTS `jys_recharge_distill`;
CREATE TABLE `jys_recharge_distill`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NULL DEFAULT NULL,
  `coin` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `amount` decimal(24, 8) NOT NULL,
  `type` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `out_address` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `in_address` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `txid` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `status` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `fee` decimal(24, 8) NULL DEFAULT NULL,
  `out_base_amount` decimal(24, 8) NULL DEFAULT NULL,
  `failed_return` tinyint(1) NULL DEFAULT NULL,
  `remark` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `create_time` bigint(20) NULL DEFAULT NULL,
  `update_time` bigint(20) NULL DEFAULT NULL,
  `passreject` char(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `ctime` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `utime` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ix_jys_recharge_distill_user_id`(`user_id`) USING BTREE,
  INDEX `ix_jys_recharge_distill_coin`(`coin`) USING BTREE,
  INDEX `ix_jys_recharge_distill_status`(`status`) USING BTREE,
  INDEX `ix_jys_recharge_distill_type`(`type`) USING BTREE,
  INDEX `idx_jys_recharge_distill_in_address`(`in_address`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6542 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_register_give_bc
-- ----------------------------
DROP TABLE IF EXISTS `jys_register_give_bc`;
CREATE TABLE `jys_register_give_bc`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NULL DEFAULT NULL,
  `coin` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `amount` decimal(24, 8) NULL DEFAULT NULL,
  `type` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `create_time` bigint(20) NULL DEFAULT NULL,
  `is_return` tinyint(1) NULL DEFAULT NULL,
  `ctime` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `utime` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `invite_uid` bigint(20) NULL DEFAULT NULL COMMENT '邀请赠送人对应邀请用户id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ix_jys_register_give_bc_coin`(`coin`) USING BTREE,
  INDEX `ix_jys_register_give_bc_user_id`(`user_id`) USING BTREE,
  CONSTRAINT `jys_register_give_bc_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `jys_user_info` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 50895 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_register_give_bc_1
-- ----------------------------
DROP TABLE IF EXISTS `jys_register_give_bc_1`;
CREATE TABLE `jys_register_give_bc_1`  (
  `user_id` double NULL DEFAULT NULL,
  `coin` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `amount` double NULL DEFAULT NULL,
  `create_time` bigint(20) NULL DEFAULT NULL,
  `is_return` bigint(20) NULL DEFAULT NULL,
  `type` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `id` bigint(20) NULL DEFAULT NULL,
  `ctime` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `utime` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间'
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_symbol_collection
-- ----------------------------
DROP TABLE IF EXISTS `jys_symbol_collection`;
CREATE TABLE `jys_symbol_collection`  (
  `symbol_id` bigint(20) NOT NULL COMMENT '币对id',
  `user_id` bigint(20) NOT NULL COMMENT '用户id',
  `collect_status` tinyint(3) NOT NULL COMMENT '收藏状态 0收藏中 1取消收藏',
  `create_time` bigint(20) NULL DEFAULT NULL COMMENT '创建时间 首次收藏时间',
  `update_time` bigint(20) NULL DEFAULT NULL COMMENT '最后更新时间',
  PRIMARY KEY (`symbol_id`, `user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_tarnsfer_account
-- ----------------------------
DROP TABLE IF EXISTS `jys_tarnsfer_account`;
CREATE TABLE `jys_tarnsfer_account`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `coin` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `type` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `num` decimal(24, 8) NOT NULL,
  `create_time` bigint(20) NULL DEFAULT NULL,
  `update_time` bigint(20) NULL DEFAULT NULL,
  `ctime` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `utime` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ix_jys_tarnsfer_account_user_id`(`user_id`) USING BTREE,
  INDEX `ix_jys_tarnsfer_account_coin`(`coin`) USING BTREE,
  INDEX `ix_jys_tarnsfer_account_type`(`type`) USING BTREE,
  CONSTRAINT `jys_tarnsfer_account_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `jys_user_info` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 25777 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_trader
-- ----------------------------
DROP TABLE IF EXISTS `jys_trader`;
CREATE TABLE `jys_trader`  (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NULL DEFAULT NULL,
  `symbol_id` int(11) NULL DEFAULT NULL,
  `trader_type` int(11) NULL DEFAULT NULL,
  `remark` varchar(16) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `create_dt` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP,
  `update_dt` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_user_auth_one
-- ----------------------------
DROP TABLE IF EXISTS `jys_user_auth_one`;
CREATE TABLE `jys_user_auth_one`  (
  `create_time` bigint(20) NULL DEFAULT NULL,
  `update_time` bigint(20) NULL DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `id_type` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `id_card` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `real_name` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `card_front` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `card_reverse` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `card_in_hand` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `check_status` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `remark` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `ctime` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `utime` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `id_card`(`id_card`) USING BTREE,
  INDEX `ix_jys_user_auth_one_check_status`(`check_status`) USING BTREE,
  INDEX `ix_jys_user_auth_one_id_type`(`id_type`) USING BTREE,
  INDEX `ix_jys_user_auth_one_user_id`(`user_id`) USING BTREE,
  CONSTRAINT `jys_user_auth_one_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `jys_user_info` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 25173 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_user_info
-- ----------------------------
DROP TABLE IF EXISTS `jys_user_info`;
CREATE TABLE `jys_user_info`  (
  `create_time` bigint(20) NULL DEFAULT NULL,
  `update_time` bigint(20) NULL DEFAULT NULL,
  `mobile` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `password_hash` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `nickname` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `is_activate` bigint(20) NULL DEFAULT NULL,
  `country` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `area_code` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `auth_level` bigint(20) NULL DEFAULT NULL,
  `api_key_hash` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `secret_key_hash` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `user_type` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `is_trade_password` tinyint(1) NULL DEFAULT NULL,
  `trade_password_hash` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `store_symbol` varchar(600) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `reset` tinyint(1) NULL DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `business_level` smallint(6) NULL DEFAULT NULL,
  `b_user_type` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备份用户类型字段20181212',
  `ctime` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `utime` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `ix_jys_user_info_email`(`email`) USING BTREE,
  UNIQUE INDEX `ix_jys_user_info_mobile`(`mobile`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 166480 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for jys_user_level_up
-- ----------------------------
DROP TABLE IF EXISTS `jys_user_level_up`;
CREATE TABLE `jys_user_level_up`  (
  `user_id` bigint(20) NOT NULL,
  `create_time` bigint(20) NOT NULL,
  `user_type` varchar(15) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `remark` varchar(200) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`, `user_type`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for left_amount
-- ----------------------------
DROP TABLE IF EXISTS `left_amount`;
CREATE TABLE `left_amount`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `address` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `plt_ratio` int(255) NULL DEFAULT NULL,
  `lock_ratio` int(255) NULL DEFAULT NULL,
  `init_lock` int(255) NULL DEFAULT NULL,
  `left_amount` decimal(28, 12) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 908 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for plt_ccyflow
-- ----------------------------
DROP TABLE IF EXISTS `plt_ccyflow`;
CREATE TABLE `plt_ccyflow`  (
  `flow_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `occur_amount` decimal(28, 12) NULL DEFAULT 0.000000000000 COMMENT '发生数额',
  `ccy` int(11) NULL DEFAULT NULL COMMENT '币种ID',
  `coin` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交易币种',
  `summary` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '业务摘要',
  `business_id` bigint(20) NULL DEFAULT NULL COMMENT '业务ID',
  `occur_dt` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发生时间',
  `remark` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`flow_id`) USING BTREE,
  INDEX `idx_ccyflow_bid`(`business_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 661112 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '平台币币交易流水' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for plt_frozen
-- ----------------------------
DROP TABLE IF EXISTS `plt_frozen`;
CREATE TABLE `plt_frozen`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NULL DEFAULT NULL,
  `ccy` int(255) NULL DEFAULT NULL,
  `qty` bigint(20) NULL DEFAULT NULL,
  `remark` varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `date` bigint(20) NULL DEFAULT NULL,
  `frozen` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `TRIGGER_NAME` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `TRIGGER_GROUP` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `BLOB_DATA` blob NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
  INDEX `SCHED_NAME`(`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
  CONSTRAINT `QRTZ_BLOB_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `CALENDAR_NAME` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `CALENDAR` blob NOT NULL,
  PRIMARY KEY (`SCHED_NAME`, `CALENDAR_NAME`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `TRIGGER_NAME` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `TRIGGER_GROUP` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `CRON_EXPRESSION` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `TIME_ZONE_ID` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
  CONSTRAINT `QRTZ_CRON_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `ENTRY_ID` varchar(95) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `TRIGGER_NAME` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `TRIGGER_GROUP` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `INSTANCE_NAME` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `FIRED_TIME` bigint(13) NOT NULL,
  `SCHED_TIME` bigint(13) NOT NULL,
  `PRIORITY` int(11) NOT NULL,
  `STATE` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `JOB_NAME` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `JOB_GROUP` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `IS_NONCONCURRENT` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `REQUESTS_RECOVERY` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`, `ENTRY_ID`) USING BTREE,
  INDEX `IDX_QRTZ_FT_TRIG_INST_NAME`(`SCHED_NAME`, `INSTANCE_NAME`) USING BTREE,
  INDEX `IDX_QRTZ_FT_INST_JOB_REQ_RCVRY`(`SCHED_NAME`, `INSTANCE_NAME`, `REQUESTS_RECOVERY`) USING BTREE,
  INDEX `IDX_QRTZ_FT_J_G`(`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) USING BTREE,
  INDEX `IDX_QRTZ_FT_JG`(`SCHED_NAME`, `JOB_GROUP`) USING BTREE,
  INDEX `IDX_QRTZ_FT_T_G`(`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
  INDEX `IDX_QRTZ_FT_TG`(`SCHED_NAME`, `TRIGGER_GROUP`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `JOB_NAME` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `JOB_GROUP` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `DESCRIPTION` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `JOB_CLASS_NAME` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `IS_DURABLE` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `IS_NONCONCURRENT` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `IS_UPDATE_DATA` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `REQUESTS_RECOVERY` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `JOB_DATA` blob NULL,
  PRIMARY KEY (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) USING BTREE,
  INDEX `IDX_QRTZ_J_REQ_RECOVERY`(`SCHED_NAME`, `REQUESTS_RECOVERY`) USING BTREE,
  INDEX `IDX_QRTZ_J_GRP`(`SCHED_NAME`, `JOB_GROUP`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `LOCK_NAME` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`SCHED_NAME`, `LOCK_NAME`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `TRIGGER_GROUP` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_GROUP`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `INSTANCE_NAME` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `LAST_CHECKIN_TIME` bigint(13) NOT NULL,
  `CHECKIN_INTERVAL` bigint(13) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`, `INSTANCE_NAME`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `TRIGGER_NAME` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `TRIGGER_GROUP` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `REPEAT_COUNT` bigint(7) NOT NULL,
  `REPEAT_INTERVAL` bigint(12) NOT NULL,
  `TIMES_TRIGGERED` bigint(10) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
  CONSTRAINT `QRTZ_SIMPLE_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `TRIGGER_NAME` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `TRIGGER_GROUP` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `STR_PROP_1` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `STR_PROP_2` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `STR_PROP_3` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `INT_PROP_1` int(11) NULL DEFAULT NULL,
  `INT_PROP_2` int(11) NULL DEFAULT NULL,
  `LONG_PROP_1` bigint(20) NULL DEFAULT NULL,
  `LONG_PROP_2` bigint(20) NULL DEFAULT NULL,
  `DEC_PROP_1` decimal(13, 4) NULL DEFAULT NULL,
  `DEC_PROP_2` decimal(13, 4) NULL DEFAULT NULL,
  `BOOL_PROP_1` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `BOOL_PROP_2` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
  CONSTRAINT `QRTZ_SIMPROP_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `TRIGGER_NAME` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `TRIGGER_GROUP` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `JOB_NAME` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `JOB_GROUP` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `DESCRIPTION` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `NEXT_FIRE_TIME` bigint(13) NULL DEFAULT NULL,
  `PREV_FIRE_TIME` bigint(13) NULL DEFAULT NULL,
  `PRIORITY` int(11) NULL DEFAULT NULL,
  `TRIGGER_STATE` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `TRIGGER_TYPE` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `START_TIME` bigint(13) NOT NULL,
  `END_TIME` bigint(13) NULL DEFAULT NULL,
  `CALENDAR_NAME` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `MISFIRE_INSTR` smallint(2) NULL DEFAULT NULL,
  `JOB_DATA` blob NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
  INDEX `IDX_QRTZ_T_J`(`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) USING BTREE,
  INDEX `IDX_QRTZ_T_JG`(`SCHED_NAME`, `JOB_GROUP`) USING BTREE,
  INDEX `IDX_QRTZ_T_C`(`SCHED_NAME`, `CALENDAR_NAME`) USING BTREE,
  INDEX `IDX_QRTZ_T_G`(`SCHED_NAME`, `TRIGGER_GROUP`) USING BTREE,
  INDEX `IDX_QRTZ_T_STATE`(`SCHED_NAME`, `TRIGGER_STATE`) USING BTREE,
  INDEX `IDX_QRTZ_T_N_STATE`(`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`, `TRIGGER_STATE`) USING BTREE,
  INDEX `IDX_QRTZ_T_N_G_STATE`(`SCHED_NAME`, `TRIGGER_GROUP`, `TRIGGER_STATE`) USING BTREE,
  INDEX `IDX_QRTZ_T_NEXT_FIRE_TIME`(`SCHED_NAME`, `NEXT_FIRE_TIME`) USING BTREE,
  INDEX `IDX_QRTZ_T_NFT_ST`(`SCHED_NAME`, `TRIGGER_STATE`, `NEXT_FIRE_TIME`) USING BTREE,
  INDEX `IDX_QRTZ_T_NFT_MISFIRE`(`SCHED_NAME`, `MISFIRE_INSTR`, `NEXT_FIRE_TIME`) USING BTREE,
  INDEX `IDX_QRTZ_T_NFT_ST_MISFIRE`(`SCHED_NAME`, `MISFIRE_INSTR`, `NEXT_FIRE_TIME`, `TRIGGER_STATE`) USING BTREE,
  INDEX `IDX_QRTZ_T_NFT_ST_MISFIRE_GRP`(`SCHED_NAME`, `MISFIRE_INSTR`, `NEXT_FIRE_TIME`, `TRIGGER_GROUP`, `TRIGGER_STATE`) USING BTREE,
  CONSTRAINT `QRTZ_TRIGGERS_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) REFERENCES `qrtz_job_details` (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for statisticdata_allshowinfo
-- ----------------------------
DROP TABLE IF EXISTS `statisticdata_allshowinfo`;
CREATE TABLE `statisticdata_allshowinfo`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` date NULL DEFAULT NULL,
  `create_time` bigint(20) NULL DEFAULT NULL,
  `update_time` bigint(20) NULL DEFAULT NULL,
  `all_user` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `all_money` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `moneyalldata` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `btc` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `eth` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `usdt` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `daycoincoin` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `dayfacoin` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `daygetmoney` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `daygetmoney_pay` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for statisticdata_overnumuser
-- ----------------------------
DROP TABLE IF EXISTS `statisticdata_overnumuser`;
CREATE TABLE `statisticdata_overnumuser`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` bigint(20) NULL DEFAULT NULL,
  `update_time` bigint(20) NULL DEFAULT NULL,
  `coin` int(11) NULL DEFAULT NULL,
  `num` int(11) NOT NULL,
  `cc_free_amount` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `fc_free_amount` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for statisticdata_sumdata
-- ----------------------------
DROP TABLE IF EXISTS `statisticdata_sumdata`;
CREATE TABLE `statisticdata_sumdata`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` date NULL DEFAULT NULL,
  `regist_list` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `sevcoincoin_list` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `sevfacoin_list` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `create_time` bigint(20) NULL DEFAULT NULL,
  `update_time` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for statisticdata_usermoney
-- ----------------------------
DROP TABLE IF EXISTS `statisticdata_usermoney`;
CREATE TABLE `statisticdata_usermoney`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` bigint(20) NULL DEFAULT NULL,
  `update_time` bigint(20) NULL DEFAULT NULL,
  `user` int(11) NULL DEFAULT NULL,
  `freeze` tinyint(1) NOT NULL,
  `all_fund` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `param_key` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'key',
  `param_value` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'value',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态   0：隐藏   1：显示',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `param_key`(`param_key`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统配置信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `parent_id` bigint(20) NULL DEFAULT NULL COMMENT '上级部门ID，一级部门为0',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '部门名称',
  `order_num` int(11) NULL DEFAULT NULL COMMENT '排序',
  `del_flag` tinyint(4) NULL DEFAULT 0 COMMENT '是否删除  -1：已删除  0：正常',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '部门管理' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_dict
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict`;
CREATE TABLE `sys_dict`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '字典名称',
  `type` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '字典类型',
  `code` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '字典码',
  `value` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '字典值',
  `order_num` int(11) NULL DEFAULT 0 COMMENT '排序',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `del_flag` tinyint(4) NULL DEFAULT 0 COMMENT '删除标记  -1：已删除  0：正常',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `type`(`type`, `code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '数据字典表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_log`;
CREATE TABLE `sys_log`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户名',
  `operation` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户操作',
  `method` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '请求方法',
  `params` varchar(5000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '请求参数',
  `time` bigint(20) NOT NULL COMMENT '执行时长(毫秒)',
  `ip` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'IP地址',
  `create_date` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 411 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `parent_id` bigint(20) NULL DEFAULT NULL COMMENT '父菜单ID，一级菜单为0',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '菜单名称',
  `url` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '菜单URL',
  `perms` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '授权(多个用逗号分隔，如：user:list,user:create)',
  `type` int(11) NULL DEFAULT NULL COMMENT '类型   0：目录   1：菜单   2：按钮',
  `icon` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '菜单图标',
  `order_num` int(11) NULL DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 249 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '菜单管理' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_oss
-- ----------------------------
DROP TABLE IF EXISTS `sys_oss`;
CREATE TABLE `sys_oss`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `url` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'URL地址',
  `create_date` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '文件上传' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `role_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '角色名称',
  `remark` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `dept_id` bigint(20) NULL DEFAULT NULL COMMENT '部门ID',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `role_id` bigint(20) NULL DEFAULT NULL COMMENT '角色ID',
  `dept_id` bigint(20) NULL DEFAULT NULL COMMENT '部门ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 54 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色与部门对应关系' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `role_id` bigint(20) NULL DEFAULT NULL COMMENT '角色ID',
  `menu_id` bigint(20) NULL DEFAULT NULL COMMENT '菜单ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1288 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色与菜单对应关系' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '密码',
  `salt` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '盐',
  `email` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `mobile` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `status` tinyint(4) NULL DEFAULT NULL COMMENT '状态  0：禁用   1：正常',
  `dept_id` bigint(20) NULL DEFAULT NULL COMMENT '部门ID',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`user_id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统用户' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NULL DEFAULT NULL COMMENT '用户ID',
  `role_id` bigint(20) NULL DEFAULT NULL COMMENT '角色ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户与角色对应关系' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tem_jys_user_info
-- ----------------------------
DROP TABLE IF EXISTS `tem_jys_user_info`;
CREATE TABLE `tem_jys_user_info`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mobile` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `mobile`(`mobile`) USING BTREE,
  UNIQUE INDEX `email`(`email`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for usermanage_bizdict
-- ----------------------------
DROP TABLE IF EXISTS `usermanage_bizdict`;
CREATE TABLE `usermanage_bizdict`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for usermanage_deletetwoauth
-- ----------------------------
DROP TABLE IF EXISTS `usermanage_deletetwoauth`;
CREATE TABLE `usermanage_deletetwoauth`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NULL DEFAULT NULL,
  `update_time` datetime(6) NULL DEFAULT NULL,
  `user` int(11) NULL DEFAULT NULL,
  `card_front` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `card_reverse` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `card_in_hand` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `check_status` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `remark` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `id_card` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `id_type` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `real_name` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 502 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for usermanage_managerlog
-- ----------------------------
DROP TABLE IF EXISTS `usermanage_managerlog`;
CREATE TABLE `usermanage_managerlog`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NULL DEFAULT NULL,
  `update_time` datetime(6) NULL DEFAULT NULL,
  `type_info` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `target_user` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `user_id_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `usermanage_managerlog_user_id_id_45bd7589_fk_auth_user_id`(`user_id_id`) USING BTREE,
  CONSTRAINT `usermanage_managerlog_ibfk_1` FOREIGN KEY (`user_id_id`) REFERENCES `auth_user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for usermanage_manageuser
-- ----------------------------
DROP TABLE IF EXISTS `usermanage_manageuser`;
CREATE TABLE `usermanage_manageuser`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tel` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `role` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `last_ip` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `command` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `user_id_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_id_id`(`user_id_id`) USING BTREE,
  CONSTRAINT `usermanage_manageuser_ibfk_1` FOREIGN KEY (`user_id_id`) REFERENCES `auth_user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for usermanage_operationlog
-- ----------------------------
DROP TABLE IF EXISTS `usermanage_operationlog`;
CREATE TABLE `usermanage_operationlog`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `operation_info` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作说明',
  `data` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '操作数据',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户id',
  `user_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户名称',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户操作日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for usermanage_platformuserlog
-- ----------------------------
DROP TABLE IF EXISTS `usermanage_platformuserlog`;
CREATE TABLE `usermanage_platformuserlog`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NULL DEFAULT NULL,
  `update_time` datetime(6) NULL DEFAULT NULL,
  `type_info` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `target_user` int(11) NULL DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for usermanage_showimage
-- ----------------------------
DROP TABLE IF EXISTS `usermanage_showimage`;
CREATE TABLE `usermanage_showimage`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `lang` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `biz_type_id` int(11) NOT NULL,
  `device` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `create_time` datetime(6) NULL DEFAULT NULL,
  `update_time` datetime(6) NULL DEFAULT NULL,
  `imagepath` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `url` varchar(3000) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `is_publish` tinyint(1) NOT NULL,
  `article_url` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '跳转链接',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `usermanage_showimage_biz_type_id_55092a4c`(`biz_type_id`) USING BTREE,
  CONSTRAINT `usermanage_showimage_ibfk_1` FOREIGN KEY (`biz_type_id`) REFERENCES `usermanage_bizdict` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 51 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for usermanage_temmanager
-- ----------------------------
DROP TABLE IF EXISTS `usermanage_temmanager`;
CREATE TABLE `usermanage_temmanager`  (
  `username_tem` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `real_password` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`username_tem`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for usermanage_websitecms
-- ----------------------------
DROP TABLE IF EXISTS `usermanage_websitecms`;
CREATE TABLE `usermanage_websitecms`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `update_time` datetime(6) NULL DEFAULT NULL,
  `create_time` datetime(6) NULL DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `sub_title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `content` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `lang` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `state` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `article_type_id` int(11) NULL DEFAULT NULL,
  `code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文章分组',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `usermanage_websitecm_article_id_ee88075b_fk_usermanag`(`article_type_id`) USING BTREE,
  CONSTRAINT `usermanage_websitecms_ibfk_1` FOREIGN KEY (`article_type_id`) REFERENCES `usermanage_bizdict` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 57 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

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
-- Procedure structure for cancel_limit_order
-- ----------------------------
DROP PROCEDURE IF EXISTS `cancel_limit_order`;
delimiter ;;
CREATE PROCEDURE `cancel_limit_order`(IN `in_user_id` BIGINT, IN `in_order_id` BIGINT)
BEGIN
	DECLARE	error_code INT DEFAULT 0;
	DECLARE	has_error INT DEFAULT 0;
	DECLARE	error_msg VARCHAR ( 64 ) DEFAULT 'success';
	DECLARE	sql_code CHAR ( 5 ) DEFAULT '00000';
	DECLARE	sql_msg TEXT;
	DECLARE	CONTINUE HANDLER FOR SQLEXCEPTION BEGIN
			GET DIAGNOSTICS CONDITION 1 sql_code = RETURNED_SQLSTATE,
			sql_msg = MESSAGE_TEXT;
		SET has_error = 1;
	END;
	
	SELECT
		@user_id := user_id,
		@consign_type := consign_type,
		@consign_status := `status`,
		@reference := reference,
		@symbol := symbol,
		@consign_qty := qty,
		@consgin_frozen := frozen,
		@consgin_price := price 
	FROM
		consign 
	WHERE
		consign_id = in_order_id;
	IF FOUND_ROWS() = 0 THEN	
		SET error_msg = 'cannot find consign!';
	ELSE 
		START TRANSACTION;
		Cancel_lable : BEGIN
			IF(@consign_status <> 2) THEN
				SET error_msg = 'consign_status cannot cancel!';
				LEAVE Cancel_lable;
			END IF;
			
			IF(@consign_type NOT in(0,1)) THEN
				SET error_msg = 'consign_status cannot cancel!';
				LEAVE Cancel_lable;
			END IF;
			IF @consign_type = 0 THEN
					UPDATE jys_position SET balance = balance + @consgin_frozen,frozen = frozen - @consgin_frozen WHERE	ccy = @reference AND user_id = in_user_id;
			ELSE 
					UPDATE jys_position SET balance = balance + @consgin_frozen,frozen = frozen - @consgin_frozen WHERE	ccy = @symbol AND user_id = in_user_id;
			END IF;
			
			IF( has_error = 1 ) THEN
				SET error_msg = 'update POSITION IN SQLEXCEPTION!';
				LEAVE Cancel_lable;
			END IF;
			
			IF( ROW_COUNT( ) <> 1 ) THEN
				SET error_msg = 'update POSITION IN no record updated !';
				SET has_error = 1;
				LEAVE Cancel_lable;
			END IF;
			
			UPDATE consign 	SET `status` = 7 	WHERE consign_id = in_order_id;
			IF( has_error = 1 ) THEN
				SET error_msg = 'update consign IN SQLEXCEPTION!';
				LEAVE Cancel_lable;
			END IF;
			
			IF( ROW_COUNT( ) <> 1 ) THEN
				SET error_msg = 'update consign IN no record updated !';
				SET has_error = 1;
				LEAVE Cancel_lable;
			END IF;
		END Cancel_lable;
		IF	( has_error = 1 ) THEN
			ROLLBACK;
		END IF;
		COMMIT;
	END IF;

	
	
	SELECT 	has_error AS error_code,error_msg AS error_msg,	sql_code,	sql_msg;

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

-- ----------------------------
-- Procedure structure for open_marchent
-- ----------------------------
DROP PROCEDURE IF EXISTS `open_marchent`;
delimiter ;;
CREATE PROCEDURE `open_marchent`(IN `in_user_id` BIGINT,
  IN `frozen_amount` DECIMAL (24, 8))
BEGIN
  DECLARE error_code INT DEFAULT 0;
  DECLARE has_error INT DEFAULT 0;
  DECLARE error_msg VARCHAR (64) DEFAULT 'success';
  DECLARE sql_code CHAR (5) DEFAULT '00000';
  DECLARE sql_msg TEXT;
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 sql_code = RETURNED_SQLSTATE,
    sql_msg = MESSAGE_TEXT;
    SET has_error = 1;
  END;
  START TRANSACTION;
  Match_lable :
  BEGIN
    UPDATE
      jys_account_info j
    SET
      j.`freeze_amount` = j.`freeze_amount` + frozen_amount,
      j.`free_amount` = j.`free_amount` - frozen_amount
    WHERE j.`user_id` = in_user_id
      AND j.`coin` = 13
      AND j.`free_amount` >= frozen_amount;
    IF (has_error = 1)
    THEN SET error_msg = 'update JYS_ACCOUNT_INFO IN SQLEXCEPTION!';
    LEAVE Match_lable;
    END IF;
    IF (ROW_COUNT () <> 1)
    THEN SET error_msg = 'update JYS_ACCOUNT_INFO IN no record updated !';
    SET has_error = 1;
    LEAVE Match_lable;
    END IF;
    UPDATE
      jys_user_info j
    SET
      j.business_level = 1
    WHERE j.id = in_user_id
      AND j.`business_level` = 0;
    IF (has_error = 1)
    THEN SET error_msg = 'update JYS_USER_INFO IN SQLEXCEPTION!';
    LEAVE Match_lable;
    END IF;
    IF (ROW_COUNT () <> 1)
    THEN SET error_msg = 'update JYS_USER_INFO IN no record updated !';
    SET has_error = 1;
    LEAVE Match_lable;
    END IF;
  END Match_lable;
  IF (has_error = 1)
  THEN ROLLBACK;
  END IF;
  COMMIT;
  SELECT
    has_error AS error_code,
    error_msg AS error_msg,
    sql_code,
    sql_msg;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
