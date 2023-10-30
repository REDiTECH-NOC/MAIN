# Commands to use with powershell for managing microsoft 365 
## Install Azure AD module
<pre>
Install-Module -Name AzureAD

> To connect to Azure AD <
Connect-AzureAD
</pre>
## Install Exchange Online Module
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
## Login with partner portal credentials
```
Connect-ExchangeOnline -DelegatedOrganization customertenant.onmicrosoft.com
```
