#!/usr/bin/perl

use strict;
use warnings;

use lib qw(lib t/lib);

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use IPC::Open2;

use Test::Base;
plan tests => 2 * blocks;

use MT;
use MT::Test qw(:db :data);
my $app = MT->instance;

my $blog_id = 2;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
};

sub undef_to_empty_string {
    defined( $_[0] ) ? $_[0] : '';
}

# Register a lot of blogs.
require MT::Blog;
for my $i ( 3 .. 20 ) {
    next if MT::Blog->load($i);

    my $blog = MT::Blog->new();
    $blog->set_values(
        {   name         => 'Blog: ' . $i,
            site_url     => '/::/' . $i,
            archive_url  => '/::/blog' . $i . '/archives/',
            site_path    => 'site/',
            archive_path => 'site/archives/',
            archive_type => 'Individual,Monthly,Weekly,Daily,Category,Page',
            archive_type_preferred   => 'Individual',
            description              => 'Blog: ' . $i,
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
    $blog->id($i);
    $blog->class('blog');
    $blog->parent_id(2);
    $blog->commenter_authenticators('enabled_TypeKey');
    $blog->save() or die "Couldn't save blog: " . $i . $blog->errstr;
}

run {
    my $block = shift;

SKIP:
    {
        skip $block->skip, 1 if $block->skip;

        my $tmpl = $app->model('template')->new;
        $tmpl->text( $block->template );
        my $ctx = $tmpl->context;

        my $blog = MT::Blog->load($blog_id);
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
    my ( $template, $text ) = @_;
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
$blog = $db->fetch_blog($blog_id);
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

            open2( my $php_in, my $php_out, 'php -q' );
            print $php_out &php_test_script( $block->template, $block->text );
            close $php_out;
            my $php_result = do { local $/; <$php_in> };
            $php_result =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g;

            my $name = $block->name . ' - dynamic';
            is( $php_result, $block->expected, $name );
        }
    };
}


__END__

=== mt:Blogs
--- template
<mt:Blogs include_blogs="1-20" exclude_blogs="1"><mt:BlogName />,</mt:Blogs>
--- expected
Blog: 10,Blog: 11,Blog: 12,Blog: 13,Blog: 14,Blog: 15,Blog: 16,Blog: 17,Blog: 18,Blog: 19,Blog: 20,Blog: 3,Blog: 4,Blog: 5,Blog: 6,Blog: 7,Blog: 8,Blog: 9,
