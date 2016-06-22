TODO:  
  - fix bug in index.html where path to rails app is messed up
  - re-flow Dockerfile so the index.html file is moved into place after all the installation stuff... which should be dead simple...
  - Hook in the assembly compiled cgi-bin on index.html
  - Consolidate apt-get's near by each other... but don't merge them so it's easier to extract... add comments per apt-get string especially compiling ruby


# Nginx fcgiwrap Docker

> [Nginx](http://nginx.org/) HTTP server with fcgiwrap Docker image

This Dockerfile is for educational purposes and serves dynamic web content via a variety of different ways:

  - nginx -> fastcgi -> bash scripts
  - nginx -> fastcgi -> ruby scripts
  - nginx -> thin    -> a rack serverlet
  - nginx -> thing   -> a rails app

Ideally you'll be able to use `ab` to create performance tests of all of these implementations to give you a feel for how perfromance is effected by using different technologies.  

## Supported tags and respective Dockerfile links :

- `1.9.7`, `latest` [(1.9/Dockerfile)](https://github.com/rodolpheche/nginx-fcgiwrap-docker/blob/1.9.7/Dockerfile)

## How to use the image

Use the Makefile commands such as `make build`, `make run`, and `make console`.

Access [http://localhost/](http://localhost/) to show the static site.
