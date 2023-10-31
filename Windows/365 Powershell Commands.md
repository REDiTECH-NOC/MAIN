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
## Get junk email Configiration
```
Get-MailboxJunkEmailConfiguration -identity "user email address"
```
## How to get Service Plan IDs
connect to azure AD
```
Get-AzureADSubscribedSKU
```
Copy the objectID of the one you want
```
Get-AzureADSubscribedSku -objectid "the object id you copied" | select -expand serviceplans
```
## How to get Blocked Senders and Domains for a user 
```
 (Get-MailboxJunkEmailConfiguration -Identity user@email.com).BlockedSendersAndDomains
```
Or Specify a domain
```
(Get-MailboxJunkEmailConfiguration -Identity user@email.com).BlockedSendersAndDomains | Where-Object { $_ -like "*@reditech.com" }

```

