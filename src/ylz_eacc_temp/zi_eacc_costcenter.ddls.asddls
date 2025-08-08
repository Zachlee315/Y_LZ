@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MD CostCenter CDS'
define root view entity ZI_EACC_COSTCENTER as select from I_CostCenter as _Costcenter
left outer join I_CostCenterText as _CostcenterText on _CostcenterText.ControllingArea = _Costcenter.ControllingArea
                                and _CostcenterText.CostCenter      = _Costcenter.CostCenter
                                and _CostcenterText.ValidityEndDate = _Costcenter.ValidityEndDate
{
  key _Costcenter.ControllingArea,                //KOKRS
  key _Costcenter.CostCenter,                     //KOSTL
  key _Costcenter.ValidityEndDate,                
      _Costcenter.ValidityStartDate,
      _CostcenterText.CostCenterName,             //KTEXT
      _CostcenterText.CostCenterDescription,      //LTEXT
      _Costcenter.CompanyCode,                    //BUKRS
      _Costcenter.BusinessArea,                   //GSBER
      _Costcenter.CostCenterCategory              //KOSAR
}
