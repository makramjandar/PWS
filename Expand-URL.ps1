function Expand-Uri($Uri)
{
    begin {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    }
    process {
        try {return (Invoke-WebRequest -Uri $Uri -UseBasicParsing).BaseResponse.ResponseUri.AbsoluteUri}}
        catch {"Ran into an issue: $PSItem"}
    }
}

# Expand-Uri https://t.co/rHrCyVMNA3
# buff.ly/2sWvPOH | Expand-Uri
# iex ((New-Object System.Net.WebClient).DownloadString('git.io/JzqqY'))
