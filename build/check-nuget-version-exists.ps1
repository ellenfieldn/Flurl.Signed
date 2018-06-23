param (
  [string]$package,
  [string]$version,
  [string]$nugetIndexUrl = "https://api.nuget.org/v3/index.json"
)

try 
{
  Write-Verbose "package: $package"
  Write-Verbose "version: $version"

  $indexResults = (Invoke-RestMethod $nugetIndexUrl)
  Write-Verbose $indexResults
  $packageResource = $indexResults.resources | Where { $_."@type" -eq "PackageBaseAddress/3.0.0" }
  Write-Verbose $packageResource
  $packageBaseUrl = $packageResource[0]."@id"
  Write-Verbose $packageBaseUrl

  $url = "$($packageBaseUrl)$($package)/index.json"
  Write-Verbose $url
  $packageJson = Invoke-RestMethod $url
  Write-Verbose "Package: $packageJson"
  
  $hasVersion = $packageJson.versions.Contains($version)
  Write-Verbose "HasVersion: $hasVersion"
  Write-Host $hasVersion
} 
catch 
{
  Write-Error = $_.Exception.Response.StatusCode.Value__
  Write-Host "False"
}
