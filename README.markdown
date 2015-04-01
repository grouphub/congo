Congo
=====

GroupHub front-end. Allows brokers to help group admins and employees manage
their benefit plans.

Getting started
---------------

1.  Make sure you have Git installed and the proper Github keys set up.
2.  Make sure you have a recent version of Ruby installed with the bundler gem.
3.  In order to run the tests, you will need Firefox installed. Visit
    https://www.mozilla.org/en-US/firefox/new/, download Firefox, copy it to
    your Applications folder, and run it once to make sure it's setup properly.
4.  Make sure you have Postgres installed. Run `brew install postgresql` and
    follow the instructions.
5.  Make sure you have Redis installed. Run `brew install redis` and follow the
    instructions.
6.  You will need ngrok in order to test enrollment locally. Visit
    <a href="http://ngrok.com">http://ngrok.com</a> and sign up. Under your
    Dashboard, make note of your "auth token". Then, in the Terminal,
    `brew install ngrok`, and run `ngrok -authtoken YOUR_AUTH_TOKEN`. Hit
    `ctrl-c` to quit.
7.  Clone the repo. `git clone https://github.com/grouphub/congo.git`.
8.  `cd congo`
9.  `bundle`
10. Verify the settings in `config/database.yml` look correct.
11. Run `script/bootstrap`.
12. Run `script/ngrok` if you would like to receive callbacks from PokitDok.
13. You can run the tests via `bundle exec rspec spec`.
14. Run the server using `script/start`.
15. Visit the site locally at
    <a href="http://localhost:5000">http://localhost:5000</a>.

Generate an ERD Diagram
-----------------------

    brew install graphviz
    rake diagram:all
    open doc/models_complete.svg

You can find the generated SVG files in `doc/**/*.svg`.

Deployment
----------

### Deploying to Heroku

1. Login to [http://heroku.com](http://heroku.com) and make sure that your SSH
   keys are setup properly. Also make sure that you have access to "grouphub
   staging" project.
2. Install the Heroku toolbelt and run `heroku login` to log in from the
   Terminal.
3. Merge your code into master.
4. `git push heroku master`

### Deploying to Elastic Beanstalk

1. `brew install aws-elasticbeanstalk`
2. Follow instructions
   [here](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3.html) to
   get setup.
3. Merge your code into master.
4. `eb congo`

Setting up Servers
------------------

### Basic Setup

In order to SSH into servers, you will need to get the "grouphub-congo" keypair
from Roger. Then you can shell in like so:

    KEY=~/.ssh/grouphub-congo
    HOST=ec2-52-1-31-195.compute-1.amazonaws.com
    ssh -i $KEY ec2-user@$HOST

You will need to set the following environment variables in your `~/.bashrc` or
similar. You can get these keys from Roger.

    export AWS_ACCESS_KEY_ID='...'
    export AWS_SECRET_ACCESS_KEY='...'

### Front-ends

Then you will need to install the Elastic Beanstalk tools.

    brew install aws-elasticbeanstalk

To get setup, you will need to run the following:

    eb setup
    eb use congo-staging

You can deploy like so:

    eb deploy

To deploy to production:

    eb use congo-production
    eb deploy

Front ends are auto-scaled by Elastic Beanstalk and should not need to be
provisioned manually. I will put more documentation here eventually.

To SSH into a front-end box:

    # On your machine
    eb ssh

    # Once SSH'ed in
    cd /var/app/current
    bundle

    # Run the Rails console
    bundle exec rails console

    # Run the Postgres console
    PGPASSWORD=$RDS_PASSWORD bundle exec rails dbconsole

    # Tail the logs
    tail -n 50 -f log/production.log

    # To sweep the database, first log into the AWS console, reboot RDS, then
    script/sweep_database

### Workers

#### Provisioning a New Server

Setup an EC2 instance using the control panel or the CLI tool. Use an "Amazon
Linux" 64-bit AMI.

Make sure you can shell into the server. For example:

    KEY=~/.ssh/grouphub-congo
    HOST=ec2-52-1-31-195.compute-1.amazonaws.com
    ssh -i $KEY ec2-user@$HOST

Prepare the server. Make sure you're ssh'ed in, and run:

    # Install packages as root
    sudo su
    yum install --assumeyes \
      gcc-c++ patch readline readline-devel zlib zlib-devel \
      libyaml-devel libffi-devel openssl-devel make \
      bzip2 autoconf automake libtool bison iconv-devel \
      git postgresql-libs postgresql-devel
    exit

    # Install rbenv, ruby, and bundler as ec2-user
    git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
    source ~/.bashrc
    rbenv install 2.2.0
    rbenv global 2.2.0
    mv ~/bin ~/bin.old
    gem install bundler
    rbenv rehash

Test that everything is correct:

    which ruby # ~/.rbenv/shims/ruby
    which bundle # ~/.rbenv/shims/bundle
    bundle -v # Bundler version 1.9.1

Set the environment variables. Make sure you're SSH'ed in, fill in the following
lines with your variables, then run:

    echo '' >> ~/.bashrc
    echo '# Environment variables' >> ~/.bashrc
    echo 'export RACK_ENV="production"' >> ~/.bashrc
    echo 'export SECRET_TOKEN="..."' >> ~/.bashrc
    echo 'export SECRET_KEY_BASE="..."' >> ~/.bashrc
    echo 'export AWS_ACCESS_KEY_ID="..."' >> ~/.bashrc
    echo 'export AWS_SECRET_ACCESS_KEY="..."' >> ~/.bashrc
    echo 'export AWS_ACCESS_KEY=$AWS_ACCESS_KEY_ID' >> ~/.bashrc
    echo 'export AWS_SECRET_KEY=$AWS_SECRET_ACCESS_KEY' >> ~/.bashrc
    echo 'export AWS_REGION="..."' >> ~/.bashrc
    echo 'export RDS_HOSTNAME="..."' >> ~/.bashrc
    echo 'export RDS_PORT="..."' >> ~/.bashrc
    echo 'export RDS_DB_NAME="..."' >> ~/.bashrc
    echo 'export RDS_USERNAME="..."' >> ~/.bashrc
    echo 'export RDS_PASSWORD="..."' >> ~/.bashrc
    echo 'export REDIS_URL="..."' >> ~/.bashrc

Make sure you have SQS, Postgres on RDS, and Redis on Elasticache setup and
permissioned properly.

Test that everything is correct:

    cat ~/.bashrc
    env

In the Congo project on your local machine, edit "config/workers.rb" so that the
"boxes" list also contains your new server's info.

Then try deploying:

    WORKER_NAME=congo-staging-worker-1 bundle exec rake workers:deploy

#### Tasks

At any time you can get a full list of rake tasks:

    # Show all rake tasks with descriptions
    bundle exec rake -T

    # Show all rake tasks
    bundle exec rake -vT

    # Show all worker-related tasks
    bundle exec rake -T | grep workers

To get a list of servers:

    bundle exec rake workers:info

To deploy all:

    # Deploy all
    bundle exec rake workers:deploy

    # Deploy one
    WORKER_NAME=congo-staging-worker-1 bundle exec rake workers:deploy

To stop or start the workers and clocks:

    # Stop all
    bundle exec rake workers:stop

    # Stop one
    WORKER_NAME=congo-staging-worker-1 bundle exec rake workers:stop

    # Start all
    bundle exec rake workers:start

    # Start one
    WORKER_NAME=congo-staging-worker-1 bundle exec rake workers:start

`bundle exec rake workers:start` and `bundle exec rake workers:restart` are
synonyms. Both of them will try and stop the workers before starting them again.

