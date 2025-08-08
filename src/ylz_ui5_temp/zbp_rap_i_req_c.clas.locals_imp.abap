CLASS lhc_purchasecreate DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

*    METHODS get_instance_features FOR INSTANCE FEATURES
*      IMPORTING keys REQUEST requested_features FOR purchasecreate RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR purchasecreate RESULT result.

    METHODS create_pr FOR DETERMINE ON SAVE
      IMPORTING keys FOR purchasecreate~create_pr.

*    METHODS create_pr FOR MODIFY
*      IMPORTING keys FOR ACTION purchasecreate~create_pr." RESULT result.

*    METHODS create_pr_00 FOR MODIFY
*      IMPORTING keys FOR ACTION purchasecreate~create_pr_00 RESULT result.

ENDCLASS.

CLASS lhc_purchasecreate IMPLEMENTATION.

*  METHOD get_instance_features.
*  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create_pr.
          IF keys IS NOT INITIAL.
      READ ENTITIES OF zrap_i_req_c IN LOCAL MODE
       ENTITY purchasecreate ALL FIELDS WITH
       CORRESPONDING #( keys )
      RESULT DATA(lt_req_c)
      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported).

    DATA : ls_req_c like line of lt_req_c.

      "Select records
      IF lt_req_c IS NOT INITIAL.

        SORT lt_req_c BY purchaserequisition ASCENDING
                         purchaserequisitionitem ASCENDING.

*        DATA lt_target TYPE tcs_head-create_s-%target.
        LOOP AT lt_req_c ASSIGNING FIELD-SYMBOL(<fs_req_c>).
        ENDLOOP.

      ENDIF.
    ENDIF.
  ENDMETHOD.

*  METHOD create_pr_00.
*
*  ENDMETHOD.

ENDCLASS.

CLASS lsc_zrap_i_req_c DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zrap_i_req_c IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
