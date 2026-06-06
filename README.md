# Windows-NT-Old-BSOD

A PowerShell-based utility that emulates legacy Blue Screen of Death (BSOD) screens from Windows NT through **Windows 7**. Designed for use on **Windows 10** and **Windows 11** systems to reproduce classic system error visuals.
##  Features

1. **Classic BSOD Intro**  
   Displays the iconic line:  
   *“A problem has been detected and Windows has been shut down to prevent damage to your computer.”*

2. **Character‑by‑Character Typing**  
   Text animates across the screen, giving the illusion of the crash message being “typed” live.

3. **Driver Failure Simulation**  
   If a failing driver is selected, the BSOD shows:  
   *“The problem seems to be caused by the following file: example.sys”*

4. **Randomized Stop Codes**  
   Pulls from a large set of authentic Windows stop codes (e.g., `0x0000007E`, `0x00000050`) with matching driver names.

5. **Fake Kernel Addresses & Parameters**  
   Generates random memory addresses and parameters to replicate real crash details.

6. **Crash Dump Sequence**  
   Simulates the dump process with lines like:  
   - “Collecting data for crash dump …”  
   - “Dumping physical memory to disk: XX%”  
   - Progress counter runs from 4% to 100% with randomized increments.

7. **Safe Simulation**  
   Runs in fullscreen, hides cursor, exits with **Escape**, and cleans up resources no actual crash or data loss.

   # SET-UP: 

  ##  1. Change to downloads dir: cd Downloads

  ##  2. Locate the folder

 ##   3. Change the dir to that folder which is: cd Windows-NT-Old-BSOD-1.0.0\Windows-NT-Old-BSOD-1.0.0

##   4. Allow script execution for this session (required for unsigned scripts): Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

##   5. Run the script: .\BugCheck-Mockup.ps1
