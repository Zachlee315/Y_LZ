CLASS ycl_lz_grj_emltest DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS YCL_LZ_GRJ_EMLTEST IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA lt_journal_entry TYPE TABLE FOR ACTION IMPORT i_cnsldtngroupjrnlentrytp~post.
    DATA lv_cid           TYPE abp_behv_cid.

    TRY.
        lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
      CATCH cx_uuid_error.
        ASSERT 1 = 0.
    ENDTRY.

    lt_journal_entry = VALUE #( ( %cid                                = lv_cid
                                  %param-FiscalYear                   = '2023'
                                  %param-ConsolidationVersion         = 'T10'
                                  %param-FiscalPeriod                 = '012'
                                  %param-ConsolidationChartOfAccounts = 'Y1'
                                  %param-ConsolidationDocumentType    = 'Z5'
                                  %param-ConsolidationGroup           = 'CG_A0'
                                  %param-DocumentItemText             = 'test!'
                                  %param-ConsolidationUnit            = 'T100'

                                  %param-_item                        = VALUE #(
                                      ConsolidationVersion = 'T10'
                                      SubItem              = '915'
                                      LocalCurrency        = 'KRW'
                                      TransactionCurrency  = 'KRW'
                                      GroupCurrency        = 'KRW'
                                      ConsolidationUnit    = 'T100'
                                      PartnerConsolidationUnit = 'T200'
                                      ( ConsolidationPostingItem    = '1'
                                        FinancialStatementItem      = '0000161100'
                                        AmountInLocalCurrency       = '-12500'
                                        AmountInTransactionCurrency = '-12500'
                                        AmountInGroupCurrency       = '-12500' )
                                      ( ConsolidationPostingItem    = '2'
                                        FinancialStatementItem      = '0000121100'
                                        AmountInLocalCurrency       = '12500'
                                        AmountInTransactionCurrency = '12500'
                                        AmountInGroupCurrency       = '12500' ) ) ) ).

    MODIFY ENTITY i_cnsldtngroupjrnlentrytp
           EXECUTE Simulate FROM CORRESPONDING #( lt_journal_entry )
           FAILED   DATA(ls_validation_failed)
           REPORTED DATA(ls_validation_reported)
           " TODO: variable is assigned but never used (ABAP cleaner)
           MAPPED   DATA(ls_validation_mapped).

    IF ls_validation_failed IS NOT INITIAL.
      LOOP AT ls_validation_reported-cnsldtngroupjournalentry ASSIGNING FIELD-SYMBOL(<ls_validation_reported>).
        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(lv_validation_result) = <ls_validation_reported>-%msg->if_message~get_text( ).
      ENDLOOP.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
