Congo
=====

GroupHub front-end. Allows brokers to help group admins and employees manage
their benefit plans.

Getting started
---------------

1. Make sure you have Git installed and the proper Github keys set up.
2. Make sure you have a recent version of Ruby installed with the bundler gem.
3. Make sure you have Postgres installed. Run `brew install postgresql` and
   follow the instructions.
4. Make sure you have Redis installed. Run `brew install redis` and follow the
   instructions.
5. Clone the repo. `git clone https://github.com/grouphub/congo.git`.
6. `cd congo`
7. `bundle`
8. Verify the settings in `config/database.yml` look correct.
9. Run `script/sweep_database`.
10. You can run the tests via `bundle exec rspec spec`.
11. Run the server using `bundle exec foreman start`.
12. Visit the site locally at [http://localhost:3000].

