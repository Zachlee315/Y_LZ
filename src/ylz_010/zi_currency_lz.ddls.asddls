@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Currency'
define root view entity ZI_CURRENCY_LZ as select from I_Currency {
    key Currency as Currency,
        CurrencyISOCode    as CurrencyISOcode
}where Currency = 'EUR' or 
       Currency = 'USD' or 
       Currency = 'KRW' or 
       Currency = 'CNY' 
