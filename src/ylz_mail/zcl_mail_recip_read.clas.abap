CLASS zcl_mail_recip_read DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MAIL_RECIP_READ IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    DATA : lt_response TYPE TABLE OF zlz_mail_p_recip,
           ls_response TYPE zlz_mail_p_recip,
           lv_num      TYPE int8.

    IF NOT  io_request->is_data_requested( ).
      RETURN.
    ENDIF.

    io_request->get_paging( ).

    TRY.
        "Filter not needed, because we all calculate fields in Backend
        DATA(lo_filter) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range.
    ENDTRY.

    SELECT * FROM zlz_mail_recip
    INTO TABLE @DATA(lt_mail).


    DATA(config_instance) = cl_bcs_mail_system_config=>create_instance( ).
    DATA(allowed_recipient_domains) = config_instance->read_allowed_recipient_domains( ).

    LOOP AT allowed_recipient_domains INTO DATA(ls_recip_domain).
      READ TABLE lt_mail INTO DATA(ls_mail) WITH KEY email = ls_recip_domain.
      IF sy-subrc EQ 0.
        MOVE-CORRESPONDING ls_mail TO ls_response.
        APPEND ls_response TO lt_response.
      ENDIF.
    ENDLOOP.

    lv_num = lines( lt_response ).
    io_response->set_total_number_of_records( lv_num ).
    io_response->set_data( lt_response ).

  ENDMETHOD.
ENDCLASS.
