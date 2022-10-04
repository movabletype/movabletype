#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib";    # t/lib
use Test::More;

BEGIN {
    eval { require PHP::Serialization }
        or plan skip_all => 'PHP::Serialization is not installed';
}

use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use Test::Base;
use MT;
use MT::Test::Tag;
use MT::Test::Permission;

plan tests => (1 + 2) * blocks;

my $app = MT->instance;

$test_env->prepare_fixture('db_data');

my $blog_id = 2;

# Remove objects in website (blog_id = 2).
$app->model('page')->remove( { id => 24 } );

my $entry = MT::Test::Permission->make_entry(
    blog_id => $blog_id,
    status  => MT::Entry::RELEASE(),
);
$entry->tags('anemones');
$entry->save() or die "Couldn't save entry record 3: " . $entry->errstr;

{
    my $tmpl = $app->model('template')->new;
    $tmpl->blog_id($blog_id);
    $tmpl->name('template-module');
    $tmpl->text('template-module:2');
    $tmpl->type('custom');
    $tmpl->save or die "Couldn't save template record: " . $tmpl->errstr;
}

$app->config( 'DefaultAccessAllowed', 0, 1 );
$app->config->save_config;

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

sub set_access_overrides {
    my $block = shift;
    my $overrides = $block->access_overrides ? eval $block->access_overrides : $default_access_overrides;
    $app->config( 'AccessOverrides', MT::Util::to_json($overrides), 1 );
    $app->config->save_config;
}

MT::Test::Tag->run_perl_tests( $blog_id, sub {
    my ($ctx, $block) = @_;

    set_access_overrides($block);

    {
        require MT::Template::Handler;
        $ctx->{__handlers}{ lc('InvokeEntries') }
            = MT::Template::Handler->new(
            sub {
                my $ctx = shift;
                $ctx->invoke_handler( 'entries', @_ );
            },
            1,
            undef
            );
    }

    if ( $block->ctx_stash ) {
        my $ctx_stash = eval $block->ctx_stash;
        for my $k ( keys %$ctx_stash ) {
            my $v = $ctx_stash->{$k};
            if ( $k eq 'archive_category' || $k eq 'category' ) {
                $v = $app->model('category')->load($v);
            }
            elsif ( $k eq 'entries' ) {
                my @entries = $app->model('entry')->load( { id => $v } );
                $v = [
                    map {
                        my $id = $_;
                        grep { $_->id == $id } @entries;
                    } ( ref $v ? @$v : $v )
                ];
            }
            $ctx->stash( $k, $v );
        }
    }

    if ( $block->ctx_values ) {
        my $ctx_values = eval $block->ctx_values;
        for my $k ( keys %$ctx_values ) {
            $ctx->{$k} = $ctx_values->{$k};
        }
    }
});

MT::Test::Tag->run_php_tests( $blog_id, sub {
    my $block = shift;

    set_access_overrides($block);

    my $ctx_stash = {
        $block->ctx_values ? %{ eval($block->ctx_values) } : (),
        $block->ctx_stash  ? %{ eval($block->ctx_stash) }  : (),
    };

    my $test_script = <<"PHP";
\$ctx_stash = unserialize('@{[ PHP::Serialization::serialize($ctx_stash) ]}');
PHP

    $test_script .= <<'PHP';
foreach($ctx_stash as $k => $v) {
    if ($k == 'archive_category' || $k == 'category') {
        require_once('class.mt_category.php');
        $cat = new Category;
        $cat->Load($v);
        $v = $cat;
        if ($v) $ctx->stash($k, $v);
    }
    if ($k == 'entries') {
        require_once('class.mt_entry.php');
        $entries = array();
        foreach ($v as $id) {
            $e = new Entry;
            $e->Load($id);
            $entries[] = $e;
        }
        $v = $entries;
        if ($v) $ctx->stash($k, $v);
    }
    $ctx->stash($k, $v);
}
PHP

    return $test_script;
} );

__END__

=== mt:Blogs with include_blogs
--- template
<mt:Blogs include_blogs="1,2,3">
<mt:BlogID />
</mt:Blogs>
--- expected


=== mt:Blogs with include_sites
--- template
<mt:Blogs include_sites="1,2,3">
<mt:BlogID />
</mt:Blogs>
--- expected


=== mt:Blog will be localizeing timestamp context if ignore_archive_context="1" is given.
--- template
<mt:Blogs include_sites="1" ignore_archive_context="1">
<mt:Entries limit="2" glue=","><mt:EntryTitle /></mt:Entries>
</mt:Blogs>
--- expected
A Rainy Day,Verse 5
--- ctx_values
{ current_timestamp => '19780131073500', current_timestamp_end => '19780131074500' }
--- access_overrides
{ 1 => 2 }


=== mt:Entries
--- template
<mt:Entries include_sites="1,2,3">
<mt:EntryID />
</mt:Entries>
--- expected
25

=== mt:Categories
--- template
<mt:Categories include_sites="1,2,3">
<mt:CategoryID />
</mt:Categories>
--- expected


=== mt:Comments (for core)
--- template
<mt:HasPlugin name="Comments"><mt:Else>
<mt:Comments include_sites="1,2,3">
<mt:CommentBody />
</mt:Comments>
</mt:HasPlugin>
--- expected


=== mt:Pages
--- template
<mt:Pages include_sites="1,2,3">
<mt:PageID />
</mt:Pages>
--- expected


=== mt:Folders
--- template
<mt:Folders include_sites="1,2,3">
<mt:FolderID />
</mt:Folders>
--- expected


=== mt:Assets
--- template
<mt:Assets include_sites="1,2,3">
<mt:AssetID />
</mt:Assets>
--- expected


=== mt:Pings (for core)
--- template
<mt:HasPlugin name="Trackback"><mt:Else>
<mt:Pings include_sites="1,2,3">
<mt:PingURL />
</mt:Pings>
</mt:HasPlugin>
--- expected


=== mt:Authors
--- template
<mt:Authors include_sites="1,2,3">
<mt:AuthorID />
</mt:Authors>
--- expected
1

=== mt:Tags
--- template
<mt:Tags include_sites="1,2,3">
<mt:TagName />
</mt:Tags>
--- expected
anemones

=== mt:Include outside MultiBlog
--- template
<mt:Include module="blog-name" blog_id="1" />
<mt:Include module="blog-name" site_id="1" />
--- expected
Test site
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
<mt:MultiBlog mode="context" include_sites="1">
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
<mt:BlogCategoryCount include_sites="1,2,3" />
--- expected
6


=== mt:BlogEntryCount with include_blogs
--- template
<mt:BlogEntryCount include_blogs="1,2,3" />
--- expected
1


=== mt:BlogEntryCount
--- template
<mt:BlogEntryCount include_sites="1,2,3" />
--- expected
1


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
1,6:2,1:
--- access_overrides
{ 1 => 2 }


=== mt:MultiBlog blog_ids="all" mode="context"
--- template
<mt:MultiBlog blog_ids="all" mode="context" trim="1"><mt:BlogID />:<mt:Entries glue="," sort_by="id" sort_order="ascend"><mt:EntryID /></mt:Entries></mt:MultiBlog>
--- expected
2:1,4,5,6,7,8,25
--- access_overrides
{ 1 => 2 }


=== mt:MultiBlog blog_ids="3" mode="context"
--- template
<mt:MultiBlog blog_ids="3" mode="context" trim="1"><mt:BlogID />:<mt:Entries glue="," sort_by="id" sort_order="ascend"><mt:EntryID /></mt:Entries></mt:MultiBlog>
--- expected
2:
--- access_overrides
{ 1 => 2 }


=== mt:MultiBlog include_sites="all" mode="context"
--- template
<mt:MultiBlog include_sites="all" mode="context" trim="1"><mt:BlogID />:<mt:Entries glue="," sort_by="id" sort_order="ascend"><mt:EntryID /></mt:Entries></mt:MultiBlog>
--- expected
2:1,4,5,6,7,8,25
--- access_overrides
{ 1 => 2 }


=== mt:OtherBlog
--- template
<mt:OtherBlog blog_id="1"><mt:BlogName /></mt:OtherBlog>
<mt:OtherBlog site_id="1"><mt:BlogName /></mt:OtherBlog>
--- expected
none
none
--- access_overrides
{ 1 => 2 }


=== mt:OtherBlog and mt:Entry with blog_id, category attribute
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


=== mt:OtherBlog and mt:Entry with site_id, category attribute
--- template
<mt:OtherBlog site_id="1">
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


=== mt:MultiBlog will not be localizeing timestamp context.
--- template
<mt:MultiBlog blog_ids="1" mode="loop">
<mt:Entries limit="2" glue=","><mt:EntryTitle /></mt:Entries>
</mt:MultiBlog>
--- expected
A Rainy Day
--- ctx_values
{ current_timestamp => '19780131073500', current_timestamp_end => '19780131074500' }
--- access_overrides
{ 1 => 2 }


=== mt:MultiBlog will be localizeing timestamp context if ignore_archive_context="1" is given.
--- template
<mt:MultiBlog blog_ids="1" mode="loop" ignore_archive_context="1">
<mt:Entries limit="2" glue=","><mt:EntryTitle /></mt:Entries>
</mt:MultiBlog>
--- expected
A Rainy Day,Verse 5
--- ctx_values
{ current_timestamp => '19780131073500', current_timestamp_end => '19780131074500' }
--- access_overrides
{ 1 => 2 }


=== mt:MultiBlog will not be localizeing category context.
--- template
<mt:MultiBlog blog_ids="1" mode="loop">
<mt:Entries glue=","><mt:EntryTitle /></mt:Entries>
</mt:MultiBlog>
--- expected
Verse 3
--- ctx_stash
{ archive_category => 1, category => 1 }
--- access_overrides
{ 1 => 2 }


=== mt:MultiBlog will be localizeing category context if ignore_archive_context="1" is given.
--- template
<mt:MultiBlog blog_ids="1" mode="loop" ignore_archive_context="1">
<mt:Entries glue=","><mt:EntryTitle /></mt:Entries>
</mt:MultiBlog>
--- expected
A Rainy Day,Verse 5,Verse 4,Verse 3,Verse 2,Verse 1
--- ctx_stash
{ archive_category => 1, category => 1 }
--- access_overrides
{ 1 => 2 }


=== mt:Entries will be ignoreing entries context if $entry->blog_id != $current_blog->id.
--- template
<mt:MultiBlog blog_ids="2" mode="loop">
<mt:Entries limit="1"><mt:EntryTitle /></mt:Entries>
</mt:MultiBlog>
--- skip_php
1
--- expected
A Rainy Day
--- ctx_stash
{ entries => [1] }
--- access_overrides
{ 1 => 2 }


=== mt:Entries will not be ignoreing entries context if invoked by other tag.
--- template
<mt:MultiBlog blog_ids="2" mode="loop">
<mt:InvokeEntries limit="1"><mt:EntryTitle /></mt:InvokeEntries>
</mt:MultiBlog>
--- skip_php
1
--- expected
A Rainy Day
--- ctx_stash
{ entries => [1] }
--- access_overrides
{ 1 => 2 }

=== MTC-28585 MTInclude after MTTags does not cause php warnings
--- template
<MTTags glue=','><MTTagName> <MTTagRank></MTTags>
<mt:Include module="template-module">
--- expected
anemones 6
template-module:2

=== MTC-28598 mt:MultiBlogIfLocalBlog never be TRUE in context mode
--- template
<mt:MultiBlog mode="context">:<MTTags glue=','><mt:BlogID><mt:MultiBlogIfLocalBlog>NEVER-VISIBLE</mt:MultiBlogIfLocalBlog></MTTags></mt:MultiBlog>
--- expected
:2

=== MTC-28598 mt:MultiBlogIfLocalBlog never be TRUE  in loop mode
--- template
<mt:MultiBlog mode="loop">:<MTTags glue=','><mt:BlogID><mt:MultiBlogIfLocalBlog>NEVER-VISIBLE</mt:MultiBlogIfLocalBlog></MTTags></mt:MultiBlog>
--- expected
:2

=== mt:MultiBlogLocalBlog mode="loop"
--- template
<mt:MultiBlog blog_ids="1,2-3" mode="loop">:<MTTags glue=','><mt:BlogName><mt:MultiBlogIfLocalBlog>NEVER-VISIBLE</mt:MultiBlogIfLocalBlog></MTTags></mt:MultiBlog>
--- expected
:none,none,none,none,none:Test site
--- access_overrides
{ 1 => 2 }

=== MTC-28598 mt:MultiBlogLocalBlog inside mt:Tags
--- template
<mt:MultiBlog mode="context">:<MTTags glue=','><mt:BlogID>:<mt:MultiBlogLocalBlog><mt:BlogID></mt:MultiBlogLocalBlog></MTTags></mt:MultiBlog>
--- expected
:2:2
