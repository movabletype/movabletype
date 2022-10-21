#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;

BEGIN {
    eval 'use Test::Spec; 1'
        or plan skip_all => 'Test::Spec is not installed';
    eval 'use Imager; 1'
        or plan skip_all => 'Imager is not installed';
    plan skip_all => 'Not for Windows now' if $^O eq 'MSWin32';
}

our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(

        # to serve actual js libraries
        StaticFilePath => "MT_HOME/mt-static/",

        # ImageMagick 6.90 hangs when it tries to scale
        # the same image again (after the initialization).
        # Version 7.07 works fine. Other three drivers do, too.
        # Because Image::Magick hides its $VERSION in an
        # internal package (Image::Magick::Q16 etc), it's
        # more reliable to depend on something else.
        ImageDriver => 'Imager',
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT;
use MT::Test::Selenium;
use Selenium::Waiter;

$test_env->prepare_fixture('db_data');

my $author = MT->model('author')->load(1) or die MT->model('author')->errstr;
$author->set_password('Nelson');
$author->save or die $author->errstr;

describe 'On Pref Blog Screen (blog_id = 1)' => sub {
    my $selenium = MT::Test::Selenium->new($test_env, { rebootable => 1 });
    context 'not save archive path' => sub {
        before all => sub {
            my $blog = MT->model('blog')->load(1) or die MT->model('blog')->errstr;
            $blog->archive_path('');
            $blog->archive_url('');
            $blog->save or die $blog->errstr;
            $selenium->visit(
                '/cgi-bin/mt.cgi?__mode=cfg_prefs&_type=website&blog_id=1&id=1&username=Melody&password=Nelson'
            );
        };
        describe 'select archive path' => sub {
            it 'option is hidden' => sub {
                $selenium->find('#enable_archive_paths');
                if (my $elem = $selenium->element) {
                    my $selected = $elem->is_selected;
                    ok !$selected, "checkbox is not selected yet";
                }
                $selenium->find('select#upload_destination');
                if (my $elem = $selenium->element) {
                    my $child = $elem->children("option");
                    foreach my $c(@$child){
                        my $text = $c->get_text;
                        if( $c->get_attribute('data-archive') ){
                            is( $c->get_attribute('hidden'), 'true', "option $text is hidden" );
                        }
                    }
                } else {
                    fail "select#upload_destination is not found";
                    note $selenium->content;
                }
            };
        };
        describe 'archive path click' => sub {
            it 'option is shown' => sub {
                $selenium->find('#enable_archive_paths');
                if (my $elem = $selenium->element) {
                    my $selected = $elem->is_selected;
                    ok !$selected, "checkbox is not selected yet";
                }
                $selenium->find('label[for=enable_archive_paths]');
                if (my $elem = $selenium->element) {
                    $elem->toggle;
                    wait_until { $selenium->find('#enable_archive_paths')->element->is_selected };
                }
                $selenium->find('select#upload_destination');
                if (my $elem = $selenium->element) {
                    my $child = $elem->children("option");
                    foreach my $c(@$child){
                        my $text = $c->get_text;
                        if( $c->get_attribute('data-archive') ){
                            is( $c->get_attribute('hidden'), undef, "option $text is not hidden now" );
                        }
                    }
                } else {
                    fail "select#upload_destination is not found";
                    note $selenium->content;
                }
            };

        }
    };
    context 'save archive path' => sub {
        before all => sub {
            my $blog = MT->model('blog')->load(1) or die MT->model('blog')->errstr;
            $blog->archive_path('/tmp/mt/site/archives');
            $blog->save or die $blog->errstr;
            $selenium->visit(
                '/cgi-bin/mt.cgi?__mode=cfg_prefs&_type=website&blog_id=1&id=1&username=Melody&password=Nelson'
            );
        };
        describe 'select archive path' => sub {
            it 'option is shown' => sub {
                $selenium->find('#enable_archive_paths');
                if (my $elem = $selenium->element) {
                    my $selected = $elem->is_selected;
                    ok $selected, "checkbox is selected now";
                }
                $selenium->find('select#upload_destination');
                if (my $elem = $selenium->element) {
                    my $child = $elem->children("option");
                    foreach my $c(@$child){
                        my $text = $c->get_text;
                        if( $c->get_attribute('data-archive') ){
                            is( $c->get_attribute('hidden'), undef, "option $text is not hidden yet" );
                        }
                    }
                } else {
                    fail "select#upload_destination is not found";
                    note $selenium->content;
                }
            };
        };
        describe 'archive path click' => sub {
            it 'option is shown' => sub {
                $selenium->find('#enable_archive_paths');
                if (my $elem = $selenium->element) {
                    my $selected = $elem->is_selected;
                    ok $selected, "checkbox is still selected";
                }
                $selenium->find('label[for=enable_archive_paths]');
                if (my $elem = $selenium->element) {
                    $elem->toggle;
                    wait_until { !$selenium->find('#enable_archive_paths')->element->is_selected };
                }
                $selenium->find('select#upload_destination');
                if (my $elem = $selenium->element) {
                    my $child = $elem->children("option");
                    foreach my $c(@$child){
                        my $text = $c->get_text;
                        if( $c->get_attribute('data-archive') ){
                            is( $c->get_attribute('hidden'), 'true', "option $text is hidden now" );
                        }
                    }
                } else {
                    fail "select#upload_destination is not found";
                    note $selenium->content;
                }
            };
        }
    };
};

runtests unless caller;
