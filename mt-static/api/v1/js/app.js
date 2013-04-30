(function(window) {
    
var API = function(options) {
    this.o = {
        appId: 'default',
        baseUrl: '',
        cookieDomain: undefined,
        cookiePath: undefined,
        async: true
    };
    for (k in this.o) {
        if (options[k]) {
            if (typeof this.o[k] === 'object') {
                for (l in this.o[k]) {
                   this.o[k][l] = options[k][l]; 
                }
            }
            else {
                this.o[k] = options[k];
            }
        }
    }
    // TODO validate option

    this.callbacks = [];
    this.tokenData = null;
}

API.mtApiAccessTokenKey = 'mt_api_access_token';
API.prototype = {
    getVersion: function() {
        return 1;
    },
    
    getAppKey: function() {
        return API.mtApiAccessTokenKey + '_' + this.o.appId;
    },
    
    storeToken: function(tokenData) {
        var o = this.o;
        tokenData.start_time = new Date().getTime() / 1000;
        Cookie.bake(this.getAppKey(), JSON.stringify(tokenData), o.cookieDomain, o.cookiePath);
        this.tokenData = null;
    },
    
    updateTokenFromDefault: function() {
        var defaultKey    = API.mtApiAccessTokenKey,
            defaultCookie = Cookie.fetch(defaultKey);
        if (! defaultCookie) {
            return null;
        }
        
        try {
            var defaultToken = JSON.parse(defaultCookie.value);
        }
        catch (e) {
            return null;
        }
        
        this.storeToken(defaultToken);
        Cookie.bake(defaultKey, '', undefined, '/', new Date(0));
        return defaultToken;
    },
    
    getToken: function() {
        if (! this.tokenData) {
            var token = null;
            
            if (window.location.hash.match(/#_login$/)) {
                try {
                    token = this.updateTokenFromDefault();
                }
                catch (e) {
                }
            }
            
            if (! token) {
                try {
                    token = JSON.parse(Cookie.fetch(this.getAppKey()).value);
                }
                catch (e) {
                }
            }
            
            this.tokenData = token;
        }
        
        if (! this.tokenData) {
            return null;
        }
        
        return this.tokenData.access_token;
    },
    
    bindEndpointParams: function(endpoint, params) {
        for (k in params) {
            endpoint = endpoint.replace(new RegExp(':' + k), params[k]);
        }
        return endpoint;
    },
    
    serialize: function(params) {
        if (! params) {
            return params;
        }
        if (typeof params === 'string') {
            return params;
        }
        
        var str = '';
        for (k in params) {
            if (str) {
                str += '&';
            }
            
            var v = params[k];
            if (v instanceof Date) {
                v = v.getFullYear() + '-' + ( v.getMonth() + 1 ) + '-' + v.getDate() +
                    (k.match(/date/i)
                        ? ''
                        : (' ' + v.getHours() + ':' + v.getMinutes() + ':' + v.getSeconds()));
            }
            else if (typeof params[k] === 'object') {
                v = JSON.stringify(params[k]);
            }
            str += encodeURIComponent(k) + '=' + encodeURIComponent(v);
        }
        return str;
    },
    
    newXMLHttpRequest: function() {
        var xmlhttp;

        if (window.ActiveXObject){
            try {
                xmlhttp = new ActiveXObject('Msxml2.XMLHTTP');
            } catch (e) {
                try {
                    xmlhttp = new ActiveXObject('Microsoft.XMLHTTP');
                } catch (e) {
                    return false;
                }
            }
        }
        else if (window.XMLHttpRequest) {
            xmlhttp = new XMLHttpRequest();
        }
        else {
            xmlhttp = false;
        }
        
        return xmlhttp;
    },
    
    sendXMLHttpRequest: function(xhr, method, url, params) {
        params = this.serialize(params);
        if (params && method.match(/^(put|delete)$/i)) {
            params += ( params === '' ? '' : '&' ) + '__method=' + method;
            method = 'POST';
        }
        
        xhr.open(method, url, this.o.async);
        xhr.setRequestHeader(
            'Content-Type', 'application/x-www-form-urlencoded'
        );
        xhr.setRequestHeader(
            'X-MT-Authorization', 'MTAuth access_token=' + this.getToken()
        );
        
        xhr.send(params);
        
        return xhr;
    },
    
    request: function(method, endpoint) {
        var api         = this,
            params_list = [],
            params      = null,
            callback    = function(){},
            originalArguments = Array.prototype.slice.call(arguments);
        
        for (var i = 2; i < arguments.length; i++) {
            switch (typeof arguments[i]) {
            case 'function':
                callback = arguments[i];
                break;
            case 'object':
            case 'string':
                params_list.push(this.serialize(arguments[i]));
                break;
            }
        }
        
        if (params_list.length && (method.toLowerCase() === 'get' || params_list.length >= 2)) {
            if (endpoint.indexOf('?') === -1) {
                endpoint += '?';
            }
            else {
                endpoint += '&';
            }
            endpoint += params_list.shift();
        }

        if (params_list.length) {
            params = params_list.shift();
        }
        
        
        var base = this.o.baseUrl.replace(/\/*$/, '/') + 'v' + this.getVersion();
        endpoint = endpoint.replace(/^\/*/, '/');


        var xhr = this.newXMLHttpRequest();
        xhr.onreadystatechange = function() {
            if (xhr.readyState !== 4) {
                return;
            }
            
            var response = null;
            try {
                response = JSON.parse(xhr.responseText);
            }
            catch (e) {
                // Do nothing
            }
            
            if (! response) {
                response = {
                    error: {
                        code:    parseInt(xhr.status, 10),
                        message: xhr.statusText
                    }
                };
            }


            function runCallbacks(response) {
                var status = callback(response);
                if (status !== false) {
                    if (response.error) {
                        // TODO default error handling
                    }
                }
            }

            if (response.error && response.error.code === 401 && endpoint !== '/token') {
                api.request('GET', '/token', function(response) {
                    if (response.error && response.error.code === 401) {
                        api.trigger('sessionExpired', response);
                        runCallbacks(response);
                    }
                    else {
                        api.storeToken(response);
                        api.request.apply(api, originalArguments);
                    }
                    return false;
                });
            }

            runCallbacks(response);
        };
        return this.sendXMLHttpRequest(xhr, method, base + endpoint, params);
    },

    on: function(key, callback) {
        if (! this.callbacks[key]) {
            this.callbacks[key] = [];
        }

        this.callbacks[key].push(callback);
    },

    off: function(key, callback) {
        if (callback) {
            var callbacks = this.callbacks[key] || [];

            for (var i = 0; i < callbacks.length; i++) {
                if (callbacks[i] === callback) {
                    callbacks.splice(i, 1);
                    break;
                }
            }
        }
        else {
            delete this.callbacks[key];
        }
    },

    trigger: function(key) {
        var callbacks = this.callbacks[key] || [],
            args      = Array.prototype.slice.call(arguments, 1);

        for (var i = 0; i < callbacks.length; i++) {
            callbacks[i].apply(this, args);
        }
    }
};

window.MT     = window.MT || {};
window.MT.API = API;



function exists(x) {
    return (x === undefined || x === null) ? false : true;
};

var Cookie = function( name, value, domain, path, expires, secure ) {
    this.name = name;
    this.value = value;
    this.domain = domain;
    this.path = path;
    this.expires = expires;
    this.secure = secure;
};

Cookie.prototype = {
    /**
     * Get this cookie from the web browser's store of cookies.  Note that if the <code>document.cookie</code>
     * property has been written to repeatedly by the same client code in excess of 4K (regardless of the size
     * of the actual cookies), IE 6 will report an empty <code>document.cookie</code> collection of cookies.
     * @return <code>Cookie</code> The fetched cookie.
     */
    fetch: function() {
        var prefix = escape( this.name ) + "=";
        var cookies = ("" + document.cookie).split( /;\s*/ );
        
        for( var i = 0; i < cookies.length; i++ ) {
            if( cookies[ i ].indexOf( prefix ) == 0 ) {
                this.value = unescape( cookies[ i ].substring( prefix.length ) );
                return this;
            }
        }
                                 
        return undefined;
    },

    
    /**
     * Set and store a cookie in the the web browser's native collection of cookies.
     * @return <code>Cookie</code> The set and stored ("baked") cookie.
     */
    bake: function( value ) {
        if( !exists( this.name ) )
        	return undefined;
		
        if( exists( value ) )
            this.value = value;
        else 
            value = this.value;
		
        var name = escape( this.name );
        value = escape( value );
        
        // log( "Saving value: " + value );
        var attributes = ( this.domain ? "; domain=" + escape( this.domain ) : "") +
            (this.path ? "; path=" + escape( this.path ) : "") +
            (this.expires ? "; expires=" + this.expires.toGMTString() : "") +
            (this.secure ? "; secure=1"  : "");       

        
        var batter = name + "=" + value + attributes;                   
        document.cookie = batter;

        return this;
    },


    remove: function() {
        this.expires = new Date( 0 ); // "Thu, 01 Jan 1970 00:00:00 GMT"
        this.value = "";
        this.bake();     
    }
};

Cookie.fetch = function( name ) {
    var cookie = new this( name );
    return cookie.fetch();        
}

    
Cookie.bake = function( name, value, domain, path, expires, secure ) {
    var cookie = new this( name, value, domain, path, expires, secure );
    return cookie.bake();
};

Cookie.remove = function( name ) {
    var cookie = this.fetch( name );
    if( cookie )
        return cookie.remove();
};


if(!this.JSON){JSON={};}(function(){function f(n){return n<10?'0'+n:n;}if(typeof Date.prototype.toJSON!=='function'){Date.prototype.toJSON=function(key){return this.getUTCFullYear()+'-'+f(this.getUTCMonth()+1)+'-'+f(this.getUTCDate())+'T'+f(this.getUTCHours())+':'+f(this.getUTCMinutes())+':'+f(this.getUTCSeconds())+'Z';};String.prototype.toJSON=Number.prototype.toJSON=Boolean.prototype.toJSON=function(key){return this.valueOf();};}var cx=/[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,escapable=/[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,gap,indent,meta={'\b':'\\b','\t':'\\t','\n':'\\n','\f':'\\f','\r':'\\r','"':'\\"','\\':'\\\\'},rep;function quote(string){escapable.lastIndex=0;return escapable.test(string)?'"'+string.replace(escapable,function(a){var c=meta[a];return typeof c==='string'?c:'\\u'+('0000'+a.charCodeAt(0).toString(16)).slice(-4);})+'"':'"'+string+'"';}function str(key,holder){var i,k,v,length,mind=gap,partial,value=holder[key];if(value&&typeof value==='object'&&typeof value.toJSON==='function'){value=value.toJSON(key);}if(typeof rep==='function'){value=rep.call(holder,key,value);}switch(typeof value){case'string':return quote(value);case'number':return isFinite(value)?String(value):'null';case'boolean':case'null':return String(value);case'object':if(!value){return'null';}gap+=indent;partial=[];if(Object.prototype.toString.apply(value)==='[object Array]'){length=value.length;for(i=0;i<length;i+=1){partial[i]=str(i,value)||'null';}v=partial.length===0?'[]':gap?'[\n'+gap+partial.join(',\n'+gap)+'\n'+mind+']':'['+partial.join(',')+']';gap=mind;return v;}if(rep&&typeof rep==='object'){length=rep.length;for(i=0;i<length;i+=1){k=rep[i];if(typeof k==='string'){v=str(k,value);if(v){partial.push(quote(k)+(gap?': ':':')+v);}}}}else{for(k in value){if(Object.hasOwnProperty.call(value,k)){v=str(k,value);if(v){partial.push(quote(k)+(gap?': ':':')+v);}}}}v=partial.length===0?'{}':gap?'{\n'+gap+partial.join(',\n'+gap)+'\n'+mind+'}':'{'+partial.join(',')+'}';gap=mind;return v;}}if(typeof JSON.stringify!=='function'){JSON.stringify=function(value,replacer,space){var i;gap='';indent='';if(typeof space==='number'){for(i=0;i<space;i+=1){indent+=' ';}}else if(typeof space==='string'){indent=space;}rep=replacer;if(replacer&&typeof replacer!=='function'&&(typeof replacer!=='object'||typeof replacer.length!=='number')){throw new Error('JSON.stringify');}return str('',{'':value});};}if(typeof JSON.parse!=='function'){JSON.parse=function(text,reviver){var j;function walk(holder,key){var k,v,value=holder[key];if(value&&typeof value==='object'){for(k in value){if(Object.hasOwnProperty.call(value,k)){v=walk(value,k);if(v!==undefined){value[k]=v;}else{delete value[k];}}}}return reviver.call(holder,key,value);}cx.lastIndex=0;if(cx.test(text)){text=text.replace(cx,function(a){return'\\u'+('0000'+a.charCodeAt(0).toString(16)).slice(-4);});}if(/^[\],:{}\s]*$/.test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g,'@').replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,']').replace(/(?:^|:|,)(?:\s*\[)+/g,''))){j=eval('('+text+')');return typeof reviver==='function'?walk({'':j},''):j;}throw new SyntaxError('JSON.parse');};}}());
})(window);
