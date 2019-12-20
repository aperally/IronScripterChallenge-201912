Param(
	[string]$htmlfile
)
if ([string]::IsNullOrEmpty($htmlfile)) {

	$htmlfile = "IronScripterChallenge-" + $(Get-Date -Format yyyyMMdd-hhmmss) + ".html"
}
if (Test-Path $htmlfile) { $null = Remove-Item $htmlfile -force }
Import-Module .\GetWPStats.psm1
$head = @"
	<html>
		<style type="text/css">
			.tftable {font-size:14px;color:#333333;width:60%;max-width:800px;border-width: 1px;
					  border-color: #ebab3a;border-collapse: collapse;
					  margin-left:auto;margin-right:auto;}
			.tftable th {font-size:24px;background-color:#ff9900;
						 font-family: Arial, Helvetica, sans-serif;
						 border-width: 1px;padding: 8px;border-style: solid;
						 border-color: #ebab3a;text-align:center;}
			.tftable {background-color:#ffebcc;}
			.tftable td {font-family: Arial, Helvetica, sans-serif;
						 font-size:14px;border-width: 1px;padding: 8px;
						 border-style: solid;border-color: #ebab3a;}
			.tftable tr:hover {background-color:#ffffff;}
			.tftable a {text-decoration: none;font-family: Arial, Helvetica, sans-serif;font-weight:bold;}
			.tftable a:link { color:#008000;}
			.tftable a:visited { color:#00b300;}
		</style>
		<body style="background-color:#e6e6ff">
			<table class="tftable" border="1">
			<tr><th>IronScripter Challenge December 2019 </th></tr>
"@


$htmltail = @"
		</table>
	</body>
</html>
"@


Add-Content -Path $htmlfile -value $head
$Data = Get-wpChlgCatPosts  https://ironscripter.us
foreach ($d in $Data) {
	$row = "<tr><td> <a href=" + $d.link + ">" + $D.title + "</a></td></tr>" 
	Add-Content -Path $htmlfile -Value $row
}

Add-Content -Path $htmlfile -Value $htmltail
Write-Host "`n`n`nHtml file is " -ForegroundColor Green -NoNewline -BackgroundColor Black
Write-Host "$htmlfile `n`n`n" -ForegroundColor Cyan -BackgroundColor Black

Invoke-Item $htmlfile




