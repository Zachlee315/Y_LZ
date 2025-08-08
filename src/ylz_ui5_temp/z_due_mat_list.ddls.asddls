@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Due Date List'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_DUE_MAT_LIST as select from I_Batch
inner join Z_SUM_STOCK_01 on Z_SUM_STOCK_01.Material = I_Batch.Material
                                       and Z_SUM_STOCK_01.Plant = I_Batch.Plant
                                       and Z_SUM_STOCK_01.Batch = I_Batch.Batch
association [1..1] to I_Product on I_Product.Product = I_Batch.Material
association [1..1] to I_ProductDescription on I_ProductDescription.Product = I_Batch.Material
                                          and I_ProductDescription.Language = $session.system_language
association [1..1] to I_Plant on I_Plant.Plant = I_Batch.Plant
                              and I_Plant.Language = $session.system_language
association [1..1] to I_Supplier on I_Supplier.Supplier = I_Batch.Supplier  
{
  key I_Batch.Material,
  key I_Batch.Batch,
  key I_Batch.Plant,
  key I_Batch.Supplier,
  key I_Batch.BatchBySupplier,
  Z_SUM_STOCK_01.StorageLocation,
  @Semantics.quantity.unitOfMeasure: 'Baseunit'
  Z_SUM_STOCK_01.MatlWrhsStkQtyInMatlBaseUnit,
  I_Batch.MatlBatchIsInRstrcdUseStock,
  I_Batch.ShelfLifeExpirationDate,
  I_Batch.ManufactureDate,
  I_Product.BaseUnit,
  I_ProductDescription.ProductDescription,
  I_Plant.PlantName,
  I_Supplier.SupplierName,
  case when I_Batch.MatlBatchIsInRstrcdUseStock = 'X' then 'Restricted' else 'Unrestricted' end as BatchStatus,
  $session.system_date as curr_date   
}
where I_Batch.ShelfLifeExpirationDate is not initial
  and Z_SUM_STOCK_01.MatlWrhsStkQtyInMatlBaseUnit <> 0
