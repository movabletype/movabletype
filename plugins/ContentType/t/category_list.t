use strict;
use warnings;

use Test::More;

use lib qw( lib extlib t/lib );
use MT;
use MT::Test qw( :app :db );

use MT::Category;
use MT::CategoryList;

my $blog_id = 1;

my $cat_list = MT::CategoryList->new;
$cat_list->set_values(
    {   blog_id => 1,
        name    => 'test category list',
    }
);
$cat_list->save or die $cat_list->errstr;

MT::

done_testing;

