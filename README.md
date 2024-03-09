# phs-fluree-demo
Demo project for PHS presentation


### Install Docker Desktop
You'll need docker and Docker Desktop to run this project.
https://www.docker.com/products/docker-desktop/

### Clone project and change into project directory
```sh
git clone https://github.com/Jackamus29/phs-fluree-demo.git && cd phs-fluree-demo
```

### Run
This command will download the latest Coldfusion docker image and the latest fluree/server image.
Then it will us the `docker-compose.yml` file to start a container from each image. The `-d` flag tells docker to run it in the background.
```sh
docker compose up -d
```

### Navigate to website
Give it a few minutes for Coldfusion to start up, then go to [http://localhost:8500](http://localhost:8500)

### Stop containers
When you're done, you can click on the trashcan button on the `phs-cf-demo` container group, or you can run
```sh
docker compose down
``` 
You can also just restart the containers with
```sh
docker compose restart
```