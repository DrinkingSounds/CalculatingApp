[Reflection.Assembly]::LoadWithPartialName('System.Drawing') | Out-Null

function Make-Icon {
    param(
        [int]$Size
    )
    $bmp = New-Object System.Drawing.Bitmap $Size, $Size
    for ($y = 0; $y -lt $Size; $y++) {
        $t = $y / [double]($Size - 1)
        $r = [int](75 * (1 - $t) + 24 * $t)
        $g = [int](108 * (1 - $t) + 40 * $t)
        $b = [int](183 * (1 - $t) + 72 * $t)
        for ($x = 0; $x -lt $Size; $x++) {
            $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($r, $g, $b))
        }
    }
    $graphics = [System.Drawing.Graphics]::FromImage($bmp)
    $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
    $fontSize = [int]($Size * 0.25)
    $font = New-Object System.Drawing.Font 'Arial', $fontSize, ([System.Drawing.FontStyle]::Bold)
    $brush = [System.Drawing.Brushes]::White
    $graphics.DrawString('+', $font, $brush, $Size * 0.15, $Size * 0.2)
    $graphics.DrawString('-', $font, $brush, $Size * 0.55, $Size * 0.2)
    $graphics.DrawString('*', $font, $brush, $Size * 0.35, $Size * 0.6)
    if (-not (Test-Path "icons")) { New-Item -ItemType Directory -Path "icons" | Out-Null }
    $bmp.Save("icons/icon-$Size.png", [System.Drawing.Imaging.ImageFormat]::Png)
    $graphics.Dispose()
    $bmp.Dispose()
}

Make-Icon -Size 192
Make-Icon -Size 512
Write-Output "Generated icons/icon-192.png and icons/icon-512.png"

