# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Template::Context;

use strict;

use MT;
use MT::Util qw( start_end_day start_end_week 
                 start_end_month week2ymd archive_file_for
                 format_ts offset_time_list first_n_words dirify get_entry
                 encode_html encode_js remove_html wday_from_ts days_in
                 spam_protect encode_php encode_url decode_html encode_xml
                 decode_xml relative_date asset_cleanup );
use MT::Request;
use Time::Local qw( timegm timelocal );
use MT::Promise qw( delay );
use MT::Category;
use MT::Entry;
use MT::I18N qw( first_n_text const uppercase lowercase substr_text length_text wrap_text );
use MT::Asset;

sub init_default_handlers {}
sub init_default_filters {}

sub core_tags {
    return {
        help_url => sub { MT->translate('http://www.movabletype.org/documentation/appendices/tags/%t.html') },
        block => {
            'App:Setting' => \&_hdlr_app_setting,
            'App:Widget' => \&_hdlr_app_widget,
            'App:StatusMsg' => \&_hdlr_app_statusmsg,
            'App:Listing' => \&_hdlr_app_listing,
            'App:SettingGroup' => \&_hdlr_app_setting_group,
            'App:Form' => \&_hdlr_app_form,

            # Core tags
            'If?' => \&_hdlr_if,
            'Unless?' => sub { defined(my $r = &_hdlr_if) or return; !$r },
            'For' => \&_hdlr_for,
            'Else' => \&_hdlr_else,
            'ElseIf' => \&_hdlr_elseif,

            'IfImageSupport?' => \&_hdlr_if_image_support,

            'EntryIfTagged?' => \&_hdlr_entry_if_tagged,

            'IfArchiveTypeEnabled?' => \&_hdlr_archive_type_enabled,
            'IfArchiveType?' => \&_hdlr_if_archive_type,

            'IfCategory?' => \&_hdlr_if_category,
            'EntryIfCategory?' => \&_hdlr_if_category,

            # Subcategory handlers
            'SubCatIsFirst?' => \&_hdlr_sub_cat_is_first,
            'SubCatIsLast?' => \&_hdlr_sub_cat_is_last,
            'HasSubCategories?' => \&_hdlr_has_sub_categories,
            'HasNoSubCategories?' => \&_hdlr_has_no_sub_categories,
            'HasParentCategory?' => \&_hdlr_has_parent_category,
            'HasNoParentCategory?' => \&_hdlr_has_no_parent_category,
            'IfIsAncestor?' => \&_hdlr_is_ancestor,
            'IfIsDescendant?' => \&_hdlr_is_descendant,

            IfStatic => \&_hdlr_pass_tokens,
            IfDynamic => \&_hdlr_pass_tokens_else,

            'AssetIfTagged?' => \&_hdlr_asset_if_tagged,

            'PageIfTagged?' => \&_hdlr_page_if_tagged,

            'IfFolder?' => \&_hdlr_if_folder,
            'FolderHeader?' => \&_hdlr_folder_header,
            'FolderFooter?' => \&_hdlr_folder_footer,
            'HasSubFolders?' => \&_hdlr_has_sub_folders,
            'HasParentFolder?' => \&_hdlr_has_parent_folder,

            IncludeBlock => \&_hdlr_include_block,

            Loop => \&_hdlr_loop,
            Section => \&_hdlr_section,
            'IfNonEmpty?' => \&_hdlr_if_nonempty,
            'IfNonZero?' => \&_hdlr_if_nonzero,

            'IfCommenterTrusted?' => \&_hdlr_commenter_trusted,
            'CommenterIfTrusted?' => \&_hdlr_commenter_trusted,
            'IfCommenterIsAuthor?' => \&_hdlr_commenter_isauthor,
            'IfCommenterIsEntryAuthor?' => \&_hdlr_commenter_isauthor,

            'IfBlog?' => \&_hdlr_blog_id,
            'IfAuthor?' => \&_hdlr_if_author,
            'AuthorHasEntry?' => \&_hdlr_author_has_entry,
            'AuthorHasPage?' => \&_hdlr_author_has_page,
            Authors => \&_hdlr_authors,
            AuthorNext => \&_hdlr_author_next_prev,
            AuthorPrevious => \&_hdlr_author_next_prev,

            Blogs => \&_hdlr_blogs,
            'BlogIfCCLicense?' => \&_hdlr_blog_if_cc_license,
            Entries => \&_hdlr_entries,
            EntriesHeader => \&_hdlr_pass_tokens,
            EntriesFooter => \&_hdlr_pass_tokens,
            EntryCategories => \&_hdlr_entry_categories,
            EntryAdditionalCategories => \&_hdlr_entry_additional_categories,
            'BlogIfCommentsOpen?' => \&_hdlr_blog_if_comments_open,
            EntryPrevious => \&_hdlr_entry_previous,
            EntryNext => \&_hdlr_entry_next,
            EntryTags => \&_hdlr_entry_tags,

            DateHeader => \&_hdlr_pass_tokens,
            DateFooter => \&_hdlr_pass_tokens,

            PingsHeader => \&_hdlr_pass_tokens,
            PingsFooter => \&_hdlr_pass_tokens,

            ArchivePrevious => \&_hdlr_archive_prev_next,
            ArchiveNext => \&_hdlr_archive_prev_next,

            SetVarBlock => \&_hdlr_set_var,
            SetVarTemplate => \&_hdlr_set_var,
            SetVars => \&_hdlr_set_vars,
            SetHashVar => \&_hdlr_set_hashvar,

            'IfCommentsModerated?' => \&_hdlr_comments_moderated,
            'IfRegistrationRequired?' => \&_hdlr_reg_required,
            'IfRegistrationNotRequired?' => \&_hdlr_reg_not_required,
            'IfRegistrationAllowed?' => \&_hdlr_reg_allowed,

            'IfTypeKeyToken?' => \&_hdlr_if_typekey_token,

            Comments => \&_hdlr_comments,
            CommentsHeader => \&_hdlr_pass_tokens,
            CommentsFooter => \&_hdlr_pass_tokens,
            CommentEntry => \&_hdlr_comment_entry,
            'CommentIfModerated?' => \&_hdlr_comment_if_moderated,

            CommentParent => \&_hdlr_comment_parent,
            CommentReplies => \&_hdlr_comment_replies,

            'IfCommentParent?' => \&_hdlr_if_comment_parent,
            'IfCommentReplies?' => \&_hdlr_if_comment_replies,

            IndexList => \&_hdlr_index_list,

            Archives => \&_hdlr_archive_set,
            ArchiveList => \&_hdlr_archives,
            ArchiveListHeader => \&_hdlr_pass_tokens,
            ArchiveListFooter => \&_hdlr_pass_tokens,

            Calendar => \&_hdlr_calendar,
            CalendarWeekHeader => \&_hdlr_pass_tokens,
            CalendarWeekFooter => \&_hdlr_pass_tokens,
            CalendarIfBlank => \&_hdlr_pass_tokens,
            CalendarIfToday => \&_hdlr_pass_tokens,
            CalendarIfEntries => \&_hdlr_pass_tokens,
            CalendarIfNoEntries => \&_hdlr_pass_tokens,

            Categories => \&_hdlr_categories,
            'CategoryIfAllowPings?' => \&_hdlr_category_allow_pings,
            CategoryPrevious => \&_hdlr_category_prevnext,
            CategoryNext => \&_hdlr_category_prevnext,

            Pings => \&_hdlr_pings,
            PingsSent => \&_hdlr_pings_sent,
            PingEntry => \&_hdlr_ping_entry,

            'IfAllowCommentHTML?' => \&_hdlr_if_allow_comment_html,
            'IfCommentsAllowed?' => \&_hdlr_if_comments_allowed,
            'IfCommentsAccepted?' => \&_hdlr_if_comments_accepted,
            'IfCommentsActive?' => \&_hdlr_if_comments_active,
            'IfPingsAllowed?' => \&_hdlr_if_pings_allowed,
            'IfPingsAccepted?' => \&_hdlr_if_pings_accepted,
            'IfPingsActive?' => \&_hdlr_if_pings_active,
            'IfPingsModerated?' => \&_hdlr_if_pings_moderated,
            'IfNeedEmail?' => \&_hdlr_if_need_email,
            'IfRequireCommentEmails?' => \&_hdlr_if_need_email,
            'EntryIfAllowComments?' => \&_hdlr_entry_if_allow_comments,
            'EntryIfCommentsOpen?' => \&_hdlr_entry_if_comments_open,
            'EntryIfAllowPings?' => \&_hdlr_entry_if_allow_pings,
            'EntryIfExtended?' => \&_hdlr_entry_if_extended,

            SubCategories => \&_hdlr_sub_categories,
            TopLevelCategories => \&_hdlr_top_level_categories,
            ParentCategory => \&_hdlr_parent_category,
            ParentCategories => \&_hdlr_parent_categories,
            TopLevelParent => \&_hdlr_top_level_parent,
            EntriesWithSubCategories => \&_hdlr_entries_with_sub_categories,

            Tags => \&_hdlr_tags,
            Ignore => sub { '' },

            # Asset handlers
            EntryAssets => \&_hdlr_assets,
            PageAssets => \&_hdlr_assets,
            Assets => \&_hdlr_assets,
            AssetTags => \&_hdlr_asset_tags,
            Asset => \&_hdlr_asset,
            AssetIsFirstInRow => \&_hdlr_pass_tokens,
            AssetIsLastInRow => \&_hdlr_pass_tokens,
            AssetsHeader => \&_hdlr_pass_tokens,
            AssetsFooter => \&_hdlr_pass_tokens,
            AuthorUserpicAsset => \&_hdlr_author_userpic_asset,
            EntryAuthorUserpicAsset => \&_hdlr_entry_author_userpic_asset,
            CommenterUserpicAsset => \&_hdlr_commenter_userpic_asset,

            # Page handlers
            Pages => \&_hdlr_pages,
            PagePrevious => \&_hdlr_page_previous,
            PageNext => \&_hdlr_page_next,
            PageTags => \&_hdlr_page_tags,
            PageFolder => \&_hdlr_page_folder,

            PagesHeader => \&_hdlr_pass_tokens,
            PagesFooter => \&_hdlr_pass_tokens,

            # Folder handlers
            Folders => \&_hdlr_folders,
            FolderPrevious => \&_hdlr_folder_prevnext,
            FolderNext => \&_hdlr_folder_prevnext,
            SubFolders => \&_hdlr_sub_folders,
            ParentFolders => \&_hdlr_parent_folders,
            ParentFolder => \&_hdlr_parent_folder,
            TopLevelFolders => \&_hdlr_top_level_folders,
            TopLevelFolder => \&_hdlr_top_level_folder,

            # Pager handlers
            'IfMoreResults?' => \&_hdlr_if_more_results,
            'IfPreviousResults?' => \&_hdlr_if_previous_results,
            PagerBlock => \&_hdlr_pager_block,
            IfCurrentPage => \&_hdlr_pass_tokens,

            # stubs for mt-search tags used in template includes
            IfTagSearch => sub { '' },
            SearchResults => sub { '' },

            IfStraightSearch => sub { '' },
            NoSearchResults => \&_hdlr_pass_tokens,
            NoSearch => \&_hdlr_pass_tokens,
            SearchResultsHeader => sub { '' },
            SearchResultsFooter => sub { '' },
            BlogResultHeader => sub { '' },
            BlogResultFooter => sub { '' },
            IfMaxResultsCutoff => sub { '' },
        },
        function => {
            'App:PageActions' => \&_hdlr_app_page_actions,
            'App:ListFilters' => \&_hdlr_app_list_filters,
            'App:ActionBar' => \&_hdlr_app_action_bar,
            'App:Link' => \&_hdlr_app_link,
            Var => \&_hdlr_get_var,
            CGIPath => \&_hdlr_cgi_path,
            AdminCGIPath => \&_hdlr_admin_cgi_path,
            CGIRelativeURL => \&_hdlr_cgi_relative_url,
            CGIHost => \&_hdlr_cgi_host,
            StaticWebPath => \&_hdlr_static_path,
            StaticFilePath => \&_hdlr_static_file_path,
            AdminScript => \&_hdlr_admin_script,
            CommentScript => \&_hdlr_comment_script,
            TrackbackScript => \&_hdlr_trackback_script,
            SearchScript => \&_hdlr_search_script,
            XMLRPCScript => \&_hdlr_xmlrpc_script,
            AtomScript => \&_hdlr_atom_script,
            NotifyScript => \&_hdlr_notify_script,
            Date => \&_hdlr_sys_date,
            Version => \&_hdlr_mt_version,
            ProductName => \&_hdlr_product_name,
            PublishCharset => \&_hdlr_publish_charset,
            DefaultLanguage => \&_hdlr_default_language,
            CGIServerPath => \&_hdlr_cgi_server_path,
            ConfigFile => \&_hdlr_config_file,

            UserSessionCookieTimeout => \&_hdlr_user_session_cookie_timeout,
            UserSessionCookieName => \&_hdlr_user_session_cookie_name,
            UserSessionCookiePath => \&_hdlr_user_session_cookie_path,
            UserSessionCookieDomain => \&_hdlr_user_session_cookie_domain,
            CommenterNameThunk => \&_hdlr_commenter_name_thunk,
            CommenterUsername => \&_hdlr_commenter_username, 
            CommenterName => \&_hdlr_commenter_name,
            CommenterEmail => \&_hdlr_commenter_email,
            CommenterAuthType => \&_hdlr_commenter_auth_type,
            CommenterAuthIconURL => \&_hdlr_commenter_auth_icon_url,
            CommenterUserpic => \&_hdlr_commenter_userpic,
            CommenterUserpicURL => \&_hdlr_commenter_userpic_url,
            CommenterID => \&_hdlr_commenter_id,
            CommenterURL => \&_hdlr_commenter_url,
            FeedbackScore => \&_hdlr_feedback_score,

            AuthorID => \&_hdlr_author_id,
            AuthorName => \&_hdlr_author_name,
            AuthorDisplayName =>\&_hdlr_author_display_name,
            AuthorEmail => \&_hdlr_author_email,
            AuthorURL => \&_hdlr_author_url,
            AuthorAuthType => \&_hdlr_author_auth_type,
            AuthorAuthIconURL => \&_hdlr_author_auth_icon_url,
            AuthorUserpic => \&_hdlr_author_userpic,
            AuthorUserpicURL => \&_hdlr_author_userpic_url,
            AuthorBasename => \&_hdlr_author_basename,

            BlogID => \&_hdlr_blog_id,
            BlogName => \&_hdlr_blog_name,
            BlogDescription => \&_hdlr_blog_description,
            BlogLanguage => \&_hdlr_blog_language,
            BlogURL => \&_hdlr_blog_url,
            BlogArchiveURL => \&_hdlr_blog_archive_url,
            BlogRelativeURL => \&_hdlr_blog_relative_url,
            BlogSitePath => \&_hdlr_blog_site_path,
            BlogHost => \&_hdlr_blog_host,
            BlogTimezone => \&_hdlr_blog_timezone,
            BlogCategoryCount => \&_hdlr_blog_category_count,
            BlogEntryCount => \&_hdlr_blog_entry_count,
            BlogCommentCount => \&_hdlr_blog_comment_count,
            BlogPingCount => \&_hdlr_blog_ping_count,
            BlogCCLicenseURL => \&_hdlr_blog_cc_license_url,
            BlogCCLicenseImage => \&_hdlr_blog_cc_license_image,
            CCLicenseRDF => \&_hdlr_cc_license_rdf,
            BlogFileExtension => \&_hdlr_blog_file_extension,
            BlogTemplateSetID => \&_hdlr_blog_template_set_id,
            EntriesCount => \&_hdlr_entries_count,
            EntryID => \&_hdlr_entry_id,
            EntryTitle => \&_hdlr_entry_title,
            EntryStatus => \&_hdlr_entry_status,
            EntryFlag => \&_hdlr_entry_flag,
            EntryCategory => \&_hdlr_entry_category,
            EntryBody => \&_hdlr_entry_body,
            EntryMore => \&_hdlr_entry_more,
            EntryExcerpt => \&_hdlr_entry_excerpt,
            EntryKeywords => \&_hdlr_entry_keywords,
            EntryLink => \&_hdlr_entry_link,
            EntryBasename => \&_hdlr_entry_basename,
            EntryAtomID => \&_hdlr_entry_atom_id,
            EntryPermalink => \&_hdlr_entry_permalink,
            EntryClass => \&_hdlr_entry_class,
            EntryClassLabel => \&_hdlr_entry_class_label,
            EntryAuthor => \&_hdlr_entry_author,
            EntryAuthorDisplayName => \&_hdlr_entry_author_display_name,
            EntryAuthorUsername => \&_hdlr_entry_author_username,
            EntryAuthorEmail => \&_hdlr_entry_author_email,
            EntryAuthorURL => \&_hdlr_entry_author_url,
            EntryAuthorLink => \&_hdlr_entry_author_link,
            EntryAuthorNickname => \&_hdlr_entry_author_nick,
            EntryAuthorID => \&_hdlr_entry_author_id,
            EntryAuthorUserpic => \&_hdlr_entry_author_userpic,
            EntryAuthorUserpicURL => \&_hdlr_entry_author_userpic_url,
            EntryDate => \&_hdlr_entry_date,
            EntryCreatedDate => \&_hdlr_entry_create_date,
            EntryModifiedDate => \&_hdlr_entry_mod_date,
            EntryCommentCount => \&_hdlr_entry_comments,
            EntryTrackbackCount => \&_hdlr_entry_ping_count,
            EntryTrackbackLink => \&_hdlr_entry_tb_link,
            EntryTrackbackData => \&_hdlr_entry_tb_data,
            EntryTrackbackID => \&_hdlr_entry_tb_id,
            EntryBlogID => \&_hdlr_entry_blog_id,
            EntryBlogName => \&_hdlr_entry_blog_name,
            EntryBlogDescription => \&_hdlr_entry_blog_description,
            EntryBlogURL => \&_hdlr_entry_blog_url,
            EntryEditLink => \&_hdlr_entry_edit_link,

            Include => \&_hdlr_include,
            Link => \&_hdlr_link,
            WidgetManager => \&_hdlr_widget_manager,
            WidgetSet => \&_hdlr_widget_manager,

            ErrorMessage => \&_hdlr_error_message,

            GetVar => \&_hdlr_get_var,
            SetVar => \&_hdlr_set_var,

            TypeKeyToken => \&_hdlr_typekey_token,
            CommentFields => \&_hdlr_comment_fields,
            RemoteSignOutLink => \&_hdlr_remote_sign_out_link,
            RemoteSignInLink => \&_hdlr_remote_sign_in_link,
            SignOutLink => \&_hdlr_sign_out_link,
            SignInLink => \&_hdlr_sign_in_link,

            CommentID => \&_hdlr_comment_id,
            CommentBlogID => \&_hdlr_comment_blog_id,
            CommentEntryID => \&_hdlr_comment_entry_id,
            CommentName => \&_hdlr_comment_author,
            CommentIP => \&_hdlr_comment_ip,
            CommentAuthor => \&_hdlr_comment_author,
            CommentAuthorLink => \&_hdlr_comment_author_link,
            CommentAuthorIdentity => \&_hdlr_comment_author_identity,
            CommentEmail => \&_hdlr_comment_email,
            CommentLink => \&_hdlr_comment_link,
            CommentURL => \&_hdlr_comment_url,
            CommentBody => \&_hdlr_comment_body,
            CommentOrderNumber => \&_hdlr_comment_order_num,
            CommentDate => \&_hdlr_comment_date,
            CommentParentID => \&_hdlr_comment_parent_id,
            CommentReplyToLink => \&_hdlr_comment_reply_link,
            CommentPreviewAuthor => \&_hdlr_comment_author,
            CommentPreviewIP => \&_hdlr_comment_ip,
            CommentPreviewAuthorLink => \&_hdlr_comment_author_link,
            CommentPreviewEmail => \&_hdlr_comment_email,
            CommentPreviewURL => \&_hdlr_comment_url,
            CommentPreviewBody => \&_hdlr_comment_body,
            CommentPreviewDate => \&_hdlr_date,
            CommentPreviewState => \&_hdlr_comment_prev_state,
            CommentPreviewIsStatic => \&_hdlr_comment_prev_static,
            CommentRepliesRecurse => \&_hdlr_comment_replies_recurse,

            IndexLink => \&_hdlr_index_link,
            IndexName => \&_hdlr_index_name,
            IndexBasename => \&_hdlr_index_basename,

            ArchiveLink => \&_hdlr_archive_link,
            ArchiveTitle => \&_hdlr_archive_title,
            ArchiveType => \&_hdlr_archive_type,
            ArchiveTypeLabel => \&_hdlr_archive_label,
            ArchiveLabel => \&_hdlr_archive_label,
            ArchiveCount => \&_hdlr_archive_count,
            ArchiveDate => \&_hdlr_date,
            ArchiveDateEnd => \&_hdlr_archive_date_end,
            ArchiveCategory => \&_hdlr_archive_category,
            ArchiveFile => \&_hdlr_archive_file,

            ImageURL => \&_hdlr_image_url,
            ImageWidth => \&_hdlr_image_width,
            ImageHeight => \&_hdlr_image_height,

            CalendarDay => \&_hdlr_calendar_day,
            CalendarCellNumber => \&_hdlr_calendar_cell_num,
            CalendarDate => \&_hdlr_date,

            CategoryID => \&_hdlr_category_id,
            CategoryLabel => \&_hdlr_category_label,
            CategoryBasename => \&_hdlr_category_basename,
            CategoryDescription => \&_hdlr_category_desc,
            CategoryArchiveLink => \&_hdlr_category_archive,
            CategoryCount => \&_hdlr_category_count,
            CategoryCommentCount => \&_hdlr_category_comment_count,
            CategoryTrackbackLink => \&_hdlr_category_tb_link,
            CategoryTrackbackCount => \&_hdlr_category_tb_count,

            PingsSentURL => \&_hdlr_pings_sent_url,
            PingTitle => \&_hdlr_ping_title,
            PingID => \&_hdlr_ping_id,
            PingURL => \&_hdlr_ping_url,
            PingExcerpt => \&_hdlr_ping_excerpt,
            PingBlogName => \&_hdlr_ping_blog_name,
            PingIP => \&_hdlr_ping_ip,
            PingDate => \&_hdlr_ping_date,

            FileTemplate => \&_hdlr_file_template,

            SignOnURL => \&_hdlr_signon_url,

            SubCatsRecurse => \&_hdlr_sub_cats_recurse,
            SubCategoryPath => \&_hdlr_sub_category_path,

            TagName => \&_hdlr_tag_name,
            TagLabel => \&_hdlr_tag_name,
            TagID => \&_hdlr_tag_id,
            TagCount => \&_hdlr_tag_count,
            TagRank => \&_hdlr_tag_rank,
            TagSearchLink => \&_hdlr_tag_search_link,

            TemplateNote => sub { '' },
            TemplateCreatedOn => \&_hdlr_template_created_on,

            HTTPContentType => \&_hdlr_http_content_type,

            AssetID => \&_hdlr_asset_id,
            AssetFileName => \&_hdlr_asset_file_name,
            AssetLabel => \&_hdlr_asset_label,
            AssetURL => \&_hdlr_asset_url,
            AssetType => \&_hdlr_asset_type,
            AssetMimeType => \&_hdlr_asset_mime_type,
            AssetFilePath => \&_hdlr_asset_file_path,
            AssetDateAdded => \&_hdlr_asset_date_added,
            AssetAddedBy => \&_hdlr_asset_added_by,
            AssetProperty => \&_hdlr_asset_property,
            AssetFileExt => \&_hdlr_asset_file_ext,
            AssetThumbnailURL => \&_hdlr_asset_thumbnail_url,
            AssetLink => \&_hdlr_asset_link,
            AssetThumbnailLink => \&_hdlr_asset_thumbnail_link,
            AssetDescription => \&_hdlr_asset_description,

            AssetCount => \&_hdlr_asset_count,

            PageID => \&_hdlr_page_id,
            PageTitle=> \&_hdlr_page_title,
            PageBody => \&_hdlr_page_body, 
            PageMore => \&_hdlr_page_more,
            PageDate => \&_hdlr_page_date,
            PageModifiedDate => \&_hdlr_page_modified_date,
            PageAuthorDisplayName => \&_hdlr_page_author_display_name,
            PageKeywords => \&_hdlr_page_keywords,
            PageBasename => \&_hdlr_page_basename,
            PagePermalink => \&_hdlr_page_permalink,
            PageAuthorEmail => \&_hdlr_page_author_email,
            PageAuthorLink => \&_hdlr_page_author_link,
            PageAuthorURL => \&_hdlr_page_author_url,
            PageExcerpt => \&_hdlr_page_excerpt,
            BlogPageCount => \&_hdlr_blog_page_count,

            FolderBasename => \&_hdlr_folder_basename,
            FolderCount => \&_hdlr_folder_count,
            FolderDescription => \&_hdlr_folder_description,
            FolderID => \&_hdlr_folder_id,
            FolderLabel => \&_hdlr_folder_label,
            FolderPath => \&_hdlr_folder_path,
            SubFolderRecurse => \&_hdlr_sub_folder_recurse,

            SearchString => sub { '' },
            SearchResultCount => sub { 0 }, 
            MaxResults => sub { '' },
            SearchMaxResults => \&_hdlr_search_max_results,
            SearchIncludeBlogs => sub { '' },
            SearchTemplateID => sub { 0 },

            UserSessionState => \&_hdlr_user_session_state,

            BuildTemplateID => \&_hdlr_build_template_id,

            CaptchaFields => \&_hdlr_captcha_fields,

            # Rating related handlers
            EntryScore => \&_hdlr_entry_score,
            CommentScore => \&_hdlr_comment_score,
            PingScore => \&_hdlr_ping_score,
            AssetScore => \&_hdlr_asset_score,
            AuthorScore => \&_hdlr_author_score,

            EntryScoreHigh => \&_hdlr_entry_score_high,
            CommentScoreHigh => \&_hdlr_comment_score_high,
            PingScoreHigh => \&_hdlr_ping_score_high,
            AssetScoreHigh => \&_hdlr_asset_score_high,
            AuthorScoreHigh => \&_hdlr_author_score_high,

            EntryScoreLow => \&_hdlr_entry_score_low,
            CommentScoreLow => \&_hdlr_comment_score_low,
            PingScoreLow => \&_hdlr_ping_score_low,
            AssetScoreLow => \&_hdlr_asset_score_low,
            AuthorScoreLow => \&_hdlr_author_score_low,

            EntryScoreAvg => \&_hdlr_entry_score_avg,
            CommentScoreAvg => \&_hdlr_comment_score_avg,
            PingScoreAvg => \&_hdlr_ping_score_avg,
            AssetScoreAvg => \&_hdlr_asset_score_avg,
            AuthorScoreAvg => \&_hdlr_author_score_avg,

            EntryScoreCount => \&_hdlr_entry_score_count,
            CommentScoreCount => \&_hdlr_comment_score_count,
            PingScoreCount => \&_hdlr_ping_score_count,
            AssetScoreCount => \&_hdlr_asset_score_count,
            AuthorScoreCount => \&_hdlr_author_score_count,

            EntryRank => \&_hdlr_entry_rank,
            CommentRank => \&_hdlr_comment_rank,
            PingRank => \&_hdlr_ping_rank,
            AssetRank => \&_hdlr_asset_rank,
            AuthorRank => \&_hdlr_author_rank,

            # Pager related handlers
            PagerLink => \&_hdlr_pager_link,
            NextLink => \&_hdlr_next_link,
            PreviousLink => \&_hdlr_previous_link,
            CurrentPage => \&_hdlr_current_page,
            TotalPages => \&_hdlr_total_pages,
        },
        modifier => {
            'numify' => \&_fltr_numify,
            'mteval' => \&_fltr_mteval,
            'filters' => \&_fltr_filters,
            'trim_to' => \&_fltr_trim_to,
            'trim' => \&_fltr_trim,
            'ltrim' => \&_fltr_ltrim,
            'rtrim' => \&_fltr_rtrim,
            'decode_html' => \&_fltr_decode_html,
            'decode_xml' => \&_fltr_decode_xml,
            'remove_html' => \&_fltr_remove_html,
            'dirify' => \&_fltr_dirify,
            'sanitize' => \&_fltr_sanitize,
            'encode_sha1' => \&_fltr_sha1,
            'encode_html' => \&_fltr_encode_html,
            'encode_xml' => \&_fltr_encode_xml,
            'encode_js' => \&_fltr_encode_js,
            'encode_php' => \&_fltr_encode_php,
            'encode_url' => \&_fltr_encode_url,
            'upper_case' => \&_fltr_upper_case,
            'lower_case' => \&_fltr_lower_case,
            'strip_linefeeds' => \&_fltr_strip_linefeeds,
            'space_pad' => \&_fltr_space_pad,
            'zero_pad' => \&_fltr_zero_pad,
            'sprintf' => \&_fltr_sprintf,
            'regex_replace' => \&_fltr_regex_replace,
            'capitalize' => \&_fltr_capitalize,
            'count_characters' => \&_fltr_count_characters,
            'cat' => \&_fltr_cat,
            'count_paragraphs' => \&_fltr_count_paragraphs,
            'count_words' => \&_fltr_count_words,
            'escape' => \&_fltr_escape,
            'indent' => \&_fltr_indent,
            'nl2br' => \&_fltr_nl2br,
            'replace' => \&_fltr_replace,
            'spacify' => \&_fltr_spacify,
            'string_format' => \&_fltr_sprintf,
            'strip' => \&_fltr_strip,
            'strip_tags' => \&_fltr_strip_tags,
            '_default' => \&_fltr_default,
            'nofollowfy' => \&_fltr_nofollowfy,
            'wrap_text' => \&_fltr_wrap_text,
            'setvar' => \&_fltr_setvar,
        },
    };
}

###########################################################################

=head2 numify

Adds commas to a number. Converting "12345" into "12,345" for instance.
The argument for the numify attribute is the separator character to use
(ie, "," or "."); "," is the default.

=cut

sub _fltr_numify {
    my ($str, $arg, $ctx) = @_;
    $arg = ',' if (!defined $arg) || ($arg eq '1');
    $str =~ s/(^[−+]?\d+?(?=(?>(?:\d{3})+)(?!\d))|\G\d{3}(?=\d))/$1$arg/g;
    return $str;
}

###########################################################################

=head2 mteval

Processes the input string for any MT template tags and returns the output.

=cut

sub _fltr_mteval {
    my ($str, $arg, $ctx) = @_;
    my $builder = $ctx->stash('builder');
    my $tokens = $builder->compile($ctx, $str);
    return $ctx->error($builder->errstr) unless defined $tokens;
    my $out = $builder->build($ctx, $tokens);
    return $ctx->error($builder->errstr) unless defined $out;
    return $out;
}

###########################################################################

=head2 encode_sha1

Outputs a SHA1-hex digest of the content from the tag it is applied to.

B<Example:>

    <$mt:EntryTitle encode_sha1="1"$>

outputs:

    0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33

=cut

sub _fltr_sha1 {
    my ($str) = @_;
    require MT::Util;
    return MT::Util::perl_sha1_digest_hex($str);
}

###########################################################################

=head2 setvar

Takes the content from the tag it is applied to and assigns it
to the given variable name.

Example, assigning a HTML link of the last published entry with a
'@featured' tag to a template variable named 'featured_entry_link':

    <mt:Entries lastn="1" tags="@featured" setvar="featured_entry_link">
        <a href="<$mt:EntryPermalink$>"><$mt:EntryTitle$></a>
    </mt:Entries>

The output from the L<Entries> tag is suppressed, and placed into
the template variable 'featured_entry_link' instead. To retrieve it,
just use the L<Var> tag.

=cut

sub _fltr_setvar {
    my ($str, $arg, $ctx) = @_;
    if ( my $hash = $ctx->{__inside_set_hashvar} ) {
        $hash->{$arg} = $str;
    }
    else {
        $ctx->var($arg, $str);
    }
    return '';
}

###########################################################################

=head2 nofollowfy

Processes the 'a' tags from the tag it is applied to and adds a 'rel'
attribute of 'nofollow' to it (or appends to an existing rel attribute).

B<Example:>

    <$mt:CommentBody nofollowfy="1"$>

=cut

sub _fltr_nofollowfy {
    my ($str, $arg, $ctx) = @_;
    return $str unless $arg;
    $str =~ s#<\s*a\s([^>]*\s*href\s*=[^>]*)>#
        my @attr = $1 =~ /[^=\s]*\s*=\s*"[^"]*"|[^=\s]*\s*=\s*'[^']*'|[^=\s]*\s*=[^\s]*/g;
        my @rel = grep { /^rel\s*=/i } @attr;
        my $rel;
        $rel = pop @rel if @rel;
        if ($rel) {
            $rel =~ s/^(rel\s*=\s*['"]?)/$1nofollow /i
                unless $rel =~ m/\bnofollow\b/;
        } else {
            $rel = 'rel="nofollow"';
        }
        @attr = grep { !/^rel\s*=/i } @attr;
        '<a ' . (join ' ', @attr) . ' ' . $rel . '>';
    #xieg;
    $str;
}

###########################################################################

=head2 filters

Applies one or more text format filters.

B<Example:>

    <$mt:EntryBody convert_breaks="0" filters="filter1, filter2, filter3"$>

=cut

sub _fltr_filters {
    my ($str, $val, $ctx) = @_;
    MT->apply_text_filters($str, [ split /\s*,\s*/, $val ], $ctx);
}

###########################################################################

=head2 trim_to

Trims the input content to the requested length.

B<Example:>

    <$mt:EntryTitle trim_to="4"$>

=cut

sub _fltr_trim_to {
    my ($str, $val, $ctx) = @_;
    return '' if $val <= 0;
    $str = substr_text($str, 0, $val) if $val < length_text($str);
    $str;
}

###########################################################################

=head2 trim

Trims all leading and trailing whitespace from the input.

B<Example:>

    <$mt:EntryTitle trim="1"$>

=cut

sub _fltr_trim {
    my ($str, $val, $ctx) = @_;
    $str =~ s/^\s+|\s+$//gs;
    $str;
}

###########################################################################

=head2 ltrim

Trims all leading whitespace from the input.

B<Example:>

    <$mt:EntryTitle ltrim="1"$>

=cut

sub _fltr_ltrim {
    my ($str, $val, $ctx) = @_;
    $str =~ s/^\s+//s;
    $str;
}

###########################################################################

=head2 rtrim

Trims all trailing (right-side) whitespace from the input.

B<Example:>

    <$mt:EntryTitle rtrim="1"$>

=cut

sub _fltr_rtrim {
    my ($str, $val, $ctx) = @_;
    $str =~ s/\s+$//s;
    $str;
}

###########################################################################

=head2 decode_html

Decodes any HTML entities from the input.

=cut

sub _fltr_decode_html {
    my ($str, $val, $ctx) = @_;
    MT::Util::decode_html($str);
}

###########################################################################

=head2 decode_xml

Removes XML encoding from the input. Strips a 'CDATA' wrapper as well.

=cut

sub _fltr_decode_xml {
    my ($str, $val, $ctx) = @_;
    decode_xml($str);
}

###########################################################################

=head2 remove_html

Removes any HTML markup from the input.

=cut

sub _fltr_remove_html {
    my ($str, $val, $ctx) = @_;
    MT::Util::remove_html($str);
}

###########################################################################

=head2 dirify

Converts the input into a filename-friendly format. This strips accents
from accented characters and changes spaces into underscores (or
dashes, depending on parameter).

The dirify parameter can be either "1", "-" or "_". "1" is equivalent
to "_".

B<Example:>

    <$mt:EntryTitle dirify="-"$>

which would translate an entry titled "Cafe" into "cafe".

=cut

sub _fltr_dirify {
    my ($str, $val, $ctx) = @_;
    return $str if (defined $val) && ($val eq '0');
    MT::Util::dirify($str, $val);
}

###########################################################################

=head2 sanitize

Filters input of particular HTML tags and other markup that may be unsafe
content. If the sanitize parameter is "1", it will use the MT configured
"GlobalSanitizeSpec" setting to control how it processes the input. But
the parameter may also specify this directly. For example:

    <$mt:CommentBody sanitize="b,strong,em,i,ul,li,ol,p,br/"$>

This would strip any HTML tags from the comment that are not specified
in this list.

=cut

sub _fltr_sanitize {
    my ($str, $val, $ctx) = @_;
    my $blog = $ctx->stash('blog');
    require MT::Sanitize;
    if ($val eq '1') {
        $val = ($blog && $blog->sanitize_spec) ||
                $ctx->{config}->GlobalSanitizeSpec;
    }
    MT::Sanitize->sanitize($str, $val);
}

###########################################################################

=head2 encode_html

Encodes any special characters into HTML entities (ie, '<' becomes '&lt;').

=cut

sub _fltr_encode_html {
    my ($str, $val, $ctx) = @_;
    MT::Util::encode_html($str, 1);
}

###########################################################################

=head2 encode_xml

Encodes input into an XML-friendly format. May wrap in a CDATA block
if the input contains tags or HTML entities.

=cut

sub _fltr_encode_xml {
    my ($str, $val, $ctx) = @_;
    MT::Util::encode_xml($str);
}

###########################################################################

=head2 encode_js

Encodes any special characters so that the string can be used safely as
the value in Javascript.

B<Example:>

    <script type="text/javascript">
    <!-- /* <![CDATA[ */
    var the_title = '<$MTEntryTitle encode_js="1"$>';
    /* ]]> */ -->

=cut

sub _fltr_encode_js {
    my ($str, $val, $ctx) = @_;
    MT::Util::encode_js($str);
}

###########################################################################

=head2 encode_php

Encodes any special characters so that the string can be used safely as
the value in PHP code.

The value of the attribute can be either C<qq> (double-quote interpolation),
C<here> (heredoc interpolation), or C<q> (single-quote interpolation). C<q>
is the default.

B<Example:>

    <?php
    $the_title = '<$MTEntryTitle encode_php="q"$>';
    $the_author = "<$MTEntryAuthorDisplayName encode_php="qq"$>";
    $the_text = <<<EOT
    <$MTEntryText encode_php="here"$>
    EOT
    ?>

=cut

sub _fltr_encode_php {
    my ($str, $val, $ctx) = @_;
    MT::Util::encode_php($str, $val);
}

###########################################################################

=head2 encode_url

URL encodes any special characters.

=cut

sub _fltr_encode_url {
    my ($str, $val, $ctx) = @_;
    MT::Util::encode_url($str);
}

###########################################################################

=head2 upper_case

Uppercases all alphabetic characters.

=cut

sub _fltr_upper_case {
    my ($str, $val, $ctx) = @_;
    return uppercase($str);
}

###########################################################################

=head2 lower_case

Lowercases all alphabetic characters.

=cut

sub _fltr_lower_case {
    my ($str, $val, $ctx) = @_;
    return lowercase($str);
}

###########################################################################

=head2 strip_linefeeds

Removes any linefeed characters from the input.

=cut

sub _fltr_strip_linefeeds {
    my ($str, $val, $ctx) = @_;
    $str =~ tr(\r\n)()d;
    $str;
}

###########################################################################

=head2 space_pad

Adds whitespace to the left of the input to the length specified.

B<Example:>

    <$mt:EntryBasename space_pad="10">

For a basename of "example", this would output: "   example".

=cut

sub _fltr_space_pad {
    my ($str, $val, $ctx) = @_;
    sprintf "%${val}s", $str;
}

###########################################################################

=head2 zero_pad

Adds '0' to the left of the input to the length specified.

B<Example:>

    <$mt:EntryID zero_pad="10"$>

For an entry id of 1023, this would output: "0000001023".

=cut

sub _fltr_zero_pad {
    my ($str, $val, $ctx) = @_;
    sprintf "%0${val}s", $str;
}

###########################################################################

=head2 string_format

An alias for the 'sprintf' modifier.

=cut

###########################################################################

=head2 sprintf

Formats the input text using the Perl 'sprintf' function. The value of
the 'sprintf' attribute is used as the sprintf pattern.

B<Example:>

    <$mt:EntryCommentCount sprintf="<%.6d>"$>

Outputs (for an entry with 1 comment):

    <000001>

Refer to Perl's documentation for sprintf for more examples.

=cut

sub _fltr_sprintf {
    my ($str, $val, $ctx) = @_;
    sprintf $val, $str;
}

###########################################################################

=head2 regex_replace

Applies a regular expression operation on the input. This filter accepts
B<two> input values: one is the pattern, the second is the replacement.

B<Example:>

    <$mt:EntryTitle regex_replace="/\s*\[.+?\]\s*$/",""$>

This would strip any bracketed phrase from the end of the entry
title field.

=cut

sub _fltr_regex_replace {
    my ($str, $val, $ctx) = @_;
    # This one requires an array
    return $str unless ref($val) eq 'ARRAY';
    my $patt = $val->[0];
    my $replace = $val->[1];
    if ($patt =~ m!^(/)(.+)\1([A-Za-z]+)?$!) {
        $patt = $2;
        my $global;
        if (my $opt = $3) {
            $global = 1 if $opt =~ m/g/;
            $opt =~ s/[ge]+//g;
            $patt = "(?$opt)" . $patt;
        }
        my $re = eval { qr/$patt/ };
        if (defined $re) {
            $replace =~ s!\\\\(\d+)!\$1!g; # for php, \\1 is how you write $1
            $replace =~ s!/!\\/!g;
            eval '$str =~ s/$re/' . $replace . '/' . ($global ? 'g' : '');
            if ($@) {
                return $ctx->error("Invalid regular expression: $@");
            }
        }
    }
    return $str;
}

###########################################################################

=head2 capitalize

Uppercases the first letter of each word in the input.

=cut

sub _fltr_capitalize {
    my ($str, $val, $ctx) = @_;
    $str =~ s/\b(\w+)\b/\u\L$1/g;
    return $str;
}

###########################################################################

=head2 count_characters

Outputs the number of characters found in the input.

=cut

sub _fltr_count_characters {
    my ($str, $val, $ctx) = @_;
    return length_text($str);
}

###########################################################################

=head2 cat

Append the input value with the value of the 'cat' attribute.

B<Example:>

    <$mt:EntryTitle cat="!!!1!"$>

=cut

sub _fltr_cat {
    my ($str, $val, $ctx) = @_;
    return $str . $val;
}

###########################################################################

=head2 count_paragraphs

Outputs the number of paragraphs found in the input.

=cut

sub _fltr_count_paragraphs {
    my ($str, $val, $ctx) = @_;
    my @paras = split /[\r\n]+/, $str;
    return scalar @paras;
}

###########################################################################

=head2 count_words

Outputs the number of words found in the input.

=cut

sub _fltr_count_words {
    my ($str, $val, $ctx) = @_;
    my @words = split /\s+/, $str;
    @words = grep /[A-Za-z0-9\x80-\xff]/, @words;
    return scalar @words;
}

# sub _fltr_date_format {
#     my ($str, $val, $ctx) = @_;
#     
# }

###########################################################################

=head2 escape

Similar to the 'encode_*' modifiers. The input is reformatted so that
certain special characters are translated depending on the value of
the 'escape' attribute. The following modes are recognized:

=over 4

=item * html

Similar to the 'encode_html' modifier. Escapes special characters as
HTML entities.

=item * url

Similar to the 'encode_url' modifier. Escapes special characters using
a URL-encoded format (ie, " " becomes "%20").

=item * javascript or js

Similar to the 'encode_js' modifier. Escapes special characters such
as quotes, newline characters, etc., so that the input can be placed
in a JavaScript string.

=item * mail

A very simple email obfuscation technique.

=back

=cut

sub _fltr_escape {
    my ($str, $val, $ctx) = @_;
    # val can be one of: html, htmlall, url, urlpathinfo, quotes,
    # hex, hexentity, decentity, javascript, mail, nonstd
    $val = lc($val);
    if ($val eq 'html') {
        $str = MT::Util::encode_html($str, 1);
    } elsif ($val eq 'htmlall') {
        # FIXME: implementation
    } elsif ($val eq 'url') {
        $str = MT::Util::encode_url($str);
    } elsif ($val eq 'urlpathinfo') {
        # FIXME: implementation
    } elsif ($val eq 'quotes') {
        # FIXME: implementation
    } elsif ($val eq 'hex') {
        # FIXME: implementation
    } elsif ($val eq 'hexentity') {
        # FIXME: implementation
    } elsif ($val eq 'decentity') {
        # FIXME: implementation
    } elsif ($val eq 'javascript' || $val eq 'js') {
        $str = MT::Util::encode_js($str);
    } elsif ($val eq 'mail') {
        $str =~ s/\./ [DOT] /g;
        $str =~ s/\@/ [AT] /g;
    } elsif ($val eq 'nonstd') {
        # FIXME: implementation
    }
    return $str;
}

###########################################################################

=head2 indent

Adds the specified amount of whitespace to the left of each line of
the input.

B<Example:>

    <$mt:EntryBody indent="4"$>

This adds 4 spaces to the left of each line of the L<EntryBody>
value.

=cut

sub _fltr_indent {
    my ($str, $val, $ctx) = @_;
    if ((my $len = int($val)) > 0) {
        my $space = ' ' x $len;
        $str =~ s/^/$space/mg;
    }
    return $str;
}

###########################################################################

=head2 nl2br

Converts any newline characters into HTML C<br> tags. If the value of
the 'nl2br' attribute is "xhtml", it will use the "C<<br />>" form
of the C<br> tag.

=cut

sub _fltr_nl2br {
    my ($str, $val, $ctx) = @_;
    if ($val eq 'xhtml') {
        $str =~ s/\r?\n/<br \/>/g;
    } else {
        $str =~ s/\r?\n/<br>/g;
    }
    return $str;
}

###########################################################################

=head2 replace

Issues a simple text search/replace on the input. This modifier requires
B<two> parameters.

B<Example:>

    <$mt:EntryBody replace="teh","the"$>

=cut

sub _fltr_replace {
    my ($str, $val, $ctx) = @_;
    # This one requires an array
    return $str unless ref($val) eq 'ARRAY';
    my $search = $val->[0];
    my $replace = $val->[1];
    $str =~ s/\Q$search\E/$replace/g;
    return $str;
}

###########################################################################

=head2 spacify

Interleaves the value of the C<spacify> attribute between each character
of the input.

B<Example:>

    <$mt:EntryTitle spacify=" "$>

Changing an entry title of "Hi there!" to "H i   t h e r e !".

=cut

sub _fltr_spacify {
    my ($str, $val, $ctx) = @_;
    my @c = split //, $str;
    return join $val, @c;
}

###########################################################################

=head2 strip

Replaces all whitespace with the value of the C<strip> attribute.

B<Example:>

    <$mt:EntryTitle strip="&nbsp;"$>

=cut

sub _fltr_strip {
    my ($str, $val, $ctx) = @_;
    $val = ' ' unless defined $val;
    $str =~ s/\s+/$val/g;
    return $str;
}

###########################################################################

=head2 strip_tags

An alias for L<remove_html>. Removes all HTML markup from the input.

=cut

sub _fltr_strip_tags {
    my ($str, $val, $ctx) = @_;
    return MT::Util::remove_html($str);
}

###########################################################################

=head2 _default

Outputs the value of the C<_default> attribute if the input string
is empty.

B<Example:>

    <$mt:BlogDescription _default="Not 'just another' Movable Type blog."$>

=cut

sub _fltr_default {
    my ($str, $val, $ctx) = @_;
    if ($str eq '') { return $val }
    return $str;
}

# sub _fltr_truncate {
#     my ($str, $val, $ctx) = @_;
# }

# sub _fltr_wordwrap {
#     my ($str, $val, $ctx) = @_;
# }

###########################################################################

=head2 wrap_text

Reformats the input, adding newline characters so the text "wraps"
at the length specified as the value for the C<wrap_text> attribute.
Example (this would format the entry text so it is suitable for
a text e-mail message):

    <$mt:EntryBody remove_html="1" wrap_text="72"$>

=cut

sub _fltr_wrap_text {
    my ($str, $val, $ctx) = @_;
    my $ret = wrap_text($str, $val);
    return $ret;
}

##  Core template tags

###########################################################################

=head2 TemplateNote

A function tag that always returns an empty string. This tag is useful
for placing simple notes in your templates, since it produces nothing.

B<Example:>

    <$mt:TemplateNote note="Hi, mom!"$>

=for tags templating

=cut

###########################################################################

=head2 Ignore

A block tag that always produces an empty string. This tag is useful
for wrapping template code you wish to disable, or perhaps annotating
sections of your template.

B<Example:>

    <mt:Ignore>
        The API key for the following tag is D3ADB33F.
    </mt:Ignore>

=for tags templating

=cut

###########################################################################

=head2 IfStatic

Returns true if the current publishing context is static publishing,
and false otherwise.

=for tags templating, utility

=cut

###########################################################################

=head2 IfDynamic

Returns true if the current publishing context is dynamic publishing,
and false otherwise.

=for tags templating, utility

=cut

###########################################################################

=head2 App:Listing

This application tag is used in MT application templates to produce
a table listing. It expects an C<object_loop> variable to be available,
or you can use the C<loop> attribute to have it use a different source.

It will output it's contents once for each row of the input array. It
produces markup that is compatible with the MT application templates
and CSS structure, so it is not meant for general blog publishing use.

The C<return_args> variable is recognized and will populate a hidden
field in the produced C<form> tag if available.

The C<blog_id> variable is recognized and will populate a hidden
field in the produced C<form> tag if available.

The C<screen_class> variable is recognized and will force the
C<hide_pager> attribute to 1 if it is set to 'search-replace'.

The C<magic_token> variable is recognized and will populate a hidden
field in the produced C<form> tag if available (or will retrieve
a token from the current application if unset).

The C<view_expanded> variable is recognized and will affect the
class name applied to the table. If assigned, the table tag will
receive a 'expanded' class; otherwise, it is given a 'compact'
class.

The C<listing_header> variable is recognized and will be output
in a C<div> tag (classed with 'listing-header') that appears
at the top of the listing. This is only output when 'actions'
are shown (see 'show_actions' attribute).

The structure of the output from a typical use like this:

    <MTApp:Listing type="entry">
        (contents of one row for table)
    </MTApp:Listing>

produces something like this:

    <div id="entry-listing" class="listing">
        <div class="listing-header">
        </div>
        <form id="entry-listing-form" class="listing-form"
            action="..../mt.cgi" method="post"
            onsubmit="return this['__mode'] ? true : false">
            <input type="hidden" name="__mode" value="" />
            <input type="hidden" name="_type" value="entry" />
            <input type="hidden" name="action_name" value="" />
            <input type="hidden" name="itemset_action_input" value="" />
            <input type="hidden" name="return_args" value="..." />
            <input type="hidden" name="blog_id" value="1" />
            <input type="hidden" name="magic_token" value="abcd" />
            <$MTApp:ActionBar bar_position="top"
                form_id="entry-listing-form"$>
            <table id="entry-listing-table"
                class="entry-listing-table compact" cellspacing="0">

                (contents of tag are placed here)

            </table>
            <$MTApp:ActionBar bar_position="bottom"
                form_id="entry-listing-form"$>
        </form>
    </div>

B<Attributes:>

=over 4

=item * type (optional)

The C<MT::Object> object type the listing is processing. If unset,
will use the contents of the C<object_type> variable.

=item * loop (optional)

The source of data to process. This is an array of hashes, similar
to the kind used with the L<Loop> tag. If unset, the C<object_loop>
variable is used instead.

=item * empty_message (optional)

Used when there are no rows to output for the listing. If not set,
it will process any 'else' block that is available instead, or, failing
that, will output an L<App:StatusMsg> tag saying that no data could be
found.

=item * id (optional)

Used to construct the DOM id for the listing. The outer C<div> tag
will use this value. If unset, it will be assigned C<type-listing> (where
'type' is the object type determined for the listing; see 'type'
attribute).

=item * listing_class (optional)

Provides a custom class name that can be applied to the main
C<div> tag produced (this is in addition to the 'listing' class
that is always applied).

=item * action (optional; default 'script_url' variable)

Supplies the 'action' attribute of the C<form> tag produced.

=item * hide_pager (optional; default '0')

Controls whether the pagination controls are shown or not.
If unspecified, pagination is shown.

=item * show_actions (optional; default '1')

Controls whether the actions associated with the object type
processed are shown or not. If unspecified, actions are shown.

=back

=for tags application

=cut

sub _hdlr_app_listing {
    my ($ctx, $args, $cond) = @_;

    my $type = $args->{type} || $ctx->var('object_type');
    my $class = MT->model($type) if $type;
    my $loop = $args->{loop} || 'object_loop';
    my $loop_obj = $ctx->var($loop);

    unless ((ref($loop_obj) eq 'ARRAY') && (@$loop_obj)) {
        my @else = @{ $ctx->stash('tokens_else') || [] };
        return &_hdlr_pass_tokens_else if @else;
        my $msg = $args->{empty_message} || MT->translate("No [_1] could be found.", $class ? lowercase($class->class_label_plural) : ($type ? $type : MT->translate("records")));
        return $ctx->build(qq{<mtapp:statusmsg
            id="zero-state"
            class="info zero-state">
            $msg
            </mtapp:statusmsg>});
    }

    my $id = $args->{id} || ($type ? $type . '-listing' : 'listing');
    my $listing_class = $args->{listing_class} || "";
    my $hide_pager = $args->{hide_pager} || 0;
    $hide_pager = 1 if ($ctx->var('screen_class') || '') eq 'search-replace';
    my $show_actions = exists $args->{show_actions} ? $args->{show_actions} : 1;
    my $return_args = $ctx->var('return_args') || '';
    $return_args = qq{\n        <input type="hidden" name="return_args" value="$return_args" />} if $return_args;
    my $blog_id = $ctx->var('blog_id') || '';
    $blog_id = qq{\n        <input type="hidden" name="blog_id" value="$blog_id" />} if $blog_id;
    my $token = $ctx->var('magic_token') || MT->app->current_magic;
    my $action = $args->{action} || '<mt:var name="script_url">';

    my $actions_top = "";
    my $actions_bottom = "";
    my $form_id = "$id-form";
    if ($show_actions) {
        $actions_top = qq{<\$MTApp:ActionBar bar_position="top" hide_pager="$hide_pager" form_id="$form_id"\$>};
        $actions_bottom = qq{<\$MTApp:ActionBar bar_position="bottom" hide_pager="$hide_pager" form_id="$form_id"\$>};
    } else {
        $listing_class .= " hide_actions";
    }

    my $insides;
    {
        local $args->{name} = $loop;
        defined($insides = _hdlr_loop($ctx, $args, $cond))
            or return;
    }
    my $listing_header = $ctx->var('listing_header') || '';
    my $view = $ctx->var('view_expanded') ? ' expanded' : ' compact';

    my $table = <<TABLE;
        <table id="$id-table" class="$id-table$view" cellspacing="0">
$insides
        </table>
TABLE

    if ($show_actions) {
        local $ctx->{__stash}{vars}{__contents__} = $table;
        return $ctx->build(<<EOT);
<div id="$id" class="listing $listing_class">
    <div class="listing-header">
        $listing_header
    </div>
    <form id="$form_id" class="listing-form"
        action="$action" method="post"
        onsubmit="return this['__mode'] ? true : false">
        <input type="hidden" name="__mode" value="" />
        <input type="hidden" name="_type" value="$type" />
        <input type="hidden" name="action_name" value="" />
        <input type="hidden" name="itemset_action_input" value="" />
$return_args
$blog_id
        <input type="hidden" name="magic_token" value="$token" />
        $actions_top
        <mt:var name="__contents__">
        $actions_bottom
    </form>
</div>
EOT
    }
    else {
        return <<EOT;
<div id="$id" class="listing $listing_class">
        $table
</div>
EOT
    }
}

###########################################################################

=head2 App:Link

Produces a application link to the current script with the mode and
attributes specified.

B<Attributes:>

=over 4

=item * mode

Maps to a '__mode' argument.

=item * type

Maps to a '_type' argument.

=back

B<Example:>

    <$MTApp:Link mode="foo" type="entry" bar="1"$>

produces:

    /cgi-bin/mt/mt.cgi?__mode=foo&_type=entry&bar=1

This tag produces unescaped '&' characters. If you use this tag
in an HTML tag attribute, be sure to add a C<escape="html"> attribute
which will encode these to HTML entities.

=for tags application

=cut

sub _hdlr_app_link {
    my ($ctx, $args, $cond) = @_;
    my $app = MT->instance;

    my %args = %$args;

    # eliminate special '@' argument (and anything other refs that may exist)
    ref($args{$_}) && delete $args{$_} for keys %args;

    # strip off any arguments that are actually global filters
    my $filters = MT->registry('tags', 'modifier');
    exists($filters->{$_}) && delete $args{$_} for keys %args;

    # remap 'type' attribute since we always express this as
    # a '_type' query parameter.
    my $mode = delete $args{mode} or return $ctx->error("mode attribute is required");
    $args{_type} = delete $args{type} if exists $args{type};
    if (exists $args{blog_id} && !($args{blog_id})) {
        delete $args{blog_id};
    } else {
        if (my $blog_id = $ctx->var('blog_id')) {
            $args{blog_id} = $blog_id;
        }
    }
    return $app->uri(mode => $mode, args => \%args);
}

###########################################################################

=head2 App:ActionBar

Produces markup for application templates for the strip of actions
for a application listing or edit screen.

B<Attributes:>

=over 4

=item * bar_position (optional; default "top")

Assigns a CSS class name indicating whether the control is above or
below the listing or edit form it is associated with.

=item * hide_pager

Assign either 1 or 0 to control whether the pagination controls are
displayed or not.

=item * form_id

Associates the pagition controls and item action widget with the
given form element.

=back

=for tags application

=cut

sub _hdlr_app_action_bar {
    my ($ctx, $args, $cond) = @_;
    my $pos = $args->{bar_position} || 'top';
    my $form_id = $args->{form_id} ? qq{ form_id="$args->{form_id}"} : "";
    my $pager = $args->{hide_pager} ? ''
        : qq{\n        <mt:include name="include/pagination.tmpl" bar_position="$pos">};
    my $buttons = $ctx->var('action_buttons') || '';
    return $ctx->build(<<EOT);
<div id="actions-bar-$pos" class="actions-bar actions-bar-$pos">
    <div class="actions-bar-inner pkg">$pager
        <span class="button-actions actions">$buttons</span>
        <span class="plugin-actions actions">
    <mt:include name="include/itemset_action_widget.tmpl"$form_id>
        </span>
    </div>
</div>
EOT
}

###########################################################################

=head2 App:Widget

An application template tag that produces HTML for displaying a MT CMS
dashboard widget. Custom widget templates should utilize this tag to wrap
their widget content.

B<Attributes:>

=over 4

=item * id (optional)

If specified, will be used as the 'id' attribute for the outermost C<div>
tag for the widget. If unspecified, will use the 'widget_id' template
variable instead.

=item * label (required)

The label to display above the widget.

=item * label_link (optional)

If specified, this link will wrap the label for the widget.

=item * label_onclick

If specified, this JavaScript code will be assigned to the 'onclick'
attribute of a link tag wrapping the widget label.

=item * class (optional)

If unspecified, will use the id of the widget. This class is included in the
'class' attribute of the outermost C<div> tag for the widget.

=item * header_action

=item * can_close (optional; default "0")

Identifies whether widget may be closed or not.

=item * tabbed (optional; default "0")

If specified, the widget will be assigned an attribute that gives it
a tabbed interface.

=back

B<Example:>

    <mtapp:Widget class="widget my-widget"
        label="<__trans phrase="All About Me">" can_close="1">
        (contents of widget go here)
    </mtapp:Widget>

=for tags application

=cut

sub _hdlr_app_widget {
    my ($ctx, $args, $cond) = @_;
    my $hosted_widget = $ctx->var('widget_id') ? 1 : 0;
    my $id = $args->{id} || $ctx->var('widget_id') || '';
    my $label = $args->{label};
    my $class = $args->{class} || $id;
    my $label_link = $args->{label_link} || "";
    my $label_onclick = $args->{label_onclick} || "";
    my $header_action = $args->{header_action} || "";
    my $closable = $args->{can_close} ? 1 : 0;
    if ($closable) {
        $header_action = qq{<a title="<__trans phrase="Remove this widget">" onclick="javascript:removeWidget('$id'); return false;" href="javascript:void(0);" class="widget-close-link"><span>close</span></a>};
    }
    my $widget_header = "";
    if ($label_link && $label_onclick) {
        $widget_header = "\n<h3 class=\"widget-label\"><a href=\"$label_link\" onclick=\"$label_onclick\"><span>$label</span></a></h3>";
    } elsif ($label_link) {
        $widget_header = "\n<h3 class=\"widget-label\"><a href=\"$label_link\"><span>$label</span></a></h3>";
    } else {
        $widget_header = "\n<h3 class=\"widget-label\"><span>$label</span></h3>";
    }
    my $token = $ctx->var('magic_token') || '';
    my $scope = $ctx->var('widget_scope') || 'system';
    my $singular = $ctx->var('widget_singular') || '';
    # Make certain widget_id is set
    my $vars = $ctx->{__stash}{vars};
    local $vars->{widget_id} = $id;
    local $vars->{widget_header} = '';
    local $vars->{widget_footer} = '';
    my $app = MT->instance;
    my $blog = $app->can('blog') ? $app->blog : $ctx->stash('blog');
    my $blog_field = $blog ? qq{<input type="hidden" name="blog_id" value="} . $blog->id . q{" />} : "";
    local $vars->{blog_id} = $blog->id if $blog;
    my $insides = $ctx->slurp($args, $cond);
    my $widget_footer = ($ctx->var('widget_footer') || '');
    my $var_header = ($ctx->var('widget_header') || '');
    if ($var_header =~ m/<h3[ >]/i) {
        $widget_header = $var_header;
    } else {
        $widget_header .= $var_header;
    }
    my $corners = $args->{corners} ? '<div class="corners"><b></b><u></u><s></s><i></i></div>' : "";
    my $tabbed = $args->{tabbed} ? ' mt:delegate="tab-container"' : "";
    my $header_class = $tabbed ? 'widget-header-tabs' : '';
    my $return_args = $app->make_return_args;
    my $cgi = $app->uri;
    if ($hosted_widget && (!$insides !~ m/<form\s/i)) {
        $insides = <<"EOT";
        <form id="$id-form" method="post" action="$cgi" onsubmit="updateWidget('$id'); return false">
        <input type="hidden" name="__mode" value="update_widget_prefs" />
        <input type="hidden" name="widget_id" value="$id" />
        $blog_field
        <input type="hidden" name="widget_action" value="save" />
        <input type="hidden" name="widget_scope" value="$scope" />
        <input type="hidden" name="widget_singular" value="$singular" />
        <input type="hidden" name="magic_token" value="$token" />
        <input type="hidden" name="return_args" value="$return_args" />
$insides
        </form>
EOT
    }
    return <<"EOT";
<div id="$id" class="widget pkg $class"$tabbed>
    <div class="widget-inner inner">
        <div class="widget-header $header_class">
            <div class="widget-header-inner pkg">
                $header_action
                $widget_header
            </div>
        </div>
        <div class="widget-content">
            <div class="widget-content-inner">
$insides
            </div>
        </div>
        <div class="widget-footer">$widget_footer</div>$corners
    </div>
</div>
EOT
}

###########################################################################

=head2 App:StatusMsg

An application template tag that outputs a MT status message.

B<Attributes:>

=over 4

=item * id (optional)

=item * class (optional; default "info")

=item * rebuild (optional)

Accepted values: "all", "index".

=item * can_close (optional; default "1")

=back

=for tags application

=cut

sub _hdlr_app_statusmsg {
    my ($ctx, $args, $cond) = @_;
    my $id = $args->{id};
    my $class = $args->{class} || 'info';
    my $msg = $ctx->slurp;
    my $rebuild = $args->{rebuild} || '';
    my $blog_id = $ctx->var('blog_id');
    my $blog = $ctx->stash('blog');
    if (!$blog && $blog_id) {
        $blog = MT->model('blog')->load($blog_id);
    }
    $rebuild = '' if $blog && $blog->custom_dynamic_templates eq 'all';
    $rebuild = qq{<__trans phrase="[_1]Publish[_2] your site to see these changes take effect." params="<a href="javascript:void(0);" class="rebuild-link" onclick="doRebuild('$blog_id');">%%</a>">} if $rebuild eq 'all';
    $rebuild = qq{<__trans phrase="[_1]Publish[_2] your site to see these changes take effect." params="<a href="javascript:void(0);" class="rebuild-link" onclick="doRebuild('$blog_id', 'prompt=index');">%%</a>">} if $rebuild eq 'index';
    my $close = '';
    if ($id && ($args->{can_close} || (!exists $args->{can_close}))) {
        $close = qq{<a href="javascript:void(0)" onclick="javascript:hide('$id');return false;" class="close-me"><span>close</span></a>};
    }
    $id = defined $id ? qq{ id="$id"} : "";
    $class = defined $class ? qq{msg msg-$class} : "msg";
    return <<"EOT";
    <div$id class="$class">$close$msg $rebuild</div>
EOT
}

###########################################################################

=head2 App:ListFilters

An application template tag used to produce an unordered list of quickfilters
for a given listing screen. The filters are drawn from a C<list_filters>
template variable which is an array of hashes.

B<Example:>

    <$mtapp:ListFilters$>

=cut

sub _hdlr_app_list_filters {
    my ($ctx, $args, $cond) = @_;
    my $app = MT->app;
    my $filters = $ctx->var("list_filters");
    return '' if (ref($filters) ne 'ARRAY') || (! @$filters );
    my $mode = $app->mode;
    my $type = $app->param('_type');
    my $type_param = "";
    $type_param = "&amp;_type=" . encode_url($type) if defined $type;
    return $ctx->build(<<EOT, $cond);
    <mt:loop name="list_filters">
        <mt:if name="__first__">
    <ul>
        </mt:if>
        <mt:if name="key" eq="\$filter_key"><li class="current-filter"><strong><mt:else><li></mt:if><a href="<mt:var name="script_url">?__mode=$mode$type_param<mt:if name="blog_id">&amp;blog_id=<mt:var name="blog_id"></mt:if>&amp;filter_key=<mt:var name="key" escape="url">"><mt:var name="label"></a><mt:if name="key" eq="\$filter_key"></strong></mt:if></li>
    <mt:if name="__last__">
    </ul>
    </mt:if>
    </mt:loop>
EOT
}

###########################################################################

=head2 App:PageActions

An application template tag used to produce an unordered list of actions
for a given listing screen. The actions are drawn from a C<page_actions>
template variable which is an array of hashes.

B<Example:>

    <$mtapp:PageActions$>

=for tags application

=cut

sub _hdlr_app_page_actions {
    my ($ctx, $args, $cond) = @_;
    my $app = MT->instance;
    my $from = $args->{from} || $app->mode;
    my $loop = $ctx->var('page_actions');
    return '' if (ref($loop) ne 'ARRAY') || (! @$loop);
    my $mt = '&amp;magic_token=' . $app->current_magic;
    return $ctx->build(<<EOT, $cond);
    <mtapp:widget
        id="page_actions"
        label="<__trans phrase="Actions">">
                <ul>
        <mt:loop name="page_actions">
            <mt:if name="page">
                    <li class="icon-left icon<mt:unless name="core">-plugin</mt:unless>-action"><a href="<mt:var name="page" escape="html"><mt:if name="page_has_params">&amp;</mt:if>from=$from<mt:if name="id">&amp;id=<mt:var name="id"></mt:if><mt:if name="blog_id">&amp;blog_id=<mt:var name="blog_id"></mt:if>$mt&amp;return_args=<mt:var name="return_args" escape="url">"<mt:if name="continue_prompt"> onclick="return confirm('<mt:var name="continue_prompt" escape="js">');"</mt:if>><mt:var name="label"></a></li>
            <mt:else><mt:if name="link">
                    <li class="icon-left icon<mt:unless name="core">-plugin</mt:unless>-action"><a href="<mt:var name="link" escape="html">&amp;from=$from<mt:if name="id">&amp;id=<mt:var name="id"></mt:if><mt:if name="blog_id">&amp;blog_id=<mt:var name="blog_id"></mt:if>$mt&amp;return_args=<mt:var name="return_args" escape="url">"<mt:if name="continue_prompt"> onclick="return confirm('<mt:var name="continue_prompt" escape="js">');"</mt:if>><mt:var name="label"></a></li>
            </mt:if><mt:if name="dialog">
                    <li class="icon-left icon<mt:unless name="core">-plugin</mt:unless>-action"><a href="javascript:void(0)" onclick="<mt:if name="continue_prompt">if(!confirm('<mt:var name="continue_prompt" escape="js">'))return false;</mt:if>return openDialog(false, '<mt:var name="dialog">', '<mt:if name="dialog_args"><mt:var name="dialog_args" escape="url">&amp;</mt:if>from=$from<mt:if name="id">&amp;id=<mt:var name="id"></mt:if><mt:if name="blog_id">&amp;blog_id=<mt:var name="blog_id"></mt:if>$mt&amp;return_args=<mt:var name="return_args" escape="url">')"><mt:var name="label"></a></li>
            </mt:if></mt:if>
        </mt:loop>
                </ul>
    </mtapp:widget>
EOT
}

###########################################################################

=head2 App:Form

Used for application templates that need to express a standard MT
application form. This produces certain hidden fields that are typically
required by MT application forms.

B<Attributes:>

=over 4

=item * action (optional)

Identifies the URL to submit the form to. If not given, will use
the current application URI.

=item * method (optional; default "POST")

Supplies the C<form> method. "GET" or "POST" are the typical values
for this, but will accept any HTTP-compatible method (ie: "PUT", "DELETE").

=item * object_id (optional)

Populates a hidden 'id' field in the form. If not given, will also use any
'id' template variable defined.

=item * blog_id (optional)

Populates a hidden 'blog_id' field in the form. If not given, will also use
any 'blog_id' template variable defined.

=item * object_type (optional)

Populates a hidden '_type' field in the form. If not given, will also use
any 'type' template variable defined.

=item * id (optional)

Used to form the 'id' element of the HTML C<form> tag. If not specified,
the C<form> tag 'id' element will be assigned TYPE-form, where TYPE is the
determined object_type.

=item * name (optional)

Supplies the C<form> name attribute. If unspecified, will use the C<id>
attribute, if available.

=item * enctype (optional)

If assigned, sets an 'enctype' attribute on the C<form> tag using the value
supplied. This is typically used to create a form that is capable of
uploading files.

=back

B<Example:>

    <mtapp:Form id="update" mode="update_blog_name">
        Blog Name: <input type="text" name="blog_name" />
        <input type="submit" />
    </mtapp:Form>

Producing:

    <form id="update" name="update" action="/cgi-bin/mt.cgi" method="POST">
    <input type="hidden" name="__mode" value="update_blog_name" />
        Blog Name: <input type="text" name="blog_name" />
        <input type="submit" />
    </form>

=for tags application

=cut

sub _hdlr_app_form {
    my ($ctx, $args, $cond) = @_;
    my $app = MT->instance;
    my $action = $args->{action} || $app->uri;
    my $method = $args->{method} || 'POST';
    my @fields;
    my $token = $ctx->var('magic_token');
    my $return = $ctx->var('return_args');
    my $id = $args->{object_id} || $ctx->var('id');
    my $blog_id = $args->{blog_id} || $ctx->var('blog_id');
    my $type = $args->{object_type} || $ctx->var('type');
    my $form_id = $args->{id} || $type . '-form';
    my $form_name = $args->{name} || $args->{id};
    my $enctype = $args->{enctype} ? " enctype=\"" . $args->{enctype} . "\"" : "";
    my $mode = $args->{mode};
    push @fields, qq{<input type="hidden" name="__mode" value="$mode" />}
        if defined $mode;
    push @fields, qq{<input type="hidden" name="_type" value="$type" />}
        if defined $type;
    push @fields, qq{<input type="hidden" name="id" value="$id" />}
        if defined $id;
    push @fields, qq{<input type="hidden" name="blog_id" value="$blog_id" />}
        if defined $blog_id;
    push @fields, qq{<input type="hidden" name="magic_token" value="$token" />}
        if defined $token;
    $return = encode_html($return) if $return;
    push @fields, qq{<input type="hidden" name="return_args" value="$return" />}
        if defined $return;
    my $fields = '';
    $fields = join("\n", @fields) if @fields;
    my $insides = $ctx->slurp($args, $cond);
    return <<"EOT";
<form id="$form_id" name="$form_name" action="$action" method="$method"$enctype>
$fields
    $insides
</form>
EOT
}

###########################################################################

=head2 App:SettingGroup

An application template tag used to wrap a number of L<App:Setting> tags.

B<Attributes:>

=over 4

=item * id (required)

A unique identifier for this group of settings.

=item * class (optional)

If specified, applies this CSS class to the C<fieldset> tag produced.

=item * shown (optional; default "1")

Controls whether the C<fieldset> is initially shown or not. If hidden,
a CSS "hidden" class is applied to the C<fieldset> tag.

=back

B<Example:>

    <MTApp:SettingGroup id="foo">
        <MTApp:Setting ...>
        <MTApp:Setting ...>
        <MTApp:Setting ...>
    </MTApp:SettingGroup>

=for tags application

=cut

sub _hdlr_app_setting_group {
    my ($ctx, $args, $cond) = @_;
    my $id = $args->{id};
    return $ctx->error("'id' attribute missing") unless $id;

    my $class = $args->{class} || "";
    my $shown = exists $args->{shown} ? ($args->{shown} ? 1 : 0) : 1;
    $class .= ($class ne '' ? " " : "") . "hidden" unless $shown;
    $class = qq{ class="$class"} if $class ne '';

    my $insides = $ctx->slurp($args, $cond);
    return <<"EOT";
<fieldset id="$id"$class>
    $insides
</fieldset>
EOT
}

###########################################################################

=head2 App:Setting

An application template tag used to display an application form field.

B<Attributes:>

=over 4

=item * id (required)

Each application setting tag requires a unique 'id' attribute. This id
should not be re-used within the template.

=item * required (optional; default "0")

Controls whether the field is displayed with visual cues that the
field is a required field or not.

=item * label

Supplies the label phrase for the setting.

=item * show_label (optional; default "1")

Controls whether the label portion of the setting is shown or not.

=item * shown (optional; default "1")

Controls whether the setting is visible or not. If specified, adds
a "hidden" class to the outermost C<div> tag produced for the
setting.

=item * label_class (optional)

Allows an additional CSS class to be applied to the label of the
setting.

=item * content_class (optional)

Allows an addtional CSS class to be applied to the contents of the
setting.

=item * hint (optional)

Supplies a "hint" phrase that provides inline instruction to the user.
By default, this hint is hidden, unless the 'show_hint' attribute
forces it to display.

=item * show_hint (optional; default "0")

Controls whether the inline help 'hint' label is shown or not.

=item * warning

Supplies a warning message to the user regarding the use of this setting.

=item * show_warning

Controls whether the warning message is shown or not.

=item * help_page

Identifies a specific page of the MT help documentation for this setting.

=item * help_section

Identifies a section name of the MT help documentation for this setting.

=back

B<Example:>

    <mtapp:Setting
        id="name"
        required="1"
        label="Username"
        hint="The username used to login">
            <input type="text" name="name" id="name" value="<$mt:Var name="name" escape="html"$>" />
    </mtapp:setting>

The basic structural output of a setting tag looks like this:

    <div id="ID-field" class="field pkg">
        <div class="field-inner">
            <div class="field-header">
                <label id="ID-label" for="ID">LABEL</label>
            </div>
            <div class="field-content">
                (content of App:Setting tag)
            </div>
        </div>
    </div>

=for tags application

=cut

sub _hdlr_app_setting {
    my ($ctx, $args, $cond) = @_;
    my $id = $args->{id};
    return $ctx->error("'id' attribute missing") unless $id;

    my $label = $args->{label};
    my $show_label = exists $args->{show_label} ? $args->{show_label} : 1;
    my $shown = exists $args->{shown} ? ($args->{shown} ? 1 : 0) : 1;
    my $label_class = $args->{label_class} || "";
    my $content_class = $args->{content_class} || "";
    my $hint = $args->{hint} || "";
    my $show_hint = $args->{show_hint} || 0;
    my $warning = $args->{warning} || "";
    my $show_warning = $args->{show_warning} || 0;
    my $indent = $args->{indent};
    my $help;
    # Formatting for help link, placed at the end of the hint.
    if ($help = $args->{help_page} || "") {
        my $section = $args->{help_section} || '';
        $section = qq{, '$section'} if $section;
        $help = qq{ <a href="javascript:void(0)" onclick="return openManual('$help'$section)" class="help-link">?</a><br />};
    }
    my $label_help = "";
    if ($label && $show_label) {
        # do nothing;
    } else {
        $label = ''; # zero it out, because the user turned it off
    }
    if ($hint && $show_hint) {
        $hint = "\n<div class=\"hint\">$hint$help</div>";
    } else {
        $hint = ''; # hiding hint because it is either empty or should not be shown
    }
    if ($warning && $show_warning) {
        $warning = qq{\n<p><img src="<mt:var name="static_uri">images/status_icons/warning.gif" alt="<__trans phrase="Warning">" width="9" height="9" />
<span class="alert-warning-inline">$warning</span></p>\n};
    } else {
        $warning = ''; # hiding hint because it is either empty or should not be shown
    }
    unless ($label_class) {
        $label_class = 'field-left-label';
    } else {
        $label_class = 'field-' . $label_class;
    }
    my $indent_css = "";
    if ($indent) {
        $indent_css = " style=\"padding-left: ".$indent."px;\""
    }
    # 'Required' indicator plus CSS class
    my $req = $args->{required} ? " *" : "";
    my $req_class = $args->{required} ? " required" : "";

    my $insides = $ctx->slurp($args, $cond);
    $insides =~ s/^\s*(<textarea)\b/<div class="textarea-wrapper">$1/g;
    $insides =~ s/(<\/textarea>)\s*$/$1<\/div>/g;

    my $class = $args->{class} || "";
    $class = ($class eq '') ? 'hidden' : $class . ' hidden' unless $shown;

    return $ctx->build(<<"EOT");
<div id="$id-field" class="field$req_class $label_class pkg $class"$indent_css>
    <div class="field-inner">
        <div class="field-header">
            <label id="$id-label" for="$id">$label$req</label>
        </div>
        <div class="field-content $content_class">
            $insides$hint$warning
        </div>
    </div>
</div>
EOT
}

###########################################################################

=head2 For

Many programming languages support the notion of a "for" loop. In the most
simple use case one could give, a for loop is a way to repeatedly execute a
piece of code n times.

Technically a for loop advances through a sequence (e.g. all odd numbers, all
even numbers, every nth number, etc), giving the programmer greater control
over the seed value (or "index") of each iteration through the loop.

B<Attributes:>

=over 4

=item * var (optional)

If assigned, the current 'index' of the loop is assigned to this template
variable.

=item * from (optional; default "0")

=item * start

Identifies the starting number for the loop.

=item * to

=item * end

Identifies the ending number for the loop. Either 'to' or 'end' must
be specified.

=item * step (optional; default "1")

=item * increment

Provides the amount to increment the loop counter.

=item * glue (optional)

If specified, this string is added inbetween each block of the loop.

=back

Within the tag, the following variables are assigned:

=over 4

=item * __first__

Assigned 1 when the loop is in the first iteration.

=item * __last__

Assigned 1 when the loop is in the last iteration.

=item * __odd__

Assigned 1 when the loop index is odd, 0 when it is even.

=item * __even__

Assigned 1 when the loop index is even, 0 when it is odd.

=item * __index__

Holds the current loop index value, even if the 'var' attribute has
been given.

=item * __counter__

Tracks the number of times the loop has run (starts at 1).

=back

B<Example:>

    <mt:For from="2" to="10" step="2" glue=","><$mt:Var name="__index__"$></mt:For>

Produces:

    2,4,6,8,10

=for tags loop, templating

=cut

sub _hdlr_for {
    my ($ctx, $args, $cond) = @_;

    my $start = (exists $args->{from} ? $args->{from} : $args->{start}) || 0;
    $start = 0 unless $start =~ /^-?\d+$/;
    my $end = (exists $args->{to} ? $args->{to} : $args->{end}) || 0;
    return q() unless $end =~ /^-?\d+$/;
    my $incr = $args->{increment} || $args->{step} || 1;
    # FIXME: support negative "step" values
    $incr = 1 unless $incr =~ /^\d+$/;
    $incr = 1 unless $incr;

    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');
    my $cnt = 1;
    my $out = '';
    my $vars = $ctx->{__stash}{vars} ||= {};
    my $glue = $args->{glue};
    my $var = $args->{var};
    for (my $i = $start; $i <= $end; $i += $incr) {
        local $vars->{__first__} = $i == $start;
        local $vars->{__last__} = $i == $end;
        local $vars->{__odd__} = ($cnt % 2 ) == 1;
        local $vars->{__even__} = ($cnt % 2 ) == 0;
        local $vars->{__index__} = $i;
        local $vars->{__counter__} = $cnt;
        local $vars->{$var} = $i if defined $var;
        my $res = $builder->build($ctx, $tokens, $cond);
        return $ctx->error($builder->errstr) unless defined $res;
        $out .= $glue
            if defined $glue && $cnt > 1 && length($out) && length($res);
        $out .= $res;
        $cnt++;
    }
    return $out;
}

###########################################################################

=head2 Else

A container tag used within If and Unless blocks to output the alternate
case.

This tag supports all of the attributes and logical operators available in
the L<If> tag and can be used multiple times to test for different
scenarios.

B<Example:>

    <mt:If name="some_variable">
        'some_variable' is assigned
    <mt:Else name="some_other_variable">
        'some_other_variable' is assigned
    <mt:Else>
        'some_variable' nor 'some_other_variable' is assigned
    </mt:If>

=for tags templating

=cut

sub _hdlr_else {
    my ($ctx, $args, $cond) = @_;
    local $args->{'@'};
    delete $args->{'@'};
    if  ((keys %$args) >= 1) {
        unless ($args->{name} || $args->{var} || $args->{tag}) {
            if ( my $t = $ctx->var('__cond_tag__') ) {
                $args->{tag} = $t;
            }
            elsif ( my $n = $ctx->var('__cond_name__') ) {
                $args->{name} = $n;
            }
        }
    }
    if (%$args) {
        defined(my $res = _hdlr_if(@_)) or return;
        return $res ? $ctx->slurp(@_) : $ctx->else();
    }
    return $ctx->slurp(@_);
}

###########################################################################

=head2 ElseIf

An alias for the 'Else' tag.

=for tags templating

=cut

sub _hdlr_elseif {
    my ($ctx, $args, $cond) = @_;
    unless ($args->{name} || $args->{var} || $args->{tag}) {
        if ( my $t = $ctx->var('__cond_tag__') ) {
            $args->{tag} = $t;
        }
        elsif ( my $n = $ctx->var('__cond_name__') ) {
            $args->{name} = $n;
        }
    }
    return _hdlr_else($ctx, $args, $cond);
}

###########################################################################

=head2 If

A conditional block that is evaluated if the attributes/modifiers evaluate
true. This tag can be used in combination with the L<ElseIf> and L<Else>
tags to test for a variety of cases.

B<Attributes:>

=over 4

=item * name

=item * var

Declares a variable to test. When none of the comparison attributes are
present ("eq", "ne", "lt", etc.) the If tag tests if the variable has
a "true" value, meaning if it is assigned a non-empty, non-zero value.

=item * tag

Declares a MT tag to execute; the value of which is used for testing.
When none of the comparison attributes are present ("eq", "ne", "lt", etc.)
the If tag tests if the specified tag produces a "true" value, meaning if
it produces a non-empty, non-zero value. For MT conditional tags, the
If tag passes through the logical result of that conditional tag.

=item * op

If specified, applies the specified mathematical operator to the value
being tested. 'op' may be one of the following (those that require a
second value use the 'value' attribute):

=over 4

=item * + or add

Addition.

=item * - or sub

Subtraction.

=item * ++ or inc

Adds 1 to the given value.

=item * -- or dec

Subtracts 1 from the given value.

=item * * or mul

Multiplication.

=item * / or div

Division.

=item * % or mod

Issues a modulus operator.

=back

=item * value

Used in conjunction with the 'op' attribute.

=item * eq

Tests whether the given value is equal to the value of the 'eq' attribute.

=item * ne

Tests whether the given value is not equal to the value of the 'ne' attribute.

=item * gt

Tests whether the given value is greater than the value of the 'gt' attribute.

=item * lt

Tests whether the given value is less than the value of the 'lt' attribute.

=item * ge

Tests whether the given value is greater than or equal to the value of the
'ge' attribute.

=item * le

Tests whether the given value is less than or equal to the value of the
'le' attribute.

=item * like

Tests whether the given value matches the regex pattern in the 'like'
attribute.

=item * test

Uses a Perl (or PHP under Dynamic Publishing) expression. For Perl, this
requires the "Safe" Perl module to be installed.

=back

B<Examples:>

If variable "foo" has a non-zero value:

    <mt:SetVar name="foo" value="bar">
    <mt:If name="foo">
        <!-- do something -->
    </mt:If>

If variable "foo" has a value equal to "bar":

    <mt:SetVar name="foo" value="bar">
    <mt:If name="foo" eq="bar">
        <!-- do something -->
    </mt:If>

If variable "foo" has a value that starts with "bar" or "baz":

    <mt:SetVar name="foo" value="barcamp" />
    <mt:If name="foo" like="^(bar|baz)">
        <!-- do something -->
    </mt:If>

If tag <$mt:EntryTitle$> has a value of "hello world":

    <mt:If tag="EntryTitle" eq="hello world">
        <!-- do something -->
    </mt:If>

If tag <$mt:CategoryCount$> is greater than 10 add "(Popular)" after
Category Label:

    <mt:Categories>
        <$mt:CategoryLabel$>
        <mt:If tag="CategoryCount" gt="10">(Popular)</mt:If>
    </mt:Categories>


If tag <$mt:EntryAuthor$> is "Melody" or "melody" and last name is "Nelson"
or "nelson" then do something:

    <mt:Authors>
        <mt:If tag="EntryAuthor" like="/(M|m)elody (N|n)elson/"
            <!-- do something -->
        </mt:If>
    </mt:Authors>

If the <$mt:CommenterEmail$> matches foo@domain.com or bar@domain.com:

    <mt:If tag="CommenterEmail" like="(foo@domain.com|bar@domain.com)">
        <!-- do something -->
    </mt:If>

If the <$mt:CommenterUsername$> matches the username of someone on the
Movable Type team:

    <mt:If tag="CommenterUsername" like="(beau|byrne|brad|jim|mark|fumiaki|yuji|djchall)">
        <!-- do something -->
    </mt:If>

If <$mt:EntryCategory$> is "Comic" then use the Comic template module
otherwise use the default:

    <mt:If tag="EntryCategory" eq="Comic">
        <$mt:Include module="Comic Entry Detail"$>
    <mt:Else>
        <$mt:Include module="Entry Detail"$>
    </mt:If>

If <$mt:EntryCategory$> is "Comic", "Sports", or "News" then link to the
category archive:

    <mt:If tag="EntryCategory" like="(Comic|Sports|News)">
        <a href="<$mt:CategoryArchiveLink$>"><$mt:CategoryLabel$></a>
    <mt:Else>
        <$mt:CategoryLabel$>
    </mt:If>

List all categories and link to categories it the category has one or more
entries:

    <mt:Categories show_empty="1">
        <mt:If name="__first__">
    <ul>
        </mt:If>
        <mt:If tag="CategoryCount" gte="1">
        <li><a href="<$MTCategoryArchiveLink$>"><$MTCategoryLabel$></a></li>
        <mt:Else>
        <li><$MTCategoryLabel$></li>
        </mt:If>
        <mt:If name="__last__">
    </ul>
        </mt:If>
    </mt:Categories>

Test a variable using Perl:

    <mt:If test="length($some_variable) > 10">
        '<$mt:Var name="some_variable"$>' is 11 characters or longer
    </mt:If>

=for tags templating

=cut

sub _hdlr_if {
    my ($ctx, $args, $cond) = @_;
    my $var = $args->{name} || $args->{var};
    my $value;
    if (defined $var) {
        # pick off any {...} or [...] from the name.
        my ($index, $key);
        if ($var =~ m/^(.+)([\[\{])(.+)[\]\}]$/) {
            $var = $1;
            my $br = $2;
            my $ref = $3;
            if ($ref =~ m/^\$(.+)/) {
                $ref = $ctx->var($1);
            }
            $br eq '[' ? $index = $ref : $key = $ref;
        } else {
            $index = $args->{index} if exists $args->{index};
            $key = $args->{key} if exists $args->{key};
        }

        $value = $ctx->var($var);
        if (ref($value)) {
            if (UNIVERSAL::isa($value, 'MT::Template')) {
                local $value->{context} = $ctx;
                $value = $value->output();
            } elsif (UNIVERSAL::isa($value, 'MT::Template::Tokens')) {
                local $ctx->{__stash}{tokens} = $value;
                $value = _hdlr_pass_tokens(@_) or return;
            } elsif (ref($value) eq 'ARRAY') {
                $value = $value->[$index] if defined $index;
            } elsif (ref($value) eq 'HASH') {
                $value = $value->{$key} if defined $key;
            }
        }
    }
    elsif (defined(my $tag = $args->{tag})) {
        $tag =~ s/^MT:?//i;
        my ($handler, $type) = $ctx->handler_for($tag);
        if (defined($handler)) {
            local $ctx->{__stash}{tag} = $args->{tag};
            $value = $handler->($ctx, { %$args });
            if ($type == 2) { # conditional tag; just use boolean
                $value = $value ? 1 : 0;
            } else {
                if (my $ph = $ctx->post_process_handler) {
                    $value = $ph->($ctx, $args, $value);
                }
            }
            $ctx->{__stash}{vars}{__cond_tag__} = $args->{tag};
        }
        else {
            return $ctx->error(MT->translate("Invalid tag [_1] specified.", $tag));
        }
    }

    $ctx->{__stash}{vars}{__cond_value__} = $value;
    $ctx->{__stash}{vars}{__cond_name__} = $var;

    if ( my $op = $args->{op} ) {
        my $rvalue = $args->{'value'};
        if ( $op && (defined $value) && !ref($value) ) {
            $value = _math_operation($ctx, $op, $value, $rvalue);
        }
    }

    my $numeric = qr/^[-]?\d+(\.\d+)?$/;
    no warnings;
    if (exists $args->{eq}) {
        return 0 unless defined($value);
        my $eq = $args->{eq};
        if ($value =~ m/$numeric/ && $eq =~ m/$numeric/) {
            return $value == $eq;
        } else {
            return $value eq $eq;
        }
    }
    elsif (exists $args->{ne}) {
        return 0 unless defined($value);
        my $ne = $args->{ne};
        if ($value =~ m/$numeric/ && $ne =~ m/$numeric/) {
            return $value != $ne;
        } else {
            return $value ne $ne;
        }
    }
    elsif (exists $args->{gt}) {
        return 0 unless defined($value);
        my $gt = $args->{gt};
        if ($value =~ m/$numeric/ && $gt =~ m/$numeric/) {
            return $value > $gt;
        } else {
            return $value gt $gt;
        }
    }
    elsif (exists $args->{lt}) {
        return 0 unless defined($value);
        my $lt = $args->{lt};
        if ($value =~ m/$numeric/ && $lt =~ m/$numeric/) {
            return $value < $lt;
        } else {
            return $value lt $lt;
        }
    }
    elsif (exists $args->{ge}) {
        return 0 unless defined($value);
        my $ge = $args->{ge};
        if ($value =~ m/$numeric/ && $ge =~ m/$numeric/) {
            return $value >= $ge;
        } else {
            return $value ge $ge;
        }
    }
    elsif (exists $args->{le}) {
        return 0 unless defined($value);
        my $le = $args->{le};
        if ($value =~ m/$numeric/ && $le =~ m/$numeric/) {
            return $value <= $le;
        } else {
            return $value le $le;
        }
    }
    elsif (exists $args->{like}) {
        my $like = $args->{like};
        if (!ref $like) {
            if ($like =~ m!^/.+/([si]+)?$!s) {
                my $opt = $1;
                $like =~ s!^/|/([si]+)?$!!g; # /abc/ => abc
                $like = "(?$opt)" . $like if defined $opt;
            }
            my $re = eval { qr/$like/ };
            return 0 unless $re;
            $args->{like} = $like = $re;
        }
        return defined($value) && ($value =~ m/$like/) ? 1 : 0;
    }
    elsif (exists $args->{test}) {
        my $expr = $args->{'test'};
        my $safe = $ctx->{__safe_compartment};
        if (!$safe) {
            $safe = eval { require Safe; new Safe; }
                or return $ctx->error("Cannot evaluate expression [$expr]: Perl 'Safe' module is required.");
            $ctx->{__safe_compartment} = $safe;
        }
        my $vars = $ctx->{__stash}{vars};
        my $ns = $safe->root;
        {
            no strict 'refs';
            foreach my $v (keys %$vars) {
                # or should we be using $ctx->var here ?
                # can we limit this step to just the variables
                # mentioned in $expr ??
                ${ $ns . '::' . $v } = $vars->{$v};
            }
        }
        my $res = $safe->reval($expr);
        if ($@) {
            return $ctx->error("Error in expression [$expr]: $@");
        }
        return $res;
    }
    if ((defined $value) && $value) {
        if (ref($value) eq 'ARRAY') {
            return @$value ? 1 : 0;
        }
        return 1;
    }
    return 0;
}

###########################################################################

=head2 Unless

A conditional tag that is the logical opposite of the L<If> tag. All
attributes supported by the L<If> tag are also supported for this tag.

=for tags templating

=cut

###########################################################################

=head2 Loop

This tag is primarily used for MT application templates, for processing
a Perl array of hashref data. This tag's heritage comes from the
CPAN HTML::Template module and it's C<TMPL_LOOP> tag and offers similar
capabilities. This tag can also handle a hashref variable, which
causes it to loop over all keys in the hash.

B<Attributes:>

=over 4

=item * name

=item * var

The template variable that contains the array of hashref data to
process.

=item * sort_by (optional)

Causes the data in the given array to be resorted in the manner
specified. The 'sort_by' attribute may specify "key" or "value"
and may additionally include the keywords "numeric" (to imply
a numeric sort instead of the default alphabetic sort) and/or
"reverse" to force the sort to be done in reverse order.

B<Example:>

    sort_by="key reverse"; sort_by="value numeric"

=item * glue (optional)

If specified, this string will be placed inbetween each "row"
of data produced by the loop tag.

=back

Within the tag, the following variables are assigned and may
be used:

=over 4

=item * __first__

Assigned when the loop is in the first iteration.

=item * __last__

Assigned when the loop is in the last iteration.

=item * __odd__

Assigned 1 when the loop is on odd numbered rows, 0 when even.

=item * __even__

Assigned 1 when the loop is on even numbered rows, 0 when odd.

=item * __key__

When looping over a hashref template variable, this variable is
assigned the key currently in context.

=item * __value__

This variable holds the value of the array or hashref element
currently in context.

=back

=for tags loop, templating

=cut

sub _hdlr_loop {
    my ($ctx, $args, $cond) = @_;
    my $name = $args->{name} || $args->{var};
    my $var = $ctx->var($name);
    return '' unless $var
      && ( (ref($var) eq 'ARRAY') && (scalar @$var) )
        || ( (ref($var) eq 'HASH') && (scalar(keys %$var)) );

    my $hash_var;
    if ( 'HASH' eq ref($var) ) {
        $hash_var = $var;
        my @keys = keys %$var;
        $var = \@keys;
    }
    if (my $sort = $args->{sort_by}) {
        $sort = lc $sort;
        if ($sort =~ m/\bkey\b/) {
            @$var = sort {$a cmp $b} @$var;
        } elsif ($sort =~ m/\bvalue\b/) {
            no warnings;
            if ($sort =~ m/\bnumeric\b/) {
                no warnings;
                if (defined $hash_var) {
                    @$var = sort {$hash_var->{$a} <=> $hash_var->{$b}} @$var;
                } else {
                    @$var = sort {$a <=> $b} @$var;
                }
            } else {
                if (defined $hash_var) {
                    @$var = sort {$hash_var->{$a} cmp $hash_var->{$b}} @$var;
                } else {
                    @$var = sort {$a cmp $b} @$var;
                }
            }
        }
        if ($sort =~ m/\breverse\b/) {
            @$var = reverse @$var;
        }
    }

    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');
    my $out = '';
    my $i = 1;
    my $vars = $ctx->{__stash}{vars} ||= {};
    my $glue = $args->{glue};
    foreach my $item (@$var) {
        local $vars->{__first__} = $i == 1;
        local $vars->{__last__} = $i == scalar @$var;
        local $vars->{__odd__} = ($i % 2 ) == 1;
        local $vars->{__even__} = ($i % 2 ) == 0;
        local $vars->{__counter__} = $i;
        my @names;
        if (UNIVERSAL::isa($item, 'MT::Object')) {
            @names = @{ $item->column_names };
        } else {
            if (ref($item) eq 'HASH') {
                @names = keys %$item;
            } elsif ( $hash_var ) {
                @names = ( '__key__', '__value__' );
            } else {
                @names = '__value__';
            }
        }
        my @var_names;
        push @var_names, lc $_ for @names;
        local @{$vars}{@var_names};
        if (UNIVERSAL::isa($item, 'MT::Object')) {
            $vars->{lc($_)} = $item->column($_) for @names;
        } elsif (ref($item) eq 'HASH') {
            $vars->{lc($_)} = $item->{$_} for @names;
        } elsif ( $hash_var ) {
            $vars->{'__key__'} = $item;
            $vars->{'__value__'} = $hash_var->{$item};
        } else {
            $vars->{'__value__'} = $item;
        }
        my $res = $builder->build($ctx, $tokens, $cond);
        return $ctx->error($builder->errstr) unless defined $res;
        if ($res ne '') {
            $out .= $glue if defined $glue && $i > 1 && length($out) && length($res);
            $out .= $res;
            $i++;
        }
    }
    return $out;
}

###########################################################################

=head2 GetVar

An alias for the 'Var' tag, and considered deprecated in favor of 'Var'.

=for tags deprecated

=cut

###########################################################################

=head2 Var

A B<function tag> used to store and later output data in a template.

B<Attributes:>

=over 4

=item * name (or var)

Identifies the template variable. The 'name' attribute supports a variety
of expressions. The typical case is a simple variable name:

    <$mt:Var name="foo"$>

Template variables may be arrays, or hash variables, in which case you
may want to reference a specific element instead of the array or hash
itself.

This selects the second element from the 'foo' array template variable:

    <$mt:Var name="foo[1]"$>

This selects the 'bar' element from the 'foo' hash template variable:

    <$mt:Var name="foo{bar}"$>

Sometimes you want to obtain the value of a function that is applied
to a variable (see the 'function' attribute). This will obtain the
number of elements in the 'foo' array:

    <$mt:Var name="count(foo)"$>

Excluding the punctuation required in the examples above, the 'name'
attribute value should contain only alphanumeric characters and,
optionally, underscores.

=item * value

In the simplest case, this attribute triggers I<assignment> of the
specified value to the variable.

    <$mt:Var name="little_pig_count" value="3"$>          # Stores 3

However, if provided with the 'op' attribute (see below), the value becomes
the operand for the specified mathematical operation and no assignment takes
place.

The 'value' attribute can contain anything other than a double quote. If you
need to use a double quote or the value is very long, you may want to use
the L<SetVarBlock> tag or the L<setvar> global modifier instead.

=item * op

Used along with the 'value' attribute to perform a number of mathematical
operations on the value of the variable.  When used in this way, the stored
value of the variable doesn't change but instead gets transformed in the
process of being output.

    <$mt:Var name="little_pig_count">                     # Displays 3
    <$mt:Var name="little_pig_count" value="1" op="sub"$> # Displays 2
    <$mt:Var name="little_pig_count" value="2" op="sub"$> # Displays 1
    <$mt:Var name="little_pig_count" value="3" op="sub"$> # Displays 0

See the L<If> tag for the list of supported operators.

=item * prepend

When used in conjuction with the 'value' attribute to store a value, this
attribute acts as a flag (i.e. 'prepend="1"') to indicate that the new value
should be added to the front of any existing value instead of replacing it.

    <$mt:Var name="greeting" value="World"$>
    <$mt:Var name="greeting" value="Hello " prepend="1"$>
    <$mt:Var name="greeting"$>  # Displays: Hello World

=item * append

When used in conjuction with the 'value' attribute to store a value, this
attribute acts as a flag (i.e. 'append="1"') to indicate that the new value
should be added to the back of any existing value instead of replacing it.

    <$mt:Var name="greeting" value="Hello"$>
    <$mt:Var name="greeting" value=" World" append="1"$>
    <$mt:Var name="greeting"$>  # Displays: Hello World

=item * function

For array template variables, this attribute supports:

=over 4

=item * push

Adds the element to the end of the array (becomes the last element).

=item * pop

Removes an element from the end of the array (last element) and
outputs it.

=item * unshift

Adds the element to the front of the array (index 0).

=item * shift

Takes an element from the front of the array (index 0).

=item * count

Returns the number of elements in the array template variable.

=back

For hash template variables, this attribute supports:

=over 4

=item * delete

Only valid when used with the 'key' attribute, or if a key is present
in the variable name.

=item * count

Returns the number of keys present in the hash template variable.

=back

=item * index

Identifies an element of an array template variable.

=item * key

Identifies a value stored for the key of a hash template variable.

=item * default

If the variable is undefined or empty, this value will be output
instead. Use of the 'default' and 'setvar' attributes together make
for an excellent way to conditionally initialize variables. The
following sets the "max_pages" variable to 10 if and only if it does
not yet have a value.

    <mt:var name="max_pages" default="10" setvar="max_pages"> 

=item * to_json

Formats the variable in JSON notation.

=item * glue

For array template variables, this attribute is used in joining the
values of the array together.

=back

=for tags templating

=cut

sub _hdlr_get_var {
    my ($ctx, $args, $cond) = @_;
    if ( exists( $args->{value} )
      && !exists( $args->{op} ) ) {
        return &_hdlr_set_var(@_);
    }
    my $name = $args->{name} || $args->{var};
    return $ctx->error(MT->translate(
        "You used a [_1] tag without a valid name attribute.", "<MT" . $ctx->stash('tag') . ">" ))
        unless defined $name;

    my ($func, $key, $index, $value);
    if ($name =~ m/^(\w+)\((.+)\)$/) {
        $func = $1;
        $name = $2;
    } else {
        $func = $args->{function} if exists $args->{function};
    }

    # pick off any {...} or [...] from the name.
    if ($name =~ m/^(.+)([\[\{])(.+)[\]\}]$/) {
        $name = $1;
        my $br = $2;
        my $ref = $3;
        if ($ref =~ m/^\$(.+)/) {
            $ref = $ctx->var($1);
            $ref = chr(0) unless defined $ref;
        }
        $br eq '[' ? $index = $ref : $key = $ref;
    } else {
        $index = $args->{index} if exists $args->{index};
        $key = $args->{key} if exists $args->{key};
    }

    if ($name =~ m/^\$/) {
        $name = $ctx->var($name);
    }

    if (defined $name) {
        $value = $ctx->var($name);
        if (ref($value) eq 'CODE') { # handle coderefs
            $value = $value->(@_);
        }
        if (ref($value)) {
            if (UNIVERSAL::isa($value, 'MT::Template')) {
                local $args->{name} = undef;
                local $args->{var} = undef;
                local $value->{context} = $ctx;
                $value = $value->output($args);
            } elsif (UNIVERSAL::isa($value, 'MT::Template::Tokens')) {
                local $ctx->{__stash}{tokens} = $value;
                local $args->{name} = undef;
                local $args->{var} = undef;
                $ctx->var($_, $args->{$_}) for keys %{$args || {}};
                $value = _hdlr_pass_tokens(@_) or return;
            } elsif (ref($value) eq 'ARRAY') {
                if ( defined $index ) {
                    if ($index =~ /^-?\d+$/) {
                        $value = $value->[ $index ];
                    } else {
                        $value = undef; # fall through to any 'default'
                    }
                }
                elsif ( defined $func ) {
                    $func = lc $func;
                    if ( 'pop' eq $func ) {
                        $value = @$value ? pop @$value : undef;
                    }
                    elsif ( 'shift' eq $func ) {
                        $value = @$value ? shift @$value : undef;
                    }
                    elsif ( 'count' eq $func ) {
                        $value = scalar @$value;
                    }
                    else {
                        return $ctx->error(
                            MT->translate("'[_1]' is not a valid function for an array.", $func)
                        );
                    }
                }
                else {
                    unless ($args->{to_json}) {
                        my $glue = exists $args->{glue} ? $args->{glue} : "";
                        $value = join $glue, @$value;
                    }
                }
            } elsif ( ref($value) eq 'HASH' ) {
                if ( defined $key ) {
                    if ( defined $func ) {
                        if ( 'delete' eq lc($func) ) {
                            $value = delete $value->{$key};
                        } else {
                            return $ctx->error(
                                MT->translate("'[_1]' is not a valid function for a hash.", $func)
                            );
                        }
                    } else {
                        if ($key ne chr(0)) {
                            $value = $value->{$key};
                        } else {
                            $value = undef;
                        }
                    }
                }
                elsif ( defined $func ) {
                    if ( 'count' eq lc($func) ) {
                        $value = scalar( keys %$value );
                    }
                    else {
                        return $ctx->error(
                            MT->translate("'[_1]' is not a valid function for a hash.", $func)
                        );
                    }
                }
            }
        }
        if ( my $op = $args->{op} ) {
            my $rvalue = $args->{'value'};
            if ( $op && (defined $value) && !ref($value) ) {
                $value = _math_operation($ctx, $op, $value, $rvalue);
            }
        }
    }
    if ((!defined $value) || ($value eq '')) {
        if (exists $args->{default}) {
            $value = $args->{default};
        }
    }

    if (ref($value) && $args->{to_json}) {
        require JSON;
        return JSON::to_json($value);
    }
    return defined $value ? $value : "";
}

###########################################################################

=head2 IfImageSupport

A conditional tag that returns true when the Movable Type installation
has the Perl modules necessary for manipulating image files.

=cut

sub _hdlr_if_image_support {
    my ($ctx, $args, $cond) = @_;
    my $if_image_support = MT->request('if_image_support');
    if (!defined $if_image_support) {
        require MT::Image;
        $if_image_support = defined MT::Image->new ? 1 : 0;
        MT->request('if_image_support', $if_image_support);
    }
    return $if_image_support;
}

###########################################################################

=head2 BuildTemplateID

Returns the ID of the template (index, archive or system template) currently
being built.

=cut

sub _hdlr_build_template_id {
    my ($ctx, $args, $cond) = @_;
    my $tmpl = $ctx->stash('template');
    if ($tmpl && $tmpl->id) {
        return $tmpl->id;
    }
    return 0;
}

###########################################################################

=head2 EntryIfTagged

Conditional tag used to test whether the current entry in context has
been assigned tags, or if it is assigned a specific tag.

B<Attributes:>

=over 4

=item * tag or name

If either 'name' or 'tag' are specified, tests the entry in context
for whether it has a tag association by that name.

=back

=for tags tags, entries

=cut

sub _hdlr_entry_if_tagged {
    my ($ctx, $args, $cond) = @_;
    my $entry = $ctx->stash('entry');
    return 0 unless $entry;
    my $tag = defined $args->{name} ? $args->{name} : (defined $args->{tag} ? $args->{tag} : '');
    if ($tag ne '') {
        $entry->has_tag($tag);
    } else {
        my @tags = $entry->tags;
        @tags = grep /^[^@]/, @tags;
        return @tags ? 1 : 0;
    }
}

sub _tags_for_blog {
    my ($ctx, $terms, $args, $type) = @_;
    my $r = MT::Request->instance;
    my $tag_cache = $r->stash('blog_tag_cache:' . $type) || {};
    my @tags;
    my $cache_id;
    my $all_count;
    my $class = MT->model($type);

    if (ref $terms->{blog_id} eq 'ARRAY') {
        $cache_id = join ',', @{$terms->{blog_id}};
        $cache_id = '!' . $cache_id if $args->{not}{blog_id};
    } else {
        $cache_id = $terms->{blog_id} || 'all';
    }
    if (!$tag_cache->{$cache_id}{tags}) {
        require MT::Tag;
        @tags = MT::Tag->load_by_datasource($class->datasource, { is_private => 0, %$terms }, { %$args });
        $tag_cache->{$cache_id} = { tags => \@tags };
        $r->stash('blog_tag_cache:' . $type, $tag_cache);
    } else {
        @tags = @{ $tag_cache->{$cache_id}{tags} };
    }

    if (!exists $tag_cache->{$cache_id}{min}) {
        require MT::Entry;
        my $min = 0;
        my $max = 0;
        foreach my $tag (@tags) {
            #clear cached count
            $tag->{__entry_count} = 0 if exists $tag->{__entry_count};
        }
        my %tags = map { $_->id => $_ } @tags;
        my $count_iter = $class->count_group_by({
            'asset' eq lc $type ? () :
                (status => MT::Entry::RELEASE()),
            %$terms,
            },{
            group => ['objecttag_tag_id'],
            'join' => MT::ObjectTag->join_on('object_id', { object_datasource => $class->datasource, %$terms }, $args),
            'asset' eq lc $type ? (no_class => 1) : (),
            %$args
        });            
        while (my ($count, $tag_id) = $count_iter->()) {
            $tags{$tag_id}->{__entry_count} = $count;
            $min = $count if ($count && ($count < $min)) || $min == 0;
            $max = $count if $count && ($count > $max);
            $all_count += $count;
        }
        $tag_cache->{$cache_id}{min} = $min;
        $tag_cache->{$cache_id}{max} = $max;
        $tag_cache->{$cache_id}{all_count} = $all_count;
        $tag_cache->{$cache_id}{tags} = [] unless $min;
    }
    ($tag_cache->{$cache_id}{tags}, $tag_cache->{$cache_id}{min}, $tag_cache->{$cache_id}{max}), $tag_cache->{$cache_id}{all_count};
}

sub _tag_sort {
    my ($tags, $column, $order) = @_;
    $column ||= 'name';
    $order ||= ($column eq 'name' ? 'ascend' : 'descend');
    no warnings;
    if ($column eq 'rank' or $column eq 'count') {
        @$tags = grep { $_->{__entry_count} }
            lc $order eq 'ascend'
                ? sort { $a->{__entry_count} <=> $b->{__entry_count} } @$tags
                : sort { $b->{__entry_count} <=> $a->{__entry_count} } @$tags;
    } elsif ($column eq 'id') {
        @$tags = grep { $_->{__entry_count} }
            lc $order eq 'descend'
                ? sort { $b->{column_values}{$column} <=> $a->{column_values}{$column} } @$tags
                : sort { $a->{column_values}{$column} <=> $b->{column_values}{$column} } @$tags;
    } else {
        @$tags = grep { $_->{__entry_count} }
            lc $order eq 'descend'
                ? sort { lc $b->{column_values}{name} cmp lc $a->{column_values}{name} } @$tags
                : sort { lc $a->{column_values}{name} cmp lc $b->{column_values}{name} } @$tags;
    }
}

###########################################################################

=head2 Tags

A container tag used for listing all tags in use on the blog in context.

B<Attributes:>

=over 4

=item * glue

A text string that is used to join each of the items together. For example

    <mt:Tags glue=", "><$mt:TagName$></mt:Tags>
    
would print out each tag name separated by a comma and a space.

=item * type

The kind of object for which to show tags. Valid values in a default
installation are C<entry> (the default), C<page>, C<asset>, C<audio>,
C<video> and C<image>. Plugins can extend this to other object classes.

=item * sort_by

The tag object column on which to order the tags. Common values are name and
rank. By default tags are sorted by name.

=item * sort_order

The direction in which to sort tags by the sort_by field. Possible values
are ascend and descend. By default, tags are shown in ascending order
when sorted by name and descending order when sorted by other columns.

=item * limit

A number of tags to show. If given, only the first tags as ordered by
sort_by and sort_order are shown.

=item * top

A number of tags to show. If given, only the given number of tags with
the most uses are shown. For example:

    <mt:Tags top="20">
        <$mt:TagName$>
    </mt:Tags>

is equivalent to

    <mt:Tags limit="20" sort_by="rank">
        <$mt:TagName$>
    </mt:Tags>

Note that even when top is used, the tags are shown in the order specified
with sort_by and sort_order.

=back

The following code is functional on any template. It prints a simple list
of tags for a blog, each linked to a tag search.

    <ul>
        <mt:Tags>
        <li>
            <a href="<$mt:TagSearchLink$>"><$mt:TagName$></a>
        </li>
        </mt:Tags>
    </ul>

Using tags like L<TagRank> and L<TagCount> and proper page styling, you
can make this simple code into a powerful looking and useful "tag cloud".

    <ul>
        <mt:Tags top="20">
        <li class="rank-<$mt:TagRank max="10"$> widget-list-item">
            <a href="<$mt:TagSearchLink$>"><$mt:TagName$></a>
        </li>
        </mt:Tags>
    </ul>

=for tags tags, multiblog, loop

=cut

sub _hdlr_tags {
    my ($ctx, $args, $cond) = @_;

    require MT::Tag;
    require MT::ObjectTag;
    require MT::Entry;
    my $type = $args->{type} || MT::Entry->datasource;

    unless ($args->{blog_id} || $args->{include_blogs} || $args->{exclude_blogs}) {
        my $app = MT->instance;
        if ($app->isa('MT::App::Search')) {
            my $exclude_blogs = $app->{searchparam}{ExcludeBlogs};
            my $include_blogs = $app->{searchparam}{IncludeBlogs};
            if (my $excl = ($exclude_blogs && (0 < scalar(keys %$exclude_blogs))) ? $exclude_blogs : undef) {
                $args->{exclude_blogs} ||= join ',', keys %$excl;
            } elsif (my $incl = ($include_blogs && (0 < scalar(keys %$include_blogs))) ? $include_blogs : undef) {
                $args->{include_blogs} = join ',', keys %$incl;
            } 
            if (($args->{include_blogs} || $args->{exclude_blogs}) && $args->{blog_id}) {
                delete $args->{blog_id};
            }
        }
    }
    
    my (%blog_terms, %blog_args);
    $ctx->set_blog_load_context($args, \%blog_terms, \%blog_args) 
        or return $ctx->error($ctx->errstr);

    my @tag_filter;
    my ($tags, $min, $max, $all_count) = _tags_for_blog($ctx, \%blog_terms, \%blog_args, $type);
    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');
    my $needs_entries = (($ctx->stash('uncompiled') || '') =~ /<MT:?Entries/i) ? 1 : 0;
    my $glue = $args->{glue};
    my $res = '';
    local $ctx->{__stash}{all_tag_count} = undef;
    local $ctx->{inside_mt_tags} = 1;

    if ($needs_entries) {
        foreach my $tag (@$tags) {
            my @args = (
                { status => MT::Entry::RELEASE(), %blog_terms },
                { sort      => 'authored_on',
                  direction => 'descend',
                  'join'    => MT::ObjectTag->join_on('object_id',
                      { tag_id => $tag->id, object_datasource => $type, %blog_terms },
                      { unique => 1, %blog_args },
                  ),
                  %blog_args,
                }
            );
            $tag->{__entries} = delay(sub { my @e = MT::Entry->load(@args); \@e });
        }
    }

    my $column = lc( $args->{sort_by} ) || 'name';
    my $top    = $args->{top}           || 0;
    my $limit  = $args->{limit}         || 0;
    my @slice_tags;
    if ($top > 0 && scalar @$tags > $top) {
        _tag_sort($tags, 'rank');
        @slice_tags = @$tags[ 0 .. $top - 1 ];
    } else {
        @slice_tags = @$tags;
    }
    _tag_sort(\@slice_tags, $column, $args->{sort_order} || '');
    if ($limit > 0 && scalar @slice_tags > $limit) {
        @slice_tags = @slice_tags[ 0 .. $limit - 1 ];
    }

    local $ctx->{__stash}{include_blogs} = $args->{include_blogs};
    local $ctx->{__stash}{exclude_blogs} = $args->{exclude_blogs};
    local $ctx->{__stash}{blog_ids} = $args->{blog_ids};
    local $ctx->{__stash}{tag_min_count} = $min;
    local $ctx->{__stash}{tag_max_count} = $max;
    my $vars = $ctx->{__stash}{vars} ||= {};
    my $i = 0;
    foreach my $tag (@slice_tags) {
        $i++;
        local $ctx->{__stash}{Tag} = $tag;
        local $vars->{__first__} = $i == 1;
        local $vars->{__last__} = !defined $slice_tags[$i];
        local $vars->{__odd__} = ($i % 2) == 1;
        local $vars->{__even__} = ($i % 2) == 0;
        local $vars->{__counter__} = $i;
        local $ctx->{__stash}{entries} = $tag->{__entries}
            if exists $tag->{__entries};
        local $ctx->{__stash}{tag_entry_count} = $tag->{__entry_count};
        local $ctx->{__stash}{all_tag_count} = $all_count;
        defined(my $out = $builder->build($ctx, $tokens, $cond))
            or return $ctx->error( $builder->errstr );
        $res .= $glue if defined $glue && length($res) && length($out);
        $res .= $out;
    }
    $res;
}

###########################################################################

=head2 TagSearchLink

A variable tag that outputs a link to a tag search for the entry tag in
context. This tag can be used whenever a tag context is present (e.g.
within an L<Tags>, L<EntryTags>, L<PageTags> or L<AssetTags> block.

Like all variable tags, you can apply any of the supported global modifiers
to L<TagSearchLink> to do further transformations.

The example below shows each tag in a cloud tag linked to a search for other
entries with that tag assigned.

    <h1>Tag cloud</h1>
    <div id="tagcloud">
        <mt:Tags>
            <h<$mt:TagRank$>>
                <a href="<$mt:TagSearchLink$>"><$mt:TagName$></a>
            </h<$mt:TagRank$>>
        </mt:Tags>
    </div>

The search link will look something like:

    http://example.com/mt/mt-search.cgi?blog_id=1&tag=politics

Using Apache rewriting, the search URL can be cleaned up to look
something like:

    http://example.com/tag/politics

A URL like this would have to be built like this:

    <$mt:BlogURL$>tag/<$mt:TagName normalize="1"$>

And of course, you would have to create the .htaccess rules to translate
this into a request to mt-search.cgi.

=for tags tags, multiblog

=cut

sub _hdlr_tag_search_link {
    my ($ctx, $args, $cond) = @_;
    my $tag = $ctx->stash('Tag');
    return '' unless $tag;

    my (%blog_terms, %blog_args);
    unless ($args->{blog_id} || $args->{include_blogs} || $args->{exclude_blogs}) {
        $args->{include_blogs} = $ctx->stash('include_blogs');
        $args->{exclude_blogs} = $ctx->stash('exclude_blogs');
        $args->{blog_ids} = $ctx->stash('blog_ids');
    }
    $ctx->set_blog_load_context($args, \%blog_terms, \%blog_args)
        or return $ctx->error($ctx->errstr);

    my $param = '';
    my $blogs = $blog_terms{blog_id};

    if ($blogs) {
        if (ref $blogs eq 'ARRAY') {
            if ($blog_args{not}{blog_id}) {
                $param .= 'ExcludeBlogs=' . join(',', @$blogs);
            } else {
                $param .= 'IncludeBlogs=' . join(',', @$blogs);
            }
        } else {
            $param .= 'blog_id=' . $blogs;
        }
        $param .= '&amp;';
    }
    $param .= 'tag=' . encode_url($tag->name);
    $param .= '&amp;limit=' . $ctx->{config}->MaxResults;
    my $path = _hdlr_cgi_path($ctx);
    $path . $ctx->{config}->SearchScript . '?' . $param;
}

###########################################################################

=head2 TagRank

A variable tag which returns a number from 1 to 6 (by default) which
represents the rating of the entry tag in context in terms of usage
where '1' is used for the most often used tags, '6' for the least often.
This tag can be used anytime a tag context exists (e.g. within an L<Tags>,
L<EntryTags>, L<PageTags> or L<AssetTags> block).

This is suitable for creating "tag clouds" in which L<TagRank> can
determine what level of header (h1 - h6) to apply to the tag.

B<Attributes:>

=over 4

=item * max (optional; default "6")

Allows a user to specify the upper bound of the scale.

=back

The following is a very basic tag cloud suitable for an index template or,
with some styling, a sidebar of any page.

    <h1>Tag cloud</h1>
    <div id="tagcloud">
        <mt:Tags>
            <h<$mt:TagRank$>>
                <a href="<$mt:TagSearchLink$>"><$mt:TagName$></a>
            </h<$mt:TagRank$>>
        </mt:Tags>
    </div>

=for tags multiblog

=for tags tags

=cut

sub _hdlr_tag_rank {
    my ($ctx, $args, $cond) = @_;

    my $max_level = $args->{max} || 6;
    unless ($args->{blog_id} || $args->{include_blogs} || $args->{exclude_blogs}) {
        $args->{include_blogs} = $ctx->stash('include_blogs');
        $args->{exclude_blogs} = $ctx->stash('exclude_blogs');
        $args->{blog_ids} = $ctx->stash('blog_ids');
    }
    my (%blog_terms, %blog_args);
    $ctx->set_blog_load_context($args, \%blog_terms, \%blog_args) 
        or return $ctx->error($ctx->errstr);

    my $tag = $ctx->stash('Tag');
    return '' unless $tag;

    my $class_type = $ctx->stash('class_type') || 'entry';  # FIXME: defaults to?
    my $class = MT->model($class_type);
    my $ds    = $class->datasource;
    my %term = $class_type eq 'entry' || $class_type eq 'page'
        ? ( status => MT::Entry::RELEASE() )
        : ();

    my $ntags = $ctx->stash('all_tag_count');
    unless ($ntags) {
        require MT::ObjectTag;
        $ntags = $class->count({
            %term,
            %blog_terms,
        }, {
            'join' => MT::ObjectTag->join_on('object_id',
                { object_datasource => $ds, %blog_terms },
                \%blog_args ),
            %blog_args,
        });
        $ctx->stash('all_tag_count', $ntags);
    }
    return 1 unless $ntags;

    my $min = $ctx->stash('tag_min_count');
    my $max = $ctx->stash('tag_max_count');
    unless (defined $min && defined $max) {
        (my $tags, $min, $max, my $all_count) = _tags_for_blog($ctx, \%blog_terms, \%blog_args, $class_type);
        $ctx->stash('tag_max_count', $max);
        $ctx->stash('tag_min_count', $min);
    }
    my $factor;

    if ($max - $min == 0) {
        $min -= $max_level;
        $factor = 1;
    } else {
        $factor = ($max_level - 1) / log($max - $min + 1);
    }

    if ($ntags < $max_level) {
        $factor *= ($ntags / $max_level);
    }

    my $count = $ctx->stash('tag_entry_count');
    unless (defined $count) {
        $count = $class->count({
            %term,
            %blog_terms,
        }, {
            'join' => MT::ObjectTag->join_on('object_id',
                { tag_id => $tag->id, object_datasource => $ds, %blog_terms },
                \%blog_args
            ),
            %blog_args,
        });
        $ctx->stash('tag_entry_count', $count);
    }

    if ($count - $min + 1 == 0) {
        return 0;
    }

    my $level = int(log($count - $min + 1) * $factor);
    $max_level - $level;
}

###########################################################################

=head2 EntryTags

A container tag used to output infomation about the tags assigned
to the entry in context. This tag's functionality is analogous
to that of L<PageTags>.

To avoid printing out the leading text when no entry tags are assigned you
can use the L<EntryIfTagged> conditional block to first test for entry tags
on the entry. You can also use the L<EntryIfTagged> conditional block with
the tag attribute to test for the assignment of a particular entry tag.

B<Attributes:>

=over 4

=item * glue

A text string that is used to join each of the items together. For example:

    <mt:EntryTags glue=", "><$mt:TagName$></mt:EntryTags>

would print out each tag name separated by a comma and a space.

=item * include_private

A boolean value which controls whether private tags (i.e. tags which start
with @) should be output by the block.  The default is 0 which suppresses
the output of private tags.  If set to 1, the tags will be displayed.  

One example of its use is in publishing a list of related entries to the
current entry.

    <mt:EntryIfTagged>
        <mt:EntryID setvar="curentry">

        <mt:SetVarBlock name="relatedtags">
            <mt:EntryTags include_private="1" glue=" OR ">
                <mt:TagName />
            </mt:EntryTags>
        </mt:SetVarBlock>
        <mt:Var name="relatedtags" strip_linefeeds="1" setvar="relatedtags">

        <mt:SetVarBlock name="listitems">
            <mt:Entries tags="$relatedtags" unique="1">
                <mt:Unless tag="EntryID" eq="$curentry">
                    <li>
                        <a href="<mt:EntryPermalink />">
                            <mt:EntryTitle />
                        </a>
                    </li>
                </mt:Unless>
            </mt:Entries>
       </mt:SetVarBlock>

       <mt:If name="listitems">
          <h3>Related Blog Entries</h3>
          <ul>
             <$mt:Var name="listitems"$>
          </ul>
       </mt:If>
    </mt:EntryIfTagged>

In the code sample above, the related entries list is created using the
entry tags of the entry currently in context, built as a boolean C<OR>
statement for the L<Entries> tag and stored in the C<$relatedtags> MT
template variable.  Without including private tags in that list, you
would miss entries that are similarly tagged on the back end.

=back

B<Example:>

The following code can be used anywhere L<Entries> can be used. It prints
a list of all of the tags assigned to each entry returned by L<Entries>
glued together by a comma and a space.

    <mt:If tag="EntryTags">
        The entry "<$mt:EntryTitle$>" is tagged:
        <mt:EntryTags glue=", "><$mt:TagName$></mt:EntryTags>
    </mt:If>

=for tags tags, entries

=cut

sub _hdlr_entry_tags {
    my ($ctx, $args, $cond) = @_;
    
    require MT::Entry;
    my $entry = $ctx->stash('entry');
    return '' unless $entry;
    my $glue = $args->{glue};

    local $ctx->{__stash}{tag_max_count} = undef;
    local $ctx->{__stash}{tag_min_count} = undef;
    local $ctx->{__stash}{all_tag_count} = undef;

    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');
    my $res = '';
    my $tags = $entry->get_tag_objects;
    for my $tag (@$tags) {
        next if $tag->is_private && !$args->{include_private};
        local $ctx->{__stash}{Tag} = $tag;
        local $ctx->{__stash}{tag_count} = undef;
        local $ctx->{__stash}{tag_entry_count} = undef;
        defined(my $out = $builder->build($ctx, $tokens, $cond))
            or return $ctx->error( $builder->errstr );
        $res .= $glue if defined $glue && length($res) && length($out);
        $res .= $out;
    }
    $res;
}

###########################################################################

=head2 TagLabel

An alias for the 'TagName' tag.

=cut

###########################################################################

=head2 TagName

Outputs the name of the current tag in context.

B<Attributes:>

=over 4

=item * normalize (optional; default "0")

If specified, outputs the "normalized" form of the tag. A normalized
tag has been stripped of any spaces and punctuation and is only
lowercase.

=over 4

=item * quote (optional; default "0")

If specified, causes any tag with spaces in it to be wrapped in quote
marks.

=back

=for tags tags

=cut

sub _hdlr_tag_name {
    my ($ctx, $args, $cond) = @_;
    my $tag = $ctx->stash('Tag');
    return '' unless $tag;
    my $name = $tag->name || '';
    if ($args->{quote} && $name =~ m/ /) {
       $name = '"' . $name . '"';
    } elsif ($args->{normalize}) {
        $name = MT::Tag->normalize($name);
    }
    $name;
}

###########################################################################

=head2 TagID

Outputs the numeric ID of the tag currently in context.

=for tags tags

=cut

sub _hdlr_tag_id {
    my ($ctx, $args, $cond) = @_;
    my $tag = $ctx->stash('Tag');
    return '' unless $tag;
    $tag->id;
}

###########################################################################

=head2 TagCount

Returns the number of entries that have been tagged with the current tag
in context.

=for tags tags, count

=cut

sub _hdlr_tag_count {
    my ($ctx, $args, $cond) = @_;
    my $count = $ctx->stash('tag_entry_count');
    my $tag = $ctx->stash('Tag');
    my $blog_id = $ctx->stash('blog_id');
    my $class_type = $ctx->stash('class_type') || 'entry';  # FIXME: defaults to?
    my $class = MT->model($class_type);
    my %term = $class_type eq 'entry' || $class_type eq 'page'
        ? ( status => MT::Entry::RELEASE() )
        : ();
    if ($tag && $class) {
        unless (defined $count) {
            $count = $class->tagged_count($tag->id, {
                %term,
                blog_id => $blog_id
            });
        }
    }
    $count ||= 0;
    return $ctx->count_format($count, $args);
}

###########################################################################

=head2 IfTypeKeyToken

A conditional tag that is true when the current blog in context has been
configured with a TypeKey token.

=for tags comments, typekey

=cut

sub _hdlr_if_typekey_token {
    my ($ctx) = @_;
    my $blog = $ctx->stash('blog');
    return $blog->remote_auth_token ? 1 : 0;
}

###########################################################################

=head2 IfCommentsModerated

A conditional tag that is true when the blog is configured to moderate
incoming comments from anonymous commenters.

=for tags comments

=cut

sub _hdlr_comments_moderated {
    my ($ctx) = @_;
    my $blog = $ctx->stash('blog');
    if ($blog->moderate_unreg_comments || $blog->manual_approve_commenters) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 IfRegistrationAllowed

A conditional tag that is true when the blog has been configured to
permit user registration.

B<Attributes:>

=over 4

=item * type (optional)

If specified, can be used to test if a particular type of registration
is enabled. The core types include "OpenID", "Vox", "LiveJournal", "TypeKey"
and "MovableType". The identifier is case-insensitive.

=back

=for tags comments

=cut

sub _hdlr_reg_allowed {
    my ($ctx, $args) = @_;
    my $blog = $ctx->stash('blog');
    if ($blog->allow_reg_comments && $blog->commenter_authenticators) {
        if (my $type = $args->{type}) {
            my %types = map { lc($_) => 1 }
                split /,/, $blog->commenter_authenticators;
            return $types{lc $type} ? 1 : 0;
        }
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 IfRegistrationRequired

A conditional tag that is true when the blog has been configured to
require user registration.

=for tags comments

=cut

sub _hdlr_reg_required {
    my ($ctx) = @_;
    my $blog = $ctx->stash('blog');
    if ( $blog->allow_reg_comments && $blog->commenter_authenticators
        && ! $blog->allow_unreg_comments ) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 IfRegistrationNotRequired

A conditional tag that is true when the blog has been configured to
permit anonymous comments.

=for tags comments

=cut

sub _hdlr_reg_not_required {
    my ($ctx) = @_;
    my $blog = $ctx->stash('blog');
    if ($blog->allow_reg_comments && $blog->commenter_authenticators
        && $blog->allow_unreg_comments) {
        return 1;
    } else {
        return 0;
    }
}
#FIXME: rethink the above tags.
#  * move all registration conditions into Context.pm?
#  * reg_not_required implies registration is allowed?
#  * moderation includes manual_approve_commenters ??
#  * alias authentication to registration?

###########################################################################

=head2 BlogIfCommentsOpen

A conditional tag that returns true when: the system is configured to
allow comments and the blog is configured to accept comments in some
fashion.

=for tags comments

=cut

sub _hdlr_blog_if_comments_open {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    if ($ctx->{config}->AllowComments &&
        (($blog->allow_reg_comments && $blog->effective_remote_auth_token)
         || $blog->allow_unreg_comments)) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 IfArchiveType

This tag allows you to conditionalize a section of template code based on
whether the primary template being published is a specific type of archive
template.

B<Attributes:>

=over 4

=item * type

=item * archive_type

The archive type to test for, case-insensitively. See L<ArchiveType> for
acceptable values but note that plugins may also provide others.

=back

If you wanted to include autodiscovery code for a customized Atom feed for
each individual entry (perhaps for tracking comments) you could put this in
your Header module. This would serve up the first link for Individual
archives and the normal feed for all other templates:

    <mt:IfArchiveType type="individual">
        <link rel="alternate" type="application/atom+xml"
            title="Comments Feed"
            href="<$MTFileTemplate format="%y/%m/%-F.xml"$>" />
    <mt:Else>
        <link rel="alternate" type="application/atom+xml"
            title="Recent Entries"
            href="<$MTLink template="feed_recent"$>" />
    </mt:IfArchiveType>

=for tags archives

=cut

sub _hdlr_if_archive_type {
    my ($ctx, $args, $cond) = @_;
    my $cat = $ctx->{current_archive_type} || $ctx->{archive_type} || '';
    my $at = $args->{type} || $args->{archive_type} || '';
    return 0 unless $at && $cat;
    return lc $at eq lc $cat;
}

###########################################################################

=head2 IfArchiveTypeEnabled

A conditional tag used to test whether a specific archive type is
published or not.

B<Attributes:>

=over 4

=item * type or archive_type

Specifies the name of the archive type you wish to check to see if it is enabled.

A list of possible values values for type can be found on the L<ArchiveType>
tag.

=back

B<Example:>

    <mt:IfArchiveTypeEnabled type="Category-Monthly">
        <!-- do something -->
    <mt:Else>
        <!-- do something else -->
    </mt:IfArchiveTypeEnabled>

=for tags archives

=cut

sub _hdlr_archive_type_enabled {
    my ($ctx, $args) = @_;
    my $blog = $ctx->stash('blog');
    my $at = ($args->{type} || $args->{archive_type});
    return $blog->has_archive_type($at);
}

sub sanitize_on {
    my ($ctx) = @_;
    unless ( exists $ctx->{'sanitize'} ) {
        # Important to come before other manipulation attributes
        # like encode_xml
        unshift @{$ctx->{'@'} ||= []}, ['sanitize' => 1];
        $ctx->{'sanitize'} = 1;
    }
}

sub nofollowfy_on {
    my ($ctx) = @_;
    unless ( exists $ctx->{'nofollowfy'} ) {
        $ctx->{'nofollowfy'} = 1;
    }
}

{
    my %include_stack;
    my %restricted_include_filenames = (
        'mt-config.cgi' => 1,
        'passwd' => 1
    );

    ###########################################################################

=head2 IncludeBlock

This tag provides MT with the ability to 'wrap' content with an included
module. This behaves much like the MTInclude tag, but it is a container tag.
The contents of the tag are taken and assigned to a variable (either one
explicitly named with a 'var' attribute, or will default to 'contents').
i.e.:

    <mt:IncludeBlock module="Some Module">
        (do something here)
    </mt:IncludeBlock>

In the "Some Module" template module, you would then have the following
template tag allowing you to reference the contents of the L<IncludeBlock>
tag used to include this "Some Module" template module, like so:

    (header stuff)
    <$mt:Var name="contents"$>
    (footer stuff)

B<Important:> Modules used as IncludeBlocks should never be processed as a Server Side Include or be cached.

+B<Attributes:>

=over 4

=item * var (optional)

Supplies a variable name to use for assigning the contents of the
L<IncludeBlock> tag. If unassigned, the "contents" variable is used.

=back

=for tags templating

=cut

sub _hdlr_include_block {
    my($ctx, $args, $cond) = @_;
    my $name = delete $args->{var} || 'contents';
    # defer the evaluation of the child tokens until used inside
    # the block (so any variables/context changes made in that template
    # affect the contained template code)
    my $tokens = $ctx->stash('tokens');
    local $ctx->{__stash}{vars}{$name} = sub {
        my $builder = $ctx->stash('builder');
        my $html = $builder->build($ctx, $tokens, $cond);
        return $ctx->error($builder->errstr) unless defined $html;
        return $html;
    };
    return $ctx->tag('include', $args, $cond);
}

###########################################################################

=head2 Include

Includes a template module or external file and outputs the result.

B<NOTE:> One and only one of the 'module', 'widget', 'file' and
'identifier' attributes can be specified.

B<Attributes:>

=over 4

=item * module

The name of a template module in the current blog.

=item * widget

The name of the widget in the current blog to include.

=item * file

The path to an external file on the system. The path can be absolute or
relative to the Local Site Path. This file is included at the time your
page is built. It should not be confused with dynamic server side
includes like that found in PHP.

=item * identifier

For selecting Index templates by their unique identifier.

=name

For application template use: identifies an application template by
filename to load.

=item * blog_id (optional)

Used to include a template from another blog in the system. Use in
conjunction with the module, widget or identifier attributes.

=item * local (optional)

Forces an Include of a template that exists in the blog that is being
published.

=item * global (optional; default "0")

Forces an Include of a globally defined template even if the
template is also available in the blog currently in context.
(For module, widget and identifier includes.)

=item * ssi (optional; default "0")

If specified, causes the include to be handled as a server-side
include. The value of the 'ssi' attribute determines the type of
include that is produced. Acceptable values are: C<php>, C<asp>,
C<jsp>, C<shtml>. This causes the contents of the include to be
processed and written to a file (stored to the blog's publishing
path, under the 'includes_c' subdirectory). The include tag itself
then returns the include directive appropriate to the 'ssi' type
specified. So, for example:

    <$mt:Include module="Tag Cloud" ssi="php"$>

This would generate the contents for the "Tag Cloud" template module
and write it to a "tag_cloud.php" file. The output of the include
tag would look like this:

    <?php include("/path/to/blog/includes_c/tag_cloud.php") ?>

Suitable for module, widget or identifier includes.

=item * cache (optional; default "0")

Enables caching of the contents of the include. Suitable for module,
widget or identifier includes.

=item * key or cache_key (optional)

Used to cache the template module. Used in conjunction with the 'cache'
attribute. Suitable for module, widget or identifier includes.

=item * ttl (optional)

Specifies the lifetime in seconds of a cached template module. Suitable
for module, widget or identifier includes.

=back

Also, other attributes given to this tag are locally assigned as
variables when invoking the include template.

The contents of the file or module are further evaluated for more Movable
Type template tags.

B<Example:> Including a Widget

    <$mt:Include widget="Search Box"$>

B<Example:> Including a File

    <$mt:Include file="/var/www/html/some-fragment.html"$>

B<Example:> Including a Template Module

    <$mt:Include module="Sidebar - Left Column"$>

B<Example:> Passing Parameters to a Template Module

    <$mt:Include module="Section Header" title="Elsewhere"$>

(from the "Section Header" template module)

    <h2><$mt:Var name="title"$></h2>

=for tags templating

=cut

sub _hdlr_include {
    my ($ctx, $arg, $cond) = @_;

    # Pass through include arguments as variables to included template
    my $vars = $ctx->{__stash}{vars} ||= {};
    my @names = keys %$arg;
    my @var_names;
    push @var_names, lc $_ for @names;
    local @{$vars}{@var_names};
    $vars->{lc($_)} = $arg->{$_} for @names;

    # Run include process
    my $out = $arg->{module}     ? _include_module(@_)
            : $arg->{widget}     ? _include_module(@_)
            : $arg->{identifier} ? _include_module(@_)
            : $arg->{file}       ? _include_file(@_)
            : $arg->{name}       ? _include_name(@_)
            :                      $ctx->error(MT->translate(
                                       'No template to include specified'))
            ;

    return $out;
}

sub _include_module {
    my ($ctx, $arg, $cond) = @_;
    my $tmpl_name = $arg->{module} || $arg->{widget} || $arg->{identifier}
        or return;
    my $name = $arg->{widget} ? 'widget' : $arg->{identifier} ? 'identifier' : 'module';
    my $type = $arg->{widget} ? 'widget' : 'custom';
    if (($type eq 'custom') && ($tmpl_name =~ m/^Widget:/)) {
        # handle old-style widget include references
        $type = 'widget';
        $tmpl_name =~ s/^Widget: ?//;
    }
    my $blog_id = $arg->{blog_id} || $ctx->{__stash}{blog_id} || 0;
    $blog_id = $ctx->stash('local_blog_id') if $arg->{local};
    my $stash_id = 'template_' . $type . '::' . $blog_id . '::' . $tmpl_name;
    return $ctx->error(MT->translate("Recursion attempt on [_1]: [_2]", MT->translate($name), $tmpl_name))
        if $include_stack{$stash_id};
    local $include_stack{$stash_id} = 1;

    my $req = MT::Request->instance;
    my ($tmpl, $tokens);
    if (my $tmpl_data = $req->stash($stash_id)) {
        ($tmpl, $tokens) = @$tmpl_data;
    }
    else {
        my %terms = $arg->{identifier} ? ( identifier => $tmpl_name )
                  :                      ( name => $tmpl_name,
                                           type => $type )
                  ;
        $terms{blog_id} = !exists $arg->{global} ? [ $blog_id, 0 ]
                        : $arg->{global}         ? 0
                        :                          $blog_id
                        ;
        ($tmpl) = MT->model('template')->load(\%terms, {
            sort      => 'blog_id',
            direction => 'descend',
        }) or return $ctx->error(MT->translate(
            "Can't find included template [_1] '[_2]'", MT->translate($name), $tmpl_name ));

        my $cur_tmpl = $ctx->stash('template');
        return $ctx->error(MT->translate("Recursion attempt on [_1]: [_2]", MT->translate($name), $tmpl_name))
            if $cur_tmpl && $cur_tmpl->id && ($cur_tmpl->id == $tmpl->id);

        $req->stash($stash_id, [ $tmpl, undef ]);
    }

    my $blog = $ctx->stash('blog') || MT->model('blog')->load($blog_id);

    my %include_recipe;
    my $use_ssi = $blog && $blog->include_system
        && ($arg->{ssi} || $tmpl->include_with_ssi) ? 1 : 0;
    if ($use_ssi) {
        # disable SSI for templates that are system templates;
        # easiest way to determine this is from the variable
        # space setting.
        if ($ctx->var('system_template')) {
            $use_ssi = 0;
        } else {
            my $extra_path = ($arg->{cache_key} || $arg->{key}) ? $arg->{cache_key} || $arg->{key}
                : $tmpl->cache_path ? $tmpl->cache_path
                    : '';
           %include_recipe = (
                name => $tmpl_name,
                id   => $tmpl->id,
                path => $extra_path,
            );
        }
    }

    # Try to read from cache
    my $cache_expire_type = $tmpl->cache_expire_type || 0;
    my $cache_enabled =
         $blog
      && $blog->include_cache
      && ( ( $arg->{cache} && $arg->{cache} > 0 )
        || $arg->{cache_key}
        || $arg->{key}
        || ( exists $arg->{ttl} )
        || ( $cache_expire_type != 0 ) ) ? 1 : 0;
    my $cache_key =
        ($arg->{cache_key} || $arg->{key})
      ? $arg->{cache_key} || $arg->{key}
      : 'blog::' . $blog_id . '::template_' . $type . '::' . $tmpl_name;
    my $ttl =
      exists $arg->{ttl} ? $arg->{ttl}
          : ( $cache_expire_type == 1 ) ? $tmpl->cache_expire_interval
              : ( $cache_expire_type == 2 ) ? 0
                  :   60 * 60;    # default 60 min.

    if ( $cache_expire_type == 2 ) {
        my @types = split /,/, ($tmpl->cache_expire_event || '');
        if (@types) {
            require MT::Touch;
            if (my $latest = MT::Touch->latest_touch($blog_id, @types)) {
                if ($use_ssi) {
                    # base cache expiration on physical file timestamp
                    my $include_file = $blog->include_path(\%include_recipe);
                    my $mtime = (stat($include_file))[9];
                    if ($mtime && (MT::Util::ts2epoch(undef, $latest) > $mtime ) ) {
                        $ttl = 1; # bound to force an update
                    }
                } else {
                    $ttl = time - MT::Util::ts2epoch(undef, $latest);
                }
            }
        }
    }

    my $cache_driver;
    if ($cache_enabled) {
        my $tmpl_mod = $tmpl->modified_on;
        my $tmpl_ts = MT::Util::ts2epoch($blog, $tmpl_mod);
        if (($ttl == 0) || (time - $tmpl_ts < $ttl)) {
            $ttl = time - $tmpl_ts;
        }
        require MT::Cache::Negotiate;
        $cache_driver = MT::Cache::Negotiate->new( ttl => $ttl );
        my $cache_value = $cache_driver->get($cache_key);

        if ($cache_value) {
            return $cache_value if !$use_ssi;

            # The template may still be cached from before we were using SSI
            # for this template, so check that it's also on disk.
            my $include_file = $blog->include_path(\%include_recipe);
            if ($blog->file_mgr->exists($include_file)) {
                return $blog->include_statement(\%include_recipe);
            }
        }
    }

    my $builder = $ctx->{__stash}{builder};
    if (!$tokens) {
        # Compile the included template against the includ*ing* template's
        # context.
        $tokens = $builder->compile($ctx, $tmpl->text);
        unless (defined $tokens) {
            $req->cache('build_template', $tmpl);
            return $ctx->error($builder->errstr);
        }
        $tmpl->tokens( $tokens );

        $req->stash($stash_id, [ $tmpl, $tokens ]);
    }

    # Build the included template against the includ*ing* template's context.
    my $ret = $tmpl->build( $ctx, $cond );
    if (!defined $ret) {
        $req->cache('build_template', $tmpl) if $tmpl;
        return $ctx->error("error in $name $tmpl_name: " . $tmpl->errstr);
    }

    if ($cache_enabled) {
        $cache_driver->replace($cache_key, $ret, $ttl);
    }

    if ($use_ssi) {
        my ($include_file, $path, $filename) =
            $blog->include_path(\%include_recipe);
        my $fmgr = $blog->file_mgr;
        if (!$fmgr->exists($path)) {
            if (!$fmgr->mkpath($path)) {
                return $ctx->error(MT->translate("Error making path '[_1]': [_2]",
                    $path, $fmgr->errstr));
            }
        }
        defined($fmgr->put_data($ret, $include_file))
            or return $ctx->error(MT->translate("Writing to '[_1]' failed: [_2]",
                $include_file, $fmgr->errstr));

        MT->upload_file_to_sync(
            url  => $blog->include_url(\%include_recipe),
            file => $include_file,
            blog => $blog,
        );

        my $stat = $blog->include_statement(\%include_recipe);
        return $stat;
    }

    return $ret;
}

sub _include_file {
    my ($ctx, $arg, $cond) = @_;
    my $file = $arg->{file} or return;
    require File::Basename;
    my $base_filename = File::Basename::basename($file);
    if (exists $restricted_include_filenames{lc $base_filename}) {
        return $ctx->error("You cannot include a file with this name: $base_filename");
    }

    my $blog_id = $arg->{blog_id} || $ctx->{__stash}{blog_id} || 0;
    my $stash_id = 'template_file::' . $blog_id . '::' . $file;
    return $ctx->error("Recursion attempt on file: [_1]", $file)
        if $include_stack{$stash_id};
    local $include_stack{$stash_id} = 1;
    my $req = MT::Request->instance;
    my $cref = $req->stash($stash_id);
    my $tokens;
    my $builder = $ctx->{__stash}{builder};
    if ($cref) {
        $tokens = $cref;
    } else {
        my $blog = $ctx->stash('blog');
        if ($blog->id != $blog_id) {
            $blog = MT::Blog->load($blog_id)
                or return $ctx->error(MT->translate(
                    "Can't find blog for id '[_1]", $blog_id));
        }
        my @paths = ($file, map File::Spec->catfile($_, $file),
                            $blog->site_path, $blog->archive_path);
        my $path;
        for my $p (@paths) {
            $path = $p, last if -e $p && -r _;
        }
        return $ctx->error(MT->translate(
            "Can't find included file '[_1]'", $file )) unless $path;
        local *FH;
        open FH, $path
            or return $ctx->error(MT->translate(
                "Error opening included file '[_1]': [_2]", $path, $! ));
        my $c;
        local $/; $c = <FH>;
        close FH;
        $tokens = $builder->compile($ctx, $c);
        return $ctx->error($builder->errstr) unless defined $tokens;
        $req->stash($stash_id, $tokens);
    }
    my $ret = $builder->build($ctx, $tokens, $cond);
    return defined($ret) ? $ret : $ctx->error("error in file $file: " . $builder->errstr);
}

sub _include_name {
    my ($ctx, $arg, $cond) = @_;
    my $app_file = $arg->{name};

    # app template include mode
    my $mt = MT->instance;
    local $mt->{component} = $arg->{component} if exists $arg->{component};
    my $stash_id = 'template_file::' . $app_file;
    return $ctx->error(MT->translate("Recursion attempt on file: [_1]", $app_file))
        if $include_stack{$stash_id};
    local $include_stack{$stash_id} = 1;
    my $tmpl = $mt->load_tmpl($app_file);
    if ($tmpl) {
        $tmpl->name($app_file);

        my $tmpl_file = $app_file;
        if ($tmpl_file) {
            $tmpl_file = File::Basename::basename($tmpl_file);
            $tmpl_file =~ s/\.tmpl$//;
            $tmpl_file = '.' . $tmpl_file;
        }
        $mt->run_callbacks('template_param' . $tmpl_file, $mt, $tmpl->param, $tmpl);

        # propagate our context
        local $tmpl->{context} = $ctx;
        my $out = $tmpl->output();
        return $ctx->error($tmpl->errstr) unless defined $out;

        $mt->run_callbacks('template_output' . $tmpl_file, $mt, \$out, $tmpl->param, $tmpl);
        return $out;
    } else {
        return defined $arg->{default} ? $arg->{default} : '';
    }
}
}

###########################################################################

=head2 FileTemplate

Produces a file name and path using the archive file naming specifiers.

B<Attributes:>

=over 4

=item * format

A required attribute that defines the template with a string of specifiers.
The supported specifiers are (B<NOTE:> do not confuse the following
table with the specifiers used for MT date tags. There is no relationship
between these -- any similarities are coincidental. These specifiers are
tuned for publishing filenames and paths for various contexts.)

=over 4

=item * %a

The entry's author's display name passed through the dirify global filter. Example: melody_nelson

=item * %-a

The same as above except using dashes. Example: melody-nelson

=item * %b

For individual archive mappings, this returns the basename of the entry. By
default, this is the first thirty characters of an entry dirified with
underscores. It can be specified by using the basename field on the edit
entry screen. Example: my_summer_vacation

=item * %-b

Same as above but using dashes. Example: my-summer-vacation

=item * %c

The entry's primary category/subcategory path, built using the category
basename field. Example: arts_and_entertainment/tv_and_movies

=item * %-c

Same as above but using dashes. Example: arts-and-entertainment/tv-and-movies

=item * %C

The entry's primary category label passed through the dirify global filter. Example: arts_and_entertainment

=item * %-C

Same as above but using dashes. Example: arts-and-entertainment

=item * %d

2-digit day of the month. Example: 09

=item * %D

3-letter language-dependent abbreviation of the week day. Example: Tue

=item * %e

A numeric entry ID padded with leading zeroes to six digits. Example: 000040

=item * %E

The entry's numeric ID. Example: 40

=item * %f

Archive filename with the specified extension. This can be used instead of
%b or %i and will do the right thing based on the context.
Example: entry_basename.html or index.html

=item * %F

Same as above but without the file extension. Example: filename

=item * %h

2-digit hour on a 24-hour clock with a leading zero if applicable.
Example: 09 for 9am, 16 for 4pm

=item * %H

2-digit hour on a 24-hour clock without a leading zero if applicable.
Example: 9 for 9am, 16 for 4pm

=item * %i

The setting of the IndexBasename configuration directive with the default
file extension appended. Example: index.html

=item * %I

Same as above but without the file extension. Example: index

=item * %j

3-digit day of year, zero-padded. Example: 040

=item * %m

2-digit month, zero-padded. Example: 07

=item * %M

3-letter language-dependent abbreviation of the month. Example: Sep

=item * %n

2-digit minute, zero-padded. Example: 04

=item * %s

2-digit second, zero-padded. Example: 01

=item * %x

File extension with a leading dot (.). If a file extension has not
been specified a blank string is returned. Example: .html

=item * %y

4-digit year. Example: 2005

=item * %Y

2-digit year with zero-padding. Example: 05

=back

=back

B<Example:>

    <$mt:FileTemplate format="%y/%m/%f"$>

=for tags archives

=cut

sub _hdlr_file_template {
    my ($ctx, $args, $cond) = @_;

    my $at = $ctx->{current_archive_type} || $ctx->{archive_type};
    $at = 'Category' if $ctx->{inside_mt_categories};
    my $format = $args->{format};
    unless ($format) {
        my $archiver = MT->publisher->archiver($at);
        $format = $archiver->default_archive_templates if $archiver;
    }
    return $ctx->error(MT->translate("Unspecified archive template")) unless $format;

    my ($dir, $sep);
    if ($args->{separator}) {
        $dir = "dirify='$args->{separator}'";
        $sep = "separator='$args->{separator}'";
    } else {
        $dir = "dirify='1'";
        $sep = "";
    }
    my %f = (
        'a' => "<MTAuthorBasename $dir>",
        '-a' => "<MTAuthorBasename separator='-'>",
        '_a' => "<MTAuthorBasename separator='_'>",
        'b' => "<MTEntryBasename $sep>",
        '-b' => "<MTEntryBasename separator='-'>",
        '_b' => "<MTEntryBasename separator='_'>",
        'c' => "<MTSubCategoryPath $sep>",
        '-c' => "<MTSubCategoryPath separator='-'>",
        '_c' => "<MTSubCategoryPath separator='_'>",
        'C' => "<MTCategoryBasename $dir>",
        '-C' => "<MTCategoryBasename dirify='-'>",
        'd' => "<MTArchiveDate format='%d'>",
        'D' => "<MTArchiveDate format='%e' trim='1'>",
        'e' => "<MTEntryID pad='1'>",
        'E' => "<MTEntryID pad='0'>",
        'f' => "<MTArchiveFile $sep>",
        '-f' => "<MTArchiveFile separator='-'>",
        'F' => "<MTArchiveFile extension='0' $sep>",
        '-F' => "<MTArchiveFile extension='0' separator='-'>",
        'h' => "<MTArchiveDate format='%H'>",
        'H' => "<MTArchiveDate format='%k' trim='1'>",
        'i' => '<MTIndexBasename extension="1">',
        'I' => "<MTIndexBasename>",
        'j' => "<MTArchiveDate format='%j'>",  # 3-digit day of year
        'm' => "<MTArchiveDate format='%m'>",  # 2-digit month
        'M' => "<MTArchiveDate format='%b'>",  # 3-letter month
        'n' => "<MTArchiveDate format='%M'>",  # 2-digit minute
        's' => "<MTArchiveDate format='%S'>",  # 2-digit second
        'x' => "<MTBlogFileExtension>",
        'y' => "<MTArchiveDate format='%Y'>",  # year
        'Y' => "<MTArchiveDate format='%y'>",  # 2-digit year
    );
    $format =~ s!%([_-]?[A-Za-z])!$f{$1}!g if defined $format;
    # now build this template and return result
    my $builder = $ctx->stash('builder');
    my $tok = $builder->compile($ctx, $format);
    return $ctx->error(MT->translate("Error in file template: [_1]", $args->{format}))
        unless defined $tok;
    defined(my $file = $builder->build($ctx, $tok, $cond))
        or return $ctx->error($builder->errstr);
    $file =~ s!/{2,}!/!g;
    $file =~ s!(^/|/$)!!g;
    $file;
}

###########################################################################

=head2 TemplateCreatedOn

Returns the creation date for the template publishing the current file.

B<Example:>

    <$mt:TemplateCreatedOn$>

=for tags date

=for tags templates

=cut

sub _hdlr_template_created_on {
    my($ctx, $args, $cond) = @_;
    my $template = $ctx->stash('template')
        or return $ctx->error(MT->translate("Can't load template"));
    $args->{ts} = $template->created_on;
    _hdlr_date($ctx, $args);
}

###########################################################################

=head2 Link

Generates the absolute URL to an index template or specific entry in the system.

B<NOTE:> Only one of the 'template', 'identifier' and 'entry_id'
attributes can be specified at a time.

B<Attributes:>

=item * template

The name of the index template.

=item * identifier

A template identifier.

=item * entry_id

The numeric system ID of the entry.

=item * with_index (optional; default "0")

If not set to 1, remove index filenames (by default, index.html)
from resulting links.

=back

B<Examples:>

    <a href="<mt:Link template="About Page">">My About Page</a>

    <a href="<mt:Link entry_id="221">">the entry about my vacation</a>

    <a href="<mt:Link identifier="main_index">">Home</a>

=for tags archives
=cut

sub _hdlr_link {
    my($ctx, $arg, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $blog_id = $blog->id;
    if (my $tmpl_name = $arg->{template}) {
        require MT::Template;
        my $tmpl = MT::Template->load({ identifier => $tmpl_name,
                type => 'index', blog_id => $blog_id })
            || MT::Template->load({ name => $tmpl_name,
                                        type => 'index',
                                        blog_id => $blog_id })
                || MT::Template->load({ outfile => $tmpl_name,
                                        type => 'index',
                                        blog_id => $blog_id })
            or return $ctx->error(MT->translate(
                "Can't find template '[_1]'", $tmpl_name ));
        my $site_url = $blog->site_url;
        $site_url .= '/' unless $site_url =~ m!/$!;
        my $link = $site_url . $tmpl->outfile;
        $link = MT::Util::strip_index($link, $blog) unless $arg->{with_index};
        $link;
    } elsif (my $entry_id = $arg->{entry_id}) {
        my $entry = MT::Entry->load($entry_id)
            or return $ctx->error(MT->translate(
                "Can't find entry '[_1]'", $entry_id ));
        my $link = $entry->permalink;
        $link = MT::Util::strip_index($link, $blog) unless $arg->{with_index};
        $link;
    }
}

###########################################################################

=head2 Version

The version number of the Movable Type system.

B<Example:>

    <mt:Version />

=for tags configuration

=cut

sub _hdlr_mt_version {
    require MT;
    MT->version_id;
}

###########################################################################

=head2 ProductName

The Movable Type edition in use.

B<Attributes:>

=over 4

=item * version (optional; default "0")

If specified, also outputs the version (same as L<Version>).

=back

B<Example:>

    <$mt:ProductName$>

for the MTOS edition, this would output:

    Movable Type Open Source

=for tags configuration

=cut

sub _hdlr_product_name {
    my ($ctx, $args, $cond) = @_;
    require MT;
    my $short_name = MT->translate(MT->product_name);
    if ($args->{version}) {
        return MT->translate("[_1] [_2]", $short_name, MT->version_id);
    } else {
        return $short_name;
    }
}

###########################################################################

=head2 PublishCharset

The value of the C<PublishCharset> directive in the system configuration.

B<Example:>

    <$mt:PublishCharset$>

=for tags configuration

=cut

sub _hdlr_publish_charset {
    my ($ctx) = @_;
    return $ctx->{config}->PublishCharset || 'utf-8';
}

###########################################################################

=head2 DefaultLanguage

The value of the C<DefaultLanguage> configuration setting.

B<Example:>

    <$mt:DefaultLanguage$>

This outputs a language code, ie: "en_US", "ja", "de", "es", "fr", "nl" or
other installed language.

=for tags configuration

=cut

sub _hdlr_default_language {
    my ($ctx) = @_;
    return $ctx->{config}->DefaultLanguage || 'en_US';
}

###########################################################################

=head2 SignOnURL

The value of the C<SignOnURL> configuration setting.

=for tags comments

=cut

sub _hdlr_signon_url {
    my ($ctx) = @_;
    return $ctx->{config}->SignOnURL;
}

###########################################################################

=head2 IfNonEmpty

A conditional tag used to test whether a template variable or tag are
non-empty. This tag is considered deprecated, in favor of the L<If> tag.

B<Attributes:>

=over 4

=item * tag

A tag which is evaluated and tested for non-emptiness.

=item * name or var

A variable whose contents are tested for non-emptiness.

=back

=for tags deprecated

=cut

sub _hdlr_if_nonempty {
    my ($ctx, $args, $cond) = @_;
    my $value;
    if (exists $args->{tag}) {
        $args->{tag} =~ s/^MT:?//i;
        my ($handler) = $ctx->handler_for($args->{tag});
        if (defined($handler)) {
            local $ctx->{__stash}{tag} = $args->{tag};
            $value = $handler->($ctx, { %$args });
            if (my $ph = $ctx->post_process_handler) {
                $value = $ph->($ctx, $args, $value);
            }
        }
    } elsif (exists $args->{name}) {
        $value = $ctx->var($args->{name});
    } elsif (exists $args->{var}) {
        $value = $ctx->var($args->{var});
    }
    if (defined($value) && $value ne '') { # want to include "0" here
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 IfNonZero

A conditional tag used to test whether a template variable or tag are
non-zero. This tag is considered deprecated, in favor of the L<If> tag.

B<Attributes:>

=over 4

=item * tag

A tag which is evaluated and tested for non-zeroness.

=item * name or var

A variable whose contents are tested for non-zeroness.

=back

=for tags deprecated

=cut

sub _hdlr_if_nonzero {
    my ($ctx, $args, $cond) = @_;
    my $value;
    if (exists $args->{tag}) {
        $args->{tag} =~ s/^MT:?//i;
        my ($handler) = $ctx->handler_for($args->{tag});
        if (defined($handler)) {
            local $ctx->{__stash}{tag} = $args->{tag};
            $value = $handler->($ctx, { %$args });
            if (my $ph = $ctx->post_process_handler) {
                $value = $ph->($ctx, $args, $value);
            }
        }
    } elsif (exists $args->{name}) {
        $value = $ctx->var($args->{name});
    } elsif (exists $args->{var}) {
        $value = $ctx->var($args->{var});
    }
    if (defined($value) && $value) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 ErrorMessage

This tag is used by the system to display the text of any user error
message. Used in system templates, such as the 'Comment Response' template.

=for tags templating

=cut

sub _hdlr_error_message {
    my ($ctx) = @_;
    my $err = $ctx->stash('error_message');
    defined $err ? $err : '';
}

###########################################################################

=head2 SetVars

A block tag that is useful for assigning multiple template variables at
once.

B<Example:>

    <mt:SetVars>
    title=My Favorite Color
    color=Blue
    </mt:SetVars>

Then later:

    <h1><$mt:Var name="title"$></h1>

    <ul><li><$mt:Var name="color"$></li></ul>

=for tags templating

=cut

sub _hdlr_set_vars {
    my($ctx, $args) = @_;
    my $tag = lc $ctx->stash('tag');
    my $val =_hdlr_pass_tokens(@_);
    $val =~ s/(^\s+|\s+$)//g;
    my @pairs = split /\r?\n/, $val;
    foreach my $line (@pairs) {
        next if $line =~ m/^\s*$/;
        my ($var, $value) = split /\s*=/, $line, 2;
        unless (defined($var) && defined($value)) {
            return $ctx->error("Invalid variable assignment: $line");
        }
        $var =~ s/^\s+//;
        $ctx->var($var, $value);
    }
    return '';
}

###########################################################################

=head2 SetHashVar

A block tag that is used for creating a hash template variable. A hash
is a variable that stores many values. You can even nest L<SetHashVar>
tags so you can store hashes inside hashes for more complex structures.

B<Example:>

    <mt:SetHashVar name="my_hash">
        <$mt:Var name="foo" value="bar"$>
        <$mt:Var name="fizzle" value="fozzle"$>
    </mt:SetHashVar>

Then later:

    foo is assigned: <$mt:Var name="my_hash{foo}"$>

=for tags templating

=cut

sub _hdlr_set_hashvar {
    my($ctx, $args) = @_;
    my $tag = lc $ctx->stash('tag');
    my $name = $args->{name} || $args->{var};
    if ($name =~ m/^\$/) {
        $name = $ctx->var($name);
    }
    return $ctx->error(MT->translate(
        "You used a [_1] tag without a valid name attribute.", "<MT$tag>" ))
        unless defined $name;

    my $hash = $ctx->var($name) || {};
    return $ctx->error(MT->translate( "[_1] is not a hash.", $name ))
        unless 'HASH' eq ref($hash);

    {
        local $ctx->{__inside_set_hashvar} = $hash;
        _hdlr_pass_tokens(@_);
    }
    if ( my $parent_hash = $ctx->{__inside_set_hashvar} ) {
        $parent_hash->{$name} = $hash;
    }
    else {
        $ctx->var($name, $hash);
    }
    return q();
}

###########################################################################

=head2 SetVar

A function tag used to set the value of a template variable. This tag
is considered deprecated in favor of L<Var>, which can be used to both
retrieve and assign template variables.

B<Attributes:>

=over 4

=item * var or name

Identifies the name of the template variable. See L<Var> for more
information on the format of this attribute.

=item * value

The value to assign to the variable.

=item * op (optional)

See the L<Var> tag for more information about this attribute.

=item * prepend (optional)

If specified, places the contents at the front of any existing value
for the template variable.

=item * append (optional)

If specified, places the contents at the end of any existing value
for the template variable.

=back

=for tags deprecated

=cut

###########################################################################

=head2 SetVarBlock

A block tag used to set the value of a template variable. Note that
you can also use the global 'setvar' modifier to achieve the same result
as it can be applied to any MT tag.

B<Attributes:>

=over 4

=item * var or name (required)

Identifies the name of the template variable. See L<Var> for more
information on the format of this attribute.

=item * op (optional)

See the L<Var> tag for more information about this attribute.

=item * prepend (optional)

If specified, places the contents at the front of any existing value
for the template variable.

=item * append (optional)

If specified, places the contents at the end of any existing value
for the template variable.

=back

=for tags templating

=cut

###########################################################################

=head2 SetVarTemplate

Similar to the L<SetVarBlock> tag, but does not evaluate the contents
of the tag, but saves it for later evaluation, when the variable is
requested. This allows you to create inline template modules that you
can use over and over again.

B<Attributes:>

=over 4

=item * var or name (required)

Identifies the name of the template variable. See L<Var> for more
information on the format of this attribute.

=back

B<Example:>

    <mt:SetVarTemplate name="entry_title">
        <h1><$MTEntryTitle$></h1>
    </mt:SetVarTemplate>
    
    <mt:Entries>
        <$mt:Var name="entry_title"$>
    </mt:Entries>

=for tags templating

=cut

sub _hdlr_set_var {
    my($ctx, $args) = @_;
    my $tag = lc $ctx->stash('tag');
    my $name = $args->{name} || $args->{var};

    return $ctx->error(MT->translate(
        "You used a [_1] tag without a valid name attribute.", "<MT$tag>" ))
        unless defined $name;

    my ($func, $key, $index, $value);
    if ($name =~ m/^(\w+)\((.+)\)$/) {
        $func = $1;
        $name = $2;
    } else {
        $func = $args->{function} if exists $args->{function};
    }

    # pick off any {...} or [...] from the name.
    if ($name =~ m/^(.+)([\[\{])(.+)[\]\}]$/) {
        $name = $1;
        my $br = $2;
        my $ref = $3;
        if ($ref =~ m/^\$(.+)/) {
            $ref = $ctx->var($1);
            $ref = chr(0) unless defined $ref;
        }
        $br eq '[' ? $index = $ref : $key = $ref;
    } else {
        $index = $args->{index} if exists $args->{index};
        $key = $args->{key} if exists $args->{key};
    }

    if ($name =~ m/^\$/) {
        $name = $ctx->var($name);
        return $ctx->error(MT->translate(
            "You used a [_1] tag without a valid name attribute.", "<MT$tag>" ))
            unless defined $name;
    }

    my $val = '';
    my $data = $ctx->var($name);
    if (($tag eq 'setvar') || ($tag eq 'var')) {
        $val = defined $args->{value} ? $args->{value} : '';
    } elsif ($tag eq 'setvarblock') {
        $val = _hdlr_pass_tokens(@_);
        return unless defined($val);
    } elsif ($tag eq 'setvartemplate') {
        $val = $ctx->stash('tokens');
        return unless defined($val);
        $val = bless $val, 'MT::Template::Tokens';
    }

    my $existing = $ctx->var($name);
    $existing = '' unless defined $existing;
    if ( 'HASH' eq ref($existing) ) {
        $existing = $existing->{ $key };
    }
    elsif ( 'ARRAY' eq ref($existing) ) {
        $existing = ( defined $index && ( $index =~ /^-?\d+$/ ) )
          ? $existing->[ $index ] 
          : undef;
    }
    $existing = '' unless defined $existing;

    if ($args->{prepend}) {
        $val = $val . $existing;
    }
    elsif ($args->{append}) {
        $val = $existing . $val;
    }
    elsif ( $existing ne '' && ( my $op = $args->{op} ) ) {
        $val = _math_operation($ctx, $op, $existing, $val);
    }

    if ( defined $key ) {
        $data ||= {};
        return $ctx->error( MT->translate("'[_1]' is not a hash.", $name) )
            unless 'HASH' eq ref($data);

        if ( ( defined $func )
          && ( 'delete' eq lc( $func ) ) ) {
            delete $data->{ $key };
        }
        else {
            $data->{ $key } = $val;
        }
    }
    elsif ( defined $index ) {
        $data ||= [];
        return $ctx->error( MT->translate("'[_1]' is not an array.", $name) )
            unless 'ARRAY' eq ref($data);
        return $ctx->error( MT->translate("Invalid index.") )
            unless $index =~ /^-?\d+$/;
        $data->[ $index ] = $val;
    }
    elsif ( defined $func ) {
        if ( 'undef' eq lc( $func ) ) {
            $data = undef;
        }
        else {
            $data ||= [];
            return $ctx->error( MT->translate("'[_1]' is not an array.", $name) )
                unless 'ARRAY' eq ref($data);
            if ( 'push' eq lc( $func ) ) {
                push @$data, $val;
            }
            elsif ( 'unshift' eq lc( $func ) ) {
                $data ||= [];
                unshift @$data, $val;
            }
            else {
                return $ctx->error(
                    MT->translate("'[_1]' is not a valid function.", $func)
                );
            }
        }
    }
    else {
        $data = $val;
    }

    if ( my $hash = $ctx->{__inside_set_hashvar} ) {
        $hash->{$name} = $data;
    }
    else {
        $ctx->var($name, $data);
    }
    return '';
}

###########################################################################

=head2 CGIPath

The value of the C<CGIPath> configuration setting. Example (the output
is guaranteed to end with "/", so appending one prior to a script
name is unnecessary):

    <a href="<$mt:CGIPath$>some-cgi-script.cgi">

=for tags configuration

=cut

sub _hdlr_cgi_path {
    my ($ctx) = @_;
    my $path = $ctx->{config}->CGIPath;
    if ($path =~ m!^/!) {
        # relative path, prepend blog domain
        if (my $blog = $ctx->stash('blog')) {
            my ($blog_domain) = $blog->archive_url =~ m|(.+://[^/]+)|;
            $path = $blog_domain . $path;
        }
    }
    $path .= '/' unless $path =~ m!/$!;
    return $path;
}

###########################################################################

=head2 AdminCGIPath

Returns the value of the C<AdminCGIPath> configuration setting if set. Otherwise, the value of the C<CGIPath> setting is returned.

In the event that the configured path has no domain (ie, "/cgi-bin/"), the active blog's domain will be used.

The path produced by this tag will always have an ending '/', even if one does not exist as configured.

B<Example:>

    <$mt:AdminCGIPath$>

=for tags path, configuration

=cut

sub _hdlr_admin_cgi_path {
    my ($ctx) = @_;
    my $cfg = $ctx->{config};
    my $path = $cfg->AdminCGIPath || $cfg->CGIPath;
    if ($path =~ m!^/!) {
        # relative path, prepend blog domain
        my $blog = $ctx->stash('blog');
        my ($blog_domain) = $blog->archive_url =~ m|(.+://[^/]+)|;
        $path = $blog_domain . $path;
    }
    $path .= '/' unless $path =~ m!/$!;
    return $path;
}

###########################################################################

=head2 ConfigFile

Returns the full file path for the Movable Type configuration file
(mt-config.cgi).

=for tags configuration

=cut

sub _hdlr_config_file {
    return MT->instance->{cfg_file};
}

###########################################################################

=head2 CGIServerPath

Returns the file path to the directory where Movable Type has been
installed. Any trailing "/" character is removed.

=for tags configuration

=cut

sub _hdlr_cgi_server_path {
    my $path = MT->instance->server_path() || "";
    $path =~ s!/*$!!;
    return $path;
}

###########################################################################

=head2 CGIRelativeURL

The relative URL (path) extracted from the CGIPath setting in
mt-config.cgi. This is the same as L<CGIPath>, but without any
domain name. This value is guaranteed to end with a "/" character.

=for tags configuration

=cut

sub _hdlr_cgi_relative_url {
    my ($ctx) = @_;
    my $url = $ctx->{config}->CGIPath;
    $url .= '/' unless $url =~ m!/$!;
    if ($url =~ m!^https?://[^/]+(/.*)$!) {
        return $1;
    }
    return $url;
}

###########################################################################

=head2 StaticFilePath

The file path to the directory where Movable Type's static files are
stored (as configured by the C<StaticFilePath> setting, or based on
the location of the MT application files alone). This value is
guaranteed to end with a "/" character.

=for tags configuration

=cut

sub _hdlr_static_file_path {
    my ($ctx) = @_;
    my $cfg = $ctx->{config};
    my $path = $cfg->StaticFilePath;
    if (!$path) {
        $path = MT->instance->{mt_dir};
        $path .= '/' unless $path =~ m!/$!;
        $path .= 'mt-static/';
    }
    $path .= '/' unless $path =~ m!/$!;
    return $path;
}

###########################################################################

=head2 StaticWebPath

The value of the C<StaticWebPath> configuration setting. If this setting
has no domain, the blog domain is added to it. This value is
guaranteed to end with a "/" character.

B<Example:>

    <img src="<$mt:StaticWebPath$>images/powered.gif"
        alt="Powered by MT" />

=for tags configuration

=cut

sub _hdlr_static_path {
    my ($ctx) = @_;
    my $cfg = $ctx->{config};
    my $path = $cfg->StaticWebPath;
    if (!$path) {
        $path = $cfg->CGIPath;
        $path .= '/' unless $path =~ m!/$!;
        $path .= 'mt-static/';
    }
    if ($path =~ m!^/!) {
        # relative path, prepend blog domain
        my $blog = $ctx->stash('blog');
        if ($blog) {
            my ($blog_domain) = $blog->archive_url =~ m|(.+://[^/]+)|;
            $path = $blog_domain . $path;
        }
    }
    $path .= '/' unless $path =~ m!/$!;
    return $path;
}

###########################################################################

=head2 AdminScript

Returns the value of the C<AdminScript> configuration setting. The default
for this setting if unassigned is "mt.cgi".

=for tags configuration

=cut

sub _hdlr_admin_script {
    my ($ctx) = @_;
    return $ctx->{config}->AdminScript;
}

###########################################################################

=head2 CommentScript

Returns the value of the C<CommentScript> configuration setting. The
default for this setting if unassigned is "mt-comments.cgi".

=for tags configuration

=cut

sub _hdlr_comment_script {
    my ($ctx) = @_;
    return $ctx->{config}->CommentScript;
}

###########################################################################

=head2 TrackbackScript

Returns the value of the C<TrackbackScript> configuration setting. The
default for this setting if unassigned is "mt-tb.cgi".

=for tags configuration

=cut

sub _hdlr_trackback_script {
    my ($ctx) = @_;
    return $ctx->{config}->TrackbackScript;
}

###########################################################################

=head2 SearchScript

Returns the value of the C<SearchScript> configuration setting. The
default for this setting if unassigned is "mt-search.cgi".

=for tags configuration

=cut

sub _hdlr_search_script {
    my ($ctx) = @_;
    return $ctx->{config}->SearchScript;
}

###########################################################################

=head2 SearchMaxResults

Returns the value of the C<SearchMaxResults> or C<MaxResults> configuration
setting. Use C<SearchMaxResults> because MaxResults is considered deprecated.

=for tags search, configuration

=cut

sub _hdlr_search_max_results {
    my ($ctx) = @_;
    return $ctx->{config}->MaxResults;
}

###########################################################################

=head2 XMLRPCScript

Returns the value of the C<XMLRPCScript> configuration setting. The
default for this setting if unassigned is "mt-xmlrpc.cgi".

=for tags configuration

=cut

sub _hdlr_xmlrpc_script {
    my ($ctx) = @_;
    return $ctx->{config}->XMLRPCScript;
}

###########################################################################

=head2 AtomScript

Returns the value of the C<AtomScript> configuration setting. The
default for this setting if unassigned is "mt-atom.cgi".

=for tags configuration

=cut

sub _hdlr_atom_script {
    my ($ctx) = @_;
    return $ctx->{config}->AtomScript;
}

###########################################################################

=head2 NotifyScript

Returns the value of the C<NotifyScript> configuration setting. The
default for this setting if unassigned is "mt-add-notify.cgi".

=for tags configuration

=cut

sub _hdlr_notify_script {
    my ($ctx) = @_;
    return $ctx->{config}->NotifyScript;
}

###########################################################################

=head2 IfAuthor

A conditional tag that is true when an author object is in context.

    <mt:IfAuthor>
        Author: <$mt:AuthorDisplayName$>
    </mt:IfAuthor>

=for tags authors

=cut

sub _hdlr_if_author {
    my ($ctx) = @_;
    return $ctx->stash('author') ? 1 : 0;
}

###########################################################################

=head2 AuthorHasEntry

A conditional tag that is true when the author currently in context
has written one or more entries that have been published.

    <mt:AuthorHasEntry>
    <a href="<$mt:ArchiveLink type="Author">">Archive for this author</a>
    </mt:AuthorHasEntry>

=for tags authors, entries

=cut

sub _hdlr_author_has_entry {
    my ($ctx)   = @_;
    my $author  = $ctx->stash('author')
      or return $ctx->_no_author_error();

    my %terms;
    $terms{blog_id}   = $ctx->stash('blog_id');
    $terms{author_id} = $author->id;
    $terms{class}     = 'entry';
    $terms{status}    = MT::Entry::RELEASE();

    my $class = MT->model('entry');
    $class->exist( \%terms );
}

###########################################################################

=head2 AuthorHasPage

A conditional tag that is true when the author currently in context
has written one or more pages that have been published.

=for tags authors, pages

=cut

sub _hdlr_author_has_page {
    my ($ctx)   = @_;
    my $author  = $ctx->stash('author')
      or return $ctx->_no_author_error();

    my %terms;
    $terms{blog_id}   = $ctx->stash('blog_id');
    $terms{author_id} = $author->id;
    $terms{class}     = 'page';
    $terms{status}    = MT::Entry::RELEASE();

    my $class = MT->model('page');
    $class->exist( \%terms );
}

###########################################################################

=head2 Authors

A container tag which iterates over a list of authors. Default listing
includes Authors who have at least one published entry.

B<Attributes:>

=over 4

=item * display_name

Specifies a particular author to select.

=item * lastn

Limits the selection of authors to the specified number.

=item * sort_by (optional)

Supported values: display_name, name, created_on.

=item * sort_order (optional; default "ascend")

Supported values: ascend, descend.

=item * any_type (optional; default "0")

Pass a value of '1' for this attribute to cause it to select users of
any type associated with the blog, including commenters.

=item * roles

A comma separated list of roles used to select users by.
eg: "Author, Commenter".

=item * need_entry (optional; default "1")

Identifies whether the author(s) must have published an entry
to be included or not.

=item * status (optional; default "enabled")

Supported values: enabled, disabled.

=item * namespace

Used in conjunction with the "min*", "max*" attributes to
select authors based on a particular scoring mechanism.

=item * min_score

If 'namespace' is also specified, filters the authors based on
the score within that namespace. This specifies the minimum score
to consider the author for inclusion.

=item * max_score

If 'namespace' is also specified, filters the authors based on
the score within that namespace. This specifies the maximum score
to consider the author for inclusion.

=item * min_rank

If 'namespace' is also specified, filters the authors based on
the rank within that namespace. This specifies the minimum rank
to consider the author for inclusion.

=item * max_rate

If 'namespace' is also specified, filters the authors based on
the rank within that namespace. This specifies the maximum rank
to consider the author for inclusion.

=item * min_count

If 'namespace' is also specified, filters the authors based on
the count within that namespace. This specifies the minimum count
to consider the author for inclusion.

=item * max_count

If 'namespace' is also specified, filters the authors based on
the count within that namespace. This specifies the maximum count
to consider the author for inclusion.

=back

List all Authors in a blog with at least 1 entry:

    <mt:Authors>
       <a href="<$mt:AuthorURL$>"><$mt:AuthorDisplayName$></a>
    </mt:Authors>

List all Authors and Commenters for a blog:

    <mt:Authors need_entry="0" roles="Author, Commenter">
        <a href="<$mt:AuthorURL$>"><mt:AuthorDisplayName$></a>
    </mt:Authors>

=for tags multiblog, loop, scoring, authors

=cut

sub _hdlr_authors {
    my($ctx, $args, $cond) = @_;
    my $blog_id = $ctx->stash('blog_id');
    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');

    require MT::Entry;
    require MT::Author;

    my (%blog_terms, %blog_args);
    $ctx->set_blog_load_context($args, \%blog_terms, \%blog_args)
        or return $ctx->error($ctx->errstr);
    my (@filters, %terms, %args);

    if ($args->{display_name}) {
        $terms{nickname} = $args->{display_name};
    }
    if (my $status_arg = $args->{status} || 'enabled') {
        if ($status_arg !~ m/\b(OR)\b|\(|\)/i) {
            my @status = MT::Tag->split(',', $status_arg);
            $status_arg = join " or ", @status;
        }
        my $status = [
            { name => 'enabled', id  => 1 },
            { name => 'disabled', id  => 2 },
        ];
        my $cexpr = $ctx->compile_status_filter($status_arg, $status);
        if ($cexpr) {
            push @filters, $cexpr;
        }
    }
    if (my $role_arg = $args->{role} || $args->{roles}) {
        if ($role_arg !~ m/\b(OR)\b|\(|\)/i) {
            my @roles = MT::Tag->split(',', $role_arg);
            $role_arg = join " or ", @roles;
        }
        require MT::Association;
        require MT::Role;
        my $roles = [ MT::Role->load(undef, { sort => 'name' }) ];
        my $cexpr = $ctx->compile_role_filter($role_arg, $roles);
        if ($cexpr) {
            my %map;
            for my $role (@$roles) {
                my $iter = MT::Association->load_iter({
                    role_id => $role->id,
                    %blog_terms
                }, \%blog_args);
                while (my $as = $iter->()) {
                    $map{$as->author_id}{$role->id}++;
                }
            }
            push @filters, sub { $cexpr->($_[0]->id, \%map) };
        }
    }

    if (defined $args->{need_entry} ? $args->{need_entry} : 1) {
        $blog_args{'unique'} = 1;
        $blog_terms{'status'} = MT::Entry::RELEASE();
        $args{'join'} = MT::Entry->join_on('author_id',
            \%blog_terms, \%blog_args);
    } else {
        $blog_args{'unique'} = 1;
        if (!$args->{role}) {
            require MT::Permission;
            $args{'join'} =
                MT::Permission->join_on( 'author_id', undef, \%blog_args );
            if ( ! $args->{any_type} ) {
                push @filters, sub {
                    $_[0]->permissions($blog_id)->can_administer_blog
                        || $_[0]->permissions($blog_id)->can_post;
                };
            }
        }
    }

    if ($args->{namespace}) {
        my $namespace = $args->{namespace};

        my $need_join = 0;
        if ($args->{sort_by} && ($args->{sort_by} eq 'score' || $args->{sort_by} eq 'rate')) {
            $need_join = 1;
        } else {
            for my $f qw( min_score max_score min_rate max_rate min_count max_count scored_by ) {
                if ($args->{$f}) {
                    $need_join = 1;
                    last;
                }
            }
        }
        if ($need_join) {
            $args{join} = MT->model('objectscore')->join_on(undef,
                {
                    object_id => \'=author_id',
                    object_ds => 'author',
                    namespace => $namespace,
                }, {
                    unique => 1,
            });
        }

        # Adds a rate or score filter to the filter list.
        if ($args->{min_score}) {
            push @filters, sub { $_[0]->score_for($namespace) >= $args->{min_score}; };
        }
        if ($args->{max_score}) {
            push @filters, sub { $_[0]->score_for($namespace) <= $args->{max_score}; };
        }
        if ($args->{min_rate}) {
            push @filters, sub { $_[0]->score_avg($namespace) >= $args->{min_rate}; };
        }
        if ($args->{max_rate}) {
            push @filters, sub { $_[0]->score_avg($namespace) <= $args->{max_rate}; };
        }
        if ($args->{min_count}) {
            push @filters, sub { $_[0]->vote_for($namespace) >= $args->{min_count}; };
        }
        if ($args->{max_count}) {
            push @filters, sub { $_[0]->vote_for($namespace) <= $args->{max_count}; };
        }
    }

    my $re_sort = 0;
    my $score_limit = 0;
    my $score_offset = 0;
    $args{'sort'} = 'created_on';
    if ($args->{'sort_by'}) {
        if (lc $args->{'sort_by'} eq 'display_name') {
            $args{'sort'} = 'nickname';
        } elsif ('score' eq $args->{sort_by} || 'rate' eq $args->{sort_by}) {
            $score_limit = delete($args->{lastn}) || 0;
            $score_offset = delete($args->{offset}) || 0;
            $re_sort = 1;
        } elsif (MT::Author->has_column($args->{sort_by})) {
            $args{'sort'} = $args->{sort_by};
        }
    }
    if ($args->{'limit'}) {
        $args{limit} = $args->{limit};
    }

    if ($re_sort) {
        $args{'direction'} = 'ascend';
    } else{
        $args{'direction'} = $args->{sort_order} || 'ascend';
    }

    my $iter = MT::Author->load_iter(\%terms, \%args);
    my $count = 0;
    my $next = $iter->();
    my $n = $args->{lastn};
    my @authors;
    AUTHOR: while ($next) {
        my $author = $next;
        $next = $iter->();
        for (@filters) {
            next AUTHOR unless $_->($author);
        }
        push @authors, $author;
        $count++;
        if ($n && ($count > $n)) {
            $iter->end;
            last;
        }
    }

    if ($re_sort && (scalar @authors)) {
        my $col = $args->{sort_by};
        my $namespace = $args->{'namespace'};
        if ('score' eq $col) {
            my $so = $args->{sort_order} || '';
            my %a = map { $_->id => $_ } @authors;
            my @aid = keys %a;
            require MT::ObjectScore;
            my $scores = MT::ObjectScore->sum_group_by(
                { 'object_ds' => 'author', 'namespace' => $namespace, object_id => \@aid },
                { 'sum' => 'score', group => ['object_id'],
                  $so eq 'ascend' ? (direction => 'ascend') : (direction => 'descend'),
                });
            my @tmp;
            my $i = 0;
            while (my ($score, $object_id) = $scores->()) {
                next if $score_offset && ($i + 1) < $score_offset;
                push @tmp, delete $a{ $object_id } if exists $a{ $object_id };
                $scores->end, last unless %a;
                $i++;
                $scores->end, last if $score_limit && $i >= $score_limit;
            }
            @authors = @tmp;
        } elsif ('rate' eq $col) {
            my $so = $args->{sort_order} || '';
            my %a = map { $_->id => $_ } @authors;
            my @aid = keys %a;
            require MT::ObjectScore;
            my $scores = MT::ObjectScore->avg_group_by(
                { 'object_ds' => 'author', 'namespace' => $namespace, object_id => \@aid },
                { 'avg' => 'score', group => ['object_id'],
                  $so eq 'ascend' ? (direction => 'ascend') : (direction => 'descend'),
                });
            my @tmp;
            my $i = 0;
            while (my ($score, $object_id) = $scores->()) {
                next if $score_offset && ($i + 1) < $score_offset;
                push @tmp, delete $a{ $object_id } if exists $a{ $object_id };
                $scores->end, last unless %a;
                $i++;
                $scores->end, last if $score_limit && $i >= $score_limit;
            }
            @authors = @tmp;
        }
    }

    my $res = '';
    my $vars = $ctx->{__stash}{vars} ||= {};
    $count = 0;
    for my $author (@authors) {
        $count++;
        local $ctx->{__stash}{author} = $author;
        local $ctx->{__stash}{author_id} = $author->id;
        local $vars->{__first__} = $count == 1;
        local $vars->{__last__} = !defined $authors[$count] || ($n && ($count == $n));
        local $vars->{__odd__} = ($count % 2) == 1;
        local $vars->{__even__} = ($count % 2) == 0;
        local $vars->{__counter__} = $count;
        defined(my $out = $builder->build($ctx, $tokens, $cond))
            or return $ctx->error( $builder->errstr );
        $res .= $out;
    }
    $res;
}

###########################################################################

=head2 AuthorID

Outputs the numeric ID of the author currently in context. If no author
is in context, it will use the author of the entry or page in context.

=for tags authors

=cut

sub _hdlr_author_id {
    my ($ctx) = @_;
    my $author = $ctx->stash('author');
    unless ($author) {
        my $e = $ctx->stash('entry'); 
        $author = $e->author if $e; 
    }
    return $ctx->_no_author_error() unless $author;
    return $author->id;
}

###########################################################################

=head2 AuthorName

Outputs the username of the author currently in context. If no author
is in context, it will use the author of the entry or page in context.

B<NOTE:> it is not recommended to publish the author's username.

=for tags authors

=cut

sub _hdlr_author_name {
    my ($ctx) = @_;
    my $author = $ctx->stash('author');
    unless ($author) {
        my $e = $ctx->stash('entry'); 
        $author = $e->author if $e; 
    }
    return $ctx->_no_author_error() unless $author;
    return $author->name;
}

###########################################################################

=head2 AuthorDisplayName

Outputs the display name of the author currently in context. If no author
is in context, it will use the author of the entry or page in context.

=for tags authors

=cut

sub _hdlr_author_display_name { 
    my ($ctx) = @_;
    my $a = $ctx->stash('author'); 
    unless ($a) { 
        my $e = $ctx->stash('entry'); 
        $a = $e->author if $e; 
    }
    return $ctx->_no_author_error() unless $a;
    return $a->nickname || MT->translate('(Display Name not set)', $a->id);
}

###########################################################################

=head2 AuthorEmail

Outputs the email address of the author currently in context. If no author
is in context, it will use the author of the entry or page in context.

B<NOTE:> it is not recommended to publish the author's email address.

=for tags authors

=cut

sub _hdlr_author_email {
    my ($ctx, $args) = @_;
    my $author = $ctx->stash('author');
    unless ($author) {
        my $e = $ctx->stash('entry'); 
        $author = $e->author if $e; 
    }
    return $ctx->_no_author_error() unless $author;
    my $email = $author->email;
    return '' unless defined $email;
    return $args && $args->{'spam_protect'} ? spam_protect($email) : $email;
}

###########################################################################

=head2 AuthorURL

Outputs the URL field of the author currently in context. If no author
is in context, it will use the author of the entry or page in context.

=for tags authors

=cut

sub _hdlr_author_url {
    my ($ctx) = @_;
    my $author = $ctx->stash('author');
    unless ($author) {
        my $e = $ctx->stash('entry'); 
        $author = $e->author if $e; 
    }
    return $ctx->_no_author_error() unless $author;
    my $url = $author->url;
    return defined $url ? $url : '';
}

###########################################################################

=head2 AuthorAuthType

Outputs the authentication type identifier for the author currently
in context. For Movable Type registered users, this is "MT".

=for tags authors

=cut

sub _hdlr_author_auth_type {
    my ($ctx) = @_;
    my $author = $ctx->stash('author');
    unless ($author) {
        my $e = $ctx->stash('entry'); 
        $author = $e->author if $e; 
    }
    return $ctx->_no_author_error() unless $author;
    my $auth_type = $author->auth_type;
    return defined $auth_type ? $auth_type : '';
}

###########################################################################

=head2 AuthorAuthIconURL

Returns URL to a small (16x16) image represents in what authentication
provider the author in context is authenticated. For most of users it will
be a small spanner logo of Movable Type. If user is a commenter, icon image
is provided by each of authentication provider. Movable Type provides
images for Vox, LiveJournal and OpenID out of the box.

B<Attributes:>

=over 4

=item * size (optional; default "logo_small")

Identifies the requested size of the logo. This is an identifier,
not a dimension in pixels. And, currently, "logo_small" is the only
supported identifier.

=back

B<Example:>

    <mt:Authors>
        <img src="<$mt:AuthorAuthIconURL$>" height="16" width="16" />
        <$mt:AuthorDisplayName$>
    </mt:Authors>

=for tags authors

=cut

sub _hdlr_author_auth_icon_url {
    my ($ctx, $args) = @_;
    my $author = $ctx->stash('author');
    unless ($author) { 
        my $e = $ctx->stash('entry'); 
        $author = $e->author if $e; 
    }
    return $ctx->_no_author_error() unless $author;
    my $size = $args->{size} || 'logo_small';
    my $url = $author->auth_icon_url($size);
    if ($url =~ m!^/!) {
        # relative path, prepend blog domain
        my $blog = $ctx->stash('blog');
        if ($blog) {
            my ($blog_domain) = $blog->archive_url =~ m|(.+://[^/]+)|;
            $url = $blog_domain . $url;
        }
    }
    return $url;
}

###########################################################################

=head2 AuthorUserpic

This template tags returns a complete HTML <img> tag representing the
current author's userpic. For example:

    <img src="http://www.yourblog.com/path/to/userpic.jpg"
        width="100" height="100" />

=for tags authors, userpics

=cut

sub _hdlr_author_userpic {
    my ($ctx) = @_;
    my $author = $ctx->stash('author');
    unless ($author) {
        my $e = $ctx->stash('entry'); 
        $author = $e->author if $e; 
    }
    return $ctx->_no_author_error() unless $author;
    return $author->userpic_html() || '';
}

###########################################################################

=head2 AuthorUserpicURL

This template tag returns the fully qualified URL for the userpic of
the author currently in context.

If the author has no userpic, this will output an empty string.

=for tags authors, userpics

=cut

sub _hdlr_author_userpic_url {
    my ($ctx) = @_;
    my $author = $ctx->stash('author');
    unless ($author) {
        my $e = $ctx->stash('entry'); 
        $author = $e->author if $e; 
    }
    return $ctx->_no_author_error() unless $author;
    return $author->userpic_url() || '';
}

###########################################################################

=head2 AuthorUserpicAsset

This container tag creates a context that contains the userpic asset for
the current author. This then allows you to use all of Movable Type's
asset template tags to display the userpic's properties.

    <ul><mt:Authors>
         <mt:AuthorUserpicAsset>
           <li>
             <img src="<$mt:AssetThumbnailURL width="20" height="20"$>"
                width="20" height="20"  />
             <$mt:AuthorName$>
           </li>
         </mt:AuthorUserpicAsset>
    </mt:Authors></ul>

=for tags authors, userpics, assets

=cut

sub _hdlr_author_userpic_asset {
    my ($ctx, $args, $cond) = @_;

    my $author = $ctx->stash('author');
    unless ($author) {
        my $e = $ctx->stash('entry'); 
        $author = $e->author if $e; 
    }
    return $ctx->_no_author_error() unless $author;
    my $asset = $author->userpic or return '';

    my $tok = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');

    local $ctx->{__stash}{asset} = $asset;
    $builder->build($ctx, $tok, { %$cond });
}

###########################################################################

=head2 AuthorBasename

Outputs the 'Basename' field of the author currently in context.

B<Attributes:>

=over 4

=item * separator (optional)

Accepts either "-" or "_". If unspecified, the raw basename value is
returned.

=back

=for tags authors

=cut

sub _hdlr_author_basename {
    my ($ctx, $args) = @_;
    my $author = $ctx->stash('author')
        or return $ctx->_no_author_error();
    my $name = $author->basename;
    $name = MT::Util::make_unique_author_basename($author) if !$name;
    if (my $sep = $args->{separator}) {
        if ($sep eq '-') {
            $name =~ s/_/-/g;
        } elsif ($sep eq '_') {
            $name =~ s/-/_/g;
        }
    }
    return $name;
}

###########################################################################

=head2 Blogs

A container tag which iterates over a list of all of the blogs in the
system. You can use any of the blog tags (L<BlogName>, L<BlogURL>, etc -
anything starting with MTBlog) inside of this tag set.

B<Attributes:>

=over 4

=item * blog_ids

This attribute allows you to limit the set of blogs iterated over by
L<Blogs>. Multiple blogs are specified in a comma-delimited fashion.
For example:

    <mt:Blogs blog_ids="1,12,19,37,112">

would iterate over only the blogs with IDs 1, 12, 19, 37 and 112.

=back

=for tags multiblog, loop, blogs

=cut

sub _hdlr_blogs {
    my($ctx, $args, $cond) = @_;
    my (%terms, %args);

    $ctx->set_blog_load_context($args, \%terms, \%args, 'id')
        or return $ctx->error($ctx->errstr);

    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');

    local $ctx->{__stash}{entries} = undef
        if $args->{ignore_archive_context};
    local $ctx->{current_timestamp} = undef
        if $args->{ignore_archive_context};
    local $ctx->{current_timestamp_end} = undef
        if $args->{ignore_archive_context};
    local $ctx->{__stash}{category} = undef
        if $args->{ignore_archive_context};
    local $ctx->{__stash}{archive_category} = undef
        if $args->{ignore_archive_context};

    require MT::Blog;
    $args{'sort'} = 'name';
    $args{direction} = 'ascend';
    my $iter = MT::Blog->load_iter(\%terms, \%args);
    my $res = '';
    my $count = 0;
    my $next = $iter->();
    my $vars = $ctx->{__stash}{vars} ||= {};
    while ($next) {
        my $blog = $next;
        $next = $iter->();
        $count++;
        local $ctx->{__stash}{blog} = $blog;
        local $ctx->{__stash}{blog_id} = $blog->id;
        local $vars->{__first__} = $count == 1;
        local $vars->{__last__} = !$next;
        local $vars->{__odd__} = ($count % 2) == 1;
        local $vars->{__even__} = ($count % 2) == 0;
        local $vars->{__counter__} = $count;
        defined(my $out = $builder->build($ctx, $tokens, $cond))
            or return $ctx->error($builder->errstr);
        $res .= $out;
    }
    $res;
}

###########################################################################

=head2 IfBlog

A conditional tag that produces its contents when there is a blog in
context. This tag is useful for situations where a blog may or may not
be in context, such as the search template, when a search is conducted
across all blogs.

B<Example:>

    <mt:IfBlog>
        <h1>Search results for <$mt:BlogName$>:</h1>
    <mt:Else>
        <h1>Search results from all blogs:</h1>
    </mt:IfBlog>

=for tags blogs

=cut

###########################################################################

=head2 BlogID

Outputs the numeric ID of the blog currently in context.

=for tags blogs

=cut

sub _hdlr_blog_id {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    $blog ? $blog->id : 0;
}

###########################################################################

=head2 BlogName

Outputs the name of the blog currently in context.

=for tags blogs

=cut

sub _hdlr_blog_name {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    my $name = $blog->name;
    defined $name ? $name : '';
}

###########################################################################

=head2 BlogDescription

Outputs the description field of the blog currently in context.

=for tags blogs

=cut

sub _hdlr_blog_description {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    my $d = $blog->description;
    defined $d ? $d : '';
}

###########################################################################

=head2 BlogURL

Outputs the Site URL field of the blog currently in context. An ending
'/' character is guaranteed.

=for tags blogs

=cut

sub _hdlr_blog_url {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    my $url = $blog->site_url;
    return '' unless defined $url;
    $url .= '/' unless $url =~ m!/$!;
    $url;
}

###########################################################################

=head2 BlogSitePath

Outputs the Site Root field of the blog currently in context. An ending
'/' character is guaranteed.

=for tags blogs

=cut

sub _hdlr_blog_site_path {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    my $path = $blog->site_path;
    return '' unless defined $path;
    $path .= '/' unless $path =~ m!/$!;
    $path;
}

###########################################################################

=head2 BlogArchiveURL

Outputs the Archive URL of the blog currently in context. An ending
'/' character is guaranteed.

=for tags blogs

=cut

sub _hdlr_blog_archive_url {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    my $url = $blog->archive_url;
    return '' unless defined $url;
    $url .= '/' unless $url =~ m!/$!;
    $url;
}

###########################################################################

=head2 BlogRelativeURL

Similar to the L<BlogURL> tag, but removes any domain name from the URL.

=for tags blogs

=cut

sub _hdlr_blog_relative_url {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    my $host = $blog->site_url;
    return '' unless defined $host;
    if ($host =~ m!^https?://[^/]+(/.*)$!) {
        return $1;
    } else {
        return '';
    }
}

###########################################################################

=head2 BlogTimezone

The timezone that has been specified for the blog displayed as an offset
from UTC in +|-hh:mm format. This setting can be changed on the blog's
General settings screen.

B<Attributes:>

=over 4

=item * no_colon (optional; default "0")

If specified, will produce the timezone without the ":" character
("+|-hhmm" only).

=back

=for tags blogs

=cut

sub _hdlr_blog_timezone {
    my ($ctx, $args) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    my $so = $blog->server_offset;
    my $no_colon = $args->{no_colon};
    my $partial_hour_offset = 60 * abs($so - int($so));
    sprintf("%s%02d%s%02d", $so < 0 ? '-' : '+',
            abs($so), $no_colon ? '' : ':',
            $partial_hour_offset);
}

{
    my %real_lang = (cz => 'cs', dk => 'da', jp => 'ja', si => 'sl');
    ###########################################################################

=head2 BlogLanguage

The blog's specified language for date display. This setting can be changed
on the blog's Entry settings screen.

B<Attributes:>

=over 4

=item * locale (optional; default "0")

If assigned, will format the language in the style "language_LOCALE" (ie: "en_US", "de_DE", etc).

=item * ietf (optional; default "0")

If assigned, will change any '_' in the language code to a '-', conforming
it to the IETF RFC # 3066.

=back

=for tags blogs

=cut

sub _hdlr_blog_language {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $lang_tag = ($blog ? $blog->language : $ctx->{config}->DefaultLanguage) || '';
    $lang_tag = ($real_lang{$lang_tag} || $lang_tag);
    if ($args->{'locale'}) {
        $lang_tag =~ s/^(..)([-_](..))?$/$1 . '_' . uc($3||$1)/e;
    } elsif ($args->{"ietf"}) {
        # http://www.ietf.org/rfc/rfc3066.txt
        $lang_tag =~ s/_/-/;
    }
    $lang_tag;
}
}

###########################################################################

=head2 BlogHost

The host name part of the absolute URL of your blog.

B<Attributes:>

=over 4

=item * exclude_port (optional; default "0")

Removes any specified port number if this attribute is set to true (1),
otherwise it will return the hostname and port number (e.g.
www.somedomain.com:8080).

=item * signature (optional; default "0")

If set to 1, then this template tag will instead return a unique signature
for the hostname, by replacing all occurrences of decimals (".") with
underscores ("_").

=back

=for tags blogs

=cut

sub _hdlr_blog_host {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    my $host = $blog->site_url;
    if ($host =~ m!^https?://([^/:]+)(:\d+)?/?!) {
        if ($args->{signature}) {
            # using '_' to replace '.' since '-' is a valid
            # letter for domains
            my $sig = $1;
            $sig =~ s/\./_/g;
            return $sig;
        }
        return $args->{exclude_port} ? $1 : $1 . ($2 || '');
    } else {
        return '';
    }
}

###########################################################################

=head2 CGIHost

Returns the domain host from the configuration directive CGIPath. If CGIPath
is defined as a relative path, then the domain is derived from the Site URL
in the blog's "Publishing Settings".

B<Attributes:>

=over 4

=item * exclude_port (optional; default "0")

If set, exclude the port number from the CGIHost.

=back

=for tags configuration

=cut

sub _hdlr_cgi_host {
    my ($ctx, $args, $cond) = @_;
    my $path = _hdlr_cgi_path(@_);
    if ($path =~ m!^https?://([^/:]+)(:\d+)?/!) {
        return $args->{exclude_port} ? $1 : $1 . ($2 || '');
    } else {
        return '';
    }
}

###########################################################################

=head2 BlogCategoryCount

Returns the number of categories associated with a blog. This
template tag supports the multiblog template tags.

This template tag also supports all of the same filtering mechanisms
defined by the mt:Categories tag allowing users to retrieve a count
of the number of comments on a blog that meet a certain criteria.

B<Example:>

    <$mt:BlogCategoryCount$>

=for tags multiblog, count, blogs, categories

=cut

sub _hdlr_blog_category_count {
    my ($ctx, $args, $cond) = @_;
    my (%terms, %args);
    $ctx->set_blog_load_context($args, \%terms, \%args)
        or return $ctx->error($ctx->errstr);
    my $count = MT::Category->count(\%terms, \%args);
    return $ctx->count_format($count, $args);
}

###########################################################################

=head2 BlogEntryCount

Returns the number of published entries associated with the blog
currently in context.

=for tags multiblog, count, blogs, entries

=cut

sub _hdlr_blog_entry_count {
    my ($ctx, $args, $cond) = @_;
    my $class_type = $args->{class_type} || 'entry';
    my $class = MT->model($class_type);
    my (%terms, %args);
    $ctx->set_blog_load_context($args, \%terms, \%args)
        or return $ctx->error($ctx->errstr);
    $terms{status} = MT::Entry::RELEASE();
    my $count = $class->count(\%terms, \%args);
    return $ctx->count_format($count, $args);
}

###########################################################################

=head2 BlogCommentCount

Returns the number of published comments associated with the blog
currently in context.

=for tags multiblog, count, blogs, comments

=cut

sub _hdlr_blog_comment_count {
    my ($ctx, $args, $cond) = @_;
    my (%terms, %args);
    $ctx->set_blog_load_context($args, \%terms, \%args)
        or return $ctx->error($ctx->errstr);
    $terms{visible} = 1;
    require MT::Comment;
    my $count = MT::Comment->count(\%terms, \%args);
    return $ctx->count_format($count, $args);
}

###########################################################################

=head2 BlogPingCount

Returns a count of published TrackBack pings associated with the blog
currently in context.

=for tags multiblog, count, blogs, pings

=cut

sub _hdlr_blog_ping_count {
    my ($ctx, $args, $cond) = @_;
    my (%terms, %args);
    $ctx->set_blog_load_context($args, \%terms, \%args)
        or return $ctx->error($ctx->errstr);
    $terms{visible} = 1;
    require MT::Trackback;
    require MT::TBPing;
    my $count = MT::Trackback->count(undef,
        { 'join' => MT::TBPing->join_on('tb_id', \%terms, \%args) });
    return $ctx->count_format($count, $args);
}

###########################################################################

=head2 BlogCCLicenseURL

Publishes the license URL of the Creative Commons logo appropriate
to the license assigned to the blog inc ontex.t If the blog doesn't
have a Creative Commons license, this tag returns an empty string.

=for tags blogs, creativecommons

=cut

sub _hdlr_blog_cc_license_url {
    my ($ctx) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    return $blog->cc_license_url;
}

###########################################################################

=head2 BlogCCLicenseImage

Publishes the URL of the Creative Commons logo appropriate to the
license assigned to the blog in context. If the blog doesn't have
a Creative Commons license, this tag returns an empty string.

B<Example:>

    <MTIf tag="BlogCCLicenseImage">
    <img src="<$MTBlogCCLicenseImage$>" alt="Creative Commons" />
    </MTIf>

=for tags blogs, creativecommons

=cut

sub _hdlr_blog_cc_license_image {
    my ($ctx) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    my $cc = $blog->cc_license or return '';
    my ($code, $license, $image_url) = $cc =~ /(\S+) (\S+) (\S+)/;
    return $image_url if $image_url;
    "http://creativecommons.org/images/public/" .
        ($cc eq 'pd' ? 'norights' : 'somerights');
}

###########################################################################

=head2 CCLicenseRDF

Returns the RDF markup for a Creative Commons License. If the blog
has not been assigned a license, this returns an empty string.

B<Attributes:>

=over 4

=item * with_index (optional; default "0")

If specified, forces the trailing "index" filename to be left on any
entry permalink published in the RDF block.

=for tags blogs, creativecommons

=cut

sub _hdlr_cc_license_rdf {
    my ($ctx, $arg) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    my $cc = $blog->cc_license or return '';
    my $cc_url = $blog->cc_license_url;
    my $rdf = <<RDF;
<!--
<rdf:RDF xmlns="http://web.resource.org/cc/"
         xmlns:dc="http://purl.org/dc/elements/1.1/"
         xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
RDF
    ## SGML comments cannot contain double hyphens, so we convert
    ## any double hyphens to single hyphens.
    my $strip_hyphen = sub {
        (my $s = $_[0]) =~ tr/\-//s;
        $s;
    };
    if (my $entry = $ctx->stash('entry')) {
        my $link = $entry->permalink;
        my $author_name = $entry->author ? $entry->author->nickname || '' : '';
        $link = MT::Util::strip_index($entry->permalink, $blog) unless $arg->{with_index};
        $rdf .= <<RDF;
<Work rdf:about="$link">
<dc:title>@{[ encode_xml($strip_hyphen->($entry->title)) ]}</dc:title>
<dc:description>@{[ encode_xml($strip_hyphen->(_hdlr_entry_excerpt(@_))) ]}</dc:description>
<dc:creator>@{[ encode_xml($strip_hyphen->($author_name)) ]}</dc:creator>
<dc:date>@{[ _hdlr_entry_date($ctx, { 'format' => "%Y-%m-%dT%H:%M:%S" }) .
             _hdlr_blog_timezone($ctx) ]}</dc:date>
<license rdf:resource="$cc_url" />
</Work>
RDF
    } else {
        $rdf .= <<RDF;
<Work rdf:about="@{[ $blog->site_url ]}">
<dc:title>@{[ encode_xml($strip_hyphen->($blog->name)) ]}</dc:title>
<dc:description>@{[ encode_xml($strip_hyphen->($blog->description)) ]}</dc:description>
<license rdf:resource="$cc_url" />
</Work>
RDF
    }
    $rdf .= MT::Util::cc_rdf($cc) . "</rdf:RDF>\n-->\n";
    $rdf;
}

###########################################################################

=head2 BlogIfCCLicense

A conditional tag that is true when the current blog in context has
been assigned a Creative Commons License.

=for tags blogs, creativecommons

=cut

sub _hdlr_blog_if_cc_license {
    my ($ctx) = @_;
    my $blog = $ctx->stash('blog');
    return 0 unless $blog;
    return $blog->cc_license ? 1 : 0;
}

###########################################################################

=head2 BlogFileExtension

Returns the configured blog filename extension, including a leading
'.' character. If no extension is assigned, this returns an empty
string.

=for tags blogs

=cut

sub _hdlr_blog_file_extension {
    my($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    my $ext = $blog->file_extension || '';
    $ext = '.' . $ext if $ext ne '';
    $ext;
}

###########################################################################

=head2 BlogTemplateSetID

Returns an identifier for the currently assigned template set for the
blog in context. The identifier is modified such that underscores are
changed to dashes. In the MT template sets, this identifier is assigned
to the "id" attribute of the C<body> HTML tag.

=for tags blogs

=cut

sub _hdlr_blog_template_set_id {
    my ($ctx) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    my $set = $blog->template_set || 'classic_blog';
    $set =~ s/_/-/g;
    return $set;
}

###########################################################################

=head2 Entries

The Entries tag is a workhorse of MT publishing. It is used for
publishing a selection of entries in a variety of situations. Typically,
the basic use (specified without any attributes) outputs the selection
of entries that are appropriate for the page being published. But you
can use this tag for publishing custom modules, index templates and
widgets to select content in many different ways.

B<Attributes:>

=over 4

=item * lastn (optional)

Allows you to limit the number of entries output. This attribute
always implies selection of entries based on their 'authored' date, in
reverse chronological order.

    <mt:Entries lastn="5" sort_by="title" sort_order="ascend">

This would publish the 5 most recent entries, ordered by their titles.

=item * limit (optional)

Similar to the C<lastn> attribute, but limits output based on whichever
sort order is in use.

=item * sort_by (optional; default "authored_on")

Accepted values are: C<authored_on>, C<title>, C<ping_count>,
C<comment_count>, C<author_id>, C<excerpt>, C<status>, C<created_on>,
C<modified_on>, C<rate>, C<score> (both C<rate> and C<score> require a C<namespace> attribute to be present).

If you have the Professional Pack installed, with custom fields, you
may specify a custom field basename to sort the listing, by giving
a C<sort_by> value of C<field:I<basename>> (where 'basename' is the custom
field basename you wish to sort on).

=item * sort_order (optional)

Accepted values are 'ascend' and 'descend'. The default is the order
specified for publishing entries, set on the blog entry preferences
screen.

=item * field:I<basename>

Permits filtering entries based on a custom field defined (available
when the Commercial Pack is installed).

B<Example:>

    <mt:Entries field:special="1" sort_by="authored_on"
        sort_order="descend" limit="5">

This selects the last 5 entries that have a "special" custom field
(checkbox field) checked.

=item * namespace (optional)

The namespace attribute is used to specify which scoring namespace
to use when applying the C<sort_by="score"> attribute, or filtering
based on scoring (any of the C<min_*>, C<max_*> attributes require this).

The MT Community Pack provides a 'community_pack_recommend' namespace,
for instance, which can be used to select entries, sorting by number
of recommend/favorite votes that have been made.

=item * class_type (optional; default 'entry')

Accepted values are 'entry' and 'page'.

=item * offset (optional)

Accepted values are any non-zero positive integers, or the keyword
"auto" which is used under dynamic publishing to automatically
determine the offset based on the C<offset> query parameter for
the request.

=item * category or categories (optional)

This attribute allows you to filter the entries based on category
assignment. The simple case is to filter for a single category,
where the full category name is specified:

    <mt:Entries category="Featured">

If you have multiple categories with the same name, you can give
their parent category names to be more explicit:

    <mt:Entries category="News/Featured">

or

    <mt:Entries category="Projects/Featured">

You can also use 'AND', 'OR' and 'NOT' operators to include or
exclude categories:

    <mt:Entries categories="(Family OR Pets) AND Featured">

or

    <mt:Entries categories="NOT Family">

=item * include_subcategories (optional)

If this attribute is specified in conjunction with the category (or
categories) attribute, it will cause any entries assigned to subcategories
of the identified category/categories to be included as well.

=item * tag or tags (optional)

This attribute functions similarly to the C<category> attribute, but
filters based on tag assignments. It also supports the logical operators
described for category selection.

=item * author (optional)

Accepts an author's username to filter entry selection.

B<Example:>

    <mt:Entries author="Melody">

=item * id (optional)

If specified, selects a single entry matching the given entry ID.

    <mt:Entries id="10">

=item * min_score (optional)

=item * max_score (optional)

=item * min_rate (optional)

=item * max_rate (optional)

=item * min_count (optional)

=item * max_count (optional)

Allows filtering of entries based on score, rating or count. Each of
the attributes require the C<namespace> attribute.

=item * scored_by (optional)

Allows filtering of entries that were scored by a particular user,
specified by username. Requires the C<namespace> attribute.

=item * days (optional)

Limits the selection of entries to a specified number of days,
based on the current date. For instance, if you specify:

    <mt:Entries days="10">

only entries that were authored within the last 10 days will be
published.

=item * recently_commented_on (optional)

Selects the list of entries that have received published comments
recently. The value of this attribute is the number of days to use
to limit the selection. For instance:

    <mt:Entries recently_commented_on="10">

will select entries that received published comments within the last
10 days. The order of the entries is the date of the most recently
received comment.

=item * unique

If specified, this flag will cause MT to keep track of which entries
are being published for a given page. It will also prevent the publishing
of entries already published.

For example, if you wish to publish the last 3 entries that are
tagged "@featured", but wish to exclude these entries from the set
of entries that follow, you can do this:


    <mt:Entries tag="@featured" lastn="3">
        ...
    </mt:Entries>
    
    <mt:Entries lastn="7" unique="1">
        ...
    </mt:Entries>

The second Entries tag will exclude any entries that were output
from the first Entries tag.

=item * glue (optional)

Specifies a string that is output inbetween published entries.

B<Example:>

    <mt:Entries glue=","><$mt:EntryID$></mt:Entries>

outputs something like this:

    10,9,8,7,6,5,4,3,2,1

=back

=for tags multiblog, loop, scoring

=cut

sub _hdlr_entries {
    my($ctx, $args, $cond) = @_;
    return $ctx->error(MT->translate('sort_by="score" must be used in combination with namespace.'))
        if ((exists $args->{sort_by}) && ('score' eq $args->{sort_by}) && (!exists $args->{namespace}));

    my $cfg = $ctx->{config};
    my $at = $ctx->{current_archive_type} || $ctx->{archive_type};
    my $blog_id = $ctx->stash('blog_id');
    my $blog = $ctx->stash('blog');
    my (@filters, %blog_terms, %blog_args, %terms, %args);

    $ctx->set_blog_load_context($args, \%blog_terms, \%blog_args)
        or return $ctx->error($ctx->errstr);
    %terms = %blog_terms;
    %args = %blog_args;

    my $class_type = $args->{class_type} || 'entry';
    my $class = MT->model($class_type);
    my $cat_class_type = $class->container_type();
    my $cat_class = MT->model($cat_class_type);

    my %fields;
    foreach my $arg ( keys %$args ) {
        if ($arg =~ m/^field:(.+)$/) {
            $fields{$1} = $args->{$arg};
        }
    }

    my $use_stash = 1;

    # For the stock Entries/Pages tags, clear any prepopulated
    # entries list (placed by archive publishing) if we're invoked
    # with any of the following attributes. A plugin tag may
    # prepopulate the entries stash and then invoke this handler
    # to permit further filtering of the entries.
    my $tag = lc $ctx->stash('tag');
    if (($tag eq 'entries') || ($tag eq 'pages')) {
        foreach my $args_key ('category', 'categories', 'tag', 'tags',
            'author') {
            if (exists($args->{$args_key})) {
                $use_stash = 0;
                last;
            }
        }
    }
    if ( $use_stash ) {
        foreach my $args_key ('id', 'days', 'recently_commented_on',
            'include_subcategories', 'include_blogs', 'exclude_blogs',
            'blog_ids') {
            if (exists($args->{$args_key})) {
                $use_stash = 0;
                last;
            }
        }
    }
    if ( $use_stash && %fields ) {
        $use_stash = 0;
    }

    my $entries;
    if ( $use_stash ) {
        $entries = $ctx->stash('entries');
        if ( !$entries && $at ) {
            my $archiver = MT->publisher->archiver($at);
            if ( $archiver && $archiver->group_based ) {
                $entries = $archiver->archive_group_entries( $ctx, %$args );
            }
        }
    }
    if ( $entries && scalar @$entries ) {
        my $entry = @$entries[0];
        if ( ! $entry->isa( $class ) ) {
            # class types do not match; we can't use stashed entries
            undef $entries;
        }
    }
    local $ctx->{__stash}{entries};

    # handle automatic offset based on 'offset' query parameter
    # in case we're invoked through mt-view.cgi or some other
    # app.
    if (($args->{offset} || '') eq 'auto') {
        $args->{offset} = 0;
        if (($args->{lastn} || $args->{limit}) && (my $app = MT->instance)) {
            if ($app->isa('MT::App')) {
                if (my $offset = $app->param('offset')) {
                    $args->{offset} = $offset;
                }
            }
        }
    }

    if (($args->{limit} || '') eq 'auto') {
        my ($days, $limit);
        my $blog = $ctx->stash('blog');
        if ($blog && ($days = $blog->days_on_index)) {
            my @ago = offset_time_list(time - 3600 * 24 * $days,
                $blog_id);
            my $ago = sprintf "%04d%02d%02d%02d%02d%02d",
                $ago[5]+1900, $ago[4]+1, @ago[3,2,1,0];
            $terms{authored_on} = [ $ago ];
            $args{range_incl}{authored_on} = 1;
        } elsif ($blog && ($limit = $blog->entries_on_index)) {
            $args->{lastn} = $limit;
        } else {
            delete $args->{limit};
        }
    } elsif ($args->{limit} && ($args->{limit} > 0)) {
        $args->{lastn} = $args->{limit};
    }

    $terms{status} = MT::Entry::RELEASE();

    if (!$entries) {
        if ($ctx->{inside_mt_categories}) {
            if (my $cat = $ctx->stash('category')) {
                $args->{category} ||= [ 'OR', [ $cat ] ]
                    if $cat->class eq $cat_class_type;
            }
        } elsif (my $cat = $ctx->stash('archive_category')) {
            $args->{category} ||= [ 'OR', [ $cat ] ]
                if $cat->class eq $cat_class_type;
        }
    }

    # kinds of <MTEntries> uses...
    #     * from an index template
    #     * from an archive context-- entries are prepopulated

    # Adds a category filter to the filters list.
    if (my $category_arg = $args->{category} || $args->{categories}) {
        my ($cexpr, $cats);
        if (ref $category_arg) {
            my $is_and = (shift @{$category_arg}) eq 'AND';
            $cats = [ @{ $category_arg->[0] } ];
            $cexpr = $ctx->compile_category_filter(undef, $cats, { 'and' => $is_and,
                children => 
                    $cat_class_type eq 'category' ?
                        ($args->{include_subcategories} ? 1 : 0) :
                        ($args->{include_subfolders} ? 1 : 0)
            });
        } else {
            if (($category_arg !~ m/\b(AND|OR|NOT)\b|[(|&]/i) &&
                (($cat_class_type eq 'category' && !$args->{include_subcategories}) ||
                 ($cat_class_type ne 'category' && !$args->{include_subfolders})))
            {
                if ($blog_terms{blog_id}) {
                    $cats = [ $cat_class->load(\%blog_terms, \%blog_args) ];
                } else {
                    my @cats = cat_path_to_category($category_arg, [ \%blog_terms, \%blog_args ], $cat_class_type);
                    if (@cats) {
                        $cats = \@cats;
                        $cexpr = $ctx->compile_category_filter(undef, $cats, { 'and' => 0 });
                    }
                }
            } else {
                my @cats = $cat_class->load(\%blog_terms, \%blog_args);
                if (@cats) {
                    $cats = \@cats;
                    $cexpr = $ctx->compile_category_filter($category_arg, $cats,
                        { children => $cat_class_type eq 'category' ?
                            ($args->{include_subcategories} ? 1 : 0) :
                            ($args->{include_subfolders} ? 1 : 0)
                        });
                }
            }
            $cexpr ||= $ctx->compile_category_filter($category_arg, $cats,
                { children => $cat_class_type eq 'category' ?
                    ($args->{include_subcategories} ? 1 : 0) :
                    ($args->{include_subfolders} ? 1 : 0) 
                });
        }
        if ($cexpr) {
            my %map;
            require MT::Placement;
            my @cat_ids = map { $_->id } @$cats;
            my $preloader = sub {
                my ($id) = @_;
                my @c_ids = MT::Placement->load(
                    { category_id => \@cat_ids, entry_id => $id },
                    { fetchonly => ['category_id'], no_triggers => 1 }
                );
                my %map;
                $map{$_->category_id} = 1 for @c_ids;
                \%map;
            };
            if ( !$entries ) {
                if ($category_arg !~ m/\bNOT\b/i) {
                    $args{join} = MT::Placement->join_on( 'entry_id', {
                            category_id => \@cat_ids, %blog_terms
                        }, { %blog_args, unique => 1 } );
                }
            }
            push @filters, sub { $cexpr->( $preloader->($_[0]->id) ) };
        } else {
            return $ctx->error(MT->translate("You have an error in your '[_2]' attribute: [_1]", $category_arg, $cat_class_type));
        }
    }
    # Adds a tag filter to the filters list.
    if (my $tag_arg = $args->{tags} || $args->{tag}) {
        require MT::Tag;
        require MT::ObjectTag;

        my $terms;
        if ($tag_arg !~ m/\b(AND|OR|NOT)\b|\(|\)/i) {
            my @tags = MT::Tag->split(',', $tag_arg);
            $terms = { name => \@tags };
            $tag_arg = join " or ", @tags;
        }
        my $tags = [ MT::Tag->load($terms, {
            ( $terms ? ( binary => { name => 1 } ) : () ),
            join => MT::ObjectTag->join_on('tag_id', {
                object_datasource => $class->datasource,
                %blog_terms,
            }, { %blog_args, unique => 1 } ),
        }) ];
        my $cexpr = $ctx->compile_tag_filter($tag_arg, $tags);
        if ($cexpr) {
            my @tag_ids = map { $_->id, ( $_->n8d_id ? ( $_->n8d_id ) : () ) } @$tags;
            my $preloader = sub {
                my ($entry_id) = @_;
                my %map;
                return \%map unless @tag_ids;
                my $terms = { 
                    tag_id => \@tag_ids,
                    object_id => $entry_id,
                    object_datasource => $class->datasource,
                    %blog_terms,
                };
                my $args = {
                    %blog_args,
                    fetchonly => ['tag_id'],
                    no_triggers => 1
                };
                my @ot_ids = MT::ObjectTag->load($terms, $args) if @tag_ids;
                $map{$_->tag_id} = 1 for @ot_ids;
                \%map;
            };
            if (!$entries) {
                if ($tag_arg !~ m/\bNOT\b/i) {
                    return '' unless @tag_ids;
                    $args{join} = MT::ObjectTag->join_on( 'object_id', {
                            tag_id => \@tag_ids, object_datasource => 'entry',
                            %blog_terms
                        }, { %blog_args, unique => 1 } );
                    if (my $last = $args->{lastn} || $args->{limit}) {
                        $args{limit} = $last;
                    }
                }
            }
            push @filters, sub { $cexpr->($preloader->($_[0]->id)) };
        } else {
            return $ctx->error(MT->translate("You have an error in your 'tag' attribute: [_1]", $tag_arg));
        }
    }

    # Adds an author filter to the filters list.
    if (my $author_name = $args->{author}) {
        require MT::Author;
        my $author = MT::Author->load({ name => $author_name }) or
            return $ctx->error(MT->translate(
                "No such user '[_1]'", $author_name ));
        if ($entries) {
            push @filters, sub { $_[0]->author_id == $author->id };
        } else {
            $terms{author_id} = $author->id;
        }
    }

    if ( my $f = MT::Component->registry("tags", "filters", "Entries") ) {
        foreach my $set ( @$f ) {
            foreach my $fkey ( keys %$set ) {
                if (exists $args->{$fkey}) {
                    my $h = $set->{$fkey}{code} ||= MT->handler_to_coderef( $set->{$fkey}{handler} );
                    next unless ref($h) eq 'CODE';

                    local $ctx->{filters} = \@filters;
                    local $ctx->{terms} = \%terms;
                    local $ctx->{args} = \%args;
                    $h->($ctx, $args, $cond);
                }
            }
        }
    }

    # Adds an ID filter to the filter list.
    if ((my $target_id = $args->{id}) && (ref($args->{id}) || ($args->{id} =~ m/^\d+$/))) {
        if ($entries) {
            if (ref $target_id eq 'ARRAY') {
                my %ids = map { $_ => 1 } @$target_id;
                push @filters, sub { exists $ids{$_[0]->id} };
            } else {
                push @filters, sub { $_[0]->id == $target_id };
            }
        } else {
            $terms{id} = $target_id;
        }
    }

    if ($args->{namespace}) {
        my $namespace = $args->{namespace};

        my $need_join = 0;
        for my $f qw( min_score max_score min_rate max_rate min_count max_count scored_by ) {
            if ($args->{$f}) {
                $need_join = 1;
                last;
            }
        }
        if ($need_join) {
            my $scored_by = $args->{scored_by} || undef;
            if ($scored_by) {
                require MT::Author;
                my $author = MT::Author->load({ name => $scored_by }) or
                    return $ctx->error(MT->translate(
                        "No such user '[_1]'", $scored_by ));
                $scored_by = $author;
            }

            $args{join} = MT->model('objectscore')->join_on(undef,
                {
                    object_id => \'=entry_id',
                    object_ds => 'entry',
                    namespace => $namespace,
                    (!$entries && $scored_by ? (author_id => $scored_by->id) : ()),
                }, {
                    unique => 1,
            });
            if ($entries && $scored_by) {
                push @filters, sub { $_[0]->get_score($namespace, $scored_by) };
            }
        }

        # Adds a rate or score filter to the filter list.
        if ($args->{min_score}) {
            push @filters, sub { $_[0]->score_for($namespace) >= $args->{min_score}; };
        }
        if ($args->{max_score}) {
            push @filters, sub { $_[0]->score_for($namespace) <= $args->{max_score}; };
        }
        if ($args->{min_rate}) {
            push @filters, sub { $_[0]->score_avg($namespace) >= $args->{min_rate}; };
        }
        if ($args->{max_rate}) {
            push @filters, sub { $_[0]->score_avg($namespace) <= $args->{max_rate}; };
        }
        if ($args->{min_count}) {
            push @filters, sub { $_[0]->vote_for($namespace) >= $args->{min_count}; };
        }
        if ($args->{max_count}) {
            push @filters, sub { $_[0]->vote_for($namespace) <= $args->{max_count}; };
        }
    }

    my $published = $ctx->{__stash}{entry_ids_published} ||= {};
    if ($args->{unique}) {
        push @filters, sub { !exists $published->{$_[0]->id} }
    }

    my $namespace = $args->{namespace};
    my $no_resort = 0;
    my $score_limit = 0;
    my $score_offset = 0;
    my @entries;
    if (!$entries) {
        my ($start, $end) = ($ctx->{current_timestamp},
                         $ctx->{current_timestamp_end});
        if ($start && $end) {
            $terms{authored_on} = [$start, $end];
            $args{range_incl}{authored_on} = 1;
        }
        if (my $days = $args->{days}) {
            my @ago = offset_time_list(time - 3600 * 24 * $days,
                $blog_id);
            my $ago = sprintf "%04d%02d%02d%02d%02d%02d",
                $ago[5]+1900, $ago[4]+1, @ago[3,2,1,0];
            $terms{authored_on} = [ $ago ];
            $args{range_incl}{authored_on} = 1;
        } else {
            # Check attributes
            my $found_valid_args = 0;
            foreach my $valid_key (
                'lastn',      'category',
                'categories', 'tag',
                'tags',       'author',
                'days',
                'min_score',  'max_score',
                'min_rate',    'max_rate',
                'min_count',  'max_count'
              )
            {
                if (exists($args->{$valid_key})) {
                    $found_valid_args = 1;
                    last;
                }
            }

            if (!$found_valid_args) {
                # Uses weblog settings
                if (my $days = $blog ? $blog->days_on_index : 10) {
                    my @ago = offset_time_list(time - 3600 * 24 * $days,
                        $blog_id);
                    my $ago = sprintf "%04d%02d%02d%02d%02d%02d",
                        $ago[5]+1900, $ago[4]+1, @ago[3,2,1,0];
                    $terms{authored_on} = [ $ago ];
                    $args{range_incl}{authored_on} = 1;
                } elsif (my $limit = $blog ? $blog->entries_on_index : 10) {
                    $args->{lastn} = $limit;
                }
            }
        }

        # Adds class_type
        $terms{class} = $class_type;

        $args{'sort'} = 'authored_on';
        if ($args->{sort_by}) {
            $args->{sort_by} =~ s/:/./; # for meta:name => meta.name
            $args->{sort_by} = 'ping_count' if $args->{sort_by} eq 'trackback_count';
            if ($class->is_meta_column($args->{sort_by})) {
                $no_resort = 0;
            } elsif ($class->has_column($args->{sort_by})) {
                $args{sort} = $args->{sort_by};
                $no_resort = 1;
            } elsif ($args->{limit} && ('score' eq $args->{sort_by} || 'rate' eq $args->{sort_by})) {
                $score_limit = delete($args->{limit}) || 0;
                $score_offset = delete($args->{offset}) || 0;
                if ( $score_limit || $score_offset ) {
                    delete $args->{lastn};
                }
                $no_resort = 0;
            }
        }

        if ( %fields ) {
            # specifies we need a join with entry_meta;
            # for now, we support one join
            my ( $col, $val ) = %fields;
            my $type = MT::Meta->metadata_by_name($class, 'field.' . $col);
            $args{join} = [ $class->meta_pkg, undef,
                { type => 'field.' . $col,
                  $type->{type} => $val,
                  'entry_id' => \'= entry_id' } ];
        }

        if (!@filters) {
            if ((my $last = $args->{lastn}) && (!exists $args->{limit})) {
                $args{direction} = 'descend';
                $args{sort} = 'authored_on';
                $args{limit} = $last;
                $no_resort = 0 if $args->{sort_by};
            } else {
                $args{direction} = $args->{sort_order} || 'descend'
                  if exists($args{sort});
                $no_resort = 1 unless $args->{sort_by};
                if ((my $last = $args->{lastn}) && (exists $args->{limit})) {
                    $args{limit} = $last;
                }
            }
            $args{offset} = $args->{offset} if $args->{offset};

            if ($args->{recently_commented_on}) {
                my $entries_iter = _rco_entries_iter(\%terms, \%args,
                    \%blog_terms, \%blog_args);
                my $limit = $args->{recently_commented_on};
                while (my $e = $entries_iter->()) {
                    push @entries, $e;
                    last unless --$limit;
                }
                $no_resort = $args->{sort_order} || $args->{sort_by} ? 0 : 1;
            } else {
                @entries = $class->load(\%terms, \%args);
            }
        } else {
            if (($args->{lastn}) && (!exists $args->{limit})) {
                $args{direction} = 'descend';
                $args{sort} = 'authored_on';
                $no_resort = 0 if $args->{sort_by};
            } else {
                $args{direction} = $args->{sort_order} || 'descend';
                $no_resort = 1 unless $args->{sort_by};
            }
            my $iter;
            if ($args->{recently_commented_on}) {
                $args->{lastn} = $args->{recently_commented_on};
                $iter = _rco_entries_iter(
                    \%terms, \%args, \%blog_terms, \%blog_args);
                $no_resort = $args->{sort_order} || $args->{sort_by} ? 0 : 1;
            } else {
                $iter = $class->load_iter(\%terms, \%args);
            }
            my $i = 0; my $j = 0;
            my $off = $args->{offset} || 0;
            my $n = $args->{lastn};
            ENTRY: while (my $e = $iter->()) {
                for (@filters) {
                    next ENTRY unless $_->($e);
                }
                next if $off && $j++ < $off;
                push @entries, $e;
                $i++;
                $iter->end, last if $n && $i >= $n;
            }
        }
    } else {
        # Don't resort a predefined list that's not in a published archive
        # page when we didn't request sorting.
        if ($args->{sort_by} || $args->{sort_order} || $ctx->{archive_type}) {
            my $so = $args->{sort_order} || ($blog ? $blog->sort_order_posts : undef) || '';
            my $col = $args->{sort_by} || 'authored_on';
            if ( $col ne 'score' ) {
                if (my $def = $class->column_def($col)) {
                    if ($def->{type} =~ m/^integer|float$/) {
                        @$entries = $so eq 'ascend' ?
                            sort { $a->$col() <=> $b->$col() } @$entries :
                            sort { $b->$col() <=> $a->$col() } @$entries;
                    } else {
                        @$entries = $so eq 'ascend' ?
                            sort { $a->$col() cmp $b->$col() } @$entries :
                            sort { $b->$col() cmp $a->$col() } @$entries;
                    }
                    $no_resort = 1;
                } elsif ($class->is_meta_column($col)) {
                    my $type = MT::Meta->metadata_by_name($class, $col);
                    no warnings;
                    if ($type->{type} =~ m/integer|float/) {
                        @$entries = $so eq 'ascend' ?
                            sort { $a->$col() <=> $b->$col() } @$entries :
                            sort { $b->$col() <=> $a->$col() } @$entries;
                    } else {
                        @$entries = $so eq 'ascend' ?
                            sort { $a->$col() cmp $b->$col() } @$entries :
                            sort { $b->$col() cmp $a->$col() } @$entries;
                    }
                    $no_resort = 1;
                }
            }
        } else {
            $no_resort = 1;
        }

        if (@filters) {
            my $i = 0; my $j = 0;
            my $off = $args->{offset} || 0;
            my $n = $args->{lastn};
            ENTRY2: foreach my $e (@$entries) {
                for (@filters) {
                    next ENTRY2 unless $_->($e);
                }
                next if $off && $j++ < $off;
                push @entries, $e;
                $i++;
                last if $n && $i >= $n;
            }
        } else {
            my $offset;
            if ($offset = $args->{offset}) {
                if ($offset < scalar @$entries) {
                    @entries = @$entries[$offset..$#$entries];
                } else {
                    @entries = ();
                }
            } else {
                @entries = @$entries;
            }
            if (my $last = $args->{lastn}) {
                if (scalar @entries > $last) {
                    @entries = @entries[0..$last-1];
                }
            }
        }
    }

    # $entries were on the stash or were just loaded
    # based on a start/end range.
    my $res = '';
    my $tok = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');
    if (!$no_resort && (scalar @entries)) {
        my $col = $args->{sort_by} || 'authored_on';
        if ('score' eq $col) {
            my $so = $args->{sort_order} || '';
            my %e = map { $_->id => $_ } @entries;
            my @eid = keys %e;
            require MT::ObjectScore;
            my $scores = MT::ObjectScore->sum_group_by(
                { 'object_ds' => $class_type, 'namespace' => $namespace, object_id => \@eid },
                { 'sum' => 'score', group => ['object_id'],
                  $so eq 'ascend' ? (direction => 'ascend') : (direction => 'descend'),
                });
            my @tmp;
            my $i = 0;
            while (my ($score, $object_id) = $scores->()) {
                $i++, next if $score_offset && $i < $score_offset;
                push @tmp, delete $e{ $object_id } if exists $e{ $object_id };
                $scores->end, last unless %e;
                $i++;
                $scores->end, last if $score_limit && (scalar @tmp) >= $score_limit;
            }

            if (!$score_limit || (scalar @tmp) < $score_limit) {
                foreach (values %e) {
                    if ($so eq 'ascend') {
                        unshift @tmp, $_;
                    } else {
                        push @tmp, $_;
                    }
                    last if $score_limit && (scalar @tmp) >= $score_limit;
                }
            }
            @entries = @tmp;
        } elsif ('rate' eq $col) {
            my $so = $args->{sort_order} || '';
            my %e = map { $_->id => $_ } @entries;
            my @eid = keys %e;
            require MT::ObjectScore;
            my $scores = MT::ObjectScore->avg_group_by(
                { 'object_ds' => $class_type, 'namespace' => $namespace, object_id => \@eid },
                { 'avg' => 'score', group => ['object_id'],
                  $so eq 'ascend' ? (direction => 'ascend') : (direction => 'descend'),
                });
            my @tmp;
            my $i = 0;
            while (my ($score, $object_id) = $scores->()) {
                $i++, next if $score_offset && $i < $score_offset;
                push @tmp, delete $e{ $object_id } if exists $e{ $object_id };
                $scores->end, last unless %e;
                $i++;
                $scores->end, last if $score_limit && (scalar @tmp) >= $score_limit;
            }
            if (!$score_limit || (scalar @tmp) < $score_limit) {
                foreach (values %e) {
                    if ($so eq 'ascend') {
                        unshift @tmp, $_;
                    } else {
                        push @tmp, $_;
                    }
                    last if $score_limit && (scalar @tmp) >= $score_limit;
                }
            }
            @entries = @tmp;
        } else {
            my $so = $args->{sort_order} || ($blog ? $blog->sort_order_posts : 'descend') || '';
            if (my $def = $class->column_def($col)) {
                if ($def->{type} =~ m/^integer|float$/) {
                    @entries = $so eq 'ascend' ?
                        sort { $a->$col() <=> $b->$col() } @entries :
                        sort { $b->$col() <=> $a->$col() } @entries;
                } else {
                    @entries = $so eq 'ascend' ?
                        sort { $a->$col() cmp $b->$col() } @entries :
                        sort { $b->$col() cmp $a->$col() } @entries;
                }
            } elsif ($class->is_meta_column($col)) {
                my $type = MT::Meta->metadata_by_name($class, $col);
                no warnings;
                if ($type->{type} =~ m/integer|float/) {
                    @entries = $so eq 'ascend' ?
                        sort { $a->$col() <=> $b->$col() } @entries :
                        sort { $b->$col() <=> $a->$col() } @entries;
                } else {
                    @entries = $so eq 'ascend' ?
                        sort { $a->$col() cmp $b->$col() } @entries :
                        sort { $b->$col() cmp $a->$col() } @entries;
                }
            }
        }
    }
    my($last_day, $next_day) = ('00000000') x 2;
    my $i = 0;
    local $ctx->{__stash}{entries} = (@entries && defined $entries[0]) ? \@entries: undef;
    my $glue = $args->{glue};
    my $vars = $ctx->{__stash}{vars} ||= {};
    for my $e (@entries) {
        local $vars->{__first__} = !$i;
        local $vars->{__last__} = !defined $entries[$i+1];
        local $vars->{__odd__} = ($i % 2) == 0; # 0-based $i
        local $vars->{__even__} = ($i % 2) == 1;
        local $vars->{__counter__} = $i+1;
        local $ctx->{__stash}{blog} = $e->blog;
        local $ctx->{__stash}{blog_id} = $e->blog_id;
        local $ctx->{__stash}{entry} = $e;
        local $ctx->{current_timestamp} = $e->authored_on;
        local $ctx->{modification_timestamp} = $e->modified_on;
        my $this_day = substr $e->authored_on, 0, 8;
        my $next_day = $this_day;
        my $footer = 0;
        if (defined $entries[$i+1]) {
            $next_day = substr($entries[$i+1]->authored_on, 0, 8);
            $footer = $this_day ne $next_day;
        } else { $footer++ }
        my $allow_comments ||= 0;
        $published->{$e->id}++;
        my $out = $builder->build($ctx, $tok, {
            %$cond,
            DateHeader => ($this_day ne $last_day),
            DateFooter => $footer,
            EntriesHeader => !$i,
            EntriesFooter => !defined $entries[$i+1],
            PagesHeader => !$i,
            PagesFooter => !defined $entries[$i+1],
        });
        return $ctx->error( $builder->errstr ) unless defined $out;
        $last_day = $this_day;
        $res .= $glue if defined $glue && $i && length($res) && length($out);
        $res .= $out;
        $i++;
    }
    if (!@entries) {
        return _hdlr_pass_tokens_else(@_);
    }

    $res;
}

###########################################################################

=head2 DateHeader

A container tag whose contents will be displayed if the entry in context
was posted on a new day in the list.

B<Example:>

    <mt:Entries>
        <mt:DateHeader>
            <h2><$mt:EntryDate format="%A, %B %e, %Y"$></h2>
        </mt:DateHeader>
        <!-- display entry here -->
    </mt:Entries>

=for tags entries

=cut

###########################################################################

=head2 DateFooter

A container tag whose contents will be displayed if the entry in context
is the last entry in the group of entries for a given day.

B<Example:>

    <mt:Entries>
        <!-- display entry here -->
        <mt:DateFooter>
            <hr />
        </mt:DateFooter>
    </mt:Entries>

=for tags entries

=cut

###########################################################################

=head2 EntriesHeader

The contents of this container tag will be displayed when the first
entry listed by a L<Entries> tag is reached.

=for tags entries

=cut

###########################################################################

=head2 EntriesFooter

The contents of this container tag will be displayed when the last
entry listed by a L<Entries> tag is reached.

=for tags entries

=cut

###########################################################################

=head2 PagesHeader

The contents of this container tag will be displayed when the first page
listed by a L<Pages> tag is reached.

B<Example:>

    <mt:Pages glue=", ">
        <mt:PagesHeader>
            The following pages are available:
        </mt:PagesHeader>
        <a href="<$mt:PagePermalink$>"><$mt:PageTitle$></a>
    </mt:Pages>

=for tags pages

=cut

###########################################################################

=head2 PagesFooter

The contents of this container tag will be displayed when the last page
listed by a L<Pages> tag is reached.

=for tags pages

=cut

# returns an iterator that supplies entries, in the order of last comment
# date (descending)
sub _rco_entries_iter {
    my ($entry_terms, $entry_args, $blog_terms, $blog_args) = @_;

    my $offset = 0;
    my $limit = $entry_args->{limit} || 20;
    my @entries;
    delete $entry_args->{direction}
        if exists $entry_args->{direction};
    delete $entry_args->{sort}
        if exists $entry_args->{sort};

    my $rco_iter = sub {
        if (! @entries) {
            require MT::Comment;
            my $iter = MT::Comment->max_group_by({
                visible => 1,
                %$blog_terms,
            }, {
                join => MT::Entry->join_on(undef,
                    {
                        'id' => \'=comment_entry_id',
                        %$entry_terms,
                    }, { %$entry_args }),
                %$blog_args,
                group => ['entry_id'],
                max => 'created_on',
                offset => $offset,
                limit => $limit,
            });
            my @ids;
            my %order;
            my $num = 0;
            while (my ($max, $id) = $iter->()) {
                push @ids, $id;
                $order{$id} = $num++;
            }
            if ( @ids ) {
                @entries = MT::Entry->load({ id => \@ids });
                @entries = sort { $order{$a->id} <=> $order{$b->id} } @entries;
            }
        }
        if ( @entries ) {
            $offset++;
            return shift @entries;
        } else {
            return undef;
        }
    };
    return Data::ObjectDriver::Iterator->new($rco_iter);
}

###########################################################################

=head2 EntriesCount

Returns the count of a list of entries that are currently in context
(ie: used in an archive template, or inside an L<Entries> tag). If no
entry list context exists, it will fallback to the list that would be
selected for a generic L<Entries> tag (respecting number of days or
entries configured to publish on the blog's main index template).

=for tags count

=cut

sub _hdlr_entries_count {   
    my ($ctx, $args, $cond) = @_;   
    my $e = $ctx->stash('entries');   

    my $count;
    if ($e) {
        $count = scalar @$e;
    } else {
        my $class_type = $args->{class_type} || 'entry';
        my $class = MT->model($class_type);
        my $cat_class = MT->model(
            $class_type eq 'entry' ? 'category' : 'folder');

        my (%terms, %args);
        my $blog_id = $ctx->stash('blog_id');

        use MT::Entry;
        $terms{blog_id} = $blog_id;
        $terms{status} = MT::Entry::RELEASE();
        my ($days, $limit);
        my $blog = $ctx->stash('blog');
        if ($blog && ($days = $blog->days_on_index)) {
            my @ago = offset_time_list(time - 3600 * 24 * $days,
                $ctx->stash('blog_id'));
            my $ago = sprintf "%04d%02d%02d%02d%02d%02d",
                $ago[5]+1900, $ago[4]+1, @ago[3,2,1,0];
            $terms{authored_on} = [ $ago ];
            $args{range_incl}{authored_on} = 1;
        } elsif ($blog && ($limit = $blog->entries_on_index)) {
            $args->{lastn} = $limit;
        }
        $args{'sort'} = 'authored_on';
        $args{direction} = 'descend';

        my $iter = $class->load_iter(\%terms, \%args);
        my $i = 0;
        my $last = $args->{lastn};
        while (my $entry = $iter->()) {
            if ($last && $last <= $i) {
               return $i;
            }
            $i++;
        }
        $count = $i;
    }
    return $ctx->count_format($count, $args);
}  

###########################################################################

=head2 EntryBody

Outputs the "main" text of the current entry in context.

B<Attributes:>

=over 4

=item * convert_breaks (optional; default "1")

Accepted values are '0' and '1'. Typically, this attribute is
used to disable (with a value of '0') the processing of the entry
text based on the text formatting option for the entry.

=item * words (optional)

Accepts any positive integer to limit the number of words
that are output.

=back

=cut

sub _hdlr_entry_body {
    my ($ctx, $args) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $text = $e->text;
    $text = '' unless defined $text;

    # Strip the mt:asset-id attribute from any span tags...
    if ($text =~ m/\smt:asset-id="\d+"/) {
        $text = asset_cleanup($text);
    }

    my $blog = $ctx->stash('blog');
    my $convert_breaks = exists $args->{convert_breaks} ?
        $args->{convert_breaks} :
            defined $e->convert_breaks ? $e->convert_breaks :
                ( $blog ? $blog->convert_paras : '__default__' );
    if ($convert_breaks) {
        my $filters = $e->text_filters;
        push @$filters, '__default__' unless @$filters;
        $text = MT->apply_text_filters($text, $filters, $ctx);
    }
    return first_n_text($text, $args->{words}) if exists $args->{words};

    return $text;
}

###########################################################################

=head2 EntryMore

Outputs the "extended" text of the current entry in context. Refer to the
L<EntryBody> tag for supported attributes.

=cut

sub _hdlr_entry_more {
    my ($ctx, $args) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $text = $e->text_more;
    $text = '' unless defined $text;

    # Strip the mt:asset-id attribute from any span tags...
    if ($text =~ m/\smt:asset-id="\d+"/) {
        $text = asset_cleanup($text);
    }

    my $blog = $ctx->stash('blog');
    my $convert_breaks = exists $args->{convert_breaks} ?
        $args->{convert_breaks} :
            defined $e->convert_breaks ? $e->convert_breaks :
                ($blog ? $blog->convert_paras : '__default__');
    if ($convert_breaks) {
        my $filters = $e->text_filters;
        push @$filters, '__default__' unless @$filters;
        $text = MT->apply_text_filters($text, $filters, $ctx);
    }
    return first_n_text($text, $args->{words}) if exists $args->{words};

    return $text;
}

###########################################################################

=head2 EntryTitle

Outputs the title of the current entry in context.

B<Attributes:>

=over 4

=item * generate (optional)

If specified, will draw content from the "main" text field of
the entry if the title is empty.

=back

=cut

sub _hdlr_entry_title {
    my ($ctx, $args) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $title = defined $e->title ? $e->title : '';
    $title = first_n_text($e->text, const('LENGTH_ENTRY_TITLE_FROM_TEXT'))
        if !$title && $args->{generate};
    return $title;
}

###########################################################################

=head2 EntryStatus

Intended for application template use only. Displays the status of the
entry in context. This will output one of "Draft", "Publish", "Review"
or "Future".

=cut

sub _hdlr_entry_status {
    my ($ctx) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    return MT::Entry::status_text($e->status);
}

###########################################################################

=head2 EntryDate

Outputs the 'authored' date of the current entry in context.
See the L<Date> tag for supported attributes.

=for tags date

=cut

sub _hdlr_entry_date {
    my ($ctx, $args) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    $args->{ts} = $e->authored_on;
    return _hdlr_date($ctx, $args);
}

###########################################################################

=head2 EntryCreatedDate

Outputs the creation date of the current entry in context.
See the L<Date> tag for supported attributes.

=for tags date

=cut

sub _hdlr_entry_create_date {
    my ($ctx, $args) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    $args->{ts} = $e->created_on;
    return _hdlr_date($ctx, $args);
}

###########################################################################

=head2 EntryModifiedDate

Outputs the modification date of the current entry in context.
See the L<Date> tag for supported attributes.

=for tags date

=cut

sub _hdlr_entry_mod_date {
    my ($ctx, $args) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    $args->{ts} = $e->modified_on || $e->created_on;
    return _hdlr_date($ctx, $args);
}

###########################################################################

=head2 EntryFlag

Used to output any of the status fields for the current entry in
context.

B<Attributes:>

=over 4

=item * flag (required)

Accepts one of: 'allow_pings', 'allow_comments'.

=back

=cut

sub _hdlr_entry_flag {
    my ($ctx, $args) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $flag = lc $args->{flag}
        or return $ctx->error(MT->translate(
            'You used <$MTEntryFlag$> without a flag.' ));
    my $v = $e->$flag();
    ## The logic here: when we added the convert_breaks flag, we wanted it
    ## to default to checked, because we added it in 2.0, and people had
    ## previously been using the global convert_paras setting, so we needed
    ## that to be used if it wasn't defined. So that's the reason for the
    ## second test (else) (should we be looking at blog->convert_paras?).
    ## When we added allow_pings, we only want this to be applied if
    ## explicitly checked.
    if ($flag eq 'allow_pings') {
        return defined $v ? $v : 0;
    } else {
        return defined $v ? $v : 1;
    }
}

###########################################################################

=head2 EntryExcerpt

Ouputs the value of the excerpt field of the current entry in context.
If the excerpt field is empty, it will draw from the main text of the
entry to generate an excerpt.

B<Attributes:>

=over 4

=item * no_generate (optional)

If the excerpt field is empty, this flag will prevent the generation
of an excerpt using the main text of the entry.

=item * words (optional; default "40")

Controls the length of the auto-generated entry excerpt. Does B<not>
limit the content when the excerpt field contains content.

=item * convert_breaks (optional; default "0")

When set to '1', applies the text formatting filters on the excerpt
content.

=back

=cut

sub _hdlr_entry_excerpt {
    my($ctx, $args) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    if (my $excerpt = $e->excerpt) {
        return $excerpt unless $args->{convert_breaks};
        my $filters = $e->text_filters;
        push @$filters, '__default__' unless @$filters;
        return MT->apply_text_filters($excerpt, $filters, $ctx);
    } elsif ($args->{no_generate}) {
        return '';
    }
    my $blog = $ctx->stash('blog');
    my $words = $args->{words} || $blog ? $blog->words_in_excerpt : 40;
    my $excerpt = _hdlr_entry_body($ctx, { words => $words, %$args });
    return '' unless $excerpt;
    return $excerpt . '...';
}

###########################################################################

=head2 EntryKeywords

Outputs the value of the keywords field for the current entry in context.

=cut

sub _hdlr_entry_keywords {
    my ($ctx) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    return defined $e->keywords ? $e->keywords : '';
}

###########################################################################

=head2 EntryAuthor

Outputs the username of the author for the current entry in context.
B<This tag is considered deprecated in favor of
L<EntryAuthorDisplayName>. It is not recommended to publish MT
usernames.>

=for tags deprecated

=cut

# FIXME: This should be a container tag providing an author
# context for the entry in context.
sub _hdlr_entry_author {
    my ($ctx) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $a = $e->author;
    return $a ? $a->name || '' : '';
}

###########################################################################

=head2 EntryAuthorDisplayName

Outputs the display name of the author for the current entry in context.
If the author has not provided a display name for publishing, this tag
will output an empty string.

=cut

sub _hdlr_entry_author_display_name {
    my ($ctx) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $a = $e->author;
    return $a ? $a->nickname || '' : '';
}

###########################################################################

=head2 EntryAuthorNickname

An alias of L<EntryAuthorDisplayName>. B<This tag is deprecated in
favor of L<EntryAuthorDisplayName>.>

=for tags deprecated

=cut

sub _hdlr_entry_author_nick {
    my ($ctx) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $a = $e->author;
    return $a ? $a->nickname || '' : '';
}

###########################################################################

=head2 EntryAuthorUsername

Outputs the username of the author for the entry currently in context.
B<NOTE: it is not recommended to publish MT usernames.>

=cut

sub _hdlr_entry_author_username {
    my ($ctx) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $a = $e->author;
    return $a ? $a->name || '' : '';
}

###########################################################################

=head2 EntryAuthorEmail

Outputs the email address of the author for the current entry in context.
B<NOTE: it is not recommended to publish e-mail addresses for MT users.>

B<Attributes:>

=over 4

=item * spam_protect (optional; default "0")

If specified, this will apply a light obfuscation of the email address,
by encoding any characters that will identify it as an email address
(C<:>, C<@>, and C<.>) into HTML entities.

=back

=cut

sub _hdlr_entry_author_email {
    my ($ctx, $args) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $a = $e->author;
    return '' unless $a && defined $a->email;
    return $args && $args->{'spam_protect'} ? spam_protect($a->email) : $a->email;
}

###########################################################################

=head2 EntryAuthorURL

Outputs the Website URL field from the author's profile for the
current entry in context.

=cut

sub _hdlr_entry_author_url {
    my($ctx, $args) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $a = $e->author;
    return $a ? $a->url || "" : "";
}

###########################################################################

=head2 EntryAuthorLink

Outputs a linked author name suitable for publishing in the 'byline'
of an entry.

B<Attributes:>

=over 4

=item * new_window

If specified, the published link is given a C<target> attribute of '_blank'.

=item * show_email (optional; default "0")

If set, will allow publishing of an email address if the URL field
for the author is empty.

=item * spam_protect (optional)

If specified, this will apply a light obfuscation of any email address
published, by encoding any characters that will identify it as an email
address (C<:>, C<@>, and C<.>) into HTML entities.

=item * type (optional)

Accepted values: C<url>, C<email>, C<archive>. Note: an 'archive' type
requires publishing of "Author" archives.

=item * show_hcard (optional; default "0")

If present, adds additional CSS class names to the link tag published,
identifying the link as a url or email address depending on the type of
link published.

=back

=cut

sub _hdlr_entry_author_link {
    my ($ctx, $args, $cond) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $a = $e->author;
    return '' unless $a;

    my $type = $args->{type} || '';

    my $displayname = $a->nickname || '';
    my $show_email = $args->{show_email} ? 1 : 0;
    my $show_url = 1 unless exists $args->{show_url} && !$args->{show_url};
    # Open the link in a new window if requested (with new_window="1").
    my $target = $args->{new_window} ? ' target="_blank"' : '';
    unless ($type) {
        if ($show_url && $a->url && ($displayname ne '')) {
            $type = 'url';
        } elsif ($show_email && $a->email && ($displayname ne '')) {
            $type = 'email';
        }
    }
    if ($type eq 'url') {
        if ($a->url && ($displayname ne '')) {
            # Add vcard properties to link if requested (with hcard="1")
            my $hcard = $args->{show_hcard} ? ' class="fn url"' : '';
            return sprintf qq(<a%s href="%s"%s>%s</a>), $hcard, $a->url, $target, $displayname;
        }
    } elsif ($type eq 'email') {
        if ($a->email && ($displayname ne '')) {
            # Add vcard properties to email if requested (with hcard="1")
            my $hcard = $args->{show_hcard} ? ' class="fn email"' : '';
            my $str = "mailto:" . $a->email;
            $str = spam_protect($str) if $args->{'spam_protect'};
            return sprintf qq(<a%s href="%s">%s</a>), $hcard, $str, $displayname;
        }
    } elsif ($type eq 'archive') {
        require MT::Author;
        if ($a->type == MT::Author::AUTHOR()) {
            local $ctx->{__stash}{author} = $a;
            if (my $link = _hdlr_archive_link($ctx, { type => 'Author' }, $cond)) {
                return sprintf qq{<a href="%s"%s>%s</a>}, $link, $target, $displayname;
            }
        }
    }
    return $displayname;
}

###########################################################################

=head2 EntryAuthorID

Outputs the numeric ID of the author for the current entry in context.

=cut

sub _hdlr_entry_author_id {
    my ($ctx) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $a = $e->author;
    return $a ? $a->id || '' : '';
}

###########################################################################

=head2 EntryAuthorUserpic

Outputs the HTML for the userpic of the author for the current entry
in context.

=cut

sub _hdlr_entry_author_userpic {
    my ($ctx) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $a = $e->author or return '';
    return $a->userpic_html() || '';
}

###########################################################################

=head2 EntryAuthorUserpicURL

Outputs the URL for the userpic image of the author for the current entry
in context.

=cut

sub _hdlr_entry_author_userpic_url {
    my ($ctx) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $a = $e->author or return '';
    return $a->userpic_url() || '';
}

###########################################################################

=head2 EntryAuthorUserpicAsset

A block tag providing an asset context for the userpic of the
author for the current entry in context. See the L<Assets> tag
for more information about publishing assets.

=cut

sub _hdlr_entry_author_userpic_asset {
    my ($ctx, $args, $cond) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $author = $e->author;
    return '' unless $author;

    my $asset = $author->userpic or return '';

    my $tok = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');

    local $ctx->{__stash}{asset} = $asset;
    return $builder->build($ctx, $tok, { %$cond });
}

###########################################################################

=head2 EntryID

Ouptuts the numeric ID for the current entry in context.

=cut

sub _hdlr_entry_id {
    my ($ctx, $args) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    return $args && $args->{pad} ? (sprintf "%06d", $e->id) : $e->id;
}

###########################################################################

=head2 EntryTrackbackLink

Outputs the TrackBack endpoint for the current entry in context.
If TrackBack is not enabled for the entry, this will output
an empty string.

=cut

sub _hdlr_entry_tb_link {
    my ($ctx, $args, $cond) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $tb = $e->trackback
        or return '';
    my $cfg = $ctx->{config};
    my $path = _hdlr_cgi_path($ctx);
    $path . $cfg->TrackbackScript . '/' . $tb->id;
}

###########################################################################

=head2 EntryTrackbackData

Outputs the TrackBack RDF block that allows for TrackBack
autodiscovery to take place. If TrackBack is not enabled
for the entry, this will output an empty string.

B<Attributes:>

=over 4

=item * comment_wrap (optional; default "1")

If enabled, will enclose the RDF markup inside an HTML
comment tag.

=item * with_index (optional; default "0")

If specified, will leave any "index.html" (or appropriate index
page filename) in the permalink of the entry in context. By default
this portion of the permalink is removed, since it is usually
unnecessary.

=back

=cut

sub _hdlr_entry_tb_data {
    my($ctx, $args) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    return '' unless $e->allow_pings;
    my $blog = $ctx->stash('blog');
    my $cfg = $ctx->{config};
    return '' unless $blog->allow_pings && $cfg->AllowPings;
    my $tb = $e->trackback or return '';
    return '' if $tb->is_disabled;
    my $path = _hdlr_cgi_path($ctx);
    $path .= $cfg->TrackbackScript . '/' . $tb->id;
    my $url;
    if (my $at = $ctx->{current_archive_type} || $ctx->{archive_type}) {
        $url = $e->archive_url($at);
        $url .= '#entry-' . sprintf("%06d", $e->id)
            unless $at eq 'Individual';
    } else {
        $url = $e->permalink;
        $url = MT::Util::strip_index($url, $ctx->stash('blog')) unless $args->{with_index};
    }
    my $rdf = '';
    my $comment_wrap = defined $args->{comment_wrap} ?
        $args->{comment_wrap} : 1;
    $rdf .= "<!--\n" if $comment_wrap;
    ## SGML comments cannot contain double hyphens, so we convert
    ## any double hyphens to single hyphens.
    my $strip_hyphen = sub {
        return unless defined $_[0];
        (my $s = $_[0]) =~ tr/\-//s;
        $s;
    };
    $rdf .= <<RDF;
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:trackback="http://madskills.com/public/xml/rss/module/trackback/"
         xmlns:dc="http://purl.org/dc/elements/1.1/">
<rdf:Description
    rdf:about="$url"
    trackback:ping="$path"
    dc:title="@{[ encode_xml($strip_hyphen->($e->title), 1) ]}"
    dc:identifier="$url"
    dc:subject="@{[ encode_xml($e->category ? $e->category->label : '', 1) ]}"
    dc:description="@{[ encode_xml($strip_hyphen->(_hdlr_entry_excerpt(@_)), 1) ]}"
    dc:creator="@{[ encode_xml(_hdlr_entry_author_display_name(@_), 1) ]}"
    dc:date="@{[ _hdlr_date($ctx, { 'ts' => $e->authored_on, 'format' => "%Y-%m-%dT%H:%M:%S" }) .
                 _hdlr_blog_timezone($ctx) ]}" />
</rdf:RDF>
RDF
    $rdf .= "-->\n" if $comment_wrap;
    $rdf;
}

###########################################################################

=head2 EntryTrackbackID

Outputs the numeric ID of the TrackBack for the current entry in context.
If not TrackBack is not enabled for the entry, this outputs an empty string.

=cut

sub _hdlr_entry_tb_id {
    my($ctx, $args) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $tb = $e->trackback
        or return '';
    $tb->id;
}

###########################################################################

=head2 EntryLink

Outputs the URL for the current entry in context.

B<Attributes:>

=over 4

=item * type (optional)

=item * archive_type (optional)

Identifies the archive type to use when creating the link. For instance,
to link to the appropriate Monthly archive for the current entry (assuming
Monthly archives are published), you can use this:

    <$MTEntryLink type="Monthly"$>

or to link to other entries by the current author (assuming Author
archives are published):

    <$MTEntryLink type="Author"$>

=back

=cut

sub _hdlr_entry_link {
    my ($ctx, $args) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $blog = $ctx->stash('blog');
    my $arch = $blog->archive_url || '';
    $arch = $blog->site_url if $e->class eq 'page';
    $arch .= '/' unless $arch =~ m!/$!;

    my $at = $args->{type} || $args->{archive_type};
    if ($at) {
        return $ctx->error(MT->translate(
            "You used an [_1] tag for linking into '[_2]' archives, but that archive type is not published.", '<$MTEntryLink$>', $at))
            unless $blog->has_archive_type($at);
    }
    my $archive_filename = $e->archive_file($at
                                            ? $at : ());
    if ($archive_filename) {
        my $link = $arch . $archive_filename;
        $link = MT::Util::strip_index($link, $blog) unless $args->{with_index};
        $link;
    } else { return "" }
}

###########################################################################

=head2 EntryBasename

Outputs the basename field for the current entry in context.

B<Attributes:>

=over 4

=item * separator (optional)

Accepts either "-" or "_". If unspecified, the raw basename value is
returned.

=back

=cut

sub _hdlr_entry_basename {
    my ($ctx, $args) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $basename = $e->basename() || '';
    if (my $sep = $args->{separator}) {
        if ($sep eq '-') {
            $basename =~ s/_/-/g;
        } elsif ($sep eq '_') {
            $basename =~ s/-/_/g;
        }
    }
    return $basename;
}

###########################################################################

=head2 EntryAtomID

Outputs the unique Atom ID for the current entry in context.

=cut

sub _hdlr_entry_atom_id {
    my ($ctx, $args, $cond) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    return $e->atom_id() || $e->make_atom_id() || $ctx->error(MT->translate("Could not create atom id for entry [_1]", $e->id));
}

###########################################################################

=head2 EntryPermalink

An absolute URL pointing to the archive page containing this entry. An
anchor (#) is included if the permalink is not pointing to an Individual
Archive page.

Most of the time, you'll want to use this inside a hyperlink. So, inside
any L<Entries> loop, you can make a link to an entry like this:

    <a href="<$mt:EntryPermalink$>"><$mt:EntryTitle$></a>

B<Attributes:>

=over 4

=item * type or archive_type (optional)

Specifies an alternative archive type to use instead of the individual
archive.

=item * valid_html (optional; default "0")

When publishing entry permalinks for non-individual archive templates, an
anchor must be appended to the URL for the link to point to the
proper entry within that archive. If 'valid_html' is unspecified,
the anchor name is simply a number-- the ID of the entry. If specified,
an 'a' is prepended to the number so the anchor name is considered
valid HTML.

=item * with_index (optional; default "0")

If assigned, will retain any index filename at the end of the permalink.

=back

=cut

sub _hdlr_entry_permalink {
    my ($ctx, $args) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $blog = $ctx->stash('blog');
    my $at = $args->{type} || $args->{archive_type};
    if ($at) {
        return $ctx->error(MT->translate(
            "You used an [_1] tag for linking into '[_2]' archives, but that archive type is not published.", '<$MTEntryPermalink$>', $at))
            unless $blog->has_archive_type($at);
    }
    my $link = $e->permalink($args ? $at : undef, 
                  { valid_html => $args->{valid_html} }) or return $ctx->error($e->errstr);
    $link = MT::Util::strip_index($link, $blog) unless $args->{with_index};
    $link;
}

###########################################################################

=head2 EntryClass

Pages and entries are technically very similar to one another. In fact
most, if not all, of the C<<mt:Entry*>> tags will work for publishing pages
and vice versa. Therefore, to more clearly differentiate within
templates between pages and entries the <mt:EntryClass> tag returns one of
two values: "page" or "entry" depending upon the current context you are
in.

B<Example:>

    <mt:If tag="EntryClass" eq="page">
        (we're publishing a page)
    <mt:Else>
        (we're publishing something else -- probably an entry)
    </mt:If>

=cut

sub _hdlr_entry_class {
    my ($ctx, $args) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    $e->class;
}

###########################################################################

=head2 EntryClassLabel

Returns the localized name of the type of entry being published.
For English blogs, this is the word "Page" or "Entry".

B<Example:>

    <$mt:EntryClassLabel$>

=cut

sub _hdlr_entry_class_label {
    my ($ctx, $args) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    $e->class_label;
}

###########################################################################

=head2 EntryCategory

This tag outputs the main category for the entry. Must be used in an
entry context (entry archive or L<Entries> loop).

All categories can be listed using L<EntryCategories> loop tag.

=cut

sub _hdlr_entry_category {
    my($ctx, $args, $cond) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $cat = $e->category;
    return '' unless $cat;
    local $ctx->{__stash}{category} = $e->category;
    &_hdlr_category_label;
}

###########################################################################

=head2 EntryCategories

A container tag that lists all of the categories (primary and secondary)
to which the entry is assigned. This tagset creates a category context
within which any category or subcategory tags may be used.

B<Attributes:>

=over 4

=item * glue (optional)

If specified, this string is placed in between each result from the loop.

=back

=cut

sub _hdlr_entry_categories {
    my($ctx, $args, $cond) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $cats = $e->categories;
    return '' unless $cats && @$cats;
    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');
    my $res = '';
    my $glue = $args->{glue};
    local $ctx->{inside_mt_categories} = 1;
    for my $cat (@$cats) {
        local $ctx->{__stash}->{category} = $cat;
        defined(my $out = $builder->build($ctx, $tokens, $cond))
            or return $ctx->error( $builder->errstr );
        $res .= $glue if defined $glue && length($res) && length($out);
        $res .= $out;
    }
    $res;
}

###########################################################################

=head2 TypeKeyToken

Outputs the configured TypeKey token for the current blog in context.
If the blog has not been configured to use TypeKey, this will output
an empty string.

=cut

sub _hdlr_typekey_token {
    my ($ctx, $args, $cond) = @_;

    my $blog_id = $ctx->stash('blog_id');
    my $blog = MT::Blog->load($blog_id)
        or return $ctx->error(MT->translate('Can\'t load blog #[_1].', $blog_id));
    my $tp_token = $blog->effective_remote_auth_token();
    return $tp_token;
}

###########################################################################

=head2 SignInLink

Outputs a link to the MT Comment script to allow a user to sign in
to comment on the blog.

=cut

sub _hdlr_sign_in_link {
    my ($ctx, $args) = @_;    
    my $cfg = $ctx->{config};
    my $blog = $ctx->stash('blog');
    my $path = _hdlr_cgi_path($ctx);
    $path .= '/' unless $path =~ m!/$!;
    my $comment_script = $cfg->CommentScript;
    my $static_arg = $args->{static} ? "&static=" . $args->{static} : '';
    my $e = $ctx->stash('entry');
    return "$path$comment_script?__mode=login$static_arg" .
        ($blog ? '&blog_id=' . $blog->id : '') .
        ($e ? '&entry_id=' . $e->id : '');
}

###########################################################################

=head2 SignOutLink

Outputs a link to the MT Comment script to allow a signed-in user to
sign out from the blog.

=cut

sub _hdlr_sign_out_link {
    my ($ctx, $args) = @_;
    my $cfg = $ctx->{config};
    my $path = _hdlr_cgi_path($ctx);
    $path .= '/' unless $path =~ m!/$!;
    my $comment_script = $cfg->CommentScript;
    my $static_arg;
    if ($args->{no_static}) {
        $static_arg = q();
    } else {
        my $url = $args->{static};
        if ($url && ($url ne '1')) {
            $static_arg = "&static=" . MT::Util::encode_url($url);
        } elsif ($url) {
            $static_arg = "&static=1";
        } else {
            $static_arg = "&static=0";
        }
    }
    my $e = $ctx->stash('entry');
    return "$path$comment_script?__mode=handle_sign_in$static_arg&logout=1" .
        ($e ? "&amp;entry_id=" . $e->id : '');
}

###########################################################################

=head2 RemoteSignInLink

Outputs a link to the MT Comment script to allow signing in to a TypeKey
configured blog. B<NOTE: This is deprecated in favor of L<SignInLink>.>

=for tags deprecated

=cut

sub _hdlr_remote_sign_in_link {
    my ($ctx, $args) = @_;
    my $cfg = $ctx->{config};
    my $blog = $ctx->stash('blog_id');
    $blog = MT::Blog->load($blog)
        if defined $blog && !(ref $blog);
    return $ctx->error(MT->translate('Can\'t load blog #[_1].', $ctx->stash('blog_id'))) unless $blog;
    my $auths = $blog->commenter_authenticators;
    return $ctx->error(MT->translate("TypeKey authentication is not enabled in this blog.  MTRemoteSignInLink can't be used."))
        if $auths !~ /TypeKey/;
    
    my $rem_auth_token = $blog->effective_remote_auth_token();
    return $ctx->error(MT->translate("To enable comment registration, you need to add a TypeKey token in your weblog config or user profile."))
        unless $rem_auth_token;
    my $needs_email = $blog->require_typekey_emails ? "&amp;need_email=1" : "";
    my $signon_url = $cfg->SignOnURL;
    my $path = _hdlr_cgi_path($ctx);
    my $comment_script = $cfg->CommentScript;
    my $static_arg = $args->{static} ? "static=" . $args->{static} : "static=0";
    my $e = $ctx->stash('entry');
    my $tk_version = $cfg->TypeKeyVersion ? "&amp;v=" . $cfg->TypeKeyVersion : "";
    my $language = "&amp;lang=" . ($args->{lang} || $cfg->DefaultLanguage || $blog->language);
    return "$signon_url$needs_email$language&amp;t=$rem_auth_token$tk_version&amp;_return=$path$comment_script%3f__mode=handle_sign_in%26key=TypeKey%26$static_arg" .
        ($e ? "%26entry_id=" . $e->id : '');
}

###########################################################################

=head2 RemoteSignOutLink

Outputs a link to the MT Comment script to allow a user to sign out from
a blog. B<NOTE: This tag is deprecated in favor of L<SignOutLink>.>

=for tags deprecated

=cut

sub _hdlr_remote_sign_out_link {
    my ($ctx, $args) = @_;
    my $cfg = $ctx->{config};
    my $path = _hdlr_cgi_path($ctx);
    my $comment_script = $cfg->CommentScript;
    my $static_arg;
    if ($args->{no_static}) {
        $static_arg = q();
    } else {
        my $url = $args->{static};
        if ($url && ($url ne '1')) {
            $static_arg = "&amp;static=" . MT::Util::encode_url($url);
        } elsif ($url) {
            $static_arg = "&amp;static=1";
        } else {
            $static_arg = "&amp;static=0";
        }
    }
    my $e = $ctx->stash('entry');
    "$path$comment_script?__mode=handle_sign_in$static_arg&amp;logout=1" .
        ($e ? "&amp;entry_id=" . $e->id : '');
}

###########################################################################

=head2 CommentFields

A deprecated tag that formerly published an entry comment form.

=for tags deprecated

=cut

sub _hdlr_comment_fields {
    my ($ctx, $args, $cond) = @_;
    return $ctx->error(MT->translate("The MTCommentFields tag is no longer available; please include the [_1] template module instead.", MT->translate("Comment Form")));
}

###########################################################################

=head2 EntryCommentCount

Outputs the number of published comments for the current entry in context.

=cut

sub _hdlr_entry_comments {
    my ($ctx, $args, $cond) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $count = $e->comment_count;
    return $ctx->count_format($count, $args);
}

###########################################################################

=head2 EntryTrackbackCount

Outputs the number of published TrackBack pings for the current entry in
context.

=cut

sub _hdlr_entry_ping_count {
    my ($ctx, $args, $cond) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $count = $e->ping_count;
    return $ctx->count_format($count, $args);
}

###########################################################################

=head2 EntryPrevious

A block tag providing a context for the entry immediately preceding the
current entry in context (in terms of authored date).

=cut

sub _hdlr_entry_previous {
    _hdlr_entry_nextprev('previous', @_);
}

###########################################################################

=head2 EntryNext

A block tag providing a context for the entry immediately following the
current entry in context (in terms of authored date).

=cut

sub _hdlr_entry_next {
    _hdlr_entry_nextprev('next', @_);
}

sub _hdlr_entry_nextprev {
    my($meth, $ctx, $args, $cond) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $terms = { status => MT::Entry::RELEASE() };
    $terms->{by_author} = 1 if $args->{by_author};
    $terms->{by_category} = 1 if $args->{by_category};
    my $entry = $e->$meth($terms);
    my $res = '';
    if ($entry) {
        my $builder = $ctx->stash('builder');
        local $ctx->{__stash}->{entry} = $entry;
        local $ctx->{current_timestamp} = $entry->authored_on;
        my $out = $builder->build($ctx, $ctx->stash('tokens'), $cond);
        return $ctx->error( $builder->errstr ) unless defined $out;
        $res .= $out;
    }
    $res;
}

sub _hdlr_pass_tokens {
    my($ctx, $args, $cond) = @_;
    my $b = $ctx->stash('builder');
    defined(my $out = $b->build($ctx, $ctx->stash('tokens'), $cond))
        or return $ctx->error($b->errstr);
    return $out;
}

sub _hdlr_pass_tokens_else {
    my($ctx, $args, $cond) = @_;
    my $b = $ctx->stash('builder');
    defined(my $out = $b->build($ctx, $ctx->stash('tokens_else'), $cond))
        or return $ctx->error($b->errstr);
    return $out;
}

###########################################################################

=head2 ArchiveDate

The starting date of the archive in context. For use with the Monthly, Weekly,
and Daily archive types only. Date format tags may be applied with the format
attribute along with the language attribute. See L<Date> for attributes
that are supported.

=for tags date, archives

=cut

###########################################################################

=head2 Date

Outputs the current date.

B<Attributes:>

=over 4

=item * ts (optional)

If specified, will use the given date as the date to publish. Must be
in the format of "YYYYMMDDhhmmss".

=item * relative (optional)

If specified, will publish the date using a phrase, if the date is
less than a week from the current date. Accepted values are "1", "2", "3"
and "js". The options for "1", "2" and "3" affect the style of the phrase.

=over 4

=item * relative="1"

Supports display of one duration: moments ago; N minutes ago; N hours ago; N days ago. For older dates in the same year, the date is shown as the abbreviated month and day of the month ("Jan 3"). For older dates, the year is added to that ("Jan 3 2005").

=item * relative="2"

Supports display of two durations: less than 1 minute ago; N seconds, N minutes ago; N minutes ago; N hours, N minutes ago; N hours ago; N days, N hours ago; N days ago.

=item * relative="3"

Supports display of two durations: N seconds ago; N seconds, N minutes ago;
N minutes ago; N hours, N minutes ago; N hours ago; N days, N hours ago; N days ago.

=item * relative="js"

When specified, publishes the date using JavaScript, which relies on a
MT JavaScript function 'mtRelativeDate' to format the date.

=back

=item * format (optional)

A string that provides the format in which to publish the date. If
unspecified, the default that is appropriate for the language of the blog
is used (for English, this is "%B %e, %Y %l:%M %p"). The format specifiers
supported are:

=over 4

=item * %Y

The 4-digit year. Example: "1999".

=item * %m

The 2-digit month (zero-padded). Example: for a date in September, this would output "09".

=item * %d

The 2-digit day of the month (zero-padded). Example: "05".

=item * %H

The 2-digit hour of the day (24-hour clock, zero-padded). Example: "18".

=item * %M

The 2-digit minute of the hour (zero-padded). Example: "09".

=item * %S

The 2-digit second of the minute (zero-padded). Example: "04".

=item * %w

The numeric day of the week, in the range C<0>-C<6>, where C<0> is
C<Sunday>. Example: "3".

=item * %j

The numeric day of the year, in the range C<0>-C<365>. Zero-padded to
three digits. Example: "040".

=item * %y

The two-digit year, zero-padded. Example: %y for a date in 2008 would
output "08".

=item * %b

The abbreviated month name. Example: %b for a date in January would
output "Jan".

=item * %B

The full month name. Example: "January".

=item * %a

The abbreviated day of the week. Example: %a for a date on a Monday would
output "Mon".

=item * %A

The full day of the week. Example: "Friday".

=item * %e

The numeric day of the month (space-padded). Example: " 8".

=item * %I

The two-digit hour on a 12-hour clock padded with a zero if applicable.
Example: "04".

=item * %k

The two-digit military time hour padded with a space if applicable.
Example: " 9".

=item * %l

The hour on a 12-hour clock padded with a space if applicable.
Example: " 4".

=back

=item * format_name (optional)

Supports date formatting for particular standards.

=over 4

=item * rfc822

Outputs the date in the format: "%a, %d %b %Y %H:%M:%S Z".

=item * iso8601

Outputs the date in the format: "%Y-%m-%dT%H:%M:%SZ".

=back

=item * utc (optional)

Converts the date into UTC time.

=item * offset_blog_id (optional)

Identifies the ID of the blog to use for adjusting the time to
blog time. Will default to the current blog in context if unset.

=item * language (optional)

Used to force localization of the date to a specific language.
Accepted values: "cz" (Czechoslovakian), "dk" (Scandinavian),
"nl" (Dutch), "en" (English), "fr" (French), "de" (German),
"is" (Icelandic), "ja" (Japanese), "it" (Italian), "no" (Norwegian),
"pl" (Polish), "pt" (Portuguese), "si" (Slovenian), "es" (Spanish),
"fi" (Finnish), "se" (Swedish). Will use the blog's date language
setting as a default.

=back

=cut

sub _hdlr_sys_date {
    my ($ctx, $args) = @_;
    unless ($args->{ts}) {
        my $t = time;
        my @ts = offset_time_list($t, $ctx->stash('blog_id'));
        $args->{ts} = sprintf "%04d%02d%02d%02d%02d%02d",
            $ts[5]+1900, $ts[4]+1, @ts[3,2,1,0];
    }
    return _hdlr_date($ctx, $args);
}

sub _hdlr_date {
    my ($ctx, $args) = @_;
    my $ts = $args->{ts} || $ctx->{current_timestamp};
    my $tag = $ctx->stash('tag');
    return $ctx->error(MT->translate(
        "You used an [_1] tag without a date context set up.", "MT$tag" ))
        unless defined $ts;
    my $blog = $ctx->stash('blog');
    unless (ref $blog) {
        my $blog_id = $blog || $args->{offset_blog_id};
        if ($blog_id) {
            $blog = MT->model('blog')->load($blog_id);
            return $ctx->error( MT->translate( 'Can\'t load blog #[_1].', $blog_id ) )
              unless $blog;
        }
    }
    my $lang = $args->{language} || $ctx->var('local_lang_id')
        || ($blog && $blog->language);
    if ($args->{utc}) {
        my($y, $mo, $d, $h, $m, $s) = $ts =~ /(\d\d\d\d)[^\d]?(\d\d)[^\d]?(\d\d)[^\d]?(\d\d)[^\d]?(\d\d)[^\d]?(\d\d)/;
        $mo--;
        my $server_offset = ($blog && $blog->server_offset) || MT->config->TimeOffset;
        if ((localtime (timelocal ($s, $m, $h, $d, $mo, $y )))[8]) {
            $server_offset += 1;
        }
        my $four_digit_offset = sprintf('%.02d%.02d', int($server_offset),
                                        60 * abs($server_offset
                                                 - int($server_offset)));
        require MT::DateTime;
        my $tz_secs = MT::DateTime->tz_offset_as_seconds($four_digit_offset);
        my $ts_utc = Time::Local::timegm_nocheck($s, $m, $h, $d, $mo, $y);
        $ts_utc -= $tz_secs;
        ($s, $m, $h, $d, $mo, $y) = gmtime( $ts_utc );
        $y += 1900; $mo++;
        $ts = sprintf("%04d%02d%02d%02d%02d%02d", $y, $mo, $d, $h, $m, $s);
    }
    if (my $format = lc ($args->{format_name} || '')) {
        my $tz = 'Z';
        unless ($args->{utc}) {
            my $so = ($blog && $blog->server_offset) || MT->config->TimeOffset;
            my $partial_hour_offset = 60 * abs($so - int($so));
            if ($format eq 'rfc822') {
                $tz = sprintf("%s%02d%02d", $so < 0 ? '-' : '+',
                    abs($so), $partial_hour_offset);
            }
            elsif ($format eq 'iso8601') {
                $tz = sprintf("%s%02d:%02d", $so < 0 ? '-' : '+',
                    abs($so), $partial_hour_offset);
            }
        }
        if ($format eq 'rfc822') {
            ## RFC-822 dates must be in English.
            $args->{'format'} = '%a, %d %b %Y %H:%M:%S ' . $tz;
            $lang = 'en';
        }
        elsif ($format eq 'iso8601') {
            $args->{format} = '%Y-%m-%dT%H:%M:%S' . $tz;
        }
    }
    if (my $r = $args->{relative}) {
        if ($r eq 'js') {
            # output javascript here to render relative date
            my($y, $mo, $d, $h, $m, $s) = $ts =~ /(\d\d\d\d)[^\d]?(\d\d)[^\d]?(\d\d)[^\d]?(\d\d)[^\d]?(\d\d)[^\d]?(\d\d)/;
            $mo--;
            my $fds = format_ts($args->{'format'}, $ts, $blog, $lang);
            my $js = <<EOT;
<script type="text/javascript">
/* <![CDATA[ */
document.write(mtRelativeDate(new Date($y,$mo,$d,$h,$m,$s), '$fds'));
/* ]]> */
</script><noscript>$fds</noscript>
EOT
            return $js;
        } else {
            my $old_lang = MT->current_language;
            MT->set_language($lang) if $lang && ($lang ne $old_lang);
            my $date = relative_date($ts, time, $blog, $args->{format}, $r);
            MT->set_language($old_lang) if $lang && ($lang ne $old_lang);
            if ($date) {
                return $date;
            } else {
                if (!$args->{format}) {
                    return '';
                }
            }
        }
    }
    my $mail_flag = $args->{mail} || 0;
    return format_ts($args->{'format'}, $ts, $blog, $lang, $mail_flag);
}

sub _comment_follow {
    my($ctx, $arg) = @_;
    my $c = $ctx->stash('comment');
    return unless $c;

    my $blog = $ctx->stash('blog');
    if ($blog && $blog->nofollow_urls) {
        if ($blog->follow_auth_links) {
            my $cmntr = $ctx->stash('commenter');
            unless ($cmntr) {
                if ($c->commenter_id) {
                    $cmntr = MT::Author->load($c->commenter_id) || undef;
                }
            }
            if (!defined $cmntr || ($cmntr && !$cmntr->is_trusted($blog->id))) {
                nofollowfy_on($arg);
            }
        } else {
            nofollowfy_on($arg);
        }
    }
}

###########################################################################

=head2 Comments

A container tag which iterates over a list of comments on an entry or for a
blog. By default, all comments in context (e.g. on an entry or in a blog) are
returned. When used in a blog context, only comments on published entries are
returned.

B<Attributes:>

=over 4

=item * lastn

Display the last N comments in context where N is a positive integer.
B<NOTE: lastn required in a blog context.>

=item * offset (optional; default "0")

Specifies a number of comments to skip.

=item * sort_by (optional)

Specifies a sort column.

=item * sort_order (optional)

Specifies the sort order and overrides the General Settings. Recognized
values are "ascend" and "descend."

=item * namespace

Used in conjunction with the "min*", "max*" attributes to
select comments based on a particular scoring mechanism.

=item * min_score

If 'namespace' is also specified, filters the comments based on
the score within that namespace. This specifies the minimum score
to consider the comment for inclusion.

=item * max_score

If 'namespace' is also specified, filters the comments based on
the score within that namespace. This specifies the maximum score
to consider the comment for inclusion.

=item * min_rank

If 'namespace' is also specified, filters the comments based on
the rank within that namespace. This specifies the minimum rank
to consider the comment for inclusion.

=item * max_rate

If 'namespace' is also specified, filters the comments based on
the rank within that namespace. This specifies the maximum rank
to consider the comment for inclusion.

=item * min_count

If 'namespace' is also specified, filters the comments based on
the count within that namespace. This specifies the minimum count
to consider the comment for inclusion.

=item * max_count

If 'namespace' is also specified, filters the comments based on
the count within that namespace. This specifies the maximum count
to consider the comment for inclusion.

=back

=for tags multiblog, comments, loop, scoring

=cut

sub _hdlr_comments {
    my($ctx, $args, $cond) = @_;

    my (%terms, %args);
    my @filters;
    my @comments;
    my $comments = $ctx->stash('comments');
    my $blog_id = $ctx->stash('blog_id');
    my $blog = $ctx->stash('blog');
    my $namespace = $args->{namespace};
    if ($args->{namespace}) {
        my $need_join = 0;
        if ($args->{sort_by} && ($args->{sort_by} eq 'score' || $args->{sort_by} eq 'rate')) {
            $need_join = 1;
        } else {
            for my $f qw( min_score max_score min_rate max_rate min_count max_count scored_by ) {
                if ($args->{$f}) {
                    $need_join = 1;
                    last;
                }
            }
        }
        if ($need_join) {
            my $scored_by = $args->{scored_by} || undef;
            if ($scored_by) {
                require MT::Author;
                my $author = MT::Author->load({ name => $scored_by }) or
                    return $ctx->error(MT->translate(
                        "No such user '[_1]'", $scored_by ));
                $scored_by = $author;
            }
            $args{join} = MT->model('objectscore')->join_on(undef,
                {
                    object_id => \'=comment_id',
                    object_ds => 'comment',
                    namespace => $namespace,
                    (!$comments && $scored_by ? (author_id => $scored_by->id) : ()),
                }, {
                    unique => 1,
            });
            if ($comments && $scored_by) {
                push @filters, sub { $_[0]->get_score($namespace, $scored_by) };
            }
        }

        # Adds a rate or score filter to the filter list.
        if ($args->{min_score}) {
            push @filters, sub { $_[0]->score_for($namespace) >= $args->{min_score}; };
        }
        if ($args->{max_score}) {
            push @filters, sub { $_[0]->score_for($namespace) <= $args->{max_score}; };
        }
        if ($args->{min_rate}) {
            push @filters, sub { $_[0]->score_avg($namespace) >= $args->{min_rate}; };
        }
        if ($args->{max_rate}) {
            push @filters, sub { $_[0]->score_avg($namespace) <= $args->{max_rate}; };
        }
        if ($args->{min_count}) {
            push @filters, sub { $_[0]->vote_for($namespace) >= $args->{min_count}; };
        }
        if ($args->{max_count}) {
            push @filters, sub { $_[0]->vote_for($namespace) <= $args->{max_count}; };
        }
    }

    my $so = lc ($args->{sort_order} || ($blog ? $blog->sort_order_comments : undef) || 'ascend');
    my $no_resort;
    if ($comments) {
        my $n = $args->{lastn};
        my $col = lc($args->{sort_by} || 'created_on');
        @$comments = $so eq 'ascend' ?
            sort { $a->created_on cmp $b->created_on } @$comments :
            sort { $b->created_on cmp $a->created_on } @$comments;
        $no_resort = 1
            unless $args->{sort_order} || $args->{sort_by};
        if (@filters) {
            my $offset = $args->{offset} || 0;
            my $j      = 0;
            COMMENTS: for my $c (@$comments) {
                for (@filters) {
                    next COMMENTS unless $_->($c);
                }
                next if $offset && $j++ < $offset;
                push @comments, $c;
            }
        }
        else {
            my $offset;
            if ($offset = $args->{offset}) {
                if ($offset < scalar @comments) {
                    @comments = @$comments[$offset..$#comments];
                } else {
                    @comments = ();
                }
            } else {
                @comments = @$comments;
            }
        }
        if ($n) {
            my $max = $n - 1 > $#comments ? $#comments : $n - 1;
            @comments = $so eq 'ascend' ?
                @comments[$#comments-$max..$#comments] :
                @comments[0..$max];
        }
    } else {
        $terms{visible} = 1;
        $ctx->set_blog_load_context($args, \%terms, \%args)
            or return $ctx->error($ctx->errstr);

        ## If there is a "lastn" arg, then we need to check if there is an entry
        ## in context. If so, grab the N most recent comments for that entry;
        ## otherwise, grab the N most recent comments for the entire blog.
        my $n = $args->{lastn};
        if (my $e = $ctx->stash('entry')) {
            ## Sort in descending order, then grab the first $n ($n most
            ## recent) comments.
            $args{'sort'} = 'created_on';
            $args{'direction'} = 'descend';
            my $cmts = $e->comments(\%terms, \%args);
            my $offset = $args->{offset} || 0;
            if (@filters) {
                my $i = 0;
                my $j = 0;
                my $offset = $args->{offset} || 0;
                COMMENTS: for my $c (@$cmts) {
                    for (@filters) {
                        next COMMENTS unless $_->($c);
                    }
                    next if $offset && $j++ < $offset;
                    push @comments, $c;
                    last if $n && ( $n <= ++$i );
                }
            } elsif ($offset || $n) {
                if ($offset) {
                    if ($offset < scalar @$cmts - 1) {
                        @$cmts = @$cmts[$offset..(scalar @$cmts - 1)];
                     } else {
                        @$cmts = ();
                    }
                }
                if ($n) {
                    my $max = $n - 1 > scalar @$cmts - 1 ? scalar @$cmts - 1 : $n - 1;
                    @$cmts = @$cmts[0..$max];
                }
                @comments = @$cmts;
            } else {
                @comments = @$cmts;
            }
        } else {
            $args{'sort'} = lc $args->{sort_by} || 'created_on';
            if ($args->{lastn} || $args->{offset}) {
                $args{'direction'} =  'descend';
                $so = 'descend';
            } else {
                $args{'direction'} =  'ascend';
                $no_resort = 1
                    unless $args->{sort_order} || $args->{sort_by};
            }

            require MT::Comment;
            if (!@filters) {
                $args{limit} = $n if $n;
                $args{offset} = $args->{offset} if $args->{offset};
                $args{join} = MT->model('entry')->join_on(
                    undef,
                    {
                        id => \'=comment_entry_id',
                        status => MT::Entry::RELEASE(),
                    }, {unique => 1});

                @comments = MT::Comment->load(\%terms, \%args);
            } else {
                my $iter = MT::Comment->load_iter(\%terms, \%args);
                my %entries;
                my $j = 0;
                my $offset = $args->{offset} || 0;
                COMMENT: while (my $c = $iter->()) {
                    my $e = $entries{$c->entry_id} ||= $c->entry;
                    next unless $e;
                    next if $e->status != MT::Entry::RELEASE();
                    for (@filters) {
                        next COMMENT unless $_->($c);
                    }
                    next if $offset && $j++ < $offset;
                    push @comments, $c;
                    if ($n && (scalar @comments == $n)) {
                        $iter->end;
                        last;
                    }
                }
            }
        }
    }

    if (!$no_resort) {
        my $col = lc ($args->{sort_by} || 'created_on');
        if (@comments) {
            if ('created_on' eq $col) {
                my @comm;
                @comm = $so eq 'ascend' ?
                    sort { $a->created_on <=> $b->created_on } @comments :
                    sort { $b->created_on <=> $a->created_on } @comments;
                # filter out comments from unapproved commenters
                @comments = grep { $_->visible() } @comm;
            } elsif ('score' eq $col) {
                my %m = map { $_->id => $_ } @comments;
                my @cid = keys %m;
                require MT::ObjectScore;
                my $scores = MT::ObjectScore->sum_group_by(
                    { 'object_ds' => 'comment', 'namespace' => $namespace, object_id => \@cid },
                    { 'sum' => 'score', group => ['object_id'],
                      $so eq 'ascend' ? (direction => 'ascend') : (direction => 'descend'),
                    });
                my @tmp;
                while (my ($score, $object_id) = $scores->()) {
                    push @tmp, delete $m{ $object_id } if exists $m{ $object_id };
                    $scores->end, last unless %m;
                }
                @comments = @tmp;
            } elsif ('rate' eq $col) {
                my %m = map { $_->id => $_ } @comments;
                my @cid = keys %m;
                require MT::ObjectScore;
                my $scores = MT::ObjectScore->avg_group_by(
                    { 'object_ds' => 'comment', 'namespace' => $namespace, object_id => \@cid },
                    { 'avg' => 'score', group => ['object_id'],
                      $so eq 'ascend' ? (direction => 'ascend') : (direction => 'descend'),
                    });
                my @tmp;
                while (my ($score, $object_id) = $scores->()) {
                    push @tmp, delete $m{ $object_id } if exists $m{ $object_id };
                    $scores->end, last unless %m;
                }
                @comments = @tmp;
            }
        }
    }

    my $html = '';
    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');
    my $i = 1;

    local $ctx->{__stash}{commenter} = $ctx->{__stash}{commenter};
    my $vars = $ctx->{__stash}{vars} ||= {};
    my $glue = $args->{glue};
    for my $c (@comments) {
        local $vars->{__first__} = $i == 1;
        local $vars->{__last__} = ($i == scalar @comments);
        local $vars->{__odd__} = ($i % 2) == 1;
        local $vars->{__even__} = ($i % 2) == 0;
        local $vars->{__counter__} = $i;
        local $ctx->{__stash}{blog} = $c->blog;
        local $ctx->{__stash}{blog_id} = $c->blog_id;
        local $ctx->{__stash}{comment} = $c;
        local $ctx->{current_timestamp} = $c->created_on;
        $ctx->stash('comment_order_num', $i);
        if ($c->commenter_id) {
            $ctx->stash('commenter', delay(sub {MT::Author->load($c->commenter_id)}));
        } else {
            $ctx->stash('commenter', undef);
        }
        my $out = $builder->build($ctx, $tokens,
            { CommentsHeader => $i == 1,
              CommentsFooter => ($i == scalar @comments), %$cond } );
        return $ctx->error( $builder->errstr ) unless defined $out;
        $html .= $glue if defined $glue && length($html) && length($out);
        $html .= $out;
        $i++;
    }
    if (!@comments) {
        return _hdlr_pass_tokens_else(@_);
    }
    return $html;
}

###########################################################################

=head2 CommentDate

Outputs the creation date for the current comment in context. See
the L<Date> tag for support attributes.

=for tags date, comments

=cut

sub _hdlr_comment_date {
    my ($ctx, $args) = @_;
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    $args->{ts} = $c->created_on;
    return _hdlr_date($ctx, $args);
}

###########################################################################

=head2 CommentID

Outputs the numeric ID for the current comment in context.

=for tags comments

=cut

sub _hdlr_comment_id {
    my ($ctx, $args) = @_;
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    my $id = $c->id || 0;
    return $args && $args->{pad} ? (sprintf "%06d", $id) : $id;
}

###########################################################################

=head2 CommentEntryID

Outputs the numeric ID for the parent entry (or page) of
the current comment in context.

=for tags comments

=cut

sub _hdlr_comment_entry_id {
    my ($ctx, $args) = @_;
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    return $args && $args->{pad} ? (sprintf "%06d", $c->entry_id) : $c->entry_id;
}

###########################################################################

=head2 CommentBlogID

Outputs the numeric ID of the blog for the current comment
in context.

=for tags comments

=cut

sub _hdlr_comment_blog_id {
    my ($ctx) = @_;
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    return $c->blog_id;
}

###########################################################################

=head2 CommentIfModerated

Conditional tag for testing whether the current comment in context is
moderated or not (used for application, email and comment response
templates where the comment may not actually be published).

=for tags comments

=cut

sub _hdlr_comment_if_moderated {
    my ($ctx) = @_;
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    return $c->visible ? 1 : 0;
}

###########################################################################

=head2 CommentName

Deprecated in favor of the L<CommentAuthor> tag.

=for tags deprecated

=cut

###########################################################################

=head2 CommentAuthor

Outputs the name field of the current comment in context (for
comments left by authenticated users, this will return their
display name).

=for tags comments

=cut

sub _hdlr_comment_author {
    my ($ctx, $args) = @_;
    sanitize_on($args);
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    my $a = defined $c->author ? $c->author : '';
    $args->{default} = MT->translate("Anonymous")
        unless exists $args->{default};
    $a ||= $args->{default};
    return remove_html($a);    
}

###########################################################################

=head2 CommentIP

Outputs the IP address where the current comment in context was
posted from.

=for tags comments

=cut

sub _hdlr_comment_ip {
    my ($ctx) = @_;
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    return defined $c->ip ? $c->ip : '';
}

###########################################################################

=head2 CommentAuthorLink

A linked version of the comment author name, using the comment author's URL
if provided in the comment posting form. Otherwise, the comment author
name is unlinked. This behavior can be altered with optional attributes.

B<Attributes:>

=over 4

=item * show_email (optional; default "0")

Specifies if the comment author's email can be displayed.

=item * show_url (optional; default "1")

Specifies if the comment author's URL can be displayed.

=item * new_window (optional; default "0")

Specifies to open the link in a new window by adding C<target="_blank">
to the anchor tag. See example below.

=item * default_name (optional; default "Anonymous")

Used in the event that the commenter did not provide a value for their
name.

=item * no_redirect (optional; default "0")

Prevents use of the mt-comments.cgi script to handle the comment author
link.

=item * nofollowfy (optional)

If assigned, applies a C<rel="nofollow"> link relation to the link.

=back

=for tags comments

=cut

sub _hdlr_comment_author_link {
    #sanitize_on($_[1]);
    my($ctx, $args) = @_;
    _comment_follow($ctx, $args);

    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    my $name = $c->author;
    $name = '' unless defined $name;
    $name ||= $args->{default_name};
    $name ||= MT->translate("Anonymous");
    my $show_email = $args->{show_email} ? 1 : 0;
    my $show_url = 1 unless exists $args->{show_url} && !$args->{show_url};
    # Open the link in a new window if requested (with new_window="1").
    my $target = $args->{new_window} ? ' target="_blank"' : '';
    my $cmntr = $ctx->stash('commenter');
    if ( !$cmntr ) {
        $cmntr = MT::Author->load( $c->commenter_id ) if $c->commenter_id;
    }

    if ( $cmntr ) {
        if ($cmntr->url) {
            return sprintf(qq(<a title="%s" href="%s"%s>%s</a>),
                           $cmntr->url, $cmntr->url, $target, $name); 
        }
        return $name;
    } elsif ($show_url && $c->url) {
        my $cfg = $ctx->{config};
        my $cgi_path = _hdlr_cgi_path($ctx);
        my $comment_script = $cfg->CommentScript;
        $name = remove_html($name);
        my $url = remove_html($c->url);
        $url =~ s/>/&gt;/g;
        if ($c->id && !$args->{no_redirect} && !$args->{nofollowfy}) {
            return sprintf(qq(<a title="%s" href="%s%s?__mode=red;id=%d"%s>%s</a>),
                           $url, $cgi_path, $comment_script, $c->id, $target, $name);
        } else {
            # In the case of preview, show URL directly without a redirect
            return sprintf(qq(<a title="%s" href="%s"%s>%s</a>),
                           $url, $url, $target, $name); 
        }
    } elsif ($show_email && $c->email && MT::Util::is_valid_email($c->email)) {
        my $email = remove_html($c->email);
        my $str = "mailto:" . $email;
        $str = spam_protect($str) if $args->{'spam_protect'};
        return sprintf qq(<a href="%s">%s</a>), $str, $name;
    }
    return $name;
}

###########################################################################

=head2 CommentEmail

Publishes the commenter's e-mail address.

B<NOTE:> It is not recommended to publish any email addresses.

B<Attributes:>

=over 4

=item * spam_protect (optional; default "0")

=back

=for tags comments

=cut

sub _hdlr_comment_email {
    my ($ctx, $args) = @_;
    sanitize_on($args);
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    return '' unless defined $c->email;
    return '' unless $c->email =~ m/@/;
    my $email = remove_html($c->email);
    return $args && $args->{'spam_protect'} ? spam_protect($email) : $email;
}

###########################################################################

=head2 CommentAuthorIdentity

Returns a profile icon link for the current commenter in context. The icon
is for the authentication service used (ie, TypeKey, OpenID, Vox
LiveJournal, etc.). If the commenter has a URL in their profile the icon
is linked to that URL.

=for tags comments

=cut

sub _hdlr_comment_author_identity {
    my ($ctx, $args) = @_;
    my $cmt = $ctx->stash('comment')
         or return $ctx->_no_comment_error();
    my $cmntr = $ctx->stash('commenter');
    unless ($cmntr) {
        if ($cmt->commenter_id) {
            $cmntr = MT::Author->load($cmt->commenter_id) 
                or return "?";
        } else {
            return q();
        }
    }
    my $link = $cmntr->url;
    my $static_path = _hdlr_static_path($ctx);
    my $logo = $cmntr->auth_icon_url;
    unless ($logo) {
        my $root_url = $static_path . "images";
        $logo = "$root_url/nav-commenters.gif";
    }
    if ($logo =~ m!^/!) {
        # relative path, prepend blog domain
        my $blog = $ctx->stash('blog');
        if ($blog) {
            my ($blog_domain) = $blog->archive_url =~ m|(.+://[^/]+)|;
            $logo = $blog_domain . $logo;
        }
    }
    my $result = qq{<img alt=\"Author Profile Page\" src=\"$logo\" width=\"16\" height=\"16\" />};
    if ($link) {
        $result = qq{<a class="commenter-profile" href=\"$link\">$result</a>};
    }
    return $result;
}

###########################################################################

=head2 CommentLink

Outputs the permalink for the comment currently in context. This is
the permalink for the parent entry, plus an anchor for the comment
itself (in the format '#comment-ID').

=for tags comments

=cut

sub _hdlr_comment_link {
    my ($ctx) = @_;
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    return '#' unless $c->id;
    my $entry = $c->entry
        or return $ctx->error("No entry exists for comment #" . $c->id);
    return $entry->archive_url . '#comment-' . $c->id;
}

###########################################################################

=head2 CommentURL

Outputs the URL of the current comment in context. The URL is the link
provided in the comment from an anonymous comment, or for authenticated
comments, is the URL from the commenter's profile.

=for tags comments

=cut

sub _hdlr_comment_url {
    my ($ctx, $args) = @_;
    sanitize_on($args);
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    my $url = defined $c->url ? $c->url : '';
    return remove_html($url);
}

###########################################################################

=head2 CommentPreviewEmail

A deprecated tag, replaced with L<CommentEmail>.

=for tags deprecated

=cut

###########################################################################

=head2 CommentPreviewBody

A deprecated tag, replaced with L<CommentBody>.

=for tags deprecated

=cut

###########################################################################

=head2 CommentPreviewAuthorLink

A deprecated tag, replaced with L<CommentAuthorLink>.

=for tags deprecated

=cut

###########################################################################

=head2 CommentPreviewURL

A deprecated tag, replaced with L<CommentURL>.

=for tags deprecated

=cut

###########################################################################

=head2 CommentPreviewDate

A deprecated tag, replaced with L<CommentDate>.

=for tags deprecated

=cut

###########################################################################

=head2 CommentPreviewAuthor

A deprecated tag, replaced with L<CommentAuthor>.

=for tags deprecated

=cut

###########################################################################

=head2 CommentPreviewIP

A deprecated tag, replaced with L<CommentIP>.

=for tags deprecated

=cut

###########################################################################

=head2 CommentBody

B<Attributes:>

=over 4

=item * autolink (optional)

If unspecified, any plaintext links in the comment body will be
automatically linked if the blog is configured to do that on the
comment preferences screen. If this attribute is specified, it will
override the blog preference.

=item * convert_breaks (optional)

By default, the comment text is formatted according to the comment text
formatting choice in the blog preferences. If convert_breaks is disabled,
the raw content of the comment body is output without any re-formatting
applied.

=item * words (optional)

Limits the length of the comment body to the specified number of words.
This is useful for producing a list of recent comments with an excerpt
of each.

=back

=for tags comments

=cut

sub _hdlr_comment_body {
    my($ctx, $args) = @_;
    sanitize_on($args);
    _comment_follow($ctx, $args);

    my $blog = $ctx->stash('blog');
    return q() unless $blog;
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    my $t = defined $c->text ? $c->text : '';
    unless ($blog->allow_comment_html) {
        $t = remove_html($t);
    }
    my $convert_breaks = exists $args->{convert_breaks} ?
        $args->{convert_breaks} :
        $blog->convert_paras_comments;
    $t = $convert_breaks ?
        MT->apply_text_filters($t, $blog->comment_text_filters, $ctx) :
        $t;
    return first_n_text($t, $args->{words}) if exists $args->{words};
    if (!(exists $args->{autolink} && !$args->{autolink}) &&
        $blog->autolink_urls) {
        $t =~ s!(^|\s|>)(https?://[^\s<]+)!$1<a href="$2">$2</a>!gs;
    }
    $t;
}

###########################################################################

=head2 CommentOrderNumber

Outputs a number relating to the position of the comment in the list
of all comments published using the C<Comments> tag, starting with "1".

=for tags comments

=cut

sub _hdlr_comment_order_num {
    my ($ctx) = @_;
    return $ctx->stash('comment_order_num');
}

###########################################################################

=head2 CommentPreviewState

For the comment preview template only.

=for tags comments

=cut

sub _hdlr_comment_prev_state {
    my ($ctx) = @_;
    return $ctx->stash('comment_state');
}

###########################################################################

=head2 CommentPreviewIsStatic

For the comment preview template only.

=for tags comments

=cut

sub _hdlr_comment_prev_static {
    my ($ctx) = @_;
    my $s = encode_html($ctx->stash('comment_is_static')) || '';
    return defined $s ? $s : ''
}

###########################################################################

=head2 CommentEntry

A block tag that can be used to set the parent entry of the comment
in context.

B<Example:>

    <mt:Comments lastn="4">
        <$mt:CommentAuthor$> left a comment on
        <mt:CommentEntry><$mt:EntryTitle$></mt:CommentEntry>.
    </mt:Comments>

=for tags comments

=cut

sub _hdlr_comment_entry {
    my($ctx, $args, $cond) = @_;
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    my $entry = MT::Entry->load($c->entry_id)
        or return '';
    local $ctx->{__stash}{entry} = $entry;
    local $ctx->{current_timestamp} = $entry->authored_on;
    $ctx->stash('builder')->build($ctx, $ctx->stash('tokens'), $cond);
}

###########################################################################

=head2 CommentParent

A block tag that can be used to set the parent comment of the current
comment in context. If the current comment has no parent, it produces
nothing.

B<Example:>

    <mt:CommentParent>
        (a reply to <$mt:CommentAuthor$>'s comment)
    </mt:CommentParent>

=for tags comments

=cut

sub _hdlr_comment_parent {
    my($ctx, $args, $cond) = @_;

    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    $c->parent_id && (my $parent = MT::Comment->load($c->parent_id))
        or return '';
    local $ctx->{__stash}{comment} = $parent;
    $ctx->stash('builder')->build($ctx, $ctx->stash('tokens'), $cond);
}

###########################################################################

=head2 CommentReplyToLink

Produces the "Reply" link for the current comment in context.
By default, this relies on using the MT "Javascript" default template,
which supplies the C<mtReplyCommentOnClick> function.

B<Attributes:>

=over 4

=item * label or text (optional)

A custom phrase for the link (default is "Reply").

=item * onclick (optional)

Custom JavaScript code for the onclick attribute. By default, this
value is "mtReplyCommentOnClick(%d, '%s')" (note that %d is replaced
with the comment ID; %s is replaced with the name of the commenter).

=back

=for tags comments

=cut

sub _hdlr_comment_reply_link {
    my($ctx, $args) = @_;
    my $comment = $ctx->stash('comment') or
        return  $ctx->_no_comment_error();

    my $label = $args->{label} || $args->{text} || MT->translate('Reply');
    my $comment_author = MT::Util::encode_js($comment->author);
    my $onclick = sprintf( $args->{onclick} || "mtReplyCommentOnClick(%d, '%s')", $comment->id, $comment_author);

    return sprintf(qq(<a title="%s" href="javascript:void(0);" onclick="$onclick">%s</a>),
                   $label, $label);
}

###########################################################################

=head2 CommentParentID

Outputs the ID of the parent comment for the comment currently in context.
If there is no parent comment, outputs '0'.

B<Attributes:>

=over 4

=item * pad

If specified, zero-pads the ID to 6 digits. Example: 001234.

=back

=for tags comments

=cut

sub _hdlr_comment_parent_id {
    my ($ctx, $args) = @_;
    my $c = $ctx->stash('comment') or return '';
    my $id = $c->parent_id || 0;
    $args && $args->{pad} ? (sprintf "%06d", $id) : ($id ? $id : '');
}

###########################################################################

=head2 CommentReplies

A block tag which iterates over a list of reply comments to the 
in context.

B<Example:>

    <mt:Comment>
      <mt:CommentReplies>
        <mt:CommentsHeader>Replies to the comment:</mt:CommentsHeader>
        <$mt:CommentBody$>
      </mt:CommentReplies>
    </mt:Comment>

=for tags comments, loop

=cut

sub _hdlr_comment_replies {
    my($ctx, $args, $cond) = @_;

    my $comment = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    my $tokens = $ctx->stash('tokens');

    $ctx->stash('_comment_replies_tokens', $tokens);

    my (%terms, %args);
    $terms{parent_id} = $comment->id;
    $terms{visible} = 1;
    $args{'sort'} = 'created_on';
    $args{'direction'} = 'descend';
    require MT::Comment;
    my $iter = MT::Comment->load_iter(\%terms, \%args);
    my %entries;
    my $blog = $ctx->stash('blog');
    my $so = lc($args->{sort_order}) || ($blog ? $blog->sort_order_comments : undef) || 'ascend';
    my $n = $args->{lastn};
    my @comments;
    while (my $c = $iter->()) {
        push @comments, $c;
        if ($n && (scalar @comments == $n)) {
            $iter->end;
            last;
        }
    }
    @comments = $so eq 'ascend' ?
        sort { $a->created_on <=> $b->created_on } @comments :
        sort { $b->created_on <=> $a->created_on } @comments;

    my $html = '';
    my $builder = $ctx->stash('builder');
    my $i = 1;
    
    @comments = grep { $_->visible() } @comments;

    local $ctx->{__stash}{commenter} = $ctx->{__stash}{commenter};
    my $vars = $ctx->{__stash}{vars} ||= {};
    for my $c (@comments) {
        local $vars->{__first__} = $i == 1;
        local $vars->{__last__} = ($i == scalar @comments);
        local $vars->{__odd__} = ($i % 2) == 1;
        local $vars->{__even__} = ($i % 2) == 0;
        local $vars->{__counter__} = $i;
        local $ctx->{__stash}{blog} = $c->blog;
        local $ctx->{__stash}{blog_id} = $c->blog_id;
        local $ctx->{__stash}{comment} = $c;
        local $ctx->{current_timestamp} = $c->created_on;
        $ctx->stash('comment_order_num', $i);
        if ($c->commenter_id) {
            $ctx->stash('commenter', delay(sub {MT::Author->load($c->commenter_id)}));
        } else {
            $ctx->stash('commenter', undef);
        }
        my $out = $builder->build($ctx, $tokens,
            { CommentsHeader => $i == 1,
              CommentsFooter => ($i == scalar @comments), } );
        return $ctx->error( $builder->errstr ) unless defined $out;
        $html .= $out;
        $i++;
    }
    if (!@comments) {
        return _hdlr_pass_tokens_else(@_);
    }
    $html;
}

###########################################################################

=head2 CommentRepliesRecurse

Recursively call the block with the replies to the comment in context. This
tag, when placed at the end of loop controlled by MTCommentReplies tag will
cause them to recursively descend into any replies to comments that exist
during the loop.

B<Example:>

    <mt:Comments>
      <$mt:CommentBody$>
      <mt:CommentReplies>
        <mt:CommentsHeader><ul></MTCommentsHeader>
        <li><$mt:CommentID$>
        <$mt:CommentRepliesRecurse$>
        </li>
        <mt:CommentsFooter></ul></mt:CommentsFooter>
      </mt:CommentReplies>
    </mt:Comments>

=for tags comments

=cut

sub _hdlr_comment_replies_recurse {
    my($ctx, $args, $cond) = @_;

    my $comment = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    my $tokens = $ctx->stash('_comment_replies_tokens');

    my (%terms, %args);
    $terms{parent_id} = $comment->id;
    $terms{visible} = 1;
    $args{'sort'} = 'created_on';
    $args{'direction'} = 'descend';
    require MT::Comment;
    my $iter = MT::Comment->load_iter(\%terms, \%args);
    my %entries;
    my $blog = $ctx->stash('blog');
    my $so = lc($args->{sort_order}) || ($blog ? $blog->sort_order_comments : undef) || 'ascend';
    my $n = $args->{lastn};
    my @comments;
    while (my $c = $iter->()) {
        push @comments, $c;
        if ($n && (scalar @comments == $n)) {
            $iter->end;
            last;
        }
    }
    @comments = $so eq 'ascend' ?
        sort { $a->created_on <=> $b->created_on } @comments :
        sort { $b->created_on <=> $a->created_on } @comments;

    my $html = '';
    my $builder = $ctx->stash('builder');
    my $i = 1;
    
    @comments = grep { $_->visible() } @comments;

    local $ctx->{__stash}{commenter} = $ctx->{__stash}{commenter};
    my $vars = $ctx->{__stash}{vars} ||= {};
    for my $c (@comments) {
        local $vars->{__first__} = $i == 1;
        local $vars->{__last__} = ($i == scalar @comments);
        local $vars->{__odd__} = ($i % 2) == 1;
        local $vars->{__even__} = ($i % 2) == 0;
        local $vars->{__counter__} = $i;
        local $ctx->{__stash}{blog} = $c->blog;
        local $ctx->{__stash}{blog_id} = $c->blog_id;
        local $ctx->{__stash}{comment} = $c;
        local $ctx->{current_timestamp} = $c->created_on;
        $ctx->stash('comment_order_num', $i);
        if ($c->commenter_id) {
            $ctx->stash('commenter', delay(sub {MT::Author->load($c->commenter_id)}));
        } else {
            $ctx->stash('commenter', undef);
        }
        my $out = $builder->build($ctx, $tokens,
            { CommentsHeader => $i == 1,
              CommentsFooter => ($i == scalar @comments), } );
        return $ctx->error( $builder->errstr ) unless defined $out;
        $html .= $out;
        $i++;
    }
    if (!@comments) {
        return _hdlr_pass_tokens_else(@_);
    }
    $html;
}

###########################################################################

=head2 CommentsHeader

The contents of this container tag will be displayed when the first
comment listed by a L<Comments> or L<CommentReplies> tag is reached.

=for tags comments

=cut

###########################################################################

=head2 CommentsFooter

The contents of this container tag will be displayed when the last
comment listed by a L<Comments> or L<CommentReplies> tag is reached.

=for tags comments

=cut

###########################################################################

=head2 IfCommentParent

A conditional tag that is true when the comment currently in context
is a reply to another comment.

B<Example:>

    <mt:IfCommentParent>
        (a reply)
    </mt:IfCommentParent>

=for tags comments

=cut

sub _hdlr_if_comment_parent {
    my($ctx, $args, $cond) = @_;

    my $c = $ctx->stash('comment');
    return 0 if !$c;

    my $parent_id = $c->parent_id;
    return 0 unless $parent_id;

    require MT::Comment;
    my $parent = MT::Comment->load($c->parent_id);
    return 0 unless $parent;
    return $parent->visible ? 1 : 0;
}

###########################################################################

=head2 IfCommentReplies

A conditional tag that is true when the comment currently in context
has replies.

=for tags comments

=cut

sub _hdlr_if_comment_replies {
    my($ctx, $args, $cond) = @_;
    my $c = $ctx->stash('comment');
    return 0 if !$c;
    MT::Comment->exist( { parent_id => $c->id, visible => 1 } );
}

###########################################################################

=head2 CommenterNameThunk

Used to populate the commenter_name Javascript variable. Deprecated in
favor of the L<UserSessionState> tag.

=for tags deprecated

=cut

sub _hdlr_commenter_name_thunk {
    my $ctx = shift;
    my $cfg = $ctx->{config};
    my $blog = $ctx->stash('blog') || MT::Blog->load($ctx->stash('blog_id'));
    return $ctx->error(MT->translate('Can\'t load blog #[_1].', $ctx->stash('blog_id'))) unless $blog;
    my ($blog_domain) = $blog->archive_url =~ m|://([^/]*)|;
    my $cgi_path = _hdlr_cgi_path($ctx);
    my ($mt_domain) = $cgi_path =~ m|://([^/]*)|;
    $mt_domain ||= '';
    if ($blog_domain ne $mt_domain) {
        my $cmt_script = $cfg->CommentScript;
        return "<script type='text/javascript' src='$cgi_path$cmt_script?__mode=cmtr_name_js'></script>";
    } else {
        return "<script type='text/javascript'>var commenter_name = getCookie('commenter_name')</script>";
    }
}

###########################################################################

=head2 CommenterUsername

This template tag returns the username of the current commenter in context.
If no name exists, then it returns an empty string.

B<Example:>

    <mt:Entries>
        <h1><$mt:EntryTitle$></h1>
        <mt:Comments>
            <a name="comment-<$mt:CommentID$>"></a>
            <p><$mt:CommentBody$></p>
            <cite><a href="/profiles/<$mt:CommenterID$>"><$mt:CommenterUsername$></a></cite>
        </mt:Comments>
    </mt:Entries>

=for tags comments

=cut

sub _hdlr_commenter_username {
    my ($ctx) = @_;
    my $a = $ctx->stash('commenter');
    return $a ? $a->name : '';
}

###########################################################################

=head2 UserSessionState

Returns a JSON-formatted data structure that represents the user that is
currently logged in.

=for tags comments, authentication

=cut

sub _hdlr_user_session_state {
    my ($ctx, $args, $cond) = @_;
    my $app = MT->app;
    return 'null' unless $app->can('session_state');

    my ( $state, $commenter ) = $app->session_state();
    require JSON;
    my $json = JSON::to_json($state);
    return $json;
}

###########################################################################

=head2 UserSessionCookieTimeout

Returns the value of the C<UserSessionCookieTimeout> configuration setting.

=for tags comments, configuration, authentication

=cut

sub _hdlr_user_session_cookie_timeout {
    my ($ctx) = @_;
    return $ctx->{config}->UserSessionCookieTimeout;
}

###########################################################################

=head2 UserSessionCookiePath

Returns the value of the C<UserSessionCookiePath> configuration setting.

The C<UserSessionCookiePath> may also use MT tags. If it does, they will
be evaluated for the blog in context.

=for tags comments, configuration, authentication

=cut

sub _hdlr_user_session_cookie_path {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $blog_id = $blog ? $blog->id : '0';
    my $blog_path = $ctx->stash('blog_cookie_path_' . $blog_id);
    if (!defined $blog_path) {
        $blog_path = $ctx->{config}->UserSessionCookiePath;
        if ($blog_path =~ m/<\$?mt/i) { # hey, a MT tag! lets evaluate
            my $builder = $ctx->stash('builder');
            my $tokens = $builder->compile($ctx, $blog_path);
            return $ctx->error($builder->errstr) unless defined $tokens;
            $blog_path = $builder->build($ctx, $tokens, $cond);
            return $ctx->error($builder->errstr) unless defined $blog_path;
        }
        $ctx->stash('blog_cookie_path_' . $blog_id, $blog_path);
    }
    return $blog_path;
}

###########################################################################

=head2 UserSessionCookieDomain

Returns the value of the C<UserSessionCookieDomain> configuration setting,
or the domain name of the blog currently in context. Any "www" subdomain
will be ignored (ie, "www.sixapart.com" becomes ".sixapart.com").

The C<UserSessionCookieDomain> may also use MT tags. If it does, they will
be evaluated for the blog in context.

=for tags comments, configuration, authentication

=cut

sub _hdlr_user_session_cookie_domain {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $blog_id = $blog ? $blog->id : '0';
    my $blog_domain = $ctx->stash('blog_cookie_domain_' . $blog_id);
    if (!defined $blog_domain) {
        $blog_domain = $ctx->{config}->UserSessionCookieDomain;
        if ($blog_domain =~ m/<\$?mt/i) { # hey, a MT tag! lets evaluate
            my $builder = $ctx->stash('builder');
            my $tokens = $builder->compile($ctx, $blog_domain);
            return $ctx->error($builder->errstr) unless defined $tokens;
            $blog_domain = $builder->build($ctx, $tokens, $cond);
            return $ctx->error($builder->errstr) unless defined $blog_domain;
        }
        # strip off common 'www' subdomain
        $blog_domain =~ s/^www\.//;
        $blog_domain = '.' . $blog_domain unless $blog_domain =~ m/^\./;
        $ctx->stash('blog_cookie_domain_' . $blog_id, $blog_domain);
    }
    return $blog_domain;
}

###########################################################################

=head2 UserSessionCookieName

Returns the value of the C<UserSessionCookieName> configuration setting.
If the setting contains the C<%b> string, it will replaced with the blog ID
of the blog currently in context.

B<Example:>

    <$mt:UserSessionCookieName$>

=for tags comments, configuration

=cut

sub _hdlr_user_session_cookie_name {
    my ($ctx) = @_;
    my $name = $ctx->{config}->UserSessionCookieName;
    if ($name =~ m/%b/) {
        my $blog_id = '0';
        if (my $blog = $ctx->stash('blog')) {
            $blog_id = $blog->id;
        }
        $name =~ s/%b/$blog_id/g;
    }
    return $name;
}

###########################################################################

=head2 CommenterName

The name of the commenter for the comment currently in context.

B<Example:>

    <$mt:CommenterName$>

=for tags comments

=cut

sub _hdlr_commenter_name {
    my ($ctx) = @_;
    my $a = $ctx->stash('commenter');
    my $name = $a ? $a->nickname || '' : '';
    $name = _hdlr_comment_author($ctx) unless $name;
    return $name;
}

###########################################################################

=head2 CommenterEmail

The email address of the commenter. The spam_protect global filter may
be used.

B<Example:>

    <$mt:CommenterEmail$>

=for tags comments

=cut

sub _hdlr_commenter_email {
    my ($ctx) = @_;
    my $a = $ctx->stash('commenter');
    return '' if $a && $a->email !~ m/@/;
    return $a ? $a->email || '' : '';
}

###########################################################################

=head2 CommenterAuthType

Returns a string which identifies what authentication provider the commenter
in context used to authenticate him/herself. Commenter context is created by
either MTComments or MTCommentReplies template tag. For example, 'MT' will be
returned when the commenter in context is authenticated by Movable Type. When
the commenter in context is authenticated by Vox, 'Vox' will be returned.

B<Example:>

    <mt:Comments>
      <$mt:CommenterName$> (<$mt:CommenterAuthType$>) said:
      <$mt:CommentBody$>
    </mt:Comments>

=for tags comments, authentication

=cut

sub _hdlr_commenter_auth_type {
    my ($ctx) = @_;
    my $a = $ctx->stash('commenter');
    return $a ? $a->auth_type || '' : '';
}

###########################################################################

=head2 CommenterAuthIconURL

Returns URL to a small (16x16) image represents in what authentication
provider the commenter in context is authenticated. Commenter context
is created by either a L<Comments> or L<CommentReplies> block tag. For
commenters authenticated by Movable Type, it will be a small spanner
logo of Movable Type. Otherwise, icon image is provided by each of
authentication provider. Movable Type provides images for Vox,
LiveJournal and OpenID out of the box.

B<Example:>

    <mt:Comments>
        <$mt:CommenterName$><$mt:CommenterAuthIconURL$>:
        <$mt:CommentBody$>
    </mt:Comments>

=for tags comments, authentication

=cut

sub _hdlr_commenter_auth_icon_url {
    my ($ctx, $args) = @_;
    my $a = $ctx->stash('commenter');
    return q() unless $a;
    my $size = $args->{size} || 'logo_small';
    my $url = $a->auth_icon_url($size);
    if ($url =~ m!^/!) {
        # relative path, prepend blog domain
        my $blog = $ctx->stash('blog');
        if ($blog) {
            my ($blog_domain) = $blog->archive_url =~ m|(.+://[^/]+)|;
            $url = $blog_domain . $url;
        }
    }
    return $url;
}

###########################################################################

=head2 CommenterIfTrusted

Deprecated in favor of the L<IfCommenterTrusted> tag.

=for tags deprecated

=cut

###########################################################################

=head2 IfCommenterTrusted

A conditional tag that displays its contents if the commenter in context
has been marked as trusted.

=for tags comments, authentication

=cut

sub _hdlr_commenter_trusted {
    my ($ctx, $args, $cond) = @_;
    my $a = $ctx->stash('commenter');
    return '' unless $a;
    if ($a->is_trusted($ctx->stash('blog_id'))) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 IfCommenterIsAuthor

Conditional tag that is true when the current comment was left
by a user who is also a native MT user.

=cut

###########################################################################

=head2 IfCommenterIsEntryAuthor

Conditional tag that is true when the current comment was left
by the author of the current entry in context.

=for tags comments

=cut

sub _hdlr_commenter_isauthor {
    my ($ctx, $args, $cond) = @_;
    my $a = $ctx->stash('commenter');
    return 0 unless $a;
    if ($a->type == MT::Author::AUTHOR()) {
        my $tag = lc $ctx->stash('tag');
        if ($tag eq 'ifcommenterisentryauthor') {
            my $c = $ctx->stash('comment');
            my $e = $c ? $c->entry : $ctx->stash('entry');
            if ($e) {
                if ($e->author_id == $a->id) {
                    return 1;
                }
            }
        } else {
            return 1;
        }
    }
    return 0;
}

###########################################################################

=head2 CommenterID

Outputs the numeric ID of the current commenter in context.

=for tags comments

=cut

sub _hdlr_commenter_id {
    my ($ctx) = @_;
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    my $cmntr = $ctx->stash('commenter') or return '';
    return $cmntr->id;
}

###########################################################################

=head2 CommenterURL

Outputs the URL from the profile of the current commenter in context.

=for tags comments

=cut

sub _hdlr_commenter_url {
    my ($ctx) = @_;
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    my $cmntr = $_[0]->stash('commenter') or return '';
    return $cmntr->url;
}

###########################################################################

=head2 CommenterUserpic

This template tag returns a complete HTML C<img> tag for the current
commenter's userpic. For example:

    <img src="http://yourblog.com/userpics/1.jpg" width="100" height="100" />

B<Example:>

    <h2>Recent Commenters</h2>
    <mt:Entries recently_commented_on="10">
        <div class="userpic" style="float: left; padding: 5px;"><$mt:CommenterUserpic$></div>
    </mt:Entries>

=for tags comments

=cut

sub _hdlr_commenter_userpic {
    my ($ctx) = @_;
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    my $cmntr = $ctx->stash('commenter') or return '';
    return $cmntr->userpic_html() || '';
}

###########################################################################

=head2 CommenterUserpicURL

This template tag returns the URL to the image of the current
commenter's userpic.

B<Example:>

    <img src="<$mt:CommenterUserpicURL$>" />

=for tags comments

=cut

sub _hdlr_commenter_userpic_url {
    my ($ctx) = @_;
    my $cmntr = $ctx->stash('commenter') or return '';
    return $cmntr->userpic_url() || '';
}

###########################################################################

=head2 CommenterUserpicAsset

This template tag is a container tag that puts the current commenter's
userpic asset in context. Because userpics are stored as assets within
Movable Type, this allows you to utilize all of the asset-related
template tags when displaying a user's userpic.

B<Example:>

     <mt:CommenterUserpicAsset>
        <img src="<$mt:AssetThumbnailURL width="20" height="20"$>"
            width="20" height="20"  />
     </mt:CommenterUserpicAsset>

=for tags comments, assets

=cut

sub _hdlr_commenter_userpic_asset {
    my ($ctx, $args, $cond) = @_;
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    my $cmntr = $ctx->stash('commenter');
    # undef means commenter has no commenter_id
    # need default userpic asset? do nothing now.
    return '' unless $cmntr;

    my $asset = $cmntr->userpic or return '';

    my $tok = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');

    local $ctx->{__stash}{asset} = $asset;
    $builder->build($ctx, $tok, { %$cond });
}

###########################################################################

=head2 FeedbackScore

Outputs the numeric junk score calculated for the current comment or
TrackBack ping in context. Outputs '0' if no score is present.
A negative number indicates spam.

=cut

sub _hdlr_feedback_score {
    my ($ctx) = @_;
    my $fb = $ctx->stash('comment') || $ctx->stash('ping');
    $fb ? $fb->junk_score || 0 : '';
}

###########################################################################

=head2 ArchivePrevious

A container tag that creates a context to the "previous" archive
relative to the current archive context.

This tag also works with the else tag to produce content if there is no
"previous" archive.

B<Attributes:>

=over 4

=item * type or archive_type (optional)

Specifies the "previous" archive type the context is for. See
the L<ArchiveList> tag for supported values for this attribute.

=back

B<Example:>

    <mt:ArchivePrevious>
      <a href="<$mt:ArchiveLink$>"
        title="<$mt:ArchiveTitle escape="html"$>">Next</a>
    <mt:Else>
       <!-- output when no previous archive is available -->
    </mt:ArchivePrevious>

=for tags archives

=cut

###########################################################################

=head2 ArchiveNext

A container tag that creates a context to the "next" archive relative to
the current archive context.

This tag also works with the else tag to produce content if there is no
"next" archive.

B<Attributes:>

=over 4

=item * type or archive_type (optional)

Specifies the "next" archive type the context is for. See the L<ArchiveList>
tag for supported values for this attribute.

=back

B<Example:>

    <mt:ArchiveNext>
      <a href="<$mt:ArchiveLink$>"
        title="<$mt:ArchiveTitle escape="html"$>">Next</a>
    <mt:Else>
       <!-- output when no next archive is available -->
    </mt:ArchiveNext>

=for tags archives

=cut

## Archives
sub _hdlr_archive_prev_next {
    my($ctx, $args, $cond) = @_;
    my $tag = lc $ctx->stash('tag');
    my $is_prev = $tag eq 'archiveprevious';
    my $res = '';
    my $at = ($args->{type} || $args->{archive_type}) || $ctx->{current_archive_type} || $ctx->{archive_type};
    my $arctype = MT->publisher->archiver($at);
    return '' unless $arctype;

    my $entry;
    if ($arctype->date_based && $arctype->category_based) {
        my $param = {
            ts       => $ctx->{current_timestamp},
            blog_id  => $ctx->stash('blog_id'),
            category => $ctx->stash('archive_category'),
        };
        $entry = $is_prev ? $arctype->previous_archive_entry($param) : $arctype->next_archive_entry($param);
    } elsif ($arctype->date_based && $arctype->author_based) {
        my $param = {
            ts       => $ctx->{current_timestamp},
            blog_id  => $ctx->stash('blog_id'),
            author   => $ctx->stash('author'),
        };
        $entry = $is_prev ? $arctype->previous_archive_entry($param) : $arctype->next_archive_entry($param);
    } elsif ($arctype->category_based) {
        return _hdlr_category_prevnext(@_);
    } elsif ($arctype->author_based) {
        if ($is_prev) {
            $ctx->stash('tag', 'AuthorPrevious');
        } else {
            $ctx->stash('tag', 'AuthorNext');
        }
        return _hdlr_author_next_prev(@_);
    } elsif ($arctype->entry_based) {
        my $e = $ctx->stash('entry');
        if ($is_prev) {
            $entry = $e->previous(1);
        } else {
            $entry = $e->next(1);
        }
    } else {
        my $ts = $ctx->{current_timestamp}
            or return $ctx->error(MT->translate(
               "You used an [_1] tag without a date context set up.", "MT$tag" ));
        return $ctx->error(MT->translate(
            "[_1] can be used only with Daily, Weekly, or Monthly archives.",
            "<MT$tag>" ))
            unless $arctype->date_based;
        my $param = {
            ts => $ctx->{current_timestamp},
            blog_id => $ctx->stash('blog_id'),
        };
        $entry = $is_prev ? $arctype->previous_archive_entry($param) : $arctype->next_archive_entry($param);
    }
    if ($entry) {
        my $builder = $ctx->stash('builder');
        local $ctx->{__stash}->{entries} = [ $entry ];
        if (my($start, $end) = $arctype->date_range($entry->authored_on)) {
            local $ctx->{current_timestamp} = $start;
            local $ctx->{current_timestamp_end} = $end;
            defined(my $out = $builder->build($ctx, $ctx->stash('tokens'),
                $cond))
                or return $ctx->error( $builder->errstr );
            $res .= $out;
        } else {
            local $ctx->{current_timestamp} = $entry->authored_on;
            local $ctx->{current_timestamp_end} = $entry->authored_on;
            defined(my $out = $builder->build($ctx, $ctx->stash('tokens'),
                $cond))
                or return $ctx->error( $builder->errstr );
            $res .= $out;
        }
    }
    $res;
}

###########################################################################

=head2 IndexList

A block tag that builds a list of all available index templates, sorting
them by name.

=cut

sub _hdlr_index_list {
    my ($ctx, $args, $cond) = @_;
    my $tokens = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');
    my $iter = MT::Template->load_iter({ type => 'index',
                                         blog_id => $ctx->stash('blog_id') },
                                       { 'sort' => 'name' });
    my $res = '';
    while (my $tmpl = $iter->()) {
        local $ctx->{__stash}{'index'} = $tmpl;
        defined(my $out = $builder->build($ctx, $tokens, $cond)) or
            return $ctx->error( $builder->errstr );
        $res .= $out;
    }
    $res;
}

###########################################################################

=head2 IndexLink

Outputs the URL for the current index template in context. Used in
an L<IndexList> tag.

B<Attributes:>

=over 4

=item * with_index (optional; default "0")

If enabled, will retain the "index.html" (or similar index filename)
in the link.

=back

=cut

sub _hdlr_index_link {
    my ($ctx, $args, $cond) = @_;
    my $idx = $ctx->stash('index');
    return '' unless $idx;
    my $blog = $ctx->stash('blog');
    my $path = $blog->site_url;
    $path .= '/' unless $path =~ m!/$!;
    $path .= $idx->outfile;
    $path = MT::Util::strip_index($path, $blog) unless $args->{with_index};
    $path;
}

###########################################################################

=head2 IndexName

Outputs the name for the current index template in context. Used in
an L<IndexList> tag.

=cut

sub _hdlr_index_name {
    my ($ctx, $args, $cond) = @_;
    my $idx = $ctx->stash('index');
    return '' unless $idx;
    $idx->name || '';
}

###########################################################################

=head2 IndexBasename

Outputs the C<IndexBasename> MT configuration setting.

B<Attributes:>

=over 4

=item * extension (optional; default "0")

If specified, will append the blog's configured file extension.

=back

=cut

sub _hdlr_index_basename {
    my ($ctx, $args, $cond) = @_;
    my $name = $ctx->{config}->IndexBasename;
    if (!$args->{extension}) {
        return $name;
    }
    my $blog = $ctx->stash('blog');
    my $ext = $blog->file_extension;
    $ext = '.' . $ext if $ext;
    $name . $ext;
}

###########################################################################

=head2 Archives

A container tag representing a list of all the enabled archive types in
a blog. This tag exists to facilitate the publication of a Google sitemap
or something of a similar nature.

B<Attributes:>

=over 4

=item * type or archive_type (optional)

Specify a comma-delimited list of archive types to loop over. If you
only wish to publish a list of Individual and Category archives, you
can specify:

    <mt:ArchiveList type="Individual,Category">

=back

B<Example:>

    <mt:Archives>
        <mt:ArchiveList><mt:ArchiveLink>
        </mt:ArchiveList>
    </mt:Archives>

This will publish a link for each archive type you publish (the primary
archive links, at least).

=cut

sub _hdlr_archive_set {
    my($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $at = $args->{type} || $args->{archive_type} || $blog->archive_type;
    return '' if !$at || $at eq 'None';
    my @at = split /,/, $at;
    my $res = '';
    my $tokens = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');
    my $old_at = $blog->archive_type_preferred();
    foreach my $type (@at) {
        $blog->archive_type_preferred($type);
        local $ctx->{current_archive_type} = $type;
        defined(my $out = $builder->build($ctx, $tokens, $cond)) or
            return $ctx->error( $builder->errstr );
        $res .= $out;
    }
    $blog->archive_type_preferred($old_at);
    $res;
}

###########################################################################

=head2 ArchiveList

A container tag representing a list of all the archive pages of a
certain type.

B<Attributes:>

=over 4

=item * type or archive_type

An optional attribute that specifies the type of archives to list.
Recognized values are "Yearly", "Monthly", "Weekly", "Daily",
"Individual", "Author", "Author-Yearly", "Author-Monthly",
"Author-Weekly", "Author-Daily", "Category", "Category-Yearly",
"Category-Monthly", "Category-Weekly" and "Category-Daily" (and perhaps
others, if custom archive types are provided through third-party
plugins). The default is to list the Preferred Archive Type specified
in the blog settings.

=item * lastn (optional)

An optional attribute that can be used to limit the number of archives
in the list.

=item * sort_order (optional; default "descend")

An optional attribute that specifies the sort order of the archives
in the list. It is effective within any of the date-based and
"Individual" archive types. Recognized values are "ascend" and
"descend".

=back

B<NOTE:> You may produce an archive list of any supported archive type
even if you are not publishing that archive type. However, the
L<ArchiveLink> tag will only work for archive types you are
publishing.

B<Example:>

    <mt:ArchiveList archive_type="Monthly">
        <a href="<$mt:ArchiveLink$>"><$mt:ArchiveTitle$></a>
    </mt:ArchiveList>

Here, we're combining two L<ArchiveList> tags (the inner L<ArchiveList>
tag is bound to the date range of the year in context):

    <mt:ArchiveList type="Yearly" sort_order="ascend">
        <mt:ArchiveListHeader>
        <ul>
        </mt:ArchiveListHeader>
            <li><$mt:ArchiveDate format="%Y"$>
        <mt:ArchiveList type="Monthly" sort_order="ascend">
            <mt:ArchiveListHeader>
                <ul>
            </mt:ArchiveListHeader>
                    <li><$mt:ArchiveDate format="%b"$></li>
            <mt:ArchiveListFooter>
                </ul>
            </mt:ArchiveListFooter>
            </li>
        </mt:ArchiveList>
        <mt:ArchiveListFooter>
        </ul>
        </mt:ArchiveListFooter>
    </mt:ArchiveList>

to publish something like this:

    <ul>
        <li>2006
            <ul>
                <li>Mar</li>
                <li>Apr</li>
                <li>May</li>
            </ul>
        </li>
        <li>2007
            <ul>
                <li>Apr</li>
                <li>Jun</li>
                <li>Dec</li>
            </ul>
        </li>
    </ul>

=cut

sub _hdlr_archives {
    my($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $at = $blog->archive_type;
    return '' if !$at || $at eq 'None';
    my $arg_at;
    if ($arg_at = $args->{type} || $args->{archive_type}) {
        $at = $arg_at;
    } elsif ($blog->archive_type_preferred) {
        $at = $blog->archive_type_preferred;
    } else {
        $at = (split /,/, $at)[0];
    }

    my $archiver = MT->publisher->archiver($at);
    return '' unless $archiver;
    my $map_class = MT->model('templatemap');
    my $map = $map_class->load({ archive_type => $at, blog_id => $blog->id });
    return '' unless $map;

    my $save_stamps;
    if ($ctx->{current_archive_type} && $arg_at && ($ctx->{current_archive_type} eq $arg_at)) {
        $save_stamps = 1;
    }

    local $ctx->{current_archive_type} = $at;
    ## If we are producing a Category archive list, don't bother to
    ## handle it here--instead hand it over to <MTCategories>.
    return _hdlr_categories(@_) if $at eq 'Category';
    my %args;
    my $sort_order = lc ($args->{sort_order} || '') eq 'ascend' ? 'ascend' : 'descend';
    $args{'sort'} = 'authored_on';
    $args{direction} = $sort_order;

    my $tokens = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');
    my $res = '';
    my $i = 0;
    my $n = $args->{lastn};

    my $save_ts;
    my $save_tse;
    my $tmpl = $ctx->stash('template');

    if ( ($tmpl && $tmpl->type eq 'archive')
         && $archiver->date_based)
    {
        my $uncompiled = $ctx->stash('uncompiled') || '';
        if ($uncompiled =~ /<mt:?archivelist>?/i) {
            $save_stamps = 1;
        }
    }

    if ($save_stamps) {
        $save_ts = $ctx->{current_timestamp};
        $save_tse = $ctx->{current_timestamp_end};
        $ctx->{current_timestamp} = undef;
        $ctx->{current_timestamp_end} = undef;
    }

    my $order = $sort_order eq 'ascend' ? 'asc' : 'desc';
    my $group_iter = $archiver->archive_group_iter($ctx, $args);
    return $ctx->error(MT->translate("Group iterator failed."))
        unless defined($group_iter);

    my ($cnt, %curr) = $group_iter->();
    my %save = map { $_ => $ctx->{__stash}{$_} } keys %curr;
    my $vars = $ctx->{__stash}{vars} ||= {};
    while (defined($cnt)) {
        $i++;
        my ($next_cnt, %next) = $group_iter->();
        my $last;
        $last = 1 if $n && ($i >= $n);
        $last = 1 unless defined $next_cnt;

        my ($start, $end);
        if ($archiver->date_based) {
            ($start, $end) = ($curr{'start'}, $curr{'end'});
        } else {
            my $entry = $curr{entries}->[0] if exists($curr{entries});
            ($start, $end) = (ref $entry ? $entry->authored_on : "");
        }
        local $ctx->{current_timestamp} = $start;
        local $ctx->{current_timestamp_end} = $end;
        local $vars->{__first__} = $i == 1;
        local $vars->{__last__} = $last;
        local $vars->{__even__} = $i % 2 == 0;
        local $vars->{__odd__} = $i % 2 == 1;
        local $vars->{__counter__} = $i;
        local $ctx->{__stash}{archive_count} = $cnt;
        local $ctx->{__stash}{entries} = delay(sub{ 
            $archiver->archive_group_entries($ctx, %curr)
        }) if $archiver->group_based;
        $ctx->{__stash}{$_} = $curr{$_} for keys %curr;
        local $ctx->{inside_archive_list} = 1;

        defined(my $out = $builder->build($ctx, $tokens, { %$cond,
            ArchiveListHeader => $i == 1, ArchiveListFooter => $last }))
            or return $ctx->error( $builder->errstr );
        $res .= $out;
        last if $last;
        ($cnt, %curr) = ($next_cnt, %next);
    }

    $ctx->{__stash}{$_} = $save{$_} for keys %save;
    $ctx->{current_timestamp} = $save_ts if $save_ts;
    $ctx->{current_timestamp_end} = $save_tse if $save_tse;
    $res;
}

###########################################################################

=head2 ArchiveListHeader

The contents of this container tag will be displayed when the first
entry listed by a L<ArchiveList> tag is reached.

=for tags archives

=cut

###########################################################################

=head2 ArchiveListFooter

The contents of this container tag will be displayed when the last
entry listed by a L<ArchiveList> tag is reached.

=for tags archives

=cut

###########################################################################

=head2 ArchiveTitle

A descriptive title of the current archive. The value returned from this
tag will vary based on the archive type:

=over 4

=item * Category

The label of the category.

=item * Daily

The date in "Month, Day YYYY" form.

=item * Weekly

The range of dates in the week in "Month, Day YYYY - Month, Day YYYY"

=item * Monthly

The range of dates in the week in "Month YYYY" form.

=item * Individual

The title of the entry.

=back

B<Example:>

    <$mt:ArchiveTitle$>

=for tags archives

=cut

sub _hdlr_archive_title {
    my($ctx, $args) = @_;

    my $at = $ctx->{current_archive_type} || $ctx->{archive_type};
    return _hdlr_category_label(@_) if $at eq 'Category';

    my $archiver = MT->publisher->archiver($at);
    my @entries;
    if ($archiver->entry_based) {
        my $entries = $ctx->stash('entries');
        if (!$entries && (my $e = $ctx->stash('entry'))) {
            push @$entries, $e;
        }
        if ($entries && ref($entries) eq 'ARRAY' && $at) {
            @entries = @$entries;
        } else {
            my $blog = $ctx->stash('blog');
            if (!@entries) {
                ## This situation arises every once in awhile. We have
                ## a date-based archive page, but no entries to go on it--this
                ## might happen, for example, if you have daily archives, and
                ## you post an entry, and then you change the status to draft.
                ## The page will be rebuilt in order to empty it, but in the
                ## process, there won't be any entries in $entries. So, we
                ## build a stub MT::Entry object and set the created_on date
                ## to the current timestamp (start of day/week/month).
            
                ## But, it's not generally true that draft-izing an entry
                ## erases all of its manifestations. The individual 
                ## archive lingers, for example. --ez
                if ($at && $archiver->date_based()) {
                    my $e = MT::Entry->new;
                    $e->authored_on($ctx->{current_timestamp});
                    @entries = ($e);
                } else {
                    return $ctx->error(MT->translate(
                        "You used an [_1] tag outside of the proper context.",
                        '<$MTArchiveTitle$>' ));
                }
            }
        }
    }
    my $title = (@entries && $entries[0]) ? $archiver->archive_title($ctx, $entries[0])
        : $archiver->archive_title($ctx, $ctx->{current_timestamp});
    defined $title ? $title : '';
}

###########################################################################

=head2 ArchiveDateEnd

The ending date of the archive in context. For use with the Monthly, Weekly,
and Daily archive types only. Date format tags may be applied with the format
attribute along with the language attribute. See L<Date> tag for supported
attributes.

B<Attributes:>

=over 4

=item * format (optional)

A string that provides the format in which to publish the date. If
unspecified, the default that is appropriate for the language of the blog
is used (for English, this is "%B %e, %Y %l:%M %p"). See the L<Date>
tag for the supported formats.

=item * language (optional; defaults to blog language)

Forces the date to the format associated with the specified language.

=item * utc (optional; default "0")

Forces the date to UTC time zone.

=item * relative (optional; default "0")

Produces a relative date (relative to current date and time). Suitable for
dynamic publishing (for instance, from PHP or search result templates). If
a relative date cannot be produced (the archive date is sufficiently old),
the 'format' attribute will govern the output of the date.

=back

B<Example:>

    <$mt:ArchiveDateEnd$>

=for tags date

=cut

sub _hdlr_archive_date_end {
    my ($ctx, $args) = @_;
    my $end = $ctx->{current_timestamp_end}
        or return $ctx->error(MT->translate(
            "[_1] can be used only with Daily, Weekly, or Monthly archives.",
            '<$MTArchiveDateEnd$>' ));
    $args->{ts} = $end;
    return _hdlr_date(@_);
}

###########################################################################

=head2 ArchiveType

Publishes the identifier for the current archive type. Typically, one
of "Daily", "Weekly", "Monthly", "Yearly", "Category", "Individual",
"Page", etc.

=cut

sub _hdlr_archive_type {
    my ($ctx, $args, $cond) = @_;

    my $at = $ctx->{current_archive_type} || $ctx->{archive_type};
    $at = 'Category' if $ctx->{inside_mt_categories};
    defined $at ? $at : '';
}

###########################################################################

=head2 ArchiveLabel

An alias for the L<ArchiveTypeLabel> tag.

B<Notes:>

Deprecated in favor of the more specific tag: L<ArchiveTypeLabel>

=for tags deprecated

=cut

###########################################################################

=head2 ArchiveTypeLabel

A descriptive label of the current archive type.

The value returned from this tag will vary based on the archive type:

Daily, Weekly, Monthly, Yearly, Author, Author Daily, Author Weekly,
Author Monthly, Author Yearly, Category, Category Daily, Category Weekly,
Category Monthly, Category Yearly

B<Example:>

    <$mt:ArchiveTypeLabel$>

Related Tags: L<ArchiveType>

=for tags archives

=cut

sub _hdlr_archive_label {
    my ($ctx, $args, $cond) = @_;

    my $at = $ctx->{current_archive_type} || $ctx->{archive_type};
    $at = 'Category' if $ctx->{inside_mt_categories};
    return q() unless defined $at;
    my $archiver = MT->publisher->archiver($at);
    my $al = $archiver->archive_label;
    if ( 'CODE' eq ref($al) ) {
        $al = $al->();
    }
    return $al;
}

###########################################################################

=head2 ArchiveFile

The archive filename including file extension for the archive in context. This
can be controlled through the archive mapping section of the blog's Publishing
settings screen.

B<Example:> For the URL http://www.example.com/categories/politics.html, the
L<ArchiveFile> tag would output "politics.html".

B<Attributes:>

=over 4

=item * extension

set to '0' to exclude the file extension (ie, produce "politics" instead of
"politics.html")

=item * separator

set to '-' to force any underscore characters in the filename to dashes

=back

B<Example:>

    <$mt:ArchiveFile$>

=cut

sub _hdlr_archive_file {
    my ($ctx, $args, $cond) = @_;

    my $at = $ctx->{current_archive_type} || $ctx->{archive_type};
    $at = 'Category' if $ctx->{inside_mt_categories};
    my $archiver = MT->publisher->archiver($at);
    my $f;
    if (!$at || ($archiver->entry_based)) {
        my $e = $ctx->stash('entry');
        return $ctx->error(MT->translate("Could not determine entry")) if !$e;
        $f = $e->basename;
    } else {
        $f = $ctx->{config}->IndexBasename;
    }
    if (exists $args->{extension} && !$args->{extension}) {
    } else {
        my $blog = $ctx->stash('blog');
        if (my $ext = $blog->file_extension) {
            $f .= '.' . $ext;
        }
    }
    if ($args->{separator}) {
        if ($args->{separator} eq '-') {
            $f =~ s/_/-/g;
        }
    }
    $f;
}

###########################################################################

=head2 ArchiveLink

Publishes a link to the archive template for the current archive context.
You may specify an alternate archive type with the "type" attribute to
publish a different archive link.

B<Attributes:>

=over 4

=item * type (optional)

=item * archive_type (optional)

Identifies the specific archive type to generate a link for. If unspecified,
uses the current archive type in context, when publishing an archive
template.

=item * with_index (optional; default "0")

If specified, forces any index filename to be included in the link to
the archive page.

=back

B<Example:>

When publishing an entry archive template, you can use the
following tag to get a link to the appropriate Monthly archive template
relevant to that entry (in other words, if the entry was published in March
2008, the archive link tag would output a permalink for the March 2008
archives).

    <$MTArchiveLink type="Monthly"$>

=cut

sub _hdlr_archive_link {
    my($ctx, $args) = @_;

    my $at = $args->{type} || $args->{archive_type};
    return _hdlr_category_archive(@_)
        if ($at && ('Category' eq $at)) ||
           ($ctx->{current_archive_type} && 'Category' eq $ctx->{current_archive_type});

    $at ||= $ctx->{current_archive_type} || $ctx->{archive_type};
    my $archiver = MT->publisher->archiver($at);
    return '' unless $archiver;

    my $blog = $ctx->stash('blog');
    my $entry;
    if ($archiver->entry_based) {
        $entry = $ctx->stash('entry');
    }
    my $author = $ctx->stash('author');

    #return $ctx->error(MT->translate(
    #    "You used an [_1] tag outside of the proper context.",
    #    '<$MTArchiveLink$>' ))
    #    unless $ctx->{current_timestamp} || $entry;

    my $cat;
    if ($archiver->category_based) {
        $cat = $ctx->stash('category') || $ctx->stash('archive_category');
    }

    return $ctx->error(MT->translate(
        "You used an [_1] tag for linking into '[_2]' archives, but that archive type is not published.", '<$MTArchiveLink$>', $at))
        unless $blog->has_archive_type($at);

    my $arch = $blog->archive_url;
    $arch = $blog->site_url if $entry && $entry->class eq 'page';
    $arch .= '/' unless $arch =~ m!/$!;
    $arch .= archive_file_for($entry, $blog, $at, $cat, undef,
                              $ctx->{current_timestamp}, $author);
    $arch = MT::Util::strip_index($arch, $blog) unless $args->{with_index};
    return $arch;
}

###########################################################################

=head2 ArchiveCount

This tag will potentially return two different values depending upon the
context in which it is invoked.

If invoked within L<Categories> this tag will behave as if it was an alias
to L<CategoryCount>.

Otherwise it will return the number corresponding to the number of entries
currently in context. For example within any L<Entries> context, this tag
will return the number of entries that that L<Entries> tag corresponds to.

B<Example:>

    <mt:Categories>
        There are <$mt:ArchiveCount$> entries in the <$mt:CategoryLabel$>
        category.
    </mt:Categories>

=for tags count

=cut

sub _hdlr_archive_count {
    my ($ctx, $args, $cond) = @_;
    my $at = $ctx->{current_archive_type} || $ctx->{archive_type};
    my $archiver = MT->publisher->archiver($at);
    if ($ctx->{inside_mt_categories} && !$archiver->date_based) {
        return _hdlr_category_count($ctx);
    } elsif (my $count = $ctx->stash('archive_count')) {
        return $ctx->count_format($count, $args);
    }

    my $e = $ctx->stash('entries');
    my @entries = @$e if ref($e) eq 'ARRAY';
    my $count = scalar @entries;
    return $ctx->count_format($count, $args);
}

###########################################################################

=head2 ArchiveCategory

This tag has been deprecated in favor of L<CategoryLabel>.
Returns the label of the current category.

B<Example:>

    <$mt:ArchiveCategory$>

=for tags deprecated

=cut

sub _hdlr_archive_category {
    return &_hdlr_category_label;
}

###########################################################################

=head2 ImageURL

Outputs the uploaded image URL (used only for the system
template for uploaded images).

=cut

sub _hdlr_image_url {
    my ($ctx) = @_;
    return $ctx->stash('image_url');
}

###########################################################################

=head2 ImageWidth

Outputs the uploaded image width in pixels (used only for the system
template for uploaded images).

=cut

sub _hdlr_image_width {
    my ($ctx) = @_;
    return $ctx->stash('image_width');
}

###########################################################################

=head2 ImageHeight

Outputs the uploaded image height in pixels (used only for the system
template for uploaded images).

=cut

sub _hdlr_image_height {
    my ($ctx) = @_;
    return $ctx->stash('image_height');
}

###########################################################################

=head2 Calendar

A container tag representing a calendar month that lists a single
calendar "cell" in the calendar display.

B<Attributes:>

=over 4

=item * month

An optional attribute that specifies the calendar month and year the
tagset is to generate. The value must be in YYYYMM format. The month
attribute also recognizes two special values. Given a value of "last",
the calendar will be generated for the previous month from the current
date. Using a value of "this" will generate a calendar for the
current month.

The default behavior is to generate a monthly calendar based on the
archive in context. When used in the context of an archive type
other then "Category," the calendar will be generated for the month
in which the archive falls.

=item * category

An optional attribute that specifies the name of a category from which
to return entries.

=back

B<Example:>

To produce a calendar for January, 2002 of entries in the category "Foo":

    <mt:Calendar month="200201" category="Foo">
        ...
    </mt:Calendar>

=for tags calendar

=cut

sub _hdlr_calendar {
    my($ctx, $args, $cond) = @_;
    my $blog_id = $ctx->stash('blog_id');
    my($prefix);
    my @ts = offset_time_list(time, $blog_id);
    my $today = sprintf "%04d%02d", $ts[5]+1900, $ts[4]+1;
    if ($prefix = lc($args->{month}||'')) {
        if ($prefix eq 'this') {
            my $ts = $ctx->{current_timestamp}
                or return $ctx->error(MT->translate(
                    "You used an [_1] tag without a date context set up.",
                    qq(<MTCalendar month="this">) ));
            $prefix = substr $ts, 0, 6;
        } elsif ($prefix eq 'last') {
            my $year = substr $today, 0, 4;
            my $month = substr $today, 4, 2;
            if ($month - 1 == 0) {
                $prefix = $year - 1 . "12";
            } else {
                $prefix = $year . $month - 1;
            }
        } else {
            return $ctx->error(MT->translate(
                "Invalid month format: must be YYYYMM" ))
                unless length($prefix) eq 6;
        }
    } else {
        $prefix = $today;
    }
    my($cat_name, $cat);
    if ($cat_name = $args->{category}) {
        $cat = MT::Category->load({ label => $cat_name, blog_id => $blog_id })
            or return $ctx->error(MT->translate(
                "No such category '[_1]'", $cat_name ));
    } else {
        $cat_name = '';    ## For looking up cached calendars.
    }
    my $uncompiled = $ctx->stash('uncompiled') || '';
    my $r = MT::Request->instance;
    my $calendar_cache = $r->cache('calendar');
    unless ($calendar_cache) {
        $r->cache('calendar', $calendar_cache = { });
    }
    if (exists $calendar_cache->{$prefix . $cat_name} &&
        $calendar_cache->{$prefix . $cat_name}{'uc'} eq $uncompiled) {
        return $calendar_cache->{$prefix . $cat_name}{output};
    }
    $today .= sprintf "%02d", $ts[3];
    my($start, $end) = start_end_month($prefix);
    my($y, $m) = unpack 'A4A2', $prefix;
    my $days_in_month = days_in($m, $y);
    my $pad_start = wday_from_ts($y, $m, 1);
    my $pad_end = 6 - wday_from_ts($y, $m, $days_in_month);
    my $iter = MT::Entry->load_iter({ blog_id => $blog_id,
                                      authored_on => [ $start, $end ],
                                      status => MT::Entry::RELEASE() },
        { range_incl => { authored_on => 1 },
          'sort' => 'authored_on',
          direction => 'ascend', });
    my @left;
    my $res = '';
    my $tokens = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');
    my $iter_drained = 0;
    for my $day (1..$pad_start+$days_in_month+$pad_end) {
        my $is_padding =
            $day < $pad_start+1 || $day > $pad_start+$days_in_month;
        my($this_day, @entries) = ('');
        local($ctx->{__stash}{entries}, $ctx->{__stash}{calendar_day},
              $ctx->{current_timestamp}, $ctx->{current_timestamp_end});
        local $ctx->{__stash}{calendar_cell} = $day;
        unless ($is_padding) {
            $this_day = $prefix . sprintf("%02d", $day - $pad_start);
            my $no_loop = 0;
            if (@left) {
                if (substr($left[0]->authored_on, 0, 8) eq $this_day) {
                    @entries = @left;
                    @left = ();
                } else {
                    $no_loop = 1;
                }
            }
            unless ($no_loop || $iter_drained) {
                while (my $entry = $iter->()) {
                    next unless !$cat || $entry->is_in_category($cat);
                    my $e_day = substr $entry->authored_on, 0, 8;
                    push(@left, $entry), last
                        unless $e_day eq $this_day;
                    push @entries, $entry;
                }
                $iter_drained++ unless @left;
            }
            $ctx->{__stash}{entries} = \@entries;
            $ctx->{current_timestamp} = $this_day . '000000';
            $ctx->{current_timestamp_end} = $this_day . '235959';
            $ctx->{__stash}{calendar_day} = $day - $pad_start;
        }
        defined(my $out = $builder->build($ctx, $tokens, {
            %$cond,
            CalendarWeekHeader => ($day-1) % 7 == 0,
            CalendarWeekFooter => $day % 7 == 0,
            CalendarIfEntries => !$is_padding && scalar @entries,
            CalendarIfNoEntries => !$is_padding && !(scalar @entries),
            CalendarIfToday => ($today eq $this_day),
            CalendarIfBlank => $is_padding,
        })) or
            return $ctx->error( $builder->errstr );
        $res .= $out;
    }
    $calendar_cache->{$prefix . $cat_name} =
        { output => $res, 'uc' => $uncompiled };
    return $res;
}

###########################################################################

=head2 CalendarIfBlank

A conditional tag that will display its contents if the current calendar
cell is for a day in another month.

B<Example:>

    <mt:CalendarIfBlank>&nbsp;</mt:CalendarIfBlank>

=for tags calendar

=cut

###########################################################################

=head2 CalendarIfEntries

A conditional tag that will display its contents if there are any
entries for this day in the blog.

B<Example:>

    <mt:CalendarIfEntries>
        <mt:Entries limit="1">
        <a href="<$mt:ArchiveLink type="Daily"$>">
            <$mt:CalendarDay$>
        </a>
        </mt:Entries>
    </mt:CalendarIfEntries>

=for tags calendar, entries

=cut

###########################################################################

=head2 CalendarIfNoEntries

A conditional tag that will display its contents if there are not entries
for this day in the blog. This tag predates the introduction of L<Else>,
a tag that could be used with L<CalendarIfEntries> to replace
C<CalendarIfNoEntries>.

=for tags calendar, entries

=cut

###########################################################################

=head2 CalendarDate

The timestamp of the current day of the month. Date format tags may be
applied with the format attribute along with the language attribute.

B<Example:>

    <$mt:CalendarDate$>

=for tags calendar, date

=cut

###########################################################################

=head2 CalendarIfToday

A conditional tag that will display its contents if the current cell
is for the current day.

=for tags calendar

=cut

###########################################################################

=head2 CalendarWeekHeader

A conditional tag that will display its contents before a calendar
week is started.

B<Example:>

    <mt:CalendarWeekHeader><tr></mt:CalendarWeekHeader>

=for tags calendar

=cut

###########################################################################

=head2 CalendarWeekFooter

A conditional tag that will display its contents before a calendar
week is ended.

B<Example:>

    <mt:CalendarWeekFooter></tr></mt:CalendarWeekFooter>

=for tags calendar

=cut

###########################################################################

=head2 CalendarDay

The numeric day of the month for the cell of the calendar being published.
This tag may only be used inside a L<Calendar> tag.

B<Example:>

    <$mt:CalendarDay$>

=for tags calendar

=cut

sub _hdlr_calendar_day {
    my ($ctx) = @_;
    my $day = $ctx->stash('calendar_day')
        or return $ctx->error(MT->translate(
            "You used an [_1] tag outside of the proper context.",
            '<$MTCalendarDay$>' ));
    return $day;
}

###########################################################################

=head2 CalendarCellNumber

The number of the "cell" in the calendar, beginning with 1. The count
begins with the first cell regardless of whether a day of the month
falls on it. This tag may only be used inside a L<Calendar> tag.

B<Example:>

    <$mt:CalendarCellNumber$>

=for tags calendar

=cut

sub _hdlr_calendar_cell_num {
    my ($ctx) = @_;
    my $num = $ctx->stash('calendar_cell')
        or return $ctx->error(MT->translate(
            "You used an [_1] tag outside of the proper context.",
            '<$MTCalendarCellNumber$>' ));
    return $num;
}

###########################################################################

=head2 Categories

Produces a list of categories defined for the current blog.

=for tags multiblog

=cut

sub _hdlr_categories {
    my($ctx, $args, $cond) = @_;
    my (%terms, %args);
    $ctx->set_blog_load_context($args, \%terms, \%args)
        or return $ctx->error($ctx->errstr);
    require MT::Placement;
    $args{'sort'} = 'label';
    $args{'direction'} = 'ascend';

    my $class_type = $args->{class_type} || 'category';
    my $class = MT->model($class_type);
    my $entry_class = MT->model(
        $class_type eq 'category' ? 'entry' : 'page');
    my %counts;
    my $count_tag = $class_type eq 'category' ? 'CategoryCount'
                  :                             'FolderCount'
                  ;
    my $uncompiled = $ctx->stash('uncompiled') || '';
    my $count_all = 0;
    if (!$args->{show_empty} || $uncompiled =~ /<\$?mt:?$count_tag/i) {
        $count_all = 1;
    }

    ## Supplies a routine that will yield the number of entries associated
    ## with the category in context in the most efficient manner.
    ## If we can determine counts will be gathered for all categories,
    ## a 'count_group_by' request is done for MT::Placement to fetch counts
    ## with a single query (storing them in %counts). 
    ## Otherwise, counts are collected on an as-needed basis, using the
    ## 'entry_count' method in MT::Category.
    my $counts_fetched = 0;
    my $entry_count_of = sub {
          my $cat = shift;
          return delay(sub{$cat->entry_count})
              unless $count_all;
          return $cat->entry_count(defined $counts{$cat->id} ? $counts{$cat->id} : 0)
              if $counts_fetched;
          return $cat->cache_property(
              'entry_count',
              sub{
                  # issue a single count_group_by for all categories
                  my $cnt_iter = MT::Placement->count_group_by(
                      {%terms},
                      {
                          group => ['category_id'],
                          join  => $entry_class->join_on(
                              undef,
                              {
                                  id     => \'=placement_entry_id',
                                  status => MT::Entry::RELEASE(),
                              }
                          ),
                      }
                  ); 
                  while (my ($count, $cat_id) = $cnt_iter->()) {
                      $counts{$cat_id} = $count;
                  }
                  $counts_fetched = 1;
                  $counts{$cat->id};
              }
        );
    };

    my $iter = $class->load_iter(\%terms, \%args);
    my $res = '';
    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');
    my $glue = $args->{glue};
    ## In order for this handler to double as the handler for
    ## <MTArchiveList archive_type="Category">, it needs to support
    ## the <$MTArchiveLink$> and <$MTArchiveTitle$> tags
    local $ctx->{inside_mt_categories} = 1;
    my $i = 0;
    my $cat = $iter->();
    if ( !$args->{show_empty} ) {
        while ( defined $cat && !$entry_count_of->($cat) ) {
            $cat = $iter->();
        }
    }
    my $n = $args->{lastn};
    my $vars = $ctx->{__stash}{vars} ||= {};
    while (defined($cat)) {
        $i++;
        my $next_cat = $iter->();
        if ( !$args->{show_empty} ) {
            while ( defined $next_cat && !$entry_count_of->($next_cat) ) {
                $next_cat = $iter->();
            }
        }
        my $last;
        $last = 1 if $n && ($i >= $n);
        $last = 1 unless defined $next_cat;

        local $ctx->{__stash}{category} = $cat;
        local $ctx->{__stash}{entries};
        local $ctx->{__stash}{category_count};
        local $ctx->{__stash}{blog_id} = $cat->blog_id;
        local $ctx->{__stash}{blog} = MT::Blog->load($cat->blog_id);
        local $ctx->{__stash}{folder_header} = ($i == 1) if $class_type ne 'category';
        local $ctx->{__stash}{folder_footer} = ($last) if $class_type ne 'category';
        local $vars->{__first__} = $i == 1;
        local $vars->{__last__} = $last;
        local $vars->{__odd__} = ($i % 2) == 1;
        local $vars->{__even__} = ($i % 2) == 0;
        local $vars->{__counter__} = $i;
        $ctx->{__stash}{category_count} = $entry_count_of->($cat);
        defined(my $out = $builder->build($ctx, $tokens,
            { %$cond,
              ArchiveListHeader => $i == 1,
              ArchiveListFooter => $last }))
            or return $ctx->error( $builder->errstr );
        $res .= $glue if defined $glue && length($res) && length($out);
        $res .= $out;
        last if $last;
        $cat = $next_cat;
    }
    $res;
}

###########################################################################

=head2 CategoryID

The numeric system ID of the category.

B<Example:>

    <$mt:CategoryID$>

=for tags categories

=cut

sub _hdlr_category_id {
    my ($ctx) = @_;
    my $cat = ($ctx->stash('category') || $ctx->stash('archive_category'))
        or return $ctx->error(MT->translate(
            "You used an [_1] tag outside of the proper context.",
            '<$MT'.$ctx->stash('tag').'$>'));
    return $cat->id;
}

###########################################################################

=head2 CategoryLabel

The label of the category in context. The current category in context can be
placed there by either the following contexts (in order of precedence):

=over 4

=item * the current category you might be by looping through a list of categories

=item * the current category archive template/mapping you are in

=item * the primary category of the current entry in context

=back

B<Example:>

    <$mt:CategoryLabel$>

=for tags categories

=cut

sub _hdlr_category_label {
    my ($ctx, $args, $cond) = @_;
    my $class_type = $args->{class_type} || 'category';
    my $e = $ctx->stash('entry');
    my $cat = ($ctx->stash('category') || $ctx->stash('archive_category'))
        || (($e = $ctx->stash('entry')) && $e->category)
        or return (defined($args->{default}) ? $args->{default} : 
                    $ctx->error(MT->translate(
                           "You used an [_1] tag outside of the proper context.",
                           '<$MT'.$ctx->stash('tag').'$>')));
    my $label = $cat->label;
    $label = '' unless defined $label;
    return $label;
}

###########################################################################

=head2 CategoryBasename

Produces the dirified basename defined for the category in context.

B<Attributes:>

=over 4

=item * default

A value to use in the event that no category is in context.

=item * separator

Valid values are "_" and "-", dash is the default value. Specifying an
underscore will convert any dashes to underscores. Specifying a dash will
convert any underscores to dashes.

=back

B<Example:>

    <$mt:CategoryBasename$>

=cut

sub _hdlr_category_basename {
    my ($ctx, $args, $cond) = @_;
    my $class_type = $args->{class_type} || 'category';
    my $e = $ctx->stash('entry');
    my $cat = ($ctx->stash('category') || $ctx->stash('archive_category'))
        || (($e = $ctx->stash('entry')) && $e->category)
        or return (defined($args->{default}) ? $args->{default} : 
                    $ctx->error(MT->translate(
                           "You used an [_1] tag outside of the proper context.",
                           '<$MT'.$ctx->stash('tag').'$>')));
    my $basename = $cat->basename || '';
    if (my $sep = $args->{separator}) {
        if ($sep eq '-') {
            $basename =~ s/_/-/g;
        } elsif ($sep eq '_') {
            $basename =~ s/-/_/g;
        }
    }
    return $basename;
}

###########################################################################

=head2 CategoryDescription

The description for the category in context.

B<Example:>

    <$mt:CategoryDescription$>

=cut

sub _hdlr_category_desc {
    my ($ctx) = @_;
    my $cat = ($ctx->stash('category') || $ctx->stash('archive_category'))
        or return $ctx->error(MT->translate(
            "You used an [_1] tag outside of the proper context.",
            '<$MT'.$ctx->stash('tag').'$>'));
    return defined $cat->description ? $cat->description : '';
}

###########################################################################

=head2 CategoryCount

The number of published entries for the category in context.

B<Example:>

    Entries in this category: <$mt:CategoryCount$>

=for tags categories, count

=cut

sub _hdlr_category_count {
    my ($ctx, $args, $cond) = @_;
    my $cat = ($ctx->stash('category') || $ctx->stash('archive_category'))
        or return $ctx->error(MT->translate(
            "You used an [_1] tag outside of the proper context.",
            '<$MT' . $ctx->stash('tag') . '$>'));
    my $count = $ctx->stash('category_count');
    $count = $cat->entry_count unless defined $count;
    return $ctx->count_format($count, $args);
}

###########################################################################

=head2 CategoryCommentCount

This template tag returns the number of comments found within a category.

B<Example:>

    <ul><mt:Categories>
        <li><$mt:CategoryLabel$> (<$mt:CategoryCommentCount$>)</li>
    </mt:Categories></ul>

=for tags categories, comments

=cut

sub _hdlr_category_comment_count {
    my ($ctx, $args, $cond) = @_;
    my $cat = ($ctx->stash('category') || $ctx->stash('archive_category'))
        or return $ctx->error(MT->translate(
            "You used an [_1] tag outside of the proper context.",
            '<$MT' . $ctx->stash('tag') . '$>'));
    my($count);
    my $blog_id = $ctx->stash ('blog_id');
    my $class = MT->model(
        $ctx->stash('tag') =~ m/Category/ig ? 'entry' : 'page');
    my @args = ({ blog_id => $blog_id, visible => 1 },
                { 'join' => MT::Entry->join_on(undef,
                              { id => \'= comment_entry_id',
                              status => MT::Entry::RELEASE(),
                              blog_id => $blog_id, },
                              { 'join' => MT::Placement->join_on('entry_id', { category_id => $cat->id, blog_id => $blog_id } ) } ) } );
    require MT::Comment;
    $count = scalar MT::Comment->count(@args);
    return $ctx->count_format($count, $args);
}

###########################################################################

=head2 CategoryArchiveLink

A link to the archive page of the category.

B<Example:>

    <$mt:CategoryArchiveLink$>

=cut

sub _hdlr_category_archive {
    my ($ctx, $args) = @_;
    my $cat = ($ctx->stash('category') || $ctx->stash('archive_category'))
        or return $ctx->error(MT->translate(
            "You used an [_1] tag outside of the proper context.",
            '<$MTCategoryArchiveLink$>' ));
    my $curr_at = $ctx->{current_archive_type} || $ctx->{archive_type} || 'Category';

    my $blog = $ctx->stash('blog');
    return '' unless $blog || $curr_at eq 'Category';
    if ( $curr_at ne 'Category' ) {
        # Check if "Category" archive is published
        my $at = $blog->archive_type;
        my @at = split /,/, $at;
        my $cat_arc = 0;
        for (@at) {
            if ( 'Category' eq $_ ) {
                $cat_arc = 1;
                last;
            }
        }
        return $ctx->error(MT->translate(
            "[_1] cannot be used without publishing Category archive.",
            '<$MTCategoryArchiveLink$>' )) unless $cat_arc;
    }

    my $arch = $blog->archive_url;
    $arch .= '/' unless $arch =~ m!/$!;
    $arch = $arch . archive_file_for(undef, $blog, 'Category', $cat);
    $arch = MT::Util::strip_index($arch, $blog) unless $args->{with_index};
    $arch;
}

###########################################################################

=head2 CategoryTrackbackLink

The URL that TrackBack pings can be sent for the category in context.

B<Example:>

    <$mt:CategoryTrackbackLink$>

=cut

sub _hdlr_category_tb_link {
    my($ctx, $args) = @_;
    my $cat = $ctx->stash('category') || $ctx->stash('archive_category');
    if (!$cat) {
        my $cat_name = $args->{category}
            or return $ctx->error(MT->translate("<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the 'category' attribute to the tag."));
        $cat = MT::Category->load({ label => $cat_name,
                                    blog_id => $ctx->stash('blog_id') })
            or return $ctx->error("No such category '$cat_name'");
    }
    require MT::Trackback;
    my $tb = MT::Trackback->load({ category_id => $cat->id })
        or return '';
    my $cfg = $ctx->{config};
    my $path = _hdlr_cgi_path($ctx);
    return $path . $cfg->TrackbackScript . '/' . $tb->id;
}

###########################################################################

=head2 CategoryIfAllowPings

A conditional tag that displays its contents if pings are enabled for
the category in context.

=for tags categories, pings

=cut

sub _hdlr_category_allow_pings {
    my ($ctx) = @_;
    my $cat = $ctx->stash('category') || $ctx->stash('archive_category');
    return $cat->allow_pings ? 1 : 0;
}

###########################################################################

=head2 CategoryTrackbackCount

The number of published TrackBack pings for the category in context.

B<Example:>

    <$mt:CategoryTrackbackCount$>

=for tags categories, pings, count

=cut

sub _hdlr_category_tb_count {
    my($ctx, $args) = @_;
    my $cat = $ctx->stash('category') || $ctx->stash('archive_category');
    return 0 unless $cat;
    require MT::Trackback;
    my $tb = MT::Trackback->load( { category_id => $cat->id } );
    return 0 unless $tb;
    require MT::TBPing;
    my $count = MT::TBPing->count( { tb_id => $tb->id, visible => 1 } );
    return $ctx->count_format($count || 0, $args);
}

sub _load_sibling_categories {
    my ($ctx, $cat, $class_type) = @_;
    my $blog_id = $cat->blog_id;
    my $r = MT::Request->instance;
    my $cats = $r->stash('__cat_cache_'.$blog_id.'_'.$cat->parent);
    return $cats if $cats;

    my $class = MT->model($class_type);
    my @cats = $class->load({blog_id => $blog_id, parent => $cat->parent},
                            {'sort' => 'label', direction => 'ascend'});
    $r->stash('__cat_cache_'.$blog_id.'_'.$cat->parent, \@cats);
    \@cats;
}

###########################################################################

=head2 CategoryPrevious

A container tag which creates a category context of the previous
category relative to the current entry category or archived category.

If the current category has sub-categories, then CategoryPrevious
will generate a link to the previous sibling category. For example,
in the following category hierarchy:

    News
        Gossip
        Politics
        Sports
    Events
        Oakland
        Palo Alto
        San Francisco
    Sports
        Local College
        MBA
        NFL

If the current category is "Events" then CategoryPrevious will link to
"News". If the current category is "San Francisco" then CategoryPrevious
will link to "Palo Alto".

B<Attributes:>

=over 4

=item * show_empty

Specifies whether categories with no entries assigned should be counted.

=back

B<Example:>

    <mt:CategoryPrevious>
        <a href="<$mt:ArchiveLink archive_type="Category"$>"><$mt:CategoryLabel$></a>
    </mt:CategoryPrevious>

=for tags categories, archives

=cut

###########################################################################

=head2 CategoryNext

A container tag which creates a category context of the next category
relative to the current entry category or archived category.

If the current category has sub-categories, then CategoryNext will
generate a link to the next sibling category. For example, in the
following category hierarchy:

    News
        Gossip
        Politics
        Sports
    Events
        Oakland
        Palo Alto
        San Francisco
    Sports
        Local College
        MBA
        NFL

If the current category is "News" then CategoryNext will link to
"Events". If the current category is "Oakland" then CategoryNext will
link to "Palo Alto".

B<Attributes:>

=over 4

=item * show_empty

Specifies whether categories with no entries assigned should be
counted and displayed.

=back

=for tags categories, archives

=cut

sub _hdlr_category_prevnext {
    my ($ctx, $args, $cond) = @_;
    my $class_type = $args->{class_type} || 'category';
    my $e = $ctx->stash('entry');
    my $tag = $ctx->stash('tag');
    my $step = $tag =~ m/Next/i ? 1 : -1;
    my $cat = $e ?
        $e->category ?
            $e->category
            : ($ctx->stash('category') || $ctx->stash('archive_category'))
        : ($ctx->stash('category') || $ctx->stash('archive_category'));
    return $ctx->error(MT->translate(
        "You used an [_1] tag outside of the proper context.",
        "<MT$tag>" )) if !defined $cat;
    require MT::Placement;
    my $needs_entries;
    my $uncompiled = $ctx->stash('uncompiled') || '';
    $needs_entries = $class_type eq 'category' ?
        (($uncompiled =~ /<MT:?Entries/i) ? 1 : 0) :
        (($uncompiled =~ /<MT:?Pages/i) ? 1 : 0);
    my $blog_id = $cat->blog_id;
    my $cats = _load_sibling_categories($ctx, $cat, $class_type);
    my ($pos, $idx);
    $idx = 0;
    foreach (@$cats) {
        $pos = $idx, last if $_->id == $cat->id;
        $idx++;
    }
    return '' unless defined $pos;
    $pos += $step;
    while ( $pos >= 0 && $pos < scalar @$cats ) {
        if (!exists $cats->[$pos]->{_placement_count}) {
            if ($needs_entries) {
                require MT::Entry;
                my @entries = MT::Entry->load({ blog_id => $blog_id,
                                            status => MT::Entry::RELEASE() },
                            { 'join' => [ 'MT::Placement', 'entry_id',
                                        { category_id => $cat->id } ],
                              'sort' => 'authored_on',
                              direction => 'descend', });
                $cats->[$pos]->{_entries} = \@entries;
                $cats->[$pos]->{_placement_count} = scalar @entries;
            } else {
                $cats->[$pos]->{_placement_count} =
                    MT::Placement->count({ category_id => $cats->[$pos]->id });
            }
        }
        $pos += $step, next
            unless $cats->[$pos]->{_placement_count} || $args->{show_empty};
        local $ctx->{__stash}{category} = $cats->[$pos];
        local $ctx->{__stash}{entries} = $cats->[$pos]->{_entries} if $needs_entries;
        local $ctx->{__stash}{category_count} = $cats->[$pos]->{_placement_count};
        return _hdlr_pass_tokens($ctx, $args, $cond);
    }
    return '';
}

###########################################################################

=head2 IfCategory

A conditional tag used to test for category assignments for the entry
in context, or generically to test for which category is in context.

B<Attributes:>

=over 4

=item * name (or label; optional)

The name of a category. If given, tests the category in context (or
categories of an entry in context) to see if it matches with the given
category name.

=item * type (optional)

Either the keyword "primary" or "secondary". Used to test whether the
specified category (specified by the name or label attribute) is a
primary or secondary category assignment for the entry in context.

=back

B<Examples:>

    <mt:IfCategory>
        (current entry in context has a category assignment)
    </mt:IfCategory>

    <mt:IfCategory type="secondary">
        (current entry in context has one or more secondary category)
    </mt:IfCategory>

    <mt:IfCategory name="News">
        (current entry in context is assigned to the "News" category)
    </mt:IfCategory>

    <mt:IfCategory name="News" type="primary">
        (current entry in context has a "News" category as its primary category)
    </mt:IfCategory>

=for tags entries, categories

=cut

###########################################################################

=head2 EntryIfCategory

This tag has been deprecated in favor of L<IfCategory>.

=for tags deprecated

=cut

sub _hdlr_if_category {
    my ($ctx, $args, $cond) = @_;
    my $e = $ctx->stash('entry');
    my $tag = lc $ctx->stash('tag');
    my $entry_context = $tag =~ m/(entry|page)if(category|folder)/;
    return $ctx->_no_entry_error() if $entry_context && !$e;
    my $name = $args->{name} || $args->{label};
    my $primary = $args->{type} && ($args->{type} eq 'primary');
    my $secondary = $args->{type} && ($args->{type} eq 'secondary');
    $entry_context ||= ($primary || $secondary);
    my $cat = $entry_context ? $e->category : ($ctx->stash('category') || $ctx->stash('archive_category'));
    if (!$cat && $e && !$entry_context) {
        $cat = $e->category;
        $entry_context = 1;
    }
    my $cats;
    if ($cat && ($primary || !$entry_context)) {
        $cats = [ $cat ];
    } elsif ($e) { 
        $cats = $e->categories;
    }
    if ($secondary && $cat) {
        my @cats = grep { $_->id != $cat->id } @$cats;
        $cats = \@cats;
    }
    if (!defined $name) {
        return @$cats ? 1 : 0;
    }
    foreach my $cat (@$cats) {
        return 1 if $cat->label eq $name;
    }
    0;
}

###########################################################################

=head2 EntryAdditionalCategories

This block tag iterates over all secondary categories for the entry in
context. Must be used in an entry context (entry archive or L<Entries> loop).

All categories can be listed using L<EntryCategories> loop tag.

=for tags entries, categories

=cut

sub _hdlr_entry_additional_categories {
    my($ctx, $args, $cond) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $cats = $e->categories;
    return '' unless $cats && @$cats;
    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');
    my $res = '';
    my $glue = $args->{glue};
    for my $cat (@$cats) {
        next if $e->category && ($cat->label eq $e->category->label);
        local $ctx->{__stash}->{category} = $cat;
        defined(my $out = $builder->build($ctx, $tokens, $cond))
            or return $ctx->error( $builder->errstr );
        $res .= $glue if defined $glue && length($res) && length($out);
        $res .= $out if length($out);
    }
    $res;
}

###########################################################################

=head2 Pings

A context-sensitive container tag that lists all of the pings sent
to a particular entry, category or blog. If used in an entry context
the tagset will list all pings for the entry. Likewise for a
TrackBack-enabled category in context. If not in an entry or category
context, a blog context is assumed and all associated pings are listed.

B<Attributes:>

=over 4

=item * category

This attribute creates a specific category context regardless of
its placement.

=item * lastn

Display the last N pings in context. N is a positive integer.

=item * sort_order

Specifies the sort order. Recognized values are "ascend" (default) and
"descend."

=back

=for tags pings, multiblog

=cut

sub _hdlr_pings {
    my($ctx, $args, $cond) = @_;
    require MT::Trackback;
    require MT::TBPing;
    my($tb, $cat);
    my $blog = $ctx->stash('blog');
    nofollowfy_on($args) if ($blog->nofollow_urls);

    if (my $e = $ctx->stash('entry')) {
        $tb = $e->trackback;
        return '' unless $tb;
    } elsif ($cat = $ctx->stash('archive_category')) {
        $tb = MT::Trackback->load({ category_id => $cat->id });
        return '' unless $tb;
    } elsif (my $cat_name = $args->{category}) {
        $cat = MT::Category->load({ label => $cat_name,
                                    blog_id => $ctx->stash('blog_id') })
            or return $ctx->error(MT->translate("No such category '[_1]'", $cat_name));
        $tb = MT::Trackback->load({ category_id => $cat->id });
        return '' unless $tb;
    }
    my $res = '';
    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');
    my (%terms, %args);
    $ctx->set_blog_load_context($args, \%terms, \%args)
        or return $ctx->error($ctx->errstr);
    $terms{tb_id} = $tb->id if $tb;
    $terms{visible} = 1;
    $args{'sort'} = 'created_on';
    $args{'direction'} = $args->{sort_order} || 'ascend';
    if (my $limit = $args->{lastn}) {
        $args{direction} = $args->{sort_order} || 'descend';
        $args{limit} = $limit;
    }
    my @pings = MT::TBPing->load(\%terms, \%args);
    my $count = 0;
    my $max = scalar @pings;
    my $vars = $ctx->{__stash}{vars} ||= {};
    for my $ping (@pings) {
        $count++;
        local $ctx->{__stash}{ping} = $ping;
        local $ctx->{__stash}{blog} = $ping->blog;
        local $ctx->{__stash}{blog_id} = $ping->blog_id;
        local $ctx->{current_timestamp} = $ping->created_on;
        local $vars->{__first__} = $count == 1;
        local $vars->{__last__} = ($count == ($max));
        local $vars->{__odd__} = ($count % 2) == 1;
        local $vars->{__even__} = ($count % 2) == 0;
        local $vars->{__counter__} = $count;
        my $out = $builder->build($ctx, $tokens, { %$cond,
            PingsHeader => $count == 1, PingsFooter => ($count == $max) });
        return $ctx->error( $builder->errstr ) unless defined $out;
        $res .= $out;
    }
    $res;
}

###########################################################################

=head2 PingsHeader

The contents of this container tag will be displayed when the first
ping listed by a L<Pings> tag is reached.

=for tags pings

=cut

###########################################################################

=head2 PingsFooter

The contents of this container tag will be displayed when the last
ping listed by a L<Pings> tag is reached.

=for tags pings

=cut

###########################################################################

=head2 PingsSent

A container tag representing a list of TrackBack pings sent from an
entry. Use the L<PingsSentURL> tag to display the URL pinged.

B<Example:>

    <h4>Ping'd</h4>
    <ul>
    <mt:PingsSent>
        <li><$mt:PingsSentURL$></li>
    </mt:PingsSent>
    </ul>

=for tags pings, entries

=cut

sub _hdlr_pings_sent {
    my($ctx, $args, $cond) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');
    my $res = '';
    my $pings = $e->pinged_url_list;
    for my $url (@$pings) {
        $ctx->stash('ping_sent_url', $url);
        defined(my $out = $builder->build($ctx, $tokens, $cond))
            or return $ctx->error($builder->errstr);
        $res .= $out;
    }
    $res;
}

###########################################################################

=head2 PingsSentURL

The URL of the TrackBack ping was sent to. This is the TrackBack Ping URL
and not a permalink.

B<Example:>

    <$mt:PingsSentURL$>

=for tags pings

=cut

sub _hdlr_pings_sent_url {
    my ($ctx) = @_;
    return $ctx->stash('ping_sent_url');
}

###########################################################################

=head2 PingDate

The timestamp of when the ping was submitted. Date format tags may be
applied with the format attribute along with the language attribute.

B<Attributes:>

=over 4

=item * format (optional)

A string that provides the format in which to publish the date. If
unspecified, the default that is appropriate for the language of the blog
is used (for English, this is "%B %e, %Y %l:%M %p"). See the L<Date>
tag for the supported formats.

=item * language (optional; defaults to blog language)

Forces the date to the format associated with the specified language.

=item * utc (optional; default "0")

Forces the date to UTC time zone.

=item * relative (optional; default "0")

Produces a relative date (relative to current date and time). Suitable for
dynamic publishing (for instance, from PHP or search result templates). If
a relative date cannot be produced (the archive date is sufficiently old),
the 'format' attribute will govern the output of the date.

=back

B<Example:>

    <$mt:PingDate$>

=for tags pings, date

=cut

sub _hdlr_ping_date {
    my ($ctx, $args) = @_;
    my $p = $ctx->stash('ping')
        or return $ctx->_no_ping_error();
    $args->{ts} = $p->created_on;
    return _hdlr_date($ctx, $args);
}

###########################################################################

=head2 PingID

A numeric system ID of the TrackBack ping in context.

B<Example:>

    <$mt:PingID$>

=for tags pings

=cut

sub _hdlr_ping_id {
    my ($ctx) = @_;
    my $ping = $ctx->stash('ping')
        or return $ctx->_no_ping_error();
    return $ping->id;
}

###########################################################################

=head2 PingTitle

The title of the remote resource that the TrackBack ping sent.

B<Example:>

    <$mt:PingTitle$>

=for tags pings

=cut

sub _hdlr_ping_title {
    my ($ctx, $args) = @_;
    sanitize_on($args);
    my $ping = $ctx->stash('ping')
        or return $ctx->_no_ping_error();
    return defined $ping->title ? $ping->title : '';
}

###########################################################################

=head2 PingURL

The URL of the remote resource that the TrackBack ping sent.

B<Example:>

    <$mt:PingURL$>

=for tags pings

=cut

sub _hdlr_ping_url {
    my ($ctx, $args) = @_;
    sanitize_on($args);
    my $ping = $ctx->stash('ping')
        or return $ctx->_no_ping_error();
    return defined $ping->source_url ? $ping->source_url : '';
}

###########################################################################

=head2 PingExcerpt

An excerpt describing the URL of the ping sent.

B<Example:>

    <$mt:PingExcerpt$>

=for tags pings

=cut

sub _hdlr_ping_excerpt {
    my ($ctx, $args) = @_;
    sanitize_on($args);
    my $ping = $ctx->stash('ping')
        or return $ctx->_no_ping_error();
    return defined $ping->excerpt ? $ping->excerpt : '';
}

###########################################################################

=head2 PingIP

The IP (Internet Protocol) network address the TrackBack ping was sent
from.

B<Example:>

    <$mt:PingIP$>

=for tags pings

=cut

sub _hdlr_ping_ip {
    my ($ctx) = @_;
    my $ping = $ctx->stash('ping')
        or return $ctx->_no_ping_error();
    return defined $ping->ip ? $ping->ip : '';
}

###########################################################################

=head2 PingBlogName

The site name that sent the TrackBack ping.

B<Example:>

    <$mt:BlogName$>

=for tags pings

=cut

sub _hdlr_ping_blog_name {
    my ($ctx, $args) = @_;
    sanitize_on($args);
    my $ping = $ctx->stash('ping')
        or return $ctx->_no_ping_error();
    return defined $ping->blog_name ? $ping->blog_name : '';
}

###########################################################################

=head2 PingEntry

Provides an entry context for the parent entry of the TrackBack ping
in context.

B<Example:>

    Last TrackBack received was for the entry
    titled:
    <mt:Pings lastn="1">
        <mt:PingEntry>
            <$mt:EntryTitle$>
        </mt:PingEntry>
    </mt:Pings>

=for tags pings, entries

=cut

sub _hdlr_ping_entry {
    my ($ctx, $args, $cond) = @_;
    my $ping = $ctx->stash('ping')
        or return $ctx->_no_ping_error();
    require MT::Trackback;
    my $tb = MT::Trackback->load($ping->tb_id);
    return '' unless $tb;
    return '' unless $tb->entry_id;
    my $entry = MT::Entry->load($tb->entry_id)
        or return '';
    local $ctx->{__stash}{entry} = $entry;
    local $ctx->{current_timestamp} = $entry->authored_on;
    $ctx->stash('builder')->build($ctx, $ctx->stash('tokens'), $cond);
}

###########################################################################

=head2 IfAllowCommentHTML

Conditional block that is true when the blog has been configured to
permit HTML in comments.

=for tags comments

=cut

sub _hdlr_if_allow_comment_html {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    if ($blog->allow_comment_html) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 IfCommentsAllowed

Conditional block that is true when the blog is configured to accept
comments, and comments are accepted on a system-wide basis. This tag
does not take the current entry context into account; use the
L<IfCommentsAccepted> tag for this.

=for tags comments, configuration

=cut

sub _hdlr_if_comments_allowed {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $cfg = $ctx->{config};
    if ((!$blog || ($blog && ($blog->allow_unreg_comments
                              || ($blog->allow_reg_comments
                                  && $blog->effective_remote_auth_token))))
        && $cfg->AllowComments) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 IfCommentsActive

Conditional tag that displays its contents if comments are enabled or
comments exist for the entry in context.

=for tags comments, entries

=cut

# comments exist in stash OR entry context allows comments
sub _hdlr_if_comments_active {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $cfg = $ctx->{config};
    my $active;
    if (my $entry = $ctx->stash('entry')) {
        $active = 1 if ($blog->accepts_comments && $entry->allow_comments
                        && $cfg->AllowComments);
        $active = 1 if $entry->comment_count;
    } else {
        $active = 1 if ($blog->accepts_comments && $cfg->AllowComments);
    }
    if ($active) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 IfCommentsAccepted

Conditional tag that displays its contents if commenting is enabled for
the entry in context.

B<Example:>

    <mt:IfCommentsAccepted>
        <h3>What do you think?</h3>
        (comment form)
    </mt:IfCommentsAccepted>

=for tags comments, entries, configuration

=cut

sub _hdlr_if_comments_accepted {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $cfg = $ctx->{config};
    my $entry = $ctx->stash('entry');
    my $blog_comments_accepted = $blog->accepts_comments && $cfg->AllowComments;
    my $accepted = $blog_comments_accepted;
    $accepted = 0 if $entry && !$entry->allow_comments;
    if ($accepted) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 IfPingsActive

Conditional tag that displays its contents if TrackBack pings are
enabled or pings exist for the entry in context.

=for tags entries, pings

=cut

sub _hdlr_if_pings_active {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $cfg = $ctx->{config};
    my $entry = $ctx->stash('entry');
    my $active;
    $active = 1 if $cfg->AllowPings && $blog->allow_pings;
    $active = 0 if $entry && !$entry->allow_pings;
    $active = 1 if !$active && $entry && $entry->ping_count;
    if ($active) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 IfPingsModerated

Conditional tag that is positive when the blog has a policy to moderate
all incoming pings by default.

=cut

sub _hdlr_if_pings_moderated {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    if ($blog->moderate_pings) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 IfPingsAccepted

Conditional tag that is positive when pings are allowed for the blog
and the entry (if one is in context) and the MT installation.

=cut

sub _hdlr_if_pings_accepted {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $cfg = $ctx->{config};
    my $accepted;
    my $entry = $ctx->stash('entry');
    $accepted = 1 if $blog->allow_pings && $cfg->AllowPings;
    $accepted = 0 if $entry && !$entry->allow_pings;
    if ($accepted) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 IfPingsAllowed

Conditional tag that is positive when pings are allowed by the blog
and the MT installation (does not test for an entry context).

=cut

sub _hdlr_if_pings_allowed {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $cfg = $ctx->{config};
    if ($blog->allow_pings && $cfg->AllowPings) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 IfNeedEmail

Conditional tag that is positive when the blog is configured to
require an e-mail address for anonymous comments.

=cut

###########################################################################

=head2 IfRequireCommentEmails

Conditional tag that is positive when the blog is configured to
require an e-mail address for anonymous comments.

=cut

sub _hdlr_if_need_email {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $cfg = $ctx->{config};
    if ($blog->require_comment_emails) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 EntryIfAllowComments

Conditional tag that is positive when the entry in context is
configured to allow commenting and the blog and MT installation
also permits comments.

=cut

sub _hdlr_entry_if_allow_comments {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $cfg = $ctx->{config};
    my $blog_comments_accepted = $blog->accepts_comments && $cfg->AllowComments;
    my $entry = $ctx->stash('entry');
    if ($blog_comments_accepted && $entry->allow_comments) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 EntryIfCommentsOpen

Deprecated in favor of L<EntryIfCommentsActive>.

=for tags deprecated

=cut

sub _hdlr_entry_if_comments_open {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $cfg = $ctx->{config};
    my $blog_comments_accepted = $blog->accepts_comments && $cfg->AllowComments;
    my $entry = $ctx->stash('entry');
    if ($entry && $blog_comments_accepted && $entry->allow_comments && $entry->allow_comments eq '1') {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 EntryIfAllowPings

Deprecated in favor of L<IfPingsAccepted>.

=for tags deprecated

=cut

sub _hdlr_entry_if_allow_pings {
    my ($ctx, $args, $cond) = @_;
    my $entry = $ctx->stash('entry');
    my $blog = $ctx->stash('blog');
    my $cfg = $ctx->{config};
    my $blog_pings_accepted = 1 if $cfg->AllowPings && $blog->allow_pings;
    if ($blog_pings_accepted && $entry->allow_pings) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 EntryIfExtended

Conditional tag that is positive when content is in the extended text
field of the current entry in context.

=cut

sub _hdlr_entry_if_extended {
    my ($ctx, $args, $cond) = @_;
    my $entry = $ctx->stash('entry');
    my $more = '';
    if ($entry) {
        $more = $entry->text_more;
        $more = '' unless defined $more;
        $more =~ s!(^\s+|\s+$)!!g;
    }
    if ($more ne '') {
        return 1;
    } else {
        return 0;
    }
}

# FIXME: Unused?
sub _hdlr_if_commenter_pending {
    my ($ctx, $args, $cond) = @_;
    my $cmtr = $ctx->stash('commenter');
    my $blog = $ctx->stash('blog');
    if ($cmtr && $blog && $cmtr->commenter_status($blog->id) == MT::Author::PENDING()) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 SubCatIsFirst

The contents of this container tag will be displayed when the first
category listed by a L<SubCategories> tag is reached.

=for tags categories

=cut

sub _hdlr_sub_cat_is_first {
    my ($ctx) = @_;
    return $ctx->stash('subCatIsFirst');
}

###########################################################################

=head2 SubCatIsLast

The contents of this container tag will be displayed when the last
category listed by a L<SubCategories> tag is reached.

=for tags categories

=cut

sub _hdlr_sub_cat_is_last {
    my ($ctx) = @_;
    return $ctx->stash('subCatIsLast');
}

###########################################################################

=head2 SubCatsRecurse

Recursively call the L<SubCategories> or L<TopLevelCategories> container
with the subcategories of the category in context. This tag, when placed
at the end of loop controlled by one of the tags above will cause them
to recursively descend into any subcategories that exist during the loop.

B<Attributes:>

=over 4

=item * max_depth (optional)

An optional attribute that specifies the maximum number of times the system
should recurse. The default is infinite depth.

=back

B<Examples:>

The following code prints out a recursive list of categories/subcategories, linking those with entries assigned to their category archive pages.

    <mt:TopLevelCategories>
      <mt:SubCatIsFirst><ul></mt:SubCatIsFirst>
        <mt:If tag="CategoryCount">
            <li><a href="<$mt:CategoryArchiveLink$>"
            title="<$mt:CategoryDescription$>"><mt:CategoryLabel></a>
        <mt:Else>
            <li><$mt:CategoryLabel$>
        </mt:If>
        <$mt:SubCatsRecurse$>
        </li>
    <mt:SubCatIsLast></ul></mt:SubCatIsLast>
    </mt:TopLevelCategories>

Or more simply:

    <mt:TopLevelCategories>
        <$mt:CategoryLabel$>
        <$mt:SubCatsRecurse$>
    </mt:TopLevelCategories>

=for tags categories

=cut

sub _hdlr_sub_cats_recurse {
    my ($ctx, $args) = @_;
    my $class_type = $args->{class_type} || 'category';
    my $class = MT->model($class_type);
    my $entry_class = MT->model(
        $class_type eq 'category' ? 'entry' : 'page');
  
    # Make sure were in the right context
    # mostly to see if we have anything to actually build
    my $tokens = $ctx->stash('subCatTokens') 
        or return $ctx->error(
            MT->translate("[_1] used outside of [_2]",
              $class_type eq 'category'
              ? (qw(MTSubCatRecurse MTSubCategories))
              : (qw(MTSubFolderRecurse MTSubFolders))
            )
        );
    my $builder = $ctx->stash('builder');
  
    my $cat = $ctx->stash('category');
  
    # Get the depth info
    my $max_depth = $args->{max_depth};
    my $depth = $ctx->stash('subCatsDepth') || 0;

    # Get the sorting info
    my $sort_method = $ctx->stash('subCatsSortMethod');
    my $sort_order  = $ctx->stash('subCatsSortOrder');

    # If we're too deep, return an emtry string because we're done
    return '' if ($max_depth && $depth >= $max_depth);
 
    my $cats = _sort_cats($ctx, $sort_method, $sort_order, [ $cat->children_categories ])
        or return $ctx->error($ctx->errstr);

    # Init variables
    my $count = 0;
    my $res = '';

    # Loop through each immediate child, incrementing the depth by 1
    while (my $c = shift @$cats) {
        next if (!defined $c);
        local $ctx->{__stash}{'category'} = $c;
        local $ctx->{__stash}{'subCatIsFirst'} = !$count;
        local $ctx->{__stash}{'subCatIsLast'} = !scalar @$cats;
        local $ctx->{__stash}{'subCatsDepth'} = $depth + 1;
        local $ctx->{__stash}{vars}->{'__depth__'} = $depth + 1;
        local $ctx->{__stash}{'folder_header'} = !$count
            if $class_type ne 'category';
        local $ctx->{__stash}{'folder_footer'} = !scalar @$cats
            if $class_type ne 'category';

        local $ctx->{__stash}{'category_count'};

        local $ctx->{__stash}{'entries'} = 
            delay(sub { my @args = ({ blog_id => $ctx->stash('blog_id'),
                                 status => MT::Entry::RELEASE() },
                               { 'join' => [ 'MT::Placement', 'entry_id',
                                             { category_id => $c->id } ],
                                 'sort' => 'authored_on',
                                 direction => 'descend', });

                   my @entries = $entry_class->load(@args); 
                   \@entries });

        defined (my $out = $builder->build($ctx, $tokens))
            or return $ctx->error($ctx->errstr);

        $res .= $out;
        $count++;
    }

    $res;
}

###########################################################################

=head2 TopLevelCategories

A block tag listing the categories that do not have a parent and exist at
"the top" of the category hierarchy. Same as using
C<E<lt>mt:SubCategories top="1"E<gt>>.

=for tags categories

=cut

sub _hdlr_top_level_categories {
    my ($ctx, $args, $cond) = @_;

    # Unset the normaly hiding places for categories so
    # MTSubCategories doesn't pick them up
    local $ctx->{__stash}{'category'} = undef;
    local $ctx->{__stash}{'archive_category'} = undef;
    local $args->{top} = 1;

    # Call MTSubCategories
    &_hdlr_sub_categories;
}

###########################################################################

=head2 SubCategories

A specialized version of the L<Categories> container tag that respects the
hierarchical structure of categories.

B<Attributes:>

=over 4

=item * include_current

An optional boolean attribute that controls the inclusion of the
current category in the list.

=item * sort_method

An optional and advanced usage attribute. A fully qualified Perl method
name to be used to sort the categories.

=item * sort_order

Specifies the sort order of the category labels. Recognized values
are "ascend" and "descend." The default is "ascend." This attribute is
ignored if sort_method has been set.

=item * top

If set to 1, displays only top level categories. Same as using
L<TopLevelCategories>.

=item * category

Specifies a specific category by name for which to return subcategories.

=item * glue

=back

=for tags categories

=cut

sub _hdlr_sub_categories {
    my ($ctx, $args, $cond) = @_;

    my $class_type = $args->{class_type} || 'category';
    my $class = MT->model($class_type);
    my $entry_class = MT->model(
        $class_type eq 'category' ? 'entry' : 'page');
    
    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');

    # Do we want the current category?
    my $include_current = $args->{include_current};

    # Sorting information
    #   sort_order ::= 'ascend' | 'descend'
    #   sort_method ::= method name (e.g. package::method)
    #
    # sort_method takes precedence
    my $sort_order = $args->{sort_order} || 'ascend';
    my $sort_method = $args->{sort_method};

    # Store the tokens for recursion
    $ctx->stash('subCatTokens', $tokens);
  
    my $current_cat;
    my @cats;
  
    if ($args->{top}) {
        @cats = $class->top_level_categories($ctx->stash('blog_id'));
    } else {
        # Use explicit category or category context
        if ($args->{category}) {
            # user specified category; list from this category down
            ($current_cat) = cat_path_to_category($args->{category}, $ctx->stash('blog_id'), $class_type);
        } else {
            $current_cat = $ctx->stash('category') || $ctx->stash('archive_category');
        }
        if ($current_cat) {
            if ($include_current) {
                # If we're to include it, just use it to seed the category list
                @cats = ($current_cat);
            } else {
                # Otherwise, use its children
                @cats = $current_cat->children_categories;
            }
        }
    }
    return '' unless @cats;
  
    my $cats = _sort_cats($ctx, $sort_method, $sort_order, \@cats)
        or return $ctx->error($ctx->errstr);
 
    # Init variables
    my $count = 0;
    my $res = '';

    # Be sure the regular MT tags know we're in a category context
    local $ctx->{inside_mt_categories} = 1;

    local $ctx->{__stash}{'subCatsSortOrder'} = $sort_order;
    local $ctx->{__stash}{'subCatsSortMethod'} = $sort_method;

    # Loop through the immediate children (or the current cat,
    # depending on the arguments
    while (my $cat = shift @$cats) {
        next if (!defined $cat);
        local $ctx->{__stash}{'category'} = $cat;
        local $ctx->{__stash}{'subCatIsFirst'} = !$count;
        local $ctx->{__stash}{'subCatIsLast'} = !scalar @$cats;
        local $ctx->{__stash}{'folder_header'} = !$count
            if $class_type ne 'category';
        local $ctx->{__stash}{'folder_footer'} = !scalar @$cats
            if $class_type ne 'category';

        local $ctx->{__stash}{'category_count'};

        local $ctx->{__stash}{'entries'} =
            delay(sub { my @args = ({ blog_id => $ctx->stash('blog_id'),
                                 status => MT::Entry::RELEASE() },
                               { 'join' => [ 'MT::Placement', 'entry_id',
                                             { category_id => $cat->id } ],
                                 'sort' => 'authored_on',
                                 direction => 'descend' });

                   my @entries = $entry_class->load(@args); 
                   \@entries } );

        defined (my $out = $builder->build($ctx, $tokens, $cond))
            or return $ctx->error($ctx->errstr);

        $res .= $out;
        $count++;
    }

    $res;
}

###########################################################################

=head2 ParentCategory

A container tag that creates a context to the current category's parent.

B<Example:>

    <mt:ParentCategory>
        Up: <a href="<mt:ArchiveLink>"><mt:CategoryLabel></a>
    </mt:ParentCategory>

=for tags categories

=cut

sub _hdlr_parent_category {
    my ($ctx, $args, $cond) = @_;

    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');

    # Get the current category
    my $cat = _get_category_context($ctx);
    return if !defined($cat) && defined($ctx->errstr);
    return '' if ($cat eq '');

    # The category must have a parent, otherwise return empty string
    my $parent = $cat->parent_category or return '';

    # Setup the context and let 'er rip
    local $ctx->{__stash}->{category} = $parent;
    defined (my $out = $builder->build($ctx, $tokens, $cond))
        or return $ctx->error($ctx->errstr);

    $out;
}

###########################################################################

=head2 ParentCategories

A block tag that lists all the ancestors of the current category.

B<Attributes:>

=over 4

=item * glue

This optional attribute is a shortcut for connecting each category
label with its value. Single and double quotes are not permitted in
the string.

=item * exclude_current

This optional boolean attribute controls the exclusion of the
current category in the list.

=back

=for tags categories

=cut

sub _hdlr_parent_categories {
    my ($ctx, $args, $cond) = @_;

    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');

    # Get the arguments
    my $exclude_current = $args->{'exclude_current'};
    my $glue = $args->{'glue'};

    # Get the current category
    defined (my $cat = _get_category_context($ctx))
        or return $ctx->error($ctx->errstr);
    return '' if ($cat eq '');

    my $res = '';

    # Put together the list of parent categories
    # including the current one unless instructed otherwise
    my @cats = $cat->parent_categories;
    @cats = ($cat, @cats) unless ($exclude_current);

    # Start from the top and work our way down
    while (my $c = pop @cats) {
        local $ctx->{__stash}->{category} = $c;
        defined (my $out = $builder->build($ctx, $tokens, $cond))
            or return $ctx->error($ctx->errstr);
        if ($args->{sub_cats_path_hack} && $out !~ /\w/) {
            $out = 'cat-' . $c->id;
        }
        $res .= $glue if defined $glue && length($res) && length($out);
        $res .= $out if length($out);
    }
    $res;
}

###########################################################################

=head2 TopLevelParent

A container tag that creates a context to the top-level ancestor of
the current category.

=for tags categories

=cut

sub _hdlr_top_level_parent {
    my ($ctx, $args, $cond) = @_;

    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');

    # Get the current category
    defined (my $cat = _get_category_context($ctx))
        or return $ctx->error($ctx->errstr);
    return '' if ($cat eq '');

    my $out = "";

    # Get the list of parents
    my @parents = ($cat, $cat->parent_categories);

    # If there are any
    # Pop the top one of the list
    if (scalar @parents) {
        $cat = pop @parents;
        local $ctx->{__stash}->{category} = $cat;
        defined($out = $builder->build($ctx, $tokens, $cond))
            or return $ctx->error($ctx->errstr);
    }

    $out;
}

sub cat_path_to_category {
    my ($path, $blog_id, $class_type) = @_;

    my $class = MT->model($class_type);
    
    # The argument version always takes precedence
    # followed by the current category (i.e. MTCategories/MTSubCategories style)
    # then the current category for the archive
    # then undef
    my @cat_path = $path =~ m@(\[[^]]+?\]|[^]/]+)@g;   # split on slashes, fields quoted by []
    @cat_path = map { $_ =~ s/^\[(.*)\]$/$1/; $_ } @cat_path;       # remove any []
    my $last_cat_id = 0;
    my $cat;
    my (%blog_terms, %blog_args);
    if (ref $blog_id eq 'ARRAY') {
        %blog_terms = %{$blog_id->[0]};
        %blog_args = %{$blog_id->[1]};
    } elsif ($blog_id) {
        $blog_terms{blog_id} = $blog_id;
    }

    my $top = shift @cat_path;
    my @cats = $class->load({ label => $top,
                                    parent => 0,
                                    %blog_terms }, \%blog_args);
    if (@cats) {
        for my $label (@cat_path) {
            my @parents = map { $_->id } @cats;
            @cats = $class->load({ label => $label,
                                         parent => \@parents,
                                         %blog_terms }, \%blog_args)
                    or last;
        }
    }
    if (!@cats && $path) {
        @cats = ($class->load({
            label => $path,
            %blog_terms,
        }, \%blog_args));
    }
    @cats;
}

###########################################################################

=head2 EntriesWithSubCategories

A specialized version of L<Entries> that is aware of subcategories. The
difference between the two tags is the behavior of the category attribute.

B<Attributes:>

=over 4

=item * category

The value of this attribute is a category label. This will include
any entries to that category and any of its subcategories. Since it
is possible for two categories to have the same label, you can specify
one particular category by including its ancestors, separated by
slashes. For instance if you have a category "Flies" and within it
a subcategory labeled "Fruit", you can ask for that category with
category="Flies/Fruit". This would distinguish it from a category
labeled "Fruit" within another called "Food Groups", for example,
which could be identified using category="Food Groups/Fruit".

If any category in the ancestor chain has a slash in its label, the
label must be quoted using square brackets:
category="Beverages/[Coffee/Tea]" identifies a category labeled
Coffee/Tea within a category labeled Beverages.

=back

You can also use any of the other attributes available to L<Entries>;
and they should behave just as they do with the original tag.

=for tags entries, categories

=cut

sub _hdlr_entries_with_sub_categories {
    my ($ctx, $args, $cond) = @_;

    my $cat = $ctx->stash('category') 
         || $ctx->stash('archive_category');

    my $save_entries = defined $ctx->stash('archive_category');
    my $saved_stash_entries;

    if (defined $cat) {
        $saved_stash_entries = $ctx->{__stash}{entries} if $save_entries;
        delete $ctx->{__stash}{entries};
    }

    local $args->{include_subcategories} = 1;
    local $args->{category} ||= ['OR', [$cat]] if defined $cat;
    my $res = _hdlr_entries($ctx, $args, $cond);
    $ctx->{__stash}{entries} = $saved_stash_entries 
        if $save_entries && $saved_stash_entries;
    $res;
}

###########################################################################

=head2 SubCategoryPath

The path to the category relative to L<BlogURL>.

In other words, this tag returns a string that is a concatenation of the
current category and its ancestors. This tag is provided for convenience
and is the equivalent of the following template tags:

    <mt:ParentCategories glue="/"><mt:CategoryBasename /></mt:ParentCategories>

B<Example:>

The category "Bar" in a category "Foo" C<E<lt>$mt:SubCategoryPath$E<gt>> becomes C<foo/bar>.

=for tags categories

=cut

sub _hdlr_sub_category_path {
    my ($ctx, $args, $cond) = @_;

    my $builder = $ctx->stash('builder');
    my $dir = '';
    if ($args->{separator}) {
        $dir = "separator='$args->{separator}'";
    }
    my $tokens  = $builder->compile($ctx, "<MTCategoryBasename $dir>");
    # unfortunately, there's no way to apply a filter that would
    # take the output of the dirify step and, if it were blank,
    # use instead some other property of the category (such as the 
    # category ID). this hack tells parent_categories to do that
    # to the output of its contents.
    $args->{'sub_cats_path_hack'} = 1;

    $args->{'glue'} = '/';
    local $ctx->{__stash}->{tokens} = $tokens;
    &_hdlr_parent_categories;
}

###########################################################################

=head2 HasSubCategories

Returns true if the current category has a sub-category.

=for tags categories

=cut

sub _hdlr_has_sub_categories {
    my ($ctx, $args, $cond) = @_;

    # Get the current category context
    defined (my $cat = _get_category_context($ctx)) 
        or return $ctx->error($ctx->errstr);
    return if ($cat eq '');

    # Return the number of children for the category
    my @children = $cat->children_categories;
    scalar @children;
}

###########################################################################

=head2 HasNoSubCategories

Returns true if the current category has no sub-categories.

=for tags categories

=cut

sub _hdlr_has_no_sub_categories {
    !&_hdlr_has_sub_categories;
}

###########################################################################

=head2 HasParentCategory

Returns true if the current category has a parent category other than
the root.

=for tags categories

=cut

sub _hdlr_has_parent_category {
    my ($ctx, $args) = @_;

    # Get the current category
    defined (my $cat = _get_category_context($ctx))
        or return $ctx->error($ctx->errstr);
    return 0 if ($cat eq '');

    # Return the parent of the category
    return $cat->parent_category ? 1 : 0;
}

###########################################################################

=head2 HasNoParentCategory

Returns true if the current category does not have a parent category
other than the root.

B<Example:>

    <mt:Categories>
      <mt:HasNoParentCategory>
        <mt:CategoryLabel> is but an orphan and has no parents.
      <mt:else>
        <mt:CategoryLabel> has a parent category!
      </mt:HasNoParentCategory>
    </mt:Categories>

=for tags categories

=cut

sub _hdlr_has_no_parent_category {
    return !&_hdlr_has_parent_category;
}

###########################################################################

=head2 IfIsAncestor

Conditional tag that is true when the category in context is an ancestor
category of the specified 'child' attribute.

B<Attributes:>

=over 4

=item * child (required)

The label of a category in the current blog.

=back

B<Example:>

    <mt:IfIsAncestor child="Featured">
        (category in context is a parent category
        to a subcategory named "Featured".)
    </mt:IfIsDescendant>

=for tags categories

=cut

sub _hdlr_is_ancestor {
    my ($ctx, $args) = @_;

    # Get the current category
    defined (my $cat = _get_category_context($ctx)) or
        return $ctx->error($ctx->errstr);
    return if ($cat eq '');

    # Get the possible child category
    my $blog_id = $ctx->stash('blog_id');
    my $iter = MT::Category->load_iter({ blog_id => $blog_id,
                                         label => $args->{'child'} }) || undef;
    while (my $child = $iter->()) {
        if ($cat->is_ancestor($child)) {
            $iter->end;
            return 1;
        }
    }

    0;
}

###########################################################################

=head2 IfIsDescendant

Conditional tag that is true when the category in context is a child
category of the specified 'parent' attribute.

B<Attributes:>

=over 4

=item * parent (required)

The label of a category in the current blog.

=back

B<Example:>

    <mt:IfIsDescendant parent="Featured">
        (category in context is a child category
        to the 'Featured' category.)
    </mt:IfIsDescendant>

=for tags categories

=cut

sub _hdlr_is_descendant {
    my ($ctx, $args) = @_;

    # Get the current category
    defined (my $cat = _get_category_context($ctx)) or
        return $ctx->error($ctx->errstr);
    return if ($cat eq '');

    # Get the possible parent category
    my $blog_id = $ctx->stash('blog_id');
    my $iter = MT::Category->load_iter({ blog_id => $blog_id,
                                         label => $args->{'parent'} });
    while (my $parent = $iter->()) {
        if ($cat->is_descendant($parent)) {
            $iter->end;
            return 1;
        }
    }

    0;
}

sub _get_category_context {
    my ($ctx) = @_;
  
    my $tag = $ctx->stash('tag');

    # Get our hands on the category for the current context
    # Either in MTCategories, a Category Archive Template
    # Or the category for the current entry
    my $cat = $ctx->stash('category') ||
        $ctx->stash('archive_category');

    if (!defined $cat) { 
    
        # No category found so far, test the entry
        if ($ctx->stash('entry')) {
            $cat = $ctx->stash('entry')->category;

            # Return empty string if entry has no category
            # as the tag has been used in the correct context
            # but there is no category to work with
            return '' if (!defined $cat);
        } else {
            return $ctx->error(MT->translate("MT[_1] must be used in a [_2] context", $tag, $tag =~ m/folder/ig ? 'folder' : 'category'));
        }
    }
    return $cat;
}

sub _sort_cats {
    my ($ctx, $sort_method, $sort_order, $cats) = @_;
    my $tag = $ctx->stash('tag');

    # If sort_method is defined
    if (defined $sort_method) {
        my $package = $sort_method;

        # Check if it has a package name
        if ($package =~ /::/) {

            # Extract the package name
            $package =~ s/::[^(::)]+$//;

            # Make sure it's loaded
            eval (qq(use $package;));
            if (my $err = $@) {
                return $ctx->error(MT->translate("Cannot find package [_1]: [_2]", $package, $err));
            }
        }

        # Sort the categories based on sort_method
        eval ("\@\$cats = sort $sort_method \@\$cats");
        if (my $err = $@) {
            return $ctx->error(MT->translate("Error sorting [_2]: [_1]", $err,$tag =~ m/folder/ig ? 'folders' : 'categories'));
        }
    } else {
        if (lc $sort_order eq 'descend') {
            @$cats = sort { $b->label cmp $a->label } @$cats;
        } else {
            @$cats = sort { $a->label cmp $b->label } @$cats;
        }
    }

    return $cats;
}

###########################################################################

=head2 EntryBlogID

The numeric system ID of the blog that is parent to the entry currently
in context.

B<Example:>

    <$mt:EntryBlogID$>

=for tags entries, blogs

=cut

sub _hdlr_entry_blog_id {
    my ($ctx, $args) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    return $args && $args->{pad} ? (sprintf "%06d", $e->blog_id) : $e->blog_id;
}

###########################################################################

=head2 EntryBlogName

Returns the blog name of the blog to which the entry in context belongs.
The blog name is set in the General Blog Settings.

B<Example:>

    <$mt:EntryBlogName$>

=for tags entries, blogs

=cut

sub _hdlr_entry_blog_name {
    my ($ctx, $args) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $b = MT::Blog->load($e->blog_id)
        or return $ctx->error(MT->translate('Can\'t load blog #[_1].', $e->blog_id));
    return $b->name;
}

###########################################################################

=head2 EntryBlogDescription

Returns the blog description of the blog to which the entry in context
belongs. The blog description is set in the General Blog Settings.

B<Example:>

    <$mt:EntryBlogDescription$>

=for tags blogs, entries

=cut

sub _hdlr_entry_blog_description {
    my ($ctx, $args) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $b = MT::Blog->load($e->blog_id)
        or return $ctx->error(MT->translate('Can\'t load blog #[_1].', $e->blog_id));
    my $d = $b->description;
    return defined $d ? $d : '';
}

###########################################################################

=head2 EntryBlogURL

Returns the blog URL for the blog to which the entry in context belongs.

B<Example:>

    <$mt:EntryBlogURL$>

=for tags blogs, entries

=cut

sub _hdlr_entry_blog_url {
    my ($ctx, $args) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $b = MT::Blog->load($e->blog_id)
        or return $ctx->error(MT->translate('Can\'t load blog #[_1].', $e->blog_id));
    return $b->site_url;
}

###########################################################################

=head2 EntryEditLink

A link to edit the entry in context from the Movable Type CMS. This tag is
only recognized in system templates where an authenticated user is
logged-in.

B<Attributes:>

=over 4

=item * text (optional; default "Edit")

A phrase to use for the edit link.

=back

B<Example:>

    <$mt:EntryEditLink$>

=for tags search

=cut

sub _hdlr_entry_edit_link {
    my($ctx, $args) = @_;
    my $user = $ctx->stash('user') or return '';
    my $entry = $ctx->stash('entry')
        or return $ctx->error(MT->translate(
            'You used an [_1] tag outside of the proper context.',
            '<$MTEntryEditLink$>' ));
    my $blog_id = $entry->blog_id;
    my $cfg = MT->config;
    my $url = $cfg->AdminCGIPath || $cfg->CGIPath;
    $url .= '/' unless $url =~ m!/$!;
    require MT::Permission;
    my $perms = MT::Permission->load({ author_id => $user->id,
                                       blog_id => $blog_id });
    return '' unless $perms && $perms->can_edit_entry($entry, $user);
    my $app = MT->instance;
    my $edit_text = $args->{text} || $app->translate("Edit");
    return sprintf
        q([<a href="%s%s%s">%s</a>]),
        $url,
        $cfg->AdminScript,
        $app->uri_params('mode' => 'view',
            args => {'_type' => $entry->class, id => $entry->id, blog_id => $blog_id}),
        $edit_text;
}

###########################################################################

=head2 HTTPContentType

When this tag is used in a dynamically published index template, the value
specified to the type attribute will be returned in the Content-Type HTTP
header sent to web browser. This content is never displayed directly to the
user but is instead used to signal to the browser the data type of the
response.

When this tag is used in a system template, such as the search results
template, mt-search.cgi will use the value specified to "type" attribute and
returns it in Content-Type HTTP header to web browser.

When this tag is used in statically published template, this template tag
outputs nothing.

B<Attributes:>

=over 4

=item * type

A valid HTTP Content-Type value, for example 'application/xml'. Note that you
must not specify charset portion of Content-Type header value in this
attribute. MT will set the portion automatically by using PublishCharset
configuration directive.

=back

B<Example:>

    <$mt:HTTPContentType type="application/xml"$>

=cut

sub _hdlr_http_content_type {
    my($ctx, $args) = @_;
    my $type = $args->{type};
    $ctx->stash('content_type', $type);
    return qq{};
}

###########################################################################

=head2 Assets

A container tag which iterates over a list of assets.

B<Attributes:>

=over 4

=item * type

Specifies a particular type(s) of asset to select. This may be
one of image, audio, video (if unspecified, will select all asset
types). Supports a comma-delimited list.

=item * file_ext

Specifies a particular file extension to select. For instance, gif, mp3,
pdf, etc. Supports a comma-delimited list.

=item * days

Selects assets created in the last number of days specified.

=item * author

Selects assets uploaded by a particular author (where the author's
username is given).

=item * lastn

Limits the selection of assets to the specified number.

=item * limit

a positive integer to limit results.

=item * offset

Used in coordination with lastn, starts N assets from the start of the
list. N is a positive integer.

=item * tag

Selects assets with particular tags (supports expressions such as
"interesting AND featured").

=item * sort_by

Supported values: file_name, created_by, created_on, score.

=item * sort_order

Supported values: ascend, descend.

=item * namespace

Used in conjunction with the sort_by attribute when sorting in
"score" order. The namespace identifies the method of scoring to use
in sorting assets.

=item * assets_per_row

When publishing a grid of thumbnails, this attribute sets how many
iterations the Assets tag publishes before setting the state that
enables the L<AssetIsLastInRow> tag. Supported values: numbers between 1
and 100. Also supported is the keyword "auto" which selects the
most aesthetically pleasing number of items per row based on the
total number of assets. For example, if you had 18 total assets, three
rows of six would publish, but for 16 assets, four rows of four
would publish.

=back

B<Example:>

    <mt:Assets lastn="10" type="image" tag="favorite">
       <a href="<mt:AssetURL>">
          <img src="<mt:AssetThumbnailURL height="70">"
               alt="<mt:AssetLabel escape="html">"
               title="<mt:AssetLabel escape="html">" />
       </a>
    </mt:Assets>

=for tags multiblog, assets

=cut

sub _hdlr_assets {
    my($ctx, $args, $cond) = @_;
    return $ctx->error(MT->translate('sort_by="score" must be used in combination with namespace.'))
        if ((exists $args->{sort_by}) && ('score' eq $args->{sort_by}) && (!exists $args->{namespace}));

    my $class_type = $args->{class_type} || 'asset';
    my $class = MT->model($class_type);
    my $assets;
    my $tag = lc $ctx->stash('tag');
    if ($tag eq 'entryassets' || $tag eq 'pageassets') {
        my $e = $ctx->stash('entry')
            or return $ctx->_no_entry_error();

        require MT::ObjectAsset;
        my @assets = MT::Asset->load({ class => '*' }, { join => MT::ObjectAsset->join_on(undef, {
            asset_id => \'= asset_id', object_ds => 'entry', object_id => $e->id })});
        return '' unless @assets;
        $assets = \@assets;
    } else {
        $assets = $ctx->stash('assets');
    }

    local $ctx->{__stash}{assets};
    my (@filters, %blog_terms, %blog_args, %terms, %args);
    my $blog_id = $ctx->stash('blog_id');
    
    $ctx->set_blog_load_context($args, \%blog_terms, \%blog_args)
        or return $ctx->error($ctx->errstr);
    %terms = %blog_terms;
    %args = %blog_args;

    # Adds parent filter (skips any generated files such as thumbnails)
    $args{null}{parent} = 1;
    $terms{parent} = \'is null';

    # Adds an author filter to the filters list.
    if (my $author_name = $args->{author}) {
        require MT::Author;
        my $author = MT::Author->load({ name => $author_name }) or
            return $ctx->error(MT->translate(
                "No such user '[_1]'", $author_name ));
        if ($assets) {
            push @filters, sub { $_[0]->created_by == $author->id };
        } else {
            $terms{created_by} = $author->id;
        }
    }

    # Added a type filter to the filters list.
    if (my $type = $args->{type}) {
        my @types = split(',', $args->{type});
        if ($assets) {
            push @filters, sub { my $a = $_[0]->class; grep(m/$a/, @types) };
        } else {
            $terms{class} = \@types;
        }
    } else {
        $terms{class} = '*';
    }

    # Added a file_ext filter to the filters list.
    if (my $ext = $args->{file_ext}) {
        my @exts = split(',', $args->{file_ext});
        if ($assets) {
            push @filters, sub { my $a = $_[0]->file_ext; grep(m/$a/, @exts) };
        } else {
            $terms{file_ext} = \@exts;
        }
    }

    # Adds a tag filter to the filters list.
    if (my $tag_arg = $args->{tags} || $args->{tag}) {
        require MT::Tag;
        require MT::ObjectTag;

        my $terms;
        if ($tag_arg !~ m/\b(AND|OR|NOT)\b|\(|\)/i) {
            my @tags = MT::Tag->split(',', $tag_arg);
            $terms = { name => \@tags };
            $tag_arg = join " or ", @tags;
        }
        my $tags = [ MT::Tag->load($terms, {
                    binary => { name => 1 },
                    join => ['MT::ObjectTag', 'tag_id', { blog_id => $blog_id, object_datasource => MT::Asset->datasource }]
        }) ];
        my $cexpr = $ctx->compile_tag_filter($tag_arg, $tags);
        if ($cexpr) {
            my @tag_ids = map { $_->id, ( $_->n8d_id ? ( $_->n8d_id ) : () ) } @$tags;
            my $preloader = sub {
                my ($entry_id) = @_;
                my $terms = {
                    tag_id            => \@tag_ids,
                    object_id         => $entry_id,
                    object_datasource => $class->datasource,
                    %blog_terms,
                };
                my $args = {
                    %blog_args,
                    fetchonly => ['tag_id'],
                    no_triggers => 1,
                };
                my @ot_ids = MT::ObjectTag->load( $terms, $args ) if @tag_ids;
                my %map;
                $map{ $_->tag_id } = 1 for @ot_ids;
                \%map;
            };
            push @filters, sub { $cexpr->( $preloader->( $_[0]->id ) ) };
        } else {
            return $ctx->error(MT->translate("You have an error in your 'tag' attribute: [_1]", $args->{tags} || $args->{tag}));
        }
    }

    if ($args->{namespace}) {
        my $namespace = $args->{namespace};

        my $need_join = 0;
        for my $f qw( min_score max_score min_rate max_rate min_count max_count scored_by ) {
            if ($args->{$f}) {
                $need_join = 1;
                last;
            }
        }

        if ($need_join) {
            my $scored_by = $args->{scored_by} || undef;
            if ($scored_by) {
                require MT::Author;
                my $author = MT::Author->load({ name => $scored_by }) or
                    return $ctx->error(MT->translate(
                        "No such user '[_1]'", $scored_by ));
                $scored_by = $author;
            }

            $args{join} = MT->model('objectscore')->join_on(undef,
                {
                    object_id => \'=asset_id',
                    object_ds => 'asset',
                    namespace => $namespace,
                    (!$assets && $scored_by ? (author_id => $scored_by->id) : ()),
                }, {
                    unique => 1,
            });
            if ($assets && $scored_by) {
                push @filters, sub { $_[0]->get_score($namespace, $scored_by) };
            }
        }

        # Adds a rate or score filter to the filter list.
        if ($args->{min_score}) {
            push @filters, sub { $_[0]->score_for($namespace) >= $args->{min_score}; };
        }
        if ($args->{max_score}) {
            push @filters, sub { $_[0]->score_for($namespace) <= $args->{max_score}; };
        }
        if ($args->{min_rate}) {
            push @filters, sub { $_[0]->score_avg($namespace) >= $args->{min_rate}; };
        }
        if ($args->{max_rate}) {
            push @filters, sub { $_[0]->score_avg($namespace) <= $args->{max_rate}; };
        }
        if ($args->{min_count}) {
            push @filters, sub { $_[0]->vote_for($namespace) >= $args->{min_count}; };
        }
        if ($args->{max_count}) {
            push @filters, sub { $_[0]->vote_for($namespace) <= $args->{max_count}; };
        }
    }

    my $no_resort = 0;
    require MT::Asset;
    my @assets;
    if (!$assets) {
        my ($start, $end) = ($ctx->{current_timestamp},
                            $ctx->{current_timestamp_end});
        if ($start && $end) {
            $terms{created_on} = [$start, $end];
            $args{range_incl}{created_on} = 1;
        }
        if (my $days = $args->{days}) {
            my @ago = offset_time_list(time - 3600 * 24 * $days,
                        $ctx->stash('blog_id'));
            my $ago = sprintf "%04d%02d%02d%02d%02d%02d",
                        $ago[5]+1900, $ago[4]+1, @ago[3,2,1,0];
            $terms{created_on} = [ $ago ];
            $args{range_incl}{created_on} = 1;
        }
        $args{'sort'} = 'created_on';
        if ($args->{sort_by}) {
            if (MT::Asset->has_column($args->{sort_by})) {
                $args{sort} = $args->{sort_by};
                $no_resort = 1;
            } elsif ('score' eq $args->{sort_by} || 'rate' eq $args->{sort_by}) {
                $no_resort = 0;
            }
        }

        if (!@filters) {
            if (my $last = $args->{lastn}) {
                $args{'sort'} = 'created_on';
                $args{direction} = 'descend';
                $args{limit} = $last;
                $no_resort = 0 if $args->{sort_by};
            } else {
                $args{direction} = $args->{sort_order} || 'descend'
                  if exists($args{sort});
                $no_resort = 1 unless $args->{sort_by};
                $args{limit} = $args->{limit} if $args->{limit};
            }
            $args{offset} = $args->{offset} if $args->{offset};
            @assets = MT::Asset->load(\%terms, \%args);
        } else {
            if ($args->{lastn}) {
                $args{direction} = 'descend';
                $args{sort} = 'created_on';
                $no_resort = 0 if $args->{sort_by};
            } else {
                $args{direction} = $args->{sort_order} || 'descend';
                $no_resort = 1 unless $args->{sort_by};
                $args->{lastn} = $args->{limit} if $args->{limit};
            }
            my $iter = MT::Asset->load_iter(\%terms, \%args);
            my $i = 0; my $j = 0;
            my $off = $args->{offset} || 0;
            my $n = $args->{lastn};
            ASSET: while (my $e = $iter->()) {
                for (@filters) {
                    next ASSET unless $_->($e);
                }
                next if $off && $j++ < $off;
                push @assets, $e;
                $i++;
                last if $n && $i >= $n;
            }
        }
    } else {
        my $blog = $ctx->stash('blog');
        my $so = lc($args->{sort_order}) || ($blog ? $blog->sort_order_posts : undef) || '';
        my $col = lc ($args->{sort_by} || 'created_on');
        # TBD: check column being sorted; if it is numeric, use numeric sort
        @$assets = $so eq 'ascend' ?
            sort { $a->$col() cmp $b->$col() } @$assets :
            sort { $b->$col() cmp $a->$col() } @$assets;
        $no_resort = 1;
        if (@filters) {
            my $i = 0; my $j = 0;
            my $off = $args->{offset} || 0;
            my $n = $args->{lastn} || $args->{limit};
            ASSET2: foreach my $e (@$assets) {
                for (@filters) {
                    next ASSET2 unless $_->($e);
                }
                next if $off && $j++ < $off;
                push @assets, $e;
                $i++;
                last if $n && $i >= $n;
            }
        } else {
            my $offset;
            if ($offset = $args->{offset}) {
                if ($offset < scalar @$assets) {
                    @assets = @$assets[$offset..$#$assets];
                } else {
                    @assets = ();
                }
            } else {
                @assets = @$assets;
            }
            if (my $last = $args->{lastn} || $args->{limit}) {
                if (scalar @assets > $last) {
                    @assets = @assets[0..$last-1];
                }
            }
        }
    }

    unless ($no_resort) {
        my $so = lc($args->{sort_order} || '');
        my $col = lc($args->{sort_by} || 'created_on');
        if ('score' eq $col) {
            my $namespace = $args->{namespace};
            my $so = $args->{sort_order} || '';
            my %a = map { $_->id => $_ } @assets;
            require MT::ObjectScore;
            my $scores = MT::ObjectScore->sum_group_by(
                { 'object_ds' => 'asset', 'namespace' => $namespace },
                { 'sum' => 'score', group => ['object_id'],
                  $so eq 'ascend' ? (direction => 'ascend') : (direction => 'descend'),
                });
            my @tmp;
            while (my ($score, $object_id) = $scores->()) {
                push @tmp, delete $a{ $object_id } if exists $a{ $object_id };
            }
            if ($so eq 'ascend') {
                unshift @tmp, $_ foreach (values %a);
            } else {
                push @tmp, $_ foreach (values %a);
            }
            @assets = @tmp;
        } elsif ('rate' eq $col) {
            my $namespace = $args->{namespace};
            my $so = $args->{sort_order} || '';
            my %a = map { $_->id => $_ } @assets;
            require MT::ObjectScore;
            my $scores = MT::ObjectScore->avg_group_by(
                { 'object_ds' => 'asset', 'namespace' => $namespace },
                { 'avg' => 'score', group => ['object_id'],
                  $so eq 'ascend' ? (direction => 'ascend') : (direction => 'descend'),
                });
            my @tmp;
            while (my ($score, $object_id) = $scores->()) {
                push @tmp, delete $a{ $object_id } if exists $a{ $object_id };
            }
            if ($so eq 'ascend') {
                unshift @tmp, $_ foreach (values %a);
            } else {
                push @tmp, $_ foreach (values %a);
            }
            @assets = @tmp;
        } else {
            # TBD: check column being sorted; if it is numeric, use numeric sort
            @assets = $so eq 'ascend' ?
                sort { $a->$col() cmp $b->$col() } @assets :
                sort { $b->$col() cmp $a->$col() } @assets;
        }
    }

    my $res = '';
    my $tok = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');
    my $per_row = $args->{assets_per_row} || 0;
    $per_row -= 1 if $per_row;
    my $row_count = 0;
    my $i = 0;
    my $total_count = @assets;
    my $vars = $ctx->{__stash}{vars} ||= {};

    for my $a (@assets) {
        local $ctx->{__stash}{asset} = $a;
        local $vars->{__first__} = !$i;
        local $vars->{__last__} = !defined $assets[$i+1];
        local $vars->{__odd__} = ($i % 2) == 0; # 0-based $i
        local $vars->{__even__} = ($i % 2) == 1;
        local $vars->{__counter__} = $i+1;
        my $f = $row_count == 0;
        my $l = $row_count == $per_row;
        $l = 1 if (($i + 1) == $total_count);
        my $out = $builder->build($ctx, $tok, {
            %$cond,
            AssetIsFirstInRow => $f,
            AssetIsLastInRow => $l,
            AssetsHeader => !$i,
            AssetsFooter => !defined $assets[$i+1],
        });
        $res .= $out;
        $row_count++;
        $row_count = 0 if $row_count > $per_row;
        $i++;
    }

    $res;
}

###########################################################################

=head2 EntryAssets

A container tag which iterates over a list of assets for the current
entry in context. Supports all the attributes provided by the L<Assets>
tag.

=for tags entries, assets

=cut

###########################################################################

=head2 PageAssets

A container tag which iterates over a list of assets for the current
page in context. Supports all the attributes provided by the L<Assets>
tag.

=for tags pages, assets

=cut

###########################################################################

=head2 AssetsHeader

The contents of this container tag will be displayed when the first
entry listed by a L<Assets> tag is reached.

=for tags assets

=cut

###########################################################################

=head2 AssetsFooter

The contents of this container tag will be displayed when the last
entry listed by a L<Assets> tag is reached.

=for tags assets

=cut

###########################################################################

=head2 AssetIsFirstInRow

A conditional tag that displays its contents if the asset in context is
the first item in the row in context when publishing a grid of
assets (e.g. thumbnails). Grid of assets can be created by specifying
assets_per_row attribute value to L<Assets> block tag.

For example, the first, the fourth and the seventh asset are the
first assets in row when L<Assets> iterates eight assets and
assets_per_row is set to "3".

B<Example:>

    <table>
      <mt:Assets type="image" assets_per_row="4">
        <mt:AssetIsFirstInRow><tr></mt:AssetIsFirstInRow>
          <td><$mt:AssetThumbnailLink$></td>
        <mt:AssetIsLastInRow></tr></mt:AssetIsLastInRow>
      </mt:Assets>
    </table>

=cut

###########################################################################

=head2 AssetIsLastInRow

A conditional tag that displays its contents if the asset in context
is the last item in the row in context when publishing a grid of
assets (e.g. thumbnails). Grid of assets can be created by specifying
assets_per_row attribute value to L<Assets> block tag.

For example, the third, the sixth and the eighth asset are the last
assets in row when L<Assets> iterates eight assets and assets_per_row is
set to "3".

B<Example:>

    <table>
      <mt:Assets type="image" assets_per_row="4">
        <mt:AssetIsFirstInRow><tr></mt:AssetIsFirstInRow>
          <td><$mt:AssetThumbnailLink$></td>
        <mt:AssetIsLastInRow></tr></mt:AssetIsLastInRow>
      </mt:Assets>
    </table>

=for tags assets

=cut

###########################################################################

=head2 Asset

Container tag that provides an asset context for a specific asset,
from which all asset variable tags can be used to retreive metadata
about that asset.

B<Attributes:>

=over 4

=item * id

The unique numeric id of the asset.

=back

B<Example:>

    <mt:Asset id="10">
        <$mt:AssetLabel$>
    </mt:Asset>

=for tags assets

=cut

sub _hdlr_asset {
    my ($ctx, $args, $cond) = @_;
    my $assets = $ctx->stash('assets');
    local $ctx->{__stash}{assets};
    return '' if !defined $args->{id};
    return '' if $assets;

    require MT::Asset;
    my $out = '';
    my $asset = MT::Asset->load({ id => $args->{id} });

    if ($asset) {
        my $tok = $ctx->stash('tokens');
        my $builder = $ctx->stash('builder');

        local $ctx->{__stash}{asset} = $asset;
        $out = $builder->build($ctx, $tok, {
                %$cond,
        });
    }
    $out;
}

###########################################################################

=head2 AssetTags

A container tag used to output infomation about the asset tags assigned
to the asset in context. This tag's functionality is analogous
to that of L<EntryTags> and its attributes are identical.

To avoid printing out the leading text when no asset tags are assigned you
can use the L<AssetIfTagged> conditional block to first test for tags
on the asset. You can also use the L<AssetIfTagged> conditional block with
the tag attribute to test for the assignment of a particular tag.

B<Attributes:>

=over 4

=item * glue

A text string that is used to join each of the items together. For example:

    <mt:AssetTags glue=", "><$mt:TagName$></mt:AssetTags>

would print out each tag name separated by a comma and a space.

=item * include_private

A boolean value which controls whether private tags (i.e. tags which start
with @) should be output by the block. The default is 0 which suppresses the
output of private tags. If set to 1, the tags will be displayed. See
L<EntryTags> for an example of its usage.

=back

B<Example:>

The following code can be used anywhere L<Assets> can be used. It prints
a list of all of the tags assigned to each asset returned by L<Assets>
glued together by a comma and a space.

    <mt:If tag="AssetTags">
        The asset "<$mt:AssetLabel$>" is tagged:
        <mt:AssetTags glue=", "><$mt:TagName$></mt:AssetTags>
    </mt:If>

=for tags tags, assets

=cut

sub _hdlr_asset_tags {
    my ($ctx, $args, $cond) = @_;

    require MT::ObjectTag;
    require MT::Asset;
    my $asset = $ctx->stash('asset');
    return '' unless $asset;
    my $glue = $args->{glue};

    local $ctx->{__stash}{tag_max_count} = undef;
    local $ctx->{__stash}{tag_min_count} = undef;
    local $ctx->{__stash}{all_tag_count} = undef;
    local $ctx->{__stash}{class_type} = 'asset';

    my $iter = MT::Tag->load_iter(undef, { 'sort' => 'name',
            'join' => MT::ObjectTag->join_on('tag_id',
                    { object_id => $asset->id,
                      blog_id => $asset->blog_id,
                      object_datasource => MT::Asset->datasource },
                    { unique => 1 } )});
    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');
    my $res = '';
    while (my $tag = $iter->()) {
        next if $tag->is_private && !$args->{include_private};
        local $ctx->{__stash}{Tag} = $tag;
        local $ctx->{__stash}{tag_count} = undef;
        local $ctx->{__stash}{tag_asset_count} = undef;
        defined(my $out = $builder->build($ctx, $tokens, $cond))
            or return $ctx->error( $builder->errstr );
        $res .= $glue if defined $glue && length($res) && length($out);
        $res .= $out;
    }

    return $res;
}

###########################################################################

=head2 AssetID

A numeric system ID of the Asset currently in context.

B<Example:>

    <$mt:AssetID$>

=for tags assets

=cut

sub _hdlr_asset_id {
    my ($ctx, $args) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();
    return $args && $args->{pad} ? (sprintf "%06d", $a->id) : $a->id;
}

###########################################################################

=head2 AssetFileName

The file name of the asset in context. For file-based assets only. Returns
the file name without the path (i.e. file.jpg, not
/home/user/public_html/images/file.jpg).

B<Example:>

    <$mt:AssetFileName$>

=for tags assets

=cut

sub _hdlr_asset_file_name {
    my ($ctx, $args) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();
    return $a->file_name;
}

###########################################################################

=head2 AssetLabel

Returns the label of the asset in context. Label can be specified upon
uploading a file.

B<Example:>

    <$mt:AssetLabel$>

=for tags assets

=cut

sub _hdlr_asset_label {
    my ($ctx, $args) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();
    return defined $a->label ? $a->label : '';
}

###########################################################################

=head2 AssetDescription

This tag returns the description text of the asset currently in context.

B<Example:>

    <$mt:AssetDescription$>

=for tags assets

=cut

sub _hdlr_asset_description {
    my ($ctx, $args) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();
    return defined $a->description ? $a->description : '';
}

###########################################################################

=head2 AssetURL

Produces a permalink for the uploaded asset.

B<Example:>

    <$mt:AssetURL$>

=for tags assets

=cut

sub _hdlr_asset_url {
    my ($ctx, $args) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();
    return $a->url;
}

###########################################################################

=head2 AssetType

Returns the localized name for the type of asset currently in context.
For instance, for an image asset, this will tag will output (for English
blogs), "image".

B<Example:>

    <$mt:AssetType$>

=for tags assets

=cut

sub _hdlr_asset_type {
    my ($ctx) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();
    return lc $a->class_label;
}

###########################################################################

=head2 AssetMimeType

Returns MIME type of the asset in context. MIME type of a file is typically
provided by web browser upon uploading.

B<Example:>

    <$mt:AssetMimeType$>

=for tags assets

=cut

sub _hdlr_asset_mime_type {
    my ($ctx) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();
    return $a->mime_type || '';
}

###########################################################################

=head2 AssetFilePath

Path information of the asset in context. For file-based assets only.
Returns the local file path with the name of the file (i.e.
/home/user/public_html/images/file.jpg).

B<Example:>

    <$mt:AssetFilePath$>

=for tags assets

=cut

sub _hdlr_asset_file_path {
    my ($ctx) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();
    return $a->file_path || '';
}

###########################################################################

=head2 AssetDateAdded

The date the asset in context was added to Movable Type.

B<Attributes:>

=over 4

=item * format

A string that provides the format in which to publish the date. If
unspecified, the default that is appropriate for the language of the blog
is used (for English, this is "%B %e, %Y %l:%M %p"). See the L<Date>
tag for the supported formats.

=item * language

Forces the date to the format associated with the specified language.

=item * utc

Forces the date to UTC format.

=back

B<Example:>

    <$mt:AssetDateAdded$>

=for tags date, assets

=cut

sub _hdlr_asset_date_added {
    my ($ctx, $args) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();
    $args->{ts} = $a->created_on;
    return _hdlr_date($ctx, $args);
}

###########################################################################

=head2 AssetAddedBy

Display name (or username if display name isn't assigned) of the user
who added the asset to the system.

B<Example:>

    <$mt:AssetAddedBy$>

=for tags assets

=cut

sub _hdlr_asset_added_by {
    my ($ctx) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();

    require MT::Author;
    my $author = MT::Author->load($a->created_by);
    return '' unless $author;
    return $author->nickname || $author->name;
}

###########################################################################

=head2 AssetProperty

Returns the additional metadata of the asset in context. Some of these
properties only make sense for certain file types. For example, image_width
and image_height apply only to images.

B<Attributes:>

=over 4

=item * property (required)

Specifies what property to return from the tag. B<Supported attribute values:>

=over 4

=item * file_size

asset's file size

=item * image_width

asset's width (for image only; otherwise returns 0)

=item * image_height

asset's height (for image only; otherwise returns 0)

=item * description

asset's description

=back

=item * format

Used in conjunction with file_size property. B<Supported attribute values:>

=over 4

=item * 0

return raw size

=item * 1 (default)

auto format depending on the size

=item * k

size expressed in kilobytes

=item * m

size expressed in megabytes

=back

=back

=for tags assets

=cut

sub _hdlr_asset_property {
    my ($ctx, $args) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();
    my $prop = $args->{property};
    return '' unless $prop;

    my $class = ref($a);
    my $ret;
    if ($prop =~ m/file_size/i) {
        my @stat = stat($a->file_path);
        my $size = $stat[7];
        my $format = $args->{format};
        $format = 1 if !defined $format;

        if ($format eq '1') {
            if ($size < 1024) {
                $ret = sprintf("%d Bytes", $size);
            } elsif ($size < 1024000) {
                $ret = sprintf("%.1f KB", $size / 1024);
            } else {
                $ret = sprintf("%.1f MB", $size / 1048576);
            }
        } elsif ($format =~ m/k/i) {
                $ret =  sprintf("%.1f", $size / 1024);
        } elsif ($format =~ m/m/i) {
                $ret = sprintf("%.1f", $size / 1048576);
        } else {
            $ret = $size;
        }
    } elsif ($prop =~ m/^image_/ && $class->can($prop)) {
        # These are numbers, so default to 0.
        $ret = $a->$prop || 0;
    } elsif ($prop =~ m/^image_/) {
        $ret = 0;
    } else {
        $ret = $a->$prop || '';
    }

    $ret;
}

###########################################################################

=head2 AssetFileExt

The file extension of the asset in context. For file-based assets only.
Returns the file extension without the leading period (ie: "jpg").

B<Example:>

    <$mt:AssetFileExt$>

=for tags assets

=cut

sub _hdlr_asset_file_ext {
    my ($ctx) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();
    return $a->file_ext || '';
}

###########################################################################

=head2 AssetThumbnailURL

Returns the URL for a thumbnail you wish to generate for the current
asset in context.

B<Attributes:>

=over 4

=item * height

The height of the thumbnail to generate. If this is the only parameter
specified then the thumbnail's width will be scaled proportionally to
the height.

=item * width

The width of the thumbnail to generate. If this is the only parameter
specified then the thumbnail's height will be scaled proportionally
to the width.

=item * scale

The percentage by which to reduce or increase the size of the current
asset.

=item * square

If set to 1 (one) then the thumbnail generated will be square, where
the length of each side of the square will be equal to the shortest
side of the image.

=back

B<Example:>

The following will output thumbnails for all of the assets embedded in all
of the entries on the system. Each thumbnail will be square and have a
max height/width of 100 pixels.

    <mt:Entries>
        <mt:EntryAssets>
            <$mt:AssetThumbnailURL width="100" square="1"$>
        </mt:EntryAssets>
    </mt:Entries>

=for tags assets

=cut

sub _hdlr_asset_thumbnail_url {
    my ($ctx, $args) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();
    return '' unless $a->has_thumbnail;

    my %arg;
    foreach (keys %$args) {
        $arg{$_} = $args->{$_};
    }
    $arg{Width} = $args->{width} if $args->{width};
    $arg{Height} = $args->{height} if $args->{height};
    $arg{Scale} = $args->{scale} if $args->{scale};
    $arg{Square} = $args->{square} if $args->{square}; 
    my ($url, $w, $h) = $a->thumbnail_url(%arg);
    return $url || '';
}

###########################################################################

=head2 AssetLink

Returns HTML anchor tag for the asset in context. For example, if the URL
of the asset is C<http://example.com/image.jpg>, the tag returns
C<E<lt>a href="http://example.com/image.jpg"E<gt>image.jpgE<lt>/aE<gt>>.

B<Attributes:>

=over 4

=item * new_window (optional; default "0")

Specifies if the tag generates 'target="_blank"' attribute to the anchor
tag.

=back

B<Example:>

    <$mt:AssetLink$>

=for tags assets

=cut

sub _hdlr_asset_link {
    my ($ctx, $args) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();

    my $ret = sprintf qq(<a href="%s"), $a->url;
    if ($args->{new_window}) {
        $ret .= qq( target="_blank");
    }
    $ret .= sprintf qq(>%s</a>), $a->file_name;
    $ret;
}

###########################################################################

=head2 AssetThumbnailLink

Produces a thumbnail image, linked to the image asset currently in
context.

B<Attributes:>

=over 4

=item * height

The height of the thumbnail to generate. If this is the only parameter
specified then the thumbnail's width will be scaled proportionally to
the height.

=item * width

The width of the thumbnail to generate. If this is the only parameter
specified then the thumbnail's height will be scaled proportionally
to the width.

=item * scale

The percentage by which to reduce or increase the size of the current
asset.

=item * new_window (optional; default "0")

If set to '1', causes the link to open a new window to the linked asset.

=back

=for tags assets

=cut

sub _hdlr_asset_thumbnail_link {
    my ($ctx, $args) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();
    my $class = ref($a);
    return '' unless UNIVERSAL::isa($a, 'MT::Asset::Image');

    # # Load MT::Image
    # require MT::Image;
    # my $img = new MT::Image(Filename => $a->file_path)
    #     or return $ctx->error(MT->translate(MT::Image->errstr));

    # Get dimensions
    my %arg;
    $arg{Width} = $args->{width} if $args->{width};
    $arg{Height} = $args->{height} if $args->{height};
    $arg{Scale} = $args->{scale} if $args->{scale};
    my ($url, $w, $h) = $a->thumbnail_url(%arg);
    my $ret = sprintf qq(<a href="%s"), $a->url;
    if ($args->{new_window}) {
        $ret .= qq( target="_blank");
    }
    $ret .= sprintf qq(><img src="%s" width="%d" height="%d" alt="" /></a>), $url, $w, $h;
    $ret;
}

###########################################################################

=head2 AssetCount

Returns the number of assets associated with the active blog.

B<Attributes:>

=over 4

=item type

Allows for filtering by file type. Built-in types supported are "image",
"audio", "video". These types can be extended by plugins.

=back

B<Example:>

    Images available: <$mt:AssetCount type="image"$>

=for tags assets

=cut

sub _hdlr_asset_count {
    my ($ctx, $args, $cond) = @_;
    my (%terms, %args);
    $terms{blog_id} = $ctx->stash('blog_id') if $ctx->stash('blog_id');
    $terms{class} = $args->{type} || '*';
    my $count = MT::Asset->count(\%terms, \%args);
    return $ctx->count_format($count, $args);
}

###########################################################################

=head2 AssetIfTagged

A conditional tag whose contents will be displayed if the asset in
context has tags.

B<Attributes:>

=over 4

=item * tag or name

If either 'name' or 'tag' are specified, tests the asset in context
for whether it has a tag association by that name.

=back

=for tags assets, tags

=cut
 
sub _hdlr_asset_if_tagged {
    my ($ctx, $args) = @_;
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();

    my $tag = defined $args->{name} ? $args->{name} : ( defined $args->{tag} ? $args->{tag} : '' );
    if ($tag ne '') {
        $a->has_tag($tag);
    } else {
        my @tags = $a->tags;
        @tags = grep /^[^@]/, @tags;
        return @tags ? 1 : 0;
    }
}

###########################################################################

=head2 CaptchaFields

Returns the HTML markup necessary to display the CAPTCHA on the published
blog. The value returned is escaped for assignment to a JavaScript string,
since the CAPTCHA field is displayed through the MT JavaScript code.

B<Example:>

    var captcha = '<$mt:CaptchaFields$>';

=for tags comments

=cut

sub _hdlr_captcha_fields {
    my ($ctx, $args, $cond) = @_;
    my $blog_id = $ctx->stash('blog_id');
    my $blog = MT->model('blog')->load($blog_id);
        return $ctx->error(MT->translate('Can\'t load blog #[_1].', $blog_id)) unless $blog;
    if (my $provider = MT->effective_captcha_provider( $blog->captcha_provider ) ) {
        my $fields = $provider->form_fields($blog_id);
        $fields =~ s/[\r\n]//g;
        $fields =~ s/'/\\'/g;
        return $fields;
    }
    return q();
}

###########################################################################

=head2 Pages

A container tag which iterates over a list of pages--which pages depends
on the context the tag is being used in. Within each iteration, you can
use any of the page variable tags.

Because pages are basically non-date-based entries, the the C<Pages>
tag is very similar to L<Entries>.

B<Attributes unique to the Pages tag:>

=over 4

=item * folder

Use folder label, not basename.

=item * include_subfolders

Specify '1' to cause all pages that may exist within subfolders to the
folder in context to be included.

=back

=for tags pages, multiblog

=cut

sub _hdlr_pages {
    my($ctx, $args, $cond) = @_;

    my $folder = $args->{folder} || $args->{folders};
    $args->{categories} = $folder if $folder;

    if ($args->{no_folder}) {
        require MT::Folder;
        my $blog_id = $ctx->stash('blog_id');
        my @fols = MT::Folder->load({blog_id => $blog_id});
        my $not_folder;
        foreach my $folder (@fols) {
            if ($not_folder) {
                $not_folder .= " OR ".$folder->label;
            } else {
                $not_folder = $folder->label;
            }
        }
        if ($not_folder) {
            $args->{categories} = "NOT ($not_folder)";
        }
    }

    # remove current_timestamp;
    local $ctx->{current_timestamp};
    local $ctx->{current_timestamp_end};

    require MT::Page;
    $args->{class_type} = MT::Page->properties->{class_type};
    _hdlr_entries($ctx, $args, $cond);
}

###########################################################################

=head2 PagePrevious

A container tag that create a context to the previous page.

=for tags pages, archives

=cut

sub _hdlr_page_previous {
    my($ctx, $args, $cond) = @_;

    return undef unless &_check_page(@_);
    require MT::Page;
    $args->{class_type} = MT::Page->properties->{class_type};
    &_hdlr_entry_previous(@_); 
}

###########################################################################

=head2 PageNext

A container tag that create a context to the next page.

=for tags pages, archives

=cut

sub _hdlr_page_next {
    my($ctx, $args, $cond) = @_;

    require MT::Page;
    $args->{class_type} = MT::Page->properties->{class_type};
    return undef unless &_check_page(@_);
    &_hdlr_entry_next(@_); 
}

###########################################################################

=head2 PageTags

A container tag used to output infomation about the tags assigned
to the page in context. This tag's functionality is analogous
to that of L<EntryTags> and its attributes are identical.

To avoid printing out the leading text when no page tags are assigned you
can use the L<PageIfTagged> conditional block to first test for tags
on the page. You can also use the L<PageIfTagged> conditional block with
the tag attribute to test for the assignment of a particular tag.

B<Attributes:>

=over 4

=item * glue

A text string that is used to join each of the items together. For example:

    <mt:PageTags glue=", "><$mt:TagName$></mt:PageTags>

would print out each tag name separated by a comma and a space.

=item * include_private

A boolean value which controls whether private tags (i.e. tags which start
with @) should be output by the block. The default is 0 which suppresses the
output of private tags. If set to 1, the tags will be displayed. See
L<EntryTags> for an example of its usage.

=back

B<Example:>

Listing out the page's tags, separated by commas:

    <mt:PageTags glue=", "><$mt:TagName$></mt:PageTags>

=for tags pages, tags

=cut

sub _hdlr_page_tags {
    my($ctx, $args, $cond) = @_;

    return undef unless &_check_page(@_);
    require MT::Page;
    $args->{class_type} = MT::Page->properties->{class_type};
    local $ctx->{__stash}{class_type} = $args->{class_type};
    &_hdlr_entry_tags(@_); 
}

###########################################################################

=head2 PageIfTagged

This template tag evaluates a block of code if a tag has been assigned
to the current entry in context. If the tag attribute is not assigned,
then the template tag will evaluate if any tag is present.

B<Attributes:>

=over 4

=item * tag

If present, the template tag will evaluate if the specified tag is
assigned to the current page.

=back

B<Example:>

    <mt:PageIfTagged tag="Foo">
      <!-- do something -->
    <mt:Else>
      <!-- do something else -->
    </mt:PageIfTagged>

=cut

sub _hdlr_page_if_tagged {
    my($ctx, $args, $cond) = @_;

    return undef unless &_check_page(@_);
    require MT::Page;
    $args->{class_type} = MT::Page->properties->{class_type};
    &_hdlr_entry_if_tagged(@_); 
}

###########################################################################

=head2 PageFolder

A container tag which holds folder context relating to the page.

=for tags pages, folders

=cut

sub _hdlr_page_folder {
    my($ctx, $args, $cond) = @_;

    return undef unless &_check_page(@_);
    require MT::Page;
    $args->{class_type} = MT::Page->properties->{class_type};
    local $ctx->{inside_mt_categories} = 1;
    &_hdlr_entry_categories(@_); 
}

###########################################################################

=head2 PageID

A numeric system ID of the Page currently in context.

B<Example:>

    <$mt:PageID$>

=cut

sub _hdlr_page_id {
    return undef unless &_check_page(@_);
    &_hdlr_entry_id(@_); 
}

###########################################################################

=head2 PageTitle

The title of the page in context.

B<Example:>

    <$mt:PageTitle$>

=for tags pages

=cut

sub _hdlr_page_title {
    return undef unless &_check_page(@_);
    &_hdlr_entry_title(@_); 
}

###########################################################################

=head2 PageBody

This tag outputs the contents of the page's Body field.

If a text formatting filter has been specified, it will automatically applied.

B<Attributes:>

=over 4

=item * words

Trims the number of words to display. By default all are displayed.

=item * convert_breaks

Controls the application of text formatting. By default convert_breaks is 0
(false). This should only be used if text formatting is set to "none" in the
Entry/Page editor.

=back

B<Example:>

    <$mt:PageBody$>

=for tags pages

=cut

sub _hdlr_page_body {
    return undef unless &_check_page(@_);
    &_hdlr_entry_body(@_); 
}

###########################################################################

=head2 PageMore

This tag outputs the contents of the page's Extended field.

If a text formatting filter has been specified it will automatically applied.

B<Attributes:>

=over 4

=item * convert_breaks (optional)

Controls the application of text formatting. By default convert_breaks is 0
(false). This should only be used if text formatting is set to "none" in the
Entry/Page editor.

=back

B<Example:>

    <$mt:PageMore$>

=for tags pages

=cut

sub _hdlr_page_more {
    return undef unless &_check_page(@_);
    &_hdlr_entry_more(@_); 
}

###########################################################################

=head2 PageDate

The authored on timestamp for the page.

B<Attributes:>

=over 4

=item * format

A string that provides the format in which to publish the date. If
unspecified, the default that is appropriate for the language of the blog
is used (for English, this is "%B %e, %Y %l:%M %p"). See the L<Date>
tag for the supported formats.

=item * language

Forces the date to the format associated with the specified language.

=item * utc

Forces the date to UTC format.

=back

B<Example:>

    <$mt:PageDate$>

=for tags pages, date

=cut

sub _hdlr_page_date {
    return undef unless &_check_page(@_);
    &_hdlr_entry_date(@_); 
}

###########################################################################

=head2 PageModifiedDate

The last modified timestamp for the page.

B<Attributes:>

=over 4

=item * format

A string that provides the format in which to publish the date. If
unspecified, the default that is appropriate for the language of the blog
is used (for English, this is "%B %e, %Y %l:%M %p"). See the L<Date>
tag for the supported formats.

=item * language

Forces the date to the format associated with the specified language.

=item * utc

Forces the date to UTC format.

=back

B<Example:>

    <$mt:PageModifiedDate$>

=for tags pages, date

=cut

sub _hdlr_page_modified_date {
    return undef unless &_check_page(@_);
    &_hdlr_entry_mod_date(@_); 
}

###########################################################################

=head2 PageKeywords

The specified keywords of the page in context.

B<Example:>

    <$mt:PageKeywords$>

=cut

sub _hdlr_page_keywords {
    return undef unless &_check_page(@_);
    &_hdlr_entry_keywords(@_); 
}

###########################################################################

=head2 PageBasename

By default, the page basename is a constant and unique identifier for
an page which is used as part of the individual pages's archive filename.

The basename is created by dirifiying the page title when the page is
first saved (regardless of the page status). From then on, barring direct
manipulation, the page basename stays constant even when you change the
page's title. In this way, Movable Type ensures that changes you make
to an page after saving it don't change the URL to the page, subsequently
breaking incoming links.

The page basename can be modified by anyone who can edit the page. If it
is modified after it is created, it is up to the user to ensure uniqueness
and no incrementing will occur. This allows you to have complete and
total control over your URLs when you want to as well as effortless
simplicity when you don't care.

B<Attributes:>

=over 4

=item * separator (optional)

Valid values are "_" and "-", dash is the default value. Specifying
an underscore will convert any dashes to underscores. Specifying a dash
will convert any underscores to dashes.

=back

B<Example:>

    <$mt:PageBasename$>

=for tags pages

=cut

sub _hdlr_page_basename {
    return undef unless &_check_page(@_);
    &_hdlr_entry_basename(@_);
}

###########################################################################

=head2 PagePermalink

An absolute URL pointing to the archive page containing this entry. An
anchor (#) is included if the permalink is not pointing to an
Individual Archive page.

B<Example:>

    <$mt:PagePermalink$>

=for tags pages, archives

=cut

sub _hdlr_page_permalink {
    return undef unless &_check_page(@_);
    &_hdlr_entry_permalink(@_);
}

###########################################################################

=head2 PageAuthorEmail

The email address of the page's author.

B<Note:> It is not recommended to publish email addresses.

B<Example:>

    <$mt:PageAuthorEmail$>

=for tags pages, authors

=cut

sub _hdlr_page_author_email {
    return undef unless &_check_page(@_);
    &_hdlr_entry_author_email(@_);
}

###########################################################################

=head2 PageAuthorLink

A linked version of the author's user name, using the author URL if provided
in the author's profile. Otherwise, the author name is unlinked. This tag uses
the author URL if available and the author email otherwise. If neither are on
record the author name is unlinked.

B<Attributes:>

=over 4

=item * show_email

Specifies if the author's email can be displayed. The default is false (0).

=item * show_url

Specifies if the author's URL can be displayed. The default is true (1).

=item * new_window

Specifies to open the link in a new window by adding "target=_blank" to the
anchor tag. See example below. The default is false (0).

=back

B<Examples:>

    <$mt:PageAuthorLink$>

    <$mt:PageAuthorLink new_window="1"$>

=for tags pages, authors

=cut

sub _hdlr_page_author_link {
    return undef unless &_check_page(@_);
    &_hdlr_entry_author_link(@_);
}

###########################################################################

=head2 PageAuthorURL

The URL of the page's author.

B<Example:>

    <$mt:PageAuthorURL$>

=cut

sub _hdlr_page_author_url {
    return undef unless &_check_page(@_);
    &_hdlr_entry_author_url(@_);
}

###########################################################################

=head2 PageExcerpt

This tag outputs the contents of the page Excerpt field if one is specified
or, if not, an auto-generated excerpt from the page Body field followed by an
ellipsis ("...").

The length of the auto-generated output of this tag can be set in the blog's
Entry Settings.

B<Attributes:>

=over 4

=item no_generate (optional; default "0")

When set to 1, the system will not auto-generate an excerpt if the excerpt
field of the page is left blank. Instead it will output nothing.

=item * convert_breaks (optional; default "0")

When set to 1, the page's specified text formatting filter will be applied. By
default, the text formatting is not applied and the excerpt is published
either as input or auto-generated by the system.

=back

B<Example:>

    <$mt:PageExcerpt$>

=cut

sub _hdlr_page_excerpt {
    return undef unless &_check_page(@_);
    &_hdlr_entry_excerpt(@_);
}

###########################################################################

=head2 BlogPageCount

The number of published pages in the blog. This template tag supports the
multiblog template tags.

B<Example:>

    <$mt:BlogPageCount$>

=for tags blogs, pages, multiblog, count

=cut

sub _hdlr_blog_page_count {
    my($ctx, $args, $cond) = @_;
    
    require MT::Page;
    $args->{class_type} = MT::Page->properties->{class_type};
    return _hdlr_blog_entry_count(@_);
}

###########################################################################

=head2 PageAuthorDisplayName

The display name of the author of the page in context. If no display name is
specified, returns an empty string, and no name is displayed.

B<Example:>

    <$mt:PageAuthorDisplayName$>

=for tags authors

=cut

sub _hdlr_page_author_display_name {
    return undef unless &_check_page(@_);
    &_hdlr_entry_author_display_name(@_);
}

###########################################################################

=head2 Folders

A container tags which iterates over a list of all folders and subfolders.

B<Attributes:>

=over 4

=item * show_empty

Setting this optional attribute to true (1) will include folders with no
pages assigned. The default is false (0), where only folders with pages
assigned.

=back

=for tags folders

=cut

sub _hdlr_folders {
    my($ctx, $args, $cond) = @_;

    require MT::Folder;
    $args->{class_type} = MT::Folder->properties->{class_type};
    _hdlr_categories($ctx, $args, $cond);
}

###########################################################################

=head2 FolderPrevious

A container tag which creates a folder context of the previous folder
relative to the current page folder or archived folder.

=for tags folders, archives

=cut

###########################################################################

=head2 FolderNext

A container tag which creates a folder context of the next folder
relative to the current page folder or archived folder.

=for tags folders, archives

=cut

sub _hdlr_folder_prevnext {
    my($ctx, $args, $cond) = @_;

    require MT::Folder;
    $args->{class_type} = MT::Folder->properties->{class_type};
    _hdlr_category_prevnext($ctx, $args, $cond);
}

###########################################################################

=head2 SubFolders

A specialized version of the L<Folders> container tag that respects
the hierarchical structure of folders.

B<Attributes:>

=over 4

=item * include_current

An optional boolean attribute that controls the inclusion of the
current folder in the list.

=item * sort_method

An optional and advanced usage attribute. A fully qualified Perl method
name to be used to sort the folders.

=item * sort_order

Specifies the sort order of the folder labels. Recognized values
are "ascend" and "descend." The default is "ascend." This attribute
is ignored if C<sort_method> is unspecified.

=item * top

If set to 1, displays only top level folders. Same as using
L<TopLevelFolders>.

=back

=for tags folders

=cut

sub _hdlr_sub_folders {
    my($ctx, $args, $cond) = @_;

    require MT::Folder;
    $args->{class_type} = MT::Folder->properties->{class_type};
    _hdlr_sub_categories($ctx, $args, $cond);
}

###########################################################################

=head2 SubFolderRecurse

Recursively call the L<SubFolders> or L<TopLevelFolders> container
with the subfolders of the folder in context. This tag, when placed at the
end of loop controlled by one of the tags above will cause them to
recursively descend into any subfolders that exist during the loop.

B<Attributes:>

=over 4

=item * max_depth (optional)

Specifies the maximum number of times the system should recurse. The default
is infinite depth.

=back

B<Examples:>

The following code prints out a recursive list of folders/subfolders, linking
those with entries assigned to their folder archive pages.

    <mt:TopLevelFolders>
      <mt:SubFolderIsFirst><ul></mt:SubFolderIsFirst>
        <mt:If tag="FolderCount">
            <li><a href="<$mt:FolderArchiveLink$>"
            title="<$mt:FolderDescription$>"><$mt:FolderLabel$></a>
        <mt:Else>
            <li><$mt:FolderLabel$>
        </mt:If>
        <$mt:SubFolderRecurse$>
        </li>
    <mt:SubFolderIsLast></ul></mt:SubFolderIsLast>
    </mt:TopLevelFolders>

Or more simply:

    <mt:TopLevelFolders>
        <$mt:FolderLabel$>
        <$mt:SubFolderRecurse$>
    </mt:TopLevelFolders>

=for tags folders

=cut

sub _hdlr_sub_folder_recurse {
    my($ctx, $args, $cond) = @_;

    require MT::Folder;
    $args->{class_type} = MT::Folder->properties->{class_type};
    _hdlr_sub_cats_recurse($ctx, $args, $cond);
}

###########################################################################

=head2 ParentFolders

A block tag that lists all the ancestors of the current folder.

B<Attributes:>

=over 4

=item * glue

This optional attribute is a shortcut for connecting each folder label
with its value. Single and double quotes are not permitted in the string.

=item * exclude_current

This optional boolean attribute controls the exclusion of the current
folder in the list.

=back

=for tags folders

=cut

sub _hdlr_parent_folders {
    my($ctx, $args, $cond) = @_;

    require MT::Folder;
    $args->{class_type} = MT::Folder->properties->{class_type};
    _hdlr_parent_categories($ctx, $args, $cond);
}

###########################################################################

=head2 ParentFolder

A container tag that creates a context to the current folder's parent.

B<Example:>

    <mt:ParentFolder>
        Up: <a href="<mt:ArchiveLink>"><mt:FolderLabel></a>
    </mt:ParentFolder>

=for tags folders

=cut

sub _hdlr_parent_folder {
    my($ctx, $args, $cond) = @_;

    require MT::Folder;
    $args->{class_type} = MT::Folder->properties->{class_type};
    _hdlr_parent_category($ctx, $args, $cond);
}

###########################################################################

=head2 TopLevelFolders

A block tag listing the folders that do not have a parent and exist at "the
top" of the folder hierarchy. Same as using C<E<lt>mt:SubFolders top="1"E<gt>>.

B<Example:>

    <mt:TopLevelFolders>
        <!-- do something -->
    </mt:TopLevelFolders>

=cut

sub _hdlr_top_level_folders {
    my($ctx, $args, $cond) = @_;

    require MT::Folder;
    $args->{class_type} = MT::Folder->properties->{class_type};
    _hdlr_top_level_categories($ctx, $args, $cond);
}

###########################################################################

=head2 TopLevelFolder

A container tag that creates a context to the top-level ancestor of
the current folder.

=for tags folders

=cut

sub _hdlr_top_level_folder {
    my($ctx, $args, $cond) = @_;

    require MT::Folder;
    $args->{class_type} = MT::Folder->properties->{class_type};
    return _hdlr_top_level_parent($ctx, $args, $cond);
}

###########################################################################

=head2 FolderBasename

Produces the dirified basename defined for the folder in context.

B<Attributes:>

=over 4

=item * default

A value to use in the event that no folder is in context.

=item * separator

Valid values are "_" and "-", dash is the default value. Specifying
an underscore will convert any dashes to underscores. Specifying a
dash will convert any underscores to dashes.

=back

B<Example:>

    <$mt:FolderBasename$>

=for tags folders

=cut

sub _hdlr_folder_basename {
    return undef unless &_check_folder(@_);
    return _hdlr_category_basename(@_);
}

###########################################################################

=head2 FolderDescription

The description for the folder in context.

B<Example:>

    <$mt:FolderDescription$>

=for tags folders

=cut

sub _hdlr_folder_description {
    return undef unless &_check_folder(@_);
    return _hdlr_category_desc(@_);
}

###########################################################################

=head2 FolderID

The numeric system ID of the folder.

B<Example:>

    <$mt:FolderID$>

=for tags folders

=cut

sub _hdlr_folder_id {
    return undef unless &_check_folder(@_);
    return _hdlr_category_id(@_);
}

###########################################################################

=head2 FolderLabel

The label of the folder in context.

B<Example:>

    <$mt:FolderLabel$>

=for tags folders

=cut

sub _hdlr_folder_label {
    return undef unless &_check_folder(@_);
    return _hdlr_category_label(@_);
}

###########################################################################

=head2 FolderCount

The number published pages in the folder.

B<Example:>

    <$mt:FolderCount$>

=for tags folders, pages

=cut

sub _hdlr_folder_count {
    return undef unless &_check_folder(@_);
    return _hdlr_category_count(@_);
}

###########################################################################

=head2 FolderPath

The path to the folder, relative to the L<BlogURL>.

B<Example:>

For the folder "Bar" in a folder "Foo" C<E<lt>$mt:FolderPath$E<gt>>
becomes foo/bar.

=for tags folders

=cut

sub _hdlr_folder_path {
    return undef unless &_check_folder(@_);
    return _hdlr_sub_category_path(@_);
}

###########################################################################

=head2 IfFolder

A conditional tag used to test for the folder assignment for the page
in context, or generically to test for which folder is in context.

B<Attributes:>

=over 4

=item * name (or label; optional)

The name of a folder. If given, tests the folder in context (or
folder of an entry in context) to see if it matches with the given
folder name.

=back

B<Example:>

    <mt:IfFolder name="News">
        (current page in context is in the "News" folder)
    </mt:IfFolder>

=for tags pages, folders

=cut

sub _hdlr_if_folder {
    return undef unless &_check_folder(@_);
    return _hdlr_if_category(@_);
}

###########################################################################

=head2 FolderHeader

The contents of this container tag will be displayed when the first
folder listed by a L<Folders> tag is reached.

=cut

sub _hdlr_folder_header {
    return undef unless &_check_folder(@_);
    my ($ctx) = @_;
    $ctx->stash('folder_header');
}

###########################################################################

=head2 FolderFooter

The contents of this container tag will be displayed when the last
folder listed by a L<Folders> tag is reached.

=for tags folders

=cut

sub _hdlr_folder_footer {
    return undef unless &_check_folder(@_);
    my ($ctx) = @_;
    $ctx->stash('folder_footer');
}

###########################################################################

=head2 HasSubFolders

Returns true if the current folder has a sub-folder.

=for tags folders

=cut

sub _hdlr_has_sub_folders {
    return undef unless &_check_folder(@_);
    &_hdlr_has_sub_categories(@_);
}

###########################################################################

=head2 HasParentFolder

Returns true if the current folder has a parent folder other than the
root.

=for tags folders

=cut

sub _hdlr_has_parent_folder {
    return undef unless &_check_folder(@_);
    &_hdlr_has_parent_category(@_);
}

sub _check_folder {
    my ($ctx) = @_;
    my $e = $ctx->stash('entry');
    my $cat = ($ctx->stash('category'))
        || (($e = $ctx->stash('entry')) && $e->category)
        or return $ctx->error(MT->translate(
            "You used an [_1] tag outside of the proper context.",
            'MT' . $ctx->stash('tag') ));
    1;
}

sub _check_page {
    my ($ctx) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_page_error();
    return $ctx->_no_page_error()
        if ref $e ne 'MT::Page';
    1;
}

# FIXME: should this routine return an empty string?
sub _object_score_for {
    my ($stash_key, $ctx, $args, $cond) = @_;
    my $key = $args->{namespace};
    return '' unless $key;
    my $object = $ctx->stash($stash_key);
    return '' unless $object;
    my $score = $object->score_for($key);
    if ( !$score && exists($args->{default}) ) {
        return $args->{default};
    }
    return $ctx->count_format($score, $args);
}

###########################################################################

=head2 EntryScore

A function tag that provides total score of the entry in context. Scores
grouped by namespace of a plugin are summed to calculate total score of an
entry.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for score to be calculated. Namespace is defined by each
plugin which leverages rating API.

=back

B<Example:>

    <$mt:EntryScore namespace="FiveStarRating"$>

=for tags entries, scoring

=cut

sub _hdlr_entry_score {
    return _object_score_for('entry', @_);
}

###########################################################################

=head2 CommentScore

A function tag that provides total score of the comment in context. Scores
grouped by namespace of a plugin are summed to calculate total score of a
comment.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for score to be calculated. Namespace is defined by each
plugin which leverages rating API.

=back

B<Example:>

    <$mt:CommentScore namespace="FiveStarRating"$>

=for tags comments, scoring

=cut

sub _hdlr_comment_score {
    return _object_score_for('comment', @_);
}

###########################################################################

=head2 PingScore

A function tag that provides total score of the TrackBack ping in context.
Scores grouped by namespace of a plugin are summed to calculate total
score of a TrackBack ping.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for the score to be sorted. Namespace is defined by each
plugin which leverages rating API.

=back

B<Example:>

    <$mt:PingScore namespace="FiveStarRating"$>

=for tags pings, scoring

=cut

sub _hdlr_ping_score {
    return _object_score_for('ping', @_);
}

###########################################################################

=head2 AssetScore

A function tag that provides total score of the asset in context. Scores
grouped by namespace of a plugin are summed to calculate total score of an
asset.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for score to be calculated. Namespace is defined by each
plugin which leverages rating API.

=back

B<Example:>

    <$mt:AssetScore namespace="FiveStarRating"$>

=for tags assets, scoring

=cut

sub _hdlr_asset_score {
    return _object_score_for('asset', @_);
}

###########################################################################

=head2 AuthorScore

A function tag that provides total score of the author in context. Scores
grouped by namespace of a plugin are summed to calculate total score of an
author.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for score to be calculated. Namespace is defined by each
plugin which leverages rating API.

=back

B<Example:>

    <$mt:AuthorScore namespace="FiveStarRating"$>

=for tags authors, scoring

=cut

sub _hdlr_author_score {
    return _object_score_for('author', @_);
}

sub _object_score_high {
    my ($stash_key, $ctx, $args, $cond) = @_;
    my $key = $args->{namespace};
    return '' unless $key;
    my $object = $ctx->stash($stash_key);
    return '' unless $object;
    return $object->score_high($key);
}

###########################################################################

=head2 EntryScoreHigh

A function tag that provides the highest score of the entry in context.
Scorings grouped by namespace of a plugin are sorted to find the highest
score of an entry.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for score to be calculated. Namespace is defined by each
plugin which leverages rating API.

=back

B<Example:>

    <$mt:EntryScoreHigh namespace="FiveStarRating"$>

=for tags entries, scoring

=cut

sub _hdlr_entry_score_high {
    return _object_score_high('entry', @_);
}

###########################################################################

=head2 CommentScoreHigh

A function tag that provides the highest score of the comment in context.
Scorings grouped by namespace of a plugin are sorted to find the
highest score of a comment.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for the score to be sorted. Namespace is defined by each
plugin which leverages rating API.

=back

B<Example:>

    <$mt:CommentScoreHigh namespace="FiveStarRating"$>

=for tags comments, scoring

=cut

sub _hdlr_comment_score_high {
    return _object_score_high('comment', @_);
}

###########################################################################

=head2 PingScoreHigh

A function tag that provides the highest score of the TrackBack ping
in context. Scorings grouped by namespace of a plugin are sorted to
find the highest score of a TrackBack ping.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for the score to be sorted. Namespace is defined by each
plugin which leverages rating API.

=back

B<Example:>

    <$mt:PingScoreHigh namespace="FiveStarRating"$>

=for tags pings, scoring

=cut

sub _hdlr_ping_score_high {
    return _object_score_high('ping', @_);
}

###########################################################################

=head2 AssetScoreHigh

A function tag that provides the highest score of the asset in context.
Scorings grouped by namespace of a plugin are sorted to find the
highest score of an asset.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for the score to be sorted. Namespace is defined by each
plugin which leverages rating API.

=back

B<Example:>

    <$mt:AssetScoreHigh namespace="FiveStarRating"$>

=for tags assets, scoring

=cut

sub _hdlr_asset_score_high {
    return _object_score_high('asset', @_);
}

###########################################################################

=head2 AuthorScoreHigh

A function tag that provides the highest score of the author in context.
Scorings grouped by namespace of a plugin are sorted to find the
highest score of an author.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for the score to be sorted. Namespace is defined by each
plugin which leverages rating API.

=back

B<Example:>

    <$mt:AuthorScoreHigh namespace="FiveStarRating"$>

=for tags authors, scoring

=cut

sub _hdlr_author_score_high {
    return _object_score_high('author', @_);
}

sub _object_score_low {
    my ($stash_key, $ctx, $args, $cond) = @_;
    my $key = $args->{namespace};
    return '' unless $key;
    my $object = $ctx->stash($stash_key);
    return '' unless $object;
    return $object->score_low($key);
}

###########################################################################

=head2 EntryScoreLow

A function tag that provides the lowest score of the entry in context.
Scorings grouped by namespace of a plugin are sorted to find the
lowest score of an entry.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for the score to be sorted. Namespace is defined by each
plugin which leverages rating API.

=back

B<Example:>

    <$mt:EntryScoreLow namespace="FiveStarRating"$>

=for tags entries, scoring

=cut

sub _hdlr_entry_score_low {
    return _object_score_low('entry', @_);
}

###########################################################################

=head2 CommentScoreLow

A function tag that provides the lowest score of the comment in context.
Scorings grouped by namespace of a plugin are sorted to find the lowest score
of a comment.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for the score to be sorted. Namespace is defined by each
plugin which leverages rating API.

=back

B<Example:>

    <$mt:CommentScoreLow namespace="FiveStarRating"$>

=for tags comments, scoring

=cut

sub _hdlr_comment_score_low {
    return _object_score_low('comment', @_);
}

###########################################################################

=head2 PingScoreLow

A function tag that provides the lowest score of the TrackBack ping in context. Scorings grouped by namespace of a plugin are sorted to find the lowest score of a TrackBack ping.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for the score to be sorted. Namespace is defined by each
plugin which leverages rating API.

=back

B<Example:>

    <$mt:PingScoreLow namespace="FiveStarRating"$>

=for tags pings, scoring

=cut

sub _hdlr_ping_score_low {
    return _object_score_low('ping', @_);
}

###########################################################################

=head2 AssetScoreLow

A function tag that provides the lowest score of the asset in context.
Scorings grouped by namespace of a plugin are sorted to find the lowest
score of an asset.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for the score to be sorted. Namespace is defined by each
plugin which leverages rating API.

=back

B<Example:>

    <$mt:AssetScoreLow namespace="FiveStarRating"$>

=for tags assets, scoring

=cut

sub _hdlr_asset_score_low {
    return _object_score_low('asset', @_);
}

###########################################################################

=head2 AuthorScoreLow

A function tag that provides the lowest score of the author in context.
Scorings grouped by namespace of a plugin are sorted to find the lowest
score of an author.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for the score to be sorted. Namespace is defined by each
plugin which leverages rating API.

=back

B<Example:>

    <$mt:AuthorScoreLow namespace="FiveStarRating"$>

=for tags authors, scoring

=cut

sub _hdlr_author_score_low {
    return _object_score_low('author', @_);
}

# FIXME: should this routine return an empty string?
sub _object_score_avg {
    my ($stash_key, $ctx, $args, $cond) = @_;
    my $key = $args->{namespace};
    return '' unless $key;
    my $object = $ctx->stash($stash_key);
    return '' unless $object;
    my $avg = $object->score_avg($key);
    return $ctx->count_format($avg, $args);
}

###########################################################################

=head2 EntryScoreAvg

A function tag that provides the avarage score of the entry in context. Scores
grouped by namespace of a plugin are summed to calculate total score of an
entry, and average is calculated by dividing the total score by the number of
scorings or 'votes'.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for avarage score to be calculated. Namespace is defined by
each plugin which leverages rating API.

=back

B<Example:>

    <$mt:EntryScoreAvg namespace="FiveStarRating"$>

=for tags entries, scoring

=cut

sub _hdlr_entry_score_avg {
    return _object_score_avg('entry', @_);
}

###########################################################################

=head2 CommentScoreAvg

A function tag that provides the avarage score of the comment in context.
Scores grouped by namespace of a plugin are summed to calculate total
score of a comment, and average is calculated by dividing the total
score by the number of scorings or 'votes'.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for avarage score to be calculated. Namespace is defined by
each plugin which leverages rating API.

=back

B<Example:>

    <$mt:CommentScoreAvg namespace="FiveStarRating"$>

=for tags comments, scoring

=cut

sub _hdlr_comment_score_avg {
    return _object_score_avg('comment', @_);
}

###########################################################################

=head2 PingScoreAvg

A function tag that provides the avarage score of the TrackBack ping in
context. Scores grouped by namespace of a plugin are summed to calculate
total score of a TrackBack ping, and average is calculated by dividing the
total score by the number of scorings or 'votes'.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for avarage score to be calculated. Namespace is defined by
each plugin which leverages rating API.

=back

B<Example:>

    <$mt:PingScoreAvg namespace="FiveStarRating"$>

=for tags pings, scoring

=cut

sub _hdlr_ping_score_avg {
    return _object_score_avg('ping', @_);
}

###########################################################################

=head2 AssetScoreAvg

A function tag that provides the avarage score of the asset in context.
Scores grouped by namespace of a plugin are summed to calculate total
score of an asset, and average is calculated by dividing the total
score by the number of scorings or 'votes'.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for avarage score to be calculated. Namespace is defined by
each plugin which leverages rating API.

=back

B<Example:>

    <$mt:AssetScoreAvg namespace="FiveStarRating"$>

=for tags assets, scoring

=cut

sub _hdlr_asset_score_avg {
    return _object_score_avg('asset', @_);
}

###########################################################################

=head2 AuthorScoreAvg

A function tag that provides the avarage score of the author in context.
Scores grouped by namespace of a plugin are summed to calculate total score of
an author, and average is calculated by dividing the total score by the number
of scorings or 'votes'.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for avarage score to be calculated. Namespace is defined by
each plugin which leverages rating API.

=back

B<Example:>

    <$mt:AuthorScoreAvg namespace="FiveStarRating"$>

=for tags authors, scoring

=cut

sub _hdlr_author_score_avg {
    return _object_score_avg('author', @_);
}

# FIXME: should this routine return an empty string?
sub _object_score_count {
    my ($stash_key, $ctx, $args, $cond) = @_;
    my $key = $args->{namespace};
    return '' unless $key;
    my $object = $ctx->stash($stash_key);
    return '' unless $object;
    my $count = $object->vote_for($key);
    return $ctx->count_format($count, $args);
}

###########################################################################

=head2 EntryScoreCount

A function tag that provides the number of scorings or 'votes' made to the
entry in context. Scorings grouped by namespace of a plugin are summed.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for the number of scorings to be calculated. Namespace is
defined by each plugin which leverages rating API.

=back

B<Example:>

    <$mt:EntryScoreCount namespace="FiveStarRating"$>

=for tags entries, scoring

=cut

sub _hdlr_entry_score_count {
    return _object_score_count('entry', @_);
}

###########################################################################

=head2 CommentScoreCount

A function tag that provides the number of scorings or 'votes' made to
the comment in context. Scorings grouped by namespace of a plugin are
summed.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for the number of scorings to be calculated. Namespace is
defined by each plugin which leverages rating API.

=back

B<Example:>

    <$mt:CommentScoreCount namespace="FiveStarRating"$>

=for tags comments, scoring

=cut

sub _hdlr_comment_score_count {
    return _object_score_count('comment', @_);
}

###########################################################################

=head2 PingScoreCount

A function tag that provides the number of scorings or 'votes' made to the
TrackBack ping in context. Scorings grouped by namespace of a plugin are
summed.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for the number of scorings to be calculated. Namespace is
defined by each plugin which leverages rating API.

=back

B<Example:>

    <$mt:PingScoreCount namespace="FiveStarRating"$>

=for tags pings, scoring

=cut

sub _hdlr_ping_score_count {
    return _object_score_count('ping', @_);
}

###########################################################################

=head2 AssetScoreCount

A function tag that provides the number of scorings or 'votes' made to the
asset in context. Scorings grouped by namespace of a plugin are summed.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for the number of scorings to be calculated. Namespace is
defined by each plugin which leverages rating API.

=back

B<Example:>

    <$mt:AssetScoreCount namespace="FiveStarRating"$>

=for tags assets, scoring

=cut

sub _hdlr_asset_score_count {
    return _object_score_count('asset', @_);
}

###########################################################################

=head2 AuthorScoreCount

A function tag that provides the number of scorings or 'votes' made to the
author in context. Scorings grouped by namespace of a plugin are summed.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for the number of scorings to be calculated. Namespace is
defined by each plugin which leverages rating API.

=back

B<Example:>

    <$mt:AuthorScoreCount namespace="FiveStarRating"$>

=for tags authors, scoring

=cut

sub _hdlr_author_score_count {
    return _object_score_count('author', @_);
}

sub _object_rank {
    my ($stash_key, $dbd_args, $ctx, $args, $cond) = @_;
    my $key = $args->{namespace};
    return '' unless $key;
    my $object = $ctx->stash($stash_key);
    return '' unless $object;
    return $object->rank_for($key, $args->{max}, $dbd_args);
}

###########################################################################

=head2 EntryRank

A function tag which returns a number from 1 to 6 (by default) which
represents the rating of the entry in context in terms of total
score where '1' is used for the highest score, '6' for the lowest score.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for rank to be calculated. Namespace is defined by each plugin which leverages rating API.

=item * max (optional; default "6")

Allows a user to specify the upper bound of the scale.

=back

B<Example:>

    <$mt:EntryRank namespace="FiveStarRating"$>

=for tags entries, scoring

=cut

sub _hdlr_entry_rank {
    return _object_rank(
        'entry',
        {
            'join' => MT->model('entry')->join_on(
                undef,
                {
                    id     => \'= objectscore_object_id',
                    status => MT::Entry::RELEASE()
                }
            )
        },
        @_
    );
}

###########################################################################

=head2 CommentRank

A function tag which returns a number from 1 to 6 (by default) which
represents the rating of the comment in context in terms of total score
where '1' is used for the highest score, '6' for the lowest score.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for rank to be calculated. Namespace is defined by each plugin which leverages rating API.

=item * max (optional; default "6")

Allows a user to specify the upper bound of the scale.

=back

B<Example:>

    <$mt:CommentRank namespace="FiveStarRating"$>

=for tags comments, scoring

=cut

sub _hdlr_comment_rank {
    return _object_rank(
        'comment',
        {
            'join' => MT->model('comment')->join_on(
                undef, { id => \'= objectscore_object_id', visible => 1, }
            )
        },
        @_
    );
}

###########################################################################

=head2 PingRank

A function tag which returns a number from 1 to 6 (by default) which
represents the rating of the TrackBack ping in context in terms of total score
where '1' is used for the highest score, '6' for the lowest score.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for rank to be calculated. Namespace is defined by each plugin which leverages rating API.

=item * max (optional; default "6")

Allows a user to specify the upper bound of the scale.

=back

B<Example:>

    <$mt:PingRank namespace="FiveStarRating"$>

=for tags pings, scoring

=cut

sub _hdlr_ping_rank {
    return _object_rank(
        'ping',
        {
            'join' => MT->model('ping')->join_on(
                undef, { id => \'= objectscore_object_id', visible => 1, }
            )
        },
        @_
    );
}

###########################################################################

=head2 AssetRank

A function tag which returns a number from 1 to 6 (by default) which
represents the rating of the asset in context in terms of total score where
'1' is used for the highest score, '6' for the lowest score.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for rank to be calculated. Namespace is defined by each plugin which leverages rating API.

=item * max (optional; default "6")

Allows a user to specify the upper bound of the scale.

=back

B<Example:>

    <$mt:AssetRank namespace="FiveStarRating"$>

=for tags assets, scoring

=cut

sub _hdlr_asset_rank {
    return _object_rank('asset', {}, @_);
}

###########################################################################

=head2 AuthorRank

A function tag which returns a number from 1 to 6 (by default) which
represents the rating of the author in context in terms of total score where
'1' is used for the highest score, '6' for the lowest score.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for rank to be calculated. Namespace is defined by each plugin which leverages rating API.

=item * max (optional; default "6")

Allows a user to specify the upper bound of the scale.

=back

B<Example:>

    <$mt:AuthorRank namespace="FiveStarRating"$>

=for tags authors, scoring

=cut

sub _hdlr_author_rank {
    return _object_rank('author', {},  @_);
}

###########################################################################

=head2 AuthorNext

A container tag which creates a author context of the next author. The
order of authors is determined by author's login name. Authors who have
at least a published entry will be considered in finding the next author.

B<Example:>

    <mt:AuthorNext>
        <a href="<$mt:ArchiveLink archive_type="Author"$>"><$mt:AuthorDisplayName$></a>
    </mt:AuthorNext>

=for tags authors, archives

=cut

###########################################################################

=head2 AuthorPrevious

A container tag which creates a author context of the previous author. The
order of authors is determined by author's login name. Authors who have
at least a published entry will be considered in finding the previous author.

B<Example:>

    <mt:AuthorPrevious>
        <a href="<$mt:ArchiveLink archive_type="Author"$>"><$mt:AuthorDisplayName$></a>
    </mt:AuthorPrevious>

=for tags authors, archives

=cut

sub _hdlr_author_next_prev {
    my($ctx, $args, $cond) = @_;
    my $tag = $ctx->stash('tag');
    my $is_prev = $tag eq 'AuthorPrevious';
    my $author = $ctx->stash('author')
        or return $ctx->error(MT->translate(
            "You used an [_1] without a author context set up.", "<MT$tag>"));
    my $blog = $ctx->stash('blog');
    my @args = ($author->name, $blog->id, $is_prev ? 'previous' : 'next');
    my $res = '';
    if (my $next = _get_author(@args)) {
        my $builder = $ctx->stash('builder');
        local $ctx->{__stash}->{author} = $next;
        defined(my $out = $builder->build($ctx, $ctx->stash('tokens'),
            $cond))
            or return $ctx->error( $builder->errstr );
        $res .= $out;
    }
    $res;
}

sub _get_author {
    my ($author_name, $blog_id, $order) = @_;

    if ($order eq 'previous') {
        $order = 'descend';
    } else {
        $order = 'ascend';
    }
    require MT::Entry;
    require MT::Author;
    my $author = MT::Author->load(undef,
        { 'sort' => 'name',
          direction => $order,
          start_val => $author_name,
          'join' => ['MT::Entry', 'author_id',
            { status => MT::Entry::RELEASE(),
              blog_id => $blog_id },
            { unique => 1}]});
    $author;
}

###########################################################################

=head2 Section

A utility block tag that is used to wrap content that can be cached,
or merely manipulated by any of Movable Type's tag modifiers.

B<Attributes:>

=over 4

=item * cache_prefix (optional)

When specified, causes the contents of the section tag to be cached
for some period of time. The 'period' attribute can specify the
cache duration (in seconds), or will use the C<DashboardCachePeriod>
configuration setting as a default (this feature was initially added
to support cacheable portions of the Movable Type Dashboard).

=item * period (optional)

A number in seconds defining the duration to cache the content produced
by the tag. Use in combination with the 'cache_prefix' attribute.

=item * by_blog (optional)

When using the 'cache_prefix' attribute, specifying '1' for this
attribute will cause the content to be cached on a per-blog basis
(otherwise, the default is system-wide).

=item * by_user (optional)

When using the 'cache_prefix' attribute, specifying '1' for this
attribute will cause the content to be cached on a per-user basis
(otherwise, the default is system-wide).

=item * html_tag (optional)

If specified, causes the content of the tag to be enclosed in a
the HTML tag identified. Example:

    <mt:Section html_tag="p">Lorem ipsum...</mt:Section>

Which would output:

    <p>Lorem ipsum...</p>

=item * id (optional)

If specified in combination with the 'html_tag' attribute, this 'id'
is added to the wrapping HTML tag.

=back

=for tags utility, templating

=cut

sub _hdlr_section {
    my($ctx, $args, $cond) = @_;
    my $app = MT->instance;
    my $out;
    my $cache_require;

    # make cache id
    my $cache_id = $args->{cache_prefix} || undef;

    # read timeout. if timeout == 0 then, content is never cached.
    my $timeout = $args->{period};
    $timeout = $app->config('DashboardCachePeriod') if !defined $timeout;
    if (defined $timeout && ($timeout > 0)) {
        if (defined $cache_id) {
            if ($args->{by_blog}) {
                my $blog = $app->blog;
                $cache_id .= ':blog_id=';
                $cache_id .= $blog ? $blog->id : '0';
            }
            if ($args->{by_user}) {
                my $author = $app->user
                    or return $ctx->error(MT->translate(
                        "Can't load user."));
                $cache_id .= ':user_id='.$author->id;
            }

            # try to load from session
            require MT::Session;
            my $sess = MT::Session::get_unexpired_value(
                $timeout,
                { id => $cache_id, kind => 'CO' }); # CO == Cache Object
            if (defined $sess) {
                $out = $sess->data();
                if ($out) {
                    if (my $wrap_tag = $args->{html_tag}) {
                        my $id = $args->{id};
                        $id = " id=\"$id\"" if $id;
                        $id = '' unless defined $id;
                        $out = "<$wrap_tag$id>" . $out . "</$wrap_tag>";
                    }
                    return $out;
                }
            }
        }

        # load failed (timeout or record not found)
        $cache_require = 1;
    }

    # build content
    defined($out = $ctx->stash('builder')->build($ctx, $ctx->stash('tokens'), $cond))
        or return $ctx->error($ctx->stash('builder')->errstr);

    if ($cache_require && (defined $cache_id)) {
        my $sess = MT::Session->load({
            id => $cache_id, kind => 'CO'});
        if ($sess) {
            $sess->remove();
        }
        $sess = MT::Session->new;
        $sess->set_values({ id => $cache_id,
                            kind => 'CO',
                            start => time,
                            data => $out});
        $sess->save();
    }

    if (my $wrap_tag = $args->{html_tag}) {
        my $id = $args->{id};
        $id = " id=\"$id\"" if $id;
        $id = '' unless defined $id;
        $out = "<$wrap_tag$id>" . $out . "</$wrap_tag>";
    }
    return $out;
}

sub _math_operation {
    my ($ctx, $op, $lvalue, $rvalue) = @_;
    return $lvalue
        unless ( $lvalue =~ m/^\-?[\d\.]+$/ )
            && ( ( defined($rvalue) && ( $rvalue =~ m/^\-?[\d\.]+$/ ) )
              || ( ( $op eq 'inc' ) || ( $op eq 'dec' ) || ( $op eq '++' ) || ( $op eq '--' ) )
            );
    if ( ( '+' eq $op ) || ( 'add' eq $op ) ) {
        return $lvalue + $rvalue;
    }
    elsif ( ( '++' eq $op ) || ( 'inc' eq $op ) ) {
        return $lvalue + 1;
    }
    elsif ( ( '-' eq $op ) || ( 'sub' eq $op ) ) {
        return $lvalue - $rvalue;
    }
    elsif ( ( '--' eq $op ) || ( 'dec' eq $op ) ) {
        return $lvalue - 1;
    }
    elsif ( ( '*' eq $op ) || ( 'mul' eq $op ) ) {
        return $lvalue * $rvalue;
    }
    elsif ( ( '/' eq $op ) || ( 'div' eq $op ) ) {
        return $ctx->error( MT->translate('Division by zero.') )
            if $rvalue == 0;
        return $lvalue / $rvalue;
    }
    elsif ( ( '%' eq $op ) || ( 'mod' eq $op ) ) {
        # Perl % is integer only
        $lvalue = int($lvalue);
        $rvalue = int($rvalue);
        return $ctx->error( MT->translate('Division by zero.') )
            if $rvalue == 0;
        return $lvalue % $rvalue;
    }
    return $lvalue;
}

###########################################################################

=head2 IfMoreResults

A conditional tag used to test whether the requested content has more
to show than currently appearing in the page.

=for tags pagination

=cut

sub _hdlr_if_more_results {
    my ($ctx) = @_;
    my $limit = $ctx->stash('limit');
    my $offset = $ctx->stash('offset');
    my $count = $ctx->stash('count');
    return $limit + $offset >= $count ? 0 : 1;
}

###########################################################################

=head2 IfPreviousResults

A conditional tag used to test whether the requested content has previous
page.

=for tags pagination

=cut

sub _hdlr_if_previous_results {
    my ($ctx) = @_;
    return $ctx->stash('offset') ? 1 : 0;
}

###########################################################################

=head2 PagerBlock

A block tag iterates from 1 to the number of the last page in the search
result. For example, if the limit was 10 and the number of results is 75,
the tag loops from 1 through 8. 

The page number is set to __value__ standard variable in each iteration. 

The tag also sets __odd__, __even__, __first__, __last__ and __counter__
standard variables. 

=for tags pagination

=back

B<Example:>

    M
    <MTPagerBlock>
      <MTIfCurrentPage>o<MTElse><a href="<MTPagerLink>">o</a></MTIfCurrentPage>
    </MTPagerBlock>
    vable Type

produces:

    "Mooooooooovable Type" where each "o" is a link to the page.

=cut

sub _hdlr_pager_block {
    my ($ctx, $args, $cond) = @_;

    my $build = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');

    my $limit = $ctx->stash('limit');
    my $offset = $ctx->stash('offset');
    my $count = $ctx->stash('count');

    my $glue = $args->{glue};

    my $output = q();
    require POSIX;
    my $pages = $limit ? POSIX::ceil( $count / $limit ) : 1;
    my $vars = $ctx->{__stash}{vars} ||= {};
    for ( my $i = 1; $i <= $pages; $i++ ) {
        local $vars->{__first__} = $i == 1;
        local $vars->{__last__} = $i == $pages;
        local $vars->{__odd__} = ($i % 2 ) == 1;
        local $vars->{__even__} = ($i % 2 ) == 0;
        local $vars->{__counter__} = $i;
        local $vars->{__value__} = $i;
        defined(my $out = $build->build($ctx, $tokens,
            { %$cond, 
              IfCurrentPage => $i == ( $limit ? $offset / $limit + 1 : 1 ),
            }
            )) or return $ctx->error( $build->errstr );
        $output .= $glue if defined $glue && $i > 1 && length($output) && length($out);
        $output .= $out;
    }
    $output;
}

###########################################################################

=head2 IfCurrentPage

A conditional tag returns true if the current page in the context of
PagerBlock is the current page that is being rendered. 
The tag must be used in the context of PagerBlock.

=for tags pagination

=cut

# overridden in other contexts
sub context_script { '' }

###########################################################################

=head2 PagerLink

A function tag returns the URL points to the page in the context of
PagerBlock. The tag can only be used in the context of PagerBlock. 

=for tags pagination

=cut

sub _hdlr_pager_link {
    my ($ctx, $args) = @_;

    my $page = $ctx->var('__value__');
    return q() unless $page;

    my $limit = $ctx->stash('limit');
    my $offset = $ctx->stash('offset');
    $offset = ( $page - 1 ) * $limit;

    my $link = $ctx->context_script($args);

    if ( $link ) {
        if ( index($link, '?') > 0 ) {
            $link .= '&';
        }
        else {
            $link .= '?';
        }
    }
    $link .= "limit=$limit";
    $link .= "&offset=$offset" if $offset;
    return $link;
}

###########################################################################

=head2 CurrentPage

A function tag returns a number represents the number of current page.
The number starts from 1.

=for tags pagination

=cut

sub _hdlr_current_page {
    my ($ctx) = @_;
    my $limit = $ctx->stash('limit');
    my $offset = $ctx->stash('offset');
    return $limit ? $offset / $limit + 1 : 1;
}

###########################################################################

=head2 TotalPages

A function tag returns a number represents the total number of pages
in the current search context. The number starts from 1. 

=for tags pagination

=cut

sub _hdlr_total_pages {
    my ($ctx) = @_;
    my $limit = $ctx->stash('limit');
    return 1 unless $limit;
    my $count = $ctx->stash('count');
    require POSIX;
    return POSIX::ceil( $count / $limit );
}

###########################################################################

=head2 PreviousLink

A function tag returns the URL points to the previous page of 
the current page that is being rendered.

=for tags pagination

=cut

sub _hdlr_previous_link {
    my ($ctx, $args) = @_;

    my $limit = $ctx->stash('limit');
    my $offset = $ctx->stash('offset');
    my $count = $ctx->stash('count');

    return q() unless $offset;
    my $current_page = $limit ? $offset / $limit + 1 : 1;
    return q() unless $current_page > 1;

    local $ctx->{__stash}{vars}{__value__} = $current_page - 1;
    return _hdlr_pager_link(@_);
}

###########################################################################

=head2 NextLink

A function tag returns the URL points to the next page of the current page
that is being rendered. 

=for tags pagination

=cut

sub _hdlr_next_link {
    my ($ctx, $args) = @_;

    my $limit = $ctx->stash('limit');
    my $offset = $ctx->stash('offset');
    my $count = $ctx->stash('count');

    return q() if ( $limit + $offset ) >= $count;
    my $current_page = $limit ? $offset / $limit + 1 : 1;

    local $ctx->{__stash}{vars}{__value__} = $current_page + 1;
    return _hdlr_pager_link(@_);
}

###########################################################################

=head2 WidgetManager

An alias for the L<WidgetSet> tag, and considered deprecated.

=for tags deprecated

=cut

###########################################################################

=head2 WidgetSet

Publishes the widget set identified by the C<name> attribute.

B<Attributes:>

=over 4

=item * name (required)

The name of the widget set to publish.

=item * blog_id (optional)

The target blog to use as a context for loading the widget set. This only
affects the loading of the widget set: it does not set the blog context
for the widgets that are published. By default, the blog in context is
used. You may specify a value of "0" for blog_id to target a global
widget set.

=back

B<Example:>

    <$mt:WidgetSet name="Sidebar"$>

=for tags widgets

=cut

sub _hdlr_widget_manager {
    my ( $ctx, $args ) = @_;
    my $tmpl_name = $args->{name}
        or return $ctx->error(MT->translate("name is required."));
    my $blog_id = $args->{blog_id} || $ctx->{__stash}{blog_id} || 0;

    require MT::Template;
    my $tmpl = MT::Template->load({ name => $tmpl_name,
                                    blog_id => $blog_id ? [ 0, $blog_id ] : 0,
                                    type => 'widgetset' })
        or return $ctx->error(MT->translate( "Specified WidgetSet '[_1]' not found.", $tmpl_name ));
    my $text = $tmpl->text;
    return $ctx->build($text) if $text;

    my $modulesets = $tmpl->modulesets;
    return ''; # empty widgetset is not an error

    my $string_tmpl = '<mt:include widget="%s">';
    my @selected = split ','. $modulesets;
    foreach my $mid (@selected) {
        my $wtmpl = MT::Template->load($mid)
            or return $ctx->error(MT->translate(
                "Can't find included template widget '[_1]'", $mid ));
        $text .= sprintf( $string_tmpl, $wtmpl->name );
    }
    return '' unless $text;
    return $ctx->build($text);
}

1;

__END__
