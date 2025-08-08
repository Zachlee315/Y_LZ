CLASS zcl_sass_http_api DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SASS_HTTP_API IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.

    CONSTANTS:if_system_class_prefix TYPE c LENGTH 20 VALUE 'ZCL_SASS_IF_',
              if_post                TYPE c LENGTH 4 VALUE 'POST',
              if_get                 TYPE c LENGTH 4 VALUE 'GET',

              if_detail              TYPE c LENGTH 6 VALUE 'DETAIL',
              if_save_data           TYPE c LENGTH 4 VALUE 'SAVE'.


    DATA:lv_req TYPE string,
         lv_res TYPE string.
    DATA:ptab TYPE abap_parmbind_tab,
         etab TYPE abap_excpbind_tab.



    lv_req = request->get_text( ).

    DATA(if_name) = request->get_form_field( 'IF_NAME' ).
    DATA(if_mode) = request->get_form_field( 'IF_MODE' ).
** DATA(if_type) = request->get_method( ).
    DATA(if_class_name) = if_system_class_prefix && if_name.

    ptab = VALUE #( ( name = 'REQUEST'
    kind = cl_abap_objectdescr=>exporting
    value = REF #( lv_req ) )
    ( name = 'RESPONSE'
    kind = cl_abap_objectdescr=>importing
    value = REF #( lv_res ) ) ).

    CASE if_mode.
      WHEN 'POST'.
        CALL METHOD (if_class_name)=>(if_post)
          PARAMETER-TABLE
          ptab.
      WHEN 'GET'.
        CALL METHOD (if_class_name)=>(if_get)
          PARAMETER-TABLE
          ptab.
      WHEN 'SAVE'.
        CALL METHOD (if_class_name)=>(if_save_data)
          PARAMETER-TABLE
          ptab.
      WHEN 'DETAIL'.
        CALL METHOD (if_class_name)=>(if_detail)
          PARAMETER-TABLE
          ptab.
    ENDCASE.

    response->set_header_field(
    EXPORTING
    i_name = 'content-type'
    i_value = 'application/json'
    ).
    response->set_text( lv_res ).



  ENDMETHOD.
ENDCLASS.
