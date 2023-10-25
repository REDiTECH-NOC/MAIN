$global:fullcustlist=@();
$global:validationstatus="False"
#BUTTON ACTIONS
$btnconnect_click = 
{
    
    fctconnectncentral #CONNECT TO N-central server
}
$btndevfilebrowse_click =
{
    getfilepath("DevOne") #load the file selection dialog
}
$btncustfilebrowse_click = 
{
    getfilepath("CustOne") #load the file selection dialog
}
$btndevfilebrowseall_click =
{
    getfilepath("DevAll") #load the file selection dialog
}
$btncustfilebrowseall_click = 
{
    getfilepath("CustAll") #load the file selection dialog
}
$btndevfilebrowsein_click = 
{
    getfilepath("Devin") #load the file selection dialog
}
$btncustfilebrowsein_click = 
{
    getfilepath("CustIn") #load the file selection dialog
}
$btndevfileexportone_click= 
{
    fctExportaDeviceproperty #Export a single device property
}
$btndevfileexportall_click=
{
    fctExportAllDeviceProperties #export all device properties
}
$btncustfileexportall_click=
{
    fctexportallcustomerproperties #export all customer-level properties
}
$btncustfileexportone_click=
{
    fctexportonecustomerproperty
}
$btncustfileimportone_click=
{
    fctimportcustomerproperty
}
$btndevfileimportone_click=
{
    fctimportdeviceproperty
}
$btncustfilevalidateone_click=
{
    fctvalidateimportcustomerpropertyfile
}
$btndevfilevalidateone_click=
{
    fctvalidateimportdevicepropertyfile
}

$chkboxcustcustidall_click=
{
    if($chkboxcustcustidall.checked -eq $true) 
    {
        $textBoxcustcustidall.enabled=$False
    }
    else {
        $textBoxcustcustidall.enabled=$true
    }
}
$chkboxcustcustidone_click=
{
    if($chkboxcustcustidone.checked -eq $true)
    {
        $textBoxcustcustidone.enabled=$False
    }
    else {
        $textBoxcustcustidone.enabled=$true
    }
}
$chkboxdevcustidall_click=
{
    if($chkboxdevcustidall.checked -eq $true)
    {
        $textBoxdevcustidall.enabled=$False
    }
    else {
        $textBoxdevcustidall.enabled=$true
    }
}
$chkboxdevcustidone_click=
{
    if($chkboxdevcustidone.checked -eq $true)
    {   
        $textboxdevcustidone.enabled=$false
    }
    else {
        $textboxdevcustidone.enabled=$True
    }
}



function fctconnectncentral()
{
    $datenow = Get-Date

    Add-Type -AssemblyName PresentationCore,PresentationFramework
    $ButtonType = [System.Windows.MessageBoxButton]::OK
    $MessageIcon = [System.Windows.MessageBoxImage]::Error
    $MessageBody = "Please note that you will receive a .net execution error if the URL or API Key is incorrect. this is not a system error but a byproduct of the command being executed "
    $MessageTitle = "Connection Warning"
    $Result = [System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)
    

#    $connvalue.ncversion
    #$objTextoutput.text=""
    $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" ---------------------------------------------------------------------------------------------------------------------------------- " + "`r`n"
    #$objTextoutput.appendtext($datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" ---------------------------------------------------------------------------------------------------------------------------------- " + "`r`n")
    $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - Connection to N-central Server " + "`r`n"

    if($textBoxncsrv.text -eq "" -or $textBoxapikey.text -eq "")
    {
        $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - Could not connect to N-central. one of the required fields is not populated (API Key or Server Address) " + "`r`n"
        $labelncsrvstatus2.text="Not Connected"
        $labelncsrvstatus2.ForeColor="Red"
        $listbox.visible=$false
    }
    else 
    {
        $connvalue=    New-NCentralConnection -ServerFQDN $textBoxncsrv.text -JWT $textBoxapikey.text
        $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - Connected : " + $connvalue.isconnected + "`r`n"
        $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - Connected N-Central Version : " + $connvalue.ncversion + "`r`n" 
        if($connvalue.error -eq "")
        {
            $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - No API Errors Reported " + "`r`n"
        }
        else
        {
            $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - API Errors : " + $connvalue.error + "`r`n"
            $listbox.visible=$false
        }

        if($connvalue.isconnected -eq "True")
        {
            $labelncsrvstatus2.text="Connected"
            $labelncsrvstatus2.ForeColor="Green"
            
            $Labelapikey.text="Please select an action:"
            $listbox.visible=$true

            $textBoxncsrv.enabled=$false
            $textBoxapikey.enabled=$false
        }
        else 
        {
            $labelncsrvstatus2.text="Not Connected"
            $labelncsrvstatus2.ForeColor="Red"

            $listbox.visible=$false
        }
    }



}


#==============================================================================================================================================
# FUNCTION : GETFILEPATH
# INPUT : devorcust : this send the flag as to whether it was called from which button (6 total)
# DETAILS : the function triggers either the open or save dialog to pick a file to import/save, and updates the text file based on the input parameter 
#==============================================================================================================================================
function getfilepath($devorcust)
{
    if($devorcust -like "*in")
    {
        $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop') }
        $FileBrowser.filter="Csv (*.csv)| *.csv"
        $fb = $FileBrowser.ShowDialog()
    }
    else 
    {
        $FileBrowser = New-Object System.Windows.Forms.SaveFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop') }
        $FileBrowser.filter="Csv (*.csv)| *.csv"
        $fb = $FileBrowser.ShowDialog()
    }
    $datenow=get-date   

    #OUTPUT LOG
    $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" ---------------------------------------------------------------------------------------------------------------------------------- " + "`r`n"

    if($FileBrowser.FileName -eq $null -or $FileBrowser.FileName -eq "")
    {
        write-host "NO FILE PICKED"
        $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - No File was Selected" + "`r`n"
    }
    else 
    {
        write-host $FileBrowser.FileName
        [string]$strfile = $filebrowser.filename
        if($strfile -like "*.csv")
        {
            write-host "CSV FOUND"
            $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - File " + $FileBrowser.FileName + " Was selected" + "`r`n"
            switch ($devorcust)
            {
                "CustOne"                 {                    $textBoxcustfile.text=$FileBrowser.FileName                }
                "DevOne"                 {                    $textBoxdevfile.text=$FileBrowser.FileName                }
                "CustAll"                 {                    $textBoxcustfileall.text=$filebrowser.filename                }
                "DevAll"                 {                    $textboxdevfileall.text=$filebrowser.filename                }
                "DevIn"                 {                    $textBoxdevfilein.text=$filebrowser.filename                }
                "CustIn"                 {                    $textBoxcustfilein.text=$filebrowser.filename                }
            }
        }
        else
        {
            $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - File " + $FileBrowser.FileName + " Was selected but it is not a CSV" + "`r`n"
        }
    }
}


#==============================================================================================================================================
# FUNCTION : fctactionchangedropdown
#==============================================================================================================================================

function fctactionchangedropdown($selectedindex)
{
    $labeldevexporthdr.visible=$false
    $labeldevexporthdr1.visible=$false
    $Labeldevfile.visible=$false
    $textBoxdevfile.visible=$false
    $btndevfilebrowse.visible=$false
    $Labeldevcustidone.visible=$false
    $textBoxdevcustidone.visible=$false
    $chkboxdevcustidone.visible=$false
    $Labeldevcustidonechk.visible=$false
    $Labeldevpropidone.visible=$false
    $textBoxdevpropidone.visible=$false
    $btndevfileexportone.visible=$false
    
    
    
    
    $labelexporthdr.visible=$false
    $labelexporthdr1.visible=$false
    $Labelcustfile.visible=$false
    $textBoxcustfile.visible=$false
    $btncustfilebrowse.visible=$false
    $Labelcustcustidone.visible=$false
    $textBoxcustcustidone.visible=$false
    $chkboxcustcustidone.visible=$false
    $Labelcustcustidonechk.visible=$false
    $Labelcustpropidone.visible=$false
    $textBoxcustpropidone.visible=$false
    $btncustfileexportone.visible=$false
    
    
    
    $labelimporthdr.visible=$false
    $labelimporthdr1.visible=$false
    $Labelcustfilein.visible=$false
    $textBoxcustfilein.visible=$false
    $btncustfilebrowsein.visible=$false
    $btncustfileimportone.visible=$false
    $btncustfilevalidateone.visible=$false
    
    
    
    $labelimportdevhdr.visible=$false
    $labelimportdevhdr1.visible=$false
    $Labeldevfilein.visible=$false
    $textBoxdevfilein.visible=$false
    $btndevfilebrowsein.visible=$false
    $btndevfileimportone.visible=$false
    $btndevfilevalidateone.visible=$false
    
    
    
    $labelexporthdrdev.visible=$false
    $labelexporthdrdevdtl.visible=$false
    $Labeldevfileall.visible=$false
    $textBoxdevfileall.visible=$false
    $Labeldevcustidall.visible=$false
    $textBoxdevcustidall.visible=$false
    $chkboxdevcustidall.visible=$false
    $Labeldevcustidallchk.visible=$false
    $btndevfilebrowseall.visible=$false
    $btndevfileexportall.visible=$false
    
    
    
    $labelexporthdrcust.visible=$false
    $labelexporthdrcustdtl.visible=$false
    $Labelcustfileall.visible=$false
    $textBoxcustfileall.visible=$false
    $Labelcustcustidall.visible=$false
    $textBoxcustcustidall.visible=$false
    $chkboxcustcustidall.visible=$false
    $Labelcustcustidallchk.visible=$false
    $btncustfilebrowseall.visible=$false
    $btncustfileexportall.visible=$false

    switch($selectedindex)
    {
        0 {
            $labeldevexporthdr.visible=$true
            $labeldevexporthdr1.visible=$true
            $Labeldevfile.visible=$true
            $textBoxdevfile.visible=$true
            $btndevfilebrowse.visible=$true
            $Labeldevcustidone.visible=$true
            $textBoxdevcustidone.visible=$true
            $chkboxdevcustidone.visible=$true
            $Labeldevcustidonechk.visible=$true
            $Labeldevpropidone.visible=$true
            $textBoxdevpropidone.visible=$true
            $btndevfileexportone.visible=$true
        }
        1 {
            $labelexporthdr.visible=$true
            $labelexporthdr1.visible=$true
            $Labelcustfile.visible=$true
            $textBoxcustfile.visible=$true
            $btncustfilebrowse.visible=$true
            $Labelcustcustidone.visible=$true
            $textBoxcustcustidone.visible=$true
            $chkboxcustcustidone.visible=$true
            $Labelcustcustidonechk.visible=$true
            $Labelcustpropidone.visible=$true
            $textBoxcustpropidone.visible=$true
            $btncustfileexportone.visible=$true

        }
        2 {
            $labelexporthdrdev.visible=$true
            $labelexporthdrdevdtl.visible=$true
            $Labeldevfileall.visible=$true
            $textBoxdevfileall.visible=$true
            $Labeldevcustidall.visible=$true
            $textBoxdevcustidall.visible=$true
            $chkboxdevcustidall.visible=$true
            $Labeldevcustidallchk.visible=$true
            $btndevfilebrowseall.visible=$true
            $btndevfileexportall.visible=$true
            
        }
        3 {
            $labelexporthdrcust.visible=$true
            $labelexporthdrcustdtl.visible=$true
            $Labelcustfileall.visible=$true
            $textBoxcustfileall.visible=$true
            $Labelcustcustidall.visible=$true
            $textBoxcustcustidall.visible=$true
            $chkboxcustcustidall.visible=$true
            $Labelcustcustidallchk.visible=$true
            $btncustfilebrowseall.visible=$true
            $btncustfileexportall.visible=$true
            
        }
        4 {
            $labelimportdevhdr.visible=$true
            $labelimportdevhdr1.visible=$true
            $Labeldevfilein.visible=$true
            $textBoxdevfilein.visible=$true
            $btndevfilebrowsein.visible=$true
            $btndevfileimportone.visible=$true
            $btndevfilevalidateone.visible=$true
            
        }
        5 {
            $labelimporthdr.visible=$true
            $labelimporthdr1.visible=$true
            $Labelcustfilein.visible=$true
            $textBoxcustfilein.visible=$true
            $btncustfilebrowsein.visible=$true
            $btncustfileimportone.visible=$true
            $btncustfilevalidateone.visible=$true
            
        }

    }



}



#==============================================================================================================================================
# FUNCTION : fctgenerateacustomerlist
#==============================================================================================================================================

function fctgeneratecustomerlist
{

    #$global:fullcustlist=@()
        

    
    $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - Generating the Customer Array Variable " + "`r`n"


    $customerlist = Get-NCCustomerList 
    $solist = Get-NCServiceOrganizationList
    
    foreach ($cust in $customerlist)
    {
    
        $OutputObject = "" | Select-Object SOID,SOName,CustomerID,CustomerName,SiteID,SiteName
    
        $parentid=""
        $parentname=""
        $parentidparent=""
        $soid=""
        $soname=""
    
        #FIRST CHECK IF ITS ALREADY A CUSTOMER TO SAVE TIME
        foreach($so in $solist)
        {
            if($cust.parentid -eq $so.customerid)
            {
                #"PARENT IS SO. CUSTOMER IS FOUND"
                $soid = $so.customerid
                $soname=$so.customername
                break
            }
        }
        #IF NOT, FIND ITS PARENT
        if($soid -eq "")
        {
            #"THIS IS A SITE, FIND CUSTOMER"
            #loop through to find first parent
            foreach($parent in $customerlist)
            {
                if($parent.customerid -eq $cust.parentid)
                {
                    #"THIS WAS A SITE. CUSTOMER IS FOUND"
                    $parentid=$parent.customerid
                    $parentname=$parent.customername
                    $parentidparent=$parent.parentid
                    break
                }
            }
            #VERIFY IF THAT PARENT IS THE SO
            foreach($so in $solist)
            {
                if($parentidparent -eq $so.customerid)
                {
                    #"PARENT IS SO. CUSTOMER IS FOUND"
                    $soid = $so.customerid
                    $soname=$so.customername
                    break
                }
            }
    
        }
    
        $OutputObject.SOID=$soid
        $OutputObject.SOName=$soname
        if($parentid -eq "")
        {
            $OutputObject.CustomerID=$cust.customerid
            $OutputObject.CustomerName=$cust.customername
            $OutputObject.SiteID=""
            $OutputObject.SiteName=""
        }
        else 
        {
            $OutputObject.CustomerID=$parentid
            $OutputObject.CustomerName=$parentname
            $OutputObject.SiteID=$cust.customerid
            $OutputObject.SiteName=$cust.customername
        }
    
        $global:fullcustlist += $OutputObject
        }

        $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - Completed Generating the Customer Array Variable " + "`r`n"


}


#==============================================================================================================================================
# FUNCTION : fctvalidateimportcustomerpropertyfile
#==============================================================================================================================================
function fctvalidateimportcustomerpropertyfile()
{
    $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" ---------------------------------------------------------------------------------------------------------------------------------- " + "`r`n"
    $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - Validating the Customer Property Import File" + "`r`n"
    $global:validationstatus="False"

    if($textBoxcustfilein.text -ne "")
    {
        if(test-path $textBoxcustfilein.text)
        {
            $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - File was found, validating header" + "`r`n"
    
            $filecontent = get-content $textBoxcustfilein.text
            $headerdtl = $filecontent[1]
            $headerdtl=$headerdtl.replace('"','')
            if($Headerdtl -eq "SOID,SOName,CustomerID,CustomerName,SiteID,SiteName,propertyname,propertyvalue")
            {
                $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - File header matches desired format" + "`r`n"
                $totalrowstoimport=$filecontent.count -2
                $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - Total rows to import: $totalrowstoimport" + "`r`n"
                $global:validationstatus="True"
                $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - File validation successful" + "`r`n"
            }
            else 
            {
                $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - File header does not matches desired format, aborting" + "`r`n"
                
            }
        }
        else 
        {
            $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - File could not be opened, aborting" + "`r`n"
        }
    }
    else 
    {
        $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - No file was selected. Please select a file first. Aborting" + "`r`n"
    }
}

function fctvalidateimportdevicepropertyfile()
{
    $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" ---------------------------------------------------------------------------------------------------------------------------------- " + "`r`n"
    $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - Validating the Custom Device Property Import File" + "`r`n"
    $global:validationstatus="False"

    if($textBoxdevfilein.text -ne "")
    {
        if(test-path $textBoxdevfilein.text)
        {
            $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - File was found, validating header" + "`r`n"
    
            $filecontent = get-content $textBoxdevfilein.text
            write-host $Headerdtl
            $headerdtl = $filecontent[1]
            if($Headerdtl -like "*DeviceID*" -and $headerdtl -like "*ID_SiteName*")
            {
                $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - File header matches desired format" + "`r`n"
                $totalrowstoimport=$filecontent.count -2
                $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - Total rows to import: $totalrowstoimport" + "`r`n"
                $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - File validation successful" + "`r`n"
                $global:validationstatus="True"
            }
            else 
            {
                $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - File header does not matches desired format, aborting" + "`r`n"
            }
        }
        else 
        {
            $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - File could not be opened, aborting" + "`r`n"
        }
    }
    else 
    {
        $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - No file was selected. Please select a file first. Aborting" + "`r`n"
    }
}


#==============================================================================================================================================
# FUNCTION : fctgenerateacustomerlist
#==============================================================================================================================================

function fctimportcustomerproperty
{
    $datenow=Get-Date

    fctvalidateimportcustomerpropertyfile
    if($global:validationstatus -eq "True")
    {
        #OUTPUT LOG
        $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" ---------------------------------------------------------------------------------------------------------------------------------- " + "`r`n"
        $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - Importing a Customer-level Property" + "`r`n"

        $filepath = $textBoxcustfilein.text

        if(test-path $filepath)
        {
            "File Found"
            $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - File was found. Proceeding with import" + "`r`n"
            $csvfile = import-csv $filepath
            #$csvfile.count


            $filecontent = get-content $filepath
            $headerdtl = $filecontent[1].split(",")
            $PropertyLabel = $headerdtl[6]
            $propertyvalue = $headerdtl[7]

            $importedrow=0
            foreach ($csvrow in $csvfile)
            {
                $csvrow.SiteID
                if($csvrow.SiteID -eq "")
                {
                    Set-NCCustomerProperty -CustomerIDs $csvrow.CustomerID -PropertyLabel  $csvrow.$PropertyLabel  -PropertyValue $csvrow.$propertyvalue 
                }
                else 
                {
                    Set-NCCustomerProperty -CustomerIDs $csvrow.SiteID -PropertyLabel  $csvrow.$PropertyLabel  -PropertyValue $csvrow.$propertyvalue > $outputstuff
                }
                $importedrow+=1

            }
            $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - Import complete. $importedrow were processed. review the PowerShell output for any failed uploads" + "`r`n"
        }
        else
        {
            "File not Found"
            $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - File was not found or cannot be accessed. aborting" + "`r`n"
        }
    }
    $global:validationstatus -eq "False"
}

#==============================================================================================================================================
# FUNCTION : fctgenerateacustomerlist
#==============================================================================================================================================

function fctimportdeviceproperty
{
    $datenow=Get-Date

    fctvalidateimportdevicepropertyfile

    if($global:validationstatus -eq "True")
    {
        #OUTPUT LOG
        $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" ---------------------------------------------------------------------------------------------------------------------------------- " + "`r`n"
        $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - Importing a Custom Device Property" + "`r`n"

        $filepath = $textBoxdevfilein.text

        if(test-path $filepath)
        {
            $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - File was found. Proceeding with import" + "`r`n"
            "File Found"
            $csvfile = import-csv $filepath 
            #$csvfile.count

            $filecontent = get-content $filepath
            $headerdtl = $filecontent[1].split(",")
            $propertyname = $headerdtl[5]
            $propertyname=$propertyname.replace('"','')

            $importedrow=0
            foreach ($csvrow in $csvfile)
            {
                Set-NCDeviceProperty -DeviceIDs $csvrow.deviceid -PropertyName $propertyname -PropertyValue $csvrow.$propertyname
                $importedrow+=1
            }
            $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - Import complete. $importedrow were processed" + "`r`n"
        }
        else {
            "File not Found"
            $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - File was not found or cannot be accessed. aborting" + "`r`n"
        }
    }
    $global:validationstatus -eq "False"
}


#==============================================================================================================================================
# FUNCTION : ftExportaDeviceproperty
#==============================================================================================================================================
function fctExportaDeviceproperty
{
    $datenow = Get-Date

    #VALIDATION

    if($labelncsrvstatus2.text -eq "Connected")
    {
        $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" ---------------------------------------------------------------------------------------------------------------------------------- " + "`r`n"
        $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - Exporting One Custom Device Property " + $textBoxdevpropidone.text + "`r`n"
        if($textBoxdevpropidone.text -ne "")
        {
            if($textboxdevcustidone.text -eq "" -and $chkboxdevcustidone.checked -eq $False)
            {
                $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - The customer is is blank and <All Customers> is not selected, Aborting " + "`r`n"
                $validation=$false
            }
            else
            {
                if($textBoxdevfile.text -eq "")
                {
                    $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - No output file path was provided, Aborting " + "`r`n"
                }
                else
                {
                    $validation=$true   
                }
            }
        }
        else
        {
            $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - Custom Property Field Blank, Aborting " + "`r`n"
            $validation=$false
        }
    }
    else
    {
        $validation=$false
        $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - N-central API not connected yet. Please click the Connect button first" + "`r`n"
    }
    
    if($validation -eq $True)
    {
        if($global:fullcustlist.count -eq 0)
        {
            fctgeneratecustomerlist
        }

        if($chkboxdevcustidone.checked -eq $true)
        {
            $CustomerID = 50
            $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - Getting All Customers " + "`r`n"
            $devicelist = Get-NCCustomerlist 50 | Get-NCDeviceList
        }
        else 
        {
            $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - Getting data for customer " + $textboxdevcustidone.text + "`r`n"
            $Propertylist = Get-NCCustomerPropertyList 
            $devicelist = get-ncdevicelist $textboxdevcustidone.text 
        }
        


        $CDP=$textBoxdevpropidone.text
        $Propertylist = ($devicelist | Tee-Object -variable LookUpList) | 
            get-ncdevicepropertylist | 
            Select-object DeviceID,
                        @{n="DeviceName" ; 
                        e={$DID=$_.deviceid ; 
                        (@($LookupList).Where({ $_.deviceid -eq $DID})).longname}}, 
                        @{n="CustomerID" ; 
                        e={$DID=$_.deviceid ; 
                        (@($LookupList).Where({ $_.deviceid -eq $DID})).customerid}}, 
                        @{n="CustomerName" ; 
                        e={$DID=$_.deviceid ; 
                        (@($LookupList).Where({ $_.deviceid -eq $DID})).customername}}, 
                        @{n="sitename" ; 
                        e={$DID=$_.deviceid ; 
                        (@($LookupList).Where({ $_.deviceid -eq $DID})).sitename}}, 
                        $CDP -ErrorAction SilentlyContinue #| export-csv $OutFile #Out-File $OutFile 
        
        #$Propertylist | Add-Member -NotePropertyName "ID_DeviceName" -NotePropertyValue ""
        $Propertylist | Add-Member -NotePropertyName "ID_DeviceClass" -NotePropertyValue ""
        $Propertylist | Add-Member -NotePropertyName "ID_SOID" -NotePropertyValue ""
        $Propertylist | Add-Member -NotePropertyName "ID_SOName" -NotePropertyValue ""
        $Propertylist | Add-Member -NotePropertyName "ID_Customer_ID" -NotePropertyValue ""
        $Propertylist | Add-Member -NotePropertyName "ID_CustomerName" -NotePropertyValue ""
        $Propertylist | Add-Member -NotePropertyName "ID_SiteID" -NotePropertyValue ""
        $Propertylist | Add-Member -NotePropertyName "ID_SiteName" -NotePropertyValue ""
                 
       # $Propertylist | export-csv C:\temp\onecdp.Csv
        
        $rowid=0
        while($Propertylist.count -gt $rowid)
        {
            #FIND DEVICE NAME
            $devicerow = $devicelist | Where-Object {$_.deviceid -eq $propertylist[$rowid].DeviceID}
            #$propertylist[$rowid].ID_Devicename = $devicerow.longname
            $propertylist[$rowid].ID_DeviceClass = $devicerow.deviceclass
            $customerid=$devicerow.customerid
        
            #find customer row
            foreach($fullcustrow in $fullcustlist)
            {
                if($fullcustrow.siteid -eq $customerid)
                {
                    #SITE FOUND
                    $propertylist[$rowid].ID_SOID=$fullcustrow.soid
                    $propertylist[$rowid].ID_SOName=$fullcustrow.soname
                    $propertylist[$rowid].ID_Customer_ID=$fullcustrow.customerid
                    $propertylist[$rowid].ID_CustomerName=$fullcustrow.customername
                    $propertylist[$rowid].ID_SiteID=$fullcustrow.siteid
                    $propertylist[$rowid].ID_SiteName=$fullcustrow.sitename
                    break
                }
                else
                {
                    if($fullcustrow.customerid -eq $customerid)
                    {
                        #"CUSTOMER FOUND"
                        $propertylist[$rowid].ID_SOID=$fullcustrow.soid
                        $propertylist[$rowid].ID_SOName=$fullcustrow.soname
                        $propertylist[$rowid].ID_Customer_ID=$fullcustrow.customerid
                        $propertylist[$rowid].ID_CustomerName=$fullcustrow.customername
                                break
                    }
                    else
                    {
                        if($fullcustrow.soid -eq $customerid)
                        {
                            #"SO FOUND"
                            $propertylist[$rowid].ID_SOID=$fullcustrow.soid
                            $propertylist[$rowid].ID_SOName=$fullcustrow.soname
                                        break
                        }
            
                    }
                }
            }
        
        
            $rowid=$rowid+1
        }
        
        $propertylist | export-csv $textBoxdevfile.text
        
        

        $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() + " - Export Completed" + "`r`n"

    }
}

function fctExportAllDeviceProperties
{
    $datenow = Get-Date

    #VALIDATION

    if($labelncsrvstatus2.text -eq "Connected")
    {
        $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" ---------------------------------------------------------------------------------------------------------------------------------- " + "`r`n"
        $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - Exporting All Custom Device Property " + "`r`n"
        if($textboxdevcustidall.text -eq "" -and $chkboxdevcustidall.checked -eq $False)
        {
            $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - The customer is is blank and <All Customers> is not selected, Aborting " + "`r`n"
            $validation=$false
        }
        else
        {
            if($textBoxdevfileall.text -eq "")
            {
                $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - No output file path was provided, Aborting " + "`r`n"
            }
            else
            {
                $validation=$true   
            }
        }
    }
    else
    {
        $validation=$false
        $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - N-central API not connected yet. Please click the Connect button first" + "`r`n"
    }
    
    if($validation -eq $True)
    {
        if($chkboxdevcustidall.checked -eq $true)
        {
            $CustomerID = 50
            $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - Getting All Customers " + "`r`n"
            $devicelist = Get-NCCustomerlist 50 | Get-NCDeviceList
        }
        else 
        {
            $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - Getting data for customer " + $textboxdevcustidall.text + "`r`n"
            $Propertylist = Get-NCCustomerPropertyList 
            $devicelist = get-ncdevicelist $textboxdevcustidall.text 
        }

        $Propertylist = ($devicelist | Tee-Object -variable LookUpList) | 
        get-ncdevicepropertylist
    
    #$Propertylist | Add-Member -NotePropertyName "ID_DeviceName" -NotePropertyValue ""
    $Propertylist | Add-Member -NotePropertyName "ID_DeviceClass" -NotePropertyValue ""
    $Propertylist | Add-Member -NotePropertyName "ID_SOID" -NotePropertyValue ""
    $Propertylist | Add-Member -NotePropertyName "ID_SOName" -NotePropertyValue ""
    $Propertylist | Add-Member -NotePropertyName "ID_Customer_ID" -NotePropertyValue ""
    $Propertylist | Add-Member -NotePropertyName "ID_CustomerName" -NotePropertyValue ""
    $Propertylist | Add-Member -NotePropertyName "ID_SiteID" -NotePropertyValue ""
    $Propertylist | Add-Member -NotePropertyName "ID_SiteName" -NotePropertyValue ""
    $Propertylist | Add-Member -NotePropertyName "ID_DeviceName" -NotePropertyValue ""
             
#    $Propertylist | export-csv C:\temp\onecdp.Csv

 
    if($global:fullcustlist.count -eq 0)
    {
        fctgeneratecustomerlist
    }


    $rowid=0
    while($Propertylist.count -gt $rowid)
    {
        #FIND DEVICE NAME
        $devicerow = $devicelist | Where-Object {$_.deviceid -eq $propertylist[$rowid].DeviceID}
        $propertylist[$rowid].ID_Devicename = $devicerow.longname
        $propertylist[$rowid].ID_DeviceClass = $devicerow.deviceclass
        $customerid=$devicerow.customerid
    
        #find customer row
        foreach($fullcustrow in $fullcustlist)
        {
            write-host "X"
            if($fullcustrow.siteid -eq $customerid)
            {
                
                #SITE FOUND
                $propertylist[$rowid].ID_SOID=$fullcustrow.soid
                $propertylist[$rowid].ID_SOName=$fullcustrow.soname
                $propertylist[$rowid].ID_Customer_ID=$fullcustrow.customerid
                $propertylist[$rowid].ID_CustomerName=$fullcustrow.customername
                $propertylist[$rowid].ID_SiteID=$fullcustrow.siteid
                $propertylist[$rowid].ID_SiteName=$fullcustrow.sitename
                break
            }
            else
            {
                if($fullcustrow.customerid -eq $customerid)
                {
                    #"CUSTOMER FOUND"
                    $propertylist[$rowid].ID_SOID=$fullcustrow.soid
                    $propertylist[$rowid].ID_SOName=$fullcustrow.soname
                    $propertylist[$rowid].ID_Customer_ID=$fullcustrow.customerid
                    $propertylist[$rowid].ID_CustomerName=$fullcustrow.customername
                            break
                }
                else
                {
                    if($fullcustrow.soid -eq $customerid)
                    {
                        #"SO FOUND"
                        $propertylist[$rowid].ID_SOID=$fullcustrow.soid
                        $propertylist[$rowid].ID_SOName=$fullcustrow.soname
                                    break
                    }
        
                }
            }
        }
    
    
        $rowid=$rowid+1
    }
    
    $propertylist | export-csv $textBoxdevfileall.text 

        $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - Export Completed " + $textboxdevcustidone.text + "`r`n"
        
    }
}

function fctexportallcustomerproperties
{
    $datenow = Get-Date

    #VALIDATION

    if($labelncsrvstatus2.text -eq "Connected")
    {
        $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" ---------------------------------------------------------------------------------------------------------------------------------- " + "`r`n"
        $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - Exporting All Customer-Level Properties " + "`r`n"
        if($textBoxcustcustidall.text -eq "" -and $chkboxcustcustidall.checked -eq $False)
        {
            $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - The customer is is blank and <All Customers> is not selected, Aborting " + "`r`n"
            $validation=$false
        }
        else
        {
            if($textBoxcustfileall.text -eq "")
            {
                $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - No output file path was provided, Aborting " + "`r`n"
            }
            else
            {
                $validation=$true   
            }
        }
    }
    else
    {
        $validation=$false
        $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - N-central API not connected yet. Please click the Connect button first" + "`r`n"
    }
    
    if($validation -eq $True)
    {
        if($chkboxcustcustidall.checked -eq $true)
        {
            $CustomerID = 50
            $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - Getting All Customers " + "`r`n"
            $Propertylist = Get-NCCustomerPropertyList
        }
        else 
        {
            $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - Getting data for customer " + $textBoxcustcustidall.text + "`r`n"
            $Propertylist = Get-NCCustomerPropertyList $textBoxcustcustidall.text
        }


        $Propertylist | Add-Member -NotePropertyName "ID_SOID" -NotePropertyValue ""
        $Propertylist | Add-Member -NotePropertyName "ID_SOName" -NotePropertyValue ""
        $Propertylist | Add-Member -NotePropertyName "ID_Customer_ID" -NotePropertyValue ""
        $Propertylist | Add-Member -NotePropertyName "ID_CustomerName" -NotePropertyValue ""
        $Propertylist | Add-Member -NotePropertyName "ID_SiteID" -NotePropertyValue ""
        $Propertylist | Add-Member -NotePropertyName "ID_SiteName" -NotePropertyValue ""

        if($global:fullcustlist.count -eq 0)
        {
            fctgeneratecustomerlist
        }

        #$global:fullcustlist | export-csv c:\temp\fullcustomerlist.csv
        #$customerlist | export-csv -path c:\temp\customerlist.csv
        
        #$customerlist.count
        $rowid=0
        while($propertylist.count -gt $rowid)
        {
            #find customer row
            foreach($fullcustrow in $global:fullcustlist)
            {
                if($fullcustrow.siteid -eq $propertylist[$rowid].customerid)
                {
                    #SITE FOUND
                    $propertylist[$rowid].ID_SOID=$fullcustrow.SOID
                    $propertylist[$rowid].ID_SOName=$fullcustrow.SOName
                    $propertylist[$rowid].ID_Customer_ID = $fullcustrow.CustomerID
                    $propertylist[$rowid].ID_CustomerName =  $fullcustrow.CustomerName
                    $propertylist[$rowid].ID_SiteID = $fullcustrow.Siteid
                    $propertylist[$rowid].ID_SiteName = $fullcustrow.SiteName
                    break
                }
                else
                {
                    if($fullcustrow.customerid -eq $propertylist[$rowid].customerid)
                    {
                        #"CUSTOMER FOUND"
                        $propertylist[$rowid].ID_SOID=$fullcustrow.SOID
                        $propertylist[$rowid].ID_SOName=$fullcustrow.SOName
                        $propertylist[$rowid].ID_Customer_ID = $fullcustrow.CustomerID
                        $propertylist[$rowid].ID_CustomerName =  $fullcustrow.CustomerName
                        $propertylist[$rowid].ID_SiteID = ""
                        $propertylist[$rowid].ID_SiteName = ""
                                break
                    }
                    else
                    {
                        if($fullcustrow.soid -eq $propertylist[$rowid].customerid)
                        {
                            #"SO FOUND"
                            $propertylist[$rowid].ID_SOID=$fullcustrow.SOID
                            $propertylist[$rowid].ID_SOName=$fullcustrow.SOName
                            $propertylist[$rowid].ID_Customer_ID =""
                            $propertylist[$rowid].ID_CustomerName =""
                            $propertylist[$rowid].ID_SiteID = ""
                            $propertylist[$rowid].ID_SiteName = ""
                
                                break
                        }
            
                    }
                }
            }
            $rowid = $rowid + 1
        }
        
        $Propertylist | Export-Csv -Path $textBoxcustfileall.text -NoTypeInformation

        $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - Export Completed " + $textboxdevcustidone.text + "`r`n"
    }



}

function fctexportonecustomerproperty
{
    $datenow = Get-Date

    #VALIDATION

    if($labelncsrvstatus2.text -eq "Connected")
    {
        $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" ---------------------------------------------------------------------------------------------------------------------------------- " + "`r`n"
        $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - Exporting All Customer-Level Properties " + "`r`n"
        if($textBoxcustcustidone.text -eq "" -and $chkboxcustcustidone.checked -eq $False)
        {
            $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - The customer is is blank and <All Customers> is not selected, Aborting " + "`r`n"
            $validation=$false
        }
        else
        {
            if($textBoxcustfile.text -eq "")
            {
                $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - No output file path was provided, Aborting " + "`r`n"
            }
            else
            {
                if($textBoxcustpropidone.text -eq "")
                {
                    $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - No Custom Property was entered, aborting " + "`r`n"
                }
                else
                {
                    $validation=$true   
                }
            }
        }
    }
    else
    {
        $validation=$false
        $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - N-central API not connected yet. Please click the Connect button first" + "`r`n"
    }
    
    if($validation -eq $True)
    {
        if($chkboxcustcustidone.checked -eq $true)
        {
            $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - Getting All Customers " + "`r`n"
            $Propertylist = Get-NCCustomerPropertyList
        }
        else 
        {
            $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - Getting data for customer " + $textBoxcustcustidall.text + "`r`n"
            $Propertylist = Get-NCCustomerPropertyList $textBoxcustcustidone.text
        }

        $fieldname=$textBoxcustpropidone.text

        $fullpropertylist=@()
        
        if($global:fullcustlist.count -eq 0)
        {
            fctgeneratecustomerlist
        }

        foreach ($custproperty in $propertylist)
        {
            $Outputproprow = "" | Select-Object SOID,SOName,CustomerID,CustomerName,SiteID,SiteName,propertyname,propertyvalue
            #find customer row
            foreach($fullcustrow in $global:fullcustlist)
            {
                $Outputproprow.soid=""
                $Outputproprow.soname=""
                $Outputproprow.customerid=""
                $Outputproprow.customername=""
                $Outputproprow.siteid=""
                $Outputproprow.sitename=""
                $Outputproprow.propertyname=""
                $Outputproprow.propertyvalue=""
                if($fullcustrow.siteid -eq $custproperty.customerid)
                {
                    #SITE FOUND
                    $Outputproprow.soid=$fullcustrow.soid
                    $Outputproprow.soname=$fullcustrow.soname
                    $Outputproprow.customerid=$fullcustrow.customerid
                    $Outputproprow.customername=$fullcustrow.customername
                    $Outputproprow.siteid=$fullcustrow.siteid
                    $Outputproprow.sitename=$fullcustrow.sitename
                    $Outputproprow.propertyname=$fieldname
                    $Outputproprow.propertyvalue=$custproperty.$fieldname
                    break
                }
                else
                {
                    if($fullcustrow.customerid -eq $custproperty.customerid)
                    {
                        #"CUSTOMER FOUND"
                        $Outputproprow.soid=$fullcustrow.soid
                        $Outputproprow.soname=$fullcustrow.soname
                        $Outputproprow.customerid=$fullcustrow.customerid
                        $Outputproprow.customername=$fullcustrow.customername
                        $Outputproprow.propertyname=$fieldname
                        $Outputproprow.propertyvalue=$custproperty.$fieldname
                            break
                    }
                    else
                    {
                        if($fullcustrow.soid -eq $custproperty.customerid)
                        {
                            #"SO FOUND"
                            $Outputproprow.soid=$fullcustrow.soid
                            $Outputproprow.soname=$fullcustrow.soname
                            $Outputproprow.propertyname=$fieldname
                            $Outputproprow.propertyvalue=$custproperty.$fieldname
                                break
                        }
            
                    }
                }
            }
            $fullpropertylist+=$Outputproprow
            
        }
        
        $fullpropertylist | export-csv $textBoxcustfile.text


#        $Propertylist | Export-Csv -Path $textBoxcustfile.text -NoTypeInformation

        $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - Export Completed " + $textboxdevcustidone.text + "`r`n"
    }
}










function Generate-Form
{
    #CREATE FORM SETUP
    Add-Type -assembly System.Windows.Forms
    $main_form = New-Object System.Windows.Forms.Form
    $main_form.Text ='N-central Custom Property Import/Export tool'
    $main_form.Width = 825
    $main_form.Height = 830
    $main_form.StartPosition = "CenterScreen"
    $main_form.BackColor = [System.Drawing.Color]::FromArgb(255,0,0,0)
    $main_form.AutoSize=$false
    $main_form.autoscale = $false
    $main_form.FormBorderStyle="Fixed3D"
    $main_form.MaximizeBox=$false
    #$main_form.AutoSize = $true
    

    #$path="c:\temp\2204_Q2_Head_Nerds_Teams_BG_Space_invaders.png"
    #$base64 = [convert]::ToBase64String((get-content $path -encoding byte))
    #$base64 | out-file c:\temp\base64logo.txt

    #CREATE TOP LOGO IMAGE

    $base64ImageString = "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"
    $imageBytes = [Convert]::FromBase64String($base64ImageString)
    $ms = New-Object IO.MemoryStream($imageBytes, 0, $imageBytes.Length)
    $ms.Write($imageBytes, 0, $imageBytes.Length);
    $NerdLogo = [System.Drawing.Image]::FromStream($ms, $true)
    $pictureBox = new-object Windows.Forms.PictureBox
    $pictureBox.Width =  $NerdLogo.Size.Width;
    $pictureBox.Height =  $NerdLogo.Size.Height; 
    $pictureBox.Location = New-Object System.Drawing.Size(0,0) 
    $pictureBox.Image = $NerdLogo;
    $main_form.Controls.Add($pictureBox)

    #==============================================================================================================================================
    # SECTION : TOP SECTION FIELDS
    #==============================================================================================================================================

    #Label for NC Server
    $Labelncsrv = New-Object System.Windows.Forms.Label
    $Labelncsrv.Text = "Server Address: "
    $Labelncsrv.Location  = New-Object System.Drawing.Point(0,100)
    $Labelncsrv.AutoSize = $true
    $labelncsrv.ForeColor = "White"
    $labelncsrv.font = "Calibri"
    $main_form.Controls.Add($Labelncsrv)
   
    #Textbox for NC Server
    $textBoxncsrv = New-Object System.Windows.Forms.TextBox
    $textBoxncsrv.Location = New-Object System.Drawing.Point(120,100)
    $textBoxncsrv.Size = New-Object System.Drawing.Size(340,20)
    $main_form.Controls.Add($textBoxncsrv)

    #Label for API KEY 
    $Labelapikey = New-Object System.Windows.Forms.Label
    $Labelapikey.Text = "API Key: "
    $Labelapikey.Location  = New-Object System.Drawing.Point(0,120)
    $Labelapikey.AutoSize = $true
    $labelapikey.ForeColor = "White"
    $labelapikey.font = "Calibri"
    $main_form.Controls.Add($Labelapikey)

    #Textbox for API Key 
    $textBoxapikey = New-Object System.Windows.Forms.TextBox
    $textBoxapikey.Location = New-Object System.Drawing.Point(120,120)
    $textBoxapikey.Size = New-Object System.Drawing.Size(340,20)
    $main_form.Controls.Add($textBoxapikey)

    #Button to Verify API Key
    $btnconnect = New-Object System.Windows.Forms.button
    $btnconnect.Location = New-Object System.Drawing.Size(480,100)
    $btnconnect.Size = New-Object System.Drawing.Size(75,40)
    $btnconnect.Text = "Connect to N-central"
    $btnconnect.ForeColor = "Black"
    $btnconnect.BackColor="White"
    $main_form.Controls.Add($btnconnect)

    #Header for Server Connection Status
    $Labelncsrvstatus = New-Object System.Windows.Forms.Label
    $Labelncsrvstatus.Text = "Status: "
    $Labelncsrvstatus.Location  = New-Object System.Drawing.Point(570,100)
    $labelncsrvstatus.size= new-object system.drawing.size(75,20)
    $Labelncsrvstatus.AutoSize = $true
    $labelncsrvstatus.ForeColor = "White"
    $labelncsrvstatus.font = "Calibri"
    $main_form.Controls.Add($Labelncsrvstatus)

    #Server Status Red/Green field
    $Labelncsrvstatus2 = New-Object System.Windows.Forms.Label
    $Labelncsrvstatus2.Text = "Not Connected "
    $Labelncsrvstatus2.Location  = New-Object System.Drawing.Point(570,120)
    $labelncsrvstatus2.size= new-object system.drawing.size(75,20)
    $Labelncsrvstatus2.AutoSize = $true
    $labelncsrvstatus2.ForeColor = "Red"
    $labelncsrvstatus2.font = "Calibri"
    $main_form.Controls.Add($Labelncsrvstatus2)

    #Help Button
    $btnhelp = New-Object System.Windows.Forms.button
    $btnhelp.Location = New-Object System.Drawing.Size(675,100)
    $btnhelp.Size = New-Object System.Drawing.Size(75,40)
    $btnhelp.Text = "Help"
    $btnhelp.ForeColor = "Black"
    $btnhelp.BackColor="White"
    $main_form.Controls.Add($btnhelp)

    #Label for API KEY 
    $Labelapikey = New-Object System.Windows.Forms.Label
    $Labelapikey.Text = "Pick a Desired Action: (NOTE : TO SELECT AN ACTION, ENSURE TO ENTER YOUR API JSON TOKEN (API KEY) AND N-CENTRAL SERVER ADDRESS, AND PRESS CONNECT"
    $Labelapikey.Location  = New-Object System.Drawing.Point(0,160)
    $Labelapikey.AutoSize = $true
    $labelapikey.ForeColor = "White"
    $labelapikey.font = "Calibri"
    $main_form.Controls.Add($Labelapikey)

    $listBox = New-Object System.Windows.Forms.ComboBox
    $listBox.DropDownStyle='DropdownList'
    $listBox.Location = New-Object System.Drawing.Point(120,160)
    $listBox.Size = New-Object System.Drawing.Size(340,20)
    $listBox.Height = 80
    [void] $listBox.Items.Add('Download a single custom device property for one or more customers')
    [void] $listBox.Items.Add('Download a single customer-level property for one or more customers')
    [void] $listBox.Items.Add('Download all custom device properties for one or more customers')
    [void] $listBox.Items.Add('Download all customer-level properties for one or more customers')
    [void] $listBox.Items.Add('Import back a single custom device property for one or more customers')
    [void] $listBox.Items.Add('Import back a single customer-level property for one or more customers')
    $main_form.Controls.add($listBox)

    #==============================================================================================================================================
    # SECTION : BOTTOM OF THE FORM
    #==============================================================================================================================================

    #output text box at bottom of form 
    $objTextoutput = New-Object System.Windows.Forms.TextBox 
    $objTextoutput.Multiline = $True;
    $objTextoutput.Location = New-Object System.Drawing.Size(0,600) 
    $objTextoutput.Size = New-Object System.Drawing.Size(800,180)
    $objTextoutput.Scrollbars = "Vertical"
    $objTextoutput.text=""
    $main_form.Controls.Add($objTextoutput)


    
    #==============================================================================================================================================
    # SECTION : SEPARATION LINES 
    #==============================================================================================================================================

    $objline1 = New-Object System.Windows.Forms.TextBox 
    $objline1.Multiline = $True;
    $objline1.Location = New-Object System.Drawing.Size(398,195) 
    $objline1.Size = New-Object System.Drawing.Size(2,600)
    $objline1.text=""
    $main_form.Controls.Add($objline1)

    $objline2 = New-Object System.Windows.Forms.TextBox 
    $objline2.Multiline = $True;
    $objline2.Location = New-Object System.Drawing.Size(0,195) 
    $objline2.Size = New-Object System.Drawing.Size(800,2)
    $objline2.text=""
    $main_form.Controls.Add($objline2)

    $objline3 = New-Object System.Windows.Forms.TextBox 
    $objline3.Multiline = $True;
    $objline3.Location = New-Object System.Drawing.Size(0,465) 
    $objline3.Size = New-Object System.Drawing.Size(800,2)
    $objline3.text=""
    $main_form.Controls.Add($objline3)

    $objline4 = New-Object System.Windows.Forms.TextBox 
    $objline4.Multiline = $True;
    $objline4.Location = New-Object System.Drawing.Size(0,345) 
    $objline4.Size = New-Object System.Drawing.Size(800,2)
    $objline4.text=""
    $main_form.Controls.Add($objline4)


    
    #==============================================================================================================================================
    # SECTION : SECTION FOR EXPORT 1 DEVICE PROPERTY
    #==============================================================================================================================================

    # Device - Section header field
    $labeldevexporthdr = New-Object System.Windows.Forms.Label
    $labeldevexporthdr.Text = "EXPORT A CUSTOM DEVICE PROPERTY"
    $labeldevexporthdr.Location  = New-Object System.Drawing.Point(000,190)
    $labeldevexporthdr.Size = new-object system.drawing.point(400,30)
    $labeldevexporthdr.TextAlign="MiddleCenter"
    $labeldevexporthdr.ForeColor = "White"
    $labeldevexporthdr.font = "Calibri"
    $main_form.Controls.Add($labeldevexporthdr)

    # Device - Section header field
    $labeldevexporthdr1 = New-Object System.Windows.Forms.Label
    $labeldevexporthdr1.Text = "This allows you to export a single device property for multiple devices that you can then import back to N-central"
    $labeldevexporthdr1.Location  = New-Object System.Drawing.Point(000,210)
    $labeldevexporthdr1.Size = new-object system.drawing.point(400,45)
    $labeldevexporthdr1.TextAlign="MiddleCenter"
    $labeldevexporthdr1.ForeColor = "White"
    $labeldevexporthdr1.font = "Calibri"
    $main_form.Controls.Add($labeldevexporthdr1)
    
    

    # Device - File Path label
    $Labeldevfile = New-Object System.Windows.Forms.Label
    $Labeldevfile.Text = "File Path : "
    $Labeldevfile.Location  = New-Object System.Drawing.Point(0,255)
    $Labeldevfile.AutoSize = $true
    $Labeldevfile.ForeColor = "White"
    $Labeldevfile.font = "Calibri"
    $main_form.Controls.Add($Labeldevfile)

    # Device - File Path Textbox
    $textBoxdevfile = New-Object System.Windows.Forms.TextBox
    $textBoxdevfile.Location = New-Object System.Drawing.Point(150,255)
    $textBoxdevfile.Size = New-Object System.Drawing.Size(175,20)
    $main_form.Controls.Add($textBoxdevfile)

    # Device - File Browse button
    $btndevfilebrowse = new-object System.Windows.Forms.Button
    $btndevfilebrowse.Location = New-Object System.Drawing.Size(330,255)
    $btndevfilebrowse.Size = New-Object System.Drawing.Size(50,20)
    $btndevfilebrowse.Text = "Browse"
    $btndevfilebrowse.ForeColor = "Black"
    $btndevfilebrowse.BackColor="White"
    $main_form.Controls.Add($btndevfilebrowse)

    $Labeldevcustidone = New-Object System.Windows.Forms.Label
    $Labeldevcustidone.Text = "CustomerID (or Site ID): "
    $Labeldevcustidone.Location  = New-Object System.Drawing.Point(000,275)
    $Labeldevcustidone.AutoSize = $true
    $Labeldevcustidone.ForeColor = "White"
    $Labeldevcustidone.font = "Calibri"
    $main_form.Controls.Add($Labeldevcustidone)
   
    $textBoxdevcustidone = New-Object System.Windows.Forms.TextBox
    $textBoxdevcustidone.Location = New-Object System.Drawing.Point(150,275)
    $textBoxdevcustidone.Size = New-Object System.Drawing.Size(100,20)
    $main_form.Controls.Add($textBoxdevcustidone)

    $chkboxdevcustidone = new-object System.Windows.Forms.CheckBox
    $chkboxdevcustidone.Location = New-Object System.Drawing.Point(270,275)
    $chkboxdevcustidone.size = New-Object System.Drawing.Point(20,20)
    $main_form.Controls.add($chkboxdevcustidone)

    $Labeldevcustidonechk = New-Object System.Windows.Forms.Label
    $Labeldevcustidonechk.Text = "All Customers"
    $Labeldevcustidonechk.Location  = New-Object System.Drawing.Point(290,278)
    $Labeldevcustidonechk.AutoSize = $true
    $Labeldevcustidonechk.ForeColor = "White"
    $Labeldevcustidonechk.font = "Calibri"
    $main_form.Controls.Add($Labeldevcustidonechk)

    $Labeldevpropidone = New-Object System.Windows.Forms.Label
    $Labeldevpropidone.Text = "Property Name: "
    $Labeldevpropidone.Location  = New-Object System.Drawing.Point(000,295)
    $Labeldevpropidone.AutoSize = $true
    $Labeldevpropidone.ForeColor = "White"
    $Labeldevpropidone.font = "Calibri"
    $main_form.Controls.Add($Labeldevpropidone)
   
    $textBoxdevpropidone = New-Object System.Windows.Forms.TextBox
    $textBoxdevpropidone.Location = New-Object System.Drawing.Point(150,295)
    $textBoxdevpropidone.Size = New-Object System.Drawing.Size(100,20)
    $main_form.Controls.Add($textBoxdevpropidone)

    $btndevfileexportone = new-object System.Windows.Forms.Button
    $btndevfileexportone.Location = New-Object System.Drawing.Size(10,320)
    $btndevfileexportone.Size = New-Object System.Drawing.Size(370,20)
    $btndevfileexportone.Text = "Export The Selected Device-Level Property"
    $btndevfileexportone.ForeColor = "Black"
    $btndevfileexportone.BackColor="White"
    $main_form.Controls.Add($btndevfileexportone)

    

    #==============================================================================================================================================
    # SECTION : SECTION FOR EXPORT 1 CUSTOMER-LEVEL PROPERTIES
    #==============================================================================================================================================

    # Cust - Section Header Field
    $labelexporthdr = New-Object System.Windows.Forms.Label
    $labelexporthdr.Text = "EXPORT A CUSTOMER-LEVEL PROPERTY"
    $labelexporthdr.Location  = New-Object System.Drawing.Point(400,190)
    $labelexporthdr.size= New-Object System.Drawing.Point(400,30)
    $labelexporthdr.TextAlign = "MiddleCenter"
    $labelexporthdr.ForeColor = "White"
    $labelexporthdr.font = "Calibri"
    $main_form.Controls.Add($labelexporthdr)

    # Cust - Section Header Field
    $labelexporthdr1 = New-Object System.Windows.Forms.Label
    $labelexporthdr1.Text = "This allows you to export a single customer-level property for multiple customers/sites that you can then export back to N-central"
    $labelexporthdr1.Location  = New-Object System.Drawing.Point(400,210)
    $labelexporthdr1.size= New-Object System.Drawing.Point(400,45)
    $labelexporthdr1.TextAlign = "MiddleCenter"
    $labelexporthdr1.ForeColor = "White"
    $labelexporthdr1.font = "Calibri"
    $main_form.Controls.Add($labelexporthdr1)
    
    # Cust - File Path Label
    $Labelcustfile = New-Object System.Windows.Forms.Label
    $Labelcustfile.Text = "File Path : "
    $Labelcustfile.Location  = New-Object System.Drawing.Point(400,255)
    $Labelcustfile.AutoSize = $true
    $Labelcustfile.ForeColor = "White"
    $Labelcustfile.font = "Calibri"
    $main_form.Controls.Add($Labelcustfile)
   
    # Cust - File Path Textbox
    $textBoxcustfile = New-Object System.Windows.Forms.TextBox
    $textBoxcustfile.Location = New-Object System.Drawing.Point(550,255)
    $textBoxcustfile.Size = New-Object System.Drawing.Size(175,20)
    $main_form.Controls.Add($textBoxcustfile)

    # Cust - File Browse Button
    $btncustfilebrowse = new-object System.Windows.Forms.Button
    $btncustfilebrowse.Location = New-Object System.Drawing.Size(730,255)
    $btncustfilebrowse.Size = New-Object System.Drawing.Size(50,20)
    $btncustfilebrowse.Text = "Browse"
    $btncustfilebrowse.ForeColor = "Black"
    $btncustfilebrowse.BackColor="White"
    $main_form.Controls.Add($btncustfilebrowse)

    $Labelcustcustidone = New-Object System.Windows.Forms.Label
    $Labelcustcustidone.Text = "CustomerID (or Site ID): "
    $Labelcustcustidone.Location  = New-Object System.Drawing.Point(400,275)
    $Labelcustcustidone.AutoSize = $true
    $Labelcustcustidone.ForeColor = "White"
    $Labelcustcustidone.font = "Calibri"
    $main_form.Controls.Add($Labelcustcustidone)
   
    $textBoxcustcustidone = New-Object System.Windows.Forms.TextBox
    $textBoxcustcustidone.Location = New-Object System.Drawing.Point(550,275)
    $textBoxcustcustidone.Size = New-Object System.Drawing.Size(100,20)
    $main_form.Controls.Add($textBoxcustcustidone)

    $chkboxcustcustidone = new-object System.Windows.Forms.CheckBox
    $chkboxcustcustidone.Location = New-Object System.Drawing.Point(670,275)
    $chkboxcustcustidone.size = New-Object System.Drawing.Point(20,20)
    $main_form.Controls.add($chkboxcustcustidone)

    $Labelcustcustidonechk = New-Object System.Windows.Forms.Label
    $Labelcustcustidonechk.Text = "All Customers"
    $Labelcustcustidonechk.Location  = New-Object System.Drawing.Point(690,278)
    $Labelcustcustidonechk.AutoSize = $true
    $Labelcustcustidonechk.ForeColor = "White"
    $Labelcustcustidonechk.font = "Calibri"
    $main_form.Controls.Add($Labelcustcustidonechk)

    $Labelcustpropidone = New-Object System.Windows.Forms.Label
    $Labelcustpropidone.Text = "Property Name: "
    $Labelcustpropidone.Location  = New-Object System.Drawing.Point(400,295)
    $Labelcustpropidone.AutoSize = $true
    $Labelcustpropidone.ForeColor = "White"
    $Labelcustpropidone.font = "Calibri"
    $main_form.Controls.Add($Labelcustpropidone)
   
    $textBoxcustpropidone = New-Object System.Windows.Forms.TextBox
    $textBoxcustpropidone.Location = New-Object System.Drawing.Point(550,295)
    $textBoxcustpropidone.Size = New-Object System.Drawing.Size(100,20)
    $main_form.Controls.Add($textBoxcustpropidone)

    $btncustfileexportone = new-object System.Windows.Forms.Button
    $btncustfileexportone.Location = New-Object System.Drawing.Size(410,320)
    $btncustfileexportone.Size = New-Object System.Drawing.Size(370,20)
    $btncustfileexportone.Text = "Export The Selected Customer-Level Property"
    $btncustfileexportone.ForeColor = "Black"
    $btncustfileexportone.BackColor="White"
    $main_form.Controls.Add($btncustfileexportone)



    #==============================================================================================================================================
    # SECTION : SECTION FOR IMPORTING CUSTOMER-LEVEL PROPERTIES
    #==============================================================================================================================================

    # Cust - Section Header Field
    $labelimporthdr = New-Object System.Windows.Forms.Label
    $labelimporthdr.Text = "IMPORT A CUSTOMER-LEVEL PROPERTY"
    $labelimporthdr.Location  = New-Object System.Drawing.Point(400,340)
    $labelimporthdr.size= New-Object System.Drawing.Point(400,30)
    $labelimporthdr.TextAlign = "MiddleCenter"
    $labelimporthdr.ForeColor = "White"
    $labelimporthdr.font = "Calibri"
    $main_form.Controls.Add($labelimporthdr)

    # Cust - Section Header Field
    $labelimporthdr1 = New-Object System.Windows.Forms.Label
    $labelimporthdr1.Text = "This allows you to import a single customer-level property for multiple customers/sites from the previously exported file"
    $labelimporthdr1.Location  = New-Object System.Drawing.Point(400,360)
    $labelimporthdr1.size= New-Object System.Drawing.Point(400,45)
    $labelimporthdr1.TextAlign = "MiddleCenter"
    $labelimporthdr1.ForeColor = "White"
    $labelimporthdr1.font = "Calibri"
    $main_form.Controls.Add($labelimporthdr1)
    
    # Cust - File Path Label
    $Labelcustfilein = New-Object System.Windows.Forms.Label
    $Labelcustfilein.Text = "File Path : "
    $Labelcustfilein.Location  = New-Object System.Drawing.Point(400,410)
    $Labelcustfilein.AutoSize = $true
    $Labelcustfilein.ForeColor = "White"
    $Labelcustfilein.font = "Calibri"
    $main_form.Controls.Add($Labelcustfilein)
   
    # Cust - File Path Textbox
    $textBoxcustfilein = New-Object System.Windows.Forms.TextBox
    $textBoxcustfilein.Location = New-Object System.Drawing.Point(550,410)
    $textBoxcustfilein.Size = New-Object System.Drawing.Size(175,20)
    $main_form.Controls.Add($textBoxcustfilein)

    #impor Cust - File Browse Button
    $btncustfilebrowsein = new-object System.Windows.Forms.Button
    $btncustfilebrowsein.Location = New-Object System.Drawing.Size(730,410)
    $btncustfilebrowsein.Size = New-Object System.Drawing.Size(50,20)
    $btncustfilebrowsein.Text = "Browse"
    $btncustfilebrowsein.ForeColor = "Black"
    $btncustfilebrowsein.BackColor="White"
    $main_form.Controls.Add($btncustfilebrowsein)

    $btncustfileimportone = new-object System.Windows.Forms.Button
    $btncustfileimportone.Location = New-Object System.Drawing.Size(595,435)
    $btncustfileimportone.Size = New-Object System.Drawing.Size(185,20)
    $btncustfileimportone.Text = "Import"
    $btncustfileimportone.ForeColor = "Black"
    $btncustfileimportone.BackColor="White"
    $main_form.Controls.Add($btncustfileimportone)

    $btncustfilevalidateone = new-object System.Windows.Forms.Button
    $btncustfilevalidateone.Location = New-Object System.Drawing.Size(410,435)
    $btncustfilevalidateone.Size = New-Object System.Drawing.Size(185,20)
    $btncustfilevalidateone.Text = "Validate Input File"
    $btncustfilevalidateone.ForeColor = "Black"
    $btncustfilevalidateone.BackColor="White"
    $main_form.Controls.Add($btncustfilevalidateone)


    #==============================================================================================================================================
    # SECTION : SECTION FOR IMPORTING DEVICE-LEVEL PROPERTIES
    #==============================================================================================================================================

    # Cust - Section Header Field
    $labelimportdevhdr = New-Object System.Windows.Forms.Label
    $labelimportdevhdr.Text = "IMPORT A CUSTOM DEVICE PROPERTY"
    $labelimportdevhdr.Location  = New-Object System.Drawing.Point(00,340)
    $labelimportdevhdr.size= New-Object System.Drawing.Point(400,30)
    $labelimportdevhdr.TextAlign = "MiddleCenter"
    $labelimportdevhdr.ForeColor = "White"
    $labelimportdevhdr.font = "Calibri"
    $main_form.Controls.Add($labelimportdevhdr)

    # Cust - Section Header Field
    $labelimportdevhdr1 = New-Object System.Windows.Forms.Label
    $labelimportdevhdr1.Text = "This allows you to import a single customer-level property for multiple customers/sites from the previously exported file"
    $labelimportdevhdr1.Location  = New-Object System.Drawing.Point(000,360)
    $labelimportdevhdr1.size= New-Object System.Drawing.Point(400,45)
    $labelimportdevhdr1.TextAlign = "MiddleCenter"
    $labelimportdevhdr1.ForeColor = "White"
    $labelimportdevhdr1.font = "Calibri"
    $main_form.Controls.Add($labelimportdevhdr1)
    
    # dev - File Path Label
    $Labeldevfilein = New-Object System.Windows.Forms.Label
    $Labeldevfilein.Text = "File Path : "
    $Labeldevfilein.Location  = New-Object System.Drawing.Point(00,410)
    $Labeldevfilein.AutoSize = $true
    $Labeldevfilein.ForeColor = "White"
    $Labeldevfilein.font = "Calibri"
    $main_form.Controls.Add($Labeldevfilein)
   
    # dev - File Path Textbox
    $textBoxdevfilein = New-Object System.Windows.Forms.TextBox
    $textBoxdevfilein.Location = New-Object System.Drawing.Point(150,410)
    $textBoxdevfilein.Size = New-Object System.Drawing.Size(175,20)
    $main_form.Controls.Add($textBoxdevfilein)

    #impor dev - File Browse Button
    $btndevfilebrowsein = new-object System.Windows.Forms.Button
    $btndevfilebrowsein.Location = New-Object System.Drawing.Size(330,410)
    $btndevfilebrowsein.Size = New-Object System.Drawing.Size(50,20)
    $btndevfilebrowsein.Text = "Browse"
    $btndevfilebrowsein.ForeColor = "Black"
    $btndevfilebrowsein.BackColor="White"
    $main_form.Controls.Add($btndevfilebrowsein)

    $btndevfileimportone = new-object System.Windows.Forms.Button
    $btndevfileimportone.Location = New-Object System.Drawing.Size(195,435)
    $btndevfileimportone.Size = New-Object System.Drawing.Size(185,20)
    $btndevfileimportone.Text = "Import"
    $btndevfileimportone.ForeColor = "Black"
    $btndevfileimportone.BackColor="White"
    $main_form.Controls.Add($btndevfileimportone)

    $btndevfilevalidateone = new-object System.Windows.Forms.Button
    $btndevfilevalidateone.Location = New-Object System.Drawing.Size(010,435)
    $btndevfilevalidateone.Size = New-Object System.Drawing.Size(185,20)
    $btndevfilevalidateone.Text = "Validate Input File"
    $btndevfilevalidateone.ForeColor = "Black"
    $btndevfilevalidateone.BackColor="White"
    $main_form.Controls.Add($btndevfilevalidateone)




    #==============================================================================================================================================
    # SECTION : SECTION FOR EXPORTING ALL DEVICE LEVEL PROPERTIES IN ONE TABLE
    #==============================================================================================================================================

    #EX DEV - Header
    $labelexporthdrdev = New-Object System.Windows.Forms.Label
    $labelexporthdrdev.Text = "EXPORT ALL CUSTOM DEVICE PROPERTIES"
    $labelexporthdrdev.Location  = New-Object System.Drawing.Point(000,460)
    $labelexporthdrdev.Size = new-object system.drawing.point(400,30)
    $labelexporthdrdev.TextAlign="MiddleCenter"
    $labelexporthdrdev.ForeColor = "White"
    $labelexporthdrdev.font = "Calibri"
    $main_form.Controls.Add($labelexporthdrdev)

    $labelexporthdrdevdtl = New-Object System.Windows.Forms.Label
    $labelexporthdrdevdtl.Text = "This allows to export all device-level properties for one or all customers to a csv"
    $labelexporthdrdevdtl.Location  = New-Object System.Drawing.Point(000,480)
    $labelexporthdrdevdtl.Size = new-object system.drawing.point(400,30)
    $labelexporthdrdevdtl.TextAlign="MiddleCenter"
    $labelexporthdrdevdtl.ForeColor = "White"
    $labelexporthdrdevdtl.font = "Calibri"
    $main_form.Controls.Add($labelexporthdrdevdtl)

    $Labeldevfileall = New-Object System.Windows.Forms.Label
    $Labeldevfileall.Text = "File Path : "
    $Labeldevfileall.Location  = New-Object System.Drawing.Point(000,510)
    $Labeldevfileall.AutoSize = $true
    $Labeldevfileall.ForeColor = "White"
    $Labeldevfileall.font = "Calibri"
    $main_form.Controls.Add($Labeldevfileall)
   
    $textBoxdevfileall = New-Object System.Windows.Forms.TextBox
    $textBoxdevfileall.Location = New-Object System.Drawing.Point(150,510)
    $textBoxdevfileall.Size = New-Object System.Drawing.Size(175,20)
    $main_form.Controls.Add($textBoxdevfileall)

    $Labeldevcustidall = New-Object System.Windows.Forms.Label
    $Labeldevcustidall.Text = "CustomerID (or Site ID): "
    $Labeldevcustidall.Location  = New-Object System.Drawing.Point(000,530)
    $Labeldevcustidall.AutoSize = $true
    $Labeldevcustidall.ForeColor = "White"
    $Labeldevcustidall.font = "Calibri"
    $main_form.Controls.Add($Labeldevcustidall)
   
    $textBoxdevcustidall = New-Object System.Windows.Forms.TextBox
    $textBoxdevcustidall.Location = New-Object System.Drawing.Point(150,530)
    $textBoxdevcustidall.Size = New-Object System.Drawing.Size(100,20)
    $main_form.Controls.Add($textBoxdevcustidall)

    $chkboxdevcustidall = new-object System.Windows.Forms.CheckBox
    $chkboxdevcustidall.Location = New-Object System.Drawing.Point(270,530)
    $chkboxdevcustidall.size = New-Object System.Drawing.Point(20,20)
    $main_form.Controls.add($chkboxdevcustidall)

    $Labeldevcustidallchk = New-Object System.Windows.Forms.Label
    $Labeldevcustidallchk.Text = "All Customers"
    $Labeldevcustidallchk.Location  = New-Object System.Drawing.Point(290,533)
    $Labeldevcustidallchk.AutoSize = $true
    $Labeldevcustidallchk.ForeColor = "White"
    $Labeldevcustidallchk.font = "Calibri"
    $main_form.Controls.Add($Labeldevcustidallchk)


    $btndevfilebrowseall = new-object System.Windows.Forms.Button
    $btndevfilebrowseall.Location = New-Object System.Drawing.Size(330,510)
    $btndevfilebrowseall.Size = New-Object System.Drawing.Size(50,20)
    $btndevfilebrowseall.Text = "browse"
    $btndevfilebrowseall.ForeColor = "Black"
    $btndevfilebrowseall.BackColor="White"
    $main_form.Controls.Add($btndevfilebrowseall)

    $btndevfileexportall = new-object System.Windows.Forms.Button
    $btndevfileexportall.Location = New-Object System.Drawing.Size(010,560)
    $btndevfileexportall.Size = New-Object System.Drawing.Size(370,20)
    $btndevfileexportall.Text = "Export all Device-Level Properties"
    $btndevfileexportall.ForeColor = "Black"
    $btndevfileexportall.BackColor="White"
    $main_form.Controls.Add($btndevfileexportall)


    
    #==============================================================================================================================================
    # SECTION : SECTION FOR EXPORTING ALL CUSTOMER LEVEL PROPERTIES IN ONE TABLE
    #==============================================================================================================================================


    #EX DEV - Header
    $labelexporthdrcust = New-Object System.Windows.Forms.Label
    $labelexporthdrcust.Text = "EXPORT ALL CUSTOMER-LEVEL PROPERTIES"
    $labelexporthdrcust.Location  = New-Object System.Drawing.Point(400,460)
    $labelexporthdrcust.size= New-Object System.Drawing.Point(400,30)
    $labelexporthdrcust.TextAlign = "MiddleCenter"
    $labelexporthdrcust.ForeColor = "White"
    $labelexporthdrcust.font = "Calibri"
    $main_form.Controls.Add($labelexporthdrcust)

    $labelexporthdrcustdtl = New-Object System.Windows.Forms.Label
    $labelexporthdrcustdtl.Text = "This allows to export all customer-level properties for one or all customers to a csv"
    $labelexporthdrcustdtl.Location  = New-Object System.Drawing.Point(400,480)
    $labelexporthdrcustdtl.size= New-Object System.Drawing.Point(400,30)
    $labelexporthdrcustdtl.TextAlign = "MiddleCenter"
    $labelexporthdrcustdtl.ForeColor = "White"
    $labelexporthdrcustdtl.font = "Calibri"
    $main_form.Controls.Add($labelexporthdrcustdtl)


    $Labelcustfileall = New-Object System.Windows.Forms.Label
    $Labelcustfileall.Text = "File Path : "
    $Labelcustfileall.Location  = New-Object System.Drawing.Point(400,510)
    $Labelcustfileall.AutoSize = $true
    $Labelcustfileall.ForeColor = "White"
    $Labelcustfileall.font = "Calibri"
    $main_form.Controls.Add($Labelcustfileall)
   
    $textBoxcustfileall = New-Object System.Windows.Forms.TextBox
    $textBoxcustfileall.Location = New-Object System.Drawing.Point(550,510)
    $textBoxcustfileall.Size = New-Object System.Drawing.Size(175,20)
    $main_form.Controls.Add($textBoxcustfileall)

    $Labelcustcustidall = New-Object System.Windows.Forms.Label
    $Labelcustcustidall.Text = "CustomerID (or Site ID): "
    $Labelcustcustidall.Location  = New-Object System.Drawing.Point(400,530)
    $Labelcustcustidall.AutoSize = $true
    $Labelcustcustidall.ForeColor = "White"
    $Labelcustcustidall.font = "Calibri"
    $main_form.Controls.Add($Labelcustcustidall)
   
    $textBoxcustcustidall = New-Object System.Windows.Forms.TextBox
    $textBoxcustcustidall.Location = New-Object System.Drawing.Point(550,530)
    $textBoxcustcustidall.Size = New-Object System.Drawing.Size(100,20)
    $main_form.Controls.Add($textBoxcustcustidall)

    $chkboxcustcustidall = new-object System.Windows.Forms.CheckBox
    $chkboxcustcustidall.Location = New-Object System.Drawing.Point(670,530)
    $chkboxcustcustidall.size = New-Object System.Drawing.Point(20,20)
    $main_form.Controls.add($chkboxcustcustidall)

    $Labelcustcustidallchk = New-Object System.Windows.Forms.Label
    $Labelcustcustidallchk.Text = "All Customers"
    $Labelcustcustidallchk.Location  = New-Object System.Drawing.Point(690,533)
    $Labelcustcustidallchk.AutoSize = $true
    $Labelcustcustidallchk.ForeColor = "White"
    $Labelcustcustidallchk.font = "Calibri"
    $main_form.Controls.Add($Labelcustcustidallchk)


    $btncustfilebrowseall = new-object System.Windows.Forms.Button
    $btncustfilebrowseall.Location = New-Object System.Drawing.Size(730,510)
    $btncustfilebrowseall.Size = New-Object System.Drawing.Size(50,20)
    $btncustfilebrowseall.Text = "browse"
    $btncustfilebrowseall.ForeColor = "Black"
    $btncustfilebrowseall.BackColor="White"
    $main_form.Controls.Add($btncustfilebrowseall)

    $btncustfileexportall = new-object System.Windows.Forms.Button
    $btncustfileexportall.Location = New-Object System.Drawing.Size(410,560)
    $btncustfileexportall.Size = New-Object System.Drawing.Size(370,20)
    $btncustfileexportall.Text = "Export all Customer-Level Properties"
    $btncustfileexportall.ForeColor = "Black"
    $btncustfileexportall.BackColor="White"
    $main_form.Controls.Add($btncustfileexportall)



    #ADD BUTTONS
    $btnconnect.add_click($btnconnect_click)
    $btndevfilebrowse.add_click($btndevfilebrowse_click)
    $btncustfilebrowse.add_click($btncustfilebrowse_click)
    $btndevfilebrowseall.add_click($btndevfilebrowseall_click)
    $btncustfilebrowseall.add_click($btncustfilebrowseall_click)
    $chkboxcustcustidall.add_click($chkboxcustcustidall_click)
    $chkboxdevcustidall.add_click($chkboxdevcustidall_click)
    $chkboxdevcustidone.add_click($chkboxdevcustidone_click)
    $chkboxcustcustidone.add_click($chkboxcustcustidone_click)
    $btncustfileexportone.add_click($btncustfileexportone_click)
    $btndevfileexportone.add_click($btndevfileexportone_click)
    $btncustfilebrowsein.add_click($btncustfilebrowsein_click)
    $btndevfilebrowsein.add_click($btndevfilebrowsein_click)
    $btndevfileexportall.add_click($btndevfileexportall_click)
    $btncustfileexportall.add_click($btncustfileexportall_click)
    $btncustfileimportone.add_click($btncustfileimportone_click)
    $btndevfileimportone.add_click($btndevfileimportone_click)
    $btncustfilevalidateone.add_click($btncustfilevalidateone_click)
    $btndevfilevalidateone.add_click($btndevfilevalidateone_click)


    #POPULATE THE LOG FIELD WITH LAUNCH INFORMATION
    $datenow = Get-Date
    $objTextoutput.text=$objTextoutput.text + $datenow.ToShortDateString() + " " + $datenow.ToLongTimeString() +" - N-central Custom Property Importer/Exporter V1.0.0 Launched " + "`r`n"

    $labeldevexporthdr.visible=$false
    $labeldevexporthdr1.visible=$false
    $Labeldevfile.visible=$false
    $textBoxdevfile.visible=$false
    $btndevfilebrowse.visible=$false
    $Labeldevcustidone.visible=$false
    $textBoxdevcustidone.visible=$false
    $chkboxdevcustidone.visible=$false
    $Labeldevcustidonechk.visible=$false
    $Labeldevpropidone.visible=$false
    $textBoxdevpropidone.visible=$false
    $btndevfileexportone.visible=$false
    
    
    
    
    $labelexporthdr.visible=$false
    $labelexporthdr1.visible=$false
    $Labelcustfile.visible=$false
    $textBoxcustfile.visible=$false
    $btncustfilebrowse.visible=$false
    $Labelcustcustidone.visible=$false
    $textBoxcustcustidone.visible=$false
    $chkboxcustcustidone.visible=$false
    $Labelcustcustidonechk.visible=$false
    $Labelcustpropidone.visible=$false
    $textBoxcustpropidone.visible=$false
    $btncustfileexportone.visible=$false
    
    
    
    $labelimporthdr.visible=$false
    $labelimporthdr1.visible=$false
    $Labelcustfilein.visible=$false
    $textBoxcustfilein.visible=$false
    $btncustfilebrowsein.visible=$false
    $btncustfileimportone.visible=$false
    $btncustfilevalidateone.visible=$false
    
    
    
    $labelimportdevhdr.visible=$false
    $labelimportdevhdr1.visible=$false
    $Labeldevfilein.visible=$false
    $textBoxdevfilein.visible=$false
    $btndevfilebrowsein.visible=$false
    $btndevfileimportone.visible=$false
    $btndevfilevalidateone.visible=$false
    
    
    
    $labelexporthdrdev.visible=$false
    $labelexporthdrdevdtl.visible=$false
    $Labeldevfileall.visible=$false
    $textBoxdevfileall.visible=$false
    $Labeldevcustidall.visible=$false
    $textBoxdevcustidall.visible=$false
    $chkboxdevcustidall.visible=$false
    $Labeldevcustidallchk.visible=$false
    $btndevfilebrowseall.visible=$false
    $btndevfileexportall.visible=$false
    
    
    
    $labelexporthdrcust.visible=$false
    $labelexporthdrcustdtl.visible=$false
    $Labelcustfileall.visible=$false
    $textBoxcustfileall.visible=$false
    $Labelcustcustidall.visible=$false
    $textBoxcustcustidall.visible=$false
    $chkboxcustcustidall.visible=$false
    $Labelcustcustidallchk.visible=$false
    $btncustfilebrowseall.visible=$false
    $btncustfileexportall.visible=$false
    

    $listbox.visible=$false


    #TEST DATA TO BE REMOVED
    $textBoxncsrv.Text = ""
    $textBoxapikey.text = ""



    $listBox.add_selectedindexchanged({
        fctactionchangedropdown($listbox.SelectedIndex)
    })




	
    

    $main_form.ShowDialog()

}

function Load-Module ($m) {

    # If module is imported say that and do nothing
    if (Get-Module | Where-Object {$_.Name -eq $m}) {
        write-host "Module $m is already imported."
    }
    else {

        # If module is not imported, but available on disk then import
        if (Get-Module -ListAvailable | Where-Object {$_.Name -eq $m}) {
            Import-Module $m -Verbose
        }
        else {

            # If module is not imported, not available on disk, but is in online gallery then install and import
            if (Find-Module -Name $m | Where-Object {$_.Name -eq $m}) {
                Install-Module -Name $m -Force -Verbose -Scope CurrentUser
                Import-Module $m -Verbose
            }
            else {

                # If the module is not imported, not available and not in the online gallery then abort
                write-host "Module $m not imported, not available and not in an online gallery, exiting."
                EXIT 1
            }
        }
    }
}


Load-Module "PS-Ncentral" 

Generate-Form

