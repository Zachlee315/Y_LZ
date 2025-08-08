CLASS ycl_outbound_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    METHODS: call_soap_service IMPORTING io_out TYPE REF TO if_oo_adt_classrun_out.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS YCL_OUTBOUND_TEST IMPLEMENTATION.


  METHOD call_soap_service.
    TRY.
        DATA(lo_processor) = NEW ycl_financial_processor( ).
        lo_processor->test_inbound_outbound_flow( ).
        io_out->write( 'SOAP service call completed successfully.' ).
      CATCH cx_static_check INTO DATA(lx_error).
        io_out->write( |Error occurred: { lx_error->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    TRY.
        call_soap_service( out ).
      CATCH cx_root INTO DATA(lx_error).
        out->write( |Unexpected error: { lx_error->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
