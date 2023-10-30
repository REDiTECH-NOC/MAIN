<#
.< help Useage>
< Please note the 'Webroot Secure Anywhere' should be replaced with the exact name of the AV from above. https://support.huntress.io/hc/en-us/articles/4454143963411>
#>
Get-WmiObject -Namespace root\SecurityCenter2 -Class AntiVirusProduct | Where-Object { $_.displayName -eq "Webroot Secure Anywhere" } | ForEach-Object{$_.Delete()}