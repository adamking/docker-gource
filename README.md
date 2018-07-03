`docker build -t adk486/docker-gource .`

From your repo run:
`docker run --rm -it -v $(pwd):/src adk486/docker-gource`
