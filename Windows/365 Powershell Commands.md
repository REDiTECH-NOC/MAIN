# Commands to use with powershell for managing microsoft 365 
## Install Azure AD module
<pre>
Install-Module -Name AzureAD

>To connect to Azure AD<
Connect-AzureAD
</pre>
## Install Exchange Online Module
<pre>
Install-Module -Name ExchangeOnlineManagement
>Import the module<
Import-Module ExchangeOnlineManagement

>Connect to Exchange online<
Connect-ExchangeOnline
</pre>
## Login with partner portal credentials
```
Connect-ExchangeOnline -DelegatedOrganization customertenant.onmicrosoft.com
```
