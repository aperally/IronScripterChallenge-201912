# IronScripter Challenge 12/2019
 https://ironscripter.us/a-powershell-challenge-for-challenges/
 
I have implemented the challenge as a PS module which I named **GetWPStats**
The module exposes the following functions

### Get-wpChlgCatPosts
SYNOPSIS
    Get posts with "Challenge" category from a WordPress site

**SYNTAX**

Get-wpChlgCatPosts `[-WpSite] <String> [[-Latest] <Int32>] [<CommonParameters>]`

**DESCRIPTION**

Display posts for the Challenge category showing when it was posted, the title, the      categories, the tags, excerpt, and link.

**PARAMETERS**

##### WpSite `<String>`
###### URL of the WP site e.g.  https://ironscripter.us<br/>

>*Required: true* |
>*Position: 1* |
>*Default value:* |
>*Accept pipeline input: false* |
>*Accept wildcard characters: false*

##### Latest `<Int32>`
###### Parameter to limit the number of returned posts<br/>

>*Required: false*|
>*Position: 2*|
>*Default value: 0*|
>*Accept pipeline input: false*|
>*Accept wildcard characters: false*


### Get-wpPostsCount
SYNTAX
Get-wpPostsCount `[-WpSite] <String> [-NoFilter] [[-By] <String>] [<CommonParameters>]` <br/>


DESCRIPTION
This is for Ironscripter challenge 12/2019.
The function returns an oject with Category name (or Tag name) and PostCount<br/>


PARAMETERS
##### WpSite `<String>`
###### URL of the WP site e.g.  https://ironscripter.us<br/>
>*Required: true*|
>*Position: 1*|
>*Accept pipeline input: false*|
>*Accept wildcard characters: false*


##### NoFilter `[<SwitchParameter>]`
###### When listing post count by tag there's a default filter to list only "beginner, intermediate, advanced" tags. Use this switch to remove the filter to include all tags

>*Required: false*|
>*Position:1*|
>*Default value: False*|
>*Accept pipeline input: false*|
>*Accept wildcard characters: false*


##### By `<String>`
###### Use this parameter to get post count by Tag or Category, possible values "Tag" or "Category"

>*Required: false*|
>*Position: 2*|
>*Default value: Category*|
>*Accept pipeline input: false*|
>*Accept wildcard characters: false*

---
## Script to get an HTML page with all the "Challenges"

### IronscripterClg2Html.ps1

Just provide the outputfile name if you like

