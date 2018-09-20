require 'net/http'

DEFAULTS = {
    'RUNS_MIN' => 3,
    'RUNS_MAX' => 10,
    'SLEEP_MIN' => 1,
    'SLEEP_MAX' => 3,
}

COLORS = [
    'ff0000',
    '00ff00',
    '0000ff',
    '9542f4',
    'f441b8',
    'f49441',
    'f4eb41',
    'b8f441',
    '41f4e2',
]

NAMES = [
    'Clark',
    'Bruce',
    'Diana',
    'Hal',
    'Kyle',
    'John',
    'Barry',
    'Wally',
    'Victor',
    'Oliver',
    'Roy',
    'Jesse',
    'Ronnie',
]

class Client

    def initialize(host, port, client_id)
        @host = host
        @port = port
        @client_id = client_id
        @sender = Net::HTTP.new(host, port)
    end

    def change_color(color)
        params = {
            'hex' => color,
            'client_id' => @client_id
        }
        body = URI.encode_www_form(params)
        response = @sender.send_request('PUT', '/light/', body)
    end

    def turn_off()
        @sender.send_request('DELETE', '/light/')
    end
end

class Bot

    def initialize(host, port)
        bot_id = self.bot_id()
        @client = Client.new(host, port, bot_id)

        puts "Bot Configuration"
        puts "  Host: #{host}"
        puts "  Port: #{port}"
        puts "  Client ID: #{bot_id}"
        puts "  Runs Min: #{DEFAULTS['RUNS_MIN']}"
        puts "  Runs Max: #{DEFAULTS['RUNS_MAX']}"
        puts "  Sleep Min: #{DEFAULTS['SLEEP_MIN']}"
        puts "  Sleep Max: #{DEFAULTS['SLEEP_MAX']}"
    end

    def run()
        num_runs = rand(DEFAULTS['RUNS_MIN']..DEFAULTS['RUNS_MAX'])
        puts "Beginning bot loop for #{num_runs} iterations"

        num_runs.times do
            # Submit the random color change
            new_color = COLORS.sample
            puts "Setting color to: #{new_color}"
            @client.change_color(new_color)

            # Sleep until the next run
            sleep_time = rand(DEFAULTS['SLEEP_MIN']..DEFAULTS['SLEEP_MAX'])
            puts "Sleeping for #{sleep_time} seconds before next change"
            sleep(sleep_time)
        end

        if ENV.has_key?('OFF')
            puts "Shutting down the light"
            @client.turn_off()
        end
    end

    def bot_id()
        suffix = (0...6).map { ('a'..'z').to_a[rand(26)] }.join
        name = NAMES.sample
        bot_id = "#{name}-#{suffix}"
        return bot_id
    end

end

if __FILE__ == $0
    ['HOST', 'PORT'].each do |var_name|
        if not ENV.has_key?(var_name)
            puts "The environment variable #{var_name} must be set"
            exit
        end
    end

    # Environment overrides
    DEFAULTS.keys.each do |key|
        if ENV.has_key?(key)
            DEFAULTS[key] = ENV[key].to_i
        end
    end

    b = Bot.new(ENV['HOST'], ENV['PORT'])
    b.run()
end