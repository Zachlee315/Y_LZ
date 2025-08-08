CLASS lhc_zif_r_outsourcing DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zif_r_outsourcing RESULT result.

    METHODS create FOR DETERMINE ON SAVE
      IMPORTING keys FOR zif_r_outsourcing~create.

    TYPES:
      "스탠다드 API Response Information
      BEGIN OF post_result,
        post_body   TYPE string,
        post_status TYPE string,
      END OF post_result.

    CONSTANTS:
      c_scenario TYPE string VALUE 'YCS_OUTBOUND_001',
      c_service1 TYPE string VALUE 'Z_MAT_DOCUMENT_REST',
      c_service2 TYPE string VALUE 'Z_MES_OUTSOURCING_REST',
      c_service3 TYPE string VALUE 'Z_GET_SUPPLIER_REST'.

    DATA: http_client    TYPE REF TO zcl_cm_0001,
          utils          TYPE REF TO zcl_cm_0002,
          uri            TYPE string,
          order_currency TYPE string,
          pr_number      TYPE string.



ENDCLASS.

CLASS lhc_zif_r_outsourcing IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
    DATA : ls_update TYPE STRUCTURE FOR UPDATE zif_r_outsourcing,
           lt_update TYPE TABLE FOR UPDATE zif_r_outsourcing.

    CREATE OBJECT utils.

    CHECK sy-subrc <> 1.

    READ ENTITIES OF zif_r_outsourcing IN LOCAL MODE
         ENTITY zif_r_outsourcing
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_result)
         FAILED    DATA(lt_failed)
         REPORTED  DATA(lt_reported).

    DATA(ls_result) = lt_result[ 1 ].
    ls_update = CORRESPONDING #( ls_result ).
    DATA(lv_jobid) = ls_result-jobid.
    DATA(lv_orderdate) = ls_result-orderdate.
*    |{ ls_result-orderdate+0(4) }-{ ls_result-orderdate+4(2) }-{ ls_result-orderdate+6(2) }T00:00:00|.

    DATA(lv_orderprice) = ls_result-orderprice.
    DATA(lv_supplier) = ls_result-subconstractorid.
    DATA(lv_itemnum) = VALUE numc5( ).


    "Get subconstractor Currency
    CREATE OBJECT http_client
      EXPORTING
        i_scenario     = c_scenario
        i_service      = c_service3
      EXCEPTIONS
        no_arrangement = 1.

    CHECK sy-subrc <> 1.

    CLEAR : uri.
    uri = |/A_SupplierPurchasingOrg(Supplier='{ lv_supplier }',PurchasingOrganization='4310') |.
    DATA(ls_supplier) = http_client->get( uri ).
    IF ls_supplier-status EQ '200'.
      "BODY parsing
      DATA: pr_supplier_msg      TYPE REF TO data.

      /ui2/cl_json=>deserialize( EXPORTING json = ls_supplier-body CHANGING data = pr_supplier_msg ).

      ASSIGN pr_supplier_msg->* TO FIELD-SYMBOL(<fs_supplier_re>).
      ASSIGN ('<fs_supplier_re>-d->*') TO FIELD-SYMBOL(<fs_supplier>).
      ASSIGN ('<fs_supplier>-PurchaseOrderCurrency->*') TO FIELD-SYMBOL(<fv_order_currency>).
      IF <fv_order_currency> IS ASSIGNED.
        order_currency = <fv_order_currency>.
      ENDIF.
    ENDIF.

    "GET PR
    CREATE OBJECT http_client
      EXPORTING
        i_scenario     = c_scenario
        i_service      = c_service2
      EXCEPTIONS
        no_arrangement = 1.

    CHECK sy-subrc <> 1.

    CLEAR : uri.
    uri = |/PurchaseReqnAcctAssgmt?$filter=OrderID eq '{ lv_jobid }'|.
    DATA(ls_pr_header) = http_client->get( uri ).

    IF ls_pr_header-status EQ '200'.

      "BODY parsing
      DATA: pr_header_msg      TYPE REF TO data.

      /ui2/cl_json=>deserialize( EXPORTING json = ls_pr_header-body CHANGING data = pr_header_msg ).
      ASSIGN pr_header_msg->* TO FIELD-SYMBOL(<fs_result_msg>).
      ASSIGN ('<fs_result_msg>-value->*') TO FIELD-SYMBOL(<ft_pr>).

      "Make PO Body json & Get uri
      CLEAR : lv_itemnum, uri.

      uri = '/PurchaseOrder'.
      DATA(json) = '{'
                 && '"PurchaseOrderType": "NB",'
                 && '"CompanyCode": "4310",'       "1000
                 && '"PurchaseOrderDate": "' && lv_orderdate && '", '
                 && '"Supplier": "' && lv_supplier && '", '
                 && '"PurchasingGroup": "001",'
                 && '"PurchasingOrganization": "4310",'     "1000
                 && '"_PurchaseOrderItem": ['
                 .
      DATA(lv_line) = lines( <ft_pr> ).
      LOOP AT <ft_pr> ASSIGNING FIELD-SYMBOL(<fs_pr>).
        ASSIGN ('<fs_pr>->*') TO FIELD-SYMBOL(<fs_str>).
        ASSIGN ('<fs_str>-PurchaseRequisition->*') TO FIELD-SYMBOL(<fv_pr>).
        IF <fv_pr> IS ASSIGNED.
          pr_number = <fv_pr>.
        ENDIF.

        lv_itemnum += 10.
        json = json
             && '{'
             && '"PurchaseOrderItem": "' && lv_itemnum && '", '
             && '"PurchaseRequisition": "' && pr_number && '", '
             && '"NetPriceAmount": ' && lv_orderprice && ', '
*             && '"DocumentCurrency": "KRW",'
             && '"DocumentCurrency" : "' && order_currency && '", '
             && '"Plant": "4310"'.     "1000
        IF sy-tabix = lv_line.
          json = json && '}'.
        ELSE.
          json = json && '},'.
        ENDIF.
      ENDLOOP.
      json = json && ']}'.

      "get token
      CREATE OBJECT http_client
        EXPORTING
          i_scenario     = c_scenario
          i_service      = c_service1
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
              body   = DATA(body)
              status = DATA(status)
      ).
      ENDIF.

      IF status EQ 201.
        ls_update-if_code = '201'.
        ls_update-po_num = substring_before( val = substring_after( val = body
                                             sub = '"PurchaseOrder":"' )
                                             sub = '"' ).
        ls_update-if_msg = '구매오더 ' && ls_update-po_num && ' 생성 성공'.
      ELSE.
        ls_update-if_code = '400'.
        ls_update-if_msg = '문서 생성 실패 : ' && substring_before( val = substring_after( val = body
                                                                sub = '"value":"' )
                                                                sub = '"' ).
      ENDIF.

      APPEND ls_update TO lt_update.

      MODIFY ENTITIES OF zif_r_outsourcing IN LOCAL MODE
      ENTITY zif_r_outsourcing UPDATE FIELDS ( po_num if_code if_msg ) WITH lt_update
      MAPPED   DATA(ls_mapped_modify)
      FAILED   DATA(lt_failed_modify)
      REPORTED DATA(lt_reported_modify).

    ENDIF.

  ENDMETHOD.
ENDCLASS.






CLASS lsc_zif_r_outsourcing DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zif_r_outsourcing IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
