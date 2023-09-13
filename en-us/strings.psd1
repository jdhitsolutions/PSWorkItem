#localized string data for verbose messaging and warnings.
ConvertFrom-StringData @'

Testing = I am a localized message
getData = Getting SQLite database information from {0}
OpenDBConnection = Opening a SQLite database connection
CloseDBConnection = Closing the SQLite database connection
TaskCount =  Getting a task count
ArchiveCount =  Getting a archive count
CategoryCount = Getting a category count
Starting = Starting command
Ending =  Ending command
GetAllCategories = Getting all PSWorkItem categories
GetCategory = Getting category {0}
FoundCategories = Found {0} PSWorkItem categories
CreateCategory = Creating PSWorkItem category -> {0}
DetectedCulture = Detected culture {0}
DetectedParameterSet = Detected parameter set {0}
FoundMatching = Found {0} matching PSWorkItem tasks
RefilteringTasks =  Re-filtering for tasks due in the next {0} day(s)
CutOffDate = Cutoff date is {0}
FilterItemsDue = Filtering for PSWorkItems due before {0}
Refiltering = Re-Filtering found {0} PSWorkItems
Sorting = Sorting {0} items
WarnNoTasksFound = Failed to find any matching PSWorkItems
FailToOpen = Failed to open the database {0}
FailedToFind = Failed to find PSWorkItem with id {0}
FailedQuery = Failed to execute query {0}
FailedArchiveID = Cannot verify the archive table column ID. Please run Update-PSWorkItemDatabase to update the table then try completing the command again. It is recommended that you backup your database before updating the table.
CompleteTask = Completing task id {0}
UsingDB = Using SQLite database {0}
AddCategory = Adding PSWorkItem category {0}
CategoryExists = The PSWorkItem category {0} already exists
CategoryExistsOverwrite = The PSWorkItem category {0} already exists and will be overwritten
MoveItem = Moving PSWorkItem to Archive.
ValidateMove = Validating the move
RemoveTask = Removing the original PSWorkItem
FailedVerifyTaskID = Could not verify that PSWorkitem {0}} [{1}}] was copied to the archive table.
'@