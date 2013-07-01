/*
 * Movable Type (r) (C) 2001-2013 Six Apart, Ltd. All Rights Reserved.
 * This code cannot be redistributed without permission from www.sixapart.com.
 * For more information, consult your Movable Type license.
 *
 * Includes jQuery JavaScript Library to serialize a HTMLFormElement
 * http://jquery.com/
 * Copyright 2005, 2013 jQuery Foundation, Inc. and other contributors
 * Released under the MIT license
 * http://jquery.org/license
 *
 * $Id$
 */

;(function(window, undefined) {

"use strict";
    
/**
 * @namespace MT
 */

/**
 * The MT.DataAPI is a client class for accessing to the Movable Type DataAPI.
 * @class DataAPI
 * @constructor
 * @param {Object} options Options.
 *   @param {String} options.clientId client ID
 *     (Available charactors: Alphabet, '_', '-')
 *   @param {String} options.baseUrl the CGI URL of the DataAPI
 *     (e.g. http://example.com/mt/mt-data-api.cgi)
 *   @param {String} options.cookieDomain
 *   @param {String} options.cookiePath
 *   @param {String} options.format
 *   @param {String} options.async
 *   @param {String} options.cache
 *   @param {String} options.disableFormData
 */
var DataAPI = function(options) {
    var i, k, l,
        requireds = ['clientId', 'baseUrl'];

    this.o = {
        clientId: undefined,
        baseUrl: undefined,
        cookieDomain: undefined,
        cookiePath: undefined,
        format: undefined,
        async: true,
        cache: false,
        disableFormData: false
    };
    for (k in options) {
        if (k in this.o) {
            if (typeof this.o[k] === 'object' && this.o[k] !== null) {
                for (l in this.o[k]) {
                   this.o[k][l] = options[k][l];
                }
            }
            else {
                this.o[k] = options[k];
            }
        }
        else {
            throw 'Unkown option: ' + k;
        }
    }

    for (i = 0; i < requireds.length; i++) {
        if (! this.o[requireds[i]]) {
            throw 'The "' + requireds[i] + '" is required.';
        }
    }

    this.callbacks = {};
    this.tokenData = null;
    this.iframeId  = 0;

    this.trigger('initialize');
};


/**
 * API version.
 * @property version
 * @static
 * @private
 * @type Number
 */
DataAPI.version = 1;

/**
 * The key of access token of this api object.
 * This value is used for the session store.
 * @property accessTokenKey
 * @static
 * @private
 * @type String
 */
DataAPI.accessTokenKey = 'mt_data_api_access_token';

/**
 * The name prefix for iframe that created to upload asset.
 * @property iframePrefix
 * @static
 * @private
 * @type String
 */
DataAPI.iframePrefix = 'mt_data_api_iframe_';

/**
 * Default format that serializes data.
 * @property defaultFormat
 * @static
 * @private
 * @type Number
 */
DataAPI.defaultFormat = 'json';

/**
 * Class level callback function data.
 * @property callbacks
 * @static
 * @private
 * @type Object
 */
DataAPI.callbacks = {};

/**
 * Available formats that serialize data.
 * @property formats
 * @static
 * @private
 * @type Object
 */
DataAPI.formats = {
    json: {
        fileExtension: 'json',
        mimeType: 'application/json',
        serialize: function() {
            return JSON.stringify.apply(JSON, arguments);
        },
        unserialize: function() {
            return JSON.parse.apply(JSON, arguments);
        }
    }
};

/**
 * Register callback to class.
 * @method on
 * @static
 * @param {String} key Event name
 * @param {Function} callback Callback function
 * @category core
 */
DataAPI.on = function(key, callback) {
    if (! this.callbacks[key]) {
        this.callbacks[key] = [];
    }

    this.callbacks[key].push(callback);
};

/**
 * Deregister callback from class.
 * @method off
 * @static
 * @param {String} key Event name
 * @param {Function} callback Callback function
 * @category core
 */
DataAPI.off = function(key, callback) {
    var i, callbacks;

    if (callback) {
        callbacks = this.callbacks[key] || [];

        for (i = 0; i < callbacks.length; i++) {
            if (callbacks[i] === callback) {
                callbacks.splice(i, 1);
                break;
            }
        }
    }
    else {
        delete this.callbacks[key];
    }
};

/**
 * Register formats that serialize data.
 * @method registerFormat
 * @static
 * @param {String} key Format name
 * @param {Object} spec Format spec
 *   @param {String} spec.fileExtension Extension
 *   @param {String} spec.mimeType MIME type
 * @category core
 */
DataAPI.registerFormat = function(key, spec) {
    DataAPI.formats[key] = spec;
};

/**
 * Get default format of this class
 * @method getDefaultFormat
 * @static
 * @return {Object} Format
 * @category core
 */
DataAPI.getDefaultFormat = function() {
    return DataAPI.formats[DataAPI.defaultFormat];
};

DataAPI.prototype = {

    /**
     * Get authorization URL
     * @method getAuthorizationUrl
     * @param {String} redirectUrl The user is redirected to this URL with "#_login" if authorization succeeded.
     * @return {String} Authorization URL
     * @category core
     */
    getAuthorizationUrl: function(redirectUrl) {
        return this.o.baseUrl.replace(/\/*$/, '/') +
            'v' + this.getVersion() +
            '/authorization' +
            '?clientId=' + this.o.clientId +
            '&redirectUrl=' + redirectUrl;
    },

    _getCurrentEpoch: function() {
        return Math.round(new Date().getTime() / 1000);
    },

    _getNextIframeName: function() {
        return DataAPI.iframePrefix + (++this.iframeId);
    },

    /**
     * Get API version
     * @method getVersion
     * @return {String} API version
     * @category core
     */
    getVersion: function() {
        return DataAPI.version;
    },

    /**
     * Get application key of this object
     * @method getAppKey
     * @return {String} Application key
     *   This value is used for the session store.
     * @category core
     */
    getAppKey: function() {
        return DataAPI.accessTokenKey + '_' + this.o.clientId;
    },

    /**
     * Get format that associated with specified MIME Type
     * @method findFormat
     * @param {String} mimeType MIME Type
     * @return {Object|null} Format. Return null if any format is not found.
     * @category core
     */
    findFormat: function(mimeType) {
        if (! mimeType) {
            return null;
        }

        for (var k in DataAPI.formats) {
            if (DataAPI.formats[k].mimeType === mimeType) {
                return DataAPI.formats[k];
            }
        }

        return null;
    },

    /**
     * Get current format of this object
     * @method getCurrentFormat
     * @return {Object} Format
     * @category core
     */
    getCurrentFormat: function() {
        return DataAPI.formats[this.o.format] || DataAPI.getDefaultFormat();
    },

    /**
     * Serialize data.
     * @method serializeData
     * @param {Object} data The data to serialize
     * @return {String} Serialized data
     * @category core
     */
    serializeData: function() {
        return this.getCurrentFormat().serialize.apply(this, arguments);
    },

    /**
     * Unserialize data.
     * @method unserializeData
     * @param {String} data The data to unserialize
     * @return {Object} Unserialized data
     * @category core
     */
    unserializeData: function() {
        return this.getCurrentFormat().unserialize.apply(this, arguments);
    },

    /**
     * Store token data via current session store.
     * @method storeTokenData
     * @param {Object} tokenData The token data
     *   @param {String} tokenData.accessToken access token
     *   @param {String} tokenData.expiresIn The number of seconds
     *     until access token becomes invalid
     *   @param {String} tokenData.sessionId [optional] session ID
     * @category core
     */
    storeTokenData: function(tokenData) {
        var o = this.o;
        tokenData.startTime = this._getCurrentEpoch();
        Cookie.bake(this.getAppKey(), this.serializeData(tokenData), o.cookieDomain, o.cookiePath);
        this.tokenData = tokenData;
    },

    _updateTokenFromDefault: function() {
        var defaultKey    = DataAPI.accessTokenKey,
            defaultCookie = Cookie.fetch(defaultKey),
            defaultToken;

        if (! defaultCookie) {
            return null;
        }

        try {
            defaultToken = this.unserializeData(defaultCookie.value);
        }
        catch (e) {
            return null;
        }

        this.storeTokenData(defaultToken);
        Cookie.bake(defaultKey, '', undefined, '/', new Date(0));
        return defaultToken;
    },

    /**
     * Get token data via current session store.
     * @method getTokenData
     * @return {Object} Token data
     * @category core
     */
    getTokenData: function() {
        var token,
            o = this.o;

        if (! this.tokenData) {
            token = null;

            if (window.location && window.location.hash === '#_login') {
                try {
                    token = this._updateTokenFromDefault();
                }
                catch (e) {
                }
            }

            if (! token) {
                try {
                    token = this.unserializeData(Cookie.fetch(this.getAppKey()).value);
                }
                catch (e) {
                }
            }

            if (token && (token.startTime + token.expiresIn < this._getCurrentEpoch())) {
                Cookie.bake(this.getAppKey(), '', o.cookieDomain, o.cookiePath, new Date(0));
                token = null;
            }

            this.tokenData = token;
        }

        if (! this.tokenData) {
            return null;
        }

        return this.tokenData;
    },

    /**
     * Get authorization request header
     * @method getAuthorizationHeader
     * @return {String|null} Header string. Return null if api object has no token.
     * @category core
     */
    getAuthorizationHeader: function() {
        var tokenData = this.getTokenData();
        if (tokenData && tokenData.accessToken) {
            return 'MTAuth accessToken=' + tokenData.accessToken;
        }

        return '';
    },

    /**
     * Bind parameters to route spec
     * @method bindEndpointParams
     * @param {String} route Specification of route
     * @param {Object} params parameters
     *   @param {Number|Object|Function} params.{key} Value to bind
     * @return {String} Endpoint to witch parameters was bound
     * @example
     *     api.bindEndpointParams('/sites/:site_id/entries/:entry_id/comments/:comment_id', {
     *       blog_id: 1,
     *       entry_id: {id: 1},
     *       comment_id: functioin(){ return 1; }
     *     });
     * @category core
     */
    bindEndpointParams: function(route, params) {
        var k, v;

        for (k in params) {
            v = params[k];
            if (typeof v === 'object') {
                if (typeof v === 'function') {
                    v = v.id();
                }
                else {
                    v = v.id;
                }
            }
            if (typeof v === 'function') {
                v = v();
            }
            route = route.replace(new RegExp(':' + k), v);
        }
        return route;
    },

    _isElement: function(e, name) {
        if (! e || typeof e !== 'object') {
            return false;
        }
        var n = e.nodeName;
        return n && n.toLowerCase() === name;
    },

    _isFormElement: function(e) {
        return this._isElement(e, 'form');
    },

    _isInputElement: function(e) {
        return this._isElement(e, 'input');
    },

    _isFileInputElement: function(e) {
        return this._isInputElement(e) && e.type.toLowerCase() === 'file';
    },

    _serializeObject: function(v) {
        function f(n) {
            return n < 10 ? '0' + n : n;
        }

        function iso8601Date(v) {
            if (! isFinite(v.valueOf())) {
                return '';
            }

            var off,
                tz = v.getTimezoneOffset();
            if(tz === 0) {
                off = 'Z';
            }
            else {
                off  = (tz > 0 ? '-': '+');
                tz   = Math.abs(tz);
                off += f(Math.floor(tz / 60)) + ':' + f(tz % 60);
            }

            return v.getFullYear()     + '-' +
                f(v.getMonth() + 1) + '-' +
                f(v.getDate())      + 'T' +
                f(v.getHours())     + ':' +
                f(v.getMinutes())   + ':' +
                f(v.getSeconds())   + off;
        }

        if (this._isFormElement(v)) {
            v = this._serializeFormElementToObject(v);
        }

        var type = typeof v;
        if (type === 'undefined' || v === null || (type === 'number' && ! isFinite(v))) {
            return '';
        }
        else if (v instanceof Date) {
            return iso8601Date(v);
        }
        else if (window.File && v instanceof window.File) {
            return v;
        }
        else if (this._isFileInputElement(v)) {
            return v.files[0];
        }
        else if (type === 'object') {
            return this.serializeData(v, function(key, value) {
                if (this[key] instanceof Date) {
                    return iso8601Date(this[key]);
                }
                return value;
            });
        }
        else {
            return v;
        }
    },

    _serializeParams: function(params) {
        if (! params) {
            return params;
        }
        if (typeof params === 'string') {
            return params;
        }
        if (this._isFormElement(params)) {
            params = this._serializeFormElementToObject(params);
        }

        var k,
            str = '';
        for (k in params) {
            if (! params.hasOwnProperty(k)) {
                continue;
            }
            if (str) {
                str += '&';
            }

            str +=
                encodeURIComponent(k) + '=' +
                encodeURIComponent(this._serializeObject(params[k]));
        }
        return str;
    },

    _unserializeParams: function(params) {
        if (typeof params !== 'string') {
            return params;
        }

        var i, pair,
            data   = {},
            values = params.split('&');

        for(i = 0; i < values.length; i++) {
            pair = values[i].split('=');
            data[decodeURIComponent(pair[0])] = decodeURIComponent(pair[1]);
        }

        return data;
    },

    _newXMLHttpRequestStandard: function() {
        try {
            return new window.XMLHttpRequest();
        } catch( e ) {}
    },

    _newXMLHttpRequestActiveX: function() {
        try {
            return new window.ActiveXObject("Microsoft.XMLHTTP");
        } catch( e ) {}
    },

    /**
     * Create XMLHttpRequest by higher browser compatibility way
     * @method newXMLHttpRequest
     * @return {XMLHttpRequest} Created XMLHttpRequest
     * @category core
     */
    newXMLHttpRequest: function() {
        return this._newXMLHttpRequestStandard() ||
            this._newXMLHttpRequestActiveX() ||
            false;
    },

    _findFileInput: function(params) {
        if (typeof params !== 'object') {
            return null;
        }

        for (var k in params) {
            if (this._isFileInputElement(params[k])) {
                return params[k];
            }
        }

        return null;
    },

    _isEmptyObject: function(o) {
        if (! o) {
            return true;
        }

        for (var k in o) {
            if (o.hasOwnProperty(k)) {
                return false;
            }
        }
        return true;
    },

    /**
     * Send request to specified URL with params via XMLHttpRequest
     * @method sendXMLHttpRequest
     * @param {XMLHttpRequest} xhr XMLHttpRequest object to send request
     * @param {String} method Request method
     * @param {String} url Request URL
     * @param {String|FormData} params Parameters to send with request
     * @return {XMLHttpRequest}
     * @category core
     */
    sendXMLHttpRequest: function(xhr, method, url, params) {
        var k, headers, uk,
            authHeader = this.getAuthorizationHeader();

        xhr.open(method, url, this.o.async);
        if (typeof params === 'string') {
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        }
        xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
        if (authHeader) {
            xhr.setRequestHeader('X-MT-Authorization', authHeader);
        }

        function normalizeHeaderKey(all, prefix, letter) {
            return prefix + letter.toUpperCase();
        }
        if (params && params.getHeaders) {
            headers = params.getHeaders();
            for (k in headers) {
                uk = k.replace(/(^|-)([a-z])/g, normalizeHeaderKey);
                xhr.setRequestHeader(uk, headers[k]);
            }
        }

        xhr.send(params);

        return xhr;
    },

    _serializeFormElementToObject: function(form) {
        var i, e, type,
            data           = {},
            submitterTypes = /^(?:submit|button|image|reset)$/i,
            submittable    = /^(?:input|select|textarea|keygen)/i,
            checkableTypes = /^(?:checkbox|radio)$/i;

        for (i = 0; i < form.elements.length; i++) {
            e    = form.elements[i];
            type = e.type;

            if (
                    ! e.name ||
                    e.disabled ||
                    ! submittable.test(e.nodeName) ||
                    submitterTypes.test(type) ||
                    (checkableTypes.test(type) && ! e.checked)
            ) {
                continue;
            }

            if (this._isFileInputElement(e)) {
                data[e.name] = e;
            }
            else {
                data[e.name] = this._elementValue(e);
            }
        }

        return data;
    },

    _elementValue: function(e) {
        if (e.nodeName.toLowerCase() === 'select') {
            var value, option,
                options = e.options,
                index = e.selectedIndex,
                one = e.type === "select-one" || index < 0,
                values = one ? null : [],
                max = one ? index + 1 : options.length,
                i = index < 0 ?
                    max :
                    one ? index : 0;

            // Loop through all the selected options
            for ( ; i < max; i++ ) {
                option = options[ i ];

                // oldIE doesn't update selected after form reset (#2551)
                if ( ( option.selected || i === index ) &&
                        // Don't return options that are disabled or in a disabled optgroup
                        ( !option.parentNode.disabled || option.parentNode.nodeName.toLowerCase() !== "optgroup" ) ) {

                    // Get the specific value for the option
                    value = option.attributes.value;
                    if (!value || value.specified) {
                        value = option.value;
                    }
                    else {
                        value = e.text;
                    }

                    // We don't need an array for one selects
                    if ( one ) {
                        return value;
                    }

                    // Multi-Selects return an array
                    values.push( value );
                }
            }

            return values;
        }
        else {
            return e.value;
        }
    },

    /**
     * Execute function with specified options
     * @method withOptions
     * @param {option} option Option to overwrite
     * @param {Function} func Function to execute
     * @return Return value of specified func
     * @example
     *     // The DataAPI object is created with {async: true}
     *     api.withOptions({async: false}, function() {
     *       api.listEntries(1, function() {
     *         // This is executed synchronously
     *       });
     *     });
     *     api.listEntries(1, function() {
     *       // This is executed asynchronously
     *     });
     * @category core
     */
    withOptions: function(option, func) {
        var k, result,
            originalOption = this.o,
            o = {};

        for (k in originalOption) {
            o[k] = originalOption[k];
        }
        for (k in option) {
            o[k] = option[k];
        }

        this.o = o;
        result = func.apply(this);
        this.o = originalOption;

        return result;
    },

    /**
     * Execute function with specified options
     * @method request
     * @param {String} method Request method
     * @param {String} endpoint Endpoint to request
     * @param {String|Object} [queryParameter]
     * @param {String|Object|HTMLFormElement|FormData} [requestData]
     *   @param {String|Object|HTMLFormElement} [requestData.{requires-json-text}] Can specify json-text value by string or object or HTMLFormElement. Serialize automatically if object or HTMLFormElement is passed.
     *   @param {HTMLInputElement|File} [requestData.{requires-file}] Can specify file value by HTMLInputElement or File object.
     * @param {Function} [callback]
     * @return {XMLHttpRequest|null} Return XMLHttpRequest if request is sent
     *   via XMLHttpRequest. Return null if request is not sent
     *   via XMLHttpRequest (e.g. sent via iframe).
     * @category core
     */
    request: function(method, endpoint) {
        var i, k, v, base,
            api        = this,
            paramsList = [],
            params     = null,
            callback   = function(){},
            xhr        = null,
            viaXhr     = true,
            currentFormat     = this.getCurrentFormat(),
            originalArguments = Array.prototype.slice.call(arguments),
            defaultParams     = {};

        function serializeParams(params) {
            var k, data;

            if (! api.o.disableFormData && window.FormData) {
                if (params instanceof window.FormData) {
                    return params;
                }
                else if (api._isFormElement(params)) {
                    return new window.FormData(params);
                }
                else if (window.FormData && typeof params === 'object') {
                    data = new window.FormData();
                    for (k in params) {
                        data.append(k, api._serializeObject(params[k]));
                    }
                    return data;
                }
            }


            if (api._isFormElement(params)) {
                params = api._serializeFormElementToObject(params);
                for (k in params) {
                    if (params[k] instanceof Array) {
                        params[k] = params[k].join(',');
                    }
                }
            }

            if (api._findFileInput(params)) {
                viaXhr = false;

                data = {};
                for (k in params) {
                    if (api._isFileInputElement(params[k])) {
                        data[k] = params[k];
                    }
                    else {
                        data[k] = api._serializeObject(params[k]);
                    }
                }
                params = data;
            }
            else if (typeof params !== 'string') {
                params = api._serializeParams(params);
            }

            return params;
        }

        function runCallback(response) {
            var status = callback(response);
            if (status !== false) {
                if (response.error) {
                    api.trigger('error', response);
                }
            }
            return status;
        }

        function needToRetry(response) {
            return response.error &&
                response.error.code === 401 &&
                endpoint !== '/token';
        }

        function retry() {
            api.request('POST', '/token', function(response) {
                if (response.error && response.error.code === 401) {
                    var status = runCallback(response);
                    if (status !== false) {
                        api.trigger('authorizationRequired', response);
                    }
                }
                else {
                    api.storeTokenData(response);
                    api.request.apply(api, originalArguments);
                }
                return false;
            });
        }

        function appendParamsToURL(base, params) {
            if (base.indexOf('?') === -1) {
                base += '?';
            }
            else {
                base += '&';
            }
            return base + api._serializeParams(params);
        }


        if (endpoint === '/token' || endpoint === '/authentication') {
            defaultParams.clientId = this.o.clientId;
        }

        if (! this.o.cache) {
            defaultParams._ = new Date().getTime();
        }

        if (currentFormat !== DataAPI.getDefaultFormat()) {
            defaultParams.format = currentFormat.fileExtension;
        }

        for (i = 2; i < arguments.length; i++) {
            v = arguments[i];
            switch (typeof v) {
            case 'function':
                callback = v;
                break;
            case 'object':
                if (
                    v &&
                    ! v.nodeName &&
                    ((window.ActiveXObject && v instanceof window.ActiveXObject) ||
                     (window.XMLHttpRequest && v instanceof window.XMLHttpRequest))
                ) {
                    xhr = v;
                }
                else {
                    paramsList.push(v);
                }
                break;
            case 'string':
                paramsList.push(this._unserializeParams(v));
                break;
            }
        }

        if (paramsList.length && (method.toLowerCase() === 'get' || paramsList.length >= 2)) {
            endpoint = appendParamsToURL(endpoint, paramsList.shift());
        }

        if (method.match(/^(put|delete)$/i)) {
            defaultParams.__method = method;
            method = 'POST';
        }

        if (paramsList.length) {
            params = paramsList.shift();
        }

        if (! this._isEmptyObject(defaultParams)) {
            if (method.toLowerCase() === 'get') {
                endpoint = appendParamsToURL(endpoint, defaultParams);
            }
            else if (window.FormData && params && params instanceof window.FormData) {
                for (k in defaultParams) {
                    params.append(k, defaultParams[k]);
                }
            }
            else {
                params = params || {};
                for (k in defaultParams) {
                    params[k] = defaultParams[k];
                }
            }
        }

        params = serializeParams(params);


        base = this.o.baseUrl.replace(/\/*$/, '/') + 'v' + this.getVersion();
        endpoint = endpoint.replace(/^\/*/, '/');

        if (viaXhr) {
            xhr = xhr || this.newXMLHttpRequest();
            xhr.onreadystatechange = function() {
                if (xhr.readyState !== 4) {
                    return;
                }

                var response, mimeType, format, url;

                try {
                    mimeType = xhr.getResponseHeader('Content-Type');
                    format   = api.findFormat(mimeType) || api.getCurrentFormat();
                    response = format.unserialize(xhr.responseText);
                }
                catch (e) {
                    response = {
                        error: {
                            code:    parseInt(xhr.status, 10),
                            message: xhr.statusText
                        }
                    };
                }

                function cleanup() {
                    xhr.onreadystatechange = function(){};
                }

                if (needToRetry(response)) {
                    retry();
                    cleanup();
                    return;
                }

                runCallback(response);

                url = xhr.getResponseHeader('X-MT-Next-Phase-URL');
                if (url) {
                    xhr.abort();
                    api.sendXMLHttpRequest(xhr, method, base + url, params);
                }
                else {
                    cleanup();
                }
            };
            return this.sendXMLHttpRequest(xhr, method, base + endpoint, params);
        }
        else {
            (function() {
                var k, file, originalName, input,
                    target     = api._getNextIframeName(),
                    doc        = window.document,
                    form       = doc.createElement('form'),
                    iframe     = doc.createElement('iframe'),
                    authHeader = api.getAuthorizationHeader();


                // Set up a form element
                form.action        = base + endpoint;
                form.target        = target;
                form.method        = method;
                form.style.display = 'inline';
                form.encoding      = 'multipart/form-data';
                form.enctype       = 'multipart/form-data';

                // Set up a iframe element
                iframe.name           = target;
                iframe.style.position = 'absolute';
                iframe.style.top      = '-9999px';
                doc.body.appendChild(iframe);
                iframe.contentWindow.name = target;


                params = params || {};
                if (authHeader) {
                    params['X-MT-Authorization'] = authHeader;
                }
                params['X-MT-Requested-Via'] = 'IFRAME';

                for (k in params) {
                    if (api._isFileInputElement(params[k])) {
                        file         = params[k];
                        originalName = file.name;
                        file.name    = k;
                        if (file.parentNode) {
                            file.parentNode.insertBefore(form, file);
                        }
                        else {
                            doc.body.appendChild(form);
                        }
                        form.appendChild(file);
                        continue;
                    }

                    input       = doc.createElement('input');
                    input.type  = 'hidden';
                    input.name  = k;
                    input.value = params[k];
                    form.appendChild(input);
                }

                form.submit();


                function handler() {
                    var body     = iframe.contentWindow.document.body,
                        contents = body.textContent || body.innerText,
                        response;

                    function cleanup() {
                        setTimeout(function() {
                            file.name = originalName;
                            if (form.parentNode) {
                                form.parentNode.insertBefore(file, form);
                                form.parentNode.removeChild(form);
                            }
                            if (iframe.parentNode) {
                                iframe.parentNode.removeChild(iframe);
                            }
                        });
                    }

                    try {
                        response = api.unserializeData(contents);
                    }
                    catch (e) {
                        response = {
                            error: {
                                code:    500,
                                message: 'Internal Server Error'
                            }
                        };
                    }

                    if (needToRetry(response)) {
                        retry();
                        cleanup();
                        return;
                    }

                    cleanup();
                    runCallback(response);
                }
                if ( iframe.addEventListener ) {
                    iframe.addEventListener('load', handler, false);
                } else if ( iframe.attachEvent ) {
                    iframe.attachEvent('onload', handler);
                }
            })();

            return;
        }
    },

    /**
     * Register callback to instance.
     * @method on
     * @param {String} key Event name
     * @param {Function} callback Callback function
     * @category core
     */
    on: DataAPI.on,

    /**
     * Deregister callback from instance.
     * @method off
     * @param {String} key Event name
     * @param {Function} callback Callback function
     * @category core
     */
    off: DataAPI.off,

    /**
     * Trigger event
     * First, run class level callbacks. Then, run instance level callbacks.
     * @method trigger
     * @param {String} key Event name
     * @category core
     */
    trigger: function(key) {
        var i,
            args      = Array.prototype.slice.call(arguments, 1),
            callbacks = (DataAPI.callbacks[key] || []) // Class level
                .concat(this.callbacks[key] || []); // Instance level

        for (i = 0; i < callbacks.length; i++) {
            callbacks[i].apply(this, args);
        }
    },

    _generateEndpointMethod: function(e) {
        var api       = this,
            varRegexp = new RegExp(':([a-zA-Z_-]+)', 'g'),
            vars      = null,
            name      = e.id.replace(/_(\w)/g, function(all, letter) {
                            return letter.toUpperCase();
                        });

        function extractVars() {
            var m, vars = [];
            while ((m = varRegexp.exec(e.route)) !== null) {
                vars.push(m[1]);
            }
            return vars;
        }

        api[name] = function() {
            if (! vars) {
                vars = extractVars();
            }

            var args           = Array.prototype.slice.call(arguments),
                endpointParams = {},
                resources      = {},
                route, i;

            for (i = 0; i < vars.length; i++) {
                endpointParams[vars[i]] = args.shift();
            }
            route = api.bindEndpointParams(e.route, endpointParams);

            if (e.resources) {
                for (i = 0; i < e.resources.length; i++) {
                    resources[e.resources[i]] = args.shift();
                }
                args.push(resources);
            }

            return api.request.apply(api, [e.verb, route].concat(args));
        };
    },

    /**
     * Generate endpoint methods
     * @method generateEndpointMethods
     * @param {Array.Object} endpoints Endpoints to register
     *   @param {Object} endpoints.{i}
     *     @param {String} endpoints.{i}.id
     *     @param {String} endpoints.{i}.route
     *     @param {String} endpoints.{i}.verb
     *     @param {Array.String} [endpoints.{i}.resources]
     * @example
     *     api.generateEndpointMethods([
     *       {
     *           "id": "list_entries",
     *           "route": "/sites/:site_id/entries",
     *           "verb": "GET",
     *       },
     *       {
     *           "id": "create_entry",
     *           "route": "/sites/:site_id/entries",
     *           "verb": "POST",
     *           "resources": [
     *               "entry"
     *           ]
     *       }
     *     ]);
     * @category core
     */
    generateEndpointMethods: function(endpoints) {
        for (var i = 0; i < endpoints.length; i++) {
            this._generateEndpointMethod(endpoints[i]);
        }
    },

    /**
     * Load endpoint from DataAPI dynamically
     * @method loadEndpoints
     * @param {Object} [params]
     *   @param {String} [params.includeComponents] Comma separated component IDs to load
     *   @param {String} [params.excludeComponents] Comma separated component IDs to exclude
     * @example
     * Load endpoints only from specified module.
     *
     *     api.loadEndpoints({
     *       includeComponents: 'your-extension-module'
     *     });
     *     api.getDataViaYourExtensionModule(function(response) {
     *       // Do stuff
     *     });
     *
     * Load all endpoints except for core.
     * Since all the endpoints of core is already loaded.
     *
     *     api.loadEndpoints({
     *       excludeComponents: 'core'
     *     });
     *     api.getDataViaYourExtensionModule(function(response) {
     *       // Do stuff
     *     });
     * @category core
     */
    loadEndpoints: function(params) {
        var api = this;

        api.withOptions({async: false}, function() {
            api.request('GET', '/endpoints', params, function(response) {
                if (response.error) {
                    return;
                }

                api.generateEndpointMethods(response.items);
            });
        });
    }
};

/**
 * Triggered on initializing an instance
 *
 * @event initialize
 **/

/**
 * Triggered on getting an error of a HTTP request
 *
 * @event error
 * @param {Object} response A response object
 *   @param {Number} response.code The HTTP response code
 *   @param {String} response.message The error message
 *   @param {Object} response.data The data exists only if a current error has optional data
 * @example
 *     api.on("error", function(response) {
 *       console.log(response.message);
 *     });
 **/

/**
 * Fired on response code is 401
 *
 * @event authorizationRequired
 * @param {Object} response A response object
 *   @param {Number} response.code The HTTP response code
 *   @param {Number} response.message The error message
 * @example
 *     api.on("authorizationRequired", function(response) {
 *       // You will return to current URL after authorization succeeded.
 *       location.href = api.getAuthorizationUrl(location.href);
 *     });
 **/


window.MT         = window.MT || {};
window.MT.DataAPI = window.MT.DataAPI || DataAPI;
window.MT.DataAPI['v' + DataAPI.version] = DataAPI;



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
        if (! window.document) {
            return undefined;
        }

        var prefix = escape( this.name ) + "=";
        var cookies = ("" + window.document.cookie).split( /;\s*/ );
        
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
        if (! window.document) {
            return undefined;
        }

        function exists(x) {
            return (x === undefined || x === null) ? false : true;
        };

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
        window.document.cookie = batter;

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


var JSON = window.JSON;
/*
    json2.js
    2012-10-08

    Public Domain.

    NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.

    See http://www.JSON.org/js.html


    This code should be minified before deployment.
    See http://javascript.crockford.com/jsmin.html

    USE YOUR OWN COPY. IT IS EXTREMELY UNWISE TO LOAD CODE FROM SERVERS YOU DO
    NOT CONTROL.


    This file creates a global JSON object containing two methods: stringify
    and parse.

        JSON.stringify(value, replacer, space)
            value       any JavaScript value, usually an object or array.

            replacer    an optional parameter that determines how object
                        values are stringified for objects. It can be a
                        function or an array of strings.

            space       an optional parameter that specifies the indentation
                        of nested structures. If it is omitted, the text will
                        be packed without extra whitespace. If it is a number,
                        it will specify the number of spaces to indent at each
                        level. If it is a string (such as '\t' or '&nbsp;'),
                        it contains the characters used to indent at each level.

            This method produces a JSON text from a JavaScript value.

            When an object value is found, if the object contains a toJSON
            method, its toJSON method will be called and the result will be
            stringified. A toJSON method does not serialize: it returns the
            value represented by the name/value pair that should be serialized,
            or undefined if nothing should be serialized. The toJSON method
            will be passed the key associated with the value, and this will be
            bound to the value

            For example, this would serialize Dates as ISO strings.

                Date.prototype.toJSON = function (key) {
                    function f(n) {
                        // Format integers to have at least two digits.
                        return n < 10 ? '0' + n : n;
                    }

                    return this.getUTCFullYear()   + '-' +
                         f(this.getUTCMonth() + 1) + '-' +
                         f(this.getUTCDate())      + 'T' +
                         f(this.getUTCHours())     + ':' +
                         f(this.getUTCMinutes())   + ':' +
                         f(this.getUTCSeconds())   + 'Z';
                };

            You can provide an optional replacer method. It will be passed the
            key and value of each member, with this bound to the containing
            object. The value that is returned from your method will be
            serialized. If your method returns undefined, then the member will
            be excluded from the serialization.

            If the replacer parameter is an array of strings, then it will be
            used to select the members to be serialized. It filters the results
            such that only members with keys listed in the replacer array are
            stringified.

            Values that do not have JSON representations, such as undefined or
            functions, will not be serialized. Such values in objects will be
            dropped; in arrays they will be replaced with null. You can use
            a replacer function to replace those with JSON values.
            JSON.stringify(undefined) returns undefined.

            The optional space parameter produces a stringification of the
            value that is filled with line breaks and indentation to make it
            easier to read.

            If the space parameter is a non-empty string, then that string will
            be used for indentation. If the space parameter is a number, then
            the indentation will be that many spaces.

            Example:

            text = JSON.stringify(['e', {pluribus: 'unum'}]);
            // text is '["e",{"pluribus":"unum"}]'


            text = JSON.stringify(['e', {pluribus: 'unum'}], null, '\t');
            // text is '[\n\t"e",\n\t{\n\t\t"pluribus": "unum"\n\t}\n]'

            text = JSON.stringify([new Date()], function (key, value) {
                return this[key] instanceof Date ?
                    'Date(' + this[key] + ')' : value;
            });
            // text is '["Date(---current time---)"]'


        JSON.parse(text, reviver)
            This method parses a JSON text to produce an object or array.
            It can throw a SyntaxError exception.

            The optional reviver parameter is a function that can filter and
            transform the results. It receives each of the keys and values,
            and its return value is used instead of the original value.
            If it returns what it received, then the structure is not modified.
            If it returns undefined then the member is deleted.

            Example:

            // Parse the text. Values that look like ISO date strings will
            // be converted to Date objects.

            myData = JSON.parse(text, function (key, value) {
                var a;
                if (typeof value === 'string') {
                    a =
/^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2}(?:\.\d*)?)Z$/.exec(value);
                    if (a) {
                        return new Date(Date.UTC(+a[1], +a[2] - 1, +a[3], +a[4],
                            +a[5], +a[6]));
                    }
                }
                return value;
            });

            myData = JSON.parse('["Date(09/09/2001)"]', function (key, value) {
                var d;
                if (typeof value === 'string' &&
                        value.slice(0, 5) === 'Date(' &&
                        value.slice(-1) === ')') {
                    d = new Date(value.slice(5, -1));
                    if (d) {
                        return d;
                    }
                }
                return value;
            });


    This is a reference implementation. You are free to copy, modify, or
    redistribute.
*/

/*jslint evil: true, regexp: true */

/*members "", "\b", "\t", "\n", "\f", "\r", "\"", JSON, "\\", apply,
    call, charCodeAt, getUTCDate, getUTCFullYear, getUTCHours,
    getUTCMinutes, getUTCMonth, getUTCSeconds, hasOwnProperty, join,
    lastIndex, length, parse, prototype, push, replace, slice, stringify,
    test, toJSON, toString, valueOf
*/


// Create a JSON object only if one does not already exist. We create the
// methods in a closure to avoid creating global variables.

if (typeof JSON !== 'object') {
    JSON = {};
}

(function () {
    'use strict';

    function f(n) {
        // Format integers to have at least two digits.
        return n < 10 ? '0' + n : n;
    }

    var cx = /[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,
        escapable = /[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,
        gap,
        indent,
        meta = {    // table of character substitutions
            '\b': '\\b',
            '\t': '\\t',
            '\n': '\\n',
            '\f': '\\f',
            '\r': '\\r',
            '"' : '\\"',
            '\\': '\\\\'
        },
        rep;


    function quote(string) {

// If the string contains no control characters, no quote characters, and no
// backslash characters, then we can safely slap some quotes around it.
// Otherwise we must also replace the offending characters with safe escape
// sequences.

        escapable.lastIndex = 0;
        return escapable.test(string) ? '"' + string.replace(escapable, function (a) {
            var c = meta[a];
            return typeof c === 'string'
                ? c
                : '\\u' + ('0000' + a.charCodeAt(0).toString(16)).slice(-4);
        }) + '"' : '"' + string + '"';
    }


    function str(key, holder) {

// Produce a string from holder[key].

        var i,          // The loop counter.
            k,          // The member key.
            v,          // The member value.
            length,
            mind = gap,
            partial,
            value = holder[key];

// If the value has a toJSON method, call it to obtain a replacement value.

        if (value && typeof value === 'object' &&
                typeof value.toJSON === 'function') {
            value = value.toJSON(key);
        }

// If we were called with a replacer function, then call the replacer to
// obtain a replacement value.

        if (typeof rep === 'function') {
            value = rep.call(holder, key, value);
        }

// What happens next depends on the value's type.

        switch (typeof value) {
        case 'string':
            return quote(value);

        case 'number':

// JSON numbers must be finite. Encode non-finite numbers as null.

            return isFinite(value) ? String(value) : 'null';

        case 'boolean':
        case 'null':

// If the value is a boolean or null, convert it to a string. Note:
// typeof null does not produce 'null'. The case is included here in
// the remote chance that this gets fixed someday.

            return String(value);

// If the type is 'object', we might be dealing with an object or an array or
// null.

        case 'object':

// Due to a specification blunder in ECMAScript, typeof null is 'object',
// so watch out for that case.

            if (!value) {
                return 'null';
            }

// Make an array to hold the partial results of stringifying this object value.

            gap += indent;
            partial = [];

// Is the value an array?

            if (Object.prototype.toString.apply(value) === '[object Array]') {

// The value is an array. Stringify every element. Use null as a placeholder
// for non-JSON values.

                length = value.length;
                for (i = 0; i < length; i += 1) {
                    partial[i] = str(i, value) || 'null';
                }

// Join all of the elements together, separated with commas, and wrap them in
// brackets.

                v = partial.length === 0
                    ? '[]'
                    : gap
                    ? '[\n' + gap + partial.join(',\n' + gap) + '\n' + mind + ']'
                    : '[' + partial.join(',') + ']';
                gap = mind;
                return v;
            }

// If the replacer is an array, use it to select the members to be stringified.

            if (rep && typeof rep === 'object') {
                length = rep.length;
                for (i = 0; i < length; i += 1) {
                    if (typeof rep[i] === 'string') {
                        k = rep[i];
                        v = str(k, value);
                        if (v) {
                            partial.push(quote(k) + (gap ? ': ' : ':') + v);
                        }
                    }
                }
            } else {

// Otherwise, iterate through all of the keys in the object.

                for (k in value) {
                    if (Object.prototype.hasOwnProperty.call(value, k)) {
                        v = str(k, value);
                        if (v) {
                            partial.push(quote(k) + (gap ? ': ' : ':') + v);
                        }
                    }
                }
            }

// Join all of the member texts together, separated with commas,
// and wrap them in braces.

            v = partial.length === 0
                ? '{}'
                : gap
                ? '{\n' + gap + partial.join(',\n' + gap) + '\n' + mind + '}'
                : '{' + partial.join(',') + '}';
            gap = mind;
            return v;
        }
    }

// If the JSON object does not yet have a stringify method, give it one.

    if (typeof JSON.stringify !== 'function') {
        JSON.stringify = function (value, replacer, space) {

// The stringify method takes a value and an optional replacer, and an optional
// space parameter, and returns a JSON text. The replacer can be a function
// that can replace values, or an array of strings that will select the keys.
// A default replacer method can be provided. Use of the space parameter can
// produce text that is more easily readable.

            var i;
            gap = '';
            indent = '';

// If the space parameter is a number, make an indent string containing that
// many spaces.

            if (typeof space === 'number') {
                for (i = 0; i < space; i += 1) {
                    indent += ' ';
                }

// If the space parameter is a string, it will be used as the indent string.

            } else if (typeof space === 'string') {
                indent = space;
            }

// If there is a replacer, it must be a function or an array.
// Otherwise, throw an error.

            rep = replacer;
            if (replacer && typeof replacer !== 'function' &&
                    (typeof replacer !== 'object' ||
                    typeof replacer.length !== 'number')) {
                throw new Error('JSON.stringify');
            }

// Make a fake root object containing our value under the key of ''.
// Return the result of stringifying the value.

            return str('', {'': value});
        };
    }


// If the JSON object does not yet have a parse method, give it one.

    if (typeof JSON.parse !== 'function') {
        JSON.parse = function (text, reviver) {

// The parse method takes a text and an optional reviver function, and returns
// a JavaScript value if the text is a valid JSON text.

            var j;

            function walk(holder, key) {

// The walk method is used to recursively walk the resulting structure so
// that modifications can be made.

                var k, v, value = holder[key];
                if (value && typeof value === 'object') {
                    for (k in value) {
                        if (Object.prototype.hasOwnProperty.call(value, k)) {
                            v = walk(value, k);
                            if (v !== undefined) {
                                value[k] = v;
                            } else {
                                delete value[k];
                            }
                        }
                    }
                }
                return reviver.call(holder, key, value);
            }


// Parsing happens in four stages. In the first stage, we replace certain
// Unicode characters with escape sequences. JavaScript handles many characters
// incorrectly, either silently deleting them, or treating them as line endings.

            text = String(text);
            cx.lastIndex = 0;
            if (cx.test(text)) {
                text = text.replace(cx, function (a) {
                    return '\\u' +
                        ('0000' + a.charCodeAt(0).toString(16)).slice(-4);
                });
            }

// In the second stage, we run the text against regular expressions that look
// for non-JSON patterns. We are especially concerned with '()' and 'new'
// because they can cause invocation, and '=' because it can cause mutation.
// But just to be safe, we want to reject all unexpected forms.

// We split the second stage into 4 regexp operations in order to work around
// crippling inefficiencies in IE's and Safari's regexp engines. First we
// replace the JSON backslash pairs with '@' (a non-JSON character). Second, we
// replace all simple value tokens with ']' characters. Third, we delete all
// open brackets that follow a colon or comma or that begin the text. Finally,
// we look to see that the remaining characters are only whitespace or ']' or
// ',' or ':' or '{' or '}'. If that is so, then the text is safe for eval.

            if (/^[\],:{}\s]*$/
                    .test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g, '@')
                        .replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g, ']')
                        .replace(/(?:^|:|,)(?:\s*\[)+/g, ''))) {

// In the third stage we use the eval function to compile the text into a
// JavaScript structure. The '{' operator is subject to a syntactic ambiguity
// in JavaScript: it can begin a block or an object literal. We wrap the text
// in parens to eliminate the ambiguity.

                j = eval('(' + text + ')');

// In the optional fourth stage, we recursively walk the new structure, passing
// each name/value pair to a reviver function for possible transformation.

                return typeof reviver === 'function'
                    ? walk({'': j}, '')
                    : j;
            }

// If the text is not JSON parseable, then a SyntaxError is thrown.

            throw new SyntaxError('JSON.parse');
        };
    }
}());

if ( typeof module === 'object' && module && typeof module.exports === 'object' ) {
    module.exports = window.MT.DataAPI;
}

})(typeof window === 'undefined' ? null : window);
