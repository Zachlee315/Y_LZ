
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'doc vendor'
define view entity zi_doc_vendor as select from ytdoc_vendor
association to parent zi_doc_header as _Header
    on $projection.Docuuid = _Header.Docuuid
        and $projection.Docseq = _Header.docseq
{ 
key vendoruuid as Vendoruuid,
key docseq as Docseq,
docuuid as Docuuid,
 glaccountlineitem             as Glaccountlineitem ,
   supplier                    as Vendor,
  glaccount                    as Glaccount,
  documentitemtext             as Itemtext,
  assignmentreference          as Assignmentreference ,
  reference1idbybusinesspartner as Reference1idbybusinesspartner,
  reference2idbybusinesspartner as Reference2idbybusinesspartner,
  reference3idbybusinesspartner as Reference3idbybusinesspartner,
  paymentterms                  as Paymentterms,
  paymentmethod                 as Paymentmethod ,
  businessplace                 as Businessplace ,
  housebank                     as Housebank   ,
  housebankaccount              as Housebankaccount ,
  taxcountry                    as Taxcountry,
  specialglcode                 as Specialglcode ,
  taxcode                       as Taxcode ,
  profitcenter                  as Profitcenter  ,
  currency                      as Currency,
  journalentryitemamount        as Journalentryitemamount,
  taxamount                     as Taxamount  ,
  taxbaseamount                 as Taxbaseamount  ,
  _Header
}
