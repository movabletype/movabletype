# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::TheSchwartz::Job;

use strict;
use warnings;
use base qw( MT::Object );
use MT::Util ();
use TheSchwartz::Job;

__PACKAGE__->install_properties(
    {   column_defs => {
            jobid => 'integer not null auto_increment'
            ,    # bigint unsigned primary key not null auto_increment
            funcid        => 'integer not null',   # int unsigned not null
            arg           => 'blob',               # mediumblob
            uniqkey       => 'string(255)',        # varchar(255) null
            insert_time   => 'integer',            # integer unsigned
            run_after     => 'integer not null',   # integer unsigned not null
            grabbed_until => 'integer not null',   # integer unsigned not null
            priority      => 'integer',            # smallint unsigned
            coalesce      => 'string(255)',        # varchar(255)
        },
        datasource  => 'ts_job',
        primary_key => 'jobid',
        indexes     => {
            funccoal => { columns => [ 'funcid', 'coalesce' ], },
            funcrun  => { columns => [ 'funcid', 'run_after' ], },
            funcpri  => { columns => [ 'funcid', 'priority' ], },
            uniqfunc => {
                columns => [ 'funcid', 'uniqkey' ],
                unique  => 1,
            },
        },
        role => q{global},
        cacheable => 0,
    }
);

my %FuncMap;

sub class_label {
    MT->translate("Background Job");
}

sub class_label_plural {
    MT->translate("Background Job");
}

sub _get_funcmap {
    unless (%FuncMap) {
        my @funcmaps = MT->model('ts_funcmap')->load(
            undef,
            {fetchonly => [qw/funcid funcname/]},
        );
        %FuncMap = map {$_->funcid => $_->funcname} @funcmaps;
    }
    \%FuncMap;
}

sub list_props {
    return {
        jobid => {
            base => '__virtual.id',
            order => 100,
        },
        funcid => {
            base => '__virtual.integer',
            label => 'Worker',
            order => 200,
            display => 'force',
            bulk_html => sub {
                my $prop = shift;
                my ( $objs, $app ) = @_;
                my $map = _get_funcmap();
                my @outs;
                for my $obj (@$objs) {
                    my $name = $map->{$obj->funcid};
                    $name =~ s/.+:://;
                    push @outs, $name;
                }
                @outs;
            },
        },
        arg => {
            base => '__virtual.string',
            label => 'Job Arg',
            order => 300,
            display => 'optional',
            html => sub {
                my $prop = shift;
                my ($obj, $app, $opts) = @_;
                # might be better to add triggers as orignal TheSchwartz::Job does but for backcompat atm
                my $arg = TheSchwartz::Job::_cond_thaw( $obj->arg );
                ref $arg ? eval { JSON::encode_json($arg) } : $arg;
            },
        },
        priority => {
            base => '__virtual.integer',
            label => 'Priority',
            order => 400,
            display => 'force',
            raw => sub {
                my $prop = shift;
                my ($obj, $app, $opts) = @_;
                return $obj->priority;
            },
        },
        uniqkey => {
            base => '__virtual.string',
            label => 'Unique Key',
            order => 500,
            display => 'optional',
            raw => sub {
                my $prop = shift;
                my ($obj, $app, $opts) = @_;
                return $obj->uniqkey;
            },
        },
        insert_time => {
            base => '__virtual.date',
            label => 'Insert Time',
            order => 600,
            display => 'force',
            raw => sub {
                my $prop = shift;
                my ( $obj, $app, $opts ) = @_;
                return MT::Util::epoch2ts(undef, $obj->insert_time);
            },
            sort => sub {
                my $prop = shift;
                my ($terms, $args) = @_;
                $args->{sort} = 'insert_time';
            },
        },
        status => {
            base => '__virtual.string',
            label => 'IsRunning',
            order => 700,
            display => 'default',
            raw => sub {
                my $prop = shift;
                my ($obj, $app, $opts) = @_;
                return '' unless $obj->grabbed_until;
                my $map = _get_funcmap();
                my $message;
                if (my $func = $map->{$obj->funcid}) {
                    if (eval "require $func; 1") {
                        my $started = $obj->grabbed_until - ($func->grab_for || 1);
                        my $started_at = MT::Util::format_ts('%Y-%m-%d %H:%M:%S', MT::Util::epoch2ts(undef, $started));
                        $message = MT->translate('Running from [_1]', $started_at);
                    } else {
                        $message = MT->translate('Running');
                    }
                }
                return $message;
            },
        },
        coalesce => {
            base => '__virtual.string',
            label => 'Coalesce',
            order => 800,
            display => 'optional',
            raw => sub {
                my $prop = shift;
                my ($obj, $app, $opts) = @_;
                return $obj->coalesce;
            },
        },
    };
}

1;
