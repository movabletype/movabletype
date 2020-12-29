# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Summary;

use strict;
use warnings;

use base qw( MT::Meta );

use constant FRESH            => 0;
use constant NEEDS_JOB        => 1;
use constant IN_QUEUE         => 2;
use constant NO_AUTO_GENERATE => 3;
use constant INLINE           => 4;

my $_REGENERATORS = {
    inline           => INLINE(),
    needs_job        => NEEDS_JOB(),
    queue            => IN_QUEUE(),
    no_auto_generate => NO_AUTO_GENERATE()
};

our ($Registry);

sub DEBUG () {0}

sub metadata_by_name {
    my $class = shift;
    my ( $pkg, $name ) = @_;
    $Registry->{ $pkg->meta_args->{key} }{$pkg}{$name};
}

{ no warnings; *metadata_by_id = \&metadata_by_name; }

sub register {
    my $class = shift;
    my ( $pkg, $key, $fields ) = @_;

    foreach my $field ( @{$fields} ) {
        my $name = $field->{name};
        my $type = $field->{type};

        my $type_id = $MT::Meta::TypesByName{$type}
            or Carp::croak(
            "Invalid summary type '$type' for field $pkg $field->{name}");

        ## load registry
        print STDERR "$pkg is registering summary $key\t$name\n" if DEBUG;

        ## clone it
        my $value = {
            name    => $name,
            type_id => $type_id,
            type    => $MT::Meta::Types{$type_id},
            pkg     => $pkg,
        };

        $Registry->{$key}{$pkg}{$name} = $value;
    }
}

# default trigger for expiration handler to use in config.yaml that doesn't do anything
sub expire_none { }

# default trigger for expiration handler to use in config.yaml that expires a summary
sub expire_all {
    my ( $parent_obj, $obj, $terms, $action, $orig ) = @_;

    # action: save/remove
    # parent_obj => author, obj => the comment

    return unless ( $parent_obj and $parent_obj->id );
    $parent_obj->expire_summary($terms);
}

=head1 NAME

MT::Summary - Manage summary data (calculated, denormalized metadata) associated with an MT::Object

=head1 DESCRIPTION

The I<MT::Summary> class manages the configuration of summary data. Summary data is similar to 
metadata, and I<MT::Summary> is descended from I<MT::Meta>. You should normally not need to access 
I<MT::Meta> directly, but will use the interface provided by I<MT::Summarizable>.

=cut

package MT::Summarizable;

sub install_properties {
    my $pkg = shift;
    my ($class) = @_;

    $class->add_trigger( post_remove => \&post_remove );
}

sub post_remove {
    my $obj      = shift;
    my $mpkg     = $obj->meta_pkg('summary') or return;
    my $id_field = $obj->datasource . '_id';
    return $mpkg->remove( { $id_field => $obj->id } );
}

sub get_summary {
    my $obj   = shift;
    my $terms = _set_terms(shift);

    if ( $obj->has_summary ) {
        return $obj->summarize( $terms->{type} );
    }
    else {
        die ref($obj) . " has no summary enabled for it\n";
    }
}

sub lookup_summary_objs {
    my $obj = shift;
    my ( $terms, $class ) = @_;
    my $summary = $obj->get_summary($terms);

 #
 # The lookup_summary_objs() sub routine has code that is very similar to the
 # get_summary_objs() code, and although it is not called by the MTEntryAssets
 # tag handler code, we believe that the fix should also be applied to here to
 # prevent potential future database errors in MTE installations using an
 # Oracle database.
 #
    return undef
        unless ( ref $summary eq 'ARRAY' ? $summary->[0] : $summary );
    eval("require $class;");
    my $objs = $class->lookup_multi(
        ref $summary eq 'ARRAY'
        ? $summary
        : [ split /,\s*/, $summary || '' ]
    );
    return @$objs;
}

sub get_summary_objs {
    my $obj = shift;
    my ( $terms, $class, $args ) = @_;
    my $summary = $obj->get_summary($terms);

  #
  # The get_summary_objs() sub in lib/MT/Summary.pm needs to check that it has
  # a non-empty list of asset IDs before calling MT::Asset->load(), and simply
  # return if the list of asset IDs is empty.
  #
    return undef
        unless ( ref $summary eq 'ARRAY' ? $summary->[0] : $summary );
    eval("require $class;");
    return $class->load(
        {   id => ref $summary eq 'ARRAY'
            ? $summary
            : [ split /,\s*/, $summary || '' ]
        },
        ref $args ? $args : ()
    );
}

sub get_summary_iter {
    my $obj = shift;
    my ( $terms, $class, $args ) = @_;
    my $summary = $obj->get_summary($terms);

 #
 # The get_summary_iter() sub routine has code that is very similar to the
 # get_summary_objs() code, and although it is not called by the MTEntryAssets
 # tag handler code, we believe that the fix should also be applied to here to
 # prevent potential future database errors in MTE installations using an
 # Oracle database.
 #
    return undef
        unless ( ref $summary eq 'ARRAY' ? $summary->[0] : $summary );
    eval("require $class;");
    return $class->load_iter(
        {   id => ref $summary eq 'ARRAY'
            ? $summary
            : [ split /,\s*/, $summary || '' ]
        },
        ref $args ? $args : ()
    );
}

sub _set_terms {
    my $terms = shift;

    if ( !ref $terms ) {
        my $str = $terms;
        return unless ( defined $str );
        $terms = {};
        if ( $str =~ /::/ ) {
            $terms->{type} = $str;
            ( $terms->{class} ) = split( /::/, $str );
        }
        else {
            $terms = {
                type  => $str,
                class => $str
            };
        }
    }
    elsif ( $terms->{type} && $terms->{class} ) {
        $terms->{type} = join( '::', $terms->{class}, $terms->{type} )
            if $terms->{type} ne $terms->{class} && $terms->{type} !~ /::/;
    }
    elsif ( $terms->{type} && !$terms->{class} ) {
        $terms->{class} = $terms->{type};
    }
    elsif ( $terms->{class} && !$terms->{type} ) {
        $terms->{type} = $terms->{class};
    }
    elsif ( !$terms->{class} && !$terms->{type} ) {
        die
            "Cannot process terms without class or type parameter: @{[%$terms]}\n";
    }
    return $terms;
}

sub set_summary {
    my $obj = shift;
    my ( $terms, $value, $reset ) = @_;
    return 0 unless $obj;

    die "Cannot call set_summary on an object with no id (" . ref($obj) . ")"
        unless $obj->id;

    die "Cannot call set_summary with no value (" . ref($obj) . ")"
        unless ( defined $value and !$reset );

    $terms = _set_terms($terms);
    if ( $obj->has_summary ) {
        if ( $obj->is_summary( $terms->{class} ) ) {
            $obj->summary( $terms, $value );
        }
        else {
            die ref($obj)
                . " has not registered field $terms->{class} to be summarizable\n";
        }
    }
    else {
        die ref($obj) . " has no summary enabled for it\n";
    }

    return 1;
}

sub summarize {
    my $obj = shift;
    return 0 unless $obj;
    my $terms  = _set_terms(shift);
    my %params = @_;
    die "Cannot call set_summary without terms" unless $terms;
    die "Cannot call set_summary on an object with no id (" . ref($obj) . ")"
        unless $obj->id;
    die ref($obj) . " has no summary enabled for it\n"
        unless $obj->has_summary;
    die ref($obj)
        . " has not registered field $terms->{class} to be summarizable\n"
        unless $obj->is_summary( $terms->{class} );

    my $type_id = $obj->class_type;
    my $class_type
        = $type_id
        ? (
          $type_id ne $obj->datasource
        ? $obj->datasource . '.' . $type_id
        : $type_id
        )
        : $obj->datasource;
    my $registry = MT->registry( summaries => $class_type );
    my $regen
        = $params{code}
        || $registry->{ $terms->{class} }->{code}
        || die
        "Required code to summarize $terms->{class} is missing in registry for class $class_type/@{[$terms->{class}]}\n";
    $regen = MT->handler_to_coderef($regen) unless ref $regen;

    if ( ref $regen ne q{CODE} ) {
        die
            "Required code to summarize $terms->{class} is not code or code handler\n";
    }
    my $value = $obj->summary($terms);
    if (   ( defined $params{force} && $params{force} )
        || $obj->summary_is_expired($terms)
        || !defined $value )
    {
        $value = $regen->( $obj, $terms );
        $obj->set_summary( $terms, $value );
    }
    return $value;
}

sub summary_is_expired {
    my $obj = shift;
    return 0 unless $obj;
    my $terms = _set_terms(shift);

    # force load of this summary if not already loaded
    $obj->summary( $terms->{type} );
    my $summary = $obj->{__summary}->{__objects}->{ $terms->{type} };
    return $summary ? $summary->expired : 0;
}

sub expire_all {
    my $obj = shift;
    return 0 unless $obj;
    foreach my $summary_key ( keys %{ $obj->{__summary}->{__objects} } ) {
        $obj->expire_summary($summary_key);
    }
}

sub insert_summarize_worker {
    my $class = shift;
    my ( $class_type, $id, $type, $priority ) = @_;
    return if ( !$class_type or !$id or !$type );
    require MT::TheSchwartz;
    require TheSchwartz::Job;
    my $job = TheSchwartz::Job->new();
    $job->funcname('MT::Worker::Summarize');
    $job->uniqkey( join( ':::', ( $class_type, $id, $type ) ) );
    $priority ||= MT->config('SummarizeWorkerPriority');
    $priority ||= 5;
    $job->priority($priority);
    MT::TheSchwartz->insert($job) or return;
    return 1;
}

sub expire_summary {
    my $obj = shift;
    return 0 unless $obj;
    my $terms = defined $_[0] ? _set_terms(shift) : undef;
    return 0 unless $terms;
    my $additional_args = $_[0];
    if ( ( !defined($terms) ) and defined($additional_args) ) {
        die
            "Summary expiration cannot override default behavior without terms\n";
    }
    my $regenerate = $additional_args->{regenerate};
    my $priority   = $additional_args->{priority};
    if ( defined($terms) ) {
        my $type_id = $obj->class_type;
        my $class_type
            = $type_id
            ? (
              $type_id ne $obj->datasource
            ? $obj->datasource . '.' . $type_id
            : $type_id
            )
            : $obj->datasource;
        my $r = MT->registry( q{summaries}, $class_type );
        $r = $r->{ $terms->{class} };
        my $type_key   = $obj->datasource . q{_id};
        my $meta_class = $obj->meta_pkg('summary');
        my $params     = {
            $type_key => $obj->id,
            type      => $terms->{type},
        };
        my $new = 1;
        my ($summary)
            = $meta_class->search($params);    # find an existing iterator
        {

            if ( $r->{regenerate} ) {
                $regenerate ||= $_REGENERATORS->{ $r->{regenerate} };
            }
            $regenerate ||= $_REGENERATORS->{q{needs_job}};
            if ( $regenerate eq MT::Summary::INLINE() ) {
                $obj->summarize( $terms, force => 1 );
            }
            else {
                if ($summary) {
                    $obj->summary( $terms->{type} );
                    $obj->{__summary}->{__objects}->{ $terms->{type} }
                        ->expired($regenerate);
                    $obj->{__summary}->save_one($terms);
                }
                if ( $regenerate == MT::Summary::IN_QUEUE() ) {
                    $priority ||= $r->{priority};
                    $obj->insert_summarize_worker( $class_type, $obj->id,
                        $terms->{type}, $priority );
                }
            }
        }
    }
    else {
        foreach my $summary_key ( keys %{ $obj->{__summary}->{__objects} } ) {
            $obj->expire_summary($summary_key);
        }
    }
    return 1;
}

=head1 NAME

MT::Summarizable - interface for I<MT::Object> subclasses that support summary
objects.

=head1 SYNOPSIS

    package Foo;
    use base qw( MT::Object MT::Summarizable );
    __PACKAGE__->install_properties({
        ...
        summary => 1
        ...
    });
    
    package main;
    
    my $foo = Foo->new;
    my $bar_value = $foo->get_summary('bar');
    my @related_foos = $foo->lookup_summary_objs('related');
    my $baz_iter = $foo->get_summary_iter({
        class => 'baz_per_blog',
        type => $foo->blog_id
    });

=head1 DESCRIPTION

Summary data objects are a special type of metadata that can be stored for an 
object belonging to a subclass of I<MT::Object>: values that are calculated 
based on other objects in the system, and which must be recalculated (or expired 
for later on-demand recalculation) in response to changes in those objects. For 
example, a count of all the comments belonging to an author, or a list of all 
the entries in a particular blog category. 

Essentially, summaries are a way of denormalizing the database schema by storing 
values that require expensive database queries to calculate, to prevent having 
to perform the same calculations repeatedly. The framework provides for 
trigger-based expiration of summaries, marking them as needing to be 
recalculated.

Summary types are declared in the Registry, and may be declared by any Movable 
Type component--core, addons, or plugins.

I<MT::Summarizable> provides an interface for accessing summary data on an 
object. In order to use summaries, an object class must declare itself a 
subclass of I<MT::Summarizable> as well as of I<MT::Object>, and include 
"summary => 1" in its properties.

=head1 USAGE

=head2 $terms

Most of the methods described below take a I<$terms> argument. This can be 
either a scalar value or a hashref, depending on how the summary in question is 
implemented.

As stored in the database, every summary value for a given object has two 
identifiers: a I<class> and a I<type>. The I<class> is what's declared in the 
Registry.

In the case of a I<simple> summary, where only one summary of a given I<class> 
exists per object (eg. "total comment count" for an MT::Author), I<type> is 
equal to I<class>.

In the case of a I<parameterized> summary, where multiple summaries of a given 
I<class> can exist per object (eg. "comment count per blog" for an MT::Author), 
I<type> is of the form I<[class]::[parameter(s)]> -- I<comments_per_blog::4> 
might contain the author's comment count for blog_id 4.

To access a parameterized summary value, pass a fully specified 
i<[class]::[parameters]> string, either as a scalar or in the I<type> element of 
the I<$terms> hashref; or pass a I<terms> hashref with both a I<type> and a 
I<class> element, and the full type will be constructed if the I<type> does not 
appear to be fully specified. In other words, the following are equivalent:

    $obj->get_summary("comments_per_blog::4");

    $obj->get_summary({ type => "comments_per_blog::4" });

    $obj->get_summary({ class => "comments_per_blog", type => "4" });

    $obj->get_summary({
        class => "comments_per_blog", type => "comments_per_blog::4"
    });

=head2 $obj->get_summary( $terms )

Returns the summary value for I<$obj> of the class and/or type matching 
I<$terms>. If the value has not yet been generated or is expired, it will be 
recalculated inline, stored, and returned.

=head2 $obj->get_summary_objs( $terms, $class, [ $args ] )

Returns a set of objects of object class I<$class>, by retrieving the summary 
value for I<$obj> matching I<$terms> and then treating it as a comma-delimited 
string of object IDs, which are loaded with any additional query parameters 
(sort order or join terms, for example) specified in the optional I<$args>.

=head2 $obj->get_summary_iter( $terms, $class, [ $args ] )

Selects objects based on a summary value as I<get_summary_objs> does, but 
returns an iterator that will loop over the objects.

=head2 $obj->lookup_summary_objs( $terms, $class )

Returns a set of objects of object class I<$class>, by retrieving the summary 
value for I<$obj> matching I<$terms> and then treating it as a comma-delimited 
string of object IDs. If no additional arguments are needed in loading the 
objects, I<lookup_summary_objs> is preferred over I<get_summary_objs> or 
I<get_summary_iter> because it does a I<lookup_multi>, which is optimized for 
caching.

=head2 $obj->set_summary( $terms, $value, $reset )

Sets the summary value for I<$obj> matching I<$terms> to I<$value>. If the 
passed value is I<undef>, the I<$reset> flag must also be passed to indicate 
that this is intentional.

Note that I<set_summary> immediately saves the summary value to the database; 
unlike with MT's metadata, it is not necessary to save the parent object in 
order to save summary values.

=head2 $obj->summary_is_expired( $terms )

Returns true if the summary for I<$obj> matching I<$terms> is expired and needs 
to be recalculated.

=head2 $obj->expire_summary( $terms, [ $options ] )

Marks the summary for I<$obj> matching I<$terms> as expired, and processes it 
for recalculation according to the regenerate option specified in its Registry 
definition, which can be overridden with the 'regenerate' option described 
below.

The optional I<$options> is a hashref that can include two elements:

=over 4

=item * regenerate: an integer specifying how the summary should be regenerated, 
which may be one of the following constants:

=over 4

=item * MT::Summary::INLINE(): the summary will be recalculated and stored 
immediately upon expiration.

=item * MT::Summary::NEEDS_JOB(): the summary will be marked as needing to be 
regenerated by a TheSchwartz job, so that a job to regenerate it will be 
inserted by an MT::Worker::SummaryWatcher custodian worker.

=item * MT::Summary::IN_QUEUE(): an MT::Worker::Summarize worker will be 
inserted into the job queue to regenerate the summary.

=item * MT::Summary::NO_AUTO_GENERATE(): the summary will not be automatically 
regenerated until the next time it's called for (i.e. by a template tag handler).

=back

=item * priority: for IN_QUEUE regeneration, an integer specifying the priority 
for the queued job, which will override the default priority specified in the 
Registry for this summary type.

=back

=head2 $obj->expire_all

Marks all summaries for I<$obj> as expired, and processes each one for 
regeneration according to the 'regenerate' option for that summary type in the 
Registry.

=cut

1;
