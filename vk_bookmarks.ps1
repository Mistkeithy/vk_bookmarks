param (
    [int]$startFrom = 0,
    [int]$getCount = 100,
    [string]$savePath = "",
	[string]$urlWithToken = 'https://oauth.vk.com/blank.html#access_token=123'
)

if (-not $PSBoundParameters.ContainsKey("startFrom")) {
    $startFrom = Read-Host "Start from"
}
if (-not $PSBoundParameters.ContainsKey("getCount")) {
    $getCount = Read-Host "Get count"
}

$accessToken = ($urlWithToken -split '=|&')[1]

chcp 65001 | Out-Null
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Download-Images($offset, $count) {
    $url = "https://api.vk.com/method/fave.get?access_token=$accessToken&v=5.131&item_type=post&offset=$offset&count=$count&extended=1"
    $response = Invoke-RestMethod -Uri $url -Method Get

    if ($response.error) {
        Write-Host "Error: $($response.error.error_msg)"
    } else {
        $dateFolder = Get-Date -Format "MMyy"
        if ($savePath -eq "") {
            $outputFolder = Join-Path -Path $PSScriptRoot -ChildPath $dateFolder
        } else {
            $outputFolder = Join-Path -Path $savePath -ChildPath $dateFolder
        }
        
        if (-not (Test-Path $outputFolder -PathType Container)) {
            New-Item -ItemType Directory -Path $outputFolder
        }

        [int]$imageCnt = 0
        foreach ($post in $response.response.items.post) {
            foreach ($attachment in $post.attachments) {
                if ($attachment.type -eq "photo") {
                    foreach ($photo in $attachment.photo.sizes) {
                        if ($photo.type -eq "w") {
                            $retryCount = 0
                            while ($true) {
                                try {
                                    Start-Sleep -Seconds 0.5
                                    $photoUrl = $photo.url
                                    $photoFileName = "$($post.id)_$($post.owner_id)_$($attachment.photo.id)_$($attachment.photo.date).jpg"
                                    $outputPath = Join-Path -Path $outputFolder -ChildPath $photoFileName
                                    Invoke-WebRequest -Uri $photoUrl -OutFile $outputPath -TimeoutSec 20
                                    $imageCnt++
                                    Write-Host "$($imageCnt): $outputPath"
                                    break
                                } catch {
                                    $retryCount++
                                    if ($retryCount -ge 20) {
                                        Write-Host "Failed to download after 20 attempts: $photoUrl"
                                        break
                                    }
                                    Start-Sleep -Seconds 1
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

$currentOffset = $startFrom
$remainingCount = $getCount

while ($remainingCount -gt 0) {
    $currentCount = [Math]::Min($remainingCount, 100)
    Download-Images -offset $currentOffset -count $currentCount
    $currentOffset += $currentCount
    $remainingCount -= $currentCount
}
