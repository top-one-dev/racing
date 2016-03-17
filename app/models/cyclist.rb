class Cyclist < ActiveRecord::Base
	default_scope {order('id')}

	has_many :stage_efforts, dependent: :destroy	
	has_many :rosters, dependent: :destroy	
	has_many :races, through: :rosters

  validates :strava_athlete_url, format: {with: /\A(https|http):\/\/www.strava.com\/athletes\/\d+\z/ , message: "It's incorrect althlete url"}

	include StravaClient

	before_save :get_cyclist_info

  private 
    def get_cyclist_info
      match_result = /\d+\z/.match(self.strava_athlete_url)
      self.strava_id = match_result[0]
      print "strava_id: #{self.strava_id}"
      if self.strava_id
        begin          
        	result = strava_client(self.access_token).retrieve_current_athlete
        rescue
        	print "strava_client retrieve_current_athlete error"
        	self.name = ''
    	    self.gender = ''
          self.ftp = 0
        else
        	self.name = result['firstname'] + ' ' + result['lastname']
    	    self.gender = 'Male' if result['sex'] == 'M'
    	    self.gender = 'Female' if result['sex'] == 'F'
          self.ftp = result['ftp'].to_i
          puts result['ftp']
    	  end
      end
    end
end