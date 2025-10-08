# JFrog Artifactory Uploader

A PowerShell GUI application for uploading files to JFrog Artifactory repository using REST API.

## Description

JFrog Artifactory Uploader is a user-friendly Windows desktop application built with PowerShell and WPF that provides an intuitive graphical interface for uploading multiple files to JFrog Artifactory repositories. The application features a modern dark-themed UI and supports batch file uploads with real-time progress tracking.

## Features

### Core Functionality
- **File Selection**: Multi-select file dialog for choosing files to upload
- **Batch Upload**: Upload multiple files simultaneously to JFrog Artifactory
- **Real-time Progress**: Live progress tracking with status updates
- **Connection Testing**: Test connectivity to JFrog Artifactory before uploading
- **Error Handling**: Comprehensive error reporting and handling

### User Interface
- **Modern Dark Theme**: Professional dark UI with cyan/lime color scheme
- **Drag & Drop Title Bar**: Click and drag window by title bar
- **File Management**: 
  - Add multiple files to upload queue
  - Remove individual files by double-clicking
  - Clear all selected files with one click
- **Progress Tracking**: Visual progress bar and detailed status messages
- **Responsive Design**: Clean layout with organized sections

### Configuration
- **Environment Variable Support**: Automatically loads configuration from environment variables
- **Manual Configuration**: Direct input of JFrog settings through GUI
- **Secure Token Handling**: Password field for API token input
- **Flexible Path Management**: Custom target path specification

### Background Processing
- **Asynchronous Uploads**: Non-blocking file uploads using PowerShell runspaces
- **Thread-Safe UI Updates**: Safe UI updates from background threads
- **Upload Status**: Real-time feedback during upload process

## Technologies Used

### Programming Languages & Frameworks
- **PowerShell 5.0+**: Core scripting language and application logic
- **XAML**: User interface markup language
- **WPF (Windows Presentation Foundation)**: GUI framework

### .NET Assemblies
- **PresentationFramework**: WPF core functionality
- **PresentationCore**: WPF presentation services
- **WindowsBase**: Base WPF classes
- **System.Windows.Forms**: File dialog and Windows Forms integration
- **System.Drawing**: Graphics and drawing support

### APIs & Protocols
- **JFrog Artifactory REST API**: File upload and repository management
- **HTTP/HTTPS**: RESTful communication with JFrog server
- **OAuth Bearer Token Authentication**: Secure API authentication

### Windows APIs
- **Kernel32.dll**: Console window management
- **User32.dll**: Window visibility control

## How to Use

### Prerequisites
- Windows operating system
- PowerShell 5.0 or higher
- JFrog Artifactory server access
- Valid JFrog API token

### Environment Variables (Optional)
Set up environment variables for automatic configuration:

```powershell
$env:JFROG_URL = "https://your-artifactory-server.com/artifactory"
$env:JFROG_REPO = "your-repository-name"
$env:JFROG_PATH = "optional/target/path/"
$env:JFROG_TOKEN = "your-api-token"
```

### Running the Application

1. **Launch the Application**
   ```powershell
   .\JFrogUploader.ps1
   ```
   
   **Optional Parameters:**
   - `-ShowConsole`: Display PowerShell console window alongside GUI

2. **Configure JFrog Settings**
   - **Server URL**: Enter your JFrog Artifactory server URL
     - Example: `https://mycompany.jfrog.io/artifactory`
   - **Repository**: Specify the target repository name
   - **Path**: (Optional) Specify target path within repository
   - **API Token**: Enter your JFrog API token

3. **Test Connection** (Recommended)
   - Click the "Test" button to verify connectivity
   - Ensures credentials and server URL are correct

4. **Select Files for Upload**
   - Click "Select" button to open file dialog
   - Choose multiple files using Ctrl+Click or Shift+Click
   - Selected files appear in the list below
   - **Remove files**: Double-click any file in the list to remove it
   - **Clear all**: Click "Clear" button to remove all selected files

5. **Upload Files**
   - Click "Upload" button to start the upload process
   - Monitor progress in the status area
   - Progress bar shows upload activity
   - Detailed messages show current file being uploaded

6. **Upload Results**
   - Success message shows number of files uploaded
   - Error messages detail any failed uploads
   - Partial success shows both successful and failed files

### UI Controls

#### Title Bar
- **JFrog Uploader**: Application title
- **i**: Information button (shows about dialog)
- **Exit**: Close application

#### Configuration Section
- **Server URL**: JFrog Artifactory base URL
- **Repository**: Target repository name
- **Path**: Optional subdirectory path
- **API Token**: Authentication token (hidden input)
- **Test**: Connection verification button

#### File Selection Section
- **Select**: Open file selection dialog
- **Clear**: Remove all selected files
- **Upload**: Start upload process
- **File List**: Shows selected files (double-click to remove)

#### Progress Section
- **Status Text**: Current operation status
- **File Count**: Number of selected files
- **Progress Bar**: Visual upload progress indicator

### Error Handling

The application provides comprehensive error handling for:
- **Connection Issues**: Network connectivity problems
- **Authentication Errors**: Invalid API tokens or permissions
- **File Access Issues**: Locked or missing files
- **Server Errors**: JFrog Artifactory server problems
- **Configuration Errors**: Missing or invalid settings

### Tips for Best Results

1. **Test Connection First**: Always test connectivity before uploading
2. **Use Environment Variables**: Set up environment variables for repeated use
3. **Batch Uploads**: Select multiple files for efficient batch processing
4. **Monitor Progress**: Watch status messages for detailed feedback
5. **Check Results**: Review success/error messages after upload completion

### Troubleshooting

**Connection Test Fails**:
- Verify server URL format and accessibility
- Check API token validity and permissions
- Ensure network connectivity to JFrog server

**Upload Fails**:
- Confirm repository exists and is accessible
- Verify write permissions for API token
- Check file sizes and server limits
- Review target path permissions

**UI Issues**:
- Restart application if UI becomes unresponsive
- Check PowerShell version compatibility
- Ensure .NET Framework is properly installed

## Author

© MeCRO-DEV

## License

This project is licensed under the terms specified in the script header.

## Version

Current Version: 1.0