---
external help file: PSWorkItem-help.xml
Module Name: PSWorkItem
online version: https://bit.ly/3OFhPRm
schema: 2.0.0
---

# Get-PSWorkItem

## SYNOPSIS

Get a PSWorkItem.

## SYNTAX

### days (Default)

```yaml
Get-PSWorkItem [-DaysDue <Int32>] [-Path <String>] [<CommonParameters>]
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
Get-PSWorkItem [-All] [-Path <String>] [<CommonParameters>]
```

### category

```yaml
Get-PSWorkItem [-Category <String>] [-Path <String>] [<CommonParameters>]
```

## DESCRIPTION

This command will retrieve PSWorkItems from the database using a parameter defined query. The default behavior is to get all PSWorkItems due within the next 10 days. If you are running the command in the PowerShell console or VSCode, the default formatting will highlight overdue tasks in red and tasks due within 3 days in yellow.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-PSWorkItem

   Database: C:\Users\Jeff\PSWorkItem.db

ID Name              Description         DueDate              Category Pct
-- ----              -----------         -------              -------- ---
 6 new server prep   SQL02               8/3/2022 5:00:00 PM  Work      45
 7 password report                       8/5/2022 12:00:00 PM Work      10
 5 revise blog pages essentials and tips 8/7/2022 5:00:00 PM  Other      0
```

Get all items due in the next 10 days.

### Example 2

```powershell
PS C:\> Get-PSWorkItem -all

   Database: C:\Users\Jeff\PSWorkItem.db

ID Name              Description         DueDate               Category Pct
-- ----              -----------         -------               -------- ---
 6 new server prep   SQL02               8/3/2022 5:00:00 PM   Work      45
 7 password report                       8/5/2022 12:00:00 PM  Work      10
 5 revise blog pages essentials and tips 8/7/2022 5:00:00 PM   Other      0
 1 update data                           8/28/2022 10:35:02 AM Temp       0
 9 Prep vacation                         11/1/2022 5:00:00 PM  Personal   0
 8 Year end backup                       12/31/2022 5:00:00 PM Work       0
```

Get all open tasks.

### Example 3

```powershell
PS C:\> Get-PSWorkItem -Category Work

   Database: C:\Users\Jeff\PSWorkItem.db

ID Name            Description DueDate               Category Pct
-- ----            ----------- -------               -------- ---
 6 new server prep SQL02       8/3/2022 5:00:00 PM   Work      45
 7 password report             8/5/2022 12:00:00 PM  Work      10
 8 Year end backup             12/31/2022 5:00:00 PM Work       0
```

Get tasks from the Work category.

### Example 4

```powershell
PS C:\> Get-PSWorkItem -id 9

   Database: C:\Users\Jeff\PSWorkItem.db

ID Name          Description DueDate              Category Pct
-- ----          ----------- -------              -------- ---
 9 Prep vacation             11/1/2022 5:00:00 PM Personal   0
```

Get a PSWorkItem by its ID.

### Example 5

```powershell
PS C:\> Get-PSWorkItem -Name p*

   Database: C:\Users\Jeff\PSWorkItem.db

ID Name            Description DueDate              Category Pct
-- ----            ----------- -------              -------- ---
 7 password report             8/5/2022 12:00:00 PM Work      10
 9 Prep vacation               11/1/2022 5:00:00 PM Personal   0
```

Get PSWorkitems with a name that begins with P.

### Example 6

```powershell
PS C:\> Get-PSWorkItem | Format-Table -View countdown

ID Name              Description         DueDate              TimeRemaining
-- ----              -----------         -------              -------------
6  new server prep   SQL02               8/3/2022 5:00:00 PM     4.05:20:31
7  password report                       8/5/2022 12:00:00 PM    6.00:20:31
5  revise blog pages essentials and tips 8/7/2022 5:00:00 PM     8.05:20:31
```

The PSWorkItem has a named table view called Countdown.

### Example 7

```powershell
PS C:\> Get-PSWorkItem | Where Overdue

   Database: C:\Users\Jeff\PSWorkItem.db

ID Name                Description DueDate               Category Pct
-- ----                ----------- -------               -------- ---
13 extend car warranty             6/1/2022 4:00:00 PM   Personal   0
11 update resume                   7/12/2022 12:00:00 PM Work       0
 7 password report                 7/15/2022 5:00:00 PM  Work      10
```

Get all overdue PSWorkItems.

### Example 8

```powershell
PS C:\> Get-PSWorkItem -all | Sort-Object category | Format-Table  -view category

   Category: Other

ID    Name                 Description               DueDate                 Pct
--    ----                 -----------               -------                 ---
5     revise blog pages    essentials and tips       8/7/2022 5:00:00 PM       0

   Category: Personal

ID    Name                 Description               DueDate                 Pct
--    ----                 -----------               -------                 ---
13    extend car warranty                            6/1/2022 4:00:00 PM       0
10    car wash                                       8/2/2022 11:54:31 AM      0
9     Prep vacation                                  11/1/2022 5:00:00 PM      0

   Category: Project

ID    Name                 Description               DueDate                 Pct
--    ----                 -----------               -------                 ---
12    Publish PSWorkitem                             8/2/2022 12:05:44 PM      0
...
```

Get PSWorkItems sorted by category and display using the Category table view.

## PARAMETERS

### -All

Get all open tasks.

```yaml
Type: SwitchParameter
Parameter Sets: all
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Category

Get all open tasks by category. There should be tab-completion for this parameter.

```yaml
Type: String
Parameter Sets: category
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DaysDue

Get open tasks due in the number of days between 1 and 365.

```yaml
Type: Int32
Parameter Sets: days
Aliases:

Required: False
Position: Named
Default value: 10
Accept pipeline input: False
Accept wildcard characters: False
```

### -ID

The task ID.

```yaml
Type: String
Parameter Sets: id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name

The name of the work item.
Wilcards are supported.

```yaml
Type: String
Parameter Sets: name
Aliases: task

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Path

The path to the PSWorkitem SQLite database file.
It should end in .db

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $PSWorkItemPath
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This command supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### PSWorkItem

## NOTES

This command has an alias of gwi.

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Complete-PSWorkItem](Complete-PSWorkItem.md)

[Get-PSWorkItemArchive](Get-PSWorkItemArchive.md)

[Remove-PSWorkItem](Remove-PSWorkItem.md)

[New-PSWorkItem](New-PSWorkItem.md)

[Set-PSWorkItem](Set-PSWorkItem.md)
