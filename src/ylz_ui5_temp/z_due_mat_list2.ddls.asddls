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
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view entity Z_DUE_MAT_LIST2 as select from Z_DUE_MAT_LIST
association [1..1] to I_StorageLocation on I_StorageLocation.StorageLocation = Z_DUE_MAT_LIST.StorageLocation
                                       and I_StorageLocation.Plant           = Z_DUE_MAT_LIST.Plant
{
  key Z_DUE_MAT_LIST.Material,
@Consumption.valueHelpDefinition: [{entity: {name: 'I_PlantStdVH', element: 'Plant' }}]
  key Z_DUE_MAT_LIST.Plant,
@Consumption.valueHelpDefinition: [{entity: {name: 'I_StorageLocation', element: 'StorageLocation' }}]
  key Z_DUE_MAT_LIST.StorageLocation,
@Consumption.valueHelpDefinition: [{entity: {name: 'I_BatchStdVH', element: 'Batch' }}]
  key Z_DUE_MAT_LIST.Batch,
  key Z_DUE_MAT_LIST.Supplier,

  Z_DUE_MAT_LIST.ProductDescription,
  Z_DUE_MAT_LIST.PlantName,
  I_StorageLocation.StorageLocationName,
  Z_DUE_MAT_LIST.BatchBySupplier,
  Z_DUE_MAT_LIST.SupplierName,
  @Semantics.quantity.unitOfMeasure: 'Baseunit'
  Z_DUE_MAT_LIST.MatlWrhsStkQtyInMatlBaseUnit,
  Z_DUE_MAT_LIST.BaseUnit,
  Z_DUE_MAT_LIST.ShelfLifeExpirationDate,
  Z_DUE_MAT_LIST.ManufactureDate,
  Z_DUE_MAT_LIST.BatchStatus,
  dats_days_between(Z_DUE_MAT_LIST.curr_date,Z_DUE_MAT_LIST.ShelfLifeExpirationDate) as remaining_days,

  case when dats_days_between(Z_DUE_MAT_LIST.curr_date,Z_DUE_MAT_LIST.ShelfLifeExpirationDate) between -10000 and 30 then 'Less then 1 month'
       when dats_days_between(Z_DUE_MAT_LIST.curr_date,Z_DUE_MAT_LIST.ShelfLifeExpirationDate) between 31 and 180 then '1 to 6 months'
       when dats_days_between(Z_DUE_MAT_LIST.curr_date,Z_DUE_MAT_LIST.ShelfLifeExpirationDate) between 181 and 9999 then 'over 6 months' end as due_range,
         
  case when dats_days_between(Z_DUE_MAT_LIST.curr_date,Z_DUE_MAT_LIST.ShelfLifeExpirationDate) between -10000 and 30 then '1'
       when dats_days_between(Z_DUE_MAT_LIST.curr_date,Z_DUE_MAT_LIST.ShelfLifeExpirationDate) between 31 and 180 then '2'
       when dats_days_between(Z_DUE_MAT_LIST.curr_date,Z_DUE_MAT_LIST.ShelfLifeExpirationDate) between 181 and 9999 then '3' end as Criticality
}
