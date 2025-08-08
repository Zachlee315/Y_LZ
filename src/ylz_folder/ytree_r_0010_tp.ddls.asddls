@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'YTREE_R_0010_TP'

define view entity YTREE_R_0010_TP
  as select from YTREE_I_0010
  association         to parent YTREE_R_0020_TP as _Form       on  $projection.FormId = _Form.FormId

  association of many to one YTREE_R_0010_TP       as _ParentMenu on  $projection.FormId     = _ParentMenu.FormId
                                                               and $projection.ParentMenu = _ParentMenu.MenuId
  association of one  to many YTREE_R_0010_TP      as _Menu       on  $projection.FormId = _Menu.FormId
                                                               and $projection.MenuId = _Menu.ParentMenu
{

  key FormId,
  key MenuId,
      ParentMenu,
      MenuName,
      MenuSeq,
      CreateDate,
      CreateTime,
      CreateUser,
      UpdateDate,
      UpdateTime,
      UpdateUser,
      _Form,
      _ParentMenu,
      _Menu
}
