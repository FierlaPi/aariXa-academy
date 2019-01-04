# ![logo][] Introduction to Powershell

[logo]: https://raw.githubusercontent.com/PowerShell/PowerShell/master/assets/ps_black_64.svg?sanitize=true

## Setup

For this presentation a setup is needed.

### Editors

Windows Powershell 5.1 is used on a Windows 10 machine. Visual Studio Code was also used and can be found at [Microsoft Visual Studio](https://code.visualstudio.com)

### Virtual machines

If you want to replicate the presentatin the following at hand beside your own device:

| Type                | Purpose                                                                  | Remark                        |
|---------------------|--------------------------------------------------------------------------|-------------------------------|
| Ubuntu server       | Powershell core on Linux                                                 | 18.04 is supported on Hyper-V |
| Windows Server 2016 | Windows Powershell Host<br>Domain controller<br>DNS server<br>JEA source |                               |
| Windows 10          | Windows Powershell client<br>JEA client                                  |                               |

All these virtual machines should be connected on one network in the same VLAN in the s

### Assets

You will also need a CSV file called **NewUser.csv** with users with following structure:

| Firstname | Lastname  | Phone        | Title               | Department     |
|-----------|-----------|--------------|---------------------|----------------|
| Quinton   | Salas     | +32477123456 | System Engineer     | Infrastructure |
| Arthur    | Bates     | +32477123456 | Network Engineer    | Infrastructure |
| Noelle    | Castaneda | +32477123456 | System Operator     | Infrastructure |
| Parker    | Krueger   | +32477123456 | Scum master         | Development    |
| Javion    | Pace      | +32477123456 | Product owner       | Development    |
| Talia     | Bradley   | +32477123456 | Team member         | Development    |
| Meredith  | Page      | +32477123456 | Sales representatif | Sales          |
| Winston   | Blake     | +32477123456 | Contract manager    | Sales          |
| Cali      | Calderon  | +32477123456 | Client prospector   | Sales          |
| Trevor    | Clements  | +32477123456 | CEO                 | Managment      |
| Cayden    | Randall   | +32477123456 | TEO                 | Managment      |
| London    | Freeman   | +32477123456 | DPO                 | Managment      |

``` note
For the Department can only have these exact values:

Managment
Sales
Development
Infrastructure

These values are looked up to set the users in groups

```

## Content

All the OS subfolders also contain a **Academy_CheatSheet.ps1**. This is a file containing commmands that help in the presentation and prevent the different typo's that ruins demo's. I provide them *AS IS*. It can help to figure out the scenario's and setups.

Little note, these CheatSheets are not created to run directly. If you try it anyway you get a message and exit the script.

| File                                          | FileType   | Description       |
|-----------------------------------------------|------------|-------------------|
| [Academy](201811%20-%20aariXa%20academy.pptx) | Powerpoint | Presentation file |
| [Workstation](Workstation)| Folder | Resources for the workstation where there is Powershell 5.1, Visual Studio Code<br>This folder also contain a Academy_CheatSheet.ps1. This contain some commands that starts everything. Will