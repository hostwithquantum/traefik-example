# traefik-example

How to run your own Traefik (v1.7). This example setup is heavily tailered towards deployments on [Planetary Quantum](https://www.planetary-quantum.com/). It can serve as another example for a lean and small deployment pipeline.

The Traefik here is the same version and in a similar configuration to the one
that (optionally) comes with Planetary Quantum cluster - in other words,
[everything described in our docs](https://docs.planetary-quantum.com/common-tasks/portainer-traefik/)
will work with it.

Questions, comments? Feel free to open an issue. :-)

## Setup

```shell
# create .envrc and customize it
$ cp .envrc-dist .envrc
$ $EDITOR .envrc
$ source .envrc
```

### Variables explained

These variables are in the example `.envrc-dist` file. You need to customize them.

| name | description |
| :---- | :--------- |
| QUANTUM_USER | Username for deployment |
| QUANTUM_PASSWORD | Password for the account |
| QUANTUM_ENDPOINT | Name of the endpoint/cluster |
| CUSTOMER_REGISTRY | fqdn of your docker registry, e.g. `r.planetary-quantum.com` |
| CUSTOMER_PROJECT | Name of the project namespace (on your registry) |
| CUSTOMER_EMAIL | An email address for Let's Encrypt |
| TRAEFIK_DOMAIN | The domain of your endpoint/cluster, e.g. `$customer.customer.planetary-quantum.net` |

## Custom TLS Certificates

To demonstrate basic custom certificate usage, this repo comes with a
self-signed example certificate for `example.127.0.0.1.nip.io`.
(Other domains will automatically get Let's Encrypt certificates.)

To add your own certificates:
* adjust `traefik.tpl.toml` under `entryPoints.https.tls.certificates` to
  include all your certificates
* adjust the Dockerfile to COPY them all into the image

## Build and publish the the image

In order to customize Traefik and keep all dependencies together, a custom image is the most simple approach.

The name of the image itself is `traefik`, but the "fq" name is `$CUSTOMER_REGISTRY/$CUSTOMER_PROJECT/traefik:latest`.

```shell
$ make all
```

There are also individual targets:
 - `make build`
 - `make push`

## Deploy the stack

Last but not least, here is how to deploy the stack:

```shell
$ make deploy
```

The _target_ invokes quantum-cli via a Docker image and injects necessary environment variables (user, password, endpoint) into the deployment. 
