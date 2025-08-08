@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Child Node'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity YSAC_I_PO_ITEM as select from I_PurchaseOrderItemAPI01
association to parent YSAC_I_PO_HEADER as _POheader
on $projection.PurchaseOrder = _POheader.PurchaseOrder
{
    key PurchaseOrder,
    key PurchaseOrderItem,
    Material,
    MaterialGroup,
    _POheader
}
