use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',      ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::App;
use MT::Test::Fixture;

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;
        MT::Test::Fixture->prepare(
            {   author       => [qw/author/],
                website      => [ { name => 'My Site' } ],
                content_type => {
                    ct_select => [
                        cf_select => {
                            type   => 'select_box',
                            values => [
                                {   label   => 'select1',
                                    value   => 'value1',
                                    checked => 'checked'
                                },
                                { label => 'select2', value => 'value2' },
                                { label => 'select3', value => 'value3' },
                                { label => 'select0', value => '0' },
                            ]
                        },
                    ],
                    ct_radio => [
                        cf_radio => {
                            type   => 'radio_button',
                            values => [
                                {   label   => 'radio1',
                                    value   => 'value1',
                                    checked => 'checked'
                                },
                                { label => 'radio2', value => 'value2' },
                                { label => 'radio3', value => 'value3' },
                                { label => 'radio0', value => '0' },
                            ],
                        },
                    ],
                    ct_check => [
                        cf_check => {
                            type   => 'checkboxes',
                            values => [
                                {   label   => 'check1',
                                    value   => 'value1',
                                    checked => 'checked'
                                },
                                { label => 'check2', value => 'value2' },
                                { label => 'check3', value => 'value3' },
                                { label => 'check0', value => '0' },
                            ],
                        },
                    ],
                },
            }
        );
    }
);

my $admin   = MT::Author->load(1);
my $blog_id = MT::Website->load( { name => 'My Site' } )->id;

subtest 'Select' => sub {
    my $app = MT::Test::App->new;
    $app->login($admin);

    my $ct_id = MT::ContentType->load( { name => 'ct_select' } )->id;
    my $cf_id = "content-field-$ct_id";

    $app->get_ok(
        {   __mode          => 'view',
            _type           => 'content_data',
            content_type_id => $ct_id,
            blog_id         => $blog_id,
        }
    );
    my @selected;
    note $app->wq_find("select[name='$cf_id']")->as_html;
    $app->wq_find("select[name='$cf_id'] option")->each(
        sub {
            my ( $i, $elem ) = @_;
            push @selected, $elem if $elem->attr('selected');
        }
    );

    is @selected                   => 1,        "selected one option";
    is $selected[0]->attr('value') => 'value1', "and the option has value1";

    $app->post_form_ok(
        {   data_label => 'cd_select',
            $cf_id     => 'value2',
        }
    );
    like $app->message_text => qr/ct_select has been saved/, "saved";

    @selected = ();
    note $app->wq_find("select[name='$cf_id']")->as_html;
    $app->wq_find("select[name='$cf_id'] option")->each(
        sub {
            my ( $i, $elem ) = @_;
            push @selected, $elem if $elem->attr('selected');
        }
    );
    is @selected                   => 1,        "selected one option";
    is $selected[0]->attr('value') => 'value2', "and the option has value2";
};

subtest 'Radio' => sub {
    my $app = MT::Test::App->new;
    $app->login($admin);

    my $ct_id = MT::ContentType->load( { name => 'ct_radio' } )->id;
    my $cf_id = "content-field-$ct_id";

    $app->get_ok(
        {   __mode          => 'view',
            _type           => 'content_data',
            content_type_id => $ct_id,
            blog_id         => $blog_id,
        }
    );
    my @checked;
    note $app->wq_find("input[name='$cf_id']")->as_html;
    $app->wq_find("input[name='$cf_id']")->each(
        sub {
            my ( $i, $elem ) = @_;
            push @checked, $elem if $elem->attr('checked');
        }
    );

    is @checked                   => 1,        "checked one button";
    is $checked[0]->attr('value') => 'value1', "and value1 is checked";

    $app->post_form_ok(
        {   data_label => 'cd_radio',
            $cf_id     => 'value2',
        }
    );
    like $app->message_text => qr/ct_radio has been saved/, "saved";

    @checked = ();
    note $app->wq_find("input[name='$cf_id']")->as_html;
    $app->wq_find("input[name='$cf_id']")->each(
        sub {
            my ( $i, $elem ) = @_;
            push @checked, $elem if $elem->attr('checked');
        }
    );
    is @checked                   => 1,        "checked one button";
    is $checked[0]->attr('value') => 'value2', "and value2 is checked";
};

subtest 'Checkbox' => sub {
    my $app = MT::Test::App->new;
    $app->login($admin);

    my $ct_id = MT::ContentType->load( { name => 'ct_check' } )->id;
    my $cf_id = "content-field-$ct_id";

    $app->get_ok(
        {   __mode          => 'view',
            _type           => 'content_data',
            content_type_id => $ct_id,
            blog_id         => $blog_id,
        }
    );
    my @checked;
    note $app->wq_find("input[name='$cf_id']")->as_html;
    $app->wq_find("input[name='$cf_id']")->each(
        sub {
            my ( $i, $elem ) = @_;
            push @checked, $elem if $elem->attr('checked');
        }
    );

    is @checked                   => 1,        "checked one box";
    is $checked[0]->attr('value') => 'value1', "and the box has value1";

    $app->post_form_ok(
        {   data_label => 'cd_check',
            $cf_id     => 'value2',
        }
    );
    like $app->message_text => qr/ct_check has been saved/, "saved";

    @checked = ();
    note $app->wq_find("input[name='$cf_id']")->as_html;
    $app->wq_find("input[name='$cf_id']")->each(
        sub {
            my ( $i, $elem ) = @_;
            push @checked, $elem if $elem->attr('checked');
        }
    );
    is @checked                   => 1,        "checked one box";
    is $checked[0]->attr('value') => 'value2', "and the box has value2";

    ## Uncheck everything
    $app->post_form_ok(
        {   data_label => 'cd_check',
            $cf_id     => [],
        }
    );
    like $app->message_text => qr/Your changes have been saved/, "saved";

    @checked = ();
    note $app->wq_find("input[name='$cf_id']")->as_html;
    $app->wq_find("input[name='$cf_id']")->each(
        sub {
            my ( $i, $elem ) = @_;
            push @checked, $elem if $elem->attr('checked');
        }
    );
    is @checked => 0, "checked no box";
};

done_testing();
