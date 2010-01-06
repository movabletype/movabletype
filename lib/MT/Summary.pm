# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
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
sub expire_none {}

# default trigger for expiration handler to use in config.yaml that expires a summary
sub expire_all {
    my ( $parent_obj, $obj, $terms, $action, $orig ) = @_;

    # action: save/remove
    # parent_obj => author, obj => the comment

    return unless ( $parent_obj and $parent_obj->id );
    $parent_obj->expire_summary($terms);
}

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
    eval("require $class;");
    my $objs = $class->lookup_multi(ref $summary eq 'ARRAY' ? $summary : [split /,\s*/, $summary || '']);
    return @$objs;
}

sub get_summary_objs {
    my $obj = shift;
    my ( $terms, $class, $args ) = @_;
    my $summary = $obj->get_summary($terms);
    eval("require $class;");
    return $class->load( { id => ref $summary eq 'ARRAY' ? $summary : [split /,\s*/, $summary || ''] }, ref $args ? $args : () );
}

sub get_summary_iter {
    my $obj = shift;
    my ( $terms, $class, $args ) = @_;
    my $summary = $obj->get_summary($terms);
    eval("require $class;");
    return $class->load_iter( { id => ref $summary eq 'ARRAY' ? $summary : [split /,\s*/, $summary || ''] }, ref $args ? $args : () );
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
            "Can't process terms without class or type parameter: @{[%$terms]}\n";
    }
    return $terms;
}

sub set_summary {
    my $obj = shift;
    my ( $terms, $value, $reset ) = @_;
    return 0 unless $obj;

    die "Can't call set_summary on an object with no id (" . ref($obj) . ")"
        unless $obj->id;

    die "Can't call set_summary with no value (" . ref($obj) . ")"
        unless (defined $value and ! $reset );

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
    my $terms = _set_terms(shift);
    my %params = @_;
    die "Can't call set_summary without terms" unless $terms;
    die "Can't call set_summary on an object with no id (" . ref($obj) . ")"
        unless $obj->id;
    die ref($obj) . " has no summary enabled for it\n"
        unless $obj->has_summary;
    die ref($obj)
        . " has not registered field $terms->{class} to be summarizable\n"
        unless $obj->is_summary( $terms->{class} );

    my $type_id = $obj->class_type;
    my $class_type = $type_id ? ($type_id ne $obj->datasource ? $obj->datasource . '.' . $type_id : $type_id) : $obj->datasource;
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
    if ( (defined $params{force} && $params{force}) 
       || $obj->summary_is_expired($terms) 
       || !defined $value ) {
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
    my $summary = $obj->{__summary}->{__objects}->{$terms->{type}};
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
        my $class_type = $type_id ? ($type_id ne $obj->datasource ? $obj->datasource . '.' . $type_id : $type_id) : $obj->datasource;
        my $r = MT->registry( q{summaries}, $class_type );
        $r = $r->{ $terms->{class} };
        my $type_key = $obj->datasource . q{_id};
        my $meta_class   = $obj->meta_pkg('summary');
        my $params = {   
           $type_key => $obj->id,
           type      => $terms->{type},
        };
        my $new = 1;
        my($summary) = $meta_class->search($params); # find an existing iterator
        {
            if ( $r->{regenerate} ) {
                $regenerate ||= $_REGENERATORS->{ $r->{regenerate} };
            }
            $regenerate ||= $_REGENERATORS->{q{needs_job}};
            if ( $regenerate eq MT::Summary::INLINE() ) {
                $obj->summarize($terms, force => 1);
            }
            else {
                if ($summary) {
                	$obj->summary($terms->{type});
					$obj->{__summary}->{__objects}->{$terms->{type}}->expired($regenerate);
					$obj->{__summary}->save_one($terms);
                }
                if ( $regenerate == MT::Summary::IN_QUEUE() ) {
                    $priority ||= $r->{priority};
                    $obj->insert_summarize_worker(
                        $class_type, $obj->id,
                        $terms->{type},   $priority
                    );
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

1;
