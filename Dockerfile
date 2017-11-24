ARG image_tag="trusty-full"
FROM masiuchi/docker-mt-test:$image_tag

COPY t/cpanfile .

RUN cpm install -g --test
