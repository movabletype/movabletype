# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.

package MT::ImportExport::Status;

use strict;
use warnings;
use base qw( MT::Object );
use MT::Util ();
use JSON;

__PACKAGE__->install_properties({
    column_defs => {
        'id'         => 'integer not null auto_increment',
        'blog_id'    => 'integer not null',
        'job_id'     => 'integer',
        'type'       => 'integer',                           # 0: import, 1: export
        'started_at' => 'integer',                           # epoch
        'ended_at'   => 'integer',                           # epoch
        'data'       => 'text',
    },
    indexes => {
        blog_id => 1,
    },
    datasource  => 'import_export_status',
    primary_key => 'id',
    audit       => 1,
    child_of    => ['MT::Blog', 'MT::Website'],
});

sub class_label {
    MT->translate("Import/Export Status");
}

sub class_label_plural {
    MT->translate("Import/Export Status");
}

sub as_hashref_for_site {
    my ($self, $site) = @_;
    my $status = $self->get_data;
    if (my $created_by = MT->model('author')->load($self->created_by)) {
        $status->{name} = $created_by->nickname || $created_by->name;
    } else {
        $status->{name} = MT->translate("(user deleted - ID:[_1])", $self->created_by);
    }
    if (my $started_at = $self->started_at) {
        # XXX: might be better to make format_epoch...
        $status->{started_at} = MT::Util::format_ts("%Y-%m-%d %H:%M:%S", MT::Util::epoch2ts($site, $started_at), $site);
    }
    if (my $ended_at = $self->ended_at) {
        $status->{ended_at} = MT::Util::format_ts("%Y-%m-%d %H:%M:%S", MT::Util::epoch2ts($site, $ended_at), $site);
    }
    $status->{created_on} = MT::Util::format_ts("%Y-%m-%d %H:%M:%S", $self->created_on, $site);
    $status->{job_id}     = $self->job_id;
    $status;
}

sub set_data {
    my ($self, $data) = @_;
    $self->data(JSON->new->utf8->canonical->encode($data));
}

sub get_data {
    my $self = shift;
    JSON->new->utf8->decode($self->data || '{}');
}

1;
