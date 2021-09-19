new-module -name Expand-Uri -scriptblock {
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
        . { iwr -useb git.io/JzqqY } | iex; Expand-URI URL1 URL2
    #>

    Function Expand-URI {
        [CmdletBinding()]
        Param(
            [Parameter(Mandatory = $True, ValueFromPipeline = $True, ValueFromPipelinebyPropertyName = $True)]
            [string[]]$SHORT_URIS,
            [string]$LOG = "$env:TEMP\ExpandURI.log"
        )

        BEGIN { Remove-Item $LOG –erroraction silentlyCONTINUE }
        PROCESS {
            Foreach ($SHORT_URI in $SHORT_URIS) {
                $CONTINUE = $true
                try {
                    $LONG_URI = (iwr -Uri $SHORT_URI -UseBasicParsing).BaseResponse.ResponseUri.AbsoluteUri
                } 
                catch { $CONTINUE = $false ; $PSItem.InvocationInfo | Format-List * | Out-File $LOG }
                if ($CONTINUE) {
                    $OBJ = New-Object –typename PSObject
                    $OBJ `
                    | Add-Member –membertype NoteProperty –name SHORT_URI –value $SHORT_URI –passthru `
                    | Add-Member –membertype NoteProperty –name LONG_URI –value $LONG_URI
                    Write-Output $OBJ
                }
            }
        }
    }
    export-modulemember -function 'Expand-URI'  
}
#Export-ModuleMember -Function Expand-URI
#Expand-Uri 'buff.ly/2sWvPOH'
#. { iwr -useb git.io/JzqqY } | iex; Expand-URI -SHORT_URI 'buff.ly/2sWvPOH'
