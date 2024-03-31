require 'octokit'

module GetContributors
  def self.get_contributors(github_pa, org_name)
    client = Octokit::Client.new(:access_token => github_pa)

    contributors = []

    repos = client.org_repos(org_name)

    repos.each do |repo|
      begin
        repo_contributors = client.contributors(repo.full_name)

        if repo_contributors.instance_of? Array
          repo_contributors.each do |contributor|
            contributors << {
              :id => contributor.id,
              :username => contributor.login,
              :url => contributor.url,
              :avatar_url => contributor.avatar_url,
            }
          end
        else
          puts "Can't get contributions of #{repo.full_name}."
        end
      rescue Octokit::NotFound
        puts "Repository #{repo.full_name} not found."
      end
    end

    contributors
  end
end
