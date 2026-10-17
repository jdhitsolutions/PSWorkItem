---
document type: cmdlet
external help file: PSWorkItem-help.xml
HelpUri: https://jdhitsolutions.com/yourls/457bec
Module Name: PSWorkItem
PlatyPS schema version: 2024-05-01
---

# Get-PSWorkItem

## SYNOPSIS

Get a PSWorkItem.

## SYNTAX

### days (Default)

```yaml
Get-PSWorkItem [-DaysDue <Int32>] [-Path <String>] [-Category <String>] [<CommonParameters>]
```

### name

```yaml
Get-PSWorkItem [[-Name] <String>] [-Path <String>] [<CommonParameters>]
```

### id

```yaml
Get-PSWorkItem [-ID <String>] [-Path <String>] [<CommonParameters>]
```

### all

```yaml
Get-PSWorkItem [-All] [-Path <String>] [-Category <String>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:

- `gwi`

## DESCRIPTION

This command will retrieve PSWorkItems from the database using a parameter-defined query. The default behavior is to get all PSWorkItems due within the next 10 days. If you are running the command in the PowerShell console or VSCode, the default formatting will highlight overdue tasks in red and tasks due within 3 days in yellow.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-PSWorkItem

   Database: C:\Users\Jeff\PSWorkItem.db

ID Name              Description         DueDate              Category Pct
-- ----              -----------         -------              -------- ---
 6 new server prep   SQL02               8/3/2026 5:00:00 PM  Work      45
 7 password report                       8/5/2026 12:00:00 PM Work      10
 5 revise blog pages essentials and tips 8/7/2026 5:00:00 PM  Other      0
```

Get all items due in the next 10 days.

### Example 2

```powershell
PS C:\> Get-PSWorkItem -all

   Database: C:\Users\Jeff\PSWorkItem.db

ID Name              Description         DueDate               Category Pct
-- ----              -----------         -------               -------- ---
 6 new server prep   SQL02               8/3/2026 5:00:00 PM   Work      45
 7 password report                       8/5/2026 12:00:00 PM  Work      10
 5 revise blog pages essentials and tips 8/7/2026 5:00:00 PM   Other      0
 1 update data                           8/28/2026 10:35:02 AM Temp       0
 9 Prep vacation                         11/1/2026 5:00:00 PM  Personal   0
 8 Year end backup                       12/31/2026 5:00:00 PM Work       0
```

Get all open tasks.

### Example 3

```powershell
PS C:\> Get-PSWorkItem -Category Work

   Database: C:\Users\Jeff\PSWorkItem.db

ID Name            Description DueDate               Category Pct
-- ----            ----------- -------               -------- ---
 6 new server prep SQL02       8/3/2026 5:00:00 PM   Work      45
 7 password report             8/5/2026 12:00:00 PM  Work      10
 8 Year end backup             12/31/2026 5:00:00 PM Work       0
```

Get tasks from the Work category. The category name is case-sensitive. Use tab-completion to get the proper value.

### Example 4

```powershell
PS C:\> Get-PSWorkItem -id 9

   Database: C:\Users\Jeff\PSWorkItem.db

ID Name          Description DueDate              Category Pct
-- ----          ----------- -------              -------- ---
 9 Prep vacation             11/1/2026 5:00:00 PM Personal   0
```

Get a PSWorkItem by its ID.

### Example 5

```powershell
PS C:\> Get-PSWorkItem -Name p*

   Database: C:\Users\Jeff\PSWorkItem.db

ID Name            Description DueDate              Category Pct
-- ----            ----------- -------              -------- ---
 7 password report             8/5/2026 12:00:00 PM Work      10
 9 Prep vacation               11/1/2026 5:00:00 PM Personal   0
```

Get PSWorkItems with a name that begins with P.

### Example 6

```powershell
PS C:\> Get-PSWorkItem | Format-Table -View countdown

ID Name              Description         DueDate              TimeRemaining
-- ----              -----------         -------              -------------
6  new server prep   SQL02               8/3/2026 5:00:00 PM     4.05:20:31
7  password report                       8/5/2026 12:00:00 PM    6.00:20:31
5  revise blog pages essentials and tips 8/7/2026 5:00:00 PM     8.05:20:31
```

The PSWorkItem has a named table view called Countdown.

### Example 7

```powershell
PS C:\> Get-PSWorkItem | Where Overdue

   Database: C:\Users\Jeff\PSWorkItem.db

ID Name                Description DueDate               Category Pct
-- ----                ----------- -------               -------- ---
13 extend car warranty             6/1/2026 4:00:00 PM   Personal   0
11 update resume                   7/12/2026 12:00:00 PM Work       0
 7 password report                 7/15/2026 5:00:00 PM  Work      10
```

Get all overdue PSWorkItems.

### Example 8

```powershell
PS C:\> Get-PSWorkItem -all | Sort-Object category | Format-Table -view category

   Category: Other

ID    Name                 Description               DueDate                 Pct
--    ----                 -----------               -------                 ---
5     revise blog pages    essentials and tips       8/7/2026 5:00:00 PM       0

   Category: Personal

ID    Name                 Description               DueDate                 Pct
--    ----                 -----------               -------                 ---
13    extend car warranty                            6/1/2026 4:00:00 PM       0
10    car wash                                       8/2/2026 11:54:31 AM      0
9     Prep vacation                                  11/1/2026 5:00:00 PM      0

   Category: Project

ID    Name                 Description               DueDate                 Pct
--    ----                 -----------               -------                 ---
12    Publish PSWorkItem                             8/2/2026 12:05:44 PM      0
...
```

Get PSWorkItems sorted by category and display using the Category table view.

## PARAMETERS

### -All

Get all open PSWorkItems except for those in the Hidden category.

```yaml
Type: SwitchParameter
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: all
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Category

Get all open PSWorkItems by category. There should be tab completion for this parameter. If you are specifying an alternate path, specify the path before using this parameter.

Beginning with module version 1.13.0 you can set the category to Hidden. This will have the effect of hiding the PSWorkItem from the default Get-PSWorkItem output unless you specify the Hidden category.

The value is case-sensitive so use tab-completion to get the proper value.

```yaml
Type: String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: days
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: all
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DaysDue

Get open PSWorkItems due in the number of days between 1 and 365.

```yaml
Type: Int32
DefaultValue: 10
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: days
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ID

The task ID.

```yaml
Type: String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: id
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

The name of the PSWorkItem.
Wildcards are supported.

```yaml
Type: String
DefaultValue: None
SupportsWildcards: true
Aliases:
- task
ParameterSets:
- Name: name
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Path

The path to the PSWorkItem SQLite database file.
It should end in .db.

```yaml
Type: String
DefaultValue: $PSWorkItemPath
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### PSWorkItem

## NOTES

This command has an alias of gwi.

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

- [Complete-PSWorkItem](Complete-PSWorkItem.md)
- [Get-PSWorkItemArchive](Get-PSWorkItemArchive.md)
- [Remove-PSWorkItem](Remove-PSWorkItem.md)
- [New-PSWorkItem](New-PSWorkItem.md)
- [Set-PSWorkItem](Set-PSWorkItem.md)
- [Open-PSWorkItemConsole](Open-PSWorkItemConsole.md)
