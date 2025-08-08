CLASS zcl_sass_if_0001 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES : BEGIN OF ty_request,
              sbudat TYPE budat,
              ebudat TYPE budat,
            END OF ty_request.

*    TYPES : BEGIN OF ty_items,
*              matnr TYPE i_matlstkatkeydateinaltuom-product,
*              werks TYPE i_matlstkatkeydateinaltuom-plant,
*              lgort TYPE i_matlstkatkeydateinaltuom-storagelocation,
*              lifnr TYPE i_matlstkatkeydateinaltuom-supplier,
*              kunnr TYPE i_matlstkatkeydateinaltuom-customer,
*              kdauf TYPE i_matlstkatkeydateinaltuom-sddocument,
*              kdpos TYPE i_matlstkatkeydateinaltuom-sddocumentitem,
*              wbsid TYPE i_matlstkatkeydateinaltuom-wbselementinternalid,
*              sobkz TYPE i_matlstkatkeydateinaltuom-inventoryspecialstocktype,
*              budat TYPE budat,
*              mtart TYPE i_product-producttype,
*              meins TYPE i_product-baseunit,
*              menge TYPE i_matlstkatkeydateinaltuom-matlwrhsstkqtyinmatlbaseunit,
*            END OF ty_items.

    TYPES : BEGIN OF ty_items,
              matnr TYPE string,
              werks TYPE string,
              lgort TYPE string,
              lifnr TYPE string,
              kunnr TYPE string,
              kdauf TYPE string,
              kdpos TYPE string,
              wbsid TYPE string,
              sobkz TYPE string,
              budat TYPE budat,
              mtart TYPE string,
              meins TYPE string,
              menge TYPE string,
            END OF ty_items.

    TYPES tt_items TYPE STANDARD TABLE OF ty_items WITH DEFAULT KEY.

    TYPES : BEGIN OF ty_response,
              to_items        TYPE tt_items,
              result_code(1),
              result_msg(100),
            END OF ty_response.

    CLASS-METHODS:
      get IMPORTING request TYPE string EXPORTING response TYPE string.
PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SASS_IF_0001 IMPLEMENTATION.


  METHOD get.
    DATA ls_request  TYPE ty_request.
    DATA ls_response TYPE ty_response.
    DATA lt_response TYPE STANDARD TABLE OF ty_response.
    DATA ls_out_items TYPE ty_items.
    DATA lt_out_items TYPE STANDARD TABLE OF ty_items.

    /ui2/cl_json=>deserialize( EXPORTING json        = request
                                         pretty_name = /ui2/cl_json=>pretty_mode-low_case
                               CHANGING  data        = ls_request ).

    IF ls_request-sbudat IS NOT INITIAL.

      SELECT _mardh~product                             AS matnr,
             _mardh~plant                               AS werks,
             _mardh~storagelocation                     AS lgort,
             _mardh~supplier                            AS lifnr,
             _mardh~customer                            AS kunnr,
             _mardh~sddocument                          AS kdauf,
             _mardh~sddocumentitem                      AS kdpos,
             _mardh~wbselementinternalid                AS wbsid,
             _mardh~inventoryspecialstocktype           AS sobkz,
             @ls_request-sbudat                         AS budat,
             _mara~producttype                          AS mtart,
             _mara~baseunit                             AS meins,
             SUM( _mardh~matlwrhsstkqtyinmatlbaseunit ) AS menge
        FROM i_matlstkatkeydateinaltuom( p_keydate = @ls_request-sbudat  ) AS _mardh
        JOIN i_product AS _mara ON _mara~product = _mardh~product
       WHERE  _mardh~materialbaseunit = _mardh~alternativeunit
        GROUP BY _mardh~product,
                 _mardh~plant,
                 _mardh~storagelocation,
                 _mardh~supplier,
                 _mardh~customer,
                 _mardh~sddocument,
                 _mardh~sddocumentitem,
                 _mardh~wbselementinternalid,
                 _mardh~inventoryspecialstocktype,
                 _mara~producttype,
                 _mara~baseunit
        INTO TABLE @DATA(lt_data).

    ENDIF.

    IF ls_request-ebudat IS NOT INITIAL.
      SELECT _mardh~product                             AS matnr,
             _mardh~plant                               AS werks,
             _mardh~storagelocation                     AS lgort,
             _mardh~supplier                            AS lifnr,
             _mardh~customer                            AS kunnr,
             _mardh~sddocument                          AS kdauf,
             _mardh~sddocumentitem                      AS kdpos,
             _mardh~wbselementinternalid                AS wbsid,
             _mardh~inventoryspecialstocktype           AS sobkz,
             @ls_request-ebudat                         AS budat,
             _mara~producttype                          AS mtart,
             _mara~baseunit                             AS meins,
             SUM( _mardh~matlwrhsstkqtyinmatlbaseunit ) AS menge
        FROM i_matlstkatkeydateinaltuom( p_keydate = @ls_request-ebudat  ) AS _mardh
        JOIN i_product AS _mara ON _mara~product = _mardh~product
       WHERE  _mardh~materialbaseunit = _mardh~alternativeunit
        GROUP BY _mardh~product,
                 _mardh~plant,
                 _mardh~storagelocation,
                 _mardh~supplier,
                 _mardh~customer,
                 _mardh~sddocument,
                 _mardh~sddocumentitem,
                 _mardh~wbselementinternalid,
                 _mardh~inventoryspecialstocktype,
                 _mara~producttype,
                 _mara~baseunit
        APPENDING TABLE @lt_data.

    ENDIF.


    IF lt_data IS NOT INITIAL.
      LOOP AT lt_data INTO DATA(ls_data).
        MOVE-CORRESPONDING ls_data TO ls_out_items.
        APPEND ls_out_items TO lt_out_items.
      ENDLOOP.
      ls_response-to_items = lt_out_items.
      ls_response-result_code = 'S'.
      ls_response-result_msg = '조회성공'.

    ELSE.
      ls_response-result_code = 'E'.
      ls_response-result_msg = '검색조건에 맞는 데이터가 없습니다.'.
    ENDIF.



    APPEND ls_response TO lt_response.
    response = /ui2/cl_json=>serialize( lt_response ).
  ENDMETHOD.
ENDCLASS.
