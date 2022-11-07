FROM gradle:5.6.2-jdk8
ARG version

ENV FL_GMAIL_USERNAME=ci-android@redmadrobot.com

# Install dependencies
RUN apt-get update && \
    apt-get install -y ca-certificates && \
    curl -sL https://deb.nodesource.com/setup_10.x |  bash - && \
    apt-get install -y make zip nodejs && \
    npm install -g danger && \
    apt-get autoremove -yq && \
    apt-get clean -yqq

# Install kotlinc
RUN cd /usr/lib && \
    wget -q https://github.com/JetBrains/kotlin/releases/download/v1.5.0/kotlin-compiler-1.5.0.zip && \
    unzip kotlin-compiler-*.zip && \
    rm kotlin-compiler-*.zip

ENV PATH $PATH:/usr/lib/kotlinc/bin

# Install danger-kotlin globally
RUN cd /usr/local && \
    git clone https://github.com/danger/kotlin.git --branch ${version} --single-branch _danger-kotlin && \
    cd _danger-kotlin && make install && \
    cd .. && rm -rf _danger-kotlin && \
    rm -rf /root/.konan/
