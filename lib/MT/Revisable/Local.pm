# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

# Storing revision histories locally in the databse

package MT::Revisable::Local;

use strict;
use warnings;
use base 'MT::ErrorHandler';

sub revision_pkg {
    my $driver  = shift;
    my ($class) = @_;
    my $props   = $class->properties;

    return $props->{revision_pkg} if $props->{revision_pkg};

    my $rev = ref $class || $class;
    $rev .= '::Revision';

    return $props->{revision_pkg} = $rev;
}

sub revision_props {
    my $driver  = shift;
    my ($class) = @_;
    my $obj_ds  = $class->datasource;
    my $obj_id  = $obj_ds . '_id';
    return {
        key         => $class->datasource,
        column_defs => {
            id          => 'integer not null auto_increment',
            label       => 'string(255)',
            description => 'string(255)',
            $obj_id     => 'integer not null',
            $obj_ds     => 'blob not null',
            rev_number  => 'integer not null',
            changed     => 'string(255) not null'
        },
        indexes     => { $obj_id    => 1 },
        defaults    => { rev_number => 0 },
        audit       => 1,
        primary_key => 'id',
        datasource  => $class->datasource . '_rev'
    };
}

sub init_revisioning {
    my $driver     = shift;
    my ($class)    = @_;
    my $datasource = $class->datasource;

    my $subclass = $class->revision_pkg;
    return unless $subclass;

    my $rev_props = $class->revision_props;

    no strict 'refs';    ## no critic
    return if defined ${"${subclass}::VERSION"};

    ## Try to use this subclass first to see if it exists
    my $subclass_file = $subclass . '.pm';
    $subclass_file =~ s{::}{/}g;
    eval "# line " . __LINE__ . " " . __FILE__
        . "\nno warnings 'all';require '$subclass_file';$subclass->import();";
    if ($@) {
        ## Die if we get an unexpected error
        die $@ unless $@ =~ /Can't locate /;
    }
    else {
        ## This class exists.  We don't need to do anything.
        return 1;
    }

    my $class_name = ref $class || $class;
    my $base_class = 'MT::Object';

    my $subclass_src = "
        # line " . __LINE__ . " " . __FILE__ . "
        package $subclass;
        our \$VERSION = 1.0;
        use base qw($base_class);

        sub blog_id {
            my \$self = shift;
            return undef unless $class_name->has_column('blog_id');
            my \$parent = $class_name->load( \$self->${datasource}_id )
                or return undef;

            return \$parent->blog_id;
        }

        1;
    ";

    ## no critic ProhibitStringyEval
    eval $subclass_src
        or print STDERR "Could not create package $subclass!\n";

    $subclass->install_properties($rev_props);
}

sub save_revision {
    my $driver = shift;
    my ( $obj, $description ) = @_;
    my $datasource       = $obj->datasource;
    my $obj_id           = $datasource . '_id';
    my $packed_obj       = $obj->pack_revision();
    my $changed_cols     = $obj->{changed_revisioned_cols};
    my $current_revision = $obj->current_revision;

    require MT::Serialize;
    my $rev_class = MT->model( $datasource . ':revision' );
    my $revision  = $rev_class->new;
    $revision->set_values(
        {   $obj_id     => $obj->id,
            $datasource => MT::Serialize->serialize( \$packed_obj ),
            changed     => join ',',
            @$changed_cols,
        }
    );
    $revision->rev_number( ++$current_revision );
    $revision->description( substr $description, 0, 255 )
        if defined($description);
    $revision->save or return;

    return $current_revision;
}

sub object_from_revision {
    my $driver = shift;
    my ( $obj, $rev ) = @_;
    my $datasource = $obj->datasource;

    my $rev_obj        = $obj->clone;
    my $serialized_obj = $rev->$datasource;
    require MT::Serialize;
    my $packed_obj = MT::Serialize->unserialize($serialized_obj);

    if (ref $$packed_obj ne 'HASH') {
        $rev->remove();
        return;
    }

    $rev_obj->unpack_revision($$packed_obj);

    # Here we cheat since audit columns aren't revisioned
    $rev_obj->modified_by( $rev->created_by );
    $rev_obj->modified_on( $rev->modified_on );

    my @changed = split ',', $rev->changed;

    return [ $rev_obj, \@changed, $rev->rev_number, $rev ];
}

sub load_revision {
    my $driver = shift;
    my ( $obj, $terms, $args ) = @_;
    my $datasource = $obj->datasource;
    my $rev_class  = MT->model( $datasource . ':revision' );

    # Only specified a rev_number
    if ( defined $terms && ref $terms ne 'HASH' ) {
        $terms = { rev_number => $terms };
    }
    $terms->{ $datasource . '_id' } ||= $obj->id;

    if (wantarray) {
        my @rev = map { $obj->object_from_revision($_); }
            $rev_class->load( $terms, $args );
        unless (@rev) {
            return $obj->error( $rev_class->errstr );
        }
        return @rev;
    }
    else {
        my $rev = $rev_class->load( $terms, $args )
            or return $obj->error( $rev_class->errstr );
        my $array = $obj->object_from_revision($rev);
        return $array;
    }
}

sub handle_max_revisions {
    my $driver = shift;
    my ( $obj, $max ) = @_;
    $max ||= $MT::Revisable::MAX_REVISIONS;

    my $datasource = $obj->datasource;
    my $rev_class  = MT->model( $datasource . ':revision' );
    my $terms      = { $datasource . '_id' => $obj->id };
    my $count      = $rev_class->count($terms);
    if ( $max <= $count ) {
        my $rev_iter = $rev_class->load_iter(
            $terms,
            {   sort      => 'created_on',
                direction => 'ascend',
                limit     => $count - $max + 1
            }
        );
        while ( my $rev = $rev_iter->() ) {
            $rev->remove;
        }
        return $max - 1;
    }
    return $count;
}

sub remove_revisions {
    my $driver = shift;
    my ($obj) = @_;

    my $rpkg = $obj->revision_pkg or return;
    my $key = $obj->datasource . '_id';
    $rpkg->remove( { $key => $obj->id } );
}

1;
