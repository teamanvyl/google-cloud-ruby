require_relative "repo_metadata.rb"
require_relative "gem_version_doc.rb"
require_relative "repo_metadata.rb"

class DevsiteBuilder < YardBuilder

  def initialize master_dir = "."
    @master_dir = Pathname.new master_dir
    collect_metadata
  end

  def build_master
    return if case_insensitive_check!

    git_ref = current_git_commit master_dir
    determine_gems(master_dir).each do |gem|
      input_dir = "#{master_dir + gem}"
      output_dir = "#{gh_pages_dir + 'docs' + gem + 'master'}"
      build_gem_docs input_dir, output_dir
      ensure_gem_latest_dir gem
      puts "Build #{gem} documentation for commit #{git_ref}"
    end
  end

  def build_gem_docs input_dir, output_dir, gem = nil, version = 'master'
    gem ||= File.basename input_dir
    gem_metadata = @metadata[gem]
    gem_metadata["version"] = version
    docs = GemVersionDoc.new input_dir, output_dir, gem_metadata
    docs.publish
  end

  def publish_tag tag
    return if case_insensitive_check!

    gem, version = split_tag tag
    add_release gem, version
    build_docs_for_tag tag
    ensure_gem_latest_dir gem
    puts "Add #{gem} documentation for #{version} release"
  end

  def rebuild_all
    return if case_insensitive_check!

    current_git_commit master_dir
    load_releases.each do |gem, versions|
      versions.each do |version|
        build_docs_for_tag "#{gem}/#{version}"
      end
      build_gem_docs master_dir, gh_pages_dir, gem
      puts "Rebuild all #{gem} documentation (all tags and master)"
    end
  end

  private

  def build_docs_for_tag tag
    gem, version = split_tag tag
    checkout_branch tag do |tag_repo|
      input_dir = "#{tag_repo + gem}"
      output_dir = "#{gh_pages_dir + 'docs' + gem + version}"
      build_gem_docs input_dir, output_dir, gem, version
    end
  end

  def collect_metadata
    @metadata = {}
    determine_gems.each do |gem|
      source = "#{master_dir + gem}/.repo-metadata.json"
      @metadata[gem] = RepoMetadata.from_source source
    end
  end
end
