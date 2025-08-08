@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'YTREE_I_0020'

define view entity YTREE_I_0020
  as select from yfoldert0020
  // Search Term #RAPTreeview
  association of exact one to many YTREE_I_0010 as _Menu on $projection.FormId = _Menu.FormId

{
  key form_id as FormId,
      cycle   as Cycle,
      @EndUserText.label: '생성일'
      cre_date    as CreateDate,
      
      @EndUserText.label: '생성시간'
      cre_time    as CreateTime,
      
      @EndUserText.label: '생성자'
      cre_user    as CreateUser,
      
      @EndUserText.label: '변경일'
      upd_date    as UpdateDate,
      
      @EndUserText.label: '변경시간'
      upd_time    as UpdateTime,
      
      @EndUserText.label: '변경자'
      upd_user    as UpdateUser,
      _Menu
}
