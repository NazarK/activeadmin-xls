require 'spec_helper'
describe ActiveAdmin::ResourceController do

  let(:mime) { Mime::Type.lookup_by_extension(:xls) }

  let(:request) do
    ActionController::TestRequest.new.tap do |test_request|
      test_request.accept = mime
    end
  end

  let(:response) { ActionController::TestResponse.new }

  let(:controller) do
    Admin::CategoriesController.new.tap do |controller|
      controller.request = request
      controller.response = response
    end
  end

  let(:filename) { "#{controller.resource_class.to_s.downcase.pluralize}-#{Time.now.strftime("%Y-%m-%d")}.xls" }

  it 'generates an xls filename' do
    controller.xls_filename.should == filename
  end

  context 'when making requests with the xls mime type' do
     it 'returns xls attachment when requested' do
      controller.send :index
      response.headers["Content-Disposition"].should == "attachment; filename=\"#{filename}\""
      response.headers["Content-Transfer-Encoding"].should == 'binary'
    end

    it 'returns max_csv_records for per_page' do
      controller.send(:per_page).should == controller.send(:max_csv_records)
    end

    it 'kicks back to the default per_page when we are not specifying a xls mime type' do
      controller.request.accept = 'text/html'
      controller.send(:per_page).should == ActiveAdmin.application.default_per_page
    end
  end
end

