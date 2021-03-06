Get-Module Qlik-Cli | Remove-Module -Force
Import-Module (Resolve-Path "$PSScriptRoot\..\Qlik-Cli.psm1").Path
. (Resolve-Path "$PSScriptRoot\..\resources\extension.ps1").Path

Describe "Import-QlikExtension" {
  Mock Invoke-QlikUpload -Verifiable {
    return $path
  }

  Context 'Password' {
    It 'should be encoded' {
      $password = ConvertTo-SecureString -String 'Pa$$w0rd' -AsPlainText -Force
      $result = Import-QlikExtension `
        -ExtensionPath 'test.qvf' `
        -Password $password

      $result | Should Match 'password=Pa%24%24w0rd'

      Assert-VerifiableMock
    }

    It 'should allow plain text' {
      $password = 'Pa$$w0rd'
      $result = Import-QlikExtension `
        -ExtensionPath 'test.qvf' `
        -Password $password

      $result | Should Match 'password=Pa%24%24w0rd'

      Assert-VerifiableMock
    }
  }
}
