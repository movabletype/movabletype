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

# Fix the bug that website is not backed up.
# https://movabletype.fogbugz.com/f/cases/113358/

use MT::Test qw( :app :db :data );
use MT::BackupRestore;

note 'System, all';
{
    my @blog_ids = ();
    my $obj_to_backup
        = MT::BackupRestore->_populate_obj_to_backup( \@blog_ids );
    my $website_class
        = ( grep { exists $_->{'MT::Website'} } @$obj_to_backup ) ? 1 : 0;
    ok( $website_class, 'Website will be backed up.' );
}

note 'Website';
{
    my @blog_ids = ( 1, 2 );
    my $obj_to_backup
        = MT::BackupRestore->_populate_obj_to_backup( \@blog_ids );
    my $website_class
        = ( grep { exists $_->{'MT::Website'} } @$obj_to_backup ) ? 1 : 0;
    ok( $website_class, 'Website will be backed up.' );
}

note 'Blog';
{
    my @blog_ids = (1);
    my $obj_to_backup
        = MT::BackupRestore->_populate_obj_to_backup( \@blog_ids );
    my $website_class
        = ( grep { exists $_->{'MT::Website'} } @$obj_to_backup ) ? 1 : 0;
    ok( !$website_class, 'Website will not be backed up.' );
}

done_testing;
