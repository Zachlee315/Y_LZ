@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZRAP_I_REQ_C'
define root view entity zrap_c_req_c 
provider contract transactional_query
as projection on ZRAP_I_REQ_C
{   
    @UI.lineItem: [{ 
    type: #FOR_ACTION,      
    position: 0, 
    dataAction: 'create_pr',  
    label: 'Create Purchase Request' 
    },
    { 
    type: #FOR_ACTION,      
    position: 1, 
    dataAction: 'create_pr_00',  
    label: 'Create Purchase Request11' 
    }
    ]

    @UI.hidden: true
    key PurchaseUUid,
   
    @UI: { lineItem: [{ position: 10 }],
    identification: [{ position: 10 }],
    selectionField: [{ position: 10 }] }

    Purchaserequisition,
    @UI: { lineItem: [{ position: 20 }],
    identification: [{ position: 20 }] }    
    Purchaserequisitionitem,
    @UI: { lineItem: [{ position: 30 }],
    identification: [{ position: 30 }] }  
    Purchaserequisitiontype,
    @UI: { lineItem: [{ position: 40 }],
    identification: [{ position: 40 }] }  
    Material,
    @UI: { lineItem: [{ position: 50 }],
    identification: [{ position: 50 }] }  
    Plant,
    @UI: { lineItem: [{ position: 60 }],
    identification: [{ position: 60 }] }  
    Purchaserequisitionitemtext,
    @UI: { lineItem: [{ position: 70 }],
    identification: [{ position: 70 }] }  
    Accountassiqnmentcategory,
    @UI: { lineItem: [{ position: 80 }],
    identification: [{ position: 80 }] }  
    PurReqnpriceQuantity,
    @UI: { lineItem: [{ position: 90 }],
    identification: [{ position: 90 }] }  
    Requestedquantity,
    @UI: { lineItem: [{ position: 100 }],
    identification: [{ position: 100 }] }  
    Baseunit,
    @UI: { lineItem: [{ position: 110 }],
    identification: [{ position: 110 }] }  
    Purchaserequisitionprice,
    @UI: { lineItem: [{ position: 120 }],
    identification: [{ position: 120 }]}  
    Purreqnitemcurrency,
    @UI: { lineItem: [{ position: 130 }],
    identification: [{ position: 130 }]}      
    Materialgroup,
    @UI: { lineItem: [{ position: 140 }],
    identification: [{ position: 140 }]}  
    Purchasinggroup,
    @UI: { lineItem: [{ position: 150 }],
    identification: [{ position: 150 }]}  
    Purchasingorganization,
    @UI: { lineItem: [{ position: 160 }],
    identification: [{ position: 160 }]}  
    OverallStatus,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt
}
