@EndUserText.label: 'Get addres fi'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZFI_GETADDRESS as select from I_Address_2 as add
left outer join ZWM_GETADDRESSPHONE as phone on add.AddressID = phone.AddressID
left outer join I_AddressFaxNumber_2 as fax on add.AddressID = fax.AddressID
{
    key add.AddressID,
    key add.AddressPersonID,
    key add.AddressRepresentationCode,       
      add.OrganizationName1,
      add.OrganizationName2,
      add.OrganizationName3,
      add.OrganizationName4,
      add.StreetName,
      add.StreetPrefixName1,
      add.StreetPrefixName2,
      add.StreetSuffixName1,
      add.StreetSuffixName2,
      add.DistrictName,
      add.CityName,
      phone.InternationalPhoneNumber,
      fax.InternationalFaxNumber
}
