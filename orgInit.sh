sfdx force:org:create -f config/project-scratch-def.json -a slackscratch1 -s -d 30 

sfdx force:source:push

sfdx force:user:permset:assign -n Slack
sfdx force:user:permset:assign -n Recruiting_Admin

sfdx force:org:open

# sfdx force:user:password:generate --targetusername test-w76emxwtl7fz@example.com
# pz!jiw4twSrvp


# sfdx force:user:display -u test-w76emxwtl7fz@example.com
#ttps://java-momentum-1541-dev-ed.cs96.my.salesforce.com