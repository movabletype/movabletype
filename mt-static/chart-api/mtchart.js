/*
 * debouncedresize: special jQuery event that happens once after a window resize
 *
 * latest version and complete README available on Github:
 * https://github.com/louisremi/jquery-smartresize
 *
 * Copyright 2012 @louis_remi
 * Licensed under the MIT license.
 *
 * This saved you an hour of work? 
 * Send me music http://www.amazon.co.uk/wishlist/HNTU0468LQON
 */
(function($) {

var $event = $.event,
	$special,
	resizeTimeout;

$special = $event.special.debouncedresize = {
	setup: function() {
		$( this ).on( "resize", $special.handler );
	},
	teardown: function() {
		$( this ).off( "resize", $special.handler );
	},
	handler: function( event, execAsap ) {
		// Save the context
		var context = this,
			args = arguments,
			dispatch = function() {
				// set correct event type
				event.type = "debouncedresize";
				$event.dispatch.apply( context, args );
			};

		if ( resizeTimeout ) {
			clearTimeout( resizeTimeout );
		}

		execAsap ?
			dispatch() :
			resizeTimeout = setTimeout( dispatch, $special.threshold );
	},
	threshold: 150
};

})(jQuery);
// ┌────────────────────────────────────────────────────────────────────┐ \\
// │ Raphaël 2.1.0 - JavaScript Vector Library                          │ \\
// ├────────────────────────────────────────────────────────────────────┤ \\
// │ Copyright © 2008-2012 Dmitry Baranovskiy (http://raphaeljs.com)    │ \\
// │ Copyright © 2008-2012 Sencha Labs (http://sencha.com)              │ \\
// ├────────────────────────────────────────────────────────────────────┤ \\
// │ Licensed under the MIT (http://raphaeljs.com/license.html) license.│ \\
// └────────────────────────────────────────────────────────────────────┘ \\
(function(t){var e,r,i="0.4.2",n="hasOwnProperty",a=/[\.\/]/,s="*",o=function(){},l=function(t,e){return t-e},h={n:{}},u=function(t,i){t+="";var n,a=r,s=Array.prototype.slice.call(arguments,2),o=u.listeners(t),h=0,c=[],f={},p=[],d=e;e=t,r=0;for(var g=0,x=o.length;x>g;g++)"zIndex"in o[g]&&(c.push(o[g].zIndex),0>o[g].zIndex&&(f[o[g].zIndex]=o[g]));for(c.sort(l);0>c[h];)if(n=f[c[h++]],p.push(n.apply(i,s)),r)return r=a,p;for(g=0;x>g;g++)if(n=o[g],"zIndex"in n)if(n.zIndex==c[h]){if(p.push(n.apply(i,s)),r)break;do if(h++,n=f[c[h]],n&&p.push(n.apply(i,s)),r)break;while(n)}else f[n.zIndex]=n;else if(p.push(n.apply(i,s)),r)break;return r=a,e=d,p.length?p:null};u._events=h,u.listeners=function(t){var e,r,i,n,o,l,u,c,f=t.split(a),p=h,d=[p],g=[];for(n=0,o=f.length;o>n;n++){for(c=[],l=0,u=d.length;u>l;l++)for(p=d[l].n,r=[p[f[n]],p[s]],i=2;i--;)e=r[i],e&&(c.push(e),g=g.concat(e.f||[]));d=c}return g},u.on=function(t,e){if(t+="","function"!=typeof e)return function(){};for(var r=t.split(a),i=h,n=0,s=r.length;s>n;n++)i=i.n,i=i.hasOwnProperty(r[n])&&i[r[n]]||(i[r[n]]={n:{}});for(i.f=i.f||[],n=0,s=i.f.length;s>n;n++)if(i.f[n]==e)return o;return i.f.push(e),function(t){+t==+t&&(e.zIndex=+t)}},u.f=function(t){var e=[].slice.call(arguments,1);return function(){u.apply(null,[t,null].concat(e).concat([].slice.call(arguments,0)))}},u.stop=function(){r=1},u.nt=function(t){return t?RegExp("(?:\\.|\\/|^)"+t+"(?:\\.|\\/|$)").test(e):e},u.nts=function(){return e.split(a)},u.off=u.unbind=function(t,e){if(!t)return u._events=h={n:{}},void 0;var r,i,o,l,c,f,p,d=t.split(a),g=[h];for(l=0,c=d.length;c>l;l++)for(f=0;g.length>f;f+=o.length-2){if(o=[f,1],r=g[f].n,d[l]!=s)r[d[l]]&&o.push(r[d[l]]);else for(i in r)r[n](i)&&o.push(r[i]);g.splice.apply(g,o)}for(l=0,c=g.length;c>l;l++)for(r=g[l];r.n;){if(e){if(r.f){for(f=0,p=r.f.length;p>f;f++)if(r.f[f]==e){r.f.splice(f,1);break}!r.f.length&&delete r.f}for(i in r.n)if(r.n[n](i)&&r.n[i].f){var x=r.n[i].f;for(f=0,p=x.length;p>f;f++)if(x[f]==e){x.splice(f,1);break}!x.length&&delete r.n[i].f}}else{delete r.f;for(i in r.n)r.n[n](i)&&r.n[i].f&&delete r.n[i].f}r=r.n}},u.once=function(t,e){var r=function(){return u.unbind(t,r),e.apply(this,arguments)};return u.on(t,r)},u.version=i,u.toString=function(){return"You are running Eve "+i},"undefined"!=typeof module&&module.exports?module.exports=u:"undefined"!=typeof define?define("eve",[],function(){return u}):t.eve=u})(this),function(t,e){"function"==typeof define&&define.amd?define(["eve"],function(r){return e(t,r)}):e(t,t.eve)}(this,function(t,e){function r(t){if(r.is(t,"function"))return b?t():e.on("raphael.DOMload",t);if(r.is(t,H))return r._engine.create[N](r,t.splice(0,3+r.is(t[0],W))).add(t);var i=Array.prototype.slice.call(arguments,0);if(r.is(i[i.length-1],"function")){var n=i.pop();return b?n.call(r._engine.create[N](r,i)):e.on("raphael.DOMload",function(){n.call(r._engine.create[N](r,i))})}return r._engine.create[N](r,arguments)}function i(t){if(Object(t)!==t)return t;var e=new t.constructor;for(var r in t)t[B](r)&&(e[r]=i(t[r]));return e}function n(t,e){for(var r=0,i=t.length;i>r;r++)if(t[r]===e)return t.push(t.splice(r,1)[0])}function a(t,e,r){function i(){var a=Array.prototype.slice.call(arguments,0),s=a.join("␀"),o=i.cache=i.cache||{},l=i.count=i.count||[];return o[B](s)?(n(l,s),r?r(o[s]):o[s]):(l.length>=1e3&&delete o[l.shift()],l.push(s),o[s]=t[N](e,a),r?r(o[s]):o[s])}return i}function s(){return this.hex}function o(t,e){for(var r=[],i=0,n=t.length;n-2*!e>i;i+=2){var a=[{x:+t[i-2],y:+t[i-1]},{x:+t[i],y:+t[i+1]},{x:+t[i+2],y:+t[i+3]},{x:+t[i+4],y:+t[i+5]}];e?i?n-4==i?a[3]={x:+t[0],y:+t[1]}:n-2==i&&(a[2]={x:+t[0],y:+t[1]},a[3]={x:+t[2],y:+t[3]}):a[0]={x:+t[n-2],y:+t[n-1]}:n-4==i?a[3]=a[2]:i||(a[0]={x:+t[i],y:+t[i+1]}),r.push(["C",(-a[0].x+6*a[1].x+a[2].x)/6,(-a[0].y+6*a[1].y+a[2].y)/6,(a[1].x+6*a[2].x-a[3].x)/6,(a[1].y+6*a[2].y-a[3].y)/6,a[2].x,a[2].y])}return r}function l(t,e,r,i,n){var a=-3*e+9*r-9*i+3*n,s=t*a+6*e-12*r+6*i;return t*s-3*e+3*r}function h(t,e,r,i,n,a,s,o,h){null==h&&(h=1),h=h>1?1:0>h?0:h;for(var u=h/2,c=12,f=[-.1252,.1252,-.3678,.3678,-.5873,.5873,-.7699,.7699,-.9041,.9041,-.9816,.9816],p=[.2491,.2491,.2335,.2335,.2032,.2032,.1601,.1601,.1069,.1069,.0472,.0472],d=0,g=0;c>g;g++){var x=u*f[g]+u,v=l(x,t,r,n,s),y=l(x,e,i,a,o),m=v*v+y*y;d+=p[g]*q.sqrt(m)}return u*d}function u(t,e,r,i,n,a,s,o,l){if(!(0>l||l>h(t,e,r,i,n,a,s,o))){var u,c=1,f=c/2,p=c-f,d=.01;for(u=h(t,e,r,i,n,a,s,o,p);V(u-l)>d;)f/=2,p+=(l>u?1:-1)*f,u=h(t,e,r,i,n,a,s,o,p);return p}}function c(t,e,r,i,n,a,s,o){if(!(D(t,r)<O(n,s)||O(t,r)>D(n,s)||D(e,i)<O(a,o)||O(e,i)>D(a,o))){var l=(t*i-e*r)*(n-s)-(t-r)*(n*o-a*s),h=(t*i-e*r)*(a-o)-(e-i)*(n*o-a*s),u=(t-r)*(a-o)-(e-i)*(n-s);if(u){var c=l/u,f=h/u,p=+c.toFixed(2),d=+f.toFixed(2);if(!(+O(t,r).toFixed(2)>p||p>+D(t,r).toFixed(2)||+O(n,s).toFixed(2)>p||p>+D(n,s).toFixed(2)||+O(e,i).toFixed(2)>d||d>+D(e,i).toFixed(2)||+O(a,o).toFixed(2)>d||d>+D(a,o).toFixed(2)))return{x:c,y:f}}}}function f(t,e,i){var n=r.bezierBBox(t),a=r.bezierBBox(e);if(!r.isBBoxIntersect(n,a))return i?0:[];for(var s=h.apply(0,t),o=h.apply(0,e),l=~~(s/5),u=~~(o/5),f=[],p=[],d={},g=i?0:[],x=0;l+1>x;x++){var v=r.findDotsAtSegment.apply(r,t.concat(x/l));f.push({x:v.x,y:v.y,t:x/l})}for(x=0;u+1>x;x++)v=r.findDotsAtSegment.apply(r,e.concat(x/u)),p.push({x:v.x,y:v.y,t:x/u});for(x=0;l>x;x++)for(var y=0;u>y;y++){var m=f[x],b=f[x+1],_=p[y],w=p[y+1],k=.001>V(b.x-m.x)?"y":"x",C=.001>V(w.x-_.x)?"y":"x",B=c(m.x,m.y,b.x,b.y,_.x,_.y,w.x,w.y);if(B){if(d[B.x.toFixed(4)]==B.y.toFixed(4))continue;d[B.x.toFixed(4)]=B.y.toFixed(4);var S=m.t+V((B[k]-m[k])/(b[k]-m[k]))*(b.t-m.t),T=_.t+V((B[C]-_[C])/(w[C]-_[C]))*(w.t-_.t);S>=0&&1>=S&&T>=0&&1>=T&&(i?g++:g.push({x:B.x,y:B.y,t1:S,t2:T}))}}return g}function p(t,e,i){t=r._path2curve(t),e=r._path2curve(e);for(var n,a,s,o,l,h,u,c,p,d,g=i?0:[],x=0,v=t.length;v>x;x++){var y=t[x];if("M"==y[0])n=l=y[1],a=h=y[2];else{"C"==y[0]?(p=[n,a].concat(y.slice(1)),n=p[6],a=p[7]):(p=[n,a,n,a,l,h,l,h],n=l,a=h);for(var m=0,b=e.length;b>m;m++){var _=e[m];if("M"==_[0])s=u=_[1],o=c=_[2];else{"C"==_[0]?(d=[s,o].concat(_.slice(1)),s=d[6],o=d[7]):(d=[s,o,s,o,u,c,u,c],s=u,o=c);var w=f(p,d,i);if(i)g+=w;else{for(var k=0,C=w.length;C>k;k++)w[k].segment1=x,w[k].segment2=m,w[k].bez1=p,w[k].bez2=d;g=g.concat(w)}}}}}return g}function d(t,e,r,i,n,a){null!=t?(this.a=+t,this.b=+e,this.c=+r,this.d=+i,this.e=+n,this.f=+a):(this.a=1,this.b=0,this.c=0,this.d=1,this.e=0,this.f=0)}function g(){return this.x+z+this.y+z+this.width+" × "+this.height}function x(t,e,r,i,n,a){function s(t){return((c*t+u)*t+h)*t}function o(t,e){var r=l(t,e);return((d*r+p)*r+f)*r}function l(t,e){var r,i,n,a,o,l;for(n=t,l=0;8>l;l++){if(a=s(n)-t,e>V(a))return n;if(o=(3*c*n+2*u)*n+h,1e-6>V(o))break;n-=a/o}if(r=0,i=1,n=t,r>n)return r;if(n>i)return i;for(;i>r;){if(a=s(n),e>V(a-t))return n;t>a?r=n:i=n,n=(i-r)/2+r}return n}var h=3*e,u=3*(i-e)-h,c=1-h-u,f=3*r,p=3*(n-r)-f,d=1-f-p;return o(t,1/(200*a))}function v(t,e){var r=[],i={};if(this.ms=e,this.times=1,t){for(var n in t)t[B](n)&&(i[K(n)]=t[n],r.push(K(n)));r.sort(ce)}this.anim=i,this.top=r[r.length-1],this.percents=r}function y(t,i,n,a,s,o){n=K(n);var l,h,u,c,f,p,g=t.ms,v={},y={},m={};if(a)for(_=0,k=or.length;k>_;_++){var b=or[_];if(b.el.id==i.id&&b.anim==t){b.percent!=n?(or.splice(_,1),u=1):h=b,i.attr(b.totalOrigin);break}}else a=+y;for(var _=0,k=t.percents.length;k>_;_++){if(t.percents[_]==n||t.percents[_]>a*t.top){n=t.percents[_],f=t.percents[_-1]||0,g=g/t.top*(n-f),c=t.percents[_+1],l=t.anim[n];break}a&&i.attr(t.anim[t.percents[_]])}if(l){if(h)h.initstatus=a,h.start=new Date-h.ms*a;else{for(var C in l)if(l[B](C)&&(ie[B](C)||i.paper.customAttributes[B](C)))switch(v[C]=i.attr(C),null==v[C]&&(v[C]=re[C]),y[C]=l[C],ie[C]){case W:m[C]=(y[C]-v[C])/g;break;case"colour":v[C]=r.getRGB(v[C]);var S=r.getRGB(y[C]);m[C]={r:(S.r-v[C].r)/g,g:(S.g-v[C].g)/g,b:(S.b-v[C].b)/g};break;case"path":var T=Re(v[C],y[C]),A=T[1];for(v[C]=T[0],m[C]=[],_=0,k=v[C].length;k>_;_++){m[C][_]=[0];for(var N=1,L=v[C][_].length;L>N;N++)m[C][_][N]=(A[_][N]-v[C][_][N])/g}break;case"transform":var M=i._,z=Oe(M[C],y[C]);if(z)for(v[C]=z.from,y[C]=z.to,m[C]=[],m[C].real=!0,_=0,k=v[C].length;k>_;_++)for(m[C][_]=[v[C][_][0]],N=1,L=v[C][_].length;L>N;N++)m[C][_][N]=(y[C][_][N]-v[C][_][N])/g;else{var R=i.matrix||new d,I={_:{transform:M.transform},getBBox:function(){return i.getBBox(1)}};v[C]=[R.a,R.b,R.c,R.d,R.e,R.f],qe(I,y[C]),y[C]=I._.transform,m[C]=[(I.matrix.a-R.a)/g,(I.matrix.b-R.b)/g,(I.matrix.c-R.c)/g,(I.matrix.d-R.d)/g,(I.matrix.e-R.e)/g,(I.matrix.f-R.f)/g]}break;case"csv":var j=F(l[C])[P](w),q=F(v[C])[P](w);if("clip-rect"==C)for(v[C]=q,m[C]=[],_=q.length;_--;)m[C][_]=(j[_]-v[C][_])/g;y[C]=j;break;default:for(j=[][E](l[C]),q=[][E](v[C]),m[C]=[],_=i.paper.customAttributes[C].length;_--;)m[C][_]=((j[_]||0)-(q[_]||0))/g}var D=l.easing,O=r.easing_formulas[D];if(!O)if(O=F(D).match(Q),O&&5==O.length){var V=O;O=function(t){return x(t,+V[1],+V[2],+V[3],+V[4],g)}}else O=pe;if(p=l.start||t.start||+new Date,b={anim:t,percent:n,timestamp:p,start:p+(t.del||0),status:0,initstatus:a||0,stop:!1,ms:g,easing:O,from:v,diff:m,to:y,el:i,callback:l.callback,prev:f,next:c,repeat:o||t.times,origin:i.attr(),totalOrigin:s},or.push(b),a&&!h&&!u&&(b.stop=!0,b.start=new Date-g*a,1==or.length))return hr();u&&(b.start=new Date-b.ms*a),1==or.length&&lr(hr)}e("raphael.anim.start."+i.id,i,t)}}function m(t){for(var e=0;or.length>e;e++)or[e].el.paper==t&&or.splice(e--,1)}r.version="2.1.0",r.eve=e;var b,_,w=/[, ]+/,k={circle:1,rect:1,path:1,ellipse:1,text:1,image:1},C=/\{(\d+)\}/g,B="hasOwnProperty",S={doc:document,win:t},T={was:Object.prototype[B].call(S.win,"Raphael"),is:S.win.Raphael},A=function(){this.ca=this.customAttributes={}},N="apply",E="concat",L="ontouchstart"in S.win||S.win.DocumentTouch&&S.doc instanceof DocumentTouch,M="",z=" ",F=String,P="split",R="click dblclick mousedown mousemove mouseout mouseover mouseup touchstart touchmove touchend touchcancel"[P](z),I={mousedown:"touchstart",mousemove:"touchmove",mouseup:"touchend"},j=F.prototype.toLowerCase,q=Math,D=q.max,O=q.min,V=q.abs,Y=q.pow,G=q.PI,W="number",X="string",H="array",U=Object.prototype.toString,$=(r._ISURL=/^url\(['"]?([^\)]+?)['"]?\)$/i,/^\s*((#[a-f\d]{6})|(#[a-f\d]{3})|rgba?\(\s*([\d\.]+%?\s*,\s*[\d\.]+%?\s*,\s*[\d\.]+%?(?:\s*,\s*[\d\.]+%?)?)\s*\)|hsba?\(\s*([\d\.]+(?:deg|\xb0|%)?\s*,\s*[\d\.]+%?\s*,\s*[\d\.]+(?:%?\s*,\s*[\d\.]+)?)%?\s*\)|hsla?\(\s*([\d\.]+(?:deg|\xb0|%)?\s*,\s*[\d\.]+%?\s*,\s*[\d\.]+(?:%?\s*,\s*[\d\.]+)?)%?\s*\))\s*$/i),Z={NaN:1,Infinity:1,"-Infinity":1},Q=/^(?:cubic-)?bezier\(([^,]+),([^,]+),([^,]+),([^\)]+)\)/,J=q.round,K=parseFloat,te=parseInt,ee=F.prototype.toUpperCase,re=r._availableAttrs={"arrow-end":"none","arrow-start":"none",blur:0,"clip-rect":"0 0 1e9 1e9",cursor:"default",cx:0,cy:0,fill:"#fff","fill-opacity":1,font:'10px "Arial"',"font-family":'"Arial"',"font-size":"10","font-style":"normal","font-weight":400,gradient:0,height:0,href:"http://raphaeljs.com/","letter-spacing":0,opacity:1,path:"M0,0",r:0,rx:0,ry:0,src:"",stroke:"#000","stroke-dasharray":"","stroke-linecap":"butt","stroke-linejoin":"butt","stroke-miterlimit":0,"stroke-opacity":1,"stroke-width":1,target:"_blank","text-anchor":"middle",title:"Raphael",transform:"",width:0,x:0,y:0},ie=r._availableAnimAttrs={blur:W,"clip-rect":"csv",cx:W,cy:W,fill:"colour","fill-opacity":W,"font-size":W,height:W,opacity:W,path:"path",r:W,rx:W,ry:W,stroke:"colour","stroke-opacity":W,"stroke-width":W,transform:"transform",width:W,x:W,y:W},ne=/[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*/,ae={hs:1,rg:1},se=/,?([achlmqrstvxz]),?/gi,oe=/([achlmrqstvz])[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029,]*((-?\d*\.?\d*(?:e[\-+]?\d+)?[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,?[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*)+)/gi,le=/([rstm])[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029,]*((-?\d*\.?\d*(?:e[\-+]?\d+)?[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,?[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*)+)/gi,he=/(-?\d*\.?\d*(?:e[\-+]?\d+)?)[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,?[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*/gi,ue=(r._radial_gradient=/^r(?:\(([^,]+?)[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*,[\x09\x0a\x0b\x0c\x0d\x20\xa0\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\u2028\u2029]*([^\)]+?)\))?/,{}),ce=function(t,e){return K(t)-K(e)},fe=function(){},pe=function(t){return t},de=r._rectPath=function(t,e,r,i,n){return n?[["M",t+n,e],["l",r-2*n,0],["a",n,n,0,0,1,n,n],["l",0,i-2*n],["a",n,n,0,0,1,-n,n],["l",2*n-r,0],["a",n,n,0,0,1,-n,-n],["l",0,2*n-i],["a",n,n,0,0,1,n,-n],["z"]]:[["M",t,e],["l",r,0],["l",0,i],["l",-r,0],["z"]]},ge=function(t,e,r,i){return null==i&&(i=r),[["M",t,e],["m",0,-i],["a",r,i,0,1,1,0,2*i],["a",r,i,0,1,1,0,-2*i],["z"]]},xe=r._getPath={path:function(t){return t.attr("path")},circle:function(t){var e=t.attrs;return ge(e.cx,e.cy,e.r)},ellipse:function(t){var e=t.attrs;return ge(e.cx,e.cy,e.rx,e.ry)},rect:function(t){var e=t.attrs;return de(e.x,e.y,e.width,e.height,e.r)},image:function(t){var e=t.attrs;return de(e.x,e.y,e.width,e.height)},text:function(t){var e=t._getBBox();return de(e.x,e.y,e.width,e.height)},set:function(t){var e=t._getBBox();return de(e.x,e.y,e.width,e.height)}},ve=r.mapPath=function(t,e){if(!e)return t;var r,i,n,a,s,o,l;for(t=Re(t),n=0,s=t.length;s>n;n++)for(l=t[n],a=1,o=l.length;o>a;a+=2)r=e.x(l[a],l[a+1]),i=e.y(l[a],l[a+1]),l[a]=r,l[a+1]=i;return t};if(r._g=S,r.type=S.win.SVGAngle||S.doc.implementation.hasFeature("http://www.w3.org/TR/SVG11/feature#BasicStructure","1.1")?"SVG":"VML","VML"==r.type){var ye,me=S.doc.createElement("div");if(me.innerHTML='<v:shape adj="1"/>',ye=me.firstChild,ye.style.behavior="url(#default#VML)",!ye||"object"!=typeof ye.adj)return r.type=M;me=null}r.svg=!(r.vml="VML"==r.type),r._Paper=A,r.fn=_=A.prototype=r.prototype,r._id=0,r._oid=0,r.is=function(t,e){return e=j.call(e),"finite"==e?!Z[B](+t):"array"==e?t instanceof Array:"null"==e&&null===t||e==typeof t&&null!==t||"object"==e&&t===Object(t)||"array"==e&&Array.isArray&&Array.isArray(t)||U.call(t).slice(8,-1).toLowerCase()==e},r.angle=function(t,e,i,n,a,s){if(null==a){var o=t-i,l=e-n;return o||l?(180+180*q.atan2(-l,-o)/G+360)%360:0}return r.angle(t,e,a,s)-r.angle(i,n,a,s)},r.rad=function(t){return t%360*G/180},r.deg=function(t){return 180*t/G%360},r.snapTo=function(t,e,i){if(i=r.is(i,"finite")?i:10,r.is(t,H)){for(var n=t.length;n--;)if(i>=V(t[n]-e))return t[n]}else{t=+t;var a=e%t;if(i>a)return e-a;if(a>t-i)return e-a+t}return e},r.createUUID=function(t,e){return function(){return"xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(t,e).toUpperCase()}}(/[xy]/g,function(t){var e=0|16*q.random(),r="x"==t?e:8|3&e;return r.toString(16)}),r.setWindow=function(t){e("raphael.setWindow",r,S.win,t),S.win=t,S.doc=S.win.document,r._engine.initWin&&r._engine.initWin(S.win)};var be=function(t){if(r.vml){var e,i=/^\s+|\s+$/g;try{var n=new ActiveXObject("htmlfile");n.write("<body>"),n.close(),e=n.body}catch(s){e=createPopup().document.body}var o=e.createTextRange();be=a(function(t){try{e.style.color=F(t).replace(i,M);var r=o.queryCommandValue("ForeColor");return r=(255&r)<<16|65280&r|(16711680&r)>>>16,"#"+("000000"+r.toString(16)).slice(-6)}catch(n){return"none"}})}else{var l=S.doc.createElement("i");l.title="Raphaël Colour Picker",l.style.display="none",S.doc.body.appendChild(l),be=a(function(t){return l.style.color=t,S.doc.defaultView.getComputedStyle(l,M).getPropertyValue("color")})}return be(t)},_e=function(){return"hsb("+[this.h,this.s,this.b]+")"},we=function(){return"hsl("+[this.h,this.s,this.l]+")"},ke=function(){return this.hex},Ce=function(t,e,i){if(null==e&&r.is(t,"object")&&"r"in t&&"g"in t&&"b"in t&&(i=t.b,e=t.g,t=t.r),null==e&&r.is(t,X)){var n=r.getRGB(t);t=n.r,e=n.g,i=n.b}return(t>1||e>1||i>1)&&(t/=255,e/=255,i/=255),[t,e,i]},Be=function(t,e,i,n){t*=255,e*=255,i*=255;var a={r:t,g:e,b:i,hex:r.rgb(t,e,i),toString:ke};return r.is(n,"finite")&&(a.opacity=n),a};r.color=function(t){var e;return r.is(t,"object")&&"h"in t&&"s"in t&&"b"in t?(e=r.hsb2rgb(t),t.r=e.r,t.g=e.g,t.b=e.b,t.hex=e.hex):r.is(t,"object")&&"h"in t&&"s"in t&&"l"in t?(e=r.hsl2rgb(t),t.r=e.r,t.g=e.g,t.b=e.b,t.hex=e.hex):(r.is(t,"string")&&(t=r.getRGB(t)),r.is(t,"object")&&"r"in t&&"g"in t&&"b"in t?(e=r.rgb2hsl(t),t.h=e.h,t.s=e.s,t.l=e.l,e=r.rgb2hsb(t),t.v=e.b):(t={hex:"none"},t.r=t.g=t.b=t.h=t.s=t.v=t.l=-1)),t.toString=ke,t},r.hsb2rgb=function(t,e,r,i){this.is(t,"object")&&"h"in t&&"s"in t&&"b"in t&&(r=t.b,e=t.s,t=t.h,i=t.o),t*=360;var n,a,s,o,l;return t=t%360/60,l=r*e,o=l*(1-V(t%2-1)),n=a=s=r-l,t=~~t,n+=[l,o,0,0,o,l][t],a+=[o,l,l,o,0,0][t],s+=[0,0,o,l,l,o][t],Be(n,a,s,i)},r.hsl2rgb=function(t,e,r,i){this.is(t,"object")&&"h"in t&&"s"in t&&"l"in t&&(r=t.l,e=t.s,t=t.h),(t>1||e>1||r>1)&&(t/=360,e/=100,r/=100),t*=360;var n,a,s,o,l;return t=t%360/60,l=2*e*(.5>r?r:1-r),o=l*(1-V(t%2-1)),n=a=s=r-l/2,t=~~t,n+=[l,o,0,0,o,l][t],a+=[o,l,l,o,0,0][t],s+=[0,0,o,l,l,o][t],Be(n,a,s,i)},r.rgb2hsb=function(t,e,r){r=Ce(t,e,r),t=r[0],e=r[1],r=r[2];var i,n,a,s;return a=D(t,e,r),s=a-O(t,e,r),i=0==s?null:a==t?(e-r)/s:a==e?(r-t)/s+2:(t-e)/s+4,i=60*((i+360)%6)/360,n=0==s?0:s/a,{h:i,s:n,b:a,toString:_e}},r.rgb2hsl=function(t,e,r){r=Ce(t,e,r),t=r[0],e=r[1],r=r[2];var i,n,a,s,o,l;return s=D(t,e,r),o=O(t,e,r),l=s-o,i=0==l?null:s==t?(e-r)/l:s==e?(r-t)/l+2:(t-e)/l+4,i=60*((i+360)%6)/360,a=(s+o)/2,n=0==l?0:.5>a?l/(2*a):l/(2-2*a),{h:i,s:n,l:a,toString:we}},r._path2string=function(){return this.join(",").replace(se,"$1")},r._preload=function(t,e){var r=S.doc.createElement("img");r.style.cssText="position:absolute;left:-9999em;top:-9999em",r.onload=function(){e.call(this),this.onload=null,S.doc.body.removeChild(this)},r.onerror=function(){S.doc.body.removeChild(this)},S.doc.body.appendChild(r),r.src=t},r.getRGB=a(function(t){if(!t||(t=F(t)).indexOf("-")+1)return{r:-1,g:-1,b:-1,hex:"none",error:1,toString:s};if("none"==t)return{r:-1,g:-1,b:-1,hex:"none",toString:s};!(ae[B](t.toLowerCase().substring(0,2))||"#"==t.charAt())&&(t=be(t));var e,i,n,a,o,l,h=t.match($);return h?(h[2]&&(n=te(h[2].substring(5),16),i=te(h[2].substring(3,5),16),e=te(h[2].substring(1,3),16)),h[3]&&(n=te((o=h[3].charAt(3))+o,16),i=te((o=h[3].charAt(2))+o,16),e=te((o=h[3].charAt(1))+o,16)),h[4]&&(l=h[4][P](ne),e=K(l[0]),"%"==l[0].slice(-1)&&(e*=2.55),i=K(l[1]),"%"==l[1].slice(-1)&&(i*=2.55),n=K(l[2]),"%"==l[2].slice(-1)&&(n*=2.55),"rgba"==h[1].toLowerCase().slice(0,4)&&(a=K(l[3])),l[3]&&"%"==l[3].slice(-1)&&(a/=100)),h[5]?(l=h[5][P](ne),e=K(l[0]),"%"==l[0].slice(-1)&&(e*=2.55),i=K(l[1]),"%"==l[1].slice(-1)&&(i*=2.55),n=K(l[2]),"%"==l[2].slice(-1)&&(n*=2.55),("deg"==l[0].slice(-3)||"°"==l[0].slice(-1))&&(e/=360),"hsba"==h[1].toLowerCase().slice(0,4)&&(a=K(l[3])),l[3]&&"%"==l[3].slice(-1)&&(a/=100),r.hsb2rgb(e,i,n,a)):h[6]?(l=h[6][P](ne),e=K(l[0]),"%"==l[0].slice(-1)&&(e*=2.55),i=K(l[1]),"%"==l[1].slice(-1)&&(i*=2.55),n=K(l[2]),"%"==l[2].slice(-1)&&(n*=2.55),("deg"==l[0].slice(-3)||"°"==l[0].slice(-1))&&(e/=360),"hsla"==h[1].toLowerCase().slice(0,4)&&(a=K(l[3])),l[3]&&"%"==l[3].slice(-1)&&(a/=100),r.hsl2rgb(e,i,n,a)):(h={r:e,g:i,b:n,toString:s},h.hex="#"+(16777216|n|i<<8|e<<16).toString(16).slice(1),r.is(a,"finite")&&(h.opacity=a),h)):{r:-1,g:-1,b:-1,hex:"none",error:1,toString:s}},r),r.hsb=a(function(t,e,i){return r.hsb2rgb(t,e,i).hex}),r.hsl=a(function(t,e,i){return r.hsl2rgb(t,e,i).hex}),r.rgb=a(function(t,e,r){return"#"+(16777216|r|e<<8|t<<16).toString(16).slice(1)}),r.getColor=function(t){var e=this.getColor.start=this.getColor.start||{h:0,s:1,b:t||.75},r=this.hsb2rgb(e.h,e.s,e.b);return e.h+=.075,e.h>1&&(e.h=0,e.s-=.2,0>=e.s&&(this.getColor.start={h:0,s:1,b:e.b})),r.hex},r.getColor.reset=function(){delete this.start},r.parsePathString=function(t){if(!t)return null;var e=Se(t);if(e.arr)return Ae(e.arr);var i={a:7,c:6,h:1,l:2,m:2,r:4,q:4,s:4,t:2,v:1,z:0},n=[];return r.is(t,H)&&r.is(t[0],H)&&(n=Ae(t)),n.length||F(t).replace(oe,function(t,e,r){var a=[],s=e.toLowerCase();if(r.replace(he,function(t,e){e&&a.push(+e)}),"m"==s&&a.length>2&&(n.push([e][E](a.splice(0,2))),s="l",e="m"==e?"l":"L"),"r"==s)n.push([e][E](a));else for(;a.length>=i[s]&&(n.push([e][E](a.splice(0,i[s]))),i[s]););}),n.toString=r._path2string,e.arr=Ae(n),n},r.parseTransformString=a(function(t){if(!t)return null;var e=[];return r.is(t,H)&&r.is(t[0],H)&&(e=Ae(t)),e.length||F(t).replace(le,function(t,r,i){var n=[];j.call(r),i.replace(he,function(t,e){e&&n.push(+e)}),e.push([r][E](n))}),e.toString=r._path2string,e});var Se=function(t){var e=Se.ps=Se.ps||{};return e[t]?e[t].sleep=100:e[t]={sleep:100},setTimeout(function(){for(var r in e)e[B](r)&&r!=t&&(e[r].sleep--,!e[r].sleep&&delete e[r])}),e[t]};r.findDotsAtSegment=function(t,e,r,i,n,a,s,o,l){var h=1-l,u=Y(h,3),c=Y(h,2),f=l*l,p=f*l,d=u*t+3*c*l*r+3*h*l*l*n+p*s,g=u*e+3*c*l*i+3*h*l*l*a+p*o,x=t+2*l*(r-t)+f*(n-2*r+t),v=e+2*l*(i-e)+f*(a-2*i+e),y=r+2*l*(n-r)+f*(s-2*n+r),m=i+2*l*(a-i)+f*(o-2*a+i),b=h*t+l*r,_=h*e+l*i,w=h*n+l*s,k=h*a+l*o,C=90-180*q.atan2(x-y,v-m)/G;return(x>y||m>v)&&(C+=180),{x:d,y:g,m:{x:x,y:v},n:{x:y,y:m},start:{x:b,y:_},end:{x:w,y:k},alpha:C}},r.bezierBBox=function(t,e,i,n,a,s,o,l){r.is(t,"array")||(t=[t,e,i,n,a,s,o,l]);var h=Pe.apply(null,t);return{x:h.min.x,y:h.min.y,x2:h.max.x,y2:h.max.y,width:h.max.x-h.min.x,height:h.max.y-h.min.y}},r.isPointInsideBBox=function(t,e,r){return e>=t.x&&t.x2>=e&&r>=t.y&&t.y2>=r},r.isBBoxIntersect=function(t,e){var i=r.isPointInsideBBox;return i(e,t.x,t.y)||i(e,t.x2,t.y)||i(e,t.x,t.y2)||i(e,t.x2,t.y2)||i(t,e.x,e.y)||i(t,e.x2,e.y)||i(t,e.x,e.y2)||i(t,e.x2,e.y2)||(t.x<e.x2&&t.x>e.x||e.x<t.x2&&e.x>t.x)&&(t.y<e.y2&&t.y>e.y||e.y<t.y2&&e.y>t.y)},r.pathIntersection=function(t,e){return p(t,e)},r.pathIntersectionNumber=function(t,e){return p(t,e,1)},r.isPointInsidePath=function(t,e,i){var n=r.pathBBox(t);return r.isPointInsideBBox(n,e,i)&&1==p(t,[["M",e,i],["H",n.x2+10]],1)%2},r._removedFactory=function(t){return function(){e("raphael.log",null,"Raphaël: you are calling to method “"+t+"” of removed object",t)}};var Te=r.pathBBox=function(t){var e=Se(t);if(e.bbox)return i(e.bbox);if(!t)return{x:0,y:0,width:0,height:0,x2:0,y2:0};t=Re(t);for(var r,n=0,a=0,s=[],o=[],l=0,h=t.length;h>l;l++)if(r=t[l],"M"==r[0])n=r[1],a=r[2],s.push(n),o.push(a);else{var u=Pe(n,a,r[1],r[2],r[3],r[4],r[5],r[6]);s=s[E](u.min.x,u.max.x),o=o[E](u.min.y,u.max.y),n=r[5],a=r[6]}var c=O[N](0,s),f=O[N](0,o),p=D[N](0,s),d=D[N](0,o),g=p-c,x=d-f,v={x:c,y:f,x2:p,y2:d,width:g,height:x,cx:c+g/2,cy:f+x/2};return e.bbox=i(v),v},Ae=function(t){var e=i(t);return e.toString=r._path2string,e},Ne=r._pathToRelative=function(t){var e=Se(t);if(e.rel)return Ae(e.rel);r.is(t,H)&&r.is(t&&t[0],H)||(t=r.parsePathString(t));var i=[],n=0,a=0,s=0,o=0,l=0;"M"==t[0][0]&&(n=t[0][1],a=t[0][2],s=n,o=a,l++,i.push(["M",n,a]));for(var h=l,u=t.length;u>h;h++){var c=i[h]=[],f=t[h];if(f[0]!=j.call(f[0]))switch(c[0]=j.call(f[0]),c[0]){case"a":c[1]=f[1],c[2]=f[2],c[3]=f[3],c[4]=f[4],c[5]=f[5],c[6]=+(f[6]-n).toFixed(3),c[7]=+(f[7]-a).toFixed(3);break;case"v":c[1]=+(f[1]-a).toFixed(3);break;case"m":s=f[1],o=f[2];default:for(var p=1,d=f.length;d>p;p++)c[p]=+(f[p]-(p%2?n:a)).toFixed(3)}else{c=i[h]=[],"m"==f[0]&&(s=f[1]+n,o=f[2]+a);for(var g=0,x=f.length;x>g;g++)i[h][g]=f[g]}var v=i[h].length;switch(i[h][0]){case"z":n=s,a=o;break;case"h":n+=+i[h][v-1];break;case"v":a+=+i[h][v-1];break;default:n+=+i[h][v-2],a+=+i[h][v-1]}}return i.toString=r._path2string,e.rel=Ae(i),i},Ee=r._pathToAbsolute=function(t){var e=Se(t);if(e.abs)return Ae(e.abs);if(r.is(t,H)&&r.is(t&&t[0],H)||(t=r.parsePathString(t)),!t||!t.length)return[["M",0,0]];var i=[],n=0,a=0,s=0,l=0,h=0;"M"==t[0][0]&&(n=+t[0][1],a=+t[0][2],s=n,l=a,h++,i[0]=["M",n,a]);for(var u,c,f=3==t.length&&"M"==t[0][0]&&"R"==t[1][0].toUpperCase()&&"Z"==t[2][0].toUpperCase(),p=h,d=t.length;d>p;p++){if(i.push(u=[]),c=t[p],c[0]!=ee.call(c[0]))switch(u[0]=ee.call(c[0]),u[0]){case"A":u[1]=c[1],u[2]=c[2],u[3]=c[3],u[4]=c[4],u[5]=c[5],u[6]=+(c[6]+n),u[7]=+(c[7]+a);break;case"V":u[1]=+c[1]+a;break;case"H":u[1]=+c[1]+n;break;case"R":for(var g=[n,a][E](c.slice(1)),x=2,v=g.length;v>x;x++)g[x]=+g[x]+n,g[++x]=+g[x]+a;i.pop(),i=i[E](o(g,f));break;case"M":s=+c[1]+n,l=+c[2]+a;default:for(x=1,v=c.length;v>x;x++)u[x]=+c[x]+(x%2?n:a)}else if("R"==c[0])g=[n,a][E](c.slice(1)),i.pop(),i=i[E](o(g,f)),u=["R"][E](c.slice(-2));else for(var y=0,m=c.length;m>y;y++)u[y]=c[y];switch(u[0]){case"Z":n=s,a=l;break;case"H":n=u[1];break;case"V":a=u[1];break;case"M":s=u[u.length-2],l=u[u.length-1];default:n=u[u.length-2],a=u[u.length-1]}}return i.toString=r._path2string,e.abs=Ae(i),i},Le=function(t,e,r,i){return[t,e,r,i,r,i]},Me=function(t,e,r,i,n,a){var s=1/3,o=2/3;return[s*t+o*r,s*e+o*i,s*n+o*r,s*a+o*i,n,a]},ze=function(t,e,r,i,n,s,o,l,h,u){var c,f=120*G/180,p=G/180*(+n||0),d=[],g=a(function(t,e,r){var i=t*q.cos(r)-e*q.sin(r),n=t*q.sin(r)+e*q.cos(r);return{x:i,y:n}});if(u)C=u[0],B=u[1],w=u[2],k=u[3];else{c=g(t,e,-p),t=c.x,e=c.y,c=g(l,h,-p),l=c.x,h=c.y;var x=(q.cos(G/180*n),q.sin(G/180*n),(t-l)/2),v=(e-h)/2,y=x*x/(r*r)+v*v/(i*i);y>1&&(y=q.sqrt(y),r=y*r,i=y*i);var m=r*r,b=i*i,_=(s==o?-1:1)*q.sqrt(V((m*b-m*v*v-b*x*x)/(m*v*v+b*x*x))),w=_*r*v/i+(t+l)/2,k=_*-i*x/r+(e+h)/2,C=q.asin(((e-k)/i).toFixed(9)),B=q.asin(((h-k)/i).toFixed(9));C=w>t?G-C:C,B=w>l?G-B:B,0>C&&(C=2*G+C),0>B&&(B=2*G+B),o&&C>B&&(C-=2*G),!o&&B>C&&(B-=2*G)}var S=B-C;if(V(S)>f){var T=B,A=l,N=h;B=C+f*(o&&B>C?1:-1),l=w+r*q.cos(B),h=k+i*q.sin(B),d=ze(l,h,r,i,n,0,o,A,N,[B,T,w,k])}S=B-C;var L=q.cos(C),M=q.sin(C),z=q.cos(B),F=q.sin(B),R=q.tan(S/4),I=4/3*r*R,j=4/3*i*R,D=[t,e],O=[t+I*M,e-j*L],Y=[l+I*F,h-j*z],W=[l,h];if(O[0]=2*D[0]-O[0],O[1]=2*D[1]-O[1],u)return[O,Y,W][E](d);d=[O,Y,W][E](d).join()[P](",");for(var X=[],H=0,U=d.length;U>H;H++)X[H]=H%2?g(d[H-1],d[H],p).y:g(d[H],d[H+1],p).x;return X},Fe=function(t,e,r,i,n,a,s,o,l){var h=1-l;return{x:Y(h,3)*t+3*Y(h,2)*l*r+3*h*l*l*n+Y(l,3)*s,y:Y(h,3)*e+3*Y(h,2)*l*i+3*h*l*l*a+Y(l,3)*o}},Pe=a(function(t,e,r,i,n,a,s,o){var l,h=n-2*r+t-(s-2*n+r),u=2*(r-t)-2*(n-r),c=t-r,f=(-u+q.sqrt(u*u-4*h*c))/2/h,p=(-u-q.sqrt(u*u-4*h*c))/2/h,d=[e,o],g=[t,s];return V(f)>"1e12"&&(f=.5),V(p)>"1e12"&&(p=.5),f>0&&1>f&&(l=Fe(t,e,r,i,n,a,s,o,f),g.push(l.x),d.push(l.y)),p>0&&1>p&&(l=Fe(t,e,r,i,n,a,s,o,p),g.push(l.x),d.push(l.y)),h=a-2*i+e-(o-2*a+i),u=2*(i-e)-2*(a-i),c=e-i,f=(-u+q.sqrt(u*u-4*h*c))/2/h,p=(-u-q.sqrt(u*u-4*h*c))/2/h,V(f)>"1e12"&&(f=.5),V(p)>"1e12"&&(p=.5),f>0&&1>f&&(l=Fe(t,e,r,i,n,a,s,o,f),g.push(l.x),d.push(l.y)),p>0&&1>p&&(l=Fe(t,e,r,i,n,a,s,o,p),g.push(l.x),d.push(l.y)),{min:{x:O[N](0,g),y:O[N](0,d)},max:{x:D[N](0,g),y:D[N](0,d)}}}),Re=r._path2curve=a(function(t,e){var r=!e&&Se(t);if(!e&&r.curve)return Ae(r.curve);for(var i=Ee(t),n=e&&Ee(e),a={x:0,y:0,bx:0,by:0,X:0,Y:0,qx:null,qy:null},s={x:0,y:0,bx:0,by:0,X:0,Y:0,qx:null,qy:null},o=(function(t,e){var r,i;if(!t)return["C",e.x,e.y,e.x,e.y,e.x,e.y];switch(!(t[0]in{T:1,Q:1})&&(e.qx=e.qy=null),t[0]){case"M":e.X=t[1],e.Y=t[2];break;case"A":t=["C"][E](ze[N](0,[e.x,e.y][E](t.slice(1))));break;case"S":r=e.x+(e.x-(e.bx||e.x)),i=e.y+(e.y-(e.by||e.y)),t=["C",r,i][E](t.slice(1));break;case"T":e.qx=e.x+(e.x-(e.qx||e.x)),e.qy=e.y+(e.y-(e.qy||e.y)),t=["C"][E](Me(e.x,e.y,e.qx,e.qy,t[1],t[2]));break;case"Q":e.qx=t[1],e.qy=t[2],t=["C"][E](Me(e.x,e.y,t[1],t[2],t[3],t[4]));break;case"L":t=["C"][E](Le(e.x,e.y,t[1],t[2]));break;case"H":t=["C"][E](Le(e.x,e.y,t[1],e.y));break;case"V":t=["C"][E](Le(e.x,e.y,e.x,t[1]));break;case"Z":t=["C"][E](Le(e.x,e.y,e.X,e.Y))}return t}),l=function(t,e){if(t[e].length>7){t[e].shift();for(var r=t[e];r.length;)t.splice(e++,0,["C"][E](r.splice(0,6)));t.splice(e,1),c=D(i.length,n&&n.length||0)}},h=function(t,e,r,a,s){t&&e&&"M"==t[s][0]&&"M"!=e[s][0]&&(e.splice(s,0,["M",a.x,a.y]),r.bx=0,r.by=0,r.x=t[s][1],r.y=t[s][2],c=D(i.length,n&&n.length||0))},u=0,c=D(i.length,n&&n.length||0);c>u;u++){i[u]=o(i[u],a),l(i,u),n&&(n[u]=o(n[u],s)),n&&l(n,u),h(i,n,a,s,u),h(n,i,s,a,u);var f=i[u],p=n&&n[u],d=f.length,g=n&&p.length;a.x=f[d-2],a.y=f[d-1],a.bx=K(f[d-4])||a.x,a.by=K(f[d-3])||a.y,s.bx=n&&(K(p[g-4])||s.x),s.by=n&&(K(p[g-3])||s.y),s.x=n&&p[g-2],s.y=n&&p[g-1]}return n||(r.curve=Ae(i)),n?[i,n]:i},null,Ae),Ie=(r._parseDots=a(function(t){for(var e=[],i=0,n=t.length;n>i;i++){var a={},s=t[i].match(/^([^:]*):?([\d\.]*)/);if(a.color=r.getRGB(s[1]),a.color.error)return null;a.color=a.color.hex,s[2]&&(a.offset=s[2]+"%"),e.push(a)}for(i=1,n=e.length-1;n>i;i++)if(!e[i].offset){for(var o=K(e[i-1].offset||0),l=0,h=i+1;n>h;h++)if(e[h].offset){l=e[h].offset;break}l||(l=100,h=n),l=K(l);for(var u=(l-o)/(h-i+1);h>i;i++)o+=u,e[i].offset=o+"%"}return e}),r._tear=function(t,e){t==e.top&&(e.top=t.prev),t==e.bottom&&(e.bottom=t.next),t.next&&(t.next.prev=t.prev),t.prev&&(t.prev.next=t.next)}),je=(r._tofront=function(t,e){e.top!==t&&(Ie(t,e),t.next=null,t.prev=e.top,e.top.next=t,e.top=t)},r._toback=function(t,e){e.bottom!==t&&(Ie(t,e),t.next=e.bottom,t.prev=null,e.bottom.prev=t,e.bottom=t)},r._insertafter=function(t,e,r){Ie(t,r),e==r.top&&(r.top=t),e.next&&(e.next.prev=t),t.next=e.next,t.prev=e,e.next=t},r._insertbefore=function(t,e,r){Ie(t,r),e==r.bottom&&(r.bottom=t),e.prev&&(e.prev.next=t),t.prev=e.prev,e.prev=t,t.next=e},r.toMatrix=function(t,e){var r=Te(t),i={_:{transform:M},getBBox:function(){return r}};return qe(i,e),i.matrix}),qe=(r.transformPath=function(t,e){return ve(t,je(t,e))},r._extractTransform=function(t,e){if(null==e)return t._.transform;e=F(e).replace(/\.{3}|\u2026/g,t._.transform||M);var i=r.parseTransformString(e),n=0,a=0,s=0,o=1,l=1,h=t._,u=new d;if(h.transform=i||[],i)for(var c=0,f=i.length;f>c;c++){var p,g,x,v,y,m=i[c],b=m.length,_=F(m[0]).toLowerCase(),w=m[0]!=_,k=w?u.invert():0;"t"==_&&3==b?w?(p=k.x(0,0),g=k.y(0,0),x=k.x(m[1],m[2]),v=k.y(m[1],m[2]),u.translate(x-p,v-g)):u.translate(m[1],m[2]):"r"==_?2==b?(y=y||t.getBBox(1),u.rotate(m[1],y.x+y.width/2,y.y+y.height/2),n+=m[1]):4==b&&(w?(x=k.x(m[2],m[3]),v=k.y(m[2],m[3]),u.rotate(m[1],x,v)):u.rotate(m[1],m[2],m[3]),n+=m[1]):"s"==_?2==b||3==b?(y=y||t.getBBox(1),u.scale(m[1],m[b-1],y.x+y.width/2,y.y+y.height/2),o*=m[1],l*=m[b-1]):5==b&&(w?(x=k.x(m[3],m[4]),v=k.y(m[3],m[4]),u.scale(m[1],m[2],x,v)):u.scale(m[1],m[2],m[3],m[4]),o*=m[1],l*=m[2]):"m"==_&&7==b&&u.add(m[1],m[2],m[3],m[4],m[5],m[6]),h.dirtyT=1,t.matrix=u}t.matrix=u,h.sx=o,h.sy=l,h.deg=n,h.dx=a=u.e,h.dy=s=u.f,1==o&&1==l&&!n&&h.bbox?(h.bbox.x+=+a,h.bbox.y+=+s):h.dirtyT=1}),De=function(t){var e=t[0];switch(e.toLowerCase()){case"t":return[e,0,0];case"m":return[e,1,0,0,1,0,0];case"r":return 4==t.length?[e,0,t[2],t[3]]:[e,0];case"s":return 5==t.length?[e,1,1,t[3],t[4]]:3==t.length?[e,1,1]:[e,1]}},Oe=r._equaliseTransform=function(t,e){e=F(e).replace(/\.{3}|\u2026/g,t),t=r.parseTransformString(t)||[],e=r.parseTransformString(e)||[];for(var i,n,a,s,o=D(t.length,e.length),l=[],h=[],u=0;o>u;u++){if(a=t[u]||De(e[u]),s=e[u]||De(a),a[0]!=s[0]||"r"==a[0].toLowerCase()&&(a[2]!=s[2]||a[3]!=s[3])||"s"==a[0].toLowerCase()&&(a[3]!=s[3]||a[4]!=s[4]))return;for(l[u]=[],h[u]=[],i=0,n=D(a.length,s.length);n>i;i++)i in a&&(l[u][i]=a[i]),i in s&&(h[u][i]=s[i])}return{from:l,to:h}
};r._getContainer=function(t,e,i,n){var a;return a=null!=n||r.is(t,"object")?t:S.doc.getElementById(t),null!=a?a.tagName?null==e?{container:a,width:a.style.pixelWidth||a.offsetWidth,height:a.style.pixelHeight||a.offsetHeight}:{container:a,width:e,height:i}:{container:1,x:t,y:e,width:i,height:n}:void 0},r.pathToRelative=Ne,r._engine={},r.path2curve=Re,r.matrix=function(t,e,r,i,n,a){return new d(t,e,r,i,n,a)},function(t){function e(t){return t[0]*t[0]+t[1]*t[1]}function i(t){var r=q.sqrt(e(t));t[0]&&(t[0]/=r),t[1]&&(t[1]/=r)}t.add=function(t,e,r,i,n,a){var s,o,l,h,u=[[],[],[]],c=[[this.a,this.c,this.e],[this.b,this.d,this.f],[0,0,1]],f=[[t,r,n],[e,i,a],[0,0,1]];for(t&&t instanceof d&&(f=[[t.a,t.c,t.e],[t.b,t.d,t.f],[0,0,1]]),s=0;3>s;s++)for(o=0;3>o;o++){for(h=0,l=0;3>l;l++)h+=c[s][l]*f[l][o];u[s][o]=h}this.a=u[0][0],this.b=u[1][0],this.c=u[0][1],this.d=u[1][1],this.e=u[0][2],this.f=u[1][2]},t.invert=function(){var t=this,e=t.a*t.d-t.b*t.c;return new d(t.d/e,-t.b/e,-t.c/e,t.a/e,(t.c*t.f-t.d*t.e)/e,(t.b*t.e-t.a*t.f)/e)},t.clone=function(){return new d(this.a,this.b,this.c,this.d,this.e,this.f)},t.translate=function(t,e){this.add(1,0,0,1,t,e)},t.scale=function(t,e,r,i){null==e&&(e=t),(r||i)&&this.add(1,0,0,1,r,i),this.add(t,0,0,e,0,0),(r||i)&&this.add(1,0,0,1,-r,-i)},t.rotate=function(t,e,i){t=r.rad(t),e=e||0,i=i||0;var n=+q.cos(t).toFixed(9),a=+q.sin(t).toFixed(9);this.add(n,a,-a,n,e,i),this.add(1,0,0,1,-e,-i)},t.x=function(t,e){return t*this.a+e*this.c+this.e},t.y=function(t,e){return t*this.b+e*this.d+this.f},t.get=function(t){return+this[F.fromCharCode(97+t)].toFixed(4)},t.toString=function(){return r.svg?"matrix("+[this.get(0),this.get(1),this.get(2),this.get(3),this.get(4),this.get(5)].join()+")":[this.get(0),this.get(2),this.get(1),this.get(3),0,0].join()},t.toFilter=function(){return"progid:DXImageTransform.Microsoft.Matrix(M11="+this.get(0)+", M12="+this.get(2)+", M21="+this.get(1)+", M22="+this.get(3)+", Dx="+this.get(4)+", Dy="+this.get(5)+", sizingmethod='auto expand')"},t.offset=function(){return[this.e.toFixed(4),this.f.toFixed(4)]},t.split=function(){var t={};t.dx=this.e,t.dy=this.f;var n=[[this.a,this.c],[this.b,this.d]];t.scalex=q.sqrt(e(n[0])),i(n[0]),t.shear=n[0][0]*n[1][0]+n[0][1]*n[1][1],n[1]=[n[1][0]-n[0][0]*t.shear,n[1][1]-n[0][1]*t.shear],t.scaley=q.sqrt(e(n[1])),i(n[1]),t.shear/=t.scaley;var a=-n[0][1],s=n[1][1];return 0>s?(t.rotate=r.deg(q.acos(s)),0>a&&(t.rotate=360-t.rotate)):t.rotate=r.deg(q.asin(a)),t.isSimple=!(+t.shear.toFixed(9)||t.scalex.toFixed(9)!=t.scaley.toFixed(9)&&t.rotate),t.isSuperSimple=!+t.shear.toFixed(9)&&t.scalex.toFixed(9)==t.scaley.toFixed(9)&&!t.rotate,t.noRotation=!+t.shear.toFixed(9)&&!t.rotate,t},t.toTransformString=function(t){var e=t||this[P]();return e.isSimple?(e.scalex=+e.scalex.toFixed(4),e.scaley=+e.scaley.toFixed(4),e.rotate=+e.rotate.toFixed(4),(e.dx||e.dy?"t"+[e.dx,e.dy]:M)+(1!=e.scalex||1!=e.scaley?"s"+[e.scalex,e.scaley,0,0]:M)+(e.rotate?"r"+[e.rotate,0,0]:M)):"m"+[this.get(0),this.get(1),this.get(2),this.get(3),this.get(4),this.get(5)]}}(d.prototype);var Ve=navigator.userAgent.match(/Version\/(.*?)\s/)||navigator.userAgent.match(/Chrome\/(\d+)/);_.safari="Apple Computer, Inc."==navigator.vendor&&(Ve&&4>Ve[1]||"iP"==navigator.platform.slice(0,2))||"Google Inc."==navigator.vendor&&Ve&&8>Ve[1]?function(){var t=this.rect(-99,-99,this.width+99,this.height+99).attr({stroke:"none"});setTimeout(function(){t.remove()})}:fe;for(var Ye=function(){this.returnValue=!1},Ge=function(){return this.originalEvent.preventDefault()},We=function(){this.cancelBubble=!0},Xe=function(){return this.originalEvent.stopPropagation()},He=function(){return S.doc.addEventListener?function(t,e,r,i){var n=L&&I[e]?I[e]:e,a=function(n){var a=S.doc.documentElement.scrollTop||S.doc.body.scrollTop,s=S.doc.documentElement.scrollLeft||S.doc.body.scrollLeft,o=n.clientX+s,l=n.clientY+a;if(L&&I[B](e))for(var h=0,u=n.targetTouches&&n.targetTouches.length;u>h;h++)if(n.targetTouches[h].target==t){var c=n;n=n.targetTouches[h],n.originalEvent=c,n.preventDefault=Ge,n.stopPropagation=Xe;break}return r.call(i,n,o,l)};return t.addEventListener(n,a,!1),function(){return t.removeEventListener(n,a,!1),!0}}:S.doc.attachEvent?function(t,e,r,i){var n=function(t){t=t||S.win.event;var e=S.doc.documentElement.scrollTop||S.doc.body.scrollTop,n=S.doc.documentElement.scrollLeft||S.doc.body.scrollLeft,a=t.clientX+n,s=t.clientY+e;return t.preventDefault=t.preventDefault||Ye,t.stopPropagation=t.stopPropagation||We,r.call(i,t,a,s)};t.attachEvent("on"+e,n);var a=function(){return t.detachEvent("on"+e,n),!0};return a}:void 0}(),Ue=[],$e=function(t){for(var r,i=t.clientX,n=t.clientY,a=S.doc.documentElement.scrollTop||S.doc.body.scrollTop,s=S.doc.documentElement.scrollLeft||S.doc.body.scrollLeft,o=Ue.length;o--;){if(r=Ue[o],L){for(var l,h=t.touches.length;h--;)if(l=t.touches[h],l.identifier==r.el._drag.id){i=l.clientX,n=l.clientY,(t.originalEvent?t.originalEvent:t).preventDefault();break}}else t.preventDefault();var u,c=r.el.node,f=c.nextSibling,p=c.parentNode,d=c.style.display;S.win.opera&&p.removeChild(c),c.style.display="none",u=r.el.paper.getElementByPoint(i,n),c.style.display=d,S.win.opera&&(f?p.insertBefore(c,f):p.appendChild(c)),u&&e("raphael.drag.over."+r.el.id,r.el,u),i+=s,n+=a,e("raphael.drag.move."+r.el.id,r.move_scope||r.el,i-r.el._drag.x,n-r.el._drag.y,i,n,t)}},Ze=function(t){r.unmousemove($e).unmouseup(Ze);for(var i,n=Ue.length;n--;)i=Ue[n],i.el._drag={},e("raphael.drag.end."+i.el.id,i.end_scope||i.start_scope||i.move_scope||i.el,t);Ue=[]},Qe=r.el={},Je=R.length;Je--;)(function(t){r[t]=Qe[t]=function(e,i){return r.is(e,"function")&&(this.events=this.events||[],this.events.push({name:t,f:e,unbind:He(this.shape||this.node||S.doc,t,e,i||this)})),this},r["un"+t]=Qe["un"+t]=function(e){for(var i=this.events||[],n=i.length;n--;)i[n].name!=t||!r.is(e,"undefined")&&i[n].f!=e||(i[n].unbind(),i.splice(n,1),!i.length&&delete this.events);return this}})(R[Je]);Qe.data=function(t,i){var n=ue[this.id]=ue[this.id]||{};if(0==arguments.length)return n;if(1==arguments.length){if(r.is(t,"object")){for(var a in t)t[B](a)&&this.data(a,t[a]);return this}return e("raphael.data.get."+this.id,this,n[t],t),n[t]}return n[t]=i,e("raphael.data.set."+this.id,this,i,t),this},Qe.removeData=function(t){return null==t?ue[this.id]={}:ue[this.id]&&delete ue[this.id][t],this},Qe.getData=function(){return i(ue[this.id]||{})},Qe.hover=function(t,e,r,i){return this.mouseover(t,r).mouseout(e,i||r)},Qe.unhover=function(t,e){return this.unmouseover(t).unmouseout(e)};var Ke=[];Qe.drag=function(t,i,n,a,s,o){function l(l){(l.originalEvent||l).preventDefault();var h=S.doc.documentElement.scrollTop||S.doc.body.scrollTop,u=S.doc.documentElement.scrollLeft||S.doc.body.scrollLeft;this._drag.x=l.clientX+u,this._drag.y=l.clientY+h,this._drag.id=l.identifier,!Ue.length&&r.mousemove($e).mouseup(Ze),Ue.push({el:this,move_scope:a,start_scope:s,end_scope:o}),i&&e.on("raphael.drag.start."+this.id,i),t&&e.on("raphael.drag.move."+this.id,t),n&&e.on("raphael.drag.end."+this.id,n),e("raphael.drag.start."+this.id,s||a||this,l.clientX+u,l.clientY+h,l)}return this._drag={},Ke.push({el:this,start:l}),this.mousedown(l),this},Qe.onDragOver=function(t){t?e.on("raphael.drag.over."+this.id,t):e.unbind("raphael.drag.over."+this.id)},Qe.undrag=function(){for(var t=Ke.length;t--;)Ke[t].el==this&&(this.unmousedown(Ke[t].start),Ke.splice(t,1),e.unbind("raphael.drag.*."+this.id));!Ke.length&&r.unmousemove($e).unmouseup(Ze),Ue=[]},_.circle=function(t,e,i){var n=r._engine.circle(this,t||0,e||0,i||0);return this.__set__&&this.__set__.push(n),n},_.rect=function(t,e,i,n,a){var s=r._engine.rect(this,t||0,e||0,i||0,n||0,a||0);return this.__set__&&this.__set__.push(s),s},_.ellipse=function(t,e,i,n){var a=r._engine.ellipse(this,t||0,e||0,i||0,n||0);return this.__set__&&this.__set__.push(a),a},_.path=function(t){t&&!r.is(t,X)&&!r.is(t[0],H)&&(t+=M);var e=r._engine.path(r.format[N](r,arguments),this);return this.__set__&&this.__set__.push(e),e},_.image=function(t,e,i,n,a){var s=r._engine.image(this,t||"about:blank",e||0,i||0,n||0,a||0);return this.__set__&&this.__set__.push(s),s},_.text=function(t,e,i){var n=r._engine.text(this,t||0,e||0,F(i));return this.__set__&&this.__set__.push(n),n},_.set=function(t){!r.is(t,"array")&&(t=Array.prototype.splice.call(arguments,0,arguments.length));var e=new cr(t);return this.__set__&&this.__set__.push(e),e.paper=this,e.type="set",e},_.setStart=function(t){this.__set__=t||this.set()},_.setFinish=function(){var t=this.__set__;return delete this.__set__,t},_.setSize=function(t,e){return r._engine.setSize.call(this,t,e)},_.setViewBox=function(t,e,i,n,a){return r._engine.setViewBox.call(this,t,e,i,n,a)},_.top=_.bottom=null,_.raphael=r;var tr=function(t){var e=t.getBoundingClientRect(),r=t.ownerDocument,i=r.body,n=r.documentElement,a=n.clientTop||i.clientTop||0,s=n.clientLeft||i.clientLeft||0,o=e.top+(S.win.pageYOffset||n.scrollTop||i.scrollTop)-a,l=e.left+(S.win.pageXOffset||n.scrollLeft||i.scrollLeft)-s;return{y:o,x:l}};_.getElementByPoint=function(t,e){var r=this,i=r.canvas,n=S.doc.elementFromPoint(t,e);if(S.win.opera&&"svg"==n.tagName){var a=tr(i),s=i.createSVGRect();s.x=t-a.x,s.y=e-a.y,s.width=s.height=1;var o=i.getIntersectionList(s,null);o.length&&(n=o[o.length-1])}if(!n)return null;for(;n.parentNode&&n!=i.parentNode&&!n.raphael;)n=n.parentNode;return n==r.canvas.parentNode&&(n=i),n=n&&n.raphael?r.getById(n.raphaelid):null},_.getElementsByBBox=function(t){var e=this.set();return this.forEach(function(i){r.isBBoxIntersect(i.getBBox(),t)&&e.push(i)}),e},_.getById=function(t){for(var e=this.bottom;e;){if(e.id==t)return e;e=e.next}return null},_.forEach=function(t,e){for(var r=this.bottom;r;){if(t.call(e,r)===!1)return this;r=r.next}return this},_.getElementsByPoint=function(t,e){var r=this.set();return this.forEach(function(i){i.isPointInside(t,e)&&r.push(i)}),r},Qe.isPointInside=function(t,e){var i=this.realPath=this.realPath||xe[this.type](this);return r.isPointInsidePath(i,t,e)},Qe.getBBox=function(t){if(this.removed)return{};var e=this._;return t?((e.dirty||!e.bboxwt)&&(this.realPath=xe[this.type](this),e.bboxwt=Te(this.realPath),e.bboxwt.toString=g,e.dirty=0),e.bboxwt):((e.dirty||e.dirtyT||!e.bbox)&&((e.dirty||!this.realPath)&&(e.bboxwt=0,this.realPath=xe[this.type](this)),e.bbox=Te(ve(this.realPath,this.matrix)),e.bbox.toString=g,e.dirty=e.dirtyT=0),e.bbox)},Qe.clone=function(){if(this.removed)return null;var t=this.paper[this.type]().attr(this.attr());return this.__set__&&this.__set__.push(t),t},Qe.glow=function(t){if("text"==this.type)return null;t=t||{};var e={width:(t.width||10)+(+this.attr("stroke-width")||1),fill:t.fill||!1,opacity:t.opacity||.5,offsetx:t.offsetx||0,offsety:t.offsety||0,color:t.color||"#000"},r=e.width/2,i=this.paper,n=i.set(),a=this.realPath||xe[this.type](this);a=this.matrix?ve(a,this.matrix):a;for(var s=1;r+1>s;s++)n.push(i.path(a).attr({stroke:e.color,fill:e.fill?e.color:"none","stroke-linejoin":"round","stroke-linecap":"round","stroke-width":+(e.width/r*s).toFixed(3),opacity:+(e.opacity/r).toFixed(3)}));return n.insertBefore(this).translate(e.offsetx,e.offsety)};var er=function(t,e,i,n,a,s,o,l,c){return null==c?h(t,e,i,n,a,s,o,l):r.findDotsAtSegment(t,e,i,n,a,s,o,l,u(t,e,i,n,a,s,o,l,c))},rr=function(t,e){return function(i,n,a){i=Re(i);for(var s,o,l,h,u,c="",f={},p=0,d=0,g=i.length;g>d;d++){if(l=i[d],"M"==l[0])s=+l[1],o=+l[2];else{if(h=er(s,o,l[1],l[2],l[3],l[4],l[5],l[6]),p+h>n){if(e&&!f.start){if(u=er(s,o,l[1],l[2],l[3],l[4],l[5],l[6],n-p),c+=["C"+u.start.x,u.start.y,u.m.x,u.m.y,u.x,u.y],a)return c;f.start=c,c=["M"+u.x,u.y+"C"+u.n.x,u.n.y,u.end.x,u.end.y,l[5],l[6]].join(),p+=h,s=+l[5],o=+l[6];continue}if(!t&&!e)return u=er(s,o,l[1],l[2],l[3],l[4],l[5],l[6],n-p),{x:u.x,y:u.y,alpha:u.alpha}}p+=h,s=+l[5],o=+l[6]}c+=l.shift()+l}return f.end=c,u=t?p:e?f:r.findDotsAtSegment(s,o,l[0],l[1],l[2],l[3],l[4],l[5],1),u.alpha&&(u={x:u.x,y:u.y,alpha:u.alpha}),u}},ir=rr(1),nr=rr(),ar=rr(0,1);r.getTotalLength=ir,r.getPointAtLength=nr,r.getSubpath=function(t,e,r){if(1e-6>this.getTotalLength(t)-r)return ar(t,e).end;var i=ar(t,r,1);return e?ar(i,e).end:i},Qe.getTotalLength=function(){return"path"==this.type?this.node.getTotalLength?this.node.getTotalLength():ir(this.attrs.path):void 0},Qe.getPointAtLength=function(t){return"path"==this.type?nr(this.attrs.path,t):void 0},Qe.getSubpath=function(t,e){return"path"==this.type?r.getSubpath(this.attrs.path,t,e):void 0};var sr=r.easing_formulas={linear:function(t){return t},"<":function(t){return Y(t,1.7)},">":function(t){return Y(t,.48)},"<>":function(t){var e=.48-t/1.04,r=q.sqrt(.1734+e*e),i=r-e,n=Y(V(i),1/3)*(0>i?-1:1),a=-r-e,s=Y(V(a),1/3)*(0>a?-1:1),o=n+s+.5;return 3*(1-o)*o*o+o*o*o},backIn:function(t){var e=1.70158;return t*t*((e+1)*t-e)},backOut:function(t){t-=1;var e=1.70158;return t*t*((e+1)*t+e)+1},elastic:function(t){return t==!!t?t:Y(2,-10*t)*q.sin((t-.075)*2*G/.3)+1},bounce:function(t){var e,r=7.5625,i=2.75;return 1/i>t?e=r*t*t:2/i>t?(t-=1.5/i,e=r*t*t+.75):2.5/i>t?(t-=2.25/i,e=r*t*t+.9375):(t-=2.625/i,e=r*t*t+.984375),e}};sr.easeIn=sr["ease-in"]=sr["<"],sr.easeOut=sr["ease-out"]=sr[">"],sr.easeInOut=sr["ease-in-out"]=sr["<>"],sr["back-in"]=sr.backIn,sr["back-out"]=sr.backOut;var or=[],lr=t.requestAnimationFrame||t.webkitRequestAnimationFrame||t.mozRequestAnimationFrame||t.oRequestAnimationFrame||t.msRequestAnimationFrame||function(t){setTimeout(t,16)},hr=function(){for(var t=+new Date,i=0;or.length>i;i++){var n=or[i];if(!n.el.removed&&!n.paused){var a,s,o=t-n.start,l=n.ms,h=n.easing,u=n.from,c=n.diff,f=n.to,p=(n.t,n.el),d={},g={};if(n.initstatus?(o=(n.initstatus*n.anim.top-n.prev)/(n.percent-n.prev)*l,n.status=n.initstatus,delete n.initstatus,n.stop&&or.splice(i--,1)):n.status=(n.prev+(n.percent-n.prev)*(o/l))/n.anim.top,!(0>o))if(l>o){var x=h(o/l);for(var v in u)if(u[B](v)){switch(ie[v]){case W:a=+u[v]+x*l*c[v];break;case"colour":a="rgb("+[ur(J(u[v].r+x*l*c[v].r)),ur(J(u[v].g+x*l*c[v].g)),ur(J(u[v].b+x*l*c[v].b))].join(",")+")";break;case"path":a=[];for(var m=0,b=u[v].length;b>m;m++){a[m]=[u[v][m][0]];for(var _=1,w=u[v][m].length;w>_;_++)a[m][_]=+u[v][m][_]+x*l*c[v][m][_];a[m]=a[m].join(z)}a=a.join(z);break;case"transform":if(c[v].real)for(a=[],m=0,b=u[v].length;b>m;m++)for(a[m]=[u[v][m][0]],_=1,w=u[v][m].length;w>_;_++)a[m][_]=u[v][m][_]+x*l*c[v][m][_];else{var k=function(t){return+u[v][t]+x*l*c[v][t]};a=[["m",k(0),k(1),k(2),k(3),k(4),k(5)]]}break;case"csv":if("clip-rect"==v)for(a=[],m=4;m--;)a[m]=+u[v][m]+x*l*c[v][m];break;default:var C=[][E](u[v]);for(a=[],m=p.paper.customAttributes[v].length;m--;)a[m]=+C[m]+x*l*c[v][m]}d[v]=a}p.attr(d),function(t,r,i){setTimeout(function(){e("raphael.anim.frame."+t,r,i)})}(p.id,p,n.anim)}else{if(function(t,i,n){setTimeout(function(){e("raphael.anim.frame."+i.id,i,n),e("raphael.anim.finish."+i.id,i,n),r.is(t,"function")&&t.call(i)})}(n.callback,p,n.anim),p.attr(f),or.splice(i--,1),n.repeat>1&&!n.next){for(s in f)f[B](s)&&(g[s]=n.totalOrigin[s]);n.el.attr(g),y(n.anim,n.el,n.anim.percents[0],null,n.totalOrigin,n.repeat-1)}n.next&&!n.stop&&y(n.anim,n.el,n.next,null,n.totalOrigin,n.repeat)}}}r.svg&&p&&p.paper&&p.paper.safari(),or.length&&lr(hr)},ur=function(t){return t>255?255:0>t?0:t};Qe.animateWith=function(t,e,i,n,a,s){var o=this;if(o.removed)return s&&s.call(o),o;var l=i instanceof v?i:r.animation(i,n,a,s);y(l,o,l.percents[0],null,o.attr());for(var h=0,u=or.length;u>h;h++)if(or[h].anim==e&&or[h].el==t){or[u-1].start=or[h].start;break}return o},Qe.onAnimation=function(t){return t?e.on("raphael.anim.frame."+this.id,t):e.unbind("raphael.anim.frame."+this.id),this},v.prototype.delay=function(t){var e=new v(this.anim,this.ms);return e.times=this.times,e.del=+t||0,e},v.prototype.repeat=function(t){var e=new v(this.anim,this.ms);return e.del=this.del,e.times=q.floor(D(t,0))||1,e},r.animation=function(t,e,i,n){if(t instanceof v)return t;(r.is(i,"function")||!i)&&(n=n||i||null,i=null),t=Object(t),e=+e||0;var a,s,o={};for(s in t)t[B](s)&&K(s)!=s&&K(s)+"%"!=s&&(a=!0,o[s]=t[s]);return a?(i&&(o.easing=i),n&&(o.callback=n),new v({100:o},e)):new v(t,e)},Qe.animate=function(t,e,i,n){var a=this;if(a.removed)return n&&n.call(a),a;var s=t instanceof v?t:r.animation(t,e,i,n);return y(s,a,s.percents[0],null,a.attr()),a},Qe.setTime=function(t,e){return t&&null!=e&&this.status(t,O(e,t.ms)/t.ms),this},Qe.status=function(t,e){var r,i,n=[],a=0;if(null!=e)return y(t,this,-1,O(e,1)),this;for(r=or.length;r>a;a++)if(i=or[a],i.el.id==this.id&&(!t||i.anim==t)){if(t)return i.status;n.push({anim:i.anim,status:i.status})}return t?0:n},Qe.pause=function(t){for(var r=0;or.length>r;r++)or[r].el.id!=this.id||t&&or[r].anim!=t||e("raphael.anim.pause."+this.id,this,or[r].anim)!==!1&&(or[r].paused=!0);return this},Qe.resume=function(t){for(var r=0;or.length>r;r++)if(or[r].el.id==this.id&&(!t||or[r].anim==t)){var i=or[r];e("raphael.anim.resume."+this.id,this,i.anim)!==!1&&(delete i.paused,this.status(i.anim,i.status))}return this},Qe.stop=function(t){for(var r=0;or.length>r;r++)or[r].el.id!=this.id||t&&or[r].anim!=t||e("raphael.anim.stop."+this.id,this,or[r].anim)!==!1&&or.splice(r--,1);return this},e.on("raphael.remove",m),e.on("raphael.clear",m),Qe.toString=function(){return"Raphaël’s object"};var cr=function(t){if(this.items=[],this.length=0,this.type="set",t)for(var e=0,r=t.length;r>e;e++)!t[e]||t[e].constructor!=Qe.constructor&&t[e].constructor!=cr||(this[this.items.length]=this.items[this.items.length]=t[e],this.length++)},fr=cr.prototype;fr.push=function(){for(var t,e,r=0,i=arguments.length;i>r;r++)t=arguments[r],!t||t.constructor!=Qe.constructor&&t.constructor!=cr||(e=this.items.length,this[e]=this.items[e]=t,this.length++);return this},fr.pop=function(){return this.length&&delete this[this.length--],this.items.pop()},fr.forEach=function(t,e){for(var r=0,i=this.items.length;i>r;r++)if(t.call(e,this.items[r],r)===!1)return this;return this};for(var pr in Qe)Qe[B](pr)&&(fr[pr]=function(t){return function(){var e=arguments;return this.forEach(function(r){r[t][N](r,e)})}}(pr));return fr.attr=function(t,e){if(t&&r.is(t,H)&&r.is(t[0],"object"))for(var i=0,n=t.length;n>i;i++)this.items[i].attr(t[i]);else for(var a=0,s=this.items.length;s>a;a++)this.items[a].attr(t,e);return this},fr.clear=function(){for(;this.length;)this.pop()},fr.splice=function(t,e){t=0>t?D(this.length+t,0):t,e=D(0,O(this.length-t,e));var r,i=[],n=[],a=[];for(r=2;arguments.length>r;r++)a.push(arguments[r]);for(r=0;e>r;r++)n.push(this[t+r]);for(;this.length-t>r;r++)i.push(this[t+r]);var s=a.length;for(r=0;s+i.length>r;r++)this.items[t+r]=this[t+r]=s>r?a[r]:i[r-s];for(r=this.items.length=this.length-=e-s;this[r];)delete this[r++];return new cr(n)},fr.exclude=function(t){for(var e=0,r=this.length;r>e;e++)if(this[e]==t)return this.splice(e,1),!0},fr.animate=function(t,e,i,n){(r.is(i,"function")||!i)&&(n=i||null);var a,s,o=this.items.length,l=o,h=this;if(!o)return this;n&&(s=function(){!--o&&n.call(h)}),i=r.is(i,X)?i:s;var u=r.animation(t,e,i,s);for(a=this.items[--l].animate(u);l--;)this.items[l]&&!this.items[l].removed&&this.items[l].animateWith(a,u,u),this.items[l]&&!this.items[l].removed||o--;return this},fr.insertAfter=function(t){for(var e=this.items.length;e--;)this.items[e].insertAfter(t);return this},fr.getBBox=function(){for(var t=[],e=[],r=[],i=[],n=this.items.length;n--;)if(!this.items[n].removed){var a=this.items[n].getBBox();t.push(a.x),e.push(a.y),r.push(a.x+a.width),i.push(a.y+a.height)}return t=O[N](0,t),e=O[N](0,e),r=D[N](0,r),i=D[N](0,i),{x:t,y:e,x2:r,y2:i,width:r-t,height:i-e}},fr.clone=function(t){t=this.paper.set();for(var e=0,r=this.items.length;r>e;e++)t.push(this.items[e].clone());return t},fr.toString=function(){return"Raphaël‘s set"},fr.glow=function(t){var e=this.paper.set();return this.forEach(function(r){var i=r.glow(t);null!=i&&i.forEach(function(t){e.push(t)})}),e},fr.isPointInside=function(t,e){var r=!1;return this.forEach(function(i){return i.isPointInside(t,e)?(console.log("runned"),r=!0,!1):void 0}),r},r.registerFont=function(t){if(!t.face)return t;this.fonts=this.fonts||{};var e={w:t.w,face:{},glyphs:{}},r=t.face["font-family"];for(var i in t.face)t.face[B](i)&&(e.face[i]=t.face[i]);if(this.fonts[r]?this.fonts[r].push(e):this.fonts[r]=[e],!t.svg){e.face["units-per-em"]=te(t.face["units-per-em"],10);for(var n in t.glyphs)if(t.glyphs[B](n)){var a=t.glyphs[n];if(e.glyphs[n]={w:a.w,k:{},d:a.d&&"M"+a.d.replace(/[mlcxtrv]/g,function(t){return{l:"L",c:"C",x:"z",t:"m",r:"l",v:"c"}[t]||"M"})+"z"},a.k)for(var s in a.k)a[B](s)&&(e.glyphs[n].k[s]=a.k[s])}}return t},_.getFont=function(t,e,i,n){if(n=n||"normal",i=i||"normal",e=+e||{normal:400,bold:700,lighter:300,bolder:800}[e]||400,r.fonts){var a=r.fonts[t];if(!a){var s=RegExp("(^|\\s)"+t.replace(/[^\w\d\s+!~.:_-]/g,M)+"(\\s|$)","i");for(var o in r.fonts)if(r.fonts[B](o)&&s.test(o)){a=r.fonts[o];break}}var l;if(a)for(var h=0,u=a.length;u>h&&(l=a[h],l.face["font-weight"]!=e||l.face["font-style"]!=i&&l.face["font-style"]||l.face["font-stretch"]!=n);h++);return l}},_.print=function(t,e,i,n,a,s,o,l){s=s||"middle",o=D(O(o||0,1),-1),l=D(O(l||1,3),1);var h,u=F(i)[P](M),c=0,f=0,p=M;if(r.is(n,"string")&&(n=this.getFont(n)),n){h=(a||16)/n.face["units-per-em"];for(var d=n.face.bbox[P](w),g=+d[0],x=d[3]-d[1],v=0,y=+d[1]+("baseline"==s?x+ +n.face.descent:x/2),m=0,b=u.length;b>m;m++){if("\n"==u[m])c=0,k=0,f=0,v+=x*l;else{var _=f&&n.glyphs[u[m-1]]||{},k=n.glyphs[u[m]];c+=f?(_.w||n.w)+(_.k&&_.k[u[m]]||0)+n.w*o:0,f=1}k&&k.d&&(p+=r.transformPath(k.d,["t",c*h,v*h,"s",h,h,g,y,"t",(t-g)/h,(e-y)/h]))}}return this.path(p).attr({fill:"#000",stroke:"none"})},_.add=function(t){if(r.is(t,"array"))for(var e,i=this.set(),n=0,a=t.length;a>n;n++)e=t[n]||{},k[B](e.type)&&i.push(this[e.type]().attr(e));return i},r.format=function(t,e){var i=r.is(e,H)?[0][E](e):arguments;return t&&r.is(t,X)&&i.length-1&&(t=t.replace(C,function(t,e){return null==i[++e]?M:i[e]})),t||M},r.fullfill=function(){var t=/\{([^\}]+)\}/g,e=/(?:(?:^|\.)(.+?)(?=\[|\.|$|\()|\[('|")(.+?)\2\])(\(\))?/g,r=function(t,r,i){var n=i;return r.replace(e,function(t,e,r,i,a){e=e||i,n&&(e in n&&(n=n[e]),"function"==typeof n&&a&&(n=n()))}),n=(null==n||n==i?t:n)+""};return function(e,i){return(e+"").replace(t,function(t,e){return r(t,e,i)})}}(),r.ninja=function(){return T.was?S.win.Raphael=T.is:delete Raphael,r},r.st=fr,function(t,e,i){function n(){/in/.test(t.readyState)?setTimeout(n,9):r.eve("raphael.DOMload")}null==t.readyState&&t.addEventListener&&(t.addEventListener(e,i=function(){t.removeEventListener(e,i,!1),t.readyState="complete"},!1),t.readyState="loading"),n()}(document,"DOMContentLoaded"),e.on("raphael.DOMload",function(){b=!0}),function(){if(r.svg){var t="hasOwnProperty",e=String,i=parseFloat,n=parseInt,a=Math,s=a.max,o=a.abs,l=a.pow,h=/[, ]+/,u=r.eve,c="",f=" ",p="http://www.w3.org/1999/xlink",d={block:"M5,0 0,2.5 5,5z",classic:"M5,0 0,2.5 5,5 3.5,3 3.5,2z",diamond:"M2.5,0 5,2.5 2.5,5 0,2.5z",open:"M6,1 1,3.5 6,6",oval:"M2.5,0A2.5,2.5,0,0,1,2.5,5 2.5,2.5,0,0,1,2.5,0z"},g={};r.toString=function(){return"Your browser supports SVG.\nYou are running Raphaël "+this.version};var x=function(i,n){if(n){"string"==typeof i&&(i=x(i));for(var a in n)n[t](a)&&("xlink:"==a.substring(0,6)?i.setAttributeNS(p,a.substring(6),e(n[a])):i.setAttribute(a,e(n[a])))}else i=r._g.doc.createElementNS("http://www.w3.org/2000/svg",i),i.style&&(i.style.webkitTapHighlightColor="rgba(0,0,0,0)");return i},v=function(t,n){var h="linear",u=t.id+n,f=.5,p=.5,d=t.node,g=t.paper,v=d.style,y=r._g.doc.getElementById(u);if(!y){if(n=e(n).replace(r._radial_gradient,function(t,e,r){if(h="radial",e&&r){f=i(e),p=i(r);var n=2*(p>.5)-1;l(f-.5,2)+l(p-.5,2)>.25&&(p=a.sqrt(.25-l(f-.5,2))*n+.5)&&.5!=p&&(p=p.toFixed(5)-1e-5*n)}return c}),n=n.split(/\s*\-\s*/),"linear"==h){var m=n.shift();if(m=-i(m),isNaN(m))return null;var b=[0,0,a.cos(r.rad(m)),a.sin(r.rad(m))],_=1/(s(o(b[2]),o(b[3]))||1);b[2]*=_,b[3]*=_,0>b[2]&&(b[0]=-b[2],b[2]=0),0>b[3]&&(b[1]=-b[3],b[3]=0)}var w=r._parseDots(n);if(!w)return null;if(u=u.replace(/[\(\)\s,\xb0#]/g,"_"),t.gradient&&u!=t.gradient.id&&(g.defs.removeChild(t.gradient),delete t.gradient),!t.gradient){y=x(h+"Gradient",{id:u}),t.gradient=y,x(y,"radial"==h?{fx:f,fy:p}:{x1:b[0],y1:b[1],x2:b[2],y2:b[3],gradientTransform:t.matrix.invert()}),g.defs.appendChild(y);for(var k=0,C=w.length;C>k;k++)y.appendChild(x("stop",{offset:w[k].offset?w[k].offset:k?"100%":"0%","stop-color":w[k].color||"#fff"}))}}return x(d,{fill:"url(#"+u+")",opacity:1,"fill-opacity":1}),v.fill=c,v.opacity=1,v.fillOpacity=1,1},y=function(t){var e=t.getBBox(1);x(t.pattern,{patternTransform:t.matrix.invert()+" translate("+e.x+","+e.y+")"})},m=function(i,n,a){if("path"==i.type){for(var s,o,l,h,u,f=e(n).toLowerCase().split("-"),p=i.paper,v=a?"end":"start",y=i.node,m=i.attrs,b=m["stroke-width"],_=f.length,w="classic",k=3,C=3,B=5;_--;)switch(f[_]){case"block":case"classic":case"oval":case"diamond":case"open":case"none":w=f[_];break;case"wide":C=5;break;case"narrow":C=2;break;case"long":k=5;break;case"short":k=2}if("open"==w?(k+=2,C+=2,B+=2,l=1,h=a?4:1,u={fill:"none",stroke:m.stroke}):(h=l=k/2,u={fill:m.stroke,stroke:"none"}),i._.arrows?a?(i._.arrows.endPath&&g[i._.arrows.endPath]--,i._.arrows.endMarker&&g[i._.arrows.endMarker]--):(i._.arrows.startPath&&g[i._.arrows.startPath]--,i._.arrows.startMarker&&g[i._.arrows.startMarker]--):i._.arrows={},"none"!=w){var S="raphael-marker-"+w,T="raphael-marker-"+v+w+k+C;r._g.doc.getElementById(S)?g[S]++:(p.defs.appendChild(x(x("path"),{"stroke-linecap":"round",d:d[w],id:S})),g[S]=1);var A,N=r._g.doc.getElementById(T);N?(g[T]++,A=N.getElementsByTagName("use")[0]):(N=x(x("marker"),{id:T,markerHeight:C,markerWidth:k,orient:"auto",refX:h,refY:C/2}),A=x(x("use"),{"xlink:href":"#"+S,transform:(a?"rotate(180 "+k/2+" "+C/2+") ":c)+"scale("+k/B+","+C/B+")","stroke-width":(1/((k/B+C/B)/2)).toFixed(4)}),N.appendChild(A),p.defs.appendChild(N),g[T]=1),x(A,u);var E=l*("diamond"!=w&&"oval"!=w);a?(s=i._.arrows.startdx*b||0,o=r.getTotalLength(m.path)-E*b):(s=E*b,o=r.getTotalLength(m.path)-(i._.arrows.enddx*b||0)),u={},u["marker-"+v]="url(#"+T+")",(o||s)&&(u.d=r.getSubpath(m.path,s,o)),x(y,u),i._.arrows[v+"Path"]=S,i._.arrows[v+"Marker"]=T,i._.arrows[v+"dx"]=E,i._.arrows[v+"Type"]=w,i._.arrows[v+"String"]=n}else a?(s=i._.arrows.startdx*b||0,o=r.getTotalLength(m.path)-s):(s=0,o=r.getTotalLength(m.path)-(i._.arrows.enddx*b||0)),i._.arrows[v+"Path"]&&x(y,{d:r.getSubpath(m.path,s,o)}),delete i._.arrows[v+"Path"],delete i._.arrows[v+"Marker"],delete i._.arrows[v+"dx"],delete i._.arrows[v+"Type"],delete i._.arrows[v+"String"];for(u in g)if(g[t](u)&&!g[u]){var L=r._g.doc.getElementById(u);L&&L.parentNode.removeChild(L)}}},b={"":[0],none:[0],"-":[3,1],".":[1,1],"-.":[3,1,1,1],"-..":[3,1,1,1,1,1],". ":[1,3],"- ":[4,3],"--":[8,3],"- .":[4,3,1,3],"--.":[8,3,1,3],"--..":[8,3,1,3,1,3]},_=function(t,r,i){if(r=b[e(r).toLowerCase()]){for(var n=t.attrs["stroke-width"]||"1",a={round:n,square:n,butt:0}[t.attrs["stroke-linecap"]||i["stroke-linecap"]]||0,s=[],o=r.length;o--;)s[o]=r[o]*n+(o%2?1:-1)*a;x(t.node,{"stroke-dasharray":s.join(",")})}},w=function(i,a){var l=i.node,u=i.attrs,f=l.style.visibility;l.style.visibility="hidden";for(var d in a)if(a[t](d)){if(!r._availableAttrs[t](d))continue;var g=a[d];switch(u[d]=g,d){case"blur":i.blur(g);break;case"href":case"title":case"target":var b=l.parentNode;if("a"!=b.tagName.toLowerCase()){var w=x("a");b.insertBefore(w,l),w.appendChild(l),b=w}"target"==d?b.setAttributeNS(p,"show","blank"==g?"new":g):b.setAttributeNS(p,d,g);break;case"cursor":l.style.cursor=g;break;case"transform":i.transform(g);break;case"arrow-start":m(i,g);break;case"arrow-end":m(i,g,1);break;case"clip-rect":var k=e(g).split(h);if(4==k.length){i.clip&&i.clip.parentNode.parentNode.removeChild(i.clip.parentNode);var B=x("clipPath"),S=x("rect");B.id=r.createUUID(),x(S,{x:k[0],y:k[1],width:k[2],height:k[3]}),B.appendChild(S),i.paper.defs.appendChild(B),x(l,{"clip-path":"url(#"+B.id+")"}),i.clip=S}if(!g){var T=l.getAttribute("clip-path");if(T){var A=r._g.doc.getElementById(T.replace(/(^url\(#|\)$)/g,c));A&&A.parentNode.removeChild(A),x(l,{"clip-path":c}),delete i.clip}}break;case"path":"path"==i.type&&(x(l,{d:g?u.path=r._pathToAbsolute(g):"M0,0"}),i._.dirty=1,i._.arrows&&("startString"in i._.arrows&&m(i,i._.arrows.startString),"endString"in i._.arrows&&m(i,i._.arrows.endString,1)));break;case"width":if(l.setAttribute(d,g),i._.dirty=1,!u.fx)break;d="x",g=u.x;case"x":u.fx&&(g=-u.x-(u.width||0));case"rx":if("rx"==d&&"rect"==i.type)break;case"cx":l.setAttribute(d,g),i.pattern&&y(i),i._.dirty=1;break;case"height":if(l.setAttribute(d,g),i._.dirty=1,!u.fy)break;d="y",g=u.y;case"y":u.fy&&(g=-u.y-(u.height||0));case"ry":if("ry"==d&&"rect"==i.type)break;case"cy":l.setAttribute(d,g),i.pattern&&y(i),i._.dirty=1;break;case"r":"rect"==i.type?x(l,{rx:g,ry:g}):l.setAttribute(d,g),i._.dirty=1;break;case"src":"image"==i.type&&l.setAttributeNS(p,"href",g);break;case"stroke-width":(1!=i._.sx||1!=i._.sy)&&(g/=s(o(i._.sx),o(i._.sy))||1),i.paper._vbSize&&(g*=i.paper._vbSize),l.setAttribute(d,g),u["stroke-dasharray"]&&_(i,u["stroke-dasharray"],a),i._.arrows&&("startString"in i._.arrows&&m(i,i._.arrows.startString),"endString"in i._.arrows&&m(i,i._.arrows.endString,1));break;case"stroke-dasharray":_(i,g,a);break;case"fill":var N=e(g).match(r._ISURL);if(N){B=x("pattern");var E=x("image");B.id=r.createUUID(),x(B,{x:0,y:0,patternUnits:"userSpaceOnUse",height:1,width:1}),x(E,{x:0,y:0,"xlink:href":N[1]}),B.appendChild(E),function(t){r._preload(N[1],function(){var e=this.offsetWidth,r=this.offsetHeight;x(t,{width:e,height:r}),x(E,{width:e,height:r}),i.paper.safari()})}(B),i.paper.defs.appendChild(B),x(l,{fill:"url(#"+B.id+")"}),i.pattern=B,i.pattern&&y(i);break}var L=r.getRGB(g);if(L.error){if(("circle"==i.type||"ellipse"==i.type||"r"!=e(g).charAt())&&v(i,g)){if("opacity"in u||"fill-opacity"in u){var M=r._g.doc.getElementById(l.getAttribute("fill").replace(/^url\(#|\)$/g,c));if(M){var z=M.getElementsByTagName("stop");x(z[z.length-1],{"stop-opacity":("opacity"in u?u.opacity:1)*("fill-opacity"in u?u["fill-opacity"]:1)})}}u.gradient=g,u.fill="none";break}}else delete a.gradient,delete u.gradient,!r.is(u.opacity,"undefined")&&r.is(a.opacity,"undefined")&&x(l,{opacity:u.opacity}),!r.is(u["fill-opacity"],"undefined")&&r.is(a["fill-opacity"],"undefined")&&x(l,{"fill-opacity":u["fill-opacity"]});L[t]("opacity")&&x(l,{"fill-opacity":L.opacity>1?L.opacity/100:L.opacity});case"stroke":L=r.getRGB(g),l.setAttribute(d,L.hex),"stroke"==d&&L[t]("opacity")&&x(l,{"stroke-opacity":L.opacity>1?L.opacity/100:L.opacity}),"stroke"==d&&i._.arrows&&("startString"in i._.arrows&&m(i,i._.arrows.startString),"endString"in i._.arrows&&m(i,i._.arrows.endString,1));break;case"gradient":("circle"==i.type||"ellipse"==i.type||"r"!=e(g).charAt())&&v(i,g);break;case"opacity":u.gradient&&!u[t]("stroke-opacity")&&x(l,{"stroke-opacity":g>1?g/100:g});case"fill-opacity":if(u.gradient){M=r._g.doc.getElementById(l.getAttribute("fill").replace(/^url\(#|\)$/g,c)),M&&(z=M.getElementsByTagName("stop"),x(z[z.length-1],{"stop-opacity":g}));break}default:"font-size"==d&&(g=n(g,10)+"px");var F=d.replace(/(\-.)/g,function(t){return t.substring(1).toUpperCase()});l.style[F]=g,i._.dirty=1,l.setAttribute(d,g)}}C(i,a),l.style.visibility=f},k=1.2,C=function(i,a){if("text"==i.type&&(a[t]("text")||a[t]("font")||a[t]("font-size")||a[t]("x")||a[t]("y"))){var s=i.attrs,o=i.node,l=o.firstChild?n(r._g.doc.defaultView.getComputedStyle(o.firstChild,c).getPropertyValue("font-size"),10):10;if(a[t]("text")){for(s.text=a.text;o.firstChild;)o.removeChild(o.firstChild);for(var h,u=e(a.text).split("\n"),f=[],p=0,d=u.length;d>p;p++)h=x("tspan"),p&&x(h,{dy:l*k,x:s.x}),h.appendChild(r._g.doc.createTextNode(u[p])),o.appendChild(h),f[p]=h}else for(f=o.getElementsByTagName("tspan"),p=0,d=f.length;d>p;p++)p?x(f[p],{dy:l*k,x:s.x}):x(f[0],{dy:0});x(o,{x:s.x,y:s.y}),i._.dirty=1;var g=i._getBBox(),v=s.y-(g.y+g.height/2);v&&r.is(v,"finite")&&x(f[0],{dy:v})}},B=function(t,e){this[0]=this.node=t,t.raphael=!0,this.id=r._oid++,t.raphaelid=this.id,this.matrix=r.matrix(),this.realPath=null,this.paper=e,this.attrs=this.attrs||{},this._={transform:[],sx:1,sy:1,deg:0,dx:0,dy:0,dirty:1},!e.bottom&&(e.bottom=this),this.prev=e.top,e.top&&(e.top.next=this),e.top=this,this.next=null
},S=r.el;B.prototype=S,S.constructor=B,r._engine.path=function(t,e){var r=x("path");e.canvas&&e.canvas.appendChild(r);var i=new B(r,e);return i.type="path",w(i,{fill:"none",stroke:"#000",path:t}),i},S.rotate=function(t,r,n){if(this.removed)return this;if(t=e(t).split(h),t.length-1&&(r=i(t[1]),n=i(t[2])),t=i(t[0]),null==n&&(r=n),null==r||null==n){var a=this.getBBox(1);r=a.x+a.width/2,n=a.y+a.height/2}return this.transform(this._.transform.concat([["r",t,r,n]])),this},S.scale=function(t,r,n,a){if(this.removed)return this;if(t=e(t).split(h),t.length-1&&(r=i(t[1]),n=i(t[2]),a=i(t[3])),t=i(t[0]),null==r&&(r=t),null==a&&(n=a),null==n||null==a)var s=this.getBBox(1);return n=null==n?s.x+s.width/2:n,a=null==a?s.y+s.height/2:a,this.transform(this._.transform.concat([["s",t,r,n,a]])),this},S.translate=function(t,r){return this.removed?this:(t=e(t).split(h),t.length-1&&(r=i(t[1])),t=i(t[0])||0,r=+r||0,this.transform(this._.transform.concat([["t",t,r]])),this)},S.transform=function(e){var i=this._;if(null==e)return i.transform;if(r._extractTransform(this,e),this.clip&&x(this.clip,{transform:this.matrix.invert()}),this.pattern&&y(this),this.node&&x(this.node,{transform:this.matrix}),1!=i.sx||1!=i.sy){var n=this.attrs[t]("stroke-width")?this.attrs["stroke-width"]:1;this.attr({"stroke-width":n})}return this},S.hide=function(){return!this.removed&&this.paper.safari(this.node.style.display="none"),this},S.show=function(){return!this.removed&&this.paper.safari(this.node.style.display=""),this},S.remove=function(){if(!this.removed&&this.node.parentNode){var t=this.paper;t.__set__&&t.__set__.exclude(this),u.unbind("raphael.*.*."+this.id),this.gradient&&t.defs.removeChild(this.gradient),r._tear(this,t),"a"==this.node.parentNode.tagName.toLowerCase()?this.node.parentNode.parentNode.removeChild(this.node.parentNode):this.node.parentNode.removeChild(this.node);for(var e in this)this[e]="function"==typeof this[e]?r._removedFactory(e):null;this.removed=!0}},S._getBBox=function(){if("none"==this.node.style.display){this.show();var t=!0}var e={};try{e=this.node.getBBox()}catch(r){}finally{e=e||{}}return t&&this.hide(),e},S.attr=function(e,i){if(this.removed)return this;if(null==e){var n={};for(var a in this.attrs)this.attrs[t](a)&&(n[a]=this.attrs[a]);return n.gradient&&"none"==n.fill&&(n.fill=n.gradient)&&delete n.gradient,n.transform=this._.transform,n}if(null==i&&r.is(e,"string")){if("fill"==e&&"none"==this.attrs.fill&&this.attrs.gradient)return this.attrs.gradient;if("transform"==e)return this._.transform;for(var s=e.split(h),o={},l=0,c=s.length;c>l;l++)e=s[l],o[e]=e in this.attrs?this.attrs[e]:r.is(this.paper.customAttributes[e],"function")?this.paper.customAttributes[e].def:r._availableAttrs[e];return c-1?o:o[s[0]]}if(null==i&&r.is(e,"array")){for(o={},l=0,c=e.length;c>l;l++)o[e[l]]=this.attr(e[l]);return o}if(null!=i){var f={};f[e]=i}else null!=e&&r.is(e,"object")&&(f=e);for(var p in f)u("raphael.attr."+p+"."+this.id,this,f[p]);for(p in this.paper.customAttributes)if(this.paper.customAttributes[t](p)&&f[t](p)&&r.is(this.paper.customAttributes[p],"function")){var d=this.paper.customAttributes[p].apply(this,[].concat(f[p]));this.attrs[p]=f[p];for(var g in d)d[t](g)&&(f[g]=d[g])}return w(this,f),this},S.toFront=function(){if(this.removed)return this;"a"==this.node.parentNode.tagName.toLowerCase()?this.node.parentNode.parentNode.appendChild(this.node.parentNode):this.node.parentNode.appendChild(this.node);var t=this.paper;return t.top!=this&&r._tofront(this,t),this},S.toBack=function(){if(this.removed)return this;var t=this.node.parentNode;return"a"==t.tagName.toLowerCase()?t.parentNode.insertBefore(this.node.parentNode,this.node.parentNode.parentNode.firstChild):t.firstChild!=this.node&&t.insertBefore(this.node,this.node.parentNode.firstChild),r._toback(this,this.paper),this.paper,this},S.insertAfter=function(t){if(this.removed)return this;var e=t.node||t[t.length-1].node;return e.nextSibling?e.parentNode.insertBefore(this.node,e.nextSibling):e.parentNode.appendChild(this.node),r._insertafter(this,t,this.paper),this},S.insertBefore=function(t){if(this.removed)return this;var e=t.node||t[0].node;return e.parentNode.insertBefore(this.node,e),r._insertbefore(this,t,this.paper),this},S.blur=function(t){var e=this;if(0!==+t){var i=x("filter"),n=x("feGaussianBlur");e.attrs.blur=t,i.id=r.createUUID(),x(n,{stdDeviation:+t||1.5}),i.appendChild(n),e.paper.defs.appendChild(i),e._blur=i,x(e.node,{filter:"url(#"+i.id+")"})}else e._blur&&(e._blur.parentNode.removeChild(e._blur),delete e._blur,delete e.attrs.blur),e.node.removeAttribute("filter");return e},r._engine.circle=function(t,e,r,i){var n=x("circle");t.canvas&&t.canvas.appendChild(n);var a=new B(n,t);return a.attrs={cx:e,cy:r,r:i,fill:"none",stroke:"#000"},a.type="circle",x(n,a.attrs),a},r._engine.rect=function(t,e,r,i,n,a){var s=x("rect");t.canvas&&t.canvas.appendChild(s);var o=new B(s,t);return o.attrs={x:e,y:r,width:i,height:n,r:a||0,rx:a||0,ry:a||0,fill:"none",stroke:"#000"},o.type="rect",x(s,o.attrs),o},r._engine.ellipse=function(t,e,r,i,n){var a=x("ellipse");t.canvas&&t.canvas.appendChild(a);var s=new B(a,t);return s.attrs={cx:e,cy:r,rx:i,ry:n,fill:"none",stroke:"#000"},s.type="ellipse",x(a,s.attrs),s},r._engine.image=function(t,e,r,i,n,a){var s=x("image");x(s,{x:r,y:i,width:n,height:a,preserveAspectRatio:"none"}),s.setAttributeNS(p,"href",e),t.canvas&&t.canvas.appendChild(s);var o=new B(s,t);return o.attrs={x:r,y:i,width:n,height:a,src:e},o.type="image",o},r._engine.text=function(t,e,i,n){var a=x("text");t.canvas&&t.canvas.appendChild(a);var s=new B(a,t);return s.attrs={x:e,y:i,"text-anchor":"middle",text:n,font:r._availableAttrs.font,stroke:"none",fill:"#000"},s.type="text",w(s,s.attrs),s},r._engine.setSize=function(t,e){return this.width=t||this.width,this.height=e||this.height,this.canvas.setAttribute("width",this.width),this.canvas.setAttribute("height",this.height),this._viewBox&&this.setViewBox.apply(this,this._viewBox),this},r._engine.create=function(){var t=r._getContainer.apply(0,arguments),e=t&&t.container,i=t.x,n=t.y,a=t.width,s=t.height;if(!e)throw Error("SVG container not found.");var o,l=x("svg"),h="overflow:hidden;";return i=i||0,n=n||0,a=a||512,s=s||342,x(l,{height:s,version:1.1,width:a,xmlns:"http://www.w3.org/2000/svg"}),1==e?(l.style.cssText=h+"position:absolute;left:"+i+"px;top:"+n+"px",r._g.doc.body.appendChild(l),o=1):(l.style.cssText=h+"position:relative",e.firstChild?e.insertBefore(l,e.firstChild):e.appendChild(l)),e=new r._Paper,e.width=a,e.height=s,e.canvas=l,e.clear(),e._left=e._top=0,o&&(e.renderfix=function(){}),e.renderfix(),e},r._engine.setViewBox=function(t,e,r,i,n){u("raphael.setViewBox",this,this._viewBox,[t,e,r,i,n]);var a,o,l=s(r/this.width,i/this.height),h=this.top,c=n?"meet":"xMinYMin";for(null==t?(this._vbSize&&(l=1),delete this._vbSize,a="0 0 "+this.width+f+this.height):(this._vbSize=l,a=t+f+e+f+r+f+i),x(this.canvas,{viewBox:a,preserveAspectRatio:c});l&&h;)o="stroke-width"in h.attrs?h.attrs["stroke-width"]:1,h.attr({"stroke-width":o}),h._.dirty=1,h._.dirtyT=1,h=h.prev;return this._viewBox=[t,e,r,i,!!n],this},r.prototype.renderfix=function(){var t,e=this.canvas,r=e.style;try{t=e.getScreenCTM()||e.createSVGMatrix()}catch(i){t=e.createSVGMatrix()}var n=-t.e%1,a=-t.f%1;(n||a)&&(n&&(this._left=(this._left+n)%1,r.left=this._left+"px"),a&&(this._top=(this._top+a)%1,r.top=this._top+"px"))},r.prototype.clear=function(){r.eve("raphael.clear",this);for(var t=this.canvas;t.firstChild;)t.removeChild(t.firstChild);this.bottom=this.top=null,(this.desc=x("desc")).appendChild(r._g.doc.createTextNode("Created with Raphaël "+r.version)),t.appendChild(this.desc),t.appendChild(this.defs=x("defs"))},r.prototype.remove=function(){u("raphael.remove",this),this.canvas.parentNode&&this.canvas.parentNode.removeChild(this.canvas);for(var t in this)this[t]="function"==typeof this[t]?r._removedFactory(t):null};var T=r.st;for(var A in S)S[t](A)&&!T[t](A)&&(T[A]=function(t){return function(){var e=arguments;return this.forEach(function(r){r[t].apply(r,e)})}}(A))}}(),function(){if(r.vml){var t="hasOwnProperty",e=String,i=parseFloat,n=Math,a=n.round,s=n.max,o=n.min,l=n.abs,h="fill",u=/[, ]+/,c=r.eve,f=" progid:DXImageTransform.Microsoft",p=" ",d="",g={M:"m",L:"l",C:"c",Z:"x",m:"t",l:"r",c:"v",z:"x"},x=/([clmz]),?([^clmz]*)/gi,v=/ progid:\S+Blur\([^\)]+\)/g,y=/-?[^,\s-]+/g,m="position:absolute;left:0;top:0;width:1px;height:1px",b=21600,_={path:1,rect:1,image:1},w={circle:1,ellipse:1},k=function(t){var i=/[ahqstv]/gi,n=r._pathToAbsolute;if(e(t).match(i)&&(n=r._path2curve),i=/[clmz]/g,n==r._pathToAbsolute&&!e(t).match(i)){var s=e(t).replace(x,function(t,e,r){var i=[],n="m"==e.toLowerCase(),s=g[e];return r.replace(y,function(t){n&&2==i.length&&(s+=i+g["m"==e?"l":"L"],i=[]),i.push(a(t*b))}),s+i});return s}var o,l,h=n(t);s=[];for(var u=0,c=h.length;c>u;u++){o=h[u],l=h[u][0].toLowerCase(),"z"==l&&(l="x");for(var f=1,v=o.length;v>f;f++)l+=a(o[f]*b)+(f!=v-1?",":d);s.push(l)}return s.join(p)},C=function(t,e,i){var n=r.matrix();return n.rotate(-t,.5,.5),{dx:n.x(e,i),dy:n.y(e,i)}},B=function(t,e,r,i,n,a){var s=t._,o=t.matrix,u=s.fillpos,c=t.node,f=c.style,d=1,g="",x=b/e,v=b/r;if(f.visibility="hidden",e&&r){if(c.coordsize=l(x)+p+l(v),f.rotation=a*(0>e*r?-1:1),a){var y=C(a,i,n);i=y.dx,n=y.dy}if(0>e&&(g+="x"),0>r&&(g+=" y")&&(d=-1),f.flip=g,c.coordorigin=i*-x+p+n*-v,u||s.fillsize){var m=c.getElementsByTagName(h);m=m&&m[0],c.removeChild(m),u&&(y=C(a,o.x(u[0],u[1]),o.y(u[0],u[1])),m.position=y.dx*d+p+y.dy*d),s.fillsize&&(m.size=s.fillsize[0]*l(e)+p+s.fillsize[1]*l(r)),c.appendChild(m)}f.visibility="visible"}};r.toString=function(){return"Your browser doesn’t support SVG. Falling down to VML.\nYou are running Raphaël "+this.version};var S=function(t,r,i){for(var n=e(r).toLowerCase().split("-"),a=i?"end":"start",s=n.length,o="classic",l="medium",h="medium";s--;)switch(n[s]){case"block":case"classic":case"oval":case"diamond":case"open":case"none":o=n[s];break;case"wide":case"narrow":h=n[s];break;case"long":case"short":l=n[s]}var u=t.node.getElementsByTagName("stroke")[0];u[a+"arrow"]=o,u[a+"arrowlength"]=l,u[a+"arrowwidth"]=h},T=function(n,l){n.attrs=n.attrs||{};var c=n.node,f=n.attrs,g=c.style,x=_[n.type]&&(l.x!=f.x||l.y!=f.y||l.width!=f.width||l.height!=f.height||l.cx!=f.cx||l.cy!=f.cy||l.rx!=f.rx||l.ry!=f.ry||l.r!=f.r),v=w[n.type]&&(f.cx!=l.cx||f.cy!=l.cy||f.r!=l.r||f.rx!=l.rx||f.ry!=l.ry),y=n;for(var m in l)l[t](m)&&(f[m]=l[m]);if(x&&(f.path=r._getPath[n.type](n),n._.dirty=1),l.href&&(c.href=l.href),l.title&&(c.title=l.title),l.target&&(c.target=l.target),l.cursor&&(g.cursor=l.cursor),"blur"in l&&n.blur(l.blur),(l.path&&"path"==n.type||x)&&(c.path=k(~e(f.path).toLowerCase().indexOf("r")?r._pathToAbsolute(f.path):f.path),"image"==n.type&&(n._.fillpos=[f.x,f.y],n._.fillsize=[f.width,f.height],B(n,1,1,0,0,0))),"transform"in l&&n.transform(l.transform),v){var C=+f.cx,T=+f.cy,N=+f.rx||+f.r||0,E=+f.ry||+f.r||0;c.path=r.format("ar{0},{1},{2},{3},{4},{1},{4},{1}x",a((C-N)*b),a((T-E)*b),a((C+N)*b),a((T+E)*b),a(C*b)),n._.dirty=1}if("clip-rect"in l){var M=e(l["clip-rect"]).split(u);if(4==M.length){M[2]=+M[2]+ +M[0],M[3]=+M[3]+ +M[1];var z=c.clipRect||r._g.doc.createElement("div"),F=z.style;F.clip=r.format("rect({1}px {2}px {3}px {0}px)",M),c.clipRect||(F.position="absolute",F.top=0,F.left=0,F.width=n.paper.width+"px",F.height=n.paper.height+"px",c.parentNode.insertBefore(z,c),z.appendChild(c),c.clipRect=z)}l["clip-rect"]||c.clipRect&&(c.clipRect.style.clip="auto")}if(n.textpath){var P=n.textpath.style;l.font&&(P.font=l.font),l["font-family"]&&(P.fontFamily='"'+l["font-family"].split(",")[0].replace(/^['"]+|['"]+$/g,d)+'"'),l["font-size"]&&(P.fontSize=l["font-size"]),l["font-weight"]&&(P.fontWeight=l["font-weight"]),l["font-style"]&&(P.fontStyle=l["font-style"])}if("arrow-start"in l&&S(y,l["arrow-start"]),"arrow-end"in l&&S(y,l["arrow-end"],1),null!=l.opacity||null!=l["stroke-width"]||null!=l.fill||null!=l.src||null!=l.stroke||null!=l["stroke-width"]||null!=l["stroke-opacity"]||null!=l["fill-opacity"]||null!=l["stroke-dasharray"]||null!=l["stroke-miterlimit"]||null!=l["stroke-linejoin"]||null!=l["stroke-linecap"]){var R=c.getElementsByTagName(h),I=!1;if(R=R&&R[0],!R&&(I=R=L(h)),"image"==n.type&&l.src&&(R.src=l.src),l.fill&&(R.on=!0),(null==R.on||"none"==l.fill||null===l.fill)&&(R.on=!1),R.on&&l.fill){var j=e(l.fill).match(r._ISURL);if(j){R.parentNode==c&&c.removeChild(R),R.rotate=!0,R.src=j[1],R.type="tile";var q=n.getBBox(1);R.position=q.x+p+q.y,n._.fillpos=[q.x,q.y],r._preload(j[1],function(){n._.fillsize=[this.offsetWidth,this.offsetHeight]})}else R.color=r.getRGB(l.fill).hex,R.src=d,R.type="solid",r.getRGB(l.fill).error&&(y.type in{circle:1,ellipse:1}||"r"!=e(l.fill).charAt())&&A(y,l.fill,R)&&(f.fill="none",f.gradient=l.fill,R.rotate=!1)}if("fill-opacity"in l||"opacity"in l){var D=((+f["fill-opacity"]+1||2)-1)*((+f.opacity+1||2)-1)*((+r.getRGB(l.fill).o+1||2)-1);D=o(s(D,0),1),R.opacity=D,R.src&&(R.color="none")}c.appendChild(R);var O=c.getElementsByTagName("stroke")&&c.getElementsByTagName("stroke")[0],V=!1;!O&&(V=O=L("stroke")),(l.stroke&&"none"!=l.stroke||l["stroke-width"]||null!=l["stroke-opacity"]||l["stroke-dasharray"]||l["stroke-miterlimit"]||l["stroke-linejoin"]||l["stroke-linecap"])&&(O.on=!0),("none"==l.stroke||null===l.stroke||null==O.on||0==l.stroke||0==l["stroke-width"])&&(O.on=!1);var Y=r.getRGB(l.stroke);O.on&&l.stroke&&(O.color=Y.hex),D=((+f["stroke-opacity"]+1||2)-1)*((+f.opacity+1||2)-1)*((+Y.o+1||2)-1);var G=.75*(i(l["stroke-width"])||1);if(D=o(s(D,0),1),null==l["stroke-width"]&&(G=f["stroke-width"]),l["stroke-width"]&&(O.weight=G),G&&1>G&&(D*=G)&&(O.weight=1),O.opacity=D,l["stroke-linejoin"]&&(O.joinstyle=l["stroke-linejoin"]||"miter"),O.miterlimit=l["stroke-miterlimit"]||8,l["stroke-linecap"]&&(O.endcap="butt"==l["stroke-linecap"]?"flat":"square"==l["stroke-linecap"]?"square":"round"),l["stroke-dasharray"]){var W={"-":"shortdash",".":"shortdot","-.":"shortdashdot","-..":"shortdashdotdot",". ":"dot","- ":"dash","--":"longdash","- .":"dashdot","--.":"longdashdot","--..":"longdashdotdot"};O.dashstyle=W[t](l["stroke-dasharray"])?W[l["stroke-dasharray"]]:d}V&&c.appendChild(O)}if("text"==y.type){y.paper.canvas.style.display=d;var X=y.paper.span,H=100,U=f.font&&f.font.match(/\d+(?:\.\d*)?(?=px)/);g=X.style,f.font&&(g.font=f.font),f["font-family"]&&(g.fontFamily=f["font-family"]),f["font-weight"]&&(g.fontWeight=f["font-weight"]),f["font-style"]&&(g.fontStyle=f["font-style"]),U=i(f["font-size"]||U&&U[0])||10,g.fontSize=U*H+"px",y.textpath.string&&(X.innerHTML=e(y.textpath.string).replace(/</g,"&#60;").replace(/&/g,"&#38;").replace(/\n/g,"<br>"));var $=X.getBoundingClientRect();y.W=f.w=($.right-$.left)/H,y.H=f.h=($.bottom-$.top)/H,y.X=f.x,y.Y=f.y+y.H/2,("x"in l||"y"in l)&&(y.path.v=r.format("m{0},{1}l{2},{1}",a(f.x*b),a(f.y*b),a(f.x*b)+1));for(var Z=["x","y","text","font","font-family","font-weight","font-style","font-size"],Q=0,J=Z.length;J>Q;Q++)if(Z[Q]in l){y._.dirty=1;break}switch(f["text-anchor"]){case"start":y.textpath.style["v-text-align"]="left",y.bbx=y.W/2;break;case"end":y.textpath.style["v-text-align"]="right",y.bbx=-y.W/2;break;default:y.textpath.style["v-text-align"]="center",y.bbx=0}y.textpath.style["v-text-kern"]=!0}},A=function(t,a,s){t.attrs=t.attrs||{};var o=(t.attrs,Math.pow),l="linear",h=".5 .5";if(t.attrs.gradient=a,a=e(a).replace(r._radial_gradient,function(t,e,r){return l="radial",e&&r&&(e=i(e),r=i(r),o(e-.5,2)+o(r-.5,2)>.25&&(r=n.sqrt(.25-o(e-.5,2))*(2*(r>.5)-1)+.5),h=e+p+r),d}),a=a.split(/\s*\-\s*/),"linear"==l){var u=a.shift();if(u=-i(u),isNaN(u))return null}var c=r._parseDots(a);if(!c)return null;if(t=t.shape||t.node,c.length){t.removeChild(s),s.on=!0,s.method="none",s.color=c[0].color,s.color2=c[c.length-1].color;for(var f=[],g=0,x=c.length;x>g;g++)c[g].offset&&f.push(c[g].offset+p+c[g].color);s.colors=f.length?f.join():"0% "+s.color,"radial"==l?(s.type="gradientTitle",s.focus="100%",s.focussize="0 0",s.focusposition=h,s.angle=0):(s.type="gradient",s.angle=(270-u)%360),t.appendChild(s)}return 1},N=function(t,e){this[0]=this.node=t,t.raphael=!0,this.id=r._oid++,t.raphaelid=this.id,this.X=0,this.Y=0,this.attrs={},this.paper=e,this.matrix=r.matrix(),this._={transform:[],sx:1,sy:1,dx:0,dy:0,deg:0,dirty:1,dirtyT:1},!e.bottom&&(e.bottom=this),this.prev=e.top,e.top&&(e.top.next=this),e.top=this,this.next=null},E=r.el;N.prototype=E,E.constructor=N,E.transform=function(t){if(null==t)return this._.transform;var i,n=this.paper._viewBoxShift,a=n?"s"+[n.scale,n.scale]+"-1-1t"+[n.dx,n.dy]:d;n&&(i=t=e(t).replace(/\.{3}|\u2026/g,this._.transform||d)),r._extractTransform(this,a+t);var s,o=this.matrix.clone(),l=this.skew,h=this.node,u=~e(this.attrs.fill).indexOf("-"),c=!e(this.attrs.fill).indexOf("url(");if(o.translate(-.5,-.5),c||u||"image"==this.type)if(l.matrix="1 0 0 1",l.offset="0 0",s=o.split(),u&&s.noRotation||!s.isSimple){h.style.filter=o.toFilter();var f=this.getBBox(),g=this.getBBox(1),x=f.x-g.x,v=f.y-g.y;h.coordorigin=x*-b+p+v*-b,B(this,1,1,x,v,0)}else h.style.filter=d,B(this,s.scalex,s.scaley,s.dx,s.dy,s.rotate);else h.style.filter=d,l.matrix=e(o),l.offset=o.offset();return i&&(this._.transform=i),this},E.rotate=function(t,r,n){if(this.removed)return this;if(null!=t){if(t=e(t).split(u),t.length-1&&(r=i(t[1]),n=i(t[2])),t=i(t[0]),null==n&&(r=n),null==r||null==n){var a=this.getBBox(1);r=a.x+a.width/2,n=a.y+a.height/2}return this._.dirtyT=1,this.transform(this._.transform.concat([["r",t,r,n]])),this}},E.translate=function(t,r){return this.removed?this:(t=e(t).split(u),t.length-1&&(r=i(t[1])),t=i(t[0])||0,r=+r||0,this._.bbox&&(this._.bbox.x+=t,this._.bbox.y+=r),this.transform(this._.transform.concat([["t",t,r]])),this)},E.scale=function(t,r,n,a){if(this.removed)return this;if(t=e(t).split(u),t.length-1&&(r=i(t[1]),n=i(t[2]),a=i(t[3]),isNaN(n)&&(n=null),isNaN(a)&&(a=null)),t=i(t[0]),null==r&&(r=t),null==a&&(n=a),null==n||null==a)var s=this.getBBox(1);return n=null==n?s.x+s.width/2:n,a=null==a?s.y+s.height/2:a,this.transform(this._.transform.concat([["s",t,r,n,a]])),this._.dirtyT=1,this},E.hide=function(){return!this.removed&&(this.node.style.display="none"),this},E.show=function(){return!this.removed&&(this.node.style.display=d),this},E._getBBox=function(){return this.removed?{}:{x:this.X+(this.bbx||0)-this.W/2,y:this.Y-this.H,width:this.W,height:this.H}},E.remove=function(){if(!this.removed&&this.node.parentNode){this.paper.__set__&&this.paper.__set__.exclude(this),r.eve.unbind("raphael.*.*."+this.id),r._tear(this,this.paper),this.node.parentNode.removeChild(this.node),this.shape&&this.shape.parentNode.removeChild(this.shape);for(var t in this)this[t]="function"==typeof this[t]?r._removedFactory(t):null;this.removed=!0}},E.attr=function(e,i){if(this.removed)return this;if(null==e){var n={};for(var a in this.attrs)this.attrs[t](a)&&(n[a]=this.attrs[a]);return n.gradient&&"none"==n.fill&&(n.fill=n.gradient)&&delete n.gradient,n.transform=this._.transform,n}if(null==i&&r.is(e,"string")){if(e==h&&"none"==this.attrs.fill&&this.attrs.gradient)return this.attrs.gradient;for(var s=e.split(u),o={},l=0,f=s.length;f>l;l++)e=s[l],o[e]=e in this.attrs?this.attrs[e]:r.is(this.paper.customAttributes[e],"function")?this.paper.customAttributes[e].def:r._availableAttrs[e];return f-1?o:o[s[0]]}if(this.attrs&&null==i&&r.is(e,"array")){for(o={},l=0,f=e.length;f>l;l++)o[e[l]]=this.attr(e[l]);return o}var p;null!=i&&(p={},p[e]=i),null==i&&r.is(e,"object")&&(p=e);for(var d in p)c("raphael.attr."+d+"."+this.id,this,p[d]);if(p){for(d in this.paper.customAttributes)if(this.paper.customAttributes[t](d)&&p[t](d)&&r.is(this.paper.customAttributes[d],"function")){var g=this.paper.customAttributes[d].apply(this,[].concat(p[d]));this.attrs[d]=p[d];for(var x in g)g[t](x)&&(p[x]=g[x])}p.text&&"text"==this.type&&(this.textpath.string=p.text),T(this,p)}return this},E.toFront=function(){return!this.removed&&this.node.parentNode.appendChild(this.node),this.paper&&this.paper.top!=this&&r._tofront(this,this.paper),this},E.toBack=function(){return this.removed?this:(this.node.parentNode.firstChild!=this.node&&(this.node.parentNode.insertBefore(this.node,this.node.parentNode.firstChild),r._toback(this,this.paper)),this)},E.insertAfter=function(t){return this.removed?this:(t.constructor==r.st.constructor&&(t=t[t.length-1]),t.node.nextSibling?t.node.parentNode.insertBefore(this.node,t.node.nextSibling):t.node.parentNode.appendChild(this.node),r._insertafter(this,t,this.paper),this)},E.insertBefore=function(t){return this.removed?this:(t.constructor==r.st.constructor&&(t=t[0]),t.node.parentNode.insertBefore(this.node,t.node),r._insertbefore(this,t,this.paper),this)},E.blur=function(t){var e=this.node.runtimeStyle,i=e.filter;return i=i.replace(v,d),0!==+t?(this.attrs.blur=t,e.filter=i+p+f+".Blur(pixelradius="+(+t||1.5)+")",e.margin=r.format("-{0}px 0 0 -{0}px",a(+t||1.5))):(e.filter=i,e.margin=0,delete this.attrs.blur),this},r._engine.path=function(t,e){var r=L("shape");r.style.cssText=m,r.coordsize=b+p+b,r.coordorigin=e.coordorigin;var i=new N(r,e),n={fill:"none",stroke:"#000"};t&&(n.path=t),i.type="path",i.path=[],i.Path=d,T(i,n),e.canvas.appendChild(r);var a=L("skew");return a.on=!0,r.appendChild(a),i.skew=a,i.transform(d),i},r._engine.rect=function(t,e,i,n,a,s){var o=r._rectPath(e,i,n,a,s),l=t.path(o),h=l.attrs;return l.X=h.x=e,l.Y=h.y=i,l.W=h.width=n,l.H=h.height=a,h.r=s,h.path=o,l.type="rect",l},r._engine.ellipse=function(t,e,r,i,n){var a=t.path();return a.attrs,a.X=e-i,a.Y=r-n,a.W=2*i,a.H=2*n,a.type="ellipse",T(a,{cx:e,cy:r,rx:i,ry:n}),a},r._engine.circle=function(t,e,r,i){var n=t.path();return n.attrs,n.X=e-i,n.Y=r-i,n.W=n.H=2*i,n.type="circle",T(n,{cx:e,cy:r,r:i}),n},r._engine.image=function(t,e,i,n,a,s){var o=r._rectPath(i,n,a,s),l=t.path(o).attr({stroke:"none"}),u=l.attrs,c=l.node,f=c.getElementsByTagName(h)[0];return u.src=e,l.X=u.x=i,l.Y=u.y=n,l.W=u.width=a,l.H=u.height=s,u.path=o,l.type="image",f.parentNode==c&&c.removeChild(f),f.rotate=!0,f.src=e,f.type="tile",l._.fillpos=[i,n],l._.fillsize=[a,s],c.appendChild(f),B(l,1,1,0,0,0),l},r._engine.text=function(t,i,n,s){var o=L("shape"),l=L("path"),h=L("textpath");i=i||0,n=n||0,s=s||"",l.v=r.format("m{0},{1}l{2},{1}",a(i*b),a(n*b),a(i*b)+1),l.textpathok=!0,h.string=e(s),h.on=!0,o.style.cssText=m,o.coordsize=b+p+b,o.coordorigin="0 0";var u=new N(o,t),c={fill:"#000",stroke:"none",font:r._availableAttrs.font,text:s};u.shape=o,u.path=l,u.textpath=h,u.type="text",u.attrs.text=e(s),u.attrs.x=i,u.attrs.y=n,u.attrs.w=1,u.attrs.h=1,T(u,c),o.appendChild(h),o.appendChild(l),t.canvas.appendChild(o);var f=L("skew");return f.on=!0,o.appendChild(f),u.skew=f,u.transform(d),u},r._engine.setSize=function(t,e){var i=this.canvas.style;return this.width=t,this.height=e,t==+t&&(t+="px"),e==+e&&(e+="px"),i.width=t,i.height=e,i.clip="rect(0 "+t+" "+e+" 0)",this._viewBox&&r._engine.setViewBox.apply(this,this._viewBox),this},r._engine.setViewBox=function(t,e,i,n,a){r.eve("raphael.setViewBox",this,this._viewBox,[t,e,i,n,a]);var o,l,h=this.width,u=this.height,c=1/s(i/h,n/u);return a&&(o=u/n,l=h/i,h>i*o&&(t-=(h-i*o)/2/o),u>n*l&&(e-=(u-n*l)/2/l)),this._viewBox=[t,e,i,n,!!a],this._viewBoxShift={dx:-t,dy:-e,scale:c},this.forEach(function(t){t.transform("...")}),this};var L;r._engine.initWin=function(t){var e=t.document;e.createStyleSheet().addRule(".rvml","behavior:url(#default#VML)");try{!e.namespaces.rvml&&e.namespaces.add("rvml","urn:schemas-microsoft-com:vml"),L=function(t){return e.createElement("<rvml:"+t+' class="rvml">')}}catch(r){L=function(t){return e.createElement("<"+t+' xmlns="urn:schemas-microsoft.com:vml" class="rvml">')}}},r._engine.initWin(r._g.win),r._engine.create=function(){var t=r._getContainer.apply(0,arguments),e=t.container,i=t.height,n=t.width,a=t.x,s=t.y;if(!e)throw Error("VML container not found.");var o=new r._Paper,l=o.canvas=r._g.doc.createElement("div"),h=l.style;return a=a||0,s=s||0,n=n||512,i=i||342,o.width=n,o.height=i,n==+n&&(n+="px"),i==+i&&(i+="px"),o.coordsize=1e3*b+p+1e3*b,o.coordorigin="0 0",o.span=r._g.doc.createElement("span"),o.span.style.cssText="position:absolute;left:-9999em;top:-9999em;padding:0;margin:0;line-height:1;",l.appendChild(o.span),h.cssText=r.format("top:0;left:0;width:{0};height:{1};display:inline-block;position:relative;clip:rect(0 {0} {1} 0);overflow:hidden",n,i),1==e?(r._g.doc.body.appendChild(l),h.left=a+"px",h.top=s+"px",h.position="absolute"):e.firstChild?e.insertBefore(l,e.firstChild):e.appendChild(l),o.renderfix=function(){},o},r.prototype.clear=function(){r.eve("raphael.clear",this),this.canvas.innerHTML=d,this.span=r._g.doc.createElement("span"),this.span.style.cssText="position:absolute;left:-9999em;top:-9999em;padding:0;margin:0;line-height:1;display:inline;",this.canvas.appendChild(this.span),this.bottom=this.top=null},r.prototype.remove=function(){r.eve("raphael.remove",this),this.canvas.parentNode.removeChild(this.canvas);for(var t in this)this[t]="function"==typeof this[t]?r._removedFactory(t):null;return!0};var M=r.st;for(var z in E)E[t](z)&&!M[t](z)&&(M[z]=function(t){return function(){var e=arguments;return this.forEach(function(r){r[t].apply(r,e)})}}(z))}}(),T.was?S.win.Raphael=r:Raphael=r,r});
(function(){var e,t,n,r,i=[].slice,s={}.hasOwnProperty,o=function(e,t){function r(){this.constructor=e}for(var n in t)s.call(t,n)&&(e[n]=t[n]);return r.prototype=t.prototype,e.prototype=new r,e.__super__=t.prototype,e},u=function(e,t){return function(){return e.apply(t,arguments)}},a=[].indexOf||function(e){for(var t=0,n=this.length;t<n;t++)if(t in this&&this[t]===e)return t;return-1};t=window.Morris={},e=jQuery,t.EventEmitter=function(){function e(){}return e.prototype.on=function(e,t){return this.handlers==null&&(this.handlers={}),this.handlers[e]==null&&(this.handlers[e]=[]),this.handlers[e].push(t),this},e.prototype.fire=function(){var e,t,n,r,s,o,u;n=arguments[0],e=2<=arguments.length?i.call(arguments,1):[];if(this.handlers!=null&&this.handlers[n]!=null){o=this.handlers[n],u=[];for(r=0,s=o.length;r<s;r++)t=o[r],u.push(t.apply(null,e));return u}},e}(),t.commas=function(e){var t,n,r,i;return e!=null?(r=e<0?"-":"",t=Math.abs(e),n=Math.floor(t).toFixed(0),r+=n.replace(/(?=(?:\d{3})+$)(?!^)/g,","),i=t.toString(),i.length>n.length&&(r+=i.slice(n.length)),r):"-"},t.pad2=function(e){return(e<10?"0":"")+e},t.Grid=function(n){function r(t){var n=this;typeof t.element=="string"?this.el=e(document.getElementById(t.element)):this.el=e(t.element);if(this.el==null||this.el.length===0)throw new Error("Graph container element not found");this.el.css("position")==="static"&&this.el.css("position","relative"),this.options=e.extend({},this.gridDefaults,this.defaults||{},t),typeof this.options.units=="string"&&(this.options.postUnits=t.units),this.raphael=new Raphael(this.el[0]),this.elementWidth=null,this.elementHeight=null,this.dirty=!1,this.init&&this.init(),this.setData(this.options.data),this.el.on("mousemove",function(e){var t;return t=n.el.offset(),n.fire("hovermove",e.pageX-t.left,e.pageY-t.top)}),this.el.on("mouseout",function(e){return n.fire("hoverout")}),this.el.on("touchstart touchmove touchend",function(e){var t,r;return r=e.originalEvent.touches[0]||e.originalEvent.changedTouches[0],t=n.el.offset(),n.fire("hover",r.pageX-t.left,r.pageY-t.top),r}),this.el.on("click",function(e){var t;return t=n.el.offset(),n.fire("gridclick",e.pageX-t.left,e.pageY-t.top)}),this.postInit&&this.postInit()}return o(r,n),r.prototype.gridDefaults={dateFormat:null,axes:!0,grid:!0,gridLineColor:"#aaa",gridStrokeWidth:.5,gridTextColor:"#888",gridTextSize:12,gridTextFamily:"sans-serif",gridTextWeight:"normal",hideHover:!1,yLabelFormat:null,xLabelAngle:0,numLines:5,padding:25,parseTime:!0,postUnits:"",preUnits:"",ymax:"auto",ymin:"auto 0",goals:[],goalStrokeWidth:1,goalLineColors:["#666633","#999966","#cc6666","#663333"],events:[],eventStrokeWidth:1,eventLineColors:["#005a04","#ccffbb","#3a5f0b","#005502"]},r.prototype.setData=function(e,n){var r,i,s,o,u,a,f,l,c,h,p,d,v,m;n==null&&(n=!0),this.options.data=e;if(e==null||e.length===0){this.data=[],this.raphael.clear(),this.hover!=null&&this.hover.hide();return}d=this.cumulative?0:null,v=this.cumulative?0:null,this.options.goals.length>0&&(u=Math.min.apply(null,this.options.goals),o=Math.max.apply(null,this.options.goals),v=v!=null?Math.min(v,u):u,d=d!=null?Math.max(d,o):o),this.data=function(){var n,r,o;o=[];for(s=n=0,r=e.length;n<r;s=++n)f=e[s],a={},a.label=f[this.options.xkey],this.options.parseTime?(a.x=t.parseDate(a.label),this.options.dateFormat?a.label=this.options.dateFormat(a.x):typeof a.label=="number"&&(a.label=(new Date(a.label)).toString())):(a.x=s,this.options.xLabelFormat&&(a.label=this.options.xLabelFormat(a))),c=0,a.y=function(){var e,t,n,r;n=this.options.ykeys,r=[];for(i=e=0,t=n.length;e<t;i=++e)p=n[i],m=f[p],typeof m=="string"&&(m=parseFloat(m)),m!=null&&typeof m!="number"&&(m=null),m!=null&&(this.cumulative?c+=m:d!=null?(d=Math.max(m,d),v=Math.min(m,v)):d=v=m),this.cumulative&&c!=null&&(d=Math.max(c,d),v=Math.min(c,v)),r.push(m);return r}.call(this),o.push(a);return o}.call(this),this.options.parseTime&&(this.data=this.data.sort(function(e,t){return(e.x>t.x)-(t.x>e.x)})),this.xmin=this.data[0].x,this.xmax=this.data[this.data.length-1].x,this.events=[],this.options.parseTime&&this.options.events.length>0&&(this.events=function(){var e,n,i,s;i=this.options.events,s=[];for(e=0,n=i.length;e<n;e++)r=i[e],s.push(t.parseDate(r));return s}.call(this),this.xmax=Math.max(this.xmax,Math.max.apply(null,this.events)),this.xmin=Math.min(this.xmin,Math.min.apply(null,this.events))),this.xmin===this.xmax&&(this.xmin-=1,this.xmax+=1),this.ymin=this.yboundary("min",v),this.ymax=this.yboundary("max",d),this.ymin===this.ymax&&(v&&(this.ymin-=1),this.ymax+=1);if(this.options.axes===!0||this.options.grid===!0)this.options.ymax===this.gridDefaults.ymax&&this.options.ymin===this.gridDefaults.ymin?(this.grid=this.autoGridLines(this.ymin,this.ymax,this.options.numLines),this.ymin=Math.min(this.ymin,this.grid[0]),this.ymax=Math.max(this.ymax,this.grid[this.grid.length-1])):(l=(this.ymax-this.ymin)/(this.options.numLines-1),this.grid=function(){var e,t,n,r;r=[];for(h=e=t=this.ymin,n=this.ymax;t<=n?e<=n:e>=n;h=e+=l)r.push(h);return r}.call(this));this.dirty=!0;if(n)return this.redraw()},r.prototype.yboundary=function(e,t){var n,r;return n=this.options["y"+e],typeof n=="string"?n.slice(0,4)==="auto"?n.length>5?(r=parseInt(n.slice(5),10),t==null?r:Math[e](t,r)):t!=null?t:0:parseInt(n,10):n},r.prototype.autoGridLines=function(e,t,n){var r,i,s,o,u,a,f,l,c;return u=t-e,c=Math.floor(Math.log(u)/Math.log(10)),f=Math.pow(10,c),i=Math.floor(e/f)*f,r=Math.ceil(t/f)*f,a=(r-i)/(n-1),f===1&&a>1&&Math.ceil(a)!==a&&(a=Math.ceil(a),r=i+a*(n-1)),i<0&&r>0&&(i=Math.floor(e/a)*a,r=Math.ceil(t/a)*a),a<1?(o=Math.floor(Math.log(a)/Math.log(10)),s=function(){var e,t;t=[];for(l=e=i;i<=r?e<=r:e>=r;l=e+=a)t.push(parseFloat(l.toFixed(1-o)));return t}()):s=function(){var e,t;t=[];for(l=e=i;i<=r?e<=r:e>=r;l=e+=a)t.push(l);return t}(),s},r.prototype._calc=function(){var e,t,n,r,i,s;i=this.el.width(),n=this.el.height();if(this.elementWidth!==i||this.elementHeight!==n||this.dirty){this.elementWidth=i,this.elementHeight=n,this.dirty=!1,this.left=this.options.padding,this.right=this.elementWidth-this.options.padding,this.top=this.options.padding,this.bottom=this.elementHeight-this.options.padding,this.options.axes&&(s=function(){var e,n,r,i;r=this.grid,i=[];for(e=0,n=r.length;e<n;e++)t=r[e],i.push(this.measureText(this.yAxisFormat(t)).width);return i}.call(this),this.left+=Math.max.apply(Math,s),e=function(){var e,t,n;n=[];for(r=e=0,t=this.data.length;0<=t?e<t:e>t;r=0<=t?++e:--e)n.push(this.measureText(this.data[r].text,-this.options.xLabelAngle).height);return n}.call(this),this.bottom-=Math.max.apply(Math,e)),this.width=Math.max(1,this.right-this.left),this.height=Math.max(1,this.bottom-this.top),this.dx=this.width/(this.xmax-this.xmin),this.dy=this.height/(this.ymax-this.ymin);if(this.calc)return this.calc()}},r.prototype.transY=function(e){return this.bottom-(e-this.ymin)*this.dy},r.prototype.transX=function(e){return this.data.length===1?(this.left+this.right)/2:this.left+(e-this.xmin)*this.dx},r.prototype.redraw=function(){this.raphael.clear(),this._calc(),this.drawGrid(),this.drawGoals(),this.drawEvents();if(this.draw)return this.draw()},r.prototype.measureText=function(e,t){var n,r;return t==null&&(t=0),r=this.raphael.text(100,100,e).attr("font-size",this.options.gridTextSize).attr("font-family",this.options.gridTextFamily).attr("font-weight",this.options.gridTextWeight).rotate(t),n=r.getBBox(),r.remove(),n},r.prototype.yAxisFormat=function(e){return this.yLabelFormat(e)},r.prototype.yLabelFormat=function(e){return typeof this.options.yLabelFormat=="function"?this.options.yLabelFormat(e):""+this.options.preUnits+t.commas(e)+this.options.postUnits},r.prototype.updateHover=function(e,t){var n,r;n=this.hitTest(e,t);if(n!=null)return(r=this.hover).update.apply(r,n)},r.prototype.drawGrid=function(){var e,t,n,r,i,s;if(this.options.grid===!1&&this.options.axes===!1)return;i=this.grid,s=[];for(n=0,r=i.length;n<r;n++)e=i[n],t=this.transY(e),this.options.axes&&this.drawYAxisLabel(this.left-this.options.padding/2,t,this.yAxisFormat(e)),this.options.grid?s.push(this.drawGridLine("M"+this.left+","+t+"H"+(this.left+this.width))):s.push(void 0);return s},r.prototype.drawGoals=function(){var e,t,n,r,i,s,o;s=this.options.goals,o=[];for(n=r=0,i=s.length;r<i;n=++r)t=s[n],e=this.options.goalLineColors[n%this.options.goalLineColors.length],o.push(this.drawGoal(t,e));return o},r.prototype.drawEvents=function(){var e,t,n,r,i,s,o;s=this.events,o=[];for(n=r=0,i=s.length;r<i;n=++r)t=s[n],e=this.options.eventLineColors[n%this.options.eventLineColors.length],o.push(this.drawEvent(t,e));return o},r.prototype.drawGoal=function(e,t){return this.raphael.path("M"+this.left+","+this.transY(e)+"H"+this.right).attr("stroke",t).attr("stroke-width",this.options.goalStrokeWidth)},r.prototype.drawEvent=function(e,t){return this.raphael.path("M"+this.transX(e)+","+this.bottom+"V"+this.top).attr("stroke",t).attr("stroke-width",this.options.eventStrokeWidth)},r.prototype.drawYAxisLabel=function(e,t,n){return this.raphael.text(e,t,n).attr("font-size",this.options.gridTextSize).attr("font-family",this.options.gridTextFamily).attr("font-weight",this.options.gridTextWeight).attr("fill",this.options.gridTextColor).attr("text-anchor","end")},r.prototype.drawGridLine=function(e){return this.raphael.path(e).attr("stroke",this.options.gridLineColor).attr("stroke-width",this.options.gridStrokeWidth)},r}(t.EventEmitter),t.parseDate=function(e){var t,n,r,i,s,o,u,a,f,l,c;return typeof e=="number"?e:(n=e.match(/^(\d+) Q(\d)$/),i=e.match(/^(\d+)-(\d+)$/),s=e.match(/^(\d+)-(\d+)-(\d+)$/),u=e.match(/^(\d+) W(\d+)$/),a=e.match(/^(\d+)-(\d+)-(\d+)[ T](\d+):(\d+)(Z|([+-])(\d\d):?(\d\d))?$/),f=e.match(/^(\d+)-(\d+)-(\d+)[ T](\d+):(\d+):(\d+(\.\d+)?)(Z|([+-])(\d\d):?(\d\d))?$/),n?(new Date(parseInt(n[1],10),parseInt(n[2],10)*3-1,1)).getTime():i?(new Date(parseInt(i[1],10),parseInt(i[2],10)-1,1)).getTime():s?(new Date(parseInt(s[1],10),parseInt(s[2],10)-1,parseInt(s[3],10))).getTime():u?(l=new Date(parseInt(u[1],10),0,1),l.getDay()!==4&&l.setMonth(0,1+(4-l.getDay()+7)%7),l.getTime()+parseInt(u[2],10)*6048e5):a?a[6]?(o=0,a[6]!=="Z"&&(o=parseInt(a[8],10)*60+parseInt(a[9],10),a[7]==="+"&&(o=0-o)),Date.UTC(parseInt(a[1],10),parseInt(a[2],10)-1,parseInt(a[3],10),parseInt(a[4],10),parseInt(a[5],10)+o)):(new Date(parseInt(a[1],10),parseInt(a[2],10)-1,parseInt(a[3],10),parseInt(a[4],10),parseInt(a[5],10))).getTime():f?(c=parseFloat(f[6]),t=Math.floor(c),r=Math.round((c-t)*1e3),f[8]?(o=0,f[8]!=="Z"&&(o=parseInt(f[10],10)*60+parseInt(f[11],10),f[9]==="+"&&(o=0-o)),Date.UTC(parseInt(f[1],10),parseInt(f[2],10)-1,parseInt(f[3],10),parseInt(f[4],10),parseInt(f[5],10)+o,t,r)):(new Date(parseInt(f[1],10),parseInt(f[2],10)-1,parseInt(f[3],10),parseInt(f[4],10),parseInt(f[5],10),t,r)).getTime()):(new Date(parseInt(e,10),0,1)).getTime())},t.Hover=function(){function n(n){n==null&&(n={}),this.options=e.extend({},t.Hover.defaults,n),this.el=e("<div class='"+this.options["class"]+"'></div>"),this.el.hide(),this.options.parent.append(this.el)}return n.defaults={"class":"morris-hover morris-default-style"},n.prototype.update=function(e,t,n){return this.html(e),this.show(),this.moveTo(t,n)},n.prototype.html=function(e){return this.el.html(e)},n.prototype.moveTo=function(e,t){var n,r,i,s,o,u;return o=this.options.parent.innerWidth(),s=this.options.parent.innerHeight(),r=this.el.outerWidth(),n=this.el.outerHeight(),i=Math.min(Math.max(0,e-r/2),o-r),t!=null?(u=t-n-10,u<0&&(u=t+10,u+n>s&&(u=s/2-n/2))):u=s/2-n/2,this.el.css({left:i+"px",top:parseInt(u)+"px"})},n.prototype.show=function(){return this.el.show()},n.prototype.hide=function(){return this.el.hide()},n}(),t.Line=function(e){function n(e){this.hilight=u(this.hilight,this),this.onHoverOut=u(this.onHoverOut,this),this.onHoverMove=u(this.onHoverMove,this),this.onGridClick=u(this.onGridClick,this);if(!(this instanceof t.Line))return new t.Line(e);n.__super__.constructor.call(this,e)}return o(n,e),n.prototype.init=function(){this.pointGrow=Raphael.animation({r:this.options.pointSize+3},25,"linear"),this.pointShrink=Raphael.animation({r:this.options.pointSize},25,"linear");if(this.options.hideHover!=="always")return this.hover=new t.Hover({parent:this.el}),this.on("hovermove",this.onHoverMove),this.on("hoverout",this.onHoverOut),this.on("gridclick",this.onGridClick)},n.prototype.defaults={lineWidth:3,pointSize:4,lineColors:["#0b62a4","#7A92A3","#4da74d","#afd8f8","#edc240","#cb4b4b","#9440ed"],pointWidths:[1],pointStrokeColors:["#ffffff"],pointFillColors:[],smooth:!0,xLabels:"auto",xLabelFormat:null,xLabelMargin:24,continuousLine:!0,hideHover:!1},n.prototype.calc=function(){return this.calcPoints(),this.generatePaths()},n.prototype.calcPoints=function(){var e,t,n,r,i,s;i=this.data,s=[];for(n=0,r=i.length;n<r;n++)e=i[n],e._x=this.transX(e.x),e._y=function(){var n,r,i,s;i=e.y,s=[];for(n=0,r=i.length;n<r;n++)t=i[n],t!=null?s.push(this.transY(t)):s.push(t);return s}.call(this),s.push(e._ymax=Math.min.apply(null,[this.bottom].concat(function(){var n,r,i,s;i=e._y,s=[];for(n=0,r=i.length;n<r;n++)t=i[n],t!=null&&s.push(t);return s}())));return s},n.prototype.hitTest=function(e,t){var n,r,i,s,o;if(this.data.length===0)return null;o=this.data.slice(1);for(n=i=0,s=o.length;i<s;n=++i){r=o[n];if(e<(r._x+this.data[n]._x)/2)break}return n},n.prototype.onGridClick=function(e,t){var n;return n=this.hitTest(e,t),this.fire("click",n,this.options.data[n],e,t)},n.prototype.onHoverMove=function(e,t){var n;return n=this.hitTest(e,t),this.displayHoverForRow(n)},n.prototype.onHoverOut=function(){if(this.options.hideHover!==!1)return this.displayHoverForRow(null)},n.prototype.displayHoverForRow=function(e){var t;return e!=null?((t=this.hover).update.apply(t,this.hoverContentForRow(e)),this.hilight(e)):(this.hover.hide(),this.hilight())},n.prototype.hoverContentForRow=function(e){var t,n,r,i,s,o,u;r=this.data[e],t="<div class='morris-hover-row-label'>"+r.label+"</div>",u=r.y;for(n=s=0,o=u.length;s<o;n=++s)i=u[n],t+="<div class='morris-hover-point' style='color: "+this.colorFor(r,n,"label")+"'>\n  "+this.options.labels[n]+":\n  "+this.yLabelFormat(i)+"\n</div>";return typeof this.options.hoverCallback=="function"&&(t=this.options.hoverCallback(e,this.options,t)),[t,r._x,r._ymax]},n.prototype.generatePaths=function(){var e,n,r,i,s;return this.paths=function(){var o,u,f,l;l=[];for(r=o=0,u=this.options.ykeys.length;0<=u?o<u:o>u;r=0<=u?++o:--o)s=this.options.smooth===!0||(f=this.options.ykeys[r],a.call(this.options.smooth,f)>=0),n=function(){var e,t,n,s;n=this.data,s=[];for(e=0,t=n.length;e<t;e++)i=n[e],i._y[r]!==void 0&&s.push({x:i._x,y:i._y[r]});return s}.call(this),this.options.continuousLine&&(n=function(){var t,r,i;i=[];for(t=0,r=n.length;t<r;t++)e=n[t],e.y!==null&&i.push(e);return i}()),n.length>1?l.push(t.Line.createPath(n,s,this.bottom)):l.push(null);return l}.call(this)},n.prototype.draw=function(){this.options.axes&&this.drawXAxis(),this.drawSeries();if(this.options.hideHover===!1)return this.displayHoverForRow(this.data.length-1)},n.prototype.drawXAxis=function(){var e,n,r,i,s,o,u,a,f,l,c=this;u=this.bottom+this.options.padding/2,s=null,i=null,e=function(e,t){var n,r,o,a,f;return n=c.drawXAxisLabel(c.transX(t),u,e),f=n.getBBox(),n.transform("r"+ -c.options.xLabelAngle),r=n.getBBox(),n.transform("t0,"+r.height/2+"..."),c.options.xLabelAngle!==0&&(a=-0.5*f.width*Math.cos(c.options.xLabelAngle*Math.PI/180),n.transform("t"+a+",0...")),r=n.getBBox(),(s==null||s>=r.x+r.width||i!=null&&i>=r.x)&&r.x>=0&&r.x+r.width<c.el.width()?(c.options.xLabelAngle!==0&&(o=1.25*c.options.gridTextSize/Math.sin(c.options.xLabelAngle*Math.PI/180),i=r.x-o),s=r.x-c.options.xLabelMargin):n.remove()},this.options.parseTime?this.data.length===1&&this.options.xLabels==="auto"?r=[[this.data[0].label,this.data[0].x]]:r=t.labelSeries(this.xmin,this.xmax,this.width,this.options.xLabels,this.options.xLabelFormat):r=function(){var e,t,n,r;n=this.data,r=[];for(e=0,t=n.length;e<t;e++)o=n[e],r.push([o.label,o.x]);return r}.call(this),r.reverse(),l=[];for(a=0,f=r.length;a<f;a++)n=r[a],l.push(e(n[0],n[1]));return l},n.prototype.drawSeries=function(){var e,t,n,r,i,s;this.seriesPoints=[];for(e=t=r=this.options.ykeys.length-1;r<=0?t<=0:t>=0;e=r<=0?++t:--t)this._drawLineFor(e);s=[];for(e=n=i=this.options.ykeys.length-1;i<=0?n<=0:n>=0;e=i<=0?++n:--n)s.push(this._drawPointFor(e));return s},n.prototype._drawPointFor=function(e){var t,n,r,i,s,o;this.seriesPoints[e]=[],s=this.data,o=[];for(r=0,i=s.length;r<i;r++)n=s[r],t=null,n._y[e]!=null&&(t=this.drawLinePoint(n._x,n._y[e],this.options.pointSize,this.colorFor(n,e,"point"),e)),o.push(this.seriesPoints[e].push(t));return o},n.prototype._drawLineFor=function(e){var t;t=this.paths[e];if(t!==null)return this.drawLinePath(t,this.colorFor(null,e,"line"))},n.createPath=function(e,n,r){var i,s,o,u,a,f,l,c,h,p,d,v,m,g;l="",n&&(o=t.Line.gradients(e)),c={y:null};for(u=m=0,g=e.length;m<g;u=++m){i=e[u];if(i.y!=null)if(c.y!=null)n?(s=o[u],f=o[u-1],a=(i.x-c.x)/4,h=c.x+a,d=Math.min(r,c.y+a*f),p=i.x-a,v=Math.min(r,i.y-a*s),l+="C"+h+","+d+","+p+","+v+","+i.x+","+i.y):l+="L"+i.x+","+i.y;else if(!n||o[u]!=null)l+="M"+i.x+","+i.y;c=i}return l},n.gradients=function(e){var t,n,r,i,s,o,u,a;n=function(e,t){return(e.y-t.y)/(e.x-t.x)},a=[];for(r=o=0,u=e.length;o<u;r=++o)t=e[r],t.y!=null?(i=e[r+1]||{y:null},s=e[r-1]||{y:null},s.y!=null&&i.y!=null?a.push(n(s,i)):s.y!=null?a.push(n(s,t)):i.y!=null?a.push(n(t,i)):a.push(null)):a.push(null);return a},n.prototype.hilight=function(e){var t,n,r,i,s;if(this.prevHilight!==null&&this.prevHilight!==e)for(t=n=0,i=this.seriesPoints.length-1;0<=i?n<=i:n>=i;t=0<=i?++n:--n)this.seriesPoints[t][this.prevHilight]&&this.seriesPoints[t][this.prevHilight].animate(this.pointShrink);if(e!==null&&this.prevHilight!==e)for(t=r=0,s=this.seriesPoints.length-1;0<=s?r<=s:r>=s;t=0<=s?++r:--r)this.seriesPoints[t][e]&&this.seriesPoints[t][e].animate(this.pointGrow);return this.prevHilight=e},n.prototype.colorFor=function(e,t,n){return typeof this.options.lineColors=="function"?this.options.lineColors.call(this,e,t,n):n==="point"?this.options.pointFillColors[t%this.options.pointFillColors.length]||this.options.lineColors[t%this.options.lineColors.length]:this.options.lineColors[t%this.options.lineColors.length]},n.prototype.drawXAxisLabel=function(e,t,n){return this.raphael.text(e,t,n).attr("font-size",this.options.gridTextSize).attr("font-family",this.options.gridTextFamily).attr("font-weight",this.options.gridTextWeight).attr("fill",this.options.gridTextColor)},n.prototype.drawLinePath=function(e,t){return this.raphael.path(e).attr("stroke",t).attr("stroke-width",this.options.lineWidth)},n.prototype.drawLinePoint=function(e,t,n,r,i){return this.raphael.circle(e,t,n).attr("fill",r).attr("stroke-width",this.strokeWidthForSeries(i)).attr("stroke",this.strokeForSeries(i))},n.prototype.strokeWidthForSeries=function(e){return this.options.pointWidths[e%this.options.pointWidths.length]},n.prototype.strokeForSeries=function(e){return this.options.pointStrokeColors[e%this.options.pointStrokeColors.length]},n}(t.Grid),t.labelSeries=function(n,r,i,s,o){var u,a,f,l,c,h,p,d,v,m,g;f=200*(r-n)/i,a=new Date(n),p=t.LABEL_SPECS[s];if(p===void 0){g=t.AUTO_LABEL_ORDER;for(v=0,m=g.length;v<m;v++){l=g[v],h=t.LABEL_SPECS[l];if(f>=h.span){p=h;break}}}p===void 0&&(p=t.LABEL_SPECS.second),o&&(p=e.extend({},p,{fmt:o})),u=p.start(a),c=[];while((d=u.getTime())<=r)d>=n&&c.push([p.fmt(u),d]),p.incr(u);return c},n=function(e){return{span:e*60*1e3,start:function(e){return new Date(e.getFullYear(),e.getMonth(),e.getDate(),e.getHours())},fmt:function(e){return""+t.pad2(e.getHours())+":"+t.pad2(e.getMinutes())},incr:function(t){return t.setUTCMinutes(t.getUTCMinutes()+e)}}},r=function(e){return{span:e*1e3,start:function(e){return new Date(e.getFullYear(),e.getMonth(),e.getDate(),e.getHours(),e.getMinutes())},fmt:function(e){return""+t.pad2(e.getHours())+":"+t.pad2(e.getMinutes())+":"+t.pad2(e.getSeconds())},incr:function(t){return t.setUTCSeconds(t.getUTCSeconds()+e)}}},t.LABEL_SPECS={decade:{span:1728e8,start:function(e){return new Date(e.getFullYear()-e.getFullYear()%10,0,1)},fmt:function(e){return""+e.getFullYear()},incr:function(e){return e.setFullYear(e.getFullYear()+10)}},year:{span:1728e7,start:function(e){return new Date(e.getFullYear(),0,1)},fmt:function(e){return""+e.getFullYear()},incr:function(e){return e.setFullYear(e.getFullYear()+1)}},month:{span:24192e5,start:function(e){return new Date(e.getFullYear(),e.getMonth(),1)},fmt:function(e){return""+e.getFullYear()+"-"+t.pad2(e.getMonth()+1)},incr:function(e){return e.setMonth(e.getMonth()+1)}},day:{span:864e5,start:function(e){return new Date(e.getFullYear(),e.getMonth(),e.getDate())},fmt:function(e){return""+e.getFullYear()+"-"+t.pad2(e.getMonth()+1)+"-"+t.pad2(e.getDate())},incr:function(e){return e.setDate(e.getDate()+1)}},hour:n(60),"30min":n(30),"15min":n(15),"10min":n(10),"5min":n(5),minute:n(1),"30sec":r(30),"15sec":r(15),"10sec":r(10),"5sec":r(5),second:r(1)},t.AUTO_LABEL_ORDER=["decade","year","month","day","hour","30min","15min","10min","5min","minute","30sec","15sec","10sec","5sec","second"],t.Area=function(n){function i(n){var s;if(!(this instanceof t.Area))return new t.Area(n);s=e.extend({},r,n),this.cumulative=!s.behaveLikeLine,s.fillOpacity==="auto"&&(s.fillOpacity=s.behaveLikeLine?.8:1),i.__super__.constructor.call(this,s)}var r;return o(i,n),r={fillOpacity:"auto",behaveLikeLine:!1},i.prototype.calcPoints=function(){var e,t,n,r,i,s,o;s=this.data,o=[];for(r=0,i=s.length;r<i;r++)e=s[r],e._x=this.transX(e.x),t=0,e._y=function(){var r,i,s,o;s=e.y,o=[];for(r=0,i=s.length;r<i;r++)n=s[r],this.options.behaveLikeLine?o.push(this.transY(n)):(t+=n||0,o.push(this.transY(t)));return o}.call(this),o.push(e._ymax=Math.max.apply(Math,e._y));return o},i.prototype.drawSeries=function(){var e,t,n,r,i,s,o,u,a,f,l;this.seriesPoints=[],this.options.behaveLikeLine?t=function(){a=[];for(var e=0,t=this.options.ykeys.length-1;0<=t?e<=t:e>=t;0<=t?e++:e--)a.push(e);return a}.apply(this):t=function(){f=[];for(var e=u=this.options.ykeys.length-1;u<=0?e<=0:e>=0;u<=0?e++:e--)f.push(e);return f}.apply(this),l=[];for(i=0,s=t.length;i<s;i++)e=t[i],this._drawFillFor(e),this._drawLineFor(e),l.push(this._drawPointFor(e));return l},i.prototype._drawFillFor=function(e){var t;t=this.paths[e];if(t!==null)return t+="L"+this.transX(this.xmax)+","+this.bottom+"L"+this.transX(this.xmin)+","+this.bottom+"Z",this.drawFilledPath(t,this.fillForSeries(e))},i.prototype.fillForSeries=function(e){var t;return t=Raphael.rgb2hsl(this.colorFor(this.data[e],e,"line")),Raphael.hsl(t.h,this.options.behaveLikeLine?t.s*.9:t.s*.75,Math.min(.98,this.options.behaveLikeLine?t.l*1.2:t.l*1.25))},i.prototype.drawFilledPath=function(e,t){return this.raphael.path(e).attr("fill",t).attr("fill-opacity",this.options.fillOpacity).attr("stroke-width",0)},i}(t.Line),t.Bar=function(n){function r(n){this.onHoverOut=u(this.onHoverOut,this),this.onHoverMove=u(this.onHoverMove,this),this.onGridClick=u(this.onGridClick,this);if(!(this instanceof t.Bar))return new t.Bar(n);r.__super__.constructor.call(this,e.extend({},n,{parseTime:!1}))}return o(r,n),r.prototype.init=function(){this.cumulative=this.options.stacked;if(this.options.hideHover!=="always")return this.hover=new t.Hover({parent:this.el}),this.on("hovermove",this.onHoverMove),this.on("hoverout",this.onHoverOut),this.on("gridclick",this.onGridClick)},r.prototype.defaults={barSizeRatio:.75,barGap:3,barColors:["#0b62a4","#7a92a3","#4da74d","#afd8f8","#edc240","#cb4b4b","#9440ed"],xLabelMargin:50},r.prototype.calc=function(){var e;this.calcBars();if(this.options.hideHover===!1)return(e=this.hover).update.apply(e,this.hoverContentForRow(this.data.length-1))},r.prototype.calcBars=function(){var e,t,n,r,i,s,o;s=this.data,o=[];for(e=r=0,i=s.length;r<i;e=++r)t=s[e],t._x=this.left+this.width*(e+.5)/this.data.length,o.push(t._y=function(){var e,r,i,s;i=t.y,s=[];for(e=0,r=i.length;e<r;e++)n=i[e],n!=null?s.push(this.transY(n)):s.push(null);return s}.call(this));return o},r.prototype.draw=function(){return this.options.axes&&this.drawXAxis(),this.drawSeries()},r.prototype.drawXAxis=function(){var e,t,n,r,i,s,o,u,a,f,l,c,h;f=this.bottom+this.options.padding/2,o=null,s=null,h=[];for(e=l=0,c=this.data.length;0<=c?l<c:l>c;e=0<=c?++l:--l)u=this.data[this.data.length-1-e],t=this.drawXAxisLabel(u._x,f,u.label),a=t.getBBox(),t.transform("r"+ -this.options.xLabelAngle),n=t.getBBox(),t.transform("t0,"+n.height/2+"..."),this.options.xLabelAngle!==0&&(i=-0.5*a.width*Math.cos(this.options.xLabelAngle*Math.PI/180),t.transform("t"+i+",0...")),(o==null||o>=n.x+n.width||s!=null&&s>=n.x)&&n.x>=0&&n.x+n.width<this.el.width()?(this.options.xLabelAngle!==0&&(r=1.25*this.options.gridTextSize/Math.sin(this.options.xLabelAngle*Math.PI/180),s=n.x-r),h.push(o=n.x-this.options.xLabelMargin)):h.push(t.remove());return h},r.prototype.drawSeries=function(){var e,t,n,r,i,s,o,u,a,f,l,c,h,p;return n=this.width/this.options.data.length,u=this.options.stacked!=null?1:this.options.ykeys.length,e=(n*this.options.barSizeRatio-this.options.barGap*(u-1))/u,o=n*(1-this.options.barSizeRatio)/2,p=this.ymin<=0&&this.ymax>=0?this.transY(0):null,this.bars=function(){var u,d,v,m;v=this.data,m=[];for(r=u=0,d=v.length;u<d;r=++u)a=v[r],i=0,m.push(function(){var u,d,v,m;v=a._y,m=[];for(f=u=0,d=v.length;u<d;f=++u)h=v[f],h!==null?(p?(c=Math.min(h,p),t=Math.max(h,p)):(c=h,t=this.bottom),s=this.left+r*n+o,this.options.stacked||(s+=f*(e+this.options.barGap)),l=t-c,this.options.stacked&&(c-=i),this.drawBar(s,c,e,l,this.colorFor(a,f,"bar")),m.push(i+=l)):m.push(null);return m}.call(this));return m}.call(this)},r.prototype.colorFor=function(e,t,n){var r,i;return typeof this.options.barColors=="function"?(r={x:e.x,y:e.y[t],label:e.label},i={index:t,key:this.options.ykeys[t],label:this.options.labels[t]},this.options.barColors.call(this,r,i,n)):this.options.barColors[t%this.options.barColors.length]},r.prototype.hitTest=function(e,t){return this.data.length===0?null:(e=Math.max(Math.min(e,this.right),this.left),Math.min(this.data.length-1,Math.floor((e-this.left)/(this.width/this.data.length))))},r.prototype.onGridClick=function(e,t){var n;return n=this.hitTest(e,t),this.fire("click",n,this.options.data[n],e,t)},r.prototype.onHoverMove=function(e,t){var n,r;return n=this.hitTest(e,t),(r=this.hover).update.apply(r,this.hoverContentForRow(n))},r.prototype.onHoverOut=function(){if(this.options.hideHover!==!1)return this.hover.hide()},r.prototype.hoverContentForRow=function(e){var t,n,r,i,s,o,u,a;r=this.data[e],t="<div class='morris-hover-row-label'>"+r.label+"</div>",a=r.y;for(n=o=0,u=a.length;o<u;n=++o)s=a[n],t+="<div class='morris-hover-point' style='color: "+this.colorFor(r,n,"label")+"'>\n  "+this.options.labels[n]+":\n  "+this.yLabelFormat(s)+"\n</div>";return typeof this.options.hoverCallback=="function"&&(t=this.options.hoverCallback(e,this.options,t)),i=this.left+(e+.5)*this.width/this.data.length,[t,i]},r.prototype.drawXAxisLabel=function(e,t,n){var r;return r=this.raphael.text(e,t,n).attr("font-size",this.options.gridTextSize).attr("font-family",this.options.gridTextFamily).attr("font-weight",this.options.gridTextWeight).attr("fill",this.options.gridTextColor)},r.prototype.drawBar=function(e,t,n,r,i){return this.raphael.rect(e,t,n,r).attr("fill",i).attr("stroke-width",0)},r}(t.Grid),t.Donut=function(n){function r(n){this.select=u(this.select,this),this.click=u(this.click,this);var r;if(!(this instanceof t.Donut))return new t.Donut(n);typeof n.element=="string"?this.el=e(document.getElementById(n.element)):this.el=e(n.element),this.options=e.extend({},this.defaults,n);if(this.el===null||this.el.length===0)throw new Error("Graph placeholder not found.");if(n.data===void 0||n.data.length===0)return;this.data=n.data,this.values=function(){var e,t,n,i;n=this.data,i=[];for(e=0,t=n.length;e<t;e++)r=n[e],i.push(parseFloat(r.value));return i}.call(this),this.redraw()}return o(r,n),r.prototype.defaults={colors:["#0B62A4","#3980B5","#679DC6","#95BBD7","#B0CCE1","#095791","#095085","#083E67","#052C48","#042135"],backgroundColor:"#FFFFFF",labelColor:"#000000",formatter:t.commas},r.prototype.redraw=function(){var e,n,r,i,s,o,u,a,f,l,c,h,p,d,v,m,g,y,b,w,E,S,x;this.el.empty(),this.raphael=new Raphael(this.el[0]),n=this.el.width()/2,r=this.el.height()/2,p=(Math.min(n,r)-10)/3,c=0,w=this.values;for(d=0,g=w.length;d<g;d++)h=w[d],c+=h;a=5/(2*p),e=1.9999*Math.PI-a*this.data.length,o=0,s=0,this.segments=[],E=this.values;for(i=v=0,y=E.length;v<y;i=++v)h=E[i],f=o+a+e*(h/c),l=new t.DonutSegment(n,r,p*2,p,o,f,this.options.colors[s%this.options.colors.length],this.options.backgroundColor,s,this.raphael),l.render(),this.segments.push(l),l.on("hover",this.select),l.on("click",this.click),o=f,s+=1;this.text1=this.drawEmptyDonutLabel(n,r-10,this.options.labelColor,15,800),this.text2=this.drawEmptyDonutLabel(n,r+10,this.options.labelColor,14),u=Math.max.apply(null,function(){var e,t,n,r;n=this.values,r=[];for(e=0,t=n.length;e<t;e++)h=n[e],r.push(h);return r}.call(this)),s=0,S=this.values,x=[];for(m=0,b=S.length;m<b;m++){h=S[m];if(h===u){this.select(s);break}x.push(s+=1)}return x},r.prototype.click=function(e){return this.fire("click",e,this.data[e])},r.prototype.select=function(e){var t,n,r,i,s,o;o=this.segments;for(i=0,s=o.length;i<s;i++)n=o[i],n.deselect();return r=this.segments[e],r.select(),t=this.data[e],this.setLabels(t.label,this.options.formatter(t.value,t))},r.prototype.setLabels=function(e,t){var n,r,i,s,o,u,a,f;return n=(Math.min(this.el.width()/2,this.el.height()/2)-10)*2/3,s=1.8*n,i=n/2,r=n/3,this.text1.attr({text:e,transform:""}),o=this.text1.getBBox(),u=Math.min(s/o.width,i/o.height),this.text1.attr({transform:"S"+u+","+u+","+(o.x+o.width/2)+","+(o.y+o.height)}),this.text2.attr({text:t,transform:""}),a=this.text2.getBBox(),f=Math.min(s/a.width,r/a.height),this.text2.attr({transform:"S"+f+","+f+","+(a.x+a.width/2)+","+a.y})},r.prototype.drawEmptyDonutLabel=function(e,t,n,r,i){var s;return s=this.raphael.text(e,t,"").attr("font-size",r).attr("fill",n),i!=null&&s.attr("font-weight",i),s},r}(t.EventEmitter),t.DonutSegment=function(e){function t(e,t,n,r,i,s,o,a,f,l){this.cx=e,this.cy=t,this.inner=n,this.outer=r,this.color=o,this.backgroundColor=a,this.index=f,this.raphael=l,this.deselect=u(this.deselect,this),this.select=u(this.select,this),this.sin_p0=Math.sin(i),this.cos_p0=Math.cos(i),this.sin_p1=Math.sin(s),this.cos_p1=Math.cos(s),this.is_long=s-i>Math.PI?1:0,this.path=this.calcSegment(this.inner+3,this.inner+this.outer-5),this.selectedPath=this.calcSegment(this.inner+3,this.inner+this.outer),this.hilight=this.calcArc(this.inner)}return o(t,e),t.prototype.calcArcPoints=function(e){return[this.cx+e*this.sin_p0,this.cy+e*this.cos_p0,this.cx+e*this.sin_p1,this.cy+e*this.cos_p1]},t.prototype.calcSegment=function(e,t){var n,r,i,s,o,u,a,f,l,c;return l=this.calcArcPoints(e),n=l[0],i=l[1],r=l[2],s=l[3],c=this.calcArcPoints(t),o=c[0],a=c[1],u=c[2],f=c[3],"M"+n+","+i+("A"+e+","+e+",0,"+this.is_long+",0,"+r+","+s)+("L"+u+","+f)+("A"+t+","+t+",0,"+this.is_long+",1,"+o+","+a)+"Z"},t.prototype.calcArc=function(e){var t,n,r,i,s;return s=this.calcArcPoints(e),t=s[0],r=s[1],n=s[2],i=s[3],"M"+t+","+r+("A"+e+","+e+",0,"+this.is_long+",0,"+n+","+i)},t.prototype.render=function(){var e=this;return this.arc=this.drawDonutArc(this.hilight,this.color),this.seg=this.drawDonutSegment(this.path,this.color,this.backgroundColor,function(){return e.fire("hover",e.index)},function(){return e.fire("click",e.index)})},t.prototype.drawDonutArc=function(e,t){return this.raphael.path(e).attr({stroke:t,"stroke-width":2,opacity:0})},t.prototype.drawDonutSegment=function(e,t,n,r,i){return this.raphael.path(e).attr({fill:t,stroke:n,"stroke-width":3}).hover(r).click(i)},t.prototype.select=function(){if(!this.selected)return this.seg.animate({path:this.selectedPath},150,"<>"),this.arc.animate({opacity:1},150,"<>"),this.selected=!0},t.prototype.deselect=function(){if(this.selected)return this.seg.animate({path:this.path},150,"<>"),this.arc.animate({opacity:0},150,"<>"),this.selected=!1},t}(t.EventEmitter)}).call(this);

(function () {
  var elem = document.createElement('canvas');
  if (elem.getContext && elem.getContext('2d')) {
    /*
* EaselJS
* Visit http://createjs.com/ for documentation, updates and examples.
*
* Copyright (c) 2011 gskinner.com, inc.
* 
* Distributed under the terms of the MIT license.
* http://www.opensource.org/licenses/mit-license.html
*
* This notice shall be included in all copies or substantial portions of the Software.
*/
this.createjs=this.createjs||{};(function(){var c=function(){throw"UID cannot be instantiated";};c._nextID=0;c.get=function(){return c._nextID++};createjs.UID=c})();this.createjs=this.createjs||{};
(function(){var c=function(){this.initialize()},b=c.prototype;c.initialize=function(a){a.addEventListener=b.addEventListener;a.removeEventListener=b.removeEventListener;a.removeAllEventListeners=b.removeAllEventListeners;a.hasEventListener=b.hasEventListener;a.dispatchEvent=b.dispatchEvent};b._listeners=null;b.initialize=function(){};b.addEventListener=function(a,m){var b=this._listeners;b?this.removeEventListener(a,m):b=this._listeners={};var d=b[a];d||(d=b[a]=[]);d.push(m);return m};b.removeEventListener=
function(a,m){var b=this._listeners;if(b){var d=b[a];if(d)for(var e=0,c=d.length;e<c;e++)if(d[e]==m){1==c?delete b[a]:d.splice(e,1);break}}};b.removeAllEventListeners=function(a){a?this._listeners&&delete this._listeners[a]:this._listeners=null};b.dispatchEvent=function(a,m){var b=!1,d=this._listeners;if(a&&d){"string"==typeof a&&(a={type:a});d=d[a.type];if(!d)return b;a.target=m||this;for(var d=d.slice(),e=0,c=d.length;e<c;e++)var h=d[e],b=h.handleEvent?b||h.handleEvent(a):b||h(a)}return!!b};b.hasEventListener=
function(a){var m=this._listeners;return!(!m||!m[a])};b.toString=function(){return"[EventDispatcher]"};createjs.EventDispatcher=c})();this.createjs=this.createjs||{};
(function(){var c=function(){throw"Ticker cannot be instantiated.";};c.useRAF=!1;c.addEventListener=null;c.removeEventListener=null;c.removeAllEventListeners=null;c.dispatchEvent=null;c.hasEventListener=null;c._listeners=null;createjs.EventDispatcher.initialize(c);c._listeners=null;c._pauseable=null;c._paused=!1;c._inited=!1;c._startTime=0;c._pausedTime=0;c._ticks=0;c._pausedTicks=0;c._interval=50;c._lastTime=0;c._times=null;c._tickTimes=null;c._rafActive=!1;c._timeoutID=null;c.addListener=function(a,
m){null!=a&&(c.removeListener(a),c._pauseable[c._listeners.length]=null==m?!0:m,c._listeners.push(a))};c.init=function(){c._inited=!0;c._times=[];c._tickTimes=[];c._pauseable=[];c._listeners=[];c._times.push(c._lastTime=c._startTime=c._getTime());c.setInterval(c._interval)};c.removeListener=function(a){var m=c._listeners;m&&(a=m.indexOf(a),-1!=a&&(m.splice(a,1),c._pauseable.splice(a,1)))};c.removeAllListeners=function(){c._listeners=[];c._pauseable=[]};c.setInterval=function(a){c._interval=a;c._inited&&
c._setupTick()};c.getInterval=function(){return c._interval};c.setFPS=function(a){c.setInterval(1E3/a)};c.getFPS=function(){return 1E3/c._interval};c.getMeasuredFPS=function(a){if(2>c._times.length)return-1;null==a&&(a=c.getFPS()|0);a=Math.min(c._times.length-1,a);return 1E3/((c._times[0]-c._times[a])/a)};c.setPaused=function(a){c._paused=a};c.getPaused=function(){return c._paused};c.getTime=function(a){return c._getTime()-c._startTime-(a?c._pausedTime:0)};c.getTicks=function(a){return c._ticks-(a?
c._pausedTicks:0)};c._handleAF=function(){c._rafActive=!1;c._setupTick();c._getTime()-c._lastTime>=0.97*(c._interval-1)&&c._tick()};c._handleTimeout=function(){c.timeoutID=null;c._setupTick();c._tick()};c._setupTick=function(){if(!(c._rafActive||null!=c.timeoutID)){if(c.useRAF){var a=window.requestAnimationFrame||window.webkitRequestAnimationFrame||window.mozRequestAnimationFrame||window.oRequestAnimationFrame||window.msRequestAnimationFrame;if(a){a(c._handleAF);c._rafActive=!0;return}}c.timeoutID=
setTimeout(c._handleTimeout,c._interval)}};c._tick=function(){var a=c._getTime();c._ticks++;var m=a-c._lastTime,b=c._paused;b&&(c._pausedTicks++,c._pausedTime+=m);c._lastTime=a;for(var d=c._pauseable,e=c._listeners.slice(),f=e?e.length:0,h=0;h<f;h++){var k=e[h];null==k||b&&d[h]||(k.tick?k.tick(m,b):k instanceof Function&&k(m,b))}c.dispatchEvent({type:"tick",paused:b,delta:m,time:a,runTime:a-c._pausedTime});for(c._tickTimes.unshift(c._getTime()-a);100<c._tickTimes.length;)c._tickTimes.pop();for(c._times.unshift(a);100<
c._times.length;)c._times.pop()};var b=window.performance&&(performance.now||performance.mozNow||performance.msNow||performance.oNow||performance.webkitNow);c._getTime=function(){return b&&b.call(performance)||(new Date).getTime()};c.init();createjs.Ticker=c})();this.createjs=this.createjs||{};
(function(){var c=function(a,m,b,d,e,c,h,k,j){this.initialize(a,m,b,d,e,c,h,k,j)},b=c.prototype;b.stageX=0;b.stageY=0;b.rawX=0;b.rawY=0;b.type=null;b.nativeEvent=null;b.onMouseMove=null;b.onMouseUp=null;b.target=null;b.pointerID=0;b.primary=!1;b.addEventListener=null;b.removeEventListener=null;b.removeAllEventListeners=null;b.dispatchEvent=null;b.hasEventListener=null;b._listeners=null;createjs.EventDispatcher.initialize(b);b.initialize=function(a,m,b,d,e,c,h,k,j){this.type=a;this.stageX=m;this.stageY=
b;this.target=d;this.nativeEvent=e;this.pointerID=c;this.primary=h;this.rawX=null==k?m:k;this.rawY=null==j?b:j};b.clone=function(){return new c(this.type,this.stageX,this.stageY,this.target,this.nativeEvent,this.pointerID,this.primary,this.rawX,this.rawY)};b.toString=function(){return"[MouseEvent (type="+this.type+" stageX="+this.stageX+" stageY="+this.stageY+")]"};createjs.MouseEvent=c})();this.createjs=this.createjs||{};
(function(){var c=function(a,m,b,d,c,f){this.initialize(a,m,b,d,c,f)},b=c.prototype;c.identity=null;c.DEG_TO_RAD=Math.PI/180;b.a=1;b.b=0;b.c=0;b.d=1;b.tx=0;b.ty=0;b.alpha=1;b.shadow=null;b.compositeOperation=null;b.initialize=function(a,m,b,d,c,f){null!=a&&(this.a=a);this.b=m||0;this.c=b||0;null!=d&&(this.d=d);this.tx=c||0;this.ty=f||0;return this};b.prepend=function(a,b,g,d,c,f){var h=this.tx;if(1!=a||0!=b||0!=g||1!=d){var k=this.a,j=this.c;this.a=k*a+this.b*g;this.b=k*b+this.b*d;this.c=j*a+this.d*
g;this.d=j*b+this.d*d}this.tx=h*a+this.ty*g+c;this.ty=h*b+this.ty*d+f;return this};b.append=function(a,b,g,d,c,f){var h=this.a,k=this.b,j=this.c,l=this.d;this.a=a*h+b*j;this.b=a*k+b*l;this.c=g*h+d*j;this.d=g*k+d*l;this.tx=c*h+f*j+this.tx;this.ty=c*k+f*l+this.ty;return this};b.prependMatrix=function(a){this.prepend(a.a,a.b,a.c,a.d,a.tx,a.ty);this.prependProperties(a.alpha,a.shadow,a.compositeOperation);return this};b.appendMatrix=function(a){this.append(a.a,a.b,a.c,a.d,a.tx,a.ty);this.appendProperties(a.alpha,
a.shadow,a.compositeOperation);return this};b.prependTransform=function(a,b,g,d,e,f,h,k,j){if(e%360){var l=e*c.DEG_TO_RAD;e=Math.cos(l);l=Math.sin(l)}else e=1,l=0;if(k||j)this.tx-=k,this.ty-=j;f||h?(f*=c.DEG_TO_RAD,h*=c.DEG_TO_RAD,this.prepend(e*g,l*g,-l*d,e*d,0,0),this.prepend(Math.cos(h),Math.sin(h),-Math.sin(f),Math.cos(f),a,b)):this.prepend(e*g,l*g,-l*d,e*d,a,b);return this};b.appendTransform=function(a,b,g,d,e,f,h,k,j){if(e%360){var l=e*c.DEG_TO_RAD;e=Math.cos(l);l=Math.sin(l)}else e=1,l=0;f||
h?(f*=c.DEG_TO_RAD,h*=c.DEG_TO_RAD,this.append(Math.cos(h),Math.sin(h),-Math.sin(f),Math.cos(f),a,b),this.append(e*g,l*g,-l*d,e*d,0,0)):this.append(e*g,l*g,-l*d,e*d,a,b);if(k||j)this.tx-=k*this.a+j*this.c,this.ty-=k*this.b+j*this.d;return this};b.rotate=function(a){var b=Math.cos(a);a=Math.sin(a);var g=this.a,d=this.c,c=this.tx;this.a=g*b-this.b*a;this.b=g*a+this.b*b;this.c=d*b-this.d*a;this.d=d*a+this.d*b;this.tx=c*b-this.ty*a;this.ty=c*a+this.ty*b;return this};b.skew=function(a,b){a*=c.DEG_TO_RAD;
b*=c.DEG_TO_RAD;this.append(Math.cos(b),Math.sin(b),-Math.sin(a),Math.cos(a),0,0);return this};b.scale=function(a,b){this.a*=a;this.d*=b;this.c*=a;this.b*=b;return this};b.translate=function(a,b){this.tx+=a;this.ty+=b;return this};b.identity=function(){this.alpha=this.a=this.d=1;this.b=this.c=this.tx=this.ty=0;this.shadow=this.compositeOperation=null;return this};b.invert=function(){var a=this.a,b=this.b,g=this.c,d=this.d,c=this.tx,f=a*d-b*g;this.a=d/f;this.b=-b/f;this.c=-g/f;this.d=a/f;this.tx=(g*
this.ty-d*c)/f;this.ty=-(a*this.ty-b*c)/f;return this};b.isIdentity=function(){return 0==this.tx&&0==this.ty&&1==this.a&&0==this.b&&0==this.c&&1==this.d};b.decompose=function(a){null==a&&(a={});a.x=this.tx;a.y=this.ty;a.scaleX=Math.sqrt(this.a*this.a+this.b*this.b);a.scaleY=Math.sqrt(this.c*this.c+this.d*this.d);var b=Math.atan2(-this.c,this.d),g=Math.atan2(this.b,this.a);b==g?(a.rotation=g/c.DEG_TO_RAD,0>this.a&&0<=this.d&&(a.rotation+=0>=a.rotation?180:-180),a.skewX=a.skewY=0):(a.skewX=b/c.DEG_TO_RAD,
a.skewY=g/c.DEG_TO_RAD);return a};b.reinitialize=function(a,b,g,d,c,f,h,k,j){this.initialize(a,b,g,d,c,f);this.alpha=h||1;this.shadow=k;this.compositeOperation=j;return this};b.appendProperties=function(a,b,g){this.alpha*=a;this.shadow=b||this.shadow;this.compositeOperation=g||this.compositeOperation;return this};b.prependProperties=function(a,b,g){this.alpha*=a;this.shadow=this.shadow||b;this.compositeOperation=this.compositeOperation||g;return this};b.clone=function(){var a=new c(this.a,this.b,
this.c,this.d,this.tx,this.ty);a.shadow=this.shadow;a.alpha=this.alpha;a.compositeOperation=this.compositeOperation;return a};b.toString=function(){return"[Matrix2D (a="+this.a+" b="+this.b+" c="+this.c+" d="+this.d+" tx="+this.tx+" ty="+this.ty+")]"};c.identity=new c(1,0,0,1,0,0);createjs.Matrix2D=c})();this.createjs=this.createjs||{};(function(){var c=function(a,b){this.initialize(a,b)},b=c.prototype;b.x=0;b.y=0;b.initialize=function(a,b){this.x=null==a?0:a;this.y=null==b?0:b};b.clone=function(){return new c(this.x,this.y)};b.toString=function(){return"[Point (x="+this.x+" y="+this.y+")]"};createjs.Point=c})();this.createjs=this.createjs||{};(function(){var c=function(a,b,g,d){this.initialize(a,b,g,d)},b=c.prototype;b.x=0;b.y=0;b.width=0;b.height=0;b.initialize=function(a,b,g,d){this.x=null==a?0:a;this.y=null==b?0:b;this.width=null==g?0:g;this.height=null==d?0:d};b.clone=function(){return new c(this.x,this.y,this.width,this.height)};b.toString=function(){return"[Rectangle (x="+this.x+" y="+this.y+" width="+this.width+" height="+this.height+")]"};createjs.Rectangle=c})();this.createjs=this.createjs||{};
(function(){var c=function(a,b,g,d,c,f,h){this.initialize(a,b,g,d,c,f,h)},b=c.prototype;b.target=null;b.overLabel=null;b.outLabel=null;b.downLabel=null;b.play=!1;b._isPressed=!1;b._isOver=!1;b.initialize=function(a,b,g,d,c,f,h){a.addEventListener&&(this.target=a,a.cursor="pointer",this.overLabel=null==g?"over":g,this.outLabel=null==b?"out":b,this.downLabel=null==d?"down":d,this.play=c,this.setEnabled(!0),this.handleEvent({}),f&&(h&&(f.actionsEnabled=!1,f.gotoAndStop&&f.gotoAndStop(h)),a.hitArea=f))};
b.setEnabled=function(a){var b=this.target;a?(b.addEventListener("mouseover",this),b.addEventListener("mouseout",this),b.addEventListener("mousedown",this)):(b.removeEventListener("mouseover",this),b.removeEventListener("mouseout",this),b.removeEventListener("mousedown",this))};b.toString=function(){return"[ButtonHelper]"};b.handleEvent=function(a){var b=this.target,g=a.type;"mousedown"==g?(a.addEventListener("mouseup",this),this._isPressed=!0,a=this.downLabel):"mouseup"==g?(this._isPressed=!1,a=
this._isOver?this.overLabel:this.outLabel):"mouseover"==g?(this._isOver=!0,a=this._isPressed?this.downLabel:this.overLabel):(this._isOver=!1,a=this._isPressed?this.overLabel:this.outLabel);this.play?b.gotoAndPlay&&b.gotoAndPlay(a):b.gotoAndStop&&b.gotoAndStop(a)};createjs.ButtonHelper=c})();this.createjs=this.createjs||{};(function(){var c=function(a,b,g,d){this.initialize(a,b,g,d)},b=c.prototype;c.identity=null;b.color=null;b.offsetX=0;b.offsetY=0;b.blur=0;b.initialize=function(a,b,g,d){this.color=a;this.offsetX=b;this.offsetY=g;this.blur=d};b.toString=function(){return"[Shadow]"};b.clone=function(){return new c(this.color,this.offsetX,this.offsetY,this.blur)};c.identity=new c("transparent",0,0,0);createjs.Shadow=c})();this.createjs=this.createjs||{};
(function(){var c=function(a){this.initialize(a)},b=c.prototype;b.complete=!0;b.onComplete=null;b.addEventListener=null;b.removeEventListener=null;b.removeAllEventListeners=null;b.dispatchEvent=null;b.hasEventListener=null;b._listeners=null;createjs.EventDispatcher.initialize(b);b._animations=null;b._frames=null;b._images=null;b._data=null;b._loadCount=0;b._frameHeight=0;b._frameWidth=0;b._numFrames=0;b._regX=0;b._regY=0;b.initialize=function(a){var b,g,d;if(null!=a){if(a.images&&0<(g=a.images.length)){d=
this._images=[];for(b=0;b<g;b++){var c=a.images[b];if("string"==typeof c){var f=c,c=new Image;c.src=f}d.push(c);!c.getContext&&!c.complete&&(this._loadCount++,this.complete=!1,function(a){c.onload=function(){a._handleImageLoad()}}(this))}}if(null!=a.frames)if(a.frames instanceof Array){this._frames=[];d=a.frames;b=0;for(g=d.length;b<g;b++)f=d[b],this._frames.push({image:this._images[f[4]?f[4]:0],rect:new createjs.Rectangle(f[0],f[1],f[2],f[3]),regX:f[5]||0,regY:f[6]||0})}else g=a.frames,this._frameWidth=
g.width,this._frameHeight=g.height,this._regX=g.regX||0,this._regY=g.regY||0,this._numFrames=g.count,0==this._loadCount&&this._calculateFrames();if(null!=(g=a.animations)){this._animations=[];this._data={};for(var h in g){a={name:h};f=g[h];if("number"==typeof f)d=a.frames=[f];else if(f instanceof Array)if(1==f.length)a.frames=[f[0]];else{a.frequency=f[3];a.next=f[2];d=a.frames=[];for(b=f[0];b<=f[1];b++)d.push(b)}else a.frequency=f.frequency,a.next=f.next,b=f.frames,d=a.frames="number"==typeof b?[b]:
b.slice(0);a.next=2>d.length||!1==a.next?null:null==a.next||!0==a.next?h:a.next;a.frequency||(a.frequency=1);this._animations.push(h);this._data[h]=a}}}};b.getNumFrames=function(a){if(null==a)return this._frames?this._frames.length:this._numFrames;a=this._data[a];return null==a?0:a.frames.length};b.getAnimations=function(){return this._animations.slice(0)};b.getAnimation=function(a){return this._data[a]};b.getFrame=function(a){var b;return this.complete&&this._frames&&(b=this._frames[a])?b:null};
b.getFrameBounds=function(a){return(a=this.getFrame(a))?new createjs.Rectangle(-a.regX,-a.regY,a.rect.width,a.rect.height):null};b.toString=function(){return"[SpriteSheet]"};b.clone=function(){var a=new c;a.complete=this.complete;a._animations=this._animations;a._frames=this._frames;a._images=this._images;a._data=this._data;a._frameHeight=this._frameHeight;a._frameWidth=this._frameWidth;a._numFrames=this._numFrames;a._loadCount=this._loadCount;return a};b._handleImageLoad=function(){0==--this._loadCount&&
(this._calculateFrames(),this.complete=!0,this.onComplete&&this.onComplete(),this.dispatchEvent("complete"))};b._calculateFrames=function(){if(!(this._frames||0==this._frameWidth)){this._frames=[];for(var a=0,b=this._frameWidth,g=this._frameHeight,d=0,c=this._images;d<c.length;d++){for(var f=c[d],h=(f.width+1)/b|0,k=(f.height+1)/g|0,k=0<this._numFrames?Math.min(this._numFrames-a,h*k):h*k,j=0;j<k;j++)this._frames.push({image:f,rect:new createjs.Rectangle(j%h*b,(j/h|0)*g,b,g),regX:this._regX,regY:this._regY});
a+=k}this._numFrames=a}};createjs.SpriteSheet=c})();this.createjs=this.createjs||{};
(function(){function c(a,b,d){this.f=a;this.params=b;this.path=null==d?!0:d}c.prototype.exec=function(a){this.f.apply(a,this.params)};var b=function(){this.initialize()},a=b.prototype;b.getRGB=function(a,b,d,c){null!=a&&null==d&&(c=b,d=a&255,b=a>>8&255,a=a>>16&255);return null==c?"rgb("+a+","+b+","+d+")":"rgba("+a+","+b+","+d+","+c+")"};b.getHSL=function(a,b,d,c){return null==c?"hsl("+a%360+","+b+"%,"+d+"%)":"hsla("+a%360+","+b+"%,"+d+"%,"+c+")"};b.BASE_64={A:0,B:1,C:2,D:3,E:4,F:5,G:6,H:7,I:8,J:9,
K:10,L:11,M:12,N:13,O:14,P:15,Q:16,R:17,S:18,T:19,U:20,V:21,W:22,X:23,Y:24,Z:25,a:26,b:27,c:28,d:29,e:30,f:31,g:32,h:33,i:34,j:35,k:36,l:37,m:38,n:39,o:40,p:41,q:42,r:43,s:44,t:45,u:46,v:47,w:48,x:49,y:50,z:51,"0":52,1:53,2:54,3:55,4:56,5:57,6:58,7:59,8:60,9:61,"+":62,"/":63};b.STROKE_CAPS_MAP=["butt","round","square"];b.STROKE_JOINTS_MAP=["miter","round","bevel"];b._ctx=(createjs.createCanvas?createjs.createCanvas():document.createElement("canvas")).getContext("2d");b.beginCmd=new c(b._ctx.beginPath,
[],!1);b.fillCmd=new c(b._ctx.fill,[],!1);b.strokeCmd=new c(b._ctx.stroke,[],!1);a._strokeInstructions=null;a._strokeStyleInstructions=null;a._ignoreScaleStroke=!1;a._fillInstructions=null;a._instructions=null;a._oldInstructions=null;a._activeInstructions=null;a._active=!1;a._dirty=!1;a.initialize=function(){this.clear();this._ctx=b._ctx};a.isEmpty=function(){return!(this._instructions.length||this._oldInstructions.length||this._activeInstructions.length)};a.draw=function(a){this._dirty&&this._updateInstructions();
for(var b=this._instructions,d=0,c=b.length;d<c;d++)b[d].exec(a)};a.drawAsPath=function(a){this._dirty&&this._updateInstructions();for(var b,d=this._instructions,c=0,f=d.length;c<f;c++)((b=d[c]).path||0==c)&&b.exec(a)};a.moveTo=function(a,b){this._activeInstructions.push(new c(this._ctx.moveTo,[a,b]));return this};a.lineTo=function(a,b){this._dirty=this._active=!0;this._activeInstructions.push(new c(this._ctx.lineTo,[a,b]));return this};a.arcTo=function(a,b,d,e,f){this._dirty=this._active=!0;this._activeInstructions.push(new c(this._ctx.arcTo,
[a,b,d,e,f]));return this};a.arc=function(a,b,d,e,f,h){this._dirty=this._active=!0;null==h&&(h=!1);this._activeInstructions.push(new c(this._ctx.arc,[a,b,d,e,f,h]));return this};a.quadraticCurveTo=function(a,b,d,e){this._dirty=this._active=!0;this._activeInstructions.push(new c(this._ctx.quadraticCurveTo,[a,b,d,e]));return this};a.bezierCurveTo=function(a,b,d,e,f,h){this._dirty=this._active=!0;this._activeInstructions.push(new c(this._ctx.bezierCurveTo,[a,b,d,e,f,h]));return this};a.rect=function(a,
b,d,e){this._dirty=this._active=!0;this._activeInstructions.push(new c(this._ctx.rect,[a,b,d,e]));return this};a.closePath=function(){this._active&&(this._dirty=!0,this._activeInstructions.push(new c(this._ctx.closePath,[])));return this};a.clear=function(){this._instructions=[];this._oldInstructions=[];this._activeInstructions=[];this._strokeStyleInstructions=this._strokeInstructions=this._fillInstructions=null;this._active=this._dirty=!1;return this};a.beginFill=function(a){this._active&&this._newPath();
this._fillInstructions=a?[new c(this._setProp,["fillStyle",a],!1),b.fillCmd]:null;return this};a.beginLinearGradientFill=function(a,g,d,e,f,h){this._active&&this._newPath();d=this._ctx.createLinearGradient(d,e,f,h);e=0;for(f=a.length;e<f;e++)d.addColorStop(g[e],a[e]);this._fillInstructions=[new c(this._setProp,["fillStyle",d],!1),b.fillCmd];return this};a.beginRadialGradientFill=function(a,g,d,e,f,h,k,j){this._active&&this._newPath();d=this._ctx.createRadialGradient(d,e,f,h,k,j);e=0;for(f=a.length;e<
f;e++)d.addColorStop(g[e],a[e]);this._fillInstructions=[new c(this._setProp,["fillStyle",d],!1),b.fillCmd];return this};a.beginBitmapFill=function(a,g,d){this._active&&this._newPath();a=this._ctx.createPattern(a,g||"");a=new c(this._setProp,["fillStyle",a],!1);this._fillInstructions=d?[a,new c(this._ctx.save,[],!1),new c(this._ctx.transform,[d.a,d.b,d.c,d.d,d.tx,d.ty],!1),b.fillCmd,new c(this._ctx.restore,[],!1)]:[a,b.fillCmd];return this};a.endFill=function(){return this.beginFill()};a.setStrokeStyle=
function(a,g,d,e,f){this._active&&this._newPath();this._strokeStyleInstructions=[new c(this._setProp,["lineWidth",null==a?"1":a],!1),new c(this._setProp,["lineCap",null==g?"butt":isNaN(g)?g:b.STROKE_CAPS_MAP[g]],!1),new c(this._setProp,["lineJoin",null==d?"miter":isNaN(d)?d:b.STROKE_JOINTS_MAP[d]],!1),new c(this._setProp,["miterLimit",null==e?"10":e],!1)];this._ignoreScaleStroke=f;return this};a.beginStroke=function(a){this._active&&this._newPath();this._strokeInstructions=a?[new c(this._setProp,
["strokeStyle",a],!1)]:null;return this};a.beginLinearGradientStroke=function(a,b,d,e,f,h){this._active&&this._newPath();d=this._ctx.createLinearGradient(d,e,f,h);e=0;for(f=a.length;e<f;e++)d.addColorStop(b[e],a[e]);this._strokeInstructions=[new c(this._setProp,["strokeStyle",d],!1)];return this};a.beginRadialGradientStroke=function(a,b,d,e,f,h,k,j){this._active&&this._newPath();d=this._ctx.createRadialGradient(d,e,f,h,k,j);e=0;for(f=a.length;e<f;e++)d.addColorStop(b[e],a[e]);this._strokeInstructions=
[new c(this._setProp,["strokeStyle",d],!1)];return this};a.beginBitmapStroke=function(a,b){this._active&&this._newPath();var d=this._ctx.createPattern(a,b||"");this._strokeInstructions=[new c(this._setProp,["strokeStyle",d],!1)];return this};a.endStroke=function(){this.beginStroke();return this};a.curveTo=a.quadraticCurveTo;a.drawRect=a.rect;a.drawRoundRect=function(a,b,d,c,f){this.drawRoundRectComplex(a,b,d,c,f,f,f,f);return this};a.drawRoundRectComplex=function(a,b,d,e,f,h,k,j){var l=(d<e?d:e)/
2,n=0,q=0,p=0,s=0;0>f&&(f*=n=-1);f>l&&(f=l);0>h&&(h*=q=-1);h>l&&(h=l);0>k&&(k*=p=-1);k>l&&(k=l);0>j&&(j*=s=-1);j>l&&(j=l);this._dirty=this._active=!0;var l=this._ctx.arcTo,r=this._ctx.lineTo;this._activeInstructions.push(new c(this._ctx.moveTo,[a+d-h,b]),new c(l,[a+d+h*q,b-h*q,a+d,b+h,h]),new c(r,[a+d,b+e-k]),new c(l,[a+d+k*p,b+e+k*p,a+d-k,b+e,k]),new c(r,[a+j,b+e]),new c(l,[a-j*s,b+e+j*s,a,b+e-j,j]),new c(r,[a,b+f]),new c(l,[a-f*n,b-f*n,a+f,b,f]),new c(this._ctx.closePath));return this};a.drawCircle=
function(a,b,d){this.arc(a,b,d,0,2*Math.PI);return this};a.drawEllipse=function(a,b,d,e){this._dirty=this._active=!0;var f=0.5522848*(d/2),h=0.5522848*(e/2),k=a+d,j=b+e;d=a+d/2;e=b+e/2;this._activeInstructions.push(new c(this._ctx.moveTo,[a,e]),new c(this._ctx.bezierCurveTo,[a,e-h,d-f,b,d,b]),new c(this._ctx.bezierCurveTo,[d+f,b,k,e-h,k,e]),new c(this._ctx.bezierCurveTo,[k,e+h,d+f,j,d,j]),new c(this._ctx.bezierCurveTo,[d-f,j,a,e+h,a,e]));return this};a.drawPolyStar=function(a,b,d,e,f,h){this._dirty=
this._active=!0;null==f&&(f=0);f=1-f;h=null==h?0:h/(180/Math.PI);var k=Math.PI/e;this._activeInstructions.push(new c(this._ctx.moveTo,[a+Math.cos(h)*d,b+Math.sin(h)*d]));for(var j=0;j<e;j++)h+=k,1!=f&&this._activeInstructions.push(new c(this._ctx.lineTo,[a+Math.cos(h)*d*f,b+Math.sin(h)*d*f])),h+=k,this._activeInstructions.push(new c(this._ctx.lineTo,[a+Math.cos(h)*d,b+Math.sin(h)*d]));return this};a.decodePath=function(a){for(var g=[this.moveTo,this.lineTo,this.quadraticCurveTo,this.bezierCurveTo,
this.closePath],d=[2,2,4,6,0],c=0,f=a.length,h=[],k=0,j=0,l=b.BASE_64;c<f;){var n=a.charAt(c),q=l[n],p=q>>3,s=g[p];if(!s||q&3)throw"bad path data (@"+c+"): "+n;n=d[p];p||(k=j=0);h.length=0;c++;q=(q>>2&1)+2;for(p=0;p<n;p++){var r=l[a.charAt(c)],u=r>>5?-1:1,r=(r&31)<<6|l[a.charAt(c+1)];3==q&&(r=r<<6|l[a.charAt(c+2)]);r=u*r/10;p%2?k=r+=k:j=r+=j;h[p]=r;c+=q}s.apply(this,h)}return this};a.clone=function(){var a=new b;a._instructions=this._instructions.slice();a._activeInstructions=this._activeInstructions.slice();
a._oldInstructions=this._oldInstructions.slice();this._fillInstructions&&(a._fillInstructions=this._fillInstructions.slice());this._strokeInstructions&&(a._strokeInstructions=this._strokeInstructions.slice());this._strokeStyleInstructions&&(a._strokeStyleInstructions=this._strokeStyleInstructions.slice());a._active=this._active;a._dirty=this._dirty;return a};a.toString=function(){return"[Graphics]"};a.mt=a.moveTo;a.lt=a.lineTo;a.at=a.arcTo;a.bt=a.bezierCurveTo;a.qt=a.quadraticCurveTo;a.a=a.arc;a.r=
a.rect;a.cp=a.closePath;a.c=a.clear;a.f=a.beginFill;a.lf=a.beginLinearGradientFill;a.rf=a.beginRadialGradientFill;a.bf=a.beginBitmapFill;a.ef=a.endFill;a.ss=a.setStrokeStyle;a.s=a.beginStroke;a.ls=a.beginLinearGradientStroke;a.rs=a.beginRadialGradientStroke;a.bs=a.beginBitmapStroke;a.es=a.endStroke;a.dr=a.drawRect;a.rr=a.drawRoundRect;a.rc=a.drawRoundRectComplex;a.dc=a.drawCircle;a.de=a.drawEllipse;a.dp=a.drawPolyStar;a.p=a.decodePath;a._updateInstructions=function(){this._instructions=this._oldInstructions.slice();
this._instructions.push(b.beginCmd);this._instructions.push.apply(this._instructions,this._activeInstructions);this._fillInstructions&&this._instructions.push.apply(this._instructions,this._fillInstructions);this._strokeInstructions&&(this._strokeStyleInstructions&&this._instructions.push.apply(this._instructions,this._strokeStyleInstructions),this._instructions.push.apply(this._instructions,this._strokeInstructions),this._ignoreScaleStroke?this._instructions.push(new c(this._ctx.save,[],!1),new c(this._ctx.setTransform,
[1,0,0,1,0,0],!1),b.strokeCmd,new c(this._ctx.restore,[],!1)):this._instructions.push(b.strokeCmd))};a._newPath=function(){this._dirty&&this._updateInstructions();this._oldInstructions=this._instructions;this._activeInstructions=[];this._active=this._dirty=!1};a._setProp=function(a,b){this[a]=b};createjs.Graphics=b})();this.createjs=this.createjs||{};
(function(){var c=function(){this.initialize()},b=c.prototype;c.suppressCrossDomainErrors=!1;c._hitTestCanvas=createjs.createCanvas?createjs.createCanvas():document.createElement("canvas");c._hitTestCanvas.width=c._hitTestCanvas.height=1;c._hitTestContext=c._hitTestCanvas.getContext("2d");c._nextCacheID=1;b.alpha=1;b.cacheCanvas=null;b.id=-1;b.mouseEnabled=!0;b.name=null;b.parent=null;b.regX=0;b.regY=0;b.rotation=0;b.scaleX=1;b.scaleY=1;b.skewX=0;b.skewY=0;b.shadow=null;b.visible=!0;b.x=0;b.y=0;b.compositeOperation=
null;b.snapToPixel=!1;b.onPress=null;b.onClick=null;b.onDoubleClick=null;b.onMouseOver=null;b.onMouseOut=null;b.onTick=null;b.filters=null;b.cacheID=0;b.mask=null;b.hitArea=null;b.cursor=null;b.addEventListener=null;b.removeEventListener=null;b.removeAllEventListeners=null;b.dispatchEvent=null;b.hasEventListener=null;b._listeners=null;createjs.EventDispatcher.initialize(b);b._cacheOffsetX=0;b._cacheOffsetY=0;b._cacheScale=1;b._cacheDataURLID=0;b._cacheDataURL=null;b._matrix=null;b.initialize=function(){this.id=
createjs.UID.get();this._matrix=new createjs.Matrix2D};b.isVisible=function(){return!(!this.visible||!(0<this.alpha&&0!=this.scaleX&&0!=this.scaleY))};b.draw=function(a,b){var c=this.cacheCanvas;if(b||!c)return!1;var d=this._cacheScale;a.drawImage(c,this._cacheOffsetX,this._cacheOffsetY,c.width/d,c.height/d);return!0};b.updateContext=function(a){var b,c=this.mask;c&&(c.graphics&&!c.graphics.isEmpty())&&(b=c.getMatrix(c._matrix),a.transform(b.a,b.b,b.c,b.d,b.tx,b.ty),c.graphics.drawAsPath(a),a.clip(),
b.invert(),a.transform(b.a,b.b,b.c,b.d,b.tx,b.ty));b=this._matrix.identity().appendTransform(this.x,this.y,this.scaleX,this.scaleY,this.rotation,this.skewX,this.skewY,this.regX,this.regY);createjs.Stage._snapToPixelEnabled&&this.snapToPixel?a.transform(b.a,b.b,b.c,b.d,b.tx+0.5|0,b.ty+0.5|0):a.transform(b.a,b.b,b.c,b.d,b.tx,b.ty);a.globalAlpha*=this.alpha;this.compositeOperation&&(a.globalCompositeOperation=this.compositeOperation);this.shadow&&this._applyShadow(a,this.shadow)};b.cache=function(a,
b,c,d,e){e=e||1;this.cacheCanvas||(this.cacheCanvas=createjs.createCanvas?createjs.createCanvas():document.createElement("canvas"));this.cacheCanvas.width=Math.ceil(c*e);this.cacheCanvas.height=Math.ceil(d*e);this._cacheOffsetX=a;this._cacheOffsetY=b;this._cacheScale=e||1;this.updateCache()};b.updateCache=function(a){var b=this.cacheCanvas,g=this._cacheScale,d=this._cacheOffsetX*g,e=this._cacheOffsetY*g;if(!b)throw"cache() must be called before updateCache()";var f=b.getContext("2d");f.save();a||
f.clearRect(0,0,b.width+1,b.height+1);f.globalCompositeOperation=a;f.setTransform(g,0,0,g,-d,-e);this.draw(f,!0);this._applyFilters();f.restore();this.cacheID=c._nextCacheID++};b.uncache=function(){this._cacheDataURL=this.cacheCanvas=null;this.cacheID=this._cacheOffsetX=this._cacheOffsetY=0;this._cacheScale=1};b.getCacheDataURL=function(){if(!this.cacheCanvas)return null;this.cacheID!=this._cacheDataURLID&&(this._cacheDataURL=this.cacheCanvas.toDataURL());return this._cacheDataURL};b.getStage=function(){for(var a=
this;a.parent;)a=a.parent;return a instanceof createjs.Stage?a:null};b.localToGlobal=function(a,b){var c=this.getConcatenatedMatrix(this._matrix);if(null==c)return null;c.append(1,0,0,1,a,b);return new createjs.Point(c.tx,c.ty)};b.globalToLocal=function(a,b){var c=this.getConcatenatedMatrix(this._matrix);if(null==c)return null;c.invert();c.append(1,0,0,1,a,b);return new createjs.Point(c.tx,c.ty)};b.localToLocal=function(a,b,c){a=this.localToGlobal(a,b);return c.globalToLocal(a.x,a.y)};b.setTransform=
function(a,b,c,d,e,f,h,k,j){this.x=a||0;this.y=b||0;this.scaleX=null==c?1:c;this.scaleY=null==d?1:d;this.rotation=e||0;this.skewX=f||0;this.skewY=h||0;this.regX=k||0;this.regY=j||0;return this};b.getMatrix=function(a){return(a?a.identity():new createjs.Matrix2D).appendTransform(this.x,this.y,this.scaleX,this.scaleY,this.rotation,this.skewX,this.skewY,this.regX,this.regY).appendProperties(this.alpha,this.shadow,this.compositeOperation)};b.getConcatenatedMatrix=function(a){a?a.identity():a=new createjs.Matrix2D;
for(var b=this;null!=b;)a.prependTransform(b.x,b.y,b.scaleX,b.scaleY,b.rotation,b.skewX,b.skewY,b.regX,b.regY).prependProperties(b.alpha,b.shadow,b.compositeOperation),b=b.parent;return a};b.hitTest=function(a,b){var g=c._hitTestContext;g.setTransform(1,0,0,1,-a,-b);this.draw(g);var d=this._testHit(g);g.setTransform(1,0,0,1,0,0);g.clearRect(0,0,2,2);return d};b.set=function(a){for(var b in a)this[b]=a[b];return this};b.clone=function(){var a=new c;this.cloneProps(a);return a};b.toString=function(){return"[DisplayObject (name="+
this.name+")]"};b.cloneProps=function(a){a.alpha=this.alpha;a.name=this.name;a.regX=this.regX;a.regY=this.regY;a.rotation=this.rotation;a.scaleX=this.scaleX;a.scaleY=this.scaleY;a.shadow=this.shadow;a.skewX=this.skewX;a.skewY=this.skewY;a.visible=this.visible;a.x=this.x;a.y=this.y;a.mouseEnabled=this.mouseEnabled;a.compositeOperation=this.compositeOperation;this.cacheCanvas&&(a.cacheCanvas=this.cacheCanvas.cloneNode(!0),a.cacheCanvas.getContext("2d").putImageData(this.cacheCanvas.getContext("2d").getImageData(0,
0,this.cacheCanvas.width,this.cacheCanvas.height),0,0))};b._applyShadow=function(a,b){b=b||Shadow.identity;a.shadowColor=b.color;a.shadowOffsetX=b.offsetX;a.shadowOffsetY=b.offsetY;a.shadowBlur=b.blur};b._tick=function(a){this.onTick&&this.onTick.apply(this,a);var b=this._listeners;b&&b.tick&&this.dispatchEvent({type:"tick",params:a})};b._testHit=function(a){try{var b=1<a.getImageData(0,0,1,1).data[3]}catch(g){if(!c.suppressCrossDomainErrors)throw"An error has occurred. This is most likely due to security restrictions on reading canvas pixel data with local or cross-domain images.";
}return b};b._applyFilters=function(){if(this.filters&&0!=this.filters.length&&this.cacheCanvas)for(var a=this.filters.length,b=this.cacheCanvas.getContext("2d"),c=this.cacheCanvas.width,d=this.cacheCanvas.height,e=0;e<a;e++)this.filters[e].applyFilter(b,0,0,c,d)};b._hasMouseHandler=function(a){var b=this._listeners;return!!(a&1&&(this.onPress||this.onClick||this.onDoubleClick||b&&(this.hasEventListener("mousedown")||this.hasEventListener("click")||this.hasEventListener("dblclick")))||a&2&&(this.onMouseOver||
this.onMouseOut||this.cursor||b&&(this.hasEventListener("mouseover")||this.hasEventListener("mouseout"))))};createjs.DisplayObject=c})();this.createjs=this.createjs||{};
(function(){var c=function(){this.initialize()},b=c.prototype=new createjs.DisplayObject;b.children=null;b.DisplayObject_initialize=b.initialize;b.initialize=function(){this.DisplayObject_initialize();this.children=[]};b.isVisible=function(){var a=this.cacheCanvas||this.children.length;return!(!this.visible||!(0<this.alpha&&0!=this.scaleX&&0!=this.scaleY&&a))};b.DisplayObject_draw=b.draw;b.draw=function(a,b){if(this.DisplayObject_draw(a,b))return!0;for(var c=this.children.slice(0),d=0,e=c.length;d<
e;d++){var f=c[d];f.isVisible()&&(a.save(),f.updateContext(a),f.draw(a),a.restore())}return!0};b.addChild=function(a){if(null==a)return a;var b=arguments.length;if(1<b){for(var c=0;c<b;c++)this.addChild(arguments[c]);return arguments[b-1]}a.parent&&a.parent.removeChild(a);a.parent=this;this.children.push(a);return a};b.addChildAt=function(a,b){var c=arguments.length,d=arguments[c-1];if(0>d||d>this.children.length)return arguments[c-2];if(2<c){for(var e=0;e<c-1;e++)this.addChildAt(arguments[e],d+e);
return arguments[c-2]}a.parent&&a.parent.removeChild(a);a.parent=this;this.children.splice(b,0,a);return a};b.removeChild=function(a){var b=arguments.length;if(1<b){for(var c=!0,d=0;d<b;d++)c=c&&this.removeChild(arguments[d]);return c}return this.removeChildAt(this.children.indexOf(a))};b.removeChildAt=function(a){var b=arguments.length;if(1<b){for(var c=[],d=0;d<b;d++)c[d]=arguments[d];c.sort(function(a,b){return b-a});for(var e=!0,d=0;d<b;d++)e=e&&this.removeChildAt(c[d]);return e}if(0>a||a>this.children.length-
1)return!1;if(b=this.children[a])b.parent=null;this.children.splice(a,1);return!0};b.removeAllChildren=function(){for(var a=this.children;a.length;)a.pop().parent=null};b.getChildAt=function(a){return this.children[a]};b.getChildByName=function(a){for(var b=this.children,c=0,d=b.length;c<d;c++)if(b[c].name==a)return b[c];return null};b.sortChildren=function(a){this.children.sort(a)};b.getChildIndex=function(a){return this.children.indexOf(a)};b.getNumChildren=function(){return this.children.length};
b.swapChildrenAt=function(a,b){var c=this.children,d=c[a],e=c[b];d&&e&&(c[a]=e,c[b]=d)};b.swapChildren=function(a,b){for(var c=this.children,d,e,f=0,h=c.length;f<h&&!(c[f]==a&&(d=f),c[f]==b&&(e=f),null!=d&&null!=e);f++);f!=h&&(c[d]=b,c[e]=a)};b.setChildIndex=function(a,b){var c=this.children,d=c.length;if(!(a.parent!=this||0>b||b>=d)){for(var e=0;e<d&&c[e]!=a;e++);e==d||e==b||(c.splice(e,1),b<e&&b--,c.splice(b,0,a))}};b.contains=function(a){for(;a;){if(a==this)return!0;a=a.parent}return!1};b.hitTest=
function(a,b){return null!=this.getObjectUnderPoint(a,b)};b.getObjectsUnderPoint=function(a,b){var c=[],d=this.localToGlobal(a,b);this._getObjectsUnderPoint(d.x,d.y,c);return c};b.getObjectUnderPoint=function(a,b){var c=this.localToGlobal(a,b);return this._getObjectsUnderPoint(c.x,c.y)};b.clone=function(a){var b=new c;this.cloneProps(b);if(a)for(var g=b.children=[],d=0,e=this.children.length;d<e;d++){var f=this.children[d].clone(a);f.parent=b;g.push(f)}return b};b.toString=function(){return"[Container (name="+
this.name+")]"};b.DisplayObject__tick=b._tick;b._tick=function(a){for(var b=this.children.length-1;0<=b;b--){var c=this.children[b];c._tick&&c._tick(a)}this.DisplayObject__tick(a)};b._getObjectsUnderPoint=function(a,b,g,d){var e=createjs.DisplayObject._hitTestContext,f=this._matrix,h=this._hasMouseHandler(d);if(!this.hitArea&&(this.cacheCanvas&&h)&&(this.getConcatenatedMatrix(f),e.setTransform(f.a,f.b,f.c,f.d,f.tx-a,f.ty-b),e.globalAlpha=f.alpha,this.draw(e),this._testHit(e)))return e.setTransform(1,
0,0,1,0,0),e.clearRect(0,0,2,2),this;for(var k=this.children.length-1;0<=k;k--){var j=this.children[k],l=j.hitArea;if(j.visible&&!(!l&&!j.isVisible()||d&&!j.mouseEnabled)){var n=d&&j._hasMouseHandler(d);if(j instanceof c&&(!l||!n))if(h){if(j=j._getObjectsUnderPoint(a,b))return this}else{if(j=j._getObjectsUnderPoint(a,b,g,d),!g&&j)return j}else if(!d||h||n)if(j.getConcatenatedMatrix(f),l&&(f.appendTransform(l.x,l.y,l.scaleX,l.scaleY,l.rotation,l.skewX,l.skewY,l.regX,l.regY),f.alpha=l.alpha),e.globalAlpha=
f.alpha,e.setTransform(f.a,f.b,f.c,f.d,f.tx-a,f.ty-b),(l||j).draw(e),this._testHit(e)){e.setTransform(1,0,0,1,0,0);e.clearRect(0,0,2,2);if(h)return this;if(g)g.push(j);else return j}}}return null};createjs.Container=c})();this.createjs=this.createjs||{};
(function(){var c=function(a){this.initialize(a)},b=c.prototype=new createjs.Container;c._snapToPixelEnabled=!1;b.autoClear=!0;b.canvas=null;b.mouseX=0;b.mouseY=0;b.onMouseMove=null;b.onMouseUp=null;b.onMouseDown=null;b.snapToPixelEnabled=!1;b.mouseInBounds=!1;b.tickOnUpdate=!0;b.mouseMoveOutside=!1;b._pointerData=null;b._pointerCount=0;b._primaryPointerID=null;b._mouseOverIntervalID=null;b.Container_initialize=b.initialize;b.initialize=function(a){this.Container_initialize();this.canvas="string"==
typeof a?document.getElementById(a):a;this._pointerData={};this.enableDOMEvents(!0)};b.update=function(){if(this.canvas){this.autoClear&&this.clear();c._snapToPixelEnabled=this.snapToPixelEnabled;this.tickOnUpdate&&this._tick(arguments.length?arguments:null);var a=this.canvas.getContext("2d");a.save();this.updateContext(a);this.draw(a,!1);a.restore()}};b.tick=b.update;b.handleEvent=function(a){"tick"==a.type&&this.update(a)};b.clear=function(){if(this.canvas){var a=this.canvas.getContext("2d");a.setTransform(1,
0,0,1,0,0);a.clearRect(0,0,this.canvas.width+1,this.canvas.height+1)}};b.toDataURL=function(a,b){b||(b="image/png");var c=this.canvas.getContext("2d"),d=this.canvas.width,e=this.canvas.height,f;if(a){f=c.getImageData(0,0,d,e);var h=c.globalCompositeOperation;c.globalCompositeOperation="destination-over";c.fillStyle=a;c.fillRect(0,0,d,e)}var k=this.canvas.toDataURL(b);a&&(c.clearRect(0,0,d+1,e+1),c.putImageData(f,0,0),c.globalCompositeOperation=h);return k};b.enableMouseOver=function(a){this._mouseOverIntervalID&&
(clearInterval(this._mouseOverIntervalID),this._mouseOverIntervalID=null);if(null==a)a=20;else if(0>=a)return;var b=this;this._mouseOverIntervalID=setInterval(function(){b._testMouseOver()},1E3/Math.min(50,a))};b.enableDOMEvents=function(a){null==a&&(a=!0);var b,c=this._eventListeners;if(!a&&c){for(b in c)a=c[b],a.t.removeEventListener(b,a.f);this._eventListeners=null}else if(a&&!c&&this.canvas){a=window.addEventListener?window:document;var d=this,c=this._eventListeners={};c.mouseup={t:a,f:function(a){d._handleMouseUp(a)}};
c.mousemove={t:a,f:function(a){d._handleMouseMove(a)}};c.dblclick={t:a,f:function(a){d._handleDoubleClick(a)}};c.mousedown={t:this.canvas,f:function(a){d._handleMouseDown(a)}};for(b in c)a=c[b],a.t.addEventListener(b,a.f)}};b.clone=function(){var a=new c(null);this.cloneProps(a);return a};b.toString=function(){return"[Stage (name="+this.name+")]"};b._getPointerData=function(a){var b=this._pointerData[a];if(!b&&(b=this._pointerData[a]={x:0,y:0},null==this._primaryPointerID||-1==this._primaryPointerID))this._primaryPointerID=
a;return b};b._handleMouseMove=function(a){a||(a=window.event);this._handlePointerMove(-1,a,a.pageX,a.pageY)};b._handlePointerMove=function(a,b,c,d){if(this.canvas){var e=this._getPointerData(a),f=e.inBounds;this._updatePointerPosition(a,c,d);if(f||e.inBounds||this.mouseMoveOutside){if(this.onMouseMove||this.hasEventListener("stagemousemove"))c=new createjs.MouseEvent("stagemousemove",e.x,e.y,this,b,a,a==this._primaryPointerID,e.rawX,e.rawY),this.onMouseMove&&this.onMouseMove(c),this.dispatchEvent(c);
if((d=e.event)&&(d.onMouseMove||d.hasEventListener("mousemove")))c=new createjs.MouseEvent("mousemove",e.x,e.y,d.target,b,a,a==this._primaryPointerID,e.rawX,e.rawY),d.onMouseMove&&d.onMouseMove(c),d.dispatchEvent(c,d.target)}}};b._updatePointerPosition=function(a,b,c){var d=this._getElementRect(this.canvas);b-=d.left;c-=d.top;var e=this.canvas.width,f=this.canvas.height;b/=(d.right-d.left)/e;c/=(d.bottom-d.top)/f;d=this._getPointerData(a);(d.inBounds=0<=b&&0<=c&&b<=e-1&&c<=f-1)?(d.x=b,d.y=c):this.mouseMoveOutside&&
(d.x=0>b?0:b>e-1?e-1:b,d.y=0>c?0:c>f-1?f-1:c);d.rawX=b;d.rawY=c;a==this._primaryPointerID&&(this.mouseX=d.x,this.mouseY=d.y,this.mouseInBounds=d.inBounds)};b._getElementRect=function(a){var b;try{b=a.getBoundingClientRect()}catch(c){b={top:a.offsetTop,left:a.offsetLeft,width:a.offsetWidth,height:a.offsetHeight}}var d=(window.pageXOffset||document.scrollLeft||0)-(document.clientLeft||document.body.clientLeft||0),e=(window.pageYOffset||document.scrollTop||0)-(document.clientTop||document.body.clientTop||
0),f=window.getComputedStyle?getComputedStyle(a):a.currentStyle;a=parseInt(f.paddingLeft)+parseInt(f.borderLeftWidth);var h=parseInt(f.paddingTop)+parseInt(f.borderTopWidth),k=parseInt(f.paddingRight)+parseInt(f.borderRightWidth),f=parseInt(f.paddingBottom)+parseInt(f.borderBottomWidth);return{left:b.left+d+a,right:b.right+d-k,top:b.top+e+h,bottom:b.bottom+e-f}};b._handleMouseUp=function(a){this._handlePointerUp(-1,a,!1)};b._handlePointerUp=function(a,b,c){var d=this._getPointerData(a),e;if(this.onMouseMove||
this.hasEventListener("stagemouseup"))e=new createjs.MouseEvent("stagemouseup",d.x,d.y,this,b,a,a==this._primaryPointerID,d.rawX,d.rawY),this.onMouseUp&&this.onMouseUp(e),this.dispatchEvent(e);var f=d.event;if(f&&(f.onMouseUp||f.hasEventListener("mouseup")))e=new createjs.MouseEvent("mouseup",d.x,d.y,f.target,b,a,a==this._primaryPointerID,d.rawX,d.rawY),f.onMouseUp&&f.onMouseUp(e),f.dispatchEvent(e,f.target);if((f=d.target)&&(f.onClick||f.hasEventListener("click"))&&this._getObjectsUnderPoint(d.x,
d.y,null,!0,this._mouseOverIntervalID?3:1)==f)e=new createjs.MouseEvent("click",d.x,d.y,f,b,a,a==this._primaryPointerID,d.rawX,d.rawY),f.onClick&&f.onClick(e),f.dispatchEvent(e);c?(a==this._primaryPointerID&&(this._primaryPointerID=null),delete this._pointerData[a]):d.event=d.target=null};b._handleMouseDown=function(a){this._handlePointerDown(-1,a,!1)};b._handlePointerDown=function(a,b,c,d){var e=this._getPointerData(a);null!=d&&this._updatePointerPosition(a,c,d);if(this.onMouseDown||this.hasEventListener("stagemousedown"))c=
new createjs.MouseEvent("stagemousedown",e.x,e.y,this,b,a,a==this._primaryPointerID,e.rawX,e.rawY),this.onMouseDown&&this.onMouseDown(c),this.dispatchEvent(c);if(d=this._getObjectsUnderPoint(e.x,e.y,null,this._mouseOverIntervalID?3:1))if(e.target=d,d.onPress||d.hasEventListener("mousedown"))if(c=new createjs.MouseEvent("mousedown",e.x,e.y,d,b,a,a==this._primaryPointerID,e.rawX,e.rawY),d.onPress&&d.onPress(c),d.dispatchEvent(c),c.onMouseMove||c.onMouseUp||c.hasEventListener("mousemove")||c.hasEventListener("mouseup"))e.event=
c};b._testMouseOver=function(){if(-1==this._primaryPointerID&&!(this.mouseX==this._mouseOverX&&this.mouseY==this._mouseOverY&&this.mouseInBounds)){var a=null;this.mouseInBounds&&(a=this._getObjectsUnderPoint(this.mouseX,this.mouseY,null,3),this._mouseOverX=this.mouseX,this._mouseOverY=this.mouseY);var b=this._mouseOverTarget;if(b!=a){var c=this._getPointerData(-1);if(b&&(b.onMouseOut||b.hasEventListener("mouseout"))){var d=new createjs.MouseEvent("mouseout",c.x,c.y,b,null,-1,c.rawX,c.rawY);b.onMouseOut&&
b.onMouseOut(d);b.dispatchEvent(d)}b&&(this.canvas.style.cursor="");if(a&&(a.onMouseOver||a.hasEventListener("mouseover")))d=new createjs.MouseEvent("mouseover",c.x,c.y,a,null,-1,c.rawX,c.rawY),a.onMouseOver&&a.onMouseOver(d),a.dispatchEvent(d);a&&(this.canvas.style.cursor=a.cursor||"");this._mouseOverTarget=a}}};b._handleDoubleClick=function(a){var b=this._getPointerData(-1),c=this._getObjectsUnderPoint(b.x,b.y,null,this._mouseOverIntervalID?3:1);if(c&&(c.onDoubleClick||c.hasEventListener("dblclick")))evt=
new createjs.MouseEvent("dblclick",b.x,b.y,c,a,-1,!0,b.rawX,b.rawY),c.onDoubleClick&&c.onDoubleClick(evt),c.dispatchEvent(evt)};createjs.Stage=c})();this.createjs=this.createjs||{};
(function(){var c=function(a){this.initialize(a)},b=c.prototype=new createjs.DisplayObject;b.image=null;b.snapToPixel=!0;b.sourceRect=null;b.DisplayObject_initialize=b.initialize;b.initialize=function(a){this.DisplayObject_initialize();"string"==typeof a?(this.image=new Image,this.image.src=a):this.image=a};b.isVisible=function(){var a=this.cacheCanvas||this.image&&(this.image.complete||this.image.getContext||2<=this.image.readyState);return!(!this.visible||!(0<this.alpha&&0!=this.scaleX&&0!=this.scaleY&&
a))};b.DisplayObject_draw=b.draw;b.draw=function(a,b){if(this.DisplayObject_draw(a,b))return!0;var c=this.sourceRect;c?a.drawImage(this.image,c.x,c.y,c.width,c.height,0,0,c.width,c.height):a.drawImage(this.image,0,0);return!0};b.clone=function(){var a=new c(this.image);this.sourceRect&&(a.sourceRect=this.sourceRect.clone());this.cloneProps(a);return a};b.toString=function(){return"[Bitmap (name="+this.name+")]"};createjs.Bitmap=c})();this.createjs=this.createjs||{};
(function(){var c=function(a){this.initialize(a)},b=c.prototype=new createjs.DisplayObject;b.onAnimationEnd=null;b.currentFrame=-1;b.currentAnimation=null;b.paused=!0;b.spriteSheet=null;b.snapToPixel=!0;b.offset=0;b.currentAnimationFrame=0;b.addEventListener=null;b.removeEventListener=null;b.removeAllEventListeners=null;b.dispatchEvent=null;b.hasEventListener=null;b._listeners=null;createjs.EventDispatcher.initialize(b);b._advanceCount=0;b._animation=null;b.DisplayObject_initialize=b.initialize;b.initialize=
function(a){this.DisplayObject_initialize();this.spriteSheet=a};b.isVisible=function(){var a=this.cacheCanvas||this.spriteSheet.complete&&0<=this.currentFrame;return!(!this.visible||!(0<this.alpha&&0!=this.scaleX&&0!=this.scaleY&&a))};b.DisplayObject_draw=b.draw;b.draw=function(a,b){if(this.DisplayObject_draw(a,b))return!0;this._normalizeFrame();var c=this.spriteSheet.getFrame(this.currentFrame);if(c){var d=c.rect;a.drawImage(c.image,d.x,d.y,d.width,d.height,-c.regX,-c.regY,d.width,d.height);return!0}};
b.play=function(){this.paused=!1};b.stop=function(){this.paused=!0};b.gotoAndPlay=function(a){this.paused=!1;this._goto(a)};b.gotoAndStop=function(a){this.paused=!0;this._goto(a)};b.advance=function(){this._animation?this.currentAnimationFrame++:this.currentFrame++;this._normalizeFrame()};b.getBounds=function(){return this.spriteSheet.getFrameBounds(this.currentFrame)};b.clone=function(){var a=new c(this.spriteSheet);this.cloneProps(a);return a};b.toString=function(){return"[BitmapAnimation (name="+
this.name+")]"};b.DisplayObject__tick=b._tick;b._tick=function(a){var b=this._animation?this._animation.frequency:1;!this.paused&&0==(++this._advanceCount+this.offset)%b&&this.advance();this.DisplayObject__tick(a)};b._normalizeFrame=function(){var a=this._animation,b=this.currentFrame,c=this.paused,d;if(a)if(d=a.frames.length,this.currentAnimationFrame>=d){var e=a.next;this._dispatchAnimationEnd(a,b,c,e,d-1)||(e?this._goto(e):(this.paused=!0,this.currentAnimationFrame=a.frames.length-1,this.currentFrame=
a.frames[this.currentAnimationFrame]))}else this.currentFrame=a.frames[this.currentAnimationFrame];else d=this.spriteSheet.getNumFrames(),b>=d&&!this._dispatchAnimationEnd(a,b,c,d-1)&&(this.currentFrame=0)};b._dispatchAnimationEnd=function(a,b,c,d,e){var f=a?a.name:null;this.onAnimationEnd&&this.onAnimationEnd(this,f,d);this.dispatchEvent({type:"animationend",name:f,next:d});!c&&this.paused&&(this.currentAnimationFrame=e);return this.paused!=c||this._animation!=a||this.currentFrame!=b};b.DisplayObject_cloneProps=
b.cloneProps;b.cloneProps=function(a){this.DisplayObject_cloneProps(a);a.onAnimationEnd=this.onAnimationEnd;a.currentFrame=this.currentFrame;a.currentAnimation=this.currentAnimation;a.paused=this.paused;a.offset=this.offset;a._animation=this._animation;a.currentAnimationFrame=this.currentAnimationFrame};b._goto=function(a){if(isNaN(a)){var b=this.spriteSheet.getAnimation(a);b&&(this.currentAnimationFrame=0,this._animation=b,this.currentAnimation=a,this._normalizeFrame())}else this.currentAnimation=
this._animation=null,this.currentFrame=a};createjs.BitmapAnimation=c})();this.createjs=this.createjs||{};
(function(){var c=function(a){this.initialize(a)},b=c.prototype=new createjs.DisplayObject;b.graphics=null;b.DisplayObject_initialize=b.initialize;b.initialize=function(a){this.DisplayObject_initialize();this.graphics=a?a:new createjs.Graphics};b.isVisible=function(){var a=this.cacheCanvas||this.graphics&&!this.graphics.isEmpty();return!(!this.visible||!(0<this.alpha&&0!=this.scaleX&&0!=this.scaleY&&a))};b.DisplayObject_draw=b.draw;b.draw=function(a,b){if(this.DisplayObject_draw(a,b))return!0;this.graphics.draw(a);
return!0};b.clone=function(a){a=new c(a&&this.graphics?this.graphics.clone():this.graphics);this.cloneProps(a);return a};b.toString=function(){return"[Shape (name="+this.name+")]"};createjs.Shape=c})();this.createjs=this.createjs||{};
(function(){var c=function(a,b,c){this.initialize(a,b,c)},b=c.prototype=new createjs.DisplayObject;c._workingContext=(createjs.createCanvas?createjs.createCanvas():document.createElement("canvas")).getContext("2d");b.text="";b.font=null;b.color="#000";b.textAlign="left";b.textBaseline="top";b.maxWidth=null;b.outline=!1;b.lineHeight=0;b.lineWidth=null;b.DisplayObject_initialize=b.initialize;b.initialize=function(a,b,c){this.DisplayObject_initialize();this.text=a;this.font=b;this.color=c?c:"#000"};
b.isVisible=function(){var a=this.cacheCanvas||null!=this.text&&""!==this.text;return!(!this.visible||!(0<this.alpha&&0!=this.scaleX&&0!=this.scaleY&&a))};b.DisplayObject_draw=b.draw;b.draw=function(a,b){if(this.DisplayObject_draw(a,b))return!0;this.outline?a.strokeStyle=this.color:a.fillStyle=this.color;a.font=this.font;a.textAlign=this.textAlign||"start";a.textBaseline=this.textBaseline||"alphabetic";this._drawText(a);return!0};b.getMeasuredWidth=function(){return this._getWorkingContext().measureText(this.text).width};
b.getMeasuredLineHeight=function(){return 1.2*this._getWorkingContext().measureText("M").width};b.getMeasuredHeight=function(){return this._drawText()*(this.lineHeight||this.getMeasuredLineHeight())};b.clone=function(){var a=new c(this.text,this.font,this.color);this.cloneProps(a);return a};b.toString=function(){return"[Text (text="+(20<this.text.length?this.text.substr(0,17)+"...":this.text)+")]"};b.DisplayObject_cloneProps=b.cloneProps;b.cloneProps=function(a){this.DisplayObject_cloneProps(a);a.textAlign=
this.textAlign;a.textBaseline=this.textBaseline;a.maxWidth=this.maxWidth;a.outline=this.outline;a.lineHeight=this.lineHeight;a.lineWidth=this.lineWidth};b._getWorkingContext=function(){var a=c._workingContext;a.font=this.font;a.textAlign=this.textAlign||"start";a.textBaseline=this.textBaseline||"alphabetic";return a};b._drawText=function(a){var b=!!a;b||(a=this._getWorkingContext());for(var c=String(this.text).split(/(?:\r\n|\r|\n)/),d=this.lineHeight||this.getMeasuredLineHeight(),e=0,f=0,h=c.length;f<
h;f++){var k=a.measureText(c[f]).width;if(null==this.lineWidth||k<this.lineWidth)b&&this._drawTextLine(a,c[f],e*d);else{for(var k=c[f].split(/(\s)/),j=k[0],l=1,n=k.length;l<n;l+=2)a.measureText(j+k[l]+k[l+1]).width>this.lineWidth?(b&&this._drawTextLine(a,j,e*d),e++,j=k[l+1]):j+=k[l]+k[l+1];b&&this._drawTextLine(a,j,e*d)}e++}return e};b._drawTextLine=function(a,b,c){this.outline?a.strokeText(b,0,c,this.maxWidth||65535):a.fillText(b,0,c,this.maxWidth||65535)};createjs.Text=c})();this.createjs=this.createjs||{};
(function(){var c=function(){throw"SpriteSheetUtils cannot be instantiated";};c._workingCanvas=createjs.createCanvas?createjs.createCanvas():document.createElement("canvas");c._workingContext=c._workingCanvas.getContext("2d");c.addFlippedFrames=function(b,a,m,g){if(a||m||g){var d=0;a&&c._flip(b,++d,!0,!1);m&&c._flip(b,++d,!1,!0);g&&c._flip(b,++d,!0,!0)}};c.extractFrame=function(b,a){isNaN(a)&&(a=b.getAnimation(a).frames[0]);var m=b.getFrame(a);if(!m)return null;var g=m.rect,d=c._workingCanvas;d.width=
g.width;d.height=g.height;c._workingContext.drawImage(m.image,g.x,g.y,g.width,g.height,0,0,g.width,g.height);m=new Image;m.src=d.toDataURL("image/png");return m};c.mergeAlpha=function(b,a,c){c||(c=createjs.createCanvas?createjs.createCanvas():document.createElement("canvas"));c.width=Math.max(a.width,b.width);c.height=Math.max(a.height,b.height);var g=c.getContext("2d");g.save();g.drawImage(b,0,0);g.globalCompositeOperation="destination-in";g.drawImage(a,0,0);g.restore();return c};c._flip=function(b,
a,m,g){for(var d=b._images,e=c._workingCanvas,f=c._workingContext,h=d.length/a,k=0;k<h;k++){var j=d[k];j.__tmp=k;f.setTransform(1,0,0,1,0,0);f.clearRect(0,0,e.width+1,e.height+1);e.width=j.width;e.height=j.height;f.setTransform(m?-1:1,0,0,g?-1:1,m?j.width:0,g?j.height:0);f.drawImage(j,0,0);var l=new Image;l.src=e.toDataURL("image/png");l.width=j.width;l.height=j.height;d.push(l)}f=b._frames;e=f.length/a;for(k=0;k<e;k++){var j=f[k],n=j.rect.clone(),l=d[j.image.__tmp+h*a],q={image:l,rect:n,regX:j.regX,
regY:j.regY};m&&(n.x=l.width-n.x-n.width,q.regX=n.width-j.regX);g&&(n.y=l.height-n.y-n.height,q.regY=n.height-j.regY);f.push(q)}m="_"+(m?"h":"")+(g?"v":"");g=b._animations;b=b._data;d=g.length/a;for(k=0;k<d;k++){f=g[k];j=b[f];h={name:f+m,frequency:j.frequency,next:j.next,frames:[]};j.next&&(h.next+=m);f=j.frames;j=0;for(l=f.length;j<l;j++)h.frames.push(f[j]+e*a);b[h.name]=h;g.push(h.name)}};createjs.SpriteSheetUtils=c})();this.createjs=this.createjs||{};
(function(){var c=function(){this.initialize()},b=c.prototype;c.ERR_DIMENSIONS="frame dimensions exceed max spritesheet dimensions";c.ERR_RUNNING="a build is already running";b.maxWidth=2048;b.maxHeight=2048;b.spriteSheet=null;b.scale=1;b.padding=1;b.timeSlice=0.3;b.progress=-1;b.onComplete=null;b.onProgress=null;b.addEventListener=null;b.removeEventListener=null;b.removeAllEventListeners=null;b.dispatchEvent=null;b.hasEventListener=null;b._listeners=null;createjs.EventDispatcher.initialize(b);b._frames=
null;b._animations=null;b._data=null;b._nextFrameIndex=0;b._index=0;b._timerID=null;b._scale=1;b.initialize=function(){this._frames=[];this._animations={}};b.addFrame=function(a,b,g,d,e,f){if(this._data)throw c.ERR_RUNNING;b=b||a.bounds||a.nominalBounds;!b&&a.getBounds&&(b=a.getBounds());if(!b)return null;g=g||1;return this._frames.push({source:a,sourceRect:b,scale:g,funct:d,params:e,scope:f,index:this._frames.length,height:b.height*g})-1};b.addAnimation=function(a,b,g,d){if(this._data)throw c.ERR_RUNNING;
this._animations[a]={frames:b,next:g,frequency:d}};b.addMovieClip=function(a,b,g){if(this._data)throw c.ERR_RUNNING;var d=a.frameBounds,e=b||a.bounds||a.nominalBounds;!e&&a.getBounds&&(e=a.getBounds());if(!e&&!d)return null;b=this._frames.length;for(var f=a.timeline.duration,h=0;h<f;h++)this.addFrame(a,d&&d[h]?d[h]:e,g,function(a){var b=this.actionsEnabled;this.actionsEnabled=!1;this.gotoAndStop(a);this.actionsEnabled=b},[h],a);h=a.timeline._labels;a=[];for(var k in h)a.push({index:h[k],label:k});
if(a.length){a.sort(function(a,b){return a.index-b.index});h=0;for(k=a.length;h<k;h++){g=a[h].label;for(var d=b+(h==k-1?f:a[h+1].index),e=[],j=b+a[h].index;j<d;j++)e.push(j);this.addAnimation(g,e,!0)}}};b.build=function(){if(this._data)throw c.ERR_RUNNING;for(this._startBuild();this._drawNext(););this._endBuild();return this.spriteSheet};b.buildAsync=function(a){if(this._data)throw c.ERR_RUNNING;this.timeSlice=a;this._startBuild();var b=this;this._timerID=setTimeout(function(){b._run()},50-50*Math.max(0.01,
Math.min(0.99,this.timeSlice||0.3)))};b.stopAsync=function(){clearTimeout(this._timerID);this._data=null};b.clone=function(){throw"SpriteSheetBuilder cannot be cloned.";};b.toString=function(){return"[SpriteSheetBuilder]"};b._startBuild=function(){var a=this.padding||0;this.progress=0;this.spriteSheet=null;this._index=0;this._scale=this.scale;var b=[];this._data={images:[],frames:b,animations:this._animations};var g=this._frames.slice();g.sort(function(a,b){return a.height<=b.height?-1:1});if(g[g.length-
1].height+2*a>this.maxHeight)throw c.ERR_DIMENSIONS;for(var d=0,e=0,f=0;g.length;){var h=this._fillRow(g,d,f,b,a);h.w>e&&(e=h.w);d+=h.h;if(!h.h||!g.length){var k=createjs.createCanvas?createjs.createCanvas():document.createElement("canvas");k.width=this._getSize(e,this.maxWidth);k.height=this._getSize(d,this.maxHeight);this._data.images[f]=k;h.h||(e=d=0,f++)}}};b._getSize=function(a,b){for(var c=4;Math.pow(2,++c)<a;);return Math.min(b,Math.pow(2,c))};b._fillRow=function(a,b,g,d,e){var f=this.maxWidth,
h=this.maxHeight;b+=e;for(var h=h-b,k=e,j=0,l=a.length-1;0<=l;l--){var n=a[l],q=this._scale*n.scale,p=n.sourceRect,s=n.source,r=Math.floor(q*p.x-e),u=Math.floor(q*p.y-e),t=Math.ceil(q*p.height+2*e),p=Math.ceil(q*p.width+2*e);if(p>f)throw c.ERR_DIMENSIONS;t>h||k+p>f||(n.img=g,n.rect=new createjs.Rectangle(k,b,p,t),j=j||t,a.splice(l,1),d[n.index]=[k,b,p,t,g,Math.round(-r+q*s.regX-e),Math.round(-u+q*s.regY-e)],k+=p)}return{w:k,h:j}};b._endBuild=function(){this.spriteSheet=new createjs.SpriteSheet(this._data);
this._data=null;this.progress=1;this.onComplete&&this.onComplete(this);this.dispatchEvent("complete")};b._run=function(){for(var a=50*Math.max(0.01,Math.min(0.99,this.timeSlice||0.3)),b=(new Date).getTime()+a,c=!1;b>(new Date).getTime();)if(!this._drawNext()){c=!0;break}if(c)this._endBuild();else{var d=this;this._timerID=setTimeout(function(){d._run()},50-a)}a=this.progress=this._index/this._frames.length;this.onProgress&&this.onProgress(this,a);this.dispatchEvent({type:"progress",progress:a})};b._drawNext=
function(){var a=this._frames[this._index],b=a.scale*this._scale,c=a.rect,d=a.sourceRect,e=this._data.images[a.img].getContext("2d");a.funct&&a.funct.apply(a.scope,a.params);e.save();e.beginPath();e.rect(c.x,c.y,c.width,c.height);e.clip();e.translate(Math.ceil(c.x-d.x*b),Math.ceil(c.y-d.y*b));e.scale(b,b);a.source.draw(e);e.restore();return++this._index<this._frames.length};createjs.SpriteSheetBuilder=c})();this.createjs=this.createjs||{};
(function(){var c=function(a){this.initialize(a)},b=c.prototype=new createjs.DisplayObject;b.htmlElement=null;b._oldMtx=null;b.DisplayObject_initialize=b.initialize;b.initialize=function(a){"string"==typeof a&&(a=document.getElementById(a));this.DisplayObject_initialize();this.mouseEnabled=!1;this.htmlElement=a;a=a.style;a.position="absolute";a.transformOrigin=a.WebkitTransformOrigin=a.msTransformOrigin=a.MozTransformOrigin=a.OTransformOrigin="0% 0%"};b.isVisible=function(){return null!=this.htmlElement};
b.draw=function(){if(null!=this.htmlElement){var a=this.getConcatenatedMatrix(this._matrix),b=this.htmlElement.style;if(this.visible)b.visibility="visible";else return!0;var c=this._oldMtx||{};c.alpha!=a.alpha&&(b.opacity=""+a.alpha,c.alpha=a.alpha);if(c.tx!=a.tx||c.ty!=a.ty||c.a!=a.a||c.b!=a.b||c.c!=a.c||c.d!=a.d)b.transform=b.WebkitTransform=b.OTransform=b.msTransform=["matrix("+a.a,a.b,a.c,a.d,a.tx+0.5|0,(a.ty+0.5|0)+")"].join(),b.MozTransform=["matrix("+a.a,a.b,a.c,a.d,(a.tx+0.5|0)+"px",(a.ty+
0.5|0)+"px)"].join(),this._oldMtx=a.clone();return!0}};b.cache=function(){};b.uncache=function(){};b.updateCache=function(){};b.hitTest=function(){};b.localToGlobal=function(){};b.globalToLocal=function(){};b.localToLocal=function(){};b.clone=function(){throw"DOMElement cannot be cloned.";};b.toString=function(){return"[DOMElement (name="+this.name+")]"};b.DisplayObject__tick=b._tick;b._tick=function(a){this.htmlElement.style.visibility="hidden";this.DisplayObject__tick(a)};createjs.DOMElement=c})();this.createjs=this.createjs||{};(function(){var c=function(){this.initialize()},b=c.prototype;b.initialize=function(){};b.getBounds=function(){return new createjs.Rectangle(0,0,0,0)};b.applyFilter=function(){};b.toString=function(){return"[Filter]"};b.clone=function(){return new c};createjs.Filter=c})();this.createjs=this.createjs||{};
(function(){var c=function(){throw"Touch cannot be instantiated";};c.isSupported=function(){return"ontouchstart"in window||window.navigator.msPointerEnabled};c.enable=function(b,a,m){if(!b||!b.canvas||!c.isSupported())return!1;b.__touch={pointers:{},multitouch:!a,preventDefault:!m,count:0};"ontouchstart"in window?c._IOS_enable(b):window.navigator.msPointerEnabled&&c._IE_enable(b);return!0};c.disable=function(b){b&&("ontouchstart"in window?c._IOS_disable(b):window.navigator.msPointerEnabled&&c._IE_disable(b))};
c._IOS_enable=function(b){var a=b.canvas,m=b.__touch.f=function(a){c._IOS_handleEvent(b,a)};a.addEventListener("touchstart",m,!1);a.addEventListener("touchmove",m,!1);a.addEventListener("touchend",m,!1);a.addEventListener("touchcancel",m,!1)};c._IOS_disable=function(b){var a=b.canvas;a&&(b=b.__touch.f,a.removeEventListener("touchstart",b,!1),a.removeEventListener("touchmove",b,!1),a.removeEventListener("touchend",b,!1),a.removeEventListener("touchcancel",b,!1))};c._IOS_handleEvent=function(b,a){if(b){b.__touch.preventDefault&&
a.preventDefault&&a.preventDefault();for(var c=a.changedTouches,g=a.type,d=0,e=c.length;d<e;d++){var f=c[d],h=f.identifier;f.target==b.canvas&&("touchstart"==g?this._handleStart(b,h,a,f.pageX,f.pageY):"touchmove"==g?this._handleMove(b,h,a,f.pageX,f.pageY):("touchend"==g||"touchcancel"==g)&&this._handleEnd(b,h,a))}}};c._IE_enable=function(b){var a=b.canvas,m=b.__touch.f=function(a){c._IE_handleEvent(b,a)};a.addEventListener("MSPointerDown",m,!1);window.addEventListener("MSPointerMove",m,!1);window.addEventListener("MSPointerUp",
m,!1);window.addEventListener("MSPointerCancel",m,!1);b.__touch.preventDefault&&(a.style.msTouchAction="none");b.__touch.activeIDs={}};c._IE_disable=function(b){var a=b.__touch.f;window.removeEventListener("MSPointerMove",a,!1);window.removeEventListener("MSPointerUp",a,!1);window.removeEventListener("MSPointerCancel",a,!1);b.canvas&&b.canvas.removeEventListener("MSPointerDown",a,!1)};c._IE_handleEvent=function(b,a){if(b){b.__touch.preventDefault&&a.preventDefault&&a.preventDefault();var c=a.type,
g=a.pointerId,d=b.__touch.activeIDs;if("MSPointerDown"==c)a.srcElement==b.canvas&&(d[g]=!0,this._handleStart(b,g,a,a.pageX,a.pageY));else if(d[g])if("MSPointerMove"==c)this._handleMove(b,g,a,a.pageX,a.pageY);else if("MSPointerUp"==c||"MSPointerCancel"==c)delete d[g],this._handleEnd(b,g,a)}};c._handleStart=function(b,a,c,g,d){var e=b.__touch;if(e.multitouch||!e.count){var f=e.pointers;f[a]||(f[a]=!0,e.count++,b._handlePointerDown(a,c,g,d))}};c._handleMove=function(b,a,c,g,d){b.__touch.pointers[a]&&
b._handlePointerMove(a,c,g,d)};c._handleEnd=function(b,a,c){var g=b.__touch,d=g.pointers;d[a]&&(g.count--,b._handlePointerUp(a,c,!0),delete d[a])};createjs.Touch=c})();(function(){var c=this.createjs=this.createjs||{},c=c.EaselJS=c.EaselJS||{};c.version="NEXT";c.buildDate="Thu, 09 May 2013 18:21:47 GMT"})();

    return this.createjs;
  }
}());

var ChartAPI = (function (global, $) {
  "use strict";
  var jQuery = $;
  var ChartAPI = {};
  var MT = global.MT = global.MT || {};
  MT.ChartAPI = ChartAPI;

  ChartAPI.Data = {};

/**
 * return back cloned data to callback.
 * @param {!jQuery} jQuery ajax/deffered object
 * @param {=jQuery} jQuery objecto of container element to attach ajax response status message which is required when this keyword has context(not null).
 * @param {Function} callback function
 * @param {=Object} current context
 * @return {object}
 */
ChartAPI.Data.getData = function (obj, $container, callback, that) {
  var cloneData, status, def, errorClassName;
  if (obj) {
    obj.done(function (data) {
      if (!cloneData) {
        if (typeof data === 'string') {
          cloneData = data.toString();
        } else if (Array.isArray(data)) {
          cloneData = jQuery.map(data, function (v) {
            return jQuery.extend({}, v);
          });
        } else {
          cloneData = jQuery.extend({}, data);
        }
      }
      callback(cloneData);
    })
      .fail(function (e) {
      status = {
        '404': 'Data is not found',
        '403': 'Data is forbidden to access'
      };
      def = 'Some error occurred in the data fetching process';
      errorClassName = e.status ? 'error-' + e.status : 'error-unknown';
      if (that) {
        that.$errormsg = jQuery('<div class="error ' + errorClassName + '">' + (status[e.status] || def) + '</div>')
          .appendTo($container);
      }
    })
      .always(function () {
      if (that && that.$progress && that.$progress.parent().length > 0) {
        that.$progress.remove();
      }
    })
      .progress(function () {
      if (that && (!that.$progress || that.$progress.parent().length === 0)) {
        that.$progress = jQuery('<div class="progress">fetching data...</div>')
          .appendTo($container);
      }
    });
  }
};
/**
 * @param {!object} JSON data to filter
 * @param {!Date|number} maximum threshold value for filtering
 * @param {!Date|number} minimum threshold value for filtering
 * @param {!string} graph unit type (yearly|quater|monthly|weekly|daily|hourly)
 * @param {=number} the number of set of Y data
 * @param {boolean} true if you do not want to unify data into a weekly data.
 * @return {object} filtered JSON data
 */
ChartAPI.Data.filterData = function (data, max, min, u, yLength, noConcat) {
  var str, hash = {};

  yLength = yLength || 1;
  jQuery.each(data, function (i, v) {
    var td, key;
    td = ChartAPI.Date.parse(v.x);
    if (td && td >= min && td <= max) {
      if (noConcat) {
        key = ChartAPI.Date.createId(td, 'daily');
        hash[key] = v;
      } else {
        if (u === 'weekly') {
          td = ChartAPI.Date.getWeekStartday(td);
        }
        key = ChartAPI.Date.createId(td, u);
        if (hash[key]) {
          for (i = 0; i < yLength; i++) {
            str = i ? 'y' + i : 'y';
            hash[key][str] = parseInt(hash[key][str], 10) + parseInt(v[str], 10);
          }
        } else { /* clone the object to prevent changing original */
          hash[key] = jQuery.extend({}, v);
        }
      }
    }
  });
  return hash;
};

  ChartAPI.Date = {};

/**
 * return the week start day
 * @param {!Date}
 * @return Date
 */
ChartAPI.Date.getWeekStartday = function (d) {
  return new Date(d.getFullYear(), d.getMonth(), d.getDate() - d.getDay());
};

/**
 * return Date string array with padding zero which is for ISO 8601 string
 * @param {!Date}
 * @param {!string} unit type (yearly|quarter|monthly|weekly|daily|hourly)
 * @return {Array.<string>}
 */
ChartAPI.Date.zeroPadArray = function (d, unit) {
  var array;
  ({
    'yearly': function () {
      array = [d.getFullYear()];
    },
    'monthly': function () {
      array = [d.getFullYear(), d.getMonth() + 1];
    },
    'quarter': function () {
      array = [d.getFullYear(), d.getMonth() + 1];
    },
    'weekly': function () {
      array = [d.getFullYear(), d.getMonth() + 1, d.getDate() - d.getDay()];
    },
    'daily': function () {
      array = [d.getFullYear(), d.getMonth() + 1, d.getDate()];
    },
    'hourly': function () {
      array = [d.getFullYear(), d.getMonth() + 1, d.getDate(), d.getHours()];
    }
  })[unit]();
  return jQuery.map(array, function (v) {
    v = v.toString();
    return v.length === 1 ? '0' + v : v;
  });
};

/**
 * return uniformalized Date string to use kinds of Date ID
 * @param {!Date}
 * @param {!string} unit type (yearly|quarter|monthly|weekly|daily|hourly)
 * @return {string}
 */
ChartAPI.Date.createId = function (d, u) {
  return ChartAPI.Date.zeroPadArray(d, u).join('');
};

/**
 * return uniformalized Date string to use kinds of Date label
 * @param {!Date}
 * @param {!string} unit type (yearly|quarter|monthly|weekly|daily|hourly)
 * @return {string}
 */
ChartAPI.Date.createXLabel = function (d, u) {
  var hour, str, array = ChartAPI.Date.zeroPadArray(d, u);
  if (u === 'hourly') {
    hour = array.pop();
    str = array.join('-') + ' ' + hour + ':00';
  } else {
    str = array.join('-');
  }
  return str;
};

/**
 * parse argument and return back Date object
 * reformeded date string and try again when Date.parser returns NaN or Invalid
 * @param {Date|number|string|null}
 * @return {Date|null}
 */
ChartAPI.Date.parse = function (d) {
  var date;
  if (!d || d instanceof Date) {
    date = d || null;
  } else if (typeof d === 'number') {
    date = new Date(d);
  } else {
    date = new Date(Date.parse(d.toString()));
  }
  if (date && /NaN|Invalid Date/.test(date.toString())) {
    date = d.replace(/-/g, '/').split('+')[0];
    if (date.split('/').length === 1) {
      // parse the string like 20130305T00:00:00
      date = d.match(/([0-9]{4})([0-9]{1,2})([0-9]{1,2})/);
      date = [date[1], date[2], date[3]].join('/');
    }
    if (date.split('/').length === 2) {
      date = date + '/01';
    }
    date = jQuery.each(date.split('/'), function (i, v) {
      return v.length === 1 ? '0' + v : v;
    }).join('/');
    date = new Date(Date.parse(date));
  }
  return date;
};

/**
 * @param {!Date}
 * @param {!number} number of data
 * @param {!string} unit type (yearly|quarter|monthly|weekly|daily|hourly)
 * @param {boolean} calculates as start date when true
 * @return {Date}
 */
ChartAPI.Date.calcDate = function (date, l, u, sym) {
  var y, m, d, h;
  y = date.getFullYear();
  m = date.getMonth();
  d = date.getDate();
  h = 0;
  l = l - 1;
  sym = sym ? -1 : 1;
  ({
    'yearly': function () {
      y = y + (sym * l);
    },
    'monthly': function () {
      m = m + (sym * l);
    },
    'quarter': function () {
      m = m + (sym * l * 4);
    },
    'weekly': function () {
      d = d + (sym * l * 7) - date.getDay();
    },
    'daily': function () {
      d = d + (sym * l);
    },
    'hourly': function () {
      h = date.getHours() + (sym * l);
    }
  })[u]();
  return new Date(y, m, d, h);
};

  ChartAPI.Range = {};
/**
 * return unified Range data object (plain object which does not have prototyped method)
 * @param {{start: string|number|Date|null, end: string|number|Date|null, length: string|number|null, maxLength: string|number|null, unit: string|null, dataType: string|null}}
 * @return {{start: Date, end: Date, length: number, maxLength: number, unit: string, dataType: string, max: Date|number, min: Date|number, isTimeline: boolean}}
 */
ChartAPI.Range.factory = function (obj) {
  var fn;
  obj = obj || {};
  obj.maxLength = obj.maxLength || 90;
  obj.dataType = obj.dataType || 'timeline';
  obj.isTimeline = ChartAPI.Range.isTimeline(obj.dataType);
  fn = obj.isTimeline ? ChartAPI.Range.calcDate : ChartAPI.Range.calcNum;
  return fn(obj.start, obj.end, obj.length, obj.maxLength, obj.unit, obj.dataType, obj.autoSized);
};

ChartAPI.Range.generate = ChartAPI.Range.factory;

/**
 * @param {string|null} data type
 * @return {boolean}
 */
ChartAPI.Range.isTimeline = function (dataType) {
  return !dataType || dataType === 'timeline';
};

/**
 * @param {=Date|null} start date
 * @param {=Date|null} end date
 * @param {=number|null} length: number of data from start date or end date. length is required when both start and end dates are null
 * @param {=number|null} maxinum length for data
 * @param {=string} unit type (yearly|quarter|monthly|weekly|daily|hourly)
 * @param {boolean} when true, auto caliculate length of data according to window width
 * @return {{start: Date, end: Date, length: number, maxLength: number, unit: string, dataType: string, max: Date|number, min: Date|number, isTimeline: boolean}}
 */
ChartAPI.Range.calcDate = function (s, e, length, maxLength, unit, dataType, autoSized) {
  unit = unit || 'monthly';
  length = length || (unit === 'hourly' ? 24 : 10);

  if (autoSized) {
    var width = jQuery(window).width();
    maxLength = Math.min(Math.ceil(width * 0.021875), maxLength);
    length = maxLength;
  }

  s = ChartAPI.Date.parse(s);
  e = ChartAPI.Date.parse(e);

  if (!s && !e) {
    e = ChartAPI.Range.getEndDate(new Date(), unit);
  }

  if (!s) {
    s = ChartAPI.Range.getStartDate(ChartAPI.Date.calcDate(e, length, unit, true), unit);
  }
  if (!e) {
    e = ChartAPI.Range.getEndDate(ChartAPI.Date.calcDate(s, length, unit, false), unit);
  }
  if (e > new Date()) {
    e = new Date();
  }
  if (s > e) {
    s = e;
  }
  length = ChartAPI.Range.getLength(s, e, unit);
  if (length > maxLength) {
    length = maxLength;
    s = ChartAPI.Date.calcDate(e, length, unit, true);
  }
  return {
    start: s,
    end: e,
    length: length,
    maxLength: maxLength,
    unit: unit,
    dataType: dataType,
    max: ChartAPI.Range.getEndDate(e, unit),
    min: ChartAPI.Range.getStartDate(s, unit),
    isTimeline: true
  };
};

/**
 * @param {=Date|null} start date
 * @param {=Date|null} end date
 * @param {=number|null} length: number of data from start date or end date. length is required when both start and end dates are null
 * @param {=number|null} maxinum length for data
 * @param {=string} unit type (yearly|quarter|monthly|weekly|daily|hourly)
 * @param {boolean} when true, auto caliculate length of data according to window width
 * @return {{start: Date, end: Date, length: number, maxLength: number, unit: string, dataType: string, max: Date|number, min: Date|number, isTimeline: boolean}}
 */
ChartAPI.Range.calcNum = function (s, e, length, maxLength, unit, dataType, autoSized) {
  length = length || 10;

  if (autoSized) {
    var width = jQuery(window).width();
    maxLength = Math.min(Math.ceil(width * 0.021875), maxLength);
    length = Math.min(length, maxLength);
  }

  if (!s && !e) {
    s = 0;
    e = length - 1;
  }

  s = parseInt(s, 10) || (s === 0 ? 0 : null);
  e = parseInt(e, 10) || (e === 0 ? 0 : null);

  if (s === null) {
    s = e - length;
    if (s < 0) {
      s = 0;
    }
  }
  if (e === null) {
    e = s + length;
  }
  if (s > e) {
    s = e;
  }
  length = e - s + 1;
  if (length > maxLength) {
    length = maxLength;
    s = e - maxLength;
  }
  return {
    start: s,
    end: e,
    length: length,
    maxLength: maxLength,
    dataType: dataType,
    unit: null,
    max: e,
    min: s,
    isTimeline: false
  };
};

/**
 * return start date within the date's unit range
 * @param {!Date}
 * @param {!string} unit type (yearly|quarter|monthly|weekly|daily|hourly)
 * @return {Date}
 */
ChartAPI.Range.getStartDate = function (d, unit) {
  var start, year = d.getFullYear(),
    month = d.getMonth(),
    date = d.getDate();
  ({
    'yearly': function () {
      start = new Date(year, 0, 1, 0, 0, 0);
    },
    'monthly': function () {
      start = new Date(year, month, 1, 0, 0, 0);
    },
    'quarter': function () {
      start = new Date(year, month, 1, 0, 0, 0);
    },
    'weekly': function () {
      start = new Date(year, month, date - d.getDay(), 0, 0, 0);
    },
    'daily': function () {
      start = new Date(year, month, date, 0, 0, 0);
    },
    'hourly': function () {
      start = new Date(year, month, date, d.getHours(), 0, 0);
    }
  })[unit]();
  return start;
};

/**
 * return end date within the date's unit range
 * @param {!Date}
 * @param {!string} unit type (yearly|quarter|monthly|weekly|daily|hourly)
 * @return {Date}
 */
ChartAPI.Range.getEndDate = function (d, unit) {
  var end, year = d.getFullYear(),
    month = d.getMonth(),
    date = d.getDate();
  ({
    'yearly': function () {
      end = new Date(year, 11, 31, 23, 59, 59);
    },
    'monthly': function () {
      end = new Date(new Date(year, month + 1, 1, 0, 0, 0).valueOf() - 1);
    },
    'quarter': function () {
      end = new Date(new Date(year, month + 1, 1, 0, 0, 0).valueOf() - 1);
    },
    'weekly': function () {
      end = new Date(year, month, date - d.getDay() + 6, 23, 59, 59);
    },
    'daily': function () {
      end = new Date(year, month, date, 23, 59, 59);
    },
    'hourly': function () {
      end = new Date(year, month, date, d.getHours(), 0, 0);
    }
  })[unit]();
  return end < new Date() ? end : new Date();
};

/**
 * return next date against the desinated range unit
 * @param {Date} start date
 * @param {Date} end date
 * @param {number} increment number from start date
 * @param {string} data u
 * @return {Date}
 */
ChartAPI.Range.getNextDate = function (s, e, i, u) {
  var d, year = s.getFullYear(),
    month = s.getMonth(),
    date = s.getDate();
  ({
    'yearly': function (i) {
      d = new Date(year + i, 0, 1);
    },
    'monthly': function (i) {
      d = new Date(year, month + i, 1);
    },
    'quarter': function (i) {
      d = new Date(year, month + i * 4, 1);
    },
    'weekly': function (i) {
      d = new Date(year, month, date + i * 7 - s.getDay());
    },
    'daily': function (i) {
      d = new Date(year, month, date + i);
    },
    'hourly': function (i) {
      d = new Date(year, month, date, s.getHours() + i);
    }
  })[u](i);
  return d < e ? d : null;
};

/**
 * return max and min value in JSON data
 * @param {!object} JSON data
 * @param {=boolean} true when data type is timeline
 * @return {{max:number, min:number}}
 */
ChartAPI.Range.getDataRange = function (data, isTimeline) {
  var map, max, min;

  if (isTimeline) {
    map = jQuery.map(data, function (v) {
      return ChartAPI.Date.parse(v.x)
        .valueOf();
    });
    max = Math.max.apply(null, map);
    min = Math.min.apply(null, map);
  } else {
    min = 0;
    max = data.length - 1;
  }

  return {
    max: max,
    min: min
  };
};

/**
 * return number of data between start and end date
 * @param {!Date}
 * @param {!Date}
 * @param {!string} unit type (yearly|quarter|monthly|weekly|daily|hourly)
 * @param {number}
 */
ChartAPI.Range.getLength = function (s, e, u) {
  var length;
  ({
    'yearly': function () {
      length = Math.ceil(e.getFullYear() - s.getFullYear());
    },
    'monthly': function () {
      length = Math.ceil(e.getFullYear() * 12 + e.getMonth() - (s.getFullYear() * 12 + s.getMonth()));
    },
    'quarter': function () {
      length = Math.ceil((e.getFullYear() * 12 + e.getMonth() - (s.getFullYear() * 12 + s.getMonth())) / 4);
    },
    'weekly': function () {
      length = Math.ceil((ChartAPI.Date.getWeekStartday(e) - ChartAPI.Date.getWeekStartday(s)) / (7 * 24 * 60 * 60 * 1000));
    },
    'daily': function () {
      length = Math.ceil((e - s) / (24 * 60 * 60 * 1000));
    },
    'hourly': function () {
      length = Math.ceil((e - s) / (60 * 60 * 1000));
    }
  })[u]();
  return length > 0 ? length + 1 : 1;
};

  /**
 * Creates Graph Object
 * If you want to draw graph, fire APPEND_GRAPH event for its container Element like this
 * $container is the jQuery object to which the graph append
 * $('#graphContainer').trigger('APPEND_TO',[$container])
 * you want to update graph as well, fire UPDATE event like the same manner above.
 *
 * @param {object} graph setings
 * @param {object} object including range settings
 * @return {jQuery} return container jQuery object
 * @constructor
 */
ChartAPI.Graph = function (config, range) {
  this.config = $.extend({
    type: 'morris.bar',
    staticPath: '',
    data: 'graph.json'
  }, config);

  this.config.id = 'graph-' + (new Date()).valueOf() + Math.floor(Math.random() * 100);
  this.config.yLength = parseInt(this.config.yLength, 10) || 1;

  this.range = ChartAPI.Range.generate(range);

  if (typeof this.config.data === 'string') {
    this.origData_ = $.getJSON(this.config.staticPath + this.config.data);
  } else {
    this.origData_ = $.Deferred();
    this.origData_.resolve(this.config.data);
  }

  this.graphData = {};
  this.graphData[this.range.unit] = $.Deferred();

  this.getData($.proxy(function (data) {
    this.graphData[this.range.unit].resolve(this.generateGraphData(data));
  }, this));

  this.$graphContainer = $('<div id="' + this.config.id + '-container" class="graph-container">');

  /**
   * @return {jQuery} return jQuery object for chaining
   * update graph
   */
  this.$graphContainer.on('UPDATE', $.proxy(function (e, newRange, unit) {
    this.update_(newRange, unit);
    return $(this.$graphContainer);
  }, this));

  this.$graphContainer.on('REMOVE', $.proxy(function () {
    this.remove_();
  }, this));

  // IE8 fires resize event even when document.body.innerWidht/innerHeight changing
  // so check window.width and update only when window.width changing.
  var windowWidth = $(window).width();
  this.updateFunc = $.proxy(function () {
    if (windowWidth && windowWidth !== $(window).width()) {
      windowWidth = $(window).width();
      this.update_();
    }
  }, this);

  if (config.autoResize) {
    $(window).on('orientationchange debouncedresize', this.updateFunc);
  }

  /**
   * @return {jQuery} return jQuery object for chaining
   * return back the graph data range to callback
   */
  this.$graphContainer.on('GET_DATA_RANGE', $.proxy(function (e, callback) {
    $.proxy(this.getData($.proxy(function (data) {
      callback(ChartAPI.Range.getDataRange(data, this.range.isTimeline));
    }, this), this));
    return $(this.$graphContainer);
  }, this));

  /**
   * @return {jQuery} return jQuery object for chaining
   * return back the graph label array to callback
   */
  this.$graphContainer.on('GET_LABEL', $.proxy(function (e, indexArray, callback) {
    $.proxy(this.getData($.proxy(function (data) {
      callback(this.getDataLabelByIndex(indexArray, data));
    }, this), this));
    return $(this.$graphContainer);
  }, this));

  /**
   * append graph container to the desinated container
   * @return {jQuery} return jQuery object for chaining
   */
  this.$graphContainer.on('APPEND_TO', $.proxy(function (e, container) {
    this.$graphContainer.appendTo(container);
    this.graphData[this.range.unit].done($.proxy(function (data) {
      var filteredData;
      if (this.range.isTimeline) {
        filteredData = $.grep(data, $.proxy(function (v) {
          return this.range.start <= v.timestamp && v.timestamp <= this.range.end;
        }, this));
      } else {
        filteredData = data.slice(this.range.min, this.range.max + 1);
      }
      this.draw_(filteredData);
    }, this));
    return $(this.$graphContainer);
  }, this));

  return this.$graphContainer;
};

/**
 * call getData function for getting graph JSON data
 * @param {Function} callback function recieve graph JSON data
 */
ChartAPI.Graph.prototype.getData = function (callback) {
  ChartAPI.Data.getData(this.origData_, this.$graphContainer, callback, this);
};

/**
 * return data label array with array indexes
 * @param {!Array.<number>} array of indexes
 * @param {!Array.<object>} graph JSON data
 * @return {Array.<string>}
 */
ChartAPI.Graph.prototype.getDataLabelByIndex = function (indexArray, data) {
  var label = this.config.dataLabel || 'x';
  return $.map(indexArray, function (i) {
    return data[i][label];
  });
};

/**
 * get total count of desinated Y data set.
 * @param {!object} graph JSON data
 * @param {!number} the number of set of Y data
 * @return {number} return the number of total count in current range
 */
ChartAPI.Graph.prototype.getTotalCount_ = function (data, index) {
  var total = 0,
    str = 'y' + (index || '');
  $.each(data, function (i, v) {
    total = total + parseInt((v[str] || v.value || 0), 10);
  });
  return total;
};

/**
 * return the delta number and className between last and last second count
 * @param {!object} graph JSON data
 * @param {!number} number of set of Y data
 * @return {y:[number,string],y1:[number,string]}
 */
ChartAPI.Graph.prototype.getDelta_ = function (data, index) {
  var e, s, delta, key, length = data.length;

  key = 'y' + (index || '');
  e = data[length - 1];
  s = data[length - 2];
  delta = (s && e && s[key]) ? e[key] - s[key] : e[key];
  return delta === undefined ? '' : delta;
};

ChartAPI.Graph.presetColors = function () {
  return ['#6AAC2B', '#FFBE00', '#CF6DD3', '#8F2CFF', '#2D85FF', '#5584D4', '#5ED2B8', '#9CCF41', '#F87085', '#2C8087', '#8EEC6A', '#FFE700', '#FF5E19', '#FF4040', '#976BD6', '#503D99', '#395595'];
};

ChartAPI.Graph.getChartColors = function (colors, type) {
  var func = {
    'reverse': function (arr) {
      return arr.reverse();
    },
    'shuffle': function (arr) {
      var i, j, length, tmp;
      length = arr.length;
      for (i = 0; i < length; i++) {
        j = Math.floor(Math.random() * length);
        tmp = arr[i];
        arr[i] = arr[j];
        arr[j] = tmp;
      }
      return arr;
    },
    'def': function (arr) {
      return arr;
    }
  };
  return func[(type || 'def')](colors || ChartAPI.Graph.presetColors());
};

ChartAPI.Graph.cachedChartColors = {};
ChartAPI.Graph.getCachedChartColors = function (graphId, colors, type) {
  return ChartAPI.Graph.cachedChartColors[graphId] = ChartAPI.Graph.cachedChartColors[graphId] || ChartAPI.Graph.getChartColors(colors, type);
};

/**
 * Draw Graph
 * @param {!Array.<object>} graph data
 * @param {=string} graph type (bar|line|area|donut)
 * @return nothing
 */
ChartAPI.Graph.prototype.draw_ = function (data) {
  var arr = this.config.type.split('.');
  var lib = arr[0];
  var method = arr[1];
  var config = this.config;

  if (config.label) {
    if (this.labelTemplate) {
      this.generateLabel(this.labelTemplate);
    } else {
      if (config.label.template) {
        var labelTemplate = config.label.template;
        if (window.require && typeof require === 'function') {
          var templateType = config.label.type;
          require([templateType + '!' + config.staticPath + labelTemplate], $.proxy(function (template) {
            this.labelTemplate = template;
            this.generateLabel(template);
          }, this));
        } else {
          var dfd = $.get(config.staticPath + labelTemplate, 'text');
          ChartAPI.Data.getData(dfd, this.$graphContainer, $.proxy(function (template) {
            this.labelTemplate = template;
            this.generateLabel(template);
          }, this));
        }
      } else {
        this.labelTemplate = '<span class="graph-label-label"></span>';
        this.generateLabel(this.labelTemplate);
      }
    }
  }

  if (config.fallback && config.fallback.test) {
    if (!ChartAPI.Graph.test[config.fallback.test]()) {
      arr = config.fallback.type.split('.');
      lib = arr[0];
      method = arr[1];
      config = $.extend(config, config.fallback);
    }
  }

  if (config.chartColors && typeof config.chartColors === 'string') {
    config.chartColors = config.chartColors.split(',');
  }

  this.graphObject = ChartAPI.Graph[lib][method](data, config, this.range, this.$graphContainer);
};

ChartAPI.Graph.test = {};

ChartAPI.Graph.test.canvas = function () {
  var elem = document.createElement('canvas');
  return elem.getContext && elem.getContext('2d');
};

ChartAPI.Graph.test.svg = function () {
  var ns = {
    'svg': 'http://www.w3.org/2000/svg'
  };
  return !!document.createElementNS && !! document.createElementNS(ns.svg, 'svg').createSVGRect;
};

/*
 * this test checks suport both VML and SVG since we only use VML for SVG fallback
 */
ChartAPI.Graph.test.vml = function () {
  var vmlSupported;
  var svgSupported = ChartAPI.Graph.test.svg();
  // http://stackoverflow.com/questions/654112/how-do-you-detect-support-for-vml-or-svg-in-a-browser
  if (!svgSupported) {
    var a = document.body.appendChild(document.createElement('div'));
    a.innerHTML = '<v:shape id="vml_flag1" adj="1" />';
    var b = a.firstChild;
    b.style.behavior = "url(#default#VML)";
    vmlSupported = b ? typeof b.adj === "object" : true;
    a.parentNode.removeChild(a);
  }
  return (svgSupported || vmlSupported);
};

ChartAPI.Graph.prototype.generateLabel = function (template) {
  var data = this.config.label.template && this.config.label.data ? this.config.label.data : {},
    yLength = this.config.label.yLength || this.config.yLength,
    dfd;

  var finalize = $.proxy(function () {
    this.labels = new ChartAPI.Graph.Labels(this.$graphContainer, yLength, template);

    this.getData($.proxy(function (data) {
      for (var i = 0; i < yLength; i++) {
        if (!this.config.label.hideTotalCount) {
          this.labels.getTotalObject(i).createTotalCount(this.getTotalCount_(data, i));
        }
        if (!this.config.label.hideDeltaCount && this.range.isTimeline) {
          this.labels.getTotalObject(i).createDeltaCount(this.getDelta_(data, i));
        }
      }
    }, this));
  }, this);

  if (data && typeof data === 'string') {
    dfd = $.getJSON(this.config.staticPath + data);
  } else {
    dfd = $.Deferred();
    dfd.resolve(data);
  }

  dfd.done(function (data) {
    if (template && typeof template === 'function') {
      template = template(data);
      finalize();
    } else if (window._) {
      template = _.template(template, data);
      finalize();
    } else {
      template = template;
      finalize();
    }
  });
};

/**
 * update Graph
 * @param {=Array.<number>}
 * @param {=string} graph unit type (yearly|quater|monthly|weekly|daily|hourly)
 */
ChartAPI.Graph.prototype.update_ = function (newRange, unit) {
  var that = this;
  newRange = newRange || [];
  if (this.graphObject && this.graphObject.remove) {
    this.graphObject.remove();
  }
  if (this.labels) {
    this.labels.remove();
  }
  this.range = ChartAPI.Range.generate({
    'start': (newRange[0] || this.range.start),
    'end': (newRange[1] || this.range.end),
    'length': null,
    'maxLength': this.range.maxLength,
    'unit': (unit || this.range.unit),
    'dataType': this.range.dataType,
    'autoSized': this.range.autoSized
  });

  this.graphData[this.range.unit].done($.proxy(function (data) {
    var filteredData;
    if (that.range.isTimeline) {
      filteredData = $.grep(data, $.proxy(function (v) {
        return this.range.min <= v.timestamp && v.timestamp <= this.range.max;
      }, this));
    } else {
      filteredData = data.slice(this.range.min, this.range.max + 1);
    }
    this.draw_(filteredData);
  }, this));
};

ChartAPI.Graph.prototype.remove_ = function () {
  if (this.config.autoResize) {
    $(window).off('orientationchange debouncedresize', this.updateFunc);
  }
  if (this.graphObject && this.graphObject.remove) {
    this.graphObject.remove();
  }
  if (this.labels) {
    this.labels.remove();
  }
  this.$graphContainer.remove();
};

ChartAPI.Graph.prototype.generateGraphData = function (data) {
  var i, j, td, key, range = this.range,
    start = range.start,
    end = range.end,
    u = range.unit,
    length = range.length,
    array = [],
    yLength = this.config.yLength || 1,
    filteredData, obj, str;
  if (this.range.isTimeline) {
    var dataRange = ChartAPI.Range.getDataRange(data, this.range.isTimeline);
    start = new Date(Math.min(this.range.min, dataRange.min));
    end = new Date(Math.max(this.range.max, dataRange.max));
    length = ChartAPI.Range.getLength(start, end, u);
    filteredData = ChartAPI.Data.filterData(data, dataRange.max, dataRange.min, u, yLength);

    for (i = 0; i < length; i++) {
      td = ChartAPI.Range.getNextDate(start, end, i, u);
      if (td) {
        key = ChartAPI.Date.createId(td, u);
        obj = {
          timestamp: td.valueOf(),
          x: ChartAPI.Date.createXLabel(td, u)
        };
        for (j = 0; j < yLength; j++) {
          str = 'y' + (j || '');
          obj[str] = filteredData[key] ? (filteredData[key][str] || 0) : 0;
        }
        array.push(obj);
      } else {
        break;
      }
    }
  } else {
    array = data;
  }
  if (this.config.type === 'morris.donut') {
    $.each(array, function (i, v) {
      $.extend(v, {
        label: (v.xLabel || v.x),
        value: v.y
      });
    });
  }
  return array;
};

  /**
 * @param {!jQuery}
 jQuery object to which attach label element(typically graph container)
 * @param {!number} length of set of data to use
 * @param {=string} html string to use label
 * @constructor
 */
ChartAPI.Graph.Labels = function ($container, yLength, template) {
  var i, key;

  this.$labelContainer = $('<div class = "graph-labels"></div>');
  if (template) {
    $('<div class="graph-label"></div>').html(template).prependTo(this.$labelContainer);
  }

  this.totals = {};
  for (i = 0; i < yLength; i++) {
    key = 'y' + (i || '');
    this.totals[key] = new ChartAPI.Graph.Labels.Total(this.$labelContainer, i);
  }

  this.$labelContainer.appendTo($container);
};

/**
 * remove label container
 */
ChartAPI.Graph.Labels.prototype.remove = function () {
  this.$labelContainer.remove();
};

/**
 * get ChartAPI.Graph.Labels.Total object
 * @param {=number} the number of Y data set
 * @return {ChartAPI.Graph.Labels.Total}
 */
ChartAPI.Graph.Labels.prototype.getTotalObject = function (i) {
  return this.totals['y' + (i || '')];
};

/**
 * @constructor
 * @param {!jQuery} jQuery object to attach
 * @param {!number} number for identify what Y data is associated with
 */
ChartAPI.Graph.Labels.Total = function (container, index) {
  this.index = index;
  this.$totalContainer = jQuery('<div class = "graph-total"></div>').appendTo(container);
};

/**
 * create element for displaying total count and append its container
 * @param {!number} total count
 */
ChartAPI.Graph.Labels.Total.prototype.createTotalCount = function (count) {
  jQuery('<span class="graph-total-count graph-total-count-y"' + (this.index || '') + '>' + count + '</span> ').appendTo(this.$totalContainer);
};

/**
 * create element for displaying delta
 * @param {!number} delta count
 */
ChartAPI.Graph.Labels.Total.prototype.createDeltaCount = function (delta) {
  var deltaClass = delta ? (delta < 0 ? 'minus ' : 'plus ') : 'zero ';

  jQuery('<span class="graph-delta graph-delta-y"' + (this.index || '') + '><span class="' + deltaClass + '">(' + delta + ')</span></span>').appendTo(this.$totalContainer);
};

  ChartAPI.Graph.css = {};

ChartAPI.Graph.css.Base = function (data, config) {
  this.len = data.length;
  this.$graphEl = $('<div id="' + config.id + '" class="css-graph">');
};

ChartAPI.Graph.css.Base.prototype.remove = function () {
  this.$graphEl.remove();
};

ChartAPI.Graph.css.Base.prototype.horizontalBar = function (data, config, range, $container) {
  if (config.width) {
    this.$graphEl.css({
      'width': config.width,
      'max-width': '100%',
      'margin': '0 auto'
    });
  }

  var barColor = config.barColor || ChartAPI.Graph.getCachedChartColors(config.id, null, config.chartColorsMethod)[1],
    barBackgroundColor = config.barBackgroundColor || '#f0f0f0',
    dateColor = config.dateColor || '#999999',
    dateColorSaturday = config.dateColorSaturday || dateColor,
    dateColorSunday = config.dateColorSunday || dateColor,
    labelColor = config.labelColor || '#999999',
    barWidth = parseInt(config.barWidth, 10) || 30,
    barMarginLeft = parseInt(config.barMarginLeft, 10) || 30,
    barInterval = parseInt(config.barInterval, 10) || 5,
    labelSize = parseInt(config.labelSize, 10) || barWidth * 0.45,
    dateLabelSize = parseInt(config.dateLabelSize, 10) || labelSize,
    createCSSGraphBarEl = function () {
      return $('<div class="css-graph-container"><div class="css-graph-date"></div><div class="css-graph-bar-container" style="height:' + barWidth + 'px; margin-bottom:' + barInterval + 'px"><div class="css-graph-bar"></div><div class="css-graph-bar-background"><div class="css-graph-bar-count"></div></div></div>');
    },
    dataY = $.map(data, function (d) {
      return parseInt(d.y, 10);
    }),
    label = $.map(data, function (d) {
      return {
        value: parseInt(d.x.substr(d.x.lastIndexOf('-') + 1), 10).toString(),
        weekday: ChartAPI.Date.parse(d.x) ? ChartAPI.Date.parse(d.x).getDay() : null
      }
    }),
    maxY = Math.max.apply(null, dataY) || 1,
    yLabel = config.yLabel || dataY,
    width, $el, $background, $bar, $count, $date;

  for (var i = this.len; i > 0;) {
    i = i - 1;
    width = Math.floor((dataY[i] / maxY) * 100) - 15;
    $el = createCSSGraphBarEl();
    $background = $el.find('.css-graph-bar-background');
    $background.css({
      'background-color': barBackgroundColor
    });

    if (config.showDate) {
      $date = $el.find('.css-graph-date');
      $date.text(label[i].value).css({
        'color': dateColor,
        'font-size': dateLabelSize + 'px',
        'line-height': barWidth + 'px'
      });
      if (label[i].weekday === 6) {
        $date.addClass('saturday').css({
          'color': dateColorSaturday
        });
      } else if (label[i].weekday === 0) {
        $date.addClass('sunday').css({
          'color': dateColorSunday
        })
      }

      $el.find('.css-graph-bar-container').css({
        'margin-left': barMarginLeft + 'px'
      });
    }

    $bar = $el.find('.css-graph-bar');
    $bar.css({
      'width': width + '%',
      'background-color': barColor
    });
    $count = $el.find('.css-graph-bar-count');
    $count.text(yLabel[i]).css({
      'color': labelColor,
      'font-size': labelSize + 'px',
      'line-height': barWidth + 'px'
    });
    $el.appendTo(this.$graphEl);
  }

  this.$graphEl.appendTo($container);
};

ChartAPI.Graph.css.Base.prototype.ratioHorizontalBar = function (data, config, range, $container) {
  var yLength = config.yLength,
    barWidth = parseInt(config.barWidth, 10) || 30,
    barMarginLeft = parseInt(config.barMarginLeft, 10) || 30,
    barInterval = parseInt(config.barInterval, 10) || 5,
    labelSize = parseInt(config.labelSize, 10) || barWidth * 0.45,
    dateColor = config.dateColor || '#999999',
    barColors = config.barColors || ChartAPI.Graph.getCachedChartColors(config.id, null, config.chartColorsMethod),
    labelColors = config.labelColors,
    labelClasses = config.labelClasses,
    i, j,
    d, dataY, totalY, $barContainer, $el, $bar, label, $date, width, totalWidth;

  for (i = 0; i < this.len; i++) {
    d = data[i];
    dataY = [];
    totalY = 0;
    totalWidth = 0;
    for (j = 0; j < yLength; j++) {
      dataY.push(d['y' + (j || '')]);
      totalY = totalY + parseInt(d['y' + (j || '')], 10);
    }

    $barContainer = $('<div class="css-graph-container"></div>').appendTo(this.$graphEl);
    if (config.showDate && d.x) {
      label = parseInt(d.x.substr(d.x.lastIndexOf('-') + 1), 10).toString();
      $date = $('<div class="css-graph-date" style="color:' + dateColor + ';font-size: ' + labelSize + 'px; line-height:' + barWidth + 'px">' + label + '</div>').appendTo($barContainer);
    }

    $el = $('<div class="css-graph-bar-container" style="height:' + barWidth + 'px; margin-bottom:' + barInterval + 'px"></div>').appendTo($barContainer);

    if (config.showDate) {
      $el.css({
        'margin-left': barMarginLeft + 'px'
      });
    }

    for (j = 0; j < yLength; j++) {
      width = Math.floor((dataY[j] / totalY) * 1000) / 10;

      if (width) {
        if (yLength === j) {
          width = 100 - totalWidth;
        }
        totalWidth = totalWidth + width;

        $bar = $('<div class="css-graph-y css-graph-y' + (j || '') + '" data-count="' + dataY[j] + '" style="line-height:' + barWidth + 'px; font-size:' + labelSize + 'px"></div>');
        $bar.css({
          'width': width + '%',
          'background-color': barColors[j]
        });

        if (config.showCount) {
          $bar.text(dataY[j]);
        }

        if (labelClasses && labelClasses[j]) {
          $bar.addClass(labelClasses[j]);
        }

        if (labelColors && labelColors[j]) {
          $bar.css({
            'color': labelColors[j]
          });
        }

        $bar.appendTo($el);
      }
    }

    $el.appendTo($barContainer);
  }
  this.$graphEl.appendTo($container);
};

ChartAPI.Graph.css.horizontalBar = ChartAPI.Graph.css.ratioHorizontalBar = function (data, config, range, $container) {
  var cssGraph = new ChartAPI.Graph.css.Base(data, config, range, $container);
  var method = config.type.slice(config.type.lastIndexOf('.') + 1);
  cssGraph[method](data, config, range, $container);
  return cssGraph;
};

  ChartAPI.Graph.easel = {};

ChartAPI.Graph.easel.Base = function (data, config, range, $container) {
  this.data = data;
  this.config = config;
  this.range = range;
  this.$container = $container;
  if (!window.createjs && typeof window.require === 'function') {
    require(['easeljs'], $.proxy(function () {
      this.buildCanvas(createjs);
    }, this));
  } else {
    var width = parseInt((config.width || $container.width()), 10);

    if (width) {
      this.buildCanvas(createjs);
    } else {
      setTimeout($.proxy(function () {
        this.buildCanvas(createjs);
      }, this), 100);
    }
  }
};

ChartAPI.Graph.easel.Base.prototype.buildCanvas = function (createjs) {
  this.width = parseInt((this.config.width || this.$container.width()), 10) || 300;
  this.height = parseInt((this.config.height || this.$container.height()), 10) || 300;

  this.$canvas = $('<canvas id="' + this.config.id + '" class="graph-canvas" width="' + this.width + '" height="' + this.height + '">').appendTo(this.$container);
  this.canvas = this.$canvas.get(0);
  this.canvas.getContext('2d');

  this.stage = this.graph = new createjs.Stage(this.canvas);
  this.stage.update();
  var method = this.config.type.split('.')[1];
  this[method](this.data, this.config);
};

ChartAPI.Graph.easel.Base.prototype.remove = function () {
  this.$canvas.remove();
};

ChartAPI.Graph.easel.Base.prototype.bar = function (data, config) {
  var length = data.length,
    barColorAlpha = config.chartColorsAlpha ? config.chartColorsAlpha[0] : 1,
    barColors = config.chartColors || ChartAPI.Graph.getCachedChartColors(config.id, null, config.chartColorsMethod),
    barColor = this.convertColor(barColors[0], barColorAlpha),
    barMargin = parseInt(config.barMargin, 10) || 10,
    barContentWidth = Math.floor(this.width / length),
    barWidth = barContentWidth - barMargin,
    leftMargin = Math.floor((this.width - (barContentWidth * length)) / 2) + barMargin / 2,
    dataY = $.map(data, function (d) {
      return parseInt(d.y, 10);
    }),
    maxY = Math.max.apply(null, dataY) || 1,
    shape,
    bar,
    x,
    y,
    barHeight;

  for (var i = 0; i < length; i++) {
    shape = new createjs.Shape();
    bar = shape.graphics;
    x = i * barContentWidth + leftMargin;
    barHeight = Math.floor(dataY[i] / maxY * this.height);
    y = this.height - barHeight;

    bar.beginFill(barColor).drawRect(x, y, barWidth, barHeight);
    this.stage.addChild(shape);
  }
  this.stage.update();
};

ChartAPI.Graph.easel.Base.prototype.motionLine = function (data, config) {
  var length = data.length,
    lineWidth = parseInt(config.lineWidth, 10) || 8,
    yLength = config.yLength || 1,
    lineColors = config.lineColors || config.chartColors || ChartAPI.Graph.getCachedChartColors(config.id, null, config.chartColorsMethod),
    lineColorsAlpha = config.chartColorsAlpha || [null],
    pointerColors = config.pointerColors || config.chartColors || ChartAPI.Graph.getCachedChartColors(config.id, null, config.chartColorsMethod),
    pointerColorsAlpha = config.pointerColorsAlpha || [null],
    pointerRadius = config.pointerRadius || 10,
    paddingTop = lineWidth / 2,
    paddingBottom = lineWidth / 2,
    count = (length - 1) * 2,
    moveX = Math.floor(this.width / length) / 2,
    paddingLeft = (this.width - (moveX * count)) / 2,
    height = this.height,
    canvasInnerHeight,
    dataYs = [],
    dataY,
    mapfunc = function (d) {
      return parseInt(d['y' + (i || '')], 10);
    };

  if (config.drawPointer) {
    paddingBottom = paddingBottom + pointerRadius;
  }

  canvasInnerHeight = this.height - (paddingTop + paddingBottom);

  for (var i = 0; i < yLength; i++) {
    dataY = $.map(data, mapfunc);
    dataYs.push(dataY);
  }

  var dataYAll = [];
  $.each(dataYs, function (i, dataY) {
    dataYAll = dataYAll.concat(dataY);
  });

  var maxY = Math.max.apply(null, dataYAll) || 1,
    moveYs = [];

  var generateMoveY = function (dataY) {
    var moveY = [];
    $.each(dataY, function (i, y) {
      if (i > 0) {
        var prevY = dataY[i - 1];
        var medium = prevY + Math.floor((y - prevY) / 2);

        medium = Math.floor((medium / maxY) * canvasInnerHeight) + paddingBottom;
        y = Math.floor((y / maxY) * canvasInnerHeight) + paddingBottom;
        moveY = moveY.concat([medium, y]);
      } else {
        y = Math.floor((y / maxY) * canvasInnerHeight) + paddingBottom;
        moveY.push(y);
      }
    });
    return moveY;
  };

  $.each(dataYs, function (i, dataY) {
    moveYs.push(generateMoveY(dataY));
  });

  var lineColor,
    shapes = [],
    lines = [],
    x = paddingLeft,
    y,
    circles = [],
    pointerColor;

  for (i = 0; i < yLength; i++) {
    lineColor = this.convertColor(lineColors[i], lineColorsAlpha[i]);
    shapes[i] = new createjs.Shape();
    lines[i] = shapes[i].graphics;
    y = height - moveYs[i][0];
    lines[i].setStrokeStyle(lineWidth).beginStroke(lineColor).moveTo(x, y);
    this.stage.addChild(shapes[i]);
    if (config.drawPointer) {
      pointerColor = this.convertColor(pointerColors[i], pointerColorsAlpha[i]);
      circles[i] = new createjs.Shape();
      circles[i].graphics.beginFill(pointerColor).drawCircle(0, 0, pointerRadius);
      this.stage.addChild(circles[i]);
    }
  }

  var stage = this.stage;

  var tick = function (e) {
    // if we are on the last frame of animation then remove the tick listener:
    count = count - 1;
    if (count === 0) {
      createjs.Ticker.removeEventListener("tick", tick);
    }

    x = x + moveX;

    var moveY;
    for (var i = 0; i < yLength; i++) {
      moveY = moveYs[i];
      y = height - moveY[moveY.length - count - 1];
      lines[i].lineTo(x, y);
      if (config.drawPointer) {
        circles[i].x = x;
        circles[i].y = Math.max(y, pointerRadius);
      }
    }

    stage.update(e);
  };

  createjs.Ticker.useRAF = true;
  createjs.Ticker.setFPS(30);
  createjs.Ticker.addEventListener('tick', tick);
};

ChartAPI.Graph.easel.Base.prototype.convertColor = function (str, alpha) {
  if (str.indexOf('#') !== -1) {
    var r = parseInt(str.substr(1, 2), 16),
      g = parseInt(str.substr(3, 2), 16),
      b = parseInt(str.substr(5, 2), 16);

    if (alpha) {
      str = 'rgba(' + [r, g, b, alpha].join(',') + ')';
    } else {
      str = 'rgb(' + [r, g, b].join(',') + ')';
    }
  } else if (str.indexOf('rgb') !== -1) {
    // wrap rgb/rgba string
    if (str.split(',').length < 4) {
      str = 'rgb(' + str + ')';
    } else {
      str = 'rgba(' + str + ')';
    }
  }
  return str;
};

ChartAPI.Graph.easel.Base.prototype.mix = function (data, config) {
  var count = 0;

  var splitData = function (length, data) {
    length = length || 1;
    var map = $.map(data, function (d) {
      var obj = {
        x: d.x
      }, key, val;

      for (var i = 0; i < length; i++) {
        key = 'y' + (i || '');
        val = 'y' + (count + i || '');
        obj[key] = d[val];
      }
      return obj;
    });
    count = count + length;
    return map;
  };

  var chartColors = config.chartColors || ChartAPI.Graph.getCachedChartColors(config.id, null, config.chartColorsMethod);

  $.each(config.mix, $.proxy(function (index, conf) {
    var colors = {
      chartColors: chartColors.slice(count, count + conf.yLength)
    };
    var partialData = splitData(conf.yLength, data);
    conf = $.extend({}, config, colors, conf);
    this[conf.type](partialData, conf);
  }, this));
};

ChartAPI.Graph.easel.bar = ChartAPI.Graph.easel.motionLine = ChartAPI.Graph.easel.mix = function (data, config, range, $container) {
  if (ChartAPI.Graph.test.canvas()) {
    var easelGraph = new ChartAPI.Graph.easel.Base(data, config, range, $container);
    return easelGraph;
  } else {
    console.warn('EaselJS graph requires for HTML5 Canvas capability');
    $container.trigger('REMOVE');
  }
};

  ChartAPI.Graph.morris = {};

ChartAPI.Graph.morris.Base = function (data, config, range, $container) {
  if (!window.Morris && typeof window.require === 'function') {
    require(['raphael', 'morris'], $.proxy(function () {
      this.build_(Morris, data, config, range, $container);
    }, this));
  } else {
    var width = config.width || $container.width();
    if (width) {
      this.build_(Morris, data, config, range, $container);
    } else {
      setTimeout($.proxy(function () {
        this.build_(Morris, data, config, range, $container);
      }, this), 100);
    }
  }
};

ChartAPI.Graph.morris.Base.prototype.build_ = function (Morris, data, config, range, $container) {
  var i,
    graphDefaults, graphConfig,
    method = config.type.split('.')[1],
    yLength = config.yLength,
    width = config.width || $container.width() || 300,
    height = config.height || $container.height() || 300;

  this.$graphEl = $('<div id="' + config.id + '" class="graph-element"></div>').css({
    'height': height + 'px',
    'width': width + 'px'
  }).prependTo($container);

  config = $.extend({}, config, {
    element: config.id,
    data: data,
    xkey: 'x',
    labels: this.getYLabels_(yLength, config.labels),
    ykeys: this.getYKeys_(yLength),
    ymax: this.getYMax_(data, method, yLength),
    ymin: config.ymin || 0,
    lineWidth: parseInt(config.lineWidth, 10) || 6,
    pointSize: parseInt(config.pointSize, 10) || 6,
    smooth: config.smooth || false
  });

  config.barColors = config.barColors || this.getChartColors(config);
  config.colors = config.colors || this.getChartColors(config);
  config.lineColors = config.lineColors || this.getChartColors(config);
  config.numLines = parseInt(config.numLines, 10) || this.getNumLines_(config.ymax, height);

  config.pointStrokeColors = config.pointStrokeColors ? config.pointStrokeColors.split(/,/) : [];
  if (!config.pointStrokeColors.length) {
    for (i = 0; i < yLength; i++) {
      config.pointStrokeColors.push('none');
    }
  }

  graphDefaults = {
    element: null,
    data: null,
    xkey: 'x',
    labels: [],
    ykeys: [],

    // gridDefaults
    dateFormat: null,
    axes: true,
    grid: true,
    gridLineColor: '#aaa',
    gridStrokeWidth: 0.5,
    gridTextColor: '#888',
    gridTextSize: 12,
    hideHover: false,
    hoverCallback: null,
    yLabelFormat: null,
    numLines: 5,
    padding: 25,
    parseTime: true,
    postUnits: '',
    preUnits: '',
    ymax: 'auto',
    ymin: 'auto 0',
    goals: [],
    goalStrokeWidth: 1.0,
    goalLineColors: ['#666633', '#999966', '#cc6666', '#663333'],
    events: [],
    eventStrokeWidth: 1.0,
    eventLineColors: ['#005a04', '#ccffbb', '#3a5f0b', '#005502'],

    // Line defaults
    lineWidth: 3,
    pointSize: 4,
    lineColors: ['#0b62a4', '#7A92A3', '#4da74d', '#afd8f8', '#edc240', '#cb4b4b', '#9440ed'],
    pointWidths: [1],
    pointStrokeColors: ['#ffffff'],
    pointFillColors: [],
    smooth: true,
    xLabels: 'auto',
    xLabelFormat: null,
    xLabelMargin: 50,
    continuousLine: true,

    // Bar defaults
    barSizeRatio: 0.75,
    barGap: 3,
    barColors: ['#0b62a4', '#7a92a3', '#4da74d', '#afd8f8', '#edc240', '#cb4b4b', '#9440ed'],

    // Donut defaults
    colors: ['#0B62A4', '#3980B5', '#679DC6', '#95BBD7', '#B0CCE1', '#095791', '#095085', '#083E67', '#052C48', '#042135'],
    backgroundColor: '#FFFFFF',
    labelColor: '#000000',
    formatter: Morris.commas
  };

  graphConfig = {};
  $.each(config, function (key, value) {
    if (graphDefaults[key] !== undefined) {
      graphConfig[key] = value;
    }
  });

  // IE8(VML) occurred error setting smooth false
  if (!ChartAPI.Graph.test.svg) {
    graphConfig.smooth = true;
  }

  // shows percentage as Y label when graph method is donut
  if (method === 'donut') {
    var totalCount = this.getTotalCount_(data, i);

    graphConfig.formatter = function (y) {
      var str = y = (y + '').replace(/,/g, '');
      if (!config.noCommaOnYLabel) {
        while (str != (str = str.replace(/^(-?\d+)(\d{3})/, '$1,$2')));
      }
      var percent = Math.ceil((y / totalCount * 10000)) / 100;

      var ret;
      if (config.donutsFormatter && typeof config.donutsFormatter === 'function') {
        ret = config.donutsFormatter(str, percent + '%', y);
      } else {
        ret = str + '(' + percent + '%)';
      }

      return ret;
    };
  }

  var M = ({
    'bar': Morris.Bar,
    'line': Morris.Line,
    'donut': Morris.Donut,
    'area': Morris.Area
  })[method];

  this.graph = new M(graphConfig);
};

/**
 * get maximum value among the desinated Y data set
 * @param {!Array.<object>} graph data to get max Y
 * @param {!number} number of set of Y data
 * @return {number} return the number of maxY for graph
 */
ChartAPI.Graph.morris.Base.prototype.getYMax_ = function (data, method, yLength) {
  var i, maxY, array, sum, key;

  if (method !== 'area') {
    array = [];
    $.each(data, function (index, value) {
      for (i = 0; i < yLength; i++) {
        key = 'y' + (i || '');
        array.push(parseInt(value[key], 10));
      }
    });
    maxY = Math.max.apply(null, array);
  } else {
    maxY = Math.max.apply(null, $.map(data, function (value) {
      sum = 0;
      for (i = 0; i < yLength; i++) {
        key = 'y' + (i || '');
        sum = sum + parseInt(value[key], 10);
      }
      return sum;
    }));
  }

  if (!maxY) {
    maxY = 1;
  }

  if (maxY % 2 !== 0) {
    maxY = maxY + 1;
  }

  return maxY;
};

ChartAPI.Graph.morris.Base.prototype.getChartColors = function (config) {
  if (!this.chartColors) {
    this.chartColors = config.chartColors || ChartAPI.Graph.getCachedChartColors(config.id, null, config.chartColorsMethod);
  }
  return this.chartColors;
};

/**
 * return YKeys array for graph setting
 * @param {!number} number of set of y data
 * @return {Array.<string>} array of y key strings
 */
ChartAPI.Graph.morris.Base.prototype.getYKeys_ = function (yLength) {
  var i, array = [];
  for (i = 0; i < yLength; i++) {
    array.push('y' + (i || ''));
  }
  return array;
};

/**
 * return YLables array for graph setting
 * @param {!number} number of set of y data
 * @return {Array.<string>} array of y key strings
 */
ChartAPI.Graph.morris.Base.prototype.getYLabels_ = function (yLength, yLabel) {
  var i, array = [];
  yLabel = yLabel ? yLabel.split(/,/) : [];
  for (i = 0; i < yLength; i++) {
    array.push((yLabel[i] || 'Count'));
  }
  return array;
};

/**
 * caliculate the number of horizental lines in graph
 * @param {!number} maximum value among the Y data set.
 * @return {number}
 */
ChartAPI.Graph.morris.Base.prototype.getNumLines_ = function (maxY, height) {
  var numlines;
  if (maxY >= 18) {
    numlines = 9;
  } else if (maxY === 2) {
    numlines = 3;
  } else {
    numlines = (maxY / 2) + 1;

  }
  numlines = Math.min((numlines || 1), Math.floor(height / 56));

  return numlines;
};

/**
 * get total count of desinated Y data set.
 * @param {!object} graph JSON data
 * @param {!number} the number of set of Y data
 * @return {number} return the number of total count in current range
 */
ChartAPI.Graph.morris.Base.prototype.getTotalCount_ = function (data, index) {
  var total = 0,
    str = 'y' + (index || ''),
    num;
  $.each(data, function (i, v) {
    num = v[str] || v.value || 0;
    if (typeof num === 'string') {
      num = parseFloat(num.replace(/,/g, ''), 10);
    }
    total = total + num;
  });
  return total;
};

ChartAPI.Graph.morris.Base.prototype.remove = function () {
  this.$graphEl.remove();
};

ChartAPI.Graph.morris.bar = ChartAPI.Graph.morris.line = ChartAPI.Graph.morris.donut = ChartAPI.Graph.morris.area = function (data, config, range, $container) {
  if (ChartAPI.Graph.test.vml()) {
    var morrisGraph = new ChartAPI.Graph.morris.Base(data, config, range, $container);
    return morrisGraph;
  } else {
    console.warn('Morris graph requires for SVG/VML capability');
    $container.trigger('REMOVE');
  }
};

  /**
 * create Slider Object
 * If you want to draw slider, fire APPEND_SLIDER event for its container Element like this
 * $('.container').trigger('APPEND_SLIDER')
 *
 * @param {object} slider setings
 * @param {object} range object
 * @param {jQuery} jQuery object of graph/list container element for getting data range
 * @param {Array.<jQuery>} array of jQuery object to fire update event
 * @param {
   Array. < jQuery >
 }
 array of jQuery object to fire event
 for getting amount labels(this event fired when range is timeline)
 * @return {object} jQuery object of slider container for chaining
 * @constructor
 */
ChartAPI.Slider = function (config, range, $dataRangeTarget, updateTarget, amountTarget) {
  if (!$.ui || !$.ui.slider) {
    throw 'ChartAPI.Slider requied jQuery UI Slider';
  }
  var that = this;
  this.id = 'slider-' + (new Date()).valueOf() + Math.floor(Math.random() * 100);
  this.config = config;
  this.range = ChartAPI.Range.generate(range);
  this.$dataRangeTarget = $dataRangeTarget;
  this.$sliderContainer = $('<div id="' + this.id + '-container" class="slider-container"></div>');

  this.eventTargetList = {
    update: this.initEventTarget(),
    amount: this.initEventTarget()
  };

  $.each(updateTarget, function (i, v) {
    that.eventTargetList.update.add(v);
  });

  $.each(amountTarget, function (i, v) {
    that.eventTargetList.amount.add(v);
  });

  /**
   * @param {object} jQuery event object
   * @param {jQuery} jQuery object to attach slider
   * @return {jQuery} return jQuery object for chaining
   */
  this.$sliderContainer.on('APPEND_TO', function (e, $container) {
    that.$container = $container;
    that.draw_($container);
    return $(this);
  });

  /**
   * for building slider UI
   * @param {object} jQuery event object
   * @return {jQuery} return jQuery object for chaining
   */
  this.$sliderContainer.on('BUILD_SLIDER', function () {
    that.$dataRangeTarget.trigger('GET_DATA_RANGE', function (dataRange) {
      that.buildSlider(dataRange.min, dataRange.max);
    });
    return $(this);
  });

  /**
   * @param {object} jQuery event object
   * @param {jQuery} jQuery object of container for graph|list object to get data range
   * @return {jQuery} return jQuery object for chaining
   */
  this.$sliderContainer.on('SET_DATA_RANGE', function (e, $target) {
    that.$dataRangeTarget = $target;
    return $(this);
  });

  /**
   * @param {object} jQuery event object
   * @param {string} the type of event (update|amount) to fire on
   * @param {Array.<jQuery>} array of jQuery object to add event target
   * @return {jQuery} return jQuery object for chaining
   */
  this.$sliderContainer.on('ADD_EVENT_LIST', function (e, type, $targets) {
    $targets = Array.isArray($targets) ? $targets : [$targets];
    $.each($targets, function (i, $target) {
      that.eventTargetList[type].add($target);
    });
    return $(this);
  });

  /**
   * @param {object} jQuery event object
   * @param {string} the type of event (update|amount) to fire on
   * @param {Array.<jQuery>} array of jQuery object to remove from event targets
   * @return {jQuery} return jQuery object for chaining
   */
  this.$sliderContainer.on('REMOVE_EVENT_LIST', function (e, type, $targets) {
    $targets = Array.isArray($targets) ? $targets : [$targets];
    $.each($targets, function (i, $target) {
      that.eventTargetList[type].remove($target);
    });
    return $(this);
  });


  this.$sliderContainer.on('ERASE', function () {
    that.erase_();
    return $(this);
  });

  this.$sliderContainer.on('REDRAW', function () {
    var $this = $(this);
    $this.trigger('BUILD_SLIDER').trigger('APPEND_TO', [that.$container]);
    return $(this);
  });

  this.$sliderContainer.on('UPDATE', function (e, values) {
    that.$slider("values", values);
    that.updateSliderAmount(values);
    return $(this);
  });

  return this.$sliderContainer;
};

/**
 * return event target object encapsulated target array
 * @return {{add:Function, remove:Function, get:Function}}
 */
ChartAPI.Slider.prototype.initEventTarget = function () {
  var target = [];
  return {
    add: function (newTarget) {
      target.push(newTarget);
    },
    remove: function (removeTarget) {
      target = $.grep(target, function (v) {
        return v !== removeTarget;
      });
    },
    get: function () {
      return target;
    }
  };
};

/**
 * build Slider UI
 * @param {number} number of the left slider handler position
 * @param {number} number of the right slider handler position
 * @param {{max:number, min:number}} Object which has max and min values
 * @return nothing
 */
ChartAPI.Slider.prototype.buildSlider = function (sliderMin, sliderMax, values) {
  var that = this;
  values = values || [this.range.min, this.range.max];

  if (this.$slider) {
    this.$slider.destroy();
    this.$slider.remove();
  }
  this.$slider = $('<div class="slider"></div>').slider({
    'range': true,
    'min': sliderMin,
    'max': sliderMax,
    'values': values,
    'slide': function (e, ui) {
      that.updateSliderAmount(ui.values, ui);
    },
    'stop': function (e, ui) {
      that.updateGraphAndList(ui.values);
    }
  }).appendTo(that.$sliderContainer);

  if (!this.config.hideSliderAmount) {
    this.$amount = $('<div class="amount"></div>');

    if (!this.config.appendSliderAmountBottom) {
      this.$amount.prependTo(this.$sliderContainer);
    } else {
      this.$amount.appendTo(this.$sliderContainer);
    }

    this.updateSliderAmount(values);
  }
};

/**
 * append Slider container to desinated element
 * @param {jQuery}
 * @return nothing
 */
ChartAPI.Slider.prototype.draw_ = function ($container) {
  this.$sliderContainer.appendTo($container);
};

/**
 * erase Slider by removing the container
 * if you want to redraw Slider, trigger 'REDRAW' for the slider container.
 */
ChartAPI.Slider.prototype.erase_ = function () {
  if (this.$slider) {
    this.$slider.destroy();
  }
  this.$sliderContainer.html('');
};

/**
 * update Slider Amount contents
 * @param {Array.<number>} values of slider position
 * @param {object} ui object returned from Slider event
 */
ChartAPI.Slider.prototype.updateSliderAmount = function (values, ui) {
  var s, e, u, newRange, maxLength = this.range.maxLength,
    $amount = this.$amount;

  if (this.range.isTimeline) {
    s = ChartAPI.Date.parse(values[0]);
    e = ChartAPI.Date.parse(values[1]);
    u = this.range.unit;

    newRange = ChartAPI.Range.getLength(s, e, u);

    if (ui && newRange > maxLength) {
      if (ui.value === ui.values[0]) {
        e = ChartAPI.Date.calcDate(s, maxLength, u, false);
        this.$slider.slider('values', 1, e.valueOf());
      } else {
        s = ChartAPI.Date.calcDate(e, maxLength, u, true);
        this.$slider.slider('values', 0, s.valueOf());
      }
    }

    if ($amount) {
      $amount.text([ChartAPI.Date.createXLabel(s, u), ChartAPI.Date.createXLabel(e, u)].join(' - '));
    }
  } else {
    s = values[0];
    e = values[1];
    if ((e - s) > maxLength) {
      if (ui.value === ui.values[0]) {
        e = maxLength - s;
        this.$slider.slider('values', 1, e);
      } else {
        s = e - maxLength;
        this.$slider.slider('values', 0, s);
      }
    }
    if ($amount) {
      $.each(this.eventTargetList.amount.get(), function (i, $target) {
        $target.trigger('GET_LABEL', [
          [s, e],
          function (a) {
            $amount.text([a[0], a[1]].join(' - '));
          }
        ]);
      });
    }
  }
};

/**
 * @param {Array.<number>} values of slider handler position
 * @param {=string} graph unit type (yearly|quater|monthly|weekly|daily|hourly)
 */
ChartAPI.Slider.prototype.updateGraphAndList = function (values, newUnit) {
  $.each(this.eventTargetList.update.get(), function (i, $target) {
    $target.trigger('UPDATE', [values, newUnit]);
  });
};

/**
 * update slider handlers position
 * @param {number} index of slider handler (left is 0, right is 1)
 * @param {number} value of slider handler position
 */
ChartAPI.Slider.prototype.update_ = function (index, value) {
  this.$slider.slider('values', index, value);
};

  /**
 * create List Object
 * If you want to draw list, fire APPEND_LIST event for its container Element like this
 * $('.container').trigger('APPEND_LIST')
 *
 * @param {object} list setings
 * @param {object} range object
 * @return {jQuery} return jQuery object for chaining
 * @constructor
 */
ChartAPI.List = function (config, range) {
  this.id = 'list-' + (new Date()).valueOf() + Math.floor(Math.random() * 100);
  this.config = config;

  this.config.staticPath = this.config.staticPath || '';

  if (this.config.data && typeof this.config.data === 'string') {
    this.origData_ = $.getJSON(this.config.staticPath + this.config.data);
  } else {
    this.origData_ = $.Deferred();
    this.origData_.resolve(this.config.data);
  }

  if (this.config.template) {
    if (window.require && typeof require === 'function') {
      var templateType = this.config.type || 'text';
      this.template_ = $.Deferred();
      require([templateType + '!' + this.config.staticPath + this.config.template], $.proxy(function (template) {
        this.template_.resolve(template);
      }, this));
    } else {
      this.template_ = $.get(this.config.staticPath + this.config.template, 'text');
    }

    this.range = ChartAPI.Range.generate(range);

    this.$listContainer = $('<div id="' + this.id + '-container" class="list-container"></div>');

    this.$listContainer.on('UPDATE', $.proxy(function (e, range) {
      this.update_(range);
    }, this));

    /**
     * @return {jQuery} return jQuery object for chaining
     * return back the graph data range to callback
     */
    this.$listContainer.on('GET_DATA_RANGE', $.proxy(function (e, callback) {
      this.getData($.proxy(function (data) {
        callback(ChartAPI.Range.getDataRange(data, this.range.isTimeline));
      }, this));
      return this.$listContainer;
    }, this));

    /**
     * @return {jQuery} return jQuery object for chaining
     * return back the graph label array to callback
     */

    this.$listContainer.on('GET_LABEL', $.proxy(function (e, indexArray, callback) {
      this.getData($.proxy(function (data) {
        callback(this.getDataLabelByIndex(indexArray, data));
      }, this));
      return this.$listContainer;
    }, this));

    /**
     * append graph container to the desinated container
     * @return {jQuery} return jQuery object for chaining
     */

    this.$listContainer.on('APPEND_TO', $.proxy(function (e, $container) {
      this.$listContainer.appendTo($container);
      this.getData($.proxy(function (data) {
        this.draw_(data);
      }, this));
      return this.$listContainer;
    }, this));

    return this.$listContainer;
  }
};

/**
 * get list data JSON
 * @param {!Function} callback function which recieve jSON data
 */
ChartAPI.List.prototype.getData = function (callback) {
  if (this.config.data) {
    ChartAPI.Data.getData(this.origData_, this.$listContainer, callback, this);
  } else {
    callback();
  }
};

/**
 * get list template string
 * @param {!Function} callback function which recieve template string
 */
ChartAPI.List.prototype.getTemplate = function (callback) {
  ChartAPI.Data.getData(this.template_, this.$listContainer, callback, this);
};

/**
 * generate html using template string
 * @param {!object} list JSON data
 */
ChartAPI.List.prototype.draw_ = function (data) {
  var that = this;
  this.getTemplate(function (templateString) {
    data = that.createListData(data);
    that.$listContainer.html(_.template(templateString, data));
  });
};

/**
 * provide x label data for slider
 * @param {!Array.<number>} array of index to get data
 * @param {!object} list JSON data
 */
ChartAPI.List.prototype.getDataLabelByIndex = function (indexArray, data) {
  var label = this.config.dataLabel || 'x';
  return $.map(indexArray, function (i) {
    return data[i][label];
  });
};

/**
 * @param {!object} list JSON data
 * @return {object} filtered data for using list template
 */
ChartAPI.List.prototype.createListData = function (data) {
  var filteredData = '';
  if (data) {
    if (this.range.isTimeline) {
      filteredData = ChartAPI.Data.filterData(data, this.range.max, this.range.min, this.range.unit, 1, true);
    } else {
      filteredData = data.slice(this.range.min, this.range.max + 1);
    }
  }
  return {
    'data': filteredData
  };
};

/**
 * update list template
 * @param {=Array.<number>} array of number
 * @param {=string} graph unit type (yearly|quater|monthly|weekly|daily|hourly)
 */
ChartAPI.List.prototype.update_ = function (newRange, unit) {
  var that = this;
  newRange = newRange || [];
  unit = unit || this.range.unit;
  this.range = ChartAPI.Range.generate({
    'start': newRange[0] || this.range.start,
    'end': newRange[1] || this.range.end,
    'length': null,
    'maxLength': this.range.maxLength,
    'unit': unit,
    'dataType': this.range.dataType
  });
  this.getData(function (data) {
    that.draw_(data);
  });
};

  /**
 * builder funciton. return jQuery object for chaining and triggering events
 * @return {jQuery}
 */
ChartAPI.Build = function (settings) {
  var $container;
  if (typeof settings === 'string' && (/\.json$/).test(settings)) {
    $container = $('<div class="mtchart-container">');
    ChartAPI.Data.getData($.getJSON(settings), null, function (settings) {
      settings.$container = $container;
      ChartAPI.Build_(settings).trigger('APPEND');
    });
  } else {
    $container = ChartAPI.Build_(settings).trigger('APPEND');
  }
  return $container;
};

/**
 * internal method for building graph|slider|list objects
 * @param {Object} settings
 * @param {=jQuery} jQuery object to attach graph|slider|list object
 */
ChartAPI.Build_ = function (settings) {
  var $container, $graphContainer, $sliderContainer, $listContainer, dataRangeTarget, sliderUpdateTarget, sliderAmountTarget;

  $container = settings.$container || $('<div class="mtchart-container">');

  sliderUpdateTarget = [];

  if (settings.graph) {
    $graphContainer = new ChartAPI.Graph(settings.graph, settings.range);
    sliderUpdateTarget.push($graphContainer);
  }

  if (settings.list) {
    $listContainer = new ChartAPI.List(settings.list, settings.range);
    if (settings.list.data) {
      sliderUpdateTarget.push($listContainer);
    }
  }

  if (settings.graph && settings.graph.type !== 'donut') {
    dataRangeTarget = $graphContainer;
    sliderAmountTarget = [$graphContainer];
  } else {
    dataRangeTarget = $listContainer;
    sliderAmountTarget = [$listContainer];
  }

  var isSmartPhone = function () {
    var userAgent = window.navigator ? window.navigator.userAgent : '';
    return (/android|iphone|ipod|ipad/i).test(userAgent);
  };

  if (settings.slider && (settings.slider.force || !isSmartPhone())) {
    $sliderContainer = new ChartAPI.Slider(settings.slider, settings.range, dataRangeTarget, sliderUpdateTarget, sliderAmountTarget);
  }

  $container.on('APPEND', function () {
    if ($graphContainer) {
      $graphContainer.trigger('APPEND_TO', [$container]);
    }
    if ($sliderContainer) {
      $sliderContainer.trigger('BUILD_SLIDER')
        .trigger('APPEND_TO', [$container]);
    }
    if ($listContainer) {
      $listContainer.trigger('APPEND_TO', [$container]);
    }
  });

  $container.on('GET_CONTAINER', function (e, type, callback) {
    callback({
      'graph': $graphContainer,
      'slider': $sliderContainer,
      'list': $listContainer
    }[type]);
  });

  return $container;
};


  return ChartAPI;
})(this, jQuery);

