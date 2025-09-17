ARG RUBY_VERSION=3.3.5
FROM ruby:${RUBY_VERSION}-slim

# Instala dependências básicas e libs para MongoDB
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libyaml-dev nodejs yarn pkg-config libjemalloc2 libssl-dev libgmp-dev && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

WORKDIR /app

# Instala gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copia o código da aplicação
COPY . .

# Expõe a porta padrão do Rails
EXPOSE 3000

# Entrypoint padrão para docker-compose (pode ser sobrescrito)
CMD ["bash"]
