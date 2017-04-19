use strict;
use warnings;

use lib qw( extlib lib );

BEGIN {
    use File::Basename qw( dirname );
    use File::Spec;
    my $plugin_home = dirname( dirname( File::Spec->rel2abs(__FILE__) ) );
    push @INC, "$plugin_home/lib", "$plugin_home/extlib";
}

use Test::More;
use MT;

use_ok('ContentType::App::CMS');
use_ok('ContentType::Feed');
use_ok('ContentType::ListProperties');
use_ok('ContentType::Permission');
use_ok('ContentType::Tags');

use_ok('MT::ContentData');
use_ok('MT::ContentField');
use_ok('MT::ContentFieldIndex');
use_ok('MT::ContentFieldType::Asset');
use_ok('MT::ContentFieldType::Category');
use_ok('MT::ContentFieldType::Checkbox');
use_ok('MT::ContentFieldType::ContentType');
use_ok('MT::ContentFieldType::Date');
use_ok('MT::ContentFieldType::DateTime');
use_ok('MT::ContentFieldType::Radio');
use_ok('MT::ContentFieldType::SelectBox');
use_ok('MT::ContentFieldType::Tag');
use_ok('MT::ContentFieldType::Time');
use_ok('MT::ContentFieldType::URL');
use_ok('MT::ContentType::UniqueKey');
use_ok('MT::ContentType');
use_ok('MT::ObjectCategory');

done_testing;
