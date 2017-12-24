-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Sun Dec 24 09:21:27 2017
-- 
SET foreign_key_checks=0;

DROP TABLE IF EXISTS `mt_accesstoken`;

--
-- Table: `mt_accesstoken`
--
CREATE TABLE `mt_accesstoken` (
  `accesstoken_id` varchar(80) NOT NULL,
  `accesstoken_session_id` varchar(80) NOT NULL,
  `accesstoken_start` integer(11) NOT NULL,
  INDEX `mt_accesstoken_session_id` (`accesstoken_session_id`),
  INDEX `mt_accesstoken_start` (`accesstoken_start`),
  PRIMARY KEY (`accesstoken_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_asset`;

--
-- Table: `mt_asset`
--
CREATE TABLE `mt_asset` (
  `asset_blog_id` integer(11) NOT NULL,
  `asset_class` varchar(255) NULL DEFAULT 'file',
  `asset_created_by` integer(11) NULL DEFAULT NULL,
  `asset_created_on` datetime NULL DEFAULT NULL,
  `asset_description` mediumtext NULL,
  `asset_file_ext` varchar(20) NULL DEFAULT NULL,
  `asset_file_name` varchar(255) NULL DEFAULT NULL,
  `asset_file_path` varchar(255) NULL DEFAULT NULL,
  `asset_id` integer(11) NOT NULL auto_increment,
  `asset_label` varchar(255) NULL DEFAULT NULL,
  `asset_mime_type` varchar(255) NULL DEFAULT NULL,
  `asset_modified_by` integer(11) NULL DEFAULT NULL,
  `asset_modified_on` datetime NULL DEFAULT NULL,
  `asset_parent` integer(11) NULL DEFAULT NULL,
  `asset_url` mediumtext NULL,
  INDEX `mt_asset_blog_class_date` (`asset_blog_id`, `asset_class`, `asset_created_on`),
  INDEX `mt_asset_class` (`asset_class`),
  INDEX `mt_asset_created_by` (`asset_created_by`),
  INDEX `mt_asset_created_on` (`asset_created_on`),
  INDEX `mt_asset_file_ext` (`asset_file_ext`),
  INDEX `mt_asset_label` (`asset_label`),
  INDEX `mt_asset_parent` (`asset_parent`),
  PRIMARY KEY (`asset_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_asset_meta`;

--
-- Table: `mt_asset_meta`
--
CREATE TABLE `mt_asset_meta` (
  `asset_meta_asset_id` integer(11) NOT NULL,
  `asset_meta_type` varchar(75) NOT NULL,
  `asset_meta_vblob` mediumblob NULL,
  `asset_meta_vchar` varchar(255) NULL DEFAULT NULL,
  `asset_meta_vchar_idx` varchar(255) NULL DEFAULT NULL,
  `asset_meta_vclob` mediumtext NULL,
  `asset_meta_vdatetime` datetime NULL DEFAULT NULL,
  `asset_meta_vdatetime_idx` datetime NULL DEFAULT NULL,
  `asset_meta_vfloat` float NULL DEFAULT NULL,
  `asset_meta_vfloat_idx` float NULL DEFAULT NULL,
  `asset_meta_vinteger` integer(11) NULL DEFAULT NULL,
  `asset_meta_vinteger_idx` integer(11) NULL DEFAULT NULL,
  INDEX `mt_asset_meta_type_vchar` (`asset_meta_type`, `asset_meta_vchar_idx`),
  INDEX `mt_asset_meta_type_vdt` (`asset_meta_type`, `asset_meta_vdatetime_idx`),
  INDEX `mt_asset_meta_type_vflt` (`asset_meta_type`, `asset_meta_vfloat_idx`),
  INDEX `mt_asset_meta_type_vint` (`asset_meta_type`, `asset_meta_vinteger_idx`),
  PRIMARY KEY (`asset_meta_asset_id`, `asset_meta_type`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_association`;

--
-- Table: `mt_association`
--
CREATE TABLE `mt_association` (
  `association_author_id` integer(11) NULL DEFAULT 0,
  `association_blog_id` integer(11) NULL DEFAULT 0,
  `association_created_by` integer(11) NULL DEFAULT NULL,
  `association_created_on` datetime NULL DEFAULT NULL,
  `association_group_id` integer(11) NULL DEFAULT 0,
  `association_id` integer(11) NOT NULL auto_increment,
  `association_modified_by` integer(11) NULL DEFAULT NULL,
  `association_modified_on` datetime NULL DEFAULT NULL,
  `association_role_id` integer(11) NULL DEFAULT 0,
  `association_type` integer(11) NOT NULL,
  INDEX `mt_association_author_id` (`association_author_id`),
  INDEX `mt_association_blog_id` (`association_blog_id`),
  INDEX `mt_association_created_on` (`association_created_on`),
  INDEX `mt_association_group_id` (`association_group_id`),
  INDEX `mt_association_role_id` (`association_role_id`),
  INDEX `mt_association_type` (`association_type`),
  PRIMARY KEY (`association_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_author`;

--
-- Table: `mt_author`
--
CREATE TABLE `mt_author` (
  `author_api_password` varchar(60) NULL DEFAULT NULL,
  `author_auth_type` varchar(50) NULL DEFAULT NULL,
  `author_basename` varchar(255) NULL DEFAULT NULL,
  `author_can_create_blog` tinyint(4) NULL DEFAULT NULL,
  `author_can_view_log` tinyint(4) NULL DEFAULT NULL,
  `author_created_by` integer(11) NULL DEFAULT NULL,
  `author_created_on` datetime NULL DEFAULT NULL,
  `author_date_format` varchar(30) NULL DEFAULT 'relative',
  `author_email` varchar(127) NULL DEFAULT NULL,
  `author_entry_prefs` varchar(255) NULL DEFAULT NULL,
  `author_external_id` varchar(255) NULL DEFAULT NULL,
  `author_hint` varchar(75) NULL DEFAULT NULL,
  `author_id` integer(11) NOT NULL auto_increment,
  `author_is_superuser` tinyint(4) NULL DEFAULT NULL,
  `author_locked_out_time` integer(11) NOT NULL DEFAULT 0,
  `author_modified_by` integer(11) NULL DEFAULT NULL,
  `author_modified_on` datetime NULL DEFAULT NULL,
  `author_name` varchar(255) NOT NULL,
  `author_nickname` varchar(255) NULL DEFAULT NULL,
  `author_password` varchar(124) NOT NULL,
  `author_preferred_language` varchar(50) NULL DEFAULT NULL,
  `author_public_key` mediumtext NULL,
  `author_remote_auth_token` varchar(50) NULL DEFAULT NULL,
  `author_remote_auth_username` varchar(50) NULL DEFAULT NULL,
  `author_status` integer(11) NULL DEFAULT 1,
  `author_text_format` varchar(30) NULL DEFAULT NULL,
  `author_type` smallint(6) NOT NULL DEFAULT 1,
  `author_url` varchar(255) NULL DEFAULT NULL,
  `author_userpic_asset_id` integer(11) NULL DEFAULT NULL,
  INDEX `mt_author_auth_type_name` (`author_auth_type`, `author_name`, `author_type`),
  INDEX `mt_author_basename` (`author_basename`),
  INDEX `mt_author_created_on` (`author_created_on`),
  INDEX `mt_author_email` (`author_email`),
  INDEX `mt_author_external_id` (`author_external_id`),
  INDEX `mt_author_locked_out_time` (`author_locked_out_time`),
  INDEX `mt_author_name` (`author_name`),
  INDEX `mt_author_status` (`author_status`),
  INDEX `mt_author_type` (`author_type`),
  PRIMARY KEY (`author_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_author_meta`;

--
-- Table: `mt_author_meta`
--
CREATE TABLE `mt_author_meta` (
  `author_meta_author_id` integer(11) NOT NULL,
  `author_meta_type` varchar(75) NOT NULL,
  `author_meta_vblob` mediumblob NULL,
  `author_meta_vchar` varchar(255) NULL DEFAULT NULL,
  `author_meta_vchar_idx` varchar(255) NULL DEFAULT NULL,
  `author_meta_vclob` mediumtext NULL,
  `author_meta_vdatetime` datetime NULL DEFAULT NULL,
  `author_meta_vdatetime_idx` datetime NULL DEFAULT NULL,
  `author_meta_vfloat` float NULL DEFAULT NULL,
  `author_meta_vfloat_idx` float NULL DEFAULT NULL,
  `author_meta_vinteger` integer(11) NULL DEFAULT NULL,
  `author_meta_vinteger_idx` integer(11) NULL DEFAULT NULL,
  INDEX `mt_author_meta_type_vchar` (`author_meta_type`, `author_meta_vchar_idx`),
  INDEX `mt_author_meta_type_vdt` (`author_meta_type`, `author_meta_vdatetime_idx`),
  INDEX `mt_author_meta_type_vflt` (`author_meta_type`, `author_meta_vfloat_idx`),
  INDEX `mt_author_meta_type_vint` (`author_meta_type`, `author_meta_vinteger_idx`),
  PRIMARY KEY (`author_meta_author_id`, `author_meta_type`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_author_summary`;

--
-- Table: `mt_author_summary`
--
CREATE TABLE `mt_author_summary` (
  `author_summary_author_id` integer(11) NOT NULL,
  `author_summary_class` varchar(75) NOT NULL,
  `author_summary_expired` smallint(6) NULL DEFAULT NULL,
  `author_summary_type` varchar(75) NOT NULL,
  `author_summary_vblob` mediumblob NULL,
  `author_summary_vchar_idx` varchar(255) NULL DEFAULT NULL,
  `author_summary_vclob` mediumtext NULL,
  `author_summary_vinteger_idx` integer(11) NULL DEFAULT NULL,
  INDEX `mt_author_summary_class_vchar` (`author_summary_class`, `author_summary_vchar_idx`),
  INDEX `mt_author_summary_class_vint` (`author_summary_class`, `author_summary_vinteger_idx`),
  INDEX `mt_author_summary_id_class` (`author_summary_author_id`, `author_summary_class`),
  PRIMARY KEY (`author_summary_author_id`, `author_summary_type`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_awesome`;

--
-- Table: `mt_awesome`
--
CREATE TABLE `mt_awesome` (
  `awesome_class` varchar(255) NULL DEFAULT 'foo',
  `awesome_file` varchar(255) NULL DEFAULT NULL,
  `awesome_id` integer(11) NOT NULL auto_increment,
  `awesome_title` varchar(255) NULL DEFAULT NULL,
  INDEX `mt_awesome_class` (`awesome_class`),
  PRIMARY KEY (`awesome_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_awesome_meta`;

--
-- Table: `mt_awesome_meta`
--
CREATE TABLE `mt_awesome_meta` (
  `awesome_meta_awesome_id` integer(11) NOT NULL,
  `awesome_meta_type` varchar(75) NOT NULL,
  `awesome_meta_vblob` mediumblob NULL,
  `awesome_meta_vchar` varchar(255) NULL DEFAULT NULL,
  `awesome_meta_vchar_idx` varchar(255) NULL DEFAULT NULL,
  `awesome_meta_vclob` mediumtext NULL,
  `awesome_meta_vdatetime` datetime NULL DEFAULT NULL,
  `awesome_meta_vdatetime_idx` datetime NULL DEFAULT NULL,
  `awesome_meta_vfloat` float NULL DEFAULT NULL,
  `awesome_meta_vfloat_idx` float NULL DEFAULT NULL,
  `awesome_meta_vinteger` integer(11) NULL DEFAULT NULL,
  `awesome_meta_vinteger_idx` integer(11) NULL DEFAULT NULL,
  INDEX `mt_awesome_meta_type_vchar` (`awesome_meta_type`, `awesome_meta_vchar_idx`),
  INDEX `mt_awesome_meta_type_vdt` (`awesome_meta_type`, `awesome_meta_vdatetime_idx`),
  INDEX `mt_awesome_meta_type_vflt` (`awesome_meta_type`, `awesome_meta_vfloat_idx`),
  INDEX `mt_awesome_meta_type_vint` (`awesome_meta_type`, `awesome_meta_vinteger_idx`),
  PRIMARY KEY (`awesome_meta_awesome_id`, `awesome_meta_type`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_blog`;

--
-- Table: `mt_blog`
--
CREATE TABLE `mt_blog` (
  `blog_allow_anon_comments` tinyint(4) NULL DEFAULT NULL,
  `blog_allow_comment_html` tinyint(4) NULL DEFAULT NULL,
  `blog_allow_commenter_regist` tinyint(4) NULL DEFAULT NULL,
  `blog_allow_comments_default` tinyint(4) NULL DEFAULT NULL,
  `blog_allow_pings` tinyint(4) NULL DEFAULT NULL,
  `blog_allow_pings_default` tinyint(4) NULL DEFAULT NULL,
  `blog_allow_reg_comments` tinyint(4) NULL DEFAULT NULL,
  `blog_allow_unreg_comments` tinyint(4) NULL DEFAULT NULL,
  `blog_archive_path` varchar(255) NULL DEFAULT NULL,
  `blog_archive_tmpl_category` varchar(255) NULL DEFAULT NULL,
  `blog_archive_tmpl_daily` varchar(255) NULL DEFAULT NULL,
  `blog_archive_tmpl_individual` varchar(255) NULL DEFAULT NULL,
  `blog_archive_tmpl_monthly` varchar(255) NULL DEFAULT NULL,
  `blog_archive_tmpl_weekly` varchar(255) NULL DEFAULT NULL,
  `blog_archive_type` text NULL DEFAULT NULL,
  `blog_archive_type_preferred` varchar(50) NULL DEFAULT NULL,
  `blog_archive_url` varchar(255) NULL DEFAULT NULL,
  `blog_autodiscover_links` tinyint(4) NULL DEFAULT NULL,
  `blog_autolink_urls` tinyint(4) NULL DEFAULT NULL,
  `blog_basename_limit` smallint(6) NULL DEFAULT NULL,
  `blog_cc_license` varchar(255) NULL DEFAULT NULL,
  `blog_children_modified_on` datetime NULL DEFAULT NULL,
  `blog_class` varchar(255) NULL DEFAULT 'blog',
  `blog_content_css` varchar(255) NULL DEFAULT NULL,
  `blog_convert_paras` varchar(30) NULL DEFAULT NULL,
  `blog_convert_paras_comments` varchar(30) NULL DEFAULT NULL,
  `blog_created_by` integer(11) NULL DEFAULT NULL,
  `blog_created_on` datetime NULL DEFAULT NULL,
  `blog_custom_dynamic_templates` varchar(25) NULL DEFAULT 'none',
  `blog_date_language` varchar(5) NULL DEFAULT NULL,
  `blog_days_on_index` integer(11) NULL DEFAULT NULL,
  `blog_description` mediumtext NULL,
  `blog_email_new_comments` tinyint(4) NULL DEFAULT NULL,
  `blog_email_new_pings` tinyint(4) NULL DEFAULT NULL,
  `blog_entries_on_index` integer(11) NULL DEFAULT NULL,
  `blog_file_extension` varchar(10) NULL DEFAULT NULL,
  `blog_google_api_key` varchar(32) NULL DEFAULT NULL,
  `blog_id` integer(11) NOT NULL auto_increment,
  `blog_internal_autodiscovery` tinyint(4) NULL DEFAULT NULL,
  `blog_is_dynamic` tinyint(4) NULL DEFAULT NULL,
  `blog_junk_folder_expiry` integer(11) NULL DEFAULT NULL,
  `blog_junk_score_threshold` float NULL DEFAULT NULL,
  `blog_language` varchar(5) NULL DEFAULT NULL,
  `blog_manual_approve_commenters` tinyint(4) NULL DEFAULT NULL,
  `blog_moderate_pings` tinyint(4) NULL DEFAULT NULL,
  `blog_moderate_unreg_comments` tinyint(4) NULL DEFAULT NULL,
  `blog_modified_by` integer(11) NULL DEFAULT NULL,
  `blog_modified_on` datetime NULL DEFAULT NULL,
  `blog_mt_update_key` varchar(30) NULL DEFAULT NULL,
  `blog_name` varchar(255) NOT NULL,
  `blog_old_style_archive_links` tinyint(4) NULL DEFAULT NULL,
  `blog_parent_id` integer(11) NULL DEFAULT NULL,
  `blog_ping_blogs` tinyint(4) NULL DEFAULT NULL,
  `blog_ping_google` tinyint(4) NULL DEFAULT NULL,
  `blog_ping_others` mediumtext NULL,
  `blog_ping_technorati` tinyint(4) NULL DEFAULT NULL,
  `blog_ping_weblogs` tinyint(4) NULL DEFAULT NULL,
  `blog_remote_auth_token` varchar(50) NULL DEFAULT NULL,
  `blog_require_comment_emails` tinyint(4) NULL DEFAULT NULL,
  `blog_sanitize_spec` varchar(255) NULL DEFAULT NULL,
  `blog_server_offset` float NULL DEFAULT NULL,
  `blog_site_path` varchar(255) NULL DEFAULT NULL,
  `blog_site_url` varchar(255) NULL DEFAULT NULL,
  `blog_sort_order_comments` varchar(8) NULL DEFAULT NULL,
  `blog_sort_order_posts` varchar(8) NULL DEFAULT NULL,
  `blog_status_default` smallint(6) NULL DEFAULT NULL,
  `blog_theme_id` varchar(255) NULL DEFAULT NULL,
  `blog_use_comment_confirmation` tinyint(4) NULL DEFAULT NULL,
  `blog_use_revision` tinyint(4) NULL DEFAULT NULL,
  `blog_welcome_msg` mediumtext NULL,
  `blog_words_in_excerpt` smallint(6) NULL DEFAULT NULL,
  INDEX `mt_blog_class` (`blog_class`),
  INDEX `mt_blog_name` (`blog_name`),
  INDEX `mt_blog_parent_id` (`blog_parent_id`),
  PRIMARY KEY (`blog_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_blog_meta`;

--
-- Table: `mt_blog_meta`
--
CREATE TABLE `mt_blog_meta` (
  `blog_meta_blog_id` integer(11) NOT NULL,
  `blog_meta_type` varchar(75) NOT NULL,
  `blog_meta_vblob` mediumblob NULL,
  `blog_meta_vchar` varchar(255) NULL DEFAULT NULL,
  `blog_meta_vchar_idx` varchar(255) NULL DEFAULT NULL,
  `blog_meta_vclob` mediumtext NULL,
  `blog_meta_vdatetime` datetime NULL DEFAULT NULL,
  `blog_meta_vdatetime_idx` datetime NULL DEFAULT NULL,
  `blog_meta_vfloat` float NULL DEFAULT NULL,
  `blog_meta_vfloat_idx` float NULL DEFAULT NULL,
  `blog_meta_vinteger` integer(11) NULL DEFAULT NULL,
  `blog_meta_vinteger_idx` integer(11) NULL DEFAULT NULL,
  INDEX `mt_blog_meta_type_vchar` (`blog_meta_type`, `blog_meta_vchar_idx`),
  INDEX `mt_blog_meta_type_vdt` (`blog_meta_type`, `blog_meta_vdatetime_idx`),
  INDEX `mt_blog_meta_type_vflt` (`blog_meta_type`, `blog_meta_vfloat_idx`),
  INDEX `mt_blog_meta_type_vint` (`blog_meta_type`, `blog_meta_vinteger_idx`),
  PRIMARY KEY (`blog_meta_blog_id`, `blog_meta_type`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_category`;

--
-- Table: `mt_category`
--
CREATE TABLE `mt_category` (
  `category_allow_pings` tinyint(4) NULL DEFAULT 0,
  `category_author_id` integer(11) NULL DEFAULT NULL,
  `category_basename` varchar(255) NULL DEFAULT NULL,
  `category_blog_id` integer(11) NOT NULL,
  `category_category_set_id` integer(11) NOT NULL DEFAULT 0,
  `category_class` varchar(255) NULL DEFAULT 'category',
  `category_created_by` integer(11) NULL DEFAULT NULL,
  `category_created_on` datetime NULL DEFAULT NULL,
  `category_description` mediumtext NULL,
  `category_id` integer(11) NOT NULL auto_increment,
  `category_label` varchar(100) NOT NULL,
  `category_modified_by` integer(11) NULL DEFAULT NULL,
  `category_modified_on` datetime NULL DEFAULT NULL,
  `category_parent` integer(11) NULL DEFAULT 0,
  `category_ping_urls` mediumtext NULL,
  INDEX `mt_category_blog_basename` (`category_blog_id`, `category_basename`),
  INDEX `mt_category_blog_class` (`category_blog_id`, `category_class`),
  INDEX `mt_category_blog_id` (`category_blog_id`),
  INDEX `mt_category_class` (`category_class`),
  INDEX `mt_category_label` (`category_label`),
  INDEX `mt_category_parent` (`category_parent`),
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_category_meta`;

--
-- Table: `mt_category_meta`
--
CREATE TABLE `mt_category_meta` (
  `category_meta_category_id` integer(11) NOT NULL,
  `category_meta_type` varchar(75) NOT NULL,
  `category_meta_vblob` mediumblob NULL,
  `category_meta_vchar` varchar(255) NULL DEFAULT NULL,
  `category_meta_vchar_idx` varchar(255) NULL DEFAULT NULL,
  `category_meta_vclob` mediumtext NULL,
  `category_meta_vdatetime` datetime NULL DEFAULT NULL,
  `category_meta_vdatetime_idx` datetime NULL DEFAULT NULL,
  `category_meta_vfloat` float NULL DEFAULT NULL,
  `category_meta_vfloat_idx` float NULL DEFAULT NULL,
  `category_meta_vinteger` integer(11) NULL DEFAULT NULL,
  `category_meta_vinteger_idx` integer(11) NULL DEFAULT NULL,
  INDEX `mt_category_meta_type_vchar` (`category_meta_type`, `category_meta_vchar_idx`),
  INDEX `mt_category_meta_type_vdt` (`category_meta_type`, `category_meta_vdatetime_idx`),
  INDEX `mt_category_meta_type_vflt` (`category_meta_type`, `category_meta_vfloat_idx`),
  INDEX `mt_category_meta_type_vint` (`category_meta_type`, `category_meta_vinteger_idx`),
  PRIMARY KEY (`category_meta_category_id`, `category_meta_type`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_category_set`;

--
-- Table: `mt_category_set`
--
CREATE TABLE `mt_category_set` (
  `category_set_blog_id` integer(11) NOT NULL,
  `category_set_cat_count` integer(11) NOT NULL DEFAULT 0,
  `category_set_created_by` integer(11) NULL DEFAULT NULL,
  `category_set_created_on` datetime NULL DEFAULT NULL,
  `category_set_ct_count` integer(11) NOT NULL DEFAULT 0,
  `category_set_id` integer(11) NOT NULL auto_increment,
  `category_set_modified_by` integer(11) NULL DEFAULT NULL,
  `category_set_modified_on` datetime NULL DEFAULT NULL,
  `category_set_name` varchar(255) NOT NULL DEFAULT '',
  `category_set_order` mediumtext NULL,
  INDEX `mt_category_set_blog_id` (`category_set_blog_id`),
  INDEX `mt_category_set_name` (`category_set_name`),
  PRIMARY KEY (`category_set_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_cd`;

--
-- Table: `mt_cd`
--
CREATE TABLE `mt_cd` (
  `cd_author_id` integer(11) NOT NULL,
  `cd_authored_on` datetime NULL DEFAULT NULL,
  `cd_blog_id` integer(11) NOT NULL,
  `cd_class` varchar(255) NULL DEFAULT 'content_data',
  `cd_content_type_id` integer(11) NOT NULL,
  `cd_created_by` integer(11) NULL DEFAULT NULL,
  `cd_created_on` datetime NULL DEFAULT NULL,
  `cd_ct_unique_id` varchar(40) NOT NULL,
  `cd_current_revision` integer(11) NOT NULL DEFAULT 0,
  `cd_data` mediumblob NULL,
  `cd_id` integer(11) NOT NULL auto_increment,
  `cd_identifier` varchar(255) NULL DEFAULT NULL,
  `cd_modified_by` integer(11) NULL DEFAULT NULL,
  `cd_modified_on` datetime NULL DEFAULT NULL,
  `cd_status` smallint(6) NOT NULL,
  `cd_unique_id` varchar(40) NOT NULL,
  `cd_unpublished_on` datetime NULL DEFAULT NULL,
  `cd_week_number` integer(11) NULL DEFAULT NULL,
  INDEX `mt_cd_class` (`cd_class`),
  INDEX `mt_cd_content_type_id` (`cd_content_type_id`),
  INDEX `mt_cd_ct_unique_id` (`cd_ct_unique_id`),
  INDEX `mt_cd_site_author` (`cd_author_id`, `cd_authored_on`, `cd_blog_id`, `cd_ct_unique_id`),
  INDEX `mt_cd_status` (`cd_status`),
  PRIMARY KEY (`cd_id`),
  UNIQUE `mt_cd_unique_id` (`cd_unique_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_cd_meta`;

--
-- Table: `mt_cd_meta`
--
CREATE TABLE `mt_cd_meta` (
  `cd_meta_cd_id` integer(11) NOT NULL,
  `cd_meta_type` varchar(75) NOT NULL,
  `cd_meta_vblob` mediumblob NULL,
  `cd_meta_vchar` varchar(255) NULL DEFAULT NULL,
  `cd_meta_vchar_idx` varchar(255) NULL DEFAULT NULL,
  `cd_meta_vclob` mediumtext NULL,
  `cd_meta_vdatetime` datetime NULL DEFAULT NULL,
  `cd_meta_vdatetime_idx` datetime NULL DEFAULT NULL,
  `cd_meta_vfloat` float NULL DEFAULT NULL,
  `cd_meta_vfloat_idx` float NULL DEFAULT NULL,
  `cd_meta_vinteger` integer(11) NULL DEFAULT NULL,
  `cd_meta_vinteger_idx` integer(11) NULL DEFAULT NULL,
  INDEX `mt_cd_meta_type_vchar` (`cd_meta_type`, `cd_meta_vchar_idx`),
  INDEX `mt_cd_meta_type_vdt` (`cd_meta_type`, `cd_meta_vdatetime_idx`),
  INDEX `mt_cd_meta_type_vflt` (`cd_meta_type`, `cd_meta_vfloat_idx`),
  INDEX `mt_cd_meta_type_vint` (`cd_meta_type`, `cd_meta_vinteger_idx`),
  PRIMARY KEY (`cd_meta_cd_id`, `cd_meta_type`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_cd_rev`;

--
-- Table: `mt_cd_rev`
--
CREATE TABLE `mt_cd_rev` (
  `cd_rev_cd` mediumblob NOT NULL,
  `cd_rev_cd_id` integer(11) NOT NULL,
  `cd_rev_changed` varchar(255) NOT NULL,
  `cd_rev_created_by` integer(11) NULL DEFAULT NULL,
  `cd_rev_created_on` datetime NULL DEFAULT NULL,
  `cd_rev_description` varchar(255) NULL DEFAULT NULL,
  `cd_rev_id` integer(11) NOT NULL auto_increment,
  `cd_rev_label` varchar(255) NULL DEFAULT NULL,
  `cd_rev_modified_by` integer(11) NULL DEFAULT NULL,
  `cd_rev_modified_on` datetime NULL DEFAULT NULL,
  `cd_rev_rev_number` integer(11) NOT NULL DEFAULT 0,
  INDEX `mt_cd_rev_cd_id` (`cd_rev_cd_id`),
  PRIMARY KEY (`cd_rev_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_cf`;

--
-- Table: `mt_cf`
--
CREATE TABLE `mt_cf` (
  `cf_blog_id` integer(11) NOT NULL,
  `cf_content_type_id` integer(11) NULL DEFAULT NULL,
  `cf_created_by` integer(11) NULL DEFAULT NULL,
  `cf_created_on` datetime NULL DEFAULT NULL,
  `cf_default` varchar(255) NULL DEFAULT NULL,
  `cf_description` varchar(255) NULL DEFAULT NULL,
  `cf_id` integer(11) NOT NULL auto_increment,
  `cf_modified_by` integer(11) NULL DEFAULT NULL,
  `cf_modified_on` datetime NULL DEFAULT NULL,
  `cf_name` varchar(255) NULL DEFAULT NULL,
  `cf_related_cat_set_id` integer(11) NULL DEFAULT NULL,
  `cf_related_content_type_id` integer(11) NULL DEFAULT NULL,
  `cf_required` tinyint(4) NULL DEFAULT NULL,
  `cf_type` varchar(255) NULL DEFAULT NULL,
  `cf_unique_id` varchar(40) NOT NULL,
  INDEX `mt_cf_blog_id` (`cf_blog_id`),
  INDEX `mt_cf_content_type_id` (`cf_content_type_id`),
  PRIMARY KEY (`cf_id`),
  UNIQUE `mt_cf_unique_id` (`cf_unique_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_cf_idx`;

--
-- Table: `mt_cf_idx`
--
CREATE TABLE `mt_cf_idx` (
  `cf_idx_content_data_id` integer(11) NULL DEFAULT NULL,
  `cf_idx_content_field_id` integer(11) NULL DEFAULT NULL,
  `cf_idx_content_type_id` integer(11) NULL DEFAULT NULL,
  `cf_idx_created_by` integer(11) NULL DEFAULT NULL,
  `cf_idx_created_on` datetime NULL DEFAULT NULL,
  `cf_idx_id` integer(11) NOT NULL auto_increment,
  `cf_idx_modified_by` integer(11) NULL DEFAULT NULL,
  `cf_idx_modified_on` datetime NULL DEFAULT NULL,
  `cf_idx_value_blob` mediumblob NULL,
  `cf_idx_value_datetime` datetime NULL DEFAULT NULL,
  `cf_idx_value_float` float NULL DEFAULT NULL,
  `cf_idx_value_integer` integer(11) NULL DEFAULT NULL,
  `cf_idx_value_varchar` varchar(255) NULL DEFAULT NULL,
  INDEX `mt_cf_idx_value_datetime` (`cf_idx_value_datetime`),
  INDEX `mt_cf_idx_value_float` (`cf_idx_value_float`),
  INDEX `mt_cf_idx_value_integer` (`cf_idx_value_integer`),
  INDEX `mt_cf_idx_value_varchar` (`cf_idx_value_varchar`),
  PRIMARY KEY (`cf_idx_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_comment`;

--
-- Table: `mt_comment`
--
CREATE TABLE `mt_comment` (
  `comment_author` varchar(100) NULL DEFAULT NULL,
  `comment_blog_id` integer(11) NOT NULL,
  `comment_commenter_id` integer(11) NULL DEFAULT NULL,
  `comment_created_by` integer(11) NULL DEFAULT NULL,
  `comment_created_on` datetime NULL DEFAULT NULL,
  `comment_email` varchar(127) NULL DEFAULT NULL,
  `comment_entry_id` integer(11) NOT NULL,
  `comment_id` integer(11) NOT NULL auto_increment,
  `comment_ip` varchar(50) NULL DEFAULT NULL,
  `comment_junk_log` mediumtext NULL,
  `comment_junk_score` float NULL DEFAULT NULL,
  `comment_junk_status` smallint(6) NULL DEFAULT 1,
  `comment_last_moved_on` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `comment_modified_by` integer(11) NULL DEFAULT NULL,
  `comment_modified_on` datetime NULL DEFAULT NULL,
  `comment_parent_id` integer(11) NULL DEFAULT NULL,
  `comment_text` mediumtext NULL,
  `comment_url` varchar(255) NULL DEFAULT NULL,
  `comment_visible` tinyint(4) NULL DEFAULT NULL,
  INDEX `mt_comment_author` (`comment_author`),
  INDEX `mt_comment_blog_ip_date` (`comment_blog_id`, `comment_ip`, `comment_created_on`),
  INDEX `mt_comment_blog_junk_stat` (`comment_blog_id`, `comment_junk_status`, `comment_last_moved_on`),
  INDEX `mt_comment_blog_stat` (`comment_blog_id`, `comment_junk_status`, `comment_created_on`),
  INDEX `mt_comment_blog_url` (`comment_blog_id`, `comment_visible`, `comment_url`),
  INDEX `mt_comment_blog_visible` (`comment_blog_id`, `comment_visible`, `comment_created_on`, `comment_id`),
  INDEX `mt_comment_blog_visible_entry` (`comment_blog_id`, `comment_visible`, `comment_entry_id`),
  INDEX `mt_comment_commenter_id` (`comment_commenter_id`),
  INDEX `mt_comment_dd_coment_vis_mod` (`comment_visible`, `comment_modified_on`),
  INDEX `mt_comment_email` (`comment_email`),
  INDEX `mt_comment_entry_visible` (`comment_entry_id`, `comment_visible`, `comment_created_on`),
  INDEX `mt_comment_last_moved_on` (`comment_last_moved_on`),
  INDEX `mt_comment_visible_date` (`comment_visible`, `comment_created_on`),
  PRIMARY KEY (`comment_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_comment_meta`;

--
-- Table: `mt_comment_meta`
--
CREATE TABLE `mt_comment_meta` (
  `comment_meta_comment_id` integer(11) NOT NULL,
  `comment_meta_type` varchar(75) NOT NULL,
  `comment_meta_vblob` mediumblob NULL,
  `comment_meta_vchar` varchar(255) NULL DEFAULT NULL,
  `comment_meta_vchar_idx` varchar(255) NULL DEFAULT NULL,
  `comment_meta_vclob` mediumtext NULL,
  `comment_meta_vdatetime` datetime NULL DEFAULT NULL,
  `comment_meta_vdatetime_idx` datetime NULL DEFAULT NULL,
  `comment_meta_vfloat` float NULL DEFAULT NULL,
  `comment_meta_vfloat_idx` float NULL DEFAULT NULL,
  `comment_meta_vinteger` integer(11) NULL DEFAULT NULL,
  `comment_meta_vinteger_idx` integer(11) NULL DEFAULT NULL,
  INDEX `mt_comment_meta_type_vchar` (`comment_meta_type`, `comment_meta_vchar_idx`),
  INDEX `mt_comment_meta_type_vdt` (`comment_meta_type`, `comment_meta_vdatetime_idx`),
  INDEX `mt_comment_meta_type_vflt` (`comment_meta_type`, `comment_meta_vfloat_idx`),
  INDEX `mt_comment_meta_type_vint` (`comment_meta_type`, `comment_meta_vinteger_idx`),
  PRIMARY KEY (`comment_meta_comment_id`, `comment_meta_type`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_config`;

--
-- Table: `mt_config`
--
CREATE TABLE `mt_config` (
  `config_data` mediumtext NULL,
  `config_id` integer(11) NOT NULL auto_increment,
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_content_type`;

--
-- Table: `mt_content_type`
--
CREATE TABLE `mt_content_type` (
  `content_type_blog_id` integer(11) NOT NULL,
  `content_type_created_by` integer(11) NULL DEFAULT NULL,
  `content_type_created_on` datetime NULL DEFAULT NULL,
  `content_type_description` mediumtext NULL,
  `content_type_fields` mediumblob NULL,
  `content_type_id` integer(11) NOT NULL auto_increment,
  `content_type_modified_by` integer(11) NULL DEFAULT NULL,
  `content_type_modified_on` datetime NULL DEFAULT NULL,
  `content_type_name` varchar(255) NULL DEFAULT NULL,
  `content_type_unique_id` varchar(40) NOT NULL,
  `content_type_user_disp_option` tinyint(4) NULL DEFAULT NULL,
  `content_type_version` integer(11) NULL DEFAULT NULL,
  INDEX `mt_content_type_blog_id` (`content_type_blog_id`),
  PRIMARY KEY (`content_type_id`),
  UNIQUE `mt_content_type_unique_id` (`content_type_unique_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_entry`;

--
-- Table: `mt_entry`
--
CREATE TABLE `mt_entry` (
  `entry_allow_comments` tinyint(4) NULL DEFAULT NULL,
  `entry_allow_pings` tinyint(4) NULL DEFAULT NULL,
  `entry_atom_id` varchar(255) NULL DEFAULT NULL,
  `entry_author_id` integer(11) NOT NULL,
  `entry_authored_on` datetime NULL DEFAULT NULL,
  `entry_basename` varchar(255) NULL DEFAULT NULL,
  `entry_blog_id` integer(11) NOT NULL,
  `entry_category_id` integer(11) NULL DEFAULT NULL,
  `entry_class` varchar(255) NULL DEFAULT 'entry',
  `entry_comment_count` integer(11) NULL DEFAULT 0,
  `entry_convert_breaks` varchar(60) NULL DEFAULT NULL,
  `entry_created_by` integer(11) NULL DEFAULT NULL,
  `entry_created_on` datetime NULL DEFAULT NULL,
  `entry_current_revision` integer(11) NOT NULL DEFAULT 0,
  `entry_excerpt` mediumtext NULL,
  `entry_id` integer(11) NOT NULL auto_increment,
  `entry_keywords` mediumtext NULL,
  `entry_modified_by` integer(11) NULL DEFAULT NULL,
  `entry_modified_on` datetime NULL DEFAULT NULL,
  `entry_ping_count` integer(11) NULL DEFAULT 0,
  `entry_pinged_urls` mediumtext NULL,
  `entry_status` smallint(6) NOT NULL,
  `entry_tangent_cache` mediumtext NULL,
  `entry_template_id` integer(11) NULL DEFAULT NULL,
  `entry_text` mediumtext NULL,
  `entry_text_more` mediumtext NULL,
  `entry_title` varchar(255) NULL DEFAULT NULL,
  `entry_to_ping_urls` mediumtext NULL,
  `entry_unpublished_on` datetime NULL DEFAULT NULL,
  `entry_week_number` integer(11) NULL DEFAULT NULL,
  INDEX `mt_entry_auth_stat_class` (`entry_author_id`, `entry_status`, `entry_class`),
  INDEX `mt_entry_author_id` (`entry_author_id`),
  INDEX `mt_entry_blog_author` (`entry_blog_id`, `entry_class`, `entry_author_id`, `entry_authored_on`),
  INDEX `mt_entry_blog_authored` (`entry_blog_id`, `entry_class`, `entry_authored_on`),
  INDEX `mt_entry_blog_basename` (`entry_blog_id`, `entry_basename`),
  INDEX `mt_entry_blog_stat_date` (`entry_blog_id`, `entry_class`, `entry_status`, `entry_authored_on`, `entry_id`),
  INDEX `mt_entry_blog_unpublished` (`entry_blog_id`, `entry_class`, `entry_unpublished_on`),
  INDEX `mt_entry_blog_week` (`entry_blog_id`, `entry_class`, `entry_status`, `entry_week_number`),
  INDEX `mt_entry_class` (`entry_class`),
  INDEX `mt_entry_class_authored` (`entry_class`, `entry_authored_on`),
  INDEX `mt_entry_class_unpublished` (`entry_class`, `entry_unpublished_on`),
  INDEX `mt_entry_comment_count` (`entry_comment_count`),
  INDEX `mt_entry_created_on` (`entry_created_on`),
  INDEX `mt_entry_dd_entry_tag_count` (`entry_blog_id`, `entry_status`, `entry_class`, `entry_id`),
  INDEX `mt_entry_modified_on` (`entry_modified_on`),
  INDEX `mt_entry_status` (`entry_status`),
  INDEX `mt_entry_tag_count` (`entry_status`, `entry_class`, `entry_blog_id`, `entry_id`),
  INDEX `mt_entry_title` (`entry_title`),
  PRIMARY KEY (`entry_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_entry_meta`;

--
-- Table: `mt_entry_meta`
--
CREATE TABLE `mt_entry_meta` (
  `entry_meta_entry_id` integer(11) NOT NULL,
  `entry_meta_type` varchar(75) NOT NULL,
  `entry_meta_vblob` mediumblob NULL,
  `entry_meta_vchar` varchar(255) NULL DEFAULT NULL,
  `entry_meta_vchar_idx` varchar(255) NULL DEFAULT NULL,
  `entry_meta_vclob` mediumtext NULL,
  `entry_meta_vdatetime` datetime NULL DEFAULT NULL,
  `entry_meta_vdatetime_idx` datetime NULL DEFAULT NULL,
  `entry_meta_vfloat` float NULL DEFAULT NULL,
  `entry_meta_vfloat_idx` float NULL DEFAULT NULL,
  `entry_meta_vinteger` integer(11) NULL DEFAULT NULL,
  `entry_meta_vinteger_idx` integer(11) NULL DEFAULT NULL,
  INDEX `mt_entry_meta_type_vchar` (`entry_meta_type`, `entry_meta_vchar_idx`),
  INDEX `mt_entry_meta_type_vdt` (`entry_meta_type`, `entry_meta_vdatetime_idx`),
  INDEX `mt_entry_meta_type_vflt` (`entry_meta_type`, `entry_meta_vfloat_idx`),
  INDEX `mt_entry_meta_type_vint` (`entry_meta_type`, `entry_meta_vinteger_idx`),
  PRIMARY KEY (`entry_meta_entry_id`, `entry_meta_type`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_entry_rev`;

--
-- Table: `mt_entry_rev`
--
CREATE TABLE `mt_entry_rev` (
  `entry_rev_changed` varchar(255) NOT NULL,
  `entry_rev_created_by` integer(11) NULL DEFAULT NULL,
  `entry_rev_created_on` datetime NULL DEFAULT NULL,
  `entry_rev_description` varchar(255) NULL DEFAULT NULL,
  `entry_rev_entry` mediumblob NOT NULL,
  `entry_rev_entry_id` integer(11) NOT NULL,
  `entry_rev_id` integer(11) NOT NULL auto_increment,
  `entry_rev_label` varchar(255) NULL DEFAULT NULL,
  `entry_rev_modified_by` integer(11) NULL DEFAULT NULL,
  `entry_rev_modified_on` datetime NULL DEFAULT NULL,
  `entry_rev_rev_number` integer(11) NOT NULL DEFAULT 0,
  INDEX `mt_entry_rev_entry_id` (`entry_rev_entry_id`),
  PRIMARY KEY (`entry_rev_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_entry_summary`;

--
-- Table: `mt_entry_summary`
--
CREATE TABLE `mt_entry_summary` (
  `entry_summary_class` varchar(75) NOT NULL,
  `entry_summary_entry_id` integer(11) NOT NULL,
  `entry_summary_expired` smallint(6) NULL DEFAULT NULL,
  `entry_summary_type` varchar(75) NOT NULL,
  `entry_summary_vblob` mediumblob NULL,
  `entry_summary_vchar_idx` varchar(255) NULL DEFAULT NULL,
  `entry_summary_vclob` mediumtext NULL,
  `entry_summary_vinteger_idx` integer(11) NULL DEFAULT NULL,
  INDEX `mt_entry_summary_class_vchar` (`entry_summary_class`, `entry_summary_vchar_idx`),
  INDEX `mt_entry_summary_class_vint` (`entry_summary_class`, `entry_summary_vinteger_idx`),
  INDEX `mt_entry_summary_id_class` (`entry_summary_entry_id`, `entry_summary_class`),
  PRIMARY KEY (`entry_summary_entry_id`, `entry_summary_type`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_failedlogin`;

--
-- Table: `mt_failedlogin`
--
CREATE TABLE `mt_failedlogin` (
  `failedlogin_author_id` integer(11) NULL DEFAULT NULL,
  `failedlogin_id` integer(11) NOT NULL auto_increment,
  `failedlogin_ip_locked` tinyint(4) NULL DEFAULT 0,
  `failedlogin_remote_ip` varchar(60) NULL DEFAULT NULL,
  `failedlogin_start` integer(11) NOT NULL,
  INDEX `mt_failedlogin_author_id` (`failedlogin_author_id`),
  INDEX `mt_failedlogin_author_start` (`failedlogin_author_id`, `failedlogin_start`),
  INDEX `mt_failedlogin_ip_locked` (`failedlogin_ip_locked`),
  INDEX `mt_failedlogin_ip_start` (`failedlogin_remote_ip`, `failedlogin_start`),
  INDEX `mt_failedlogin_remote_ip` (`failedlogin_remote_ip`),
  INDEX `mt_failedlogin_start` (`failedlogin_start`),
  PRIMARY KEY (`failedlogin_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_field`;

--
-- Table: `mt_field`
--
CREATE TABLE `mt_field` (
  `field_basename` varchar(255) NULL DEFAULT NULL,
  `field_blog_id` integer(11) NULL DEFAULT NULL,
  `field_default` mediumtext NULL,
  `field_description` mediumtext NULL,
  `field_id` integer(11) NOT NULL auto_increment,
  `field_name` varchar(255) NOT NULL,
  `field_obj_type` varchar(50) NOT NULL,
  `field_options` mediumtext NULL,
  `field_required` tinyint(4) NULL DEFAULT NULL,
  `field_tag` varchar(255) NOT NULL,
  `field_type` varchar(50) NOT NULL,
  INDEX `mt_field_basename` (`field_basename`),
  INDEX `mt_field_blog_id` (`field_blog_id`),
  INDEX `mt_field_blog_tag` (`field_blog_id`, `field_tag`),
  INDEX `mt_field_name` (`field_name`),
  INDEX `mt_field_obj_type` (`field_obj_type`),
  INDEX `mt_field_type` (`field_type`),
  PRIMARY KEY (`field_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_fileinfo`;

--
-- Table: `mt_fileinfo`
--
CREATE TABLE `mt_fileinfo` (
  `fileinfo_archive_type` varchar(255) NULL DEFAULT NULL,
  `fileinfo_author_id` integer(11) NULL DEFAULT NULL,
  `fileinfo_blog_id` integer(11) NOT NULL,
  `fileinfo_category_id` integer(11) NULL DEFAULT NULL,
  `fileinfo_entry_id` integer(11) NULL DEFAULT NULL,
  `fileinfo_file_path` mediumtext NULL,
  `fileinfo_id` integer(11) NOT NULL auto_increment,
  `fileinfo_startdate` varchar(80) NULL DEFAULT NULL,
  `fileinfo_template_id` integer(11) NULL DEFAULT NULL,
  `fileinfo_templatemap_id` integer(11) NULL DEFAULT NULL,
  `fileinfo_url` varchar(255) NULL DEFAULT NULL,
  `fileinfo_virtual` tinyint(4) NULL DEFAULT NULL,
  INDEX `mt_fileinfo_archive_type` (`fileinfo_archive_type`),
  INDEX `mt_fileinfo_author_id` (`fileinfo_author_id`),
  INDEX `mt_fileinfo_blog_id` (`fileinfo_blog_id`),
  INDEX `mt_fileinfo_category_id` (`fileinfo_category_id`),
  INDEX `mt_fileinfo_entry_id` (`fileinfo_entry_id`),
  INDEX `mt_fileinfo_startdate` (`fileinfo_startdate`),
  INDEX `mt_fileinfo_template_id` (`fileinfo_template_id`),
  INDEX `mt_fileinfo_templatemap_id` (`fileinfo_templatemap_id`),
  INDEX `mt_fileinfo_url` (`fileinfo_url`),
  PRIMARY KEY (`fileinfo_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_filter`;

--
-- Table: `mt_filter`
--
CREATE TABLE `mt_filter` (
  `filter_author_id` integer(11) NOT NULL,
  `filter_blog_id` integer(11) NOT NULL,
  `filter_created_by` integer(11) NULL DEFAULT NULL,
  `filter_created_on` datetime NULL DEFAULT NULL,
  `filter_id` integer(11) NOT NULL auto_increment,
  `filter_items` mediumblob NULL,
  `filter_label` varchar(255) NULL DEFAULT NULL,
  `filter_modified_by` integer(11) NULL DEFAULT NULL,
  `filter_modified_on` datetime NULL DEFAULT NULL,
  `filter_object_ds` varchar(255) NULL DEFAULT NULL,
  INDEX `mt_filter_author_ds` (`filter_author_id`, `filter_object_ds`),
  INDEX `mt_filter_author_id` (`filter_author_id`),
  INDEX `mt_filter_created_on` (`filter_created_on`),
  INDEX `mt_filter_label` (`filter_label`),
  INDEX `mt_filter_modified_on` (`filter_modified_on`),
  PRIMARY KEY (`filter_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_formatted_text`;

--
-- Table: `mt_formatted_text`
--
CREATE TABLE `mt_formatted_text` (
  `formatted_text_blog_id` integer(11) NOT NULL,
  `formatted_text_created_by` integer(11) NULL DEFAULT NULL,
  `formatted_text_created_on` datetime NULL DEFAULT NULL,
  `formatted_text_description` varchar(255) NULL DEFAULT NULL,
  `formatted_text_id` integer(11) NOT NULL auto_increment,
  `formatted_text_label` varchar(255) NULL DEFAULT NULL,
  `formatted_text_modified_by` integer(11) NULL DEFAULT NULL,
  `formatted_text_modified_on` datetime NULL DEFAULT NULL,
  `formatted_text_text` mediumtext NULL,
  INDEX `mt_formatted_text_blog_c_by` (`formatted_text_blog_id`, `formatted_text_created_by`),
  INDEX `mt_formatted_text_blog_id` (`formatted_text_blog_id`),
  INDEX `mt_formatted_text_created_on` (`formatted_text_created_on`),
  INDEX `mt_formatted_text_label` (`formatted_text_label`),
  INDEX `mt_formatted_text_modified_on` (`formatted_text_modified_on`),
  PRIMARY KEY (`formatted_text_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_group`;

--
-- Table: `mt_group`
--
CREATE TABLE `mt_group` (
  `group_created_by` integer(11) NULL DEFAULT NULL,
  `group_created_on` datetime NULL DEFAULT NULL,
  `group_description` mediumtext NULL,
  `group_display_name` varchar(255) NULL DEFAULT NULL,
  `group_external_id` varchar(255) NULL DEFAULT NULL,
  `group_id` integer(11) NOT NULL auto_increment,
  `group_modified_by` integer(11) NULL DEFAULT NULL,
  `group_modified_on` datetime NULL DEFAULT NULL,
  `group_name` varchar(255) NOT NULL,
  `group_status` integer(11) NULL DEFAULT 1,
  INDEX `mt_group_created_on` (`group_created_on`),
  INDEX `mt_group_external_id` (`group_external_id`),
  INDEX `mt_group_name` (`group_name`),
  INDEX `mt_group_status` (`group_status`),
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_ipbanlist`;

--
-- Table: `mt_ipbanlist`
--
CREATE TABLE `mt_ipbanlist` (
  `ipbanlist_blog_id` integer(11) NOT NULL,
  `ipbanlist_created_by` integer(11) NULL DEFAULT NULL,
  `ipbanlist_created_on` datetime NULL DEFAULT NULL,
  `ipbanlist_id` integer(11) NOT NULL auto_increment,
  `ipbanlist_ip` varchar(50) NOT NULL,
  `ipbanlist_modified_by` integer(11) NULL DEFAULT NULL,
  `ipbanlist_modified_on` datetime NULL DEFAULT NULL,
  INDEX `mt_ipbanlist_blog_id` (`ipbanlist_blog_id`),
  INDEX `mt_ipbanlist_ip` (`ipbanlist_ip`),
  PRIMARY KEY (`ipbanlist_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_log`;

--
-- Table: `mt_log`
--
CREATE TABLE `mt_log` (
  `log_author_id` integer(11) NULL DEFAULT 0,
  `log_blog_id` integer(11) NULL DEFAULT 0,
  `log_category` varchar(255) NULL DEFAULT NULL,
  `log_class` varchar(255) NULL DEFAULT 'system',
  `log_created_by` integer(11) NULL DEFAULT NULL,
  `log_created_on` datetime NULL DEFAULT NULL,
  `log_id` integer(11) NOT NULL auto_increment,
  `log_ip` varchar(50) NULL DEFAULT NULL,
  `log_level` integer(11) NULL DEFAULT 1,
  `log_message` mediumtext NULL,
  `log_metadata` mediumtext NULL,
  `log_modified_by` integer(11) NULL DEFAULT NULL,
  `log_modified_on` datetime NULL DEFAULT NULL,
  INDEX `mt_log_blog_id` (`log_blog_id`),
  INDEX `mt_log_class` (`log_class`),
  INDEX `mt_log_created_on` (`log_created_on`),
  INDEX `mt_log_level` (`log_level`),
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_notification`;

--
-- Table: `mt_notification`
--
CREATE TABLE `mt_notification` (
  `notification_blog_id` integer(11) NOT NULL,
  `notification_created_by` integer(11) NULL DEFAULT NULL,
  `notification_created_on` datetime NULL DEFAULT NULL,
  `notification_email` varchar(75) NULL DEFAULT NULL,
  `notification_id` integer(11) NOT NULL auto_increment,
  `notification_modified_by` integer(11) NULL DEFAULT NULL,
  `notification_modified_on` datetime NULL DEFAULT NULL,
  `notification_name` varchar(50) NULL DEFAULT NULL,
  `notification_url` varchar(255) NULL DEFAULT NULL,
  INDEX `mt_notification_blog_id` (`notification_blog_id`),
  INDEX `mt_notification_email` (`notification_email`),
  PRIMARY KEY (`notification_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_objectasset`;

--
-- Table: `mt_objectasset`
--
CREATE TABLE `mt_objectasset` (
  `objectasset_asset_id` integer(11) NOT NULL,
  `objectasset_blog_id` integer(11) NULL DEFAULT NULL,
  `objectasset_cf_id` integer(11) NOT NULL DEFAULT 0,
  `objectasset_embedded` tinyint(4) NULL DEFAULT 0,
  `objectasset_id` integer(11) NOT NULL auto_increment,
  `objectasset_object_ds` varchar(50) NOT NULL,
  `objectasset_object_id` integer(11) NOT NULL,
  INDEX `mt_objectasset_asset_id` (`objectasset_asset_id`),
  INDEX `mt_objectasset_blog_obj` (`objectasset_blog_id`, `objectasset_object_ds`, `objectasset_object_id`),
  INDEX `mt_objectasset_id_ds` (`objectasset_object_id`, `objectasset_object_ds`),
  PRIMARY KEY (`objectasset_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_objectcategory`;

--
-- Table: `mt_objectcategory`
--
CREATE TABLE `mt_objectcategory` (
  `objectcategory_blog_id` integer(11) NULL DEFAULT NULL,
  `objectcategory_category_id` integer(11) NOT NULL,
  `objectcategory_cf_id` integer(11) NOT NULL DEFAULT 0,
  `objectcategory_id` integer(11) NOT NULL auto_increment,
  `objectcategory_is_primary` tinyint(4) NOT NULL,
  `objectcategory_object_ds` varchar(50) NOT NULL,
  `objectcategory_object_id` integer(11) NOT NULL,
  INDEX `mt_objectcategory_blog_ds_obj` (`objectcategory_blog_id`, `objectcategory_object_ds`, `objectcategory_object_id`, `objectcategory_category_id`),
  INDEX `mt_objectcategory_blog_ds_tag` (`objectcategory_blog_id`, `objectcategory_object_ds`, `objectcategory_category_id`),
  INDEX `mt_objectcategory_category_id` (`objectcategory_category_id`),
  INDEX `mt_objectcategory_is_primary` (`objectcategory_is_primary`),
  INDEX `mt_objectcategory_object_ds` (`objectcategory_object_ds`),
  INDEX `mt_objectcategory_object_id` (`objectcategory_object_id`),
  PRIMARY KEY (`objectcategory_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_objectscore`;

--
-- Table: `mt_objectscore`
--
CREATE TABLE `mt_objectscore` (
  `objectscore_author_id` integer(11) NULL DEFAULT 0,
  `objectscore_created_by` integer(11) NULL DEFAULT NULL,
  `objectscore_created_on` datetime NULL DEFAULT NULL,
  `objectscore_id` integer(11) NOT NULL auto_increment,
  `objectscore_ip` varchar(50) NULL DEFAULT NULL,
  `objectscore_modified_by` integer(11) NULL DEFAULT NULL,
  `objectscore_modified_on` datetime NULL DEFAULT NULL,
  `objectscore_namespace` varchar(100) NOT NULL,
  `objectscore_object_ds` varchar(50) NOT NULL,
  `objectscore_object_id` integer(11) NULL DEFAULT 0,
  `objectscore_score` float NULL DEFAULT NULL,
  INDEX `mt_objectscore_ds_obj` (`objectscore_object_ds`, `objectscore_object_id`),
  INDEX `mt_objectscore_ns_ip_ds_obj` (`objectscore_namespace`, `objectscore_ip`, `objectscore_object_ds`, `objectscore_object_id`),
  INDEX `mt_objectscore_ns_user_ds_obj` (`objectscore_namespace`, `objectscore_author_id`, `objectscore_object_ds`, `objectscore_object_id`),
  INDEX `mt_objectscore_user_ns` (`objectscore_author_id`, `objectscore_namespace`),
  PRIMARY KEY (`objectscore_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_objecttag`;

--
-- Table: `mt_objecttag`
--
CREATE TABLE `mt_objecttag` (
  `objecttag_blog_id` integer(11) NULL DEFAULT NULL,
  `objecttag_cf_id` integer(11) NOT NULL DEFAULT 0,
  `objecttag_id` integer(11) NOT NULL auto_increment,
  `objecttag_object_datasource` varchar(50) NOT NULL,
  `objecttag_object_id` integer(11) NOT NULL,
  `objecttag_tag_id` integer(11) NOT NULL,
  INDEX `mt_objecttag_blog_ds_obj_tag` (`objecttag_blog_id`, `objecttag_object_datasource`, `objecttag_object_id`, `objecttag_tag_id`),
  INDEX `mt_objecttag_blog_ds_tag` (`objecttag_blog_id`, `objecttag_object_datasource`, `objecttag_tag_id`),
  INDEX `mt_objecttag_object_datasource` (`objecttag_object_datasource`),
  INDEX `mt_objecttag_object_id` (`objecttag_object_id`),
  INDEX `mt_objecttag_tag_id` (`objecttag_tag_id`),
  PRIMARY KEY (`objecttag_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_permission`;

--
-- Table: `mt_permission`
--
CREATE TABLE `mt_permission` (
  `permission_author_id` integer(11) NOT NULL DEFAULT 0,
  `permission_blog_id` integer(11) NOT NULL DEFAULT 0,
  `permission_blog_prefs` varchar(255) NULL DEFAULT NULL,
  `permission_created_by` integer(11) NULL DEFAULT NULL,
  `permission_created_on` datetime NULL DEFAULT NULL,
  `permission_entry_prefs` mediumtext NULL,
  `permission_id` integer(11) NOT NULL auto_increment,
  `permission_modified_by` integer(11) NULL DEFAULT NULL,
  `permission_modified_on` datetime NULL DEFAULT NULL,
  `permission_page_prefs` mediumtext NULL,
  `permission_permissions` mediumtext NULL,
  `permission_restrictions` mediumtext NULL,
  `permission_role_mask` integer(11) NULL DEFAULT 0,
  `permission_template_prefs` varchar(255) NULL DEFAULT NULL,
  INDEX `mt_permission_author_id` (`permission_author_id`),
  INDEX `mt_permission_blog_id` (`permission_blog_id`),
  INDEX `mt_permission_role_mask` (`permission_role_mask`),
  PRIMARY KEY (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_placement`;

--
-- Table: `mt_placement`
--
CREATE TABLE `mt_placement` (
  `placement_blog_id` integer(11) NOT NULL,
  `placement_category_id` integer(11) NOT NULL,
  `placement_entry_id` integer(11) NOT NULL,
  `placement_id` integer(11) NOT NULL auto_increment,
  `placement_is_primary` tinyint(4) NOT NULL,
  INDEX `mt_placement_blog_cat` (`placement_blog_id`, `placement_category_id`),
  INDEX `mt_placement_blog_id` (`placement_blog_id`),
  INDEX `mt_placement_category_id` (`placement_category_id`),
  INDEX `mt_placement_entry_id` (`placement_entry_id`),
  INDEX `mt_placement_is_primary` (`placement_is_primary`),
  PRIMARY KEY (`placement_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_plugindata`;

--
-- Table: `mt_plugindata`
--
CREATE TABLE `mt_plugindata` (
  `plugindata_data` mediumblob NULL,
  `plugindata_id` integer(11) NOT NULL auto_increment,
  `plugindata_key` varchar(255) NOT NULL,
  `plugindata_plugin` varchar(50) NOT NULL,
  INDEX `mt_plugindata_key` (`plugindata_key`),
  INDEX `mt_plugindata_plugin` (`plugindata_plugin`),
  PRIMARY KEY (`plugindata_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_role`;

--
-- Table: `mt_role`
--
CREATE TABLE `mt_role` (
  `role_created_by` integer(11) NULL DEFAULT NULL,
  `role_created_on` datetime NULL DEFAULT NULL,
  `role_description` mediumtext NULL,
  `role_id` integer(11) NOT NULL auto_increment,
  `role_is_system` tinyint(4) NULL DEFAULT 0,
  `role_modified_by` integer(11) NULL DEFAULT NULL,
  `role_modified_on` datetime NULL DEFAULT NULL,
  `role_name` varchar(255) NOT NULL,
  `role_permissions` mediumtext NULL,
  `role_role_mask` integer(11) NULL DEFAULT NULL,
  `role_role_mask2` integer(11) NULL DEFAULT NULL,
  `role_role_mask3` integer(11) NULL DEFAULT NULL,
  `role_role_mask4` integer(11) NULL DEFAULT NULL,
  INDEX `mt_role_created_on` (`role_created_on`),
  INDEX `mt_role_is_system` (`role_is_system`),
  INDEX `mt_role_name` (`role_name`),
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_session`;

--
-- Table: `mt_session`
--
CREATE TABLE `mt_session` (
  `session_data` mediumblob NULL,
  `session_duration` integer(11) NULL DEFAULT NULL,
  `session_email` varchar(255) NULL DEFAULT NULL,
  `session_id` varchar(80) NOT NULL,
  `session_kind` varchar(2) NULL DEFAULT NULL,
  `session_name` varchar(255) NULL DEFAULT NULL,
  `session_start` integer(11) NOT NULL,
  INDEX `mt_session_duration` (`session_duration`),
  INDEX `mt_session_kind` (`session_kind`),
  INDEX `mt_session_name` (`session_name`),
  INDEX `mt_session_start` (`session_start`),
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_sync_file_list`;

--
-- Table: `mt_sync_file_list`
--
CREATE TABLE `mt_sync_file_list` (
  `sync_file_list_blog_id` integer(11) NOT NULL,
  `sync_file_list_created_by` integer(11) NULL DEFAULT NULL,
  `sync_file_list_created_on` datetime NULL DEFAULT NULL,
  `sync_file_list_id` integer(11) NOT NULL auto_increment,
  `sync_file_list_is_dir` tinyint(4) NULL DEFAULT NULL,
  `sync_file_list_modified_by` integer(11) NULL DEFAULT NULL,
  `sync_file_list_modified_on` datetime NULL DEFAULT NULL,
  `sync_file_list_path` mediumtext NULL,
  `sync_file_list_sync_setting_id` integer(11) NOT NULL,
  `sync_file_list_timestamp` integer(11) NULL DEFAULT NULL,
  INDEX `mt_sync_file_list_blog_id` (`sync_file_list_blog_id`),
  INDEX `mt_sync_file_list_sync_set_id` (`sync_file_list_sync_setting_id`),
  PRIMARY KEY (`sync_file_list_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_sync_setting`;

--
-- Table: `mt_sync_setting`
--
CREATE TABLE `mt_sync_setting` (
  `sync_setting_avoid_dot_ht` tinyint(4) NULL DEFAULT NULL,
  `sync_setting_blog_id` integer(11) NOT NULL,
  `sync_setting_created_by` integer(11) NULL DEFAULT NULL,
  `sync_setting_created_on` datetime NULL DEFAULT NULL,
  `sync_setting_enable_sync` tinyint(4) NULL DEFAULT NULL,
  `sync_setting_id` integer(11) NOT NULL auto_increment,
  `sync_setting_metadata` mediumblob NULL,
  `sync_setting_modified_by` integer(11) NULL DEFAULT NULL,
  `sync_setting_modified_on` datetime NULL DEFAULT NULL,
  `sync_setting_name` varchar(255) NULL DEFAULT NULL,
  `sync_setting_notify_error_only` tinyint(4) NULL DEFAULT NULL,
  `sync_setting_notify_mail` varchar(255) NULL DEFAULT NULL,
  `sync_setting_schedule_date` datetime NULL DEFAULT NULL,
  INDEX `mt_sync_setting_blog_id` (`sync_setting_blog_id`),
  PRIMARY KEY (`sync_setting_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_tag`;

--
-- Table: `mt_tag`
--
CREATE TABLE `mt_tag` (
  `tag_id` integer(11) NOT NULL auto_increment,
  `tag_is_private` tinyint(4) NULL DEFAULT 0,
  `tag_n8d_id` integer(11) NULL DEFAULT 0,
  `tag_name` varchar(255) NOT NULL,
  INDEX `mt_tag_n8d_id` (`tag_n8d_id`),
  INDEX `mt_tag_name` (`tag_name`),
  INDEX `mt_tag_name_id` (`tag_name`, `tag_id`),
  INDEX `mt_tag_private_id_name` (`tag_is_private`, `tag_id`, `tag_name`),
  PRIMARY KEY (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_tbping`;

--
-- Table: `mt_tbping`
--
CREATE TABLE `mt_tbping` (
  `tbping_blog_id` integer(11) NOT NULL,
  `tbping_blog_name` varchar(255) NULL DEFAULT NULL,
  `tbping_created_by` integer(11) NULL DEFAULT NULL,
  `tbping_created_on` datetime NULL DEFAULT NULL,
  `tbping_excerpt` mediumtext NULL,
  `tbping_id` integer(11) NOT NULL auto_increment,
  `tbping_ip` varchar(50) NOT NULL,
  `tbping_junk_log` mediumtext NULL,
  `tbping_junk_score` float NULL DEFAULT NULL,
  `tbping_junk_status` smallint(6) NOT NULL DEFAULT 1,
  `tbping_last_moved_on` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `tbping_modified_by` integer(11) NULL DEFAULT NULL,
  `tbping_modified_on` datetime NULL DEFAULT NULL,
  `tbping_source_url` varchar(255) NULL DEFAULT NULL,
  `tbping_tb_id` integer(11) NOT NULL,
  `tbping_title` varchar(255) NULL DEFAULT NULL,
  `tbping_visible` tinyint(4) NULL DEFAULT NULL,
  INDEX `mt_tbping_blog_junk_stat` (`tbping_blog_id`, `tbping_junk_status`, `tbping_last_moved_on`),
  INDEX `mt_tbping_blog_stat` (`tbping_blog_id`, `tbping_junk_status`, `tbping_created_on`),
  INDEX `mt_tbping_blog_url` (`tbping_blog_id`, `tbping_visible`, `tbping_source_url`),
  INDEX `mt_tbping_blog_visible` (`tbping_blog_id`, `tbping_visible`, `tbping_created_on`, `tbping_id`),
  INDEX `mt_tbping_created_on` (`tbping_created_on`),
  INDEX `mt_tbping_ip` (`tbping_ip`),
  INDEX `mt_tbping_junk_date` (`tbping_junk_status`, `tbping_created_on`),
  INDEX `mt_tbping_last_moved_on` (`tbping_last_moved_on`),
  INDEX `mt_tbping_tb_visible` (`tbping_tb_id`, `tbping_visible`, `tbping_created_on`),
  INDEX `mt_tbping_visible_date` (`tbping_visible`, `tbping_created_on`),
  PRIMARY KEY (`tbping_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_tbping_meta`;

--
-- Table: `mt_tbping_meta`
--
CREATE TABLE `mt_tbping_meta` (
  `tbping_meta_tbping_id` integer(11) NOT NULL,
  `tbping_meta_type` varchar(75) NOT NULL,
  `tbping_meta_vblob` mediumblob NULL,
  `tbping_meta_vchar` varchar(255) NULL DEFAULT NULL,
  `tbping_meta_vchar_idx` varchar(255) NULL DEFAULT NULL,
  `tbping_meta_vclob` mediumtext NULL,
  `tbping_meta_vdatetime` datetime NULL DEFAULT NULL,
  `tbping_meta_vdatetime_idx` datetime NULL DEFAULT NULL,
  `tbping_meta_vfloat` float NULL DEFAULT NULL,
  `tbping_meta_vfloat_idx` float NULL DEFAULT NULL,
  `tbping_meta_vinteger` integer(11) NULL DEFAULT NULL,
  `tbping_meta_vinteger_idx` integer(11) NULL DEFAULT NULL,
  INDEX `mt_tbping_meta_type_vchar` (`tbping_meta_type`, `tbping_meta_vchar_idx`),
  INDEX `mt_tbping_meta_type_vdt` (`tbping_meta_type`, `tbping_meta_vdatetime_idx`),
  INDEX `mt_tbping_meta_type_vflt` (`tbping_meta_type`, `tbping_meta_vfloat_idx`),
  INDEX `mt_tbping_meta_type_vint` (`tbping_meta_type`, `tbping_meta_vinteger_idx`),
  PRIMARY KEY (`tbping_meta_tbping_id`, `tbping_meta_type`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_template`;

--
-- Table: `mt_template`
--
CREATE TABLE `mt_template` (
  `template_blog_id` integer(11) NOT NULL,
  `template_build_dynamic` tinyint(4) NULL DEFAULT NULL,
  `template_build_interval` integer(11) NULL DEFAULT NULL,
  `template_build_type` smallint(6) NULL DEFAULT NULL,
  `template_content_type_id` integer(11) NULL DEFAULT NULL,
  `template_created_by` integer(11) NULL DEFAULT NULL,
  `template_created_on` datetime NULL DEFAULT NULL,
  `template_current_revision` integer(11) NOT NULL DEFAULT 0,
  `template_id` integer(11) NOT NULL auto_increment,
  `template_identifier` varchar(50) NULL DEFAULT NULL,
  `template_linked_file` varchar(255) NULL DEFAULT NULL,
  `template_linked_file_mtime` varchar(10) NULL DEFAULT NULL,
  `template_linked_file_size` integer(11) NULL DEFAULT NULL,
  `template_modified_by` integer(11) NULL DEFAULT NULL,
  `template_modified_on` datetime NULL DEFAULT NULL,
  `template_name` varchar(255) NOT NULL,
  `template_outfile` varchar(255) NULL DEFAULT NULL,
  `template_rebuild_me` tinyint(4) NULL DEFAULT NULL,
  `template_text` mediumtext NULL,
  `template_type` varchar(25) NOT NULL,
  INDEX `mt_template_blog_id` (`template_blog_id`),
  INDEX `mt_template_identifier` (`template_identifier`),
  INDEX `mt_template_name` (`template_name`),
  INDEX `mt_template_outfile` (`template_outfile`),
  INDEX `mt_template_type` (`template_type`),
  PRIMARY KEY (`template_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_template_meta`;

--
-- Table: `mt_template_meta`
--
CREATE TABLE `mt_template_meta` (
  `template_meta_template_id` integer(11) NOT NULL,
  `template_meta_type` varchar(75) NOT NULL,
  `template_meta_vblob` mediumblob NULL,
  `template_meta_vchar` varchar(255) NULL DEFAULT NULL,
  `template_meta_vchar_idx` varchar(255) NULL DEFAULT NULL,
  `template_meta_vclob` mediumtext NULL,
  `template_meta_vdatetime` datetime NULL DEFAULT NULL,
  `template_meta_vdatetime_idx` datetime NULL DEFAULT NULL,
  `template_meta_vfloat` float NULL DEFAULT NULL,
  `template_meta_vfloat_idx` float NULL DEFAULT NULL,
  `template_meta_vinteger` integer(11) NULL DEFAULT NULL,
  `template_meta_vinteger_idx` integer(11) NULL DEFAULT NULL,
  INDEX `mt_template_meta_type_vchar` (`template_meta_type`, `template_meta_vchar_idx`),
  INDEX `mt_template_meta_type_vdt` (`template_meta_type`, `template_meta_vdatetime_idx`),
  INDEX `mt_template_meta_type_vflt` (`template_meta_type`, `template_meta_vfloat_idx`),
  INDEX `mt_template_meta_type_vint` (`template_meta_type`, `template_meta_vinteger_idx`),
  PRIMARY KEY (`template_meta_template_id`, `template_meta_type`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_template_rev`;

--
-- Table: `mt_template_rev`
--
CREATE TABLE `mt_template_rev` (
  `template_rev_changed` varchar(255) NOT NULL,
  `template_rev_created_by` integer(11) NULL DEFAULT NULL,
  `template_rev_created_on` datetime NULL DEFAULT NULL,
  `template_rev_description` varchar(255) NULL DEFAULT NULL,
  `template_rev_id` integer(11) NOT NULL auto_increment,
  `template_rev_label` varchar(255) NULL DEFAULT NULL,
  `template_rev_modified_by` integer(11) NULL DEFAULT NULL,
  `template_rev_modified_on` datetime NULL DEFAULT NULL,
  `template_rev_rev_number` integer(11) NOT NULL DEFAULT 0,
  `template_rev_template` mediumblob NOT NULL,
  `template_rev_template_id` integer(11) NOT NULL,
  INDEX `mt_template_rev_template_id` (`template_rev_template_id`),
  PRIMARY KEY (`template_rev_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_templatemap`;

--
-- Table: `mt_templatemap`
--
CREATE TABLE `mt_templatemap` (
  `templatemap_archive_type` varchar(100) NOT NULL,
  `templatemap_blog_id` integer(11) NOT NULL,
  `templatemap_build_interval` integer(11) NULL DEFAULT NULL,
  `templatemap_build_type` smallint(6) NULL DEFAULT 1,
  `templatemap_cat_field_id` integer(11) NULL DEFAULT NULL,
  `templatemap_dt_field_id` integer(11) NULL DEFAULT NULL,
  `templatemap_file_template` varchar(255) NULL DEFAULT NULL,
  `templatemap_id` integer(11) NOT NULL auto_increment,
  `templatemap_is_preferred` tinyint(4) NULL DEFAULT NULL,
  `templatemap_template_id` integer(11) NOT NULL,
  INDEX `mt_templatemap_archive_type` (`templatemap_archive_type`),
  INDEX `mt_templatemap_blog_id` (`templatemap_blog_id`),
  INDEX `mt_templatemap_is_preferred` (`templatemap_is_preferred`),
  INDEX `mt_templatemap_template_id` (`templatemap_template_id`),
  PRIMARY KEY (`templatemap_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_touch`;

--
-- Table: `mt_touch`
--
CREATE TABLE `mt_touch` (
  `touch_blog_id` integer(11) NULL DEFAULT NULL,
  `touch_id` integer(11) NOT NULL auto_increment,
  `touch_modified_on` datetime NULL DEFAULT NULL,
  `touch_object_type` varchar(255) NULL DEFAULT NULL,
  INDEX `mt_touch_blog_type` (`touch_blog_id`, `touch_object_type`, `touch_modified_on`),
  PRIMARY KEY (`touch_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_trackback`;

--
-- Table: `mt_trackback`
--
CREATE TABLE `mt_trackback` (
  `trackback_blog_id` integer(11) NOT NULL,
  `trackback_category_id` integer(11) NOT NULL DEFAULT 0,
  `trackback_created_by` integer(11) NULL DEFAULT NULL,
  `trackback_created_on` datetime NULL DEFAULT NULL,
  `trackback_description` mediumtext NULL,
  `trackback_entry_id` integer(11) NOT NULL DEFAULT 0,
  `trackback_id` integer(11) NOT NULL auto_increment,
  `trackback_is_disabled` tinyint(4) NULL DEFAULT 0,
  `trackback_modified_by` integer(11) NULL DEFAULT NULL,
  `trackback_modified_on` datetime NULL DEFAULT NULL,
  `trackback_passphrase` varchar(30) NULL DEFAULT NULL,
  `trackback_rss_file` varchar(255) NULL DEFAULT NULL,
  `trackback_title` varchar(255) NULL DEFAULT NULL,
  `trackback_url` varchar(255) NULL DEFAULT NULL,
  INDEX `mt_trackback_blog_id` (`trackback_blog_id`),
  INDEX `mt_trackback_category_id` (`trackback_category_id`),
  INDEX `mt_trackback_created_on` (`trackback_created_on`),
  INDEX `mt_trackback_entry_id` (`trackback_entry_id`),
  PRIMARY KEY (`trackback_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_ts_error`;

--
-- Table: `mt_ts_error`
--
CREATE TABLE `mt_ts_error` (
  `ts_error_error_time` integer(11) NOT NULL,
  `ts_error_funcid` integer(11) NOT NULL DEFAULT 0,
  `ts_error_jobid` integer(11) NOT NULL,
  `ts_error_message` mediumtext NOT NULL,
  INDEX `mt_ts_error_error_time` (`ts_error_error_time`),
  INDEX `mt_ts_error_funcid_time` (`ts_error_funcid`, `ts_error_error_time`),
  INDEX `mt_ts_error_jobid` (`ts_error_jobid`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_ts_exitstatus`;

--
-- Table: `mt_ts_exitstatus`
--
CREATE TABLE `mt_ts_exitstatus` (
  `ts_exitstatus_completion_time` integer(11) NULL DEFAULT NULL,
  `ts_exitstatus_delete_after` integer(11) NULL DEFAULT NULL,
  `ts_exitstatus_funcid` integer(11) NOT NULL,
  `ts_exitstatus_jobid` integer(11) NOT NULL,
  `ts_exitstatus_status` integer(11) NULL DEFAULT NULL,
  INDEX `mt_ts_exitstatus_delete_after` (`ts_exitstatus_delete_after`),
  INDEX `mt_ts_exitstatus_funcid` (`ts_exitstatus_funcid`),
  PRIMARY KEY (`ts_exitstatus_jobid`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_ts_funcmap`;

--
-- Table: `mt_ts_funcmap`
--
CREATE TABLE `mt_ts_funcmap` (
  `ts_funcmap_funcid` integer(11) NOT NULL auto_increment,
  `ts_funcmap_funcname` varchar(255) NOT NULL,
  PRIMARY KEY (`ts_funcmap_funcid`),
  UNIQUE `mt_ts_funcmap_funcname` (`ts_funcmap_funcname`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mt_ts_job`;

--
-- Table: `mt_ts_job`
--
CREATE TABLE `mt_ts_job` (
  `ts_job_arg` mediumblob NULL,
  `ts_job_coalesce` varchar(255) NULL DEFAULT NULL,
  `ts_job_funcid` integer(11) NOT NULL,
  `ts_job_grabbed_until` integer(11) NOT NULL,
  `ts_job_insert_time` integer(11) NULL DEFAULT NULL,
  `ts_job_jobid` integer(11) NOT NULL auto_increment,
  `ts_job_priority` integer(11) NULL DEFAULT NULL,
  `ts_job_run_after` integer(11) NOT NULL,
  `ts_job_uniqkey` varchar(255) NULL DEFAULT NULL,
  INDEX `mt_ts_job_funccoal` (`ts_job_funcid`, `ts_job_coalesce`),
  INDEX `mt_ts_job_funcpri` (`ts_job_funcid`, `ts_job_priority`),
  INDEX `mt_ts_job_funcrun` (`ts_job_funcid`, `ts_job_run_after`),
  PRIMARY KEY (`ts_job_jobid`),
  UNIQUE `mt_ts_job_uniqfunc` (`ts_job_funcid`, `ts_job_uniqkey`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

SET foreign_key_checks=1;

