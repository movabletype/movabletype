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
            IfNonEmpty => \&_hdlr_if_nonempty,
            IfNonZero => \&_hdlr_if_nonzero,

            IfCommenterTrusted => \&_hdlr_commenter_trusted,
            CommenterIfTrusted => \&_hdlr_commenter_trusted,
            IfCommenterIsAuthor => \&_hdlr_commenter_isauthor,
            IfCommenterIsEntryAuthor => \&_hdlr_commenter_isauthor,

            'IfBlog?' => \&_hdlr_blog_id,
            'IfAuthor?' => \&_hdlr_if_author,
            'AuthorHasEntry?' => \&_hdlr_author_has_entry,
            'AuthorHasPage?' => \&_hdlr_author_has_page,
            Authors => \&_hdlr_authors,

            Blogs => \&_hdlr_blogs,
            'BlogIfCCLicense?' => \&_hdlr_blog_if_cc_license,
            Entries => \&_hdlr_entries,
            EntriesHeader => \&_hdlr_pass_tokens,
            EntriesFooter => \&_hdlr_pass_tokens,
            EntryCategories => \&_hdlr_entry_categories,
            EntryAdditionalCategories => \&_hdlr_entry_additional_categories,
            BlogIfCommentsOpen => \&_hdlr_blog_if_comments_open,
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

            IfCommentsModerated => \&_hdlr_comments_moderated,
            IfRegistrationRequired => \&_hdlr_reg_required,
            IfRegistrationNotRequired => \&_hdlr_reg_not_required,
            IfRegistrationAllowed => \&_hdlr_reg_allowed,

            IfTypeKeyToken => \&_hdlr_if_typekey_token,

            Comments => \&_hdlr_comments,
            CommentsHeader => \&_hdlr_pass_tokens,
            CommentsFooter => \&_hdlr_pass_tokens,
            CommentEntry => \&_hdlr_comment_entry,
            CommentIfModerated => \&_hdlr_comment_if_moderated,

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
            CategoryIfAllowPings => \&_hdlr_category_allow_pings,
            CategoryPrevious => \&_hdlr_category_prevnext,
            CategoryNext => \&_hdlr_category_prevnext,

            Pings => \&_hdlr_pings,
            PingsSent => \&_hdlr_pings_sent,
            PingEntry => \&_hdlr_ping_entry,

            IfAllowCommentHTML => \&_hdlr_if_allow_comment_html,
            IfCommentsAllowed => \&_hdlr_if_comments_allowed,
            IfCommentsAccepted => \&_hdlr_if_comments_accepted,
            IfCommentsActive => \&_hdlr_if_comments_active,
            IfPingsAllowed => \&_hdlr_if_pings_allowed,
            IfPingsAccepted => \&_hdlr_if_pings_accepted,
            IfPingsActive => \&_hdlr_if_pings_active,
            IfPingsModerated => \&_hdlr_if_pings_moderated,
            IfNeedEmail => \&_hdlr_if_need_email,
            IfRequireCommentEmails => \&_hdlr_if_need_email,
            EntryIfAllowComments => \&_hdlr_if_comments_active,
            EntryIfCommentsOpen => \&_hdlr_entry_if_comments_open,
            EntryIfAllowPings => \&_hdlr_entry_if_allow_pings,
            EntryIfExtended => \&_hdlr_entry_if_extended,

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

            # stubs for mt-search tags used in template includes
            IfTagSearch => sub { '' },
            SearchResults => sub { '' },

            IfStraightSearch => sub { '' },
            NoSearchResults => \&_hdlr_pass_tokens,
            NoSearch => \&_hdlr_pass_tokens,
            BlogResultHeader => sub { '' },
            BlogResultFooter => sub { '' },
            IfMaxResultsCutoff => sub { '' },
            SearchIfMoreResults => sub { '' },
            SearchIfPreviousResults => sub { '' },
            SearchResultPages => sub { '' },
            SearchIfCurrentPage => sub { '' },
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
            AuthorNext => \&_hdlr_author_prev_next,
            AuthorPrevious => \&_hdlr_author_prev_next,
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

            ErrorMessage => \&_hdlr_error_message,

            GetVar => \&_hdlr_get_var,
            SetVar => \&_hdlr_set_var,

            TypeKeyToken => \&_hdlr_typekey_token,
            CommentFields => \&_hdlr_comment_fields,
            RemoteSignOutLink => \&_hdlr_remote_sign_out_link,
            RemoteSignInLink => \&_hdlr_remote_sign_in_link,

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
            CfgMaxResults => sub { $_[0]->{config}->MaxResults },
            SearchIncludeBlogs => sub { '' },
            SearchTemplateID => sub { 0 },
            SearchPageLink => sub { '' },
            SearchNextLink => sub { '' },
            SearchPreviousLink => sub { '' },
            SearchCurrentPage => sub { '' },
            SearchTotalPages => sub { '' },

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
        },
        modifier => {
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

sub _fltr_setvar {
    my ($str, $arg, $ctx) = @_;
    $ctx->var($arg, $str);
    return '';
}

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

sub _fltr_filters {
    my ($str, $val, $ctx) = @_;
    MT->apply_text_filters($str, [ split /\s*,\s*/, $val ], $ctx);
}
sub _fltr_trim_to {
    my ($str, $val, $ctx) = @_;
    return '' if $val <= 0;
    $str = substr_text($str, 0, $val) if $val < length_text($str);
    $str;
}
sub _fltr_trim {
    my ($str, $val, $ctx) = @_;
    $str =~ s/^\s+|\s+$//gs;
    $str;
}
sub _fltr_ltrim {
    my ($str, $val, $ctx) = @_;
    $str =~ s/^\s+//s;
    $str;
}
sub _fltr_rtrim {
    my ($str, $val, $ctx) = @_;
    $str =~ s/\s+$//s;
    $str;
}
sub _fltr_decode_html {
    my ($str, $val, $ctx) = @_;
    MT::Util::decode_html($str);
}
sub _fltr_decode_xml {
    my ($str, $val, $ctx) = @_;
    decode_xml($str);
}
sub _fltr_remove_html {
    my ($str, $val, $ctx) = @_;
    MT::Util::remove_html($str);
}
sub _fltr_dirify {
    my ($str, $val, $ctx) = @_;
    return $str if (defined $val) && ($val eq '0');
    MT::Util::dirify($str, $val);
}
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
sub _fltr_encode_html {
    my ($str, $val, $ctx) = @_;
    MT::Util::encode_html($str, 1);
}
sub _fltr_encode_xml {
    my ($str, $val, $ctx) = @_;
    MT::Util::encode_xml($str);
}
sub _fltr_encode_js {
    my ($str, $val, $ctx) = @_;
    MT::Util::encode_js($str);
}
sub _fltr_encode_php {
    my ($str, $val, $ctx) = @_;
    MT::Util::encode_php($str, $val);
}
sub _fltr_encode_url {
    my ($str, $val, $ctx) = @_;
    MT::Util::encode_url($str);
}
sub _fltr_upper_case {
    my ($str, $val, $ctx) = @_;
    return uppercase($str);
}
sub _fltr_lower_case {
    my ($str, $val, $ctx) = @_;
    return lowercase($str);
}
sub _fltr_strip_linefeeds {
    my ($str, $val, $ctx) = @_;
    $str =~ tr(\r\n)()d;
    $str;
}
sub _fltr_space_pad {
    my ($str, $val, $ctx) = @_;
    sprintf "%${val}s", $str;
}
sub _fltr_zero_pad {
    my ($str, $val, $ctx) = @_;
    sprintf "%0${val}s", $str;
}
sub _fltr_sprintf {
    my ($str, $val, $ctx) = @_;
    sprintf $val, $str;
}

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
            $replace =~ s!\\\\(\d+)!\$$1!g; # for php, \\1 is how you write $1
            if ($global) {
                $str =~ s/$re/$replace/g;
                my @matches = ($0, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20);
                $str =~ s/\$(\d+)/$matches[$1]/g;
            } else {
                $str =~ s/$re/$replace/;
                my @matches = ($0, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20);
                $str =~ s/\$(\d+)/$matches[$1]/g;
            }
        }
    }
    return $str;
}

sub _fltr_capitalize {
    my ($str, $val, $ctx) = @_;
    $str =~ s/\b(\w+)\b/\u\L$1/g;
    return $str;
}

sub _fltr_count_characters {
    my ($str, $val, $ctx) = @_;
    return length_text($str);
}

sub _fltr_cat {
    my ($str, $val, $ctx) = @_;
    return $str . $val;
}

sub _fltr_count_paragraphs {
    my ($str, $val, $ctx) = @_;
    my @paras = split /[\r\n]+/, $str;
    return scalar @paras;
}

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

sub _fltr_indent {
    my ($str, $val, $ctx) = @_;
    if ((my $len = int($val)) > 0) {
        my $space = ' ' x $len;
        $str =~ s/^/$space/mg;
    }
    return $str;
}

sub _fltr_nl2br {
    my ($str, $val, $ctx) = @_;
    if ($val eq 'xhtml') {
        $str =~ s/\r?\n/<br \/>/g;
    } else {
        $str =~ s/\r?\n/<br>/g;
    }
    return $str;
}

sub _fltr_replace {
    my ($str, $val, $ctx) = @_;
    # This one requires an array
    return $str unless ref($val) eq 'ARRAY';
    my $search = $val->[0];
    my $replace = $val->[1];
    $str =~ s/\Q$search\E/$replace/g;
    return $str;
}

sub _fltr_spacify {
    my ($str, $val, $ctx) = @_;
    my @c = split //, $str;
    return join $val, @c;
}

sub _fltr_strip {
    my ($str, $val, $ctx) = @_;
    $val = ' ' unless defined $val;
    $str =~ s/\s+/$val/g;
    return $str;
}

sub _fltr_strip_tags {
    my ($str, $val, $ctx) = @_;
    return MT::Util::remove_html($str);
}

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

sub _fltr_wrap_text {
    my ($str, $val, $ctx) = @_;
    my $ret = wrap_text($str, $val);
    return $ret;
}

##  Core template tags

sub _hdlr_app_listing {
    my ($ctx, $args, $cond) = @_;

    my $type = $args->{type} || $ctx->var('object_type');
    my $class = MT->model($type);
    my $loop = $args->{loop} || 'object_loop';
    my $loop_obj = $ctx->var($loop);

    unless ((ref($loop_obj) eq 'ARRAY') && (@$loop_obj)) {
        my @else = @{ $ctx->stash('tokens_else') || [] };
        return &_hdlr_pass_tokens_else if @else;
        my $msg = $args->{empty_message} || MT->translate("No [_1] could be found.", lowercase($class->class_label_plural));
        return $ctx->build(qq{<mtapp:statusmsg
            id="zero-state"
            class="info zero-state">
            $msg
            </mtapp:statusmsg>});
    }

    my $id = $args->{id} || $type . '-listing';
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
    if ($show_actions) {
        $actions_top = qq{<\$MTApp:ActionBar bar_position="top" hide_pager="$hide_pager"\$>};
        $actions_bottom = qq{<\$MTApp:ActionBar bar_position="bottom" hide_pager="$hide_pager"\$>};
    } else {
        $listing_class .= " hide_actions";
    }

    my $insides;
    {
        local $args->{name} = $loop;
        defined($insides = _hdlr_loop($ctx, $args, $cond))
            or return;
    }
    my $view = $ctx->var('view_expanded') ? ' expanded' : ' compact';

    my $table = <<TABLE;
        <table id="$id-table" class="$id-table$view" cellspacing="0">
$insides
        </table>
TABLE

    if ($show_actions) {
        return $ctx->build(<<EOT);
<div id="$id" class="listing $listing_class">
    <form id="$id-form" class="listing-form"
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
        $table
        $actions_bottom
    </form>
</div>
EOT
    }
    else {
        return $ctx->build(<<EOT);
<div id="$id" class="listing $listing_class">
        $table
</div>
EOT
    }
}

sub _hdlr_app_link {
    my ($ctx, $arg, $cond) = @_;
    my $app = MT->instance;
    my %args = %$arg;
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

sub _hdlr_app_action_bar {
    my ($ctx, $args, $cond) = @_;
    my $pos = $args->{bar_position} || 'top';
    my $pager = $args->{hide_pager} ? ''
        : qq{\n        <mt:include name="include/pagination.tmpl" bar_position="$pos">};
    my $buttons = $ctx->var('action_buttons') || '';
    return $ctx->build(<<EOT);
<div id="actions-bar-$pos" class="actions-bar actions-bar-$pos">
    <div class="actions-bar-inner pkg">$pager
        <span class="button-actions actions">$buttons</span>
        <span class="plugin-actions actions">
    <mt:include name="include/itemset_action_widget.tmpl">
        </span>
    </div>
</div>
EOT
}

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
        <div class="widget-footer">$widget_footer</div>
    </div>
</div>
EOT
}

sub _hdlr_app_statusmsg {
    my ($ctx, $args, $cond) = @_;
    my $id = $args->{id};
    my $class = $args->{class} || 'info';
    my $msg = $ctx->slurp;
    my $rebuild = $args->{rebuild} || '';
    my $blog_id = $ctx->var('blog_id');
    $rebuild = qq{<__trans phrase="[_1]Publish[_2] your site to see these changes take effect." params="<a href="javascript:void(0);" class="rebuild-link" onclick="doRebuild('$blog_id');">%%</a>">} if $rebuild eq 'all';
    $rebuild = qq{<__trans phrase="[_1]Publish[_2] your site to see these changes take effect." params="<a href="javascript:void(0);" class="rebuild-link" onclick="doRebuild('$blog_id', 'prompt=index');">%%</a>">} if $rebuild eq 'index';
    my $close = '';
    if ($args->{can_close} || (!exists $args->{can_close})) {
        $close = qq{<a href="javascript:void(0)" onclick="javascript:hide('$id');return false;" class="close-me"><span>close</span></a>};
    }
    $id = defined $id ? qq{ id="$id"} : "";
    $class = defined $class ? qq{msg msg-$class} : "msg";
    return <<"EOT";
    <div$id class="$class">$close$msg $rebuild</div>
EOT
}

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
    $insides =~ s/(<textarea)\b/<div class="textarea-wrapper">$1/g;
    $insides =~ s/(<\/textarea>)/$1<\/div>/g;

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

sub _hdlr_for {
    my ($ctx, $args, $cond) = @_;

    my $start = (exists $args->{from} ? $args->{from} : $args->{start}) || 0;
    $start = 0 unless $start =~ /^\d+$/;
    my $end = (exists $args->{to} ? $args->{to} : $args->{end}) || 0;
    return q() unless $end =~ /^\d+$/;
    my $incr = $args->{increment} || $args->{step} || 1;
    $incr = 1 unless $incr =~ /^\d+$/;

    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');
    my $cnt = 1;
    my $out = '';
    my $vars = $ctx->{__stash}{vars} ||= {};
    my $glue = $args->{glue};
    $glue = '' unless defined $glue;
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
        $out .= $glue if $cnt > 1;
        $out .= $res;
        $cnt++;
    }
    return $out;
}

sub _hdlr_else {
    my ($ctx, $args, $cond) = @_;
    local $args->{'@'};
    delete $args->{'@'};
    if  ((keys %$args) == 1) {
        my $name = $args->{name} || $args->{var} || $args->{tag} || undef;
        $name = ($ctx->var('__name__') || undef) unless $name;
        $args->{name} = $name if $name;
    }
    return _hdlr_if(@_) ? $ctx->slurp(@_) : $ctx->else() if %$args;
    return $ctx->slurp(@_);
}

sub _hdlr_elseif {
    my ($ctx, $args, $cond) = @_;
    $args->{name} = $ctx->var('__name__')
        unless ($args->{name} || $args->{var} || $args->{tag} || undef);
    return _hdlr_else($ctx, $args, $cond);
}

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
        my ($handler) = $ctx->handler_for($tag);
        if (defined($handler)) {
            local $ctx->{__stash}{tag} = $args->{tag};
            $value = $handler->($ctx, { %$args });
            if (my $ph = $ctx->post_process_handler) {
                $value = $ph->($ctx, $args, $value);
            }
        }
        else {
            return $ctx->error(MT->translate("Invalid tag [_1] specified.", $tag));
        }
    }

    $ctx->{__stash}{vars}->{__value__} = $value;
    $ctx->{__stash}{vars}->{__name__} = $var;

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
    $glue = '' unless defined $glue;
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
        $out .= $glue if $i > 1;
        $out .= $res;
        $i++;
    }
    return $out;
}

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

    if ($name =~ m/^$/) {
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
                    if ($index =~ /^\d+$/) {
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
        return JSON::objToJson($value);
    }
    return defined $value ? $value : "";
}

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

sub _hdlr_build_template_id {
    my ($ctx, $args, $cond) = @_;
    my $tmpl = $ctx->stash('template');
    if ($tmpl && $tmpl->id) {
        return $tmpl->id;
    }
    return 0;
}

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
    my $glue = $args->{glue} || '';
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

    my $column = lc( $args->{sort_by} || 'name' );
    $args->{sort_order} ||= '';
    my $tags_length = @$tags;
    my @slice_tags;
    if (defined $args->{top} && $args->{top} > 0 && $tags_length > $args->{top}){
        _tag_sort($tags, 'rank');
        @slice_tags = @$tags[ 0 .. $args->{top} - 1 ];
    } else {
        @slice_tags = @$tags;
    }
    $tags_length = scalar @slice_tags;
    if ($column ne 'rank') {
        _tag_sort(\@slice_tags, $column, $args->{sort_order});
    }
    if (defined $args->{limit} && $args->{limit} > 0 && $tags_length > $args->{limit}){
        @slice_tags = @slice_tags[ 0 .. $args->{limit} - 1 ];
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
        $res .= $glue if $res ne '';
        $res .= $out;
    }
    $res;
}

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

    my $ntags = $ctx->stash('all_tag_count');
    unless ($ntags) {
        require MT::ObjectTag;
        $ntags = MT::Entry->count({
            status => MT::Entry::RELEASE(),
            %blog_terms,
        }, {
            'join' => MT::ObjectTag->join_on('object_id',
                { object_datasource => MT::Entry->datasource, %blog_terms },
                \%blog_args ),
            %blog_args,
        });
        $ctx->stash('all_tag_count', $ntags);
    }
    return 1 unless $ntags;

    my $min = $ctx->stash('tag_min_count');
    my $max = $ctx->stash('tag_max_count');
    unless (defined $min && defined $max) {
        (my $tags, $min, $max, my $all_count) = _tags_for_blog($ctx, \%blog_terms, \%blog_args, MT::Entry->datasource);
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
        require MT::Entry;
        $count = MT::Entry->count({
            status => MT::Entry::RELEASE(),
            %blog_terms,
        }, {
            'join' => MT::ObjectTag->join_on('object_id',
                { tag_id => $tag->id, object_datasource => MT::Entry->datasource, %blog_terms },
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

sub _hdlr_entry_tags {
    my ($ctx, $args, $cond) = @_;
    
    require MT::Entry;
    my $entry = $ctx->stash('entry');
    return '' unless $entry;
    my $glue = $args->{glue} || '';

    local $ctx->{__stash}{tag_max_count} = undef;
    local $ctx->{__stash}{tag_min_count} = undef;

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
        $res .= $glue if $res ne '';
        $res .= $out;
    }
    $res;
}

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

sub _hdlr_tag_id {
    my ($ctx, $args, $cond) = @_;
    my $tag = $ctx->stash('Tag');
    return '' unless $tag;
    $tag->id;
}

sub _hdlr_tag_count {
    my ($ctx, $args, $cond) = @_;
    my $count = $ctx->stash('tag_entry_count');
    my $tag = $ctx->stash('Tag');
    my $blog_id = $ctx->stash('blog_id');
    return 0 unless $tag;
    unless (defined $count) {
        $count = MT::Entry->tagged_count($tag->id, { status => MT::Entry::RELEASE(),
                                                     blog_id => $blog_id });
    }
    $count || 0;
}

sub _hdlr_if_typekey_token {
    my $blog = $_[0]->stash('blog');
    if ($blog->remote_auth_token) {
        _hdlr_pass_tokens(@_);
    } else {
        _hdlr_pass_tokens_else(@_);
    }
}

sub _hdlr_comments_moderated {
    my $blog = $_[0]->stash('blog');
    if ($blog->moderate_unreg_comments || $blog->manual_approve_commenters) {
        _hdlr_pass_tokens(@_);
    } else {
        _hdlr_pass_tokens_else(@_);
    }
}

sub _hdlr_reg_allowed {
    my $blog = $_[0]->stash('blog');
    if ($blog->allow_reg_comments && $blog->commenter_authenticators) {
        _hdlr_pass_tokens(@_);
    } else {
        _hdlr_pass_tokens_else(@_);
    }
}

sub _hdlr_reg_required {
    my $blog = $_[0]->stash('blog');
    if ( $blog->allow_reg_comments && $blog->commenter_authenticators
        && ! $blog->allow_unreg_comments ) {
        _hdlr_pass_tokens(@_);
    } else {
        _hdlr_pass_tokens_else(@_);
    }
}

sub _hdlr_reg_not_required {
    my $blog = $_[0]->stash('blog');
    if ($blog->allow_reg_comments && $blog->commenter_authenticators
        && $blog->allow_unreg_comments) {
        _hdlr_pass_tokens(@_);
    } else {
        _hdlr_pass_tokens_else(@_);
    }
}
#FIXME: rethink the above tags.
#  * move all registration conditions into Context.pm?
#  * reg_not_required implies registration is allowed?
#  * moderation includes manual_approve_commenters ??
#  * alias authentication to registration?

sub _hdlr_blog_if_comments_open {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    if ($ctx->{config}->AllowComments &&
        (($blog->allow_reg_comments && $blog->effective_remote_auth_token)
         || $blog->allow_unreg_comments)) {
        _hdlr_pass_tokens(@_);
    } else {
        _hdlr_pass_tokens_else(@_);
    }
}

sub _hdlr_if_archive_type {
    my ($ctx, $args, $cond) = @_;
    my $cat = $ctx->{current_archive_type} || $ctx->{archive_type} || '';
    my $at = $args->{type} || $args->{archive_type} || '';
    return 0 unless $at && $cat;
    return lc $at eq lc $cat;
}

sub _hdlr_archive_type_enabled {
    my $blog = $_[0]->stash('blog');
    my $at = lc ($_[1]->{type} || $_[1]->{archive_type});
    return $blog->has_archive_type($at);
}

sub sanitize_on {
    unless ( exists $_[0]->{'sanitize'} ) {
        # Important to come before other manipulation attributes
        # like encode_xml
        unshift @{$_[0]->{'@'} ||= []}, ['sanitize' => 1];
        $_[0]->{'sanitize'} = 1;
    }
}

sub nofollowfy_on {
    unless ( exists $_[0]->{'nofollowfy'} ) {
        $_[0]->{'nofollowfy'} = 1;
    }
}

{
    my %include_stack;
    my %restricted_include_filenames = (
        'mt-config.cgi' => 1,
        'passwd' => 1
    );

sub _hdlr_include_block {
    my($ctx, @param) = @_;
    my $contents = $ctx->slurp(@param);
    my $args = $param[0];
    my $name = delete $args->{var} || 'contents';
    local $ctx->{__stash}{vars}{$name} = $contents;
    return $ctx->tag('include', @param);
}

sub _hdlr_include {
    my ( $ctx, $arg, $cond ) = @_;

    # If option provided, read from cache
    my $cache_key     = $arg->{key};
    my $ttl           = $arg->{ttl} || 0;
    my $cache_require = 0;
    my $cache;
    if ($cache_key) {
        require MT::Session;
        if ($ttl) {
            $cache = MT::Session::get_unexpired_value(
                $ttl,
                {
                    id   => $cache_key,
                    kind => 'CO',
                }
            );
        }
        else {
            $cache = MT::Session->load(
                {
                    id   => $cache_key,
                    kind => 'CO',
                }
            );
        }
        if ($cache) {
            return $cache->data();
        }
        else {
            $cache_require = 1;
        }
    }

    # Run include process
    my $out = _include_process(@_);

    if ($cache_require) {
        $cache = MT::Session->load(
            {
                id   => $cache_key,
                kind => 'CO',
            }
        );
        $cache->remove() if $cache;
        $cache = MT::Session->new;
        $cache->set_values(
            {
                id    => $cache_key,
                kind  => 'CO',
                start => time,
                data  => $out,
            }
        );
        $cache->save();
    }

    return $out;
}

sub _include_process {
    my($ctx, $arg, $cond) = @_;
    my $req = MT::Request->instance;
    my $blog_id = $arg->{blog_id} || $ctx->{__stash}{blog_id} || 0;

    # Pass through include arguments as variables to included template
    my $vars = $ctx->{__stash}{vars} ||= {};
    my @names = keys %$arg;
    my @var_names;
    push @var_names, lc $_ for @names;
    local @{$vars}{@var_names};
    $vars->{lc($_)} = $arg->{$_} for @names;
    my $cur_tmpl = $ctx->stash('template');

    if (my $tmpl_name = $arg->{module} || $arg->{widget} || $arg->{identifier}) {
        my $name = $arg->{widget} ? 'widget' : $arg->{identifier} ? 'identifier' : 'module';
        my $type = $arg->{widget} ? 'widget' : 'custom';
        if (($type eq 'custom') && ($tmpl_name =~ m/^Widget:/)) {
            # handle old-style widget include references
            $type = 'widget';
            $tmpl_name =~ s/^Widget: ?//;
        }
        my $stash_id = 'template_' . $type . '::' . $blog_id . '::' . $tmpl_name;
        return $ctx->error(MT->translate("Recursion attempt on [_1]: [_2]", MT->translate($name), $tmpl_name))
            if $include_stack{$stash_id};
        local $include_stack{$stash_id} = 1;
        my $builder = $ctx->{__stash}{builder};
        my $tokens = $req->stash($stash_id);
        my $tmpl;
        unless ($tokens) {
            my $blog_id_param;
            if (exists $arg->{global}) {
                if ($arg->{global}) {
                    $blog_id_param = 0;
                }
                else {
                    $blog_id_param = $blog_id;
                }
            }
            else {
                $blog_id_param = [ $blog_id, 0 ];
            }
            require MT::Template;
            my @tmpl = MT::Template->load({ ($arg->{identifier} ? ( identifier => $tmpl_name) : ( name => $tmpl_name,
                                            type => $type )),
                                            blog_id => $blog_id_param }, {
                                            sort      => 'blog_id',
                                            direction => 'descend',
                                        })
                or return $ctx->error(MT->translate(
                    "Can't find included template [_1] '[_2]'", MT->translate($name), $tmpl_name ));
            $tmpl = $tmpl[0];
            return $ctx->error(MT->translate("Recursion attempt on [_1]: [_2]", MT->translate($name), $tmpl_name))
                if $cur_tmpl && $cur_tmpl->id && ($cur_tmpl->id == $tmpl->id);
            $tokens = $builder->compile($ctx, $tmpl->text);
            unless (defined $tokens) {
                $req->cache('build_template', $tmpl);
                return $ctx->error($builder->errstr);
            }
            $req->stash($stash_id, $tokens);
        }
        my $ret = $builder->build($ctx, $tokens, $cond);
        if (defined $ret) {
            return $ret;
        } else {
            $req->cache('build_template', $tmpl) if $tmpl;
            return $ctx->error("error in $name $tmpl_name: " . $builder->errstr);
        }
    } elsif (my $file = $arg->{file}) {
        require File::Basename;
        my $base_filename = File::Basename::basename($file);
        if (exists $restricted_include_filenames{lc $base_filename}) {
            return $ctx->error("You cannot include a file with this name: $base_filename");
        }

        my $stash_id = 'template_file::' . $blog_id . '::' . $file;
        return $ctx->error("Recursion attempt on file: [_1]", $file)
            if $include_stack{$stash_id};
        local $include_stack{$stash_id} = 1;
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
    } elsif (my $app_file = $arg->{name}) {
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
}

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
        '-a' => "<MTAuthorBasename dirify='-'>",
        '_a' => "<MTAuthorBasename dirify='_'>",
        'b' => "<MTEntryBasename $sep>",
        '-b' => "<MTEntryBasename separator='-'>",
        '_b' => "<MTEntryBasename separator='_'>",
        'c' => "<MTSubCategoryPath $sep>",
        '-c' => "<MTSubCategoryPath separator='-'>",
        '_c' => "<MTSubCategoryPath separator='_'>",
        'C' => "<MTArchiveCategory $dir default=''>",
        '-C' => "<MTArchiveCategory dirify='-' default=''>",
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

sub _hdlr_template_created_on {
    my($ctx, $args, $cond) = @_;
    my $template = $ctx->stash('template')
        or return $ctx->error(MT->translate("Can't load template"));
    $args->{ts} = $template->created_on;
    _hdlr_date($_[0], $args);
}

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

sub _hdlr_mt_version {
    require MT;
    MT->version_id;
}

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

sub _hdlr_publish_charset {
    my ($ctx) = @_;
    return $ctx->{config}->PublishCharset || 'utf-8';
}

sub _hdlr_default_language {
    my ($ctx) = @_;
    return $ctx->{config}->DefaultLanguage || 'en_US';
}

sub _hdlr_signon_url {
    my ($ctx) = @_;
    return $ctx->{config}->SignOnURL;
}

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
        _hdlr_pass_tokens($ctx, $args, $cond);
    } else {
        _hdlr_pass_tokens_else($ctx, undef, $cond);
    }
}

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
        _hdlr_pass_tokens($ctx, $args, $cond);
    } else {
        _hdlr_pass_tokens_else($ctx, undef, $cond);
    }
}

sub _hdlr_error_message {
    my $err = $_[0]->stash('error_message');
    defined $err ? $err : '';
}

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

sub _hdlr_set_hashvar {
    my($ctx, $args) = @_;
    my $tag = lc $ctx->stash('tag');
    my $name = $args->{name} || $args->{var};
    if ($name =~ m/^$/) {
        $name = $ctx->var($name);
    }
    return $ctx->error(MT->translate(
        "You used a [_1] tag without a valid name attribute.", "<MT$tag>" ))
        unless defined $name;

    my $hash = $ctx->var($name) || {};
    return $ctx->error(MT->translate( "[_1] is not a hash.", $name ))
        unless 'HASH' eq ref($hash);

    local $ctx->{__inside_set_hashvar} = $hash;
    _hdlr_pass_tokens(@_);
    $ctx->var($name, $hash);
    return q();
}

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

    if ($name =~ m/^$/) {
        $name = $ctx->var($name);
        return $ctx->error(MT->translate(
            "You used a [_1] tag without a valid name attribute.", "<MT$tag>" ))
            unless defined $name;
    }

    my $val;
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
        $existing = ( defined $index && ( $index =~ /^\d+$/ ) )
          ? $existing->[ $index ] 
          : undef;
    }

    if ($args->{prepend}) {
        $val = $val . $existing;
    }
    elsif ($args->{append}) {
        $val = $existing . $val;
    }
    elsif ( defined($existing) && ( my $op = $args->{op} ) ) {
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
            unless $index =~ /^\d+$/;
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

sub _hdlr_config_file {
    return MT->instance->{cfg_file};
}

sub _hdlr_cgi_server_path {
    my $path = MT->instance->server_path() || "";
    $path =~ s!/*$!!;
    return $path;
}

sub _hdlr_cgi_relative_url {
    my ($ctx) = @_;
    my $url = $ctx->{config}->CGIPath;
    $url .= '/' unless $url =~ m!/$!;
    if ($url =~ m!^https?://[^/]+(/.*)$!) {
        return $1;
    }
    return $url;
}

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

sub _hdlr_admin_script {
    my ($ctx) = @_;
    return $ctx->{config}->AdminScript;
}

sub _hdlr_comment_script {
    my ($ctx) = @_;
    return $ctx->{config}->CommentScript;
}

sub _hdlr_trackback_script {
    my ($ctx) = @_;
    return $ctx->{config}->TrackbackScript;
}

sub _hdlr_search_script {
    my ($ctx) = @_;
    return $ctx->{config}->SearchScript;
}

sub _hdlr_xmlrpc_script {
    my ($ctx) = @_;
    return $ctx->{config}->XMLRPCScript;
}

sub _hdlr_atom_script {
    my ($ctx) = @_;
    return $ctx->{config}->AtomScript;
}

sub _hdlr_notify_script {
    my ($ctx) = @_;
    return $ctx->{config}->NotifyScript;
}

sub _no_author_error {
    return $_[0]->error(MT->translate(
        "You used an '[_1]' tag outside of the context of a author; " .
        "perhaps you mistakenly placed it outside of an 'MTAuthors' " .
        "container?", $_[1] ));
}

sub _hdlr_if_author {
    return $_[0]->stash('author') ? 1 : 0;
}

sub _hdlr_author_has_entry {
    my ($ctx)   = @_;
    my $author  = $ctx->stash('author')
      or return $ctx->_no_author_error( $ctx->stash('tag') );

    my %terms;
    $terms{blog_id}   = $ctx->stash('blog_id');
    $terms{author_id} = $author->id;
    $terms{class}     = 'entry';
    $terms{status}    = MT::Entry::RELEASE();

    my $class = MT->model('entry');
    $class->count( \%terms );
}

sub _hdlr_author_has_page {
    my ($ctx)   = @_;
    my $author  = $ctx->stash('author')
      or return $ctx->_no_author_error( $ctx->stash('tag') );

    my %terms;
    $terms{blog_id}   = $ctx->stash('blog_id');
    $terms{author_id} = $author->id;
    $terms{class}     = 'page';
    $terms{status}    = MT::Entry::RELEASE();

    my $class = MT->model('page');
    $class->count( \%terms );
}

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
        $args{'join'} = MT::Entry->join_on('author_id', \%blog_terms, \%blog_args);
    } else {
        $terms{'type'} = 1;
        require MT::Association;
        $args{'join'} = MT::Association->join_on('author_id', { blog_id => $blog_id }, { unique => 1 });
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
        }
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
            $iter->('finish');
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
                $scores->('finish'), last unless %a;
                $i++;
                $scores->('finish'), last if $score_limit && $i >= $score_limit;
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
                $scores->('finish'), last unless %a;
                $i++;
                $scores->('finish'), last if $score_limit && $i >= $score_limit;
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
        local $vars->{__last__} = !$next || ($n && ($count == $n));
        local $vars->{__odd__} = ($count % 2) == 1;
        local $vars->{__even__} = ($count % 2) == 0;
        local $vars->{__counter__} = $count;
        defined(my $out = $builder->build($ctx, $tokens, $cond))
            or return $ctx->error( $builder->errstr );
        $res .= $out;
    }
    $res;
}

sub _hdlr_author_id {
    my $author = $_[0]->stash('author')
        or return $_[0]->_no_author_error('MTAuthorID');
    $author->id;
}

sub _hdlr_author_name {
    my $author = $_[0]->stash('author')
        or return $_[0]->_no_author_error('MTAuthorName');
    $author->name;
}

sub _hdlr_author_display_name { 
    my $a = $_[0]->stash('author'); 
    unless ($a) { 
        my $e = $_[0]->stash('entry'); 
        $a = $e->author if $e; 
    } 
    return $_[0]->_no_author_error('MTAuthorDisplayName') unless $a;
    $a->nickname || MT->translate('(Display Name not set)', $a->id);
} 

sub _hdlr_author_email {
    my $author = $_[0]->stash('author')
        or return $_[0]->_no_author_error('MTAuthorEmail');
    my $email = $author->email;
    defined $email ? $email : '';
}

sub _hdlr_author_url {
    my $author = $_[0]->stash('author')
        or return $_[0]->_no_author_error('MTAuthorURL');
    my $url = $author->url;
    defined $url ? $url : '';
}

sub _hdlr_author_auth_type {
    my $author = $_[0]->stash('author')
        or return $_[0]->_no_author_error('MTAuthorAuthType');
    my $auth_type = $author->auth_type;
    defined $auth_type ? $auth_type : '';
}

sub _hdlr_author_auth_icon_url {
    my $author = $_[0]->stash('author')
        or return $_[0]->_no_author_error('MTAuthorAuthType');
    my $size = $_[1]->{size} || 'logo_small';
    return $author->auth_icon_url($size);
}

sub _hdlr_author_userpic {
    my $author = $_[0]->stash('author')
        or return $_[0]->_no_author_error('MTAuthorUserpic');
    $author->userpic_html() || '';
}

sub _hdlr_author_userpic_url {
    my $author = $_[0]->stash('author')
        or return $_[0]->_no_author_error('MTAuthorUserpicURL');
    $author->userpic_url() || '';
}

sub _hdlr_author_userpic_asset {
    my ($ctx, $args, $cond) = @_;

    my $author = $ctx->stash('author')
        or return $ctx->_no_author_error('MTAuthorUserpicAsset');
    my $asset = $author->userpic or return '';

    my $tok = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');

    local $ctx->{__stash}{asset} = $asset;
    $builder->build($ctx, $tok, { %$cond });
}

sub _hdlr_author_basename {
    my $author = $_[0]->stash('author')
        or return $_[0]->_no_author_error('MTAuthorBasename');
    my $name = $author->basename;
    $name = MT::Util::make_unique_author_basename($author) if !$name;
    return $name;
}

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

sub _hdlr_blog_id {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    $blog ? $blog->id : 0;
}

sub _hdlr_blog_name {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    my $name = $blog->name;
    defined $name ? $name : '';
}

sub _hdlr_blog_description {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    my $d = $blog->description;
    defined $d ? $d : '';
}

sub _hdlr_blog_url {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    my $url = $blog->site_url;
    return '' unless defined $url;
    $url .= '/' unless $url =~ m!/$!;
    $url;
}

sub _hdlr_blog_site_path {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    my $path = $blog->site_path;
    return '' unless defined $path;
    $path .= '/' unless $path =~ m!/$!;
    $path;
}

sub _hdlr_blog_archive_url {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    my $url = $blog->archive_url;
    return '' unless defined $url;
    $url .= '/' unless $url =~ m!/$!;
    $url;
}

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

sub _hdlr_blog_timezone {
    my $blog = $_[0]->stash('blog');
    return '' unless $blog;
    my $so = $blog->server_offset;
    my $no_colon = $_[1]->{no_colon};
    my $partial_hour_offset = 60 * abs($so - int($so));
    sprintf("%s%02d%s%02d", $so < 0 ? '-' : '+',
            abs($so), $no_colon ? '' : ':',
            $partial_hour_offset);
}

{
    my %real_lang = (cz => 'cs', dk => 'da', jp => 'ja', si => 'sl');
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

sub _hdlr_blog_host {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    my $host = $blog->site_url;
    if ($host =~ m!^https?://([^/:]+)(:\d+)?/!) {
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

sub _hdlr_cgi_host {
    my ($ctx, $args, $cond) = @_;
    my $path = _hdlr_cgi_path(@_);
    if ($path =~ m!^https?://([^/:]+)(:\d+)?/!) {
        return $args->{exclude_port} ? $1 : $1 . ($2 || '');
    } else {
        return '';
    }
}

sub _hdlr_blog_category_count {
    my ($ctx, $args, $cond) = @_;
    my (%terms, %args);
    $ctx->set_blog_load_context($args, \%terms, \%args)
        or return $ctx->error($ctx->errstr);
    MT::Category->count(\%terms, \%args);
}
                
sub _hdlr_blog_entry_count {
    my ($ctx, $args, $cond) = @_;
    my $class_type = $args->{class_type} || 'entry';
    my $class = MT->model($class_type);
    my (%terms, %args);
    $ctx->set_blog_load_context($args, \%terms, \%args)
        or return $ctx->error($ctx->errstr);
    $terms{status} = MT::Entry::RELEASE();
    $class->count(\%terms, \%args);
}

sub _hdlr_blog_comment_count {
    my ($ctx, $args, $cond) = @_;
    my (%terms, %args);
    $ctx->set_blog_load_context($args, \%terms, \%args)
        or return $ctx->error($ctx->errstr);
    $terms{visible} = 1;
    require MT::Comment;
    MT::Comment->count(\%terms, \%args);
}

sub _hdlr_blog_ping_count {
    my ($ctx, $args, $cond) = @_;
    my (%terms, %args);
    $ctx->set_blog_load_context($args, \%terms, \%args)
        or return $ctx->error($ctx->errstr);
    $terms{visible} = 1;
    require MT::Trackback;
    require MT::TBPing;
    MT::Trackback->count(undef,
        { 'join' => MT::TBPing->join_on('tb_id', \%terms, \%args) });
}

sub _hdlr_blog_cc_license_url {
    my $blog = $_[0]->stash('blog');
    return '' unless $blog;
    return $blog->cc_license_url;
}

sub _hdlr_blog_cc_license_image {
    my $blog = $_[0]->stash('blog');
    return '' unless $blog;
    my $cc = $blog->cc_license or return '';
    my ($code, $license, $image_url) = $cc =~ /(\S+) (\S+) (\S+)/;
    return $image_url if $image_url;
    "http://creativecommons.org/images/public/" .
        ($cc eq 'pd' ? 'norights' : 'somerights');
}
sub _hdlr_cc_license_rdf {
    my($ctx, $arg) = @_;
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
        $link = MT::Util::strip_index($entry->permalink, $blog) unless $arg->{with_index};
        $rdf .= <<RDF;
<Work rdf:about="$link">
<dc:title>@{[ encode_xml($strip_hyphen->($entry->title)) ]}</dc:title>
<dc:description>@{[ encode_xml($strip_hyphen->(_hdlr_entry_excerpt(@_))) ]}</dc:description>
<dc:creator>@{[ encode_xml($strip_hyphen->($entry->author ? $entry->author->name : '')) ]}</dc:creator>
<dc:date>@{[ _hdlr_entry_date($_[0], { 'format' => "%Y-%m-%dT%H:%M:%S" }) .
             _hdlr_blog_timezone($_[0]) ]}</dc:date>
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
sub _hdlr_blog_if_cc_license {
    my $blog = $_[0]->stash('blog');
    return 0 unless $blog;
    $blog->cc_license ? 1 : 0;
}

sub _hdlr_blog_file_extension {
    my($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    my $ext = $blog->file_extension || '';
    $ext = '.' . $ext if $ext ne '';
    $ext;
}

sub _hdlr_blog_template_set_id {
    my ($ctx) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    my $set = $blog->template_set || 'classic_blog';
    $set =~ s/_/-/g;
    return $set;
}

sub _hdlr_entries {
    my($ctx, $args, $cond) = @_;
    return $ctx->error(MT->translate('sort_by="score" must be used in combination with namespace.'))
        if ((exists $args->{sort_by}) && ('score' eq $args->{sort_by}) && (!exists $args->{namespace}));
    
    my $cfg = $ctx->{config};
    my $at = $ctx->{current_archive_type} || $ctx->{archive_type};
    my $entries = $ctx->stash('entries');
    if ($at && !$entries) {
        my $archiver = MT->publisher->archiver($at);
        if ( $archiver && $archiver->group_based ) {
            $entries = $archiver->archive_group_entries( $ctx, %$args );
            # $ctx->stash( 'entries', $entries );
        }
    }
    my $blog_id = $ctx->stash('blog_id');
    my $blog = $ctx->stash('blog');
    my (@filters, %blog_terms, %blog_args, %terms, %args);

    $ctx->set_blog_load_context($args, \%blog_terms, \%blog_args)
        or return $ctx->error($ctx->errstr);
    %terms = %blog_terms;
    %args = %blog_args;

    my $class_type = $args->{class_type} || 'entry';
    my $class = MT->model($class_type);
    my $cat_class = MT->model(
        $class_type eq 'entry' ? 'category' : 'folder');

    if ($entries && @$entries) {
        my $entry = @$entries[0];
        $entries = undef if $entry->class ne $class_type;

        foreach my $args_key ('category', 'categories', 'tag', 'tags', 'author', 'id', 'days', 'recently_commented_on', 'include_subcategories', 'include_blogs', 'exclude_blogs', 'blog_ids') {
            if (exists($args->{$args_key})) {
                $entries = undef;
                last;
            }
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

    if (!$entries && $class_type eq 'entry') {
        if ($ctx->{inside_mt_categories}) {
            if (my $cat = $ctx->stash('category')) {
                $args->{category} ||= [ 'OR', [ $cat ] ];
            }
        } elsif (my $cat = $ctx->stash('archive_category')) {
            $args->{category} ||= [ 'OR', [ $cat ] ];
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
                    $class_type eq 'entry' ?
                        ($args->{include_subcategories} ? 1 : 0) :
                        ($args->{include_subfolders} ? 1 : 0)
            });
        } else {
            if (($category_arg !~ m/\b(AND|OR|NOT)\b|[(|&]/i) &&
                (($class_type eq 'entry' && !$args->{include_subcategories}) ||
                 ($class_type ne 'entry' && !$args->{include_subfolders})))
            {
                if ($blog_terms{blog_id}) {
                    $cats = [ $cat_class->load(\%blog_terms, \%blog_args) ];
                } else {
                    my @cats = cat_path_to_category($category_arg, [ \%blog_terms, \%blog_args ], $class_type);
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
                        { children => $class_type eq 'entry' ?
                            ($args->{include_subcategories} ? 1 : 0) :
                            ($args->{include_subfolders} ? 1 : 0)
                        });
                }
            }
            $cexpr ||= $ctx->compile_category_filter($category_arg, $cats,
                { children => $class_type eq 'entry' ?
                    ($args->{include_subcategories} ? 1 : 0) :
                    ($args->{include_subfolders} ? 1 : 0) 
                });
        }
        if ($cexpr) {
            my %map;
            require MT::Placement;
            for my $cat (@$cats) {
                my $iter = MT::Placement->load_iter({ category_id => $cat->id });
                while (my $p = $iter->()) {
                    $map{$p->entry_id}{$cat->id}++;
                }
            }
            push @filters, sub { $cexpr->($_[0]->id, \%map) };
        } else {
            return $ctx->error(MT->translate("You have an error in your '[_2]' attribute: [_1]", $args->{category} || $args->{categories}, $class_type eq 'entry' ? 'category' : 'folder'));
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
            %args,
            binary => { name => 1 },
            join => MT::ObjectTag->join_on('tag_id', {
                object_datasource => $class->datasource,
                %blog_terms
            }, \%blog_args)
        }) ];
        my $cexpr = $ctx->compile_tag_filter($tag_arg, $tags);
        if ($cexpr) {
            my %map;
            for my $tag (@$tags) {
                my $iter = MT::ObjectTag->load_iter({ 
                    tag_id => $tag->id,
                    object_datasource => $class->datasource,
                    %blog_terms,
                }, { %args, %blog_args });
                while (my $et = $iter->()) {
                    $map{$et->object_id}{$tag->id}++;
                }
            }
            push @filters, sub { $cexpr->($_[0]->id, \%map) };
        } else {
            return $ctx->error(MT->translate("You have an error in your 'tag' attribute: [_1]", $args->{tags} || $args->{tag}));
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
                'days',       'recently_commented_on',
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
            if ($class->has_column($args->{sort_by})) {
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
            @entries = $class->load(\%terms, \%args);
        } else {
            if (($args->{lastn}) && (!exists $args->{limit})) {
                $args{direction} = 'descend';
                $args{sort} = 'authored_on';
                $no_resort = 0 if $args->{sort_by};
            } else {
                $args{direction} = $args->{sort_order} || 'descend';
                $no_resort = 1 unless $args->{sort_by};
            }
            my $iter = $class->load_iter(\%terms, \%args);
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
                $iter->('finish'), last if $n && $i >= $n;
            }
        }
        if ($args->{recently_commented_on}) {
            my @e = sort {$b->comment_latest->created_on <=>
                          $a->comment_latest->created_on}
                    grep {$_->comment_latest} @entries;
            @entries = splice(@e, 0, $args->{recently_commented_on});
            $no_resort = 1;
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
                $scores->('finish'), last unless %e;
                $i++;
                $scores->('finish'), last if $score_limit && (scalar @tmp) >= $score_limit;
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
                $scores->('finish'), last unless %e;
                $i++;
                $scores->('finish'), last if $score_limit && (scalar @tmp) >= $score_limit;
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
            }
        }
    }
    my($last_day, $next_day) = ('00000000') x 2;
    my $i = 0;
    local $ctx->{__stash}{entries} = \@entries;
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
            EntriesHeader => $class_type eq 'entry' ?
                (!$i) : (),
            EntriesFooter => $class_type eq 'entry' ?
                (!defined $entries[$i+1]) : (),
            PagesHeader => $class_type ne 'entry' ?
                (!$i) : (),
            PagesFooter => $class_type ne 'entry' ?
                (!defined $entries[$i+1]) : (),
        });
        return $ctx->error( $builder->errstr ) unless defined $out;
        $last_day = $this_day;
        $res .= $glue if defined $glue && $i;
        $res .= $out;
        $i++;
    }
    if (!@entries) {
        return _hdlr_pass_tokens_else(@_);
    }

    $res;
}

sub _hdlr_entries_count {   
    my ($ctx, $args, $cond) = @_;   
    my $e = $ctx->stash('entries');   

    unless ($e) {
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
        return $i;
    }

    return 0 unless $e;
    scalar @$e;
}  

sub _no_entry_error {
    my $tag = $_[1];
    $tag = 'MT' . $tag unless $tag =~ m/^MT/i;
    return $_[0]->error(MT->translate(
        "You used an '[_1]' tag outside of the context of an entry; " .
        "perhaps you mistakenly placed it outside of an 'MTEntries' container?",
        $tag));
}

sub _hdlr_entry_body {
    my $arg = $_[1];
    my $e = $_[0]->stash('entry')
        or return $_[0]->_no_entry_error($_[0]->stash('tag'));
    my $text = $e->text;
    $text = '' unless defined $text;

    # Strip the mt:asset-id attribute from any span tags...
    if ($text =~ m/\smt:asset-id="\d+"/) {
        $text = asset_cleanup($text);
    }

    my $blog = $_[0]->stash('blog');
    my $convert_breaks = exists $arg->{convert_breaks} ?
        $arg->{convert_breaks} :
            defined $e->convert_breaks ? $e->convert_breaks :
                ( $blog ? $blog->convert_paras : '__default__' );
    if ($convert_breaks) {
        my $filters = $e->text_filters;
        push @$filters, '__default__' unless @$filters;
        $text = MT->apply_text_filters($text, $filters, $_[0]);
    }
    return first_n_text($text, $arg->{words}) if exists $arg->{words};

    return $text;
}

sub _hdlr_entry_more {
    my $arg = $_[1];
    my $e = $_[0]->stash('entry')
        or return $_[0]->_no_entry_error($_[0]->stash('tag'));
    my $text = $e->text_more;
    $text = '' unless defined $text;

    # Strip the mt:asset-id attribute from any span tags...
    if ($text =~ m/\smt:asset-id="\d+"/) {
        $text = asset_cleanup($text);
    }

    my $blog = $_[0]->stash('blog');
    my $convert_breaks = exists $arg->{convert_breaks} ?
        $arg->{convert_breaks} :
            defined $e->convert_breaks ? $e->convert_breaks :
                ($blog ? $blog->convert_paras : '__default__');
    if ($convert_breaks) {
        my $filters = $e->text_filters;
        push @$filters, '__default__' unless @$filters;
        $text = MT->apply_text_filters($text, $filters, $_[0]);
    }
    return first_n_text($text, $arg->{words}) if exists $arg->{words};

    return $text;
}

sub _hdlr_entry_title {
    my $e = $_[0]->stash('entry')
        or return $_[0]->_no_entry_error($_[0]->stash('tag'));
    my $title = defined $e->title ? $e->title : '';
    $title = first_n_text($e->text, const('LENGTH_ENTRY_TITLE_FROM_TEXT'))
        if !$title && $_[1]->{generate};
    $title;
}

sub _hdlr_entry_status {
    my $e = $_[0]->stash('entry')
        or return $_[0]->_no_entry_error($_[0]->stash('tag'));
    MT::Entry::status_text($e->status);
}

sub _hdlr_entry_date {
    my $e = $_[0]->stash('entry')
        or return $_[0]->_no_entry_error($_[0]->stash('tag'));
    my $args = $_[1];
    $args->{ts} = $e->authored_on;
    _hdlr_date($_[0], $args);
}

sub _hdlr_entry_create_date {
    my $e = $_[0]->stash('entry')
        or return $_[0]->_no_entry_error($_[0]->stash('tag'));
    my $args = $_[1];
    $args->{ts} = $e->created_on;
    _hdlr_date($_[0], $args);
}

sub _hdlr_entry_mod_date {
    my $e = $_[0]->stash('entry')
        or return $_[0]->_no_entry_error($_[0]->stash('tag'));
    my $args = $_[1];
    $args->{ts} = $e->modified_on || $e->created_on;
    _hdlr_date($_[0], $args);
}

sub _hdlr_entry_flag {
    my $e = $_[0]->stash('entry')
        or return $_[0]->_no_entry_error($_[0]->stash('tag'));
    my $flag = lc $_[1]->{flag}
        or return $_[0]->error(MT->translate(
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

sub _hdlr_entry_excerpt {
    my($ctx, $args) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error($ctx->stash('tag'));
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
    $excerpt . '...';
}

sub _hdlr_entry_keywords {
    my $e = $_[0]->stash('entry')
        or return $_[0]->_no_entry_error($_[0]->stash('tag'));
    defined $e->keywords ? $e->keywords : '';
}

# FIXME: This should be a container tag providing an author
# context for the entry in context.
sub _hdlr_entry_author {
    my $e = $_[0]->stash('entry')
        or return $_[0]->_no_entry_error($_[0]->stash('tag'));
    my $a = $e->author;
    $a ? $a->name || '' : '';
}

sub _hdlr_entry_author_display_name {
    my $e = $_[0]->stash('entry')
        or return $_[0]->_no_entry_error($_[0]->stash('tag'));
    my $a = $e->author;
    $a ? $a->nickname || '' : '';
}

sub _hdlr_entry_author_nick {
    my $e = $_[0]->stash('entry')
        or return $_[0]->_no_entry_error($_[0]->stash('tag'));
    my $a = $e->author;
    $a ? $a->nickname || '' : '';
}

sub _hdlr_entry_author_username {
    my $e = $_[0]->stash('entry')
        or return $_[0]->_no_entry_error($_[0]->stash('tag'));
    my $a = $e->author;
    $a ? $a->name || '' : '';
}

sub _hdlr_entry_author_email {
    my $e = $_[0]->stash('entry')
        or return $_[0]->_no_entry_error($_[0]->stash('tag'));
    my $a = $e->author;
    return '' unless $a && defined $a->email;
    $_[1] && $_[1]->{'spam_protect'} ? spam_protect($a->email) : $a->email;
}

sub _hdlr_entry_author_url {
    my($ctx, $args) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error($ctx->stash('tag'));
    my $a = $e->author;
    $a ? $a->url || "" : "";
}

sub _hdlr_entry_author_link {
    my($ctx, $args, $cond) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error($ctx->stash('tag'));
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

sub _hdlr_entry_author_id {
    my $e = $_[0]->stash('entry')
        or return $_[0]->_no_entry_error($_[0]->stash('tag'));
    my $a = $e->author;
    $a ? $a->id || '' : '';
}

sub _hdlr_entry_author_userpic {
    my $e = $_[0]->stash('entry')
        or return $_[0]->_no_entry_error($_[0]->stash('tag'));
    my $a = $e->author or return '';
    $a->userpic_html() || '';
}

sub _hdlr_entry_author_userpic_url {
    my $e = $_[0]->stash('entry')
        or return $_[0]->_no_entry_error($_[0]->stash('tag'));
    my $a = $e->author or return '';
    $a->userpic_url() || '';
}

sub _hdlr_entry_author_userpic_asset {
    my ($ctx, $args, $cond) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error($ctx->stash('tag'));
    my $author = $e->author;
    return '' unless $author;

    my $asset = $author->userpic or return '';

    my $tok = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');

    local $ctx->{__stash}{asset} = $asset;
    $builder->build($ctx, $tok, { %$cond });
}

sub _hdlr_entry_id {
    my $args = $_[1];
    my $e = $_[0]->stash('entry')
        or return $_[0]->_no_entry_error($_[0]->stash('tag'));
    $args && $args->{pad} ? (sprintf "%06d", $e->id) : $e->id;
}

sub _hdlr_entry_tb_link {
    my ($ctx, $args, $cond) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error($ctx->stash('tag'));
    my $tb = $e->trackback
        or return '';
    my $cfg = $ctx->{config};
    my $path = _hdlr_cgi_path($ctx);
    $path . $cfg->TrackbackScript . '/' . $tb->id;
}

sub _hdlr_entry_tb_data {
    my($ctx, $args) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error($ctx->stash('tag'));
    return '' unless $e->allow_pings;
    my $blog = $ctx->stash('blog');
    my $cfg = $ctx->{config};
    return '' unless $blog->allow_pings && $cfg->AllowPings;
    my $tb = $e->trackback or return '';
    return '' if $tb->is_disabled;
    my $path = _hdlr_cgi_path($ctx);
    $path .= $cfg->TrackbackScript . '/' . $tb->id;
    my $url;
    if (my $at = $_[0]->{current_archive_type} || $_[0]->{archive_type}) {
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
    dc:date="@{[ _hdlr_date($_[0], { 'ts' => $e->authored_on, 'format' => "%Y-%m-%dT%H:%M:%S" }) .
                 _hdlr_blog_timezone($_[0]) ]}" />
</rdf:RDF>
RDF
    $rdf .= "-->\n" if $comment_wrap;
    $rdf;
}

sub _hdlr_entry_tb_id {
    my($ctx, $args) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error($ctx->stash('tag'));
    my $tb = $e->trackback
        or return '';
    $tb->id;
}

sub _hdlr_entry_link {
    my ($ctx, $args) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error($ctx->stash('tag'));
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

sub _hdlr_entry_basename {
    my $args = $_[1];
    my $e = $_[0]->stash('entry')
        or return $_[0]->_no_entry_error($_[0]->stash('tag'));
    my $basename = $e->basename() || '';
    if (my $sep = $args->{separator}) {
        if ($sep eq '-') {
            $basename =~ s/_/-/g;
        } elsif ($sep eq '_') {
            $basename =~ s/-/_/g;
        }
    }
    $basename;
}

sub _hdlr_entry_atom_id {
    my ($ctx, $args, $cond) = @_;
    my $e = $_[0]->stash('entry')
        or return $ctx->_no_entry_error($ctx->stash('tag'));
    return $e->atom_id() || $e->make_atom_id() || $ctx->error(MT->translate("Could not create atom id for entry [_1]", $e->id));
}

sub _hdlr_entry_permalink {
    my ($ctx, $args) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error($ctx->stash('tag'));
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

sub _hdlr_entry_class {
    my ($ctx, $args) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error($ctx->stash('tag'));
    $e->class;
}

sub _hdlr_entry_class_label {
    my ($ctx, $args) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error($ctx->stash('tag'));
    $e->class_label;
}

sub _hdlr_entry_category {
    my($ctx, $args, $cond) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error($ctx->stash('tag'));
    my $cat = $e->category;
    return '' unless $cat;
    local $ctx->{__stash}{category} = $e->category;
    &_hdlr_category_label;
}

sub _hdlr_entry_categories {
    my($ctx, $args, $cond) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error($ctx->stash('tag'));
    my $cats = $e->categories;
    return '' unless $cats && @$cats;
    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');
    my @res;
    for my $cat (@$cats) {
        local $ctx->{__stash}->{category} = $cat;
        defined(my $out = $builder->build($ctx, $tokens, $cond))
            or return $ctx->error( $builder->errstr );
        push @res, $out;
    }
    my $sep = $args->{glue} || '';
    join $sep, @res;
}

sub _hdlr_typekey_token {
    my ($ctx, $args, $cond) = @_;

    my $blog_id = $ctx->stash('blog_id');
    my $blog = MT::Blog->load($blog_id);
    my $tp_token = $blog->effective_remote_auth_token();
    return $tp_token;
}

sub _hdlr_remote_sign_in_link {
    my ($ctx, $args) = @_;
    my $cfg = $ctx->{config};
    my $blog = $ctx->stash('blog_id');
    $blog = MT::Blog->load($blog)
        if defined $blog && !(ref $blog);
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
    my $e = $_[0]->stash('entry');
    "$path$comment_script?__mode=handle_sign_in$static_arg&amp;logout=1" .
        ($e ? "&amp;entry_id=" . $e->id : '');
}

sub _hdlr_comment_fields {
    my ($ctx, $args, $cond) = @_;
    return $ctx->error(MT->translate("The MTCommentFields tag is no longer available; please include the [_1] template module instead.", MT->translate("Comment Form")));
}

sub _hdlr_entry_comments {
    my $e = $_[0]->stash('entry')
        or return $_[0]->_no_entry_error($_[0]->stash('tag'));
    $e->comment_count;
}
sub _hdlr_entry_ping_count {
    my $e = $_[0]->stash('entry')
        or return $_[0]->_no_entry_error($_[0]->stash('tag'));
    $e->ping_count;
}
sub _hdlr_entry_previous {
    _hdlr_entry_nextprev('previous', @_);
}

sub _hdlr_entry_next {
    _hdlr_entry_nextprev('next', @_);
}

sub _hdlr_entry_nextprev {
    my($meth, $ctx, $args, $cond) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error($ctx->stash('tag'));
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

sub _hdlr_sys_date {
    my $args = $_[1];
    unless ($args->{ts}) {
        my $t = time;
        my @ts = offset_time_list($t, $_[0]->stash('blog_id'));
        $args->{ts} = sprintf "%04d%02d%02d%02d%02d%02d",
            $ts[5]+1900, $ts[4]+1, @ts[3,2,1,0];
    }
    _hdlr_date($_[0], $args);
}

sub _hdlr_date {
    my $args = $_[1];
    my $ts = $args->{ts} || $_[0]->{current_timestamp};
    my $tag = $_[0]->stash('tag');
    return $_[0]->error(MT->translate(
        "You used an [_1] tag without a date context set up.", "MT$tag" ))
        unless defined $ts;
    my $blog = $_[0]->stash('blog');
    unless (ref $blog) {
        my $blog_id = $blog || $args->{offset_blog_id};
        $blog = MT->model('blog')->load($blog_id)
          if $blog_id;
    }
    my $lang = $args->{language} || $_[0]->var('local_lang_id')
        || ($blog && $blog->language);
    if ($args->{utc}) {
        my($y, $mo, $d, $h, $m, $s) = $ts =~ /(\d\d\d\d)[^\d]?(\d\d)[^\d]?(\d\d)[^\d]?(\d\d)[^\d]?(\d\d)[^\d]?(\d\d)/;
        $mo--;
        my $server_offset = $blog->server_offset;
        if ((localtime (timelocal ($s, $m, $h, $d, $mo, ($y - 1900 >= 0 ? $y - 1900 : 0 ))))[8]) {
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
            my $so = $blog->server_offset;
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

sub _no_comment_error {
    return $_[0]->error(MT->translate(
        "You used an '[_1]' tag outside of the context of a comment; " .
        "perhaps you mistakenly placed it outside of an 'MTComments' " .
        "container?", $_[1] ));
}
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
    if ($comments) {
        my $n = $args->{lastn};
        if (@filters) {
            COMMENTS: for my $c (@$comments) {
                for (@filters) {
                    next COMMENTS unless $_->($c);
                }
                push @comments, $c;
            }
        }
        else {
            @comments = @$comments;
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
            my $comments = $e->comments(\%terms, \%args);
            my $i = 0;
            if (@filters) {
                COMMENTS: for my $c (@$comments) {
                    for (@filters) {
                        next COMMENTS unless $_->($c);
                    }
                    push @comments, $c;
                    last if $n && ( $n <= ++$i );
                }
            } elsif ($n) {
                my $max = $n - 1 > $#$comments ? $#$comments : $n - 1;
                @comments = @$comments[0..$max];
            } else {
                @comments = @$comments;
            }
        } else {
            $args{'sort'} = 'created_on';
            $args{'direction'} = 'descend';
            require MT::Comment;
            my $iter = MT::Comment->load_iter(\%terms, \%args);
            my %entries;
            COMMENT: while (my $c = $iter->()) {
                my $e = $entries{$c->entry_id} ||= $c->entry;
                next unless $e;
                next if $e->status != MT::Entry::RELEASE();
                for (@filters) {
                    next COMMENT unless $_->($c);
                }
                push @comments, $c;
                if ($n && (scalar @comments == $n)) {
                    $iter->('finish');
                    last;
                }
            }
        }
    }

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
                $scores->('finish'), last unless %m;
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
                $scores->('finish'), last unless %m;
            }
            @comments = @tmp;
        }
    }

    my $html = '';
    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');
    my $i = 1;

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
              CommentsFooter => ($i == scalar @comments), %$cond } );
        return $ctx->error( $builder->errstr ) unless defined $out;
        $html .= $out;
        $i++;
    }
    if (!@comments) {
        return _hdlr_pass_tokens_else(@_);
    }
    $html;
}
sub _hdlr_comment_date {
    my $c = $_[0]->stash('comment')
        or return $_[0]->_no_comment_error('MTCommentDate');
    my $args = $_[1];
    $args->{ts} = $c->created_on;
    _hdlr_date($_[0], $args);
}
sub _hdlr_comment_id {
    my $args = $_[1];
    my $c = $_[0]->stash('comment')
        or return $_[0]->_no_comment_error('MTCommentID');
    my $id = $c->id || 0;
    $args && $args->{pad} ? (sprintf "%06d", $id) : $id;
}
sub _hdlr_comment_entry_id {
    my $args = $_[1];
    my $c = $_[0]->stash('comment')
        or return $_[0]->_no_comment_error('MTCommentEntryID');
    $args && $args->{pad} ? (sprintf "%06d", $c->entry_id) : $c->entry_id;
}
sub _hdlr_comment_blog_id {
    my $c = $_[0]->stash('comment')
        or return $_[0]->_no_comment_error('MTCommentBlogID');
    return $c->blog_id;
}
sub _hdlr_comment_if_moderated {
    my $c = $_[0]->stash('comment')
        or return $_[0]->_no_comment_error('MTCommentIfModerated');
    if ($c->visible) {
        return _hdlr_pass_tokens(@_);
    } else {
        return _hdlr_pass_tokens_else(@_);
    }
}

# FIXME: This should be a container tag providing an author
# context for the comment.
sub _hdlr_comment_author {
    sanitize_on($_[1]);
    my $tag = $_[0]->stash('tag');
    my $c;
    my $a;
    if (!$c) {
        $c = $_[0]->stash('comment')
            or return $_[0]->_no_comment_error('MT' . $tag);
        $a = defined $c->author ? $c->author : '';
    }
    $a ||= $_[1]{default} || '';
    remove_html($a);    
}
sub _hdlr_comment_ip {
    my $c = $_[0]->stash('comment')
        or return $_[0]->_no_comment_error('MT' . $_[0]->stash('tag'));
    defined $c->ip ? $c->ip : '';
}
sub _hdlr_comment_author_link {
    #sanitize_on($_[1]);
    my($ctx, $args) = @_;
    _comment_follow($ctx, $args);

    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error('MT' . $ctx->stash('tag'));
    my $name = $c->author;
    $name = '' unless defined $name;
    $name ||= $_[1]{default_name};
    $name ||= '';
    my $show_email = $args->{show_email} ? 1 : 0;
    my $show_url = 1 unless exists $args->{show_url} && !$args->{show_url};
    # Open the link in a new window if requested (with new_window="1").
    my $target = $args->{new_window} ? ' target="_blank"' : '';
    if ($show_url && $c->url) {
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
    } else {
        return $name;
    }
}
sub _hdlr_comment_email {
    sanitize_on($_[1]);
    my $c = $_[0]->stash('comment')
        or return $_[0]->_no_comment_error('MT' . $_[0]->stash('tag'));
    return '' unless defined $c->email;
    return '' unless $c->email =~ m/@/;
    my $email = remove_html($c->email);
    $_[1] && $_[1]->{'spam_protect'} ? spam_protect($email) : $email;
}
sub _hdlr_comment_author_identity {
    my ($ctx, $args) = @_;
    my $cmt = $ctx->stash('comment')
         or return $ctx->_no_comment_error('MT' . $ctx->stash('tag'));
    my $cmntr = $ctx->stash('commenter');
    unless ($cmntr) {
        if ($cmt->commenter_id) {
            $cmntr = MT::Author->load($cmt->commenter_id) 
                or return "?";
        } else {
            return q();
        }
    }
    return q() unless $cmntr->url;
    my $link = $cmntr->url;
    my $static_path = _hdlr_static_path($ctx);
    my $logo = $cmntr->auth_icon_url;
    unless ($logo) {
        my $root_url = $static_path . "images";
        $root_url =~ s|/$||;
        $logo = "$root_url/nav-commenters.gif";
    }
    qq{<a class="commenter-profile" href=\"$link\"><img alt=\"Author Profile Page\" src=\"$logo\" width=\"16\" height=\"16\" /></a>};
}

sub _hdlr_comment_link {
    my $c = $_[0]->stash('comment')
        or return $_[0]->_no_comment_error('MT' . $_[0]->stash('tag'));
    my $entry = $c->entry
        or return $_[0]->error("No entry exists for comment #" . $c->id);
    return $entry->archive_url . '#comment-' . $c->id;
}

sub _hdlr_comment_url {
    sanitize_on($_[1]);
    my $c = $_[0]->stash('comment')
        or return $_[0]->_no_comment_error('MT' . $_[0]->stash('tag'));
    my $url = defined $c->url ? $c->url : '';
    remove_html($url);
}
sub _hdlr_comment_body {
    my($ctx, $arg) = @_;
    sanitize_on($arg);
    _comment_follow($ctx, $arg);

    my $blog = $ctx->stash('blog');
    return q() unless $blog;
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error('MT' . $ctx->stash('tag'));
    my $t = defined $c->text ? $c->text : '';
    unless ($blog->allow_comment_html) {
        $t = remove_html($t);
    }
    my $convert_breaks = exists $arg->{convert_breaks} ?
        $arg->{convert_breaks} :
        $blog->convert_paras_comments;
    $t = $convert_breaks ?
        MT->apply_text_filters($t, $blog->comment_text_filters, $ctx) :
        $t;
    return first_n_text($t, $arg->{words}) if exists $arg->{words};
    if (!(exists $arg->{autolink} && !$arg->{autolink}) &&
        $blog->autolink_urls) {
        $t =~ s!(^|\s|>)(https?://[^\s<]+)!$1<a href="$2">$2</a>!gs;
    }
    $t;
}
sub _hdlr_comment_order_num { $_[0]->stash('comment_order_num') }
sub _hdlr_comment_prev_state { $_[0]->stash('comment_state') }
sub _hdlr_comment_prev_static {
    my $s = encode_html($_[0]->stash('comment_is_static')) || '';
    defined $s ? $s : ''
}
sub _hdlr_comment_entry {
    my($ctx, $args, $cond) = @_;
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error('MTCommentEntry');
    my $entry = MT::Entry->load($c->entry_id)
        or return '';
    local $ctx->{__stash}{entry} = $entry;
    local $ctx->{current_timestamp} = $entry->authored_on;
    $ctx->stash('builder')->build($ctx, $ctx->stash('tokens'), $cond);
}

sub _hdlr_comment_parent {
    my($ctx, $args, $cond) = @_;

    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error('MTCommentParent');
    $c->parent_id && (my $parent = MT::Comment->load($c->parent_id))
        or return '';
    local $ctx->{__stash}{comment} = $parent;
    $ctx->stash('builder')->build($ctx, $ctx->stash('tokens'), $cond);
}

sub _hdlr_comment_replies {
    my($ctx, $args, $cond) = @_;

    my $comment = $ctx->stash('comment')
        or return $ctx->_no_comment_error('MTCommentReplies');
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
            $iter->('finish');
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

sub _hdlr_comment_replies_recurse {
    my($ctx, $args, $cond) = @_;

    my $comment = $ctx->stash('comment')
        or return $ctx->_no_comment_error('MTCommentRepliesRecurse');
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
            $iter->('finish');
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

sub _hdlr_if_comment_replies {
    my($ctx, $args, $cond) = @_;

    my $c = $ctx->stash('comment');
    return 0 if !$c;
    my @children = MT::Comment->load({parent_id => $c->id});
    return $#children >= 0;
}

sub _hdlr_commenter_name_thunk {
    my $ctx = shift;
    my $cfg = $ctx->{config};
    my $blog = $ctx->stash('blog') || MT::Blog->load($ctx->stash('blog_id'));
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
sub _hdlr_commenter_username {
    my $a = $_[0]->stash('commenter');
    $a ? $a->name : '';
}
sub _hdlr_commenter_name {
    my $a = $_[0]->stash('commenter');
    $a ? $a->nickname || '' : '';
}
sub _hdlr_commenter_email {
    my $a = $_[0]->stash('commenter');
    return '' if $a && $a->email !~ m/@/;
    $a ? $a->email || '' : '';
}
sub _hdlr_commenter_auth_type {
    my $a = $_[0]->stash('commenter');
    $a ? $a->auth_type || '' : '';
}
sub _hdlr_commenter_auth_icon_url {
    my $a = $_[0]->stash('commenter');
    return q() unless $a;
    my $size = $_[1]->{size} || 'logo_small';
    return $a->auth_icon_url($size);
}
sub _hdlr_commenter_trusted {
    my ($ctx, $args, $cond) = @_;
    my $a = $ctx->stash('commenter');
    return '' unless $a;
    if ($a->is_trusted($ctx->stash('blog_id'))) {
        return _hdlr_pass_tokens(@_);
    } else {
        return _hdlr_pass_tokens_else(@_);
    }
}

sub _hdlr_commenter_isauthor {
    my ($ctx, $args, $cond) = @_;
    my $a = $ctx->stash('commenter');
    return _hdlr_pass_tokens_else(@_)
      unless $a;
    if ($a->type == MT::Author::AUTHOR()) {
        my $tag = lc $ctx->stash('tag');
        if ($tag eq 'ifcommenterisentryauthor') {
            my $c = $ctx->stash('comment');
            my $e = $c ? $c->entry : $ctx->stash('entry');
            if ($e) {
                if ($e->author_id == $a->id) {
                    return _hdlr_pass_tokens(@_);
                }
            }
        } else {
            return _hdlr_pass_tokens(@_);
        }
    }
    return _hdlr_pass_tokens_else(@_);
}

sub _hdlr_commenter_id {
    my $c = $_[0]->stash('comment')
        or return $_[0]->_no_comment_error($_[0]->stash('tag'));
    my $cmntr = $_[0]->stash('commenter') or return '';
    return $cmntr->id;
}

sub _hdlr_commenter_url {
    my $c = $_[0]->stash('comment')
        or return $_[0]->_no_comment_error($_[0]->stash('tag'));
    my $cmntr = $_[0]->stash('commenter') or return '';
    return $cmntr->url;
}

sub _hdlr_commenter_userpic {
    my $c = $_[0]->stash('comment')
        or return $_[0]->_no_comment_error($_[0]->stash('tag'));
    my $cmntr = $_[0]->stash('commenter') or return '';
    $cmntr->userpic_html() || '';
}

sub _hdlr_commenter_userpic_url {
    my $cmntr = $_[0]->stash('commenter') or return '';
    $cmntr->userpic_url() || '';
}

sub _hdlr_commenter_userpic_asset {
    my ($ctx, $args, $cond) = @_;
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error($ctx->stash('tag'));
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

sub _hdlr_feedback_score {
    my $fb = $_[0]->stash('comment') || $_[0]->stash('ping');
    $fb ? $fb->junk_score || 0 : '';
}

## Archives
sub _get_adjacent_category_entry {
    my($ts, $cat, $order) = @_;
    if ($order eq 'previous') {
        $order = 'descend';
    } else {
        $order = 'ascend';
    }
    require MT::Entry;
    require MT::Placement;
    my $entry = MT::Entry->load(
        { status => MT::Entry::RELEASE() },
        { limit => 1,
          'sort' => 'authored_on',
          direction => $order,
          start_val => $ts,
          'join' => [ 'MT::Placement', 'entry_id',
            { category_id => $cat->id } ] });
    $entry;
}

sub _get_adjacent_author_entry {
    my($ts, $blog_id, $author, $order) = @_;
    if ($order eq 'previous') {
        $order = 'descend';
    } else {
        $order = 'ascend';
    }
    require MT::Entry;
    my $entry = MT::Entry->load(
        { status => MT::Entry::RELEASE(),
          author_id => $author->id,
          blog_id => $blog_id },
        { limit => 1,
          'sort' => 'authored_on',
          direction => $order,
          start_val => $ts});
    $entry;
}

sub _hdlr_archive_prev_next {
    my($ctx, $args, $cond) = @_;
    my $tag = lc $ctx->stash('tag');
    my $is_prev = $tag eq 'archiveprevious';
    my $res = '';
    my $at = ($_[1]->{type} || $_[1]->{archive_type}) || $ctx->{current_archive_type} || $ctx->{archive_type};
    my $arctype = MT->publisher->archiver($at);
    return '' unless $arctype;

    my ($start, $end, $entry);
    if ($arctype->date_based && $arctype->category_based) {
        my $cat = $ctx->stash('archive_category');
        $start = $ctx->{current_timestamp};
        $end = $ctx->{current_timestamp_end};
        if ($is_prev) {
            $entry = _get_adjacent_category_entry( $start, $cat, 'previous' );
        } else {
            $entry = _get_adjacent_category_entry( $end, $cat, 'next' );
        }
    } elsif ($arctype->date_based && $arctype->author_based) {
        my $author = $ctx->stash('author');
        my $blog = $ctx->stash('blog');
        $start = $ctx->{current_timestamp};
        $end = $ctx->{current_timestamp_end};
        if ($is_prev) {
            $entry = _get_adjacent_author_entry( $start, $blog->id, $author, 'previous' );
        } else {
            $entry = _get_adjacent_author_entry( $end, $blog->id, $author, 'next' );
        }
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
        my @arg = ($ts, $ctx->stash('blog_id'), $at);
        push @arg, $is_prev ? 'previous' : 'next';
        $entry = get_entry(@arg);
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
sub _hdlr_index_name {
    my ($ctx, $args, $cond) = @_;
    my $idx = $ctx->stash('index');
    return '' unless $idx;
    $idx->name || '';
}
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

sub _hdlr_archives {
    my($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $at = $blog->archive_type;
    return '' if !$at || $at eq 'None';
    if (my $arg_at = $args->{type} || $args->{archive_type}) {
        $at = $arg_at;
    } elsif ($blog->archive_type_preferred) {
        $at = $blog->archive_type_preferred;
    } else {
        $at = (split /,/, $at)[0];
    }

    my $archiver = MT->publisher->archiver($at);
    return '' unless $archiver;

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
            $save_ts = $ctx->{current_timestamp};
            $save_tse = $ctx->{current_timestamp_end};
            $ctx->{current_timestamp} = undef;
            $ctx->{current_timestamp_end} = undef;
        }
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
        local $ctx->{__stash}{entries} = delay(sub{ 
            $archiver->archive_group_entries($ctx, %curr)
        }) if $archiver->group_based;
        $ctx->{__stash}{$_} = $curr{$_} for keys %curr;
        local $ctx->{inside_archive_list} = 1;

        defined(my $out = $builder->build($ctx, $tokens, { %$cond,
            ArchiveListHeader => $i == 1, ArchiveListFooter => $last }))
            or return $ctx->error( $builder->errstr );
        $res .= $out;
        ($cnt, %curr) = ($next_cnt, %next);
    }

    $ctx->{__stash}{$_} = $save{$_} for keys %save;
    $ctx->{current_timestamp} = $save_ts if $save_ts;
    $ctx->{current_timestamp_end} = $save_tse if $save_tse;
    $res;
}

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

sub _hdlr_archive_date_end {
    my($ctx) = @_;
    my $end = $ctx->{current_timestamp_end}
        or return $_[0]->error(MT->translate(
            "[_1] can be used only with Daily, Weekly, or Monthly archives.",
            '<$MTArchiveDateEnd$>' ));
    $_[1]{ts} = $end;
    _hdlr_date(@_);
}

sub _hdlr_archive_type {
    my ($ctx, $args, $cond) = @_;

    my $at = $ctx->{current_archive_type} || $ctx->{archive_type};
    $at = 'Category' if $ctx->{inside_mt_categories};
    defined $at ? $at : '';
}

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
    $al;
}

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

sub _hdlr_archive_count {
    my $ctx = $_[0];
    if ($ctx->{inside_mt_categories}) {
        return _hdlr_category_count($ctx);
    } elsif (my $count = $ctx->stash('archive_count')) {
        return $count;
    } else {
        my $e = $_[0]->stash('entries');
        my @entries = @$e if ref($e) eq 'ARRAY';
        return scalar @entries;
    }
}

sub _hdlr_archive_category {
    &_hdlr_category_label;
}

sub _hdlr_image_url { $_[0]->stash('image_url') }
sub _hdlr_image_width { $_[0]->stash('image_width') }
sub _hdlr_image_height { $_[0]->stash('image_height') }

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
    $res;
}

sub _hdlr_calendar_day {
    my $day = $_[0]->stash('calendar_day')
        or return $_[0]->error(MT->translate(
            "You used an [_1] tag outside of the proper context.",
            '<$MTCalendarDay$>' ));
    $day;
}

sub _hdlr_calendar_cell_num {
    my $num = $_[0]->stash('calendar_cell')
        or return $_[0]->error(MT->translate(
            "You used an [_1] tag outside of the proper context.",
            '<$MTCalendarCellNumber$>' ));
    $num;
}

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
    
    my $iter = $class->load_iter(\%terms, \%args);
    my $res = '';
    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');
    my $glue = exists $args->{glue} ? $args->{glue} : '';
    ## In order for this handler to double as the handler for
    ## <MTArchiveList archive_type="Category">, it needs to support
    ## the <$MTArchiveLink$> and <$MTArchiveTitle$> tags
    local $ctx->{inside_mt_categories} = 1;
    my $i = 0;
    my $cat = $iter->();
    my $n = $args->{lastn};
    my $vars = $ctx->{__stash}{vars} ||= {};
    while (defined($cat)) {
        $i++;
        my $next_cat = $iter->();
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
        my @args = (
            { blog_id => $cat->blog_id,
              status => MT::Entry::RELEASE() },
            { 'join' => [ 'MT::Placement', 'entry_id',
                          { category_id => $cat->id } ],
              'sort' => 'authored_on',
              direction => 'descend', });
        $ctx->{__stash}{category_count} = $entry_class->count(@args);
        $cat = $next_cat,next unless $ctx->{__stash}{category_count} || $args->{show_empty};
        defined(my $out = $builder->build($ctx, $tokens,
            { %$cond,
              ArchiveListHeader => $i == 1,
              ArchiveListFooter => $last }))
            or return $ctx->error( $builder->errstr );
        $res .= $glue if $res ne '';
        $res .= $out;
        $cat = $next_cat;
    }
    $res;
}

sub _hdlr_category_id {
    my $cat = ($_[0]->stash('category') || $_[0]->stash('archive_category'))
        or return $_[0]->error(MT->translate(
            "You used an [_1] tag outside of the proper context.",
            '<$MT'.$_[0]->stash('tag').'$>'));
    $cat->id;
}

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
    $label;
}

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
    $basename;
}

sub _hdlr_category_desc {
    my $cat = ($_[0]->stash('category') || $_[0]->stash('archive_category'))
        or return $_[0]->error(MT->translate(
            "You used an [_1] tag outside of the proper context.",
            '<$MT'.$_[0]->stash('tag').'$>'));
    defined $cat->description ? $cat->description : '';
}

sub _hdlr_category_count {
    my($ctx) = @_;
    my $cat = ($ctx->stash('category') || $_[0]->stash('archive_category'))
        or return $_[0]->error(MT->translate(
            "You used an [_1] tag outside of the proper context.",
            '<$MT'.$_[0]->stash('tag').'$>'));
    my($count);
    unless ($count = $ctx->stash('category_count')) {
        my $class = MT->model(
            $ctx->stash('tag') =~ m/Category/ig ? 'entry' : 'page');
        my @args = ({ blog_id => $ctx->stash ('blog_id'),
                      status => MT::Entry::RELEASE() },
                    { 'join' => [ 'MT::Placement', 'entry_id',
                                  { category_id => $cat->id } ] });
        require MT::Placement;
        $count = scalar $class->count(@args);
    }
    $count;
}

sub _hdlr_category_comment_count {
    my($ctx) = @_;
    my $cat = ($ctx->stash('category') || $_[0]->stash('archive_category'))
        or return $_[0]->error(MT->translate(
            "You used an [_1] tag outside of the proper context.",
            '<$MT'.$_[0]->stash('tag').'$>'));
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
    $count;
}

sub _hdlr_category_archive {
    my $cat = ($_[0]->stash('category') || $_[0]->stash('archive_category'))
        or return $_[0]->error(MT->translate(
            "You used an [_1] tag outside of the proper context.",
            '<$MTCategoryArchiveLink$>' ));
    my $curr_at = $_[0]->{current_archive_type} || $_[0]->{archive_type} || 'Category';

    my $blog = $_[0]->stash('blog');
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
        return $_[0]->error(MT->translate(
            "[_1] cannot be used without publishing Category archive.",
            '<$MTCategoryArchiveLink$>' )) unless $cat_arc;
    }

    my @entries = MT::Entry->load({ status => MT::Entry::RELEASE() },
        { join => [ 'MT::Placement', 'entry_id', { category_id => $cat->id }, { unqiue => 1 } ] } );
    my $entry = $entries[0] if @entries;
    my $arch = $blog->archive_url;
    $arch .= '/' unless $arch =~ m!/$!;
    $arch = $arch . archive_file_for($entry, $blog, 'Category', $cat);
    $arch = MT::Util::strip_index($arch, $blog) unless $_[1]->{with_index};
    $arch;
}

sub _hdlr_category_tb_link {
    my($ctx, $args) = @_;
    my $cat = $_[0]->stash('category') || $_[0]->stash('archive_category');
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
    $path . $cfg->TrackbackScript . '/' . $tb->id;
}

sub _hdlr_category_allow_pings {
    my $cat = $_[0]->stash('category') || $_[0]->stash('archive_category');
    if ($cat->allow_pings) {
        _hdlr_pass_tokens(@_);
    } else {
        _hdlr_pass_tokens_else(@_);
    }                                 
}

sub _hdlr_category_tb_count {
    my($ctx, $args) = @_;
    my $cat = $_[0]->stash('category') || $_[0]->stash('archive_category');
    return 0 unless $cat;
    require MT::Trackback;
    my $tb = MT::Trackback->load( { category_id => $cat->id } );
    return 0 unless $tb;
    require MT::TBPing;
    my $count = MT::TBPing->count( { tb_id => $tb->id, visible => 1 } );
    $count || 0;
}

sub _load_sibling_categories {
    my ($ctx, $cat) = @_;
    my $blog_id = $cat->blog_id;
    my $r = MT::Request->instance;
    my $cats = $r->stash('__cat_cache_'.$blog_id.'_'.$cat->parent);
    return $cats if $cats;

    my @cats = MT::Category->load({blog_id => $blog_id, parent => $cat->parent},
                                  {'sort' => 'label', direction => 'ascend'});
    $r->stash('__cat_cache_'.$blog_id.'_'.$cat->parent, \@cats);
    \@cats;
}

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
    my $cats = _load_sibling_categories($ctx, $cat);
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

sub _hdlr_if_category {
    my ($ctx, $args, $cond) = @_;
    my $e = $ctx->stash('entry');
    my $tag = lc $ctx->stash('tag');
    my $entry_context = $tag =~ m/(entry|page)if(category|folder)/;
    return $ctx->_no_entry_error($tag) if $entry_context && !$e;
    my $name = $args->{name} || $args->{label};
    if (!defined $name) {
        return $ctx->error(MT->translate("You failed to specify the label attribute for the [_1] tag.", $tag));
    }
    my $primary = $args->{type} && ($args->{type} eq 'primary');
    my $secondary = $args->{type} && ($args->{type} eq 'secondary');
    my $cat = $entry_context ? $e->category : ($ctx->stash('category') || $ctx->stash('archive_category'));
    if (!$cat && $e && !$entry_context) {
        $cat = $e->category;
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
    foreach my $cat (@$cats) {
        return 1 if $cat->label eq $name;
    }
    0;
}

sub _hdlr_entry_additional_categories {
    my($ctx, $args, $cond) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error($ctx->stash('tag'));
    my $cats = $e->categories;
    return '' unless $cats && @$cats;
    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');
    my @res;
    for my $cat (@$cats) {
        next if $e->category && ($cat->label eq $e->category->label);
        local $ctx->{__stash}->{category} = $cat;
        defined(my $out = $builder->build($ctx, $tokens, $cond))
            or return $ctx->error( $builder->errstr );
        push @res, $out;
    }
    my $sep = $args->{glue} || '';
    join $sep, @res; 
}

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
sub _hdlr_pings_sent {
    my($ctx, $args, $cond) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error('MTPingsSent');
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
sub _hdlr_pings_sent_url { $_[0]->stash('ping_sent_url') }
sub _no_ping_error {
    return $_[0]->error(MT->translate("You used an '[_1]' tag outside of the context of " .
                        "a ping; perhaps you mistakenly placed it outside " .
                        "of an 'MTPings' container?", $_[1]));
}
sub _hdlr_ping_date {
    my $p = $_[0]->stash('ping')
        or return $_[0]->_no_ping_error('MTPingDate');
    my $args = $_[1];
    $args->{ts} = $p->created_on;
    _hdlr_date($_[0], $args);
}
sub _hdlr_ping_id {
    my $ping = $_[0]->stash('ping')
        or return $_[0]->_no_ping_error('MTPingID');
    $ping->id;
}
sub _hdlr_ping_title {
    sanitize_on($_[1]);
    my $ping = $_[0]->stash('ping')
        or return $_[0]->_no_ping_error('MTPingTitle');
    defined $ping->title ? $ping->title : '';
}
sub _hdlr_ping_url {
    sanitize_on($_[1]);
    my $ping = $_[0]->stash('ping')
        or return $_[0]->_no_ping_error('MTPingURL');
    defined $ping->source_url ? $ping->source_url : '';
}
sub _hdlr_ping_excerpt {
    sanitize_on($_[1]);
    my $ping = $_[0]->stash('ping')
        or return $_[0]->_no_ping_error('MTPingExcerpt');
    defined $ping->excerpt ? $ping->excerpt : '';
}
sub _hdlr_ping_ip {
    my $ping = $_[0]->stash('ping')
        or return $_[0]->_no_ping_error('MTPingIP');
    defined $ping->ip ? $ping->ip : '';
}
sub _hdlr_ping_blog_name {
    sanitize_on($_[1]);
    my $ping = $_[0]->stash('ping')
        or return $_[0]->_no_ping_error('MTPingBlogName');
    defined $ping->blog_name ? $ping->blog_name : '';
}
sub _hdlr_ping_entry {
    my ($ctx, $args, $cond) = @_;
    my $ping = $ctx->stash('ping')
        or return $ctx->_no_ping_error('MTPingEntry');
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
sub _hdlr_if_allow_comment_html {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    if ($blog->allow_comment_html) {
        return _hdlr_pass_tokens(@_);
    } else {
        return _hdlr_pass_tokens_else(@_);
    }
}

sub _hdlr_if_comments_allowed {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $cfg = $ctx->{config};
    if ((!$blog || ($blog && ($blog->allow_unreg_comments
                              || ($blog->allow_reg_comments
                                  && $blog->effective_remote_auth_token))))
        && $cfg->AllowComments) {
        return _hdlr_pass_tokens(@_);
    } else {
        return _hdlr_pass_tokens_else(@_);
    }
}

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
        return _hdlr_pass_tokens(@_);
    } else {
        return _hdlr_pass_tokens_else(@_);
    }
}

sub _hdlr_if_comments_accepted {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $cfg = $ctx->{config};
    my $entry = $ctx->stash('entry');
    my $blog_comments_accepted = $blog->accepts_comments && $cfg->AllowComments;
    my $accepted = $blog_comments_accepted;
    $accepted = 0 if $entry && !$entry->allow_comments;
    if ($accepted) {
        return _hdlr_pass_tokens(@_);
    } else {
        return _hdlr_pass_tokens_else(@_);
    }
}

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
        return _hdlr_pass_tokens(@_);
    } else {
        return _hdlr_pass_tokens_else(@_);
    }
}

sub _hdlr_if_pings_moderated {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    if ($blog->moderate_pings) {
        return _hdlr_pass_tokens(@_);
    } else {
        return _hdlr_pass_tokens_else(@_);
    }
}

sub _hdlr_if_pings_accepted {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $cfg = $ctx->{config};
    my $accepted;
    my $entry = $ctx->stash('entry');
    $accepted = 1 if $blog->allow_pings && $cfg->AllowPings;
    $accepted = 0 if $entry && !$entry->allow_pings;
    if ($accepted) {
        return _hdlr_pass_tokens(@_);
    } else {
        return _hdlr_pass_tokens_else(@_);
    }
}

sub _hdlr_if_pings_allowed {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $cfg = $ctx->{config};
    if ($blog->allow_pings && $cfg->AllowPings) {
        return _hdlr_pass_tokens(@_);
    } else {
        return _hdlr_pass_tokens_else(@_);
    }
}

sub _hdlr_if_need_email {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $cfg = $ctx->{config};
    if ($blog->require_comment_emails) {
        return _hdlr_pass_tokens(@_);
    } else {
        return _hdlr_pass_tokens_else(@_);
    }
}

sub _hdlr_entry_if_allow_comments {
    my ($ctx, $args, $cond) = @_;
    my $entry = $ctx->stash('entry');
    if ($entry->allow_comments) {
        return _hdlr_pass_tokens(@_);
    } else {
        return _hdlr_pass_tokens_else(@_);
    }
}

sub _hdlr_entry_if_comments_open {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $entry = $ctx->stash('entry');
    my $cfg = $ctx->{config};
    if ($entry && $entry->allow_comments && $entry->allow_comments eq '1') {
        return _hdlr_pass_tokens(@_);
    } else {
        return _hdlr_pass_tokens_else(@_);
    }
}

sub _hdlr_entry_if_allow_pings {
    my ($ctx, $args, $cond) = @_;
    my $entry = $ctx->stash('entry');
    if ($entry->allow_pings) {
        return _hdlr_pass_tokens(@_);
    } else {
        return _hdlr_pass_tokens_else(@_);
    }
}

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
        return _hdlr_pass_tokens(@_);
    } else {
        return _hdlr_pass_tokens_else(@_);
    }
}

sub _hdlr_if_commenter_pending {
    my ($ctx, $args, $cond) = @_;
    my $cmtr = $ctx->stash('commenter');
    my $blog = $ctx->stash('blog');
    if ($cmtr && $blog && $cmtr->commenter_status($blog->id) == MT::Author::PENDING()) {
        return _hdlr_pass_tokens(@_);
    } else {
        return _hdlr_pass_tokens_else(@_);
    }
}

sub _hdlr_sub_cat_is_first {
    $_[0]->stash('subCatIsFirst');
}

sub _hdlr_sub_cat_is_last {
    $_[0]->stash('subCatIsLast');
}

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

sub _hdlr_parent_category {
    my ($ctx, $args, $cond) = @_;

    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');

    # Get the current category
    defined (my $cat = _get_category_context($ctx))
        or return $ctx->error($ctx->errstr);
    return '' if ($cat eq '');
  
    # The category must have a parent, otherwise return empty string
    my $parent = $cat->parent_category or return '';

    # Setup the context and let 'er rip
    local $ctx->{__stash}->{category} = $parent;
    defined (my $out = $builder->build($ctx, $tokens, $cond))
        or return $ctx->error($ctx->errstr);

    $out;
}

sub _hdlr_parent_categories {
    my ($ctx, $args, $cond) = @_;

    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');

    # Get the arguments
    my $exclude_current = $args->{'exclude_current'};
    my $glue = $args->{'glue'} || '';

    # Get the current category
    defined (my $cat = _get_category_context($ctx))
        or return $ctx->error($ctx->errstr);
    return '' if ($cat eq '');

    my @res;

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
        push @res, $out;
    }

    # Slap them all together with some glue
    return join $glue, @res;
}

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

sub _hdlr_has_no_sub_categories {
    !&_hdlr_has_sub_categories;
}

sub _hdlr_has_parent_category {
    my ($ctx, $args) = @_;

    # Get the current category
    defined (my $cat = _get_category_context($ctx))
        or return $ctx->error($ctx->errstr);
    return 0 if ($cat eq '');

    # Return the parent of the category
    return $cat->parent_category ? 1 : 0;
}

sub _hdlr_has_no_parent_category {
    return !&_hdlr_has_parent_category;
}

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
            $iter->('finish');
            return 1;
        }
    }

    0;
}

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
            $iter->('finish');
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

sub _hdlr_entry_blog_id {
    my $args = $_[1];
    my $e = $_[0]->stash('entry')
        or return $_[0]->_no_entry_error($_[0]->stash('tag'));
    $args && $args->{pad} ? (sprintf "%06d", $e->blog_id) : $e->blog_id;
}

sub _hdlr_entry_blog_name {
    my $args = $_[1];
    my $e = $_[0]->stash('entry')
        or return $_[0]->_no_entry_error($_[0]->stash('tag'));
    my $b = MT::Blog->load($e->blog_id);
    $b->name;
}

sub _hdlr_entry_blog_description {
    my $args = $_[1];
    my $e = $_[0]->stash('entry')
        or return $_[0]->_no_entry_error($_[0]->stash('tag'));
    my $b = MT::Blog->load($e->blog_id);
    my $d = $b->description;
    defined $d ? $d : '';
}

sub _hdlr_entry_blog_url {
    my $args = $_[1];
    my $e = $_[0]->stash('entry')
        or return $_[0]->_no_entry_error($_[0]->stash('tag'));
    my $b = MT::Blog->load($e->blog_id);
    $b->site_url;
}

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

sub _hdlr_http_content_type {
    my($ctx, $args) = @_;
    my $type = $args->{type};
    $ctx->stash('content_type', $type);
    return qq{};
}

### for Asset
sub _hdlr_assets {
    my($ctx, $args, $cond) = @_;
    return $ctx->error(MT->translate('sort_by="score" must be used in combination with namespace.'))
        if ((exists $args->{sort_by}) && ('score' eq $args->{sort_by}) && (!exists $args->{namespace}));

    my $assets;
    my $tag = lc $ctx->stash('tag');
    if ($tag eq 'entryassets' || $tag eq 'pageassets') {
        my $e = $ctx->stash('entry')
            or return $ctx->_no_entry_error($tag);

        require MT::ObjectAsset;
        my @assets = MT::Asset->load(undef, { join => MT::ObjectAsset->join_on(undef, {
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
            push @filters, sub { my $a =$_[0]->class; grep(m/$a/, @types) };
        } else {
            $terms{class} = \@types;
        }
    } else {
        $terms{class} = '*';
    }

    # Added a file_ext filter to the filters list.
    if (my $ext = $args->{file_ext}) {
        my @exts = split(',', $args->{file_ext});
        if (!$assets) {
            push @filters, sub { my $a =$_[0]->file_ext; grep(m/$a/, @exts) };
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
            my %map;
            for my $tag (@$tags) {
                my $iter = MT::ObjectTag->load_iter({ tag_id => $tag->id, blog_id => $blog_id, object_datasource => MT::Asset->datasource });
                while (my $et = $iter->()) {
                    $map{$et->object_id}{$tag->id}++;
                }
                                                                                                                                                                                    }
            push @filters, sub { $cexpr->($_[0]->id, \%map) };
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

sub _hdlr_asset_tags {
    my ($ctx, $args, $cond) = @_;

    require MT::ObjectTag;
    require MT::Asset;
    my $asset = $ctx->stash('asset');
    return '' unless $asset;
    my $glue = $args->{glue} || '';

    local $ctx->{__stash}{tag_max_count} = undef;
    local $ctx->{__stash}{tag_min_count} = undef;

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
        $res .= $glue if $res ne '';
        $res .= $out;
    }

    $res;
}

sub _hdlr_asset_id {
    my $args = $_[1];
    my $a = $_[0]->stash('asset')
        or return $_[0]->_no_asset_error('MTAssetID');
    $args && $args->{pad} ? (sprintf "%06d", $a->id) : $a->id;
}

sub _hdlr_asset_file_name {
    my $args = $_[1];
    my $a = $_[0]->stash('asset')
        or return $_[0]->_no_asset_error('MTAssetFileName');
    $a->file_name;
}

sub _hdlr_asset_label {
    my $args = $_[1];
    my $a = $_[0]->stash('asset')
        or return $_[0]->_no_asset_error('MTAssetLabel');
    defined $a->label ? $a->label : '';
}

sub _hdlr_asset_description {
    my $args = $_[1];
    my $a = $_[0]->stash('asset')
        or return $_[0]->_no_asset_error('MTAssetDescription');
    defined $a->description ? $a->description : '';
}

sub _hdlr_asset_url {
    my $args = $_[1];
    my $a = $_[0]->stash('asset')
        or return $_[0]->_no_asset_error('MTAssetURL');
    $a->url;
}

sub _hdlr_asset_type {
    my $args = $_[1];
    my $a = $_[0]->stash('asset')
        or return $_[0]->_no_asset_error('MTAssetType');
    lc $a->class_label;
}

sub _hdlr_asset_mime_type {
    my $args = $_[1];
    my $a = $_[0]->stash('asset')
        or return $_[0]->_no_asset_error('MTAssetMimeType');
    $a->mime_type || '';
}

sub _hdlr_asset_file_path {
    my $args = $_[1];
    my $a = $_[0]->stash('asset')
        or return $_[0]->_no_asset_error('MTAssetFilePath');
    $a->file_path;
}

sub _hdlr_asset_date_added {
    my $args = $_[1];
    my $a = $_[0]->stash('asset')
        or return $_[0]->_no_asset_error('MTAssetDateAdded');
    $args->{ts} = $a->created_on;
    _hdlr_date($_[0], $args);
}

sub _hdlr_asset_added_by {
    my $args = $_[1];
    my $a = $_[0]->stash('asset')
        or return $_[0]->_no_asset_error('MTAssetAddedBy');
    
    require MT::Author;
    my $author = MT::Author->load($a->created_by);
    return '' unless $author;
    $author->nickname || $author->name;
}

sub _hdlr_asset_property {
    my $args = $_[1];
    my $a = $_[0]->stash('asset')
        or return $_[0]->_no_asset_error('MTAssetProperty');
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

sub _hdlr_asset_file_ext {
    my $args = $_[1];
    my $a = $_[0]->stash('asset')
        or return $_[0]->_no_asset_error('MTAssetFileExt');
    $a->file_ext || '';
}

sub _hdlr_asset_thumbnail_url {
    my $args = $_[1];
    my $a = $_[0]->stash('asset')
        or return $_[0]->_no_asset_error('MTAssetThumbnailURL');
    return '' unless $a->has_thumbnail;

    my %arg;
    foreach (keys %$args) {
	$arg{$_} = $args->{$_};
    }
    $arg{Width} = $args->{width} if $args->{width};
    $arg{Height} = $args->{height} if $args->{height};
    $arg{Scale} = $args->{scale} if $args->{scale};
    my ($url, $w, $h) = $a->thumbnail_url(%arg);
    return $url || '';
}

sub _hdlr_asset_link {
    my $args = $_[1];
    my $a = $_[0]->stash('asset')
        or return $_[0]->_no_asset_error('MTAssetLink');

    my $ret = sprintf qq(<a href="%s"), $a->url;
    if ($args->{new_window}) {
        $ret .= qq( target="_blank");
    }
    $ret .= sprintf qq(>%s</a>), $a->file_name;
    $ret;
}

sub _hdlr_asset_thumbnail_link {
    my $args = $_[1];
    my $a = $_[0]->stash('asset')
        or return $_[0]->_no_asset_error('MTAssetThumbnailLink');
    my $class = ref($a);
    return '' unless UNIVERSAL::isa($a, 'MT::Asset::Image');

    # # Load MT::Image
    # require MT::Image;
    # my $img = new MT::Image(Filename => $a->file_path)
    #     or return $_[0]->error(MT->translate(MT::Image->errstr));

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

sub _hdlr_asset_count {
    my ($ctx, $args, $cond) = @_;
    my (%terms, %args);
    $terms{blog_id} = $ctx->stash('blog_id') if $ctx->stash('blog_id');
    $terms{class} = $args->{type} || '*';
    MT::Asset->count(\%terms, \%args);
}
 
sub _hdlr_asset_if_tagged {
    my $args = $_[1];
    my $a = $_[0]->stash('asset')
        or return $_[0]->_no_asset_error('MTAssetIfTagged');

    my $tag = defined $args->{name} ? $args->{name} : ( defined $args->{tag} ? $args->{tag} : '' );
    if ($tag ne '') {
        $a->has_tag($tag);
    } else {
        my @tags = $a->tags;
        @tags = grep /^[^@]/, @tags;
        return @tags ? 1 : 0;
    }
}

sub _no_asset_error {
    return $_[0]->error(MT->translate(
        "You used an '[_1]' tag outside of the context of an asset; " .
        "perhaps you mistakenly placed it outside of an 'MTAssets' container?",
        $_[1]));

}

sub _hdlr_captcha_fields {
    my ($ctx, $args, $cond) = @_;
    my $blog_id = $ctx->stash('blog_id');
    my $blog = MT->model('blog')->load($blog_id);
    if (my $provider = MT->effective_captcha_provider( $blog->captcha_provider ) ) {
        my $fields = $provider->form_fields($blog_id);
        $fields =~ s/[\r\n]//g;
        $fields =~ s/'/\\'/g;
        return $fields;
    }
    return q();
}

sub _no_page_error {
    return $_[0]->error(MT->translate(
        "You used an '[_1]' tag outside of the context of an page; " .
        "perhaps you mistakenly placed it outside of an 'MTPages' container?",
        $_[1]));
}

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

sub _hdlr_page_previous {
    my($ctx, $args, $cond) = @_;

    return $_ unless &_check_page(@_);
    require MT::Page;
    $args->{class_type} = MT::Page->properties->{class_type};
    &_hdlr_entry_previous(@_); 
}

sub _hdlr_page_next {
    my($ctx, $args, $cond) = @_;

    require MT::Page;
    $args->{class_type} = MT::Page->properties->{class_type};
    return $_ unless &_check_page(@_);
    &_hdlr_entry_next(@_); 
}

sub _hdlr_page_tags {
    my($ctx, $args, $cond) = @_;

    return $_ unless &_check_page(@_);
    require MT::Page;
    $args->{class_type} = MT::Page->properties->{class_type};
    &_hdlr_entry_tags(@_); 
}

sub _hdlr_page_if_tagged {
    my($ctx, $args, $cond) = @_;

    return $_ unless &_check_page(@_);
    require MT::Page;
    $args->{class_type} = MT::Page->properties->{class_type};
    &_hdlr_entry_if_tagged(@_); 
}

sub _hdlr_page_folder {
    my($ctx, $args, $cond) = @_;

    return $_ unless &_check_page(@_);
    require MT::Page;
    $args->{class_type} = MT::Page->properties->{class_type};
    local $ctx->{inside_mt_categories} = 1;
    &_hdlr_entry_categories(@_); 
}

sub _hdlr_page_id {
    return $_ unless &_check_page(@_);
    &_hdlr_entry_id(@_); 
}

sub _hdlr_page_title {
    return $_ unless &_check_page(@_);
    &_hdlr_entry_title(@_); 
}

sub _hdlr_page_body {
    return $_ unless &_check_page(@_);
    &_hdlr_entry_body(@_); 
}

sub _hdlr_page_more {
    return $_ unless &_check_page(@_);
    &_hdlr_entry_more(@_); 
}

sub _hdlr_page_date {
    return $_ unless &_check_page(@_);
    &_hdlr_entry_date(@_); 
}

sub _hdlr_page_modified_date {
    return $_ unless &_check_page(@_);
    &_hdlr_entry_mod_date(@_); 
}

sub _hdlr_page_keywords {
    return $_ unless &_check_page(@_);
    &_hdlr_entry_keywords(@_); 
}

sub _hdlr_page_basename {
    return $_ unless &_check_page(@_);
    &_hdlr_entry_basename(@_);
}

sub _hdlr_page_permalink {
    return $_ unless &_check_page(@_);
    &_hdlr_entry_permalink(@_);
}

sub _hdlr_page_author_email {
    return $_ unless &_check_page(@_);
    &_hdlr_entry_author_email(@_);
}

sub _hdlr_page_author_link {
    return $_ unless &_check_page(@_);
    &_hdlr_entry_author_link(@_);
}

sub _hdlr_page_author_url {
    return $_ unless &_check_page(@_);
    &_hdlr_entry_author_url(@_);
}

sub _hdlr_page_excerpt {
    return $_ unless &_check_page(@_);
    &_hdlr_entry_excerpt(@_);
}

sub _hdlr_blog_page_count {
    my($ctx, $args, $cond) = @_;
    
    require MT::Page;
    $args->{class_type} = MT::Page->properties->{class_type};
    &_hdlr_blog_entry_count(@_);
}

sub _hdlr_page_author_display_name {
    return $_ unless &_check_page(@_);
    &_hdlr_entry_author_display_name(@_);
}

sub _hdlr_folders {
    my($ctx, $args, $cond) = @_;

    require MT::Folder;
    $args->{class_type} = MT::Folder->properties->{class_type};
    _hdlr_categories($ctx, $args, $cond);
}

sub _hdlr_folder_prevnext {
    my($ctx, $args, $cond) = @_;

    require MT::Folder;
    $args->{class_type} = MT::Folder->properties->{class_type};
    _hdlr_category_prevnext($ctx, $args, $cond);
}

sub _hdlr_sub_folders {
    my($ctx, $args, $cond) = @_;

    require MT::Folder;
    $args->{class_type} = MT::Folder->properties->{class_type};
    _hdlr_sub_categories($ctx, $args, $cond);
}

sub _hdlr_sub_folder_recurse {
    my($ctx, $args, $cond) = @_;

    require MT::Folder;
    $args->{class_type} = MT::Folder->properties->{class_type};
    _hdlr_sub_cats_recurse($ctx, $args, $cond);
}

sub _hdlr_parent_folders {
    my($ctx, $args, $cond) = @_;

    require MT::Folder;
    $args->{class_type} = MT::Folder->properties->{class_type};
    _hdlr_parent_categories($ctx, $args, $cond);
}

sub _hdlr_parent_folder {
    my($ctx, $args, $cond) = @_;

    require MT::Folder;
    $args->{class_type} = MT::Folder->properties->{class_type};
    _hdlr_parent_category($ctx, $args, $cond);
}

sub _hdlr_top_level_folders {
    my($ctx, $args, $cond) = @_;

    require MT::Folder;
    $args->{class_type} = MT::Folder->properties->{class_type};
    _hdlr_top_level_categories($ctx, $args, $cond);
}

sub _hdlr_top_level_folder {
    my($ctx, $args, $cond) = @_;

    require MT::Folder;
    $args->{class_type} = MT::Folder->properties->{class_type};
    _hdlr_top_level_parent($ctx, $args, $cond);
}

sub _hdlr_folder_basename {
    return $_ unless &_check_folder(@_);
    &_hdlr_category_basename(@_);
}

sub _hdlr_folder_description {
    return $_ unless &_check_folder(@_);
    &_hdlr_category_desc(@_);
}

sub _hdlr_folder_id {
    return $_ unless &_check_folder(@_);
    &_hdlr_category_id(@_);
}

sub _hdlr_folder_label {
    return $_ unless &_check_folder(@_);
    &_hdlr_category_label(@_);
}

sub _hdlr_folder_count {
    return $_ unless &_check_folder(@_);
    &_hdlr_category_count(@_);
}

sub _hdlr_folder_path {
    return $_ unless &_check_folder(@_);
    &_hdlr_sub_category_path(@_);
}

sub _hdlr_if_folder {
    return $_ unless &_check_folder(@_);
    &_hdlr_if_category(@_);
}

sub _hdlr_folder_header {
    return $_ unless &_check_folder(@_);
    $_[0]->stash('folder_header');
}

sub _hdlr_folder_footer {
    return $_ unless &_check_folder(@_);
    $_[0]->stash('folder_footer');
}

sub _hdlr_has_sub_folders {
    return $_ unless &_check_folder(@_);
    &_hdlr_has_sub_categories(@_);
}

sub _hdlr_has_parent_folder {
    return $_ unless &_check_folder(@_);
    &_hdlr_has_parent_category(@_);
}

sub _check_folder {
    my $e = $_[0]->stash('entry');
    my $cat = ($_[0]->stash('category'))
        || (($e = $_[0]->stash('entry')) && $e->category)
        or return MT->translate(
            "You used an [_1] tag outside of the proper context.",
            'MT'.$_[0]->stash('tag') );
    1;
}

sub _check_page {
    my $e = $_[0]->stash('entry')
        or return $_[0]->_no_page_error('MT'.$_[0]->stash('tag'));
    return $_[0]->_no_page_error('MT'.$_[0]->stash('tag'))
        if ref $e ne 'MT::Page';
    1;
}

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
    $score;
      
}

sub _hdlr_entry_score {
    return _object_score_for('entry', @_);
}

sub _hdlr_comment_score {
    return _object_score_for('comment', @_);
}

sub _hdlr_ping_score {
    return _object_score_for('ping', @_);
}

sub _hdlr_asset_score {
    return _object_score_for('asset', @_);
}

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

sub _hdlr_entry_score_high {
    return _object_score_high('entry', @_);
}

sub _hdlr_comment_score_high {
    return _object_score_high('comment', @_);
}

sub _hdlr_ping_score_high {
    return _object_score_high('ping', @_);
}

sub _hdlr_asset_score_high {
    return _object_score_high('asset', @_);
}

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

sub _hdlr_entry_score_low {
    return _object_score_low('entry', @_);
}

sub _hdlr_comment_score_low {
    return _object_score_low('comment', @_);
}

sub _hdlr_ping_score_low {
    return _object_score_low('ping', @_);
}

sub _hdlr_asset_score_low {
    return _object_score_low('asset', @_);
}

sub _hdlr_author_score_low {
    return _object_score_low('author', @_);
}

sub _object_score_avg {
    my ($stash_key, $ctx, $args, $cond) = @_;
    my $key = $args->{namespace};
    return '' unless $key;
    my $object = $ctx->stash($stash_key);
    return '' unless $object;
    return $object->score_avg($key);
}

sub _hdlr_entry_score_avg {
    return _object_score_avg('entry', @_);
}

sub _hdlr_comment_score_avg {
    return _object_score_avg('comment', @_);
}

sub _hdlr_ping_score_avg {
    return _object_score_avg('ping', @_);
}

sub _hdlr_asset_score_avg {
    return _object_score_avg('asset', @_);
}

sub _hdlr_author_score_avg {
    return _object_score_avg('author', @_);
}

sub _object_score_count {
    my ($stash_key, $ctx, $args, $cond) = @_;
    my $key = $args->{namespace};
    return '' unless $key;
    my $object = $ctx->stash($stash_key);
    return '' unless $object;
    return $object->vote_for($key);
}

sub _hdlr_entry_score_count {
    return _object_score_count('entry', @_);
}

sub _hdlr_comment_score_count {
    return _object_score_count('comment', @_);
}

sub _hdlr_ping_score_count {
    return _object_score_count('ping', @_);
}

sub _hdlr_asset_score_count {
    return _object_score_count('asset', @_);
}

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

sub _hdlr_asset_rank {
    return _object_rank('asset', {}, @_);
}

sub _hdlr_author_rank {
    return _object_rank('author', {},  @_);
}

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

1;
