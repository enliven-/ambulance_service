module ApplicationHelper

  # encoding: UTF-8
  require 'cgi'
  require 'net/http'
  require 'open-uri'
  require 'nokogiri'
  require 'extlib/hash'

  class MyGoogleDirections

    attr_reader :status, :doc, :xml, :origin, :destination, :options

    @@base_url = 'http://maps.googleapis.com/maps/api/directions/xml'

    @@default_options = {
      :language => :en,
      :alternative => :true,
      :sensor => :false,
      :mode => :driving,
      :departure_time => Time.now.to_i,
      # :region => "in",
    }

    def initialize(origin, destination, opts=@@default_options)
      @origin = origin
      @destination = destination
      @options = opts.merge({:origin => transcribe(@origin), :destination => transcribe(@destination)})

      @url = @@base_url + '?' + @options.to_params
      @xml = open(@url).read
      @doc = Nokogiri::XML(@xml)
      @status = @doc.css('status').text
    end

    def xml_call
      @url
    end

    # an example URL to be generated
    #http://maps.google.com/maps/api/directions/xml?origin=St.+Louis,+MO&destination=Nashville,+TN&sensor=false&key=ABQIAAAAINgf4OmAIbIdWblvypOUhxSQ8yY-fgrep0oj4uKpavE300Q6ExQlxB7SCyrAg2evsxwAsak4D0Liiv

    def drive_time_in_minutes
      if @status != "OK"
        drive_time = Float::INFINITY
      else
        drive_time = @doc.css("duration value").last.text
        convert_to_minutes(drive_time)
      end
    end

    def drive_time_in_secs
      if @status != "OK"
        drive_time = Float::INFINITY
      else
        drive_time = @doc.css("duration value").last.text
        convert_to_secs(drive_time)
      end
    end

    def drive_time
      if @status != "OK"
        drive_time = Float::INFINITY
      else
        drive_time = @doc.css("duration value").last.text
        convert_to_hours(drive_time)
      end
    end      

    # the distance.value field always contains a value expressed in meters.
    def distance
      return @distance if @distance
      unless @status == 'OK'
        @distance = Float::INFINITY
      else
        @distance = @doc.css("distance value").last.text
      end
    end

    def distance_text
      return @distance_text if @distance_text
      unless @status == 'OK'
        @distance_text = "Inf km"
      else
        @distance_text = @doc.css("distance text").last.text
      end
    end

    def distance_in_miles
      if @status != "OK"
        distance_in_miles = Float::INFINITY
      else
        meters = distance
        distance_in_miles = (meters.to_f / 1610.22).round
        distance_in_miles
      end
    end

    def public_url
      "http://maps.google.com/maps?saddr=#{transcribe(@origin)}&daddr=#{transcribe(@destination)}&hl=#{@options[:language]}&ie=UTF8"
    end

    def steps
      if @status == 'OK'
        @doc.css('html_instructions').map {|a| a.text }
      else
        []
      end
    end

    private

      def convert_to_minutes(text)
        (text.to_f / 60).round
      end

      def convert_to_hours(text)
        (text.to_f / 60 / 60).round(2)
      end

      def convert_to_secs(text)
        text.to_f
      end

      def transcribe(location)
        # CGI::escape(location)
        location
      end

  end


end
