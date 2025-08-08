@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'sales order header'
define root view entity zi_so_main_lz as select from zlz_so_main
composition [1] of zi_so_detail_lz as _Detail
composition [0..*] of zi_so_detail_products_lz as _Detailproducts
 {
    key orderuuid   as Orderuuid,
    order_number as SalesDocument,
    order_status as OrderStatus,
    change_at as ChangedOn,
    customer as Customer,
    customer_con as CustomerContact,
    quantity as Quantity,
    amount as Amount,
    unit  as UoM,
    currency as CurrencyCode,
    
    _Detail, 
    _Detailproducts
}
