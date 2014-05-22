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
use MT::Test qw(:db);
use MT::Test::Permission;
my $app = MT->instance;

my $blog_id = 1;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
};

my $mt = MT->instance;

# Make test data
my $b = $mt->model('blog')->new;
$b->set_values( { id => 1, } );
$b->save or die $b->errstr;

my $cat = MT::Test::Permission->make_category( blog_id => $b->id, );

my $folder = MT::Test::Permission->make_category( blog_id => $b->id, );

my @dates = (
    {   authored_on  => '20131201000000',
        modified_on  => '20130901000000',
        has_category => 0
    },
    {   authored_on  => '20131101000000',
        modified_on  => '20131001000000',
        has_category => 1
    },
    {   authored_on  => '20131001000000',
        modified_on  => '20131101000000',
        has_category => 1
    },
    {   authored_on  => '20130901000000',
        modified_on  => '20131201000000',
        has_category => 1
    },
);
foreach (@dates) {
    my %values = (
        blog_id     => 1,
        author_id   => 1,
        status      => MT::Entry::RELEASE,
        authored_on => $_->{authored_on},
        modified_on => $_->{modified_on},
        created_on  => $_->{modified_on},
    );

    # page
    my $p = $mt->model('page')->new;
    $p->set_values( \%values );
    $p->save or die $p->errstr;

    # entry
    my $e = $mt->model('entry')->new;
    $e->set_values( \%values );
    $e->save or die $e->errstr;

    next unless $_->{has_category};

    # associate with category/folder
    my $p_place = $mt->model('placement')->new;
    $p_place->set_values(
        {   blog_id     => $b->id,
            category_id => $folder->id,
            entry_id    => $p->id,
            is_primary  => 1,
        }
    );
    $p_place->save or die $p_place->errstr;

    my $e_place = $mt->model('placement')->new;
    $e_place->set_values(
        {   blog_id     => $b->id,
            category_id => $cat->id,
            entry_id    => $e->id,
            is_primary  => 1,
        }
    );
    $e_place->save or die $e_place->errstr;
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

=== mt:PageNext
--- template
<MTPages><MTPageNext><MTPageID></MTPageNext></MTPages>
--- expected
357

=== mt:PagePrevious
--- template
<MTPages><MTPagePrevious><MTPageID></MTPagePrevious></MTPages>
--- expected
135

=== mt:EntryNext
--- template
<MTEntries><MTEntryNext><MTEntryID></MTEntryNext></MTEntries>
--- expected
246

=== mt:EntryPrevious
--- template
<MTEntries><MTEntryPrevious><MTEntryID></MTEntryPrevious></MTEntries>
--- expected
468

=== mt:PageNext (by_category="1")
--- template
<MTPages><MTPageNext by_category="1"><MTPageID></MTPageNext></MTPages>
--- expected
57

=== mt:PagePrevious (by_category="1")
--- template
<MTPages><MTPagePrevious by_category="1"><MTPageID></MTPagePrevious></MTPages>
--- expected
35

=== mt:EntryNext (by_category="1")
--- template
<MTEntries><MTEntryNext by_category="1"><MTEntryID></MTEntryNext></MTEntries>
--- expected
46

=== mt:EntryPrevious (by_category="1")
--- template
<MTEntries><MTEntryPrevious by_category="1"><MTEntryID></MTEntryPrevious></MTEntries>
--- expected
68

=== mt:PageNext (by_folder="1")
--- template
<MTPages><MTPageNext by_folder="1"><MTPageID></MTPageNext></MTPages>
--- expected
57

=== mt:PagePrevious (by_folder="1")
--- template
<MTPages><MTPagePrevious by_folder="1"><MTPageID></MTPagePrevious></MTPages>
--- expected
35

=== mt:EntryNext (by_folder="1")
--- template
<MTEntries><MTEntryNext by_folder="1"><MTEntryID></MTEntryNext></MTEntries>
--- expected
46

=== mt:EntryPrevious (by_folder="1")
--- template
<MTEntries><MTEntryPrevious by_folder="1"><MTEntryID></MTEntryPrevious></MTEntries>
--- expected
68
