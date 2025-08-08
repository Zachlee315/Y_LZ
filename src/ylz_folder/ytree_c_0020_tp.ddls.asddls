@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'YTREE_C_0020_TP'

//// Search Term #PresentationVariant
//@UI.presentationVariant: [
//  {
//    qualifier: 'pvariant',
//    text: '(#PresentationVariant)',
//    maxItems: 5,
//    // Search Term #DefaultSort
//    sortOrder: [
//      {
//        by: 'FormId',
//        direction: #ASC
//      }
//    ],
//    visualizations: [{type: #AS_LINEITEM}]
//  }
//]
//
//// Search Term #SelectionVariant
//@UI.selectionVariant: [
//  {
//    qualifier: 'svariant',
//    text: 'Cycle(#SelectionVariant)',
//    filter: 'Cycle NE 0'
//  }
//]
//
//// Search Term #SelectionPresentationVariant
//@UI.selectionPresentationVariant: [
//  {
//    text: '(#SelectionPresentationVariant)',
//    presentationVariantQualifier: 'pvariant',
//    selectionVariantQualifier: 'svariant'
//  }
//]


define root view entity YTREE_C_0020_TP
  provider contract transactional_query
  as projection on YTREE_R_0020_TP

{
      // Search Term #RAPTreeviewSection
      @UI.facet: [ {
         purpose:       #STANDARD,
         position: 10,
         type:          #LINEITEM_REFERENCE,
         label:         'Menu of Form (#RAPTreeview)',
         targetElement: '_Menu'
       }]

//,{ type: #FOR_ACTION, dataAction: 'DeleteWithCheck', label: 'Delete' }
      @UI: {
      lineItem:       [{ position: 10 }],
      identification: [{ position: 10 }]
      }
      @EndUserText.label : 'FormID'
      @UI.selectionField: [{ position: 10}]
      @Consumption.valueHelpDefinition: [{entity: {name: 'YTREE_VH_FORMID', element: 'FormId' }}]
  key FormId,

      @UI: {
      lineItem:       [{ position: 20 }],
      identification: [{ position: 20 }]
      }
      @EndUserText.label : 'Form Cycle'
      Cycle,

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
      _Menu : redirected to composition child YTREE_C_0010_TP
}
