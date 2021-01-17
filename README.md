# First Docker App

This is my first Docker based ExpressJS app. This project is a very simple
ExpressJS app that displays "Hello, World!" on your browser.

## Building and running the single stage image

To put into perspective how large this simple project that just displays
"Hello, World!" on your browser can really be, run
```docker build -f Dockerfile.big -t hello-express-big .```. This
could take some time to build if you are downloading the
```node:14.15.4``` image for the first time. Once that is done, run
```docker images```. This command displays all of the images present on
your system. Here, you should see an image with the name
```hello-express-big```. For me, this image came up to be 1.06 GB
which is massive considering what it does!

To run the image, run
```docker run -dp 3000:3000 --name=hello-express-big hello-express-big```.
This will create a container called ```hello-express-big``` and run it in
the background. Now, you can open up any browser of your choice and go to
```localhost:3000```.

## Building and running the multi-stage image

To optimise the image, I have used two things. Firstly, I will be using the
```node:14.15.4-alpine``` base image. This image contains all of the
functionality of the normal ```node:14.15.4``` image but can be as small as
5 MB! Secondly, I will be packaging all of the required dependencies and source
code into a single file using Webpack in production mode. This means that I
don't have to install the dependencies again during the second stage of the
build process.

So now to build this image, run ```docker build -t hello-express .```. This
step shouldn't take as long as the previous build step. Once complete, run
```docker images```, and check the size of the newly build image
```hello-express```. For me, it was 117.77 MB. A massive reduction in size!

Now to run the image, run 
```docker run -dp 3000:3000 --name=hello-express first-docekr-app``` and then
open up ```localhost:3000``` in your preferred browser.

## Clean up (Optional)

To stop and remove the containers run ```docker rm -f hello-express``` and
```docker rm -f hello-express-big```. This will stop and remove the
containers from the process list. Then to delete the images, run 
```docker rmi hello-express``` and ```docker rmi hello-express-big```.
Additionally, to remove any build cache, run ```docker builder prune -a```.

## Running in development mode

Making changes to docker containers isn't as easy. It involves stopping the
running container, deleting it's image, rebuilding a new image from the
changes, and finally, running it again. Luckily for us however, we can use
Docker Compose to do this for us. Here, I am using bind mounts to share the
source code to another container running the same ```node:14.15.4``` base
image. I then install all dependencies using ```npm``` and run the ```dev```
script. The ```dev``` script uses ```nodemon``` to watch for changes in the
source code and restarts the server whenever it sees a change.

Now to run the project in development mode, run
```docker-compose -f docker-compose.dev.yml up -d```. This will build
and start the container. Now, you can open ```localhost:3000``` in your
preferred browser.

Now when a change is detected in any of the files, ```nodemon``` will
automatically restart the server. To see your changes, simply refresh your
browser tab.

To stop the running container, run
```docker-compose -f docker-compose.dev.yml down```. This will stop and delete
the running container.

### Note

Docker in Windows uses Hyper-V which does not propagate file system changes to
a client. Therefore, ```nodemon``` has to be run using the ```--legacy-watch```
flag. If you are a Linux or MacOS user, remove the ```--legacy-watch``` flag
from the ```dev``` script in ```package.json```.