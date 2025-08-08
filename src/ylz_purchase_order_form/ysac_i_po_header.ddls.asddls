@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Parent Node'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity YSAC_I_PO_HEADER as select from I_PurchaseOrderAPI01
composition [0..*] of YSAC_I_PO_ITEM as _POitem
association to parent YSAC_R_PO_QUERY as _Query on $projection.PurchaseOrder = _Query.PurchaseOrder
{
    key PurchaseOrder,
    PurchaseOrderType,
    CreationDate,
    PurchaseOrderDate,
    PaymentTerms,
    _Query,
    _POitem
}
