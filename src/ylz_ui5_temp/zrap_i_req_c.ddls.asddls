@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Upload to Create PR'
define root view entity ZRAP_I_REQ_C 
as select from zrap_d_req_c as PurchaseCreate
{   
   
    key purchase_uuid as PurchaseUUid,
    @EndUserText.label: 'Purchase Requisition'
    purchaserequisition as Purchaserequisition,
    @EndUserText.label: 'Purchase Requisition Item'
    purchaserequisitionitem as Purchaserequisitionitem,
    purchaserequisitiontype as Purchaserequisitiontype,
    @EndUserText.label: 'Material'
    material as Material,
    @EndUserText.label: 'Plant'
    plant as Plant,
    @Semantics.text: true
    purchaserequisitionitemtext as Purchaserequisitionitemtext,
    accountassiqnmentcategory as Accountassiqnmentcategory,
    purreqnpricequantity as PurReqnpriceQuantity,
    @Semantics.quantity.unitOfMeasure: 'Baseunit'
    requestedquantity as Requestedquantity,
    @EndUserText.label: 'Baseunit'
    baseunit as Baseunit,
    @Semantics.amount.currencyCode: 'Purreqnitemcurrency'
    purchaserequisitionprice as Purchaserequisitionprice,
    @EndUserText.label: 'Currency'
    purreqnitemcurrency as Purreqnitemcurrency,
    materialgroup as Materialgroup,
    purchasinggroup as Purchasinggroup,
    purchasingorganization as Purchasingorganization,
    overall_status as OverallStatus,
    @Semantics.user.createdBy: true
    @EndUserText.label: 'Created By'
    created_by as CreatedBy,
    @Semantics.systemDateTime.createdAt: true
    @EndUserText.label: 'Created At'
    created_at as CreatedAt,
    @Semantics.user.lastChangedBy: true
    @EndUserText.label: 'Changed By'
    last_changed_by as LastChangedBy,
    @Semantics.systemDateTime.lastChangedAt: true
    @EndUserText.label: 'Changed At'
    last_changed_at as LastChangedAt

}
