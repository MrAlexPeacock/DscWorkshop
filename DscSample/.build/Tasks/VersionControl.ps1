task VersionControl {
    
    if ($env:BHBuildSystem -eq 'AppVeyor' -or $env:BHBuildSystem -eq 'VSTS') {
        $path = "$ProjectPath\DSC_ConfigData\MetaConfig\DscTagging.yml"

        $content = Select-String -Pattern 'DscTagging:' -Path $path -Context 0,1
        $content.Context.PostContext[0] -match '  Version: (?<Version>\d+.\d+.\d+)' | Out-Null
        
        $version = [System.Version]$Matches.Version
        $version = New-Object System.Version($version.Major, $version.Minor, $env:BHBuildNumber)
                
        $content = Get-Content -Path $path -Raw
        $content = $content -replace $Matches.Version, $version
        $content | Set-Content -Path $path
    }

}
