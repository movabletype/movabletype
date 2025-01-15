use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../t/lib";
use File::Find;
use File::Spec;
use Test::More;
use Cwd qw(realpath);
use Path::Tiny;
use HTML::Filter::Callbacks;
use MT::Test::Util::MakeMTTagsHarmless;

BEGIN {
    plan skip_all => 'requires MT_TEST_STATIC_FILES for now' unless exists $ENV{MT_TEST_STATIC_FILES};
}

my %known;
my %unknown;
my @broken;

my %used_in_makefile;
my %made_by_makefile;
my $makefile = path("$FindBin::Bin/../Makefile")->slurp_utf8;
while($makefile =~ m!mt-static/(.+?.(?:css|js):?)!g) {
    my $path = $1;
    if ($path =~ s/:$//) {
        $made_by_makefile{$path} = 1;
    } else {
        $used_in_makefile{$path} = 1;
    }
}

my %used_in_makejs;
my $makejs = path("$FindBin::Bin/../build/mt-dists/make-js")->slurp_utf8;
while($makejs =~ m!mt-static/(.+?.(?:css|js))!g) {
    $used_in_makejs{$1} = 1;
}
my %made_by_makejs = map { "mt_" . $_ . ".js" => 1 } qw(en_us ja de fr nl es);

my %copied_but_unused = map { $_ => 1 } qw(
    bootstrap/js/bootstrap.bundle.js
    bootstrap/js/bootstrap.bundle.min.js
    bootstrap5/js/bootstrap.esm.js
    bootstrap5/js/bootstrap.esm.min.js
    bootstrap5/js/bootstrap.js
    bootstrap5/js/bootstrap.min.js
);

my %used_in_archetype = map {$_ => 1} qw(css/editor/editor-content.css);

my $mt_static = realpath("$FindBin::Bin/../mt-static");
my @tmpl_dirs = map { realpath($_) } grep {-d $_} ("$FindBin::Bin/../tmpl", glob("$FindBin::Bin/../plugins/*/tmpl"), glob("$FindBin::Bin/../addons/*/tmpl"));

find({
    wanted => sub {
        my $file = $File::Find::name;
        return unless -f $file;
        my $relpath = File::Spec->abs2rel($file, $mt_static);
        $known{$relpath} = 0;
    },
    no_chdir => 1,
    follow   => 1,
}, $mt_static);

my $filter = HTML::Filter::Callbacks->new;
$filter->add_callbacks(
    script => {
        start => sub {
            my ($tag, $c) = @_;
            my $src = $tag->attr('src') or return;
            $src =~ s/[\?#].*$//;
            $src =~ s!^(\.\./)+!!;
            return if $src =~ /mt_%l/;
            if (exists $known{$src}) {
                $known{$src}++;
            } else {
                return if !$src || $src =~ m![/_]\.js$!;
                $unknown{$src}++;
                return if $made_by_makefile{$src} || $made_by_makejs{$src};
                push @broken, $c->stash->{file} . ": $src";
            }
        },
    },
    my_script => {
        start => sub {
            my ($tag, $c) = @_;
            my $src = $tag->attr('path') or return;
            $src =~ s/[\?#].*$//;
            $src =~ s!^(\.\./)+!!;
            return if $src =~ /mt_%l/;
            if (exists $known{$src}) {
                $known{$src}++;
            } else {
                return if !$src || $src =~ m![/_]\.js$!;
                $unknown{$src}++;
                return if $made_by_makefile{$src} || $made_by_makejs{$src};
                push @broken, $c->stash->{file} . ": $src";
            }
        },
    },
    link => {
        start => sub {
            my ($tag, $c) = @_;
            my $href = $tag->attr('href') or return;
            $href =~ s/[\?#].*$//;
            $href =~ s!^(\.\./)+!!;
            $href =~ s!^/!!;
            if (exists $known{$href}) {
                $known{$href}++;
            } else {
                return if !$href || $href =~ /_\.css$/;
                $unknown{$href}++;
                return if $made_by_makefile{$href} || $made_by_makejs{$href} || $used_in_archetype{$href};
                push @broken, $c->stash->{file} . ": $href";
            }
        },
    },
    my_stylesheet => {
        start => sub {
            my ($tag, $c) = @_;
            my $href = $tag->attr('path') or return;
            $href =~ s/[\?#].*$//;
            $href =~ s!^(\.\./)+!!;
            $href =~ s!^/!!;
            if (exists $known{$href}) {
                $known{$href}++;
            } else {
                return if !$href || $href =~ /_\.css$/;
                $unknown{$href}++;
                return if $made_by_makefile{$href} || $made_by_makejs{$href} || $used_in_archetype{$href};
                push @broken, $c->stash->{file} . ": $href";
            }
        },
    },
);

for my $tmpl_dir (@tmpl_dirs) {
    next if $tmpl_dir =~ /MTBlockEditor|SharedPreview/;
    find({
        wanted => sub {
            my $file = $File::Find::name;
            return unless -f $file;
            test($file);
        },
        no_chdir => 1,
        follow   => 0,
    }, $tmpl_dir);
}

sub test {
    my $file = shift;
    my $tmpl = path($file)->slurp_utf8;
    $tmpl =~ s/mt:script/my_script/gs;
    $tmpl =~ s/mt:stylesheet/my_stylesheet/gs;
    $tmpl = strip_mt_tags(make_harmless($tmpl));
    $tmpl =~ s/<!--[^>]+>//g;
    $filter->stash->{file} = $file;
    $filter->process($tmpl);
}

for my $path (sort keys %known) {
    next unless $path =~ /\.(?:css|js)$/;
    next if $path =~ m!(?:^|/)(?:themes|support|plugins|popper|codemirror|i18n|data-api)/!;
    next if $path =~ m!chart-api/(?:core|deps)/!;
    next if $path =~ m!themes-base/!;
    next if $path =~ /styles_\w+.css$/;
    next if $path =~ /mt_\w+.js$/;
    if ($known{$path}) {
        ok $known{$path}, "$path is used $known{$path} times";
    } else {
        my $alt_path = $path;
        if ($alt_path =~ /\.min/) {
            $alt_path =~ s/\.min\.(css|js)$/.$1/;
        } else {
            $alt_path =~ s/\.(css|js)$/.min.$1/;
        }
        if ($known{$alt_path}) {
            local $TODO = "only $alt_path is used";
            ok $known{$alt_path}, "$path is not used but $alt_path is used $known{$alt_path} times";
        } elsif ($used_in_makefile{$path}) {
            local $TODO = "only used in Makefile";
            ok $used_in_makefile{$path}, "$path is only used in Makefile";
        } elsif ($used_in_makejs{$path}) {
            local $TODO = "only used in make-js";
            ok $used_in_makejs{$path}, "$path is only used in make-js";
        } elsif ($used_in_archetype{$path}) {
            local $TODO = "only used in archetype";
            ok $used_in_archetype{$path}, "$path is only used in archetype";
        } elsif ($copied_but_unused{$path}) {
            local $TODO = "copied but not used";
            ok $used_in_makejs{$path}, "$path is copied from node_modules but not used";
        } else {
            ok $known{$path}, "$path is used $known{$path} times";
        }
    }
}
for my $path (sort keys %unknown) {
    if ($unknown{$path}) {
        if ($made_by_makefile{$path}) {
            local $TODO = "will be made by Makefile";
            ok $made_by_makefile{$path}, "$path will be made by Makefile, used $unknown{$path} times";
            next;
        } elsif ($made_by_makejs{$path}) {
            local $TODO = "will be made by make-js";
            ok $made_by_makejs{$path}, "$path will be made by make-js, used $unknown{$path} times";
            next;
        }
    }
    ok !$unknown{$path}, "unknown $path is used $unknown{$path} times";
}

note explain \@broken if @broken;

done_testing;
