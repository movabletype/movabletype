package MT::Test::Util::CreativeCommons;

use strict;
use warnings;

sub by_nc_sa_20 {
    return join " ", qw(
        by-nc-sa
        http://creativecommons.org/licenses/by-nc-sa/2.0/
        http://creativecommons.org/images/public/somerights20.gif
    );
}

sub by_30 {
    return join " ", qw(
        by
        http://creativecommons.org/licenses/by/3.0/
        http://i.creativecommons.org/l/by/3.0/88x31.png
    );
}

sub set_cc_license {
    my ($class, $type) = @_;
    for my $site (MT::Website->load({class => '*'})) {
        $site->cc_license(MT::Test::Util::CreativeCommons->$type);
        $site->save;
    }
}

1;
