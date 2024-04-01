require "octokit"

module GetContributors
  def self.has_contributor?(list, username)
    list.find { |c| c[:username] == username } != nil
  end

  def self.get_contributors(github_pa, org_name)
    client = Octokit::Client.new(:access_token => github_pa)

    contributors = []

    repos = client.org_repos(org_name, { :per_page => 500 })

    repos.each do |repo|
      begin
        repo_contributors = client.contributors(repo.full_name)

        if repo_contributors.instance_of? Array
          repo_contributors.each do |contributor|
            # Prevent duplicate contributor
            if !self.has_contributor?(contributors, contributor.login)
              contributors << {
                :id => contributor.id,
                :username => contributor.login,
                :url => contributor.url,
                :avatar_url => contributor.avatar_url,
              }
            end
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
