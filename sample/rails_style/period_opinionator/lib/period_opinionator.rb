require 'diffy'

require "period_opinionator/version"

module PeriodOpinionator

  def self.correct(text)
    fixed_text = conduct_processing(text)

    { body: fixed_text,
      diff: Diffy::Diff.new(text, fixed_text).to_s(:html_simple) }
  end

  def self.conduct_processing(text)
    text.gsub(/\.+/, "SUPER IMPORTANT PROCESS")
  end
end
