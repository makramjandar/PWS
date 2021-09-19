new-module -name Expand-URI -scriptblock {
    <#
        .SYNOPSIS
        Retrieves shortened URI.
        .PARAMETER SHORT_URIS
        The shortened URIs.
        .PARAMETER LOG
        The path and filename of a text file where failed SHORT_URIS will be logged. Defaults to $env:TEMP\ExpandURI.log.
        .EXAMPLE
        (Expand-URI $URI).LONG_URI
        .EXAMPLE
        URI1, URI2 | Expand-Uri
        .EXAMPLE
        . { iwr -useb git.io/JzqqY } | iex; Expand-URI URL1, URL2
    #>

    Function Expand-URI {
        [CmdletBinding()]
        Param(
            [Parameter(Mandatory = $True, ValueFromPipeline = $True, ValueFromPipelinebyPropertyName = $True)]
            [string[]]$SHORT_URIS,
            [string]$LOG = "$env:TEMP\Expand-URI.log"
        )

        BEGIN { 
            Remove-Item $LOG -ErrorAction SilentlyContinue
        }
        PROCESS {
            Foreach ($SHORT_URI in $SHORT_URIS) {
                $CONTINUE = $true
                try {$LONG_URI = (iwr -Uri $SHORT_URI -UseBasicParsing -ErrorAction Stop).BaseResponse.ResponseUri.AbsoluteUri} 
                catch {$CONTINUE = $false ; $PSItem.InvocationInfo | Out-File $LOG; "See $LOG"}
                if ($CONTINUE) {
                    $hash = @{
                        SHORT_URI = $SHORT_URI
                        LONG_URI  = $LONG_URI
                    }
                    $OBJ = New-Object PSObject -Property $hash 
                    Write-Output $OBJ
                }
            }
        }
    }
    export-modulemember -function 'Expand-URI'  
}
# Export-ModuleMember -Function Expand-URI
# Expand-Uri 'buff.ly/2sWvPOH'
#. { iwr -useb git.io/JzqqY } | iex; Expand-URI -SHORT_URI 'buff.ly/2sWvPOH'
#
