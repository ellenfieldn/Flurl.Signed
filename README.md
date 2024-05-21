# Flurl.Signed

Sometimes life isn't fair and you are stuck supporting the world as it existed 10+ years ago. So if you'd like to use the amazing [Flurl](https://flurl.dev), but for whatever reason are still using strong naming, I've signed and repackaged them for you.

Enjoy!

**NuGet Packages:**

- [Flurl.Signed](https://www.nuget.org/packages/Flurl.Signed)  
- [Flulr.Http.Signed](https://www.nuget.org/packages/Flurl.Http.Signed)

## Caveats

- These are not built from source, they simply sign the existing assemblies on NuGet and publish them back to NuGet.

## Acknowledgements

- Todd Menier for developing Flurl. (<https://github.com/tmenier>)
- Carolyn Van Slyck for developing the original version of Flurl.Signed. (<https://github.com/carolynvs>)

## Roadmap

I don't think I plan to do too much to this given that it already works, but some things that would be fun and make it more robust that I may be able to find time for:

- Separate the nuget package generation from the uploading to the nuget repository.
- Add verification of the nuget packages with sn.exe
- Add integration tests to verify consumption of the nuget packages
- Push based on results of verification and integration tests

## How it works

For anyone who wants to replicate this, here's how:

### Generating a signing key

1. Open Visual Studio Powershell as Administrator
1. Run `sn -k Flurl.Signed.snk`
1. Encode as base64 by running the command `certutil -encodehex -f .\Flurl.Signed.snk Flurl.Signed.encoded.txt 0x40000001`
1. Add as Secret "NUGET_SIGNING_KEY" to github repo

### Build Orchestration

- Build Definition in VSTS
- Get Sources from GitHub
- Phase 1 - Defaults
  - Download Secure file - Downloads the signing key which was uploaded to VSTS
  - MSBuild
    - Project: build/build.proj
    - MSBuild Version: Latest
    - MSBuild Architecture: x86
    - MSBuild Arguments: `/p:NugetApiKey=$(NugetApiKey)`
- Variables: Need to define NugetApiKey as your Nuget Api Key.
- Triggers:
  - When: Scheduled every day at 2am utc
  - Uncheck Only schedule builds if source or definition has changed
