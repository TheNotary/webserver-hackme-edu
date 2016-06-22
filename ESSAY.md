# Understanding web requests through nginx
There are

#### static assets
When a static asset is requested from the user (such as an index.html file that exists on the filesystem) then nginx will simply pipe that file back to the original requester.  Nginx and apache are very quick at doing this.  

#### fastcgi_pass
ref:  https://www.digitalocean.com/community/tutorials/understanding-and-implementing-fastcgi-proxying-in-nginx
Using fastcgi_pass, nginx can pass the requests to a cgi-bin to fastcgi to be processed before being returned to nginx.  The protocols for this hand off can be http, unix sockets and possibly others.  We can wire tap the unix socket and watch what data is sent to the socket from nginx.  

(http://superuser.com/questions/484671/can-i-monitor-a-local-unix-domain-socket-like-tcpdump)
```
sudo mv /path/to/sock /path/to/sock.original
sudo socat -t100 -x -v UNIX-LISTEN:/path/to/sock,mode=777,reuseaddr,fork UNIX-CONNECT:/path/to/sock.original
```

You'll notice that no headers are actually sent.  

#### proxy_pass
#### usgnlsidfj
#### memchache


# Making Metasploit Modules - Workflow etc

## (SQL Injection, intel collection) Explain scanning for exploitablity of the post commands
Inject SQL to bypass authentication to intellegence

## (Password decrypting, pivoting with passwords)
Decrypt the admin username/ password to gain access to a site protected by basic auth.  

## (RCE) Explain buffer overflow exploitability of the assembly cgi-bin for posting when that's sorted out

## (Dissassembly) Dissasemble a compiled app that has some database connection credentials burried in it?
Perform some pivoting that required decompiling a binary and analyzing what it does and then perform an attack on a weakness.  Oh... it uploads to an SFTP and can place files arbitrarily on the system due to poor configurations.  This will take us out of the VM/ docker container and into a more substantial environment that gives us access to server orchestration software such as Chef.  

## (Rootkit l0l)
Build a presence on the machine, manage it as though it were a member of your network
