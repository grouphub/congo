Congo
=====

GroupHub front-end. Allows brokers to help group admins and employees manage
their benefit plans.

Getting started
---------------

1. Make sure you have Git installed and the proper Github keys set up.
2. Make sure you have a recent version of Ruby installed with the bundler gem.
3. Make sure you have Postgres installed.
4. Clone the repo. `git clone https://github.com/grouphub/congo.git`.
5. `cd congo`
6. `bundle`
7. Verify the settings in `config/database.yml` look correct.
8. Run `script/sweep_database`.
9. You can run the tests via `bundle exec rspec spec`.
10. Run the server using `bundle exec foreman start`.
11. Visit the site locally at [http://localhost:3000].

