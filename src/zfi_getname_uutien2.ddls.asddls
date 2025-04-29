@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lấy tên người bán ưu tiên 2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_GETNAME_UUTIEN2 as select distinct from I_OperationalAcctgDocItem as oadi
left outer join I_Supplier as supplier on supplier.Supplier = oadi.Supplier
left outer join I_Address_2 as addr  on addr.AddressID = supplier.AddressID
left outer join I_SupplierAccountGroupText as sagt on sagt.SupplierAccountGroup = supplier.SupplierAccountGroup
                                                      and  sagt.Language = 'E'     
{
    key oadi.CompanyCode,
    key oadi.AccountingDocument,
    key oadi.FiscalYear,
    key oadi.AccountingDocumentItem,
    oadi.AlternativePayeePayer,
    
    case 
        when concat_with_space(supplier.BusinessPartnerName2,concat_with_space(supplier.BusinessPartnerName3,supplier.BusinessPartnerName4,1),1) = ''
         then supplier.BusinessPartnerName1
     else concat_with_space(supplier.BusinessPartnerName2,concat_with_space(supplier.BusinessPartnerName3,supplier.BusinessPartnerName4,1),1)
        end  as name2,

        supplier.TaxNumber1 as Tax2,
//    concat(addr.StreetName,concat(',',concat(addr.DistrictName,concat(',',addr.CityName)))) as Diachi2,   
    case
        when addr.StreetName = '' and addr.DistrictName <> '' and addr.CityName <> ''
           then concat(addr.DistrictName,concat_with_space(',',addr.CityName,1))
        when addr.DistrictName = '' and addr.StreetName <> '' and addr.CityName <> ''
           then concat(addr.StreetName,concat_with_space(',',addr.CityName,1))
        when addr.CityName = '' and addr.StreetName <> '' and addr.DistrictName <> ''
           then concat(addr.StreetName,concat_with_space(',',addr.DistrictName,1))
        when addr.StreetName = '' and addr.DistrictName = ''
           then addr.CityName
        when addr.StreetName = '' and addr.CityName = ''
           then addr.DistrictName
        when addr.DistrictName = '' and addr.CityName = ''
           then addr.StreetName
        else
            concat(addr.StreetName,concat_with_space(',',concat(addr.DistrictName,concat_with_space(',',addr.CityName,1)),1))
        end as Diachi2,                                                                                                                                           
    oadi.AlternativePayeePayer as Sup_Cus,
    supplier.IsOneTimeAccount,
    oadi.AddressAndBankIsSetManually,
    oadi.FinancialAccountType,
    sagt.SupplierAccountGroup as AccountGroup2
}
//where((oadi.Supplier <> '') and (oadi.AlternativePayeePayer <> '') and (oadi.FinancialAccountType = 'K'))
//where (oadi.AlternativePayeePayer <> '' ) 
//
where (supplier.IsOneTimeAccount = '' and oadi.AddressAndBankIsSetManually = '' ) and 
 (oadi.FinancialAccountType = 'K')
