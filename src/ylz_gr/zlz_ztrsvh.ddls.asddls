@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[GR]거래유형 도움말'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZLZ_ZTRSVH
  as select from zlz_t_ztrs

{
  @EndUserText.label: '거래유형'
  key ztrs_type,

  @EndUserText.label: '거래유형 명'
      ztrs_txt
}

