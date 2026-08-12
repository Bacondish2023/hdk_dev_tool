@echo off
rem This script replaces version string in files
rem Do NOT copy this script because this is not generic.
rem

setlocal enabledelayedexpansion
set SCRIPT_NAME=%~n0
set RESULT_OF_COMMAND=0

set TARGET_FILES=README.md ^
cpp\script\code\do_build.bat ^
cpp\script\code\do_build.sh ^
cpp\script\code\do_clean.bat ^
cpp\script\code\do_clean.sh ^
cpp\script\code\do_lint.bat ^
cpp\script\code\do_lint.sh ^
cpp\script\code\do_test.bat ^
cpp\script\code\do_test.sh ^
embedded\avr8\script\code\do_build.bat ^
embedded\avr8\script\code\do_build.sh ^
embedded\avr8\script\code\do_clean.bat ^
embedded\avr8\script\code\do_clean.sh ^
embedded\avr8\script\code\do_lint.bat ^
embedded\avr8\script\code\do_lint.sh ^
embedded\avr8\script\code\do_test.bat ^
embedded\avr8\script\code\do_test.sh ^
embedded\avr8\script\code\toolchain_avr8_real.cmake ^
embedded\avr8\script\code\toolchain_avr8_simulation.cmake ^
papyrusrt\script\code\do_build.bat ^
papyrusrt\script\code\do_build.sh ^
papyrusrt\script\code\do_clean.bat ^
papyrusrt\script\code\do_clean.sh ^
papyrusrt\script\code\do_lint.bat ^
papyrusrt\script\code\do_lint.sh ^
papyrusrt\script\code\do_test.bat ^
papyrusrt\script\code\do_test.sh ^
papyrusrt\script\code\start_papyrusrt.bat ^
papyrusrt\script\code\start_papyrusrt.sh ^
python\script\code\do_build.bat ^
python\script\code\do_build.sh ^
python\script\code\do_clean.bat ^
python\script\code\do_clean.sh ^
python\script\code\do_lint.bat ^
python\script\code\do_lint.sh ^
python\script\code\do_test.bat ^
python\script\code\do_test.sh

set OLD_STRING=1.1.0
set NEW_STRING=1.1.1

echo !SCRIPT_NAME!: Starts
echo !SCRIPT_NAME!: Replaces "%OLD_STRING%" to "%NEW_STRING%"

for %%f in (%TARGET_FILES%) do (
  echo !SCRIPT_NAME!: Handles "%%f"

  python -B tool\string_replacer.py --fail_if_no_match %%f %OLD_STRING% %NEW_STRING%
  set RESULT_OF_COMMAND=!ERRORLEVEL!
  if !RESULT_OF_COMMAND! NEQ 0 (
    echo !SCRIPT_NAME!: Failed. Return code is: !RESULT_OF_COMMAND!
    exit /B 1
  )
)

echo !SCRIPT_NAME!: Exits successfully
endlocal

exit /B 0
