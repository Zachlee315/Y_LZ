@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'YTREE_C_0010_TP'

@Metadata.allowExtensions: true

@OData.hierarchy.recursiveHierarchy: [{ entity.name: 'YTREE_I_0030' }]


define view entity YTREE_C_0010_TP
  as projection on YTREE_R_0010_TP

{

      @UI.facet: [{
        purpose:       #STANDARD,
        type:          #IDENTIFICATION_REFERENCE,
        label:         'Menu (#RAPTreeview)',
        position:      10
      }]

      //      @UI.hidden: true
      @Consumption.valueHelpDefinition: [{entity: {name: 'YTREE_VH_FORMID', element: 'FormId' }}]
      @EndUserText.label : 'FormId'
  key FormId,
      //      @UI.hidden: true
      @EndUserText.label : 'MenuId'
  key MenuId,

      @UI: {
      lineItem:       [{
        position: 30,
              value: '_ParentMenu.MenuName',
        label: 'Name of Parent Menu'
      }],
      identification: [{
        position: 30,
              value: '_ParentMenu.MenuName',
        label: 'Name of Parent Menu'
      }]
      }
      @EndUserText.label : 'Parent MenuId'
      @Consumption.valueHelpDefinition: [
      {
      entity: { name: 'YTREE_VH_PARENTMENU', element: 'MenuId' },
      additionalBinding: [{ element: 'FormId', localElement: 'FormId', usage: #FILTER }]

      }
      ]
      ParentMenu,

      @UI: {
      lineItem:       [{ position: 10 }],
      identification: [{ position: 10 }]
      }
      @EndUserText.label : 'Name of Menu'
      MenuName,

      @UI: {
      lineItem:       [{ position: 20 }],
      identification: [{ position: 20 }]
      }
      @EndUserText.label : 'Seq. of Menu'
      MenuSeq,

      @EndUserText.label: '생성일'
      @UI.hidden: true
      CreateDate,

      @EndUserText.label: '생성시간'
      @UI.hidden: true
      CreateTime,

      @EndUserText.label: '생성자'
      @UI.hidden: true
      CreateUser,

      @EndUserText.label: '변경일'
      @UI.hidden: true
      UpdateDate,

      @EndUserText.label: '변경시간'
      @UI.hidden: true
      UpdateTime,

      @EndUserText.label: '변경자'
      @UI.hidden: true
      UpdateUser,
      /* Associations */
      _Form       : redirected to parent YTREE_C_0020_TP,
      _Menu       : redirected to YTREE_C_0010_TP,
      _ParentMenu : redirected to YTREE_C_0010_TP
}
