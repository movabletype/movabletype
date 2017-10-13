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


use Test::More;

use lib qw( lib extlib t/lib );
use MT::Test;
use MT;
use MT::L10N;

MT->instance;

subtest 'MT::L10N' => sub {
    subtest 'parent class' => sub {
        is_deeply( \@MT::L10N::ISA, [qw/ Locale::Maketext /],
            'Locale::Maketext' );
    };

    subtest '$PERMITTED_METHODS_REGEX' => sub {
        my $regex = $MT::L10N::PERMITTED_METHODS_REGEX;

        like( 'lc',       $regex, 'lc' );
        like( 'uc',       $regex, 'uc' );
        like( 'quant',    $regex, 'quant' );
        like( 'numerate', $regex, 'numerate' );
        like( 'numf',     $regex, 'numf' );
        like( 'sprintf',  $regex, 'sprintf' );

        unlike( 'fail_with', $regex, 'fail_with' );

        unlike( 'lcc',        $regex, 'lcc' );
        unlike( 'uucc',       $regex, 'uucc' );
        unlike( 'qquantt',    $regex, 'qquantt' );
        unlike( 'nnumeratee', $regex, 'nnumeratee' );
        unlike( 'nnumff',     $regex, 'nnumff' );
        unlike( 'ssprintff',  $regex, 'ssprintff' );
    };

    subtest 'language_name' => sub {
        my $lh_ja = MT::L10N->get_handle('ja');
        is( $lh_ja->language_name, 'Japanese', 'Japanese' );

        my $lh_en_us = MT::L10N->get_handle('en-us');
        is( $lh_en_us->language_name, 'US English', 'US English' );
    };

    subtest 'encoding' => sub {
        is( MT::L10N->encoding, 'iso-8859-1', 'iso-8859-1' );
    };

    subtest 'ascii_only' => sub {
        is( MT::L10N->ascii_only, 0, 'zero' );
    };

    subtest 'lc' => sub {
        is( MT::L10N->lc('ABC'), 'abc', 'abc' );
    };

    subtest 'uc' => sub {
        is( MT::L10N->uc('def'), 'DEF', 'DEF' );
    };

    subtest '_compile' => sub {
        my $lh = MT::L10N->get_handle;

        subtest 'permitted' => sub {
            eval { $lh->_compile('[lc]') };
            ok( !$@, '[lc]' );
            eval { $lh->_compile('[uc]') };
            ok( !$@, '[uc]' );
            eval { $lh->_compile('[quant]') };
            ok( !$@, '[quant]' );
            eval { $lh->_compile('[numf]') };
            ok( !$@, '[numf]' );
            eval { $lh->_compile('[numerate]') };
            ok( !$@, '[numerate]' );
            eval { $lh->_compile('[sprintf]') };
            ok( !$@, '[sprintf]' );

            eval { $lh->_compile('[quant,1,file]') };
            ok( !$@, '[quant,1,file]' );
            eval { $lh->_compile('[numf,1000000]') };
            ok( !$@, '[numf,1000000]' );
            eval { $lh->_compile('[numerate,2,file,files]') };
            ok( !$@, '[numerate,2,file,files]' );
            eval { $lh->_compile('[sprintf,%.2f,1]') };
            ok( !$@, '[sprintf,%.2f,1]' );
            eval { $lh->_compile('[lc,ABC]') };
            ok( !$@, '[lc,ABC]' );
            eval { $lh->_compile('[uc,def]') };
            ok( !$@, '[uc,def]' );

            eval { $lh->_compile('[_1]') };
            ok( !$@, '[_1]' );
            eval { $lh->_compile('[_0]') };
            ok( !$@, '[_0]' );
            eval { $lh->_compile('[_-1]') };
            ok( !$@, '[_1]' );

            eval { $lh->_compile('~[quant,1,file~]') };
            ok( !$@, '~[quant,1,file~]' );
            eval { $lh->_compile('~[non_existent_method,100~]') };
            ok( !$@, '~[non_existent_method,100~]' );
            eval { $lh->_compile('~[fail_with,failure_handler_auto~]') };
            ok( !$@, '~[fail_with,failure_handler_auto~]' );
            eval { $lh->_compile('~~~[fail_with,failure_handler_auto~]') };
            ok( !$@, '~~~[fail_with,failure_handler_auto~]' );
        };

        subtest 'not permitted' => sub {
            eval { $lh->_compile('[lcc]') };
            ok( $@, '[lcc]' );
            eval { $lh->_compile('[uucc]') };
            ok( $@, '[uucc]' );
            eval { $lh->_compile('[qquantt]') };
            ok( $@, '[qquantt]' );
            eval { $lh->_compile('[nnumeratee]') };
            ok( $@, '[nnumeratee]' );
            eval { $lh->_compile('[nnumff]') };
            ok( $@, '[nnumff]' );
            eval { $lh->_compile('[ssprintff]') };
            ok( $@, '[ssprintff]' );

            eval { $lh->_compile('[fail_with]') };
            ok( $@, '[fail_with]' );
            eval { $lh->_compile('[fail_with,failure_handler_auto]') };
            ok( $@, '[fail_with,failure_handler_auto]' );
            eval { $lh->_compile('[non_existent_method,100]') };
            ok( $@, '[non_existent_method,100]' );
            eval { $lh->_compile('~~[fail_with,failure_handler_auto]') };
            ok( $@, '~~[fail_with,failure_handler_auto]' );
            eval { $lh->_compile('~~~~[fail_with,failure_handler_auto]') };
            ok( $@, '~~~~[fail_with,failure_handler_auto]' );
        };
    };
};

subtest 'MT::translate' => sub {
    subtest 'Enabled methods of Locale::Maketext in bracket' => sub {
        my $quant = MT->translate('[quant,1,file]');
        is( $quant, '1 file', 'quant' );

        my $numf = MT->translate('[numf,1000000]');
        is( $numf, '1,000,000', 'numf' );

        my $numerate = MT->translate('[numerate,2,file,files]');
        is( $numerate, 'files', 'numerate' );

        my $sprintf = MT->translate('[sprintf,%.2f,1]');
        is( $sprintf, '1.00', 'sprintf' );
    };

    subtest 'Enabled methods of MT::L10N in bracket' => sub {
        my $lc = MT->translate('[lc,ABC]');
        is( $lc, 'abc', 'lc' );

        my $uc = MT->translate('[uc,def]');
        is( $uc, 'DEF', 'uc' );
    };

    subtest 'number in bracket' => sub {
        my $positive = MT->translate( '[_1]', 'positive' );
        is( $positive, 'positive', '[_1]' );

        my $negative = MT->translate( '[_-1]', 'negative', 'integer' );
        is( $negative, 'integer', '[_-1]' );

        my $zero = MT->translate( '[_0]', 'zero' );
        ok( eval { $zero->isa('MT::L10N') }, '[_0]' );
    };

    subtest 'Disabled methods' => sub {
        ok( MT::L10N->can('fail_with'), 'fail_with method exists' );

        eval { MT->translate('[fail_with,failure_handler_auto]') };
        ok( $@, 'fail_with' );

        eval { MT->translate('[fail_with]') };
        ok( $@, 'fail_with w/o paramters' );

        ok( !MT::L10N->can('non_existent_method'),
            'non_existent_method method does not exist'
        );
        eval { MT->translate('[non_existent_method,100]'); };
        ok( $@, 'non_existent_method' );
    };

    subtest 'Escaped by tilde' => sub {
        my $quant = MT->translate('~[quant,1,file~]');
        is( $quant, '[quant,1,file]', 'quant' );

        my $non_existent_method
            = MT->translate('~[non_existent_method,100~]');
        is( $non_existent_method, '[non_existent_method,100]',
            'non_existent_method' );

        my $fail_with = MT->translate('~[fail_with,failure_handler_auto~]');
        is( $fail_with, '[fail_with,failure_handler_auto]', 'fail_with' );

        eval { MT->translate('~~[fail_with,failure_handler_auto]') };
        ok( $@, 'fail_with with 2 tildes' );

        my $fail_with_3_tildes
            = MT->translate('~~~[fail_with,failure_handler_auto~]');
        is( $fail_with_3_tildes,
            '~[fail_with,failure_handler_auto]',
            'fail_with with 3 tildes'
        );

        eval { MT->translate('~~~~[fail_with,failure_handler_auto]') };
        ok( $@, 'fail_with with 4 tildes' );
    };
};

done_testing;
