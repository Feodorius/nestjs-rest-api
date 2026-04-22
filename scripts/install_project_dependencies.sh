#!/bin/bash

#give permission for everything in the express-app directory
sudo chmod -R 777 /home/ec2-user/express-app

cd /home/ec2-user/express-app

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # loads nvm bash_completion (node is in path now)

npm install pm2 -g

npm install --legacy-peer-deps

REGION=$(aws ssm get-parameter --name "/myapp/REGION" --query "Parameter.Value" --output text)
PUBLIC_ACCESS_KEY=$(aws ssm get-parameter --name "/myapp/PUBLIC_ACCESS_KEY" --with-decryption --query "Parameter.Value" --output text)
PRIVATE_ACCESS_KEY=$(aws ssm get-parameter --name "/myapp/PRIVATE_ACCESS_KEY" --with-decryption --query "Parameter.Value" --output text)

# Use AWS Secrets service for setting env variables in prod;
file_location=./.env
cat >$file_location <<EOF
REGION="${REGION}"
PUBLIC_ACCESS_KEY="${PUBLIC_ACCESS_KEY}"
PRIVATE_ACCESS_KEY="${PRIVATE_ACCESS_KEY}"
LOCAL_DATABASE_ENDPOINT=""
TABLE_AUTOCREATE="true"
TABLE_AUTOUPDATE="false"
APP_NAME="YourAppName"
DEVELOPMENT="false"
PORT="3000"
EOF

npm run build
