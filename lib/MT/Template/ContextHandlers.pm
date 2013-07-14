# Movable Type (r) Open Source (C) 2001-2013 Six Apart Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Template::Context;

use strict;

use MT::Util qw( format_ts relative_date );
use Time::Local qw( timelocal );

sub init_default_handlers { }
sub init_default_filters  { }

sub core_tags {
    my $tags = {
        help_url => sub {
            MT->translate(
                'http://www.movabletype.org/documentation/appendices/tags/%t.html'
            );
        },
        block => {

            ## Core
            Ignore    => sub {''},
            'If?'     => \&MT::Template::Tags::Core::_hdlr_if,
            'Unless?' => \&MT::Template::Tags::Core::_hdlr_unless,
            'Else'    => \&MT::Template::Tags::Core::_hdlr_else,
            'ElseIf'  => \&MT::Template::Tags::Core::_hdlr_elseif,
            'IfNonEmpty?'  => \&MT::Template::Tags::Core::_hdlr_if_nonempty,
            'IfNonZero?'   => \&MT::Template::Tags::Core::_hdlr_if_nonzero,
            Loop           => \&MT::Template::Tags::Core::_hdlr_loop,
            'For'          => \&MT::Template::Tags::Core::_hdlr_for,
            SetVarBlock    => \&MT::Template::Tags::Core::_hdlr_set_var,
            SetVarTemplate => \&MT::Template::Tags::Core::_hdlr_set_var,
            SetVars        => \&MT::Template::Tags::Core::_hdlr_set_vars,
            SetHashVar     => \&MT::Template::Tags::Core::_hdlr_set_hashvar,

            ## System
            IncludeBlock => \&MT::Template::Tags::System::_hdlr_include_block,
            IfStatic     => \&slurp,
            IfDynamic    => \&else,
            Section      => \&MT::Template::Tags::System::_hdlr_section,

            ## App
            'App:Setting'   => \&MT::Template::Tags::App::_hdlr_app_setting,
            'App:Widget'    => \&MT::Template::Tags::App::_hdlr_app_widget,
            'App:StatusMsg' => \&MT::Template::Tags::App::_hdlr_app_statusmsg,
            'App:Listing'   => \&MT::Template::Tags::App::_hdlr_app_listing,
            'App:SettingGroup' =>
                \&MT::Template::Tags::App::_hdlr_app_setting_group,
            'App:Form' => \&MT::Template::Tags::App::_hdlr_app_form,

            ## Blog
            Blogs     => '$Core::MT::Template::Tags::Blog::_hdlr_blogs',
            'IfBlog?' => '$Core::MT::Template::Tags::Blog::_hdlr_if_blog',
            'BlogIfCCLicense?' =>
                '$Core::MT::Template::Tags::Blog::_hdlr_blog_if_cc_license',

            ## Website
            Websites => '$Core::MT::Template::Tags::Website::_hdlr_websites',
            'IfWebsite?' =>
                '$Core::MT::Template::Tags::Website::_hdlr_website_id',
            'WebsiteIfCCLicense?' =>
                '$Core::MT::Template::Tags::Website::_hdlr_website_if_cc_license',
            'WebsiteHasBlog?' =>
                '$Core::MT::Template::Tags::Website::_hdlr_website_has_blog',
            BlogParentWebsite =>
                '$Core::MT::Template::Tags::Website::_hdlr_blog_parent_website',

            ## Author
            Authors => '$Core::MT::Template::Tags::Author::_hdlr_authors',
            AuthorNext =>
                '$Core::MT::Template::Tags::Author::_hdlr_author_next_prev',
            AuthorPrevious =>
                '$Core::MT::Template::Tags::Author::_hdlr_author_next_prev',
            'IfAuthor?' =>
                '$Core::MT::Template::Tags::Author::_hdlr_if_author',

            ## Commenter
            'IfExternalUserManagement?' =>
                '$Core::MT::Template::Tags::Commenter::_hdlr_if_external_user_management',
            'IfCommenterRegistrationAllowed?' =>
                '$Core::MT::Template::Tags::Commenter::_hdlr_if_commenter_registration_allowed',
            'IfCommenterTrusted?' =>
                '$Core::MT::Template::Tags::Commenter::_hdlr_commenter_trusted',
            'CommenterIfTrusted?' =>
                '$Core::MT::Template::Tags::Commenter::_hdlr_commenter_trusted',
            'IfCommenterIsAuthor?' =>
                '$Core::MT::Template::Tags::Commenter::_hdlr_commenter_isauthor',
            'IfCommenterIsEntryAuthor?' =>
                '$Core::MT::Template::Tags::Commenter::_hdlr_commenter_isauthor',

            ## Archive
            Archives =>
                '$Core::MT::Template::Tags::Archive::_hdlr_archive_set',
            ArchiveList =>
                '$Core::MT::Template::Tags::Archive::_hdlr_archives',
            ArchiveListHeader => \&slurp,
            ArchiveListFooter => \&slurp,
            ArchivePrevious =>
                '$Core::MT::Template::Tags::Archive::_hdlr_archive_prev_next',
            ArchiveNext =>
                '$Core::MT::Template::Tags::Archive::_hdlr_archive_prev_next',
            'IfArchiveType?' =>
                '$Core::MT::Template::Tags::Archive::_hdlr_if_archive_type',
            'IfArchiveTypeEnabled?' =>
                '$Core::MT::Template::Tags::Archive::_hdlr_archive_type_enabled',
            IndexList =>
                '$Core::MT::Template::Tags::Archive::_hdlr_index_list',

            ## Entry
            Entries => '$Core::MT::Template::Tags::Entry::_hdlr_entries',
            EntriesHeader => \&slurp,
            EntriesFooter => \&slurp,
            EntryPrevious =>
                '$Core::MT::Template::Tags::Entry::_hdlr_entry_previous',
            EntryNext => '$Core::MT::Template::Tags::Entry::_hdlr_entry_next',
            DateHeader => \&slurp,
            DateFooter => \&slurp,
            'EntryIfExtended?' =>
                '$Core::MT::Template::Tags::Entry::_hdlr_entry_if_extended',
            'AuthorHasEntry?' =>
                '$Core::MT::Template::Tags::Entry::_hdlr_author_has_entry',

            ## Comment
            'IfCommentsModerated?' =>
                '$Core::MT::Template::Tags::Comment::_hdlr_comments_moderated',
            'BlogIfCommentsOpen?' =>
                '$Core::MT::Template::Tags::Comment::_hdlr_blog_if_comments_open',
            'WebsiteIfCommentsOpen?' =>
                '$Core::MT::Template::Tags::Comment::_hdlr_blog_if_comments_open',
            Comments => '$Core::MT::Template::Tags::Comment::_hdlr_comments',
            CommentsHeader => \&slurp,
            CommentsFooter => \&slurp,
            CommentEntry =>
                '$Core::MT::Template::Tags::Comment::_hdlr_comment_entry',
            'CommentIfModerated?' =>
                '$Core::MT::Template::Tags::Comment::_hdlr_comment_if_moderated',
            CommentParent =>
                '$Core::MT::Template::Tags::Comment::_hdlr_comment_parent',
            CommentReplies =>
                '$Core::MT::Template::Tags::Comment::_hdlr_comment_replies',
            'IfCommentParent?' =>
                '$Core::MT::Template::Tags::Comment::_hdlr_if_comment_parent',
            'IfCommentReplies?' =>
                '$Core::MT::Template::Tags::Comment::_hdlr_if_comment_replies',
            'IfRegistrationRequired?' =>
                '$Core::MT::Template::Tags::Comment::_hdlr_reg_required',
            'IfRegistrationNotRequired?' =>
                '$Core::MT::Template::Tags::Comment::_hdlr_reg_not_required',
            'IfRegistrationAllowed?' =>
                '$Core::MT::Template::Tags::Comment::_hdlr_reg_allowed',
            'IfTypeKeyToken?' =>
                '$Core::MT::Template::Tags::Comment::_hdlr_if_typekey_token',
            'IfAllowCommentHTML?' =>
                '$Core::MT::Template::Tags::Comment::_hdlr_if_allow_comment_html',
            'IfCommentsAllowed?' =>
                '$Core::MT::Template::Tags::Comment::_hdlr_if_comments_allowed',
            'IfCommentsAccepted?' =>
                '$Core::MT::Template::Tags::Comment::_hdlr_if_comments_accepted',
            'IfCommentsActive?' =>
                '$Core::MT::Template::Tags::Comment::_hdlr_if_comments_active',
            'IfNeedEmail?' =>
                '$Core::MT::Template::Tags::Comment::_hdlr_if_need_email',
            'IfRequireCommentEmails?' =>
                '$Core::MT::Template::Tags::Comment::_hdlr_if_need_email',
            'EntryIfAllowComments?' =>
                '$Core::MT::Template::Tags::Comment::_hdlr_entry_if_allow_comments',
            'EntryIfCommentsOpen?' =>
                '$Core::MT::Template::Tags::Comment::_hdlr_entry_if_comments_open',

            ## Ping
            Pings       => '$Core::MT::Template::Tags::Ping::_hdlr_pings',
            PingsHeader => \&slurp,
            PingsFooter => \&slurp,
            PingsSent => '$Core::MT::Template::Tags::Ping::_hdlr_pings_sent',
            PingEntry => '$Core::MT::Template::Tags::Ping::_hdlr_ping_entry',
            'IfPingsAllowed?' =>
                '$Core::MT::Template::Tags::Ping::_hdlr_if_pings_allowed',
            'IfPingsAccepted?' =>
                '$Core::MT::Template::Tags::Ping::_hdlr_if_pings_accepted',
            'IfPingsActive?' =>
                '$Core::MT::Template::Tags::Ping::_hdlr_if_pings_active',
            'IfPingsModerated?' =>
                '$Core::MT::Template::Tags::Ping::_hdlr_if_pings_moderated',
            'EntryIfAllowPings?' =>
                '$Core::MT::Template::Tags::Ping::_hdlr_entry_if_allow_pings',
            'CategoryIfAllowPings?' =>
                '$Core::MT::Template::Tags::Ping::_hdlr_category_allow_pings',

            ## Category
            Categories =>
                '$Core::MT::Template::Tags::Category::_hdlr_categories',
            CategoryPrevious =>
                '$Core::MT::Template::Tags::Category::_hdlr_category_prevnext',
            CategoryNext =>
                '$Core::MT::Template::Tags::Category::_hdlr_category_prevnext',
            SubCategories =>
                '$Core::MT::Template::Tags::Category::_hdlr_sub_categories',
            TopLevelCategories =>
                '$Core::MT::Template::Tags::Category::_hdlr_top_level_categories',
            ParentCategory =>
                '$Core::MT::Template::Tags::Category::_hdlr_parent_category',
            ParentCategories =>
                '$Core::MT::Template::Tags::Category::_hdlr_parent_categories',
            TopLevelParent =>
                '$Core::MT::Template::Tags::Category::_hdlr_top_level_parent',
            EntriesWithSubCategories =>
                '$Core::MT::Template::Tags::Category::_hdlr_entries_with_sub_categories',
            'IfCategory?' =>
                '$Core::MT::Template::Tags::Category::_hdlr_if_category',
            'EntryIfCategory?' =>
                '$Core::MT::Template::Tags::Category::_hdlr_if_category',
            'SubCatIsFirst?' =>
                '$Core::MT::Template::Tags::Category::_hdlr_sub_cat_is_first',
            'SubCatIsLast?' =>
                '$Core::MT::Template::Tags::Category::_hdlr_sub_cat_is_last',
            'HasSubCategories?' =>
                '$Core::MT::Template::Tags::Category::_hdlr_has_sub_categories',
            'HasNoSubCategories?' =>
                '$Core::MT::Template::Tags::Category::_hdlr_has_no_sub_categories',
            'HasParentCategory?' =>
                '$Core::MT::Template::Tags::Category::_hdlr_has_parent_category',
            'HasNoParentCategory?' =>
                '$Core::MT::Template::Tags::Category::_hdlr_has_no_parent_category',
            'IfIsAncestor?' =>
                '$Core::MT::Template::Tags::Category::_hdlr_is_ancestor',
            'IfIsDescendant?' =>
                '$Core::MT::Template::Tags::Category::_hdlr_is_descendant',
            EntryCategories =>
                '$Core::MT::Template::Tags::Category::_hdlr_entry_categories',
            EntryPrimaryCategory =>
                '$Core::MT::Template::Tags::Category::_hdlr_entry_primary_category',
            EntryAdditionalCategories =>
                '$Core::MT::Template::Tags::Category::_hdlr_entry_additional_categories',

            ## Page
            'AuthorHasPage?' =>
                '$Core::MT::Template::Tags::Page::_hdlr_author_has_page',
            Pages => '$Core::MT::Template::Tags::Page::_hdlr_pages',
            PagePrevious =>
                '$Core::MT::Template::Tags::Page::_hdlr_page_previous',
            PageNext    => '$Core::MT::Template::Tags::Page::_hdlr_page_next',
            PagesHeader => \&slurp,
            PagesFooter => \&slurp,

            ## Folder
            'IfFolder?' =>
                '$Core::MT::Template::Tags::Folder::_hdlr_if_folder',
            'FolderHeader?' =>
                '$Core::MT::Template::Tags::Folder::_hdlr_folder_header',
            'FolderFooter?' =>
                '$Core::MT::Template::Tags::Folder::_hdlr_folder_footer',
            'HasSubFolders?' =>
                '$Core::MT::Template::Tags::Folder::_hdlr_has_sub_folders',
            'HasParentFolder?' =>
                '$Core::MT::Template::Tags::Folder::_hdlr_has_parent_folder',
            PageFolder =>
                '$Core::MT::Template::Tags::Folder::_hdlr_page_folder',
            Folders => '$Core::MT::Template::Tags::Folder::_hdlr_folders',
            FolderPrevious =>
                '$Core::MT::Template::Tags::Folder::_hdlr_folder_prevnext',
            FolderNext =>
                '$Core::MT::Template::Tags::Folder::_hdlr_folder_prevnext',
            SubFolders =>
                '$Core::MT::Template::Tags::Folder::_hdlr_sub_folders',
            ParentFolders =>
                '$Core::MT::Template::Tags::Folder::_hdlr_parent_folders',
            ParentFolder =>
                '$Core::MT::Template::Tags::Folder::_hdlr_parent_folder',
            TopLevelFolders =>
                '$Core::MT::Template::Tags::Folder::_hdlr_top_level_folders',
            TopLevelFolder =>
                '$Core::MT::Template::Tags::Folder::_hdlr_top_level_folder',

            ## Asset
            EntryAssets => '$Core::MT::Template::Tags::Asset::_hdlr_assets',
            PageAssets  => '$Core::MT::Template::Tags::Asset::_hdlr_assets',
            Assets      => '$Core::MT::Template::Tags::Asset::_hdlr_assets',
            Asset       => '$Core::MT::Template::Tags::Asset::_hdlr_asset',
            AssetIsFirstInRow => \&slurp,
            AssetIsLastInRow  => \&slurp,
            AssetsHeader      => \&slurp,
            AssetsFooter      => \&slurp,

            ## Userpic
            AuthorUserpicAsset =>
                '$Core::MT::Template::Tags::Userpic::_hdlr_author_userpic_asset',
            EntryAuthorUserpicAsset =>
                '$Core::MT::Template::Tags::Userpic::_hdlr_entry_author_userpic_asset',
            CommenterUserpicAsset =>
                '$Core::MT::Template::Tags::Userpic::_hdlr_commenter_userpic_asset',

            ## Tag
            Tags      => '$Core::MT::Template::Tags::Tag::_hdlr_tags',
            EntryTags => '$Core::MT::Template::Tags::Tag::_hdlr_entry_tags',
            PageTags  => '$Core::MT::Template::Tags::Tag::_hdlr_page_tags',
            AssetTags => '$Core::MT::Template::Tags::Tag::_hdlr_asset_tags',
            'EntryIfTagged?' =>
                '$Core::MT::Template::Tags::Tag::_hdlr_entry_if_tagged',
            'PageIfTagged?' =>
                '$Core::MT::Template::Tags::Tag::_hdlr_page_if_tagged',
            'AssetIfTagged?' =>
                '$Core::MT::Template::Tags::Tag::_hdlr_asset_if_tagged',

            ## Calendar
            Calendar => '$Core::MT::Template::Tags::Calendar::_hdlr_calendar',
            CalendarWeekHeader  => \&slurp,
            CalendarWeekFooter  => \&slurp,
            CalendarIfBlank     => \&slurp,
            CalendarIfToday     => \&slurp,
            CalendarIfEntries   => \&slurp,
            CalendarIfNoEntries => \&slurp,

            ## Pager
            'IfMoreResults?' =>
                '$Core::MT::Template::Tags::Pager::_hdlr_if_more_results',
            'IfPreviousResults?' =>
                '$Core::MT::Template::Tags::Pager::_hdlr_if_previous_results',
            PagerBlock =>
                '$Core::MT::Template::Tags::Pager::_hdlr_pager_block',
            IfCurrentPage => \&slurp,

            ## Search
            IfTagSearch         => sub {''},
            SearchResults       => sub {''},
            IfStraightSearch    => sub {''},
            NoSearchResults     => \&slurp,
            NoSearch            => \&slurp,
            SearchResultsHeader => sub {''},
            SearchResultsFooter => sub {''},
            BlogResultHeader    => sub {''},
            BlogResultFooter    => sub {''},
            IfMaxResultsCutoff  => sub {''},

            ## Misc
            'IfImageSupport?' =>
                '$Core::MT::Template::Tags::Misc::_hdlr_if_image_support',
        },
        function => {

            ## Core
            SetVar       => \&MT::Template::Tags::Core::_hdlr_set_var,
            GetVar       => \&MT::Template::Tags::Core::_hdlr_get_var,
            Var          => \&MT::Template::Tags::Core::_hdlr_get_var,
            TemplateNote => sub {''},

            ## System
            Include      => \&MT::Template::Tags::System::_hdlr_include,
            Link         => \&MT::Template::Tags::System::_hdlr_link,
            CanonicalURL => \&MT::Template::Tags::System::_hdlr_canonical_url,
            CanonicalLink =>
                \&MT::Template::Tags::System::_hdlr_canonical_link,
            Date        => \&MT::Template::Tags::System::_hdlr_sys_date,
            AdminScript => \&MT::Template::Tags::System::_hdlr_admin_script,
            CommentScript =>
                \&MT::Template::Tags::System::_hdlr_comment_script,
            TrackbackScript =>
                \&MT::Template::Tags::System::_hdlr_trackback_script,
            SearchScript => \&MT::Template::Tags::System::_hdlr_search_script,
            XMLRPCScript => \&MT::Template::Tags::System::_hdlr_xmlrpc_script,
            AtomScript   => \&MT::Template::Tags::System::_hdlr_atom_script,
            NotifyScript => \&MT::Template::Tags::System::_hdlr_notify_script,
            CGIHost      => \&MT::Template::Tags::System::_hdlr_cgi_host,
            CGIPath      => \&MT::Template::Tags::System::_hdlr_cgi_path,
            AdminCGIPath =>
                \&MT::Template::Tags::System::_hdlr_admin_cgi_path,
            CGIRelativeURL =>
                \&MT::Template::Tags::System::_hdlr_cgi_relative_url,
            CGIServerPath =>
                \&MT::Template::Tags::System::_hdlr_cgi_server_path,
            StaticWebPath => \&MT::Template::Tags::System::_hdlr_static_path,
            StaticFilePath =>
                \&MT::Template::Tags::System::_hdlr_static_file_path,
            SupportDirectoryURL =>
                \&MT::Template::Tags::System::_hdlr_support_directory_url,
            Version     => \&MT::Template::Tags::System::_hdlr_mt_version,
            ProductName => \&MT::Template::Tags::System::_hdlr_product_name,
            PublishCharset =>
                \&MT::Template::Tags::System::_hdlr_publish_charset,
            DefaultLanguage =>
                \&MT::Template::Tags::System::_hdlr_default_language,
            ConfigFile => \&MT::Template::Tags::System::_hdlr_config_file,
            IndexBasename =>
                \&MT::Template::Tags::System::_hdlr_index_basename,
            HTTPContentType =>
                \&MT::Template::Tags::System::_hdlr_http_content_type,
            FileTemplate => \&MT::Template::Tags::System::_hdlr_file_template,
            TemplateCreatedOn =>
                \&MT::Template::Tags::System::_hdlr_template_created_on,
            BuildTemplateID =>
                \&MT::Template::Tags::System::_hdlr_build_template_id,
            ErrorMessage => \&MT::Template::Tags::System::_hdlr_error_message,
            PasswordValidation =>
                \&MT::Template::Tags::System::_hdlr_password_validation_script,
            PasswordValidationRule =>
                \&MT::Template::Tags::System::_hdlr_password_validation_rules,

            ## App

            'App:PageActions' =>
                \&MT::Template::Tags::App::_hdlr_app_page_actions,
            'App:ListFilters' =>
                \&MT::Template::Tags::App::_hdlr_app_list_filters,
            'App:ActionBar' =>
                \&MT::Template::Tags::App::_hdlr_app_action_bar,
            'App:Link' => \&MT::Template::Tags::App::_hdlr_app_link,

            ## Blog
            BlogID   => '$Core::MT::Template::Tags::Blog::_hdlr_blog_id',
            BlogName => '$Core::MT::Template::Tags::Blog::_hdlr_blog_name',
            BlogDescription =>
                '$Core::MT::Template::Tags::Blog::_hdlr_blog_description',
            BlogLanguage =>
                '$Core::MT::Template::Tags::Blog::_hdlr_blog_language',
            BlogDateLanguage =>
                '$Core::MT::Template::Tags::Blog::_hdlr_blog_date_language',
            BlogURL => '$Core::MT::Template::Tags::Blog::_hdlr_blog_url',
            BlogArchiveURL =>
                '$Core::MT::Template::Tags::Blog::_hdlr_blog_archive_url',
            BlogRelativeURL =>
                '$Core::MT::Template::Tags::Blog::_hdlr_blog_relative_url',
            BlogSitePath =>
                '$Core::MT::Template::Tags::Blog::_hdlr_blog_site_path',
            BlogHost => '$Core::MT::Template::Tags::Blog::_hdlr_blog_host',
            BlogTimezone =>
                '$Core::MT::Template::Tags::Blog::_hdlr_blog_timezone',
            BlogCCLicenseURL =>
                '$Core::MT::Template::Tags::Blog::_hdlr_blog_cc_license_url',
            BlogCCLicenseImage =>
                '$Core::MT::Template::Tags::Blog::_hdlr_blog_cc_license_image',
            CCLicenseRDF =>
                '$Core::MT::Template::Tags::Blog::_hdlr_cc_license_rdf',
            BlogFileExtension =>
                '$Core::MT::Template::Tags::Blog::_hdlr_blog_file_extension',
            BlogTemplateSetID =>
                '$Core::MT::Template::Tags::Blog::_hdlr_blog_template_set_id',
            BlogThemeID =>
                '$Core::MT::Template::Tags::Blog::_hdlr_blog_theme_id',

            ## Website
            WebsiteID =>
                '$Core::MT::Template::Tags::Website::_hdlr_website_id',
            WebsiteName =>
                '$Core::MT::Template::Tags::Website::_hdlr_website_name',
            WebsiteDescription =>
                '$Core::MT::Template::Tags::Website::_hdlr_website_description',
            WebsiteLanguage =>
                '$Core::MT::Template::Tags::Website::_hdlr_website_language',
            WebsiteDateLanguage =>
                '$Core::MT::Template::Tags::Website::_hdlr_website_date_language',
            WebsiteURL =>
                '$Core::MT::Template::Tags::Website::_hdlr_website_url',
            WebsitePath =>
                '$Core::MT::Template::Tags::Website::_hdlr_website_path',
            WebsiteTimezone =>
                '$Core::MT::Template::Tags::Website::_hdlr_website_timezone',
            WebsiteCCLicenseURL =>
                '$Core::MT::Template::Tags::Website::_hdlr_website_cc_license_url',
            WebsiteCCLicenseImage =>
                '$Core::MT::Template::Tags::Website::_hdlr_website_cc_license_image',
            WebsiteFileExtension =>
                '$Core::MT::Template::Tags::Website::_hdlr_website_file_extension',
            WebsiteHost =>
                '$Core::MT::Template::Tags::Website::_hdlr_website_host',
            WebsiteRelativeURL =>
                '$Core::MT::Template::Tags::Website::_hdlr_website_relative_url',
            WebsiteThemeID =>
                '$Core::MT::Template::Tags::Website::_hdlr_website_theme_id',

            ## Author
            AuthorID => '$Core::MT::Template::Tags::Author::_hdlr_author_id',
            AuthorName =>
                '$Core::MT::Template::Tags::Author::_hdlr_author_name',
            AuthorDisplayName =>
                '$Core::MT::Template::Tags::Author::_hdlr_author_display_name',
            AuthorEmail =>
                '$Core::MT::Template::Tags::Author::_hdlr_author_email',
            AuthorURL =>
                '$Core::MT::Template::Tags::Author::_hdlr_author_url',
            AuthorAuthType =>
                '$Core::MT::Template::Tags::Author::_hdlr_author_auth_type',
            AuthorAuthIconURL =>
                '$Core::MT::Template::Tags::Author::_hdlr_author_auth_icon_url',
            AuthorBasename =>
                '$Core::MT::Template::Tags::Author::_hdlr_author_basename',
            AuthorCommentCount =>
                '$Core::MT::Summary::Author::_hdlr_author_comment_count',
            AuthorEntriesCount =>
                '$Core::MT::Summary::Author::_hdlr_author_entries_count',

            ## Commenter
            CommenterNameThunk =>
                '$Core::MT::Template::Tags::Commenter::_hdlr_commenter_name_thunk',
            CommenterUsername =>
                '$Core::MT::Template::Tags::Commenter::_hdlr_commenter_username',
            CommenterName =>
                '$Core::MT::Template::Tags::Commenter::_hdlr_commenter_name',
            CommenterEmail =>
                '$Core::MT::Template::Tags::Commenter::_hdlr_commenter_email',
            CommenterAuthType =>
                '$Core::MT::Template::Tags::Commenter::_hdlr_commenter_auth_type',
            CommenterAuthIconURL =>
                '$Core::MT::Template::Tags::Commenter::_hdlr_commenter_auth_icon_url',
            CommenterID =>
                '$Core::MT::Template::Tags::Commenter::_hdlr_commenter_id',
            CommenterURL =>
                '$Core::MT::Template::Tags::Commenter::_hdlr_commenter_url',
            UserSessionState =>
                '$Core::MT::Template::Tags::Commenter::_hdlr_user_session_state',
            UserSessionCookieTimeout =>
                '$Core::MT::Template::Tags::Commenter::_hdlr_user_session_cookie_timeout',
            UserSessionCookieName =>
                '$Core::MT::Template::Tags::Commenter::_hdlr_user_session_cookie_name',
            UserSessionCookiePath =>
                '$Core::MT::Template::Tags::Commenter::_hdlr_user_session_cookie_path',
            UserSessionCookieDomain =>
                '$Core::MT::Template::Tags::Commenter::_hdlr_user_session_cookie_domain',

            ## Archive
            ArchiveLink =>
                '$Core::MT::Template::Tags::Archive::_hdlr_archive_link',
            ArchiveTitle =>
                '$Core::MT::Template::Tags::Archive::_hdlr_archive_title',
            ArchiveType =>
                '$Core::MT::Template::Tags::Archive::_hdlr_archive_type',
            ArchiveTypeLabel =>
                '$Core::MT::Template::Tags::Archive::_hdlr_archive_label',
            ArchiveLabel =>
                '$Core::MT::Template::Tags::Archive::_hdlr_archive_label',
            ArchiveCount =>
                '$Core::MT::Template::Tags::Archive::_hdlr_archive_count',
            ArchiveDate => \&build_date,
            ArchiveDateEnd =>
                '$Core::MT::Template::Tags::Archive::_hdlr_archive_date_end',
            ArchiveFile =>
                '$Core::MT::Template::Tags::Archive::_hdlr_archive_file',
            IndexLink =>
                '$Core::MT::Template::Tags::Archive::_hdlr_index_link',
            IndexName =>
                '$Core::MT::Template::Tags::Archive::_hdlr_index_name',

            ## Entry
            EntriesCount =>
                '$Core::MT::Template::Tags::Entry::_hdlr_entries_count',
            EntryID => '$Core::MT::Template::Tags::Entry::_hdlr_entry_id',
            EntryTitle =>
                '$Core::MT::Template::Tags::Entry::_hdlr_entry_title',
            EntryStatus =>
                '$Core::MT::Template::Tags::Entry::_hdlr_entry_status',
            EntryFlag => '$Core::MT::Template::Tags::Entry::_hdlr_entry_flag',
            EntryBody => '$Core::MT::Template::Tags::Entry::_hdlr_entry_body',
            EntryMore => '$Core::MT::Template::Tags::Entry::_hdlr_entry_more',
            EntryExcerpt =>
                '$Core::MT::Template::Tags::Entry::_hdlr_entry_excerpt',
            EntryKeywords =>
                '$Core::MT::Template::Tags::Entry::_hdlr_entry_keywords',
            EntryLink => '$Core::MT::Template::Tags::Entry::_hdlr_entry_link',
            EntryBasename =>
                '$Core::MT::Template::Tags::Entry::_hdlr_entry_basename',
            EntryAtomID =>
                '$Core::MT::Template::Tags::Entry::_hdlr_entry_atom_id',
            EntryPermalink =>
                '$Core::MT::Template::Tags::Entry::_hdlr_entry_permalink',
            EntryClass =>
                '$Core::MT::Template::Tags::Entry::_hdlr_entry_class',
            EntryClassLabel =>
                '$Core::MT::Template::Tags::Entry::_hdlr_entry_class_label',
            EntryAuthor =>
                '$Core::MT::Template::Tags::Entry::_hdlr_entry_author',
            EntryAuthorDisplayName =>
                '$Core::MT::Template::Tags::Entry::_hdlr_entry_author_display_name',
            EntryAuthorNickname =>
                '$Core::MT::Template::Tags::Entry::_hdlr_entry_author_nick',
            EntryAuthorUsername =>
                '$Core::MT::Template::Tags::Entry::_hdlr_entry_author_username',
            EntryAuthorEmail =>
                '$Core::MT::Template::Tags::Entry::_hdlr_entry_author_email',
            EntryAuthorURL =>
                '$Core::MT::Template::Tags::Entry::_hdlr_entry_author_url',
            EntryAuthorLink =>
                '$Core::MT::Template::Tags::Entry::_hdlr_entry_author_link',
            EntryAuthorID =>
                '$Core::MT::Template::Tags::Entry::_hdlr_entry_author_id',

            AuthorEntryCount =>
                '$Core::MT::Template::Tags::Entry::_hdlr_author_entry_count',
            EntryDate => '$Core::MT::Template::Tags::Entry::_hdlr_entry_date',
            EntryCreatedDate =>
                '$Core::MT::Template::Tags::Entry::_hdlr_entry_create_date',
            EntryModifiedDate =>
                '$Core::MT::Template::Tags::Entry::_hdlr_entry_mod_date',

            EntryBlogID =>
                '$Core::MT::Template::Tags::Entry::_hdlr_entry_blog_id',
            EntryBlogName =>
                '$Core::MT::Template::Tags::Entry::_hdlr_entry_blog_name',
            EntryBlogDescription =>
                '$Core::MT::Template::Tags::Entry::_hdlr_entry_blog_description',
            EntryBlogURL =>
                '$Core::MT::Template::Tags::Entry::_hdlr_entry_blog_url',
            EntryEditLink =>
                '$Core::MT::Template::Tags::Entry::_hdlr_entry_edit_link',
            BlogEntryCount =>
                '$Core::MT::Template::Tags::Entry::_hdlr_blog_entry_count',

            ## Comment
            CommentID =>
                '$Core::MT::Template::Tags::Comment::_hdlr_comment_id',
            CommentBlogID =>
                '$Core::MT::Template::Tags::Comment::_hdlr_comment_blog_id',
            CommentEntryID =>
                '$Core::MT::Template::Tags::Comment::_hdlr_comment_entry_id',
            CommentName =>
                '$Core::MT::Template::Tags::Comment::_hdlr_comment_author',
            CommentIP =>
                '$Core::MT::Template::Tags::Comment::_hdlr_comment_ip',
            CommentAuthor =>
                '$Core::MT::Template::Tags::Comment::_hdlr_comment_author',
            CommentAuthorLink =>
                '$Core::MT::Template::Tags::Comment::_hdlr_comment_author_link',
            CommentAuthorIdentity =>
                '$Core::MT::Template::Tags::Comment::_hdlr_comment_author_identity',
            CommentEmail =>
                '$Core::MT::Template::Tags::Comment::_hdlr_comment_email',
            CommentLink =>
                '$Core::MT::Template::Tags::Comment::_hdlr_comment_link',
            CommentURL =>
                '$Core::MT::Template::Tags::Comment::_hdlr_comment_url',
            CommentBody =>
                '$Core::MT::Template::Tags::Comment::_hdlr_comment_body',
            CommentOrderNumber =>
                '$Core::MT::Template::Tags::Comment::_hdlr_comment_order_num',
            CommentDate =>
                '$Core::MT::Template::Tags::Comment::_hdlr_comment_date',
            CommentParentID =>
                '$Core::MT::Template::Tags::Comment::_hdlr_comment_parent_id',
            CommentReplyToLink =>
                '$Core::MT::Template::Tags::Comment::_hdlr_comment_reply_link',
            CommentPreviewAuthor =>
                '$Core::MT::Template::Tags::Comment::_hdlr_comment_author',
            CommentPreviewIP =>
                '$Core::MT::Template::Tags::Comment::_hdlr_comment_ip',
            CommentPreviewAuthorLink =>
                '$Core::MT::Template::Tags::Comment::_hdlr_comment_author_link',
            CommentPreviewEmail =>
                '$Core::MT::Template::Tags::Comment::_hdlr_comment_email',
            CommentPreviewURL =>
                '$Core::MT::Template::Tags::Comment::_hdlr_comment_url',
            CommentPreviewBody =>
                '$Core::MT::Template::Tags::Comment::_hdlr_comment_body',
            CommentPreviewDate => \&build_date,
            CommentPreviewState =>
                '$Core::MT::Template::Tags::Comment::_hdlr_comment_prev_state',
            CommentPreviewIsStatic =>
                '$Core::MT::Template::Tags::Comment::_hdlr_comment_prev_static',
            CommentRepliesRecurse =>
                '$Core::MT::Template::Tags::Comment::_hdlr_comment_replies_recurse',
            BlogCommentCount =>
                '$Core::MT::Template::Tags::Comment::_hdlr_blog_comment_count',
            WebsiteCommentCount =>
                '$Core::MT::Template::Tags::Comment::_hdlr_blog_comment_count',
            EntryCommentCount =>
                '$Core::MT::Template::Tags::Comment::_hdlr_entry_comments',
            CategoryCommentCount =>
                '$Core::MT::Template::Tags::Comment::_hdlr_category_comment_count',
            TypeKeyToken =>
                '$Core::MT::Template::Tags::Comment::_hdlr_typekey_token',
            CommentFields =>
                '$Core::MT::Template::Tags::Comment::_hdlr_comment_fields',
            RemoteSignOutLink =>
                '$Core::MT::Template::Tags::Comment::_hdlr_remote_sign_out_link',
            RemoteSignInLink =>
                '$Core::MT::Template::Tags::Comment::_hdlr_remote_sign_in_link',
            SignOutLink =>
                '$Core::MT::Template::Tags::Comment::_hdlr_sign_out_link',
            SignInLink =>
                '$Core::MT::Template::Tags::Comment::_hdlr_sign_in_link',
            SignOnURL =>
                '$Core::MT::Template::Tags::Comment::_hdlr_signon_url',

            ## Ping', => {
            PingsSentURL =>
                '$Core::MT::Template::Tags::Ping::_hdlr_pings_sent_url',
            PingTitle => '$Core::MT::Template::Tags::Ping::_hdlr_ping_title',
            PingID    => '$Core::MT::Template::Tags::Ping::_hdlr_ping_id',
            PingURL   => '$Core::MT::Template::Tags::Ping::_hdlr_ping_url',
            PingExcerpt =>
                '$Core::MT::Template::Tags::Ping::_hdlr_ping_excerpt',
            PingBlogName =>
                '$Core::MT::Template::Tags::Ping::_hdlr_ping_blog_name',
            PingIP   => '$Core::MT::Template::Tags::Ping::_hdlr_ping_ip',
            PingDate => '$Core::MT::Template::Tags::Ping::_hdlr_ping_date',
            BlogPingCount =>
                '$Core::MT::Template::Tags::Ping::_hdlr_blog_ping_count',
            WebsitePingCount =>
                '$Core::MT::Template::Tags::Ping::_hdlr_blog_ping_count',
            EntryTrackbackCount =>
                '$Core::MT::Template::Tags::Ping::_hdlr_entry_ping_count',
            EntryTrackbackLink =>
                '$Core::MT::Template::Tags::Ping::_hdlr_entry_tb_link',
            EntryTrackbackData =>
                '$Core::MT::Template::Tags::Ping::_hdlr_entry_tb_data',
            EntryTrackbackID =>
                '$Core::MT::Template::Tags::Ping::_hdlr_entry_tb_id',
            CategoryTrackbackLink =>
                '$Core::MT::Template::Tags::Ping::_hdlr_category_tb_link',
            CategoryTrackbackCount =>
                '$Core::MT::Template::Tags::Ping::_hdlr_category_tb_count',

            ## Category
            CategoryID =>
                '$Core::MT::Template::Tags::Category::_hdlr_category_id',
            CategoryLabel =>
                '$Core::MT::Template::Tags::Category::_hdlr_category_label',
            CategoryBasename =>
                '$Core::MT::Template::Tags::Category::_hdlr_category_basename',
            CategoryDescription =>
                '$Core::MT::Template::Tags::Category::_hdlr_category_desc',
            CategoryArchiveLink =>
                '$Core::MT::Template::Tags::Category::_hdlr_category_archive',
            CategoryCount =>
                '$Core::MT::Template::Tags::Category::_hdlr_category_count',
            SubCatsRecurse =>
                '$Core::MT::Template::Tags::Category::_hdlr_sub_cats_recurse',
            SubCategoryPath =>
                '$Core::MT::Template::Tags::Category::_hdlr_sub_category_path',
            BlogCategoryCount =>
                '$Core::MT::Template::Tags::Category::_hdlr_blog_category_count',
            ArchiveCategory =>
                '$Core::MT::Template::Tags::Category::_hdlr_archive_category',
            EntryCategory =>
                '$Core::MT::Template::Tags::Category::_hdlr_entry_category',

            ## Page
            PageID    => '$Core::MT::Template::Tags::Page::_hdlr_page_id',
            PageTitle => '$Core::MT::Template::Tags::Page::_hdlr_page_title',
            PageBody  => '$Core::MT::Template::Tags::Page::_hdlr_page_body',
            PageMore  => '$Core::MT::Template::Tags::Page::_hdlr_page_more',
            PageDate  => '$Core::MT::Template::Tags::Page::_hdlr_page_date',
            PageModifiedDate =>
                '$Core::MT::Template::Tags::Page::_hdlr_page_modified_date',
            PageKeywords =>
                '$Core::MT::Template::Tags::Page::_hdlr_page_keywords',
            PageBasename =>
                '$Core::MT::Template::Tags::Page::_hdlr_page_basename',
            PagePermalink =>
                '$Core::MT::Template::Tags::Page::_hdlr_page_permalink',
            PageAuthorDisplayName =>
                '$Core::MT::Template::Tags::Page::_hdlr_page_author_display_name',
            PageAuthorEmail =>
                '$Core::MT::Template::Tags::Page::_hdlr_page_author_email',
            PageAuthorLink =>
                '$Core::MT::Template::Tags::Page::_hdlr_page_author_link',
            PageAuthorURL =>
                '$Core::MT::Template::Tags::Page::_hdlr_page_author_url',
            PageExcerpt =>
                '$Core::MT::Template::Tags::Page::_hdlr_page_excerpt',
            BlogPageCount =>
                '$Core::MT::Template::Tags::Page::_hdlr_blog_page_count',
            WebsitePageCount =>
                '$Core::MT::Template::Tags::Page::_hdlr_blog_page_count',

            ## Folder
            FolderBasename =>
                '$Core::MT::Template::Tags::Folder::_hdlr_folder_basename',
            FolderCount =>
                '$Core::MT::Template::Tags::Folder::_hdlr_folder_count',
            FolderDescription =>
                '$Core::MT::Template::Tags::Folder::_hdlr_folder_description',
            FolderID => '$Core::MT::Template::Tags::Folder::_hdlr_folder_id',
            FolderLabel =>
                '$Core::MT::Template::Tags::Folder::_hdlr_folder_label',
            FolderPath =>
                '$Core::MT::Template::Tags::Folder::_hdlr_folder_path',
            SubFolderRecurse =>
                '$Core::MT::Template::Tags::Folder::_hdlr_sub_folder_recurse',

            ## Asset
            AssetID => '$Core::MT::Template::Tags::Asset::_hdlr_asset_id',
            AssetFileName =>
                '$Core::MT::Template::Tags::Asset::_hdlr_asset_file_name',
            AssetLabel =>
                '$Core::MT::Template::Tags::Asset::_hdlr_asset_label',
            AssetURL  => '$Core::MT::Template::Tags::Asset::_hdlr_asset_url',
            AssetType => '$Core::MT::Template::Tags::Asset::_hdlr_asset_type',
            AssetMimeType =>
                '$Core::MT::Template::Tags::Asset::_hdlr_asset_mime_type',
            AssetFilePath =>
                '$Core::MT::Template::Tags::Asset::_hdlr_asset_file_path',
            AssetDateAdded =>
                '$Core::MT::Template::Tags::Asset::_hdlr_asset_date_added',
            AssetAddedBy =>
                '$Core::MT::Template::Tags::Asset::_hdlr_asset_added_by',
            AssetProperty =>
                '$Core::MT::Template::Tags::Asset::_hdlr_asset_property',
            AssetFileExt =>
                '$Core::MT::Template::Tags::Asset::_hdlr_asset_file_ext',
            AssetThumbnailURL =>
                '$Core::MT::Template::Tags::Asset::_hdlr_asset_thumbnail_url',
            AssetLink => '$Core::MT::Template::Tags::Asset::_hdlr_asset_link',
            AssetThumbnailLink =>
                '$Core::MT::Template::Tags::Asset::_hdlr_asset_thumbnail_link',
            AssetDescription =>
                '$Core::MT::Template::Tags::Asset::_hdlr_asset_description',
            AssetCount =>
                '$Core::MT::Template::Tags::Asset::_hdlr_asset_count',

            ## Userpic
            AuthorUserpic =>
                '$Core::MT::Template::Tags::Userpic::_hdlr_author_userpic',
            AuthorUserpicURL =>
                '$Core::MT::Template::Tags::Userpic::_hdlr_author_userpic_url',
            EntryAuthorUserpic =>
                '$Core::MT::Template::Tags::Userpic::_hdlr_entry_author_userpic',
            EntryAuthorUserpicURL =>
                '$Core::MT::Template::Tags::Userpic::_hdlr_entry_author_userpic_url',
            CommenterUserpic =>
                '$Core::MT::Template::Tags::Userpic::_hdlr_commenter_userpic',
            CommenterUserpicURL =>
                '$Core::MT::Template::Tags::Userpic::_hdlr_commenter_userpic_url',

            ## Tag
            TagName  => '$Core::MT::Template::Tags::Tag::_hdlr_tag_name',
            TagLabel => '$Core::MT::Template::Tags::Tag::_hdlr_tag_name',
            TagID    => '$Core::MT::Template::Tags::Tag::_hdlr_tag_id',
            TagCount => '$Core::MT::Template::Tags::Tag::_hdlr_tag_count',
            TagRank  => '$Core::MT::Template::Tags::Tag::_hdlr_tag_rank',
            TagSearchLink =>
                '$Core::MT::Template::Tags::Tag::_hdlr_tag_search_link',

            ## Calendar
            CalendarDay =>
                '$Core::MT::Template::Tags::Calendar::_hdlr_calendar_day',
            CalendarCellNumber =>
                '$Core::MT::Template::Tags::Calendar::_hdlr_calendar_cell_num',
            CalendarDate => \&build_date,

            ## Score
            # Rating related handlers
            EntryScore =>
                '$Core::MT::Template::Tags::Score::_hdlr_entry_score',
            CommentScore =>
                '$Core::MT::Template::Tags::Score::_hdlr_comment_score',
            PingScore => '$Core::MT::Template::Tags::Score::_hdlr_ping_score',
            AssetScore =>
                '$Core::MT::Template::Tags::Score::_hdlr_asset_score',
            AuthorScore =>
                '$Core::MT::Template::Tags::Score::_hdlr_author_score',

            EntryScoreHigh =>
                '$Core::MT::Template::Tags::Score::_hdlr_entry_score_high',
            CommentScoreHigh =>
                '$Core::MT::Template::Tags::Score::_hdlr_comment_score_high',
            PingScoreHigh =>
                '$Core::MT::Template::Tags::Score::_hdlr_ping_score_high',
            AssetScoreHigh =>
                '$Core::MT::Template::Tags::Score::_hdlr_asset_score_high',
            AuthorScoreHigh =>
                '$Core::MT::Template::Tags::Score::_hdlr_author_score_high',

            EntryScoreLow =>
                '$Core::MT::Template::Tags::Score::_hdlr_entry_score_low',
            CommentScoreLow =>
                '$Core::MT::Template::Tags::Score::_hdlr_comment_score_low',
            PingScoreLow =>
                '$Core::MT::Template::Tags::Score::_hdlr_ping_score_low',
            AssetScoreLow =>
                '$Core::MT::Template::Tags::Score::_hdlr_asset_score_low',
            AuthorScoreLow =>
                '$Core::MT::Template::Tags::Score::_hdlr_author_score_low',

            EntryScoreAvg =>
                '$Core::MT::Template::Tags::Score::_hdlr_entry_score_avg',
            CommentScoreAvg =>
                '$Core::MT::Template::Tags::Score::_hdlr_comment_score_avg',
            PingScoreAvg =>
                '$Core::MT::Template::Tags::Score::_hdlr_ping_score_avg',
            AssetScoreAvg =>
                '$Core::MT::Template::Tags::Score::_hdlr_asset_score_avg',
            AuthorScoreAvg =>
                '$Core::MT::Template::Tags::Score::_hdlr_author_score_avg',

            EntryScoreCount =>
                '$Core::MT::Template::Tags::Score::_hdlr_entry_score_count',
            CommentScoreCount =>
                '$Core::MT::Template::Tags::Score::_hdlr_comment_score_count',
            PingScoreCount =>
                '$Core::MT::Template::Tags::Score::_hdlr_ping_score_count',
            AssetScoreCount =>
                '$Core::MT::Template::Tags::Score::_hdlr_asset_score_count',
            AuthorScoreCount =>
                '$Core::MT::Template::Tags::Score::_hdlr_author_score_count',

            EntryRank => '$Core::MT::Template::Tags::Score::_hdlr_entry_rank',
            CommentRank =>
                '$Core::MT::Template::Tags::Score::_hdlr_comment_rank',
            PingRank  => '$Core::MT::Template::Tags::Score::_hdlr_ping_rank',
            AssetRank => '$Core::MT::Template::Tags::Score::_hdlr_asset_rank',
            AuthorRank =>
                '$Core::MT::Template::Tags::Score::_hdlr_author_rank',

            ## Pager
            PagerLink => '$Core::MT::Template::Tags::Pager::_hdlr_pager_link',
            NextLink  => '$Core::MT::Template::Tags::Pager::_hdlr_next_link',
            PreviousLink =>
                '$Core::MT::Template::Tags::Pager::_hdlr_previous_link',
            CurrentPage =>
                '$Core::MT::Template::Tags::Pager::_hdlr_current_page',
            TotalPages =>
                '$Core::MT::Template::Tags::Pager::_hdlr_total_pages',

            ## Search
            # stubs for mt-search tags used in template includes
            SearchString      => sub {''},
            SearchResultCount => sub {0},
            MaxResults        => sub {''},
            SearchMaxResults =>
                '$Core::MT::Template::Tags::Search::_hdlr_search_max_results',
            SearchIncludeBlogs   => sub {''},
            SearchTemplateID     => sub {0},
            SearchTemplateBlogID => sub {0},

            ## Misc
            FeedbackScore =>
                '$Core::MT::Template::Tags::Misc::_hdlr_feedback_score',
            ImageURL => '$Core::MT::Template::Tags::Misc::_hdlr_image_url',
            ImageWidth =>
                '$Core::MT::Template::Tags::Misc::_hdlr_image_width',
            ImageHeight =>
                '$Core::MT::Template::Tags::Misc::_hdlr_image_height',
            WidgetManager =>
                '$Core::MT::Template::Tags::Misc::_hdlr_widget_manager',
            WidgetSet =>
                '$Core::MT::Template::Tags::Misc::_hdlr_widget_manager',
            CaptchaFields =>
                '$Core::MT::Template::Tags::Misc::_hdlr_captcha_fields',
        },
        modifier => {
            'numify'  => '$Core::MT::Template::Tags::Filters::_fltr_numify',
            'mteval'  => '$Core::MT::Template::Tags::Filters::_fltr_mteval',
            'filters' => '$Core::MT::Template::Tags::Filters::_fltr_filters',
            'trim_to' => '$Core::MT::Template::Tags::Filters::_fltr_trim_to',
            'trim'    => '$Core::MT::Template::Tags::Filters::_fltr_trim',
            'ltrim'   => '$Core::MT::Template::Tags::Filters::_fltr_ltrim',
            'rtrim'   => '$Core::MT::Template::Tags::Filters::_fltr_rtrim',
            'decode_html' =>
                '$Core::MT::Template::Tags::Filters::_fltr_decode_html',
            'decode_xml' =>
                '$Core::MT::Template::Tags::Filters::_fltr_decode_xml',
            'remove_html' =>
                '$Core::MT::Template::Tags::Filters::_fltr_remove_html',
            'dirify' => '$Core::MT::Template::Tags::Filters::_fltr_dirify',
            'sanitize' =>
                '$Core::MT::Template::Tags::Filters::_fltr_sanitize',
            'encode_sha1' => '$Core::MT::Template::Tags::Filters::_fltr_sha1',
            'encode_html' =>
                '$Core::MT::Template::Tags::Filters::_fltr_encode_html',
            'encode_xml' =>
                '$Core::MT::Template::Tags::Filters::_fltr_encode_xml',
            'encode_js' =>
                '$Core::MT::Template::Tags::Filters::_fltr_encode_js',
            'encode_php' =>
                '$Core::MT::Template::Tags::Filters::_fltr_encode_php',
            'encode_url' =>
                '$Core::MT::Template::Tags::Filters::_fltr_encode_url',
            'upper_case' =>
                '$Core::MT::Template::Tags::Filters::_fltr_upper_case',
            'lower_case' =>
                '$Core::MT::Template::Tags::Filters::_fltr_lower_case',
            'strip_linefeeds' =>
                '$Core::MT::Template::Tags::Filters::_fltr_strip_linefeeds',
            'space_pad' =>
                '$Core::MT::Template::Tags::Filters::_fltr_space_pad',
            'zero_pad' =>
                '$Core::MT::Template::Tags::Filters::_fltr_zero_pad',
            'sprintf' => '$Core::MT::Template::Tags::Filters::_fltr_sprintf',
            'regex_replace' =>
                '$Core::MT::Template::Tags::Filters::_fltr_regex_replace',
            'capitalize' =>
                '$Core::MT::Template::Tags::Filters::_fltr_capitalize',
            'count_characters' =>
                '$Core::MT::Template::Tags::Filters::_fltr_count_characters',
            'cat' => '$Core::MT::Template::Tags::Filters::_fltr_cat',
            'count_paragraphs' =>
                '$Core::MT::Template::Tags::Filters::_fltr_count_paragraphs',
            'count_words' =>
                '$Core::MT::Template::Tags::Filters::_fltr_count_words',
            'escape'  => '$Core::MT::Template::Tags::Filters::_fltr_escape',
            'indent'  => '$Core::MT::Template::Tags::Filters::_fltr_indent',
            'nl2br'   => '$Core::MT::Template::Tags::Filters::_fltr_nl2br',
            'replace' => '$Core::MT::Template::Tags::Filters::_fltr_replace',
            'spacify' => '$Core::MT::Template::Tags::Filters::_fltr_spacify',
            'string_format' =>
                '$Core::MT::Template::Tags::Filters::_fltr_sprintf',
            'strip' => '$Core::MT::Template::Tags::Filters::_fltr_strip',
            'strip_tags' =>
                '$Core::MT::Template::Tags::Filters::_fltr_strip_tags',
            '_default' => '$Core::MT::Template::Tags::Filters::_fltr_default',
            'nofollowfy' =>
                '$Core::MT::Template::Tags::Filters::_fltr_nofollowfy',
            'wrap_text' =>
                '$Core::MT::Template::Tags::Filters::_fltr_wrap_text',
            'setvar' => '$Core::MT::Template::Tags::Filters::_fltr_setvar',
        },
    };
    return $tags;
}

## used in both Comment.pm and Ping.pm
sub sanitize_on {
    my ( $ctx, $args ) = @_;
    ## backward compatibility. in MT4, this didn't take $ctx.
    if ( !UNIVERSAL::isa( $ctx, 'MT::Template::Context' ) ) {
        $args = $ctx;
    }
    unless ( exists $args->{'sanitize'} ) {

        # Important to come before other manipulation attributes
        # like encode_xml
        unshift @{ $args->{'@'} ||= [] }, [ 'sanitize' => 1 ];
        $args->{'sanitize'} = 1;
    }
}

## used in Ping.pm
sub nofollowfy_on {
    my ( $ctx, $args ) = @_;
    unless ( exists $args->{'nofollowfy'} ) {
        $args->{'nofollowfy'} = 1;
    }
}

## used in both Category.pm and Entry.pm.
sub cat_path_to_category {
    ## for backward compatibility.
    shift if UNIVERSAL::isa( $_[0], 'MT::Template::Context' );
    my ( $path, $blog_id, $class_type ) = @_;

    my $class = MT->model($class_type);

  # The argument version always takes precedence
  # followed by the current category (i.e. MTCategories/MTSubCategories style)
  # then the current category for the archive
  # then undef
    my @cat_path = $path
        =~ m@(\[[^]]+?\]|[^]/]+)@g;    # split on slashes, fields quoted by []
    @cat_path = map { $_ =~ s/^\[(.*)\]$/$1/; $_ } @cat_path;  # remove any []
    my $last_cat_id = 0;
    my $cat;
    my ( %blog_terms, %blog_args );
    if ( ref $blog_id eq 'ARRAY' ) {
        %blog_terms = %{ $blog_id->[0] };
        %blog_args  = %{ $blog_id->[1] };
    }
    elsif ($blog_id) {
        $blog_terms{blog_id} = $blog_id;
    }

    my $top  = shift @cat_path;
    my @cats = $class->load(
        {   label  => $top,
            parent => 0,
            %blog_terms
        },
        \%blog_args
    );
    if (@cats) {
        for my $label (@cat_path) {
            my @parents = map { $_->id } @cats;
            @cats = $class->load(
                {   label  => $label,
                    parent => \@parents,
                    %blog_terms
                },
                \%blog_args
            ) or last;
        }
    }
    if ( !@cats && $path ) {
        @cats = (
            $class->load(
                {   label => $path,
                    %blog_terms,
                },
                \%blog_args
            )
        );
    }
    @cats;
}

## for backward compatibility
sub _hdlr_pass_tokens      { shift->slurp(@_) }
sub _hdlr_pass_tokens_else { shift->else(@_) }

sub build_date {
    my ( $ctx, $args ) = @_;
    my $ts = $args->{ts} || $ctx->{current_timestamp};
    my $tag = $ctx->stash('tag');
    return $ctx->error(
        MT->translate(
            "You used an [_1] tag without a date context set up.", "MT$tag"
        )
    ) unless defined $ts;
    my $blog = $ctx->stash('blog');
    unless ( ref $blog ) {
        my $blog_id = $blog || $args->{offset_blog_id};
        if ($blog_id) {
            $blog = MT->model('blog')->load($blog_id);
            return $ctx->error(
                MT->translate( 'Cannot load blog #[_1].', $blog_id ) )
                unless $blog;
        }
    }
    my $lang 
        = $args->{language}
        || $ctx->var('local_lang_id')
        || ( $blog && $blog->date_language );
    if ( $args->{utc} ) {
        my ( $y, $mo, $d, $h, $m, $s )
            = $ts
            =~ /(\d\d\d\d)[^\d]?(\d\d)[^\d]?(\d\d)[^\d]?(\d\d)[^\d]?(\d\d)[^\d]?(\d\d)/;
        $mo--;
        my $server_offset = ( $blog && $blog->server_offset )
            || MT->config->TimeOffset;
        if ( ( localtime( timelocal( $s, $m, $h, $d, $mo, $y ) ) )[8] ) {
            $server_offset += 1;
        }
        my $four_digit_offset = sprintf( '%.02d%.02d',
            int($server_offset),
            60 * abs( $server_offset - int($server_offset) ) );
        require MT::DateTime;
        my $tz_secs = MT::DateTime->tz_offset_as_seconds($four_digit_offset);
        my $ts_utc = Time::Local::timegm_nocheck( $s, $m, $h, $d, $mo, $y );
        $ts_utc -= $tz_secs;
        ( $s, $m, $h, $d, $mo, $y ) = gmtime($ts_utc);
        $y += 1900;
        $mo++;
        $ts = sprintf( "%04d%02d%02d%02d%02d%02d", $y, $mo, $d, $h, $m, $s );
    }
    if ( my $format = lc( $args->{format_name} || '' ) ) {
        my $tz = 'Z';
        unless ( $args->{utc} ) {
            my $so = ( $blog && $blog->server_offset )
                || MT->config->TimeOffset;
            my $partial_hour_offset = 60 * abs( $so - int($so) );
            if ( $format eq 'rfc822' ) {
                $tz = sprintf( "%s%02d%02d",
                    $so < 0 ? '-' : '+',
                    abs($so), $partial_hour_offset );
            }
            elsif ( $format eq 'iso8601' ) {
                $tz = sprintf( "%s%02d:%02d",
                    $so < 0 ? '-' : '+',
                    abs($so), $partial_hour_offset );
            }
        }
        if ( $format eq 'rfc822' ) {
            ## RFC-822 dates must be in English.
            $args->{'format'} = '%a, %d %b %Y %H:%M:%S ' . $tz;
            $lang = 'en';
        }
        elsif ( $format eq 'iso8601' ) {
            $args->{format} = '%Y-%m-%dT%H:%M:%S' . $tz;
        }
    }
    if ( my $r = $args->{relative} ) {
        if ( $r eq 'js' ) {

            # output javascript here to render relative date
            my ( $y, $mo, $d, $h, $m, $s )
                = $ts
                =~ /(\d\d\d\d)[^\d]?(\d\d)[^\d]?(\d\d)[^\d]?(\d\d)[^\d]?(\d\d)[^\d]?(\d\d)/;
            $mo--;
            my $fds = format_ts( $args->{'format'}, $ts, $blog, $lang );
            my $js = <<EOT;
<script type="text/javascript">
/* <![CDATA[ */
document.write(mtRelativeDate(new Date($y,$mo,$d,$h,$m,$s), '$fds'));
/* ]]> */
</script><noscript>$fds</noscript>
EOT
            return $js;
        }
        else {
            my $old_lang = MT->current_language;
            MT->set_language($lang) if $lang && ( $lang ne $old_lang );
            my $date = relative_date( $ts, time, $blog, $args->{format}, $r,
                $lang );
            MT->set_language($old_lang) if $lang && ( $lang ne $old_lang );
            if ($date) {
                return $date;
            }
            else {
                if ( !$args->{format} ) {
                    return '';
                }
            }
        }
    }
    my $mail_flag = $args->{mail} || 0;
    return format_ts( $args->{'format'}, $ts, $blog, $lang, $mail_flag );
}

*_hdlr_date = *build_date;

sub cgi_path {
    my ($ctx) = @_;
    my $path = $ctx->{config}->CGIPath;
    if ( $path =~ m!^/! ) {

        # relative path, prepend blog domain
        if ( my $blog = $ctx->stash('blog') ) {
            my ($blog_domain) = $blog->archive_url =~ m|(.+://[^/]+)|;
            if ($blog_domain) {
                $path = $blog_domain . $path;
            }
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

package MT::Template::Tags::Core;
use strict;

use MT::Util qw(deep_copy);

sub _math_operation {
    my ( $ctx, $op, $lvalue, $rvalue ) = @_;
    return $lvalue
        unless ( $lvalue =~ m/^\-?[\d\.]+$/ )
        && (
        ( defined($rvalue) && ( $rvalue =~ m/^\-?[\d\.]+$/ ) )
        || (   ( $op eq 'inc' )
            || ( $op eq 'dec' )
            || ( $op eq '++' )
            || ( $op eq '--' ) )
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
    my ( $ctx, $args, $cond ) = @_;
    my $var = $args->{name} || $args->{var};
    my $value;
    if ( defined $var ) {

        # pick off any {...} or [...] from the name.
        my ( $index, $key );
        if ( $var =~ m/^(.+)([\[\{])(.+)[\]\}]$/ ) {
            $var = $1;
            my $br  = $2;
            my $ref = $3;
            if ( $ref =~ m/^\$(.+)/ ) {
                $ref = $ctx->var($1);
            }
            $br eq '[' ? $index = $ref : $key = $ref;
        }
        else {
            $index = $args->{index} if exists $args->{index};
            $key   = $args->{key}   if exists $args->{key};
        }

        $value = $ctx->var($var);
        if ( ref($value) ) {
            if ( UNIVERSAL::isa( $value, 'MT::Template' ) ) {
                local $value->{context} = $ctx;
                $value = $value->output();
            }
            elsif ( UNIVERSAL::isa( $value, 'MT::Template::Tokens' ) ) {
                local $ctx->{__stash}{tokens} = $value;
                $value = $ctx->slurp( $args, $cond ) or return;
            }
            elsif ( ref($value) eq 'ARRAY' ) {
                $value = $value->[$index] if defined $index;
            }
            elsif ( ref($value) eq 'HASH' ) {
                $value = $value->{$key} if defined $key;
            }
        }
    }
    elsif ( defined( my $tag = $args->{tag} ) ) {
        $tag =~ s/^MT:?//i;
        require Storable;
        my $local_args = Storable::dclone($args);
        $value = $ctx->tag( $tag, $local_args, $cond );
    }

    $ctx->{__stash}{vars}{__cond_value__} = $value;
    $ctx->{__stash}{vars}{__cond_name__}  = $var;

    if ( my $op = $args->{op} ) {
        my $rvalue = $args->{'value'};
        if ( $op && ( defined $value ) && !ref($value) ) {
            $value = _math_operation( $ctx, $op, $value, $rvalue );
        }
    }

    my $numeric = qr/^[-]?[0-9]+(\.[0-9]+)?$/;
    no warnings;
    if ( exists $args->{eq} ) {
        return 0 unless defined($value);
        my $eq = $args->{eq};
        if ( $value =~ m/$numeric/ && $eq =~ m/$numeric/ ) {
            return $value == $eq;
        }
        else {
            return $value eq $eq;
        }
    }
    elsif ( exists $args->{ne} ) {
        return 0 unless defined($value);
        my $ne = $args->{ne};
        if ( $value =~ m/$numeric/ && $ne =~ m/$numeric/ ) {
            return $value != $ne;
        }
        else {
            return $value ne $ne;
        }
    }
    elsif ( exists $args->{gt} ) {
        return 0 unless defined($value);
        my $gt = $args->{gt};
        if ( $value =~ m/$numeric/ && $gt =~ m/$numeric/ ) {
            return $value > $gt;
        }
        else {
            return $value gt $gt;
        }
    }
    elsif ( exists $args->{lt} ) {
        return 0 unless defined($value);
        my $lt = $args->{lt};
        if ( $value =~ m/$numeric/ && $lt =~ m/$numeric/ ) {
            return $value < $lt;
        }
        else {
            return $value lt $lt;
        }
    }
    elsif ( exists $args->{ge} ) {
        return 0 unless defined($value);
        my $ge = $args->{ge};
        if ( $value =~ m/$numeric/ && $ge =~ m/$numeric/ ) {
            return $value >= $ge;
        }
        else {
            return $value ge $ge;
        }
    }
    elsif ( exists $args->{le} ) {
        return 0 unless defined($value);
        my $le = $args->{le};
        if ( $value =~ m/$numeric/ && $le =~ m/$numeric/ ) {
            return $value <= $le;
        }
        else {
            return $value le $le;
        }
    }
    elsif ( exists $args->{like} ) {
        my $like = $args->{like};
        if ( !ref $like ) {
            if ( $like =~ m!^/.+/([si]+)?$!s ) {
                my $opt = $1;
                $like =~ s!^/|/([si]+)?$!!g;    # /abc/ => abc
                $like = "(?$opt)" . $like if defined $opt;
            }
            my $re = eval {qr/$like/};
            return 0 unless $re;
            $args->{like} = $like = $re;
        }
        return defined($value) && ( $value =~ m/$like/ ) ? 1 : 0;
    }
    elsif ( exists $args->{test} ) {
        my $expr = $args->{'test'};
        my $safe = $ctx->{__safe_compartment};
        if ( !$safe ) {
            $safe = eval { require Safe; new Safe; }
                or return $ctx->error(
                "Cannot evaluate expression [$expr]: Perl 'Safe' module is required."
                );
            $ctx->{__safe_compartment} = $safe;
        }
        my $vars = $ctx->{__stash}{vars};
        my $ns   = $safe->root;
        {
            no strict 'refs';
            foreach my $v ( keys %$vars ) {

                # or should we be using $ctx->var here ?
                # can we limit this step to just the variables
                # mentioned in $expr ??
                ${ $ns . '::' . $v } = $vars->{$v};
            }
        }

        my @warnings;
        my $res;
        {
            local $SIG{__WARN__} = sub { push( @warnings, $_[0] ); };
            $res = $safe->reval($expr);
        }
        if ($@) {
            return $ctx->error("Error in expression [$expr]: $@");
        }

        # THINK: should return error if there are some warnings?
        # if (@warnings) {
        #     return $ctx->error("Warning in expression [$expr]: @warnings");
        # }

        return $res;
    }
    if ( ( defined $value ) && $value ) {
        if ( ref($value) eq 'ARRAY' ) {
            return @$value ? 1 : 0;
        }
        elsif ( ref($value) eq 'HASH' ) {
            return %$value ? 1 : 0;
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

sub _hdlr_unless {
    defined( my $r = &_hdlr_if ) or return;
    !$r;
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
    my ( $ctx, $args, $cond ) = @_;
    local $args->{'@'};
    delete $args->{'@'};
    if ( ( keys %$args ) >= 1 ) {
        unless ( $args->{name} || $args->{var} || $args->{tag} ) {
            if ( my $t = $ctx->var('__cond_tag__') ) {
                $args->{tag} = $t;
            }
            elsif ( my $n = $ctx->var('__cond_name__') ) {
                $args->{name} = $n;
            }
        }
    }
    if (%$args) {
        defined( my $res = _hdlr_if(@_) ) or return;
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
    my ( $ctx, $args, $cond ) = @_;
    unless ( $args->{name} || $args->{var} || $args->{tag} ) {
        if ( my $t = $ctx->var('__cond_tag__') ) {
            $args->{tag} = $t;
        }
        elsif ( my $n = $ctx->var('__cond_name__') ) {
            $args->{name} = $n;
        }
    }
    return _hdlr_else( $ctx, $args, $cond );
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
    my ( $ctx, $args, $cond ) = @_;
    my $value;
    if ( exists $args->{tag} ) {
        $args->{tag} =~ s/^MT:?//i;
        $value = $ctx->tag( $args->{tag}, $args, $cond );
    }
    elsif ( exists $args->{name} ) {
        $value = $ctx->var( $args->{name} );
    }
    elsif ( exists $args->{var} ) {
        $value = $ctx->var( $args->{var} );
    }
    if ( defined($value) && $value ne '' ) {    # want to include "0" here
        return 1;
    }
    else {
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
    my ( $ctx, $args, $cond ) = @_;
    my $value;
    if ( exists $args->{tag} ) {
        $args->{tag} =~ s/^MT:?//i;
        $value = $ctx->tag( $args->{tag}, $args, $cond );
    }
    elsif ( exists $args->{name} ) {
        $value = $ctx->var( $args->{name} );
    }
    elsif ( exists $args->{var} ) {
        $value = $ctx->var( $args->{var} );
    }
    if ( defined($value) && $value ) {
        return 1;
    }
    else {
        return 0;
    }
}

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
    my ( $ctx, $args, $cond ) = @_;
    my $name = $args->{name} || $args->{var};
    my $var = $ctx->var($name);
    return ''
        unless $var && ( ( ref($var) eq 'ARRAY' ) && ( scalar @$var ) )
            || ( ( ref($var) eq 'HASH' ) && ( scalar( keys %$var ) ) );

    my $hash_var;
    if ( 'HASH' eq ref($var) ) {
        $hash_var = $var;
        my @keys = keys %$var;
        $var = \@keys;
    }
    if ( my $sort = $args->{sort_by} ) {
        $sort = lc $sort;
        if ( $sort =~ m/\bkey\b/ ) {
            @$var = sort { $a cmp $b } @$var;
        }
        elsif ( $sort =~ m/\bvalue\b/ ) {
            no warnings;
            if ( $sort =~ m/\bnumeric\b/ ) {
                no warnings;
                if ( defined $hash_var ) {
                    @$var
                        = sort { $hash_var->{$a} <=> $hash_var->{$b} } @$var;
                }
                else {
                    @$var = sort { $a <=> $b } @$var;
                }
            }
            else {
                if ( defined $hash_var ) {
                    @$var
                        = sort { $hash_var->{$a} cmp $hash_var->{$b} } @$var;
                }
                else {
                    @$var = sort { $a cmp $b } @$var;
                }
            }
        }
        if ( $sort =~ m/\breverse\b/ ) {
            @$var = reverse @$var;
        }
    }

    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');
    my $out     = '';
    my $i       = 1;
    my $vars    = $ctx->{__stash}{vars} ||= {};
    my $glue    = $args->{glue};
    foreach my $item (@$var) {
        local $vars->{__first__}   = $i == 1;
        local $vars->{__last__}    = $i == scalar @$var;
        local $vars->{__odd__}     = ( $i % 2 ) == 1;
        local $vars->{__even__}    = ( $i % 2 ) == 0;
        local $vars->{__counter__} = $i;
        my @names;
        if ( ref $item && UNIVERSAL::isa( $item, 'MT::Object' ) ) {
            @names = @{ $item->column_names };
        }
        else {
            if ( ref($item) eq 'HASH' ) {
                @names = keys %$item;
            }
            elsif ($hash_var) {
                @names = ( '__key__', '__value__' );
            }
            else {
                @names = '__value__';
            }
        }
        my @var_names;
        push @var_names, lc $_ for @names;
        local @{$vars}{@var_names};
        if ( ref $item && UNIVERSAL::isa( $item, 'MT::Object' ) ) {
            $vars->{ lc($_) } = $item->column($_) for @names;
        }
        elsif ( ref($item) eq 'HASH' ) {
            $vars->{ lc($_) } = $item->{$_} for @names;
        }
        elsif ($hash_var) {
            $vars->{'__key__'}   = $item;
            $vars->{'__value__'} = $hash_var->{$item};
        }
        else {
            $vars->{'__value__'} = $item;
        }
        my $res = $builder->build( $ctx, $tokens, $cond );
        return $ctx->error( $builder->errstr ) unless defined $res;
        if ( $res ne '' ) {
            $out .= $glue
                if defined $glue && $i > 1 && length($out) && length($res);
            $out .= $res;
            $i++;
        }
    }
    return $out;
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
    my ( $ctx, $args, $cond ) = @_;

    my $start = ( exists $args->{from} ? $args->{from} : $args->{start} )
        || 0;
    $start = 0 unless $start =~ /^-?\d+$/;
    my $end = ( exists $args->{to} ? $args->{to} : $args->{end} ) || 0;
    return q() unless $end =~ /^-?\d+$/;
    my $incr = $args->{increment} || $args->{step} || 1;

    # FIXME: support negative "step" values
    $incr = 1 unless $incr =~ /^\d+$/;
    $incr = 1 unless $incr;

    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');
    my $cnt     = 1;
    my $out     = '';
    my $vars    = $ctx->{__stash}{vars} ||= {};
    my $glue    = $args->{glue};
    my $var     = $args->{var};
    for ( my $i = $start; $i <= $end; $i += $incr ) {
        local $vars->{__first__}   = $i == $start;
        local $vars->{__last__}    = $i == $end;
        local $vars->{__odd__}     = ( $cnt % 2 ) == 1;
        local $vars->{__even__}    = ( $cnt % 2 ) == 0;
        local $vars->{__index__}   = $i;
        local $vars->{__counter__} = $cnt;
        local $vars->{$var} = $i if defined $var;
        my $res = $builder->build( $ctx, $tokens, $cond );
        return $ctx->error( $builder->errstr ) unless defined $res;
        $out .= $glue
            if defined $glue && $cnt > 1 && length($out) && length($res);
        $out .= $res;
        $cnt++;
    }
    return $out;
}

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
    my ( $ctx, $args ) = @_;
    my $tag = lc $ctx->stash('tag');
    my $val = $ctx->slurp($args);
    $val =~ s/(^\s+|\s+$)//g;
    my @pairs = split /\r?\n/, $val;
    foreach my $line (@pairs) {
        next if $line =~ m/^\s*$/;
        my ( $var, $value ) = split /\s*=/, $line, 2;
        unless ( defined($var) && defined($value) ) {
            return $ctx->error("Invalid variable assignment: $line");
        }
        $var =~ s/^\s+//;
        $ctx->var( $var, $value );
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
    my ( $ctx, $args ) = @_;
    my $tag = lc $ctx->stash('tag');
    my $name = $args->{name} || $args->{var};
    if ( $name =~ m/^\$/ ) {
        $name = $ctx->var($name);
    }
    return $ctx->error(
        MT->translate(
            "You used a [_1] tag without a valid name attribute.", "<MT$tag>"
        )
    ) unless defined $name;

    my $hash = $ctx->var($name) || {};
    return $ctx->error( MT->translate( "[_1] is not a hash.", $name ) )
        unless 'HASH' eq ref($hash);

    {
        local $ctx->{__inside_set_hashvar} = $hash;
        $ctx->slurp($args);
    }
    if ( my $parent_hash = $ctx->{__inside_set_hashvar} ) {
        $parent_hash->{$name} = $hash;
    }
    else {
        $ctx->var( $name, $hash );
    }
    return q();
}

###########################################################################

=head2 SetVar

A function tag used to set the value of a template variable.

For simply setting variables you can use the L<Var> tag with a value attribute to assign template variables.

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

=for tags

=cut

sub _hdlr_set_var {
    my ( $ctx, $args ) = @_;
    my $tag = lc $ctx->stash('tag');
    my $name = $args->{name} || $args->{var};

    return $ctx->error(
        MT->translate(
            "You used a [_1] tag without a valid name attribute.", "<MT$tag>"
        )
    ) unless defined $name;

    my ( $func, $key, $index, $value );
    if ( $name =~ m/^(\w+)\((.+)\)$/ ) {
        $func = $1;
        $name = $2;
    }
    else {
        $func = $args->{function} if exists $args->{function};
    }

    # pick off any {...} or [...] from the name.
    if ( $name =~ m/^(.+)([\[\{])(.+)[\]\}]$/ ) {
        $name = $1;
        my $br  = $2;
        my $ref = $3;
        if ( $ref =~ m/^\$(.+)/ ) {
            $ref = $ctx->var($1);
            $ref = chr(0) unless defined $ref;
        }
        $br eq '[' ? $index = $ref : $key = $ref;
    }
    else {
        $index = $args->{index} if exists $args->{index};
        $key   = $args->{key}   if exists $args->{key};
    }

    if ( $name =~ m/^\$/ ) {
        $name = $ctx->var($name);
        return $ctx->error(
            MT->translate(
                "You used a [_1] tag without a valid name attribute.",
                "<MT$tag>"
            )
        ) unless defined $name;
    }

    my $val  = '';
    my $data = $ctx->var($name);
    if ( ( $tag eq 'setvar' ) || ( $tag eq 'var' ) ) {
        $val = defined $args->{value} ? $args->{value} : '';
    }
    elsif ( $tag eq 'setvarblock' ) {
        $val = $ctx->slurp($args);
        return unless defined($val);
    }
    elsif ( $tag eq 'setvartemplate' ) {
        $val = $ctx->stash('tokens');
        return unless defined($val);
        $val = bless $val, 'MT::Template::Tokens';
    }

    my $existing = $ctx->var($name);
    $existing = '' unless defined $existing;
    if ( 'HASH' eq ref($existing) && defined $key ) {
        $existing = $existing->{$key};
    }
    elsif ( 'ARRAY' eq ref($existing) ) {
        $existing
            = ( defined $index && ( $index =~ /^-?\d+$/ ) )
            ? $existing->[$index]
            : undef;
    }
    $existing = '' unless defined $existing;

    if ( $args->{prepend} ) {
        $val = $val . $existing;
    }
    elsif ( $args->{append} ) {
        $val = $existing . $val;
    }
    elsif ( $existing ne '' && ( my $op = $args->{op} ) ) {
        $val = _math_operation( $ctx, $op, $existing, $val );
    }

    $val = deep_copy( $val, MT->config->DeepCopyRecursiveLimit );

    if ( defined $key ) {
        $data ||= {};
        return $ctx->error( MT->translate( "'[_1]' is not a hash.", $name ) )
            unless 'HASH' eq ref($data);

        if (   ( defined $func )
            && ( 'delete' eq lc($func) ) )
        {
            delete $data->{$key};
        }
        else {
            $data->{$key} = $val;
        }
    }
    elsif ( defined $index ) {
        $data ||= [];
        return $ctx->error(
            MT->translate( "'[_1]' is not an array.", $name ) )
            unless 'ARRAY' eq ref($data);
        return $ctx->error( MT->translate("Invalid index.") )
            unless $index =~ /^-?\d+$/;
        $data->[$index] = $val;
    }
    elsif ( defined $func ) {
        if ( 'undef' eq lc($func) ) {
            $data = undef;
        }
        else {
            $data ||= [];
            return $ctx->error(
                MT->translate( "'[_1]' is not an array.", $name ) )
                unless 'ARRAY' eq ref($data);
            if ( 'push' eq lc($func) ) {
                push @$data, $val;
            }
            elsif ( 'unshift' eq lc($func) ) {
                $data ||= [];
                unshift @$data, $val;
            }
            else {
                return $ctx->error(
                    MT->translate( "'[_1]' is not a valid function.", $func )
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
        $ctx->var( $name, $data );
    }
    return '';
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
of expressions. In order to not conflict with variable interpolation,
the value of the name attribute should only contain uppercase letters,
lowercase letters, numbers and underscores. The typical case is a simple
variable name:

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
    my ( $ctx, $args, $cond ) = @_;
    if ( exists( $args->{value} )
        && !exists( $args->{op} ) )
    {
        return &_hdlr_set_var(@_);
    }
    my $name = $args->{name} || $args->{var};
    return $ctx->error(
        MT->translate(
            "You used a [_1] tag without a valid name attribute.",
            "<MT" . $ctx->stash('tag') . ">"
        )
    ) unless defined $name;

    my ( $func, $key, $index, $value );
    if ( $name =~ m/^(\w+)\((.+)\)$/ ) {
        $func = $1;
        $name = $2;
    }
    else {
        $func = $args->{function} if exists $args->{function};
    }

    # pick off any {...} or [...] from the name.
    if ( $name =~ m/^(.+)([\[\{])(.+)[\]\}]$/ ) {
        $name = $1;
        my $br  = $2;
        my $ref = $3;
        if ( $ref =~ m/^\$(.+)/ ) {
            $ref = $ctx->var($1);
            $ref = chr(0) unless defined $ref;
        }
        $br eq '[' ? $index = $ref : $key = $ref;
    }
    else {
        $index = $args->{index} if exists $args->{index};
        $key   = $args->{key}   if exists $args->{key};
    }

    if ( $name =~ m/^\$/ ) {
        $name = $ctx->var($name);
    }

    if ( defined $name ) {
        $value = $ctx->var($name);
        if ( ref($value) eq 'CODE' ) {    # handle coderefs
            $value = $value->(@_);
        }
        if ( ref($value) ) {
            if ( ref($value) eq 'ARRAY' ) {
                if ( defined $index ) {
                    if ( $index =~ /^-?\d+$/ ) {
                        $value = $value->[$index];
                    }
                    else {
                        $value = undef;    # fall through to any 'default'
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
                            MT->translate(
                                "'[_1]' is not a valid function for an array.",
                                $func
                            )
                        );
                    }
                }
                else {
                    unless ( $args->{to_json} ) {
                        my $glue = exists $args->{glue} ? $args->{glue} : "";
                        $value = join $glue, @$value;
                    }
                }
            }
            elsif ( ref($value) eq 'HASH' ) {
                if ( defined $key ) {
                    if ( defined $func ) {
                        if ( 'delete' eq lc($func) ) {
                            $value = delete $value->{$key};
                        }
                        else {
                            return $ctx->error(
                                MT->translate(
                                    "'[_1]' is not a valid function for a hash.",
                                    $func
                                )
                            );
                        }
                    }
                    else {
                        if ( $key ne chr(0) ) {
                            $value = $value->{$key};
                        }
                        else {
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
                            MT->translate(
                                "'[_1]' is not a valid function for a hash.",
                                $func
                            )
                        );
                    }
                }
            }
        }
        if ( ref($value) ) {
            if ( UNIVERSAL::isa( $value, 'MT::Template' ) ) {
                local $args->{name}     = undef;
                local $args->{var}      = undef;
                local $value->{context} = $ctx;
                $value = $value->output($args);
            }
            elsif ( UNIVERSAL::isa( $value, 'MT::Template::Tokens' ) ) {
                local $ctx->{__stash}{tokens} = $value;
                local $args->{name}           = undef;
                local $args->{var}            = undef;

                # Pass through SetVarTemplate arguments as variables
                # so that they do not affect the global stash
                my $vars = $ctx->{__stash}{vars} ||= {};
                my @names = keys %$args;
                my @var_names;
                push @var_names, lc $_ for @names;
                local @{$vars}{@var_names};
                $vars->{ lc($_) } = $args->{$_} for @names;
                $value = $ctx->slurp($args) or return;
            }
        }
        if ( my $op = $args->{op} ) {
            my $rvalue = $args->{'value'};
            if ( $op && ( defined $value ) && !ref($value) ) {
                $value = _math_operation( $ctx, $op, $value, $rvalue );
            }
        }
    }
    if ( ( !defined $value ) || ( $value eq '' ) ) {
        if ( exists $args->{default} ) {
            $value = $args->{default};
        }
    }

    if ( ref($value) && $args->{to_json} ) {
        return MT::Util::to_json($value);
    }
    return defined $value ? $value : "";
}

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

=head2 TemplateNote

A function tag that always returns an empty string. This tag is useful
for placing simple notes in your templates, since it produces nothing.

B<Example:>

    <$mt:TemplateNote note="Hi, mom!"$>

=for tags templating

=cut

package MT::Template::Tags::App;

use strict;

use MT;
use MT::Util qw( encode_html encode_url );

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
    my ( $ctx, $args, $cond ) = @_;
    my $id = $args->{id};
    return $ctx->error("'id' attribute missing") unless $id;

    my $label       = $args->{label};
    my $show_label  = exists $args->{show_label} ? $args->{show_label} : 1;
    my $shown       = exists $args->{shown} ? ( $args->{shown} ? 1 : 0 ) : 1;
    my $label_class = $args->{label_class} || "";
    my $content_class = $args->{content_class} || "";
    my $hint          = $args->{hint} || "";
    my $show_hint     = $args->{show_hint} || 0;
    my $warning       = $args->{warning} || "";
    my $show_warning  = $args->{show_warning} || 0;
    my $indent        = $args->{indent};
    my $help;

    # Formatting for help link, placed at the end of the hint.
    if ( $help = $args->{help_page} || "" ) {
        my $section = $args->{help_section} || '';
        $section = qq{, '$section'} if $section;
        $help
            = qq{ <a href="javascript:void(0)" onclick="return openManual('$help'$section)" class="help-link">?</a><br />};
    }
    my $label_help = "";
    if ( $label && $show_label ) {

        # do nothing;
    }
    else {
        $label = '';    # zero it out, because the user turned it off
    }
    if ( $hint && $show_hint ) {
        $hint = "\n<div class=\"hint\">$hint$help</div>";
    }
    else {
        $hint = ''
            ;  # hiding hint because it is either empty or should not be shown
    }
    if ( $warning && $show_warning ) {
        $warning
            = qq{\n<p><img src="<mt:var name="static_uri">images/status_icons/warning.gif" alt="<__trans phrase="Warning">" width="9" height="9" />
<span class="alert-warning-inline">$warning</span></p>\n};
    }
    else {
        $warning = ''
            ;  # hiding hint because it is either empty or should not be shown
    }
    unless ($label_class) {
        $label_class = 'field-left-label';
    }
    else {
        $label_class = 'field-' . $label_class;
    }
    my $indent_css = "";
    if ($indent) {
        $indent_css = " style=\"padding-left: " . $indent . "px;\"";
    }

    # 'Required' indicator plus CSS class
    my $req       = $args->{required} ? " *"        : "";
    my $req_class = $args->{required} ? " required" : "";

    my $insides = $ctx->slurp( $args, $cond );

    # $insides =~ s/^\s*(<textarea)\b/<div class="textarea-wrapper">$1/g;
    # $insides =~ s/(<\/textarea>)\s*$/$1<\/div>/g;

    my $class = $args->{class} || "";
    $class = ( $class eq '' ) ? 'hidden' : $class . ' hidden' unless $shown;

    return $ctx->build(<<"EOT");
<div id="$id-field" class="field$req_class $label_class $class"$indent_css>
    <div class="field-header">
      <label id="$id-label" for="$id">$label$req</label>
    </div>
    <div class="field-content $content_class">
      $insides$hint$warning
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
    my ( $ctx, $args, $cond ) = @_;
    my $hosted_widget = $ctx->var('widget_id') ? 1 : 0;
    my $id            = $args->{id} || $ctx->var('widget_id') || '';
    my $label         = $args->{label};
    my $class         = $args->{class} || $id;
    my $label_link    = $args->{label_link} || "";
    my $label_onclick = $args->{label_onclick} || "";
    my $header_action = $args->{header_action} || "";
    my $closable      = $args->{can_close} ? 1 : 0;
    if ($closable) {
        $header_action
            = qq{<a title="<__trans phrase="Remove this widget">" onclick="javascript:removeWidget('$id'); return false;" href="javascript:void(0);" class="widget-close-link"><span>close</span></a>};
    }
    my $widget_header = "";
    if ( $label_link && $label_onclick ) {
        $widget_header
            = "\n<h2><a href=\"$label_link\" onclick=\"$label_onclick\"><span>$label</span></a></h2>";
    }
    elsif ($label_link) {
        $widget_header
            = "\n<h2><a href=\"$label_link\"><span>$label</span></a></h2>";
    }
    else {
        $widget_header = "\n<h2><span>$label</span></h2>";
    }
    my $token    = $ctx->var('magic_token')     || '';
    my $scope    = $ctx->var('widget_scope')    || 'system';
    my $singular = $ctx->var('widget_singular') || '';

    # Make certain widget_id is set
    my $vars = $ctx->{__stash}{vars};
    local $vars->{widget_id}     = $id;
    local $vars->{widget_header} = '';
    local $vars->{widget_footer} = '';
    my $app = MT->instance;
    my $blog = $app->can('blog') ? $app->blog : $ctx->stash('blog');
    my $blog_field
        = $blog
        ? qq{<input type="hidden" name="blog_id" value="}
        . $blog->id . q{" />}
        : "";
    local $vars->{blog_id} = $blog->id if $blog;
    my $insides = $ctx->slurp( $args, $cond );
    my $widget_footer = ( $ctx->var('widget_footer') || '' );
    my $var_header    = ( $ctx->var('widget_header') || '' );

    if ( $var_header =~ m/<h2[ >]/i ) {
        $widget_header = $var_header;
    }
    else {
        $widget_header .= $var_header;
    }
    my $corners
        = $args->{corners}
        ? '<div class="corners"><b></b><u></u><s></s><i></i></div>'
        : "";
    my $tabbed       = $args->{tabbed} ? ' mt:delegate="tab-container"' : "";
    my $header_class = $tabbed         ? 'widget-header-tabs'           : '';
    my $return_args = $app->make_return_args;
    $return_args = encode_html($return_args);
    my $cgi = $app->uri;
    if ( $hosted_widget && ( !$insides !~ m/<form\s/i ) ) {
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
<div id="$id" class="widget $class"$tabbed>
  <div class="widget-header $header_class">
    <div class="widget-action">$header_action</div>
    <div class="widget-label">$widget_header</div>
  </div>
  <div class="widget-content">
    $insides
  </div>
  <div class="widget-footer">$widget_footer</div>$corners
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
    my ( $ctx, $args, $cond ) = @_;
    my $app     = MT->instance;
    my $id      = $args->{id};
    my $class   = $args->{class} || 'info';
    my $msg     = $ctx->slurp;
    my $rebuild = $args->{rebuild} || '';
    my $no_link = $args->{no_link} || '';
    my $blog_id = $ctx->var('blog_id');
    my $blog    = $ctx->stash('blog');
    if ( !$blog && $blog_id ) {
        $blog = MT->model('blog')->load($blog_id);
    }
    if ( $id eq 'replace-count' && $rebuild =~ /^(website|blog)$/ ) {
        my $link_l
            = $no_link
            ? ''
            : '<a href="<mt:var name="mt_url">?__mode=rebuild_confirm&blog_id=<mt:var name="blog_id">&prompt=index" class="mt-rebuild">';
        my $link_r = $no_link ? '' : '</a>';
        my $obj_type
            = $rebuild eq 'blog'
            ? MT->translate('blog(s)')
            : MT->translate('website(s)');
        $rebuild
            = qq{<__trans phrase="[_1]Publish[_2] your [_3] to see these changes take effect." params="$link_l%%$link_r%%$obj_type">};
    }
    elsif (
        $blog && $app->user
        and $app->user->can_do(
            'rebuild',
            at_least_one => 1,
            blog_id      => $blog->id,
        )
        )
    {
        $rebuild = '' if $blog && $blog->custom_dynamic_templates eq 'all';
        $rebuild
            = qq{<__trans phrase="[_1]Publish[_2] your site to see these changes take effect." params="<a href="<mt:var name="mt_url">?__mode=rebuild_confirm&blog_id=<mt:var name="blog_id">" class="mt-rebuild">%%</a>">}
            if $rebuild eq 'all';
        $rebuild
            = qq{<__trans phrase="[_1]Publish[_2] your site to see these changes take effect." params="<a href="<mt:var name="mt_url">?__mode=rebuild_confirm&blog_id=<mt:var name="blog_id">&prompt=index" class="mt-rebuild">%%</a>">}
            if $rebuild eq 'index';
    }
    else {
        $rebuild = '';
    }
    my $close = '';
    if ( $id && ( $args->{can_close} || ( !exists $args->{can_close} ) ) ) {
        $close
            = qq{<span class="mt-close-msg close-link clickable icon-remove icon16 action-icon"><__trans phrase="Close"></span>};
    }
    $id    = defined $id    ? qq{ id="$id"}      : "";
    $class = defined $class ? qq{msg msg-$class} : "msg";
    return $ctx->build(<<"EOT");
    <div$id class="$class"><p class="msg-text">$msg $rebuild</p>$close</div>
EOT
}

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
    my ( $ctx, $args, $cond ) = @_;

    my $type = $args->{type} || $ctx->var('object_type');
    my $class = MT->model($type) if $type;
    my $loop = $args->{loop} || 'object_loop';
    my $loop_obj = $ctx->var($loop);

    unless ( ( ref($loop_obj) eq 'ARRAY' ) && (@$loop_obj) ) {
        my @else = @{ $ctx->stash('tokens_else') || [] };
        return MT::Template::Context::_hdlr_pass_tokens_else(@_) if @else;
        my $msg = $args->{empty_message} || MT->translate(
            "No [_1] could be found.",
            $class
            ? lc( $class->class_label_plural )
            : ( $type ? $type : MT->translate("records") )
        );
        return $ctx->build(
            qq{<mtapp:statusmsg
            id="zero-state"
            class="info zero-state"
            can_close="0">
            $msg
            </mtapp:statusmsg>}
        );
    }

    my $id = $args->{id} || ( $type ? $type . '-listing' : 'listing' );
    $id =~ s/:/\-/g;    # meta and revision uses colon as a separator
    my $listing_class = $args->{listing_class} || "";
    my $hide_pager    = $args->{hide_pager}    || 0;
    $hide_pager = 1
        if ( $ctx->var('screen_class') || '' ) eq 'search-replace';
    my $show_actions
        = exists $args->{show_actions} ? $args->{show_actions} : 1;
    my $return_args = $ctx->var('return_args') || '';
    my $search_options
        = MT->app->param('__mode') eq 'search_replace'
        ? ( $ctx->var('search_options') || '' )
        : '';
    $return_args = encode_html( $return_args . $search_options );
    $return_args
        = qq{\n        <input type="hidden" name="return_args" value="$return_args" />}
        if $return_args;
    my $blog_id = $ctx->var('blog_id') || '';
    $blog_id
        = qq{\n        <input type="hidden" name="blog_id" value="$blog_id" />}
        if $blog_id;
    my $token = $ctx->var('magic_token') || MT->app->current_magic || '';
    my $action = $args->{action} || '<mt:var name="script_url">' || '';
    my $target
        = defined $args->{target} ? ' target="' . $args->{target} . '"' : '';

    my $actions_top    = "";
    my $actions_bottom = "";
    my $form_id        = "$id-form";
    if ($show_actions) {
        $actions_top
            = qq{<\$MTApp:ActionBar bar_position="top" hide_pager="$hide_pager" form_id="$form_id"\$>};
        $actions_bottom
            = qq{<\$MTApp:ActionBar bar_position="bottom" hide_pager="$hide_pager" form_id="$form_id"\$>};
    }
    else {
        $listing_class .= " hide_actions";
    }

    my $insides;
    {
        local $args->{name} = $loop;
        defined( $insides = $ctx->invoke_handler( 'loop', $args, $cond ) )
            or return;
    }
    my $listing_header = $ctx->var('listing_header') || '';
    my $view = $ctx->var('view_expanded') ? ' expanded' : ' compact';

    my $table = <<TABLE;
        <table id="$id-table" class="legacy listing-table $listing_class $id-table$view">
$insides
        </table>
TABLE

    if ($show_actions) {
        local $ctx->{__stash}{vars}{__contents__} = $table;
        return $ctx->build(<<EOT);
<div id="$id" class="listing line $listing_class">
    <div class="listing-header">
        $listing_header
    </div>
    <form id="$form_id" class="listing-form"
        action="$action" method="post" $target
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
    my ( $ctx, $args, $cond ) = @_;
    my $id = $args->{id};
    return $ctx->error("'id' attribute missing") unless $id;

    my $class = $args->{class} || "";
    my $shown = exists $args->{shown} ? ( $args->{shown} ? 1 : 0 ) : 1;
    $class .= ( $class ne '' ? " " : "" ) . "hidden" unless $shown;
    $class = qq{ class="$class"} if $class ne '';

    my $insides = $ctx->slurp( $args, $cond );
    return <<"EOT";
<fieldset id="$id"$class>
    $insides
</fieldset>
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
    my ( $ctx, $args, $cond ) = @_;
    my $app    = MT->instance;
    my $action = $args->{action} || $app->uri;
    my $method = $args->{method} || 'POST';
    my @fields;
    my $token     = $ctx->var('magic_token');
    my $return    = $ctx->var('return_args');
    my $id        = $args->{object_id} || $ctx->var('id');
    my $blog_id   = $args->{blog_id} || $ctx->var('blog_id');
    my $type      = $args->{object_type} || $ctx->var('type');
    my $form_id   = $args->{id} || $type . '-form';
    my $form_name = $args->{name} || $args->{id};
    my $enctype
        = $args->{enctype} ? " enctype=\"" . $args->{enctype} . "\"" : "";
    my $mode = $args->{mode};
    push @fields, qq{<input type="hidden" name="__mode" value="$mode" />}
        if defined $mode;
    push @fields, qq{<input type="hidden" name="_type" value="$type" />}
        if defined $type;
    push @fields, qq{<input type="hidden" name="id" value="$id" />}
        if defined $id;
    push @fields, qq{<input type="hidden" name="blog_id" value="$blog_id" />}
        if defined $blog_id;
    push @fields,
        qq{<input type="hidden" name="magic_token" value="$token" />}
        if defined $token;
    $return = encode_html($return) if $return;
    push @fields,
        qq{<input type="hidden" name="return_args" value="$return" />}
        if defined $return;
    my $fields = '';
    $fields = join( "\n", @fields ) if @fields;
    my $insides = $ctx->slurp( $args, $cond );
    return <<"EOT";
<form id="$form_id" name="$form_name" action="$action" method="$method"$enctype>
$fields
    $insides
</form>
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
    my ( $ctx, $args, $cond ) = @_;
    my $app  = MT->instance;
    my $from = $args->{from} || $app->mode;
    my $loop = $ctx->var('page_actions');
    return '' if ( ref($loop) ne 'ARRAY' ) || ( !@$loop );
    my $mt = '&amp;magic_token=' . $app->current_magic;
    return $ctx->build( <<EOT, $cond );
    <mtapp:widget
        id="page_actions"
        label="<__trans phrase="Actions">">
                <ul>
        <mt:loop name="page_actions">
            <mt:if name="page">
                    <li class="icon-left-xwide icon<mt:unless name="core">-plugin</mt:unless>-action"><a href="<mt:var name="page" escape="html"><mt:if name="page_has_params">&amp;</mt:if>from=$from<mt:if name="id">&amp;id=<mt:var name="id"></mt:if><mt:if name="blog_id">&amp;blog_id=<mt:var name="blog_id"></mt:if>$mt&amp;return_args=<mt:var name="return_args" escape="url">"<mt:if name="continue_prompt"> onclick="return confirm('<mt:var name="continue_prompt" escape="js">');"</mt:if>><mt:var name="label"></a></li>
            <mt:else><mt:if name="link">
                    <li class="icon-left-xwide icon<mt:unless name="core">-plugin</mt:unless>-action"><a href="<mt:var name="link" escape="html">&amp;from=$from<mt:if name="id">&amp;id=<mt:var name="id"></mt:if><mt:if name="blog_id">&amp;blog_id=<mt:var name="blog_id"></mt:if>$mt&amp;return_args=<mt:var name="return_args" escape="url">"<mt:if name="continue_prompt"> onclick="return confirm('<mt:var name="continue_prompt" escape="js">');"</mt:if><mt:if name="dialog"> class="mt-open-dialog"</mt:if>><mt:var name="label"></a></li>
            </mt:if></mt:if>
        </mt:loop>
                </ul>
    </mtapp:widget>
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
    my ( $ctx, $args, $cond ) = @_;
    my $app     = MT->app;
    my $filters = $ctx->var("list_filters");
    return '' if ( ref($filters) ne 'ARRAY' ) || ( !@$filters );
    my $mode       = $app->mode;
    my $type       = $app->param('_type');
    my $type_param = "";
    $type_param = "&amp;_type=" . encode_url($type) if defined $type;
    return $ctx->build( <<EOT, $cond );
    <mt:loop name="list_filters">
        <mt:if name="__first__">
    <ul>
        </mt:if>
        <mt:if name="key" eq="\$filter_key"><li class="current-filter"><em><mt:else><li></mt:if><a href="<mt:var name="script_url">?__mode=$mode$type_param<mt:if name="blog_id">&amp;blog_id=<mt:var name="blog_id"></mt:if>&amp;filter_key=<mt:var name="key" escape="url">"><mt:var name="label"></a><mt:if name="key" eq="\$filter_key"></em></mt:if></li>
    <mt:if name="__last__">
    </ul>
    </mt:if>
    </mt:loop>
EOT
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
    my ( $ctx, $args, $cond ) = @_;
    my $pos = $args->{bar_position} || 'top';
    my $form_id
        = $args->{form_id}
        ? qq{<mt:setvar name="form_id" value="$args->{form_id}">}
        : "";
    my $pager
        = $args->{hide_pager}
        ? ''
        : qq{\n        <mt:include name="include/pagination.tmpl" bar_position="$pos">};
    my $buttons = $ctx->var('action_buttons') || '';
    my $buttons_html
        = $buttons =~ /\S/
        ? qq{<div class="button-actions actions">$buttons</div>}
        : '';

    return $ctx->build(<<EOT);
$form_id
<div id="actions-bar-$pos" class="actions-bar actions-bar-$pos">
    $pager
    $buttons_html
<mt:include name="include/itemset_action_widget.tmpl">
</div>
EOT
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
    my ( $ctx, $args, $cond ) = @_;
    my $app = MT->instance;

    my %args = %$args;

    # eliminate special '@' argument (and anything other refs that may exist)
    ref( $args{$_} ) && delete $args{$_} for keys %args;

    # strip off any arguments that are actually global filters
    my $filters = MT->registry( 'tags', 'modifier' );
    exists( $filters->{$_} ) && delete $args{$_} for keys %args;

    # remap 'type' attribute since we always express this as
    # a '_type' query parameter.
    my $mode = delete $args{mode}
        or return $ctx->error("mode attribute is required");
    $args{_type} = delete $args{type} if exists $args{type};
    if ( exists $args{blog_id} && !( $args{blog_id} ) ) {
        delete $args{blog_id};
    }
    else {
        if ( my $blog_id = $ctx->var('blog_id') ) {
            $args{blog_id} = $blog_id;
        }
    }
    return $app->uri( mode => $mode, args => \%args );
}

package MT::Template::Tags::System;

use strict;

use MT;
use MT::Util qw( offset_time_list encode_html );
use MT::Request;

{
    my %include_stack;
    my %restricted_include_filenames = (
        'mt-config.cgi' => 1,
        'passwd'        => 1
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
        my ( $ctx, $args, $cond ) = @_;
        my $name = delete $args->{var} || 'contents';

        # defer the evaluation of the child tokens until used inside
        # the block (so any variables/context changes made in that template
        # affect the contained template code)
        my $tokens = $ctx->stash('tokens');
        local $ctx->{__stash}{vars}{lc $name} = sub {
            my $builder = $ctx->stash('builder');
            my $html = $builder->build( $ctx, $tokens, $cond );
            return $ctx->error( $builder->errstr ) unless defined $html;
            return $html;
        };
        return _hdlr_include( $ctx, $args, $cond );
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

=item * name

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

=item * parent (optional; default "0")
Forces an include of a template from the parent website or
current website if current context is 'Website'.

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
        my ( $ctx, $arg, $cond ) = @_;

        # Pass through include arguments as variables to included template
        my $vars = $ctx->{__stash}{vars} ||= {};
        my @names = keys %$arg;
        my @var_names;
        push @var_names, lc $_ for @names;
        local @{$vars}{@var_names};
        $vars->{ lc($_) } = $arg->{$_} for @names;

        # Run include process
        my $out
            = $arg->{module}     ? _include_module(@_)
            : $arg->{widget}     ? _include_module(@_)
            : $arg->{identifier} ? _include_module(@_)
            : $arg->{file}       ? _include_file(@_)
            : $arg->{name}       ? _include_name(@_)
            : $ctx->error(
            MT->translate('No template to include was specified') );

        return $out;
    }

    sub _include_module {
        my ( $ctx, $arg, $cond ) = @_;
        my $tmpl_name = $arg->{module} || $arg->{widget} || $arg->{identifier}
            or return;
        my $name
            = $arg->{widget}     ? 'widget'
            : $arg->{identifier} ? 'identifier'
            :                      'module';
        my $type = $arg->{widget} ? 'widget' : 'custom';
        if ( ( $type eq 'custom' ) && ( $tmpl_name =~ m/^Widget:/ ) ) {

            # handle old-style widget include references
            $type = 'widget';
            $tmpl_name =~ s/^Widget: ?//;
        }

        my $_stash_blog = $ctx->stash('blog');
        my $blog_id
            = $arg->{global}             ? 0
            : defined( $arg->{blog_id} ) ? $arg->{blog_id}
            : $_stash_blog               ? $_stash_blog->id
            :                              0;
        $blog_id = $ctx->stash('local_blog_id') if $arg->{local};

        if ( $arg->{parent} ) {
            return $ctx->error(
                MT->translate(
                    "'parent' modifier cannot be used with '[_1]'", 'global'
                )
            ) if $arg->{global};
            return $ctx->error(
                MT->translate(
                    "'parent' modifier cannot be used with '[_1]'", 'local'
                )
            ) if $arg->{local};

            my $local_blog
                = MT->model('blog')->load( $ctx->stash('local_blog_id') );
            $blog_id = $local_blog->website->id;
        }

        ## Don't know why but hash key has to be encoded
        my $stash_id = Encode::encode_utf8(
            'template_' . $type . '::' . $blog_id . '::' . $tmpl_name );
        return $ctx->error(
            MT->translate(
                "Recursion attempt on [_1]: [_2]", MT->translate($name),
                $tmpl_name
            )
        ) if $include_stack{$stash_id};
        local $include_stack{$stash_id} = 1;

        my $req = MT::Request->instance;
        my ( $tmpl, $tokens );
        if ( my $tmpl_data = $req->stash($stash_id) ) {
            ( $tmpl, $tokens ) = @$tmpl_data;
        }
        else {
            my %terms
                = $arg->{identifier}
                ? ( identifier => $tmpl_name )
                : (
                name => $tmpl_name,
                type => $type
                );
            $terms{blog_id}
                = ( exists $arg->{global} && $arg->{global} ) ? 0
                : ( exists $arg->{parent} && $arg->{parent} ) ? $blog_id
                :   [ $blog_id, 0 ];

            ($tmpl) = MT->model('template')->load(
                \%terms,
                {   sort      => 'blog_id',
                    direction => 'descend',
                }
                )
                or return $ctx->error(
                MT->translate(
                    "Cannot find included template [_1] '[_2]'",
                    MT->translate($name), $tmpl_name
                )
                );

            my $cur_tmpl = $ctx->stash('template');
            return $ctx->error(
                MT->translate(
                    "Recursion attempt on [_1]: [_2]", MT->translate($name),
                    $tmpl_name
                )
                )
                if $cur_tmpl
                    && $cur_tmpl->id
                    && ( $cur_tmpl->id == $tmpl->id );

            $req->stash( $stash_id, [ $tmpl, undef ] );
        }

        my $blog = $ctx->stash('blog') || MT->model('blog')->load($blog_id);

        my %include_recipe;
        my $use_ssi 
            = $blog
            && $blog->include_system
            && ( $arg->{ssi} || $tmpl->include_with_ssi ) ? 1 : 0;
        if ($use_ssi) {

            # disable SSI for templates that are system templates;
            # easiest way to determine this is from the variable
            # space setting.
            if ( $ctx->var('system_template') ) {
                $use_ssi = 0;
            }
            else {
                my $extra_path
                    = ( $arg->{cache_key} || $arg->{key} ) ? $arg->{cache_key}
                    || $arg->{key}
                    : $tmpl->cache_path ? $tmpl->cache_path
                    :                     '';
                %include_recipe = (
                    name => $tmpl_name,
                    id   => $tmpl->id,
                    path => $extra_path,
                );
            }
        }

        # Try to read from cache
        my $enc               = MT->config->PublishCharset;
        my $cache_expire_type = 0;
        my $cache_enabled     = 0;

        if ( $blog && $blog->include_cache ) {
            $cache_expire_type = $tmpl->cache_expire_type || 0;
            $cache_enabled = ( ( $arg->{cache} && $arg->{cache} > 0 )
            || $arg->{cache_key}
            || $arg->{key}
            || ( exists $arg->{ttl} )
            || ( $cache_expire_type != 0 ) ) ? 1 : 0;
        }
        my $cache_key 
            = $arg->{cache_key}
            || $arg->{key}
            || $tmpl->get_cache_key();

      # Delete a cached data if $ttl_for_get seconds have passed since saving.
        my $ttl_for_get
            = exists $arg->{ttl}          ? $arg->{ttl}
            : ( $cache_expire_type == 1 ) ? $tmpl->cache_expire_interval
            : ( $cache_expire_type == 2 ) ? 0
            :                               60 * 60;    # default 60 min.
            # Allow the cache driver to expire data after $ttl_for_set passed.
        my $ttl_for_set = $ttl_for_get;

        if ( $cache_expire_type == 2 ) {
            my @types = split /,/, ( $tmpl->cache_expire_event || '' );
            if (@types) {
                require MT::Touch;
                if ( my $latest
                    = MT::Touch->latest_touch( $blog_id, @types ) )
                {
                    if ($use_ssi) {

                        # base cache expiration on physical file timestamp
                        my $include_file
                            = $blog->include_path( \%include_recipe );
                        my $fmgr  = $blog->file_mgr;
                        my $mtime = $fmgr->file_mod_time($include_file);
                        if ($mtime
                            && ( MT::Util::ts2epoch( undef, $latest, 1 )
                                > $mtime )
                            )
                        {
                            $ttl_for_get = 1;    # bound to force an update
                        }
                    }
                    else {
                        $ttl_for_get
                            = time - MT::Util::ts2epoch( undef, $latest, 1 );
                        $ttl_for_get = 1
                            if $ttl_for_get == 0;    # edited just now.
                    }
                }
            }
        }

        my $cache_driver;
        if ($cache_enabled) {
            my $tmpl_mod = $tmpl->modified_on;
            my $tmpl_ts
                = MT::Util::ts2epoch( $tmpl->blog_id ? $tmpl->blog : undef,
                $tmpl_mod );
            if ( ( $ttl_for_get == 0 ) || ( time - $tmpl_ts < $ttl_for_get ) )
            {
                $ttl_for_get = time - $tmpl_ts;
            }
            require MT::Cache::Negotiate;
            $cache_driver = MT::Cache::Negotiate->new(
                ttl       => $ttl_for_get,
                expirable => 1
            );
            my $cache_value = $cache_driver->get($cache_key);
            $cache_value = Encode::decode( $enc, $cache_value );
            if ($cache_value) {
                return $cache_value if !$use_ssi;

              # The template may still be cached from before we were using SSI
              # for this template, so check that it's also on disk.
                my $include_file = $blog->include_path( \%include_recipe );
                if ( $blog->file_mgr->exists($include_file) ) {
                    return $blog->include_statement( \%include_recipe );
                }
            }
        }

        my $builder = $ctx->{__stash}{builder};
        if ( !$tokens ) {

            # Compile the included template against the includ*ing* template's
            # context.
            $tokens = $builder->compile( $ctx, $tmpl->text );
            unless ( defined $tokens ) {
                $req->cache( 'build_template', $tmpl );
                return $ctx->error( $builder->errstr );
            }
            $tmpl->tokens($tokens);

            $req->stash( $stash_id, [ $tmpl, $tokens ] );
        }

     # Build the included template against the includ*ing* template's context.
        my $ret = $tmpl->build( $ctx, $cond );
        if ( !defined $ret ) {
            $req->cache( 'build_template', $tmpl ) if $tmpl;
            return $ctx->error(
                MT->translate(
                    "Error in [_1] [_2]: [_3]", MT->translate($name),
                    $tmpl_name,                 $tmpl->errstr
                )
            );
        }

        if ($cache_enabled) {
            $cache_driver->set( $cache_key, Encode::encode( $enc, $ret ),
                $ttl_for_set );
        }

        if ($use_ssi) {
            my ( $include_file, $path, $filename )
                = $blog->include_path( \%include_recipe );
            my $fmgr = $blog->file_mgr;
            if ( !$fmgr->exists($path) ) {
                if ( !$fmgr->mkpath($path) ) {
                    return $ctx->error(
                        MT->translate(
                            "Error making path '[_1]': [_2]", $path,
                            $fmgr->errstr
                        )
                    );
                }
            }
            defined( $fmgr->put_data( $ret, $include_file ) )
                or return $ctx->error(
                MT->translate(
                    "Writing to '[_1]' failed: [_2]", $include_file,
                    $fmgr->errstr
                )
                );

            MT->upload_file_to_sync(
                url  => $blog->include_url( \%include_recipe ),
                file => $include_file,
                blog => $blog,
            );

            my $stat = $blog->include_statement( \%include_recipe );
            return $stat;
        }

        return $ret;
    }

    sub _include_file {
        my ( $ctx, $arg, $cond ) = @_;
        if ( !MT->config->AllowFileInclude ) {
            return $ctx->error(
                MT->translate(
                    'File inclusion is disabled by "AllowFileInclude" config directive.'
                )
            );
        }
        my $file = $arg->{file} or return;
        require File::Basename;
        my $base_filename = File::Basename::basename($file);
        if ( exists $restricted_include_filenames{ lc $base_filename } ) {
            return $ctx->error(
                "You cannot include a file with this name: $base_filename");
        }

        my $blog_id = $arg->{blog_id} || $ctx->{__stash}{blog_id} || 0;
        my $stash_id = 'template_file::' . $blog_id . '::' . $file;
        return $ctx->error( "Recursion attempt on file: [_1]", $file )
            if $include_stack{$stash_id};
        local $include_stack{$stash_id} = 1;
        my $req  = MT::Request->instance;
        my $cref = $req->stash($stash_id);
        my $tokens;
        my $builder = $ctx->{__stash}{builder};

        if ($cref) {
            $tokens = $cref;
        }
        else {
            my $blog = $ctx->stash('blog');
            if ( $blog && $blog->id != $blog_id ) {
                $blog = MT::Blog->load($blog_id)
                    or return $ctx->error(
                    MT->translate(
                        "Cannot find blog for id '[_1]", $blog_id
                    )
                    );
            }
            my @paths = ($file);
            push @paths,
                map { File::Spec->catfile( $_, $file ) }
                ( $blog->site_path, $blog->archive_path )
                if $blog;
            my $path;
            for my $p (@paths) {
                $path = $p, last if -e $p && -r _;
            }
            return $ctx->error(
                MT->translate( "Cannot find included file '[_1]'", $file ) )
                unless $path;
            local *FH;
            open FH, $path
                or return $ctx->error(
                MT->translate(
                    "Error opening included file '[_1]': [_2]",
                    $path, $!
                )
                );
            my $c;
            local $/;
            $c = <FH>;
            close FH;
            $tokens = $builder->compile( $ctx, $c );
            return $ctx->error( $builder->errstr ) unless defined $tokens;
            $req->stash( $stash_id, $tokens );
        }
        my $ret = $builder->build( $ctx, $tokens, $cond );
        return defined($ret)
            ? $ret
            : $ctx->error( "error in file $file: " . $builder->errstr );
    }

    sub _include_name {
        my ( $ctx, $arg, $cond ) = @_;
        my $app_file = $arg->{name};

        # app template include mode
        my $mt = MT->instance;
        local $mt->{component} = $arg->{component}
            if exists $arg->{component};
        my $stash_id = 'template_file::' . $app_file;
        return $ctx->error(
            MT->translate( "Recursion attempt on file: [_1]", $app_file ) )
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
            $mt->run_callbacks( 'template_param' . $tmpl_file,
                $mt, $tmpl->param, $tmpl );

            # propagate our context
            local $tmpl->{context} = $ctx;
            my $out = $tmpl->output();
            return $ctx->error( $tmpl->errstr ) unless defined $out;

            $mt->run_callbacks( 'template_output' . $tmpl_file,
                $mt, \$out, $tmpl->param, $tmpl );
            return $out;
        }
        else {
            return defined $arg->{default} ? $arg->{default} : '';
        }
    }
}

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
    my ( $ctx, $args, $cond ) = @_;
    my $app = MT->instance;
    my $out;
    my $cache_require;
    my $enc = MT->config->PublishCharset || 'UTF-8';

    # make cache id
    my $cache_id = $args->{cache_prefix} || undef;

    my $tmpl = $ctx->{__stash}{template};
    $cache_id .= ':' . $tmpl->id if $tmpl && $tmpl->id;

    # read timeout. if timeout == 0 then, content is never cached.
    my $timeout = $args->{period};
    $timeout = $app->config('DashboardCachePeriod') if !defined $timeout;
    if ( defined $timeout && ( $timeout > 0 ) ) {
        if ( defined $cache_id ) {
            if ( $args->{by_blog} ) {
                my $blog = $app->blog;
                $cache_id .= ':blog_id=';
                $cache_id .= $blog ? $blog->id : '0';
            }
            if ( $args->{by_user} ) {
                my $author = $app->user
                    or
                    return $ctx->error( MT->translate("Cannot load user.") );
                $cache_id .= ':user_id=' . $author->id;
            }

            # try to load from session
            require MT::Session;
            my $sess = MT::Session::get_unexpired_value( $timeout,
                { id => $cache_id, kind => 'CO' } );    # CO == Cache Object
            if ( defined $sess ) {
                ## need to decode by hand for blob typed column.
                my $data = $sess->data();
                $data = MT::I18N::utf8_off($data) if MT::I18N::is_utf8($data);
                my $out = Encode::decode( $enc, $data );
                if ($out) {
                    if ( my $wrap_tag = $args->{html_tag} ) {
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
    defined( $out
            = $ctx->stash('builder')
            ->build( $ctx, $ctx->stash('tokens'), $cond ) )
        or return $ctx->error( $ctx->stash('builder')->errstr );

    if ( $cache_require && ( defined $cache_id ) ) {
        my $sess = MT::Session->load( { id => $cache_id, kind => 'CO' } );
        if ($sess) {
            $sess->remove();
        }
        $sess = MT::Session->new;
        $sess->set_values(
            {   id    => $cache_id,
                kind  => 'CO',
                start => time,
                data  => Encode::encode( $enc, $out )
            }
        );
        $sess->save();
    }

    if ( my $wrap_tag = $args->{html_tag} ) {
        my $id = $args->{id};
        $id = " id=\"$id\"" if $id;
        $id = '' unless defined $id;
        $out = "<$wrap_tag$id>" . $out . "</$wrap_tag>";
    }
    return $out;
}

###########################################################################

=head2 Link

Generates the absolute URL to an index template or specific entry in the system.

B<NOTE:> Only one of the 'template' or 'entry_id' attributes can be specified
at a time.

B<Attributes:>

=over 4

=item * template

The index template to which to link. This attribute should be the template's
name, identifier, or outfile.

=item * entry_id

The numeric system ID of the entry. This attribute can not use with blog_id.

=item * blog_id

The numeric system ID of the blog/website. This attribute can not use with entry_id.

=item * with_index (optional; default "0")

If not set to 1, remove index filenames (by default, index.html)
from resulting links.

=back

B<Examples:>

    <a href="<mt:Link template="About Page">">My About Page</a>

    <a href="<mt:Link template="main_index">">Blog Home</a>

    <a href="<mt:Link entry_id="221">">the entry about my vacation</a>

=for tags archives
=cut

sub _hdlr_link {
    my ( $ctx, $arg, $cond ) = @_;
    my $curr_blog = $ctx->stash('blog');
    if ( my $tmpl_name = $arg->{template} ) {
        my $blog
            = $arg->{blog_id}
            ? MT->model('blog')->load( $arg->{blog_id} )
            : $curr_blog;
        my $blog_id = $blog->id;
        require MT::Template;
        my $tmpl = MT::Template->load(
            {   identifier => $tmpl_name,
                type       => 'index',
                blog_id    => $blog_id
            }
            )
            || MT::Template->load(
            {   name    => $tmpl_name,
                type    => 'index',
                blog_id => $blog_id
            }
            )
            || MT::Template->load(
            {   outfile => $tmpl_name,
                type    => 'index',
                blog_id => $blog_id
            }
            )
            or return $ctx->error(
            MT->translate( "Cannot find template '[_1]'", $tmpl_name ) );
        my $site_url = $blog->site_url;
        $site_url .= '/' unless $site_url =~ m!/$!;
        my $link = $site_url . $tmpl->outfile;
        $link = MT::Util::strip_index( $link, $curr_blog )
            unless $arg->{with_index};
        $link;
    }
    elsif ( my $entry_id = $arg->{entry_id} ) {
        my $entry = MT::Entry->load($entry_id)
            or return $ctx->error(
            MT->translate( "Cannot find entry '[_1]'", $entry_id ) );
        my $link = $entry->permalink;
        $link = MT::Util::strip_index( $link, $curr_blog )
            unless $arg->{with_index};
        $link;
    }
}

###########################################################################

=head2 CanonicalURL

Generates the canonical URL to template built now.

B<Attributes:>

=over 4

=item * current_mapping (optional; default "0")

If not set to 1, use the URL of preferred mapping if current archive type
has some mapping.

=item * with_index (optional; default "0")

If not set to 1, remove index filenames (by default, index.html)
from resulting links.

=back

B<Examples:>
    <link rel="canonical" href="<mt:CanonicalURL encode_html="1">" />

=cut

sub _hdlr_canonical_url {
    my ( $ctx, $args ) = @_;

    my $blog = $ctx->stash('blog')
        or return '';
    my $url
        = (   !$args->{current_mapping}
            && $ctx->stash('preferred_mapping_url') )
        || $ctx->stash('current_mapping_url');
    $url = $url->() if ref $url;

    return '' unless $url;

    $args->{with_index}
        ? $url
        : MT::Util::strip_index( $url, $blog );
}

###########################################################################

=head2 CanonicalLink

Generates a link tag of the canonical URL to template built now.

B<Attributes:>

=over 4

=item * current_mapping (optional; default "0")

If not set to 1, use the URL of preferred mapping if current archive type
has some mapping.

=item * with_index (optional; default "0")

If not set to 1, remove index filenames (by default, index.html)
from resulting links.

=back

=cut

sub _hdlr_canonical_link {
    my ( $ctx, $args ) = @_;

    my $handler = $ctx->handler_for('canonicalurl');
    my $url = $handler->invoke( $ctx, $args ) or return '';

    '<link rel="canonical" href="' . encode_html($url) . '" />';
}

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
    my ( $ctx, $args ) = @_;
    unless ( $args->{ts} ) {
        my $t = time;
        my @ts = offset_time_list( $t, $ctx->stash('blog_id') );
        $args->{ts} = sprintf "%04d%02d%02d%02d%02d%02d",
            $ts[5] + 1900, $ts[4] + 1, @ts[ 3, 2, 1, 0 ];
    }
    return $ctx->build_date($args);
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
    my ( $ctx, $args, $cond ) = @_;
    my $path = $ctx->cgi_path;
    if ( $path =~ m!^https?://([^/:]+)(:\d+)?/! ) {
        return $args->{exclude_port} ? $1 : $1 . ( $2 || '' );
    }
    else {
        return '';
    }
}

###########################################################################

=head2 CGIPath

The value of the C<CGIPath> configuration setting. Example (the output
is guaranteed to end with "/", so appending one prior to a script
name is unnecessary):

    <a href="<$mt:CGIPath$>some-cgi-script.cgi">

=for tags configuration

=cut

sub _hdlr_cgi_path { shift->cgi_path }

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
    if ( $path =~ m!^/! ) {

        # relative path, prepend blog domain
        my $blog = $ctx->stash('blog');
        my ($blog_domain) = $blog->archive_url =~ m|(.+://[^/]+)|;
        $path = $blog_domain . $path;
    }
    $path .= '/' unless $path =~ m!/$!;
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
    if ( $url =~ m!^https?://[^/]+(/.*)$! ) {
        return $1;
    }
    return $url;
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

=head2 StaticFilePath

The file path to the directory where Movable Type's static files are
stored (as configured by the C<StaticFilePath> setting, or based on
the location of the MT application files alone). This value is
guaranteed to end with a "/" character.

=for tags configuration

=cut

sub _hdlr_static_file_path {
    my ($ctx) = @_;
    my $cfg   = $ctx->{config};
    my $path  = $cfg->StaticFilePath;
    if ( !$path ) {
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
    my $cfg   = $ctx->{config};
    my $path  = $cfg->StaticWebPath;
    if ( !$path ) {
        $path = $cfg->CGIPath;
        $path .= '/' unless $path =~ m!/$!;
        $path .= 'mt-static/';
    }
    if ( $path =~ m!^/! ) {

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

=head2 SupportDirectoryURL

The value of the C<SupportDirectoryURL> configuration setting. This value is
guaranteed to end with a "/" character.

=for tags configuration

=cut

sub _hdlr_support_directory_url {
    my ($ctx) = @_;
    return MT->support_directory_url;
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
    my ( $ctx, $args, $cond ) = @_;
    require MT;
    my $short_name = MT->translate( MT->product_name );
    if ( $args->{version} ) {
        return MT->translate( "[_1] [_2]", $short_name, MT->version_id );
    }
    else {
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

=head2 ConfigFile

Returns the full file path for the Movable Type configuration file
(mt-config.cgi).

=for tags configuration

=cut

sub _hdlr_config_file {
    return MT->instance->{cfg_file};
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
    my ( $ctx, $args, $cond ) = @_;
    my $name = $ctx->{config}->IndexBasename;
    if ( !$args->{extension} ) {
        return $name;
    }
    my $blog = $ctx->stash('blog');
    my $ext  = $blog->file_extension;
    $ext = '.' . $ext if $ext;
    $name . $ext;
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
    my ( $ctx, $args ) = @_;
    my $type = $args->{type};
    $ctx->stash( 'content_type', $type );
    return qq{};
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

{
    my %tokens_cache;

    sub _hdlr_file_template {
        my ( $ctx, $args, $cond ) = @_;

        my $at = $ctx->{current_archive_type} || $ctx->{archive_type};
        $at = 'Category' if $ctx->{inside_mt_categories};
        my $format = $args->{format};
        unless ($format) {
            my $archiver = MT->publisher->archiver($at);
            $format = $archiver->default_archive_templates if $archiver;
        }
        return $ctx->error( MT->translate("Unspecified archive template") )
            unless $format;

        my ( $dir, $sep );
        if ( $args->{separator} ) {
            $dir = "dirify='$args->{separator}'";
            $sep = "separator='$args->{separator}'";
        }
        else {
            $dir = "dirify='1'";
            $sep = "";
        }
        my %f = (
            'a'  => "<MTAuthorBasename $dir>",
            '-a' => "<MTAuthorBasename separator='-'>",
            '_a' => "<MTAuthorBasename separator='_'>",
            'b'  => "<MTEntryBasename $sep>",
            '-b' => "<MTEntryBasename separator='-'>",
            '_b' => "<MTEntryBasename separator='_'>",
            'c'  => "<MTSubCategoryPath $sep>",
            '-c' => "<MTSubCategoryPath separator='-'>",
            '_c' => "<MTSubCategoryPath separator='_'>",
            'C'  => "<MTCategoryBasename $sep>",
            '-C' => "<MTCategoryBasename separator='-'>",
            'd'  => "<MTArchiveDate format='%d'>",
            'D'  => "<MTArchiveDate format='%e' trim='1'>",
            'e'  => "<MTEntryID pad='1'>",
            'E'  => "<MTEntryID pad='0'>",
            'f'  => "<MTArchiveFile $sep>",
            '-f' => "<MTArchiveFile separator='-'>",
            'F'  => "<MTArchiveFile extension='0' $sep>",
            '-F' => "<MTArchiveFile extension='0' separator='-'>",
            'h'  => "<MTArchiveDate format='%H'>",
            'H'  => "<MTArchiveDate format='%k' trim='1'>",
            'i'  => '<MTIndexBasename extension="1">',
            'I'  => "<MTIndexBasename>",
            'j' => "<MTArchiveDate format='%j'>",    # 3-digit day of year
            'm' => "<MTArchiveDate format='%m'>",    # 2-digit month
            'M' => "<MTArchiveDate format='%b'>",    # 3-letter month
            'n' => "<MTArchiveDate format='%M'>",    # 2-digit minute
            's' => "<MTArchiveDate format='%S'>",    # 2-digit second
            'x' => "<MTBlogFileExtension>",
            'y' => "<MTArchiveDate format='%Y'>",    # year
            'Y' => "<MTArchiveDate format='%y'>",    # 2-digit year
            'p' =>
                "<mt:PagerBlock><mt:IfCurrentPage><mt:Var name='__value__'></mt:IfCurrentPage></mt:PagerBlock>"
            ,                                        # current page number
            '_Z' => "<MTArchiveDate format='%Y/%m'>"
            ,    # year/month, used as default archive map

        );
        $format =~ s!%y/%m!%_Z!g if defined $format;
        $format =~ s!%([_-]?[A-Za-z])!$f{$1}!g if defined $format;

        # now build this template and return result
        my $builder = $ctx->stash('builder');
        my $tok     = $tokens_cache{$format}
            ||= $builder->compile( $ctx, $format );
        return $ctx->error(
            MT->translate( "Error in file template: [_1]", $args->{format} ) )
            unless defined $tok;
        defined( my $file = $builder->build( $ctx, $tok, $cond ) )
            or return $ctx->error( $builder->errstr );
        $file =~ s!/{2,}!/!g;
        $file =~ s!(^/|/$)!!g;
        $file;
    }
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
    my ( $ctx, $args, $cond ) = @_;
    my $template = $ctx->stash('template')
        or return $ctx->error( MT->translate("Cannot load template") );
    $args->{ts} = $template->created_on;
    $ctx->build_date($args);
}

###########################################################################

=head2 BuildTemplateID

Returns the ID of the template (index, archive or system template) currently
being built.

=cut

sub _hdlr_build_template_id {
    my ( $ctx, $args, $cond ) = @_;
    my $tmpl = $ctx->stash('template');
    if ( $tmpl && $tmpl->id ) {
        return $tmpl->id;
    }
    return 0;
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

=head2 PasswordValidation

This tag add a password validation JavaScript to a form (user profile,
new installation) where ever a user need to insert a new password

As one of the rules are that the password should not include the user name,
The script will try to fish inside the form for the username, (checking
name, admin_name) and if not exists will use the logined user name

B<Attributes:>

=over 4

=item * form

The name of the form this tag will letch on

=item * password

The name of the password field in the form this tag will check

=item * username

The name of the usrname field in the form to be checked against the password
If this name is empty string, the username will not be checked.

=back

B<Example:>

    <$mt:PasswordValidation form="profile" password="pass" username="name"$>

=cut

sub _hdlr_password_validation_script {
    my ( $ctx, $args ) = @_;
    my $form_id    = $args->{form};
    my $pass_field = $args->{password};
    my $user_field = $args->{username};
    my $app        = MT->instance;

    return $ctx->error(
        MT->translate(
            "You used an [_1] tag without a valid [_2] attribute.",
            "<MTPasswordValidation>", "form"
        )
    ) unless defined $form_id;

    return $ctx->error(
        MT->translate(
            "You used an [_1] tag without a valid [_2] attribute.",
            "<MTPasswordValidation>", "password"
        )
    ) unless defined $pass_field;

    $user_field ||= '';
    my @constrains = $app->config('UserPasswordValidation');
    my $min_length = $app->config('UserPasswordMinLength');
    if ( ( $min_length =~ m/\D/ ) or ( $min_length < 1 ) ) {
        $min_length = $app->config->default('UserPasswordMinLength');
    }

    my $vs = "\n";
    $vs .= << "JSCRIPT";
        function verify_password(username, passwd) {
          if (passwd.length < $min_length) {
            return "<__trans phrase="Password should be longer than [_1] characters" params="$min_length">";
          }
          if (username && (passwd.toLowerCase().indexOf(username.toLowerCase()) > -1)) {
            return "<__trans phrase="Password should not include your Username">";
          }
JSCRIPT

    if ( grep { $_ eq 'letternumber' } @constrains ) {
        $vs .= << 'JSCRIPT';
            if ((passwd.search(/[a-zA-Z]/) == -1) || (passwd.search(/\d/) == -1)) {
              return "<__trans phrase="Password should include letters and numbers">";
            }
JSCRIPT

    }
    if ( grep { $_ eq 'upperlower' } @constrains ) {
        $vs .= << 'JSCRIPT';
            if (( passwd.search(/[a-z]/) == -1) || (passwd.search(/[A-Z]/) == -1)) {
              return "<__trans phrase="Password should include lowercase and uppercase letters">";
            }
JSCRIPT

    }
    if ( grep { $_ eq 'symbol' } @constrains ) {
        $vs .= << 'JSCRIPT';
            if ( passwd.search(/[!"#$%&'\(\|\)\*\+,-\.\/\\:;<=>\?@\[\]^_`{}~]/) == -1 ) {
              return "<__trans phrase="Password should contain symbols such as #!$%">";
            }
JSCRIPT

    }
    $vs .= << 'JSCRIPT';
          return "";
        }
JSCRIPT

    $vs .= << "JSCRIPT";
        jQuery(document).ready(function() {
            jQuery("form#$form_id").submit(function(e){
                var form = jQuery(this);
                var passwd_input = form.find("input[name=$pass_field]");
                if ( !passwd_input.is(":visible") ) {
                    return true;
                }
                var passwd = passwd_input.val();
                if (passwd == null || passwd == "") {
                    return true;
                }
                var username = "$user_field" ? form.find("input[name=$user_field]").val() : "";
                var error = verify_password(username, passwd);
                if (error == "") {
                    return true;
                }
                alert(error);
                e.preventDefault();
                return false;
            });
        });
JSCRIPT

    return $vs;
}

###########################################################################

=head2 PasswordValidationRule

A string explaining the effective password policy

=cut

sub _hdlr_password_validation_rules {
    my ($ctx) = @_;

    my $app = MT->instance;

    my @constrains = $app->config('UserPasswordValidation');
    my $min_length = $app->config('UserPasswordMinLength');
    if ( ( $min_length =~ m/\D/ ) or ( $min_length < 1 ) ) {
        $min_length = $app->config->default('UserPasswordMinLength');
    }

    my $msg = $app->translate( "minimum length of [_1]", $min_length );
    $msg .= $app->translate(', uppercase and lowercase letters')
        if grep { $_ eq 'upperlower' } @constrains;
    $msg .= $app->translate(', letters and numbers')
        if grep { $_ eq 'letternumber' } @constrains;
    $msg .= $app->translate(', symbols (such as #!$%)')
        if grep { $_ eq 'symbol' } @constrains;

    return $msg;
}

1;
__END__
