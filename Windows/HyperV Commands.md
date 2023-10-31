# Get a list of VMs on a host
make sure to change the save path
```
Get-VM -ComputerName HyperV05, HyperV06 | Select-Object -Property Name, State, CPUUsage, MemoryAssigned, Uptime, Status, Version, ComputerName | Export-Csv -Path C:\Users\REDiTECH\Desktop\vmlist.csv -NoTypeInformation
```
