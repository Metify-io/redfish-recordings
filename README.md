# Redfish service recordings

This repository contains selection of Redfish recordings that can be served by
the Redfish mock servers.


## Quickstart

In order to make playing with those recordings as painless as possible,
repository already contains a `Gemfile` that can be used to install
[Redfish tools gem][rf-tools] that contain mock server. Running

   [rf-tools]: https://github.com/xlab-si/redfish_tools
               (Redfish tools)

    $ bundle
    Fetching gem metadata from https://rubygems.org/...
    Resolving dependencies...
    Using bundler 1.16.1
    ...

will install Redfish tools gem with dependecies and provide `redfish serve`
command. To start serving one of the recordings (`lenovo-sr650` in this
example), we must run

    $ bundle exec redfish serve lenovo-sr650
    [2018-05-30 16:37:01] INFO  WEBrick 1.3.1
    [2018-05-30 16:37:01] INFO  ruby 2.4.3 (2017-12-14) [x86_64-linux]
    [2018-05-30 16:37:01] INFO  RedfishTools::Server#start: pid=30028 port=8000

If we now visit `localhost:8000/redfish/v1`, a healthy amount of JSON data
will fill our browser.

To terminate the server, just press `CTRL+c`.

And this is basically all there is to it.


## Using prebuilt docker image

Docker image with two recordings is published in the xlab-steampunk repository on
quay.io. We can use it to spin up a mock server that serves one of the
two mocks.

We can start the container by running:

    $ docker run \
        --name rfmock \
        -p 8010:8000/tcp \
        -d \
        --rm \
        quay.io/xlab-steampunk/redfish-mock

This will start a Redfish mock server that we can access by visiting
http://localhost:8010/redfish/v1. By default, credentials that the mock server
uses are user/pass, and the recording that the mock server serves is mock.

We can customize all of those things by means of environment variables. This
example demonstrates all of the variables that we can use to tweak the
container:

    $ docker run \
        --name rfmock \
        -e PORT=8123
        -e USER=redfish \
        -e PASS=rfmock \
        -e MOCK=lenovo-sr650 \
        -p 8010:8123/tcp \
        -d \
        --rm \
        quay.io/xlab-steampunk/redfish-mock

When run like this, the mock server will serve a Lenovo recording, protected
by the redfish/rfmock credentials on port 8123. Note that we still can access
the mock server on http://localhost:8010/redfish/v1 (because of our port
forwarding rule).

There is one more variable called `BIND` whose value should be left as is most
of the time.


## Building and publishing the docker image

We can build the docker image by running:

    $ docker build --pull -t quay.io/xlab-steampunk/redfish-mock:latest .

Once we ave the image ready, we can publish it by running:

    $ docker push quay.io/xlab-steampunk/redfish-mock:latest

And that is about it.
