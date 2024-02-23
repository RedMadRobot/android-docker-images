ARG version
FROM ruby:${version}-slim-bookworm

# Install needed tools
RUN apt-get update --yes && apt-get install --yes --no-install-recommends \
    git \
	curl \
	make \
	g++ \
    && rm -rf /var/lib/apt/lists/*

# Install bundler
ENV PATH="$GEM_HOME/gems/bin:$PATH"
RUN gem install bundler

# Install firebase-cli
RUN curl -Lo /usr/local/bin/firebase https://firebase.tools/bin/linux/latest && \
    chmod +x /usr/local/bin/firebase

CMD ["bash"]
