
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'doc items'

define view entity zi_doc_items as select from ytdoc_items
association to parent zi_doc_header as _Header
    on $projection.Docuuid = _Header.Docuuid
    and $projection.Docseq = _Header.Docseq
{
  key itemuuid                  as Itemuuid,
  key docseq as Docseq,
  docuuid                       as Docuuid,
  glaccountlineitem             as Glaccountlineitem ,
  companycode                   as Companycode  ,
  glaccount                     as Glaccount,
  documentitemtext              as Documentitemtext ,
  reference1idbybusinesspartner as Reference1idbybusinesspartner,
  reference2idbybusinesspartner as Reference2idbybusinesspartner,
  reference3idbybusinesspartner as Reference3idbybusinesspartner,
  financialtransactiontype      as Financialtransactiontype ,
  taxcode                       as Taxcode,
  taxjurisdiction               as Taxjurisdiction ,
  taxcountry                    as Taxcountry ,
  plant                         as Plant,
  businessplace                 as Businessplace ,
  valuedate                     as Valuedate ,
  housebank                     as Housebank   ,
  housebankaccount              as Housebankaccount ,
  profitcenter                  as Profitcenter   ,
  partnerprofitcenter           as Partnerprofitcenter,
  segment                       as Segment ,
  partnersegment                as Partnersegment,
  costcenter                    as Costcenter,
  costctractivitytype           as Costctractivitytype,
  wbselement                    as Wbselement,
  masterfixedasset              as Masterfixedasset,
  fixedasset                    as Fixedasset,
  functionalarea                as Functionalarea,
  servicedocumenttype           as Servicedocumenttype,
  servicedocument               as Servicedocument,
  servicedocumentitem           as Servicedocumentitem,
  orderid                       as Orderid,
  currency                      as Currency,
  journalentryitemamount        as Journalentryitemamount,
  taxamount                     as Taxamount  ,
  taxbaseamount                 as Taxbaseamount  ,
  _Header
}
