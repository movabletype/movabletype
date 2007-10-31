package MT::Core;

use strict;
use MT;
use base 'MT::Component';

# This is just to make our localization scanner happy
sub trans {
    return shift;
}

sub name {
    return "Core";
}

my $core_registry;

BEGIN {
    $core_registry = {
        version        => MT->VERSION,
        schema_version => MT->schema_version,
        object_drivers => {
            'mysql' => {
                label => 'MySQL Database',
                dbd_package => 'DBD::mysql',
                config_package => 'DBI::mysql',
            },
            'postgres' => {
                label => 'PostgreSQL Database',
                dbd_package => 'DBD::Pg',
                dbd_version => '1.32',
                config_package => 'DBI::postgres',
            },
            'sqlite' => {
                label => 'SQLite Database',
                dbd_package => 'DBD::SQLite',
                dbd_version => '1.11',
                config_package => 'DBI::sqlite',
            },
            #'sqlite2' => {
            #    label => 'SQLite Database (v2)',
            #    dbd_package => 'DBD::SQLite2',
            #    config_package => 'DBI::sqlite',
            #},
        },
        object_types   => {
            'entry'           => 'MT::Entry',
            'author'          => 'MT::Author',
            'asset'           => 'MT::Asset',
            'asset.image'     => 'MT::Asset::Image',
            'entry.page'      => 'MT::Page',
            'page'            => 'MT::Page',
            'category.folder' => 'MT::Folder',
            'folder'          => 'MT::Folder',
            'category'        => 'MT::Category',
            'user'            => 'MT::Author',
            'commenter'       => 'MT::Author',
            'blog'            => 'MT::Blog',
            'template'        => 'MT::Template',
            'comment'         => 'MT::Comment',
            'notification'    => 'MT::Notification',
            'templatemap'     => 'MT::TemplateMap',
            'banlist'         => 'MT::IPBanList',
            'tbping'          => 'MT::TBPing',
            'ping'            => 'MT::TBPing',
            'ping_cat'        => 'MT::TBPing',
            'log'             => 'MT::Log',
            'log.ping'        => 'MT::Log::TBPing',
            'log.entry'       => 'MT::Log::Entry',
            'log.comment'     => 'MT::Log::Comment',
            'log.system'      => 'MT::Log',
            'tag'             => 'MT::Tag',
            'role'            => 'MT::Role',
            'association'     => 'MT::Association',
            'permission'      => 'MT::Permission',
            'fileinfo'        => 'MT::FileInfo',
            'placement'       => 'MT::Placement',
            'plugindata'      => 'MT::PluginData',
            'session'         => 'MT::Session',
            'trackback'       => 'MT::Trackback',
            'config'          => 'MT::Config',
            'objecttag'       => 'MT::ObjectTag',
            'objectscore'     => 'MT::ObjectScore',
            'objectasset'     => 'MT::ObjectAsset',
        },
        permissions => {
            'system.administer' => {
                label => trans("System Administrator"),
                group => 'sys_admin',
                order => 0,
            },
            'system.create_blog' => {
                label => trans("Create Blogs"),
                group => 'sys_admin',
                order => 100,
            },
            'system.manage_plugins' => {
                label => trans('Manage Plugins'),
                group => 'sys_admin',
                order => 200,
            },
            'system.view_log' => {
                label => trans("View System Activity Log"),
                group => 'sys_admin',
                order => 300,
            },

            'blog.administer_blog' => {
                label => trans("Blog Administrator"),
                group => 'blog_admin',
                order => 0,
            },
            'blog.edit_config' => {
                label => trans("Configure Blog"),
                group => 'blog_admin',
                order => 100,
            },
            'blog.set_publish_paths' => {
                label => trans('Set Publishing Paths'),
                group => 'blog_admin',
                order => 200,
            },
            'blog.edit_categories' => {
                label => trans('Manage Categories'),
                group => 'blog_admin',
                order => 300,
            },
            'blog.edit_tags' => {
                label => trans('Manage Tags'),
                group => 'blog_admin',
                order => 400,
            },
            'blog.edit_notifications' => {
                label => trans('Manage Notification List'),
                group => 'blog_admin',
                order => 500,
            },
            'blog.view_blog_log' => {
                label => trans('View Activity Log'),
                group => 'blog_admin',
                order => 600,
            },

            'blog.create_post' => {
                label => trans('Create Entries'),
                group => 'auth_pub',
                order => 100,
            },
            'blog.publish_post' => {
                label => trans('Publish Post'),
                group => 'auth_pub',
                order => 200,
            },
            'blog.send_notifications' => {
                label => trans('Send Notifications'),
                group => 'auth_pub',
                order => 300,
            },
            'blog.edit_all_posts' => {
                label => trans('Edit All Entries'),
                group => 'auth_pub',
                order => 400,
            },
            'blog.manage_pages' => {
                label => trans('Manage Pages'),
                group => 'auth_pub',
                order => 500,
            },
            'blog.rebuild' => {
                label => trans('Rebuild Files'),
                group => 'auth_pub',
                order => 600,
            },

            'blog.edit_templates' => {
                label => trans('Manage Templates'),
                group => 'blog_design',
                order => 100,
            },

            'blog.upload' => {
                label => trans("Upload File"),
                group => 'blog_upload',
                order => 100,
            },
            'blog.save_image_defaults' => {
                label => trans('Save Image Defaults'),
                group => 'blog_upload',
                order => 200,
            },
            'blog.edit_assets' => {
                label => trans('Manage Assets'),
                group => 'blog_upload',
                order => 300,
            },

            'blog.comment' => {
                label => trans("Post Comments"),
                group => 'blog_comment',
                order => 100,
            },
            'blog.manage_feedback' => {
                label => trans('Manage Feedback'),
                group => 'blog_comment',
                order => 200,
            },
        },
        config_settings => {
            'AtomApp' => {
                type    => 'HASH',
                default => 'weblog=MT::AtomServer::Weblog'
            },
            'SchemaVersion'   => undef,
            'Database'        => undef,
            'DBHost'          => undef,
            'DBSocket'        => undef,
            'DBPort'          => undef,
            'DBUser'          => undef,
            'DBPassword'      => undef,
            'DefaultLanguage' => {
                default => 'en_US',    # FIXME: make a handler for this
            },
            'DefaultSiteRoot' => { default => '', },
            'DefaultSiteURL'  => { default => '', },
            'TemplatePath'    => {
                default => 'tmpl',
                path    => 1,
            },
            'WeblogTemplatesPath' => {
                default => 'default_templates',
                path    => 1,
            },
            'AltTemplatePath' => {
                default => 'alt-tmpl',
                path    => 1,
            },
            'CSSPath'    => { default => 'css', },
            'ImportPath' => {
                default => 'import',
                path    => 1,
            },
            'PluginPath' => {
                default => 'plugins',
                path    => 1,
                type    => 'ARRAY',
            },
            'EnableArchivePaths' => { default => 0, },
            'SearchTemplatePath' => {
                default => 'search_templates',
                path    => 1,
            },
            'ObjectDriver'  => undef,
            'Serializer'    => { default => 'MT', },
            'SendMailPath'  => { default => '/usr/lib/sendmail', },
            'TimeOffset'    => { default => 0, },
            'WSSETimeout'   => { default => 120, },
            'StaticWebPath' => { default => '', },
            'StaticFilePath' => undef,
            'CGIPath'       => { default => '/cgi-bin/', },
            'AdminCGIPath'  => undef,
            'CookieDomain'  => undef,
            'CookiePath'    => undef,
            'MailEncoding'  => {
                default => 'ISO-8859-1',    # FIXME: make a handler for this
            },
            'MailTransfer'      => { default => 'sendmail' },
            'SMTPServer'        => { default => 'localhost', },
            'DebugEmailAddress' => undef,
            'WeblogsPingURL' => { default => 'http://rpc.weblogs.com/RPC2', },
            'BlogsPingURL'   => { default => 'http://ping.blo.gs/', },
            'MTPingURL' => { default => 'http://www.movabletype.org/update/', },
            'TechnoratiPingURL' =>
              { default => 'http://rpc.technorati.com/rpc/ping', },
            'GooglePingURL' =>
              { default => 'http://blogsearch.google.com/ping/RPC2', },
            'CGIMaxUpload'          => { default => 10_000_000 },
            'DBUmask'               => { default => '0111', },
            'HTMLUmask'             => { default => '0111', },
            'UploadUmask'           => { default => '0111', },
            'DirUmask'              => { default => '0000', },
            'HTMLPerms'             => { default => '0666', },
            'UploadPerms'           => { default => '0666', },
            'NoTempFiles'           => { default => 0, },
            'TempDir'               => { default => '/tmp', },
            'EntriesPerRebuild'     => { default => 40, },
            'UseNFSSafeLocking'     => { default => 0, },
            'NoLocking'             => { default => 0, },
            'NoHTMLEntities'        => { default => 1, },
            'NoCDATA'               => { default => 0, },
            'NoPlacementCache'      => { default => 0, },
            'NoPublishMeansDraft'   => { default => 0, },
            'IgnoreISOTimezones'    => { default => 0, },
            'PingTimeout'           => { default => 60, },
            'HTTPTimeout'           => { default => 60 },
            'PingInterface'         => undef,
            'HTTPInterface'         => undef,
            'PingProxy'             => undef,
            'HTTPProxy'             => undef,
            'PingNoProxy'           => { default => 'localhost', },
            'HTTPNoProxy'           => { default => 'localhost', },
            'ImageDriver'           => { default => 'ImageMagick', },
            'NetPBMPath'            => undef,
            'AdminScript'           => { default => 'mt.cgi', },
            'ActivityFeedScript'    => { default => 'mt-feed.cgi', },
            'ActivityFeedItemLimit' => { default => 50, },
            'CommentScript'         => { default => 'mt-comments.cgi', },
            'TrackbackScript'       => { default => 'mt-tb.cgi', },
            'SearchScript'          => { default => 'mt-search.cgi', },
            'XMLRPCScript'          => { default => 'mt-xmlrpc.cgi', },
            'ViewScript'            => { default => 'mt-view.cgi', },
            'AtomScript'            => { default => 'mt-atom.cgi', },
            'UpgradeScript'         => { default => 'mt-upgrade.cgi', },
            'PublishCharset'        => {
                default => 'utf-8',    # FIXME: make a handler for this
            },
            'SafeMode'           => { default => 1, },
            'GlobalSanitizeSpec' => {
                default => 'a href,b,i,br/,p,strong,em,ul,ol,li,blockquote,pre',
            },
            'GenerateTrackBackRSS' => { default => 0, },

            ## Search settings, copied from Jay's mt-search and integrated
            ## into default config.
            'NoOverride'          => { default => '', },
            'RegexSearch'         => { default => 0, },
            'CaseSearch'          => { default => 0, },
            'ResultDisplay'       => { default => 'descend', },
            'ExcerptWords'        => { default => 40, },
            'SearchElement'       => { default => 'entries', },
            'ExcludeBlogs'        => undef,
            'IncludeBlogs'        => undef,
            'DefaultTemplate'     => { default => 'default.tmpl', },
            'Type'                => { default => 'straight', },
            'MaxResults'          => { default => '100', },
            'SearchCutoff'        => { default => '9999999', },
            'CommentSearchCutoff' => { default => '30', },
            'AltTemplate'         => {
                type    => 'ARRAY',
                default => 'feed results_feed.tmpl',
            },
            'SearchSortBy'    => undef,
            'SearchSortOrder' => { default => 'ascend', },
            'RegKeyURL' =>
              { default => 'http://www.typekey.com/extras/regkeys.txt', },
            'IdentitySystem' =>
              { default => 'http://www.typekey.com/t/typekey', },
            'SignOnURL' =>
              { default => 'https://www.typekey.com/t/typekey/login?', },
            'SignOffURL' =>
              { default => 'https://www.typekey.com/t/typekey/logout?', },
            'IdentityURL'     => { default => "http://profile.typekey.com/", },
            'DynamicComments' => { default => 0, },
            'SignOnPublicKey' => { default => '', },
            'ThrottleSeconds' => { default => 20, },
            'SearchThrottleIPWhitelist' => undef,
            'OneHourMaxPings'           => { default => 10, },
            'OneDayMaxPings'            => { default => 50, },
            'SupportURL'                => {
                default => 'http://www.sixapart.com/movabletype/support/'
                ,    # FIXME: make a handler for this
            },
            'NewsURL' => {
                default => 'http://www.sixapart.com/movabletype/news/'
                ,    # FIXME: make a handler for this
            },
            'NewsboxURL' => {
                default => 'http://www.movabletype.org/mt4_news_widget.html'
                ,    # FIXME: make a handler for this
            },
            # 'MTNewsURL' => {
            #     default => 'http://www.sixapart.com/movabletype/news/mt4_news_widget.html',
            # },
            # 'LearningNewsURL' => {
            #     default => 'http://learning.movabletype.org/newsbox.html',
            # },
            # 'HackingNewsURL' => {
            #     default => 'http://hacking.movabletype.org/newsbox.html',
            # },
            'EmailAddressMain'      => undef,
            'EmailReplyTo'          => undef,
            'EmailNotificationBcc'  => { default => 1, },
            'CommentSessionTimeout' => { default => 60 * 60 * 1, },
            'UserSessionTimeout'    => { default => 60 * 60 * 4, },
            'LaunchBackgroundTasks' => { default => 0 },
            'TypeKeyVersion'        => { default => '1.1' },
            'TransparentProxyIPs'   => { default => 0, },
            'DebugMode'             => { default => 0, },
            'PublishCommenterIcon'  => { default => 1, },
            'ShowIPInformation'     => { default => 0, },
            'AllowComments'         => { default => 1, },
            'AllowPings'            => { default => 1, },
            'HelpURL'               => {
                default => 'http://www.sixapart.com/movabletype/docs/4.0/'
                ,    # FIXME: make a handler for this
            },
            'UsePlugins'               => { default => 1, },
            'PluginSwitch'             => { type    => 'HASH', },
            'PluginSchemaVersion'      => { type    => 'HASH', },
            'OutboundTrackbackLimit'   => { default => 'any', },
            'OutboundTrackbackDomains' => { type    => 'ARRAY', },
            'IndexBasename'            => { default => 'index', },
            'LogExportEncoding'        => {
                default => 'utf-8',    # FIXME: make a handler for this
            },
            'ActivityFeedsRunTasks' => { default => 1, },
            'ExportEncoding'        => {
                default => 'utf-8',    # FIXME: make a handler for this
            },
            'SQLSetNames'     => undef,
            'UseSQLite2'      => { default => 0, },
            'UseJcodeModule'  => { default => 0, },
            'DefaultTimezone' => {
                default => '0',        # FIXME: make a handler for this
            },
            'CategoryNameNodash' => {
                default => '0',        # FIXME: make a handler for this
            },
            'DefaultListPrefs' => {
                type    => 'HASH',
                default => {
                    Rows       => 20,
                    Format     => 'Compact',     # Compact|Expanded
                    SortOrder  => 'Ascend',      # Ascend|Descend
                    Button     => 'Above',       # Above|Below|Both
                    DateFormat => 'Relative',    # Relative|Full
                },
            },
            'DefaultEntryPrefs' => {
                type    => 'HASH',
                default => {
                    type   => 'Default',         # Default|All|Custom
                    button => 'Below',           # Above|Below|Both
                    height => 162,               # textarea height
                },
            },
            'DeleteFilesAtRebuild'      => { default => 1, },
            'MaxTagAutoCompletionItems' => { default => 10000, },
            'NewUserAutoProvisioning' =>
              { handler => \&NewUserAutoProvisioning, },
            'NewUserTemplateBlogId'   => undef,
            'DefaultUserLanguage'     => undef,
            'DefaultUserTagDelimiter' => {
                handler => \&DefaultUserTagDelimiter,
                default => 'comma',
            },
            'AuthenticationModule' => { default => 'MT', },
            'AuthLoginURL'         => undef,
            'AuthLogoutURL'        => undef,
            'DefaultAssignments'   => undef,
            ## External Sync settings
            'ExternalUserManagement' => {
                default => 1,
                handler => \&ExternalUserManagement,
            },
            'FuturePostFrequency'       => { default => 1 },
            'ExternalUserSyncFrequency' => { default => 60 },
            'AssetCacheDir'             => { default => 'assets_c', },
            'MemcachedServers'          => { type    => 'ARRAY', },
            'CommenterRegistration'     => {
                type    => 'HASH',
                default => {
                    Allow  => '0',
                    Notify => q(),
                },
            },
            'UseCommentConfirmationPage' => { default => 1, },
            'CaptchaSourceImageBase'     => undef,
            'CaptchaProvider'            => undef,
            'SecretToken'                => { handler => \&SecretToken, },
            ## NaughtyWordChars settings
            'NwcSmartReplace' => { default => 0, },
            'NwcReplaceField' =>
              { default => 'title,text,text_more,keywords,excerpt,tags', },
        },
        upgrade_functions => \&load_upgrade_fns,
        applications      => {
            'xmlrpc'   => { handler => 'MT::XMLRPCServer', },
            'atom'     => { handler => 'MT::AtomServer', },
            'feeds'    => { handler => 'MT::App::ActivityFeeds', },
            'view'     => { handler => 'MT::App::Viewer', },
            'notify'   => { handler => 'MT::App::NotifyList', },
            'tb'       => { handler => 'MT::App::Trackback', },
            'upgrade'  => { handler => 'MT::App::Upgrade', },
            'wizard'   => { handler => 'MT::App::Wizard', },
            'comments' => { handler => 'MT::App::Comments', },
            'search'   => {
                handler => 'MT::App::Search', 
                tags => sub { MT->app->load_core_tags },
            },
            'cms'      => {
                handler        => 'MT::App::CMS',
                cgi_base       => 'mt',
                page_actions   => sub { MT->app->core_page_actions(@_) },
                list_actions   => sub { MT->app->core_list_actions(@_) },
                list_filters   => sub { MT->app->core_list_filters(@_) },
                menus          => sub { MT->app->core_menus() },
                methods        => sub { MT->app->core_methods() },
                widgets        => sub { MT->app->core_widgets() },
                import_formats => sub {
                    require MT::Import;
                    return MT::Import->core_import_formats();
                },
            },
        },
        archive_types => \&load_archive_types,
        tags          => \&load_core_tags,
        text_filters  => {
            '__default__' => {
                label   => 'Convert Line Breaks',
                handler => 'MT::Util::html_text_transform',
            },
            'richtext' => {
                label   => 'Rich Text',
                handler => 'MT::Util::rich_text_transform',
            },
        },
        ping_servers  => {
            'weblogs' => {
                label => 'weblogs.com',
                url   => 'http://rpc.weblogs.com/RPC2',
            },
            'technorati' => {
                label => 'technorati.com',
                url   => 'http://rpc.technorati.com/rpc/ping',
            },
            'google' => {
                label => 'google.com',
                url   => 'http://blogsearch.google.com/ping/RPC2',
            },
        },
        commenter_authenticators => \&load_core_commenter_auth,
        captcha_providers        => \&load_captcha_providers,
        tasks                    => \&load_core_tasks,
        default_templates        => \&load_default_templates,
        template_snippets        => {
            'insert_entries' => {
                label   => '<MTEntries>',
                content => qq{<MTEntries lastn="10">\n</MTEntries>\n},
            },
        },
    };
}

sub id {
    return 'core';
}

sub load_core_tasks {
    my $cfg = MT->config;
    return {
        'FuturePost' => {
            label     => 'Publish Future Posts',
            frequency => $cfg->FuturePostFrequency * 60,    # once per minute
            code      => sub {
                MT->instance->publisher->publish_future_posts;
              }
        },
        'JunkExpiration' => {
            label     => 'Junk Folder Expiration',
            frequency => 12 * 60 * 60,             # no more than every 12 hours
            code      => sub {
                require MT::JunkFilter;
                MT::JunkFilter->task_expire_junk;
            },
        },
        'CleanTemporaryFiles' => {
            label => 'Remove Temporary Files',
            frequency => 68 * 60,   # once per hour
            code => sub {
                MT::Core->remove_temporary_files;
            },
        },
    };
}

sub remove_temporary_files {
    require MT::Session;

    my @files = MT::Session->load(
        { kind => 'TF', start => [ undef, time - 60 * 60 ] },
        { range => { start => 1 } } );
    my $fmgr = MT::FileMgr->new('Local');
    foreach my $f (@files) {
        if ($fmgr->delete($f->name)) {
            $f->remove;
        }
    }
    # This is a silent task; no need to log removal of temporary files
    return '';
}

sub load_default_templates {
    require MT::DefaultTemplates;
    return MT::DefaultTemplates->core_default_templates;
}

sub load_captcha_providers {
    return MT->core_captcha_providers;
}

sub load_core_commenter_auth {
    return MT->core_commenter_authenticators;
}

sub load_core_tags {
    require MT::Template::ContextHandlers;
    return MT::Template::Context::core_tags();
}

sub load_upgrade_fns {
    require MT::Upgrade;
    return MT::Upgrade->core_upgrade_functions;
}

sub l10n_class { 'MT::L10N' }

sub init_registry {
    my $c = shift;
    return $c->{registry} = $core_registry;
}

# Config handlers for these settings...

sub load_archive_types {
    require MT::WeblogPublisher;
    return MT::WeblogPublisher->core_archive_types;
}

sub SecretToken {
    my $cfg = shift;
    $cfg->set_internal( 'SecretToken', @_ ) if @_;
    my $secret = $cfg->get_internal('SecretToken');
    unless ($secret) {
        my @alpha = ( 'a' .. 'z', 'A' .. 'Z', 0 .. 9 );
        $secret = join '', map $alpha[ rand @alpha ], 1 .. 40;
        $secret = $cfg->set_internal( 'SecretToken', $secret, 1 );
        $cfg->save_config();
    }
    return $secret;
}

sub DefaultUserTagDelimiter {
    my $mgr = shift;
    return $mgr->set_internal( 'DefaultUserTagDelimiter', @_ ) if @_;
    my $delim = $mgr->get_internal('DefaultUserTagDelimiter');
    if ( lc $delim eq 'comma' ) {
        return ord(',');
    }
    elsif ( lc $delim eq 'space' ) {
        return ord(' ');
    }
    else {
        return ord(',');
    }
}

sub NewUserAutoProvisioning {
    my $mgr = shift;
    return $mgr->set_internal( 'NewUserAutoProvisioning', @_ ) if @_;
    return 0 unless $mgr->DefaultSiteRoot && $mgr->DefaultSiteURL;
    $mgr->get_internal('NewUserAutoProvisioning');
}

sub ExternalUserManagement {
    my $mgr = shift;
    return $mgr->set_internal( 'ExternalUserManagement', @_ ) if @_;
    ( $mgr->AuthenticationModule ne 'MT' )
      && $mgr->get_internal('ExternalUserManagement');
}

1;
