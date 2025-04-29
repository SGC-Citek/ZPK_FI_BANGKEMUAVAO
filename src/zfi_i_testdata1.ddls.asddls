@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lấy tên người bán ưu tiên 2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_TESTDATA1 as select distinct from I_OperationalAcctgDocItem as oadi
inner join I_OperationalAcctgDocTaxItem as oadti on oadti.AccountingDocument = oadi.AccountingDocument
                                                and oadti.CompanyCode = oadi.CompanyCode
                                                and oadti.FiscalYear  = oadi.FiscalYear
                                                and oadti.TaxItem = oadi.AccountingDocumentItem
left outer join I_Supplier as supplier on supplier.Supplier = oadi.Supplier
left outer join I_Customer as customer on customer.Customer = oadi.Customer
{
    key oadi.CompanyCode,
    key oadi.AccountingDocument,
    key oadi.FiscalYear,
    key oadi.AccountingDocumentItem,
    oadi.FinancialAccountType,
    customer.IsOneTimeAccount,
    supplier.IsOneTimeAccount as supplierIsOneTimeAccount,
    case 
        when oadi.FinancialAccountType <> ''
            then case 
                    when concat_with_space(supplier.BusinessPartnerName2,concat_with_space(supplier.BusinessPartnerName3,supplier.BusinessPartnerName4,1),1) = ''
                        then supplier.BusinessPartnerName1
                    else      concat_with_space(supplier.BusinessPartnerName2,concat_with_space(supplier.BusinessPartnerName3,supplier.BusinessPartnerName4,1),1)
                  end
             else case when  concat_with_space(customer.BusinessPartnerName2,concat_with_space(customer.BusinessPartnerName3,customer.BusinessPartnerName4,1),1) = ''
                            then customer.BusinessPartnerName1
                        else concat_with_space(customer.BusinessPartnerName2,concat_with_space(customer.BusinessPartnerName3,customer.BusinessPartnerName4,1),1)
                        end
     end as name3,
     case 
        when supplier.TaxNumber1 is null or supplier.TaxNumber1 is initial
            then customer.TaxNumber1
            else supplier.TaxNumber1
     end as Tax3,
     oadi.Supplier,
     oadi.Customer
}
where oadi.FinancialAccountType = 'K' and ((supplier.IsOneTimeAccount <> '') or (customer.IsOneTimeAccount <> ''))
//where oadi.FinancialAccountType = 'K' and  (customer.IsOneTimeAccount <> '')

