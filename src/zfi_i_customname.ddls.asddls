@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Xét ưu tiên name người bán'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_CustomName
  as select distinct from I_JournalEntry            as je
    inner join            I_OperationalAcctgDocItem as oadi on  oadi.CompanyCode        = je.CompanyCode
                                                            and oadi.AccountingDocument = je.AccountingDocument
                                                            and oadi.FiscalYear         = je.FiscalYear
    left outer join       ZFI_GETNAME_UUTIEN2       as ut2  on  ut2.AccountingDocument = je.AccountingDocument
                                                            and ut2.CompanyCode        = je.CompanyCode
                                                            and ut2.FiscalYear         = je.FiscalYear
    left outer join       ZFI_I_GETNAME_UUTIEN3     as ut3  on  ut3.AccountingDocument = je.AccountingDocument
                                                            and ut3.CompanyCode        = je.CompanyCode
                                                            and ut3.FiscalYear         = je.FiscalYear
    left outer join       ZFI_I_GETNAME_UUTIEN4     as ut4  on  ut4.AccountingDocument = je.AccountingDocument
                                                            and ut4.CompanyCode        = je.CompanyCode
                                                            and ut4.FiscalYear         = je.FiscalYear
    left outer join       ZFI_I_GETNAME_UUTIEN5     as ut5  on  ut5.AccountingDocument = je.AccountingDocument
                                                            and ut5.CompanyCode        = je.CompanyCode
                                                            and ut5.FiscalYear         = je.FiscalYear
{
  key ut2.CompanyCode,
  key ut2.AccountingDocument,
  key ut2.FiscalYear,
      ut3.name3,
      ut4.name4,
      ut5.name5,
      ut2.Name2
}
