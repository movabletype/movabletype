(function(c){var b=tinymce.DOM;tinymce.create("tinymce.plugins.MTInlinepopupsPlugin",{init:function(d,e){a();d.onBeforeRenderUI.add(function(){d.windowManager=new tinymce.MTInlineWindowManager(d)})},getInfo:function(){return{longname:"MTInlinepopups",author:"Six Apart Ltd",authorurl:"",infourl:"",version:"1.0"}}});function a(){tinymce.create("tinymce.MTInlineWindowManager:tinymce.InlineWindowManager",{MTInlineWindowManager:function(d){this.parent(d)},open:function(i,j){var e=this.editor;var g,h,d;if(h=e.settings.plugin_mt_inlinepopups_window_sizes){g=i.url||i.file;c.each(h,function(l,f){if((new RegExp(l+"$")).test(g)){i=c.extend({},i,f);c.each(["width","height","min_width","min_height","max_width","max_height","left","top"],function(n,m){if(i[m]&&typeof i[m]==="function"){i[m]=i[m].call(e)}})}})}e.focus(true);d=tinymce.InlineWindowManager.prototype.open.apply(this,[i,j]);c("#"+d.iframeElement.id).load(function(){if(i.body_id){c(this).contents().find("body").attr("id",i.body_id)}if(i.onload){i.onload({iframe:this})}});return d}})}tinymce.PluginManager.add("mt_inlinepopups",tinymce.plugins.MTInlinepopupsPlugin,["inlinepopups"])})(jQuery);