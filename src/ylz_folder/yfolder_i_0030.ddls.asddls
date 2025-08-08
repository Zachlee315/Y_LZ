@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Menu Hierarchy Node'

define hierarchy YFOLDER_I_0030
  with parameters
    P_FormId : abap.char(10)

  as parent child hierarchy(
    source YFOLDER_I_0010
       
    child to parent association _ParentMenu

    directory _Form filter by
      FormId = $parameters.P_FormId

    start where
      ParentMenu is initial
    siblings order by
      MenuName
  )
{
  key FormId,
  key MenuId,
      ParentMenu,
      MenuName,
      MenuSeq


}
