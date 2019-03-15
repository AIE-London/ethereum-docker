# Docker Compose Deployment Scripts

Use the `generate.sh` script to generate a Docker Compose config file. For the arguments, it’s best to look in the script. It gives quite a bit of hopefully helpful output too.

## Note about CPU limit

In order to set a container CPU limit with Docker Compose, we intentionally specifiy an older 2.x version in the config file rather than the current v3 (since support for CPU limits was removed / moved to Docker Swarm).
