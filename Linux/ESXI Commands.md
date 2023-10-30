# ESXI Commands
Repair a VMDK "Object type requires hosted I/O":
```ssh into host```
```
vmkfstools -x check “disk.vmdk”
```
That should say disk needs reapired
```
vmkfstools -x repair “disk.vmdk”
```
That should say successfully repaired