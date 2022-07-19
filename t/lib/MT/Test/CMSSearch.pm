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

my $scrape_id = {
    content_data => sub { _scrape_id_via_link($_[0], 'td:nth-of-type(3) strong a', 'id') },
    entry        => sub { _scrape_id_via_link($_[0], 'td:nth-of-type(3) strong a', 'id') },
    page         => sub { _scrape_id_via_link($_[0], 'td:nth-of-type(3) strong a', 'id') },
    template     => sub { _scrape_id_via_link($_[0], 'td:nth-of-type(2) a',        'id') },
    asset        => sub { _scrape_id_via_link($_[0], 'td:nth-of-type(3) a',        'id') },
    log          => sub { die 'Not implemented yet' },
    user         => sub { _scrape_id_via_link($_[0], 'td:nth-of-type(2) a', 'id') },
    group        => sub { die 'Not implemented yet' },
    blog         => sub { _scrape_id_via_link($_[0], 'td:nth-of-type(2) a', 'blog_id') },
    website      => sub { _scrape_id_via_link($_[0], 'td:nth-of-type(2) a', 'blog_id') },
};

my $scrape_name = {
    template => sub { _scrape_name($_[0], 'td:nth-of-type(2) a') },
    entry    => sub { _scrape_name($_[0], 'td:nth-of-type(3) strong a') },
    asset    => sub { _scrape_name($_[0], 'td:nth-of-type(3) a') },
    blog     => sub { _scrape_name($_[0], 'td:nth-of-type(2) a') },
    website  => sub { _scrape_name($_[0], 'td:nth-of-type(2) a') },
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

    if (my $expected = $data->{expected_obj_names}) {
        my @got = $scrape_name->{ $params->{_type} || 'entry' }->($app);
        if ($data->{expected_obj_ignore_order}) {
            is_deeply([sort @got], [sort @$expected], $name);
        } else {
            is_deeply(\@got, $expected, $name);
        }
        note explain \@got;
        # note $app->content;
    }

    if (my $expected = $data->{expected_obj_ids}) {
        my @got = $scrape_id->{ $params->{_type} || 'entry' }->($app);
        is_deeply(\@got, $expected, $name);
        note explain \@got;
        # note $app->content;
    }

    if (my $complete = $data->{complete}) {
        $complete->($data, $app);
    }
}

sub _scrape_id_via_link {
    my ($app, $selector, $param_name) = @_;
    my @links = $app->wq_find('.mt-table tbody tr ' . $selector) || ();
    return map { ($_ =~ qr{\b$param_name=(\d+)})[0] } map { $_->attr('href') } @links;
}

sub _scrape_name {
    my ($app, $selector) = @_;
    my @links = $app->wq_find('.mt-table tbody tr ' . $selector) || ();
    return map { $_->text } @links;
}

1;
