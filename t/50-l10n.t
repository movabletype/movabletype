use strict;
use warnings;

use Test::More;

use lib qw( lib extlib t/lib );
use MT;
use MT::L10N;

MT->instance;

subtest 'default $MT::L10N::ENABLED_METHODS_REGEX' => sub {
    my $regex = $MT::L10N::ENABLED_METHODS_REGEX;

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

subtest 'Disabled methods' => sub {
    eval { MT->translate('[fail_with,failure_handler_auto]') };
    ok( $@, 'fail_with' );

    require MT::L10N;
    ok( MT::L10N->can('fail_with'), 'fail_with method exists' );

    eval { MT->translate('[non_existent_method,100]'); };
    ok( $@, 'non_existent_method' );
};

subtest 'Escaped by tilde' => sub {
    my $quant = MT->translate('~[quant,1,file~]');
    is( $quant, '[quant,1,file]', 'quant' );

    my $non_existent_method = MT->translate('~[non_existent_method,100~]');
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

done_testing;
