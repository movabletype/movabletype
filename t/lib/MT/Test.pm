# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#

package MT::Test;

use strict;
use warnings;
use base qw( Exporter );

our $VERSION = 0.9;
our @EXPORT  = qw(
    _run_app _run_rpt _run_tasks
    location_param_contains query_param_contains has_php
);

# Handle cwd = MT_DIR, MT_DIR/t
use lib 't/lib', 'extlib', 'lib', '../lib', '../extlib';
use File::Spec;
use File::Basename;
use MT;
use MT::Mail;
use MT::Mail::MIME;

use Cwd qw( abs_path );
use URI;
use URI::Escape;
use URI::QueryParam;

# Speed-up tests on Windows.
if ( $^O eq 'MSWin32' ) {
    no warnings 'redefine';
    require Net::SSLeay;
    *Net::SSLeay::RAND_poll = sub () {1};
    require MT::Util;
    *MT::Util::check_fast_cgi = sub {0};
}

MT->add_callback( 'post_init', 1, undef, \&add_plugin_test_libs );

sub add_plugin_test_libs {
    require MT::Plugin;
    my @p = MT::Plugin->select;
    foreach my $p (@p) {
        my $t_lib = File::Spec->catdir( $p->path, 't', 'lib' );
        unshift @INC, $t_lib if ( -d $t_lib );
    }
}

use Test::More;

BEGIN {

    # if MT_HOME is not set, set it
    unless ( $ENV{MT_HOME} ) {
        require Cwd;
        my $cwd    = Cwd::getcwd();
        my @pieces = File::Spec->splitdir($cwd);
        pop @pieces unless -d 't';
        $ENV{MT_HOME} = File::Spec->catdir(@pieces);
    }

    # if MT_CONFIG is not set, set it
    if ( $ENV{MT_CONFIG} ) {
        if ( !File::Spec->file_name_is_absolute( $ENV{MT_CONFIG} ) ) {
            $ENV{MT_CONFIG}
                = File::Spec->catfile( $ENV{MT_HOME}, "t", $ENV{MT_CONFIG} );
        }
    }
    else {
        require DBD::SQLite;    # Use in sqlite-test.cfg.
        $ENV{MT_CONFIG}
            = File::Spec->catfile( $ENV{MT_HOME}, "t", "sqlite-test.cfg" );
    }
    chdir $ENV{MT_HOME};
    my $ds_dir = File::Spec->catdir( $ENV{MT_HOME}, "t", "db" );
    if ( !-d $ds_dir ) {
        mkdir $ds_dir;
    }
    elsif ( -f $ds_dir . '/mt.db' ) {
        my $file = $ds_dir . '/mt.db';
        unlink $file;
    }
}

# Suppress output when "MailTransfer debug"
unless ( $ENV{MT_TEST_MAIL} ) {
    no warnings 'redefine';
    *MT::Mail::_send_mt_debug = sub {1};
    *MT::Mail::MIME::_send_mt_debug = sub {1};
}

sub import {
    my $pkg = shift;
    my @to_export;

# TODO: only use these init_* calls as calls, not as import args, now that we have real functions to export.
    foreach my $opt (@_) {
        if ( $opt =~ m{ \A : (.+) \z }xms ) {
            my $command = "init_$1";
            $pkg->$command() if $pkg->can($command);
        }
        else {
            push @to_export, $opt;
        }
    }

    MT->instance unless $ENV{MT_TEST_ROOT};

    # Export requested or all exportable functions.
    $pkg->export_to_level( 1, @to_export || qw( :DEFAULT ) );
}

our $session_id;
our $session_username = '';

sub init_app {
    my $pkg = shift;
    my ($cfg) = @_;

    my $app = $ENV{MT_APP} || 'MT::App';
    eval "require $app; 1;" or die "Can't load $app";

    $app->set_instance( $app->new( $cfg ? ( Config => $cfg ) : () ) );
    $app->config( 'TemplatePath', abs_path( $app->config->TemplatePath ) );
    $app->config( 'SearchTemplatePath',
        [ File::Spec->rel2abs( $app->config->SearchTemplatePath ) ] );

    # kill __test_output for a new request
    require MT;
    MT->add_callback(
        "${app}::init_request",
        1, undef,
        sub {
            $_[1]->{__test_output}    = '';
            $_[1]->{upgrade_required} = 0;
        }
    ) or die( MT->errstr );
    {
        local $SIG{__WARN__} = sub { };
        my $orig_login = \&MT::App::login;
        *MT::App::print = sub {
            my $app = shift;
            $app->{__test_output} ||= '';
            $app->{__test_output} .= join( '', @_ );
            return 1;
        };
        *MT::App::login = sub {
            my $app = shift;
            if ( my $user = $app->param('__test_user') ) {

                # attempting to fake user session
                if (  !$session_id
                    || $user->name ne $session_username
                    || $app->param('__test_new_session') )
                {
                    $app->start_session( $user, 1 );
                    $session_id       = $app->{session}->id;
                    $session_username = $user->name;
                }
                else {
                    $app->session_user( $user, $session_id );
                }
                if (MT->has_plugin('MFA') && $0 !~ /\bMFA\b/) {
                    $app->session(mfa_verified => 1);
                }
                $app->param( 'magic_token', $app->current_magic );
                $app->user($user);
                return ( $user, 0 );
            }
            $orig_login->( $app, @_ );
        };

    }
}

sub init_cms {
    my $pkg = shift;
    my ($cfg) = @_;

    require MT::App::CMS;
    MT->set_instance( MT::App::CMS->new( $cfg ? ( Config => $cfg ) : () ) );
}

sub init_testdb {
    my $pkg = shift;

    #MT::Upgrade->register_class(['Foo', 'Bar']);
    MT->instance;
    my $registry = MT->component('core')->registry;
    $registry->{object_types}->{foo} = 'Foo';
    $registry->{object_types}->{bar} = 'Bar';
    $registry->{object_types}->{baz} = 'Baz';

    $pkg->init_newdb;
}

sub _load_classes {
    my $pkg = shift;
    my ($cfg) = @_;

    my $mt = MT->instance( $cfg ? ( Config => $cfg ) : () )
        or die "No MT object " . MT->errstr;

    my @classes;
    my $types = MT->registry('object_types');
    for my $key ( keys %$types ) {
        next if $key =~ /\./;
        my $class = $types->{$key};
        $class = $class->[0] if ref $class eq 'ARRAY';
        push @classes, $class;

        if ( $key eq 'entry' or $key eq 'user' ) {
            push @classes, "$class\::Summary";
        }

        if ( my $model = MT->model($key) ) {
            if ( $model->meta_pkg ) {
                my $meta_class = MT->model("$key:meta");
                push @classes, $meta_class if $meta_class;
            }
        }
    }
    foreach my $class (@classes) {
        if ( !defined *{ $class . '::__properties' } ) {
            eval '# line '
                . __LINE__ . ' '
                . __FILE__ . "\n"
                . 'require '
                . $class
                or die $@;
        }
    }
    @classes;
}

sub init_newdb {
    my $pkg = shift;

    my @classes = $pkg->_load_classes(@_);

    # Clear existing database tables
    my $driver = MT::Object->driver();
    foreach my $class (@classes) {
        next unless $driver->dbd->ddl_class->table_exists($class);
        $driver->sql( $driver->dbd->ddl_class->drop_table_sql($class) );
        $driver->dbd->ddl_class->drop_sequence($class);
    }

    1;
}

sub init_upgrade {
    my $pkg  = shift;
    my %args = @_;

    require MT::Upgrade;

    # Prevent temporal values for previous tests to be contaminated into DB
    MT->instance->init_config_from_db;
    MT->instance->init_plugins;

    # Initialize the MT database
    MT::Upgrade->do_upgrade(
        Install => 1,
        App     => __PACKAGE__,
        User    => {
            user_name     => 'Melody',
            user_password => 'Nelson',
            user_nickname => 'Melody',
            user_email    => 'test@localhost.localdomain',
        },
        Blog    => {}
    );
    eval {

        # line __LINE__ __FILE__
        MT::Entry->remove;
        MT::Page->remove;
        MT::Comment->remove;

        unless ( $args{not_create_website} ) {
            my $website
                = MT::Website->create_default_website('First Website');
            $website->allow_data_api(1);
            $website->save;
            my $author = MT::Author->load;
            my ($website_admin_role)
                = MT::Role->load_by_permission('administer_site');
            MT::Association->link(
                $website => $website_admin_role => $author );
        }
    };
    warn $@ if $@;

    clear_cache();

    if (lc($ENV{MT_TEST_BACKEND} // '') eq 'oracle') {
        require MT::Test::Env;
        MT::Test::Env->update_sequences;
    }

    1;
}

sub clear_cache {
    require MT::ObjectDriver::Driver::Cache::RAM;
    MT::ObjectDriver::Driver::Cache::RAM->clear_cache();
    MT->request->reset;
}

sub init_db {
    my $pkg = shift;
    $pkg->init_newdb(@_) && $pkg->init_upgrade(@_);
}

sub config { MT->config }

sub progress { }

sub error {
    my ( $x, $msg ) = @_;
    print "ERROR: $msg\n";
}

sub init_data {
    my $pkg = shift;

    my $test_root = $ENV{MT_TEST_ROOT} || "$ENV{MT_HOME}/t";
    my $themedir = File::Spec->catdir( $MT::MT_DIR => 'themes' );
    MT->config->ThemesDirectory( [$themedir] );
    require MT::Theme;

    require MT::Website;
    my $website = MT::Website->new();
    $website->set_values(
        {   name                     => 'Test site',
            site_url                 => 'http://narnia.na/',
            site_path                => $test_root,
            description              => "Narnia None Test Website",
            custom_dynamic_templates => 'custom',
            convert_paras            => 1,
            allow_data_api           => 1,
            allow_reg_comments       => 1,
            allow_unreg_comments     => 0,
            allow_pings              => 1,
            sort_order_posts         => 'descend',
            sort_order_comments      => 'ascend',
            remote_auth_token        => 'token',
            convert_paras_comments   => 1,
            cc_license           => '',
            server_offset        => '-3.5',
            children_modified_on => '20000101000000',
            language             => 'en_us',
            date_language        => 'en_us',
            file_extension       => 'html',
            theme_id             => 'classic_website',
        }
    );
    $website->id(2);
    $website->class('website');
    $website->save() or die "Couldn't save website 2: " . $website->errstr;
    my $classic_website = MT::Theme->load('classic_website')
        or die MT::Theme->errstr;
    $classic_website->apply($website);
    $website->save() or die "Couldn't save blog 1: " . $website->errstr;

    clear_cache();

    require MT::Blog;
    my $blog;
    $blog = MT::Blog->load(1);
    $blog ||= MT::Blog->new();
    $blog->set_values(
        {   name         => 'None',
            site_url     => '/::/nana/',
            archive_url  => '/::/nana/archives/',
            site_path    => "$test_root/site/",
            archive_path => "$test_root/site/archives/",
            archive_type => 'Individual,Monthly,Weekly,Daily,Category,Page',
            archive_type_preferred   => 'Individual',
            description              => "Narnia None Test Blog",
            custom_dynamic_templates => 'custom',
            convert_paras            => 1,
            allow_data_api           => 1,
            allow_reg_comments       => 1,
            allow_unreg_comments     => 0,
            allow_pings              => 1,
            sort_order_posts         => 'descend',
            sort_order_comments      => 'ascend',
            remote_auth_token        => 'token',
            convert_paras_comments   => 1,
            google_api_key           => 'r9Vj5K8PsjEu+OMsNZ/EEKjWmbCeQAv1',
            cc_license           => '',
            server_offset        => '-3.5',
            children_modified_on => '20000101000000',
            language             => 'en_us',
            date_language        => 'en_us',
            file_extension       => 'html',
            theme_id             => 'classic_blog',
        }
    );
    $blog->id(1);
    $blog->class('blog');
    $blog->parent_id(2);
    $blog->save() or die "Couldn't save blog 1: " . $blog->errstr;

    my $classic_blog = MT::Theme->load('classic_blog')
        or die MT::Theme->errstr;
    $classic_blog->apply($blog);
    $blog->save() or die "Couldn't save blog 1: " . $blog->errstr;

    #    $blog->create_default_templates('mt_blog');
    clear_cache();

    MT::Author->load(1)->set_score( 'unit test', MT::Author->load(1), 1, 1 );

    require MT::Entry;
    require MT::Author;
    my $chuckd = MT::Author->new();
    $chuckd->set_values(
        {   name             => 'Chuck D',
            nickname         => 'Chucky Dee',
            email            => 'chuckd@example.com',
            url              => 'http://chuckd.com/',
            userpic_asset_id => 3,
            api_password     => 'seecret',
            auth_type        => 'MT',
            created_on       => '19780131074500',
        }
    );
    $chuckd->set_password("bass");
    $chuckd->type( MT::Author::AUTHOR() );
    $chuckd->id(2);
    $chuckd->is_superuser(1);
    $chuckd->save()
        or die "Couldn't save author record 2: " . $chuckd->errstr;
    $chuckd->set_score( 'unit test', MT::Author->load(1), 2, 1 );

    my $bobd = MT::Author->new();
    $bobd->set_values(
        {   name       => 'Bob D',
            nickname   => 'Dylan',
            email      => 'bobd@example.com',
            url        => 'http://example.com/',
            auth_type  => 'MT',
            created_on => '19780131075000',
        }
    );
    $bobd->set_password("flute");
    $bobd->type( MT::Author::AUTHOR() );
    $bobd->id(3);
    $bobd->can_sign_in_cms(1);
    $bobd->can_sign_in_data_api(1);
    $bobd->save() or die "Couldn't save author record 3: " . $bobd->errstr;
    $bobd->set_score( 'unit test', MT::Author->load(1), 3, 1 );

    my $johnd = MT::Author->new();
    $johnd->set_values(
        {   name       => 'John Doe',
            nickname   => 'John Doe',
            email      => 'jdoe@doe.com',
            auth_type  => 'TypeKey',
            created_on => '19780131080000',
        }
    );
    $johnd->type( MT::Author::COMMENTER() );
    $johnd->password('(none)');
    $johnd->id(4);
    $johnd->can_sign_in_cms(1);
    $johnd->can_sign_in_data_api(1);
    $johnd->save() or die "Couldn't save author record 4: " . $johnd->errstr;

    my $hiro = MT::Author->new();
    $hiro->set_values(
        {   name       => 'Hiro Nakamura',
            nickname   => 'Hiro',
            email      => 'hiro@heroes.com',
            auth_type  => 'MT',
            created_on => '19780131081000',
        }
    );
    $hiro->type( MT::Author::AUTHOR() );
    $hiro->password('time');
    $hiro->id(5);
    $hiro->status(2);
    $hiro->can_sign_in_cms(1);
    $hiro->can_sign_in_data_api(1);
    $hiro->save() or die "Couldn't save author record 5: " . $hiro->errstr;

    require MT::Role;
    my ( $admin_role, $author_role )
        = map { MT::Role->load( { name => MT->translate($_) } ) }
        ( 'Site Administrator', 'Author' );

    unless ( $admin_role && $author_role ) {
        my @default_roles = (
            {   name        => 'Site Administrator',
                description => 'Can administer the site.',
                role_mask   => 2**12,
                perms       => ['administer_site']
            },
            {   name => 'Author',
                description =>
                    'Can create entries, edit their own entries, upload files and publish.',
                perms => [
                    'comment',      'create_post',
                    'publish_post', 'upload',
                    'send_notifications'
                ],
            },
        );

        foreach my $r (@default_roles) {
            my $role = MT::Role->new();
            $role->name( MT->translate( $r->{name} ) );
            $role->description( MT->translate( $r->{description} ) );
            $role->clear_full_permissions;
            $role->set_these_permissions( $r->{perms} );
            if ( $r->{name} =~ m/^System/ ) {
                $role->is_system(1);
            }
            $role->role_mask( $r->{role_mask} ) if exists $r->{role_mask};
            $role->save;
        }
        clear_cache();
        ( $admin_role, $author_role )
            = map { MT::Role->load( { name => MT->translate($_) } ) }
            ( 'Site Administrator', 'Author' );
    }

    require MT::Association;
    my $assoc = MT::Association->new();
    $assoc->author_id( $chuckd->id );
    $assoc->blog_id(1);
    $assoc->role_id( $admin_role->id );
    $assoc->type(1);
    $assoc->save();

    $assoc = MT::Association->new();
    $assoc->author_id( $bobd->id );
    $assoc->blog_id(1);
    $assoc->role_id( $author_role->id );
    $assoc->type(1);
    $assoc->save();

    $assoc = MT::Association->new();
    $assoc->author_id( $hiro->id );
    $assoc->blog_id(1);
    $assoc->role_id( $admin_role->id );
    $assoc->type(1);
    $assoc->save();

    # set permission record for johnd commenter on blog 1
    $johnd->approve(1);

    my $entry = MT::Entry->load(1);

    # TODO: this test entry is never created; upgrading already adds entry #1.
    if ( !$entry ) {
        $entry = MT::Entry->new();
        $entry->set_values(
            {   blog_id        => 1,
                title          => 'A Rainy Day',
                text           => 'On a drizzly day last weekend,',
                text_more      => 'I took my grandpa for a walk.',
                excerpt        => 'A story of a stroll.',
                keywords       => 'keywords',
                created_on     => '19780131074500',
                modified_on    => '19780131074600',
                authored_on    => '19780131074500',
                unpublished_on => '19780131074700',
                author_id      => $chuckd->id,
                pinged_urls    => 'http://technorati.com/',
                allow_comments => 1,
                allow_pings    => 1,
                status         => MT::Entry::RELEASE(),
            }
        );
        $entry->id(1);
        $entry->tags( 'rain', 'grandpa', 'strolling' );
        $entry->save()
            or die "Couldn't save entry record 1: " . $entry->errstr;
    }
    $entry->clear_cache();

    $entry = MT::Entry->load(2);
    if ( !$entry ) {
        $entry = MT::Entry->new();
        $entry->set_values(
            {   blog_id        => 1,
                title          => 'A preponderance of evidence',
                text           => 'It is sufficient to say...',
                text_more      => 'Brevity is the soul of wit.',
                created_on     => '19790131074500',
                modified_on    => '19790131074600',
                authored_on    => '19780131074500',
                author_id      => $bobd->id,
                allow_comments => 1,
                status         => MT::Entry::FUTURE(),
            }
        );
        $entry->id(2);
        $entry->save()
            or die "Couldn't save entry record 2: " . $entry->errstr;
    }
    $entry->clear_cache();

    $entry = MT::Entry->load(3);
    if ( !$entry ) {
        $entry = MT::Entry->new();
        $entry->set_values(
            {   blog_id        => 1,
                title          => 'Spurious anemones',
                text           => '...are better than the non-spurious',
                text_more      => 'variety.',
                created_on     => '19770131074500',
                modified_on    => '19770131074600',
                authored_on    => '19780131074500',
                author_id      => $chuckd->id,
                allow_comments => 1,
                allow_pings    => 0,
                status         => MT::Entry::HOLD(),
            }
        );
        $entry->id(3);
        $entry->tags('anemones');
        $entry->save()
            or die "Couldn't save entry record 3: " . $entry->errstr;
    }
    $entry->clear_cache();

    require MT::Trackback;
    my $tb = MT::Trackback->load(1);
    if ( !$tb ) {
        $tb = new MT::Trackback;
        $tb->entry_id(1);
        $tb->blog_id(1);
        $tb->title("Entry TrackBack Title");
        $tb->description("Entry TrackBack Description");
        $tb->category_id(0);
        $tb->id(1);
        $tb->save or die "Couldn't save Trackback record 1: " . $tb->errstr;
    }

    require MT::TBPing;
    my $ping = MT::TBPing->load(1);
    if ( !$ping ) {
        $ping = new MT::TBPing;
        $ping->tb_id(1);
        $ping->blog_id(1);
        $ping->ip('127.0.0.1');
        $ping->title('Foo');
        $ping->excerpt('Bar');
        $ping->source_url('http://example.com/');
        $ping->blog_name("Example Blog");
        $ping->created_on('20050405000000');
        $ping->id(1);
        $ping->visible(1);
        $ping->save or die "Couldn't save TBPing record 1: " . $ping->errstr;
    }

    my @verses = (
        'I must be cruel only to be kind;' . "\n" . 'Thus bad begins, and worse remains behind.',
        'Look like the innocent flower,' . "\n" . 'But be the serpent under it.',
        'Me, poor man, my library' . "\n" . 'Was dukedom large enough.',
        'The Devil hath power' . "\n" . 'To assume a pleasing shape.',
        join(
            "\n",
            'The weight of this sad time we must obey,',
            'Speak what we feel, not what we ought to say.',
            'The oldest hath borne most: we that are young',
            'Shall never see so much, nor live so long.'
        ),
    );

    require MT::Category;
    my $cat = MT::Category->load( { label => 'foo', blog_id => 1 } );
    if ( !$cat ) {
        $cat = new MT::Category;
        $cat->blog_id(1);
        $cat->label('foo');
        $cat->description('bar');
        $cat->author_id( $chuckd->id );
        $cat->parent(0);
        $cat->id(1);
        $cat->save or die "Couldn't save category record 1: " . $cat->errstr;
    }

    $cat = MT::Category->load( { label => 'bar', blog_id => 1 } );
    if ( !$cat ) {
        $cat = new MT::Category;
        $cat->blog_id(1);
        $cat->label('bar');
        $cat->description('foo');
        $cat->author_id( $chuckd->id );
        $cat->parent(0);
        $cat->id(2);
        $cat->save or die "Couldn't save category record 2: " . $cat->errstr;
    }

    $tb = MT::Trackback->load(2);
    if ( !$tb ) {
        $tb = new MT::Trackback;
        $tb->title("Category TrackBack Title");
        $tb->description("Category TrackBack Description");
        $tb->entry_id(0);
        $tb->blog_id(1);
        $tb->category_id(2);
        $tb->id(2);
        $tb->save or die "Couldn't save Trackback record 2: " . $tb->errstr;
    }

    $cat = MT::Category->load( { label => 'subfoo', blog_id => 1 } );
    if ( !$cat ) {
        $cat = new MT::Category;
        $cat->blog_id(1);
        $cat->label('subfoo');
        $cat->description('subcat');
        $cat->author_id( $bobd->id );
        $cat->parent(1);
        $cat->id(3);
        $cat->save or die "Couldn't save category record 3: " . $cat->errstr;
    }

    # Categories and sub categories
    $cat = MT::Category->load( { label => 'US', blog_id => 2 } );
    if ( !$cat ) {
        $cat = new MT::Category;
        $cat->blog_id(2);
        $cat->label('US');
        $cat->description('The United States of America');
        $cat->author_id( $chuckd->id );
        $cat->parent(0);
        $cat->id(4);
        $cat->save or die "Couldn't save category record 4: " . $cat->errstr;
    }
    $cat = MT::Category->load( { label => 'California', blog_id => 2 } );
    if ( !$cat ) {
        $cat = new MT::Category;
        $cat->blog_id(2);
        $cat->label('California');
        $cat->description('');
        $cat->author_id( $chuckd->id );
        $cat->parent(4);
        $cat->id(5);
        $cat->save or die "Couldn't save category record 5: " . $cat->errstr;
    }
    $cat = MT::Category->load( { label => 'San Fransico', blog_id => 2 } );
    if ( !$cat ) {
        $cat = new MT::Category;
        $cat->blog_id(2);
        $cat->label('San Fransisco');
        $cat->description('');
        $cat->author_id( $chuckd->id );
        $cat->parent(5);
        $cat->id(6);
        $cat->save or die "Couldn't save category record 6: " . $cat->errstr;
    }

    $cat = MT::Category->load( { label => 'Japan', blog_id => 2 } );
    if ( !$cat ) {
        $cat = new MT::Category;
        $cat->blog_id(2);
        $cat->label('Japan');
        $cat->description('Japan');
        $cat->author_id( $chuckd->id );
        $cat->parent(0);
        $cat->id(7);
        $cat->save or die "Couldn't save category record 7: " . $cat->errstr;
    }
    $cat = MT::Category->load( { label => 'Tokyo', blog_id => 2 } );
    if ( !$cat ) {
        $cat = new MT::Category;
        $cat->blog_id(2);
        $cat->label('Tokyo');
        $cat->description('');
        $cat->author_id( $chuckd->id );
        $cat->parent(7);
        $cat->id(8);
        $cat->save or die "Couldn't save category record 8: " . $cat->errstr;
    }
    $cat = MT::Category->load( { label => 'Chiyoda', blog_id => 2 } );
    if ( !$cat ) {
        $cat = new MT::Category;
        $cat->blog_id(2);
        $cat->label('Chiyoda');
        $cat->description('');
        $cat->author_id( $chuckd->id );
        $cat->parent(8);
        $cat->id(9);
        $cat->save or die "Couldn't save category record 9: " . $cat->errstr;
    }

    require MT::Placement;
    foreach my $i ( 1 .. @verses ) {
        $entry = MT::Entry->load( $i + 3 );
        if ( !$entry ) {
            $entry = MT::Entry->new();
            $entry->set_values(
                {   blog_id        => 1,
                    title          => "Verse $i",
                    text           => $verses[$i],
                    author_id      => ( $i == 3 ? $bobd->id : $chuckd->id ),
                    created_on     => sprintf( "%04d0131074501", $i + 1960 ),
                    modified_on    => sprintf( "%04d0131074601", $i + 1960 ),
                    authored_on    => sprintf( "%04d0131074501", $i + 1960 ),
                    allow_comments => ( $i <= 2 ? 0 : 1 ),
                    status         => MT::Entry::RELEASE(),
                }
            );
            $entry->id( $i + 3 );
            if ( $i == 1 || $i == 3 || $i == 5 ) {
                $entry->tags( 'verse', 'rain' );
            }
            else {
                $entry->tags( 'verse', 'anemones' );
            }
            $entry->save()
                or die "Couldn't save entry record "
                . ( $entry->id ) . ": "
                . $entry->errstr;
            if ( $i == 3 ) {
                my $place = new MT::Placement;
                $place->entry_id( $entry->id );
                $place->blog_id(1);
                $place->category_id(1);
                $place->is_primary(1);
                $place->save
                    or die "Couldn't save placement record: "
                    . $place->errstr;
            }
            if ( $i == 4 ) {
                my $place = new MT::Placement;
                $place->entry_id( $entry->id );
                $place->blog_id(1);
                $place->category_id(3);
                $place->is_primary(1);
                $place->save
                    or die "Couldn't save placement record: "
                    . $place->errstr;
            }
        }
    }

    # entry id 1 - 1 visible comment
    # entry id 4 - no comments, commenting is off
    require MT::Comment;
    unless ( MT::Comment->count( { entry_id => 1 } ) ) {
        my $cmt = new MT::Comment();
        $cmt->set_values(
            {   text =>
                    'Postmodern false consciousness has always been firmly rooted in post-Freudian Lacanian neo-Marxist bojangles. Needless to say, this quickly and asymptotically approches a purpletacular jouissance of etic jumpinmypants.',
                entry_id   => 1,
                author     => 'v14GrUH 4 cheep',
                visible    => 1,
                email      => 'jake@fatman.com',
                url        => 'http://fatman.com/',
                blog_id    => 1,
                ip         => '127.0.0.1',
                created_on => '20040714182800',
            }
        );
        $cmt->id(1);
        $cmt->save() or die "Couldn't save comment record 1: " . $cmt->errstr;

        $cmt->id(11);
        $cmt->text('Comment reply for comment 1');
        $cmt->author('Comment 11');
        $cmt->created_on('20040812182900');
        $cmt->parent_id(1);
        $cmt->save()
            or die "Couldn't save comment record 11: " . $cmt->errstr;

        $cmt->id(12);
        $cmt->text('Comment reply for comment 11');
        $cmt->author('Comment 12');
        $cmt->created_on('20040810183000');
        $cmt->parent_id(11);
        $cmt->save()
            or die "Couldn't save comment record 12: " . $cmt->errstr;
    }

    # entry id 5 - 1 comment, commenting is off (closed)
    unless ( MT::Comment->count( { entry_id => 5 } ) ) {
        my $cmt = new MT::Comment();
        $cmt->set_values(
            {   text         => 'Comment for entry 5, visible',
                entry_id     => 5,
                author       => 'Comment 2',
                visible      => 1,
                email        => 'johnd@doe.com',
                url          => 'http://john.doe.com/',
                commenter_id => $johnd->id,
                blog_id      => 1,
                ip           => '127.0.0.1',
                created_on   => '20040912182800',
            }
        );
        $cmt->id(2);
        $cmt->junk_score(1.5);
        $cmt->save() or die "Couldn't save comment record 2: " . $cmt->errstr;
    }

    # entry id 6 - 3 comment visible, 1 moderated
    unless ( MT::Comment->count( { entry_id => 6 } ) ) {
        my $cmt = new MT::Comment();
        $cmt->set_values(
            {   text       => 'Comment for entry 6, visible',
                entry_id   => 6,
                author     => 'Comment 3',
                visible    => 1,
                email      => '',
                url        => '',
                blog_id    => 1,
                ip         => '127.0.0.1',
                created_on => '20040911182800',
            }
        );
        $cmt->id(3);
        $cmt->save() or die "Couldn't save comment record 3: " . $cmt->errstr;

        $cmt->id(4);
        $cmt->visible(0);
        $cmt->author('Comment 4');
        $cmt->text('Comment for entry 6, moderated');
        $cmt->created_on('20040910182800');
        $cmt->save() or die "Couldn't save comment record 4: " . $cmt->errstr;

        $cmt->text("All your comments are belonged to me.");
        $cmt->commenter_id( $chuckd->id );
        $cmt->visible(1);
        $cmt->created_on('20040910183000');
        $cmt->id(14);
        $cmt->save or die "Couldn't save comment record 1: " . $cmt->errstr;

        $cmt->text("All your comments are belonged to us MT Authors.");
        $cmt->commenter_id( $bobd->id );
        $cmt->visible(1);
        $cmt->created_on('20040910182800');
        $cmt->id(15);
        $cmt->save or die "Couldn't save comment record 1: " . $cmt->errstr;
    }

    # entry id 7 - 0 comment visible, 1 moderated
    unless ( MT::Comment->count( { entry_id => 7 } ) ) {
        my $cmt = new MT::Comment();
        $cmt->set_values(
            {   text       => 'Comment for entry 7, moderated',
                entry_id   => 7,
                author     => 'Comment 7',
                visible    => 0,
                email      => '',
                url        => '',
                blog_id    => 1,
                ip         => '127.0.0.1',
                created_on => '20040909182800',
            }
        );
        $cmt->id(5);
        $cmt->save() or die "Couldn't save comment record 5: " . $cmt->errstr;
    }

    # entry id 8 - 1 comment visible, 1 moderated, 1 junk
    unless ( MT::Comment->count( { entry_id => 8 } ) ) {
        my $cmt = new MT::Comment();
        $cmt->set_values(
            {   text       => 'Comment for entry 8, visible',
                entry_id   => 8,
                author     => 'Comment 8',
                visible    => 1,
                email      => '',
                url        => '',
                blog_id    => 1,
                ip         => '127.0.0.1',
                created_on => '20040614182800',
            }
        );
        $cmt->id(6);
        $cmt->save() or die "Couldn't save comment record 6: " . $cmt->errstr;

        $cmt->id(7);
        $cmt->visible(0);
        $cmt->text('Comment for entry 8, moderated');
        $cmt->author('JD7');
        $cmt->created_on('20040812182800');
        $cmt->save() or die "Couldn't save comment record 7: " . $cmt->errstr;

        $cmt->id(8);
        $cmt->visible(0);
        $cmt->junk_status(-1);
        $cmt->text('Comment for entry 8, junk');
        $cmt->author('JD8');
        $cmt->created_on('20040810182800');
        $cmt->save() or die "Couldn't save comment record 8: " . $cmt->errstr;
    }

    # entry id 24 - 1 comment visible, 1 moderated
    unless ( MT::Comment->count( { entry_id => 24 } ) ) {
        my $cmt = new MT::Comment();
        $cmt->set_values(
            {   text       => 'Comment for entry 24, visible',
                entry_id   => 24,
                author     => 'Comment 24',
                visible    => 1,
                email      => '',
                url        => '',
                blog_id    => 2,
                ip         => '127.0.0.1',
                created_on => '20040614182800',
            }
        );
        $cmt->id(16);
        $cmt->save()
            or die "Couldn't save comment record 16: " . $cmt->errstr;

        $cmt->id(17);
        $cmt->visible(0);
        $cmt->text('Comment for entry 24, moderated');
        $cmt->author('JD17');
        $cmt->created_on('20040812182800');
        $cmt->save()
            or die "Couldn't save comment record 17: " . $cmt->errstr;
    }

    require MT::Template;
    require MT::TemplateMap;

    my $tmpl = new MT::Template;
    $tmpl->blog_id(1);
    $tmpl->name('blog-name');
    $tmpl->text('<MTBlogName>');
    $tmpl->type('custom');
    $tmpl->save or die "Couldn't save template record 1: " . $tmpl->errstr;

    my $include_block_tmpl = new MT::Template;
    $include_block_tmpl->blog_id(1);
    $include_block_tmpl->name('header-line');
    $include_block_tmpl->text('<h1><MTGetVar name="contents"></h1>');
    $include_block_tmpl->type('custom');
    $include_block_tmpl->save
        or die "Couldn't save template record 2: "
        . $include_block_tmpl->errstr;

    my $tmpl_map = new MT::TemplateMap;
    $tmpl_map->blog_id(1);
    $tmpl_map->template_id( $tmpl->id );
    $tmpl_map->archive_type('Daily');
    $tmpl_map->is_preferred(1);
    $tmpl_map->build_type(1);
    $tmpl_map->save
        or die "Couldn't save template map record (Daily): "
        . $tmpl_map->errstr;

    $tmpl_map = new MT::TemplateMap;
    $tmpl_map->blog_id(1);
    $tmpl_map->template_id( $tmpl->id );
    $tmpl_map->archive_type('Weekly');
    $tmpl_map->is_preferred(1);
    $tmpl_map->build_type(1);
    $tmpl_map->save
        or die "Couldn't save template map record (Weekly): "
        . $tmpl_map->errstr;

    $tmpl_map = new MT::TemplateMap;
    $tmpl_map->blog_id(1);
    $tmpl_map->template_id( $tmpl->id );
    $tmpl_map->archive_type('Author');
    $tmpl_map->is_preferred(1);
    $tmpl_map->build_type(1);
    $tmpl_map->save
        or die "Couldn't save template map record (Author): "
        . $tmpl_map->errstr;

    # Revert into default for test...
    $blog->archive_type(
        'Individual,Monthly,Weekly,Daily,Category,Page,Author');
    $blog->save;

    ### Asset
    use MT::Asset;

    my $img_pkg  = MT::Asset->class_handler('image');
    my $file_pkg = MT::Asset->class_handler('file');
    my $asset    = new $img_pkg;
    $asset->blog_id(1);
    $asset->url('http://narnia.na/nana/images/test.jpg');
    $asset->file_path(
        File::Spec->catfile( $ENV{MT_HOME}, "t", 'images', 'test.jpg' ) );
    $asset->file_name('test.jpg');
    $asset->file_ext('jpg');
    $asset->image_width(640);
    $asset->image_height(480);
    $asset->mime_type('image/jpeg');
    $asset->label('Image photo');
    $asset->description('This is a test photo.');
    $asset->created_by(1);
    $asset->tags( 'alpha', 'beta', 'gamma' );
    $asset->save or die "Couldn't save asset record 1: " . $asset->errstr;

    $asset->set_score( 'unit test', $bobd,               5, 1 );
    $asset->set_score( 'unit test', $johnd,              3, 1 );
    $asset->set_score( 'unit test', MT::Author->load(1), 4, 1 );

    $asset = new $file_pkg;
    $asset->blog_id(1);
    $asset->url('http://narnia.na/nana/files/test.tmpl');
    $asset->file_path(
        File::Spec->catfile( $ENV{MT_HOME}, "t", 'test.tmpl' ) );
    $asset->file_name('test.tmpl');
    $asset->file_ext('tmpl');
    $asset->mime_type('text/plain');
    $asset->label('Template');
    $asset->description('This is a test template.');
    $asset->created_by(1);
    $asset->created_on('19780131074500');
    $asset->tags('beta');
    $asset->save or die "Couldn't save file asset record: " . $asset->errstr;

    $asset->set_score( 'unit test', $chuckd, 2, 1 );
    $asset->set_score( 'unit test', $johnd,  3, 1 );

    $asset = new $img_pkg;
    $asset->blog_id(0);
    $asset->url('%s/uploads//test.jpg');
    $asset->file_path(
        File::Spec->catfile( $ENV{MT_HOME}, "t", 'images', 'test.jpg' ) );
    $asset->file_name('test.jpg');
    $asset->file_ext('jpg');
    $asset->image_width(640);
    $asset->image_height(480);
    $asset->mime_type('image/jpeg');
    $asset->label('Image photo');
    $asset->description('This is a userpic photo.');
    $asset->created_by(1);
    $asset->tags('@userpic');
    $asset->save or die "Couldn't save asset record 3: " . $asset->errstr;

    # not exsists file
    $asset = new $img_pkg;
    $asset->blog_id(0);
    $asset->url('%s/uploads/test2.jpg');
    $asset->file_path(
        File::Spec->catfile( $ENV{MT_HOME}, "t", 'images', 'test2.jpg' ) );
    $asset->file_name('test2.jpg');
    $asset->file_ext('jpg');
    $asset->image_width(640);
    $asset->image_height(480);
    $asset->mime_type('image/jpeg');
    $asset->label('Image photo');
    $asset->description('This is not exists file.');
    $asset->created_by(1);
    $asset->tags('not_exists');
    $asset->save or die "Couldn't save asset record 4: " . $asset->errstr;

    $asset = new $img_pkg;
    $asset->blog_id(1);
    $asset->url('http://narnia.na/nana/images/test1.jpg');
    $asset->file_path(
        File::Spec->catfile( $ENV{MT_HOME}, "t", 'images', 'test1.jpg' ) );
    $asset->file_name('test1.jpg');
    $asset->file_ext('jpg');
    $asset->image_width(640);
    $asset->image_height(480);
    $asset->mime_type('image/jpeg');
    $asset->label('Image photo');
    $asset->description('This is a test photo.');
    $asset->tags( 'alpha', 'beta', 'gamma' );
    $asset->created_by(1);
    $asset->created_on('20000131074500');
    $asset->save or die "Couldn't save asset record 5: " . $asset->errstr;

    $asset->set_score( 'unit test', $bobd, 8, 5 );

    $asset = new $img_pkg;
    $asset->blog_id(1);
    $asset->url('http://narnia.na/nana/images/test2.jpg');
    $asset->file_path(
        File::Spec->catfile( $ENV{MT_HOME}, "t", 'images', 'test2.jpg' ) );
    $asset->file_name('test2.jpg');
    $asset->file_ext('jpg');
    $asset->image_width(640);
    $asset->image_height(480);
    $asset->mime_type('image/jpeg');
    $asset->label('Image photo');
    $asset->description('This is a test photo.');
    $asset->tags( 'alpha', 'beta', 'gamma' );
    $asset->created_by(1);
    $asset->created_on('20000131074600');
    $asset->save or die "Couldn't save asset record 6: " . $asset->errstr;

    $asset->set_score( 'unit test', $bobd, 9, 6 );

    $asset = new $img_pkg;
    $asset->blog_id(1);
    $asset->url('http://narnia.na/nana/images/test3.jpg');
    $asset->file_path(
        File::Spec->catfile( $ENV{MT_HOME}, "t", 'images', 'test3.jpg' ) );
    $asset->file_name('test3.jpg');
    $asset->file_ext('jpg');
    $asset->image_width(640);
    $asset->image_height(480);
    $asset->mime_type('image/jpeg');
    $asset->label('Image photo');
    $asset->description('This is a test photo.');
    $asset->tags( 'alpha', 'beta', 'gamma' );
    $asset->created_by(1);
    $asset->created_on('20000131074700');
    $asset->save or die "Couldn't save asset record 7: " . $asset->errstr;

    $asset->set_score( 'unit test', $bobd, 7, 7 );
    ## ObjectScore
    my $e5 = MT::Entry->load(5);
    $e5->set_score( 'unit test', $bobd,               5, 1 );
    $e5->set_score( 'unit test', $johnd,              3, 1 );
    $e5->set_score( 'unit test', MT::Author->load(1), 4, 1 );

    my $e6 = MT::Entry->load(6);
    $e6->set_score( 'unit test', $chuckd, 1, 1 );
    $e6->set_score( 'unit test', $johnd,  1, 1 );

    my $e4 = MT::Entry->load(4);
    $e4->set_score( 'unit test', $chuckd, 2, 1 );
    $e4->set_score( 'unit test', $johnd,  3, 1 );

    ## Page
    require MT::Page;
    my $page = MT::Page->new();
    $page->set_values(
        {   blog_id     => 1,
            title       => 'But in ourselves, that we are underlings.',
            text        => 'Men at some time are masters of their fates:',
            text_more   => 'The fault, dear Brutus, is not in our stars,',
            keywords    => 'no folder',
            excerpt     => 'excerpt',
            created_on  => '19780131074500',
            authored_on => '19780131074500',
            modified_on => '19780131074600',
            unpublished_on => '19780131074700',
            author_id   => $chuckd->id,
            status      => MT::Entry::RELEASE(),
        }
    );
    $page->id(20);
    $page->tags( 'river', 'flow', 'watch' );
    $page->save() or die "Couldn't save page record 20: " . $page->errstr;

    require MT::Folder;
    my $folder = MT::Folder->new();
    $folder->blog_id(1);
    $folder->label('info');
    $folder->description('information');
    $folder->author_id( $chuckd->id );
    $folder->parent(0);
    $folder->id(20);
    $folder->save or die "Could'n sae folder record 20:" . $folder->errstr;

    $folder = MT::Folder->new();
    $folder->blog_id(1);
    $folder->label('download');
    $folder->description('download top');
    $folder->author_id( $chuckd->id );
    $folder->parent(0);
    $folder->id(21);
    $folder->save or die "Could'n sae folder record 21:" . $folder->errstr;

    $folder = MT::Folder->new();
    $folder->blog_id(1);
    $folder->label('nightly');
    $folder->description('nightly build');
    $folder->author_id( $chuckd->id );
    $folder->parent(21);
    $folder->id(22);
    $folder->save or die "Could'n sae folder record 22:" . $folder->errstr;

    # Folder with sub folders
    $folder = MT::Folder->new();
    $folder->blog_id(2);
    $folder->label('Product');
    $folder->description('News');
    $folder->author_id( $chuckd->id );
    $folder->parent(0);
    $folder->id(23);
    $folder->save or die "Could'n sae folder record 21:" . $folder->errstr;

    $folder = MT::Folder->new();
    $folder->blog_id(2);
    $folder->label('Consumer');
    $folder->description('');
    $folder->author_id( $chuckd->id );
    $folder->parent(23);
    $folder->id(24);
    $folder->save or die "Could'n sae folder record 22:" . $folder->errstr;

    $folder = MT::Folder->new();
    $folder->blog_id(2);
    $folder->label('Game');
    $folder->description('');
    $folder->author_id( $chuckd->id );
    $folder->parent(24);
    $folder->id(25);
    $folder->save or die "Could'n sae folder record 22:" . $folder->errstr;

    $page = MT::Page->new();
    $page->set_values(
        {   blog_id     => 1,
            title       => 'Page #1',
            text        => 'Good night, good night! Parting is such sweet sorrow,',
            text_more   => 'That I shall say good night till it be morrow.',
            keywords    => 'keywords',
            created_on  => '19790131074500',
            authored_on => '19790131074500',
            modified_on => '19790131074600',
            author_id   => $chuckd->id,
            status      => MT::Entry::RELEASE(),
        }
    );
    $page->id(21);
    $page->tags( 'page1', 'page2', 'page3' );
    $page->save() or die "Couldn't save page record 21: " . $page->errstr;

    my $folder_place = new MT::Placement;
    $folder_place->entry_id(21);
    $folder_place->blog_id(1);
    $folder_place->category_id(20);
    $folder_place->is_primary(1);
    $folder_place->save
        or die "Couldn't save placement record: " . $folder_place->errstr;

    $page = MT::Page->new();
    $page->set_values(
        {   blog_id     => 1,
            title       => 'Page #2',
            text        => 'By the pricking of my thumbs,',
            text_more   => 'Something wicked this way comes.',
            keywords    => 'keywords',
            created_on  => '19800131074500',
            authored_on => '19800131074500',
            modified_on => '19800131074600',
            author_id   => $chuckd->id,
            status      => MT::Entry::RELEASE(),
        }
    );
    $page->id(22);
    $page->tags( 'page2', 'page3' );
    $page->save() or die "Couldn't save page record 22: " . $page->errstr;

    $folder_place = new MT::Placement;
    $folder_place->entry_id(22);
    $folder_place->blog_id(1);
    $folder_place->category_id(21);
    $folder_place->is_primary(1);
    $folder_place->save
        or die "Couldn't save placement record: " . $folder_place->errstr;

    $page = MT::Page->new();
    $page->set_values(
        {   blog_id     => 1,
            title       => 'Page #3',
            text        => 'Good night, good night! parting is such sweet sorrow,',
            text_more   => 'That I shall say good night till it be morrow.',
            keywords    => 'keywords',
            created_on  => '19810131074500',
            authored_on => '19810131074500',
            modified_on => '19810131074600',
            author_id   => $bobd->id,
            status      => MT::Entry::RELEASE(),
        }
    );
    $page->id(23);
    $page->tags('page3');
    $page->save() or die "Couldn't save page record 23: " . $page->errstr;

    $folder_place = new MT::Placement;
    $folder_place->entry_id(23);
    $folder_place->blog_id(1);
    $folder_place->category_id(22);
    $folder_place->is_primary(1);
    $folder_place->save
        or die "Couldn't save placement record: " . $folder_place->errstr;

    unless ( MT::Comment->count( { entry_id => $page->id } ) ) {
        my $page_cmt = new MT::Comment();
        $page_cmt->set_values(
            {   text =>
                    "Your time is limited, so don't waste it living someone else's life. Don't be trapped by dogma - which is living with the results of other people's thinking. Don't let the noise of others' opinions drown out your own inner voice. And most important, have the courage to follow your heart and intuition. They somehow already know what you truly want to become. Everything else is secondary.",
                entry_id    => 23,
                author      => 'Steve Jobs',
                visible     => 1,
                email       => 'f@example.com',
                url         => 'http://example.com/',
                blog_id     => 1,
                ip          => '127.0.0.1',
                created_on  => '20040114182800',
                modified_on => '20040114182800',
            }
        );
        $page_cmt->id(13);
        $page_cmt->save()
            or die "Couldn't save comment record 1: " . $page_cmt->errstr;
    }

    my $page_tb = MT::Trackback->new;
    $page_tb->entry_id( $page->id );
    $page_tb->blog_id(1);
    $page_tb->title("Page TrackBack Title");
    $page_tb->description("Page TrackBack Description");
    $page_tb->category_id(0);
    $page_tb->id(3);
    $page_tb->save or die "Couldn't save Trackback record 1: " . $tb->errstr;

    my $page_ping = MT::TBPing->new;
    $page_ping->tb_id( $page_tb->id );
    $page_ping->blog_id(1);
    $page_ping->ip('127.0.0.1');
    $page_ping->title('Trackbacking to a page');
    $page_ping->excerpt(
        'Four bridges in the bayarea.  Golden Gate, Bay, San Mateo and Dan Burton.'
    );
    $page_ping->source_url('http://example.com/');
    $page_ping->blog_name("Example Blog");
    $page_ping->created_on('20040101000000');
    $page_ping->modified_on('20040101000000');
    $page_ping->visible(1);
    $page_ping->id(3);
    $page_ping->save or die "Couldn't save TBPing record 1: " . $ping->errstr;

    # About page for website
    $page = MT::Page->new();
    $page->set_values(
        {   blog_id     => 2,
            title       => 'About',
            text        => 'About this website.',
            text_more   => 'This website is wonderful.',
            keywords    => 'about',
            excerpt     => 'excerpt',
            created_on  => '20050131074500',
            authored_on => '20050131074500',
            modified_on => '20050131074600',
            author_id   => $chuckd->id,
            status      => MT::Entry::RELEASE(),
        }
    );
    $page->id(24);
    $page->tags('@about');
    $page->comment_count(
        MT::Comment->count( { entry_id => 24, visible => 1 } ) || 0 );
    $page->save() or die "Couldn't save page record 24: " . $page->errstr;

    clear_cache();
    MT->instance->rebuild( BlogID => 1, );

    ### Make ObjectAsset mappings
    require MT::ObjectAsset;
    my $map;
    $entry = MT::Entry->load(1);
    if ($entry) {
        $map = new MT::ObjectAsset;
        $map->blog_id( $entry->blog_id );
        $map->asset_id(5);
        $map->object_ds( $entry->datasource );
        $map->object_id( $entry->id );
        $map->save;

        $map = new MT::ObjectAsset;
        $map->blog_id( $entry->blog_id );
        $map->asset_id(6);
        $map->object_ds( $entry->datasource );
        $map->object_id( $entry->id );
        $map->save;

        $map = new MT::ObjectAsset;
        $map->blog_id( $entry->blog_id );
        $map->asset_id(7);
        $map->object_ds( $entry->datasource );
        $map->object_id( $entry->id );
        $map->save;
    }
    $page = MT::Page->load(20);
    if ($page) {
        $map = new MT::ObjectAsset;
        $map->blog_id( $page->blog_id );
        $map->asset_id(5);
        $map->object_ds( $page->datasource );
        $map->object_id( $page->id );
        $map->save;

        $map = new MT::ObjectAsset;
        $map->blog_id( $page->blog_id );
        $map->asset_id(6);
        $map->object_ds( $page->datasource );
        $map->object_id( $page->id );
        $map->save;

        $map = new MT::ObjectAsset;
        $map->blog_id( $page->blog_id );
        $map->asset_id(7);
        $map->object_ds( $page->datasource );
        $map->object_id( $page->id );
        $map->save;
    }

    if (lc($ENV{MT_TEST_BACKEND} // '') =~ /^(oracle|pg)/) {
        require MT::Test::Env;
        MT::Test::Env->update_sequences;
    }

    1;
}

sub _run_app {
    my ( $class, $params, $level ) = @_;
    $level ||= 0;
    require CGI;
    my $cgi              = CGI->new;
    my $follow_redirects = 0;
    my $max_redirects    = 10;
    my %app_hash_values  = qw(
        __request_method request_method
        __path_info __path_info
    );

    while ( my ( $k, $v ) = each(%$params) ) {
        next if grep { $_ eq $k } keys %app_hash_values;
        if ( ref($v) eq 'ARRAY' && $k ne '__test_upload' ) {
            $cgi->param( $k, @$v );
        }
        elsif ( $k eq '__test_follow_redirects' ) {
            $follow_redirects = $v;
        }
        elsif ( $k eq '__test_max_redirects' ) {
            $max_redirects = $v;
        }
        elsif ( $k eq '__test_upload' ) {
            my ( $param, $src ) = @$v;
            require CGI::File::Temp;
            my ($cgi_fh) = new CGI::File::Temp( UNLINK => 1 )
                or die "CGI::File::Temp: $!";
            my $basename = basename($src);
            if ( $^O eq 'MSWin32' ) {
                require Encode;
                Encode::from_to( $basename, 'cp932', 'utf8' );
            }
            $cgi_fh->_mp_filename($basename);
            $CGI::DefaultClass->binmode($cgi_fh)
                if $CGI::needs_binmode
                && defined fileno($cgi_fh);

            {
                local $/ = undef;
                open my $upload, "<", $src or die "Can't open $src: $!";
                binmode $upload if $basename =~ /\.(?:gif|png|jpg)$/;
                my $d = <$upload>;
                close $upload;
                print $cgi_fh $d;

                seek( $cgi_fh, 0, 0 );
            }

            $cgi->param( $param, $cgi_fh );
        }
        else {
            $cgi->param( $k, $v );
        }
    }
    eval "require $class;";
    my $app = $class->new( CGIObject => $cgi );
    MT->set_instance($app);
    $app->config( 'TemplatePath', abs_path( $app->config->TemplatePath ) );
    $app->config( 'SearchTemplatePath',
        [ abs_path( $app->config->SearchTemplatePath ) ] );
    $app->config( 'MailTransfer', 'debug' ) unless $ENV{MT_TEST_MAIL};

    # nix upgrade required
    # seems to be hanging around when it doesn't need to be
    $app->{init_request} = 0;    # gotta set this to force the init request
    $app->init_request( CGIObject => $cgi );
    while ( my ( $params_key, $app_key ) = each %app_hash_values ) {
        $app->{$app_key} = $params->{$params_key}
            if exists $params->{$params_key};
    }
    $app->run;

    my $out = $app->{__test_output};

    # is the response a redirect
    if (   $out
        && $follow_redirects
        && (   $out =~ /^Status: 302 (?:Moved|Found)\s*$/smi
            || $out =~ /window\.location=/ )
        && $level < $max_redirects
        )
    {
        if (   $out =~ /^Location: \/cgi-bin\/mt\.cgi\?(.+)$/m
            || $out =~ /window\.location='\/cgi-bin\/mt\.cgi\?([^']+)'/ )
        {
            my %params = _parse_query($1);

            # carry over the test parameters
            $params{$_} = $params->{$_}
                foreach ( grep {/^__test/} keys %$params );

            # nix any any all caches!!
            clear_cache();

            # anything else here??
            delete $app->{__test_output};
            undef $app;

            # avoid processing multiple requests in a second
            sleep(1);

            $app = _run_app( $class, \%params, $level + 1 );
        }
    }

    return $app;
}

sub _parse_query {
    my ($query) = @_;
    $query =~ s/\s*$//g;
    my @params = split( /&/, $query );
    my %params
        = map { my ( $k, $v ) = split( /=/, $_, 2 ); $k => uri_unescape($v) }
        @params;
    return %params;
}

sub _run_rpt {
    MT::Session->remove( { kind => 'PT' } );
    my $res = `perl -It/lib ./tools/run-periodic-tasks --verbose 2>&1`;
    if ( $res =~ /((?:Compilation failed|Can't locate).*)/ ) {
        diag $1;
        BAIL_OUT;
    }
    $res;
}

sub _run_tasks {
    my ($tasks) = @_;
    return unless $tasks;
    require MT::Session;
    for my $t (@$tasks) {
        MT::Session->remove( { id => "Task:$t" } );
    }

    MT->set_instance( MT->new );

    require MT::TaskMgr;
    MT::TaskMgr->run_tasks(@$tasks);
}

sub location_param_contains {
    my ( $out, $expects, $message ) = @_;
    my ($location_url) = $out =~ /^Location:\s*(\S+)/m;
    unless ($location_url) {
        fail "$message: no Location url";
        return;
    }
    query_param_contains( $location_url, $expects, $message );
}

sub query_param_contains {
    my ( $url, $expects, $message ) = @_;
    my $uri  = URI->new($url);
    my $fail = 0;
    for my $key ( sort keys %$expects ) {
        is $uri->query_param($key) => $expects->{$key},
            "$key: $expects->{$key}"
            or $fail++;
    }
    ok !$fail, $message;
}

sub has_php {
    require MT::Test::PHP;
    MT::Test::PHP->php_version ? 1 : 0;
}

sub validate_param { return [] }

1;
