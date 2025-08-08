@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '외주발주'
define root view entity zif_r_outsourcing as select from ztif_outsourcing

{
key uuid,
timekey,
companycode,
jobid,
orderdate,
worker,
operationnum,
orderqty,
subconstractorid,
orderprice,
duedate,
inspectionflag,
mescreatetime,
erpupdatetime,
crud,
applyflag,
eventcomment,
trycnt,
outsourcingline,
outsourcingrel,
outsourcingnum,
grouptimekey,
po_num,
if_code,
if_msg,
@Semantics.user.createdBy: true
created_by,
@Semantics.systemDateTime.createdAt: true
created_at,
@Semantics.user.lastChangedBy: true        
last_changed_by,
@Semantics.systemDateTime.lastChangedAt: true
last_changed_at,
@Semantics.systemDateTime.localInstanceLastChangedAt: true
local_last_changed_at
}
