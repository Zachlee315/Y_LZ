CLASS lsc_zmn_i_buildings DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS adjust_numbers REDEFINITION.

ENDCLASS.

CLASS lsc_zmn_i_buildings IMPLEMENTATION.

*  this method using the late numbering concept to assign the building id for the entity
*  using number range object
  METHOD adjust_numbers.

    LOOP AT mapped-building ASSIGNING FIELD-SYMBOL(<map_building>)
      WHERE %key-BuildingId IS INITIAL .

<map_building>-%key-BuildingId = 'B1000001'.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_building DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR building RESULT result.

    METHODS validatenrooms FOR VALIDATE ON SAVE
      IMPORTING keys FOR building~validatenrooms.

ENDCLASS.

CLASS lhc_building IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD validatenrooms.
*    reading the building entites
    READ ENTITIES OF ymn_i_buildings IN LOCAL MODE
        ENTITY building
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(buildings)
        FAILED DATA(building_failed).

    IF building_failed IS NOT INITIAL.
*     if the above read fails then return the error message
      failed = CORRESPONDING #( DEEP building_failed ).
      RETURN.
    ENDIF.

    LOOP AT buildings ASSIGNING FIELD-SYMBOL(<building>).

      IF NOT <building>-nrooms BETWEEN 1 AND 10.

*        if bulk upload, then the excel row no field will not be initial,
*        creating a message prefix for the output message
        DATA(lv_msg) = |No of Rooms must be in Range 1 to 10|.
        lv_msg = COND #( WHEN <building>-excelrownumber IS INITIAL
            THEN lv_msg
            ELSE |Row { <building>-excelrownumber }: { lv_msg }|
          ).

        APPEND VALUE #(
            %tky = <building>-%tky
        ) TO failed-building.

        APPEND VALUE #(
            %tky = <building>-%tky
            %state_area = 'Validate_Rooms'
            %msg = new_message_with_text(
                     severity = if_abap_behv_message=>severity-error
                     text     = lv_msg
                   )
            %element-nrooms = if_abap_behv=>mk-on
        ) TO reported-building.
      ENDIF.

      CLEAR lv_msg.
      <building>-buildingid = 'B100001'.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
