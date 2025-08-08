@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'sales order detail products'

define view entity zi_so_detail_products_lz as select from zlz_so_products
association to parent zi_so_main_lz as _Header
 on $projection.Orderuuid = _Header.Orderuuid 
 {
  key itemuuid     as Itemuuid,
  orderuuid        as Orderuuid,
  order_number     as SalesDocument,
  order_item       as ItemNumber,
  doc_number       as DocumentNo,
  company          as Company,
  contact          as Contact,
  post_date        as PostingDate,
  amount           as Amount,
  currency         as CurrencyCode,
  
 _Header
}
