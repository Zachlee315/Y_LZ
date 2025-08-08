@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'YTREE_VH_PARENTMENU'
@Search.searchable: true

define view entity YTREE_VH_PARENTMENU
  as select from yfoldert0010
{
      @Search.defaultSearchElement: true 
      @UI.selectionField: [{ position: 10 }]
      @UI.lineItem: [{ position: 10, importance: #HIGH }]
  key form_id   as FormId,
      @UI.lineItem: [{ position: 20, importance: #HIGH }]
  key menu_id   as MenuId,
      @UI.lineItem: [{ position: 30, importance: #HIGH }]
      menu_name as ParentMenuName
}
where
  parent_menu is initial
