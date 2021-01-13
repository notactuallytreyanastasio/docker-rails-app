require 'rails_helper'

RSpec.describe Dog, type: :model do
  describe "attributes" do
    context "setters and getters" do
      it "can set/get a name" do
        subject.name = "artemis"
        expect(subject.name).to eq "artemis"
      end

      it "can set/get a breed" do
        subject.breed = "pug"
        expect(subject.breed).to eq "pug"
      end

      it "can set/get a age" do
        subject.age = 1
        expect(subject.age).to eq 1
      end
    end
  end
end
