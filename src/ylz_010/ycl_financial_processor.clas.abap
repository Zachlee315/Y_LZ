CLASS ycl_financial_processor DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      process_inbound_data RAISING cx_static_check,
      process_outbound_confirmation RAISING cx_static_check,
      test_inbound_outbound_flow RAISING cx_static_check.

  PRIVATE SECTION.
    METHODS:
      create_inbound_proxy RETURNING VALUE(ro_proxy) TYPE REF TO ZSTD_INCO_FINANCIAL_CONSOLIDAT,
      create_outbound_proxy RETURNING VALUE(ro_proxy) TYPE REF TO zsoapco_financial_consolidatio
      ,
      handle_error IMPORTING ix_error TYPE REF TO cx_root RAISING cx_static_check,
      log_message IMPORTING iv_message TYPE string.

    DATA: mv_inbound_uuid TYPE sysuuid_x16.  " 인바운드 UUID를 저장할 속성

ENDCLASS.



CLASS YCL_FINANCIAL_PROCESSOR IMPLEMENTATION.


  METHOD create_inbound_proxy.
    DATA(lo_destination) = cl_soap_destination_provider=>create_by_comm_arrangement(
*      comm_scenario  = 'CS_SAP_COM_0248'
*      service_id     = 'FINCS_RPTDFINDATABULKIN_WEBI'
*      comm_system_id = 'YLZ_COSTCENTER'
      comm_scenario  = 'YCS_SOAP_IN'
      service_id     = 'ZLZ_SOAP_TEST_SPRX'
      comm_system_id = 'YLZ_COSTCENTER'
    ).

    ro_proxy = NEW ZSTD_INCO_FINANCIAL_CONSOLIDAT(
      destination = lo_destination
    ).
  ENDMETHOD.


  METHOD create_outbound_proxy.
    .
*    DATA(lo_destination) = cl_soap_destination_provider=>create_by_comm_arrangement(
**      comm_scenario  = 'CS_SAP_COM_0248'
**      service_id     = 'CO_FINCS_RFD_BULK_OUT_SPRX'
**      comm_system_id = 'YLZ_COSTCENTER'
*      comm_scenario  = 'ZCS_GR_OUT_001'
*      service_id     = 'ZSTD_GR_OUT_001_SPRX'
*      comm_system_id = 'Z_SYSTEM_REST'
*    ).
*
*
*
*    ro_proxy = NEW zsoapco_financial_consolidatio(
*      destination = lo_destination
*    ).


    .
  ENDMETHOD.


  METHOD handle_error.
    log_message( |Error occurred: { ix_error->get_text( ) }| ).

  ENDMETHOD.


  METHOD log_message.

  ENDMETHOD.


  METHOD process_inbound_data.
    TRY.
        DATA(lo_inbound_proxy) = create_inbound_proxy( ).

        DATA: ls_item TYPE ZSTD_INREPORTED_FINANCIAL_DAT7.

        ls_item-row_number = 1.
        ls_item-partner_consolidation_unit = 'T100'.
        ls_item-financial_statement_item = '111200'.
        ls_item-subitem_category = 1.
        ls_item-subitem = 915.

* Currency values
        DATA: ls_amount_transaction_currency TYPE zamount3,
              ls_amount_local_currency       TYPE zamount3,
              ls_amount_group_currency       TYPE zamount3.

        ls_amount_transaction_currency-currency_code = 'KRW'.
        ls_amount_transaction_currency-content = '1000.00'.
        ls_item-amount_in_transaction_currency = ls_amount_transaction_currency.

        ls_amount_local_currency-currency_code = 'KRW'.
        ls_amount_local_currency-content = '1200.00'.
        ls_item-amount_in_local_currency = ls_amount_local_currency.

        ls_amount_group_currency-currency_code = 'KRW'.
        ls_amount_group_currency-content = '1100.00'.
        ls_item-amount_in_group_currency = ls_amount_group_currency.


        DATA: lt_items                   TYPE zstd_inreported_financial__tab,
              ls_reported_financial_data TYPE zstd_inreported_financial_dat8.

        APPEND ls_item TO lt_items.

        ls_reported_financial_data-consolidation_unit = 'T100'.
        ls_reported_financial_data-item = lt_items.



        DATA: lt_reported_data_create TYPE zstd_inreported_financial_tab1,
              ls_reported_data_creat  TYPE ZSTD_INREPORTED_FINANCIAL_DAT3, " 데이터 타입 수정
              ls_global_parameter     TYPE zstd_inreported_financial_dat2,
              ls_action_control       TYPE zstd_inreported_financial_dat4,
              ls_reported_data_bulk   TYPE zstd_inreported_financial_dat5,
              ls_message_header       TYPE zstd_inbusiness_document_mess3.

        DATA(lv_uuid) = cl_system_uuid=>create_uuid_x16_static( ).
        mv_inbound_uuid = lv_uuid.  " 생성된 UUID를 클래스 속성에 저장

*        ls_message_header-creation_date_time =  '20240801000000'.
        ls_message_header-sender_business_system_id = 'YLZ_BS'.
        ls_message_header-uuid-content = lv_uuid.
        ls_message_header-id-content = 'YLZ_BS'.



        " ls_reported_financial_data의 타입이 아닌 ls_reported_data_creat의 타입으로 변환
        ls_reported_data_creat-reported_financial_data = ls_reported_financial_data.
        ls_reported_data_creat-message_header = ls_message_header.

* Append reported data
        APPEND ls_reported_data_creat TO lt_reported_data_create.


* Global parameter 설정
        ls_global_parameter-consolidation_version = 'T10'.
        ls_global_parameter-consolidation_chart_of_account = 'Y1'.
        ls_global_parameter-fiscal_year = '2023'.
        ls_global_parameter-fiscal_period = '12'.

* Action control 설정
        ls_action_control-update_mode = 5.
        ls_action_control-is_data_periodic = abap_true.

* Bulk 데이터에 각 필드 할당
        ls_reported_data_bulk-message_header = ls_message_header.
        ls_reported_data_bulk-global_parameter = ls_global_parameter.
        ls_reported_data_bulk-action_control = ls_action_control.
        ls_reported_data_bulk-reported_financial_data_create = lt_reported_data_create.


        DATA: ls_final_structure TYPE zstd_inreported_financial_dat6.

        ls_final_structure-reported_financial_data_bulk_c = ls_reported_data_bulk.

        DATA(ls_request) = VALUE ZSTD_INREPORTED_FINANCIAL_DAT6( reported_financial_data_bulk_c = ls_reported_data_bulk ).


        lo_inbound_proxy->reported_financial_data_create(
          EXPORTING
            input = ls_request
        ).

        COMMIT WORK.

        log_message( 'Inbound data processed successfully.' ).

      CATCH cx_root INTO DATA(lx_error).
        handle_error( lx_error ).
    ENDTRY.
  ENDMETHOD.


  METHOD process_outbound_confirmation.
    TRY.
        DATA(lo_outbound_proxy) = create_outbound_proxy( ).

        DATA: ls_final_structure    TYPE zsoapreported_financial_data_2,
              ls_reported_data_bulk TYPE zsoapreported_financial_data_b,
              ls_message_header     TYPE zbusiness_document_message_h12.
        DATA: lv_timestamp TYPE timestamp.
        GET TIME STAMP FIELD lv_timestamp.
        " 메시지 헤더 설정
        DATA: lv_timestamp_str TYPE string.

        lv_timestamp_str = |{ lv_timestamp TIMESTAMP = ISO }|.
*        ls_message_header-creation_date_time = lv_timestamp_str.
        ls_message_header-sender_business_system_id = 'YLZ_BS'.
        ls_message_header-uuid-content = cl_system_uuid=>create_uuid_x16_static( ).
        ls_message_header-reference_uuid-content = mv_inbound_uuid.


        ls_reported_data_bulk-message_header = ls_message_header.

        ls_final_structure-reported_financial_data_bulk_c = ls_reported_data_bulk.

        " 프록시 호출
        lo_outbound_proxy->confirm_reported_financial_dat(
          EXPORTING
            input = ls_final_structure
        ).

        " 성공 메시지 로깅
        log_message( |Outbound confirmation sent successfully. UUID: { ls_message_header-uuid-content }| ).
        log_message( |Referenced inbound UUID: { ls_message_header-reference_uuid-content }| ).

        COMMIT WORK.

      CATCH cx_root INTO DATA(lx_error).
        handle_error( lx_error ).
    ENDTRY.
  ENDMETHOD.


  METHOD test_inbound_outbound_flow.
    TRY.
        log_message( 'Starting inbound-outbound flow test.' ).

        " Process inbound data
        process_inbound_data( ).

        " Instead of waiting, we'll just log a message
        log_message( 'Inbound processing completed. In a real scenario, there might be a delay here.' ).

*        " Process outbound confirmation
*        process_outbound_confirmation( ).
*
*        log_message( 'Inbound-outbound flow test completed successfully.' ).

      CATCH cx_root INTO DATA(lx_error).
        handle_error( lx_error ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
