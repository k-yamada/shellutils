require 'spec_helper'

module ShellUtils
  describe ShellUtils do
    it "shoudl exec shell command" do
      ShellUtils.sh "pwd"
    end

    it "shoudl exec shell command" do
      ShellUtils.sudo "pwd"
    end
    
  end


end
