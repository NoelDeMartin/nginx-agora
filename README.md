# Nginx Agora

A collection of bash scripts to manage an nginx docker container acting as a reverse proxy to other containers.

For convenience, install the main script into your bin directory:

```sh
sudo ln -s `pwd`/scripts/nginx-agora.sh /usr/bin/nginx-agora
```

The following operations are supported:

- `start` Starts and creates nginx-agora container and network.
- `restart` Restarts nginx-agora running container.
- `install` Installs a new website. This command takes the path to the nginx config file, the root folder of the website and an optional name. This name will be used for mounting the root folder into the container under `/var/www/{name}`.
- `stop` Stop nginx-agora running container.
- `status` Display nginx-agora container status.

A network with the name `nginx-agora` will be created, and containers to be exposed should be attached to this network.

To learn more how this all works I suggest looking at the actual scripts.

## Plain HTML example

To get started with a bare-bones example, execute the following commands from the `example` folder on the cloned repository.

```sh
nginx-agora install example.test.conf ./
ln -s ../sites_available/example.test.conf ../sites_enabled
nginx-agora start
```

Remember to add example.test to your `/etc/hosts` file.

Now visit [http://example.test](http://example.test) in your browser and that should work!

## Disclaimer

These scripts were created for my own use case, and are intended for advanced users who are already familiar with docker and nginx and just want a starting point. Or for others learning how to setup their own server using docker and nginx. But I wouldn't recommend using this in production without looking at the scripts (they are very short!).

If you are looking for a more comprehensive and hands-off alternative, take a look at [nginx-proxy](https://github.com/jwilder/nginx-proxy).

