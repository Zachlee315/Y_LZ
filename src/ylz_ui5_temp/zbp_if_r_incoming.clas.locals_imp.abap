CLASS lhc_zif_r_incoming DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zif_r_incoming RESULT result.

    METHODS create FOR DETERMINE ON SAVE
      IMPORTING keys FOR zif_r_incoming~create.


    CONSTANTS:
      c_scenario    TYPE string VALUE 'YCS_OUTBOUND_001',
      c_service_po  TYPE string VALUE 'Z_MAT_DOCUMENT_REST',   "PO PATCH 용
      c_service_mat TYPE string VALUE 'Z_MATDOC_REST'.            "자재문서 POST용


    DATA: http_client TYPE REF TO zcl_cm_0001,
          utils       TYPE REF TO zcl_cm_0002,
          uri         TYPE string.

ENDCLASS.

CLASS lhc_zif_r_incoming IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.

    DATA : ls_update TYPE STRUCTURE FOR UPDATE zif_r_incoming,
           lt_update TYPE TABLE FOR UPDATE zif_r_incoming.

    CREATE OBJECT utils.

    CHECK sy-subrc <> 1.

    READ ENTITIES OF zif_r_incoming IN LOCAL MODE
         ENTITY zif_r_incoming
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_result)
         FAILED    DATA(lt_failed)
         REPORTED  DATA(lt_reported).

    DATA(ls_result) = lt_result[ 1 ].

    IF ls_result-inspectionflag IS NOT INITIAL.
      EXIT. "InspectionFlag가 값이 있으면 입고처리에서 제외
    ENDIF.
    ls_update = CORRESPONDING #( ls_result ).
    DATA(lv_comp_flag) = ls_result-completeflag.
    DATA(lv_insp_flag) = ls_result-inspectionflag.

    DATA(lv_jobid) = VALUE char12(  ).
    lv_jobid = |{ ls_result-jobid  ALPHA = IN }|.

    DATA(lv_incomingdate) = ls_result-incomingdate.
    DATA(lv_incomingqty) = ls_result-incomingqty.


    "GET 구매오더 정보
    SELECT purchaseorder, purchaseorderitem
      FROM ycds_select_test
     WHERE orderid EQ @lv_jobid
      INTO TABLE @DATA(lt_po).
    SORT lt_po BY purchaseorder ASCENDING
                  purchaseorderitem ASCENDING.
    DELETE ADJACENT DUPLICATES FROM lt_po
    COMPARING ALL FIELDS.

    CASE lv_comp_flag.
      WHEN 'N'.  "입고전기

        CLEAR : uri.
        uri = '/A_MaterialDocumentHeader'.

        DATA(lv_find) = find( val = lv_incomingdate sub = '-' ).
        IF lv_find IS NOT INITIAL.
          DATA(lv_posting) =
              lv_incomingdate && 'T00:00:00'.
        ELSE.
          lv_posting =
             |{ lv_incomingdate+0(4) }-{ lv_incomingdate+4(2) }-{ lv_incomingdate+6(2) }T00:00:00|.
        ENDIF.

        DATA(lv_line) = lines( lt_po ).
        LOOP AT lt_po INTO DATA(ls_po).
          "ReferenceDocument로 확인했을때 PO별 입고처리하는것으로 추정됨.
          IF sy-tabix = 1.
            DATA(json) = '{'
                  && '"PostingDate": "' && lv_posting && '", '
                  && '"GoodsMovementCode": "01", '
                  && '"ReferenceDocument": "' && ls_po-purchaseorder && '",'
                  && '"to_MaterialDocumentItem" : ['.
          ENDIF.

          json = json
               && '{'
               && '  "Plant" : "4310",'    "1000
               && '  "GoodsMovementType" : "101",'
               && '  "PurchaseOrder": "' && ls_po-purchaseorder && '",'
               && '  "PurchaseOrderItem": "' && ls_po-purchaseorderitem && '",'
               && '  "GoodsMovementRefDocType": "B",'
               && '  "QuantityInEntryUnit": "' && lv_incomingqty && '",'
               && '  "ShelfLifeExpirationDate":  "2024-08-09T00:00:00" '    "다인에서는 해당 소스 주석필요
              .
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
            i_service      = c_service_mat
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
          ls_update-document_num = substring_before( val = substring_after( val = body
                                               sub = '"MaterialDocument":"' )
                                               sub = '"' ).
          ls_update-if_msg = '입고문서  ' && ls_update-document_num && ' 생성 성공'.
        ELSE.
          ls_update-if_code = '400'.
          ls_update-if_msg = '문서 생성 실패 : ' && substring_before( val = substring_after( val = body
                                                                  sub = '"value":"' )
                                                                  sub = '"' ).
        ENDIF.



      WHEN 'Y'.  "구매오더 변경

        LOOP AT lt_po INTO ls_po.
          CLEAR : token, json, uri.
          uri = |/PurchaseOrderItem/{ ls_po-purchaseorder }/{ ls_po-purchaseorderitem }|.
          json = '{'
              && '"IsCompletelyDelivered": true '
              && '}'.

          "get token
          CREATE OBJECT http_client
            EXPORTING
              i_scenario     = c_scenario
              i_service      = c_service_po
            EXCEPTIONS
              no_arrangement = 1.

          CHECK sy-subrc <> 1.

          token = http_client->get_token_cookies( uri ).

          IF token IS NOT INITIAL.
            http_client->patch(
              EXPORTING
                  uri = uri
                  json = json
              IMPORTING
                  body   = DATA(patch_body)
                  status = DATA(patch_status)
          ).
          ENDIF.

          IF patch_status EQ 200.
            ls_update-if_code = '200'.
            ls_update-document_num = substring_before( val = substring_after( val = patch_body
                                                 sub = '"PurchaseOrder":"' )
                                                 sub = '"' ).
            ls_update-if_msg = '구매오더  ' && ls_update-document_num && ' 변경 성공'.
          ELSE.
            ls_update-if_code = '400'.
            ls_update-if_msg = '오더 변경 실패 : ' && substring_before( val = substring_after( val = patch_body
                                                                    sub = '"value":"' )
                                                                    sub = '"' ).
          ENDIF.

          APPEND ls_update TO lt_update.

          MODIFY ENTITIES OF zif_r_incoming IN LOCAL MODE
          ENTITY zif_r_incoming UPDATE FIELDS ( document_num if_code if_msg ) WITH lt_update
          MAPPED   DATA(ls_mapped_modify)
          FAILED   DATA(lt_failed_modify)
          REPORTED DATA(lt_reported_modify).
        ENDLOOP.
    ENDCASE.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zif_r_incoming DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zif_r_incoming IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
