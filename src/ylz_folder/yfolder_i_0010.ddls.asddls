@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FOLDER TEST'

@OData.hierarchy.recursiveHierarchy: [{ entity.name: 'YFOLDER_I_0030' }]

@UI: {
  headerInfo: {
    typeName: 'Menu in Form',
    typeNamePlural: 'Menu in Form',
    title.value: 'MenuName'
  },
  presentationVariant: [
    {
      sortOrder: [{ by: 'MenuName', direction: #ASC }],
      visualizations: [{type: #AS_LINEITEM}]
    }
  ]
  }

define root view entity YFOLDER_I_0010
  as select from yfoldert0010

  association         to one YFOLDER_I_0020 as _Form       on  $projection.FormId = _Form.FormId
  association of many to one YFOLDER_I_0010 as _ParentMenu on  $projection.FormId     = _ParentMenu.FormId
                                                           and $projection.ParentMenu = _ParentMenu.MenuId

{

      @UI.facet: [{
        purpose:       #STANDARD,
        type:          #IDENTIFICATION_REFERENCE,
        label:         'Menu (#RAPTreeview)',
        position:      10
      }]

      @UI.hidden: true
  key form_id     as FormId,
      @UI.hidden: true
  key menu_id     as MenuId,

      @UI: {
      lineItem:       [{
        position: 30,
        value: '_ParentMenu.MenuName',
        label: 'Parent Menu'
      }],
      identification: [{
        position: 30,
        value: '_ParentMenu.MenuName',
        label: 'Parent Menu'
      }]
      }
      @EndUserText.label : 'Parent Menu'
      parent_menu as ParentMenu,

      @UI: {
      lineItem:       [{ position: 10 }],
      identification: [{ position: 10 }]
      }
      @EndUserText.label : 'Name of Menu'
      menu_name   as MenuName,

      @UI: {
      lineItem:       [{ position: 20 }],
      identification: [{ position: 20 }]
      }
      @EndUserText.label : 'Seq. of Menu'
      menu_seq    as MenuSeq,
      _Form,
      _ParentMenu
}
