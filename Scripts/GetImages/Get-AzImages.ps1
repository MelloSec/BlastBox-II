$location = 'east us'
Get-AzVMImagePublisher -Location $location | Select PublisherName | Out-File -Filepath AzurePublisherList.txt

$ubuntu = 'Canonical'
$kali = 'kali-linux'
$Windows = 'MicrosoftWindowsDesktop'
$Server = 'MicrosoftWindowsServer'

Get-AzVMImageOffer -Location $location -PublisherName $ubuntu | Select Offer | Out-File -Filepath ubuntu.txt

Get-AzVMImageOffer -Location $location -PublisherName $Windows | Select Offer | Out-File -Filepath Windows.txt
Get-AzVMImageOffer -Location $location -PublisherName $Server | Select Offer | Out-File -Filepath Server.txt

$ubuntu = 'Canonical'
$kali = 'kali-linux'
$Windows = 'MicrosoftWindowsDesktop'
$Server = 'MicrosoftWindowsServer'
$ubuntuimage = 'ubuntuserver'
$kaliimage = 'kali-linux'

Get-AzVMImageSku -Location $location -PublisherName $ubuntu -Offer $ubuntuimage | Select Skus >> ubuntu.txt




# Kali
$location = 'east us'
$kali = 'kali-linux'
$kaliimage = 'kali'
Get-AzVMImageOffer -Location $location -PublisherName $kali | Select Offer | Out-File -Filepath kali.txt
Get-AzVMImageSku -Location $location -PublisherName $kali -Offer $kaliimage | Select Skus > kalisku.txt
Get-AzVMImageSku -Location $location -PublisherName $kali -Offer $kaliimage | Select Skus

$sku = "kali-20224"
Get-AzVMImage -Location $location -PublisherName $kali -Offer $kaliimage -Sku $sku | Select Version > kaliversion.txt
$version = cat kaliversion.txt

$version = "2022.4.1"

Get-AzVMImage -Location $location -PublisherName $kali -Offer $kaliimage -Sku $sku -Version $version
Get-AzVMImage -Location $location -PublisherName $kali -Offer $kaliimage -Sku $sku -Version $version

-Publisher $kali -Product $kaliimage -Name $sku 


$location = 'east us'
$kali = 'kali-linux'
$kaliimage = 'kali'
$sku = "kali-20224"
$agreementTerms=Get-AzMarketplaceterms -Publisher $kali -Product $kaliimage -Name $sku 
Set-AzMarketplaceTerms -Publisher $kali -Product $kaliimage -Name $sku  -Terms $agreementTerms -Accept

$vmConfig = Set-AzVMPlan -VM  -Publisher $publisherName -Product $productName -Name $planName