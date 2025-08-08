@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '수신자 관리 PROJECTION'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_MAIL_RECIP_READ'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZLZ_MAIL_P_RECIP
  provider contract transactional_query
  as projection on ZLZ_MAIL_R_RECIP
{

      @UI.facet: [ { id: 'EMAIL',
                     purpose: #STANDARD,
                     type: #IDENTIFICATION_REFERENCE,
                     label: '메일 수신자 관리',
                     position: 10 } ]


      @UI.hidden: true
  key Uuid,
      @EndUserText.label: '이름'
      @UI.identification: [ { position: 10 } ]
      @UI.selectionField: [{ position: 10 }]
      @UI.lineItem: [ { position: 10 } ]
      Name,

      @EndUserText.label: '이메일'
      @UI.identification: [ { position: 20 } ]
      @UI.lineItem: [ { position: 20 } ]
      Email,

      @EndUserText.label: '생성일'
      @UI.hidden: true
      CreatedAt,

      @EndUserText.label: '생성자'
      @UI.hidden: true
      CreatedBy,

      @EndUserText.label: '최종 변경일'
      @UI.hidden: true
      LastChangedAt,

      @EndUserText.label: '최종 변경자'
      @UI.hidden: true
      LastChangedBy,

      @EndUserText.label: '로컬 최종 변경일'
      @UI.hidden: true
      LocalLastChangedAt
}
