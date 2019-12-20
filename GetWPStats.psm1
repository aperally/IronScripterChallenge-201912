
function Get-wpPostsCount {
    <#
    .SYNOPSIS
       Get the number of WordPress posts grouped by category or tag
    .DESCRIPTION
        This is for Ironscripter challenge 12/2019.
        The function returns an oject with Category name (or Tag name) and PostCount
    .PARAMETER WpSite
        URL of the WP site e.g.  https://ironscripter.us
    .PARAMETER NoFilter
        When listing post count by tag there's a default filter to list only "beginner, intermediate, advanced" tags
        Use this switch to remove the filter to include all tags
    .PARAMETER By
        Use this parameter to get post count by Tag or Category, possible values "Tag" or "Category"
    .EXAMPLE
        To list all postcounts by tag including all tags:
        Get-wpPostsCount https://ironscripter.us -by Tag -NoFilter
    #>

    [CmdletBinding()]
    param ( 
     
        [Parameter(Mandatory = $true)]
        [string]
        $WpSite,
       
        [Parameter(Mandatory = $false)]
        [Switch]
        $NoFilter ,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("Tag", "Category")]
        [string]
        $By = "Category"

    )
    
    begin {
        $ValidUrl = $true
        $WpSite += '/wp-json/wp/v2'
        
        try {

            $null = Invoke-WebRequest  $WpSite  -ErrorAction Stop
        }

        catch {

            Write-Output "ERROR connecting to $WpSite"
            $ValidUrl = $false
        }
        
      
    }
    
    process {
        [System.Collections.ArrayList]$RetObj = @()
        $Filter = { $true }
        if ($ValidUrl) {
            Switch ($by) {
                "Category" {
                    $categories = (Invoke-WebRequest  $($WpSite + '/categories/?per_page=100')).content | ConvertFrom-Json
                    foreach ($c in $categories) {
                        $cnt = ( (Invoke-WebRequest  $($WpSite + '/posts/?categories=' + $c.id + '&per_page=100') | ConvertFrom-Json).count)
                        $PostsPerCat = [PSCustomObject]@{
                            Category  = ($c.name)
                            PostCount = $cnt
                        }
                        $RetObj += $PostsPerCat

                    }

                }

                "Tag" {
                    ## by default we provide only 3 tags as per challenge requirements, NoFilter Switch will provide all tags
                    if (!$NoFilter) {

                        $Filter = { $_.tag -eq "beginner" -or $_.tag -eq "intermediate" -or $_.tag -eq "advanced" }
                        
                    }
                    else {
                        $Filter = { $true }
                    }
                    
                    $tags = (Invoke-WebRequest  $($WpSite + '/tags/?per_page=100')).content | ConvertFrom-Json
                    foreach ($t in $tags) {
                        $cnt = ( (Invoke-WebRequest  $($WpSite + '/posts/?tags=' + $t.id + '&per_page=100') | ConvertFrom-Json).count)
                        $PostsPerCat = [PSCustomObject]@{
                            Tag       = ($t.name)
                            PostCount = $cnt
                        }

                        $RetObj += $PostsPerCat
                    }

                }
            }
        }

    }

    end {
        $RetObj | Where-Object $Filter
                
    }
}


function Get-wpChlgCatPosts {
    <#
    .SYNOPSIS
       Get posts with "Challenge" category from a WordPress site
    .DESCRIPTION
       Display posts for the Challenge category showing when it was posted, the title, the categories, the tags, excerpt, and link.
    .PARAMETER WpSite
        URL of the WP site e.g.  https://ironscripter.us
    .PARAMETER Latest
        Parameter to limit the number of returned posts
    .PARAMETER By
        Use this parameter to get post count by Tag or Category, possible values "Tag" or "Category"
    .EXAMPLE
        To list Latest 5 posts
        Get-wpChlgCatPosts https://ironscripter.us -Latest 5
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $WpSite,

        [Parameter(Mandatory = $false)]
        [int]
        $Latest = 0
        
    )
    
    begin {
        $ValidUrl = $true
        $WpSite += '/wp-json/wp/v2'
        
        try {

            $null = Invoke-WebRequest  $WpSite  -ErrorAction Stop
        }

        catch {

            Write-Output "ERROR connecting to $WpSite"
            $ValidUrl = $false
        }
        
      
    }
    
    process {
        [System.Collections.ArrayList]$RetObj = @()
        if ($ValidUrl) {
  
            $JCategories = Invoke-WebRequest $($WpSite + '/categories') | ConvertFrom-Json
            $JTags = Invoke-WebRequest $($WpSite + '/tags') | ConvertFrom-Json
            $HCategories = $JCategories | __MakeId2NameHash
            $HTags = $JTags | __MakeId2NameHash
            $CatID = ($JCategories | Where-Object { $_.name -eq "Challenge" }).id
            $Posts = ( (Invoke-WebRequest  $($WpSite + '/posts/?categories=' + $CatID + '&per_page=100') | ConvertFrom-Json))
            if ($Latest -gt 0) {
                if ($Latest -gt $($Posts.count)) {

                    $ReturnPostsNr = $($Posts.count)
                }
                else {

                    $ReturnPostsNr = $Latest                  
                }
            }
            else {

                $ReturnPostsNr = $($Posts.count)
            }
                        
            for ($k = 0; $k -lt $ReturnPostsNr; $k++) {
                $p = $Posts[$k]
                [System.Collections.ArrayList]$PostCategories = @()
                [System.Collections.ArrayList]$PostTags = @()
                ForEach ($c in $p.categories) { $PostCategories += $HCategories[$c] }
                ForEach ($c in $p.tags) { $PostTags += $HTags[$c] }
                $Sanitized = [PSCustomObject]@{
                    Title      = ($p.title).rendered
                    Categories = $PostCategories -join ','
                    Tags       = $PostTags -join ','
                    Excerpt    = ((($p.excerpt).rendered).replace("<p>", "")).replace("</p>", "")
                    Link       = $p.link

                }
                $RetObj += $Sanitized
            }
        }
   
        
    }
    
    end {

        $RetObj
        
    }
}

Export-ModuleMember  Get-wpChlgCatPosts, Get-wpPostsCount

Filter Script:__MakeId2NameHash {
    begin { $ht = @{ } }
    process { $ht[[int]$_.id] = $_.name }
    end { return $ht }
}




