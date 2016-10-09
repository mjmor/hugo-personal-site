+++
thumbnail = "/assets/hugo.png"
postname = "Building a Static Website with Hugo and Nginx"
draft = false
tags = [
  "web-dev",
]
categories = [
  "technology",
]
series = [
  "",
]
date = "2016-10-09T16:53:39-04:00"
title = "hugositecreator"

+++

At MHacks this past weekend I redesigned my website for a more mobile-friendly 
experience. In the process, I decided I also wanted to create a page for blog 
posts but I was ***positive*** that I didn't want to do this using vanilla HTML, 
CSS, and javascript (which is how my previous website was constructed). So I went 
out on a limb and searched the web for some site generator or content management 
system that suited my needs. What I came up with was Hugo.

Hugo
---
Hugo is a static website engine built in the Go pogramming language (obligatory 
link: [Hugo's Website](https://gohugo.io/)). I think what 
really drew me in was a snippet from the front page stating *"Hugo doesn’t depend 
on administrative privileges, databases, runtimes, interpreters or external 
libraries."* And it really doesn't. All you need is Go and git and I already had 
those installed. For the general user who wants to use a premade theme (many of 
which available [here](https://themes.gohugo.io/)) creating a website can be as simple as: 
```
hugo new site mysite
# edit the site config to suite your needs
cd mysite && vim config.toml
hugo new post/building-a-website.md
```
then all the content they wish to post in the 'building-a-website' page can simply 
be placed in a markdown file with a special header located at `mysite/content/post/building-a-website.md`. On top of that wonderful and simple interface for adding content, 
hugo has a built in HTTP server, meaning 
I can generate my site on the fly by leaving the HTTP server running and look at 
it will render any changes I've made. A developers dream. The HTTP server can be 
launched via:
```
hugo server
# or if you'd like to include content you haven't published yet (aka drafts)
hugo server --buildDrafts
```
This feature was incredibly useful while I was designing my site for the first time. It 
is also great while I write new content for the site and test out obsure markdown tags 
I'm not familiar with.<sup>haha</sup> 

I was pretty set on retaining the aesthetic of my current website so instead of using 
a premade theme I chose to create my own from some of the CSS styling my current 
website. I haven't made it into an 'official' hugo theme yet due to the way my site is 
constructed but if you're interested in viewing the source code it can be found on 
[github](https://github.com/mjmor/hugo-terminal-theme). I plan to convert it into an official hugo 
theme in the future when I can find time. 

Hosting a Hugo Site on Nginx
---
A Hugo generated site can be hosted on most if not all of the existing hosting providers 
including Heroku, GoDaddy, DreamHost, GitHub Pages, Surge, Aerobatic, Google Cloud Storage, Amazon S3 and CloudFront. They can also be hosted with relative ease on a web server 
such as Apache or Nginx. I chose to go with Nginx because I am familiar with the 
configuration syntax and I already have a Digital Ocean droplet to run it on. I also 
plan on hosting a python back-end in flask on the same droplet and Nginx 
will be perfect for proxying to flask in the future. 

Because I already had all the source code for generating the site via Hugo in a git repo, 
deploying the site was as simple as:

1. adding a server block to my Nginx configuration
2. cloning the repo (or updating the repo if it's already there)
3. running the hugo command to generate the site
4. copying the generated site to my site's root directory
5. reload the nginx configuration

Creating the Nginx server block for the configuration file was straightforward due to 
Hugo's rigoruous content structure. The server block goes as follows (and of course it 
uses excryption):

```
server {
        listen       443 ssl http2;
        listen       [::]:443 ssl http2;
        server_name  maxwelljmorgan.net www.maxwelljmorgan.net;
        root         /var/www/maxwelljmorgan.net/html/;

        access_log /var/www/maxwelljmorgan.net/log/access.log;
        error_log /var/www/maxwelljmorgan.net/log/error.log;

        add_header Strict-Transport-Security max-age=15768000;

        ssl_certificate "/etc/letsencrypt/live/maxwelljmorgan.net/fullchain.pem";
        ssl_certificate_key "/etc/letsencrypt/live/maxwelljmorgan.net/privkey.pem";
        ssl_session_cache shared:SSL:50m;
        ssl_stapling on;
        ssl_stapling_verify on;
        ssl_dhparam "/etc/ssl/certs/dhparam.pem";
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_session_timeout  1d;
        ssl_ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:!aNULL:!MD5:!DSS;
        ssl_prefer_server_ciphers on;

        location / {
            try_files $uri $uri/index.html $uri.html =404;
        }

        location ~ /.well-known {
                allow all;
        }

        error_page 404 /404.html;

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }
    server {
        listen 80;
        server_name maxwelljmorgan.com www.maxwelljmorgan.com;
        return 301 https://$host$request_uri;
    }
}
```

Then when I want to update my site (say if I add new content), only steps 2, 3, 4, and 5 
are needed. Since I love bash and automation, I went ahead and created a nice little 
script to take care of steps 2, 3, and 4. 

```
#!/bin/bash

SITE_ROOT="/var/www/maxwelljmorgan.net/html/"
PUBLIC_DIR="/home/mjmor/repos/hugo-personal-site/public/"

if git pull; then
    /home/mjmor/go/bin/hugo
    if [ ! -z "$SITE_ROOT" ]; then
        sudo rm -rf ${SITE_ROOT}*
    fi
    if [ ! -z "$PUBLIC_DIR" ]; then
        sudo cp -R ${PUBLIC_DIR}* $SITE_ROOT && \
    fi
    sudo systemctl reload nginx.service
fi
```


Creating this site was a great learning experience using Hugo and I look forward to 
working with Hugo more in the future as I make changes to the site and add new content 
because trust me, I know it's not the prettiest site at the moment (:
