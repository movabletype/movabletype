# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::ContentType::UniqueID;
use strict;
use warnings;
use MT::Util::Encode qw(encode_utf8_if_flagged);
use MT::Util::UniqueID qw(create_sha1_id MT_CONTENT_TYPE_NS MT_CONTENT_FIELD_NS MT_CONTENT_DATA_NS);
use MT;

my $Max_retry_count = 3;

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
        my $ns =
              $obj->isa('MT::ContentType')  ? MT_CONTENT_TYPE_NS
            : $obj->isa('MT::ContentField') ? MT_CONTENT_FIELD_NS
            : $obj->isa('MT::ContentData')  ? MT_CONTENT_DATA_NS
            :                                 '';
        my $unique_id = create_sha1_id($ns, encode_utf8_if_flagged($name));
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

