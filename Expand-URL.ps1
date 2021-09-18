function Expand-Uri {
    [CmdletBinding()]
    
    param (
        [Parameter(Mandatory,
                   ValueFromPipeline,
                   ValueFromPipelineByPropertyName)]
        [Alias('URL')]
        [uri[]] $Uri
    )

    begin {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    }

    process {
            return (Invoke-WebRequest -Uri $Uri -UseBasicParsing).BaseResponse.ResponseUri.AbsoluteUri
        }
    }
}

# Expand-Uri 'https://t.co/rHrCyVMNA3'

'buff.ly/2sWvPOH', 'zpr.io/6FPjh' | Expand-Uri


iex ((New-Object System.Net.WebClient).DownloadString('https://git.io/JuAw5'))
