#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;
run_tests_by_data();
__DATA__
-
  name: IfNonEmpty with an attribute "tag" prints the inner content if the specified tag isn't empty.
  template: <MTIfNonEmpty tag="MTDate">nonempty</MTIfNonEmpty>
  expected: nonempty

-
  name: IfNonEmpty with an attribute "tag" doesn't prints the inner content if the specified tag is empty.
  template: <MTIfNonEmpty tag="MTEntryCategory">nonempty</MTIfNonEmpty>
  expected: ''

-
  name: IfNonZero with an attribute "tag" prints the inner content if the specified tag isn't zero.
  template: <MTIfNonZero tag="MTBlogEntryCount">nonzero</MTIfNonZero>
  expected: nonzero

-
  name: IfNonZero with an attribute "tag" doesn't prints the inner content if the specified tag is zero.
  template: <MTIfNonZero tag="MTCategoryCommentCount">nonzero</MTIfNonZero>
  expected: ''

-
  name: GetVar prints value of specified variable.
  template: <MTGetVar name="x">
  expected: x-var
  var:
    x: x-var

-
  name: SetVar sets value to specified variable.
  template: <MTSetVar name="x" value="x-var"><MTGetVar name="x">
  expected: x-var

-
  name: SetVar with attributes "op=inc" and "value" sets the calculation result.
  template: |
    <MTSetVar name="number" op="inc">
    <MTGetVar name="number">
    <MTSetVar name="number" op="++">
    <MTGetVar name="number">
  expected: |
    7
    8
  var:
    number: 6

-
  name: SetVar with attributes "op=dec" and "value" sets the calculation result.
  template: |
    <MTSetVar name="number" op="dec">
    <MTGetVar name="number">
    <MTSetVar name="number" op="--">
    <MTGetVar name="number">
  expected: |
    5
    4
  var:
    number: 6

-
  name: Else in IfNonZero prints the inner content if the specified tag is zero.
  template: |
    <MTIfNonZero tag='GetVar' name='x'>
      non-zero
      <MTElse>
        zero
      </MTElse>
    </MTIfNonZero>
  expected: zero
  var:
    x: 0

-
  name: GetVar with an attribute "function=count" prints the number of elements in the specified variable.
  template: |
    <MTGetVar name="list0" function="count">
    <MTGetVar name="list1" function="count">
    <MTGetVar name="list2" function="count">
  expected: |
    0
    1
    2
  var:
    list0: []
    list1:
      - 1
    list2:
      - 1
      - 2

-
  name: Loop lists all elements of the specified variable. (for array)
  template: |
    <MTLoop name="list">
      <MTVar name="__value__">
    </MTLoop>
  expected: |
    Foo
    Bar
  var:
    list:
      - Foo
      - Bar

-
  name: Loop lists all elements of the specified variable. (for hash)
  template: |
    <MTLoop name="list" sort_by="key reverse">
      <MTVar name="__key__">: <MTVar name="__value__">
    </MTLoop>
  expected: |
    foo: Foo
    bar: Bar
  var:
    list:
      foo: Foo
      bar: Bar

-
  name: Loop with an attribute "glue" prints content that was joined with ",".
  template:
    <MTSetVar name='offices3' value='San Francisco' index='0'>
    <MTSetVar name='offices3' value='Tokyo' function='unshift'>
    <MTSetVarBlock name='offices3' index='2'>Paris</MTSetVarBlock>
    --<MTLoop name='offices3' glue=','><MTVar name='__value__'></MTLoop>
  expected: --Tokyo,San Francisco,Paris

-
  name: GetVar with an attribute "index" prints the element of the specified index in the variable.
  template: |
    <MTGetVar name='list' index='0'>
    <MTGetVar name='list' index='1'>
  expected: |
    Foo
    Bar
  var:
    list:
      - Foo
      - Bar

-
  name: GetVar with an attribute "key" prints the element of the specified index in the variable.
  template: |
    <MTGetVar name='list' key='foo'>
    <MTGetVar name='list' key='bar'>
  expected: |
    Foo
    Bar
  var:
    list:
      foo: Foo
      bar: Bar

-
  name: SetVar with an attribute "index" sets value to specified index in variable.
  template: |
    <MTSetVar name='list' value='Foo' index='0'>
    <MTSetVar name='list' value='Bar' index='1'>
    <MTLoop name="list">
      <MTVar name="__value__">
    </MTLoop>
  expected: |
    Foo
    Bar

-
  name: SetVar with an attribute "key" sets value to specified key in variable.
  template: |
    <MTSetVar name='list' value='Foo' key='foo'>
    <MTSetVar name='list' value='Bar' key='bar'>
    <MTLoop name="list" sort_by="key reverse">
      <MTVar name="__key__">: <MTVar name="__value__">
    </MTLoop>
  expected: |
    foo: Foo
    bar: Bar

-
  name: SetVar with an attribute "function=unshift" unshift value to specified variable.
  template: |
    <MTSetVar name='list' value='Foo' index='0'>
    <MTSetVar name='list' value='Bar' function='unshift'>
    <MTLoop name="list">
      <MTVar name="__value__">
    </MTLoop>
  expected: |
    Bar
    Foo

-
  name: GetVar with an attribute "function=shift" shifts and prints the first element of the specified variable.
  template: |
    <MTSetVar name='list' value='Foo' index='0'>
    <MTSetVar name='list' value='Bar' index='1'>
    shift: <MTGetVar name='list' function='shift'>
    <MTLoop name="list">
      <MTVar name="__value__">
    </MTLoop>
  expected: |
    shift: Foo
    Bar

-
  name: GetVar with an attribute "function=delete" deletes and prints the element of the specified key.
  template: |
    <MTSetVar name='list' value='Foo' key='foo'>
    <MTSetVar name='list' value='Bar' key='bar'>
    <MTGetVar name='list' function='delete' key='foo'>
    <MTLoop name="list" sort_by="key reverse">
      <MTVar name="__key__">: <MTVar name="__value__">
    </MTLoop>
  expected: |
    Foo
    bar: Bar

-
  name: SetVarBlock with an attribute "index" sets value to specified index in variable.
  template: |
    <MTSetVarBlock name='list' index='0'>Foo</MTSetVarBlock>
    <MTSetVarBlock name='list' index='1'>Bar</MTSetVarBlock>
    <MTLoop name="list">
      <MTVar name="__value__">
    </MTLoop>
  expected: |
    Foo
    Bar

-
  name: Loop extracts the hash object for the current context.
  template: |
    <MTVar name='object1' key='name' value='foo'>
    <MTVar name='object1' key='price' value='1.00'>
    <MTVar name='object2' key='name' value='bar'>
    <MTVar name='object2' key='price' value='1.13'>
    <MTSetVar name='array1' function='push' value='$object1'>
    <MTSetVar name='array1' function='push' value='$object2'>
    <MTLoop name='array1'>
      <MTVar name='name'>(<MTVar name='price'>)
    </MTLoop>
  expected: |
    foo(1.00)
    bar(1.13)

-
  name: GetVar with attributes "op=sub" and "value" prints the calculation result.
  template: |
    <MTGetVar name="number" op="sub" value="1">
    <MTGetVar name="number" op="-" value="1">
  expected: |
    5
    5
  var:
    number: 6

-
  name: GetVar with attributes "op=add" and "value" prints the calculation result.
  template: |
    <MTGetVar name="number" op="add" value="1">
    <MTGetVar name="number" op="+" value="1">
  expected: |
    7
    7
  var:
    number: 6

-
  name: GetVar with attributes "op=nul" and "value" prints the calculation result.
  template: |
    <MTGetVar name="number" op="mul" value="2">
    <MTGetVar name="number" op="*" value="2">
  expected: |
    12
    12
  var:
    number: 6

-
  name: GetVar with attributes "op=div" and "value" prints the calculation result.
  template: |
    <MTGetVar name="number" op="div" value="2">
    <MTGetVar name="number" op="/" value="2">
  expected: |
    3
    3
  var:
    number: 6

-
  name: GetVar with attributes "op=inc" and "value" prints the calculation result.
  template: |
    <MTGetVar name="number" op="inc">
    <MTGetVar name="number" op="++">
  expected: |
    7
    7
  var:
    number: 6

-
  name: GetVar with attributes "op=dec" and "value" prints the calculation result.
  template: |
    <MTGetVar name="number" op="dec">
    <MTGetVar name="number" op="--">
  expected: |
    5
    5
  var:
    number: 6

-
  name: GetVar with attributes "op=mod" and "value" prints the calculation result.
  template: |
    <MTGetVar name="number" op="mod" value="5">
    <MTGetVar name="number" op="%" value="5">
  expected: |
    1
    1
  var:
    number: 6

-
  name: For repeats the inner content by specified times.
  template: |
    <MTFor from='0' to='3' step='1' glue=','><MTGetVar name='list' index='$__index__'></MTFor>
  expected: Foo,Bar,Baz
  var:
    list:
      - Foo
      - Bar
      - Baz

-
  name: SetHashVar sets value to specified key in the variable.
  template: |
    <MTSetHashVar name='MTVersions2'>
      <MTSetVar name='4.0' value='Athena'>
      <MTSetVarBlock name='4.01'>Enterprise Solution</MTSetVarBlock>
      <MTSetVar name='4.1' value='Boomer'>
      <MTVar name='4.2' value='Cal'>
    </MTSetHashVar>
    --
    <MTLoop name='MTVersions2' sort_by='value'>
      <MTVar name='__key__'> - <MTVar name='__value__'>
    </MTLoop>
  expected: |
    --
    4.0 - Athena
    4.1 - Boomer
    4.2 - Cal
    4.01 - Enterprise Solution

-
  name: Loop with an attribute "sort_by=key" sorts by value and prints the content.
  template: |
    <MTSetHashVar name='MTVersions3'>
      <MTSetVar name='4.0' value='Athena'>
      <MTSetVarBlock name='4.01'>Enterprise Solution</MTSetVarBlock>
      <MTSetVar name='4.1' value='Boomer'>
    </MTSetHashVar>
    <MTVar name='MTVersions3' key='4.2' value='Cal'>
    --
    <MTLoop name='MTVersions3' sort_by='key'>
      <MTVar name='__key__'> - <MTVar name='__value__'>
    </MTLoop>
  expected: |
    --
    4.0 - Athena
    4.01 - Enterprise Solution
    4.1 - Boomer
    4.2 - Cal

-
  name: Loop with an attribute "sort_by=value" sorts by value and prints the content.
  template: |
    <MTSetVar name='offices4' value='San Francisco' index='0'>
    <MTSetVar name='offices4' value='Tokyo' function='unshift'>
    <MTSetVarBlock name='offices4' index='2'>Paris</MTSetVarBlock>
    --<MTLoop name='offices4' glue=',' sort_by='value'><MTVar name='__value__'></MTLoop>
  expected: --Paris,San Francisco,Tokyo

-
  name: SetVar and GetVar has a syntax sugar "variable_name[index]".
  template: |
    <MTSetVar name='offices9[0]' value='San Francisco'>
    <MTSetVar name='unshift(offices9)' value='Tokyo'>
    <MTSetVarBlock name='offices9[2]'>Paris</MTSetVarBlock>
    --<MTGetVar name='count(offices9)'>;<MTGetVar name='offices9[1]'>;<MTGetVar name='shift(offices9)'>;<MTGetVar name='count(offices9)'>;<MTGetVar name='offices9' index='1'>
  expected: --3;San Francisco;Tokyo;2;Paris

-
  name: SetVar and GetVar has a syntax sugar "variable_name{key}".
  template: |
    <MTSetVar name='MTVersions4{4.0}' value='Athena'>
    <MTSetVarBlock name='MTVersions4{4.01}'>Enterprise Solution</MTSetVarBlock>
    <MTSetVarBlock name='MTVersions4{4.1}'>Boomer<MTSetVar name='4.2' value='Cal'></MTSetVarBlock>
    <MTGetVar name='MTVersions4{4.0}'>;<MTGetVar name='MTVersions4{4.01}'>;<MTGetVar name='MTVersions4{4.1}'>;<MTGetVar name='MTVersions4{4.2}'>;
  expected: Athena;Enterprise Solution;Boomer;;

-
  name: SetVar and GetVar has a syntax sugar "operation(variable_name)".
  template: |
    <MTVar name='object3{name}' value='foo'>
    <MTVar name='object3{price}' value='1.00'>
    <MTVar name='object4{name}' value='bar'>
    <MTVar name='object4{price}' value='1.13'>
    <MTSetVar name='push(array2)' value='$object3'>
    <MTSetVar name='push(array2)' value='$object4'>
    <MTLoop name='array2'>
      <MTVar name='name'> (<MTVar name='price'>)
    </MTLoop>
  expected: |
    foo (1.00)
    bar (1.13)

-
  name: Loop with an attribute "sort_by=key reverse" lists elements that are sorted by the key.
  template: |
    <MTSetVar name='MTVersions5{4.0}' value='Athena'>
    <MTSetVarBlock name='MTVersions5{4.01}'>Enterprise Solution</MTSetVarBlock>
    <MTSetVarBlock name='MTVersions5{4.1}'>Boomer</MTSetVarBlock>
    <MTSetHashVar name='MTVersions5'>
      <MTSetVar name='4.2' value='Cal'>
    </MTSetHashVar>
    --<MTLoop name='MTVersions5' sort_by='key reverse'><MTVar name='__key__'> - <MTVar name='__value__'>;</MTLoop>
  expected: --4.2 - Cal;4.1 - Boomer;4.01 - Enterprise Solution;4.0 - Athena;

-
  name: Loop with an attribute "sort_by=key" lists elements that are sorted by the key.
  template: |
    <MTSetVar name='MTVersions6{4.0}' value='Athena'>
    <MTSetVarBlock name='MTVersions6{4.01}'>Enterprise Solution</MTSetVarBlock>
    <MTSetVarBlock name='MTVersions6{4.1}'>Boomer<MTSetVar name='4.2' value='Cal'></MTSetVarBlock>
    --<MTLoop name='MTVersions6' sort_by='key'><MTVar name='__key__'> - <MTVar name='__value__'>;</MTLoop>

  expected: --4.0 - Athena;4.01 - Enterprise Solution;4.1 - Boomer;

-
  name: 'SetVar and GetVar has a syntax sugar "variable_name[$template_variable]".'
  template: |
    <MTSetVar name='offices7' value='San Francisco' index='0'>
    <MTSetVar name='unshift(offices7)' value='Tokyo'>
    <MTSetVarBlock name='offices7' index='2'>Paris</MTSetVarBlock>
    --<MTVar name='offices7[1]'>,<MTVar name='shift(offices7)'>,<MTSetVar name='i' value='1'><MTVar name='offices7[$i]'>
  expected: --San Francisco,Tokyo,Paris

-
  name: 'SetVar with attributes "name" and "value=$name" copies "$name" onto another name. (for array)'
  template: |
    <MTSetVar name='offices8' value='San Francisco' index='0'>
    <MTSetVar name='unshift(offices8)' value='Tokyo'>
    <MTSetVarBlock name='offices8' index='2'>Paris</MTSetVarBlock>
    <MTSetVar name='var_offices' value='$offices8'>
    --<MTVar name='var_offices[1]'>,<MTVar name='shift(var_offices)'>,<MTSetVar name='i' value='1'><MTVar name='var_offices[$i]'>
  expected: --San Francisco,Tokyo,Paris

-
  name: 'SetVar with attributes "name" and "value=$name" copies "$name" onto another name. (for hash)'
  template: |
    <MTSetVar name='MTVersions7' key='4.0' value='Athena'>
    <MTSetVarBlock name='MTVersions7' key='4.01'>Enterprise Solution</MTSetVarBlock>
    <MTSetVarBlock name='MTVersions7' key='4.1'>Boomer<MTSetVar name='4.2' value='Cal'></MTSetVarBlock>
    <MTSetVar name='var_hash' value='$MTVersions7'>
    <MTGetVar name='var_hash{4.0}'>;<MTGetVar name='var_hash{4.01}'>;<MTGetVar name='var_hash{4.1}'>;<MTGetVar name='var_hash{4.2}'>;
  expected: Athena;Enterprise Solution;Boomer;;

-
  name: SetVar and GetVar has a syntax sugar "delete(variable_name{key})".
  template: |
    <MTSetVar name='MTVersions8' key='4.0' value='Athena'>
    <MTSetVarBlock name='MTVersions8' key='4.01'>Enterprise Solution</MTSetVarBlock>
    <MTSetVarBlock name='MTVersions8' key='4.1'>Boomer</MTSetVarBlock>
    <MTSetHashVar name='MTVersions8'>
      <MTSetVarBlock name='4.2'>Cal</MTSetVarBlock>
    </MTSetHashVar>
    <MTGetVar name='delete(MTVersions8{4.0})'>;<MTGetVar name='MTVersions8{4.0}'>;<MTSetVar name='delete(MTVersions8{4.01})'>;<MTGetVar name='MTVersions8{4.01}'>;<MTGetVar name='MTVersions8' function='delete' key='4.2'>;<MTGetVar name='MTVersions8' function='delete' key='4.1'>;<MTGetVar name='MTVersions8' key='4.1'>;
  expected: Athena;;;;Cal;Boomer;;

-
  name: If with attributes "name" and "index" can compare the element of array to value.
  template: |
    <MTSetVar name='offices9' value='San Francisco' index='0'>
    <MTSetVar name='unshift(offices9)' value='Tokyo'>
    <MTSetVarBlock name='offices9' index='2'>Paris</MTSetVarBlock>
    --<MTIf name='offices9' index='2' eq='Paris'>TRUE<MTElse>FALSE</MTIf>,<MTIf name='offices9[1]' eq='San Francisco'>TRUE<MTElse>FALSE</MTIf>,<MTVar name='idx' value='0'><MTIf name='offices9[$idx]' eq='San Francisco'><MTVar name='offices9[0]'><MTElse name='offices9[2]' eq='San Francisco'>TRUE<MTElse>FALSE</MTIf>,<MTIf name='offices9' index='3' eq='1'><MTIgnore>value is undef so it is always evaluated false.</MTIgnore>TRUE<MTElse>FALSE</MTIf>,
  expected: --TRUE,TRUE,FALSE,FALSE,

-
  name: If with attributes "name" and "key" can compare the element of hash to value.
  template: |
    <MTSetVar name='MTVersions8' key='4.0' value='Athena'>
    <MTSetVarBlock name='MTVersions8' key='4.01'>Enterprise Solution</MTSetVarBlock>
    <MTSetVarBlock name='MTVersions8' key='4.1'>Boomer</MTSetVarBlock>
    <MTSetVar name='var_hash' value='$MTVersions8'>
    <MTIf name='var_hash{4.0}' eq='Enterprise Solution'>TRUE<MTElse>FALSE</MTIf>;<MTIf name='var_hash{4.01}' eq='Enterprise Solution'>TRUE<MTElse>FALSE</MTIf>;<MTIf name='var_hash' key='4.2' eq='Boomer'>TRUE<MTElse>FALSE</MTIf>;<MTIf name='MTVersions8{4.1}' ne='Boomer'><MTVar name='MTVersions8{4.1}'><MTElse name='MTVersions8{4.1}' eq='Cal'>TRUE<MTElse>FALSE</MTIf>;
  expected: FALSE;TRUE;FALSE;FALSE;

-
  name: If with attributes "name" and "op" can compare the calculation result to value.
  template: |
    <MTSetVar name='num' value='1'>
    <MTGetVar name='num'>;<MTIf name='num' eq='1'>TRUE<MTElse>FALSE</MTIf>;<MTGetVar name='num' value='20' op='mul'>;<MTIf name='num' value='3' op='*' eq='60'>TRUE<MTElse>FALSE</MTIf>;<MTIf name='num' value='3' op='+' eq='4'>TRUE<MTElse name='num' op='+' value='4' eq='5'>555<MTElse>FALSE</MTIf>;
  expected: 1;TRUE;20;FALSE;TRUE;

-
  name: Complex conditions of If and Else. (foo=hoge)
  template: |
    <mt:setvar name='foo' value='hoge'>
    <mt:if name='foo' eq='hoge'>
    value is hoge.<mt:elseif name='foo' eq='koge'>
    value is koge.<mt:else eq='joge'>
    value is joge.<mt:elseif eq='moge'>
    value is moge.<mt:else>
    value is <mt:getvar name='foo'>.</mt:if>
  expected: value is hoge.

-
  name: Complex conditions of If and Else. (foo=koge)
  template: |
    <mt:setvar name='foo' value='koge'>
    <mt:if name='foo' eq='hoge'>
    value is hoge.<mt:elseif name='foo' eq='koge'>
    value is koge.<mt:else eq='joge'>
    value is joge.<mt:elseif eq='moge'>
    value is moge.<mt:else>
    value is <mt:getvar name='foo'>.</mt:if>
  expected: value is koge.

-
  name: Complex conditions of If and Else. (foo=joge)
  template: |
    <mt:setvar name='foo' value='joge'>
    <mt:if name='foo' eq='hoge'>
    value is hoge.<mt:elseif name='foo' eq='koge'>
    value is koge.<mt:else eq='joge'>
    value is joge.<mt:elseif eq='moge'>
    value is moge.<mt:else>
    value is <mt:getvar name='foo'>.</mt:if>
  expected: value is joge.

-
  name: Complex conditions of If and Else. (foo=moge)
  template: |
    <mt:setvar name='foo' value='moge'>
    <mt:if name='foo' eq='hoge'>
    value is hoge.<mt:elseif name='foo' eq='koge'>
    value is koge.<mt:else eq='joge'>
    value is joge.<mt:elseif eq='moge'>
    value is moge.<mt:else>
    value is <mt:getvar name='foo'>.</mt:if>
  expected: value is moge.

-
  name: Complex conditions of If and Else. (foo=poge)
  template: |
    <mt:setvar name='foo' value='poge'>
    <mt:if name='foo' eq='hoge'>
    value is hoge.<mt:elseif name='foo' eq='koge'>
    value is koge.<mt:else eq='joge'>
    value is joge.<mt:elseif eq='moge'>
    value is moge.<mt:else>
    value is <mt:getvar name='foo'>.</mt:if>
  expected: value is poge.

-
  name: "Else in If prints the inner content if the condition isn't ture."
  template: |
    <mt:setvar name='foo' value='poge'>
    <mt:if name='foo' eq='hoge'>
    <mt:else>
    value is <mt:var name='foo'>
    </mt:if>
  expected: value is poge

-
  name: "Else in If prints the inner content if the specified variable isn't defined."
  template: |
    <mt:setvar name='foo' value='1'>
    <mt:if name='bar'>true<mt:else>false</mt:if>
  expected: false

-
  name: ElseIf can handle attributes "name" and "eq".
  template: |
    value is <mt:setvar name='foo' value='poge'><mt:if name='foo' eq='hoge' strip_linefeeds='1'>
    hoge<mt:elseif name='foo' eq='moge'>
    moge<mt:else>
    false</mt:if>
  expected: value is false

-
  name: Else can handle attributes "name" and "eq".
  template: |
    value is <mt:setvar name='foo' value='poge'><mt:if name='foo' eq='hoge' strip_linefeeds='1'>
    hoge<mt:else name='foo' eq='moge'>
    moge<mt:else>
    false</mt:if>
  expected: value is false

-
  name: ElseIf can handle an attribute "eq" and can omit "name".
  template: |
    value is <mt:setvar name='foo' value='poge'><mt:if name='foo' eq='hoge' strip_linefeeds='1'>
    hoge<mt:elseif eq='moge'>
    moge<mt:else>
    false</mt:if>
  expected: value is false

-
  name: Else can handle an attribute "eq" and can omit "name".
  template: |
    value is <mt:setvar name='foo' value='poge'><mt:if name='foo' eq='hoge' strip_linefeeds='1'>
    hoge<mt:else eq='moge'>
    moge<mt:else>
    false</mt:if>
  expected: value is false

-
  name: ElseIf can handle an attribute "eq" and can omit "name". (compare to 'poge')
  template: |
    value is <mt:setvar name='foo' value='poge'><mt:if name='foo' eq='hoge' strip_linefeeds='1'>
    hoge<mt:elseif eq='poge'>
    poge<mt:else>
    false</mt:if>
  expected: value is poge

-
  name: Else can handle an attribute "eq" and can omit "name". (compare to 'poge')
  template: |
    value is <mt:setvar name='foo' value='poge'><mt:if name='foo' eq='hoge' strip_linefeeds='1'>
    hoge<mt:else eq='poge'>
    poge<mt:else>
    false</mt:if>
  expected: value is poge

-
  name: Loop prepare the counter variable as "__counter__".
  template: |
    <mt:var name='ar[0]' value='A'>
    <mt:var name='ar[1]' value='B'>
    <mt:var name='ar[2]' value='C'>
    <mt:loop name='ar'>
    <mt:if name='__value__' eq='A'>
    A:<mt:var name='__counter__'>
    <mt:elseif eq='B'>
    B:<mt:var name='__counter__'>
    <mt:else>
    C:<mt:var name='__counter__'>
    </mt:if>
    </mt:loop>
  expected: |
    A:1
    B:2
    C:3

- 
  name: Var with attributes "name" and "value" works as SetVar.
  template: |
    <mt:var name='foo' value='2'>
    <mt:if name='foo' eq='1'>
    incorrect<mt:else eq='2'>
    correct<mt:else eq='3'>
    incorrect</mt:if>
  expected: correct

-
  name: SetVars set up variables.
  template: |-
    <MTSetVars>
    foo=Foo
    </MTSetVars><MTGetVar name='foo'>
  expected: Foo

-
  name: SetVarTemplate create a template.
  template: |
    <MTSetVarTemplate name='foo_template'>
      <MTSetVar name='foo' value='Bar'>
    </MTSetVarTemplate>
    <MTSetVar name='foo' value='Foo'>
    <MTVar name='foo_template'>
    <MTGetVar name='foo'>
  expected: Bar

-
  name: Unless prints the inner content if the condition is false.
  template: |
    <MTSetVar name='foo' value='Foo'>
    <MTUnless name='foo' eq='Bar'>Content</MTUnless>
  expected: Content

-
  name: Unless doesn't print the inner content if the condition is true.
  template: |
    <MTSetVar name='foo' value='Foo'>
    <MTUnless name='foo' eq='Foo'>Content</MTUnless>
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

