require 'fastlane/action'
require_relative '../helper/semantic_release_helper'
require 'uri'
require 'net/http'

module Fastlane
  module Actions
    module SharedValues
    end

    class CreateReleaseAction < Action
      
      def self.run(params)
        uri = URI("#{params[:endpoint]}/projects/#{params[:project_id]}/releases")
        res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          req = Net::HTTP::Post.new(uri)
          req['Content-Type'] = 'application/json'
          req['PRIVATE-TOKEN'] = params[:private_token]
          req.body = {
            "assets": params[:assets],
            "description": params[:description],
            "milestones": [],
            "name": params[:title],
            "ref": params[:branch_name],
            "tag_name": params[:tag]
          }.to_json
          res = http.request(req)
          res
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Create Gitlab release"
      end

      def self.details
        "Create Gitlab release"
      end

      def self.available_options
        # Define all options your action supports.

        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(
            key: :description,
            description: "Release note description",
            default_value: "",
            optional: true
          ),
          FastlaneCore::ConfigItem.new(
            key: :title,
            description: "Title for release notes",
            optional: true
          ),
          FastlaneCore::ConfigItem.new(
            key: :endpoint,
            description: "Gitlab endpoint",
            optional: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :project_id,
            description: "Gitlab project id",
            optional: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :private_token,
            description: "Gitlab user private token",
            optional: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :tag,
            description: "Release tag",
            optional: true
          ),
          FastlaneCore::ConfigItem.new(
            key: :branch_name,
            description: "Git branch name",
            optional: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :assets,
            description: "Release assets",
            optional: true
          )
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        []
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
        "Returns generated release notes as a string"
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["xotahal"]
      end

      def self.is_supported?(platform)
        # you can do things like
        true
      end
    end
  end
end
