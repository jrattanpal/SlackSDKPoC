sfdx force:org:create -f config/project-scratch-def.json -a slackscratchpkg1 -s -d 30 

sfdx force:source:push

sfdx force:user:permset:assign -n Slack
sfdx force:user:permset:assign -n Recruiting_Admin

sfdx force:data:tree:import --plan data/secgenpkgtestjr/slack-demo-plan.json

sfdx force:org:open

# Create 2GP package
# sfdx force:package:create --name "SlackSDK PoC Recruiting 1" --path force-app --packagetype Managed
# Create package version
# sfdx force:package:version:create --package "SlackSDK PoC Recruiting 1" --installationkey test1234 --wait 10 -f config/project-scratch-def.json



# sfdx force:data:tree:export --query "SELECT FIELDS(ALL) FROM Position__c LIMIT 200" --prefix slack-demo --outputdir data --plan
# sfdx force:data:tree:export --query "SELECT FIELDS(ALL) FROM Candidate__c LIMIT 200" --prefix slack-demo --outputdir data --plan
# sfdx force:data:tree:export --query "SELECT Interview_Date__c,Candidate__c,Interview_Type__c,Interviewer_Confirmed__c,Status__c FROM Interview__c LIMIT 200" --prefix slack-demo --outputdir data --plan



#AppBuilder
#Production org—https://app-builder-for-slack.herokuapp.com
#Sandbox or scratch org— https://app-builder-for-slack-test.herokuapp.com

#Sample app: https://git.soma.salesforce.com/donald-small/apex-end-to-end-example