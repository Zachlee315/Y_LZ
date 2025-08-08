CLASS lhc_ytree_r_0020_tp DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ytree_r_0020_tp RESULT result.
*    METHODS deletewithcheck FOR MODIFY
*      IMPORTING keys FOR ACTION ytree_r_0020_tp~deletewithcheck RESULT result.

ENDCLASS.

CLASS lhc_ytree_r_0020_tp IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

*  METHOD DeleteWithCheck.
*  ENDMETHOD.

ENDCLASS.
