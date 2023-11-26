CREATE TABLE `binary_default_collation` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary


CREATE TABLE `t1` (
  `id` char(36) NOT NULL,
  `bits` bit(1) DEFAULT NULL,
  `tiny_text` tinytext,
  `binary` binary(1) DEFAULT NULL,
  `varbinary` varbinary(1) DEFAULT NULL,
  `tinyblob` tinyblob,
  `linestring` linestring DEFAULT NULL,
  `polygon` polygon DEFAULT NULL,
  `geometrycollection` geomcollection DEFAULT NULL,
  `multipoint` multipoint DEFAULT NULL,
  `multilinestring` multilinestring DEFAULT NULL,
  `multipolygon` multipolygon DEFAULT NULL,
  `float_literal_default` float DEFAULT '1e19',
  `expr_default` int DEFAULT ((1 + 2)),
  `invisible` varchar(255) DEFAULT NULL /*!80023 INVISIBLE */,
  `column_format_dynamic` varchar(255) /*!50606 COLUMN_FORMAT DYNAMIC */ DEFAULT NULL,
  `column_format_fixed` varchar(255) /*!50606 COLUMN_FORMAT FIXED */ DEFAULT NULL,
  `storage_disk` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci /*!50606 STORAGE DISK */ DEFAULT NULL,
  `storage_memory` varchar(255) /*!50606 STORAGE MEMORY */ DEFAULT NULL,
  `non_negative_float` float DEFAULT NULL,
  `binary_charset` enum('ok','voila') CHARACTER SET binary COLLATE binary DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `non_negative_check` CHECK ((`non_negative_float` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `t2` (
  `id` char(36) NOT NULL,
  `t2_id` char(36) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci