@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'sales order detail'
define view entity zi_so_detail_lz as select from zlz_so_detail
association to parent zi_so_main_lz as _Header
 on $projection.Orderuuid = _Header.Orderuuid 

 {
  key detailuuid    as Detailuuid,
  key orderuuid         as Orderuuid,
  order_number      as SalesDocument,
  dlv_date          as DeliveredDate,
  model             as Model,
  leas_amt          as LeasAmount,
  currency          as CurrencyCode,
  pay_cycle         as PaymentCycle,
  contract          as Contract,
  factory           as Factory,
  color             as Color,
  axis              as Axis,
  tra_date          as TransactionDate,
  supplier          as Supplier,
  supplier_no       as SupplierNo,
  socket            as Socket,
  con_h_phone       as HomePhone,
  con_o_phone       as OfficePhone,
  edln              as Edln,
  twitter           as Twitter,
  haddr             as HomeAddr,
  maddr             as MailAddr,
  email             as Email,
  
  _Header
}
