@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'YTREE_R_0020'
@Metadata.ignorePropagatedAnnotations: true
define root view entity YTREE_R_0020
  as select from YTREE_I_0020

{
  key FormId,
      Cycle,
      /* Associations */
      _Menu

}
