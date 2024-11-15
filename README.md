# Active Directory Computer Logon Report Script

This PowerShell script retrieves information about computers in Active Directory (AD) and displays the last logon date for each computer. It allows filtering by Organizational Units (OUs) or containers and sorts the results by the most recent logon date. The script is designed to help administrators track inactive or unused computers in their AD environment.

---

## Features

- Retrieve computer objects and their last logon date from Active Directory.
- Optionally filter by a specific OU or container.
- Automatically sort results by the most recent logon date.
- Export the results to a CSV file for further analysis.
- Supports both OUs (`OU=...`) and default containers like `Computers` (`CN=...`).

---

## Prerequisites

1. **PowerShell Version**: Ensure that you have PowerShell 5.1 or later installed.
2. **Active Directory Module**: The `ActiveDirectory` PowerShell module must be installed. This is typically available on domain-joined machines or can be installed as part of the RSAT tools.
3. **AD Permissions**: The user running the script must have permissions to query Active Directory objects.
4. **Network Connectivity**: The script must be able to connect to an Active Directory server or domain controller.

---

## How to Use

### 1. Clone or Download the Script

Save the script file to your local machine as `ADComputerLogonReport.ps1`.

### 2. Run the Script

Run the script in PowerShell. Navigate to the directory containing the script and execute:

.\ADComputerLogonReport.ps1

### 3. Follow the Prompts

Enter the FQDN or server name: Provide the name or FQDN of your Active Directory server (e.g., DC01 or dc01.contoso.com).

Filter by OU or container:

If you want to focus on a specific part of AD, you can filter by an Organizational Unit (OU) or container. Enter the name when prompted.

Example for an OU: Contoso Computers

Example for a container: Computers

Export to CSV: Optionally, export the results to a CSV file by providing the desired file path (e.g., C:\Temp\ADComputers.csv).