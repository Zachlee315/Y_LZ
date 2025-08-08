CLASS ylz_test_class DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS YLZ_TEST_CLASS IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

SELECT *
FROM ZLZ_MAIL_r_RECIP
into TABLE @data(lt_tmp).

if sy-subrc eq 0.
endif.

*    MODIFY ENTITIES OF zi_doc_header
*    ENTITY zi_doc_header
*    DELETE FROM
*    VALUE #( ( docuuid = '00000000-0000-0000-0000-000000000000') )
*    FAILED DATA(failed)
*    REPORTED DATA(reported).
*
*    COMMIT ENTITIES BEGIN
*     RESPONSE OF zi_doc_header
*     FAILED DATA(lt_commit_failed)
*     REPORTED DATA(lt_commit_reported).
** ...
*    COMMIT ENTITIES END.

*      READ ENTITIES OF i_journalentrytp
*        ENTITY journalentry
*        all FIELDS WITH VALUE #( ( companycode = '4310' fiscalyear = '2024' accountingdocument = '1900000024' ) )
*        RESULT DATA(read_result)
*        FAILED DATA(read_failed)
*        REPORTED DATA(read_reported).

*          using number range to generate the building id
***          cl_numberrange_runtime=>number_get(
***            EXPORTING
***              nr_range_nr       = '01'
***              object            = 'ZNR_10_NO'
***              quantity          = 1
***            IMPORTING
***              number            = DATA(number)
***              returncode        = DATA(ret_code)
***              returned_quantity = DATA(ret_qty)
***          ).


**    DATA: lt_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
**          lv_cid     TYPE abp_behv_cid.
**
**
**
**    TRY.
**        lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
**      CATCH cx_uuid_error.
**        ASSERT 1 = 0.
**    ENDTRY.
**
**
**    APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<je_deep>).
**    <je_deep>-%cid = lv_cid.
**    <je_deep>-%param = VALUE #(
**        companycode                  = '4310' " Success
**        documentreferenceid          = 'BKPFF'
**        createdbyuser                = 'CB9980000045'
**        businesstransactiontype      = 'RFIV'
**        accountingdocumenttype       = 'KR'
**        documentdate                 = '20240312'
**        postingdate                  = '20240312'
**        accountingdocumentheadertext = 'RAP 생성'
**        TaxDeterminationDate         = '20240312'
**        _glitems                     = VALUE #(
**            ( glaccountlineitem = |001|
**              glaccount         = '0061004000'
**              costcenter        = '0043101301'
**              documentitemtext  = '비용아이템'
**              taxcode           = 'V5'
**              _currencyamount   = VALUE #( ( currencyrole = '00' journalentryitemamount = '100.00' currency = 'KRW' ) ) )
**
**            ( glaccountlineitem = |002|
**              glaccount         = '0061004000'
**              costcenter        = '0043101301'
**              documentitemtext  = '비용아이템'
**              taxcode           = 'V5'
**              _currencyamount   = VALUE #( ( currencyrole = '00' journalentryitemamount = '100.00' currency = 'KRW' ) ) )
**               )
**        _apitems                     = VALUE #(
**            ( glaccountlineitem = |003|
**              supplier        = '1000030'
**              businessplace   = '4310'
**              _currencyamount = VALUE #( ( currencyrole = '00' journalentryitemamount = '-220.00' currency = 'KRW' ) ) ) )
**        _taxitems                    = VALUE #(
**            ( glaccountlineitem = |004|
**              taxcode               = 'V5'
**              taxitemclassification = 'VST'
**              ConditionType         = 'MWVS'
**              _currencyamount       = VALUE #( ( journalentryitemamount = '20.00' taxbaseamount = '200.00' currency = 'KRW' ) ) ) )
**        ).
**
**
**    MODIFY ENTITIES OF i_journalentrytp
**     ENTITY journalentry
**     EXECUTE post FROM lt_je_deep
**     FAILED DATA(ls_failed_deep)
**     REPORTED DATA(ls_reported_deep)
**     MAPPED DATA(ls_mapped_deep).
**
**    IF ls_failed_deep IS NOT INITIAL.
**
**
**      LOOP AT ls_reported_deep-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep>).
**        DATA(lv_result) = <ls_reported_deep>-%msg->if_message~get_text( ).
*** ...
**      ENDLOOP.
**    ELSE.
**
**
**      COMMIT ENTITIES BEGIN
**       RESPONSE OF i_journalentrytp
**       FAILED DATA(lt_commit_failed)
**       REPORTED DATA(lt_commit_reported).
*** ...
**      COMMIT ENTITIES END.
**    ENDIF.

*****     DATA :lt_header TYPE TABLE FOR UPDATE zi_doc_header,
*****           ls_header TYPE STRUCTURE FOR UPDATE zi_doc_header.
****
****    " CBO 데이터 조회
****    READ ENTITIES OF zi_doc_header IN LOCAL MODE
****         ENTITY zi_doc_header
****         ALL FIELDS
****           " keys 값 설정
****         WITH CORRESPONDING #( keys )
****         RESULT DATA(lt_header_result)
****         FAILED    DATA(lt_failed)
****         REPORTED  DATA(lt_reported).
****
****    " Standard API 호출
****    DATA(key) = keys[ 1 ].
****
****    " Doc UUID 기준으로 데이터 조회
****    READ ENTITIES OF zi_doc_header IN LOCAL MODE
*****        ENTITY zi_doc_header
*****        ALL FIELDS WITH VALUE #( ( docuuid = key-docuuid ) )
*****        RESULT DATA(lt_doc_input)
****        "Item 조회
****        ENTITY zi_doc_header BY \_item
****        ALL FIELDS WITH VALUE #( ( docuuid = key-docuuid ) )
****        RESULT DATA(lt_doc_item_input)
****        "vendor 조회
****        ENTITY zi_doc_header BY \_vendor
****        ALL FIELDS WITH VALUE #( ( docuuid = key-docuuid ) )
****        RESULT DATA(lt_doc_vendor_input)
****        "tax 조회
****        ENTITY zi_doc_header BY \_tax
****        ALL FIELDS WITH VALUE #( ( docuuid = key-docuuid ) )
****        RESULT DATA(lt_doc_tax_input).
****
****    " 읽어온 ENTITY 값들로 I_JOURNALENTRYTP 생성 데이터 만들기
****    DATA: lt_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
****          lv_cid     TYPE abp_behv_cid.
****
****    TRY.
****        lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
****      CATCH cx_uuid_error.
****        ASSERT 1 = 0.
****    ENDTRY.
****
****    APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<je_deep>).
****    <je_deep>-%cid = lv_cid.
****
****    " 전표헤더
****    DATA(ls_header) = lt_header_result[ 1 ].
****    <je_deep>-%param-companycode = ls_header-companycode.
****    <je_deep>-%param-documentreferenceid = ls_header-documentreferenceid.
****    <je_deep>-%param-createdbyuser = ls_header-createduser.
****    <je_deep>-%param-businesstransactiontype = ls_header-businesstransactiontype.
****    <je_deep>-%param-accountingdocumenttype = ls_header-accountingdocumenttype.
****    <je_deep>-%param-documentdate = ls_header-documentdate.
****    <je_deep>-%param-postingdate = ls_header-postingdate.
****    <je_deep>-%param-accountingdocumentheadertext = ls_header-headertext.
****    <je_deep>-%param-taxdeterminationdate = ls_header-taxdeterminationdate.
****
****    " Items(G/L)
****    DATA ls_deep_item LIKE <je_deep>-%param-_glitems.
****    CLEAR : ls_deep_item.
****    LOOP AT lt_doc_item_result INTO DATA(ls_item).
****      ls_deep_item = VALUE #( ( glaccountlineitem = ls_item-glaccountlineitem
****                                glaccount         = ls_item-glaccount
****                                costcenter        = ls_item-costcenter
****                                documentitemtext  = ls_item-documentitemtext
****                                taxcode           = ls_item-taxcode
****                                _currencyamount   = VALUE #( ( currencyrole           = '00'
****                                                               journalentryitemamount = ls_item-journalentryitemamount
****                                                               currency               = ls_item-currency ) ) ) ).
****
****      APPEND LINES OF ls_deep_item TO <je_deep>-%param-_glitems.
****    ENDLOOP.
****
****    " Vendor Items
****    DATA ls_deep_vendor LIKE <je_deep>-%param-_apitems.
****    CLEAR : ls_deep_vendor.
****    LOOP AT lt_doc_vendor_result INTO DATA(ls_vendor).
****      ls_deep_vendor = VALUE #( ( glaccountlineitem = ls_vendor-glaccountlineitem
****                                supplier            = ls_vendor-vendor
****                                businessplace       = ls_vendor-businessplace
****                                _currencyamount     = VALUE #( ( currencyrole           = '00'
****                                                               journalentryitemamount = ls_vendor-journalentryitemamount
****                                                               currency               = ls_vendor-currency ) ) ) ).
****
****      APPEND LINES OF ls_deep_vendor TO <je_deep>-%param-_apitems.
****    ENDLOOP.
****
****    " Tax Items
****    DATA ls_deep_tax LIKE <je_deep>-%param-_taxitems.
****    CLEAR : ls_deep_tax.
****    LOOP AT lt_doc_tax_result INTO DATA(ls_tax).
****      ls_deep_tax = VALUE #( ( glaccountlineitem     = ls_tax-glaccountlineitem
****                               taxcode               = ls_tax-Taxcode
****                               taxitemclassification = ls_tax-Taxitemclassification
****                               ConditionType         = ls_tax-Conditiontype
****                               _currencyamount       = VALUE #( ( currencyrole           = '00'
****                                                                  journalentryitemamount = ls_tax-journalentryitemamount
****                                                                  Taxbaseamount          = ls_tax-Taxbaseamount
****                                                                  currency               = ls_tax-currency ) ) ) ).
****
****      APPEND LINES OF ls_deep_tax TO <je_deep>-%param-_taxitems.
****    ENDLOOP.
****
****    " Modify Entity
****    MODIFY ENTITIES OF i_journalentrytp
****     ENTITY journalentry
****     EXECUTE post FROM lt_je_deep
****     FAILED DATA(ls_failed_deep)
****     REPORTED DATA(ls_reported_deep)
****     MAPPED DATA(ls_mapped_deep).
****
****     " fail
****     IF ls_failed_deep IS NOT INITIAL.
****      LOOP AT ls_reported_deep-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep>).
****        DATA(lv_result) = <ls_reported_deep>-%msg->if_message~get_text( ).
****
****      ENDLOOP.
****
****    ELSE.
****     " Success
****
*****      COMMIT ENTITIES BEGIN
*****       RESPONSE OF i_journalentrytp
*****       FAILED DATA(lt_commit_failed)
*****       REPORTED DATA(lt_commit_reported).
****** ...
*****      COMMIT ENTITIES END.
****    ENDIF.
  ENDMETHOD.
ENDCLASS.
