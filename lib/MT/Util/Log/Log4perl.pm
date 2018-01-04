# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Util::Log::Log4perl;
use strict;
use warnings;
use MT;
use base qw(MT::Util::Log);

BEGIN {
    use Log::Log4perl qw(:easy);
    use Log::Log4perl::Level;
}

sub new {
    my ( $self, $logger_level, $log_file ) = @_;

    my $level = $logger_level || MT->config->Loggerlevel;
    my $numval = Log::Log4perl::Level::to_priority( uc $level );

    eval {
        Log::Log4perl->easy_init(
            {   file   => ">>$log_file",
                layout => "%m%n",
                level  => $numval,
            }
        );
    };
    die $@ if $@;

    return $self;
}

sub debug {
    my ( $class, $msg ) = @_;
    my $logger = Log::Log4perl->get_logger();
    $logger->debug($msg);
}

sub info {
    my ( $class, $msg ) = @_;
    my $logger = Log::Log4perl->get_logger();
    $logger->info($msg);
}

sub warn {
    my ( $class, $msg ) = @_;
    my $logger = Log::Log4perl->get_logger();
    $logger->warn($msg);
}

sub error {
    my ( $class, $msg ) = @_;
    my $logger = Log::Log4perl->get_logger();
    $logger->error($msg);
}

1;
