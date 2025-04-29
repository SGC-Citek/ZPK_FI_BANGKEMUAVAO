@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lấy tên người bán ưu tiên 4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_GETNAME_UUTIEN4 as select distinct from I_OperationalAcctgDocItem as oadi

{
  key oadi.CompanyCode,
  key oadi.AccountingDocument,
  key oadi.FiscalYear,
  key oadi.AccountingDocumentItem,
      oadi.FinancialAccountType,
  '' as name4,
  '' as Tax4,
  '' as Diachi4,
  '' as AccountGroup4
}
where FinancialAccountType <>'K' 
