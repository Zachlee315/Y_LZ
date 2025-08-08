CLASS lhc_ZMES_R_0027 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zmes_r_0027 RESULT result.

    METHODS create FOR DETERMINE ON SAVE
      IMPORTING keys FOR zmes_r_0027~create.

    CONSTANTS:
      c_scenario    TYPE string VALUE 'YCS_OUTBOUND_001',
      c_service_def TYPE string VALUE 'ZMES_MD_0005_REST',   "결함문서 등록용
      c_service_mat TYPE string VALUE 'Z_MATDOC_REST'.       "자재문서 POST용


    DATA: http_client TYPE REF TO zcl_cm_0001,
          utils       TYPE REF TO zcl_cm_0002,
          uri         TYPE string.

ENDCLASS.

CLASS lhc_ZMES_R_0027 IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
    DATA : ls_update TYPE STRUCTURE FOR UPDATE zmes_r_0027,
           lt_update TYPE TABLE FOR UPDATE zmes_r_0027.

    READ ENTITIES OF zmes_r_0027 IN LOCAL MODE
         ENTITY zmes_r_0027
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_result)
         FAILED    DATA(lt_failed)
         REPORTED  DATA(lt_reported).

    DATA(ls_result) = lt_result[ 1 ].
    ls_update = CORRESPONDING #( ls_result ).

    DATA(lv_transnum)     = ls_result-transnum.         "수불번호
    DATA(lv_matdoc_year)  = lv_transnum+0(4).           "자재문서연도
    DATA(lv_matdoc_num)   = lv_transnum+4(10).          "자재문서번호
    DATA(lv_matdoc_item)  = lv_transnum+15(4).          "자재문서아이템
    DATA(lv_normalqty)    = ls_result-normalqty.        "양품수량
    DATA(lv_quantity)     = ls_result-quantity.         "검사수량
    DATA(lv_scrapcode)    = ls_result-scrapcode.        "부적합코드
    DATA(lv_scrapcomment) = ls_result-scrapcomment.     "부접합사유
    DATA(lv_scrapqty)     = ls_result-scrapqty.         "부적합수량
    DATA(lv_material)     = ls_result-materialnum.      "자재번호


    "Get Matdoc
    SELECT SINGLE *
      FROM zmes_r_0027_01
     WHERE MaterialDocumentYear EQ @lv_matdoc_year
       AND MaterialDocument EQ @lv_matdoc_num
      INTO @DATA(ls_matdoc).
    IF sy-subrc EQ 0.

        data(lv_posting) =
           |{ ls_matdoc-postingdate+0(4) }-{ ls_matdoc-postingdate+4(2) }-{ ls_matdoc-postingdate+6(2) }T00:00:00|.



      IF lv_scrapqty IS INITIAL.
        DATA(json) = '{'
          && '"PostingDate": "' && lv_posting && '", '
          && '"GoodsMovementCode": "04", '
          && '"to_MaterialDocumentItem" : ['
          && '{'
          && '  "Plant": "' && ls_matdoc-plant && '", '
          && '  "StorageLocation": "' && ls_matdoc-StorageLocation && '", '
          && '  "Material": "' && ls_matdoc-Material && '", '
          && '  "GoodsMovementType" : "321",'
          && '  "QuantityInEntryUnit": "' && lv_normalqty && '", '
*          && '  "YY1_MATDOC_YEAR_MMI": "' && lv_matdoc_year && '", '
*          && '  "YY1_MATDOC_DOC_MMI": "' && lv_matdoc_num && '", '
*          && '  "YY1_MATDOC_ITEM_MMI": "' && lv_matdoc_item && '", '
          && '  "IssuingOrReceivingPlant": "' && ls_matdoc-plant && '", '
          && '  "IssuingOrReceivingStorageLoc": "' && ls_matdoc-StorageLocation && '"'
          && '}'
          && ']}'
        .
      ELSEIF lv_scrapqty > 0.
        json = '{'
          && '"PostingDate": "' && lv_posting && '", '
          && '"GoodsMovementCode": "04", '
          && '"to_MaterialDocumentItem" : ['
          && '{'
          && '  "Plant": "' && ls_matdoc-plant && '", '
          && '  "StorageLocation": "' && ls_matdoc-StorageLocation && '", '
          && '  "Material": "' && ls_matdoc-Material && '", '
          && '  "GoodsMovementType" : "350",'
          && '  "QuantityInEntryUnit": "' && lv_quantity && '", '
*          && '  "YY1_MATDOC_YEAR_MMI": "' && lv_matdoc_year && '", '
*          && '  "YY1_MATDOC_DOC_MMI": "' && lv_matdoc_num && '", '
*          && '  "YY1_MATDOC_ITEM_MMI": "' && lv_matdoc_item && '", '
*          && '  "YY1_MAT_REA_CODE": "' && lv_scrapcode && '", '
*          && '  "YY1_MAT_REA": "' && lv_scrapcomment && '", '
          && '  "IssuingOrReceivingPlant": "' && ls_matdoc-plant && '", '
          && '  "IssuingOrReceivingStorageLoc": "' && ls_matdoc-StorageLocation && '"'
          && '}'
          && ']}'
        .
      ENDIF.

      CLEAR : uri.
      uri = '/A_MaterialDocumentHeader'.

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
        ls_update-if_msg = '자재문서  ' && ls_update-document_num && ' 생성 성공'.

        IF lv_scrapqty > 0.

          CLEAR json.
          json = '{'
            && '"DefectCategory": "06", '
            && '"DefectText": "수입구매부적합", '
            && |"DefectCodeGroup": "{ lv_scrapcode+0(2) }", |
            && |"DefectCode": "{ lv_scrapcode+2(3) }", |
            && '"DefectiveQuantity": ' && lv_scrapqty && ', '
            && '"DefectiveQuantityUnit": "' && ls_matdoc-EntryUnit && '", '
            && '"Material": "' && lv_material && '", '
            && '"Plant": "' && ls_matdoc-plant && '", '
            && '"QualityIssueReference": "' && lv_transnum && '", '
            && '"_DefectDetailedDescription" : ['
            && '{'
            && '  "DefectLongText": "' && lv_scrapcomment && '"'
            && '}'
            && ']}'
          .

          CLEAR : token, uri, body, status.
          uri = '/Defect'.

          "get token
          CREATE OBJECT http_client
            EXPORTING
              i_scenario     = c_scenario
              i_service      = c_service_def
            EXCEPTIONS
              no_arrangement = 1.

          CHECK sy-subrc <> 1.

          token = http_client->get_token_cookies( uri ).

          IF token IS NOT INITIAL.
            http_client->post(
              EXPORTING
                  uri = uri
                  json = json
              IMPORTING
                  body   = body
                  status = status
            ).
          ENDIF.

          IF status EQ 201.
            ls_update-if_code = '201'.
            ls_update-scrapdoc_num = substring_before( val = substring_after( val = body
                                                 sub = '"Defect":"' )
                                                 sub = '"' ).
            ls_update-if_msg = '자재문서 및 결함문서 등록성공'.
          ELSE.
            ls_update-if_code = '400'.
            ls_update-if_msg = '문서 생성 실패 : ' && substring_before( val = substring_after( val = body
                                                                    sub = '"value":"' )
                                                                    sub = '"' ).
          ENDIF.

        ENDIF.

      ELSE.
        ls_update-if_code = '400'.
        ls_update-if_msg = '문서 생성 실패 : ' && substring_before( val = substring_after( val = body
                                                                sub = '"value":"' )
                                                                sub = '"' ).
      ENDIF.

    ELSE.
      ls_update-if_code = '400'.
      ls_update-if_msg = '수불번호에 맞는 자재문서가 없습니다.'.
    ENDIF.

    APPEND ls_update TO lt_update.

    MODIFY ENTITIES OF zmes_r_0027 IN LOCAL MODE
    ENTITY zmes_r_0027
    UPDATE FIELDS ( document_num
                    scrapdoc_num
                    if_code
                    if_msg )
             WITH lt_update
    MAPPED   DATA(ls_mapped_modify)
    FAILED   DATA(lt_failed_modify)
    REPORTED DATA(lt_reported_modify).

  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZMES_R_0027 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZMES_R_0027 IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
