@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '자재문서조회용'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMES_R_0027_01 as 
select from I_MaterialDocumentHeader_2 as _MatHeader
 inner join I_MaterialDocumentItem_2 as _MatItem
    on _MatItem.MaterialDocumentYear = _MatHeader.MaterialDocumentYear
   and _MatItem.MaterialDocument     = _MatHeader.MaterialDocument
{
    key _MatHeader.MaterialDocumentYear, 
    key _MatHeader.MaterialDocument,
    key _MatItem.MaterialDocumentItem,  
        _MatHeader.PostingDate,
        _MatItem.Plant, 
        _MatItem.StorageLocation, 
        _MatItem.Material, 
        _MatItem.EntryUnit
    
}
