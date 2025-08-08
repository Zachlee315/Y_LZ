@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'doc header'
define root view entity zi_doc_header as select from ytdoc_header as _Header

  composition [0..*] of zi_doc_items as _Item
  composition [0..*] of zi_doc_vendor as _Vendor
  composition [0..*] of zi_doc_tax as _Tax
  
{ 
  key docseq                   as Docseq,
  key docuuid                  as Docuuid,
  accountingdocument           as DocumentNumber,
  businesstransactiontype      as Businesstransactiontype,
  accountingdocumenttype       as Accountingdocumenttype ,
  ledgergroup                  as Ledgergroup ,
  documentreferenceid          as Documentreferenceid ,
  accountingdocumentheadertext as Headertext,
  createdbyuser                as Createduser,
  companycode                  as Companycode,
  documentdate                 as Documentdate ,
  postingdate                  as Postingdate ,
  taxreportingdate             as Taxreportingdate ,
  taxdeterminationdate         as Taxdeterminationdate,
  invoicereceiptdate           as Invoicereceiptdate,
  exchangeratedate             as Exchangeratedate,
  isnegativeposting            as Inegativeposting  ,
  postingfiscalperiod          as Postingfiscalperiod,
  reversalreferencedocumentkey as Reversalreferencedocumentkey,
  reversalreason               as Reversalreason,
  ifstatus                     as Ifstatus ,
  ifmsg                        as Ifmsg,
    _Item,
    _Vendor,
    _Tax
}
