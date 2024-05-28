package MT::Test::Wizard;

use strict;
use warnings;
use Test::More;
use MT::App::Wizard;
use Exporter 'import';

our @EXPORT = qw(test_wizard);

my @steps = qw(
    pre_start
    content_separation
    packages
    configure
    optional
    cfg_ldap_auth
    seed
);

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
    cfg_ldap_auth => {},
);

sub test_wizard {
    my %param = @_;
    my $guard = MT::Test::Wizard::ConfigGuard->new;

    my $app = MT::Test::App->new('MT::App::Wizard');
    if (MT->component('enterprise')) {
        # XXX: dirty hack to reinitialize a handler
        MT->component('enterprise')->{registry}{applications}{wizard}{wizard_template} = '$enterprise::MT::Enterprise::Wizard::template_hdlr';
    }

    $app->get_ok();

    my %seen;
    until ((my $step = current_step($app) || '') eq 'seed') {
        die $app->content unless $step;
        note "current step: $step";
        next_step($app, $seen{$step}++ ? {} : $param{$step} || $default{$step});
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
    my $form = $app->form or return;
    my $mode = $form->find_input('__mode');
    if (!$mode->value) {
        $mode->readonly(0);
        my (@new_modes) = map { $_->{onclick} =~ /go\(['"](.+?)['"]\)/; $1 } grep { ($_->class // '') =~ /primary/ and $_->{onclick} } $form->inputs;
        my $new_mode = @new_modes == 1 ? $new_modes[0] : 'next_step';
        $mode->value($new_mode);
    }
    for my $name (keys %$param) {
        my $input = $form->find_input($name) or die "$name not found";
        $input->value($param->{$name});
    }
    $app->post_ok($form->click);
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