package LanguageXX;
use strict;
use warnings;
use utf8;
use MT::Util;

sub cb_init_app {
    $MT::Util::Languages{zz} = [
        ['にちようび', 'げつようび', 'かようび', 'すいようび', 'もくようび', 'きんようび', 'どようび'],
        ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
        ['ごぜん', 'ごご'],
        '%Yねん%bがつ%eにち %H:%M',
        '%Yねん%bがつ%eにち',
        '%H:%M',
        '%Yねん%bがつ',
        '%bがつ%eにち'
    ];
}

1;
