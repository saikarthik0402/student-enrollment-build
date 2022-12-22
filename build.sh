#! /bin/sh
APP_DIR="/home/app"

#Install Git
apk add git 

#Check git Version
GIT_VERSION=`git --version`
echo "$GIT_VERSION"

#Checks if the GITHUB secrets are found in env 
if [[ -z "$GITHUB_USER" ]]  && [[ -z "$GITHUB_TOKEN" ]] ; then
    echo "Github Credentials not found in environment variables"
    exit 1;
fi


#Cloning the stripe-handler repository stripe-golang branch
git -C $APP_DIR clone  --branch stripe-golang https://$GITHUB_USER:$GITHUB_TOKEN@github.com/saikarthik0402/stripehandler.git

#Cloning the student-enrollment-api-golang- repository
git -C $APP_DIR clone https://$GITHUB_USER:$GITHUB_TOKEN@github.com/saikarthik0402/student-enrollment-api-golang-.git

#Cloning the student-enrollment-app repository
git -C $APP_DIR clone --branch student-golang-app https://$GITHUB_USER:$GITHUB_TOKEN@github.com/saikarthik0402/studentenrollment.git

#Cloning the student-enrollment-server-app
git -C $APP_DIR clone https://$GITHUB_USER:$GITHUB_TOKEN@github.com/saikarthik0402/student-enrollment-app-server.git

#lising dir for debuggind
ls $APP_DIR

set -e
#Building and Copying the dist folder from student-enrollment-app-repo
docker build -t student-enrollment-app-build-image $APP_DIR/studentenrollment

#Building  student-enrollment-app-server 
docker build -t student-enrollment-app-image $APP_DIR/student-enrollment-app-server

#Building enrollment-api-golang-image
docker build -t student-app-golang-image $APP_DIR/student-enrollment-api-golang-

#Building Stripe-Handler-golang
docker build -t stripe-handler $APP_DIR/stripehandler


#Removing all the files
rm -rf $APP_DIR/stripehandler/
rm -rf $APP_DIR/student-enrollment-api-golang-/
rm -rf $APP_DIR/studentenrollment/
rm -rf $APP_DIR/student-enrollment-app-server/

#Running Docker Compose
echo "Running Docker Compose Up................................."
docker compose -f $DOCKER_COMPOSE_FILE up --detach
exit 0;