use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',  ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use Test::Base::Less;
use MT::Util qw( html_text_transform );

register_filter html_text_transform => \&html_text_transform;

filters {
    input    => [qw/chomp html_text_transform/],
    expected => [qw/trim chomp/],
};

run {
    my $block = shift;
    is($block->input, $block->expected);
};

done_testing;

__DATA__

=== single paragraph, single line, no tags
--- input
test
--- expected
<p>test</p>

=== single paragraph, multiple lines, no tags
--- input
test
test2
--- expected
<p>test<br />
test2</p>

=== multiple paragraphs, single line, no tags
--- input
test

test2
--- expected
<p>test</p>

<p>test2</p>

=== multiple paragraphs, multiple lines, no tags
--- input
test
test2

test3
test4
--- expected
<p>test<br />
test2</p>

<p>test3<br />
test4</p>

=== single paragraph, single line, tagged
--- input
<ul><li>test</li></ul>
--- expected
<ul><li>test</li></ul>

=== single paragraph, multiple lines, tagged
--- input
<ul>
<li>test</li>
<li>test2</li>
</ul>
--- expected
<ul>
<li>test</li>
<li>test2</li>
</ul>

=== multiple paragraphs, single line, tagged
--- input
<ul>
<li>test</li>

<li>test2</li>
</ul>
--- expected
<ul>
<li>test</li>

<li>test2</li>
</ul>

=== multiple paragraphs, multiple lines, tagged
--- input
<ul>
<li>test
test2</li>

<li>test3
test4</li>
</ul>
--- expected
<ul>
<li>test<br />
test2</li>

<li>test3<br />
test4</li>
</ul>

=== multiple paragraphs, multiple lines, mixed (edge cases)
--- input
<ul>
<li>test1

test2-1
test2-2

test3</li>

<li>test4-1
test4-2

test5-1
test5-2
test5-3

test6-1
test6-2</li>

<li>test7-1
test7-2

test8-1
test8-2</li>
</ul>
--- expected
<ul>
<li>test1

<p>test2-1<br />
test2-2</p>

test3</li>

<li>test4-1<br />
test4-2

<p>test5-1<br />
test5-2<br />
test5-3</p>

test6-1<br />
test6-2</li>

<li>test7-1<br />
test7-2<br /><br />

test8-1<br />
test8-2</li>
</ul>

=== multiple paragraphs, multiple lines, no mix
--- input
<ul>
<li>

test1

test2-1
test2-2

test3

</li>

<li>

test4-1
test4-2

test5-1
test5-2
test5-3

test6-1
test6-2

</li>
</ul>
--- expected
<ul>
<li>

<p>test1</p>

<p>test2-1<br />
test2-2</p>

<p>test3</p>

</li>

<li>

<p>test4-1<br />
test4-2</p>

<p>test5-1<br />
test5-2<br />
test5-3</p>

<p>test6-1<br />
test6-2</p>

</li>
</ul>

=== guard pre, script, code tags
--- input
line1
line2

<pre>
pre-line1-1
pre-line1-2

pre-line2-1
pre-line2-2

pre-line3-1
pre-line3-2
</pre>

<pre><code>
pre-line0-1
pre-line0-2

<script>
pre-line1-1
pre-line1-2

pre-line2-1
pre-line2-2

pre-line3-1
pre-line3-2
</script>

pre-line4-1
pre-line4-2
</code></pre>

<script>
script1-1
script1-2

script2-1
script2-2

script3-1
script3-2
</script>

<style>
# though style tag should not appear in the html body...
style1-1
style1-2

style2-1
style2-2

style3-1
style3-2
</style>

line3
line4
--- expected
<p>line1<br />
line2</p>

<pre>
pre-line1-1
pre-line1-2

pre-line2-1
pre-line2-2

pre-line3-1
pre-line3-2
</pre>

<pre><code>
pre-line0-1
pre-line0-2

<script>
pre-line1-1
pre-line1-2

pre-line2-1
pre-line2-2

pre-line3-1
pre-line3-2
</script>

pre-line4-1
pre-line4-2
</code></pre>

<script>
script1-1
script1-2

script2-1
script2-2

script3-1
script3-2
</script>

<style>
# though style tag should not appear in the html body...
style1-1
style1-2

style2-1
style2-2

style3-1
style3-2
</style>

<p>line3<br />
line4</p>

=== guard pre, script, code tags more eagerly
--- input
line1
line2

<div>
<pre>
pre-line1-1
pre-line1-2

pre-line2-1
pre-line2-2

pre-line3-1
pre-line3-2
</pre>
</div>

<p>
<pre><code>
pre-line0-1
pre-line0-2

<script>
pre-line1-1
pre-line1-2

pre-line2-1
pre-line2-2

pre-line3-1
pre-line3-2
</script>

pre-line4-1
pre-line4-2
</code></pre>
</p>

<script src=""></script>
<script src=""></script>
<script src=""></script>

<script src=""></script>
<script>
script1-1
script1-2

script2-1
script2-2

script3-1
script3-2
</script>

<script src=""></script>
<style>
# though style tag should not appear in the html body...
style1-1
style1-2

style2-1
style2-2

style3-1
style3-2
</style>

<div>
<!--
foo
-->
</div>

line3
line4
--- expected
<p>line1<br />
line2</p>

<div>
<pre>
pre-line1-1
pre-line1-2

pre-line2-1
pre-line2-2

pre-line3-1
pre-line3-2
</pre>
</div>

<p>
<pre><code>
pre-line0-1
pre-line0-2

<script>
pre-line1-1
pre-line1-2

pre-line2-1
pre-line2-2

pre-line3-1
pre-line3-2
</script>

pre-line4-1
pre-line4-2
</code></pre>
</p>

<script src=""></script>
<script src=""></script>
<script src=""></script>

<script src=""></script>
<script>
script1-1
script1-2

script2-1
script2-2

script3-1
script3-2
</script>

<script src=""></script>
<style>
# though style tag should not appear in the html body...
style1-1
style1-2

style2-1
style2-2

style3-1
style3-2
</style>

<div>
<!--
foo
-->
</div>

<p>line3<br />
line4</p>
