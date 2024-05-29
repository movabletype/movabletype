package MT::Test::Selenium;

use Role::Tiny::With;
use strict;
use warnings;
use FindBin;
use Time::HiRes qw(time);
use File::Path;
use Try::Tiny;
use 5.010;
use JSON::PP ();    # silence redefine warnings
use JSON;
use Test::More;
use Test::TCP;
use Plack::Runner;
use Plack::Builder;
use Plack::App::Directory;
use File::Spec;
use File::Which qw/which/;
use Devel::GlobalDestruction;
use Encode;
use LWP::UserAgent;
use URI;
use URI::QueryParam;
use MT::PSGI;
use Selenium::Waiter;
use constant DEBUG => $ENV{MT_TEST_SELENIUM_DEBUG} ? 1 : $ENV{TRAVIS} ? 1 : 0;
use constant MY_HOST => $ENV{TRAVIS} ? $ENV{HOSTNAME} : '127.0.0.1';

with qw(
    MT::Test::Role::Wight
    MT::Test::Role::Request
    MT::Test::Role::WebQuery
);

our %EXTRA = (
    "Selenium::Chrome" => {
        'goog:chromeOptions' => {
            args => [
                'headless', ( DEBUG ? ('enable-logging') : () ),
                'window-size=1280,800', 'no-sandbox', 'disable-dev-shm-usage',
                'host-rules=MAP * '. MY_HOST,
            ],
            prefs => {
                'download.default_directory'   => $ENV{MT_TEST_ROOT},
                'download.prompt_for_download' => $JSON::false,
            },
            perfLoggingPrefs => {
                traceCategories => 'browser,devtools.timeline,devtools',
            },
        },
        'goog:loggingPrefs' => { performance => 'ALL', browser => 'ALL' },
        binaries     => [
            'chromedriver',
            '/usr/bin/chromedriver',
            '/usr/lib/chromium-browser/chromedriver',
            '/usr/lib64/chromium-browser/chromedriver',
        ],
    },
    "Selenium::Remote::Driver" => {
        'goog:chromeOptions' => {
            args => [
                'headless', ( DEBUG ? 'enable-logging' : () ),
                'window-size=1280,800', 'no-sandbox', 'disable-dev-shm-usage',
                'host-rules=MAP * '. MY_HOST,
            ],
            prefs => {
                'download.default_directory'   => $ENV{MT_TEST_ROOT},
                'download.prompt_for_download' => $JSON::false,
            },
            perfLoggingPrefs => {
                traceCategories => 'browser,devtools.timeline,devtools',
            },
        },
        'goog:loggingPrefs' => { performance => 'ALL', browser => 'ALL' },
        travis => {
            remote_server_addr => 'chromedriver',
            port               => 9515,
        },
    },
);

sub new {
    my ( $class, $env, $args ) = @_;

    plan skip_all => "Selenium testing is skipped by env" if $ENV{MT_TEST_SKIP_SELENIUM};

    my $driver_class = $ENV{MT_TEST_SELENIUM_DRIVER} || 'Selenium::Chrome';
    eval "require $driver_class" or plan skip_all => "No $driver_class";

    my $extra = $EXTRA{$driver_class} || {};

    my %driver_opts = (
        auto_close          => 1,
        default_finder      => 'css',
        extra_capabilities  => $extra,
        acceptInsecureCerts => 1,
        startup_timeout     => 10,
    );
    for my $binary ( @{ delete $extra->{binaries} || [] } ) {
        $binary = _fix_binary($binary) or next;
        $driver_opts{binary} = $binary;
        last;
    }

    my $ua = LWP::UserAgent->new(timeout => 300);
    $driver_opts{ua} = $ua;

    my $travis_config = delete $extra->{travis};

    if (DEBUG) {
        my $log_file = "$ENV{MT_HOME}/selenium_log.txt";
        $driver_opts{custom_args} = "--log-path=$log_file --verbose";
    }

    my $driver = eval { $driver_class->new(%driver_opts) }
        or plan skip_all => "Failed to instantiate $driver_class: $@";

    $driver->debug_on if DEBUG;

    my $server = Test::TCP->new(
        code => sub {
            my $port = shift;

            my $pid_file = "$ENV{MT_TEST_ROOT}/.server.pid";
            my $host     = MY_HOST;
            my %extra    = (
                CGIPath        => "http://$host:$port/cgi-bin/",
                StaticWebPath  => "http://$host:$port/mt-static/",
                StaticFilePath => "$ENV{MT_HOME}/mt-static",
                PIDFilePath    => $pid_file,
            );
            $env->update_config(%extra);

            if ($args->{rebootable} && 
                    eval { require Server::Starter; require Net::Server::SS::PreFork; require Starman; 1 }) {
                my @options = qw(-s Starman --workers 1);
                push @options, '--env', (DEBUG ? 'development' : 'production');
                Server::Starter::start_server(
                    port     => "$host:$port",
                    pid_file => $pid_file,
                    exec     => ['plackup', @options, "$ENV{MT_HOME}/mt.psgi"],
                );
                exit(0);
            }
            my $app        = MT::PSGI->new->to_app;
            my $static_app = Plack::App::Directory->new(
                root => "$ENV{MT_HOME}/mt-static" );

            my $builder = builder {
                mount "/mt-static" => builder {
                    enable 'AccessLog' if DEBUG;
                    $static_app;
                };
                mount "/" => builder {
                    enable 'AccessLog' if DEBUG;
                    $app;
                };
            };
            my $runner = Plack::Runner->new( app => $builder );
            $runner->parse_options(
                '--port'   => $port,
                '--env'    => ( DEBUG ? 'development' : 'test' ),
                '--server' => 'Standalone',
            );
            $runner->run;
        },
    );

    my $port     = $server->port;
    my $host     = MY_HOST;
    my $base_url = URI->new("http://$host:$port");

    bless {
        server   => $server,
        base_url => $base_url,
        driver   => $driver,
        pid      => $$,
    }, $class;
}

sub _fix_binary {
    my $binary = shift;
    if ( File::Spec->file_name_is_absolute($binary) ) {
        return $binary if -e $binary && -x _;
    }
    else {
        which($binary);
    }
}

sub driver { shift->{driver} }

sub DESTROY {
    my $self = shift;
    return unless $self->{pid} eq $$;
    if (in_global_destruction) {
        warn "Destroy MT::Test::Selenium object earlier!\nWebDriver may not be shut down properly at the global destruction";
    }
    my $driver = $self->{driver} or return;
    $driver->quit;
    $self->{server}->stop;
}

sub base_url {
    my $self = shift;
    $self->{base_url}->clone;
}

sub element { shift->{_element} }
sub content { shift->{content} }

sub login {
    my ( $self, $user ) = @_;
    my $url = $self->base_url;
    $url->path('/cgi-bin/mt.cgi');
    $self->driver->get("$url");
    $self->{content} = $self->driver->get_page_source;
    my $form = $self->form;
    $form->param( username => $user->name );
    $form->param( password => $user->id == 1 ? 'Nelson' : 'pass' );

    $self->_post_form($form);
}

sub _post_form {
    my ( $self, $form ) = @_;
    my $submit;
    for my $input ( $form->inputs ) {
        my $type = $input->type;
        if ( $type =~ /(?:text|password)/ ) {
            my $elem = $self->_find_by_input($input);
            $elem->clear;
            $elem->send_keys( $input->value );
        }
        if ( $type eq 'submit' ) {
            $submit = $self->_find_by_input($input);
        }
    }
    $submit->click();
}

sub _find_by_input {
    my ( $self, $input ) = @_;
    if ( $input->id ) {
        return wait_until { $self->driver->find_element_by_id( $input->id ) };
    }
    elsif ( $input->name ) {
        my $type = $input->type;
        if ( $type eq 'select' ) {
            Carp::croak "not implemented";
        }
        elsif ( $type eq 'textarea' ) {
            Carp::croak "not implemented";
        }
        else {
            return wait_until { $self->driver->find_element('input[name=' . $input->name . ']' ) };
        }
    }
    Carp::croak "Can't find elem from input";
}

sub find {
    my ( $self, $selector ) = @_;
    my $element = wait_until { $self->driver->find_element($selector); };
    Test::More::diag $@ if $@;
    $self->{_element} = $element;
    $self;
}

sub get_current_value {
    my ($self, $selector, $prop_name) = @_;
    $prop_name ||= 'value';
    $selector = quotemeta($selector);
    $prop_name = quotemeta($prop_name);
    wait_until { $self->driver->execute_script("return jQuery('$selector').prop('$prop_name');") };
}

sub mt_url {
    my ( $self, $params ) = @_;
    my $url = $self->base_url;
    $url->path("/cgi-bin/mt.cgi");
    $url->query_form_hash($params) if $params;
    $url;
}

sub request {
    my ( $self, $params ) = @_;
    my $method = delete $params->{__request_method};
    my $request_url;
    if ( $method eq 'GET' ) {
        $request_url = $self->mt_url($params);
        $self->driver->get("$request_url");
        $self->{content} = $self->driver->get_page_source;
    }
    elsif ( $method eq 'POST' ) {
        $request_url = $self->mt_url;
        my $submit;
        for my $key ( keys %$params ) {
            my $input = wait_until { $self->driver->find_element_by_name($key) };
            if ($input) {
                my $tag = lc $input->get_tag_name;
                if ( !$input->is_enabled or $input->is_hidden ) {
                    next;
                }
                if ( $tag eq 'input' ) {
                    my $type = lc $input->get_attribute('type');
                    if ( $type eq 'submit' ) {
                        $submit = $input;
                    }
                    elsif ( $type eq 'checkbox' ) {
                    }
                    elsif ( $type eq 'radio' ) {
                    }
                    else {
                        $input->clear if defined $input->get_value;
                        $input->send_keys( $params->{$key} );
                    }
                }
                elsif ( $tag eq 'select' ) {
                    $input->click;
                    for my $option ( @{ $input->children('option') || [] } ) {
                        if ( $option->get_value eq $params->{$key} ) {
                            $option->set_selected;
                        }
                        elsif ( $option->is_selected ) {
                            $option->toggle;
                        }
                    }
                }
            }
        }
        my $source = $self->driver->get_page_source;
        if ($submit) {
            $submit->click;
        }
        else {
            $submit = wait_until { $self->driver->find_element_by_class('btn-primary') };
            $submit->click;
        }
    }

    if (DEBUG) {
        ## Typically warnings from jquery-migrate.js
        my $console_log = $self->driver->get_log('browser');
        note explain $console_log if @{ $console_log || [] };
    }

    my $logs   = $self->_get_response_logs;
    my @errors = grep { $_->{status} !~ /^[23]/ } @$logs;
    if (@errors) {
        note explain \@errors;
    }
    my $res;
    for my $log (@$logs) {
        next unless $log->{url} eq $request_url;

        # TODO: take care of redirection
        $res = HTTP::Response->new( $log->{status}, $log->{statusText},
            [ %{ $log->{headers} || {} } ] );
        $res->content(encode_utf8($self->{content}));
    }
    $res ||= HTTP::Response->new(200);
    return $self->{res} = $res;
}

sub _get_request_logs {
    my $self = shift;
    my $logs = $self->driver->get_log('performance');
    my @requests;
    for my $log (@$logs) {
        next unless $log->{message} =~ /Network\.requestWillBeSent/;
        my $message = decode_json( $log->{message} );
        my $req     = $message->{message}{params}{request} or next;
        push @requests, { map { $_ => $req->{$_} } qw/headers method url/ };
    }
    return \@requests;
}

sub _get_response_logs {
    my $self = shift;
    my $logs = $self->driver->get_log('performance');
    my @responses;
    for my $log (@$logs) {
        next unless $log->{message} =~ /Network\.responseReceived/;
        my $message = decode_json( $log->{message} );
        my $res     = $message->{message}{params}{response} or next;
        ## Add timing if requested?
        push @responses,
            { map { $_ => $res->{$_} }
                qw/headers status statusText url requestHeaders/ };
    }
    return \@responses;
}

sub get_browser_error_log {
    my ($self) = @_;
    state $ignore_hosts = join('|', ('narnia.na', 'example.com', 'creativecommons.org'));
    my $logs = $self->driver->get_log('browser');
    my @filtered;
    for my $log (@$logs) {
        if ($log->{source} eq 'network') {
            next if ($log->{message} =~ qr{^https?://($ignore_hosts)});
        }
        if ($log->{source} eq 'console-api' && $log->{level} =~ qr{INFO|WARNING}) {
            next;
        }
        push(@filtered, $log);
    }
    return @filtered;
}

sub screenshot {
    return unless $ENV{MT_TEST_CAPTURE_SCREENSHOT};
    # TODO consider zero padding for index numbers
    my ($self, $id) = @_;
    state $index = 1;
    state $evidence_dir = sprintf("%s/evidence/%s/%s", $FindBin::Bin, time, $FindBin::Script);
    File::Path::make_path("$evidence_dir");
    my $basename = $index. ($id ? '-'. $id : ''). '.png';
    $self->driver->capture_screenshot("$evidence_dir/$basename");
    $index++;
}

sub screenshot_full {
    return unless $ENV{MT_TEST_CAPTURE_SCREENSHOT};
    my ($self, $id, $width, $height) = @_;
    my $size_org = $self->driver->get_window_size();
    $width  = $width  || $self->driver->execute_script('return document.body.scrollWidth / (top === self ? 1 : 0.8)');
    $height = $height || $self->driver->execute_script('return document.body.scrollHeight / (top === self ? 1 : 0.8)');
    $self->driver->set_window_size($height, $width);
    my $name = $self->screenshot($id);
    $self->driver->set_window_size($size_org->{'height'}, $size_org->{'width'});
    return $name;
}

sub retry_until_success {
    my $self = shift;
    my $args = { limit => $ENV{MT_TEST_SELENIUM_MAX_RETRY} || 1, task => sub { }, teardown => sub { }, @_ };
    for my $i (1 .. $args->{'limit'}) {
        my $exception;
        my $ret = try {
            return $args->{'task'}->();
        } catch {
            $exception = $_;
            $exception =~ s{ at \S+ line \d+.*}{}s;
            diag(($i == $args->{'limit'} ? 'Aborting' : 'Retrying'). ': '. $exception);
            $args->{'teardown'}->();
        };
        return $ret unless defined($exception);
    }
    diag 'Failed';
    return;
}

sub wait_until_ready {
    my $self = shift;
    wait_until { $self->driver->execute_script("return document.readyState === 'complete'") };
}

sub scroll_to_element {
    my ($self, $selector) = @_;
    my $do_scroll = $self->driver->execute_script(qq{
        var button = document.querySelector('$selector');
        var rect = button.getBoundingClientRect();
        if (!((rect.top >= 0) && (rect.bottom < document.documentElement.clientHeight))) {
            window.scrollTo(0, rect.top + document.documentElement.scrollTop);
            return 1;
        } else {
            return 0;
        }
    });

    return unless $do_scroll;

    wait_until {
        my $is_finished = $self->driver->execute_script(qq{
            var rect = document.querySelector('$selector').getBoundingClientRect();
            return ((rect.top >= 0) && (rect.bottom < document.documentElement.clientHeight));
        });
        $is_finished;
    };
}

sub scroll_and_click {
    my ($self, $selector) = @_;
    $self->scroll_to_element($selector);
    $self->driver->find_element($selector, 'css')->click;
}

1;
