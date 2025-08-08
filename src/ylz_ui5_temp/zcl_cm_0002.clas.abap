CLASS zcl_cm_0002 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: json_xml_date IMPORTING json_date    TYPE string
                           RETURNING VALUE(xml_date) TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CM_0002 IMPLEMENTATION.


    METHOD json_xml_date.

        DATA : lv_posting_date TYPE string.
               lv_posting_date = json_date+6(13).

        DATA:
            lv_date        TYPE sy-datum,
            lv_days_i      TYPE i,
            lv_sec_i       TYPE i,
            lv_timestamp   TYPE timestampl,
            lv_timsmsec    TYPE timestampl,
            ev_date        TYPE SYDATE,
            ev_time        TYPE SYUZEIT.
        CONSTANTS:
            lc_day_in_sec TYPE i VALUE 86400.

          lv_timestamp = lv_posting_date / 1000.   "timestamp in seconds

          lv_days_i    = lv_timestamp DIV lc_day_in_sec.
          lv_date      = '19700101'.
          ev_date     = lv_date + lv_days_i.

*          lv_sec_i    = lv_timestamp MOD lc_day_in_sec.
*          ev_time     = lv_sec_i.

          "xml_date = |{ ev_date+0(4) }-{ ev_date+4(2) }-{ ev_date+6(2) }|.
          xml_date = ev_date.
    ENDMETHOD.
ENDCLASS.
