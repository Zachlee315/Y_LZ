CLASS lhc_zlz_mail_r_recip DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zlz_mail_r_recip RESULT result.
    METHODS delete_domain FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zlz_mail_r_recip~delete_domain.

    METHODS add_domain FOR DETERMINE ON SAVE
      IMPORTING keys FOR zlz_mail_r_recip~add_domain.

ENDCLASS.

CLASS lhc_zlz_mail_r_recip IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD delete_domain.
    DATA: ls_update     TYPE STRUCTURE FOR UPDATE zlz_mail_r_recip,
          lt_update     TYPE TABLE FOR UPDATE zlz_mail_r_recip,
          lt_delete     TYPE TABLE OF zlz_mail_r_recip,
          lt_uuid_range TYPE RANGE OF sysuuid_x16, " UUID 범위 테이블
          ls_uuid_range LIKE LINE OF lt_uuid_range.

***    DATA: lt_allowed_recipient_domains TYPE cl_bcs_mail_system_config=>tyt_recipient_domains,
***          ls_allowed_recipient_domains LIKE LINE OF lt_allowed_recipient_domains.

    " 모든 UUID를 범위 테이블로 수집
    LOOP AT keys INTO DATA(ls_key).
      CLEAR ls_uuid_range.
      ls_uuid_range-sign   = 'I'.
      ls_uuid_range-option = 'EQ'.
      ls_uuid_range-low    = ls_key-uuid.
      APPEND ls_uuid_range TO lt_uuid_range.
    ENDLOOP.

    " 범위 테이블을 사용하여 모든 삭제될 레코드 조회
    IF lt_uuid_range IS NOT INITIAL.
      SELECT * FROM zlz_mail_r_recip
        WHERE uuid IN @lt_uuid_range
        INTO TABLE @lt_delete.
    ENDIF.

    " 삭제될 레코드가 없으면 종료
    IF lt_delete IS INITIAL.
      RETURN.
    ENDIF.

    LOOP AT lt_delete INTO DATA(ls_delete).
      MOVE-CORRESPONDING ls_delete TO ls_update.
      APPEND ls_update TO lt_update.

*****      ls_allowed_recipient_domains = ls_delete-email.
*****      APPEND ls_allowed_recipient_domains TO lt_allowed_recipient_domains.
    ENDLOOP.

****    DATA(config_instance) = cl_bcs_mail_system_config=>create_instance( ).
****
****    "Delete allowed domains
****    TRY.
****        config_instance->delete_allowed_rec_domains( lt_allowed_recipient_domains ).
****      CATCH cx_bcs_mail_config INTO DATA(deletion_error).
****        DATA(lv_error) = 'X'.
****    ENDTRY.
****
****    IF lv_error IS NOT INITIAL.
****      RETURN.
****    ENDIF.

    " 업데이트할 데이터를 데이터베이스에 반영
    MODIFY ENTITIES OF zlz_mail_r_recip IN LOCAL MODE
           ENTITY zlz_mail_r_recip UPDATE SET FIELDS WITH lt_update
           MAPPED   DATA(ls_mapped_modify)
           FAILED   DATA(lt_failed_modify)
           REPORTED DATA(lt_reported_modify).

  ENDMETHOD.

  METHOD add_domain.

  ENDMETHOD.

ENDCLASS.
