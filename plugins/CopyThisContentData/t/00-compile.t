use strict;
use warnings;

use lib './lib', './extlib', './plugins/CopyThisContentData/lib';
use Test::More;

use_ok('CopyThisContentData::Callback');
use_ok('CopyThisContentData::CMS');
use_ok('CopyThisContentData::Transformer');

use_ok('CopyThisContentData::L10N');
use_ok('CopyThisContentData::L10N::ja');

done_testing;

