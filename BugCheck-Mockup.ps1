Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$stopCodes = @(
    @{ Code = "IRQL_NOT_LESS_OR_EQUAL"; Hex = "0x0000000A"; Failed = "ndis.sys" },
    @{ Code = "APC_INDEX_MISMATCH"; Hex = "0x00000001"; Failed = "ntoskrnl.exe" },
    @{ Code = "KMODE_EXCEPTION_NOT_HANDLED"; Hex = "0x0000001E"; Failed = "ntoskrnl.exe" },
    @{ Code = "PAGE_FAULT_IN_NONPAGED_AREA"; Hex = "0x00000050"; Failed = "ntoskrnl.exe" },
    @{ Code = "BAD_POOL_CALLER"; Hex = "0x000000C2"; Failed = "ndis.sys" },
    @{ Code = "DRIVER_IRQL_NOT_LESS_OR_EQUAL"; Hex = "0x000000D1"; Failed = "nvlddmkm.sys" },
    @{ Code = "INACCESSIBLE_BOOT_DEVICE"; Hex = "0x0000007B"; Failed = "storport.sys" },
    @{ Code = "NTFS_FILE_SYSTEM"; Hex = "0x00000024"; Failed = "ntfs.sys" },
    @{ Code = "PFN_LIST_CORRUPT"; Hex = "0x0000004E"; Failed = "ntoskrnl.exe" },
    @{ Code = "SYSTEM_SERVICE_EXCEPTION"; Hex = "0x0000003B"; Failed = "win32k.sys" },
    @{ Code = "SYSTEM_THREAD_EXCEPTION_NOT_HANDLED"; Hex = "0x0000007E"; Failed = "nvlddmkm.sys" },
    @{ Code = "UNEXPECTED_KERNEL_MODE_TRAP"; Hex = "0x0000007F"; Failed = "ntoskrnl.exe" },
    @{ Code = "DRIVER_OVERRAN_STACK_BUFFER"; Hex = "0x000000F7"; Failed = "ntoskrnl.exe" },
    @{ Code = "CRITICAL_STRUCTURE_CORRUPTION"; Hex = "0x00000109"; Failed = "ntoskrnl.exe" },
    @{ Code = "BAD_POOL_HEADER"; Hex = "0x00000019"; Failed = "ntoskrnl.exe" },
    @{ Code = "POOL_CORRUPTION_IN_FILE_AREA"; Hex = "0x000000DE"; Failed = "ntfs.sys" },
    @{ Code = "DRIVER_LEFT_LOCKED_PAGES_IN_PROCESS"; Hex = "0x000000CB"; Failed = "ndis.sys" },

    @{ Code = "DATA_BUS_ERROR"; Hex = "0x0000002E"; Failed = "" },
    @{ Code = "NO_MORE_SYSTEM_PTES"; Hex = "0x0000003F"; Failed = "ntoskrnl.exe" },
    @{ Code = "MISMATCHED_HAL"; Hex = "0x00000079"; Failed = "hal.dll" },
    @{ Code = "KERNEL_STACK_INPAGE_ERROR"; Hex = "0x00000077"; Failed = "ntoskrnl.exe" },
    @{ Code = "REGISTRY_ERROR"; Hex = "0x00000051"; Failed = "ntoskrnl.exe" },
    @{ Code = "BAD_SYSTEM_CONFIG_INFO"; Hex = "0x00000074"; Failed = "ntoskrnl.exe" },

    @{ Code = "DRIVER_POWER_STATE_FAILURE"; Hex = "0x0000009F"; Failed = "USBPORT.SYS" },
    @{ Code = "DRIVER_VERIFIER_DETECTED_VIOLATION"; Hex = "0x000000C4"; Failed = "verifier.sys" },
    @{ Code = "DRIVER_CORRUPTED_EXPOOL"; Hex = "0x000000C5"; Failed = "ntoskrnl.exe" },
    @{ Code = "DRIVER_UNLOADED_WITHOUT_CANCELLING_PENDING_OPERATIONS"; Hex = "0x000000CE"; Failed = "ntoskrnl.exe" },
    @{ Code = "SPECIAL_POOL_DETECTED_MEMORY_CORRUPTION"; Hex = "0x000000C1"; Failed = "ntoskrnl.exe" },

    @{ Code = "THREAD_STUCK_IN_DEVICE_DRIVER"; Hex = "0x000000EA"; Failed = "nvlddmkm.sys" },
    @{ Code = "HAL_INITIALIZATION_FAILED"; Hex = "0x0000005C"; Failed = "hal.dll" },
    @{ Code = "MACHINE_CHECK_EXCEPTION"; Hex = "0x0000009C"; Failed = "hal.dll" },
    
    @{ Code = "UNMOUNTABLE_BOOT_VOLUME"; Hex = "0x000000ED"; Failed = "" },
    @{ Code = "KERNEL_DATA_INPAGE_ERROR"; Hex = "0x0000007A"; Failed = "disk.sys" },
    @{ Code = "WHEA_UNCORRECTABLE_ERROR"; Hex = "0x00000124"; Failed = "" },
    @{ Code = "CLOCK_WATCHDOG_TIMEOUT"; Hex = "0x00000101"; Failed = "intelppm.sys" },

    @{ Code = "ATTEMPTED_WRITE_TO_READONLY_MEMORY"; Hex = "0x000000BE"; Failed = "ntoskrnl.exe" },
    @{ Code = "CRITICAL_OBJECT_TERMINATION"; Hex = "0x000000F4"; Failed = "csrss.exe" },
    @{ Code = "FAT_FILE_SYSTEM"; Hex = "0x00000023"; Failed = "fastfat.sys" },
    @{ Code = "BUGCODE_USB_DRIVER"; Hex = "0x000000FE"; Failed = "USBPORT.SYS" },

    @{ Code = "VIDEO_TDR_FAILURE"; Hex = "0x00000116"; Failed = "nvlddmkm.sys" }
)

$errorChoice = $stopCodes | Get-Random
$StopCode = $errorChoice.Code
$hexCode = $errorChoice.Hex
$failingFile = $errorChoice.Failed

function Get-RandomKernelAddr {
    $high = (Get-Random -Min 0x1000 -Max 0xFFFF).ToString("X4")
    $low  = (Get-Random -Min 0x10000 -Max 0xFFFFF).ToString("X5")
    return "0xFFFFF80$high$low"
}

$param1 = Get-RandomKernelAddr
$param2 = Get-RandomKernelAddr
$param3 = Get-RandomKernelAddr
$param4 = (Get-RandomKernelAddr).Replace("0x", "0X")

# 1% Chance of RSOD
if ((Get-Random -Min 1 -Max 101) -le 1) {
    $screenColor = [System.Drawing.Color]::FromArgb(170, 0, 0)
} else {
    $screenColor = [System.Drawing.Color]::FromArgb(0, 0, 170)
}

$form = [System.Windows.Forms.Form]::new()
$form.BackColor = $screenColor
$form.FormBorderStyle = 'None'
$form.WindowState = 'Maximized'
$form.TopMost = $true
$form.Cursor = [System.Windows.Forms.Cursors]::Hide

$form.Add_KeyDown({ if ($_.KeyCode -eq 'Escape') { 
    [System.Windows.Forms.Cursor]::Show()
    $script:bufGfx.Dispose(); $script:bufBmp.Dispose()
    Stop-Process -Id $PID -Force 
} })

[int]$w = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
[int]$h = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height
if ($w -eq 0) { $w = 1920 }; if ($h -eq 0) { $h = 1080 }
$scaleY = $h / 1080

$leftMargin = [int](5 * $scaleY)
$textYStart = [int](30 * $scaleY)
$mainFontSize = [int](20 * $scaleY)
if ($mainFontSize -lt 9) { $mainFontSize = 9 }

$classicText = "A problem has been detected and windows has been shut down to prevent damage`r`nto your computer.`r`n`r`n"
if ($failingFile) {
    $classicText += "The problem seems to be caused by the following file: $failingFile`r`n`r`n"
}
$classicText += "$StopCode`r`n`r`n"
$classicText += "If this is the first time you've seen this Stop error screen,`r`nrestart your computer. If this screen appears again, follow`r`nthese steps:`r`n`r`n"
$classicText += "Check to make sure any new hardware or software is properly installed.`r`nIf this is a new installation, ask your hardware or software manufacturer`r`nfor any windows updates you might need.`r`n`r`n"
$classicText += "If problems continue, disable or remove any newly installed hardware`r`nor software. Disable BIOS memory options such as caching or shadowing.`r`nIf you need to use safe Mode to remove or disable components, restart`r`nyour computer, press F8 to select Advanced Startup Options, and then`r`nselect safe Mode.`r`n`r`n"
$classicText += "Technical information:`r`n`r`n"
$classicText += "*** STOP: $hexCode ($param1,$param2,$param3,0" + $param4.Substring(1) + ")`r`n`r`n"

if ($failingFile) {
    $addr = (Get-RandomKernelAddr).ToLower()
    $base = (Get-RandomKernelAddr).ToLower()
    $date = "0x" + (Get-Random -Min 0x40000000 -Max 0x5FFFFFFF).ToString("X8")
    $classicText += "*** $failingFile - Address $addr base at $base DateStamp $date`r`n`r`n"
}
$classicText += "`r`n"

$script:bufBmp = [System.Drawing.Bitmap]::new($w, $h)
$script:bufGfx = [System.Drawing.Graphics]::FromImage($script:bufBmp)
$script:bufGfx.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::SingleBitPerPixelGridFit
$script:bgColor = $screenColor

$font = [System.Drawing.Font]::new("Lucida Console", $mainFontSize, [System.Drawing.FontStyle]::Regular)
$brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::White)

$form.Add_Paint({ param($sender, $e); $e.Graphics.DrawImage($script:bufBmp, 0, 0) })

function Update-Buffer ($text) {
    $script:bufGfx.Clear($script:bgColor)
    $script:bufGfx.DrawString($text, $font, $brush, $leftMargin, $textYStart)
    $screenGfx = $form.CreateGraphics()
    $screenGfx.DrawImage($script:bufBmp, 0, 0)
    $screenGfx.Dispose()
}

$form.Add_Shown({
    [System.Windows.Forms.Cursor]::Hide()
    $displayed = ""
    $batchSize = 45 
    for ($i = 0; $i -lt $classicText.Length; $i += $batchSize) {
        $displayed += $classicText.Substring($i, [Math]::Min($batchSize, $classicText.Length - $i))
        Update-Buffer $displayed
        [System.Windows.Forms.Application]::DoEvents()
        [System.Threading.Thread]::Sleep(1)
    }

    Start-Sleep -Milliseconds 200
    $displayed += "Collecting data for crash dump ...`r`n"
    Update-Buffer $displayed
    Start-Sleep -Milliseconds 150
    $displayed += "Beginning dump of physical memory.`r`n"
    Update-Buffer $displayed
    
    $baseWithDump = $displayed + "Dumping physical memory to disk:  "
    for ($pct = 4; $pct -le 100; $pct += (Get-Random -Min 2 -Max 7)) {
        if ($pct -gt 100) { $pct = 100 }
        Update-Buffer ($baseWithDump + $pct)
        [System.Windows.Forms.Application]::DoEvents()
        Start-Sleep -Milliseconds (Get-Random -Min 80 -Max 250)
    }
    
    Update-Buffer ($baseWithDump + "100`r`nPhysical memory dump complete.`r`nContact your system admin or technical support group for further assistance.")
    
    Start-Sleep -Seconds 5
    $script:bgColor = [System.Drawing.Color]::Black
    Update-Buffer ""
    Start-Sleep -Seconds 2
    
    [System.Windows.Forms.Cursor]::Show()
    $font.Dispose()
    $brush.Dispose()
    $script:bufGfx.Dispose()
    $script:bufBmp.Dispose()
    $form.Close()
})

[void]$form.ShowDialog()
