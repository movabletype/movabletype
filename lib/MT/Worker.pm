# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Worker;

use strict;
use warnings;
use base qw( TheSchwartz::Worker );

sub work_safely {
    my $self = shift;
    my ($job) = @_;

    my $app = MT->instance;
    if ($app->config->AuditLog) {
        require MT::Util::UniqueID;
        my $audit_data = {
            requestId => MT::Util::UniqueID::create_uuid(),
            userId    => undef,
            remoteIp  => undef,
            context   => {},
        };
        $app->run_callbacks( 'init_audit_data', $app, $audit_data );
        $app->request('MT::Core::Audit', $audit_data);
        require MT::Util::Log;
        MT::Util::Log::init();
        local $audit_data->{context}{job} = $job->funcname;
        MT::Util::Log->info('job started');
    }

    my $res = $self->SUPER::work_safely(@_);

    if ($app->config->AuditLog) {
        MT::Util::Log->info('job completed');
    }

    return $res;
}

1;
