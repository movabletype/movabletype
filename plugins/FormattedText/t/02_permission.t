#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;

MT::Test->init_app;

my $mt = MT->instance;

### Make test data
$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    # Website
    my $website = MT::Test::Permission->make_website(
        name => 'my website',
    );

    # Blog
    my $blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name => 'my blog',
    );
    my $second_blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name => 'second blog',
    );

    # Author
    my $aikawa = MT::Test::Permission->make_author(
        name     => 'aikawa',
        nickname => 'Ichiro Aikawa',
    );

    my $ichikawa = MT::Test::Permission->make_author(
        name     => 'ichikawa',
        nickname => 'Jiro Ichikawa',
    );

    my $ukawa = MT::Test::Permission->make_author(
        name     => 'ukawa',
        nickname => 'Saburo Ukawa',
    );

    my $egawa = MT::Test::Permission->make_author(
        name     => 'egawa',
        nickname => 'Shiro Egawa',
    );

    my $ogawa = MT::Test::Permission->make_author(
        name     => 'ogawa',
        nickname => 'Goro Ogawa',
    );

    my $kagawa = MT::Test::Permission->make_author(
        name     => 'kagawa',
        nickname => 'Ichiro Kagawa',
    );

    my $kikkawa = MT::Test::Permission->make_author(
        name     => 'kikkawa',
        nickname => 'Jiro Kikkawa',
    );

    my $kumekawa = MT::Test::Permission->make_author(
        name     => 'kumekawa',
        nickname => 'Saburo Kumekawa',
    );

    my $kemikawa = MT::Test::Permission->make_author(
        name     => 'kemikawa',
        nickname => 'Shiro Kemikawa',
    );

    my $koishikawa = MT::Test::Permission->make_author(
        name     => 'koishikawa',
        nickname => 'Goro Koishikawa',
    );

    my $sagawa = MT::Test::Permission->make_author(
        name     => 'sagawa',
        nickname => 'Ichiro Sagawa',
    );

    my $shimoda = MT::Test::Permission->make_author(
        name     => 'shimoda',
        nickname => 'Jiro Shimoda',
    );

    my $suda = MT::Test::Permission->make_author(
        name     => 'suda',
        nickname => 'Saburo Suda',
    );

    my $seta = MT::Test::Permission->make_author(
        name     => 'seta',
        nickname => 'Shiro Seta',
    );

    my $soneda = MT::Test::Permission->make_author(
        name     => 'soneda',
        nickname => 'Goro Soneda',
    );

    my $taneda = MT::Test::Permission->make_author(
        name     => 'taneda',
        nickname => 'Ichiro Taneda',
    );

    my $tsuda = MT::Test::Permission->make_author(
        name     => 'tsuda',
        nickname => 'Saburo Tsuda',
    );

    my $tezuka = MT::Test::Permission->make_author(
        name     => 'tezuka',
        nickname => 'Shiro Tezuka',
    );

    my $admin = MT::Author->load(1);

    # Role
    my $create_post = MT::Test::Permission->make_role(
        name        => 'Create Post',
        permissions => "'create_post'",
    );

    my $edit_all_posts = MT::Test::Permission->make_role(
        name        => 'Edit All Posts',
        permissions => "'edit_all_posts'",
    );

    my $manage_pages = MT::Test::Permission->make_role(
        name        => 'Manage Pages',
        permissions => "'manage_pages'",
    );

    my $publish_post = MT::Test::Permission->make_role(
        name        => 'Publish Post',
        permissions => "'publish_post'",
    );

    my $edit_config = MT::Test::Permission->make_role(
        name        => 'Edit Config',
        permissions => "'edit_config'",
    );

    my $designer = MT::Role->load( { name => MT->translate('Designer') } );

    require MT::Association;
    MT::Association->link( $aikawa   => $edit_config    => $blog );
    MT::Association->link( $ichikawa => $create_post    => $blog );
    MT::Association->link( $ukawa    => $edit_all_posts => $blog );
    MT::Association->link( $egawa    => $manage_pages   => $blog );
    MT::Association->link( $ogawa    => $create_post    => $blog );
    MT::Association->link( $kagawa   => $designer       => $blog );
    MT::Association->link( $shimoda  => $publish_post   => $blog );
    MT::Association->link( $seta     => $publish_post   => $blog );

    MT::Association->link( $kikkawa    => $edit_config    => $second_blog );
    MT::Association->link( $kumekawa   => $create_post    => $second_blog );
    MT::Association->link( $koishikawa => $edit_all_posts => $second_blog );
    MT::Association->link( $kemikawa   => $manage_pages   => $second_blog );
    MT::Association->link( $suda       => $publish_post   => $second_blog );

    MT::Association->link( $soneda, $edit_config,    $website );
    MT::Association->link( $taneda, $create_post,    $website );
    MT::Association->link( $tsuda,  $edit_all_posts, $website );
    MT::Association->link( $tezuka, $manage_pages,   $website );
});

my $website = MT::Website->load( { name => 'my website' } );

my $blog = MT::Blog->load( { name => 'my blog' } );

my $aikawa     = MT::Author->load( { name => 'aikawa' } );
my $ichikawa   = MT::Author->load( { name => 'ichikawa' } );
my $ukawa      = MT::Author->load( { name => 'ukawa' } );
my $egawa      = MT::Author->load( { name => 'egawa' } );
my $ogawa      = MT::Author->load( { name => 'ogawa' } );
my $kagawa     = MT::Author->load( { name => 'kagawa' } );
my $kikkawa    = MT::Author->load( { name => 'kikkawa' } );
my $kumekawa   = MT::Author->load( { name => 'kumekawa' } );
my $kemikawa   = MT::Author->load( { name => 'kemikawa' } );
my $koishikawa = MT::Author->load( { name => 'koishikawa' } );
my $sagawa     = MT::Author->load( { name => 'sagawa' } );
my $shimoda    = MT::Author->load( { name => 'shimoda' } );
my $suda       = MT::Author->load( { name => 'suda' } );
my $seta       = MT::Author->load( { name => 'seta' } );
my $soneda     = MT::Author->load( { name => 'soneda' } );
my $taneda     = MT::Author->load( { name => 'taneda' } );
my $tsuda      = MT::Author->load( { name => 'tsuda' } );
my $tezuka     = MT::Author->load( { name => 'tezuka' } );

my $admin = MT::Author->load(1);

my $ichikawa_template = $mt->model('formatted_text')->new;
$ichikawa_template->set_values(
    {   blog_id    => $blog->id,
        created_by => $ichikawa->id,
    }
);

my $ukawa_template = $mt->model('formatted_text')->new;
$ukawa_template->set_values(
    {   blog_id    => $blog->id,
        created_by => $ukawa->id,
    }
);

my $taneda_template = $mt->model('formatted_text')->new;
$taneda_template->set_values(
    {   blog_id    => $website->id,
        created_by => $taneda->id,
    },
);
$taneda_template->save;

my $tsuda_template = $mt->model('formatted_text')->new;
$tsuda_template->set_values(
    {   blog_id    => $website->id,
        created_by => $tsuda->id,
    },
);
$tsuda_template->save;

use FormattedText::App;

subtest 'Common scope' => sub {

    note('FormattedText::App::can_edit_formatted_text (for new object)');

    ok( FormattedText::App::can_edit_formatted_text(
            $ichikawa->permissions($blog),
            undef, $ichikawa
        ),
        'Permission: Create Post: Can create boilerplate'
    );

    ok( FormattedText::App::can_edit_formatted_text(
            $ukawa->permissions($blog),
            undef, $ukawa
        ),
        'Permission: Edit All Posts: Can create boilerplate'
    );

    ok( !FormattedText::App::can_edit_formatted_text(
            $egawa->permissions($blog),
            undef, $aikawa
        ),
        'Permission: Manage Pages: Cannot create boilerplate'
    );

    ok( !FormattedText::App::can_edit_formatted_text(
            $aikawa->permissions($blog),
            undef, $aikawa
        ),
        'Permission: Edit Config: Cannot create boilerplate'
    );

    note('FormattedText::App::can_edit_formatted_text (for existing object)');

    ok( FormattedText::App::can_edit_formatted_text(
            $ichikawa->permissions($blog),
            $ichikawa_template, $ichikawa
        ),
        'Permission: Create Post: Can edit boilerplate created by oneself'
    );
    ok( !FormattedText::App::can_edit_formatted_text(
            $ichikawa->permissions($blog),
            $ukawa_template, $ichikawa
        ),
        'Permission: Create Post: Cannot edit boilerplate created by others'
    );

    ok( FormattedText::App::can_edit_formatted_text(
            $ukawa->permissions($blog),
            $ukawa_template, $ukawa
        ),
        'Permission: Edit All Posts: Can edit boilerplate created by oneself'
    );
    ok( FormattedText::App::can_edit_formatted_text(
            $ukawa->permissions($blog),
            $ichikawa_template, $ukawa
        ),
        'Permission: Edit All Posts: Can edit boilerplate created by others'
    );

    ok( !FormattedText::App::can_edit_formatted_text(
            $egawa->permissions($blog),
            $ichikawa_template, $egawa
        ),
        'Permission: Manage Pages: Cannot edit boilerplate'
    );

    ok( !FormattedText::App::can_edit_formatted_text(
            $aikawa->permissions($blog),
            $ichikawa_template, $aikawa
        ),
        'Permission: Edit Config: Cannot edit boilerplate'
    );

    note('FormattedText::App::can_view_formatted_text');

    ok( FormattedText::App::can_view_formatted_text(
            $ichikawa->permissions($blog),
            $ichikawa_template, $ichikawa
        ),
        'Permission: Create Post: Can view boilerplate created by oneself'
    );
    ok( FormattedText::App::can_view_formatted_text(
            $ichikawa->permissions($blog),
            $ukawa_template, $ichikawa
        ),
        'Permission: Create Post: Cannot view boilerplate created by others'
    );

    ok( FormattedText::App::can_view_formatted_text(
            $ukawa->permissions($blog),
            $ukawa_template, $ukawa
        ),
        'Permission: Edit All Posts: Can view boilerplate created by oneself'
    );
    ok( FormattedText::App::can_view_formatted_text(
            $ukawa->permissions($blog),
            $ichikawa_template, $ukawa
        ),
        'Permission: Edit All Posts: Can view boilerplate created by others'
    );

    ok( !FormattedText::App::can_view_formatted_text(
            $egawa->permissions($blog),
            $ichikawa_template, $egawa
        ),
        'Permission: Manage Pages: Cannot view boilerplate'
    );

    ok( !FormattedText::App::can_view_formatted_text(
            $aikawa->permissions($blog),
            $ichikawa_template, $aikawa
        ),
        'Permission: Edit Config: Cannot view boilerplate'
    );

};

subtest 'Website scope' => sub {
    my $cnt = 0;

    my @view_suite = (
        {   perm => 'Administrator',
            user => $admin,
            ok   => 1,
        },
        {   perm => 'Create Post',
            user => $taneda,
            ok   => 1,
        },
        {   perm => 'Edit All Posts',
            user => $tsuda,
            ok   => 1,
        },
        {   perm => 'Manage Pages',
            user => $tezuka,
            ok   => 0,
        },
        {   perm => 'Edit Config',
            user => $soneda,
            ok   => 0,
        },
    );

    my @edit_suite = (
        {   perm        => 'Administrator',
            user        => $admin,
            boilerplate => $taneda_template,
            ok          => 1,
        },
        {   perm        => 'Create Post',
            user        => $taneda,
            boilerplate => $taneda_template,
            oneself     => 1,
            ok          => 1,
        },
        {   perm        => 'Create Post',
            user        => $taneda,
            boilerplate => $tsuda_template,
            oneself     => 0,
            ok          => 0,
        },
        {   perm        => 'Edit All Posts',
            user        => $tsuda,
            boilerplate => $tsuda_template,
            oneself     => 1,
            ok          => 1,
        },
        {   perm        => 'Edit All Posts',
            user        => $tsuda,
            boilerplate => $taneda_template,
            oneself     => 0,
            ok          => 1,
        },
        {   perm        => 'Manage Pages',
            user        => $tezuka,
            boilerplate => $taneda_template,
            ok          => 0,
        },
        {   perm        => 'Edit Config',
            user        => $soneda,
            boilerplate => $taneda_template,
            ok          => 0,
        },
    );

    subtest 'List boilerplates' => sub {
        foreach my $data (@view_suite) {
            my $app = _run_app(
                'MT::App::CMS',
                {   __test_user => $data->{user},
                    __mode      => 'list',
                    _type       => 'formatted_text',
                    blog_id     => $website->id,
                },
            );
            my $out = delete $app->{__test_output};

            if ( $data->{ok} ) {
                unlike( $out, qr/(redirect|permission)=1/,
                          'Permission: '
                        . $data->{perm}
                        . ": Can list boilerplates" );
            }
            else {
                like( $out, qr/(redirect|permission)=1/,
                          'Permission: '
                        . $data->{perm}
                        . ": Cannot list boilerplates" );
            }
        }
    };

    subtest 'View boilerplate (for new object)' => sub {
        foreach my $data (@view_suite) {
            my $app = _run_app(
                'MT::App::CMS',
                {   __test_user => $data->{user},
                    __mode      => 'view',
                    _type       => 'formatted_text',
                    blog_id     => $website->id,
                },
            );
            my $out = delete $app->{__test_output};

            if ( $data->{ok} ) {
                unlike( $out, qr/(redirect|permission)=1/,
                          'Permission: '
                        . $data->{perm}
                        . ": Can view boilerplate" );
            }
            else {
                like( $out, qr/(redirect|permission)=1/,
                          'Permission: '
                        . $data->{perm}
                        . ": Cannot view boilerplate" );
            }
        }
    };

    subtest 'View boilerplate (for existing object)' => sub {
        foreach my $data (@edit_suite) {
            my $app = _run_app(
                'MT::App::CMS',
                {   __test_user => $data->{user},
                    __mode      => 'view',
                    _type       => 'formatted_text',
                    blog_id     => $website->id,
                    id          => $data->{boilerplate}->id,
                },
            );
            my $out = delete $app->{__test_output};

            if ( $data->{ok} ) {
                my $test
                    = 'Permission: '
                    . $data->{perm}
                    . ': Can view boilerplate';
                if ( exists $data->{oneself} ) {
                    $test .= $data->{oneself} ? ' by oneself' : ' by others';
                }
                unlike( $out, qr/(redirect|permission)=1/, $test );
            }
            else {
                my $test
                    = 'Permission: '
                    . $data->{perm}
                    . ': Cannot view boilerplate';
                if ( exists $data->{oneself} ) {
                    $test .= $data->{oneself} ? ' by oneself' : ' by others';
                }
                like( $out, qr/(redirect|permission)=1/, $test );
            }
        }
    };

    subtest 'Save boilerplate (for new object)' => sub {
        foreach my $data (@view_suite) {
            my $app = _run_app(
                'MT::App::CMS',
                {   __test_user      => $data->{user},
                    __request_method => 'POST',
                    __mode           => 'save',
                    _type            => 'formatted_text',
                    blog_id          => $website->id,
                    label            => 'New boilerplate ' . $cnt,
                },
            );
            $cnt++;
            my $out = delete $app->{__test_output};

            if ( $data->{ok} ) {
                my $test
                    = 'Permission: '
                    . $data->{perm}
                    . ': Can create boilerplate';
                ok( $out =~ /saved=1&saved_added=1/
                        && $out !~ /(redirect|permission)=1/,
                    $test
                );
            }
            else {
                my $test
                    = 'Permission: '
                    . $data->{perm}
                    . ': Cannot create boilerplate';
                ok( $out !~ /saved=1&saved_added=1/
                        && $out =~ /(redirect|permission)=1/,
                    $test
                );
            }
        }
    };

    subtest 'Save boilerplate (for existing object)' => sub {
        foreach my $data (@edit_suite) {
            my $app = _run_app(
                'MT::App::CMS',
                {   __test_user      => $data->{user},
                    __request_method => 'POST',
                    __mode           => 'save',
                    _type            => 'formatted_text',
                    blog_id          => $website->id,
                    id               => $data->{boilerplate}->id,
                    label            => 'Change ' . $cnt,
                },
            );
            $cnt++;
            my $out = delete $app->{__test_output};

            if ( $data->{ok} ) {
                my $test
                    = 'Permission: '
                    . $data->{perm}
                    . ': Can update boilerplate';
                if ( exists $data->{oneself} ) {
                    $test .= $data->{oneself} ? ' by oneself' : ' by others';
                }
                ok( $out =~ /saved=1&saved_changes=1/
                        && $out !~ /(redirect|permission)=1/,
                    $test
                );
            }
            else {
                my $test
                    = 'Permission: '
                    . $data->{perm}
                    . ': Cannot update boilerplate';
                if ( exists $data->{oneself} ) {
                    $test .= $data->{oneself} ? ' by oneself' : ' by others';
                }
                ok( $out !~ /saved=1&saved_changes=1/
                        && $out =~ /(redirect|permission)=1/,
                    $test
                );
            }
        }
    };

    subtest 'Delete boilerplate' => sub {
        foreach my $data (@edit_suite) {
            my $boilerplate = $data->{boilerplate};
            $data->{boilerplate}
                = MT->model('formatted_text')->load( $boilerplate->id );
            if ( !$data->{boilerplate} ) {
                my $temp = MT->model('formatted_text')->new;
                $temp->set_values(
                    {   blog_id    => $boilerplate->blog_id,
                        created_by => $boilerplate->created_by,
                    }
                );
                $temp->save;

                $data->{boilerplate} = $temp;
            }

            my $app = _run_app(
                'MT::App::CMS',
                {   __test_user      => $data->{user},
                    __request_method => 'POST',
                    __mode           => 'delete',
                    _type            => 'formatted_text',
                    action_name      => 'delete',
                    blog_id          => $website->id,
                    id               => $data->{boilerplate}->id,
                },
            );
            my $out = delete $app->{__test_output};

            if ( $data->{ok} ) {
                my $test
                    = 'Permission: '
                    . $data->{perm}
                    . ': Can delete boilerplate';
                if ( exists $data->{oneself} ) {
                    $test .= $data->{oneself} ? ' by oneself' : ' by others';
                }
                ok( $out =~ /saved_deleted=1/
                        && $out !~ /(redirect|permission)=1/,
                    $test
                );
            }
            else {
                my $test
                    = 'Permission: '
                    . $data->{perm}
                    . ': Cannot delete boilerplate';
                if ( exists $data->{oneself} ) {
                    $test .= $data->{oneself} ? ' by oneself' : ' by others';
                }
                ok( $out !~ /saved_deleted=1/
                        && $out =~ /(redirect|permission)=1/,
                    $test
                );
            }
        }
    };

};

done_testing;
