
%w[4.0 4.1 4.2 5.0 5.1].each do |version|
  appraise "rails-#{version}" do
    gem 'activesupport', "~> #{version}.0"
  end
end

%w[3.0 3.1 3.2 3.3 3.4 3.5 3.6].each do |version|
  appraise "rspec-#{version}" do
    gem 'rspec', "~> #{version}.0"
  end
end
