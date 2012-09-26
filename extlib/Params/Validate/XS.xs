/* Copyright (c) 2000-2012 Dave Rolsky and Ilya Martynov */

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#define NEED_eval_pv
#define NEED_newCONSTSUB
#define NEED_sv_2pv_flags
#include "ppport.h"

#ifdef __GNUC__
#define INLINE inline
#else
#define INLINE
#endif

/* type constants */
#define SCALAR    1
#define ARRAYREF  2
#define HASHREF   4
#define CODEREF   8
#define GLOB      16
#define GLOBREF   32
#define SCALARREF 64
#define UNKNOWN   128
#define UNDEF     256
#define OBJECT    512

#define HANDLE    (GLOB | GLOBREF)
#define BOOLEAN   (SCALAR | UNDEF)

/* return data macros */
#define RETURN_ARRAY(ret) \
    STMT_START \
    { \
        I32 i; \
        switch(GIMME_V) \
        { \
            case G_VOID: \
                return; \
                case G_ARRAY: \
                    EXTEND(SP, av_len(ret) + 1); \
                    for(i = 0; i <= av_len(ret); i++) \
                    { \
                        PUSHs(*av_fetch(ret, i, 1)); \
                    } \
                    break; \
                    case G_SCALAR: \
                        XPUSHs(sv_2mortal(newRV_inc((SV*) ret))); \
                        break; \
                    } \
                } STMT_END \

#define RETURN_HASH(ret) \
    STMT_START \
    { \
        HE* he; \
        I32 keys; \
        switch(GIMME_V) \
        { \
            case G_VOID: \
                return; \
                case G_ARRAY: \
                    keys = hv_iterinit(ret); \
                    EXTEND(SP, keys * 2); \
                    while ((he = hv_iternext(ret))) \
                    { \
                        PUSHs(HeSVKEY_force(he)); \
                        PUSHs(HeVAL(he)); \
                    } \
                    break; \
                    case G_SCALAR: \
                        XPUSHs(sv_2mortal(newRV_inc((SV*) ret))); \
                        break; \
                    } \
                } STMT_END


INLINE static bool
no_validation() {
    SV* no_v;

    no_v = get_sv("Params::Validate::NO_VALIDATION", 0);
    if (! no_v)
        croak("Cannot retrieve $Params::Validate::NO_VALIDATION\n");

    return SvTRUE(no_v);
}


/* return type string that corresponds to typemask */
INLINE static SV*
typemask_to_string(IV mask) {
    SV* buffer;
    IV empty = 1;

    buffer = sv_2mortal(newSVpv("", 0));

    if (mask & SCALAR) {
        sv_catpv(buffer, "scalar");
        empty = 0;
    }
    if (mask & ARRAYREF) {
        sv_catpv(buffer, empty ? "arrayref" : " arrayref");
        empty = 0;
    }
    if (mask & HASHREF) {
        sv_catpv(buffer, empty ? "hashref" : " hashref");
        empty = 0;
    }
    if (mask & CODEREF) {
        sv_catpv(buffer, empty ? "coderef" : " coderef");
        empty = 0;
    }
    if (mask & GLOB) {
        sv_catpv(buffer, empty ? "glob" : " glob");
        empty = 0;
    }
    if (mask & GLOBREF) {
        sv_catpv(buffer, empty ? "globref" : " globref");
        empty = 0;
    }
    if (mask & SCALARREF) {
        sv_catpv(buffer, empty ? "scalarref" : " scalarref");
        empty = 0;
    }
    if (mask & UNDEF) {
        sv_catpv(buffer, empty ? "undef" : " undef");
        empty = 0;
    }
    if (mask & OBJECT) {
        sv_catpv(buffer, empty ? "object" : " object");
        empty = 0;
    }
    if (mask & UNKNOWN) {
        sv_catpv(buffer, empty ? "unknown" : " unknown");
        empty = 0;
    }

    return buffer;
}


/* compute numberic datatype for variable */
INLINE static IV
get_type(SV* sv) {
    IV type = 0;

    if (SvTYPE(sv) == SVt_PVGV) {
        return GLOB;
    }
    if (!SvOK(sv)) {
        return UNDEF;
    }
    if (!SvROK(sv)) {
        return SCALAR;
    }

    switch (SvTYPE(SvRV(sv))) {
        case SVt_NULL:
        case SVt_IV:
        case SVt_NV:
        case SVt_PV:
        #if PERL_VERSION <= 10
        case SVt_RV:
        #endif
        case SVt_PVMG:
        case SVt_PVIV:
        case SVt_PVNV:
        #if PERL_VERSION <= 8
        case SVt_PVBM:
        #elif PERL_VERSION >= 11
        case SVt_REGEXP:
        #endif
            type = SCALARREF;
            break;
        case SVt_PVAV:
            type = ARRAYREF;
            break;
        case SVt_PVHV:
            type = HASHREF;
            break;
        case SVt_PVCV:
            type = CODEREF;
            break;
        case SVt_PVGV:
            type = GLOBREF;
            break;
            /* Perl 5.10 has a bunch of new types that I don't think will ever
               actually show up here (I hope), but not handling them makes the
               C compiler cranky. */
        default:
            type = UNKNOWN;
            break;
    }

    if (type) {
        if (sv_isobject(sv)) return type | OBJECT;
        return type;
    }

    /* Getting here should not be possible */
    return UNKNOWN;
}


/* get an article for given string */
INLINE static const char*
article(SV* string) {
    STRLEN len;
    char* rawstr;

    rawstr = SvPV(string, len);
    if (len) {
        switch(rawstr[0]) {
            case 'a':
            case 'e':
            case 'i':
            case 'o':
            case 'u':
                return "an";
        }
    }

    return "a";
}


/* raises exception either using user-defined callback or using
   built-in method */
static void
validation_failure(SV* message, HV* options) {
    SV** temp;
    SV* on_fail;

    if ((temp = hv_fetch(options, "on_fail", 7, 0))) {
        SvGETMAGIC(*temp);
        on_fail = *temp;
    }
    else {
        on_fail = NULL;
    }

    /* use user defined callback if available */
    if (on_fail) {
        dSP;
        PUSHMARK(SP);
        XPUSHs(message);
        PUTBACK;
        call_sv(on_fail, G_DISCARD);
    }
    else {
        /* by default resort to Carp::confess for error reporting */
        dSP;
        perl_require_pv("Carp.pm");
        PUSHMARK(SP);
        XPUSHs(message);
        PUTBACK;
        call_pv("Carp::confess", G_DISCARD);
    }

    return;
}

/* get called subroutine fully qualified name */
static SV*
get_called(HV* options) {
    SV** temp;

    if ((temp = hv_fetch(options, "called", 6, 0))) {
        SvGETMAGIC(*temp);
        return *temp;
    }
    else {
        IV frame;
        SV* buffer;
        SV* caller;

        if ((temp = hv_fetch(options, "stack_skip", 10, 0))) {
            SvGETMAGIC(*temp);
            frame = SvIV(*temp);
        }
        else {
            frame = 1;
        }

        buffer = sv_2mortal(newSVpvf("(caller(%d))[3]", (int) frame));
        SvTAINTED_off(buffer);

        caller = eval_pv(SvPV_nolen(buffer), 1);
        if (SvTYPE(caller) == SVt_NULL) {
            sv_setpv(caller, "N/A");
        }

        return caller;
    }
}


/* $value->isa alike validation */
static IV
validate_isa(SV* value, SV* package, SV* id, HV* options) {
    SV* buffer;
    IV ok = 1;

    SvGETMAGIC(value);
    if (SvOK(value) && (sv_isobject(value) || (SvPOK(value) && ! looks_like_number(value)))) {
        dSP;

        SV* ret;
        IV count;

        ENTER;
        SAVETMPS;

        PUSHMARK(SP);
        EXTEND(SP, 2);
        PUSHs(value);
        PUSHs(package);
        PUTBACK;

        count = call_method("isa", G_SCALAR);

        if (! count)
            croak("Calling isa did not return a value");

        SPAGAIN;

        ret = POPs;
        SvGETMAGIC(ret);

        ok = SvTRUE(ret);

        PUTBACK;
        FREETMPS;
        LEAVE;
    }
    else {
        ok = 0;
    }

    if (! ok) {
        buffer = sv_2mortal(newSVsv(id));
        sv_catpv(buffer, " to ");
        sv_catsv(buffer, get_called(options));
        sv_catpv(buffer, " was not ");
        sv_catpv(buffer, article(package));
        sv_catpv(buffer, " '");
        sv_catsv(buffer, package);
        sv_catpv(buffer, "' (it is ");
        if ( SvOK(value) ) {
            sv_catpv(buffer, article(value));
            sv_catpv(buffer, " ");
            sv_catsv(buffer, value);
        }
        else {
            sv_catpv(buffer, "undef");
        }
        sv_catpv(buffer, ")\n");
        validation_failure(buffer, options);
    }

    return 1;
}


static IV
validate_can(SV* value, SV* method, SV* id, HV* options) {
    IV ok = 1;

    SvGETMAGIC(value);
    if (SvOK(value) && (sv_isobject(value) || (SvPOK(value) && ! looks_like_number(value)))) {
        dSP;

        SV* ret;
        IV count;

        ENTER;
        SAVETMPS;

        PUSHMARK(SP);
        EXTEND(SP, 2);
        PUSHs(value);
        PUSHs(method);
        PUTBACK;

        count = call_method("can", G_SCALAR);

        if (! count)
            croak("Calling can did not return a value");

        SPAGAIN;

        ret = POPs;
        SvGETMAGIC(ret);

        ok = SvTRUE(ret);

        PUTBACK;
        FREETMPS;
        LEAVE;
    }
    else {
        ok = 0;
    }

    if (! ok) {
        SV* buffer;

        buffer = sv_2mortal(newSVsv(id));
        sv_catpv(buffer, " to ");
        sv_catsv(buffer, get_called(options));
        sv_catpv(buffer, " does not have the method: '");
        sv_catsv(buffer, method);
        sv_catpv(buffer, "'\n");
        validation_failure(buffer, options);
    }

    return 1;
}

/* validates specific parameter using supplied parameter specification */
static IV
validate_one_param(SV* value, SV* params, HV* spec, SV* id, HV* options, IV* untaint) {
    SV** temp;
    IV   i;

    /*
    HE* he;
    hv_iterinit(spec);

    while (he = hv_iternext(spec)) {
        STRLEN len;
        char* key = HePV(he, len);
        int ok = 0;
        int j;
        for ( j = 0; j < VALID_KEY_COUNT; j++ ) {
            if ( strcmp( key, valid_keys[j] ) == 0) {
                ok = 1;
                break;
            }
        }

        if ( ! ok ) {
            SV* buffer = sv_2mortal(newSVpv("\"",0));
            sv_catpv( buffer, key );
            sv_catpv( buffer, "\" is not an allowed validation spec key\n");
            validation_failure(buffer, options);
        }
    }
    */

    /* check type */
    if ((temp = hv_fetch(spec, "type", 4, 0))) {
        IV type;

        if ( ! ( SvOK(*temp)
            && looks_like_number(*temp)
            && SvIV(*temp) > 0 ) ) {
            SV* buffer;

            buffer = sv_2mortal(newSVsv(id));
            sv_catpv( buffer, " has a type specification which is not a number. It is ");
            if ( SvOK(*temp) ) {
                sv_catpv( buffer, "a string - " );
                sv_catsv( buffer, *temp );
            }
            else {
                sv_catpv( buffer, "undef");
            }
            sv_catpv( buffer, ".\n Use the constants exported by Params::Validate to declare types." );

            validation_failure(buffer, options);
        }

        SvGETMAGIC(*temp);
        type = get_type(value);
        if (! (type & SvIV(*temp))) {
            SV* buffer;
            SV* is;
            SV* allowed;

            buffer = sv_2mortal(newSVsv(id));
            sv_catpv(buffer, " to ");
            sv_catsv(buffer, get_called(options));
            sv_catpv(buffer, " was ");
            is = typemask_to_string(type);
            allowed = typemask_to_string(SvIV(*temp));
            sv_catpv(buffer, article(is));
            sv_catpv(buffer, " '");
            sv_catsv(buffer, is);
            sv_catpv(buffer, "', which is not one of the allowed types: ");
            sv_catsv(buffer, allowed);
            sv_catpv(buffer, "\n");
            validation_failure(buffer, options);
        }
    }

    /* check isa */
    if ((temp = hv_fetch(spec, "isa", 3, 0))) {
        SvGETMAGIC(*temp);

        if (SvROK(*temp) && SvTYPE(SvRV(*temp)) == SVt_PVAV) {
            AV* array = (AV*) SvRV(*temp);

            for(i = 0; i <= av_len(array); i++) {
                SV* package;

                package = *av_fetch(array, i, 1);
                SvGETMAGIC(package);
                if (! validate_isa(value, package, id, options)) {
                    return 0;
                }
            }
        }
        else {
            if (! validate_isa(value, *temp, id, options)) {
                return 0;
            }
        }
    }

    /* check can */
    if ((temp = hv_fetch(spec, "can", 3, 0))) {
        SvGETMAGIC(*temp);
        if (SvROK(*temp) && SvTYPE(SvRV(*temp)) == SVt_PVAV) {
            AV* array = (AV*) SvRV(*temp);

            for (i = 0; i <= av_len(array); i++) {
                SV* method;

                method = *av_fetch(array, i, 1);
                SvGETMAGIC(method);

                if (! validate_can(value, method, id, options)) {
                    return 0;
                }
            }
        }
        else {
            if (! validate_can(value, *temp, id, options)) {
                return 0;
            }
        }
    }

    /* let callbacks to do their tests */
    if ((temp = hv_fetch(spec, "callbacks", 9, 0))) {
        SvGETMAGIC(*temp);
        if (SvROK(*temp) && SvTYPE(SvRV(*temp)) == SVt_PVHV) {
            HE* he;

            hv_iterinit((HV*) SvRV(*temp));
            while ((he = hv_iternext((HV*) SvRV(*temp)))) {
                if (SvROK(HeVAL(he)) && SvTYPE(SvRV(HeVAL(he))) == SVt_PVCV) {
                    dSP;

                    SV* ret;
                    IV ok;
                    IV count;

                    ENTER;
                    SAVETMPS;

                    PUSHMARK(SP);
                    EXTEND(SP, 2);
                    PUSHs(value);
                    PUSHs(sv_2mortal(newRV_inc(params)));
                    PUTBACK;

                    count = call_sv(SvRV(HeVAL(he)), G_SCALAR);

                    SPAGAIN;

                    if (! count)
                        croak("Validation callback did not return anything");

                    ret = POPs;
                    SvGETMAGIC(ret);
                    ok = SvTRUE(ret);

                    PUTBACK;
                    FREETMPS;
                    LEAVE;

                    if (! ok) {
                        SV* buffer;

                        buffer = sv_2mortal(newSVsv(id));
                        sv_catpv(buffer, " to ");
                        sv_catsv(buffer, get_called(options));
                        sv_catpv(buffer, " did not pass the '");
                        sv_catsv(buffer, HeSVKEY_force(he));
                        sv_catpv(buffer, "' callback\n");
                        validation_failure(buffer, options);
                    }
                }
                else {
                    SV* buffer;

                    buffer = sv_2mortal(newSVpv("callback '", 0));
                    sv_catsv(buffer, HeSVKEY_force(he));
                    sv_catpv(buffer, "' for ");
                    sv_catsv(buffer, get_called(options));
                    sv_catpv(buffer, " is not a subroutine reference\n");
                    validation_failure(buffer, options);
                }
            }
        }
        else {
            SV* buffer;

            buffer = sv_2mortal(newSVpv("'callbacks' validation parameter for '", 0));
            sv_catsv(buffer, get_called(options));
            sv_catpv(buffer, " must be a hash reference\n");
            validation_failure(buffer, options);
        }
    }

    if ((temp = hv_fetch(spec, "regex", 5, 0))) {
        dSP;

        IV has_regex = 0;
        IV ok;

        SvGETMAGIC(*temp);
        if (SvPOK(*temp)) {
            has_regex = 1;
        }
        else if (SvROK(*temp)) {
            SV* svp;

            svp = (SV*)SvRV(*temp);

            #if PERL_VERSION <= 10
            if (SvMAGICAL(svp) && mg_find(svp, PERL_MAGIC_qr)) {
                has_regex = 1;
            }
            #else
            if (SvTYPE(svp) == SVt_REGEXP) {
                has_regex = 1;
            }
            #endif
        }

        if (!has_regex) {
            SV* buffer;

            buffer = sv_2mortal(newSVpv("'regex' validation parameter for '", 0));
            sv_catsv(buffer, get_called(options));
            sv_catpv(buffer, " must be a string or qr// regex\n");
            validation_failure(buffer, options);
        }

        PUSHMARK(SP);
        EXTEND(SP, 2);
        PUSHs(value);
        PUSHs(*temp);
        PUTBACK;
        call_pv("Params::Validate::XS::_check_regex_from_xs", G_SCALAR);
        SPAGAIN;
        ok = POPi;
        PUTBACK;

        if (!ok) {
            SV* buffer;

            buffer = sv_2mortal(newSVsv(id));
            sv_catpv(buffer, " to ");
            sv_catsv(buffer, get_called(options));
            sv_catpv(buffer, " did not pass regex check\n");
            validation_failure(buffer, options);
        }
    }

    if ((temp = hv_fetch(spec, "untaint", 7, 0))) {
        if (SvTRUE(*temp)) {
            *untaint = 1;
        }
    }

    return 1;
}


/* merges one hash into another (not deep copy) */
static void
merge_hashes(HV* in, HV* out) {
    HE* he;

    hv_iterinit(in);
    while ((he = hv_iternext(in))) {
        if (!hv_store_ent(out, HeSVKEY_force(he),
        SvREFCNT_inc(HeVAL(he)), HeHASH(he))) {
            SvREFCNT_dec(HeVAL(he));
            croak("Cannot add new key to hash");
        }
    }
}


/* convert array to hash */
static IV
convert_array2hash(AV* in, HV* options, HV* out) {
    IV i;
    I32 len;

    len = av_len(in);
    if (len > -1 && len % 2 != 1) {
        SV* buffer;
        buffer = sv_2mortal(newSVpv("Odd number of parameters in call to ", 0));
        sv_catsv(buffer, get_called(options));
        sv_catpv(buffer, " when named parameters were expected\n");

        validation_failure(buffer, options);
    }

    for(i = 0; i <= av_len(in); i += 2) {
        SV* key;
        SV* value;

        key = *av_fetch(in, i, 1);
        SvGETMAGIC(key);

        /* We need to make a copy because if the array was @_, then the
           values in the array are marked as readonly, which causes
           problems when the hash being made gets returned to the
           caller. */
        value = sv_2mortal( newSVsv( *av_fetch(in, i + 1, 1) ) );
        SvGETMAGIC(value);

        if (! hv_store_ent(out, key, SvREFCNT_inc(value), 0)) {
            SvREFCNT_dec(value);
            croak("Cannot add new key to hash");
        }
    }

    return 1;
}


/* get current Params::Validate options */
static HV*
get_options(HV* options) {
    HV* OPTIONS;
    HV* ret;
    SV** temp;
    char* pkg;
    SV* buffer;
    SV* caller;

    ret = (HV*) sv_2mortal((SV*) newHV());

    buffer = sv_2mortal(newSVpv("caller(0)", 0));
    SvTAINTED_off(buffer);

    caller = eval_pv(SvPV_nolen(buffer), 1);
    if (SvTYPE(caller) == SVt_NULL) {
        pkg = "main";
    }
    else {
        pkg = SvPV_nolen(caller);
    }

    /* get package specific options */
    OPTIONS = get_hv("Params::Validate::OPTIONS", 1);
    if ((temp = hv_fetch(OPTIONS, pkg, strlen(pkg), 0))) {
        SvGETMAGIC(*temp);
        if (SvROK(*temp) && SvTYPE(SvRV(*temp)) == SVt_PVHV) {
            if (options) {
                merge_hashes((HV*) SvRV(*temp), ret);
            }
            else {
                return (HV*) SvRV(*temp);
            }
        }
    }
    if (options) {
        merge_hashes(options, ret);
    }

    return ret;
}


static SV*
normalize_one_key(SV* key, SV* normalize_func, SV* strip_leading, IV ignore_case) {
    SV* copy;
    STRLEN len_sl;
    STRLEN len;
    char *rawstr_sl;
    char *rawstr;

    copy = sv_2mortal(newSVsv(key));

    /* if normalize_func is provided, ignore the other options */
    if (normalize_func) {
        dSP;

        SV* normalized;

        PUSHMARK(SP);
        XPUSHs(copy);
        PUTBACK;
        if (! call_sv(SvRV(normalize_func), G_SCALAR)) {
            croak("The normalize_keys callback did not return anything");
        }
        SPAGAIN;
        normalized = POPs;
        PUTBACK;

        if (! SvOK(normalized)) {
            croak("The normalize_keys callback did not return a defined value when normalizing the key '%s'", SvPV_nolen(copy));
        }

        return normalized;
    }
    else if (ignore_case || strip_leading) {
        if (ignore_case) {
            STRLEN i;

            rawstr = SvPV(copy, len);
            for (i = 0; i < len; i++) {
                /* should this account for UTF8 strings? */
                *(rawstr + i) = toLOWER(*(rawstr + i));
            }
        }

        if (strip_leading) {
            rawstr_sl = SvPV(strip_leading, len_sl);
            rawstr = SvPV(copy, len);

            if (len > len_sl && strnEQ(rawstr_sl, rawstr, len_sl)) {
                copy = sv_2mortal(newSVpvn(rawstr + len_sl, len - len_sl));
            }
        }
    }

    return copy;
}


static HV*
normalize_hash_keys(HV* p, SV* normalize_func, SV* strip_leading, IV ignore_case) {
    SV* normalized;
    HE* he;
    HV* norm_p;

    if (!normalize_func && !ignore_case && !strip_leading) {
        return p;
    }

    norm_p = (HV*) sv_2mortal((SV*) newHV());
    hv_iterinit(p);
    while ((he = hv_iternext(p))) {
        normalized =
            normalize_one_key(HeSVKEY_force(he), normalize_func, strip_leading, ignore_case);

        if (hv_fetch_ent(norm_p, normalized, 0, 0)) {
            croak("The normalize_keys callback returned a key that already exists, '%s', when normalizing the key '%s'",
                SvPV_nolen(normalized), SvPV_nolen(HeSVKEY_force(he)));
        }

        if (! hv_store_ent(norm_p, normalized, SvREFCNT_inc(HeVAL(he)), 0)) {
            SvREFCNT_dec(HeVAL(he));
            croak("Cannot add new key to hash");
        }
    }
    return norm_p;
}


static IV
validate_pos_depends(AV* p, AV* specs, HV* options) {
    IV p_idx;
    SV** depends;
    SV** p_spec;
    SV* buffer;

    for (p_idx = 0; p_idx <= av_len(p); p_idx++) {
        p_spec = av_fetch(specs, p_idx, 0);

        if (p_spec != NULL && SvROK(*p_spec) &&
        SvTYPE(SvRV(*p_spec)) == SVt_PVHV) {

            depends = hv_fetch((HV*) SvRV(*p_spec), "depends", 7, 0);

            if (! depends) {
                return 1;
            }

            if (SvROK(*depends)) {
                croak("Arguments to 'depends' for validate_pos() must be a scalar");
            }

            if (av_len(p) < SvIV(*depends) -1) {

                buffer =
                    sv_2mortal(newSVpvf("Parameter #%d depends on parameter #%d, which was not given",
                    (int) p_idx + 1,
                    (int) SvIV(*depends)));

                validation_failure(buffer, options);
            }
        }
    }
    return 1;
}


static IV
validate_named_depends(HV* p, HV* specs, HV* options) {
    HE* he;
    HE* he1;
    SV* buffer;
    SV** depends_value;
    AV* depends_list;
    SV* depend_name;
    SV* temp;
    I32 d_idx;

    /* the basic idea here is to iterate through the parameters
     * (which we assumed to have already gone through validation
     * via validate_one_param()), and the check to see if that
     * parameter contains a "depends" spec. If it does, we'll
     * check if that parameter specified by depends exists in p
     */
    hv_iterinit(p);
    while ((he = hv_iternext(p))) {
        he1 = hv_fetch_ent(specs, HeSVKEY_force(he), 0, HeHASH(he));

        if (he1 && SvROK(HeVAL(he1)) &&
            SvTYPE(SvRV(HeVAL(he1))) == SVt_PVHV) {

            if (hv_exists((HV*) SvRV(HeVAL(he1)), "depends", 7)) {

                depends_value = hv_fetch((HV*) SvRV(HeVAL(he1)), "depends", 7, 0);

                if (! depends_value) {
                    return 1;
                }

                if (! SvROK(*depends_value)) {
                    depends_list = (AV*) sv_2mortal((SV*) newAV());
                    temp = sv_2mortal(newSVsv(*depends_value));
                    av_push(depends_list,SvREFCNT_inc(temp));
                }
                else if (SvTYPE(SvRV(*depends_value)) == SVt_PVAV) {
                    depends_list = (AV*) SvRV(*depends_value);
                }
                else {
                    croak("Arguments to 'depends' must be a scalar or arrayref");
                }

                for (d_idx =0; d_idx <= av_len(depends_list); d_idx++) {

                    depend_name = *av_fetch(depends_list, d_idx, 0);

                    /* first check if the parameter to which this
                     * depends on was given to us
                     */
                    if (!hv_exists(p, SvPV_nolen(depend_name),
                    SvCUR(depend_name))) {
                        /* oh-oh, the parameter that this parameter
                         * depends on is not available. Let's first check
                         * if this is even valid in the spec (i.e., the
                         * spec actually contains a spec for such parameter)
                         */
                        if (!hv_exists(specs, SvPV_nolen(depend_name),
                        SvCUR(depend_name))) {

                            buffer =
                                sv_2mortal(newSVpv("Following parameter specified in depends for '", 0));

                            sv_catsv(buffer, HeSVKEY_force(he1));
                            sv_catpv(buffer, "' does not exist in spec: ");
                            sv_catsv(buffer, depend_name);

                            croak("%s", SvPV_nolen(buffer));
                        }
                        /* if we got here, the spec was correct. we just
                         * need to issue a regular validation failure
                         */
                        buffer = sv_2mortal(newSVpv( "Parameter '", 0));
                        sv_catsv(buffer, HeSVKEY_force(he1));
                        sv_catpv(buffer, "' depends on parameter '");
                        sv_catsv(buffer, depend_name);
                        sv_catpv(buffer, "', which was not given");
                        validation_failure(buffer, options);
                    }
                }
            }
        }
    }
    return 1;
}


void
cat_string_representation(SV* buffer, SV* value) {
    if(SvOK(value)) {
        sv_catpv(buffer, "\"");
        sv_catpv(buffer, SvPV_nolen(value));
        sv_catpv(buffer, "\"");
    }
    else {
        sv_catpv(buffer, "undef");
    }
}


void
apply_defaults(HV *ret, HV *p, HV *specs, AV *missing) {
    HE* he;
    SV** temp;

    hv_iterinit(specs);
    while ((he = hv_iternext(specs))) {
        HV* spec;
        SV* val;

        val = HeVAL(he);

        /* get extended param spec if available */
        if (SvROK(val) && SvTYPE(SvRV(val)) == SVt_PVHV) {
            spec = (HV*) SvRV(val);
        }
        else {
            spec = NULL;
        }

        /* test for parameter existence  */
        if (hv_exists_ent(p, HeSVKEY_force(he), HeHASH(he))) {
            continue;
        }

        /* parameter may not be defined but we may have default */
        if (spec && (temp = hv_fetch(spec, "default", 7, 0))) {
            SV* value;

            SvGETMAGIC(*temp);
            value = sv_2mortal(newSVsv(*temp));

            /* make sure that parameter is put into return hash */
            if (GIMME_V != G_VOID) {
                if (!hv_store_ent(ret, HeSVKEY_force(he),
                SvREFCNT_inc(value), HeHASH(he))) {
                    SvREFCNT_dec(value);
                    croak("Cannot add new key to hash");
                }
            }

            continue;
        }

        /* find if missing parameter is mandatory */
        if (! no_validation()) {
            SV** temp;

            if (spec) {
                if ((temp = hv_fetch(spec, "optional", 8, 0))) {
                    SvGETMAGIC(*temp);

                    if (SvTRUE(*temp)) continue;
                }
            }
            else if (!SvTRUE(HeVAL(he))) {
                continue;
            }
            av_push(missing, SvREFCNT_inc(HeSVKEY_force(he)));
        }
    }
}


static IV
validate(HV* p, HV* specs, HV* options, HV* ret) {
    AV* missing;
    AV* unmentioned;
    HE* he;
    HE* he1;
    SV* hv;
    SV* hv1;
    IV ignore_case = 0;
    SV* strip_leading = NULL;
    IV allow_extra = 0;
    SV** temp;
    SV* normalize_func = NULL;
    AV* untaint_keys = (AV*) sv_2mortal((SV*) newAV());
    IV i;

    if ((temp = hv_fetch(options, "ignore_case", 11, 0))) {
        SvGETMAGIC(*temp);
        ignore_case = SvTRUE(*temp);
    }

    if ((temp = hv_fetch(options, "strip_leading", 13, 0))) {
        SvGETMAGIC(*temp);
        if (SvOK(*temp)) strip_leading = *temp;
    }

    if ((temp = hv_fetch(options, "normalize_keys", 14, 0))) {
        SvGETMAGIC(*temp);
        if(SvROK(*temp) && SvTYPE(SvRV(*temp)) == SVt_PVCV) {
            normalize_func = *temp;
        }
    }

    if (normalize_func || ignore_case || strip_leading) {
        p = normalize_hash_keys(p, normalize_func, strip_leading, ignore_case);
        specs = normalize_hash_keys(specs, normalize_func, strip_leading, ignore_case);
    }

    /* short-circuit everything else when no_validation is true */
    if (no_validation()) {
        if (GIMME_V != G_VOID) {
            while ((he = hv_iternext(p))) {
                hv = HeVAL(he);
                SvGETMAGIC(hv);

                /* put the parameter into return hash */
                if (!hv_store_ent(ret, HeSVKEY_force(he), SvREFCNT_inc(hv),
                HeHASH(he))) {
                    SvREFCNT_dec(hv);
                    croak("Cannot add new key to hash");
                }
            }
            apply_defaults(ret, p, specs, NULL);
        }

        return 1;
    }

    if ((temp = hv_fetch(options, "allow_extra", 11, 0))) {
        SvGETMAGIC(*temp);
        allow_extra = SvTRUE(*temp);
    }

    /* find extra parameters and validate good parameters */
    unmentioned = (AV*) sv_2mortal((SV*) newAV());

    hv_iterinit(p);
    while ((he = hv_iternext(p))) {
        hv = HeVAL(he);
        SvGETMAGIC(hv);

        /* put the parameter into return hash */
        if (GIMME_V != G_VOID) {
            if (!hv_store_ent(ret, HeSVKEY_force(he), SvREFCNT_inc(hv),
            HeHASH(he))) {
                SvREFCNT_dec(hv);
                croak("Cannot add new key to hash");
            }
        }

        /* check if this parameter is defined in spec and if it is
           then validate it using spec */
        he1 = hv_fetch_ent(specs, HeSVKEY_force(he), 0, HeHASH(he));
        if(he1) {
            hv1 = HeVAL(he1);
            if (SvROK(hv1) && SvTYPE(SvRV(hv1)) == SVt_PVHV) {
                SV* buffer;
                HV* spec;
                IV untaint = 0;

                spec = (HV*) SvRV(hv1);
                buffer = sv_2mortal(newSVpv("The '", 0));
                sv_catsv(buffer, HeSVKEY_force(he));
                sv_catpv(buffer, "' parameter (");
                cat_string_representation(buffer, hv);
                sv_catpv(buffer, ")");

                if (! validate_one_param(hv, (SV*) p, spec, buffer, options, &untaint))
                    return 0;

                /* The value stored here is meaningless, we're just tracking
                   keys to untaint later */
                if (untaint) {
                    av_push(untaint_keys, SvREFCNT_inc(HeSVKEY_force(he1)));
                }
            }
        }
        else if (! allow_extra) {
            av_push(unmentioned, SvREFCNT_inc(HeSVKEY_force(he)));
        }

        if (av_len(unmentioned) > -1) {
            SV* buffer;

            buffer = sv_2mortal(newSVpv("The following parameter", 0));
            if (av_len(unmentioned) != 0) {
                sv_catpv(buffer, "s were ");
            }
            else {
                sv_catpv(buffer, " was ");
            }
            sv_catpv(buffer, "passed in the call to ");
            sv_catsv(buffer, get_called(options));
            sv_catpv(buffer, " but ");
            if (av_len(unmentioned) != 0) {
                sv_catpv(buffer, "were ");
            }
            else {
                sv_catpv(buffer, "was ");
            }
            sv_catpv(buffer, "not listed in the validation options: ");
            for(i = 0; i <= av_len(unmentioned); i++) {
                sv_catsv(buffer, *av_fetch(unmentioned, i, 1));
                if (i < av_len(unmentioned)) {
                    sv_catpv(buffer, " ");
                }
            }
            sv_catpv(buffer, "\n");

            validation_failure(buffer, options);
        }
    }

    validate_named_depends(p, specs, options);

    /* find missing parameters */
    missing = (AV*) sv_2mortal((SV*) newAV());

    apply_defaults(ret, p, specs, missing);

    if (av_len(missing) > -1) {
        SV* buffer;

        buffer = sv_2mortal(newSVpv("Mandatory parameter", 0));
        if (av_len(missing) > 0) {
            sv_catpv(buffer, "s ");
        }
        else {
            sv_catpv(buffer, " ");
        }

        for(i = 0; i <= av_len(missing); i++) {
            sv_catpvf(buffer, "'%s'",
                SvPV_nolen(*av_fetch(missing, i, 0)));
            if (i < av_len(missing)) {
                sv_catpv(buffer, ", ");
            }
        }
        sv_catpv(buffer, " missing in call to ");
        sv_catsv(buffer, get_called(options));
        sv_catpv(buffer, "\n");

        validation_failure(buffer, options);
    }

    if (GIMME_V != G_VOID) {
        for (i = 0; i <= av_len(untaint_keys); i++) {
            SvTAINTED_off(HeVAL(hv_fetch_ent(p, *av_fetch(untaint_keys, i, 0), 0, 0)));
        }
    }

    return 1;
}


static SV*
validate_pos_failure(IV pnum, IV min, IV max, HV* options) {
    SV* buffer;
    SV** temp;
    IV allow_extra;

    if ((temp = hv_fetch(options, "allow_extra", 11, 0))) {
        SvGETMAGIC(*temp);
        allow_extra = SvTRUE(*temp);
    }
    else {
        allow_extra = 0;
    }

    buffer = sv_2mortal(newSViv(pnum + 1));
    if (pnum != 0) {
        sv_catpv(buffer, " parameters were passed to ");
    }
    else {
        sv_catpv(buffer, " parameter was passed to ");
    }
    sv_catsv(buffer, get_called(options));
    sv_catpv(buffer, " but ");
    if (!allow_extra) {
        if (min != max) {
            sv_catpvf(buffer, "%d - %d", (int) min + 1, (int) max + 1);
        }
        else {
            sv_catpvf(buffer, "%d", (int) max + 1);
        }
    }
    else {
        sv_catpvf(buffer, "at least %d", (int) min + 1);
    }
    if ((allow_extra ? min : max) != 0) {
        sv_catpv(buffer, " were expected\n");
    }
    else {
        sv_catpv(buffer, " was expected\n");
    }

    return buffer;
}


/* Given a single parameter spec and a corresponding complex spec form
   of it (which must be false if the spec is not complex), return true
   says that the parameter is options.  */
static bool
spec_says_optional(SV* spec, IV complex_spec) {
    SV** temp;

    if (complex_spec) {
        if ((temp = hv_fetch((HV*) SvRV(spec), "optional", 8, 0))) {
            SvGETMAGIC(*temp);
            if (!SvTRUE(*temp))
                return FALSE;
        }
        else {
            return FALSE;
        }
    }
    else {
        if (SvTRUE(spec)) {
            return FALSE;
        }
    }
    return TRUE;
}


static IV
validate_pos(AV* p, AV* specs, HV* options, AV* ret) {
    SV* buffer;
    SV* value;
    SV* spec = NULL;
    SV** temp;
    IV i;
    IV complex_spec = 0;
    IV allow_extra;
    /* Index of highest-indexed required parameter known so far, or -1
       if no required parameters are known yet.  */
    IV min = -1;
    AV* untaint_indexes = (AV*) sv_2mortal((SV*) newAV());

    if (no_validation()) {
        IV spec_count = av_len(specs);
        IV p_count    = av_len(p);
        IV max        = spec_count > p_count ? spec_count : p_count;

        if (GIMME_V == G_VOID) {
            return 1;
        }

        for (i = 0; i <= max; i++) {
            if (i <= spec_count) {
                spec = *av_fetch(specs, i, 1);
                SvGETMAGIC(spec);
                complex_spec = (SvROK(spec) && SvTYPE(SvRV(spec)) == SVt_PVHV);
            }

            if (i <= av_len(p)) {
                value = *av_fetch(p, i, 1);
                SvGETMAGIC(value);
                av_push(ret, SvREFCNT_inc(value));
            } else if (complex_spec &&
            (temp = hv_fetch((HV*) SvRV(spec), "default", 7, 0))) {
                SvGETMAGIC(*temp);
                av_push(ret, SvREFCNT_inc(*temp));
            }
        }
        return 1;
    }

    /* iterate through all parameters and validate them */
    for (i = 0; i <= av_len(specs); i++) {
        spec = *av_fetch(specs, i, 1);
        SvGETMAGIC(spec);
        complex_spec = (SvROK(spec) && SvTYPE(SvRV(spec)) == SVt_PVHV);

        /* Unless the current spec refers to an optional argument, update
           our notion of the index of the highest-idexed required
           parameter.  */
        if (! spec_says_optional(spec, complex_spec) ) {
            min = i;
        }

        if (i <= av_len(p)) {
            value = *av_fetch(p, i, 1);
            SvGETMAGIC(value);

            if (complex_spec) {
                IV untaint = 0;

                buffer = sv_2mortal(newSVpvf("Parameter #%d (", (int) i + 1));
                cat_string_representation(buffer, value);
                sv_catpv(buffer, ")");

                if (! validate_one_param(value, (SV*) p, (HV*) SvRV(spec),
                buffer, options, &untaint)) {
                    return 0;
                }

                if (untaint) {
                    av_push(untaint_indexes, newSViv(i));
                }
            }

            if (GIMME_V != G_VOID) {
                av_push(ret, SvREFCNT_inc(value));
            }

        } else if (complex_spec &&
        (temp = hv_fetch((HV*) SvRV(spec), "default", 7, 0))) {
            SvGETMAGIC(*temp);

            if (GIMME_V != G_VOID) {
                av_push(ret, SvREFCNT_inc(*temp));
            }

        }
        else {
            if (i == min) {
                /* We don't have as many arguments as the arg spec requires.  */
                SV* buffer;

                /* Look forward through remaining argument specifications to
                   find the last non-optional one, so we can correctly report the
                   number of arguments required.  */
                for (i++ ; i <= av_len(specs); i++) {
                    spec = *av_fetch(specs, i, 1);
                    SvGETMAGIC(spec);
                    complex_spec = (SvROK(spec) && SvTYPE(SvRV(spec)) == SVt_PVHV);
                    if (! spec_says_optional(spec, complex_spec)) {
                        min = i;
                    }
                    if (min != i)
                        break;
                }

                buffer = validate_pos_failure(av_len(p), min, av_len(specs), options);

                validation_failure(buffer, options);
            }
        }
    }

    validate_pos_depends(p, specs, options);

    /* test for extra parameters */
    if (av_len(p) > av_len(specs)) {
        if ((temp = hv_fetch(options, "allow_extra", 11, 0))) {
            SvGETMAGIC(*temp);
            allow_extra = SvTRUE(*temp);
        }
        else {
            allow_extra = 0;
        }
        if (allow_extra) {
            /* put all additional parameters into return array */
            if (GIMME_V != G_VOID) {
                for(i = av_len(specs) + 1; i <= av_len(p); i++) {
                    value = *av_fetch(p, i, 1);
                    SvGETMAGIC(value);

                    av_push(ret, SvREFCNT_inc(value));
                }
            }
        }
        else {
            SV* buffer;

            buffer = validate_pos_failure(av_len(p), min, av_len(specs), options);

            validation_failure(buffer, options);
        }
    }

    if (GIMME_V != G_VOID) {
        for (i = 0; i <= av_len(untaint_indexes); i++) {
            SvTAINTED_off(*av_fetch(p, SvIV(*av_fetch(untaint_indexes, i, 0)), 0));
        }
    }

    return 1;
}


MODULE = Params::Validate::XS    PACKAGE = Params::Validate::XS

void
validate(p, specs)
    SV* p
    SV* specs

    PROTOTYPE: \@$

    PPCODE:

    HV* ret = NULL;
    AV* pa;
    HV* ph;
    HV* options;

    if (no_validation() && GIMME_V == G_VOID) {
        XSRETURN(0);
    }

    SvGETMAGIC(p);
    if (! (SvROK(p) && SvTYPE(SvRV(p)) == SVt_PVAV)) {
        croak("Expecting array reference as first parameter");
    }

    SvGETMAGIC(specs);
    if (! (SvROK(specs) && SvTYPE(SvRV(specs)) == SVt_PVHV)) {
        croak("Expecting hash reference as second parameter");
    }

    pa = (AV*) SvRV(p);
    ph = NULL;
    if (av_len(pa) == 0) {
        /* we were called as validate( @_, ... ) where @_ has a
           single element, a hash reference */
        SV* value;

        value = *av_fetch(pa, 0, 1);
        SvGETMAGIC(value);
        if (SvROK(value) && SvTYPE(SvRV(value)) == SVt_PVHV) {
            ph = (HV*) SvRV(value);
        }
    }

    options = get_options(NULL);

    if (! ph) {
        ph = (HV*) sv_2mortal((SV*) newHV());

        if (! convert_array2hash(pa, options, ph) ) {
            XSRETURN(0);
        }
    }
    if (GIMME_V != G_VOID) {
        ret = (HV*) sv_2mortal((SV*) newHV());
    }
    if (! validate(ph, (HV*) SvRV(specs), options, ret)) {
        XSRETURN(0);
    }
    RETURN_HASH(ret);

void
validate_pos(p, ...)
SV* p

    PROTOTYPE: \@@

    PPCODE:

    AV* specs;
    AV* ret = NULL;
    IV i;

    if (no_validation() && GIMME_V == G_VOID) {
        XSRETURN(0);
    }


    SvGETMAGIC(p);
    if (!SvROK(p) || !(SvTYPE(SvRV(p)) == SVt_PVAV)) {
        croak("Expecting array reference as first parameter");
    }


    specs = (AV*) sv_2mortal((SV*) newAV());
    av_extend(specs, items);
    for(i = 1; i < items; i++) {
        if (!av_store(specs, i - 1, SvREFCNT_inc(ST(i)))) {
            SvREFCNT_dec(ST(i));
            croak("Cannot store value in array");
        }
    }


    if (GIMME_V != G_VOID) {
        ret = (AV*) sv_2mortal((SV*) newAV());
    }


    if (! validate_pos((AV*) SvRV(p), specs, get_options(NULL), ret)) {
        XSRETURN(0);
    }


    RETURN_ARRAY(ret);

void
validate_with(...)

    PPCODE:

    HV* p;
    SV* params;
    SV* spec;
    IV i;

    if (no_validation() && GIMME_V == G_VOID) XSRETURN(0);

    /* put input list into hash */
    p = (HV*) sv_2mortal((SV*) newHV());
    for(i = 0; i < items; i += 2) {
        SV* key;
        SV* value;

        key = ST(i);
        if (i + 1 < items) {
            value = ST(i + 1);
        }
        else {
            value = &PL_sv_undef;
        }
        if (! hv_store_ent(p, key, SvREFCNT_inc(value), 0)) {
            SvREFCNT_dec(value);
            croak("Cannot add new key to hash");
        }
    }

    params = *hv_fetch(p, "params", 6, 1);
    SvGETMAGIC(params);
    spec = *hv_fetch(p, "spec", 4, 1);
    SvGETMAGIC(spec);

    if (SvROK(spec) && SvTYPE(SvRV(spec)) == SVt_PVAV) {
        if (SvROK(params) && SvTYPE(SvRV(params)) == SVt_PVAV) {
            AV* ret = NULL;

            if (GIMME_V != G_VOID) {
                ret = (AV*) sv_2mortal((SV*) newAV());
            }

            if (! validate_pos((AV*) SvRV(params), (AV*) SvRV(spec),
            get_options(p), ret)) {
                XSRETURN(0);
            }

            RETURN_ARRAY(ret);
        }
        else {
            croak("Expecting array reference in 'params'");
        }
    }
    else if (SvROK(spec) && SvTYPE(SvRV(spec)) == SVt_PVHV) {
        HV* hv;
        HV* ret = NULL;
        HV* options;

        options = get_options(p);

        if (SvROK(params) && SvTYPE(SvRV(params)) == SVt_PVHV) {
            hv = (HV*) SvRV(params);
        }
        else if (SvROK(params) && SvTYPE(SvRV(params)) == SVt_PVAV) {
            I32 hv_set = 0;

            /* Check to see if we have a one element array
               containing a hash reference */
            if (av_len((AV*) SvRV(params)) == 0) {
                SV** first_elem;

                first_elem = av_fetch((AV*) SvRV(params), 0, 0);

                if (first_elem && SvROK(*first_elem) &&
                SvTYPE(SvRV(*first_elem)) == SVt_PVHV) {

                    hv = (HV*) SvRV(*first_elem);
                    hv_set = 1;
                }
            }

            if (! hv_set) {
                hv = (HV*) sv_2mortal((SV*) newHV());

                if (! convert_array2hash((AV*) SvRV(params), options, hv))
                    XSRETURN(0);
            }
        }
        else {
            croak("Expecting array or hash reference in 'params'");
        }

        if (GIMME_V != G_VOID) {
            ret = (HV*) sv_2mortal((SV*) newHV());
        }

        if (! validate(hv, (HV*) SvRV(spec), options, ret)) {
            XSRETURN(0);
        }

        RETURN_HASH(ret);
    }
    else {
        croak("Expecting array or hash reference in 'spec'");
    }
