module Traveloka
	class Flight
		SERIALIZEABLE = [:flight_number, :airline_code, :publish_fare, :takeoff_at , :landing_at , :promo, :origin, :destination]
		attr_reader *SERIALIZEABLE
		attr_reader :search_object, :source, :flight_set
		def initialize flight_set , index = 0
			
			@flight_set = flight_set
			@raw_source = @flight_set.raw_source
			@flight_collection = @flight_set.flight_collection
			@search_object = @flight_collection.search_object
			
			@source = @raw_source['CFR'][index]
			build!
		end

		def build!
			SERIALIZEABLE.each do |v|
				instance_variable_set("@#{v}".to_sym, send("get_#{v}".to_sym))
			end
		end

		def get_flight_number
		end
		
		def get_airline_code
		end
		
		def get_publish_fare
			str = source["SEG"][0]
			str.split(".")[5].to_i
		end
		
		def get_takeoff_at
			str_trg = source['SEG'][0]
			md = str_trg.match /[A-Z]+-\d+\.[A-Z]+.[A-Z]+.(?<target>\d+.\d+)./
			"#{search_object.flight_date.strftime("%d-%m-%Y")} #{md[:target].gsub('.', ':')}".to_time(:local)
		end

		def get_landing_at
			str_trg = source['SEG'][0]
			md = str_trg.match /[A-Z]+-\d+\.[A-Z]+.[A-Z]+.\d+.\d+\.(?<target>\d+.\d+)./
			"#{search_object.flight_date.strftime("%d-%m-%Y")} #{md[:target].gsub('.', ':')}".to_time(:local)

		end

		def get_origin
			source['AIR'].split(".").first
		end
		
		def get_destination
			source['AIR'].split(".").last			
		end

		def get_promo
		end
	end

end