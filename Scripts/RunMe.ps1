Invoke-WebRequest https://github.com/MelloSec/BlastBox-II/archive/refs/heads/main.zip -o main.zip 
Expand-Archive .\main.zip
cd .\main\BlastBox-II-main\Scripts\
set-executionpolicy bypass 
.\Choco-Loader.ps1
