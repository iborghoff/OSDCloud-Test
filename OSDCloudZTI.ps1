using namespace System.Management.Automation.Host

Write-Host  -ForegroundColor Cyan "Starting OSDCloud ..."
Start-Sleep -Seconds 5

# Menu
function Deployment-Menu {
    $title = ''
    $question = 'Please choose a deployment option:'
    $zti = [ChoiceDescription]::new('&ZTI', 'Zero Touch Install - This is fully automated without any prompts.')
    $gui = [ChoiceDescription]::new('&GUI', 'GUI Install - A UI to choose install options.')
    $quit = [ChoiceDescription]::new('&Quit', 'Quit and restart the device.')
    $options = [ChoiceDescription[]]($zti, $gui, $quit)
    $result = $host.ui.PromptForChoice($title, $question, $options, 0)
    switch ($result) {
        0 { 
            # Update OSD
            Write-Host  -ForegroundColor Cyan "Updating OSD PowerShell Module"
            Install-Module OSD -Force

            Write-Host  -ForegroundColor Cyan "Importing OSD PowerShell Module"
            Import-Module OSD -Force

            # Start OSDCloud Process
            Write-Host  -ForegroundColor Cyan "Starting OSDCloud"
            $userconf = Read-Host -Prompt 'Choose deployment method:' 

            switch ($userconf) {
                UI {  }
                ZTI { Start-OSDCloud -OSLanguage en-us -OSBuild 21H1 -OSEdition Enterprise -ZTI }
                Default { Start-OSDCloud -OSLanguage en-us -OSBuild 21H1 -OSEdition Enterprise -ZTI }
            }

            # Restart
            Write-Host  -ForegroundColor Cyan "Restarting in 20 seconds!"
            Start-Sleep -Seconds 20
            wpeutil reboot
        }
        1 { 
            Start-OSDCloudGUI
        }
        2 { 
            Write-Host 'Restarting device.'
            wpeutil reboot
         }
    }
}
Deployment-Menu
