Congo
=====

GroupHub front-end. Allows brokers to help group admins and employees manage
their benefit plans.

Getting started
---------------

1. Make sure you have Git installed and the proper Github keys set up, as well as a recent version of Ruby with the bundler gem, and Postgres.
2. Clone the repo. `git clone https://github.com/grouphub/congo.git`, then `cd congo`.
3. `bundle`
4. Verify the settings in `config/database.yml` look correct, then run `script/sweep_database`.
5. Run the server using `foreman start`.
6. Visit the site locally at [http://localhost:3000](http://localhost:3000).
7. You can run the tests via `bundle exec rspec spec`.
