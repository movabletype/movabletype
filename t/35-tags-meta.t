#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;
plan tests => 2 * blocks;

use MT;

use MT::Test;

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

$test_env->prepare_fixture(sub {
    MT::Test->init_db;

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
                status    => MT::Entry::RELEASE(),
            }
        );
        $e->meta( 'field.test_text',    $v );
        $e->meta( 'field.test_integer', $v );
        $e->save or die $e->errstr;
    }
});

MT::Test::Tag->run_perl_tests($blog_id);
MT::Test::Tag->run_php_tests($blog_id, \&_set_entry_meta_php);

sub _set_entry_meta_php {
    my $block = shift;

    my $entry_meta_fields_php = 'array(';
    while ( my ( $name, $type ) = each %$entry_meta_fields ) {
        $entry_meta_fields_php .= "'$name' => '$type',";
    }
    $entry_meta_fields_php .= ')';
    return <<"PHP";
\$entry_meta_fields = $entry_meta_fields_php;
foreach(\$entry_meta_fields as \$name => \$type) {
    BaseObject::install_meta('entry', \$name, \$type);
}
PHP
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
