CLASS lhc_zi_doc_header DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_doc_header RESULT result.

    METHODS post FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_doc_header~post.

    METHODS:
      create_document
        IMPORTING params TYPE sysuuid_x16,

      reverse_document
        IMPORTING params TYPE sysuuid_x16.

ENDCLASS.

CLASS lhc_zi_doc_header IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.



  METHOD post.

    " CBO 데이터 조회
    READ ENTITIES OF zi_doc_header IN LOCAL MODE
         ENTITY zi_doc_header
         ALL FIELDS
           " keys 값 설정
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_header_result)
         FAILED    DATA(lt_failed)
         REPORTED  DATA(lt_reported).

    " Standard API 호출
    DATA(key) = keys[ 1 ].




    " 전표헤더
    DATA(ls_header) = lt_header_result[ 1 ].

    IF ls_header-reversalreferencedocumentkey IS INITIAL.
      me->create_document( key-docuuid ).
    ELSE.
      me->reverse_document( key-docuuid ).
    ENDIF.

  ENDMETHOD.

  METHOD create_document.

    DATA: lt_temp_key TYPE zdoc_entry_handler=>tt_temp_key,
          ls_temp_key LIKE LINE OF lt_temp_key.
    DATA: lt_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post.

    " Doc UUID 기준으로 데이터 조회
    READ ENTITIES OF zi_doc_header IN LOCAL MODE
        ENTITY zi_doc_header
        ALL FIELDS WITH VALUE #( ( docuuid = params ) )
        RESULT DATA(lt_doc_result)
        "Item 조회
        ENTITY zi_doc_header BY \_item
        ALL FIELDS WITH VALUE #( ( docuuid = params ) )
        RESULT DATA(lt_doc_item_result)
        "vendor 조회
        ENTITY zi_doc_header BY \_vendor
        ALL FIELDS WITH VALUE #( ( docuuid = params ) )
        RESULT DATA(lt_doc_vendor_result)
        "tax 조회
        ENTITY zi_doc_header BY \_tax
        ALL FIELDS WITH VALUE #( ( docuuid = params ) )
        RESULT DATA(lt_doc_tax_result).

    APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<je_deep>).

    DATA(ls_header) = lt_doc_result[ 1 ].

    <je_deep>-%cid = ls_header-docuuid.
    <je_deep>-%param-companycode = ls_header-companycode.
    <je_deep>-%param-documentreferenceid = ls_header-documentreferenceid.
    <je_deep>-%param-createdbyuser = ls_header-createduser.
    <je_deep>-%param-businesstransactiontype = ls_header-businesstransactiontype.
    <je_deep>-%param-accountingdocumenttype = ls_header-accountingdocumenttype.
    <je_deep>-%param-documentdate = ls_header-documentdate.
    <je_deep>-%param-postingdate = ls_header-postingdate.
    <je_deep>-%param-accountingdocumentheadertext = ls_header-headertext.
    <je_deep>-%param-taxdeterminationdate = ls_header-taxdeterminationdate.

    " Items(G/L)
    DATA ls_deep_item LIKE <je_deep>-%param-_glitems.
    CLEAR : ls_deep_item.
    LOOP AT lt_doc_item_result INTO DATA(ls_item).
      ls_deep_item = VALUE #( ( glaccountlineitem = ls_item-glaccountlineitem
                                glaccount         = ls_item-glaccount
                                costcenter        = ls_item-costcenter
                                documentitemtext  = ls_item-documentitemtext
                                taxcode           = ls_item-taxcode
                                _currencyamount   = VALUE #( ( currencyrole           = '00'
                                                               journalentryitemamount = ls_item-journalentryitemamount
                                                               currency               = ls_item-currency ) ) ) ).

      APPEND LINES OF ls_deep_item TO <je_deep>-%param-_glitems.
    ENDLOOP.

    " Vendor Items
    DATA ls_deep_vendor LIKE <je_deep>-%param-_apitems.
    CLEAR : ls_deep_vendor.
    LOOP AT lt_doc_vendor_result INTO DATA(ls_vendor).
      ls_deep_vendor = VALUE #( ( glaccountlineitem = ls_vendor-glaccountlineitem
                                supplier            = ls_vendor-vendor
                                businessplace       = ls_vendor-businessplace
                                _currencyamount     = VALUE #( ( currencyrole           = '00'
                                                               journalentryitemamount = ls_vendor-journalentryitemamount
                                                               currency               = ls_vendor-currency ) ) ) ).

      APPEND LINES OF ls_deep_vendor TO <je_deep>-%param-_apitems.
    ENDLOOP.

    " Tax Items
    DATA ls_deep_tax LIKE <je_deep>-%param-_taxitems.
    CLEAR : ls_deep_tax.
    LOOP AT lt_doc_tax_result INTO DATA(ls_tax).
      ls_deep_tax = VALUE #( ( glaccountlineitem     = ls_tax-glaccountlineitem
                               taxcode               = ls_tax-taxcode
                               taxitemclassification = ls_tax-taxitemclassification
                               conditiontype         = ls_tax-conditiontype
                               _currencyamount       = VALUE #( ( currencyrole           = '00'
                                                                  journalentryitemamount = ls_tax-journalentryitemamount
                                                                  taxbaseamount          = ls_tax-taxbaseamount
                                                                  currency               = ls_tax-currency ) ) ) ).

      APPEND LINES OF ls_deep_tax TO <je_deep>-%param-_taxitems.
    ENDLOOP.



* simulation
    READ ENTITIES OF i_journalentrytp ##EML_READ_IN_LOCAL_MODE_OK
    ENTITY journalentry
    EXECUTE validate FROM CORRESPONDING #( lt_je_deep )
      RESULT DATA(lt_check_result)
      FAILED DATA(ls_failed)
      REPORTED DATA(ls_reported).

* simulation결과 실패이면 temp key를 통해 오류 정보를 save_modify쪽으로 넘겨서 cbo에 저장
    IF ls_failed IS NOT INITIAL.
      CLEAR ls_temp_key.

      LOOP AT ls_reported-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported>).
        ls_temp_key-simu_result = 'E'.
        ls_temp_key-simu_msg = <ls_reported>-%msg->if_message~get_text( ).
      ENDLOOP.

      ls_temp_key-cid = ls_header-docuuid.
      APPEND ls_temp_key TO lt_temp_key.

    ELSE.

* simulation 성공이면 실제 실전기 진행

      " Modify Entity (생성됨)
      MODIFY ENTITIES OF i_journalentrytp
       ENTITY journalentry
       EXECUTE post FROM lt_je_deep
       FAILED DATA(ls_failed_deep)
       REPORTED DATA(ls_reported_deep)
       MAPPED DATA(ls_mapped_deep).

      LOOP AT ls_mapped_deep-journalentry INTO DATA(ls_je_mapped).
        ls_temp_key-cid = ls_je_mapped-%cid.
        ls_temp_key-pid = ls_je_mapped-%pid.
        ls_temp_key-simu_result = 'S'.
        APPEND ls_temp_key TO lt_temp_key.
      ENDLOOP.

    ENDIF.

    zdoc_entry_handler=>get_instance( )->set_temp_key( lt_temp_key ).

  ENDMETHOD.

  METHOD reverse_document.

    DATA: lt_temp_key TYPE zdoc_entry_handler=>tt_temp_key,
          ls_temp_key LIKE LINE OF lt_temp_key.
    DATA: lt_je_deep    TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
          lt_je_reverse TYPE TABLE FOR ACTION IMPORT i_journalentrytp~reverse.

    " Doc UUID 기준으로 데이터 조회
    READ ENTITIES OF zi_doc_header IN LOCAL MODE
        ENTITY zi_doc_header
        ALL FIELDS WITH VALUE #( ( docuuid = params ) )
        RESULT DATA(lt_doc_result).

    APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<je_deep>).

    DATA(ls_header) = lt_doc_result[ 1 ].

    <je_deep>-%cid = ls_header-docuuid.
    <je_deep>-%param-companycode = ls_header-companycode.
    <je_deep>-%param-documentreferenceid = ls_header-documentreferenceid.
    <je_deep>-%param-createdbyuser = ls_header-createduser.
    <je_deep>-%param-businesstransactiontype = ls_header-businesstransactiontype.
    <je_deep>-%param-accountingdocumenttype = ls_header-accountingdocumenttype.
    <je_deep>-%param-documentdate = ls_header-documentdate.
    <je_deep>-%param-postingdate = ls_header-postingdate.
    <je_deep>-%param-accountingdocumentheadertext = ls_header-headertext.
    <je_deep>-%param-reversalreason = ls_header-reversalreason.
    <je_deep>-%param-reversalreferencedocumentkey = ls_header-reversalreferencedocumentkey.

* simulation
    READ ENTITIES OF i_journalentrytp ##EML_READ_IN_LOCAL_MODE_OK
    ENTITY journalentry
    EXECUTE validate FROM CORRESPONDING #( lt_je_deep )
      RESULT DATA(lt_check_result)
      FAILED DATA(ls_failed)
      REPORTED DATA(ls_reported).

* simulation결과 실패이면 temp key를 통해 오류 정보를 save_modify쪽으로 넘겨서 cbo에 저장
    IF ls_failed IS NOT INITIAL.
      CLEAR ls_temp_key.

      LOOP AT ls_reported-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported>).
        ls_temp_key-simu_result = 'E'.
        ls_temp_key-simu_msg = <ls_reported>-%msg->if_message~get_text( ).
      ENDLOOP.

      ls_temp_key-cid = ls_header-docuuid.
      APPEND ls_temp_key TO lt_temp_key.

    ELSE.

      APPEND INITIAL LINE TO lt_je_reverse ASSIGNING FIELD-SYMBOL(<je_reverse>).
      <je_reverse>-companycode = ls_header-companycode.
      <je_reverse>-fiscalyear = ls_header-reversalreferencedocumentkey+14(4).
      <je_reverse>-accountingdocument = ls_header-reversalreferencedocumentkey+0(10).
      <je_reverse>-%param-postingdate = ls_header-postingdate.
      <je_reverse>-%param-createdbyuser = ls_header-createduser.
      <je_reverse>-%param-reversalreason = ls_header-reversalreason.

* simulation 성공이면 실제 역분개 진행
      " Modify Entity (생성됨)
      MODIFY ENTITIES OF i_journalentrytp
       ENTITY journalentry
       EXECUTE reverse FROM lt_je_reverse
       FAILED DATA(ls_failed_re)
       REPORTED DATA(ls_reported_re)
       MAPPED DATA(ls_mapped_re).

      LOOP AT ls_mapped_re-journalentry INTO DATA(ls_mapped_redeep).
        ls_temp_key-cid = ls_mapped_redeep-%cid.
        ls_temp_key-pid = ls_mapped_redeep-%pid.
        ls_temp_key-simu_result = 'RS'.
        APPEND ls_temp_key TO lt_temp_key.
      ENDLOOP.

    ENDIF.

    zdoc_entry_handler=>get_instance( )->set_temp_key( lt_temp_key ).

  ENDMETHOD.
ENDCLASS.


CLASS lsc_zi_doc_header DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_doc_header IMPLEMENTATION.

  METHOD save_modified.
    "unmanaged save for table ytdoc_header
    DATA: lt_create TYPE TABLE OF ytdoc_header,
          lt_delete TYPE TABLE OF ytdoc_header.


    lt_create = CORRESPONDING #( create-zi_doc_header MAPPING FROM ENTITY ).
    lt_delete = CORRESPONDING #( delete-zi_doc_header MAPPING FROM ENTITY ).

    " cbo 테이블 저장
    zdoc_entry_handler=>get_instance( )->additional_save( it_create = lt_create
                                                          it_delete = lt_delete ).

  ENDMETHOD.


  METHOD cleanup_finalize.
    zdoc_entry_handler=>get_instance( )->clean_up( ).
  ENDMETHOD.

ENDCLASS.
