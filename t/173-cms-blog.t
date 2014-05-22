#!/usr/bin/perl

use strict;
use warnings;

use lib qw( lib extlib ../lib ../extlib t/lib );

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

BEGIN {
    use Test::More;
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';
}

use MT;
use MT::Association;
use MT::CMS::User;
use MT::Role;

use MT::Test qw( :app :db :data );

use Test::More;

MT->instance;
my $user        = MT::Author->load(1);
my $mock_author = Test::MockModule->new('MT::Author');
our $is_superuser = 0;
$mock_author->mock( 'is_superuser', sub {$is_superuser} );
my $website = MT::Website->load(2);
is( !!$website->is_blog, '', 'Is a website' );

my $admin_role
    = MT::Role->load( { permissions => { like => '%administer_website%' } } );
require MT::Association;
MT::Association->link( $user, $admin_role, $website );

my %callbacks = ();
my $mock_mt   = Test::MockModule->new('MT');
$mock_mt->mock(
    'run_callbacks',
    sub {
        my ( $app, $meth, @param ) = @_;
        $callbacks{$meth} ||= [];
        push @{ $callbacks{$meth} }, \@param;
        $mock_mt->original('run_callbacks')->(@_);
    }
);

subtest 'Check callbacks for each config screens' => sub {
    my @screens = (
        {   __mode => 'cfg_prefs',
            name   => 'General Settings',
        },
        {   __mode => 'cfg_entry',
            name   => 'Compose Settings',
        },
        {   __mode => 'cfg_feedback',
            name   => 'Feedback Settings',
        },
        {   __mode => 'cfg_registration',
            skip   => 1,
            name   => 'Registration Settings',
        },
        {   __mode => 'cfg_web_services',
            name   => 'Web Services Settings',
        },
    );

    for my $s (@screens) {
        subtest $s->{name} . ' screen' => sub {
            %callbacks = ();

            plan skip_all => 'This test is skip for this screen'
                if $s->{skip};

            my %param = (
                __test_user => $user,
                __mode      => $s->{__mode},
                blog_id     => $website->id
            );
            my $app = _run_app( 'MT::App::CMS', \%param );
            my $out = delete $app->{__test_output};

            for my $t (qw(blog website)) {
                for my $name (
                    qw(cms_object_scope_filter cms_view_permission_filter cms_edit)
                    )
                {
                    my $cb = 'MT::App::CMS::' . $name . '.' . $t;
                    is( scalar @{ $callbacks{$cb} || [] },
                        1, $cb . ' has been called once' );
                }
            }

            like(
                $out,
                qr/name="__mode"\s*value="save"(?:(?!form).)*name="_type"\s*value="website"/sm,
                '"website" is specified for "_type"'
            );

            done_testing;
        };
    }

    done_testing;
};

subtest 'Check callbacks for each config screens for global level' => sub {
    local $is_superuser = 1;

    my @screens = (
        {   __mode => 'cfg_web_services',
            name   => 'Web Services Settings',
            like   => qr/__mode" value="save_cfg_system_web_services"/,
        },
    );

    for my $s (@screens) {
        subtest $s->{name} . ' screen' => sub {
            %callbacks = ();

            plan skip_all => 'This test is skip for this screen'
                if $s->{skip};

            my %param = (
                __test_user => $user,
                __mode      => $s->{__mode},
                blog_id     => 0,
            );
            my $app = _run_app( 'MT::App::CMS', \%param );
            my $out = delete $app->{__test_output};

            for my $t (qw(blog)) {
                for my $name (
                    qw(cms_edit)
                    )
                {
                    my $cb = 'MT::App::CMS::' . $name . '.' . $t;
                    is( scalar @{ $callbacks{$cb} || [] },
                        1, $cb . ' has been called once' );
                }
            }

            like( $out, $s->{like}, 'output' );

            done_testing;
        };
    }

    done_testing;
};

subtest 'Check callbacks for saving' => sub {
    %callbacks = ();

    my %param = (
        __test_user      => $user,
        __mode           => 'save',
        __request_method => 'POST',
        _type            => 'website',
        id               => $website->id,
        blog_id          => $website->id,
        site_url         => q(),
    );
    my $app = _run_app( 'MT::App::CMS', \%param );
    my $out = delete $app->{__test_output};

    for my $t (qw(blog website)) {
        for my $name (
            qw(cms_save_permission_filter cms_save_filter cms_pre_save cms_post_save)
            )
        {
            my $cb = 'MT::App::CMS::' . $name . '.' . $t;
            is( scalar @{ $callbacks{$cb} || [] },
                1, $cb . ' has been called once' );
        }
    }

    like( $out, qr/Location:.*saved=1/, 'Saved successfully' );

    done_testing;
};

done_testing;
