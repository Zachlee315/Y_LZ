@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[GR]Consolidation Doctument type'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZLZ_DOCTYPEVH as select from I_CnsldtnDocumentTypeText_2

{
    
   key  ConsolidationDocumentType,
        ConsolidationDocumentTypeText
}where   Language = '3'
