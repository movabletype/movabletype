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

{
    my $tmpl = $app->model('template')->new;
    $tmpl->blog_id(2);
    $tmpl->name('template-module');
    $tmpl->text('template-module:2');
    $tmpl->type('custom');
    $tmpl->save or die "Couldn't save template record 1: " . $tmpl->errstr;
}

my $blog_id = 2;

my $plugin = $app->component('MultiBlog');
$plugin->set_config_value( 'default_access_allowed', '0', 'system' );

my $default_access_overrides = {
    # not allowed
    1 => 1,
    # allowed
    # 1 => 2,
    # inherit
    # 1 => 0,
};

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
};

sub undef_to_empty_string {
    defined( $_[0] ) ? $_[0] : '';
}

run {
    my $block = shift;

    SKIP:
    {
        skip $block->skip, 1 if $block->skip;

        my $overrides =
          $block->access_overrides
          ? eval $block->access_overrides
          : $default_access_overrides;
        $plugin->set_config_value( 'access_overrides', $overrides, 'system' );

        my $tmpl = $app->model('template')->new;
        $tmpl->text( $block->template );
        my $ctx = $tmpl->context;

        my $blog = MT::Blog->load($blog_id);
        $ctx->stash( 'blog',    $blog );
        $ctx->stash( 'blog_id', $blog->id );
        $ctx->stash( 'local_blog_id', $blog->id );
        $ctx->stash( 'builder', MT::Builder->new );

        my $result = $tmpl->build;
        $result =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g;

        is( $result, $block->expected, $block->name );
    }
};

sub php_test_script {
    my ($template, $text) = @_;
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

$mt = MT::get_instance($blog_id, $MT_CONFIG);
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
        skip "Can't find executable file: php", 1 * blocks('expected_dynamic');
    }

    run {
        my $block = shift;

        SKIP:
        {
            skip $block->skip, 1 if $block->skip;
            my $overrides =
              $block->access_overrides
              ? eval $block->access_overrides
              : $default_access_overrides;
            $plugin->set_config_value( 'access_overrides', $overrides,
                'system' );

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
<mt:Blogs include_blogs="1,2,3">
<mt:BlogID />
</mt:Blogs>
--- expected


=== mt:Entries
--- template
<mt:Entries include_blogs="1,2,3">
<mt:EntryID />
</mt:Entries>
--- expected


=== mt:Categories
--- template
<mt:Categories include_blogs="1,2,3">
<mt:CategoryID />
</mt:Categories>
--- expected


=== mt:Comments
--- template
<mt:Comments include_blogs="1,2,3">
<mt:CommentBody />
</mt:Comments>
--- expected


=== mt:Pages
--- template
<mt:Pages include_blogs="1,2,3">
<mt:PageID />
</mt:Pages>
--- expected


=== mt:Folders
--- template
<mt:Folders include_blogs="1,2,3">
<mt:FolderID />
</mt:Folders>
--- expected


=== mt:Assets
--- template
<mt:Assets include_blogs="1,2,3">
<mt:AssetID />
</mt:Assets>
--- expected


=== mt:Pings
--- template
<mt:Pings include_blogs="1,2,3">
<mt:PingURL />
</mt:Pings>
--- expected


=== mt:Authors
--- template
<mt:Authors include_blogs="1,2,3">
<mt:AuthorID />
</mt:Authors>
--- expected


=== mt:Tags
--- template
<mt:Tags include_blogs="1,2,3">
<mt:TagName />
</mt:Tags>
--- expected


=== mt:Include outside MultiBlog
--- template
<mt:Include module="blog-name" blog_id="1" />
--- expected
Test site


=== mt:Include
--- template
<mt:MultiBlog blog_ids="1" mode="loop">
    <mt:Include module="blog-name" />
</mt:MultiBlog>
--- expected
none
--- access_overrides
{ 1 => 2 }


=== mt:Include after Multiblog with mode="context"
--- template
<mt:Entries blog_ids="1" lastn="1">
<mt:MultiBlog mode="context" include_blogs="1">
</mt:MultiBlog>
<mt:Include module="template-module" />
</mt:Entries>
--- expected
template-module:2
--- access_overrides
{ 1 => 2 }


=== mt:Include after Multiblog with mode="loop"
--- template
<mt:Entries blog_ids="1">
<mt:MultiBlog mode="loop">
</mt:MultiBlog>
</mt:Entries>
<mt:Include module="template-module" />
--- expected
template-module:2
--- access_overrides
{ 1 => 2 }


=== mt:BlogCategoryCount
--- template
<mt:BlogCategoryCount include_blogs="1,2,3" />
--- expected
0


=== mt:BlogEntryCount
--- template
<mt:BlogEntryCount include_blogs="1,2,3" />
--- expected
0


=== mt:BlogPingCount
--- template
<mt:BlogPingCount include_blogs="1,2,3" />
--- expected
0


=== mt:TagSearchLink
--- template
<mt:MultiBlog blog_ids="1" mode="loop" trim="1">
<mt:Tags limit="1">
<mt:TagSearchLink />
</mt:Tags>
</mt:MultiBlog>
--- expected
http://narnia.na/cgi-bin/mt-search.cgi?IncludeBlogs=1&amp;tag=anemones&amp;limit=20
--- access_overrides
{ 1 => 2 }


=== mt:MultiBlog mode="loop"
--- template
<mt:MultiBlog blog_ids="all" mode="loop" trim="1"><mt:BlogID />,<mt:EntriesCount />:</mt:MultiBlog>
--- expected
1,6:2,0:
--- access_overrides
{ 1 => 2 }


=== mt:MultiBlog blog_ids="all" mode="context"
--- template
<mt:MultiBlog blog_ids="all" mode="context" trim="1"><mt:BlogID />:<mt:Entries glue="," sort_by="id" sort_order="ascend"><mt:EntryID /></mt:Entries></mt:MultiBlog>
--- expected
2:1,4,5,6,7,8
--- access_overrides
{ 1 => 2 }


=== mt:MultiBlog blog_ids="3" mode="context"
--- template
<mt:MultiBlog blog_ids="3" mode="context" trim="1"><mt:BlogID />:<mt:Entries glue="," sort_by="id" sort_order="ascend"><mt:EntryID /></mt:Entries></mt:MultiBlog>
--- expected
2:
--- access_overrides
{ 1 => 2 }


=== mt:MultiBlog include_blogs="all" mode="context"
--- template
<mt:MultiBlog include_blogs="all" mode="context" trim="1"><mt:BlogID />:<mt:Entries glue="," sort_by="id" sort_order="ascend"><mt:EntryID /></mt:Entries></mt:MultiBlog>
--- expected
2:1,4,5,6,7,8
--- access_overrides
{ 1 => 2 }


=== mt:OtherBlog
--- template
<mt:OtherBlog blog_id="1"><mt:BlogName /></mt:OtherBlog>
--- expected
none
--- access_overrides
{ 1 => 2 }


=== mt:OtherBlog and mt:Entry with category attribute
--- template
<mt:OtherBlog blog_id="1">
    <mt:Entries category="foo" glue=",">
        <mt:EntryTitle />
    </mt:Entries>
</mt:OtherBlog>
--- expected
Verse 3
--- access_overrides
{ 1 => 2 }


=== mt:MultiBlogLocalBlog mode="context"
--- template
<mt:MultiBlog blog_ids="1" mode="context">
    <mt:MultiBlogLocalBlog>
        <mt:BlogName />
    </mt:MultiBlogLocalBlog>
</mt:MultiBlog>
--- expected
Test site
--- access_overrides
{ 1 => 2 }


=== mt:MultiBlogLocalBlog mode="loop"
--- template
<mt:MultiBlog blog_ids="1" mode="loop">
    <mt:MultiBlogLocalBlog>
        <mt:BlogName />
    </mt:MultiBlogLocalBlog>
</mt:MultiBlog>
--- expected
Test site
--- access_overrides
{ 1 => 2 }


=== mt:MultiBlogIfLocalBlog
--- template
<mt:MultiBlog blog_ids="1" mode="loop">
    <mt:MultiBlogLocalBlog>
        <mt:MultiBlogIfLocalBlog>Foo</mt:MultiBlogIfLocalBlog>
    </mt:MultiBlogLocalBlog>
</mt:MultiBlog>
--- expected
Foo
--- access_overrides
{ 1 => 2 }

=== mt:MultiBlogLocalBlog mode="loop"
--- template
<mt:MultiBlog blog_ids="1,2-3" mode="loop"><mt:BlogName />,</mt:MultiBlog>
--- expected
none,Test site,
--- access_overrides
{ 1 => 2, 2 => 2}
