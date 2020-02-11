describe Fastlane::Actions::FivethreeIonicAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with(
        'The fivethree_ionic plugin is working!'
      )

      Fastlane::Actions::FivethreeIonicAction.run(nil)
    end
  end
end
