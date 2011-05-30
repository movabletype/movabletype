#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;
run_tests_by_data();
__DATA__
-
  name: test item 84
  template: <MTEntries lastn="1"><MTEntryTitle dirify="1"></MTEntries>
  expected: a_rainy_day

-
  name: test item 85
  template: <MTEntries lastn="1"><MTEntryTitle trim_to="6"></MTEntries>
  expected: A Rain

-
  name: test item 86
  template: <MTEntries lastn="1"><MTEntryTitle decode_html="1"></MTEntries>
  expected: A Rainy Day

-
  name: test item 87
  template: <MTEntries lastn="1"><MTEntryTitle decode_xml="1"></MTEntries>
  expected: A Rainy Day

-
  name: test item 88
  template: <MTEntries lastn="1"><MTEntryTitle remove_html="1"></MTEntries>
  expected: A Rainy Day

-
  name: test item 89
  template: |
    <MTEntries lastn="1" sanitize="1">
      <h1><strong><MTEntryTitle></strong></h1>
    </MTEntries>
  expected: <strong>A Rainy Day</strong>

-
  name: test item 90
  template: <MTEntries lastn="1" encode_html="1"><strong><MTEntryTitle></strong></MTEntries>
  expected: "&lt;strong&gt;A Rainy Day&lt;/strong&gt;"

-
  name: test item 91
  template: <MTEntries lastn="1" encode_xml="1"><strong><MTEntryTitle></strong></MTEntries>
  expected: <![CDATA[<strong>A Rainy Day</strong>]]>

-
  name: test item 92
  template: <MTEntries lastn="1" encode_js="1">"<MTEntryTitle>"</MTEntries>
  expected: \"A Rainy Day\"

-
  name: test item 93
  template: <MTEntries lastn="1" encode_php="1">'<MTEntryTitle>'</MTEntries>
  expected: \'A Rainy Day\'

-
  name: test item 94
  template: <MTEntries lastn="1"><MTEntryTitle encode_url="1"></MTEntries>
  expected: "A%20Rainy%20Day"

-
  name: test item 95
  template: <MTEntries lastn="1"><MTEntryTitle upper_case="1"></MTEntries>
  expected: A RAINY DAY

-
  name: test item 96
  template: <MTEntries lastn="1"><MTEntryTitle lower_case="1"></MTEntries>
  expected: a rainy day

-
  name: test item 97
  template: |-
    <MTEntries lastn="1" strip_linefeeds="1">
      <MTEntryTitle>
    </MTEntries>
  expected: A Rainy Day

-
  name: test item 98
  template: <MTEntries lastn="1"><MTEntryTitle space_pad="30"></MTEntries>
  expected: "                   A Rainy Day"

-
  name: test item 99
  template: <MTEntries lastn="1"><MTEntryTitle space_pad="-30"></MTEntries>
  expected: "A Rainy Day                   "

-
  name: test item 100
  template: <MTEntries lastn="1"><MTEntryTitle zero_pad="30"></MTEntries>
  expected: 0000000000000000000A Rainy Day

-
  name: test item 101
  template: |
    <MTEntries lastn="1"><MTEntryTitle sprintf="%030s"></MTEntries>
  expected: 0000000000000000000A Rainy Day

-
  name: test item 146
  template: <MTEntries lastn="1"><MTEntryTitle lower_case="1"></MTEntries>
  expected: a rainy day

-
  name: test item 171
  template: <MTSetVar name="x" value="   abc   "><MTGetVar name="x" trim="1">
  expected: abc

-
  name: test item 172
  template: <MTSetVar name="x" value="   abc   "><MTGetVar name="x" ltrim="1">
  expected: "abc   "

-
  name: test item 173
  template: <MTSetVar name="x" value="   abc"><MTGetVar name="x" rtrim="1">
  expected: "   abc"

-
  name: test item 174
  template: <MTSetVar name="x" value="abc"><MTGetVar name="x" filters="__default__">
  expected: <p>abc</p>

-
  name: test item 569
  template: |-
    <MTSetVarBlock name="foo">a
    b
    c</MTSetVarBlock><MTGetVar name="foo" count_paragraphs="1">
  expected: 3

-
  name: test item 570
  template: |
    <MTSetVarBlock name="foo">-1234567</MTSetVarBlock>
    <MTGetVar name="foo" numify="1">
  expected: -1,234,567

-
  name: test item 571
  template: |
    <MTSetVarBlock name="foo">Foo</MTSetVarBlock>
    <MTGetVar name="foo" encode_sha1="1">
  expected: 201a6b3053cc1422d2c3670b62616221d2290929

-
  name: test item 572
  template: |
    <MTSetVarBlock name="foo">Foo</MTSetVarBlock>
    <MTGetVar name="foo" spacify=" ">
  expected: F o o

-
  name: test item 573
  template: |
    <MTSetVarBlock name="foo">Foo</MTSetVarBlock>
    <MTGetVar name="foo" count_characters="1">
  expected: 3

-
  name: test item 574
  template: |
    <MTSetVarBlock name="foo">Foo</MTSetVarBlock>
    <MTGetVar name="foo" cat="Bar">
  expected: FooBar

-
  name: test item 575
  template: |
    <MTSetVarBlock name="foo">FooBar</MTSetVarBlock>
    <MTGetVar name="foo" regex_replace="/Fo*/i","Bar">
  expected: BarBar

-
  name: test item 576
  template: |
    <MTSetVarBlock name="foo">Foo Bar Baz</MTSetVarBlock>
    <MTGetVar name="foo" count_words="1">
  expected: 3

-
  name: test item 577
  template: |
    <MTSetVarBlock name="foo">foo</MTSetVarBlock>
    <MTGetVar name="foo" capitalize="1">
  expected: Foo

-
  name: test item 578
  template: |
    <MTSetVarBlock name="foo">FooBar</MTSetVarBlock>
    <MTGetVar name="foo" replace="Bar","Foo">
  expected: FooFoo

-
  name: test item 579
  template: |-
    <MTSetVarBlock name="foo">aaa
    bbb</MTSetVarBlock>
    <MTGetVar name="foo" indent="2">
  expected: "  aaa\n  bbb"

-
  name: test item 580
  template: |-
    <MTSetVarBlock name="foo">aaa
    bbb</MTSetVarBlock>
    <MTGetVar name="foo" indent="2">
  expected: "  aaa\n  bbb"

-
  name: test item 581
  template: |
    <MTSetVar name="foo" value="Foo">
    <MTSetVar name="bar" value="<MTGetVar name='foo'>">
    <MTGetVar name="bar" mteval="1">
  expected: Foo

-
  name: test item 582
  template: |
    <MTSetVarBlock name="foo"><span>Foo</span></MTSetVarBlock>
    <MTGetVar name="foo" strip_tags="1">
  expected: Foo

-
  name: test item 583
  template: |
    <MTSetVar name="foo" value="Foo">
    <MTVar name="foo" setvar="bar">
    <MTVar name="bar">
  expected: Foo

-
  name: test item 584
  template: |
    <MTSetVarBlock name="foo">1234567890</MTSetVarBlock>
    <MTGetVar name="foo" wrap_text="4">
  expected: |-
    123
    456
    789
    0

-
  name: test item 585
  template: |-
    <MTSetVarBlock name="foo">123
    456</MTSetVarBlock>
    <MTGetVar name="foo" nl2br="xhtml" strip="">
  expected: 123<br/>456

-
  name: test item 586
  template: |
    <MTSetVarBlock name="foo">  Foo  Bar  </MTSetVarBlock>
    <MTGetVar name="foo" strip="">
  expected: FooBar

-
  name: test item 587
  template: |
    <MTSetVarBlock name="foo">  Foo  Bar  </MTSetVarBlock>
    <MTGetVar name="foo" strip="&nbsp;">
  expected: |
    &nbsp;Foo&nbsp;Bar&nbsp;

-
  name: test item 588
  template: |
    <MTSetVarBlock name="foo">1</MTSetVarBlock>
    <MTGetVar name="foo" string_format="%06d">
  expected: 000001

-
  name: test item 589
  template: |
    <MTSetVarBlock name="foo"></MTSetVarBlock>
    <MTGetVar name="foo" _default="Default">
  expected: Default

-
  name: test item 590
  template: |
    <MTSetVarBlock name="foo">Foo</MTSetVarBlock>
    <MTGetVar name="foo" _default="Default">
  expected: Foo

-
  name: test item 591
  template: |
    <MTSetVarBlock name="foo"><span>Foo</span></MTSetVarBlock>
    <MTGetVar name="foo" escape="html">
  expected: |
    &lt;span&gt;Foo&lt;/span&gt;

-
  name: test item 592
  run: 0
  template: |
    <MTSetVarBlock name="foo"><span>Foo</span></MTSetVarBlock>
    <MTGetVar name="foo" escape="htmlall">
  expected: |
    &lt;span&gt;Foo&lt;/span&gt;

-
  name: test item 593
  template: |
    <MTSetVarBlock name="foo">http://example.com/?q=@</MTSetVarBlock>
    <MTGetVar name="foo" escape="url">
  expected: |
    http%3A%2F%2Fexample.com%2F%3Fq%3D%40

-
  name: test item 594
  run: 0
  template: |
    <MTSetVarBlock name="foo">http://example.com/?q=@</MTSetVarBlock>
    <MTGetVar name="foo" escape="urlpathinfo">
  expected: |
    http%3A//example.com/%3Fq%3D%40

-
  name: test item 595
  run: 0
  template: |
    <MTSetVarBlock name="foo">http://example.com/?q=@</MTSetVarBlock>
    <MTGetVar name="foo" escape="quotes">
  expected: |
    http://example.com/?q=@

-
  name: test item 596
  run: 0
  template: |
    <MTSetVarBlock name="foo">http://example.com/?q=@</MTSetVarBlock>
    <MTGetVar name="foo" escape="hex">
  expected: |
    %68%74%74%70%3a%2f%2f%65%78%61%6d%70%6c%65%2e%63%6f%6d%2f%3f%71%3d%40

-
  name: test item 597
  run: 0
  template: |
    <MTSetVarBlock name="foo">http://example.com/?q=@</MTSetVarBlock>
    <MTGetVar name="foo" escape="hexentity">
  expected: |
    &#x68;&#x74;&#x74;&#x70;&#x3a;&#x2f;&#x2f;&#x65;&#x78;&#x61;&#x6d;&#x70;&#x6c;&#x65;&#x2e;&#x63;&#x6f;&#x6d;&#x2f;&#x3f;&#x71;&#x3d;&#x40;

-
  name: test item 598
  run: 0
  template: |
    <MTSetVarBlock name="foo">http://example.com/?q=@</MTSetVarBlock><MTGetVar name="foo" escape="decentity">
  expected: |
    &#104;&#116;&#116;&#112;&#58;&#47;&#47;&#101;&#120;&#97;&#109;&#112;&#108;&#101;&#46;&#99;&#111;&#109;&#47;&#63;&#113;&#61;&#64;

-
  name: test item 599
  run: 0
  template: |
    <MTSetVarBlock name="foo"><script>alert("test");</script></MTSetVarBlock>
    <MTGetVar name="foo" escape="javascript">
  expected: |
    \<s\cript\>alert(\"test\");\<\/s\cript\>

-
  name: test item 600
  run: 0
  template: |
    <MTSetVarBlock name="foo">test@example.com</MTSetVarBlock>
    <MTGetVar name="foo" escape="mail">
  expected: |
    test [AT] example [DOT] com

-
  name: test item 601
  run: 0
  template: |
    <MTSetVarBlock name="foo"><span>Foo</span></MTSetVarBlock>
    <MTGetVar name="foo" escape="nonstd">
  expected: |
    <span>Foo</span>

-
  name: test item 602
  template: |
    <MTSetVarBlock name="foo"><a href="http://example.com/">Example</a></MTSetVarBlock>
    <MTGetVar name="foo" nofollowfy="1">
  expected: |
    <a href="http://example.com/" rel="nofollow">Example</a>

-
  name: test item 603
  template: |
    <MTSetVarBlock name="foo"><a href="http://example.com/" rel="next">Example</a></MTSetVarBlock>
    <MTGetVar name="foo" nofollowfy="1">
  expected: |
    <a href="http://example.com/" rel="nofollow next">Example</a>

-
  name: test item 605
  template: <MTEntries lastn="1"><MTEntryTitle trim_to="6+..."></MTEntries>
  expected: A Rain...

