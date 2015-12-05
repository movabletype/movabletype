#!/usr/bin/perl
use strict;
use warnings;

use Test::More;

BEGIN {
    eval 'use Test::Spec; 1'
        or plan skip_all => 'Test::Spec is not installed';
    eval 'use Test::Wight; 1'
        or plan skip_all => 'Wight is not installed';
}

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
    system 'perl -Ilib -Iextlib -It/lib -e "use MT::Test qw( :db :data );"';

    $ENV{MT_CONFIG} = 't/mysql-test.cfg';
}
use lib qw( lib extlib );
use MT;
use MT::PSGI;

my $wight = Test::Wight->new;
$wight->spawn_psgi( MT::PSGI->new->to_app );

describe 'On Edit Image dialog (blog_id = 1, asset_id = 1)' => sub {
    before all => sub {
        $wight->visit(
            '/cgi-bin/mt.cgi?__mode=dialog_edit_image&blog_id=1&id=1&username=Melody&password=Nelson'
        );
    };
    context 'just after opening dialog,' => sub {
        describe 'resize-width textbox' => sub {
            it 'should be 640' => sub {
                is( $wight->find('input#resize-width')->value, 640 );
            };
        };
        describe 'resize-height textbox' => sub {
            it 'should be 480' => sub {
                is( $wight->find('input#resize-height')->value, 480 );
            };
        };
        describe 'resize-apply button' => sub {
            it 'should be disabled' => sub {
                is( $wight->find('button#resize-apply')
                        ->attribute('disabled'),
                    'disabled'
                );
            };
        };
        describe 'resize-reset button' => sub {
            it 'should be disabled' => sub {
                is( $wight->find('button#resize-reset')
                        ->attribute('disabled'),
                    'disabled'
                );
            };
        };
    };
    context 'when resize width is changed to 320,' => sub {
        before all => sub {
            $wight->find('input#resize-width')->set(320);
        };
        describe 'resize-width textbox' => sub {
            it 'should be 320' => sub {
                is( $wight->find('input#resize-width')->value, 320 );
            };
        };
        describe 'resize-height textbox' => sub {
            it 'should be 240' => sub {
                is( $wight->find('input#resize-height')->value, 240 );
            };
        };
        describe 'resize-apply button' => sub {
            it 'should be enabled' => sub {
                ok( !$wight->find('button#resize-apply')
                        ->attribute('disabled') );
            };
        };
        describe 'resize-reset button' => sub {
            it 'should be enabled' => sub {
                ok( !$wight->find('button#resize-reset')
                        ->attribute('disabled') );
            };
        };
    };
    context 'when resize width is changed to 1280,' => sub {
        before all => sub {
            $wight->find('input#resize-width')->set(1280);
        };
        describe 'resize-width textbox' => sub {
            it 'should be 1280' => sub {
                is( $wight->find('input#resize-width')->value, 1280 );
            };
        };
        describe 'resize-height textbox' => sub {
            it 'should be 960' => sub {
                is( $wight->find('input#resize-height')->value, 960 );
            };
        };
        describe 'resize-apply button' => sub {
            it 'should be disabled' => sub {
                is( $wight->find('button#resize-apply')
                        ->attribute('disabled'),
                    'disabled'
                );
            };
        };
        describe 'resize-reset button' => sub {
            it 'should be enabled' => sub {
                ok( !$wight->find('button#resize-reset')
                        ->attribute('disabled') );
            };
        };
    };
};

runtests unless caller;

