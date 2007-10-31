# GoogleSearch plugin for Movable Type
# Author: Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
# $Id$

package AuthorArchive::L10N::ja;

use strict;

use base 'AuthorArchive::L10N';
use vars qw( %Lexicon );

our %Lexicon = (
    'Author #[_1]' => 'ユーザー(#[_1])',
    'AUTHOR_ADV' => 'ユーザー',
    'AUTHOR-YEARLY_ADV' => '年別ユーザー',
    'AUTHOR-MONTHLY_ADV' => '月別ユーザー',
    'AUTHOR-WEEKLY_ADV' => '週別ユーザー',
    'AUTHOR-DAILY_ADV' => '日別ユーザー',
);

1;
