
[![PHP 8.2](https://github.com/chrecht/docker-library/actions/workflows/php-8.2.yml/badge.svg)](https://github.com/chrecht/docker-library/actions/workflows/php-8.2.yml)

[![PHP 8.3](https://github.com/chrecht/docker-library/actions/workflows/php-8.3.yml/badge.svg)](https://github.com/chrecht/docker-library/actions/workflows/php-8.3.yml)

[![nginx 1.26 - stable](https://github.com/chrecht/docker-library/actions/workflows/nginx-1.26.yml/badge.svg)](https://github.com/chrecht/docker-library/actions/workflows/nginx-1.26.yml)

[![nginx 1.27 - mainline](https://github.com/chrecht/docker-library/actions/workflows/nginx-1.27.yml/badge.svg)](https://github.com/chrecht/docker-library/actions/workflows/nginx-1.27.yml)

[![node 18](https://github.com/chrecht/docker-library/actions/workflows/node-18.yml/badge.svg)](https://github.com/chrecht/docker-library/actions/workflows/node-18.yml)

[![node 20](https://github.com/chrecht/docker-library/actions/workflows/node-20.yml/badge.svg)](https://github.com/chrecht/docker-library/actions/workflows/node-20.yml)

[![node 22](https://github.com/chrecht/docker-library/actions/workflows/node-22.yml/badge.svg)](https://github.com/chrecht/docker-library/actions/workflows/node-22.yml)



# create builder
docker buildx create \
  --name container \
  --driver=docker-container

# clear builder cache
docker builder --builder=container prune -af
