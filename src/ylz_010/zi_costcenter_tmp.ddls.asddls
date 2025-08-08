@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'get costcenter CDS'
define root view entity zi_costcenter_tmp as select from I_CostCenter as _Costcenter
left outer join I_CostCenterText as _CostcenterText on _CostcenterText.ControllingArea = _Costcenter.ControllingArea
                                and _CostcenterText.CostCenter      = _Costcenter.CostCenter
                                and _CostcenterText.ValidityEndDate = _Costcenter.ValidityEndDate
{
  key _Costcenter.ControllingArea,
  key _Costcenter.CostCenter,
  key _Costcenter.ValidityEndDate,
      _Costcenter.ValidityStartDate,
      _CostcenterText.CostCenterName,
      _CostcenterText.CostCenterDescription,
      _Costcenter.CompanyCode,
      _Costcenter.BusinessArea,
      _Costcenter.CostCenterCategory
}
