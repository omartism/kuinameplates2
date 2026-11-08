@echo off
cd /d "%~dp0"
echo Creating junctions for Kui Nameplates into Interface\AddOns...
mklink /J "..\Kui_Media" "Kui_Media"
mklink /J "..\Kui_Nameplates" "Kui_Nameplates"
mklink /J "..\Kui_Nameplates_Core" "Kui_Nameplates_Core"
mklink /J "..\Kui_Nameplates_Core_Config" "Kui_Nameplates_Core_Config"
echo Done!
pause
