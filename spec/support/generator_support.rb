module GeneratorSupport
  def file_path(path)
    File.join(destination_root, path)
  end

  def file_contents(path)
    File.read(file_path(path))
  end

  def run_rails_new_generator(path)
    # inherit whatever GEMFILE is specified by our environment. This should allow the test to inherit
    # specific versions of rails from a gemfile, eg when using appraisals (to come soon)
    %x[bundle exec rails new -T -B -G #{path}] # skip test, bundle and git.
  end
end
