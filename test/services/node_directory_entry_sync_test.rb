require 'test_helper'

class NodeDirectoryEntrySyncTest < ActiveSupport::TestCase
  describe NodeDirectoryEntrySync do
    let(:node_directory) do
      create(:node_directory)
    end

    let(:s3_key) do
      "sample-key"
    end

    let(:get_object_response_stub) do
      GetObjectResponseStub.new(
        bucket: node_directory.s3_bucket,
        key: s3_key,
        body: node_directory_entry_file_body,
      )
    end

    let(:entry_data) do
      JSON.parse(node_directory_entry_file_body)
    end

    let(:node_directory_entry_file_body) do
      file_fixture("node_directory/credential-engine-registry/ce-ee8c01f1-05fe-4d09-99ff-7dd4ec12a571.json").read
    end

    describe ".sync!" do
      context "S3 object exists" do
        before do
          S3Client.stub_responses(:get_object, proc { |context| get_object_response_stub.response(params: context.params) })
        end

        describe "competency framework resource handling" do
          context "competency framework doesn't exist" do
            it "creates competency framework" do
              node_directory_entry_sync = NodeDirectoryEntrySync.new(
                node_directory: node_directory,
                s3_key: s3_key,
              )

              node_directory_entry_sync.sync!

              framework = CompetencyFramework.find_by(node_directory_s3_key: s3_key)

              assert framework.present?
            end
          end

          context "competency framework already exists" do
            it "updates existing competency framework" do
              competency_framework = create(:competency_framework,
                node_directory: node_directory,
                node_directory_s3_key: s3_key,
              )

              node_directory_entry_sync = NodeDirectoryEntrySync.new(
                node_directory: node_directory,
                s3_key: s3_key,
              )

              assert_changes(-> { competency_framework.external_id }) do
                node_directory_entry_sync.sync!

                competency_framework.reload
              end
            end
          end
        end

        describe "competence framework attributes" do
          before do
            S3Client.stub_responses(:get_object, proc { |context| get_object_response_stub.response(params: context.params) })

            node_directory_entry_sync = NodeDirectoryEntrySync.new(
              node_directory: node_directory,
              s3_key: s3_key,
            )
            node_directory_entry_sync.sync!
          end

          subject do
            CompetencyFramework.find_by(node_directory_s3_key: s3_key)
          end

          let(:framework_data) do
            entry_data["framework"]
          end

          let(:competencies_data) do
            entry_data["competencies"]
          end

          it "sets proper external_id" do
            assert_equal framework_data["@id"], subject.external_id
          end

          it "sets proper name" do
            assert_equal framework_data["name"], subject.name
          end

          it "sets proper description" do
            assert_equal framework_data["description"], subject.description
          end

          it "sets proper concept keywords" do
            assert_equal framework_data["conceptKeyword"], subject.concept_keywords
          end

          it "sets proper attribution name" do
            assert_equal framework_data["attributionName"], subject.attribution_name
          end

          it "sets proper attribution URL" do
            assert_equal framework_data["attributionURL"], subject.attribution_url
          end

          it "sets proper provider node agent" do
            assert_equal framework_data["providerNodeAgent"], subject.provider_node_agent
          end

          it "sets proper provider meta model" do
            assert_equal framework_data["providerMetaModel"], subject.provider_meta_model
          end

          it "sets proper beneficiary rights" do
            assert_equal framework_data["beneficiaryRights"], subject.beneficiary_rights
          end

          it "sets proper registry rights" do
            assert_equal framework_data["registryRights"], subject.registry_rights
          end

          it "creates competencies with proper attributes" do
            assert_equal competencies_data.count, subject.competencies.count

            assert subject.competencies.all?(&:persisted?)

            competencies_data.each do |competency_data|
              competency = subject.competencies.find_by(name: competency_data["competencyText"])

              assert competency.present?

              if competency_data["comment"].present?
                assert_equal competency_data["comment"].join("\n"), competency.comment
              end
            end
          end
        end
      end

      context "S3 object doesn't exist" do
        before do
          S3Client.stub_responses(:get_object, Aws::S3::Errors::NoSuchKey.new(nil, nil))
        end

        context "competency framework doesn't exist" do
          it "passes gracefully" do
            node_directory_entry_sync = NodeDirectoryEntrySync.new(
              node_directory: node_directory,
              s3_key: s3_key,
            )

            # Making sure it doesn't throw any exception
            node_directory_entry_sync.sync!
          end
        end

        context "competency framework exists" do
          it "deletes existing competency framework" do
            create(:competency_framework,
              node_directory: node_directory,
              node_directory_s3_key: s3_key,
            )

            node_directory_entry_sync = NodeDirectoryEntrySync.new(
              node_directory: node_directory,
              s3_key: s3_key,
            )

            node_directory_entry_sync.sync!

            assert_not CompetencyFramework.exists?(node_directory_s3_key: s3_key)
          end
        end
      end

      context "S3 throws connection error" do
        let(:exception) do
          Seahorse::Client::NetworkingError.new(SocketError.new)
        end

        before do
          S3Client.stub_responses(:get_object, exception)
        end

        it "bubbles up the exception" do
          node_directory_entry_sync = NodeDirectoryEntrySync.new(
            node_directory: node_directory,
            s3_key: s3_key,
          )

          assert_raises(exception.class) do
            node_directory_entry_sync.sync!
          end
        end
      end
    end
  end

  class GetObjectResponseStub
    attr_reader :bucket,
      :key,
      :body

    def initialize(bucket:, key:, body:)
      @bucket = bucket
      @key = key
      @body = body
    end

    def response(params:)
      {
        body: body,
        content_type: "application/json",
      }
    end
  end
end
