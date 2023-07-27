param([bool] $IncrementVersion=$false) 
    
try{
    pac auth select --name "personal.dev"
    $managedZipFile=Join-Path $env:USERPROFILE -ChildPath "Downloads\CustomDocumentTemplateMetadata_managed.zip";
    $zipFile=Join-Path $env:USERPROFILE -ChildPath "Downloads\CustomDocumentTemplateMetadata.zip";

    if ($IncrementVersion -eq $true) {
        $solutionXml=[xml](Get-Content ".\CustomDocumentTemplateMetadata\other\solution.xml")
        $currentVersion=$solutionXml.ImportExportXml.SolutionManifest.Version.Split(".");
        pac solution online-version --solution-name "CustomDocumentTemplateMetadata" --solution-version "$($currentVersion[0]).$($currentVersion[1]).$($currentVersion[2]).$(([int]$IncrementVersion[3])+1)"
    }

    pac solution export --path $managedZipFile --name "CustomDocumentTemplateMetadata" --managed --async --overwrite
    pac solution export --path $ZipFile --name "CustomDocumentTemplateMetadata"  --async --overwrite
    
    pac solution unpack --zipfile $managedzipFile --folder ".\CustomDocumentTemplateMetadata"  --packagetype "Managed" --allowDelete true --allowWrite true
    pac solution unpack --zipfile $zipFile --folder ".\CustomDocumentTemplateMetadata"  --packagetype "UnManaged" --allowDelete true --allowWrite true
    
    pac canvas unpack --msapp ".\CustomDocumentTemplateMetadata\CanvasApps\tua_templatemanagementcustompage_85384_DocumentUri.msapp" --sources ".\CanvasSource\tua_templatemanagementcustompage"
}

catch {
    1:write-Error $_.exception
}