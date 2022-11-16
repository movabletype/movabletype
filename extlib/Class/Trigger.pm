package Class::Trigger;
use 5.008_001;
use strict;
use vars qw($VERSION);
$VERSION = "0.15";

use Carp ();

my (%Triggers, %TriggerPoints);
my %Fetch_All_Triggers_Cache;

sub import {
    my $class = shift;
    my $pkg = caller(0);

    $TriggerPoints{$pkg} = { map { $_ => 1 } @_ } if @_;

    # export mixin methods
    no strict 'refs';
    my @methods = qw(add_trigger call_trigger last_trigger_results);
    *{"$pkg\::$_"} = \&{$_} for @methods;
}

sub add_trigger {
    my $proto = shift;

    my $triggers = __fetch_triggers($proto);

    my %params = @_;
    my @values = values %params;
    if (@_ > 2 && (grep { ref && ref eq 'CODE' } @values) == @values) {
        Carp::croak "mutiple trigger registration in one add_trigger() call is deprecated.";
    }

    if ($#_ == 1 && ref($_[1]) eq 'CODE') {
        @_ = (name => $_[0], callback => $_[1]);
    }

    my %args = ( name => undef, callback => undef, abortable => undef, @_ );
    my $when = $args{'name'};
    my $code = $args{'callback'};
    my $abortable = $args{'abortable'};
    __validate_triggerpoint( $proto, $when );
    Carp::croak('add_trigger() needs coderef') unless ref($code) eq 'CODE';
    push @{ $triggers->{$when} }, [ $code, $abortable ];

    # Clear the cache when class triggers are added.  Because triggers are 
    # inherited adding a trigger to one class may effect others.  Simplest
    # thing to do is to clear the whole thing.
    %Fetch_All_Triggers_Cache = () unless ref $proto;

    1;
}


sub last_trigger_results {
    my $self = shift;
    my $result_store = ref($self) ? $self : ${Class::Trigger::_trigger_results}->{$self};
    return $result_store->{'_class_trigger_results'};
}

sub call_trigger {
    my $self = shift;
    my $when = shift;

    my @return;

    my $result_store = ref($self) ? $self : ${Class::Trigger::_trigger_results}->{$self};

    $result_store->{'_class_trigger_results'} = [];

    if (my @triggers = __fetch_all_triggers($self, $when)) { # any triggers?
        for my $trigger (@triggers) {
            my @return = $trigger->[0]->($self, @_);
            push @{$result_store->{'_class_trigger_results'}}, \@return;
            return undef if ($trigger->[1] and not $return[0]); # only abort on false values.
        }
    }
    else {
        # if validation is enabled we can only add valid trigger points
        # so we only need to check in call_trigger() if there's no
        # trigger with the requested name.
        __validate_triggerpoint($self, $when);
    }

    return scalar @{$result_store->{'_class_trigger_results'}};
}

sub __fetch_all_triggers {
    my ($obj, $when, $list, $order, $nocache) = @_;
    $nocache = 0 unless defined $nocache;
    my $class = ref $obj || $obj;
    my $return;
    my $when_key = defined $when ? $when : '';
    
    unless ($nocache) {
        return __cached_triggers($obj, $when)
            if $Fetch_All_Triggers_Cache{$class}{$when_key};
    }
    
    unless ($list) {
        # Absence of the $list parameter conditions the creation of
        # the unrolled list of triggers. These keep track of the unique
        # set of triggers being collected for each class and the order
        # in which to return them (based on hierarchy; base class
        # triggers are returned ahead of descendant class triggers).
        $list = {};
        $order = [];
        $return = 1;
    }
    no strict 'refs';
    my @classes = @{$class . '::ISA'};
    push @classes, $class;
    foreach my $c (@classes) {
        next if $list->{$c};
#        if (UNIVERSAL::can($c, 'call_trigger')) {
        if ($c->can('call_trigger')) {
            $list->{$c} = [];
            __fetch_all_triggers($c, $when, $list, $order, 1)
                unless $c eq $class;
            if (defined $when && $Triggers{$c}{$when}) {
                push @$order, $c;
                $list->{$c} = $Triggers{$c}{$when};
            }
        }
    }
    if ($return) {
        my @triggers;
        foreach my $class (@$order) {
            push @triggers, @{ $list->{$class} };
        }

        # Only cache the class triggers, object triggers would
        # necessitate a much larger cache and they're cheap to
        # get anyway.
        $Fetch_All_Triggers_Cache{$class}{$when_key} = \@triggers;

        return __cached_triggers($obj, $when);
    }
}


sub __cached_triggers {
    my($proto, $when) = @_;
    my $class = ref $proto || $proto;
    
    return @{ $Fetch_All_Triggers_Cache{$class}{$when || ''} },
           @{ __object_triggers($proto, $when) };
}


sub __object_triggers {
    my($obj, $when) = @_;
    
    return [] unless ref $obj && defined $when;
    return $obj->{__triggers}{$when} || [];
}


sub __validate_triggerpoint {
    return unless my $points = $TriggerPoints{ref $_[0] || $_[0]};
    my ($self, $when) = @_;
    Carp::croak("$when is not valid triggerpoint for ".(ref($self) ? ref($self) : $self))
        unless $points->{$when};
}

sub __fetch_triggers {
    my ($obj, $proto) = @_;
    # check object based triggers first
    return ref $obj ? $obj->{__triggers} ||= {} : $Triggers{$obj} ||= {};
}

1;
__END__

=head1 NAME

Class::Trigger - Mixin to add / call inheritable triggers

=head1 SYNOPSIS

  package Foo;
  use Class::Trigger;

  sub foo {
      my $self = shift;
      $self->call_trigger('before_foo');
      # some code ...
      $self->call_trigger('middle_of_foo');
      # some code ...
      $self->call_trigger('after_foo');
  }

  package main;
  Foo->add_trigger(before_foo => \&sub1);
  Foo->add_trigger(after_foo => \&sub2);

  my $foo = Foo->new;
  $foo->foo;            # then sub1, sub2 called

  # triggers are inheritable
  package Bar;
  use base qw(Foo);

  Bar->add_trigger(before_foo => \&sub);

  # triggers can be object based
  $foo->add_trigger(after_foo => \&sub3);
  $foo->foo;            # sub3 would appply only to this object

=head1 DESCRIPTION

Class::Trigger is a mixin class to add / call triggers (or hooks)
that get called at some points you specify.

=head1 METHODS

By using this module, your class is capable of following methods.

=over 4

=item add_trigger

  Foo->add_trigger($triggerpoint => $sub);
  $foo->add_trigger($triggerpoint => $sub);


  Foo->add_trigger( name => $triggerpoint,
                    callback => sub {return undef},
                    abortable => 1); 

  # no further triggers will be called. Undef will be returned.


Adds triggers for trigger point. You can have any number of triggers
for each point. Each coderef will be passed a reference to the calling object, 
as well as arguments passed in via L<call_trigger>. Return values will be
captured in I<list context>.

If add_trigger is called with named parameters and the C<abortable>
parameter is passed a true value, a false return value from trigger
code will stop processing of this trigger point and return a C<false>
value to the calling code.

If C<add_trigger> is called without the C<abortable> flag, return
values will be captured by call_trigger, but failures will be ignored.

If C<add_trigger> is called as object method, whole current trigger
table will be copied onto the object and the new trigger added to
that. (The object must be implemented as hash.)

  my $foo = Foo->new;

  # this trigger ($sub_foo) would apply only to $foo object
  $foo->add_trigger($triggerpoint => $sub_foo);
  $foo->foo;

  # And not to another $bar object
  my $bar = Foo->new;
  $bar->foo;

=item call_trigger

  $foo->call_trigger($triggerpoint, @args);

Calls triggers for trigger point, which were added via C<add_trigger>
method. Each triggers will be passed a copy of the object as the first argument.
Remaining arguments passed to C<call_trigger> will be passed on to each trigger.
Triggers are invoked in the same order they were defined.

If there are no C<abortable> triggers or no C<abortable> trigger point returns 
a false value, C<call_trigger> will return the number of triggers processed.


If an C<abortable> trigger returns a false value, call trigger will stop execution
of the trigger point and return undef.

=item last_trigger_results

    my @results = @{ $foo->last_trigger_results };

Returns a reference to an array of the return values of all triggers called
for the last trigger point. Results are ordered in the same order the triggers
were run.


=back

=head1 TRIGGER POINTS

By default you can make any number of trigger points, but if you want
to declare names of trigger points explicitly, you can do it via
C<import>.

  package Foo;
  use Class::Trigger qw(foo bar baz);

  package main;
  Foo->add_trigger(foo  => \&sub1); # okay
  Foo->add_trigger(hoge => \&sub2); # exception

=head1 FAQ

B<Acknowledgement:> Thanks to everyone at POOP mailing-list
(http://poop.sourceforge.net/).

=over 4

=item Q.

This module lets me add subs to be run before/after a specific
subroutine is run.  Yes?

=item A.

You put various call_trigger() method in your class.  Then your class
users can call add_trigger() method to add subs to be run in points
just you specify (exactly where you put call_trigger()).

=item Q.

Are you aware of the perl-aspects project and the Aspect module?  Very
similar to Class::Trigger by the look of it, but its not nearly as
explicit.  Its not necessary for foo() to actually say "triggers go
*here*", you just add them.

=item A.

Yep ;)

But the difference with Aspect would be that Class::Trigger is so
simple that it's easy to learn, and doesn't require 5.6 or over.

=item Q.

How does this compare to Sub::Versive, or Hook::LexWrap?

=item A.

Very similar. But the difference with Class::Trigger would be the
explicitness of trigger points.

In addition, you can put hooks in any point, rather than pre or post
of a method.

=item Q.

It looks interesting, but I just can't think of a practical example of
its use...

=item A.

(by Tony Bowden)

I originally added code like this to Class::DBI to cope with one
particular case: auto-upkeep of full-text search indices.

So I added functionality in Class::DBI to be able to trigger an
arbitary subroutine every time something happened - then it was a
simple matter of setting up triggers on INSERT and UPDATE to reindex
that row, and on DELETE to remove that index row.

See L<Class::DBI::mysql::FullTextSearch> and its source code to see it
in action.

=back

=head1 AUTHORS

Original idea by Tony Bowden E<lt>tony@kasei.comE<gt> in Class::DBI.

Code by Tatsuhiko Miyagawa E<lt>miyagawa@bulknews.netE<gt>.

Jesse Vincent added a code to get return values from triggers and
abortable flag.

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Class::DBI>

=cut

