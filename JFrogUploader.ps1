<#PSScriptInfo
.VERSION 1.0
.GUID 2c8e4f1a-b5d7-4c62-8a9f-3d2e1b0c9f8e
.AUTHOR MeCRO-DEV
.COMPANYNAME MeCRO-DEV
.COPYRIGHT MeCRO-DEV
.TAGS JFrog Artifactory Upload
.LICENSEURI 
.PROJECTURI 
.ICONURI
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES
#>

<#
.DESCRIPTION
 JFrog Artifactory File Uploader - Upload files to JFrog Artifactory repository using REST API
#>

############################################################################
# JFrog Artifactory File Uploader
# PowerShell GUI for uploading files to JFrog Artifactory
############################################################################

#Requires -Version 5.0
param (
    [switch] $ShowConsole
)
Set-StrictMode -Version Latest

# UI XAML
[xml]$Global:xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
    xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
    Title="JFrog Artifactory Uploader" Height="550" Width="700"
    WindowStyle="None"
    WindowStartupLocation="CenterScreen"
    ResizeMode="NoResize"
    Background="#181735">

    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="45"/>
            <RowDefinition/>
        </Grid.RowDefinitions>
        <Grid.ColumnDefinitions>
            <ColumnDefinition/>
        </Grid.ColumnDefinitions>
        
        <!-- Title Bar -->
        <Grid x:Name="gTitle" Background="#0F0F4D" Grid.ColumnSpan="1">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="200"/>
                <ColumnDefinition/>
                <ColumnDefinition Width="40"/>
                <ColumnDefinition Width="80"/>
            </Grid.ColumnDefinitions>
            <TextBlock Text="JFrog Uploader" Margin="10,0,0,0" Foreground="Yellow" Grid.Column="0" Grid.ColumnSpan="1" VerticalAlignment="Center" HorizontalAlignment="Left" FontWeight="Medium" FontSize="20" FontFamily="Courier New Bold" />
            
            <Button x:Name="btAbout" Grid.Column="2" Content="i" Foreground="Cyan" FontSize="14" FontWeight="Medium" Grid.ColumnSpan="1" VerticalAlignment="Center">
                <Button.Style>
                    <Style TargetType="Button">
                        <Setter Property="TextElement.FontFamily" Value="Cascadia Mono SemiBold"/>
                        <Setter Property="Background" Value="#552284"/>
                        <Setter Property="Cursor" Value="Hand"/>
                        <Style.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Background" Value="#FF4C70"/>
                            </Trigger>
                        </Style.Triggers>
                    </Style>
                </Button.Style>
                <Button.Template>
                    <ControlTemplate TargetType="Button">
                        <Border Width="25" Height="25" CornerRadius="15" Background="{TemplateBinding Background}">
                            <ContentPresenter VerticalAlignment="Center" HorizontalAlignment="Center"/>
                        </Border>
                    </ControlTemplate>
                </Button.Template>
            </Button>
            
            <Button x:Name="btExit" Grid.Column="3" Content="Exit" Margin="15,0,0,0" Foreground="Cyan" FontSize="14" FontWeight="Medium" Grid.ColumnSpan="1" VerticalAlignment="Center">
                <Button.Style>
                    <Style TargetType="Button">
                        <Setter Property="TextElement.FontFamily" Value="Courier New"/>
                        <Setter Property="Background" Value="#552284"/>
                        <Setter Property="Cursor" Value="Hand"/>
                        <Style.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Background" Value="#FF4C70"/>
                            </Trigger>
                        </Style.Triggers>
                    </Style>
                </Button.Style>
                <Button.Template>
                    <ControlTemplate TargetType="Button">
                        <Border Width="60" Height="25" CornerRadius="20" Background="{TemplateBinding Background}">
                            <ContentPresenter VerticalAlignment="Center" HorizontalAlignment="Center"/>
                        </Border>
                    </ControlTemplate>
                </Button.Template>
            </Button>
        </Grid>
        
        <!-- Main Content -->
        <StackPanel Grid.Row="1">
            <StackPanel Orientation="Vertical" Margin="10,10,0,0">
                
                <!-- JFrog Configuration Section -->
                <StackPanel Orientation="Vertical" Margin="10,5,0,0">
                    <TextBlock Text="JFrog Artifactory Configuration" Foreground="Lime" FontSize="16" FontWeight="Bold" FontFamily="Courier New" Margin="0,0,0,10"/>
                    
                    <StackPanel Orientation="Horizontal" Margin="0,5,0,0">
                        <TextBlock Text="Server URL:" Width="100" Foreground="Cyan" FontSize="14" FontWeight="Light" FontFamily="Courier New" VerticalAlignment="Center"/>
                        <TextBox x:Name="tbServerUrl" Width="330" Height="25" Margin="10,0,0,0" Background="Black" Foreground="White" FontFamily="Courier New" FontSize="12" 
                                 Text="" VerticalContentAlignment="Center"/>
                    </StackPanel>
                    
                    <StackPanel Orientation="Horizontal" Margin="0,10,0,0">
                        <TextBlock Text="Repository:" Width="100" Foreground="Cyan" FontSize="14" FontWeight="Light" FontFamily="Courier New" VerticalAlignment="Center"/>
                        <TextBox x:Name="tbRepository" Width="330" Height="25" Margin="10,0,0,0" Background="Black" Foreground="White" FontFamily="Courier New" FontSize="12" 
                                 Text="" VerticalContentAlignment="Center"/>
                        <TextBlock Text="Path:" Width="50" Margin="20,0,0,0" Foreground="Cyan" FontSize="14" FontWeight="Light" FontFamily="Courier New" VerticalAlignment="Center"/>
                        <TextBox x:Name="tbTargetPath" Width="150" Height="25" Margin="10,0,0,0" Background="Black" Foreground="White" FontFamily="Courier New" FontSize="12" 
                                 Text="" VerticalContentAlignment="Center"/>
                    </StackPanel>
                    
                    <StackPanel Orientation="Horizontal" Margin="0,10,0,0">
                        <TextBlock Text="API Token:" Width="100" Foreground="Cyan" FontSize="14" FontWeight="Light" FontFamily="Courier New" VerticalAlignment="Center"/>
                        <PasswordBox x:Name="pbApiToken" Width="490" Height="25" Margin="10,0,0,0" Background="Black" Foreground="White" FontFamily="Courier New" FontSize="12"/>
                        <Button x:Name="btTestConnection" Content="Test" Width="60" Height="25" Margin="10,0,0,0" FontSize="16" FontWeight="Medium" FontFamily="Courier New">
                            <Button.Style>
                                <Style TargetType="Button">
                                    <Setter Property="Background" Value="#4CAF50"/>
                                    <Setter Property="Foreground" Value="White"/>
                                    <Setter Property="Cursor" Value="Hand"/>
                                    <Style.Triggers>
                                        <Trigger Property="IsMouseOver" Value="True">
                                            <Setter Property="Background" Value="#45a049"/>
                                        </Trigger>
                                    </Style.Triggers>
                                </Style>
                            </Button.Style>
                            <Button.Template>
                                <ControlTemplate TargetType="Button">
                                    <Border CornerRadius="5" Background="{TemplateBinding Background}">
                                        <ContentPresenter VerticalAlignment="Center" HorizontalAlignment="Center"/>
                                    </Border>
                                </ControlTemplate>
                            </Button.Template>
                        </Button>
                    </StackPanel>
                </StackPanel>
                
                <Line X1="0" Y1="20" X2="680" Y2="20" Stroke="Lime" StrokeThickness="2" Margin="0,0,0,0"/>
                
                <!-- File Selection Section -->
                <StackPanel Orientation="Vertical" Margin="10,20,0,0">
                    <StackPanel Orientation="Horizontal" Margin="0,0,0,10">
                        <TextBlock Text="File Selection" Foreground="Lime" FontSize="16" FontWeight="Bold" FontFamily="Courier New" Margin="0,0,0,0"/>
                        <Button x:Name="btSelectFiles" Content="Select" Width="100" Height="30" Margin="20,-5,0,0" FontSize="16" FontWeight="Medium" FontFamily="Courier New">
                            <Button.Style>
                                <Style TargetType="Button">
                                    <Setter Property="Background" Value="Orange"/>
                                    <Setter Property="Foreground" Value="Black"/>
                                    <Setter Property="Cursor" Value="Hand"/>
                                    <Style.Triggers>
                                        <Trigger Property="IsMouseOver" Value="True">
                                            <Setter Property="Background" Value="#FFCCFF"/>
                                            <Setter Property="Foreground" Value="Blue"/>
                                        </Trigger>
                                    </Style.Triggers>
                                </Style>
                            </Button.Style>
                            <Button.Template>
                                <ControlTemplate TargetType="Button">
                                    <Border CornerRadius="10" Background="{TemplateBinding Background}">
                                        <ContentPresenter VerticalAlignment="Center" HorizontalAlignment="Center"/>
                                    </Border>
                                </ControlTemplate>
                            </Button.Template>
                        </Button>
                        
                        <Button x:Name="btClearFiles" Content="Clear" Width="100" Height="30" Margin="20,-10,0,0" FontSize="16" FontWeight="Medium" FontFamily="Courier New">
                            <Button.Style>
                                <Style TargetType="Button">
                                    <Setter Property="Background" Value="#f44336"/>
                                    <Setter Property="Foreground" Value="White"/>
                                    <Setter Property="Cursor" Value="Hand"/>
                                    <Style.Triggers>
                                        <Trigger Property="IsMouseOver" Value="True">
                                            <Setter Property="Background" Value="#da190b"/>
                                        </Trigger>
                                    </Style.Triggers>
                                </Style>
                            </Button.Style>
                            <Button.Template>
                                <ControlTemplate TargetType="Button">
                                    <Border CornerRadius="10" Background="{TemplateBinding Background}">
                                        <ContentPresenter VerticalAlignment="Center" HorizontalAlignment="Center"/>
                                    </Border>
                                </ControlTemplate>
                            </Button.Template>
                        </Button>
                        
                        <Button x:Name="btUpload" Content="Upload" Width="100" Height="30" Margin="20,-10,0,0" FontSize="16" FontWeight="Medium" FontFamily="Courier New">
                            <Button.Style>
                                <Style TargetType="Button">
                                    <Setter Property="Background" Value="#2196F3"/>
                                    <Setter Property="Foreground" Value="White"/>
                                    <Setter Property="Cursor" Value="Hand"/>
                                    <Style.Triggers>
                                        <Trigger Property="IsMouseOver" Value="True">
                                            <Setter Property="Background" Value="#1976D2"/>
                                        </Trigger>
                                    </Style.Triggers>
                                </Style>
                            </Button.Style>
                            <Button.Template>
                                <ControlTemplate TargetType="Button">
                                    <Border CornerRadius="10" Background="{TemplateBinding Background}">
                                        <ContentPresenter VerticalAlignment="Center" HorizontalAlignment="Center"/>
                                    </Border>
                                </ControlTemplate>
                            </Button.Template>
                        </Button>
                    </StackPanel>
                    
                    <!-- Selected Files List -->
                    <ListBox x:Name="lbSelectedFiles" Height="150" Width="660" Margin="-20,0,0,0" Background="Black" Foreground="Lime" FontFamily="Courier New" FontSize="11"
                             ScrollViewer.HorizontalScrollBarVisibility="Auto" ScrollViewer.VerticalScrollBarVisibility="Auto">
                        <ListBox.ItemTemplate>
                            <DataTemplate>
                                <TextBlock Text="{Binding}" Foreground="Lime" FontFamily="Courier New" FontSize="11"/>
                            </DataTemplate>
                        </ListBox.ItemTemplate>
                    </ListBox>
                </StackPanel>
                
                <Line X1="0" Y1="20" X2="680" Y2="20" Stroke="Lime" StrokeThickness="2" Margin="0,0,0,0"/>
                
                <!-- Progress Section -->
                <StackPanel Orientation="Vertical" Margin="10,20,0,0">
                    <TextBlock Text="Upload Progress" Foreground="Lime" FontSize="16" FontWeight="Bold" FontFamily="Courier New" Margin="0,0,0,10"/>
                    <TextBlock x:Name="tbProgress" Text="Ready to upload..." Foreground="White" FontSize="14" FontFamily="Courier New" Width="600"/>
                </StackPanel>
                
                <StackPanel Orientation="Horizontal" Margin="10,10,0,0">
                    <TextBlock x:Name="tbFileCount" Text="Files: 0" Width="100" Foreground="White" FontSize="12" FontWeight="Light" FontFamily="Courier New"/>
                    <TextBlock x:Name="tbCopyright" Text="© MeCRO-DEV" Margin="440,0,0,0" Foreground="Yellow" FontSize="14" FontWeight="Normal" FontFamily="Segoe Script"/>
                </StackPanel>
                <ProgressBar x:Name="pbUploadProgress" Width="660" Height="2" Margin="-10,10,0,0" IsIndeterminate="False" Background="#181735" Foreground="Yellow" BorderThickness="0"/>
            </StackPanel>
        </StackPanel>
    </Grid>
</Window>
"@

try {
    Add-Type -AssemblyName PresentationFramework,PresentationCore,WindowsBase,System.Windows.Forms,System.Drawing
} catch {
    Throw "Failed to load WPF assemblies, script terminated."
}

# Global variables
$Global:SelectedFiles = @()
$Global:UploadInProgress = $false

# Initialize the GUI
$syncHash = [hashtable]::Synchronized(@{})
$syncHash.UploadInProgress = $false
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$syncHash.window = [Windows.Markup.XamlReader]::Load($reader)
$syncHash.Gui = @{}

$xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'x:Name')]]") | ForEach-Object {
    if (!($_ -match "ColorAnimation" -or $_ -match "ThicknessAnimation")) {
        $syncHash.Gui.Add($_.Name, $syncHash.Window.FindName($_.Name)) 2>&1 3>&1 4>&1 | Out-Null
    }
}

# Window drag functionality
$syncHash.Gui.gTitle.Add_MouseDown({
    $e = [System.Windows.Input.MouseButtonEventArgs]$args[1]
    if ($e.LeftButton -eq [System.Windows.Input.MouseButtonState]::Pressed) {
        $syncHash.window.DragMove()
    }
})

# Exit button event
$syncHash.Gui.btExit.Add_Click({
    $syncHash.Window.Close()
})

# About button event
$syncHash.Gui.btAbout.Add_Click({
    [System.Windows.MessageBox]::Show(
        "JFrog Artifactory File Uploader v1.0`n`nUpload files to JFrog Artifactory repository using REST API.`n`nEnvironment Variables:`n- JFROG_URL (*)`n- JFROG_REPO (*)`n- JFROG_PATH`n- JFROG_TOKEN (*)",
        "About JFrog Uploader",
        [System.Windows.MessageBoxButton]::OK,
        [System.Windows.MessageBoxImage]::Information
    )
})

# Select Files button event
$syncHash.Gui.btSelectFiles.Add_Click({
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Multiselect = $true
    $openFileDialog.Title = "Select Files to Upload"
    $openFileDialog.Filter = "All Files (*.*)|*.*"
    
    if ($openFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        # Append new files to existing list, avoiding duplicates
        $newFiles = $openFileDialog.FileNames | Where-Object { $Global:SelectedFiles -notcontains $_ }
        $Global:SelectedFiles += $newFiles
        Update-FilesList
    }
})

# Clear Files button event
$syncHash.Gui.btClearFiles.Add_Click({
    $Global:SelectedFiles = @()
    Update-FilesList
})

# Test Connection button event
$syncHash.Gui.btTestConnection.Add_Click({
    Test-JFrogConnection
})

# ListBox double-click event to remove selected file
$syncHash.Gui.lbSelectedFiles.Add_MouseDoubleClick({
    $selectedItem = $syncHash.Gui.lbSelectedFiles.SelectedItem
    if ($selectedItem -ne $null) {
        # Remove the selected file from the global array, ensure it remains an array
        $filteredFiles = $Global:SelectedFiles | Where-Object { $_ -ne $selectedItem }
        $Global:SelectedFiles = @($filteredFiles)
        Update-FilesList
    }
})

# Upload Files button event
$syncHash.Gui.btUpload.Add_Click({
    if ($syncHash.UploadInProgress -eq $true) {
        Show-ErrorMessage "Upload already in progress!" "Upload In Progress"
        return
    }
    
    if ($Global:SelectedFiles.Count -eq 0) {
        Show-ErrorMessage "No files selected for upload. Please select files first." "No Files Selected"
        return
    }
    
    if ([string]::IsNullOrWhiteSpace($syncHash.Gui.tbServerUrl.Text) -or 
        [string]::IsNullOrWhiteSpace($syncHash.Gui.tbRepository.Text) -or 
        [string]::IsNullOrWhiteSpace($syncHash.Gui.pbApiToken.Password)) {
        Show-ErrorMessage "Please fill in all required fields:`n- Server URL`n- Repository`n- API Token" "Missing Required Fields"
        return
    }
    
    Start-Upload
})

# Functions
function Show-ErrorMessage {
    param([string]$Message, [string]$Title = "Error")
    
    $syncHash.Window.Dispatcher.Invoke([action]{
        [System.Windows.MessageBox]::Show(
            $Message,
            $Title,
            [System.Windows.MessageBoxButton]::OK,
            [System.Windows.MessageBoxImage]::Error
        )
    })
}

function Show-InfoMessage {
    param([string]$Message, [string]$Title = "Information")
    
    $syncHash.Window.Dispatcher.Invoke([action]{
        [System.Windows.MessageBox]::Show(
            $Message,
            $Title,
            [System.Windows.MessageBoxButton]::OK,
            [System.Windows.MessageBoxImage]::Information
        )
    })
}

function Update-FilesList {
    $syncHash.Gui.lbSelectedFiles.Items.Clear()
    foreach ($file in $Global:SelectedFiles) {
        $syncHash.Gui.lbSelectedFiles.Items.Add($file)
    }
    
    $syncHash.Gui.tbFileCount.Text = "Files: $($Global:SelectedFiles.Count)"
}

function Test-JFrogConnection {
    try {
        $serverUrl = $syncHash.Gui.tbServerUrl.Text.TrimEnd('/')
        $apiToken = $syncHash.Gui.pbApiToken.Password
        
        if ([string]::IsNullOrWhiteSpace($serverUrl) -or [string]::IsNullOrWhiteSpace($apiToken)) {
            Show-ErrorMessage "Server URL and API Token are required for connection test" "Connection Test Failed"
            return
        }
        
        # Create headers for authentication
        $headers = @{
            "Authorization" = "Bearer $apiToken"
            "Content-Type" = "application/json"
        }
        
        # Test connection by getting system info
        $testUrl = "$serverUrl/api/system/ping"
        
        $response = Invoke-RestMethod -Uri $testUrl -Method GET -Headers $headers -TimeoutSec 30
        
        if ($response -eq "OK") {
            Show-InfoMessage "Connection to JFrog Artifactory established successfully!" "Connection Test Successful"
        } else {
            Show-ErrorMessage "Unexpected response from server: $response" "Connection Test Warning"
        }
        
    } catch {
        Show-ErrorMessage "Failed to connect to JFrog Artifactory:`n`n$($_.Exception.Message)" "Connection Test Failed"
    }
}

function Start-Upload {
    $Global:UploadInProgress = $true
    $syncHash.UploadInProgress = $true
    $syncHash.Gui.tbProgress.Text = "Starting upload..."
    
    # Set progress bar to indeterminate mode
    $syncHash.Gui.pbUploadProgress.IsIndeterminate = $true
    
    # Disable upload button during upload
    $syncHash.Gui.btUpload.IsEnabled = $false
    
    # Get GUI values before starting background task
    $serverUrl = $syncHash.Gui.tbServerUrl.Text.TrimEnd('/')
    $repository = $syncHash.Gui.tbRepository.Text
    $targetPath = $syncHash.Gui.tbTargetPath.Text
    $apiToken = $syncHash.Gui.pbApiToken.Password
    
    # Create a runspace for background upload
    $runspace = [runspacefactory]::CreateRunspace()
    $runspace.Open()
    $runspace.SessionStateProxy.SetVariable("syncHash", $syncHash)
    $runspace.SessionStateProxy.SetVariable("SelectedFiles", $Global:SelectedFiles)
    $runspace.SessionStateProxy.SetVariable("ServerUrl", $serverUrl)
    $runspace.SessionStateProxy.SetVariable("Repository", $repository)
    $runspace.SessionStateProxy.SetVariable("TargetPath", $targetPath)
    $runspace.SessionStateProxy.SetVariable("ApiToken", $apiToken)
    
    $powershell = [powershell]::Create().AddScript({
        param($syncHash, $SelectedFiles, $ServerUrl, $Repository, $TargetPath, $ApiToken)
        
        function Update-ProgressFromBG {
            param([string]$Status)
            
            $syncHash.Gui.tbProgress.Dispatcher.Invoke([action]{
                $syncHash.Gui.tbProgress.Text = $Status
            })
        }
        
        function Show-ErrorFromBG {
            param([string]$Message, [string]$Title = "Upload Error")
            
            $syncHash.Window.Dispatcher.Invoke([action]{
                [System.Windows.MessageBox]::Show(
                    $Message,
                    $Title,
                    [System.Windows.MessageBoxButton]::OK,
                    [System.Windows.MessageBoxImage]::Error
                )
            })
        }
        
        function Show-InfoFromBG {
            param([string]$Message, [string]$Title = "Upload Complete")
            
            $syncHash.Window.Dispatcher.Invoke([action]{
                [System.Windows.MessageBox]::Show(
                    $Message,
                    $Title,
                    [System.Windows.MessageBoxButton]::OK,
                    [System.Windows.MessageBoxImage]::Information
                )
            })
        }
        
        try {
            # Use the passed parameters instead of accessing GUI elements
            # Ensure target path ends with /
            if (-not [string]::IsNullOrWhiteSpace($TargetPath) -and -not $TargetPath.EndsWith('/')) {
                $TargetPath += '/'
            }
            
            $headers = @{
                "Authorization" = "Bearer $ApiToken"
            }
            
            $totalFiles = $SelectedFiles.Count
            $uploadedFiles = 0
            $failedFiles = @()
            
            foreach ($filePath in $SelectedFiles) {
                try {
                    $fileName = [System.IO.Path]::GetFileName($filePath)
                    $uploadUrl = "$ServerUrl/$Repository/$TargetPath$fileName"
                    
                    Update-ProgressFromBG -Status "Uploading: $fileName"
                    
                    # Read file content
                    $fileBytes = [System.IO.File]::ReadAllBytes($filePath)
                    
                    # Upload file using REST API
                    $response = Invoke-RestMethod -Uri $uploadUrl -Method PUT -Body $fileBytes -Headers $headers -ContentType "application/octet-stream"
                    
                    $uploadedFiles++
                    
                } catch {
                    $failedFiles += "$fileName - $($_.Exception.Message)"
                }
                
                # Update progress
                Update-ProgressFromBG -Status "Progress: $($uploadedFiles + $failedFiles.Count)/$totalFiles files processed"
            }
            
            # Final summary
            Update-ProgressFromBG -Status "Upload completed: $uploadedFiles successful, $($failedFiles.Count) failed"
            
            # Show results
            if ($failedFiles.Count -eq 0) {
                Show-InfoFromBG "All $uploadedFiles files uploaded successfully!" "Upload Successful"
            } elseif ($uploadedFiles -eq 0) {
                $errorMessage = "All files failed to upload:`n`n" + ($failedFiles -join "`n")
                Show-ErrorFromBG $errorMessage "Upload Failed"
            } else {
                $errorMessage = "$uploadedFiles files uploaded successfully, but $($failedFiles.Count) files failed:`n`n" + ($failedFiles -join "`n")
                Show-ErrorFromBG $errorMessage "Upload Partially Failed"
            }
            
        } catch {
            Update-ProgressFromBG -Status "Upload failed"
            Show-ErrorFromBG "Fatal error during upload:`n`n$($_.Exception.Message)" "Upload Error"
        } finally {
            # Re-enable upload button, reset upload flags, and stop progress bar
            $syncHash.Gui.btUpload.Dispatcher.Invoke([action]{
                $syncHash.Gui.btUpload.IsEnabled = $true
                $syncHash.Gui.pbUploadProgress.IsIndeterminate = $false
            })
            
            # Reset upload flags in syncHash (accessible from main thread)
            $syncHash.UploadInProgress = $false
        }
    })
    
    $powershell.Runspace = $runspace
    $powershell.AddParameter("syncHash", $syncHash)
    $powershell.AddParameter("SelectedFiles", $Global:SelectedFiles)
    $powershell.AddParameter("ServerUrl", $serverUrl)
    $powershell.AddParameter("Repository", $repository)
    $powershell.AddParameter("TargetPath", $targetPath)
    $powershell.AddParameter("ApiToken", $apiToken)
    $powershell.BeginInvoke()
}

# Console visibility functions
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'

function Show-Console {
    $consolePtr = [Console.Window]::GetConsoleWindow()
    [Console.Window]::ShowWindow($consolePtr, 5) | Out-Null
}

function Hide-Console {
    $consolePtr = [Console.Window]::GetConsoleWindow()
    [Console.Window]::ShowWindow($consolePtr, 0) | Out-Null
}

# Handle console visibility
if ($ShowConsole.IsPresent) {
    Show-Console
} else {
    Hide-Console
}

# Initialize UI
Update-FilesList

# Load values from environment variables
$jfrogUrl = $env:JFROG_URL
if (![string]::IsNullOrWhiteSpace($jfrogUrl)) {
    $syncHash.Gui.tbServerUrl.Text = $jfrogUrl
}

$jfrogRepo = $env:JFROG_REPO
if (![string]::IsNullOrWhiteSpace($jfrogRepo)) {
    $syncHash.Gui.tbRepository.Text = $jfrogRepo
}

$jfrogPath = $env:JFROG_PATH
if (![string]::IsNullOrWhiteSpace($jfrogPath)) {
    $syncHash.Gui.tbTargetPath.Text = $jfrogPath
}

$jfrogToken = $env:JFROG_TOKEN
if (![string]::IsNullOrWhiteSpace($jfrogToken)) {
    $syncHash.Gui.pbApiToken.Password = $jfrogToken
}

# Show the window
$syncHash.window.ShowDialog() | Out-Null