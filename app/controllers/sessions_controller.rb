class SessionsController < ApplicationController
	def create
		if session[:access_token].nil?
			redirect_to 'https://www.strava.com/oauth/authorize?client_id=9388&response_type=code&redirect_uri=http://localhost:3000/token_exchange&scope=write&state=mystate&approval_prompt=force'
		else
			redirect_to action: :get_token
		end
	end

	def get_token
		if session[:access_token].nil?
			code = params[:code]			
			resp = RestClient.post 'https://www.strava.com/oauth/token', client_id: 9388, client_secret: '00012a020dcbe8d72c4a74a66df4489e2307dcdc', code: code	

			resp_json = JSON.parse(resp)						
			access_token = resp_json["access_token"]				
			athlete = resp_json["athlete"]						

			@cyclist = Cyclist.find_by(strava_id: athlete['id'])
			if @cyclist.nil?
			    gender = 'Male' if athlete['sex'] == 'M'
			    gender = 'Female' if athlete['sex'] == 'F'

				@cyclist = Cyclist.create access_token: access_token, name: athlete['firstname'] + ' ' + athlete['lastname'], strava_id: athlete['id'], gender: gender, strava_athlete_url: 'https://www.strava.com/athletes/' + athlete['id'].to_s
			else
				@cyclist.update access_token: access_token
			end
					
			session[:cyclist_name] = athlete['firstname'] + ' ' + athlete['lastname']
			session[:access_token] = access_token
			#print "=====#{access_token}====="
			session[:token_type] = resp_json["token_type"]
			session[:athlete_id] = resp_json["athlete_id"]
		end
		render template: 'statics/home'
	end

	def deauth		
		unless session[:access_token].nil?
			
			auth_param =  session[:token_type].to_s + ' ' + session[:access_token]
			#print "=======#{auth_param.class}==========="

			access_token = RestClient.post "https://www.strava.com/oauth/deauthorize", { 'x' => 1 }.to_json, :content_type => :json, :accept => :json, :Authorization => auth_param

			@cyclist = Cyclist.find_by(strava_id: session[:athlete_id])	
			@cyclist.update access_token: nil if @cyclist

			session[:cyclist_name] = nil
			session[:access_token] = nil
			session[:token_type] = nil
			session[:athlete_id] = nil
		end
		render template: 'statics/home'
		#redirect root_path
	end
end

=begin

client id - 9546
client secret - 08ea0212e129f308e6ab3875f5443df1cae368e7

{"access_token":"0bc3669fc42a842ca21188e63f461377c207d05e","token_type":"Bearer","athlete":{"id":12513647,"username":"louis_dunn","resource_state":3,"firstname":"Louis","lastname":"Dunn","profile_medium":"avatar/athlete/medium.png","profile":"avatar/athlete/large.png","city":"Columbus","state":"Ohio","country":"United States","sex":"M","friend":null,"follower":null,"premium":false,"created_at":"2015-12-21T09:24:05Z","updated_at":"2016-01-10T04:47:59Z","badge_type_id":0,"follower_count":0,"friend_count":0,"mutual_friend_count":0,"athlete_type":0,"date_preference":"%m/%d/%Y","measurement_preference":"feet","email":"louisdunn51@gmail.com","ftp":null,"weight":null,"clubs":[],"bikes":[],"shoes":[]}}

  create_table "cyclists", force: :cascade do |t|
    t.string   "name"
    t.integer  "strava_id"
    t.string   "gender"
    t.string   "age_range"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "strava_athlete_url"
  end

=end