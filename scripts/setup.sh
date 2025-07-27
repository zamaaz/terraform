#!/bin/bash

# A fully automated script to setup Terraform and AWS CLI with configuration.
# This script will:
# - Auto-install Homebrew on macOS if not present
# - Install Terraform and AWS CLI on all supported platforms
# - Automatically configure AWS credentials by prompting for user input
#
# INSTRUCTIONS:
# 1. Save this file as `setup.sh`.
# 2. On macOS or Linux, make it executable: `chmod +x setup.sh`
# 3. Run it: `./setup.sh`
# 4. For Windows: 
#    - Run this from Git Bash with ADMINISTRATOR PRIVILEGES
#    - Right-click Git Bash → "Run as administrator"
# 5. Have your AWS Access Key ID, Secret Access Key, and preferred region ready.

# --- Configuration ---
TERRAFORM_VERSION="1.12.2" # You can change this to your desired version
OS_TYPE="$(uname -s)"
ARCH="$(uname -m)"

# --- Helper Functions ---
function configure_aws_credentials() {
  echo ""
  echo "--- Configuring AWS Credentials ---"

  # Check if AWS CLI is installed and available
  if ! command -v aws &> /dev/null; then
      echo "AWS CLI command could not be found. Please ensure it was installed correctly."
      exit 1
  fi

  read -p "Enter AWS Access Key ID: " AWS_ACCESS_KEY_ID
  read -sp "Enter AWS Secret Access Key: " AWS_SECRET_ACCESS_KEY
  echo ""
  read -p "Enter Default region name (e.g., us-east-1): " AWS_DEFAULT_REGION

  aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
  aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
  aws configure set region "$AWS_DEFAULT_REGION"
  aws configure set output "json"

  echo ""
  echo "✅ AWS credentials configured successfully!"
  echo "--------------------------------------------------"
}

function configure_aws_credentials_windows() {
  echo ""
  echo "--- Configuring AWS Credentials ---"
  
  # Wait a moment for AWS CLI installation to be fully available
  sleep 3
  
  read -p "Enter AWS Access Key ID: " AWS_ACCESS_KEY_ID
  read -sp "Enter AWS Secret Access Key: " AWS_SECRET_ACCESS_KEY
  echo ""
  read -p "Enter Default region name (e.g., us-east-1): " AWS_DEFAULT_REGION

  # Use PowerShell to configure AWS CLI on Windows
  powershell.exe -Command "& {
    # Refresh environment to get AWS CLI in PATH
    \$env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'User') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'Machine')
    
    # Find AWS CLI (should be in PATH after installation)
    \$awsCmd = Get-Command aws -ErrorAction SilentlyContinue
    
    if (\$awsCmd) {
      Write-Host '🔧 Configuring AWS credentials...'
      & aws configure set aws_access_key_id '$AWS_ACCESS_KEY_ID'
      & aws configure set aws_secret_access_key '$AWS_SECRET_ACCESS_KEY'
      & aws configure set region '$AWS_DEFAULT_REGION'
      & aws configure set output 'json'
      Write-Host '✅ AWS credentials configured successfully!'
    } else {
      Write-Host '❌ AWS CLI not found in PATH. Installation may have failed.'
      Write-Host 'Please try running: aws configure'
      exit 1
    }
  }"

  echo ""
  echo "✅ AWS credentials configured successfully!"
  echo "--------------------------------------------------"
}

function check_windows_admin() {
  # Check if running with elevated permissions on Windows
  local is_admin=$(powershell.exe -Command "& {
    \$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    \$currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
  }" 2>/dev/null)
  
  if [[ "$is_admin" != "True" ]]; then
    echo "❌ ERROR: This script requires administrator privileges on Windows."
    echo ""
    echo "Please run this script as Administrator:"
    echo "1. Right-click on Git Bash (or your terminal)"
    echo "2. Select 'Run as administrator'"
    echo "3. Navigate to this directory and run the script again"
    echo ""
    echo "Administrator privileges are required to:"
    echo "- Install software to Program Files directory"
    echo "- Modify system PATH environment variables"
    echo "- Install MSI packages system-wide"
    exit 1
  fi
  
  echo "✅ Administrator privileges confirmed."
}


# --- Main Logic ---

echo "--- Checking Operating System ---"

# --- macOS Setup ---
if [[ "$OS_TYPE" == "Darwin" ]]; then
  echo "Detected macOS."

  # Auto-install Homebrew if not present
  if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing Homebrew automatically..."
    echo "--- Installing Homebrew ---"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for current session
    if [[ "$ARCH" == "arm64" ]]; then
      export PATH="/opt/homebrew/bin:$PATH"
    else
      export PATH="/usr/local/bin:$PATH"
    fi
    
    # Verify installation
    if ! command -v brew &> /dev/null; then
      echo "❌ Failed to install Homebrew. Please install it manually from https://brew.sh/"
      exit 1
    fi
    echo "✅ Homebrew installed successfully!"
  else
    echo "✅ Homebrew is already installed."
  fi

  echo "--- Installing Terraform and AWS CLI using Homebrew ---"
  brew install terraform
  brew install awscli

  configure_aws_credentials

# --- Linux Setup ---
elif [[ "$OS_TYPE" == "Linux" ]]; then
  echo "Detected Linux."
  
  # Check for required tools
  if ! command -v wget &> /dev/null || ! command -v unzip &> /dev/null; then
    echo "wget and unzip are required. Please install them using your package manager (e.g., sudo apt-get install wget unzip)"
    exit 1
  fi

  # Create a temporary directory for downloads
  TEMP_DIR=$(mktemp -d)
  cd "$TEMP_DIR"

  echo "--- Downloading and installing Terraform ---"
  if [[ "$ARCH" == "x86_64" ]]; then TF_ARCH="amd64"; else TF_ARCH="arm64"; fi
  wget -q "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${TF_ARCH}.zip"
  unzip -o "terraform_${TERRAFORM_VERSION}_linux_${TF_ARCH}.zip"
  sudo mv terraform /usr/local/bin/
  
  echo "--- Downloading and installing AWS CLI ---"
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip -o awscliv2.zip
  sudo ./aws/install --update
  
  # Cleanup
  cd ~
  rm -rf "$TEMP_DIR"

  configure_aws_credentials

# --- Windows Setup ---
elif [[ "$OS_TYPE" == *"MINGW"* || "$OS_TYPE" == *"CYGWIN"* ]]; then
  echo "Detected Windows."
  
  # Check for administrator privileges
  check_windows_admin
  
  echo "--- Installing Terraform and AWS CLI with elevated permissions ---"
  
  # Install both Terraform and AWS CLI using PowerShell with proper error handling
  powershell.exe -Command "& {
    \$ErrorActionPreference = 'Stop'
    
    try {
      # Create Program Files directories
      \$tfInstallPath = 'C:\\Program Files\\Terraform'
      if (!(Test-Path \$tfInstallPath)) {
        New-Item -ItemType Directory -Path \$tfInstallPath -Force | Out-Null
        Write-Host '📁 Created Terraform directory'
      }
      
      # Download and install Terraform
      Write-Host '📥 Downloading Terraform ${TERRAFORM_VERSION}...'
      \$tfUrl = 'https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_windows_amd64.zip'
      \$tfZipPath = Join-Path -Path \$env:TEMP -ChildPath 'terraform.zip'
      
      Invoke-WebRequest -Uri \$tfUrl -OutFile \$tfZipPath -UseBasicParsing
      Write-Host '📦 Extracting Terraform...'
      Expand-Archive -Path \$tfZipPath -DestinationPath \$tfInstallPath -Force
      
      # Add Terraform to system PATH (requires admin)
      \$systemPath = [System.Environment]::GetEnvironmentVariable('Path', 'Machine')
      if (!(\$systemPath -like '*C:\\Program Files\\Terraform*')) {
        [System.Environment]::SetEnvironmentVariable('Path', \$systemPath + ';C:\\Program Files\\Terraform', 'Machine')
        Write-Host '🔧 Added Terraform to system PATH'
      }
      
      # Clean up
      Remove-Item \$tfZipPath -Force -ErrorAction SilentlyContinue
      Write-Host '✅ Terraform installed successfully!'
      
      # Download and install AWS CLI
      Write-Host '📥 Downloading AWS CLI...'
      \$awsMsiUrl = 'https://awscli.amazonaws.com/AWSCLIV2.msi'
      \$awsMsiPath = Join-Path -Path \$env:TEMP -ChildPath 'AWSCLIV2.msi'
      
      Invoke-WebRequest -Uri \$awsMsiUrl -OutFile \$awsMsiPath -UseBasicParsing
      Write-Host '📦 Installing AWS CLI...'
      
      # Install MSI with elevated permissions
      \$process = Start-Process -FilePath 'msiexec.exe' -ArgumentList '/i', \$awsMsiPath, '/quiet', '/norestart' -Wait -PassThru
      
      if (\$process.ExitCode -eq 0) {
        Write-Host '✅ AWS CLI installed successfully!'
      } else {
        throw \"AWS CLI installation failed with exit code: \$(\$process.ExitCode)\"
      }
      
      # Clean up
      Remove-Item \$awsMsiPath -Force -ErrorAction SilentlyContinue
      
      # Refresh environment variables
      \$env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'User') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'Machine')
      
    } catch {
      Write-Host \"❌ Installation failed: \$(\$_.Exception.Message)\" -ForegroundColor Red
      exit 1
    }
  }"

  # Configure AWS credentials automatically
  configure_aws_credentials_windows


else
  echo "Unsupported OS: $OS_TYPE"
  exit 1
fi

echo ""
echo "🎉 Setup completed successfully!"
echo "=============================================="
echo "✅ Terraform installed and ready to use"
echo "✅ AWS CLI installed and configured"
echo ""
if [[ "$OS_TYPE" == *"MINGW"* || "$OS_TYPE" == *"CYGWIN"* ]]; then
  echo "Note: You may need to open a new terminal to use the tools"
  echo "due to PATH changes requiring environment refresh."
  echo ""
fi
echo "You can now start using Terraform with AWS!"
echo "Try running: terraform --version"
echo "And: aws sts get-caller-identity"
echo "=============================================="
