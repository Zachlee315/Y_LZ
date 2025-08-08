CLASS zcl_gr_if_8000 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES : ty_str TYPE ygrat9999,
            tt_str TYPE STANDARD TABLE OF ty_str WITH DEFAULT KEY.

    TYPES : ty_formular TYPE ygrat9997,
            tt_formular TYPE STANDARD TABLE OF ty_formular WITH DEFAULT KEY.

    TYPES: BEGIN OF ty_request,
             form_id TYPE ygrat9999-form_id,
             menu_id TYPE ygrat9999-menu_id,
           END OF ty_request.

    TYPES: BEGIN OF ty_return,
             re_code(1),
             re_msg(200),
             to_str      TYPE tt_str,
             to_formular TYPE tt_formular,
           END OF ty_return.

    CLASS-METHODS post IMPORTING !request  TYPE string
                       EXPORTING !response TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GR_IF_8000 IMPLEMENTATION.


  METHOD post.
    DATA ls_request  TYPE ty_request.
    DATA ls_return  TYPE ty_return.
    DATA lt_return  LIKE TABLE OF ls_return.
    DATA lt_str      TYPE tt_str.
    DATA lt_formular TYPE tt_formular.

    /ui2/cl_json=>deserialize( EXPORTING json        = request
                                             pretty_name = /ui2/cl_json=>pretty_mode-low_case
                                   CHANGING  data        = ls_request ).


    "양식구조 조회
    SELECT *
      FROM ygrat9999
     WHERE form_id EQ @ls_request-form_id
       AND menu_id EQ @ls_request-menu_id
      INTO CORRESPONDING FIELDS OF TABLE @lt_str.


    "수식 조회
    SELECT *
      FROM ygrat9997
     WHERE form_id EQ @ls_request-form_id
       AND menu_id EQ @ls_request-menu_id
      INTO CORRESPONDING FIELDS OF TABLE @lt_formular.

    ls_return-to_formular = lt_formular.
    ls_return-to_str = lt_str.

    IF ls_return-to_str IS INITIAL.
      ls_return-re_code = 'E'.
      ls_return-re_msg = '검색하신 양식이 없습니다.'.
    ELSE.
      ls_return-re_code = 'S'.
      ls_return-re_msg = '조회성공'.
    ENDIF.


    IF ls_return IS NOT INITIAL.
      response = /ui2/cl_json=>serialize( ls_return ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
