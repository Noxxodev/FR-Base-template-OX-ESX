CREATE TABLE `jail` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `identifier` VARCHAR(255) NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `jailTime` INT(11) NOT NULL DEFAULT '0',
  `reason` TEXT NOT NULL,
  `jailer` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `banlist` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `identifier` varchar(46) DEFAULT NULL,
  `playerName` varchar(64) NOT NULL,
  `reason` text NOT NULL,
  `banTime` bigint(20) NOT NULL,
  `expireTime` bigint(20) NOT NULL,
  `adminName` varchar(64) NOT NULL,
  `xbl` varchar(64) DEFAULT NULL,
  `discord` varchar(64) DEFAULT NULL,
  `live` varchar(64) DEFAULT NULL,
  `fivem` varchar(64) DEFAULT NULL,
  `char1` varchar(64) DEFAULT NULL,
  `ip` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`)
);

ALTER TABLE `banlist`
	ADD COLUMN `guid` varchar(64) DEFAULT NULL;

CREATE TABLE reports (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    player_name VARCHAR(255) NOT NULL,
    license VARCHAR(255) NOT NULL,
    reason TEXT NOT NULL,
    admin_name VARCHAR(255)
);

CREATE TABLE `account_info` (
  `license` varchar(255) NOT NULL,
  `steam` varchar(255) DEFAULT NULL,
  `xbl` varchar(255) DEFAULT NULL,
  `discord` varchar(255) DEFAULT NULL,
  `live` varchar(255) DEFAULT NULL,
  `fivem` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `ip` varchar(255) DEFAULT NULL,
  `guid` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `account_info`
  ADD PRIMARY KEY (`license`);
COMMIT;