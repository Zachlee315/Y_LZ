@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'YTREE_VH_FORMID'

define view entity YTREE_VH_FORMID
  as select from yfoldert0020
{

      @UI.selectionField: [{ position: 10 }]
      @UI.lineItem: [{ position: 10, importance: #HIGH }]
  key form_id as FormId,
      @UI.lineItem: [{ position: 20, importance: #HIGH }]
  key cycle   as cycle


}
