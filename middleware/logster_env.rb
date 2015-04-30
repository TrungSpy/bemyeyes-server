
module BME
  class LogsterEnv 
    def initialize(app)
      @app = app
    end
    def call(env)
      Thread.current[Logster::Logger::LOGSTER_ENV] = env
       @app.call(env)
    end
  end
end

