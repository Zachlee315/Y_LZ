@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '외주공정 입고'
define root view entity zif_r_incoming as select from ztif_incoming

{
  key uuid       ,
  timekey        ,
  companycode    ,
  jobid          ,
  incomingdate   ,
  worker                ,
  operationnum          ,
  incomingqty           ,
  incomingprice         ,
  completeflag          ,
  mescreatetime         ,
  erpupdatetime         ,
  crud                  ,
  applyflag             ,
  eventcomment          ,
  trycnt                ,
  inspectionflag        ,
  document_num          ,
  if_code               ,
  if_msg                ,
  @Semantics.user.createdBy: true
  created_by            ,
  @Semantics.systemDateTime.createdAt: true
  created_at            ,
  @Semantics.user.lastChangedBy: true  
  last_changed_by       ,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at       ,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at 
}
