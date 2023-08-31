use v5.10.1;
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../t/lib";
use MT::Test::Env;
use MT::Test::Util::MakeMTTagsHarmless;
use Test::More;
use File::Find;
use Path::Tiny;
use HTML::Filter::Callbacks;
use Term::ANSIColor;

BEGIN {
    plan skip_all => 'requires MT_TEST_BS_MIGRATION for now' unless exists $ENV{MT_TEST_BS_MIGRATION};
}

my %map = map {lc $_ => 1} split /\s+/, $ENV{MT_TEST_BS_MIGRATION} // '';

sub info    ($) { note colored(shift, "cyan") }
sub warning ($) { note colored(shift, "yellow") }

# see https://getbootstrap.com/docs/5.0/migration/ (or https://getbootstrap.jp/docs/5.0/migration/) for details

my $filter = HTML::Filter::Callbacks->new;
$filter->add_callbacks(
    '*' => {
        start => sub {
            my ($tag, $c) = @_;
            $tag->remove_text;
            my $name = lc $tag->name;
            my $html = $tag->as_string;
            if ($html =~ /class=`/) {
                $c->stash->{retry}{$tag->as_string} = strip_mt_tags($html);
                return;
            }
            $html = delete $filter->stash->{org} if $filter->stash->{org};
            my $file = $c->stash->{file};
            my @classes = split /\s/, $tag->attr('class') // '';
            my %class_map = map { $_ => 1 } @classes;
            my @attrs = @{$tag->{attrs}};

            ## Content, Reboot, etc
            if (!%map or grep /content/, keys %map) {
                info "$file: drop thead-light/dark: $html" if grep /thead-(?:light|dark)/, @classes;
                info "$file: drop text-justify: $html" if grep /text-justify/, @classes;

                # defined in scss/admin2023/_modifier.scss
                info "$file: drop pre-scrollable: $html" if grep /pre-scrollable/, @classes;

                if ($name eq 'a') {
                    # .text-* utilities do not add hover and focus states to links anymore.
                    # .link-* helper classes can be used instead. 
                    # https://github.com/twbs/bootstrap/pull/29267
                    if (grep /^text-/, @classes) {
                        warning "$file: use link- instead of text-: $html";
                    }
                }
            }

            ## Forms
            if (!%map or grep /form/, keys %map) {
                if (grep /custom-check/, @classes) {
                    if (!grep /form-check/, @classes) {
                        fail "$file: replace custom-check with form-check: $html";
                    } else {
                        info "$file: drop custom-check: $html";
                    }
                }

                warning "$file: replace custom-switch with form-switch: $html" if grep /custom-switch/, @classes;
                warning "$file: drop custom-file: $html" if grep /custom-file/, @classes;
                warning "$file: drop form-file: $html" if grep /form-file/, @classes;
                warning "$file: replace custom-range with form-range: $html" if grep /custom-range/, @classes;
                warning "$file: drop form-control-file: $html" if grep /form-control-file/, @classes;
                warning "$file: drop form-control-range: $html" if grep /form-control-range/, @classes;
                warning "$file: drop input-group-append: $html" if grep /input-group-append/, @classes;
                warning "$file: drop input-group-prepend: $html" if grep /input-group-prepend/, @classes;

                warning "$file: drop form-row: $html" if grep /form-row/, @classes;

                # defined in scss/admin2023/_modifier.scss
                info "$file: drop form-group: $html" if grep /form-group/, @classes;
                info "$file: drop form-inline: $html" if grep /form-inline/, @classes;

                if ($name eq 'label') {
                    fail "$file: $name has no form-label: $html" unless $class_map{'form-label'} || $class_map{'form-check-label'};
                }
                if ($name eq 'select') {
                    fail "$file: $name has no form-select: $html" unless $class_map{'form-select'};

                    # .form-inline .custom-select is defined in scss/admin2023/_modifier.scss
                    # both custom-select and form-select are needed
                    warning "$file: $name has no custom-select: $html" unless $class_map{'custom-select'};
                }
            }

            ## Badges
            if (!%map or grep /badge/, keys %map) {
                # some of the badge-(type) attributes are defined in scss/admin2023/_modifier.scss
                info "$file: replace badge-* with bg-*: $html" if grep /^badge-(?:primary|success|danger|warning|info)/, @classes;
                warning "$file: replace badge-* with bg-*: $html" if grep /^badge-(?:secondary|light|dark)/, @classes;

                warning "$file: replace badge-pill with rounded-pill: $html" if grep /^badge-pill/, @classes;
            }

            ## Close button
            if (!%map or grep /close/, keys %map) {
                # button.close is defined in scss/admin2023/_modifier.scss
                info "$file: replace close with btn-close: $html" if grep /^close$/, @classes;
            }

            ## Utilities
            if (!%map or grep /util/, keys %map) {
                warning "$file: replace left-* with start-*: $html" if grep /^left-\w+$/, @classes;
                warning "$file: replace right-* with end-*: $html" if grep /^right-\w+$/, @classes;
                warning "$file: replace float-left with float-start: $html" if grep /float-left/, @classes;
                warning "$file: replace float-right with float-end: $html" if grep /float-right/, @classes;
                warning "$file: replace border-left with border-start: $html" if grep /border-left/, @classes;
                warning "$file: replace border-right with border-end: $html" if grep /border-right/, @classes;
                warning "$file: replace rounded-left with rounded-start: $html" if grep /rounded-left/, @classes;
                warning "$file: replace rounded-right with rounded-end: $html" if grep /rounded-right/, @classes;
                warning "$file: replace ml-* with ms-*: $html" if grep /^ml-\w+$/, @classes;
                warning "$file: replace mr-* with me-*: $html" if grep /^mr-\w+$/, @classes;
                warning "$file: replace pl-* with ps-*: $html" if grep /^pl-\w+$/, @classes;
                warning "$file: replace pr-* with pe-*: $html" if grep /^pr-\w+$/, @classes;
                warning "$file: replace text-left with text-start: $html" if grep /text-left/, @classes;
                warning "$file: replace text-right with text-end: $html" if grep /text-right/, @classes;

                warning "$file: replace text-monospace with font-monospace: $html" if grep /text-monospace/, @classes;
                warning "$file: drop text-hide: $html" if grep /text-hide/, @classes;

                warning "$file: replace font-weight-* with fw-*: $html" if grep /font-weight-/, @classes;
                warning "$file: replace font-style-* with fst-*: $html" if grep /font-style-/, @classes;

                warning "$file: replace rounded-sm with rounded-[0-3]: $html" if grep /rounded-sm/, @classes;
                warning "$file: drop rounded-lg with rounded-[0-3]: $html" if grep /rounded-lg/, @classes;
            }

            ## Helpers
            if (!%map or grep /helper/, keys %map) {
                fail "$file: replace sr-only with visually-hidden: $html" if grep /^sr-only/, @classes && !grep /^visually-hidden/, @classes;
            }

            ## JavaScript
            if (!%map or grep /java|js/, keys %map) {
                # typically, data-bs-toggle, data-bs-target, data-bs-parent, data-bs-dismiss, data-bs-container etc...
                my $known = qr/(?:toggle|target|parent|dismiss|container)/;
                my $mt_attr = join '|', qw(
                    mt id role destination blockeditor asset orig_text placement full_rich screen label children panel
                    is can-data field archive rebuild search test child
                );
                for my $name (qw(toggle target parent dismiss container)) {
                    fail "$file: replace data-$name with data-bs-$name: $html" if grep(/^data-$name/, @attrs) && $c->stash->{content} !~ /jQuery.*?data\([^)]*$name/;
                    fail "$file: replace data-bs-$name with data-$name: $html" if grep(/^data-bs-$name/, @attrs) && $c->stash->{content} =~ /jQuery.*?data\([^)]*$name/;
                }
                info "$file: replace data-* with data-bs-*: $html" if grep {/^data-(?!bs)/ && !/^data-$known/ && !/^data-(?:$mt_attr)/} @attrs;
            }
        },
    },
);

my @lib_dirs = grep { -d $_ } (
    'lib',
    glob("plugins/*/lib"),
    glob("plugins/*/*.pl"),
    glob("plugins/*/config.yaml"),
    glob("addons/*/lib"),
    glob("addons/*/*.pl"),
    glob("addons/*/config.yaml"),
    glob("../movabletype-addons/addons/*/lib"),
    glob("../movabletype-addons/addons/*/*.pl"),
    glob("../movabletype-addons/addons/*/config.yaml"),
    glob("../movabletype-plugins/plugins/*/lib"),
    glob("../movabletype-plugins/plugins/*/*.pl"),
    glob("../movabletype-plugins/plugins/*/config.yaml"),
);

for my $dir (@lib_dirs) {
    find({
        wanted => sub {
            my $file = $File::Find::name;
            return unless -f $file;
            return if $file =~ /L10N/;
            test($file);
        },
        no_chdir    => 1,
        follow_fast => 1,
    }, $dir);
}

my @tmpl_dirs = (
    'tmpl',
    glob("plugins/*/tmpl"),
    glob("addons/*/tmpl"),
);

for my $dir (@tmpl_dirs) {
    find({
        wanted => sub {
            my $file = $File::Find::name;
            return unless -f $file;
            return unless $file =~ /admin2023/;
            test($file);
        },
        no_chdir    => 1,
        follow_fast => 1,
    }, $dir);
}

pass "walked through";

done_testing;

my $MANIFEST_SKIP_REGEX;

sub test {
    my $file = shift;

    $MANIFEST_SKIP_REGEX ||= load_manifest_skip();
    return if $file =~ $MANIFEST_SKIP_REGEX;

#    note $file;
    my $content = path($file)->slurp_utf8;
    return unless $content =~ /<\w+/;
    $filter->stash->{file} = $file;
    $content = make_harmless($content);
    $filter->stash->{content} = $content;
    $filter->process($content);
    while (my $retry = delete $filter->stash->{retry}) {
        for my $org (sort keys %$retry) {
            $filter->stash->{org} = $org;
            $filter->process($retry->{$org});
        }
    }
}

sub load_manifest_skip {
    # Not skipping lines with rules is ok for testing purpose.
    my @lines = map { chomp($_); $_ } grep { $_ =~ /^[^#\s]/ } path('MANIFEST.SKIP')->lines;
    my $regex = join('|', @lines);
    return qr/$regex/;
}
