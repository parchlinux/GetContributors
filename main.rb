require_relative "./config"
require_relative "./get_contributors"

contributors_json_file = "./json/contributors.json"
configs = Config.read "config.json"
org_name = configs["organization"]

github_pa = ENV["GITHUB_PERSONAL_ACCESS_TOKEN"]
if github_pa == nil
  raise "Could not get github personal access token as a env variable!"
end

contributors = GetContributors.get_contributors(github_pa, org_name)

# Update the contributors.json file
File.open(contributors_json_file, "w") do |file|
  file.puts JSON(contributors)
end
