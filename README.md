# FastR Docker

>Docker Images for [FastR](https://github.com/oracle/fastr) using [GraalVM](https://www.graalvm.org) CE Community Edition

## Why use docker
>Using Docker images is a great way to develop quality and reprodutible research. Use docker images, to run Gnu-R, FastR, Python, or any mix of tools. Even Gui application, lige QGis, could run under docker with a few adjusts. 
>>Some advantages of this aproach are:

+ You could create a well defined ennvironment to your research task. Where the tools and packages are in their respective versions that are need to run. No more need to uninstall and install tools and packages in your computer. All this tools will be containerized under docker and isolated of your system. 

+ Containers could be shared, moved and accessed remotely.

+ Publish a paper, working in a group **?** just publish your docker to others use.

+ Need more power? For example, you develop a research that is too slow to your computer, just move you docker image to some Cloud Provider, or other Supercomputer/Cluster that you have access. You will dont need to prepare, or ask to IT prepare the enviroment to run.

## Why FastR is so fast

> FastR is [compatible implementation](https://www.graalvm.org/docs/reference-manual/languages/r/#graalvm-r-engine-compatibility) from source of GNU-R Language Packages using [Trufle](https://github.com/oracle/graal/blob/master/truffle/README.md) and [GraalVM compiler](https://github.com/oracle/graal/blob/master/compiler) and run under GraalVM universal virtual machine which run self-optimizing AST interpreters.
**What this mean?**
Unlike **R** and other interpreted languages an AST interpreter like GraalVM learn to optimize performance while running. In this way longer process can get performance like a machine C/C++ compiler or even better.

## When use FastR **?**

+ Use FastR to get very high performance for R scripts
+ When using scripts that take time to run

## Caveats

+ FastR its not viable for short run scripts, since loading are more slow than standard Gnu-R and will not benefited from optimizations
+ FastR are under early development, so you need takes more care about installing R packages. 
> Get more informations about compatibility, parameters, etc in [GraalVM Reference Manual for R](https://www.graalvm.org/docs/reference-manual/languages/r/) 

## How to use this FastR Docker

+ First you need to have docker engine installed in your computer. Under Debian, Ubuntu, LinuxMint or other debian base system, is already on base repositories. But, you could use Docker.com repositories to get the newest version.
+ If you want really deploy FastR for your needs or research group in your own computer or server. Its highly recommended to configure where docker engine will store contents. Do this changing "graph" parameter in daemon.json that in ubuntu/debian is at /etc/docker/daemon, to a directory mapped to outside of system partition. 

## Using this docker image

```bash
docker pull jobdiogenes/fastr
```

___Running until exit___

***--rm*** option mean that after exit, the container will be removed.

***--name*** defined a name to your newly created container

***-v /my-folder-path:/inside-container-path*** map a local folder, remote, or docker volume to a container path.

```bash
docker run --rm -it --name mytest -v /path-to/my-local/data-and-scripts:/mnt Rscript /mnt/mytest.R
```
> **Notes:** Here and even, its highly recommended that in yours scripts **NEVER** use paths points to outside your script folder, like "../data.csv".

___Loading a FastR Docker that will stay running in background and restart if stopped___

***-d*** mean that docker will load and stay running in background until you call to stop or remove.
***$(pwd)*** mean (Linux,Unix,OSX,Nix, only) that will replace to the path od current folder where you are calling.
```bash
docker run -d --restart always --name myfastr -v $(pwd)/data:/mnt jobdiogenes/fastr
```

>This kind of call is usefull when you have scripts that takes long to run, and if something happens you want autorestart. Of course, in this situation your script must deal with errors and restarting.
> Another use, is to serve aplications, or enviroment to remote access or just that you use frequently.

___Loading, Prepare, Save and Reuse___

```bash
# Loading
docker run --rm -it --name mythesis jobdiogenes/fastr:latest
```

```bash
## Prepare now, the FastR running container to your needs. 
# Run R and then install your packages there. 
R
# Or call a script that is in the folder that you map to do this.
Rscript /mnt/install-packages.R

## You could even copy data to the container.
# Rememeber this could make your docker image bigger. But, its great
# for easy reproductibility.
mkdir /data
cp  /mnt/data/* /data
```

While running, you container, in another terminal/console session do it:

```bash
docker save mythesis -o mythesis.tar
```

>After saving, you could exit, stop or remove the docker that you was using.

Now you could share your docker image file. Reuse it by doing it:
```bash
docker load -i mythesis.tar
```

#### Any questions, want help ***?***
> Use github issue to contact-me
