CLASS zfi_cl_bangthuemuavao_custom DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_rap_query_provider.
    DATA: gt_data   TYPE TABLE OF zfi_i_thuemuavao_custom.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS get_data
      IMPORTING
        io_request TYPE REF TO if_rap_query_request
      EXPORTING
        et_data    LIKE gt_data.
ENDCLASS.



CLASS ZFI_CL_BANGTHUEMUAVAO_CUSTOM IMPLEMENTATION.


  METHOD get_data.
    DATA: lr_gla      TYPE RANGE OF hkont,
          lr_compcode TYPE RANGE OF bukrs,
          lr_year     TYPE RANGE OF gjahr,
          lr_acgr     TYPE RANGE OF ktokk,
          fromdate    TYPE  vdm_v_start_date,
          todate      TYPE vdm_v_start_date.

    " get range by filter ---------------------------
    TRY.
        DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
    ENDTRY.

    DATA(lt_parameter) = io_request->get_parameters( ).
    IF lt_parameter IS NOT INITIAL.
      LOOP AT lt_parameter REFERENCE INTO DATA(ls_parameter).
        CASE ls_parameter->parameter_name.
          WHEN 'FROMDATE'.
            fromdate        = ls_parameter->value .
          WHEN 'TODATE'.
            todate = ls_parameter->value .
        ENDCASE.
      ENDLOOP.
    ENDIF.

    IF lt_filter_cond IS NOT INITIAL.
      LOOP AT lt_filter_cond REFERENCE INTO DATA(ls_filter_cond).
        CASE ls_filter_cond->name.
          WHEN 'GLACCOUNT'.
            lr_gla = CORRESPONDING #( ls_filter_cond->range ) .
          WHEN 'COMPANYCODE'.
            lr_compcode = CORRESPONDING #( ls_filter_cond->range ) .
          WHEN 'FISCALYEAR'.
            lr_year = CORRESPONDING #( ls_filter_cond->range ) .
          WHEN 'ACCOUNTGROUP'.
            lr_acgr = CORRESPONDING #( ls_filter_cond->range ) .

        ENDCASE.
      ENDLOOP.
    ENDIF.
    " get range by filter ---------------------------
    TRY.
        DATA(lv_language) = cl_abap_context_info=>get_user_language_abap_format(  ).
      CATCH cx_abap_context_info_error INTO DATA(ls_context_info).
    ENDTRY.


    SELECT DISTINCT i_operationalacctgdocitem~accountingdocument
    FROM i_operationalacctgdocitem
    WHERE i_operationalacctgdocitem~glaccount IN @lr_gla
    INTO TABLE @DATA(lt_filter).

    SELECT
        bktmv~companycode,
        bktmv~fiscalyear,
        bktmv~accountingdocument,
        bktmv~accountingdocumentitem,
        bktmv~taxcode,
        bktmv~glaccount,
        bktmv~accountgroup,
        bktmv~documentreferenceid,
        bktmv~ngayphathanh,
        bktmv~postingdate,
        bktmv~tennguoiban,
        bktmv~mstnguoiban,
        bktmv~diengiai,
        bktmv~dvt,
        bktmv~soluong,
        bktmv~dvt_e,
        bktmv~debitcreditcode,
        bktmv~companycodecurrency,
        bktmv~taxbaseamountincocodecrcy,
        bktmv~value,
        bktmv~gtgt,
        bktmv~ghichu,
        bktmv~diachi,
        bktmv~username,
        bktmv~taxgroup,
        bktmv~rtype,
        bktmv~Company
    FROM zfi_i_bangkemuavao( fromdate = @fromdate,
                             todate   = @todate ) AS bktmv
    INNER JOIN @lt_filter AS filter ON filter~accountingdocument EQ bktmv~accountingdocument
    WHERE bktmv~companycode IN @lr_compcode
        AND bktmv~fiscalyear IN @lr_year
        AND bktmv~accountgroup IN @lr_acgr
    INTO CORRESPONDING FIELDS OF TABLE @et_data.

  ENDMETHOD.


  METHOD if_rap_query_provider~select.
    " get list field requested ----------------------
    DATA(lt_reqs_element) = io_request->get_requested_elements( ).
    DATA(lt_aggr_element) = io_request->get_aggregation( )->get_aggregated_elements( ).
    IF lt_aggr_element IS NOT INITIAL.
      LOOP AT lt_aggr_element ASSIGNING FIELD-SYMBOL(<lfs_aggr_elements>).
        DELETE lt_reqs_element WHERE table_line = <lfs_aggr_elements>-result_element.
        DATA(lv_aggr) = |{ <lfs_aggr_elements>-aggregation_method }( { <lfs_aggr_elements>-input_element } ) as { <lfs_aggr_elements>-result_element }|.
        APPEND lv_aggr TO lt_reqs_element.
      ENDLOOP.
    ENDIF.

    DATA(lv_reqs_element) = concat_lines_of( table = lt_reqs_element sep = `, ` ).
    " get list field requested ----------------------

    " get list field ordered ------------------------
    DATA(lt_sort) = io_request->get_sort_elements( ).

    DATA(lt_sort_criteria) = VALUE string_table( FOR ls_sort IN lt_sort ( ls_sort-element_name && COND #( WHEN ls_sort-descending = abap_true THEN ` descending`
                                                                                                                                              ELSE ` ascending` ) ) ).


    " get list field ordered ------------------------

    " get range of row data -------------------------
    DATA(lv_top)      = io_request->get_paging( )->get_page_size( ).
    DATA(lv_skip)     = io_request->get_paging( )->get_offset( ).
    DATA(lv_max_rows) = COND #( WHEN lv_top = if_rap_query_paging=>page_size_unlimited THEN 0
                                ELSE lv_top ).
    IF lv_max_rows = -1 .
      lv_max_rows = 1.
    ENDIF.
    CASE io_request->get_entity_id( ).
      WHEN 'ZFI_I_THUEMUAVAO_CUSTOM'.
        DATA: lt_return TYPE TABLE OF zfi_i_thuemuavao_custom.
        DATA(lv_sort_element) = COND #( WHEN lt_sort_criteria IS INITIAL
                                     THEN `CompanyCode,FiscalYear,AccountingDocument, AccountingDocumentItem, TaxCode`
                                     ELSE concat_lines_of( table = lt_sort_criteria sep = `, ` ) ).
        " get range of row data -------------------------
        get_data(
            EXPORTING io_request = io_request
            IMPORTING et_data    = DATA(lt_data) ).

        SELECT (lv_reqs_element)
          FROM @lt_data AS data
          ORDER BY (lv_sort_element)
          INTO CORRESPONDING FIELDS OF TABLE @lt_return
          OFFSET @lv_skip UP TO @lv_max_rows ROWS.

        IF io_request->is_data_requested( ).
          io_response->set_data( lt_return ).
        ENDIF.
        IF io_request->is_total_numb_of_rec_requested( ).
          io_response->set_total_number_of_records( lines( lt_data ) ).
        ENDIF.
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
