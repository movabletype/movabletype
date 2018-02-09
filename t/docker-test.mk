.PHONY: docker_build_image docker_build_dist docker_run_test docker_test docker_label docker_stop docker_clean docker-test-php-lint

DOCKER_IMAGE ?= mt

DOCKER_TESTS ?= ./t \
                ./plugins/*/t

DOCKER_SKIP_TESTS ?= t/62-asset-editor.t \
                     plugins/MultiBlog/t/02.tags.t

DOCKER_TEST_COMMAND ?= cp ./t/mysql-test.cfg ./mt-config.cgi && \
                       rm $(DOCKER_SKIP_TESTS) && \
                       service mysqld start & sleep 10 && \
                       service memcached start & sleep 10 && \
                       prove $(DOCKER_TESTS) && \
                       phpunit

docker_build_image:
	docker build --tag $(DOCKER_IMAGE) .

# TODO: remove hard-coded options
docker_build_dist:
	docker run --rm -v $$PWD:/var/www/mt -w /var/www/mt $(DOCKER_IMAGE) bash -c "perl build/exportmt.pl --local --no-lang-stamp --pack=MT --rel_num=0 --prod --alpha=1"

docker_run_test:
	docker run --label="$$(make -s docker_label)" --rm -w /var/www/mt $(DOCKER_IMAGE) bash -c "$(DOCKER_TEST_COMMAND)"

docker_test: docker_build_image docker_run_test

docker_label:
	echo "test.$(DOCKER_IMAGE)=$$(git rev-parse HEAD)"

docker_stop:
	docker stop $$(docker ps -q --filter "label=$$(make -s docker_label)")

docker_clean:
	docker run --rm -v $$PWD:/var/www/mt -w /var/www/mt $(DOCKER_IMAGE) bash -c "make clean"

PHP_DOCKER_IMAGE ?= php:5.3

docker-test-php-lint:
	docker run --rm -it -v $$PWD:/php -w /php $(PHP_DOCKER_IMAGE) bash -c "PHP_LINT_DIR=$(PHP_LINT_DIR) make test-php-lint"

