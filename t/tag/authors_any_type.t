use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;

plan tests => (1 + 2) * blocks;

use MT::Association;
use MT::Role;
use MT::Website;

use MT::Test;
use MT::Test::Permission;

my $site_id = 1;

$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    my $site = MT::Website->load($site_id) or die MT::Website->errstr;

    my $role_site_admin   = MT::Role->load({ name => 'Site Administrator' }) or die MT::Role->errstr;
    my $author_site_admin = MT::Test::Permission->make_author(name => 'site_admin');
    MT::Association->link($author_site_admin => $role_site_admin => $site);

    my $author_author_having_entry = MT::Test::Permission->make_author(name => 'author_having_entry');
    my $role_author                = MT::Role->load({ name => 'Author' }) or die MT::Role->errstr;
    MT::Association->link($author_author_having_entry => $role_author => $site);
    MT::Test::Permission->make_entry(
        blog_id   => $site->id,
        author_id => $author_author_having_entry->id,
    );

    my $author_author_having_no_entry = MT::Test::Permission->make_author(name => 'author_having_no_entry');
    MT::Association->link($author_author_having_no_entry => $role_author => $site);

    my $author_content_designer = MT::Test::Permission->make_author(name => 'content_designer');
    my $role_content_designer   = MT::Role->load({ name => 'Content Designer' }) or die MT::Role->errstr;
    MT::Association->link($author_content_designer => $role_content_designer => $site);

    my $other_site_admin = MT::Test::Permission->make_author(name => 'other_site_admin');
    my $other_site       = MT::Test::Permission->make_website(name => 'other_site');
    MT::Association->link($other_site_admin => $role_site_admin => $other_site);

    my $system_permission_author = MT::Test::Permission->make_author(name => 'system_permission_author');
    my $perm = $system_permission_author->permissions(0);
    $perm->can_sign_in_cms(1);
    $perm->can_sign_in_data_api(1);
    $perm->can_edit_templates(1);
    $perm->save or die $perm->errstr;

    MT::Test::Permission->make_author(name => 'no_permission_author');
});

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
    error    => [qw( chomp )],
};

MT::Test::Tag->run_perl_tests($site_id);
MT::Test::Tag->run_php_tests($site_id);

__END__

=== (no modifiers)
--- template
<mtauthors><mtauthorname>(<mtauthorid>)
</mtauthors>
--- expected
author_having_entry(3)

=== need_entry="1"
--- template
<mtauthors need_entry="1"><mtauthorname>(<mtauthorid>)
</mtauthors>
--- expected
author_having_entry(3)

=== any_type="1"
--- template
<mtauthors any_type="1"><mtauthorname>(<mtauthorid>)
</mtauthors>
--- expected
site_admin(2)
author_having_entry(3)
author_having_no_entry(4)
content_designer(5)
Melody(1)

=== need_entry="0" any_type="0"
--- template
<mtauthors need_entry="0" any_type="0"><mtauthorname>(<mtauthorid>)
</mtauthors>
--- expected
site_admin(2)
author_having_entry(3)
author_having_no_entry(4)
Melody(1)
