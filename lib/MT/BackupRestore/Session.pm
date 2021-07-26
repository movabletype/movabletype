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
    if (my $existing = MT::Session->load({ kind => 'BU', name => $name })) {
        my $dir = $existing->get('dir');
        if ($dir && -d $dir) {
            require File::Path;
            File::Path::rmtree($dir);
        }
        $existing->remove;
    }
    my $sess = MT::Session->new;
    $sess->id($id);
    $sess->kind('BU');
    $sess->name($name);
    $sess->start(time);
    $sess->set('progress', []);
    $sess->set('files',    {});
    $sess->set('urls',     []);
    $sess->set('done',     0);
    $sess->save;
    return bless { sess => $sess }, $class;
}

sub load {
    my ($self, $name) = @_;
    $name ||= ref $self ? $self->{sess}->name : return;
    my $sess = MT::Session->load({ kind => 'BU', name => $name }) or return;
    if (ref $self) {
        $self->{sess} = $sess;
        return $self;
    }
    return bless { sess => $sess }, $self;
}

sub sess {
    my $self = shift;
    return $self->{sess};
}

sub combine {
    my ($self, @fields) = @_;
    $self = $self->load;
    return { map { $_ => $self->sess->get($_) } @fields };
}

sub progress {
    my ($self, $progress, $append) = @_;
    if ($progress->[0] eq "\n") {
        warn caller(0);
        warn caller(1);
    }
    if (defined($progress)) {
        die '$progress must be an ARRAY ref' unless (ref $progress && ref $progress eq 'ARRAY');
        my $array = [$progress] unless (ref $progress->[0]);
        $self = $self->load;
        my $loaded = $self->sess->get('progress');
        @$loaded = () unless $append;
        push @{$loaded}, { message => $_->[0], $_->[1] ? (id => $_->[1]) : () } for @$array;
        $self->sess->save;
    } else {
        return $self->get('progress');
    }
}

sub urls {
    my ($self, $urls, $append) = @_;
    if (defined($urls)) {
        die '$url must be an ARRAY ref' unless (ref $urls && ref $urls eq 'ARRAY');
        if ($append) {
            $self = $self->load;
            push @{ $self->sess->get('urls') }, @$urls;
            return $self->sess->save;
        } else {
            return $self->set('urls', $urls);
        }
    } else {
        return $self->get('urls');
    }
}

sub file {
    my ($self, $fname) = @_;
    if (defined($fname)) {
        $self = $self->load;
        $self->sess->get('files')->{$fname} = 1;
        return $self->sess->save;
    } else {
        return $self->get('files');
    }
}

sub check_file {
    my ($self, $fname) = @_;
    $self = $self->load;
    delete $self->sess->get('files')->{$fname} or return;    # only one time available
    $self->sess->save;
    return $fname;
}

sub asset_ids {
    my ($self, $asset_ids, $append) = @_;
    if (defined($asset_ids)) {
        die '$url must be an ARRAY ref' unless (ref $asset_ids && ref $asset_ids eq 'ARRAY');
        if ($append) {
            $self = $self->load;
            push @{ $self->sess->get('asset_ids') }, @$asset_ids;
            return $self->sess->save;
        } else {
            return $self->set('asset_ids', $asset_ids);
        }
    } else {
        return $self->get('asset_ids');
    }
}

sub dir {
    my ($self, $dir) = @_;
    if (defined($dir)) {
        require MT::FileMgr;
        MT::FileMgr->new('Local')->mkpath($dir) unless -d $dir;
        return                                  unless -d $dir && -w $dir;
        return $self->set('dir', $dir);
    } else {
        return $self->get('dir');
    }
}

sub dialog_params {
    my ($self, $params) = @_;
    return defined($params) ? $self->set('dialog_params', $params) : $self->get('dialog_params');
}

sub error {
    my ($self, $error) = @_;
    return defined($error) ? $self->set('error', $error) : $self->get('error');
}

sub done {
    my ($self, $done) = @_;
    return defined($done) ? $self->set('done', $done) : $self->get('done');
}

sub set {
    my ($self, $name, $val) = @_;
    $self = $self->load;
    $self->sess->set($name, $val);
    $self->sess->save;
    return 1;
}

sub get {
    my ($self, $name) = @_;
    return $self->load->sess->get($name);
}

sub purge {
    my ($class, $ttl) = @_;

    my $iter = MT::Session->load_iter(
        { kind  => 'BU', start => [undef, time - $ttl] },
        { range => { start => 1 } });

    my @ids = ();
    while (my $sess = $iter->()) {
        my $dir = $sess->get('dir');
        if ($dir && -d $dir) {
            require File::Path;
            File::Path::rmtree($dir);
        }
        push @ids, $sess->id;
    }

    MT::Session->remove({ id => \@ids }) if @ids;
}

1;

=head1 NAME

MT::BackupRestore::Session - Backup and Restore sesssion manager

=head1 SYNOPSIS

    use MT::BackupRestore::Session;

    my $sess = MT::BackupRestore::Session->start('restore:'. $user_id, $id);
    # or
    my $sess = MT::BackupRestore::Session->load('restore:'. $user_id);

=head1 DESCRIPTION

I<MT::BackupRestore::Session> provides backup & restore session management methods.

=head1 METHODS

=head2 $class->start($name, $id)

Constructor. This automatically creates a BU typed session data on database.

    my $sess = MT::BackupRestore::Session->start('restore:'. $user_id, $id);

=head2 $class_or_instance->load($name);

Load or reload a existing session by calling as class method or instance method respectively.
I<name> is required when you call it as class method.

    # Load by name
    my $sess = MT::BackupRestore::Session->load('restore:'. $user_id);

    # Reload
    $sess->load;

=head2 $instance->sess;

Get raw L<MT::Session> instance of a the instance.

    $sess->sess;

=head2 $instance->combine(@fields)

Get session values for given field names in hash reference.

    my $hash_ref = $sess->combine(@fields);

=head2 $instance->progress($progress, $append)

Set or get progress data.

    $sess->progress([$msg]);
    $sess->progress([$msg, $id]);
    $sess->progress([[$msg, $id], [$msg, $id]]);
    $sess->progress([[$msg, $id], [$msg, $id]], $append);
    my $array_ref = $sess->progress;

=head2 $instance->urls($urls, $append)

Set or get urls.

    $sess->urls([$url]);
    $sess->urls([$url1, $url2]);
    $sess->urls([$url1, $url2], $append);
    $array_ref = $sess->urls;

=head2 $instance->file($fname)

Set or get files.

    $sess->file($filename);
    my $hash_ref = $sess->file; # {filename => 1}

=head2 $instance->check_file($fname)

Check if a file with given name exists or not. Since the file download is only available one time, the method automatically delete the name.

    my $filename = $sess->check_file($filename) or die 'file not found';

=head2 $instance->asset_ids($asset_ids, $append)

Set or get asset_ids.

    $sess->asset_ids([$id1, $id2]);
    $sess->asset_ids([$id1], $append);
    my $array_ref = $sess->asset_ids;

=head2 $instance->dir($path)

Set or get a path for working directory.

    $sess->dir('/path/to/dir');
    my $dir = $sess->dir;

=head2 $instance->dialog_params($query)

Set or get a dialog parameters in a URL encoded query string.

    $sess->dialog_params('key1=value1&key2=value2');
    my $params = $sess->dialog_params;

=head2 $instance->error($message)

Set or get a error message.

    $sess->error('some error occured');
    my $error = $sess->error;

=head2 $instance->done($bool)

Set or get whether or not the process is done.

    $sess->done(1);
    $sess->done(0);
    my $is_done = $sess->done;

=head2 $instance->set($name, $value)

General purgose setter.

    $sess->set('field', $value);

=head2 $instance->get($name)

General purgose getter.

    $sess->get('field');

=head2 $instance->purge($ttl)

Purge session with given TTL.

    $sess->purge($ttl);

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
