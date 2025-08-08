@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: '[GR]고정자산관련-기준정보 조회Consumption'

@UI.headerInfo: { typeName: '기준정보 관리', typeNamePlural: '기준정보 관리', typeImageUrl: 'sap-icon://damaster' }

define root view entity ZLZ_C_GRTDA5200
  provider contract transactional_query
  as projection on ZLZ_R_GRTDA5200

{
      @UI.facet: [ { id: 'Master',
                     purpose: #STANDARD,
                     type: #IDENTIFICATION_REFERENCE,
                     label: 'MasterData',
                     position: 10 } ]
      @UI.hidden: true
  key uuid,

      @UI.identification:[ {position: 01} ]
      @UI.selectionField: [{ position: 10}]
      @Consumption: { valueHelpDefinition: [{ entity: { name: 'ZASGRV_CNSLDTNUNIT' , element: 'ConsolidationUnit' } } ],
      //                filter.mandatory: true

                      filter.selectionType: #SINGLE
               }
      rbunit,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZASGRV_CNSLDTNUNIT', element: 'ConsolidationUnit' } } ]
      @UI.identification: [ { position: 10 } ]
      @UI.lineItem: [ { position: 10 } ]
      rbuptr,

      @Consumption.filter: { mandatory: true, selectionType: #SINGLE }
      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_CnsldtnVersion', element: 'ConsolidationVersion' } } ]
      @UI.identification: [ { position: 11 } ]
      @UI.lineItem: [ { position: 11 } ]
      @UI.selectionField: [ { position: 11 } ]
      //            @Consumption.valueHelpDefinition: [{ entity: { name: 'ZASGRV_REVISION' , element: 'Revision' } } ]

      rvers,

      @Consumption.filter: { mandatory: true, selectionType: #SINGLE }
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZASGRV_RITCLG', element: 'Ritclg' } } ]
      @UI.identification: [ { position: 12 } ]
      @UI.lineItem: [ { position: 12 } ]
      @UI.selectionField: [ { position: 12 } ]
      ritclg,

      @Consumption.filter: { mandatory: true, selectionType: #SINGLE }
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZLZ_ZTRSVH', element: 'ztrs_type' } } ]
      @UI.identification: [ { position: 13 } ]
      @UI.lineItem: [ { position: 13 } ]
      @UI.selectionField: [ { position: 13 } ]
      ztrs_type,

      @UI.identification: [ { position: 20 } ]
      @UI.lineItem: [ { position: 20 } ]
      rhcur,

      @UI.identification: [ { position: 30 } ]
      @UI.lineItem: [ { position: 30 } ]
      ztrs,

      @UI.identification: [ { position: 40 } ]
      @UI.lineItem: [ { position: 40 } ]
      ztrs_txt,

      @UI.identification: [ { position: 50 } ]
      @UI.lineItem: [ { position: 50 } ]
      ztitem_fa,

      @UI.identification: [ { position: 60 } ]
      @UI.lineItem: [ { position: 60 } ]
      zusfl,

      @UI.identification: [ { position: 70 } ]
      @UI.lineItem: [ { position: 70 } ]
      zdate_trs,

      @UI.identification: [ { position: 80 } ]
      @UI.lineItem: [ { position: 80 } ]
      zdate_clo,

      @UI.identification: [ { position: 90 } ]
      @UI.lineItem: [ { position: 90 } ]
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZGRVCOA05', element: 'GLAccount' } } ]
      zritem_dep,

      @UI.identification: [ { position: 100 } ]
      @UI.lineItem: [ { position: 100 } ]
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZGRVCOA05', element: 'GLAccount' } } ]
      zritem_eli,

      @UI.identification: [ { position: 110 } ]
      @UI.lineItem: [ { position: 110 } ]
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZGRVCOA05', element: 'GLAccount' } } ]
      zritem_accum,

      @UI.identification: [ { position: 120 } ]
      @UI.lineItem: [ { position: 120 } ]
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZGRVCOA05', element: 'GLAccount' } } ]
      zritem_imp_dep,

      @UI.identification: [ { position: 130 } ]
      @UI.lineItem: [ { position: 130 } ]
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZGRVCOA05', element: 'GLAccount' } } ]
      zritem_def,

      @UI.identification: [ { position: 140 } ]
      @UI.lineItem: [ { position: 140 } ]
      zamt ,
      
      @UI.identification: [ { position: 150 } ]
      @UI.lineItem: [ { position: 150 } ]
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZLZ_DOCTYPEVH', element: 'ConsolidationDocumentType' } } ]
      docty,

      @UI.identification: [ { position: 160 } ]
      @UI.lineItem: [ { position: 160 } ]
      zstatus,

      @UI.identification: [ { position: 170 } ]
      @UI.lineItem: [ { position: 170 } ]
      zworkstatus,

      @UI.hidden: true
      created_at,

      @UI.hidden: true
      created_by,

      @UI.hidden: true
      last_changed_at,

      @UI.hidden: true
      last_changed_by,

      @UI.hidden: true
      local_last_changed_at
}
