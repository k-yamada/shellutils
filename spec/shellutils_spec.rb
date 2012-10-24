require 'spec_helper'
require 'tempfile'

module ShellUtils
  describe ShellUtils do
    describe ".sh" do
      it "exec shell command" do
        ShellUtils.sh "pwd"
      end
    end

    describe ".sudo" do
      #it "exec shell command" do
      #  ShellUtils.sudo "pwd"
      #end
    end

    describe ".add_config_text" do
      it "add config text" do
        config_text = <<-EOF
config1=value1
config2=value2
        EOF
        tf = Tempfile.open("tmp")
        ShellUtils.add_config(tf.path, "sample", config_text)
        result = tf.read
        result.should =~ /config1=value1/
        result.should =~ /config2=value2/
        tf.close!
      end
      
      it "overwrite config text" do
        config_text = <<-EOF
config3=value3
config4=value4
        EOF
        tf = Tempfile.open("tmp")
        initial_text = <<-EOF
## sample
config1=value1
config2=value2
## END
        EOF
        File.open(tf.path, "w") {|f| f.write initial_text}

        ShellUtils.add_config(tf.path, "sample", config_text)
        result = tf.read
        result.should_not =~ /config1=value1/
        result.should_not =~ /config2=value2/
        result.should =~ /config3=value3/
        result.should =~ /config4=value4/
        tf.close!
      end
    end
    
  end
end
