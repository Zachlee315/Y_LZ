CLASS zdoc_entry_handler DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-DATA: go_instance TYPE REF TO zdoc_entry_handler.

    CLASS-METHODS: get_instance RETURNING VALUE(result) TYPE REF TO zdoc_entry_handler.

    TYPES: BEGIN OF ty_temp_key,
             cid            TYPE abp_behv_cid,
             pid            TYPE abp_behv_pid,
             simu_result(2),
             simu_msg       TYPE string,
*             msg TYPE ref to if_abap_behv_message,
           END OF ty_temp_key,
           tt_temp_key TYPE STANDARD TABLE OF ty_temp_key WITH DEFAULT KEY,
           BEGIN OF ty_final_key,
             cid            TYPE abp_behv_cid,
             bukrs          TYPE bukrs,
             belnr          TYPE belnr_d,
             gjahr          TYPE gjahr,
             simu_result(2),
             simu_msg       TYPE string,
           END OF ty_final_key,
           tt_final_key TYPE STANDARD TABLE OF ty_final_key WITH DEFAULT KEY,
           tt_header    TYPE STANDARD TABLE OF ytdoc_header WITH DEFAULT KEY.


    DATA: temp_key     TYPE tt_temp_key.


    METHODS: set_temp_key IMPORTING it_temp_key TYPE tt_temp_key,
      get_temp_key RETURNING VALUE(result) TYPE tt_temp_key,
      convert_temp_to_final RETURNING VALUE(result) TYPE tt_final_key,
      additional_save IMPORTING it_create TYPE tt_header
                                it_delete TYPE tt_header,
      clean_up.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZDOC_ENTRY_HANDLER IMPLEMENTATION.


  METHOD additional_save.

    DATA: lt_create TYPE TABLE OF ytdoc_header.

    DATA(lt_je_key) = convert_temp_to_final(  ).

    LOOP AT it_create INTO DATA(ls_create).
      " 전표 생성은 CID 로 확인
      READ TABLE lt_je_key INTO DATA(ls_je_key) WITH KEY cid = ls_create-docuuid.
      IF sy-subrc = 0.
        IF ls_je_key-simu_result = 'E'.
          ls_create-ifstatus = ls_je_key-simu_result.
          ls_create-ifmsg = ls_je_key-simu_msg.
        ELSE.
          ls_create-accountingdocument = ls_je_key-belnr.
          ls_create-ifstatus = 'S'.
          ls_create-ifmsg = '전표생성 성공!'.
        ENDIF.
        APPEND ls_create TO lt_create.

      ELSE.
        " 전표 역분개는 CID 값이 없으므로 simu_result = 'RS' 로 확인
        READ TABLE lt_je_key INTO ls_je_key WITH KEY simu_result = 'RS'.
        IF sy-subrc = 0.
          IF ls_je_key-simu_result = 'E'.
            ls_create-ifstatus = ls_je_key-simu_result.
            ls_create-ifmsg = ls_je_key-simu_msg.
          ELSE.
            ls_create-accountingdocument = ls_je_key-belnr.
            ls_create-ifstatus = 'S'.
            ls_create-ifmsg = '역분개 성공!'.
          ENDIF.
          APPEND ls_create TO lt_create.
        ENDIF.
      ENDIF.

    ENDLOOP.

    IF lt_create IS NOT INITIAL.
      INSERT ytdoc_header FROM TABLE @lt_create.
    ENDIF.

    IF it_delete IS NOT INITIAL.
      DELETE ytdoc_header FROM TABLE @it_delete.
    ENDIF.

  ENDMETHOD.


  METHOD clean_up.
    CLEAR temp_key.
  ENDMETHOD.


  METHOD convert_temp_to_final.
    DATA: ls_final_key TYPE ty_final_key.
    IF temp_key IS NOT INITIAL.
      LOOP AT temp_key INTO DATA(ls_temp_key).

        CASE ls_temp_key-simu_result.
          WHEN 'E'.
            ls_final_key-cid = ls_temp_key-cid.
            ls_final_key-simu_result = ls_temp_key-simu_result.
            ls_final_key-simu_msg = ls_temp_key-simu_msg.
          WHEN 'S' OR 'RS'.

            CONVERT KEY OF i_journalentrytp
              FROM ls_temp_key-pid
              TO FINAL(lv_root_key).

            ls_final_key-cid = ls_temp_key-cid.
            ls_final_key-simu_result = ls_temp_key-simu_result.
            ls_final_key-bukrs = lv_root_key-companycode.
            ls_final_key-belnr = lv_root_key-accountingdocument.
            ls_final_key-gjahr = lv_root_key-fiscalyear.

        ENDCASE.

        APPEND ls_final_key TO result.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD get_instance.
    IF go_instance IS NOT BOUND.
      go_instance = NEW #( ).
    ENDIF.
    result = go_instance.
  ENDMETHOD.


  METHOD get_temp_key.
    result = temp_key.
  ENDMETHOD.


  METHOD set_temp_key.
    temp_key = it_temp_key.
  ENDMETHOD.
ENDCLASS.
