@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MD GL ACCOUNT CDS'
define root view entity ZI_EACC_GLACC as select from I_GLAccountInCompanyCode  as _GLAccount             //SKB1
inner join I_GLAccountInChartOfAccounts as _GLCOA on _GLCOA.GLAccount = _GLAccount.GLAccount            //SKA1
inner join I_GLAccountText as _GLAccountText on _GLAccountText.GLAccount = _GLAccount.GLAccount         //SKAT
                                            and _GLAccountText.ChartOfAccounts =  _GLCOA.ChartOfAccounts
{
    
  key _GLAccountText.ChartOfAccounts,           //SKAT.KTOPL
  key _GLAccount.GLAccount,                     //SKB1.SAKNR
  key _GLAccountText.Language,                 
      _GLAccount.CompanyCode,                   //SKB1.BUKRS
      _GLAccountText.GLAccountName,             //SKAT.TXT20
      _GLAccountText.GLAccountLongName,         //SKAT.TXT50
      _GLAccount.ReconciliationAccountType,     //SKB1.MITKZ
      _GLCOA.GLAccountGroup,                    //SKA1.KTOKS
      _GLCOA.ProfitLossAccountType              //SKA1.GVTYP

}
where _GLAccountText.Language = $session.system_language
