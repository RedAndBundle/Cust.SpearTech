# $artifactUrl = Get-BCArtifactUrl -version 22 -type OnPrem -country nl -select Latest
$artifactUrl = Get-BCArtifactUrl -version 22 -type OnPrem -country w1 -select Latest
$containerName = 'SpearTech'
# $containerName = 'bc220-rb'
$credential = New-Object pscredential 'admin', (ConvertTo-SecureString -String 'admin' -AsPlainText -Force)
$licenseFile = 'X:\Onedrive\Red And Bundle\Development - Documents\Licenses\Business Central\BC22 On Prem ForNAV + Own Objects.bclicense'
$ucInstallFolder = 'X:\Sync\Red and Bundle\Development\Source Code\Cust.ForNAV\ForNAV Docker Installer\UniversalCodeApp 22'

# $additionalParameters = @("--publish 9031:9030")

New-BcContainer `
    -accept_eula `
    -containerName $containerName `
    -artifactUrl $artifactUrl `
    -Credential $credential `
    -auth UserPassword `
    -licenseFile $licenseFile `
    -updateHosts `
    -isolation hyperv `
    -EnableTaskScheduler:$true `
    -useGenericImage "$(Get-BestGenericImageName)-dev"
    # -additionalParameters $additionalParameters
    
#    -useSSL `

Add-FontsToBCContainer -containerName $containerName -path c:\windows\fonts\*.ttf

docker stop $containerName
$dest = "{0}:\{1}" -f $containerName, 'ForNAVUC'
docker cp $ucInstallFolder $dest

docker stop $containerName
$dest = "{0}:\{1}" -f $containerName, 'ProgramData\ForNAV\Report Service'
docker cp "C:\ProgramData\ForNAV\Report Service\Configuration" $dest

# docker run --rm -it $containerName