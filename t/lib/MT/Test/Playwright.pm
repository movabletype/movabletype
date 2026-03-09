package MT::Test::Playwright;

use Role::Tiny::With;
use strict;
use warnings;
use FindBin;
use Time::HiRes;
use 5.010;
use JSON::PP ();    # silence redefine warnings
use Test::More;
use Test::TCP;
use Plack::Runner;
use Plack::Builder;
use Plack::App::Directory;
use URI;
use URI::QueryParam;
use MT::PSGI;
use constant DEBUG => $ENV{MT_TEST_PLAYWRIGHT_DEBUG} ? 1 : 0;
use constant MY_HOST => $ENV{TRAVIS} ? $ENV{HOSTNAME} : '127.0.0.1';

with qw(
    MT::Test::Role::Request
    MT::Test::Role::WebQuery
);

plan skip_all => 'requires Playwright' unless eval { require Playwright };

sub new {
    my ( $class, $env, $args ) = @_;

    plan skip_all => "Playwright testing is skipped by env" if $ENV{MT_TEST_SKIP_PLAYWRIGHT};

    my $type = $ENV{MT_TEST_PLAYWRIGHT_TYPE} || 'chrome';

    my $server = Test::TCP->new(
        code => sub {
            my $port = shift;

            my $rebootable = $args && $args->{rebootable} &&
                    eval { require Server::Starter; require Net::Server::SS::PreFork; require Starman; 1 };

            my $host     = MY_HOST;
            my %extra    = (
                CGIPath        => "http://$host:$port/cgi-bin/",
                StaticWebPath  => "http://$host:$port/mt-static/",
                StaticFilePath => "$ENV{MT_HOME}/mt-static",
            );
            my $pid_file;
            if ($rebootable) {
                $pid_file           = "$ENV{MT_TEST_ROOT}/.server.pid";
                $extra{PIDFilePath} = $pid_file;
            }

            $env->update_config(%extra);

            if ($rebootable) {
                my @options = qw(-s Starman --workers 2);
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

    my $handle = Playwright->new(debug => DEBUG ? 1 : 0);
    my $browser = $handle->launch(headless => $ENV{MT_TEST_PLAYWRIGHT_HEADLESS} // 1, type => $type);

    bless {
        server   => $server,
        base_url => $base_url,
        handle   => $handle,
        browser  => $browser,
        pid      => $$,
    }, $class;
}

sub browser { shift->{browser} }
sub handle  { shift->{handle} }

sub DESTROY {
    my $self = shift;
    return unless $self->{pid} eq $$;
    my $handle = $self->{handle} or return;
    $handle->quit;
    $self->{server}->stop;
}

sub base_url {
    my $self = shift;
    $self->{base_url}->clone;
}

sub mt_url {
    my ($self, $params) = @_;
    my $url = $self->base_url;
    $url->path("/cgi-bin/mt.cgi");
    $url->query_form_hash($params) if $params;
    $url;
}

sub page {
    my $self = shift;
    $self->{page} ||= $self->browser->newPage;
}

sub login {
    my ($self, $user) = @_;
    my $page = $self->page;
    $page->on('console', 'console.log("CONSOLE: "+arguments[0].text())');
    $page->on('response', 'if (arguments[0].status() >= 300) {console.log("RESPONSE: "+arguments[0].status()+" "+arguments[0].url())}');
    $page->goto($self->mt_url->as_string);
    $self->{content} = $page->content;
    my $form = $self->form;
    $form->param( username => $user->name );
    $form->param( password => $user->id == 1 ? 'Nelson' : 'pass' );

    $self->_post_form($form);
}

sub _post_form {
    my ($self, $form) = @_;
    my $page = $self->page;
    my $submit;
    for my $input ($form->inputs) {
        my $type = $input->type;
        if ( $type =~ /(?:text|password)/ ) {
            $page->fill($self->_input_selector($input), $input->value);
        }
        if ( $type =~ /(?:check|radio)/ ) {
            if ($input->value) {
                $page->check($self->_input_selector($input));
            } else {
                $page->uncheck($self->_input_selector($input));
            }
        }
        if ( $type =~ /(?:select)/ ) {
            $page->selectOption($self->_input_selector($input), $input->value);
        }
        if ( $type eq 'submit' ) {
            $submit = $self->_input_selector($input);
        }
    }
    my $event = $self->{wait_for} || 'load';
    my $promise = $page->waitForEvent($event);
    my $res = $page->click($submit || '.btn-primary');
    $res = $self->handle->await($promise);
    $self->{content} = $page->content;
    return 1;
}

sub _input_selector {
    my ($self, $input) = @_;
    if ($input->id) {
        return '#' . $input->id;
    }
    elsif ($input->name) {
        my $type = $input->type;
        if ($type eq 'select') {
            return 'select[name=' . $input->name . ']';
        } elsif ($type eq 'textarea') {
            return 'textarea[name=' . $input->name . ']';
        } else {
            return 'input[name=' . $input->name . ']';
        }
    }
}

sub request {
    my ( $self, $params ) = @_;
    my $method = delete $params->{__request_method};
    my $request_url;
    my $page = $self->page;
    if ($method eq 'GET') {
        $request_url = $self->mt_url($params);
        $page->goto("$request_url");
        $self->{content} = $page->content;
    }
    elsif ($method eq 'POST') {
        my $form = $self->form;
        for my $key (keys %$params) {
            my $input = $form->find_input($key) or next;
            next if $input->readonly;
            $input->value($params->{$key});
        }
        $self->_post_form($self->form);
    }

    my $res;
    $res ||= HTTP::Response->new(200);
    return $self->{res} = $res;
}

1;
