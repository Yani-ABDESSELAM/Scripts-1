# Prompt to Continue

# Dynamic Variables (Safe to change)
$Title = "Continue..."
$Info = "Should the script continue?"

# Static Variables (Do not change!)
$Options = [System.Management.Automation.Host.ChoiceDescription[]] @("&Yes", "&No")
[int]$DefaultChoice = 0
$Opt = $host.UI.PromptForChoice($Title , $Info, $Options, $DefaultChoice)

# Script
Switch ($Opt) {
  0 { 
    Write-Verbose -Message "Yes"
  }

  1 { 
    Write-Verbose -Message "No" 
  }
}
