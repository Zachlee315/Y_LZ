@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '출고전기 테스트'
define root view entity Z_OUTBOUND_001 as 
select from I_MaterialDocumentItem_2 as _Matdoc
inner join I_PurchaseOrderItemAPI01 as _Poitems
        on _Matdoc.PurchaseOrder = _Poitems.PurchaseOrder
       and _Matdoc.PurchaseOrderItem = _Poitems.PurchaseOrderItem
inner join I_PurchaseOrderAPI01 as _Poheader
        on _Matdoc.PurchaseOrder = _Poheader.PurchaseOrder
left outer join I_Supplier as _Supplier
        on _Matdoc.Supplier = _Supplier.Supplier        
left outer join I_ProductText as _MaterialText
        on _Matdoc.Material = _MaterialText.Product
       and _MaterialText.Language = $session.system_language
{
    key _Matdoc.MaterialDocument,
    key _Matdoc.MaterialDocumentItem,
    key _Matdoc.PurchaseOrder,
    key _Matdoc.PurchaseOrderItem,
        _Matdoc.Supplier,
        _Supplier.BusinessPartnerName1,
        _Poheader.PurchasingOrganization,
        _Poheader.PurchasingGroup,
        _Matdoc.Material,
        _MaterialText.ProductName,
        _Poitems.PurchaseOrderItemText,
        _Matdoc.Plant,
        _Matdoc.QuantityInEntryUnit,
        _Matdoc.EntryUnit,
        _Matdoc.PostingDate,
        _Matdoc.StorageLocation,
        _Poitems.RequirementTracking
        
    
}
where _Matdoc.GoodsMovementIsCancelled = ''
  and _Matdoc.GoodsMovementRefDocType = 'B'
  and _Matdoc.InventoryStockType = '01'
  and _Matdoc.GoodsMovementType = '101'
  and _Matdoc.StorageLocation = '431A'
//  and _Poitems.RequirementTracking <> ''
