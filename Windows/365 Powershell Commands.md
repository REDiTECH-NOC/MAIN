# Commands to use with powershell for managing microsoft 365 
## -Install Azure AD module
```
Install-Module -Name AzureAD
```
connect to Azure AD
```
Connect-AzureAD
```
## -Install Exchange Online Module
```
Install-Module -Name ExchangeOnlineManagement
```
Import the module
```
Import-Module ExchangeOnlineManagement
```
Conenct to Exchnage online
```
Connect-ExchangeOnline
```
## -Login with partner portal credentials
```
Connect-ExchangeOnline -DelegatedOrganization customertenant.onmicrosoft.com
```
