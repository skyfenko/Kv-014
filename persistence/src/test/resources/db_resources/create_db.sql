-- SCHEMA CREATION (IN DEFAULT DATABASE: DEFAULT->POSTGRES)
DROP SCHEMA IF EXISTS ZOO CASCADE;
CREATE SCHEMA ZOO;

-- TABLES CREATION
-- ************************************************************************************************

-- +++++++++++++++ZONES OBJECTS++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- GEO_ZONES (GLOBAL)---------------------------------------------
CREATE TABLE IF NOT EXISTS ZOO.GEO_ZONES (
  ID   BIGINT PRIMARY KEY NOT NULL,
  NAME VARCHAR(50)         NOT NULL
);
COMMENT ON COLUMN ZOO.GEO_ZONES.ID IS 'GEOGRAPHICAL ZONE ID';
COMMENT ON COLUMN ZOO.GEO_ZONES.NAME IS 'GEOGRAPHICAL ZONE NAME';
--END OF GEO_ZONES------------------------------------------------

-- ZOO_ZONES (LOCAL IN ZOO, MAPPED ON GEOZONES)------------------------------------------------
CREATE TABLE ZOO.ZOO_ZONES (
  ID             BIGINT PRIMARY KEY NOT NULL,
  NAME           VARCHAR(20)         NOT NULL,
  DESCRIPTION    VARCHAR(100)        NOT NULL,
  HOUSE_CAPACITY INTEGER                 NOT NULL,
  GEO_ZONE_ID    BIGINT                 NOT NULL,
  CONSTRAINT FK_GEO_ZONE FOREIGN KEY (GEO_ZONE_ID)
  REFERENCES ZOO.GEO_ZONES (ID)
  ON UPDATE CASCADE ON DELETE CASCADE
);
COMMENT ON TABLE ZOO.ZOO_ZONES IS 'REPRESENTATION OF EXISTING ZONES IN THE ZOO';
COMMENT ON COLUMN ZOO.ZOO_ZONES.ID IS 'ZOO ZONE ID';
COMMENT ON COLUMN ZOO.ZOO_ZONES.NAME IS 'ZOO ZONE NAME';
COMMENT ON COLUMN ZOO.ZOO_ZONES.DESCRIPTION IS 'ZOO ZONE DESCRIPTION';
COMMENT ON COLUMN ZOO.ZOO_ZONES.HOUSE_CAPACITY IS 'HOW MANY HOUSES THIS ZONE CONTAINS';
COMMENT ON COLUMN ZOO.ZOO_ZONES.GEO_ZONE_ID IS 'FOREIGN KEY (BASED ON GEOGRAPHICAL ZONE ID)';
--END OF ZOO_ZONES------------------------------------------------------------------------------
-- +++++++++++++++END OF ZONES OBJECTS+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++SPECIES OBJECTS (WITH TAXONOMICAL HIERARCHY)+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- CLASSES (TAXONOMICAL ONES)-------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS ZOO.CLASSES (
  ID   BIGINT PRIMARY KEY NOT NULL,
  NAME VARCHAR(50)         NOT NULL
);
COMMENT ON TABLE ZOO.CLASSES IS 'REPRESENTATION OF TAXONOMICAL CLASSES, PARENT OF TAXONOMICAL FAMILY';
COMMENT ON COLUMN ZOO.CLASSES.ID IS 'TAXONOMICAL CLASS ID';
COMMENT ON COLUMN ZOO.CLASSES.NAME IS 'TAXONOMICAL CLASS NAME (LATIN?)';
--END OF CLASSES -------------------------------------------------------------------------------------

-- FAMILIES (TAXONOMICAL ONES)-------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS ZOO.FAMILIES (
  ID       BIGINT PRIMARY KEY NOT NULL,
  NAME     VARCHAR(50)         NOT NULL,
  CLASS_ID BIGINT                 NOT NULL,
  CONSTRAINT FK_CLASS_ID FOREIGN KEY (CLASS_ID)
  REFERENCES ZOO.CLASSES (ID)
  ON UPDATE CASCADE ON DELETE CASCADE
);
COMMENT ON TABLE ZOO.FAMILIES IS 'REPRESENTATION OF TAXONOMICAL FAMILIES, PARENT OF TAXONOMICAL SPECIES';
COMMENT ON COLUMN ZOO.FAMILIES.ID IS 'TAXONOMICAL FAMILY ID';
COMMENT ON COLUMN ZOO.FAMILIES.NAME IS 'TAXONOMICAL FAMILY NAME (LATIN?)';
COMMENT ON COLUMN ZOO.FAMILIES.CLASS_ID IS 'FOREIGN KEY (TAXONOMICAL CLASS OF THE FAMILY)';
--END OF FAMILIES -------------------------------------------------------------------------------------

-- SPECIES (TAXONOMICAL ONES)---------------------------------------------------------------
CREATE TABLE IF NOT EXISTS ZOO.SPECIES (
  ID              BIGINT PRIMARY KEY NOT NULL,
  SCIENTIFIC_NAME VARCHAR(50)         NOT NULL,
  COMMON_NAME     VARCHAR(50) DEFAULT NULL,
  FAMILY_ID       BIGINT                 NOT NULL,
  -- UNCOMMENT IF WE NEED IMAGES STORAGE
  -- IMAGE_LINK VARCHAR(100) DEFAULT NULL,
  CONSTRAINT FK_FAMILY_ID FOREIGN KEY (FAMILY_ID)
  REFERENCES ZOO.FAMILIES (ID)
  ON UPDATE CASCADE ON DELETE CASCADE
);
COMMENT ON TABLE ZOO.FAMILIES IS 'REPRESENTATION OF TAXONOMICAL SPECIES';
COMMENT ON COLUMN ZOO.SPECIES.ID IS 'SPECIES ID';
COMMENT ON COLUMN ZOO.SPECIES.SCIENTIFIC_NAME IS 'SCIENTIFIC LATIN NAME';
COMMENT ON COLUMN ZOO.SPECIES.COMMON_NAME IS 'COMMON ENGLISH NAME';
COMMENT ON COLUMN ZOO.SPECIES.FAMILY_ID IS 'FOREIGN KEY (TAXONOMICAL FAMILY OF THE SPECIES)';
--END OF SPECIES ----------------------------------------------------------------------------

-- GEO ZONES MAPPING (MANY-TO-MANY, ZONES <-> SPECIES)---------------------------------------------------------
CREATE TABLE IF NOT EXISTS ZOO.GEO_ZONE_SPECIES_MAPPING (
  GEO_ZONE_ID BIGINT NOT NULL,
  SPECIES_ID  BIGINT NOT NULL,
  CONSTRAINT PK_ZONE_MAPPING PRIMARY KEY (GEO_ZONE_ID, SPECIES_ID),
  CONSTRAINT FK_M_GEO_ZONE_ID FOREIGN KEY (GEO_ZONE_ID)
  REFERENCES ZOO.GEO_ZONES (ID)
  ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT FK_M_SPECIES_ID FOREIGN KEY (SPECIES_ID)
  REFERENCES ZOO.SPECIES (ID)
  ON UPDATE CASCADE ON DELETE CASCADE

);
COMMENT ON TABLE ZOO.GEO_ZONE_SPECIES_MAPPING IS 'REPRESENTATION OF MAPPING (MANY-TO-MANY, ZONES <-> SPECIES)';
COMMENT ON COLUMN ZOO.GEO_ZONE_SPECIES_MAPPING.GEO_ZONE_ID IS 'ID OF GEO ZONE (FROM GEO_ZONES TABLE)';
COMMENT ON COLUMN ZOO.GEO_ZONE_SPECIES_MAPPING.SPECIES_ID IS 'ID OF SPECIES (FROM SPECIES TABLE)';
--END OF GEO ZONES MAPPING -------------------------------------------------------------------------------------
-- +++++++++++++++END OF SPECIES OBJECTS+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++HOUSE OBJECTS+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- HOUSES (CONTAINERS IN ZOO ZONES WHERE ANIMALS ARE PLACED)--------------------------------------------------
CREATE TABLE IF NOT EXISTS ZOO.HOUSES (
  ID           BIGINT PRIMARY KEY NOT NULL,
  ZOO_ZONE_ID  BIGINT                 NOT NULL,
  MAX_CAPACITY INTEGER                 NOT NULL DEFAULT 1,
  CONSTRAINT FK_ZOO_ZONE_ID FOREIGN KEY (ZOO_ZONE_ID)
  REFERENCES ZOO.ZOO_ZONES (ID)
  ON UPDATE CASCADE ON DELETE CASCADE
);
COMMENT ON TABLE ZOO.HOUSES IS 'CONTAINERS IN ZOO ZONES WHERE ANUMALS ARE PLACED';
COMMENT ON COLUMN ZOO.HOUSES.ID IS 'Id of a ZOO zone that a house is positioned in';
COMMENT ON COLUMN ZOO.HOUSES.MAX_CAPACITY IS 'Maximum number of animals that a house can contain';
--END OF HOUSES -----------------------------------------------------------------------------------------------
-- +++++++++++++++END OF HOUSE OBJECTS++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++WAREHOUSE OBJECTS+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- WAREHOUSES (CONTAINS SUPPLIES: MEDICINE, FOOD)--------------------------------------------------
CREATE TABLE IF NOT EXISTS ZOO.WAREHOUSE (
  ID          BIGINT PRIMARY KEY NOT NULL,
  SUPPLY_NAME VARCHAR(50)         NOT NULL,
  AMOUNT      INTEGER                 NOT NULL CHECK (AMOUNT >= 0) DEFAULT 0
);
COMMENT ON TABLE ZOO.WAREHOUSE IS 'SUPPLIES CONTAINER: MEDICINE, FOOD';
COMMENT ON COLUMN ZOO.WAREHOUSE.ID IS 'SUPPLY ID';
COMMENT ON COLUMN ZOO.WAREHOUSE.SUPPLY_NAME IS 'SUPPLY NAME(MEDICINE, FOOD)';
--END OF WAREHOUSE -----------------------------------------------------------------------------------------------
-- +++++++++++++++END OF WAREHOUSE OBJECTS++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++ANIMALS OBJECTS+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- ANIMALS (SPECIFIC ENTITIES, PLACED IN ZOO)-------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS ZOO.ANIMALS (
  ID                BIGINT PRIMARY KEY NOT NULL,
  NICKNAME          VARCHAR(50)                  DEFAULT NULL,
  SPECIES_ID        BIGINT             NOT NULL,
  HOUSE_ID          BIGINT                 NOT NULL,
  BIRTHDAY          DATE                         DEFAULT NULL,
  TEMPERATURE_MIN   INTEGER                 NOT NULL DEFAULT -273,
  TEMPERATURE_MAX   INTEGER                 NOT NULL DEFAULT 100,
  FOOD_CONSUMPTION  INTEGER                 NOT NULL DEFAULT 0,
  ANIMALS_PER_HOUSE INTEGER             NOT NULL,
  CHECK (TEMPERATURE_MAX >= TEMPERATURE_MIN),
  CONSTRAINT FK_SPECIES_ID FOREIGN KEY (SPECIES_ID)
  REFERENCES ZOO.SPECIES (ID)
  ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT FK_HOUSE_ID FOREIGN KEY (HOUSE_ID)
  REFERENCES ZOO.HOUSES (ID)
  ON UPDATE CASCADE ON DELETE CASCADE
);
COMMENT ON TABLE ZOO.ANIMALS IS 'SPECIFIC ENTITIES OF ANIMALS, PLACED IN ZOO';
COMMENT ON COLUMN ZOO.ANIMALS.ID IS 'ANIMAL ID';
COMMENT ON COLUMN ZOO.ANIMALS.NICKNAME IS 'NAME OF ANIMAL, OPTIONAL';
COMMENT ON COLUMN ZOO.ANIMALS.SPECIES_ID IS 'FOREIGN KEY (ID OF TAXONOMICAL SPECIE OF THE ANIMAL->TABLE SPECIES)';
COMMENT ON COLUMN ZOO.ANIMALS.HOUSE_ID IS 'FOREIGN KEY (ID OF HOUSE WHERE IT LIVES->HOUSE TABLE)';
COMMENT ON COLUMN ZOO.ANIMALS.BIRTHDAY IS 'ANIMAL BIRTH DATE. OPTIONAL';
COMMENT ON COLUMN ZOO.ANIMALS.TEMPERATURE_MIN IS 'MINIMUM RECOMMENDED TEMPERATURE FOR LIVING';
COMMENT ON COLUMN ZOO.ANIMALS.TEMPERATURE_MAX IS 'MAXIMUM RECOMMENDED TEMPERATURE FOR LIVING';
COMMENT ON COLUMN ZOO.ANIMALS.FOOD_CONSUMPTION IS 'AMOUNT OF FOOD PER ONE DAY FOR THIS ANIMAL';
COMMENT ON COLUMN ZOO.ANIMALS.ANIMALS_PER_HOUSE IS 'This required value specifies the "density" of this individual';
--END OF ANIMALS -----------------------------------------------------------------------------------------------
-- +++++++++++++++END OF ANIMALS OBJECTS++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++EMPLOYEES OBJECTS++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- EMPLOYEE ROLES (EMPLOYEE, MANAGER, ADMIN ETC)-----------------
CREATE TABLE IF NOT EXISTS ZOO.EMPLOYEE_ROLES (
  ID    BIGINT PRIMARY KEY NOT NULL,
  TITLE VARCHAR(20)         NOT NULL
);
COMMENT ON TABLE ZOO.EMPLOYEE_ROLES IS 'ROLES DESCRIPTION';
COMMENT ON COLUMN ZOO.EMPLOYEE_ROLES.ID IS 'ROLE ID';
COMMENT ON COLUMN ZOO.EMPLOYEE_ROLES.TITLE IS 'EMPLOYEE TITLE (EMPLOYEE, MANAGER, ADMIN ETC)';
--END OF TASK TYPES -------------------------------------------------------------

-- EMPLOYEES (ALL EMPLOYEES)------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS ZOO.EMPLOYEES (
  ID         BIGINT PRIMARY KEY NOT NULL,
  FIRST_NAME VARCHAR(20)         NOT NULL,
  LAST_NAME  VARCHAR(20)         NOT NULL,
  HIRED_DATE TIMESTAMP DEFAULT NULL,
  EMAIL      VARCHAR(50) UNIQUE CHECK (EMAIL LIKE '%@%'),
  PASSWORD   VARCHAR(50)
);
COMMENT ON TABLE ZOO.EMPLOYEES IS 'TASKS ARCHIVE';
COMMENT ON COLUMN ZOO.EMPLOYEES.ID IS 'EMPLOYEE ID';
COMMENT ON COLUMN ZOO.EMPLOYEES.FIRST_NAME IS 'Employee`s FIRST name';
COMMENT ON COLUMN ZOO.EMPLOYEES.LAST_NAME IS 'Employee`s LAST name';
COMMENT ON COLUMN ZOO.EMPLOYEES.HIRED_DATE IS 'The date of an employment. OPTIONAL.';
COMMENT ON COLUMN ZOO.EMPLOYEES.EMAIL IS 'EMPLOYEE EMAIL';
COMMENT ON COLUMN ZOO.EMPLOYEES.PASSWORD IS 'HASH OF EMPLOYEE`S PASSWORD';
--END OF EMPLOYEES -------------------------------------------------------------------------------------

--EMPLOYEES ROLES MAPPING (MANY-TO-MANY, EMPLOYEES <-> ROLES)---------------------------------------------------
CREATE TABLE IF NOT EXISTS ZOO.EMPLOYEE_ROLE_MAPPING (
  EMPLOYEE_ID BIGINT NOT NULL,
  ROLE_ID     BIGINT NOT NULL,
  CONSTRAINT PK_ROLE_MAPPING PRIMARY KEY (EMPLOYEE_ID, ROLE_ID),
  CONSTRAINT FK_EMPLOYEE_ID FOREIGN KEY (EMPLOYEE_ID)
  REFERENCES ZOO.EMPLOYEES (ID)
  ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT FK_ROLE_ID FOREIGN KEY (ROLE_ID)
  REFERENCES ZOO.EMPLOYEE_ROLES (ID)
  ON UPDATE CASCADE ON DELETE CASCADE
);
COMMENT ON TABLE ZOO.EMPLOYEE_ROLE_MAPPING IS 'REPRESENTATION OF MAPPING (MANY-TO-MANY, EMPLOYEES <-> ROLES)';
COMMENT ON COLUMN ZOO.EMPLOYEE_ROLE_MAPPING.EMPLOYEE_ID IS 'EMPLOYEE ID (FROM EMPLOYEE TABLE)';
COMMENT ON COLUMN ZOO.EMPLOYEE_ROLE_MAPPING.ROLE_ID IS 'ROLE ID (FROM EMPLOYEE_ROLES TABLE)';
--END OF EMPLOYEES ROLE MAPPING --------------------------------------------------------------------------------
-- +++++++++++++++END OF EMPLOYEES OBJECTS+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++TASKS OBJECTS+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- TASK TYPES (FEED ANIMALS, CHECK ANIMALS, GIVE MEDICINE ETC.)-----------------
CREATE TABLE IF NOT EXISTS ZOO.TASK_TYPES (
  ID   BIGINT PRIMARY KEY NOT NULL,
  TYPE VARCHAR(50)         NOT NULL
);
COMMENT ON TABLE ZOO.TASK_TYPES IS 'TASK TYPES DESCRIPTION';
COMMENT ON COLUMN ZOO.TASK_TYPES.ID IS 'TASK TYPE ID';
COMMENT ON COLUMN ZOO.TASK_TYPES.TYPE IS 'TASK TYPE (FEED, CHECK, REPORT ETC.)';
--END OF TASK TYPES -------------------------------------------------------------

-- TASK STATUSES (CANCELLED, DONE, FAILED ETC.)-----------------
CREATE TABLE IF NOT EXISTS ZOO.TASK_STATUSES (
  ID   BIGINT PRIMARY KEY NOT NULL,
  TYPE VARCHAR(50)         NOT NULL
);
COMMENT ON TABLE ZOO.TASK_STATUSES IS 'TASK STATUSES DESCRIPTION';
COMMENT ON COLUMN ZOO.TASK_STATUSES.ID IS 'TASK STATUS ID';
COMMENT ON COLUMN ZOO.TASK_STATUSES.TYPE IS 'TASK STATUSES (CANCELLED, DONE, FAILED ETC.)';
--END OF TASK STATUSES -------------------------------------------------------------

-- TASKS (ARCHIVE OF ALL ASSIGNED TASKS ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS ZOO.TASKS (
  ID                     BIGINT PRIMARY KEY NOT NULL,
  TASK_TYPE_ID           BIGINT                 NOT NULL,
  ASSIGNEE_ID            BIGINT                 NOT NULL,
  ASSIGNER_ID            BIGINT                 NOT NULL,
  STARTED_ESTIMATED      TIMESTAMP           NOT NULL,
  ACCOMPLISHED_ESTIMATED TIMESTAMP           NOT NULL,
  STARTED_ACTUAL         TIMESTAMP    DEFAULT NULL,
  ACCOMPLISHED_ACTUAL    TIMESTAMP    DEFAULT NULL,
  ZONE_ID                BIGINT                 NOT NULL,
  STATUS_ID              BIGINT                 NOT NULL,
  TASK_COMMENT           VARCHAR(100) DEFAULT NULL,
  CONSTRAINT FK_ZONE_ID FOREIGN KEY (ZONE_ID)
  REFERENCES ZOO.ZOO_ZONES (ID)
  ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT FK_ASSIGNEE_ID FOREIGN KEY (ASSIGNEE_ID)
  REFERENCES ZOO.EMPLOYEES (ID)
  ON UPDATE CASCADE,
  CONSTRAINT FK_ASSIGNER_ID FOREIGN KEY (ASSIGNER_ID)
  REFERENCES ZOO.EMPLOYEES (ID)
  ON UPDATE CASCADE,
  CONSTRAINT FK_TYPE_ID FOREIGN KEY (TASK_TYPE_ID)
  REFERENCES ZOO.TASK_TYPES (ID)
  ON UPDATE CASCADE,
  CONSTRAINT FK_STATUS_ID FOREIGN KEY (STATUS_ID)
  REFERENCES ZOO.TASK_STATUSES (ID)
  ON UPDATE CASCADE
);
COMMENT ON TABLE ZOO.TASKS IS 'TASKS ARCHIVE';
COMMENT ON COLUMN ZOO.TASKS.ID IS 'TASK ID';
COMMENT ON COLUMN ZOO.TASKS.TASK_TYPE_ID IS 'TASK TYPE ID (FOREIGN KEY->TASK_TYPES TABLE)';
COMMENT ON COLUMN ZOO.TASKS.ASSIGNEE_ID IS 'WHO MUST ACCOMPLISH TASK (FOREIGN KEY->EMPLOYEES TABLE)';
COMMENT ON COLUMN ZOO.TASKS.ASSIGNER_ID IS 'WHO ASSIGNED TASK (FOREIGN KEY->EMPLOYEES TABLE)';
COMMENT ON COLUMN ZOO.TASKS.STARTED_ESTIMATED IS 'WHEN TASK SHOULD NORMALLY START';
COMMENT ON COLUMN ZOO.TASKS.ACCOMPLISHED_ESTIMATED IS 'WHEN TASK SHOULD NORMALLY FINISH';
COMMENT ON COLUMN ZOO.TASKS.STARTED_ACTUAL IS 'WHEN TASK WAS ACTUALLY STARTED (IF WAS)';
COMMENT ON COLUMN ZOO.TASKS.ACCOMPLISHED_ACTUAL IS 'WHEN TASK WAS ACTUALLY FINISHED (IF WAS)';
COMMENT ON COLUMN ZOO.TASKS.ZONE_ID IS 'WHERE THIS TASK IS TAKEN PLACE';
COMMENT ON COLUMN ZOO.TASKS.STATUS_ID IS 'TASK STATUS  ID (FOREIGN KEY->STATUSES TABLE)';
COMMENT ON COLUMN ZOO.TASKS.TASK_COMMENT IS 'TASK COMMENTS';
--END OF TASKS -------------------------------------------------------------------------------------
-- +++++++++++++++END OF TASKS OBJECTS++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- UTILITY CREATION (INDEXES ETC)
-- ************************************************************************************************
CREATE UNIQUE INDEX CLASS_ID_IDX ON ZOO.CLASSES (ID);
CREATE UNIQUE INDEX FAMILY_ID_IDX ON ZOO.FAMILIES (ID);
CREATE INDEX FAMILY_CLASS_ID_IDX ON ZOO.FAMILIES (CLASS_ID);
CREATE UNIQUE INDEX SPECIES_ID_IDX ON ZOO.SPECIES (ID);
CREATE UNIQUE INDEX SPECIE_FAMILY_ID_IDX ON ZOO.SPECIES (ID);
CREATE UNIQUE INDEX ZONE_SPECIES_IDX ON ZOO.GEO_ZONE_SPECIES_MAPPING (GEO_ZONE_ID, SPECIES_ID);
CREATE UNIQUE INDEX HOUSES_ID_IDX ON ZOO.HOUSES (ID);
CREATE INDEX HOUSES_ZONE_ID_IDX ON ZOO.HOUSES (ZOO_ZONE_ID, ID);
CREATE UNIQUE INDEX ANIMALS_ID_IDX ON ZOO.ANIMALS (ID);
CREATE INDEX ANIMALS_SPECIES_ID_IDX ON ZOO.ANIMALS (SPECIES_ID, ID);
CREATE INDEX ANIMALS_HOUSE_ID_IDX ON ZOO.ANIMALS (HOUSE_ID, ID);
CREATE UNIQUE INDEX TASKS_ID_IDX ON ZOO.TASKS (ID);
CREATE INDEX TASKS_STATUS_ID_IDX ON ZOO.TASKS (STATUS_ID);
CREATE INDEX TASKS_TYPE_IDX ON ZOO.TASKS (TASK_TYPE_ID);
CREATE INDEX TASKS_START_ID_IDX ON ZOO.TASKS (STARTED_ACTUAL, STATUS_ID);
CREATE INDEX TASKS_ASSIGNEE_ID_IDX ON ZOO.TASKS (ASSIGNEE_ID, ASSIGNER_ID, TASK_TYPE_ID);
CREATE INDEX TASKS_ASSIGNER_ID_IDX ON ZOO.TASKS (ASSIGNER_ID, ASSIGNEE_ID, TASK_TYPE_ID);
