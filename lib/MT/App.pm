# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::App;

use strict;
use warnings;
use base qw( MT );

use File::Spec;
use MT::Request;
use MT::Util qw( encode_html offset_time_list decode_html encode_url
    is_valid_email is_url escape_unicode extract_url_path);
use MT::I18N qw( wrap_text );

my $COOKIE_NAME = 'mt_user';
sub COMMENTER_COOKIE_NAME () {"mt_commenter"}
use vars qw( %Global_actions );

sub core_menus {
    return {};
}

sub core_methods {
    return {};
}

sub core_page_actions {
    return {};
}

sub core_list_actions {
    return {};
}

sub core_list_filters {
    {};
}

sub core_widgets {
    {};
}

sub core_blog_stats_tabs {
    {};
}

sub core_search_apis {
    {};
}

sub __massage_page_action {
    my ( $app, $action, $type ) = @_;
    return if exists $action->{__massaged};

    # my $plugin_sig = $action->{plugin};
    my $plugin = $action->{plugin};

    if ( my $link = $action->{link} ) {
        my $envelope = $plugin->envelope;
        $link .= '?' unless $link =~ m.\?.;
        my $page = $app->config->AdminCGIPath || $app->config->CGIPath;
        $page .= '/' unless $page =~ m!/$!;
        $page .= $envelope . '/' if $envelope;
        $page .= $link;
        my $has_params = ( $page =~ m/\?/ )
            && ( $page !~ m!(&|;|\?)$! );
        $action->{page}            = $page;
        $action->{page_has_params} = $has_params;
    }
    elsif ( $action->{mode} || $action->{dialog} ) {
        if ( $app->user->is_superuser ) {
            $action->{allowed} = 1;
        }
        else {
            my $perms = $app->permissions;
            if ( my $p = $action->{permission} ) {
                my @p = split /,/, $p;
                foreach my $p (@p) {
                    my $perm = 'can_' . $p;
                    $action->{allowed} = 1, last
                        if ( $perms && $perms->$perm() );
                }
            }
        }
        $action->{link} = $app->uri(
            mode =>
                ( $action->{mode} ? $action->{mode} : $action->{dialog} ),
            args => $action->{args}
        );
    }
    else {
        $action->{page} = $app->uri(
            mode => 'page_action',
            args => { action_name => $action->{key}, '_type' => $type }
        );
        $action->{page_has_params} = 1;
    }
    $action->{core} = $plugin->isa('MT::Plugin') ? 0 : 1;
    $action->{order} = -10000 + ( $action->{order} || 0 ) if $action->{core};
    $action->{label} = $action->{link_text} if exists $action->{link_text};
    if ( $plugin && !ref( $action->{label} ) ) {
        my $label = $action->{label};
        $action->{label} = sub { $plugin->translate($label) };
    }

    $action->{__massaged} = 1;
}

sub filter_conditional_list {
    my ( $app, $list, @param ) = @_;

    # $list may either be an array of things or a hashref of things

    my $perms = $app->permissions;
    my $user  = $app->user;
    my $admin = ( $user && $user->is_superuser() )
        || ( $perms && $perms->blog_id && $perms->has('administer_site') );
    my $system_perms;
    $system_perms = $user->permissions(0) unless $perms && $perms->blog_id;

    my $test = sub {
        my ($item) = @_;
        if ( my $action = $item->{permit_action} ) {
            if ( !$user->is_superuser ) {
                my $blog = $app->blog;
                my $blog_ids;
                push @$blog_ids, $blog->id
                    if $blog;

                my $include_all;
                if ( 'HASH' eq ref $action ) {
                    if ( $action->{system_action} ) {

             # Return true if user has system level privilege for this action.
                        return 1
                            if $system_perms
                            && $system_perms->can_do(
                            $action->{system_action} );
                    }

                    $include_all = $action->{include_all} || 0;
                    $action = $action->{permit_action};
                }
                if ( $include_all and $blog and !$blog->is_blog ) {
                    my $blogs = $blog->blogs;
                    my @map = map { $_->id } @$blogs;
                    push @$blog_ids, map { $_->id } @{ $blog->blogs };
                }

                my $terms = {
                    author_id   => $app->user->id,
                    permissions => \'is not null',
                    (   $blog_ids
                        ? ( blog_id => $blog_ids )
                        : ( blog_id => { not => 0 } )
                    ),
                };

                my $count = MT->model('permission')->count($terms);
                return 0 unless $count;

                my $iter = MT->model('permission')->load_iter($terms);

                my @actions = split /,/, $action;
                my $cond = 0;
                while ( my $p = $iter->() ) {
                    my $allowed;
                    foreach my $act (@actions) {
                        $allowed = 1
                            if $p->can_do($act);
                    }
                    $cond++ if $allowed;
                }

                return 0 if !$cond or ( $include_all and $cond != $count );
            }
        }
        else {
            return 0
                if !$system_perms
                && $item->{system_permission}
                && !$item->{permission};

            if ( $system_perms && ( my $sp = $item->{system_permission} ) ) {
                my $allowed = 0;
                my @sp = split /,/, $sp;
                foreach my $sp_ (@sp) {
                    $sp_ =~ s/'(.+)'/$1/;
                    my $perm = 'can_' . $sp_;
                    $allowed = 1, last
                        if $admin
                        || ( $system_perms
                        && $system_perms->can($perm)
                        && $system_perms->$perm() );
                }
                return 0 unless $allowed;
            }
            else {
                if ( my $p = $item->{permission} ) {
                    my $allowed = 0;
                    my @p = split /,/, $p;
                    foreach my $p_ (@p) {
                        my $perm = 'can_' . $p_;
                        $allowed = 1, last
                            if $admin
                            || ( $perms
                            && $perms->can($perm)
                            && $perms->$perm() );
                    }
                    return 0 unless $allowed;
                }
            }
        }
        if ( my $cond = $item->{condition} ) {
            if ( !ref($cond) ) {
                $cond = $item->{condition} = $app->handler_to_coderef($cond);
            }
            return 0 unless $cond->(@param);
        }
        return 1;
    };

    if ( ref $list eq 'ARRAY' ) {
        my @list;
        if (@$list) {

            # translate the link text here...
            foreach my $item (@$list) {
                push @list, $item if $test->($item);
            }
        }
        return \@list;
    }
    elsif ( ref $list eq 'HASH' ) {
        my %list;
        if (%$list) {

            # translate the link text here...
            foreach my $item ( keys %$list ) {
                $list{$item} = $list->{$item}
                    if $test->( $list->{$item} );
            }
        }
        return \%list;
    }
    return undef;
}

sub page_actions {
    my $app = shift;
    my ( $type, @param ) = @_;
    my $actions = $app->registry( "page_actions", $type ) or return;
    foreach my $a ( keys %$actions ) {
        $actions->{$a}{key} = $a;
        __massage_page_action( $app, $actions->{$a}, $type );
    }
    my @actions = values %$actions;
    $actions = $app->filter_conditional_list( \@actions, @param );
    no warnings;
    @$actions = sort { $a->{order} <=> $b->{order} } @$actions;
    return $actions;
}

sub list_actions {
    my $app = shift;
    my ( $type, @param ) = @_;

    $type = 'content_data' if $type =~ /^content_data\.content_data_[0-9]+$/;

    my $actions = $app->registry( "list_actions", $type ) or return;
    my @actions;
    foreach my $a ( keys %$actions ) {
        $actions->{$a}{key}  = $a;
        $actions->{$a}{core} = 1
            unless UNIVERSAL::isa( $actions->{$a}{plugin}, 'MT::Plugin' );

        if ( !$actions->{$a}{js_message} ) {
            if ( exists $actions->{$a}{js_message_handler} ) {
                my $code = $app->handler_to_coderef(
                    $actions->{$a}{js_message_handler} );
                $actions->{$a}{js_message} = $code->()
                    if 'CODE' eq ref($code);
            }
            else {
                $actions->{$a}{js_message} = $actions->{$a}{label};
            }
        }

        $actions->{$a}{action_mode} = $actions->{$a}{mode}
            if $actions->{$a}{mode};

        if ( exists $actions->{$a}{continue_prompt_handler} ) {
            my $code = $app->handler_to_coderef(
                $actions->{$a}{continue_prompt_handler} );
            $actions->{$a}{continue_prompt} = $code->()
                if 'CODE' eq ref($code);
        }
        push @actions, $actions->{$a};
    }
    $actions = $app->filter_conditional_list( \@actions, @param );
    no warnings;
    @$actions = sort { $a->{order} <=> $b->{order} } @$actions;
    return $actions;
}

sub content_actions {
    my $app = shift;
    my ( $type, @param ) = @_;
    my $actions = $app->registry( "content_actions", $type ) or return;
    my @actions;
    for my $key ( keys %$actions ) {
        my $action = $actions->{$key};
        $action->{key} = $key;
        my %args;
        if ( 'CODE' eq ref $action->{args} ) {
            my $code = $action->{args};
            %args = %{ $code->() || {} };
        }
        else {
            %args = %{ $action->{args} || {} };
        }
        if ( $type =~ m/(.*)\.(.*)/ ) {
            $args{_type} = $1;
            $args{type}  = $2;
        }
        else {
            $args{_type} ||= $type;
        }
        $args{return_args} = $app->make_return_args if $action->{return_args};
        $action->{url} = $app->uri(
            mode => $action->{mode},
            args => {
                %args,
                blog_id => ( $app->blog ? $app->blog->id : 0 ),
                magic_token => $app->current_magic,
            },
        ) if $action->{mode};
        $args{id} = $action->{id}
            if $action->{id};
        push @actions, $action;
    }
    $actions = $app->filter_conditional_list( \@actions, @param );
    no warnings;
    @$actions = sort { $a->{order} <=> $b->{order} or $a->{key} cmp $b->{key} } @$actions;
    return $actions;
}

sub list_filters {
    my $app = shift;
    my ( $type, @param ) = @_;

    my $filters = $app->registry( "list_filters", $type ) or return;
    my @filters;
    foreach my $a ( keys %$filters ) {
        $filters->{$a}{key} = $a;
        next if $a =~ m/^_/;    # not shown...
        push @filters, $filters->{$a};
    }
    $filters = $app->filter_conditional_list( \@filters, @param );
    no warnings;
    @$filters = sort { $a->{order} <=> $b->{order} } @$filters;
    return $filters;
}

sub search_apis {
    my $app = shift;
    my ( $view, @param ) = @_;

    my $apis = $app->registry("search_apis") or return;
    my @apis;
    foreach my $a ( keys %$apis ) {
        $apis->{$a} = $app->registry( "search_apis", $a )
            unless ref $apis->{$a};
        next if $apis->{$a}->{view} && $apis->{$a}->{view} ne $view;
        $apis->{$a}{key}  = $a;
        $apis->{$a}{core} = 1
            unless UNIVERSAL::isa( $apis->{$a}{plugin}, 'MT::Plugin' );
        push @apis, $apis->{$a};
    }
    $apis = $app->filter_conditional_list( \@apis, @param );
    no warnings;
    @$apis = sort { $a->{order} <=> $b->{order} } @$apis;
    return $apis;
}

sub listing {
    my $app = shift;
    my ($opt) = @_;

    my $type = $opt->{type} || $opt->{Type} || $app->param('_type');
    my $tmpl
        = $opt->{template}
        || $opt->{Template}
        || 'list_' . $type . '.tmpl';
    my $iter_method = $opt->{iterator} || $opt->{Iterator} || 'load_iter';
    my $param       = $opt->{params}   || $opt->{Params}   || {};
    $param->{listing_screen} = 1;
    my $add_pseudo_new_user;
    $add_pseudo_new_user = delete $param->{pseudo_new_user}
        if exists $param->{pseudo_new_user};
    my $hasher  = $opt->{code}    || $opt->{Code};
    my $terms   = $opt->{terms}   || $opt->{Terms} || {};
    my $args    = $opt->{args}    || $opt->{Args} || {};
    my $no_html = $opt->{no_html} || $opt->{NoHTML};
    my $json    = $opt->{json}    || $app->param('json');
    my $search = $app->param('search');
    my $no_limit
        = exists( $opt->{no_limit} )
        ? $opt->{no_limit}
        : ( $search ? 1 : 0 );
    my $pre_build;
    $pre_build = $opt->{pre_build} if ref( $opt->{pre_build} ) eq 'CODE';
    $param->{json} = 1 if $json;

    my $class = $app->model($type) or return;
    my $list_pref;
    $list_pref = $app->list_pref($type) if $app->can('list_pref');
    $param->{$_} = $list_pref->{$_} for keys %$list_pref;
    my $limit = $args->{limit} || $list_pref->{rows};
    $limit =~ s/\D//g;
    my $offset = $app->param('offset') || 0;
    $offset =~ s/\D//g;
    my $d = $app->param('d') || 0;
    $d =~ s/\D//g;
    $args->{offset}
        = $d
        ? ( $d < $offset ? $offset - $d : 0 )
        : $offset
        if $offset && !$no_limit;
    $args->{limit} = $limit + 1 unless $no_limit;
    $param->{limit_none} = 1 if $no_limit;

    # handle search parameter
    if ($search) {
        $app->param( 'do_search', 1 );
        if ( $app->can('do_search_replace') ) {
            my $search_param = $app->do_search_replace(
                { terms => $terms, args => $args } );
            if ($hasher) {
                my $data = $search_param->{object_loop};
                if ( $data && @$data ) {
                    foreach my $row (@$data) {
                        my $obj = $row->{object};
                        $row = $obj->get_values();
                        $hasher->( $obj, $row );
                    }
                }
            }
            $param->{$_} = $search_param->{$_} for keys %$search_param;
            $no_limit = $param->{limit_none} = 1;
        }
    }
    else {

        # handle filter options
        my $filter_key = $app->param('filter_key');
        my $filter_col = $app->param('filter');
        my $filter_val = $app->param('filter_val');
        if ( !$filter_key && !$filter_col ) {
            $filter_key = 'default';
        }
        if ($filter_key) {

            # set filter based on type
            my $filter = $app->registry( "list_filters", $type, $filter_key );
            if ($filter) {
                if ( my $code = $filter->{code} || $filter->{handler} ) {
                    if ( ref($code) ne 'CODE' ) {
                        $code = $filter->{code}
                            = $app->handler_to_coderef($code);
                    }
                    if ( ref($code) eq 'CODE' ) {
                        $code->( $terms, $args );
                        $param->{filter}       = 1;
                        $param->{filter_key}   = $filter_key;
                        $param->{filter_label} = $filter->{label};
                    }
                }
            }
        }
        if ( $filter_col && $filter_val ) {
            if ((      ( $filter_col eq 'normalizedtag' )
                    || ( $filter_col eq 'exacttag' )
                )
                && ( $class->isa('MT::Taggable') )
                )
            {
                my $normalize = ( $filter_col eq 'normalizedtag' );
                my $tag_class = $app->model('tag');
                my $ot_class  = $app->model('objecttag');
                my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
                my @filter_vals
                    = $tag_class->split( $tag_delim, $filter_val );
                my @filter_tags = @filter_vals;
                if ($normalize) {
                    push @filter_tags, MT::Tag->normalize($_)
                        foreach @filter_vals;
                }
                my @tags = $tag_class->load(
                    { name   => [@filter_tags] },
                    { binary => { name => 1 } }
                );
                my @tag_ids;
                foreach (@tags) {
                    push @tag_ids, $_->id;
                    if ($normalize) {
                        my @more = $tag_class->load(
                            { n8d_id => $_->n8d_id ? $_->n8d_id : $_->id } );
                        push @tag_ids, $_->id foreach @more;
                    }
                }
                @tag_ids = (0) unless @tags;
                $args->{'join'} = $ot_class->join_on(
                    'object_id',
                    {   tag_id            => \@tag_ids,
                        object_datasource => $class->datasource
                    },
                    { unique => 1 }
                );
            }
            elsif ( !exists( $terms->{$filter_col} ) ) {
                if ( $class->is_meta_column($filter_col) ) {
                    my @result
                        = $class->search_by_meta( $filter_col, $filter_val,
                        {}, $args );
                    $iter_method = sub {
                        return shift @result;
                    };
                }
                elsif ( $class->has_column($filter_col) ) {
                    $terms->{$filter_col} = $filter_val;
                }
            }
            $param->{filter}     = $filter_col;
            $param->{filter_val} = $filter_val;
            my $url_val = encode_url($filter_val);
            $param->{filter_args} = "&filter=$filter_col&filter_val=$url_val";
            $param->{"filter_col_$filter_col"} = 1;
        }

        # automagic blog scoping
        my $blog = $app->blog;
        if ($blog) {

            # In blog context, class defines blog_id as a column,
            # so restrict listing to active blog:
            if ( $class->has_column('blog_id') ) {
                $terms->{blog_id} ||= $blog->id;
            }
        }

        $args->{sort} = 'id'
            unless exists $args->{sort};    # must always provide sort column

        $app->run_callbacks( 'app_pre_listing_' . $app->mode,
            $app, $terms, $args, $param, \$hasher );

        my $iter
            = ref($iter_method) eq 'CODE'
            ? $iter_method
            : ( $class->$iter_method( $terms, $args )
                or return $app->error( $class->errstr ) );
        my @objs;
        while ( my $obj = $iter->() ) {
            push @objs, $obj;
            last if ( scalar @objs == $limit ) && ( !$no_limit );
        }

        if (@objs && $objs[0]->has_meta) {
            require MT::Meta::Proxy;
            MT::Meta::Proxy->bulk_load_meta_objects(\@objs);
        }

        my @data;
        for my $obj (@objs) {
            my $row = $obj->get_values();
            $hasher->( $obj, $row ) if $hasher;

            if ( $obj->errstr ) {
                return $app->error( $obj->errstr );
            }

            #$app->run_callbacks( 'app_listing_'.$app->mode,
            #                     $app, $obj, $row );
            push @data, $row;
        }

        $param->{object_loop} = \@data;

        # handle pagination
        $limit  += 0;
        $offset += 0;
        my $pager = {
            offset        => $offset,
            limit         => $limit,
            rows          => scalar @data,
            d             => $d,
            listTotal     => $class->count( $terms, $args ) + $d || 0,
            chronological => $param->{list_noncron} ? 0 : 1,
            return_args   => encode_html( $app->make_return_args ),
            method        => $app->request_method,
        };
        $param->{object_type} ||= $type;
        $param->{pager_json} = $json ? $pager : MT::Util::to_json($pager);

  # pager.rows (number of rows shown)
  # pager.listTotal (total number of rows in datasource)
  # pager.offset (offset currently used)
  # pager.chronological (boolean, whether the listing is chronological or not)
    }

    my $plural = $type;

    # entry -> entries; user -> users
    if ( $class->can('class_label') ) {
        $param->{object_label} = $class->class_label;
    }
    if ( $class->can('class_label_plural') ) {
        $param->{object_label_plural} = $class->class_label_plural;
    }

    if ( $app->user->is_superuser() ) {
        $param->{is_superuser} = 1;
    }

    $param->{limit} = $limit;
    if ($json) {
        $pre_build->($param) if $pre_build;
        my $html = $app->build_page( $tmpl, $param );
        my $data = {
            html  => $html,
            pager => $param->{pager_json},
        };
        $app->send_http_header("text/javascript+json");
        $app->print_encode( MT::Util::to_json($data) );
        $app->{no_print_body} = 1;
    }
    else {
        $app->load_list_actions( $type, $param );
        my $count;
        $count = $pre_build->($param) if $pre_build;
        if ($count) {
            my $rows  = scalar @{ $param->{object_loop} };
            my $pager = {
                offset        => $offset,
                limit         => $limit,
                rows          => $rows,
                d             => $count,
                listTotal     => $class->count( $terms, $args ) + $count || 0,
                chronological => $param->{list_noncron} ? 0 : 1,
                return_args   => encode_html( $app->make_return_args ),
                method        => $app->request_method,
            };
            $param->{pager_json} = MT::Util::to_json($pager);
        }
        if ($no_html) {
            return $param;
        }
        if ( ref $tmpl ) {
            $tmpl->param($param);
            return $tmpl;
        }
        else {
            return $app->load_tmpl( $tmpl, $param );
        }
    }
}

sub multi_listing {
    my $app = shift;
    my ($opt) = @_;

    my $types = $opt->{type} || $opt->{Type};
    if ( ref($types) ne 'ARRAY' ) {
        return $app->listing(@_);
    }
    my $tmpl
        = $opt->{template}
        || $opt->{Template}
        || 'list_' . $types->[0] . '.tmpl';

    my $app_json        = $app->param('json');
    my $app_search_type = $app->param('search_type');

    my $no_html = $opt->{no_html} || $opt->{NoHTML};
    my $search = $app->param('search');
    my $no_limit
        = exists( $opt->{no_limit} )
        ? $opt->{no_limit}
        : ( $search ? 1 : 0 );
    my $json   = $opt->{json}          || $app->param('json');
    my $param  = $opt->{params}        || $opt->{Params} || {};
    my $offset = $app->param('offset') || 0;
    $offset =~ s/\D//g;
    my $sort = exists $opt->{args}->{sort} ? $opt->{args}->{sort} : 'id';

    if ( ref($types) ne 'ARRAY' ) {
        return $app->listing(@_);
    }
    my $all_object_loop = [];
    my $page_limit = $app->param('limit') || 0;
    foreach my $type (@$types) {
        my $options = $opt;
        $options->{type} = $type;
        $options->{json} = 0;
        $app->param( 'json', 0 );
        $options->{no_html} = 1;
        $app->param( 'search_type', $type );
        $app->param( 'offset',      0 );

        $options->{code}
            = $opt->{"${type}_code"}
            || $opt->{"${type}_Code"}
            || $opt->{code}
            || $opt->{Code};
        $options->{terms}
            = $opt->{"${type}_terms"}
            || $opt->{"${type}_Terms"}
            || $opt->{terms}
            || $opt->{Terms};
        $options->{args}
            = $opt->{"${type}_args"}
            || $opt->{"${type}_Args"}
            || $opt->{args}
            || $opt->{Args};
        $options->{iterator}
            = $opt->{"${type}_iterator"}
            || $opt->{"${type}_Iterator"}
            || 'load_iter';

        my $list_pref;
        $list_pref = $app->list_pref($type) if $app->can('list_pref');
        my $type_limit = $opt->{args}->{limit} || $list_pref->{rows};
        $type_limit =~ s/\D//g;

        $options->{args}->{limit} = 9999;
        $app->param( 'limit', 9999 );
        $options->{args}->{no_limit} = 1;

        $app->listing($options);
        foreach my $object ( @{ $options->{params}->{object_loop} } ) {
            $object->{object_type} = $type;
            push( @$all_object_loop, $object );
        }

        $page_limit = $page_limit < $type_limit ? $type_limit : $page_limit;
        $options->{params}->{object_loop} = undef;
        $options->{args}->{limit}         = $page_limit;
    }
    @$all_object_loop
        = sort { $b->{$sort} cmp $a->{$sort} } @$all_object_loop;
    my @object_loop = @$all_object_loop;
    if ( !$no_limit ) {
        @object_loop = splice( @object_loop, $offset, $page_limit );
    }
    $param->{object_loop} = \@object_loop;

    $app->param( 'limit', $page_limit );

    # handle pagination
    my $args = $opt->{args}     || $opt->{Args};
    my $d    = $app->param('d') || 0;
    $d =~ s/\D//g;

    my $pager = {
        offset        => $offset,
        limit         => $page_limit,
        rows          => scalar @object_loop,
        d             => $d,
        listTotal     => scalar @$all_object_loop + $d || 0,
        chronological => $param->{list_noncron} ? 0 : 1,
        return_args   => encode_html( $app->make_return_args ),
        method        => $app->request_method,
    };
    $param->{pager_json} = $json ? $pager : MT::Util::to_json($pager);

    if ($json) {
        $app->param( 'json', $app_json );
        $param->{json}    = $json;
        $param->{no_html} = $no_html;
        $app->param( 'search_type', $app_search_type );
        $app->param( 'offset',      $offset );

        my $html = $app->build_page( $tmpl, $param );

        my $data = {
            html  => $html,
            pager => $pager,
        };

        $app->send_http_header("text/javascript+json");
        $app->print_encode( MT::Util::to_json($data) );
        $app->{no_print_body} = 1;
    }
}

sub parse_filtered_list_permission {
    my ($app, $maybe_action_list) = @_;

    my $inherit_blogs = 1;
    if ('HASH' eq ref $maybe_action_list) {
        $inherit_blogs = $maybe_action_list->{inherit} if defined $maybe_action_list->{inherit};
        $maybe_action_list = $maybe_action_list->{permit_action};
    }
    my @actions;
    if (ref $maybe_action_list eq 'CODE' || $maybe_action_list =~ m/^sub \{/ || $maybe_action_list =~ m/^\$/ ) {
        my $code = $maybe_action_list;
        $code = MT->handler_to_coderef($code);
        ($maybe_action_list, @actions) = $code->($app);     # may die here
    }

    if (ref $maybe_action_list eq 'ARRAY') {
        unshift @actions, @$maybe_action_list;
    } else {
        unshift @actions, split /\s*,\s*/, $maybe_action_list;
    }
    return (\@actions, $inherit_blogs);
}

sub json_result {
    my $app = shift;
    my ($result) = @_;
    $app->set_header( 'X-Content-Type-Options' => 'nosniff' );
    $app->send_http_header("application/json");
    $app->{no_print_body} = 1;
    $app->print_encode(
        MT::Util::to_json( { error => undef, result => $result } ) );
    return undef;
}

sub json_error {
    my $app = shift;
    my ( $error, $status ) = @_;
    $app->response_code($status)
        if defined $status;
    $app->set_header( 'X-Content-Type-Options' => 'nosniff' );
    $app->send_http_header("application/json");
    $app->{no_print_body} = 1;
    $app->print_encode( MT::Util::to_json( { error => $error } ) );
    return undef;
}

sub response_code {
    my $app = shift;
    $app->{response_code} = shift if @_;
    $app->{response_code};
}

sub response_message {
    my $app = shift;
    $app->{response_message} = shift if @_;
    $app->{response_message};
}

sub response_content_type {
    my $app = shift;
    $app->{response_content_type} = shift if @_;
    $app->{response_content_type};
}

sub response_content {
    my $app = shift;
    $app->{response_content} = shift if @_;
    $app->{response_content};
}

sub set_x_frame_options_header {
    my $app = shift;
    my $x_frame_options = $app->config->XFrameOptions || '';

    # If set as NONE MT should not output X-Frame-Options header.
    return if lc $x_frame_options eq 'none';

    # Use default value when invalid value is set.
    unless ( lc $x_frame_options eq 'deny'
        || lc $x_frame_options eq 'sameorigin'
        || $x_frame_options =~ /^allow-from\s+\S+/i )
    {
        $x_frame_options = $app->config->default('XFrameOptions');
    }

    $app->set_header( 'X-Frame-Options', $x_frame_options );
}

sub set_x_xss_protection_header {
    my $app = shift;

    my $xss_protection = $app->config->XXSSProtection;
    return unless $xss_protection;

    $app->set_header( 'X-XSS-Protection', $xss_protection );
}

sub set_referrer_policy {
    my $app = shift;

    my $policy = $app->config->ReferrerPolicy;
    return unless $policy;

    $app->set_header( 'Referrer-Policy', $policy );
}

sub send_http_header {
    my $app = shift;
    my ($type) = @_;
    $type ||= $app->{response_content_type} || 'text/html';
    if ( my $charset = $app->charset ) {
        $type .= "; charset=$charset"
            if $type =~ m!^text/|\+xml$|/json$!
            && $type !~ /\bcharset\b/;
    }
    if ( MT::Util::is_mod_perl1() ) {
        if ( $app->{response_message} ) {
            $app->{apache}->status_line(
                ( $app->response_code || 200 )
                . ( $app->{response_message}
                    ? ' ' . $app->{response_message}
                    : ''
                )
            );
        }
        else {
            $app->{apache}->status( $app->response_code || 200 );
        }
        $app->{apache}->send_http_header($type);
        if ( $MT::DebugMode & 128 ) {
            print "Status: "
                . ( $app->response_code || 200 )
                . (
                $app->{response_message}
                ? ' ' . $app->{response_message}
                : ''
                ) . "\n";
            print "Content-Type: $type\n\n";
        }
    }
    else {
        $app->{cgi_headers}{-status}
            = ( $app->response_code || 200 )
            . (
            $app->{response_message} ? ' ' . $app->{response_message} : '' );
        $app->{cgi_headers}{-type} = $type;
        $app->print( $app->{query}->header( %{ $app->{cgi_headers} } ) );
    }
}

sub print {
    my $app = shift;
    if ( MT::Util::is_mod_perl1() ) {
        $app->{apache}->print(@_);
    }
    else {
        CORE::print(@_);
    }
    if ( $MT::DebugMode & 128 ) {
        CORE::print STDERR @_;
    }
}

sub print_encode {
    my $app = shift;
    my $enc = $app->charset || 'UTF-8';
    my $restype = $app->{response_content_type} || '';
    if ($restype =~ m!/json$!) {
        $enc = 'UTF-8';
    }
    $app->print( Encode::encode( $enc, $_[0] ) );
}

sub handler ($$) {
    my $class = shift;
    my ($r) = @_;
    require Apache::Constants;
    if ( lc( $r->dir_config('Filter') || '' ) eq 'on' ) {
        $r = $r->filter_register;
    }
    my $config_file = $r->dir_config('MTConfig');
    my $mt_dir      = $r->dir_config('MTHome');
    my %params      = (
        Config       => $config_file,
        ApacheObject => $r,
        ( $mt_dir ? ( Directory => $mt_dir ) : () )
    );
    my $app = $class->new(%params)
        or die $class->errstr;

    MT->set_instance($app);
    $app->init_request(%params);

    my $cfg = $app->config;
    if ( my @extra = $r->dir_config('MTSetVar') ) {
        for my $d (@extra) {
            my ( $var, $val ) = $d =~ /^\s*(\S+)\s+(.+)$/;
            $cfg->set( $var, $val );
        }
    }

    $app->run;
    return Apache::Constants::OK();
}

sub init {
    my $app   = shift;
    my %param = @_;
    $app->{apache} = $param{ApacheObject} if exists $param{ApacheObject};

    # start tracing even prior to 'init'
    local $SIG{__WARN__} = sub { $app->trace( $_[0] ) };
    $app->SUPER::init(%param) or return;
    $app->{vtbl}                 = {};
    $app->{is_admin}             = 0;
    $app->{template_dir}         = 'cms';          #$app->id;
    $app->{user_class}           = 'MT::Author';
    $app->{plugin_template_path} = 'tmpl';
    $app->run_callbacks( 'init_app', $app, @_ );

    if ( $MT::DebugMode & 128 ) {
        MT->add_callback( 'pre_run', 1, $app, sub { $app->pre_run_debug } );
        MT->add_callback( 'take_down', 1, $app,
            sub { $app->post_run_debug } );
    }

    # Register restore callback to restore blog assciation of triggers
    MT->add_callback( 'restore', 10, $app,
        sub { MT->model('rebuild_trigger')->runner( 'post_restore', @_ ) } );

    $app->{vtbl} = $app->registry("methods");
    return $app;
}

sub pre_run_debug {
    my $app = shift;
    if ( $MT::DebugMode & 128 ) {
        print STDERR "=====START: $$===========================\n";
        print STDERR "Package: " . ref($app) . "\n";
        print STDERR "Session: " . $app->session->id . "\n"
            if $app->session;
        print STDERR "Request: " . $app->request_method . "\n";
        my @param = $app->multi_param;
        if (@param) {
            foreach my $key (@param) {
                my @val = $app->multi_param($key);
                print STDERR "\t" . $key . ": " . $_ . "\n" for @val;
            }
        }
        print STDERR "-----Response:\n";
    }
}

sub post_run_debug {
    if ( $MT::DebugMode & 128 ) {
        print STDERR "\n=====END: $$=============================\n";
    }
}

sub run_callbacks {
    my $app = shift;
    my ( $meth, @param ) = @_;
    $meth = ( ref($app) || $app ) . '::' . $meth unless $meth =~ m/::/;
    return $app->SUPER::run_callbacks( $meth, @param );
}

{
    my $callbacks_added;

    sub init_callbacks {
        my $app = shift;
        $app->SUPER::init_callbacks(@_);
        return if $callbacks_added;

        my $call_with_current_app = sub {
            my $method_name = shift;
            my $current_app = MT->instance;
            return unless $current_app->isa('MT::App');
            $current_app->$method_name;
        };
        MT->add_callback( 'post_save',   0, $app, \&_cb_mark_blog );
        MT->add_callback( 'post_remove', 0, $app, \&_cb_mark_blog );
        MT->add_callback( 'MT::Blog::post_remove', 0, $app,
            \&_cb_unmark_blog );
        MT->add_callback( 'MT::Config::post_save', 0, $app,
            sub { $call_with_current_app->('reboot') } );
        MT->add_callback( 'pre_build', 9, $app,
            sub { $call_with_current_app->('touch_blogs') } );
        $callbacks_added = 1;
    }
}

sub init_request {
    my $app   = shift;
    my %param = @_;

    return if $app->{init_request};

    if ($MT::DebugMode) {
        require Time::HiRes;
        $app->{start_request_time} = Time::HiRes::time();
    }

    if ( $app->{request_read_config} ) {
        $app->init_config( \%param ) or return;
        $app->{request_read_config} = 0;
    }

    # @req_vars: members of the app object which are request-specific
    # and are cleared at the beginning of each request.
    my @req_vars = qw(mode __path_info _blog redirect login_again
        no_print_body response_code response_content_type response_message
        author cgi_headers breadcrumbs goback cache_templates warning_trace
        cookies _errstr request_method requires_login __host );
    delete $app->{$_} foreach @req_vars;
    $app->user(undef);
    if ( MT::Util::is_mod_perl1() ) {
        require Apache::Request;
        $app->{apache} = $param{ApacheObject} || Apache->request;
        $app->{query} = Apache::Request->instance( $app->{apache},
            POST_MAX => $app->config->CGIMaxUpload );
    }
    else {
        if ( $param{CGIObject} ) {
            $app->{query} = $param{CGIObject};
            require CGI;
            $CGI::POST_MAX = $app->config->CGIMaxUpload;
        }
        else {
            if ( my $path_info = $ENV{PATH_INFO} ) {
                if ( $path_info =~ m/\.cgi$/ ) {

                    # some CGI environments (notably 'sbox') leaves PATH_INFO
                    # defined which interferes with CGI.pm determining the
                    # request url.
                    delete $ENV{PATH_INFO};
                }
            }
            require CGI;
            $CGI::POST_MAX = $app->config->CGIMaxUpload;
            $app->{query} = CGI->new( $app->{no_read_body} ? {} : () );
        }
    }
    $app->init_query();

    $app->{return_args} = $app->{query}->param('return_args');
    $app->cookies;

    ## Initialize the MT::Request singleton for this particular request.
    $app->request->reset();
    $app->request( 'App-Class', ref $app );

    $app->run_callbacks( ref($app) . '::init_request', $app, @_ );

    $app->{init_request} = 1;
}

sub init_query {
    my $app = shift;
    my $q   = $app->{query};

    # CGI.pm has this terrible flaw in that if a POST is in effect,
    # it totally ignores any query parameters.
    if ( $app->request_method eq 'POST' ) {
        if ( !MT::Util::is_mod_perl1() ) {
            my $query_string = $ENV{'QUERY_STRING'};
            $query_string ||= $ENV{'REDIRECT_QUERY_STRING'}
                if defined $ENV{'REDIRECT_QUERY_STRING'};
            if ( defined($query_string) and $query_string ne '' ) {
                $q->parse_params($query_string);
            }
        }
    }
}

{
    my $has_encode;

    sub validate_request_params {
        my $app = shift;
        my ($options) = @_;

        $has_encode = eval { require Encode; 1 } ? 1 : 0
            unless defined $has_encode;
        return 1 unless $has_encode;

        my $q = $app->param;

        # validate all parameter data matches the expected character set.
        my @p = $app->multi_param();

        # use specific charset if the application method forces it
        my $charset = $options->{charset} || $app->charset;
        require Encode;
        require MT::I18N::default;
        $charset = 'utf-8' if $charset =~ m/utf-?8/i;
        my $request_charset = $charset;
        if ( my $content_type = $q->content_type() ) {
            if ( $content_type =~ m/;\s*charset=([^\s;]+)\s*;?/i ) {
                $request_charset = lc $1;
                $request_charset =~ s/^\s+|\s+$//gs;
            }
        }
        my $transcode = $request_charset ne $charset ? 1 : 0;
        my %params;
        foreach my $p (@p) {
            if ( $p =~ m/[^\x20-\x7E]/ ) {

                # non-ASCII parameter name
                return $app->errtrans("Invalid request");
            }

            my @d = $app->multi_param($p);
            my @param;
            foreach my $d (@d) {
                if (   ( !defined $d )
                    || ( $d eq '' )
                    || ( $d !~ m/[^\x20-\x7E]/ ) )
                {
                    push @param, $d;
                    next;
                }
                $d
                    = MT::I18N::default->encode_text_encode( $d,
                    $request_charset, $charset )
                    if $transcode;
                unless ( UNIVERSAL::isa( $d, 'Fh' ) ) {
                    eval {
                        $d = Encode::decode( $charset, $d, 1 )
                            unless Encode::is_utf8($d);
                    };
                    return $app->errtrans(
                        "Problem with this request: corrupt character data for character set [_1]",
                        $charset
                    ) if $@;
                }
                push @param, $d;
            }
            if (@param) {
                if ( 1 == scalar(@param) ) {
                    $params{$p} = $param[0];
                }
                else {
                    $params{$p} = [@param];
                }
            }
        }
        while ( my ( $key, $val ) = each %params ) {
            if ( ref($val) && ( 'ARRAY' eq ref($val) ) ) {
                $app->multi_param( $key, @{ $params{$key} } );
            }
            else {
                $app->param( $key, $val );
            }
        }

        return 1;
    }
}

sub registry {
    my $app = shift;
    my $ar = $app->SUPER::registry( "applications", $app->id, @_ );
    my $gr;
    $gr = $app->SUPER::registry(@_) if @_;
    if ($ar) {
        MT::__merge_hash( $ar, $gr );
        return $ar;
    }
    return $gr;
}

sub _cb_unmark_blog {
    my ( $eh, $obj ) = @_;
    my $mt_req = MT->instance->request;
    if ( my $blogs_touched = $mt_req->stash('blogs_touched') ) {
        delete $blogs_touched->{ $obj->id };
        $mt_req->stash( 'blogs_touched', $blogs_touched );
    }
}

sub _cb_mark_blog {
    my ( $eh, $obj ) = @_;
    my $obj_type = ref $obj;

    if ( $obj_type eq 'MT::Author' ) {
        require MT::Touch;
        MT::Touch->touch( 0, 'author' );
        return;
    }

    return
        if ( $obj_type eq 'MT::Log'
        || $obj_type eq 'MT::Session'
        || $obj_type eq 'MT::Touch'
        || ( ( $obj_type ne 'MT::Blog' ) && !$obj->has_column('blog_id') ) );
    my $mt_req = MT->instance->request;
    my $blogs_touched = $mt_req->stash('blogs_touched') || {};

    # Issue MT::Touch touches for specific types we track
    my $type = $obj->datasource;
    if ( $obj->properties->{class_column} && $type ne 'asset' ) {
        $type = $obj->class_type;
    }
    if ( $type
        !~ m/^(entry|comment|page|folder|category|tbping|asset|author|template|content_data|content_type)$/
        )
    {
        undef $type;
    }

    if ( $obj_type eq 'MT::Blog' ) {
        delete $blogs_touched->{ $obj->id };
    }
    elsif ( $obj_type eq 'MT::ContentData' ) {
        if ( $obj->blog_id ) {
            my $th = $blogs_touched->{ $obj->blog_id } ||= {};
            if ( my $ct = $obj->content_type ) {
                $th->{ 'content_data_' . $ct->unique_id } = 1;
            }
        }
    }
    else {
        if ( $obj->blog_id ) {
            my $th = $blogs_touched->{ $obj->blog_id } ||= {};
            $th->{$type} = 1 if $type;
        }
    }
    $mt_req->stash( 'blogs_touched', $blogs_touched );
}

# Along with _cb_unmark_blog and _cb_mark_blog, this is an elaborate
# scheme to cause MT::Blog objects that are affected as a result of a
# change to a child class to be updated with respect to their
# 'last modification' timestamp which is used by the dynamic engine
# to determine when cached files are stale.
sub touch_blogs {
    my $blogs_touched = MT->instance->request('blogs_touched') or return;
    foreach my $blog_id ( keys %$blogs_touched ) {
        next unless $blog_id;
        my $blog = MT::Blog->load($blog_id);
        next unless ($blog);
        my $th = $blogs_touched->{$blog_id} || {};
        my @types = keys %$th;
        $blog->touch(@types);
        $blog->save() or die $blog->errstr;
    }
    MT->instance->request( 'blogs_touched', undef );
}

sub add_breadcrumb {
    my $app = shift;
    push @{ $app->{breadcrumbs} },
        {
        bc_name => $_[0],
        bc_uri  => $_[1],
        };
}

sub is_authorized {1}
sub can_sign_in   {1}

sub commenter_cookie { COMMENTER_COOKIE_NAME() }

sub user_cookie {$COOKIE_NAME}

sub user {
    my $app = shift;
    $app->{author} = $app->{ $app->user_cookie } = $_[0] if @_;
    return $app->{author};
}

sub permissions {
    my $app = shift;

    if (@_) {
        $app->{perms} = shift;
    }
    else {
        if ( !$app->{perms} ) {
            my $user = $app->user
                or return;

            # Exists?
            my $blog_id = $app->param('blog_id');
            if ($blog_id) {
                my $blog = MT->model('blog')->load($blog_id)
                    or return $app->errtrans( 'Cannot load blog #[_1]',
                    $blog_id );
            }

            my $perm = $user->permissions($blog_id);
            if (   $user->is_superuser
                || $user->can_edit_templates
                || $perm->permissions )
            {
                $app->{perms} = $perm;
            }
            else {
                $app->{perms} = undef;
            }
        }
    }

    return $app->{perms};
}

sub can_do {
    my $app = shift;
    my ( $action, $perms ) = @_;
    my $user = $app->user
        or die $app->error(
        $app->translate('Internal Error: Login user is not initialized.') );

    ##TODO: is this always good behavior?
    return 1 if $user->is_superuser;

    if ( $perms ||= $app->permissions ) {
        my $blog_result = $perms->can_do($action);
        return $blog_result if defined $blog_result;
    }
    ## if there were no result from blog permission,
    ## look for system level permission.

    # use the same cache_key as MT::Author::permissions
    my $cache_key = "__perm_author_" . (defined $user->id ? $user->id : '');

    require MT::Request;
    my $req = MT::Request->instance;
    my $sys_perms = $req->stash($cache_key);
    if (!$sys_perms) {
        $sys_perms = MT::Permission->load(
            {   author_id => $user->id,
                blog_id   => 0,
            }
        );
        $req->stash($cache_key, $sys_perms);
    }

    return $sys_perms ? $sys_perms->can_do($action) : undef;
}

sub session_state {
    my $app  = shift;
    my $blog = $app->blog;
    my ( $sessobj, $commenter ) = $app->get_commenter_session();
    return $app->_commenter_state( $blog, $sessobj, $commenter );
}

sub _commenter_state {
    my $app = shift;
    my ( $blog, $sessobj, $commenter ) = @_;
    my $c;
    my $blog_id = $blog ? $blog->id : 0;
    if ( $sessobj && $commenter ) {
        $c = {
            sid  => $sessobj->id,
            name => $commenter->nickname
                || $app->translate('(Display Name not set)'),
            url     => $commenter->url,
            email   => $commenter->email,
            userpic => scalar $commenter->userpic_url,
            profile => "",                               # profile link url
            is_authenticated => 1,
            is_author => ( $commenter->type == MT::Author::AUTHOR() ? 1 : 0 ),
            is_trusted   => 0,
            is_anonymous => 0,
            can_post     => 0,
            can_comment  => 0,
            is_banned    => 0,
        };
        if ( $blog_id && $blog ) {
            my $blog_perms = $commenter->blog_perm($blog_id);
            my $banned = $commenter->is_banned($blog_id) ? 1 : 0;
            $banned = 0 if $blog_perms && $blog_perms->can_administer;
            $banned ||= 1 if $commenter->status == MT::Author::BANNED();
            $c->{is_banned} = $banned;

            if ($banned) {
                $sessobj->remove;
                delete $c->{sid};
            }
            else {
                $sessobj->start( time + $app->config->CommentSessionTimeout )
                    ;    # extend by timeout
                $sessobj->save();
            }

            # FIXME: These may not be accurate in 'SingleCommunity' mode...
            my $can_comment = $banned ? 0 : 1;
            $can_comment = 0
                unless $blog->allow_unreg_comments
                || $blog->allow_reg_comments;
            $c->{can_comment} = $can_comment;
            $c->{can_post}
                = ( $blog_perms && $blog_perms->can_create_post ) ? 1 : 0;
            $c->{is_trusted}
                = ( $commenter->is_trusted($blog_id) ? 1 : 0 ),
                ;
        }
    }

    unless ($c) {
        my $can_comment = $blog && $blog->allow_anon_comments ? 1 : 0;
        $c = {
            is_authenticated => 0,
            is_trusted       => 0,
            is_anonymous     => 1,
            can_post         => 0,              # no anonymous posts
            can_comment      => $can_comment,
            is_banned        => 0,
        };
    }

    return ( $c, $commenter );
}

sub session {
    my $app  = shift;
    my $sess = $app->{session};
    return unless $sess;
    if (@_) {
        my $setting = shift;
        @_ ? $sess->set( $setting, @_ ) : $sess->get($setting);
    }
    else {
        $sess;
    }
}

sub make_magic_token {
    require MT::Util::UniqueID;
    MT::Util::UniqueID::create_magic_token();
}

sub make_session {
    my ( $auth, $remember ) = @_;
    require MT::Session;
    require MT::Util::UniqueID;
    my $new_id = MT::Util::UniqueID::create_session_id();
    my $token  = MT::Util::UniqueID::create_magic_token();
    my $sess = new MT::Session;
    $sess->id( $new_id );
    $sess->kind('US');    # US == User Session
    $sess->start(time);
    $sess->name( $auth->id );
    $sess->set( 'author_id', $auth->id );
    $sess->set( 'remember', 1 ) if $remember;
    $sess->set( 'magic_token', $token );
    $sess->save;
    $sess;
}

# given credentials in the form of a username, optional password, and
# session ID ("token"), this returns the corresponding author object
# if the credentials are legit, 0 if insufficient credentials were there,
# or undef if they were actually incorrect
sub session_user {
    my $app = shift;
    my ( $author, $session_id, %opt ) = @_;
    return undef unless $author && $session_id;
    if ( !$app->{session} ) {
        require MT::Session;
        my $timeout
            = $opt{permanent}
            ? ( 360 * 24 * 365 * 10 )
            : $app->config->UserSessionTimeout;
        $app->{session} = MT::Session::get_unexpired_value(
            $timeout,
            {   id   => $session_id,
                kind => 'US'
            }
        );
    }
    my $sess = $app->{session} or return undef;

    if ( $sess->get('author_id') == $author->id ) {
        my $start = time;
        $sess->start($start);
        $sess->set(start => $start) unless $sess->get('start');
        $sess->save;
        return $author;
    }
    else {
        return undef;
    }
}

sub get_commenter_session {
    my $app = shift;
    my $q   = $app->param;

    my $session_key;

    my %cookies     = $app->cookies();
    my $cookie_name = $app->commenter_session_cookie_name;
    if ( !$cookies{$cookie_name} or !$cookies{$cookie_name}->value() ) {
        return ( undef, undef );
    }
    my $state
        = $app->unbake_user_state_cookie( $cookies{$cookie_name}->value() );
    $session_key = $state->{sid} || "";
    $session_key =~ y/+/ /;
    my $cfg = $app->config;
    require MT::Session;
    my $sess_obj = MT::Session->load( { id => $session_key, kind => 'SI' } );
    my $timeout = $cfg->CommentSessionTimeout;
    my ( $user_id, $user );
    $user_id = $sess_obj->get('author_id') if $sess_obj;
    $user    = MT::Author->load($user_id)  if $user_id;

    if (   !$sess_obj
        || ( $sess_obj->start() + $timeout < time )
        || ( !$user_id )
        || ( !$user ) )
    {
        $app->_invalidate_commenter_session( \%cookies );
        return ( undef, undef );
    }

    # session is valid!
    return ( $sess_obj, $user );
}

sub make_commenter {
    my $app    = shift;
    my %params = @_;

    # Strip any angle brackets from input, just to be safe
    foreach my $f (qw( name email nickname url )) {
        $params{$f} =~ s/[<>]//g if exists $params{$f};
    }

    require MT::Author;
    my $cmntr = MT::Author->load(
        {   name      => $params{name},
            type      => MT::Author::COMMENTER(),
            auth_type => $params{auth_type},
        }
    );
    if ( !$cmntr ) {
        $cmntr = $app->model('author')->new();
        $cmntr->set_values(
            {   email     => $params{email},
                name      => $params{name},
                nickname  => $params{nickname},
                password  => "(none)",
                type      => MT::Author::COMMENTER(),
                url       => $params{url},
                auth_type => $params{auth_type},
                (   $params{external_id}
                    ? ( external_id => $params{external_id} )
                    : ()
                ),
                (   $params{remote_auth_username}
                    ? ( remote_auth_username =>
                            $params{remote_auth_username} )
                    : ()
                ),
            }
        );
        $cmntr->save();
    }
    else {
        $cmntr->set_values(
            {   email    => $params{email},
                nickname => $params{nickname},
                password => "(none)",
                type     => MT::Author::COMMENTER(),
                url      => $params{url},
                (   $params{external_id}
                    ? ( external_id => $params{external_id} )
                    : ()
                ),
            }
        );
        $cmntr->save();
    }
    return $cmntr;
}

sub make_commenter_session {
    my $app = shift;
    my ( $session_key, $email, $name, $nick, $id, $url ) = @_;
    my $user;

    # support for old signature; new signature is $session_key, $user_obj
    if ( ref($session_key) && $session_key->isa('MT::Author') ) {
        $user        = $session_key;
        $session_key = $app->make_magic_token;
        $email       = $user->email;
        $name        = $user->name;
        $nick = $user->nickname || $app->translate('(Display Name not set)');
        $id   = $user->id;
        $url  = $user->url;
    }

    require MT::Session;
    my $sess_obj = MT::Session->new();
    $sess_obj->id($session_key);
    $sess_obj->email($email);
    $sess_obj->name($name);
    $sess_obj->start(time);
    $sess_obj->kind("SI");
    $sess_obj->set( 'author_id', $id ) if $id;
    $sess_obj->save()
        or return $app->error(
        $app->translate(
            "The login could not be confirmed because of a database error ([_1])",
            $sess_obj->errstr
        )
        );

    $app->bake_commenter_cookie( $sess_obj, $user, $nick );
    return $session_key;
}

sub bake_commenter_cookie {
    my $app = shift;
    my ( $sess_obj, $user, $nick ) = @_;

    my $session_key = $sess_obj->id;

    my $enc = $app->charset;
    my $nick_escaped
        = $nick ? MT::Util::escape_unicode($nick)
        : $user ? MT::Util::escape_unicode( $user->nickname )
        :         '';

    my $timeout;
    if ( $user && $user->type == MT::Author::AUTHOR() ) {
        if ( $app->param('remember') ) {

            # 10 years, same as app sign-in 'remember me'
            $timeout = '+3650d';
        }
        else {
            $timeout = '+' . $app->config->UserSessionTimeout . 's';
        }
    }
    else {
        $timeout = '+' . $app->config->CommentSessionTimeout . 's';
    }

    my %kookee = (
        -name  => COMMENTER_COOKIE_NAME(),
        -value => $session_key,
        -path  => '/',
        ( $timeout ? ( -expires => $timeout ) : () )
    );
    $app->bake_cookie(%kookee);
    my %name_kookee = (
        -name  => "commenter_name",
        -value => $nick_escaped,
        -path  => '/',
        ( $timeout ? ( -expires => $timeout ) : () )
    );
    $app->bake_cookie(%name_kookee);

    my $blog = $app->blog;
    my $blog_id = $blog ? $blog->id : '0';
    my ( $state, $commenter )
        = $app->_commenter_state( $blog, $sess_obj, $user );

    my $build = sub {
        my $tag = shift;
        require MT::Builder;
        require MT::Template::Context;
        my $builder = MT::Builder->new;
        my $ctx     = MT::Template::Context->new;
        $ctx->stash( blog    => $blog );
        $ctx->stash( blog_id => $blog_id );
        my $tokens = $builder->compile( $ctx, $tag );
        die $ctx->error( $builder->errstr ) unless defined $tokens;
        $tag = $builder->build( $ctx, $tokens );
        die $ctx->error( $builder->errstr ) unless defined $tag;
        return $tag;
    };

    my $cookie_path = MT->config->UserSessionCookiePath;
    $cookie_path = $build->($cookie_path)
        if $cookie_path =~ m/<\$?mt/i;    # hey, a MT tag! lets evaluate

    my %user_session_kookee = (
        -name  => $app->commenter_session_cookie_name,
        -value => $app->bake_user_state_cookie($state),
        -path  => $cookie_path,
    );
    $app->bake_cookie(%user_session_kookee);
}

sub commenter_session_cookie_name {
    my $app               = shift;
    my $user_session_name = MT->config->UserSessionCookieName;
    if ( !MT->config->SingleCommunity ) {
        my $blog = $app->blog or return;
        my $blog_id = $blog->id;
        $user_session_name =~ s/%b/$blog_id/;
    }
    $user_session_name;
}

sub bake_user_state_cookie {
    my $app = shift;
    my ($state) = @_;
    join(
        ';',
        (   map      { $_ . ":'" . $state->{$_} . "'" }
                grep { $state->{$_} }
                keys %$state
        )
    );
}

sub unbake_user_state_cookie {
    my $app = shift;
    my ($value) = @_;
    return unless $value;
    return {
        map {
            my ( $k, $v ) = split( ':', $_, 2 );
            $v =~ s/^'//;
            $v =~ s/'$//;
            ( $k, $v );
        } split( ';', $value )
    };
}

sub _invalidate_commenter_session {
    my $app = shift;
    my ($cookies) = @_;

    my $cookie_val = (
          $cookies->{ COMMENTER_COOKIE_NAME() }
        ? $cookies->{ COMMENTER_COOKIE_NAME() }->value()
        : ""
    );
    my $session = $cookie_val;
    require MT::Session;
    my $sess_obj = MT::Session->load( { id => $session } );
    $sess_obj->remove() if ($sess_obj);

    my $timeout = $app->{cfg}->CommentSessionTimeout;

    my %kookee = (
        -name    => COMMENTER_COOKIE_NAME(),
        -value   => '',
        -path    => '/',
        -expires => "+${timeout}s"
    );
    $app->bake_cookie(%kookee);
    my %name_kookee = (
        -name    => 'commenter_name',
        -value   => '',
        -path    => '/',
        -expires => "+${timeout}s"
    );
    $app->bake_cookie(%name_kookee);
    my %id_kookee = (
        -name    => 'commenter_id',
        -value   => '',
        -path    => '/',
        -expires => "+${timeout}s"
    );
    $app->bake_cookie(%id_kookee);

    my $blog    = $app->blog;
    my $blog_id = $blog ? $blog->id : '0';
    my $build   = sub {
        my $tag = shift;
        require MT::Builder;
        require MT::Template::Context;
        my $builder = MT::Builder->new;
        my $ctx     = MT::Template::Context->new;
        $ctx->stash( blog    => $blog );
        $ctx->stash( blog_id => $blog_id );
        my $tokens = $builder->compile( $ctx, $tag );
        die $ctx->error( $builder->errstr ) unless defined $tokens;
        $tag = $builder->build( $ctx, $tokens );
        die $ctx->error( $builder->errstr ) unless defined $tag;
        return $tag;
    };

    my $cookie_path = MT->config->UserSessionCookiePath;
    $cookie_path = $build->($cookie_path)
        if $cookie_path =~ m/<\$?mt/i;    # hey, a MT tag! lets evaluate

    my %user_session_kookee = (
        -name    => $app->commenter_session_cookie_name,
        -value   => '',
        -expires => "+${timeout}s",
        -path    => $cookie_path,
    );
    $app->bake_cookie(%user_session_kookee);
}

sub start_session {
    my $app = shift;
    my ( $author, $remember ) = @_;
    if ( !defined $author ) {
        $author = $app->user;
        my ( $x, $y );
        ( $x, $y, $remember )
            = split( /::/, $app->cookie_val( $app->user_cookie ) );
    }
    $remember ||= '';
    my $session = make_session( $author, $remember );
    my %arg = (
        -name  => $app->user_cookie,
        -value => Encode::encode(
            $app->charset,
            join( '::', $author->name, $session->id, $remember )
        ),
        -path => $app->config->CookiePath || $app->mt_path
    );
    $arg{-expires} = '+10y' if $remember;
    $app->{session} = $session;
    $app->bake_cookie(%arg);
    \%arg;
}

sub _get_options_tmpl {
    my $self = shift;
    my ($authenticator) = @_;

    my $tmpl = $authenticator->{login_form};
    return q() unless $tmpl;
    return $tmpl->($authenticator) if ref $tmpl eq 'CODE';
    if ( $tmpl =~ /\s/ ) {
        return $tmpl;
    }
    else {    # no spaces in $tmpl; must be a filename...
        if ( my $plugin = $authenticator->{plugin} ) {
            my $ret = $plugin->load_tmpl($tmpl) or die $plugin->errstr;
            return $ret;
        }
        else {
            return MT->instance->load_tmpl($tmpl);
        }
    }
}

sub _get_options_html {
    my $app           = shift;
    my ($key)         = @_;
    my $authenticator = MT->commenter_authenticator($key);
    return q() unless $authenticator;

    my $snip_tmpl = $app->_get_options_tmpl($authenticator);
    return q() unless $snip_tmpl;

    require MT::Template;
    my $tmpl;
    if ( ref $snip_tmpl ne 'MT::Template' ) {
        $tmpl = MT::Template->new(
            type   => 'scalarref',
            source => ref $snip_tmpl ? $snip_tmpl : \$snip_tmpl
        );
    }
    else {
        $tmpl = $snip_tmpl;
    }

    $app->set_default_tmpl_params($tmpl);
    my $entry_id = $app->param('entry_id') || '';
    $entry_id =~ s/\D//g;
    my $blog_id = $app->param('blog_id') || '';
    $blog_id =~ s/\D//g;
    my $static = MT::Util::remove_html(
        $app->param('static')    # unused - for compatibility
            || encode_url(
            $app->param('return_to') || $app->param('return_url') || ''
            )
            || ''
    );
    if ( my $p = $authenticator->{login_form_params} ) {
        $p = $app->handler_to_coderef($p);
        if ($p) {
            my $params = $p->( $key, $blog_id, $entry_id, $static, );
            $tmpl->param($params) if $params;
        }
    }
    my $html = $tmpl->output();
    if ( UNIVERSAL::isa( $authenticator, 'MT::Plugin' )
        && ( $html =~ m/<__trans / ) )
    {
        $html = $authenticator->translate_templatized($html);
    }
    $html;
}

sub external_authenticators {
    my $app = shift;
    my ( $blog, $param ) = @_;
    return [] unless $blog;

    $param ||= {};

    my @external_authenticators;

    my %cas = map { $_->{key} => $_ } $app->commenter_authenticators;

    my @auths = split ',', $blog->commenter_authenticators;
    my %otherauths;
    foreach my $key (@auths) {
        my $id = lc $key;
        $id =~ s/[^a-z0-9-]//;
        if ( $key eq 'MovableType' ) {
            $param->{default_id}          = $id;
            $param->{enabled_MovableType} = 1;
            $param->{default_signin}      = 'MovableType';
            my $cfg = $app->config;
            if ( my $registration = $cfg->CommenterRegistration ) {
                if ( $cfg->AuthenticationModule eq 'MT' ) {
                    $param->{registration_allowed} = $registration->{Allow}
                        && $blog->allow_commenter_regist ? 1 : 0;
                }
            }
            require MT::Auth;
            $param->{can_recover_password} = MT::Auth->can_recover_password;
            next;
        }

        my $auth = $cas{$key} or next;

        if (   $key ne 'OpenID'
            && $key ne 'LiveJournal' )
        {
            push @external_authenticators,
                {
                id         => $id,
                name       => $auth->{label},
                key        => $auth->{key},
                login_form => $app->_get_options_html($key),
                exists( $auth->{logo} ) ? ( logo => $auth->{logo} ) : (),
                };
        }
        else {
            $otherauths{$key} = {
                id         => $id,
                name       => $auth->{label},
                key        => $auth->{key},
                login_form => $app->_get_options_html($key),
                exists( $auth->{logo} ) ? ( logo => $auth->{logo} ) : (),
            };
        }
    }

    unshift @external_authenticators, $otherauths{'LiveJournal'}
        if exists $otherauths{'LiveJournal'};
    unshift @external_authenticators, $otherauths{'OpenID'}
        if exists $otherauths{'OpenID'};

    \@external_authenticators;
}

sub _is_commenter {
    my $app = shift;
    my ($author) = @_;

    return 0 if $author->is_superuser;

   # Check if the user is a commenter and keep them from logging in to the app
    my @author_perms
        = $app->model('permission')
        ->load( { author_id => $author->id, blog_id => '0' },
        { not => { blog_id => 1 } } );
    my $commenter = -1;
    my $commenter_blog_id;
    for my $perm (@author_perms) {
        my $permissions = $perm->permissions;
        next unless $permissions;
        if ( $permissions eq "'comment'" ) {
            $commenter_blog_id = $perm->blog_id unless $commenter_blog_id;
            $commenter = 1;
            next;
        }
        return 0;
    }
    if ( -1 == $commenter ) {

        # this user does not have any permission to any blog
        # check for system permission
        my $sys_perms             = MT::Permission->perms('system');
        my $has_system_permission = 0;
        foreach (@$sys_perms) {
            if ( $author->permissions(0)->has( $_->[0] ) ) {
                $has_system_permission = 1;
                last;
            }
        }
        return $app->error(
            $app->translate(
                'Sorry, but you do not have permission to access any blogs or websites within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.'
            )
        ) unless $has_system_permission;
        return -1;
    }
    return $commenter_blog_id;
}

# virutal method overridden when pending user has special treatment
sub login_pending {q()}

# virutal method overridden when commenter needs special treatment
sub commenter_loggedin {
    my $app = shift;
    my ( $commenter, $commenter_blog_id ) = @_;
    my $blog = $app->model('blog')->load($commenter_blog_id)
        or return $app->error(
        $app->translate( "Cannot load blog #[_1].", $commenter_blog_id ) );
    my $path = $app->config('CGIPath');
    $path .= '/' unless $path =~ m!/$!;
    my $url = $path . $app->config('CommentScript');
    $url .= '?__mode=edit_profile';
    $url .= '&commenter=' . $commenter->id;
    $url .= '&blog_id=' . $commenter_blog_id;
    $url .= '&static=' . $blog->site_url;
    $url;
}

# MT::App::login
#   Working from the query object, determine whether the session is logged in,
#   perform any session/cookie maintenance, and if we're logged in,
#   return a pair
#     ($author, $first_time)
#   where $author is an author object and $first_time is true if this
#   is the first request of a session. $first_time is returned just
#   for any plugins that might need it, since historically the logging
#   and session management was done by the calling code.

sub login {
    my $app = shift;

    my $new_login = 0;

    require MT::Auth;

    my $ctx = MT::Auth->fetch_credentials( { app => $app } );
    unless ($ctx) {
        if ( defined( $app->param('password') ) ) {
            # Login invalid (empty password)
            my $username = $app->param('username');
            my $message  = defined $username && $username ne ''
                         ? $app->translate("Failed login attempt by user '[_1]'", $username)
                         : $app->translate("Failed login attempt by anonymous user");
            $app->log({
                message  => $message,
                level    => MT::Log::SECURITY(),
                category => 'login_user',
                class    => 'author',
            });
            return $app->error( $app->translate('Invalid login.') );
        }
        return;
    }

    my $res = MT::Auth->validate_credentials($ctx) || MT::Auth::UNKNOWN();
    my $user = $ctx->{username};

    if ( $res == MT::Auth::UNKNOWN() ) {

        # Login invalid; auth layer knows nothing of user
        $app->log(
            {   message => $app->translate(
                    "Failed login attempt by unknown user '[_1]'", $user
                ),
                level    => MT::Log::SECURITY(),
                category => 'login_user',
                class    => 'author',
            }
        ) if defined $user;
        MT::Auth->invalidate_credentials( { app => $app } );
        return $app->error( $app->translate('Invalid login.') );
    }
    elsif ( $res == MT::Auth::INACTIVE() ) {

        # Login invalid; auth layer reports user was disabled
        $app->log(
            {   message => $app->translate(
                    "Failed login attempt by disabled user '[_1]'", $user
                ),
                level    => MT::Log::SECURITY(),
                category => 'login_user',
                class    => 'author',
            }
        );
        return $app->error(
            $app->translate(
                'This account has been disabled. Please see your Movable Type system administrator for access.'
            )
        );
    }
    elsif ( $res == MT::Auth::PENDING() ) {

        # Login invalid; auth layer reports user was pending
        # Check if registration is allowed and if so send special message
        my $message;
        if ( my $registration = $app->config->CommenterRegistration ) {
            if ( $registration->{Allow} ) {
                $message = $app->login_pending();
            }
        }
        $message
            ||= $app->translate(
            'This account has been disabled. Please see your Movable Type system administrator for access.'
            );
        $app->user(undef);
        $app->log(
            {   message => $app->translate(
                    "Failed login attempt by pending user '[_1]'", $user
                ),
                level    => MT::Log::SECURITY(),
                category => 'login_user',
                class    => 'author',
            }
        );
        return $app->error($message);
    }
    elsif ($res == MT::Auth::INVALID_PASSWORD()
        || $res == MT::Auth::SESSION_EXPIRED() )
    {

        # Login invalid (password error, etc...)
        $app->log(
            {   message => $app->translate(
                    "Failed login attempt by user '[_1]'", $user
                ),
                level    => MT::Log::SECURITY(),
                category => 'login_user',
                class    => 'author',
            }
        );
        return $app->error( $app->translate('Invalid login.') );
    }
    elsif ( $res == MT::Auth::DELETED() ) {

        # Login invalid; auth layer says user record has been removed
        $app->log(
            {   message => $app->translate(
                    "Failed login attempt by deleted user '[_1]'", $user
                ),
                level    => MT::Log::SECURITY(),
                category => 'login_user',
                class    => 'author',
            }
        );
        return $app->error(
            $app->translate(
                'This account has been deleted. Please see your Movable Type system administrator for access.'
            )
        );
    }
    elsif ( $res == MT::Auth::LOCKED_OUT() ) {
        $app->log(
            {   message => $app->translate(
                    "Failed login attempt by locked-out user '[_1]'", $user
                ),
                level    => MT::Log::SECURITY(),
                category => 'login_user',
                class    => 'author',
            }
        );
        return $app->error( $app->translate('Invalid login.') );
    }
    elsif ( $res == MT::Auth::REDIRECT_NEEDED() ) {

# The authentication driver is delegating authentication to another URL, follow the
# designated redirect.
        my $url = $app->config->AuthLoginURL;
        if ( $url && !$app->{redirect} ) {
            $app->redirect($url);
        }
        return
            0
            ; # Return undefined so the redirect (set by the Auth Driver) will be
              # followed by MT.
    }
    elsif ( $res == MT::Auth::NEW_LOGIN() ) {

 # auth layer reports valid user and that this is a new login. act accordingly
        my $author = $app->user;
        MT::Auth->new_login( $app, $author );
        $new_login = 1;
    }
    elsif ( $res == MT::Auth::NEW_USER() ) {

        # auth layer reports that a new user has been created by logging in.
        my $user_class = $app->user_class;
        my $author     = $user_class->new;
        $app->user($author);
        $author->name( $ctx->{username} ) if $ctx->{username};
        $author->type( MT::Author::AUTHOR() );
        $author->status( MT::Author::ACTIVE() );
        $author->auth_type( $app->config->AuthenticationModule );
        my $saved = MT::Auth->new_user( $app, $author );
        $saved = $author->save unless $saved;

        unless ($saved) {
            $app->log(
                {   message => MT->translate(
                        "User cannot be created: [_1].",
                        $author->errstr
                    ),
                    level    => MT::Log::ERROR(),
                    class    => 'system',
                    category => 'create_user'
                }
                ),
                $app->error(
                MT->translate(
                    "User cannot be created: [_1].",
                    $author->errstr
                )
                ),
                return undef;
        }

        $app->log(
            {   message => MT->translate(
                    "User '[_1]' has been created.",
                    $author->name
                ),
                level    => MT::Log::INFO(),
                class    => 'system',
                category => 'create_user'
            }
        );

        # provision user if configured to do so
        MT->run_callbacks( 'new_user_provisioning', $author );
        $new_login = 1;
    }
    my $author = $app->user;

# At this point the MT::Auth module should have initialized an author object. If
# it did then everything is cool and the MT session is initialized. If not, then
# an error is thrown

    if ($author) {

        # Login valid
        if ($new_login) {
            my $commenter_blog_id = $app->_is_commenter($author);

            # $commenter_blog_id
            #  0: user has more permissions than comment
            #  N: user has only comment permission on some blog
            # -1: user has only system permissions
            # undef: user does not have any permission

            return $app->error(
                $app->translate(
                    'Our apologies, but you do not have permission to access any blogs or websites within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.'
                )
            ) if !defined $commenter_blog_id || $commenter_blog_id > 0;

            # Application level login validation
            if ( !$app->can_sign_in($author) ) {
                MT::Auth->invalidate_credentials( { app => $app } );
                return $app->error( $app->translate('Invalid login.') );
            }

            $app->start_session( $author, $ctx->{permanent} ? 1 : 0 );
            $app->request( 'fresh_login', 1 );
            $app->log({
                message  => $app->translate(
                    "User '[_1]' (ID:[_2]) logged in successfully",
                    $author->name, $author->id
                ),
                level    => MT::Log::INFO(),
                class    => 'author',
                category => 'login_user',
            });

            ## magic_token = the user is trying to post something
            ## (after a long pause, or because of CSRF)
            if ( defined $app->param('magic_token') ) {
                return $app->redirect_to_home;
            }
        }
        else {
            $author = $app->session_user( $author, $ctx->{session_id},
                permanent => $ctx->{permanent} );
            if ( !defined($author) ) {
                $app->user(undef);
                $app->{login_again} = 1;
                return undef;
            }
        }

        # $author->last_login();
        # $author->save;

        return ( $author, $new_login );
    }
    else {
        MT::Auth->invalidate_credentials( { app => $app } );
        if ( !defined($author) ) {
            require MT::Log;

            # undef indicates *invalid* login as opposed to no login at all.
            $app->log(
                {   message => $app->translate(
                        "Invalid login attempt from user '[_1]'", $user
                    ),
                    level => MT::Log::WARNING(),
                }
            );
            return $app->error( $app->translate('Invalid login.') );
        }
        else {
            return undef;
        }
    }
}

sub logout {
    my $app = shift;

    require MT::Auth;

    my $ctx = MT::Auth->fetch_credentials( { app => $app } );
    if ( $ctx && $ctx->{username} ) {
        my $user_class = $app->user_class;
        my $user       = $user_class->load(
            { name => $ctx->{username}, type => MT::Author::AUTHOR() } );
        if ($user) {
            $app->user($user);
            $app->log(
                {   message => $app->translate(
                        "User '[_1]' (ID:[_2]) logged out", $user->name,
                        $user->id
                    ),
                    level    => MT::Log::INFO(),
                    class    => 'author',
                    category => 'logout_user',
                }
            );
        }
    }

    MT::Auth->invalidate_credentials( { app => $app } );
    my %cookies = $app->cookies();
    $app->_invalidate_commenter_session( \%cookies );

   # The login box should only be displayed in the event of non-delegated auth
   # right?
    my $delegate = MT::Auth->delegate_auth();
    if ($delegate) {
        my $url = $app->config->AuthLogoutURL;
        if ( $url && !$app->{redirect} ) {
            $app->redirect($url);
        }
        if ( $app->{redirect} ) {

            # Return 0 to force MT to follow redirects
            return 0;
        }
    }

    # Displaying the login box
    $app->show_login( { logged_out => 1, } );
}

sub create_user_pending {
    my $app = shift;
    my ($param) = @_;
    $param ||= {};

    my $cfg = $app->config;
    $param->{ 'auth_mode_' . $cfg->AuthenticationModule } = 1;

    my $blog;
    if ( exists $param->{blog_id} ) {
        $blog = $app->model('blog')->load( $param->{blog_id} )
            or return $app->error(
            $app->translate( "Cannot load blog #[_1].", $param->{blog_id} ) );
    }

    my $external_auth = $app->param('external_auth');
    my $password      = $app->param('password');
    my $pass_verify   = $app->param('pass_verify');
    my $url           = $app->param('url');

    unless ($external_auth) {
        unless ($password) {
            return $app->error( $app->translate("User requires password.") );
        }

        if ( $password ne $pass_verify ) {
            return $app->error( $app->translate('Passwords do not match.') );
        }

        if ( $url && ( !is_url($url) || ( $url =~ m/[<>]/ ) ) ) {
            return $app->error( $app->translate("URL is invalid.") );
        }
    }

    my $nickname = $app->param('nickname');
    if ( !length($nickname) && !$external_auth ) {
        return $app->error( $app->translate("User requires display name.") );
    }
    if ( length($nickname) && $nickname =~ m/([<>])/ ) {
        return $app->error(
            $app->translate(
                "[_1] contains an invalid character: [_2]",
                $app->translate("Display Name"),
                encode_html($1)
            )
        );
    }

    my $email = $app->param('email');
    if ($email) {
        unless ( is_valid_email($email) ) {
            delete $param->{email};
            return $app->error(
                $app->translate("Email Address is invalid.") );
        }
        if ( $email =~ m/([<>])/ ) {
            return $app->error(
                $app->translate(
                    "[_1] contains an invalid character: [_2]",
                    $app->translate("Email Address"),
                    encode_html($1)
                )
            );
        }
    }
    elsif ( $app->config('RequiredUserEmail') and !$external_auth ) {
        delete $param->{email};
        return $app->error(
            $app->translate("Email Address is required for password reset.")
        );
    }

    my $name = $app->param('username');
    if ( defined $name ) {
        $name =~ s/(^\s+|\s+$)//g;
        $param->{name} = $name;
    }
    unless ( defined($name) && length($name) ) {
        return $app->error( $app->translate("User requires username.") );
    }
    elsif ( $name =~ m/([<>])/ ) {
        return $app->error(
            $app->translate(
                "[_1] contains an invalid character: [_2]",
                $app->translate("Username"),
                encode_html($1)
            )
        );
    }
    if ( $name =~ m/([<>])/ ) {
        return $app->error(
            $app->translate(
                "[_1] contains an invalid character: [_2]",
                $app->translate("Username"),
                encode_html($1)
            )
        );
    }

    my $existing = MT::Author->exist( { name => $name } );
    return $app->error(
        $app->translate("A user with the same name already exists.") )
        if $existing;

    if ( $url && ( !is_url($url) || ( $url =~ m/[<>]/ ) ) ) {
        return $app->error( $app->translate("URL is invalid.") );
    }

    if ($blog
        && ( my $provider
            = MT->effective_captcha_provider( $blog->captcha_provider ) )
        )
    {
        unless ( $provider->validate_captcha($app) ) {
            return $app->error(
                $app->translate("Text entered was wrong.  Try again.") );
        }
    }

    my $user = $app->model('author')->new;
    $user->name($name);
    $user->nickname($nickname);
    $user->email($email);
    unless ($external_auth) {
        $user->set_password($password);
        $user->url($url) if $url;
    }
    else {
        $user->password('(none)');
    }
    $user->type( MT::Author::AUTHOR() );
    $user->status( MT::Author::PENDING() );
    $user->auth_type( $app->config->AuthenticationModule );

    unless ( $user->save ) {
        return $app->error(
            $app->translate(
                "An error occurred while trying to process signup: [_1]",
                $user->errstr
            )
        );
    }
    return $user;

}

sub _send_comment_notification {
    my $app = shift;
    my ( $comment, $comment_link, $entry, $blog, $commenter ) = @_;

    return unless $blog->email_new_comments;

    my $cfg       = $app->config;
    my $attn_reqd = $comment->is_moderated;

    if ( $blog->email_attn_reqd_comments && !$attn_reqd ) {
        return;
    }

    require MT::Util::Mail;
    my $author = $entry->author;
    return unless $author && $author->email;
    $app->set_language($author->preferred_language) if $author->preferred_language;
    my $from_addr = $comment->email;
    if (!$from_addr || !is_valid_email($from_addr)) {
        $from_addr = $cfg->EmailAddressMain || $author->email;
        $from_addr = $comment->author . ' <' . $from_addr . '>' if $comment->author;
    }
    my %head = (
        id      => 'new_comment',
        To      => $author->email,
        From    => $from_addr,
        Subject => '[' . $blog->name . '] ' . $app->translate("New Comment Added to '[_1]'", $entry->title),
    );
    my $charset = $cfg->MailEncoding || $cfg->PublishCharset;
    $head{'Content-Type'} = qq(text/plain; charset="$charset");
    my $base;
    {
        local $app->{is_admin} = 1;
        $base = $app->base . $app->mt_uri;
    }
    if ( $base =~ m!^/! ) {
        my ($blog_domain) = $blog->site_url =~ m|(.+://[^/]+)|;
        $base = $blog_domain . $base;
    }
    my $nonce
        = MT::Util::perl_sha1_digest_hex( $comment->id
            . $comment->created_on
            . $blog->id
            . $cfg->SecretToken );
    my $approve_link = $base
        . $app->uri_params(
        'mode' => 'approve_item',
        args   => {
            blog_id => $blog->id,
            '_type' => 'comment',
            id      => $comment->id,
            nonce   => $nonce
        }
        );
    my $spam_link = $base
        . $app->uri_params(
        'mode' => 'handle_junk',
        args   => {
            blog_id => $blog->id,
            '_type' => 'comment',
            id      => $comment->id,
            nonce   => $nonce
        }
        );
    my $edit_link = $base
        . $app->uri_params(
        'mode' => 'view',
        args   => {
            blog_id => $blog->id,
            '_type' => 'comment',
            id      => $comment->id
        }
        );
    my $ban_link = $base
        . $app->uri_params(
        'mode' => 'save',
        args   => {
            '_type' => 'banlist',
            blog_id => $blog->id,
            ip      => $comment->ip
        }
        );
    my %param = (
        blog           => $blog,
        entry          => $entry,
        view_url       => $comment_link,
        approve_url    => $approve_link,
        spam_url       => $spam_link,
        edit_url       => $edit_link,
        ban_url        => $ban_link,
        comment        => $comment,
        unapproved     => !$comment->visible(),
        state_editable => (
            $author->is_superuser()
                || (
                   $author->permissions( $blog->id )->can_manage_feedback
                || $author->permissions( $blog->id )->can_publish_post )
        ) ? 1 : 0,
    );
    my $body = MT->build_email( 'new-comment.tmpl', \%param );
    MT::Util::Mail->send_and_log( \%head, $body ) or return $app->error( MT::Util::Mail->errstr() );
}

sub _send_sysadmins_email {
    my $app = shift;
    my ( $ids, $email_id, $body, $subject, $from ) = @_;
    my $cfg = $app->config;

    my @ids = split ',', $ids;
    my @sysadmins = MT::Author->load(
        {   id   => \@ids,
            type => MT::Author::AUTHOR()
        },
        {   join => MT::Permission->join_on(
                'author_id',
                {   permissions => "\%'administer'\%",
                    blog_id     => '0',
                },
                { 'like' => { 'permissions' => 1 } }
            )
        }
    );

    require MT::Util::Mail;

    my $from_addr = $cfg->EmailAddressMain || $from;

    if (!$from_addr || !is_valid_email($from_addr)) {
        $app->log(
            {   message =>
                    MT->translate("System Email Address is not configured."),
                level    => MT::Log::ERROR(),
                class    => 'system',
                category => 'email'
            }
        );
        return;
    }

    foreach my $a (@sysadmins) {
        next unless $a->email && is_valid_email( $a->email );
        my %head = (
            id      => $email_id,
            To      => $a->email,
            From    => $from_addr,
            Subject => $subject,
        );
        my $charset = $cfg->MailEncoding || $cfg->PublishCharset;
        $head{'Content-Type'} = qq(text/plain; charset="$charset");
        MT::Util::Mail->send_and_log( \%head, $body ) or last;
    }
}

sub clear_login_cookie {
    my $app = shift;
    $app->bake_cookie(
        -name    => $app->user_cookie,
        -value   => '',
        -expires => '-1y',
        -path    => $app->config->CookiePath || $app->mt_path
    );
}

sub request_content {
    my $app = shift;
    unless ( exists $app->{request_content} ) {
        if ( MT::Util::is_mod_perl1() ) {
            ## Read from $app->{apache}
            my $r   = $app->{apache};
            my $len = $app->get_header('Content-length');
            $r->read( $app->{request_content}, $len );
        }
        elsif ( $ENV{'psgi.input'} ) {
            ## Read frrom psgi.input
            my $fh = $ENV{'psgi.input'};
            seek $fh, 0, 0;
            my $buffer = '';
            while ( my $buf = <$fh> ) {
                $buffer .= $buf;
            }
            $app->{request_content} = $buffer
                if $buffer;
        }
        else {
            ## Read from STDIN
            my $len = $ENV{CONTENT_LENGTH} || 0;
            read STDIN, $app->{request_content}, $len;
        }
    }
    $app->{request_content};
}

sub get_header {
    my $app = shift;
    my ($key) = @_;
    if ( MT::Util::is_mod_perl1() ) {
        return $app->{apache}->header_in($key);
    }
    else {
        ( $key = uc($key) ) =~ tr/-/_/;
        return $ENV{ 'HTTP_' . $key };
    }
}

sub set_header {
    my $app = shift;
    my ( $key, $val ) = @_;
    if ( MT::Util::is_mod_perl1() ) {
        $app->{apache}->header_out( $key, $val );
    }
    else {
        unless ( $key =~ /^-/ ) {
            ( $key = lc($key) ) =~ tr/-/_/;
            $key = '-' . $key;
        }
        if ( $key eq '-cookie' ) {
            push @{ $app->{cgi_headers}{$key} }, $val;
        }
        else {
            $app->{cgi_headers}{$key} = $val;
        }
    }
}

sub request_method {
    my $app = shift;
    if (@_) {
        $app->{request_method} = shift;
    }
    elsif ( !exists $app->{request_method} ) {
        if ( MT::Util::is_mod_perl1() ) {
            $app->{request_method} = Apache->request->method;
        }
        else {
            $app->{request_method} = $ENV{REQUEST_METHOD} || '';
        }
    }
    $app->{request_method};
}

sub upload_info {
    my $app          = shift;
    my ($param_name) = @_;
    my $q            = $app->param;

    my ( $fh, $info, $no_upload );
    if ( MT::Util::is_mod_perl1() ) {
        if ( my $up = $q->upload($param_name) ) {
            $fh        = $up->fh;
            $info      = $up->info;
            $no_upload = !$up->size;
        }
        else {
            $no_upload = 1;
        }
    }
    else {
        ## Older versions of CGI.pm didn't have an 'upload' method.
        eval { $fh = $q->upload($param_name) };
        if ( $@ && $@ =~ /^Undefined subroutine/ ) {
            $fh = $q->param($param_name);
        }
        return unless $fh;
        $info = $q->uploadInfo($fh);
    }

    return if $no_upload;
    return ( $fh, $info );
}

sub cookie_val {
    my $app     = shift;
    my $cookies = $app->cookies;
    if ( $cookies && $cookies->{ $_[0] } ) {
        return $cookies->{ $_[0] }->value() || "";
    }
    return "";
}

sub bake_cookie {
    my $app   = shift;
    my %param = @_;
    my $cfg   = $app->config;
    if ( ( !exists $param{'-secure'} ) && $app->is_secure ) {
        $param{'-secure'} = 1;
    }
    unless ( $param{-path} ) {
        $param{-path} = $cfg->CookiePath || $app->path;
    }
    if ( !$param{-domain} && $cfg->CookieDomain ) {
        $param{-domain} = $cfg->CookieDomain;
    }
    if ( MT::Util::is_mod_perl1() ) {
        require Apache::Cookie;
        my $cookie = Apache::Cookie->new( $app->{apache}, %param );
        if ( $param{-expires} && ( $cookie->expires =~ m/%/ ) ) {

            # Fix for oddball Apache::Cookie error reported on Windows.
            require CGI::Util;
            $cookie->expires(
                CGI::Util::expires( $param{-expires}, 'cookie' ) );
        }
        $cookie->bake;
    }
    else {
        require CGI::Cookie;
        my $cookie = CGI::Cookie->new(%param);
        $app->set_header( '-cookie', $cookie );
    }
}

sub cookies {
    my $app = shift;
    unless ( $app->{cookies} ) {
        my $class
            = MT::Util::is_mod_perl1() ? 'Apache::Cookie' : 'CGI::Cookie';
        eval "use $class;";
        $app->{cookies} = $class->fetch;
    }
    if ( $app->{cookies} ) {
        return wantarray ? %{ $app->{cookies} } : $app->{cookies};
    }
    else {
        return wantarray ? () : undef;
    }
}

sub show_error {
    my $app = shift;
    my ($param) = @_;
    my $tmpl;
    my $mode    = $app->mode;
    my $url     = $app->uri;
    my $blog_id = $app->param('blog_id');
    my $status  = $param->{status};
    $app->response_code($status)
        if defined $status;

    if ( ref $param ne 'HASH' ) {

        # old scalar signature
        $param = { error => $param };
    }

    my $error = $param->{error} || $app->translate('Unknown error occurred.');

    if ($MT::DebugMode) {
        if ($@) {

            # Use 'pre' tag to wrap Perl error
            $param->{enable_pre} = 1;
        }
    }
    else {
        if ( $error =~ m/^(.+?)( at .+? line \d+)(.*)$/s ) {

            # Hide any module path info from perl error message
            # Information could be revealing info about where MT app
            # resides on server, and what version is being used, which
            # may be helpful forensics to an attacker.
            $error = $1;
        }
        $error =~ s!(https?://\S+)!<a href="$1" target="_blank">$1</a>!g;
    }

    $tmpl = $app->load_tmpl('error.tmpl');
    if ( !$tmpl ) {
        $error = '<pre>' . $error . '</pre>' unless $error =~ m/<pre>/;
        return
              "Cannot load error template; got error '"
            . encode_html( $app->errstr )
            . "'. Giving up. Original error was: $error";
    }
    my $type = $app->param('__type') || '';
    if ( $type eq 'dialog' ) {
        $param->{name} ||= $app->{name} || 'dialog';
        $param->{goback} ||=
            $app->{goback}
            ? "window.location='" . $app->{goback} . "'"
            : 'closeDialog()';
        $param->{value} ||= $app->{value} || $app->translate("Close");
        $param->{dialog} = 1;
    }
    else {
        $param->{goback} ||=
            $app->{goback}
            ? "window.location='" . $app->{goback} . "'"
            : 'history.back()';
        $param->{value} ||= $app->{value} || $app->translate("Back");
    }
    $param->{hide_goback_button} = $app->{hide_goback_button} || 0;
    local $param->{error} = $error;
    $param->{local_lang_id} = $app->current_language || 'en_us';
    $tmpl->param($param);
    $app->run_callbacks( 'template_param.error', $app, $tmpl->param, $tmpl );
    my $out = $tmpl->output;
    if ( !defined $out ) {
        $param->{enable_pre} = 1 unless $error =~ m/<pre>/;
        return
              "Cannot build error template; got error '"
            . encode_html( $tmpl->errstr )
            . "'. Giving up. Original error was: $error";
    }
    $app->run_callbacks( 'template_output.error', $app, \$out, $tmpl->param,
        $tmpl );
    return $app->l10n_filter($out);
}

sub show_login {
    my $app = shift;

    my $judge = 1;
    if ( $app->isa('MT::App::Upgrader') ) {
        my $class   = MT->model('failedlogin');
        my $ddl     = $class->driver->dbd->ddl_class;
        my $db_defs = $ddl->column_defs($class);
        $judge = 0 unless $db_defs;
    }
    if ($judge) {
        require MT::Lockout;
        if ( MT::Lockout->is_locked_out( $app, $app->remote_ip ) ) {
            $app->{hide_goback_button} = 1;
            return $app->errtrans("Invalid request");
        }
    }

    my ($param) = @_;
    $param ||= {};
    require MT::Auth;
    $app->build_page(
        'login.tmpl',
        {   error                => $app->errstr,
            no_breadcrumbs       => 1,
            login_fields         => MT::Auth->login_form($app),
            can_recover_password => MT::Auth->can_recover_password,
            delegate_auth        => MT::Auth->delegate_auth,
            build_blog_selector  => 0,
            build_menus          => 0,
            build_compose_menus  => 0,
            build_user_menus     => 0,
            %$param,
        }
    );
}

sub pre_run {
    my $app = shift;
    if ( my $auth = $app->user ) {
        if ( my $lang = $app->param('__lang') ) {
            $app->set_language($lang);
        }
        else {
            $app->set_language( $auth->preferred_language )
                if $auth->has_column('preferred_language');
        }
    }

    # allow language override
    my $lang = $app->session ? $app->session('lang') : '';
    $app->set_language($lang) if ($lang);
    if ( $lang = $app->param('__lang') ) {
        $app->set_language($lang);
        if ( $app->session ) {
            $app->session( 'lang', $lang );
            $app->session->save;
        }
    }

    $app->{breadcrumbs} = [];

    if ( $MT::DebugMode & 4 ) {
        $Data::ObjectDriver::PROFILE = 1;
        Data::ObjectDriver->profiler->reset;
    }

    MT->run_callbacks( ( ref $app ) . '::pre_run', $app );

    1;
}

sub post_run { MT->run_callbacks( ( ref $_[0] ) . '::post_run', $_[0] ); 1 }

sub reboot {
    my $app = shift;
    $app->{do_reboot} = 1;
    $app->set_header( 'Connection' => 'close' )
        if $ENV{FAST_CGI} || MT->config->PIDFilePath;
}

sub do_reboot {
    my $app = shift;

    return unless $app->{do_reboot};
    delete $app->{do_reboot};

    if ( $ENV{FAST_CGI} ) {
        require MT::Touch;
        MT::Touch->touch( 0, 'config' );

        if ( my $watchfile = MT->config->IISFastCGIMonitoringFilePath ) {
            require MT::FileMgr;
            my $fmgr = MT::FileMgr->new('Local');
            my $res = $fmgr->put_data( '', $watchfile );
            if ( !defined($res) ) {
                $app->log(
                    $app->translate(
                        "Failed to open monitoring file that specified by IISFastCGIMonitoringFilePath directive '[_1]': [_2]",
                        $watchfile,
                        $fmgr->errstr,
                    )
                );
                return 1;
            }
        }
    }
    if ( my $pidfile = MT->config->PIDFilePath ) {
        require MT::FileMgr;
        my $fmgr = MT::FileMgr->new('Local');
        my $pid;
        unless ( $pid = $fmgr->get_data($pidfile) ) {
            $app->log(
                $app->translate(
                    "Failed to open pid file [_1]: [_2]", $pidfile,
                    $fmgr->errstr,
                )
            );
            return 1;
        }
        chomp $pid;
        unless ( kill 'HUP', int($pid) ) {
            $app->log(
                $app->translate( "Failed to send reboot signal: [_1]", $!, )
            );
            return 1;
        }
        if (my $wait = MT->config->WaitAfterReboot) {
            require Time::HiRes;
            if (MT->config->DisableMetaRefresh) {
                my $until = Time::HiRes::time() + $wait;
                while ((my $sleep = $until - Time::HiRes::time()) > 0) {
                    Time::HiRes::sleep($sleep);
                }
            } else {
                Time::HiRes::sleep $wait;
            }
        }
    }
    1;
}

sub run {
    my $app = shift;
    my $q   = $app->param;

    my $timer;
    if ( $app->config->PerformanceLogging ) {
        $timer = $app->get_timer();
        $timer->pause_partial();
    }

    if ( my $cache_control = $app->config->HeaderCacheControl ) {
        $app->set_header( 'Cache-Control' => $cache_control );
    }

    $app->set_x_frame_options_header;
    $app->set_x_xss_protection_header;
    $app->set_referrer_policy;

    my ($body);

    # Declare these variables here for Perl 5.6.x
    # BugId:79755
    my ( $mode, $code, $requires_login, $get_method_info, $meth_info,
        @handlers );
    eval {

        # line __LINE__ __FILE__

        $mode = $app->mode || 'default';

        $requires_login  = $app->{requires_login};
        $get_method_info = sub {
            $code = $app->handlers_for_mode($mode);

            @handlers = ();
            @handlers = ref($code) eq 'ARRAY' ? @$code : ($code)
                if defined $code;

            $meth_info = {};
            $app->request( method_info => {} );
            foreach my $code (@handlers) {
                if ( ref $code eq 'HASH' ) {
                    $meth_info = $code;
                    $app->request( method_info => $meth_info );
                    $requires_login
                        = $requires_login & $meth_info->{requires_login}
                        if exists $meth_info->{requires_login};
                }
            }
        };
        $get_method_info->();

        $app->validate_request_params($meth_info) or die;

        require MT::Auth;
        if ( MT::Util::is_mod_perl1() ) {
            unless ( $app->{no_read_body} ) {
                my $status = $q->parse;
                unless ( $status == Apache::Constants::OK() ) {
                    die $app->translate('The file you uploaded is too large.')
                        . "\n<!--$status-->";
                }
            }
        }
        else {
            my $err;
            eval { $err = $q->cgi_error };
            unless ($@) {
                if ( $err && $err =~ /^413/ ) {
                    die $app->translate('The file you uploaded is too large.')
                        . "\n";
                }
            }
        }

    REQUEST:
        {

            if ($requires_login) {
                my ($author) = $app->login;
                if ( !$author || !$app->is_authorized ) {
                    if (  !$app->{login_again}
                        && $meth_info->{no_direct} )
                    {

                     # Direct mode call.
                     # We will be continue but all parameters will be deleted.
                        $app->param->delete_all();
                    }

                    $body
                        = ref($author) eq $app->user_class
                        ? $app->show_error( { error => $app->errstr } )
                        : $app->show_login();
                    last REQUEST;
                }
            }

            unless (@handlers) {
                my $meth = "mode_$mode";
                if ( $app->can($meth) ) {
                    no strict 'refs';
                    $code = \&{ *{ ref($app) . '::' . $meth } };
                    push @handlers, $code;
                }
            }

            if ( !@handlers ) {
                $app->error(
                    $app->translate( 'Unknown action [_1]', $mode ) );
                last REQUEST;
            }

            $app->response_content(undef);
            $app->{forward} = undef;

            $app->pre_run;
            foreach my $code (@handlers) {

                my $local_component;
                if ( ref $code eq 'HASH' ) {
                    my $meth_info = $code;
                    $code = $meth_info->{code} || $meth_info->{handler};
                    $local_component = $meth_info->{component}
                        if $meth_info->{component};

                    my $set = $meth_info->{permission}
                        || $meth_info->{permit_action};

                    if ($set) {
                        my $user    = $app->user;
                        my $perms   = $app->permissions;
                        my $blog    = $app->blog;
                        my $allowed = 0;
                        if ($user) {
                            my $admin = $user->is_superuser()
                                || ( $blog
                                && $perms
                                && $perms->can_administer_site() );
                            my @p = split /,/, $set;
                            foreach my $p (@p) {
                                $allowed = 1, last
                                    if $admin
                                    || ( $perms && $perms->can_do($p) );
                            }
                        }
                        unless ($allowed) {
                            $app->permission_denied();
                            last REQUEST;
                        }
                    }
                }

                if ( ref $code ne 'CODE' ) {
                    $code = $app->handler_to_coderef($code);
                }

                if ($code) {
                    my @forward_params = @{ $app->{forward_params} || [] };
                    $app->{forward_params} = undef;
                    local $app->{component} = $local_component
                        if $local_component;
                    my $content = $code->( $app, @forward_params );
                    $app->response_content($content)
                        if defined $content;
                }
            }

            $app->post_run;

            if ( my $new_mode = $app->{forward} ) {
                $mode = $new_mode;
                $get_method_info->();
                goto REQUEST;
            }

            $body = $app->response_content();

            if ( ref($body) && ( $body->isa('MT::Template') ) ) {
                defined( my $out = $app->build_page($body) )
                    or die $body->errstr;
                $body = $out;
            }

            unless ( defined $body
                || $app->{redirect}
                || $app->{login_again}
                || $app->{no_print_body} )
            {
                $body = $app->show_error( { error => $app->errstr } );
            }
            $app->error(undef);
        } ## end REQUEST block
    };

    if ( ( !defined $body ) && $app->{login_again} ) {

        # login again!
        $body = $app->show_login
            or $body = $app->show_error( { error => $app->errstr } );
    }
    elsif (!defined $body
        && !$app->{redirect}
        && !$app->{login_again}
        && !$app->{no_print_body} )
    {
        my $err = $app->errstr || $@;
        $body = $app->show_error( { error => $err } );
    }

    if ( ref($body) && ( $body->isa('MT::Template') ) ) {
        $body = $app->show_error( { error => $@ || $app->errstr } );
    }

    if ( my $url = $app->{redirect} ) {
        if ( !MT->config->DisableMetaRefresh and $app->{redirect_use_meta} ) {
            $app->send_http_header();
            $app->print( '<meta http-equiv="refresh" content="' . encode_html(MT->config->WaitAfterReboot). ';url=' . encode_html($url) . '">' );
        }
        else {
            if ( MT::Util::is_mod_perl1() ) {
                $app->{apache}->header_out( Location => $url );
                $app->response_code( Apache::Constants::REDIRECT() );
                $app->send_http_header;
            }
            else {
                $app->print(
                    $q->redirect( -uri => $url, %{ $app->{cgi_headers} } ) );
            }
        }
    }
    else {
        unless ( $app->{no_print_body} ) {
            $app->send_http_header;
            if ( $MT::DebugMode && !( $MT::DebugMode & 128 ) )
            {    # no need to emit twice
                if ( $body =~ m!</body>!i ) {
                    my $trace = '';
                    if ( $app->{trace} ) {
                        foreach ( @{ $app->{trace} } ) {
                            my $msg = encode_html($_);
                            $trace
                                .= '<li style="padding: 0.2em 0.5em; margin: 0">'
                                . $msg . '</li>' . "\n";
                        }
                    }
                    $trace = '<li style="padding: 0.2em 0.5em; margin: 0">'
                        . sprintf( "Request completed in %.3f seconds.",
                        Time::HiRes::time() - $app->{start_request_time} )
                        . "</li>\n"
                        . $trace;
                    if ( $trace ne '' ) {
                        my $debug_panel_header
                            = $app->translate('Warnings and Log Messages');
                        my $panel = <<"__HTML__";
                          <div class="col-12 mt-3">
                            <div class="card debug-panel" style="margin: 0 -15px;">
                              <div class="card-header text-white" style="background: #EF7678;">
                                <h4 class="my-0">$debug_panel_header</h4>
                              </div>
                              <div class="card-block p-4 debug-panel-inner" style="background: #FFE0E0;">
                                <ul class="list-unstyled" style="list-style: none; text-align: left">
                                  $trace
                                </ul>
                              </div>
                            </div>
                          </div>
__HTML__
                        $body =~ s!(</body>)!$panel$1!i;
                    }
                }
            }

            # Some browsers throw you to quirks mode if the doctype isn't
            # up front and leading whitespace makes a feed invalid.
            $body =~ s/\A(?:\s|\x{feff}|\xef\xbb\xbf)+(<(?:\?xml|!DOCTYPE))/$1/s if defined $body;

            $app->print_encode($body);
        }
    }

    if ($timer) {
        $timer->mark( ref($app) . '::run' );
    }

    $app->takedown();
}

sub forward {
    my $app = shift;
    my ( $new_mode, @params ) = @_;
    $app->{forward}        = $new_mode;
    $app->{forward_params} = \@params;
    return undef;
}

sub handlers_for_mode {
    my $app = shift;
    my ($mode) = @_;

    my $code;

    if ( my $meths = $Global_actions{ ref($app) }
        || $Global_actions{ $app->id } )
    {
        $code = $meths->{$mode} if exists $meths->{$mode};
    }

    $code ||= $app->{vtbl}{$mode};

    return undef unless $code;

    my @code;
    @code = ref($code) eq 'ARRAY' ? @$code : ($code);

    foreach my $hdlr (@code) {
        if ( $hdlr && ref $hdlr eq 'HASH' ) {
            if ( $hdlr->{condition} ) {
                my $cond = $hdlr->{condition};
                if ( !ref($cond) ) {
                    $cond = $hdlr->{condition}
                        = $app->handler_to_coderef($cond);
                }
                return undef unless $cond->($app);
            }

            my $handler = $hdlr->{code} || $hdlr->{handler};
            if ( $handler && $handler !~ m/->/ ) {
                $hdlr->{component} = $1
                    if $handler =~ m/^\$?(\w+)::/;
            }
        }
        else {
            if ( $hdlr =~ m/^\$?(\w+)::/ ) {
                $hdlr = { code => $hdlr, component => $1 };
            }
        }
    }
    return \@code;
}

sub mode {
    my $app = shift;
    if (@_) {
        $app->{mode} = shift;
    }
    else {
        if ( my $mode = $app->param('__mode') ) {
            $mode =~ s/[<>"']//g;
            $app->{mode} ||= $mode;
        }
    }
    $app->{mode} || $app->{default_mode} || 'default';
}

sub assert {
    my $app = shift;
    my $x   = shift;
    return 1 if $x;
    return $app->errtrans(@_);
}

sub takedown {
    my $app = shift;
    my $cfg = $app->config;

    MT->run_callbacks( ref($app) . '::take_down', $app )
        ;    # arg is the app object

    $app->touch_blogs;

    my $sess = $app->session;
    $sess->save if $sess && $sess->is_dirty;

    $app->user(undef);
    delete $app->{$_}
        for qw( cookies perms session trace response_content _blog
        WeblogPublisher init_request );

    my $driver = $MT::Object::DRIVER;
    $driver->clear_cache if $driver && $driver->can('clear_cache');

    require MT::Auth;
    MT::Auth->release;

    if ( $cfg->PerformanceLogging ) {
        $app->log_times();
    }

    # save_config here so not to miss any dirty config change to persist
    if ( UNIVERSAL::isa( $app, 'MT::App::Upgrader' ) ) {

        # mt_config table doesn't exist during installation
        if ( my $cfg_pkg = $app->model('config') ) {
            my $driver = $cfg_pkg->driver;
            if ( $driver->table_exists($cfg_pkg) ) {
                $cfg->save_config();
            }
        }
    }
    else {
        $cfg->save_config();
    }

    $app->request->finish;
    delete $app->{request};
    $app->do_reboot if $app->{do_reboot};

}

sub l10n_filter { $_[0]->translate_templatized( $_[1] ) }

sub load_widgets {
    my $app = shift;
    my ( $page, $scope_type, $param ) = @_;

    my $user = $app->user;
    my $blog = $app->blog;
    my $blog_id;
    $blog_id = $blog->id if $blog;
    my $scope
        = $scope_type eq 'blog'
        || $scope_type eq 'website' ? 'blog:' . $blog_id
        : $scope_type eq 'user'     ? 'user:' . $user->id
        :                             'system';
    my $resave_widgets = 0;
    my $widget_set     = $page . ':' . $scope;

    my $widget_store = $user->widgets;
    my $widgets;
    $widgets = $widget_store->{$widget_set} if $widget_store;

    unless ($widgets) {
        $resave_widgets = 1;
        $widgets        = $app->default_widgets_for_dashboard($scope_type);
    }

    my $reg_widgets = $app->registry("widgets");
    $reg_widgets
        = $app->filter_conditional_list( $reg_widgets, $page, $scope );
    my $all_widgets;
    foreach my $widget ( keys %$reg_widgets ) {
        if ( my $widget_view = $reg_widgets->{$widget}->{view} ) {
            if ( 'ARRAY' eq ref $widget_view ) {
                next
                    unless ( scalar grep { $_ eq $scope_type }
                    @$widget_view );
            }
            else {
                next if $scope_type ne $widget_view;
            }
            $all_widgets->{$widget} = $reg_widgets->{$widget};
        }
        else {
            $all_widgets->{$widget} = $reg_widgets->{$widget};
        }
    }

    my @ordered_list;
    my %orders;
    my $order_num = 0;
    foreach my $widget_id ( keys %$widgets ) {
        my $widget_param = $widgets->{$widget_id} ||= {};
        if ( my $order = $widget_param->{order} ) {
            $order_num = $order_num < $order ? $order : $order_num;
        }
    }
    foreach my $widget_id ( keys %$widgets ) {
        my $widget_param = $widgets->{$widget_id} ||= {};
        my $order;
        if ( !( $order = $widget_param->{order} ) ) {
            $order = $all_widgets->{$widget_id}{order};
            $order
                = $order && ref $order eq 'HASH'
                ? $all_widgets->{$widget_id}{order}{$scope_type}
                : $order * 100;
            $order = $order_num = $order_num + 100 unless defined $order;
            $widget_param->{order} = $order;
            $resave_widgets = 1;
        }
        push @ordered_list, $widget_id;
        $orders{$widget_id} = $order;
    }
    @ordered_list = sort { $orders{$a} <=> $orders{$b} } @ordered_list;

    $app->build_widgets(
        set         => $widget_set,
        param       => $param,
        widgets     => $all_widgets,
        widget_cfgs => $widgets,
        order       => \@ordered_list,
    ) or return;

    if ($resave_widgets) {
        my $widget_store = $user->widgets();
        $widget_store->{$widget_set} = $widgets;
        $user->widgets($widget_store);
        $user->save;
    }
    return $param;
}

sub build_widgets {
    my $app    = shift;
    my %params = @_;
    my ( $widget_set, $param, $widgets, $widget_cfgs, $order,
        $passthru_param )
        = @params{qw( set param widgets widget_cfgs order passthru_param )};
    $widget_cfgs    ||= {};
    $order          ||= [ keys %$widgets ];
    $passthru_param ||= [qw( html_head css_include js_include )];

    my $blog = $app->blog;
    my $blog_id;
    $blog_id = $blog->id if $blog;

    # The list of widgets in a user's record
    # is going to look like this:
    #    xxx-1
    #    xxx-2
    #    yyy-1
    #    zzz
    # Any numeric suffix is just a means to distinguish
    # the instance of the widget from other instances.
    # The actual widget id is this minus the instance number.
    foreach my $widget_inst (@$order) {
        my $widget_id = $widget_inst;
        $widget_id =~ s/-\d+$//;
        my $widget = $widgets->{$widget_id};
        next unless $widget;
        my $widget_cfg = $widget_cfgs->{$widget_inst} || {};
        my $widget_param = { %$param, %{ $widget_cfg->{param} || {} } };
        foreach (@$passthru_param) {
            $widget_param->{$_} = '';
        }
        my $tmpl_name = $widget->{template};

        my $p = $widget->{plugin};
        my $tmpl;
        if ($p) {
            $tmpl = $p->load_tmpl($tmpl_name);
        }
        else {

            # This is probably never used since all
            # widgets in reality are provided through
            # some sort of component/plugin.
            $tmpl = $app->load_tmpl($tmpl_name);
        }
        next unless $tmpl;
        $tmpl_name = '.' . $tmpl_name;
        $tmpl_name =~ s/\.tmpl$//;

        my $set = $widget->{set} || $widget_cfg->{set} || 'main';
        local $widget_param->{blog_id}         = $blog_id;
        local $widget_param->{widget_block}    = $set;
        local $widget_param->{widget_id}       = $widget_inst;
        local $widget_param->{widget_mobile}   = $widget->{mobile} ? 1 : 0;
        local $widget_param->{widget_scope}    = $widget_set;
        local $widget_param->{widget_singular} = $widget->{singular} || 0;
        local $widget_param->{magic_token}     = $app->current_magic;
        local $widget_param->{build_menus}     = 0;
        local $widget_param->{build_blog_selector} = 0;
        local $widget_param->{build_compose_menus} = 0;

        if ( my $h = $widget->{code} || $widget->{handler} ) {
            $h = $app->handler_to_coderef($h);
            $h->( $app, $tmpl, $widget_param );
        }
        my $ctx = $tmpl->context;
        if ($blog) {
            $ctx->stash( 'blog_id', $blog_id );
            $ctx->stash( 'blog',    $blog );
        }

        $app->run_callbacks( 'template_param' . $tmpl_name,
            $app, $tmpl->param, $tmpl );

        my $content = $app->build_page( $tmpl, $widget_param );

        if ( !defined $content ) {
            return $app->error(
                "Error processing template for widget $widget_id: "
                    . $tmpl->errstr );
        }

        $app->run_callbacks( 'template_output' . $tmpl_name,
            $app, \$content, $tmpl->param, $tmpl );

        $param->{$set} ||= '';
        $param->{$set} .= $content;

        # Widgets often need to populate script/styles/etc into
        # the header; these are special app-template variables
        # that collect this content and display them in the
        # header. No other widget-parameters are to leak into the
        # parent template parameter namespace (ie, a widget cannot
        # set/alter the page_title).
        foreach (@$passthru_param) {
            $param->{$_} = ( $param->{$_} || '' ) . "\n" . $tmpl->param($_);
        }
    }

    return $param;
}

sub update_widget_prefs {
    my $app  = shift;
    my $user = $app->user;
    $app->validate_magic or return;

    my $blog = $app->blog;
    my $blog_id;
    $blog_id = $blog->id if $blog;
    my $widget_id     = $app->param('widget_id');
    my $action        = $app->param('widget_action');
    my $widget_scope  = $app->param('widget_scope');
    my $widgets       = $user->widgets || {};
    my $these_widgets = $widgets->{$widget_scope} ||= {};
    my $resave_widgets;
    my $result = {};

    if ( ( $action eq 'remove' ) && $these_widgets ) {
        $result->{message} = $app->translate( "Removed [_1].", $widget_id );
        if ( delete $these_widgets->{$widget_id} ) {
            $resave_widgets = 1;
        }
    }

    if ( $action eq 'add' ) {
        my $set = $app->param('widget_set') || 'main';
        my $all_widgets = $app->registry("widgets");
        if ( my $widget = $all_widgets->{$widget_id} ) {
            my $widget_inst = $widget_id;
            unless ( $widget->{singular} ) {
                my $num = 1;
                while ( exists $these_widgets->{$widget_inst} ) {
                    $widget_inst = $widget_id . '-' . $num;
                    $num++;
                }
            }
            $these_widgets->{$widget_inst} = { set   => $set };
            $these_widgets->{$widget_inst} = { param => $widget->{param} }
                if exists $widget->{param};

            # Renumbering widget order
            my $widget_count = keys %$these_widgets;
            foreach my $widget_id ( keys %$these_widgets ) {
                if ( my $widget = $all_widgets->{$widget_id} ) {
                    my @widget_scopes = split ':', $widget_scope;
                    my $order = $widget->{order};
                    $order
                        = $order && ref $order eq 'HASH'
                        ? $widget->{order}{ $widget_scopes[1] }
                        : $order * 100;
                    if ($order) {
                        $these_widgets->{$widget_id} = { order => $order };
                    }
                    else {
                        $these_widgets->{$widget_id}
                            = { order => $widget_count++ * 100 };
                    }
                }
            }
        }
        $resave_widgets = 1;
    }

    if ( ( $action eq 'save' ) && $these_widgets ) {
        my %all_params = $app->param_hash;
        my $refresh = $all_params{widget_refresh} ? 1 : 0;
        delete $all_params{$_}
            for
            qw( json widget_id widget_action __mode widget_set widget_singular widget_refresh magic_token widget_scope return_args );
        $these_widgets->{$widget_id}{param} = {};
        $these_widgets->{$widget_id}{param}{$_} = $all_params{$_}
            for keys %all_params;
        $widgets->{$widget_scope} = $these_widgets;
        $resave_widgets = 1;
        if ($refresh) {
            $result->{html} = 'widget!';    # $app->render_widget();
        }
    }
    if ($resave_widgets) {
        $user->widgets($widgets);
        $user->save;
    }
    if ( $app->param('json') ) {
        return $app->json_result($result);
    }
    else {
        $app->add_return_arg( 'saved' => 1 );
        $app->call_return;
    }
}

sub load_widget_list {
    my $app = shift;
    my ( $page, $scope_type, $param ) = @_;

    my $blog = $app->blog;
    my $blog_id;
    $blog_id = $blog->id if $blog;
    my $user = $app->user;
    my $scope
        = $scope_type eq 'blog'
        || $scope_type eq 'website' ? 'blog:' . $blog_id
        : $scope_type eq 'user'     ? 'user:' . $user->id
        :                             'system';
    $scope = $page . ':' . $scope;

    my $user_widgets = $app->user->widgets || {};
    $user_widgets
        = $user_widgets->{$scope}
        || $app->default_widgets_for_dashboard($scope_type)
        || {};
    my %in_use;
    foreach my $uw ( keys %$user_widgets ) {
        $uw =~ s/-\d+$//;
        $in_use{$uw} = 1;
    }

    my $all_widgets = $app->registry("widgets");
    my $widgets     = [];

    # First, filter out any 'singular' widgets that are already
    # in the user's widget bag
    foreach my $id ( keys %$all_widgets ) {
        my $w = $all_widgets->{$id};
        if ( $w->{singular} ) {

            # don't allow multiple widgets
            next if exists $in_use{$id};
        }
        if ( my $widget_view = $w->{view} ) {
            if ( 'ARRAY' eq ref $widget_view ) {
                next
                    unless ( scalar grep { $_ eq $scope_type }
                    @$widget_view );
            }
            else {
                next if $scope_type ne $widget_view;
            }
        }

        $w->{id} = $id;
        push @$widgets, $w;
    }

    # Now filter remaining widgets based on any permission
    # or declared condition
    $widgets = $app->filter_conditional_list( $widgets, $page, $scope );

    # Finally, build the widget loop, but don't include
    # any widgets that are unlabeled, since these are
    # added by the system and cannot be manually added.
    my @widget_loop;
    foreach my $w (@$widgets) {
        my $label = $w->{label} or next;
        $label = $label->() if ref($label) eq 'CODE';
        next unless $label;
        push @widget_loop,
            {
            widget_id => $w->{id},
            ( $w->{set} ? ( widget_set => $w->{set} ) : () ),
            widget_label => $label,
            ( $w->{param} ? ( param => $w->{param} ) : () ),
            };
    }
    @widget_loop
        = sort { $a->{widget_label} cmp $b->{widget_label} } @widget_loop;
    $param->{widget_scope}    = $scope;
    $param->{all_widget_loop} = \@widget_loop;
}

sub load_list_actions {
    my $app = shift;
    my ( $type, $param, @p ) = @_;
    my $all_actions = $app->list_actions( $type, @p );
    if ( ref($all_actions) eq 'ARRAY' ) {
        my @plugin_actions;
        my @core_actions;
        my @button_actions;
        foreach my $a (@$all_actions) {
            if ( $a->{button} ) {
                push @button_actions, $a;
            }
            elsif ( $a->{core} ) {
                push @core_actions, $a;
            }
            else {
                push @plugin_actions, $a;
            }
        }
        $param->{more_list_actions} = \@plugin_actions;
        $param->{list_actions}      = \@core_actions;
        $param->{button_actions}    = \@button_actions;
        $param->{all_actions}       = $all_actions;
        $param->{has_pulldown_actions}
            = ( @plugin_actions || @core_actions ) ? 1 : 0;
        $param->{has_mobile_pulldown_actions}
            = ( grep { $_->{mobile} } @$all_actions )
            ? 1
            : 0;
        $param->{has_list_actions} = scalar @$all_actions;
    }
    my $filters = $app->list_filters( $type, @p );
    $param->{list_filters} = $filters if $filters;
    return $param;
}

sub load_content_actions {
    my $app = shift;
    my ( $type, $param, @p ) = @_;
    my $all_actions = $app->content_actions( $type, @p );
    if ( ref($all_actions) eq 'ARRAY' ) {
        $param->{content_actions} = $all_actions;
    }
    return $param;
}

sub current_magic {
    my $app  = shift;
    my $sess = $app->session;
    return ( $sess ? $sess->get('magic_token') : undef );
}

sub validate_magic {
    my $app = shift;
    return 1
        if $app->param('username')
        && $app->param('password')
        && $app->request('fresh_login');
    $app->{login_again} = 1, return undef
        unless ( $app->current_magic || '' ) eq
        ( $app->param('magic_token') || '' );
    1;
}

sub delete_param {
    my $app   = shift;
    my ($key) = @_;
    my $q     = $app->{query};
    return unless $q;
    if ( MT::Util::is_mod_perl1() ) {
        my $tab = $q->parms;
        $tab->unset($key);
    }
    else {
        $q->delete($key);
    }
}

sub param_hash {
    my $app = shift;
    my $q   = $app->{query};
    return () unless $q;
    my @params = $app->multi_param();
    my %result;
    foreach my $p (@params) {
        $result{$p} = $q->param($p);
    }
    %result;
}

sub validate_param {
    my ($app, $rules) = @_;
    return 1 if $app->config->DisableValidateParam;

    require MT::ParamValidator;
    unless ($MT::ParamValidator::Initialized) {
        my $handlers = $app->registry('param_validator') || {};
        for my $name (keys %$handlers) {
            next unless $name && $name =~ /^[A-Za-z][A-Za-z0-9_]*$/;
            my $code = $app->handler_to_coderef($handlers->{$name});
            MT::ParamValidator->set_handler($name => $code);
        }
        $MT::ParamValidator::Initialized = 1;
    }
    my $validator = MT::ParamValidator->new($rules) or return $app->error(MT::ParamValidator->errstr);
    my $res = $validator->validate_param($app);
    if (!$res) {
        if ($MT::DebugMode) {
            return $app->error($validator->errstr);
        } else {
            return $app->error(MT->translate("Invalid request."));
        }
    }
    return $res;
}

## Path/server/script-name determination methods

sub query_string {
    my $app = shift;
    MT::Util::is_mod_perl1()
        ? $app->{apache}->args
        : $app->{query}->query_string;
}

sub return_uri {
    my ( $uri, $query ) = ( $_[0]->uri, $_[0]->return_args );
    return $uri if !defined $query or $query eq "";
    $uri . '?' . $query;
}

sub call_return {
    my $app = shift;
    $app->add_return_arg(@_) if @_;
    my $connection = $app->get_header('Connection') || '';
    $app->redirect( $app->return_uri,
        ( $connection eq 'close' ? ( UseMeta => 1 ) : () ) );
}

sub state_params {
    my $app = shift;
    return $app->{state_params} ? @{ $app->{state_params} } : ();
}

# make_return_args
# Creates a query string that refers to the same view as the one we're
# already rendering.
sub make_return_args {
    my $app = shift;

    my @vars = $app->state_params;
    my %args;
    foreach my $v (@vars) {
        if ( my @p = $app->multi_param($v) ) {
            $args{$v}
                = ( scalar @p > 1
                    && ( $v eq 'filter_val' || $v eq 'filter' ) )
                ? \@p
                : $p[0];
        }
    }
    my $return = $app->uri_params( mode => $app->mode, 'args' => \%args );
    $return =~ s/^\?//;
    $return;
}

sub return_args {
    $_[0]->{return_args} = $_[1] if $_[1];
    $_[0]->{return_args};
}

sub add_return_arg {
    my $app = shift;
    if ( scalar @_ == 1 ) {
        $app->{return_args} .= '&' if $app->{return_args};
        $app->{return_args} .= shift;
    }
    else {
        my (%args) = @_;
        foreach my $a ( sort keys %args ) {
            $app->{return_args} .= '&' if $app->{return_args};
            if ( ref $args{$a} eq 'ARRAY' ) {
                $app->{return_args} .= $a . '=' . encode_url($_)
                    foreach @{ $args{$a} };
            }
            else {
                $app->{return_args} .= $a . '=' . encode_url( $args{$a} );
            }
        }
    }
}

sub base {
    my $app = shift;
    return $app->{__host} if exists $app->{__host};
    my $cfg = $app->config;
    my $path
        = $app->{is_admin}
        ? ( $cfg->AdminCGIPath || $cfg->CGIPath )
        : $cfg->CGIPath;
    if ( $path =~ m!^(https?://[^/]+)!i ) {
        ( my $host = $1 ) =~ s!/$!!;
        return $app->{__host} = $host;
    }

    # determine hostname from environment (supports relative CGI paths)
    if ( my $host = $ENV{HTTP_HOST} ) {
        return $app->{__host}
            = 'http' . ( $app->is_secure ? 's' : '' ) . '://' . $host;
    }
    '';
}

*path = \&mt_path;

sub mt_path {
    my $app = shift;
    return $app->{__mt_path} if exists $app->{__mt_path};

    my $cfg = $app->config;
    my $path;
    $path
        = $app->{is_admin}
        ? ( $cfg->AdminCGIPath || $cfg->CGIPath )
        : $cfg->CGIPath;
    if ( $path && $path =~ m!^https?://[^/]+(/?.*)$!i ) {
        $path = $1;
    }
    elsif ( !$path ) {
        $path = '/';
    }
    $path .= '/' unless substr( $path, -1, 1 ) eq '/';
    $app->{__mt_path} = $path;
}

sub app_path {
    my $app = shift;
    return $app->{__path} if exists $app->{__path};

    my $path;
    if ( MT::Util::is_mod_perl1() ) {
        $path = $app->{apache}->uri;
        $path =~ s!/[^/]*$!!;
    }
    elsif ( $app->{query} ) {
        local $ENV{PATH_INFO} = q()
            if (
            ( exists( $ENV{PERLXS} ) && $ENV{PERLXS} eq "PerlIS" )
            || (   defined( $ENV{SERVER_SOFTWARE} )
                && $ENV{SERVER_SOFTWARE} =~ /IIS/
                && $ENV{FAST_CGI} )
            );
        $path = $app->{query}->url;
        $path =~ s!/[^/]*$!!;

        # '@' within path is okay; this is for Yahoo!'s hosting environment.
        $path =~ s/%40/@/;
    }
    else {
        $path = $app->mt_path;
    }
    if ( $path =~ m!^https?://[^/]+(/?.*)$!i ) {
        $path = $1;
    }
    elsif ( !$path ) {
        $path = '/';
    }
    $path .= '/' unless substr( $path, -1, 1 ) eq '/';
    $app->{__path} = $path;
}

sub envelope {
    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.8');
    '';
}

sub script {
    my $app = shift;
    return $app->{__script} if exists $app->{__script};
    my $script
        = MT::Util::is_mod_perl1() ? $app->{apache}->uri : $ENV{SCRIPT_NAME};
    if ( !$script ) {
        require File::Basename;
        import File::Basename qw(basename);
        $script = basename($0);
    }
    $script =~ s!/$!!;
    $script = ( split /\//, $script )[-1];
    $app->{__script} = $script;
}

sub uri {
    my $app = shift;
    $app->{is_admin} ? $app->mt_uri(@_) : $app->app_uri(@_);
}

sub app_uri {
    my $app = shift;
    $app->app_path . $app->script . $app->uri_params(@_);
}

# app_uri refers to the active app script
sub mt_uri {
    my $app = shift;
    $app->mt_path . $app->config->AdminScript . $app->uri_params(@_);
}

# mt_uri refers to mt's script even if we're in a plugin.
sub uri_params {
    my $app = shift;
    my (%param) = @_;
    my @params;
    push @params, '__mode=' . $param{mode} if $param{mode};
    if ( $param{args} ) {
        foreach my $p ( keys %{ $param{args} } ) {
            if ( ref $param{args}{$p} eq 'ARRAY' ) {
                push @params, ( $p . '=' . encode_url($_) )
                    foreach @{ $param{args}{$p} };
            }
            else {
                push @params, ( $p . '=' . encode_url( $param{args}{$p} ) )
                    if defined $param{args}{$p};
            }
        }
    }
    @params ? '?' . ( join '&', @params ) : '';
}

sub path_info {
    my $app = shift;
    return $app->{__path_info} if exists $app->{__path_info};
    my $path_info;
    if ( MT::Util::is_mod_perl1() ) {
        ## mod_perl often leaves part of the script name (Location)
        ## in the path info, for some reason. This should remove it.
        $path_info = $app->{apache}->path_info;
        if ($path_info) {
            my ($script_last) = $app->{apache}->location =~ m!/([^/]+)$!;
            $path_info =~ s!^/$script_last!!;
        }
    }
    else {
        return undef unless $app->{query};
        $path_info = $app->{query}->path_info;

        my $script_name = $ENV{SCRIPT_NAME};
        $path_info =~ s!^$script_name!!
            if $script_name;
    }
    $app->{__path_info} = $path_info;
}

sub is_secure {
    my $app = shift;
    if ( MT::Util::is_mod_perl1() ) {
        return $app->{apache}->subprocess_env('https');
    }
    else {
        return
              $app->{query}->protocol() eq 'https' ? 1
            : ( $app->get_header('X-Forwarded-Proto') || '' ) eq 'https' ? 1
            :                                                              0;
    }
}

sub redirect {
    my $app = shift;
    my ( $url, %options ) = @_;
    $url =~ s/[\r\n].*$//s;
    $app->{redirect_use_meta} = $options{UseMeta};
    unless ( $url =~ m!^https?://!i ) {
        $url = $app->base . $url;
    }
    $app->{redirect} = $url;
    return;
}

sub redirect_to_home {
    my $app = shift;
    my $uri = MT::Util::is_mod_perl1()
        ? $app->{apache}->uri
        : $app->{query}->url( -pathinfo => 1, -query => 0, -full => 1 );
    return $app->redirect($uri);
}

sub is_valid_redirect_target {
    my ( $app, $target ) = @_;

    my @urls;
    my $blog_id = $app->param('blog_id');
    if ( $blog_id && $blog_id !~ /\D/ ) {
        my $blog = MT::Blog->load($blog_id)
            or return $app->errtrans( 'Cannot load site #[_1].', $blog_id );
        push @urls, $blog->site_url;
    }
    else {
        my @sites = MT::Blog->load( { class => '*' } );
        for my $site (@sites) {
            push @urls, $site->site_url;
        }
    }
    if ( my $base = $app->base ) {
        push @urls, $base;
    }
    if ( MT->config->ReturnToURL ) {
        push @urls, MT->config->ReturnToURL;
    }

    require URI;

    my @hosts;
    my %seen;
    for my $url (@urls) {
        my $uri = URI->new( $url, 'http' )->canonical;
        next unless $uri->isa('URI::http');
        my $host = $uri->host or next;
        next if $seen{$host}++;
        push @hosts, $host;
    }

    if ( defined $target ) {
        return $app->_is_valid_redirect_target( $target, \@hosts );
    }
    else {
        ## for backward compatibility
        my @targets = grep { defined $_ && $_ ne '' }
            map { scalar $app->param($_) } qw/static return_url return_to/;
        push @targets, '' unless @targets;
        for my $target (@targets) {
            next if $target eq '0';
            if ( ( $target eq '' ) || ( $target eq '1' ) ) {
                require MT::Entry;
                my $entry_id = $app->param('entry_id') || 0;
                my $entry    = MT::Entry->load($entry_id)
                    or return $app->error(
                    $app->translate( 'Cannot load entry #[_1].', $entry_id )
                    );
                $target = $entry->archive_url;
            }
            $app->_is_valid_redirect_target( $target, \@hosts )
                or return;
        }
        ## now all of the targets are validated
        return 1;
    }
}

sub _is_valid_redirect_target {
    my ( $app, $target, $allowed_hosts ) = @_;
    return if $target =~ /[[:cntrl:]]|\\/;
    my $uri  = URI->new( $target, 'http' )->canonical;
    my $host = $uri->host;
    my $path = $uri->path;
    return   unless $uri->isa('URI::http');
    return   unless substr( $path, 0, 1 ) eq '/';
    # If relative, $target should be one of the app scripts (usually mt.cgi)
    if (!defined $host) {
        return ($path eq URI->new($app->uri)->path) ? 1 : 0;
    }
    for my $allowed ( @{ $allowed_hosts || [] } ) {
        return 1 if $allowed eq $host;
    }
    return;
}

sub param {
    my $app = shift;
    return unless $app->{query};
    Carp::carp "app->param called in list context; use app->multi_param"
        if wantarray;
    if (@_) {
        $app->{query}->param(@_);
    }
    else {
        wantarray ? ( $app->{query}->param ) : $app->{query};
    }
}

sub multi_param {
    my $app = shift;
    return unless $app->{query};
    local $CGI::LIST_CONTEXT_WARN = 0;
    ( $app->{query}->param(@_) );
}

sub blog {
    my $app = shift;
    $app->{_blog} = shift if @_;
    return $app->{_blog} if $app->{_blog};
    return undef unless $app->{query};
    my $blog_id = $app->param('blog_id');
    if ($blog_id) {
        require MT::Blog;
        my $blog = MT::Blog->load($blog_id);
        $app->{_blog} = $blog;
    }
    return $app->{_blog};
}

## Logging/tracing

sub log {
    my $app = shift;
    unless ($MT::plugins_installed) {

        # finish init_schema here since we have to log something
        # to the database.
        $app->init_schema();
    }
    my ($msg) = @_;
    require MT::Log;
    my $log = MT::Log->new;
    if ( ref $msg eq 'HASH' ) {
        $log->set_values($msg);
        $msg = $msg->{'message'} || '';
    }
    elsif ( ( ref $msg ) && ( UNIVERSAL::isa( $msg, 'MT::Log' ) ) ) {
        $log = $msg;
    }
    else {
        $log->message($msg);
    }
    $log->ip( $app->remote_ip );
    if ( !$log->blog_id ) {
        my $blog = $app->blog;
        $log->blog_id( $blog->id ) if $blog;
    }
    if ( !$log->author_id ) {
        my $user = $app->user;
        $log->author_id( $user->id ) if $user;
    }
    $log->level( MT::Log::INFO() )
        unless defined $log->level;
    $log->class('system')
        unless defined $log->class;
    $log->save;

    require MT::Util::Log;
    MT::Util::Log::init();
    my $method
        = $log->level == MT::Log::DEBUG()    ? 'debug'
        : $log->level == MT::Log::INFO()     ? 'info'
        : $log->level == MT::Log::NOTICE()   ? 'notice'
        : $log->level == MT::Log::WARNING()  ? 'warn'
        : $log->level == MT::Log::ERROR()    ? 'error'
        : $log->level == MT::Log::SECURITY() ? 'error'
        :                                      'none';
    MT::Util::Log->$method( $log->message );
}

sub trace {
    my $app = shift;
    $app->{trace} ||= [];
    if ( $MT::DebugMode & 2 ) {
        require Carp;
        my $msg = "@_";
        chomp $msg;
        push @{ $app->{trace} }, Carp::longmess($msg);
    }
    else {
        push @{ $app->{trace} }, "@_";
    }
    if ( $MT::DebugMode & 128 ) {
        my @caller = caller(1);
        my $place
            = $caller[0] . '::'
            . $caller[3] . ' in '
            . $caller[1]
            . ', line '
            . $caller[2];
        if ( $MT::DebugMode & 2 ) {
            my $msg = "@_";
            chomp $msg;
            print STDERR Carp::longmess("(warn from $place) $msg");
        }
        else {
            print STDERR "(warn from $place) @_\n";
        }
    }
}

sub remote_ip {
    my $app = shift;

    my $trusted = $app->config->TransparentProxyIPs || 0;
    my $remote_ip = (
        MT::Util::is_mod_perl1()
        ? $app->{apache}->connection->remote_ip
        : $ENV{REMOTE_ADDR}
    );
    $remote_ip ||= '127.0.0.1';
    my $ip
        = $trusted
        ? ( $app->get_header('X-Forwarded-For') || '' )
        : $remote_ip;
    if ($trusted) {
        if ( $trusted =~ m/^\d+$/ ) {

            # TransparentProxyIPs of 1, means to use the
            # right-most IP from X-Forwarded-For (remote_ip is the proxy)
            # TransparentProxyIPs of 2, means to use the
            # next-to-last IP from X-Forwarded-For.
            $trusted--;    # assumes numeric value
            my @iplist = reverse split /\s*,\s*/, $ip;
            if (@iplist) {
                do {
                    $ip = $iplist[ $trusted-- ];
                } while ( $trusted >= 0 && !$ip );
                $ip ||= $remote_ip;
            }
            else {
                $ip = $remote_ip;
            }
        }
        elsif ( $trusted =~ m/^\d+\./ ) {    # looks IP-ish
                # In this form, TransparentProxyIPs can be a list of
                # IP or subnet addresses to exclude as trusted IPs
                # TransparentProxyIPs 10.1.1., 12.34.56.78
            my @trusted = split /\s*,\s*/, $trusted;
            my @iplist = reverse split /\s*,\s*/, $ip;
            while ( @iplist && grep( { $iplist[0] =~ m/^\Q$_\E/ } @trusted ) )
            {
                shift @iplist;
            }
            $ip = @iplist ? $iplist[0] : $remote_ip;
        }
    }

    return $ip;
}

sub document_root {
    my $app = shift;
    my $cwd = '';
    if ( MT::Util::is_mod_perl1() ) {
        ## If mod_perl, just use the document root.
        $cwd = $app->{apache}->document_root;
    }
    else {
        $cwd = $ENV{DOCUMENT_ROOT} || $app->mt_dir;
    }
    $cwd = File::Spec->canonpath($cwd);
    $cwd =~ s!([\\/])cgi(?:-bin)?([\\/].*)?$!$1!;
    $cwd =~ s!([\\/])mt[\\/]?$!$1!i;
    return $cwd;
}

sub errtrans {
    my $app = shift;
    return $app->error( $app->translate(@_) );
}

sub permission_denied {
    my $app = shift;
    return $app->error(
        $app->translate('You did not have permission for this action.') );
}

sub DESTROY {
    ## Destroy the Request object, which is used for caching
    ## per-request data. We have to do this manually, because in
    ## a persistent environment, the object will not go out of scope.
    ## Same with the ConfigMgr object and ObjectDriver.
    MT::Request->finish();
    undef $MT::Object::DRIVER;
    undef $MT::Object::DBI_DRIVER;
    undef $MT::ConfigMgr::cfg;
}

sub set_no_cache {
    my $app = shift;
    ## Add the Pragma: no-cache header.
    if ( MT::Util::is_mod_perl1() ) {
        $app->{apache}->no_cache(1);
    }
    else {
        $app->param->cache('no');
    }
}

sub verify_password_strength {
    my ( $app, $username, $pass ) = @_;
    my @constrains = $app->config('UserPasswordValidation');
    my $min_length = $app->config('UserPasswordMinLength');

    if ( ( $min_length =~ m/\D/ ) or ( $min_length < 1 ) ) {
        $min_length = $app->config->default('UserPasswordMinLength');
    }

    if ( length $pass < $min_length ) {
        return $app->translate(
            "Password should be longer than [_1] characters", $min_length );
    }
    if ( $username && index( lc($pass), lc($username) ) >= 0 ) {
        return $app->translate("Password should not include your Username");
    }
    if ( ( grep { $_ eq 'letternumber' } @constrains )
        and not( $pass =~ /[a-zA-Z]/ and $pass =~ /\d/ ) )
    {
        return $app->translate("Password should include letters and numbers");
    }
    if ( ( grep { $_ eq 'upperlower' } @constrains )
        and not( $pass =~ /[a-z]/ and $pass =~ /[A-Z]/ ) )
    {
        return $app->translate(
            "Password should include lowercase and uppercase letters");
    }
    if ( ( grep { $_ eq 'symbol' } @constrains )
        and not $pass =~ m'[!"#$%&\'\(\|\)\*\+,-\.\/\\:;<=>\?@\[\]^_`{}~]' )
    {
        return $app->translate(
            'Password should contain symbols such as #!$%');
    }

    return;
}

1;
__END__

=head1 NAME

MT::App - Movable Type base web application class

=head1 SYNOPSIS

    package MT::App::Foo;
    use MT::App;
    @MT::App::Foo::ISA = qw( MT::App );

    package main;
    my $app = MT::App::Foo->new;
    $app->run;

=head1 DESCRIPTION

L<MT::App> is the base class for Movable Type web applications. It provides
support for an application running using standard CGI, or under
L<Apache::Registry>, or as a L<mod_perl> handler. L<MT::App> is not meant to
be used directly, but rather as a base class for other web applications using
the Movable Type framework (for example, L<MT::App::CMS>).

=head1 USAGE

L<MT::App> subclasses the L<MT> class, which provides it access to the
publishing methods in that class.

=head1 CALLBACKS

=over 4

=item <package>::template_source

=item <package>::template_source.<filename>

    callback($eh, $app, \$tmpl)

Executed after loading the MT::Template file.  The E<lt>packageE<gt> portion
is the full package name of the application running. For example,

    MT::App::CMS::template_source.menu

Is the full callback name for loading the menu.tmpl file under the
L<MT::App::CMS> application. The "MT::App::CMS::template_source" callback is
also invoked for all templates loading by the CMS.  Finally, you can also hook
into:

    *::template_source

as a wildcard callback name to capture any C<MT::Template> files that are
loaded regardless of application.

=item <package>::template_param

=item <package>::template_param.<filename>

    callback($eh, $app, \%param, $tmpl)

This callback is invoked in conjunction with the MT::App-E<gt>build_page
method. The $param argument is a hashref of L<MT::Template> parameter
data that will eventually be passed to the template to produce the page.

=item <package>::template_output

=item <package>::template_output.<filename>

    callback($eh, $app, \$tmpl_str, \%param, $tmpl)

This callback is invoked in conjunction with the MT::App-E<gt>build_page
method. The C<$tmpl_str> parameter is a string reference for the page that
was built by the MT::App-E<gt>build_page method. Since it is a reference,
it can be modified by the callback. The C<$param> parameter is a hash reference to the parameter data that was given to build the page. The C<$tmpl>
parameter is the L<MT::Template> object used to generate the page.

=back

=head1 METHODS

Following are the list of methods specific to L<MT::App>:

=head2 MT::App->new

Constructs and returns a new L<MT::App> object.

=head2 $app->init_request

Invoked at the start of each request. This method is a good place to
initialize any settings that are request-specific. When overriding this
method, B<always> call the superclass C<init_request> method.

One such setting is the C<requires_login> member element that controls
whether the active application mode requires the user to login first.

Example:

    sub init_request {
        my $app = shift;
        $app->SUPER::init_request(@_);
        $app->{requires_login} = 1 unless $app->mode eq 'unprotected';
    }

=head2 $app->reboot

Reboot all MT instance. Now, this method sends SIGHUP to the process manager
which specified by PIDFilePath config directive. If PIDFilePath isn't set, no
signals would be sent.

=head2 $app->run

Runs the application. This gathers the input, chooses the method to execute,
executes it, and prints the output to the client.

If an error occurs during the execution of the application, L<run> handles all
of the errors thrown either through the L<MT::ErrorHandler> or through C<die>.

=head2 $app->login

Checks the user's credentials, first by looking for a login cookie, then by
looking for the C<username> and C<password> CGI parameters. In both cases,
the username and password are verified for validity. This method does not set
the user's login cookie, however--that should be done by the caller (in most
cases, the caller is the L<run> method).

On success, returns the L<MT::Author> object representing the author who logged
in, and a boolean flag; if the boolean flag is true, it indicates the the login
credentials were obtained from the CGI parameters, and thus that a cookie
should be set by the caller. If the flag is false, the credentials came from
an existing cookie.

On an authentication error, L<login> removes any authentication cookies that
the user might have on his or her browser, then returns C<undef>, and the
error message can be obtained from C<$app-E<gt>errstr>.

=head2 $app->logout

A handler method for logging the user out of the application.

=head2 $app->send_http_header([ $content_type ])

Sends the HTTP header to the client; if C<$content_type> is specified, the
I<Content-Type> header is set to C<$content_type>. Otherwise, C<text/html> is
used as the default.

In a L<mod_perl> context, this calls the L<Apache::send_http_header> method;
in a CGI context, the L<CGI::header> method is called.

=head2 $app->print(@data)

Sends data C<@data> to the client.

In a L<mod_perl> context, this calls the L<Apache::print> method; in a CGI
context, data is printed directly to STDOUT.

=head2 $app->bake_cookie(%arg)

Bakes a cookie to be sent to the client.

C<%arg> can contain any valid parameters to the C<new> methods of
L<CGI::Cookie> (or L<Apache::Cookie>--both take the same parameters). These
include C<-name>, C<-value>, C<-path>, C<-secure>, and C<-expires>.

If you do not include the C<-path> parameter in C<%arg>, it will be set
automatically to C<$app-E<gt>path> (below).

In a L<mod_perl> context, this method uses L<Apache::Cookie>; in a CGI context,
it uses L<CGI::Cookie>.

This method will automatically assign a "secure" flag for the cookie if it the current HTTP request is using the https protocol. To forcibly disable the secure flag, provide a C<-secure> argument with a value of 0.

=head2 $app->cookies

Returns a reference to a hash containing cookie objects, where the objects are
either of class L<Apache::Cookie> (in a L<mod_perl> context) or L<CGI::Cookie>
(in a CGI context).

=head2 $app->user_cookie

Returns the string of the cookie name used for the user login cookie.

=head2 $app->user

Returns the object of the logged in user. Typically a L<MT::Author>
object.

=head2 $app->clear_login_cookie

Sends a cookie back to the user's browser which clears their existing
authenication cookie.

=head2 $app->current_magic

Returns the active user's "magic token" which is used to validate posted data
with the C<validate_magic> method.

=head2 $app->make_magic_token

Creates a new "magic token" string which is a random set of characters.
The

=head2 $app->add_return_arg(%param)

Adds one or more arguments to the list of 'return' arguments that are
use to construct a return URL.

Example:

    $app->add_return_arg(finished_task => 1)
    $app->call_return;

This will redirect the user back to the URL they came from, adding a
new 'finished_task' query parameter to the URL.

=head2 $app->call_return

Invokes C<$app-E<gt>redirect> using the C<$app-E<gt>return_uri> method
as the address.

=head2 $app->make_return_args

Constructs the list of return arguments using the
data available from C<$app-E<gt>state_params> and C<$app->E<gt>mode>.

=head2 $app->mode([$mode])

Gets or sets the active application run mode.

=head2 $app->state_params

Returns a list of the parameter names that preserve the given state
of the application. These are declared during the application's C<init>
method, using the C<state_params> member element.

Example:

    $app->{state_params} = ['filter','page','blog_id'];

=head2 $app->return_args([$args])

Gets or sets a string containing query parameters which is used by
C<return_uri> in constructing a 'return' address for the current
request.

=head2 $app->return_uri

Returns a string composed of the C<$app-E<gt>uri> and the
C<$app-E<gt>return_args>.

=head2 $app->uri_params(%param)

A utility method that assembles the query portion of a URI, taking
a mode and set of parameters. The string returned does include the '?'
character if query parameters exist.

Example:

    my $query_str = $app->uri_params(mode => 'go',
                                     args => { 'this' => 'that' });
    # $query_str == '?__mode=go&this=that'

=head2 $app->session([$element[,$value]])

Returns the active user's session object. This also acts as a get/set
method for assigning arbitrary data into the user's session record.
At the end of the active request, any unsaved session data is written
to the L<MT::Session> record.

Example:

    # saves the value of a 'color' parameter into the user's session
    # this value will persist from one request to the next, but will
    # be cleared when the user logs out or has to reauthenicate.
    $app->session('color', $app->param('color'))

=head2 $app->start_session([$author, $remember])

Initializes a new user session by both calling C<make_session> and
setting the user's login cookie.

=head2 $app->make_session

Creates a new user session MT::Session record for the active user.

=head2 $app->session_user($user_obj, $session_id, %options)

Given an existing user object and a session ID ("token"), this returns the
user object back if the session's user ID matches the requested
$user_obj-E<gt>id, undef if the session can't be found or if the session's
user ID doesn't match the $user_obj-E<gt>id.

=head2 $app->show_error($error)

Handles the display of an application error.

=head2 $app->show_login(\%param)

Builds the log-in screen.

=head2 $app->envelope

This method is deprecated.

=head2 $app->takedown

Called at the end of the web request for cleanup purposes.

=head2 $app->add_breadcrumb($name, $uri)

Adds to the navigation history path that is displayed to the end user when
using the application.  The last breadcrumb should always be a reference to
the active mode of the application. Example:

    $app->add_breadcrumb('Edit Foo',
        $app->uri_params(mode => 'edit',
                         args => { '_type' => 'foo' }));

=head2 $app->add_methods(%arg)

Used to supply the application class with a list of available run modes and
the code references for each of them. C<%arg> should be a hash list of
methods and the code reference for it. Example:

    $app->add_methods(
        'one' => \&one,
        'two' => \&two,
        'three' => \&three,
    );

=head2 $app->add_plugin_action($where, $action_link, $link_text)

  $app->add_plugin_action($where, $action_link, $link_text)

Adds a link to the given plugin action from the location specified by
$where. This allows plugins to create actions that apply to, for
example, the entry which the user is editing. The type of object the
user was editing, and its ID, are passed as parameters.

Values that are used from the $where parameter are as follows:

=over 4

=item * list_entries

=item * list_commenter

=item * list_comments

=item * <type>
(Where <type> is any object that the user can already edit, such as
'entry,' 'comment,' 'commenter,' 'blog,' etc.)

=back

The C<$where> value will be passed to the given action_link as a CGI
parameter called C<from>. For example, on the list_entries page, a
link will appear to:

    <action_link>&from=list_entries

If the $where is a single-item page, such as an entry-editing page,
then the action_link will also receive a CGI parameter C<id> whose
value is the ID of the object under consideration:

    <action_link>&from=entry&id=<entry-id>

Note that the link is always formed by appending an ampersand. Thus,
if your $action_link is simply the name of a CGI script, such as
my-plugin.cgi, you'll want to append a '?' to the argument you pass:

    MT->add_plugin_action('entry', 'my-plugin.cgi?', \
                          'Touch this entry with MyPlugin')

Finally, the $link_text parameter specifies the text of the link; this
value will be wrapped in E<lt>a> tags that point to the $action_link.

=head2 $app->plugin_actions($type)

Returns a list of plugin actions that are registered for the C<$type>
specified. The return value is an array of hashrefs with the following
keys set for each: C<page> (the registered 'action link'),
C<link_text> (the registered 'link text'), C<plugin> (the plugin's envelope).
See the documentation for
L<$app-E<gt>add_plugin_action($where, $action_link, $link_text)>
for more information.

=head2 $app->app_path

Returns the path portion of the active URI.

=head2 $app->app_uri

Returns the current application's URI.

=head2 $app->mt_path

Returns the path portion of the URI that is used for accessing the MT CGI
scripts.

=head2 $app->mt_uri

Returns the full URI of the MT "admin" script (typically a reference to
mt.cgi).

=head2 $app->blog

Returns the active blog, if available. The I<blog_id> query
parameter identifies this blog.

=head2 $app->touch_blogs

An internal routine that is used during the end of an application
request to update each L<MT::Blog> object's timestamp if any of it's
child objects were changed during the application request.

=head2 $app->tmpl_prepend(\$str, $section, $id, $content)

Adds text at the top of a MT marker tag identified by C<$section> and
C<$id>. If a template contains the following:

    <MT_HEAD:STYLE>
    <link ...>
    </MT_HEAD:STYLE>

A call to tmpl_prepend like this:

    $app->tmpl_prepend($tmpl_ref, 'HEAD', 'STYLE', "new link tag\n");

will result in this change in the template page:

    <MT_HEAD:STYLE>
    new link tag
    <link ...>
    </MT_HEAD:STYLE>

=head2 $app->tmpl_append(\$str, $section, $id, $content)

Adds text at the bottom of a MT marker tag identified by C<$section> and
C<$id>. If a template contains the following:

    <MT_HEAD:STYLE>
    <link ...>
    </MT_HEAD:STYLE>

A call to tmpl_append like this:

    $app->tmpl_append($tmpl_ref, 'HEAD', 'STYLE', "new link tag\n");

will result in this change in the template page:

    <MT_HEAD:STYLE>
    <link ...>
    new link tag
    </MT_HEAD:STYLE>

=head2 $app->tmpl_replace(\$str, $section, $id, $content)

Replaces text within a MT marker tag identified by C<$section> and
C<$id>. If a template contains the following:

    <MT_HEAD:STYLE>
    <link ...>
    </MT_HEAD:STYLE>

A call to tmpl_replace like this:

    $app->tmpl_prepend($tmpl_ref, 'HEAD', 'STYLE', "new style content\n");

will result in this change in the template page:

    <MT_HEAD:STYLE>
    new style content
    </MT_HEAD:STYLE>

=head2 $app->tmpl_select(\$str, $section, $id)

Returns the text found within a MT marker tag identified by C<$section> and
C<$id>. If a template contains the following:

    <MT_HEAD:STYLE>
    <link ...>
    </MT_HEAD:STYLE>

A call to tmpl_select like this:

    my $str = $app->tmpl_select($tmpl_ref, 'HEAD', 'STYLE');

will select the following and return it:

    <link ...>

=head2 $app->cookie_val($name)

Returns the value of a given cookie.

=head2 $app->delete_param($param)

Clears the value of a given CGI parameter.

=head2 $app->errtrans($msg[, @param])

Translates the C<$msg> text, passing through C<@param> for any parameters
within the message. This also sets the error state of the application,
assinging the translated text as the error message.

=head2 $app->get_header($header)

Returns the value of the specified HTTP header.

=head2 MT::App->handler

The mod_perl handler used when the application is run as a native
mod_perl handler.

=head2 $app->init(@param)

Initializes the application object, setting default values and establishing
the parameters necessary to run.  The @param values are passed through
to the parent class, the C<MT> package.

This method needs to be invoked by any subclass when the object is
initialized.

=head2 $app->is_authorized

Returns a true value if the active user is authorized to access the
application. By default, this always returns true; subclasses may
override it to check app-specific authorization. A login attempt will
be rejected with a generic error message at the MT::App level, if
is_authorized returns false, but MT::App subclasses may wish to
perform additional checks which produce more specific error messages.

Subclass authors can assume that $app->user is populated with the
authenticated user when this routine is invoked, and that CGI query
object is available through $app->{query} and $app->param().

=head2 $app->is_secure

Returns a boolean result based on whether the application request is
happening over a secure (HTTPS) connection.

=head2 $app->l10n_filter

Alias for C<MT-E<gt>translate_templatized>.

=head2 $app->param($name[, $value])

Interface for getting and setting CGI query parameters. Example:

    my $title = $app->param('entry_title');

Versions of MT before 3.16 did not support the MT::App::param()
method. In that environment, $app->{query} is a CGI object whose
C<param> method works identically with this one.

=head2 $app->param_hash

Returns a hash (not a reference) containing all of the query parameter
names and their values. Example:

    my %data = $app->param_hash;
    my $title = $data{entry_title};

=head2 $app->post_run

This method is invoked, with no parameters, immediately following the
execution of the requested C<__mode> handler. Its return value is ignored.

C<post_run> will be invoked whether or not the C<__mode> handler returns an
error state through the MT::ErrorHandler mechanism, but it will not be
invoked if the handler C<die>s.

App subclasses can override this method with tasks to be executed
after any C<__mode> handler but before the page is delivered to the
client. Such a method should invoke C<SUPER::post_run> to ensure that
MT's core post-run tasks are executed.

=head2 $app->pre_run

This method is invoked, with no parameters, before dispatching to the
requested C<__mode> handler. Its return value is ignored.

C<pre_run> is not invoked if the request could not be authenticated.
If C<pre_run> is invoked and does not C<die>, the C<__mode> handler
B<will> be invoked.

App subclasses can override this method with tasks to be executed
before, and regardless of, the C<__mode> specified in the
request. Such an overriding method should invoke C<SUPER::pre_run> to
ensure that MT's core pre-run tasks are executed.

=head2 $app->query_string

Returns the CGI query string of the active request.

=head2 $app->request_content

Returns a scalar containing the POSTed data of the active HTTP
request. This will force the request body to be read, even if
$app->{no_read_body} is true. TBD: document no_read_body.

=head2 $app->request_method

Returns the method of the active HTTP request, typically either "GET"
or "POST".

=head2 $app->response_content_type([$type])

Gets or sets the HTTP response Content-Type header.

=head2 $app->response_code([$code])

Gets or sets the HTTP response code: the numerical value that begins
the "status line." Defaults to 200.

=head2 $app->response_message([$message])

Gets or sets the HTTP response message, better known as the "reason
phrase" of the "status line." E.g., if these calls were executed:

   $app->response_code("404");
   $app->response_message("Thingy Not Found");

This status line might be returned to the client:

   404 Thingy Not Found

By default, the reason phrase is an empty string, but an appropriate
reason phrase may be assigned by the webserver based on the response
code.

=head2 $app->set_header($name, $value)

Adds an HTTP header to the response with the given name and value.

=head2 $app->validate_magic

Checks for a I<magic_token> HTTP parameter and validates it for the current
author.  If it is invalid, an error message is assigned to the application
and a false result is returned. If it is valid, it returns 1. Example:

    return unless $app->validate_magic;

To populate a form with a valid magic token, place the token value in a
hidden form field:

    <input type="hidden" name="magic_token" value="<TMPL_VAR NAME=MAGIC_TOKEN>" />

If you're protecting a hyperlink, add the token to the query parameters
for that link.

=head2 $app->redirect($url, [option1 => option1_val, ...])

Redirects the client to the URL C<$url>. If C<$url> is not an absolute
URL, it is prepended with the value of C<$app-E<gt>base>.

By default, the redirection is accomplished by means of a Location
header and a 302 Redirect response.

If the option C<UseMeta =E<gt> 1> is given, the request will be redirected
by issuing a text/html entity body that contains a "meta redirect"
tag. This option can be used to work around clients that won't accept
cookies as part of a 302 Redirect response.

=head2 $app->base

The protocol and domain of the application. For example, with the full URI
F<http://www.foo.com/mt/mt.cgi>, this method will return F<http://www.foo.com>.

=head2 $app->path

The path component of the URL of the application directory. For
example, with the full URL F<http://www.foo.com/mt/mt.cgi>, this
method will return F</mt/>.

=head2 $app->script

In CGI mode, the filename of the active CGI script. For example, with
the full URL F<http://www.foo.com/mt/mt.cgi>, this method will return
F<mt.cgi>.

In mod_perl mode, the Request-URI without any query string.

=head2 $app->uri([%params])

The concatenation of C<$app-E<gt>path> and C<$app-E<gt>script>. For example,
with the full URI F<http://www.foo.com/mt/mt.cgi>, this method will return
F</mt/mt.cgi>. If C<%params> exist, they are passed to the
C<$app-E<gt>uri_params> method for processing.

Example:

    return $app->redirect($app->uri(mode => 'go', args => {'this'=>'that'}));

=head2 $app->path_info

The path_info for the request (that is, whatever is left in the URI
after removing the path to the script itself).

=head2 $app->log($msg)

Adds the message C<$msg> to the activity log. The log entry will be tagged
with the IP address of the client running the application (that is, of the
browser that made the HTTP request), using C<$app-E<gt>remote_ip>.

=head2 $app->trace(@msg)

Adds a trace message by concatenating all the members of C<@msg> to the
internal tracing mechanism; trace messages are then displayed at the
top of the output page sent to the client.  These messages are
displayed when the I<DebugMode> configuration parameter is
enabled. This is useful for debugging.

=head2 $app->remote_ip

The IP address of the client.

In a L<mod_perl> context, this calls L<Apache::Connection::remote_ip>; in a
CGI context, this uses C<$ENV{REMOTE_ADDR}>.

=head1 STANDARD APPLICATION TEMPLATE PARAMETERS

When loading an application template, a number of parameters are preset for
you. The following are some parameters that are assigned by C<MT::App> itself:

=over 4

=item * AUTHOR_ID

=item * AUTHOR_NAME

The MT::Author ID and username of the currently logged-in user.

=item * MT_VERSION

The value returned by MT->version_id. Typically just the release version
number, but for special releases such as betas, this may also include
an identifying suffix (ie "3.2b").

=item * MT_PRODUCT_CODE

A product code defined by Six Apart to identify the edition of Movable Type.
Currently, the valid values include:

    MT  - Movable Type Personal or Movable Type Commercial editions
    MTE - Movable Type Advanced

=item * MT_PRODUCT_NAME

The name of the product in use.

=item * LANGUAGE_TAG

The active language identifier of the currently logged-in user (or default
language for the MT installation if there is no logged in user).

=item * LANGUAGE_xx

A parameter dynamically named for testing for particular languages.

Sample usage:

    <TMPL_IF NAME=LANGUAGE_FR>Parlez-vous Francias?</TMPL_IF>

Note that this is not a recommended way to localize your application. This
is intended for including or excluding portions of a template based on the
active language.

=item * LANGUAGE_ENCODING

Provides the character encoding that is configured for the application. This
maps to the "PublishCharset" MT configuration setting.

=item * STATIC_URI

This provides the mt-config.cgi setting for "StaticWebPath" or "AdminCGIPath",
depending on whether the active CGI is an admin CGI script or not (most
likely it is, if it's meant to be used by an administrator (mt.cgi) and not
an end user such as mt-comments.cgi).

Sample usage:

    <TMPL_VAR NAME=STATIC_URI>images/image-name.gif

With a StaticWebPath of '/mt/', this produces:

    /mt/mt-static/images/image-name.gif

or, if StaticWebPath is 'http://example.com/mt-static/':

    http://example.com/mt-static/images/image-name.gif

=item * SCRIPT_URL

Returns the relative URL to the active CGI script.

Sample usage:

    <TMPL_VAR NAME=SCRIPT_URL>?__mode=blah

which may output:

    /mt/plugins/myplugin/myplugin.cgi?__mode=blah


=item * MT_URI

Yields the relative URL to the primary Movable Type application script
(mt.cgi or the configured 'AdminScript').

Sample usage:

    <TMPL_VAR NAME=MT_URI>?__mode=view&_type=entry&id=1&blog_id=1

producing:

    /mt/mt.cgi?__mode=view&_type=entry&id=1&blog_id=1

=item * SCRIPT_PATH

The path portion of URL for script

Sample usage:

    <TMPL_VAR NAME=SCRIPT_PATH>mt-check.cgi

producing:

    /mt/mt-check.cgi

=item * SCRIPT_FULL_URL

The complete URL to the active script. This is useful when needing to output
the full script URL, including the protocol and domain.

Sample usage:

    <TMPL_VAR NAME=SCRIPT_FULL_URL>?__mode=blah

Which produces something like this:

    http://example.com/mt/plugins/myplugin/myplugin.cgi?__mode=blah

=back

=head1 AUTHOR & COPYRIGHTS

Please see the L<MT> manpage for author, copyright, and license information.

=cut
