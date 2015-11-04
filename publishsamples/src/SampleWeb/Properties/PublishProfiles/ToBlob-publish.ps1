[cmdletbinding(SupportsShouldProcess=$true)]
param($publishProperties, $packOutput, $nugetUrl)

function Publish-FolderToBlobStorage{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true,Position=0)]
        [ValidateScript({Test-Path $_ -PathType Container})] 
        $folder,
        [Parameter(Mandatory=$true,Position=1)]
        $storageAcctName,
        [Parameter(Mandatory=$true,Position=2)]
        $storageAcctKey,
        [Parameter(Mandatory=$true,Position=3)]
        $containerName
    )
    begin{
        'Publishing folder to blob storage. [folder={0},storageAcctName={1},storageContainer={2}]' -f $folder,$storageAcctName,$containerName | Write-Output
        Push-Location
        Set-Location $folder
        $destContext = New-AzureStorageContext -StorageAccountName $storageAcctName -StorageAccountKey $storageAcctKey
    }
    end{ Pop-Location }
    process{
        $allFiles = (Get-ChildItem $folder -Recurse -File).FullName

        foreach($file in $allFiles){
            $relPath = (Resolve-Path $file -Relative).TrimStart('.\')
            "relPath: [$relPath]" | Write-Output

            Set-AzureStorageBlobContent -Blob $relPath -File $file -Container $containerName -Context $destContext
        }
    }
}

$storageAcctName = $publishProperties['StorageAcctName']
$storageAcctKey = $publishProperties['StorageAcctKey']
$storageContainer = $publishProperties['StorageContainer']

if([string]::IsNullOrWhiteSpace($storageAcctName)){ throw 'Missing StorageAcctName' }
if([string]::IsNullOrWhiteSpace($storageAcctKey)){ throw 'Missing StorageAcctKey' }
if([string]::IsNullOrWhiteSpace($storageContainer)){ throw 'Missing StorageContainer' }

"Publishing to blob container $storageContainer" | Write-Output
Publish-FolderToBlobStorage -folder $packOutput -storageAcctName $storageAcctName -storageAcctKey $storageAcctKey -containerName $storageContainer 