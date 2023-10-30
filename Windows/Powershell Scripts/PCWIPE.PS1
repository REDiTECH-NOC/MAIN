# SCRIPT FOUND ON https://techcommunity.microsoft.com/t5/windows-deployment/factory-reset-windows-10-without-user-intervention/m-p/1339823 
# PUBLISHED TO THE N-ABLE COOKBOOK BY MARC-ANDRE TANGUAY
# NOTE : THIS SCRIPT MUST BE RUN AS "SYSTEM" DUE TO PERMISSIONS REQUIREMENT. PLEASE ENSURE YOUR RMM SUPPORTS THIS MODE
# 	 BE CAREFUL USING THIS. THIS WILL WIPE THE COMPUTER AND RESET WINDOWS TO FACTORY SETTINGS WITH NO USER PROMPT OR INTERACTION.
#        ALSO NOTE THAT THIS IS NOT A DISK WIPE, BUT RATHER WINDOWS GOING BACK TO FACTORY SETTINGS AND DELETING ALL USER DATA. 


$namespaceName = "root\cimv2\mdm\dmmap"
$className = "MDM_RemoteWipe"
$methodName = "doWipeMethod"

$session = New-CimSession

$params = New-Object Microsoft.Management.Infrastructure.CimMethodParametersCollection
$param = [Microsoft.Management.Infrastructure.CimMethodParameter]::Create("param", "", "String", "In")
$params.Add($param)

$instance = Get-CimInstance -Namespace $namespaceName -ClassName $className -Filter "ParentID='./Vendor/MSFT' and InstanceID='RemoteWipe'"
$session.InvokeMethod($namespaceName, $instance, $methodName, $params)