package MTL10NUpdater;

use 5.010;
use strict;
use warnings;
use Cwd;
use File::Find;
use File::Basename;
use Encode;
use YAML::Tiny;

my @ignore = qw(
);

sub new {
    my ($class, %args) = @_;
    bless \%args, $class;
}

sub names {
    my $self = shift;
    return '' unless $self->parent;

    my @names = @{ $self->{name} // [] };
    if (!@names) {
        @names = map { basename($_) } grep -d $_, glob $self->path($self->parent, '*');
    }
    if ($self->is_addons) {
        return map { s/\.pack$//; $_ } @names;
    }
    @names;
}

sub parent {
    my $self = shift;
    $self->{parent} //= $self->_parent;
}

sub _parent {
    my $self = shift;
    my ($parent) = $self->_basename =~ /^movabletype-(addons|plugins)/;
    $parent // '';
}

sub _basename {
    my $self = shift;
    $self->{_basename} //= basename(Cwd::cwd);
}

sub root { shift->{root} }

sub mt_dir {
    my $self = shift;
    $self->{mt_dir} //= $self->_mt_dir;
}

sub _mt_dir {
    my $self = shift;
    my $basename = $self->_basename;
    my $parent = $self->parent or return Cwd::realpath(".");
    $basename =~ s/\-$parent//;
    Cwd::realpath("../$basename");
}

sub path {
    my $self = shift;
    Cwd::realpath(File::Spec->catdir($self->root, @_));
}

sub relative {
    my ($self, $path) = @_;
    File::Spec->abs2rel($path, $self->root);
}

sub slurp {
    my ($self, $file) = @_;
    open my $fh, '<', $file or die "$file: $!";
    local $/;
    my $body = <$fh>;
    decode_utf8($body);
}

sub is_addons { shift->parent eq 'addons' }

sub langs {
    my $self = shift;
    my @langs = @{ $self->{lang} // [] };
    if (!@langs) {
        @langs = qw(de es fr ja nl);
    }
    @langs;
}

sub update {
    my $self = shift;
    my $verbose = $self->{verbose};
    my @needs_update;
    my @possibly_removable;
    my @contradicted;
    for my $name ($self->names) {
        my $mapping = $self->find_phrases($name);
        for my $lang ($self->langs) {
            print STDERR "Updating $name $lang\n";
            my ($preamble, $lexicon) = $self->load_current_l10n($name, $lang);
            my $core_lexicon = $self->load_core_l10n($lang) // {};
            my $output = $preamble . '%Lexicon = (' . "\n";
            my %seen;
            for my $path (sort keys %$mapping) {
                my @lines;
                for my $item (@{ $mapping->{$path} }) {
                    my $component;
                    my $phrase = $item;
                    if (ref $item eq 'ARRAY') {
                        $component = $item->[1];
                        $phrase = $item->[0];
                    }
                    next if $seen{$phrase}++;
                    next if $phrase =~ /\A\s*\z/;
                    my $trans = $lexicon->{$phrase};
                    my $message = '';
                    my $is_core;
                    my $core_trans = $core_lexicon->{$phrase} // $core_lexicon->{lc $phrase};
                    if ($core_trans or ($component && !$self->parent)) {
                        $trans //= $core_trans;
                        $message = $verbose && $self->parent ? ' # Core' : '';
                        if ($component) {
                            if ($verbose) {
                                $message = '#' unless $self->parent;
                                $message .= " (possibly removable from core: $component)";
                            }
                            if (!$verbose && !$self->parent) {
                                $seen{$phrase}--;
                                next;
                            }
                            push @possibly_removable, [$name, $lang, $phrase, $trans];
                        }
                        if ($trans ne $core_trans) {
                            $message .= " (contradicted)" if $verbose;
                            push @contradicted, [$name, $lang, $phrase, "$trans <=> $core_trans"];
                        }
                        $is_core = 1 unless $component;
                    }
                    elsif (!defined $trans or $trans eq '') {
                        if (defined $lexicon->{lc $phrase} && $lexicon->{lc $phrase} ne '') {
                            $trans = $lexicon->{lc $phrase};
                            $message = $verbose ? ' # Translate - Case' : '';
                        }
                        else {
                            $trans = '';
                            $message = ' # Translate - New';
                        }
                        push @needs_update, [$name, $lang, $phrase, ""];
                    }
                    my ($qs, $qe) = ("'", "'");
                    if ($phrase =~ /\\n/ or $phrase =~ /[^\\]'/ or $trans =~ /[^\\]'/) {
                        ($qs, $qe) = ('q{', '}');
                        if ($phrase =~ /[{}]/ or $trans =~ /[{}]/) {
                            warn encode_utf8("Unexpected {} in $name $lang:\nPHRASE $phrase\nTRANS: $trans\n");
                            $phrase =~ s/(?<!\\)([{}])/'\\'.$1/eg;
                            $trans  =~ s/(?<!\\)([{}])/'\\'.$1/eg;
                        }
                        if ($trans && ($phrase =~ /\n/ or $trans =~ /\n/)) {
                            my $phrase_n = $phrase =~ tr/\n/\n/;
                            my $trans_n = $trans =~ tr/\n/\n/;
                            warn encode_utf8("Unexpected \\n: in $name $lang ($phrase_n <=> $trans_n):\nPHRASE $phrase\nTRANS: $trans\n");
                        }
                    }
                    my $line = "\t$qs$phrase$qe => $qs$trans$qe,$message";
                    if ($is_core && $self->{ignore_core}) {
                        $line =~ s/^/#/gm;
                    }
                    push @lines, $line; 
                }
                next unless @lines;
                @lines = sort @lines if $self->{sort};
                $output .= join "\n", "", "## $path", (@lines), "";
            }
            $output .= ");\n\n1;\n";
            unless ($self->{dry_run}) {
                my $file = $self->l10n_file($name, $lang);
                open my $fh, '>', $file or die "$file: $!";
                print $fh encode_utf8($output);
                close $fh;
                $self->load_current_l10n($name, $lang);
            }
        }
    }
    if (@possibly_removable) {
        print "\nPossibly removable:\n";
        report(\@possibly_removable);
    }
    if (@needs_update) {
        print "\nNeeds to update:\n";
        report(\@needs_update);
    }
    if (@contradicted) {
        print "\nContradicted:\n";
        report(\@contradicted);
    }
}

sub report {
    my $list = shift;
    my $current = '';
    for my $item (@$list) {
        my $flag = "$item->[0]: $item->[1]";
        if ($current ne $flag) {
            $current = $flag;
            print "\n$flag:\n";
        }
        print "\t", encode_utf8($item->[2]), " => ", encode_utf8($item->[3]), "\n";
    }
}

my %l10n_classes = (
    'feeds-app-lite' => 'FeedsLite::L10N',
    'mixiComment'    => 'mixiComment::L10N',
);

sub l10n_class {
    my ($self, $name) = @_;
    return "MT::L10N" unless $self->parent;

    my $config = $self->load_config_yaml($name);
    my $l10n_class = $config->{l10n_class} // $l10n_classes{$name} // "MT::${name}::L10N";
}

sub l10n_file {
    my ($self, $name, $lang) = @_;
    my $l10n_class = $self->l10n_class($name, $lang);
    $self->path( $self->parent, $self->is_addons ? "$name.pack" : $name, "lib", split('::', $l10n_class), "$lang.pm" );
}

sub load_config_yaml {
    my ($self, $name) = @_;
    my $file = $self->path( $self->parent, $self->is_addons ? "$name.pack" : $name, 'config.yaml' );
    return {} unless $file && -f $file;
    my $config = YAML::Tiny::LoadFile($file);
    $config = $config->[0] if ref $config eq 'ARRAY';
    return $config;
}

sub core_l10n_file {
    my ($self, $lang) = @_;
    Cwd::realpath(File::Spec->catfile( $self->mt_dir, "lib", "MT", "L10N", $lang . ".pm" ));
}

sub load_current_l10n {
    my ($self, $name, $lang) = @_;

    my $package = $self->l10n_class($name) . "::$lang";
    my $file = $self->l10n_file($name, $lang) or die "No l10n file: $name $lang";
    my $module = $self->slurp($file);
    $module =~ s/\A(.+?)(\%Lexicon\s*=)/package $package; use utf8; our $2/s;
    my $preamble = $1 or die "No preamble? $name $lang";
    $module =~ s/^\s*use base.+$//m;
    eval $module or die "Failed to load current l10n module $name $lang: $@";
    no strict 'refs';
    my %lexicon = %{"$package\::Lexicon"};

    ($preamble, \%lexicon);
}

sub load_core_l10n {
    my ($self, $lang) = @_;
    my $file = $self->core_l10n_file($lang);
    if (!-f $file) {
        warn "Core l10n file is missing: $file";
    }
    my $package = join "::", "MT", "L10N", $lang;
    
    my $module = $self->slurp($file);
    $module =~ s/\A(?:.+?)(\%Lexicon\s*=)/package $package; use utf8; our $1/s;
    eval $module or die "Failed to load core l10n module $lang: $@";
    no strict 'refs';
    my %lexicon = %{"$package\::Lexicon"};
    \%lexicon;
}

sub find_phrases {
    my ($self, $name) = @_;
    $name .= ".pack" if $self->is_addons;

    my @dirs;
    my $ignore_re;
    if ($self->parent) {
        @dirs = (
            $self->path($self->parent, $name),
            $self->path("mt-static", $self->parent, $name),
        );
    } else {
        @dirs = qw(
            lib
            php
            themes
            tmpl
            default_templates
            search_templates
            mt-static
            addons
            plugins
        );
        require Regexp::Trie;
        my $rt = Regexp::Trie->new;
        $rt->add($_) for qw(
            fabric.js
            chart-api/mtchart.js
            tiny_mce/plugins/save/plugin.js
            tiny_mce/plugins/spellchecker/plugin.js
            tiny_mce/plugins/template/plugin.js
            tiny_mce/plugins/textcolor/plugin.js
            tiny_mce/plugins/toc/plugin.js
            tiny_mce/tinymce.js
            tiny_mce/plugins/help/plugin.js
            tiny_mce/themes/silver/theme.js
        );
        $ignore_re = $rt->regexp;
    }

    my $verbose = $self->{verbose};
    my %mapping;
    for my $dir (@dirs) {
        next unless -d $dir;
        finddepth({
            no_chdir => 1,
            follow => 1,
            preprocess => sub {
                my @dirs = @_;
                grep {basename($_) !~ m!(?:^|/)(?:\.|extlib|local|t)$!} @dirs
            },
            wanted => sub {
                my $file = $File::Find::name;
                return unless -f $file && $file =~ /\.(?:cgi|pm|pl|php|tmpl|pre|js|mtml|tag|yaml|cfg)$/;
                return if $file =~ /min\.js$/;
                return if $file =~ m!/L10N/!;
                return if $ignore_re && $file =~ /$ignore_re$/;
                print STDERR "Scanning $file\n" if $verbose;
                my $path = $self->relative($file);
                my $content = $self->slurp($file);

                my $check_component = $file =~ /addons|plugins/ ? 1 : 0;

                my @phrases;
                while ($content =~ m!(<(?:_|MT)_TRANS(?:\s+((?:\w+)\s*=\s*(["'])(?:<[^>]+?>|[^\3]+?)*?\3))+?\s*/?>)!igm) {
                    my ($msg, %args) = ($1);
                    while ($msg =~ /\b(\w+)\s*=\s*(["'])((?:<[^>]+?>|[^\2])*?)?\2/g) {  #'
                        $args{$1} = $3;
                    }
                    next unless exists $args{phrase};
                    my $phrase = $args{phrase};
                    $phrase =~ s/\\"/"/g;
                    if ($check_component) {
                        push @phrases, [$phrase, 'tmpl'];
                    } else {
                        push @phrases, $phrase;
                    }
                }

                while ($content =~ /(?:(\S+)\->)?(?:translate|errtrans|trans_error|trans|translate_escape|maketext)\s*\(((?:\s*(?:"(?:[^"\\]+|\\.)*"|'(?:[^'\\]+|\\.)*'|q\{(?:[^}\\]+|\\.)*})\s*\.?\s*){1,})[,\)]/gs) {
                    my ($component, $msg) = ($1, $2);
                    my $phrase = '';
                    while ($msg =~ /"((?:[^"\\]+|\\.)*)"|'((?:[^'\\]+|\\.)*)'|q\{((?:[^}\\]+|\\.)*)}/gs) {
                        $phrase .= ($1 || $2 || $3);
                    }
                    $phrase =~ s/([^\\]?)'/$1\\'/g;
                    $phrase =~ s/['"]\s*.\s*\n\s*['"]//gs;
                    $phrase =~ s/['"]\s*\n\s*.\s*['"]//gs;
                    $phrase =~ s/\\?\\'/'/g;
                    if ($check_component && $component && $component !~ /^(?:MT|\$mt|\$ctx->mt|\$app|\$self|\$class)$/) {
                        push @phrases, [$phrase, $component];  # component-specific
                    } else {
                        push @phrases, $phrase;
                    }
                }

                while ($content =~ /\s*(?:["'])?label(?:_plural)?(?:["'])?\s*=>\s*(["'])(.*?)([^\\])\1/gs) {
                    next if $2 =~ /^$1/;
                    my $phrase = $2.$3;
                    next if $phrase =~ /^string\(/;
                    if ($check_component) {
                        push @phrases, [$phrase, 'label'];
                    } else {
                        push @phrases, $phrase;
                    }
                }

                if ($path =~ /(services|streams)\.yaml$/) {
                    while ($content =~ /\s*(?:description|ident_hint|label|name):\s*(.+)/g) {
                        my $phrase = $1;
                        $phrase =~ s/(^'+|'+$)//;
                        $phrase =~ s/'/\\'/g;
                        push @phrases, $phrase;
                    }
                }
                elsif ($path =~ /\.yaml$/) {
                    while ($content =~ /\s*(?:label:|label_plural:)\s*(.+)/g) {
                        my $phrase = $1;
                        $phrase =~ s/(^'+|'+$)//g;
                        $phrase =~ s/'/\\'/g;
                        if ($check_component) {
                            push @phrases, [$phrase, 'label'];
                        } else {
                            push @phrases, $phrase;
                        }
                    }
                }

                $mapping{$path} = \@phrases;
            },
        }, $dir);
    }
    \%mapping;
}

1;
