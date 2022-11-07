ARG version
FROM ruby:${version}-slim

ENV FL_GMAIL_USERNAME=ci-android@redmadrobot.com

# Install needed tools
RUN apt-get update --yes && apt-get install --yes --no-install-recommends \
    git \
	curl \
	make \
	g++ \
    && rm -rf /var/lib/apt/lists/*

# Install bundler
ENV GEM_HOME="/usr/local/bundle" \
    PATH="$GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH"
RUN gem install bundler

# Install firebase-cli
RUN curl -Lo /usr/local/bin/firebase https://firebase.tools/bin/linux/latest && \
    chmod +x /usr/local/bin/firebase
