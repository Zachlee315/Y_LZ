@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'YTREE_R_0020_TP'

define root view entity YTREE_R_0020_TP
  as select from YTREE_I_0020

  composition of exact one to many YTREE_R_0010_TP as _Menu

{
  key FormId,
      Cycle,
      CreateDate,
      CreateTime,
      CreateUser,
      UpdateDate,
      UpdateTime,
      UpdateUser,
      /* Associations */
      _Menu

}
