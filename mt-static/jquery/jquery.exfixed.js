/*
 * 	exFixed 2.0.2 - jQuery plugin
 *	written by Cyokodog	
 *
 *	Copyright (c) 2009 Cyokodog (http://d.hatena.ne.jp/cyokodog/)
 *	Dual licensed under the MIT (MIT-LICENSE.txt)
 *	and GPL (GPL-LICENSE.txt) licenses.
 *
 *	Built for jQuery library
 *	http://jquery.com
 *
 */
/*
 * 	memo
 * 	Rev.2.0.3
		unfixed -> unFixed
		width or height = 'auto' 時に overflow:hidden 
		ex.defineExPlugin 対応
 */
(function($j){
	$j.ex=$j.ex||{};
	/*
	 * 	ex.defineExPlugin 1.0
	 */
	$j.ex.defineExPlugin = function(pluginName,constr){
		$j.fn[pluginName]=
			function(cfg){
				var o=this,arr=[];
				o.each(function(idx){
					arr.push(new constr(o.eq(idx),cfg));
				});
				var obj=$j(arr);
				for(var i in constr.prototype)(function(i){
					if(i.slice(0,1)!='_'){
						obj[i]=function(){
							return obj[0][i].apply(obj[0],arguments);
						}
					}
				})(i);
				obj.target=function(){return o}
				return obj;
			}
		;
	}
	/*
	 * 	exFixed 2.0.3
	 */
	$j.ex.fixed = function(target,cfg){
		var o=this,c=o.cfg=$j.extend({
			target:target,
			smooth:true,
			unfixed:target.css('position')
		},cfg);

		//for modern browser
		if(!o._applyBrowser){
			c.target.css({position:'fixed'});
			if(cfg){
				for(var i=0;i<o._attn.length;i++){
					for(var j in o._attn[i]){
						var name=o._attn[i][j];
						if(typeof cfg[name]!='undefined')
							c.target.css(name,cfg[name])
					}
				}
			}
			return;
		}

		//init target
		c.cs=c.target
			.css({position:'absolute',overflow:'hidden'})
			.attr('currentStyle');
		o.toFrontContainer();

		//init config and position
		c.container=$j.boxModel?$j('html'):$j('body');
		c.container.height();//for IE Bug
		c.baseSize={};
		c.rowSize={};
		o.smoothPatch();
		o.fixedSize(cfg);
		o._exactPos()._smoothPos()

		//for resize container
		var t;
		$j(window).resize(function(){
			if(t)clearTimeout(t);
			t=setTimeout(function(){
				o._exactPos()._smoothPos()
			},1)
		})
	};
	$j.extend($j.ex.fixed.prototype,{
		target:function(){
			return this.cfg.target;
		},
		currentSize:function(){
			var o=this,c=o.cfg;
			var ret={};
			for(var i in c.baseSize)ret[i]=c.baseSize[i];
			return ret;
		},
		fixedSize:function(size,pair){
			var o=this,c=o.cfg;
			if(!o._applyBrowser)return size;
			o._setBaseSize(size);
			return o._calcRowSize(pair);
		},
		fixedOpen:function(f){
			var o=this,c=o.cfg;
			if (o._applyBrowser)o._exactPos();
			if(f)setTimeout(function(){f();},0);
			return o;
		},
		fixedClose:function(size){
			var o=this,c=o.cfg;
			if(size)c.target.css(o.fixedSize(size,true))
			if(!o._applyBrowser)return o;
			o._smoothPos();
			return o;
		},
		unFixed : function(position){
			var o=this,c=o.cfg;
			position=='fixed'?undefined:position;
			c.target.css('position',position||c.unfixed);
			c.target[0].style.removeExpression('top');
			c.target[0].style.removeExpression('left');
			return o;
		},
		smoothPatch:function(){
			var o=this,c=o.cfg;
			if(!o._applyBrowser)return o;
			if(!c.smooth)
				c.target[0].style.setExpression('', 'this.style.filter=""');
			var img=c.container.css('background-image');
			if(img=='none'){
				c.container.css({'background-image':'url(null)'})
			}
			else
			if($j.boxModel){
				c.container.css({'background-image':'url(null)'})
				$j('body').css({
					'background-image':img,
					'background-attachment':c.container.css('background-attachment')
				})
			}
			c.container.css({
				'background-attachment':'fixed'
			});
			return o;
		},
		toFrontContainer : function(){
			var o=this,c=o.cfg;
			var pr=c.target.parents();
			var contNode=pr.filter(function(idx){
				var el=pr.eq(idx);
				return !(/HTML|BODY/i.test(el[0].tagName)) && pr.eq(idx).css('position')!='static';
			});
			if(contNode.size())
				contNode.eq(contNode.size()-1).after(c.target)
			return o;
		},
		_applyBrowser:$j.browser.msie && ($j.browser.version < 7.0 || !$j.boxModel),
		_parseSize:function(val,xFlg){
			var o=this,c=o.cfg;
			if(val=='auto')return val;
			if((val+'').indexOf('%')<0)return parseInt(val)||0;
			var cSize=c.container.attr(xFlg?'clientWidth':'clientHeight');
			return Math.round(cSize*parseInt(val)/100);
		},
		_parseIntSize:function(val,xFlg){
			return parseInt(this._parseSize(val,xFlg))||0;
		},
		_attn :[
			{size:'height',pos1:'top',pos2:'bottom'},
			{size:'width',pos1:'left',pos2:'right'}
		],
		_setBaseSize:function(par){
			var o=this,c=o.cfg;
			for(var i=0;i<o._attn.length;i++){
				var attn=o._attn[i];
				for(var j in attn){
					if(typeof c.baseSize[attn[j]]=='undefined'){
						c.baseSize[attn[j]]=c.cs[attn[j]];
					}
				}
				if(par){
					if(par[attn.pos1]!=undefined && par[attn.pos1]!='auto'){
						c.baseSize[attn.pos1]=par[attn.pos1];
						c.baseSize[attn.pos2]='auto';
					}
					if(par[attn.pos2]!=undefined && par[attn.pos2]!='auto'){
						c.baseSize[attn.pos2]=par[attn.pos2];
						c.baseSize[attn.pos1]='auto';
					}
					if(par[attn.size]!=undefined)c.baseSize[attn.size]=par[attn.size];
				}
			}
			return o;
		},
		_calcRowSize:function(pair){
			var o=this,c=o.cfg;
			c.rowSize={};
			for(var i=0;i<o._attn.length;i++){
				var attn=o._attn[i];
				for(var j in attn){
					var val=c.baseSize[attn[j]];
					if(val=='auto'){
						if(pair)c.rowSize[attn[j]] = val;
					}
					else{
						c.rowSize[attn[j]]=o._parseIntSize(val,i);
						if(j=='pos1'){
							var key=attn.pos1.slice(0,1).toUpperCase()+attn.pos1.slice(1)
							c.rowSize[attn[j]]+=c.container['scroll'+key]()
						}
					}
				}
			}
			return c.rowSize;
		},
		_smoothPos:function(){
			var o=this,c=o.cfg;
			var pos=c.target.position();
			for(var i=0;i<o._attn.length;i++){
				var attn = o._attn[i];
				if (c.baseSize[attn.pos2] == 'auto' || c.smooth) {
					var css = {};
					css[attn.pos1] = pos[attn.pos1];
					css[attn.pos2] = 'auto';
					c.target.css(css);
					var key = attn.pos1.slice(0, 1).toUpperCase() + attn.pos1.slice(1)
					c.target[0]['exFixed' + key] = pos[attn.pos1] - $j(window)['scroll' + key]();
					c.target[0].style.setExpression(attn.pos1, 'this.exFixed' + key + '+(document.body.scroll' + key + '||document.documentElement.scroll' + key + ') + "px"');
				}
			}
			return o;
		},
		_exactPos:function(){
			var o=this,c=o.cfg;
			o._calcRowSize();
			var css={};
			for(var i=0;i<o._attn.length;i++){
				var attn=o._attn[i];
				c.target[0].style.removeExpression(attn.pos1);
				css[attn.size]=c.rowSize[attn.size];
				if(c.baseSize[attn.pos2]!='auto'){
					css[attn.pos1]='auto';
					css[attn.pos2]=c.rowSize[attn.pos2];
				}
				else{
					css[attn.pos1]=c.rowSize[attn.pos1];
					css[attn.pos2]='auto';
				}
			}
			c.target.css(css);
			setTimeout(function(){c.target.css(css);},0);//for scrollbar
			return o;
		}
	});
	$j.ex.defineExPlugin('exFixed',$j.ex.fixed);
})(jQuery);

