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

### Workers

Setup an EC2 instance using the control panel or the CLI tool.

Make sure you can shell into the server.
`ssh -i ~/.ssh/grouphub-congo ec2-user@ec2-52-1-31-195.compute-1.amazonaws.com`

Prepare the server.

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
    rbenv install 2.2.0
    rbenv global 2.2.0
    mv ~/bin ~/bin.old
    gem install bundler
    rbenv rehash
