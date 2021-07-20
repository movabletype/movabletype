# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Session;
use strict;
use warnings;

use MT::Object;
@MT::Session::ISA = qw( MT::Object );
__PACKAGE__->install_properties(
    {   column_defs => {
            'id'       => 'string(80) not null',
            'data'     => 'blob',
            'email'    => 'string(255)',
            'name'     => 'string(255)',
            'kind'     => 'string(2)',
            'start'    => 'integer not null',
            'duration' => 'integer',
        },
        indexes => {
            'start'    => 1,
            'name'     => 1,
            'kind'     => 1,
            'duration' => 1,
        },
        datasource  => 'session',
        primary_key => 'id',
    }
);

sub class_label {
    MT->translate("Session");
}

sub get_unexpired_value {
    my $timeout = shift;

    ## Do not use a cached session even when the driver supports it
    my $driver = __PACKAGE__->driver;
    my $disabled;
    if ( $driver->isa('Data::ObjectDriver::Driver::BaseCache') ) {
        $disabled = Data::ObjectDriver::Driver::BaseCache->Disabled || 0;
        Data::ObjectDriver::Driver::BaseCache->Disabled(1);
    }

    my $candidate = __PACKAGE__->load(@_);

    if ( defined $disabled ) {
        Data::ObjectDriver::Driver::BaseCache->Disabled($disabled);
    }

    if ( $candidate && $candidate->start() < time - $timeout ) {
        $candidate->remove();
        $candidate = undef;
    }
    return $candidate;
}

sub save {
    my $sess = shift;
    if ( my $data = $sess->{__data} ) {
        require MT::Serialize;
        my $ser = MT::Serialize->serialize( \$data );
        $sess->data($ser);
    }
    $sess->{__dirty} = 0;
    $sess->SUPER::save(@_);
}

sub is_dirty {
    my $sess = shift;
    $sess->{__dirty};
}

sub thaw_data {
    my $sess = shift;
    return $sess->{__data} if $sess->{__data};
    my $data = $sess->data;
    $data = '' unless $data;
    require MT::Serialize;
    my $out = MT::Serialize->unserialize($data);
    if ( ref $out eq 'REF' ) {
        $sess->{__data} = $$out;
    }
    else {
        $sess->{__data} = {};
    }
    $sess->{__dirty} = 0;
    $sess->{__data};
}

sub get {
    my $sess  = shift;
    my ($var) = @_;
    my $data  = $sess->thaw_data;
    $data->{$var};
}

sub set {
    my $sess = shift;
    my ( $var, $val ) = @_;
    if ( $sess->kind eq q{US} and $var eq q{US} ) {
        $sess->name($val);
    }
    my $data = $sess->thaw_data;
    $sess->{__dirty} = 1;
    $data->{$var} = $val;
}

sub purge {
    my $class = shift;
    my ( $kind, $ttl ) = @_;

    $class = ref($class) if ref($class);

    my $terms = { $kind ? ( kind => $kind ) : () };
    my $args = {};
    if ($ttl) {
        $terms->{start} = [ undef, time - $ttl ];
        $args->{range} = { start => 1 };
    }
    else {

        # use stored expiration period
        $terms->{duration} = [ undef, time ];
        $args->{range} = { duration => 1 };
    }

    $class->remove( $terms, $args )
        or return $class->error( $class->errstr );

    $class->purge_user_session_excession();

    1;
}

sub purge_user_session_excession {
    my $class       = shift;
    my $max         = MT->config('MaxUserSession') || return;
    my $target_kind = ['US', 'DS'];
    my $start_obj   = $class->load(
        { kind => $target_kind },
        { sort => 'start', direction => 'descend', limit => 1, offset => $max - 1 }) || return;
    $class->remove({ kind => $target_kind, start => [undef, $start_obj->start] }, { range => { start => 1 } });
}

1;

__END__

=pod

=head1 NAME

MT::Session - temporary storage of arbitrary data.

=head1 SYNOPSIS

Provides for the storage of arbitrary temporary data. The name
"session" is a hold-over from the days when commenter sessions were
the only kind of temporary data that MT stored.

A piece of temporary data is identified uniquely by an ID, but it also
has a "kind," a two-character identifier that separates different
usages of the table. The C<id> value must be distinct across all
kinds.

Each kind is associated with a fixed timeout window; records older
than that amount are deleted automatically.  Currently-used kinds are
as follows:

=over 4

=item SI

Active commenter sessions are held in SI sessions.

=item KY

The public key of the remote comment authentication service is held in
the I<single> record of kind 'KY'.

=item OT

The one time token that to exchange with commenter session.

=item AN

"Nonce" values (used for certain authentication systems) are stored
with a kind of 'AN'.

=item US

Active user sessions are held in 'US' records.

=item NW

The cached contents of the newsbox in the dashboard widget
is held in the I<single> record of kind 'NW'.

=item AF

Session data for Activity Feeds.

=item AS

AutoSave data for entry and template.

=item TF

Data for temporary file created during entry and template preview.

=item CR

Token stored for commenter registration.

=item CS

Cache of the result of blog search via mt-search.cgi

=item CO

Cached Object records store cache data of objects via MT::Cache::Session class.
Cache of the template module is the default use of the kind.

=item BU

BU indicates the backup session whose files should be downloaded 
only within the particular period of time.  Backup data can't be
downloaded using the link provided by MT after the period is expired.

=item CC

Category Cache is the cache of a particular category data.

=item SC

System Check is the result of the mt-check.cgi executed within the application
(from Tools menu item).

=item PT

Periodic Task indicates when a certain scheduled task is run the last time.

=item CA

CaptchA session stores the captcha token that is asked for a particular challenge.
It expiers after 10 minutes.

=item TC

Tag Cache is the cache of a particular tag data.

=item DU

Disk Usage is the cache for notify free disk space alert. Cloud.pack only.

=item DW

Cache for the dashboard widget content. Each widget should be separated by its ID.

=item DS

DataAPI Session.

=back

=head1 METHODS

=head2 $sess = MT::Session::get_unexpired_value($timeout[, $terms[, $args, ...]]);

Fetches the specified session record, if it is current (its C<start>
field falls within last $timeout seconds). Arguments following the
$timeout argument are passed directly to C<MT::Object::load>.

=head2 $sess->get($var)

Return the value of I<var>.

=head2 is_dirty

Return the value of the session I<__dirty> flag.

=head2 $sess->save()

Save the session data and unset the I<__dirty> flag.

=head2 $sess->set($var, $val)

Set the I<var> to I<val> and set the session I<__dirty> flag.

=head2 $sess->thaw_data()

Return the session data and unset the I<__dirty> flag.

=head2 MT::Session->class_label

Returns the localized descriptive name for this class.

=head2 MT::Session->purge($kind, $ttl)

Purges stale session records.  I<$kind> and I<$ttl> are both optional.
Pass I<$kind> and the method purges only the records that are of the kind.
Pass I<$ttl> and the method purges records that have lived more than the time-to-live.
If I<$ttl> is not specified, the method purges records that has specified duration
and the duration has been ended.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
