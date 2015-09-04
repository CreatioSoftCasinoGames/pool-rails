class Api::V1::XpBallPottedConsecutivesController < Api::V1::ApplicationController

def ball_potted_consecutive
	 @ball_potted = XpBallConsecutive.all
@xp = XpBallPottedOnWinning.all
render json: { ball_potted: @ball_potted, xp: @xp}
end

end