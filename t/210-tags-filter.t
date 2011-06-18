#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;
run_tests_by_data();
__DATA__
-
  name: dirify
  template: <mt:Section dirify="1">A Rainy Day</mt:Section>
  expected: a_rainy_day

-
  name: trim_to=6
  template: <mt:Section trim_to="6">A Rainy Day</mt:Section>
  expected: A Rain

-
  name: trim_to=6+...
  template: <mt:Section trim_to="6+...">A Rainy Day</mt:Section>
  expected: A Rain...

-
  name: decode_html
  template: '<mt:Section decode_html="1">&quot;&amp;&lt;&gt;</mt:Section>'
  expected: '"&<>'

-
  name: decode_xml (has CDATA section)
  template: |
    <mt:Section decode_xml="1">
      &quot;&amp;&lt;&gt;&apos;
      <![CDATA[<strong>A Rainy Day</strong>]]>
    </mt:Section>
  expected: |
    &quot;&amp;&lt;&gt;&apos;
    <strong>A Rainy Day</strong>

-
  name: decode_xml (has no CDATA section)
  template: |
    <mt:Section decode_xml="1">
      &quot;&amp;&lt;&gt;&apos;
    </mt:Section>
  expected: |
    "&<>'

-
  name: remove_html
  template: <mt:Section remove_html="1">A <a href="#">Rainy</a> Day</mt:Section>
  expected: A Rainy Day

-
  name: sanitize
  template: <mt:Section sanitize="1"><h1><strong>A Rainy Day</strong></h1></mt:Section>
  expected: <strong>A Rainy Day</strong>

-
  name: encode_html
  template: <mt:Section encode_html="1"><strong>A Rainy Day</strong></mt:Section>
  expected: "&lt;strong&gt;A Rainy Day&lt;/strong&gt;"

-
  name: encode_xml
  template: <mt:Section encode_xml="1"><strong>A Rainy Day</strong></mt:Section>
  expected: <![CDATA[<strong>A Rainy Day</strong>]]>

-
  name: encode_js
  template: <mt:Section encode_js="1">"<script>'</script></mt:Section>
  expected: \"\<s\cript\>\'\<\/s\cript\>

-
  name: encode_php
  template: |
    <mt:Section encode_php="1">
      '"\
      A Rainy Day
      "'
    </mt:Section>
  expected: |
    \'"\\
    A Rainy Day
    "\'

-
  name: encode_php="qq"
  template: |
    <mt:Section encode_php="qq">
      '"\
      A Rainy Day
      "'
    </mt:Section>
  expected: |
    \n  '\"\\\n  A Rainy Day\n  \"'\n

-
  name: encode_php="here"
  template: |
    <mt:Section encode_php="here">
      '"\
      A Rainy Day
      "'
    </mt:Section>
  expected: |
    \n  '"\\\n  A Rainy Day\n  "'\n

-
  name: encode_url
  template: <mt:Section encode_url="1">A Rainy Day</mt:Section>
  expected: "A%20Rainy%20Day"

-
  name: upper_case
  template: <mt:Section upper_case="1">A Rainy Day</mt:Section>
  expected: A RAINY DAY

-
  name: lower_case
  template: <mt:Section lower_case="1">A Rainy Day</mt:Section>
  expected: a rainy day

-
  name: strip_linefeeds
  template: |
    <mt:Section strip_linefeeds="1">
      A Rainy Day
      A Sunny Day
      A Rainy Day
    </mt:Section>
  expected: |
    A Rainy Day  A Sunny Day  A Rainy Day

-
  name: space_pad=30
  template: <mt:Section space_pad="30">A Rainy Day</mt:Section>
  expected: "                   A Rainy Day"

-
  name: space_pad=-30
  template: <mt:Section space_pad="-30">A Rainy Day</mt:Section>
  expected: "A Rainy Day                   "

-
  name: zero_pad=30
  template: <mt:Section zero_pad="30">A Rainy Day</mt:Section>
  expected: 0000000000000000000A Rainy Day

-
  name: sprintf=%030s
  template: <mt:Section sprintf="%030s">A Rainy Day</mt:Section>
  expected: 0000000000000000000A Rainy Day

-
  name: trim
  template: <mt:Section trim="1">   abc   </mt:Section>
  expected: 'abc'
  trim: 0

-
  name: ltrim
  template: <mt:Section ltrim="1">   abc   </mt:Section>
  expected: 'abc   '
  trim: 0

-
  name: rtrim
  template: <mt:Section rtrim="1">   abc   </mt:Section>
  expected: '   abc'
  trim: 0

-
  name: filters=__default__
  template: <mt:Section filters="__default__">abc</mt:Section>
  expected: <p>abc</p>

-
  name: count_paragraphs
  template: |
    <mt:Section count_paragraphs="1">a
      b
      c</mt:Section>
  expected: 3

-
  name: numify
  template: <mt:Section numify="1">-1234567</mt:Section>
  expected: -1,234,567

-
  name: encode_sha1
  template: <mt:Section encode_sha1="1">Foo</mt:Section>
  expected: 201a6b3053cc1422d2c3670b62616221d2290929

-
  name: spacify
  template: <mt:Section spacify=" ">Foo</mt:Section>
  expected: F o o

-
  name: spacify=,
  template: <mt:Section spacify=",">Foo</mt:Section>
  expected: F,o,o

-
  name: count_characters
  template: <mt:Section count_characters="1">Foo</mt:Section>
  expected: 3

-
  name: cat=Bar
  template: <mt:Section cat="Bar">Foo</mt:Section>
  expected: FooBar

-
  name: regex_replace
  template: <mt:Section regex_replace="/fo*/i","Bar">FooBar</mt:Section>
  expected: BarBar

-
  name: count_words
  template: <mt:Section count_words="1">Foo Bar Baz</mt:Section>
  expected: 3

-
  name: capitalize
  template: <mt:Section capitalize="1">foo</mt:Section>
  expected: Foo

-
  name: replace
  template: <mt:Section replace="Bar","Foo">FooBar</mt:Section>
  expected: FooFoo

-
  name: indent=2
  template: |-
    <mt:Section indent="2">Foo
    Bar</mt:Section>
  expected: "  Foo\n  Bar"

-
  name: mteval
  template: |
    <MTSetVar name="foo" value="Foo">
    <MTSetVar name="bar" value="<MTGetVar name='foo'>">
    <MTGetVar name="bar" mteval="1">
  expected: Foo

-
  name: setvar
  template: |
    <MTSetVar name="foo" value="Foo">
    <MTVar name="foo" setvar="bar">
    <MTVar name="bar">
  expected: Foo

-
  name: wrap_text=4
  template: <mt:Section wrap_text="4">1234567890</mt:Section>
  expected: |-
    123
    456
    789
    0

-
  name: nl2br
  template: |-
    <mt:Section nl2br="1">Foo
    Bar</mt:Section>
  expected: Foo<br>Bar
  expected_php: |
    Foo<br />
    Bar

-
  name: nl2br=xhtml
  template: |-
    <mt:Section nl2br="xhtml">Foo
    Bar</mt:Section>
  expected: Foo<br />Bar
  expected_php: |
    Foo<br />
    Bar

-
  name: strip
  template: <mt:Section strip="">  Foo  Bar  </mt:Section>
  expected: FooBar

-
  name: strip=&nbsp;
  template: <mt:Section strip="&nbsp;">  Foo  Bar  </mt:Section>
  expected: '&nbsp;Foo&nbsp;Bar&nbsp;'

-
  name: string_format
  template: <mt:Section string_format="%06d">1</mt:Section>
  expected: 000001

-
  name: _default (has a content)
  template: <mt:Section _default="default">content</mt:Section>
  expected: content

-
  name: _default (has no content)
  template: <mt:Section _default="default"></mt:Section>
  expected: default

-
  name: escape=html2
  template: |
    <mt:Section escape="html">
      <span>Foo</span>
    </mt:Section>
  expected: |
    &lt;span&gt;Foo&lt;/span&gt;

-
  name: escape=htmlall
  skip: Not implemented.
  template: |
    <mt:Section escape="htmlall">
      <span>Foo</span>
    </mt:Section>
  expected: |
    &lt;span&gt;Foo&lt;/span&gt;

-
  name: escape=url
  template: '<mt:Section escape="url">http://example.com/?q=@</mt:Section>'
  expected: |
    http%3A%2F%2Fexample.com%2F%3Fq%3D%40

-
  name: escape=urlpathinfo
  skip: Not implemented.
  template: '<mt:Section escape="url">http://example.com/?q=@</mt:Section>'
  expected: |
    http%3A//example.com/%3Fq%3D%40

-
  name: escape=quotes
  skip: Not implemented.
  template: '<mt:Section escape="quotes">http://example.com/?q=@</mt:Section>'
  expected: |
    http://example.com/?q=@

-
  name: escape=hex
  skip: Not implemented.
  template: '<mt:Section escape="hex">http://example.com/?q=@</mt:Section>'
  expected: |
    %68%74%74%70%3a%2f%2f%65%78%61%6d%70%6c%65%2e%63%6f%6d%2f%3f%71%3d%40

-
  name: escape=hexentity
  skip: Not implemented.
  template: '<mt:Section escape="hexentity">http://example.com/?q=@</mt:Section>'
  expected: |
    &#x68;&#x74;&#x74;&#x70;&#x3a;&#x2f;&#x2f;&#x65;&#x78;&#x61;&#x6d;&#x70;&#x6c;&#x65;&#x2e;&#x63;&#x6f;&#x6d;&#x2f;&#x3f;&#x71;&#x3d;&#x40;

-
  name: escape=decentity
  skip: Not implemented.
  template: '<mt:Section escape="decentity">http://example.com/?q=@</mt:Section>'
  expected: |
    &#104;&#116;&#116;&#112;&#58;&#47;&#47;&#101;&#120;&#97;&#109;&#112;&#108;&#101;&#46;&#99;&#111;&#109;&#47;&#63;&#113;&#61;&#64;

-
  name: escape=javascript
  skip: Not implemented.
  template: '<mt:Section escape="javascript"><script>alert("test");</script></mt:Section>'
  expected: |
    \<s\cript\>alert(\"test\");\<\/s\cript\>

-
  name: escape=mail
  skip: Not implemented.
  template: '<mt:Section escape="mail">test@example.com</mt:Section>'
  expected: |
    test [AT] example [DOT] com

-
  name: escape=nonstd
  skip: Not implemented.
  template: '<mt:Section escape="nonstd"><span>Foo</span></mt:Section>'
  expected: |
    <span>Foo</span>

-
  name: nofollowfy
  template: |
    <mt:Section nofollowfy="1">
      <a href="http://example.com/">Example</a>
    </mt:Section>
  expected: |
    <a href="http://example.com/" rel="nofollow">Example</a>

-
  name: nofollowfy (already has a attribute "rel")
  template: |
    <mt:Section nofollowfy="1">
      <a href="http://example.com/" rel="next">Example</a>
    </mt:Section>
  expected: |
    <a href="http://example.com/" rel="nofollow next">Example</a>

######## numify

######## mteval

######## encode_sha1

######## setvar

######## nofollowfy

######## filters

######## trim_to

######## trim

######## ltrim

######## rtrim

######## decode_html

######## decode_xml

######## remove_html

######## dirify

######## sanitize

######## encode_html

######## encode_xml

######## encode_js

######## encode_php

######## encode_url

######## upper_case

######## lower_case

######## strip_linefeeds

######## space_pad

######## zero_pad

######## string_format

######## sprintf

######## regex_replace

######## capitalize

######## count_characters

######## cat

######## count_paragraphs

######## count_words

######## escape

######## indent

######## nl2br

######## replace

######## spacify

######## strip

######## strip_tags

######## _default

######## wrap_text


