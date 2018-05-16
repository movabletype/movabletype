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

use MT::Test;
use MT::Util;

MT::Test->init_app;

$test_env->prepare_fixture('db_data');

my $user = MT->model('author')->load(1);
my $blog = MT->model('blog')->load(1);

for my $type (qw/ category folder /) {
    my $order_field = "${type}_order";

    subtest $type => sub {

        # Update order.
        {
            my @category
                = MT->model($type)
                ->load( { blog_id => $blog->id }, { sort => 'id' } );
            my $new_order = join ',', ( map { $_->id } @category );
            $blog->$order_field($new_order);
            $blog->save or die $blog->errstr;
        }

        subtest 'No parent' => sub {
            my $order = $blog->$order_field;

            my $app = _run_app(
                'MT::App::CMS',
                {   __test_user => $user,
                    __mode      => 'js_add_category',
                    _type       => $type,
                    blog_id     => $blog->id,
                    parent      => -1,
                    label       => $type,
                }
            );
            my $out = delete $app->{__test_output};

            my $result = _from_json($out);
            ok( exists $result->{error} && !$result->{error}, 'No error' );

            _clear_cache();

            my $category_id = $result->{result}{id};
            $blog = MT->model('blog')->load(1);
            is( $blog->$order_field, "${category_id},${order}",
                'Order has been updated.' );
        };

        subtest 'Has parent' => sub {
            my $order = $blog->$order_field;
            my $parent = MT->model($type)->load( { blog_id => $blog->id },
                { sort => 'id', direction => 'descend' } );

            my $app = _run_app(
                'MT::App::CMS',
                {   __test_user => $user,
                    __mode      => 'js_add_category',
                    _type       => $type,
                    blog_id     => $blog->id,
                    parent      => $parent->id,
                    label       => $type,
                }
            );
            my $out = delete $app->{__test_output};

            my $result = _from_json($out);
            ok( exists $result->{error} && !$result->{error}, 'No error' );

            _clear_cache();

            my $category_id = $result->{result}{id};
            $blog = MT->model('blog')->load(1);

            my @order = split ',', $order;
            @order
                = map { $_ == $parent->id ? ( $_, $category_id ) : $_ }
                @order;
            my $new_order = join ',', @order;
            is( $blog->$order_field, $new_order, 'Order has been updated.' );
        };

    };
}

done_testing;

sub _from_json {
    my $out = shift;
    $out =~ s/\A(?:[^\{]*)(\{.*\})(?:[^\{\}]*)\z/$1/m;
    eval { MT::Util::from_json($out) };
}

sub _clear_cache {
    eval {
        require MT::ObjectDriver::Driver::Cache::RAM;
        MT::ObjectDriver::Driver::Cache::RAM->Disabled(1);
    };
}
