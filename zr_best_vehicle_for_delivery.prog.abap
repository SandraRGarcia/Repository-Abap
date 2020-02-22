*&------------------------------------------------------------------------*
*& Report  ZBEST_VEHICLE_FOR_DELIVERY
*&------------------------------------------------------------------------*
*& Program to determine which vehicle is the best option for the deliver
*&------------------------------------------------------------------------*
report zr_best_vehicle_for_delivery message-id zmdelivery.

*-------------------------------------------------------------------------
*--------- Global declarations -------------------------------------------
*-------------------------------------------------------------------------
include zi_delivery_data_declaration.

*-------------------------------------------------------------------------
*--- Declaration of Selection screen  ------------------------------------
*-------------------------------------------------------------------------
selection-screen begin of block exec with frame.
parameters:  p_rexec  radiobutton group gr01 default 'X' user-command comm,
             p_destin type ztdistances-local1 matchcode object zshstores,
             p_amount type zsdistances-distance.
selection-screen skip.
parameters:  p_rtabl  radiobutton group gr01,
             p_tables type char40.
selection-screen end of block exec.

*--------------------------------------------------------------------------
* -----------------     At Selection screen events   ----------------------
*--------------------------------------------------------------------------

* --- Fill up option of tables to update ----------------------------------
at selection-screen on value-request for p_tables.
*--- Update list of tables for maintenance
  perform list_tables_in_matchcode using 'X'.

*--- Change characteristic of screen fields depending on checkbox selected
at selection-screen output.
  if p_rexec is not initial.
* Check whether location exists
    if p_destin is not initial.
      perform valid_destination changing gv_end.
    endif.
    perform change_screen_fields using '1' '1' '0'.
  else.
    perform change_screen_fields using '0' '0' '1'.
  endif.

***************************************************************************
* -----------------           Main program               ---------------- *
***************************************************************************
start-of-selection.

  if p_rexec is not initial.
*--- If it's to perform calculation, check whether screen fields have value
    if p_destin is not initial and p_amount is not initial.
      clear gv_end.
      perform valid_destination changing gv_end.
      if gv_end is initial.
* Create Object for the class ZCL_DELIVERY
        if cl_delivery is not bound.
          try.
              create object cl_delivery.
            catch cx_sy_create_object_error  ##CATCH_ALL
              cx_root.
              message e000 with text-006.   " Message: Internal error: Issue on Class ZCL_DELIVERY
          endtry.
        endif.

        if cl_delivery is bound.
*--- Call the call passing information and display the final result
          call method cl_delivery->process
            exporting
              pv_destin = p_destin
              pv_amount = p_amount.
        endif.
      endif.
    else.
      message i004.                    " Message: Fill up selection fields
    endif.
* If it's to update configuraton, check table name is selected
  elseif p_rtabl is not initial.
    if p_tables is not initial.
      if gt_tables is initial.
        perform list_tables_in_matchcode using ''.
      endif.
      read table gt_tables into gw_tables with key table = p_tables.
      if sy-subrc eq 0.
*--- Call table maintenance
        perform maintain_table using gw_tables-name.
      else.
        message i006.                    " Message: Select a valid configuration table
      endif.
    else.
      message i004.                    " Message: Fill up selection fields
    endif.
  endif.

*--------------------------------------------------------------------------
*  Change characteristic of screen fields depending on checkbox selected
*--------------------------------------------------------------------------
form change_screen_fields using value(pi_d) type any
                                value(pi_a) type any
                                value(pi_t) type any.

  loop at screen.
    if screen-name = 'P_DESTIN'. screen-input = pi_d. endif.
    if screen-name = 'P_AMOUNT'. screen-input = pi_a. endif.
    if screen-name = 'P_TABLES'. screen-input = pi_t. endif.
    modify screen.
  endloop.

endform.

*--------------------------------------------------------------------------
*&  Add table into matchcode
*--------------------------------------------------------------------------
form add_tables_into_matchcode using value(pi_table) type any
                                     value(pi_name) type any.
  gw_tables-name = pi_table.
  gw_final-table = gw_tables-table = pi_name.
  translate  gw_tables-table to upper case.
  append gw_final to gt_final.
  append gw_tables to gt_tables.

endform.
*&---------------------------------------------------------------------*
*&      Form  MAINTAIN_TABLE
*&---------------------------------------------------------------------*
form maintain_table using p_view type any.

* Table of inactive CUA functions for view maintenance
  gw_excl-function = 'ATAB'.
  append gw_excl to gt_excl.

  call function 'VIEW_MAINTENANCE_CALL'
    exporting
      action               = 'U'
      view_name            = p_view
      check_ddic_mainflag  = 'X'
    tables
      excl_cua_funct       = gt_excl
    exceptions
      client_reference     = 01
      foreign_lock         = 02
      no_database_function = 04
      no_editor_function   = 05
      no_show_auth         = 06
      no_tvdir_entry       = 07
      no_upd_auth          = 08
      system_failure       = 09
      view_not_found       = 10.
  case sy-subrc.
    when 01. message i054(sv) with sy-mandt. " Maintenance of data in current client not permitted
* No maintenance authorization for cross-client tables (see Help)
    when 03. message id 'TB' type 'I' number 109.
    when 04. message i022(sv).                       " Create control function module
    when 05. message i023(sv).                       " Create data processing function module
    when 06. message i053(sv).                       " No display authorization for requested data
    when 07.
* Does table exist?
      call function 'DDIF_NAMETAB_GET'
        exporting
          tabname   = p_view
        exceptions
          not_found = 1
          others    = 2.
      if sy-subrc <> 0.
        message i164(sv) with p_view.   " Table/View does not exist in the dictionary
      else.
* The maintenance dialog for table/view is incomplete or not defined
        message i037(sv) with p_view.
      endif.
    when 08. message i052(sv).      " No maintenance authorization for requested data
    when 09. message i050(sv) with p_view.  " System error: Unable to lock table/view
    when 10. message i028(sv) with p_view.  " Table/View not in DDIC
  endcase.

endform.
*&---------------------------------------------------------------------*
*&      Form  LIST_TABLES_IN_MATCHCODE
*&---------------------------------------------------------------------*
* Update list of tables for maintenance
* ----------------------------------------------------------------------
form list_tables_in_matchcode using pi_exib type any.

  perform add_tables_into_matchcode using 'ZTVEHICLE_TYPES' text-001. " Vehicle types
  perform add_tables_into_matchcode using 'ZTCAPACITY'      text-002. " Vehicle Capacity
  perform add_tables_into_matchcode using 'ZTDISTANCES'     text-003. " Distances
  perform add_tables_into_matchcode using 'ZTSHORT'         text-004. " Shortest dist. between vehicle/store
  perform add_tables_into_matchcode using 'ZTSTORES'        text-005. " Stores/Locations

*--- Is this moment to display the matchcode
  if pi_exib = 'X'.
* Display the list of tables via matchcode
    call function 'F4IF_INT_TABLE_VALUE_REQUEST'
      exporting
        retfield        = 'TABLE'
        value_org       = 'S'
      tables
        value_tab       = gt_final
        return_tab      = gt_return
      exceptions
        parameter_error = 01
        no_values_found = 02.
    if sy-subrc = 0.
      read table gt_return into gw_return index 1.
      write gw_return-fieldval to p_tables.
    endif.
  endif.

endform.
*&---------------------------------------------------------------------*
*&      Form  VALID_DESTINATION
*&---------------------------------------------------------------------*
form valid_destination changing po_end type any.

  select single id from ztstores into p_destin where id = p_destin.
  if sy-subrc ne 0.
    message i005.                    " Message: Invalid Location/Store
    po_end = 'X'.
  endif.

endform.
