require 'spec_helper'
require 'diametric/persistence/rest'
require 'securerandom'

describe Diametric::Persistence::REST, :integration do
  before do
    @db_uri = ENV['DATOMIC_URI'] || 'http://localhost:46291'
    @storage = ENV['DATOMIC_STORAGE'] || 'free'
    @dbname = ENV['DATOMIC_NAME'] || "test-#{SecureRandom.uuid}"
    @connection_options = {
      :uri => @db_uri,
      :storage => @storage,
      :database => @dbname
    }
  end

  it "can connect to a Datomic database" do
    subject.connect(@connection_options)
    subject.connection.should be_a(Datomic::Client)
  end

  it_behaves_like "persistence API" do
    let(:model_class) { Mouse }

    before do
      Diametric::Persistence::REST.connect(@connection_options)
      Diametric::Persistence::REST.create_schemas
    end
  end
end
