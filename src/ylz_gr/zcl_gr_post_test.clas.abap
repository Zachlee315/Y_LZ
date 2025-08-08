CLASS zcl_gr_post_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

    CONSTANTS:
      c_scenario TYPE string VALUE 'YZL_PPA_TEST',
      c_service  TYPE string VALUE 'ZLZ_PPA_POST_TEST_REST'.


    DATA: http_client TYPE REF TO zcl_cm_0001,
          utils       TYPE REF TO zcl_cm_0002,
          uri         TYPE string.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GR_POST_TEST IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


    CLEAR : uri.
*    uri = '/SAP__self.Post'.
    uri = '/SAP__self.Simulate'.
    DATA(json) = '{'
    && '"FiscalYear": "' && 2023 && '",'
    && '"ConsolidationVersion": "' && 'T10' && '", '
    && '"FiscalPeriod": "12", '
     && '"ConsolidationChartOfAccounts": "Y1", '
     && '"ConsolidationDocumentType": "Z3", '
     && '"ConsolidationUnit": "T100", '

    && '"_Item" : ['
    && '{'
    && ' "ConsolidationPostingItem" : "' && 1 && '",'
    && ' "FinancialStatementItem": "' && 161100 && '",'
    && ' "ConsolidationVersion": "' && 'T10' && '",'
    && ' "SubItem": "' && '915' && '",'
    && ' "AmountInLocalCurrency": -11000,'
    && ' "AmountInGroupCurrency": -11000,'
    && ' "AmountInTransactionCurrency": -11000,'
    && ' "LocalCurrency": "' && 'KRW' && '",'
    && ' "GroupCurrency": "' && 'KRW' && '",'
    && ' "TransactionCurrency": "' && 'KRW' && '",'
    && ' "ConsolidationUnit": "' && 'T100' && '"'
    && '},'
    && '{'
    && ' "ConsolidationPostingItem" : "' && 2 && '",'
    && ' "FinancialStatementItem": "' && 121100 && '",'
    && ' "ConsolidationVersion": "' && 'T10' && '",'
    && ' "SubItem": "' && '915' && '",'
    && ' "AmountInLocalCurrency": 11000,'
    && ' "AmountInGroupCurrency": 11000,'
    && ' "AmountInTransactionCurrency": 11000,'
    && ' "LocalCurrency": "' && 'KRW' && '",'
    && ' "GroupCurrency": "' && 'KRW' && '",'
    && ' "TransactionCurrency": "' && 'KRW' && '",'
    && ' "ConsolidationUnit": "' && 'T100' && '"'
    && '}'
    && ']}'.

    "get token
    CREATE OBJECT http_client
      EXPORTING
        i_scenario     = c_scenario
        i_service      = c_service
      EXCEPTIONS
        no_arrangement = 1.

    CHECK sy-subrc <> 1.

    DATA(token) = http_client->get_token_cookies( uri ).

    IF token IS NOT INITIAL.
      http_client->post(
      EXPORTING
      uri = uri
      json = json
      IMPORTING
      body = DATA(body)
      status = DATA(status)
      ).
    ENDIF.

    IF status EQ 200.

      DATA(lv_docnum) = substring_before( val = substring_after( val = body
      sub = '"ConsolidationDocumentNumber":"' )
      sub = '"' ).

      DATA(lv_gjahr) = substring_before( val = substring_after( val = body
      sub = '"FiscalYear":"' )
      sub = '"' ).
    ELSE.
      DATA(lv_msg) = substring_before( val = substring_after( val = body
      sub = '"message":"' )
      sub = '"' ).

    ENDIF.


  ENDMETHOD.
ENDCLASS.
