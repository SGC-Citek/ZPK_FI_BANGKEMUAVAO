@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lấy diễn giải mua hàng 2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_laydiengiai2 as select distinct from I_OperationalAcctgDocItem as oadi
    inner join            I_JournalEntry    as je         on  oadi.CompanyCode        = je.CompanyCode
                                                                       and oadi.AccountingDocument = je.AccountingDocument
                                                                       and oadi.FiscalYear         = je.FiscalYear
{
    key oadi.CompanyCode,
    key oadi.AccountingDocument,
    key oadi.FiscalYear,
    key oadi.AccountingDocumentItem,
    oadi.FinancialAccountType,
    case when oadi.DocumentItemText <> ''
        then oadi.DocumentItemText
        else je.AccountingDocumentHeaderText
      end as DienGiai2
 }
where oadi.GLAccount like '0011%' and oadi.FinancialAccountType <> 'K' and oadi.PurchasingDocument = ''
