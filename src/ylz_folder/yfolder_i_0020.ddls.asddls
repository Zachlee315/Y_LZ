@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FOLDER ROOT'

define view entity YFOLDER_I_0020
  as select from yfoldert0020 
  
    // Search Term #RAPTreeview
  association of exact one to many YFOLDER_I_0010 as _Menu      on  $projection.FormId = _Menu.FormId 
  
{
  key form_id as FormId,
      cycle   as Cycle,
      
      _Menu
}
