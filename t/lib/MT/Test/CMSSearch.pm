# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#

package MT::Test::CMSSearch;
use strict;
use warnings;
use base qw( Exporter );
use Test::More;
use URI;

our @EXPORT = qw/ test_search /;

my $id_getter = {
    entry        => \&_id_getter_entry,
    page         => \&_id_getter_entry,
    content_data => \&_id_getter_entry,
};

sub test_search {
    my ($data) = @_;
    my $params = $data->{params};
    my $name   = $data->{name} || do {
        my $uri = URI->new;
        $uri->query_form($params);
        'right result for ' . $uri;
    };
    my $author = $data->{author};
    $author = MT::Author->load($data->{author}) unless ref($author);

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author);
    $app->post_ok({ __mode => 'search_replace', %$params });

    if ($data->{ids}) {
        my @ids = $id_getter->{ $params->{_type} || 'entry' }->($app);
        is_deeply(\@ids, $data->{ids}, $name);
        note explain \@ids;
        # note $app->content;
    }

    if (my $complete = $data->{complete}) {
        $complete->($data, $app);
    }
}

sub _id_getter_entry {
    my $app   = shift;
    my @links = $app->wq_find('.mt-table tbody tr td:nth-of-type(3) strong a');
    return map { ($_ =~ qr{\bid=(\d+)})[0] } map { $_->attr('href') } @links;
}

1;
