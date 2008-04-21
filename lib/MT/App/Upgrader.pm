# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::App::Upgrader;
use strict;

use MT::App;
@MT::App::Upgrader::ISA = qw(MT::App);
use MT::BasicAuthor;
use MT::Util;
use MT::I18N;
use JSON;

sub id { 'upgrade' }

use vars qw($MAX_TIME);
sub BEGIN {
    $MAX_TIME = 5;
}

sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
    $app->add_methods(
        'main' => \&main,
        'install' => \&upgrade,
        'upgrade' => \&upgrade,
        'run_actions' => \&run_actions,
        'init_user' => \&init_user,
        'init_blog' => \&init_blog,
    );
    $app->{user_class} = 'MT::BasicAuthor';
    $app->{template_dir} = 'cms';
    $app->{plugin_template_path} = '';
    $app;
}

sub init_request {
    my $app = shift;
    $app->SUPER::init_request(@_);
    $app->set_no_cache;
    $app->{default_mode} = 'install';
    my $mode = $app->mode || $app->{default_mode};
    $app->{requires_login} = ($mode eq 'upgrade') || ($mode eq 'main');
}

sub login {
    my $app = shift;
    my $q = $app->{query};
    my $cookies = $app->{cookies};
    my($user, $pass, $remember, $crypted, $cookie_middle);
    my $first_time = 0;
    my $cookie_name = $app->user_cookie;
    if ($cookies->{$cookie_name} && (defined $cookies->{$cookie_name}->value)) {
        ($user, $cookie_middle, $remember) = split /::/, $cookies->{$cookie_name}->value;
    } elsif ($cookies->{'user'}) {   # 1.1 - 2.661
        ($user, $cookie_middle, $remember) = split /::/, $cookies->{'user'}->value;
    }else{
        $cookie_middle = '';
        $remember = '';
    }
    if ($q->param('username') && $q->param('password')) {
        $first_time = 1;
        $user = $q->param('username');
        $pass = $q->param('password');
        $remember = $q->param('remember') || '';
        $crypted = 0;
    }
    return unless $user && ($pass || $cookie_middle);
    if (my @author = MT::BasicAuthor->load({ name => $user })) {
        foreach my $author (@author) {
            # skip any possible non-authors...
            if (MT::Auth->password_exists) {
                next unless $author->password;
                next if $author->password eq '(none)';
            }
            my $valid = 0;
            if ($pass) {
                if ($author->is_valid_password($pass, $crypted)) {
                    $app->request('fresh_login', 1);
                    $valid = 1;
                }
            } elsif ($cookie_middle) {
                # try checking old-style cookie using crypt'd password
                # then try the magic token if user is using new cookie
                # format...
                if ( ( 'MT' eq $app->config->AuthenticationModule )
                  && ( $author->is_valid_password($cookie_middle, 1) ) ) {
                    $valid = 1;
                } elsif ($cookie_middle eq $author->magic_token) {
                    $valid = 1;
                } elsif (eval{require MT::BasicSession;MT::BasicSession->load($cookie_middle)}) {
                    $valid = 1;
                }
            }
            if ($valid) {
                $app->{author} = $author;
                if ($cookie_middle ne $author->magic_token) {
                    my %arg = (-name => $cookie_name,
                               -value => join('::',
                                              $author->name,
                                              $author->magic_token,
                                              # note this is BasicAuthor::magic_token
                                              $remember),
                               -path => $app->config('CookiePath') || $app->mt_path
                               );
                    $app->bake_cookie(%arg);
                }
                return($author, $first_time);
            } else {
                return undef;    # error message?
            }
        }
    }
    ## Login invalid, so get rid of cookie (if it exists) and let the
    ## user know.
    $app->bake_cookie(-name => $cookie_name, -value => '',
        -expires => '-1y', -path => $app->config('CookiePath') || $app->mt_path)
        unless $first_time;
    return $app->error($app->translate('Invalid login.'));
}

# build_page needs to know what to use as the magic token
sub current_magic {
    my $app = shift;
    return $app->{author}->magic_token if $app->{author};
}

sub upgrade {
    my $app = shift;

    my $install_mode;
    my %param;

    my $ver = $^V ? join('.', unpack 'C*', $^V) : $];
    my $perl_ver_check = '';
    if ($] < 5.006001) {  # our minimal requirement for support
        $param{version_warning} = 1;
        $param{perl_version} = $ver;
        $param{perl_minimum} = '5.6.1';
    }

    my $method = $app->request_method;

    my $driver = MT::Object->driver;
    my $author_class = MT->model('author');
    if (!$driver || !$driver->table_exists($author_class)) {
        $install_mode = 1;
        if ($method ne 'POST') {
            return $app->build_page("install.tmpl", \%param);
        }
    }

    if ($method ne 'POST') {
        return $app->main();
    }

    $app->validate_magic or return;

    # if code flows here, this is upgrading
    my $steps;
    eval {
        local $app->{upgrading} = 1;
        require MT::Upgrade;
        MT::Upgrade->do_upgrade(Install => 0, DryRun => 1, App => $app);
        my $steps = $app->response->{steps};
        my $fn = \%MT::Upgrade::functions;
        if ($steps && @$steps) {
            @$steps = sort { $fn->{$a->[0]}->{priority} <=>
                             $fn->{$b->[0]}->{priority} } @$steps;
        }
    };
    die $@ if $@;
    $steps = $app->response->{steps};
    my $json_steps;
    if ($steps && @$steps) {
        $json_steps = objToJson($steps);
    }

    $param{up_to_date} = $json_steps ? 0 : 1;
    $param{initial_steps} = $json_steps;

    return $app->build_page('upgrade_runner.tmpl', \%param);
}

my @keys = qw( admin_email hint preferred_language admin_nickname admin_username initial_user initial_password initial_nickname initial_email initial_hint initial_lang initial_external_id );

sub init_user {
    my $app = shift;
    my ($param) = @_;

    my $method = $app->request_method;
    if ($method ne 'POST') {
        return $app->main();
    }

    $app->validate_magic or return;

    my %param = $app->unserialize_config;
    if (!$app->param('continue')) {
        return $app->build_page('install.tmpl', \%param);
    }

    foreach my $key (@keys) {
        $param{$key} = $app->param($key);
    }

    my $initial_user = $app->param('admin_username');
    my $initial_password = '';
    my $initial_nickname = $app->param('admin_nickname') || '';
    my $initial_email = $app->param('admin_email') || '';
    my $initial_hint = $app->param('hint') || '';
    my $initial_lang = $app->param('preferred_language');
    my $initial_external_id = '';

    require MT::Auth;
    my $mode = $app->config("AuthenticationModule");
    #my ($pref) = split /\s+/, $mode;

    if (!MT::Auth->password_exists) {
        # external authentication; validate password
        my $pass = $app->param('admin_password');
        # validate login
        my $err = '';
        my $author = new MT::BasicAuthor;
        $author->name($initial_user);
        if (MT::Auth->is_valid_password($author, $pass, 0, \$err)) {
            $initial_password = $pass;
            $app->param('name', $initial_user);
            my $error = MT::Auth->sanity_check($app);
            if ($error) {
                $param{error} = $error;
                return $app->build_page('install.tmpl', \%param);
            } else {
                $initial_email = $app->param('email') || '';
                $initial_nickname = $app->param('nickname') || '';
                $initial_external_id = MT::Author->unpack_external_id($app->param('external_id')) if $app->param('external_id');
            }
        } else {
            $param{error} = $app->translate("Failed to authenticate using given credentials: [_1].", $err);
            return $app->build_page('install.tmpl', \%param);
        }
    } else {
        my $pass = $app->param('admin_password');
        my $pass2 = $app->param('admin_password_confirm');
        $pass = '' unless defined $pass;
        $pass2 = '' unless defined $pass2;
        if (length($pass)) {
            if ($pass2 eq $pass) {
                $initial_password = $pass;
            } else {
                $param{error} = $app->translate("You failed to validate your password.");
                return $app->build_page('install.tmpl', \%param);
            }
        } else {
            $param{error} = $app->translate("You failed to supply a password.");
            return $app->build_page('install.tmpl', \%param);
        }
    }
    if ($mode eq 'MT') {
        if (!MT::Util::is_valid_email($initial_email)) {
            $param{error} = $app->translate("The e-mail address is required.");
            return $app->build_page('install.tmpl', \%param);
        }
        $initial_hint =~ s!^\s+|\s+$!!gs;
    }

    $param{initial_user} = $initial_user;
    $param{initial_password} = $initial_password;
    $param{initial_nickname} = $initial_nickname;
    $param{initial_email} = $initial_email;
    $param{initial_hint} = $initial_hint;
    $param{initial_lang} = $initial_lang;
    $param{initial_external_id} = $initial_external_id;
    $param{config} = $app->serialize_config(%param);
    $app->init_blog(\%param);
}

sub init_blog {
    my $app = shift;
    my ($param) = @_;
    my %param;

    $param{config} = $param->{config} || $app->param('config');
    $param{blog_name} = $app->param('blog_name');
    $param{blog_url} = $app->param('blog_url') || '';
    $param{blog_path} = $app->param('blog_path') || '';
    $param{blog_timezone} = $app->param('blog_timezone');
    $param{blog_template_set} = $app->param('blog_template_set');
    $param{blog_path} =~ s!(/|\\)$!!;
    $param{blog_url} .= '/' if $param{blog_url} !~ m!/$!;

    my $tz = $app->param('blog_timezone') || $app->config('DefaultTimezone');
    my $param_name = 'blog_timezone_'.$tz;
    $param_name =~ s/[\-\.]/_/g;
    $param{$param_name} = 1;

    my $sets = $app->registry("template_sets");
    $sets->{$_}{key} = $_ for keys %$sets;
    $sets->{'mt_blog'}{selected} = 1;
    $sets = [ values %$sets ];
    no warnings;
    @$sets = sort { $a->{order} <=> $b->{order} } @$sets;
    $param{'template_set_loop'} = $sets;
    $param{'template_set_index'} = $#$sets;

    if ($app->param('back')) {
        return $app->init_user;
    }
    if (!$app->param('finish')) {
        # suggest site_path & site_url
        my $path = $app->config('DefaultSiteRoot');
        if (!$path){
            $path = $app->document_root();
        }
        $param{blog_path} = File::Spec->catdir( $path, 'BLOG-NAME' );

        my $url = $app->config('DefaultSiteURL');
        if (!$url) {
            $url = $app->base . '/';
            $url =~ s!/cgi(?:-bin)?(/.*)?$!/!;
            $url =~ s!/mt/?$!/!i;
        }
        $param{blog_url} = $url . 'BLOG-NAME/';
        
        return $app->build_page('setup_initial_blog.tmpl', \%param);
    }

    # check to publishing path (writable?)
    my $site_path;
    if ( -d $param{blog_path} ){
        $site_path = $param{blog_path};
    } else {
        my @dirs = File::Spec->splitdir($param{blog_path});
        pop @dirs;
        $site_path = File::Spec->catdir(@dirs);
    }
    if (!-w $site_path) {
            $param{error} = $app->translate("The path provided below is not writable.", $param{blog_path});
        return $app->build_page('setup_initial_blog.tmpl', \%param);
    }

    my %config = $app->unserialize_config();
    foreach my $key (@keys) {
        $param{$key} = $config{$key};
    }

    my $new_user;
    my $new_blog;
    use URI::Escape;
    $new_user = {
        user_name => uri_escape($param{initial_user}),
        user_nickname => uri_escape($param{initial_nickname}),
        user_password => uri_escape($param{initial_password}),
        user_email => uri_escape($param{initial_email}),
        user_lang => $param{initial_lang},
        user_hint => uri_escape($param{initial_hint}),
        user_external_id => $param{initial_external_id},
    };
    $new_blog = {
        blog_name => uri_escape($param{blog_name}),
        blog_url => uri_escape($param{blog_url}),
        blog_path => uri_escape($param{blog_path}),
        blog_timezone => $param{blog_timezone},
        blog_template_set => $param{blog_template_set} || 'mt_blog',
    };

    my $steps;
    my $install_mode = 1;
    eval {
        local $app->{upgrading} = 1;
        require MT::Upgrade;
        MT::Upgrade->do_upgrade(Install => $install_mode, DryRun => 1,
            App => $app, ($install_mode ? (User => $new_user, Blog => $new_blog) : ()));
        my $steps = $app->response->{steps};
        my $fn = \%MT::Upgrade::functions;
        if ($steps && @$steps) {
            @$steps = sort { $fn->{$a->[0]}->{priority} <=>
                             $fn->{$b->[0]}->{priority} } @$steps;
        }
    };
    die $@ if $@;
    $steps = $app->response->{steps};
    my $json_steps;
    if ($steps && @$steps) {
        $json_steps = objToJson($steps);
    }

    $param{installing} = $install_mode;
    $param{up_to_date} = $json_steps ? 0 : 1;
    $param{initial_steps} = $json_steps;

    return $app->build_page('upgrade_runner.tmpl', \%param);
}

sub finish {
    my $app = shift;

    if ($app->{author}) {
        require MT::Author;
        my $author = MT::Author->load($app->{author}->id);
        my $cookie_obj = $app->start_session($author);
        my $response = $app->response;
        $response->{cookie} = { map { $_ => $cookie_obj->{$_} } (keys %$cookie_obj) };
    }    
}

sub run_actions {
    my $app = shift;

    $| = 1;

    $app->{no_print_body} = 1;
    $app->send_http_header('text/plain');

    my $install_mode = $app->param('installing');

    if (!$install_mode) {
        $app->login;
    }

    my $schema = $app->{cfg}->SchemaVersion || 0;
    if ($schema) {
        if (!$app->validate_magic) {
            $app->response->{error} = $app->translate("Invalid session.");
            return $app->json_response;
        }
    }

    my $steps = $app->param('steps');
    $steps = jsonToObj($steps);

    my $start = time;
    my @steps = ( @$steps );
    my $step;

    my $fn = \%MT::Upgrade::functions;

    eval {
        local $app->{upgrading} = 1;
        require MT::Upgrade;
        MT::Upgrade->init;

        local $MT::Upgrade::App = $app;
        local $MT::Upgrade::Installing = $install_mode;
        local $MT::Upgrade::MAX_TIME = $MAX_TIME;

        while ($step = shift @steps) {
            my $result = MT::Upgrade->run_step($step);
            my $new_steps = $app->response->{steps};
            if (@$new_steps) {
                push @steps, @$new_steps;
                @steps = sort { $fn->{$a->[0]}->{priority} <=>
                                 $fn->{$b->[0]}->{priority} } @steps;
                $app->response->{steps} = [];
            }
            last unless $result;
            # don't run for more than our time limit
            last if time > $start + $MAX_TIME; 
        }
    };
    if ($@) {
        unshift @steps, $step if $step;
        $app->response->{error} = $@;
    }
    if ($app->errstr) {
        unshift @steps, $step;
        $app->response->{error} = $app->errstr;
    }

    if (@steps) {
        @steps = sort { $fn->{$a->[0]}->{priority} <=>
                         $fn->{$b->[0]}->{priority} } @steps;
        $app->response->{steps} = \@steps;
    }

    $app->json_response;
}

sub json_response {
    my $app = shift;
    $app->print(' JSON:' . objToJson($app->response));
}

sub response {
    my $self = shift || MT->instance;
    return unless ref $self;
    if (!$self->{response}) {
        $self->{response} = { steps => [], progress => [], error => undef };
    }
    $self->{response};
}

sub add_step {
    my $self = shift;
    push @{ $self->response->{steps} }, [ @_ ];
}

sub progress {
    my $app = shift;
    my ($msg, $make_id) = @_;
    $msg =~ s/^\s+//gs;
    $msg =~ s/\s+$//gs;
    $msg =~ s/\s+/ /gs;
    if ($make_id) {
        require MT::Util;
        my $id = MT::Util::dirify($make_id);
        $msg = qq{#$id $msg};
    }
    $app->print($msg . "\n");
}

sub error {
    my $app = shift;
    my ($msg) = @_;
    $app->SUPER::error(@_);
    return unless ref $app;
    $app->response->{error} = $msg;
    die $msg if ref $app && $app->{upgrading};
    return;
}

sub serialize_config {
    my $app = shift;
    my %param = @_;
 
    require MT::Serialize;
    my $ser = MT::Serialize->new('MT');
    my %set;
    foreach my $key (@keys) {
        $set{$key} = $param{$key};
    }
    my $set = \%set;
    unpack 'H*', $ser->serialize(\$set);
}

sub unserialize_config {
    my $app = shift;
    my $data = $app->param('config');
    my %config;
    if ($data) {
        $data = pack 'H*', $data;
        require MT::Serialize;
        my $ser = MT::Serialize->new('MT');
        my $thawed = $ser->unserialize($data);
        if ($thawed) {
            my $saved_cfg = $$thawed;
            if (keys %$saved_cfg) {
                foreach my $p (keys %$saved_cfg) {
                    $config{$p} = $saved_cfg->{$p};
                }
            }
        }
    }
    %config;
}

sub main {
    my $app = shift;
    my ($param) = @_;

    my $ver = $^V ? join('.', unpack 'C*', $^V) : $];
    my $perl_ver_check = '';
    if ($] < 5.006001) {  # our minimal requirement for support
        $param->{version_warning} = 1;
        $param->{perl_version} = $ver;
        $param->{perl_minimum} = '5.6.1';
    }

    my $driver = MT::Object->driver;
    my $author_class = MT->model('author');
    if (!$driver || !$driver->table_exists($author_class)) {
        my $method = $app->request_method;
        if ($param || ($method ne 'POST')) {
            $param->{admin_username} ||= $app->param('admin_username') || '';
            return $app->build_page("install.tmpl", $param);
        }
        $app->validate_magic or return;
        return $app->upgrade();
    }

    my $schema = $app->{cfg}->SchemaVersion || 0;
    my $version = $app->config->MTVersion || 0;

    if ($schema >= 3.2) {
        my $author;
        eval {
            require MT::Author;
            $author = MT::Author->load($app->{author}->id);
        };
        if ($author && !$author->is_superuser) {
            return $app->errtrans("No permissions. Please contact your administrator for upgrading Movable Type.");
        }
    }

    my $cur_schema = MT->schema_version;
    my $cur_version = MT->version_number;
    if ($cur_schema > $schema) {
        # yes, MT itself is needing an upgrade...
        $param->{mt_upgrade} = 1;
    }
    elsif ( $app->config->NotifyUpgrade && ($cur_version > $version) ) {
        $param->{mt_version_incremented} = 1;
        MT->log(MT->translate("Movable Type has been upgraded to version [_1].", $cur_version));
        $app->config->MTVersion( $cur_version, 1 );
        $app->config->save_config;
    }

    $param->{help_url} = $app->help_url();
    $param->{to_schema} = $cur_schema;
    $param->{from_schema} = $schema;
    $param->{mt_version} = $cur_version;

    my @plugins;
    my $plugin_ver = $app->{cfg}->PluginSchemaVersion;
    foreach my $plugin (@MT::Components) {
        if ($plugin->needs_upgrade) {
            push @plugins, { name => $plugin->label,
                version => $plugin->version };
        }
    }
    $param->{plugin_upgrades} = \@plugins if @plugins;
    $param->{needs_upgrade} = $param->{mt_upgrade} || (@plugins > 0);

    $app->build_page('upgrade.tmpl', $param);
}

sub build_page {
    my $app = shift;
    my ($tmpl, $param) = @_;
    $param ||= {};
    $param->{no_breadcrumbs} = 1;

    my $auth_mode = $app->config('AuthenticationModule');
    my ($pref) = split /\s+/, $auth_mode;
    $param->{"auth_mode_$pref"} = 1;

    my $auth = $app->user;
    if ( !$auth && $param->{needs_upgrade} ) {
        $auth = $app->login;
    }   
    my $langs = $app->supported_languages;
    my @data;
    my $preferred = $app->config('DefaultLanguage');
    $preferred = 'en-us' if (lc($preferred) eq 'en_us');
    for my $tag (keys %$langs) {
        (my $name = $langs->{$tag}) =~ s/\w+ English/English/;
        my $row = { l_tag => $tag, l_name => $app->translate($name) };
        $row->{l_selected} = 1 if $preferred eq $tag;
        push @data, $row;
    }
    $param->{languages} = [ sort { $a->{l_name} cmp $b->{l_name} }
                          @data ];

    $app->SUPER::build_page($tmpl, $param);
}

1;
__END__

=head1 NAME

MT::App::Upgrader

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
