#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use FindBin;
use lib "$FindBin::Bin/../../../t/lib"; # t/lib

use Test::More;
use MT::Test::Env;

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

MT::Test::TextFilter->set('commonmark');

filters {
    text     => [qw( chomp )],
    expected => [qw( chomp )],
};

my $site = MT::Blog->load(1);
my $site_id = $site->id;

MT::Test::TextFilter->run_perl_tests($site_id);
MT::Test::TextFilter->run_php_tests($site_id);

done_testing;

# spec version: 0.31.2

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
\!\"\#\$\%\&\'\(\)\*\+\,\-\.\/\:\;\<\=\>\?\@\[\\\]\^\_\`\{\|\}\~
!!! expected
<p>!&quot;#$%&amp;'()*+,-./:;&lt;=&gt;?@[\]^_`{|}~</p>

@@@ Test 13
!!! text
\	\A\a\ \3\φ\«
!!! expected
<p>\	\A\a\ \3\φ\«</p>

@@@ Test 14
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

@@@ Test 15
!!! text
\\*emphasis*
!!! expected
<p>\<em>emphasis</em></p>

@@@ Test 16
!!! text
foo\
bar
!!! expected
<p>foo<br />
bar</p>

@@@ Test 17
!!! text
`` \[\` ``
!!! expected
<p><code>\[\`</code></p>

@@@ Test 18
!!! text
    \[\]
!!! expected
<pre><code>\[\]
</code></pre>

@@@ Test 19
!!! text
~~~
\[\]
~~~
!!! expected
<pre><code>\[\]
</code></pre>

@@@ Test 20
!!! text
<https://example.com?find=\*>
!!! expected
<p><a href="https://example.com?find=%5C*">https://example.com?find=\*</a></p>

@@@ Test 21
!!! text
<a href="/bar\/)">
!!! expected
<a href="/bar\/)">

@@@ Test 22
!!! text
[foo](/bar\* "ti\*tle")
!!! expected
<p><a href="/bar*" title="ti*tle">foo</a></p>

@@@ Test 23
!!! text
[foo]

[foo]: /bar\* "ti\*tle"
!!! expected
<p><a href="/bar*" title="ti*tle">foo</a></p>

@@@ Test 24
!!! text
``` foo\+bar
foo
```
!!! expected
<pre><code class="language-foo+bar">foo
</code></pre>

@@@ Test 25
!!! text
&nbsp; &amp; &copy; &AElig; &Dcaron;
&frac34; &HilbertSpace; &DifferentialD;
&ClockwiseContourIntegral; &ngE;
!!! expected
<p>  &amp; © Æ Ď
¾ ℋ ⅆ
∲ ≧̸</p>

@@@ Test 26
!!! text
&#35; &#1234; &#992; &#0;
!!! expected
<p># Ӓ Ϡ �</p>

@@@ Test 27
!!! text
&#X22; &#XD06; &#xcab;
!!! expected
<p>&quot; ആ ಫ</p>

@@@ Test 28
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

@@@ Test 29
!!! text
&copy
!!! expected
<p>&amp;copy</p>

@@@ Test 30
!!! text
&MadeUpEntity;
!!! expected
<p>&amp;MadeUpEntity;</p>

@@@ Test 31
!!! text
<a href="&ouml;&ouml;.html">
!!! expected
<a href="&ouml;&ouml;.html">

@@@ Test 32
!!! text
[foo](/f&ouml;&ouml; "f&ouml;&ouml;")
!!! expected
<p><a href="/f%C3%B6%C3%B6" title="föö">foo</a></p>

@@@ Test 33
!!! text
[foo]

[foo]: /f&ouml;&ouml; "f&ouml;&ouml;"
!!! expected
<p><a href="/f%C3%B6%C3%B6" title="föö">foo</a></p>

@@@ Test 34
!!! text
``` f&ouml;&ouml;
foo
```
!!! expected
<pre><code class="language-föö">foo
</code></pre>

@@@ Test 35
!!! text
`f&ouml;&ouml;`
!!! expected
<p><code>f&amp;ouml;&amp;ouml;</code></p>

@@@ Test 36
!!! text
    f&ouml;f&ouml;
!!! expected
<pre><code>f&amp;ouml;f&amp;ouml;
</code></pre>

@@@ Test 37
!!! text
&#42;foo&#42;
*foo*
!!! expected
<p>*foo*
<em>foo</em></p>

@@@ Test 38
!!! text
&#42; foo

* foo
!!! expected
<p>* foo</p>
<ul>
<li>foo</li>
</ul>

@@@ Test 39
!!! text
foo&#10;&#10;bar
!!! expected
<p>foo

bar</p>

@@@ Test 40
!!! text
&#9;foo
!!! expected
<p>	foo</p>

@@@ Test 41
!!! text
[a](url &quot;tit&quot;)
!!! expected
<p>[a](url &quot;tit&quot;)</p>

@@@ Test 42
!!! text
- `one
- two`
!!! expected
<ul>
<li>`one</li>
<li>two`</li>
</ul>

@@@ Test 43
!!! text
***
---
___
!!! expected
<hr />
<hr />
<hr />

@@@ Test 44
!!! text
+++
!!! expected
<p>+++</p>

@@@ Test 45
!!! text
===
!!! expected
<p>===</p>

@@@ Test 46
!!! text
--
**
__
!!! expected
<p>--
**
__</p>

@@@ Test 47
!!! text
 ***
  ***
   ***
!!! expected
<hr />
<hr />
<hr />

@@@ Test 48
!!! text
    ***
!!! expected
<pre><code>***
</code></pre>

@@@ Test 49
!!! text
Foo
    ***
!!! expected
<p>Foo
***</p>

@@@ Test 50
!!! text
_____________________________________
!!! expected
<hr />

@@@ Test 51
!!! text
 - - -
!!! expected
<hr />

@@@ Test 52
!!! text
 **  * ** * ** * **
!!! expected
<hr />

@@@ Test 53
!!! text
-     -      -      -
!!! expected
<hr />

@@@ Test 54
!!! text
- - - -    
!!! expected
<hr />

@@@ Test 55
!!! text
_ _ _ _ a

a------

---a---
!!! expected
<p>_ _ _ _ a</p>
<p>a------</p>
<p>---a---</p>

@@@ Test 56
!!! text
 *-*
!!! expected
<p><em>-</em></p>

@@@ Test 57
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

@@@ Test 58
!!! text
Foo
***
bar
!!! expected
<p>Foo</p>
<hr />
<p>bar</p>

@@@ Test 59
!!! text
Foo
---
bar
!!! expected
<h2>Foo</h2>
<p>bar</p>

@@@ Test 60
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

@@@ Test 61
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

@@@ Test 62
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

@@@ Test 63
!!! text
####### foo
!!! expected
<p>####### foo</p>

@@@ Test 64
!!! text
#5 bolt

#hashtag
!!! expected
<p>#5 bolt</p>
<p>#hashtag</p>

@@@ Test 65
!!! text
\## foo
!!! expected
<p>## foo</p>

@@@ Test 66
!!! text
# foo *bar* \*baz\*
!!! expected
<h1>foo <em>bar</em> *baz*</h1>

@@@ Test 67
!!! text
#                  foo                     
!!! expected
<h1>foo</h1>

@@@ Test 68
!!! text
 ### foo
  ## foo
   # foo
!!! expected
<h3>foo</h3>
<h2>foo</h2>
<h1>foo</h1>

@@@ Test 69
!!! text
    # foo
!!! expected
<pre><code># foo
</code></pre>

@@@ Test 70
!!! text
foo
    # bar
!!! expected
<p>foo
# bar</p>

@@@ Test 71
!!! text
## foo ##
  ###   bar    ###
!!! expected
<h2>foo</h2>
<h3>bar</h3>

@@@ Test 72
!!! text
# foo ##################################
##### foo ##
!!! expected
<h1>foo</h1>
<h5>foo</h5>

@@@ Test 73
!!! text
### foo ###     
!!! expected
<h3>foo</h3>

@@@ Test 74
!!! text
### foo ### b
!!! expected
<h3>foo ### b</h3>

@@@ Test 75
!!! text
# foo#
!!! expected
<h1>foo#</h1>

@@@ Test 76
!!! text
### foo \###
## foo #\##
# foo \#
!!! expected
<h3>foo ###</h3>
<h2>foo ###</h2>
<h1>foo #</h1>

@@@ Test 77
!!! text
****
## foo
****
!!! expected
<hr />
<h2>foo</h2>
<hr />

@@@ Test 78
!!! text
Foo bar
# baz
Bar foo
!!! expected
<p>Foo bar</p>
<h1>baz</h1>
<p>Bar foo</p>

@@@ Test 79
!!! text
## 
#
### ###
!!! expected
<h2></h2>
<h1></h1>
<h3></h3>

@@@ Test 80
!!! text
Foo *bar*
=========

Foo *bar*
---------
!!! expected
<h1>Foo <em>bar</em></h1>
<h2>Foo <em>bar</em></h2>

@@@ Test 81
!!! text
Foo *bar
baz*
====
!!! expected
<h1>Foo <em>bar
baz</em></h1>

@@@ Test 82
!!! text
  Foo *bar
baz*	
====
!!! expected
<h1>Foo <em>bar
baz</em></h1>

@@@ Test 83
!!! text
Foo
-------------------------

Foo
=
!!! expected
<h2>Foo</h2>
<h1>Foo</h1>

@@@ Test 84
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

@@@ Test 85
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

@@@ Test 86
!!! text
Foo
   ----      
!!! expected
<h2>Foo</h2>

@@@ Test 87
!!! text
Foo
    ---
!!! expected
<p>Foo
---</p>

@@@ Test 88
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

@@@ Test 89
!!! text
Foo  
-----
!!! expected
<h2>Foo</h2>

@@@ Test 90
!!! text
Foo\
----
!!! expected
<h2>Foo\</h2>

@@@ Test 91
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

@@@ Test 92
!!! text
> Foo
---
!!! expected
<blockquote>
<p>Foo</p>
</blockquote>
<hr />

@@@ Test 93
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

@@@ Test 94
!!! text
- Foo
---
!!! expected
<ul>
<li>Foo</li>
</ul>
<hr />

@@@ Test 95
!!! text
Foo
Bar
---
!!! expected
<h2>Foo
Bar</h2>

@@@ Test 96
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

@@@ Test 97
!!! text

====
!!! expected
<p>====</p>

@@@ Test 98
!!! text
---
---
!!! expected
<hr />
<hr />

@@@ Test 99
!!! text
- foo
-----
!!! expected
<ul>
<li>foo</li>
</ul>
<hr />

@@@ Test 100
!!! text
    foo
---
!!! expected
<pre><code>foo
</code></pre>
<hr />

@@@ Test 101
!!! text
> foo
-----
!!! expected
<blockquote>
<p>foo</p>
</blockquote>
<hr />

@@@ Test 102
!!! text
\> foo
------
!!! expected
<h2>&gt; foo</h2>

@@@ Test 103
!!! text
Foo

bar
---
baz
!!! expected
<p>Foo</p>
<h2>bar</h2>
<p>baz</p>

@@@ Test 104
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

@@@ Test 105
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

@@@ Test 106
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

@@@ Test 107
!!! text
    a simple
      indented code block
!!! expected
<pre><code>a simple
  indented code block
</code></pre>

@@@ Test 108
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

@@@ Test 109
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

@@@ Test 110
!!! text
    <a/>
    *hi*

    - one
!!! expected
<pre><code>&lt;a/&gt;
*hi*

- one
</code></pre>

@@@ Test 111
!!! text
    chunk1

    chunk2
  
 
 
    chunk3
!!! expected
<pre><code>chunk1

chunk2



chunk3
</code></pre>

@@@ Test 112
!!! text
    chunk1
      
      chunk2
!!! expected
<pre><code>chunk1
  
  chunk2
</code></pre>

@@@ Test 113
!!! text
Foo
    bar

!!! expected
<p>Foo
bar</p>

@@@ Test 114
!!! text
    foo
bar
!!! expected
<pre><code>foo
</code></pre>
<p>bar</p>

@@@ Test 115
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

@@@ Test 116
!!! text
        foo
    bar
!!! expected
<pre><code>    foo
bar
</code></pre>

@@@ Test 117
!!! text

    
    foo
    

!!! expected
<pre><code>foo
</code></pre>

@@@ Test 118
!!! text
    foo  
!!! expected
<pre><code>foo  
</code></pre>

@@@ Test 119
!!! text
```
<
 >
```
!!! expected
<pre><code>&lt;
 &gt;
</code></pre>

@@@ Test 120
!!! text
~~~
<
 >
~~~
!!! expected
<pre><code>&lt;
 &gt;
</code></pre>

@@@ Test 121
!!! text
``
foo
``
!!! expected
<p><code>foo</code></p>

@@@ Test 122
!!! text
```
aaa
~~~
```
!!! expected
<pre><code>aaa
~~~
</code></pre>

@@@ Test 123
!!! text
~~~
aaa
```
~~~
!!! expected
<pre><code>aaa
```
</code></pre>

@@@ Test 124
!!! text
````
aaa
```
``````
!!! expected
<pre><code>aaa
```
</code></pre>

@@@ Test 125
!!! text
~~~~
aaa
~~~
~~~~
!!! expected
<pre><code>aaa
~~~
</code></pre>

@@@ Test 126
!!! text
```
!!! expected
<pre><code></code></pre>

@@@ Test 127
!!! text
`````

```
aaa
!!! expected
<pre><code>
```
aaa
</code></pre>

@@@ Test 128
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

@@@ Test 129
!!! text
```

  
```
!!! expected
<pre><code>
  
</code></pre>

@@@ Test 130
!!! text
```
```
!!! expected
<pre><code></code></pre>

@@@ Test 131
!!! text
 ```
 aaa
aaa
```
!!! expected
<pre><code>aaa
aaa
</code></pre>

@@@ Test 132
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

@@@ Test 133
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

@@@ Test 134
!!! text
    ```
    aaa
    ```
!!! expected
<pre><code>```
aaa
```
</code></pre>

@@@ Test 135
!!! text
```
aaa
  ```
!!! expected
<pre><code>aaa
</code></pre>

@@@ Test 136
!!! text
   ```
aaa
  ```
!!! expected
<pre><code>aaa
</code></pre>

@@@ Test 137
!!! text
```
aaa
    ```
!!! expected
<pre><code>aaa
    ```
</code></pre>

@@@ Test 138
!!! text
``` ```
aaa
!!! expected
<p><code> </code>
aaa</p>

@@@ Test 139
!!! text
~~~~~~
aaa
~~~ ~~
!!! expected
<pre><code>aaa
~~~ ~~
</code></pre>

@@@ Test 140
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

@@@ Test 141
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

@@@ Test 142
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

@@@ Test 143
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

@@@ Test 144
!!! text
````;
````
!!! expected
<pre><code class="language-;"></code></pre>

@@@ Test 145
!!! text
``` aa ```
foo
!!! expected
<p><code>aa</code>
foo</p>

@@@ Test 146
!!! text
~~~ aa ``` ~~~
foo
~~~
!!! expected
<pre><code class="language-aa">foo
</code></pre>

@@@ Test 147
!!! text
```
``` aaa
```
!!! expected
<pre><code>``` aaa
</code></pre>

@@@ Test 148
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

@@@ Test 149
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

@@@ Test 150
!!! text
 <div>
  *hello*
         <foo><a>
!!! expected
 <div>
  *hello*
         <foo><a>

@@@ Test 151
!!! text
</div>
*foo*
!!! expected
</div>
*foo*

@@@ Test 152
!!! text
<DIV CLASS="foo">

*Markdown*

</DIV>
!!! expected
<DIV CLASS="foo">
<p><em>Markdown</em></p>
</DIV>

@@@ Test 153
!!! text
<div id="foo"
  class="bar">
</div>
!!! expected
<div id="foo"
  class="bar">
</div>

@@@ Test 154
!!! text
<div id="foo" class="bar
  baz">
</div>
!!! expected
<div id="foo" class="bar
  baz">
</div>

@@@ Test 155
!!! text
<div>
*foo*

*bar*
!!! expected
<div>
*foo*
<p><em>bar</em></p>

@@@ Test 156
!!! text
<div id="foo"
*hi*
!!! expected
<div id="foo"
*hi*

@@@ Test 157
!!! text
<div class
foo
!!! expected
<div class
foo

@@@ Test 158
!!! text
<div *???-&&&-<---
*foo*
!!! expected
<div *???-&&&-<---
*foo*

@@@ Test 159
!!! text
<div><a href="bar">*foo*</a></div>
!!! expected
<div><a href="bar">*foo*</a></div>

@@@ Test 160
!!! text
<table><tr><td>
foo
</td></tr></table>
!!! expected
<table><tr><td>
foo
</td></tr></table>

@@@ Test 161
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

@@@ Test 162
!!! text
<a href="foo">
*bar*
</a>
!!! expected
<a href="foo">
*bar*
</a>

@@@ Test 163
!!! text
<Warning>
*bar*
</Warning>
!!! expected
<Warning>
*bar*
</Warning>

@@@ Test 164
!!! text
<i class="foo">
*bar*
</i>
!!! expected
<i class="foo">
*bar*
</i>

@@@ Test 165
!!! text
</ins>
*bar*
!!! expected
</ins>
*bar*

@@@ Test 166
!!! text
<del>
*foo*
</del>
!!! expected
<del>
*foo*
</del>

@@@ Test 167
!!! text
<del>

*foo*

</del>
!!! expected
<del>
<p><em>foo</em></p>
</del>

@@@ Test 168
!!! text
<del>*foo*</del>
!!! expected
<p><del><em>foo</em></del></p>

@@@ Test 169
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

@@@ Test 170
!!! text
<script type="text/javascript">
// JavaScript example

document.getElementById("demo").innerHTML = "Hello JavaScript!";
</script>
okay
!!! expected
<script type="text/javascript">
// JavaScript example

document.getElementById("demo").innerHTML = "Hello JavaScript!";
</script>
<p>okay</p>

@@@ Test 171
!!! text
<textarea>

*foo*

_bar_

</textarea>
!!! expected
<textarea>

*foo*

_bar_

</textarea>

@@@ Test 172
!!! text
<style
  type="text/css">
h1 {color:red;}

p {color:blue;}
</style>
okay
!!! expected
<style
  type="text/css">
h1 {color:red;}

p {color:blue;}
</style>
<p>okay</p>

@@@ Test 173
!!! text
<style
  type="text/css">

foo
!!! expected
<style
  type="text/css">

foo

@@@ Test 174
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

@@@ Test 175
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

@@@ Test 176
!!! text
<style>p{color:red;}</style>
*foo*
!!! expected
<style>p{color:red;}</style>
<p><em>foo</em></p>

@@@ Test 177
!!! text
<!-- foo -->*bar*
*baz*
!!! expected
<!-- foo -->*bar*
<p><em>baz</em></p>

@@@ Test 178
!!! text
<script>
foo
</script>1. *bar*
!!! expected
<script>
foo
</script>1. *bar*

@@@ Test 179
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

@@@ Test 180
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

@@@ Test 181
!!! text
<!DOCTYPE html>
!!! expected
<!DOCTYPE html>

@@@ Test 182
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

@@@ Test 183
!!! text
  <!-- foo -->

    <!-- foo -->
!!! expected
  <!-- foo -->
<pre><code>&lt;!-- foo --&gt;
</code></pre>

@@@ Test 184
!!! text
  <div>

    <div>
!!! expected
  <div>
<pre><code>&lt;div&gt;
</code></pre>

@@@ Test 185
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

@@@ Test 186
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

@@@ Test 187
!!! text
Foo
<a href="bar">
baz
!!! expected
<p>Foo
<a href="bar">
baz</p>

@@@ Test 188
!!! text
<div>

*Emphasized* text.

</div>
!!! expected
<div>
<p><em>Emphasized</em> text.</p>
</div>

@@@ Test 189
!!! text
<div>
*Emphasized* text.
</div>
!!! expected
<div>
*Emphasized* text.
</div>

@@@ Test 190
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

@@@ Test 191
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

@@@ Test 192
!!! text
[foo]: /url "title"

[foo]
!!! expected
<p><a href="/url" title="title">foo</a></p>

@@@ Test 193
!!! text
   [foo]: 
      /url  
           'the title'  

[foo]
!!! expected
<p><a href="/url" title="the title">foo</a></p>

@@@ Test 194
!!! text
[Foo*bar\]]:my_(url) 'title (with parens)'

[Foo*bar\]]
!!! expected
<p><a href="my_(url)" title="title (with parens)">Foo*bar]</a></p>

@@@ Test 195
!!! text
[Foo bar]:
<my url>
'title'

[Foo bar]
!!! expected
<p><a href="my%20url" title="title">Foo bar</a></p>

@@@ Test 196
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

@@@ Test 197
!!! text
[foo]: /url 'title

with blank line'

[foo]
!!! expected
<p>[foo]: /url 'title</p>
<p>with blank line'</p>
<p>[foo]</p>

@@@ Test 198
!!! text
[foo]:
/url

[foo]
!!! expected
<p><a href="/url">foo</a></p>

@@@ Test 199
!!! text
[foo]:

[foo]
!!! expected
<p>[foo]:</p>
<p>[foo]</p>

@@@ Test 200
!!! text
[foo]: <>

[foo]
!!! expected
<p><a href="">foo</a></p>

@@@ Test 201
!!! text
[foo]: <bar>(baz)

[foo]
!!! expected
<p>[foo]: <bar>(baz)</p>
<p>[foo]</p>

@@@ Test 202
!!! text
[foo]: /url\bar\*baz "foo\"bar\baz"

[foo]
!!! expected
<p><a href="/url%5Cbar*baz" title="foo&quot;bar\baz">foo</a></p>

@@@ Test 203
!!! text
[foo]

[foo]: url
!!! expected
<p><a href="url">foo</a></p>

@@@ Test 204
!!! text
[foo]

[foo]: first
[foo]: second
!!! expected
<p><a href="first">foo</a></p>

@@@ Test 205
!!! text
[FOO]: /url

[Foo]
!!! expected
<p><a href="/url">Foo</a></p>

@@@ Test 206
!!! text
[ΑΓΩ]: /φου

[αγω]
!!! expected
<p><a href="/%CF%86%CE%BF%CF%85">αγω</a></p>

@@@ Test 207
!!! text
[foo]: /url
!!! expected

@@@ Test 208
!!! text
[
foo
]: /url
bar
!!! expected
<p>bar</p>

@@@ Test 209
!!! text
[foo]: /url "title" ok
!!! expected
<p>[foo]: /url &quot;title&quot; ok</p>

@@@ Test 210
!!! text
[foo]: /url
"title" ok
!!! expected
<p>&quot;title&quot; ok</p>

@@@ Test 211
!!! text
    [foo]: /url "title"

[foo]
!!! expected
<pre><code>[foo]: /url &quot;title&quot;
</code></pre>
<p>[foo]</p>

@@@ Test 212
!!! text
```
[foo]: /url
```

[foo]
!!! expected
<pre><code>[foo]: /url
</code></pre>
<p>[foo]</p>

@@@ Test 213
!!! text
Foo
[bar]: /baz

[bar]
!!! expected
<p>Foo
[bar]: /baz</p>
<p>[bar]</p>

@@@ Test 214
!!! text
# [Foo]
[foo]: /url
> bar
!!! expected
<h1><a href="/url">Foo</a></h1>
<blockquote>
<p>bar</p>
</blockquote>

@@@ Test 215
!!! text
[foo]: /url
bar
===
[foo]
!!! expected
<h1>bar</h1>
<p><a href="/url">foo</a></p>

@@@ Test 216
!!! text
[foo]: /url
===
[foo]
!!! expected
<p>===
<a href="/url">foo</a></p>

@@@ Test 217
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

@@@ Test 218
!!! text
[foo]

> [foo]: /url
!!! expected
<p><a href="/url">foo</a></p>
<blockquote>
</blockquote>

@@@ Test 219
!!! text
aaa

bbb
!!! expected
<p>aaa</p>
<p>bbb</p>

@@@ Test 220
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

@@@ Test 221
!!! text
aaa


bbb
!!! expected
<p>aaa</p>
<p>bbb</p>

@@@ Test 222
!!! text
  aaa
 bbb
!!! expected
<p>aaa
bbb</p>

@@@ Test 223
!!! text
aaa
             bbb
                                       ccc
!!! expected
<p>aaa
bbb
ccc</p>

@@@ Test 224
!!! text
   aaa
bbb
!!! expected
<p>aaa
bbb</p>

@@@ Test 225
!!! text
    aaa
bbb
!!! expected
<pre><code>aaa
</code></pre>
<p>bbb</p>

@@@ Test 226
!!! text
aaa     
bbb     
!!! expected
<p>aaa<br />
bbb</p>

@@@ Test 227
!!! text
  

aaa
  

# aaa

  
!!! expected
<p>aaa</p>
<h1>aaa</h1>

@@@ Test 228
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

@@@ Test 229
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

@@@ Test 230
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

@@@ Test 231
!!! text
    > # Foo
    > bar
    > baz
!!! expected
<pre><code>&gt; # Foo
&gt; bar
&gt; baz
</code></pre>

@@@ Test 232
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

@@@ Test 233
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

@@@ Test 234
!!! text
> foo
---
!!! expected
<blockquote>
<p>foo</p>
</blockquote>
<hr />

@@@ Test 235
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

@@@ Test 236
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

@@@ Test 237
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

@@@ Test 238
!!! text
> foo
    - bar
!!! expected
<blockquote>
<p>foo
- bar</p>
</blockquote>

@@@ Test 239
!!! text
>
!!! expected
<blockquote>
</blockquote>

@@@ Test 240
!!! text
>
>  
> 
!!! expected
<blockquote>
</blockquote>

@@@ Test 241
!!! text
>
> foo
>  
!!! expected
<blockquote>
<p>foo</p>
</blockquote>

@@@ Test 242
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

@@@ Test 243
!!! text
> foo
> bar
!!! expected
<blockquote>
<p>foo
bar</p>
</blockquote>

@@@ Test 244
!!! text
> foo
>
> bar
!!! expected
<blockquote>
<p>foo</p>
<p>bar</p>
</blockquote>

@@@ Test 245
!!! text
foo
> bar
!!! expected
<p>foo</p>
<blockquote>
<p>bar</p>
</blockquote>

@@@ Test 246
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

@@@ Test 247
!!! text
> bar
baz
!!! expected
<blockquote>
<p>bar
baz</p>
</blockquote>

@@@ Test 248
!!! text
> bar

baz
!!! expected
<blockquote>
<p>bar</p>
</blockquote>
<p>baz</p>

@@@ Test 249
!!! text
> bar
>
baz
!!! expected
<blockquote>
<p>bar</p>
</blockquote>
<p>baz</p>

@@@ Test 250
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

@@@ Test 251
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

@@@ Test 252
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

@@@ Test 253
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

@@@ Test 254
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

@@@ Test 255
!!! text
- one

 two
!!! expected
<ul>
<li>one</li>
</ul>
<p>two</p>

@@@ Test 256
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

@@@ Test 257
!!! text
 -    one

     two
!!! expected
<ul>
<li>one</li>
</ul>
<pre><code> two
</code></pre>

@@@ Test 258
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

@@@ Test 259
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

@@@ Test 260
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

@@@ Test 261
!!! text
-one

2.two
!!! expected
<p>-one</p>
<p>2.two</p>

@@@ Test 262
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

@@@ Test 263
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

@@@ Test 264
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

@@@ Test 265
!!! text
123456789. ok
!!! expected
<ol start="123456789">
<li>ok</li>
</ol>

@@@ Test 266
!!! text
1234567890. not ok
!!! expected
<p>1234567890. not ok</p>

@@@ Test 267
!!! text
0. ok
!!! expected
<ol start="0">
<li>ok</li>
</ol>

@@@ Test 268
!!! text
003. ok
!!! expected
<ol start="3">
<li>ok</li>
</ol>

@@@ Test 269
!!! text
-1. not ok
!!! expected
<p>-1. not ok</p>

@@@ Test 270
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

@@@ Test 271
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

@@@ Test 272
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

@@@ Test 273
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

@@@ Test 274
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

@@@ Test 275
!!! text
   foo

bar
!!! expected
<p>foo</p>
<p>bar</p>

@@@ Test 276
!!! text
-    foo

  bar
!!! expected
<ul>
<li>foo</li>
</ul>
<p>bar</p>

@@@ Test 277
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

@@@ Test 278
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

@@@ Test 279
!!! text
-   
  foo
!!! expected
<ul>
<li>foo</li>
</ul>

@@@ Test 280
!!! text
-

  foo
!!! expected
<ul>
<li></li>
</ul>
<p>foo</p>

@@@ Test 281
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

@@@ Test 282
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

@@@ Test 283
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

@@@ Test 284
!!! text
*
!!! expected
<ul>
<li></li>
</ul>

@@@ Test 285
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

@@@ Test 286
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

@@@ Test 287
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

@@@ Test 288
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

@@@ Test 289
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

@@@ Test 290
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

@@@ Test 291
!!! text
  1.  A paragraph
    with two lines.
!!! expected
<ol>
<li>A paragraph
with two lines.</li>
</ol>

@@@ Test 292
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

@@@ Test 293
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

@@@ Test 294
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

@@@ Test 295
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

@@@ Test 296
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

@@@ Test 297
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

@@@ Test 298
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

@@@ Test 299
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

@@@ Test 300
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

@@@ Test 301
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

@@@ Test 302
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

@@@ Test 303
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

@@@ Test 304
!!! text
The number of windows in my house is
14.  The number of doors is 6.
!!! expected
<p>The number of windows in my house is
14.  The number of doors is 6.</p>

@@@ Test 305
!!! text
The number of windows in my house is
1.  The number of doors is 6.
!!! expected
<p>The number of windows in my house is</p>
<ol>
<li>The number of doors is 6.</li>
</ol>

@@@ Test 306
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

@@@ Test 307
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

@@@ Test 308
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

@@@ Test 309
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

@@@ Test 310
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

@@@ Test 311
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

@@@ Test 312
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

@@@ Test 313
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

@@@ Test 314
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

@@@ Test 315
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

@@@ Test 316
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

@@@ Test 317
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

@@@ Test 318
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

@@@ Test 319
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

@@@ Test 320
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

@@@ Test 321
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

@@@ Test 322
!!! text
- a
!!! expected
<ul>
<li>a</li>
</ul>

@@@ Test 323
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

@@@ Test 324
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

@@@ Test 325
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

@@@ Test 326
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

@@@ Test 327
!!! text
`hi`lo`
!!! expected
<p><code>hi</code>lo`</p>

@@@ Test 328
!!! text
`foo`
!!! expected
<p><code>foo</code></p>

@@@ Test 329
!!! text
`` foo ` bar ``
!!! expected
<p><code>foo ` bar</code></p>

@@@ Test 330
!!! text
` `` `
!!! expected
<p><code>``</code></p>

@@@ Test 331
!!! text
`  ``  `
!!! expected
<p><code> `` </code></p>

@@@ Test 332
!!! text
` a`
!!! expected
<p><code> a</code></p>

@@@ Test 333
!!! text
` b `
!!! expected
<p><code> b </code></p>

@@@ Test 334
!!! text
` `
`  `
!!! expected
<p><code> </code>
<code>  </code></p>

@@@ Test 335
!!! text
``
foo
bar  
baz
``
!!! expected
<p><code>foo bar   baz</code></p>

@@@ Test 336
!!! text
``
foo 
``
!!! expected
<p><code>foo </code></p>

@@@ Test 337
!!! text
`foo   bar 
baz`
!!! expected
<p><code>foo   bar  baz</code></p>

@@@ Test 338
!!! text
`foo\`bar`
!!! expected
<p><code>foo\</code>bar`</p>

@@@ Test 339
!!! text
``foo`bar``
!!! expected
<p><code>foo`bar</code></p>

@@@ Test 340
!!! text
` foo `` bar `
!!! expected
<p><code>foo `` bar</code></p>

@@@ Test 341
!!! text
*foo`*`
!!! expected
<p>*foo<code>*</code></p>

@@@ Test 342
!!! text
[not a `link](/foo`)
!!! expected
<p>[not a <code>link](/foo</code>)</p>

@@@ Test 343
!!! text
`<a href="`">`
!!! expected
<p><code>&lt;a href=&quot;</code>&quot;&gt;`</p>

@@@ Test 344
!!! text
<a href="`">`
!!! expected
<p><a href="`">`</p>

@@@ Test 345
!!! text
`<https://foo.bar.`baz>`
!!! expected
<p><code>&lt;https://foo.bar.</code>baz&gt;`</p>

@@@ Test 346
!!! text
<https://foo.bar.`baz>`
!!! expected
<p><a href="https://foo.bar.%60baz">https://foo.bar.`baz</a>`</p>

@@@ Test 347
!!! text
```foo``
!!! expected
<p>```foo``</p>

@@@ Test 348
!!! text
`foo
!!! expected
<p>`foo</p>

@@@ Test 349
!!! text
`foo``bar``
!!! expected
<p>`foo<code>bar</code></p>

@@@ Test 350
!!! text
*foo bar*
!!! expected
<p><em>foo bar</em></p>

@@@ Test 351
!!! text
a * foo bar*
!!! expected
<p>a * foo bar*</p>

@@@ Test 352
!!! text
a*"foo"*
!!! expected
<p>a*&quot;foo&quot;*</p>

@@@ Test 353
!!! text
* a *
!!! expected
<p>* a *</p>

@@@ Test 354
!!! text
*$*alpha.

*£*bravo.

*€*charlie.
!!! expected
<p>*$*alpha.</p>
<p>*£*bravo.</p>
<p>*€*charlie.</p>

@@@ Test 355
!!! text
foo*bar*
!!! expected
<p>foo<em>bar</em></p>

@@@ Test 356
!!! text
5*6*78
!!! expected
<p>5<em>6</em>78</p>

@@@ Test 357
!!! text
_foo bar_
!!! expected
<p><em>foo bar</em></p>

@@@ Test 358
!!! text
_ foo bar_
!!! expected
<p>_ foo bar_</p>

@@@ Test 359
!!! text
a_"foo"_
!!! expected
<p>a_&quot;foo&quot;_</p>

@@@ Test 360
!!! text
foo_bar_
!!! expected
<p>foo_bar_</p>

@@@ Test 361
!!! text
5_6_78
!!! expected
<p>5_6_78</p>

@@@ Test 362
!!! text
пристаням_стремятся_
!!! expected
<p>пристаням_стремятся_</p>

@@@ Test 363
!!! text
aa_"bb"_cc
!!! expected
<p>aa_&quot;bb&quot;_cc</p>

@@@ Test 364
!!! text
foo-_(bar)_
!!! expected
<p>foo-<em>(bar)</em></p>

@@@ Test 365
!!! text
_foo*
!!! expected
<p>_foo*</p>

@@@ Test 366
!!! text
*foo bar *
!!! expected
<p>*foo bar *</p>

@@@ Test 367
!!! text
*foo bar
*
!!! expected
<p>*foo bar
*</p>

@@@ Test 368
!!! text
*(*foo)
!!! expected
<p>*(*foo)</p>

@@@ Test 369
!!! text
*(*foo*)*
!!! expected
<p><em>(<em>foo</em>)</em></p>

@@@ Test 370
!!! text
*foo*bar
!!! expected
<p><em>foo</em>bar</p>

@@@ Test 371
!!! text
_foo bar _
!!! expected
<p>_foo bar _</p>

@@@ Test 372
!!! text
_(_foo)
!!! expected
<p>_(_foo)</p>

@@@ Test 373
!!! text
_(_foo_)_
!!! expected
<p><em>(<em>foo</em>)</em></p>

@@@ Test 374
!!! text
_foo_bar
!!! expected
<p>_foo_bar</p>

@@@ Test 375
!!! text
_пристаням_стремятся
!!! expected
<p>_пристаням_стремятся</p>

@@@ Test 376
!!! text
_foo_bar_baz_
!!! expected
<p><em>foo_bar_baz</em></p>

@@@ Test 377
!!! text
_(bar)_.
!!! expected
<p><em>(bar)</em>.</p>

@@@ Test 378
!!! text
**foo bar**
!!! expected
<p><strong>foo bar</strong></p>

@@@ Test 379
!!! text
** foo bar**
!!! expected
<p>** foo bar**</p>

@@@ Test 380
!!! text
a**"foo"**
!!! expected
<p>a**&quot;foo&quot;**</p>

@@@ Test 381
!!! text
foo**bar**
!!! expected
<p>foo<strong>bar</strong></p>

@@@ Test 382
!!! text
__foo bar__
!!! expected
<p><strong>foo bar</strong></p>

@@@ Test 383
!!! text
__ foo bar__
!!! expected
<p>__ foo bar__</p>

@@@ Test 384
!!! text
__
foo bar__
!!! expected
<p>__
foo bar__</p>

@@@ Test 385
!!! text
a__"foo"__
!!! expected
<p>a__&quot;foo&quot;__</p>

@@@ Test 386
!!! text
foo__bar__
!!! expected
<p>foo__bar__</p>

@@@ Test 387
!!! text
5__6__78
!!! expected
<p>5__6__78</p>

@@@ Test 388
!!! text
пристаням__стремятся__
!!! expected
<p>пристаням__стремятся__</p>

@@@ Test 389
!!! text
__foo, __bar__, baz__
!!! expected
<p><strong>foo, <strong>bar</strong>, baz</strong></p>

@@@ Test 390
!!! text
foo-__(bar)__
!!! expected
<p>foo-<strong>(bar)</strong></p>

@@@ Test 391
!!! text
**foo bar **
!!! expected
<p>**foo bar **</p>

@@@ Test 392
!!! text
**(**foo)
!!! expected
<p>**(**foo)</p>

@@@ Test 393
!!! text
*(**foo**)*
!!! expected
<p><em>(<strong>foo</strong>)</em></p>

@@@ Test 394
!!! text
**Gomphocarpus (*Gomphocarpus physocarpus*, syn.
*Asclepias physocarpa*)**
!!! expected
<p><strong>Gomphocarpus (<em>Gomphocarpus physocarpus</em>, syn.
<em>Asclepias physocarpa</em>)</strong></p>

@@@ Test 395
!!! text
**foo "*bar*" foo**
!!! expected
<p><strong>foo &quot;<em>bar</em>&quot; foo</strong></p>

@@@ Test 396
!!! text
**foo**bar
!!! expected
<p><strong>foo</strong>bar</p>

@@@ Test 397
!!! text
__foo bar __
!!! expected
<p>__foo bar __</p>

@@@ Test 398
!!! text
__(__foo)
!!! expected
<p>__(__foo)</p>

@@@ Test 399
!!! text
_(__foo__)_
!!! expected
<p><em>(<strong>foo</strong>)</em></p>

@@@ Test 400
!!! text
__foo__bar
!!! expected
<p>__foo__bar</p>

@@@ Test 401
!!! text
__пристаням__стремятся
!!! expected
<p>__пристаням__стремятся</p>

@@@ Test 402
!!! text
__foo__bar__baz__
!!! expected
<p><strong>foo__bar__baz</strong></p>

@@@ Test 403
!!! text
__(bar)__.
!!! expected
<p><strong>(bar)</strong>.</p>

@@@ Test 404
!!! text
*foo [bar](/url)*
!!! expected
<p><em>foo <a href="/url">bar</a></em></p>

@@@ Test 405
!!! text
*foo
bar*
!!! expected
<p><em>foo
bar</em></p>

@@@ Test 406
!!! text
_foo __bar__ baz_
!!! expected
<p><em>foo <strong>bar</strong> baz</em></p>

@@@ Test 407
!!! text
_foo _bar_ baz_
!!! expected
<p><em>foo <em>bar</em> baz</em></p>

@@@ Test 408
!!! text
__foo_ bar_
!!! expected
<p><em><em>foo</em> bar</em></p>

@@@ Test 409
!!! text
*foo *bar**
!!! expected
<p><em>foo <em>bar</em></em></p>

@@@ Test 410
!!! text
*foo **bar** baz*
!!! expected
<p><em>foo <strong>bar</strong> baz</em></p>

@@@ Test 411
!!! text
*foo**bar**baz*
!!! expected
<p><em>foo<strong>bar</strong>baz</em></p>

@@@ Test 412
!!! text
*foo**bar*
!!! expected
<p><em>foo**bar</em></p>

@@@ Test 413
!!! text
***foo** bar*
!!! expected
<p><em><strong>foo</strong> bar</em></p>

@@@ Test 414
!!! text
*foo **bar***
!!! expected
<p><em>foo <strong>bar</strong></em></p>

@@@ Test 415
!!! text
*foo**bar***
!!! expected
<p><em>foo<strong>bar</strong></em></p>

@@@ Test 416
!!! text
foo***bar***baz
!!! expected
<p>foo<em><strong>bar</strong></em>baz</p>

@@@ Test 417
!!! text
foo******bar*********baz
!!! expected
<p>foo<strong><strong><strong>bar</strong></strong></strong>***baz</p>

@@@ Test 418
!!! text
*foo **bar *baz* bim** bop*
!!! expected
<p><em>foo <strong>bar <em>baz</em> bim</strong> bop</em></p>

@@@ Test 419
!!! text
*foo [*bar*](/url)*
!!! expected
<p><em>foo <a href="/url"><em>bar</em></a></em></p>

@@@ Test 420
!!! text
** is not an empty emphasis
!!! expected
<p>** is not an empty emphasis</p>

@@@ Test 421
!!! text
**** is not an empty strong emphasis
!!! expected
<p>**** is not an empty strong emphasis</p>

@@@ Test 422
!!! text
**foo [bar](/url)**
!!! expected
<p><strong>foo <a href="/url">bar</a></strong></p>

@@@ Test 423
!!! text
**foo
bar**
!!! expected
<p><strong>foo
bar</strong></p>

@@@ Test 424
!!! text
__foo _bar_ baz__
!!! expected
<p><strong>foo <em>bar</em> baz</strong></p>

@@@ Test 425
!!! text
__foo __bar__ baz__
!!! expected
<p><strong>foo <strong>bar</strong> baz</strong></p>

@@@ Test 426
!!! text
____foo__ bar__
!!! expected
<p><strong><strong>foo</strong> bar</strong></p>

@@@ Test 427
!!! text
**foo **bar****
!!! expected
<p><strong>foo <strong>bar</strong></strong></p>

@@@ Test 428
!!! text
**foo *bar* baz**
!!! expected
<p><strong>foo <em>bar</em> baz</strong></p>

@@@ Test 429
!!! text
**foo*bar*baz**
!!! expected
<p><strong>foo<em>bar</em>baz</strong></p>

@@@ Test 430
!!! text
***foo* bar**
!!! expected
<p><strong><em>foo</em> bar</strong></p>

@@@ Test 431
!!! text
**foo *bar***
!!! expected
<p><strong>foo <em>bar</em></strong></p>

@@@ Test 432
!!! text
**foo *bar **baz**
bim* bop**
!!! expected
<p><strong>foo <em>bar <strong>baz</strong>
bim</em> bop</strong></p>

@@@ Test 433
!!! text
**foo [*bar*](/url)**
!!! expected
<p><strong>foo <a href="/url"><em>bar</em></a></strong></p>

@@@ Test 434
!!! text
__ is not an empty emphasis
!!! expected
<p>__ is not an empty emphasis</p>

@@@ Test 435
!!! text
____ is not an empty strong emphasis
!!! expected
<p>____ is not an empty strong emphasis</p>

@@@ Test 436
!!! text
foo ***
!!! expected
<p>foo ***</p>

@@@ Test 437
!!! text
foo *\**
!!! expected
<p>foo <em>*</em></p>

@@@ Test 438
!!! text
foo *_*
!!! expected
<p>foo <em>_</em></p>

@@@ Test 439
!!! text
foo *****
!!! expected
<p>foo *****</p>

@@@ Test 440
!!! text
foo **\***
!!! expected
<p>foo <strong>*</strong></p>

@@@ Test 441
!!! text
foo **_**
!!! expected
<p>foo <strong>_</strong></p>

@@@ Test 442
!!! text
**foo*
!!! expected
<p>*<em>foo</em></p>

@@@ Test 443
!!! text
*foo**
!!! expected
<p><em>foo</em>*</p>

@@@ Test 444
!!! text
***foo**
!!! expected
<p>*<strong>foo</strong></p>

@@@ Test 445
!!! text
****foo*
!!! expected
<p>***<em>foo</em></p>

@@@ Test 446
!!! text
**foo***
!!! expected
<p><strong>foo</strong>*</p>

@@@ Test 447
!!! text
*foo****
!!! expected
<p><em>foo</em>***</p>

@@@ Test 448
!!! text
foo ___
!!! expected
<p>foo ___</p>

@@@ Test 449
!!! text
foo _\__
!!! expected
<p>foo <em>_</em></p>

@@@ Test 450
!!! text
foo _*_
!!! expected
<p>foo <em>*</em></p>

@@@ Test 451
!!! text
foo _____
!!! expected
<p>foo _____</p>

@@@ Test 452
!!! text
foo __\___
!!! expected
<p>foo <strong>_</strong></p>

@@@ Test 453
!!! text
foo __*__
!!! expected
<p>foo <strong>*</strong></p>

@@@ Test 454
!!! text
__foo_
!!! expected
<p>_<em>foo</em></p>

@@@ Test 455
!!! text
_foo__
!!! expected
<p><em>foo</em>_</p>

@@@ Test 456
!!! text
___foo__
!!! expected
<p>_<strong>foo</strong></p>

@@@ Test 457
!!! text
____foo_
!!! expected
<p>___<em>foo</em></p>

@@@ Test 458
!!! text
__foo___
!!! expected
<p><strong>foo</strong>_</p>

@@@ Test 459
!!! text
_foo____
!!! expected
<p><em>foo</em>___</p>

@@@ Test 460
!!! text
**foo**
!!! expected
<p><strong>foo</strong></p>

@@@ Test 461
!!! text
*_foo_*
!!! expected
<p><em><em>foo</em></em></p>

@@@ Test 462
!!! text
__foo__
!!! expected
<p><strong>foo</strong></p>

@@@ Test 463
!!! text
_*foo*_
!!! expected
<p><em><em>foo</em></em></p>

@@@ Test 464
!!! text
****foo****
!!! expected
<p><strong><strong>foo</strong></strong></p>

@@@ Test 465
!!! text
____foo____
!!! expected
<p><strong><strong>foo</strong></strong></p>

@@@ Test 466
!!! text
******foo******
!!! expected
<p><strong><strong><strong>foo</strong></strong></strong></p>

@@@ Test 467
!!! text
***foo***
!!! expected
<p><em><strong>foo</strong></em></p>

@@@ Test 468
!!! text
_____foo_____
!!! expected
<p><em><strong><strong>foo</strong></strong></em></p>

@@@ Test 469
!!! text
*foo _bar* baz_
!!! expected
<p><em>foo _bar</em> baz_</p>

@@@ Test 470
!!! text
*foo __bar *baz bim__ bam*
!!! expected
<p><em>foo <strong>bar *baz bim</strong> bam</em></p>

@@@ Test 471
!!! text
**foo **bar baz**
!!! expected
<p>**foo <strong>bar baz</strong></p>

@@@ Test 472
!!! text
*foo *bar baz*
!!! expected
<p>*foo <em>bar baz</em></p>

@@@ Test 473
!!! text
*[bar*](/url)
!!! expected
<p>*<a href="/url">bar*</a></p>

@@@ Test 474
!!! text
_foo [bar_](/url)
!!! expected
<p>_foo <a href="/url">bar_</a></p>

@@@ Test 475
!!! text
*<img src="foo" title="*"/>
!!! expected
<p>*<img src="foo" title="*"/></p>

@@@ Test 476
!!! text
**<a href="**">
!!! expected
<p>**<a href="**"></p>

@@@ Test 477
!!! text
__<a href="__">
!!! expected
<p>__<a href="__"></p>

@@@ Test 478
!!! text
*a `*`*
!!! expected
<p><em>a <code>*</code></em></p>

@@@ Test 479
!!! text
_a `_`_
!!! expected
<p><em>a <code>_</code></em></p>

@@@ Test 480
!!! text
**a<https://foo.bar/?q=**>
!!! expected
<p>**a<a href="https://foo.bar/?q=**">https://foo.bar/?q=**</a></p>

@@@ Test 481
!!! text
__a<https://foo.bar/?q=__>
!!! expected
<p>__a<a href="https://foo.bar/?q=__">https://foo.bar/?q=__</a></p>

@@@ Test 482
!!! text
[link](/uri "title")
!!! expected
<p><a href="/uri" title="title">link</a></p>

@@@ Test 483
!!! text
[link](/uri)
!!! expected
<p><a href="/uri">link</a></p>

@@@ Test 484
!!! text
[](./target.md)
!!! expected
<p><a href="./target.md"></a></p>

@@@ Test 485
!!! text
[link]()
!!! expected
<p><a href="">link</a></p>

@@@ Test 486
!!! text
[link](<>)
!!! expected
<p><a href="">link</a></p>

@@@ Test 487
!!! text
[]()
!!! expected
<p><a href=""></a></p>

@@@ Test 488
!!! text
[link](/my uri)
!!! expected
<p>[link](/my uri)</p>

@@@ Test 489
!!! text
[link](</my uri>)
!!! expected
<p><a href="/my%20uri">link</a></p>

@@@ Test 490
!!! text
[link](foo
bar)
!!! expected
<p>[link](foo
bar)</p>

@@@ Test 491
!!! text
[link](<foo
bar>)
!!! expected
<p>[link](<foo
bar>)</p>

@@@ Test 492
!!! text
[a](<b)c>)
!!! expected
<p><a href="b)c">a</a></p>

@@@ Test 493
!!! text
[link](<foo\>)
!!! expected
<p>[link](&lt;foo&gt;)</p>

@@@ Test 494
!!! text
[a](<b)c
[a](<b)c>
[a](<b>c)
!!! expected
<p>[a](&lt;b)c
[a](&lt;b)c&gt;
[a](<b>c)</p>

@@@ Test 495
!!! text
[link](\(foo\))
!!! expected
<p><a href="(foo)">link</a></p>

@@@ Test 496
!!! text
[link](foo(and(bar)))
!!! expected
<p><a href="foo(and(bar))">link</a></p>

@@@ Test 497
!!! text
[link](foo(and(bar))
!!! expected
<p>[link](foo(and(bar))</p>

@@@ Test 498
!!! text
[link](foo\(and\(bar\))
!!! expected
<p><a href="foo(and(bar)">link</a></p>

@@@ Test 499
!!! text
[link](<foo(and(bar)>)
!!! expected
<p><a href="foo(and(bar)">link</a></p>

@@@ Test 500
!!! text
[link](foo\)\:)
!!! expected
<p><a href="foo):">link</a></p>

@@@ Test 501
!!! text
[link](#fragment)

[link](https://example.com#fragment)

[link](https://example.com?foo=3#frag)
!!! expected
<p><a href="#fragment">link</a></p>
<p><a href="https://example.com#fragment">link</a></p>
<p><a href="https://example.com?foo=3#frag">link</a></p>

@@@ Test 502
!!! text
[link](foo\bar)
!!! expected
<p><a href="foo%5Cbar">link</a></p>

@@@ Test 503
!!! text
[link](foo%20b&auml;)
!!! expected
<p><a href="foo%20b%C3%A4">link</a></p>

@@@ Test 504
!!! text
[link]("title")
!!! expected
<p><a href="%22title%22">link</a></p>

@@@ Test 505
!!! text
[link](/url "title")
[link](/url 'title')
[link](/url (title))
!!! expected
<p><a href="/url" title="title">link</a>
<a href="/url" title="title">link</a>
<a href="/url" title="title">link</a></p>

@@@ Test 506
!!! text
[link](/url "title \"&quot;")
!!! expected
<p><a href="/url" title="title &quot;&quot;">link</a></p>

@@@ Test 507
!!! text
[link](/url "title")
!!! expected
<p><a href="/url%C2%A0%22title%22">link</a></p>

@@@ Test 508
!!! text
[link](/url "title "and" title")
!!! expected
<p>[link](/url &quot;title &quot;and&quot; title&quot;)</p>

@@@ Test 509
!!! text
[link](/url 'title "and" title')
!!! expected
<p><a href="/url" title="title &quot;and&quot; title">link</a></p>

@@@ Test 510
!!! text
[link](   /uri
  "title"  )
!!! expected
<p><a href="/uri" title="title">link</a></p>

@@@ Test 511
!!! text
[link] (/uri)
!!! expected
<p>[link] (/uri)</p>

@@@ Test 512
!!! text
[link [foo [bar]]](/uri)
!!! expected
<p><a href="/uri">link [foo [bar]]</a></p>

@@@ Test 513
!!! text
[link] bar](/uri)
!!! expected
<p>[link] bar](/uri)</p>

@@@ Test 514
!!! text
[link [bar](/uri)
!!! expected
<p>[link <a href="/uri">bar</a></p>

@@@ Test 515
!!! text
[link \[bar](/uri)
!!! expected
<p><a href="/uri">link [bar</a></p>

@@@ Test 516
!!! text
[link *foo **bar** `#`*](/uri)
!!! expected
<p><a href="/uri">link <em>foo <strong>bar</strong> <code>#</code></em></a></p>

@@@ Test 517
!!! text
[![moon](moon.jpg)](/uri)
!!! expected
<p><a href="/uri"><img src="moon.jpg" alt="moon" /></a></p>

@@@ Test 518
!!! text
[foo [bar](/uri)](/uri)
!!! expected
<p>[foo <a href="/uri">bar</a>](/uri)</p>

@@@ Test 519
!!! text
[foo *[bar [baz](/uri)](/uri)*](/uri)
!!! expected
<p>[foo <em>[bar <a href="/uri">baz</a>](/uri)</em>](/uri)</p>

@@@ Test 520
!!! text
![[[foo](uri1)](uri2)](uri3)
!!! expected
<p><img src="uri3" alt="[foo](uri2)" /></p>

@@@ Test 521
!!! text
*[foo*](/uri)
!!! expected
<p>*<a href="/uri">foo*</a></p>

@@@ Test 522
!!! text
[foo *bar](baz*)
!!! expected
<p><a href="baz*">foo *bar</a></p>

@@@ Test 523
!!! text
*foo [bar* baz]
!!! expected
<p><em>foo [bar</em> baz]</p>

@@@ Test 524
!!! text
[foo <bar attr="](baz)">
!!! expected
<p>[foo <bar attr="](baz)"></p>

@@@ Test 525
!!! text
[foo`](/uri)`
!!! expected
<p>[foo<code>](/uri)</code></p>

@@@ Test 526
!!! text
[foo<https://example.com/?search=](uri)>
!!! expected
<p>[foo<a href="https://example.com/?search=%5D(uri)">https://example.com/?search=](uri)</a></p>

@@@ Test 527
!!! text
[foo][bar]

[bar]: /url "title"
!!! expected
<p><a href="/url" title="title">foo</a></p>

@@@ Test 528
!!! text
[link [foo [bar]]][ref]

[ref]: /uri
!!! expected
<p><a href="/uri">link [foo [bar]]</a></p>

@@@ Test 529
!!! text
[link \[bar][ref]

[ref]: /uri
!!! expected
<p><a href="/uri">link [bar</a></p>

@@@ Test 530
!!! text
[link *foo **bar** `#`*][ref]

[ref]: /uri
!!! expected
<p><a href="/uri">link <em>foo <strong>bar</strong> <code>#</code></em></a></p>

@@@ Test 531
!!! text
[![moon](moon.jpg)][ref]

[ref]: /uri
!!! expected
<p><a href="/uri"><img src="moon.jpg" alt="moon" /></a></p>

@@@ Test 532
!!! text
[foo [bar](/uri)][ref]

[ref]: /uri
!!! expected
<p>[foo <a href="/uri">bar</a>]<a href="/uri">ref</a></p>

@@@ Test 533
!!! text
[foo *bar [baz][ref]*][ref]

[ref]: /uri
!!! expected
<p>[foo <em>bar <a href="/uri">baz</a></em>]<a href="/uri">ref</a></p>

@@@ Test 534
!!! text
*[foo*][ref]

[ref]: /uri
!!! expected
<p>*<a href="/uri">foo*</a></p>

@@@ Test 535
!!! text
[foo *bar][ref]*

[ref]: /uri
!!! expected
<p><a href="/uri">foo *bar</a>*</p>

@@@ Test 536
!!! text
[foo <bar attr="][ref]">

[ref]: /uri
!!! expected
<p>[foo <bar attr="][ref]"></p>

@@@ Test 537
!!! text
[foo`][ref]`

[ref]: /uri
!!! expected
<p>[foo<code>][ref]</code></p>

@@@ Test 538
!!! text
[foo<https://example.com/?search=][ref]>

[ref]: /uri
!!! expected
<p>[foo<a href="https://example.com/?search=%5D%5Bref%5D">https://example.com/?search=][ref]</a></p>

@@@ Test 539
!!! text
[foo][BaR]

[bar]: /url "title"
!!! expected
<p><a href="/url" title="title">foo</a></p>

@@@ Test 540
!!! text
[ẞ]

[SS]: /url
!!! expected
<p><a href="/url">ẞ</a></p>

@@@ Test 541
!!! text
[Foo
  bar]: /url

[Baz][Foo bar]
!!! expected
<p><a href="/url">Baz</a></p>

@@@ Test 542
!!! text
[foo] [bar]

[bar]: /url "title"
!!! expected
<p>[foo] <a href="/url" title="title">bar</a></p>

@@@ Test 543
!!! text
[foo]
[bar]

[bar]: /url "title"
!!! expected
<p>[foo]
<a href="/url" title="title">bar</a></p>

@@@ Test 544
!!! text
[foo]: /url1

[foo]: /url2

[bar][foo]
!!! expected
<p><a href="/url1">bar</a></p>

@@@ Test 545
!!! text
[bar][foo\!]

[foo!]: /url
!!! expected
<p>[bar][foo!]</p>

@@@ Test 546
!!! text
[foo][ref[]

[ref[]: /uri
!!! expected
<p>[foo][ref[]</p>
<p>[ref[]: /uri</p>

@@@ Test 547
!!! text
[foo][ref[bar]]

[ref[bar]]: /uri
!!! expected
<p>[foo][ref[bar]]</p>
<p>[ref[bar]]: /uri</p>

@@@ Test 548
!!! text
[[[foo]]]

[[[foo]]]: /url
!!! expected
<p>[[[foo]]]</p>
<p>[[[foo]]]: /url</p>

@@@ Test 549
!!! text
[foo][ref\[]

[ref\[]: /uri
!!! expected
<p><a href="/uri">foo</a></p>

@@@ Test 550
!!! text
[bar\\]: /uri

[bar\\]
!!! expected
<p><a href="/uri">bar\</a></p>

@@@ Test 551
!!! text
[]

[]: /uri
!!! expected
<p>[]</p>
<p>[]: /uri</p>

@@@ Test 552
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

@@@ Test 553
!!! text
[foo][]

[foo]: /url "title"
!!! expected
<p><a href="/url" title="title">foo</a></p>

@@@ Test 554
!!! text
[*foo* bar][]

[*foo* bar]: /url "title"
!!! expected
<p><a href="/url" title="title"><em>foo</em> bar</a></p>

@@@ Test 555
!!! text
[Foo][]

[foo]: /url "title"
!!! expected
<p><a href="/url" title="title">Foo</a></p>

@@@ Test 556
!!! text
[foo] 
[]

[foo]: /url "title"
!!! expected
<p><a href="/url" title="title">foo</a>
[]</p>

@@@ Test 557
!!! text
[foo]

[foo]: /url "title"
!!! expected
<p><a href="/url" title="title">foo</a></p>

@@@ Test 558
!!! text
[*foo* bar]

[*foo* bar]: /url "title"
!!! expected
<p><a href="/url" title="title"><em>foo</em> bar</a></p>

@@@ Test 559
!!! text
[[*foo* bar]]

[*foo* bar]: /url "title"
!!! expected
<p>[<a href="/url" title="title"><em>foo</em> bar</a>]</p>

@@@ Test 560
!!! text
[[bar [foo]

[foo]: /url
!!! expected
<p>[[bar <a href="/url">foo</a></p>

@@@ Test 561
!!! text
[Foo]

[foo]: /url "title"
!!! expected
<p><a href="/url" title="title">Foo</a></p>

@@@ Test 562
!!! text
[foo] bar

[foo]: /url
!!! expected
<p><a href="/url">foo</a> bar</p>

@@@ Test 563
!!! text
\[foo]

[foo]: /url "title"
!!! expected
<p>[foo]</p>

@@@ Test 564
!!! text
[foo*]: /url

*[foo*]
!!! expected
<p>*<a href="/url">foo*</a></p>

@@@ Test 565
!!! text
[foo][bar]

[foo]: /url1
[bar]: /url2
!!! expected
<p><a href="/url2">foo</a></p>

@@@ Test 566
!!! text
[foo][]

[foo]: /url1
!!! expected
<p><a href="/url1">foo</a></p>

@@@ Test 567
!!! text
[foo]()

[foo]: /url1
!!! expected
<p><a href="">foo</a></p>

@@@ Test 568
!!! text
[foo](not a link)

[foo]: /url1
!!! expected
<p><a href="/url1">foo</a>(not a link)</p>

@@@ Test 569
!!! text
[foo][bar][baz]

[baz]: /url
!!! expected
<p>[foo]<a href="/url">bar</a></p>

@@@ Test 570
!!! text
[foo][bar][baz]

[baz]: /url1
[bar]: /url2
!!! expected
<p><a href="/url2">foo</a><a href="/url1">baz</a></p>

@@@ Test 571
!!! text
[foo][bar][baz]

[baz]: /url1
[foo]: /url2
!!! expected
<p>[foo]<a href="/url1">bar</a></p>

@@@ Test 572
!!! text
![foo](/url "title")
!!! expected
<p><img src="/url" alt="foo" title="title" /></p>

@@@ Test 573
!!! text
![foo *bar*]

[foo *bar*]: train.jpg "train & tracks"
!!! expected
<p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>

@@@ Test 574
!!! text
![foo ![bar](/url)](/url2)
!!! expected
<p><img src="/url2" alt="foo bar" /></p>

@@@ Test 575
!!! text
![foo [bar](/url)](/url2)
!!! expected
<p><img src="/url2" alt="foo bar" /></p>

@@@ Test 576
!!! text
![foo *bar*][]

[foo *bar*]: train.jpg "train & tracks"
!!! expected
<p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>

@@@ Test 577
!!! text
![foo *bar*][foobar]

[FOOBAR]: train.jpg "train & tracks"
!!! expected
<p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>

@@@ Test 578
!!! text
![foo](train.jpg)
!!! expected
<p><img src="train.jpg" alt="foo" /></p>

@@@ Test 579
!!! text
My ![foo bar](/path/to/train.jpg  "title"   )
!!! expected
<p>My <img src="/path/to/train.jpg" alt="foo bar" title="title" /></p>

@@@ Test 580
!!! text
![foo](<url>)
!!! expected
<p><img src="url" alt="foo" /></p>

@@@ Test 581
!!! text
![](/url)
!!! expected
<p><img src="/url" alt="" /></p>

@@@ Test 582
!!! text
![foo][bar]

[bar]: /url
!!! expected
<p><img src="/url" alt="foo" /></p>

@@@ Test 583
!!! text
![foo][bar]

[BAR]: /url
!!! expected
<p><img src="/url" alt="foo" /></p>

@@@ Test 584
!!! text
![foo][]

[foo]: /url "title"
!!! expected
<p><img src="/url" alt="foo" title="title" /></p>

@@@ Test 585
!!! text
![*foo* bar][]

[*foo* bar]: /url "title"
!!! expected
<p><img src="/url" alt="foo bar" title="title" /></p>

@@@ Test 586
!!! text
![Foo][]

[foo]: /url "title"
!!! expected
<p><img src="/url" alt="Foo" title="title" /></p>

@@@ Test 587
!!! text
![foo] 
[]

[foo]: /url "title"
!!! expected
<p><img src="/url" alt="foo" title="title" />
[]</p>

@@@ Test 588
!!! text
![foo]

[foo]: /url "title"
!!! expected
<p><img src="/url" alt="foo" title="title" /></p>

@@@ Test 589
!!! text
![*foo* bar]

[*foo* bar]: /url "title"
!!! expected
<p><img src="/url" alt="foo bar" title="title" /></p>

@@@ Test 590
!!! text
![[foo]]

[[foo]]: /url "title"
!!! expected
<p>![[foo]]</p>
<p>[[foo]]: /url &quot;title&quot;</p>

@@@ Test 591
!!! text
![Foo]

[foo]: /url "title"
!!! expected
<p><img src="/url" alt="Foo" title="title" /></p>

@@@ Test 592
!!! text
!\[foo]

[foo]: /url "title"
!!! expected
<p>![foo]</p>

@@@ Test 593
!!! text
\![foo]

[foo]: /url "title"
!!! expected
<p>!<a href="/url" title="title">foo</a></p>

@@@ Test 594
!!! text
<http://foo.bar.baz>
!!! expected
<p><a href="http://foo.bar.baz">http://foo.bar.baz</a></p>

@@@ Test 595
!!! text
<https://foo.bar.baz/test?q=hello&id=22&boolean>
!!! expected
<p><a href="https://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean">https://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean</a></p>

@@@ Test 596
!!! text
<irc://foo.bar:2233/baz>
!!! expected
<p><a href="irc://foo.bar:2233/baz">irc://foo.bar:2233/baz</a></p>

@@@ Test 597
!!! text
<MAILTO:FOO@BAR.BAZ>
!!! expected
<p><a href="MAILTO:FOO@BAR.BAZ">MAILTO:FOO@BAR.BAZ</a></p>

@@@ Test 598
!!! text
<a+b+c:d>
!!! expected
<p><a href="a+b+c:d">a+b+c:d</a></p>

@@@ Test 599
!!! text
<made-up-scheme://foo,bar>
!!! expected
<p><a href="made-up-scheme://foo,bar">made-up-scheme://foo,bar</a></p>

@@@ Test 600
!!! text
<https://../>
!!! expected
<p><a href="https://../">https://../</a></p>

@@@ Test 601
!!! text
<localhost:5001/foo>
!!! expected
<p><a href="localhost:5001/foo">localhost:5001/foo</a></p>

@@@ Test 602
!!! text
<https://foo.bar/baz bim>
!!! expected
<p>&lt;https://foo.bar/baz bim&gt;</p>

@@@ Test 603
!!! text
<https://example.com/\[\>
!!! expected
<p><a href="https://example.com/%5C%5B%5C">https://example.com/\[\</a></p>

@@@ Test 604
!!! text
<foo@bar.example.com>
!!! expected
<p><a href="mailto:foo@bar.example.com">foo@bar.example.com</a></p>

@@@ Test 605
!!! text
<foo+special@Bar.baz-bar0.com>
!!! expected
<p><a href="mailto:foo+special@Bar.baz-bar0.com">foo+special@Bar.baz-bar0.com</a></p>

@@@ Test 606
!!! text
<foo\+@bar.example.com>
!!! expected
<p>&lt;foo+@bar.example.com&gt;</p>

@@@ Test 607
!!! text
<>
!!! expected
<p>&lt;&gt;</p>

@@@ Test 608
!!! text
< https://foo.bar >
!!! expected
<p>&lt; https://foo.bar &gt;</p>

@@@ Test 609
!!! text
<m:abc>
!!! expected
<p>&lt;m:abc&gt;</p>

@@@ Test 610
!!! text
<foo.bar.baz>
!!! expected
<p>&lt;foo.bar.baz&gt;</p>

@@@ Test 611
!!! text
https://example.com
!!! expected
<p>https://example.com</p>

@@@ Test 612
!!! text
foo@bar.example.com
!!! expected
<p>foo@bar.example.com</p>

@@@ Test 613
!!! text
<a><bab><c2c>
!!! expected
<p><a><bab><c2c></p>

@@@ Test 614
!!! text
<a/><b2/>
!!! expected
<p><a/><b2/></p>

@@@ Test 615
!!! text
<a  /><b2
data="foo" >
!!! expected
<p><a  /><b2
data="foo" ></p>

@@@ Test 616
!!! text
<a foo="bar" bam = 'baz <em>"</em>'
_boolean zoop:33=zoop:33 />
!!! expected
<p><a foo="bar" bam = 'baz <em>"</em>'
_boolean zoop:33=zoop:33 /></p>

@@@ Test 617
!!! text
Foo <responsive-image src="foo.jpg" />
!!! expected
<p>Foo <responsive-image src="foo.jpg" /></p>

@@@ Test 618
!!! text
<33> <__>
!!! expected
<p>&lt;33&gt; &lt;__&gt;</p>

@@@ Test 619
!!! text
<a h*#ref="hi">
!!! expected
<p>&lt;a h*#ref=&quot;hi&quot;&gt;</p>

@@@ Test 620
!!! text
<a href="hi'> <a href=hi'>
!!! expected
<p>&lt;a href=&quot;hi'&gt; &lt;a href=hi'&gt;</p>

@@@ Test 621
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

@@@ Test 622
!!! text
<a href='bar'title=title>
!!! expected
<p>&lt;a href='bar'title=title&gt;</p>

@@@ Test 623
!!! text
</a></foo >
!!! expected
<p></a></foo ></p>

@@@ Test 624
!!! text
</a href="foo">
!!! expected
<p>&lt;/a href=&quot;foo&quot;&gt;</p>

@@@ Test 625
!!! text
foo <!-- this is a --
comment - with hyphens -->
!!! expected
<p>foo <!-- this is a --
comment - with hyphens --></p>

@@@ Test 626
!!! text
foo <!--> foo -->

foo <!---> foo -->
!!! expected
<p>foo <!--> foo --&gt;</p>
<p>foo <!---> foo --&gt;</p>

@@@ Test 627
!!! text
foo <?php echo $a; ?>
!!! expected
<p>foo <?php echo $a; ?></p>

@@@ Test 628
!!! text
foo <!ELEMENT br EMPTY>
!!! expected
<p>foo <!ELEMENT br EMPTY></p>

@@@ Test 629
!!! text
foo <![CDATA[>&<]]>
!!! expected
<p>foo <![CDATA[>&<]]></p>

@@@ Test 630
!!! text
foo <a href="&ouml;">
!!! expected
<p>foo <a href="&ouml;"></p>

@@@ Test 631
!!! text
foo <a href="\*">
!!! expected
<p>foo <a href="\*"></p>

@@@ Test 632
!!! text
<a href="\"">
!!! expected
<p>&lt;a href=&quot;&quot;&quot;&gt;</p>

@@@ Test 633
!!! text
foo  
baz
!!! expected
<p>foo<br />
baz</p>

@@@ Test 634
!!! text
foo\
baz
!!! expected
<p>foo<br />
baz</p>

@@@ Test 635
!!! text
foo       
baz
!!! expected
<p>foo<br />
baz</p>

@@@ Test 636
!!! text
foo  
     bar
!!! expected
<p>foo<br />
bar</p>

@@@ Test 637
!!! text
foo\
     bar
!!! expected
<p>foo<br />
bar</p>

@@@ Test 638
!!! text
*foo  
bar*
!!! expected
<p><em>foo<br />
bar</em></p>

@@@ Test 639
!!! text
*foo\
bar*
!!! expected
<p><em>foo<br />
bar</em></p>

@@@ Test 640
!!! text
`code  
span`
!!! expected
<p><code>code   span</code></p>

@@@ Test 641
!!! text
`code\
span`
!!! expected
<p><code>code\ span</code></p>

@@@ Test 642
!!! text
<a href="foo  
bar">
!!! expected
<p><a href="foo  
bar"></p>

@@@ Test 643
!!! text
<a href="foo\
bar">
!!! expected
<p><a href="foo\
bar"></p>

@@@ Test 644
!!! text
foo\
!!! expected
<p>foo\</p>

@@@ Test 645
!!! text
foo  
!!! expected
<p>foo</p>

@@@ Test 646
!!! text
### foo\
!!! expected
<h3>foo\</h3>

@@@ Test 647
!!! text
### foo  
!!! expected
<h3>foo</h3>

@@@ Test 648
!!! text
foo
baz
!!! expected
<p>foo
baz</p>

@@@ Test 649
!!! text
foo 
 baz
!!! expected
<p>foo
baz</p>

@@@ Test 650
!!! text
hello $.;'there
!!! expected
<p>hello $.;'there</p>

@@@ Test 651
!!! text
Foo χρῆν
!!! expected
<p>Foo χρῆν</p>

@@@ Test 652
!!! text
Multiple     spaces
!!! expected
<p>Multiple     spaces</p>

