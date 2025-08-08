@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'YTREE_I_0010'

////@OData.hierarchy.recursiveHierarchy: [{ entity.name: 'YTREE_I_0030' }]

////@UI: {
////  headerInfo: {
////    typeName: 'Menu in Form',
////    typeNamePlural: 'Menu in Form',
////    title.value: 'MenuName'
////  },
////  presentationVariant: [
////    {
////      sortOrder: [{ by: 'MenuName', direction: #ASC }],
////      visualizations: [{type: #AS_LINEITEM}]
////    }
////  ]
////  }

define root view entity YTREE_I_0010
  as select from yfoldert0010

  association of many to one YTREE_I_0020  as _Form       on  $projection.FormId = _Form.FormId
  association of many to one YTREE_I_0010  as _ParentMenu on  $projection.FormId     = _ParentMenu.FormId
                                                          and $projection.ParentMenu = _ParentMenu.MenuId
  association of many to many YTREE_I_0010 as _Menu       on  $projection.FormId = _Menu.FormId
                                                          and $projection.MenuId = _Menu.ParentMenu
{

////      @UI.facet: [{
////        purpose:       #STANDARD,
////        type:          #IDENTIFICATION_REFERENCE,
////        label:         'Menu (#RAPTreeview)',
////        position:      10
////      }]

//      @UI.hidden: true
  key form_id     as FormId,
//      @UI.hidden: true
  key menu_id     as MenuId,

//      @UI: {
//      lineItem:       [{
//        position: 30,
//        value: '_ParentMenu.MenuName',
//        label: 'Parent Menu'
//      }],
//      identification: [{
//        position: 30,
//        value: '_ParentMenu.MenuName',
//        label: 'Parent Menu'
//      }]
//      }
      @EndUserText.label : 'Parent Menu'
      parent_menu as ParentMenu,

//      @UI: {
//      lineItem:       [{ position: 10 }],
//      identification: [{ position: 10 }]
//      }
      @EndUserText.label : 'Name of Menu'
      menu_name   as MenuName,

//      @UI: {
//      lineItem:       [{ position: 20 }],
//      identification: [{ position: 20 }]
//      }
      @EndUserText.label : 'Seq. of Menu'
      menu_seq    as MenuSeq,

      @EndUserText.label: '생성일'
//      @UI.hidden: true
      cre_date    as CreateDate,

      @EndUserText.label: '생성시간'
//      @UI.hidden: true
      cre_time    as CreateTime,

      @EndUserText.label: '생성자'
//      @UI.hidden: true
      cre_user    as CreateUser,

      @EndUserText.label: '변경일'
//      @UI.hidden: true
      upd_date    as UpdateDate,

      @EndUserText.label: '변경시간'
//      @UI.hidden: true
      upd_time    as UpdateTime,

      @EndUserText.label: '변경자'
//      @UI.hidden: true
      upd_user    as UpdateUser,

      _Form,
      _ParentMenu,
      _Menu
}
