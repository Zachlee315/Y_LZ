@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[GR]고정자산관련-기준정보 조회'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZLZ_R_GRTDA5200
  as select from zlz_grtda01

{
  key uuid,
      @EndUserText.label: '연결단위'
      rbunit,
      @EndUserText.label: '매출법인'
      rbuptr,
      @EndUserText.label: '연결계정과목'
      ritclg,
      @EndUserText.label: '거래유형'
      ztrs_type,
      @EndUserText.label: '연결버전'
      rvers,
      @EndUserText.label: '통화키'
      rhcur,
      @EndUserText.label: '거래코드'
      ztrs,
      @EndUserText.label: '거래명'
      ztrs_txt,
      @EndUserText.label: '고정자산계정'
      ztitem_fa,
      @EndUserText.label: '상각기간'
      zusfl,
      @EndUserText.label: '거래일'
      zdate_trs,
      @EndUserText.label: '상각시작일'
      zdate_clo,
      @EndUserText.label: '상각계정'
      zritem_dep,
      @EndUserText.label: '소거계정'
      zritem_eli,
      @EndUserText.label: '상각누계계정'
      zritem_accum,
      @EndUserText.label: '손상차손'
      zritem_imp_dep,
      @EndUserText.label: '이연법인세'
      zritem_def,
      @EndUserText.label: '취득금액'
      @Semantics.amount.currencyCode: 'RHCUR'
      zamt,
      @EndUserText.label: '전표유형'
      docty,
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
