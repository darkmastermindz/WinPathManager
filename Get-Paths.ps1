# Get Paths Script

# Declare Class
class SoftPath {
		[string] $RawPath
		[string] $SoftName
		[bool] $HasBin
		[string] $Version
		[bool] $HasVersion
}

# Get the Path (Str)
Function Get-Path {
	Param(
		[Parameter(Mandatory=$True,Position=1)][string]$Path
	)
		
	return (Get-ItemProperty -path $Path).Path
}

# Get Parsed Path
Function Get-ParsedPath {
	Param(
		[Parameter(Mandatory=$True,Position=1)][string]$Path
	)
	
	$num = 0
	$Return = @{}
	$Raw = Get-Path($Path)
	$RawArr = $Raw.Split(';')
	
	foreach ($item in $RawMacArr){
		$temp = New-Object SoftPath
		$temp.RawPath = $item
		$temp.SoftName = $item.Split('\')[2] + ", " + $item.Split('\')[3]
		$temp.HasBin = $item.toLower().Contains("bin")
		$temp.Version = [regex]::Match($item, '\d+.*.\d+').Value
		$temp.HasVersion = [regex]::Match($item, '\d+.*.\d+').Success
		
		$Return.add($num, $temp)
		$num++
	}
	
	return $Return
}

# Commit New Path
Function Commit-Path{
	
	Param(
		[Parameter(Mandatory=$True,Position=1)][string]$PathStr,
		[Parameter(Mandatory=$True,Position=2)][SoftPath]$PathClass,
		[Parameter(Mandatory=$True,Position=3)][bool]$isStr,
		[Parameter(Mandatory=$True,Position=4)][string]$PathDest
	)
	
	$newPath = [string]::Empty
	if ($isStr -eq $False){
		
		# Iterate and Form 
		foreach ($item in $PathClass.Values){
			
			if ($newPath.length -eq 0){
				$newPath += $item.RawPath
			} else {
				$newPath = $newPath + ";" + $item.RawPath
			}
		}
		
	} 
	else {
		$newPath = $PathStr
	}
	
	# Commit to Path
	Set-ItemProperty -Path $PathDest -Name Path -Value $newPath
	$check = (Get-ItemProperty -path $PathDest).Path
	
	# Check for new Commit
	if ($newPath -eq $check){
		Write-host "New Path successfully Written!"
	}
}

# Path to Vars
Function Interp-Path-To-Vars {
	Param(
		[Parameter(Mandatory=$True,Position=1)][string]$Path
	)
	
	$CurrentPath = Get-ParsedPath($Path)
	
	
	
}

$Machine = Get-Paths 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment'
$User = Get-Paths 'HKCU:\Environment'
