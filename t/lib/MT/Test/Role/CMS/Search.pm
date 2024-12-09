package MT::Test::Role::CMS::Search;

use Role::Tiny;
use Test::More;

requires qw/wq_find/;

around request => sub {
    my $orig = shift;
    my $self = shift;
    $self->{_searchform} = {};
    $orig->($self, @_);
};

sub find_searchform {
    my ($self, $name) = @_;
    my $forms = $self->{_searchform};
    my $id = $self->{res}. ":$name";
    unless ($forms->{$id}) {
        $forms->{$id} ||= $self->form($name) || return note "Failed to find form";
    }
    return $forms->{$id};
}

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
    my $form = $self->find_searchform('search_form') or return;
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
    my $limit = $form->find_input('limit');
    $limit->readonly(0);
    $limit->value('');
    $self->post_ok($form->click);
}

sub change_content_type {
    my ($self, $ct_id) = @_;
    return if $self->current_tab ne 'content_data';
    my $form      = $self->find_searchform('search_form') or return;
    my $ct_select = $form->find_input('content_type_id')  or return note 'Failed to find content type selector';
    $ct_select->value($ct_id);

    my @input = $form->find_input('search_cols');
    for my $elem (@input) {
        my $val             = _checkbox_attr_value($elem);
        my $checkbox        = $self->wq_find(qq{#search_form input[name="search_cols"][value="$val"]});
        my $li              = $checkbox->parent->parent;
        my $ct_cf_belogs_to = $li->attr('data-mt-content-type');
        $elem->disabled($ct_cf_belogs_to && $ct_cf_belogs_to == $ct_id ? '' : 'disabled');
    }
}

sub have_more_link_exists {
    $_[0]->wq_find('#have-more-count')->size ? 1 : 0;
}

sub search {
    my ($self, $value, $opts) = @_;
    my $form = $self->find_searchform('search_form') or return;
    $form->value('search', $value);
    my $do_search = $form->find_input('do_search');
    $do_search->readonly(0);
    $do_search->value(1);
    if ($opts->{limit} && $opts->{limit} eq 'all' && $self->have_more_link_exists) {
        $form->find_input('limit')->readonly(0);
    }
    $self->apply_opts($form, $opts) if $opts;
    $self->post_ok($form->click);
}

sub replace {
    my ($self, $new_value, $target, $opts) = @_;
    my $form = $self->find_searchform('search_form') or return;
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

sub dialog_grant_role_search {
    my ($self, $value, $opts) = @_;
    my $form   = $self->find_searchform('grant') or return;
    my $params = { search => $value, _type => 'user' };

    for my $key (keys %$opts) {
        next unless exists $params->{$key};
        $params->{$key} = $opts->{$key};
    }

    $self->post_ok({
        %$params,
        __mode      => (scalar $self->{cgi}->param('__mode')),
        magic_token => (scalar $self->{cgi}->param('magic_token')),
        return_args => (scalar $self->{cgi}->param('return_args')),
        blog_id     => (scalar $self->{cgi}->param('blog_id')),
        type        => (scalar $self->{cgi}->param('type')),
        dialog      => 1,
        json        => 1,
    });
}

# This should be implemented in HTML::Form?
sub _change_checkbox {
    my ($checkbox, $on) = @_;
    my $menu = $on ? 1 : 0;
    $checkbox->{current} = $menu;
    $checkbox->{menu}[$menu]{seen}++;
}

sub _checkbox_attr_value {
    my ($checkbox) = @_;
    $checkbox->{menu}[1]->{value};
}

sub apply_opts {
    my ($self, $form, $opts) = @_;
    for my $key (%$opts) {
        my @input = $form->find_input($key) or next;
        if ($input[0]->type eq 'checkbox') {
            if (ref($opts->{$key}) eq 'ARRAY') {
                my %flags = map { $_ => 1 } @{ $opts->{$key} };
                for my $elem (@input) {
                    my $val = _checkbox_attr_value($elem);
                    _change_checkbox($elem, $val && $flags{$val});
                }
            } else {
                _change_checkbox($input[0], $opts->{$key});
            }
        } else {
            next unless _validate($self, $key, $opts);
            $input[0]->value($opts->{$key});
        }
    }
}

sub _validate {
    my ($self, $key, $opts) = @_;

    if ($key eq 'date_time_field_id') {
        my $new_val = $opts->{$key};
        if ($new_val > 0) {
            my $form            = $self->find_searchform('search_form') or return;
            my $ct_id           = $form->find_input('content_type_id')->value;
            my $option          = $self->wq_find(qq{#search_form select[name="date_time_field_id"] option[value="$new_val"]});
            my $ct_cf_belogs_to = $option->attr('data-mt-content-type');
            if ($ct_cf_belogs_to != $ct_id) {
                note "Warning: cf=$new_val belongs to ct=$ct_cf_belogs_to but ct=$ct_id given: continue";
            }
        }
    }

    return 1;
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

my $TitleContainerSelectors = {
    admin2023 => {
        content_data => 'td.id a.label',
        template     => 'td:nth-of-type(2) a',
        entry        => 'td.title > span.title',
        asset        => 'td:nth-of-type(3) a',
        blog         => 'td:nth-of-type(2) a',
        website      => 'td:nth-of-type(2) a',
    },
    mt7 => {
        content_data => 'td.id strong',
        template     => 'td:nth-of-type(2) a',
        entry        => 'td.title strong',
        asset        => 'td:nth-of-type(3) a',
        blog         => 'td:nth-of-type(2) a',
        website      => 'td:nth-of-type(2) a',
    },
};

sub found_titles {
    my $self = shift;
    my @titles;
    my $type     = $self->current_tab or return [];
    my $selector = $TitleContainerSelectors->{MT->config('AdminThemeId') || 'mt7'}{$type};
    my $found    = $self->found or return [];
    $found->each(sub {
        my ($i, $row) = @_;
        my $text = $row->find($selector)->text // '';
        $text =~ s{^\s+|\s+$}{}g;
        push @titles, $text;
    });
    return \@titles;
}

sub found_site_ids {
    my $self = shift;
    my @site_ids;
    my $found    = $self->found or return [];
    $found->each(sub {
        my ($i, $row) = @_;
        my $anchor = $row->find('td.blog a') || return;
        my $url = $anchor->attr('href') || return;
        $url =~ /\bblog_id=(\d+)/ || return;
        push @site_ids, $1;
    });
    return \@site_ids;
}

sub found_highlighted_count {
    my $self = shift;
    my @titles;
    my $type  = $self->current_tab or return [];
    return $self->wq_find(qq!form#${type}-listing-form table tbody [data-search-highlight="1"]!)->size;
}

1;
