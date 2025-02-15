-- MySQL Script generated by MySQL Workbench
-- mar 28 mar 2017 18:02:39 CEST
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

-- -----------------------------------------------------
-- Schema comics
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Table `story_type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `story_type` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(240) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `country`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `country` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(24) NOT NULL,
  `name` VARCHAR(240) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `publisher`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `publisher` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `country_id` INT NOT NULL,
  `name` VARCHAR(240) NOT NULL,
  `began` DATE NULL COMMENT '	',
  `ended` DATE NULL,
  `notes` TEXT NULL,
  `url` TEXT NULL,
  PRIMARY KEY (`id`),
  INDEX `country_country_id_idx` (`country_id` ASC),
  CONSTRAINT `country_country_id`
    FOREIGN KEY (`country_id`)
    REFERENCES `country` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `indicia_publisher`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `indicia_publisher` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `publisher_id` INT NOT NULL,
  `country_id` INT NOT NULL,
  `name` VARCHAR(240) NOT NULL,
  `began` DATE NULL,
  `ended` DATE NULL,
  `is_surrogate` TINYINT(1) NULL COMMENT 'A Boolean indicating whether the indicia publisher is a company related to the master publisher or an unrelated company who published on behalf of the master publisher.',
  `notes` TEXT NULL,
  `url` TEXT NULL,
  PRIMARY KEY (`id`),
  INDEX `country_country_id_idx` (`country_id` ASC),
  INDEX `publisher_publisher_id_idx` (`publisher_id` ASC),
  CONSTRAINT `country_country_id`
    FOREIGN KEY (`country_id`)
    REFERENCES `country` (`id`)
    ON DELETE RESTRICT ,
  CONSTRAINT `publisher_publisher_id`
    FOREIGN KEY (`publisher_id`)
    REFERENCES `publisher` (`id`)
    ON DELETE RESTRICT)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `language`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `language` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(24) NOT NULL,
  `name` VARCHAR(240) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `series_publication_type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `series_publication_type` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(240) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `series`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `series` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `first_issue_id` INT NULL,
  `last_issue_id` INT NULL,
  `publisher_id` INT NOT NULL,
  `country_id` INT NOT NULL,
  `language_id` INT NOT NULL,
  `series_publication_type_id` INT NULL,
  `name` VARCHAR(240) NOT NULL,
  `notes` TEXT NULL,
  `format` ENUM('Hardcover', 'Comics') NULL COMMENT 'Description of physical format (Hardcover, comics, etc.)',
  `color` TEXT NULL,
  `dimension` TEXT NULL,
  `paper_stock` TEXT NULL,
  `binding` TEXT NULL,
  `publishing_format` TEXT NULL COMMENT 'UNKNOWN FIELD IN THE WIKI',
  PRIMARY KEY (`id`),
  INDEX `issue_first_issue_id_idx` (`first_issue_id` ASC),
  INDEX `issue_last_issue_id_idx` (`last_issue_id` ASC),
  INDEX `country_country_id_idx` (`country_id` ASC),
  INDEX `language_language_id_idx` (`language_id` ASC),
  INDEX `publisher_publisher_id_idx` (`publisher_id` ASC),
  INDEX `series_publication_type_publication_type_idx` (`series_publication_type_id` ASC),
  CONSTRAINT `issue_first_issue_id`
    FOREIGN KEY (`first_issue_id`)
    REFERENCES `issue` (`id`)
    ON DELETE SET NULL,
  CONSTRAINT `issue_last_issue_id`
    FOREIGN KEY (`last_issue_id`)
    REFERENCES `issue` (`id`)
    ON DELETE SET NULL,
  CONSTRAINT `country_country_id`
    FOREIGN KEY (`country_id`)
    REFERENCES `country` (`id`)
    ON DELETE RESTRICT,
  CONSTRAINT `language_language_id`
    FOREIGN KEY (`language_id`)
    REFERENCES `language` (`id`)
    ON DELETE RESTRICT,
  CONSTRAINT `publisher_publisher_id`
    FOREIGN KEY (`publisher_id`)
    REFERENCES `publisher` (`id`)
    ON DELETE RESTRICT,
  CONSTRAINT `series_publication_type_publication_type_id`
    FOREIGN KEY (`series_publication_type_id`)
    REFERENCES `series_publication_type` (`id`)
    ON DELETE SET NULL)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `issue`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `issue` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `series_id` INT NOT NULL,
  `indicia_publisher_id` INT NULL,
  `title` VARCHAR(240) NOT NULL,
  `number` INT NOT NULL COMMENT 'Issue number',
  `publication_date` DATE NULL COMMENT 'May be approximate (circa 1870) or a precise date',
  `page_count` REAL NULL COMMENT 'Is a real number!?!',
  `indicia_frequency` TEXT NULL COMMENT 'Publication frequency (monthly, quarterly, etc.)',
  `notes` TEXT NULL COMMENT 'Freeform notes',
  `isbn` TEXT NULL COMMENT 'UNKNOWN FIELD IN WIKI',
  `barcode` TEXT NULL,
  `on_sale_date` DATE NULL COMMENT 'UNKNOWN FIELD IN WIKI',
  `rating` TEXT NULL COMMENT 'Approval and age rating',
  PRIMARY KEY (`id`),
  INDEX `indicia_publisher_indica_publisher_id_idx` (`indicia_publisher_id` ASC),
  INDEX `series_series_id_idx` (`series_id` ASC),
  CONSTRAINT `indica_publisher_id`
    FOREIGN KEY (`indicia_publisher_id`)
    REFERENCES `indicia_publisher` (`id`)
    ON DELETE SET NULL,
  CONSTRAINT `series_series_id`
    FOREIGN KEY (`series_id`)
    REFERENCES `series` (`id`)
    ON DELETE RESTRICT)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `story`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `story` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `issue_id` INT NOT NULL,
  `type_id` INT NOT NULL,
  `title` VARCHAR(240) NOT NULL COMMENT 'Name of the story',
  `synopsis` TEXT NULL,
  `reprint_note` TEXT NULL,
  `notes` TEXT NULL COMMENT 'Arbitrary notes',
  PRIMARY KEY (`id`),
  INDEX `story_type_type_id_idx` (`type_id` ASC),
  INDEX `issue_issue_id_idx` (`issue_id` ASC),
  CONSTRAINT `story_type_type_id`
    FOREIGN KEY (`type_id`)
    REFERENCES `story_type` (`id`)
    ON DELETE RESTRICT,
  CONSTRAINT `issue_issue_id`
    FOREIGN KEY (`issue_id`)
    REFERENCES `issue` (`id`)
    ON DELETE RESTRICT)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `story_reprint`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `story_reprint` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `origin_id` INT NOT NULL,
  `target_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `story_origin_id_idx` (`origin_id` ASC),
  INDEX `story_target_id_idx` (`target_id` ASC),
  CONSTRAINT `story_origin_id`
    FOREIGN KEY (`origin_id`)
    REFERENCES `story` (`id`)
    ON DELETE CASCADE,
  CONSTRAINT `story_target_id`
    FOREIGN KEY (`target_id`)
    REFERENCES `story` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `issue_reprint`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `issue_reprint` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `origin_id` INT NOT NULL,
  `target_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `issue_origin_id_idx` (`origin_id` ASC),
  INDEX `issue_target_id_idx` (`target_id` ASC),
  CONSTRAINT `issue_origin_id`
    FOREIGN KEY (`origin_id`)
    REFERENCES `issue` (`id`)
    ON DELETE CASCADE,
  CONSTRAINT `issue_target_id`
    FOREIGN KEY (`target_id`)
    REFERENCES `issue` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `brand_group`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `brand_group` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `publisher_id` INT NOT NULL,
  `name` VARCHAR(240) NOT NULL,
  `began` DATE NULL,
  `ended` DATE NULL,
  `notes` TEXT NULL,
  `url` TEXT NULL,
  PRIMARY KEY (`id`),
  INDEX `publisher_publisher_id_idx` (`publisher_id` ASC),
  CONSTRAINT `publisher_publisher_id`
    FOREIGN KEY (`publisher_id`)
    REFERENCES `publisher` (`id`)
    ON DELETE RESTRICT)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `hero`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hero` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(240) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `feature`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `feature` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `story_id` INT NOT NULL,
  `hero_id` INT NOT NULL,
  INDEX `story_story_id_idx` (`story_id` ASC),
  INDEX `hero_hero_id_idx` (`hero_id` ASC),
  PRIMARY KEY (`id`),
  CONSTRAINT `hero_hero_id`
    FOREIGN KEY (`hero_id`)
    REFERENCES `hero` (`id`)
    ON DELETE CASCADE,
  CONSTRAINT `story_story_id`
    FOREIGN KEY (`story_id`)
    REFERENCES `story` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `person`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `person` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `alias_id` INT NULL,
  `firstname` VARCHAR(240) NOT NULL,
  `lastname` VARCHAR(240) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `person_alias_id_idx` (`alias_id` ASC),
  CONSTRAINT `person_alias_id`
    FOREIGN KEY (`alias_id`)
    REFERENCES `person` (`id`)
    ON DELETE SET NULL)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `character`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `character` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `story_id` INT NOT NULL,
  `hero_id` INT NOT NULL,
  INDEX `story_story_id_idx` (`story_id` ASC),
  INDEX `hero_hero_id_idx` (`hero_id` ASC),
  PRIMARY KEY (`id`),
  CONSTRAINT `hero_hero_id`
    FOREIGN KEY (`hero_id`)
    REFERENCES `hero` (`id`)
    ON DELETE CASCADE,
  CONSTRAINT `story_story_id`
    FOREIGN KEY (`story_id`)
    REFERENCES `story` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `genre`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `genre` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(240) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `story_genre`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `story_genre` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `story_id` INT NOT NULL,
  `genre_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `story_story_id_idx` (`story_id` ASC),
  INDEX `genre_genre_id_idx` (`genre_id` ASC),
  CONSTRAINT `story_story_id`
    FOREIGN KEY (`story_id`)
    REFERENCES `story` (`id`)
    ON DELETE CASCADE,
  CONSTRAINT `genre_genre_id`
    FOREIGN KEY (`genre_id`)
    REFERENCES `genre` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `price`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `price` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `issue_id` INT NOT NULL,
  `amount` REAL NOT NULL,
  -- We must put in the ENUM() the list of currencies
  `currency` ENUM('CHF') NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `issue_issue_id_idx` (`issue_id` ASC),
  CONSTRAINT `issue_issue_id`
    FOREIGN KEY (`issue_id`)
    REFERENCES `issue` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `participate`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `participate` (
  `id` INT NOT NULL,
  `person_id` INT NOT NULL,
  `story_id` INT NOT NULL,
  `role` ENUM('script', 'pencil', 'ink', 'color', 'letter', 'editing') NOT NULL,
  `note` TEXT NULL,
  PRIMARY KEY (`id`),
  INDEX `person_person_id_idx` (`person_id` ASC),
  INDEX `story_story_id_idx` (`story_id` ASC),
  CONSTRAINT `person_person_id`
    FOREIGN KEY (`person_id`)
    REFERENCES `person` (`id`)
    ON DELETE CASCADE,
  CONSTRAINT `story_story_id`
    FOREIGN KEY (`story_id`)
    REFERENCES `story` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `editing`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `editing` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `person_id` INT NOT NULL,
  `issue_id` INT NOT NULL,
  `note` TEXT NULL,
  PRIMARY KEY (`id`),
  INDEX `person_person_id_idx` (`person_id` ASC),
  INDEX `issue_issue_id_idx` (`issue_id` ASC),
  CONSTRAINT `person_person_id`
    FOREIGN KEY (`person_id`)
    REFERENCES `person` (`id`)
    ON DELETE CASCADE,
  CONSTRAINT `issue_issue_id`
    FOREIGN KEY (`issue_id`)
    REFERENCES `issue` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB;
