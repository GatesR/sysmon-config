@echo off
setlocal
set hour=%time:~0,2%
set minute=%time:~3,2%
set /A minute+=2
if %minute% GTR 59 (
 set /A minute-=60
 set /A hour+=1
)
if %hour%==24 set hour=00
if "%hour:~0,1%"==" " set hour=0%hour:~1,1%
if "%hour:~1,1%"=="" set hour=0%hour%
if "%minute:~1,1%"=="" set minute=0%minute%
set tasktime=%hour%:%minute%
mkdir C:\ProgramData\SMon
pushd "C:\ProgramData\SMon\"
echo [+] Downloading SMon...
@powershell (new-object System.Net.WebClient).DownloadFile('https://live.sysinternals.com/Sysmon64.exe','C:\ProgramData\sysmon\SMon64.exe')"
echo [+] Downloading Sysmon config...
@powershell (new-object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/gatesr/sysmon-config/master/sysmonconfig-export.xml','C:\ProgramData\sysmon\sysmonconfig-export.xml')"
@powershell (new-object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/gatesr/sysmon-config/master/Auto_update.bat','C:\ProgramData\sysmon\Auto_Update.bat')"
SMon64.exe -accepteula -i sysmonconfig-export.xml
echo [+] mon Successfully Installed!
attrib +s +h +r c:\ProgramData\mon
echo Y | cacls c:\ProgramData\SMon /e /p everyone:n
echo Y | cacls c:\ProgramData\SMon /p system:f
echo Y | cacls c:\ProgramData\SMon /p Administrators:f
sc failure mon actions= restart/10000/restart/10000// reset= 120
echo [+] SMon Directory Permissions Reset and Services Hidden
sc sdset SMon D:(D;;DCLCWPDTSD;;;IU)(D;;DCLCWPDTSD;;;SU)(D;;DCLCWPDTSD;;;BA)(A;;CCLCSWLOCRRC;;;IU)(A;;CCLCSWLOCRRC;;;SU)(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)S:(AU;FA;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;WD)
echo [+] Creating Auto Update Task set to Hourly..
SchTasks /Create /RU SYSTEM /RL HIGHEST /SC HOURLY /TN Update_SMon_Rules /TR C:\ProgramData\mon\Auto_Update.bat /F /ST %tasktime%
timeout /t 10
exit
