describe Fastlane::Actions::FivIncrementBuildNoAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The fiv_increment_build_no plugin is working!")

      Fastlane::Actions::FivIncrementBuildNoAction.run(nil)
    end
  end
end
