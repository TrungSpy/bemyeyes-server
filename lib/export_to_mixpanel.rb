require_relative '../models/init.rb'
require 'mixpanel-ruby'

class ExportToMixpanel
  def initialize
    $config = YAML.load_file('config/config.yml')
    $tracker = Mixpanel::Tracker.new($config['mixpanel']['token'])
  end

  def Export
    User.find_each(role:"helper") do |user| 
      $tracker.people.set(user._id, {
        '$first_name'       => user.first_name,
        '$last_name'        => user.last_name,
        '$email'            => user.email,
        '$city' => "",
        '$country' => "",
        '$region' => "",
        'Role'    => user.role,
        "FacebookUser" => user.is_external_user,
        "UtcOffset" => user.utc_offset,
        "languages" => user.languages,
        "user_id" => user.user_id,
        "blocked" => user.blocked,
        "inactive" => user.inactive,
        "expiry_time"=>user.expiry_time,
        "created_at" => user.created_at,
        "updated_at" => user.updated_at,
      });
      puts '.'
    end
  end
end

