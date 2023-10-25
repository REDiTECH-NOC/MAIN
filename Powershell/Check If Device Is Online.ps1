# Script checks the condition of the computer and if it is online, then alert on the dashboard.
# Tested on windows 7 workstation.

Try{
	$computer = 'localhost'
	if (Test-Connection $computer -Count 2 -Quiet) {
		try {
			$user = $null
			$user = gwmi -Class win32_computersystem -ComputerName $computer | select -ExpandProperty username -ErrorAction Stop
		}
		catch { 
			$output =  "Not logged on"; return
		}
		try {
			if ((Get-Process logonui -ComputerName $computer -ErrorAction Stop) -and ($user)) {
			$output = "Workstation locked by $user"	}
		}
		catch { 
			if ($user) { $output = "$user logged on" } 
		}
	}
	else { $output = "$user logged on" }		
	if ( $output -eq "$user logged on"){
		Write-Host "$user comes back online"
	}
	else {
	$output
	}
	Write-Host "Successfully passed"
	exit 0
	}
Catch {
	Write-Host "Failure"
	exit 1001
	}
