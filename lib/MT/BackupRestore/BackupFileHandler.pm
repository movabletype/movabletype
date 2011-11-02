# Movable Type (r) Open Source (C) 2001-2011 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::BackupRestore::BackupFileHandler;

use strict;
use warnings;
use XML::SAX::Base;
use MIME::Base64;

@MT::BackupRestore::BackupFileHandler::ISA = qw(XML::SAX::Base);

sub new {
    my $class   = shift;
    my (%param) = @_;
    my $self    = bless \%param, $class;
    require MT::BackupRestore::ObjectCreator;
    $self->{oc} = MT::BackupRestore::ObjectCreator->new(%param);
    return $self;
}

sub start_document {
    my $self = shift;
    my $data = shift;

    $self->{start} = 1;
    $self->{current_class} = '';
    $self->{current} = undef;

    $self->{oc}->set_is_pp($self->{is_pp});
    1;
}

sub start_element {
    my $self = shift;
    my $data = shift;

    if ( $self->{start} ) {
        return $self->__inspect_root_element($data);
    }

    my $name  = $data->{LocalName};
    my $attrs = $data->{Attributes};
    my $ns    = $data->{NamespaceURI};

    my $callback = $self->{callback};

    if ( my $current = $self->{current} ) {
        # this is an element for a text column of the object
        $self->{current_text} = [$name];
        return 1;
    }

    if ( MT::BackupRestore::NS_MOVABLETYPE() ne $ns ) {
        my $obj = $self->{oc}->start_non_mt_element($data);
        $self->{current} = $obj if defined($obj) && ( '1' ne $obj );
        return 1;
    }


    my $class = MT->model($name);
    unless ($class) {
        push @{ $self->{errors} },
            MT->translate(
            '[_1] is not a subject to be restored by Movable Type.',
            $name );
        return 1;
    }

    if ( $self->{current_class} ne $class ) {
        if ( my $c = $self->{current_class} ) {
            my $records = $self->{records};
            $self->{oc}->run_callback(
                MT->translate("[_1] records restored.", $records),
                $c->class_type || $c->datasource
            );
        }
        $self->{records}       = 0;
        $self->{current_class} = $class;
        my $state = MT->translate( 'Restoring [_1] records:', $class );
        $self->{oc}->set_new_class($class);
        $self->{oc}->run_callback($name);
    }

    $self->{current} = $self->{oc}->start_object($data);
    1;
}

sub characters {
    my $self = shift;
    my $data = shift;

    return if !exists( $self->{current} );
    if ( my $text_data = $self->{current_text} ) {
        push @$text_data, $data->{Data};
        $self->{current_text} = $text_data;
    }
    1;
}

sub end_element {
    my $self = shift;
    my $data = shift;

    my $obj = $self->{current};
    return unless $obj;

    if ( my $text_data = delete $self->{current_text} ) {
        my $column_name = shift @$text_data;
        $self->{current}->{$column_name} = $text_data;
        return;
    }

    $self->{oc}->save_object($obj, $data);
    delete $self->{current};
}

sub __inspect_root_element {
    my ($self, $data) = @_;

    my $name  = $data->{LocalName};
    my $attrs = $data->{Attributes};
    my $ns    = $data->{NamespaceURI};

    die MT->translate(
        'Uploaded file was not a valid Movable Type backup manifest file.'
        )
        if !(      ( 'movabletype' eq $name )
                && ( MT::BackupRestore::NS_MOVABLETYPE() eq $ns )
        );

    #unless ($self->{ignore_schema_conflicts}) {
    my $schema = $attrs->{'{}schema_version'}->{Value};

    #if (('ignore' ne $self->{schema_version}) && ($schema > $self->{schema_version})) {
    if ( $schema != $self->{schema_version} ) {
        $self->{critical} = 1;
        my $message = MT->translate(
            'Uploaded file was backed up from Movable Type but the different schema version ([_1]) from the one in this system ([_2]).  It is not safe to restore the file to this version of Movable Type.',
            $schema, $self->{schema_version}
        );
        MT->log(
            {   message  => $message,
                level    => MT::Log::ERROR(),
                class    => 'system',
                category => 'restore',
            }
        );
        die $message;
    }

    #}
    $self->{start} = 0;
    return 1;
}

sub end_document {
    my $self = shift;
    my $data = shift;

    if ( my $c = $self->{current_class} ) {
        my $records = $self->{records};
        $self->{oc}->run_callback(
            MT->translate( "[_1] records restored.", $records ),
            $c->class_type || $c->datasource
        );
    }

    1;
}


1;
