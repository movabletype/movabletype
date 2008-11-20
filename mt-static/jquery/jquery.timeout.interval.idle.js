(function($) {

    if (typeof $.timeout != "undefined") return; 

    $.extend({
      timeout : function (func,delay) {
            // init
            if (typeof $.timeout.count == "undefined") $.timeout.count = 0;     
            if (typeof $.timeout.funcs == "undefined") $.timeout.funcs = new Array(); 
            // set timeout
            if (typeof func =='string') return setTimeout(func, delay); 
            if (typeof func =='function') {
                $.timeout.count++;
                $.timeout.funcs[$.timeout.count] = func;
                return setTimeout("$.timeout.funcs["+$.timeout.count+"]();", delay);
            }
        },
      interval : function (func,delay) {
            // init
            if (typeof $.interval.count == "undefined") $.interval.count = 0;     
            if (typeof $.interval.funcs == "undefined") $.interval.funcs = new Array(); 
            // set interval
            if (typeof func =='string') return setInterval(func, delay); 
            if (typeof func =='function') {
                $.interval.count++;
                $.interval.funcs[$.interval.count] = func;
                return setInterval("$.interval.funcs["+$.interval.count+"]();", delay);
            }
        },
      idle : function (func,delay) {
            // init
            if (typeof $.idle.lasttimeout == "undefined") $.idle.lasttimeout = null;
            if (typeof $.idle.lastfunc == "undefined") $.idle.lastfunc = null;
            // set idle timeout
            if ($.idle.timeout) { clearTimeout($.idle.timeout); $.idle.timeout = null; $.idle.lastfunc = null; }
            if (typeof(func)=='string') { 
                $.idle.timeout = setTimeout(func, delay); 
                return $.idle.timeout;
            }        
            if (typeof(func)=='function') { 
                $.idle.lastfunc = func;
                $.idle.timeout = setTimeout("$.idle.lastfunc();", delay);
                return $.idle.timeout;
            }
        },
      clear : function (countdown) {
        clearInterval(countdown);
        clearTimeout(countdown);
      }    
        
    });
    
    
})(jQuery);