# Credential Parameter
[CmdletBinding()]
param(
  [Parameter(
    Position = 0,
    HelpMessage = 'Credentials to use for authentication.')]
  [System.Management.Automation.PSCredential]
  [System.Management.Automation.CredentialAttribute()]
  $Credential
)
