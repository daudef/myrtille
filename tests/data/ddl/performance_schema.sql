CREATE TABLE `accounts` (
  `USER` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `HOST` char(255) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
  `CURRENT_CONNECTIONS` bigint NOT NULL,
  `TOTAL_CONNECTIONS` bigint NOT NULL,
  UNIQUE KEY `ACCOUNT` (`USER`,`HOST`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `binary_log_transaction_compression_stats` (
  `LOG_TYPE` enum('BINARY','RELAY') NOT NULL COMMENT 'The log type to which the transactions were written.',
  `COMPRESSION_TYPE` varchar(64) NOT NULL COMMENT 'The transaction compression algorithm used.',
  `TRANSACTION_COUNTER` bigint unsigned NOT NULL COMMENT 'Number of transactions written to the log',
  `COMPRESSED_BYTES_COUNTER` bigint unsigned NOT NULL COMMENT 'The total number of bytes compressed.',
  `UNCOMPRESSED_BYTES_COUNTER` bigint unsigned NOT NULL COMMENT 'The total number of bytes uncompressed.',
  `COMPRESSION_PERCENTAGE` smallint NOT NULL COMMENT 'The compression ratio as a percentage.',
  `FIRST_TRANSACTION_ID` text COMMENT 'The first transaction written.',
  `FIRST_TRANSACTION_COMPRESSED_BYTES` bigint unsigned NOT NULL COMMENT 'First transaction written compressed bytes.',
  `FIRST_TRANSACTION_UNCOMPRESSED_BYTES` bigint unsigned NOT NULL COMMENT 'First transaction written uncompressed bytes.',
  `FIRST_TRANSACTION_TIMESTAMP` timestamp(6) NULL DEFAULT NULL COMMENT 'When the first transaction was written.',
  `LAST_TRANSACTION_ID` text COMMENT 'The last transaction written.',
  `LAST_TRANSACTION_COMPRESSED_BYTES` bigint unsigned NOT NULL COMMENT 'Last transaction written compressed bytes.',
  `LAST_TRANSACTION_UNCOMPRESSED_BYTES` bigint unsigned NOT NULL COMMENT 'Last transaction written uncompressed bytes.',
  `LAST_TRANSACTION_TIMESTAMP` timestamp(6) NULL DEFAULT NULL COMMENT 'When the last transaction was written.'
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `cond_instances` (
  `NAME` varchar(128) NOT NULL,
  `OBJECT_INSTANCE_BEGIN` bigint unsigned NOT NULL,
  PRIMARY KEY (`OBJECT_INSTANCE_BEGIN`),
  KEY `NAME` (`NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `data_lock_waits` (
  `ENGINE` varchar(32) NOT NULL,
  `REQUESTING_ENGINE_LOCK_ID` varchar(128) NOT NULL,
  `REQUESTING_ENGINE_TRANSACTION_ID` bigint unsigned DEFAULT NULL,
  `REQUESTING_THREAD_ID` bigint unsigned DEFAULT NULL,
  `REQUESTING_EVENT_ID` bigint unsigned DEFAULT NULL,
  `REQUESTING_OBJECT_INSTANCE_BEGIN` bigint unsigned NOT NULL,
  `BLOCKING_ENGINE_LOCK_ID` varchar(128) NOT NULL,
  `BLOCKING_ENGINE_TRANSACTION_ID` bigint unsigned DEFAULT NULL,
  `BLOCKING_THREAD_ID` bigint unsigned DEFAULT NULL,
  `BLOCKING_EVENT_ID` bigint unsigned DEFAULT NULL,
  `BLOCKING_OBJECT_INSTANCE_BEGIN` bigint unsigned NOT NULL,
  KEY `REQUESTING_ENGINE_LOCK_ID` (`REQUESTING_ENGINE_LOCK_ID`,`ENGINE`),
  KEY `BLOCKING_ENGINE_LOCK_ID` (`BLOCKING_ENGINE_LOCK_ID`,`ENGINE`),
  KEY `REQUESTING_ENGINE_TRANSACTION_ID` (`REQUESTING_ENGINE_TRANSACTION_ID`,`ENGINE`),
  KEY `BLOCKING_ENGINE_TRANSACTION_ID` (`BLOCKING_ENGINE_TRANSACTION_ID`,`ENGINE`),
  KEY `REQUESTING_THREAD_ID` (`REQUESTING_THREAD_ID`,`REQUESTING_EVENT_ID`),
  KEY `BLOCKING_THREAD_ID` (`BLOCKING_THREAD_ID`,`BLOCKING_EVENT_ID`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `data_locks` (
  `ENGINE` varchar(32) NOT NULL,
  `ENGINE_LOCK_ID` varchar(128) NOT NULL,
  `ENGINE_TRANSACTION_ID` bigint unsigned DEFAULT NULL,
  `THREAD_ID` bigint unsigned DEFAULT NULL,
  `EVENT_ID` bigint unsigned DEFAULT NULL,
  `OBJECT_SCHEMA` varchar(64) DEFAULT NULL,
  `OBJECT_NAME` varchar(64) DEFAULT NULL,
  `PARTITION_NAME` varchar(64) DEFAULT NULL,
  `SUBPARTITION_NAME` varchar(64) DEFAULT NULL,
  `INDEX_NAME` varchar(64) DEFAULT NULL,
  `OBJECT_INSTANCE_BEGIN` bigint unsigned NOT NULL,
  `LOCK_TYPE` varchar(32) NOT NULL,
  `LOCK_MODE` varchar(32) NOT NULL,
  `LOCK_STATUS` varchar(32) NOT NULL,
  `LOCK_DATA` varchar(8192) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`ENGINE_LOCK_ID`,`ENGINE`),
  KEY `ENGINE_TRANSACTION_ID` (`ENGINE_TRANSACTION_ID`,`ENGINE`),
  KEY `THREAD_ID` (`THREAD_ID`,`EVENT_ID`),
  KEY `OBJECT_SCHEMA` (`OBJECT_SCHEMA`,`OBJECT_NAME`,`PARTITION_NAME`,`SUBPARTITION_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `error_log` (
  `LOGGED` timestamp(6) NOT NULL,
  `THREAD_ID` bigint unsigned DEFAULT NULL,
  `PRIO` enum('System','Error','Warning','Note') NOT NULL,
  `ERROR_CODE` varchar(10) DEFAULT NULL,
  `SUBSYSTEM` varchar(7) DEFAULT NULL,
  `DATA` text NOT NULL,
  PRIMARY KEY (`LOGGED`),
  KEY `THREAD_ID` (`THREAD_ID`),
  KEY `PRIO` (`PRIO`),
  KEY `ERROR_CODE` (`ERROR_CODE`),
  KEY `SUBSYSTEM` (`SUBSYSTEM`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_errors_summary_by_account_by_error` (
  `USER` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `HOST` char(255) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
  `ERROR_NUMBER` int DEFAULT NULL,
  `ERROR_NAME` varchar(64) DEFAULT NULL,
  `SQL_STATE` varchar(5) DEFAULT NULL,
  `SUM_ERROR_RAISED` bigint unsigned NOT NULL,
  `SUM_ERROR_HANDLED` bigint unsigned NOT NULL,
  `FIRST_SEEN` timestamp NULL DEFAULT NULL,
  `LAST_SEEN` timestamp NULL DEFAULT NULL,
  UNIQUE KEY `ACCOUNT` (`USER`,`HOST`,`ERROR_NUMBER`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_errors_summary_by_host_by_error` (
  `HOST` char(255) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
  `ERROR_NUMBER` int DEFAULT NULL,
  `ERROR_NAME` varchar(64) DEFAULT NULL,
  `SQL_STATE` varchar(5) DEFAULT NULL,
  `SUM_ERROR_RAISED` bigint unsigned NOT NULL,
  `SUM_ERROR_HANDLED` bigint unsigned NOT NULL,
  `FIRST_SEEN` timestamp NULL DEFAULT NULL,
  `LAST_SEEN` timestamp NULL DEFAULT NULL,
  UNIQUE KEY `HOST` (`HOST`,`ERROR_NUMBER`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_errors_summary_by_thread_by_error` (
  `THREAD_ID` bigint unsigned NOT NULL,
  `ERROR_NUMBER` int DEFAULT NULL,
  `ERROR_NAME` varchar(64) DEFAULT NULL,
  `SQL_STATE` varchar(5) DEFAULT NULL,
  `SUM_ERROR_RAISED` bigint unsigned NOT NULL,
  `SUM_ERROR_HANDLED` bigint unsigned NOT NULL,
  `FIRST_SEEN` timestamp NULL DEFAULT NULL,
  `LAST_SEEN` timestamp NULL DEFAULT NULL,
  UNIQUE KEY `THREAD_ID` (`THREAD_ID`,`ERROR_NUMBER`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_errors_summary_by_user_by_error` (
  `USER` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `ERROR_NUMBER` int DEFAULT NULL,
  `ERROR_NAME` varchar(64) DEFAULT NULL,
  `SQL_STATE` varchar(5) DEFAULT NULL,
  `SUM_ERROR_RAISED` bigint unsigned NOT NULL,
  `SUM_ERROR_HANDLED` bigint unsigned NOT NULL,
  `FIRST_SEEN` timestamp NULL DEFAULT NULL,
  `LAST_SEEN` timestamp NULL DEFAULT NULL,
  UNIQUE KEY `USER` (`USER`,`ERROR_NUMBER`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_errors_summary_global_by_error` (
  `ERROR_NUMBER` int DEFAULT NULL,
  `ERROR_NAME` varchar(64) DEFAULT NULL,
  `SQL_STATE` varchar(5) DEFAULT NULL,
  `SUM_ERROR_RAISED` bigint unsigned NOT NULL,
  `SUM_ERROR_HANDLED` bigint unsigned NOT NULL,
  `FIRST_SEEN` timestamp NULL DEFAULT NULL,
  `LAST_SEEN` timestamp NULL DEFAULT NULL,
  UNIQUE KEY `ERROR_NUMBER` (`ERROR_NUMBER`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_stages_current` (
  `THREAD_ID` bigint unsigned NOT NULL,
  `EVENT_ID` bigint unsigned NOT NULL,
  `END_EVENT_ID` bigint unsigned DEFAULT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `SOURCE` varchar(64) DEFAULT NULL,
  `TIMER_START` bigint unsigned DEFAULT NULL,
  `TIMER_END` bigint unsigned DEFAULT NULL,
  `TIMER_WAIT` bigint unsigned DEFAULT NULL,
  `WORK_COMPLETED` bigint unsigned DEFAULT NULL,
  `WORK_ESTIMATED` bigint unsigned DEFAULT NULL,
  `NESTING_EVENT_ID` bigint unsigned DEFAULT NULL,
  `NESTING_EVENT_TYPE` enum('TRANSACTION','STATEMENT','STAGE','WAIT') DEFAULT NULL,
  PRIMARY KEY (`THREAD_ID`,`EVENT_ID`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_stages_history` (
  `THREAD_ID` bigint unsigned NOT NULL,
  `EVENT_ID` bigint unsigned NOT NULL,
  `END_EVENT_ID` bigint unsigned DEFAULT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `SOURCE` varchar(64) DEFAULT NULL,
  `TIMER_START` bigint unsigned DEFAULT NULL,
  `TIMER_END` bigint unsigned DEFAULT NULL,
  `TIMER_WAIT` bigint unsigned DEFAULT NULL,
  `WORK_COMPLETED` bigint unsigned DEFAULT NULL,
  `WORK_ESTIMATED` bigint unsigned DEFAULT NULL,
  `NESTING_EVENT_ID` bigint unsigned DEFAULT NULL,
  `NESTING_EVENT_TYPE` enum('TRANSACTION','STATEMENT','STAGE','WAIT') DEFAULT NULL,
  PRIMARY KEY (`THREAD_ID`,`EVENT_ID`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_stages_history_long` (
  `THREAD_ID` bigint unsigned NOT NULL,
  `EVENT_ID` bigint unsigned NOT NULL,
  `END_EVENT_ID` bigint unsigned DEFAULT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `SOURCE` varchar(64) DEFAULT NULL,
  `TIMER_START` bigint unsigned DEFAULT NULL,
  `TIMER_END` bigint unsigned DEFAULT NULL,
  `TIMER_WAIT` bigint unsigned DEFAULT NULL,
  `WORK_COMPLETED` bigint unsigned DEFAULT NULL,
  `WORK_ESTIMATED` bigint unsigned DEFAULT NULL,
  `NESTING_EVENT_ID` bigint unsigned DEFAULT NULL,
  `NESTING_EVENT_TYPE` enum('TRANSACTION','STATEMENT','STAGE','WAIT') DEFAULT NULL
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_stages_summary_by_account_by_event_name` (
  `USER` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `HOST` char(255) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  UNIQUE KEY `ACCOUNT` (`USER`,`HOST`,`EVENT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_stages_summary_by_host_by_event_name` (
  `HOST` char(255) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  UNIQUE KEY `HOST` (`HOST`,`EVENT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_stages_summary_by_thread_by_event_name` (
  `THREAD_ID` bigint unsigned NOT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  PRIMARY KEY (`THREAD_ID`,`EVENT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_stages_summary_by_user_by_event_name` (
  `USER` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  UNIQUE KEY `USER` (`USER`,`EVENT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_stages_summary_global_by_event_name` (
  `EVENT_NAME` varchar(128) NOT NULL,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  PRIMARY KEY (`EVENT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_statements_current` (
  `THREAD_ID` bigint unsigned NOT NULL,
  `EVENT_ID` bigint unsigned NOT NULL,
  `END_EVENT_ID` bigint unsigned DEFAULT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `SOURCE` varchar(64) DEFAULT NULL,
  `TIMER_START` bigint unsigned DEFAULT NULL,
  `TIMER_END` bigint unsigned DEFAULT NULL,
  `TIMER_WAIT` bigint unsigned DEFAULT NULL,
  `LOCK_TIME` bigint unsigned NOT NULL,
  `SQL_TEXT` longtext,
  `DIGEST` varchar(64) DEFAULT NULL,
  `DIGEST_TEXT` longtext,
  `CURRENT_SCHEMA` varchar(64) DEFAULT NULL,
  `OBJECT_TYPE` varchar(64) DEFAULT NULL,
  `OBJECT_SCHEMA` varchar(64) DEFAULT NULL,
  `OBJECT_NAME` varchar(64) DEFAULT NULL,
  `OBJECT_INSTANCE_BEGIN` bigint unsigned DEFAULT NULL,
  `MYSQL_ERRNO` int DEFAULT NULL,
  `RETURNED_SQLSTATE` varchar(5) DEFAULT NULL,
  `MESSAGE_TEXT` varchar(128) DEFAULT NULL,
  `ERRORS` bigint unsigned NOT NULL,
  `WARNINGS` bigint unsigned NOT NULL,
  `ROWS_AFFECTED` bigint unsigned NOT NULL,
  `ROWS_SENT` bigint unsigned NOT NULL,
  `ROWS_EXAMINED` bigint unsigned NOT NULL,
  `CREATED_TMP_DISK_TABLES` bigint unsigned NOT NULL,
  `CREATED_TMP_TABLES` bigint unsigned NOT NULL,
  `SELECT_FULL_JOIN` bigint unsigned NOT NULL,
  `SELECT_FULL_RANGE_JOIN` bigint unsigned NOT NULL,
  `SELECT_RANGE` bigint unsigned NOT NULL,
  `SELECT_RANGE_CHECK` bigint unsigned NOT NULL,
  `SELECT_SCAN` bigint unsigned NOT NULL,
  `SORT_MERGE_PASSES` bigint unsigned NOT NULL,
  `SORT_RANGE` bigint unsigned NOT NULL,
  `SORT_ROWS` bigint unsigned NOT NULL,
  `SORT_SCAN` bigint unsigned NOT NULL,
  `NO_INDEX_USED` bigint unsigned NOT NULL,
  `NO_GOOD_INDEX_USED` bigint unsigned NOT NULL,
  `NESTING_EVENT_ID` bigint unsigned DEFAULT NULL,
  `NESTING_EVENT_TYPE` enum('TRANSACTION','STATEMENT','STAGE','WAIT') DEFAULT NULL,
  `NESTING_EVENT_LEVEL` int DEFAULT NULL,
  `STATEMENT_ID` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`THREAD_ID`,`EVENT_ID`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_statements_histogram_by_digest` (
  `SCHEMA_NAME` varchar(64) DEFAULT NULL,
  `DIGEST` varchar(64) DEFAULT NULL,
  `BUCKET_NUMBER` int unsigned NOT NULL,
  `BUCKET_TIMER_LOW` bigint unsigned NOT NULL,
  `BUCKET_TIMER_HIGH` bigint unsigned NOT NULL,
  `COUNT_BUCKET` bigint unsigned NOT NULL,
  `COUNT_BUCKET_AND_LOWER` bigint unsigned NOT NULL,
  `BUCKET_QUANTILE` double NOT NULL,
  UNIQUE KEY `SCHEMA_NAME` (`SCHEMA_NAME`,`DIGEST`,`BUCKET_NUMBER`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_statements_histogram_global` (
  `BUCKET_NUMBER` int unsigned NOT NULL,
  `BUCKET_TIMER_LOW` bigint unsigned NOT NULL,
  `BUCKET_TIMER_HIGH` bigint unsigned NOT NULL,
  `COUNT_BUCKET` bigint unsigned NOT NULL,
  `COUNT_BUCKET_AND_LOWER` bigint unsigned NOT NULL,
  `BUCKET_QUANTILE` double NOT NULL,
  PRIMARY KEY (`BUCKET_NUMBER`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_statements_history` (
  `THREAD_ID` bigint unsigned NOT NULL,
  `EVENT_ID` bigint unsigned NOT NULL,
  `END_EVENT_ID` bigint unsigned DEFAULT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `SOURCE` varchar(64) DEFAULT NULL,
  `TIMER_START` bigint unsigned DEFAULT NULL,
  `TIMER_END` bigint unsigned DEFAULT NULL,
  `TIMER_WAIT` bigint unsigned DEFAULT NULL,
  `LOCK_TIME` bigint unsigned NOT NULL,
  `SQL_TEXT` longtext,
  `DIGEST` varchar(64) DEFAULT NULL,
  `DIGEST_TEXT` longtext,
  `CURRENT_SCHEMA` varchar(64) DEFAULT NULL,
  `OBJECT_TYPE` varchar(64) DEFAULT NULL,
  `OBJECT_SCHEMA` varchar(64) DEFAULT NULL,
  `OBJECT_NAME` varchar(64) DEFAULT NULL,
  `OBJECT_INSTANCE_BEGIN` bigint unsigned DEFAULT NULL,
  `MYSQL_ERRNO` int DEFAULT NULL,
  `RETURNED_SQLSTATE` varchar(5) DEFAULT NULL,
  `MESSAGE_TEXT` varchar(128) DEFAULT NULL,
  `ERRORS` bigint unsigned NOT NULL,
  `WARNINGS` bigint unsigned NOT NULL,
  `ROWS_AFFECTED` bigint unsigned NOT NULL,
  `ROWS_SENT` bigint unsigned NOT NULL,
  `ROWS_EXAMINED` bigint unsigned NOT NULL,
  `CREATED_TMP_DISK_TABLES` bigint unsigned NOT NULL,
  `CREATED_TMP_TABLES` bigint unsigned NOT NULL,
  `SELECT_FULL_JOIN` bigint unsigned NOT NULL,
  `SELECT_FULL_RANGE_JOIN` bigint unsigned NOT NULL,
  `SELECT_RANGE` bigint unsigned NOT NULL,
  `SELECT_RANGE_CHECK` bigint unsigned NOT NULL,
  `SELECT_SCAN` bigint unsigned NOT NULL,
  `SORT_MERGE_PASSES` bigint unsigned NOT NULL,
  `SORT_RANGE` bigint unsigned NOT NULL,
  `SORT_ROWS` bigint unsigned NOT NULL,
  `SORT_SCAN` bigint unsigned NOT NULL,
  `NO_INDEX_USED` bigint unsigned NOT NULL,
  `NO_GOOD_INDEX_USED` bigint unsigned NOT NULL,
  `NESTING_EVENT_ID` bigint unsigned DEFAULT NULL,
  `NESTING_EVENT_TYPE` enum('TRANSACTION','STATEMENT','STAGE','WAIT') DEFAULT NULL,
  `NESTING_EVENT_LEVEL` int DEFAULT NULL,
  `STATEMENT_ID` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`THREAD_ID`,`EVENT_ID`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_statements_history_long` (
  `THREAD_ID` bigint unsigned NOT NULL,
  `EVENT_ID` bigint unsigned NOT NULL,
  `END_EVENT_ID` bigint unsigned DEFAULT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `SOURCE` varchar(64) DEFAULT NULL,
  `TIMER_START` bigint unsigned DEFAULT NULL,
  `TIMER_END` bigint unsigned DEFAULT NULL,
  `TIMER_WAIT` bigint unsigned DEFAULT NULL,
  `LOCK_TIME` bigint unsigned NOT NULL,
  `SQL_TEXT` longtext,
  `DIGEST` varchar(64) DEFAULT NULL,
  `DIGEST_TEXT` longtext,
  `CURRENT_SCHEMA` varchar(64) DEFAULT NULL,
  `OBJECT_TYPE` varchar(64) DEFAULT NULL,
  `OBJECT_SCHEMA` varchar(64) DEFAULT NULL,
  `OBJECT_NAME` varchar(64) DEFAULT NULL,
  `OBJECT_INSTANCE_BEGIN` bigint unsigned DEFAULT NULL,
  `MYSQL_ERRNO` int DEFAULT NULL,
  `RETURNED_SQLSTATE` varchar(5) DEFAULT NULL,
  `MESSAGE_TEXT` varchar(128) DEFAULT NULL,
  `ERRORS` bigint unsigned NOT NULL,
  `WARNINGS` bigint unsigned NOT NULL,
  `ROWS_AFFECTED` bigint unsigned NOT NULL,
  `ROWS_SENT` bigint unsigned NOT NULL,
  `ROWS_EXAMINED` bigint unsigned NOT NULL,
  `CREATED_TMP_DISK_TABLES` bigint unsigned NOT NULL,
  `CREATED_TMP_TABLES` bigint unsigned NOT NULL,
  `SELECT_FULL_JOIN` bigint unsigned NOT NULL,
  `SELECT_FULL_RANGE_JOIN` bigint unsigned NOT NULL,
  `SELECT_RANGE` bigint unsigned NOT NULL,
  `SELECT_RANGE_CHECK` bigint unsigned NOT NULL,
  `SELECT_SCAN` bigint unsigned NOT NULL,
  `SORT_MERGE_PASSES` bigint unsigned NOT NULL,
  `SORT_RANGE` bigint unsigned NOT NULL,
  `SORT_ROWS` bigint unsigned NOT NULL,
  `SORT_SCAN` bigint unsigned NOT NULL,
  `NO_INDEX_USED` bigint unsigned NOT NULL,
  `NO_GOOD_INDEX_USED` bigint unsigned NOT NULL,
  `NESTING_EVENT_ID` bigint unsigned DEFAULT NULL,
  `NESTING_EVENT_TYPE` enum('TRANSACTION','STATEMENT','STAGE','WAIT') DEFAULT NULL,
  `NESTING_EVENT_LEVEL` int DEFAULT NULL,
  `STATEMENT_ID` bigint unsigned DEFAULT NULL
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_statements_summary_by_account_by_event_name` (
  `USER` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `HOST` char(255) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  `SUM_LOCK_TIME` bigint unsigned NOT NULL,
  `SUM_ERRORS` bigint unsigned NOT NULL,
  `SUM_WARNINGS` bigint unsigned NOT NULL,
  `SUM_ROWS_AFFECTED` bigint unsigned NOT NULL,
  `SUM_ROWS_SENT` bigint unsigned NOT NULL,
  `SUM_ROWS_EXAMINED` bigint unsigned NOT NULL,
  `SUM_CREATED_TMP_DISK_TABLES` bigint unsigned NOT NULL,
  `SUM_CREATED_TMP_TABLES` bigint unsigned NOT NULL,
  `SUM_SELECT_FULL_JOIN` bigint unsigned NOT NULL,
  `SUM_SELECT_FULL_RANGE_JOIN` bigint unsigned NOT NULL,
  `SUM_SELECT_RANGE` bigint unsigned NOT NULL,
  `SUM_SELECT_RANGE_CHECK` bigint unsigned NOT NULL,
  `SUM_SELECT_SCAN` bigint unsigned NOT NULL,
  `SUM_SORT_MERGE_PASSES` bigint unsigned NOT NULL,
  `SUM_SORT_RANGE` bigint unsigned NOT NULL,
  `SUM_SORT_ROWS` bigint unsigned NOT NULL,
  `SUM_SORT_SCAN` bigint unsigned NOT NULL,
  `SUM_NO_INDEX_USED` bigint unsigned NOT NULL,
  `SUM_NO_GOOD_INDEX_USED` bigint unsigned NOT NULL,
  UNIQUE KEY `ACCOUNT` (`USER`,`HOST`,`EVENT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_statements_summary_by_digest` (
  `SCHEMA_NAME` varchar(64) DEFAULT NULL,
  `DIGEST` varchar(64) DEFAULT NULL,
  `DIGEST_TEXT` longtext,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  `SUM_LOCK_TIME` bigint unsigned NOT NULL,
  `SUM_ERRORS` bigint unsigned NOT NULL,
  `SUM_WARNINGS` bigint unsigned NOT NULL,
  `SUM_ROWS_AFFECTED` bigint unsigned NOT NULL,
  `SUM_ROWS_SENT` bigint unsigned NOT NULL,
  `SUM_ROWS_EXAMINED` bigint unsigned NOT NULL,
  `SUM_CREATED_TMP_DISK_TABLES` bigint unsigned NOT NULL,
  `SUM_CREATED_TMP_TABLES` bigint unsigned NOT NULL,
  `SUM_SELECT_FULL_JOIN` bigint unsigned NOT NULL,
  `SUM_SELECT_FULL_RANGE_JOIN` bigint unsigned NOT NULL,
  `SUM_SELECT_RANGE` bigint unsigned NOT NULL,
  `SUM_SELECT_RANGE_CHECK` bigint unsigned NOT NULL,
  `SUM_SELECT_SCAN` bigint unsigned NOT NULL,
  `SUM_SORT_MERGE_PASSES` bigint unsigned NOT NULL,
  `SUM_SORT_RANGE` bigint unsigned NOT NULL,
  `SUM_SORT_ROWS` bigint unsigned NOT NULL,
  `SUM_SORT_SCAN` bigint unsigned NOT NULL,
  `SUM_NO_INDEX_USED` bigint unsigned NOT NULL,
  `SUM_NO_GOOD_INDEX_USED` bigint unsigned NOT NULL,
  `FIRST_SEEN` timestamp(6) NOT NULL,
  `LAST_SEEN` timestamp(6) NOT NULL,
  `QUANTILE_95` bigint unsigned NOT NULL,
  `QUANTILE_99` bigint unsigned NOT NULL,
  `QUANTILE_999` bigint unsigned NOT NULL,
  `QUERY_SAMPLE_TEXT` longtext,
  `QUERY_SAMPLE_SEEN` timestamp(6) NOT NULL,
  `QUERY_SAMPLE_TIMER_WAIT` bigint unsigned NOT NULL,
  UNIQUE KEY `SCHEMA_NAME` (`SCHEMA_NAME`,`DIGEST`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_statements_summary_by_host_by_event_name` (
  `HOST` char(255) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  `SUM_LOCK_TIME` bigint unsigned NOT NULL,
  `SUM_ERRORS` bigint unsigned NOT NULL,
  `SUM_WARNINGS` bigint unsigned NOT NULL,
  `SUM_ROWS_AFFECTED` bigint unsigned NOT NULL,
  `SUM_ROWS_SENT` bigint unsigned NOT NULL,
  `SUM_ROWS_EXAMINED` bigint unsigned NOT NULL,
  `SUM_CREATED_TMP_DISK_TABLES` bigint unsigned NOT NULL,
  `SUM_CREATED_TMP_TABLES` bigint unsigned NOT NULL,
  `SUM_SELECT_FULL_JOIN` bigint unsigned NOT NULL,
  `SUM_SELECT_FULL_RANGE_JOIN` bigint unsigned NOT NULL,
  `SUM_SELECT_RANGE` bigint unsigned NOT NULL,
  `SUM_SELECT_RANGE_CHECK` bigint unsigned NOT NULL,
  `SUM_SELECT_SCAN` bigint unsigned NOT NULL,
  `SUM_SORT_MERGE_PASSES` bigint unsigned NOT NULL,
  `SUM_SORT_RANGE` bigint unsigned NOT NULL,
  `SUM_SORT_ROWS` bigint unsigned NOT NULL,
  `SUM_SORT_SCAN` bigint unsigned NOT NULL,
  `SUM_NO_INDEX_USED` bigint unsigned NOT NULL,
  `SUM_NO_GOOD_INDEX_USED` bigint unsigned NOT NULL,
  UNIQUE KEY `HOST` (`HOST`,`EVENT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_statements_summary_by_program` (
  `OBJECT_TYPE` enum('EVENT','FUNCTION','PROCEDURE','TABLE','TRIGGER') NOT NULL,
  `OBJECT_SCHEMA` varchar(64) NOT NULL,
  `OBJECT_NAME` varchar(64) NOT NULL,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  `COUNT_STATEMENTS` bigint unsigned NOT NULL,
  `SUM_STATEMENTS_WAIT` bigint unsigned NOT NULL,
  `MIN_STATEMENTS_WAIT` bigint unsigned NOT NULL,
  `AVG_STATEMENTS_WAIT` bigint unsigned NOT NULL,
  `MAX_STATEMENTS_WAIT` bigint unsigned NOT NULL,
  `SUM_LOCK_TIME` bigint unsigned NOT NULL,
  `SUM_ERRORS` bigint unsigned NOT NULL,
  `SUM_WARNINGS` bigint unsigned NOT NULL,
  `SUM_ROWS_AFFECTED` bigint unsigned NOT NULL,
  `SUM_ROWS_SENT` bigint unsigned NOT NULL,
  `SUM_ROWS_EXAMINED` bigint unsigned NOT NULL,
  `SUM_CREATED_TMP_DISK_TABLES` bigint unsigned NOT NULL,
  `SUM_CREATED_TMP_TABLES` bigint unsigned NOT NULL,
  `SUM_SELECT_FULL_JOIN` bigint unsigned NOT NULL,
  `SUM_SELECT_FULL_RANGE_JOIN` bigint unsigned NOT NULL,
  `SUM_SELECT_RANGE` bigint unsigned NOT NULL,
  `SUM_SELECT_RANGE_CHECK` bigint unsigned NOT NULL,
  `SUM_SELECT_SCAN` bigint unsigned NOT NULL,
  `SUM_SORT_MERGE_PASSES` bigint unsigned NOT NULL,
  `SUM_SORT_RANGE` bigint unsigned NOT NULL,
  `SUM_SORT_ROWS` bigint unsigned NOT NULL,
  `SUM_SORT_SCAN` bigint unsigned NOT NULL,
  `SUM_NO_INDEX_USED` bigint unsigned NOT NULL,
  `SUM_NO_GOOD_INDEX_USED` bigint unsigned NOT NULL,
  PRIMARY KEY (`OBJECT_TYPE`,`OBJECT_SCHEMA`,`OBJECT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_statements_summary_by_thread_by_event_name` (
  `THREAD_ID` bigint unsigned NOT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  `SUM_LOCK_TIME` bigint unsigned NOT NULL,
  `SUM_ERRORS` bigint unsigned NOT NULL,
  `SUM_WARNINGS` bigint unsigned NOT NULL,
  `SUM_ROWS_AFFECTED` bigint unsigned NOT NULL,
  `SUM_ROWS_SENT` bigint unsigned NOT NULL,
  `SUM_ROWS_EXAMINED` bigint unsigned NOT NULL,
  `SUM_CREATED_TMP_DISK_TABLES` bigint unsigned NOT NULL,
  `SUM_CREATED_TMP_TABLES` bigint unsigned NOT NULL,
  `SUM_SELECT_FULL_JOIN` bigint unsigned NOT NULL,
  `SUM_SELECT_FULL_RANGE_JOIN` bigint unsigned NOT NULL,
  `SUM_SELECT_RANGE` bigint unsigned NOT NULL,
  `SUM_SELECT_RANGE_CHECK` bigint unsigned NOT NULL,
  `SUM_SELECT_SCAN` bigint unsigned NOT NULL,
  `SUM_SORT_MERGE_PASSES` bigint unsigned NOT NULL,
  `SUM_SORT_RANGE` bigint unsigned NOT NULL,
  `SUM_SORT_ROWS` bigint unsigned NOT NULL,
  `SUM_SORT_SCAN` bigint unsigned NOT NULL,
  `SUM_NO_INDEX_USED` bigint unsigned NOT NULL,
  `SUM_NO_GOOD_INDEX_USED` bigint unsigned NOT NULL,
  PRIMARY KEY (`THREAD_ID`,`EVENT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_statements_summary_by_user_by_event_name` (
  `USER` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  `SUM_LOCK_TIME` bigint unsigned NOT NULL,
  `SUM_ERRORS` bigint unsigned NOT NULL,
  `SUM_WARNINGS` bigint unsigned NOT NULL,
  `SUM_ROWS_AFFECTED` bigint unsigned NOT NULL,
  `SUM_ROWS_SENT` bigint unsigned NOT NULL,
  `SUM_ROWS_EXAMINED` bigint unsigned NOT NULL,
  `SUM_CREATED_TMP_DISK_TABLES` bigint unsigned NOT NULL,
  `SUM_CREATED_TMP_TABLES` bigint unsigned NOT NULL,
  `SUM_SELECT_FULL_JOIN` bigint unsigned NOT NULL,
  `SUM_SELECT_FULL_RANGE_JOIN` bigint unsigned NOT NULL,
  `SUM_SELECT_RANGE` bigint unsigned NOT NULL,
  `SUM_SELECT_RANGE_CHECK` bigint unsigned NOT NULL,
  `SUM_SELECT_SCAN` bigint unsigned NOT NULL,
  `SUM_SORT_MERGE_PASSES` bigint unsigned NOT NULL,
  `SUM_SORT_RANGE` bigint unsigned NOT NULL,
  `SUM_SORT_ROWS` bigint unsigned NOT NULL,
  `SUM_SORT_SCAN` bigint unsigned NOT NULL,
  `SUM_NO_INDEX_USED` bigint unsigned NOT NULL,
  `SUM_NO_GOOD_INDEX_USED` bigint unsigned NOT NULL,
  UNIQUE KEY `USER` (`USER`,`EVENT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_statements_summary_global_by_event_name` (
  `EVENT_NAME` varchar(128) NOT NULL,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  `SUM_LOCK_TIME` bigint unsigned NOT NULL,
  `SUM_ERRORS` bigint unsigned NOT NULL,
  `SUM_WARNINGS` bigint unsigned NOT NULL,
  `SUM_ROWS_AFFECTED` bigint unsigned NOT NULL,
  `SUM_ROWS_SENT` bigint unsigned NOT NULL,
  `SUM_ROWS_EXAMINED` bigint unsigned NOT NULL,
  `SUM_CREATED_TMP_DISK_TABLES` bigint unsigned NOT NULL,
  `SUM_CREATED_TMP_TABLES` bigint unsigned NOT NULL,
  `SUM_SELECT_FULL_JOIN` bigint unsigned NOT NULL,
  `SUM_SELECT_FULL_RANGE_JOIN` bigint unsigned NOT NULL,
  `SUM_SELECT_RANGE` bigint unsigned NOT NULL,
  `SUM_SELECT_RANGE_CHECK` bigint unsigned NOT NULL,
  `SUM_SELECT_SCAN` bigint unsigned NOT NULL,
  `SUM_SORT_MERGE_PASSES` bigint unsigned NOT NULL,
  `SUM_SORT_RANGE` bigint unsigned NOT NULL,
  `SUM_SORT_ROWS` bigint unsigned NOT NULL,
  `SUM_SORT_SCAN` bigint unsigned NOT NULL,
  `SUM_NO_INDEX_USED` bigint unsigned NOT NULL,
  `SUM_NO_GOOD_INDEX_USED` bigint unsigned NOT NULL,
  PRIMARY KEY (`EVENT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_transactions_current` (
  `THREAD_ID` bigint unsigned NOT NULL,
  `EVENT_ID` bigint unsigned NOT NULL,
  `END_EVENT_ID` bigint unsigned DEFAULT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `STATE` enum('ACTIVE','COMMITTED','ROLLED BACK') DEFAULT NULL,
  `TRX_ID` bigint unsigned DEFAULT NULL,
  `GTID` varchar(64) DEFAULT NULL,
  `XID_FORMAT_ID` int DEFAULT NULL,
  `XID_GTRID` varchar(130) DEFAULT NULL,
  `XID_BQUAL` varchar(130) DEFAULT NULL,
  `XA_STATE` varchar(64) DEFAULT NULL,
  `SOURCE` varchar(64) DEFAULT NULL,
  `TIMER_START` bigint unsigned DEFAULT NULL,
  `TIMER_END` bigint unsigned DEFAULT NULL,
  `TIMER_WAIT` bigint unsigned DEFAULT NULL,
  `ACCESS_MODE` enum('READ ONLY','READ WRITE') DEFAULT NULL,
  `ISOLATION_LEVEL` varchar(64) DEFAULT NULL,
  `AUTOCOMMIT` enum('YES','NO') NOT NULL,
  `NUMBER_OF_SAVEPOINTS` bigint unsigned DEFAULT NULL,
  `NUMBER_OF_ROLLBACK_TO_SAVEPOINT` bigint unsigned DEFAULT NULL,
  `NUMBER_OF_RELEASE_SAVEPOINT` bigint unsigned DEFAULT NULL,
  `OBJECT_INSTANCE_BEGIN` bigint unsigned DEFAULT NULL,
  `NESTING_EVENT_ID` bigint unsigned DEFAULT NULL,
  `NESTING_EVENT_TYPE` enum('TRANSACTION','STATEMENT','STAGE','WAIT') DEFAULT NULL,
  PRIMARY KEY (`THREAD_ID`,`EVENT_ID`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_transactions_history` (
  `THREAD_ID` bigint unsigned NOT NULL,
  `EVENT_ID` bigint unsigned NOT NULL,
  `END_EVENT_ID` bigint unsigned DEFAULT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `STATE` enum('ACTIVE','COMMITTED','ROLLED BACK') DEFAULT NULL,
  `TRX_ID` bigint unsigned DEFAULT NULL,
  `GTID` varchar(64) DEFAULT NULL,
  `XID_FORMAT_ID` int DEFAULT NULL,
  `XID_GTRID` varchar(130) DEFAULT NULL,
  `XID_BQUAL` varchar(130) DEFAULT NULL,
  `XA_STATE` varchar(64) DEFAULT NULL,
  `SOURCE` varchar(64) DEFAULT NULL,
  `TIMER_START` bigint unsigned DEFAULT NULL,
  `TIMER_END` bigint unsigned DEFAULT NULL,
  `TIMER_WAIT` bigint unsigned DEFAULT NULL,
  `ACCESS_MODE` enum('READ ONLY','READ WRITE') DEFAULT NULL,
  `ISOLATION_LEVEL` varchar(64) DEFAULT NULL,
  `AUTOCOMMIT` enum('YES','NO') NOT NULL,
  `NUMBER_OF_SAVEPOINTS` bigint unsigned DEFAULT NULL,
  `NUMBER_OF_ROLLBACK_TO_SAVEPOINT` bigint unsigned DEFAULT NULL,
  `NUMBER_OF_RELEASE_SAVEPOINT` bigint unsigned DEFAULT NULL,
  `OBJECT_INSTANCE_BEGIN` bigint unsigned DEFAULT NULL,
  `NESTING_EVENT_ID` bigint unsigned DEFAULT NULL,
  `NESTING_EVENT_TYPE` enum('TRANSACTION','STATEMENT','STAGE','WAIT') DEFAULT NULL,
  PRIMARY KEY (`THREAD_ID`,`EVENT_ID`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_transactions_history_long` (
  `THREAD_ID` bigint unsigned NOT NULL,
  `EVENT_ID` bigint unsigned NOT NULL,
  `END_EVENT_ID` bigint unsigned DEFAULT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `STATE` enum('ACTIVE','COMMITTED','ROLLED BACK') DEFAULT NULL,
  `TRX_ID` bigint unsigned DEFAULT NULL,
  `GTID` varchar(64) DEFAULT NULL,
  `XID_FORMAT_ID` int DEFAULT NULL,
  `XID_GTRID` varchar(130) DEFAULT NULL,
  `XID_BQUAL` varchar(130) DEFAULT NULL,
  `XA_STATE` varchar(64) DEFAULT NULL,
  `SOURCE` varchar(64) DEFAULT NULL,
  `TIMER_START` bigint unsigned DEFAULT NULL,
  `TIMER_END` bigint unsigned DEFAULT NULL,
  `TIMER_WAIT` bigint unsigned DEFAULT NULL,
  `ACCESS_MODE` enum('READ ONLY','READ WRITE') DEFAULT NULL,
  `ISOLATION_LEVEL` varchar(64) DEFAULT NULL,
  `AUTOCOMMIT` enum('YES','NO') NOT NULL,
  `NUMBER_OF_SAVEPOINTS` bigint unsigned DEFAULT NULL,
  `NUMBER_OF_ROLLBACK_TO_SAVEPOINT` bigint unsigned DEFAULT NULL,
  `NUMBER_OF_RELEASE_SAVEPOINT` bigint unsigned DEFAULT NULL,
  `OBJECT_INSTANCE_BEGIN` bigint unsigned DEFAULT NULL,
  `NESTING_EVENT_ID` bigint unsigned DEFAULT NULL,
  `NESTING_EVENT_TYPE` enum('TRANSACTION','STATEMENT','STAGE','WAIT') DEFAULT NULL
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_transactions_summary_by_account_by_event_name` (
  `USER` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `HOST` char(255) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  `COUNT_READ_WRITE` bigint unsigned NOT NULL,
  `SUM_TIMER_READ_WRITE` bigint unsigned NOT NULL,
  `MIN_TIMER_READ_WRITE` bigint unsigned NOT NULL,
  `AVG_TIMER_READ_WRITE` bigint unsigned NOT NULL,
  `MAX_TIMER_READ_WRITE` bigint unsigned NOT NULL,
  `COUNT_READ_ONLY` bigint unsigned NOT NULL,
  `SUM_TIMER_READ_ONLY` bigint unsigned NOT NULL,
  `MIN_TIMER_READ_ONLY` bigint unsigned NOT NULL,
  `AVG_TIMER_READ_ONLY` bigint unsigned NOT NULL,
  `MAX_TIMER_READ_ONLY` bigint unsigned NOT NULL,
  UNIQUE KEY `ACCOUNT` (`USER`,`HOST`,`EVENT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_transactions_summary_by_host_by_event_name` (
  `HOST` char(255) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  `COUNT_READ_WRITE` bigint unsigned NOT NULL,
  `SUM_TIMER_READ_WRITE` bigint unsigned NOT NULL,
  `MIN_TIMER_READ_WRITE` bigint unsigned NOT NULL,
  `AVG_TIMER_READ_WRITE` bigint unsigned NOT NULL,
  `MAX_TIMER_READ_WRITE` bigint unsigned NOT NULL,
  `COUNT_READ_ONLY` bigint unsigned NOT NULL,
  `SUM_TIMER_READ_ONLY` bigint unsigned NOT NULL,
  `MIN_TIMER_READ_ONLY` bigint unsigned NOT NULL,
  `AVG_TIMER_READ_ONLY` bigint unsigned NOT NULL,
  `MAX_TIMER_READ_ONLY` bigint unsigned NOT NULL,
  UNIQUE KEY `HOST` (`HOST`,`EVENT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_transactions_summary_by_thread_by_event_name` (
  `THREAD_ID` bigint unsigned NOT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  `COUNT_READ_WRITE` bigint unsigned NOT NULL,
  `SUM_TIMER_READ_WRITE` bigint unsigned NOT NULL,
  `MIN_TIMER_READ_WRITE` bigint unsigned NOT NULL,
  `AVG_TIMER_READ_WRITE` bigint unsigned NOT NULL,
  `MAX_TIMER_READ_WRITE` bigint unsigned NOT NULL,
  `COUNT_READ_ONLY` bigint unsigned NOT NULL,
  `SUM_TIMER_READ_ONLY` bigint unsigned NOT NULL,
  `MIN_TIMER_READ_ONLY` bigint unsigned NOT NULL,
  `AVG_TIMER_READ_ONLY` bigint unsigned NOT NULL,
  `MAX_TIMER_READ_ONLY` bigint unsigned NOT NULL,
  PRIMARY KEY (`THREAD_ID`,`EVENT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_transactions_summary_by_user_by_event_name` (
  `USER` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  `COUNT_READ_WRITE` bigint unsigned NOT NULL,
  `SUM_TIMER_READ_WRITE` bigint unsigned NOT NULL,
  `MIN_TIMER_READ_WRITE` bigint unsigned NOT NULL,
  `AVG_TIMER_READ_WRITE` bigint unsigned NOT NULL,
  `MAX_TIMER_READ_WRITE` bigint unsigned NOT NULL,
  `COUNT_READ_ONLY` bigint unsigned NOT NULL,
  `SUM_TIMER_READ_ONLY` bigint unsigned NOT NULL,
  `MIN_TIMER_READ_ONLY` bigint unsigned NOT NULL,
  `AVG_TIMER_READ_ONLY` bigint unsigned NOT NULL,
  `MAX_TIMER_READ_ONLY` bigint unsigned NOT NULL,
  UNIQUE KEY `USER` (`USER`,`EVENT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_transactions_summary_global_by_event_name` (
  `EVENT_NAME` varchar(128) NOT NULL,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  `COUNT_READ_WRITE` bigint unsigned NOT NULL,
  `SUM_TIMER_READ_WRITE` bigint unsigned NOT NULL,
  `MIN_TIMER_READ_WRITE` bigint unsigned NOT NULL,
  `AVG_TIMER_READ_WRITE` bigint unsigned NOT NULL,
  `MAX_TIMER_READ_WRITE` bigint unsigned NOT NULL,
  `COUNT_READ_ONLY` bigint unsigned NOT NULL,
  `SUM_TIMER_READ_ONLY` bigint unsigned NOT NULL,
  `MIN_TIMER_READ_ONLY` bigint unsigned NOT NULL,
  `AVG_TIMER_READ_ONLY` bigint unsigned NOT NULL,
  `MAX_TIMER_READ_ONLY` bigint unsigned NOT NULL,
  PRIMARY KEY (`EVENT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_waits_current` (
  `THREAD_ID` bigint unsigned NOT NULL,
  `EVENT_ID` bigint unsigned NOT NULL,
  `END_EVENT_ID` bigint unsigned DEFAULT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `SOURCE` varchar(64) DEFAULT NULL,
  `TIMER_START` bigint unsigned DEFAULT NULL,
  `TIMER_END` bigint unsigned DEFAULT NULL,
  `TIMER_WAIT` bigint unsigned DEFAULT NULL,
  `SPINS` int unsigned DEFAULT NULL,
  `OBJECT_SCHEMA` varchar(64) DEFAULT NULL,
  `OBJECT_NAME` varchar(512) DEFAULT NULL,
  `INDEX_NAME` varchar(64) DEFAULT NULL,
  `OBJECT_TYPE` varchar(64) DEFAULT NULL,
  `OBJECT_INSTANCE_BEGIN` bigint unsigned NOT NULL,
  `NESTING_EVENT_ID` bigint unsigned DEFAULT NULL,
  `NESTING_EVENT_TYPE` enum('TRANSACTION','STATEMENT','STAGE','WAIT') DEFAULT NULL,
  `OPERATION` varchar(32) NOT NULL,
  `NUMBER_OF_BYTES` bigint DEFAULT NULL,
  `FLAGS` int unsigned DEFAULT NULL,
  PRIMARY KEY (`THREAD_ID`,`EVENT_ID`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_waits_history` (
  `THREAD_ID` bigint unsigned NOT NULL,
  `EVENT_ID` bigint unsigned NOT NULL,
  `END_EVENT_ID` bigint unsigned DEFAULT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `SOURCE` varchar(64) DEFAULT NULL,
  `TIMER_START` bigint unsigned DEFAULT NULL,
  `TIMER_END` bigint unsigned DEFAULT NULL,
  `TIMER_WAIT` bigint unsigned DEFAULT NULL,
  `SPINS` int unsigned DEFAULT NULL,
  `OBJECT_SCHEMA` varchar(64) DEFAULT NULL,
  `OBJECT_NAME` varchar(512) DEFAULT NULL,
  `INDEX_NAME` varchar(64) DEFAULT NULL,
  `OBJECT_TYPE` varchar(64) DEFAULT NULL,
  `OBJECT_INSTANCE_BEGIN` bigint unsigned NOT NULL,
  `NESTING_EVENT_ID` bigint unsigned DEFAULT NULL,
  `NESTING_EVENT_TYPE` enum('TRANSACTION','STATEMENT','STAGE','WAIT') DEFAULT NULL,
  `OPERATION` varchar(32) NOT NULL,
  `NUMBER_OF_BYTES` bigint DEFAULT NULL,
  `FLAGS` int unsigned DEFAULT NULL,
  PRIMARY KEY (`THREAD_ID`,`EVENT_ID`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_waits_history_long` (
  `THREAD_ID` bigint unsigned NOT NULL,
  `EVENT_ID` bigint unsigned NOT NULL,
  `END_EVENT_ID` bigint unsigned DEFAULT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `SOURCE` varchar(64) DEFAULT NULL,
  `TIMER_START` bigint unsigned DEFAULT NULL,
  `TIMER_END` bigint unsigned DEFAULT NULL,
  `TIMER_WAIT` bigint unsigned DEFAULT NULL,
  `SPINS` int unsigned DEFAULT NULL,
  `OBJECT_SCHEMA` varchar(64) DEFAULT NULL,
  `OBJECT_NAME` varchar(512) DEFAULT NULL,
  `INDEX_NAME` varchar(64) DEFAULT NULL,
  `OBJECT_TYPE` varchar(64) DEFAULT NULL,
  `OBJECT_INSTANCE_BEGIN` bigint unsigned NOT NULL,
  `NESTING_EVENT_ID` bigint unsigned DEFAULT NULL,
  `NESTING_EVENT_TYPE` enum('TRANSACTION','STATEMENT','STAGE','WAIT') DEFAULT NULL,
  `OPERATION` varchar(32) NOT NULL,
  `NUMBER_OF_BYTES` bigint DEFAULT NULL,
  `FLAGS` int unsigned DEFAULT NULL
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_waits_summary_by_account_by_event_name` (
  `USER` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `HOST` char(255) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  UNIQUE KEY `ACCOUNT` (`USER`,`HOST`,`EVENT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_waits_summary_by_host_by_event_name` (
  `HOST` char(255) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  UNIQUE KEY `HOST` (`HOST`,`EVENT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_waits_summary_by_instance` (
  `EVENT_NAME` varchar(128) NOT NULL,
  `OBJECT_INSTANCE_BEGIN` bigint unsigned NOT NULL,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  PRIMARY KEY (`OBJECT_INSTANCE_BEGIN`),
  KEY `EVENT_NAME` (`EVENT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_waits_summary_by_thread_by_event_name` (
  `THREAD_ID` bigint unsigned NOT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  PRIMARY KEY (`THREAD_ID`,`EVENT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_waits_summary_by_user_by_event_name` (
  `USER` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  UNIQUE KEY `USER` (`USER`,`EVENT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `events_waits_summary_global_by_event_name` (
  `EVENT_NAME` varchar(128) NOT NULL,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  PRIMARY KEY (`EVENT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `file_instances` (
  `FILE_NAME` varchar(512) NOT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `OPEN_COUNT` int unsigned NOT NULL,
  PRIMARY KEY (`FILE_NAME`),
  KEY `EVENT_NAME` (`EVENT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `file_summary_by_event_name` (
  `EVENT_NAME` varchar(128) NOT NULL,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  `COUNT_READ` bigint unsigned NOT NULL,
  `SUM_TIMER_READ` bigint unsigned NOT NULL,
  `MIN_TIMER_READ` bigint unsigned NOT NULL,
  `AVG_TIMER_READ` bigint unsigned NOT NULL,
  `MAX_TIMER_READ` bigint unsigned NOT NULL,
  `SUM_NUMBER_OF_BYTES_READ` bigint NOT NULL,
  `COUNT_WRITE` bigint unsigned NOT NULL,
  `SUM_TIMER_WRITE` bigint unsigned NOT NULL,
  `MIN_TIMER_WRITE` bigint unsigned NOT NULL,
  `AVG_TIMER_WRITE` bigint unsigned NOT NULL,
  `MAX_TIMER_WRITE` bigint unsigned NOT NULL,
  `SUM_NUMBER_OF_BYTES_WRITE` bigint NOT NULL,
  `COUNT_MISC` bigint unsigned NOT NULL,
  `SUM_TIMER_MISC` bigint unsigned NOT NULL,
  `MIN_TIMER_MISC` bigint unsigned NOT NULL,
  `AVG_TIMER_MISC` bigint unsigned NOT NULL,
  `MAX_TIMER_MISC` bigint unsigned NOT NULL,
  PRIMARY KEY (`EVENT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `file_summary_by_instance` (
  `FILE_NAME` varchar(512) NOT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `OBJECT_INSTANCE_BEGIN` bigint unsigned NOT NULL,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  `COUNT_READ` bigint unsigned NOT NULL,
  `SUM_TIMER_READ` bigint unsigned NOT NULL,
  `MIN_TIMER_READ` bigint unsigned NOT NULL,
  `AVG_TIMER_READ` bigint unsigned NOT NULL,
  `MAX_TIMER_READ` bigint unsigned NOT NULL,
  `SUM_NUMBER_OF_BYTES_READ` bigint NOT NULL,
  `COUNT_WRITE` bigint unsigned NOT NULL,
  `SUM_TIMER_WRITE` bigint unsigned NOT NULL,
  `MIN_TIMER_WRITE` bigint unsigned NOT NULL,
  `AVG_TIMER_WRITE` bigint unsigned NOT NULL,
  `MAX_TIMER_WRITE` bigint unsigned NOT NULL,
  `SUM_NUMBER_OF_BYTES_WRITE` bigint NOT NULL,
  `COUNT_MISC` bigint unsigned NOT NULL,
  `SUM_TIMER_MISC` bigint unsigned NOT NULL,
  `MIN_TIMER_MISC` bigint unsigned NOT NULL,
  `AVG_TIMER_MISC` bigint unsigned NOT NULL,
  `MAX_TIMER_MISC` bigint unsigned NOT NULL,
  PRIMARY KEY (`OBJECT_INSTANCE_BEGIN`),
  KEY `FILE_NAME` (`FILE_NAME`),
  KEY `EVENT_NAME` (`EVENT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `global_status` (
  `VARIABLE_NAME` varchar(64) NOT NULL,
  `VARIABLE_VALUE` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`VARIABLE_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `global_variables` (
  `VARIABLE_NAME` varchar(64) NOT NULL,
  `VARIABLE_VALUE` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`VARIABLE_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `host_cache` (
  `IP` varchar(64) NOT NULL,
  `HOST` varchar(255) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
  `HOST_VALIDATED` enum('YES','NO') NOT NULL,
  `SUM_CONNECT_ERRORS` bigint NOT NULL,
  `COUNT_HOST_BLOCKED_ERRORS` bigint NOT NULL,
  `COUNT_NAMEINFO_TRANSIENT_ERRORS` bigint NOT NULL,
  `COUNT_NAMEINFO_PERMANENT_ERRORS` bigint NOT NULL,
  `COUNT_FORMAT_ERRORS` bigint NOT NULL,
  `COUNT_ADDRINFO_TRANSIENT_ERRORS` bigint NOT NULL,
  `COUNT_ADDRINFO_PERMANENT_ERRORS` bigint NOT NULL,
  `COUNT_FCRDNS_ERRORS` bigint NOT NULL,
  `COUNT_HOST_ACL_ERRORS` bigint NOT NULL,
  `COUNT_NO_AUTH_PLUGIN_ERRORS` bigint NOT NULL,
  `COUNT_AUTH_PLUGIN_ERRORS` bigint NOT NULL,
  `COUNT_HANDSHAKE_ERRORS` bigint NOT NULL,
  `COUNT_PROXY_USER_ERRORS` bigint NOT NULL,
  `COUNT_PROXY_USER_ACL_ERRORS` bigint NOT NULL,
  `COUNT_AUTHENTICATION_ERRORS` bigint NOT NULL,
  `COUNT_SSL_ERRORS` bigint NOT NULL,
  `COUNT_MAX_USER_CONNECTIONS_ERRORS` bigint NOT NULL,
  `COUNT_MAX_USER_CONNECTIONS_PER_HOUR_ERRORS` bigint NOT NULL,
  `COUNT_DEFAULT_DATABASE_ERRORS` bigint NOT NULL,
  `COUNT_INIT_CONNECT_ERRORS` bigint NOT NULL,
  `COUNT_LOCAL_ERRORS` bigint NOT NULL,
  `COUNT_UNKNOWN_ERRORS` bigint NOT NULL,
  `FIRST_SEEN` timestamp NOT NULL,
  `LAST_SEEN` timestamp NOT NULL,
  `FIRST_ERROR_SEEN` timestamp NULL DEFAULT NULL,
  `LAST_ERROR_SEEN` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`IP`),
  KEY `HOST` (`HOST`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `hosts` (
  `HOST` char(255) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
  `CURRENT_CONNECTIONS` bigint NOT NULL,
  `TOTAL_CONNECTIONS` bigint NOT NULL,
  UNIQUE KEY `HOST` (`HOST`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `keyring_component_status` (
  `STATUS_KEY` varchar(256) NOT NULL,
  `STATUS_VALUE` varchar(1024) NOT NULL
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `keyring_keys` (
  `KEY_ID` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `KEY_OWNER` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `BACKEND_KEY_ID` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin


CREATE TABLE `log_status` (
  `SERVER_UUID` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `LOCAL` json NOT NULL,
  `REPLICATION` json NOT NULL,
  `STORAGE_ENGINES` json NOT NULL
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `memory_summary_by_account_by_event_name` (
  `USER` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `HOST` char(255) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `COUNT_ALLOC` bigint unsigned NOT NULL,
  `COUNT_FREE` bigint unsigned NOT NULL,
  `SUM_NUMBER_OF_BYTES_ALLOC` bigint unsigned NOT NULL,
  `SUM_NUMBER_OF_BYTES_FREE` bigint unsigned NOT NULL,
  `LOW_COUNT_USED` bigint NOT NULL,
  `CURRENT_COUNT_USED` bigint NOT NULL,
  `HIGH_COUNT_USED` bigint NOT NULL,
  `LOW_NUMBER_OF_BYTES_USED` bigint NOT NULL,
  `CURRENT_NUMBER_OF_BYTES_USED` bigint NOT NULL,
  `HIGH_NUMBER_OF_BYTES_USED` bigint NOT NULL,
  UNIQUE KEY `ACCOUNT` (`USER`,`HOST`,`EVENT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `memory_summary_by_host_by_event_name` (
  `HOST` char(255) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `COUNT_ALLOC` bigint unsigned NOT NULL,
  `COUNT_FREE` bigint unsigned NOT NULL,
  `SUM_NUMBER_OF_BYTES_ALLOC` bigint unsigned NOT NULL,
  `SUM_NUMBER_OF_BYTES_FREE` bigint unsigned NOT NULL,
  `LOW_COUNT_USED` bigint NOT NULL,
  `CURRENT_COUNT_USED` bigint NOT NULL,
  `HIGH_COUNT_USED` bigint NOT NULL,
  `LOW_NUMBER_OF_BYTES_USED` bigint NOT NULL,
  `CURRENT_NUMBER_OF_BYTES_USED` bigint NOT NULL,
  `HIGH_NUMBER_OF_BYTES_USED` bigint NOT NULL,
  UNIQUE KEY `HOST` (`HOST`,`EVENT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `memory_summary_by_thread_by_event_name` (
  `THREAD_ID` bigint unsigned NOT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `COUNT_ALLOC` bigint unsigned NOT NULL,
  `COUNT_FREE` bigint unsigned NOT NULL,
  `SUM_NUMBER_OF_BYTES_ALLOC` bigint unsigned NOT NULL,
  `SUM_NUMBER_OF_BYTES_FREE` bigint unsigned NOT NULL,
  `LOW_COUNT_USED` bigint NOT NULL,
  `CURRENT_COUNT_USED` bigint NOT NULL,
  `HIGH_COUNT_USED` bigint NOT NULL,
  `LOW_NUMBER_OF_BYTES_USED` bigint NOT NULL,
  `CURRENT_NUMBER_OF_BYTES_USED` bigint NOT NULL,
  `HIGH_NUMBER_OF_BYTES_USED` bigint NOT NULL,
  PRIMARY KEY (`THREAD_ID`,`EVENT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `memory_summary_by_user_by_event_name` (
  `USER` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `COUNT_ALLOC` bigint unsigned NOT NULL,
  `COUNT_FREE` bigint unsigned NOT NULL,
  `SUM_NUMBER_OF_BYTES_ALLOC` bigint unsigned NOT NULL,
  `SUM_NUMBER_OF_BYTES_FREE` bigint unsigned NOT NULL,
  `LOW_COUNT_USED` bigint NOT NULL,
  `CURRENT_COUNT_USED` bigint NOT NULL,
  `HIGH_COUNT_USED` bigint NOT NULL,
  `LOW_NUMBER_OF_BYTES_USED` bigint NOT NULL,
  `CURRENT_NUMBER_OF_BYTES_USED` bigint NOT NULL,
  `HIGH_NUMBER_OF_BYTES_USED` bigint NOT NULL,
  UNIQUE KEY `USER` (`USER`,`EVENT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `memory_summary_global_by_event_name` (
  `EVENT_NAME` varchar(128) NOT NULL,
  `COUNT_ALLOC` bigint unsigned NOT NULL,
  `COUNT_FREE` bigint unsigned NOT NULL,
  `SUM_NUMBER_OF_BYTES_ALLOC` bigint unsigned NOT NULL,
  `SUM_NUMBER_OF_BYTES_FREE` bigint unsigned NOT NULL,
  `LOW_COUNT_USED` bigint NOT NULL,
  `CURRENT_COUNT_USED` bigint NOT NULL,
  `HIGH_COUNT_USED` bigint NOT NULL,
  `LOW_NUMBER_OF_BYTES_USED` bigint NOT NULL,
  `CURRENT_NUMBER_OF_BYTES_USED` bigint NOT NULL,
  `HIGH_NUMBER_OF_BYTES_USED` bigint NOT NULL,
  PRIMARY KEY (`EVENT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `metadata_locks` (
  `OBJECT_TYPE` varchar(64) NOT NULL,
  `OBJECT_SCHEMA` varchar(64) DEFAULT NULL,
  `OBJECT_NAME` varchar(64) DEFAULT NULL,
  `COLUMN_NAME` varchar(64) DEFAULT NULL,
  `OBJECT_INSTANCE_BEGIN` bigint unsigned NOT NULL,
  `LOCK_TYPE` varchar(32) NOT NULL,
  `LOCK_DURATION` varchar(32) NOT NULL,
  `LOCK_STATUS` varchar(32) NOT NULL,
  `SOURCE` varchar(64) DEFAULT NULL,
  `OWNER_THREAD_ID` bigint unsigned DEFAULT NULL,
  `OWNER_EVENT_ID` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`OBJECT_INSTANCE_BEGIN`),
  KEY `OBJECT_TYPE` (`OBJECT_TYPE`,`OBJECT_SCHEMA`,`OBJECT_NAME`,`COLUMN_NAME`),
  KEY `OWNER_THREAD_ID` (`OWNER_THREAD_ID`,`OWNER_EVENT_ID`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `mutex_instances` (
  `NAME` varchar(128) NOT NULL,
  `OBJECT_INSTANCE_BEGIN` bigint unsigned NOT NULL,
  `LOCKED_BY_THREAD_ID` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`OBJECT_INSTANCE_BEGIN`),
  KEY `NAME` (`NAME`),
  KEY `LOCKED_BY_THREAD_ID` (`LOCKED_BY_THREAD_ID`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `objects_summary_global_by_type` (
  `OBJECT_TYPE` varchar(64) DEFAULT NULL,
  `OBJECT_SCHEMA` varchar(64) DEFAULT NULL,
  `OBJECT_NAME` varchar(64) DEFAULT NULL,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  UNIQUE KEY `OBJECT` (`OBJECT_TYPE`,`OBJECT_SCHEMA`,`OBJECT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `performance_timers` (
  `TIMER_NAME` enum('CYCLE','NANOSECOND','MICROSECOND','MILLISECOND') NOT NULL,
  `TIMER_FREQUENCY` bigint DEFAULT NULL,
  `TIMER_RESOLUTION` bigint DEFAULT NULL,
  `TIMER_OVERHEAD` bigint DEFAULT NULL
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `persisted_variables` (
  `VARIABLE_NAME` varchar(64) NOT NULL,
  `VARIABLE_VALUE` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`VARIABLE_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `prepared_statements_instances` (
  `OBJECT_INSTANCE_BEGIN` bigint unsigned NOT NULL,
  `STATEMENT_ID` bigint unsigned NOT NULL,
  `STATEMENT_NAME` varchar(64) DEFAULT NULL,
  `SQL_TEXT` longtext NOT NULL,
  `OWNER_THREAD_ID` bigint unsigned NOT NULL,
  `OWNER_EVENT_ID` bigint unsigned NOT NULL,
  `OWNER_OBJECT_TYPE` enum('EVENT','FUNCTION','PROCEDURE','TABLE','TRIGGER') DEFAULT NULL,
  `OWNER_OBJECT_SCHEMA` varchar(64) DEFAULT NULL,
  `OWNER_OBJECT_NAME` varchar(64) DEFAULT NULL,
  `TIMER_PREPARE` bigint unsigned NOT NULL,
  `COUNT_REPREPARE` bigint unsigned NOT NULL,
  `COUNT_EXECUTE` bigint unsigned NOT NULL,
  `SUM_TIMER_EXECUTE` bigint unsigned NOT NULL,
  `MIN_TIMER_EXECUTE` bigint unsigned NOT NULL,
  `AVG_TIMER_EXECUTE` bigint unsigned NOT NULL,
  `MAX_TIMER_EXECUTE` bigint unsigned NOT NULL,
  `SUM_LOCK_TIME` bigint unsigned NOT NULL,
  `SUM_ERRORS` bigint unsigned NOT NULL,
  `SUM_WARNINGS` bigint unsigned NOT NULL,
  `SUM_ROWS_AFFECTED` bigint unsigned NOT NULL,
  `SUM_ROWS_SENT` bigint unsigned NOT NULL,
  `SUM_ROWS_EXAMINED` bigint unsigned NOT NULL,
  `SUM_CREATED_TMP_DISK_TABLES` bigint unsigned NOT NULL,
  `SUM_CREATED_TMP_TABLES` bigint unsigned NOT NULL,
  `SUM_SELECT_FULL_JOIN` bigint unsigned NOT NULL,
  `SUM_SELECT_FULL_RANGE_JOIN` bigint unsigned NOT NULL,
  `SUM_SELECT_RANGE` bigint unsigned NOT NULL,
  `SUM_SELECT_RANGE_CHECK` bigint unsigned NOT NULL,
  `SUM_SELECT_SCAN` bigint unsigned NOT NULL,
  `SUM_SORT_MERGE_PASSES` bigint unsigned NOT NULL,
  `SUM_SORT_RANGE` bigint unsigned NOT NULL,
  `SUM_SORT_ROWS` bigint unsigned NOT NULL,
  `SUM_SORT_SCAN` bigint unsigned NOT NULL,
  `SUM_NO_INDEX_USED` bigint unsigned NOT NULL,
  `SUM_NO_GOOD_INDEX_USED` bigint unsigned NOT NULL,
  PRIMARY KEY (`OBJECT_INSTANCE_BEGIN`),
  UNIQUE KEY `OWNER_THREAD_ID` (`OWNER_THREAD_ID`,`OWNER_EVENT_ID`),
  KEY `STATEMENT_ID` (`STATEMENT_ID`),
  KEY `STATEMENT_NAME` (`STATEMENT_NAME`),
  KEY `OWNER_OBJECT_TYPE` (`OWNER_OBJECT_TYPE`,`OWNER_OBJECT_SCHEMA`,`OWNER_OBJECT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `processlist` (
  `ID` bigint unsigned NOT NULL,
  `USER` varchar(32) DEFAULT NULL,
  `HOST` varchar(255) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
  `DB` varchar(64) DEFAULT NULL,
  `COMMAND` varchar(16) DEFAULT NULL,
  `TIME` bigint DEFAULT NULL,
  `STATE` varchar(64) DEFAULT NULL,
  `INFO` longtext,
  PRIMARY KEY (`ID`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `replication_applier_configuration` (
  `CHANNEL_NAME` char(64) NOT NULL,
  `DESIRED_DELAY` int NOT NULL,
  `PRIVILEGE_CHECKS_USER` text CHARACTER SET utf8 COLLATE utf8_bin COMMENT 'User name for the security context of the applier.',
  `REQUIRE_ROW_FORMAT` enum('YES','NO') NOT NULL COMMENT 'Indicates whether the channel shall only accept row based events.',
  `REQUIRE_TABLE_PRIMARY_KEY_CHECK` enum('STREAM','ON','OFF') NOT NULL COMMENT 'Indicates what is the channel policy regarding tables having primary keys on create and alter table queries',
  `ASSIGN_GTIDS_TO_ANONYMOUS_TRANSACTIONS_TYPE` enum('OFF','LOCAL','UUID') NOT NULL COMMENT 'Indicates whether the channel will generate a new GTID for anonymous transactions. OFF means that anonymous transactions will remain anonymous. LOCAL means that anonymous transactions will be assigned a newly generated GTID based on server_uuid. UUID indicates that anonymous transactions will be assigned a newly generated GTID based on Assign_gtids_to_anonymous_transactions_value',
  `ASSIGN_GTIDS_TO_ANONYMOUS_TRANSACTIONS_VALUE` text CHARACTER SET utf8 COLLATE utf8_bin COMMENT 'Indicates the UUID used while generating GTIDs for anonymous transactions',
  PRIMARY KEY (`CHANNEL_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `replication_applier_filters` (
  `CHANNEL_NAME` char(64) NOT NULL,
  `FILTER_NAME` char(64) NOT NULL,
  `FILTER_RULE` longtext NOT NULL,
  `CONFIGURED_BY` enum('STARTUP_OPTIONS','CHANGE_REPLICATION_FILTER','STARTUP_OPTIONS_FOR_CHANNEL','CHANGE_REPLICATION_FILTER_FOR_CHANNEL') NOT NULL,
  `ACTIVE_SINCE` timestamp(6) NOT NULL,
  `COUNTER` bigint unsigned NOT NULL DEFAULT '0'
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `replication_applier_global_filters` (
  `FILTER_NAME` char(64) NOT NULL,
  `FILTER_RULE` longtext NOT NULL,
  `CONFIGURED_BY` enum('STARTUP_OPTIONS','CHANGE_REPLICATION_FILTER') NOT NULL,
  `ACTIVE_SINCE` timestamp(6) NOT NULL
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `replication_applier_status` (
  `CHANNEL_NAME` char(64) NOT NULL,
  `SERVICE_STATE` enum('ON','OFF') NOT NULL,
  `REMAINING_DELAY` int unsigned DEFAULT NULL,
  `COUNT_TRANSACTIONS_RETRIES` bigint unsigned NOT NULL,
  PRIMARY KEY (`CHANNEL_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `replication_applier_status_by_coordinator` (
  `CHANNEL_NAME` char(64) NOT NULL,
  `THREAD_ID` bigint unsigned DEFAULT NULL,
  `SERVICE_STATE` enum('ON','OFF') NOT NULL,
  `LAST_ERROR_NUMBER` int NOT NULL,
  `LAST_ERROR_MESSAGE` varchar(1024) NOT NULL,
  `LAST_ERROR_TIMESTAMP` timestamp(6) NOT NULL,
  `LAST_PROCESSED_TRANSACTION` char(57) DEFAULT NULL,
  `LAST_PROCESSED_TRANSACTION_ORIGINAL_COMMIT_TIMESTAMP` timestamp(6) NOT NULL,
  `LAST_PROCESSED_TRANSACTION_IMMEDIATE_COMMIT_TIMESTAMP` timestamp(6) NOT NULL,
  `LAST_PROCESSED_TRANSACTION_START_BUFFER_TIMESTAMP` timestamp(6) NOT NULL,
  `LAST_PROCESSED_TRANSACTION_END_BUFFER_TIMESTAMP` timestamp(6) NOT NULL,
  `PROCESSING_TRANSACTION` char(57) DEFAULT NULL,
  `PROCESSING_TRANSACTION_ORIGINAL_COMMIT_TIMESTAMP` timestamp(6) NOT NULL,
  `PROCESSING_TRANSACTION_IMMEDIATE_COMMIT_TIMESTAMP` timestamp(6) NOT NULL,
  `PROCESSING_TRANSACTION_START_BUFFER_TIMESTAMP` timestamp(6) NOT NULL,
  PRIMARY KEY (`CHANNEL_NAME`),
  KEY `THREAD_ID` (`THREAD_ID`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `replication_applier_status_by_worker` (
  `CHANNEL_NAME` char(64) NOT NULL,
  `WORKER_ID` bigint unsigned NOT NULL,
  `THREAD_ID` bigint unsigned DEFAULT NULL,
  `SERVICE_STATE` enum('ON','OFF') NOT NULL,
  `LAST_ERROR_NUMBER` int NOT NULL,
  `LAST_ERROR_MESSAGE` varchar(1024) NOT NULL,
  `LAST_ERROR_TIMESTAMP` timestamp(6) NOT NULL,
  `LAST_APPLIED_TRANSACTION` char(57) DEFAULT NULL,
  `LAST_APPLIED_TRANSACTION_ORIGINAL_COMMIT_TIMESTAMP` timestamp(6) NOT NULL,
  `LAST_APPLIED_TRANSACTION_IMMEDIATE_COMMIT_TIMESTAMP` timestamp(6) NOT NULL,
  `LAST_APPLIED_TRANSACTION_START_APPLY_TIMESTAMP` timestamp(6) NOT NULL,
  `LAST_APPLIED_TRANSACTION_END_APPLY_TIMESTAMP` timestamp(6) NOT NULL,
  `APPLYING_TRANSACTION` char(57) DEFAULT NULL,
  `APPLYING_TRANSACTION_ORIGINAL_COMMIT_TIMESTAMP` timestamp(6) NOT NULL,
  `APPLYING_TRANSACTION_IMMEDIATE_COMMIT_TIMESTAMP` timestamp(6) NOT NULL,
  `APPLYING_TRANSACTION_START_APPLY_TIMESTAMP` timestamp(6) NOT NULL,
  `LAST_APPLIED_TRANSACTION_RETRIES_COUNT` bigint unsigned NOT NULL,
  `LAST_APPLIED_TRANSACTION_LAST_TRANSIENT_ERROR_NUMBER` int NOT NULL,
  `LAST_APPLIED_TRANSACTION_LAST_TRANSIENT_ERROR_MESSAGE` varchar(1024) DEFAULT NULL,
  `LAST_APPLIED_TRANSACTION_LAST_TRANSIENT_ERROR_TIMESTAMP` timestamp(6) NOT NULL,
  `APPLYING_TRANSACTION_RETRIES_COUNT` bigint unsigned NOT NULL,
  `APPLYING_TRANSACTION_LAST_TRANSIENT_ERROR_NUMBER` int NOT NULL,
  `APPLYING_TRANSACTION_LAST_TRANSIENT_ERROR_MESSAGE` varchar(1024) DEFAULT NULL,
  `APPLYING_TRANSACTION_LAST_TRANSIENT_ERROR_TIMESTAMP` timestamp(6) NOT NULL,
  PRIMARY KEY (`CHANNEL_NAME`,`WORKER_ID`),
  KEY `THREAD_ID` (`THREAD_ID`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `replication_asynchronous_connection_failover` (
  `CHANNEL_NAME` char(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'The replication channel name that connects source and replica.',
  `HOST` char(255) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL COMMENT 'The source hostname that the replica will attempt to switch over the replication connection to in case of a failure.',
  `PORT` int NOT NULL COMMENT 'The source port that the replica will attempt to switch over the replication connection to in case of a failure.',
  `NETWORK_NAMESPACE` char(64) DEFAULT NULL COMMENT 'The source network namespace that the replica will attempt to switch over the replication connection to in case of a failure. If its value is empty, connections use the default (global) namespace.',
  `WEIGHT` int unsigned NOT NULL COMMENT 'The order in which the replica shall try to switch the connection over to when there are failures. Weight can be set to a number between 1 and 100, where 100 is the highest weight and 1 the lowest.',
  `MANAGED_NAME` char(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'The name of the group which this server belongs to.'
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `replication_asynchronous_connection_failover_managed` (
  `CHANNEL_NAME` char(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'The replication channel name that connects source and replica.',
  `MANAGED_NAME` char(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'The name of the source which needs to be managed.',
  `MANAGED_TYPE` char(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'Determines the managed type.',
  `CONFIGURATION` json DEFAULT NULL COMMENT 'The data to help manage group. For Managed_type = GroupReplication, Configuration value should contain {"Primary_weight": 80, "Secondary_weight": 60}, so that it assigns weight=80 to PRIMARY of the group, and weight=60 for rest of the members in mysql.replication_asynchronous_connection_failover table.'
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `replication_connection_configuration` (
  `CHANNEL_NAME` char(64) NOT NULL,
  `HOST` char(255) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
  `PORT` int NOT NULL,
  `USER` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `NETWORK_INTERFACE` char(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `AUTO_POSITION` enum('1','0') NOT NULL,
  `SSL_ALLOWED` enum('YES','NO','IGNORED') NOT NULL,
  `SSL_CA_FILE` varchar(512) NOT NULL,
  `SSL_CA_PATH` varchar(512) NOT NULL,
  `SSL_CERTIFICATE` varchar(512) NOT NULL,
  `SSL_CIPHER` varchar(512) NOT NULL,
  `SSL_KEY` varchar(512) NOT NULL,
  `SSL_VERIFY_SERVER_CERTIFICATE` enum('YES','NO') NOT NULL,
  `SSL_CRL_FILE` varchar(255) NOT NULL,
  `SSL_CRL_PATH` varchar(255) NOT NULL,
  `CONNECTION_RETRY_INTERVAL` int NOT NULL,
  `CONNECTION_RETRY_COUNT` bigint unsigned NOT NULL,
  `HEARTBEAT_INTERVAL` double NOT NULL COMMENT 'Number of seconds after which a heartbeat will be sent .',
  `TLS_VERSION` varchar(255) NOT NULL,
  `PUBLIC_KEY_PATH` varchar(512) NOT NULL,
  `GET_PUBLIC_KEY` enum('YES','NO') NOT NULL,
  `NETWORK_NAMESPACE` varchar(64) NOT NULL,
  `COMPRESSION_ALGORITHM` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'Compression algorithm used for data transfer between master and slave.',
  `ZSTD_COMPRESSION_LEVEL` int NOT NULL COMMENT 'Compression level associated with zstd compression algorithm.',
  `TLS_CIPHERSUITES` text CHARACTER SET utf8 COLLATE utf8_bin,
  `SOURCE_CONNECTION_AUTO_FAILOVER` enum('1','0') NOT NULL,
  `GTID_ONLY` enum('1','0') NOT NULL COMMENT 'Indicates if this channel only uses GTIDs and does not persist positions.',
  PRIMARY KEY (`CHANNEL_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `replication_connection_status` (
  `CHANNEL_NAME` char(64) NOT NULL,
  `GROUP_NAME` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `SOURCE_UUID` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `THREAD_ID` bigint unsigned DEFAULT NULL,
  `SERVICE_STATE` enum('ON','OFF','CONNECTING') NOT NULL,
  `COUNT_RECEIVED_HEARTBEATS` bigint unsigned NOT NULL DEFAULT '0',
  `LAST_HEARTBEAT_TIMESTAMP` timestamp(6) NOT NULL COMMENT 'Shows when the most recent heartbeat signal was received.',
  `RECEIVED_TRANSACTION_SET` longtext NOT NULL,
  `LAST_ERROR_NUMBER` int NOT NULL,
  `LAST_ERROR_MESSAGE` varchar(1024) NOT NULL,
  `LAST_ERROR_TIMESTAMP` timestamp(6) NOT NULL,
  `LAST_QUEUED_TRANSACTION` char(57) DEFAULT NULL,
  `LAST_QUEUED_TRANSACTION_ORIGINAL_COMMIT_TIMESTAMP` timestamp(6) NOT NULL,
  `LAST_QUEUED_TRANSACTION_IMMEDIATE_COMMIT_TIMESTAMP` timestamp(6) NOT NULL,
  `LAST_QUEUED_TRANSACTION_START_QUEUE_TIMESTAMP` timestamp(6) NOT NULL,
  `LAST_QUEUED_TRANSACTION_END_QUEUE_TIMESTAMP` timestamp(6) NOT NULL,
  `QUEUEING_TRANSACTION` char(57) DEFAULT NULL,
  `QUEUEING_TRANSACTION_ORIGINAL_COMMIT_TIMESTAMP` timestamp(6) NOT NULL,
  `QUEUEING_TRANSACTION_IMMEDIATE_COMMIT_TIMESTAMP` timestamp(6) NOT NULL,
  `QUEUEING_TRANSACTION_START_QUEUE_TIMESTAMP` timestamp(6) NOT NULL,
  PRIMARY KEY (`CHANNEL_NAME`),
  KEY `THREAD_ID` (`THREAD_ID`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `replication_group_member_stats` (
  `CHANNEL_NAME` char(64) NOT NULL,
  `VIEW_ID` char(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `MEMBER_ID` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `COUNT_TRANSACTIONS_IN_QUEUE` bigint unsigned NOT NULL,
  `COUNT_TRANSACTIONS_CHECKED` bigint unsigned NOT NULL,
  `COUNT_CONFLICTS_DETECTED` bigint unsigned NOT NULL,
  `COUNT_TRANSACTIONS_ROWS_VALIDATING` bigint unsigned NOT NULL,
  `TRANSACTIONS_COMMITTED_ALL_MEMBERS` longtext NOT NULL,
  `LAST_CONFLICT_FREE_TRANSACTION` text NOT NULL,
  `COUNT_TRANSACTIONS_REMOTE_IN_APPLIER_QUEUE` bigint unsigned NOT NULL,
  `COUNT_TRANSACTIONS_REMOTE_APPLIED` bigint unsigned NOT NULL,
  `COUNT_TRANSACTIONS_LOCAL_PROPOSED` bigint unsigned NOT NULL,
  `COUNT_TRANSACTIONS_LOCAL_ROLLBACK` bigint unsigned NOT NULL
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `replication_group_members` (
  `CHANNEL_NAME` char(64) NOT NULL,
  `MEMBER_ID` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `MEMBER_HOST` char(255) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
  `MEMBER_PORT` int DEFAULT NULL,
  `MEMBER_STATE` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `MEMBER_ROLE` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `MEMBER_VERSION` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `MEMBER_COMMUNICATION_STACK` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `rwlock_instances` (
  `NAME` varchar(128) NOT NULL,
  `OBJECT_INSTANCE_BEGIN` bigint unsigned NOT NULL,
  `WRITE_LOCKED_BY_THREAD_ID` bigint unsigned DEFAULT NULL,
  `READ_LOCKED_BY_COUNT` int unsigned NOT NULL,
  PRIMARY KEY (`OBJECT_INSTANCE_BEGIN`),
  KEY `NAME` (`NAME`),
  KEY `WRITE_LOCKED_BY_THREAD_ID` (`WRITE_LOCKED_BY_THREAD_ID`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `session_account_connect_attrs` (
  `PROCESSLIST_ID` bigint unsigned NOT NULL,
  `ATTR_NAME` varchar(32) COLLATE utf8mb4_bin NOT NULL,
  `ATTR_VALUE` varchar(1024) COLLATE utf8mb4_bin DEFAULT NULL,
  `ORDINAL_POSITION` int DEFAULT NULL,
  PRIMARY KEY (`PROCESSLIST_ID`,`ATTR_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin


CREATE TABLE `session_connect_attrs` (
  `PROCESSLIST_ID` bigint unsigned NOT NULL,
  `ATTR_NAME` varchar(32) COLLATE utf8mb4_bin NOT NULL,
  `ATTR_VALUE` varchar(1024) COLLATE utf8mb4_bin DEFAULT NULL,
  `ORDINAL_POSITION` int DEFAULT NULL,
  PRIMARY KEY (`PROCESSLIST_ID`,`ATTR_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin


CREATE TABLE `session_status` (
  `VARIABLE_NAME` varchar(64) NOT NULL,
  `VARIABLE_VALUE` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`VARIABLE_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `session_variables` (
  `VARIABLE_NAME` varchar(64) NOT NULL,
  `VARIABLE_VALUE` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`VARIABLE_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `setup_actors` (
  `HOST` char(255) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT '%',
  `USER` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '%',
  `ROLE` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '%',
  `ENABLED` enum('YES','NO') NOT NULL DEFAULT 'YES',
  `HISTORY` enum('YES','NO') NOT NULL DEFAULT 'YES',
  PRIMARY KEY (`HOST`,`USER`,`ROLE`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `setup_consumers` (
  `NAME` varchar(64) NOT NULL,
  `ENABLED` enum('YES','NO') NOT NULL,
  PRIMARY KEY (`NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `setup_instruments` (
  `NAME` varchar(128) NOT NULL,
  `ENABLED` enum('YES','NO') NOT NULL,
  `TIMED` enum('YES','NO') DEFAULT NULL,
  `PROPERTIES` set('singleton','progress','user','global_statistics','mutable') NOT NULL,
  `VOLATILITY` int NOT NULL,
  `DOCUMENTATION` longtext,
  PRIMARY KEY (`NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `setup_objects` (
  `OBJECT_TYPE` enum('EVENT','FUNCTION','PROCEDURE','TABLE','TRIGGER') NOT NULL DEFAULT 'TABLE',
  `OBJECT_SCHEMA` varchar(64) DEFAULT '%',
  `OBJECT_NAME` varchar(64) NOT NULL DEFAULT '%',
  `ENABLED` enum('YES','NO') NOT NULL DEFAULT 'YES',
  `TIMED` enum('YES','NO') NOT NULL DEFAULT 'YES',
  UNIQUE KEY `OBJECT` (`OBJECT_TYPE`,`OBJECT_SCHEMA`,`OBJECT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `setup_threads` (
  `NAME` varchar(128) NOT NULL,
  `ENABLED` enum('YES','NO') NOT NULL,
  `HISTORY` enum('YES','NO') NOT NULL,
  `PROPERTIES` set('singleton','user') NOT NULL,
  `VOLATILITY` int NOT NULL,
  `DOCUMENTATION` longtext,
  PRIMARY KEY (`NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `socket_instances` (
  `EVENT_NAME` varchar(128) NOT NULL,
  `OBJECT_INSTANCE_BEGIN` bigint unsigned NOT NULL,
  `THREAD_ID` bigint unsigned DEFAULT NULL,
  `SOCKET_ID` int NOT NULL,
  `IP` varchar(64) NOT NULL,
  `PORT` int NOT NULL,
  `STATE` enum('IDLE','ACTIVE') NOT NULL,
  PRIMARY KEY (`OBJECT_INSTANCE_BEGIN`),
  KEY `THREAD_ID` (`THREAD_ID`),
  KEY `SOCKET_ID` (`SOCKET_ID`),
  KEY `IP` (`IP`,`PORT`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `socket_summary_by_event_name` (
  `EVENT_NAME` varchar(128) NOT NULL,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  `COUNT_READ` bigint unsigned NOT NULL,
  `SUM_TIMER_READ` bigint unsigned NOT NULL,
  `MIN_TIMER_READ` bigint unsigned NOT NULL,
  `AVG_TIMER_READ` bigint unsigned NOT NULL,
  `MAX_TIMER_READ` bigint unsigned NOT NULL,
  `SUM_NUMBER_OF_BYTES_READ` bigint unsigned NOT NULL,
  `COUNT_WRITE` bigint unsigned NOT NULL,
  `SUM_TIMER_WRITE` bigint unsigned NOT NULL,
  `MIN_TIMER_WRITE` bigint unsigned NOT NULL,
  `AVG_TIMER_WRITE` bigint unsigned NOT NULL,
  `MAX_TIMER_WRITE` bigint unsigned NOT NULL,
  `SUM_NUMBER_OF_BYTES_WRITE` bigint unsigned NOT NULL,
  `COUNT_MISC` bigint unsigned NOT NULL,
  `SUM_TIMER_MISC` bigint unsigned NOT NULL,
  `MIN_TIMER_MISC` bigint unsigned NOT NULL,
  `AVG_TIMER_MISC` bigint unsigned NOT NULL,
  `MAX_TIMER_MISC` bigint unsigned NOT NULL,
  PRIMARY KEY (`EVENT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `socket_summary_by_instance` (
  `EVENT_NAME` varchar(128) NOT NULL,
  `OBJECT_INSTANCE_BEGIN` bigint unsigned NOT NULL,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  `COUNT_READ` bigint unsigned NOT NULL,
  `SUM_TIMER_READ` bigint unsigned NOT NULL,
  `MIN_TIMER_READ` bigint unsigned NOT NULL,
  `AVG_TIMER_READ` bigint unsigned NOT NULL,
  `MAX_TIMER_READ` bigint unsigned NOT NULL,
  `SUM_NUMBER_OF_BYTES_READ` bigint unsigned NOT NULL,
  `COUNT_WRITE` bigint unsigned NOT NULL,
  `SUM_TIMER_WRITE` bigint unsigned NOT NULL,
  `MIN_TIMER_WRITE` bigint unsigned NOT NULL,
  `AVG_TIMER_WRITE` bigint unsigned NOT NULL,
  `MAX_TIMER_WRITE` bigint unsigned NOT NULL,
  `SUM_NUMBER_OF_BYTES_WRITE` bigint unsigned NOT NULL,
  `COUNT_MISC` bigint unsigned NOT NULL,
  `SUM_TIMER_MISC` bigint unsigned NOT NULL,
  `MIN_TIMER_MISC` bigint unsigned NOT NULL,
  `AVG_TIMER_MISC` bigint unsigned NOT NULL,
  `MAX_TIMER_MISC` bigint unsigned NOT NULL,
  PRIMARY KEY (`OBJECT_INSTANCE_BEGIN`),
  KEY `EVENT_NAME` (`EVENT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `status_by_account` (
  `USER` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `HOST` char(255) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
  `VARIABLE_NAME` varchar(64) NOT NULL,
  `VARIABLE_VALUE` varchar(1024) DEFAULT NULL,
  UNIQUE KEY `ACCOUNT` (`USER`,`HOST`,`VARIABLE_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `status_by_host` (
  `HOST` char(255) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
  `VARIABLE_NAME` varchar(64) NOT NULL,
  `VARIABLE_VALUE` varchar(1024) DEFAULT NULL,
  UNIQUE KEY `HOST` (`HOST`,`VARIABLE_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `status_by_thread` (
  `THREAD_ID` bigint unsigned NOT NULL,
  `VARIABLE_NAME` varchar(64) NOT NULL,
  `VARIABLE_VALUE` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`THREAD_ID`,`VARIABLE_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `status_by_user` (
  `USER` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `VARIABLE_NAME` varchar(64) NOT NULL,
  `VARIABLE_VALUE` varchar(1024) DEFAULT NULL,
  UNIQUE KEY `USER` (`USER`,`VARIABLE_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `table_handles` (
  `OBJECT_TYPE` varchar(64) NOT NULL,
  `OBJECT_SCHEMA` varchar(64) NOT NULL,
  `OBJECT_NAME` varchar(64) NOT NULL,
  `OBJECT_INSTANCE_BEGIN` bigint unsigned NOT NULL,
  `OWNER_THREAD_ID` bigint unsigned DEFAULT NULL,
  `OWNER_EVENT_ID` bigint unsigned DEFAULT NULL,
  `INTERNAL_LOCK` varchar(64) DEFAULT NULL,
  `EXTERNAL_LOCK` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`OBJECT_INSTANCE_BEGIN`),
  KEY `OBJECT_TYPE` (`OBJECT_TYPE`,`OBJECT_SCHEMA`,`OBJECT_NAME`),
  KEY `OWNER_THREAD_ID` (`OWNER_THREAD_ID`,`OWNER_EVENT_ID`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `table_io_waits_summary_by_index_usage` (
  `OBJECT_TYPE` varchar(64) DEFAULT NULL,
  `OBJECT_SCHEMA` varchar(64) DEFAULT NULL,
  `OBJECT_NAME` varchar(64) DEFAULT NULL,
  `INDEX_NAME` varchar(64) DEFAULT NULL,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  `COUNT_READ` bigint unsigned NOT NULL,
  `SUM_TIMER_READ` bigint unsigned NOT NULL,
  `MIN_TIMER_READ` bigint unsigned NOT NULL,
  `AVG_TIMER_READ` bigint unsigned NOT NULL,
  `MAX_TIMER_READ` bigint unsigned NOT NULL,
  `COUNT_WRITE` bigint unsigned NOT NULL,
  `SUM_TIMER_WRITE` bigint unsigned NOT NULL,
  `MIN_TIMER_WRITE` bigint unsigned NOT NULL,
  `AVG_TIMER_WRITE` bigint unsigned NOT NULL,
  `MAX_TIMER_WRITE` bigint unsigned NOT NULL,
  `COUNT_FETCH` bigint unsigned NOT NULL,
  `SUM_TIMER_FETCH` bigint unsigned NOT NULL,
  `MIN_TIMER_FETCH` bigint unsigned NOT NULL,
  `AVG_TIMER_FETCH` bigint unsigned NOT NULL,
  `MAX_TIMER_FETCH` bigint unsigned NOT NULL,
  `COUNT_INSERT` bigint unsigned NOT NULL,
  `SUM_TIMER_INSERT` bigint unsigned NOT NULL,
  `MIN_TIMER_INSERT` bigint unsigned NOT NULL,
  `AVG_TIMER_INSERT` bigint unsigned NOT NULL,
  `MAX_TIMER_INSERT` bigint unsigned NOT NULL,
  `COUNT_UPDATE` bigint unsigned NOT NULL,
  `SUM_TIMER_UPDATE` bigint unsigned NOT NULL,
  `MIN_TIMER_UPDATE` bigint unsigned NOT NULL,
  `AVG_TIMER_UPDATE` bigint unsigned NOT NULL,
  `MAX_TIMER_UPDATE` bigint unsigned NOT NULL,
  `COUNT_DELETE` bigint unsigned NOT NULL,
  `SUM_TIMER_DELETE` bigint unsigned NOT NULL,
  `MIN_TIMER_DELETE` bigint unsigned NOT NULL,
  `AVG_TIMER_DELETE` bigint unsigned NOT NULL,
  `MAX_TIMER_DELETE` bigint unsigned NOT NULL,
  UNIQUE KEY `OBJECT` (`OBJECT_TYPE`,`OBJECT_SCHEMA`,`OBJECT_NAME`,`INDEX_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `table_io_waits_summary_by_table` (
  `OBJECT_TYPE` varchar(64) DEFAULT NULL,
  `OBJECT_SCHEMA` varchar(64) DEFAULT NULL,
  `OBJECT_NAME` varchar(64) DEFAULT NULL,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  `COUNT_READ` bigint unsigned NOT NULL,
  `SUM_TIMER_READ` bigint unsigned NOT NULL,
  `MIN_TIMER_READ` bigint unsigned NOT NULL,
  `AVG_TIMER_READ` bigint unsigned NOT NULL,
  `MAX_TIMER_READ` bigint unsigned NOT NULL,
  `COUNT_WRITE` bigint unsigned NOT NULL,
  `SUM_TIMER_WRITE` bigint unsigned NOT NULL,
  `MIN_TIMER_WRITE` bigint unsigned NOT NULL,
  `AVG_TIMER_WRITE` bigint unsigned NOT NULL,
  `MAX_TIMER_WRITE` bigint unsigned NOT NULL,
  `COUNT_FETCH` bigint unsigned NOT NULL,
  `SUM_TIMER_FETCH` bigint unsigned NOT NULL,
  `MIN_TIMER_FETCH` bigint unsigned NOT NULL,
  `AVG_TIMER_FETCH` bigint unsigned NOT NULL,
  `MAX_TIMER_FETCH` bigint unsigned NOT NULL,
  `COUNT_INSERT` bigint unsigned NOT NULL,
  `SUM_TIMER_INSERT` bigint unsigned NOT NULL,
  `MIN_TIMER_INSERT` bigint unsigned NOT NULL,
  `AVG_TIMER_INSERT` bigint unsigned NOT NULL,
  `MAX_TIMER_INSERT` bigint unsigned NOT NULL,
  `COUNT_UPDATE` bigint unsigned NOT NULL,
  `SUM_TIMER_UPDATE` bigint unsigned NOT NULL,
  `MIN_TIMER_UPDATE` bigint unsigned NOT NULL,
  `AVG_TIMER_UPDATE` bigint unsigned NOT NULL,
  `MAX_TIMER_UPDATE` bigint unsigned NOT NULL,
  `COUNT_DELETE` bigint unsigned NOT NULL,
  `SUM_TIMER_DELETE` bigint unsigned NOT NULL,
  `MIN_TIMER_DELETE` bigint unsigned NOT NULL,
  `AVG_TIMER_DELETE` bigint unsigned NOT NULL,
  `MAX_TIMER_DELETE` bigint unsigned NOT NULL,
  UNIQUE KEY `OBJECT` (`OBJECT_TYPE`,`OBJECT_SCHEMA`,`OBJECT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `table_lock_waits_summary_by_table` (
  `OBJECT_TYPE` varchar(64) DEFAULT NULL,
  `OBJECT_SCHEMA` varchar(64) DEFAULT NULL,
  `OBJECT_NAME` varchar(64) DEFAULT NULL,
  `COUNT_STAR` bigint unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint unsigned NOT NULL,
  `COUNT_READ` bigint unsigned NOT NULL,
  `SUM_TIMER_READ` bigint unsigned NOT NULL,
  `MIN_TIMER_READ` bigint unsigned NOT NULL,
  `AVG_TIMER_READ` bigint unsigned NOT NULL,
  `MAX_TIMER_READ` bigint unsigned NOT NULL,
  `COUNT_WRITE` bigint unsigned NOT NULL,
  `SUM_TIMER_WRITE` bigint unsigned NOT NULL,
  `MIN_TIMER_WRITE` bigint unsigned NOT NULL,
  `AVG_TIMER_WRITE` bigint unsigned NOT NULL,
  `MAX_TIMER_WRITE` bigint unsigned NOT NULL,
  `COUNT_READ_NORMAL` bigint unsigned NOT NULL,
  `SUM_TIMER_READ_NORMAL` bigint unsigned NOT NULL,
  `MIN_TIMER_READ_NORMAL` bigint unsigned NOT NULL,
  `AVG_TIMER_READ_NORMAL` bigint unsigned NOT NULL,
  `MAX_TIMER_READ_NORMAL` bigint unsigned NOT NULL,
  `COUNT_READ_WITH_SHARED_LOCKS` bigint unsigned NOT NULL,
  `SUM_TIMER_READ_WITH_SHARED_LOCKS` bigint unsigned NOT NULL,
  `MIN_TIMER_READ_WITH_SHARED_LOCKS` bigint unsigned NOT NULL,
  `AVG_TIMER_READ_WITH_SHARED_LOCKS` bigint unsigned NOT NULL,
  `MAX_TIMER_READ_WITH_SHARED_LOCKS` bigint unsigned NOT NULL,
  `COUNT_READ_HIGH_PRIORITY` bigint unsigned NOT NULL,
  `SUM_TIMER_READ_HIGH_PRIORITY` bigint unsigned NOT NULL,
  `MIN_TIMER_READ_HIGH_PRIORITY` bigint unsigned NOT NULL,
  `AVG_TIMER_READ_HIGH_PRIORITY` bigint unsigned NOT NULL,
  `MAX_TIMER_READ_HIGH_PRIORITY` bigint unsigned NOT NULL,
  `COUNT_READ_NO_INSERT` bigint unsigned NOT NULL,
  `SUM_TIMER_READ_NO_INSERT` bigint unsigned NOT NULL,
  `MIN_TIMER_READ_NO_INSERT` bigint unsigned NOT NULL,
  `AVG_TIMER_READ_NO_INSERT` bigint unsigned NOT NULL,
  `MAX_TIMER_READ_NO_INSERT` bigint unsigned NOT NULL,
  `COUNT_READ_EXTERNAL` bigint unsigned NOT NULL,
  `SUM_TIMER_READ_EXTERNAL` bigint unsigned NOT NULL,
  `MIN_TIMER_READ_EXTERNAL` bigint unsigned NOT NULL,
  `AVG_TIMER_READ_EXTERNAL` bigint unsigned NOT NULL,
  `MAX_TIMER_READ_EXTERNAL` bigint unsigned NOT NULL,
  `COUNT_WRITE_ALLOW_WRITE` bigint unsigned NOT NULL,
  `SUM_TIMER_WRITE_ALLOW_WRITE` bigint unsigned NOT NULL,
  `MIN_TIMER_WRITE_ALLOW_WRITE` bigint unsigned NOT NULL,
  `AVG_TIMER_WRITE_ALLOW_WRITE` bigint unsigned NOT NULL,
  `MAX_TIMER_WRITE_ALLOW_WRITE` bigint unsigned NOT NULL,
  `COUNT_WRITE_CONCURRENT_INSERT` bigint unsigned NOT NULL,
  `SUM_TIMER_WRITE_CONCURRENT_INSERT` bigint unsigned NOT NULL,
  `MIN_TIMER_WRITE_CONCURRENT_INSERT` bigint unsigned NOT NULL,
  `AVG_TIMER_WRITE_CONCURRENT_INSERT` bigint unsigned NOT NULL,
  `MAX_TIMER_WRITE_CONCURRENT_INSERT` bigint unsigned NOT NULL,
  `COUNT_WRITE_LOW_PRIORITY` bigint unsigned NOT NULL,
  `SUM_TIMER_WRITE_LOW_PRIORITY` bigint unsigned NOT NULL,
  `MIN_TIMER_WRITE_LOW_PRIORITY` bigint unsigned NOT NULL,
  `AVG_TIMER_WRITE_LOW_PRIORITY` bigint unsigned NOT NULL,
  `MAX_TIMER_WRITE_LOW_PRIORITY` bigint unsigned NOT NULL,
  `COUNT_WRITE_NORMAL` bigint unsigned NOT NULL,
  `SUM_TIMER_WRITE_NORMAL` bigint unsigned NOT NULL,
  `MIN_TIMER_WRITE_NORMAL` bigint unsigned NOT NULL,
  `AVG_TIMER_WRITE_NORMAL` bigint unsigned NOT NULL,
  `MAX_TIMER_WRITE_NORMAL` bigint unsigned NOT NULL,
  `COUNT_WRITE_EXTERNAL` bigint unsigned NOT NULL,
  `SUM_TIMER_WRITE_EXTERNAL` bigint unsigned NOT NULL,
  `MIN_TIMER_WRITE_EXTERNAL` bigint unsigned NOT NULL,
  `AVG_TIMER_WRITE_EXTERNAL` bigint unsigned NOT NULL,
  `MAX_TIMER_WRITE_EXTERNAL` bigint unsigned NOT NULL,
  UNIQUE KEY `OBJECT` (`OBJECT_TYPE`,`OBJECT_SCHEMA`,`OBJECT_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `threads` (
  `THREAD_ID` bigint unsigned NOT NULL,
  `NAME` varchar(128) NOT NULL,
  `TYPE` varchar(10) NOT NULL,
  `PROCESSLIST_ID` bigint unsigned DEFAULT NULL,
  `PROCESSLIST_USER` varchar(32) DEFAULT NULL,
  `PROCESSLIST_HOST` varchar(255) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
  `PROCESSLIST_DB` varchar(64) DEFAULT NULL,
  `PROCESSLIST_COMMAND` varchar(16) DEFAULT NULL,
  `PROCESSLIST_TIME` bigint DEFAULT NULL,
  `PROCESSLIST_STATE` varchar(64) DEFAULT NULL,
  `PROCESSLIST_INFO` longtext,
  `PARENT_THREAD_ID` bigint unsigned DEFAULT NULL,
  `ROLE` varchar(64) DEFAULT NULL,
  `INSTRUMENTED` enum('YES','NO') NOT NULL,
  `HISTORY` enum('YES','NO') NOT NULL,
  `CONNECTION_TYPE` varchar(16) DEFAULT NULL,
  `THREAD_OS_ID` bigint unsigned DEFAULT NULL,
  `RESOURCE_GROUP` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`THREAD_ID`),
  KEY `PROCESSLIST_ID` (`PROCESSLIST_ID`),
  KEY `THREAD_OS_ID` (`THREAD_OS_ID`),
  KEY `NAME` (`NAME`),
  KEY `PROCESSLIST_ACCOUNT` (`PROCESSLIST_USER`,`PROCESSLIST_HOST`),
  KEY `PROCESSLIST_HOST` (`PROCESSLIST_HOST`),
  KEY `RESOURCE_GROUP` (`RESOURCE_GROUP`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `tls_channel_status` (
  `CHANNEL` varchar(128) NOT NULL,
  `PROPERTY` varchar(128) NOT NULL,
  `VALUE` varchar(2048) NOT NULL
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `user_defined_functions` (
  `UDF_NAME` varchar(64) NOT NULL,
  `UDF_RETURN_TYPE` varchar(20) NOT NULL,
  `UDF_TYPE` varchar(20) NOT NULL,
  `UDF_LIBRARY` varchar(1024) DEFAULT NULL,
  `UDF_USAGE_COUNT` bigint DEFAULT NULL,
  PRIMARY KEY (`UDF_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `user_variables_by_thread` (
  `THREAD_ID` bigint unsigned NOT NULL,
  `VARIABLE_NAME` varchar(64) NOT NULL,
  `VARIABLE_VALUE` longblob,
  PRIMARY KEY (`THREAD_ID`,`VARIABLE_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `users` (
  `USER` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `CURRENT_CONNECTIONS` bigint NOT NULL,
  `TOTAL_CONNECTIONS` bigint NOT NULL,
  UNIQUE KEY `USER` (`USER`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `variables_by_thread` (
  `THREAD_ID` bigint unsigned NOT NULL,
  `VARIABLE_NAME` varchar(64) NOT NULL,
  `VARIABLE_VALUE` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`THREAD_ID`,`VARIABLE_NAME`)
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `variables_info` (
  `VARIABLE_NAME` varchar(64) NOT NULL,
  `VARIABLE_SOURCE` enum('COMPILED','GLOBAL','SERVER','EXPLICIT','EXTRA','USER','LOGIN','COMMAND_LINE','PERSISTED','DYNAMIC') DEFAULT 'COMPILED',
  `VARIABLE_PATH` varchar(1024) DEFAULT NULL,
  `MIN_VALUE` varchar(64) DEFAULT NULL,
  `MAX_VALUE` varchar(64) DEFAULT NULL,
  `SET_TIME` timestamp(6) NULL DEFAULT NULL,
  `SET_USER` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `SET_HOST` char(255) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL
) ENGINE=PERFORMANCE_SCHEMA DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci