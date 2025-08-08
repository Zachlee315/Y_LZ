@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '수신자 관리 ROOT'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZLZ_MAIL_R_RECIP
  as select from zlz_mail_recip
{
  key uuid                  as Uuid,
      name                  as Name,
      email                 as Email,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,

      @Semantics.user.createdBy: true
      created_by            as CreatedBy,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,

      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt
}
