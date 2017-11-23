FROM masiuchi/docker-mt-test:trusty-full

COPY t/cpanfile .

RUN cpm install -g --test
