require 'spec_helper'

module Log4r
  describe RootLogger do

    subject { Log4r::RootLogger.instance }

    before do
      Log4r::RootLogger.instance_variable_set(:@singleton__instance__, nil)
      Log4r::GlobalLogger.instance_variable_set(:@singleton__instance__, nil)
      Logger::Repository.instance_variable_set(:@singleton__instance__, nil)
    end

    context "method implements the singleton" do
      context "when try to create a new object" do
        it "raises NoMethodError" do
         lambda { Log4r::RootLogger.new }.
             should raise_error(NoMethodError, "private method `new' called for Log4r::RootLogger:Class")
        end
      end # when try to create a new object

      context "when try to create a new object with instance method" do
        it "return single object" do
          subject.kind_of?(Log4r::RootLogger).should be_true
        end

        it "Logger::Repository['global'] includes instance object" do
          subject
          Logger::Repository['root'].should == subject
        end
      end # when try to create a new object with instance method
    end # method implements the singleton

    context "is_root?" do
      it "returns true" do
        subject.is_root?.should be_true
      end
    end # is_root?

    context "level=" do
      it "sets level name" do
        subject.level=3
        subject.instance_variable_get(:@level).should == 3
      end
    end # level=

    context "additive=" do
      it "does nothing" do
        subject.additive='foo'.should == 'foo'
      end
    end # additive=

    context "outputters=" do
      it "sets outputters" do
        subject.outputters=Log4r::Outputter.new('stdout', { :level => 3 })
        subject.instance_variable_get(:@outputters).
            first.kind_of?(Log4r::Outputter).should be_true
      end
    end # outputters=

    context "trace=" do
      it "sets trace" do
        subject.trace = true
        subject.instance_variable_get(:@trace).should be_true
      end
    end # trace=

    context "add" do
      it "added outputters" do
        subject.add(Log4r::Outputter.new('stdout', { :level => 3 })).
            first.kind_of?(Log4r::Outputter).should be_true
      end
    end # add

    context "remove" do
      it "removed outputters" do
        subject.add(Log4r::Outputter.new('stdout', { :level => 3 }))
        subject.remove('stdout')
        subject.instance_variable_get(:@outputters).should == []
      end
    end # remove
  end # RootLogger

  describe GlobalLogger do

    subject { Log4r::GlobalLogger.instance }

    context "method implements the singleton" do
      context "when try to create a new object" do
        it "raises NoMethodError" do
         lambda { Log4r::GlobalLogger.new }.
             should raise_error(NoMethodError, "private method `new' called for Log4r::GlobalLogger:Class")
        end
      end # when try to create a new object

      context "when try to create a new object with instance method" do
        it "return single object" do
          subject.kind_of?(Log4r::GlobalLogger).should be_true
        end

        it "Logger::Repository['global'] includes instance object" do
          subject
          Logger::Repository['global'].should == subject
        end
      end # when try to create a new object with instance method
    end # method implements the singleton

    context "is_root?" do
      it "returns true" do
        subject.is_root?.should be_true
      end
    end # is_root?

    context "level=" do
      it "sets level name" do
        subject.level=('debug')
        subject.instance_variable_get(:@level).should == "debug"
      end
    end # level=

    context "outputters=" do
      it "does nothing" do
        subject.outputters='foo'.should == 'foo'
      end
    end # outputters=

    context "trace=" do
      it "does nothing" do
        subject.trace='foo'.should == 'foo'
      end
    end # trace=

    context "additive=" do
      it "does nothing" do
        subject.additive='foo'.should == 'foo'
      end
    end # additive=

    context "add" do
      it "does nothing" do
        subject.add('foo').should be_nil
      end
    end # add

    context "remove" do
      it "does nothing" do
        subject.remove('foo').should be_nil
      end
    end # remove
  end # GlobalLogger
end # Log4r