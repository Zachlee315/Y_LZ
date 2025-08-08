@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'doc tax'

define view entity zi_doc_tax as select from ytdoc_tax
association to parent zi_doc_header as _Header
    on $projection.Docuuid = _Header.Docuuid
        and $projection.Docseq = _Header.Docseq
{
  key taxuuid           as Taxuuid,
  key docseq as Docseq,
  docuuid               as Docuuid,
  glaccountlineitem             as Glaccountlineitem ,
  taxcode                       as Taxcode,
  taxitemclassification  as Taxitemclassification,
  conditiontype          as Conditiontype,
  currency                      as Currency,
  journalentryitemamount        as Journalentryitemamount,
  taxamount                     as Taxamount  ,
  taxbaseamount                 as Taxbaseamount  ,
  _Header
}
