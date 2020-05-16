"Convert LastLogonTimestamp":{
    "prefix": "LastLogonTimestamp",
    "body": [
        "$hash_lastLogonTimestamp = @{Name='LastLogonTimeStamp';Expression={([datetime]::FromFileTime($$_.LastLogonTimeStamp))}}"],
    "description": "Convert Active Directory property LastLogonTimestamp"
},

"Convert pwdLastSet":{
    "prefix": "pwdLastSet",
    "body": [
        "$hash_pwdLastSet = @{Name='pwdLastSet';Expression={([datetime]::FromFileTime($$_.pwdLastSet))}}"],
    "description": "Convert Active Directory property pwdLastSet"
