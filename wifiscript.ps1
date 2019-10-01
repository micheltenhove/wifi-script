## Generate the certificate from a On-Prem AD Joined device ##
## If you want this wi-fi profile to be non-removable from an end user perspective, ##
## then also make an Intune Profile with the wifiprofile.xml content that is the same as this one ##
## Reason that I'm choosing this way to do it, is that I want to be sure the wi-fi profile is created when this script ran, the intune policy will eventually force the wi-fi profile so It can't be deleted anymore ##

## Create Folder ##
New-Item -ItemType directory -Path C:\wifi -Force

## Download necessary files from Azure Blob with SAS URL ##
Invoke-WebRequest -Uri "https://intuneresources.blob.core.windows.net/" -OutFile "C:\wifi\certificate.pfx"
Invoke-WebRequest -Uri "https://intuneresources.blob.core.windows.net/" -OutFile "C:\wifi\wifiprofile.xml"

## Import Certificate and connect to the wi-fi network ##
Import-PfxCertificate -FilePath C:\wifi\certificate.pfx -Password (ConvertTo-SecureString -String 'CERTPASS' -AsPlainText -Force) -CertStoreLocation Cert:\LocalMachine\My
netsh wlan add profile filename="C:\wifi\wifiprofile.xml" user=all

## Remove the folder including the content ##
Remove-Item -Path C:\wifi -Force -Recurse
