<#
.SYNOPSIS
This script moves the Windows taskbar to the monitor 2, right side, and vertical orientation.

.DESCRIPTION
This script uses the Windows API to move the taskbar to the specified monitor, side, and orientation.

.EXAMPLE
.\placeTaskbar.ps1
This command moves the taskbar to the right side of the second monitor, and sets it to be vertical.

.NOTES
This script requires Windows 10 or later, and should be run with administrator privileges.
#>
# Define constants
$SPI_SETWORKAREA = 0x002F
$ABM_SETPOS = 3
$ABE_RIGHT = 2

# Get monitor #2
$monitor = [System.Windows.Forms.Screen]::AllScreens[1]

# Get work area rectangle for monitor #2
$workAreaRect = $monitor.WorkingArea

# Calculate new taskbar size and position
$taskbarWidth = [int]($workAreaRect.Width * 0.05)
$taskbarHeight = $workAreaRect.Height
$taskbarX = $workAreaRect.Right - $taskbarWidth
$taskbarY = $workAreaRect.Top

# Set new work area rectangle for monitor #2
$newWorkAreaRect = [RECT]::new()
$newWorkAreaRect.Left = $workAreaRect.Left
$newWorkAreaRect.Top = $workAreaRect.Top
$newWorkAreaRect.Right = $workAreaRect.Right - $taskbarWidth
$newWorkAreaRect.Bottom = $workAreaRect.Bottom
[User32]::SystemParametersInfo($SPI_SETWORKAREA, 0, [ref]$newWorkAreaRect, 0)

# Set new position and size for taskbar
$appBarData = New-Object Shell32.APPBARDATA
$appBarData.cbSize = [System.Runtime.InteropServices.Marshal]::SizeOf($appBarData)
$appBarData.uEdge = $ABE_RIGHT
$appBarData.rc.Left = $taskbarX
$appBarData.rc.Top = $taskbarY
$appBarData.rc.Right = $taskbarX + $taskbarWidth
$appBarData.rc.Bottom = $taskbarY + $taskbarHeight
[User32]::SHAppBarMessage($ABM_SETPOS, [ref]$appBarData)

# Restart explorer.exe process to apply changes
Stop-Process -Name explorer -ErrorAction SilentlyContinue