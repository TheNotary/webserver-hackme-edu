TODO:  
  - Split this repo into two projects, one that's all about performance testing, and a second that's about pentesting


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


## Resources on performance related stuff
- Listing of benchmarks across various frameworks including one's I've never heard of
  - http://www.madebymarket.com/blog/dev/ruby-web-benchmark-report.html

- ab commands for doing post tests
  - https://gist.github.com/kelvinn/6a1c51b8976acf25bd78

- awk process to parse ab commands and reformat it into good looking html graphs
  - ......


## Pentesting Related

[Pentesting Discussion](ESSAY.md)
