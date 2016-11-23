class SessionsController < ApplicationController
	
	skip_before_action :require_oauth

	def create
		if session[:access_token].nil?
			redirect_uri = Rails.application.secrets[:redirect_url]			
			client_id = Rails.application.secrets[:strava_client_id]
			redirect_to "https://www.strava.com/oauth/authorize?client_id=#{client_id}&response_type=code&redirect_uri=#{redirect_uri}/token_exchange&scope=write&state=mystate&approval_prompt=force"
		else
			redirect_to action: :get_token
		end
	end

	def get_token
		if session[:access_token].nil?
			code = params[:code]			
			client_id = Rails.application.secrets[:strava_client_id]	
			client_secret = Rails.application.secrets[:strava_client_secret]	
			begin
				resp = RestClient.post 'https://www.strava.com/oauth/token', client_id: client_id, client_secret: client_secret, code: code
			rescue
				puts "The request failed - https://www.strava.com/oauth/token client_id: #{client_id} client_secret: #{client_secret} code: #{code}"
			else
				resp_json = JSON.parse(resp)
				access_token = resp_json["access_token"]				
				athlete = resp_json["athlete"]

				gender = "Male"
			    gender = "Male" if athlete["sex"] == "M"
			    gender = "Female" if athlete["sex"] == "F"
			    name = athlete["firstname"] + " " + athlete["lastname"]
			    email = athlete["email"]					

				@cyclist = Cyclist.find_by(strava_id: athlete['id'])			
				if @cyclist.nil?					
					@cyclist = Cyclist.create access_token: access_token, name: name, strava_id: athlete['id'], gender: gender, strava_athlete_url: 'https://www.strava.com/athletes/' + athlete['id'].to_s
				else
					@cyclist.update access_token: access_token, name: name, strava_id: athlete['id'], gender: gender, email: email, strava_athlete_url: 'https://www.strava.com/athletes/' + athlete['id'].to_s
				end

				session[:cyclist_name] = athlete['firstname'] + ' ' + athlete['lastname']
				session[:access_token] = access_token
				#print "=====#{access_token}====="
				session[:token_type] = resp_json["token_type"]
				session[:athlete_id] = resp_json["athlete_id"]
				session[:cyclist_id] = @cyclist.id
			end
		end
		# @cyclist = Cyclist.find(session[:cyclist_id]) if @cyclist.nil?
		if session[:cyclist_id] == 270
			session[:cyclist_id] = 4
			session[:cyclist_name] = 'Tom Jean'
		end 
		unless session[:access_token].nil?
			if session[:cyclist_id].nil? or session[:cyclist_name] == ''
				session[:access_token] = nil
			else				
				@cyclist = Cyclist.find(session[:cyclist_id]) if @cyclist.nil?
				@available_races = available_races()
				Race.all.each do |race|
					today = Time.now.to_date
					if race.stages.last.close_date >= today
						if race.rosters.find_by(cyclist_id: session[:cyclist_id]) then redirect_to race_result_path(race_id: race) end
					end
				end
				# @available_races.each do |race| 
				# 	if race.rosters.find_by(cyclist_id: session[:cyclist_id]) then redirect_to race_result_path(race_id: race) end 
				# end
				@cyclist_result = cyclist_result(@cyclist, nil)
			end			
		end
		# render template: 'statics/home'
	end

	def race_result
		if session[:access_token].nil? or params[:race_id].nil?
			redirect_to action: :get_token
		else
			@race = Race.find(params[:race_id])
			@cyclist = Cyclist.find(session[:cyclist_id])
			@roster = @race.rosters.find_by(cyclist_id: session[:cyclist_id])
			# @cyclist_result = cyclist_result(@cyclist, @race)
			@cyclist_result = cyclist_result(@cyclist, nil)
		end
	end

	def deauth		
		unless session[:access_token].nil?
			
			auth_param =  session[:token_type].to_s + ' ' + session[:access_token]
			#print "=======#{auth_param.class}==========="
			begin
				access_token = RestClient.post "https://www.strava.com/oauth/deauthorize", { 'x' => 1 }.to_json, :content_type => :json, :accept => :json, :Authorization => auth_param
			rescue
				session[:cyclist_name] = nil				
			end

			@cyclist = Cyclist.find_by(strava_id: session[:athlete_id])	
			@cyclist.update access_token: nil if @cyclist

			session[:cyclist_name] = nil
			session[:access_token] = nil
			session[:token_type] = nil
			session[:athlete_id] = nil
			session[:cyclist_id] = nil
		end
		# render template: 'statics/home'
		redirect_to root_path
	end

	def reset_token
		ssession[:access_token] = nil
		redirect_to root_path
	end
end