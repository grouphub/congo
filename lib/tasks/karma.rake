namespace :karma do
  task :start => :environment do
    with_tmp_config :start
  end

  task :run => :environment do
    exit with_tmp_config :start, "--single-run"
  end

  private

  def with_tmp_config(command, args = nil)
    Tempfile.open('karma_unit.js', Rails.root.join('tmp')) do |f|
      f.write unit_js(application_spec_files)
      f.flush

      system "./node_modules/karma/bin/karma #{command} #{f.path} #{args}"
    end
  end

  def application_spec_files
    Rails.application.assets
      .find_asset('application-spec.js')
      .to_a
      .map {|e| e.pathname.to_s }
  end

  def unit_js(files)
    unit_js = File.open('karma.conf.js', 'r').read
    rendered_files = files
      .map { |file| %["#{file}"] }
      .join(%[,\n])

    unit_js.gsub 'APPLICATION_SPEC', rendered_files
  end
end

