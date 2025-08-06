#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use FindBin;
use lib "$FindBin::Bin/../../../t/lib"; # t/lib

use Test::More;
use MT::Test::Env;
use MT::Test::PHP;

our $test_env;
BEGIN {
    plan skip_all => 'Requires Perl 5.26' if $] < 5.026;

    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test::TextFilter;

$test_env->prepare_fixture('db');

delimiters('@@@', '!!!');

MT::Test::TextFilter->set('gfm');

filters {
    text     => [qw( chomp )],
    expected => [qw( chomp )],
};

my $site = MT::Blog->load(1);
my $site_id = $site->id;

MT::Test::TextFilter->run_perl_tests($site_id);
MT::Test::TextFilter->run_php_tests($site_id) if MT::Test::PHP::php_version >= 7.4;

done_testing;

# Version 0.29-gfm (2019-04-06)

__END__

@@@ Test 1
!!! text
	foo	baz		bim
!!! expected
<pre><code>foo	baz		bim
</code></pre>

@@@ Test 2
!!! text
  	foo	baz		bim
!!! expected
<pre><code>foo	baz		bim
</code></pre>

@@@ Test 3
!!! text
    a	a
    ὐ	a
!!! expected
<pre><code>a	a
ὐ	a
</code></pre>

@@@ Test 4
!!! text
  - foo

	bar
!!! expected
<ul>
<li>
<p>foo</p>
<p>bar</p>
</li>
</ul>

@@@ Test 5
!!! text
- foo

		bar
!!! expected
<ul>
<li>
<p>foo</p>
<pre><code>  bar
</code></pre>
</li>
</ul>

@@@ Test 6
!!! text
>		foo
!!! expected
<blockquote>
<pre><code>  foo
</code></pre>
</blockquote>

@@@ Test 7
!!! text
-		foo
!!! expected
<ul>
<li>
<pre><code>  foo
</code></pre>
</li>
</ul>

@@@ Test 8
!!! text
    foo
	bar
!!! expected
<pre><code>foo
bar
</code></pre>

@@@ Test 9
!!! text
 - foo
   - bar
	 - baz
!!! expected
<ul>
<li>foo
<ul>
<li>bar
<ul>
<li>baz</li>
</ul>
</li>
</ul>
</li>
</ul>

@@@ Test 10
!!! text
#	Foo
!!! expected
<h1>Foo</h1>

@@@ Test 11
!!! text
*	*	*	
!!! expected
<hr />

@@@ Test 12
!!! text
- `one
- two`
!!! expected
<ul>
<li>`one</li>
<li>two`</li>
</ul>

@@@ Test 13
!!! text
***
---
___
!!! expected
<hr />
<hr />
<hr />

@@@ Test 14
!!! text
+++
!!! expected
<p>+++</p>

@@@ Test 15
!!! text
===
!!! expected
<p>===</p>

@@@ Test 16
!!! text
--
**
__
!!! expected
<p>--
**
__</p>

@@@ Test 17
!!! text
 ***
  ***
   ***
!!! expected
<hr />
<hr />
<hr />

@@@ Test 18
!!! text
    ***
!!! expected
<pre><code>***
</code></pre>

@@@ Test 19
!!! text
Foo
    ***
!!! expected
<p>Foo
***</p>

@@@ Test 20
!!! text
_____________________________________
!!! expected
<hr />

@@@ Test 21
!!! text
 - - -
!!! expected
<hr />

@@@ Test 22
!!! text
 **  * ** * ** * **
!!! expected
<hr />

@@@ Test 23
!!! text
-     -      -      -
!!! expected
<hr />

@@@ Test 24
!!! text
- - - -    
!!! expected
<hr />

@@@ Test 25
!!! text
_ _ _ _ a

a------

---a---
!!! expected
<p>_ _ _ _ a</p>
<p>a------</p>
<p>---a---</p>

@@@ Test 26
!!! text
 *-*
!!! expected
<p><em>-</em></p>

@@@ Test 27
!!! text
- foo
***
- bar
!!! expected
<ul>
<li>foo</li>
</ul>
<hr />
<ul>
<li>bar</li>
</ul>

@@@ Test 28
!!! text
Foo
***
bar
!!! expected
<p>Foo</p>
<hr />
<p>bar</p>

@@@ Test 29
!!! text
Foo
---
bar
!!! expected
<h2>Foo</h2>
<p>bar</p>

@@@ Test 30
!!! text
* Foo
* * *
* Bar
!!! expected
<ul>
<li>Foo</li>
</ul>
<hr />
<ul>
<li>Bar</li>
</ul>

@@@ Test 31
!!! text
- Foo
- * * *
!!! expected
<ul>
<li>Foo</li>
<li>
<hr />
</li>
</ul>

@@@ Test 32
!!! text
# foo
## foo
### foo
#### foo
##### foo
###### foo
!!! expected
<h1>foo</h1>
<h2>foo</h2>
<h3>foo</h3>
<h4>foo</h4>
<h5>foo</h5>
<h6>foo</h6>

@@@ Test 33
!!! text
####### foo
!!! expected
<p>####### foo</p>

@@@ Test 34
!!! text
#5 bolt

#hashtag
!!! expected
<p>#5 bolt</p>
<p>#hashtag</p>

@@@ Test 35
!!! text
\## foo
!!! expected
<p>## foo</p>

@@@ Test 36
!!! text
# foo *bar* \*baz\*
!!! expected
<h1>foo <em>bar</em> *baz*</h1>

@@@ Test 37
!!! text
#                  foo                     
!!! expected
<h1>foo</h1>

@@@ Test 38
!!! text
 ### foo
  ## foo
   # foo
!!! expected
<h3>foo</h3>
<h2>foo</h2>
<h1>foo</h1>

@@@ Test 39
!!! text
    # foo
!!! expected
<pre><code># foo
</code></pre>

@@@ Test 40
!!! text
foo
    # bar
!!! expected
<p>foo
# bar</p>

@@@ Test 41
!!! text
## foo ##
  ###   bar    ###
!!! expected
<h2>foo</h2>
<h3>bar</h3>

@@@ Test 42
!!! text
# foo ##################################
##### foo ##
!!! expected
<h1>foo</h1>
<h5>foo</h5>

@@@ Test 43
!!! text
### foo ###     
!!! expected
<h3>foo</h3>

@@@ Test 44
!!! text
### foo ### b
!!! expected
<h3>foo ### b</h3>

@@@ Test 45
!!! text
# foo#
!!! expected
<h1>foo#</h1>

@@@ Test 46
!!! text
### foo \###
## foo #\##
# foo \#
!!! expected
<h3>foo ###</h3>
<h2>foo ###</h2>
<h1>foo #</h1>

@@@ Test 47
!!! text
****
## foo
****
!!! expected
<hr />
<h2>foo</h2>
<hr />

@@@ Test 48
!!! text
Foo bar
# baz
Bar foo
!!! expected
<p>Foo bar</p>
<h1>baz</h1>
<p>Bar foo</p>

@@@ Test 49
!!! text
## 
#
### ###
!!! expected
<h2></h2>
<h1></h1>
<h3></h3>

@@@ Test 50
!!! text
Foo *bar*
=========

Foo *bar*
---------
!!! expected
<h1>Foo <em>bar</em></h1>
<h2>Foo <em>bar</em></h2>

@@@ Test 51
!!! text
Foo *bar
baz*
====
!!! expected
<h1>Foo <em>bar
baz</em></h1>

@@@ Test 52
!!! text
  Foo *bar
baz*	
====
!!! expected
<h1>Foo <em>bar
baz</em></h1>

@@@ Test 53
!!! text
Foo
-------------------------

Foo
=
!!! expected
<h2>Foo</h2>
<h1>Foo</h1>

@@@ Test 54
!!! text
   Foo
---

  Foo
-----

  Foo
  ===
!!! expected
<h2>Foo</h2>
<h2>Foo</h2>
<h1>Foo</h1>

@@@ Test 55
!!! text
    Foo
    ---

    Foo
---
!!! expected
<pre><code>Foo
---

Foo
</code></pre>
<hr />

@@@ Test 56
!!! text
Foo
   ----      
!!! expected
<h2>Foo</h2>

@@@ Test 57
!!! text
Foo
    ---
!!! expected
<p>Foo
---</p>

@@@ Test 58
!!! text
Foo
= =

Foo
--- -
!!! expected
<p>Foo
= =</p>
<p>Foo</p>
<hr />

@@@ Test 59
!!! text
Foo  
-----
!!! expected
<h2>Foo</h2>

@@@ Test 60
!!! text
Foo\
----
!!! expected
<h2>Foo\</h2>

@@@ Test 61
!!! text
`Foo
----
`

<a title="a lot
---
of dashes"/>
!!! expected
<h2>`Foo</h2>
<p>`</p>
<h2>&lt;a title=&quot;a lot</h2>
<p>of dashes&quot;/&gt;</p>

@@@ Test 62
!!! text
> Foo
---
!!! expected
<blockquote>
<p>Foo</p>
</blockquote>
<hr />

@@@ Test 63
!!! text
> foo
bar
===
!!! expected
<blockquote>
<p>foo
bar
===</p>
</blockquote>

@@@ Test 64
!!! text
- Foo
---
!!! expected
<ul>
<li>Foo</li>
</ul>
<hr />

@@@ Test 65
!!! text
Foo
Bar
---
!!! expected
<h2>Foo
Bar</h2>

@@@ Test 66
!!! text
---
Foo
---
Bar
---
Baz
!!! expected
<hr />
<h2>Foo</h2>
<h2>Bar</h2>
<p>Baz</p>

@@@ Test 67
!!! text

====
!!! expected
<p>====</p>

@@@ Test 68
!!! text
---
---
!!! expected
<hr />
<hr />

@@@ Test 69
!!! text
- foo
-----
!!! expected
<ul>
<li>foo</li>
</ul>
<hr />

@@@ Test 70
!!! text
    foo
---
!!! expected
<pre><code>foo
</code></pre>
<hr />

@@@ Test 71
!!! text
> foo
-----
!!! expected
<blockquote>
<p>foo</p>
</blockquote>
<hr />

@@@ Test 72
!!! text
\> foo
------
!!! expected
<h2>&gt; foo</h2>

@@@ Test 73
!!! text
Foo

bar
---
baz
!!! expected
<p>Foo</p>
<h2>bar</h2>
<p>baz</p>

@@@ Test 74
!!! text
Foo
bar

---

baz
!!! expected
<p>Foo
bar</p>
<hr />
<p>baz</p>

@@@ Test 75
!!! text
Foo
bar
* * *
baz
!!! expected
<p>Foo
bar</p>
<hr />
<p>baz</p>

@@@ Test 76
!!! text
Foo
bar
\---
baz
!!! expected
<p>Foo
bar
---
baz</p>

@@@ Test 77
!!! text
    a simple
      indented code block
!!! expected
<pre><code>a simple
  indented code block
</code></pre>

@@@ Test 78
!!! text
  - foo

    bar
!!! expected
<ul>
<li>
<p>foo</p>
<p>bar</p>
</li>
</ul>

@@@ Test 79
!!! text
1.  foo

    - bar
!!! expected
<ol>
<li>
<p>foo</p>
<ul>
<li>bar</li>
</ul>
</li>
</ol>

@@@ Test 80
!!! text
    <a/>
    *hi*

    - one
!!! expected
<pre><code>&lt;a/&gt;
*hi*

- one
</code></pre>

@@@ Test 81
!!! text
    chunk1

    chunk2
  
 
 
    chunk3
!!! expected
<pre><code>chunk1

chunk2



chunk3
</code></pre>

@@@ Test 82
!!! text
    chunk1
      
      chunk2
!!! expected
<pre><code>chunk1
  
  chunk2
</code></pre>

@@@ Test 83
!!! text
Foo
    bar
!!! expected
<p>Foo
bar</p>

@@@ Test 84
!!! text
    foo
bar
!!! expected
<pre><code>foo
</code></pre>
<p>bar</p>

@@@ Test 85
!!! text
# Heading
    foo
Heading
------
    foo
----
!!! expected
<h1>Heading</h1>
<pre><code>foo
</code></pre>
<h2>Heading</h2>
<pre><code>foo
</code></pre>
<hr />

@@@ Test 86
!!! text
        foo
    bar
!!! expected
<pre><code>    foo
bar
</code></pre>

@@@ Test 87
!!! text

    
    foo
    
!!! expected
<pre><code>foo
</code></pre>

@@@ Test 88
!!! text
    foo  
!!! expected
<pre><code>foo  
</code></pre>

@@@ Test 89
!!! text
```
<
 >
```
!!! expected
<pre><code>&lt;
 &gt;
</code></pre>

@@@ Test 90
!!! text
~~~
<
 >
~~~
!!! expected
<pre><code>&lt;
 &gt;
</code></pre>

@@@ Test 91
!!! text
``
foo
``
!!! expected
<p><code>foo</code></p>

@@@ Test 92
!!! text
```
aaa
~~~
```
!!! expected
<pre><code>aaa
~~~
</code></pre>

@@@ Test 93
!!! text
~~~
aaa
```
~~~
!!! expected
<pre><code>aaa
```
</code></pre>

@@@ Test 94
!!! text
````
aaa
```
``````
!!! expected
<pre><code>aaa
```
</code></pre>

@@@ Test 95
!!! text
~~~~
aaa
~~~
~~~~
!!! expected
<pre><code>aaa
~~~
</code></pre>

@@@ Test 96
!!! text
```
!!! expected
<pre><code></code></pre>

@@@ Test 97
!!! text
`````

```
aaa
!!! expected
<pre><code>
```
aaa
</code></pre>

@@@ Test 98
!!! text
> ```
> aaa

bbb
!!! expected
<blockquote>
<pre><code>aaa
</code></pre>
</blockquote>
<p>bbb</p>

@@@ Test 99
!!! text
```

  
```
!!! expected
<pre><code>
  
</code></pre>

@@@ Test 100
!!! text
```
```
!!! expected
<pre><code></code></pre>

@@@ Test 101
!!! text
 ```
 aaa
aaa
```
!!! expected
<pre><code>aaa
aaa
</code></pre>

@@@ Test 102
!!! text
  ```
aaa
  aaa
aaa
  ```
!!! expected
<pre><code>aaa
aaa
aaa
</code></pre>

@@@ Test 103
!!! text
   ```
   aaa
    aaa
  aaa
   ```
!!! expected
<pre><code>aaa
 aaa
aaa
</code></pre>

@@@ Test 104
!!! text
    ```
    aaa
    ```
!!! expected
<pre><code>```
aaa
```
</code></pre>

@@@ Test 105
!!! text
```
aaa
  ```
!!! expected
<pre><code>aaa
</code></pre>

@@@ Test 106
!!! text
   ```
aaa
  ```
!!! expected
<pre><code>aaa
</code></pre>

@@@ Test 107
!!! text
```
aaa
    ```
!!! expected
<pre><code>aaa
    ```
</code></pre>

@@@ Test 108
!!! text
``` ```
aaa
!!! expected
<p><code> </code>
aaa</p>

@@@ Test 109
!!! text
~~~~~~
aaa
~~~ ~~
!!! expected
<pre><code>aaa
~~~ ~~
</code></pre>

@@@ Test 110
!!! text
foo
```
bar
```
baz
!!! expected
<p>foo</p>
<pre><code>bar
</code></pre>
<p>baz</p>

@@@ Test 111
!!! text
foo
---
~~~
bar
~~~
# baz
!!! expected
<h2>foo</h2>
<pre><code>bar
</code></pre>
<h1>baz</h1>

@@@ Test 112
!!! text
```ruby
def foo(x)
  return 3
end
```
!!! expected
<pre><code class="language-ruby">def foo(x)
  return 3
end
</code></pre>

@@@ Test 113
!!! text
~~~~    ruby startline=3 $%@#$
def foo(x)
  return 3
end
~~~~~~~
!!! expected
<pre><code class="language-ruby">def foo(x)
  return 3
end
</code></pre>

@@@ Test 114
!!! text
````;
````
!!! expected
<pre><code class="language-;"></code></pre>

@@@ Test 115
!!! text
``` aa ```
foo
!!! expected
<p><code>aa</code>
foo</p>

@@@ Test 116
!!! text
~~~ aa ``` ~~~
foo
~~~
!!! expected
<pre><code class="language-aa">foo
</code></pre>

@@@ Test 117
!!! text
```
``` aaa
```
!!! expected
<pre><code>``` aaa
</code></pre>

@@@ Test 118
!!! text
<table><tr><td>
<pre>
**Hello**,

_world_.
</pre>
</td></tr></table>
!!! expected
<table><tr><td>
<pre>
**Hello**,
<p><em>world</em>.
</pre></p>
</td></tr></table>

@@@ Test 119
!!! text
<table>
  <tr>
    <td>
           hi
    </td>
  </tr>
</table>

okay.
!!! expected
<table>
  <tr>
    <td>
           hi
    </td>
  </tr>
</table>
<p>okay.</p>

@@@ Test 120
!!! text
 <div>
  *hello*
         <foo><a>
!!! expected
 <div>
  *hello*
         <foo><a>

@@@ Test 121
!!! text
</div>
*foo*
!!! expected
</div>
*foo*

@@@ Test 122
!!! text
<DIV CLASS="foo">

*Markdown*

</DIV>
!!! expected
<DIV CLASS="foo">
<p><em>Markdown</em></p>
</DIV>

@@@ Test 123
!!! text
<div id="foo"
  class="bar">
</div>
!!! expected
<div id="foo"
  class="bar">
</div>

@@@ Test 124
!!! text
<div id="foo" class="bar
  baz">
</div>
!!! expected
<div id="foo" class="bar
  baz">
</div>

@@@ Test 125
!!! text
<div>
*foo*

*bar*
!!! expected
<div>
*foo*
<p><em>bar</em></p>

@@@ Test 126
!!! text
<div id="foo"
*hi*
!!! expected
<div id="foo"
*hi*

@@@ Test 127
!!! text
<div class
foo
!!! expected
<div class
foo

@@@ Test 128
!!! text
<div *???-&&&-<---
*foo*
!!! expected
<div *???-&&&-<---
*foo*

@@@ Test 129
!!! text
<div><a href="bar">*foo*</a></div>
!!! expected
<div><a href="bar">*foo*</a></div>

@@@ Test 130
!!! text
<table><tr><td>
foo
</td></tr></table>
!!! expected
<table><tr><td>
foo
</td></tr></table>

@@@ Test 131
!!! text
<div></div>
``` c
int x = 33;
```
!!! expected
<div></div>
``` c
int x = 33;
```

@@@ Test 132
!!! text
<a href="foo">
*bar*
</a>
!!! expected
<a href="foo">
*bar*
</a>

@@@ Test 133
!!! text
<Warning>
*bar*
</Warning>
!!! expected
<Warning>
*bar*
</Warning>

@@@ Test 134
!!! text
<i class="foo">
*bar*
</i>
!!! expected
<i class="foo">
*bar*
</i>

@@@ Test 135
!!! text
</ins>
*bar*
!!! expected
</ins>
*bar*

@@@ Test 136
!!! text
<del>
*foo*
</del>
!!! expected
<del>
*foo*
</del>

@@@ Test 137
!!! text
<del>

*foo*

</del>
!!! expected
<del>
<p><em>foo</em></p>
</del>

@@@ Test 138
!!! text
<del>*foo*</del>
!!! expected
<p><del><em>foo</em></del></p>

@@@ Test 139
!!! text
<pre language="haskell"><code>
import Text.HTML.TagSoup

main :: IO ()
main = print $ parseTags tags
</code></pre>
okay
!!! expected
<pre language="haskell"><code>
import Text.HTML.TagSoup

main :: IO ()
main = print $ parseTags tags
</code></pre>
<p>okay</p>

@@@ Test 140
!!! text
<script type="text/javascript">
// JavaScript example

document.getElementById("demo").innerHTML = "Hello JavaScript!";
</script>
okay
!!! expected_todo
<script type="text/javascript">
// JavaScript example

document.getElementById("demo").innerHTML = "Hello JavaScript!";
</script>
<p>okay</p>

@@@ Test 141
!!! text
<style
  type="text/css">
h1 {color:red;}

p {color:blue;}
</style>
okay
!!! expected_todo
<style
  type="text/css">
h1 {color:red;}

p {color:blue;}
</style>
<p>okay</p>

@@@ Test 142
!!! text
<style
  type="text/css">

foo
!!! expected_todo
<style
  type="text/css">

foo
!!! expected_php
<style
  type="text/css">

foo

@@@ Test 143
!!! text
> <div>
> foo

bar
!!! expected
<blockquote>
<div>
foo
</blockquote>
<p>bar</p>

@@@ Test 144
!!! text
- <div>
- foo
!!! expected
<ul>
<li>
<div>
</li>
<li>foo</li>
</ul>

@@@ Test 145
!!! text
<style>p{color:red;}</style>
*foo*
!!! expected_todo
<style>p{color:red;}</style>
<p><em>foo</em></p>

@@@ Test 146
!!! text
<!-- foo -->*bar*
*baz*
!!! expected
<!-- foo -->*bar*
<p><em>baz</em></p>

@@@ Test 147
!!! text
<script>
foo
</script>1. *bar*
!!! expected_todo
<script>
foo
</script>1. *bar*

@@@ Test 148
!!! text
<!-- Foo

bar
   baz -->
okay
!!! expected
<!-- Foo

bar
   baz -->
<p>okay</p>

@@@ Test 149
!!! text
<?php

  echo '>';

?>
okay
!!! expected
<?php

  echo '>';

?>
<p>okay</p>

@@@ Test 150
!!! text
<!DOCTYPE html>
!!! expected
<!DOCTYPE html>

@@@ Test 151
!!! text
<![CDATA[
function matchwo(a,b)
{
  if (a < b && a < 0) then {
    return 1;

  } else {

    return 0;
  }
}
]]>
okay
!!! expected
<![CDATA[
function matchwo(a,b)
{
  if (a < b && a < 0) then {
    return 1;

  } else {

    return 0;
  }
}
]]>
<p>okay</p>

@@@ Test 152
!!! text
  <!-- foo -->

    <!-- foo -->
!!! expected
  <!-- foo -->
<pre><code>&lt;!-- foo --&gt;
</code></pre>

@@@ Test 153
!!! text
  <div>

    <div>
!!! expected
  <div>
<pre><code>&lt;div&gt;
</code></pre>

@@@ Test 154
!!! text
Foo
<div>
bar
</div>
!!! expected
<p>Foo</p>
<div>
bar
</div>

@@@ Test 155
!!! text
<div>
bar
</div>
*foo*
!!! expected
<div>
bar
</div>
*foo*

@@@ Test 156
!!! text
Foo
<a href="bar">
baz
!!! expected
<p>Foo
<a href="bar">
baz</p>

@@@ Test 157
!!! text
<div>

*Emphasized* text.

</div>
!!! expected
<div>
<p><em>Emphasized</em> text.</p>
</div>

@@@ Test 158
!!! text
<div>
*Emphasized* text.
</div>
!!! expected
<div>
*Emphasized* text.
</div>

@@@ Test 159
!!! text
<table>

<tr>

<td>
Hi
</td>

</tr>

</table>
!!! expected
<table>
<tr>
<td>
Hi
</td>
</tr>
</table>

@@@ Test 160
!!! text
<table>

  <tr>

    <td>
      Hi
    </td>

  </tr>

</table>
!!! expected
<table>
  <tr>
<pre><code>&lt;td&gt;
  Hi
&lt;/td&gt;
</code></pre>
  </tr>
</table>

@@@ Test 161
!!! text
[foo]: /url "title"

[foo]
!!! expected
<p><a href="/url" title="title">foo</a></p>

@@@ Test 162
!!! text
   [foo]: 
      /url  
           'the title'  

[foo]
!!! expected
<p><a href="/url" title="the title">foo</a></p>

@@@ Test 163
!!! text
[Foo*bar\]]:my_(url) 'title (with parens)'

[Foo*bar\]]
!!! expected
<p><a href="my_(url)" title="title (with parens)">Foo*bar]</a></p>

@@@ Test 164
!!! text
[Foo bar]:
<my url>
'title'

[Foo bar]
!!! expected
<p><a href="my%20url" title="title">Foo bar</a></p>

@@@ Test 165
!!! text
[foo]: /url '
title
line1
line2
'

[foo]
!!! expected
<p><a href="/url" title="
title
line1
line2
">foo</a></p>

@@@ Test 166
!!! text
[foo]: /url 'title

with blank line'

[foo]
!!! expected
<p>[foo]: /url 'title</p>
<p>with blank line'</p>
<p>[foo]</p>

@@@ Test 167
!!! text
[foo]:
/url

[foo]
!!! expected
<p><a href="/url">foo</a></p>

@@@ Test 168
!!! text
[foo]:

[foo]
!!! expected
<p>[foo]:</p>
<p>[foo]</p>

@@@ Test 169
!!! text
[foo]: <>

[foo]
!!! expected
<p><a href="">foo</a></p>

@@@ Test 170
!!! text
[foo]: <bar>(baz)

[foo]
!!! expected
<p>[foo]: <bar>(baz)</p>
<p>[foo]</p>

@@@ Test 171
!!! text
[foo]: /url\bar\*baz "foo\"bar\baz"

[foo]
!!! expected
<p><a href="/url%5Cbar*baz" title="foo&quot;bar\baz">foo</a></p>

@@@ Test 172
!!! text
[foo]

[foo]: url
!!! expected
<p><a href="url">foo</a></p>

@@@ Test 173
!!! text
[foo]

[foo]: first
[foo]: second
!!! expected
<p><a href="first">foo</a></p>

@@@ Test 174
!!! text
[FOO]: /url

[Foo]
!!! expected
<p><a href="/url">Foo</a></p>

@@@ Test 175
!!! text
[ΑΓΩ]: /φου

[αγω]
!!! expected
<p><a href="/%CF%86%CE%BF%CF%85">αγω</a></p>

@@@ Test 176
!!! text
[foo]: /url
!!! expected

@@@ Test 177
!!! text
[
foo
]: /url
bar
!!! expected
<p>bar</p>

@@@ Test 178
!!! text
[foo]: /url "title" ok
!!! expected
<p>[foo]: /url &quot;title&quot; ok</p>

@@@ Test 179
!!! text
[foo]: /url
"title" ok
!!! expected
<p>&quot;title&quot; ok</p>

@@@ Test 180
!!! text
    [foo]: /url "title"

[foo]
!!! expected
<pre><code>[foo]: /url &quot;title&quot;
</code></pre>
<p>[foo]</p>

@@@ Test 181
!!! text
```
[foo]: /url
```

[foo]
!!! expected
<pre><code>[foo]: /url
</code></pre>
<p>[foo]</p>

@@@ Test 182
!!! text
Foo
[bar]: /baz

[bar]
!!! expected
<p>Foo
[bar]: /baz</p>
<p>[bar]</p>

@@@ Test 183
!!! text
# [Foo]
[foo]: /url
> bar
!!! expected
<h1><a href="/url">Foo</a></h1>
<blockquote>
<p>bar</p>
</blockquote>

@@@ Test 184
!!! text
[foo]: /url
bar
===
[foo]
!!! expected
<h1>bar</h1>
<p><a href="/url">foo</a></p>

@@@ Test 185
!!! text
[foo]: /url
===
[foo]
!!! expected
<p>===
<a href="/url">foo</a></p>

@@@ Test 186
!!! text
[foo]: /foo-url "foo"
[bar]: /bar-url
  "bar"
[baz]: /baz-url

[foo],
[bar],
[baz]
!!! expected
<p><a href="/foo-url" title="foo">foo</a>,
<a href="/bar-url" title="bar">bar</a>,
<a href="/baz-url">baz</a></p>

@@@ Test 187
!!! text
[foo]

> [foo]: /url
!!! expected
<p><a href="/url">foo</a></p>
<blockquote>
</blockquote>

@@@ Test 188
!!! text
[foo]: /url
!!! expected

@@@ Test 189
!!! text
aaa

bbb
!!! expected
<p>aaa</p>
<p>bbb</p>

@@@ Test 190
!!! text
aaa
bbb

ccc
ddd
!!! expected
<p>aaa
bbb</p>
<p>ccc
ddd</p>

@@@ Test 191
!!! text
aaa


bbb
!!! expected
<p>aaa</p>
<p>bbb</p>

@@@ Test 192
!!! text
  aaa
 bbb
!!! expected
<p>aaa
bbb</p>

@@@ Test 193
!!! text
aaa
             bbb
                                       ccc
!!! expected
<p>aaa
bbb
ccc</p>

@@@ Test 194
!!! text
   aaa
bbb
!!! expected
<p>aaa
bbb</p>

@@@ Test 195
!!! text
    aaa
bbb
!!! expected
<pre><code>aaa
</code></pre>
<p>bbb</p>

@@@ Test 196
!!! text
aaa     
bbb     
!!! expected
<p>aaa<br />
bbb</p>

@@@ Test 197
!!! text
  

aaa
  

# aaa

  
!!! expected
<p>aaa</p>
<h1>aaa</h1>

@@@ Test 198
!!! text
| foo | bar |
| --- | --- |
| baz | bim |
!!! expected
<table>
<thead>
<tr>
<th>foo</th>
<th>bar</th>
</tr>
</thead>
<tbody>
<tr>
<td>baz</td>
<td>bim</td>
</tr>
</tbody>
</table>

@@@ Test 199
!!! text
| abc | defghi |
:-: | -----------:
bar | baz
!!! expected
<table>
<thead>
<tr>
<th align="center">abc</th>
<th align="right">defghi</th>
</tr>
</thead>
<tbody>
<tr>
<td align="center">bar</td>
<td align="right">baz</td>
</tr>
</tbody>
</table>

@@@ Test 200
!!! text
| f\|oo  |
| ------ |
| b `\|` az |
| b **\|** im |
!!! expected
<table>
<thead>
<tr>
<th>f|oo</th>
</tr>
</thead>
<tbody>
<tr>
<td>b <code>|</code> az</td>
</tr>
<tr>
<td>b <strong>|</strong> im</td>
</tr>
</tbody>
</table>

@@@ Test 201
!!! text
| abc | def |
| --- | --- |
| bar | baz |
> bar
!!! expected
<table>
<thead>
<tr>
<th>abc</th>
<th>def</th>
</tr>
</thead>
<tbody>
<tr>
<td>bar</td>
<td>baz</td>
</tr>
</tbody>
</table>
<blockquote>
<p>bar</p>
</blockquote>

@@@ Test 202
!!! text
| abc | def |
| --- | --- |
| bar | baz |
bar

bar
!!! expected
<table>
<thead>
<tr>
<th>abc</th>
<th>def</th>
</tr>
</thead>
<tbody>
<tr>
<td>bar</td>
<td>baz</td>
</tr>
<tr>
<td>bar</td>
<td></td>
</tr>
</tbody>
</table>
<p>bar</p>

@@@ Test 203
!!! text
| abc | def |
| --- |
| bar |
!!! expected
<p>| abc | def |
| --- |
| bar |</p>

@@@ Test 204
!!! text
| abc | def |
| --- | --- |
| bar |
| bar | baz | boo |
!!! expected
<table>
<thead>
<tr>
<th>abc</th>
<th>def</th>
</tr>
</thead>
<tbody>
<tr>
<td>bar</td>
<td></td>
</tr>
<tr>
<td>bar</td>
<td>baz</td>
</tr>
</tbody>
</table>

@@@ Test 205
!!! text
| abc | def |
| --- | --- |
!!! expected
<table>
<thead>
<tr>
<th>abc</th>
<th>def</th>
</tr>
</thead>
</table>

@@@ Test 206
!!! text
> # Foo
> bar
> baz
!!! expected
<blockquote>
<h1>Foo</h1>
<p>bar
baz</p>
</blockquote>

@@@ Test 207
!!! text
># Foo
>bar
> baz
!!! expected
<blockquote>
<h1>Foo</h1>
<p>bar
baz</p>
</blockquote>

@@@ Test 208
!!! text
   > # Foo
   > bar
 > baz
!!! expected
<blockquote>
<h1>Foo</h1>
<p>bar
baz</p>
</blockquote>

@@@ Test 209
!!! text
    > # Foo
    > bar
    > baz
!!! expected
<pre><code>&gt; # Foo
&gt; bar
&gt; baz
</code></pre>

@@@ Test 210
!!! text
> # Foo
> bar
baz
!!! expected
<blockquote>
<h1>Foo</h1>
<p>bar
baz</p>
</blockquote>

@@@ Test 211
!!! text
> bar
baz
> foo
!!! expected
<blockquote>
<p>bar
baz
foo</p>
</blockquote>

@@@ Test 212
!!! text
> foo
---
!!! expected
<blockquote>
<p>foo</p>
</blockquote>
<hr />

@@@ Test 213
!!! text
> - foo
- bar
!!! expected
<blockquote>
<ul>
<li>foo</li>
</ul>
</blockquote>
<ul>
<li>bar</li>
</ul>

@@@ Test 214
!!! text
>     foo
    bar
!!! expected
<blockquote>
<pre><code>foo
</code></pre>
</blockquote>
<pre><code>bar
</code></pre>

@@@ Test 215
!!! text
> ```
foo
```
!!! expected
<blockquote>
<pre><code></code></pre>
</blockquote>
<p>foo</p>
<pre><code></code></pre>

@@@ Test 216
!!! text
> foo
    - bar
!!! expected
<blockquote>
<p>foo
- bar</p>
</blockquote>

@@@ Test 217
!!! text
>
!!! expected
<blockquote>
</blockquote>

@@@ Test 218
!!! text
>
>  
> 
!!! expected
<blockquote>
</blockquote>

@@@ Test 219
!!! text
>
> foo
>  
!!! expected
<blockquote>
<p>foo</p>
</blockquote>

@@@ Test 220
!!! text
> foo

> bar
!!! expected
<blockquote>
<p>foo</p>
</blockquote>
<blockquote>
<p>bar</p>
</blockquote>

@@@ Test 221
!!! text
> foo
> bar
!!! expected
<blockquote>
<p>foo
bar</p>
</blockquote>

@@@ Test 222
!!! text
> foo
>
> bar
!!! expected
<blockquote>
<p>foo</p>
<p>bar</p>
</blockquote>

@@@ Test 223
!!! text
foo
> bar
!!! expected
<p>foo</p>
<blockquote>
<p>bar</p>
</blockquote>

@@@ Test 224
!!! text
> aaa
***
> bbb
!!! expected
<blockquote>
<p>aaa</p>
</blockquote>
<hr />
<blockquote>
<p>bbb</p>
</blockquote>

@@@ Test 225
!!! text
> bar
baz
!!! expected
<blockquote>
<p>bar
baz</p>
</blockquote>

@@@ Test 226
!!! text
> bar

baz
!!! expected
<blockquote>
<p>bar</p>
</blockquote>
<p>baz</p>

@@@ Test 227
!!! text
> bar
>
baz
!!! expected
<blockquote>
<p>bar</p>
</blockquote>
<p>baz</p>

@@@ Test 228
!!! text
> > > foo
bar
!!! expected
<blockquote>
<blockquote>
<blockquote>
<p>foo
bar</p>
</blockquote>
</blockquote>
</blockquote>

@@@ Test 229
!!! text
>>> foo
> bar
>>baz
!!! expected
<blockquote>
<blockquote>
<blockquote>
<p>foo
bar
baz</p>
</blockquote>
</blockquote>
</blockquote>

@@@ Test 230
!!! text
>     code

>    not code
!!! expected
<blockquote>
<pre><code>code
</code></pre>
</blockquote>
<blockquote>
<p>not code</p>
</blockquote>

@@@ Test 231
!!! text
A paragraph
with two lines.

    indented code

> A block quote.
!!! expected
<p>A paragraph
with two lines.</p>
<pre><code>indented code
</code></pre>
<blockquote>
<p>A block quote.</p>
</blockquote>

@@@ Test 232
!!! text
1.  A paragraph
    with two lines.

        indented code

    > A block quote.
!!! expected
<ol>
<li>
<p>A paragraph
with two lines.</p>
<pre><code>indented code
</code></pre>
<blockquote>
<p>A block quote.</p>
</blockquote>
</li>
</ol>

@@@ Test 233
!!! text
- one

 two
!!! expected
<ul>
<li>one</li>
</ul>
<p>two</p>

@@@ Test 234
!!! text
- one

  two
!!! expected
<ul>
<li>
<p>one</p>
<p>two</p>
</li>
</ul>

@@@ Test 235
!!! text
 -    one

     two
!!! expected
<ul>
<li>one</li>
</ul>
<pre><code> two
</code></pre>

@@@ Test 236
!!! text
 -    one

      two
!!! expected
<ul>
<li>
<p>one</p>
<p>two</p>
</li>
</ul>

@@@ Test 237
!!! text
   > > 1.  one
>>
>>     two
!!! expected
<blockquote>
<blockquote>
<ol>
<li>
<p>one</p>
<p>two</p>
</li>
</ol>
</blockquote>
</blockquote>

@@@ Test 238
!!! text
>>- one
>>
  >  > two
!!! expected
<blockquote>
<blockquote>
<ul>
<li>one</li>
</ul>
<p>two</p>
</blockquote>
</blockquote>

@@@ Test 239
!!! text
-one

2.two
!!! expected
<p>-one</p>
<p>2.two</p>

@@@ Test 240
!!! text
- foo


  bar
!!! expected
<ul>
<li>
<p>foo</p>
<p>bar</p>
</li>
</ul>

@@@ Test 241
!!! text
1.  foo

    ```
    bar
    ```

    baz

    > bam
!!! expected
<ol>
<li>
<p>foo</p>
<pre><code>bar
</code></pre>
<p>baz</p>
<blockquote>
<p>bam</p>
</blockquote>
</li>
</ol>

@@@ Test 242
!!! text
- Foo

      bar


      baz
!!! expected
<ul>
<li>
<p>Foo</p>
<pre><code>bar


baz
</code></pre>
</li>
</ul>

@@@ Test 243
!!! text
123456789. ok
!!! expected
<ol start="123456789">
<li>ok</li>
</ol>

@@@ Test 244
!!! text
1234567890. not ok
!!! expected
<p>1234567890. not ok</p>

@@@ Test 245
!!! text
0. ok
!!! expected
<ol start="0">
<li>ok</li>
</ol>

@@@ Test 246
!!! text
003. ok
!!! expected
<ol start="3">
<li>ok</li>
</ol>

@@@ Test 247
!!! text
-1. not ok
!!! expected
<p>-1. not ok</p>

@@@ Test 248
!!! text
- foo

      bar
!!! expected
<ul>
<li>
<p>foo</p>
<pre><code>bar
</code></pre>
</li>
</ul>

@@@ Test 249
!!! text
  10.  foo

           bar
!!! expected
<ol start="10">
<li>
<p>foo</p>
<pre><code>bar
</code></pre>
</li>
</ol>

@@@ Test 250
!!! text
    indented code

paragraph

    more code
!!! expected
<pre><code>indented code
</code></pre>
<p>paragraph</p>
<pre><code>more code
</code></pre>

@@@ Test 251
!!! text
1.     indented code

   paragraph

       more code
!!! expected
<ol>
<li>
<pre><code>indented code
</code></pre>
<p>paragraph</p>
<pre><code>more code
</code></pre>
</li>
</ol>

@@@ Test 252
!!! text
1.      indented code

   paragraph

       more code
!!! expected
<ol>
<li>
<pre><code> indented code
</code></pre>
<p>paragraph</p>
<pre><code>more code
</code></pre>
</li>
</ol>

@@@ Test 253
!!! text
   foo

bar
!!! expected
<p>foo</p>
<p>bar</p>

@@@ Test 254
!!! text
-    foo

  bar
!!! expected
<ul>
<li>foo</li>
</ul>
<p>bar</p>

@@@ Test 255
!!! text
-  foo

   bar
!!! expected
<ul>
<li>
<p>foo</p>
<p>bar</p>
</li>
</ul>

@@@ Test 256
!!! text
-
  foo
-
  ```
  bar
  ```
-
      baz
!!! expected
<ul>
<li>foo</li>
<li>
<pre><code>bar
</code></pre>
</li>
<li>
<pre><code>baz
</code></pre>
</li>
</ul>

@@@ Test 257
!!! text
-   
  foo
!!! expected
<ul>
<li>foo</li>
</ul>

@@@ Test 258
!!! text
-

  foo
!!! expected
<ul>
<li></li>
</ul>
<p>foo</p>

@@@ Test 259
!!! text
- foo
-
- bar
!!! expected
<ul>
<li>foo</li>
<li></li>
<li>bar</li>
</ul>

@@@ Test 260
!!! text
- foo
-   
- bar
!!! expected
<ul>
<li>foo</li>
<li></li>
<li>bar</li>
</ul>

@@@ Test 261
!!! text
1. foo
2.
3. bar
!!! expected
<ol>
<li>foo</li>
<li></li>
<li>bar</li>
</ol>

@@@ Test 262
!!! text
*
!!! expected
<ul>
<li></li>
</ul>

@@@ Test 263
!!! text
foo
*

foo
1.
!!! expected
<p>foo
*</p>
<p>foo
1.</p>

@@@ Test 264
!!! text
 1.  A paragraph
     with two lines.

         indented code

     > A block quote.
!!! expected
<ol>
<li>
<p>A paragraph
with two lines.</p>
<pre><code>indented code
</code></pre>
<blockquote>
<p>A block quote.</p>
</blockquote>
</li>
</ol>

@@@ Test 265
!!! text
  1.  A paragraph
      with two lines.

          indented code

      > A block quote.
!!! expected
<ol>
<li>
<p>A paragraph
with two lines.</p>
<pre><code>indented code
</code></pre>
<blockquote>
<p>A block quote.</p>
</blockquote>
</li>
</ol>

@@@ Test 266
!!! text
   1.  A paragraph
       with two lines.

           indented code

       > A block quote.
!!! expected
<ol>
<li>
<p>A paragraph
with two lines.</p>
<pre><code>indented code
</code></pre>
<blockquote>
<p>A block quote.</p>
</blockquote>
</li>
</ol>

@@@ Test 267
!!! text
    1.  A paragraph
        with two lines.

            indented code

        > A block quote.
!!! expected
<pre><code>1.  A paragraph
    with two lines.

        indented code

    &gt; A block quote.
</code></pre>

@@@ Test 268
!!! text
  1.  A paragraph
with two lines.

          indented code

      > A block quote.
!!! expected
<ol>
<li>
<p>A paragraph
with two lines.</p>
<pre><code>indented code
</code></pre>
<blockquote>
<p>A block quote.</p>
</blockquote>
</li>
</ol>

@@@ Test 269
!!! text
  1.  A paragraph
    with two lines.
!!! expected
<ol>
<li>A paragraph
with two lines.</li>
</ol>

@@@ Test 270
!!! text
> 1. > Blockquote
continued here.
!!! expected
<blockquote>
<ol>
<li>
<blockquote>
<p>Blockquote
continued here.</p>
</blockquote>
</li>
</ol>
</blockquote>

@@@ Test 271
!!! text
> 1. > Blockquote
> continued here.
!!! expected
<blockquote>
<ol>
<li>
<blockquote>
<p>Blockquote
continued here.</p>
</blockquote>
</li>
</ol>
</blockquote>

@@@ Test 272
!!! text
- foo
  - bar
    - baz
      - boo
!!! expected
<ul>
<li>foo
<ul>
<li>bar
<ul>
<li>baz
<ul>
<li>boo</li>
</ul>
</li>
</ul>
</li>
</ul>
</li>
</ul>

@@@ Test 273
!!! text
- foo
 - bar
  - baz
   - boo
!!! expected
<ul>
<li>foo</li>
<li>bar</li>
<li>baz</li>
<li>boo</li>
</ul>

@@@ Test 274
!!! text
10) foo
    - bar
!!! expected
<ol start="10">
<li>foo
<ul>
<li>bar</li>
</ul>
</li>
</ol>

@@@ Test 275
!!! text
10) foo
   - bar
!!! expected
<ol start="10">
<li>foo</li>
</ol>
<ul>
<li>bar</li>
</ul>

@@@ Test 276
!!! text
- - foo
!!! expected
<ul>
<li>
<ul>
<li>foo</li>
</ul>
</li>
</ul>

@@@ Test 277
!!! text
1. - 2. foo
!!! expected
<ol>
<li>
<ul>
<li>
<ol start="2">
<li>foo</li>
</ol>
</li>
</ul>
</li>
</ol>

@@@ Test 278
!!! text
- # Foo
- Bar
  ---
  baz
!!! expected
<ul>
<li>
<h1>Foo</h1>
</li>
<li>
<h2>Bar</h2>
baz</li>
</ul>

@@@ Test 279
!!! text
- [ ] foo
- [x] bar
!!! expected
<ul>
<li><input disabled="" type="checkbox"> foo</li>
<li><input checked="" disabled="" type="checkbox"> bar</li>
</ul>

@@@ Test 280
!!! text
- [x] foo
  - [ ] bar
  - [x] baz
- [ ] bim
!!! expected
<ul>
<li><input checked="" disabled="" type="checkbox"> foo
<ul>
<li><input disabled="" type="checkbox"> bar</li>
<li><input checked="" disabled="" type="checkbox"> baz</li>
</ul>
</li>
<li><input disabled="" type="checkbox"> bim</li>
</ul>

@@@ Test 281
!!! text
- foo
- bar
+ baz
!!! expected
<ul>
<li>foo</li>
<li>bar</li>
</ul>
<ul>
<li>baz</li>
</ul>

@@@ Test 282
!!! text
1. foo
2. bar
3) baz
!!! expected
<ol>
<li>foo</li>
<li>bar</li>
</ol>
<ol start="3">
<li>baz</li>
</ol>

@@@ Test 283
!!! text
Foo
- bar
- baz
!!! expected
<p>Foo</p>
<ul>
<li>bar</li>
<li>baz</li>
</ul>

@@@ Test 284
!!! text
The number of windows in my house is
14.  The number of doors is 6.
!!! expected
<p>The number of windows in my house is
14.  The number of doors is 6.</p>

@@@ Test 285
!!! text
The number of windows in my house is
1.  The number of doors is 6.
!!! expected
<p>The number of windows in my house is</p>
<ol>
<li>The number of doors is 6.</li>
</ol>

@@@ Test 286
!!! text
- foo

- bar


- baz
!!! expected
<ul>
<li>
<p>foo</p>
</li>
<li>
<p>bar</p>
</li>
<li>
<p>baz</p>
</li>
</ul>

@@@ Test 287
!!! text
- foo
  - bar
    - baz


      bim
!!! expected
<ul>
<li>foo
<ul>
<li>bar
<ul>
<li>
<p>baz</p>
<p>bim</p>
</li>
</ul>
</li>
</ul>
</li>
</ul>

@@@ Test 288
!!! text
- foo
- bar

<!-- -->

- baz
- bim
!!! expected
<ul>
<li>foo</li>
<li>bar</li>
</ul>
<!-- -->
<ul>
<li>baz</li>
<li>bim</li>
</ul>

@@@ Test 289
!!! text
-   foo

    notcode

-   foo

<!-- -->

    code
!!! expected
<ul>
<li>
<p>foo</p>
<p>notcode</p>
</li>
<li>
<p>foo</p>
</li>
</ul>
<!-- -->
<pre><code>code
</code></pre>

@@@ Test 290
!!! text
- a
 - b
  - c
   - d
  - e
 - f
- g
!!! expected
<ul>
<li>a</li>
<li>b</li>
<li>c</li>
<li>d</li>
<li>e</li>
<li>f</li>
<li>g</li>
</ul>

@@@ Test 291
!!! text
1. a

  2. b

   3. c
!!! expected
<ol>
<li>
<p>a</p>
</li>
<li>
<p>b</p>
</li>
<li>
<p>c</p>
</li>
</ol>

@@@ Test 292
!!! text
- a
 - b
  - c
   - d
    - e
!!! expected
<ul>
<li>a</li>
<li>b</li>
<li>c</li>
<li>d
- e</li>
</ul>

@@@ Test 293
!!! text
1. a

  2. b

    3. c
!!! expected
<ol>
<li>
<p>a</p>
</li>
<li>
<p>b</p>
</li>
</ol>
<pre><code>3. c
</code></pre>

@@@ Test 294
!!! text
- a
- b

- c
!!! expected
<ul>
<li>
<p>a</p>
</li>
<li>
<p>b</p>
</li>
<li>
<p>c</p>
</li>
</ul>

@@@ Test 295
!!! text
* a
*

* c
!!! expected
<ul>
<li>
<p>a</p>
</li>
<li></li>
<li>
<p>c</p>
</li>
</ul>

@@@ Test 296
!!! text
- a
- b

  c
- d
!!! expected
<ul>
<li>
<p>a</p>
</li>
<li>
<p>b</p>
<p>c</p>
</li>
<li>
<p>d</p>
</li>
</ul>

@@@ Test 297
!!! text
- a
- b

  [ref]: /url
- d
!!! expected
<ul>
<li>
<p>a</p>
</li>
<li>
<p>b</p>
</li>
<li>
<p>d</p>
</li>
</ul>

@@@ Test 298
!!! text
- a
- ```
  b


  ```
- c
!!! expected
<ul>
<li>a</li>
<li>
<pre><code>b


</code></pre>
</li>
<li>c</li>
</ul>

@@@ Test 299
!!! text
- a
  - b

    c
- d
!!! expected
<ul>
<li>a
<ul>
<li>
<p>b</p>
<p>c</p>
</li>
</ul>
</li>
<li>d</li>
</ul>

@@@ Test 300
!!! text
* a
  > b
  >
* c
!!! expected
<ul>
<li>a
<blockquote>
<p>b</p>
</blockquote>
</li>
<li>c</li>
</ul>

@@@ Test 301
!!! text
- a
  > b
  ```
  c
  ```
- d
!!! expected
<ul>
<li>a
<blockquote>
<p>b</p>
</blockquote>
<pre><code>c
</code></pre>
</li>
<li>d</li>
</ul>

@@@ Test 302
!!! text
- a
!!! expected
<ul>
<li>a</li>
</ul>

@@@ Test 303
!!! text
- a
  - b
!!! expected
<ul>
<li>a
<ul>
<li>b</li>
</ul>
</li>
</ul>

@@@ Test 304
!!! text
1. ```
   foo
   ```

   bar
!!! expected
<ol>
<li>
<pre><code>foo
</code></pre>
<p>bar</p>
</li>
</ol>

@@@ Test 305
!!! text
* foo
  * bar

  baz
!!! expected
<ul>
<li>
<p>foo</p>
<ul>
<li>bar</li>
</ul>
<p>baz</p>
</li>
</ul>

@@@ Test 306
!!! text
- a
  - b
  - c

- d
  - e
  - f
!!! expected
<ul>
<li>
<p>a</p>
<ul>
<li>b</li>
<li>c</li>
</ul>
</li>
<li>
<p>d</p>
<ul>
<li>e</li>
<li>f</li>
</ul>
</li>
</ul>

@@@ Test 307
!!! text
`hi`lo`
!!! expected
<p><code>hi</code>lo`</p>

@@@ Test 308
!!! text
\!\"\#\$\%\&\'\(\)\*\+\,\-\.\/\:\;\<\=\>\?\@\[\\\]\^\_\`\{\|\}\~
!!! expected
<p>!&quot;#$%&amp;'()*+,-./:;&lt;=&gt;?@[\]^_`{|}~</p>

@@@ Test 309
!!! text
\	\A\a\ \3\φ\«
!!! expected
<p>\	\A\a\ \3\φ\«</p>

@@@ Test 310
!!! text
\*not emphasized*
\<br/> not a tag
\[not a link](/foo)
\`not code`
1\. not a list
\* not a list
\# not a heading
\[foo]: /url "not a reference"
\&ouml; not a character entity
!!! expected
<p>*not emphasized*
&lt;br/&gt; not a tag
[not a link](/foo)
`not code`
1. not a list
* not a list
# not a heading
[foo]: /url &quot;not a reference&quot;
&amp;ouml; not a character entity</p>

@@@ Test 311
!!! text
\\*emphasis*
!!! expected
<p>\<em>emphasis</em></p>

@@@ Test 312
!!! text
foo\
bar
!!! expected
<p>foo<br />
bar</p>

@@@ Test 313
!!! text
`` \[\` ``
!!! expected
<p><code>\[\`</code></p>

@@@ Test 314
!!! text
    \[\]
!!! expected
<pre><code>\[\]
</code></pre>

@@@ Test 315
!!! text
~~~
\[\]
~~~
!!! expected
<pre><code>\[\]
</code></pre>

@@@ Test 316
!!! text
<http://example.com?find=\*>
!!! expected
<p><a href="http://example.com?find=%5C*">http://example.com?find=\*</a></p>

@@@ Test 317
!!! text
<a href="/bar\/)">
!!! expected
<a href="/bar\/)">

@@@ Test 318
!!! text
[foo](/bar\* "ti\*tle")
!!! expected
<p><a href="/bar*" title="ti*tle">foo</a></p>

@@@ Test 319
!!! text
[foo]

[foo]: /bar\* "ti\*tle"
!!! expected
<p><a href="/bar*" title="ti*tle">foo</a></p>

@@@ Test 320
!!! text
``` foo\+bar
foo
```
!!! expected
<pre><code class="language-foo+bar">foo
</code></pre>

@@@ Test 321
!!! text
&nbsp; &amp; &copy; &AElig; &Dcaron;
&frac34; &HilbertSpace; &DifferentialD;
&ClockwiseContourIntegral; &ngE;
!!! expected
<p>  &amp; © Æ Ď
¾ ℋ ⅆ
∲ ≧̸</p>

@@@ Test 322
!!! text
&#35; &#1234; &#992; &#0;
!!! expected
<p># Ӓ Ϡ �</p>

@@@ Test 323
!!! text
&#X22; &#XD06; &#xcab;
!!! expected
<p>&quot; ആ ಫ</p>

@@@ Test 324
!!! text
&nbsp &x; &#; &#x;
&#87654321;
&#abcdef0;
&ThisIsNotDefined; &hi?;
!!! expected
<p>&amp;nbsp &amp;x; &amp;#; &amp;#x;
&amp;#87654321;
&amp;#abcdef0;
&amp;ThisIsNotDefined; &amp;hi?;</p>

@@@ Test 325
!!! text
&copy
!!! expected
<p>&amp;copy</p>

@@@ Test 326
!!! text
&MadeUpEntity;
!!! expected
<p>&amp;MadeUpEntity;</p>

@@@ Test 327
!!! text
<a href="&ouml;&ouml;.html">
!!! expected
<a href="&ouml;&ouml;.html">

@@@ Test 328
!!! text
[foo](/f&ouml;&ouml; "f&ouml;&ouml;")
!!! expected
<p><a href="/f%C3%B6%C3%B6" title="föö">foo</a></p>

@@@ Test 329
!!! text
[foo]

[foo]: /f&ouml;&ouml; "f&ouml;&ouml;"
!!! expected
<p><a href="/f%C3%B6%C3%B6" title="föö">foo</a></p>

@@@ Test 330
!!! text
``` f&ouml;&ouml;
foo
```
!!! expected
<pre><code class="language-föö">foo
</code></pre>

@@@ Test 331
!!! text
`f&ouml;&ouml;`
!!! expected
<p><code>f&amp;ouml;&amp;ouml;</code></p>

@@@ Test 332
!!! text
    f&ouml;f&ouml;
!!! expected
<pre><code>f&amp;ouml;f&amp;ouml;
</code></pre>

@@@ Test 333
!!! text
&#42;foo&#42;
*foo*
!!! expected
<p>*foo*
<em>foo</em></p>

@@@ Test 334
!!! text
&#42; foo

* foo
!!! expected
<p>* foo</p>
<ul>
<li>foo</li>
</ul>

@@@ Test 335
!!! text
foo&#10;&#10;bar
!!! expected
<p>foo

bar</p>

@@@ Test 336
!!! text
&#9;foo
!!! expected
<p>	foo</p>

@@@ Test 337
!!! text
[a](url &quot;tit&quot;)
!!! expected
<p>[a](url &quot;tit&quot;)</p>

@@@ Test 338
!!! text
`foo`
!!! expected
<p><code>foo</code></p>

@@@ Test 339
!!! text
`` foo ` bar ``
!!! expected
<p><code>foo ` bar</code></p>

@@@ Test 340
!!! text
` `` `
!!! expected
<p><code>``</code></p>

@@@ Test 341
!!! text
`  ``  `
!!! expected
<p><code> `` </code></p>

@@@ Test 342
!!! text
` a`
!!! expected
<p><code> a</code></p>

@@@ Test 343
!!! text
` b `
!!! expected
<p><code> b </code></p>

@@@ Test 344
!!! text
` `
`  `
!!! expected
<p><code> </code>
<code>  </code></p>

@@@ Test 345
!!! text
``
foo
bar  
baz
``
!!! expected
<p><code>foo bar   baz</code></p>

@@@ Test 346
!!! text
``
foo 
``
!!! expected
<p><code>foo </code></p>

@@@ Test 347
!!! text
`foo   bar 
baz`
!!! expected
<p><code>foo   bar  baz</code></p>

@@@ Test 348
!!! text
`foo\`bar`
!!! expected
<p><code>foo\</code>bar`</p>

@@@ Test 349
!!! text
``foo`bar``
!!! expected
<p><code>foo`bar</code></p>

@@@ Test 350
!!! text
` foo `` bar `
!!! expected
<p><code>foo `` bar</code></p>

@@@ Test 351
!!! text
*foo`*`
!!! expected
<p>*foo<code>*</code></p>

@@@ Test 352
!!! text
[not a `link](/foo`)
!!! expected
<p>[not a <code>link](/foo</code>)</p>

@@@ Test 353
!!! text
`<a href="`">`
!!! expected
<p><code>&lt;a href=&quot;</code>&quot;&gt;`</p>

@@@ Test 354
!!! text
<a href="`">`
!!! expected
<p><a href="`">`</p>

@@@ Test 355
!!! text
`<http://foo.bar.`baz>`
!!! expected
<p><code>&lt;http://foo.bar.</code>baz&gt;`</p>

@@@ Test 356
!!! text
<http://foo.bar.`baz>`
!!! expected
<p><a href="http://foo.bar.%60baz">http://foo.bar.`baz</a>`</p>

@@@ Test 357
!!! text
```foo``
!!! expected
<p>```foo``</p>

@@@ Test 358
!!! text
`foo
!!! expected
<p>`foo</p>

@@@ Test 359
!!! text
`foo``bar``
!!! expected
<p>`foo<code>bar</code></p>

@@@ Test 360
!!! text
*foo bar*
!!! expected
<p><em>foo bar</em></p>

@@@ Test 361
!!! text
a * foo bar*
!!! expected
<p>a * foo bar*</p>

@@@ Test 362
!!! text
a*"foo"*
!!! expected
<p>a*&quot;foo&quot;*</p>

@@@ Test 363
!!! text
* a *
!!! expected
<p>* a *</p>

@@@ Test 364
!!! text
foo*bar*
!!! expected
<p>foo<em>bar</em></p>

@@@ Test 365
!!! text
5*6*78
!!! expected
<p>5<em>6</em>78</p>

@@@ Test 366
!!! text
_foo bar_
!!! expected
<p><em>foo bar</em></p>

@@@ Test 367
!!! text
_ foo bar_
!!! expected
<p>_ foo bar_</p>

@@@ Test 368
!!! text
a_"foo"_
!!! expected
<p>a_&quot;foo&quot;_</p>

@@@ Test 369
!!! text
foo_bar_
!!! expected
<p>foo_bar_</p>

@@@ Test 370
!!! text
5_6_78
!!! expected
<p>5_6_78</p>

@@@ Test 371
!!! text
пристаням_стремятся_
!!! expected
<p>пристаням_стремятся_</p>

@@@ Test 372
!!! text
aa_"bb"_cc
!!! expected
<p>aa_&quot;bb&quot;_cc</p>

@@@ Test 373
!!! text
foo-_(bar)_
!!! expected
<p>foo-<em>(bar)</em></p>

@@@ Test 374
!!! text
_foo*
!!! expected
<p>_foo*</p>

@@@ Test 375
!!! text
*foo bar *
!!! expected
<p>*foo bar *</p>

@@@ Test 376
!!! text
*foo bar
*
!!! expected
<p>*foo bar
*</p>

@@@ Test 377
!!! text
*(*foo)
!!! expected
<p>*(*foo)</p>

@@@ Test 378
!!! text
*(*foo*)*
!!! expected
<p><em>(<em>foo</em>)</em></p>

@@@ Test 379
!!! text
*foo*bar
!!! expected
<p><em>foo</em>bar</p>

@@@ Test 380
!!! text
_foo bar _
!!! expected
<p>_foo bar _</p>

@@@ Test 381
!!! text
_(_foo)
!!! expected
<p>_(_foo)</p>

@@@ Test 382
!!! text
_(_foo_)_
!!! expected
<p><em>(<em>foo</em>)</em></p>

@@@ Test 383
!!! text
_foo_bar
!!! expected
<p>_foo_bar</p>

@@@ Test 384
!!! text
_пристаням_стремятся
!!! expected
<p>_пристаням_стремятся</p>

@@@ Test 385
!!! text
_foo_bar_baz_
!!! expected
<p><em>foo_bar_baz</em></p>

@@@ Test 386
!!! text
_(bar)_.
!!! expected
<p><em>(bar)</em>.</p>

@@@ Test 387
!!! text
**foo bar**
!!! expected
<p><strong>foo bar</strong></p>

@@@ Test 388
!!! text
** foo bar**
!!! expected
<p>** foo bar**</p>

@@@ Test 389
!!! text
a**"foo"**
!!! expected
<p>a**&quot;foo&quot;**</p>

@@@ Test 390
!!! text
foo**bar**
!!! expected
<p>foo<strong>bar</strong></p>

@@@ Test 391
!!! text
__foo bar__
!!! expected
<p><strong>foo bar</strong></p>

@@@ Test 392
!!! text
__ foo bar__
!!! expected
<p>__ foo bar__</p>

@@@ Test 393
!!! text
__
foo bar__
!!! expected
<p>__
foo bar__</p>

@@@ Test 394
!!! text
a__"foo"__
!!! expected
<p>a__&quot;foo&quot;__</p>

@@@ Test 395
!!! text
foo__bar__
!!! expected
<p>foo__bar__</p>

@@@ Test 396
!!! text
5__6__78
!!! expected
<p>5__6__78</p>

@@@ Test 397
!!! text
пристаням__стремятся__
!!! expected
<p>пристаням__стремятся__</p>

@@@ Test 398
!!! text
__foo, __bar__, baz__
!!! expected
<p><strong>foo, <strong>bar</strong>, baz</strong></p>

@@@ Test 399
!!! text
foo-__(bar)__
!!! expected
<p>foo-<strong>(bar)</strong></p>

@@@ Test 400
!!! text
**foo bar **
!!! expected
<p>**foo bar **</p>

@@@ Test 401
!!! text
**(**foo)
!!! expected
<p>**(**foo)</p>

@@@ Test 402
!!! text
*(**foo**)*
!!! expected
<p><em>(<strong>foo</strong>)</em></p>

@@@ Test 403
!!! text
**Gomphocarpus (*Gomphocarpus physocarpus*, syn.
*Asclepias physocarpa*)**
!!! expected
<p><strong>Gomphocarpus (<em>Gomphocarpus physocarpus</em>, syn.
<em>Asclepias physocarpa</em>)</strong></p>

@@@ Test 404
!!! text
**foo "*bar*" foo**
!!! expected
<p><strong>foo &quot;<em>bar</em>&quot; foo</strong></p>

@@@ Test 405
!!! text
**foo**bar
!!! expected
<p><strong>foo</strong>bar</p>

@@@ Test 406
!!! text
__foo bar __
!!! expected
<p>__foo bar __</p>

@@@ Test 407
!!! text
__(__foo)
!!! expected
<p>__(__foo)</p>

@@@ Test 408
!!! text
_(__foo__)_
!!! expected
<p><em>(<strong>foo</strong>)</em></p>

@@@ Test 409
!!! text
__foo__bar
!!! expected
<p>__foo__bar</p>

@@@ Test 410
!!! text
__пристаням__стремятся
!!! expected
<p>__пристаням__стремятся</p>

@@@ Test 411
!!! text
__foo__bar__baz__
!!! expected
<p><strong>foo__bar__baz</strong></p>

@@@ Test 412
!!! text
__(bar)__.
!!! expected
<p><strong>(bar)</strong>.</p>

@@@ Test 413
!!! text
*foo [bar](/url)*
!!! expected
<p><em>foo <a href="/url">bar</a></em></p>

@@@ Test 414
!!! text
*foo
bar*
!!! expected
<p><em>foo
bar</em></p>

@@@ Test 415
!!! text
_foo __bar__ baz_
!!! expected
<p><em>foo <strong>bar</strong> baz</em></p>

@@@ Test 416
!!! text
_foo _bar_ baz_
!!! expected
<p><em>foo <em>bar</em> baz</em></p>

@@@ Test 417
!!! text
__foo_ bar_
!!! expected
<p><em><em>foo</em> bar</em></p>

@@@ Test 418
!!! text
*foo *bar**
!!! expected
<p><em>foo <em>bar</em></em></p>

@@@ Test 419
!!! text
*foo **bar** baz*
!!! expected
<p><em>foo <strong>bar</strong> baz</em></p>

@@@ Test 420
!!! text
*foo**bar**baz*
!!! expected
<p><em>foo<strong>bar</strong>baz</em></p>

@@@ Test 421
!!! text
*foo**bar*
!!! expected
<p><em>foo**bar</em></p>

@@@ Test 422
!!! text
***foo** bar*
!!! expected
<p><em><strong>foo</strong> bar</em></p>

@@@ Test 423
!!! text
*foo **bar***
!!! expected
<p><em>foo <strong>bar</strong></em></p>

@@@ Test 424
!!! text
*foo**bar***
!!! expected
<p><em>foo<strong>bar</strong></em></p>

@@@ Test 425
!!! text
foo***bar***baz
!!! expected
<p>foo<em><strong>bar</strong></em>baz</p>

@@@ Test 426
!!! text
foo******bar*********baz
!!! expected
<p>foo<strong><strong><strong>bar</strong></strong></strong>***baz</p>

@@@ Test 427
!!! text
*foo **bar *baz* bim** bop*
!!! expected
<p><em>foo <strong>bar <em>baz</em> bim</strong> bop</em></p>

@@@ Test 428
!!! text
*foo [*bar*](/url)*
!!! expected
<p><em>foo <a href="/url"><em>bar</em></a></em></p>

@@@ Test 429
!!! text
** is not an empty emphasis
!!! expected
<p>** is not an empty emphasis</p>

@@@ Test 430
!!! text
**** is not an empty strong emphasis
!!! expected
<p>**** is not an empty strong emphasis</p>

@@@ Test 431
!!! text
**foo [bar](/url)**
!!! expected
<p><strong>foo <a href="/url">bar</a></strong></p>

@@@ Test 432
!!! text
**foo
bar**
!!! expected
<p><strong>foo
bar</strong></p>

@@@ Test 433
!!! text
__foo _bar_ baz__
!!! expected
<p><strong>foo <em>bar</em> baz</strong></p>

@@@ Test 434
!!! text
__foo __bar__ baz__
!!! expected
<p><strong>foo <strong>bar</strong> baz</strong></p>

@@@ Test 435
!!! text
____foo__ bar__
!!! expected
<p><strong><strong>foo</strong> bar</strong></p>

@@@ Test 436
!!! text
**foo **bar****
!!! expected
<p><strong>foo <strong>bar</strong></strong></p>

@@@ Test 437
!!! text
**foo *bar* baz**
!!! expected
<p><strong>foo <em>bar</em> baz</strong></p>

@@@ Test 438
!!! text
**foo*bar*baz**
!!! expected
<p><strong>foo<em>bar</em>baz</strong></p>

@@@ Test 439
!!! text
***foo* bar**
!!! expected
<p><strong><em>foo</em> bar</strong></p>

@@@ Test 440
!!! text
**foo *bar***
!!! expected
<p><strong>foo <em>bar</em></strong></p>

@@@ Test 441
!!! text
**foo *bar **baz**
bim* bop**
!!! expected
<p><strong>foo <em>bar <strong>baz</strong>
bim</em> bop</strong></p>

@@@ Test 442
!!! text
**foo [*bar*](/url)**
!!! expected
<p><strong>foo <a href="/url"><em>bar</em></a></strong></p>

@@@ Test 443
!!! text
__ is not an empty emphasis
!!! expected
<p>__ is not an empty emphasis</p>

@@@ Test 444
!!! text
____ is not an empty strong emphasis
!!! expected
<p>____ is not an empty strong emphasis</p>

@@@ Test 445
!!! text
foo ***
!!! expected
<p>foo ***</p>

@@@ Test 446
!!! text
foo *\**
!!! expected
<p>foo <em>*</em></p>

@@@ Test 447
!!! text
foo *_*
!!! expected
<p>foo <em>_</em></p>

@@@ Test 448
!!! text
foo *****
!!! expected
<p>foo *****</p>

@@@ Test 449
!!! text
foo **\***
!!! expected
<p>foo <strong>*</strong></p>

@@@ Test 450
!!! text
foo **_**
!!! expected
<p>foo <strong>_</strong></p>

@@@ Test 451
!!! text
**foo*
!!! expected
<p>*<em>foo</em></p>

@@@ Test 452
!!! text
*foo**
!!! expected
<p><em>foo</em>*</p>

@@@ Test 453
!!! text
***foo**
!!! expected
<p>*<strong>foo</strong></p>

@@@ Test 454
!!! text
****foo*
!!! expected
<p>***<em>foo</em></p>

@@@ Test 455
!!! text
**foo***
!!! expected
<p><strong>foo</strong>*</p>

@@@ Test 456
!!! text
*foo****
!!! expected
<p><em>foo</em>***</p>

@@@ Test 457
!!! text
foo ___
!!! expected
<p>foo ___</p>

@@@ Test 458
!!! text
foo _\__
!!! expected
<p>foo <em>_</em></p>

@@@ Test 459
!!! text
foo _*_
!!! expected
<p>foo <em>*</em></p>

@@@ Test 460
!!! text
foo _____
!!! expected
<p>foo _____</p>

@@@ Test 461
!!! text
foo __\___
!!! expected
<p>foo <strong>_</strong></p>

@@@ Test 462
!!! text
foo __*__
!!! expected
<p>foo <strong>*</strong></p>

@@@ Test 463
!!! text
__foo_
!!! expected
<p>_<em>foo</em></p>

@@@ Test 464
!!! text
_foo__
!!! expected
<p><em>foo</em>_</p>

@@@ Test 465
!!! text
___foo__
!!! expected
<p>_<strong>foo</strong></p>

@@@ Test 466
!!! text
____foo_
!!! expected
<p>___<em>foo</em></p>

@@@ Test 467
!!! text
__foo___
!!! expected
<p><strong>foo</strong>_</p>

@@@ Test 468
!!! text
_foo____
!!! expected
<p><em>foo</em>___</p>

@@@ Test 469
!!! text
**foo**
!!! expected
<p><strong>foo</strong></p>

@@@ Test 470
!!! text
*_foo_*
!!! expected
<p><em><em>foo</em></em></p>

@@@ Test 471
!!! text
__foo__
!!! expected
<p><strong>foo</strong></p>

@@@ Test 472
!!! text
_*foo*_
!!! expected
<p><em><em>foo</em></em></p>

@@@ Test 473
!!! text
****foo****
!!! expected
<p><strong><strong>foo</strong></strong></p>

@@@ Test 474
!!! text
____foo____
!!! expected
<p><strong><strong>foo</strong></strong></p>

@@@ Test 475
!!! text
******foo******
!!! expected
<p><strong><strong><strong>foo</strong></strong></strong></p>

@@@ Test 476
!!! text
***foo***
!!! expected
<p><em><strong>foo</strong></em></p>

@@@ Test 477
!!! text
_____foo_____
!!! expected
<p><em><strong><strong>foo</strong></strong></em></p>

@@@ Test 478
!!! text
*foo _bar* baz_
!!! expected
<p><em>foo _bar</em> baz_</p>

@@@ Test 479
!!! text
*foo __bar *baz bim__ bam*
!!! expected
<p><em>foo <strong>bar *baz bim</strong> bam</em></p>

@@@ Test 480
!!! text
**foo **bar baz**
!!! expected
<p>**foo <strong>bar baz</strong></p>

@@@ Test 481
!!! text
*foo *bar baz*
!!! expected
<p>*foo <em>bar baz</em></p>

@@@ Test 482
!!! text
*[bar*](/url)
!!! expected
<p>*<a href="/url">bar*</a></p>

@@@ Test 483
!!! text
_foo [bar_](/url)
!!! expected
<p>_foo <a href="/url">bar_</a></p>

@@@ Test 484
!!! text
*<img src="foo" title="*"/>
!!! expected
<p>*<img src="foo" title="*"/></p>

@@@ Test 485
!!! text
**<a href="**">
!!! expected
<p>**<a href="**"></p>

@@@ Test 486
!!! text
__<a href="__">
!!! expected
<p>__<a href="__"></p>

@@@ Test 487
!!! text
*a `*`*
!!! expected
<p><em>a <code>*</code></em></p>

@@@ Test 488
!!! text
_a `_`_
!!! expected
<p><em>a <code>_</code></em></p>

@@@ Test 489
!!! text
**a<http://foo.bar/?q=**>
!!! expected
<p>**a<a href="http://foo.bar/?q=**">http://foo.bar/?q=**</a></p>

@@@ Test 490
!!! text
__a<http://foo.bar/?q=__>
!!! expected
<p>__a<a href="http://foo.bar/?q=__">http://foo.bar/?q=__</a></p>

@@@ Test 491
!!! text
~~Hi~~ Hello, ~there~ world!
!!! expected
<p><del>Hi</del> Hello, <del>there</del> world!</p>

@@@ Test 492
!!! text
This ~~has a

new paragraph~~.
!!! expected
<p>This ~~has a</p>
<p>new paragraph~~.</p>

@@@ Test 493
!!! text
This will ~~~not~~~ strike.
!!! expected
<p>This will ~~~not~~~ strike.</p>

@@@ Test 494
!!! text
[link](/uri "title")
!!! expected
<p><a href="/uri" title="title">link</a></p>

@@@ Test 495
!!! text
[link](/uri)
!!! expected
<p><a href="/uri">link</a></p>

@@@ Test 496
!!! text
[link]()
!!! expected
<p><a href="">link</a></p>

@@@ Test 497
!!! text
[link](<>)
!!! expected
<p><a href="">link</a></p>

@@@ Test 498
!!! text
[link](/my uri)
!!! expected
<p>[link](/my uri)</p>

@@@ Test 499
!!! text
[link](</my uri>)
!!! expected
<p><a href="/my%20uri">link</a></p>

@@@ Test 500
!!! text
[link](foo
bar)
!!! expected
<p>[link](foo
bar)</p>

@@@ Test 501
!!! text
[link](<foo
bar>)
!!! expected
<p>[link](<foo
bar>)</p>

@@@ Test 502
!!! text
[a](<b)c>)
!!! expected
<p><a href="b)c">a</a></p>

@@@ Test 503
!!! text
[link](<foo\>)
!!! expected
<p>[link](&lt;foo&gt;)</p>

@@@ Test 504
!!! text
[a](<b)c
[a](<b)c>
[a](<b>c)
!!! expected
<p>[a](&lt;b)c
[a](&lt;b)c&gt;
[a](<b>c)</p>

@@@ Test 505
!!! text
[link](\(foo\))
!!! expected
<p><a href="(foo)">link</a></p>

@@@ Test 506
!!! text
[link](foo(and(bar)))
!!! expected
<p><a href="foo(and(bar))">link</a></p>

@@@ Test 507
!!! text
[link](foo\(and\(bar\))
!!! expected
<p><a href="foo(and(bar)">link</a></p>

@@@ Test 508
!!! text
[link](<foo(and(bar)>)
!!! expected
<p><a href="foo(and(bar)">link</a></p>

@@@ Test 509
!!! text
[link](foo\)\:)
!!! expected
<p><a href="foo):">link</a></p>

@@@ Test 510
!!! text
[link](#fragment)

[link](http://example.com#fragment)

[link](http://example.com?foo=3#frag)
!!! expected
<p><a href="#fragment">link</a></p>
<p><a href="http://example.com#fragment">link</a></p>
<p><a href="http://example.com?foo=3#frag">link</a></p>

@@@ Test 511
!!! text
[link](foo\bar)
!!! expected
<p><a href="foo%5Cbar">link</a></p>

@@@ Test 512
!!! text
[link](foo%20b&auml;)
!!! expected
<p><a href="foo%20b%C3%A4">link</a></p>

@@@ Test 513
!!! text
[link]("title")
!!! expected
<p><a href="%22title%22">link</a></p>

@@@ Test 514
!!! text
[link](/url "title")
[link](/url 'title')
[link](/url (title))
!!! expected
<p><a href="/url" title="title">link</a>
<a href="/url" title="title">link</a>
<a href="/url" title="title">link</a></p>

@@@ Test 515
!!! text
[link](/url "title \"&quot;")
!!! expected
<p><a href="/url" title="title &quot;&quot;">link</a></p>

@@@ Test 516
!!! text
[link](/url "title")
!!! expected
<p><a href="/url%C2%A0%22title%22">link</a></p>

@@@ Test 517
!!! text
[link](/url "title "and" title")
!!! expected
<p>[link](/url &quot;title &quot;and&quot; title&quot;)</p>

@@@ Test 518
!!! text
[link](/url 'title "and" title')
!!! expected
<p><a href="/url" title="title &quot;and&quot; title">link</a></p>

@@@ Test 519
!!! text
[link](   /uri
  "title"  )
!!! expected
<p><a href="/uri" title="title">link</a></p>

@@@ Test 520
!!! text
[link] (/uri)
!!! expected
<p>[link] (/uri)</p>

@@@ Test 521
!!! text
[link [foo [bar]]](/uri)
!!! expected
<p><a href="/uri">link [foo [bar]]</a></p>

@@@ Test 522
!!! text
[link] bar](/uri)
!!! expected
<p>[link] bar](/uri)</p>

@@@ Test 523
!!! text
[link [bar](/uri)
!!! expected
<p>[link <a href="/uri">bar</a></p>

@@@ Test 524
!!! text
[link \[bar](/uri)
!!! expected
<p><a href="/uri">link [bar</a></p>

@@@ Test 525
!!! text
[link *foo **bar** `#`*](/uri)
!!! expected
<p><a href="/uri">link <em>foo <strong>bar</strong> <code>#</code></em></a></p>

@@@ Test 526
!!! text
[![moon](moon.jpg)](/uri)
!!! expected
<p><a href="/uri"><img src="moon.jpg" alt="moon" /></a></p>

@@@ Test 527
!!! text
[foo [bar](/uri)](/uri)
!!! expected
<p>[foo <a href="/uri">bar</a>](/uri)</p>

@@@ Test 528
!!! text
[foo *[bar [baz](/uri)](/uri)*](/uri)
!!! expected
<p>[foo <em>[bar <a href="/uri">baz</a>](/uri)</em>](/uri)</p>

@@@ Test 529
!!! text
![[[foo](uri1)](uri2)](uri3)
!!! expected
<p><img src="uri3" alt="[foo](uri2)" /></p>

@@@ Test 530
!!! text
*[foo*](/uri)
!!! expected
<p>*<a href="/uri">foo*</a></p>

@@@ Test 531
!!! text
[foo *bar](baz*)
!!! expected
<p><a href="baz*">foo *bar</a></p>

@@@ Test 532
!!! text
*foo [bar* baz]
!!! expected
<p><em>foo [bar</em> baz]</p>

@@@ Test 533
!!! text
[foo <bar attr="](baz)">
!!! expected
<p>[foo <bar attr="](baz)"></p>

@@@ Test 534
!!! text
[foo`](/uri)`
!!! expected
<p>[foo<code>](/uri)</code></p>

@@@ Test 535
!!! text
[foo<http://example.com/?search=](uri)>
!!! expected
<p>[foo<a href="http://example.com/?search=%5D(uri)">http://example.com/?search=](uri)</a></p>

@@@ Test 536
!!! text
[foo][bar]

[bar]: /url "title"
!!! expected
<p><a href="/url" title="title">foo</a></p>

@@@ Test 537
!!! text
[link [foo [bar]]][ref]

[ref]: /uri
!!! expected
<p><a href="/uri">link [foo [bar]]</a></p>

@@@ Test 538
!!! text
[link \[bar][ref]

[ref]: /uri
!!! expected
<p><a href="/uri">link [bar</a></p>

@@@ Test 539
!!! text
[link *foo **bar** `#`*][ref]

[ref]: /uri
!!! expected
<p><a href="/uri">link <em>foo <strong>bar</strong> <code>#</code></em></a></p>

@@@ Test 540
!!! text
[![moon](moon.jpg)][ref]

[ref]: /uri
!!! expected
<p><a href="/uri"><img src="moon.jpg" alt="moon" /></a></p>

@@@ Test 541
!!! text
[foo [bar](/uri)][ref]

[ref]: /uri
!!! expected
<p>[foo <a href="/uri">bar</a>]<a href="/uri">ref</a></p>

@@@ Test 542
!!! text
[foo *bar [baz][ref]*][ref]

[ref]: /uri
!!! expected
<p>[foo <em>bar <a href="/uri">baz</a></em>]<a href="/uri">ref</a></p>

@@@ Test 543
!!! text
*[foo*][ref]

[ref]: /uri
!!! expected
<p>*<a href="/uri">foo*</a></p>

@@@ Test 544
!!! text
[foo *bar][ref]*

[ref]: /uri
!!! expected
<p><a href="/uri">foo *bar</a>*</p>

@@@ Test 545
!!! text
[foo <bar attr="][ref]">

[ref]: /uri
!!! expected
<p>[foo <bar attr="][ref]"></p>

@@@ Test 546
!!! text
[foo`][ref]`

[ref]: /uri
!!! expected
<p>[foo<code>][ref]</code></p>

@@@ Test 547
!!! text
[foo<http://example.com/?search=][ref]>

[ref]: /uri
!!! expected
<p>[foo<a href="http://example.com/?search=%5D%5Bref%5D">http://example.com/?search=][ref]</a></p>

@@@ Test 548
!!! text
[foo][BaR]

[bar]: /url "title"
!!! expected
<p><a href="/url" title="title">foo</a></p>

@@@ Test 549
!!! text
[ẞ]

[SS]: /url
!!! expected
<p><a href="/url">ẞ</a></p>

@@@ Test 550
!!! text
[Foo
  bar]: /url

[Baz][Foo bar]
!!! expected
<p><a href="/url">Baz</a></p>

@@@ Test 551
!!! text
[foo] [bar]

[bar]: /url "title"
!!! expected
<p>[foo] <a href="/url" title="title">bar</a></p>

@@@ Test 552
!!! text
[foo]
[bar]

[bar]: /url "title"
!!! expected
<p>[foo]
<a href="/url" title="title">bar</a></p>

@@@ Test 553
!!! text
[foo]: /url1

[foo]: /url2

[bar][foo]
!!! expected
<p><a href="/url1">bar</a></p>

@@@ Test 554
!!! text
[bar][foo\!]

[foo!]: /url
!!! expected
<p>[bar][foo!]</p>

@@@ Test 555
!!! text
[foo][ref[]

[ref[]: /uri
!!! expected
<p>[foo][ref[]</p>
<p>[ref[]: /uri</p>

@@@ Test 556
!!! text
[foo][ref[bar]]

[ref[bar]]: /uri
!!! expected
<p>[foo][ref[bar]]</p>
<p>[ref[bar]]: /uri</p>

@@@ Test 557
!!! text
[[[foo]]]

[[[foo]]]: /url
!!! expected
<p>[[[foo]]]</p>
<p>[[[foo]]]: /url</p>

@@@ Test 558
!!! text
[foo][ref\[]

[ref\[]: /uri
!!! expected
<p><a href="/uri">foo</a></p>

@@@ Test 559
!!! text
[bar\\]: /uri

[bar\\]
!!! expected
<p><a href="/uri">bar\</a></p>

@@@ Test 560
!!! text
[]

[]: /uri
!!! expected
<p>[]</p>
<p>[]: /uri</p>

@@@ Test 561
!!! text
[
 ]

[
 ]: /uri
!!! expected
<p>[
]</p>
<p>[
]: /uri</p>

@@@ Test 562
!!! text
[foo][]

[foo]: /url "title"
!!! expected
<p><a href="/url" title="title">foo</a></p>

@@@ Test 563
!!! text
[*foo* bar][]

[*foo* bar]: /url "title"
!!! expected
<p><a href="/url" title="title"><em>foo</em> bar</a></p>

@@@ Test 564
!!! text
[Foo][]

[foo]: /url "title"
!!! expected
<p><a href="/url" title="title">Foo</a></p>

@@@ Test 565
!!! text
[foo] 
[]

[foo]: /url "title"
!!! expected
<p><a href="/url" title="title">foo</a>
[]</p>

@@@ Test 566
!!! text
[foo]

[foo]: /url "title"
!!! expected
<p><a href="/url" title="title">foo</a></p>

@@@ Test 567
!!! text
[*foo* bar]

[*foo* bar]: /url "title"
!!! expected
<p><a href="/url" title="title"><em>foo</em> bar</a></p>

@@@ Test 568
!!! text
[[*foo* bar]]

[*foo* bar]: /url "title"
!!! expected
<p>[<a href="/url" title="title"><em>foo</em> bar</a>]</p>

@@@ Test 569
!!! text
[[bar [foo]

[foo]: /url
!!! expected
<p>[[bar <a href="/url">foo</a></p>

@@@ Test 570
!!! text
[Foo]

[foo]: /url "title"
!!! expected
<p><a href="/url" title="title">Foo</a></p>

@@@ Test 571
!!! text
[foo] bar

[foo]: /url
!!! expected
<p><a href="/url">foo</a> bar</p>

@@@ Test 572
!!! text
\[foo]

[foo]: /url "title"
!!! expected
<p>[foo]</p>

@@@ Test 573
!!! text
[foo*]: /url

*[foo*]
!!! expected
<p>*<a href="/url">foo*</a></p>

@@@ Test 574
!!! text
[foo][bar]

[foo]: /url1
[bar]: /url2
!!! expected
<p><a href="/url2">foo</a></p>

@@@ Test 575
!!! text
[foo][]

[foo]: /url1
!!! expected
<p><a href="/url1">foo</a></p>

@@@ Test 576
!!! text
[foo]()

[foo]: /url1
!!! expected
<p><a href="">foo</a></p>

@@@ Test 577
!!! text
[foo](not a link)

[foo]: /url1
!!! expected
<p><a href="/url1">foo</a>(not a link)</p>

@@@ Test 578
!!! text
[foo][bar][baz]

[baz]: /url
!!! expected
<p>[foo]<a href="/url">bar</a></p>

@@@ Test 579
!!! text
[foo][bar][baz]

[baz]: /url1
[bar]: /url2
!!! expected
<p><a href="/url2">foo</a><a href="/url1">baz</a></p>

@@@ Test 580
!!! text
[foo][bar][baz]

[baz]: /url1
[foo]: /url2
!!! expected
<p>[foo]<a href="/url1">bar</a></p>

@@@ Test 581
!!! text
![foo](/url "title")
!!! expected
<p><img src="/url" alt="foo" title="title" /></p>

@@@ Test 582
!!! text
![foo *bar*]

[foo *bar*]: train.jpg "train & tracks"
!!! expected
<p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>

@@@ Test 583
!!! text
![foo ![bar](/url)](/url2)
!!! expected
<p><img src="/url2" alt="foo bar" /></p>

@@@ Test 584
!!! text
![foo [bar](/url)](/url2)
!!! expected
<p><img src="/url2" alt="foo bar" /></p>

@@@ Test 585
!!! text
![foo *bar*][]

[foo *bar*]: train.jpg "train & tracks"
!!! expected
<p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>

@@@ Test 586
!!! text
![foo *bar*][foobar]

[FOOBAR]: train.jpg "train & tracks"
!!! expected
<p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>

@@@ Test 587
!!! text
![foo](train.jpg)
!!! expected
<p><img src="train.jpg" alt="foo" /></p>

@@@ Test 588
!!! text
My ![foo bar](/path/to/train.jpg  "title"   )
!!! expected
<p>My <img src="/path/to/train.jpg" alt="foo bar" title="title" /></p>

@@@ Test 589
!!! text
![foo](<url>)
!!! expected
<p><img src="url" alt="foo" /></p>

@@@ Test 590
!!! text
![](/url)
!!! expected
<p><img src="/url" alt="" /></p>

@@@ Test 591
!!! text
![foo][bar]

[bar]: /url
!!! expected
<p><img src="/url" alt="foo" /></p>

@@@ Test 592
!!! text
![foo][bar]

[BAR]: /url
!!! expected
<p><img src="/url" alt="foo" /></p>

@@@ Test 593
!!! text
![foo][]

[foo]: /url "title"
!!! expected
<p><img src="/url" alt="foo" title="title" /></p>

@@@ Test 594
!!! text
![*foo* bar][]

[*foo* bar]: /url "title"
!!! expected
<p><img src="/url" alt="foo bar" title="title" /></p>

@@@ Test 595
!!! text
![Foo][]

[foo]: /url "title"
!!! expected
<p><img src="/url" alt="Foo" title="title" /></p>

@@@ Test 596
!!! text
![foo] 
[]

[foo]: /url "title"
!!! expected
<p><img src="/url" alt="foo" title="title" />
[]</p>

@@@ Test 597
!!! text
![foo]

[foo]: /url "title"
!!! expected
<p><img src="/url" alt="foo" title="title" /></p>

@@@ Test 598
!!! text
![*foo* bar]

[*foo* bar]: /url "title"
!!! expected
<p><img src="/url" alt="foo bar" title="title" /></p>

@@@ Test 599
!!! text
![[foo]]

[[foo]]: /url "title"
!!! expected
<p>![[foo]]</p>
<p>[[foo]]: /url &quot;title&quot;</p>

@@@ Test 600
!!! text
![Foo]

[foo]: /url "title"
!!! expected
<p><img src="/url" alt="Foo" title="title" /></p>

@@@ Test 601
!!! text
!\[foo]

[foo]: /url "title"
!!! expected
<p>![foo]</p>

@@@ Test 602
!!! text
\![foo]

[foo]: /url "title"
!!! expected
<p>!<a href="/url" title="title">foo</a></p>

@@@ Test 603
!!! text
<http://foo.bar.baz>
!!! expected
<p><a href="http://foo.bar.baz">http://foo.bar.baz</a></p>

@@@ Test 604
!!! text
<http://foo.bar.baz/test?q=hello&id=22&boolean>
!!! expected
<p><a href="http://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean">http://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean</a></p>

@@@ Test 605
!!! text
<irc://foo.bar:2233/baz>
!!! expected
<p><a href="irc://foo.bar:2233/baz">irc://foo.bar:2233/baz</a></p>

@@@ Test 606
!!! text
<MAILTO:FOO@BAR.BAZ>
!!! expected
<p><a href="MAILTO:FOO@BAR.BAZ">MAILTO:FOO@BAR.BAZ</a></p>

@@@ Test 607
!!! text
<a+b+c:d>
!!! expected
<p><a href="a+b+c:d">a+b+c:d</a></p>

@@@ Test 608
!!! text
<made-up-scheme://foo,bar>
!!! expected
<p><a href="made-up-scheme://foo,bar">made-up-scheme://foo,bar</a></p>

@@@ Test 609
!!! text
<http://../>
!!! expected
<p><a href="http://../">http://../</a></p>

@@@ Test 610
!!! text
<localhost:5001/foo>
!!! expected
<p><a href="localhost:5001/foo">localhost:5001/foo</a></p>

@@@ Test 611
!!! text
<http://foo.bar/baz bim>
!!! expected
<p>&lt;http://foo.bar/baz bim&gt;</p>

@@@ Test 612
!!! text
<http://example.com/\[\>
!!! expected
<p><a href="http://example.com/%5C%5B%5C">http://example.com/\[\</a></p>

@@@ Test 613
!!! text
<foo@bar.example.com>
!!! expected
<p><a href="mailto:foo@bar.example.com">foo@bar.example.com</a></p>

@@@ Test 614
!!! text
<foo+special@Bar.baz-bar0.com>
!!! expected
<p><a href="mailto:foo+special@Bar.baz-bar0.com">foo+special@Bar.baz-bar0.com</a></p>

@@@ Test 615
!!! text
<foo\+@bar.example.com>
!!! expected
<p>&lt;foo+@bar.example.com&gt;</p>

@@@ Test 616
!!! text
<>
!!! expected
<p>&lt;&gt;</p>

@@@ Test 617
!!! text
< http://foo.bar >
!!! expected_todo
<p>&lt; http://foo.bar &gt;</p>

@@@ Test 618
!!! text
<m:abc>
!!! expected
<p>&lt;m:abc&gt;</p>

@@@ Test 619
!!! text
<foo.bar.baz>
!!! expected
<p>&lt;foo.bar.baz&gt;</p>

@@@ Test 620
!!! text
http://example.com
!!! expected_todo
<p>http://example.com</p>

@@@ Test 621
!!! text
foo@bar.example.com
!!! expected_todo
<p>foo@bar.example.com</p>

@@@ Test 622
!!! text
www.commonmark.org
!!! expected
<p><a href="http://www.commonmark.org">www.commonmark.org</a></p>

@@@ Test 623
!!! text
Visit www.commonmark.org/help for more information.
!!! expected
<p>Visit <a href="http://www.commonmark.org/help">www.commonmark.org/help</a> for more information.</p>

@@@ Test 624
!!! text
Visit www.commonmark.org.

Visit www.commonmark.org/a.b.
!!! expected
<p>Visit <a href="http://www.commonmark.org">www.commonmark.org</a>.</p>
<p>Visit <a href="http://www.commonmark.org/a.b">www.commonmark.org/a.b</a>.</p>

@@@ Test 625
!!! text
www.google.com/search?q=Markup+(business)

www.google.com/search?q=Markup+(business)))

(www.google.com/search?q=Markup+(business))

(www.google.com/search?q=Markup+(business)
!!! expected
<p><a href="http://www.google.com/search?q=Markup+(business)">www.google.com/search?q=Markup+(business)</a></p>
<p><a href="http://www.google.com/search?q=Markup+(business)">www.google.com/search?q=Markup+(business)</a>))</p>
<p>(<a href="http://www.google.com/search?q=Markup+(business)">www.google.com/search?q=Markup+(business)</a>)</p>
<p>(<a href="http://www.google.com/search?q=Markup+(business)">www.google.com/search?q=Markup+(business)</a></p>

@@@ Test 626
!!! text
www.google.com/search?q=(business))+ok
!!! expected
<p><a href="http://www.google.com/search?q=(business))+ok">www.google.com/search?q=(business))+ok</a></p>

@@@ Test 627
!!! text
www.google.com/search?q=commonmark&hl=en

www.google.com/search?q=commonmark&hl;
!!! expected
<p><a href="http://www.google.com/search?q=commonmark&amp;hl=en">www.google.com/search?q=commonmark&amp;hl=en</a></p>
<p><a href="http://www.google.com/search?q=commonmark">www.google.com/search?q=commonmark</a>&amp;hl;</p>

@@@ Test 628
!!! text
www.commonmark.org/he<lp
!!! expected
<p><a href="http://www.commonmark.org/he">www.commonmark.org/he</a>&lt;lp</p>

@@@ Test 629
!!! text
http://commonmark.org

(Visit https://encrypted.google.com/search?q=Markup+(business))
!!! expected
<p><a href="http://commonmark.org">http://commonmark.org</a></p>
<p>(Visit <a href="https://encrypted.google.com/search?q=Markup+(business)">https://encrypted.google.com/search?q=Markup+(business)</a>)</p>

@@@ Test 630
!!! text
foo@bar.baz
!!! expected
<p><a href="mailto:foo@bar.baz">foo@bar.baz</a></p>

@@@ Test 631
!!! text
hello@mail+xyz.example isn't valid, but hello+xyz@mail.example is.
!!! expected
<p>hello@mail+xyz.example isn't valid, but <a href="mailto:hello+xyz@mail.example">hello+xyz@mail.example</a> is.</p>

@@@ Test 632
!!! text
a.b-c_d@a.b

a.b-c_d@a.b.

a.b-c_d@a.b-

a.b-c_d@a.b_
!!! expected
<p><a href="mailto:a.b-c_d@a.b">a.b-c_d@a.b</a></p>
<p><a href="mailto:a.b-c_d@a.b">a.b-c_d@a.b</a>.</p>
<p>a.b-c_d@a.b-</p>
<p>a.b-c_d@a.b_</p>

@@@ Test 633
!!! text
mailto:foo@bar.baz

mailto:a.b-c_d@a.b

mailto:a.b-c_d@a.b.

mailto:a.b-c_d@a.b/

mailto:a.b-c_d@a.b-

mailto:a.b-c_d@a.b_

xmpp:foo@bar.baz

xmpp:foo@bar.baz.
!!! expected_todo
<p><a href="mailto:foo@bar.baz">mailto:foo@bar.baz</a></p>
<p><a href="mailto:a.b-c_d@a.b">mailto:a.b-c_d@a.b</a></p>
<p><a href="mailto:a.b-c_d@a.b">mailto:a.b-c_d@a.b</a>.</p>
<p><a href="mailto:a.b-c_d@a.b">mailto:a.b-c_d@a.b</a>/</p>
<p>mailto:a.b-c_d@a.b-</p>
<p>mailto:a.b-c_d@a.b_</p>
<p><a href="xmpp:foo@bar.baz">xmpp:foo@bar.baz</a></p>
<p><a href="xmpp:foo@bar.baz">xmpp:foo@bar.baz</a>.</p>

@@@ Test 634
!!! text
xmpp:foo@bar.baz/txt

xmpp:foo@bar.baz/txt@bin

xmpp:foo@bar.baz/txt@bin.com
!!! expected_todo
<p><a href="xmpp:foo@bar.baz/txt">xmpp:foo@bar.baz/txt</a></p>
<p><a href="xmpp:foo@bar.baz/txt@bin">xmpp:foo@bar.baz/txt@bin</a></p>
<p><a href="xmpp:foo@bar.baz/txt@bin.com">xmpp:foo@bar.baz/txt@bin.com</a></p>

@@@ Test 635
!!! text
xmpp:foo@bar.baz/txt/bin
!!! expected_todo
<p><a href="xmpp:foo@bar.baz/txt">xmpp:foo@bar.baz/txt</a>/bin</p>

@@@ Test 636
!!! text
<a><bab><c2c>
!!! expected
<p><a><bab><c2c></p>

@@@ Test 637
!!! text
<a/><b2/>
!!! expected
<p><a/><b2/></p>

@@@ Test 638
!!! text
<a  /><b2
data="foo" >
!!! expected
<p><a  /><b2
data="foo" ></p>

@@@ Test 639
!!! text
<a foo="bar" bam = 'baz <em>"</em>'
_boolean zoop:33=zoop:33 />
!!! expected
<p><a foo="bar" bam = 'baz <em>"</em>'
_boolean zoop:33=zoop:33 /></p>

@@@ Test 640
!!! text
Foo <responsive-image src="foo.jpg" />
!!! expected
<p>Foo <responsive-image src="foo.jpg" /></p>

@@@ Test 641
!!! text
<33> <__>
!!! expected
<p>&lt;33&gt; &lt;__&gt;</p>

@@@ Test 642
!!! text
<a h*#ref="hi">
!!! expected
<p>&lt;a h*#ref=&quot;hi&quot;&gt;</p>

@@@ Test 643
!!! text
<a href="hi'> <a href=hi'>
!!! expected
<p>&lt;a href=&quot;hi'&gt; &lt;a href=hi'&gt;</p>

@@@ Test 644
!!! text
< a><
foo><bar/ >
<foo bar=baz
bim!bop />
!!! expected
<p>&lt; a&gt;&lt;
foo&gt;&lt;bar/ &gt;
&lt;foo bar=baz
bim!bop /&gt;</p>

@@@ Test 645
!!! text
<a href='bar'title=title>
!!! expected
<p>&lt;a href='bar'title=title&gt;</p>

@@@ Test 646
!!! text
</a></foo >
!!! expected
<p></a></foo ></p>

@@@ Test 647
!!! text
</a href="foo">
!!! expected
<p>&lt;/a href=&quot;foo&quot;&gt;</p>

@@@ Test 648
!!! text
foo <!-- this is a
comment - with hyphen -->
!!! expected
<p>foo <!-- this is a
comment - with hyphen --></p>

@@@ Test 649
!!! text
foo <!-- not a comment -- two hyphens -->
!!! expected_todo
<p>foo &lt;!-- not a comment -- two hyphens --&gt;</p>

@@@ Test 650
!!! text
foo <!--> foo -->

foo <!-- foo--->
!!! expected_todo
<p>foo &lt;!--&gt; foo --&gt;</p>
<p>foo &lt;!-- foo---&gt;</p>

@@@ Test 651
!!! text
foo <?php echo $a; ?>
!!! expected
<p>foo <?php echo $a; ?></p>

@@@ Test 652
!!! text
foo <!ELEMENT br EMPTY>
!!! expected
<p>foo <!ELEMENT br EMPTY></p>

@@@ Test 653
!!! text
foo <![CDATA[>&<]]>
!!! expected
<p>foo <![CDATA[>&<]]></p>

@@@ Test 654
!!! text
foo <a href="&ouml;">
!!! expected
<p>foo <a href="&ouml;"></p>

@@@ Test 655
!!! text
foo <a href="\*">
!!! expected
<p>foo <a href="\*"></p>

@@@ Test 656
!!! text
<a href="\"">
!!! expected
<p>&lt;a href=&quot;&quot;&quot;&gt;</p>

@@@ Test 657
!!! text
<strong> <title> <style> <em>

<blockquote>
  <xmp> is disallowed.  <XMP> is also disallowed.
</blockquote>
!!! expected
<p><strong> &lt;title> &lt;style> <em></p>
<blockquote>
  &lt;xmp> is disallowed.  &lt;XMP> is also disallowed.
</blockquote>

@@@ Test 658
!!! text
foo  
baz
!!! expected
<p>foo<br />
baz</p>

@@@ Test 659
!!! text
foo\
baz
!!! expected
<p>foo<br />
baz</p>

@@@ Test 660
!!! text
foo       
baz
!!! expected
<p>foo<br />
baz</p>

@@@ Test 661
!!! text
foo  
     bar
!!! expected
<p>foo<br />
bar</p>

@@@ Test 662
!!! text
foo\
     bar
!!! expected
<p>foo<br />
bar</p>

@@@ Test 663
!!! text
*foo  
bar*
!!! expected
<p><em>foo<br />
bar</em></p>

@@@ Test 664
!!! text
*foo\
bar*
!!! expected
<p><em>foo<br />
bar</em></p>

@@@ Test 665
!!! text
`code  
span`
!!! expected
<p><code>code   span</code></p>

@@@ Test 666
!!! text
`code\
span`
!!! expected
<p><code>code\ span</code></p>

@@@ Test 667
!!! text
<a href="foo  
bar">
!!! expected
<p><a href="foo  
bar"></p>

@@@ Test 668
!!! text
<a href="foo\
bar">
!!! expected
<p><a href="foo\
bar"></p>

@@@ Test 669
!!! text
foo\
!!! expected
<p>foo\</p>

@@@ Test 670
!!! text
foo  
!!! expected
<p>foo</p>

@@@ Test 671
!!! text
### foo\
!!! expected
<h3>foo\</h3>

@@@ Test 672
!!! text
### foo  
!!! expected
<h3>foo</h3>

@@@ Test 673
!!! text
foo
baz
!!! expected
<p>foo
baz</p>

@@@ Test 674
!!! text
foo 
 baz
!!! expected
<p>foo
baz</p>

@@@ Test 675
!!! text
hello $.;'there
!!! expected
<p>hello $.;'there</p>

@@@ Test 676
!!! text
Foo χρῆν
!!! expected
<p>Foo χρῆν</p>

@@@ Test 677
!!! text
Multiple     spaces
!!! expected
<p>Multiple     spaces</p>

