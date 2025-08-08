@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sum of Stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_SUM_STOCK_01 as select from I_MaterialStock_2
{
  key Material,
  key Plant,
  key StorageLocation,
  key Batch,
  key MaterialBaseUnit,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
  @Aggregation.default: #SUM
  sum( MatlWrhsStkQtyInMatlBaseUnit ) as MatlWrhsStkQtyInMatlBaseUnit
}
where InventoryStockType = '01'
group by Material, Plant, StorageLocation, Batch, MaterialBaseUnit
