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
    }
);

sub class_label {
    MT->translate("Job");
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
                my %func_ids = map {$_->funcid => 1} @$objs;
                my @funcmaps = MT->model('ts_funcmap')->load(
                    {funcid => [keys %func_ids]},
                    {fetchonly => [qw/funcid funcname/]},
                );
                my %map = map {$_->funcid => $_->funcname} @funcmaps;
                my @outs;
                for my $obj (@$objs) {
                    my $name = $map{$obj->funcid};
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
                return $obj->arg;
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
                return $obj->grabbed_until ? 'Running' : '';
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
