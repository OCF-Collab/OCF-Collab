require 'test_helper'

class NodeDirectorySyncTest < ActiveSupport::TestCase
  test "it enqueues entry sync job for each S3 object supporting pagination" do
    node_directory = create(:node_directory)
    node_directory_sync = NodeDirectorySync.new(node_directory: node_directory)

    list_objects_response_stub = S3ListObjectsResponseStub.new(
      bucket: node_directory.s3_bucket,
      total_objects: 20,
      max_keys: 3,
    )
    S3Client.stub_responses(:list_objects_v2, proc { |context| list_objects_response_stub.response(params: context.params) })

    entry_sync_job_perform_later = Minitest::Mock.new
    list_objects_response_stub.objects.each do |object|
      entry_sync_job_perform_later.expect(:call, nil, [{
        node_directory_id: node_directory.id,
        s3_key: object[:key],
      }])
    end

    NodeDirectoryEntrySyncJob.stub(:perform_later, entry_sync_job_perform_later) do
      node_directory_sync.sync!
    end

    entry_sync_job_perform_later.verify
  end

  class S3ListObjectsResponseStub
    attr_reader :bucket, :total_objects, :max_keys

    def initialize(bucket:, total_objects:, max_keys:)
      @bucket = bucket
      @total_objects = total_objects
      @max_keys = max_keys
    end

    def response(params:)
      if params[:bucket] != bucket
        return empty_page
      end

      page(continuation_token: params[:continuation_token])
    end

    def empty_page
      {
        contents: [],
        is_truncated: false,
        next_continuation_token: nil,
      }
    end

    def page(continuation_token:)
      pages.find do |page|
        page[:continuation_token] == continuation_token
      end
    end

    def pages
      @pages ||= begin
        groups = objects.in_groups_of(max_keys, false)

        groups.map.with_index do |group, index|
          {
            contents: group,
            continuation_token: group != groups.first ? "continuation-token-%d" % index : nil,
            is_truncated: group != groups.last,
            next_continuation_token: group != groups.last ? "continuation-token-%d" % (index + 1) : nil,
          }
        end
      end
    end

    def objects
      @objects ||= total_objects.times.map do |n|
        { key: "object-%d" % n }
      end
    end
  end
end
