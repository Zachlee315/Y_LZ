@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[GR]고정자산관련-기준정보 조회 추가거래'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZLZ_R_GRTDA5201
  as select from zlz_grtda02

{

  key uuid,
      @EndUserText.label: '연결단위'
      rbunit,
      @EndUserText.label: '파트너단위'
      rbuptr,
      @EndUserText.label: '회계연도'
      ryear,
      @EndUserText.label: '전기기간'
      poper,
      @EndUserText.label: '연결계정과목'
      ritclg,
      @EndUserText.label: '거래유형'
      ztrs_type,
      @EndUserText.label: '통화키'
      rhcur,
      @EndUserText.label: '거래코드'
      ztrs,
      @EndUserText.label: '거래명'
      ztrs_txt,
      @EndUserText.label: '변동유형'
      ztype_eve,
      @EndUserText.label: '변동일자'
      zdate_eve,
      @EndUserText.label: '당월 상각표함'
      zck_inclu,
      @EndUserText.label: '변동금액'
      @Semantics.amount.currencyCode : 'RHCUR'
      zamt_eve,
      @EndUserText.label: '거래적요'
      zeve_txt,
      @EndUserText.label: '상태'
      zstatus,
      @EndUserText.label: '작업상태'
      zworkstatus,
      @Semantics.systemDateTime.createdAt: true
      @EndUserText.label: 'Created At'
      created_at,
      @Semantics.user.createdBy: true
      @EndUserText.label: 'Created By'
      created_by,
      @Semantics.systemDateTime.lastChangedAt: true
      @EndUserText.label: 'Last Changed At'
      last_changed_at,
      @Semantics.user.lastChangedBy: true
      @EndUserText.label: 'Last Changed By'
      last_changed_by,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      @EndUserText.label: 'Local Last Changed At'
      local_last_changed_at
}
