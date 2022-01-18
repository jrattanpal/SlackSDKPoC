# Slack SDK Pilot

## Setup

- Create a new workspace (either in Enterprise Grid sandbox if you have one OR sign up with your personal email for free Slack account)

- Run ./orgInit.sh command (check file to see all SFDX commands)
- When all is setup,
- Open Recruiting_Slack_Settings__c Custom setting
- Click "Manage Records"
- Update "Team ID" with the Workplace ID of your slack worksplace where you want to test this app
  - Workplace ID (a.k.a. Team ID) Starts with "T"

- Install Slack app using following distribution link in your workspace (or Enterprise Grid sandbox)
  - https://slack.com/oauth/v2/authorize?client_id=2560874297015.2764151570580&scope=channels:history,channels:manage,channels:read,chat:write,chat:write.customize,chat:write.public,commands,groups:history,groups:read,groups:write,im:history,im:write,reactions:read,users.profile:read,users:read,users:read.email,users:write&user_scope=chat:write,im:write,reactions:read,users.profile:read,users:read,users:read.email
  - Permissions maybe overkill but this is test app. This will eventually be cleaned.

- Once app is installed, try to run a recruting command/shortcut (eg: /recruiting)
- This should prompt you to "Connect" your sandbox (remember to select sandbox link)
- You will need username and password for your scratch org
- Run following commands
  - sfdx force:user:password:generate --targetusername  YOUR-NEW-SCRATCH-ORG-USERNAME
    - To generate password
  - sfdx force:user:display -u   YOUR-NEW-SCRATCH-ORG-USERNAME
    - This will return user information including password
    - Save this as you may need this again
- After you have logged in, it will prompt you to allow permissions to Slack app

- If all was done properly then you should be able to run commands and return data from your org
