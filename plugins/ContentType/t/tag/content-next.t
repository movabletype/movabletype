#!/usr/bin/perl

use strict;
use warnings;

use lib qw(lib t/lib);

use IPC::Open2;

use Test::Base;

# plan tests => 2 * blocks;
plan tests => 1 * blocks;

use MT;
use MT::Test qw(:db);
use MT::Test::Permission;
my $app = MT->instance;

my $blog_id = 1;

my $vars = {};

sub var {
    for my $line (@_) {
        for my $key ( keys %{$vars} ) {
            my $replace = quotemeta "[% ${key} %]";
            my $value   = $vars->{$key};
            $line =~ s/$replace/$value/g;
        }
    }
    @_;
}

filters {
    template => [qw( var chomp )],
    expected => [qw( var chomp )],
    error    => [qw( chomp )],
};

my $mt = MT->instance;

my $author2 = MT::Test::Permission->make_author;

my $category_list
    = MT::Test::Permission->make_category_list( blog_id => $blog_id );

my $category1 = MT::Test::Permission->make_category(
    blog_id          => $category_list->blog_id,
    category_list_id => $category_list->id,
    label            => 'category1',
);
my $category2 = MT::Test::Permission->make_category(
    blog_id          => $category_list->blog_id,
    category_list_id => $category_list->id,
    label            => 'category2',
);
$vars->{cat1_id} = $category1->id;
$vars->{cat2_id} = $category2->id;

my $ct = MT::Test::Permission->make_content_type(
    name    => 'test content type',
    blog_id => $blog_id,
);
my $cf = MT::Test::Permission->make_content_field(
    blog_id             => $ct->blog_id,
    content_type_id     => $ct->id,
    name                => 'category',
    type                => 'category',
    related_cat_list_id => $category_list->id,
);
my $fields = [
    {   id      => $cf->id,
        order   => 1,
        type    => $cf->type,
        options => {
            label         => 1,
            category_list => $cf->related_cat_list_id,
        },
        unique_id => $cf->unique_id,
    }
];
$ct->fields($fields);
$ct->save or die $ct->errstr;

my $cd1 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    author_id       => 1,
    data            => { $cf->id => [ $category1->id ] },
);
my $cd2 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    author_id       => $author2->id,
    data            => { $cf->id => [ $category2->id ] },
);
my $cd3 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    author_id       => 1,
    data            => { $cf->id => [ $category1->id ] },
);

$cd1->authored_on('201706011930');
$cd1->modified_on('201706011930');
$cd1->save or die $cd1->errstr;

$cd2->authored_on('201705311930');
$cd2->modified_on('201706021930');
$cd2->save or die $cd2->errstr;

$cd3->authored_on('201705301930');
$cd3->modified_on('201706031930');
$cd3->save or die $cd3->errstr;

$vars->{cd1_id} = $cd1->id;
$vars->{cd2_id} = $cd2->id;
$vars->{cd3_id} = $cd3->id;

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

        my $result = eval { $tmpl->build };
        if ( defined $result ) {
            $result =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g;
            is( $result, $block->expected, $block->name );
        }
        else {
            $result = $ctx->errstr;
            $result =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g;
            is( $result, $block->error, $block->name . ' (error)' );
        }
    }
};

# sub php_test_script {
#     my ( $template, $text ) = @_;
#     $text ||= '';
#
#     my $test_script = <<PHP;
# <?php
# \$MT_HOME   = '@{[ $ENV{MT_HOME} ? $ENV{MT_HOME} : '.' ]}';
# \$MT_CONFIG = '@{[ $app->find_config ]}';
# \$blog_id   = '$blog_id';
# \$tmpl = <<<__TMPL__
# $template
# __TMPL__
# ;
# \$text = <<<__TMPL__
# $text
# __TMPL__
# ;
# PHP
#     $test_script .= <<'PHP';
# include_once($MT_HOME . '/php/mt.php');
# include_once($MT_HOME . '/php/lib/MTUtil.php');
#
# $mt = MT::get_instance(1, $MT_CONFIG);
# $mt->init_plugins();
#
# $db = $mt->db();
# $ctx =& $mt->context();
#
# $ctx->stash('blog_id', $blog_id);
# $ctx->stash('local_blog_id', $blog_id);
# $blog = $db->fetch_blog($blog_id);
# $ctx->stash('blog', $blog);
#
# if ($ctx->_compile_source('evaluated template', $tmpl, $_var_compiled)) {
#     $ctx->_eval('?>' . $_var_compiled);
# } else {
#     print('Error compiling template module.');
# }
#
# ?>
# PHP
# }
#
# SKIP:
# {
#     unless ( join( '', `php --version 2>&1` ) =~ m/^php/i ) {
#         skip "Can't find executable file: php",
#             1 * blocks('expected_dynamic');
#     }
#
#     run {
#         my $block = shift;
#
#     SKIP:
#         {
#             skip $block->skip, 1 if $block->skip;
#
#             open2( my $php_in, my $php_out, 'php -q' );
#             print $php_out &php_test_script( $block->template, $block->text );
#             close $php_out;
#             my $php_result = do { local $/; <$php_in> };
#             $php_result =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g;
#
#             my $name = $block->name . ' - dynamic';
#             is( $php_result, $block->expected, $name );
#         }
#     };
# }

__END__

=== MT:ContentNext
--- template
<mt:Contents blog_id="1" name="test content type"><mt:ContentNext><mt:ContentID></mt:ContentNext></mt:Contents>
--- expected
[% cd2_id %][% cd3_id %]

=== MT:ContentNext with by_author="1"
--- template
<mt:Contents blog_id="1" name="test content type"><mt:ContentNext by_author="1"><mt:ContentID></mt:ContentNext></mt:Contents>
--- expected
[% cd3_id %]

=== MT:ContentNext with by_authored_on="1"
--- template
<mt:Contents blog_id="1" name="test content type"><mt:ContentNext by_authored_on="1"><mt:ContentID></mt:ContentNext></mt:Contents>
--- expected
[% cd1_id %][% cd2_id %]

=== MT:ContentNext with by_category="1"
--- template
<mt:Contents blog_id="1" name="test content type"><mt:ContentNext by_category="1"><mt:ContentID></mt:ContentNext></mt:Contents>
--- expected
[% cd3_id %]

=== MT:ContentNext with by_category="1" category_id="???"
--- template
<mt:Contents blog_id="1" name="test content type"><mt:ContentNext by_category="1" category_id="[% cat2_id %]"><mt:ContentID></mt:ContentNext></mt:Contents>
--- expected
[% cd3_id %]

