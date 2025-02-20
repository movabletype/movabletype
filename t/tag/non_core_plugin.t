use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        PluginPath => ['TEST_ROOT/plugins'],
    );
    $ENV{MT_CONFIG} = $test_env->config_file;

    $test_env->save_file('plugins/Awesome/config.yaml', <<'YAML');
name: Awesome
key:  awesome
id:   awesome
YAML

    $test_env->save_file('plugins/SortMethod/config.yaml', <<'YAML');
name: SortMethod
id:   sortmethod
YAML

    $test_env->save_file('plugins/SortMethod/lib/SortMethod.pm', <<'PM');
package SortMethod;
use strict;
use warnings;

sub sort ($$) { $_[0]->label cmp $_[1]->label }

1;
PM
}

use MT::Test::Tag;

$test_env->prepare_fixture('db_data');

my $blog_id = 1;

MT::Test::Tag->run_perl_tests($blog_id);
MT::Test::Tag->run_php_tests($blog_id);

done_testing;

__DATA__

=== test 757
--- template
<MTSubCategories show_empty="1" top="1" sort_method="SortMethod::sort"><MTCategoryLabel></MTSubCategories>
--- expected
barfoo

=== test 855
--- template
<MTHasPlugin name="Awesome">has Awesome<MTElse>doesn't have Awesome</MTHasPlugin>
--- expected
has Awesome
