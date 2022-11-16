# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

# An interface for any MT::Object that wishes to utilize versioning

package MT::Revisable;

use strict;
use warnings;

our $MAX_REVISIONS = 20;

{
    my $driver;

    sub _driver {
        my $driver_name = 'MT::Revisable::' . MT->config->RevisioningDriver;
        eval 'require ' . $driver_name;
        if ( my $err = $@ ) {
            die(MT->translate(
                    "Bad RevisioningDriver config '[_1]': [_2]",
                    $driver_name, $err
                )
            );
        }
        my $driver = $driver_name->new;
        die $driver_name->errstr
            if ( !$driver || ( ref( \$driver ) eq 'SCALAR' ) );
        return $driver;
    }

    sub _handle {
        my $method = ( caller(1) )[3];
        $method =~ s/.*:://;
        my $driver = $driver ||= _driver();
        return undef unless $driver->can($method);
        $driver->$method(@_);
    }

    sub release {
        undef $driver;
    }
}

sub install_properties {
    my $pkg        = shift;
    my ($class)    = @_;
    my $props      = $class->properties;
    my $datasource = $class->long_datasource;

    $props->{column_defs}{current_revision} = {
        label    => 'Revision Number',
        type     => 'integer',
        not_null => 1,
        default  => 0,
    };
    $class->install_column('current_revision');
    $props->{defaults}{current_revision} = 0;

    # Callbacks: clean list of changed columns to only
    # include versioned columns
    MT->add_callback( 'data_api_pre_save.' . $datasource,
        9, undef, \&mt_presave_obj );
    MT->add_callback( 'api_pre_save.' . $datasource,
        9, undef, \&mt_presave_obj );
    MT->add_callback( 'cms_pre_save.' . $datasource,
        9, undef, \&mt_presave_obj );

    # Callbacks: object-level callbacks could not be
    # prioritized and thus caused problems with plugins
    # registering a post_save and saving
    MT->add_callback( 'data_api_post_save.' . $datasource,
        9, undef, \&mt_postsave_obj );
    MT->add_callback( 'api_post_save.' . $datasource,
        9, undef, \&mt_postsave_obj );
    MT->add_callback( 'cms_post_save.' . $datasource,
        9, undef, \&mt_postsave_obj );

    $class->add_callback( 'post_remove', 0, MT->component('core'),
        \&mt_postremove_obj );
}

sub revision_pkg         { _handle(@_); }
sub revision_props       { _handle(@_); }
sub init_revisioning     { _handle(@_); }
sub handle_max_revisions { _handle(@_); }

sub revisioned_columns {
    my $obj  = shift;
    my $defs = $obj->column_defs;

    my @cols;
    foreach my $col ( keys %$defs ) {
        push @cols, $col
            if $defs->{$col} && exists $defs->{$col}{revisioned};
    }

    return \@cols;
}

sub is_revisioned_column {
    my $obj   = shift;
    my ($col) = @_;
    my $defs  = $obj->column_defs;

    return 1 if $defs->{$col} && exists $defs->{$col}{revisioned};
}

sub mt_presave_obj {
    my ( $cb, $app, $obj, $orig ) = @_;

    return 1 unless $app->isa('MT::App');
    return 1 unless $app->param('save_revision');

    $obj->gather_changed_cols( $orig, $app );
    return 1 unless exists $obj->{changed_revisioned_cols};

    # Collision Checking
    my $changed_cols = $obj->{changed_revisioned_cols};
    my $modified_by  = $obj->can('author') ? $obj->author : $app->user;

    if ( scalar @$changed_cols ) {
        my $current_revision = $app->param('current_revision') || 0;
        if (   $app->isa('MT::App::CMS')
            && $current_revision # not submitted if a user saves again on collision
            && $current_revision != $obj->current_revision
            )
        {
            my $return_args = $app->param('return_args');
            my %param       = (
                collision            => 1,
                return_args          => $return_args,
                modified_by_nickname => $modified_by->nickname
            );
            return $app->forward( "view", \%param );
        }
    }

    return 1;
}

sub mt_postsave_obj {
    my ( $cb, $app, $obj, $orig ) = @_;

    return 1 unless $app && $app->isa('MT::App');
    return 1 unless $app->param('save_revision');

    if ( exists $obj->{changed_revisioned_cols} ) {
        my $col = 'max_revisions_' . $obj->datasource;
        if ( my $blog = $obj->blog ) {
            my $max = $blog->$col;
            $obj->handle_max_revisions($max);
        } elsif ( $obj->datasource eq 'template' ) {
            my $global_max = MT->config->GlobalTemplateMaxRevisions;
            $obj->handle_max_revisions($global_max);
        }
        my $revision_note = $app->param('revision-note');
        my $revision      = $obj->save_revision($revision_note);
        $obj->current_revision($revision);

        # call update to bypass instance save method
        $obj->update or return $obj->error( $obj->errstr );
        if ( $obj->has_meta('revision') ) {
            $obj->revision($revision);

            # hack to bypass instance save method
            $obj->{__meta}->set_primary_keys($obj);
            $obj->{__meta}->save;
        }
    }

    return 1;
}

sub mt_postremove_obj {
    my ( $cb, $obj, $original ) = @_;

    # Remove revisions
    $obj->remove_revisions();
}

sub gather_changed_cols {
    my $obj = shift;
    my ($orig) = @_;

    my @changed_cols;
    my $revisioned_cols = $obj->revisioned_columns;

    my %date_cols = map { $_ => 1 }
        @{ $obj->columns_of_type( 'datetime', 'timestamp' ) };

    foreach my $col (@$revisioned_cols) {
        my $obj_col  = defined $obj->$col  ? $obj->$col  : '';
        my $orig_col = defined $orig->$col ? $orig->$col : '';
        next if $orig && $obj_col eq $orig_col;
        next
            if $orig
            && exists $date_cols{$col}
            && $orig_col eq MT::Object::_db2ts($obj_col);

        push @changed_cols, $col;
    }

    $obj->{changed_revisioned_cols} = \@changed_cols
        if @changed_cols;

    my $class = ref $obj || $obj;
    MT->run_callbacks( $class . '::gather_changed_cols', $obj, @_ );

    1;
}

sub pack_revision {
    my $obj    = shift;
    my $class  = ref $obj || $obj;
    my %values = %{ $obj->column_values };

    my $meta_values = $obj->meta;
    foreach my $key ( keys %$meta_values ) {
        next if $key eq 'current_revision';
        $values{$key} = $meta_values->{$key};
    }

    MT->run_callbacks( $class . '::pack_revision', $obj, \%values );

    return \%values;
}

sub unpack_revision {
    my $obj          = shift;
    my ($packed_obj) = @_;
    my $class        = ref $obj || $obj;

    delete $packed_obj->{current_revision}
        if exists $packed_obj->{current_revision};

    $obj->{is_revisioned} = 1;

    $obj->set_values($packed_obj);

    MT->run_callbacks( $class . '::unpack_revision', $obj, $packed_obj );
}

sub save_revision {
    my $obj   = shift;
    my $class = ref $obj || $obj;

    my $filter_result
        = MT->run_callbacks( $class . '::save_revision_filter', $obj );
    return if !$filter_result;

    MT->run_callbacks( $class . '::pre_save_revision', $obj, @_ );

    my $current_revision = _handle( $obj, @_ ) || 0;

    MT->run_callbacks( $class . '::post_save_revision',
        $obj, $current_revision );

    return $current_revision;
}

sub object_from_revision { _handle(@_); }
sub load_revision        { _handle(@_); }
sub remove_revisions     { _handle(@_); }

sub apply_revision {
    my $obj = shift;
    my ( $terms, $args ) = @_;

    my $rev = $obj->load_revision( $terms, $args )
        or return $obj->error(
        MT->translate( 'Revision not found: [_1]', $obj->errstr ) );
    my $rev_object = $rev->[0];
    $obj->set_values( $rev_object->column_values );
    $obj->save
        or return $obj->error( $obj->errstr );
    return $obj;
}

sub diff_object {
    my $obj_a = shift;
    my ( $obj_b, $diff_args ) = @_;

    return $obj_a->error(
        MT->translate(
            "There are not the same types of objects, expecting two [_1]",
            lc $obj_a->class_label_plural
        )
    ) if ref $obj_a ne ref $obj_b;

    my %diff;
    my $cols = $obj_a->revisioned_columns();
    foreach my $col (@$cols) {
        $diff{$col} = _diff_string( $obj_a->$col, $obj_b->$col, $diff_args );
    }

    return \%diff;
}

sub diff_revision {
    my $obj = shift;
    my ( $terms, $diff_args ) = @_;

    # Only specified a rev_number so diff with current
    if ( defined $terms && ref $terms ne 'HASH' ) {
        $terms = { rev_number => [ $_[0], $obj->current_revision ] };
    }
    my $args = {
        limit     => 2,
        sort_by   => 'created_on',
        direction => 'ascend'
    };

    my @revisions = $obj->load_revision( $terms, $args );
    my $obj_a     = $revisions[0]->[0];
    my $obj_b     = $revisions[1]->[0];

    return $obj->error(
        MT->translate( "Did not get two [_1]", lc $obj->class_label_plural ) )
        if ref $obj_a ne ref $obj || ref $obj_b ne ref $obj;

    my %diff;
    my $cols = $obj->revisioned_columns();
    foreach my $col (@$cols) {
        $diff{$col} = _diff_string( $obj_a->$col, $obj_b->$col, $diff_args );
    }

    return \%diff;
}

sub _diff_string {
    my ( $str_a, $str_b, $diff_args ) = @_;
    $diff_args ||= {};
    my $diff_method     = $diff_args->{method} || 'html_word_diff';
    my $limit_unchanged = $diff_args->{limit_unchanged};

    require HTML::Diff;
    Carp::croak(
        MT->translate( "Unknown method [_1]", 'HTML::Diff::' . $diff_method )
    ) unless HTML::Diff->can($diff_method);

    my $diff_result = eval "HTML::Diff::$diff_method(\$str_a, \$str_b)";
    my @result;
    foreach my $diff (@$diff_result) {
        unless ( $diff->[0] eq 'c' ) {    # changed has adds and removes
            push @result,
                {
                flag => $diff->[0],
                text => ( $diff->[0] eq '+' ) ? $diff->[2] : $diff->[1]
                };
        }
        else {
            push @result,
                {
                flag => '-',
                text => $diff->[1]
                };
            push @result,
                {
                flag => '+',
                text => $diff->[2]
                };
        }
    }
    return \@result;
}

sub is_revisioned {
    my $obj = shift;
    return $obj->{is_revisioned};
}

1;

__END__

=head1 NAME

MT::Revisable - An interface for any MT::Object that wishes to be versioned.

=head1 SUBCLASS INHERITANCE

To be versioned, an MT::Object subclass must first inherit MT::Revisable:

    package MT::Foo;
    use base qw( MT::Object MT::Revisable );

When a revision is saved, the entire object is taken and serialized.
However, in order to curb bloat, the saving of a revision is only triggered
when a versioned column has changed. To mark a column as versioned, simply add
the keyword C<revisioned> to the column definition:

    __PACKAGE__->install_properties({
        column_defs => {
            melody_nelson => 'string(255) not null revisioned
        }
    });

If at least one versioned column is changed

=head1 METHODS

=head2 $class->revision_pkg

Returned by C<MT->model($class->datasource . ':revision')> - the namespace of
the class that stores revisions for the class.

=head2 $class->revision_props

Returns a hashref of the install properties for the C<revision_pkg>

=head2 $class->init_revisioning

Called by the base C<MT::Object> class to initialize the revisioning framework
for the particular class. This may involve creating the C<revision_pkg>.

=head2 $class->revisioned_columns

Returns an arrayref of column names that are marked as being revisioned.

=head2 $class->is_revisioned_column($col)

Checks whether the passed column name has been marked as being revisioned

=head2 $obj->gather_changed_cols($orig, $app)

Compares the revisioned columns of C<$orig> with C<$obj> and stores an arrayref
of changed columns in C<$obj->{changed_revisioned_columns}>

=head2 $obj->pack_revision()

Creates the hashref that will be stored as a particular revision of the object.
By default, this hashref contains the values of the object's normal and meta
columns. The C<<package>::pack_revision> callback can be used to add further
values to be stored with the revision.

=head2 $obj->unpack_revision($packed_obj)

The opposite of C<pack_revision>, takes the C<$packed_obj> hashref and unpacks
it, setting the values of C<$obj> as needed. The C<<package>::unpack_revision>
callback can be used for any other keys added to C<$packged_obj> that are not
part of the normal or meta columns.

=head2 $obj->save_revision()

Called automatically when an object is saved from the MT web interface or
posted via a 3rd party client (on a low priority api/cms_post_save callback).
Saves a revision only if at least one revisioned column has changed.

# =head2 $obj->object_from_revision($revision)

=head2 $obj->load_revision(\%terms, \%args)

Loads revisions for the C<$obj>. Arguments work similarly to C<MT::Object->load>.
Thus, one can simply do C<$obj->load_revision($rev_numer)> or pass terms and
args. Terms can be any of the following:

=over

=item * id

=item * label

=item * description

=item * rev_number

=item * changed

=back

C<load_revision> should return an/array of arrayref(s) of:

=over

=item 0. The object stored at the revision

=item 1. An array ref of the changed columns that triggered the revision

=item 2. The revision number

=item 3. The revision class object

=back

=head2 $obj->apply_revision(\%terms, \%args)

Rolls back to the state of the object at C<$obj->load_revision(\%terms, \%args)>
and saves this action as a revision.

=head2 $obj->diff_object($obj_b)

Returns a hashref of column names with the values being an arrayref representation
of the diff:

    [<flag>, <left>, <right>]

with the flag being C<'u', '+', '-', 'c'>. See the C<HTML::Diff> POD for more
information.

=head2 $obj->diff_revision(\%terms, \%diff_args)

Loads the first object at C<$obj->load_revision(\%terms, \%args)> and returns
a hashref of column names with the values being an arrayref representation
of the diff:

    [<flag>, <left>, <right>]

with the flag being C<'u', '+', '-', 'c'>. See the C<HTML::Diff> POD for more
information.

=head2 $obj->is_revisioned()

Returns 1 if C<$obj> is revisioned object.

=head1 CALLBACKS

=head2 <package>::pack_revision

    sub pack_revision {
        my ($cb, $obj, $values) = @_;

    }

This callback is run after C<$values> is initially populated by C<$obj->pack-revision()>
and is a hashref of the normal and meta column values and allows you to modify
C<$values> before it is saved with the revision. Thus, you can use this callback
to augment what is stored with every revision.

=head2 <package>::unpack_revision

    sub unpack_revision {
        my ($cb, $obj, $packed_obj) = @_;

    }

This callback is the complement of C<pack_revision> and allows you to restore
values that are within C<$packed_obj>.

=head2 <package>::save_revision_filter

    sub save_revision_filter {
        my ($cb, $obj) = @_;
    }

Similar to the C<cms_save_filter> callbacks, this filter will allow you to
prevent the saving of a particular revision.

=head2 <package>::pre_save_revision

    sub pre_save_revision {
        my ($cb, $obj) = @_;

    }

This callback is called just before the revision is saved.

=head2 <package>::post_save_revision

    sub post_save_revision {
        my ($cb, $obj, $rev_number) = @_;

    }

This callback is called immediately after a revision is saved.

=head2 <package>::gather_changed_cols

    sub post_save_revision {
        my ($cb, $obj, $rev_number) = @_;

    }

This callback is called when MT gathered changed columns from
object columns.  Plugins can use the callback to add more column
such as the ones added by plugins themselves that may not be
detected by the default handler.

=head1 DRIVERS

The majority of the methods MT::Revisable provides are implemented by driver
modules. These driver modules specify how versions of an object are saved and
retrieved from a data store. By default, MT::Revisable uses the
MT::Revisable::Local driver which saves versions within the Movable Type database.
To change this, you would first need to create a driver that implements the
following methods:

=over

=item * revision_pkg

=item * revision_props

=item * init_revisioning

=item * save_revision

=item * load_revision

=back

If some of the above methods are not applicable to your driver, simply return undef.
