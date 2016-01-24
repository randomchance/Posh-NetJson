

Function New-NetCollection {
    param(
        [Parameter(HelpMessage="")]
        [object[]] $collection = @()
    )

    [pscustomobject]@{
        type = "NetworkCollection"
        collection = $collection
    }
}
Export-ModuleMember -Function New-NetCollection

Function New-NetGraph {
    param(
        [Parameter(
            ParameterSetName="static",
            HelpMessage="Create a netgraph with static routes."
            )]
        [switch]$Static,
        
        [parameter(
            ParameterSetName="notstatic",
            mandatory = $true,
            HelpMessage="Name of the routing protocol, may be 'static' when representing static routes."
            )]
        [string]$protocol,
        
        [parameter(
            ParameterSetName="notstatic",
            mandatory = $true,
            HelpMessage="version of the routing protocol, may be null when representing static routes"
            )]
        [string]$version,
        
        [Parameter(
            ParameterSetName="notstatic",
            mandatory = $true,
            HelpMessage="Name of main routing metric used by the routing protocol to determine the best routes when sending packets, may be null when representing static routes"
            )]
        [string]$metric,
        
        [Parameter(
            HelpMessage="array of Node Objects [node-objects]"
            )]
        [object[]]$nodes = @(),
        
        [Parameter(
            HelpMessage="array of Link Objects [link-objects]"
            )]
        [object[]]$links = @(),
        
        [Parameter(
            HelpMessage="string indicating the revision from which the routing protocol binary was built (eg: git hash, svn revision)"
            )]
        [string]$revision = "",
        
        [Parameter(
            HelpMessage="arbitrary identifier of the topology"
        )]
        [string]$topology_id = "",
        
        [Parameter(
            HelpMessage="arbitrary identifier of the router on which the protocol is running (eg: ip, mac, hash)"
            )]
        [string]$router_id = "",
        
        [Parameter(
            HelpMessage="a human readable label for the topology"
        )]
        [string]$label = ""
        
    )
    
    if($Static)
    {
        $protocol = 'static'
        $version = $null
        $metric = $null
    }

    [pscustomobject]@{
        type="NetworkGraph"
        version = $version
        metric = $metric
        nodes = $nodes
        links = $links
        revision = $revision
        topology_id = $topology_id
        router_id = $router_id
        label = $label
    }
}

Export-ModuleMember -Function New-NetGraph

Function New-NetGraphNode {
    param(
        [parameter(
            mandatory = $true,
            HelpMessage="arbitrary identifier of the node, eg: ipv4, ipv6, mac address, hash, ecc."
            )]
        [string]$ID,
        
        [Parameter(HelpMessage="human readable label of the node")]
        [string]$Label="",
        
        [Parameter(
            HelpMessage="array of strings representing additional addresses (mac/ip) which can be used to communicate with the node"
            )]
        [string[]]$LocalAddresses = @(),
        
        [Parameter(
            HelpMessage="hashtable which MAY contain any arbitrary member; These aribtrary members SHOULD be visualized by user interface softwar"
        )]
        $Properties = @{}
    )

    [pscustomobject]@{
        id = $ID
        label = $Label
        local_addresses = $LocalAddresses
        properties = $Properties
    }
}
Export-ModuleMember -Function New-NetGraphNode


Function New-NetGraphLink {
    param(
        [parameter(
            mandatory = $true,
            HelpMessage="id of the source node"
        )]
        [string]$Source,
        
        [parameter(
            mandatory = $true,
            HelpMessage="id of the target node"
        )]
        [string]$Target,
        
        [parameter(
            mandatory = $true,
            HelpMessage="value of the routing metric indicating the outgoing cost to reach the destination; lower cost is better, it MAY be omitted when representing static routes; Infinity and NaN are not allowed in accordance with the JSON RFC [RFC7159]"
        )]
        [double]$Cost,
        
        [Parameter(HelpMessage="human readable representation of the cost member")]
        [string]$CostText="",
        
        [Parameter(HelpMessage="hashtable which MAY contain any arbitrary member; These aribtrary members SHOULD be visualized by user interface software")]
        $Properties = @{}
    )

    [pscustomobject]@{
        source = $Source
        target = $Target
        cost = $Cost
        cost_text = $CostText
        properties = $Properties
    }
}
Export-ModuleMember -Function  New-NetGraphLink

