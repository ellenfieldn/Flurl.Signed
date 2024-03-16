param (
  [string]$package,
  [string]$version,
  [string]$nugetIndexUrl = "https://api.nuget.org/v3/index.json"
)

try 
{
  Write-Information "Package Name: $package"
  Write-Information "Package Version: $version"
  Write-Information "NuGet Index URL: $nugetIndexUrl"

  Write-Information "Getting nuget index from $($nugetIndexUrl)..."
  $indexResults = (Invoke-RestMethod $nugetIndexUrl)
  Write-Verbose $indexResults
  $packageResource = $indexResults.resources | Where-Object { $_."@type" -eq "PackageBaseAddress/3.0.0" }
  Write-Verbose $packageResource
  $packageBaseUrl = $packageResource[0]."@id"
  Write-Verbose $packageBaseUrl

  $url = "$($packageBaseUrl)$($package.ToLower())/index.json"
  Write-Information "Getting list of package versions from $($url)"
  $packageJson = Invoke-RestMethod $url
  
  $hasVersion = $packageJson.versions.Contains($version)
  Write-Verbose "HasVersion: $hasVersion"
  Write-Host (!$hasVersion)
} 
catch 
{
  Write-Error = $_.Exception
  Write-Host "True"
}
