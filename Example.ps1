$graph = New-NetGraph -Static -label "My Network"

$graph.nodes += New-NetGraphNode -ID 'router1' -Label "Router" -LocalAddresses @('10.10.10.1','10.10.11.1') -Properties @{gateway = $true}

(20 .. 30) |% {

$graph.nodes += New-NetGraphNode -ID "switch$_" -Label "Switch $_"  -LocalAddresses @("10.10.10.$_")
$graph.links += New-NetGraphLink -Source "switch$_" -Target 'router1' -Cost 1 -Properties @{type = 'fiber'}
}


# Generate a bunch of servers
$switches = $graph.nodes | ? id -Like "switch*" | select -ExpandProperty id

(100 .. 180) |% {

$graph.nodes += New-NetGraphNode -ID "10.10.10.$_" -Label "Server $_" -Properties @{type = 'Server'}
$graph.links += New-NetGraphLink -Source "10.10.10.$_" -Target ($switches | Get-Random ) -Cost 1.5 -Properties @{type = 'ethernet'}
}

$graph | ConvertTo-Json -depth 5| Out-File -FilePath "test.json"