#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test qw( :app :db );
use MT::Test::Permission;
use MT;

my $mt = MT->instance;

subtest 'FormattedText::FormattedText::validate' => sub {
    my @suite = (
        {   values => {
                label       => 'Label',
                text        => 'Text',
                description => 'Description',
            },
            is_valid => 1,
        },
        {   values => {
                text        => 'Text',
                description => 'Description',
            },
            is_valid => undef,
        },
        {   values => {
                label       => 'Label',
                description => 'Description',
            },
            is_valid => 1,
        },
        {   values => {
                label => 'Label',
                text  => 'Text',
            },
            is_valid => 1,
        },
    );

    require FormattedText::FormattedText;
    foreach my $data (@suite) {
        my $handler = MT::ErrorHandler->new;
        my $status  = FormattedText::FormattedText::validate( $handler,
            $data->{values} );
        is( $status, $data->{is_valid},
                  ( $data->{is_valid} ? 'Valid params' : 'Invalid params' )
                . ': keys: '
                . join( ',', keys( %{ $data->{values} } ) ) );
    }
};

subtest 'Remove parent blog' => sub {
    my $blog = MT->model('blog')->new;
    $blog->set_values( { name => 'Test', } );
    $blog->save or die $blog->errstr;

    my $formatted_text = MT->model('formatted_text')->new;
    $formatted_text->set_values( { blog_id => $blog->id, } );
    $formatted_text->save or die $formatted_text->errstr;

    $blog->remove;

    $formatted_text
        = MT->model('formatted_text')->load( $formatted_text->id );

    ok( !$formatted_text, 'A formatted text is removed with parent blog' );

    done_testing;
};

done_testing;
