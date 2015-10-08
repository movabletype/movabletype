#!/usr/bin/perl
use strict;
use warnings;

# Fix the bug that website is not backed up.
# https://movabletype.fogbugz.com/f/cases/113358/

use Test::More;

use lib qw( lib extlib t/lib );
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
