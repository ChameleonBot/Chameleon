FROM swift:5.2.2 as builder

# For local build, add `--build-arg env=docker`
# In your application, you can use `Environment.custom(name: "docker")` to check if you're in this env
ARG env
RUN apt-get -qq update && apt-get install -y \
  libssl-dev zlib1g-dev \
  libcurl4-openssl-dev \
  && rm -r /var/lib/apt/lists/*

WORKDIR /app
COPY . .
RUN mkdir -p /build/lib && cp -R /usr/lib/swift/linux/*.so* /build/lib
RUN swift build -c release && mv `swift build -c release --show-bin-path` /build/bin

ENTRYPOINT swift test --enable-test-discovery