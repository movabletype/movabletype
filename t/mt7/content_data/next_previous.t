## -*- mode: perl; coding: utf-8 -*-
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test qw( :db );
use MT::Test::Permission;

use MT::Category;

my $blog_id = 1;

my $category_set
    = MT::Test::Permission->make_category_set( blog_id => $blog_id, );

my $category1 = MT::Test::Permission->make_category(
    blog_id         => $category_set->blog_id,
    category_set_id => $category_set->id,
    label           => 'category1',
);
my $category2 = MT::Test::Permission->make_category(
    blog_id         => $category_set->blog_id,
    category_set_id => $category_set->id,
    label           => 'category2',
);

my $ct = MT::Test::Permission->make_content_type(
    blog_id => $blog_id,
    name    => 'test content type',
);

my $cf = MT::Test::Permission->make_content_field(
    blog_id            => $ct->blog_id,
    content_type_id    => $ct->id,
    name               => 'categories',
    type               => 'categories',
    related_cat_set_id => $category_set->id,
);

my $fields = [
    {   id      => $cf->id,
        order   => 1,
        type    => $cf->type,
        options => {
            label        => 1,
            category_set => $cf->related_cat_set_id,
        },
        unique_id => $cf->unique_id,
    }
];
$ct->fields($fields);
$ct->save or die $ct->errstr;

my $cd = MT::Test::Permission->make_content_data(
    blog_id         => $ct->blog_id,
    author_id       => 1,
    content_type_id => $ct->id,
    data            => { $cf->id => $category1->id },
);

subtest 'no $opt or $opt = 1' => sub {
    MT::ContentData->remove_all;
    my $terms = {
        author_id       => 1,
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        status          => MT::Entry::RELEASE(),
    };
    my $cd1 = MT::Test::Permission->make_content_data( %{$terms},
        authored_on => '20170602122000' );
    my $cd2 = MT::Test::Permission->make_content_data(
        %{$terms},
        authored_on => '20170603122000',
        status      => MT::Entry::HOLD(),
    );
    my $cd3 = MT::Test::Permission->make_content_data( %{$terms},
        authored_on => '20170604122000' );

    # no $opt
    is( $cd1->next->id,     $cd2->id, '$cd1->next is $cd2' );
    is( $cd2->previous->id, $cd1->id, '$cd2->previous is $cd1' );

    MT::ObjectDriver::Driver::Cache::RAM->clear_cache;

    # $opt = 1
    is( $cd1->next(1)->id,     $cd3->id, '$cd1->next(1) is $cd3' );
    is( $cd3->previous(1)->id, $cd1->id, '$cd3->previous(1) is $cd1' );
};

subtest '$opt = { by_modified_on => 1 }' => sub {
    MT::ContentData->remove_all;
    my $terms = {
        author_id       => 1,
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        status          => MT::Entry::RELEASE(),
    };
    my $cd1 = MT::Test::Permission->make_content_data( %{$terms} );
    my $cd2 = MT::Test::Permission->make_content_data( %{$terms} );

    $cd1->authored_on('20160602122000');
    $cd1->modified_on('20160602122000');
    $cd1->save or die $cd1->errstr;

    $cd2->authored_on('20160601122000');
    $cd2->modified_on('20160603122000');
    $cd2->save or die $cd2->errstr;

    ok( $cd1->next( { by_modified_on => 1 } ),
        '$cd1->next({ by_modified_on => 1 }) exists'
    );
    is( $cd1->next( { by_modified_on => 1 } )->id,
        $cd2->id, '$cd1->next({ by_modified_on => 1 }) is $cd2' );

    ok( $cd2->previous( { by_modified_on => 1 } ),
        '$cd2->previous({ by_modified_on }) exists'
    );
    is( $cd2->previous( { by_modified_on => 1 } )->id,
        $cd1->id, '$cd2->previous({ by_modified_on => 1 }) is $cd1' );
};

subtest '$opt = { by_author => 1 }' => sub {
    MT::ContentData->remove_all;
    my $author2 = MT::Test::Permission->make_author;
    my $terms   = {
        author_id       => 1,
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        status          => MT::Entry::RELEASE(),
    };
    my $cd1 = MT::Test::Permission->make_content_data( %{$terms} );
    my $cd2 = MT::Test::Permission->make_content_data( %{$terms},
        author_id => $author2->id );
    my $cd3 = MT::Test::Permission->make_content_data( %{$terms} );

    is( $cd1->next( { by_author => 1 } )->id,
        $cd3->id, '$cd1->next({ by_author => 1 }) is $cd3' );
    is( $cd3->previous( { by_author => 1 } )->id,
        $cd1->id, '$cd3->previous({ by_author => 1 }) is $cd1' );
};

subtest '$opt = { by_category => 1 }' => sub {
    MT::ContentData->remove_all;
    my $terms = {
        author_id       => 1,
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        status          => MT::Entry::RELEASE(),
    };
    my $cd1 = MT::Test::Permission->make_content_data(
        %{$terms},
        authored_on => '20170602134500',
        data        => { $cf->id => [ $category1->id ] }
    );
    my $cd2 = MT::Test::Permission->make_content_data(
        %{$terms},
        authored_on => '20170603134500',
        data        => { $cf->id => [ $category2->id ] }
    );
    my $cd3 = MT::Test::Permission->make_content_data(
        %{$terms},
        authored_on => '20170604134500',
        data        => { $cf->id => [ $category1->id ] }
    );

    is( $cd1->next( { by_category => 1 } )->id,
        $cd3->id, '$cd1->next is $cd3',
    );
    is( $cd3->previous( { by_category => 1 } )->id,
        $cd1->id, '$cd3->previous is $cd1',
    );

};

subtest '$opt = { by_category => { content_field_id => ??? } }' => sub {
    MT::ContentData->remove_all;
    my $terms = {
        author_id       => 1,
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        status          => MT::Entry::RELEASE(),
    };
    my $cd1 = MT::Test::Permission->make_content_data(
        %{$terms},
        authored_on => '20170602134500',
        data        => { $cf->id => [ $category1->id ] }
    );
    my $cd2 = MT::Test::Permission->make_content_data(
        %{$terms},
        authored_on => '20170603134500',
        data        => { $cf->id => [ $category2->id ] }
    );
    my $cd3 = MT::Test::Permission->make_content_data(
        %{$terms},
        authored_on => '20170604134500',
        data        => { $cf->id => [ $category1->id ] }
    );

    is( $cd1->next( { by_category => { content_field_id => $cf->id } } )->id,
        $cd3->id,
        '$cd1->next is $cd3',
    );
    is( $cd3->previous( { by_category => { content_field_id => $cf->id } } )
            ->id,
        $cd1->id,
        '$cd3->previous is $cd1',
    );
};

subtest
    '$opt = { by_category => { content_field_id => ???, category_id => ??? } }'
    => sub {
    MT::ContentData->remove_all;
    my $terms = {
        author_id       => 1,
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        status          => MT::Entry::RELEASE(),
    };
    my $cd1 = MT::Test::Permission->make_content_data(
        %{$terms},
        authored_on => '20170602134500',
        data        => { $cf->id => [ $category1->id ] }
    );
    my $cd2 = MT::Test::Permission->make_content_data(
        %{$terms},
        authored_on => '20170603134500',
        data        => { $cf->id => [ $category2->id ] }
    );
    my $cd3 = MT::Test::Permission->make_content_data(
        %{$terms},
        authored_on => '20170604134500',
        data        => { $cf->id => [ $category1->id ] }
    );

    ok( !$cd2->next(
            {   by_category => {
                    content_field_id => $cf->id,
                    category_id      => $category2->id
                }
            }
        ),
        'no $cd2->next',
    );
    ok( !$cd2->previous(
            {   by_category => {
                    content_field_id => $cf->id,
                    category_id      => $category2->id
                }
            }
        ),
        'no $cd2->previous',
    );
    };

done_testing;

