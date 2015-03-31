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

### Front-ends

Front ends are auto-scaled by Elastic Beanstalk and should not need to be
provisioned manually. I will put more documentation here eventually.

### Workers

Setup an EC2 instance using the control panel or the CLI tool. Use an "Amazon
Linux" 64-bit AMI.

Make sure you can shell into the server. For example:

    ssh -i ~/.ssh/grouphub-congo ec2-user@ec2-52-1-31-195.compute-1.amazonaws.com

Prepare the server. Make sure you're ssh'ed in, and run:

    sudo su
    yum install --assumeyes \
      gcc-c++ patch readline readline-devel zlib zlib-devel \
      libyaml-devel libffi-devel openssl-devel make \
      bzip2 autoconf automake libtool bison iconv-devel \
      git postgresql-libs postgresql-devel
    exit
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

Set the environment variables. Make sure you're ssh'ed in, fill in the following
lines with your variables, then run:

    echo '' >> ~/.bashrc
    echo '# Environment variables' >> ~/.bashrc
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
    echo 'export RACK_ENV="production"' >> ~/.bashrc

Test that everything is correct:

    cat ~/.bashrc
    ruby -e "puts ENV.inspect"

In the Congo project on your local machine, edit "config/workers.rb" so that the
"boxes" list also contains your new server's info.

Then try deploying:

    bundle exec rake workers:deploy_one[...] # Replace the ellipsis with your worker name

To deploy all:

    bundle exec rake workers:deploy

