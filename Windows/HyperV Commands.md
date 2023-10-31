# Get a list of VMs on a host
Need to change the Host names and save path
```
Get-VM -ComputerName HyperV05, HyperV06 | Select-Object -Property Name, State, CPUUsage, MemoryAssigned, Uptime, Status, Version, ComputerName | Export-Csv -Path C:\Users\REDiTECH\Desktop\vmlist.csv -NoTypeInformation
```
# Get replication information
Need to change the Host names and save path
```
Get-VMReplication -ComputerName HyperV05, HyperV06 -ReplicationState Replicating | Export-Csv -Path C:\Users\REDiTECH\Desktop\vmlist2.csv -NoTypeInformation
```
