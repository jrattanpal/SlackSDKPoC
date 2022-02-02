sfdx force:org:create -f config/project-scratch-def.json -a slackscratchpkgtest1  -d 30 

#https://login.salesforce.com/packaging/installPackage.apexp?p0=04t6O000001J8kCQAS
sfdx force:package:install -k test1234  -p 04t6O000001J8kCQAS -w 20 -u slackscratchpkgtest1

sfdx force:user:permset:assign -n secgenpkgtestjr__Slack -u slackscratchpkgtest1
sfdx force:user:permset:assign -n secgenpkgtestjr__Recruiting_Admin -u slackscratchpkgtest1

sfdx force:data:tree:import --plan data/secgenpkgtestjr/slack-demo-plan.json -u slackscratchpkgtest1

sfdx force:org:open -u slackscratchpkgtest1

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