/* Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
 * This file is combined from multiple sources.  Consult the source files for their
 * respective licenses and copyrights.
 */defined=function(x){return x!==undefined;};exists=function(x){return(x===undefined||x===null)?false:true;};truth=function(x){return(x&&x!="0")?true:false;};finite=function(x){return isFinite(x)?x:0;};finiteInt=function(x,b){return finite(parseInt(x,b));};finiteFloat=function(x){return finite(parseFloat(x));};max=function(){var a=arguments;var n=a[0];for(var i=1;i<a.length;i++)
if(a[i]>n)
n=a[i];return n;};min=function(){var a=arguments;var n=a[0];for(var i=1;i<a.length;i++)
if(a[i]<n)
n=a[i];return n;};extend=function(o){var a=arguments;for(var i=1;i<a.length;i++){var s=a[i];for(var p in s){try{if(!o[p]&&(!s.hasOwnProperty||s.hasOwnProperty(p)))
o[p]=s[p];}catch(e){}}}
return o;};override=function(o){var a=arguments;for(var i=1;i<a.length;i++){var s=a[i];for(var p in s){try{if(!s.hasOwnProperty||s.hasOwnProperty(p))
o[p]=s[p];}catch(e){}}}
return o;};log=function(){};log.error=log.warn=log.debug=log;Try={these:function(){var a=arguments;for(var i=0;i<a.length;i++){try{return a[i]();}catch(e){}}
return undefined;}};Unique={length:0,id:function(){return++this.length;}};if(!defined(window.Event))
Event={};Event.stop=function(ev){ev=ev||this;if(ev===Event)
ev=window.event;if(ev.preventDefault)
ev.preventDefault();if(ev.stopPropagation)
ev.stopPropagation();try{ev.cancelBubble=true;ev.returnValue=false;}catch(e){}
return false;};Event.prep=function(ev){ev=ev||window.event;if(!defined(ev.stop))
ev.stop=this.stop;if(!defined(ev.target))
ev.target=ev.srcElement;if(!defined(ev.relatedTarget)){ev.relatedTarget=(event.type=="mouseover"||event.type=="mouseenter")?ev.fromElement:ev.toElement;}
return ev;};try{Event.prototype.stop=Event.stop;}
catch(e){}
Function.stub=function(){};extend(Function.prototype,{bind:function(o){var m=this;return function(){return m.apply(o,arguments);};},bindEventListener:function(o){var m=this;return function(e){try{event=Event.prep(e);}catch(e){}
return m.call(o,e);};},applySuper:function(o,args){return this.__super.apply(o,args||[]);},callSuper:function(o){var args=[];for(var i=1;i<arguments.length;i++)
args.push(arguments[i]);return this.__super.apply(o,args);}});indirectObjects=[];__SUBCLASS__={__SUBCLASS__:"__SUBCLASS__"};Class=function(sc){var c=function(s){this.constructor=arguments.callee;if(s===__SUBCLASS__)
return;this.init.apply(this,arguments);};override(c,Class);sc=sc||Object;override(c,sc);c.__super=sc;c.superClass=sc.prototype;c.prototype=sc===Object?new sc():new sc(__SUBCLASS__);extend(c.prototype,Class.prototype);var a=arguments;for(var i=1;i<a.length;i++)
override(c.prototype,a[i]);c.prototype.constructor=sc;for(var p in c.prototype){var m=c.prototype[p];if(typeof m!="function"||defined(m.__super))
continue;m.__super=null;var pr=c.prototype;while(pr&&!m.__super){if(pr===pr.constructor.prototype)
break;pr=pr.constructor.prototype;var s=pr[p];if(defined(s)&&typeof s=="function")
m.__super=s;}}
return c;};extend(Class,{initSingleton:function(){if(this.singleton)
return this.singleton;var c=this.singletonConstructor||this;this.singleton=new c();return this.singleton;}});Class.prototype={init:function(){},destroy:function(){try{if(this.indirectIndex)
indirectObjects[this.indirectIndex]=undefined;delete this.indirectIndex;}catch(e){}
for(var property in this){try{if(this.hasOwnProperty(property))
delete this[property];}catch(e){}}},getBoundMethod:function(mn){return this[mn].bind(this);},getEventListener:function(mn){return this[mn].bindEventListener(this);},getIndirectIndex:function(){if(!defined(this.indirectIndex)){this.indirectIndex=indirectObjects.length;indirectObjects.push(this);}
return this.indirectIndex;},getIndirectMethod:function(mn){if(!this.indirectMethods)
this.indirectMethods={};var m=this[mn];if(typeof m!="function")
return undefined;var indirectIndex=this.getIndirectIndex();if(!this.indirectMethods[mn]){this.indirectMethods[mn]=new Function("if ( !window.indirectObjects ) return; "+
"var o = indirectObjects["+indirectIndex+"];"+
"return o['"+mn+"'].apply( o, arguments );");}
return this.indirectMethods[mn];},getIndirectEventListener:function(mn){if(!this.indirectEventListeners)
this.indirectEventListeners={};var m=this[mn];if(typeof m!="function")
return undefined;var indirectIndex=this.getIndirectIndex();if(!this.indirectEventListeners[mn]){this.indirectEventListeners[mn]=new Function("event","try { event = Event.prep( event ); } catch( e ) {}"+
"if ( !window.indirectObjects ) return; "+
"var o = indirectObjects["+indirectIndex+"];"+
"return o['"+mn+"'].call( o, event );");}
return this.indirectEventListeners[mn];}};extend(Class.prototype,{_gGM:Class.prototype.getBoundMethod,_gEL:Class.prototype.getEventListener,_gII:Class.prototype.getIndirectIndex,_gIM:Class.prototype.getIndirectMethod,_gIEL:Class.prototype.getIndirectEventListener});extend(String,{escapeJSChar:function(c){switch(c){case"\\":return"\\\\";case"\"":return"\\\"";case"'":return"\\'";case"\b":return"\\b";case"\f":return"\\f";case"\n":return"\\n";case"\r":return"\\r";case"\t":return"\\t";}
if(c>=" ")
return c;c=c.charCodeAt(0).toString(16);switch(c.length){case 1:return"\\u000"+c;case 2:return"\\u00"+c;case 3:return"\\u0"+c;case 4:return"\\u"+c;}
return"";},encodeEntity:function(c){switch(c){case"<":return"&lt;";case">":return"&gt;";case"&":return"&amp;";case'"':return"&quot;";case"'":return"&apos;";}
return c;},decodeEntity:function(c){switch(c){case"amp":return"&";case"quot":return'"';case"apos":return"'";case"gt":return">";case"lt":return"<";}
var m=c.match(/^#(\d+)$/);if(m&&defined(m[1]))
return String.fromCharCode(m[1]);m=c.match(/^#x([0-9a-f]+)$/i);if(m&&defined(m[1]))
return String.fromCharCode(parseInt(hex,m[1]));return c;},encodeQuery:function(o){var q=[];var e=encodeURIComponent||escapeURI||escape;for(var p in o)
q.push(e(p)+"="+e(o[p]));return q.join("&");}});extend(String.prototype,{escapeJS:function(){return this.replace(/([^ -!#-\[\]-~])/g,function(m,c){return String.escapeJSChar(c);})},encodeHTML:function(){return this.replace(/([<>&"])/g,function(m,c){return String.encodeEntity(c)});},decodeHTML:function(){return this.replace(/&(.*?);/g,function(m,c){return String.decodeEntity(c)});},cssToJS:function(){return this.replace(/-([a-z])/g,function(m,c){return c.toUpperCase()});},jsToCSS:function(){return this.replace(/([A-Z])/g,function(m,c){return"-"+c.toLowerCase()});},firstToLowerCase:function(){return this.replace(/^(.)/,function(m,c){return c.toLowerCase()});},rgbToHex:function(){var c=this.match(/(\d+)\D+(\d+)\D+(\d+)/);if(!c)
return undefined;return"#"+
finiteInt(c[1]).toString(16).pad(2,"0")+
finiteInt(c[2]).toString(16).pad(2,"0")+
finiteInt(c[3]).toString(16).pad(2,"0");},pad:function(length,padChar){var padding=length-this.length;if(padding<=0)
return this;if(!defined(padChar))
padChar=" ";var out=[];for(var i=0;i<padding;i++)
out.push(padChar);out.push(this);return out.join("");},trim:function(){return this.replace(/^\s+|\s+$/g,"");},interpolate:function(vars){return this.replace(/(?!\\)\$\{([^\}]+)\}|(?!\\)\$([a-zA-Z][a-zA-Z0-9_]*)|\\\$/g,function(m,a,b){with(vars){if(a)
return eval("("+a+")");else if(b)
return eval("("+b+")");}
return"$";});}});extend(Array,{fromPseudo:function(){var out=[];for(var j=0;j<arguments.length;j++)
for(var i=0;i<arguments[j].length;i++)
out.push(arguments[j][i]);return out;}});extend(Array.prototype,{copy:function(){var out=[];for(var i=0;i<this.length;i++)
out[i]=this[i];return out;},first:function(c,o){var l=this.length;for(var i=0;i<l;i++){var result=o?c.call(o,this[i],i,this):c(this[i],i,this);if(result)
return this[i];}
return null;},fitIndex:function(i,di){if(!exists(i))
i=di;else if(i<0){i=this.length+i;if(i<0)
i=0;}else if(i>=this.length)
i=this.length-1;return i;},scramble:function(){for(var i=0;i<this.length;i++){var j=Math.floor(Math.random()*this.length);var t=this[i];this[i]=this[j];this[j]=t;}},add:function(){var a=arguments;for(var i=0;i<a.length;i++){var j=this.indexOf(a[i]);if(j<0)
this.push(arguments[i]);}
return this.length;},remove:function(){var a=arguments;for(var i=0;i<a.length;i++){var j=this.indexOf(a[i]);if(j>=0)
this.splice(j,1);}
return this.length;},every:function(c,o){var l=this.length;for(var i=0;i<l;i++)
if(!(o?c.call(o,this[i],i,this):c(this[i],i,this)))
return false;return true;},some:function(c,o){var l=this.length;for(var i=0;i<l;i++)
if(o?c.call(o,this[i],i,this):c(this[i],i,this))
return true;return false;},filter:function(c,o){var out=[];var l=this.length;for(var i=0;i<l;i++)
if(o?c.call(o,this[i],i,this):c(this[i],i,this))
out.push(this[i]);return out;},forEach:function(c,o){var l=this.length;for(var i=0;i<l;i++)
o?c.call(o,this[i],i,this):c(this[i],i,this);},indexOf:function(v,fi){if(!this.fitIndex){return-1;}
fi=this.fitIndex(fi,0);for(var i=0;i<this.length;i++)
if(this[i]===v)
return i;return-1;},lastIndexOf:function(v,fi){fi=this.fitIndex(fi,this.length-1);for(var i=fi;i>=0;i--)
if(this[i]==v)
return i;return-1;},concat:function(){var a=arguments;var o=this.copy();for(i=0;i<a.length;i++){var b=a[i];for(j=0;j<b.length;j++)
o.push(b[j]);}
return o;},push:function(){var a=arguments;for(var i=0;i<a.length;i++)
this[this.length]=a[i];return this.length;},pop:function(){if(this.length==0)
return undefined;var o=this[this.length-1];this.length--;return o;},unshift:function(){var a=arguments;for(var i=0;i<a.length;i++){this[i+a.length]=this[i];this[i]=a[i];}
return this.length;},shift:function(){if(this.length==0)
return undefined;var o=this[0];for(var i=1;i<this.length;i++)
this[i-1]=this[i];this.length--;return o;}});extend(Date,{strings:{localeWeekdays:{},localeShortWeekdays:{},localeMonths:{},localeShortMonths:{}},matchISOString:new RegExp("^([0-9]{4})"+
"(?:-(?=0[1-9]|1[0-2])|$)(..)?"+
"(?:-(?=0[1-9]|[12][0-9]|3[01])|$)([0-9]{2})?"+
"(?:T(?=[01][0-9]|2[0-4])|$)T?([0-9]{2})?"+
"(?::(?=[0-5][0-9])|\\+|-|Z|$)([0-9]{2})?"+
"(?::(?=[0-5][0-9]|60$|60[+|-|Z]|60.0+)|\\+|-|Z|$):?([0-9]{2})?"+
"(\\.[0-9]+)?"+
"(Z|\\+[01][0-9]|\\+2[0-4]|-[01][0-9]|-2[0-4])?"+
":?([0-5][0-9]|60)?$"),fromISOString:function(string){var t=this.matchISOString.exec(string);if(!t)
return undefined;var y=finiteInt(t[1],10);var mo=finiteInt(t[2],10)-1;var d=finiteInt(t[3],10);var h=finiteInt(t[4],10);var m=finiteInt(t[5],10);var s=finiteInt(t[6],10);var ms=finiteInt(Math.round(parseFloat(t[7])*1000));var tzh=finiteInt(t[8],10);var tzm=finiteInt(t[9],10);var date=new this(0);if(defined(t[8])){date.setUTCFullYear(y,mo,d);date.setUTCHours(h,m,s,ms);var o=(tzh*60+tzm)*60000;if(o)
date=new this(date-o);}else{date.setFullYear(y,mo,d);date.setHours(h,m,s,ms);}
return date;}});extend(Date.prototype,{clone:function(){return new Date(this.getTime());},getISOTimezoneOffset:function(){var o=-this.getTimezoneOffset();var n=0;if(o<0){n=1;o*=-1;}
var h=Math.floor(o/60).toString().pad(2,"0");var m=Math.floor(o%60).toString().pad(2,"0");return(n?"-":"+")+h+":"+m;},toISODateString:function(){var y=this.getFullYear();var m=(this.getMonth()+1).toString().pad(2,"0");var d=this.getDate().toString().pad(2,"0");return y+"-"+m+"-"+d;},toUTCISODateString:function(){var y=this.getUTCFullYear();var m=(this.getUTCMonth()+1).toString().pad(2,"0");var d=this.getUTCDate().toString().pad(2,"0");return y+"-"+m+"-"+d;},toISOTimeString:function(){var h=this.getHours().toString().pad(2,"0");var m=this.getMinutes().toString().pad(2,"0");var s=this.getSeconds().toString().pad(2,"0");var ms=this.getMilliseconds().toString().pad(3,"0");var tz=this.getISOTimezoneOffset();return h+":"+m+":"+s+"."+ms+tz;},toUTCISOTimeString:function(){var h=this.getUTCHours().toString().pad(2,"0");var m=this.getUTCMinutes().toString().pad(2,"0");var s=this.getUTCSeconds().toString().pad(2,"0");var ms=this.getUTCMilliseconds().toString().pad(3,"0");return h+":"+m+":"+s+"."+ms+"Z";},toISOString:function(){return this.toISODateString()+"T"+this.toISOTimeString();},toUTCISOString:function(){return this.toUTCISODateString()+"T"+this.toUTCISOTimeString();},getLocaleDayString:function(d){if(isNaN(d))
d=this.getDay();return this.constructor.strings.localeWeekdays[d];},getLocaleDayShortString:function(d){if(isNaN(d))
d=this.getDay();return this.constructor.strings.localeShortWeekdays[d];},getLocaleMonthString:function(m){if(isNaN(m))
m=this.getMonth();return this.constructor.strings.localeMonths[m];},getLocaleMonthShortString:function(m){if(isNaN(m))
m=this.getMonth();return this.constructor.strings.localeShortMonths[m];}});window.CompatibleEnumerator=new Class(Object,{init:function(a){this.data=a;this.index=0;},atEnd:function(){return this.index>=this.data.length?true:false;},item:function(){return this.atEnd()?undefined:this.data[this.index];},moveFirst:function(){this.index=0;return this.item();},moveNext:function(){this.index++;return this.item();}});if(!defined(window.Enumerator)){window.Enumerator=window.CompatibleEnumerator;}
window.EnumeratorFactory=function(collection){try{return new window.Enumerator(collection);}
catch(e){return new window.CompatibleEnumerator(collection);}};if(!defined(window.XMLHttpRequest)){window.XMLHttpRequest=function(){var h=["Microsoft.XMLHTTP","MSXML2.XMLHTTP.5.0","MSXML2.XMLHTTP.4.0","MSXML2.XMLHTTP.3.0","MSXML2.XMLHTTP"];for(var i=0;i<h.length;i++){try{return new ActiveXObject(h[i]);}catch(e){}}
return undefined;}};Timer=new Class(Object,{init:function(callback,delay,count){this.callback=callback;this.delay=max(delay,1);this.nextDelay=this.delay;this.startTime=0;this.count=count;this.execCount=0;this.state="new";this.timeout=null;this.id=Unique.id();this.start();},destroy:function(){this.stop();this.callback=null;},exec:function(){this.execCount++;this.callback(this);if(this.count&&this.execCount>=this.count){return this.destroy();}
if(this.state=="started")
this.run();},run:function(){this.state="started";this.timeout=window.setTimeout(this.exec.bind(this),this.nextDelay);this.nextDelay=this.delay;var date=new Date();this.startTime=date.UTC;},start:function(){switch(this.state){case"new":case"paused":case"stopped":this.run();break;}},stop:function(){this.state="stopped";try{window.clearTimeout(this.timeout);}catch(e){}
this.timeout=null;},pause:function(){if(this.state!="started")
return;this.stop();this.state="paused";var date=new Date();this.nextDelay=max(this.delay-(date.UTC-this.startTime),1);},reset:function(delay){if(this.state!="started")
return;if(defined(delay))
this.delay=this.nextDelay=max(delay,1);try{window.clearTimeout(this.timeout);}catch(e){}
this.timeout=window.setTimeout(this.exec.bind(this),this.nextDelay);}});Cookie=new Class(Object,{init:function(name,value,domain,path,expires,secure){this.name=name;this.value=value;this.domain=domain;this.path=path;this.expires=expires;this.secure=secure;},fetch:function(){var prefix=escape(this.name)+"=";var cookies=(""+document.cookie).split(/;\s*/);for(var i=0;i<cookies.length;i++){if(cookies[i].indexOf(prefix)==0){this.value=unescape(cookies[i].substring(prefix.length));return this;}}
return undefined;},bake:function(value){if(!exists(this.name))
return undefined;if(exists(value))
this.value=value;else
value=this.value;var name=escape(this.name);value=escape(value);var attributes=(this.domain?"; domain="+escape(this.domain):"")+
(this.path?"; path="+escape(this.path):"")+
(this.expires?"; expires="+this.expires.toGMTString():"")+
(this.secure?"; secure=1":"");var batter=name+"="+value+attributes;document.cookie=batter;return this;},remove:function(){this.expires=new Date(0);this.value="";this.bake();}});override(Cookie,{fetch:function(name){var cookie=new this(name);return cookie.fetch();},bake:function(name,value,domain,path,expires,secure){var cookie=new this(name,value,domain,path,expires,secure);return cookie.bake();},remove:function(name){var cookie=this.fetch(name);if(cookie)
return cookie.remove();}});if(!defined(window.Node))
Node={};try{extend(Node,{ELEMENT_NODE:1,ATTRIBUTE_NODE:2,TEXT_NODE:3,CDATA_SECTION_NODE:4,COMMENT_NODE:8,DOCUMENT_NODE:9,DOCUMENT_FRAGMENT_NODE:11});}catch(e){}
if(!defined(window.DOM))
DOM={};extend(DOM,{getElement:function(e){return(typeof e=="string"||typeof e=="number")?document.getElementById(e):e;},reload:function(w){if(!w||!w.location||!w.location.reload)
w=window;w.location.reload(true);},addEventListener:function(e,en,f,uc){try{if(e.addEventListener)
e.addEventListener(en,f,uc);else if(e.attachEvent)
e.attachEvent("on"+en,f);else
e["on"+en]=f;}catch(e){}},removeEventListener:function(e,en,f,uc){try{if(e.removeEventListener)
e.removeEventListener(en,f,uc);else if(e.detachEvent)
e.detachEvent("on"+en,f);else
e["on"+en]=undefined;}catch(e){}},focus:function(e){try{e=DOM.getElement(e);e.focus();}catch(e){}},blur:function(e){try{e=DOM.getElement(e);e.blur();}catch(e){}},setFormData:function(el,d){if(typeof el=="string"||typeof el=="number")
el=DOM.getElement(el);if(!d)
d={};var es=Array.fromPseudo(el.getElementsByTagName("input"),el.getElementsByTagName("textarea"),el.getElementsByTagName("select"));for(var i=0;i<es.length;i++){var e=es[i];var t=e.getAttribute("type");t=t?t.toLowerCase():"";var tn=e.tagName.toLowerCase();var v=d[e.name];switch(tn){case"input":if(t=="image"||t=="submit")
break;if(t=="radio"){if(d.hasOwnProperty(e.name))
e.checked=v==e.value?true:false;break;}
if(t=="checkbox"){if(v instanceof Array)
e.checked=(v.indexOf(e.value)!=-1)?true:false;else
e.checked=v==e.value?true:false;break;}
case"textarea":if(d.hasOwnProperty(e.name)&&defined(v))
e.value=v;break;case"select":for(var j=0;j<e.options.length;j++){if(e.options[j].value==v){e.selectedIndex=j;break;}}
break;}}},getFormData:function(el,d){if(typeof el=="string"||typeof el=="number")
el=DOM.getElement(el);if(!d)
d={};var es=Array.fromPseudo(el.getElementsByTagName("input"),el.getElementsByTagName("textarea"),el.getElementsByTagName("select"));for(var i=0;i<es.length;i++){var e=es[i];var t=e.getAttribute("type");t=t?t.toLowerCase():"";var name=e.name;if(!e.getAttribute('mt:raw-name')){name=name.cssToJS();}
var tn=e.tagName.toLowerCase();switch(tn){case"input":if(t=="image"||t=="submit")
break;if(t=="radio"){if(e.checked)
d[name]=e.value;break;}else if(t=="checkbox"){var value=(e.checked)?e.value:"";if(d.hasOwnProperty(name)){if(!(d[name]instanceof Array)){if(d[name])
d[name]=[d[name]];else
d[name]=[];}
var pos=d[name].indexOf(e.value);if(pos!=-1)
d[name].splice(pos,1);if(value)
d[name].push(value);}else
d[name]=value;break;}
case"textarea":if(d.hasOwnProperty(name)){if(!(d[name]instanceof Array)){if(d[name]){d[name]=[d[name]];}else{d[name]=[];}}
d[name].push(e.value);}else{d[name]=e.value;}
break;case"select":if(e.selectedIndex<0){d[name]=undefined;}else if(e.multiple){d[name]=[];for(var j=0;j<e.options.length;j++){if(e.options[j].selected){d[name].push(e.options[j].value);}}}else{d[name]=e.options[e.selectedIndex].value;}
break;}}
return d;},getComputedStyle:function(e){if(e.currentStyle)
return e.currentStyle;var style={};var owner=DOM.getOwnerDocument(e);if(owner&&owner.defaultView&&owner.defaultView.getComputedStyle){try{style=owner.defaultView.getComputedStyle(e,null);}catch(e){}}
return style;},getStyle:function(e,p){var s=DOM.getComputedStyle(e);return s[p];},getClientDimensions:function(w){w=w||window;var d={};if(w.innerHeight){d.x=w.innerWidth;d.y=w.innerHeight;return d;}
var de=w.document.documentElement;if(de&&de.clientHeight){d.x=de.clientWidth;d.y=de.clientHeight;return d;}
if(document.body){d.x=document.body.clientWidth;d.y=document.body.clientHeight;return d;}
return undefined;},getDocumentDimensions:function(d){d=d||document;if(d.body.scrollHeight>d.body.offsetHeight)
return{width:d.body.scrollWidth,height:d.body.scrollHeight};else
return{width:d.body.offsetWidth,height:d.body.offsetHeight};},getDimensions:function(e){if(!e)
return undefined;var style=DOM.getComputedStyle(e);return{offsetLeft:e.offsetLeft,offsetTop:e.offsetTop,offsetWidth:e.offsetWidth,offsetHeight:e.offsetHeight,clientWidth:e.clientWidth,clientHeight:e.clientHeight,offsetRight:e.offsetLeft+e.offsetWidth,offsetBottom:e.offsetTop+e.offsetHeight,clientLeft:finiteInt(style.borderLeftWidth)+finiteInt(style.paddingLeft),clientTop:finiteInt(style.borderTopWidth)+finiteInt(style.paddingTop),clientRight:e.clientLeft+e.clientWidth,clientBottom:e.clientTop+e.clientHeight,marginLeft:style.marginLeft,marginTop:style.marginTop,marginRight:style.marginRight,marginBottom:style.marginBottom};},getAbsoluteDimensions:function(e){var d=DOM.getDimensions(e);if(!d)
return d;d.absoluteLeft=d.offsetLeft;d.absoluteTop=d.offsetTop;d.absoluteRight=d.offsetRight;d.absoluteBottom=d.offsetBottom;var bork=0;while(e){try{e=e.offsetParent;}catch(err){log("In DOM.getAbsoluteDimensions: "+err.message);if(++bork>25)
return null;}
if(!e)
return d;d.absoluteLeft+=e.offsetLeft;d.absoluteTop+=e.offsetTop;d.absoluteRight+=e.offsetLeft;d.absoluteBottom+=e.offsetTop;}
return d;},getIframeAbsoluteDimensions:function(e){var d=DOM.getAbsoluteDimensions(e);if(!d)
return d;var iframe=DOM.getOwnerIframe(e);if(!defined(iframe))
return d;var d2=DOM.getIframeAbsoluteDimensions(iframe);var scroll=DOM.getWindowScroll(iframe.contentWindow);var left=d2.absoluteLeft-scroll.left;var top=d2.absoluteTop-scroll.top;d.absoluteLeft+=left;d.absoluteTop+=top;d.absoluteRight+=left;d.absoluteBottom+=top;return d;},setLeft:function(e,v){e.style.left=finiteInt(v)+"px";},setTop:function(e,v){e.style.top=finiteInt(v)+"px";},setRight:function(e,v){e.style.right=finiteInt(v)+"px";},setBottom:function(e,v){e.style.bottom=finiteInt(v)+"px";},setWidth:function(e,v){e.style.width=max(0,finiteInt(v))+"px";},setHeight:function(e,v){e.style.height=max(0,finiteInt(v))+"px";},setZIndex:function(e,v){e.style.zIndex=finiteInt(v);},getWindowScroll:function(w){w=w||window;var d=w.document,de=d.documentElement,b=d.body;return{left:max(finiteInt(w.pageXOffset),finiteInt(de.scrollLeft),finiteInt(b.scrollLeft),finiteInt(w.scrollX)),top:max(finiteInt(w.pageYOffset),finiteInt(de.scrollTop),finiteInt(b.scrollTop),finiteInt(w.scrollY))};},getAbsoluteCursorPosition:function(ev){ev=ev||window.event;var pos={x:ev.clientX,y:ev.clientY};if(window.devicePixelRatio||!navigator.userAgent.toLowerCase().match(/webkit/)){var s=DOM.getWindowScroll(window);pos.x+=s.left;pos.y+=s.top;}
return pos;},invisibleStyle:{display:"block",position:"absolute",left:0,top:0,width:0,height:0,margin:0,border:0,padding:0,fontSize:"0.1px",lineHeight:0,opacity:0,MozOpacity:0,filter:"alpha(opacity=0)"},makeInvisible:function(e){for(var p in this.invisibleStyle)
if(this.invisibleStyle.hasOwnProperty(p))
e.style[p]=this.invisibleStyle[p];},getSelection:function(w,d){if(!w)
w=window;if(navigator.userAgent.indexOf('MSIE')!=-1){return d?d.selection:w.document.selection;}
else{return w.getSelection();}},mergeTextNodes:function(n){var c=0;while(n){if(n.nodeType==Node.TEXT_NODE&&n.nextSibling&&n.nextSibling.nodeType==Node.TEXT_NODE){n.nodeValue+=n.nextSibling.nodeValue;n.parentNode.removeChild(n.nextSibling);c++;}else{if(n.firstChild)
c+=DOM.mergeTextNodes(n.firstChild);n=n.nextSibling;}}
return c;},selectElement:function(e){var d=e.ownerDocument;if(d.body.createControlRange){var r=d.body.createControlRange();r.addElement(e);r.select();}},isImmutable:function(n){try{if(n.getAttribute("contenteditable")=="false")
return true;}catch(e){}
return false;},getImmutable:function(n){var immutable=null;while(n){if(DOM.isImmutable(n))
immutable=n;n=n.parentNode;}
return immutable;},getOwnerDocument:function(n){if(!n)
return document;if(n.ownerDocument)
return n.ownerDocument;if(n.getElementById)
return n;return document;},getOwnerWindow:function(n){if(!n)
return window;if(n.parentWindow)
return n.parentWindow;var doc=DOM.getOwnerDocument(n);if(doc&&doc.defaultView)
return doc.defaultView;return window;},getOwnerIframe:function(n){if(!n)
return undefined;var nw=DOM.getOwnerWindow(n);var nd=DOM.getOwnerDocument(n);var pw=nw.parent||nw.parentWindow;if(!pw)
return undefined;var parentDocument=pw.document;var es=parentDocument.getElementsByTagName("iframe");for(var en=EnumeratorFactory(es);!en.atEnd();en.moveNext()){var e=en.item();try{var d=e.contentDocument||e.contentWindow.document;if(d===nd)
return e;}catch(err){};}
return undefined;},filterElementsByClassName:function(es,cn){var filtered=[];for(var en=EnumeratorFactory(es);!en.atEnd();en.moveNext()){var e=en.item();if(DOM.hasClassName(e,cn))
filtered.push(e);}
return filtered;},filterElementsByAttribute:function(es,a){if(!es)
return[];if(!a)
return es;var f=[];for(var en=EnumeratorFactory(es);!en.atEnd();en.moveNext()){var e=en.item();if(!e)
continue;try{if(e.getAttribute&&e.getAttribute(a))
f.push(e);}catch(e){}}
return f;},filterElementsByTagName:function(es,tn){if(tn=="*")
return es;var f=[];tn=tn.toLowerCase();for(var en=EnumeratorFactory(es);!en.atEnd();en.moveNext()){var e=en.item();if(e.tagName&&e.tagName.toLowerCase()==tn)
f.push(e);}
return f;},getElementsByTagAndAttribute:function(r,tn,a){if(!r)
r=document;var es=r.getElementsByTagName(tn);return DOM.filterElementsByAttribute(es,a);},getElementsByAttribute:function(r,a){return DOM.getElementsByTagAndAttribute(r,"*",a);},getElementsByAttributeAndValue:function(r,a,v){var es=DOM.getElementsByTagAndAttribute(r,"*",a);var filtered=[];for(var i=0;i<es.length;i++){var e=es[i];try{if(e.getAttribute&&e.getAttribute(a)==v)
filtered.push(es[i]);}catch(e){}}
return filtered;},getElementsByTagAndClassName:function(r,tn,cn){if(!r)
r=document;var elements=r.getElementsByTagName(tn);return DOM.filterElementsByClassName(elements,cn);},getElementsByClassName:function(r,cn){return DOM.getElementsByTagAndClassName(r,"*",cn);},hasAncestor:function(n,a){while(n){if(n.parentNode===a)
return true;n=n.parentNode;}
return false;},getAncestors:function(n,s){if(!n)
return[];var as=s?[n]:[];n=n.parentNode;while(n){as.push(n);n=n.parentNode;}
return as;},getAncestorsByTagName:function(n,tn,s){var es=DOM.getAncestors(n,s);return DOM.filterElementsByTagName(es,tn);},getFirstAncestorByTagName:function(n,tn,s){return DOM.getAncestorsByTagName(n,tn,s)[0];},getAncestorsByClassName:function(n,cn,s){var es=DOM.getAncestors(n,s);return DOM.filterElementsByClassName(es,cn);},getFirstAncestorByClassName:function(n,cn,s){return DOM.getAncestorsByClassName(n,cn,s)[0];},getAncestorsByTagAndClassName:function(n,tn,cn,s){var es=DOM.getAncestorsByTagName(n,tn,s);return DOM.filterElementsByClassName(es,cn);},getFirstAncestorByTagAndClassName:function(n,tn,cn,s){return DOM.getAncestorsByTagAndClassName(n,tn,cn,s)[0];},getAncestorsByAttribute:function(n,a,s){var es=DOM.getAncestors(n,s);return DOM.filterElementsByAttribute(es,a);},getFirstAncestorByAttribute:function(n,a,s){return DOM.getAncestorsByAttribute(n,a,s)[0];},getPreviousElement:function(n,t){if(!t)
t=Node.ELEMENT_NODE;n=n.previousSibling;while(n){if(n.nodeType==Node.ELEMENT_NODE)
return n;n=n.previousSibling;}
return null;},getNextElement:function(n,t){if(!t)
t=Node.ELEMENT_NODE;n=n.nextSibling;while(n){if(n.nodeType==t)
return n;n=n.nextSibling;}
return null;},isInlineNode:function(n){if(n.nodeType==Node.TEXT_NODE)
return n;if(n.nodeType==Node.DOCUMENT_NODE)
return false;if(n.nodeType!=Node.ELEMENT_NODE)
return n;if(n.tagName&&n.tagName.toLowerCase()=="br")
return false;var display=DOM.getStyle(n,"display");if(display&&display.indexOf("inline")>=0)
return n;},isTextNode:function(n){if(n.nodeType==Node.TEXT_NODE)
return n;},isInlineTextNode:function(n){if(n.nodeType==Node.TEXT_NODE)
return n;if(!DOM.isInlineNode(n))
return null;},getClassNames:function(e){if(!e||!e.className||typeof e.className!='string')
return[];return e.className.split(/\s+/g);},hasClassName:function(e,cn){e=DOM.getElement(e);if(!e||!e.className)
return false;var cs=DOM.getClassNames(e);for(var i=0;i<cs.length;i++){if(cs[i]==cn)
return true;}
return false;},addClassName:function(e,cn){e=DOM.getElement(e);if(!e||!cn)
return false;var cs=DOM.getClassNames(e);for(var i=0;i<cs.length;i++){if(cs[i]==cn)
return true;}
cs.push(cn);e.className=cs.join(" ");return false;},removeClassName:function(e,cn){var r=false;e=DOM.getElement(e);if(!e||!e.className||!cn)
return r;var cs=(e.className&&e.className.length)?e.className.split(/\s+/g):[];var ncs=[];if(cn instanceof RegExp){for(var i=0;i<cs.length;i++){if(cn.test(cs[i])){r=true;continue;}
ncs.push(cs[i]);}}else{for(var i=0;i<cs.length;i++){if(cs[i]==cn){r=true;continue;}
ncs.push(cs[i]);}}
if(r)
e.className=ncs.join(" ");return r;},replaceWithChildNodes:function(n){var firstChild=n.firstChild;var parentNode=n.parentNode;while(n.firstChild)
parentNode.insertBefore(n.removeChild(n.firstChild),n);parentNode.removeChild(n);return firstChild;},replaceWithHTML:function(n,h){var d=DOM.getOwnerDocument(n);var e=d.createElement("div");e.innerHTML=h;var parentNode=n.parentNode;var nextSibling=n.nextSibling;parentNode.replaceChild(e.removeChild(e.firstChild),n);return;while(e.firstChild)
parentNode.insertBefore(e.removeChild(e.firstChild),nextSibling);},activateEmbeds:function(doc){if(!defined(window.clipboardData))
return;if(!doc)
doc=document;var es=doc.getElementsByTagName("embed");for(var j=0;j<es.length;j++)
es[j].parentElement.innerHTML=es[j].parentElement.innerHTML;},createInvisibleInput:function(d){if(!d)
d=window.document;var e=document.createElement("input");e.setAttribute("autocomplete","off");e.autocomplete="off";DOM.makeInvisible(e);return e;},getMouseEventAttribute:function(ev,a){if(!a)
return;var es=DOM.getAncestors(ev.target,true);for(var en=EnumeratorFactory(es);!en.atEnd();en.moveNext()){var e=en.item();try{var v=e.getAttribute?e.getAttribute(a):null;if(v){ev.attributeElement=e;ev.attribute=v;return v;}}catch(e){}}},setElementAttribute:function(e,a,v){if(navigator.userAgent.toLowerCase().match(/webkit/)){var at=e.attributes;for(var i=0;i<at.length;i++)
if(at[i].name==a)
return at[i].nodeValue=v;}
e.setAttribute(a,v);},swapAttributes:function(e,tg,at){var ar=e.getAttribute(tg);if(!ar)
return false;if(e.tagName.toLowerCase()=='script'){var cl=e.cloneNode(true);if(!cl)
return false;DOM.setElementAttribute(cl,at,ar);cl.removeAttribute(tg);return e.parentNode.replaceChild(cl,e);}else{DOM.setElementAttribute(e,at,ar);e.removeAttribute(tg);}}});extend(DOM,{_gE:DOM.getElement,_aCN:DOM.addClassName,_rCN:DOM.removeClassName});$=DOM.getElement;Observable=new Class(Object,{init:function(){this.observers=[];},destroy:function(){this.observers.length=0;this.observers=undefined;},addObserver:function(object){this.observers.add(object.getIndirectIndex());},removeObserver:function(object){this.observers.remove(object.getIndirectIndex());},broadcastToObservers:function(){var args=Array.fromPseudo(arguments);var methodName=args.shift();for(var i=0;i<this.observers.length;i++){var observer=indirectObjects[this.observers[i]];if(observer[methodName])
observer[methodName].apply(observer,args);}},broadcastToObserversNB:function(){var args=Array.fromPseudo(arguments);var methodName=args.shift();for(var i=0;i<this.observers.length;i++){if(indirectObjects[this.observers[i]][methodName]){var _ob=indirectObjects[this.observers[i]];var method=_ob[methodName];new Timer(function(){method.apply(_ob,args);},(i*10)+10,1);}}}});Autolayout={matchAutolayout:/(?:^|\s)autolayout-(\S+)(?:\s|$)/,matchSingleAutolayout:/^autolayout-(\S+)$/,applyAutolayouts:function(e){var cs=DOM.getClassNames(e);for(var i=0;i<cs.length;i++){var r=this.matchSingleAutolayout.exec(cs[i]);if(!r||!r[1])
continue;var l=r[1].cssToJS();if(!this.layouts.hasOwnProperty(l))
continue;this.layouts[l].apply(this,arguments);}}}
Autolayout.layouts={center:function(e){DOM.setLeft(e,finiteInt(e.parentNode.clientWidth/2)-finiteInt(e.offsetWidth/2));DOM.setTop(e,finiteInt(e.parentNode.clientHeight/2)-finiteInt(e.offsetHeight/2));},heightParent:function(e){DOM.setHeight(e,finiteInt(e.parentNode.clientHeight));},heightNext:function(e){var ne=DOM.getNextElement(e);if(!ne)
return;DOM.setHeight(e,finiteInt(ne.offsetTop)-finiteInt(e.offsetTop));},flyout:function(e){var d=DOM.getIframeAbsoluteDimensions(this.targetElement);if(!d)
return;DOM.setLeft(e,d.absoluteLeft);DOM.setTop(e,d.absoluteBottom);},FLYOUT_SMART_EPSILON_Y:200,flyoutSmart:function(e){var td=DOM.getIframeAbsoluteDimensions(this.targetElement);if(!td)
return;var dd=DOM.getDocumentDimensions(DOM.getOwnerDocument(e));if(td.absoluteLeft>(dd.width/2)){e.style.left="auto";DOM.setRight(e,(dd.width-td.absoluteRight));}else{e.style.right="auto";DOM.setLeft(e,td.absoluteLeft);}
if(td.absoluteTop>(dd.height-300)){e.style.top="auto";DOM.setBottom(e,(dd.height-td.absoluteBottom));}else{e.style.bottom="auto";DOM.setTop(e,td.absoluteTop);}},flyoutUp:function(e){var d=DOM.getIframeAbsoluteDimensions(this.targetElement);if(!d)
return;var a=DOM.getDimensions(e);DOM.setLeft(e,d.absoluteLeft);DOM.setTop(e,d.absoluteBottom-a.offsetHeight);},flyoutLeft:function(e){var d=DOM.getIframeAbsoluteDimensions(this.targetElement);if(!d)
return;var a=DOM.getDimensions(e);DOM.setLeft(e,d.absoluteLeft-a.offsetWidth);DOM.setTop(e,d.absoluteTop);},flyoutLeftFromRight:function(e){var d=DOM.getIframeAbsoluteDimensions(this.targetElement);if(!d)
return;var a=DOM.getDimensions(e);DOM.setLeft(e,d.absoluteRight-a.offsetWidth);DOM.setTop(e,d.absoluteTop);},targetWidth:function(e){if(!this.targetElement)
return;DOM.setWidth(e,this.targetElement.offsetWidth);}}
Component=new Class(Observable,Autolayout,{useClosures:false,init:function(){arguments.callee.applySuper(this,arguments);this.initObject.apply(this,arguments);this.initSentinels();this.initEventListeners();this.initComponents();},destroy:function(){arguments.callee.applySuper(this,arguments);this.destroyComponents();this.destroyEventListeners();this.destroyObject();},initObject:function(element){this.element=DOM.getElement(element);if(!this.element)
throw typeof element=="string"?"no element: "+element:"no element";this.name=element;this.parent=null;this.components=[];this.sentinels=null;this.active=false;},destroyObject:function(element){this.components=null;this.sentinels=null;this.parent=null;this.element=null;this.name=null;},initEventListeners:function(){this.addEventListener(this.element,"mouseover","eventMouseOver");this.addEventListener(this.element,"mouseout","eventMouseOut");this.addEventListener(this.element,"mousemove","eventMouseMove");this.addEventListener(this.element,"mousedown","eventMouseDown");this.addEventListener(this.element,"mouseup","eventMouseUp");this.addEventListener(this.element,"click","eventClick");this.addEventListener(this.element,"dblclick","eventDoubleClick");this.addEventListener(this.element,"contextmenu","eventContextMenu");this.addEventListener(this.element,"keydown","eventKeyDown");this.addEventListener(this.element,"keyup","eventKeyUp");this.addEventListener(this.element,"keypress","eventKeyPress");this.addEventListener(this.element,"focus","eventFocus",true);this.addEventListener(this.element,"blur","eventBlur",true);this.addEventListener(this.element,"focusin","eventFocusIn");this.addEventListener(this.element,"focusout","eventFocusOut");},destroyEventListeners:function(){},addEventListener:function(object,eventName,methodName,useCapture){if(!this[methodName]||this[methodName]===Function.stub)
return;DOM.addEventListener(object,eventName,(this.useClosures?this.getEventListener(methodName):this.getIndirectEventListener(methodName)),useCapture);},removeEventListener:function(object,eventName,methodName,useCapture){var listener=this.useClosures?this.getEventListener(methodName):this.getIndirectEventListener(methodName);DOM.removeEventListener(object,eventName,listener,useCapture);},matchCommand:/(?:^|\s)command-(\S+)(?:\s|$)/,getMouseEventCommand:function(event,rootElement){var ancestors=DOM.getAncestors(event.target,true);var cmdattr=app.NAMESPACE+":command";for(var i=0;i<ancestors.length;i++){try{var result=ancestors[i].getAttribute(cmdattr);if(!result){result=this.matchCommand.exec(ancestors[i].className);if(result[1])
result=result[1];}
if(result){event.commandElement=ancestors[i];event.command=result.cssToJS();return event.command;}
if(ancestors[i]==rootElement)
break;}catch(e){}}},eventMouseDown:function(event){if(this.activatable)
this.activate(event);},eventFocus:function(event){if(this.activatable)
this.activate(event);},eventFocusIn:function(event){if(this.activatable)
this.activate(event);},reflow:function(event){this.applyAutolayouts(this.element);this.reflowComponents(event);},reflowComponents:function(event){this.components.forEach(function(component){component.reflow(event);});},initComponents:function(){},destroyComponents:function(){this.components.forEach(function(component){component.destroy();});this.components.length=0;},addComponent:function(component){this.components.add(component);component.parent=this;component.reflow();return component;},removeComponent:function(component){this.components.remove(component);component.parent=null;return component;},activatable:false,modal:false,initSentinels:function(){if(!this.activatable||this.sentinels)
return;this.sentinels={captureStart:DOM.createInvisibleInput()};this.element.insertBefore(this.sentinels.captureStart,this.element.firstChild);if(!this.modal)
return;extend(this.sentinels,{puntStart:DOM.createInvisibleInput(),captureEnd:DOM.createInvisibleInput(),puntEnd:DOM.createInvisibleInput()});this.element.insertBefore(this.sentinels.puntStart,this.element.firstChild);this.element.appendChild(this.sentinels.captureEnd);this.element.appendChild(this.sentinels.puntEnd);},refreshSentinels:function(){this.sentinels=null;this.initSentinels();},activate:function(event){if(!this.activatable)
return;if(!window.app.setActiveComponent(this))
return;this.active=true;this.captureFocus(event);DOM.addClassName(this.element,"active-component");this.broadcastToObserversNB("componentActivated",this);},deactivate:function(){this.active=false;DOM.removeClassName(this.element,"active-component");this.broadcastToObserversNB("componentDeactivated",this);},focusableTagNames:{taginput:defined,tagtextarea:defined,tagbutton:defined,tagselect:defined,tagdiv:defined,taga:defined,tagoption:defined,tagp:defined},captureFocus:function(event){if(this.active&&!this.modal)
return;var tagName=(defined(event)&&event.target.tagName)?"tag"+event.target.tagName.toLowerCase():null;var command;if(tagName&&event)
command=this.getMouseEventCommand(event);if(!tagName||(this.focusableTagNames[tagName]!==defined)&&!command){try{this.sentinels.captureStart.focus();event.stop();if(defined(this.sentinels.captureStart.focusIn))
this.sentinels.captureStart.focusIn();}catch(e){}}
if(!defined(event)||!this.modal)
return;try{if(event.target===this.sentinels.puntEnd)
this.sentinels.captureStart.focus();else if(event.target===this.sentinels.puntStart)
this.sentinels.captureEnd.focus();}catch(e){}},hide:function(){DOM.removeClassName(this.element,"visible");DOM.addClassName(this.element,"hidden");},show:function(){DOM.removeClassName(this.element,"hidden");DOM.addClassName(this.element,"visible");this.reflow();}});Modal=new Class(Component,{activatable:true,modal:true,isOpen:false,open:function(data,callback){if(!this.transitory)
window.scrollTo(0,0);this.data=defined(data)?data:{};this.callback=callback;this.active=false;this.isOpen=true;window.app.addModal(this);},close:function(data){window.app.removeModal(this);this.isOpen=false;if(this.callback)
this.callback(data,this);this.callback=null;this.data=null;},eventClick:function(event){if(event.shiftKey)
event.stop();},eventKeyPress:function(event){switch(event.keyCode){case 27:this.close(false);}}});Transient=new Class(Modal,{transitory:true,eventKeyPress:function(event){switch(event.keyCode){case 27:this.close(false);}},eventClick:function(event){this.close(this.getMouseEventCommand(event));return event.stop();},eventContextMenu:function(event){return event.stop();},open:function(data,callback,targetElement){this.targetElement=targetElement;return arguments.callee.applySuper(this,arguments);}});Component.Delegator={DEFAULT_NAMESPACE:"core",setupDelegates:function(object){if(!this.delegateListeners)
this.delegateListeners={};if(!this.delegates)
this.delegates={};if(!defined(this.NAMESPACE))
this.NAMESPACE=(window.app&&app.NAMESPACE)?app.NAMESPACE:this.DEFAULT_NAMESPACE;},addEventListener:function(object,eventName,methodName,useCapture){DOM.addEventListener(object,eventName,(this.useClosures?this.getEventListener(methodName):this.getIndirectEventListener(methodName)),useCapture);},setDelegate:function(name,object){this.setupDelegates(object);this.delegates[name]=object;return object;},setDelegateListener:function(eventName,delegateName){this.setupDelegates();this.delegateListeners[eventName]=delegateName;},delegateEvent:function(event,eventName){var delegate=DOM.getMouseEventAttribute(event,this.NAMESPACE+":delegate");if(!delegate){if(this.delegateListeners&&this.delegateListeners.hasOwnProperty(eventName))
delegate=this.delegateListeners[eventName];else
return undefined;}else
delegate=delegate.cssToJS();if(this.delegates&&this.delegates.hasOwnProperty(delegate)&&this.delegates[delegate][eventName])
return this.delegates[delegate][eventName](event,this);},getIndirectEventListener:function(methodName){if(!this.indirectEventListeners)
this.indirectEventListeners={};var method=this[methodName];var indirectIndex=this.getIndirectIndex();if(!this.indirectEventListeners[methodName]){return this.indirectEventListeners[methodName]=new Function("event","if ( window.indirectObjects === undefined ) return;"+
"try { event = Event.prep( event ); } catch( e ) {}"+
"var o = window.indirectObjects["+indirectIndex+"];"+
"if ( !o ) return;"+
"var r = o.delegateEvent( event, '"+methodName+
"' ); if ( r ) return r; if ( o[ '"+methodName+
"' ] ) return o['"+methodName+"'].call( o, event );");}
return this.indirectEventListeners[methodName];}};List=new Class(Component,{disableUnSelect:false,viewMode:"tile",enableMagnifier:false,magnifierElement:null,magnifyDelay:100,singleSelect:false,updateCache:false,cacheObject:null,perPage:30,noClickSelection:false,hoverDelay:100,checkboxSelection:false,selectLimit:0,activatable:true,flyoutClasses:["flyout-left","flyout-right","flyout-top","flyout-bottom"],initObject:function(element,templateName){arguments.callee.applySuper(this,arguments);this.content=DOM.getElement(element+"-content");if(!this.content)
this.content=this.element;if(!templateName)
throw"List now takes an element, and a template as arguments";this.templateName=templateName;this.selected=[];this.focused=false;this.itempos={};this.items=[];this.unselectable={};this.lastselected=null;this.hoverElement=null;this.hoveredElement=null;this.hoverTimer=null;this.cacheObject=null;this.currentPage=1;},destroyObject:function(){this.selected.length=0;this.selected=null;this.items.length=0;this.items=null;this.unselectable=null;this.content=null;this.hoverElement=null;this.hoveredElement=null;this.magnifierElement=null;this.magnifierElementContent=null;this.cacheObject=null;arguments.callee.applySuper(this,arguments);},initEventListeners:function(){arguments.callee.applySuper(this,arguments);this.addEventListener(this.element,"DOMMouseScroll","eventDOMMouseScroll");DOM.addEventListener(this.element,"selectstart",Event.stop);},clearHover:function(){if(this.hoverElement)
DOM.removeClassName(this.hoverElement,"list-item-hover");this.hoverElement=null;if(this.hoverTimer)
this.hoverTimer.destroy();this.hoverTimer=null;},clearHovered:function(){if(this.hoveredElement)
DOM.removeClassName(this.hoveredElement,"list-item-hover");},deactivate:function(){arguments.callee.applySuper(this,arguments);this.clearHover();},setOption:function(opt,value){switch(opt){case"magnifierElement":if(!value)
break;this.magnifierElement=$(value);if(!this.magnifierElement)
break;this.magnifierElementContent=$(value+'-content');if(!this.magnifierElementContent)
this.magnifierElementContent=this.magnifierElement;if(!this.magnifierElement.mouseOverSet){var el=this.magnifierElement;DOM.addEventListener(this.magnifierElementContent,"mouseover",function(){DOM.addClassName(el,"hidden");});this.magnifierElement.mouseOverSet=true;}
break;case"enableMagnifier":if(!value)
DOM.addClassName(this.magnifierElement,"hidden");this[opt]=value;break;case"viewMode":DOM.removeClassName(this.element,/^mode-.*/);DOM.addClassName(this.element,"mode-"+value);this[opt]=value;break;case"singleselect":opt="singleSelect";default:this[opt]=value;}},setModel:function(model){if(this.model)
this.model.removeObserver(this);this.model=model;this.model.addObserver(this);this.retrieveItems();},getSelectedLength:function(){return this.selected.length;},getSelectedIDs:function(){return this.selected;},getFirstSelected:function(){return this.selected.length?this.selected[0]:null;},getSelectedItems:function(){var selected=[];for(var i=0;i<this.selected.length;i++)
selected.push(this.items[this.itempos[this.selected[i]]]);return selected;},getFirstItem:function(){return this.items.length?this.items[0]:null;},getItem:function(id){if(!defined(this.itempos[id]))
return null;else
return this.items[this.itempos[id]];},getItems:function(){return this.items;},getItemIds:function(){var ids=[];for(var i=0;i<this.items.length;i++)
ids.push(this.items[i].item_id);return ids;},replaceItems:function(items){var current=this.selected;this.resetView();for(var i=0;i<items.length;i++)
this.addItem(items[i],(current.indexOf(items[i].id)!=-1)?true:false);this.broadcastToObservers("listItemsUpdated",this,false,items);},updateItems:function(items,classes){for(var i=0;i<items.length;i++){var id=items[i].id;var pos=this.itempos[id];var zebra=(pos%2)?"even":"odd";if(!defined(pos))
continue;var selected=(this.selected.indexOf(id)!=-1)?true:false;var div=document.createElement("div");div.className=defined(classes)?classes:"list-item "+zebra;div.innerHTML=Template.process(this.templateName,{div:div,item:items[i],is:{selected:selected},list:this,index:pos});div.item_id=items[i].id;if(selected){DOM.addClassName(div,"selected");if(this.checkboxSelection)
this.toggleCheckbox(div,true);}
this.content.replaceChild(div,this.items[pos]);this.items[pos]=div;if(this.updateCache&&this.cacheObject)
this.cacheObject.setItem(items[i].id,items[i]);}
if(this.items.length)
this.setListEmpty(false);this.broadcastToObservers("listItemsUpdated",this,true,items);},addItem:function(item,selected,classes){this.setListEmpty(false);var pos=this.items.length;var zebra=(pos%2)?"even":"odd";var div=document.createElement("div");div.className=defined(classes)?classes:"list-item "+zebra;div.innerHTML=Template.process(this.templateName,{div:div,item:item,is:{selected:selected},list:this,index:pos});div.item_id=item.id;if(defined(item.type))
div.type=item.type;if(defined(item.unselectable)&&item.unselectable)
this.unselectable[item.id]=true;this.content.appendChild(div);this.items.push(div);this.itempos[item.id]=pos;if(this.updateCache&&this.cacheObject)
this.cacheObject.setItem(item.id,item);if(selected){DOM.addClassName(div,"selected");if(this.checkboxSelection)
this.toggleCheckbox(div,true);this.selected.add(item.id);}},removeItem:function(itemid){if(!defined(this.itempos[itemid]))
return;log("remove item "+itemid);this.removeItems([itemid]);},removeItems:function(items){var itemids=[];for(var i=0;i<items.length;i++){var idx=this.itempos[items[i]];if(!defined(idx))
continue;if(this.items[idx].item_id!=items[i])
continue;this.content.removeChild(this.items[idx]);if(this.lastselected==items[i])
this.lastselected=null;var len=this.items.length;for(var j=idx+1;j<len;j++)
this.itempos[this.items[j].item_id]=(j-1);this.selected.remove(items[i]);delete this.itempos[items[i]];this.items.splice(idx,1);if(this.items.length==0)
this.setListEmpty(true);itemids.push(items[i]);if(this.updateCache&&this.cacheObject)
this.cacheObject.deleteItem(items[i]);}
if(itemids.length)
this.broadcastToObservers("listItemsRemoved",this,itemids);},reset:function(){this.resetView();DOM.addClassName(this.element,"list-empty");},resetView:function(){this.selected=[];this.itempos={};var len=this.items.length;for(var i=0;i<len;i++)
this.content.removeChild(this.items[i]);this.items=[];this.lastselected=null;this.unselectable={};},setSelection:function(ids,nobcast){var startlen=this.selected.length;var idx;var selected=[];var e;for(var i=0;i<ids.length;i++){this.selected.add(ids[i]);idx=this.itempos[ids[i]];if(defined(idx)){e=this.items[idx];selected.push(e.item_id);DOM.addClassName(e,"selected");if(this.checkboxSelection)
this.toggleCheckbox(e,true);}}
if(nobcast)
return;if(startlen<this.selected.length&&selected.length)
this.broadcastToObservers("listItemsSelected",this,selected);},unsetSelection:function(ids){var startlen=this.selected.length;var selected=[];var idx;var e;for(var i=0;i<ids.length;i++){this.selected.remove(ids[i]);idx=this.itempos[ids[i]];if(!defined(idx))
continue;e=this.items[idx];selected.push(e.item_id);DOM.removeClassName(e,"selected");if(this.checkboxSelection)
this.toggleCheckbox(e,false);}
if(startlen>this.selected.length&&selected.length)
this.broadcastToObservers("listItemsUnSelected",this,selected);},resetSelection:function(){if(this.selected.length==0)
return;var selected=[];var idx;var e;for(var i=0;i<this.selected.length;i++){idx=this.itempos[this.selected[i]];if(!defined(idx))
continue;e=this.items[idx];selected.push(this.selected[i]);DOM.removeClassName(e,"selected");if(this.checkboxSelection)
this.toggleCheckbox(e,false);}
this.selected=[];if(selected.length)
this.broadcastToObservers("listItemsUnSelected",this,selected);},getListElementFromTarget:function(target){return DOM.getFirstAncestorByClassName(target,"list-item",true);},getItemIdFromTarget:function(target){var item=this.getListElementFromTarget(target);if(item)
return item.item_id;else
return undefined;},eventDOMMouseScroll:function(event){var delta=0;if(event.wheelDelta){delta=(event.wheelDelta*-0.5);}else if(event.detail){delta=(event.detail*10);}
var scrollt=this.content.scrollTop;this.content.scrollTop+=delta;if(scrollt!=this.content.scrollTop){this.reflow();event.stop();}},eventMouseDown:function(event){arguments.callee.applySuper(this,arguments);var ancestor=this.getListElementFromTarget(event.target);if(ancestor)
return;},eventDoubleClick:function(event){var ancestor=this.getListElementFromTarget(event.target);if(!ancestor)
return;if(this.selected.length)
this.broadcastToObservers("listItemsDoubleClicked",this,this.selected);},eventMouseOver:function(event){var element=this.getListElementFromTarget(event.target);if(element!==this.hoverElement){this.hoverElement=element;if(this.hoverTimer)
this.hoverTimer.destroy();this.hoverTimer=new Timer(this.getIndirectMethod("timedMouseover"),this.hoverDelay,1);if(!this.enableMagnifier||!element)
return;}
if(!this.enableMagnifier)
return;if(this.magnifierAttribute){var target=DOM.getMouseEventAttribute(event,this.magnifierAttribute);if(!target)
return;}
if(!this.cacheObject&&window.app&&app.assetCache)
this.cacheObject=app.assetCache;if(this.magnifyItemId&&this.magnifyItemId==element.item_id)
return;this.magnifyItemId=element.item_id;var item=this.cacheObject.getItem(this.magnifyItemId);if(!item)
return;this.magnifierElementContent.innerHTML=Template.process(this.magnifierTemplate,{item:item,list:this});if(this.magnifyTimer)
this.magnifyTimer.destroy();this.magnifyTimer=new Timer(this.getIndirectMethod("showMagnifier"),this.magnifyDelay,1);var cli=DOM.getClientDimensions();this.clientHX=cli.x/2;this.clientHY=cli.y/2;this.positionMagnifier(event);},showMagnifier:function(){if(!defined(this.magnifyItemId))
return;DOM.removeClassName(this.magnifierElement,"hidden");},eventMouseMove:function(event){if(!this.enableMagnifier||!defined(this.magnifyItemId)||!this.getListElementFromTarget(event.target))
return;this.positionMagnifier(event);},positionMagnifier:function(event){var m=DOM.getAbsoluteCursorPosition(event);var classX=(m.x>this.clientHX)?0:1;var classY=(m.y>this.clientHY)?2:3;if(classX!=this.magClassX||classY!=this.magClassY){for(var i=0;i<this.flyoutClasses.length;i++){if(i==classX||i==classY)
continue;DOM.removeClassName(this.magnifierElement,this.flyoutClasses[i]);}
DOM.addClassName(this.magnifierElement,this.flyoutClasses[classX]);DOM.addClassName(this.magnifierElement,this.flyoutClasses[classY]);this.magClassX=classX;this.magClassY=classY;}
m.x+=10;m.y+=15;DOM.setLeft(this.magnifierElement,m.x);DOM.setTop(this.magnifierElement,m.y);},eventMouseOut:function(event){var element;if(this.magnifierAttribute){var target=DOM.getMouseEventAttribute(event,this.magnifierAttribute);if(!target)
return;}else{element=this.getListElementFromTarget(event.relatedTarget);if(event.relatedTarget&&!element)
this.clearHover();}
if(this.enableMagnifier&&!element){if(this.magnifyTimer)
this.magnifyTimer.destroy();DOM.addClassName(this.magnifierElement,"hidden");this.magnifyItemId=undefined;event.stop();}},eventClick:function(event){if(this.noClickSelection)
return;var command=this.getMouseEventCommand(event);if(command)
return;var ancestor=this.getListElementFromTarget(event.target);if(!ancestor){if(event.ctrlKey||event.metaKey||event.shiftKey)
return;if(!this.disableUnSelect)
this.resetSelection();return;}
var item_id=ancestor.item_id;if(!this.singleSelect&&event.shiftKey){var sel=[];var start=this.itempos[this.lastselected]||0
var end=this.itempos[item_id];if(start>end){var tmp=end;end=start;start=tmp;}
for(var i=start;i<=end;i++){if(this.selectLimit&&(this.selected.length+sel.length)>=this.selectLimit){this.unsetSelection([this.items[i].item_id]);continue;}
if(this.selected.indexOf(this.items[i].item_id)==-1&&!this.unselectable[this.items[i].item_id])
sel.push(this.items[i].item_id);}
this.setSelection(sel);return;}else if(!this.singleSelect&&(event.ctrlKey||event.metaKey)){if(this.selected.indexOf(item_id)!=-1&&!this.unselectable[item_id]){this.lastselected=item_id;this.unsetSelection([item_id]);return;}}else{if(this.selected.length==1&&this.selected[0]==item_id){this.lastselected=item_id;if(this.toggleSelect)
this.unsetSelection([item_id]);return;}else{if(!this.toggleSelect)
this.resetSelection();}}
if(defined(this.unselectable[item_id]))
return;this.lastselected=item_id;if(this.toggleSelect){if(this.selected.indexOf(item_id)!=-1){log("unselecting "+item_id);this.unsetSelection([item_id]);return;}}
if(this.selectLimit&&this.selected.length>=this.selectLimit)
return this.unsetSelection([item_id]);log("selecting "+item_id);this.setSelection([item_id]);},timedMouseover:function(timer){if(this.hoveredElement)
this.clearHovered();if(this.hoverElement){DOM.addClassName(this.hoverElement,"list-item-hover");this.hoveredElement=this.hoverElement;}},listModelItems:function(modelobj,items,update,total,offset,count){this.length=total;this.broadcastToObservers("listTotal",this,total,this.currentPage,this.perPage,items.length);if(update){this.updateItems(items);return;}
DOM.removeClassName(this.element,"list-loading");if(modelobj.filteredEmpty)
this.setListEmpty(true,true);else if(modelobj.empty)
this.setListEmpty(true);else if(items.length)
this.setListEmpty(false);else if(!items.length)
this.setListEmpty(true);else
this.setListEmpty(false);this.replaceItems(items);},setListEmpty:function(empty,filtered){if(empty){if(filtered)
DOM.addClassName(this.element,"list-empty-filtered");else
DOM.removeClassName(this.element,"list-empty-filtered");DOM.addClassName(this.element,"list-no-results");}else{DOM.removeClassName(this.element,"list-no-results");DOM.removeClassName(this.element,"list-empty-filtered");}
DOM.removeClassName(this.element,"list-empty");this.broadcastToObservers("listEmpty",this,empty,filtered);},retrieveItems:function(){this.model.getItems(((this.currentPage-1)*this.perPage),this.perPage);},setPerPage:function(perPage){this.perPage=perPage;},setCurrentPage:function(currentPage){this.currentPage=currentPage;},listModelChanged:function(modelobj){this.retrieveItems();},pagerPageChange:function(pagerobj,page){this.setCurrentPage(page);this.retrieveItems();},componentActivated:function(comp){if(!this.enableMagnifier)
return;DOM.addClassName(this.magnifierElement,"hidden");},componentDeactivated:function(comp){if(!this.enableMagnifier)
return;DOM.addClassName(this.magnifierElement,"hidden");},toggleCheckbox:function(e,value){var es=e.getElementsByTagName("input");if(!es)
return;var type;for(var i=0;i<es.length;i++){type=es[i].getAttribute("type");type=type?type.toLowerCase():"";if(type=="checkbox"||type=="radio")
es[i].checked=value;}}});ListModel=new Class(Observable,{init:function(){arguments.callee.applySuper(this,arguments);if(arguments[0]instanceof Array)
this.source=arguments[0];app.c.addObserver(this);},getItems:function(start,end,callback){if(!start)
start=0;if(!end||end>this.source.length)
end=this.source.length;this.broadcastToObservers("listModelItems",this,this.source.slice(start,end));},assetsDeleted:function(cobj,ids){this.broadcastToObservers("listModelChanged",this);},assetsUpdated:function(cobj,ids){this.broadcastToObservers("listModelChanged",this);}});ModalMask=new Class(Component,{eventMouseDown:function(event){window.app.dismissTransients();}});App=new Class(Component,Component.Delegator,{NAMESPACE:"core",initObject:function(){arguments.callee.callSuper(this,document.documentElement);this.window=window;this.document=document;this.displayState={};this.dialogs={};this.flyouts={};this.modalStack=[];this.activeComponent=null;this.monitorTimer=new Timer(this.getIndirectMethod("monitor"),100);},destroyObject:function(){this.modalStack=null;this.dialogs=null;this.flyouts=null;this.displayState=null;this.activeComponent=null;this.document=null;this.window=null;arguments.callee.applySuper(this,arguments);},initEventListeners:function(){arguments.callee.applySuper(this,arguments);this.addEventListener(window,"resize","eventResize");this.addEventListener(window,"pagehide","eventPagehide");},eventClick:function(event){var command=this.getMouseEventCommand(event);switch(command){case"goToLocation":event.stop();this.gotoLocation(event.commandElement.getAttribute("href"));break;}},eventPagehide:function(event){if(!event.persisted){this.destroy();}},eventResize:function(event){return this.reflow(event);},eventUnload:function(event){this.destroy();},initComponents:function(){arguments.callee.applySuper(this,arguments);if(DOM.getElement("modal-mask"))
this.modalMask=this.addComponent(new ModalMask("modal-mask"));},monitor:function(timer){this.monitorDisplayState();this.monitorLocation();},monitorDisplayState:function(){var changed=0;var style=DOM.getComputedStyle(this.element);changed+=this.displayChanged(style,"fontSize");if(changed)
this.reflow();},displayChanged:function(object,property){try{if(this.displayState[property]!=object[property]){this.displayState[property]=object[property];return 1;}}catch(e){}
return 0;},getActiveComponent:function(){return this.activeComponent;},setActiveComponent:function(component){var modal=this.modalStack[this.modalStack.length-1];var ancestors=DOM.getAncestors(component.element,true);if(modal&&ancestors.indexOf(modal.element)>0&&modal.active)
return false;if(this.activeComponent&&this.activeComponent!==component)
this.activeComponent.deactivate();this.activeComponent=component;return true;},addModal:function(modal){this.modalStack.add(modal);this.modalMask.show();modal.show();this.stackModals();},removeModal:function(modal){modal.active=false;modal.hide();this.modalStack.remove(modal);this.stackModals();},STACK_RADIX:1000,stackModals:function(){for(var i=this.modalStack.length;i>0;i--)
DOM.setZIndex(this.modalStack[i-1].element,i*this.STACK_RADIX);DOM.setZIndex(this.modalMask.element,this.modalStack.length*this.STACK_RADIX-10);if(this.modalStack.length){this.modalMask.show();this.modalStack[this.modalStack.length-1].activate();}else
this.modalMask.hide();},dismissTransients:function(){for(var i=this.modalStack.length-1;i>=0;i--)
if(this.modalStack[i].transitory)
this.modalStack[i].close();},dismissAll:function(){while(this.modalStack.length)
this.removeModal(this.modalStack[0]);},gotoLocation:function(locationBase,locationArg){var location=(""+this.window.location);var parts=location.split("#");if(locationBase){parts[0]=locationBase;this.monitorTimer.stop();}
if(locationArg)
parts[1]=encodeURI(this.encodeLocation(locationArg));else
parts.length=1;location=parts.join("#");if(this.location==location)
return;this.location=location;if(!locationBase&&defined(this.window.clipboardData)){var iframe=this.document.getElementById("__location");iframe.contentWindow.document.open("text/html");iframe.contentWindow.document.write("<script type='text/javascript'>"+
"if( window.parent && window.parent.app )"+
"window.parent.app.replaceLocation( '"+this.location+"' );"+
"</script>"+
"<body style='background: rgb("+
Math.floor(Math.random()*256)+","+
Math.floor(Math.random()*256)+","+
Math.floor(Math.random()*256)+")'>"+
this.location+"</body>");}
else{this.window.location=this.location;if((""+this.window.location)!=this.location)
this.monitorTimer.stop();}
this.parseLocation();if(!locationBase){this.exec();this.broadcastToObservers("exec");}},replaceLocation:function(location){this.window.location.replace(location);if(this.location==location)
return;this.location=location;this.parseLocation();this.exec();this.broadcastToObservers("exec");},monitorLocation:function(){var location=(""+window.location);if(this.location==location)
return;this.location=location;this.parseLocation();this.exec();this.broadcastToObservers("exec");},parseLocation:function(){if(!defined(this.locationArg))
this.locationArg=null;try{var parts=this.location.split("#");var arg=decodeURI(parts[1]||"");this.locationArg=this.decodeLocation(arg);}catch(e){}
return this.locationArg;},encodeLocation:function(obj){var loc=[];for(key in obj)
if(obj.hasOwnProperty(key)&&typeof obj[key]!="function")
loc.push(key+":"+((obj[key]instanceof Array)?obj[key].join(","):obj[key]));return loc.join("/");},decodeLocation:function(arg){var obj={};var vals=arg.split("/");var kv;for(var i=0;i<vals.length;i++){if(!defined(vals[i]))
continue;kv=vals[i].split(":");if(kv&&kv.length>1)
obj[kv[0]]=kv[1];else
obj[vals[i]]=true;}
return obj;},exec:function(){}});App.bootstrap=function(){window.app=App.initSingleton();};App.bootstrapInline=function(defer){this.deferBootstrap=defer;if(defer){DOM.addEventListener(window,"load",this.bootstrap);}
else{this.bootstrapApp();}};App.bootstrapIframe=function(){this.deferBootstrap=false;this.bootstrapApp();};App.bootstrapCheck=function(){var e=DOM.getElement("bootstrapper");if(!e)
return log.warn('bootstrap checking...');if(this.bootstrapTimer)
this.bootstrapTimer.stop();this.bootstrapTimer=null;this.bootstrap();}
App.bootstrapApp=function(){if(this.deferBootstrap)
return;this.bootstrapTimer=new Timer(this.bootstrapCheck.bind(this),20);};if(defined(window.clipboardData)){try{document.execCommand("BackgroundImageCache",false,true);}catch(e){}
var blankURI=window.__blankURI__||"about:blank";var iframe=document.createElement('div');iframe.innerHTML="<iframe id='__location' src='"+blankURI+
"' width='0' height='0' frameborder='0' style='visibility:hidden;position:absolute;left:0;top:0;'></iframe>";iframe=iframe.firstChild;var insertIframe=function(){document.body.appendChild(iframe);};if(document.addEventListener){document.addEventListener("DOMContentLoaded",insertIframe,false);}else{document.attachEvent("onreadystatechange",insertIframe,false);}}
Cache=new Class(Object,{maxLength:100,hits:0,misses:0,init:function(maxLength){if(maxLength>0)
this.maxLength=maxLength;this.flush();},flush:function(){this.length=0;this.LRU=0;this.MRU=0;this.IDX={};this.KEY=[];this.VALUE=[];this.PREV=[];this.NEXT=[];this.DELETE=[];},getItemsOrdered:function(offset,count){offset=offset||0;count=count||this.length;var keys=[];var values=[];var idx=this.MRU;var c=0;for(var i=0;i<this.length;i++){if(i<offset){idx=this.NEXT[idx];continue;}
keys.push(this.KEY[idx]);values.push(this.VALUE[idx]);c++;if(c>=count)
break;idx=this.NEXT[idx];}
return[keys,values];},getItems_:function(){return[this.KEY,this.VALUE];},deleteItem:function(key){if(!this.IDX.hasOwnProperty(key))
return undefined;var value=this.VALUE[this.IDX[key]];this.deleteNode(key);return value;},setItem:function(key,value){if(!defined(key)||!defined(value))
return undefined;var idx;if(this.IDX.hasOwnProperty(key))
idx=this.deleteNode(key);else if(this.length>=this.maxLength&&defined(this.KEY[this.LRU]))
idx=this.deleteNode(this.KEY[this.LRU]);else if(this.KEY.length&&this.KEY[this.LRU]==undefined)
idx=this.LRU;this.insertNode(key,value,idx);return value;},getItem:function(key){var idx=this.IDX[key];if(!this.IDX.hasOwnProperty(key)||idx<0||idx>=this.length||!defined(this.VALUE[idx])){this.misses++;return undefined;}
this.hits++;this.setMRU(idx);return this.VALUE[idx];},getItems:function(ids){var items=[];for(var i=0;i<ids.length;i++){var item=this.getItem(ids[i]);if(item)
items.push(item);}
return items;},touchItem:function(key){var idx=this.IDX[key];if(!this.IDX.hasOwnProperty(key)||idx<0||idx>=this.length||!defined(this.VALUE[idx]))
return undefined;this.setMRU(idx);},setMRU:function(idx){var prevnode=this.PREV[idx];var nextnode=this.NEXT[idx];if(prevnode==-1){if(this.MRU!=idx)
log.error("LRUCache::setMRU idx:"+idx+" has an inconsistent PREV key (PREV:-1 but MRU != idx)");return;}
this.connectNodes(prevnode,nextnode);this.PREV[this.MRU]=idx;this.NEXT[idx]=this.MRU;this.PREV[idx]=-1;this.MRU=idx;},setLRU:function(idx){var nextnode=this.NEXT[idx];var prevnode=this.PREV[idx];if(nextnode==-1){if(this.LRU!=idx)
log.error("LRUCache::setLRU  idx:"+idx+" has an inconsistent NEXT key (NEXT:-1 but LRU != idx)");return;}
this.connectNodes(prevnode,nextnode);this.NEXT[this.LRU]=idx;this.PREV[idx]=this.LRU;this.NEXT[idx]=-1;this.LRU=idx;},connectNodes:function(prevnode,nextnode){if(prevnode==-1)
this.MRU=nextnode;else
this.NEXT[prevnode]=nextnode;if(nextnode==-1)
this.LRU=prevnode;else
this.PREV[nextnode]=prevnode;},deleteNode:function(key){var idx=this.IDX[key];this.setLRU(idx);delete this.IDX[key];this.KEY[idx]=undefined;this.VALUE[idx]=undefined;return idx;},insertNode:function(key,value,idx){if(!defined(idx))
idx=this.length++;this.setMRU(idx);this.VALUE[idx]=value;this.KEY[idx]=key;this.IDX[key]=idx;return idx;},visualize:function(){var c=this.LRU;log.warn("LRUCache::visualize MRU: "+c);for(var i=0;i<this.length;i++){log.warn("LRUCache::visualize [ "+this.KEY[c]+" ] "+c+
((this.LRU==c)?" - LRU":"")+((this.MRU==c)?" - MRU":""));c=this.PREV[c];}}});Client=new Class(Observable,{init:function(url,user,password){arguments.callee.applySuper(this,arguments);this.url=url;this.user=user;this.password=password;this.baseId="c"+Unique.id();this.count=0;},call:function(obj){return this.request(obj);},request:function(obj){obj.client=this;return new this.constructor.Request(obj);},getUniqueId:function(){return this.baseId+"r"+this.count++;}});Client.Request=new Class(Observable,{contentType:"text/javascript+json",init:function(obj){arguments.callee.applySuper(this,arguments);this.state="new";this.client=obj.client;this.method=obj.method||"default";this.params=obj.params||[];this.heap=obj.heap;this.id=defined(this.heap)?this.client.getUniqueId():null;this.asynchronous=this.heap?true:false;this.request={id:this.id,method:this.method,params:this.params};if(obj.delay){this.timer=new Timer(this.start.bind(this),obj.delay,1);}else
this.start();},start:function(){this.timer=null;this.state="started";this.transport=new XMLHttpRequest();if(this.id!=null)
this.transport.onreadystatechange=this.readyStateChange.bind(this);this.transport.open("POST",this.client.url,this.asynchronous,this.client.user,this.client.password);this.transport.setRequestHeader("content-type",this.contentType);this.transport.send(Object.toJSON(this.request));},stop:function(){this.state="stopped";this.heap=null;this.client=null;if(this.timer)
this.timer.stop();if(this.transport)
this.transport.abort();},readyStateChange:function(){if(this.transport.readyState!=4||this.state!="started")
return;this.state="finished";this.response={id:this.id,result:null,error:null};try{if(this.transport.responseText.charAt(0)=="{"){try{this.response=eval("("+this.transport.responseText+")");}catch(e){this.response.error="error in eval/parse of responseText";}}else{this.response.error="Status: "+this.transport.status+" Error: Response not in JSON format";log.error(this.transport.responseText.encodeHTML());}}catch(e){if(e.message)
e=e.message;this.response.error=e;}
this.response.status=this.transport.status;if(this.heap&&this.heap.callback){if(this.processCallbacks(this.heap.callback))
return;}
this.heap=null;this.client=null;},processCallbacks:function(callbacks){if(callbacks instanceof Array){for(var i=0;i<callbacks.length;i++){callbacks[i](this.response,this.heap,this);}}else{callbacks(this.response,this.heap,this);}
return false;},pause:function(){this.state="paused";if(this.timer)
this.timer.pause();}});Client.simpleRequest=function(url,params,callback){url=url+(url.match(/\?/)?"&":"?")+String.encodeQuery(params);var transport=new XMLHttpRequest();transport.onreadystatechange=function(){if(transport.readyState!=4)
return;callback(transport.responseText);};transport.open("GET",url,true);transport.send("");};Template=new Class(Object,{beginToken:"[#",endToken:"#]",init:function(source){if(source)
this.compile(source);},compile:function(source){var statements=["context.open();","with( context.vars ) { "];var start=0,end=-this.endToken.length;while(start<source.length){end+=this.endToken.length;start=source.indexOf(this.beginToken,end);if(start<0)
start=source.length;if(start>end)
statements.push("context.write( ",'"'+source.substring(end,start).escapeJS()+'"'," );");start+=this.beginToken.length;if(start>=source.length)
break;end=source.indexOf(this.endToken,start);if(end<0)
throw"Template parsing error: Unable to find matching end token ("+this.endToken+").";var length=(end-start);if(length<=0)
continue;else if(length>=4&&source.charAt(start)=="-"&&source.charAt(start+1)=="-"&&source.charAt(end-1)=="-"&&source.charAt(end-2)=="-")
continue;else if(source.charAt(start)=="=")
statements.push("context.write( ",source.substring(start+1,end)," );");else if(source.charAt(start)=="*"){var cmd=source.substring(start+1,end).match(/^\s*(\w+)/);if(cmd){cmd=cmd[1];switch(cmd){case"return":statements.push("return context.close();");}}
}else if(source.charAt(start)=="|"){start+=1;var afterfilters=source.substring(start,end).search(/\s/);var filters=[];var params=[];if(afterfilters>0){filters=source.substring(start,start+afterfilters).replace(/(\w+)(\(([^\)]+)\))?/g,"$1|$3").split("|");afterfilters+=1;}else{filters=["h",""];}
var cmds=[];var params=[];for(var j=0;j<filters.length;j++){if(j%2)
params.push(filters[j]);else
cmds.push(filters[j]);}
filters=cmds.reverse();var numfilters=filters.length;filters.push(source.substring(start+afterfilters,end));for(var i=0;i<numfilters;i++){filters[i]=" context.f."+filters[i]+"( ";filters.push(", context");if(params[i]!="")
filters.push(", ["+params[i]+"]");filters.push(" )");}
filters=filters.join("");statements.push("context.write( "+filters+" );");}
else
statements.push(source.substring(start,end));}
statements.push("} return context.close();");this.process=new Function("context",statements.join("\n"));},process:function(context){return"";},exec:function(context){log("Template::exec() method has been deprecated. Please use process() instead or "+
"the new static Template.process( name[, vars[, templates]] ) method.");return this.process(context);}});extend(Template,{templates:{},process:function(name,vars,templates){var context=new Template.Context(vars,templates);return context.include(name);}});Template.Context=new Class(Object,{init:function(vars,templates){this.vars=vars||{};this.templates=templates||Template.templates;this.stack=[];this.out=[];this.f=Template.Filter;},include:function(name){if(!this.templates.hasOwnProperty(name)){log.error("Template name "+name+" does not exist!");return;}
if(typeof this.templates[name]=="string")
this.templates[name]=new Template(this.templates[name]);try{return this.templates[name].process(this);}catch(e){var error="Error while processing template:"+name+" - "+e.message;log.error(error);throw error;}},write:function(){this.out.push.apply(this.out,arguments);},writeln:function(){this.write.apply(this,arguments);this.write("\n");},clear:function(){this.out.length=0;},exit:function(){return this.getOutput();},getOutput:function(){return this.out.join("");},open:function(){this.stack.push(this.out);this.out=[];},close:function(){var result=this.getOutput();this.out=this.stack.pop()||[];return result;}});Template.Filter={i:function(string,context){if((typeof string!="string")&&string&&string.toString)
string=string.toString();return string.interpolate(context.vars);},h:function(string,context){if((typeof string!="string")&&string&&string.toString)
string=string.toString();return(typeof string=="string")?string.encodeHTML():"".encodeHTML(string);},H:function(string,context){if((typeof string!="string")&&string&&string.toString)
string=string.toString();return(typeof string=="string")?string.decodeHTML():"".encodeHTML(string);},U:function(string,context){return decodeURI(string);},u:function(string,context){return encodeURI(string).replace(/\//g,"%2F");},lc:function(string,context){if((typeof string!="string")&&string&&string.toString)
string=string.toString();return(typeof string=="string")?string.toLowerCase():"".toLowerCase(string);},uc:function(string,context){if((typeof string!="string")&&string&&string.toString)
string=string.toString();return(typeof string=="string")?string.toUpperCase():"".toUpperCase(string);},substr:function(string,context,params){if(!params)
throw"Template Filter Error: substr() requires at least one parameter";if(params[0]<0)
params[0]=string.length+params[0];return String.substr.apply(string,params);},ws:function(string,context){if((typeof string!="string")&&string&&string.toString)
string=string.toString();return(typeof string=="string")?string.replace(/^\s+/g,"").replace(/\s+$/g,""):string;},trim:function(string,context,params){if(!params)
throw"Template Filter Error: trim() requires at least one parameter";if((typeof string!="string")&&string&&string.toString)
string=string.toString();if((typeof string=="string")&&string.length>params[0]){string=string.substr(0,params[0]);var newstr=string.replace(/\w+$/,"");return((newstr=="")?string:newstr)+"\u2026";}else
return string;},date:function(string,context){if((typeof string!="string")&&string&&string.toString)
string=string.toString();var date=Date.fromISOString(string);return(date)?date.toISODateString():"";},localeDate:function(string,context){if((typeof string!="string")&&string&&string.toString)
string=string.toString();var date=Date.fromISOString(string);return(date)?date.toLocaleString():"";},rt:function(string,context){if((typeof string!="string")&&string&&string.toString)
string=string.toString();return(typeof string=="string")?string.replace(/<\/?[^>]+>/gi,""):string;},rp:function(string,params){if((typeof string!="string")&&string&&string.toString)
string=string.toString();if((typeof string=="string")&&params.length==2){return string.replace(params[0],params[1]);}else
return string;}};TC=function()
{}
TC.matchShortWords=/\b(\S*)\b/gi;TC.matchLeadingSpace=/^\s+/;TC.matchTrailingSpace=/\s+$/;TC.matchSpace=/\s+/g;TC.defined=function(x)
{try
{if(typeof x!="undefined")
return true;}
catch(e){}
return false;}
TC.inspect=function(x)
{var t="";for(var i in x)
t+=i+" = "+x[i]+"<br />";return t;}
TC.elementOrId=function(element)
{if(!element)
return null;if(typeof element=="string")
element=document.getElementById(element);return element;}
TC.applyFunction=function(elements,func)
{if(!elements)
return;for(var i in elements)
{var element=elements[i];if(!element)
continue;func(element);}}
TC.attachWindowEvent=function(eventName,func)
{var onEventName='on'+eventName;var old=window[onEventName];if(typeof old!='function')
window[onEventName]=func;else
{window[onEventName]=function(evt)
{old(evt);return func(evt);};}}
TC.attachLoadEvent=function(func)
{TC.attachWindowEvent('load',func);}
TC.attachBeforeUnloadEvent=function(func)
{var old=window.onbeforeunload;if(typeof old!='function')
window.onbeforeunload=func;else
{window.onbeforeunload=function(evt)
{old(evt);return func(evt);};}}
TC.attachDocumentEvent=function(element,eventName,func,recurse)
{if(!element||!element.document)
return;var doc=element.document;TC.attachEvent(doc,eventName,func);if(!recurse)
return;var elements=[];if(doc.frames)
{for(var i in doc.frames);elements[elements.length]=doc.frames[i];}
var iframes=doc.getElementsByTagName("iframe")||[];for(var i in iframes)
elements[elements.length]=iframes[i];for(var i in elements)
{if(!elements[i]||!elements[i].contentWindow)
continue;TC.attachDocumentEvent(elements[i].contentWindow,eventName,func,recurse);}}
TC.attachEvent=function(element,eventName,func)
{element=TC.elementOrId(element);if(!element)
return;if(element.addEventListener)
element.addEventListener(eventName,func,true);else if(element.attachEvent)
element.attachEvent("on"+eventName,func);else
element["on"+eventName]=func;}
TC.detachEvent=function(element,eventName,func)
{element=TC.elementOrId(element);if(!element)
return;if(element.removeEventListener)
element.removeEventListener(eventName,func,true);else if(element.detachEvent)
element.detachEvent("on"+eventName,func);else
element["on"+eventName]=null;}
TC.stopEvent=function(evt)
{evt=evt||event;if(evt.preventDefault)
evt.preventDefault();if(evt.stopPropagation)
evt.stopPropagation();if(TC.defined(evt.returnValue))
{evt.cancelBubble=true;evt.returnValue=false;}
return false;}
TC.allowTabs=function(element)
{element=TC.elementOrId(element);TC.attachEvent(element,"keypress",TC.allowTabs.keyPress);TC.attachEvent(element,"keydown",TC.allowTabs.keyDown);}
TC.allowTabs.keyPress=function(evt)
{evt=evt||event;var element=evt.target||evt.srcElement;if(evt.keyCode==9)
{return TC.stopEvent(evt);}
return true;}
TC.allowTabs.keyDown=function(evt)
{evt=evt||event;var element=evt.target||evt.srcElement;if(evt.keyCode==9)
{TC.setSelectionValue(element,"\t");return false;}
return true;}
TC.allowHover=function(element)
{element=TC.elementOrId(element);TC.attachEvent(element,"mouseover",TC.allowHover.mouseOver);TC.attachEvent(element,"mouseout",TC.allowHover.mouseOut);}
TC.allowHover.mouseOver=function(evt)
{evt=evt||event;var element=evt.target||evt.srcElement;TC.addClassName(element,"hover");}
TC.allowHover.mouseOut=function(evt)
{evt=evt||event;var element=evt.target||evt.srcElement;TC.removeClassName(element,"hover");}
TC.getSelection=function(element)
{var doc=TC.getOwnerDocument(element);var win=TC.getOwnerWindow(doc);if(win.getSelection)
return win.getSelection();else if(doc.getSelection)
return doc.getSelection();else if(doc.selection)
return doc.selection;return null;}
TC.getCaretPosition=function(element)
{var doc=TC.getOwnerDocument(element);if(doc.selection){var range=doc.selection.createRange();var isCollapsed=range.compareEndPoints("StartToEnd",range)==0;if(!isCollapsed)
range.collapse(true);var b=range.getBookmark();return b.charCodeAt(2)-2;}else if(element.selectionStart!='undefined'){return element.selectionStart;}
return null;}
TC.setCaretPosition=function(element,pos)
{if(element.createTextRange){var range=element.createTextRange();range.collapse(true);range.moveStart("character",pos);range.select();return true;}else{element.selectionStart=pos;element.selectionEnd=pos;return true;}
return false;}
TC.createRange=function(selection,element)
{var doc=TC.getOwnerDocument(element);if(selection&&selection.getRangeAt)
return selection.getRangeAt(0);else if(selection&&selection.createRange)
return selection.createRange();else if(doc.createRange)
return doc.createRange();return null;}
TC.extractElementText=function(element)
{element=TC.elementOrId(element);if(!element||element.nodeType==8)
return'';var tagName=element.tagName?element.tagName.toLowerCase():'';if(tagName=='input'||tagName=='textarea')
return'';var text=element.nodeValue!=null?element.nodeValue:'';for(var i=0;i<element.childNodes.length;i++)
text+=TC.extractElementText(element.childNodes[i]);return text;}
TC.setSelectionValue=function(element,value)
{element=TC.elementOrId(element);var scrollFromBottom=element.scrollHeight-element.scrollTop;if(document.selection)
{element.focus();document.selection.createRange().text=value;}
else
{var length=element.textLength;var start=element.selectionStart;var end=element.selectionEnd;element.value=element.value.substring(0,start)+
value+element.value.substring(end,length);element.caretPos=start+length;element.selectionStart=start+value.length;element.selectionEnd=start+value.length;}
element.scrollTop=element.scrollHeight-scrollFromBottom;}
TC.normalizeWords=function(text)
{text=text.toLowerCase();var originalWords=text.match(matchShortWords);var exists=new Array();var words=new Array();for(i=0;i<originalWords.length;i++)
{if(exists[originalWords[i]])
continue;exists[originalWords[i]]=1;words[words.length]=originalWords[i];}
words.sort();return words;}
TC.getOwnerDocument=function(element)
{if(!element)
return document;if(element.ownerDocument)
return element.ownerDocument;if(element.getElementById)
return element
return document;}
TC.getOwnerWindow=function(element)
{if(!element)
return window;if(element.parentWindow)
return element.parentWindow;var doc=TC.getOwnerDocument(element);if(doc&&doc.defaultView)
return doc.defaultView;return window;}
TC.getElementsByTagAndClassName=function(tagName,className,root)
{root=TC.elementOrId(root);if(!root)
root=document;var allElements=root.getElementsByTagName(tagName);var elements=[];for(var i=0;i<allElements.length;i++)
{var element=allElements[i];if(!element)
continue;if(TC.hasClassName(element,className))
elements[elements.length]=element;}
return elements;}
TC.getElementsByClassName=function(className,root)
{return TC.getElementsByTagAndClassName("*",className,root);}
TC.getParentByTagName=function(element,tagName)
{tagName=tagName.toLowerCase();var parent=element.parentNode;while(parent)
{if(parent.tagName&&parent.tagName.toLowerCase()==tagName)
return parent;parent=parent.parentNode;}
return null;}
TC.inlineDisplays={"inline":1,"inline-block":1}
TC.isInlineNode=function(node)
{if(node.nodeType==3)
return true;if(node.nodeType==9)
return false;if(node.nodeType!=1)
return true;if(node.tagName&&node.tagName.toLowerCase()=="br")
return false;var d=TC.getStyle(node,"display");if(TC.inlineDisplays[d])
return true;return false;}
TC.getPreviousTextNode=function(node,inline)
{var up=false;while(node)
{if(!up&&node.lastChild)
{node=node.lastChild;up=false;}
else if(node.previousSibling)
{node=node.previousSibling;up=false;}
else if(node.parentNode)
{node=node.parentNode;up=true;}
else
return null;if(node.nodeType==3)
return node;if(inline&&!TC.isInlineNode(node))
return null;}
return null;}
TC.getNextTextNode=function(node,inline)
{var up=false;while(node)
{if(!up&&node.firstChild)
{node=node.firstChild;up=false;}
else if(node.nextSibling)
{node=node.nextSibling;up=false;}
else if(node.parentNode)
{node=node.parentNode;up=true;}
else
return null;if(node.nodeType==3)
return node;if(inline&&!TC.isInlineNode(node))
return null;}
return null;}
TC.setAttributes=function(element,attr)
{element=TC.elementOrId(element);if(!element||!attr)
return;for(var a in attr)
element.setAttribute(a,attr[a]);}
TC.hasClassName=function(element,className)
{if(!element||!element.className||typeof element.className!='string'||!className)
return false;var classNames=element.className.split(TC.matchSpace);for(var i=0;i<classNames.length;i++)
{if(classNames[i]==className)
return true;}
return false;}
TC.getClassNames=function(e){if(!e||!e.className)
return[];return e.className.split(/\s+/g);}
TC.addClassName=function(e,cn){if(!e||!cn)
return false;var cs=TC.getClassNames(e);for(var i=0;i<cs.length;i++){if(cs[i]==cn)
return true;}
cs.push(cn);e.className=cs.join(" ");return false;}
TC.removeClassName=function(e,cn){var r=false;if(!e||!e.className||!cn)
return r;var cs=(e.className&&e.className.length)?e.className.split(/\s+/g):[];var ncs=[];if(cn instanceof RegExp){for(var i=0;i<cs.length;i++){if(cn.test(cs[i])){r=true;continue;}
ncs.push(cs[i]);}}else{for(var i=0;i<cs.length;i++){if(cs[i]==cn){r=true;continue;}
ncs.push(cs[i]);}}
if(r)
e.className=ncs.join(" ");return r;}
TC.getComputedStyle=function(e)
{if(e.currentStyle)
return e.currentStyle;var style={};var owner=TC.getOwnerDocument(e);if(owner&&owner.defaultView&&owner.defaultView.getComputedStyle){try{style=owner.defaultView.getComputedStyle(e,null);}catch(e){}}
return style;}
TC.getStyle=function(element,property)
{element=TC.elementOrId(element);var style;if(window.getComputedStyle)
style=window.getComputedStyle(element,null).getPropertyValue(property);else if(element.currentStyle)
style=element.currentStyle[property];return style;}
TC.setStyle=function(element,style)
{element=TC.elementOrId(element);if(!element||!element.style||!style)
return;for(var s in style)
element.style[s]=style[s];}
TC.getAbsolutePosition=function(element)
{element=TC.elementOrId(element);var pos={"left":0,"top":0};if(!element)
return pos;while(element)
{pos.left+=element.offsetLeft;pos.top+=element.offsetTop;element=element.offsetParent;}
return pos;}
TC.getAbsoluteCursorPosition=function(evt)
{evt=evt||event;var pos={x:evt.clientX,y:evt.clientY};if(document.documentElement&&TC.defined(document.documentElement.scrollLeft))
{pos.x+=document.documentElement.scrollLeft;pos.y+=document.documentElement.scrollTop;}
else if(TC.defined(window.scrollX))
{pos.x+=window.scrollX;pos.y+=window.scrollX;}
else if(document.body&&TC.defined(document.body.scrollLeft))
{pos.x+=document.body.scrollLeft;pos.y+=document.body.scrollTop;}
return pos;}
TC.scramble=function(array)
{var length=array.length;for(var i=0;i<length;i++)
{var a=Math.floor(Math.random()*length);var b=Math.floor(Math.random()*length);var temp=array[a];array[a]=array[b];array[b]=temp;}}
TC.TableSelect=function(element){var self=this;this.clickClosure=function(evt){return self.click(evt);};this.focusRow=null;this.lastClicked=null;this.thisClicked=null;this.updating=false;this.shiftKey=false;this.onChange=null;this.init(element);}
TC.TableSelect.prototype.rowSelect=false;TC.TableSelect.prototype.init=function(container){container=TC.elementOrId(container);if(!container)return;this.container=container;TC.attachEvent(container,"click",this.clickClosure);this.selectAll();}
TC.TableSelect.prototype.eventKeyPress=function(evt){evt=evt||event;var element=evt.target||evt.srcElement;var c=(String.fromCharCode(evt.charCode||evt.keyCode)||"");switch(c){case'J':this.focusSelect();case'j':this.focusNext();break;case'K':this.focusPrevious();this.focusSelect();break;case'k':this.focusPrevious();break;case'X':this.shiftKey=true;case'x':this.focusSelect();break;}
return evt;}
TC.TableSelect.prototype.focusNext=function(){var next=this.getNextSibling(this.focusRow);var n;while(next&&(((next.tagName?next.tagName.toLowerCase():'')!='tr')||(TC.hasClassName(next,"slave"))||!((n=TC.getComputedStyle(next))&&n["display"]!="none"))){next=this.getNextSibling(next);}
if(next){this.setFocus(next);}}
TC.TableSelect.prototype.focusPrevious=function(){var prev=this.getPreviousSibling(this.focusRow);var n;while(prev&&(((prev.tagName?prev.tagName.toLowerCase():'')!='tr')||(TC.hasClassName(prev,"slave"))||!((n=TC.getComputedStyle(prev))&&n["display"]!="none"))){prev=this.getPreviousSibling(prev);}
if(prev){this.setFocus(prev);}}
TC.TableSelect.prototype.focusSelect=function(){var parent=this.focusRow;if(!parent)return;var elements=TC.getElementsByTagAndClassName("input","select",parent);for(var i=0;i<elements.length;i++){element=elements[i];if((element.type=="checkbox")||(element.type=="radio")){element.checked=!element.checked;return this.select(element);}}}
TC.TableSelect.prototype.click=function(evt){evt=evt||event;var element=evt.target||evt.srcElement;this.shiftKey=evt.shiftKey;var tagName=element.tagName?element.tagName.toLowerCase():null;if(tagName=="input"&&TC.hasClassName(element,"select")){if((element.type=="checkbox")||(element.type=="radio")){var parent=TC.getParentByTagName(element,"tr");if(parent)this.setFocus(parent);return this.select(element,parent);}}
if(!this.rowSelect&&tagName!="td")return;if((tagName=='a')||(TC.getParentByTagName(element,"a")))
return;var parent;if((tagName=="li"||tagName=="label"||tagName=="span")&&TC.hasClassName(TC.getParentByTagName(element,"div"),"mt-table__hierarchy")){if(tagName=="li"){parent=element;}else{parent=TC.getParentByTagName(element,"li");}}else{parent=TC.getParentByTagName(element,"tr");}
while(TC.hasClassName(parent,"slave"))
parent=this.getPreviousSibling(parent);if(parent){this.setFocus(parent);var elements=TC.getElementsByTagAndClassName("input","select",parent);for(var i=0;i<elements.length;i++){element=elements[i];if((element.type=="checkbox")||(element.type=="radio")){if(element.disabled)return;if(element.type==="radio"&&element.checked)return;element.checked=!element.checked;return this.select(element,parent);}}}}
TC.TableSelect.prototype.select=function(checkbox,row){this.thisClicked=checkbox;var checked=checkbox.checked?true:false;var all=checkbox.value=="all"?true:false;if(all){this.thisClicked=null;this.lastClicked=null;this.focusRow=null;return this.selectAll(checkbox);}
if(this.selectRow(row,checked)){if(this.onChange)this.onChange(this,row,checked);if(checkbox.type=="radio"){this.lastClicked=null;this.clearOthers(row);return;}}
this.selectAll();this.lastClicked=this.thisClicked;}
TC.TableSelect.prototype.clearOthers=function(sel_row){var rows=this.container.getElementsByTagName("tr");for(var i=0;i<rows.length;i++){var row=rows[i];if(!row||!row.tagName)
continue;if(row.id==sel_row.id)
continue;this.selectRow(row,false);}}
TC.TableSelect.prototype.setFocus=function(row){if(this.focusRow){TC.removeClassName(this.focusRow,"has-focus");var next=this.getNextSibling(this.focusRow);while(next&&TC.hasClassName(next,"slave")){TC.removeClassName(next,"has-focus");next=this.getNextSibling(next);}}
this.focusRow=row;if(this.focusRow){TC.addClassName(this.focusRow,"has-focus");var next=this.getNextSibling(this.focusRow);while(next&&TC.hasClassName(next,"slave")){TC.addClassName(next,"has-focus");next=this.getNextSibling(next);}}}
TC.TableSelect.prototype.selectAll=function(checkbox){if(this.updating)return;this.updating=true;var alls=[];var count=0;var selectedCount=0;var invert=false;var lastClicked=-1;var thisClicked=-1;var rows=this.container.getElementsByTagName("tr");for(var i=0;i<rows.length;i++){var row=rows[i];if(!row||!row.tagName)
continue;var inputs=row.getElementsByTagName("input");for(var j=0;j<inputs.length;j++){var input=inputs[j];if(((input.type!="checkbox")&&(input.type!="radio"))||!TC.hasClassName(input,"select"))
continue;if(this.lastClicked&&input==this.lastClicked)
lastClicked=i;if(this.thisClicked&&input==this.thisClicked)
thisClicked=i;}
invert=this.shiftKey;}
for(var i=0;i<rows.length;i++){var row=rows[i];if(!row||!row.tagName)
continue;var inputs=row.getElementsByTagName("input");for(var j=0;j<inputs.length;j++){var input=inputs[j];if(((input.type!="checkbox")&&(input.type!="radio"))||!TC.hasClassName(input,"select"))
continue;if(input.value!='all'){if(this.focusRow==null)
this.setFocus(row);}
var checked;if(checkbox){var checked;if(invert)
checked=!input.checked;else
checked=checkbox?checkbox.checked:input.checked;input.checked=checked;if(this.selectRow(row,checked)){if(input.value!="all"){if(this.onChange)this.onChange(this,row,checked);}}}
if(input.value=="all")
alls[alls.length]=input;else{count++;if(input.checked)
selectedCount++;}}}
if((lastClicked!=-1)&&(this.shiftKey)){var low,hi;if(thisClicked<lastClicked){low=thisClicked;hi=lastClicked;}else{low=lastClicked;hi=thisClicked;}
for(i=low+1;i<hi;i++){var row=rows[i];if(!row||!row.tagName)
continue;var inputs=row.getElementsByTagName("input");for(var j=0;j<inputs.length;j++){var input=inputs[j];if(((input.type!="checkbox")&&(input.type!="radio"))||!TC.hasClassName(input,"select")||input.value=="all")
continue;input.checked=this.thisClicked.checked;}
if(this.selectRow(row,this.thisClicked.checked)){if(this.onChange)this.onChange(this,row,this.thisClicked.checked);}}
this.lastClicked.checked=this.thisClicked.checked;if(this.selectRow(rows[lastClicked],this.lastClicked.checked)){if(this.onChange)this.onChange(this,rows[lastClicked],this.lastClicked.checked);}}
for(var i=0;i<alls.length;i++){if(count&&count==selectedCount){alls[i].checked=true;}else
alls[i].checked=false;}
this.shiftKey=false;this.updating=false;}
TC.TableSelect.prototype.selected=function(){var values=[];var rows=this.container.getElementsByTagName("tr");for(var i=0;i<rows.length;i++){var row=rows[i];if(!row||!row.tagName)
continue;var inputs=row.getElementsByTagName("input");for(var j=0;j<inputs.length;j++){var input=inputs[j];if(((input.type!="checkbox")&&(input.type!="radio"))||!TC.hasClassName(input,"select"))
continue;if(input.checked)
values[values.length]=input;}}
return values;}
TC.TableSelect.prototype.selectRow=function(row,checked){if(!row)return false;var changed=false;if(checked){if(!TC.hasClassName(row,"mt-table__highlight")){TC.addClassName(row,"mt-table__highlight");changed=true;}}else{if(TC.hasClassName(row,"mt-table__highlight")){TC.removeClassName(row,"mt-table__highlight");changed=true;}}
if(changed){var inputs=row.getElementsByTagName("input");for(var j=0;j<inputs.length;j++){var input=inputs[j];if(input.type!="checkbox"||!TC.hasClassName(input,"select"))
continue;input.checked=checked;}
var next=this.getNextSibling(row);while(next&&TC.hasClassName(next,"slave")){if(checked)
TC.addClassName(next,"mt-table__highlight");else
TC.removeClassName(next,"mt-table__highlight");next=this.getNextSibling(next);}}
return changed;}
TC.TableSelect.prototype.selectThese=function(list){for(var i=0;i<list.length;i++){var el=TC.elementOrId(list[i]);this.selectRow(el,true);}
this.selectAll();}
TC.TableSelect.prototype.getNextSibling=function(el){while(el){el=el.nextSibling;if(el&&el.tagName&&el.tagName.toLowerCase()=='tr')
break;}
return el;}
TC.TableSelect.prototype.getPreviousSibling=function(el){while(el){el=el.previousSibling;if(el&&el.tagName&&el.tagName.toLowerCase()=='tr')
break;}
return el;}