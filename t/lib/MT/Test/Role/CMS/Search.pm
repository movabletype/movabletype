package MT::Test::Role::CMS::Search;

use Role::Tiny;
use Test::More;

requires qw/wq_find/;

sub tabs {
    my $self = shift;
    my @tabs;
    $self->wq_find('ul#search-tabs-list li a')->each(sub {
        my $elem = $_;
        my $tab  = $elem->attr('data-mt-object-type');
        push @tabs, $tab;
    });
    @tabs;
}

sub current_tab {
    my $self = shift;
    $self->wq_find('ul#search-tabs-list li a.active')->attr('data-mt-object-type');
}

sub tab_exists {
    my ($self, $type_name) = @_;
    my $tab = $self->wq_find(qq{ul#search-tabs-list li a[data-mt-object-type=$type_name]});
    return $tab->size > 0;
}

sub change_tab {
    my ($self, $type_name) = @_;
    my $form = $self->form('search_form') or return note "Failed to change tab to $type_name";
    $self->tab_exists($type_name) or return note "Failed to change tab to $type_name";
    my $type     = $form->find_input('_type');
    my $old_type = $type->value // '';
    $type->readonly(0);
    $type->value($type_name);
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

# This should be implemented in HTML::Form?
sub _change_checkbox {
    my ($checkbox, $on) = @_;
    my $menu = $on ? 1 : 0;
    $checkbox->{current} = $menu;
    $checkbox->{menu}[$menu]{seen}++;
}

sub search {
    my ($self, $value, $opts) = @_;
    my $form = $self->form('search_form') or return note "Failed to find form";
    $form->value('search', $value);
    my $do_search = $form->find_input('do_search');
    $do_search->readonly(0);
    $do_search->value(1);
    $self->apply_opts($form, $opts) if $opts;
    $self->post_ok($form->click);
}

sub replace {
    my ($self, $new_value, $target, $opts) = @_;
    my $form = $self->form('search_form') or return note "Failed to find form";
    $form->value('replace', $new_value);
    my $do_replace = $form->find_input('do_replace');
    $do_replace->readonly(0);
    $do_replace->value(1);
    my $replace_ids = $form->find_input('replace_ids');
    $replace_ids->readonly(0);
    $replace_ids->value(join(',', @$target));
    $self->apply_opts($form, $opts) if $opts;
    $self->post_ok($form->click);
}

sub apply_opts {
    my ($self, $form, $opts) = @_;
    for my $key (%$opts) {
        my @input = $form->find_input($key) or next;
        $_->disabled('') for @input;
        if ($input[0]->type eq 'checkbox') {
            if (ref($opts->{$key}) eq 'ARRAY') {
                my %flags = map { $_ => 1 } @{ $opts->{$key} };
                _change_checkbox($_, $_->value && $flags{ $_->value }) for @input;
            } else {
                _change_checkbox($input[0], $opts->{$key});
            }
        } else {
            $input[0]->value($opts->{$key});
        }
    }
}

sub result_count {
    my $self    = shift;
    my $text    = $self->wq_find('#result-count')->text;
    my ($count) = $text =~ /(\d+)/;
    $count;
}

sub found {
    my $self = shift;
    my $type = $self->current_tab or return;
    $self->wq_find("form#${type}-listing-form table tbody tr:not(.preview-data)");
}

sub found_ids {
    my $self = shift;
    my @ids;
    my $found = $self->found or return [];
    $found->each(sub {
        my ($i, $row) = @_;
        push @ids, $row->find('input[name=id]')->attr('value');
    });
    return \@ids;
}

my %TitleContainerSelectors = (
    content_data => 'td.id strong',
    template     => 'td:nth-of-type(2) a',
    entry        => 'td.title strong',
    asset        => 'td:nth-of-type(3) a',
    blog         => 'td:nth-of-type(2) a',
    website      => 'td:nth-of-type(2) a',
);

sub found_titles {
    my $self = shift;
    my @titles;
    my $type     = $self->current_tab or return [];
    my $selector = $TitleContainerSelectors{$type};
    my $found    = $self->found or return [];
    $found->each(sub {
        my ($i, $row) = @_;
        my $text = $row->find($selector)->text;
        $text =~ s{^\s+|\s+$}{}g;
        push @titles, $text;
    });
    return \@titles;
}

1;
