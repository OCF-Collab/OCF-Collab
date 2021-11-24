require "test_helper"

class S3EventNotificationProcessorTest < ActiveSupport::TestCase
  EVENT_NAMES = [
    "ObjectCreated:Put",
    "ObjectCreated:Post",
    "ObjectCreated:Copy",
    "ObjectCreated:CompleteMultipartUpload",
    "ObjectRemoved:Delete",
    "ObjectRemoved:DeleteMarkerCreated",
  ]

  let(:node_directory) do
    create(:node_directory)
  end

  let(:s3_bucket) do
    node_directory.s3_bucket
  end

  let(:s3_key) do
    "sample-key"
  end

  let(:event_notification) do
    {
      "eventVersion" => "2.1",
      "eventSource" => "aws:s3",
      "awsRegion" => "us-east-1",
      "eventTime" => "2020-12-22T17:32:00.115Z",
      "eventName" => event_name,
      "userIdentity" => {
        "principalId" => "AWS:XXXXXXXXXXXXXXXXXXXXX",
      },
      "requestParameters" => {
        "sourceIPAddress" => "XXX.XXX.XXX.XXX",
      },
      "responseElements" => {
        "x-amz-request-id" => "XXXXXXXXXXXXXXXX",
        "x-amz-id-2" => "XXXXXXXXXXXX",
      },
      "s3" => {
        "s3SchemaVersion" => "1.0",
        "configurationId" => "ocf-collab-s3-event-notification",
        "bucket" => {
          "name" => s3_bucket,
          "ownerIdentity" => {
            "principalId" => "XXXXXXXXXXXXX",
          },
          "arn" => "arn:aws:s3:::#{ s3_bucket }",
        },
        "object" => {
          "key" => s3_key,
          "size" => 24452,
          "eTag" => "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
          "sequencer" => "XXXXXXXXXXXXXXXXXX",
        }
      }
    }
  end

  subject do
    S3EventNotificationProcessor.new(event_notification: event_notification)
  end

  describe ".process!" do
    context "valid events" do
      EVENT_NAMES.each do |event_name|
        context "Event name: %s" % event_name do
          let(:event_name) do
            event_name
          end

          let(:node_directory_entry_sync_job_perform_later_mock) do
            mock = Minitest::Mock.new
            mock.expect(:call, nil, [{
              node_directory: node_directory,
              s3_key: s3_key,
            }])
            mock
          end

          it "schedules node directory entry sync" do
            NodeDirectoryEntrySyncJob.stub(
              :perform_later,
              node_directory_entry_sync_job_perform_later_mock
            ) do
              subject.process!
            end

            node_directory_entry_sync_job_perform_later_mock.verify
          end
        end
      end
    end

    context "invalid event" do
      context "invalid event type" do
        let(:event_name) do
          "InvalidEventType"
        end

        it "raises ArgumentError" do
          error = assert_raises(ArgumentError) do
            subject.process!
          end

          assert_includes error.message, "Invalid S3 event"
        end
      end

      context "unregistered S3 bucket" do
        let(:event_name) do
          EVENT_NAMES.first
        end

        let(:s3_bucket) do
          "bucket-without-node-directory"
        end

        it "raises ArgumentError" do
          error = assert_raises(ActiveRecord::RecordNotFound) do
            subject.process!
          end

          assert_includes error.message, "NodeDirectory"
        end
      end
    end
  end
end
