CLASS zcl_bom_display DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

    TYPES:
      ty_table       TYPE TABLE OF z_bom_extraction.

    DATA: pt_response TYPE TABLE OF z_bom_extraction,
          ps_response LIKE LINE OF pt_response.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS ZCL_BOM_DISPLAY IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    DATA: lv_param TYPE string,
          lv_where TYPE string.

    IF io_request->is_data_requested( ). "incoming data
      io_request->get_paging( ).

      DATA(lt_param_cond) = io_request->get_parameters( ).  "cds parameter조건
      DATA(lv_filter_cond) =  io_request->get_filter( )->get_as_sql_string( ). "FIORI화면의 필터조건
      REPLACE 'PLANT =' WITH 'BOMLINK~PLANT =' INTO lv_filter_cond.
      REPLACE ALL OCCURRENCES OF 'MATERIAL =' IN lv_filter_cond WITH 'BOMLINK~MATERIAL ='.

      lv_param = VALUE #( lt_param_cond[ parameter_name   = 'P_KEYDATE' ]-value OPTIONAL ). "parameter value

      "Select data
      SELECT *
      FROM i_bomcomponentwithkeydate( p_keydate = @lv_param ) AS bom
      JOIN i_materialbomlink AS bomlink
        ON bom~billofmaterialcategory = bomlink~billofmaterialcategory
       AND bom~billofmaterialvariant = bomlink~billofmaterialvariant
       AND bom~billofmaterial = bomlink~billofmaterial
      WHERE bomlink~billofmaterialcategory = 'M'
      AND bomlink~billofmaterialvariant = '01'
*      AND (lv_where)
      INTO TABLE @DATA(lt_bomlist).

      LOOP AT lt_bomlist ASSIGNING FIELD-SYMBOL(<lfs_bomlist>).
        MOVE-CORRESPONDING <lfs_bomlist>-bomlink TO ps_response.
        MOVE-CORRESPONDING <lfs_bomlist>-bom TO ps_response.

        SELECT SINGLE productname FROM i_producttext
        WHERE product = @ps_response-material
         AND language = @sy-langu
         INTO @ps_response-materialdesc.

        APPEND ps_response TO pt_response.
        CLEAR ps_response.

      ENDLOOP.

      IF io_request->is_total_numb_of_rec_requested(  ).
        io_response->set_total_number_of_records( lines( pt_response  ) ). "총데이터건수
        io_response->set_data( pt_response  ). "데이터 전송
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
