using namespace System.Management.Automation.Host

$scriptverion = '1.0'
Write-Host -ForegroundColor Yellow "Script version $scriptverion"

function Start-DeploymentMenu {
    $title = ''
    $question = 'Please choose a deployment option:'
    $zti = [ChoiceDescription]::new('&ZTI', 'Zero Touch Install - Fully automated install without any prompts.')
    $gui = [ChoiceDescription]::new('&UI', 'UI Install - A UI to choose install options.')
    $quit = [ChoiceDescription]::new('&Quit', 'Quit and restart device.')
    $options = [ChoiceDescription[]]($zti, $gui, $quit)
    $result = $host.ui.PromptForChoice($title, $question, $options, 0)
    switch ($result) {
        0 { 
            # Start OSDCloud Process
            Write-Host -ForegroundColor Cyan "Starting OSDCloud ZTI"
            Start-OSDCloud -OSLanguage en-us -OSBuild 21H1 -OSEdition Enterprise -ZTI
    
            # Restart
            Write-Host -ForegroundColor Cyan "Restarting in 20 seconds!"
            Start-Sleep -Seconds 20
            wpeutil reboot
        }
        1 { 
            # Start OSDCloud UI
            Write-Host -ForegroundColor Cyan "Starting OSDCloud UI"
            Start-OSDCloud
        }
        2 { 
            # Restart
            Write-Host -ForegroundColor Cyan "Restarting in 20 seconds!"
            Start-Sleep -Seconds 20
            wpeutil reboot
        }
    }
}

Start-DeploymentMenu 
