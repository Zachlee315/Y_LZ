CLASS zlz_gr_test_class DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZLZ_GR_TEST_CLASS IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    " types : BEGIN OF ty_tcurr,
    " KURST     type I_ExchangeRateRawData-ExchangeRateType,
    " FCURR     type I_ExchangeRateRawData-SourceCurrency,
    " TCURR     type I_ExchangeRateRawData-TargetCurrency,
    " GDATU     type I_ExchangeRateRawData-ValidityStartDate,
    " ZDATE_EVE type ZGRAT5210-ZDATE_EVE,   "변동일자
    " UKURS     type I_ExchangeRateRawData-ExchangeRate,
    " FFACT     type I_ExchangeRateRawData-NumberOfSourceCurrencyUnits,
    " TFACT     type I_ExchangeRateRawData-NumberOfTargetCurrencyUnits,
    " END OF ty_tcurr.
    "
    " SELECT -
    " FROM I_ExchangeRateRawData
    " INTO TABLE @DATA(lt_tab).
    " IF sy-subrc EQ 0 .
    " ENDIF.

**     SELECT *
**     FROM zgrat5200
**     INTO TABLE @DATA(lt_del).
**
**     DELETE  zgrat5200 FROM TABLE @lt_del.

    " DATA: system_uuid TYPE REF TO if_system_uuid,
    " uuid        TYPE sysuuid_c32.
    "
    " DO 1 TIMES.
    " system_uuid = cl_uuid_factory=>create_system_uuid( ).
    " ENDDO.
    "
**     DATA : lt_lock TYPE STANDARD TABLE OF zbs_dmo_lock.
**     lt_lock = VALUE #( ( CLIENT = '080' identification = '1' description = '최초' )
******     ( CLIENT = '080' VALUE = 'B' TEXT = '상각' )
******     ( CLIENT = '080' VALUE = 'C' TEXT = '손상' )
******     ( CLIENT = '080' VALUE = 'D' TEXT = '처분' )
******     ( CLIENT = '080' VALUE = 'E' TEXT = '최초상각' )
******     ( CLIENT = '080' VALUE = 'F' TEXT = '상각종료' )
**     ).
**     INSERT zbs_dmo_lock FROM TABLE @lt_lock.


    " 환율 테스트

    " 환율 등록
**    DATA lt_exchange_rates TYPE cl_exchange_rates=>ty_exchange_rates.
**    DATA ls_exchange_rate  TYPE cl_exchange_rates=>ty_exchange_rate.
**
**    CLEAR ls_exchange_rate.
**    ls_exchange_rate-rate_type   = 'CLO'.
**    ls_exchange_rate-from_curr   = 'USD'.
**    ls_exchange_rate-to_currncy  = 'KRW'.
**    ls_exchange_rate-valid_from  = '20250331'.
**
**    ls_exchange_rate-from_factor = '1'.
**    ls_exchange_rate-to_factor   = '100'.
**    ls_exchange_rate-exch_rate   = '14.15200'.
**    APPEND ls_exchange_rate TO lt_exchange_rates.
**    DATA(lt_result) = cl_exchange_rates=>put( exchange_rates = lt_exchange_rates[] ).
**
**    LOOP AT lt_result INTO DATA(ls_result).
**      IF ls_result-type <> 'E'.
**
**      ELSE.
**
**      ENDIF.
**    ENDLOOP.
    " 환율 조회

**    DATA: lv_exchange_rate TYPE cl_exchange_rates=>ty_convert_curr-ukurs,
**          lv_local_factor  TYPE cl_exchange_rates=>ty_convert_curr-ffact,
**          lv_amount_no_dec TYPE p LENGTH 13,
**          lv_sum_tax_lc      TYPE zgrat5210-zamt_tax_lc.
**
**    TRY.
**        cl_exchange_rates=>convert_to_local_currency( EXPORTING date             = '20240131'
**                                                                foreign_amount   = lv_sum_tax_lc
**                                                                foreign_currency = 'USD'
**                                                                local_currency   = 'KRW'
**                                                                rate_type        = 'CLO'
**                                                      IMPORTING exchange_rate    = lv_exchange_rate
**                                                                local_factor     = lv_local_factor ).
**
***        IF ls_request-local_currency = 'KRW' OR
***           ls_request-local_currency = 'JPY' OR
***           ls_request-local_currency = 'VND'.
***
***          lv_amount_no_dec = ls_request-foreign_amount * lv_exchange_rate * lv_local_factor.
***          ls_return-local_amount = lv_amount_no_dec.
***        ELSE.
**          data(local_amount) =  lv_sum_tax_lc * lv_exchange_rate * lv_local_factor.
***        ENDIF.
**
**      CATCH cx_exchange_rates.
**        DATA(error_exchange) = 'no exchange rate'.
**    ENDTRY.

*    TYPES:
*      BEGIN OF my_struct,
*        fieldname TYPE c LENGTH 50,
*        key       TYPE c LENGTH 1,
*      END OF my_struct.
*
*
*    DATA: ls_key_field TYPE my_struct,
*          lt_key_field TYPE STANDARD TABLE OF  my_struct WITH EMPTY KEY.
*
*    DATA: ref_table_des TYPE REF TO cl_abap_structdescr,
*          ref_type      TYPE REF TO cl_abap_typedescr.
*
** Get the structure of the table.
*    cl_abap_typedescr=>describe_by_name(
*          EXPORTING
*            p_name         = 'ZGRAT5200'
*          RECEIVING
*            p_descr_ref    = ref_type
*          EXCEPTIONS
*            type_not_found = 1
*            OTHERS         = 2
*        ).
*    IF sy-subrc <> 0.
*    ENDIF.
*    CHECK sy-subrc = 0.
*
*    ref_table_des ?= ref_type.



**    TYPES tab_type TYPE STANDARD  TABLE OF ZGRAT5200 WITH DEFAULT KEY .
**    DATA itab TYPE tab_type.

*****DATA it13 TYPE HASHED TABLE OF ZGRAT5200
*****  WITH UNIQUE DEFAULT KEY.
*****
*****    DATA(tdo_d) = cl_abap_typedescr=>describe_by_data( it13 ).
*****    "DATA(tdo_d) = cl_abap_typedescr=>describe_by_name( 'TAB_TYPE' ).
*****
*****    "Cast to get more specific information
*****    DATA(tdo_itab) = CAST cl_abap_tabledescr( cl_abap_typedescr=>describe_by_data( it13 ) ).
*****    "DATA(tdo_itab) = CAST cl_abap_tabledescr( tdo_d ).
*****
*****    DATA(type_category_itab) = tdo_itab->kind.
*****    DATA(relative_name_itab) = tdo_itab->get_relative_name( ).
*****    ... "Explore more options by positioning the cursor behind -> and choosing CTRL + Space
*****    DATA(table_kind_itab) = tdo_itab->table_kind.
*****    DATA(table_keys_itab) = tdo_itab->key.
*****    DATA(table_keys_more_details_itab) = tdo_itab->get_keys( ).
*****    DATA(table_has_unique_key_itab) = tdo_itab->has_unique_key.
*****    DATA(table_key_alias_itab) = tdo_itab->get_key_aliases( ).
*****    DATA(line_type_itab) = tdo_itab->get_table_line_type( ).
*****    DATA(table_component_info_itab) = CAST cl_abap_structdescr( tdo_itab->get_table_line_type( ) ).
*****    DATA(table_components_itab) = CAST cl_abap_structdescr( tdo_itab->get_table_line_type( ) )->components.
*****    DATA(table_comps_more_info_itab) = CAST cl_abap_structdescr( tdo_itab->get_table_line_type( ) )->get_components( ).
*******    DATA(applies_to_data_itab) = tdo_itab->applies_to_data( VALUE tab_type( ) ).


**DATA : LV_BUNIT TYPE ZGRAT5200-RBUNIT.
**
**LV_BUNIT = 'T200'.
**
**DATA(LV_UNAME) = SY-UNAME.
**
**AUTHORITY-CHECK OBJECT 'E_CS_BUNIT'
**ID 'BUNIT' FIELD LV_BUNIT
**ID 'DIMEN' FIELD 'Y1'
**ID 'ACTVT' FIELD '01'.
**
**
**
**
**
**
**IF SY-SUBRC <> 0.
**  DATA(LV_MSG) = ' 권한없음'.
**ENDIF.


*SELECT * FROM I_CnsldtnLedger
*INTO TABLE @DATA(LT_TAB).

**    " lock object test
**    TRY.
**        DATA(lo_lock) = cl_abap_lock_object_factory=>get_instance( 'EZBS_DEMO_LOCK' ).
**
**        lo_lock->enqueue( it_parameter = VALUE #( ( name = 'IDENTIFICATION' value = REF #( 1 ) ) ) ).
**
**      CATCH cx_abap_foreign_lock INTO DATA(lo_locked).
**        out->write( |Locked by { lo_locked->user_name }| ).
**      CATCH cx_abap_lock_failure.
**        out->write( `Failed ...` ).
**    ENDTRY.



  ENDMETHOD.
ENDCLASS.
