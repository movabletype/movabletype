# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::ContentType::UniqueID;
use strict;
use warnings;

use Encode qw( encode_utf8 );

use MT;
use MT::Util qw( perl_sha1_digest_hex );

my $Max_retry_count = 3;

sub generate_unique_id {
    my $name = shift;
    unless ( defined $name && $name ne '' ) {
        $name = rand(9999);
    }
    my $key = join(
        $ENV{'REMOTE_ADDR'}     || '',
        $ENV{'HTTP_USER_AGENT'} || '',
        time, $$, rand(9999), encode_utf8($name)
    );
    return ( perl_sha1_digest_hex($key) );
}

sub set_unique_id {
    my ($obj) = @_;
    for my $i ( 1 .. $Max_retry_count ) {
        if ( $MT::DebugMode && $i > 1 ) {
            my $class = MT->model( $obj->datasource );
            my $obj_id = $obj->id || 0;
            warn "Try to generate unique_id of $class (ID:$obj_id) again";
        }
        my $name
            = $obj->can('name')  ? $obj->name
            : $obj->can('label') ? $obj->label
            :                      '';
        my $unique_id = generate_unique_id($name);
        unless ( _exist_same_unique_id( $unique_id, $obj ) ) {
            $obj->column( 'unique_id', $unique_id );
            return 1;
        }
    }
    die MT->translate('Cannot generate unique unique_id');
}

sub _exist_same_unique_id {
    my ( $unique_id, $obj ) = @_;
    $obj->exist(
        {   $obj->id ? ( id => { not => $obj->id } ) : (),
            unique_id => $unique_id,
        }
    );
}

1;

