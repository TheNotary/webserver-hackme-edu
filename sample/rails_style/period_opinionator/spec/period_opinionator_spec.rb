require 'spec_helper'

describe PeriodOpinionator do

  before :each do
    @un_corrected_string = "This is a sentence.  Typography is important to get correct.    So is writing code like `this.powerful(function)`"
    @corrected_string = "This is a sentence. Typography is important to get correct. So is writing code like `this.powerful(function)`"

    @expected_diff = "<div class=\"diff\">\n  <ul>\n    <li class=\"del\"><del>This is a sentence.  Typography is important to get correct.    So is writing code like `this.powerful(function)`</del></li>\n\n    <li class=\"ins\"><ins>This is a sentence. Typography is important to get correct. So is writing code like `this.powerful(function)`</ins></li>\n\n  </ul>\n</div>\n"
  end

  it 'has a version number' do
    expect(PeriodOpinionator::VERSION).not_to be nil
  end

  it 'exposes the corrected string of text' do
    result = PeriodOpinionator.correct(@un_corrected_string)

    expect(result[:body]).to eq(@corrected_string)
  end

  it 'exposes a diff of the original and corrected strings' do
    result = PeriodOpinionator.correct(@un_corrected_string)

    expect(result[:diff]).to eq(@expected_diff)
  end
  
  it 'ensure remove_extra_spaces_after_period is a module level method' do
    result = PeriodOpinionator.remove_extra_spaces_after_period(@un_corrected_string)

    expect(result).to eq(@corrected_string)
  end
end
