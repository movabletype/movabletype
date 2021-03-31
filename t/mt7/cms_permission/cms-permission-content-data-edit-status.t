#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;

use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::App;
use MT::Test::Permission;

### Make test data
$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        # Sites
        my $site = MT::Test::Permission->make_website( name => 'my website' );
        my $site2 = MT::Test::Permission->make_website(
            name => 'my second website' );

        # Users
        my $create_user = MT::Test::Permission->make_author(
            name     => 'aikawa',
            nickname => 'Ichiro Aikawa',
        );

        my $edit_user = MT::Test::Permission->make_author(
            name     => 'ichikawa',
            nickname => 'Jiro Ichikawa',
        );

        my $manage_user = MT::Test::Permission->make_author(
            name     => 'ukawa',
            nickname => 'Saburo Ukawa',
        );
    }
);

### Loading test data
my $site  = MT::Website->load( { name => 'my website' } );
my $site2 = MT::Website->load( { name => 'my second website' } );

my $create_user = MT::Author->load( { name => 'aikawa' } );
my $edit_user   = MT::Author->load( { name => 'ichikawa' } );
my $manage_user = MT::Author->load( { name => 'ukawa' } );

### Make test data
# Content Type & Content Field & Content Data

my $content_type = MT::Test::Permission->make_content_type(
    blog_id => $site->id,
    name    => 'test content type',
);

my $content_field = MT::Test::Permission->make_content_field(
    blog_id         => $content_type->blog_id,
    content_type_id => $content_type->id,
    name            => 'single line text',
    type            => 'single_line_text',
);

my $field_data = [
    {   id        => $content_field->id,
        order     => 1,
        type      => $content_field->type,
        options   => { label => $content_field->name, },
        unique_id => $content_field->unique_id,
    },
];
$content_type->fields($field_data);
$content_type->save or die $content_type->errstr;

my $cd = MT::Test::Permission->make_content_data(
    blog_id         => $site->id,
    author_id       => $create_user->id,
    content_type_id => $content_type->id,
    data            => { $content_field->id => 'test text' },
);

# Permissions
my $field_priv
    = 'content_type:'
    . $content_type->unique_id
    . '-content_field:'
    . $content_field->unique_id;

my $create_priv = 'create_content_data:' . $content_type->unique_id;
my $create_role = MT::Test::Permission->make_role(
    name        => 'create_content_data ' . $content_field->name,
    permissions => "'${create_priv}','${field_priv}'",
);

my $publish_priv = 'publish_content_data:' . $content_type->unique_id;
my $publish_role = MT::Test::Permission->make_role(
    name        => 'publish_content_data ' . $content_field->name,
    permissions => "'${publish_priv}','${create_priv}','${field_priv}'",
);

my $edit_priv = 'edit_all_content_data:' . $content_type->unique_id;
my $edit_role = MT::Test::Permission->make_role(
    name        => 'edit_all_content_data ' . $content_field->name,
    permissions => "'${edit_priv}','${field_priv}'",
);

my $manage_priv = 'manage_content_data:' . $content_type->unique_id;
my $manage_role = MT::Test::Permission->make_role(
    name => 'manage_content_data ' . $content_field->name,
    permissions =>
        "'${manage_priv}','${create_priv}','${publish_priv}','${edit_priv}','${field_priv}'",
);

print $manage_user->permissions->permissions . "\n";
require MT::Association;
MT::Association->link( $create_user => $create_role => $site );
MT::Association->link( $edit_user   => $edit_role   => $site );
MT::Association->link( $manage_user => $manage_role => $site );

my $admin = MT::Author->load(1);

### Run
my ( $app, $out );

subtest 'mode = view (new)' => sub {
    my $app = MT::Test::App->new;
    my @selected;
    my %options;

    # Admin
    $app->login($admin);
    $app->get_ok(
        {   __mode          => 'view',
            blog_id         => $site->id,
            content_type_id => $content_type->id,
            _type           => 'content_data',
            type            => 'content_data_' . $content_type->id,
        }
    );

    note $app->wq_find("select[name='status']")->as_html;
    $app->wq_find("select[name='status'] option")->each(
        sub {
            my ( $i, $elem ) = @_;
            push @selected, $elem if $elem->attr('selected');
            $options{ $elem->attr('value') } = 1;
        }
    );
    is @selected                   => 1,   "selected one option";
    is $selected[0]->attr('value') => '2', "and the option has value 2";
    is $options{1}                 => 1,   "existed option value 1";
    is $options{2}                 => 1,   "existed option value 2";
    is $options{4}                 => 1,   "existed option value 4";

    # Create user
    $app->login($create_user);
    $app->get_ok(
        {   __mode          => 'view',
            blog_id         => $site->id,
            content_type_id => $content_type->id,
            _type           => 'content_data',
            type            => 'content_data_' . $content_type->id,
        }
    );

    note $app->wq_find("input[name='status']")->as_html;
    my $elem = $app->wq_find("input[name='status']");
    is $elem->attr('value') => 1, "existed hidden input value 1";

    # Manage user
    $app->login($manage_user);
    $app->get_ok(
        {   __mode          => 'view',
            blog_id         => $site->id,
            content_type_id => $content_type->id,
            _type           => 'content_data',
            type            => 'content_data_' . $content_type->id,
        },
    );

    note $app->wq_find("select[name='status']")->as_html;
    @selected = ();
    $app->wq_find("select[name='status'] option")->each(
        sub {
            my ( $i, $elem ) = @_;
            push @selected, $elem if $elem->attr('selected');
            $options{ $elem->attr('value') } = 1;
        }
    );
    is @selected                   => 1,   "selected one option";
    is $selected[0]->attr('value') => '2', "and the option has value 2";
    is $options{1}                 => 1,   "existed option value 1";
    is $options{2}                 => 1,   "existed option value 2";
    is $options{4}                 => 1,   "existed option value 4";
};

subtest 'mode = view (edit)' => sub {
    my $app = MT::Test::App->new;
    my @selected;
    my %options;

    # Admin
    my $cd_admin = MT::Test::Permission->make_content_data(
        blog_id         => $site->id,
        author_id       => $admin->id,
        content_type_id => $content_type->id,
        data            => { $content_field->id => 'test text' },
    );
    $app->login($admin);
    $app->get_ok(
        {   __mode          => 'view',
            blog_id         => $site->id,
            content_type_id => $content_type->id,
            _type           => 'content_data',
            type            => 'content_data_' . $content_type->id,
            id              => $cd_admin->id,
        }
    );

    note $app->wq_find("select[name='status']")->as_html;
    $app->wq_find("select[name='status'] option")->each(
        sub {
            my ( $i, $elem ) = @_;
            push @selected, $elem if $elem->attr('selected');
            $options{ $elem->attr('value') } = 1;
        }
    );
    is @selected                   => 1,   "selected one option";
    is $selected[0]->attr('value') => '2', "and the option has value 2";
    is $options{1}                 => 1,   "existed option value 1";
    is $options{2}                 => 1,   "existed option value 2";

    # Create user
    my $cd_cuser = MT::Test::Permission->make_content_data(
        blog_id         => $site->id,
        author_id       => $create_user->id,
        content_type_id => $content_type->id,
        data            => { $content_field->id => 'test text' },
    );
    $cd_cuser->status( MT::ContentStatus::HOLD() );
    $cd_cuser->save();
    $app->login($create_user);
    $app->get_ok(
        {   __mode          => 'view',
            blog_id         => $site->id,
            content_type_id => $content_type->id,
            _type           => 'content_data',
            type            => 'content_data_' . $content_type->id,
            id              => $cd_cuser->id,
        },
    );

    note $app->wq_find("input[name='status']")->as_html;
    my $elem = $app->wq_find("input[name='status']");
    is $elem->attr('value') => 1, "existed hidden input value 1";

    # Edit user - Other's draft data
    $app->login($edit_user);
    $app->get_ok(
        {   __mode          => 'view',
            blog_id         => $site->id,
            content_type_id => $content_type->id,
            _type           => 'content_data',
            type            => 'content_data_' . $content_type->id,
            id              => $cd_cuser->id,
        },
    );

    note $app->wq_find("select[name='status']")->as_html;
    @selected = ();
    $app->wq_find("select[name='status'] option")->each(
        sub {
            my ( $i, $elem ) = @_;
            push @selected, $elem if $elem->attr('selected');
            $options{ $elem->attr('value') } = 1;
        }
    );
    is @selected                   => 1,   "selected one option";
    is $selected[0]->attr('value') => '1', "and the option has value 1";
    is $options{1}                 => 1,   "existed option value 1";
    is $options{2}                 => 1,   "existed option value 2";
    is $options{4}                 => 1,   "existed option value 4";

    # Edit user - Other's published data
    $app->get_ok(
        {   __mode          => 'view',
            blog_id         => $site->id,
            content_type_id => $content_type->id,
            _type           => 'content_data',
            type            => 'content_data_' . $content_type->id,
            id              => $cd->id,
        },
    );

    note $app->wq_find("select[name='status']")->as_html;
    @selected = ();
    $app->wq_find("select[name='status'] option")->each(
        sub {
            my ( $i, $elem ) = @_;
            push @selected, $elem if $elem->attr('selected');
            $options{ $elem->attr('value') } = 1;
        }
    );
    is @selected                   => 1,   "selected one option";
    is $selected[0]->attr('value') => '2', "and the option has value 2";
    is $options{1}                 => 1,   "existed option value 1";
    is $options{2}                 => 1,   "existed option value 2";

    # Manage user - Other's draft data
    $app->login($manage_user);
    $app->get_ok(
        {   __mode          => 'view',
            blog_id         => $site->id,
            content_type_id => $content_type->id,
            _type           => 'content_data',
            type            => 'content_data_' . $content_type->id,
            id              => $cd_cuser->id,
        },
    );

    note $app->wq_find("select[name='status']")->as_html;
    @selected = ();
    $app->wq_find("select[name='status'] option")->each(
        sub {
            my ( $i, $elem ) = @_;
            push @selected, $elem if $elem->attr('selected');
            $options{ $elem->attr('value') } = 1;
        }
    );
    is @selected                   => 1,   "selected one option";
    is $selected[0]->attr('value') => '1', "and the option has value 1";
    is $options{1}                 => 1,   "existed option value 1";
    is $options{2}                 => 1,   "existed option value 2";
    is $options{4}                 => 1,   "existed option value 4";

    # Manage user - Other's published data
    $app->get_ok(
        {   __mode          => 'view',
            blog_id         => $site->id,
            content_type_id => $content_type->id,
            _type           => 'content_data',
            type            => 'content_data_' . $content_type->id,
            id              => $cd->id,
        },
    );

    note $app->wq_find("select[name='status']")->as_html;
    @selected = ();
    $app->wq_find("select[name='status'] option")->each(
        sub {
            my ( $i, $elem ) = @_;
            push @selected, $elem if $elem->attr('selected');
            $options{ $elem->attr('value') } = 1;
        }
    );
    is @selected                   => 1,   "selected one option";
    is $selected[0]->attr('value') => '2', "and the option has value 2";
    is $options{1}                 => 1,   "existed option value 1";
    is $options{2}                 => 1,   "existed option value 2";
};

done_testing();
