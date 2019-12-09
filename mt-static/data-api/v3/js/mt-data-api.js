/*
 * Movable Type DataAPI SDK for JavaScript v3
 * https://github.com/movabletype/mt-data-api-sdk-js
 * Copyright (c) 2013-2019 Six Apart Ltd.
 * This program is distributed under the terms of the MIT license.
 *
 * Includes jQuery JavaScript Library in some parts.
 * http://jquery.com/
 * Copyright 2005, 2013 jQuery Foundation, Inc. and other contributors
 * Released under the MIT license
 * http://jquery.org/license
 */

;(function(window, factory) {
    var DataAPI = factory(window);

    if ( typeof module === "object" && typeof module.exports === "object" ) {
        module.exports = DataAPI;
    } else {
        if ( typeof define === "function" && define.amd ) {
            define("mt-data-api", [], function() {
                return DataAPI;
            });
        }
    }
}(typeof window === "undefined" ? undefined : window, function(window, undefined) {

"use strict";

/**
 * @namespace MT
 */

/**
 * The MT.DataAPI is a client class for accessing to the Movable Type DataAPI.
 * @class DataAPI
 * @constructor
 * @param {Object} options Options.
 *   @param {String} options.clientId Client ID
 *     This value allows alphanumeric, (_)underscore, (-)dash.
 *   @param {String} options.baseUrl The absolute CGI URL of the DataAPI.
 *     (e.g. http://example.com/mt/mt-data-api.cgi)
 *   @param {String} [options.format] The format to serialize.
 *   @param {String} [options.sessionStore] The session store.
 *     In browser, the cookie is used by default.
 *   @param {String} [options.sessionDomain] The session domain.
 *     When using the cookie, this value is used as cookie domain.
 *   @param {String} [options.sessionPath] The session path
 *     When using the cookie, this value is used as cookie path.
 *   @param {Boolean} [options.async] If true, use asynchronous
 *      XMLHttpRequest. The default value is the true.
 *   @param {Number} [options.timeout] The number of milliseconds a
 *      request can take before automatically being terminated.
 *      The default value is not set up, browser's default is used.
 *   @param {Boolean} [options.cache] If false, add an additional
 *      parameter "_" to request to avoid cache. The default value
 *      is the true.
 *   @param {Boolean} [options.withoutAuthorization] If true,
 *      the "X-MT-Authorization" request header is not sent even if
 *      already got accessToken. The default value is the false.
 *   @param {Boolean} [options.loadPluginEndpoints] If true, load
 *      endpoint data extended by plugin and generate methods to
 *      access that endpoint automatically. The default value is
 *      the true.
 *      (However even if this option's value is false, you are able
 *      to use all the methods to access to core endpoint.)
 *   @param {Boolean} [options.suppressResponseCodes] If true, add
 *      suppressResponseCodes parameter to each request. As a result,
 *      the Data API always returns 200 as HTTP response code.
 *      The default value is not set up.
 *      The default value is the false when requested via XMLHttpRequest
 *      or IFRAME. The default value is the true when requested via
 *      XDomainRequest.
 *   @param {Boolean} [options.crossOrigin] If true, requests are sent as
 *      a cross-domain request. The default value is assigned
 *      automatically by document's URL and baseUrl.
 *   @param {Boolean(} [options.disableFormData] If false,use FormData
 *      class when available that. The default value is the false.
 */
var DataAPI = function(options) {
    var i, k,
        requireds = ['clientId', 'baseUrl'];

    this.o = {
        clientId: undefined,
        baseUrl: undefined,
        format: undefined,
        sessionStore: undefined,
        sessionDomain: undefined,
        sessionPath: undefined,
        async: true,
        timeout: undefined,
        cache: true,
        withoutAuthorization: false,
        processOneTimeTokenOnInitialize: true,
        loadPluginEndpoints: true,
        suppressResponseCodes: undefined,
        crossOrigin: undefined,
        disableFormData: false
    };
    for (k in options) {
        if (k in this.o) {
            this.o[k] = options[k];
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

    this._initOptions();

    if (this.o.loadPluginEndpoints) {
        this.loadEndpoints({
            excludeComponents: 'core'
        });
    }

    if (this.o.processOneTimeTokenOnInitialize) {
        this._storeOneTimeToken();
    }

    this.trigger('initialize');
};


/**
 * The API version.
 * @property version
 * @static
 * @private
 * @type Number
 */
DataAPI.version = 3;

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
 * The default format that serializes data.
 * @property defaultFormat
 * @static
 * @private
 * @type String
 */
DataAPI.defaultFormat = 'json';

/**
 * The default session store.
 * @property defaultSessionStore
 * @static
 * @private
 * @type String
 */
DataAPI.defaultSessionStore = window.document ? 'cookie-encrypted' : 'fs';

/**
 * Class level callbacks function data.
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
 * Available session stores.
 * @property sessionStores
 * @static
 * @private
 * @type Object
 */
DataAPI.sessionStores = {};
;(function() {

function fetchCookieValues(name) {
    var cookie = Cookie.fetch(name);

    if (! cookie) {
        return {};
    }

    try {
        return JSON.parse(cookie.value);
    }
    catch (e) {
        return {
            data: cookie.value
        };
    }
}

function fillinDefaultCookieValues(values, o) {
    var path = values.path,
        currentPath = extractPath(documentUrl());
    if (! path || path.length > currentPath.length) {
        path = currentPath;
    }

    return {
        data: values.data,
        domain: ( typeof o === 'undefined' ? undefined : o.sessionDomain ) || values.domain || undefined,
        path: ( typeof o === 'undefined' ? undefined : o.sessionPath ) || path
    };
}

function documentUrl() {
    if (! window.location) {
        return '';
    }

    var loc;

    // IE may throw an exception when accessing
    // a field from window.location if document.domain has been set
    try {
        loc = window.location.href;
    } catch( e ) {
        // Use the href attribute of an A element
        // since IE will modify it given document.location
        loc = window.document.createElement( "a" );
        loc.href = "";
        loc = loc.href;
    }

    return loc;
}

function extractPath(url) {
    var urlRegexp = /^[\w.+-]+:(?:\/\/[^\/?#:]*(?::\d+|)|)(.*)\/[^\/]*$/,
        match     = urlRegexp.exec(url.toLowerCase());

    return match ? match[1] : null;
}

DataAPI.sessionStores['cookie'] = {
    save: function(name, data, remember) {
        var expires = remember ? new Date(new Date().getTime() + 315360000000) : undefined, // after 10 years
            values  = fillinDefaultCookieValues(fetchCookieValues(name), this.o);
        Cookie.bake(name, JSON.stringify(values), values.domain, values.path, expires);
    },
    fetch: function(name) {
        fetchCookieValues(name).data;
    },
    remove: function(name) {
        var values = fillinDefaultCookieValues(fetchCookieValues(name));
        Cookie.bake(name, '', values.domain, values.path, new Date(0));
    }
};

})();

;(function() {

/** @fileOverview Javascript cryptography implementation.
 *
 * Crush to remove comments, shorten variable names and
 * generally reduce transmission size.
 *
 * @author Emily Stark
 * @author Mike Hamburg
 * @author Dan Boneh
 */

"use strict";
/*jslint indent: 2, bitwise: false, nomen: false, plusplus: false, white: false, regexp: false */
/*global document, window, escape, unescape */

/** @namespace The Stanford Javascript Crypto Library, top-level namespace. */
var sjcl = {
  /** @namespace Symmetric ciphers. */
  cipher: {},

  /** @namespace Hash functions.  Right now only SHA256 is implemented. */
  hash: {},
  
  /** @namespace Block cipher modes of operation. */
  mode: {},

  /** @namespace Miscellaneous.  HMAC and PBKDF2. */
  misc: {},
  
  /**
   * @namespace Bit array encoders and decoders.
   *
   * @description
   * The members of this namespace are functions which translate between
   * SJCL's bitArrays and other objects (usually strings).  Because it
   * isn't always clear which direction is encoding and which is decoding,
   * the method names are "fromBits" and "toBits".
   */
  codec: {},
  
  /** @namespace Exceptions. */
  exception: {
    /** @class Ciphertext is corrupt. */
    corrupt: function(message) {
      this.toString = function() { return "CORRUPT: "+this.message; };
      this.message = message;
    },
    
    /** @class Invalid parameter. */
    invalid: function(message) {
      this.toString = function() { return "INVALID: "+this.message; };
      this.message = message;
    },
    
    /** @class Bug or missing feature in SJCL. */
    bug: function(message) {
      this.toString = function() { return "BUG: "+this.message; };
      this.message = message;
    },

    /** @class Something isn't ready. */
    notReady: function(message) {
      this.toString = function() { return "NOT READY: "+this.message; };
      this.message = message;
    }
  }
};
/** @fileOverview Low-level AES implementation.
 *
 * This file contains a low-level implementation of AES, optimized for
 * size and for efficiency on several browsers.  It is based on
 * OpenSSL's aes_core.c, a public-domain implementation by Vincent
 * Rijmen, Antoon Bosselaers and Paulo Barreto.
 *
 * An older version of this implementation is available in the public
 * domain, but this one is (c) Emily Stark, Mike Hamburg, Dan Boneh,
 * Stanford University 2008-2010 and BSD-licensed for liability
 * reasons.
 *
 * @author Emily Stark
 * @author Mike Hamburg
 * @author Dan Boneh
 */

/**
 * Schedule out an AES key for both encryption and decryption.  This
 * is a low-level class.  Use a cipher mode to do bulk encryption.
 *
 * @constructor
 * @param {Array} key The key as an array of 4, 6 or 8 words.
 *
 * @class Advanced Encryption Standard (low-level interface)
 */
sjcl.cipher.aes = function (key) {
  if (!this._tables[0][0][0]) {
    this._precompute();
  }
  
  var i, j, tmp,
    encKey, decKey,
    sbox = this._tables[0][4], decTable = this._tables[1],
    keyLen = key.length, rcon = 1;
  
  if (keyLen !== 4 && keyLen !== 6 && keyLen !== 8) {
    throw new sjcl.exception.invalid("invalid aes key size");
  }
  
  this._key = [encKey = key.slice(0), decKey = []];
  
  // schedule encryption keys
  for (i = keyLen; i < 4 * keyLen + 28; i++) {
    tmp = encKey[i-1];
    
    // apply sbox
    if (i%keyLen === 0 || (keyLen === 8 && i%keyLen === 4)) {
      tmp = sbox[tmp>>>24]<<24 ^ sbox[tmp>>16&255]<<16 ^ sbox[tmp>>8&255]<<8 ^ sbox[tmp&255];
      
      // shift rows and add rcon
      if (i%keyLen === 0) {
        tmp = tmp<<8 ^ tmp>>>24 ^ rcon<<24;
        rcon = rcon<<1 ^ (rcon>>7)*283;
      }
    }
    
    encKey[i] = encKey[i-keyLen] ^ tmp;
  }
  
  // schedule decryption keys
  for (j = 0; i; j++, i--) {
    tmp = encKey[j&3 ? i : i - 4];
    if (i<=4 || j<4) {
      decKey[j] = tmp;
    } else {
      decKey[j] = decTable[0][sbox[tmp>>>24      ]] ^
                  decTable[1][sbox[tmp>>16  & 255]] ^
                  decTable[2][sbox[tmp>>8   & 255]] ^
                  decTable[3][sbox[tmp      & 255]];
    }
  }
};

sjcl.cipher.aes.prototype = {
  // public
  /* Something like this might appear here eventually
  name: "AES",
  blockSize: 4,
  keySizes: [4,6,8],
  */
  
  /**
   * Encrypt an array of 4 big-endian words.
   * @param {Array} data The plaintext.
   * @return {Array} The ciphertext.
   */
  encrypt:function (data) { return this._crypt(data,0); },
  
  /**
   * Decrypt an array of 4 big-endian words.
   * @param {Array} data The ciphertext.
   * @return {Array} The plaintext.
   */
  decrypt:function (data) { return this._crypt(data,1); },
  
  /**
   * The expanded S-box and inverse S-box tables.  These will be computed
   * on the client so that we don't have to send them down the wire.
   *
   * There are two tables, _tables[0] is for encryption and
   * _tables[1] is for decryption.
   *
   * The first 4 sub-tables are the expanded S-box with MixColumns.  The
   * last (_tables[01][4]) is the S-box itself.
   *
   * @private
   */
  _tables: [[[],[],[],[],[]],[[],[],[],[],[]]],

  /**
   * Expand the S-box tables.
   *
   * @private
   */
  _precompute: function () {
   var encTable = this._tables[0], decTable = this._tables[1],
       sbox = encTable[4], sboxInv = decTable[4],
       i, x, xInv, d=[], th=[], x2, x4, x8, s, tEnc, tDec;

    // Compute double and third tables
   for (i = 0; i < 256; i++) {
     th[( d[i] = i<<1 ^ (i>>7)*283 )^i]=i;
   }
   
   for (x = xInv = 0; !sbox[x]; x ^= x2 || 1, xInv = th[xInv] || 1) {
     // Compute sbox
     s = xInv ^ xInv<<1 ^ xInv<<2 ^ xInv<<3 ^ xInv<<4;
     s = s>>8 ^ s&255 ^ 99;
     sbox[x] = s;
     sboxInv[s] = x;
     
     // Compute MixColumns
     x8 = d[x4 = d[x2 = d[x]]];
     tDec = x8*0x1010101 ^ x4*0x10001 ^ x2*0x101 ^ x*0x1010100;
     tEnc = d[s]*0x101 ^ s*0x1010100;
     
     for (i = 0; i < 4; i++) {
       encTable[i][x] = tEnc = tEnc<<24 ^ tEnc>>>8;
       decTable[i][s] = tDec = tDec<<24 ^ tDec>>>8;
     }
   }
   
   // Compactify.  Considerable speedup on Firefox.
   for (i = 0; i < 5; i++) {
     encTable[i] = encTable[i].slice(0);
     decTable[i] = decTable[i].slice(0);
   }
  },
  
  /**
   * Encryption and decryption core.
   * @param {Array} input Four words to be encrypted or decrypted.
   * @param dir The direction, 0 for encrypt and 1 for decrypt.
   * @return {Array} The four encrypted or decrypted words.
   * @private
   */
  _crypt:function (input, dir) {
    if (input.length !== 4) {
      throw new sjcl.exception.invalid("invalid aes block size");
    }
    
    var key = this._key[dir],
        // state variables a,b,c,d are loaded with pre-whitened data
        a = input[0]           ^ key[0],
        b = input[dir ? 3 : 1] ^ key[1],
        c = input[2]           ^ key[2],
        d = input[dir ? 1 : 3] ^ key[3],
        a2, b2, c2,
        
        nInnerRounds = key.length/4 - 2,
        i,
        kIndex = 4,
        out = [0,0,0,0],
        table = this._tables[dir],
        
        // load up the tables
        t0    = table[0],
        t1    = table[1],
        t2    = table[2],
        t3    = table[3],
        sbox  = table[4];
 
    // Inner rounds.  Cribbed from OpenSSL.
    for (i = 0; i < nInnerRounds; i++) {
      a2 = t0[a>>>24] ^ t1[b>>16 & 255] ^ t2[c>>8 & 255] ^ t3[d & 255] ^ key[kIndex];
      b2 = t0[b>>>24] ^ t1[c>>16 & 255] ^ t2[d>>8 & 255] ^ t3[a & 255] ^ key[kIndex + 1];
      c2 = t0[c>>>24] ^ t1[d>>16 & 255] ^ t2[a>>8 & 255] ^ t3[b & 255] ^ key[kIndex + 2];
      d  = t0[d>>>24] ^ t1[a>>16 & 255] ^ t2[b>>8 & 255] ^ t3[c & 255] ^ key[kIndex + 3];
      kIndex += 4;
      a=a2; b=b2; c=c2;
    }
        
    // Last round.
    for (i = 0; i < 4; i++) {
      out[dir ? 3&-i : i] =
        sbox[a>>>24      ]<<24 ^ 
        sbox[b>>16  & 255]<<16 ^
        sbox[c>>8   & 255]<<8  ^
        sbox[d      & 255]     ^
        key[kIndex++];
      a2=a; a=b; b=c; c=d; d=a2;
    }
    
    return out;
  }
};

/** @fileOverview Arrays of bits, encoded as arrays of Numbers.
 *
 * @author Emily Stark
 * @author Mike Hamburg
 * @author Dan Boneh
 */

/** @namespace Arrays of bits, encoded as arrays of Numbers.
 *
 * @description
 * <p>
 * These objects are the currency accepted by SJCL's crypto functions.
 * </p>
 *
 * <p>
 * Most of our crypto primitives operate on arrays of 4-byte words internally,
 * but many of them can take arguments that are not a multiple of 4 bytes.
 * This library encodes arrays of bits (whose size need not be a multiple of 8
 * bits) as arrays of 32-bit words.  The bits are packed, big-endian, into an
 * array of words, 32 bits at a time.  Since the words are double-precision
 * floating point numbers, they fit some extra data.  We use this (in a private,
 * possibly-changing manner) to encode the number of bits actually  present
 * in the last word of the array.
 * </p>
 *
 * <p>
 * Because bitwise ops clear this out-of-band data, these arrays can be passed
 * to ciphers like AES which want arrays of words.
 * </p>
 */
sjcl.bitArray = {
  /**
   * Array slices in units of bits.
   * @param {bitArray a} The array to slice.
   * @param {Number} bstart The offset to the start of the slice, in bits.
   * @param {Number} bend The offset to the end of the slice, in bits.  If this is undefined,
   * slice until the end of the array.
   * @return {bitArray} The requested slice.
   */
  bitSlice: function (a, bstart, bend) {
    a = sjcl.bitArray._shiftRight(a.slice(bstart/32), 32 - (bstart & 31)).slice(1);
    return (bend === undefined) ? a : sjcl.bitArray.clamp(a, bend-bstart);
  },

  /**
   * Concatenate two bit arrays.
   * @param {bitArray} a1 The first array.
   * @param {bitArray} a2 The second array.
   * @return {bitArray} The concatenation of a1 and a2.
   */
  concat: function (a1, a2) {
    if (a1.length === 0 || a2.length === 0) {
      return a1.concat(a2);
    }
    
    var out, i, last = a1[a1.length-1], shift = sjcl.bitArray.getPartial(last);
    if (shift === 32) {
      return a1.concat(a2);
    } else {
      return sjcl.bitArray._shiftRight(a2, shift, last|0, a1.slice(0,a1.length-1));
    }
  },

  /**
   * Find the length of an array of bits.
   * @param {bitArray} a The array.
   * @return {Number} The length of a, in bits.
   */
  bitLength: function (a) {
    var l = a.length, x;
    if (l === 0) { return 0; }
    x = a[l - 1];
    return (l-1) * 32 + sjcl.bitArray.getPartial(x);
  },

  /**
   * Truncate an array.
   * @param {bitArray} a The array.
   * @param {Number} len The length to truncate to, in bits.
   * @return {bitArray} A new array, truncated to len bits.
   */
  clamp: function (a, len) {
    if (a.length * 32 < len) { return a; }
    a = a.slice(0, Math.ceil(len / 32));
    var l = a.length;
    len = len & 31;
    if (l > 0 && len) {
      a[l-1] = sjcl.bitArray.partial(len, a[l-1] & 0x80000000 >> (len-1), 1);
    }
    return a;
  },

  /**
   * Make a partial word for a bit array.
   * @param {Number} len The number of bits in the word.
   * @param {Number} x The bits.
   * @param {Number} [0] _end Pass 1 if x has already been shifted to the high side.
   * @return {Number} The partial word.
   */
  partial: function (len, x, _end) {
    if (len === 32) { return x; }
    return (_end ? x|0 : x << (32-len)) + len * 0x10000000000;
  },

  /**
   * Get the number of bits used by a partial word.
   * @param {Number} x The partial word.
   * @return {Number} The number of bits used by the partial word.
   */
  getPartial: function (x) {
    return Math.round(x/0x10000000000) || 32;
  },

  /**
   * Compare two arrays for equality in a predictable amount of time.
   * @param {bitArray} a The first array.
   * @param {bitArray} b The second array.
   * @return {boolean} true if a == b; false otherwise.
   */
  equal: function (a, b) {
    if (sjcl.bitArray.bitLength(a) !== sjcl.bitArray.bitLength(b)) {
      return false;
    }
    var x = 0, i;
    for (i=0; i<a.length; i++) {
      x |= a[i]^b[i];
    }
    return (x === 0);
  },

  /** Shift an array right.
   * @param {bitArray} a The array to shift.
   * @param {Number} shift The number of bits to shift.
   * @param {Number} [carry=0] A byte to carry in
   * @param {bitArray} [out=[]] An array to prepend to the output.
   * @private
   */
  _shiftRight: function (a, shift, carry, out) {
    var i, last2=0, shift2;
    if (out === undefined) { out = []; }
    
    for (; shift >= 32; shift -= 32) {
      out.push(carry);
      carry = 0;
    }
    if (shift === 0) {
      return out.concat(a);
    }
    
    for (i=0; i<a.length; i++) {
      out.push(carry | a[i]>>>shift);
      carry = a[i] << (32-shift);
    }
    last2 = a.length ? a[a.length-1] : 0;
    shift2 = sjcl.bitArray.getPartial(last2);
    out.push(sjcl.bitArray.partial(shift+shift2 & 31, (shift + shift2 > 32) ? carry : out.pop(),1));
    return out;
  },
  
  /** xor a block of 4 words together.
   * @private
   */
  _xor4: function(x,y) {
    return [x[0]^y[0],x[1]^y[1],x[2]^y[2],x[3]^y[3]];
  }
};
/** @fileOverview Bit array codec implementations.
 *
 * @author Emily Stark
 * @author Mike Hamburg
 * @author Dan Boneh
 */
 
/** @namespace UTF-8 strings */
sjcl.codec.utf8String = {
  /** Convert from a bitArray to a UTF-8 string. */
  fromBits: function (arr) {
    var out = "", bl = sjcl.bitArray.bitLength(arr), i, tmp;
    for (i=0; i<bl/8; i++) {
      if ((i&3) === 0) {
        tmp = arr[i/4];
      }
      out += String.fromCharCode(tmp >>> 24);
      tmp <<= 8;
    }
    return decodeURIComponent(escape(out));
  },
  
  /** Convert from a UTF-8 string to a bitArray. */
  toBits: function (str) {
    str = unescape(encodeURIComponent(str));
    var out = [], i, tmp=0;
    for (i=0; i<str.length; i++) {
      tmp = tmp << 8 | str.charCodeAt(i);
      if ((i&3) === 3) {
        out.push(tmp);
        tmp = 0;
      }
    }
    if (i&3) {
      out.push(sjcl.bitArray.partial(8*(i&3), tmp));
    }
    return out;
  }
};
/** @fileOverview Bit array codec implementations.
 *
 * @author Emily Stark
 * @author Mike Hamburg
 * @author Dan Boneh
 */

/** @namespace Base64 encoding/decoding */
sjcl.codec.base64 = {
  /** The base64 alphabet.
   * @private
   */
  _chars: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",
  
  /** Convert from a bitArray to a base64 string. */
  fromBits: function (arr, _noEquals) {
    var out = "", i, bits=0, c = sjcl.codec.base64._chars, ta=0, bl = sjcl.bitArray.bitLength(arr);
    for (i=0; out.length * 6 < bl; ) {
      out += c.charAt((ta ^ arr[i]>>>bits) >>> 26);
      if (bits < 6) {
        ta = arr[i] << (6-bits);
        bits += 26;
        i++;
      } else {
        ta <<= 6;
        bits -= 6;
      }
    }
    while ((out.length & 3) && !_noEquals) { out += "="; }
    return out;
  },
  
  /** Convert from a base64 string to a bitArray */
  toBits: function(str) {
    str = str.replace(/\s|=/g,'');
    var out = [], i, bits=0, c = sjcl.codec.base64._chars, ta=0, x;
    for (i=0; i<str.length; i++) {
      x = c.indexOf(str.charAt(i));
      if (x < 0) {
        throw new sjcl.exception.invalid("this isn't base64!");
      }
      if (bits > 26) {
        bits -= 26;
        out.push(ta ^ x>>>bits);
        ta  = x << (32-bits);
      } else {
        bits += 6;
        ta ^= x << (32-bits);
      }
    }
    if (bits&56) {
      out.push(sjcl.bitArray.partial(bits&56, ta, 1));
    }
    return out;
  }
};
/** @fileOverview Javascript SHA-256 implementation.
 *
 * An older version of this implementation is available in the public
 * domain, but this one is (c) Emily Stark, Mike Hamburg, Dan Boneh,
 * Stanford University 2008-2010 and BSD-licensed for liability
 * reasons.
 *
 * Special thanks to Aldo Cortesi for pointing out several bugs in
 * this code.
 *
 * @author Emily Stark
 * @author Mike Hamburg
 * @author Dan Boneh
 */

/**
 * Context for a SHA-256 operation in progress.
 * @constructor
 * @class Secure Hash Algorithm, 256 bits.
 */
sjcl.hash.sha256 = function (hash) {
  if (!this._key[0]) { this._precompute(); }
  if (hash) {
    this._h = hash._h.slice(0);
    this._buffer = hash._buffer.slice(0);
    this._length = hash._length;
  } else {
    this.reset();
  }
};

/**
 * Hash a string or an array of words.
 * @static
 * @param {bitArray|String} data the data to hash.
 * @return {bitArray} The hash value, an array of 16 big-endian words.
 */
sjcl.hash.sha256.hash = function (data) {
  return (new sjcl.hash.sha256()).update(data).finalize();
};

sjcl.hash.sha256.prototype = {
  /**
   * The hash's block size, in bits.
   * @constant
   */
  blockSize: 512,
   
  /**
   * Reset the hash state.
   * @return this
   */
  reset:function () {
    this._h = this._init.slice(0);
    this._buffer = [];
    this._length = 0;
    return this;
  },
  
  /**
   * Input several words to the hash.
   * @param {bitArray|String} data the data to hash.
   * @return this
   */
  update: function (data) {
    if (typeof data === "string") {
      data = sjcl.codec.utf8String.toBits(data);
    }
    var i, b = this._buffer = sjcl.bitArray.concat(this._buffer, data),
        ol = this._length,
        nl = this._length = ol + sjcl.bitArray.bitLength(data);
    for (i = 512+ol & -512; i <= nl; i+= 512) {
      this._block(b.splice(0,16));
    }
    return this;
  },
  
  /**
   * Complete hashing and output the hash value.
   * @return {bitArray} The hash value, an array of 16 big-endian words.
   */
  finalize:function () {
    var i, b = this._buffer, h = this._h;

    // Round out and push the buffer
    b = sjcl.bitArray.concat(b, [sjcl.bitArray.partial(1,1)]);
    
    // Round out the buffer to a multiple of 16 words, less the 2 length words.
    for (i = b.length + 2; i & 15; i++) {
      b.push(0);
    }
    
    // append the length
    b.push(Math.floor(this._length / 0x100000000));
    b.push(this._length | 0);

    while (b.length) {
      this._block(b.splice(0,16));
    }

    this.reset();
    return h;
  },

  /**
   * The SHA-256 initialization vector, to be precomputed.
   * @private
   */
  _init:[],
  /*
  _init:[0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19],
  */
  
  /**
   * The SHA-256 hash key, to be precomputed.
   * @private
   */
  _key:[],
  /*
  _key:
    [0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
     0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
     0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
     0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
     0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
     0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
     0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
     0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2],
  */


  /**
   * Function to precompute _init and _key.
   * @private
   */
  _precompute: function () {
    var i = 0, prime = 2, factor;

    function frac(x) { return (x-Math.floor(x)) * 0x100000000 | 0; }

    outer: for (; i<64; prime++) {
      for (factor=2; factor*factor <= prime; factor++) {
        if (prime % factor === 0) {
          // not a prime
          continue outer;
        }
      }
      
      if (i<8) {
        this._init[i] = frac(Math.pow(prime, 1/2));
      }
      this._key[i] = frac(Math.pow(prime, 1/3));
      i++;
    }
  },
  
  /**
   * Perform one cycle of SHA-256.
   * @param {bitArray} words one block of words.
   * @private
   */
  _block:function (words) {  
    var i, tmp, a, b,
      w = words.slice(0),
      h = this._h,
      k = this._key,
      h0 = h[0], h1 = h[1], h2 = h[2], h3 = h[3],
      h4 = h[4], h5 = h[5], h6 = h[6], h7 = h[7];

    /* Rationale for placement of |0 :
     * If a value can overflow is original 32 bits by a factor of more than a few
     * million (2^23 ish), there is a possibility that it might overflow the
     * 53-bit mantissa and lose precision.
     *
     * To avoid this, we clamp back to 32 bits by |'ing with 0 on any value that
     * propagates around the loop, and on the hash state h[].  I don't believe
     * that the clamps on h4 and on h0 are strictly necessary, but it's close
     * (for h4 anyway), and better safe than sorry.
     *
     * The clamps on h[] are necessary for the output to be correct even in the
     * common case and for short inputs.
     */
    for (i=0; i<64; i++) {
      // load up the input word for this round
      if (i<16) {
        tmp = w[i];
      } else {
        a   = w[(i+1 ) & 15];
        b   = w[(i+14) & 15];
        tmp = w[i&15] = ((a>>>7  ^ a>>>18 ^ a>>>3  ^ a<<25 ^ a<<14) + 
                         (b>>>17 ^ b>>>19 ^ b>>>10 ^ b<<15 ^ b<<13) +
                         w[i&15] + w[(i+9) & 15]) | 0;
      }
      
      tmp = (tmp + h7 + (h4>>>6 ^ h4>>>11 ^ h4>>>25 ^ h4<<26 ^ h4<<21 ^ h4<<7) +  (h6 ^ h4&(h5^h6)) + k[i]); // | 0;
      
      // shift register
      h7 = h6; h6 = h5; h5 = h4;
      h4 = h3 + tmp | 0;
      h3 = h2; h2 = h1; h1 = h0;

      h0 = (tmp +  ((h1&h2) ^ (h3&(h1^h2))) + (h1>>>2 ^ h1>>>13 ^ h1>>>22 ^ h1<<30 ^ h1<<19 ^ h1<<10)) | 0;
    }

    h[0] = h[0]+h0 | 0;
    h[1] = h[1]+h1 | 0;
    h[2] = h[2]+h2 | 0;
    h[3] = h[3]+h3 | 0;
    h[4] = h[4]+h4 | 0;
    h[5] = h[5]+h5 | 0;
    h[6] = h[6]+h6 | 0;
    h[7] = h[7]+h7 | 0;
  }
};


/** @fileOverview CCM mode implementation.
 *
 * Special thanks to Roy Nicholson for pointing out a bug in our
 * implementation.
 *
 * @author Emily Stark
 * @author Mike Hamburg
 * @author Dan Boneh
 */

/** @namespace CTR mode with CBC MAC. */
sjcl.mode.ccm = {
  /** The name of the mode.
   * @constant
   */
  name: "ccm",
  
  /** Encrypt in CCM mode.
   * @static
   * @param {Object} prf The pseudorandom function.  It must have a block size of 16 bytes.
   * @param {bitArray} plaintext The plaintext data.
   * @param {bitArray} iv The initialization value.
   * @param {bitArray} [adata=[]] The authenticated data.
   * @param {Number} [tlen=64] the desired tag length, in bits.
   * @return {bitArray} The encrypted data, an array of bytes.
   */
  encrypt: function(prf, plaintext, iv, adata, tlen) {
    var L, i, out = plaintext.slice(0), tag, w=sjcl.bitArray, ivl = w.bitLength(iv) / 8, ol = w.bitLength(out) / 8;
    tlen = tlen || 64;
    adata = adata || [];
    
    if (ivl < 7) {
      throw new sjcl.exception.invalid("ccm: iv must be at least 7 bytes");
    }
    
    // compute the length of the length
    for (L=2; L<4 && ol >>> 8*L; L++) {}
    if (L < 15 - ivl) { L = 15-ivl; }
    iv = w.clamp(iv,8*(15-L));
    
    // compute the tag
    tag = sjcl.mode.ccm._computeTag(prf, plaintext, iv, adata, tlen, L);
    
    // encrypt
    out = sjcl.mode.ccm._ctrMode(prf, out, iv, tag, tlen, L);
    
    return w.concat(out.data, out.tag);
  },
  
  /** Decrypt in CCM mode.
   * @static
   * @param {Object} prf The pseudorandom function.  It must have a block size of 16 bytes.
   * @param {bitArray} ciphertext The ciphertext data.
   * @param {bitArray} iv The initialization value.
   * @param {bitArray} [[]] adata The authenticated data.
   * @param {Number} [64] tlen the desired tag length, in bits.
   * @return {bitArray} The decrypted data.
   */
  decrypt: function(prf, ciphertext, iv, adata, tlen) {
    tlen = tlen || 64;
    adata = adata || [];
    var L, i, 
        w=sjcl.bitArray,
        ivl = w.bitLength(iv) / 8,
        ol = w.bitLength(ciphertext), 
        out = w.clamp(ciphertext, ol - tlen),
        tag = w.bitSlice(ciphertext, ol - tlen), tag2;
    

    ol = (ol - tlen) / 8;
        
    if (ivl < 7) {
      throw new sjcl.exception.invalid("ccm: iv must be at least 7 bytes");
    }
    
    // compute the length of the length
    for (L=2; L<4 && ol >>> 8*L; L++) {}
    if (L < 15 - ivl) { L = 15-ivl; }
    iv = w.clamp(iv,8*(15-L));
    
    // decrypt
    out = sjcl.mode.ccm._ctrMode(prf, out, iv, tag, tlen, L);
    
    // check the tag
    tag2 = sjcl.mode.ccm._computeTag(prf, out.data, iv, adata, tlen, L);
    if (!w.equal(out.tag, tag2)) {
      throw new sjcl.exception.corrupt("ccm: tag doesn't match");
    }
    
    return out.data;
  },

  /* Compute the (unencrypted) authentication tag, according to the CCM specification
   * @param {Object} prf The pseudorandom function.
   * @param {bitArray} plaintext The plaintext data.
   * @param {bitArray} iv The initialization value.
   * @param {bitArray} adata The authenticated data.
   * @param {Number} tlen the desired tag length, in bits.
   * @return {bitArray} The tag, but not yet encrypted.
   * @private
   */
  _computeTag: function(prf, plaintext, iv, adata, tlen, L) {
    // compute B[0]
    var q, mac, field = 0, offset = 24, tmp, i, macData = [], w=sjcl.bitArray, xor = w._xor4;

    tlen /= 8;
  
    // check tag length and message length
    if (tlen % 2 || tlen < 4 || tlen > 16) {
      throw new sjcl.exception.invalid("ccm: invalid tag length");
    }
  
    if (adata.length > 0xFFFFFFFF || plaintext.length > 0xFFFFFFFF) {
      // I don't want to deal with extracting high words from doubles.
      throw new sjcl.exception.bug("ccm: can't deal with 4GiB or more data");
    }

    // mac the flags
    mac = [w.partial(8, (adata.length ? 1<<6 : 0) | (tlen-2) << 2 | L-1)];

    // mac the iv and length
    mac = w.concat(mac, iv);
    mac[3] |= w.bitLength(plaintext)/8;
    mac = prf.encrypt(mac);
    
  
    if (adata.length) {
      // mac the associated data.  start with its length...
      tmp = w.bitLength(adata)/8;
      if (tmp <= 0xFEFF) {
        macData = [w.partial(16, tmp)];
      } else if (tmp <= 0xFFFFFFFF) {
        macData = w.concat([w.partial(16,0xFFFE)], [tmp]);
      } // else ...
    
      // mac the data itself
      macData = w.concat(macData, adata);
      for (i=0; i<macData.length; i += 4) {
        mac = prf.encrypt(xor(mac, macData.slice(i,i+4).concat([0,0,0])));
      }
    }
  
    // mac the plaintext
    for (i=0; i<plaintext.length; i+=4) {
      mac = prf.encrypt(xor(mac, plaintext.slice(i,i+4).concat([0,0,0])));
    }

    return w.clamp(mac, tlen * 8);
  },

  /** CCM CTR mode.
   * Encrypt or decrypt data and tag with the prf in CCM-style CTR mode.
   * May mutate its arguments.
   * @param {Object} prf The PRF.
   * @param {bitArray} data The data to be encrypted or decrypted.
   * @param {bitArray} iv The initialization vector.
   * @param {bitArray} tag The authentication tag.
   * @param {Number} tlen The length of th etag, in bits.
   * @param {Number} L The CCM L value.
   * @return {Object} An object with data and tag, the en/decryption of data and tag values.
   * @private
   */
  _ctrMode: function(prf, data, iv, tag, tlen, L) {
    var enc, i, w=sjcl.bitArray, xor = w._xor4, ctr, b, l = data.length, bl=w.bitLength(data);

    // start the ctr
    ctr = w.concat([w.partial(8,L-1)],iv).concat([0,0,0]).slice(0,4);
    
    // en/decrypt the tag
    tag = w.bitSlice(xor(tag,prf.encrypt(ctr)), 0, tlen);
  
    // en/decrypt the data
    if (!l) { return {tag:tag, data:[]}; }
    
    for (i=0; i<l; i+=4) {
      ctr[3]++;
      enc = prf.encrypt(ctr);
      data[i]   ^= enc[0];
      data[i+1] ^= enc[1];
      data[i+2] ^= enc[2];
      data[i+3] ^= enc[3];
    }
    return { tag:tag, data:w.clamp(data,bl) };
  }
};
/** @fileOverview HMAC implementation.
 *
 * @author Emily Stark
 * @author Mike Hamburg
 * @author Dan Boneh
 */

/** HMAC with the specified hash function.
 * @constructor
 * @param {bitArray} key the key for HMAC.
 * @param {Object} [hash=sjcl.hash.sha256] The hash function to use.
 */
sjcl.misc.hmac = function (key, Hash) {
  this._hash = Hash = Hash || sjcl.hash.sha256;
  var exKey = [[],[]], i,
      bs = Hash.prototype.blockSize / 32;
  this._baseHash = [new Hash(), new Hash()];

  if (key.length > bs) {
    key = Hash.hash(key);
  }
  
  for (i=0; i<bs; i++) {
    exKey[0][i] = key[i]^0x36363636;
    exKey[1][i] = key[i]^0x5C5C5C5C;
  }
  
  this._baseHash[0].update(exKey[0]);
  this._baseHash[1].update(exKey[1]);
};

/** HMAC with the specified hash function.  Also called encrypt since it's a prf.
 * @param {bitArray|String} data The data to mac.
 */
sjcl.misc.hmac.prototype.encrypt = sjcl.misc.hmac.prototype.mac = function (data) {
  var w = new (this._hash)(this._baseHash[0]).update(data).finalize();
  return new (this._hash)(this._baseHash[1]).update(w).finalize();
};

/** @fileOverview Password-based key-derivation function, version 2.0.
 *
 * @author Emily Stark
 * @author Mike Hamburg
 * @author Dan Boneh
 */

/** Password-Based Key-Derivation Function, version 2.0.
 *
 * Generate keys from passwords using PBKDF2-HMAC-SHA256.
 *
 * This is the method specified by RSA's PKCS #5 standard.
 *
 * @param {bitArray|String} password  The password.
 * @param {bitArray} salt The salt.  Should have lots of entropy.
 * @param {Number} [count=1000] The number of iterations.  Higher numbers make the function slower but more secure.
 * @param {Number} [length] The length of the derived key.  Defaults to the
                            output size of the hash function.
 * @param {Object} [Prff=sjcl.misc.hmac] The pseudorandom function family.
 * @return {bitArray} the derived key.
 */
sjcl.misc.pbkdf2 = function (password, salt, count, length, Prff) {
  count = count || 1000;
  
  if (length < 0 || count < 0) {
    throw sjcl.exception.invalid("invalid params to pbkdf2");
  }
  
  if (typeof password === "string") {
    password = sjcl.codec.utf8String.toBits(password);
  }
  
  Prff = Prff || sjcl.misc.hmac;
  
  var prf = new Prff(password),
      u, ui, i, j, k, out = [], b = sjcl.bitArray;

  for (k = 1; 32 * out.length < (length || 1); k++) {
    u = ui = prf.encrypt(b.concat(salt,[k]));
    
    for (i=1; i<count; i++) {
      ui = prf.encrypt(ui);
      for (j=0; j<ui.length; j++) {
        u[j] ^= ui[j];
      }
    }
    
    out = out.concat(u);
  }

  if (length) { out = b.clamp(out, length); }

  return out;
};
/** @fileOverview Random number generator.
 *
 * @author Emily Stark
 * @author Mike Hamburg
 * @author Dan Boneh
 */

/** @namespace Random number generator
 *
 * @description
 * <p>
 * This random number generator is a derivative of Ferguson and Schneier's
 * generator Fortuna.  It collects entropy from various events into several
 * pools, implemented by streaming SHA-256 instances.  It differs from
 * ordinary Fortuna in a few ways, though.
 * </p>
 *
 * <p>
 * Most importantly, it has an entropy estimator.  This is present because
 * there is a strong conflict here between making the generator available
 * as soon as possible, and making sure that it doesn't "run on empty".
 * In Fortuna, there is a saved state file, and the system is likely to have
 * time to warm up.
 * </p>
 *
 * <p>
 * Second, because users are unlikely to stay on the page for very long,
 * and to speed startup time, the number of pools increases logarithmically:
 * a new pool is created when the previous one is actually used for a reseed.
 * This gives the same asymptotic guarantees as Fortuna, but gives more
 * entropy to early reseeds.
 * </p>
 *
 * <p>
 * The entire mechanism here feels pretty klunky.  Furthermore, there are
 * several improvements that should be made, including support for
 * dedicated cryptographic functions that may be present in some browsers;
 * state files in local storage; cookies containing randomness; etc.  So
 * look for improvements in future versions.
 * </p>
 */
sjcl.random = {
  /** Generate several random words, and return them in an array
   * @param {Number} nwords The number of words to generate.
   */
  randomWords: function (nwords, paranoia) {
    var out = [], i, readiness = this.isReady(paranoia), g;
  
    if (readiness === this._NOT_READY) {
      throw new sjcl.exception.notReady("generator isn't seeded");
    } else if (readiness & this._REQUIRES_RESEED) {
      this._reseedFromPools(!(readiness & this._READY));
    }
  
    for (i=0; i<nwords; i+= 4) {
      if ((i+1) % this._MAX_WORDS_PER_BURST === 0) {
        this._gate();
      }
   
      g = this._gen4words();
      out.push(g[0],g[1],g[2],g[3]);
    }
    this._gate();
  
    return out.slice(0,nwords);
  },
  
  setDefaultParanoia: function (paranoia) {
    this._defaultParanoia = paranoia;
  },
  
  /**
   * Add entropy to the pools.
   * @param data The entropic value.  Should be a 32-bit integer, array of 32-bit integers, or string
   * @param {Number} estimatedEntropy The estimated entropy of data, in bits
   * @param {String} source The source of the entropy, eg "mouse"
   */
  addEntropy: function (data, estimatedEntropy, source) {
    source = source || "user";
  
    var id,
      i, tmp,
      t = (new Date()).valueOf(),
      robin = this._robins[source],
      oldReady = this.isReady(), err = 0;
      
    id = this._collectorIds[source];
    if (id === undefined) { id = this._collectorIds[source] = this._collectorIdNext ++; }
      
    if (robin === undefined) { robin = this._robins[source] = 0; }
    this._robins[source] = ( this._robins[source] + 1 ) % this._pools.length;
  
    switch(typeof(data)) {
      
    case "number":
      if (estimatedEntropy === undefined) {
        estimatedEntropy = 1;
      }
      this._pools[robin].update([id,this._eventId++,1,estimatedEntropy,t,1,data|0]);
      break;
      
    case "object":
      var objName = Object.prototype.toString.call(data);
      if (objName === "[object Uint32Array]") {
        tmp = [];
        for (i = 0; i < data.length; i++) {
          tmp.push(data[i]);
        }
        data = tmp;
      } else {
        if (objName !== "[object Array]") {
          err = 1;
        }
        for (i=0; i<data.length && !err; i++) {
          if (typeof(data[i]) != "number") {
            err = 1;
          }
        }
      }
      if (!err) {
        if (estimatedEntropy === undefined) {
          /* horrible entropy estimator */
          estimatedEntropy = 0;
          for (i=0; i<data.length; i++) {
            tmp= data[i];
            while (tmp>0) {
              estimatedEntropy++;
              tmp = tmp >>> 1;
            }
          }
        }
        this._pools[robin].update([id,this._eventId++,2,estimatedEntropy,t,data.length].concat(data));
      }
      break;
      
    case "string":
      if (estimatedEntropy === undefined) {
       /* English text has just over 1 bit per character of entropy.
        * But this might be HTML or something, and have far less
        * entropy than English...  Oh well, let's just say one bit.
        */
       estimatedEntropy = data.length;
      }
      this._pools[robin].update([id,this._eventId++,3,estimatedEntropy,t,data.length]);
      this._pools[robin].update(data);
      break;
      
    default:
      err=1;
    }
    if (err) {
      throw new sjcl.exception.bug("random: addEntropy only supports number, array of numbers or string");
    }
  
    /* record the new strength */
    this._poolEntropy[robin] += estimatedEntropy;
    this._poolStrength += estimatedEntropy;
  
    /* fire off events */
    if (oldReady === this._NOT_READY) {
      if (this.isReady() !== this._NOT_READY) {
        this._fireEvent("seeded", Math.max(this._strength, this._poolStrength));
      }
      this._fireEvent("progress", this.getProgress());
    }
  },
  
  /** Is the generator ready? */
  isReady: function (paranoia) {
    var entropyRequired = this._PARANOIA_LEVELS[ (paranoia !== undefined) ? paranoia : this._defaultParanoia ];
  
    if (this._strength && this._strength >= entropyRequired) {
      return (this._poolEntropy[0] > this._BITS_PER_RESEED && (new Date()).valueOf() > this._nextReseed) ?
        this._REQUIRES_RESEED | this._READY :
        this._READY;
    } else {
      return (this._poolStrength >= entropyRequired) ?
        this._REQUIRES_RESEED | this._NOT_READY :
        this._NOT_READY;
    }
  },
  
  /** Get the generator's progress toward readiness, as a fraction */
  getProgress: function (paranoia) {
    var entropyRequired = this._PARANOIA_LEVELS[ paranoia ? paranoia : this._defaultParanoia ];
  
    if (this._strength >= entropyRequired) {
      return 1.0;
    } else {
      return (this._poolStrength > entropyRequired) ?
        1.0 :
        this._poolStrength / entropyRequired;
    }
  },
  
  /** start the built-in entropy collectors */
  startCollectors: function () {
    if (this._collectorsStarted) { return; }
  
    if (window.addEventListener) {
      window.addEventListener("load", this._loadTimeCollector, false);
      window.addEventListener("mousemove", this._mouseCollector, false);
    } else if (document.attachEvent) {
      document.attachEvent("onload", this._loadTimeCollector);
      document.attachEvent("onmousemove", this._mouseCollector);
    }
    else {
      throw new sjcl.exception.bug("can't attach event");
    }
  
    this._collectorsStarted = true;
  },
  
  /** stop the built-in entropy collectors */
  stopCollectors: function () {
    if (!this._collectorsStarted) { return; }
  
    if (window.removeEventListener) {
      window.removeEventListener("load", this._loadTimeCollector, false);
      window.removeEventListener("mousemove", this._mouseCollector, false);
    } else if (window.detachEvent) {
      window.detachEvent("onload", this._loadTimeCollector);
      window.detachEvent("onmousemove", this._mouseCollector);
    }
    this._collectorsStarted = false;
  },
  
  /* use a cookie to store entropy.
  useCookie: function (all_cookies) {
      throw new sjcl.exception.bug("random: useCookie is unimplemented");
  },*/
  
  /** add an event listener for progress or seeded-ness. */
  addEventListener: function (name, callback) {
    this._callbacks[name][this._callbackI++] = callback;
  },
  
  /** remove an event listener for progress or seeded-ness */
  removeEventListener: function (name, cb) {
    var i, j, cbs=this._callbacks[name], jsTemp=[];
  
    /* I'm not sure if this is necessary; in C++, iterating over a
     * collection and modifying it at the same time is a no-no.
     */
  
    for (j in cbs) {
	if (cbs.hasOwnProperty(j) && cbs[j] === cb) {
        jsTemp.push(j);
      }
    }
  
    for (i=0; i<jsTemp.length; i++) {
      j = jsTemp[i];
      delete cbs[j];
    }
  },
  
  /* private */
  _pools                   : [new sjcl.hash.sha256()],
  _poolEntropy             : [0],
  _reseedCount             : 0,
  _robins                  : {},
  _eventId                 : 0,
  
  _collectorIds            : {},
  _collectorIdNext         : 0,
  
  _strength                : 0,
  _poolStrength            : 0,
  _nextReseed              : 0,
  _key                     : [0,0,0,0,0,0,0,0],
  _counter                 : [0,0,0,0],
  _cipher                  : undefined,
  _defaultParanoia         : 6,
  
  /* event listener stuff */
  _collectorsStarted       : false,
  _callbacks               : {progress: {}, seeded: {}},
  _callbackI               : 0,
  
  /* constants */
  _NOT_READY               : 0,
  _READY                   : 1,
  _REQUIRES_RESEED         : 2,

  _MAX_WORDS_PER_BURST     : 65536,
  _PARANOIA_LEVELS         : [0,48,64,96,128,192,256,384,512,768,1024],
  _MILLISECONDS_PER_RESEED : 30000,
  _BITS_PER_RESEED         : 80,
  
  /** Generate 4 random words, no reseed, no gate.
   * @private
   */
  _gen4words: function () {
    for (var i=0; i<4; i++) {
      this._counter[i] = this._counter[i]+1 | 0;
      if (this._counter[i]) { break; }
    }
    return this._cipher.encrypt(this._counter);
  },
  
  /* Rekey the AES instance with itself after a request, or every _MAX_WORDS_PER_BURST words.
   * @private
   */
  _gate: function () {
    this._key = this._gen4words().concat(this._gen4words());
    this._cipher = new sjcl.cipher.aes(this._key);
  },
  
  /** Reseed the generator with the given words
   * @private
   */
  _reseed: function (seedWords) {
    this._key = sjcl.hash.sha256.hash(this._key.concat(seedWords));
    this._cipher = new sjcl.cipher.aes(this._key);
    for (var i=0; i<4; i++) {
      this._counter[i] = this._counter[i]+1 | 0;
      if (this._counter[i]) { break; }
    }
  },
  
  /** reseed the data from the entropy pools
   * @param full If set, use all the entropy pools in the reseed.
   */
  _reseedFromPools: function (full) {
    var reseedData = [], strength = 0, i;
  
    this._nextReseed = reseedData[0] =
      (new Date()).valueOf() + this._MILLISECONDS_PER_RESEED;
    
    for (i=0; i<16; i++) {
      /* On some browsers, this is cryptographically random.  So we might
       * as well toss it in the pot and stir...
       */
      reseedData.push(Math.random()*0x100000000|0);
    }
    
    for (i=0; i<this._pools.length; i++) {
     reseedData = reseedData.concat(this._pools[i].finalize());
     strength += this._poolEntropy[i];
     this._poolEntropy[i] = 0;
   
     if (!full && (this._reseedCount & (1<<i))) { break; }
    }
  
    /* if we used the last pool, push a new one onto the stack */
    if (this._reseedCount >= 1 << this._pools.length) {
     this._pools.push(new sjcl.hash.sha256());
     this._poolEntropy.push(0);
    }
  
    /* how strong was this reseed? */
    this._poolStrength -= strength;
    if (strength > this._strength) {
      this._strength = strength;
    }
  
    this._reseedCount ++;
    this._reseed(reseedData);
  },
  
  _mouseCollector: function (ev) {
    var x = ev.x || ev.clientX || ev.offsetX || 0, y = ev.y || ev.clientY || ev.offsetY || 0;
    sjcl.random.addEntropy([x,y], 2, "mouse");
  },
  
  _loadTimeCollector: function (ev) {
    sjcl.random.addEntropy((new Date()).valueOf(), 2, "loadtime");
  },
  
  _fireEvent: function (name, arg) {
    var j, cbs=sjcl.random._callbacks[name], cbsTemp=[];
    /* TODO: there is a race condition between removing collectors and firing them */ 

    /* I'm not sure if this is necessary; in C++, iterating over a
     * collection and modifying it at the same time is a no-no.
     */
  
    for (j in cbs) {
     if (cbs.hasOwnProperty(j)) {
        cbsTemp.push(cbs[j]);
     }
    }
  
    for (j=0; j<cbsTemp.length; j++) {
     cbsTemp[j](arg);
    }
  }
};

(function(){
  try {
    // get cryptographically strong entropy in Webkit
    var ab = new Uint32Array(32);
    crypto.getRandomValues(ab);
    sjcl.random.addEntropy(ab, 1024, "crypto.getRandomValues");
  } catch (e) {
    // no getRandomValues :-(
  }
})();
/** @fileOverview Convenince functions centered around JSON encapsulation.
 *
 * @author Emily Stark
 * @author Mike Hamburg
 * @author Dan Boneh
 */
 
 /** @namespace JSON encapsulation */
 sjcl.json = {
  /** Default values for encryption */
  defaults: { v:1, iter:1000, ks:128, ts:64, mode:"ccm", adata:"", cipher:"aes" },

  /** Simple encryption function.
   * @param {String|bitArray} password The password or key.
   * @param {String} plaintext The data to encrypt.
   * @param {Object} [params] The parameters including tag, iv and salt.
   * @param {Object} [rp] A returned version with filled-in parameters.
   * @return {String} The ciphertext.
   * @throws {sjcl.exception.invalid} if a parameter is invalid.
   */
  encrypt: function (password, plaintext, params, rp) {
    params = params || {};
    rp = rp || {};
    
    var j = sjcl.json, p = j._add({ iv: sjcl.random.randomWords(4,0) },
                                  j.defaults), tmp, prp, adata;
    j._add(p, params);
    adata = p.adata;
    if (typeof p.salt === "string") {
      p.salt = sjcl.codec.base64.toBits(p.salt);
    }
    if (typeof p.iv === "string") {
      p.iv = sjcl.codec.base64.toBits(p.iv);
    }
    
    if (!sjcl.mode[p.mode] ||
        !sjcl.cipher[p.cipher] ||
        (typeof password === "string" && p.iter <= 100) ||
        (p.ts !== 64 && p.ts !== 96 && p.ts !== 128) ||
        (p.ks !== 128 && p.ks !== 192 && p.ks !== 256) ||
        (p.iv.length < 2 || p.iv.length > 4)) {
      throw new sjcl.exception.invalid("json encrypt: invalid parameters");
    }
    
    if (typeof password === "string") {
      tmp = sjcl.misc.cachedPbkdf2(password, p);
      password = tmp.key.slice(0,p.ks/32);
      p.salt = tmp.salt;
    }
    if (typeof plaintext === "string") {
      plaintext = sjcl.codec.utf8String.toBits(plaintext);
    }
    if (typeof adata === "string") {
      adata = sjcl.codec.utf8String.toBits(adata);
    }
    prp = new sjcl.cipher[p.cipher](password);
    
    /* return the json data */
    j._add(rp, p);
    rp.key = password;
    
    /* do the encryption */
    p.ct = sjcl.mode[p.mode].encrypt(prp, plaintext, p.iv, adata, p.ts);
    
    //return j.encode(j._subtract(p, j.defaults));
    return j.encode(p);
  },
  
  /** Simple decryption function.
   * @param {String|bitArray} password The password or key.
   * @param {String} ciphertext The ciphertext to decrypt.
   * @param {Object} [params] Additional non-default parameters.
   * @param {Object} [rp] A returned object with filled parameters.
   * @return {String} The plaintext.
   * @throws {sjcl.exception.invalid} if a parameter is invalid.
   * @throws {sjcl.exception.corrupt} if the ciphertext is corrupt.
   */
  decrypt: function (password, ciphertext, params, rp) {
    params = params || {};
    rp = rp || {};
    
    var j = sjcl.json, p = j._add(j._add(j._add({},j.defaults),j.decode(ciphertext)), params, true), ct, tmp, prp, adata=p.adata;
    if (typeof p.salt === "string") {
      p.salt = sjcl.codec.base64.toBits(p.salt);
    }
    if (typeof p.iv === "string") {
      p.iv = sjcl.codec.base64.toBits(p.iv);
    }
    
    if (!sjcl.mode[p.mode] ||
        !sjcl.cipher[p.cipher] ||
        (typeof password === "string" && p.iter <= 100) ||
        (p.ts !== 64 && p.ts !== 96 && p.ts !== 128) ||
        (p.ks !== 128 && p.ks !== 192 && p.ks !== 256) ||
        (!p.iv) ||
        (p.iv.length < 2 || p.iv.length > 4)) {
      throw new sjcl.exception.invalid("json decrypt: invalid parameters");
    }
    
    if (typeof password === "string") {
      tmp = sjcl.misc.cachedPbkdf2(password, p);
      password = tmp.key.slice(0,p.ks/32);
      p.salt  = tmp.salt;
    }
    if (typeof adata === "string") {
      adata = sjcl.codec.utf8String.toBits(adata);
    }
    prp = new sjcl.cipher[p.cipher](password);
    
    /* do the decryption */
    ct = sjcl.mode[p.mode].decrypt(prp, p.ct, p.iv, adata, p.ts);
    
    /* return the json data */
    j._add(rp, p);
    rp.key = password;
    
    return sjcl.codec.utf8String.fromBits(ct);
  },
  
  /** Encode a flat structure into a JSON string.
   * @param {Object} obj The structure to encode.
   * @return {String} A JSON string.
   * @throws {sjcl.exception.invalid} if obj has a non-alphanumeric property.
   * @throws {sjcl.exception.bug} if a parameter has an unsupported type.
   */
  encode: function (obj) {
    var i, out='{', comma='';
    for (i in obj) {
      if (obj.hasOwnProperty(i)) {
        if (!i.match(/^[a-z0-9]+$/i)) {
          throw new sjcl.exception.invalid("json encode: invalid property name");
        }
        out += comma + '"' + i + '":';
        comma = ',';
        
        switch (typeof obj[i]) {
        case 'number':
        case 'boolean':
          out += obj[i];
          break;
          
        case 'string':
          out += '"' + escape(obj[i]) + '"';
          break;
        
        case 'object':
          out += '"' + sjcl.codec.base64.fromBits(obj[i],1) + '"';
          break;
        
        default:
          throw new sjcl.exception.bug("json encode: unsupported type");
        }
      }
    }
    return out+'}';
  },
  
  /** Decode a simple (flat) JSON string into a structure.  The ciphertext,
   * adata, salt and iv will be base64-decoded.
   * @param {String} str The string.
   * @return {Object} The decoded structure.
   * @throws {sjcl.exception.invalid} if str isn't (simple) JSON.
   */
  decode: function (str) {
    str = str.replace(/\s/g,'');
    if (!str.match(/^\{.*\}$/)) { 
      throw new sjcl.exception.invalid("json decode: this isn't json!");
    }
    var a = str.replace(/^\{|\}$/g, '').split(/,/), out={}, i, m;
    for (i=0; i<a.length; i++) {
      if (!(m=a[i].match(/^(?:(["']?)([a-z][a-z0-9]*)\1):(?:(\d+)|"([a-z0-9+\/%*_.@=\-]*)")$/i))) {
        throw new sjcl.exception.invalid("json decode: this isn't json!");
      }
      if (m[3]) {
        out[m[2]] = parseInt(m[3],10);
      } else {
        out[m[2]] = m[2].match(/^(ct|salt|iv)$/) ? sjcl.codec.base64.toBits(m[4]) : unescape(m[4]);
      }
    }
    return out;
  },
  
  /** Insert all elements of src into target, modifying and returning target.
   * @param {Object} target The object to be modified.
   * @param {Object} src The object to pull data from.
   * @param {boolean} [requireSame=false] If true, throw an exception if any field of target differs from corresponding field of src.
   * @return {Object} target.
   * @private
   */
  _add: function (target, src, requireSame) {
    if (target === undefined) { target = {}; }
    if (src === undefined) { return target; }
    var i;
    for (i in src) {
      if (src.hasOwnProperty(i)) {
        if (requireSame && target[i] !== undefined && target[i] !== src[i]) {
          throw new sjcl.exception.invalid("required parameter overridden");
        }
        target[i] = src[i];
      }
    }
    return target;
  },
  
  /** Remove all elements of minus from plus.  Does not modify plus.
   * @private
  _subtract: function (plus, minus) {
    var out = {}, i;
    
    for (i in plus) {
      if (plus.hasOwnProperty(i) && plus[i] !== minus[i]) {
        out[i] = plus[i];
      }
    }
    
    return out;
  },
  */
  
  /** Return only the specified elements of src.
   * @private
   */
  _filter: function (src, filter) {
    var out = {}, i;
    for (i=0; i<filter.length; i++) {
      if (src[filter[i]] !== undefined) {
        out[filter[i]] = src[filter[i]];
      }
    }
    return out;
  }
};

/** Simple encryption function; convenient shorthand for sjcl.json.encrypt.
 * @param {String|bitArray} password The password or key.
 * @param {String} plaintext The data to encrypt.
 * @param {Object} [params] The parameters including tag, iv and salt.
 * @param {Object} [rp] A returned version with filled-in parameters.
 * @return {String} The ciphertext.
 */
sjcl.encrypt = sjcl.json.encrypt;

/** Simple decryption function; convenient shorthand for sjcl.json.decrypt.
 * @param {String|bitArray} password The password or key.
 * @param {String} ciphertext The ciphertext to decrypt.
 * @param {Object} [params] Additional non-default parameters.
 * @param {Object} [rp] A returned object with filled parameters.
 * @return {String} The plaintext.
 */
sjcl.decrypt = sjcl.json.decrypt;

/** The cache for cachedPbkdf2.
 * @private
 */
sjcl.misc._pbkdf2Cache = {};

/** Cached PBKDF2 key derivation.
 * @param {String} The password.  
 * @param {Object} The derivation params (iteration count and optional salt).
 * @return {Object} The derived data in key, the salt in salt.
 */
sjcl.misc.cachedPbkdf2 = function (password, obj) {
  var cache = sjcl.misc._pbkdf2Cache, c, cp, str, salt, iter;
  
  obj = obj || {};
  iter = obj.iter || 1000;
  
  /* open the cache for this password and iteration count */
  cp = cache[password] = cache[password] || {};
  c = cp[iter] = cp[iter] || { firstSalt: (obj.salt && obj.salt.length) ?
                     obj.salt.slice(0) : sjcl.random.randomWords(2,0) };
          
  salt = (obj.salt === undefined) ? c.firstSalt : obj.salt;
  
  c[salt] = c[salt] || sjcl.misc.pbkdf2(password, salt, obj.iter);
  return { key: c[salt].slice(0), salt:salt.slice(0) };
};




var localStorage = window.localStorage;

function cookieName(name) {
    if (! window.location) {
        return name;
    }

    var port = window.location.port ||
        (window.location.protocol === 'https:' ? 443 : 80);

    return name + '_' + port;
}

function fetchCookieValues(name) {
    var cookie = Cookie.fetch(cookieName(name));

    if (! cookie) {
        return {};
    }

    try {
        return JSON.parse(cookie.value);
    }
    catch (e) {
        return {
            encryptKey: cookie.value
        };
    }
}

function fillinDefaultCookieValues(values, o) {
    function generateKey() {
        return sjcl.codec.base64.fromBits(sjcl.random.randomWords(8, 0));
    }

    var path = values.path,
        currentPath = extractPath(documentUrl());
    if (! path || path.length > currentPath.length) {
        path = currentPath;
    }

    return {
        encryptKey: values.encryptKey || generateKey(),
        storageKey: values.storageKey || generateKey(),
        domain: o.sessionDomain || values.domain || undefined,
        path: o.sessionPath || path
    };
}

function documentUrl() {
    if (! window.location) {
        return '';
    }

    var loc;

    // IE may throw an exception when accessing
    // a field from window.location if document.domain has been set
    try {
        loc = window.location.href;
    } catch( e ) {
        // Use the href attribute of an A element
        // since IE will modify it given document.location
        loc = window.document.createElement( "a" );
        loc.href = "";
        loc = loc.href;
    }

    return loc;
}

function extractPath(url) {
    var urlRegexp = /^[\w.+-]+:(?:\/\/[^\/?#:]*(?::\d+|)|)(.*)\/[^\/]*$/,
        match     = urlRegexp.exec(url.toLowerCase());

    return match ? match[1] : null;
}

// DEPRECATED
// This method will be removed in future version.
function buildLocalStorageNames(name, path) {
    function buildName(path) {
        return name + ':' + path;
    }

    var names = [];

    if (! path) {
        return [name];
    }

    while (true) {
        names.push(buildName(path));
        if (path === '/') {
            break;
        }
        path = path.replace(/[^\/]+\/$/, '');
    }
    return names;
}

// DEPRECATED
// This method will be removed in future version.
function localStorageNames(name, o) {
    return buildLocalStorageNames(name, o.sessionPath || extractPath(documentUrl())+"/");
}

if (! localStorage) {
    DataAPI.sessionStores['cookie-encrypted'] = {
        save:   function(){},
        fetch:  function(){},
        remove: function(){}
    };
}
else {
    DataAPI.sessionStores['cookie-encrypted'] = {
        save: function(name, data, remember) {
            var expires = remember ? new Date(new Date().getTime() + 315360000000) : undefined, // after 10 years
                values  = fillinDefaultCookieValues(fetchCookieValues(name), this.o);

            Cookie.bake(cookieName(name), JSON.stringify(values), values.domain, values.path, expires);
            localStorage.setItem(values.storageKey, sjcl.encrypt(values.encryptKey, data));
        },
        fetch: function(name) {
            var values = fetchCookieValues(name),
                i, names, data;

            // Backward compatibility 
            if (! values.storageKey) {
                names = localStorageNames(name, this.o);
                for (i = 0; i < names.length; i++) {
                    if (localStorage.getItem(names[i])) {
                        values.storageKey = names[i];
                        break;
                    }
                }
            }

            data = localStorage.getItem(values.storageKey);

            try {
                return sjcl.decrypt(values.encryptKey, data);
            }
            catch (e) {
            }

            return null;
        },
        remove: function(name) {
            var values = fillinDefaultCookieValues(fetchCookieValues(name), this.o);

            Cookie.bake(cookieName(name), '', values.domain, values.path, new Date(0));

            if (values.storageKey) {
                localStorage.removeItem(values.storageKey);
            }
        }
    };
}

})();


/**
 * Register callback to class.
 * @method on
 * @static
 * @param {String} key Event name
 * @param {Function} callback Callback function
 * @category core
 * @example
 *     var callback = function() {
 *       // Do stuff
 *     };
 *     DataAPI.on(eventName, callback);
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
 * @example
 *     DataAPI.off(eventName, callback);
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
 * @param {Object} spec
 *   @param {String} spec.fileExtension Extension
 *   @param {String} spec.mimeType MIME type
 *   @param {String} spec.serialize Serializing method
 *   @param {String} spec.unserialize Unserializing method
 * @category core
 */
DataAPI.registerFormat = function(key, spec) {
    this.formats[key] = spec;
};

/**
 * Register session store.
 * @method registerSessionStore
 * @static
 * @param {String} key Session store name
 * @param {Object} spec
 *   @param {String} spec.save Saving method
 *   @param {String} spec.fetch Fetching method
 *   @param {String} spec.remove Removing method
 * @category core
 */
DataAPI.registerSessionStore = function(key, spec) {
    this.sessionStores[key] = spec;
};

/**
 * Get default format of this class.
 * @method getDefaultFormat
 * @static
 * @return {Object} Format
 * @category core
 */
DataAPI.getDefaultFormat = function() {
    return this.formats[this.defaultFormat];
};

/**
 * Get default session store of this class.
 * @method getDefaultSessionStore
 * @static
 * @return {Object} Format
 * @category core
 */
DataAPI.getDefaultSessionStore = function() {
    return this.sessionStores[this.defaultSessionStore];
};

DataAPI.prototype = {
    constructor: DataAPI.prototype.constructor,

    _initOptions: function() {
        this._initCrossDomainOption();
    },

    _initCrossDomainOption: function() {
        var loc, locParts, baseUrl, baseParts,
            urlRegexp = /^([\w.+-]+:)(?:\/\/([^\/?#:]*)(?::(\d+)|)|)/;

        if ( window.document && typeof this.o.crossOrigin === 'undefined') {
            // IE may throw an exception when accessing
            // a field from window.location if document.domain has been set
            try {
                loc = window.location.href;
            } catch( e ) {
                // Use the href attribute of an A element
                // since IE will modify it given document.location
                loc = window.document.createElement( "a" );
                loc.href = "";
                loc = loc.href;
            }
            locParts  = urlRegexp.exec( loc.toLowerCase() ) || [];

            baseUrl   = this.o.baseUrl.replace(/^\/\//, locParts[1]).toLowerCase();
            baseParts = urlRegexp.exec( baseUrl );

            this.o.crossOrigin = !!( baseParts &&
                ( baseParts[ 1 ] !== locParts[ 1 ] || baseParts[ 2 ] !== locParts[ 2 ] ||
                    ( baseParts[ 3 ] || ( baseParts[ 1 ] === "http:" ? "80" : "443" ) ) !==
                        ( locParts[ 3 ] || ( locParts[ 1 ] === "http:" ? "80" : "443" ) ) )
            );
        }
    },

    /**
     * Get authorization URL.
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
        return this.constructor.iframePrefix + (++this.iframeId);
    },

    /**
     * Get API version.
     * @method getVersion
     * @return {String} API version
     * @category core
     */
    getVersion: function() {
        return this.constructor.version;
    },

    /**
     * Get application key of this object.
     * @method getAppKey
     * @return {String} Application key
     *   This value is used for the session store.
     * @category core
     */
    getAppKey: function() {
        return this.constructor.accessTokenKey + '_' + this.o.clientId;
    },

    _findFormatInternal: function(mimeType) {
        if (! mimeType) {
            return null;
        }

        for (var k in this.constructor.formats) {
            if (this.constructor.formats[k].mimeType === mimeType) {
                return this.constructor.formats[k];
            }
        }

        return null;
    },

    /**
     * Get format by MIME Type.
     * @method findFormat
     * @param {String} mimeType MIME Type
     * @return {Object|null} Format. Return null if any format is not found.
     * @category core
     */
    findFormat: function(mimeType) {
        var format = this._findFormatInternal(mimeType);
        if (! format && mimeType.indexOf(';')) {
            format = this._findFormatInternal(mimeType.replace(/\s*;.*/, ''));
        }

        return format;
    },

    /**
     * Get current format of this object.
     * @method getCurrentFormat
     * @return {Object} Format
     * @category core
     */
    getCurrentFormat: function() {
        return this.constructor.formats[this.o.format] ||
            this.constructor.getDefaultFormat();
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
     * Get current session store of this object.
     * @method getCurrentSessionStore
     * @return {Object} Session store
     * @category core
     */
    getCurrentSessionStore: function() {
        return this.constructor.sessionStores[this.o.sessionStore] ||
            this.constructor.getDefaultSessionStore();
    },

    /**
     * Save session data.
     * @method saveSessionData
     * @param {String} name The name of session
     * @param {Object} data The data to save
     * @category core
     */
    saveSessionData: function() {
        return this.getCurrentSessionStore().save.apply(this, arguments);
    },

    /**
     * Fetch session data.
     * @method fetchSessionData
     * @param {String} name The name of session
     * @return {String} The data fetched
     * @category core
     */
    fetchSessionData: function() {
        return this.getCurrentSessionStore().fetch.apply(this, arguments);
    },

    /**
     * Remove session data.
     * @method removeSessionData
     * @param {String} name The name of session
     * @category core
     */
    removeSessionData: function() {
        return this.getCurrentSessionStore().remove.apply(this, arguments);
    },

    /**
     * Store token data via current session store.
     * @method storeTokenData
     * @param {Object} tokenData The token data
     *   @param {String} tokenData.accessToken access token
     *   @param {String} tokenData.expiresIn The number of seconds
     *     until access token becomes invalid
     *   @param {String} [tokenData.sessionId] session ID
     * @category core
     */
    storeTokenData: function(tokenData) {
        var oldData = this.getTokenData();
        if (! tokenData.sessionId && oldData && oldData.sessionId) {
            tokenData.sessionId = oldData.sessionId;
        }

        tokenData.startTime = this._getCurrentEpoch();
        this.saveSessionData(
            this.getAppKey(),
            this.serializeData(tokenData),
            tokenData.sessionId && tokenData.remember
        );
        this.tokenData = tokenData;
    },

    /**
     * Clear token data from object and session store.
     * @method clearTokenData
     * @category core
     */
    clearTokenData: function() {
        this.removeSessionData(this.getAppKey());
        this.tokenData = null;
    },

    _updateTokenFromDefaultCookie: function() {
        var defaultKey    = this.constructor.accessTokenKey,
            defaultCookie = Cookie.fetch(defaultKey),
            defaultToken;

        if (! defaultCookie) {
            return null;
        }

        Cookie.bake(defaultKey, '', undefined, '/', new Date(0));

        try {
            defaultToken = this.unserializeData(defaultCookie.value);
        }
        catch (e) {
            return null;
        }

        this.storeTokenData(defaultToken);
        return defaultToken;
    },

    _hasOneTimeToken: function() {
        return window.location && window.location.hash.indexOf('#_ott_') === 0;
    },

    _storeOneTimeToken: function() {
        var token, m;

        if (! window.location) {
            return undefined;
        }

        m = window.location.hash.match(/^#_ott_(.*)/);
        if (! m) {
            return undefined;
        }

        token = {
            oneTimeToken: m[1]
        };
        window.location.hash = '#_login';

        this.storeTokenData(token);
        return token;
    },

    /**
     * Get token data via current session store.
     * @method getTokenData
     * @return {Object} Token data
     * @category core
     */
    getTokenData: function() {
        var token = this.tokenData;

        if (! token) {
            if (window.location) {
                if (window.location.hash === '#_login') {
                    try {
                        token = this._updateTokenFromDefaultCookie();
                    }
                    catch (e) {
                    }
                }
                else if (this._hasOneTimeToken()) {
                    token = this._storeOneTimeToken();
                }
            }

            if (! token) {
                try {
                    token = this.unserializeData(this.fetchSessionData(this.getAppKey()));
                }
                catch (e) {
                }
            }
        }

        if (token &&
            'startTime' in token &&
            'expiresIn' in token &&
            (token.startTime + token.expiresIn < this._getCurrentEpoch())) {
            delete token.accessToken;
            delete token.startTime;
            delete token.expiresIn;
        }

        return this.tokenData = token || null;
    },

    /**
     * Get authorization request header.
     * @method getAuthorizationHeader
     * @return {String|null} Header string. Return null if api object has no token.
     * @category core
     */
    getAuthorizationHeader: function(key) {
        var tokenData = this.getTokenData();
        if (tokenData) {
            return 'MTAuth ' + key + '=' + (tokenData[key] || '');
        }

        return '';
    },

    /**
     * Bind parameters to route spec.
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
                if (typeof v.id === 'function') {
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
        else if (type === 'boolean') {
            return v ? '1' : '';
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
     * Create XMLHttpRequest by higher browser compatibility way.
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
     * Send request to specified URL with params via XMLHttpRequest.
     * @method sendXMLHttpRequest
     * @param {XMLHttpRequest} xhr XMLHttpRequest object to send request
     * @param {String} method Request method
     * @param {String} url Request URL
     * @param {String|FormData} params Parameters to send with request
     * @return {XMLHttpRequest}
     * @category core
     */
    sendXMLHttpRequest: function(xhr, method, url, params, defaultHeaders) {
        var k, headers, uk;

        xhr.open(method, url, this.o.async);
        for (k in defaultHeaders) {
            xhr.setRequestHeader(k, defaultHeaders[k]);
        }
        if (typeof params === 'string') {
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        }
        if (! this.o.crossOrigin) {
            xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
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
     * Execute function with specified options.
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
        this._initOptions();

        result = func.apply(this);

        this.o = originalOption;
        this._initOptions();

        return result;
    },

    _requestVia: function() {
        return (window.XDomainRequest &&
                this.o.crossOrigin &&
                /msie (8|9)\./i.test(window.navigator.appVersion)) ? 'xdr' : 'xhr';
    },

    /**
     * Send a request to the endpoint with specified parameters.
     * @method request
     * @param {String} method Request method
     * @param {String} endpoint Endpoint to request
     * @param {String|Object} [queryParameter]
     * @param {String|Object|HTMLFormElement|FormData} [requestData]
     *   @param {String|Object|HTMLFormElement} [requestData.{the-key-requires-json-text}] Can specify json-text value by string or object or HTMLFormElement. Serialize automatically if object or HTMLFormElement is passed.
     *   @param {HTMLInputElement|File} [requestData.{the-key-requires-file}] Can specify file value by HTMLInputElement or File object.
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
            xdr        = null,
            via        = this._requestVia(),
            tokenData  = this.getTokenData(),
            authHeader = this.getAuthorizationHeader('accessToken'),
            currentFormat     = this.getCurrentFormat(),
            originalMethod    = method,
            originalArguments = Array.prototype.slice.call(arguments),
            defaultParams     = {},
            defaultHeaders    = {};

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
                via = 'iframe';

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
                endpoint !== '/token' &&
                endpoint !== '/authentication';
        }

        function retryWithAuthentication() {
            api.request('POST', '/token', function(response) {
                if (response.error) {
                    parseArguments(originalArguments);
                    return runCallback(response);
                }
                else {
                    api.storeTokenData(response);
                    api.request.apply(api, originalArguments);
                    return false;
                }
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

        function parseArguments(args) {
            for (i = 2; i < args.length; i++) {
                v = args[i];
                switch (typeof v) {
                case 'function':
                    callback = v;
                    break;
                case 'object':
                    if (
                        v &&
                        ! v.nodeName &&
                        ((window.ActiveXObject && v instanceof window.ActiveXObject) ||
                         (window.XMLHttpRequest && v instanceof window.XMLHttpRequest) ||
                         (window.XDomainRequest && v instanceof window.XDomainRequest))
                    ) {
                        if (window.XDomainRequest && v instanceof window.XDomainRequest) {
                            xdr = v;
                        }
                        else {
                            xhr = v;
                        }
                    }
                    else {
                        paramsList.push(v);
                    }
                    break;
                case 'string':
                    paramsList.push(api._unserializeParams(v));
                    break;
                }
            }
        }

        if (! this.o.withoutAuthorization &&
            tokenData &&
            ! tokenData.accessToken &&
            endpoint !== '/token' &&
            endpoint !== '/authentication'
        ) {
            return retryWithAuthentication();
        }

        if (authHeader) {
            defaultHeaders['X-MT-Authorization'] = authHeader;
        }

        if (endpoint === '/token' || endpoint === '/authentication') {
            if (tokenData && tokenData.oneTimeToken) {
                defaultHeaders['X-MT-Authorization'] =
                    api.getAuthorizationHeader('oneTimeToken');
                delete tokenData.oneTimeToken;
            }
            else if (tokenData && tokenData.sessionId) {
                defaultHeaders['X-MT-Authorization'] =
                    api.getAuthorizationHeader('sessionId');
            }
            else if (endpoint === '/token' && originalMethod.toLowerCase() === 'post') {
                delete defaultHeaders['X-MT-Authorization'];
            }
            defaultParams.clientId = api.o.clientId;
        }

        if (this.o.withoutAuthorization) {
            delete defaultHeaders['X-MT-Authorization'];
        }

        if (this.o.suppressResponseCodes ||
            (typeof this.o.suppressResponseCodes === 'undefined' && via === 'xdr')
        ) {
            defaultParams.suppressResponseCodes = true;
        }

        if (! this.o.cache) {
            defaultParams._ = new Date().getTime();
        }

        if (currentFormat !== this.constructor.getDefaultFormat()) {
            defaultParams.format = currentFormat.fileExtension;
        }

        if (method.match(/^(put|delete)$/i)) {
            defaultParams.__method = method;
            method = 'POST';
        }

        parseArguments(arguments);

        if (paramsList.length && (method.toLowerCase() === 'get' || paramsList.length >= 2)) {
            endpoint = appendParamsToURL(endpoint, paramsList.shift());
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


        function responseCallback(contentType, responseText, status, statusText, cleanup) {
            var response, mimeType, format, callbackResult;

            try {
                mimeType = contentType;
                format   = api.findFormat(mimeType) || api.getCurrentFormat();
                response = format.unserialize(responseText);
            }
            catch (e) {
                response = {
                    error: {
                        code:    +status,
                        message: statusText || 'Communication Error'
                    }
                };
            }

            if (needToRetry(response)) {
                retryWithAuthentication();
                if (cleanup) {
                    cleanup();
                }
                return false;
            }

            if ((! response.error &&
                    endpoint === '/authentication' &&
                    originalMethod.toLowerCase() === 'delete') ||
                (response.error && response.error.code === 401 && (
                    (endpoint === '/authentication' &&
                     originalMethod.toLowerCase() === 'post') ||
                    (endpoint === '/token' &&
                     originalMethod.toLowerCase() === 'post')))) {
                api.clearTokenData();
            }
            else if (! response.error && (
                (endpoint === '/authentication' &&
                 originalMethod.toLowerCase() === 'post') ||
                (endpoint === '/token' &&
                 originalMethod.toLowerCase() === 'post'))) {
                api.storeTokenData(response);
            }

            callbackResult = runCallback(response);

            if (callbackResult !== false &&
                response.error && response.error.code === 401 &&
                endpoint !== '/authentication') {
                api.trigger('authorizationRequired', response);
            }
        }

        if (via === 'xdr') {
            if (! this._isEmptyObject(defaultHeaders)) {
                throw 'Cannot set request header when sending via XDomainRequest';
            }

            xdr = xdr || new window.XDomainRequest();
            xdr.onload = function() {
                responseCallback(xdr.contentType, xdr.responseText, 200);
            };
            xdr.onerror = function() {
                responseCallback(xdr.contentType, xdr.responseText, 404);
            };
            xdr.onprogress = function(){};
            xdr.ontimeout = function() {
                responseCallback(xdr.contentType, xdr.responseText, 0);
            };
            if (typeof this.o.timeout !== 'undefined') {
                xdr.timeout = this.o.timeout || Number.MAX_VALUE;
            }
            xdr.open( method, base + endpoint);
            xdr.send( api._serializeParams(params) || null );
        }
        else if (via === 'xhr') {
            xhr = xhr || this.newXMLHttpRequest();
            if (typeof this.o.timeout !== 'undefined') {
                xhr.timeout = this.o.timeout;
            }
            xhr.onreadystatechange = function() {
                var responseResult, url;

                if (xhr.readyState !== 4) {
                    return;
                }

                function cleanup() {
                    xhr.onreadystatechange = function(){};
                }

                responseResult = responseCallback(
                    xhr.getResponseHeader('Content-Type'),
                    xhr.responseText,
                    xhr.status,
                    xhr.statusText,
                    cleanup
                );

                if (responseResult === false) {
                    return;
                }

                url = xhr.getResponseHeader('X-MT-Next-Phase-URL');
                if (url) {
                    xhr.abort();
                    api.sendXMLHttpRequest(xhr, method, base + url, params, defaultHeaders);
                }
                else {
                    cleanup();
                }
            };
            return this.sendXMLHttpRequest(xhr, method, base + endpoint, params, defaultHeaders);
        }
        else {
            (function() {
                var k, file, originalName, input,
                    target     = api._getNextIframeName(),
                    doc        = window.document,
                    form       = doc.createElement('form'),
                    iframe     = doc.createElement('iframe');


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
                for (k in defaultHeaders) {
                    params[k] = defaultHeaders[k];
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
                        retryWithAuthentication();
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
     * @example
     *     var callback = function() {
     *       // Do stuff
     *     };
     *     api.on(eventName, callback);
     */
    on: function() {
        this.constructor.on.apply(this, arguments);
    },

    /**
     * Deregister callback from instance.
     * @method off
     * @param {String} key Event name
     * @param {Function} callback Callback function
     * @category core
     * @example
     *     api.off(eventName, callback);
     */
    off: function() {
        this.constructor.off.apply(this, arguments);
    },

    /**
     * Trigger event.
     * First, run class level callbacks. Then, run instance level callbacks.
     * @method trigger
     * @param {String} key Event name
     * @category core
     */
    trigger: function(key) {
        var i,
            args      = Array.prototype.slice.call(arguments, 1),
            callbacks = (this.constructor.callbacks[key] || []) // Class level
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
     * Generate methods to access endpoint.
     * @method generateEndpointMethods
     * @param {Array.Object} endpoints Endpoints to register
     *   @param {Object} endpoints.{i}
     *     @param {String} endpoints.{i}.id Normally, the ID is snake case,
     *       but generated method is camel case.
     *     @param {String} endpoints.{i}.route The template of route
     *     @param {String} endpoints.{i}.verb The HTTP verb
     *     @param {Array.String} [endpoints.{i}.resources] The required resource data
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
     * Load endpoint from DataAPI dynamically.
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

        api.withOptions({withoutAuthorization: true, async: false}, function() {
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
 * @example
 *     DataAPI.on("initialize", function() {
 *       console.log("initializing...");
 *     });
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
 *       console.log(response.error.message);
 *     });
 **/

/**
 * Triggered on receiving the HTTP response code 401 (Authorization required).
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

        var prefix = escape( this.name ) + "=",
            cookies = ("" + window.document.cookie).split( /;\s*/ ),
            i;

        for( i = 0; i < cookies.length; i++ ) {
            if( cookies[ i ].indexOf( prefix ) === 0 ) {
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
        }

        if( !exists( this.name ) ) {
            return undefined;
        }

        if( exists( value ) ) {
            this.value = value;
        }
        else {
            value = this.value;
        }

        var name = escape( this.name ),
            attributes = ( this.domain ? "; domain=" + escape( this.domain ) : "") +
            (this.path ? "; path=" + escape( this.path ) : "") +
            (this.expires ? "; expires=" + this.expires.toGMTString() : "") +
            (this.secure ? "; secure=1"  : ""),
            batter = name + "=" + escape( value ) + attributes;

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
};


Cookie.bake = function( name, value, domain, path, expires, secure ) {
    var cookie = new this( name, value, domain, path, expires, secure );
    return cookie.bake();
};

Cookie.remove = function( name ) {
    var cookie = this.fetch( name );
    if ( cookie ) {
        return cookie.remove();
    }
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

DataAPI.on('initialize', function() {
    this.generateEndpointMethods(
        [
    {
        "id": "list_endpoints",
        "route": "/endpoints",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "authenticate",
        "route": "/authentication",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "get_token",
        "route": "/token",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "revoke_authentication",
        "route": "/authentication",
        "verb": "DELETE",
        "resources": null
    },
    {
        "id": "revoke_token",
        "route": "/token",
        "verb": "DELETE",
        "resources": null
    },
    {
        "id": "get_user",
        "route": "/users/:user_id",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "update_user",
        "route": "/users/:user_id",
        "verb": "PUT",
        "resources": [
            "user"
        ]
    },
    {
        "id": "list_blogs_for_user",
        "route": "/users/:user_id/sites",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "get_blog",
        "route": "/sites/:site_id",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_entries",
        "route": "/sites/:site_id/entries",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "create_entry",
        "route": "/sites/:site_id/entries",
        "verb": "POST",
        "resources": [
            "entry"
        ]
    },
    {
        "id": "get_entry",
        "route": "/sites/:site_id/entries/:entry_id",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "update_entry",
        "route": "/sites/:site_id/entries/:entry_id",
        "verb": "PUT",
        "resources": [
            "entry"
        ]
    },
    {
        "id": "delete_entry",
        "route": "/sites/:site_id/entries/:entry_id",
        "verb": "DELETE",
        "resources": null
    },
    {
        "id": "list_categories",
        "route": "/sites/:site_id/categories",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_comments",
        "route": "/sites/:site_id/comments",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_comments_for_entry",
        "route": "/sites/:site_id/entries/:entry_id/comments",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "create_comment",
        "route": "/sites/:site_id/entries/:entry_id/comments",
        "verb": "POST",
        "resources": [
            "comment"
        ]
    },
    {
        "id": "create_reply_comment",
        "route": "/sites/:site_id/entries/:entry_id/comments/:comment_id/replies",
        "verb": "POST",
        "resources": [
            "comment"
        ]
    },
    {
        "id": "get_comment",
        "route": "/sites/:site_id/comments/:comment_id",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "update_comment",
        "route": "/sites/:site_id/comments/:comment_id",
        "verb": "PUT",
        "resources": [
            "comment"
        ]
    },
    {
        "id": "delete_comment",
        "route": "/sites/:site_id/comments/:comment_id",
        "verb": "DELETE",
        "resources": null
    },
    {
        "id": "list_trackbacks",
        "route": "/sites/:site_id/trackbacks",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_trackbacks_for_entry",
        "route": "/sites/:site_id/entries/:entry_id/trackbacks",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "get_trackback",
        "route": "/sites/:site_id/trackbacks/:ping_id",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "update_trackback",
        "route": "/sites/:site_id/trackbacks/:ping_id",
        "verb": "PUT",
        "resources": [
            "trackback"
        ]
    },
    {
        "id": "delete_trackback",
        "route": "/sites/:site_id/trackbacks/:ping_id",
        "verb": "DELETE",
        "resources": null
    },
    {
        "id": "upload_asset",
        "route": "/sites/:site_id/assets/upload",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "list_permissions_for_user",
        "route": "/users/:user_id/permissions",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "publish_entries",
        "route": "/publish/entries",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "get_stats_provider",
        "route": "/sites/:site_id/stats/provider",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_stats_pageviews_for_path",
        "route": "/sites/:site_id/stats/path/pageviews",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_stats_visits_for_path",
        "route": "/sites/:site_id/stats/path/visits",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_stats_pageviews_for_date",
        "route": "/sites/:site_id/stats/date/pageviews",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_stats_visits_for_date",
        "route": "/sites/:site_id/stats/date/visits",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_categories",
        "route": "/sites/:site_id/categories",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_categories_for_entry",
        "route": "/sites/:site_id/entries/:entry_id/categories",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_parent_categories",
        "route": "/sites/:site_id/categories/:category_id/parents",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_sibling_categories",
        "route": "/sites/:site_id/categories/:category_id/siblings",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_child_categories",
        "route": "/sites/:site_id/categories/:category_id/children",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "create_category",
        "route": "/sites/:site_id/categories",
        "verb": "POST",
        "resources": [
            "category"
        ]
    },
    {
        "id": "get_category",
        "route": "/sites/:site_id/categories/:category_id",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "update_category",
        "route": "/sites/:site_id/categories/:category_id",
        "verb": "PUT",
        "resources": [
            "category"
        ]
    },
    {
        "id": "delete_category",
        "route": "/sites/:site_id/categories/:category_id",
        "verb": "DELETE",
        "resources": null
    },
    {
        "id": "permutate_categories",
        "route": "/sites/:site_id/categories/permutate",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "list_folders",
        "route": "/sites/:site_id/folders",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_parent_folders",
        "route": "/sites/:site_id/folders/:folder_id/parents",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_sibling_folders",
        "route": "/sites/:site_id/folders/:folder_id/siblings",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_child_folders",
        "route": "/sites/:site_id/folders/:folder_id/children",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "create_folder",
        "route": "/sites/:site_id/folders",
        "verb": "POST",
        "resources": [
            "folder"
        ]
    },
    {
        "id": "get_folder",
        "route": "/sites/:site_id/folders/:folder_id",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "update_folder",
        "route": "/sites/:site_id/folders/:folder_id",
        "verb": "PUT",
        "resources": [
            "folder"
        ]
    },
    {
        "id": "delete_folder",
        "route": "/sites/:site_id/folders/:folder_id",
        "verb": "DELETE",
        "resources": null
    },
    {
        "id": "permutate_folders",
        "route": "/sites/:site_id/folders/permutate",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "list_assets",
        "route": "/sites/:site_id/assets",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_assets_for_entry",
        "route": "/sites/:site_id/entries/:entry_id/assets",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_assets_for_page",
        "route": "/sites/:site_id/pages/:page_id/assets",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_assets_for_site_and_tag",
        "route": "/sites/:site_id/tags/:tag_id/assets",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "upload_asset",
        "route": "/assets/upload",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "upload_asset_for_site",
        "route": "/sites/:site_id/assets/upload",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "get_asset",
        "route": "/sites/:site_id/assets/:asset_id",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "update_asset",
        "route": "/sites/:site_id/assets/:asset_id",
        "verb": "PUT",
        "resources": [
            "asset"
        ]
    },
    {
        "id": "delete_asset",
        "route": "/sites/:site_id/assets/:asset_id",
        "verb": "DELETE",
        "resources": null
    },
    {
        "id": "get_thumbnail",
        "route": "/sites/:site_id/assets/:asset_id/thumbnail",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_entries_for_category",
        "route": "/sites/:site_id/categories/:category_id/entries",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_entries_for_asset",
        "route": "/sites/:site_id/assets/:asset_id/entries",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_entries_for_site_and_tag",
        "route": "/sites/:site_id/tags/:tag_id/entries",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "create_entry",
        "route": "/sites/:site_id/entries",
        "verb": "POST",
        "resources": [
            "entry"
        ]
    },
    {
        "id": "update_entry",
        "route": "/sites/:site_id/entries/:entry_id",
        "verb": "PUT",
        "resources": [
            "entry"
        ]
    },
    {
        "id": "import_entries",
        "route": "/sites/:site_id/entries/import",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "export_entries",
        "route": "/sites/:site_id/entries/export",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "preview_entry_by_id",
        "route": "/sites/:site_id/entries/:entry_id/preview",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "preview_entry",
        "route": "/sites/:site_id/entries/preview",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "list_pages",
        "route": "/sites/:site_id/pages",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_pages_for_folder",
        "route": "/sites/:site_id/folders/:folder_id/pages",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_pages_for_asset",
        "route": "/sites/:site_id/assets/:asset_id/pages",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_pages_for_site_and_tag",
        "route": "/sites/:site_id/tags/:tag_id/pages",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "create_page",
        "route": "/sites/:site_id/pages",
        "verb": "POST",
        "resources": [
            "page"
        ]
    },
    {
        "id": "get_page",
        "route": "/sites/:site_id/pages/:page_id",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "update_page",
        "route": "/sites/:site_id/pages/:page_id",
        "verb": "PUT",
        "resources": [
            "page"
        ]
    },
    {
        "id": "delete_page",
        "route": "/sites/:site_id/pages/:page_id",
        "verb": "DELETE",
        "resources": null
    },
    {
        "id": "preview_page_by_id",
        "route": "/sites/:site_id/pages/:page_id/preview",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "preview_page",
        "route": "/sites/:site_id/pages/preview",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "list_comments_for_page",
        "route": "/sites/:site_id/pages/:page_id/comments",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "create_comment_for_page",
        "route": "/sites/:site_id/pages/:page_id/comments",
        "verb": "POST",
        "resources": [
            "comment"
        ]
    },
    {
        "id": "create_reply_comment_for_page",
        "route": "/sites/:site_id/pages/:page_id/comments/:comment_id/replies",
        "verb": "POST",
        "resources": [
            "comment"
        ]
    },
    {
        "id": "list_trackbacks_for_page",
        "route": "/sites/:site_id/pages/:page_id/trackbacks",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_sites",
        "route": "/sites",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_sites_by_parent",
        "route": "/sites/:site_id/children",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "insert_new_blog",
        "route": "/sites/:site_id",
        "verb": "POST",
        "resources": [
            "blog"
        ]
    },
    {
        "id": "insert_new_website",
        "route": "/sites",
        "verb": "POST",
        "resources": [
            "website"
        ]
    },
    {
        "id": "update_site",
        "route": "/sites/:site_id",
        "verb": "PUT",
        "resources": null
    },
    {
        "id": "delete_site",
        "route": "/sites/:site_id",
        "verb": "DELETE",
        "resources": null
    },
    {
        "id": "list_roles",
        "route": "/roles",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "create_role",
        "route": "/roles",
        "verb": "POST",
        "resources": [
            "role"
        ]
    },
    {
        "id": "get_role",
        "route": "/roles/:role_id",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "update_role",
        "route": "/roles/:role_id",
        "verb": "PUT",
        "resources": [
            "role"
        ]
    },
    {
        "id": "delete_role",
        "route": "/roles/:role_id",
        "verb": "DELETE",
        "resources": null
    },
    {
        "id": "list_permissions",
        "route": "/permissions",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_permissions_for_user",
        "route": "/users/:user_id/permissions",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_permissions_for_site",
        "route": "/sites/:site_id/permissions",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_permissions_for_role",
        "route": "/roles/:role_id/permissions",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "grant_permission_to_site",
        "route": "/sites/:site_id/permissions/grant",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "grant_permission_to_user",
        "route": "/users/:user_id/permissions/grant",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "revoke_permission_from_site",
        "route": "/sites/:site_id/permissions/revoke",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "revoke_permission_from_user",
        "route": "/users/:user_id/permissions/revoke",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "search",
        "route": "/search",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_logs",
        "route": "/sites/:site_id/logs",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "get_log",
        "route": "/sites/:site_id/logs/:log_id",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "create_log",
        "route": "/sites/:site_id/logs",
        "verb": "POST",
        "resources": [
            "log"
        ]
    },
    {
        "id": "update_log",
        "route": "/sites/:site_id/logs/:log_id",
        "verb": "PUT",
        "resources": [
            "log"
        ]
    },
    {
        "id": "delete_log",
        "route": "/sites/:site_id/logs/:log_id",
        "verb": "DELETE",
        "resources": null
    },
    {
        "id": "reset_logs",
        "route": "/sites/:site_id/logs",
        "verb": "DELETE",
        "resources": null
    },
    {
        "id": "export_logs",
        "route": "/sites/:site_id/logs/export",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_tags_for_site",
        "route": "/sites/:site_id/tags",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "get_tag_for_site",
        "route": "/sites/:site_id/tags/:tag_id",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "rename_tag_for_site",
        "route": "/sites/:site_id/tags/:tag_id",
        "verb": "PUT",
        "resources": null
    },
    {
        "id": "delete_tag_for_site",
        "route": "/sites/:site_id/tags/:tag_id",
        "verb": "DELETE",
        "resources": null
    },
    {
        "id": "list_themes",
        "route": "/themes",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_themes_for_site",
        "route": "/sites/:site_id/themes",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "get_theme",
        "route": "/themes/:theme_id",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "get_theme_for_site",
        "route": "/sites/:site_id/themes/:theme_id",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "apply_theme_to_site",
        "route": "/sites/:site_id/themes/:theme_id/apply",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "uninstall_theme",
        "route": "/themes/:theme_id",
        "verb": "DELETE",
        "resources": null
    },
    {
        "id": "export_site_theme",
        "route": "/sites/:site_id/export_theme",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "list_templates",
        "route": "/sites/:site_id/templates",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "get_template",
        "route": "/sites/:site_id/templates/:template_id",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "create_template",
        "route": "/sites/:site_id/templates",
        "verb": "POST",
        "resources": [
            "template"
        ]
    },
    {
        "id": "update_template",
        "route": "/sites/:site_id/templates/:template_id",
        "verb": "PUT",
        "resources": [
            "template"
        ]
    },
    {
        "id": "delete_template",
        "route": "/sites/:site_id/templates/:template_id",
        "verb": "DELETE",
        "resources": null
    },
    {
        "id": "publish_template",
        "route": "/sites/:site_id/templates/:template_id/publish",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "refresh_template",
        "route": "/sites/:site_id/templates/:template_id/refresh",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "refresh_templates_for_site",
        "route": "/sites/:site_id/refresh_templates",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "clone_template",
        "route": "/sites/:site_id/templates/:template_id/clone",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "preview_template_by_id",
        "route": "/sites/:site_id/templates/:template_id/preview",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "preview_template",
        "route": "/sites/:site_id/templates/preview",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "list_templatemaps",
        "route": "/sites/:site_id/templates/:template_id/templatemaps",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "get_templatemap",
        "route": "/sites/:site_id/templates/:template_id/templatemaps/:templatemap_id",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "create_templatemap",
        "route": "/sites/:site_id/templates/:template_id/templatemaps",
        "verb": "POST",
        "resources": [
            "templatemap"
        ]
    },
    {
        "id": "update_templatemap",
        "route": "/sites/:site_id/templates/:template_id/templatemaps/:templatemap_id",
        "verb": "PUT",
        "resources": [
            "templatemap"
        ]
    },
    {
        "id": "delete_templatemap",
        "route": "/sites/:site_id/templates/:template_id/templatemaps/:templatemap_id",
        "verb": "DELETE",
        "resources": null
    },
    {
        "id": "list_widgetsets",
        "route": "/sites/:site_id/widgetsets",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "get_widgetset",
        "route": "/sites/:site_id/widgetsets/:widgetset_id",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "create_widgetset",
        "route": "/sites/:site_id/widgetsets",
        "verb": "POST",
        "resources": [
            "widgetset"
        ]
    },
    {
        "id": "update_widgetset",
        "route": "/sites/:site_id/widgetsets/:widgetset_id",
        "verb": "PUT",
        "resources": [
            "widgetset"
        ]
    },
    {
        "id": "delete_widgetset",
        "route": "/sites/:site_id/widgetsets/:widgetset_id",
        "verb": "DELETE",
        "resources": null
    },
    {
        "id": "list_widgets",
        "route": "/sites/:site_id/widgets",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_widgets_for_widgetset",
        "route": "/sites/:site_id/widgetsets/:widgetset_id/widgets",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "get_widgets",
        "route": "/sites/:site_id/widgets/:widget_id",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "get_widget_for_widgetset",
        "route": "/sites/:site_id/widgetsets/:widgetset_id/widgets/:widget_id",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "create_widget",
        "route": "/sites/:site_id/widgets",
        "verb": "POST",
        "resources": [
            "widget"
        ]
    },
    {
        "id": "update_widget",
        "route": "/sites/:site_id/widgets/:widget_id",
        "verb": "PUT",
        "resources": [
            "widget"
        ]
    },
    {
        "id": "delete_widget",
        "route": "/sites/:site_id/widgets/:widget_id",
        "verb": "DELETE",
        "resources": null
    },
    {
        "id": "refresh_widget",
        "route": "/sites/:site_id/widgets/:widget_id/refresh",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "clone_widget",
        "route": "/sites/:site_id/widgets/:widget_id/clone",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "list_users",
        "route": "/users",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "create_user",
        "route": "/users",
        "verb": "POST",
        "resources": [
            "user"
        ]
    },
    {
        "id": "delete_user",
        "route": "/users/:user_id",
        "verb": "DELETE",
        "resources": null
    },
    {
        "id": "unlock_user",
        "route": "/users/:user_id/unlock",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "recover_password_for_user",
        "route": "/users/:user_id/recover_password",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "recover_password",
        "route": "/recover_password",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "list_plugins",
        "route": "/plugins",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "get_plugin",
        "route": "/plugins/:plugin_id",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "enable_plugin",
        "route": "/plugins/:plugin_id/enable",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "disable_plugin",
        "route": "/plugins/:plugin_id/disable",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "enable_all_plugins",
        "route": "/plugins/enable",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "disable_all_plugins",
        "route": "/plugins/disable",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "backup_site",
        "route": "/sites/:site_id/backup",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "authenticate",
        "route": "/authentication",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "upload_asset",
        "route": "/assets/upload",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "upload_asset_for_site",
        "route": "/sites/:site_id/assets/upload",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "list_fields",
        "route": "/sites/:site_id/fields",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "get_field",
        "route": "/sites/:site_id/fields/:field_id",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "create_field",
        "route": "/sites/:site_id/fields",
        "verb": "POST",
        "resources": [
            "field"
        ]
    },
    {
        "id": "update_field",
        "route": "/sites/:site_id/fields/:field_id",
        "verb": "PUT",
        "resources": [
            "field"
        ]
    },
    {
        "id": "delete_field",
        "route": "/sites/:site_id/fields/:field_id",
        "verb": "DELETE",
        "resources": null
    },
    {
        "id": "list_groups",
        "route": "/groups",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "list_groups_for_user",
        "route": "/users/:user_id/groups",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "get_group",
        "route": "/groups/:group_id",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "create_group",
        "route": "/groups",
        "verb": "POST",
        "resources": [
            "group"
        ]
    },
    {
        "id": "update_group",
        "route": "/groups/:group_id",
        "verb": "PUT",
        "resources": [
            "group"
        ]
    },
    {
        "id": "delete_group",
        "route": "/groups/:group_id",
        "verb": "DELETE",
        "resources": null
    },
    {
        "id": "synchronize_groups",
        "route": "/groups/synchronize",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "list_permissions_for_group",
        "route": "/groups/:group_id/permissions",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "grant_permission_to_group",
        "route": "/groups/:group_id/permissions/grant",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "revoke_permission_from_group",
        "route": "/groups/:group_id/permissions/revoke",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "list_members_for_group",
        "route": "/groups/:group_id/members",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "get_member_for_group",
        "route": "/groups/:group_id/members/:member_id",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "add_member_to_group",
        "route": "/groups/:group_id/members",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "remove_member_from_group",
        "route": "/groups/:group_id/members/:member_id",
        "verb": "DELETE",
        "resources": null
    },
    {
        "id": "bulk_author_import",
        "route": "/users/import",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "bulk_author_export",
        "route": "/users/export",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "synchronize_users",
        "route": "/users/synchronize",
        "verb": "POST",
        "resources": null
    },
    {
        "id": "list_formatted_texts",
        "route": "/sites/:site_id/formatted_texts",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "get_formatted_text",
        "route": "/sites/:site_id/formatted_texts/:formatted_text_id",
        "verb": "GET",
        "resources": null
    },
    {
        "id": "create_formatted_text",
        "route": "/sites/:site_id/formatted_texts",
        "verb": "POST",
        "resources": [
            "formatted_text"
        ]
    },
    {
        "id": "update_formatted_text",
        "route": "/sites/:site_id/formatted_texts/:formatted_text_id",
        "verb": "PUT",
        "resources": [
            "formatted_text"
        ]
    },
    {
        "id": "delete_formatted_text",
        "route": "/sites/:site_id/formatted_texts/:formatted_text_id",
        "verb": "DELETE",
        "resources": null
    }
]

    );
});

window.MT         = window.MT || {};
window.MT.DataAPI = window.MT.DataAPI || DataAPI;
window.MT.DataAPI['v' + DataAPI.version] = DataAPI;


return DataAPI;

}));
