require 'spec_helper'

describe Log4r::YamlConfigurator do

  let!(:yml) { Log4r::YamlConfigurator }
  let!(:pre_config) { {
      "custom_levels" => [ "DEBUG", "DEBUG_FINE", "DEBUG_MEDIUM",
                          "DEBUG_GROSS", "DETAIL", "INFO", "WARN",
                          "ALARM", "ERROR", "FATAL"
                        ],
      "global" => { "level"=>"ALL" },
      "root" => { "level"=>"ALL" }
  } }
  let!(:outputters) { {
      "type" => "StdoutOutputter",
      "name" => "stdout",
      "level" => "DEBUG",
      "formatter" => {
                       "date_pattern" => "%y%m%d %H:%M:%S.%L",
                       "pattern" => "%d %p %C %l %M",
                       "type" => "PatternFormatter"
                      }
  } }
  let!(:logger) { {
      "name" => "root",
      "level" => "ALL",
      "outputters" => ["stdout"]
  } }

  describe "#load_yaml_files" do
    it "receives decode_pre_config" do
      yml.stub!(:decode_outputter)
      yml.should_receive(:decode_pre_config).with(pre_config)
      yml.load_yaml_files(['logging/configure-log4r.yml'])
    end

    it "receives decode_outputter" do
      yml.should_receive(:decode_outputter).with(outputters)
      yml.load_yaml_files(['logging/configure-log4r.yml'])
    end

    it "receives decode_logger" do
      yml.should_receive(:decode_logger).with(logger)
      yml.load_yaml_files(['logging/configure-log4r.yml'])
    end

    it "receives decode_logserver" do
      # because config-log4.yml hasn't a logserver option
      yml.should_not_receive(:decode_logserver)
      yml.load_yaml_files(['logging/configure-log4r.yml'])
    end
  end # #load_yaml_files

  describe "#decode_pre_config" do
    context "when pre_config is nil" do
      it "returns Log4r::RootLogger object" do
        yml.decode_pre_config(nil).kind_of?(Log4r::RootLogger).should be_true
      end
    end

    it "receives decode_custom_levels" do
      yml.should_receive(:decode_custom_levels).with(pre_config['custom_levels'])
      yml.decode_pre_config(pre_config)
    end

    it "receives global_config" do
      yml.should_receive(:global_config).with(pre_config['global'])
      yml.decode_pre_config(pre_config)
    end

    it "receives root_config" do
      yml.should_receive(:root_config).with(pre_config['root'])
      yml.decode_pre_config(pre_config)
    end

    it "receives decode_parameters" do
      yml.should_receive(:decode_parameters).with(pre_config['parameters'])
      yml.decode_pre_config(pre_config)
    end
  end # #decode_pre_config

  describe "#root_config" do
    context "when 'root' is nul" do
      it { yml.root_config(nil).should be_nil }
    end

    context "when 'level' is nul" do
      it "returns nil" do
        pre_config['root']['level'] = nil
        yml.root_config(pre_config['root']).should be_nil
      end
    end

    context "when 'level' is 'FATAL'" do
      it "root level equal five" do
        pre_config['root']['level'] = 'FATAL'
        yml.root_config(pre_config['root'])
        Log4r::Logger.root.level.should == 5
      end
    end
  end # #root_config

  describe "#decode_logger" do
    context "when logger name is 'root'" do
      it "receives decode_logger_common with root logger" do
        yml.should_receive(:decode_logger_common).with(Log4r::Logger.root, logger)
        yml.decode_logger(logger)
      end
    end # when logger name is 'root'

    context "when logger name is 'global'" do
      it "receives decode_logger_common with global logger" do
        logger['name'] = 'global'
        yml.should_receive(:decode_logger_common).with(Log4r::Logger.global, logger)
        yml.decode_logger(logger)
      end
    end # when logger name is 'global'

    context "when logger name isn't 'global' or 'root'" do
      it "receives decode_logger_common with global logger" do
        logger['name'] = 'new_name'
        new_log = Log4r::Logger.new('new_name')
        Log4r::Logger.stub!(:new).and_return(new_log)
        yml.should_receive(:decode_logger_common).with(new_log, logger)
        yml.decode_logger(logger)
      end
    end # when logger name isn't 'global' or 'root'
  end # #decode_logger
end # Log4r::YamlConfigurator