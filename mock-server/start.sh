docker run -ti -p 8080:8080 \
    -v $(pwd)/config:/opt/imposter/config \
    outofcoffee/imposter-openapi
