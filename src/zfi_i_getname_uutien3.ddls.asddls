@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lấy tên người bán ưu tiên 2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_GETNAME_UUTIEN3
  as select distinct from I_OperationalAcctgDocItem as oadi
  //inner join I_OperationalAcctgDocTaxItem as oadti on oadti.AccountingDocument = oadi.AccountingDocument
  //                                                and oadti.CompanyCode = oadi.CompanyCode
  //                                                and oadti.FiscalYear  = oadi.FiscalYear
  //                                                and oadti.TaxItem = oadi.TaxItemGroup
    left outer join       I_Supplier                as supp on supp.Supplier           = oadi.Supplier
//                                                                and(
//                                                                  supplier.IsOneTimeAccount    is null
//                                                                  or supplier.IsOneTimeAccount is initial
//                                                                )
//                                                                )
 left outer join       I_OneTimeAccountSupplier                as supplier on supplier.CompanyCode = oadi.CompanyCode
                                                                            and supplier.AccountingDocument = oadi.AccountingDocument
                                                                            and supplier.FiscalYear = oadi.FiscalYear
                                                                            and supplier.AccountingDocumentItem = oadi.AccountingDocumentItem
left outer join I_SupplierAccountGroupText as sagt on sagt.SupplierAccountGroup = supp.SupplierAccountGroup
                                                      and  sagt.Language = 'E'                                                        
{
  key oadi.CompanyCode,
  key oadi.AccountingDocument,
  key oadi.FiscalYear,
  key oadi.AccountingDocumentItem,
      oadi.FinancialAccountType,
     
//      case when concat_with_space(supplier.BusinessPartnerName2,concat_with_space(supplier.BusinessPartnerName3,supplier.BusinessPartnerName4,1),1) = ''
//                      then  supplier.BusinessPartnerName1
//                else concat_with_space(supplier.BusinessPartnerName2,concat_with_space(supplier.BusinessPartnerName3,supplier.BusinessPartnerName4,1),1)
//      end                                                                                                                                 as nameSupplier,
      concat_with_space(supplier.BusinessPartnerName1,
      concat_with_space(supplier.BusinessPartnerName2,
      concat_with_space(supplier.BusinessPartnerName3,
      supplier.BusinessPartnerName4,1),1),1) as nameSupplier,

      $projection.nameSupplier       as name3,
      

      supplier.TaxID1  as Tax3,
//      concat_with_space( supplier.StreetAddressName, supplier.CityName,1)                as Diachi3,
//      concat(supplier.StreetAddressName,concat(',',supplier.CityName)) as Diachi3,
      case
        when supplier.StreetAddressName = ''
           then supplier.CityName
        when supplier.CityName = ''
           then supplier.StreetAddressName     
        else
            concat(supplier.StreetAddressName,concat(',',supplier.CityName))
        end as Diachi3,
      oadi.Supplier,
      oadi.TaxCode,
      case
        when oadi.Supplier is null or oadi.Supplier is initial
            then oadi.Customer
        else oadi.Supplier
     end as Sup_Cus,
     sagt.SupplierAccountGroup as AccountGroup3
}
where ( supp.IsOneTimeAccount <> '' or oadi.AddressAndBankIsSetManually <> '' ) and
//where
     (oadi.FinancialAccountType = 'K')
