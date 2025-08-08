CLASS zcl_lz_mail_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LZ_MAIL_TEST IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA(config_instance) = cl_bcs_mail_system_config=>create_instance( ).

    DATA recipient_domains TYPE cl_bcs_mail_system_config=>tyt_recipient_domains.
    DATA sender_domains TYPE cl_bcs_mail_system_config=>tyt_sender_domains.
    recipient_domains = VALUE #( ( 'jindongyan@aspnc.com' ) ( 'psm0509@aspnc.com' ) ( 'lizhe0315@aspnc.com' ) ).
****    sender_domains = VALUE #( ( 'lizhe0315@aspnc.com' ) ).


**    "Add allowed domains
**    TRY.
**        config_instance->set_address_check_active( abap_true ).
**        config_instance->add_allowed_recipient_domains( recipient_domains ).
**        config_instance->add_allowed_sender_domains( sender_domains ).
****        config_instance->modify_default_sender_address( iv_default_address = 'lizhe0315@aspnc.com'
****                                                    iv_default_name = 'Personal Sender' ).
**      CATCH cx_bcs_mail_config INTO DATA(write_error).
**        "handle exception
**        DATA(lv_error) = 'X'.
**    ENDTRY.

**    "Read allowed domains
    DATA(allowed_recipient_domains) = config_instance->read_allowed_recipient_domains( ).
    DATA(allowed_sender_domains) = config_instance->read_allowed_sender_domains( ).
    config_instance->read_default_sender_address(
      IMPORTING
        ev_default_sender_address = DATA(default_sender_address)
        ev_default_sender_name = DATA(default_sender_name) ).


" 수신자 추가와 발신이 동시에 작동하지 못한다
    TRY.
        DATA(lo_mail) = cl_bcs_mail_message=>create_instance( ).

        lo_mail->set_sender( 'do.not.reply@my407000.mail.s4hana.cloud.sap' ).
*        lo_mail->set_sender( 'do.not.reply@my406989.mail.s4hana.cloud.sap' ).
        lo_mail->add_recipient( 'psm0509@aspnc.com' ).

        lo_mail->set_subject( 'Test Mail' ).

        lo_mail->set_main( cl_bcs_mail_textpart=>create_instance(
            iv_content      = '<h1>Hello</h1><p>Hello world send from RAP!</p>'
            iv_content_type = 'text/html' ) ).

        lo_mail->send( IMPORTING et_status = DATA(lt_status) ).

        out->write( lt_status ).

      CATCH cx_bcs_mail INTO DATA(lo_err).
        out->write( lo_err->get_longtext( ) ).
    ENDTRY.



**    "Delete allowed domains
**    TRY.
**        config_instance->delete_allowed_rec_domains( allowed_recipient_domains ).
****        config_instance->delete_allowed_sender_domains( allowed_sender_domains ).
**        config_instance->delete_default_sender_addr( default_sender_address ).
**      CATCH cx_bcs_mail_config INTO DATA(deletion_error).
**        "handle exception
**    ENDTRY.
  ENDMETHOD.
ENDCLASS.
