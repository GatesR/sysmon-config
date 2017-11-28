@echo on
cd C:\ProgramData\SMon\
@powershell (new-object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/gatesr/sysmon-config/master/sysmonconfig-export.xml','C:\ProgramData\sysmon\sysmonconfig-export.xml')"
SMon64 -c sysmonconfig-export.xml
exit
