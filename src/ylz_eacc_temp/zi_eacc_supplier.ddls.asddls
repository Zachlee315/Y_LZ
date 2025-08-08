@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MD supplier'
define root view entity ZI_EACC_SUPPLIER
  as select from    I_SupplierCompany as _SupplierCompany
    left outer join I_GLAccountText as _GLtext on _SupplierCompany.ReconciliationAccount = _GLtext.GLAccount
    and _GLtext.Language = $session.system_language

  association [1..1] to I_Supplier as _Supplier on $projection.Supplier = _Supplier.Supplier
{

  key _SupplierCompany.Supplier              as Supplier,
  key _SupplierCompany.CompanyCode           as CompanyCode,
      _Supplier.SupplierName                 as SupplierName,
      _SupplierCompany.HouseBank             as HouseBank,
      _SupplierCompany.ReconciliationAccount as ReconciliationAccount,
      _Supplier.CityName                     as CityName,
      _Supplier.StreetName                   as StreetName,
      _Supplier.SortField                    as SortField,    //sortl           "추가정보
      _Supplier.TaxNumber1                   as TaxNumber1,   //stcd1           "주민등록번호
      _Supplier.TaxNumber2                   as TaxNumber2,   //stcd2           "사업자번호
      _Supplier.PhoneNumber1                 as PhoneNumber1, //telf1           "전화번호
      _Supplier.BusinessType                 as BusinessType, //j_1kftbus       "업종
      _Supplier.IndustryType                 as IndustryType  //j_1kftind       "업태
      
    
}
