@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ycds_select_test'

define root view entity ycds_select_test as select from
I_PurOrdAccountAssignmentAPI01 as _PurOrdAcc
inner join I_PurchaseOrderItemAPI01 as _PurOrdItem
   on _PurOrdItem.PurchaseOrder = _PurOrdAcc.PurchaseOrder
  and _PurOrdItem.PurchaseOrderItem = _PurOrdAcc.PurchaseOrderItem

{
   key _PurOrdItem.PurchaseOrder,
   key _PurOrdItem.PurchaseOrderItem,
       _PurOrdAcc.OrderID

}
where _PurOrdItem.PurchasingDocumentDeletionCode = ''
