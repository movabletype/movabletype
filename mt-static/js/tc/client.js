/*
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
*/


/*
--------------------------------------------------------------------------------
TC.Client
HTTP client for doing Ajax requests
--------------------------------------------------------------------------------
*/

TC.Client = function()
{
}

TC.Client.initClient = function()
{
    if( !window.XMLHttpRequest ) {
        window.XMLHttpRequest = function() {
            var types = [
			"Microsoft.XMLHTTP",
			"MSXML2.XMLHTTP.5.0",
			"MSXML2.XMLHTTP.4.0",
			"MSXML2.XMLHTTP.3.0",
			"MSXML2.XMLHTTP"
		];
		
		for( var i = 0; i < types.length; i++ ) {
			try {
				return new ActiveXObject( types[ i ] );
			} catch( e ) {}
		}
		
		return undefined;
        };
    }
    if( window.XMLHttpRequest )
        return new XMLHttpRequest();
}

TC.Client.call = function( param )
{
    if( !param['uri'] )
        return;
    var c = TC.Client.initClient();
    if( !c )
        return;
    // adding random bits to avoid cache in stupid IE
    var random = (param['uri'].match(/\?/) ? '&' : '?') + '.r=' + Math.random(1);
    param['uri'] += random;
    c.open(param['method'] || 'GET', param['uri'], true);
    c.onreadystatechange = function()
    {
        if ( c.readyState == 1 ) {
            if ( param['loading'] ) param['loading']( c );
        } else if ( c.readyState == 2 ) {
            if ( param['loaded'] ) param['loaded']( c );
        } else if ( c.readyState == 3 ) {
            if ( param['interactive'] ) param['interactive']( c );
        } else if( c.readyState == 4 ) {
            if( c.status && ( c.status != 200 ) ) {
                if ( param['error'] )
                    param['error']( c, c.responseText, param );
                else
                    alert( 'Error: [' + c.status + '] ' + c.responseText );
            } else if( param['load'] ) {
                if ( c.responseText.charAt(0) == '/' )
                    param['load']( c, c.responseText.substr( 2, ( c.responseText.length - 4 ) ), param );
                else 
                    param['load']( c, c.responseText, param );
            }
        }
    };
    var contents = null;
    if( param['arguments'] )
    {
        if (typeof param['arguments'] == 'string') {
            contents = param['arguments'];
        } else {
            var args = new Array();
            var e = encodeURIComponent || escapeURI || escape;
            for( var a in param['arguments'] ) {
                if ( param['arguments'][a] instanceof Array ) {
                    for ( var i = 0; i < param['arguments'][a].length; i++ ) {
                        args.push( a + '=' + e( param['arguments'][a][i] ) );
                    }
                } else {
                    args.push( a + '=' + e( param['arguments'][a] ) );
                }
            }
            contents = args.join('&');
        }
        c.setRequestHeader( 'Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8' );
    }
    c.setRequestHeader( 'X-Requested-With', 'XMLHttpRequest' );
    c.send( contents );
    return c;
}

