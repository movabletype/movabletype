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
my $app = MT->instance;

my $blog_id = 1;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
};

my $entry_meta_fields = {
    'field.test_text'    => 'text',
    'field.test_integer' => 'integer',
};

my $mt          = MT->instance;
my $blog_class  = $mt->model('blog');
my $entry_class = $mt->model('entry');
$entry_class->install_meta( { column_defs => $entry_meta_fields, } );

if ( !$blog_class->load(1) ) {
    my $b = $blog_class->new;
    $b->set_values( { id => 1, } );
    $b->save or die $b->errstr;
}

$entry_class->remove_all( { blog_id => 1 } );
for my $v (qw(1 2 10)) {
    my $e = $entry_class->new;
    $e->set_values(
        {   title     => $v,
            blog_id   => 1,
            author_id => 1,
            status    => MT::Entry::RELEASE,
        }
    );
    $e->meta( 'field.test_text',    $v );
    $e->meta( 'field.test_integer', $v );
    $e->save or die $e->errstr;
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

    my $entry_meta_fields_php = 'array(';
    while ( my ( $name, $type ) = each %$entry_meta_fields ) {
        $entry_meta_fields_php .= "'$name' => '$type',";
    }
    $entry_meta_fields_php .= ')';

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
\$entry_meta_fields = $entry_meta_fields_php;
PHP
    $test_script .= <<'PHP';
include_once($MT_HOME . '/php/mt.php');
include_once($MT_HOME . '/php/lib/MTUtil.php');

$mt = MT::get_instance(1, $MT_CONFIG);
$mt->init_plugins();

$db = $mt->db();
$ctx =& $mt->context();

foreach($entry_meta_fields as $name => $type) {
    BaseObject::install_meta('entry', $name, $type);
}

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
            1 * blocks;
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

=== mt:Entries sort_by="field.test_text"
--- template
<mt:entries sort_by="field.test_text"><mt:EntryTitle />
</mt:entries>
--- expected
2
10
1

=== mt:Entries sort_by="field.test_integer"
--- template
<mt:entries sort_by="field.test_integer"><mt:EntryTitle />
</mt:entries>
--- expected
10
2
1

=== mt:Entries sort_by="field.test_text" sort_order="ascend"
--- template
<mt:entries sort_by="field.test_text" sort_order="ascend"><mt:EntryTitle />
</mt:entries>
--- expected
1
10
2

=== mt:Entries sort_by="field.test_integer" sort_order="ascend"
--- template
<mt:entries sort_by="field.test_integer" sort_order="ascend"><mt:EntryTitle />
</mt:entries>
--- expected
1
2
10

=== mt:Entries sort_by="field.test_text" offset="1"
--- template
<mt:entries offset="1" sort_by="field.test_text"><mt:EntryTitle />
</mt:entries>
--- expected
10
1

=== mt:Entries sort_by="field.test_integer" offset="1"
--- template
<mt:entries offset="1" sort_by="field.test_integer"><mt:EntryTitle />
</mt:entries>
--- expected
2
1

=== mt:Entries sort_by="field.test_text" offset="3"
--- template
<mt:entries offset="3" sort_by="field.test_text"><mt:EntryTitle />
</mt:entries>
--- expected

=== mt:Entries sort_by="field.test_integer" offset="3"
--- template
<mt:entries offset="3" sort_by="field.test_integer"><mt:EntryTitle />
</mt:entries>
--- expected

=== mt:Entries sort_by="field.test_text" limit="1"
--- template
<mt:entries limit="1" sort_by="field.test_text"><mt:EntryTitle />
</mt:entries>
--- expected
2

=== mt:Entries sort_by="field.test_integer" limit="1"
--- template
<mt:entries limit="1" sort_by="field.test_integer"><mt:EntryTitle />
</mt:entries>
--- expected
10

=== mt:Entries sort_by="field.test_text" limit="5"
--- template
<mt:entries limit="5" sort_by="field.test_text"><mt:EntryTitle />
</mt:entries>
--- expected
2
10
1

=== mt:Entries sort_by="field.test_integer" limit="5"
--- template
<mt:entries limit="5" sort_by="field.test_integer"><mt:EntryTitle />
</mt:entries>
--- expected
10
2
1

=== mt:Entries sort_by="field.test_text" limit="1" offset="2"
--- template
<mt:entries limit="1" offset="2" sort_by="field.test_text"><mt:EntryTitle />
</mt:entries>
--- expected
1

=== mt:Entries sort_by="field.test_integer" limit="1" offset="2"
--- template
<mt:entries limit="1" offset="2" sort_by="field.test_integer"><mt:EntryTitle />
</mt:entries>
--- expected
1

=== mt:Entries sort_by="field.test_text" sort_order="ascend" limit="1" offset="2"
--- template
<mt:entries limit="1" offset="2" sort_by="field.test_text" sort_order="ascend"><mt:EntryTitle />
</mt:entries>
--- expected
2

=== mt:Entries sort_by="field.test_integer" sort_order="ascend" limit="1" offset="2"
--- template
<mt:entries limit="1" offset="2" sort_by="field.test_integer" sort_order="ascend"><mt:EntryTitle />
</mt:entries>
--- expected
10
