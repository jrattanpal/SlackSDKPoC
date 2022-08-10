# Slack SDK Pilot


Salesforce Slack SDK for AppExchange Partners: https://salesforce.vidyard.com/watch/MJMJqu2x3PuLVdWoVzke2r?

(Demo with Technical Details) How to extend an AppExchange solution with Salesforce Slack SDK: https://salesforce.vidyard.com/watch/4zzgPYmVbqv3d8YoSfR9iY?


Slack (SDK) documentation for ISVS: https://dxv59a8vfm5tm.cloudfront.net/foyer/guide/overview.html

## Setup
​
- Create a new workspace (either in Enterprise Grid sandbox if you have one OR sign up with your personal email for free Slack account)
​
- Edit sfdx-project.json to replace the SFDCLoginURL value with your own devhub domain
- Run ./orgInit.sh command (check file to see all SFDX commands)
- When all is setup,
- Open Recruiting_Slack_Settings__c Custom setting
- Click "Manage Records" and New
- Set "Team ID" with the Workplace ID of your slack worksplace where you want to test this app
  - Workplace ID (a.k.a. Team ID) Starts with "T"
  - To find Team ID
    - Go to WORKSPACE.slack.com (in browser)
    - This should redirect you to something like https://app.slack.com/client/[T***]/.....
    - THat number starting with T is Team ID
​
- Install Slack app 
​
- This will prompt you to "Connect" your sandbox (remember to select sandbox link)
- You will need username and password for your scratch org
- Run following commands
  - sfdx force:user:password:generate --targetusername  YOUR-NEW-SCRATCH-ORG-USERNAME
    - To generate password
  - sfdx force:user:display -u   YOUR-NEW-SCRATCH-ORG-USERNAME
    - This will return user information including password
    - Save this as you may need this again
- Use following distribution link in your workspace (or Enterprise Grid sandbox)
  - https://slack.com/oauth/v2/authorize?client_id=2560874297015.2764151570580&scope=channels:history,channels:manage,channels:read,chat:write,chat:write.customize,chat:write.public,commands,groups:history,groups:read,groups:write,im:history,im:write,reactions:read,users.profile:read,users:read,users:read.email,users:write&user_scope=chat:write,im:write,reactions:read,users.profile:read,users:read,users:read.email
  - Permissions maybe overkill but this is test app. This will eventually be cleaned.
  - After you have logged in, it will prompt you to allow permissions to Slack app
- Once app is installed, try to run a recruiting command/shortcut (eg: /recruiting)
​
- If all was done properly then you should be able to run commands and return data from your org
