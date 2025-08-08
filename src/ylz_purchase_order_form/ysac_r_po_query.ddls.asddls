@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root node'
@Metadata.ignorePropagatedAnnotations: true
define root view entity YSAC_R_PO_QUERY as select from I_PuRCHASEORDERAPI01
composition [1..1] of YSAC_I_PO_HEADER as _POheader
{
    
   key PurchaseOrder,
   _POheader
}
