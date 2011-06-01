#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;
run_tests_by_data();
__DATA__
-
  name: test item 1
  template: ''
  expected: ''

-
  name: test item 15
  template: <MTIfNonEmpty tag="MTDate">nonempty</MTIfNonEmpty>
  expected: nonempty

-
  name: test item 16
  template: ''
  expected: ''

-
  name: test item 17
  template: <MTIfNonZero tag="MTBlogEntryCount">nonzero</MTIfNonZero>
  expected: nonzero

-
  name: test item 45
  template: <MTSetVar name="x" value="x-var"><MTGetVar name="x">
  expected: x-var

-
  name: test item 105
  run: 0
  template: ''
  expected: ''

-
  name: test item 142
  template: disabled
  expected: disabled

-
  name: test item 202
  template: ''
  expected: ''

-
  name: test item 233
  template: <MTSetVar name='x' value='0'><MTIfNonZero tag='GetVar' name='x'><MTElse>0</MTElse></MTIfNonZero>
  expected: 0

-
  name: test item 368
  template: |
    <MTSetVar name='offices' value='San Francisco' index='0'>
    <MTSetVar name='offices' value='Tokyo' function='unshift'>
    <MTSetVarBlock name='offices' index='2'>Paris</MTSetVarBlock>
    --
    <MTGetVar name='offices' function='count'>;
    <MTGetVar name='offices' index='1'>;
    <MTGetVar name='offices' function='shift'>;
    <MTGetVar name='offices' function='count'>;
    <MTGetVar name='offices' index='1'>
  expected: |
    --
    3;
    San Francisco;
    Tokyo;
    2;
    Paris

-
  name: test item 369
  template: |
    <MTSetVar name='MTVersions' key='4.0' value='Athena'>
    <MTSetVarBlock name='MTVersions' key='4.01'>Enterprise Solution</MTSetVarBlock>
    <MTSetVarBlock name='MTVersions' key='4.1'>Boomer</MTSetVarBlock>
    <MTSetVar name='4.2' value='Cal'>
    <MTGetVar name='MTVersions' key='4.0'>;
    <MTGetVar name='MTVersions' key='4.01'>;
    <MTGetVar name='MTVersions' key='4.1'>;
    <MTGetVar name='MTVersions' key='4.2'>;

  expected: |
    Athena;
    Enterprise Solution;
    Boomer;
    ;

-
  name: test item 370
  template: |
    <MTVar name='object1' key='name' value='foo'>
    <MTVar name='object1' key='price' value='1.00'>
    <MTVar name='object2' key='name' value='bar'>
    <MTVar name='object2' key='price' value='1.13'>
    <MTSetVar name='array1' function='push' value='$object1'>
    <MTSetVar name='array1' function='push' value='$object2'>
    <MTLoop name='array1'>
      <MTVar name='name'>(<MTVar name='price'>)<br />
    </MTLoop>
  expected: |
    foo(1.00)<br />
    bar(1.13)<br />

-
  name: test item 371
  template: |
    <MTSetVar name='offices1' value='San Francisco' index='0'>
    <MTSetVar name='offices1' value='Tokyo' function='unshift'>
    <MTSetVarBlock name='offices1' index='2'>Paris</MTSetVarBlock>
    --
    <MTGetVar name='offices1' function='count'>;
    <MTGetVar name='offices1' index='1'>;
    <MTGetVar name='offices1' function='shift'>;
    <MTGetVar name='offices1' function='count'>;
    <MTGetVar name='offices1' index='1'>;
  expected: |
    --
    3;
    San Francisco;
    Tokyo;
    2;
    Paris;

-
  name: test item 372
  template: <MTSetVar name='offices2' value='San Francisco' index='0'><MTSetVar name='offices2' value='Tokyo' function='unshift'><MTSetVarBlock name='offices2' index='2'>Paris</MTSetVarBlock>--<MTSetVarBlock name='count'><MTGetVar name='offices2' function='count' op='sub' value='1'></MTSetVarBlock><MTFor from='0' to='$count' step='1' glue=','><MTGetVar name='offices2' index='$__index__'></MTFor>
  expected: --Tokyo,San Francisco,Paris

-
  name: test item 373
  template: <MTSetHashVar name='MTVersions2'><MTSetVar name='4.0' value='Athena'><MTSetVarBlock name='4.01'>Enterprise Solution</MTSetVarBlock><MTSetVar name='4.1' value='Boomer'><MTVar name='4.2' value='Cal'></MTSetHashVar>--<MTLoop name='MTVersions2' sort_by='value'><MTVar name='__key__'> - <MTVar name='__value__'>;</MTLoop>
  expected: --4.0 - Athena;4.1 - Boomer;4.2 - Cal;4.01 - Enterprise Solution;

-
  name: test item 374
  template: <MTSetHashVar name='MTVersions3'><MTSetVar name='4.0' value='Athena'><MTSetVarBlock name='4.01'>Enterprise Solution</MTSetVarBlock><MTSetVar name='4.1' value='Boomer'></MTSetHashVar><MTVar name='MTVersions3' key='4.2' value='Cal'>--<MTLoop name='MTVersions3' sort_by='key'><MTVar name='__key__'> - <MTVar name='__value__'>;</MTLoop>
  expected: --4.0 - Athena;4.01 - Enterprise Solution;4.1 - Boomer;4.2 - Cal;

-
  name: test item 375
  template: <MTSetVar name='offices3' value='San Francisco' index='0'><MTSetVar name='offices3' value='Tokyo' function='unshift'><MTSetVarBlock name='offices3' index='2'>Paris</MTSetVarBlock>--<MTLoop name='offices3' glue=','><MTVar name='__value__'></MTLoop>
  expected: --Tokyo,San Francisco,Paris

-
  name: test item 376
  template: <MTSetVar name='offices4' value='San Francisco' index='0'><MTSetVar name='offices4' value='Tokyo' function='unshift'><MTSetVarBlock name='offices4' index='2'>Paris</MTSetVarBlock>--<MTLoop name='offices4' glue=',' sort_by='value'><MTVar name='__value__'></MTLoop>
  expected: --Paris,San Francisco,Tokyo

-
  name: test item 377
  template: "<MTSetVar name='num' op='add' value='99'><MTGetVar name='num'>;<MTGetVar name='num' value='1' op='+'>;<MTSetVar name='num' value='1'><MTGetVar name='num'>;<MTGetVar name='num' value='20' op='mul'>;<MTSetVar name='num' value='2' op='add'><MTGetVar name='num'>;<MTGetVar name='num' value='20' op='*'>;<MTSetVar name='num' value='3' op='*'><MTGetVar name='num'>;<MTGetVar name='num' value='3' op='/'>;<MTSetVar name='num' op='div' value='2'><MTGetVar name='num'>;<MTGetVar name='num' value='0.5' op='-'>;<MTSetVar name='num' op='mod' value='6'><MTGetVar name='num'>;<MTGetVar name='num' value='3' op='%'>;"
  expected: 99;100;1;20;3;60;9;3;4.5;4;4;1;

-
  name: test item 378
  template: <MTSetVar name='num' value='1'><MTGetVar name='num' op='++'>;<MTSetVar name='num' op='inc'><MTGetVar name='num'>;<MTSetVar name='num' op='dec'><MTGetVar name='num'>;<MTGetVar name='num' op='--'>;
  expected: 2;2;1;0;

-
  name: test item 379
  template: <MTSetVar name='offices9[0]' value='San Francisco'><MTSetVar name='unshift(offices9)' value='Tokyo'><MTSetVarBlock name='offices9[2]'>Paris</MTSetVarBlock>--<MTGetVar name='count(offices9)'>;<MTGetVar name='offices9[1]'>;<MTGetVar name='shift(offices9)'>;<MTGetVar name='count(offices9)'>;<MTGetVar name='offices9' index='1'>
  expected: --3;San Francisco;Tokyo;2;Paris

-
  name: test item 380
  template: <MTSetVar name='MTVersions4{4.0}' value='Athena'><MTSetVarBlock name='MTVersions4{4.01}'>Enterprise Solution</MTSetVarBlock><MTSetVarBlock name='MTVersions4{4.1}'>Boomer<MTSetVar name='4.2' value='Cal'></MTSetVarBlock><MTGetVar name='MTVersions4{4.0}'>;<MTGetVar name='MTVersions4{4.01}'>;<MTGetVar name='MTVersions4{4.1}'>;<MTGetVar name='MTVersions4{4.2}'>;
  expected: Athena;Enterprise Solution;Boomer;;

-
  name: test item 381
  template: <MTVar name='object3{name}' value='foo'><MTVar name='object3{price}' value='1.00'><MTVar name='object4{name}' value='bar'><MTVar name='object4{price}' value='1.13'><MTSetVar name='push(array2)' value='$object3'><MTSetVar name='push(array2)' value='$object4'><MTLoop name='array2'><MTVar name='name'>(<MTVar name='price'>)<br /></MTLoop>
  expected: foo(1.00)<br />bar(1.13)<br />

-
  name: test item 382
  template: <MTSetVar name='offices5[0]' value='San Francisco'><MTSetVar name='unshift(offices5)' value='Tokyo'><MTSetVarBlock name='offices5[2]'>Paris</MTSetVarBlock>--<MTGetVar name='count(offices5)'>;<MTGetVar name='offices5[1]'>;<MTGetVar name='shift(offices5)'>;<MTGetVar name='count(offices5)'>;<MTGetVar name='offices5[1]'>
  expected: --3;San Francisco;Tokyo;2;Paris

-
  name: test item 383
  template: <MTSetVar name='offices6[0]' value='San Francisco'><MTSetVar name='unshift(offices6)' value='Tokyo'><MTSetVarBlock name='offices6[2]'>Paris</MTSetVarBlock>--<MTSetVarBlock name='count'><MTGetVar name='count(offices6)' op='--'></MTSetVarBlock><MTFor from='0' to='$count' increment='1' glue=','><MTGetVar name='offices6[$__index__]'></MTFor>
  expected: --Tokyo,San Francisco,Paris

-
  name: test item 384
  template: <MTSetVar name='MTVersions5{4.0}' value='Athena'><MTSetVarBlock name='MTVersions5{4.01}'>Enterprise Solution</MTSetVarBlock><MTSetVarBlock name='MTVersions5{4.1}'>Boomer</MTSetVarBlock><MTSetHashVar name='MTVersions5'><MTSetVar name='4.2' value='Cal'></MTSetHashVar>--<MTLoop name='MTVersions5' sort_by='key reverse'><MTVar name='__key__'> - <MTVar name='__value__'>;</MTLoop>
  expected: --4.2 - Cal;4.1 - Boomer;4.01 - Enterprise Solution;4.0 - Athena;

-
  name: test item 385
  template: <MTSetVar name='MTVersions6{4.0}' value='Athena'><MTSetVarBlock name='MTVersions6{4.01}'>Enterprise Solution</MTSetVarBlock><MTSetVarBlock name='MTVersions6{4.1}'>Boomer<MTSetVar name='4.2' value='Cal'></MTSetVarBlock>--<MTLoop name='MTVersions6' sort_by='key'><MTVar name='__key__'> - <MTVar name='__value__'>;</MTLoop>
  expected: --4.0 - Athena;4.01 - Enterprise Solution;4.1 - Boomer;

-
  name: test item 386
  template: <MTSetVar name='offices7' value='San Francisco' index='0'><MTSetVar name='unshift(offices7)' value='Tokyo'><MTSetVarBlock name='offices7' index='2'>Paris</MTSetVarBlock>--<MTVar name='offices7[1]'>,<MTVar name='shift(offices7)'>,<MTSetVar name='i' value='1'><MTVar name='offices7[$i]'>
  expected: --San Francisco,Tokyo,Paris

-
  name: test item 387
  template: <MTSetVar name='offices8' value='San Francisco' index='0'><MTSetVar name='unshift(offices8)' value='Tokyo'><MTSetVarBlock name='offices8' index='2'>Paris</MTSetVarBlock><MTSetVar name='var_offices' value='$offices8'>--<MTVar name='var_offices[1]'>,<MTVar name='shift(var_offices)'>,<MTSetVar name='i' value='1'><MTVar name='var_offices[$i]'>
  expected: --San Francisco,Tokyo,Paris

-
  name: test item 388
  template: <MTSetVar name='MTVersions7' key='4.0' value='Athena'><MTSetVarBlock name='MTVersions7' key='4.01'>Enterprise Solution</MTSetVarBlock><MTSetVarBlock name='MTVersions7' key='4.1'>Boomer<MTSetVar name='4.2' value='Cal'></MTSetVarBlock><MTSetVar name='var_hash' value='$MTVersions7'><MTGetVar name='var_hash{4.0}'>;<MTGetVar name='var_hash{4.01}'>;<MTGetVar name='var_hash{4.1}'>;<MTGetVar name='var_hash{4.2}'>;
  expected: Athena;Enterprise Solution;Boomer;;

-
  name: test item 389
  template: <MTSetVar name='MTVersions8' key='4.0' value='Athena'><MTSetVarBlock name='MTVersions8' key='4.01'>Enterprise Solution</MTSetVarBlock><MTSetVarBlock name='MTVersions8' key='4.1'>Boomer</MTSetVarBlock><MTSetHashVar name='MTVersions8'><MTSetVarBlock name='4.2'>Cal</MTSetVarBlock></MTSetHashVar><MTGetVar name='delete(MTVersions8{4.0})'>;<MTGetVar name='MTVersions8{4.0}'>;<MTSetVar name='delete(MTVersions8{4.01})'>;<MTGetVar name='MTVersions8{4.01}'>;<MTGetVar name='MTVersions8' function='delete' key='4.2'>;<MTGetVar name='MTVersions8' function='delete' key='4.1'>;<MTGetVar name='MTVersions8' key='4.1'>;
  expected: Athena;;;;Cal;Boomer;;

-
  name: test item 390
  template: <MTSetVar name='offices9' value='San Francisco' index='0'><MTSetVar name='unshift(offices9)' value='Tokyo'><MTSetVarBlock name='offices9' index='2'>Paris</MTSetVarBlock>--<MTIf name='offices9' index='2' eq='Paris'>TRUE<MTElse>FALSE</MTIf>,<MTIf name='offices9[1]' eq='San Francisco'>TRUE<MTElse>FALSE</MTIf>,<MTVar name='idx' value='0'><MTIf name='offices9[$idx]' eq='San Francisco'><MTVar name='offices9[0]'><MTElse name='offices9[2]' eq='San Francisco'>TRUE<MTElse>FALSE</MTIf>,<MTIf name='offices9' index='3' eq='1'><MTIgnore>value is undef so it is always evaluated false.</MTIgnore>TRUE<MTElse>FALSE</MTIf>,
  expected: --TRUE,TRUE,FALSE,FALSE,

-
  name: test item 391
  template: <MTSetVar name='MTVersions8' key='4.0' value='Athena'><MTSetVarBlock name='MTVersions8' key='4.01'>Enterprise Solution</MTSetVarBlock><MTSetVarBlock name='MTVersions8' key='4.1'>Boomer</MTSetVarBlock><MTSetVar name='var_hash' value='$MTVersions8'><MTIf name='var_hash{4.0}' eq='Enterprise Solution'>TRUE<MTElse>FALSE</MTIf>;<MTIf name='var_hash{4.01}' eq='Enterprise Solution'>TRUE<MTElse>FALSE</MTIf>;<MTIf name='var_hash' key='4.2' eq='Boomer'>TRUE<MTElse>FALSE</MTIf>;<MTIf name='MTVersions8{4.1}' ne='Boomer'><MTVar name='MTVersions8{4.1}'><MTElse name='MTVersions8{4.1}' eq='Cal'>TRUE<MTElse>FALSE</MTIf>;
  expected: FALSE;TRUE;FALSE;FALSE;

-
  name: test item 392
  template: <MTSetVar name='num' value='1'><MTGetVar name='num'>;<MTIf name='num' eq='1'>TRUE<MTElse>FALSE</MTIf>;<MTGetVar name='num' value='20' op='mul'>;<MTIf name='num' value='3' op='*' eq='60'>TRUE<MTElse>FALSE</MTIf>;<MTIf name='num' value='3' op='+' eq='4'>TRUE<MTElse name='num' op='+' value='4' eq='5'>555<MTElse>FALSE</MTIf>;
  expected: 1;TRUE;20;FALSE;TRUE;

-
  name: test item 395
  template: <MTSetVar name='val' value='0'><MTIfNonEmpty name="val">zero</MTIfNonEmpty>
  expected: zero

-
  name: test item 396
  template: "<mt:setvar name='foo' value='hoge'><mt:if name='foo' eq='hoge'>value is hoge.<mt:elseif name='foo' eq='koge'>value is koge.<mt:else eq='joge'>value is joge.<mt:elseif eq='moge'>value is moge.<mt:else>value is <mt:getvar name='foo'>.</mt:if>"
  expected: value is hoge.

-
  name: test item 397
  template: "<mt:setvar name='foo' value='koge'><mt:if name='foo' eq='hoge'>value is hoge.<mt:elseif name='foo' eq='koge'>value is koge.<mt:else eq='joge'>value is joge.<mt:elseif eq='moge'>value is moge.<mt:else>value is <mt:getvar name='foo'>.</mt:if>"
  expected: value is koge.

-
  name: test item 398
  template: "<mt:setvar name='foo' value='joge'><mt:if name='foo' eq='hoge'>value is hoge.<mt:elseif name='foo' eq='koge'>value is koge.<mt:else eq='joge'>value is joge.<mt:elseif eq='moge'>value is moge.<mt:else>value is <mt:getvar name='foo'>.</mt:if>"
  expected: value is joge.

-
  name: test item 399
  template: "<mt:setvar name='foo' value='moge'><mt:if name='foo' eq='hoge'>value is hoge.<mt:elseif name='foo' eq='koge'>value is koge.<mt:else eq='joge'>value is joge.<mt:elseif eq='moge'>value is moge.<mt:else>value is <mt:getvar name='foo'>.</mt:if>"
  expected: value is moge.

-
  name: test item 400
  template: "<mt:setvar name='foo' value='poge'><mt:if name='foo' eq='hoge'>value is hoge.<mt:elseif name='foo' eq='koge'>value is koge.<mt:else eq='joge'>value is joge.<mt:elseif eq='moge'>value is moge.<mt:else>value is <mt:getvar name='foo'>.</mt:if>"
  expected: value is poge.

-
  name: test item 401
  template: "<mt:setvar name='foo' value='poge'><mt:if name='foo' eq='hoge'><mt:else>value is <mt:var name='foo'></mt:if>"
  expected: value is poge

-
  name: test item 402
  template: "<mt:setvar name='foo' value='1'><mt:if name='bar'>true<mt:else>false</mt:if>"
  expected: false

-
  name: test item 407
  template: "value is <mt:setvar name='foo' value='poge'><mt:if name='foo' eq='hoge'>hoge<mt:elseif name='foo' eq='moge'>moge<mt:else>false</mt:if>"
  expected: value is false

-
  name: test item 408
  template: "value is <mt:setvar name='foo' value='poge'><mt:if name='foo' eq='hoge'>hoge<mt:else name='foo' eq='moge'>moge<mt:else>false</mt:if>"
  expected: value is false

-
  name: test item 409
  run: 0
  template: "value is <mt:setvar name='foo' value='poge'><mt:if name='foo' eq='hoge'>hoge<mt:elseif eq='moge'>moge<mt:else>false</mt:if>"
  expected: value is false

-
  name: test item 410
  run: 0
  template: "value is <mt:setvar name='foo' value='poge'><mt:if name='foo' eq='hoge'>hoge<mt:else eq='moge'>moge<mt:else>false</mt:if>"
  expected: value is false

-
  name: test item 411
  run: 0
  template: "value is <mt:setvar name='foo' value='poge'><mt:if name='foo' eq='hoge'>hoge<mt:elseif eq='poge'>poge<mt:else>false</mt:if>"
  expected: value is poge

-
  name: test item 412
  run: 0
  template: "value is <mt:setvar name='foo' value='poge'><mt:if name='foo' eq='hoge'>hoge<mt:else eq='poge'>poge<mt:else>false</mt:if>"
  expected: value is poge

-
  name: test item 413
  run: 0
  template: "<mt:var name='ar[0]' value='A'><mt:var name='ar[1]' value='B'><mt:var name='ar[2]' value='C'><mt:loop name='ar'><mt:if name='__value__' eq='A'><mt:var name='__counter__'><mt:elseif eq='B'><mt:var name='__counter__'><mt:else><mt:var name='__counter__'></mt:if></mt:loop>"
  expected: 123

-
  name: test item 414
  run: 0
  template: "<mt:var name='ar[0]' value='A'><mt:var name='ar[1]' value='B'><mt:var name='ar[2]' value='C'><mt:loop name='ar'><mt:if name='__value__' eq='A'><mt:var name='__counter__'><mt:else eq='B'><mt:var name='__counter__'><mt:else><mt:var name='__counter__'></mt:if></mt:loop>"
  expected: 123

-
  name: test item 415
  run: 0
  template: "value is <mt:setvar name='foo' value='fuga'><mt:if name='foo' eq='hoge'>hoge<mt:elseif eq='poge'>poge<mt:elseif eq='fuga'>fuga<mt:else>false</mt:if>"
  expected: value is fuga

-
  name: test item 416
  run: 0
  template: "value is <mt:setvar name='foo' value='fuga'><mt:if name='foo' eq='hoge'>hoge<mt:else eq='poge'>poge<mt:else eq='fuga'>fuga<mt:else>false</mt:if>"
  expected: value is fuga

-
  name: test item 417
  run: 0
  template: "<mt:var name='ar[0]' value='A'><mt:var name='ar[1]' value='B'><mt:var name='ar[2]' value='C'><mt:loop name='ar'><mt:if name='__value__' eq='A'><mt:var name='__counter__'><mt:elseif eq='B'><mt:var name='__counter__'><mt:elseif eq='C'>hoge!<mt:else><mt:var name='__counter__'></mt:if></mt:loop>"
  expected: 12hoge!

-
  name: test item 418
  run: 0
  template: "<mt:var name='ar[0]' value='A'><mt:var name='ar[1]' value='B'><mt:var name='ar[2]' value='C'><mt:loop name='ar'><mt:if name='__value__' eq='A'><mt:var name='__counter__'><mt:else eq='B'><mt:var name='__counter__'><mt:else eq='C'>hoge!<mt:else><mt:var name='__counter__'></mt:if></mt:loop>"
  expected: 12hoge!

-
  name: test item 419
  template: "<mt:setvar name='foo' value='c'><mt:if name='foo' eq='a'>value is a.<mt:elseif eq='b'>value is b.<mt:else eq='c'>value is c.<mt:elseif eq='d'>value is d.<mt:else>value is this: <mt:getvar name='foo'>.</mt:if>"
  expected: value is c.

-
  name: test item 420
  template: "<mt:setvar name='foo' value='c'><mt:setvar name='bar' value='xxx'><mt:if name='foo' eq='a'>value is a.<mt:else><mt:if name='bar' eq='aaa'><mt:else eq='c'>value is c<mt:else eq='xxx'>value is xxx.</mt:if></mt:if>"
  expected: value is xxx.

-
  name: test item 421
  template: "<mt:setvar name='foo' value='c'><mt:setvar name='bar' value='xxx'><mt:if name='foo' eq='a'>value is a.<mt:elseif name='bar' eq='aaa'><mt:else eq='c'>value is c<mt:else eq='xxx'>value is xxx.</mt:if>"
  expected: value is xxx.

-
  name: test item 422
  template: "<mt:var name='foo' value='2'><mt:if name='foo' eq='1'>incorrect<mt:else eq='2'>correct<mt:else eq='3'>incorrect</mt:if>"
  expected: correct

-
  name: test item 423
  template: "<mt:var name='foo1' value='foo-1'><mt:var name='foo2' value='foo-2'><mt:if name='foo1' eq='abc'>incorrect-1<mt:else eq='def'>incorrect-2<mt:else eq='foo-1'>CORRECT-1<mt:if name='foo2' eq='ghi'>incorrect-3<mt:else eq='foo-2'>CORRECT-2<mt:else>incorrect-4</mt:if><mt:else eq='foo-2'>incorrect-5<mt:else>incorrect-6</mt:if>"
  expected: CORRECT-1CORRECT-2

-
  name: test item 526
  template: |-
    <MTSetVars>
    foo=Foo
    </MTSetVars><MTGetVar name='foo'>
  expected: Foo

-
  name: test item 527
  template: <MTSetVarTemplate name='foo_template'><MTSetVar name='foo' value='Bar'></MTSetVarTemplate><MTSetVar name='foo' value='Foo'><MTVar name='foo_template'><MTGetVar name='foo'>
  expected: Bar

-
  name: test item 533
  template: <MTSetVar name='foo' value='Foo'><MTUnless name='foo' eq='Bar'>Content</MTUnless>
  expected: Content

-
  name: test item 534
  template: <MTSetVar name='foo' value='Foo'><MTUnless name='foo' eq='Foo'>Content</MTUnless>
  expected: ''


######## If
## name
## var
## tag
## op
## + or add
## - or sub
## ++ or inc
## -- or dec
## * or mul
## / or div
## % or mod
## value
## eq
## ne
## gt
## lt
## ge
## le
## like
## test

######## Unless

######## Else

######## ElseIf

######## IfNonEmpty
## tag
## name or var

######## IfNonZero
## tag
## name or var

######## Loop
## name
## var
## sort_by (optional)
## glue (optional)
## __first__
## __last__
## __odd__
## __even__
## __key__
## __value__

######## For
## var (optional)
## from (optional; default "0")
## start
## to
## end
## step (optional; default "1")
## increment
## glue (optional)
## __first__
## __last__
## __odd__
## __even__
## __index__
## __counter__

######## SetVarBlock
## var or name (required)
## op (optional)
## prepend (optional)
## append (optional)

######## SetVarTemplate
## var or name (required)

######## SetVars

######## SetHashVar

######## SetVar
## var or name
## value
## op (optional)
## prepend (optional)
## append (optional)

######## GetVar

######## Var
## name (or var)
## value
## op
## prepend
## append
## function
## push
## pop
## unshift
## shift
## count
## delete
## count
## index
## key
## default
## to_json
## glue

######## Ignore

######## TemplateNote

