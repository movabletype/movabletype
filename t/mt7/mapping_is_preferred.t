use strict;
use warnings;

use Test::More;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib qw( lib extlib t/lib );
use MT::Test qw( :app :db );
use MT::Test::Permission;

# Site
my $site = MT->model('website')->load();

# Author
my $admin = MT->model('author')->load(1);

my $content_type_01 = MT::Test::Permission->make_content_type(
    blog_id => $site->id,
    name    => 'test content type 01',
);

my $content_type_02 = MT::Test::Permission->make_content_type(
    blog_id => $site->id,
    name    => 'test content type 02',
);

my $template_01 = MT::Test::Permission->make_template(
    blog_id         => $site->id,
    content_type_id => $content_type_01->id,
    name            => 'ContentType Test 01',
    type            => 'ct',
    text            => 'test',
);

my $template_02 = MT::Test::Permission->make_template(
    blog_id         => $site->id,
    content_type_id => $content_type_02->id,
    name            => 'ContentType Test 02',
    type            => 'ct',
    text            => 'test',
);

subtest 'Add 1st TemplateMap' => sub {
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __mode           => 'add_map',
            blog_id          => $site->id,
            template_id      => $template_01->id,
            new_archive_type => 'ContentType',
            file_template    => '%y/%m/%-f',
            dt_field_id      => 0,
        },
    );
    my $out = delete $app->{__test_output};

    like(
        $out,
        qr/<div id="templatemap-listing" class="form-group">/,
        'Added 1st TemplateMap.'
    );

    my $first_template = MT->model('templatemap')->load(1);
    is( $first_template->is_preferred, 1, '1st TemplateMap is preferred.' );
};

subtest 'Add 2nd TemplateMap' => sub {
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __mode           => 'add_map',
            blog_id          => $site->id,
            template_id      => $template_01->id,
            new_archive_type => 'ContentType',
            file_template    => '%y/%m/%-f',
            dt_field_id      => 0,
        },
    );
    my $out = delete $app->{__test_output};

    like(
        $out,
        qr/<div id="templatemap-listing" class="form-group">/,
        'Added 2nd TemplateMap.'
    );

    my $second_template = MT->model('templatemap')->load(2);
    is( $second_template->is_preferred,
        0, '2nd TemplateMap is not preferred.' );

    my $first_template = MT->model('templatemap')->load(1);
    is( $first_template->is_preferred, 1, '1st TemplateMap is preferred.' );
};

subtest 'Add 3rd TemplateMap' => sub {
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __mode           => 'add_map',
            blog_id          => $site->id,
            template_id      => $template_01->id,
            new_archive_type => 'ContentType',
            file_template    => '%y/%m/%-f',
            dt_field_id      => 0,
        },
    );
    my $out = delete $app->{__test_output};

    like(
        $out,
        qr/<div id="templatemap-listing" class="form-group">/,
        'Added 3rd TemplateMap.'
    );

    my $third_template = MT->model('templatemap')->load(3);
    is( $third_template->is_preferred,
        0, '3rd TemplateMap is not preferred.' );

    my $second_template = MT->model('templatemap')->load(2);
    is( $second_template->is_preferred,
        0, '2nd TemplateMap is not preferred.' );

    my $first_template = MT->model('templatemap')->load(1);
    is( $first_template->is_preferred, 1, '1st TemplateMap is preferred.' );
};

subtest 'Add Another Content Type\'s TemplateMap 01' => sub {
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __mode           => 'add_map',
            blog_id          => $site->id,
            template_id      => $template_02->id,
            new_archive_type => 'ContentType',
            file_template    => '%y/%m/%-f',
            dt_field_id      => 0,
        },
    );
    my $out = delete $app->{__test_output};

    like(
        $out,
        qr/<div id="templatemap-listing" class="form-group">/,
        'Added Another Content Type\'s TemplateMap 01.'
    );

    my $another_template = MT->model('templatemap')->load(4);
    is( $another_template->is_preferred,
        1, 'Another Content Type\'s TemplateMap 01 is preferred.' );

    my $third_template = MT->model('templatemap')->load(3);
    is( $third_template->is_preferred,
        0, '3rd TemplateMap is not preferred.' );

    my $second_template = MT->model('templatemap')->load(2);
    is( $second_template->is_preferred,
        0, '2nd TemplateMap is not preferred.' );

    my $first_template = MT->model('templatemap')->load(1);
    is( $first_template->is_preferred, 1, '1st TemplateMap is preferred.' );
};

subtest 'Add Another Content Type\'s TemplateMap 02' => sub {
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __mode           => 'add_map',
            blog_id          => $site->id,
            template_id      => $template_02->id,
            new_archive_type => 'ContentType',
            file_template    => '%y/%m/%-f',
            dt_field_id      => 0,
        },
    );
    my $out = delete $app->{__test_output};

    like(
        $out,
        qr/<div id="templatemap-listing" class="form-group">/,
        'Added Another Content Type\'s TemplateMap 02.'
    );

    my $another_template_02 = MT->model('templatemap')->load(5);
    is( $another_template_02->is_preferred,
        0, 'Another Content Type\'s TemplateMap 02 is not preferred.' );

    my $another_template_01 = MT->model('templatemap')->load(4);
    is( $another_template_01->is_preferred,
        1, 'Another Content Type\'s TemplateMap 01 is preferred.' );

    my $third_template = MT->model('templatemap')->load(3);
    is( $third_template->is_preferred,
        0, '3rd TemplateMap is not preferred.' );

    my $second_template = MT->model('templatemap')->load(2);
    is( $second_template->is_preferred,
        0, '2nd TemplateMap is not preferred.' );

    my $first_template = MT->model('templatemap')->load(1);
    is( $first_template->is_preferred, 1, '1st TemplateMap is preferred.' );
};

subtest 'Change Preferred TemplateMap' => sub {
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user                          => $admin,
            __mode                               => 'save',
            _type                                => 'template',
            id                                   => $template_01->id,
            blog_id                              => $site->id,
            type                                 => 'ct',
            current_revision                     => '11',
            name                                 => 'ContentType Test 01',
            content_type_id                      => 1,
            text                                 => 'test',
            archive_file_sel_2                   => '%y/%m/%-f',
            archive_file_tmpl_2                  => '%y/%m/%-f',
            archive_tmpl_preferred_ContentType_2 => '1',
            dt_field_id_2                        => 0,
            map_build_type_2                     => '1',
            new_archive_type                     => 'ContentType',
            return_args => '__mode=view&_type=template&blog_id=1&id=2',
        },
    );
    my $out = delete $app->{__test_output};

    like( $out, qr/302 Found/, 'Changed Preferred TemplateMap.' );

    my $another_template_02 = MT->model('templatemap')->load(5);
    is( $another_template_02->is_preferred,
        0, 'Another Content Type\'s TemplateMap 02 is not preferred.' );

    my $another_template_01 = MT->model('templatemap')->load(4);
    is( $another_template_01->is_preferred,
        1, 'Another Content Type\'s TemplateMap 01 is preferred.' );

    my $third_template = MT->model('templatemap')->load(3);
    is( $third_template->is_preferred,
        0, '3rd TemplateMap is not preferred.' );

    my $second_template = MT->model('templatemap')->load(2);
    is( $second_template->is_preferred, 1, '2nd TemplateMap is preferred.' );

    my $first_template = MT->model('templatemap')->load(1);
    is( $first_template->is_preferred,
        0, '1st TemplateMap is not preferred.' );
};

subtest 'Remove Preferred TemplateMap' => sub {
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user => $admin,
            __mode      => 'delete_map',
            blog_id     => $site->id,
            template_id => $template_01->id,
            id          => 2,
        },
    );
    my $out = delete $app->{__test_output};

    like(
        $out,
        qr/<div id="templatemap-listing" class="form-group">/,
        'Removed Preferred TemplateMap 02.'
    );

    my $another_template_02 = MT->model('templatemap')->load(5);
    is( $another_template_02->is_preferred,
        0, 'Another Content Type\'s TemplateMap 02 is not preferred.' );

    my $another_template_01 = MT->model('templatemap')->load(4);
    is( $another_template_01->is_preferred,
        1, 'Another Content Type\'s TemplateMap 01 is preferred.' );

    my $third_template = MT->model('templatemap')->load(3);
    is( $third_template->is_preferred,
        0, '3rd TemplateMap is not preferred.' );

    my $second_template = MT->model('templatemap')->load(2);
    is( $second_template, undef, '2nd TemplateMap is removed.' );

    my $first_template = MT->model('templatemap')->load(1);
    is( $first_template->is_preferred, 1, '1st TemplateMap is preferred.' );
};

done_testing;
