@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lấy tên người bán ưu tiên 5'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_GETNAME_UUTIEN5 as select distinct from I_JournalEntryItem as jei

{
    key jei.CompanyCode,
    key jei.AccountingDocument,
    key jei.FiscalYear,
    key jei.AccountingDocumentItem,
    //,
    ' ' as Tax5,
    ' ' as name5,
    jei.Supplier as Sup_Cus
//    jei.YY1_TenNCCxuatHD_COB as name5,

//    jei.Supplier as Sup_Cus
}
//where (jei.YY1_MSTNhcungcpxuthon_COB <> '' and jei.YY1_TenNCCxuatHD_COB <> '')
