# ======================================================================
#
# Copyright (C) 2000-2001 Paul Kulchenko (paulclinger@yahoo.com)
# SOAP::Lite is free software; you can redistribute it
# and/or modify it under the same terms as Perl itself.
#
# $Id: Lite.pm 131 2007-11-16 10:43:28Z kutterma $
#
# ======================================================================

package UDDI::Lite;

use 5.004;
use strict;
use vars qw($VERSION);

#$VERSION = sprintf("%d.%s", map {s/_//g; $_} q$Name$ =~ /-(\d+)_([\d_]+)/);
$VERSION = $SOAP::Lite::VERSION;

use SOAP::Lite;

# ======================================================================

package UDDI::Constants;

BEGIN
{
    use vars
      qw(%UDDI_VERSIONS $ELEMENTS $ATTRIBUTES $WITHNAMES $NAMESPACE $GENERIC);

    %UDDI_VERSIONS = (
        1 => {
            ELEMENTS => {
                address         => { addressLine     => 1 },
                authToken       => { authInfo        => 1 },
                bindingDetail   => { bindingTemplate => 1 },
                bindingTemplate => {
                    accessPoint           => 1,
                    description           => 1,
                    hostingRedirector     => 1,
                    tModelInstanceDetails => 1
                },
                bindingTemplates  => { bindingTemplate   => 1 },
                businessDetail    => { businessEntity    => 1 },
                businessDetailExt => { businessEntityExt => 1 },
                businessEntity    => {
                    businessServices => 1,
                    categoryBag      => 1,
                    contacts         => 1,
                    description      => 1,
                    discoveryURLs    => 1,
                    identifierBag    => 1,
                    name             => 1
                },
                businessEntityExt => { businessEntity => 1 },
                businessInfo      =>
                  { description => 1, name => 1, serviceInfos => 1 },
                businessInfos   => { businessInfo  => 1 },
                businessList    => { businessInfos => 1 },
                businessService => {
                    bindingTemplates => 1,
                    categoryBag      => 1,
                    description      => 1,
                    name             => 1
                },
                businessServices => { businessService => 1 },
                categoryBag      => { keyedReference  => 1 },
                contact          => {
                    address     => 1,
                    description => 1,
                    email       => 1,
                    personName  => 1,
                    phone       => 1
                },
                contacts          => { contact       => 1 },
                delete_binding    => { authInfo      => 1, bindingKey => 1 },
                delete_business   => { authInfo      => 1, businessKey => 1 },
                delete_service    => { authInfo      => 1, serviceKey => 1 },
                delete_tModel     => { authInfo      => 1, tModelKey => 1 },
                discard_authToken => { authInfo      => 1 },
                discoveryURLs     => { discoveryUrl  => 1 },
                dispositionReport => { result        => 1 },
                findQualifiers    => { findQualifier => 1 },
                find_binding => { findQualifiers => 1, tModelBag => 1 },
                find_business => {
                    categoryBag    => 1,
                    discoveryURLs  => 1,
                    findQualifiers => 1,
                    identifierBag  => 1,
                    name           => 1,
                    tModelBag      => 1
                },
                find_service => {
                    categoryBag    => 1,
                    findQualifiers => 1,
                    name           => 1,
                    tModelBag      => 1
                },
                find_tModel => {
                    categoryBag    => 1,
                    findQualifiers => 1,
                    identifierBag  => 1,
                    name           => 1
                },
                get_bindingDetail     => { bindingKey     => 1 },
                get_businessDetail    => { businessKey    => 1 },
                get_businessDetailExt => { businessKey    => 1 },
                get_registeredInfo    => { authInfo       => 1 },
                get_serviceDetail     => { serviceKey     => 1 },
                get_tModelDetail      => { tModelKey      => 1 },
                identifierBag         => { keyedReference => 1 },
                instanceDetails       =>
                  { description => 1, instanceParms => 1, overviewDoc => 1 },
                overviewDoc    => { description   => 1, overviewURL => 1 },
                registeredInfo => { businessInfos => 1, tModelInfos => 1 },
                result         => { errInfo       => 1 },
                save_binding  => { authInfo => 1, bindingTemplate => 1 },
                save_business =>
                  { authInfo => 1, businessEntity => 1, uploadRegister => 1 },
                save_service => { authInfo => 1, businessService => 1 },
                save_tModel  =>
                  { authInfo => 1, tModel => 1, uploadRegister => 1 },
                serviceDetail => { businessService => 1 },
                serviceInfo   => { name            => 1 },
                serviceInfos  => { serviceInfo     => 1 },
                serviceList   => { serviceInfos    => 1 },
                tModel        => {
                    categoryBag   => 1,
                    description   => 1,
                    identifierBag => 1,
                    name          => 1,
                    overviewDoc   => 1
                },
                tModelBag             => { tModelKey          => 1 },
                tModelDetail          => { tModel             => 1 },
                tModelInfo            => { name               => 1 },
                tModelInfos           => { tModelInfo         => 1 },
                tModelInstanceDetails => { tModelInstanceInfo => 1 },
                tModelInstanceInfo    =>
                  { description => 1, instanceDetails => 1 },
                tModelList              => { tModelInfos => 1 },
                validate_categorization => {
                    businessEntity  => 1,
                    businessService => 1,
                    keyValue        => 1,
                    tModel          => 1,
                    tModelKey       => 1
                }
            },    
            ATTRIBUTES => {
                accessPoint => { URLType  => 2 },
                address     => { sortCode => 2, useType => 2 },
                authToken   => { generic  => 2, operator => 2 },
                bindingDetail =>
                  { generic => 2, operator => 2, truncated => 2 },
                bindingTemplate => { bindingKey => 2, serviceKey => 2 },
                businessDetail  =>
                  { generic => 2, operator => 2, truncated => 2 },
                businessDetailExt =>
                  { generic => 2, operator => 2, truncated => 2 },
                businessEntity =>
                  { authorizedName => 2, businessKey => 2, operator => 2 },
                businessInfo => { businessKey => 2 },
                businessList =>
                  { generic => 2, operator => 2, truncated => 2 },
                businessService   => { businessKey => 2, serviceKey => 2 },
                contact           => { useType     => 2 },
                delete_binding    => { generic     => 2 },
                delete_business   => { generic     => 2 },
                delete_service    => { generic     => 2 },
                delete_tModel     => { generic     => 2 },
                description       => { lang        => 2 },
                discard_authToken => { generic     => 2 },
                discoveryUrl      => { useType     => 2 },
                dispositionReport =>
                  { generic => 2, operator => 2, truncated => 2 },
                email        => { useType => 2 },
                errInfo      => { errCode => 2 },
                find_binding =>
                  { generic => 2, maxRows => 2, serviceKey => 2 },
                find_business => { generic => 2, maxRows => 2 },
                find_service  =>
                  { businessKey => 2, generic => 2, maxRows => 2 },
                find_tModel   => { generic => 2, maxRows => 2 },
                get_authToken => { cred    => 2, generic => 2, userID => 2 },
                get_bindingDetail     => { generic    => 2 },
                get_businessDetail    => { generic    => 2 },
                get_businessDetailExt => { generic    => 2 },
                get_registeredInfo    => { generic    => 2 },
                get_serviceDetail     => { generic    => 2 },
                get_tModelDetail      => { generic    => 2 },
                hostingRedirector     => { bindingKey => 2 },
                keyedReference        =>
                  { keyName => 2, keyValue => 2, tModelKey => 2 },
                phone          => { useType => 2 },
                registeredInfo =>
                  { generic => 2, operator => 2, truncated => 2 },
                result        => { errno   => 2, keyType => 2 },
                save_binding  => { generic => 2 },
                save_business => { generic => 2 },
                save_service  => { generic => 2 },
                save_tModel   => { generic => 2 },
                serviceDetail =>
                  { generic => 2, operator => 2, truncated => 2 },
                serviceInfo => { businessKey => 2, serviceKey => 2 },
                serviceList =>
                  { generic => 2, operator => 2, truncated => 2 },
                tModel =>
                  { authorizedName => 2, operator => 2, tModelKey => 2 },
                tModelDetail =>
                  { generic => 2, operator => 2, truncated => 2 },
                tModelInfo         => { tModelKey => 2 },
                tModelInstanceInfo => { tModelKey => 2 },
                tModelList => { generic => 2, operator => 2, truncated => 2 },
                validate_categorization => { generic => 2 }
            },
            WITHNAMES => [
                qw/accessPoint address addressLine authInfo authToken bindingDetail bindingKey bindingTemplate bindingTemplates businessDetail businessDetailExt businessEntity businessEntityExt businessInfo businessInfos businessKey businessList businessService businessServices categoryBag contact contacts description discoveryURLs discoveryUrl dispositionReport email errInfo findQualifier findQualifiers hostingRedirector identifierBag instanceDetails instanceParms keyValue keyedReference name overviewDoc overviewURL personName phone registeredInfo result serviceDetail serviceInfo serviceInfos serviceKey serviceList tModel tModelBag tModelDetail tModelInfo tModelInfos tModelInstanceDetails tModelInstanceInfo tModelKey tModelList uploadRegister/
            ],
            NAMESPACE => 'urn:uddi-org:api',
            GENERIC   => '1.0',             # string, not number; '.0' matters
        },
        2 => {
            ELEMENTS => {
                add_publisherAssertions =>
                  { authInfo => 1, publisherAssertion => 1 },
                address             => { addressLine => 1 },
                assertionStatusItem => {
                    fromKey        => 1,
                    keyedReference => 1,
                    keysOwned      => 1,
                    toKey          => 1
                },
                assertionStatusReport => { assertionStatusItem => 1 },
                authToken             => { authInfo            => 1 },
                bindingDetail         => { bindingTemplate     => 1 },
                bindingTemplate       => {
                    accessPoint           => 1,
                    description           => 1,
                    hostingRedirector     => 1,
                    tModelInstanceDetails => 1
                },
                bindingTemplates  => { bindingTemplate   => 1 },
                businessDetail    => { businessEntity    => 1 },
                businessDetailExt => { businessEntityExt => 1 },
                businessEntity    => {
                    businessServices => 1,
                    categoryBag      => 1,
                    contacts         => 1,
                    description      => 1,
                    discoveryURLs    => 1,
                    identifierBag    => 1,
                    name             => 1
                },
                businessEntityExt => { businessEntity => 1 },
                businessInfo      =>
                  { description => 1, name => 1, serviceInfos => 1 },
                businessInfos   => { businessInfo  => 1 },
                businessList    => { businessInfos => 1 },
                businessService => {
                    bindingTemplates => 1,
                    categoryBag      => 1,
                    description      => 1,
                    name             => 1
                },
                businessServices => { businessService => 1 },
                categoryBag      => { keyedReference  => 1 },
                contact          => {
                    address     => 1,
                    description => 1,
                    email       => 1,
                    personName  => 1,
                    phone       => 1
                },
                contacts        => { contact  => 1 },
                delete_binding  => { authInfo => 1, bindingKey => 1 },
                delete_business => { authInfo => 1, businessKey => 1 },
                delete_publisherAssertions =>
                  { authInfo => 1, publisherAssertion => 1 },
                delete_service    => { authInfo       => 1, serviceKey => 1 },
                delete_tModel     => { authInfo       => 1, tModelKey  => 1 },
                discard_authToken => { authInfo       => 1 },
                discoveryURLs     => { discoveryURL   => 1 },
                dispositionReport => { result         => 1 },
                findQualifiers    => { findQualifier  => 1 },
                find_binding      => { findQualifiers => 1, tModelBag  => 1 },
                find_business     => {
                    categoryBag    => 1,
                    discoveryURLs  => 1,
                    findQualifiers => 1,
                    identifierBag  => 1,
                    name           => 1,
                    tModelBag      => 1
                },
                find_relatedBusinesses => {
                    businessKey    => 1,
                    findQualifiers => 1,
                    keyedReference => 1
                },
                find_service => {
                    categoryBag    => 1,
                    findQualifiers => 1,
                    name           => 1,
                    tModelBag      => 1
                },
                find_tModel => {
                    categoryBag    => 1,
                    findQualifiers => 1,
                    identifierBag  => 1,
                    name           => 1
                },
                get_assertionStatusReport =>
                  { authInfo => 1, completionStatus => 1 },
                get_bindingDetail       => { bindingKey     => 1 },
                get_businessDetail      => { businessKey    => 1 },
                get_businessDetailExt   => { businessKey    => 1 },
                get_publisherAssertions => { authInfo       => 1 },
                get_registeredInfo      => { authInfo       => 1 },
                get_serviceDetail       => { serviceKey     => 1 },
                get_tModelDetail        => { tModelKey      => 1 },
                identifierBag           => { keyedReference => 1 },
                instanceDetails         =>
                  { description => 1, instanceParms => 1, overviewDoc => 1 },
                keysOwned          => { fromKey     => 1, toKey       => 1 },
                overviewDoc        => { description => 1, overviewURL => 1 },
                publisherAssertion =>
                  { fromKey => 1, keyedReference => 1, toKey => 1 },
                publisherAssertions => { publisherAssertion => 1 },
                registeredInfo => { businessInfos => 1, tModelInfos => 1 },
                relatedBusinessInfo => {
                    businessKey         => 1,
                    description         => 1,
                    name                => 1,
                    sharedRelationships => 1
                },
                relatedBusinessInfos  => { relatedBusinessInfo => 1 },
                relatedBusinessesList =>
                  { businessKey => 1, relatedBusinessInfos => 1 },
                result       => { errInfo  => 1 },
                save_binding => { authInfo => 1, bindingTemplate => 1 },
                save_business =>
                  { authInfo => 1, businessEntity => 1, uploadRegister => 1 },
                save_service => { authInfo => 1, businessService => 1 },
                save_tModel  =>
                  { authInfo => 1, tModel => 1, uploadRegister => 1 },
                serviceDetail           => { businessService => 1 },
                serviceInfo             => { name            => 1 },
                serviceInfos            => { serviceInfo     => 1 },
                serviceList             => { serviceInfos    => 1 },
                set_publisherAssertions =>
                  { authInfo => 1, publisherAssertion => 1 },
                sharedRelationships => { keyedReference => 1 },
                tModel              => {
                    categoryBag   => 1,
                    description   => 1,
                    identifierBag => 1,
                    name          => 1,
                    overviewDoc   => 1
                },
                tModelBag             => { tModelKey          => 1 },
                tModelDetail          => { tModel             => 1 },
                tModelInfo            => { name               => 1 },
                tModelInfos           => { tModelInfo         => 1 },
                tModelInstanceDetails => { tModelInstanceInfo => 1 },
                tModelInstanceInfo    =>
                  { description => 1, instanceDetails => 1 },
                tModelList      => { tModelInfos => 1 },
                validate_values =>
                  { businessEntity => 1, businessService => 1, tModel => 1 }
            },
            ATTRIBUTES => {
                accessPoint             => { URLType => 2 },
                add_publisherAssertions => { generic => 2 },
                address => { sortCode => 2, tModelKey => 2, useType => 2 },
                addressLine => { keyName => 2, keyValue => 2 },
                assertionStatusItem => { completionStatus => 2 },
                assertionStatusReport => { generic => 2, operator => 2 },
                authToken     => { generic => 2, operator => 2 },
                bindingDetail =>
                  { generic => 2, operator => 2, truncated => 2 },
                bindingTemplate => { bindingKey => 2, serviceKey => 2 },
                businessDetail  =>
                  { generic => 2, operator => 2, truncated => 2 },
                businessDetailExt =>
                  { generic => 2, operator => 2, truncated => 2 },
                businessEntity =>
                  { authorizedName => 2, businessKey => 2, operator => 2 },
                businessInfo => { businessKey => 2 },
                businessList =>
                  { generic => 2, operator => 2, truncated => 2 },
                businessService => { businessKey => 2, serviceKey => 2 },
                contact         => { useType     => 2 },
                delete_binding  => { generic     => 2 },
                delete_business => { generic     => 2 },
                delete_publisherAssertions => { generic => 2 },
                delete_service             => { generic => 2 },
                delete_tModel              => { generic => 2 },
                description                => { lang    => 2 },
                discard_authToken          => { generic => 2 },
                discoveryURL               => { useType => 2 },
                dispositionReport          =>
                  { generic => 2, operator => 2, truncated => 2 },
                email        => { useType => 2 },
                errInfo      => { errCode => 2 },
                find_binding =>
                  { generic => 2, maxRows => 2, serviceKey => 2 },
                find_business          => { generic => 2, maxRows => 2 },
                find_relatedBusinesses => { generic => 2, maxRows => 2 },
                find_service           =>
                  { businessKey => 2, generic => 2, maxRows => 2 },
                find_tModel               => { generic => 2, maxRows => 2 },
                get_assertionStatusReport => { generic => 2 },
                get_authToken => { cred => 2, generic => 2, userID => 2 },
                get_bindingDetail       => { generic    => 2 },
                get_businessDetail      => { generic    => 2 },
                get_businessDetailExt   => { generic    => 2 },
                get_publisherAssertions => { generic    => 2 },
                get_registeredInfo      => { generic    => 2 },
                get_serviceDetail       => { generic    => 2 },
                get_tModelDetail        => { generic    => 2 },
                hostingRedirector       => { bindingKey => 2 },
                keyedReference          =>
                  { keyName => 2, keyValue => 2, tModelKey => 2 },
                name                => { lang    => 2 },
                phone               => { useType => 2 },
                publisherAssertions =>
                  { authorizedName => 2, generic => 2, operator => 2 },
                registeredInfo =>
                  { generic => 2, operator => 2, truncated => 2 },
                relatedBusinessesList =>
                  { generic => 2, operator => 2, truncated => 2 },
                result        => { errno   => 2, keyType => 2 },
                save_binding  => { generic => 2 },
                save_business => { generic => 2 },
                save_service  => { generic => 2 },
                save_tModel   => { generic => 2 },
                serviceDetail =>
                  { generic => 2, operator => 2, truncated => 2 },
                serviceInfo => { businessKey => 2, serviceKey => 2 },
                serviceList =>
                  { generic => 2, operator => 2, truncated => 2 },
                set_publisherAssertions => { generic   => 2 },
                sharedRelationships     => { direction => 2 },
                tModel                  =>
                  { authorizedName => 2, operator => 2, tModelKey => 2 },
                tModelDetail =>
                  { generic => 2, operator => 2, truncated => 2 },
                tModelInfo         => { tModelKey => 2 },
                tModelInstanceInfo => { tModelKey => 2 },
                tModelList => { generic => 2, operator => 2, truncated => 2 },
                validate_values => { generic => 2 }
            },
            WITHNAMES => [
                qw/accessPoint address addressLine assertionStatusItem assertionStatusReport authInfo authToken bindingDetail bindingKey bindingTemplate bindingTemplates businessDetail businessDetailExt businessEntity businessEntityExt businessInfo businessInfos businessKey businessList businessService businessServices categoryBag completionStatus contact contacts description discoveryURL discoveryURLs dispositionReport email errInfo findQualifier findQualifiers fromKey hostingRedirector identifierBag instanceDetails instanceParms keyedReference keysOwned name overviewDoc overviewURL personName phone publisherAssertion publisherAssertions registeredInfo relatedBusinessInfo relatedBusinessInfos relatedBusinessesList result serviceDetail serviceInfo serviceInfos serviceKey serviceList sharedRelationships tModel tModelBag tModelDetail tModelInfo tModelInfos tModelInstanceDetails tModelInstanceInfo tModelKey tModelList toKey uploadRegister/
            ],
            NAMESPACE => 'urn:uddi-org:api_v2',
            GENERIC   => '2.0',
        },
        3 => {
            ELEMENTS => {
                add_publisherAssertions =>
                  { authInfo => 1, publisherAssertion => 1 },
                address             => { addressLine => 1 },
                assertionStatusItem => {
                    fromKey        => 1,
                    keyedReference => 1,
                    keysOwned      => 1,
                    toKey          => 1
                },
                assertionStatusReport => { assertionStatusItem => 1 },
                authToken             => { authInfo            => 1 },
                bindingDetail         =>
                  { bindingTemplate => 1, listDescription => 1 },
                bindingTemplate => {
                    accessPoint           => 1,
                    categoryBag           => 1,
                    description           => 1,
                    Signature             => 1,
                    hostingRedirector     => 1,
                    tModelInstanceDetails => 1
                },
                bindingTemplates => { bindingTemplate => 1 },
                businessDetail   => { businessEntity  => 1 },
                businessEntity   => {
                    businessServices => 1,
                    categoryBag      => 1,
                    contacts         => 1,
                    description      => 1,
                    discoveryURLs    => 1,
                    Signature        => 1,
                    identifierBag    => 1,
                    name             => 1
                },
                businessInfo =>
                  { description => 1, name => 1, serviceInfos => 1 },
                businessInfos => { businessInfo  => 1 },
                businessList  => { businessInfos => 1, listDescription => 1 },
                businessService => {
                    bindingTemplates => 1,
                    categoryBag      => 1,
                    description      => 1,
                    Signature        => 1,
                    name             => 1
                },
                businessServices => { businessService => 1 },
                categoryBag      => {
                    keyedReference      => 1,
                    keyedReferenceGroup => 1,
                    keyedReferenceGroup => 1
                },
                contact => {
                    address     => 1,
                    description => 1,
                    email       => 1,
                    personName  => 1,
                    phone       => 1
                },
                contacts        => { contact  => 1 },
                delete_binding  => { authInfo => 1, bindingKey => 1 },
                delete_business => { authInfo => 1, businessKey => 1 },
                delete_publisherAssertions =>
                  { authInfo => 1, publisherAssertion => 1 },
                delete_service    => { authInfo      => 1, serviceKey => 1 },
                delete_tModel     => { authInfo      => 1, tModelKey  => 1 },
                discard_authToken => { authInfo      => 1 },
                discoveryURLs     => { discoveryURL  => 1 },
                dispositionReport => { result        => 1 },
                findQualifiers    => { findQualifier => 1 },
                find_binding      => {
                    authInfo       => 1,
                    categoryBag    => 1,
                    findQualifiers => 1,
                    find_tModel    => 1,
                    tModelBag      => 1
                },
                find_business => {
                    authInfo               => 1,
                    categoryBag            => 1,
                    discoveryURLs          => 1,
                    findQualifiers         => 1,
                    find_relatedBusinesses => 1,
                    find_tModel            => 1,
                    identifierBag          => 1,
                    name                   => 1,
                    tModelBag              => 1
                },
                find_relatedBusinesses => {
                    authInfo       => 1,
                    businessKey    => 1,
                    findQualifiers => 1,
                    fromKey        => 1,
                    keyedReference => 1,
                    toKey          => 1
                },
                find_service => {
                    authInfo       => 1,
                    categoryBag    => 1,
                    findQualifiers => 1,
                    find_tModel    => 1,
                    name           => 1,
                    tModelBag      => 1
                },
                find_tModel => {
                    authInfo       => 1,
                    categoryBag    => 1,
                    findQualifiers => 1,
                    identifierBag  => 1,
                    name           => 1
                },
                get_assertionStatusReport =>
                  { authInfo => 1, completionStatus => 1 },
                get_bindingDetail   => { authInfo => 1, bindingKey  => 1 },
                get_businessDetail  => { authInfo => 1, businessKey => 1 },
                get_operationalInfo => { authInfo => 1, entityKey   => 1 },
                get_publisherAssertions => { authInfo => 1 },
                get_registeredInfo      => { authInfo => 1 },
                get_serviceDetail       => { authInfo => 1, serviceKey => 1 },
                get_tModelDetail        => { authInfo => 1, tModelKey => 1 },
                identifierBag   => { keyedReference => 1 },
                instanceDetails => {
                    description   => 1,
                    instanceParms => 1,
                    instanceParms => 1,
                    overviewDoc   => 1
                },
                keyedReferenceGroup => { keyedReference => 1 },
                keysOwned => { fromKey => 1, toKey => 1, toKey => 1 },
                listDescription =>
                  { actualCount => 1, includeCount => 1, listHead => 1 },
                operationalInfo => {
                    authorizedName            => 1,
                    created                   => 1,
                    modified                  => 1,
                    modifiedIncludingChildren => 1,
                    nodeID                    => 1
                },
                operationalInfos => { operationalInfo => 1 },
                overviewDoc      =>
                  { description => 1, overviewURL => 1, overviewURL => 1 },
                publisherAssertion => {
                    Signature      => 1,
                    fromKey        => 1,
                    keyedReference => 1,
                    toKey          => 1
                },
                publisherAssertions => { publisherAssertion => 1 },
                registeredInfo => { businessInfos => 1, tModelInfos => 1 },
                relatedBusinessInfo => {
                    businessKey         => 1,
                    description         => 1,
                    name                => 1,
                    sharedRelationships => 1
                },
                relatedBusinessInfos  => { relatedBusinessInfo => 1 },
                relatedBusinessesList => {
                    businessKey          => 1,
                    listDescription      => 1,
                    relatedBusinessInfos => 1
                },
                result        => { errInfo  => 1 },
                save_binding  => { authInfo => 1, bindingTemplate => 1 },
                save_business => { authInfo => 1, businessEntity => 1 },
                save_service  => { authInfo => 1, businessService => 1 },
                save_tModel   => { authInfo => 1, tModel => 1 },
                serviceDetail => { businessService => 1 },
                serviceInfo   => { name            => 1 },
                serviceInfos  => { serviceInfo     => 1 },
                serviceList   => { listDescription => 1, serviceInfos => 1 },
                set_publisherAssertions =>
                  { authInfo => 1, publisherAssertion => 1 },
                sharedRelationships =>
                  { keyedReference => 1, publisherAssertion => 1 },
                tModel => {
                    categoryBag   => 1,
                    description   => 1,
                    Signature     => 1,
                    identifierBag => 1,
                    name          => 1,
                    overviewDoc   => 1
                },
                tModelBag    => { tModelKey   => 1 },
                tModelDetail => { tModel      => 1 },
                tModelInfo   => { description => 1, name => 1 },
                tModelInfos  => { tModelInfo  => 1 },
                tModelInstanceDetails => { tModelInstanceInfo => 1 },
                tModelInstanceInfo    =>
                  { description => 1, instanceDetails => 1 },
                tModelList => { listDescription => 1, tModelInfos => 1 }
            },
            ATTRIBUTES => {
                accessPoint => { useType => 2 },
                address     =>
                  { sortCode => 2, tModelKey => 2, useType => 2, lang => 2 },
                addressLine => { keyName => 2, keyValue => 2 },
                assertionStatusItem => { completionStatus => 2 },
                bindingDetail       => { truncated        => 2 },
                bindingTemplate => { bindingKey  => 2, serviceKey => 2 },
                businessDetail  => { truncated   => 2 },
                businessEntity  => { businessKey => 2 },
                businessInfo    => { businessKey => 2 },
                businessList    => { truncated   => 2 },
                businessService   => { businessKey => 2, serviceKey => 2 },
                contact           => { useType     => 2 },
                description       => { lang        => 2 },
                discoveryURL      => { useType     => 2 },
                dispositionReport => { truncated   => 2 },
                email             => { useType     => 2 },
                errInfo           => { errCode     => 2 },
                find_binding      =>
                  { listHead => 2, maxRows => 2, serviceKey => 2 },
                find_business          => { listHead => 2, maxRows => 2 },
                find_relatedBusinesses => { listHead => 2, maxRows => 2 },
                find_service           =>
                  { businessKey => 2, listHead => 2, maxRows => 2 },
                find_tModel        => { listHead      => 2, maxRows => 2 },
                get_authToken      => { cred          => 2, userID  => 2 },
                get_registeredInfo => { infoSelection => 2 },
                hostingRedirector  => { bindingKey    => 2 },
                keyedReference     =>
                  { keyName => 2, keyValue => 2, tModelKey => 2 },
                keyedReferenceGroup   => { tModelKey => 2 },
                name                  => { lang      => 2 },
                operationalInfo       => { entityKey => 2 },
                operationalInfos      => { truncated => 2 },
                overviewURL           => { useType   => 2 },
                personName            => { lang      => 2 },
                phone                 => { useType   => 2 },
                registeredInfo        => { truncated => 2 },
                relatedBusinessesList => { truncated => 2 },
                result                => { errno     => 2, keyType => 2 },
                serviceDetail         => { truncated => 2 },
                serviceInfo         => { businessKey => 2, serviceKey => 2 },
                serviceList         => { truncated   => 2 },
                sharedRelationships => { direction   => 2 },
                tModel             => { deleted   => 2, tModelKey => 2 },
                tModelDetail       => { truncated => 2 },
                tModelInfo         => { tModelKey => 2 },
                tModelInstanceInfo => { tModelKey => 2 },
                tModelList         => { truncated => 2 }
            },
            WITHNAMES => [
                qw/accessPoint actualCount address addressLine assertionStatusItem assertionStatusReport authToken authorizedName bindingDetail bindingKey bindingTemplate bindingTemplates businessDetail businessEntity businessInfo businessInfos businessKey businessList businessService businessServices categoryBag completionStatus contact contacts created description discoveryURL discoveryURLs dispositionReport email entityKey errInfo findQualifier findQualifiers fromKey hostingRedirector identifierBag includeCount infoSelection instanceDetails instanceParms keyedReference keyedReferenceGroup keysOwned listDescription listHead modified modifiedIncludingChildren name nodeID operationalInfo operationalInfos overviewDoc overviewURL personName phone publisherAssertion publisherAssertions registeredInfo relatedBusinessInfo relatedBusinessInfos relatedBusinessesList result serviceDetail serviceInfo serviceInfos serviceKey serviceList sharedRelationships tModel tModelBag tModelDetail tModelInfo tModelInfos tModelInstanceDetails tModelInstanceInfo tModelKey tModelList toKey/
            ],
            NAMESPACE => 'urn:uddi-org:api_v3',
            GENERIC   => undef,
        },
    );
}

# ======================================================================

package UDDI::SOM;

use vars qw(@ISA);
@ISA = qw(SOAP::SOM);

sub result
{    # result should point to immediate child of Body
    my $self   = shift;
    my $result = '/Envelope/Body/[1]';
    ref $self or return $result;
    defined $self->fault ? undef: $self->valueof($result);
}

# ======================================================================

package UDDI::Data;

use Carp ();

use vars qw(@ISA $AUTOLOAD);
@ISA = qw(SOAP::Data);

use overload fallback => 1, '""' => sub { shift->SUPER::value };

sub _init
{
    use vars qw(@EXPORT_OK %EXPORT_TAGS);
    @EXPORT_OK   = ( with => @$UDDI::Constants::WITHNAMES );
    %EXPORT_TAGS = ( all  => [@EXPORT_OK] );

    use vars qw($elements $attributes);
    $elements   = $UDDI::Constants::ELEMENTS;
    $attributes = $UDDI::Constants::ATTRIBUTES;
}

sub new
{
    my $self  = shift;
    my $class = ref($self) || $self;

    unless ( ref $self )
    {
        $self = $class->SUPER::new( @_, type => 'uddi' );
    }
    return $self;
}

sub with
{
    my $self = shift;
    $self =
      (      __PACKAGE__->can($self)
          || Carp::croak "Don't know what to do with '$self'" )->()
      unless ref $self && UNIVERSAL::isa( $self => __PACKAGE__ );

    my $name = $self->SUPER::name;
    my @values;
    while (@_)
    {
        my $data = shift;
        my ( $method, $attr, @value ) =
          UNIVERSAL::isa( $data => __PACKAGE__ )
          ? ( $data->SUPER::name, $data->SUPER::attr, $data->SUPER::value )
          : ( $data, {}, shift );
        exists $attributes->{$name}{$method}

          # attribute
          ? $self->$method(@value)

          # sub element
          : push(
            @values,
            (
                $self->can($method)
                  || Carp::croak "Don't know what to do with '$method'"
              )->(@value)->attr($attr)
          );
    }
    $self->set_value( [@values] );
}

sub _compileit
{
    no strict 'refs';
    my $method = shift;
    *$method = sub {

        # GENERATE element if no parameters: businessInfo()
        return __PACKAGE__->SUPER::name($method)
          if !@_ && exists $elements->{$method};

        die "Expected element (UDDI::Data) as parameter for $method()\n"
          if !ref $_[0] && exists $elements->{$method};

        # MAKE ELEMENT: name( [{attr => value},] 'old')
        if ( !UNIVERSAL::isa( $_[0] => __PACKAGE__ ) )
        {

            # get optional list of attributes as a first parameter
            my $attr = ref $_[0] eq 'HASH' ? shift @_ : {};
            return __PACKAGE__->SUPER::name( $method => @_ )->attr($attr);
        }

        my $name = $_[0]->SUPER::name;

        if ( defined $name )
        {

            # GET/SET ATTRIBUTE: businessInfo->businessKey
            return @_ > 1
              ? scalar( $_[0]->attr->{$method} = $_[1], $_[0] )    # SET
              : __PACKAGE__->SUPER::name(
                $method => $_[0]->attr->{$method} )                # GET
              if exists $attributes->{$name}
              && exists $attributes->{$name}{$method};

            # GET ELEMENT: businessInfos->businessInfo
            my @elems = grep {
                     ref $_
                  && UNIVERSAL::isa( $_ => __PACKAGE__ )
                  && $_->SUPER::name eq $method
            } map { ref $_ eq 'ARRAY' ? @$_ : $_ } $_[0]->value;
            return wantarray ? @elems : $elems[0]
              if exists $elements->{$name}
              && exists $elements->{$name}{$method};

            # MAKE ELEMENT: businessInfos(businessInfo('something'))
            return __PACKAGE__->SUPER::name( $method => @_ )
              if exists $elements->{$method}
              && exists $elements->{$method}{$name};
        }

        # handle UDDI::Data->method() calls for those SOAP::Data methods
        #  that conflict with UDDI methods, like name()
        if ( UNIVERSAL::can( $ISA[0] => $method ) )
        {
            my $pkg = shift @_;
            return eval "\$pkg->SUPER::$method(\@_)";
        }

        Carp::croak
          "Don't know what to do with '$method' and '$name' elements";
      }
}

sub BEGIN { _compileit('name') }

sub AUTOLOAD
{
    my $method = substr( $AUTOLOAD, rindex( $AUTOLOAD, '::' ) + 2 );
    return if $method eq 'DESTROY';

    _compileit($method);
    goto &$AUTOLOAD;
}

# ======================================================================

package UDDI::Serializer;

use vars qw(@ISA);
@ISA = qw(SOAP::Serializer);

sub new
{
    my $self  = shift;
    my $class = ref($self) || $self;

    unless ( ref $self )
    {
        $self = $class->SUPER::new(
            attr       => {},
            namespaces => {
                $SOAP::Constants::PREFIX_ENV
                ? ( $SOAP::Constants::NS_ENV => $SOAP::Constants::PREFIX_ENV )
                : (),
            },
            autotype => 0,
            @_,
        );
    }
    return $self;
}

use overload;    # protect from stringification in UDDI::Data
sub gen_id { overload::StrVal( $_[1] ) =~ /\((0x\w+)\)/o; $1 }

sub as_uddi
{
    my $self = shift;
    my ( $value, $name, $type, $attr ) = @_;
    return $self->encode_array( $value, $name, undef, $attr )
      if ref $value eq 'ARRAY';
    return $self->encode_hash( $value, $name, undef, $attr )
      if ref $value eq 'HASH';
    [
        $name,
        { %{ $attr || {} } },
        ref $value
        ? ( [ $self->encode_object($value) ], $self->gen_id($value) )
        : $value
    ];
}

sub encode_array
{
    my $self    = shift;
    my $encoded = $self->SUPER::encode_array(@_);
    delete $encoded->[1]
      ->{ SOAP::Utils::qualify( $self->encprefix => 'arrayType' ) };
    return $encoded;
}

# ======================================================================

package UDDI::Deserializer;

use vars qw(@ISA);
@ISA = qw(SOAP::Deserializer);

sub decode_value
{
    my $self = shift;
    my $ref  = shift;
    my ( $name, $attrs, $children, $value ) = @$ref;

    # base class knows what to do with elements in SOAP namespace
    return $self->SUPER::decode_value($ref)
      if exists $attrs->{href}
      || ( SOAP::Utils::splitlongname($name) )[0] eq $SOAP::Constants::NS_ENV;

    UDDI::Data->SOAP::Data::name($name)->attr($attrs)
      ->set_value( ref $children
          && @$children
        ? map( scalar( ( $self->decode_object($_) )[1] ), @$children )
        : $value );
}

sub deserialize
{
    bless shift->SUPER::deserialize(@_) => 'UDDI::SOM';
}

# ======================================================================

package UDDI::Lite;

use vars qw(@ISA $AUTOLOAD %EXPORT_TAGS);
use Exporter;
use Carp ();
@ISA = qw(SOAP::Lite Exporter);

BEGIN
{    # handle exports
    %EXPORT_TAGS = (
        'delete' => [
            qw/delete_binding delete_business delete_service
              delete_tModel delete_publisherAssertions/
        ],

        # ^-------------------- v2/3
        'auth' => [qw/get_authToken discard_authToken get_registeredInfo/],
        'save' => [
            qw/save_binding save_business save_service save_tModel
              add_publisherAssertions set_publisherAssertions/
        ],

        # ^----------------- v2/3 ^----------------- v2/3
        'validate' => [qw/validate_categorization validate_values/],

        # ^------------------- v1 ^------------v2
        'find' => [
            qw/find_binding find_business find_service find_tModel
              find_relatedBusinesses/
        ],

        # ^---------------- v2/3
        'get' => [
            qw/get_bindingDetail get_businessDetail get_businessDetailExt
              get_serviceDetail get_tModelDetail
              get_assertionStatusReport get_publisherAssertions/
        ],

        # ^------------------- v2/3 ^----------------- v2/3
    );
    $EXPORT_TAGS{inquiry} = [ map { @{ $EXPORT_TAGS{$_} } } qw/find get/ ];
    $EXPORT_TAGS{publish} =
      [ map { @{ $EXPORT_TAGS{$_} } } qw/delete auth save validate/ ];
    $EXPORT_TAGS{all} = [ map { @{ $EXPORT_TAGS{$_} } } qw/inquiry publish/ ];
    Exporter::export_ok_tags('all');
}

my $uddiversion;

sub uddiversion
{
    my $self    = shift;
    my $version = shift or return $uddiversion;

    die qq!Wrong UDDI version. Supported versions: @{[
        join ", ", keys %UDDI::Constants::UDDI_VERSIONS]}\n!
      unless defined $UDDI::Constants::UDDI_VERSIONS{$version};

    foreach ( keys %{ $UDDI::Constants::UDDI_VERSIONS{$version} } )
    {
        eval
"\$UDDI::Constants::$_ = \$UDDI::Constants::UDDI_VERSIONS{$version}->{$_}"
          or die;
    }

    UDDI::Data->_init;

    $uddiversion = $version;
    $self;
}

BEGIN { UDDI::Lite->uddiversion(1) }

sub new
{
    my $self  = shift;
    my $class = ref($self) || $self;

    unless ( ref $self )
    {
        $self = $class->SUPER::new(
            on_action  => sub { '""' },
            serializer => UDDI::Serializer->new, # register UDDI Serializer
            deserializer => UDDI::Deserializer->new,    # and Deserializer
            @_,
        );
    }
    return $self;
}

sub AUTOLOAD
{
    my $method = substr( $AUTOLOAD, rindex( $AUTOLOAD, '::' ) + 2 );
    return if $method eq 'DESTROY';

    no strict 'refs';
    *$AUTOLOAD = sub {
        return shift->call( $method => @_ )
          if UNIVERSAL::isa( $_[0] => __PACKAGE__ );
        my $som =
          (      __PACKAGE__->self
              || Carp::croak "Method call on unspecified object. Died" )
          ->call( $method => @_ );
        UNIVERSAL::isa( $som => 'SOAP::SOM' ) ? $som->result : $som;
    };
    goto &$AUTOLOAD;
}

sub call
{
    SOAP::Trace::trace('()');
    my $self   = shift;
    my $method = shift;
    my @parameters;
    my $attr = ref $_[0] eq 'HASH' ? shift() : {};
    while (@_)
    {
        push( @parameters,
            UNIVERSAL::isa( $_[0] => 'UDDI::Data' )
            ? shift
            : SOAP::Data->name( shift, shift ) );
    }
    my $message =
      SOAP::Data->name( $method => \SOAP::Data->value(@parameters) )->attr(
        {
            xmlns => $UDDI::Constants::NAMESPACE,
            (
                defined $UDDI::Constants::GENERIC
                ? ( generic => $UDDI::Constants::GENERIC )
                : ()
            ),
            %$attr
        }
      );

    my $serializer = $self->serializer;
    $serializer->on_nonserialized( $self->on_nonserialized );

    my $respond = $self->transport->send_receive(
        endpoint => $self->endpoint,
        action   => $self->on_action->( $self->uri ),
        envelope => $serializer->envelope( freeform => $message ),
        encoding => $serializer->encoding,
    );

    return $respond if $self->outputxml;

    unless ( $self->transport->is_success )
    {
        my $result = eval { $self->deserializer->deserialize($respond) }
          if $respond;
        return $self->on_fault->( $self, $@ ? $respond : $result ) || $result;
    }

    return unless $respond;    # nothing to do for one-ways
    return $self->deserializer->deserialize($respond);
}

# ======================================================================

1;

__END__

=head1 NAME

UDDI::Lite - Library for UDDI clients in Perl

=head1 SYNOPSIS

  use UDDI::Lite;
  print UDDI::Lite
    -> proxy('http://uddi.microsoft.com/inquire')
    -> find_business(name => 'old')
    -> result
    -> businessInfos->businessInfo->serviceInfos->serviceInfo->name;

The same code with autodispatch: 

  use UDDI::Lite +autodispatch => 
    proxy => 'http://uddi.microsoft.com/inquire'
  ;

  print find_business(name => 'old')
    -> businessInfos->businessInfo->serviceInfos->serviceInfo->name;                         

Or with importing:

  use UDDI::Lite 
    'UDDI::Lite' => [':inquiry'],
    proxy => 'http://uddi.microsoft.com/inquire'
  ;

  print find_business(name => 'old')
    -> businessInfos->businessInfo->serviceInfos->serviceInfo->name;                         

Publishing API:

  use UDDI::Lite 
    import => ['UDDI::Data'], 
    import => ['UDDI::Lite'],
    proxy => "https://some.server.com/endpoint_fot_publishing_API";

  my $auth = get_authToken({userID => 'USERID', cred => 'CRED'})->authInfo;
  my $busent = with businessEntity =>
    name("Contoso Manufacturing"), 
    description("We make components for business"),
    businessKey(''),
    businessServices with businessService =>
      name("Buy components"), 
      description("Bindings for buying our components"),
      serviceKey(''),
      bindingTemplates with bindingTemplate =>
        description("BASDA invoices over HTTP post"),
        accessPoint('http://www.contoso.com/buy.asp'),
        bindingKey(''),
        tModelInstanceDetails with tModelInstanceInfo =>
          description('some tModel'),
          tModelKey('UUID:C1ACF26D-9672-4404-9D70-39B756E62AB4')
  ;
  print save_business($auth, $busent)->businessEntity->businessKey;

=head1 DESCRIPTION

UDDI::Lite for Perl is a collection of Perl modules which provides a 
simple and lightweight interface to the Universal Description, Discovery
and Integration (UDDI) server.

To learn more about UDDI, visit http://www.uddi.org/.

The main features of the library are:

=over 3

=item *

Supports both inquiry and publishing API 

=item *

Builded on top of SOAP::Lite module, hence inherited syntax and features

=item *

Supports easy-to-use interface with convinient access to (sub)elements
and attributes

=item *

Supports HTTPS protocol

=item *

Supports SMTP protocol

=item *

Supports Basic/Digest server authentication

=back

=head1 OVERVIEW OF CLASSES AND PACKAGES

This table should give you a quick overview of the classes provided by the
library.

 UDDI::Lite.pm
 -- UDDI::Lite         -- Main class provides all logic
 -- UDDI::Data         -- Provides extensions for serialization architecture
 -- UDDI::Serializer   -- Serializes data structures to UDDI/SOAP package
 -- UDDI::Deserializer -- Deserializes result into objects
 -- UDDI::SOM          -- Provides access to deserialized object tree

=head2 UDDI::Lite

All methods that UDDI::Lite gives you access to can be used for both
setting and retrieving values. If you provide no parameters, you'll
get current value, and if you'll provide parameter(s), new value
will be assigned and method will return object (if not stated something
else). This is suitable for stacking these calls like:

  $uddi = UDDI::Lite
    -> on_debug(sub{print@_})
    -> proxy('http://uddi.microsoft.com/inquire')
  ;

Order is insignificant and you may call new() method first. If you
don't do it, UDDI::Lite will do it for you. However, new() method
gives you additional syntax:

  $uddi = new UDDI::Lite
    on_debug => sub {print@_},
    proxy => 'http://uddi.microsoft.com/inquire'
  ;

new() accepts hash with method names and values, and will call 
appropriate method with passed value.

Since new() is optional it won't be mentioned anymore.

Other available methods inherited from SOAP::Lite and most usable are:

=over 4

=item proxy()

Shortcut for C<transport-E<gt>proxy()>. This lets you specify an endpoint and 
also loads the required module at the same time. It is required for dispatching SOAP 
calls. The name of the module will be defined depending on the protocol 
specific for the endpoint. SOAP::Lite will do the rest work.

=item on_fault()

Lets you specify handler for on_fault event. Default behavior is die 
on transport error and does nothing on others. You can change this 
behavior globally or locally, for particular object.

=item on_debug()

Lets you specify handler for on_debug event. Default behavior is do 
nothing. Use +trace/+debug option for UDDI::Lite instead.

=back

To change to UDDI Version 2, use the following pragma:

  use UDDI::Lite uddiversion => 2;

=head2 UDDI::Data

You can use this class if you want to specify value and name for UDDI 
elements. 
For example, C<UDDI::Data-E<gt>name('businessInfo')-E<gt>value(123)> will 
be serialized to C<E<lt>businessInfoE<gt>123E<lt>/businessInfoE<gt>>, as 
well as C<UDDI::Data->name(businessInfo =E<gt> 123)>.

If you want to provide names for your parameters you can either specify

  find_business(name => 'old')

or do it with UDDI::Data:

  find_business(UDDI::Data->name(name => 'old'))

Later has some advantages: it'll work on any level, so you can do:

  find_business(UDDI::Data->name(name => UDDI::Data->name(subname => 'old')))

and also you can create arrays with this syntax:
                         
  find_business(UDDI::Data->name(name => 
    [UDDI::Data->name(subname1 => 'name1'), 
     UDDI::Data->name(subname2 => 'name2')]))

will be serialized into:

  <find_business xmlns="urn:uddi-org:api" generic="1.0">
    <name>
      <subname1>name1</subname1>
      <subname2>name2</subname2>
    </name>
  </find_business>

For standard elements more convinient syntax is available:

  find_business(
    findQualifiers(findQualifier('sortByNameAsc',
                                 'caseSensitiveMatch')),
    name('M')
  )

and
 
  find_business(
    findQualifiers([findQualifier('sortByNameAsc'), 
                    findQualifier('caseSensitiveMatch')]), 
    name('M')
  )

both will generate:

  <SOAP-ENV:Envelope 
    xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
    <SOAP-ENV:Body>
      <find_business xmlns="urn:uddi-org:api" generic="1.0">
        <findQualifiers>
          <findQualifier>sortByNameAsc</findQualifier>
          <findQualifier>caseSensitiveMatch</findQualifier>
        </findQualifiers>
        <name>M</name>
      </find_business>
    </SOAP-ENV:Body>
  </SOAP-ENV:Envelope>

You can use ANY valid combinations (according to "UDDI Programmer's 
API Specification"). If you try to generate something unusual, like 
C<name(name('myname'))>, you'll get:

  Don't know what to do with 'name' and 'name' elements ....

If you REALLY need to do it, use C<UDDI::Data> syntax described above.

As special case you can pass hash as the first parameter of method
call and values of this hash will be added as attributes to top element:

  find_business({maxRows => 10}, UDDI::Data->name(name => old))

gives you

  <find_business xmlns="urn:uddi-org:api" generic="1.0" maxRows="10">
    ....
  </find_business>

You can also pass back parameters exactly as you get it from method call
(like you probably want to do with authInfo).

You can get access to attributes and elements through the same interface:

  my $list = find_business(name => old);
  my $bis = $list->businessInfos;
  for ($bis->businessInfo) {
    my $s = $_->serviceInfos->serviceInfo;
    print $s->name,        # element
          $s->businessKey, # attribute
          "\n";
  }

To match advantages provided by C<with> operator available in other 
languages (like VB) we provide similar functionality that adds you 
flexibility:

    with findQualifiers => 
      findQualifier => 'sortByNameAsc',
      findQualifier => 'caseSensitiveMatch'

is the same as: 

    with(findQualifiers => 
      findQualifier('sortByNameAsc'),
      findQualifier('caseSensitiveMatch'),
    )

and:

    findQualifiers->with( 
      findQualifier('sortByNameAsc'),
      findQualifier('caseSensitiveMatch'),
    )

will all generate the same code as mentioned above:

    findQualifiers(findQualifier('sortByNameAsc',
                                 'caseSensitiveMatch')),

Advantage of C<with> syntax is the you can specify both attributes and 
elements through the same interface. First argument is element where all 
other elements and attributes will be attached. Provided examples and 
tests cover different syntaxes.

=head2 AUTODISPATCHING

UDDI::Lite provides autodispatching feature that lets you create 
code that looks similar for local and remote access.

For example:

  use UDDI::Lite +autodispatch => 
    proxy => 'http://uddi.microsoft.com/inquire';

tells autodispatch all UDDI calls to 
'http://uddi.microsoft.com/inquire'. All subsequent calls can look 
like:

  find_business(name => 'old');
  find_business(UDDI::Data->name(name => 'old'));
  find_business(name('old'));

=head1 BUGS AND LIMITATIONS

=over 4

=item *

Interface is still subject to change.

=item *

Though HTTPS/SSL is supported you should specify it yourself (with 
C<proxy> or C<endpoint>) for publishing API calls.

=back

=head1 AVAILABILITY

For now UDDI::Lite is distributed as part of SOAP::Lite package.
You can download it from ( http://soaplite.com/ ) 
or from CPAN ( http://search.cpan.org/search?dist=SOAP-Lite ).  

=head1 SEE ALSO

L<SOAP::Lite> ( http://search.cpan.org/search?dist=SOAP-Lite )
L<UDDI> ( http://search.cpan.org/search?dist=UDDI )

=head1 COPYRIGHT

Copyright (C) 2000-2004 Paul Kulchenko. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Paul Kulchenko (paulclinger@yahoo.com)

=cut
