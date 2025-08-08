@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'YTREE_C_0020'

define root view entity YTREE_C_0020
  provider contract transactional_query
  as projection on YTREE_R_0020
{
      // Search Term #RAPTreeviewSection
      @UI.facet: [ {
         purpose:       #STANDARD,
         position: 10,
         type:          #LINEITEM_REFERENCE,
         label:         'Menu of Form (#RAPTreeview)',
         targetElement: '_Menu'
       }]

      @UI: {
      lineItem:       [{ position: 10 }],
      identification: [{ position: 10 }]
      }
      @EndUserText.label : 'FormID'
  key FormId,

      @UI: {
      lineItem:       [{ position: 20 }],
      identification: [{ position: 20 }]
      }
      @EndUserText.label : 'Form Cycle'
      Cycle,
      /* Associations */
      _Menu
}
