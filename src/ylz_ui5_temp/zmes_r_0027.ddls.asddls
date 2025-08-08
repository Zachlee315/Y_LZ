@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '원부자재 수입검사 실적 테스트'
define root view entity ZMES_R_0027
  as select from zmes_t_0027

{

  key uuid                  as UUID,
      timekey               as TIMEKEY,
      transnum              as TRANSNUM,
      transdate             as TRANSDATE,
      companycode           as COMPANYCODE,
      productspecid         as PRODUCTSPECID,
      materialnum           as MATERIALNUM,
      inspectstartdate      as INSPECTSTARTDATE,
      inspectenddate        as INSPECTENDDATE,
      stopstartdate         as STOPSTARTDATE,
      stopenddate           as STOPENDDATE,
      inspector             as INSPECTOR,
      quantity              as QUANTITY,
      normalqty             as NORMALQTY,
      concessionqty         as CONCESSIONQTY,
      scrapqty              as SCRAPQTY,
      scrapcode             as SCRAPCODE,
      scrapcomment          as SCRAPCOMMENT,
      mescreatetime         as MESCREATETIME,
      erpupdatetime         as ERPUPDATETIME,
      crud                  as CRUD,
      applyflag             as APPLYFLAG,
      eventcomment          as EVENTCOMMENT,
      trycnt                as TRYCNT,
      document_num          as DOCUMENT_NUM,
      scrapdoc_num          as SCRAPDOC_NUM,
      if_code               as IF_CODE,
      if_msg                as IF_MSG,
      @Semantics.user.createdBy: true
      created_by            as CREATED_BY,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CREATED_AT,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LAST_CHANGED_BY,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LAST_CHANGED_AT,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LOCAL_LAST_CHANGED_AT
}
