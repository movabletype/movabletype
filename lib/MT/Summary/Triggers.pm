# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Summary::Triggers;
use strict;
use warnings;

{
    my $triggers_added;

    sub post_init_add_triggers {
        return if $triggers_added;

        # post_save triggers for summary expiration
        my $summaries = MT->registry('summaries');
        my %class_triggers;
        for my $class_type ( keys %$summaries ) {
            next if ( $class_type eq 'plugin' );
            for my $summary_class ( keys %{ $summaries->{$class_type} } ) {
                next if ( $summary_class eq 'plugin' );
                my $expires
                    = $summaries->{$class_type}->{$summary_class}->{expires};
                next unless $expires;
                for my $class ( keys %$expires ) {

             # check for required code handler for expiration code
             # it's going to be used in triggers, but we check it here because
             # errors in triggers are handled (swallowed) by MT code
                    my $code   = $expires->{$class}->{code};
                    my $id_col = $expires->{$class}->{id_column};
                    $code = MT->handler_to_coderef($code)
                        if ( $code && !ref($code) );
                    die
                        "Missing required handler for '$class_type: $summary_class: expires: $class' element with $id_col\n"
                        unless ref $code;

                    $class_triggers{$class} ||= [];
                    push(
                        @{ $class_triggers{$class} },
                        {   summary_class => $summary_class,
                            class_type    => $class_type,
                            expires       => $expires->{$class},
                        }
                    );
                }
            }
        }
        for my $class ( keys %class_triggers ) {

# load the class if it hasn't been loaded already
# ignore errors as the class may be already loaded as part of some other class (and not available as a standalone module)
# if load is not successful it's going to fail on add_trigger call anyway
            eval "require $class";
            $class->add_trigger(
                pre_save => sub {
                    &pre_save_trigger( $class_triggers{$class}, @_ );
                }
            );
            $class->add_trigger(
                post_save => sub {
                    &post_trigger( 'save', $class_triggers{$class}, @_ );
                }
            );
            $class->add_trigger(
                post_remove => sub {
                    &post_trigger( 'remove', $class_triggers{$class}, @_ );
                }
            );
            $class->add_callback(
                'pre_remove_multi',
                0,
                MT->component('core'),
                sub {
                    my ( $cb, @args ) = @_;
                    for my $obj ( $class->load(@args) ) {
                        post_trigger( 'remove', $class_triggers{$class}, $obj,
                            $obj );
                    }
                }
            );
        }
        $triggers_added = 1;
    }
}

sub pre_save_trigger {
    my ( $triggers, $obj ) = @_;
    if ( !$obj->id ) {
        $obj->{__summary_trigger_new} = 1;
    }
}

sub post_trigger {
    my ( $action, $triggers, $obj, $orig_obj ) = @_;
    for my $trigger (@$triggers) {
        next unless $trigger->{expires}->{id_column};
        my $parent_class = MT->model( $trigger->{class_type} );
        die "Cannot find a class for '", $trigger->{class_type}, "'"
            if !defined $parent_class;
        my $code   = $trigger->{expires}->{code};
        my $id_col = $trigger->{expires}->{id_column};
        next unless $obj->$id_col;
        $code = MT->handler_to_coderef($code) if ( $code && !ref($code) );
        die "Missing required handler for expires with ",
            $trigger->{class_type}, " and $id_col"
            unless ref $code;
        my $parent_obj = $parent_class->load( $obj->$id_col );
        next unless $parent_obj;
        eval {
            $code->(
                $parent_obj, $obj, $trigger->{summary_class},
                $action, $orig_obj
            );
        };
    }
    delete $obj->{__summary_trigger_new};
}

1;
