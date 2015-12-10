FROM ruby:2.2

RUN apt-get update -qq && apt-get install -y build-essential

# for database support
# see http://guides.rubyonrails.org/command_line.html#rails-dbconsole
#RUN apt-get update && apt-get install -y mysql-client postgresql-client sqlite3 --no-install-recommends && rm -rf /var/lib/apt/lists/*

# for postgres
RUN apt-get install -y libpq-dev

# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev

# for capybara-webkit
RUN apt-get install -y libqt4-webkit libqt4-dev xvfb

# for documentation
RUN apt-get install -y graphviz

# for a JS runtime
RUN apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*

ENV APP_HOME /congo-app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install

ADD . $APP_HOME
