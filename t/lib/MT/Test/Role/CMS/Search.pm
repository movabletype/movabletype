package MT::Test::Role::CMS::Search;

use Role::Tiny;
use Test::More;

requires qw/wq_find/;

my %ScrapeId = (
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
);

my %ScrapeName = (
    template => sub { _scrape_name($_[0], 'td:nth-of-type(2) a') },
    entry    => sub { _scrape_name($_[0], 'td:nth-of-type(3) strong a') },
    asset    => sub { _scrape_name($_[0], 'td:nth-of-type(3) a') },
    blog     => sub { _scrape_name($_[0], 'td:nth-of-type(2) a') },
    website  => sub { _scrape_name($_[0], 'td:nth-of-type(2) a') },
);

sub _scrape_id_via_link {
    my ($self, $selector, $param_name) = @_;
    my @links = $self->wq_find('.mt-table tbody tr ' . $selector) || ();
    return map { ($_ =~ qr{\b$param_name=(\d+)})[0] } map { $_->attr('href') } @links;
}

sub _scrape_name {
    my ($self, $selector) = @_;
    my @links = $self->wq_find('.mt-table tbody tr ' . $selector) || ();
    return map { $_->text } @links;
}

sub tabs {
    my $self = shift;
    my @tabs;
    $self->wq_find('ul#search-tabs-list li a')->each(sub {
        my $elem = $_;
        my $tab = $elem->attr('data-mt-object-type');
        push @tabs, $tab
    });
    @tabs
}

sub current_tab {
    my $self = shift;
    $self->wq_find('ul#search-tabs-list li a.active')->attr('data-mt-object-type');
}

sub change_tab {
    my ($self, $tab) = @_;
    my $form = $self->form('search_form') or return note "Failed to change tab to $tab";;
    my $type = $form->find_input('_type');
    my $old_type = $type->value // '';
    $type->readonly(0);
    $type->value($tab);
    if ($type ne $old_type) {
        if (my $org = $form->find_input('orig_search')) {
            my $value = $org->value;
            if (defined $value && $value ne '') {
                my $do_search = $form->find_input('do_search');
                $do_search->readonly(0);
                $do_search->value(1);
            }
        }
    }
    $self->post_ok($form->click);
}

sub search {
    my ($self, $value, $opts) = @_;
    my $form = $self->form('search_form') or return note "Failed to find form";
    $form->value('search', $value);
    my $do_search = $form->find_input('do_search');
    $do_search->readonly(0);
    $do_search->value(1);
    if ($opts) {
        for my $key (%$opts) {
            my $input = $form->find_input($key) or next;
            if ($input->type eq 'checkbox') {
                if ($opts->{$key}) {
                    $input->check;
                } else {
                    $input->check(undef);
                }
            } else {
                $input->value($opts->{$key});
            }
        }
    }
    $self->post_ok($form->click);
}

sub result_count {
    my $self = shift;
    my $text = $self->wq_find('#result-count')->text;
    my ($count) = $text =~ /(\d+)/;
    $count;
}

sub found {
    my $self = shift;
    my $type = $self->current_tab;
    $self->wq_find("form#${type}-listing-form table tbody tr");
}

sub found_ids {
    my $self = shift;
    my @ids;
    $self->found->each(sub {
        my ($i, $row) = @_;
        push @ids, $row->find('input[name=id]')->attr('value');
    });
    return \@ids;
}

sub found_titles {
    my $self = shift;
    my @titles;
    $self->found->each(sub {
        my ($i, $row) = @_;
        push @titles, $row->find('td.title strong')->text;
    });
    return \@titles;
}

1;
