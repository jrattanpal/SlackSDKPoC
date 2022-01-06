sfdx force:org:create -f config/project-scratch-def.json -a slackscratch2 -s -d 30 

sfdx force:source:push

sfdx force:user:permset:assign -n Slack
sfdx force:user:permset:assign -n Recruiting_Admin

sfdx force:data:tree:import --plan data/slack-demo-plan.json

sfdx force:org:open

# sfdx force:user:password:generate --targetusername test-4r3qyik1uguc@example.com
# jtnoresk6xJk*


# sfdx force:user:display -u test-4r3qyik1uguc@example.com
# https://energy-saas-5826-dev-ed.cs43.my.salesforce.com


# sfdx force:data:tree:export --query "SELECT FIELDS(ALL) FROM Position__c LIMIT 200" --prefix slack-demo --outputdir data --plan
# sfdx force:data:tree:export --query "SELECT FIELDS(ALL) FROM Candidate__c LIMIT 200" --prefix slack-demo --outputdir data --plan
# sfdx force:data:tree:export --query "SELECT Interview_Date__c,Candidate__c,Interview_Type__c,Interviewer_Confirmed__c,Status__c FROM Interview__c LIMIT 200" --prefix slack-demo --outputdir data --plan


#First scratch org where authentication worked

# sfdx force:user:password:generate --targetusername test-m8fxaarscrmy@example.com
# pz!jiw4twSrvp


# sfdx force:user:display -u test-m8fxaarscrmy@example.com
# https://java-momentum-1541-dev-ed.cs96.my.salesforce.com


#AppBuilder
#Production org—https://app-builder-for-slack.herokuapp.com
#Sandbox or scratch org— https://app-builder-for-slack-test.herokuapp.com

#Sample app: https://git.soma.salesforce.com/donald-small/apex-end-to-end-example