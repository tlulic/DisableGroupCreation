# potrebno je imati instalirano AzureAD ili AzureADPreview modul da bi mogli pokrenuti skriptu
# provjera instalirane verzije

Get-InstalledModule -Name "AzureAD*"

# instalacija zadnje verzije

Install-Module AzureADPreview


# ova skripta disejbla sve korisnike osim admina da mogu kreirati grupe i izvršava se na razini tenanta (skripta je preuzeta sa ShareGate sajta)

$AllowGroupCreation = "False"

Connect-AzureAD

$settingsObjectID = (Get-AzureADDirectorySetting | Where-object -Property Displayname -Value "Group.Unified" -EQ).id
if(!$settingsObjectID)
{
	  $template = Get-AzureADDirectorySettingTemplate | Where-object {$_.displayname -eq "group.unified"}
    $settingsCopy = $template.CreateDirectorySetting()
    New-AzureADDirectorySetting -DirectorySetting $settingsCopy
    $settingsObjectID = (Get-AzureADDirectorySetting | Where-object -Property Displayname -Value "Group.Unified" -EQ).id
}

$settingsCopy = Get-AzureADDirectorySetting -Id $settingsObjectID
$settingsCopy["EnableGroupCreation"] = $AllowGroupCreation


Set-AzureADDirectorySetting -Id $settingsObjectID -DirectorySetting $settingsCopy

(Get-AzureADDirectorySetting -Id $settingsObjectID).Values
