# - `docker build -t foo .`
# - `docker run -it --name foo_container foo sh` to start the container and shell in
# - in the container, `mix dialyzer`
# - exit
# - `docker rm -f foo_container`

FROM hexpm/elixir:1.12.0-rc.1-erlang-24.0-ubuntu-bionic-20210325 as build

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# install and compile mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get
RUN mix deps.compile

# compile application code
COPY lib lib
RUN mix compile
