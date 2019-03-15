# Docker Compose Deployment Scripts

## Note about CPU limit

In order to set a container CPU limit with Docker Compose, we intentionally specifiy an older 2.x version in the config file rather than the current v3 (since support for CPU limits was removed / moved to Docker Swarm).
