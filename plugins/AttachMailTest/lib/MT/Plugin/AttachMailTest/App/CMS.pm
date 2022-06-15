# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Plugin::AttachMailTest::App::CMS;

use strict;
use warnings;

sub attach_mail_test_form {
    my ($app) = @_;
    my %params = (
        success => scalar($app->param('success')),
        error   => scalar($app->param('error')),
    );
    $app->build_page('cms/form.tmpl', \%params);
}

sub attach_mail_test_send {
    my ($app) = @_;
    my $cfg   = $app->config;
    my $q     = $app->param;
    my $body  = $q->param('body');
    my @parts = ($body);

    my $attach_count = 0;
    while (1) {
        my $field = 'attach' . ($attach_count + 1);
        my ($fh, $info) = $app->upload_info($field);
        if ($fh) {
            my $path     = $q->tmpFileName($fh);
            my $filename = $q->param('attach' . ($attach_count + 1) . '-name');
            $filename ||= ($info->{'Content-Disposition'} =~ qr{filename="?([^"]+)"?})[0];
            push @parts, { name => $filename, path => $path };
        } elsif (my $attach = $q->param($field)) {
            if (my $name = $q->param('attach' . ($attach_count + 1) . '-name')) {
                push @parts, { body => $attach, name => $name };
            } else {
                push @parts, { body => $attach };
            }
        } else {
            last;
        }
        $attach_count++;
    }

    require MT::Util::Mail;
    my %head = (
        To      => [split(',', scalar($q->param('to')))],
        Cc      => [split(',', scalar($q->param('cc')))],
        Bcc     => [split(',', scalar($q->param('bcc')))],
        From    => $cfg->EmailAddressMain,
        Subject => scalar($q->param('subject')),
    );

    my $ok = MT::Util::Mail->send(\%head, \@parts);

    my %args;

    if ($ok) {
        $args{success} = 1;
    } else {
        $args{error} = 1;
        MT->instance->log({
            message  => MT->translate('Error sending mail: [_1]', MT::Util::Mail->errstr),
            level    => MT::Log::ERROR(),
            class    => 'system',
            category => 'email'
        });
    }

    $app->redirect($app->uri(mode => 'attach_mail_test_form', args => \%args));
}

1;
