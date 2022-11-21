package XML::SAX::SVGTransformer;

use strict;
use warnings;
use base 'XML::SAX::Base';
use Math::Matrix;
use Math::Trig qw/deg2rad/;

our $VERSION = '0.05';
our $GroupId = 'SVGTransformer';

my $IdMatrix = Math::Matrix->id(4);

sub start_document {
    my $self = shift;
    $self->SUPER::start_document(@_);
    $self->{_stack}   = [];
    $self->{_ops}     = [];
    $self->{_stash}   = {};
    $self->{_comment} = '';
}

sub start_element {
    my $self = shift;
    my $elem = $_[0];
    my $name = lc $elem->{LocalName};
    if ($name eq 'svg' && !$self->_seen($name) && !$self->_stash($name)) {
        $self->_stash(svg    => $elem);
        $self->_stash(prefix => $elem->{Prefix});
        return;
    } elsif ($self->_stash('svg') && !$self->_stash('updated')) {
        my @args;
        if ($name eq 'g' && (_attr($elem, 'id') || '') eq $self->_group_id) {
            push @args, $elem;
        }
        $self->_update_tags(@args);
    }
    $self->_push($name);
    $self->SUPER::start_element(@_);
}

sub comment {
    my ($self, $comment) = @_;
    if ($self->_stash('svg')) {
        my $data  = $comment->{Data};
        my @parts = split /(?:\s+|\s*,\s*)/, $data || '';
        if (@parts == 4 && !grep !/^[-0-9.eE]+$/, @parts) {
            $self->{_comment} = $data;
            return;
        }
    }
    $self->SUPER::comment($comment);
}

sub end_element {
    my $self   = shift;
    my $elem   = $_[0];
    my $name   = lc $elem->{LocalName};
    my $popped = $self->_pop($name);
    while (ref $popped) {
        $self->_end_added_elements($popped);
        $popped = $self->_pop($name);
    }
    $self->SUPER::end_element(@_);
}

sub end_document {
    my $self    = shift;
    my @stacked = @{$self->{_stack}};
    return unless @stacked;
    while (my $popped = pop @stacked) {
        die "Broken! got: $popped left:" . join(",", @stacked) unless ref $popped;
        $self->_end_added_elements($popped);
    }
}

sub _end_added_elements {
    my ($self, $tags) = @_;
    for my $tag (reverse @$tags) {
        my $prefix = $self->_stash('prefix');
        $self->SUPER::end_element({
            LocalName => $tag,
            Name      => $prefix ? "$prefix:$tag" : $tag,
            Prefix    => $prefix,
        });
    }
}

sub info { shift->{_info} || {} }

sub _update_tags {
    my ($self, $group) = @_;

    my $svg = $self->_delete_stash('svg');

    my $svg_width   = _attr($svg, 'width');
    my $svg_height  = _attr($svg, 'height');
    my $svg_viewbox = _attr($svg, 'viewBox');
    my $svg_version = _attr($svg, 'version');

    if (!$svg_viewbox && $svg_width && $svg_height) {
        $svg_viewbox = "0 0 $svg_width $svg_height";
    }

    my $view;
    @$view{qw/min_x min_y max_x max_y tx ty w h/} = (0) x 8;

    $svg_viewbox = $self->{_comment} if $self->{_comment};

    if ($svg_viewbox) {
        @$view{qw/min_x min_y w h/} = _split($svg_viewbox);
        $view->{max_x}              = $view->{min_x} + $view->{w};
        $view->{max_y}              = $view->{min_y} + $view->{h};
    } else {
        $view->{max_x} = $view->{w} = _numify($svg_width);
        $view->{max_y} = $view->{h} = _numify($svg_height);
    }

    my $new_group;
    if (!$group) {
        my $prefix = $svg->{Prefix} ? "$svg->{Prefix}:" : "";
        $group = {
            LocalName    => 'g',
            Name         => $prefix . 'g',
            Prefix       => $svg->{Prefix},
            NamespaceURI => $svg->{NamespaceURI},
            Attributes   => {
                '{}id' => {
                    Name  => 'id',
                    Value => $self->_group_id,
                },
                '{}transform' => {
                    Name  => 'transform',
                    Value => '',
                },
            },
        };
        $new_group = 1;
    }

    my $scale = $self->_scale($view, @$self{qw/Width Height/});
    push @{$self->{_ops}}, ['scale', @$scale];

    my $transform = _attr($group, 'transform');

    $self->_parse_transform($transform);

    my $matrix = $self->_parse_transform($self->{Transform});

    $view = _to_hash($matrix * _to_matrix($view));
    _translate($view);

    push @{$self->{_ops}}, ['translate', @$view{qw/tx ty/}];

    my $width  = $view->{w};
    my $height = $view->{h};

    if ($self->{KeepAspectRatio}) {
        $width  = $self->{Width};
        $height = $self->{Height};
        my @offset = (0, 0);
        if ($width > $view->{w}) {
            $offset[0] = ($width - $view->{w}) / 2;
        }
        if ($height > $view->{h}) {
            $offset[1] = ($height - $view->{h}) / 2;
        }

        if ($offset[0] or $offset[1]) {
            my $wrapper = {
                LocalName    => $svg->{LocalName},
                Name         => $svg->{Name},
                Prefix       => $svg->{Prefix},
                NamespaceURI => $svg->{NamespaceURI},
            };
            my $wrapper_group = {
                LocalName    => $group->{LocalName},
                Name         => $group->{Name},
                Prefix       => $group->{Prefix},
                NamespaceURI => $group->{NamespaceURI},
            };
            _attr($wrapper, 'width',   $width);
            _attr($wrapper, 'height',  $height);
            _attr($wrapper, 'viewBox', "0 0 $width $height");

            _attr($wrapper_group, 'transform', "translate($offset[0] $offset[1])");

            _attr($group, 'id', undef);

            $self->_push(['svg', 'g']);
            $self->SUPER::start_element($wrapper);
            $self->SUPER::start_element($wrapper_group);
        }
    }

    _attr($svg, 'width',   $view->{w});
    _attr($svg, 'height',  $view->{h});
    _attr($svg, 'viewBox', "0 0 $view->{w} $view->{h}");

    $self->_push('svg');
    $self->SUPER::start_element($svg);
    $self->SUPER::comment({Data => $svg_viewbox});

    $transform = $self->_ops_to_transform;
    _attr($group, 'transform', $transform);
    if ($new_group && $transform) {
        $self->_push(['g']);
        $self->SUPER::start_element($group);
    }

    $self->_stash(updated => 1);

    $self->{_info} = {
        width   => $width,
        height  => $height,
        version => $svg_version,
    };
}

sub _parse_transform {
    my ($self, $transform) = @_;

    $transform = '' unless defined $transform;

    my @ops = @{$self->{_ops}};
    if ($transform) {
        my @parts = (lc $transform) =~ /(\w+(?:\([^)]*\))?)/g;
        for my $op (reverse @parts) {
            my ($name, $arg) = $op =~ /^(\w+)(?:\(([^)]*)\))?$/;
            my @args = _split($arg);
            if ($name eq 'rotate') {
                if (@ops && $ops[-1][0] eq 'rotate') {
                    $ops[-1][1] += $args[0];
                    $ops[-1][1] %= 360;
                } else {
                    push @ops, ['rotate', @args];
                }
            } elsif ($name eq 'flipx') {
                my $m = Math::Matrix->diagonal(-1, 1, -1, 1);
                if (@ops && $ops[-1][0] eq 'matrix') {
                    $ops[-1][1] *= $m;
                } else {
                    push @ops, ['matrix', $m];
                }
            } elsif ($name eq 'flipy') {
                my $m = Math::Matrix->diagonal(1, -1, 1, -1);
                if (@ops && $ops[-1][0] eq 'matrix') {
                    $ops[-1][1] *= $m;
                } else {
                    push @ops, ['matrix', $m];
                }
            } elsif ($name eq 'matrix') {
                my $m = Math::Matrix->new([
                    [$args[0], $args[2], 0,        0],
                    [$args[1], $args[3], 0,        0],
                    [0,        0,        $args[0], $args[2]],
                    [0,        0,        $args[1], $args[3]],
                ]);
                if (@ops && $ops[-1] eq 'matrix') {
                    $ops[-1][1] *= $m;
                } else {
                    push @ops, ['matrix', $m];
                }
            }
        }
        $self->{_ops} = \@ops;
    }

    my $matrix = $IdMatrix->clone;
    for my $op (@ops) {
        my ($name, @args) = @$op;
        if ($name eq 'rotate') {
            my $angle = deg2rad($args[0] || 0);
            my $sin   = sin $angle;
            my $cos   = cos $angle;
            my $m     = Math::Matrix->new([
                [$cos, -$sin, 0,    0],
                [$sin, $cos,  0,    0],
                [0,    0,     $cos, -$sin],
                [0,    0,     $sin, $cos],
            ]);
            $matrix *= $m;
            if ($matrix->equal($IdMatrix)) {
                $matrix = $IdMatrix->clone;
            }
        } elsif ($name eq 'matrix') {
            $matrix *= $args[0];
        } elsif ($name eq 'scale') {
            $matrix *= Math::Matrix->new(
                [$args[0], 0,        0,        0],
                [0,        $args[1], 0,        0],
                [0,        0,        $args[0], 0],
                [0,        0,        0,        $args[1]],
            );
        }
    }
    return $matrix;
}

sub _ops_to_transform {
    my $self = shift;
    my @transform;
    for my $op (@{$self->{_ops}}) {
        my ($name, @args) = @$op;
        if ($name eq 'rotate') {
            next if !$args[0];
            push @transform, "rotate($args[0])";
        } elsif ($name eq 'matrix') {
            next if $args[0]->equal($IdMatrix);
            my $flatten = join ' ', _flatten($args[0]);
            push @transform, "matrix($flatten)";
        } elsif ($name eq 'scale') {
            next if $args[0] == 1 && $args[1] == 1;
            push @transform, "scale($args[0] $args[1])";
        } elsif ($name eq 'translate') {
            next if !$args[0] && !$args[1];
            $args[0] ||= 0;
            $args[1] ||= 0;
            push @transform, "translate($args[0] $args[1])";
        }
    }
    join ' ', reverse @transform;
}

sub _numify {
    my $number = shift or return 0;
    $number =~ tr/0-9.eE\-//cd;
    $number += 0;
    $number =~ s/\.0+$//;
    $number || 0;
}

sub _split {
    my $value = shift;
    return unless defined $value;
    map { _numify($_) } split /(?:\s+|\s*,\s*)/, $value;
}

sub _flatten {
    my $matrix = shift;
    my $array  = $matrix->as_array;
    my @values = map { _numify($_) } (
        $array->[0][0],
        $array->[1][0],
        $array->[0][1] - $array->[0][0],
        $array->[1][1] - $array->[1][0],
        $array->[0][2] + $array->[0][3],
        $array->[1][2] + $array->[1][3],
    );
    @values;
}

sub _translate {
    my $set = shift;

    if ($set->{min_x}) {
        $set->{max_x} -= $set->{min_x};
        $set->{tx}    -= $set->{min_x};
        $set->{min_x} = 0;
    }
    if ($set->{min_y}) {
        $set->{max_y} -= $set->{min_y};
        $set->{ty}    -= $set->{min_y};
        $set->{min_y} = 0;
    }
}

sub _to_matrix {
    my $set = shift;
    Math::Matrix->new([
        [@$set{qw/min_x max_x min_x max_x/}],
        [@$set{qw/min_y min_y max_y max_y/}],
        [@$set{qw/tx tx tx tx/}],
        [@$set{qw/ty ty ty ty/}],
    ]);
}

sub _to_hash {
    my $matrix = shift;
    my %hash;
    @hash{qw/min_x min_y max_x max_y tx ty/} = (0, 0, 0, 0, 0, 0);
    my $x  = $matrix->getrow(0);
    my $y  = $matrix->getrow(1);
    my $tx = $matrix->getrow(2);
    my $ty = $matrix->getrow(3);
    $hash{min_x} = $x->min->as_array->[0][0];
    $hash{max_x} = $x->max->as_array->[0][0];
    $hash{min_y} = $y->min->as_array->[0][0];
    $hash{max_y} = $y->max->as_array->[0][0];
    $hash{tx}    = $tx->min->as_array->[0][0];
    $hash{ty}    = $ty->min->as_array->[0][0];
    $hash{w}     = $hash{max_x} - $hash{min_x};
    $hash{h}     = $hash{max_y} - $hash{min_y};
    \%hash;
}

sub _scale {
    my ($self, $set, $x, $y) = @_;

    my ($scale_x, $scale_y) = (1, 1);
    if ($x && $y) {
        if ($set->{w}) {
            $scale_x = $x / $set->{w};
        }
        if ($set->{h}) {
            $scale_y = $y / $set->{h};
        }
        if ($self->{KeepAspectRatio}) {
            if ($scale_x > $scale_y) {
                $scale_x = $scale_y;
            } else {
                $scale_y = $scale_x;
            }
        }
    } elsif ($x) {
        if ($set->{w}) {
            $scale_x = $x / $set->{w};
        }
        $scale_y = $scale_x;
    } elsif ($y) {
        if ($set->{h}) {
            $scale_y = $y / $set->{h};
        }
        $scale_x = $scale_y;
    }
    return [$scale_x, $scale_y];
}

sub _push {
    my ($self, $name) = @_;
    push @{$self->{_stack}}, $name;
}

sub _pop {
    my ($self, $name) = @_;
    my $popped = pop @{$self->{_stack}};
    if (!ref $popped && $name ne $popped) {
        die "Broken! expected: $name got: $popped left:" . join(",", @{$self->{_stack}});
    }
    $popped;
}

sub _seen {
    my ($self, $name) = @_;
    my $count = grep { $_ eq $name } @{$self->{_stack}};
    return $count || 0;
}

sub _group_id {
    my $self = shift;
    if ($self->{SessionId}) {
        join '-', $GroupId, $self->{SessionId};
    } else {
        $GroupId;
    }
}

sub _stash {
    my $self = shift;
    my $key  = shift;
    if (@_) {
        $self->{_stash}{$key} = shift;
    }
    $self->{_stash}{$key};
}

sub _delete_stash {
    my ($self, $key) = @_;
    delete $self->{_stash}{$key};
}

sub _attr {
    my $elem = shift;
    my $name = shift;
    if (@_) {
        my $value = shift;
        if (defined $value && $value ne '') {
            if (!exists $elem->{Attributes}{"{}$name"}{Name}) {
                $elem->{Attributes}{"{}$name"}{Name} = $name;
            }
            return $elem->{Attributes}{"{}$name"}{Value} = $value;
        } else {
            delete $elem->{Attributes}{"{}$name"};
            return;
        }
    } else {
        return unless exists $elem->{Attributes};
        return unless exists $elem->{Attributes}{"{}$name"};
        return $elem->{Attributes}{"{}$name"}{Value};
    }
}

1;

__END__

=encoding utf-8

=head1 NAME

XML::SAX::SVGTransformer - SVG transformer

=head1 SYNOPSIS

    use XML::SAX::ParserFactory;
    use XML::SAX::SVGTransformer;
    use XML::SAX::Writer;

    my $output;
    my $writer = XML::SAX::Writer->new(
        Output         => \$output,
        QuoteCharacter => '"',
    );
    my $transformer = XML::SAX::SVGTransformer->new(
        Handler   => $writer,
        Transform => 'rotate(90)',
        Width     => 180,
    );
    my $parser = XML::SAX::ParserFactory->parser(
        Handler => $transformer,
    );
    $parser->parse_uri($file);

    say $transformer->info->{width};

=head1 DESCRIPTION

This SAX handler adds a transform attribute to an SVG image
to make it rotate, flip, or resize. You can also use this to extract
the size information of the image.

Internally, this adds a comment to keep the initial image size,
and a group with a transformation attribute to wrap everything in
the outermost C<svg> tag.

=head1 METHODS

=head2 new

Creates a handler. Options specific to this handler are:

=over 4

=item Width

An expected image width. The actual width may be different.

=item Height

An xpected image height. The actual height may be different.

You can set both Width and Height, but you usually get a better
result when you specify only one of them.

=item KeepAspectRatio

If set to true, aspect ratio is kept when both Width and Height
are set.

=item Transform

A string to indicate how to transform the image. Valid values are

C<rotate(\d)>, C<flipx>, C<flipy>, C<matrix(\d \d \d \d \d \d)>.

=item SessionId

This handler usually uses the same group if it finds a group it has
added before. If SessionId is specified, it only reuses the group
with the same id. Otherwise, it adds a new group to wrap the
existing group.

=back

=head2 info

Returns an informational hash reference.

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2021 by Kenichi Ishigaki.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
