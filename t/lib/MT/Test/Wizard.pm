package MT::Test::Wizard;

use strict;
use warnings;
use Test::More;
use MT::App::Wizard;
use MT::Test::App;
use Exporter 'import';
use Test::TCP;
use Module::Find qw/findsubmod/;

our @EXPORT = qw(test_wizard);

sub start_server {
    my $static_server = Test::TCP->new(
        code => sub {
            my $port = shift;
            exec "plackup", "-I", "$ENV{MT_HOME}/lib", "-I", "$ENV{MT_HOME}/extlib", "-p", $port,
                "-M", "Plack::App::Directory", "-M", "Plack::App::URLMap",
                "-e", "my \$map = Plack::App::URLMap->new; \$map->map('/mt-static' => Plack::App::Directory->new({root => '$ENV{MT_HOME}/mt-static'})->to_app ); \$map";
        },
    );
}

my @extra_modules = do { local @Module::Find::ModuleDirs = grep {m!\bt[\\/]lib\b!} @INC; findsubmod 'MT::Test::Wizard'; };
for my $module (@extra_modules) {
    eval "require $module";
}

my %default = (
    pre_start => {
        set_static_uri_to  => 'http://localhost/mt-static',
        set_static_file_to => File::Spec->catdir($ENV{MT_HOME}, 'mt-static'),
    },
    content_separation => {
        skip_content_separation => 'on',
    },
    packages  => {},
    configure => {
        dbtype   => 'mysql',
        dbname   => 'mt_test',
        dbuser   => 'mt',
        dbpass   => 'test',
        dbserver => 'localhost',
    },
    optional => {
        email_address_main => 'test@localhost.localdomain',
        mail_transfer      => 'sendmail',
        sendmail_path      => '/usr/sbin/sendmail',
    },
);

sub test_wizard {
    my %param = @_;
    my $guard = MT::Test::Wizard::ConfigGuard->new;

    local $ENV{MT_TEST_RUN_APP_AS_CGI} = 0;

    my $static_server = start_server();
    my $port          = $static_server->port;
    $default{pre_start}{set_static_uri_to} = "http://127.0.0.1:$port/mt-static";

    my $app = MT::Test::App->new('MT::App::Wizard');

    # XXX: for now
    no warnings 'redefine';
    local *MT::App::takedown = sub {};

    $app->get_ok();

    my %seen;
    my $ct        = 0;
    my $prev_step = '';
    local $MT::DebugMode = 1;
    until ((my $step = current_step($app) || '') eq 'seed') {
        die $app->content unless $step;
        die $app->content if $ct > 2;
        note "current step: $step";
        next_step($app, $seen{$step}++ ? {} : $param{$step} || $default{$step});
        if ($prev_step eq $step) {
            $ct++;
        } else {
            $ct = 0;
        }
        $prev_step = $step;
    }

    $app->content_like(qr/You've successfully configured Movable Type./);

    my $config = $app->_find_text('#config_settings pre.pre-scrollable');
    if ($param{mt_config}) {
        for my $line (@{ $param{mt_config}{like} || [] }) {
            like $config => qr/$line/, "'$line' exists";
        }
        for my $line (@{ $param{mt_config}{unlike} || [] }) {
            unlike $config => qr/$line/, "'$line' does not exist";
        }
    }
}

sub current_step {
    my $app  = shift;
    my $form = $app->form or return;
    $form->param('step');
}

sub next_step {
    my ($app, $param) = @_;
    my $callback = delete $param->{__test_after_post};
    my $form = $app->form or return;
    my $mode = $form->find_input('__mode');
    if (!$mode->value) {
        $mode->readonly(0);
        my (@new_modes) = map { $_->{onclick} =~ /go\(['"](.+?)['"]\)/; $1 } grep { ($_->class // '') =~ /primary/ and $_->{onclick} } $form->inputs;
        my $new_mode = @new_modes == 1 ? $new_modes[0] : 'next_step';
        $mode->value($new_mode);
    }
    my $test = $form->find_input('test');
    if ($test and $param->{test} and !$test->value) {
        $test->readonly(0);
        $test->value(delete $param->{test});
        $mode->value('test') if $mode->value eq 'next_step';
    }
    for my $name (keys %$param) {
        my $input = $form->find_input($name) or die "$name not found";
        $input->value($param->{$name});
    }
    $app->post_ok($form->click);
    ok !$app->generic_error, "no generic errors";
    if ($callback) {
        $callback->($app);
    }
}

package MT::Test::Wizard::ConfigGuard;

use strict;
use warnings;
use File::Spec;
use File::Copy qw(mv);

sub new {
    my $class  = shift;
    my $self   = bless {}, $class;
    my $config = File::Spec->catfile($ENV{MT_HOME}, 'mt-config.cgi');
    if (-e $config) {
        my $ct = '';
        my $backup;
        for my $ct ('', 1 .. 10) {
            $backup = File::Spec->catfile($ENV{MT_HOME}, 'mt-config.cgi.bak' . $ct);
            last if !-e $backup;
        }
        mv($config, $backup);
        $self->{config} = $config;
        $self->{backup} = $backup;
    }
    $self;
}

sub DESTROY {
    my $self = shift;
    if ($self->{backup} && $self->{config}) {
        mv $self->{backup} => $self->{config};
    }
}

1;
