sfdx force:org:create -f config/project-scratch-def.json -a slackscratch1 -s -d 30 

sfdx force:source:push

sfdx force:user:permset:assign -n Slack
sfdx force:user:permset:assign -n Recruiting_Admin

sfdx force:org:open

# sfdx force:user:password:generate --targetusername test-w76emxwtl7fz@example.com
# Jbc6rq&iebpvv


# sfdx force:user:display -u test-w76emxwtl7fz@example.com
#https://flow-nosoftware-2952-dev-ed.cs69.my.salesforce.com