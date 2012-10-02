require 'spec_helper'

module Log4r
  describe Logger do

    before do
      Log4r::RootLogger.instance_variable_set(:@singleton__instance__, nil)
      Log4r::GlobalLogger.instance_variable_set(:@singleton__instance__, nil)
      Logger::Repository.instance_variable_set(:@singleton__instance__, nil)
    end

    describe "#root" do
      it "returns Log4r::RootLogger object" do
        Log4r::Logger.root.kind_of?(Log4r::RootLogger).should be_true
      end
    end # #root

    describe "#global" do
      it "returns Log4r::GlobalLogger object" do
        Log4r::Logger.global.kind_of?(Log4r::GlobalLogger).should be_true
      end
    end # #global

    describe "#[]" do
      context "when _fullname=='root'" do
        it "returns Log4r::RootLogger object" do
          Log4r::Logger.[]('root').kind_of?(Log4r::RootLogger).should be_true
        end
      end # when _fullname=='root'

      context "when _fullname=='global'" do
        it "returns Log4r::globalLogger object" do
          Log4r::Logger.[]('global').kind_of?(Log4r::GlobalLogger).should be_true
        end
      end # when _fullname=='global'

      context "when _fullname isn't 'root' or 'global'" do
        it "returns object from Logger::Repository" do
          Logger::Repository['string'] = 1
          Log4r::Logger.[]('string').should == 1
        end
      end # when _fullname isn't 'root' or 'global'
    end # #[]

    describe Logger::LoggerFactory do

      let!(:log) {  Log4r::Logger.new('temp') }

      describe "#define_methods" do
        it "receives set_log method once" do
          Log4r::Logger['global'].instance_variable_set(:@level, 5)
          Logger::LoggerFactory.should_receive(:set_log)
          Logger::LoggerFactory.define_methods(log)
        end
      end # #define_methods

      describe "#set_log" do
        it "creates 'temp' method for logging" do
          Logger::LoggerFactory.set_log(log, 'TEMP')
          log.methods.select{ |x| x == :temp }.should have(1).item
        end
      end # #set_log

    end # Logger::LoggerFactory
  end # Logger
end # Log4r