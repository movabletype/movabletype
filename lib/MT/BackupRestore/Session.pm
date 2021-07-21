# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::BackupRestore::Session;
use strict;
use warnings;
use MT::Session;

sub start {
    my ($class, $name, $id) = @_;
    MT::Session->remove({ kind => 'BU', name => $name });
    my $sess = MT::Session->new;
    $sess->id($id);
    $sess->kind('BU');
    $sess->name($name);
    $sess->start(time);
    $sess->set('progress', []);
    $sess->set('files', {});
    $sess->set('urls', []);
    $sess->set('done', 0);
    $sess->save;
    return bless {sess => $sess}, $class;
}

sub load {
    my ($self, $name) = @_;
    my $sess = MT::Session->load({ kind => 'BU', name => $name }) or return;
    if (ref $self) {
        $self->{sess} = $sess;
        return $self;
    }
    return bless {sess => $sess}, $self;
}

sub sess {
    my $self = shift;
    return $self->{sess};
}

sub combine {
    my ($self) = @_;
    $self = $self->load($self->sess->name);
    return {map { $_ => $self->sess->get($_) } ('progress', 'urls', 'done')};
}

sub progress {
    my ($self, $str, $id) = @_;
    $self = $self->load($self->sess->name);
    push @{ $self->sess->get('progress') }, { message => $str, $id ? (id => $id) : () };
    $self->sess->save;
}

sub urls {
    my ($self, $urls) = @_;
    $self = $self->load($self->sess->name);
    my $files = $self->sess->get('urls');
    push @$files, @$urls;
    $self->sess->save;
}

sub file {
    my ($self, $fname) = @_;
    return unless $fname;
    $self = $self->load($self->sess->name);
    my $files = $self->sess->get('files');
    $files->{$fname} = 1;
    $self->sess->save;
}

sub get_file {
    my ($self, $fname) = @_;
    $self = $self->load($self->sess->name);
    my $files = $self->sess->get('files');
    delete $files->{$fname} or return; # only one time available
    $self->sess->save;
    return $fname;
}

sub done {
    my ($self) = @_;
    $self = $self->load($self->sess->name);
    $self->sess->set('done', 1);
    $self->sess->save;
}

sub purge {
    my $class = shift;

    my $iter = MT::Session->load_iter(
        { kind  => 'BU', start => [undef, time - MT->config->UserSessionTimeout] },
        { range => { start => 1 } });

    my @ids = ();
    while ( my $s = $iter->() ) {
        push @ids, $s->id;
    }

    return unless @ids;
    MT::Session->remove( { id => \@ids } );
}

1;
