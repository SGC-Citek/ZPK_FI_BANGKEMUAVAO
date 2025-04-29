@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lấy diễn giải mua hàng'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_LAYDIENGIAI
  as select distinct from I_OperationalAcctgDocItem as oadi
    left outer join       I_PurchaseOrderItemAPI01  as poi  on
//                                                               //    pc.PurchaseOrderItemUniqueID = oadi.AssignmentReference
//                                                               //                                                            and( pc.TaxCode                   = oadi.TaxCode )
//                                                               //                                                            and
                                                               oadi.PurchasingDocument     = poi.PurchaseOrder
                                                           and oadi.PurchasingDocumentItem = poi.PurchaseOrderItem
//  //    left outer join       I_ProductDescription      as text on  text.Language = 'E'
//  //                                                            and text.Product  = oadi.Product
//    left outer join       I_UnitOfMeasure           as uom on uom.UnitOfMeasure = pc.PurchaseOrderQuantityUnit
left outer join I_SuplrInvcItemPurOrdRefAPI01 as supinv on supinv.SupplierInvoice = substring(oadi.OriginalReferenceDocument,1,10)
                                                    and   supinv.FiscalYear =  substring(oadi.OriginalReferenceDocument,11,4)
left outer join I_ProductText as prdt on prdt.Product =  supinv.PurchaseOrderItemMaterial     
                                    and prdt.Language = $session.system_language 
left outer join I_ConditionTypeText   as ctt on ctt.ConditionType =    supinv.SuplrInvcDeliveryCostCndnType
                                            and ctt.Language =  $session.system_language                                                                                
left outer join I_UnitOfMeasure as uom on supinv.PurchaseOrderQuantityUnit =  uom.UnitOfMeasure                                          
{
  key oadi.CompanyCode,
  key oadi.AccountingDocument,
  key oadi.FiscalYear,
  key oadi.AccountingDocumentItem,
  key prdt.Product,
  key ctt.ConditionType,
  key supinv.TaxCode as TaxCode,
//   oadi.TaxCode,
      oadi.FinancialAccountType,
  prdt.ProductName, 
  ctt.ConditionTypeName,
  poi.PurchaseOrderItemText,
  supinv.PurchaseOrderQuantityUnit,
  uom.UnitOfMeasure_E,
  @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
  supinv.QuantityInPurchaseOrderUnit,
  case
        when ctt.ConditionType <> ''
            then
              case
                   when prdt.ProductName <> ''
                        then concat(ctt.ConditionTypeName,concat('(',concat(prdt.ProductName,')')))
                   else
                        concat(ctt.ConditionTypeName,concat('(',concat(poi.PurchaseOrderItemText,')')))
              end
              
        else
            case
                when prdt.ProductName <> ''
                     then  prdt.ProductName
            else
                poi.PurchaseOrderItemText
            end
  end as DienGiai, 
  @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
  case
        when ctt.ConditionType <> ''  or supinv.IsSubsequentDebitCredit is not initial 
            then cast(0 as abap.dec(12,2))
        else
            cast($projection.quantityinpurchaseorderunit as abap.dec(12,2))
  end as SoLuong
//      oadi.GLAccount,
      //    oadi.Product,
      //      text.ProductDescription as DienGiai
//      pc.PurchaseOrderItemText as DienGiai,
//      pc.PurchaseOrder,
//      //      pc.PurchaseOrderItem,
//      uom.UnitOfMeasure_E      as POQuantityUnit,
//      pc.PurchaseOrderQuantityUnit,
//      @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
//      pc.OrderQuantity
}
where
  (
    oadi.PurchasingDocument <> ''
    //and oadi.GLAccount            not like '00133%'
  )
