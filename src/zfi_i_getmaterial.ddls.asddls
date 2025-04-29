@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lấy mặt hàng'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_GETMATERIAL as select distinct from I_OperationalAcctgDocItem as oadi
    left outer join I_PurchaseOrderItemAPI01 as pc on pc.PurchaseOrderItemUniqueID = oadi.AssignmentReference
                                                  and pc.TaxCode  = oadi.TaxCode
    left outer join       I_ProductDescription      as text on  text.Language = 'E'
                                                            and text.Product  = oadi.Product
{
  key oadi.CompanyCode,
  key oadi.AccountingDocument,
  key oadi.FiscalYear,
  key oadi.AccountingDocumentItem,
  oadi.TaxCode,
      oadi.FinancialAccountType,
      oadi.GLAccount,
      //    oadi.Product,
//      text.ProductDescription as DienGiai
      pc.PurchaseOrderItemText as DienGiai
}
where
  (
  oadi.PurchasingDocument <> ''
  )
