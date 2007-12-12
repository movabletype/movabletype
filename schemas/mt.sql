CREATE TABLE mt_author (
    author_id INTEGER SERIAL PRIMARY KEY,
    author_name VARCHAR(50) NOT NULL,
    author_type TINYINT NOT NULL,
    author_nickname VARCHAR(50),
    author_password VARCHAR(60) NOT NULL,
    author_email VARCHAR(75) NOT NULL,
    author_url VARCHAR(255),
    author_can_create_blog TINYINT,
    author_can_view_log TINYINT,
    author_hint VARCHAR(75),
    author_created_by INTEGER,
    author_public_key TEXT,
    author_preferred_language VARCHAR(50),
    author_remote_auth_username VARCHAR(50),
    author_remote_auth_token VARCHAR(50)
);
CREATE UNIQUE INDEX mt_author_name_type ON mt_author (author_name, author_type);
CREATE INDEX mt_author_email ON mt_author (author_email);

CREATE TABLE mt_blog (
    blog_id INTEGER SERIAL PRIMARY KEY,
    blog_name VARCHAR(255) NOT NULL,
    blog_description TEXT,
    blog_site_path VARCHAR(255),
    blog_site_url VARCHAR(255),
    blog_archive_path VARCHAR(255),
    blog_archive_url VARCHAR(255),
    blog_archive_type VARCHAR(255),
    blog_archive_type_preferred VARCHAR(25),
    blog_days_on_index SMALLINT,
    blog_language VARCHAR(5),
    blog_file_extension VARCHAR(10),
    blog_email_new_comments TINYINT,
    blog_email_new_pings TINYINT,
    blog_allow_comment_html TINYINT,
    blog_autolink_urls TINYINT,
    blog_sort_order_posts VARCHAR(8),
    blog_sort_order_comments VARCHAR(8),
    blog_allow_comments_default TINYINT,
    blog_allow_pings_default TINYINT,
    blog_server_offset FLOAT,
    blog_convert_paras VARCHAR(30),
    blog_convert_paras_comments VARCHAR(30),
    blog_status_default TINYINT,
    blog_allow_anon_comments TINYINT,
    blog_allow_reg_comments TINYINT,
    blog_allow_unreg_comments TINYINT,
    blog_moderate_unreg_comments TINYINT,
    blog_require_comment_emails TINYINT,
    blog_manual_approve_commenters TINYINT,
    blog_words_in_excerpt SMALLINT,
    blog_ping_technorati TINYINT,
    blog_ping_weblogs TINYINT,
    blog_ping_blogs TINYINT,
    blog_ping_others TEXT,
    blog_mt_update_key VARCHAR(30),
    blog_autodiscover_links TINYINT,
    blog_welcome_msg TEXT,
    blog_old_style_archive_links TINYINT,
    blog_archive_tmpl_monthly VARCHAR(255),
    blog_archive_tmpl_weekly VARCHAR(255),
    blog_archive_tmpl_daily VARCHAR(255),
    blog_archive_tmpl_individual VARCHAR(255),
    blog_archive_tmpl_category VARCHAR(255),
    blog_google_api_key VARCHAR(32),
    blog_sanitize_spec VARCHAR(255),
    blog_cc_license VARCHAR(255),
    blog_is_dynamic TINYINT,
    blog_remote_auth_token VARCHAR(50),	
    blog_children_modified_on TIMESTAMP,
    blog_custom_dynamic_templates VARCHAR(25)
);
CREATE INDEX mt_blog_name ON mt_blog (blog_name);

CREATE TABLE mt_category (
    category_id INTEGER SERIAL PRIMARY KEY,
    category_blog_id INTEGER NOT NULL,
    category_allow_pings TINYINT,
    category_label VARCHAR(100) NOT NULL,
    category_description TEXT,
    category_author_id INTEGER,
    category_ping_urls TEXT,
    category_parent INTEGER
);
--CREATE UNIQUE INDEX mt_category_blog_label ON mt_category (category_blog_id, category_label);

CREATE TABLE mt_comment (
    comment_id INTEGER SERIAL PRIMARY KEY,
    comment_blog_id INTEGER NOT NULL,
    comment_entry_id INTEGER NOT NULL,
    comment_ip VARCHAR(16),
    comment_author VARCHAR(100),
    comment_email VARCHAR(75),
    comment_url VARCHAR(255),
    comment_commenter_id INTEGER,
    comment_visible TINYINT,
    commenter_is_junk TINYINT NOT NULL,
    comment_last_moved_on TIMESTAMP NOT NULL,
    comment_junk_score FLOAT,
    comment_junk_log TEXT,
    comment_text TEXT,
    comment_created_on TIMESTAMP NOT NULL,
    comment_modified_on TIMESTAMP NOT NULL,
    comment_created_by INTEGER,
    comment_modified_by INTEGER
);
CREATE INDEX mt_comment_ip ON mt_comment (comment_ip);
CREATE INDEX mt_comment_created_on ON mt_comment (comment_created_on);
CREATE INDEX mt_comment_entry_id ON mt_comment (comment_entry_id);
CREATE INDEX mt_comment_blog_id ON mt_comment (comment_blog_id);
CREATE INDEX mt_comment_commenter_id ON mt_comment (comment_commenter_id);
CREATE INDEX mt_comment_visible ON mt_comment (comment_visible);
CREATE INDEX mt_comment_is_junk ON mt_comment (comment_is_junk);
CREATE INDEX mt_comment_last_moved_on ON mt_comment (comment_last_moved_on);
CREATE INDEX mt_comment_junk_score ON mt_comment (comment_junk_score);

CREATE TABLE mt_entry (
    entry_id INTEGER SERIAL PRIMARY KEY,
    entry_blog_id INTEGER NOT NULL,
    entry_status TINYINT NOT NULL,
    entry_author_id INTEGER NOT NULL,
    entry_allow_comments TINYINT,
    entry_allow_pings TINYINT,
    entry_convert_breaks VARCHAR(30),
    entry_category_id INTEGER,
    entry_title VARCHAR(255),
    entry_excerpt TEXT,
    entry_text TEXT,
    entry_text_more TEXT,
    entry_to_ping_urls TEXT,
    entry_pinged_urls TEXT,
    entry_keywords TEXT,
    entry_tangent_cache TEXT,
    entry_created_on TIMESTAMP NOT NULL,
    entry_modified_on TIMESTAMP NOT NULL,
    entry_created_by INTEGER,
    entry_modified_by INTEGER,
    entry_basename VARCHAR(50) NOT NULL
);
CREATE INDEX mt_entry_blog_id ON mt_entry (entry_blog_id);
CREATE INDEX mt_entry_status ON mt_entry (entry_status);
CREATE INDEX mt_entry_author_id ON mt_entry (entry_author_id);
CREATE INDEX mt_entry_created_on ON mt_entry (entry_created_on);
CREATE INDEX mt_entry_basename ON mt_entry (entry_basename);

CREATE TABLE mt_ipbanlist (
    ipbanlist_id INTEGER SERIAL PRIMARY KEY,
    ipbanlist_blog_id INTEGER NOT NULL,
    ipbanlist_ip VARCHAR(15) NOT NULL,
    ipbanlist_created_on TIMESTAMP NOT NULL,
    ipbanlist_modified_on TIMESTAMP NOT NULL,
    ipbanlist_created_by INTEGER,
    ipbanlist_modified_by INTEGER
);
CREATE INDEX mt_ipbanlist_blog_id ON mt_ipbanlist (ipbanlist_blog_id);
CREATE INDEX mt_ipbanlist_ip ON mt_ipbanlist (ipbanlist_ip);

CREATE TABLE mt_log (
    log_id INTEGER SERIAL PRIMARY KEY,
    log_message VARCHAR(255),
    log_ip VARCHAR(16),
    log_created_on TIMESTAMP NOT NULL,
    log_modified_on TIMESTAMP NOT NULL,
    log_created_by INTEGER,
    log_modified_by INTEGER,
);
CREATE INDEX mt_log_created_on ON mt_log (log_created_on);

CREATE TABLE mt_notification (
    notification_id INTEGER SERIAL PRIMARY KEY,
    notification_blog_id INTEGER NOT NULL,
    notification_name VARCHAR(50),
    notification_email VARCHAR(75),
    notification_url VARCHAR(255),
    notification_created_on TIMESTAMP NOT NULL,
    notification_modified_on TIMESTAMP NOT NULL,
    notification_created_by INTEGER,
    notification_modified_by INTEGER,
);
CREATE INDEX mt_notification_blog_id ON mt_notification (notification_blog_id);

CREATE TABLE mt_permission (
    permission_id INTEGER SERIAL PRIMARY KEY,
    permission_author_id INTEGER NOT NULL,
    permission_blog_id INTEGER NOT NULL,
    permission_role_mask SMALLINT,
    permission_entry_prefs VARCHAR(255)
);
CREATE UNIQUE INDEX mt_permission_blog_author ON mt_permission (permission_blog_id, permission_author_id);

CREATE TABLE mt_placement (
    placement_id INTEGER SERIAL PRIMARY KEY,
    placement_entry_id INTEGER NOT NULL,
    placement_blog_id INTEGER NOT NULL,
    placement_category_id INTEGER NOT NULL,
    placement_is_primary TINYINT NOT NULL
);
CREATE INDEX mt_placement_entry_id ON mt_placement (placement_entry_id);
CREATE INDEX mt_placement_category_id ON mt_placement (placement_category_id);
CREATE INDEX mt_placement_is_primary ON mt_placement (placement_is_primary);

CREATE TABLE mt_plugindata (
    plugindata_id INTEGER SERIAL PRIMARY KEY,
    plugindata_plugin VARCHAR(50) NOT NULL,
    plugindata_key VARCHAR(255) NOT NULL,
    plugindata_data BLOB
);
CREATE INDEX mt_plugindata_plugin ON mt_plugindata (plugindata_plugin);
CREATE INDEX mt_plugindata_key ON mt_plugindata (plugindata_key);

CREATE TABLE mt_template (
    template_id INTEGER SERIAL PRIMARY KEY,
    template_blog_id INTEGER NOT NULL,
    template_name VARCHAR(50) NOT NULL,
    template_type VARCHAR(25) NOT NULL,
    template_outfile VARCHAR(255),
    template_rebuild_me TINYINT default 1,
    template_text TEXT,
    template_linked_file VARCHAR(255),
    template_linked_file_mtime VARCHAR(10),
    template_linked_file_size MEDIUMINT,
    template_created_on TIMESTAMP NOT NULL,
    template_modified_on TIMESTAMP NOT NULL,
    template_created_by INTEGER,
    template_modified_by INTEGER,
    template_build_dynamic TINYINT
);
CREATE UNIQUE INDEX mt_template_blog_name ON mt_template (template_blog_id, template_name);
CREATE INDEX mt_template_type ON mt_template (template_type);

CREATE TABLE mt_templatemap (
    templatemap_id INTEGER SERIAL PRIMARY KEY,
    templatemap_blog_id INTEGER NOT NULL,
    templatemap_template_id INTEGER NOT NULL,
    templatemap_archive_type VARCHAR(25) NOT NULL,
    templatemap_file_template VARCHAR(255),
    templatemap_is_preferred TINYINT NOT NULL
);
CREATE INDEX mt_templatemap_blog_id ON mt_templatemap (templatemap_blog_id);
CREATE INDEX mt_templatemap_template_id ON mt_templatemap (templatemap_template_id);
CREATE INDEX mt_templatemap_archive_type ON mt_templatemap (templatemap_archive_type);
CREATE INDEX mt_templatemap_is_preferred ON mt_templatemap (templatemap_is_preferred);

CREATE TABLE mt_trackback (
    trackback_id INTEGER SERIAL PRIMARY KEY,
    trackback_blog_id INTEGER NOT NULL,
    trackback_title VARCHAR(255),
    trackback_description TEXT,
    trackback_rss_file VARCHAR(255),
    trackback_url VARCHAR(255),
    trackback_entry_id INTEGER NOT NULL,
    trackback_category_id INTEGER NOT NULL,
    trackback_passphrase VARCHAR(30),
    trackback_is_disabled TINYINT default 0,
    trackback_created_on TIMESTAMP NOT NULL,
    trackback_modified_on TIMESTAMP NOT NULL,
    trackback_created_by INTEGER,
    trackback_modified_by INTEGER
);
CREATE INDEX mt_trackback_blog_id ON mt_trackback (trackback_blog_id);
CREATE INDEX mt_trackback_entry_id ON mt_trackback (trackback_entry_id);
CREATE INDEX mt_trackback_category_id ON mt_trackback (trackback_category_id);
CREATE INDEX mt_trackback_created_on ON mt_trackback (trackback_created_on);

CREATE TABLE mt_tbping (
    tbping_id INTEGER SERIAL PRIMARY KEY,
    tbping_blog_id INTEGER NOT NULL,
    tbping_tb_id INTEGER NOT NULL,
    tbping_title VARCHAR(255),
    tbping_excerpt TEXT,
    tbping_source_url VARCHAR(255),
    tbping_ip VARCHAR(15) NOT NULL,
    tbping_blog_name VARCHAR(255),
    tbping_visible TINYINT,
    tbping_is_junk TINYINT NOT NULL,
    tbping_junk_score FLOAT,
    tbping_junk_log TEXT,
    tbping_last_moved_on TIMESTAMP NOT NULL,
    tbping_created_on TIMESTAMP NOT NULL,
    tbping_modified_on TIMESTAMP NOT NULL,
    tbping_created_by INTEGER,
    tbping_modified_by INTEGER
);
CREATE INDEX mt_tbping_blog_id ON mt_tbping (tbping_blog_id);
CREATE INDEX mt_tbping_tb_id ON mt_tbping (tbping_tb_id);
CREATE INDEX mt_tbping_ip ON mt_tbping (tbping_ip);
CREATE INDEX mt_tbping_created_on ON mt_tbping (tbping_created_on);
CREATE INDEX mt_tbping_last_moved_on ON mt_tbping (tbping_last_moved_on);
CREATE INDEX mt_tbping_is_junk ON mt_tbping (tbping_is_junk);
CREATE INDEX mt_tbping_visible ON mt_tbping (tbping_visible);
CREATE INDEX mt_tbping_junk_score ON mt_tbping (tbping_junk_score);

CREATE TABLE mt_session (
    session_id VARCHAR(80) PRIMARY KEY,
    session_data TEXT,
    session_email VARCHAR(255),
    session_name VARCHAR(255),
    session_start int NOT NULL,
    session_kind VARCHAR(2)
);
CREATE INDEX mt_session_start ON mt_session (session_start);

CREATE TABLE mt_fileinfo (
    fileinfo_id INTEGER PRIMARY KEY SERIAL,
    fileinfo_blog_id INTEGER NOT NULL,
    fileinfo_entry_id INTEGER,
    fileinfo_url VARCHAR(255),
    fileinfo_file_path TEXT,
    fileinfo_template_id INTEGER,
    fileinfo_templatemap_id INTEGER,
    fileinfo_archive_type VARCHAR(255),
    fileinfo_category_id INTEGER,
    fileinfo_startdate VARCHAR(80),
    fileinfo_virtual TINYINT
);
CREATE INDEX mt_fileinfo_blog_id ON mt_fileinfo (fileinfo_blog_id);
CREATE INDEX mt_fileinfo_entry_id ON mt_fileinfo (fileinfo_entry_id);
CREATE INDEX mt_fileinfo_url ON mt_fileinfo (fileinfo_url);

