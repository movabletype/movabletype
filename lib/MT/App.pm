# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::App;

use strict;
use base qw( MT );

use File::Spec;
use MT::Request;
use MT::Util qw( encode_html offset_time_list decode_html encode_url );
use MT::I18N qw( encode_text );

my $COOKIE_NAME = 'mt_user';
use constant COMMENTER_COOKIE_NAME => "mt_commenter";
use vars qw( %Global_actions );

# Default id method turns MT::App::CMS => cms; Foo::Bar => foo/bar
sub id {
    my $pkg = shift;
    my $id = ref($pkg) || $pkg;
    # ignore the MT::App prefix as part of the identifier
    $id =~ s/^MT::App:://;
    $id =~ s!::!/!g;
    return lc $id;
}

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
    {}
}

sub core_widgets {
    {}
}

sub __massage_page_action {
    my ($app, $action, $type) = @_;
    return if exists $action->{__massaged};

    # my $plugin_sig = $action->{plugin};
    my $plugin = $action->{plugin};

    if (my $link = $action->{link}) {
        my $envelope = $plugin->envelope;
        $link .= '?' unless $link =~ m.\?.;
        my $page = $app->config->AdminCGIPath || $app->config->CGIPath;
        $page .= '/' unless $page =~ m!/$!;
        $page .= $envelope . '/' if $envelope;
        $page .= $link;
        my $has_params = ($page =~ m/\?/)
            && ($page !~ m!(&|;|\?)$!);
        $action->{page} = $page;
        $action->{page_has_params} = $has_params;
    } elsif ($action->{mode} || $action->{dialog}) {
        if ( $app->user->is_superuser ) {
            $action->{allowed} = 1;
        }
        else {
            my $perms = $app->permissions;
            if ( my $p = $action->{permission} ) {
                my @p = split /,/, $p;
                foreach my $p (@p) {
                    my $perm = 'can_' . $p;
                    $action->{allowed} = 1, last if ( $perms && $perms->$perm() );
                }
            }
        }
        if ( $action->{mode} ) {
            $action->{link} = $app->uri(
                mode => $action->{mode},
                args => $action->{args}
            );
        }
        elsif ( $action->{dialog} ) {
            if ( $action->{args} ) {
                my @args = map { $_ . '=' . $action->{args}->{$_} } keys %{ $action->{args} };
                $action->{dialog_args} .= join '&', @args;
            }
        }
    } else {
        $action->{page} = $app->uri(mode => 'page_action', args => { action_name => $action->{key}, '_type' => $type } );
        $action->{page_has_params} = 1;
    }
    $action->{label} = $action->{link_text} if exists $action->{link_text};

    if ($plugin && !ref($action->{label})) {
        my $label = $action->{label};
        if ($plugin) {
            $action->{label} = sub { $plugin->translate($label) };
        } else {
            $action->{label} = sub { $app->translate($label) };
        }
    }

    $action->{__massaged} = 1;
}

sub filter_conditional_list {
    my ($app, $list, @param) = @_;

    # $list may either be an array of things or a hashref of things

    my $perms = $app->permissions;
    my $user = $app->user;
    my $admin = ($user && $user->is_superuser())
        || ($perms && $perms->blog_id && $perms->has('administer_blog'));

    my $test = sub {
        my ($item) = @_;
        if (my $p = $item->{permission}) {
            my $allowed = 0;
            my @p = split /,/, $p;
            foreach my $p (@p) {
                my $perm = 'can_' . $p;
                $allowed = 1, last
                    if $admin || ($perms && $perms->can($perm) && $perms->$perm());
            }
            return 0 unless $allowed;
        }
        if (my $cond = $item->{condition}) {
            if (!ref($cond)) {
                $cond = $item->{condition} = $app->handler_to_coderef($cond);
            }
            return 0 unless $cond->(@param);
        }
        return 1;
    };

    if (ref $list eq 'ARRAY') {
        my @list;
        if (@$list) {
            # translate the link text here...
            foreach my $item (@$list) {
                push @list, $item if $test->($item);
            }
        }
        return \@list;
    } elsif (ref $list eq 'HASH') {
        my %list;
        if (%$list) {
            # translate the link text here...
            foreach my $item (keys %$list) {
                $list{$item} = $list->{$item}
                    if $test->($list->{$item});
            }
        }
        return \%list;
    }
}

sub page_actions {
    my $app = shift;
    my ($type, @param) = @_;
    my $actions = $app->registry("page_actions", $type) or return;
    foreach my $a (keys %$actions) {
        $actions->{$a}{key} = $a;
        $actions->{$a}{core} = 1 if $actions->{$a}{plugin}->id eq 'core';
        __massage_page_action($app, $actions->{$a}, $type);
    }
    my @actions = values %$actions;
    $actions = $app->filter_conditional_list(\@actions, @param);
    no warnings;
    @$actions = sort { $a->{order} <=> $b->{order} } @$actions;
    return $actions;
}

sub list_actions {
    my $app = shift;
    my ($type, @param) = @_;

    my $actions = $app->registry("list_actions", $type) or return;
    my @actions;
    foreach my $a (keys %$actions) {
        $actions->{$a}{key} = $a;
        $actions->{$a}{core} = 1 if $actions->{$a}{plugin}->id eq 'core';
        push @actions, $actions->{$a};
    }
    $actions = $app->filter_conditional_list(\@actions, @param);
    no warnings;
    @$actions = sort { $a->{order} <=> $b->{order} } @$actions;
    return $actions;
}

sub list_filters {
    my $app = shift;
    my ($type, @param) = @_;

    my $filters = $app->registry("list_filters", $type) or return;
    my @filters;
    foreach my $a (keys %$filters) {
        $filters->{$a}{key} = $a;
        next if $a =~ m/^_/; # not shown...
        push @filters, $filters->{$a};
    }
    $filters = $app->filter_conditional_list(\@filters, @param);
    no warnings;
    @$filters = sort { $a->{order} <=> $b->{order} } @$filters;
    return $filters;
}

sub listing {
    my $app = shift;
    my ($opt) = @_;

    my $type = $opt->{type} || $opt->{Type} || $app->param('_type');
    my $tmpl = $opt->{template}
      || $opt->{Template}
      || 'list_' . $type . '.tmpl';
    my $iter_method = $opt->{iterator} || $opt->{Iterator} || 'load_iter';
    my $param       = $opt->{params}   || $opt->{Params}   || {};
    my $add_pseudo_new_user = delete $param->{pseudo_new_user}
      if exists $param->{pseudo_new_user};
    my $hasher  = $opt->{code}    || $opt->{Code};
    my $terms   = $opt->{terms}   || $opt->{Terms} || {};
    my $args    = $opt->{args}    || $opt->{Args} || {};
    my $no_html = $opt->{no_html} || $opt->{NoHTML};
    my $no_limit = $opt->{no_limit} || 0;
    my $json    = $opt->{json}    || $app->param('json');
    my $pre_build = $opt->{pre_build} if ref($opt->{pre_build}) eq 'CODE';
    $param->{json} = 1 if $json;

    my $class = $app->model($type) or return;
    my $list_pref = $app->list_pref($type);
    $param->{$_} = $list_pref->{$_} for keys %$list_pref;
    my $limit = $list_pref->{rows};
    my $offset = $app->param('offset') || 0;
    $args->{offset} = $offset if $offset && !$no_limit;
    $args->{limit} = $limit + 1 unless $no_limit;
    $param->{limit_none} = 1 if $no_limit;

    # handle search parameter
    if ( my $search = $app->param('search') ) {
        $app->param( 'do_search', 1 );
        if ($app->can('do_search_replace')) {
            my $search_param = $app->do_search_replace();
            if ($hasher) {
                my $data = $search_param->{object_loop};
                if ( $data && @$data ) {
                    foreach my $row (@$data) {
                        my $obj = $row->{object};
                        $row = $obj->column_values();
                        $hasher->( $obj, $row );
                    }
                }
            }
            $param->{$_} = $search_param->{$_} for keys %$search_param;
            $param->{limit_none} = 1;
        }
    }
    else {
        # handle filter options
        my $filter_key = $app->param('filter_key');
        if ( !$filter_key && !$app->param('filter') ) {
            $filter_key = 'default';
        }
        if ( $filter_key ) {

            # set filter based on type
            my $filter = $app->registry( "list_filters", $type, $filter_key );
            if ($filter) {
                if ( my $code = $filter->{code} || $filter->{handler} ) {
                    if ( ref($code) ne 'CODE' ) {
                        $code = $filter->{code} =
                          $app->handler_to_coderef($code);
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
        if (   ( my $filter_col = $app->param('filter') )
            && ( my $val = $app->param('filter_val') ) )
        {
            if (
                (
                       ( $filter_col eq 'normalizedtag' )
                    || ( $filter_col eq 'exacttag' )
                )
                && ( $class->isa('MT::Taggable') )
              )
            {
                my $normalize   = ( $filter_col eq 'normalizedtag' );
                my $tag_class   = $app->model('tag');
                my $ot_class    = $app->model('objecttag');
                my $tag_delim   = chr( $app->user->entry_prefs->{tag_delim} );
                my @filter_vals = $tag_class->split( $tag_delim, $val );
                my @filter_tags = @filter_vals;
                if ($normalize) {
                    push @filter_tags, MT::Tag->normalize($_)
                      foreach @filter_vals;
                }
                my @tags = $tag_class->load( { name => [@filter_tags] },
                    { binary => { name => 1 } } );
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
                    {
                        tag_id            => \@tag_ids,
                        object_datasource => $class->datasource
                    },
                    { unique => 1 }
                );
            }
            elsif ( !exists( $terms->{$filter_col} ) ) {
                $terms->{$filter_col} = $val;
            }
            $param->{filter}     = $filter_col;
            $param->{filter_val} = $val;
            my $url_val = encode_url($val);
            $param->{filter_args} = "&filter=$filter_col&filter_val=$url_val";
            $param->{"filter_col_$filter_col"} = 1;
        }

        # automagic blog scoping
        my $blog = $app->blog;
        if ($blog) {

            # In blog context, class defines blog_id as a column,
            # so restrict listing to active blog:
            if ( $class->column_def('blog_id') ) {
                $terms->{blog_id} ||= $blog->id;
            }
        }

        $args->{sort} = 'id'
          unless exists $args->{sort};    # must always provide sort column
        my $iter =
          ref($iter_method) eq 'CODE'
          ? $iter_method
          : ( $class->$iter_method( $terms, $args )
              or return $app->error( $class->errstr ) );
        my @data;
        while ( my $obj = $iter->() ) {
            my $row = $obj->column_values();
            $hasher->( $obj, $row ) if $hasher;
            push @data, $row;
            last if (scalar @data == $limit) && (!$no_limit);
        }

        $param->{object_loop} = \@data;

        # handle pagination
        my $pager = {
            offset        => $offset,
            limit         => $limit,
            rows          => scalar @data,
            listTotal     => $class->count( $terms, $args ),
            chronological => $param->{list_noncron} ? 0 : 1,
            return_args   => $app->make_return_args,
        };
        $param->{object_type} ||= $type;
        require JSON;
        $param->{pager_json} = $json ? $pager : JSON::objToJson($pager);

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

    if ($json) {
        $pre_build->($param) if $pre_build;
        my $html = $app->build_page( $tmpl, $param );
        my $data = {
            html  => $html,
            pager => $param->{pager_json},
        };
        $app->send_http_header("text/javascript+json");
        require JSON;
        $app->print( JSON::objToJson($data) );
        $app->{no_print_body} = 1;
    }
    else {
        $app->load_list_actions( $type, $param );
        $pre_build->($param) if $pre_build;
        if ($no_html) {
            return $param;
        }
        if (ref $tmpl) {
            $tmpl->param( $param );
            return $tmpl;
        } else {
            return $app->load_tmpl( $tmpl, $param );
        }
    }
}

sub json_result {
    my $app = shift;
    my ($result) = @_;
    $app->send_http_header("text/javascript+json");
    $app->{no_print_body} = 1;
    require JSON;
    $app->print(JSON::objToJson( { error => undef, result => $result }));
}

sub json_error {
    my $app = shift;
    my ($error) = @_;
    $app->send_http_header("text/javascript+json");
    $app->{no_print_body} = 1;
    require JSON;
    $app->print(JSON::objToJson( { error => $error } ));
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

sub send_http_header {
    my $app = shift;
    my($type) = @_;
    $type ||= 'text/html';
    if (my $charset = $app->charset) {
        $type .= "; charset=$charset"
            if $type =~ m!^text/! && $type !~ /\bcharset\b/;
    }
    if ($ENV{MOD_PERL}) {
        if ($app->{response_message}) {
            $app->{apache}->status_line(($app->response_code || 200) . " " 
                                        . $app->{response_message});
        } else {
            $app->{apache}->status($app->response_code || 200);
        }
        $app->{apache}->send_http_header($type);
        if ($MT::DebugMode & 128) {
            print "Status: " . ($app->response_code || 200)
                . ($app->{response_message} ? $app->{response_message} : '')
                . "\n";
            print "Content-Type: $type\n\n";
        }
    } else {
        $app->{cgi_headers}{-status} = ($app->response_code || 200) . " "
                                     . ($app->{response_message} || "");
        $app->{cgi_headers}{-type} = $type;
        $app->print($app->{query}->header(%{ $app->{cgi_headers} }));
    }
}

sub print {
    my $app = shift;
    if ($ENV{MOD_PERL}) {
        $app->{apache}->print(@_);
    } else {
        CORE::print(@_);
    }
    if ($MT::DebugMode & 128) {
        CORE::print STDERR @_;
    }
}

sub handler ($$) {
    my $class = shift;
    my($r) = @_;
    require Apache::Constants;
    if (lc($r->dir_config('Filter') || '') eq 'on') {
        $r = $r->filter_register;
    }
    my $config_file = $r->dir_config('MTConfig');
    my $mt_dir = $r->dir_config('MTHome');
    my %params = (Config => $config_file, ApacheObject => $r,
                  ( $mt_dir ? ( Directory => $mt_dir ) : () ));
    my $app = $class->new( %params )
        or die $class->errstr;

    MT->set_instance($app);
    $app->init_request(%params);

    my $cfg = $app->config;
    if (my @extra = $r->dir_config('MTSetVar')) {
        for my $d (@extra) {
            my($var, $val) = $d =~ /^\s*(\S+)\s+(.+)$/;
            $cfg->set($var, $val);
        }
    }

    $app->run;
    return Apache::Constants::OK();
}

sub new {
    my $pkg = shift;
    my $app = $pkg->SUPER::new(@_);
    $app->{init_request} = 0;
    $app;
}

sub init {
    my $app = shift;
    my %param = @_;
    $app->{apache} = $param{ApacheObject} if exists $param{ApacheObject};
    $app->SUPER::init(%param) or return;
    $app->{vtbl} = { };
    $app->{is_admin} = 0;
    $app->{template_dir} = 'cms'; #$app->id;
    $app->{user_class} = 'MT::Author';
    $app->{plugin_template_path} = 'tmpl';
    $app->run_callbacks('init_app', $app, @_);
    if ($MT::DebugMode & 128) {
        MT->add_callback('pre_run', 1, $app, sub { $app->pre_run_debug });
        MT->add_callback('post_run', 1, $app, sub { $app->post_run_debug });
    }
    $app->{vtbl} = $app->registry("methods");
    $app->init_request(@_);
    return $app;
}

sub pre_run_debug {
    my $app = shift;
    if ($MT::DebugMode & 128) {
        print STDERR "=====START: $$===========================\n";
        print STDERR "Package: " . ref($app) . "\n";
        print STDERR "Session: " . $app->session->id . "\n"
            if $app->session;
        print STDERR "Request: " . $app->param->request_method . "\n";
        my @param = $app->param;
        if (@param) {
            foreach my $key (@param) {
                my @val = $app->param($key);
                print STDERR "\t" . $key . ": " . $_ . "\n"
                    for @val;
            }
        }
        print STDERR "-----Response:\n";
    }
}

sub post_run_debug {
    if ($MT::DebugMode & 128) {
        print STDERR "\n=====END: $$=============================\n";
    }
}

sub run_callbacks {
    my $app = shift;
    my ($meth, @param) = @_;
    $meth = (ref($app)||$app) . '::' . $meth unless $meth =~ m/::/;
    return $app->SUPER::run_callbacks($meth, @param);
}

sub init_callbacks {
    my $app = shift;
    $app->SUPER::init_callbacks(@_);
    MT->add_callback('*::post_save', 0, $app, \&_cb_mark_blog );
    MT->add_callback('MT::Blog::post_remove', 0, $app, \&_cb_unmark_blog );
    MT->add_callback('new_user_provisioning', 5, $app, \&_cb_user_provisioning);
}

sub init_request {
    my $app = shift;
    my %param = @_;

    return if $app->{init_request};

    if ($app->{request_read_config}) {
        $app->init_config(\%param) or return;
        $app->{request_read_config} = 0;
    }

    # @req_vars: members of the app object which are request-specific
    # and are cleared at the beginning of each request.
    my @req_vars = qw(mode __path_info _blog redirect login_again
        no_print_body response_code response_content_type response_message
        author cgi_headers breadcrumbs goback cache_templates warning_trace
        cookies _errstr request_method requires_login );
    delete $app->{$_} foreach @req_vars;
    $app->{trace} = undef;
    $app->user(undef);
    if ($ENV{MOD_PERL}) {
        require Apache::Request;
        $app->{apache} = $param{ApacheObject} || Apache->request;
        $app->{query} = Apache::Request->instance($app->{apache},
            POST_MAX => $app->config->CGIMaxUpload);
    } else {
        if ($param{CGIObject}) {
            $app->{query} = $param{CGIObject};
            require CGI;
            $CGI::POST_MAX = $app->config->CGIMaxUpload;
        } else {
            if (my $path_info = $ENV{PATH_INFO}) {
                if ($path_info =~ m/\.cgi$/) {
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
    $app->{return_args} = $app->{query}->param('return_args');
    $app->cookies;

    # Backward compatible assignment; now that plugin actions are
    # actually stored in the app object, the MT::PluginActions
    # hash variable needs to point to it.
    # *MT::PluginActions = $app->{plugin_actions};

    ## Initialize the MT::Request singleton for this particular request.
    $app->request->reset();
    $app->request('App-Class', ref $app);

    $app->run_callbacks(ref($app) . '::init_request', $app, @_);

    $app->{init_request} = 1;
}

sub registry {
    my $app = shift;
    my $ar = $app->SUPER::registry("applications", $app->id, @_);
    my $gr = $app->SUPER::registry(@_) if @_;
    if ($ar) {
        MT::__merge_hash($ar, $gr);
        return $ar;
    }
    return $gr;
}

sub _cb_unmark_blog {
    my ($eh, $obj) = @_;
    my $mt_req = MT->instance->request;
    if (my $blogs_touched = $mt_req->stash('blogs_touched')) {
        delete $blogs_touched->{$obj->id};
        $mt_req->stash('blogs_touched', $blogs_touched);
    }
}

sub _cb_mark_blog {
    my ($eh, $obj) = @_;
    my $obj_type = ref $obj;
    return if ($obj_type eq 'MT::Author' ||
               $obj_type eq 'MT::Log' || $obj_type eq 'MT::Session' ||
               (($obj_type ne 'MT::Blog') && !$obj->has_column('blog_id')));
    my $mt_req = MT->instance->request;
    my $blogs_touched = $mt_req->stash('blogs_touched') || {};
    if ($obj_type eq 'MT::Blog') {
        $blogs_touched->{$obj->id} = 0;
    } else {
        $blogs_touched->{$obj->blog_id}++;
    }
    $mt_req->stash('blogs_touched', $blogs_touched);
}

sub _cb_user_provisioning {
    my ($cb, $user) = @_;

    # Supply user with what they need...

    require MT::Blog;
    require MT::Util;
    my $new_blog;
    my $blog_name = $user->nickname || MT->translate("First Weblog");
    if (my $blog_id = MT->config('NewUserTemplateBlogId')) {
        my $blog = MT::Blog->load($blog_id);
        if (!$blog) {
            MT->log({
                message => MT->translate("Error loading weblog #[_1] for user provisioning. Check your NewUserTemplateBlogId setting.", $blog_id),
                level => MT::Log::ERROR(),
            });
            return;
        }
        $new_blog = $blog->clone({
            Children => 1,
            Classes => { 'MT::Permission' => 0, 'MT::Association' => 0 },
            BlogName => $blog_name,
        });
        if (!$new_blog) {
            MT->log({
                message => MT->translate("Error provisioning weblog for new user '[_1]' using template blog #[_2].", $user->id, $blog->id),
                level => MT::Log::ERROR(),
            });
            return;
        }
    } else {
        $new_blog = MT::Blog->create_default_blog($blog_name);
    }

    my $dir_name;
    if (my $root = MT->config('DefaultSiteRoot')) {
        my $fmgr = $new_blog->file_mgr;
        if (-d $root) {
            my $path;
            $dir_name = MT::Util::dirify($new_blog->name);
            $dir_name = 'blog-' if ($dir_name =~ /_*/);
            my $sfx = 0;
            while (1) {
                $path = File::Spec->catdir($root, $dir_name . ($sfx ? $sfx : ''));
                $path =~ s/(.+)\-$/$1/;
                if (!-d $path) {
                    $fmgr->mkpath($path);
                    if (!-d $path) {
                        MT->log({
                            message => MT->translate("Error creating directory [_1] for blog #[_2].", $path, $new_blog->id),
                            level => MT::Log::ERROR(),
                        });
                    }
                    last;
                }
                $sfx++;
            }
            $dir_name .= $sfx ? $sfx : '';
            $dir_name =~ s/(.+)\-$/$1/;
            $new_blog->site_path($path);
        }
    }
    if (my $url = MT->config('DefaultSiteURL')) {
        $url .= '/' unless $url =~ m!/$!;
        $url .= $dir_name ? $dir_name : MT::Util::dirify($new_blog->name);
        $url .= '/';
        $new_blog->site_url($url);
    }
    my $offset = MT->config('DefaultTimezone');
    if (defined $offset) {
        $new_blog->server_offset($offset);
    }
    $new_blog->save
        or MT->log({
            message => MT->translate("Error provisioning weblog for new user '[_1] (ID: [_2])'.", $user->id, $user->name),
            level => MT::Log::ERROR(),
        }), return;
    MT->log({
        message => MT->translate(
            "Blog '[_1] (ID: [_2])' for user '[_3] (ID: [_4])' has been created.",
            $new_blog->name, $new_blog->id, $user->name, $user->id),
        level => MT::Log::INFO(),
        class => 'system',
        category => 'new'
    });

    require MT::Role;
    require MT::Association;
    my $role = MT::Role->load_by_permission('administer_blog');
    if ($role) {
        MT::Association->link($user => $role => $new_blog);
    } else {
        MT->log({
            message => MT->translate(
                "Error assigning weblog administration rights to user '[_1] (ID: [_2])' for weblog '[_3] (ID: [_4])'. No suitable weblog administrator role was found.",
                $user->name, $user->id, $new_blog->name, $new_blog->id,),
            level => MT::Log::ERROR(),
            class => 'system',
            category => 'new'
        });
    }
    1;
}

# Along with _cb_unmark_blog and _cb_mark_blog, this is an elaborate
# scheme to cause MT::Blog objects that are affected as a result of a
# change to a child class to be updated with respect to their
# 'last modification' timestamp which is used by the dynamic engine
# to determine when cached files are stale.
sub touch_blogs {
    my $blogs_touched = MT->instance->request('blogs_touched') or return;
    foreach my $blog_id (keys %$blogs_touched) {
        next unless $blog_id;
        my $blog = MT::Blog->load($blog_id, {cached_ok=>1});
        if (($blog->custom_dynamic_templates || '') ne 'none') {
            $blog->touch();
            $blog->save() or die $blog->errstr;
        }
    }
}

sub add_breadcrumb {
    my $app = shift;
    push @{ $app->{breadcrumbs} }, {
        bc_name => $_[0],
        bc_uri => $_[1],
    }
}

sub is_authorized { 1 }

sub user_cookie { $COOKIE_NAME }

sub user {
    my $app = shift;
    $app->{author} = $app->{$COOKIE_NAME} = $_[0] if @_;
    return $app->{author};
}

sub permissions {
    my $app = shift;
    $app->{perms} = shift if @_;
    return $app->{perms};
}

sub session {
    my $app = shift;
    my $sess = $app->{session};
    return unless $sess;
    if (@_) {
        my $setting = shift;
        @_ ? $sess->set($setting, @_) : $sess->get($setting);
    } else {
        $sess;
    }
}

sub make_magic_token {
    my @alpha = ('a'..'z', 'A'..'Z', 0..9);
    my $token = join '', map $alpha[rand @alpha], 1..40;
    $token;
}

sub make_session {
    my $auth = shift;
    require MT::Session;
    my $sess = new MT::Session;
    $sess->id(make_magic_token());
    $sess->kind('US');  # US == User Session
    $sess->start(time);
    $sess->set('author_id', $auth->id);
    $sess->save;
    $sess;
}

# given credentials in the form of a username, optional password, and
# session ID ("token"), this returns the corresponding author object
# if the credentials are legit, 0 if insufficient credentials were there,
# or undef if they were actually incorrect
sub session_user {
    my $app = shift;
    my ($author, $session_id, %opt) = @_;
    return undef unless $author && $session_id;
    if ($app->{session}) {
        if ($app->{session}->get('author_id') == $author->id) {
            return $author;
        }
    }

    require MT::Session;
    my $timeout = $opt{permanent} ? (360*24*365*10)
        : $app->config->UserSessionTimeout;
    my $sess = MT::Session::get_unexpired_value($timeout,
                                                { id => $session_id, 
                                                  kind => 'US' });
    $app->{session} = $sess;

    return undef if !$sess;
    if ($sess && ($sess->get('author_id') == $author->id)) {
        return $author;
    } else {
        return undef;
    }
}

sub _make_commenter_session {
    my $app = shift;
    my ($session_key, $email, $name, $nick, $id, $url, $timeout) = @_;

    my $enc = $app->charset;
    $nick = encode_text($nick, $enc, 'utf-8');
    my $nick_escaped = MT::Util::escape_unicode( $nick );

    $timeout = '+' . $app->{cfg}->CommentSessionTimeout . 's' unless defined $timeout;
    my %kookee = (-name => COMMENTER_COOKIE_NAME(),
                  -value => $session_key,
                  -path => '/',
                  ($timeout ? (-expires => $timeout) : ()));
    $app->bake_cookie(%kookee);
    my %name_kookee = (-name => "commenter_name",
                       -value => $nick_escaped,
                       -path => '/',
                       ($timeout ? (-expires => $timeout) : ()));
    $app->bake_cookie(%name_kookee);
    if (defined $id) {
        my @blogs;
        if ($app->user && $app->user->is_superuser) {
            @blogs = $app->model('blog')->load;
        }
        else {
            @blogs = $app->model('blog')->load(undef,
              {
                join => MT::Permission->join_on('blog_id',
                  {
                    permissions => "\%'comment'\%",
                    author_id   => $id
                  },
                  { 'like' => { 'permissions' => 1 } }
                )
              }
            );
        }
        my $blog_ids = "'" . join("','", map { $_->id } @blogs) . "'";
        my %id_kookee = (-name => "commenter_id",
                           -value => $id . ':' . $blog_ids,
                           -path => '/',
                           ($timeout ? (-expires => $timeout) : ()));
        $app->bake_cookie(%id_kookee);
    }
    if (defined($url) && $url) {
        my %id_kookee = (-name => "commenter_url",
                           -value => $url,
                           -path => '/',
                           ($timeout ? (-expires => $timeout) : ()));
        $app->bake_cookie(%id_kookee);
    }

    require MT::Session;
    my $sess_obj = MT::Session->new();
    $sess_obj->id($session_key);
    $sess_obj->email($email);
    $sess_obj->name($name);
    $sess_obj->start(time);
    $sess_obj->kind("SI");
    $sess_obj->save()
        or return $app->error($app->translate("The login could not be confirmed because of a database error ([_1])", $sess_obj->errstr));
    return $session_key;
}

sub _invalidate_commenter_session {
    my $app = shift;
    my ($cookies) = @_;

    my $cookie_val = ($cookies->{COMMENTER_COOKIE_NAME()}
                      ? $cookies->{COMMENTER_COOKIE_NAME()}->value()
                      : "");
    my $session = $cookie_val;
    require MT::Session;
    my $sess_obj = MT::Session->load({id => $session });
    $sess_obj->remove() if ($sess_obj);
    
    my $timeout = $app->{cfg}->CommentSessionTimeout;

    my %kookee = (-name => COMMENTER_COOKIE_NAME(),
                  -value => '',
                  -path => '/',
                  -expires => "+${timeout}s");
    $app->bake_cookie(%kookee);
    my %name_kookee = (-name => 'commenter_name',
                       -value => '',
                       -path => '/',
                       -expires => "+${timeout}s");
    $app->bake_cookie(%name_kookee);
    my %id_kookee = (-name => 'commenter_id',
                       -value => '',
                       -path => '/',
                       -expires => "+${timeout}s");
    $app->bake_cookie(%id_kookee);
}

sub start_session {
    my $app = shift;
    my ($author, $remember) = @_;
    if (!defined $author) {
        $author = $app->user;
        my ($x, $y);
        ($x, $y, $remember) = split(/::/, $app->cookie_val($app->user_cookie));
    }
    my $session = make_session($author);
    my %arg = (-name => $COOKIE_NAME,
               -value => join('::',
                              $author->name,
                              $session->id,
                              $remember),
               -path => $app->config->CookiePath || $app->mt_path
               );
    $arg{-expires} = '+10y' if $remember;
    $app->{session} = $session;
    $app->bake_cookie(%arg);
    \%arg;
}

sub _is_commenter {
    my $app = shift;
    my ($author) = @_;

    # Check if the user is a commenter and keep them from logging in to the app
    my @author_perms = $app->model('permission')->load(
        { author_id => $author->id, blog_id => '0' },
        { not => { blog_id => 1 } });
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
        my $sys_perms = MT::Permission->perms('system');
        my $has_system_permission = 0;
        foreach (@$sys_perms) {
            if ( $author->permissions(0)->has( $_->[0] ) ) {
                $has_system_permission = 1;
                last;
            }
        }
        return $app->error($app->translate('Permission denied.'))
            unless $has_system_permission;
        return -1;
    } 
    return $commenter_blog_id;
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
    my $ctx = MT::Auth->fetch_credentials({ app => $app });
    unless ($ctx) {
        if ( $app->param('submit') ) {
            return $app->error($app->translate('Invalid login.'));
        }
        return;
    }

    my $res = MT::Auth->validate_credentials($ctx) || MT::Auth::UNKNOWN();
    my $user = $ctx->{username};

    if ($res == MT::Auth::UNKNOWN()) {
        # Login invalid; auth layer knows nothing of user
        $app->log({
            message => $app->translate("Failed login attempt by unknown user '[_1]'", $user),
            level => MT::Log::WARNING(),
            category => 'login_user',
        }) if defined $user;
        MT::Auth->invalidate_credentials({app => $app});
        return $app->error($app->translate('Invalid login.'));
    } elsif ($res == MT::Auth::INACTIVE()) {
        # Login invalid; auth layer reports user was disabled
        $app->log({
            message => $app->translate("Failed login attempt by disabled user '[_1]'", $user),
            level => MT::Log::WARNING(),
            category => 'login_user',
        });
        return $app->error($app->translate(
            'This account has been disabled. Please see your system administrator for access.'));
    } elsif ($res == MT::Auth::INVALID_PASSWORD()) {
        # Login invlaid (password error, etc...)
        return $app->error($app->translate('Invalid login.'));
    } elsif ($res == MT::Auth::DELETED()) {
        # Login invalid; auth layer says user record has been removed
        return $app->error($app->translate(
            'This account has been deleted. Please see your system administrator for access.'));
    } elsif ($res == MT::Auth::REDIRECT_NEEDED()) {
        # The authentication driver is delegating authentication to another URL, follow the
        # designated redirect.
        my $url = $app->config->AuthLoginURL;
        if ($url && !$app->{redirect}) {
            $app->redirect($url);
        }
        return 0;  # Return undefined so the redirect (set by the Auth Driver) will be
                   # followed by MT.
    } elsif ($res == MT::Auth::NEW_LOGIN()) {
        # auth layer reports valid user and that this is a new login. act accordingly
        my $author = $app->user;
        MT::Auth->new_login($app, $author);
        $new_login = 1;
    } elsif ($res == MT::Auth::NEW_USER()) {
        # auth layer reports that a new user has been created by logging in.
        my $user_class = $app->user_class;
        my $author = $user_class->new;
        $app->user($author);
        $author->name($ctx->{username}) if $ctx->{username};
        $author->type(MT::Author::AUTHOR());
        $author->status(MT::Author::ACTIVE());
        my $saved = MT::Auth->new_user($app, $author);
        $saved = $author->save unless $saved;

        unless ($saved) {
            $app->log({
                 message => MT->translate("User cannot be created: [_1].", $author->errstr),
                 level => MT::Log::ERROR(),
                 class => 'system',
                 category => 'create_user'
            }), $app->error(MT->translate("User cannot be created: [_1].", $author->errstr)), return undef;
        }

        $app->log({
            message => MT->translate("User '[_1]' has been created.", $author->name),
            level => MT::Log::INFO(),
            class => 'system',
            category => 'create_user'
        });

        # provision user if configured to do so
        if ($app->config->NewUserAutoProvisioning) {
            MT->run_callbacks('new_user_provisioning', $author);
        }
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
            return unless defined $commenter_blog_id;
            # $commenter_blog_id
            #  0: user has more permissions than comment
            #  N: user has only comment permission on some blog
            # -1: user has only system permissions
            # undef: user does not have any permission
 
            if ( $commenter_blog_id >= 0 ) {
                # Presence of 'password' indicates this is a login request;
                # do session/cookie management.
                $app->_make_commenter_session(
                    $app->make_magic_token, 
                    $author->email, 
                    $author->name, 
                    ($author->nickname || 'User#' . $author->id), 
                    $author->id, 
                    undef, 
                    $ctx->{permanent} ? '+10y' : 0
                );

                if ($commenter_blog_id) {
                    my $blog = $app->model('blog')->load($commenter_blog_id);
                    my $url = $app->config('CGIPath') . $app->config('CommentScript');
                    $url .= '?__mode=edit_profile';
                    $url .= '&commenter=' . $author->id;
                    $url .= '&blog_id=' . $commenter_blog_id;
                    $url .= '&static=' . $blog->site_url;
                    return $app->redirect($url);
                }
            }
            ## commenter_blog_id can be -1 - user who has only system permissions

            $app->start_session($author, $ctx->{permanent} ? 1 : 0);
            $app->request('fresh_login', 1);
            $app->log($app->translate("User '[_1]' (ID:[_2]) logged in successfully", $author->name, $author->id));
        } else {
            $author = $app->session_user($author, $ctx->{session_id}, permanent => $ctx->{permanent});
            if (!defined($author)) {
                $app->user(undef);
                $app->{login_again} = 1;
                return undef;
            }
        }

        # $author->last_login();
        # $author->save;

        ## update session so the user will be counted as active
        require MT::Session;
        my $sess_active = MT::Session->load( { kind => 'UA', name => $author->id } );
        if (!$sess_active) {
            $sess_active = MT::Session->new;
            $sess_active->id(make_magic_token());
            $sess_active->kind('UA'); # UA == User Activation
            $sess_active->name($author->id);
        }
        $sess_active->start(time);
        $sess_active->save;

        return ($author, $new_login);
    } else {
        MT::Auth->invalidate_credentials({app => $app});
        if (!defined($author)) {
            require MT::Log;
            # undef indicates *invalid* login as opposed to no login at all.
            $app->log({
                message => $app->translate("Invalid login attempt from user '[_1]'", $user),
                level => MT::Log::WARNING(),
            });
            return $app->error($app->translate('Invalid login.'));
        } else {
            return undef;
        }
    }
}

sub logout {
    my $app = shift;

    require MT::Auth;

    my $ctx = MT::Auth->fetch_credentials({ app => $app });
    if ($ctx && $ctx->{username}) {
        my $user_class = $app->user_class;
        my $user = $user_class->load({ name => $ctx->{username}, type => MT::Author::AUTHOR() });
        if ($user) {
            $app->user($user);
            $app->log($app->translate("User '[_1]' (ID:[_2]) logged out",
                                  $user->name, $user->id));
        }
    }

    MT::Auth->invalidate_credentials({ app => $app });
    my %cookies = $app->cookies();
    $app->_invalidate_commenter_session(\%cookies);

    # The login box should only be displayed in the event of non-delegated auth
    # right?
    my $delegate = MT::Auth->delegate_auth();
    if ($delegate) {
        my $url = $app->config->AuthLogoutURL;
        if ($url && !$app->{redirect}) {
            $app->redirect($url);
        }
        if ($app->{redirect}) {
            # Return 0 to force MT to follow redirects
            return 0;
        }
    }

    # Displaying the login box
    $app->load_tmpl('login.tmpl', {
        logged_out => 1, 
        no_breadcrumbs => 1,
        login_fields => MT::Auth->login_form($app),
        can_recover_password => MT::Auth->can_recover_password,
        delegate_auth => $delegate,
    });
}

sub clear_login_cookie {
    my $app = shift;
    $app->bake_cookie(-name => $COOKIE_NAME, -value => '', -expires => '-1y',
        -path => $app->config->CookiePath || $app->mt_path);
}

sub request_content {
    my $app = shift;
    unless (exists $app->{request_content}) {
        if ($ENV{MOD_PERL}) {
            ## Read from $app->{apache}
            my $r = $app->{apache};
            my $len = $app->get_header('Content-length');
            $r->read($app->{request_content}, $len);
        } else {
            ## Read from STDIN
            my $len = $ENV{CONTENT_LENGTH} || 0;
            read STDIN, $app->{request_content}, $len;
        }
    }
    $app->{request_content};
}

sub get_header {
    my $app = shift;
    my($key) = @_;
    if ($ENV{MOD_PERL}) {
        return $app->{apache}->header_in($key);
    } else {
        ($key = uc($key)) =~ tr/-/_/;
        return $ENV{'HTTP_' . $key};
    }
}

sub set_header {
    my $app = shift;
    my($key, $val) = @_;
    if ($ENV{MOD_PERL}) {
        $app->{apache}->header_out($key, $val);
    } else {
        unless ($key =~ /^-/) {
            ($key = lc($key)) =~ tr/-/_/;
            $key = '-' . $key;
        }
        if ($key eq '-cookie') {
            push @{$app->{cgi_headers}{$key}}, $val;
        } else {
            $app->{cgi_headers}{$key} = $val;
        }
    }
}

sub request_method {
    my $app = shift;
    if (@_) {
        $app->{request_method} = shift;
    } elsif (!exists $app->{request_method}) {
        if ($ENV{MOD_PERL}) {
            $app->{request_method} = Apache->request->method;
        } else {
            $app->{request_method} = $ENV{REQUEST_METHOD};
        }
    }
    $app->{request_method};
}

sub cookie_val {
    my $app = shift;
    my $cookies = $app->cookies;
    if ($cookies && $cookies->{$_[0]}) {
        return $cookies->{$_[0]}->value() || "";
    }
    return "";
}

sub bake_cookie {
    my $app = shift;
    my %param = @_;
    my $cfg = $app->config;
    if ((!exists $param{'-secure'}) && $app->is_secure) {
        $param{'-secure'} = 1;
    }
    unless ($param{-path}) {
        $param{-path} = $cfg->CookiePath || $app->path;
    }
    if (!$param{-domain} && $cfg->CookieDomain) {
        $param{-domain} = $cfg->CookieDomain;
    }
    if ($ENV{MOD_PERL}) {
        require Apache::Cookie;
        my $cookie = Apache::Cookie->new($app->{apache}, %param);
        if ($param{-expires} && ($cookie->expires =~ m/%/)) {
            # Fix for oddball Apache::Cookie error reported on Windows.
            require CGI::Util;
            $cookie->expires(CGI::Util::expires($param{-expires}, 'cookie'));
        }
        $cookie->bake;
    } else {
        require CGI::Cookie;
        my $cookie = CGI::Cookie->new(%param);
        $app->set_header('-cookie', $cookie);
    }
}

sub cookies {
    my $app = shift;
    unless ($app->{cookies}) {
        my $class = $ENV{MOD_PERL} ? 'Apache::Cookie' : 'CGI::Cookie';
        eval "use $class;";
        $app->{cookies} = $class->fetch;
    }
    return wantarray ? %{ $app->{cookies} } : $app->{cookies}
        if $app->{cookies};
}

sub show_error {
    my $app = shift;
    my($error) = @_;
    my $tmpl;
    my $mode = $app->mode;
    my $url =  $app->uri;
    my $blog_id = $app->param('blog_id');
    if ($MT::DebugMode && $@) {
        $error = '<pre>'.encode_html($error).'</pre>';
    } else {
        $error = encode_html($error);
        $error =~ s!(https?://\S+)!<a href="$1" target="_blank">$1</a>!g;
    }
    $tmpl = $app->load_tmpl('error.tmpl') or
        return "Can't load error template; got error '" . $app->errstr .
               "'. Giving up. Original error was <pre>$error</pre>";
    $tmpl->param(ERROR => $error);
    my $type = $app->param('__type') || '';
    if ($type eq 'dialog') {
        $tmpl->param(NAME => $app->{name} || 'dialog' );
        $tmpl->param(GOBACK => $app->{goback} || 'closeDialog()');
        $tmpl->param(VALUE => $app->{value} || $app->translate("Close"));
    } else {
        $tmpl->param(GOBACK => $app->{goback} || 'history.back()');
        $tmpl->param(VALUE => $app->{value} || $app->translate("Go Back"));
    }
    $app->l10n_filter($tmpl->output);
}

sub pre_run {
    my $app = shift;
    if (my $auth = $app->user) {
        if (my $lang = $app->param('__lang')) {
            $app->set_language($lang);
        } else {
            $app->set_language($auth->preferred_language)
                if $auth->has_column('preferred_language');
        }
    }

    # allow language override
    my $lang = $app->session ? $app->session('lang') : '';
    $app->set_language( $lang ) if( $lang );
    if( $lang = $app->{query}->param('__lang') ) {
        $app->set_language( $lang );
        if( $app->session ) {
            $app->session( 'lang', $lang );
            $app->session->save;
        }
    }

    $app->{breadcrumbs} = [];
    MT->run_callbacks((ref $app) . '::pre_run', $app);
    1;
}

sub post_run { MT->run_callbacks((ref $_[0]) . '::post_run', $_[0]); 1 }

sub run {
    my $app = shift;
    my $q = $app->param;

    ## Add the Pragma: no-cache header.
    if ($ENV{MOD_PERL}) {
        $app->{apache}->no_cache(1);
    } else {
        $q->cache('no');
    }

    my($body);
    eval {
        require MT::Auth;
        if ($ENV{MOD_PERL}) {
            unless ($app->{no_read_body}) {
                my $status = $q->parse;
                unless ($status == Apache::Constants::OK()) {
                    die $app->translate('The file you uploaded is too large.') .
                        "\n<!--$status-->";
                }
            }
        } else {
            my $err;
            eval { $err = $q->cgi_error };
            unless ($@) {
                if ($err && $err =~ /^413/) {
                    die $app->translate('The file you uploaded is too large.') .
                        "\n";
                }
            }
        }

        REQUEST:
        {
            my $requires_login = $app->{requires_login};

            my $mode = $app->mode || 'default';

            my $code = $app->handlers_for_mode($mode);

            my @handlers = ref($code) eq 'ARRAY' ? @$code : ( $code )
                if defined $code;

            foreach my $code (@handlers) {
                if (ref $code eq 'HASH') {
                    my $meth_info = $code;
                    $requires_login = exists $meth_info->{requires_login}
                        ? $meth_info->{requires_login} : $requires_login;
                }
            }

            if ($requires_login) {
                my ($author) = $app->login;
                if (!$author || !$app->is_authorized) {
                    $body = ref ($author) eq $app->user_class
                        ? $app->show_error( $app->errstr )
                        : $app->build_page('login.tmpl',{
                            error => $app->errstr,
                            no_breadcrumbs => 1,
                            login_fields => sub { MT::Auth->login_form($app) },
                            can_recover_password => sub { MT::Auth->can_recover_password },
                            delegate_auth => sub { MT::Auth->delegate_auth },
                        });
                    last REQUEST;
                }
            }

            unless (@handlers) {
                my $meth = "mode_$mode";
                if ($app->can($meth)) {
                    no strict 'refs';
                    $code = \&{ *{ ref($app).'::'.$meth } };
                    push @handlers, $code;
                }
            }

            if (!@handlers) {
                $app->error($app->translate('Unknown action [_1]', $mode));
                last REQUEST;
            }

            $app->response_content(undef);

            $app->pre_run;

            foreach my $code (@handlers) {

                if (ref $code eq 'HASH') {
                    my $meth_info = $code;
                    $code = $meth_info->{code} || $meth_info->{handler};

                    if (my $set = $meth_info->{permission}) {
                        my $user = $app->user;
                        my $perms = $app->permissions;
                        my $blog = $app->blog;
                        my $allowed = 0;
                        if ($user) {
                            my $admin = $user->is_superuser()
                                || ($blog && $perms && $perms->can_administer_blog());
                            my @p = split /,/, $set;
                            foreach my $p (@p) {
                                my $perm = 'can_' . $p;
                                $allowed = 1, last
                                    if $admin || $perms && ($perms->can($perm) && $perms->$perm());
                            }
                        }
                        unless ($allowed) {
                            $app->errtrans("Permission denied.");
                            last REQUEST;
                        }
                    }
                }

                if (ref $code ne 'CODE') {
                    $code = $app->handler_to_coderef($code);
                }

                if ($code) {
                    my $content = $code->($app);
                    $app->response_content($content)
                        if defined $content;
                }
            }

            $app->post_run;

            $body = $app->response_content();

            if (ref($body) && ($body->isa('MT::Template'))) {
                my $out = $app->build_page($body)
                    or die $body->errstr;
                $body = $out;
            }

            # Some browsers throw you to quirks mode if the doctype isn't
            # up front.
            $body =~ s/^\s+(<!DOCTYPE)/$1/s if defined $body;

            unless (defined $body || $app->{redirect} || $app->{login_again}) {
                if ($app->{no_print_body}) {
                    $app->print($app->errstr);
                } else {
                    $body = $app->show_error( $app->errstr );
                }
            }
            $app->error(undef);
        }  ## end REQUEST block
    };
    unless (defined $body) {
        my $err = $app->errstr || $@;
        $body = $app->show_error($err);
    }
    if (ref($body) && ($body->isa('MT::Template'))) {
        $body = $@ || $app->errstr;
    }

    if ((!defined $body) && $app->{login_again}) {
        # login again!
        require MT::Auth;
        $body = $app->build_page('login.tmpl', {
            error => $app->errstr,
            no_breadcrumbs => 1,
            login_fields => MT::Auth->login_form($app),
            can_recover_password => MT::Auth->can_recover_password,
            delegate_auth => MT::Auth->delegate_auth,
        })
            or $body = $app->show_error( $app->errstr );
    }

    if (my $url = $app->{redirect}) {
        if ($app->{redirect_use_meta}) {
            $app->send_http_header();
            $app->print('<meta http-equiv="refresh" content="0;url=' . 
                        $app->{redirect} . '">');
        } else {
            if ($ENV{MOD_PERL}) {
                $app->{apache}->header_out(Location => $url);
                $app->response_code(Apache::Constants::REDIRECT());
                $app->send_http_header;
            } else {
                $app->print($q->redirect(-uri => $url, %{ $app->{cgi_headers} }));
            }
        }
    } else {
        unless ($app->{no_print_body}) {
            $app->send_http_header;
            if ($MT::DebugMode && !($MT::DebugMode & 128)) { # no need to emit twice
                if ($body =~ m!</body>!i) {
                    if ($app->{trace} &&
                        (!defined $app->{warning_trace} || $app->{warning_trace})) {
                        my $trace = '';
                        foreach (@{$app->{trace}}) {
                            my $msg = encode_html($_);
                            $trace .= '<li>' . $msg . '</li>';
                        }
                        $trace = '<ul>' . $trace . '</ul>';
                        my $panel = "<div class=\"debug-panel\">"
                            . "<h3>" . $app->translate("Warnings and Log Messages") . "</h3>"
                            . "<div class=\"debug-panel-inner\">"
                            . $trace . "</div></div>";
                        $body =~ s!(</body>)!$panel$1!i;
                    }
                }
            }
            $app->print($body);
        }
    }
    $app->takedown();
}

sub handlers_for_mode {
    my $app = shift;
    my ($mode) = @_;

    my $code;

    if (my $meths = $Global_actions{ref($app)}
        || $Global_actions{$app->id}) {
        $code = $meths->{$mode} if exists $meths->{$mode};
    }

    $code ||= $app->{vtbl}{$mode};

    return $code;
}

sub mode {
    my $app = shift;
    if (@_) {
        $app->{mode} = shift;
    } else {
        if (my $mode = $app->param('__mode')) {
            $mode =~ s/[<>"']//g;
            $app->{mode} ||= $mode;
        }
    }
    $app->{mode} || $app->{default_mode} || 'default';
}

sub assert {
    my $app = shift;
    my $x = shift;
    return 1 if $x;
    return $app->errtrans(@_);
}

sub takedown {
    my $app = shift;

    MT->run_callbacks(ref($app) . '::take_down', $app);   # arg is the app object

    $app->touch_blogs;

    my $sess = $app->session;
    $sess->save if $sess && $sess->is_dirty;

    my $driver = $MT::Object::DRIVER;
    $driver->clear_cache if $driver;

    require MT::Auth;
    MT::Auth->release;

    $app->request->finish;
    delete $app->{request};
    delete $app->{cookies};
    $app->{request_read_config} = 1;
}

sub l10n_filter { $_[0]->translate_templatized($_[1]) }

sub template_paths {
    my $app = shift;
    my @paths;
    my $path = $app->config->TemplatePath;
    if ($app->{plugin_template_path}) {
        if (File::Spec->file_name_is_absolute($app->{plugin_template_path})) {
            push @paths, $app->{plugin_template_path}
                if -d $app->{plugin_template_path};
        } else {
            my $dir = File::Spec->catdir($app->app_dir,
                                         $app->{plugin_template_path}); 
            if (-d $dir) {
                push @paths, $dir;
            } else {
                $dir = File::Spec->catdir($app->mt_dir,
                                          $app->{plugin_template_path});
                push @paths, $dir if -d $dir;
            }
        }
    }
    if (my $alt_path = $app->config->AltTemplatePath) {
        if (-d $alt_path) {    # AltTemplatePath is absolute
            push @paths, File::Spec->catdir($alt_path,
                                            $app->{template_dir})
                if $app->{template_dir};
            push @paths, $alt_path;
        }
    }
    push @paths, File::Spec->catdir($path, $app->{template_dir})
        if $app->{template_dir};
    push @paths, $path;
    return @paths;
}

sub find_file {
    my $app = shift;
    my ($paths, $file) = @_;
    my $filename;
    foreach my $p (@$paths) {
        my $filepath = File::Spec->canonpath(File::Spec->catfile($p, $file));
        $filename = File::Spec->canonpath($filepath);
        return $filename if -f $filename;
    }
    undef;
}

sub load_widgets {
    my $app = shift;
    my ($page, $param, $default_widgets) = @_;

    my $user = $app->user;
    my $blog = $app->blog;
    my $blog_id = $blog->id if $blog;
    my $scope = $blog_id ? 'blog:'.$blog_id : 'system';
    my $resave_widgets = 0;
    my $widget_set = $page . ':' . $scope;

    # TBD: Fetch list of widgets from user object, or
    # use a default list

    my $widget_store = $user->widgets;
    my $widgets = $widget_store->{$widget_set} if $widget_store;

    unless ($widgets) {
        $resave_widgets = 1;
        $widgets = $default_widgets;

        # add the 'new_user' / 'new_install' widget...
        unless ($widget_store) {
            # Special case for the MT CMS dashboard and initial
            # widgets used there.
            if ($page eq 'dashboard') {
                if ($user->id == 1) {
                    # first user! good enough guess at this.
                    $widgets->{new_install} = { order => -1, set => 'main' };
                } else {
                    $widgets->{new_user} = { order => -1, set => 'main' };
                }
            }
        }
    }

    my $all_widgets = $app->registry("widgets");
    $all_widgets = $app->filter_conditional_list($all_widgets, $page, $scope);

    my @loop;
    my $num = 0;
    my @ordered_list;
    my %orders;
    my $order_num = 0;
    foreach my $widget_id (keys %$widgets) {
        my $widget_param = $widgets->{$widget_id} ||= {};
        my $order;
        if (!($order = $widget_param->{order})) {
            $order = ++$order_num;
            $widget_param->{order} = $order_num;
            $resave_widgets = 1;
        }
        push @ordered_list, $widget_id;
        $orders{$widget_id} = $order;
    }
    @ordered_list = sort { $orders{$a} <=> $orders{$b} } @ordered_list;

    # The list of widgets in a user's record
    # is going to look like this:
    #    xxx-1
    #    xxx-2
    #    yyy-1
    #    zzz
    # Any numeric suffix is just a means to distinguish
    # the instance of the widget from other instances.
    # The actual widget id is this minus the instance number.
    foreach my $widget_inst (@ordered_list) {
        my $widget_id = $widget_inst;
        $widget_id =~ s/-\d+$//;
        my $widget = $all_widgets->{$widget_id};
        next unless $widget;
        my $widget_cfg = $widgets->{$widget_inst} || {};
        my $widget_param = $widget_cfg->{param} || {};
        my $tmpl_name = $widget->{template};

        my $p = $widget->{plugin};
        my $tmpl;
        if ($p) {
            $tmpl = $p->load_tmpl($tmpl_name);
            $app->set_default_tmpl_params($tmpl);
        } else {
            # This is probably never used since all
            # widgets in reality are provided through
            # some sort of component/plugin.
            $tmpl = $app->load_tmpl($tmpl_name);
        }
        next unless $tmpl;

        $num++;
        my $set = $widget->{set} || $widget_cfg->{set} || 'main';
        local $param->{blog_id} = $blog_id;
        local $param->{widget_block} = $set;
        local $param->{widget_id} = $widget_inst;
        local $param->{widget_scope} = $widget_set;
        local $param->{widget_singular} = $widget->{singular} || 0;
        local $param->{magic_token} = $app->current_magic;
        my @opt_names = keys %$widget_param;
        local @{$param}{@opt_names};
        $param->{$_} = $widget_param->{$_} for @opt_names;
        if (my $h = $widget->{code} || $widget->{handler}) {
            $h = $app->handler_to_coderef($h);
            $h->($app, $tmpl, $param);
        }
        $tmpl->param($param);
        my $content = $tmpl->output($param);
        if (!defined $content) {
            return $app->error("Error processing template for widget $widget_id: " . $tmpl->errstr);
        }
        $param = $tmpl->param;
        $param->{$set} ||= '';
        $param->{$set} .= $content;
    }

    if ($resave_widgets) {
        my $widget_store = $user->widgets();
        $widget_store->{$widget_set} = $widgets;
        $user->widgets($widget_store);
        $user->save;
    }

    return $param;
}

sub update_widget_prefs {
    my $app = shift;
    my $user = $app->user;
    $app->validate_magic or return;

    my $blog = $app->blog;
    my $blog_id = $blog->id if $blog;
    my $widget_id = $app->param('widget_id');
    my $action = $app->param('widget_action');
    my $widget_scope = $app->param('widget_scope');
    my $widgets = $user->widgets || {};
    my $these_widgets = $widgets->{$widget_scope} ||= {};
    my $resave_widgets;
    my $result = {};
    if (($action eq 'remove') && $these_widgets) {
        $result->{message} = $app->translate("Removed [_1].", $widget_id);
        if (delete $these_widgets->{$widget_id}) {
            $resave_widgets = 1;
        }
    }
    if ($action eq 'add') {
        my $set = $app->param('widget_set') || 'main';
        my $all_widgets = $app->registry("widgets");
        if (my $widget = $all_widgets->{$widget_id}) {
            my $widget_inst = $widget_id;
            unless ($widget->{singular}) {
                my $num = 1;
                while (exists $these_widgets->{$widget_inst}) {
                    $widget_inst = $widget_id . '-' . $num;
                    $num++;
                }
            }
            $these_widgets->{$widget_inst} = { set => $set };
        }
        $resave_widgets = 1;
    }
    if (($action eq 'save') && $these_widgets) {
        my %all_params = $app->param_hash;
        my $refresh = $all_params{widget_refresh} ? 1 : 0;
        delete $all_params{$_}
          for qw( json widget_id widget_action __mode widget_set widget_singular widget_refresh magic_token widget_scope return_args );
        $these_widgets->{$widget_id}{param} = {};
        $these_widgets->{$widget_id}{param}{$_} = $all_params{$_}
            for keys %all_params;
        $widgets->{$widget_scope} = $these_widgets;
        $resave_widgets = 1;
        if ($refresh) {
            $result->{html} = 'widget!'; # $app->render_widget();
        }
    }
    if ($resave_widgets) {
        $user->widgets($widgets);
        $user->save;
    }
    if ($app->param('json')) {
        return $app->json_result($result);
    } else {
        $app->add_return_arg( 'saved' => 1 );
        $app->call_return;
    }
}

sub load_widget_list {
    my $app = shift;
    my ($page, $param, $default_set) = @_;

    my $blog = $app->blog;
    my $blog_id = $blog->id if $blog;
    my $scope = $page . ':' . ($blog_id ? 'blog:'.$blog_id : 'system');

    my $user_widgets = $app->user->widgets || {};
    $user_widgets = $user_widgets->{$scope} || $default_set || {};
    my %in_use;
    foreach my $uw (keys %$user_widgets) {
        $uw =~ s/-\d+$//;
        $in_use{$uw} = 1;
    }

    my $all_widgets = $app->registry("widgets");
    my $widgets = [];
    # First, filter out any 'singular' widgets that are already
    # in the user's widget bag
    foreach my $id (keys %$all_widgets) {
        my $w = $all_widgets->{$id};
        if ($w->{singular}) {
            # don't allow multiple widgets
            next if exists $in_use{$id};
        }
        $w->{id} = $id;
        push @$widgets, $w;
    }
    # Now filter remaining widgets based on any permission
    # or declared condition
    $widgets = $app->filter_conditional_list($widgets, $page, $scope);
    # Finally, build the widget loop, but don't include
    # any widgets that are unlabeled, since these are
    # added by the system and cannot be manually added.
    my @widget_loop;
    foreach my $w (@$widgets) {
        my $label = $w->{label} or next;
        $label = $label->() if ref($label) eq 'CODE';
        next unless $label;
        push @widget_loop, {
            widget_id => $w->{id},
            ($w->{set} ? ( widget_set => $w->{set} ) : ()),
            widget_label => $label,
        }
    }
    @widget_loop = sort { $a->{widget_label} cmp $b->{widget_label} }
        @widget_loop;
    $param->{widget_scope} = $scope;
    $param->{all_widget_loop} = \@widget_loop;
}

sub load_list_actions {
    my $app = shift;
    my ( $type, $param, @p ) = @_;
    my $all_actions = $app->list_actions( $type, @p );
    if ( ref($all_actions) eq 'ARRAY' ) {
        my @plugin_actions;
        my @core_actions;
        foreach my $a (@$all_actions) {
            if ( $a->{core} ) {
                push @core_actions, $a;
            }
            else {
                push @plugin_actions, $a;
            }
        }
        $param->{more_list_actions} = \@plugin_actions;
        $param->{list_actions}      = \@core_actions;
        $param->{has_list_actions} =
          ( @plugin_actions || @core_actions ) ? 1 : 0;
    }
    my $filters = $app->list_filters( $type, @p );
    $param->{list_filters} = $filters if $filters;
}

sub load_tmpl {
    my $app = shift;
    if ($app->{component}) {
        if (my $c = $app->component($app->{component})) {
            return $c->load_tmpl(@_);
        }
    }

    my($file, @p) = @_;
    my $param;
    if (@p && (ref($p[$#p]) eq 'HASH')) {
        $param = pop @p;
    }
    my $cfg = $app->config;
    require MT::Template;
    my $tmpl;
    my $err;
    my @paths = $app->template_paths;

    my $cache_dir;
    if (!$app->config->NoLocking) {
        my $path = $cfg->TemplatePath;
        $cache_dir = File::Spec->catdir($path, 'cache');
        undef $cache_dir if (!-d $cache_dir) || (!-w $cache_dir);
    }

    my $type = {'SCALAR' => 'scalarref', 'ARRAY' => 'arrayref'}->{ref $file}
        || 'filename';
    eval {
        $tmpl = MT::Template->new(
            type => $type, source => $file,
            path => \@paths,
            filter => sub {
                my ($str, $fname) = @_;
                if ($fname) {
                    $fname = File::Basename::basename($fname);
                    $fname =~ s/\.tmpl$//;
                    $app->run_callbacks("template_source.$fname", $app, @_);
                } else {
                    $app->run_callbacks("template_source", $app, @_);
                }
                return $str;
            },
            @p);
    };
    $err = $@;
    return $app->error(
        $app->translate("Loading template '[_1]' failed: [_2]", $file, $err))
        if $err;
    $tmpl->{__file} = $file if $type eq 'file';
    $app->set_default_tmpl_params($tmpl);
    $tmpl->param($param) if $param;
    $tmpl;
}

sub set_default_tmpl_params {
    my $app = shift;
    my ($tmpl) = @_;
    my $param = {};
    if (my $author = $app->user) {
        $param->{author_id} = $author->id;
        $param->{author_name} = $author->name;
    }
    ## We do this in load_tmpl because show_error and login don't call
    ## build_page; so we need to set these variables here.
    require MT::Auth;
    $param->{mt_debug} = $MT::DebugMode;
    $param->{can_logout} = MT::Auth->can_logout;
    $param->{static_uri} = $app->static_path;
    $param->{script_url} = $app->uri;
    $param->{mt_url} = $app->mt_uri;
    $param->{script_path} = $app->path;
    $param->{script_full_url} = $app->base . $app->uri;
    $param->{mt_version} = MT->version_id;
    $param->{mt_product_code} = MT->product_code;
    $param->{mt_product_name} = $app->translate(MT->product_name);
    $param->{language_tag} = substr($app->current_language, 0, 2);
    $param->{language_encoding} = $app->charset;
    $tmpl->param($param);
}

sub process_mt_template {
    my $app = shift;
    my ($body) = @_;
    $body =~ s@<(?:_|MT)_ACTION\s+mode="([^"]+)"(?:\s+([^>]*))?>@
        my $mode = $1; my %args;
        %args = $2 =~ m/\s*(\w+)="([^"]*?)"\s*/g if defined $2; # "
        MT::Util::encode_html($app->uri(mode => $mode, args => \%args));
    @geis;
    # Strip out placeholder wrappers to facilitate tmpl_* callbacks
    $body =~ s/<\/?MT_(\w+):(\w+)>//g;
    $body;
}

sub build_page {
    my $app = shift;
    my($file, $param) = @_;
    my $tmpl;
    my $mode = $app->mode;
    $param->{"mode_$mode"} ||= 1;
    $param->{breadcrumbs} = $app->{breadcrumbs};
    if ($param->{breadcrumbs}[-1]) {
        $param->{breadcrumbs}[-1]{is_last} = 1;
        $param->{page_titles} = [ reverse @{ $app->{breadcrumbs} } ];
    }
    pop @{ $param->{page_titles} };
    if (my $lang_id = $app->current_language) {
        $param->{local_lang_id} ||= lc $lang_id if $lang_id !~ m/^en/i;
    }
    $param->{magic_token} = $app->current_magic if $app->user;

    # List of installed packs in the application footer
    my @packs_installed;
    my $packs = $app->find_addons('pack');
    if ($packs) {
        foreach my $pack (@$packs) {
            my $c = $app->component(lc $pack->{id});
            if ($c) {
                my $label = $c->label || $pack->{label};
                $label = $label->() if ref($label) eq 'CODE';
                push @packs_installed, {
                    label => $label,
                    version => $c->version,
                    id => $c->id,
                };
            }
        }
    }
    @packs_installed = sort { $a->{label} cmp $b->{label} } @packs_installed;
    $param->{packs_installed} = \@packs_installed;
    $param->{portal_url} = $app->translate("http://www.movabletype.com/");

    my $tmpl_file;
    if (UNIVERSAL::isa($file, 'MT::Template')) {
        $tmpl = $file;
        $app->run_callbacks('template_param', $app, $param, $tmpl);
    } else {
        $tmpl = $app->load_tmpl($file) or return;
        $tmpl_file = $file;
        $tmpl_file =~ s/\.tmpl$//;
        $app->run_callbacks('template_param.' . $tmpl_file, $app, $param, $tmpl);
    }
    if (($mode && ($mode !~ m/delete/)) && ($app->{login_again} ||
        ($app->{requires_login} && !$app->user))) {
        ## If it's a login screen, direct the user to where they were going
        ## (query params including mode and all) unless they were logging in,
        ## logging out, or deleting something.
        my $q = $app->{query};
        if ($mode) {
            my @query = map { {name => $_, value => scalar $q->param($_)}; }
                grep { ($_ ne 'username') && ($_ ne 'password') && ($_ ne 'submit') && ($mode eq 'logout' ? ($_ ne '__mode') : 1) } $q->param;
            $param->{query_params} = \@query;
        }
        $param->{login_again} = $app->{login_again};
    }

    my $blog = $app->blog;
    $tmpl->context()->stash('blog', $blog) if $blog;

    $tmpl_file ||= $tmpl->{__file} if exists $tmpl->{__file};

    my $output = $app->build_page_in_mem($tmpl, $param);
    return unless defined $output;
    if ($tmpl_file) {
        $app->run_callbacks('template_output.'.$tmpl_file, $app, \$output, $param, $tmpl);
    } else {
        $app->run_callbacks('template_output', $app, \$output, $param, $tmpl);
    }
    $output;
}

sub build_page_in_mem {
    my $app = shift;
    my($tmpl, $param) = @_;
    $tmpl->param($param) if $param;
    my $out = $tmpl->output;
    return $app->error($tmpl->errstr) unless defined $out;
    return $app->translate_templatized($app->process_mt_template($out));
}

sub current_magic {
    my $app = shift;
    my $sess = $app->session;
    return ($sess ? $sess->id : undef);
}

sub validate_magic {
    my $app = shift;
    return 1
        if $app->param('username') && $app->param('password')
            && $app->request('fresh_login');
    $app->{login_again} = 1, return undef
        unless ($app->current_magic || '') eq ($app->param('magic_token') || '');
    1;
}

sub delete_param {
    my $app = shift;
    my($key) = @_;
    my $q = $app->{query};
    return unless $q;
    if ($ENV{MOD_PERL}) {
        my $tab = $q->parms;
        $tab->unset($key);
    } else {
        $q->delete($key);
    }
}

sub param_hash {
    my $app = shift;
    my $q = $app->{query};
    return () unless $q;
    my @params = $q->param();
    my %result;
    foreach my $p (@params) {
        $result{$p} = $q->param($p);
    }
    %result;
}

## Path/server/script-name determination methods

sub query_string {
    my $app = shift;
    $ENV{MOD_PERL} ? $app->{apache}->args : $app->{query}->query_string;
}

sub return_uri {
    $_[0]->uri . '?' . $_[0]->return_args;
}

sub call_return {
    my $app = shift;
    $app->add_return_arg(@_) if @_;
    $app->redirect($app->return_uri);
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
        if (my @p = $app->param($v)) {
            $args{$v} = (scalar @p > 1 && $v eq 'filter_val') ? \@p : $p[0];
        }
    }
    my $return = $app->uri_params(mode => $app->mode, 'args' => \%args);
    $return =~ s/^\?//;
    $return;
}

sub return_args {
    $_[0]->{return_args} = $_[1] if $_[1];
    $_[0]->{return_args};
}

sub add_return_arg {
    my $app = shift;
    if (scalar @_ == 1) {
        $app->{return_args} .= '&' if $app->{return_args};
        $app->{return_args} .= shift;
    } else {
        my (%args) = @_;
        foreach my $a (sort keys %args) {
            $app->{return_args} .= '&' if $app->{return_args};
            if (ref $args{$a} eq 'ARRAY') {
                $app->{return_args} .= $a . '=' . encode_url($_) foreach @{$args{$a}};
            } else {
                $app->{return_args} .= $a . '=' . encode_url($args{$a});
            }
        }
    }
}

sub base {
    my $app = shift;
    return $app->{__host} if exists $app->{__host};
    my $cfg = $app->config;
    my $path = $app->{is_admin} ?
        ($cfg->AdminCGIPath || $cfg->CGIPath) :
        $cfg->CGIPath;
    if ($path =~ m!^(https?://[^/]+)!i) {
        (my $host = $1) =~ s!/$!!;
        return $app->{__host} = $host;
    }
    # determine hostname from environment (supports relative CGI paths)
    if (my $host = $ENV{HTTP_HOST}) {
        return $app->{__host} = 'http' . ($app->is_secure ? 's' : '') . '://' . $host;
    }
    '';
}

*path = \&mt_path;
sub mt_path {
    my $app = shift;
    return $app->{__mt_path} if exists $app->{__mt_path};

    my $cfg = $app->config;
    my $path;
    $path = $app->{is_admin} ?
        ($cfg->AdminCGIPath || $cfg->CGIPath) :
        $cfg->CGIPath;
    if ($path =~ m!^https?://[^/]+(/?.*)$!i) {
        $path = $1;
    } elsif (!$path) {
        $path = '/';
    }
    $path .= '/' unless substr($path, -1, 1) eq '/';
    $app->{__mt_path} = $path;
}

sub app_path {
    my $app = shift;
    return $app->{__path} if exists $app->{__path};

    my $path;
    if ($ENV{MOD_PERL}) {
        $path = $app->{apache}->uri;
        $path =~ s!/[^/]*$!!;
    } elsif ($app->{query}) {
        $path = $app->{query}->url;
        $path =~ s!/[^/]*$!!;
        $path =~ s/%40/@/;    # '@' within path is okay
    } else {
        $path = $app->mt_path;
    }
    if ($path =~ m!^https?://[^/]+(/?.*)$!i) {
        $path = $1;
    } elsif (!$path) {
        $path = '/';
    }
    $path .= '/' unless substr($path, -1, 1) eq '/';
    $app->{__path} = $path;
}

sub envelope { '' }

sub static_path {
    my $app = shift;
    my $spath = $app->config->StaticWebPath;
    if (!$spath) {
        $spath = $app->path . 'mt-static/';
    } else {
        $spath .= '/' unless $spath =~ m!/$!;
    }
    $spath;
}

sub script {
    my $app = shift;
    return $app->{__script} if exists $app->{__script};
    my $script = $ENV{MOD_PERL} ? $app->{apache}->uri : $ENV{SCRIPT_NAME};
    if (!$script) {
        require File::Basename; import File::Basename qw(basename);
        $script = basename($0);
    }
    $script =~ s!/$!!;
    $script = (split /\//, $script)[-1];
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
    if ($param{args}) {
        foreach my $p (keys %{$param{args}}) {
            if (ref $param{args}{$p}) {
                push @params, ($p . '=' . encode_url($_)) foreach @{$param{args}{$p}};
            } else {
                push @params, ($p . '=' . encode_url($param{args}{$p}));
            }
        }
    }
    @params ? '?' . (join '&', @params) : '';
}

sub path_info {
    my $app = shift;
    return $app->{__path_info} if exists $app->{__path_info};
    my $path_info;
    if ($ENV{MOD_PERL}) {
        ## mod_perl often leaves part of the script name (Location)
        ## in the path info, for some reason. This should remove it.
        $path_info = $app->{apache}->path_info;
        if ($path_info) {
            my($script_last) = $app->{apache}->location =~ m!/([^/]+)$!;
            $path_info =~ s!^/$script_last!!;
        }
    } else {
        $path_info = $app->{query}->path_info;
    }
    $app->{__path_info} = $path_info;
}

sub is_secure {
    my $app = shift;
    $ENV{MOD_PERL} ? $app->{apache}->subprocess_env('https') :
        $app->{query}->protocol() eq 'https';
}

sub redirect {
    my $app = shift;
    my($url, %options) = @_;
    $url =~ s/[\r\n].*$//s;
    $app->{redirect_use_meta} = $options{UseMeta};
    unless ($url =~ m!^https?://!i) {
        $url = $app->base . $url;
    }
    $app->{redirect} = $url;
    return;
}

sub param {
    my $app = shift;
    return unless $app->{query};
    if (@_) {
        $app->{query}->param(@_);
    } else {
        wantarray ? ( $app->{query}->param ) : $app->{query};
    }
}

sub blog {
    my $app = shift;
    $app->{_blog} = shift if @_;
    return $app->{_blog} if $app->{_blog};
    return undef unless $app->{query};
    my $blog_id = $app->param('blog_id');
    if ($blog_id) {
        $app->{_blog} = MT::Blog->load($blog_id, {cached_ok=>1});
    }
    return $app->{_blog};
}

## Logging/tracing

sub log {
    my $app = shift;
    my($msg) = @_;
    require MT::Log;
    my $log = MT::Log->new;
    if (ref $msg eq 'HASH') {
        $log->set_values($msg);
        $msg = $msg->{'message'} || '';
    } elsif ((ref $msg) && (UNIVERSAL::isa($msg, 'MT::Log'))) {
        $log = $msg;
    } else {
        $log->message($msg);
    }
    $log->ip($app->remote_ip);
    if (my $blog = $app->blog) {
        $log->blog_id($blog->id);
    }
    if (my $user = $app->user) {
        $log->author_id($user->id);
    }
    $log->level(MT::Log::INFO())
        unless defined $log->level;
    $log->class('system')
        unless defined $log->class;
    $log->save;
}

sub trace {
    my $app = shift;
    $app->{trace} ||= [];
    push @{$app->{trace}}, "@_";
    if ($MT::DebugMode & 2) {
        require Carp;
        local $Carp::CarpLevel = 1;
        push @{$app->{trace}}, Carp::longmess("Stack trace:");
    }
    if ($MT::DebugMode & 128) {
        my @caller = caller(1);
        my $place = $caller[0] . '::' . $caller[3] . ' in ' . $caller[1] . ', line ' . $caller[2];
        print STDERR "(warn from $place) @_\n";
        if ($MT::DebugMode & 2) {
            local $Carp::CarpLevel = 1;
            print STDERR Carp::longmess("Stack trace:");
        }
    }
}

sub remote_ip {
    my $app = shift;
    my $ip = $app->config->TransparentProxyIPs
        ? $app->get_header('X-Forwarded-For')
        : ($ENV{MOD_PERL}
           ? $app->{apache}->connection->remote_ip
           : $ENV{REMOTE_ADDR});
    $ip ||= '127.0.0.1';
    if ($ip =~ m/,/) {
        $ip =~ s/.+,\s*//;
    }
    return $ip;
}

sub document_root {
    my $app = shift;
    my $cwd = '';
    if ( $ENV{MOD_PERL} ) {
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

sub static_file_path {
    my $app = shift;
    return $app->{__static_file_path}
        if exists $app->{__static_file_path};

    my $path = $app->config('StaticFilePath');
    return $app->{__static_file_path} = $path if $path && -d $path;

    # Attempt to derive StaticFilePath based on environment
    my $web_path = $app->config->StaticWebPath || 'mt-static';
    $web_path =~ s!^https?://[^/]+/!!;
    my $doc_static_path = File::Spec->catdir($app->document_root(), $web_path);
    return $app->{__static_file_path} = $doc_static_path
        if -d $doc_static_path;
    my $mtdir_static_path = File::Spec->catdir($app->mt_dir, 'mt-static');
    return $app->{__static_file_path} = $mtdir_static_path
        if -d $mtdir_static_path;
    return;
}

sub errtrans {
    my $app = shift;
    return $app->error($app->translate(@_));
}

sub DESTROY {
    ## Destroy the Request object, which is used for caching
    ## per-request data. We have to do this manually, because in
    ## a persistent environment, the object will not go out of scope.
    ## Same with the ConfigMgr object and ObjectDriver.
    MT::Request->finish();
    undef $MT::Object::DRIVER;
    undef $MT::ConfigMgr::cfg;
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

=head2 $app->template_paths

Returns an array of directory paths where application templates exist.

=head2 $app->find_file(\@paths, $filename)

Returns the path and filename for a file found in any of the given paths.
If the file cannot be found, it returns undef.

=head2 $app->load_tmpl($file[, @params])

Loads a L<MT::Template> template using the filename specified. See the
documentation for the C<build_page> method to learn about how templates
are located. The optional C<@params> are passed to the L<MT::Template>
constructor.

=head2 $app->set_default_tmpl_params($tmpl)

Assigns standard parameters to the given L<MT::Template> C<$tmpl> object.
Refer to the L<STANDARD APPLICATION TEMPLATE PARAMETERS> section for a
complete list of these parameters.

=head2 $app->charset

Gets or sets the application's character set based on the "PublishCharset"
configuration setting or the encoding of the active language
(C<$app-E<gt>current_language>).

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

=head2 $app->envelope

This method is deprecated.

=head2 $app->static_path

Returns the application's static web path.

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

Returns the active weblog, if available. The I<blog_id> query
parameter identifies this weblog.

=head2 $app->touch_blogs

An internal routine that is used during the end of an application
request to update each L<MT::Blog> object's timestamp if any of it's
child objects were changed during the application request.

=head2 $app->build_page($tmpl_name, \%param)

Builds an application page to be sent to the client; the page name is specified
in C<$tmpl_name>, which should be the name of a template containing valid
L<MT::Template> markup. C<\%param> is a hash ref whose keys and values will
be passed to L<MT::Template::param> for use in the template.

On success, returns a scalar containing the page to be sent to the client. On
failure, returns C<undef>, and the error message can be obtained from
C<$app-E<gt>errstr>.

=head3 How does build_page find a template?

The C<build_page> function looks in several places for an app
template. Two configuration directives can modify these search paths,
and application and plugin code can also affect them.

The I<TemplatePath> config directive is an absolute path to the directory
where MT's core application templates live. It defaults to the I<mt_dir>
plus an additional path segment of 'tmpl'.

The optional I<AltTemplatePath> config directive is a path (absolute
or relative) to a directory where some 'override templates' may
live. An override template takes the place of one of MT's core
application templates, and is used interchangeably with the core
template. This allows power users to customize the look and feel of
the MT application. If I<AltTemplatePath> is relative, its base path
is the value of the Movable Type configuration file.

Next, any application built on the C<MT::App> foundation can define
its own I<template_dir> parameter, which identifies a subdirectory of
TemplatePath (or AltTemplatePath) where that application's templates
can be found. I<template_dir> defaults to C<cms>. Most templates will
be found in this directory, but sometimes the template search will
fall through to the parent directory, where a default error template
is found, for example. I<template_dir> should rightly have been named
I<application_template_dir>, since it is application-specific.

Finally, a plugin can specify its I<plugin_template_path>, which
locates a directory where the templates for that plugin's own
interface are found. If the I<plugin_template_path> is relative, it
may be relative to either the I<app_dir>, or the I<mt_dir>; the former
takes precedence if it exists. (for a definition of I<app_dir> and
I<mt_dir>, see L<MT>)

Given these values, the order of search is as follows:

=over 4

=item * I<plugin_template_path>

=item * I<AltTemplatePath>

=item * I<AltTemplatePath>F</>I<template_dir>

=item * I<TemplatePath>/I<template_dir>

=item * I<TemplatePath>

=back

If a template with the given name is not found in any of these
locations, an ugly error is thrown to the user.

=head2 $app->build_page_in_mem($tmpl, \%param)

Used internally by the L<build_page> method to render the output
of a L<MT::Template> object (the first parameter) using the parameter
data (the second parameter). It additionally calls the L<process_mt_template>
method (to process any E<lt>MT_ACTIONE<gt> and E<lt>MT_X:YE<gt> marker tags)
and then L<translate_templatized> (to process any E<lt>MT_TRANSE<gt> tags).

=head2 $app->process_mt_template($str)

Processes the E<lt>MT_ACTIONE<gt> tags that are present in C<$str>. These tags
are in the following format:

    <MT_ACTION mode="mode_name" parameter="value">

The mode parameter is required (and must be the first attribute). The
following attributes are appended as regular query parameters.

The MT_ACTION tag is a preferred way to specify application links rather
than using this syntax:

    <TMPL_VAR NAME=SCRIPT_URL>?__mode=mode_name&parameter=value

C<process_mt_templates> also strips the C<$str> variable of any tags in
the format of C<E<lt>MT_\w+:\w+E<gt>>. These are 'marker' tags that are
used to identify specific portions of the template page and used in
conjunction with the transformer callback helper methods C<tmpl_prepend>,
C<tmpl_append>, C<tmpl_replace>, C<tmpl_select>.

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

Returns a hash reference containing all of the query parameter names
and their values. Example:

    my $data = $app->param_hash;
    my $title = $data->{entry_title};

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
    MTE - Movable Type Enterprise

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

    <TMPL_VAR NAME=STATIC_URI>images/logo.gif

With a StaticWebPath of '/mt/', this produces:

    /mt/mt-static/images/logo.gif

or, if StaticWebPath is 'http://example.com/mt-static/':

    http://example.com/mt-static/images/logo.gif

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
