Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$stopCodes = @(
    @{ Code = "DRIVER_IRQL_NOT_LESS_OR_EQUAL"; Hex = "0x000000D1"; Failed = "myfault.sys" },
    @{ Code = "IRQL_NOT_LESS_OR_EQUAL"; Hex = "0x0000000A"; Failed = "ntoskrnl.exe" },
    @{ Code = "PAGE_FAULT_IN_NONPAGED_AREA"; Hex = "0x00000050"; Failed = "ntoskrnl.exe" },
    @{ Code = "CRITICAL_PROCESS_DIED"; Hex = "0x000000EF"; Failed = "" },
    @{ Code = "SYSTEM_SERVICE_EXCEPTION"; Hex = "0x0000003B"; Failed = "win32kfull.sys" },
    @{ Code = "KMODE_EXCEPTION_NOT_HANDLED"; Hex = "0x0000001E"; Failed = "wdf01000.sys" },
    @{ Code = "DPC_WATCHDOG_VIOLATION"; Hex = "0x00000133"; Failed = "nvlddmkm.sys" },
    @{ Code = "WHEA_UNCORRECTABLE_ERROR"; Hex = "0x00000124"; Failed = "hal.dll" },
    @{ Code = "MEMORY_MANAGEMENT"; Hex = "0x0000001A"; Failed = "" },
    @{ Code = "KERNEL_DATA_INPAGE_ERROR"; Hex = "0x0000007A"; Failed = "disk.sys" },
    @{ Code = "BAD_POOL_CALLER"; Hex = "0x000000C2"; Failed = "ntfs.sys" },
    @{ Code = "MACHINE_CHECK_EXCEPTION"; Hex = "0x0000009C"; Failed = "" },
    @{ Code = "VIDEO_TDR_FAILURE"; Hex = "0x00000116"; Failed = "nvlddmkm.sys" },
    @{ Code = "ATTEMPTED_WRITE_TO_READONLY_MEMORY"; Hex = "0x000000BE"; Failed = "ntoskrnl.exe" },
    @{ Code = "SYSTEM_THREAD_EXCEPTION_NOT_HANDLED"; Hex = "0x0000007E"; Failed = "dxgkrnl.sys" },
    @{ Code = "KERNEL_SECURITY_CHECK_FAILURE"; Hex = "0x00000139"; Failed = "" },
    @{ Code = "DRIVER_IRQL_NOT_LESS_OR_EQUAL"; Hex = "0x000000D1"; Failed = "ndis.sys" },
    @{ Code = "INACCESSIBLE_BOOT_DEVICE"; Hex = "0x0000007B"; Failed = "storport.sys" },
    @{ Code = "NTFS_FILE_SYSTEM"; Hex = "0x00000024"; Failed = "ntfs.sys" },
    @{ Code = "KERNEL_MODE_HEAP_CORRUPTION"; Hex = "0x0000013A"; Failed = "ntoskrnl.exe" },
    @{ Code = "POOL_CORRUPTION_IN_FILE_AREA"; Hex = "0x000000DE"; Failed = "ntfs.sys" },
    @{ Code = "IRQL_GT_ZERO_AT_SYSTEM_SERVICE"; Hex = "0x0000004A"; Failed = "ntoskrnl.exe" },
    @{ Code = "WORKER_INVALID"; Hex = "0x000000E4"; Failed = "ntoskrnl.exe" },
    @{ Code = "APC_INDEX_MISMATCH"; Hex = "0x00000001"; Failed = "ntoskrnl.exe" },
    @{ Code = "DRIVER_OVERRAN_STACK_BUFFER"; Hex = "0x000000F7"; Failed = "ntoskrnl.exe" },
    @{ Code = "BUGCODE_USB_DRIVER"; Hex = "0x000000FE"; Failed = "usbhub.sys" },
    @{ Code = "UNEXPECTED_STORE_EXCEPTION"; Hex = "0x00000154"; Failed = "" },
    @{ Code = "CRITICAL_STRUCTURE_CORRUPTION"; Hex = "0x00000109"; Failed = "ntoskrnl.exe" },
    @{ Code = "CLOCK_WATCHDOG_TIMEOUT"; Hex = "0x00000101"; Failed = "intelppm.sys" },
    @{ Code = "PFN_LIST_CORRUPT"; Hex = "0x0000004E"; Failed = "ntoskrnl.exe" },
    @{ Code = "DRIVER_POWER_STATE_FAILURE"; Hex = "0x0000009F"; Failed = "ntoskrnl.exe" },
    @{ Code = "THREAD_STUCK_IN_DEVICE_DRIVER"; Hex = "0x000000EA"; Failed = "dxgkrnl.sys" },
    @{ Code = "REGISTRY_ERROR"; Hex = "0x00000051"; Failed = "" },
    @{ Code = "STATUS_SYSTEM_PROCESS_TERMINATED"; Hex = "0x0000021A"; Failed = "ntdll.dll" },
    @{ Code = "HAL_INITIALIZATION_FAILED"; Hex = "0x0000005C"; Failed = "hal.dll" },
    @{ Code = "VIDEO_TDR_TIMEOUT_DETECTED"; Hex = "0x00000117"; Failed = "nvlddmkm.sys" },
    @{ Code = "MANUALLY_INITIATED_CRASH"; Hex = "0x000000E2"; Failed = "kbdclass.sys" },
    @{ Code = "FAT_FILE_SYSTEM"; Hex = "0x00000023"; Failed = "fastfat.sys" },
    @{ Code = "DRIVER_VERIFIER_DETECTED_VIOLATION"; Hex = "0x000000C4"; Failed = "verifier.sys" },
    @{ Code = "BUGCODE_NDIS_DRIVER"; Hex = "0x0000007C"; Failed = "ndis.sys" },
    @{ Code = "ACPI_BIOS_ERROR"; Hex = "0x000000A5"; Failed = "acpi.sys" },
    @{ Code = "FLTMGR_FILE_SYSTEM"; Hex = "0x000000F5"; Failed = "fltmgr.sys" },
    @{ Code = "PCI_BUS_DRIVER_INTERNAL"; Hex = "0x000000A1"; Failed = "pci.sys" },
    @{ Code = "WDF_VIOLATION"; Hex = "0x0000010D"; Failed = "Wdf01000.sys" },
    @{ Code = "NMI_HARDWARE_FAILURE"; Hex = "0x00000080"; Failed = "" },
    @{ Code = "REFS_FILE_SYSTEM"; Hex = "0x00000149"; Failed = "ReFS.sys" },
    @{ Code = "KERNEL_AUTO_BOOST_LOCK_ACQUISITION_WITH_RAISED_IRQL"; Hex = "0x00000192"; Failed = "ntoskrnl.exe" },
    @{ Code = "UDFS_FILE_SYSTEM"; Hex = "0x00000026"; Failed = "udfs.sys" },
    @{ Code = "VIDEO_ENGINE_TIMEOUT_DETECTED"; Hex = "0x00000141"; Failed = "watchdog.sys" },
    @{ Code = "NDIS_INTERNAL_ERROR"; Hex = "0x0000011D"; Failed = "ndis.sys" },
    @{ Code = "PAGE_FAULT_IN_FREED_SPECIAL_POOL"; Hex = "0x000000E6"; Failed = "ntoskrnl.exe" },
    @{ Code = "KERNEL_AUTO_BOOST_INVALID_LOCK_RELEASE"; Hex = "0x00000193"; Failed = "ntoskrnl.exe" },
    @{ Code = "UNHANDLED_EXCEPTION_CONTEXT"; Hex = "0x0000019E"; Failed = "" },
    @{ Code = "EXFAT_FILE_SYSTEM"; Hex = "0x0000012C"; Failed = "exfat.sys" },
    @{ Code = "KERNEL_STACK_INPAGE_ERROR"; Hex = "0x00000077"; Failed = "ntoskrnl.exe" },
    @{ Code = "DATA_BUS_ERROR"; Hex = "0x0000002E"; Failed = "" },
    @{ Code = "NO_MORE_SYSTEM_PTES"; Hex = "0x0000003F"; Failed = "" },
    @{ Code = "TARGET_MDL_TOO_SMALL"; Hex = "0x00000040"; Failed = "" },
    @{ Code = "MUST_SUCCEED_POOL_EMPTY"; Hex = "0x00000041"; Failed = "" },
    @{ Code = "ATTEMPTED_SWITCH_FROM_DPC"; Hex = "0x000000B8"; Failed = "ntoskrnl.exe" },
    @{ Code = "MUTUALLY_EXCLUSIVE_RESOURCE_MUST_BE_LONG_TERM"; Hex = "0x000000C1"; Failed = "" },
    @{ Code = "DRIVER_LEFT_LOCKED_PAGES_IN_PROCESS"; Hex = "0x000000CB"; Failed = "" },
    @{ Code = "TERMINAL_SERVER_DRIVER_MADE_INCORRECT_MEMORY_REFERENCE"; Hex = "0x000000CF"; Failed = "rdpdr.sys" },
    @{ Code = "DRIVER_UNLOADED_WITHOUT_CANCELLING_PENDING_OPERATIONS"; Hex = "0x000000CE"; Failed = "" },
    @{ Code = "SYSTEM_SCAN_AT_RAISED_IRQL_CAUGHT_IMPROPER_DRIVER_UNLOAD"; Hex = "0x000000D4"; Failed = "" },
    @{ Code = "DRIVER_PORTION_MUST_BE_NONPAGED"; Hex = "0x000000D3"; Failed = "" },
    @{ Code = "VIDEO_DRIVER_INIT_FAILURE"; Hex = "0x000000B4"; Failed = "vgapnp.sys" },
    @{ Code = "BOOTLOG_FILE_SYSTEM"; Hex = "0x000000B7"; Failed = "" },
    @{ Code = "AGP_INVALID_ACCESS"; Hex = "0x00000017"; Failed = "videoprt.sys" },
    @{ Code = "AGP_GART_CORRUPTION"; Hex = "0x00000018"; Failed = "videoprt.sys" },
    @{ Code = "AGP_ILLEGAL_GART_ACCESS"; Hex = "0x00000019"; Failed = "videoprt.sys" },
    @{ Code = "FTDISK_INTERNAL_ERROR"; Hex = "0x00000058"; Failed = "ftdisk.sys" },
    @{ Code = "PINBALL_FILE_SYSTEM"; Hex = "0x00000059"; Failed = "pinball.sys" },
    @{ Code = "CRITICAL_SERVICE_FAILED"; Hex = "0x0000005A"; Failed = "" },
    @{ Code = "SET_ENV_VAR_FAILED"; Hex = "0x00000061"; Failed = "" },
    @{ Code = "IO1_INITIALIZATION_FAILED"; Hex = "0x00000069"; Failed = "" },
    @{ Code = "PROCESS1_INITIALIZATION_FAILED"; Hex = "0x0000006B"; Failed = "" },
    @{ Code = "REF_LM_DEBUG_STRING"; Hex = "0x0000006E"; Failed = "" },
    @{ Code = "SESSION3_INITIALIZATION_FAILED"; Hex = "0x0000006F"; Failed = "smss.exe" },
    @{ Code = "CONFIG_INITIALIZATION_FAILED"; Hex = "0x00000067"; Failed = "" },
    @{ Code = "CONFIG_LIST_FAILED"; Hex = "0x00000073"; Failed = "" },
    @{ Code = "BAD_SYSTEM_CONFIG_INFO"; Hex = "0x00000074"; Failed = "" },
    @{ Code = "CANNOT_WRITE_CONFIGURATION"; Hex = "0x00000075"; Failed = "" },
    @{ Code = "PROCESS_HAS_LOCKED_PAGES"; Hex = "0x00000076"; Failed = "" },
    @{ Code = "PHASE0_EXCEPTION"; Hex = "0x00000078"; Failed = "" },
    @{ Code = "MISMATCHED_HAL"; Hex = "0x00000079"; Failed = "hal.dll" },
    @{ Code = "INSTALL_MORE_MEMORY"; Hex = "0x0000007C"; Failed = "" },
    @{ Code = "SYSTEM_EXIT_OWNED_MUTEX"; Hex = "0x00000039"; Failed = "" },
    @{ Code = "MULTIPROCESSOR_CONFIGURATION_NOT_SUPPORTED"; Hex = "0x0000003E"; Failed = "" },
    @{ Code = "UNEXPECTED_KERNEL_MODE_TRAP"; Hex = "0x0000007F"; Failed = "ntoskrnl.exe" },
    @{ Code = "NDISTEST_INTERNAL_ERROR"; Hex = "0x0000008B"; Failed = "ndis.sys" },
    @{ Code = "SPECIAL_POOL_DETECTED_MEMORY_CORRUPTION"; Hex = "0x000000D6"; Failed = "ntoskrnl.exe" },
    @{ Code = "DRIVER_CORRUPTED_EXPOOL"; Hex = "0x000000C5"; Failed = "" },
    @{ Code = "DRIVER_CORRUPTED_MMPOOL"; Hex = "0x000000D0"; Failed = "" },
    @{ Code = "DRIVER_USED_EXCESSIVE_PTES"; Hex = "0x000000D4"; Failed = "" },
    @{ Code = "DRIVER_INVALID_STACK_ACCESS"; Hex = "0x000000DC"; Failed = "" },
    @{ Code = "CHR_INTERNAL_ERROR"; Hex = "0x000000E1"; Failed = "" },
    @{ Code = "RESOURCE_NOT_OWNED"; Hex = "0x000000E3"; Failed = "" },
    @{ Code = "CANCEL_STATE_IN_COMPLETED_IRP"; Hex = "0x000000E8"; Failed = "" },
    @{ Code = "SYSTEM_THREAD_NOT_GRANTED_ACCESS"; Hex = "0x000000EA"; Failed = "" },
    @{ Code = "DRIVER_RETURNED_STATUS_REPARSE_FOR_VOLUME_OPEN"; Hex = "0x000000ED"; Failed = "" },
    @{ Code = "HTTP_DRIVER_CORRUPTED"; Hex = "0x000000FA"; Failed = "http.sys" },
    @{ Code = "SECURE_KERNEL_ERROR"; Hex = "0x0000014B"; Failed = "securekernel.exe" },
    @{ Code = "HYPERVISOR_ERROR"; Hex = "0x000000200"; Failed = "hvix64.sys" },
    @{ Code = "WINLOGON_FATAL_ERROR"; Hex = "0x0000021A"; Failed = "winlogon.exe" },
    @{ Code = "DRIVER_RETURNED_HOLDING_LOCK"; Hex = "0x000000DE"; Failed = "" },
    @{ Code = "KERNEL_THREAD_PRIORITY_FLOOR_VIOLATION"; Hex = "0x0000015D"; Failed = "ntoskrnl.exe" },
    @{ Code = "VIDEO_SCHEDULER_INTERNAL_ERROR"; Hex = "0x00000119"; Failed = "dxgmms2.sys" },
    @{ Code = "ATTEMPTED_EXECUTE_OF_NOEXECUTE_MEMORY"; Hex = "0x000000FC"; Failed = "ntoskrnl.exe" }
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
    $script:bufGfx.Dispose(); $script:bufBmp.Dispose()
    Stop-Process -Id $PID -Force 
} })

[int]$w = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
[int]$h = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height
if ($w -eq 0) { $w = 1920 }; if ($h -eq 0) { $h = 1080 }
$scaleY = $h / 1080

$leftMargin = [int](30 * $scaleY)
$textYStart = [int](30 * $scaleY)

$mainFontSize = [int](16 * $scaleY)
if ($mainFontSize -lt 9) { $mainFontSize = 9 }

$classicText =  "A problem has been detected and windows has been shut down to prevent damage`r`nto your computer.`r`n`r`n"
if ($failingFile) {
    $classicText += "The problem seems to be caused by the following file: $failingFile`r`n`r`n"
}
$classicText += "$StopCode`r`n`r`n"
$classicText += "If this is the first time you've seen this Stop error screen,`r`nrestart your computer. If this screen appears again, follow`r`nthese steps:`r`n`r`n"
$classicText += "Check to make sure any new hardware or software is properly installed.`r`nIf this is a new installation, ask your hardware or software manufacturer`r`nfor any windows updates you might need.`r`n`r`n"
$classicText += "If problems continue, disable or remove any newly installed hardware`r`nor software. Disable BIOS memory options such as caching or shadowing.`r`nIf you need to use safe Mode to remove or disable components, restart`r`nyour computer, press F8 to select Advanced Startup Options, and then`r`nselect safe Mode.`r`n`r`n"
$classicText += "Technical information:`r`n`r`n"
$classicText += "*** STOP: $hexCode ($param1,$param2,$param3,0`r`n" + $param4.Substring(1) + ")`r`n`r`n"

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

$form.Add_Paint({
    param($sender, $e)
    $e.Graphics.DrawImage($script:bufBmp, 0, 0)
})

function Update-Buffer ($text) {
    $script:bufGfx.Clear($script:bgColor)
    $script:bufGfx.DrawString($text, $font, $brush, $leftMargin, $textYStart)
    
    $screenGfx = $form.CreateGraphics()
    $screenGfx.DrawImage($script:bufBmp, 0, 0)
    $screenGfx.Dispose()
}

$form.Add_Shown({
    $displayed = ""
    $batchSize = 45 
    for ($i = 0; $i -lt $classicText.Length; $i += $batchSize) {
        if (($i + $batchSize) -le $classicText.Length) {
            $displayed += $classicText.Substring($i, $batchSize)
        } else {
            $displayed += $classicText.Substring($i)
        }
        Update-Buffer $displayed
        [System.Windows.Forms.Application]::DoEvents()
        [System.Threading.Thread]::Sleep(1)
    }

    Start-Sleep -Milliseconds 200
    $displayed += "Collecting data for crash dump ...`r`n"
    Update-Buffer $displayed
    Start-Sleep -Milliseconds 150
    
    $displayed += "Initializing disk for crash dump ...`r`n"
    Update-Buffer $displayed
    Start-Sleep -Milliseconds 200
    
    $displayed += "Beginning dump of physical memory.`r`n"
    Update-Buffer $displayed
    Start-Sleep -Milliseconds 100
    
    $baseWithDump = $displayed + "Dumping physical memory to disk:  "
    
    Update-Buffer ($baseWithDump + "4")
    [System.Windows.Forms.Application]::DoEvents()
    Start-Sleep -Milliseconds 1500
    
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
    
    $font.Dispose()
    $brush.Dispose()
    $script:bufGfx.Dispose()
    $script:bufBmp.Dispose()
    Stop-Process -Id $PID -Force
})

[void]$form.ShowDialog()
