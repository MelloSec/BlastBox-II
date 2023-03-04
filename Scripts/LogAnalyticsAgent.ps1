# Save your workspace ID and Key from Senintel workspace as variables $ID and $KEY
Invoke-WebRequest https://go.microsoft.com/fwlink/?LinkId=828603 -o setup.exe
setup.exe /qn NOAPM=1 ADD_OPINSIGHTS_WORKSPACE=1 OPINSIGHTS_WORKSPACE_AZURE_CLOUD_TYPE=0 OPINSIGHTS_WORKSPACE_ID=$ID OPINSIGHTS_WORKSPACE_KEY=$KEY AcceptEndUserLicenseAgreement=1