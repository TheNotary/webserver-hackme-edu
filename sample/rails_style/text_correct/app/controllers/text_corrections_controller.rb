class TextCorrectionsController < ApplicationController
  def correct
    text = params[:text]

    # binding.pry

    correction = PeriodOpinionator.correct(text)

    render json: { body: correction[:body],
                   diff: correction[:diff].html_safe }
  end
end
