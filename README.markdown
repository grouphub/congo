Congo
=====

GroupHub front-end. Allows brokers to help group admins and employees manage
their benefit plans.

Getting started
---------------

1. Make sure you have Git installed and the proper Github keys set up.
2. Make sure you have a recent version of Ruby installed with the bundler gem.
3. In order to run the tests, you will need Firefox installed. Visit
   https://www.mozilla.org/en-US/firefox/new/, download Firefox, copy it to
   your Applications folder, and run it once to make sure it's setup properly.
4. Make sure you have Postgres installed. Run `brew install postgresql` and
   follow the instructions.
5. Make sure you have Redis installed. Run `brew install redis` and follow the
   instructions.
6. Clone the repo. `git clone https://github.com/grouphub/congo.git`.
7. `cd congo`
8. `bundle`
9. Verify the settings in `config/database.yml` look correct.
10. Run `script/sweep_database`.
11. You can run the tests via `bundle exec rspec spec`.
12. Run the server using `bundle exec foreman start`.
13. Visit the site locally at http://localhost:5000.

