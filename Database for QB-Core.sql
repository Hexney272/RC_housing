ALTER TABLE `players` ADD COLUMN `last_property` VARCHAR(255) DEFAULT NULL;

CREATE TABLE IF NOT EXISTS `houses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(50) DEFAULT NULL,
  `object_id` int(11) DEFAULT NULL,
  `owner` varchar(120) DEFAULT NULL,
  `owner_name` varchar(80) DEFAULT NULL,
  `renter` varchar(120) DEFAULT NULL,
  `renter_name` varchar(80) DEFAULT NULL,
  `name` longtext DEFAULT '',
  `description` longtext DEFAULT NULL,
  `region` varchar(70) DEFAULT NULL,
  `address` varchar(50) DEFAULT NULL,
  `keys` longtext NOT NULL DEFAULT '[]',
  `permissions` longtext DEFAULT '[]',
  `metadata` longtext NOT NULL DEFAULT '[]',
  `sale` longtext DEFAULT '[]',
  `rental` longtext DEFAULT '[]',
  `last_enter` int(11) DEFAULT NULL,
  `creator` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `houses_bills` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `house_id` int(11) NOT NULL,
  `period` varchar(50) NOT NULL DEFAULT '',
  `type` varchar(50) DEFAULT NULL,
  `total` float DEFAULT 0,
  `paid` tinyint(1) DEFAULT 0,
  `details` longtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_period_per_house_type` (`house_id`,`period`,`type`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `houses_furniture` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `house_id` int(11) NOT NULL,
  `position` longtext DEFAULT NULL,
  `model` varchar(70) DEFAULT NULL,
  `stored` int(11) DEFAULT 0,
  `metadata` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `houses_furniture_list` (
  `model` varchar(80) NOT NULL,
  `label` varchar(80) DEFAULT NULL,
  `price` int(11) DEFAULT 0,
  `deliverySize` int(11) DEFAULT 1,
  `tag` varchar(50) DEFAULT NULL,
  `isOutdoor` int(11) DEFAULT 1,
  `isIndoor` int(11) DEFAULT 1,
  `interactableName` varchar(50) DEFAULT NULL,
  `metadata` longtext DEFAULT NULL,
  PRIMARY KEY (`model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;