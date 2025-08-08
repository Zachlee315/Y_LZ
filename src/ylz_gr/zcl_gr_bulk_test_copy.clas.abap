CLASS zcl_gr_bulk_test_copy DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS handle_error IMPORTING ix_error TYPE REF TO cx_root
                         RAISING   cx_static_check.

    METHODS log_message IMPORTING iv_message TYPE string.

    DATA mv_inbound_uuid TYPE sysuuid_x16.
ENDCLASS.



CLASS ZCL_GR_BULK_TEST_COPY IMPLEMENTATION.


  METHOD handle_error.
    log_message( |Error occurred: { ix_error->get_text( ) }| ).

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    DATA ls_item                        TYPE zasgr_bulk_createreported_fin7.
    DATA ls_amount_transaction_currency TYPE zasgr_bulk_createamount.
    DATA ls_amount_local_currency       TYPE zasgr_bulk_createamount.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA ls_amount_group_currency       TYPE zasgr_bulk_createamount.
    DATA lt_reported_data_create        TYPE zasgr_bulk_createreported_tab1.
    DATA ls_reported_data_create        TYPE zasgr_bulk_createreported_fin3. " 데이터 타입 수정
    DATA ls_global_parameter            TYPE zasgr_bulk_createreported_fin2.
    DATA ls_action_control              TYPE zasgr_bulk_createreported_fin4.
    DATA ls_reported_data_bulk          TYPE zasgr_bulk_createreported_fin5.
    DATA ls_message_header              TYPE zasgr_conbusiness_document_me3.
    DATA ls_message_header_for_items    TYPE zasgr_conbusiness_document_me3.

    DATA lt_items                       TYPE zasgr_bulk_createreported__tab.
    DATA ls_reported_financial_data     TYPE zasgr_bulk_createreported_fin8.

    TRY.

        DATA(lv_uuid_header) = cl_system_uuid=>create_uuid_x16_static( ).

        CLEAR : ls_item,
                ls_amount_transaction_currency,
                ls_amount_local_currency,
                ls_amount_group_currency.
        ls_item-row_number               = 1.
        ls_item-financial_statement_item = '121100'.
        ls_item-subitem_category         = '1'.
        ls_item-subitem                  = '915'.
        ls_item-yy1_example_field        = lv_uuid_header.

        " Currency values
        ls_amount_transaction_currency-currency_code = 'KRW'.
        ls_amount_transaction_currency-content       = '1400'.
        ls_item-amount_in_transaction_currency = ls_amount_transaction_currency.

        ls_amount_local_currency-currency_code = 'KRW'.
        ls_amount_local_currency-content       = '1400'.
        ls_item-amount_in_local_currency = ls_amount_local_currency.
        APPEND ls_item TO lt_items.

        CLEAR : ls_item,
                ls_amount_transaction_currency,
                ls_amount_local_currency,
                ls_amount_group_currency.
        ls_item-row_number               = 2.
        ls_item-financial_statement_item = '121100'.
        ls_item-subitem_category         = '1'.
        ls_item-subitem                  = '915'.
        ls_item-yy1_example_field        = lv_uuid_header.

        " Currency values
        ls_amount_transaction_currency-currency_code = 'KRW'.
        ls_amount_transaction_currency-content       = '-1400'.
        ls_item-amount_in_transaction_currency = ls_amount_transaction_currency.

        ls_amount_local_currency-currency_code = 'KRW'.
        ls_amount_local_currency-content       = '-1400'.
        ls_item-amount_in_local_currency = ls_amount_local_currency.
        APPEND ls_item TO lt_items.

        ls_reported_financial_data-consolidation_unit = 'T100'.
        ls_reported_financial_data-item               = lt_items.

        ls_message_header-sender_business_system_id = 'ZASGR'.
        ls_message_header-uuid-content = lv_uuid_header.
        ls_message_header-id-content = lv_uuid_header.

        ls_reported_data_create-reported_financial_data = ls_reported_financial_data.
        ls_reported_data_create-message_header          = ls_message_header.

        " Append reported data
        APPEND ls_reported_data_create TO lt_reported_data_create.

        " Global parameter 설정
        ls_global_parameter-consolidation_version          = 'T10'.
        ls_global_parameter-consolidation_chart_of_account = 'Y1'.
        ls_global_parameter-fiscal_year                    = '2023'.
        ls_global_parameter-fiscal_period                  = '12'.

        " Action control 설정
        ls_action_control-update_mode                 = 5.
        ls_action_control-is_data_periodic            = abap_true.
        ls_action_control-consolidation_document_type = '07'.

        " Bulk 데이터에 각 필드 할당
        ls_message_header_for_items-uuid-content = lv_uuid_header.
        ls_message_header_for_items-sender_business_system_id = 'ZASGR'.
        ls_message_header_for_items-id-content = lv_uuid_header.
        ls_reported_data_bulk-message_header                 = ls_message_header_for_items.
        ls_reported_data_bulk-global_parameter               = ls_global_parameter.
        ls_reported_data_bulk-action_control                 = ls_action_control.
        ls_reported_data_bulk-reported_financial_data_create = lt_reported_data_create.

        DATA(destination) = cl_soap_destination_provider=>create_by_comm_arrangement(
                                comm_scenario  = 'ZASGR_BULK_CREATION'
                                service_id     = 'ZASGR_BULK_CREATE_SPRX'
                                comm_system_id = 'ZASGR' ).

        DATA(proxy) = NEW zasgr_bulk_createco_financial( destination = destination ).

        " fill request
        DATA(request) = VALUE zasgr_bulk_createreported_fin6( reported_financial_data_bulk_c = ls_reported_data_bulk ).

        proxy->reported_financial_data_create( input = request ).

        " trigger async call
        COMMIT WORK.

        log_message( 'Inbound data processed successfully.' ).
      CATCH cx_soap_destination_error INTO DATA(destination_error).
        handle_error( destination_error ).
      CATCH cx_ai_system_fault INTO DATA(system_fault).
        handle_error( system_fault ).
        " handle error
    ENDTRY.
  ENDMETHOD.


  METHOD log_message.

  ENDMETHOD.
ENDCLASS.
