@ObjectModel.query.implementedBy: 'ABAP:ZCL_BOM_DISPLAY'
@EndUserText.label: 'BOM Extraction'
@UI.headerInfo: {typeName: 'Billofmaterial',typeNamePlural: ' BOM Mass Download'}
define root custom entity Z_BOM_EXTRACTION
  with parameters
    //    @Environment.systemField: #SYSTEM_DATE
    //    @ui.lineItem :[{label:'Material',position:10,importance: #HIGH }]
    P_KeyDate : vdm_v_key_date
{


      @UI.facet                    : [ {
       id                          : 'bomdata',
       purpose                     : #STANDARD,
       type                        : #IDENTIFICATION_REFERENCE,
       label                       : 'BOM List test',
       position                    : 10
      } ]

      @UI                          : { lineItem: [{ label:'MAterial', position: 10 }],
      identification               : [{ position: 10 }]}
      //      selectionField: [{ position: 10 }] }
      //      @Consumption.valueHelpDefinition: [{ entity: {name:'I_ProductPlantStdVH' ,element: 'Product' } }]
      //      @Consumption.valueHelpDefinition: [{additionalBinding: [{ element: 'Plant', localElement: 'Plant' }]}]
      //    @Consumption.filter:{mandatory: true}

  key Material                     : matnr;
      @UI.lineItem                 : [{label:'Plant', position:20 }]
      @UI.identification           : [{ position: 20 }]
      //      @UI.selectionField           : [{ position: 20 }]
      //      @Consumption.valueHelpDefinition: [{ entity: {name:'I_PlantStdVH' ,element: 'Plant' } }]
      //      @Consumption.filter          :{mandatory: true}
      Plant                        : werks_d;

      @UI.hidden                   : true
      BillOfMaterialCategory       : abap.char(1);
      @UI.hidden                   : true
      Billofmaterial               : abap.char(8);
      @UI.hidden                   : true
      Billofmaterialvariant        : abap.char(2);
      @UI.hidden                   : true
      Billofmaterialitemnodenumber : abap.numc(8);

      @UI.lineItem                 :[{label:'MaterialDesc', position:30 }]
      @UI.identification           : [{ position: 30 }]
      MaterialDesc                 : abap.char(40);
      @UI.lineItem                 :[{label:'ValidityStartdate',position:40,importance: #HIGH  }]
      @UI.identification           : [{ position: 40 }]
      Validitystartdate            : abap.dats;
      @UI.lineItem                 :[{label:'ValidityEnddate',position:50,importance: #HIGH }]
      @UI.identification           : [{ position: 50 }]
      Validityenddate              : abap.dats;
      @UI.lineItem                 :[{label:'Component',position:60,importance: #HIGH  }]
      @UI.identification           : [{ position: 60 }]
      Billofmaterialcomponent      : matnr;
      @UI.lineItem                 :[{label:'ComponentDesc',position:70,importance: #HIGH  }]
      @UI.identification           : [{ position: 70 }]
      //  BillofmaterialcomponentDesc  : abap.char(40);
      ComponentDescription         : abap.char(40);
      @UI.lineItem                 :[{label:'ItemCategory',position:80,importance: #HIGH  }]
      @UI.identification           : [{ position: 80 }]
      Billofmaterialitemcategory   : abap.char(1);
      @UI.lineItem                 :[{label:'ItemNumber ',position:90,importance: #HIGH  }]
      @UI.identification           : [{ position: 90 }]
      Billofmaterialitemnumber     : abap.char(4);
      @UI.lineItem                 :[{label:'ItemUnit',position:100,importance: #HIGH  }]
      @UI.identification           : [{ position: 100 }]
      //  @Semantics.unitOfMeasure
      Billofmaterialitemunit       : meins;
      //  Billofmaterialitemunit       : abap.unit(3);
      @UI.lineItem                 :[{label:'ItemQuantity',position:110,importance: #HIGH  }]
      @UI.identification           : [{ position: 110 }]
      //  @Semantics.quantity.unitOfMeasure : 'billofmaterialitemunit'
      Billofmaterialitemquantity   : abap.numc(13);
      //   Billofmaterialitemquantity   : abap.quan(13,3);
      @UI.hidden                   : true
      Identifierbomitem            : abap.char(8);

      @UI.lineItem                 :[{label:'Level',position:120,importance: #LOW  }]
      @UI.identification           : [{ position: 120 }]
      LevelCount                   : abap.numc(8);
      @UI.lineItem                 :[{label:'Path(Predecessor)',position:130,importance: #LOW  }]
      @UI.identification           : [{ position: 130 }]
      Path                         : abap.numc(8);

}
