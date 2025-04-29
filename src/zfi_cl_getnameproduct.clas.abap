class zfi_cl_getnameproduct definition
  public
  final
  create public .

  public section.
  interfaces if_sadl_exit_calc_element_read .
  data:
      g_entity    type string,
      result type string.
  protected section.
  private section.
ENDCLASS.



CLASS ZFI_CL_GETNAMEPRODUCT IMPLEMENTATION.


  method if_sadl_exit_calc_element_read~calculate.
*    if  g_entity = 'ZFI_I_BANGKEMUAVAO'.
*      data: lt_bktmv  type standard table of ZFI_I_BANGKEMUAVAO with default key.
*      lt_bktmv = corresponding #( it_original_data ).
*      select
*        poia~PurchaseOrder,
*        poia~PurchaseOrderItemUniqueID,
*        "table~TaxCode,
*        poia~PurchaseOrderItemText as ShortText
*        from I_PurchaseOrderItemAPI01 as poia
*        "inner join  @lt_bktmv as table on table~AssignmentReference = poia~PurchaseOrderItemUniqueID
*        into table @data(data).
**      select
**          oadi~PurchasingDocument,
**          oadi~TaxCode
**          from I_OperationalAcctgDocItem as oadi
**          inner join @data as data on data~PurchaseOrderItemUniqueID = oadi~AssignmentReference
**          into table @data(resultData).
*        Loop at lt_bktmv reference into data(ls_bktmv).
*            read table data with key PurchaseOrder = ls_bktmv->PurchasingDocument into data(ls_text).
*        if sy-subrc = 0 .
*          ls_bktmv->mathangexcel = ls_text-shorttext.
*        endif.
*        endloop.
*      ct_calculated_data = corresponding #( lt_bktmv ).
*    endif.
  endmethod.


  method if_sadl_exit_calc_element_read~get_calculation_info.
    g_entity = iv_entity.
    data: lt_elements type table of string .
    if  iv_entity = 'ZFI_I_BANGKEMUAVAO'.
      loop at it_requested_calc_elements assigning field-symbol(<fs_calc_element>).
        case <fs_calc_element>.
          when 'MATHANGEXCEL'.
"            append 'ASSIGNMENTREFERENCE' to lt_elements.
            append 'TAXCODE' to lt_elements.
          when others.
        endcase.
      endloop.
      sort lt_elements.
      et_requested_orig_elements = corresponding #( lt_elements ).
    endif.
  endmethod.
ENDCLASS.
