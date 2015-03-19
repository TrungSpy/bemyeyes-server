require 'language_list'
class BMELanguage < Struct.new(:name, :iso_639_1, :iso_639_3)
end
class App < Sinatra::Base
  register Sinatra::Namespace
  namespace '/languages' do
    get '/common' do
      LanguageList::COMMON_LANGUAGES.reject{|language|!( language.living?)}.map{|lan| BMELanguage.new lan.name, lan.iso_639_1}.to_json
    end
    
     get '/living' do
      LanguageList::LIVING_LANGUAGES.map{|lan| BMELanguage.new lan.name.force_encoding("utf-8"),  lan.iso_639_1 ||  lan.iso_639_3, lan.iso_639_3}.to_json
    end

  end
end
