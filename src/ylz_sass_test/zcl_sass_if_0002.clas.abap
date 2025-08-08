CLASS zcl_sass_if_0002 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    TYPES : BEGIN OF ty_select_tab,
              tab_name    TYPE string,
              tab_alias   TYPE string,
              param_value TYPE string,
              param_if    TYPE c LENGTH 1,
            END OF ty_select_tab.

    TYPES : BEGIN OF ty_tab_join,
              tab_name       TYPE string,
              tab_alias      TYPE string,
              join_tab       TYPE string,
              join_tab_alias TYPE string,
              join_type      TYPE c LENGTH 1,     "M - 메인테이블(FROM); I - INNER JOIN; L - LEFT OUTTER JOIN
              cond_field_r   TYPE string,         "JOIN 조건 우측 필드
              cond_field_l   TYPE string,         "JOIN 조건 좌측 필드
            END OF ty_tab_join.

    TYPES : BEGIN OF ty_tab_param,
              tab_name    TYPE string,
              param_name  TYPE string,
              param_value TYPE string,
            END OF ty_tab_param.

    TYPES : BEGIN OF ty_tab_where,
              field_name  TYPE string,
              field_alias TYPE string,
              cond_value  TYPE string,    "특정 상수값, 테이블 필드, 파라미터값 등 가능..
              cond_alias  TYPE string,    "테이블 필드일때 별칭
              operator    TYPE string,
            END OF ty_tab_where.

    TYPES : BEGIN OF ty_groupby,
              field_alias TYPE string,
              field_name  TYPE string,
            END OF ty_groupby.

    TYPES : BEGIN OF ty_select_fields,
              tab_name    TYPE string,
              field_name  TYPE string,
              field_alias TYPE string,
              cons_value  TYPE string,        "상수필드 값
              sum_if      TYPE c LENGTH 1,    "합계여부
              cons_if     TYPE c LENGTH 1,    "상수여부
            END OF ty_select_fields.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_sass_if_0002 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.


    DATA : ls_select_tab TYPE ty_select_tab,
           lt_select_tab TYPE STANDARD TABLE OF ty_select_tab.
    DATA : ls_tab_join TYPE ty_tab_join,
           lt_tab_join TYPE STANDARD TABLE OF ty_tab_join.
    DATA : ls_tab_param TYPE ty_tab_param,
           lt_tab_param TYPE STANDARD TABLE OF ty_tab_param.
    DATA : ls_tab_where TYPE ty_tab_where,
           lt_tab_where TYPE STANDARD TABLE OF ty_tab_where.
    DATA : ls_groupby TYPE ty_groupby,
           lt_groupby TYPE STANDARD TABLE OF ty_groupby.
    DATA : ls_select_fields TYPE ty_select_fields,
           lt_select_fields TYPE STANDARD TABLE OF ty_select_fields.

    DATA : lv_request_sbudat TYPE budat,
           lv_request_ebudat TYPE budat.

    DATA : lv_times TYPE sy-index.

    lv_request_sbudat = '20240101'.
    lv_request_ebudat = '20240131'.

    lt_select_tab = VALUE #( ( tab_name = 'I_MATLSTKATKEYDATEINALTUOM' tab_alias = '_MARDH' param_if = 'X' param_value = |{ lv_request_sbudat }| )
                           ).

    lt_tab_join = VALUE #( ( tab_name = 'I_PRODUCT' tab_alias = '_MARA' join_tab = 'I_MATLSTKATKEYDATEINALTUOM'  join_tab_alias = '_MARDH' join_type = 'I' cond_field_l = 'PRODUCT' cond_field_r = 'PRODUCT' )
**                           ( tab_name = 'I_PRODUCTTEX' tab_alias = '_MTEXT' join_tab = 'I_MATLSTKATKEYDATEINALTUOM'  join_tab_alias = '_MARDH' join_type = 'L' cond_filed_l = 'PRODUCT' cond_filed_r = 'PRODUCT' )
                           ).

    lt_tab_param = VALUE #( ( tab_name = 'I_MATLSTKATKEYDATEINALTUOM' param_name = 'P_KEYDATE' param_value = |'{ lv_request_sbudat }'|  )
                           ).

    lt_tab_where = VALUE #( ( field_name = 'MATERIALBASEUNIT' field_alias = '_MARDH' cond_value = 'ALTERNATIVEUNIT' cond_alias =  '_MARDH' operator = '=' )
    ( field_name = 'STORAGELOCATION' field_alias = '_MARDH' cond_value = |( '431B' )|  cond_alias =  '' operator = 'IN' )
                           ).

    lt_select_fields = VALUE #( ( tab_name = 'I_MATLSTKATKEYDATEINALTUOM' field_name = 'PRODUCT' field_alias = 'MATNR' )
                                ( tab_name = 'I_MATLSTKATKEYDATEINALTUOM' field_name = 'PLANT' field_alias = 'WERKS' )
                                ( tab_name = 'I_MATLSTKATKEYDATEINALTUOM' field_name = 'STORAGELOCATION' field_alias = 'LGORT' )
                                ( tab_name = 'I_MATLSTKATKEYDATEINALTUOM' field_name = 'SUPPLIER' field_alias = 'LIFNR' )
                                ( tab_name = 'I_MATLSTKATKEYDATEINALTUOM' field_name = 'CUSTOMER' field_alias = 'KUNNR'  )
                                ( tab_name = 'I_MATLSTKATKEYDATEINALTUOM' field_name = 'SDDOCUMENT' field_alias = 'KDAUF' )
                                ( tab_name = 'I_MATLSTKATKEYDATEINALTUOM' field_name = 'SDDOCUMENTITEM' field_alias = 'KDPOS' )
                                ( tab_name = 'I_MATLSTKATKEYDATEINALTUOM' field_name = 'WBSELEMENTINTERNALID' field_alias = 'WBSID'  )
                                ( tab_name = 'I_MATLSTKATKEYDATEINALTUOM' field_name = 'INVENTORYSPECIALSTOCKTYPE' field_alias = 'SOBKZ'  )
                                ( tab_name = 'I_PRODUCT' field_name = 'PRODUCTTYPE' field_alias = 'MTART'  )
                                ( tab_name = 'I_PRODUCT' field_name = 'BASEUNIT' field_alias = 'MEINS'  )
                                ( tab_name = 'I_MATLSTKATKEYDATEINALTUOM' field_name = 'MATLWRHSSTKQTYINMATLBASEUNIT' field_alias = 'MENGE' sum_if = 'X'  )
                                ( field_alias = 'BUDAT'  cons_if = 'X' cons_value = |'{ lv_request_sbudat }'| )
                           ).

    lt_groupby = VALUE #( ( field_alias = '_MARDH' field_name = 'PRODUCT' )
                          ( field_alias = '_MARDH' field_name = 'PLANT' )
                          ( field_alias = '_MARDH' field_name = 'STORAGELOCATION' )
                          ( field_alias = '_MARDH' field_name = 'SUPPLIER' )
                          ( field_alias = '_MARDH' field_name = 'CUSTOMER' )
                          ( field_alias = '_MARDH' field_name = 'SDDOCUMENT' )
                          ( field_alias = '_MARDH' field_name = 'SDDOCUMENTITEM' )
                          ( field_alias = '_MARDH' field_name = 'WBSELEMENTINTERNALID' )
                          ( field_alias = '_MARDH' field_name = 'INVENTORYSPECIALSTOCKTYPE' )
                          ( field_alias = '_MARA'  field_name = 'PRODUCTTYPE' )
                          ( field_alias = '_MARA' field_name = 'BASEUNIT' )
                        ).

    DATA: lv_sql_from    TYPE string,
          lv_sql_where   TYPE string,
          lv_sql_field   TYPE string,
          lv_sql_groupby TYPE string.



    "SELECT 필드구성
    DATA(lv_field_count) = lines( lt_select_fields[] ).
    LOOP AT lt_select_fields INTO ls_select_fields.
      DATA(lv_index) = sy-tabix.
      READ TABLE lt_select_tab INTO ls_select_tab WITH KEY tab_name = ls_select_fields-tab_name.
      IF sy-subrc EQ 0.
        IF ls_select_fields-sum_if IS INITIAL.
          DATA(lv_field) = | { ls_select_tab-tab_alias }~{ ls_select_fields-field_name } AS { ls_select_fields-field_alias }| .
        ELSE.
          lv_field = | SUM( { ls_select_tab-tab_alias }~{ ls_select_fields-field_name } ) AS { ls_select_fields-field_alias }|.
        ENDIF.
      ENDIF.

      READ TABLE lt_tab_join INTO ls_tab_join WITH KEY tab_name = ls_select_fields-tab_name.
      IF sy-subrc EQ 0.
        IF ls_select_fields-sum_if IS INITIAL.
          lv_field = | { ls_tab_join-tab_alias }~{ ls_select_fields-field_name } AS { ls_select_fields-field_alias }| .
        ELSE.
          lv_field = | SUM( { ls_tab_join-tab_alias }~{ ls_select_fields-field_name } ) AS { ls_select_fields-field_alias }|.
        ENDIF.
      ENDIF.

      IF ls_select_fields-tab_name IS INITIAL AND ls_select_fields-cons_if IS NOT INITIAL.
        lv_field = | { ls_select_fields-cons_value } AS { ls_select_fields-field_alias }|.
      ENDIF.

      IF lv_index NE lv_field_count.
        lv_sql_field = lv_sql_field && lv_field && ','.
      ELSE.
        lv_sql_field = lv_sql_field && lv_field.
      ENDIF.

      CLEAR lv_field.
    ENDLOOP.

    "FROM
    ls_select_tab = lt_select_tab[ 1 ].
    IF ls_select_tab-param_if IS INITIAL.
      lv_sql_from = | { ls_select_tab-tab_name } AS { ls_select_tab-tab_alias }|.
    ELSE.
      DATA(lv_param_cnout) = lines( lt_tab_param[] ).
      CLEAR lv_times.
      "FROM 테이블에 파라미터 조건이 여려개인 상황도 고려함
      LOOP AT lt_tab_param INTO ls_tab_param WHERE tab_name = ls_select_tab-tab_name.
        lv_times += 1.

        IF  lv_times = 1.
          lv_sql_from = | { ls_select_tab-tab_name }( { ls_tab_param-param_name } = '{ ls_select_tab-param_value }' |.
          IF lv_times = lv_param_cnout.
            lv_sql_from = lv_sql_from && | ) AS { ls_select_tab-tab_alias }|.
          ENDIF.
        ELSE.
          IF lv_times <> lv_param_cnout.
            lv_sql_from = lv_sql_from && |, { ls_tab_param-param_name } = '{ ls_select_tab-param_value }'|.
          ELSE.
            lv_sql_from = lv_sql_from && | ) AS { ls_select_tab-tab_alias }|.
          ENDIF.
        ENDIF.
      ENDLOOP.

    ENDIF.

    "JOIN
    DATA lv_tabix TYPE sy-tabix.
    DATA lv_cond_op TYPE c LENGTH 3.
    LOOP AT lt_tab_join INTO  DATA(wa)
         GROUP BY ( tab_name  = wa-tab_name
                    index = GROUP INDEX
                    size  = GROUP SIZE )
         ASCENDING INTO DATA(lo_grp).

      CLEAR lv_tabix.
      LOOP AT GROUP lo_grp INTO DATA(ls_grp).
        lv_tabix += 1.

        CASE ls_grp-join_type.
          WHEN 'I'.
            lv_sql_from = lv_sql_from && | INNER JOIN { ls_grp-tab_name } AS { ls_grp-tab_alias }|.
          WHEN 'L'.
            lv_sql_from = lv_sql_from && | LEFT OUTTER JOIN { ls_grp-tab_name } AS { ls_grp-tab_alias }|.
        ENDCASE.

        IF lv_tabix = 1.
          lv_cond_op = 'ON'.
        ELSE.
          lv_cond_op = 'AND'.
        ENDIF.
        lv_sql_from = lv_sql_from && | { lv_cond_op } { ls_grp-tab_alias }~{ ls_grp-cond_field_l } = { ls_grp-join_tab_alias }~{ ls_grp-cond_field_r } | .
      ENDLOOP.
    ENDLOOP.

    "WHERE 조건
    CLEAR : lv_tabix.
    LOOP AT lt_tab_where INTO ls_tab_where.

      lv_tabix += 1.
      " 우측조건 값이 특정테이블 필드일때
      IF ls_tab_where-cond_alias IS NOT INITIAL.
        IF lv_tabix = 1.
          lv_sql_where = | { ls_tab_where-field_alias }~{ ls_tab_where-field_name } { ls_tab_where-operator } { ls_tab_where-cond_alias }~{ ls_tab_where-cond_value } |.
        ELSE.
          lv_sql_where = lv_sql_where && | AND { ls_tab_where-field_alias }~{ ls_tab_where-field_name } { ls_tab_where-operator } { ls_tab_where-cond_alias }~{ ls_tab_where-cond_value } |.
        ENDIF.

      ELSE.

        "우측조건 값이 일반 값일때
        IF lv_tabix = 1.
          lv_sql_where = | { ls_tab_where-field_alias }~{ ls_tab_where-field_name } { ls_tab_where-operator } { ls_tab_where-cond_value } |.
        ELSE.
          lv_sql_where = lv_sql_where && | AND { ls_tab_where-field_alias }~{ ls_tab_where-field_name } { ls_tab_where-operator } { ls_tab_where-cond_value } |.
        ENDIF.
      ENDIF.
    ENDLOOP.

    "GROUP BY
    LOOP AT lt_groupby INTO ls_groupby.
      IF sy-tabix = 1.
        lv_sql_groupby = lv_sql_groupby && | { ls_groupby-field_alias }~{ ls_groupby-field_name } |.
      ELSE.
        lv_sql_groupby = lv_sql_groupby && |, { ls_groupby-field_alias }~{ ls_groupby-field_name } |.
      ENDIF.
    ENDLOOP.




    TYPES : BEGIN OF ty_items,
              matnr TYPE i_matlstkatkeydateinaltuom-product,
              werks TYPE i_matlstkatkeydateinaltuom-plant,
              lgort TYPE i_matlstkatkeydateinaltuom-storagelocation,
              lifnr TYPE i_matlstkatkeydateinaltuom-supplier,
              kunnr TYPE i_matlstkatkeydateinaltuom-customer,
              kdauf TYPE i_matlstkatkeydateinaltuom-sddocument,
              kdpos TYPE i_matlstkatkeydateinaltuom-sddocumentitem,
              wbsid TYPE i_matlstkatkeydateinaltuom-wbselementinternalid,
              sobkz TYPE i_matlstkatkeydateinaltuom-inventoryspecialstocktype,
              budat TYPE c LENGTH 10,
              mtart TYPE i_product-producttype,
              meins TYPE i_product-baseunit,
              menge TYPE i_matlstkatkeydateinaltuom-matlwrhsstkqtyinmatlbaseunit,
            END OF ty_items.
    DATA : lt_data TYPE STANDARD TABLE OF ty_items.


    SELECT (lv_sql_field)
     FROM (lv_sql_from)
    WHERE (lv_sql_where)
     GROUP BY (lv_sql_groupby)
     INTO CORRESPONDING FIELDS OF TABLE @lt_data.
  ENDMETHOD.
ENDCLASS.
