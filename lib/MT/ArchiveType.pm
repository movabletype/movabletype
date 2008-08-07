# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::ArchiveType;

use strict;
use MT::WeblogPublisher;

sub new {
    my $pkg  = shift;
    my $self = {@_};
    bless $self, $pkg;
}

sub _getset {
    my $self = shift;
    my $name = shift;
    @_ ? $self->{$name} = $_[0] : $self->{$name};
}

sub _getset_coderef {
    my ($obj, $key, @param) = @_;
    # We only do this weird thing for MT::ArchiveType, which for MT 4
    # allowed assignment of a coderef to the base MT::ArchiveType class.
    # With MT 4.2 and later, this routine should be overridden by a
    # subclass, and therefore, shouldn't do anything by itself.
    if (ref($obj) eq __PACKAGE__) {
        if (@param && ref($param[0]) eq 'CODE') {
            $obj->_getset( $key, @param );
            return;
        }
        if (my $code = $obj->_getset($key)) {
            return $code->(@param);
        }
    }
    return;
}

sub name { shift->_getset( 'name', @_ ) }

# The base class routine should handle coderef assignment
# calling date_range with other parameters invokes this routine
# and returns the result
sub archive_group_iter {
    shift->_getset_coderef( 'archive_group_iter', @_ );
}
sub archive_group_entries {
    shift->_getset_coderef( 'archive_group_entries', @_ );
}
sub archive_file {
    shift->_getset_coderef( 'archive_file', @_ );
}
sub archive_title {
    shift->_getset_coderef( 'archive_title', @_ );
}
sub archive_label {
    shift->_getset_coderef( 'archive_label', @_ );
}

sub group_based {
    my $obj = shift;
    if (ref($obj) eq __PACKAGE__) {
        return $obj->_getset( 'archive_group_entries' ) ? 1 : 0;
    }
    return 0;
}

sub default_archive_templates {
    shift->_getset( 'default_archive_templates', @_ );
}
sub dynamic_template { shift->_getset( 'dynamic_template', @_ ) }
sub entry_class      { shift->_getset( 'entry_class',      @_ ) || 'entry' }
sub category_class   { shift->_getset( 'category_class',   @_ ) || 'category' }
sub template_params  { shift->_getset('template_params') }

sub dynamic_support  {
    my $obj = shift;
    if (ref $obj ne __PACKAGE__) {
        return 1; # assume support unless overridden
    }
    $obj->_getset( 'dynamic_support',  @_ );
}

sub category_based {
    my $obj = shift;
    if (ref $obj ne __PACKAGE__) {
        return $obj->isa('MT::ArchiveType::Category');
    }
    return $obj->_getset('category_based', @_);
}

sub entry_based {
    my $obj = shift;
    if (ref $obj ne __PACKAGE__) {
        return $obj->isa('MT::ArchiveType::Individual');
    }
    return $obj->_getset('entry_based', @_);
}

sub date_based {
    my $obj = shift;
    if (ref $obj ne __PACKAGE__) {
        return $obj->isa('MT::ArchiveType::Date');
    }
    return $obj->_getset('date_based', @_);
}

sub author_based {
    my $obj = shift;
    if (ref $obj ne __PACKAGE__) {
        return $obj->isa('MT::ArchiveType::Author');
    }
    return $obj->_getset('author_based', @_);
}

sub archive_entries_count {
    my $self = shift;

    return $self->_getset_coderef( 'archive_entries_count', @_ )
        if ref($self) eq __PACKAGE__;

    my ($params) = @_;
    my $blog     = $params->{Blog};
    my $at       = $params->{ArchiveType};
    my $ts       = $params->{Timestamp};
    my $cat      = $params->{Category};
    my $auth     = $params->{Author};
    my ( $start, $end );
    if ($ts) {
        my $archiver = MT->publisher->archiver($at);
        ( $start, $end ) = $archiver->date_range($ts) if $archiver;
    }

    my $count = MT->model('entry')->count(
        {
            blog_id => $blog->id,
            status  => MT::Entry::RELEASE(),
            ( $ts ? ( authored_on => [ $start, $end ] ) : () ),
            ( $auth ? ( author_id => $auth->id ) : () ),
        },
        {
            ( $ts ? ( range_incl => { authored_on => 1 } ) : () ),
            (
                $cat
                ? (
                    'join' => [
                        'MT::Placement', 'entry_id',
                        { category_id => $cat->id }
                    ]
                  )
                : ()
            ),
        }
    );
    return $count;
}

# For user-defined date-based archive types
sub date_range {
    shift->_getset_coderef( 'date_range', @_ );
}
sub next_archive_entry {
    shift->_getset_coderef( 'next_archive_entry', @_ );
}
sub previous_archive_entry {
    shift->_getset_coderef( 'previous_archive_entry', @_ );
}

1;
