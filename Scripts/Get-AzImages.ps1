$location = 'east us'
Get-AzVMImagePublisher -Location $location | Select PublisherName | Out-File -Filepath AzurePublisherList.txt

$ubuntu = 'Canonical'
$kali = 'kali-linux'
$Windows = 'MicrosoftWindowsDesktop'
$Server = 'MicrosoftWindowsServer'

Get-AzVMImageOffer -Location $location -PublisherName $ubuntu | Select Offer | Out-File -Filepath $ubuntu.txt
Get-AzVMImageOffer -Location $location -PublisherName $kali | Select Offer | Out-File -Filepath $kali.txt
Get-AzVMImageOffer -Location $location -PublisherName $Windows | Select Offer | Out-File -Filepath $Windows.txt
Get-AzVMImageOffer -Location $location -PublisherName $Server | Select Offer | Out-File -Filepath $Server.txt

$ubuntuimage = 'ubuntuserver'
$kaliimage = 'kali-linux'

Get-AzVMImageSku -Location $location -PublisherName $ubuntu -Offer $ubuntuimage | Select Skus >> $kali.txt
Get-AzVMImageSku -Location $location -PublisherName $kali -Offer $kaliimage | Select Skus >> $ubuntu.txt

