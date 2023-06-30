#invoke Pester v5 test
#requires -module Pester

$config = New-PesterConfiguration

$config.Output.Verbosity ="detailed"

Invoke-Pester -Configuration $config