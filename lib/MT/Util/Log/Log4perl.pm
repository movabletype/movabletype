# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
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

sub use_config { 1 }

sub new {
    my ( $self, $logger_level, $log_file ) = @_;

    if ( my $config = MT->config('LoggerConfig') ) {
        Log::Log4perl::Config->allow_code(0);
        Log::Log4perl::init($config);
        return $self;
    }

    my $level = $logger_level || MT->config->Loggerlevel;
    my $numval = Log::Log4perl::Level::to_priority( uc $level );

    Log::Log4perl->easy_init(
        {   file   => ">>$log_file",
            layout => "%m%n",
            level  => $numval,
            utf8   => 1,
        }
    );

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

sub notice {
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
