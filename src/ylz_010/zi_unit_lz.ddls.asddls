@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Unit CDS'
define view entity zi_unit_lz as select from I_UnitOfMeasure
{
    
 key UnitOfMeasure as UnitOfMeasure,
     UnitOfMeasureSAPCode as UnitOfMeasureSAPCode
     
}where UnitOfMeasure = 'KG' or 
       UnitOfMeasure = 'EA' or
       UnitOfMeasure = 'TON' 
