# This may change later, for now I'm making the db users all
# just be postgres, we'll see if this should be configured later.
db_user=postgres

usage:
	@echo "Welcome to your friendly makefile interface to docker\nThese commands will help you interface with the application:\nUsage\nmake run-app                  # runs the whole app as is (no rebuild of images)\nmake build                    # build all layers\nmake kill-app                 # kills the app\nmake rebuild-all-and-run-app  # rebuild all images, run the full app\nmake run-tests                # run all tests, or just one with 'make run-tests spec=path_to_spec' (works with any spec)\nmake rebuild-layers           # rebuild all layers, or just one with 'make rebuild-layers layer=web' (or any other layer)\nmake rails-console            # enter a rails console\nmake database-console         # enter a database console session in postgresql\nmake redis-console            # enter a redis REPL session\nmake get-logs                 # get all logs, or one layers with 'make get-logs layer=web' (or any other layer)"

# USAGE
# build all layers
build:
	@docker-compose build

# USAGE
# $ make run-app
# run all services as they are, with no rebuilding
# If you have only made changes to code and not created any new files,
# this is what you want.
# If you have made new files, the 'COPY .' command in the Dockerfile
# will never have seen these files and they will not be present in the
# image.
#
# So, if you have added a new spec, migration, etc, or changed the Gemfile
# or added a yarn package, this is NOT what you will want to run, instead use
#
# make rebuild-all-and-run-app
#
# To rebuild _everything_, or use
#
# make rebuild-layers layer=layer_name
#
# to just rebuild one. i.e:
#
# make rebuild-layers layer=web
#
# Will just rebuild the web layer, getting you new files, and bundling etc.
run-app:
	@docker-compose down; \
	docker-compose up -d; \
		echo; \
		echo; \
		echo; \
		echo "To view logs, see relevent make commands in Makefile"; \

# USAGE
# make kill-app
# stops all containers, and the app itself
kill-app:
	@docker-compose down

# USAGE
# $ make rebuild-all-and-run-app
# run all services with images rebuilt
# If you want everything fresh, this is the move
rebuild-all-and-run-app:
	@docker-compose down; \
	docker-compose up --build -d; \
		echo; \
		echo; \
		echo; \
		echo "To view logs, see relevent make commands in Makefile"; \

# USAGE
# $ make run-tests
# run all tests
# to run a specific test, pass the argument 'spec' to a directory or file, i.e:
# make run-test spec=spec/models/user_spec.rb
# or
# make run-test spec=spec/controllers/
# and it will run those accordingly
run-tests:
	@echo; \
	echo "By default this will run the entire suite as the .rspec file configures"; \
	echo "To run a specific test, use:"; \
	echo "make run-tests spec=path_to_your_spec_or_directory"; \
	docker-compose exec web bundle exec rspec $(spec)


# USAGE
# By default it will rebuild all layers with
#
# make rebuild-layers
# make rebuild-layers layer=layer_name
# i.e
# make rebuild-layers layer=web
# make rebuild-layers layer=database
# make rebuild-layers layer=redis
# make rebuild-layers layer=webpack-dev-server
#
# This is what you want to run when you make any changes to their
# configuration or their general structure, it will ensure you get
# a new image with the latest changes
rebuild-layers:
	@docker-compose build $(layer)

# USAGE
# make rails-console
# Runs a rails console in the web application layer.
rails-console:
	@docker-compose run --rm web bin/rails c

# USAGE
# make database-console
# Runs a psql REPL in the database layer
database-console:
	@docker-compose run --rm database psql -U $(db_user) -h database

# USAGE
# make redis-console
# Runs a redis REPL in the redis layer using the redis cli client
redis-console:
	@docker-compose run --rm redis redis-cli -h redis

# USAGE
# By default, it will get all logs:
# make get-logs
#
# To get a specific layers logs:
#
# make get-logs layer=web
# make get-logs layer=database
# make get-logs layer=redis
# make get-logs layer=webpack-dev-server
get-logs:
	@docker-compose logs -f $(layer)
