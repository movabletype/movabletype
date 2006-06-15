# Copyright 2001-2006 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::Log;
use strict;

use constant INFO     => 1;
use constant WARNING  => 2;
use constant ERROR    => 4;
use constant SECURITY => 8;
use constant DEBUG    => 16;

use vars qw(@ISA %Classes);
%Classes = (
    'system' => 'MT::Log',
    'entry' => 'MT::Log::Entry',
    'ping' => 'MT::Log::TBPing',
    'comment' => 'MT::Log::Comment',
);

use MT::Object;
@ISA = qw( MT::Object );

__PACKAGE__->install_properties({
    column_defs => {
        'id' => 'integer not null auto_increment',
        'message' => 'string(255)',
        'ip' => 'string(16)',
        'blog_id' => 'integer not null',
        'author_id' => 'integer',
        'level' => 'integer',
        'class' => 'string(255)',
        'category' => 'string(255)',
        'metadata' => 'string(255)',
    },
    indexes => {
        created_on => 1,
        blog_id => 1,
        level => 1,
        class => 1,
    },
    defaults => {
        blog_id => 0,
    },
    child_of => 'MT::Blog',
    datasource => 'log',
    audit => 1,
    primary_key => 'id',
});

sub new {
    my $pkg = shift;
    my $log = $pkg->SUPER::new(@_);
    if ($pkg eq __PACKAGE__) {
        $log->class('system');
    } else {
        $log->class($pkg);
    }
    $log;
}

sub init {
    my $log = shift;
    $log->SUPER::init(@_);
    my @ts = gmtime(time);
    my $ts = sprintf '%04d%02d%02d%02d%02d%02d',
        $ts[5]+1900, $ts[4]+1, @ts[3,2,1,0];
    $log->created_on($ts);
    $log->modified_on($ts);
    $log;
}

sub add_class {
    my $class = shift;
    my ($ident, $package) = @_;
    $Classes{$ident} = $package;
}

{
    my %bad_classes;

    sub set_values {
        my $obj = shift;
        $obj->SUPER::set_values(@_);
        my $pkg = $obj->class;
        $pkg = $Classes{$pkg} or return $obj;
        if ($pkg ne ref($obj)) {
            return $obj if exists $bad_classes{$pkg};
            unless (defined *{$pkg.'::'}) {
                eval "use $pkg;";
                if ($@) {
                    $bad_classes{$pkg} = 1;
                    return $obj if $@;
                }
            }
            $obj = bless $obj, $pkg if $pkg;
        }
        $obj;
    }
}

sub class_label { "System" }
sub description {
    my $log = shift;
    if ($log->message =~ m/\r?\n/) {
        return '<pre>' . $log->message . '</pre>';
    }
    undef;
}

sub metadata_object {
    my $log = shift;
    my $class = $log->metadata_class;
    return undef unless $class;
    my $id = int($log->metadata);
    return undef unless $id;
    eval "require $class;" or return undef;
    $class->load($id);
}

sub metadata_class {
    my $log = shift;
    my $pkg = ref $log || $log;
    if ($pkg =~ m/::Log::/) {
        $pkg =~ s/::Log::/::/;
        $pkg;
    } else {
        undef;
    }
}

sub to_hash {
    my $log = shift;
    my $hash = $log->SUPER::to_hash(@_);
    $hash->{"log.level_" . $log->level} = 1 if $log->level;
    $hash->{"log.class_" . $log->class} = 1 if $log->class;
    $hash->{"log.category_" . $log->category} = 1 if $log->category;
    if (my $obj = $log->metadata_object) {
        my $obj_hash = $obj->to_hash;
        $hash->{"log.$_"} = $obj_hash->{$_} foreach keys %$obj_hash;
    }
    if ($log->author_id) {
        require MT::Author;
        if (my $auth = MT::Author->load($log->author_id)) {
            # prefix these hash keys with "log" since this
            # log record may also refer to an entry/comment that
            # has an associated author/commenter record and that
            # would potentially clash with the log author record.
            # ie, author 1 deletes entry written by author 2
            # or author 1 deletes comment posted by commenter author 3
            my $auth_hash = $auth->to_hash;
            $hash->{"log.$_"} = $auth_hash->{$_} foreach keys %$auth_hash;
        }
    }
    return $hash;
}

package MT::Log::Entry;

@MT::Log::Entry::ISA = qw(MT::Log);

sub class_label { "Entries" }
sub description {
    my $log = shift;
    my $msg;
    if (my $entry = $log->metadata_object) {
        $msg = $entry->to_hash->{'entry.text_html'};
    } else {
        $msg = MT->translate('Entry # [_1] not found.', $log->metadata);
    }

    $msg;
}

package MT::Log::Comment;

@MT::Log::Comment::ISA = qw(MT::Log);

sub class_label { "Comments" }
sub description {
    my $log = shift;
    my $cmt = $log->metadata_object;
    my $msg;
    if ($cmt) {
        $msg = $cmt->to_hash->{'comment.text_html'};
    } else {
        $msg = MT->translate("Comment # [_1] not found.", $log->metadata);
    }
    $msg;
}

package MT::Log::TBPing;

@MT::Log::TBPing::ISA = qw(MT::Log);

sub class_label { "TrackBacks" }
sub description {
    my $log = shift;
    my $id = int($log->metadata);
    my $ping = $log->metadata_object;
    my $msg;
    if ($ping) {
        $msg = $ping->to_hash->{'tbping.excerpt_html'};
    } else {
        $msg = MT->translate("TrackBack # [_1] not found.", $log->metadata);
    }
    $msg;
}

1;
__END__

=head1 NAME

MT::Log - Movable Type activity log record

=head1 SYNOPSIS

    use MT::Log;
    my $log = MT::Log->new;
    $log->message('This is a message in the activity log.');
    $log->save
        or die $log->errstr;

=head1 DESCRIPTION

An I<MT::Log> object represents a record in the Movable Type activity log.

=head1 USAGE

As a subclass of I<MT::Object>, I<MT::Log> inherits all of the
data-management and -storage methods from that class; thus you should look
at the I<MT::Object> documentation for details about creating a new object,
loading an existing object, saving an object, etc.

=head1 DATA ACCESS METHODS

The I<MT::Log> object holds the following pieces of data. These fields can
be accessed and set using the standard data access methods described in the
I<MT::Object> documentation.

=over 4

=item * id

The numeric ID of the log record.

=item * message

The log entry.

=item * ip

The IP address related with the message; this is useful, for example, when
the message pertains to a failed login, to determine the IP address of the
user who attempted to log in.

=item * created_on

The timestamp denoting when the log record was created, in the format
C<YYYYMMDDHHMMSS>. Note that the timestamp has already been adjusted for the
selected timezone.

=item * modified_on

The timestamp denoting when the log record was last modified, in the format
C<YYYYMMDDHHMMSS>. Note that the timestamp has already been adjusted for the
selected timezone.

=back

=head1 DATA LOOKUP

In addition to numeric ID lookup, you can look up or sort records by any
combination of the following fields. See the I<load> documentation in
I<MT::Object> for more information.

=over 4

=item * created_on

=back

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
