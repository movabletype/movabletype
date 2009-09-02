# Movable Type (r) Open Source (C) 2001-2009 Six Apart Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: ContextHandlers.pm 3531 2009-03-12 09:11:52Z fumiakiy $

package MT::Template::Context;

use strict;

use MT::Util qw( format_ts relative_date );
use Time::Local qw( timelocal );

sub init_default_handlers {}
sub init_default_filters {}

sub core_tags {
    my $tags = {
        help_url => sub { MT->translate('http://www.movabletype.org/documentation/appendices/tags/%t.html') },
        block => {

            ## Core
            Ignore         =>   sub { '' },
            'If?'          => '$Core::MT::Template::Tags::Core::_hdlr_if',
            'Unless?'      => '$Core::MT::Template::Tags::Core::_hdlr_unless',
            'Else'         => '$Core::MT::Template::Tags::Core::_hdlr_else',
            'ElseIf'       => '$Core::MT::Template::Tags::Core::_hdlr_elseif',
            'IfNonEmpty?'  => '$Core::MT::Template::Tags::Core::_hdlr_if_nonempty',
            'IfNonZero?'   => '$Core::MT::Template::Tags::Core::_hdlr_if_nonzero',
            Loop           => '$Core::MT::Template::Tags::Core::_hdlr_loop',
            'For'          => '$Core::MT::Template::Tags::Core::_hdlr_for',
            SetVarBlock    => '$Core::MT::Template::Tags::Core::_hdlr_set_var',
            SetVarTemplate => '$Core::MT::Template::Tags::Core::_hdlr_set_var',
            SetVars        => '$Core::MT::Template::Tags::Core::_hdlr_set_vars',
            SetHashVar     => '$Core::MT::Template::Tags::Core::_hdlr_set_hashvar',

            ## System
            IncludeBlock => '$Core::MT::Template::Tags::System::_hdlr_include_block',
            IfStatic     => \&slurp,
            IfDynamic    => \&else,
            Section      => '$Core::MT::Template::Tags::System::_hdlr_section',

            ## App
            'App:Setting'      => '$Core::MT::Template::Tags::App::_hdlr_app_setting',
            'App:Widget'       => '$Core::MT::Template::Tags::App::_hdlr_app_widget',
            'App:StatusMsg'    => '$Core::MT::Template::Tags::App::_hdlr_app_statusmsg',
            'App:Listing'      => '$Core::MT::Template::Tags::App::_hdlr_app_listing',
            'App:SettingGroup' => '$Core::MT::Template::Tags::App::_hdlr_app_setting_group',
            'App:Form'         => '$Core::MT::Template::Tags::App::_hdlr_app_form',

            ## Blog
            Blogs              => '$Core::MT::Template::Tags::Blog::_hdlr_blogs',
            'IfBlog?'          => '$Core::MT::Template::Tags::Blog::_hdlr_if_blog',
            'BlogIfCCLicense?' => '$Core::MT::Template::Tags::Blog::_hdlr_blog_if_cc_license',

            ## Website
            Websites              => '$Core::MT::Template::Tags::Website::_hdlr_websites',
            'IfWebsite?'          => '$Core::MT::Template::Tags::Website::_hdlr_website_id',
            'WebsiteIfCCLicense?' => '$Core::MT::Template::Tags::Website::_hdlr_website_if_cc_license',
            'WebsiteHasBlog?'      => '$Core::MT::Template::Tags::Website::_hdlr_website_has_blog',

            ## Author
            Authors            => '$Core::MT::Template::Tags::Author::_hdlr_authors',
            AuthorNext         => '$Core::MT::Template::Tags::Author::_hdlr_author_next_prev',
            AuthorPrevious     => '$Core::MT::Template::Tags::Author::_hdlr_author_next_prev',
            'IfAuthor?'        => '$Core::MT::Template::Tags::Author::_hdlr_if_author',

            ## Commenter
            'IfExternalUserManagement?'       => '$Core::MT::Template::Tags::Commenter::_hdlr_if_external_user_management',
            'IfCommenterRegistrationAllowed?' => '$Core::MT::Template::Tags::Commenter::_hdlr_if_commenter_registration_allowed',
            'IfCommenterTrusted?'             => '$Core::MT::Template::Tags::Commenter::_hdlr_commenter_trusted',
            'CommenterIfTrusted?'             => '$Core::MT::Template::Tags::Commenter::_hdlr_commenter_trusted',
            'IfCommenterIsAuthor?'            => '$Core::MT::Template::Tags::Commenter::_hdlr_commenter_isauthor',
            'IfCommenterIsEntryAuthor?'       => '$Core::MT::Template::Tags::Commenter::_hdlr_commenter_isauthor',

            ## Archive
            Archives                => '$Core::MT::Template::Tags::Archive::_hdlr_archive_set',
            ArchiveList             => '$Core::MT::Template::Tags::Archive::_hdlr_archives',
            ArchiveListHeader       => \&slurp,
            ArchiveListFooter       => \&slurp,
            ArchivePrevious         => '$Core::MT::Template::Tags::Archive::_hdlr_archive_prev_next',
            ArchiveNext             => '$Core::MT::Template::Tags::Archive::_hdlr_archive_prev_next',
            'IfArchiveType?'        => '$Core::MT::Template::Tags::Archive::_hdlr_if_archive_type',
            'IfArchiveTypeEnabled?' => '$Core::MT::Template::Tags::Archive::_hdlr_archive_type_enabled',
            IndexList               => '$Core::MT::Template::Tags::Archive::_hdlr_index_list',

            ## Entry
            Entries            => '$Core::MT::Template::Tags::Entry::_hdlr_entries',
            EntriesHeader      => \&slurp,
            EntriesFooter      => \&slurp,
            EntryPrevious      => '$Core::MT::Template::Tags::Entry::_hdlr_entry_previous',
            EntryNext          => '$Core::MT::Template::Tags::Entry::_hdlr_entry_next',
            DateHeader         => \&slurp,
            DateFooter         => \&slurp,
            'EntryIfExtended?' => '$Core::MT::Template::Tags::Entry::_hdlr_entry_if_extended',
            'AuthorHasEntry?'  => '$Core::MT::Template::Tags::Entry::_hdlr_author_has_entry',

            ## Comment
            'IfCommentsModerated?'       => '$Core::MT::Template::Tags::Comment::_hdlr_comments_moderated',
            'BlogIfCommentsOpen?'        => '$Core::MT::Template::Tags::Comment::_hdlr_blog_if_comments_open',
            'WebsiteIfCommentsOpen?'     => '$Core::MT::Template::Tags::Comment::_hdlr_blog_if_comments_open',
            Comments                     => '$Core::MT::Template::Tags::Comment::_hdlr_comments',
            CommentsHeader               => \&slurp,
            CommentsFooter               => \&slurp,
            CommentEntry                 => '$Core::MT::Template::Tags::Comment::_hdlr_comment_entry',
            'CommentIfModerated?'        => '$Core::MT::Template::Tags::Comment::_hdlr_comment_if_moderated',
            CommentParent                => '$Core::MT::Template::Tags::Comment::_hdlr_comment_parent',
            CommentReplies               => '$Core::MT::Template::Tags::Comment::_hdlr_comment_replies',
            'IfCommentParent?'           => '$Core::MT::Template::Tags::Comment::_hdlr_if_comment_parent',
            'IfCommentReplies?'          => '$Core::MT::Template::Tags::Comment::_hdlr_if_comment_replies',
            'IfRegistrationRequired?'    => '$Core::MT::Template::Tags::Comment::_hdlr_reg_required',
            'IfRegistrationNotRequired?' => '$Core::MT::Template::Tags::Comment::_hdlr_reg_not_required',
            'IfRegistrationAllowed?'     => '$Core::MT::Template::Tags::Comment::_hdlr_reg_allowed',
            'IfTypeKeyToken?'            => '$Core::MT::Template::Tags::Comment::_hdlr_if_typekey_token',
            'IfAllowCommentHTML?'        => '$Core::MT::Template::Tags::Comment::_hdlr_if_allow_comment_html',
            'IfCommentsAllowed?'         => '$Core::MT::Template::Tags::Comment::_hdlr_if_comments_allowed',
            'IfCommentsAccepted?'        => '$Core::MT::Template::Tags::Comment::_hdlr_if_comments_accepted',
            'IfCommentsActive?'          => '$Core::MT::Template::Tags::Comment::_hdlr_if_comments_active',
            'IfNeedEmail?'               => '$Core::MT::Template::Tags::Comment::_hdlr_if_need_email',
            'IfRequireCommentEmails?'    => '$Core::MT::Template::Tags::Comment::_hdlr_if_need_email',
            'EntryIfAllowComments?'      => '$Core::MT::Template::Tags::Comment::_hdlr_entry_if_allow_comments',
            'EntryIfCommentsOpen?'       => '$Core::MT::Template::Tags::Comment::_hdlr_entry_if_comments_open',

            ## Ping
            Pings                    => '$Core::MT::Template::Tags::Ping::_hdlr_pings',
            PingsHeader              => \&slurp,
            PingsFooter              => \&slurp,
            PingsSent                => '$Core::MT::Template::Tags::Ping::_hdlr_pings_sent',
            PingEntry                => '$Core::MT::Template::Tags::Ping::_hdlr_ping_entry',
            'IfPingsAllowed?'        => '$Core::MT::Template::Tags::Ping::_hdlr_if_pings_allowed',
            'IfPingsAccepted?'       => '$Core::MT::Template::Tags::Ping::_hdlr_if_pings_accepted',
            'IfPingsActive?'         => '$Core::MT::Template::Tags::Ping::_hdlr_if_pings_active',
            'IfPingsModerated?'      => '$Core::MT::Template::Tags::Ping::_hdlr_if_pings_moderated',
            'EntryIfAllowPings?'     => '$Core::MT::Template::Tags::Ping::_hdlr_entry_if_allow_pings',
            'CategoryIfAllowPings?'  => '$Core::MT::Template::Tags::Ping::_hdlr_category_allow_pings',

            ## Category
            Categories                => '$Core::MT::Template::Tags::Category::_hdlr_categories',
            CategoryPrevious          => '$Core::MT::Template::Tags::Category::_hdlr_category_prevnext',
            CategoryNext              => '$Core::MT::Template::Tags::Category::_hdlr_category_prevnext',
            SubCategories             => '$Core::MT::Template::Tags::Category::_hdlr_sub_categories',
            TopLevelCategories        => '$Core::MT::Template::Tags::Category::_hdlr_top_level_categories',
            ParentCategory            => '$Core::MT::Template::Tags::Category::_hdlr_parent_category',
            ParentCategories          => '$Core::MT::Template::Tags::Category::_hdlr_parent_categories',
            TopLevelParent            => '$Core::MT::Template::Tags::Category::_hdlr_top_level_parent',
            EntriesWithSubCategories  => '$Core::MT::Template::Tags::Category::_hdlr_entries_with_sub_categories',
            'IfCategory?'             => '$Core::MT::Template::Tags::Category::_hdlr_if_category',
            'EntryIfCategory?'        => '$Core::MT::Template::Tags::Category::_hdlr_if_category',
            'SubCatIsFirst?'          => '$Core::MT::Template::Tags::Category::_hdlr_sub_cat_is_first',
            'SubCatIsLast?'           => '$Core::MT::Template::Tags::Category::_hdlr_sub_cat_is_last',
            'HasSubCategories?'       => '$Core::MT::Template::Tags::Category::_hdlr_has_sub_categories',
            'HasNoSubCategories?'     => '$Core::MT::Template::Tags::Category::_hdlr_has_no_sub_categories',
            'HasParentCategory?'      => '$Core::MT::Template::Tags::Category::_hdlr_has_parent_category',
            'HasNoParentCategory?'    => '$Core::MT::Template::Tags::Category::_hdlr_has_no_parent_category',
            'IfIsAncestor?'           => '$Core::MT::Template::Tags::Category::_hdlr_is_ancestor',
            'IfIsDescendant?'         => '$Core::MT::Template::Tags::Category::_hdlr_is_descendant',
            EntryCategories           => '$Core::MT::Template::Tags::Category::_hdlr_entry_categories',
            EntryAdditionalCategories => '$Core::MT::Template::Tags::Category::_hdlr_entry_additional_categories',

            ## Page
            'AuthorHasPage?' => '$Core::MT::Template::Tags::Page::_hdlr_author_has_page',
            Pages            => '$Core::MT::Template::Tags::Page::_hdlr_pages',
            PagePrevious     => '$Core::MT::Template::Tags::Page::_hdlr_page_previous',
            PageNext         => '$Core::MT::Template::Tags::Page::_hdlr_page_next',
            PagesHeader      => \&slurp,
            PagesFooter      => \&slurp,

            ## Folder
            'IfFolder?'        => '$Core::MT::Template::Tags::Folder::_hdlr_if_folder',
            'FolderHeader?'    => '$Core::MT::Template::Tags::Folder::_hdlr_folder_header',
            'FolderFooter?'    => '$Core::MT::Template::Tags::Folder::_hdlr_folder_footer',
            'HasSubFolders?'   => '$Core::MT::Template::Tags::Folder::_hdlr_has_sub_folders',
            'HasParentFolder?' => '$Core::MT::Template::Tags::Folder::_hdlr_has_parent_folder',
            PageFolder         => '$Core::MT::Template::Tags::Folder::_hdlr_page_folder',
            Folders            => '$Core::MT::Template::Tags::Folder::_hdlr_folders',
            FolderPrevious     => '$Core::MT::Template::Tags::Folder::_hdlr_folder_prevnext',
            FolderNext         => '$Core::MT::Template::Tags::Folder::_hdlr_folder_prevnext',
            SubFolders         => '$Core::MT::Template::Tags::Folder::_hdlr_sub_folders',
            ParentFolders      => '$Core::MT::Template::Tags::Folder::_hdlr_parent_folders',
            ParentFolder       => '$Core::MT::Template::Tags::Folder::_hdlr_parent_folder',
            TopLevelFolders    => '$Core::MT::Template::Tags::Folder::_hdlr_top_level_folders',
            TopLevelFolder     => '$Core::MT::Template::Tags::Folder::_hdlr_top_level_folder',

            ## Asset
            EntryAssets       => '$Core::MT::Template::Tags::Asset::_hdlr_assets',
            PageAssets        => '$Core::MT::Template::Tags::Asset::_hdlr_assets',
            Assets            => '$Core::MT::Template::Tags::Asset::_hdlr_assets',
            Asset             => '$Core::MT::Template::Tags::Asset::_hdlr_asset',
            AssetIsFirstInRow => \&slurp,
            AssetIsLastInRow  => \&slurp,
            AssetsHeader      => \&slurp,
            AssetsFooter      => \&slurp,

            ## Userpic
            AuthorUserpicAsset      => '$Core::MT::Template::Tags::Userpic::_hdlr_author_userpic_asset',
            EntryAuthorUserpicAsset => '$Core::MT::Template::Tags::Userpic::_hdlr_entry_author_userpic_asset',
            CommenterUserpicAsset   => '$Core::MT::Template::Tags::Userpic::_hdlr_commenter_userpic_asset',

            ## Tag
            Tags             => '$Core::MT::Template::Tags::Tag::_hdlr_tags',
            EntryTags        => '$Core::MT::Template::Tags::Tag::_hdlr_entry_tags',
            PageTags         => '$Core::MT::Template::Tags::Tag::_hdlr_page_tags',
            AssetTags        => '$Core::MT::Template::Tags::Tag::_hdlr_asset_tags',
            'EntryIfTagged?' => '$Core::MT::Template::Tags::Tag::_hdlr_entry_if_tagged',
            'PageIfTagged?'  => '$Core::MT::Template::Tags::Tag::_hdlr_page_if_tagged',
            'AssetIfTagged?' => '$Core::MT::Template::Tags::Tag::_hdlr_asset_if_tagged',

            ## Calendar
            Calendar            => '$Core::MT::Template::Tags::Calendar::_hdlr_calendar',
            CalendarWeekHeader  => \&slurp,
            CalendarWeekFooter  => \&slurp,
            CalendarIfBlank     => \&slurp,
            CalendarIfToday     => \&slurp,
            CalendarIfEntries   => \&slurp,
            CalendarIfNoEntries => \&slurp,

            ## Pager
            'IfMoreResults?'     => '$Core::MT::Template::Tags::Pager::_hdlr_if_more_results',
            'IfPreviousResults?' => '$Core::MT::Template::Tags::Pager::_hdlr_if_previous_results',
            PagerBlock           => '$Core::MT::Template::Tags::Pager::_hdlr_pager_block',
            IfCurrentPage        => \&slurp,

            ## Search
            IfTagSearch         => sub { '' },
            SearchResults       => sub { '' },
            IfStraightSearch    => sub { '' },
            NoSearchResults     => \&slurp,
            NoSearch            => \&slurp,
            SearchResultsHeader => sub { '' },
            SearchResultsFooter => sub { '' },
            BlogResultHeader    => sub { '' },
            BlogResultFooter    => sub { '' },
            IfMaxResultsCutoff  => sub { '' },

            ## Misc
            'IfImageSupport?' => '$Core::MT::Template::Tags::Misc::_hdlr_if_image_support',
        },
        function => {

            ## Core
            SetVar       => '$Core::MT::Template::Tags::Core::_hdlr_set_var',
            GetVar       => '$Core::MT::Template::Tags::Core::_hdlr_get_var',
            Var          => '$Core::MT::Template::Tags::Core::_hdlr_get_var',
            TemplateNote => sub { '' },

            ## System
            Include           => '$Core::MT::Template::Tags::System::_hdlr_include',
            Link              => '$Core::MT::Template::Tags::System::_hdlr_link',
            Date              => '$Core::MT::Template::Tags::System::_hdlr_sys_date',
            AdminScript       => '$Core::MT::Template::Tags::System::_hdlr_admin_script',
            CommentScript     => '$Core::MT::Template::Tags::System::_hdlr_comment_script',
            TrackbackScript   => '$Core::MT::Template::Tags::System::_hdlr_trackback_script',
            SearchScript      => '$Core::MT::Template::Tags::System::_hdlr_search_script',
            XMLRPCScript      => '$Core::MT::Template::Tags::System::_hdlr_xmlrpc_script',
            AtomScript        => '$Core::MT::Template::Tags::System::_hdlr_atom_script',
            NotifyScript      => '$Core::MT::Template::Tags::System::_hdlr_notify_script',
            CGIHost           => '$Core::MT::Template::Tags::System::_hdlr_cgi_host',
            CGIPath           => '$Core::MT::Template::Tags::System::_hdlr_cgi_path',
            AdminCGIPath      => '$Core::MT::Template::Tags::System::_hdlr_admin_cgi_path',
            CGIRelativeURL    => '$Core::MT::Template::Tags::System::_hdlr_cgi_relative_url',
            CGIServerPath     => '$Core::MT::Template::Tags::System::_hdlr_cgi_server_path',
            StaticWebPath     => '$Core::MT::Template::Tags::System::_hdlr_static_path',
            StaticFilePath    => '$Core::MT::Template::Tags::System::_hdlr_static_file_path',
            SupportDirectoryURL => '$Core::MT::Template::Tags::System::_hdlr_support_directory_url',
            Version           => '$Core::MT::Template::Tags::System::_hdlr_mt_version',
            ProductName       => '$Core::MT::Template::Tags::System::_hdlr_product_name',
            PublishCharset    => '$Core::MT::Template::Tags::System::_hdlr_publish_charset',
            DefaultLanguage   => '$Core::MT::Template::Tags::System::_hdlr_default_language',
            ConfigFile        => '$Core::MT::Template::Tags::System::_hdlr_config_file',
            IndexBasename     => '$Core::MT::Template::Tags::System::_hdlr_index_basename',
            HTTPContentType   => '$Core::MT::Template::Tags::System::_hdlr_http_content_type',
            FileTemplate      => '$Core::MT::Template::Tags::System::_hdlr_file_template',
            TemplateCreatedOn => '$Core::MT::Template::Tags::System::_hdlr_template_created_on',
            BuildTemplateID   => '$Core::MT::Template::Tags::System::_hdlr_build_template_id',
            ErrorMessage      => '$Core::MT::Template::Tags::System::_hdlr_error_message',

            ## App

            'App:PageActions' => '$Core::MT::Template::Tags::App::_hdlr_app_page_actions',
            'App:ListFilters' => '$Core::MT::Template::Tags::App::_hdlr_app_list_filters',
            'App:ActionBar'   => '$Core::MT::Template::Tags::App::_hdlr_app_action_bar',
            'App:Link'        => '$Core::MT::Template::Tags::App::_hdlr_app_link',

            ## Blog
            BlogID             => '$Core::MT::Template::Tags::Blog::_hdlr_blog_id',
            BlogName           => '$Core::MT::Template::Tags::Blog::_hdlr_blog_name',
            BlogDescription    => '$Core::MT::Template::Tags::Blog::_hdlr_blog_description',
            BlogLanguage       => '$Core::MT::Template::Tags::Blog::_hdlr_blog_language',
            BlogURL            => '$Core::MT::Template::Tags::Blog::_hdlr_blog_url',
            BlogArchiveURL     => '$Core::MT::Template::Tags::Blog::_hdlr_blog_archive_url',
            BlogRelativeURL    => '$Core::MT::Template::Tags::Blog::_hdlr_blog_relative_url',
            BlogSitePath       => '$Core::MT::Template::Tags::Blog::_hdlr_blog_site_path',
            BlogHost           => '$Core::MT::Template::Tags::Blog::_hdlr_blog_host',
            BlogTimezone       => '$Core::MT::Template::Tags::Blog::_hdlr_blog_timezone',
            BlogCCLicenseURL   => '$Core::MT::Template::Tags::Blog::_hdlr_blog_cc_license_url',
            BlogCCLicenseImage => '$Core::MT::Template::Tags::Blog::_hdlr_blog_cc_license_image',
            CCLicenseRDF       => '$Core::MT::Template::Tags::Blog::_hdlr_cc_license_rdf',
            BlogFileExtension  => '$Core::MT::Template::Tags::Blog::_hdlr_blog_file_extension',
            BlogTemplateSetID  => '$Core::MT::Template::Tags::Blog::_hdlr_blog_template_set_id',
            BlogThemeID        => '$Core::MT::Template::Tags::Blog::_hdlr_blog_theme_id',


            ## Website
            WebsiteID             => '$Core::MT::Template::Tags::Website::_hdlr_website_id',
            WebsiteLabel          => '$Core::MT::Template::Tags::Website::_hdlr_website_label',
            WebsiteDescription    => '$Core::MT::Template::Tags::Website::_hdlr_website_description',
            WebsiteLanguage       => '$Core::MT::Template::Tags::Website::_hdlr_website_language',
            WebsiteURL            => '$Core::MT::Template::Tags::Website::_hdlr_website_url',
            WebsitePath           => '$Core::MT::Template::Tags::Website::_hdlr_website_path',
            WebsiteTimezone       => '$Core::MT::Template::Tags::Website::_hdlr_website_timezone',
            WebsiteCCLicenseURL   => '$Core::MT::Template::Tags::Website::_hdlr_website_cc_license_url',
            WebsiteCCLicenseImage => '$Core::MT::Template::Tags::Website::_hdlr_website_cc_license_image',
            WebsiteFileExtension  => '$Core::MT::Template::Tags::Website::_hdlr_website_file_extension',
            WebsiteHost           => '$Core::MT::Template::Tags::Website::_hdlr_website_host',
            WebsiteRelativeURL    => '$Core::MT::Template::Tags::Website::_hdlr_website_relative_url',
            WebsiteThemeID        => '$Core::MT::Template::Tags::Website::_htlr_website_theme_id',

            ## Author
            AuthorID          => '$Core::MT::Template::Tags::Author::_hdlr_author_id',
            AuthorName        => '$Core::MT::Template::Tags::Author::_hdlr_author_name',
            AuthorDisplayName => '$Core::MT::Template::Tags::Author::_hdlr_author_display_name',
            AuthorEmail       => '$Core::MT::Template::Tags::Author::_hdlr_author_email',
            AuthorURL         => '$Core::MT::Template::Tags::Author::_hdlr_author_url',
            AuthorAuthType    => '$Core::MT::Template::Tags::Author::_hdlr_author_auth_type',
            AuthorAuthIconURL => '$Core::MT::Template::Tags::Author::_hdlr_author_auth_icon_url',
            AuthorBasename    => '$Core::MT::Template::Tags::Author::_hdlr_author_basename',
            AuthorCommentCount => '$Core::MT::Summary::Author::_hdlr_author_comment_count',
            AuthorEntriesCount => '$Core::MT::Summary::Author::_hdlr_author_entries_count',

            ## Commenter
            CommenterNameThunk       => '$Core::MT::Template::Tags::Commenter::_hdlr_commenter_name_thunk',
            CommenterUsername        => '$Core::MT::Template::Tags::Commenter::_hdlr_commenter_username', 
            CommenterName            => '$Core::MT::Template::Tags::Commenter::_hdlr_commenter_name',
            CommenterEmail           => '$Core::MT::Template::Tags::Commenter::_hdlr_commenter_email',
            CommenterAuthType        => '$Core::MT::Template::Tags::Commenter::_hdlr_commenter_auth_type',
            CommenterAuthIconURL     => '$Core::MT::Template::Tags::Commenter::_hdlr_commenter_auth_icon_url',
            CommenterID              => '$Core::MT::Template::Tags::Commenter::_hdlr_commenter_id',
            CommenterURL             => '$Core::MT::Template::Tags::Commenter::_hdlr_commenter_url',
            UserSessionState         => '$Core::MT::Template::Tags::Commenter::_hdlr_user_session_state',
            UserSessionCookieTimeout => '$Core::MT::Template::Tags::Commenter::_hdlr_user_session_cookie_timeout',
            UserSessionCookieName    => '$Core::MT::Template::Tags::Commenter::_hdlr_user_session_cookie_name',
            UserSessionCookiePath    => '$Core::MT::Template::Tags::Commenter::_hdlr_user_session_cookie_path',
            UserSessionCookieDomain  => '$Core::MT::Template::Tags::Commenter::_hdlr_user_session_cookie_domain',

            ## Archive
            ArchiveLink      => '$Core::MT::Template::Tags::Archive::_hdlr_archive_link',
            ArchiveTitle     => '$Core::MT::Template::Tags::Archive::_hdlr_archive_title',
            ArchiveType      => '$Core::MT::Template::Tags::Archive::_hdlr_archive_type',
            ArchiveTypeLabel => '$Core::MT::Template::Tags::Archive::_hdlr_archive_label',
            ArchiveLabel     => '$Core::MT::Template::Tags::Archive::_hdlr_archive_label',
            ArchiveCount     => '$Core::MT::Template::Tags::Archive::_hdlr_archive_count',
            ArchiveDate      => \&build_date,
            ArchiveDateEnd   => '$Core::MT::Template::Tags::Archive::_hdlr_archive_date_end',
            ArchiveFile      => '$Core::MT::Template::Tags::Archive::_hdlr_archive_file',
            IndexLink        => '$Core::MT::Template::Tags::Archive::_hdlr_index_link',
            IndexName        => '$Core::MT::Template::Tags::Archive::_hdlr_index_name',

            ## Entry
            EntriesCount           => '$Core::MT::Template::Tags::Entry::_hdlr_entries_count',
            EntryID                => '$Core::MT::Template::Tags::Entry::_hdlr_entry_id',
            EntryTitle             => '$Core::MT::Template::Tags::Entry::_hdlr_entry_title',
            EntryStatus            => '$Core::MT::Template::Tags::Entry::_hdlr_entry_status',
            EntryFlag              => '$Core::MT::Template::Tags::Entry::_hdlr_entry_flag',
            EntryBody              => '$Core::MT::Template::Tags::Entry::_hdlr_entry_body',
            EntryMore              => '$Core::MT::Template::Tags::Entry::_hdlr_entry_more',
            EntryExcerpt           => '$Core::MT::Template::Tags::Entry::_hdlr_entry_excerpt',
            EntryKeywords          => '$Core::MT::Template::Tags::Entry::_hdlr_entry_keywords',
            EntryLink              => '$Core::MT::Template::Tags::Entry::_hdlr_entry_link',
            EntryBasename          => '$Core::MT::Template::Tags::Entry::_hdlr_entry_basename',
            EntryAtomID            => '$Core::MT::Template::Tags::Entry::_hdlr_entry_atom_id',
            EntryPermalink         => '$Core::MT::Template::Tags::Entry::_hdlr_entry_permalink',
            EntryClass             => '$Core::MT::Template::Tags::Entry::_hdlr_entry_class',
            EntryClassLabel        => '$Core::MT::Template::Tags::Entry::_hdlr_entry_class_label',
            EntryAuthor            => '$Core::MT::Template::Tags::Entry::_hdlr_entry_author',
            EntryAuthorDisplayName => '$Core::MT::Template::Tags::Entry::_hdlr_entry_author_display_name',
            EntryAuthorNickname    => '$Core::MT::Template::Tags::Entry::_hdlr_entry_author_nick',
            EntryAuthorUsername    => '$Core::MT::Template::Tags::Entry::_hdlr_entry_author_username',
            EntryAuthorEmail       => '$Core::MT::Template::Tags::Entry::_hdlr_entry_author_email',
            EntryAuthorURL         => '$Core::MT::Template::Tags::Entry::_hdlr_entry_author_url',
            EntryAuthorLink        => '$Core::MT::Template::Tags::Entry::_hdlr_entry_author_link',
            EntryAuthorID          => '$Core::MT::Template::Tags::Entry::_hdlr_entry_author_id',

            AuthorEntryCount       => '$Core::MT::Template::Tags::Entry::_hdlr_author_entry_count',
            EntryDate              => '$Core::MT::Template::Tags::Entry::_hdlr_entry_date',
            EntryCreatedDate       => '$Core::MT::Template::Tags::Entry::_hdlr_entry_create_date',
            EntryModifiedDate      => '$Core::MT::Template::Tags::Entry::_hdlr_entry_mod_date',

            EntryBlogID            => '$Core::MT::Template::Tags::Entry::_hdlr_entry_blog_id',
            EntryBlogName          => '$Core::MT::Template::Tags::Entry::_hdlr_entry_blog_name',
            EntryBlogDescription   => '$Core::MT::Template::Tags::Entry::_hdlr_entry_blog_description',
            EntryBlogURL           => '$Core::MT::Template::Tags::Entry::_hdlr_entry_blog_url',
            EntryEditLink          => '$Core::MT::Template::Tags::Entry::_hdlr_entry_edit_link',
            BlogEntryCount         => '$Core::MT::Template::Tags::Entry::_hdlr_blog_entry_count',

            ## Comment
            CommentID                 => '$Core::MT::Template::Tags::Comment::_hdlr_comment_id',
            CommentBlogID             => '$Core::MT::Template::Tags::Comment::_hdlr_comment_blog_id',
            CommentEntryID            => '$Core::MT::Template::Tags::Comment::_hdlr_comment_entry_id',
            CommentName               => '$Core::MT::Template::Tags::Comment::_hdlr_comment_author',
            CommentIP                 => '$Core::MT::Template::Tags::Comment::_hdlr_comment_ip',
            CommentAuthor             => '$Core::MT::Template::Tags::Comment::_hdlr_comment_author',
            CommentAuthorLink         => '$Core::MT::Template::Tags::Comment::_hdlr_comment_author_link',
            CommentAuthorIdentity     => '$Core::MT::Template::Tags::Comment::_hdlr_comment_author_identity',
            CommentEmail              => '$Core::MT::Template::Tags::Comment::_hdlr_comment_email',
            CommentLink               => '$Core::MT::Template::Tags::Comment::_hdlr_comment_link',
            CommentURL                => '$Core::MT::Template::Tags::Comment::_hdlr_comment_url',
            CommentBody               => '$Core::MT::Template::Tags::Comment::_hdlr_comment_body',
            CommentOrderNumber        => '$Core::MT::Template::Tags::Comment::_hdlr_comment_order_num',
            CommentDate               => '$Core::MT::Template::Tags::Comment::_hdlr_comment_date',
            CommentParentID           => '$Core::MT::Template::Tags::Comment::_hdlr_comment_parent_id',
            CommentReplyToLink        => '$Core::MT::Template::Tags::Comment::_hdlr_comment_reply_link',
            CommentPreviewAuthor      => '$Core::MT::Template::Tags::Comment::_hdlr_comment_author',
            CommentPreviewIP          => '$Core::MT::Template::Tags::Comment::_hdlr_comment_ip',
            CommentPreviewAuthorLink  => '$Core::MT::Template::Tags::Comment::_hdlr_comment_author_link',
            CommentPreviewEmail       => '$Core::MT::Template::Tags::Comment::_hdlr_comment_email',
            CommentPreviewURL         => '$Core::MT::Template::Tags::Comment::_hdlr_comment_url',
            CommentPreviewBody        => '$Core::MT::Template::Tags::Comment::_hdlr_comment_body',
            CommentPreviewDate        => \&build_date,
            CommentPreviewState       => '$Core::MT::Template::Tags::Comment::_hdlr_comment_prev_state',
            CommentPreviewIsStatic    => '$Core::MT::Template::Tags::Comment::_hdlr_comment_prev_static',
            CommentRepliesRecurse     => '$Core::MT::Template::Tags::Comment::_hdlr_comment_replies_recurse',
            BlogCommentCount          => '$Core::MT::Template::Tags::Comment::_hdlr_blog_comment_count',
            WebsiteCommentCount       => '$Core::MT::Template::Tags::Comment::_hdlr_blog_comment_count',
            EntryCommentCount         => '$Core::MT::Template::Tags::Comment::_hdlr_entry_comments',
            CategoryCommentCount      => '$Core::MT::Template::Tags::Comment::_hdlr_category_comment_count',
            TypeKeyToken              => '$Core::MT::Template::Tags::Comment::_hdlr_typekey_token',
            CommentFields             => '$Core::MT::Template::Tags::Comment::_hdlr_comment_fields',
            RemoteSignOutLink         => '$Core::MT::Template::Tags::Comment::_hdlr_remote_sign_out_link',
            RemoteSignInLink          => '$Core::MT::Template::Tags::Comment::_hdlr_remote_sign_in_link',
            SignOutLink               => '$Core::MT::Template::Tags::Comment::_hdlr_sign_out_link',
            SignInLink                => '$Core::MT::Template::Tags::Comment::_hdlr_sign_in_link',
            SignOnURL                 => '$Core::MT::Template::Tags::Comment::_hdlr_signon_url',

            ## Ping', => {
            PingsSentURL           => '$Core::MT::Template::Tags::Ping::_hdlr_pings_sent_url',
            PingTitle              => '$Core::MT::Template::Tags::Ping::_hdlr_ping_title',
            PingID                 => '$Core::MT::Template::Tags::Ping::_hdlr_ping_id',
            PingURL                => '$Core::MT::Template::Tags::Ping::_hdlr_ping_url',
            PingExcerpt            => '$Core::MT::Template::Tags::Ping::_hdlr_ping_excerpt',
            PingBlogName           => '$Core::MT::Template::Tags::Ping::_hdlr_ping_blog_name',
            PingIP                 => '$Core::MT::Template::Tags::Ping::_hdlr_ping_ip',
            PingDate               => '$Core::MT::Template::Tags::Ping::_hdlr_ping_date',
            BlogPingCount          => '$Core::MT::Template::Tags::Ping::_hdlr_blog_ping_count',
            WebsitePingCount       => '$Core::MT::Template::Tags::Ping::_hdlr_blog_ping_count',
            EntryTrackbackCount    => '$Core::MT::Template::Tags::Ping::_hdlr_entry_ping_count',
            EntryTrackbackLink     => '$Core::MT::Template::Tags::Ping::_hdlr_entry_tb_link',
            EntryTrackbackData     => '$Core::MT::Template::Tags::Ping::_hdlr_entry_tb_data',
            EntryTrackbackID       => '$Core::MT::Template::Tags::Ping::_hdlr_entry_tb_id',
            CategoryTrackbackLink  => '$Core::MT::Template::Tags::Ping::_hdlr_category_tb_link',
            CategoryTrackbackCount => '$Core::MT::Template::Tags::Ping::_hdlr_category_tb_count',

            ## Category
            CategoryID          => '$Core::MT::Template::Tags::Category::_hdlr_category_id',
            CategoryLabel       => '$Core::MT::Template::Tags::Category::_hdlr_category_label',
            CategoryBasename    => '$Core::MT::Template::Tags::Category::_hdlr_category_basename',
            CategoryDescription => '$Core::MT::Template::Tags::Category::_hdlr_category_desc',
            CategoryArchiveLink => '$Core::MT::Template::Tags::Category::_hdlr_category_archive',
            CategoryCount       => '$Core::MT::Template::Tags::Category::_hdlr_category_count',
            SubCatsRecurse      => '$Core::MT::Template::Tags::Category::_hdlr_sub_cats_recurse',
            SubCategoryPath     => '$Core::MT::Template::Tags::Category::_hdlr_sub_category_path',
            BlogCategoryCount   => '$Core::MT::Template::Tags::Category::_hdlr_blog_category_count',
            ArchiveCategory     => '$Core::MT::Template::Tags::Category::_hdlr_archive_category',
            EntryCategory       => '$Core::MT::Template::Tags::Category::_hdlr_entry_category',

            ## Page
            PageID                => '$Core::MT::Template::Tags::Page::_hdlr_page_id',
            PageTitle             => '$Core::MT::Template::Tags::Page::_hdlr_page_title',
            PageBody              => '$Core::MT::Template::Tags::Page::_hdlr_page_body', 
            PageMore              => '$Core::MT::Template::Tags::Page::_hdlr_page_more',
            PageDate              => '$Core::MT::Template::Tags::Page::_hdlr_page_date',
            PageModifiedDate      => '$Core::MT::Template::Tags::Page::_hdlr_page_modified_date',
            PageKeywords          => '$Core::MT::Template::Tags::Page::_hdlr_page_keywords',
            PageBasename          => '$Core::MT::Template::Tags::Page::_hdlr_page_basename',
            PagePermalink         => '$Core::MT::Template::Tags::Page::_hdlr_page_permalink',
            PageAuthorDisplayName => '$Core::MT::Template::Tags::Page::_hdlr_page_author_display_name',
            PageAuthorEmail       => '$Core::MT::Template::Tags::Page::_hdlr_page_author_email',
            PageAuthorLink        => '$Core::MT::Template::Tags::Page::_hdlr_page_author_link',
            PageAuthorURL         => '$Core::MT::Template::Tags::Page::_hdlr_page_author_url',
            PageExcerpt           => '$Core::MT::Template::Tags::Page::_hdlr_page_excerpt',
            BlogPageCount         => '$Core::MT::Template::Tags::Page::_hdlr_blog_page_count',
            WebsitePageCount      => '$Core::MT::Template::Tags::Page::_hdlr_blog_page_count',

            ## Folder
            FolderBasename    => '$Core::MT::Template::Tags::Folder::_hdlr_folder_basename',
            FolderCount       => '$Core::MT::Template::Tags::Folder::_hdlr_folder_count',
            FolderDescription => '$Core::MT::Template::Tags::Folder::_hdlr_folder_description',
            FolderID          => '$Core::MT::Template::Tags::Folder::_hdlr_folder_id',
            FolderLabel       => '$Core::MT::Template::Tags::Folder::_hdlr_folder_label',
            FolderPath        => '$Core::MT::Template::Tags::Folder::_hdlr_folder_path',
            SubFolderRecurse  => '$Core::MT::Template::Tags::Folder::_hdlr_sub_folder_recurse',

            ## Asset
            AssetID            => '$Core::MT::Template::Tags::Asset::_hdlr_asset_id',
            AssetFileName      => '$Core::MT::Template::Tags::Asset::_hdlr_asset_file_name',
            AssetLabel         => '$Core::MT::Template::Tags::Asset::_hdlr_asset_label',
            AssetURL           => '$Core::MT::Template::Tags::Asset::_hdlr_asset_url',
            AssetType          => '$Core::MT::Template::Tags::Asset::_hdlr_asset_type',
            AssetMimeType      => '$Core::MT::Template::Tags::Asset::_hdlr_asset_mime_type',
            AssetFilePath      => '$Core::MT::Template::Tags::Asset::_hdlr_asset_file_path',
            AssetDateAdded     => '$Core::MT::Template::Tags::Asset::_hdlr_asset_date_added',
            AssetAddedBy       => '$Core::MT::Template::Tags::Asset::_hdlr_asset_added_by',
            AssetProperty      => '$Core::MT::Template::Tags::Asset::_hdlr_asset_property',
            AssetFileExt       => '$Core::MT::Template::Tags::Asset::_hdlr_asset_file_ext',
            AssetThumbnailURL  => '$Core::MT::Template::Tags::Asset::_hdlr_asset_thumbnail_url',
            AssetLink          => '$Core::MT::Template::Tags::Asset::_hdlr_asset_link',
            AssetThumbnailLink => '$Core::MT::Template::Tags::Asset::_hdlr_asset_thumbnail_link',
            AssetDescription   => '$Core::MT::Template::Tags::Asset::_hdlr_asset_description',
            AssetCount         => '$Core::MT::Template::Tags::Asset::_hdlr_asset_count',

            ## Userpic
            AuthorUserpic         => '$Core::MT::Template::Tags::Userpic::_hdlr_author_userpic',
            AuthorUserpicURL      => '$Core::MT::Template::Tags::Userpic::_hdlr_author_userpic_url',
            EntryAuthorUserpic    => '$Core::MT::Template::Tags::Userpic::_hdlr_entry_author_userpic',
            EntryAuthorUserpicURL => '$Core::MT::Template::Tags::Userpic::_hdlr_entry_author_userpic_url',
            CommenterUserpic      => '$Core::MT::Template::Tags::Userpic::_hdlr_commenter_userpic',
            CommenterUserpicURL   => '$Core::MT::Template::Tags::Userpic::_hdlr_commenter_userpic_url',

            ## Tag
            TagName       => '$Core::MT::Template::Tags::Tag::_hdlr_tag_name',
            TagLabel      => '$Core::MT::Template::Tags::Tag::_hdlr_tag_name',
            TagID         => '$Core::MT::Template::Tags::Tag::_hdlr_tag_id',
            TagCount      => '$Core::MT::Template::Tags::Tag::_hdlr_tag_count',
            TagRank       => '$Core::MT::Template::Tags::Tag::_hdlr_tag_rank',
            TagSearchLink => '$Core::MT::Template::Tags::Tag::_hdlr_tag_search_link',

            ## Calendar
            CalendarDay        => '$Core::MT::Template::Tags::Calendar::_hdlr_calendar_day',
            CalendarCellNumber => '$Core::MT::Template::Tags::Calendar::_hdlr_calendar_cell_num',
            CalendarDate       => \&build_date,

            ## Score
            # Rating related handlers
            EntryScore   => '$Core::MT::Template::Tags::Score::_hdlr_entry_score',
            CommentScore => '$Core::MT::Template::Tags::Score::_hdlr_comment_score',
            PingScore    => '$Core::MT::Template::Tags::Score::_hdlr_ping_score',
            AssetScore   => '$Core::MT::Template::Tags::Score::_hdlr_asset_score',
            AuthorScore  => '$Core::MT::Template::Tags::Score::_hdlr_author_score',

            EntryScoreHigh   => '$Core::MT::Template::Tags::Score::_hdlr_entry_score_high',
            CommentScoreHigh => '$Core::MT::Template::Tags::Score::_hdlr_comment_score_high',
            PingScoreHigh    => '$Core::MT::Template::Tags::Score::_hdlr_ping_score_high',
            AssetScoreHigh   => '$Core::MT::Template::Tags::Score::_hdlr_asset_score_high',
            AuthorScoreHigh  => '$Core::MT::Template::Tags::Score::_hdlr_author_score_high',

            EntryScoreLow   => '$Core::MT::Template::Tags::Score::_hdlr_entry_score_low',
            CommentScoreLow => '$Core::MT::Template::Tags::Score::_hdlr_comment_score_low',
            PingScoreLow    => '$Core::MT::Template::Tags::Score::_hdlr_ping_score_low',
            AssetScoreLow   => '$Core::MT::Template::Tags::Score::_hdlr_asset_score_low',
            AuthorScoreLow  => '$Core::MT::Template::Tags::Score::_hdlr_author_score_low',

            EntryScoreAvg   => '$Core::MT::Template::Tags::Score::_hdlr_entry_score_avg',
            CommentScoreAvg => '$Core::MT::Template::Tags::Score::_hdlr_comment_score_avg',
            PingScoreAvg    => '$Core::MT::Template::Tags::Score::_hdlr_ping_score_avg',
            AssetScoreAvg   => '$Core::MT::Template::Tags::Score::_hdlr_asset_score_avg',
            AuthorScoreAvg  => '$Core::MT::Template::Tags::Score::_hdlr_author_score_avg',

            EntryScoreCount   => '$Core::MT::Template::Tags::Score::_hdlr_entry_score_count',
            CommentScoreCount => '$Core::MT::Template::Tags::Score::_hdlr_comment_score_count',
            PingScoreCount    => '$Core::MT::Template::Tags::Score::_hdlr_ping_score_count',
            AssetScoreCount   => '$Core::MT::Template::Tags::Score::_hdlr_asset_score_count',
            AuthorScoreCount  => '$Core::MT::Template::Tags::Score::_hdlr_author_score_count',

            EntryRank   => '$Core::MT::Template::Tags::Score::_hdlr_entry_rank',
            CommentRank => '$Core::MT::Template::Tags::Score::_hdlr_comment_rank',
            PingRank    => '$Core::MT::Template::Tags::Score::_hdlr_ping_rank',
            AssetRank   => '$Core::MT::Template::Tags::Score::_hdlr_asset_rank',
            AuthorRank  => '$Core::MT::Template::Tags::Score::_hdlr_author_rank',

            ## Pager
            PagerLink    => '$Core::MT::Template::Tags::Pager::_hdlr_pager_link',
            NextLink     => '$Core::MT::Template::Tags::Pager::_hdlr_next_link',
            PreviousLink => '$Core::MT::Template::Tags::Pager::_hdlr_previous_link',
            CurrentPage  => '$Core::MT::Template::Tags::Pager::_hdlr_current_page',
            TotalPages   => '$Core::MT::Template::Tags::Pager::_hdlr_total_pages',

            ## Search
            # stubs for mt-search tags used in template includes
            SearchString       => sub { '' },
            SearchResultCount  => sub { 0 }, 
            MaxResults         => sub { '' },
            SearchMaxResults   => '$Core::MT::Template::Tags::Search::_hdlr_search_max_results',
            SearchIncludeBlogs => sub { '' },
            SearchTemplateID   => sub { 0 },

            ## Misc
            FeedbackScore => '$Core::MT::Template::Tags::Misc::_hdlr_feedback_score',
            ImageURL      => '$Core::MT::Template::Tags::Misc::_hdlr_image_url',
            ImageWidth    => '$Core::MT::Template::Tags::Misc::_hdlr_image_width',
            ImageHeight   => '$Core::MT::Template::Tags::Misc::_hdlr_image_height',
            WidgetManager => '$Core::MT::Template::Tags::Misc::_hdlr_widget_manager',
            WidgetSet     => '$Core::MT::Template::Tags::Misc::_hdlr_widget_manager',
            CaptchaFields => '$Core::MT::Template::Tags::Misc::_hdlr_captcha_fields',
        },
        modifier => {
            'numify'           => '$Core::MT::Template::Tags::Filters::_fltr_numify',
            'mteval'           => '$Core::MT::Template::Tags::Filters::_fltr_mteval',
            'filters'          => '$Core::MT::Template::Tags::Filters::_fltr_filters',
            'trim_to'          => '$Core::MT::Template::Tags::Filters::_fltr_trim_to',
            'trim'             => '$Core::MT::Template::Tags::Filters::_fltr_trim',
            'ltrim'            => '$Core::MT::Template::Tags::Filters::_fltr_ltrim',
            'rtrim'            => '$Core::MT::Template::Tags::Filters::_fltr_rtrim',
            'decode_html'      => '$Core::MT::Template::Tags::Filters::_fltr_decode_html',
            'decode_xml'       => '$Core::MT::Template::Tags::Filters::_fltr_decode_xml',
            'remove_html'      => '$Core::MT::Template::Tags::Filters::_fltr_remove_html',
            'dirify'           => '$Core::MT::Template::Tags::Filters::_fltr_dirify',
            'sanitize'         => '$Core::MT::Template::Tags::Filters::_fltr_sanitize',
            'encode_sha1'      => '$Core::MT::Template::Tags::Filters::_fltr_sha1',
            'encode_html'      => '$Core::MT::Template::Tags::Filters::_fltr_encode_html',
            'encode_xml'       => '$Core::MT::Template::Tags::Filters::_fltr_encode_xml',
            'encode_js'        => '$Core::MT::Template::Tags::Filters::_fltr_encode_js',
            'encode_php'       => '$Core::MT::Template::Tags::Filters::_fltr_encode_php',
            'encode_url'       => '$Core::MT::Template::Tags::Filters::_fltr_encode_url',
            'upper_case'       => '$Core::MT::Template::Tags::Filters::_fltr_upper_case',
            'lower_case'       => '$Core::MT::Template::Tags::Filters::_fltr_lower_case',
            'strip_linefeeds'  => '$Core::MT::Template::Tags::Filters::_fltr_strip_linefeeds',
            'space_pad'        => '$Core::MT::Template::Tags::Filters::_fltr_space_pad',
            'zero_pad'         => '$Core::MT::Template::Tags::Filters::_fltr_zero_pad',
            'sprintf'          => '$Core::MT::Template::Tags::Filters::_fltr_sprintf',
            'regex_replace'    => '$Core::MT::Template::Tags::Filters::_fltr_regex_replace',
            'capitalize'       => '$Core::MT::Template::Tags::Filters::_fltr_capitalize',
            'count_characters' => '$Core::MT::Template::Tags::Filters::_fltr_count_characters',
            'cat'              => '$Core::MT::Template::Tags::Filters::_fltr_cat',
            'count_paragraphs' => '$Core::MT::Template::Tags::Filters::_fltr_count_paragraphs',
            'count_words'      => '$Core::MT::Template::Tags::Filters::_fltr_count_words',
            'escape'           => '$Core::MT::Template::Tags::Filters::_fltr_escape',
            'indent'           => '$Core::MT::Template::Tags::Filters::_fltr_indent',
            'nl2br'            => '$Core::MT::Template::Tags::Filters::_fltr_nl2br',
            'replace'          => '$Core::MT::Template::Tags::Filters::_fltr_replace',
            'spacify'          => '$Core::MT::Template::Tags::Filters::_fltr_spacify',
            'string_format'    => '$Core::MT::Template::Tags::Filters::_fltr_sprintf',
            'strip'            => '$Core::MT::Template::Tags::Filters::_fltr_strip',
            'strip_tags'       => '$Core::MT::Template::Tags::Filters::_fltr_strip_tags',
            '_default'         => '$Core::MT::Template::Tags::Filters::_fltr_default',
            'nofollowfy'       => '$Core::MT::Template::Tags::Filters::_fltr_nofollowfy',
            'wrap_text'        => '$Core::MT::Template::Tags::Filters::_fltr_wrap_text',
            'setvar'           => '$Core::MT::Template::Tags::Filters::_fltr_setvar',
        },
    };
    return $tags;
}

## used in both Comment.pm and Ping.pm
sub sanitize_on {
    my ($ctx, $args) = @_;
    ## backward compatibility. in MT4, this didn't take $ctx.
    if (!UNIVERSAL::isa( $ctx, 'MT::Template::Context' ) ) {
        $args = $ctx;
    }
    unless ( exists $args->{'sanitize'} ) {
        # Important to come before other manipulation attributes
        # like encode_xml
        unshift @{$args->{'@'} ||= []}, ['sanitize' => 1];
        $args->{'sanitize'} = 1;
    }
}

## used in Ping.pm
sub nofollowfy_on {
    my ($ctx) = @_;
    unless ( exists $ctx->{'nofollowfy'} ) {
        $ctx->{'nofollowfy'} = 1;
    }
}

## used in both Category.pm and Entry.pm.
sub cat_path_to_category {
    ## for backward compatibility.
    shift if UNIVERSAL::isa($_[0], 'MT::Template::Context');
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

## for backward compatibility
sub _hdlr_pass_tokens { shift->slurp(@_) }
sub _hdlr_pass_tokens_else { shift->else(@_) }

sub build_date {
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

*_hdlr_date = *build_date;

sub cgi_path {
    my ($ctx) = @_;
    my $path = $ctx->{config}->CGIPath;
    if ($path =~ m!^/!) {
        # relative path, prepend blog domain
        if (my $blog = $ctx->stash('blog')) {
            my ($blog_domain) = $blog->archive_url =~ m|(.+://[^/]+)|;
            $path = $blog_domain . $path;
        }
    }
    $path .= '/' unless $path =~ m{/$};
    return $path;
}

sub check_page {
    my ($ctx) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_page_error();
    return $ctx->_no_page_error()
        if ref $e ne 'MT::Page';
    1;
}
*_check_page = *check_page;

1;

__END__
