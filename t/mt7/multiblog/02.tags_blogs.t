#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib"; # t/lib
use Test::More;
use MT::Test::Env;
BEGIN {
    eval qq{ use Test::Base; 1 }
        or plan skip_all => 'Test::Base is not installed';
}

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use IPC::Open2;

plan tests => 2 * blocks;

use MT;
use MT::Test;
my $app = MT->instance;

$test_env->prepare_fixture('db_data');

my $blog_id = 2;

my $plugin = $app->component('MultiBlog');
my $default_access_allowed = 0;

# Settings:
#   Blog ID => Permission
# Permission:
#   1:not allowed  2:allowed  0:inherit
my $default_access_overrides = { 1 => 1 };

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
};

sub undef_to_empty_string {
    defined( $_[0] ) ? $_[0] : '';
}

sub register_3rd_blog {
    require MT::Blog;
    return if MT::Blog->load(3);

    my $blog = MT::Blog->new();
    $blog->set_values(
        {   name         => '3rd',
            site_url     => '/::/3rd/',
            archive_url  => '/::/3rd/archives/',
            site_path    => 'site/',
            archive_path => 'site/archives/',
            archive_type => 'Individual,Monthly,Weekly,Daily,Category,Page',
            archive_type_preferred   => 'Individual',
            description              => "3rd Blog",
            custom_dynamic_templates => 'custom',
            convert_paras            => 1,
            allow_reg_comments       => 1,
            allow_unreg_comments     => 0,
            allow_pings              => 1,
            sort_order_posts         => 'descend',
            sort_order_comments      => 'ascend',
            remote_auth_token        => 'token',
            convert_paras_comments   => 1,
            google_api_key           => 'r9Vj5K8PsjEu+OMsNZ/EEKjWmbCeQAv1',
            cc_license =>
                'by-nc-sa http://creativecommons.org/licenses/by-nc-sa/2.0/ http://creativecommons.org/images/public/somerights20.gif',
            server_offset        => '-3.5',
            children_modified_on => '20000101000000',
            language             => 'en_us',
            file_extension       => 'html',
            theme_id             => 'classic_blog',
        }
    );
    $blog->id(3);
    $blog->class('blog');
    $blog->parent_id(2);
    $blog->commenter_authenticators('enabled_TypeKey');
    $blog->save() or die "Couldn't save blog 1: " . $blog->errstr;

    my $classic_blog = MT::Theme->load('classic_blog')
        or die MT::Theme->errstr;
    $classic_blog->apply($blog);
    $blog->save() or die "Couldn't save blog 3: " . $blog->errstr;

    my $entry = MT::Entry->new();
    $entry->set_values(
        {   blog_id        => 3,
            title          => "3rd Blog's entry",
            text           => "3rd Blog's entry",
            text_more      => "3rd Blog's entry more",
            excerpt        => "3rd Blog's entry excerpt",
            keywords       => 'keywords',
            created_on     => '19780131074500',
            authored_on    => '19780131074500',
            modified_on    => '19780131074600',
            authored_on    => '19780131074500',
            author_id      => 1,
            allow_comments => 1,
            allow_pings    => 1,
            status         => MT::Entry::RELEASE(),
        }
    );
    $entry->tags( 'rain', 'grandpa', 'strolling' );
    $entry->save();

    require MT::Category;
    my $cat = new MT::Category;
    $cat->blog_id(3);
    $cat->label('foo');
    $cat->description('bar');
    $cat->author_id(1);
    $cat->parent(0);
    $cat->save or die "Couldn't save category record 1: " . $cat->errstr;

    my $place = new MT::Placement;
    $place->entry_id( $entry->id );
    $place->blog_id(3);
    $place->category_id( $cat->id );
    $place->is_primary(1);
    $place->save
        or die "Couldn't save placement record: " . $place->errstr;
}
&register_3rd_blog();

run {
    my $block = shift;

SKIP:
    {
        skip $block->skip, 1 if $block->skip;

        # Get system setting
        my $rebuild_trigger = MT->model('rebuild_trigger')->load( { blog_id => 0 } );
        unless ($rebuild_trigger) {
            $rebuild_trigger = MT->model('rebuild_trigger')->new();
            $rebuild_trigger->blog_id(0);
            $rebuild_trigger->data('{}');
        }
        my $data
            = $rebuild_trigger->data()
            ? MT::Util::from_json( $rebuild_trigger->data() )
            : {};

        my $overrides
            = $block->access_overrides
            ? eval $block->access_overrides
            : $default_access_overrides;
        $data->{access_overrides} = $overrides;

        my $allowed
            = defined( $block->default_access_allowed )
            ? $block->default_access_allowed
            : $default_access_allowed;
        chomp($allowed);
        $data->{default_access_allowed} = $allowed;

        $rebuild_trigger->data( MT::Util::to_json($data) );
        $rebuild_trigger->save;

        my $tmpl = $app->model('template')->new;
        $tmpl->text( $block->template );
        my $ctx = $tmpl->context;

        my $blog = MT::Blog->load( $block->blog_id || $blog_id );
        $ctx->stash( 'blog',          $blog );
        $ctx->stash( 'blog_id',       $blog->id );
        $ctx->stash( 'local_blog_id', $blog->id );
        $ctx->stash( 'builder',       MT::Builder->new );

        my $result = $tmpl->build;
        $result =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g;

        is( $result, $block->expected, $block->name );
    }
};

sub php_test_script {
    my ( $template, $blog_id, $text ) = @_;
    $text ||= '';

    my $test_script = <<PHP;
<?php
\$MT_HOME   = '@{[ $ENV{MT_HOME} ? $ENV{MT_HOME} : '.' ]}';
\$MT_CONFIG = '@{[ $app->find_config ]}';
\$blog_id   = '$blog_id';
\$tmpl = <<<__TMPL__
$template
__TMPL__
;
\$text = <<<__TMPL__
$text
__TMPL__
;
PHP
    $test_script .= <<'PHP';
include_once($MT_HOME . '/php/mt.php');
include_once($MT_HOME . '/php/lib/MTUtil.php');

$mt = MT::get_instance(1, $MT_CONFIG);
$mt->init_plugins();

$db = $mt->db();
$ctx =& $mt->context();

$ctx->stash('blog_id', $blog_id);
$ctx->stash('local_blog_id', $blog_id);
$blog = $db->fetch_blog(2);
$ctx->stash('blog', $blog);

if ($ctx->_compile_source('evaluated template', $tmpl, $_var_compiled)) {
    $ctx->_eval('?>' . $_var_compiled);
} else {
    print('Error compiling template module.');
}

?>
PHP
}

SKIP:
{
    unless ( join( '', `php --version 2>&1` ) =~ m/^php/i ) {
        skip "Can't find executable file: php",
            1 * blocks('expected_dynamic');
    }

    run {
        my $block = shift;

    SKIP:
        {
            skip $block->skip, 1 if $block->skip;

            # Get system setting
            my $rebuild_trigger = MT->model('rebuild_trigger')->load( { blog_id => 0 } );
            unless ($rebuild_trigger) {
                $rebuild_trigger = MT->model('rebuild_trigger')->new();
                $rebuild_trigger->blog_id(0);
                $rebuild_trigger->data('{}');
            }
            my $data
                = $rebuild_trigger->data()
                ? MT::Util::from_json( $rebuild_trigger->data() )
                : {};

            my $overrides
                = $block->access_overrides
                ? eval $block->access_overrides
                : $default_access_overrides;
            $data->{access_overrides} = $overrides;

            my $allowed
                = defined( $block->default_access_allowed )
                ? $block->default_access_allowed
                : $default_access_allowed;
            chomp($allowed);
            $data->{default_access_allowed} = $allowed;

            $rebuild_trigger->data( MT::Util::to_json($data) );
            $rebuild_trigger->save;

            open2( my $php_in, my $php_out, 'php -q' );
            print $php_out &php_test_script( $block->template,
                $block->blog_id || $blog_id,
                $block->text );
            close $php_out;
            my $php_result = do { local $/; <$php_in> };
            $php_result =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g;

            my $name = $block->name . ' - dynamic';
            is( $php_result, $block->expected, $name );
        }
    };
}

__END__

=== mt:Entries
--- template
<mt:Entries>
<mt:EntryTitle />
</mt:Entries>
--- expected
--- access_overrides
{ 1 => 1, 2 => 2, 3 => 2}

=== mt:Categories
--- template
<mt:Categories>
<mt:CategoryID />
</mt:Categories>
--- expected
--- access_overrides
{ 1 => 1, 2 => 2, 3 => 2}

=== mt:Blogs with blog_ids and class="*" (Default access: denied)
--- template
<mt:Blogs include_blogs="1,3" class="*">
<mt:BlogID />
</mt:Blogs>
--- expected
--- default_access_allowed
0
--- access_overrides
{ 1 => 0, 2 => 0, 3 => 0}

=== mt:Blogs with no attributes (Default access: denied)
--- template
<mt:Blogs>
<mt:BlogID />
</mt:Blogs>
--- expected
--- default_access_allowed
0
--- access_overrides
{ 1 => 0, 2 => 0, 3 => 0}

=== mt:Websites without attributes (Default access: denied)
--- template
<mt:Websites>
<mt:WebsiteID />
</mt:Websites>
--- expected
--- default_access_allowed
0
--- access_overrides
{ 1 => 0, 2 => 0, 3 => 0}
--- blog_id
1
